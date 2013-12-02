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

import _69.io.IoBuffer;

import flash.errors.IllegalOperationError;
import flash.utils.ByteArray;
import flash.utils.Dictionary;

/**
 * A <tt>IProtocolDecoder</tt> that cumulates the content of received buffers to
 * a <em>cumulative</em> to help users implement decoders.
 * <p>If the received <tt>IoBuffer</tt> is only a part of message. decoders should
 * cumulate received buffers to make a message complete or postpone decoding until
 * more buffers arrive.</p>
 *
 * @author keyhom
 */
public class CumulativeProtocolDecoder implements IStateProtocolDecoder {

    /** @private */
    protected static const _BUFFER_KEY:String = "_$$SESSION_BUFFER_KEY$$";

    /**
     * Creates a CumulativeProtocolDecoder instance.
     */
    public function CumulativeProtocolDecoder() {
    }

    /**
     * @inheritDoc
     */
    public function createDecoderState():Object {
        return new Dictionary();
    }

    /**
     * @inheritDoc
     */
    public function decode(input:Object, context:Object):Object {
        var buffer:ByteArray;
        if (input is ByteArray) {
            buffer = input as ByteArray;
        } else if (input is IoBuffer) {
            buffer = input.getByteArray(0);
        } else {
            throw new ArgumentError("Invalid inputs binary or protocol-specific data.");
        }

        if (buffer && buffer.bytesAvailable) {
            var useSessionBuffer:Boolean = true;
            var sessionBuf:ByteArray = (context[_BUFFER_KEY] as ByteArray);
            // If we have a session buffer, append data to that; otherwise use
            // the buffer read from the network directly.
            if (null != sessionBuf)
            {
                var newBuf:ByteArray = new ByteArray;
                newBuf.writeBytes(sessionBuf);
                newBuf.writeBytes(buffer);
                newBuf.position = 0;
                buffer = newBuf;
            } else {
                useSessionBuffer = false;
            }

            var buf:IoBuffer = IoBuffer.wrap(buffer);

            var decoded:Boolean = false;
            var results:Array = [];
            var result:Object;
            while (buf.remaining) {
                var pos:int = buf.position;
                result = doDecode(buf, context);
                if (buf.position == pos) // data underflow.
                {
                    if (null != result)
                        throw new IllegalOperationError("doDecode() can't return true when buffer is not consumed.");
                    break;
                }
                decoded = true;
                if (null != result)
                    results.push(result);
            }

            // If there is any data left that can't be decoded, we store it in a
            // buffer in the session and next time this decoder is invoked the
            // session buffer gets appended to.
            if (buf.remaining && decoded)
            {
                if (useSessionBuffer)
                    ByteArray(context[_BUFFER_KEY]).clear();

                var temp:ByteArray = new ByteArray;
                temp.writeBytes(buf.array, buf.arrayOffset + buf.position, buf.remaining);
                temp.position = 0;
                context[_BUFFER_KEY] = temp;

            } else if (!buf.remaining) {
                if (useSessionBuffer) {
                    // remove remaining in session.
                    if (_BUFFER_KEY in context)
                    {
                        ByteArray(context[_BUFFER_KEY]).clear();
                        delete context[_BUFFER_KEY];
                    }
                }
            }

            return results;
        }

        return null;
    }

    /**
     * @inheritDoc
     */
    public function finishDecode(context:Object):void {
        // nothing to do.
    }

    /**
     * Decodes the input I/O buffer to the high-level object.
     *
     * @param input The I/O buffer specified by binary or protocol-specific.
     * @param context The context state object.
     * @return The deocded result.
     */
    protected function doDecode(input:IoBuffer, context:Object):Object {
        return false;
    }

}
}
// vim:ft=as3
