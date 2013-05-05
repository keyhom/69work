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

/**
 * The <tt>IBuffer</tt> interface represents a container for data of a specified
 * primitive type.
 * <p/>
 * A buffer is linear, finite sequence of elements of a specific primitive type.
 * Aside from its content, the essential properties of a buffer are its limit,
 * position:
 * <ul>
 *     <li>A buffer's limit is the index of the first element that should not be
 *     read or written. A buffer's limit is never negative and is never greater
 *     than its length.</li>
 *     <li>A buffer's position is the index of the next element to be read or
 *     written. A buffer's position is never negative and is never greater than
 *     its limit.</li>
 * </ul>
 * There is one subclass of this class for each non-boolean primitive type.
 *
 * @author keyhom
 */
public interface IBuffer {

    /**
     * The limit of this buffer.
     */
    function get limit():uint ;

    /**
     * The position of this buffer.
     */
    function get position():uint ;

    /**
     * The number of elements between the current position and the limit.
     */
    function get remaining():uint;

    /**
     * Tells whether or not this buffer is read-only.
     */
    function get readOnly():Boolean;

    /**
     * Clears this buffer. The position is set to zero, the limit is set to zero,
     * and the mark is discarded.
     * Invoke this method before using a sequence of channel-read or put operations
     * to fill this buffer. For example:
     * <pre>
     *     buf.clear();     // Prepare buffer for reading.
     *     in.read(buf);    // Read data.
     * </pre>
     * This method does not actually erase the data in the buffer, but it's named as
     * if it did because it will most often be used in situations in which that might
     * as well be the case.
     *
     * @return This buffer instance for chaining.
     */
    function clear():IBuffer;

    /**
     * Flips this buffer. The limit is set to the current position and then the position
     * is set to zero. If the mark is defined then it's discarded. After a sequence of
     * channel-read or put operations, invoke this method to prepare for a sequence of
     * channel-write or relative get operations. For example:
     * <pre>
     *     buf.put(magic);      // Prepend buffer.
     *     in.read(buf);        // Read data into rest of buffer.
     *     buf.flip();          // Flip buffer.
     *     out.write(buf);      // Write header + data to channel.
     * </pre>
     * This method is often used in conjunction with the <tt>IBuffer#compact()</tt> method
     * when transferring data from one place to another.
     *
     * @return This buffer for chaining.
     */
    function flip():IBuffer;

    /**
     * Resets this buffer's position to the previously-marked position.
     * Invoking this method neither changes nor discards the mark's value.
     *
     * @return This buffer for chaining.
     */
    function reset():IBuffer;

    /**
     * Sets this buffer's mark at its position.
     *
     * @return This buffer for chaining.
     */
    function mark():IBuffer;

    /**
     * Sets this buffer's limit. If the position is larger than the new limit then
     * it is set to the new limit. If the mark is defined and larger than the new
     * limit then it is discarded.
     *
     * @param value The new limit value; must be non-negative and no larger than this
     * buffer's length.
     * @return This buffer for chaining.
     */
    function limitTo(value:uint):IBuffer;

    /**
     * Sets this buffer's position. If the mark is defined and larger than the new
     * position then it's discarded.
     *
     * @param value The new position value; must be non-negative and no larger than
     * the current limit.
     *
     * @return This buffer for chaining.
     */
    function positionTo(value:uint):IBuffer;

    /**
     * Rewinds this buffer. The position is set to zero and the mark is discarded.
     * Invoke this method before a sequence of channel-write or get operations,
     * assuming that the limit has already been set appropriately. For example:
     * <pre>
     *     out.write(buf);          // Write remaining data.
     *     buf.rewind();            // Rewind buffer.
     *     buf.get(bytes);          // Copy data into array.
     * </pre>
     *
     * @return This buffer for chaining.
     */
    function rewind():IBuffer;

}
}
// vim:ft=as3
