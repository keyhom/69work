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

import $69.network.codec.IStateProtocolEncoder;

import flash.utils.ByteArray;

/**
 * A <tt>IProtocolEncoder</tt> which encodes a string into a text line which ends with the delimiter.
 *
 * @author keyhom
 */
public class TextLineEncoder implements IStateProtocolEncoder {

    /** @private */
    private var _delimiter:String;
    /** @private */
    private var maxLineLength:uint = uint.MAX_VALUE;
    /** @private */
    private var _charset:String;

    /**
     * Creates a TextLineEncoder instance.
     */
    public function TextLineEncoder(delimiter:String = '\n', charset:String = 'utf-8') {
        if (!delimiter)
            delimiter = '\n';
        this._delimiter = delimiter;
        if (!charset)
            charset = 'utf-8';
        this._charset = charset;
    }

    /**
     * @inheritDoc
     */
    public function createEncoderState():Object {
        return null;
    }

    /**
     * @inheritDoc
     */
    public function encode(message:Object, context:Object):Object {
        var value:String = null == message ? "" : String(message);

        if (value.length > maxLineLength) {
            throw new ArgumentError("Line length: " + value.length);
        }
        var bytes:ByteArray = new ByteArray;
        bytes.writeMultiByte(value, _charset);
        bytes.position = 0;
        return bytes;
    }
}
}
// vim:ft=as3
