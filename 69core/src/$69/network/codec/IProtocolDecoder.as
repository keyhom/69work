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

package $69.network.codec {

/**
 * Decodes a binary or protocol-specific data into higher-level message objects.
 * <p/>
 * Must be immutable, a <tt>CONTEXT</tt> will be provided per session.
 *
 * @author keyhom
 */
public interface IProtocolDecoder {

    /**
     * Decodes binary or protocol-specific content into higher-level protocol message objects.
     *
     * @param input The received message to decode.
     * @param context The decoding context (will be stored in the session for the next decode call).
     * @return The decoded message or <code>null</code> if nothing was decoded.
     */
    function decode(input:Object, context:Object):Object;

    /**
     * Finish decoding, for example if the decoder accumulated some unused input, it should discard it, or throw an exception.
     * @param context The decoding context.
     */
    function finishDecode(context:Object):void;

}
}
// vim:ft=as3
