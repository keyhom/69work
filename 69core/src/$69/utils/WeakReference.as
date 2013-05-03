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

package $69.utils {

import $69.core.api.ILifecycle;

import flash.utils.Dictionary;

/**
 * Represents a Weak-Reference that provides a container for containing the target object by weak-reference storage.
 *
 * @author keyhom
 */
public final class WeakReference implements ILifecycle {

    /**
     * Creates a WeakReference instance.
     */
    public function WeakReference(value:* = null) {
        _o = new Dictionary(true);

        if (null != value) {
            this.value = value;
        }
    }

    /** @private */
    private var _o:Dictionary;

    /**
     * The value of this <tt>WeakReference</tt>.
     */
    public function get value():* {
        if (_o) {
            for (var k:* in _o) {
                return k;
            }
        }
        return null;
    }

    /** @private */
    public function set value(value:*):void {
        if (_o) {
            // Make sure to remove the previous value.
            if (!empty)
                clear();
            _o[value] = true;
        }
    }

    /**
     * Indicates if this <tt>WeakReference</tt> is empty.
     */
    public function get empty():Boolean {
        return null == value;
    }

    /**
     * Clears this <tt>WeakReference</tt>.
     */
    public function clear():void {
        if (_o) {
            for (var k:* in _o) {
                delete _o[k];
            }
        }
    }

    /**
     * @inheritDoc
     */
    public function toString():String {
        return "WeakReference [" + value + "]";
    }

    /**
     * @inheritDoc
     */
    public function init():void {
        // nothing to do.
    }

    /**
     * @inheritDoc
     */
    public function destory():void {
        clear();
        _o = null;
    }

}
}
// vim:ft=as3
