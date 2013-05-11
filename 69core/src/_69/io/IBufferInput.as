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
 * The <tt>IBufferInput</tt> interface provides a set of methods for reading
 * binary data. This interface is the I/O counterpart to the IBufferOutput
 * interface, which write binary data.
 *
 * All IBufferInput and IBufferOutput operations are "bigEndian" by default, and
 * are non-blocking. If insufficient data is available, an EOFError exception is
 * thrown. Use the <code>IBufferInput.byteAvailable</code> property to
 * determine how much data is available to read.
 *
 * Since extension matters only when you read data, not when you write it.
 *
 * @author keyhom
 */
public interface IBufferInput extends IBuffer {

    /**
     * Gets a Boolean value from the buffer.
     * <p/>
     * If the supplied <code>pos</code> is &lt; 0, represents to  move the current
     * position cursor after this. Otherwise, represents to peek the value at the
     * specified position, this will not move the position cursor.
     *
     * @param pos The specified position to peek if &gt; 0, or represents the
     *            current position if &lt; 0, the default value is -1.
     * @throws flash.errors.EOFError there is not sufficient data available to read.
     */
    function getBoolean(pos:int = -1):Boolean;

    /**
     * Gets a signed byte from the buffer.
     * <p/>
     * If the supplied <code>pos</code> is &lt; 0, represents to  move the current
     * position cursor after this. Otherwise, represents to peek the value at the
     * specified position, this will not move the position cursor.
     *
     * @param pos The specified position to peek if &gt; 0, or represents the
     *            current position if &lt; 0, the default value is -1.
     * @throws flash.errors.EOFError there is not sufficient data available to read.
     */
    function getByte(pos:int = -1):int;

    /**
     * Gets a signed 16-bit integer from the buffer.
     * <p/>
     * If the supplied <code>pos</code> is &lt; 0, represents to  move the current
     * position cursor after this. Otherwise, represents to peek the value at the
     * specified position, this will not move the position cursor.
     *
     * @param pos The specified position to peek if &gt; 0, or represents the
     *            current position if &lt; 0, the default value is -1.
     * @throws flash.errors.EOFError there is not sufficient data available to read.
     */
    function getShort(pos:int = -1):int;

    /**
     * Gets a signed 32-bit integer from the buffer.
     * <p/>
     * If the supplied <code>pos</code> is &lt; 0, represents to  move the current
     * position cursor after this. Otherwise, represents to peek the value at the
     * specified position, this will not move the position cursor.
     *
     * @param pos The specified position to peek if &gt; 0, or represents the
     *            current position if &lt; 0, the default value is -1.
     * @throws flash.errors.EOFError there is not sufficient data available to read.
     */
    function getInt(pos:int = -1):int;

    /**
     * Gets a signed 64-bit integer from the buffer.
     * <p/>
     * If the supplied <code>pos</code> is &lt; 0, represents to  move the current
     * position cursor after this. Otherwise, represents to peek the value at the
     * specified position, this will not move the position cursor.
     *
     * @param pos The specified position to peek if &gt; 0, or represents the
     *            current position if &lt; 0, the default value is -1.
     * @throws flash.errors.EOFError there is not sufficient data available to read.
     */
    function getLong(pos:int = -1):Number;

    /**
     * Gets an unsigned byte from the buffer.
     * <p/>
     * If the supplied <code>pos</code> is &lt; 0, represents to  move the current
     * position cursor after this. Otherwise, represents to peek the value at the
     * specified position, this will not move the position cursor.
     *
     * @param pos The specified position to peek if &gt; 0, or represents the
     *            current position if &lt; 0, the default value is -1.
     * @throws flash.errors.EOFError there is not sufficient data available to read.
     */
    function getUnsignedByte(pos:int = -1):uint ;

    /**
     * Gets an unsigned 16-bit integer from the buffer.
     * <p/>
     * If the supplied <code>pos</code> is &lt; 0, represents to  move the current
     * position cursor after this. Otherwise, represents to peek the value at the
     * specified position, this will not move the position cursor.
     *
     * @param pos The specified position to peek if &gt; 0, or represents the
     *            current position if &lt; 0, the default value is -1.
     * @throws flash.errors.EOFError there is not sufficient data available to read.
     */
    function getUnsignedShort(pos:int = -1):uint ;

    /**
     * Gets an unsigned 32-bit integer from the buffer.
     * <p/>
     * If the supplied <code>pos</code> is &lt; 0, represents to  move the current
     * position cursor after this. Otherwise, represents to peek the value at the
     * specified position, this will not move the position cursor.
     *
     * @param pos The specified position to peek if &gt; 0, or represents the
     *            current position if &lt; 0, the default value is -1.
     * @throws flash.errors.EOFError there is not sufficient data available to read.
     */
    function getUnsignedInt(pos:int = -1):uint ;

    /**
     * Gets an unsigned 64-bit integer from the buffer.
     * <p/>
     * If the supplied <code>pos</code> is &lt; 0, represents to  move the current
     * position cursor after this. Otherwise, represents to peek the value at the
     * specified position, this will not move the position cursor.
     *
     * @param pos The specified position to peek if &gt; 0, or represents the
     *            current position if &lt; 0, the default value is -1.
     * @throws flash.errors.EOFError there is not sufficient data available to read.
     */
    function getUnsignedLong(pos:int = -1):Number;

    /**
     * Gets the number of data bytes, specified by the length parameter, from
     * the buffer.
     * <p/>
     * If the supplied <code>pos</code> is &lt; 0, represents to  move the current
     * position cursor after this. Otherwise, represents to peek the value at the
     * specified position, this will not move the position cursor.
     *
     * @param bytes The byte array to get.
     * @param offset The offset of the specified byte array to get.
     * @param length The length of the byte array to get.
     * @throws flash.errors.EOFError there is not sufficient data available to read.
     */
    function getBytes(bytes:ByteArray, offset:uint = 0, length:uint = 0):void;

    /**
     * Gets the number of data bytes, specified by the length parameter, from
     * the buffer.
     * <p/>
     * If the supplied <code>pos</code> is &lt; 0, represents to  move the current
     * position cursor after this. Otherwise, represents to peek the value at the
     * specified position, this will not move the position cursor.
     *
     * @param offset The offset within the array of the first byte to be written.
     * @param length The length to get.
     * @throws flash.errors.EOFError there is not sufficient data available to read.
     */
    function getByteArray(offset:uint = 0, length:uint = 0):ByteArray;

    /**
     * Gets an IEEE 754 double-precision floating point number from the buffer.
     * <p/>
     * If the supplied <code>pos</code> is &lt; 0, represents to  move the current
     * position cursor after this. Otherwise, represents to peek the value at the
     * specified position, this will not move the position cursor.
     *
     * @param pos The specified position to peek if &gt; 0, or represents the
     *            current position if &lt; 0, the default value is -1.
     * @throws flash.errors.EOFError there is not sufficient data available to read.
     */
    function getDouble(pos:int = -1):Number;

    /**
     * Gets an IEEE 754 single-precision floating point number from the buffer.
     * <p/>
     * If the supplied <code>pos</code> is &lt; 0, represents to  move the current
     * position cursor after this. Otherwise, represents to peek the value at the
     * specified position, this will not move the position cursor.
     *
     * @param pos The specified position to peek if &gt; 0, or represents the
     *            current position if &lt; 0, the default value is -1.
     * @throws flash.errors.EOFError there is not sufficient data available to read.
     */
    function getFloat(pos:int = -1):Number;

    /**
     * Gets a multi-byte string of specified length from the buffer using the specified character set.
     * <p/>
     * If the supplied <code>pos</code> is &lt; 0, represents to  move the current
     * position cursor after this. Otherwise, represents to peek the value at the
     * specified position, this will not move the position cursor.
     *
     * @param pos The specified position to peek if &gt; 0, or represents the
     *            current position if &lt; 0, the default value is -1.
     * @param length The number of bytes from the buffer to read.
     * @param charset The string denoting the character set to use to interpret the bytes. Possible character set strings
     *                include "shift-jis", "cn-gb", "iso-8859-1", and others.
     * @return UTF-8 encoded string.
     * @throws flash.errors.EOFError There is not sufficient data available to read.
     */
    function getString(pos:int = -1, length:uint = 0, charset:String = null):String;

    /**
     * Gets a multi-type string of specified length which the value is got from the buffer by the specified <code>prefixLength</code> from the buffer using the specified character set.
     * <p/>
     * If the supplied <code>pos</code> is &lt; 0, represents to  move the current
     * position cursor after this. Otherwise, represents to peek the value at the
     * specified position, this will not move the position cursor.
     *
     * @param pos The specified position to peek if &gt; 0, or represents the
     *            current position if &lt; 0, the default value is -1.
     * @param prefixLength The length of the prefix's value to get.
     * @param charset The string denoting the character set to use to interpret the bytes. Possible character set strings
     *                include "shift-jis", "cn-gb", "iso-8859-1", and others.
     * @return UTF-8 encoded string.
     * @throws flash.errors.EOFError there is not sufficient data available to read.
     */
    function getPrefixedString(pos:int = -1, prefixLength:uint = 2, charset:String = null):String;

    /**
     * Gets an object from the buffer, encoded in AMF serialized format.
     * <p/>
     * If the supplied <code>pos</code> is &lt; 0, represents to  move the current
     * position cursor after this. Otherwise, represents to peek the value at the
     * specified position, this will not move the position cursor.
     *
     * @param pos The specified position to peek if &gt; 0, or represents the
     *            current position if &lt; 0, the default value is -1.
     * @return The de-serialized object
     * @throws flash.errors.EOFError there is not sufficient data available to read.
     */
    function getObject(pos:int = -1):Object;

}
}
// vim:ft=as3
