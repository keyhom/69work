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

package _69.net {

import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.net.Socket;

/**
 * This class allows TCP socket connections through HTTP proxies in accordance with
 * RFC 2817:
 *
 * ftp://ftp.rfc-editor.org/in-notes/rfc2817.txt
 *
 * It can also be used to make direct connections to a destination, as well. If you
 * pass the host and port into the constructor, no proxy will be used. You can also
 * call connect, passing in the host and the port, and if you didn't set the proxy
 * info, a direct connection will be made. A proxy is only used after you have called
 * the setProxyInfo function.
 *
 * The connection to and negotiation with the proxy is completely hidden. All the
 * same events are thrown whether you are using a proxy or not, and the data you
 * receive from the target server will look exact as it would if you were connected
 * to it directly rather than through a proxy.
 *
 * @author Christian Cantrell
 *
 **/
public class RFC2817Socket extends Socket {

    /**
     * Construct a new RFC2817Socket object. If you pass in the host and the port,
     * no proxy will be used. If you want to use a proxy, instantiate with no
     * arguments, call setProxyInfo, then call connect.
     **/
    public function RFC2817Socket(host:String = null, port:int = 0) {
        super(host, port);
    }

    /** @private */
    private var buffer:String = String('');
    /** @private */
    private var deferredEventHandlers:Object = {};
    /** @private */
    private var host:String = null;
    /** @private */
    private var port:int = 0;
    /** @private */
    private var proxyHost:String = null;
    /** @private */
    private var proxyPort:int = 0;

    /**
     * @inheritDoc
     */
    override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0.0, useWeakReference:Boolean = false):void {
        if (type == Event.CONNECT || type == ProgressEvent.SOCKET_DATA) {
            this.deferredEventHandlers[type] = {listener: listener, useCapture: useCapture, priority: priority, useWeakReference: useWeakReference};
        } else {
            super.addEventListener(type, listener, useCapture, priority, useWeakReference);
        }
    }

    /**
     * @inheritDoc
     *
     * Connect to the specified host over the specified port. If you want your
     * connection proxy, call the setProxyInfo function first.
     **/
    override public function connect(host:String, port:int):void {
        if (this.proxyHost == null) {
            this.redirectConnectEvent();
            this.redirectSocketDataEvent();
            super.connect(host, port);
        }
        else {
            this.host = host;
            this.port = port;
            super.addEventListener(Event.CONNECT, this.onConnect);
            super.addEventListener(ProgressEvent.SOCKET_DATA, this.onSocketData);
            super.connect(this.proxyHost, this.proxyPort);
        }
    }

    /**
     * Set the proxy host and port number. Your connection will only proxied if
     * this function has been called.
     **/
    public function setProxyInfo(host:String, port:int):void {
        this.proxyHost = host;
        this.proxyPort = port;

        var deferredSocketDataHandler:Object = this.deferredEventHandlers[ProgressEvent.
                SOCKET_DATA];
        var deferredConnectHandler:Object = this.deferredEventHandlers[Event.
                CONNECT];

        if (deferredSocketDataHandler != null) {
            super.removeEventListener(ProgressEvent.SOCKET_DATA, deferredSocketDataHandler.
                    listener, deferredSocketDataHandler.useCapture);
        }

        if (deferredConnectHandler != null) {
            super.removeEventListener(Event.CONNECT, deferredConnectHandler.
                    listener, deferredConnectHandler.useCapture);
        }
    }

    private function redirectConnectEvent():void {
        super.removeEventListener(Event.CONNECT, onConnect);
        var deferredEventHandler:Object = this.deferredEventHandlers[Event.CONNECT];
        if (deferredEventHandler != null) {
            super.addEventListener(Event.CONNECT, deferredEventHandler.listener,
                    deferredEventHandler.useCapture, deferredEventHandler.
                            priority, deferredEventHandler.useWeakReference);
        }
    }

    private function redirectSocketDataEvent():void {
        super.removeEventListener(ProgressEvent.SOCKET_DATA, onSocketData);
        var deferredEventHandler:Object = this.deferredEventHandlers[ProgressEvent.
                SOCKET_DATA];
        if (deferredEventHandler != null) {
            super.addEventListener(ProgressEvent.SOCKET_DATA, deferredEventHandler.
                    listener, deferredEventHandler.useCapture,
                    deferredEventHandler.priority, deferredEventHandler.
                            useWeakReference);
        }
    }

    private function checkResponse(event:ProgressEvent):void {
        var responseCode:String = this.buffer.substr(this.buffer.indexOf(" ") +
                1, 3);

        if (responseCode.search(/^2/) == -1) {
            var ioError:IOErrorEvent = new IOErrorEvent(IOErrorEvent.IO_ERROR);
            ioError.text = "Error connecting to the proxy [" + this.proxyHost +
                    "] on port [" + this.proxyPort + "]: " + this.buffer;
            this.dispatchEvent(ioError);
        }
        else {
            this.redirectSocketDataEvent();
            this.dispatchEvent(new Event(Event.CONNECT));
            if (this.bytesAvailable > 0) {
                this.dispatchEvent(event);
            }
        }
        // Resets the buffer to empty string.
        this.buffer = '';
    }

    private function onConnect(event:Event):void {
        this.writeUTFBytes("CONNECT " + this.host + ":" + this.port + " HTTP/1.1\n\n");
        this.flush();
        this.redirectConnectEvent();
    }

    private function onSocketData(event:ProgressEvent):void {
        while (this.bytesAvailable != 0) {
            this.buffer += this.readUTFBytes(1);
            if (this.buffer.search(/\r?\n\r?\n$/) != -1) {
                this.checkResponse(event);
                break;
            }
        }
    }
}
}
// vim:ft=as3
