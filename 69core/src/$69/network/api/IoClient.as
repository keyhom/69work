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

package $69.network.api {

import $69.core.api.IFuture;

import flash.utils.Dictionary;

/**
 * The <tt>IoClient</tt> represents a base interface for providing connect to the end-point server and manages the <tt>IoSession</tt>s.
 *
 * @author keyhom
 */
public interface IoClient {

    /**
     * Connects to the remote end-point server by the specified host and port.
     *
     * @param host The host of the remote peer.
     * @param port The port of the remote peer.
     * @return The <tt>IFuture</tt> handle that computation completed.
     */
    function connect(host:String, port:int):IFuture;

    /**
     * Disposed this <tt>IoClient</tt> to releases all managed sessions.
     */
    function dispose():void;

    /**
     * A list of all managed <tt>IoSession</tt> currently.
     */
    function get managedSessions():Dictionary;

    /**
     * Indicates if the <tt>IoClient</tt> was activated.
     */
    function get activated():Boolean;

    /**
     * The chaining filters.
     */
    function get filters():Vector.<IoFilter>;

    /** @private */
    function set filters(value:Vector.<IoFilter>):void;

    /**
     * The I/O handler.
     */
    function get handler():IoHandler;

    /** @private */
    function set handler(value:IoHandler):void;

}
}
// vim:ft=as3
