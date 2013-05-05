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

package _69.network.codec {

/**
 * In charge of encoding a message of the MESSAGE into another from (could be a <tt>ByteArray</tt> or any other protocol level construction.
 *
 * @author keyhom
 */
public interface IProtocolEncoder {

    /**
     * Encodes higher-level message objects into binary or protocol-specific data.
     *
     * @param message The message to encode.
     * @param context The encoding context (will be stored in the session for the next encode call).
     * @return The encoded message.
     */
    function encode(message:Object, context:Object):Object;

}
}
// vim:ft=as3
