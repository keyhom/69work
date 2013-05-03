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

package $69.logging {

import flash.events.Event;

/**
 * Represents the log information for a single logging event.
 * The logging system dispatches a single event each time a process requests information be logged.
 * This event can be captured by any object for storage or formatting.
 * <br/>
 * The <tt>LogEvent</tt> was duplicated <tt>from mx.logging.LogEvent</tt>.
 */
public class LogEvent extends Event {

    /**
     * Event type constant, identifies a logging event.
     */
    public static const LOG:String = "log";

    /**
     * Returns a string value representing the level specified.
     *
     * @param value The level a string is desired for.
     * @return The level specified in English.
     */
    public static function getLevelString(value:uint):String {
        switch (value) {
            case LogEventLevel.INFO:
                return "INFO";
            case LogEventLevel.DEBUG:
                return "DEBUG";
            case LogEventLevel.ERROR:
                return "ERROR";
            case LogEventLevel.WARN:
                return "WARN";
            case LogEventLevel.FATAL:
                return "FATAL";
            case LogEventLevel.ALL:
                return "ALL";
        }

        return "UNKNOWN";
    }

    /**
     * Creates a LogEvent instance.
     *
     * @param message String containing the log data.
     * @param level The level for this log event.
     */
    public function LogEvent(message:String = "", level:int = 0 /* LogEventLevel.ALL */) {
        super(LogEvent.LOG, false, false);

        this.message = message;
        this.level = level;
    }

    /**
     * Provides access to the level for this log event.
     */
    public var level:int;
    /**
     * Provides access to the message that was logged.
     */
    public var message:String;

    /**
     * @private
     */
    override public function clone():Event {
        return new LogEvent(message, /* type, */ level);
    }
}
}
// vim:ft=as3
