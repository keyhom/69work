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

/**
 * The <tt>Log</tt> was duplicated from <tt>mx.logging.Log</tt>.
 */
public class Log {

    /**
     * @private
     * Sentinal value for the target log level to indicate no logging.
     */
    private static var NONE:int = int.MAX_VALUE;
    /**
     * @private
     * The most verbose supported log level among registered targets.
     */
    private static var _targetLevel:int = NONE;
    /**
     * @private
     * An associative Vector of existing loggers keyed by category.
     */
    private static var _loggers:Array;
    /**
     * @private
     * Vector of targets tha should be searched any time a new logger is created.
     */
    private static var _targets:Array = [];

    /**
     * Indicates whether a fatal level log event will be processed by a log target.
     *
     * @return true if a fatal level log event will be logged, false otherwise.
     */
    public static function isFatal():Boolean {
        return _targetLevel <= LogEventLevel.FATAL;
    }

    /**
     * Indicates whether a error level log event will be processed by a log target.
     *
     * @return true if a error level log event will be logged, false otherwise.
     */
    public static function isError():Boolean {
        return _targetLevel <= LogEventLevel.ERROR;
    }

    /**
     * Indicates whether a warn level log event will be processed by a log target.
     *
     * @return true if a warn level log event will be logged, false otherwise.
     */
    public static function isWarn():Boolean {
        return _targetLevel <= LogEventLevel.WARN;
    }

    /**
     * Indicates whether a info level log event will be processed by a log target.
     *
     * @return true if a info level log event will be logged, false otherwise.
     */
    public static function isInfo():Boolean {
        return _targetLevel <= LogEventLevel.INFO;
    }

    /**
     * Indicates whether a debug level log event will be processed by a log target.
     *
     * @return true if a debug level log event will be logged, false otherwise.
     */
    public static function isDebug():Boolean {
        return _targetLevel <= LogEventLevel.DEBUG;
    }

    /**
     * Allows the specified target to begin receiving notification of log events.
     *
     * @param target The specific target that should capture log events.
     */
    public static function addTarget(target:ILoggingTarget):void {
        if (target) {
            const filters:Array = target.filters;

            // need to find what filters this target matches and set
            // the specified target as a listener for that logger.
            for (var i:String in _loggers) {
                if (categoryMatchInFilterList(i, filters)) {
                    target.addLogger(ILogger(_loggers[i]));
                }
            }
            // if we found a match all is good, otherwise we need to put the target
            // in a waiting queue in the event that a logger is created that this
            // target cares about.
            _targets.push(target);

            if (_targetLevel == NONE) {
                _targetLevel = target.level;
            } else if (target.level < _targetLevel) {
                _targetLevel = target.level;
            }
        } else {
            throw new ArgumentError("Invalid target of logging.");
        }
    }

    /**
     * Stops the specified target from receiving notification of log events.
     *
     * @param target The specific target that should capture log events.
     */
    public static function removeTarget(target:ILoggingTarget):void {
        if (target) {
            const filters:Array = target.filters;
            // Disconnect this target from any matching loggers.
            for (var i:String in _loggers) {
                if (categoryMatchInFilterList(i, filters)) {
                    target.removeLogger(ILogger(_loggers[i]));
                }
            }
            // Remove the target.
            for (var j:int = 0; j < _targets.length; j++) {
                if (target == _targets[i]) {
                    _targets.splice(j, 1);
                    j--;
                }
            }
            resetTargetLevel();
        }
        else {
            throw new ArgumentError("Invalid target of logging.");
        }
    }

    /**
     * Returns the logger associated with the specified category.
     * If the category given dose not exist a new instance of a logger will be returned and associated
     * with that category.
     *
     * @param category The category of the logger that should be returned.
     * @return An instance of a logger object for the specified name. If the name does not exists, a new
     *          instance with the specified name is returned.
     */
    public static function getLogger(category:String):ILogger {
        checkCategory(category);

        if (!_loggers) {
            _loggers = [];
        }

        // get the logger for the specified category or create one if it doesn't exist.
        var result:ILogger = _loggers[category];
        if (result == null) {
            result = new LogLogger(category);
            _loggers[category] = result;
        }

        // check to see if there are any targets waiting for this logger.
        var target:ILoggingTarget;

        for (var i:int = 0; i < _targets.length; i++) {
            target = ILoggingTarget(_targets[i]);

            if (categoryMatchInFilterList(category, target.filters))
                target.addLogger(result);
        }

        return result;
    }

    /**
     * This method removes all of the current loggers from the cache.
     * Subsquent calls to the <code>getLogger</code> method return new instances of loggers rather than any previous
     * instances with the same category.
     * This method is intended for use in debugging only.
     */
    public static function flush():void {
        _loggers = [];
        _targets = [];
        _targetLevel = NONE;
    }

    /**
     * This method checks the specified string value for illegal characters.
     *
     * @param value The String to check for illegal characters.
     * @return true if there are any illegal characters found, false otherwise.
     */
    public static function hasIllegalCharacters(value:String):Boolean {
        return value.search(/[\[\]~\$\^&\\(\)\{\}\+?\/=`!@#%,:;'"<>\s]/) != -1;
    }

    /**
     * This method checks that the specified category matches any of the filter expressions provided in the
     * <code>filters</code> Array.
     *
     * @param category The category to match against.
     * @param filters A list of Strings to check category against.
     * @return true if the specified category matches any of the filter expressions found in the filters list,
     *          false otherwise.
     */
    private static function categoryMatchInFilterList(category:String, filters:Array):Boolean {
        var filter:String;
        var index:int = -1;
        for (var i:int = 0; i < filters.length; i++) {
            filter = filters[i];
            // first check to see if we need to do a partial match
            // do we have an asterisk?
            index = filter.indexOf('*');

            if (index == 0) {
                return true;
            }

            index = index < 0 ? index = category.length : index - 1;

            if (category.substring(0, index) == filter.substring(0, index))
                return true;
        }
        return false;
    }

    /**
     * This method will ensure that a valid category string has been specified.
     * If the category is not valid an <code>InvalidCategoryError</code> will be thrown.
     * @private
     */
    private static function checkCategory(category:String):void {
        if (category == null || category.length == 0) {
            throw new Error("Invalid length of category.");
        }

        if (hasIllegalCharacters(category) || category.indexOf("*") != -1) {
            throw new Error("Invalid character of category.");
        }
    }

    /**
     * @private
     * This method resets the Log's target level to the most verbose log level for the currently registered targets.
     */
    private static function resetTargetLevel():void {
        var minLevel:int = NONE;
        for (var i:int = 0; i < _targets.length; i++) {
            if (minLevel == NONE || _targets[i].level < minLevel) {
                minLevel = _targets[i].level;
            }
        }
        _targetLevel = minLevel;
    }

    /**
     * Returns a string value representing the level specified.
     *
     * @param level The level a string is desired for.
     * @return The level specified in English.
     */
    public static function getLevelString(level:int):String {
        return LogEvent.getLevelString(level);
    }

}
}
// vim:ft=as3
