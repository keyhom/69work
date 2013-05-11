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

package _69.network.filter.logging {

import _69.io.IoBuffer;
import _69.logging.ILogger;
import _69.logging.LogLogger;
import _69.logging.LoggerFactory;
import _69.network.api.IWriteRequest;
import _69.network.api.IoChainController;
import _69.network.api.IoSession;
import _69.network.filter.IoFilterAdapter;

import flash.utils.ByteArray;

/**
 * The <tt>LoggingFilter</tt> that implements from <tt>IoFilter</tt> logging to filter for the <tt>IoSession</tt>s's events.
 *
 * @author keyhom
 */
public class LoggingFilter extends IoFilterAdapter {

    /** The default logger used for that if the <tt>LoggingFilter</tt> wasn't submit a specified <tt>name</tt>. */
    private static const _DEFAULT_LOGGER:ILogger = LoggerFactory.getLogger("$69-NETWORK");

    /**
     * Creates a LoggingFilter instance.
     */
    public function LoggingFilter(name:String = null, level:int = 4) {
        if ((null == name || !name.length) && (level == 4)) {
            _logger = _DEFAULT_LOGGER;
            return;
        }

        _logger = new LogLogger(name);
        this._logLevel = level;
    }

    /** @private */
    private var _logger:ILogger;
    /** @private */
    private var _logLevel:int = 4;

    /**
     * @inheritDoc
     */
    override public function sessionCreated(session:IoSession):void {
        _logger.log(_logLevel, "CREATED   - [{0}]", session);
        super.sessionCreated(session);
    }

    /**
     * @inheritDoc
     */
    override public function sessionOpened(session:IoSession):void {
        _logger.log(_logLevel, "OPENED    - [{0}]", session.toString(true));
        super.sessionOpened(session);
    }

    /**
     * @inheritDoc
     */
    override public function sessionClosed(session:IoSession):void {
        _logger.log(_logLevel, "CLOSED    - [{0}]", session.toString(true));
        super.sessionClosed(session);
    }

    /**
     * @inheritDoc
     */
    override public function messageReceived(session:IoSession, message:Object, chain:IoChainController):void {
        if (message is ByteArray) {
            message = IoBuffer.toHexString(message as ByteArray);
        }

        _logger.log(_logLevel, "RECEIVED  - [{0}] {1}", session, message);
        super.messageReceived(session, message, chain);
    }

    /**
     * @inheritDoc
     */
    override public function messageWritting(session:IoSession, message:IWriteRequest, chain:IoChainController):void {
        var msg:Object = message.message;
        if (message.message is ByteArray) {
            msg = IoBuffer.toHexString(message.message as ByteArray);
        }
        _logger.log(_logLevel, "WRITTING  - [{0}] {1}", session, msg);
        super.messageWritting(session, message, chain);
    }

    /**
     * @inheritDoc
     */
    override public function messageSent(session:IoSession, message:Object):void {
        if (message is ByteArray) {
            message = IoBuffer.toHexString(message as ByteArray);
        }

        _logger.log(_logLevel, "SENT      - [{0}] {1}", session, message);
        super.messageSent(session, message);
    }

    /**
     * @inheritDoc
     */
    override public function errorCaught(session:IoSession, e:Error):void {
        _logger.log(_logLevel, "EXCEPTION - [{0}] [{1}] {2}:{3} - {4}", session, e.errorID, e.name, e.message, e.getStackTrace());
        super.errorCaught(session, e);
    }

}
}
// vim:ft=as3
