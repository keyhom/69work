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

/**
 * Represents a I/O filter with <tt>IoSession</tt> to intercept all the I/O operation.
 *
 * @author keyhom
 */
public interface IoFilter {

    /**
     * Fires when the specified <tt>IoSession</tt> was created.
     *
     * @param session The <tt>IoSession</tt> associated with the connection.
     */
    function sessionCreated(session:IoSession):void;

    /**
     * Fires when the specified <tt>IoSession</tt> was opened with the connection.
     *
     * @param session The <tt>IoSession</tt> associated with the connection.
     */
    function sessionOpened(session:IoSession):void;

    /**
     * Fires when the specified <tt>IoSession</tt> was closed.
     *
     * @param session The <tt>IoSession</tt> associated with the connection.
     */
    function sessionClosed(session:IoSession):void;

    /**
     * Fires when the specified <tt>IoSession</tt> was received message from the end-point of the connection.
     *
     * @param session The <tt>IoSession</tt> associated with the connection.
     * @param message The message received from the end-point of the connection.
     * @param chain The chain controller for calling next filter.
     */
    function messageReceived(session:IoSession, message:Object, chain:IoChainController):void;

    /**
     * Fires when the specified <tt>IoSession</tt> was being written to the end-point of the connection.
     *
     * @param session The <tt>IoSession</tt> associated with the connection.
     * @param message The message which being written.
     * @param chain The chain controller for calling next filter.
     */
    function messageWritting(session:IoSession, message:Object, chain:IoChainController):void;

    /**
     * Fires when the specified <tt>IoSession</tt> was sent to the end-point of the connection.
     *
     * @param session The <tt>IoSession</tt> associated with the connection.
     * @param message The message which sent to the end-point of the connection.
     */
    function messageSent(session:IoSession, message:Object):void;

    /**
     * Fires when the specified <tt>IoSession</tt> was caught any <tt>Error</tt>.
     *
     * @param session The <tt>IoSession</tt> which cause by the error.
     * @param e The <tt>Error</tt> caught.
     */
    function errorCaught(session:IoSession, e:Error):void;

}
}
// vim:ft=as3
