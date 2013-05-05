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
 * The <tt>LogEventLevel</tt> was duplicated from <tt>mx.logging.LogEventLevel</tt>.
 */
public final class LogEventLevel {

    /**
     * Designates events that are very harmful and will eventually lead to application failure.
     */
    public static const FATAL:int = 1000;
    /**
     * Designates error events that might still allow the application to continue running.
     */
    public static const ERROR:int = 8;
    /**
     * Designates events that could be harmful to the application operation.
     */
    public static const WARN:int = 6;
    /**
     * Designates informational messages that highlight the progress of the application at coarse-grained level.
     */
    public static const INFO:int = 4;
    /**
     * Designates informational level messages that are fine grained and most helpful when debugging an application.
     */
    public static const DEBUG:int = 2;
    /**
     * Tells a target to process all messages.
     */
    public static const ALL:int = 0;

}
}
// vim:ft=as3
