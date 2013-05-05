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

import _69.core.api.IElement;
import _69.core.api.IElementVisitor;
import _69.core.api.ILifecycle;

import flash.errors.IllegalOperationError;

/**
 * The <tt>IQueue</tt> implementation by using the original AS3's <tt>Vector.<Object></tt>.
 *
 * @author keyhom
 */
public class VectorQueue implements IQueue, IElement, ILifecycle {

    /**
     * Creates a VectorQueue instance.
     */
    public function VectorQueue(container:* = null) {
        if (null != container)
            this._context = container;
    }

    /** @private */
    private var _disposed:Boolean = false;

    /**
     * @inheritDoc
     */
    public function get size():uint {
        if (_disposed || !_context) return 0;
        return context.length;
    }

    /**
     * @inheritDoc
     */
    public function get empty():Boolean {
        return size == 0;
    }

    /** @private */
    private var _context:Vector.<Object>;

    /**
     * The container of this queue.
     */
    protected function get context():Vector.<Object> {
        if (!_disposed && !_context) {
            _context = new Vector.<Object>();
        }
        return _context;
    }

    /**
     * @inheritDoc
     */
    public function offer(element:*):IQueue {
        if (null == element)
            throw new ArgumentError("Invalid element.");

        checkDisposed();
        context.push(element);
        return this;
    }

    /**
     * @inheritDoc
     */
    public function poll():* {
        checkDisposed();
        return empty ? null : context.shift();
    }

    /**
     * @inheritDoc
     */
    public function peek():* {
        checkDisposed();
        return empty ? null : context[0];
    }

    /**
     * @inheritDoc
     */
    public function clear():void {
        if (_disposed) return;

        if (_context) {
            _context = null;
        }
    }

    /**
     * @inheritDoc
     */
    public function acceptVisit(visitor:IElementVisitor):void {
        if (visitor)
            visitor.visitAny(this);
    }

    /**
     * @inheritDoc
     */
    public function init():void {
        if (!_disposed) {
            _context = context; // Call the context property to initialize.
        }
    }

    /**
     * @inheritDoc
     */
    public function destory():void {
        if (!_disposed) {
            try {
                clear();
            } catch (ignore:*) {
            } finally {
                _context = null;
                _disposed = true; // Make sure the context will never be recreated.
            }
        }
    }

    /**
     * Indicates if this queue is disposed to operating.
     */
    protected function checkDisposed():void {
        if (_disposed) {
            throw new IllegalOperationError("The VectorQueue is disposed.");
        }
    }
}
}
// vim:ft=as3
