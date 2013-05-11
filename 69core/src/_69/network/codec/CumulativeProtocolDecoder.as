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
        var buffer:IoBuffer;
        if (input is ByteArray) {
            buffer = IoBuffer.wrap(ByteArray(input));
        } else if (input is IoBuffer) {
            buffer = IoBuffer(input);
        } else {
            throw new ArgumentError("Invalid inputs binary or protocol-specific data.");
        }

        if (buffer && buffer.remaining) {
            var useSessionBuffer:Boolean = true;
            var sessionBuf:IoBuffer = (context[_BUFFER_KEY] as IoBuffer);
            // If we have a session buffer, append data to that; otherwise use
            // the buffer read from the network directly.
            var buf:IoBuffer = sessionBuf;
            if (null != buf) {
                buf.put(buffer);
                var pos:uint = buf.position;
                buf.positionTo(0);
                var subBuf:IoBuffer = buf.slice();
                subBuf.limitTo(pos);
                buf.positionTo(pos);
                buf = subBuf;
            } else {
                buf = buffer;
                useSessionBuffer = false;
            }

            var result:Object;
            if ((result = doDecode(buf, context))) {
                if (0 == buf.position)
                    throw new IllegalOperationError("doDecode() can't return true when buffer is not consumed.");
            }

            // If there is any data left that can't be decoded, we store it in a
            // buffer in the session and next time this decoder is invoked the
            // session buffer gets appended to.
            if (buf.remaining) {
                if (!useSessionBuffer) {
                    // storage remaining in session.
                    sessionBuf = IoBuffer.allocate();
                    sessionBuf.put(buf);
                    context[_BUFFER_KEY] = sessionBuf;
                }
            } else {
                if (useSessionBuffer) {
                    // remove remaining in session.
                    if (_BUFFER_KEY in context) {
                        IoBuffer(context[_BUFFER_KEY]).free();
                        delete context[_BUFFER_KEY];
                    }
                }
            }

            return result;
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
