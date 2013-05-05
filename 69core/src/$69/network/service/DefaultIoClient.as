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

package $69.network.service {

import $69.$69_internal;
import $69.core.api.DefaultFuture;
import $69.core.api.IFuture;
import $69.core.api.ILifecycle;
import $69.network.api.IoClient;
import $69.network.api.IoFilter;
import $69.network.api.IoHandler;
import $69.network.api.IoSession;
import $69.network.session.SocketSession;

import flash.net.Socket;
import flash.utils.Dictionary;

use namespace $69_internal;

/**
 * A default implementation for <tt>IoClient</tt>.
 *
 * @author keyhom
 */
public class DefaultIoClient implements IoClient, ILifecycle {

    /**
     * Creates a DefaultIoClient instance.
     */
    public function DefaultIoClient() {
    }

    /**
     * @private
     */
    private var _managedSessions:Dictionary;

    /**
     * @inheritDoc
     */
    public function get managedSessions():Dictionary {
        if (!_managedSessions)
            _managedSessions = new Dictionary();
        return _managedSessions;
    }

    /**
     * @private
     */
    private var _activated:Boolean = false;

    /**
     * @inheritDoc
     */
    public function get activated():Boolean {
        return _activated;
    }

    /** @private */
    private var _filters:Vector.<IoFilter>;

    /**
     * @inheritDoc
     */
    public function get filters():Vector.<IoFilter> {
        if (!_filters)
            _filters = new Vector.<IoFilter>;
        return _filters;
    }

    /**
     * @inheritDoc
     */
    public function set filters(value:Vector.<IoFilter>):void {
        this._filters = value;
    }

    /** @private */
    private var _handler:IoHandler;

    /**
     * @inheritDoc
     */
    public function get handler():IoHandler {
        return _handler;
    }

    /**
     * @inheritDoc
     */
    public function set handler(value:IoHandler):void {
        this._handler = value;
    }

    /**
     * @inheritDoc
     */
    public function connect(host:String, port:int):IFuture {
        var connectFuture:DefaultFuture = new DefaultFuture();
        connectFuture.callLater(function (f:IFuture):void {
            if (f.completed) {
                if (null != f.result) {
                    var s:SocketSession = f.result as SocketSession;
                    s.$69_internal::setHost(host);
                    s.$69_internal::setPort(port);

                    if (managedSessions)
                        managedSessions[s.id] = s;

                    if (!activated)
                        _activated = true;
                }
            }
        });

        var socket:Socket = new Socket();
        new SocketSession(this, socket, connectFuture);
        socket.connect(host, port);
        socket = null;

        return connectFuture;
    }

    /**
     * @inheritDoc
     */
    public function dispose():void {
        _activated = false;

        if (null != _managedSessions) // Destory all the managed sessions.
            for each (var s:IoSession in _managedSessions) {
                if (s is ILifecycle) {
                    ILifecycle(s).destory();
                }
            }
        _managedSessions = null;
    }

    /**
     * @inheritDoc
     */
    public function init():void {
    }

    /**
     * @inheritDoc
     */
    public function destory():void {
        dispose();
        _filters = null;
        _handler = null;
    }

}
}
// vim:ft=as3
