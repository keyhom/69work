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

package _69.network.session {

import _69.core.api.IFuture;
import _69.network.api.IWriteRequest;

/**
 * The write request created by the <tt>IoSession</tt>'s write method, which is
 * transmitted through the filter chain and finish as a socket write. <br/>
 *
 * We store the original message into this data structure, along the associated
 * potentially modified message if the original message gets encoded during the
 * process.<br/>
 *
 * Note that when we always ends with the message being a ByteArray when we reach
 * the socket. <br/>
 *
 * We also keep a <tt>IFuture</tt> into this data structure to inform the caller
 * about the write completion.
 *
 * @author keyhom
 */
public class DefaultWriteRequest implements IWriteRequest {

    /**
     * Creates a WriteRequest instance.
     */
    public function DefaultWriteRequest(originMessage:Object) {
        this._message = originMessage;
        this._originMessage = originMessage;
    }

    /** @private */
    private var _message:Object;

    /**
     * @inheritDoc
     */
    public function get message():Object {
        return _message;
    }

    /** @private */
    private var _originMessage:Object;

    /**
     * @inheritDoc
     */
    public function get originMessage():Object {
        return _originMessage;
    }

    /** @private */
    private var _future:IFuture;

    /**
     * @inheritDoc
     */
    public function get future():IFuture {
        return _future;
    }

    /**
     * @private
     */
    public function toString():String {
        var sb:String = '';
        sb += 'WriteRequest[';

        if (null != future) {
            sb += 'Future: ' + future + ', ';
        } else {
            sb += 'No future, ';
        }

        if (null != _originMessage) {
            sb += 'Original Message: \'' + _originMessage + '\', ';
        } else {
            sb += 'No Original Message, ';
        }

        if (null != message) {
            sb += 'Encoded message: \'' + _message + '\'';
        } else {
            sb += 'No encoded message';
        }

        sb += ']';
        return sb;
    }

    /** @private */
    $69internal function setMessage(message:Object):void {
        this._message = message;
    }

    $69internal function setFuture(future:IFuture):void {
        this._future = future;
    }
}
}

namespace $69internal = "http://p.keyhom.org/69/";

// vim:ft=as3
