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

import _69.logging.targets.TraceTarget;

import flash.errors.IllegalOperationError;
import flash.utils.Dictionary;
import flash.utils.getQualifiedClassName;

/**
 * Represents a factory that provides creating the <tt>ILogger</tt> for the specified target.
 *
 * @author keyhom
 */
public class LoggerFactory {

    /**
     * Designates to specified a logging target.
     */
    public static var TARGET:ILoggingTarget = createDefaultLoggingTarget();
    /** Designates to cache the <tt>ILogger</tt> instances. */
    private static var _LOGGERS:Dictionary = new Dictionary(true);

    /**
     * Gets an implementation of ILogger.
     * <br/>
     * If the supplied obj is a <tt>Class</tt>, mean that this <tt>ILogger</tt> will being cached in LoggerFactory until the class was releases.
     *
     * @param obj The Class or Name of the specified.
     * @return An ILogger instance.
     */
    public static function getLogger(obj:Object):ILogger {
        if (obj is String) {
            return newLogger(String(obj));
        } else if (obj is Class) {
            var qname:String = getQualifiedClassName(obj);
            if (!(obj in _LOGGERS)) {
                _LOGGERS[obj] = newLogger(qname);
            }
            return _LOGGERS[obj] as ILogger;
        }

        throw new ArgumentError("Invalid class or name supplied for LoggerFactory.");
    }

    /**
     * @private
     */
    protected static function newLogger(qname:String):ILogger {
        const logger:ILogger = new LogLogger(qname);
        TARGET.addLogger(logger);
        return logger;
    }

    /** @private */
    private static function createDefaultLoggingTarget():ILoggingTarget {
        var l:TraceTarget = new TraceTarget();
        l.includeCategory = true;
        l.includeDate = false;
        l.includeTime = true;
        l.includeLevel = true;
        l.level = LogEventLevel.ALL;
        return l;
    }

    /**
     * Creates a LoggerFactory instance.
     */
    public function LoggerFactory() {
        throw new IllegalOperationError("The LoggerFactory is a static class rejected to be instanced.");
    }
}
}
// vim:ft=as3
