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

package _69.network.filter.codec {

import _69.network.api.IWriteRequest;
import _69.network.api.IoChainController;
import _69.network.api.IoSession;
import _69.network.codec.IProtocolDecoder;
import _69.network.codec.IProtocolEncoder;
import _69.network.codec.IStateProtocolDecoder;
import _69.network.codec.IStateProtocolEncoder;
import _69.network.filter.IoFilterAdapter;
import _69.network.session.DefaultWriteRequest;

import flash.errors.IllegalOperationError;

/**
 * An <tt>IoFilter</tt> which translates binary or protocol specific data into message objects and vice vera using <tt>ProtocolCodecFactory<tt>, <tt>ProtocolEncoder</tt>, <tt>ProtocolDecoder</tt>.
 *
 * @author keyhom
 */
public class ProtocolCodecFilter extends IoFilterAdapter {

    /** Key for session attribute holding the encoder. */
    private static const ENCODER:String = "__$$INTERNAL_ENCODER$$__";
    /** Key for session attribute holding the decoder. */
    private static const DECODER:String = "__$$INTERNAL_DECODER$$__";

    /**
     * Creates an new ProtocolFilter instance.
     */
    public function ProtocolCodecFilter(encoder:IProtocolEncoder, decoder:IProtocolDecoder) {
        if (null == encoder) throw new ArgumentError("null encoder");
        if (null == decoder) throw new ArgumentError("null decoder");

        this._encoder = encoder;
        this._decoder = decoder;
    }

    /** @private */
    private var _encoder:IProtocolEncoder;
    /** @private */
    private var _decoder:IProtocolDecoder;

    /**
     * @inheritDoc
     */
    override public function messageReceived(session:IoSession, message:Object, chain:IoChainController):void {
        var state:Object = getDecodingState(session);

        // Loop until the decoder cannot decode more.
        var msg:Object = null;
        try {
            msg = _decoder.decode(message, state);
            if (msg != null) {
                chain.callNextFilter(session, msg);
            }
        } catch (e:Error) {
            throw e;
        }
    }

    /**
     * @inheritDoc
     */
    override public function messageWritting(session:IoSession, message:IWriteRequest, chain:IoChainController):void {
        var encoded:Object = _encoder.encode(message.message, getEncodingState(session));
        var request:DefaultWriteRequest = message as DefaultWriteRequest;
        if (!request) {
            throw new IllegalOperationError("The message must extends from the DefaultWriteRequest.");
        }
        request.$69internal::setMessage(encoded);
        chain.callNextFilter(session, request);
    }

    /**
     * @inheritDoc
     */
    override public function sessionOpened(session:IoSession):void {
        // Initialize the encoder and decoder state.
        var encoderState:Object = null;
        var decoderState:Object = null;

        if (_encoder is IStateProtocolEncoder) {
            encoderState = IStateProtocolEncoder(_encoder).createEncoderState();
        }

        if (_decoder is IStateProtocolDecoder) {
            decoderState = IStateProtocolDecoder(_decoder).createDecoderState();
        }

        session[ENCODER] = encoderState;
        session[DECODER] = decoderState;
    }

    /**
     * @inheritDoc
     */
    override public function sessionClosed(session:IoSession):void {
        _decoder.finishDecode(getDecodingState(session));
    }

    /** @private */
    private function getDecodingState(session:IoSession):Object {
        return session[DECODER];
    }

    /** @private */
    private function getEncodingState(session:IoSession):Object {
        return session[ENCODER];
    }

}
}

namespace $69internal = "http://p.keyhom.org/69/";
// vim:ft=as3
