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

import flash.events.IEventDispatcher;

/**
 * This class provide the basic functionality required by the logging framework for a target implementation.
 * It handles the validation of filter expressions and provides a default level property.
 * No implementation of the <code>LogEvent()</code> method is provided.
 * <br/>
 * The <tt>AbstractTarget</tt> was duplicated from <tt>mx.logging.AbstractTarget</tt>.
 */
public class AbstractTarget implements ILoggingTarget {

    /**
     * Creates an AbstractTarget instance.
     */
    public function AbstractTarget() {
        super();
    }

    /**
     * @private
     */
    private var _loggerCount:uint = 0;

    /**
     * @private
     * Storage for the filters property.
     */
    private var _filters:Array = ["*"];

    /**
     * @inheritDoc
     */
    public function get filters():Array {
        return _filters;
    }

    /**
     * @private
     * This method will make sure that all of the filter expressions specified are valid, and will throw
     * <code>InvalidFilterError</code> if any are not.
     */
    public function set filters(value:Array):void {
        if (value && value.length) {
            // a valid filter value will be fully qualified or have a wildcard in it. The wild card can only be located
            // at the end of the expression. valid examples xx*, xx.*, *
            var filter:String;
            var index:int;
            var _length:uint = value.length;

            for (var i:uint = 0; i < _length; i++) {
                filter = value[i];
                // check for invalid characters
                if (Log.hasIllegalCharacters(filter)) {
                    throw new Error("Invalid characters.");
                }

                index = filter.indexOf("*");

                if (index >= 0 && index != filter.length -1) {
                    throw new Error("Places characters.");
                }
            }
        } else {
            // if null was specified then default to all.
            value = ["*"];
        }

        if (_loggerCount > 0) {
            Log.removeTarget(this);
            _filters = value;
            Log.addTarget(this);
        } else {
            _filters = value;
        }
    }

    /**
     * @private
     * Storage for the id property.
     */
    private var _id:String;

    [Inspectable(category="General")]

    /**
     * Provides access to the id of this target.
     * The id is assigned at runtime by the mxml compiler if used as an mxml tag, or internally if used within
     * a script block.
     */
    public function get id():String {
        return _id;
    }

    /**
     * @private
     * Storage for the level property.
     */
    private var _level:int = LogEventLevel.ALL;

    /**
     * Provides access to the level this target is currently set at.
     */
    public function get level():int {
        return _level;
    }

    /**
     * @private
     */
    public function set level(value:int):void {
        // A change of level may impact the target level for Log.
        Log.removeTarget(this);
        _level = value;
        Log.addTarget(this);
    }

    /**
     * Sets up this target with the specified logger.
     *
     * @param logger The ILogger that this target should listen to.
     */
    public function addLogger(logger:ILogger):void {
        if (logger) {
            _loggerCount++;
            if (logger is IEventDispatcher)
                IEventDispatcher(logger).addEventListener(LogEvent.LOG, logHandler, false, 0, true);
        }
    }

    /**
     * Stops this target from receiving events from the specified logger.
     *
     * @param logger The ILogger that this target should ignore.
     */
    public function removeLogger(logger:ILogger):void {
        if (logger) {
            _loggerCount++;
            if (logger is IEventDispatcher)
                IEventDispatcher(logger).removeEventListener(LogEvent.LOG, logHandler);
        }
    }

    /**
     * This method handles a <code>LogEvent</code> from an associated logger.
     * A target uses this method to translate the event into the appropriate
     * format for transmission, storage, or display.
     * This method will be called only if the event's level is in range of the
     * target's level.
     *
     * @param event An event from an associated logger.
     */
    public function logEvent(event:Object):void {
    }

    /**
     * @private
     * This method will call the <code>LogEvent</code> method if the level of the event is appropriate for the current
     * level.
     */
    private function logHandler(event:LogEvent):void {
        if (event.level >= level) {
            logEvent(event);
        }
    }

}
}
// vim:ft=as3
