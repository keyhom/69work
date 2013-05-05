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

package $69.network.codec.textline {

import $69.io.IoBuffer;
import $69.network.codec.IStateProtocolDecoder;

import flash.errors.IllegalOperationError;
import flash.utils.ByteArray;

/**
 * @author keyhom
 */
public class TextLineDecoder implements IStateProtocolDecoder {

    /**
     * Creates a TextLineDecoder instance.
     */
    public function TextLineDecoder(charset:String = 'utf-8') {
        this._charset = charset;
    }

    /** @private */
    private var _charset:String;

    /** @private */
    private var _maxLineLength:int = 1024;

    /**
     * The maximum length of line. Default to 1024.
     */
    public function get maxLineLength():uint {
        return _maxLineLength;
    }

    /** @private */
    public function set maxLineLength(value:uint):void {
        this._maxLineLength = value;
    }

    /**
     * @inheritDoc
     */
    public function createDecoderState():Object {
        return new Context(maxLineLength, _charset);
    }

    /**
     * @inheritDoc
     */
    public function decode(input:Object, context:Object):Object {
        var ctx:Context = context as Context;
        if (ctx) {
            var decoded:String = null;
            var matchCount:int = ctx.matchCount;
            var buffer:IoBuffer = getBuffer(input);
            // try to find a match.
            var oldPos:int = buffer.position;
            var oldLimit:int = buffer.limit;

            while (buffer.remaining && null == decoded) {
                var b:int = buffer.getByte();
                var matched:Boolean = false;

                switch (b) {
                    case '\r':
                        // Might be Mac, but we don't auto-detect Mac EOL to avoid confusion.
                        matchCount++;
                        break;
                    case '\n':
                        // Unix.
                        matchCount++;
                        matched = true;
                        break;

                    default:
                        matchCount = 0;
                }

                if (matched) {
                    // Found a match.
                    var pos:int = buffer.position;
                    buffer.limitTo(pos);
                    buffer.positionTo(oldPos);

                    ctx.append(buffer);

                    buffer.limitTo(oldLimit);
                    buffer.positionTo(pos);

                    try {
                        if (ctx.overflowLength == 0) {
                            var buf:IoBuffer = ctx.buffer;
                            buf.flip();
                            buf.limitTo(buf.limit - matchCount);

                            decoded = buf.getString(0, 0, ctx.charset);
                        } else {
                            var overflowPosition:int = ctx.overflowLength;
                            throw new IllegalOperationError("Line is too long: " + overflowPosition);
                        }
                    } finally {
                        ctx.reset();
                    }
                    oldPos = pos;
                    matchCount = 0;
                }
            }

            // Put remainder to buf.
            buffer.positionTo(oldPos);
            ctx.append(buffer);
            ctx.matchCount = matchCount;
            return decoded;
        }
        return null;
    }

    /**
     * @inheritDoc
     */
    public function finishDecode(context:Object):void {
        // nothing to do.
    }

    /** @private */
    private static function getBuffer(input:Object):IoBuffer {
        if (input is ByteArray)
            return IoBuffer.wrap(input as ByteArray);
        else if (input is IoBuffer)
            return input as IoBuffer;
        else
            throw new ArgumentError("Unknown binary or protocol-specific data.");
    }

}
}

import $69.io.IoBuffer;

/**
 * A Context used during the decoding of a lin. It stores the decoder, the temporary buffer containing the decoded line, and other status flags.
 *
 * @author keyhom
 */
class Context {

    /**
     * The temporary buffer containing the decoded line.
     */
    private var _buf:IoBuffer;

    /**
     * The charset for decoding.
     */
    private var _charset:String;

    /**
     * The number of lines found so far.
     */
    public var matchCount:int = 0;

    /**
     * Overflow length.
     */
    private var _overflowLength:int = 0;

    /** @private */
    private var _maxLineLength:uint;

    /**
     * Creates a Context instance.
     */
    public function Context(maxLineLength:uint, charset:String = 'utf-8') {
        this._charset = charset;
        this._maxLineLength = maxLineLength;
        _buf = new IoBuffer();
    }

    /** @private */
    public function get buffer():IoBuffer {
        return _buf;
    }

    /** @private */
    public function get charset():String {
        return _charset;
    }

    /** @private */
    public function get overflowLength():int {
        return _overflowLength;
    }

    /**
     * Resets the context.
     */
    public function reset():void {
        _overflowLength = 0;
        matchCount = 0;
        _buf.clear();
    }

    /**
     * Appends the buffer.
     */
    public function append(input:IoBuffer):void {
        if (_buf.position > _maxLineLength - input.remaining) {
            _overflowLength = _buf.position + input.remaining;
            _buf.clear();
            input.positionTo(input.limit);
        } else {
            _buf.putByteArray(input.array);
        }
    }
}
// vim:ft=as3
