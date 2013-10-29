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

import flash.errors.IllegalOperationError;
import flash.utils.ByteArray;

/**
 * The <tt>IoBuffer</tt> representing a default implementation for <tt>IBuffer</tt>, <tt>IBufferInput</tt>, <tt>IBufferOutput</tt>, using the <tt>flash.utils.ByteArray</tt> for implementing.
 *
 * @author keyhom
 */
public class IoBuffer implements IBuffer, IBufferInput, IBufferOutput {

    /** @private */
    internal static const BUF:IoBuffer = new IoBuffer();

    /**
     * Allocates a new <tt>IoBuffer</tt>.
     * The new buffer's position will be zero, its limit will be its capacity,
     * and its mark will be undefined. It will have a backing array, and its
     * array offset will be zero.
     *
     * @return The new buffer.
     */
    public static function allocate():IoBuffer {
        var newBuf:IoBuffer = BUF.clone();
        newBuf.constructsByCL(uint.MAX_VALUE, uint.MAX_VALUE);
        return newBuf;
    }

    /**
     * Designated a static constructor for <tt>IoBuffer</tt> specified by the <code>byteArray</code>.
     *
     * @param byteArray The specified byte-array to wrap as IoBuffer.
     * @param offset The offset specified by byte-array.
     * @param length The length specified by byte-array.
     * @return An <tt>IoBuffer</tt> instance associated with the specified <tt>ByteArray</tt>.
     */
    public static function wrap(byteArray:ByteArray, offset:uint = 0, length:uint = 0):IoBuffer {
        if (!byteArray)
            throw new ArgumentError("Invalid byteArray to wrap as IoBuffer.");
        var newBuf:IoBuffer = BUF.clone();
        newBuf.constructsByHOL(byteArray, offset, length ? length : byteArray.length);
        return newBuf;
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

    /** @private */
    internal static function checkBounds(off:int, len:int, size:int):void {
        if (0 > (off | len | (off + len) | (size - (off + len)))) {
            throw new RangeError();
        }
    }

    /**
     * <b>NOTE: </b>
     * Using the static constructor instead of the default constructor.
     * @exampleText
     * IoBuffer.allocate();
     * IoBuffer.wrap(new ByteArray);
     * @throws flash.errors.IllegalOperationError
     */
    public function IoBuffer(buf:IoBuffer = null) {
        if (BUF && (!buf || !buf._newFlag))
            throw new IllegalOperationError("Using IoBuffer.allocate() or IoBuffer.wrap() instead of.");
        else if (!BUF) {
            this._newFlag = true;
        }
    }

    /** @private */
    private var _newFlag:Boolean = false;
    /** @private */
    private var _offset:uint = 0;
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
     * The sequence bytes array containing in this I/O buffer.
     */
    public function get array():ByteArray {
        return _bytes;
    }

    /** @private */
    private var _limit:uint;

    /**
     * @inheritDoc
     */
    public function get limit():uint {
        return _limit;
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
        return _limit - _position;
    }

    /** @private */
    private var _readOnly:Boolean = false;

    /**
     * @inheritDoc
     */
    public function get readOnly():Boolean {
        return _readOnly;
    }

    /**
     * The offset within this buffer's backing array of the first element of the
     * buffer (optional operation).
     * If this buffer is backed by an array then buffer position <tt>p</tt> corresponds
     * to array index <code>p + arrayOffset</code>.
     * Invoke the <tt>hasArray</tt> method before invoking this method in order
     * to ensure that this buffer has an accessible backing array.
     *
     * @return The offset within this buffer's array of the first element of the
     *         buffer.
     * @throws Error If this buffer is backed by an array but is read-only.
     *         flash.errors.IllegalOperationError If this buffer is not backed
     *         by an accessible array.
     */
    public function get arrayOffset():int {
        if (null == _bytes)
            throw new IllegalOperationError();
        if (readOnly)
            throw new Error("ReadOnlyBuffer Error caught");
        return _offset;
    }

    /** @private */
    private var _capacity:uint = uint.MAX_VALUE;

    /**
     * Designates to stored the capacity of this buffer.
     */
    public function get capacity():uint {
        return _capacity;
    }

    /**
     * Sets the endian by specified <code>value</code>.
     *
     * @return This buffer for chaining.
     */
    public function endianTo(value:String):IoBuffer {
        _bytes.endian = value;
        return this;
    }

    /**
     * @inheritDoc
     */
    public function getBoolean(pos:int = -1):Boolean {
        pos < 0 ? pos = nextIndex() : checkIndex(pos);
        _bytes.position = ix(pos);
        return _bytes.readBoolean();
    }

    /**
     * @inheritDoc
     */
    public function getByte(pos:int = -1):int {
        pos < 0 ? pos = nextIndex() : checkIndex(pos);
        _bytes.position = ix(pos);
        return _bytes.readByte();
    }

    /**
     * @inheritDoc
     */
    public function getShort(pos:int = -1):int {
        pos < 0 ? pos = nextIndex(2) : checkIndex(pos, 2);
        _bytes.position = ix(pos);
        return _bytes.readShort();
    }

    /**
     * @inheritDoc
     */
    public function getInt(pos:int = -1):int {
        pos < 0 ? pos = nextIndex(4) : checkIndex(pos, 4);
        _bytes.position = ix(pos);
        return _bytes.readInt();
    }

    /**
     * @inheritDoc
     */
    public function getLong(pos:int = -1):Number {
        pos < 0 ? pos = nextIndex(8) : checkIndex(pos, 8);
        _bytes.position = ix(pos);

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
        pos < 0 ? pos = nextIndex(1) : checkIndex(pos, 1);
        _bytes.position = ix(pos);
        return _bytes.readUnsignedByte();
    }

    /**
     * @inheritDoc
     */
    public function getUnsignedShort(pos:int = -1):uint {
        pos < 0 ? pos = nextIndex(2) : checkIndex(pos, 2);
        _bytes.position = ix(pos);
        return _bytes.readUnsignedShort();
    }

    /**
     * @inheritDoc
     */
    public function getUnsignedInt(pos:int = -1):uint {
        pos < 0 ? pos = nextIndex(4) : checkIndex(pos, 4);
        _bytes.position = ix(pos);
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
    public function getBytes(bytes:ByteArray, offset:uint = 0, length:uint = 0):void {
        if (!bytes)
            throw new ArgumentError("Invalid bytes array.");
        checkBounds(offset, length, length);
        _bytes.position = ix(_position);
        _position += length;
        _bytes.readBytes(bytes, offset, length);
    }

    /**
     * @inheritDoc
     */
    public function getByteArray(offset:uint = 0, length:uint = 0):ByteArray {
        var bytes:ByteArray = new ByteArray;
        getBytes(bytes, offset, length);
        return bytes;
    }

    /**
     * @inheritDoc
     */
    public function getDouble(pos:int = -1):Number {
        pos < 0 ? pos = nextIndex(8) : checkIndex(pos, 8);
        _bytes.position = ix(pos);
        return _bytes.readDouble();
    }

    /**
     * @inheritDoc
     */
    public function getFloat(pos:int = -1):Number {
        pos < 0 ? pos = nextIndex(4) : checkIndex(pos, 4);
        _bytes.position = ix(pos);
        return _bytes.readFloat();
    }

    /**
     * @inheritDoc
     */
    public function getString(pos:int = -1, length:uint = 0, charset:String = null):String {
        var forward:Boolean = pos < 0;
        forward ? pos = _position : false;
        if (!length) {
            length = limit - pos;
        }
        forward ? nextIndex(length) : false;
        _bytes.position = ix(checkIndex(pos, length));
        return _bytes.readMultiByte(length, charset ? charset : 'utf-8');
    }

    /**
     * @inheritDoc
     */
    public function getPrefixedString(pos:int = -1, prefixLength:uint = 2, charset:String = null):String {
        if (!prefixLength)
            throw new ArgumentError("Invalid prefixLength, not available value is: 0");
        null == charset ? charset = 'utf-8' : false;
        var forward:Boolean = pos < 0;
        forward ? pos = _position : false;
        _bytes.position = ix(checkIndex(pos, prefixLength));
        var length:uint = _bytes.readUnsignedShort();
        pos += prefixLength;

        forward ? nextIndex(length + prefixLength) : false;
        _bytes.position = ix(checkIndex(pos, length));
        return _bytes.readMultiByte(length, charset);
    }

    /**
     * @inheritDoc
     */
    public function getObject(pos:int = -1):Object {
        var forward:Boolean = pos < 0;
        forward ? pos = checkIndex(_position, 4) : checkIndex(pos, 4);
        _bytes.position = ix(pos);

        var o:Object = _bytes.readObject();
        if (forward) {
            _position += (_bytes.position - pos);
        }
        return o;
    }

    /**
     * @inheritDoc
     */
    public function clear():IBuffer {
        _position = 0;
        _limit = _capacity;
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
     * Compacts this buffer (optional operation).
     * The bytes between the buffer's current position and its limit, if any, are
     * copied to the beginning of the buffer. That is, the byte at index <i>p</i>
     * = <code>position</code> is copied to index zero, the byte at index <i>p</i>
     * + <code>1</code> is copied to index one, and so forth until the byte at
     * index <code>limit</code> - 1 is copied to index <i>n</i> = <code>limit</code>
     *  - 1 - <i>p</i>. The buffer's position is then set to <i>n</i> + 1 and its
     *  limit is set to its capacity. The mark, if defined, is discarded.
     *  The buffer's position is set to the number of bytes copied, rather than
     *  to zero, so that an invocation of this method can be followed immediately
     *  by an invocation of another relative <code>put</code> method.
     *  Invoke this method after writing data from a buffer in case the write
     *  was incomplete. The following loop, for example, copied bytes from one
     *  channel to another via the buffer <code>buf</code>:
     *  @exampleText
     *  buf.clear();            // Prepare buffer for use.
     *  while (in.read(buf) >= 0 || buf.position != 0) {
     *      buf.flip();
     *      out.write(buf);
     *      buf.compact();      // In case of partial write.
     *  }
     *
     * @return This buffer for chaining.
     */
    public function compact():IoBuffer {
        var pos:uint = ix(this.position);
        _bytes.position = ix(0);
        _bytes.writeBytes(_bytes, pos, remaining);
        positionTo(remaining);
        limitTo(capacity);
        _mark = -1;
        return this;
    }

    /**
     * @inheritDoc
     */
    public function flip():IBuffer {
        _limit = _position;
        _position = 0;
        _mark = -1;
        return this;
    }

    /**
     * @inheritDoc
     */
    public function reset():IBuffer {
        if (_mark >= 0) {
            positionTo(_mark);
        } else {
            throw new Error("Invalid Mark.");
        }
        return this;
    }

    /**
     * Creates a new I/O buffer whose content is a shared sub-sequence of this
     * buffer's content.
     * The content of the new buffer will start at this buffer's current position.
     * Changes to this buffer's content will be visible in the new buffer, and
     * vice versa; the two buffer's position, limit, and mark values will be
     * independent.
     * The new buffer's position will be zero, its capacity and its limit will be
     * the number of bytes remaining in this buffer, and its mark will be undefined.
     * The new buffer will be direct if, and only if, this buffer is direct, and
     * it will be read-only if, and only if, this buffer is read-only.
     *
     * @return The new I/O buffer.
     */
    public function slice():IoBuffer {
        var subBuf:IoBuffer = BUF.clone();
        subBuf.constructsByHMPLCO(_bytes, -1, 0, remaining, remaining, _position + _offset);
        return subBuf;
    }

    /**
     * Creates a new I/O buffer that shares this buffer's content.
     * The content of the new buffer will be that of this buffer. Changes to this
     * buffer's content will be visible in the new buffer, and vice versa; the
     * two buffer's position, limit, and mark values will be independent. The
     * new buffer's capacity, limit, and position, and mark values will be identical
     * to those of this buffer. The new buffer will be direct if, and only if,
     * this buffer is direct, and it will be read-only if, and only if, this buffer
     * is read-only.
     *
     * @return The new I/O buffer.
     */
    public function duplicate():IoBuffer {
        var subBuf:IoBuffer = BUF.clone();
        subBuf.constructsByHMPLCO(_bytes, markValue(), _position, _limit, _capacity, _offset);
        return subBuf;
    }

    /**
     * Creates a new, read-only I/O buffer that shares this buffer's content.
     * The content of the new buffer will be that of this buffer. Changes to this
     * buffer's content will be visible in the new buffer; the new buffer itself,
     * however, will be read-only and will not allow the shared content to be
     * modified. The two buffer's position, limit, and mark values will be
     * independent.
     * The new buffer's capacity, limit, position, and mark values will be identical
     * to those of this buffer.
     * If this buffer is itself read-only then this method behaves in exactly the
     * same way as the <code>duplicate</code> method.
     *
     * @return The new, read-only I/O buffer.
     */
    public function asReadOnlyBuffer():IoBuffer {
        // TODO: Implements the asReadOnlyBuffer() method.
        throw new IllegalOperationError("The method asReadOnlyBuffer in IoBuffer was not supported.");
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
        if (value > _capacity) {
            throw new ArgumentError("The IoBuffer was limited by OutOfBounds. It must be limit <= capacity.");
        }
        _limit = value;
        if (_position > _limit) _position = _limit;
        if (_mark > _limit) _mark = -1;
        return this;
    }

    /**
     * @inheritDoc
     */
    public function positionTo(value:uint):IBuffer {
        if (value > _limit)
            throw new ArgumentError("Invalid position to.");
        _position = value;
        if (_mark > _position) _mark = -1;
        return this;
    }

    /**
     * @inheritDoc
     */
    public function rewind():IBuffer {
        _position = 0;
        _mark = -1;
        return this;
    }

    /**
     * Tells whether or not this buffer is backed by an accessible byte array.
     * @return <tt>true</tt> if, and only if, this buffer is backed by an array
     *         and is not read only.
     */
    public function hasArray():Boolean {
        return (_bytes != null) && !readOnly;
    }

    /**
     * @inheritDoc
     */
    public function putBoolean(value:Boolean, pos:int = -1):IBufferOutput {
        pos < 0 ? pos = nextIndex() : checkIndex(pos);
        _bytes.position = ix(pos);
        _bytes.writeBoolean(value);
        return this;
    }

    /**
     * @inheritDoc
     */
    public function putByte(value:int, pos:int = -1):IBufferOutput {
        pos < 0 ? pos = nextIndex(1) : checkIndex(pos, 1);
        _bytes.position = ix(pos);
        _bytes.writeByte(value);
        return this;
    }

    /**
     * @inheritDoc
     */
    public function putByteArray(bytes:ByteArray, offset:uint = 0, length:uint = 0):IBufferOutput {
        checkBounds(offset, length, bytes.length);
        if (length > remaining)
            throw new RangeError();
        _bytes.position = ix(_position);
        _position += length;
        _bytes.writeBytes(bytes, offset, length);
        return this;
    }

    /**
     * @inheritDoc
     */
    public function putDouble(value:Number, pos:int = -1):IBufferOutput {
        pos < 0 ? pos = nextIndex(8) : checkIndex(pos, 8);
        _bytes.position = ix(pos);
        _bytes.writeDouble(value);
        return this;
    }

    /**
     * @inheritDoc
     */
    public function putFloat(value:Number, pos:int = -1):IBufferOutput {
        pos < 0 ? pos = nextIndex(4) : checkIndex(pos, 4);
        _bytes.position = ix(pos);
        _bytes.writeFloat(value);
        return this;
    }

    /**
     * @inheritDoc
     */
    public function putShort(value:int, pos:int = -1):IBufferOutput {
        pos < 0 ? pos = nextIndex(2) : checkIndex(pos, 2);
        _bytes.position = ix(pos);
        _bytes.writeShort(value);
        return this;
    }

    /**
     * @inheritDoc
     */
    public function putInt(value:int, pos:int = -1):IBufferOutput {
        pos < 0 ? pos = nextIndex(4) : checkIndex(pos, 4);
        _bytes.position = ix(pos);
        _bytes.writeInt(value);
        return this;
    }

    /**
     * @inheritDoc
     */
    public function putUnsignedInt(value:uint, pos:int = -1):IBufferOutput {
        pos < 0 ? pos = nextIndex(4) : checkIndex(pos, 4);
        _bytes.position = ix(pos);
        _bytes.writeUnsignedInt(value);
        return this;
    }

    /**
     * @inheritDoc
     */
    public function putLong(value:Number, pos:int = -1):IBufferOutput {
        if (isNaN(value)) throw new ArgumentError("Invalid value to write as Long.");
        pos < 0 ? pos = nextIndex(8) : checkIndex(pos, 8);
        _bytes.position = ix(pos);

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
            // Determines the object bytes length.
            var b:ByteArray = new ByteArray;
            b.endian = endian;
            b.writeObject(value);
            b.position = 0;

            pos < 0 ? pos = nextIndex(b.length) : checkIndex(pos, b.length);
            _bytes.position = ix(pos);
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
            // Determines the byte length.
            var b:ByteArray = new ByteArray();
            b.endian = endian;
            b.writeMultiByte(value, charset);
            b.position = 0;
            pos < 0 ? pos = nextIndex(b.length) : checkIndex(pos, b.length);
            _bytes.position = ix(pos);
            _bytes.writeBytes(b, 0, b.length);
        }
        return this;
    }

    /**
     * @inheritDoc
     */
    public function putPrefixedString(value:String, prefixLength:uint = 2, charset:String = null, pos:int = -1):IBufferOutput {
        if (null == value)
            value = "";

        if (!prefixLength || prefixLength == 3 || prefixLength > 4) {
            throw new ArgumentError("Invalid prefix length!");
        }
        null == charset ? charset = 'utf-8' : false;

        // Determines the byte length of value.
        var b:ByteArray = new ByteArray;
        b.endian = endian;
        b.writeMultiByte(value, charset);
        b.position = 0;

        pos < 0 ? pos = nextIndex(b.length + prefixLength) : checkIndex(pos, b.length + prefixLength);
        _bytes.position = ix(pos);

        switch (prefixLength) {
            case 1:
                _bytes.writeByte(b.length & 0xFF);
                break;
            case 2:
                _bytes.writeShort(b.length & 0xFFFF);
                break;
            case 4:
                _bytes.writeUnsignedInt(b.length);
                break;
        }
        _bytes.writeBytes(b, 0, b.length);
        return this;
    }

    /**
     * Writes a <tt>IoBuffer</tt> to this instance.
     *
     * @param buffer The specified <tt>IoBuffer</tt> to write.
     * @return This instance for chaining.
     */
    public function put(buffer:IoBuffer):IoBuffer {
        if (buffer == this) {
            throw new ArgumentError();
        }
        var n:uint = buffer.remaining;
        if (n > remaining) {
            throw new RangeError();
        }

        var pos:uint = buffer.position;
        buffer.positionTo(0);
        var bytes:ByteArray = buffer.getByteArray(pos, n);

        putByteArray(bytes, 0, bytes.length);
        return this;
    }

    /** @private */
    public function toString(limit:uint = 0):String {
        if (!limit || !_bytes) {
            return 'IoBuffer[pos=' + position + ', lim=' + limit + ', cap=' + capacity + ']';
        } else {
            return 'IoBuffer[heap=' + toHexString(this.array, limit) + ']';
        }
    }

    /** @private */
    protected function ix(i:int):int {
        return _offset + i;
    }

    /** @private */
    protected function constructsByHMPLCO(hb:ByteArray, mark:int, pos:uint, lim:uint, cap:uint, off:uint):void {
        constructsByMPLCHO(mark, pos, lim, cap, hb, off);
    }

    /**
     * Checks the given index against the limit, throwing an RangeError if its
     * not smaller than the limit or is smaller than zero.
     *
     * @param i The specified index.
     * @param nb The specified index of byte-array (optional).
     * @return  the specified index.
     */
    internal function checkIndex(i:uint, nb:uint = 1):int {
        if (i >= limit || nb > limit - i)
            throw new RangeError();
        return i;
    }

    /** @private */
    internal function markValue():int {
        return _mark;
    }

    /** @private */
    internal final function nextIndex(nb:uint = 1):int {
        if (nb > limit - position)
            throw new RangeError();
        var p:int = position;
        _position += nb;
        return p;
    }

    /** @private */
    internal function constructsByBase(mark:int, pos:uint, lim:uint, cap:uint):void {
        this._capacity = cap;
        limitTo(lim);
        positionTo(pos);
        if (mark > 0) {
            if (mark > pos)
                throw new ArgumentError("mark > position: (" + mark + " > " + pos + ")");
            _mark = mark;
        }
    }

    /** @private */
    internal function constructsByMPLCHO(mark:int, pos:uint, lim:uint, cap:uint, hb:ByteArray, off:int):void {
        constructsByBase(mark, pos, lim, cap);
        this._bytes = hb;
        this._offset = off;
    }

    /** @private */
    internal function constructsByMPLC(mark:int, pos:uint, lim:uint, cap:uint):void {
        constructsByMPLCHO(mark, pos, lim, cap, null, 0);
    }

    /** @private */
    internal function constructsByCL(cap:uint, lim:uint):void {
        constructsByMPLCHO(-1, 0, lim, cap, new ByteArray, 0);
    }

    /** @private */
    internal function constructsByHOL(hb:ByteArray, off:int, len:int):void {
        constructsByMPLCHO(-1, off, off + len, hb.length, hb, 0);
    }

    /** @private */
    internal function clone():IoBuffer {
        return new IoBuffer(BUF);
    }

}
}
// vim:ft=as3
