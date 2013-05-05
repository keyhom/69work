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

package _69.logging {

/**
 * All logger target implementations within the logging framework must implement this interface.
 * <br/>
 * The <tt>ILoggingTarget</tt> was duplicated from <tt>mx.logging.ILoggingTarget</tt>.
 */
public interface ILoggingTarget {

    /**
     * In addition to the <code>level</code> setting, filters are used to provide a psuedo-hierarchical mapping for
     * processing only those events for a given category.
     */
    function get filters():Array;

    /**
     * @private
     */
    function set filters(value:Array):void;

    /**
     * Provides access to the level this target is currently set at.
     */
    function get level():int;

    /**
     * @private
     */
    function set level(value:int):void;

    /**
     * Sets up this target with the specified logger.
     *
     * @param logger The ILogger that this target listens to.
     */
    function addLogger(logger:ILogger):void;

    /**
     * Stops this target from receiving events from the specified logger.
     *
     * @param logger The ILogger that this target ignores.
     */
    function removeLogger(logger:ILogger):void;

}
}
// vim:ft=as3
