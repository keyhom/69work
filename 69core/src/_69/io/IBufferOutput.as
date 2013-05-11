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

import flash.utils.ByteArray;

/**
 * The <tt>IBufferOutput</tt> interface provides a set of methods for writing binary data. This interface is the I/O
 * counterpart to the <tt>IBufferInput</tt> interface, which reads binary data.
 * The <tt>IBufferOutput</tt> is implemented by the <tt>IoBuffer</tt> class.
 * <p/>
 * All <tt>IBufferInput</tt> and <tt>IBufferOutput</tt> operations are "bigEndian" by default, and are non-blocking.
 * Sign extension matters only when you read data, not when you write it.
 *
 * @author keyhom
 */
public interface IBufferOutput extends IBuffer {

    /**
     * Writes a Boolean value.
     * A single byte is written according to the <code>value</code> parameter, either 1 if <tt>true</tt> or 0 if <tt>false</tt>.
     *
     * @param value A Boolean value determining which byte is written. If the parameter is <tt>true</tt>, 1 is written; if <tt>false</tt>, 0 is written.
     * @param pos The position to write to. If the <code>pos</code> is &lt; 0, the <code>value</code> will being written at current position; if the <code>pos</code> is &gt; 0, the <code>value</code> will being written at the specified position by the supplied.
     * @return This buffer for chaining.
     */
    function putBoolean(value:Boolean, pos:int = -1):IBufferOutput;

    /**
     * Writes a byte. The low 8 bits of the parameter are used; the high 24 bits are ignored.
     *
     * @param value A byte value as an integer.
     * @param pos The position to write to. If the <code>pos</code> is &lt; 0, the <code>value</code> will being written at current position; if the <code>pos</code> is &gt; 0, the <code>value</code> will being written at the specified position by the supplied.
     * @return This buffer for chaining.
     */
    function putByte(value:int, pos:int = -1):IBufferOutput;

    /**
     * Writes a sequence of bytes from the specified byte array, bytes, starting at the byte specified by offset (using a zero-based index) with a length specified by <code>length</code>, into the buffer.
     *
     * @param bytes The byte array to write.
     * @param offset A zero-based index specifying the position into the array to begin writting.
     * @param length An unsigned integer specifying how far into the buffer to write.
     * @return This buffer for chaining.
     */
    function putByteArray(bytes:ByteArray, offset:uint = 0, length:uint = 0):IBufferOutput;

    /**
     * Writes an IEEE 754 double-precision (64-bit) floating point number.
     *
     * @param value A double-precision (64-bit) floating point number to write.
     * @param pos The position to write to. If the <code>pos</code> is &lt; 0, the <code>value</code> will being written at current position; if the <code>pos</code> is &gt; 0, the <code>value</code> will being written at the specified position by the supplied.
     * @return This buffer for chaining.
     */
    function putDouble(value:Number, pos:int = -1):IBufferOutput;

    /**
     * Writes an IEEE 754 single-precision (32-bit) floating point number.
     *
     * @param value A single-precision (32-bit) floating point number to write.
     * @param pos The position to write to. If the <code>pos</code> is &lt; 0, the <code>value</code> will being written at current position; if the <code>pos</code> is &gt; 0, the <code>value</code> will being written at the specified position by the supplied.
     * @return This buffer for chaining.
     */
    function putFloat(value:Number, pos:int = -1):IBufferOutput;

    /**
     * Writes a 16-bit integer. The low 16 bits of the parameter are used; the high 16 bits are ignored.
     *
     * @param value A byte value as an 16-bit integer.
     * @param pos The position to write to. If the <code>pos</code> is &lt; 0, the <code>value</code> will being written at current position; if the <code>pos</code> is &gt; 0, the <code>value</code> will being written at the specified position by the supplied.
     * @return This buffer for chaining.
     */
    function putShort(value:int, pos:int = -1):IBufferOutput;

    /**
     * Writes a 32-bit signed integer.
     *
     * @param value A byte value as a signed integer.
     * @param pos The position to write to. If the <code>pos</code> is &lt; 0, the <code>value</code> will being written at current position; if the <code>pos</code> is &gt; 0, the <code>value</code> will being written at the specified position by the supplied.
     * @return This buffer for chaining.
     */
    function putInt(value:int, pos:int = -1):IBufferOutput;

    /**
     * Writes a 32-bit unsigned integer.
     *
     * @param value A byte value as a unsigned integer.
     * @param pos The position to write to. If the <code>pos</code> is &lt; 0, the <code>value</code> will being written at current position; if the <code>pos</code> is &gt; 0, the <code>value</code> will being written at the specified position by the supplied.
     * @return This buffer for chaining.
     */
    function putUnsignedInt(value:uint, pos:int = -1):IBufferOutput;

    /**
     * Writes a 64-bit signed integer.
     *
     * @param value A byte value as a 64-bit signed integer.
     * @param pos The position to write to. If the <code>pos</code> is &lt; 0, the <code>value</code> will being written at current position; if the <code>pos</code> is &gt; 0, the <code>value</code> will being written at the specified position by the supplied.
     * @return This buffer for chaining.
     */
    function putLong(value:Number, pos:int = -1):IBufferOutput;

    /**
     * Writes a 64-bit unsigned integer.
     *
     * @param value A byte value as a 64-bit unsigned integer.
     * @param pos The position to write to. If the <code>pos</code> is &lt; 0, the <code>value</code> will being written at current position; if the <code>pos</code> is &gt; 0, the <code>value</code> will being written at the specified position by the supplied.
     * @return This buffer for chaining.
     */
    function putUnsignedLong(value:Number, pos:int = -1):IBufferOutput;

    /**
     * Writes an object to the buffer, in AMF serialized format.
     *
     * @param value The object ot serialized.
     * @param pos The position to write to. If the <code>pos</code> is &lt; 0, the <code>value</code> will being written at current position; if the <code>pos</code> is &gt; 0, the <code>value</code> will being written at the specified position by the supplied.
     * @return This buffer for chaining.
     */
    function putObject(value:Object, pos:int = -1):IBufferOutput;

    /**
     * Writes a multi-byte string to the buffer, using the specified character set.
     *
     * @param value The string value to be written.
     * @param charset The string denoting the character set to use. Possible character set strings include "shift-jis", "cn-gb", "iso-8859-1", and others.
     * @param pos The position to write to. If the <code>pos</code> is &lt; 0, the <code>value</code> will being written at current position; if the <code>pos</code> is &gt; 0, the <code>value</code> will being written at the specified position by the supplied.
     * @return This buffer for chaining.
     */
    function putString(value:String, charset:String = null, pos:int = -1):IBufferOutput;

    /**
     * Writes a multi-byte string which contains a prefixed length to the buffer. The length of the string in bytes is written first, as a integer specified by the <code>prefixLength</code>, following by the bytes representing the characters of the string.
     *
     * @param value The string value to write to the buffer.
     * @param prefixLength The prefix length to be specified.
     * @param charset The string denoting the character set to use. Possible character set strings include "shift-jis", "cn-gb", "iso-8859-1", and others.
     * @param pos The position to write to. If the <code>pos</code> is &lt; 0, the <code>value</code> will being written at current position; if the <code>pos</code> is &gt; 0, the <code>value</code> will being written at the specified position by the supplied.
     * @return This buffer for chaining.
     */
    function putPrefixedString(value:String, prefixLength:uint = 2, charset:String = null, pos:int = -1):IBufferOutput;

}
}
// vim:ft=as3