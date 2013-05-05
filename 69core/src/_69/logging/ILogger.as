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

import _69.core.api.IElement;

/**
 * The <tt>ILogger</tt> that represents a logging facade, duplicated the logging message and delegate to the implementation target.
 * The <tt>ILogger</tt> was duplicated from mx.logging.ILogger.
 */
public interface ILogger extends IElement {

    /**
     * The category value for the logger.
     */
    function get category():String;

    /**
     * Logs the specified data at the given level.
     * <p>The String specified for logging can contain braces with an index indicating which additional parameter should
     * be inserted into the String before it is logged.
     * </p>
     *
     * @param level The level this information should be logged at.
     * @param message The information to log.
     * @param rest Additional parameters that can be substituted in the str parameter at each "{<code>x</code>}" location,
     *         where <code>x</code> in a integer (zero based) index value into the Array of values specified.
     */
    function log(level:int, message:String, ...rest):void;

    /**
     * Logs the specified data using the <code>LogLevel.DEBUG</code> level.
     * <code>LogLevel.DEBUG</code> designates informational level message that are fine grained and most helpful
     * when debugging an application.
     *
     * @param message The information to log.
     * @param rest Additional parameters that can be substituted in the str parameter.
     */
    function debug(message:String, ...rest):void;

    /**
     * Logs the specified data using the <code>LogLevel.ERROR</code> level.
     *
     * @param message The information to log.
     * @param rest Additional parameters that can be substituted in the str parameter.
     */
    function error(message:String, ...rest):void;

    /**
     * Logs the specified data using the <code>LogLevel.FATAL</code> level.
     *
     * @param message The information to log.
     * @param rest Additional parameters that can be substituted in the str parameter.
     */
    function fatal(message:String, ...rest):void;

    /**
     * Logs the specified data using the <code>LogLevel.INFO</code> level.
     *
     * @param message The information to log.
     * @param rest Additional parameters that can be substituted in the str parameter.
     */
    function info(message:String, ...rest):void;

    /**
     * Logs the specified data using the <code>LogLevel.WARN</code> level.
     *
     * @param message The information to log.
     * @param rest Additional parameters that can be substituted in the str parameter.
     */
    function warn(message:String, ...rest):void;

}
}
// vim:ft=as3
