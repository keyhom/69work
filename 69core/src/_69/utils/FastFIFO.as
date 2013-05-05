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
 * The <tt>FastFIFO</tt> that implements from <tt>IQueue</tt> represents a "Fast" FIFO queue.
 * The <tt>FastFIFO</tt> should be used at the situation that the queue contains huge elements.
 *
 * @author keyhom
 */
public class FastFIFO implements IQueue, IElement, ILifecycle {

    /**
     * Creates a FastFIFO instance.
     */
    public function FastFIFO() {
    }

    /** @private */
    private var _disposed:Boolean = false;
    /** The head index currently */
    private var _head:int = 0;
    /** The tail index currently. */
    private var _tail:int = 0;

    /**
     * @inheritDoc
     */
    public function get size():uint {
        if (_disposed || !_context) return 0;
        return (_tail - _head);
    }

    /**
     * @inheritDoc
     */
    public function get empty():Boolean {
        return size == 0;
    }

    /** @private */
    private var _context:Array;

    /**
     * The container of this queue.
     */
    protected function get context():Array {
        if (!_disposed && !_context) {
            _context = [];
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
        context[_tail++] = element;
        return this;
    }

    /**
     * @inheritDoc
     */
    public function poll():* {
        checkDisposed();
        if (_head >= size / 2) {
            _context = _context.slice(_head, _tail);
            _tail -= _head;
            _head = 0;
        }
        return empty ? null : context[_head++];
    }

    /**
     * @inheritDoc
     */
    public function peek():* {
        checkDisposed();
        return empty ? null : context[_head];
    }

    /**
     * @inheritDoc
     */
    public function clear():void {
        if (_disposed) {
            return;
        }

        if (_context)
            _context = null;
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
            _head = 0;
            _tail = 0;
            _context = context;
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
                _head = 0;
                _tail = 0;
                _context = null;
                _disposed = true;
            }
        }
    }

    /**
     * Indicates if this queue is disposed to operating.
     */
    protected function checkDisposed():void {
        if (_disposed) {
            throw new IllegalOperationError("The FastFIFO is disposed to operate.");
        }
    }
}
}
// vim:ft=as3
