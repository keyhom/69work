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

package $69.core.api {

/**
 * The base interface that represents a future event handle.
 * In general, this implementation was contains the result or error when the specified async-work had been finished.
 *
 * @author keyhom
 */
public interface IFuture {

    /**
     * Tells if the specified computation work is completed.
     * Both the result or error was assigned, the completed should be <tt>true</tt> by default.
     */
    function get completed():Boolean;

    /**
     * The result object if the specified computation work is completed, or null otherwise.
     */
    function get result():Object;

    /**
     * The error caught if the specified computation work is caught, or null otherwise.
     */
    function get error():Error;

    /**
     * The callback function registered to this future and being called when this future is computed completed.
     *
     * @param func The callback function.
     */
    function callLater(func:Function):void;

}
}
// vim:ft=as3