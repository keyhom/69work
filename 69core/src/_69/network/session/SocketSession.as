/*
 * Copyright (c) 2013 keyhom.c@gmail.com.
 *
 * This software is provided 'as-is', without any express or implied warranty.
 * In no event will the authors be held liable for any damages arising from
 * the use of this software.
 *
 * Permission is granted to anyone to use this software for any purpose
 * excluding commercial applications, and to alter it and redistribute it
 * freely, subject to the following restrictions:
 *
 *     1. The origin of this software must not be misrepresented; you must not
 *     claim that you wrote the original software. If you use this software
 *     in a product, an acknowledgment in the product documentation would be
 *     appreciated but is not required.
 *
 *     2. Altered source versions must be plainly marked as such, and must not
 *     be misrepresented as being the original software.
 *
 *     3. This notice may not be removed or altered from any source
 *     distribution.
 */

package _69.network.session {

import _69.core.api.DefaultFuture;
import _69.core.api.ILifecycle;
import _69.network.api.IWriteRequest;
import _69.network.api.IoChainController;
import _69.network.api.IoClient;
import _69.network.api.IoFilter;
import _69.network.api.IoHandler;
import _69.network.api.IoSession;

import flash.errors.IOError;
import flash.errors.IllegalOperationError;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.net.Socket;
import flash.utils.ByteArray;

/**
 * The <tt>SocketSession</tt> implements the <tt>IoSession</tt> represents to use the AS3 <tt>Socket</tt> providing the connection operation.
 *
 * @author keyhom
 */
public dynamic class SocketSession implements IoSession, IoChainController, ILifecycle {

    /** @private */
    private static const _EMPTY_FILTERS:Vector.<IoFilter> = new Vector.<IoFilter>(0, true);
    /** @private */
    private static const _READ_OPS:int = 1 << 1;
    /** @private */
    private static const _WRITE_OPS:int = 1 << 2;
    /** @private */
    private const _id:Number = nextSessionId();
    /** @private */
    private static var _EMPTY_HANDLER:IoHandler;
    /** @private */
    private static var _INSTANCE_ID:Number = 0;

    /** @private */
    private static function nextSessionId():Number {
        return ++_INSTANCE_ID;
    }

    /**
     * Creates a SocketSession instance.
     */
    public function SocketSession(service:IoClient, socket:Socket, connectFuture:DefaultFuture) {
        this._service = service;
        this._socket = socket;
        this._connectFuture = connectFuture;

        init();
    }

    /** @private */
    private var _ops:int = 0;
    /** @private */
    private var _socket:Socket;
    /** @private */
    private var _disposed:Boolean = false;
    /** @private */
    private var _readChainPos:int = 0;
    /** @private */
    private var _writeChainPos:int = 0;
    /** @private */
    private var _connectFuture:DefaultFuture;
    /** @private */
    private var _initialized:Boolean = false;

    /** @private */
    private var _host:String;

    public function get host():String {
        return _host;
    }

    /** @private */
    private var _port:uint;

    public function get port():uint {
        return _port;
    }

    /** @private */
    private var _service:IoClient;

    /**
     * @inheritDoc
     */
    public function get service():IoClient {
        return _service;
    }

    /**
     * @inheritDoc
     */
    public function get id():Number {
        return _id;
    }

    /**
     * @inheritDoc
     */
    public function get connected():Boolean {
        if (_socket)
            return _socket.connected;
        return false;
    }

    /**
     * The <tt>IoFilter</tt>s associated with this session.
     */
    protected function get filters():Vector.<IoFilter> {
        if (_service && _service.filters) {
            return _service.filters;
        }
        return _EMPTY_FILTERS;
    }

    /**
     * The <tt>IoHandler</tt> associated with this session.
     */
    protected function get handler():IoHandler {
        if (_service && _service.handler) {
            return _service.handler;
        }
        return _EMPTY_HANDLER;
    }

    private function fireMessageSent(message:Object):void {
        var chain:Vector.<IoFilter> = filters;
        for each(var f:IoFilter in chain) {
            f.messageSent(this, message);
        }

        handler.messageSent(this, message);
    }

    /** @private */
    protected function read(bytes:ByteArray):void {
        if (filters.length) {
            _ops |= _READ_OPS;
            _readChainPos = 0;
            // filters[0].messageReceived(this, bytes, this);
            callNextFilter(this, bytes);
        } else { // Dispatch to the I/O handler directly.
            handler.messageReceived(this, bytes);
        }
    }

    /**
     * @inheritDoc
     */
    public function write(message:Object):void {
        if (message) {
            if (message is ByteArray) {
                writeDirect(message as ByteArray);

                fireMessageSent(message);
            } else {
                if (filters.length) {
                    _ops |= _WRITE_OPS;
                    _writeChainPos = filters.length > 0 ? filters.length - 1 : 0;
                    var request:DefaultWriteRequest = new DefaultWriteRequest(message);
                    request.$69internal::setFuture(new DefaultFuture);
                    callNextFilter(this, request);
                }
            }
        }
    }

    /**
     * @inheritDoc
     */
    public function close():void {
        if (_socket && _socket.connected) {
            _socket.close();
            _socket.dispatchEvent(new Event(Event.CLOSE));
        }
    }

    /**
     * @inheritDoc
     */
    public function callNextFilter(session:IoSession, message:Object):void {
        if (_WRITE_OPS == (_ops & _WRITE_OPS)) { // Process write.
            if (_writeChainPos < 0) {
                // end of chain.
                var msg:Object = message is IWriteRequest ? IWriteRequest(message).message : message;
                if (msg is ByteArray) {
                    writeDirect(msg as ByteArray);

                    fireMessageSent(message is IWriteRequest ? IWriteRequest(message).originMessage : message);
                } else {
                    fireErrorCaught(new IllegalOperationError("Can't write with unencoded message."));
                }

                _ops &= ~_WRITE_OPS;
                _writeChainPos = filters.length > 0 ? filters.length - 1 : 0;
            } else if (_writeChainPos >= 0 && filters.length) {
                filters[_writeChainPos--].messageWritting(session, message as IWriteRequest, this);
            }
        }

        if (_READ_OPS == (_ops & _READ_OPS)) { // Process read.
            if (_readChainPos > filters.length - 1) {
                // end of chain.
                _ops &= ~_READ_OPS;
                _readChainPos = 0;

                handler.messageReceived(session, message);
            } else if (_readChainPos <= filters.length - 1) {
                filters[_readChainPos++].messageReceived(session, message, this);
            }
        }
    }

    /**
     * @inheritDoc
     */
    public function init():void {
        if (_disposed || _initialized)  return;

        // First construct the default empty handler.
        if (null == _EMPTY_HANDLER) {
            _EMPTY_HANDLER = new AnonymousHandler();
        }

        if (_socket) {
            if (!_socket.hasEventListener(Event.CONNECT))
                _socket.addEventListener(Event.CONNECT, _onConnect);
            if (!_socket.hasEventListener(Event.CLOSE))
                _socket.addEventListener(Event.CLOSE, _onClose);
            if (!_socket.hasEventListener(SecurityErrorEvent.SECURITY_ERROR))
                _socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, _onSecurityError);
            if (!_socket.hasEventListener(ProgressEvent.SOCKET_DATA))
                _socket.addEventListener(ProgressEvent.SOCKET_DATA, _onSocketData);
            if (!_socket.hasEventListener(IOErrorEvent.IO_ERROR))
                _socket.addEventListener(IOErrorEvent.IO_ERROR, _onIoError);

        }

        // Fires the session created event to the filters.
        _readChainPos = 0;
        _writeChainPos = filters.length - 1;

        var chain:Vector.<IoFilter> = this.filters;
        for each(var f:IoFilter in chain) {
            f.sessionCreated(this);
        }

        // Fires the session created event to the handler.
        handler.sessionCreated(this);

        _initialized = true;
    }

    /**
     * @inheritDoc
     */
    public function destory():void {
        if (_disposed) return;

        // Removes this session from the managedSessions.
        if (_service && _service.managedSessions) {
            delete _service.managedSessions[id];

            var s:Object;
            for (s in _service.managedSessions) {
                if (null != s)
                    break;
            }

            if (null != s) {
                _service.dispose();
            }
        }

        if (connected)
            close();

        // Clean up all attributes.
        for (var k:String in this) {
            delete this[k];
        }

        if (_socket) {
            if (_socket.hasEventListener(Event.CONNECT))
                _socket.removeEventListener(Event.CONNECT, _onConnect);
            if (_socket.hasEventListener(Event.CLOSE))
                _socket.removeEventListener(Event.CLOSE, _onClose);
            if (_socket.hasEventListener(ProgressEvent.SOCKET_DATA))
                _socket.removeEventListener(ProgressEvent.SOCKET_DATA, _onSocketData);
            if (_socket.hasEventListener(IOErrorEvent.IO_ERROR))
                _socket.removeEventListener(IOErrorEvent.IO_ERROR, _onIoError);
            if (_socket.hasEventListener(SecurityErrorEvent.SECURITY_ERROR))
                _socket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, _onSecurityError);
        }

        _socket = null;
        _service = null;
        _disposed = true;
    }

    /**
     * @inheritDoc
     */
    public function toString(includeRemotePeer:Boolean = false):String {
        var s:String = "SocketSession#" + id;
        if (includeRemotePeer) {
            s += ' { host: ' + host + ', port: ' + port + ' }';
        }
        return s;
    }

    /**
     * Writes the specified byte-array directly.
     *
     * @param bytes The byte-array to write.
     */
    protected function writeDirect(bytes:ByteArray):void {
        if (bytes && connected) {
            _socket.writeBytes(bytes, 0, bytes.length);

            _socket.flush();
        }
    }


    //----------------------------------------------------------------------------
    //
    // Event Handlers
    //
    //----------------------------------------------------------------------------

    private function fireErrorCaught(error:Error):void {
        // Fires the error caught to the filters.
        var chain:Vector.<IoFilter> = filters;
        for each (var f:IoFilter in chain) {
            f.errorCaught(this, error);
        }

        // Fires the error caught to the handler.
        handler.errorCaught(this, error);
    }

    /** @private */
    private function _onConnect(e:Event):void {
        // Make sure this event will never be call du.
        Socket(e.currentTarget).removeEventListener(Event.CONNECT, _onConnect);

        // Flush the socket.
        _socket.flush();

        // Releases the connect future if absently.
        if (_connectFuture) {
            _connectFuture.complete(this);
            _connectFuture = null;
        }

        // Fires the session opens to the filters.
        var chain:Vector.<IoFilter> = filters;
        for each(var f:IoFilter in chain) {
            f.sessionOpened(this);
        }

        // Fires the session opens to the handler.
        handler.sessionOpened(this);
    }

    /** @private */
    private function _onClose(e:Event):void {
        Socket(e.currentTarget).removeEventListener(Event.CLOSE, _onClose);

        if (_connectFuture) {
            _connectFuture.complete(this);
            _connectFuture = null;
        }

        // Fires the closed event to the filters.
        var chain:Vector.<IoFilter> = this.filters;
        for each (var f:IoFilter in chain) {
            f.sessionClosed(this);
        }

        // Fires the closed event to the handler.
        handler.sessionClosed(this);

        // Destory this session.
        destory();
    }

    /** @private */
    private function _onSecurityError(e:SecurityErrorEvent):void {
        Socket(e.currentTarget).removeEventListener(SecurityErrorEvent.SECURITY_ERROR, _onSecurityError);

        if (_connectFuture) {
            _connectFuture.complete(e);
            _connectFuture = null;
        }

        var error:SecurityError = new SecurityError(e.text, e.errorID);
        fireErrorCaught(error);

        destory();
    }

    /** @private */
    private function _onIoError(e:IOErrorEvent):void {
        var error:IOError = new IOError(e.text, e.errorID);
        fireErrorCaught(error);
    }

    /** @private */
    private function _onSocketData(e:ProgressEvent):void {
        if (_socket.connected && _socket.bytesAvailable) {
            var bytes:ByteArray = new ByteArray();
            _socket.readBytes(bytes, 0, _socket.bytesAvailable);

            read(bytes);
        }
    }

    /** @private */
    $69internal function setHost(host:String):void {
        this._host = host;
    }

    /** @private */
    $69internal function setPort(port:int):void {
        this._port = port;
    }
}
}

import _69.network.api.IoHandler;
import _69.network.api.IoSession;

/** @private */
class AnonymousHandler implements IoHandler {

    /**
     * Creates a AnonymousHandler instance.
     */
    public function AnonymousHandler() {
    }

    /**
     * @inheritDoc
     */
    public function sessionCreated(session:IoSession):void {
    }

    /**
     * @inheritDoc
     */
    public function sessionOpened(session:IoSession):void {
    }

    /**
     * @inheritDoc
     */
    public function sessionClosed(session:IoSession):void {
    }

    /**
     * @inheritDoc
     */
    public function messageSent(session:IoSession, message:Object):void {
    }

    /**
     * @inheritDoc
     */
    public function messageReceived(session:IoSession, message:Object):void {
    }

    /**
     * @inheritDoc
     */
    public function errorCaught(session:IoSession, e:Error):void {
    }

}
namespace $69internal = "http://p.keyhom.org/69/";
// vim:ft=as3
