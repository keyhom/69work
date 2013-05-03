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

import $69.core.api.IElementVisitor;

import flash.events.EventDispatcher;

/**
 * The <tt>LogLogger</tt> was duplicated from mx.logging.LogLogger.
 */
public class LogLogger extends EventDispatcher implements ILogger {

    /**
     * Creates a LogLogger instance.
     */
    public function LogLogger(category:String) {
        super();

        _category = category;
    }

    /**
     * @private
     * Storage for the category property.
     */
    private var _category:String;

    /**
     * @inheritDoc
     */
    public function get category():String {
        return _category;
    }

    /**
     * @inheritDoc
     */
    public function log(level:int, message:String, ...rest):void {
        // we don't want to allow people to log message at the Log.Level.ALL level, so throw a RTE if they do.
        if (level < LogEventLevel.DEBUG) {
            throw new ArgumentError("Level limited.");
        }

        if (hasEventListener(LogEvent.LOG)) {
            // replace all of the parameters in the msg string
            for (var i:int = 0; i < rest.length; i++) {
                message = message.replace(new RegExp("\\{" + i + "\\}", "g"), rest[i]);
            }

            dispatchEvent(new LogEvent(message, level));
        }
    }

    /**
     * @inheritDoc
     */
    public function debug(message:String, ...rest):void {
        if (hasEventListener(LogEvent.LOG)) {
            // replace all of the parameters in the msg string.
            for (var i:int = 0; i < rest.length; i++) {
                message = message.replace(new RegExp("\\{" + i + "\\}", "g"), rest[i]);
            }

            dispatchEvent(new LogEvent(message, LogEventLevel.DEBUG));
        }
    }

    /**
     * @inheritDoc
     */
    public function error(message:String, ...rest):void {
        if (hasEventListener(LogEvent.LOG)) {
            // replace all of the parameters in the msg string.
            for (var i:int = 0; i < rest.length; i++) {
                message = message.replace(new RegExp("\\{" + i + "\\}", "g"), rest[i]);
            }

            dispatchEvent(new LogEvent(message, LogEventLevel.ERROR));
        }
    }

    /**
     * @inheritDoc
     */
    public function fatal(message:String, ...rest):void {
        if (hasEventListener(LogEvent.LOG)) {
            // replace all of parameters in the msg string.
            for (var i:int = 0; i < rest.length; i++) {
                message = message.replace(new RegExp("\\{" + i + "\\}", "g"), rest[i]);
            }

            dispatchEvent(new LogEvent(message, LogEventLevel.FATAL));
        }
    }

    /**
     * @inheritDoc
     */
    public function info(message:String, ...rest):void {
        if (hasEventListener(LogEvent.LOG)) {
            // replace all of parameters in the msg string.
            for (var i:int = 0; i < rest.length; i++) {
                message = message.replace(new RegExp("\\{" + i + "\\}", "g"), rest[i]);
            }

            dispatchEvent(new LogEvent(message, LogEventLevel.INFO));
        }
    }

    /**
     * @inheritDoc
     */
    public function warn(message:String, ...rest):void {
        if (hasEventListener(LogEvent.LOG)) {
            // replace all of parameters in the msg string.
            for (var i:int = 0; i < rest.length; i++) {
                message = message.replace(new RegExp("\\{" + i + "\\}", "g"), rest[i]);
            }

            dispatchEvent(new LogEvent(message, LogEventLevel.WARN));
        }
    }

    /**
     * @inheritDoc
     */
    public function acceptVisit(visitor:IElementVisitor):void {
        if (visitor)
            visitor.visitAny(this);
    }

}
}
// vim:ft=as3
