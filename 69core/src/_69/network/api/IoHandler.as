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
 * A </tt>IoHandler</tt> represents to handle the I/O logic with the specified <tt>IoSession</tt>.
 *
 * @author keyhom
 */
public interface IoHandler {

    /**
     * Handles the specified session created.
     *
     * @param session The session associated with the connection.
     */
    function sessionCreated(session:IoSession):void;

    /**
     * Handles the specified session opened.
     *
     * @param session The session associated with the connection.
     */
    function sessionOpened(session:IoSession):void;

    /**
     * Handles the specified session closed.
     *
     * @param session The session associated with the connection.
     */
    function sessionClosed(session:IoSession):void;

    /**
     * Handles the specified message sent by the specified session.
     *
     * @param session The session associated with the connection.
     * @param message The message to sent.
     */
    function messageSent(session:IoSession, message:Object):void;

    /**
     * Handles the specified message received by the specified session.
     *
     * @param session The session associated with the connection.
     * @param message The message received.
     */
    function messageReceived(session:IoSession, message:Object):void;

    /**
     * Handles the specified session caught an specified error.
     *
     * @param session The session associated with the connection.
     * @param e The error caught.
     */
    function errorCaught(session:IoSession, e:Error):void;

}
}
// vim:ft=as3
