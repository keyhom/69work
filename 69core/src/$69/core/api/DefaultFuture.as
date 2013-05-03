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

package $69.core.api {


/**
 * The default implementation of <tt>IFuture</tt>.
 *
 * @author keyhom
 */
public class DefaultFuture implements IFuture, IElement, ILifecycle {

    /**
     * Creates a DefaultFuture instance.
     */
    public function DefaultFuture() {
        init();
    }

    /** @private */
    private var _callbacks:Vector.<Function>;

    /** @private */
    private var _result:Object;

    /**
     * @inheritDoc
     */
    public function get result():Object {
        return _result;
    }

    /** @private */
    private var _completed:Boolean = false;

    /**
     * @inheritDoc
     */
    public function get completed():Boolean {
        return _completed;
    }

    /**
     * @inheritDoc
     */
    public function get error():Error {
        return result as Error;
    }

    /**
     * Completes the future..
     */
    public function complete(result:Object):void {
        this._result = result;
        _completed = true;

        // notify all callbacks.
        if (_callbacks) {
            for each(var l:Function in _callbacks) {
                try {
                    l.call(null, this);
                } catch (ignore:*) {
                }
            }

        }

        // Destory this future.
        destory();
    }

    /**
     * @inheritDoc
     * @return
     */
    public function toString():String {
        return "DefaultFuture of [" + result + "]";
    }

    /**
     * @inheritDoc
     * @param func
     */
    public function callLater(func:Function):void {
        if (null != func) {
            _callbacks.push(func);
        }
    }

    /**
     * @inheritDoc
     * @param visitor
     */
    public function acceptVisit(visitor:IElementVisitor):void {
        if (visitor) {
            visitor.visitAny(this);
        }
    }

    /**
     * @inheritDoc
     */
    public function init():void {
        if (!_callbacks) {
            _callbacks = new Vector.<Function>;
        }
    }

    /**
     * @inheritDoc
     */
    public function destory():void {
        _result = null;
        _callbacks = null;
    }

}
}
// vim:ft=as3
