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

import _69.core.api.IFuture;

/**
 * The write request created by the <tt>IoSession</tt>'s write method, which is
 * transmitted through the filter chain and finish as a socket write. <br/>
 *
 * We store the original message into this data structure, along the associated
 * potentially modified message if the original message gets encoded during the
 * process.<br/>
 *
 * Note that when we always ends with the message being a ByteArray when we reach
 * the socket. <br/>
 *
 * We also keep a <tt>IFuture</tt> into this data structure to inform the caller
 * about the write completion.
 *
 * @author keyhom
 */
public interface IWriteRequest {

    /**
     * The message stored in this request.
     */
    function get message():Object;

    /**
     * The original message stored in this request.
     */
    function get originMessage():Object;

    /**
     * The future to be completed on a write success.
     */
    function get future():IFuture;

}
}
// vim:ft=as3
