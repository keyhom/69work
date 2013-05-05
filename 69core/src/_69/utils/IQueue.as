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

package _69.utils {

/**
 * The <tt>IQueue</tt> that represents a queue provided the <b>FIFO</b> implementation by default.
 *
 * @author keyhom
 */
public interface IQueue {

    /**
     * Pops in stack.
     *
     * @param element The element to pop.
     * @return The <tt>IQueue</tt> reference for chaining.
     */
    function offer(element:*):IQueue;

    /**
     * Pops out the element in stack.
     *
     * @return The element which is pop out.
     */
    function poll():*;

    /**
     * Peeks out the element in stack, this operation wouldn't pop out the element.
     *
     * @return The element which to peek.
     */
    function peek():*;

    /**
     * The size of the queue.
     *
     * @return The number of this queue's size.
     */
    function get size():uint;

    /**
     * Indicates if the queue is empty now.
     */
    function get empty():Boolean;

    /**
     * Cleans up this queue.
     */
    function clear():void;

}
}
// vim:ft=as3
