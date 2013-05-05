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

package _69.core.api {

/**
 * The base interface that represents a generic handler to run any logic.
 * A simple function <code>run(... rest):void</code> method defines in this handler.
 *
 * @author keyhom
 */
public interface IHandler {

    /**
     * Runs any logic by this method.
     *
     * @param rest The any arguments required.
     */
    function run(... rest):void;

}
}
// vim:ft=as3
