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

package $69.network.filter.logging {

import $69.logging.ILogger;
import $69.logging.LogLogger;
import $69.logging.LoggerFactory;
import $69.network.api.IoChainController;
import $69.network.api.IoSession;
import $69.network.filter.IoFilterAdapter;

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
        _logger.log(_logLevel, "RECEIVED  - [{0}] {1}", session, message);
        super.messageReceived(session, message, chain);
    }

    /**
     * @inheritDoc
     */
    override public function messageWritting(session:IoSession, message:Object, chain:IoChainController):void {
        _logger.log(_logLevel, "WRITTING  - [{0}] {1}", session, message);
        super.messageWritting(session, message, chain);
    }

    /**
     * @inheritDoc
     */
    override public function messageSent(session:IoSession, message:Object):void {
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
