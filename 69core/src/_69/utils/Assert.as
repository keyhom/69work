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

package _69.utils {

import flash.errors.IllegalOperationError;

/**
 * The <tt>Assert</tt> represents the assertion for the actionscript runtime to determine the specific condition, such as typeof assertion, Boolean assertion etc.
 *
 * @author keyhom
 */
public class Assert {

    /** @private */
    public static function isTrue(value:*):void {
        if (!(value is Boolean && Boolean(value)))
            throw new AssertError();
    }

    /** @private */
    public static function isFalse(value:*):void {
        isTrue(!value);
    }

    /** @private */
    public static function typeOf(obj:Object, ...rest):void {
        if (rest.length > 0) {
            for each(var clazz:Class in rest){
                if (obj is clazz) {
                    return;
                }
            }
        }
        throw new AssertError();
    }

    /**
     * @private
     */
    public function Assert() {
        throw new IllegalOperationError("Instance the Assert wasn't allowed!");
    }
}
}

/** @private */
class AssertError extends Error {

    /**
     * Creates an AssertError instance.
     */
    public function AssertError(message:String = null, errorID:Number = 0) {
        if (!message) message = "Assert failed.";
        super(message, errorID);
    }

}
// vim:ft=as3

