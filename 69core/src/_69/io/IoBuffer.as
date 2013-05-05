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

package _69.io {

import flash.errors.EOFError;
import flash.errors.IllegalOperationError;
import flash.utils.ByteArray;

/**
 * The <tt>IoBuffer</tt> representing a default implementation for <tt>IBuffer</tt>, <tt>IBufferInput</tt>, <tt>IBufferOutput</tt>, using the <tt>flash.utils.ByteArray</tt> for implementing.
 *
 * @author keyhom
 */
public class IoBuffer implements IBuffer, IBufferInput, IBufferOutput {

    /**
     * Designated a static constructor for <tt>IoBuffer</tt> specified by the <code>byteArray</code>.
     *
     * @param byteArray The specified byte-array to wrap as IoBuffer.
     * @return An <tt>IoBuffer</tt> instance associated with the specified <tt>ByteArray</tt>.
     */
    public static function wrap(byteArray:ByteArray):IoBuffer {
        if (!byteArray)
            throw new IllegalOperationError("Invalid byteArray to wrap as IoBuffer.");
        var bb:IoBuffer = new IoBuffer(byteArray);
        return bb;
    }

    /**
     * Outputs the specified <tt>ByteArray</tt>'s hex string.
     *
     * @param bytes The bytes to dump hex.
     * @param limit The number of bytes to dump to.
     * @return The hex string.
     */
    public static function toHexString(bytes:ByteArray, limit:uint = 25):String {
        if (bytes) {
            var s:String = '';
            var pos:int = bytes.position;
            var len:int = Math.min(bytes.length, limit);

            for (var i:int = 0; i < len; i++) {
                var b:int = bytes.readByte();
                var s1:String = (b & 0xFF).toString(16).toUpperCase();
                if (s1.length == 1) {
                    s1 = '0' + s1;
                }
                s += ' ' + s1;
            }

            bytes.position = pos;

            if (len < bytes.length) {
                s += ' ...';
            }

            return s;
        }
        return '';
    }

    /**
     * Creates an IoBuffer instance.
     */
    public function IoBuffer(byteArray:ByteArray = null) {
        if (byteArray) {
            this._bytes = byteArray;
        } else {
            this._bytes = new ByteArray();
        }
    }

    /** The head index for bytes beginning. */
    private var _head:uint = 0;
    /** The tail index for bytes ending. */
    private var _tail:uint = int.MAX_VALUE;
    /** @private */
    private var _bytes:ByteArray;
    /** @private */
    private var _mark:int = -1;

    /**
     * The endian default by BIG_ENDIAN for this IoBuffer.
     */
    public function get endian():String {
        return _bytes.endian;
    }

    /**
     * Designates to determine the capacity of this buffer.
     * This capacity is only available in sub-queue IoBuffer.
     */
    public function get capacity():uint {
        return _tail - _head;
    }

    /**
     * The sequence bytes array containing in this I/O buffer.
     */
    public function get array():ByteArray {
        return _bytes;
    }

    /** @private */
    private var _limit:int = -1;

    /**
     * @inheritDoc
     */
    public function get limit():uint {
        return _limit < 0 ? _bytes.length - _head : _limit;
    }

    /** @private */
    private var _position:uint = 0;

    /**
     * @inheritDoc
     */
    public function get position():uint {
        return _position;
    }

    /**
     * @inheritDoc
     */
    public function get remaining():uint {
        return limit - position;
    }

    /**
     * @inheritDoc
     */
    public function get readOnly():Boolean {
        return false;
    }

    /**
     * Sets the endian by specified <code>value</code>.
     */
    public function endianTo(value:String):void {
        _bytes.endian = value;
    }

    /**
     * @inheritDoc
     */
    public function getBoolean(pos:int = -1):Boolean {
        validate();
        var forward:Boolean = pos < 0;
        forward ? pos = _position : false;
        checkBounds(pos, 1);
        forward ? _position += 1 : false;
        _bytes.position = pos + _head;
        return _bytes.readBoolean();
    }

    /**
     * @inheritDoc
     */
    public function getByte(pos:int = -1):int {
        validate();
        var forward:Boolean = pos < 0;
        forward ? pos = _position : false;
        checkBounds(pos, 1);
        forward ? _position += 1 : false;
        _bytes.position = pos + _head;
        return _bytes.readByte();
    }

    /**
     * @inheritDoc
     */
    public function getShort(pos:int = -1):int {
        validate();
        var forward:Boolean = pos < 0;
        forward ? pos = _position : false;
        checkBounds(pos, 2);
        forward ? _position += 2 : false;
        _bytes.position = pos + _head;
        return _bytes.readShort();
    }

    /**
     * @inheritDoc
     */
    public function getInt(pos:int = -1):int {
        validate();
        var forward:Boolean = pos < 0;
        forward ? pos = _position : false;
        checkBounds(pos, 4);
        forward ? _position += 4 : false;
        _bytes.position = pos + _head;
        return _bytes.readInt();
    }

    /**
     * @inheritDoc
     */
    public function getLong(pos:int = -1):Number {
        validate();
        var forward:Boolean = pos < 0;
        forward ? pos = _position : false;
        checkBounds(pos, 8);
        forward ? _position += 8 : false;
        _bytes.position = pos + _head;

//        var a1:int, a2:int;
//
//        if (endian == Endian.BIG_ENDIAN) {
//            a1 = _bytes.readInt();
//            a2 = _bytes.readInt();
//        } else {
//            a2 = _bytes.readInt();
//            a1 = _bytes.readInt();
//        }
//        return a1 << 32 | a2;

        var l:String = "0x";
        for (var i:int = 0; i < 8; i++) {
            var numStr:String = _bytes.readUnsignedByte().toString(16);
            l += numStr.length == 1 ? "0" + numStr : numStr;
        }
        return parseInt(l);
    }

    /**
     * @inheritDoc
     */
    public function getUnsignedByte(pos:int = -1):uint {
        validate();
        var forward:Boolean = pos < 0;
        forward ? pos = _position : false;
        checkBounds(pos, 1);
        forward ? _position += 1 : false;
        _bytes.position = pos + _head;
        return _bytes.readUnsignedByte();
    }

    /**
     * @inheritDoc
     */
    public function getUnsignedShort(pos:int = -1):uint {
        validate();
        var forward:Boolean = pos < 0;
        forward ? pos = _position : false;
        checkBounds(pos, 2);
        forward ? _position += 2 : false;
        _bytes.position = pos + _head;
        return _bytes.readUnsignedShort();
    }

    /**
     * @inheritDoc
     */
    public function getUnsignedInt(pos:int = -1):uint {
        validate();
        var forward:Boolean = pos < 0;
        forward ? pos = _position : false;
        checkBounds(pos, 4);
        forward ? _position += 4 : false;
        _bytes.position = pos + _head;
        return _bytes.readUnsignedInt();
    }

    /**
     * @inheritDoc
     */
    public function getUnsignedLong(pos:int = -1):Number {
        var value:Number = getLong(pos);
        return value & 0xFFFFFFFFFFFFFFFF;
    }

    /**
     * @inheritDoc
     */
    public function getBytes(bytes:ByteArray, offset:uint = 0, length:uint = 0, pos:int = -1):void {
        if (!bytes)
            throw new ArgumentError("Invalid bytes array.");
        validate();
        var forward:Boolean = pos < 0;
        forward ? pos = _position : false;
        if (!length)
            length = limit - pos;

        if (!length)
            return;

        checkBounds(pos, length);
        forward ? _position += length : false;
        _bytes.position = pos + _head;
        _bytes.readBytes(bytes, offset, length);
    }

    /**
     * @inheritDoc
     */
    public function getByteArray(length:uint = 0, pos:int = -1):ByteArray {
        validate();
        var forward:Boolean = pos < 0;
        forward ? pos = _position : false;
        if (!length) {
            length = remaining;
        }
        checkBounds(pos, length);
        forward ? _position += length : false;
        _bytes.position = pos + _head;
        var bb:ByteArray = new ByteArray();
        _bytes.readBytes(bb, 0, length);
        return bb;
    }

    /**
     * @inheritDoc
     */
    public function getDouble(pos:int = -1):Number {
        validate();
        var forward:Boolean = pos < 0;
        forward ? pos = _position : false;
        checkBounds(pos, 8);
        forward ? _position += 8 : false;
        _bytes.position = pos + _head;
        return _bytes.readDouble();
    }

    /**
     * @inheritDoc
     */
    public function getFloat(pos:int = -1):Number {
        validate();
        var forward:Boolean = pos < 0;
        forward ? pos = _position : false;
        checkBounds(pos, 4);
        forward ? _position += 4 : false;
        _bytes.position = pos + _head;
        return _bytes.readFloat();
    }

    /**
     * @inheritDoc
     */
    public function getString(pos:int = -1, length:uint = 0, charset:String = null):String {
        validate();
        var forward:Boolean = pos < 0;
        forward ? pos = _position : false;
        if (!length) {
            length = limit - pos;
        }
        checkBounds(pos, length);
        forward ? _position += length : false;
        _bytes.position = pos + _head;
        return _bytes.readMultiByte(length, charset ? charset : 'utf-8');
    }

    /**
     * @inheritDoc
     */
    public function getPrefixedString(pos:int = -1, prefixLength:uint = 2, charset:String = null):String {
        if (!prefixLength)
            throw new ArgumentError("Invalid prefixLength, not available value is: 0");
        null == charset ? charset = 'utf-8' : false;
        validate();
        var forward:Boolean = pos < 0;
        forward ? pos = _position : false;
        checkBounds(pos, prefixLength);
        _bytes.position = pos + _head;
        var length:uint = _bytes.readUnsignedShort();
        pos += prefixLength;

        checkBounds(pos, length);
        forward ? _position += length + prefixLength : false;
        _bytes.position = pos + _head;
        return _bytes.readMultiByte(length, charset);
    }

    /**
     * @inheritDoc
     */
    public function getObject(pos:int = -1):Object {
        validate();
        var forward:Boolean = pos < 0;
        forward ? pos = _position : false;
        checkBounds(pos, limit - pos);
        forward ? _position += (limit - pos) : false;
        _bytes.position = pos + _head;
        return _bytes.readObject();
    }

    /**
     * @inheritDoc
     */
    public function clear():IBuffer {
        _position = 0;
        _limit = 0;
        _mark = -1;
        return this;
    }

    /**
     * Frees this I/O buffer.
     */
    public function free():void {
        if (_bytes) {
            _bytes.clear();
            _bytes = null;
        }

        clear();
    }

    /**
     * Compacts this buffer.
     *
     * @return This buffer for chaining.
     */
    public function compact():IoBuffer {
        var bytes:ByteArray = new ByteArray;
        bytes.endian = _bytes.endian;
        bytes.writeBytes(_bytes, _position, remaining);
        _bytes.clear();
        _bytes = bytes;
        return this;
    }

    /**
     * @inheritDoc
     */
    public function flip():IBuffer {
        limitTo(position);
        return positionTo(0);
    }

    /**
     * @inheritDoc
     */
    public function reset():IBuffer {
        if (_mark >= 0) {
            positionTo(_mark);
        }
        return this;
    }

    /**
     * description of IoBuffer#slice().
     *
     * @return The sub-queue instance between this <tt>IoBuffer</tt>'s position and limit.
     */
    public function slice():IoBuffer {
        var sb:IoBuffer = new IoBuffer();
        sb._head = _position;
        sb._tail = _limit;
        sb._bytes = _bytes;
        return sb;
    }

    /**
     * @inheritDoc
     */
    public function mark():IBuffer {
        _mark = _position;
        return this;
    }

    /**
     * @inheritDoc
     */
    public function limitTo(value:uint):IBuffer {
        if (value > capacity) {
            throw new IllegalOperationError("The IoBuffer was limited by OutOfBounds. It must be limit <= capacity.");
        }
        this._limit = value;
        return this;
    }

    /**
     * @inheritDoc
     */
    public function positionTo(value:uint):IBuffer {
        this._position = value;
        return this;
    }

    /**
     * @inheritDoc
     */
    public function rewind():IBuffer {
        positionTo(0);
        _mark = -1;
        return this;
    }

//    /**
//     * Designates to provides the specified position which is available currently.
//     *
//     * @param pos The specified position to compare with the current position.
//     * @return The available position currently.
//     */
//    protected function getPosition0(pos:int = -1):uint {
//         return pos < 0 ? _position : pos;
//    }

    /**
     * @inheritDoc
     */
    public function putBoolean(value:Boolean, pos:int = -1):IBufferOutput {
        validate();
        var forward:Boolean = pos < 0;
        forward ? pos = _position : false;
        checkBounds(pos, 1);
        forward ? _position += 1 : false;
        _bytes.position = pos + _head;
        _bytes.writeBoolean(value);
        return this;
    }

    /**
     * @inheritDoc
     */
    public function putByte(value:int, pos:int = -1):IBufferOutput {
        validate();
        var forward:Boolean = pos < 0;
        forward ? pos = _position : false;
        checkBounds(pos, 1);
        forward ? _position += 1 : false;
        _bytes.position = pos + _head;
        _bytes.writeByte(value);
        return this;
    }

    /**
     * @inheritDoc
     */
    public function putByteArray(bytes:ByteArray, offset:uint = 0, length:uint = 0, pos:int = -1):IBufferOutput {
        validate();
        var forward:Boolean = pos < 0;
        forward ? pos = _position : false;
        if (!length) {
            length = bytes.length;
        }

        if (!length) {
            return this;
        }

        checkBounds(pos, length);
        forward ? _position += length : false;
        _bytes.position = pos + _head;
        _bytes.writeBytes(bytes, offset, length);
        return this;
    }

    /**
     * @inheritDoc
     */
    public function putDouble(value:Number, pos:int = -1):IBufferOutput {
        validate();
        var forward:Boolean = pos < 0;
        forward ? pos = _position : false;
        checkBounds(pos, 8);
        forward ? _position += 8 : false;
        _bytes.position = pos + _head;
        _bytes.writeDouble(value);
        return this;
    }

    /**
     * @inheritDoc
     */
    public function putFloat(value:Number, pos:int = -1):IBufferOutput {
        validate();
        var forward:Boolean = pos < 0;
        forward ? pos = _position : false;
        checkBounds(pos, 4);
        forward ? _position += 4 : false;
        _bytes.position = pos + _head;
        _bytes.writeFloat(value);
        return this;
    }

    /**
     * @inheritDoc
     */
    public function putShort(value:int, pos:int = -1):IBufferOutput {
        validate();
        var forward:Boolean = pos < 0;
        forward ? pos = _position : false;
        checkBounds(pos, 2);
        forward ? _position += 2 : false;
        _bytes.position = pos + _head;
        _bytes.writeShort(value);
        return this;
    }

    /**
     * @inheritDoc
     */
    public function putInt(value:int, pos:int = -1):IBufferOutput {
        validate();
        var forward:Boolean = pos < 0;
        forward ? pos = _position : false;
        checkBounds(pos, 4);
        forward ? _position += 4 : false;
        _bytes.position = pos + _head;
        _bytes.writeInt(value);
        return this;
    }

    /**
     * @inheritDoc
     */
    public function putUnsignedInt(value:uint, pos:int = -1):IBufferOutput {
        validate();
        var forward:Boolean = pos < 0;
        forward ? pos = _position : false;
        checkBounds(pos, 4);
        forward ? _position += 4 : false;
        _bytes.position = pos + _head;
        _bytes.writeUnsignedInt(value);
        return this;
    }

    /**
     * @inheritDoc
     */
    public function putLong(value:Number, pos:int = -1):IBufferOutput {
        if (isNaN(value)) throw new ArgumentError("Invalid value to write as Long.");
        validate();
        var forward:Boolean = pos < 0;
        forward ? pos = _position : false;
        checkBounds(pos, 8);
        forward ? _position += 8 : false;
        _bytes.position = pos + _head;

        // write long implementation.
        var hex:String = value.toString(16);
        var pn:int = 16 - hex.length;
        var ps:String = '';

        for (var i:int = 0; i < pn; i++) {
            ps += '0';
        }

        hex = ps + hex;
        i = 0;

        for (var n:int = hex.length; i < n; i += 2) {
            var c:String = hex.charAt(i) + hex.charAt(i + 1);
            _bytes.writeByte(parseInt(c, 16));
        }

        return this;
    }

    /**
     * @inheritDoc
     */
    public function putUnsignedLong(value:Number, pos:int = -1):IBufferOutput {
        throw new IllegalOperationError("The IoBuffer doesn't supported UnsignedLong to write now.");
    }

    /**
     * @inheritDoc
     * @param value
     * @param pos
     * @return
     */
    public function putObject(value:Object, pos:int = -1):IBufferOutput {
        if (value) {
            validate();
            var forward:Boolean = pos < 0 ? pos = _position : false;
            // Determines the object bytes length.
            var b:ByteArray = new ByteArray;
            b.endian = endian;
            b.writeObject(value);
            b.position = 0;
            var length:uint = b.length;
            checkBounds(pos, length);
            forward ? _position += length : false;
            _bytes.position = pos + _head;
            _bytes.writeObject(value);
        }
        return this;
    }

    /**
     * @inheritDoc
     */
    public function putString(value:String, charset:String = null, pos:int = -1):IBufferOutput {
        if (value) {
            null == charset ? charset = 'utf-8' : false;
            validate();
            var forward:Boolean = pos < 0 ? pos = _position : false;
            // Determines the byte length.
            var b:ByteArray = new ByteArray();
            b.endian = endian;
            b.writeMultiByte(value, charset);
            b.position = 0;
            var length:uint = b.length;
            checkBounds(pos, length);
            forward ? _position += length : false;
            _bytes.position = pos + _head;
            _bytes.writeBytes(b, 0, length);
        }
        return this;
    }

    /**
     * @inheritDoc
     */
    public function putPrefixedString(value:String, prefixLength:uint = 2, charset:String = null, pos:int = -1):IBufferOutput {
        if (value) {
            if (!prefixLength) {
                throw new ArgumentError("Invalid prefix length!");
            }
            null == charset ? charset = 'utf-8' : false;
            validate();
            var forward:Boolean = pos < 0 ? pos = _position : false;
            // Determines the byte length of value.
            var b:ByteArray = new ByteArray;
            b.endian = endian;
            b.writeMultiByte(value, charset);
            b.position = 0;
            var length:uint = b.length;
            checkBounds(pos, length + prefixLength);
            forward ? _position += length + prefixLength : false;

            _bytes.position = pos + _head;
            _bytes.writeShort(length);
            _bytes.writeBytes(b, 0, length);
        }
        return this;
    }

    /**
     * @private
     */
    public function toString(limit:uint = 25):String {
        validate();
        return toHexString(this.array, limit);
    }

    /** @private */
    private function validate():void {
        if (!_bytes) throw new EOFError("Trying to operate a free IoBuffer!!!");
    }

    /** @private */
    private function checkBounds(pos:uint, more:uint = 1):void {
        if (pos + more > capacity) throw new EOFError("IndexOutOfBounds: no enough operating at position: " + pos);
    }
}
}
// vim:ft=as3
