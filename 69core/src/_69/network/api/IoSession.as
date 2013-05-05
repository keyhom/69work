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

package _69.network.api {

/**
 * The <tt>IoSession</tt> represents a session context associated with the connection which communicated with the end-point server.
 *
 * @author keyhom
 */
public interface IoSession {

    /**
     * The ID number of this <tt>IoSession</tt>.
     */
    function get id():Number;

    /**
     * Indicates if this session was connected currently.
     */
    function get connected():Boolean;

    /**
     * The <tt>IoClient</tt> instead of.
     */
    function get service():IoClient;

    /**
     * Writes the specified message to the end-point.
     *
     * @param message The specified message to write.
     */
    function write(message:Object):void;

    /**
     * Closes this session.
     * This operation also disconnect the connection with the end-point server.
     */
    function close():void;

    /**
     * The host of the remote peer.
     */
    function get host():String;

    /**
     * The port of the remote peer.
     */
    function get port():uint;

    /**
     * Designates to output the session with the specified information.
     *
     * @param includeRemotePeer <tt>true</tt> if contains the remote-peer information, <tt>false</tt> otherwise.
     * @return The formatted output text.
     */
    function toString(includeRemotePeer:Boolean = false):String;

}
}
// vim:ft=as3
