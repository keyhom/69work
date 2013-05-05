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

package _69.network.filter {

import _69.network.api.IoChainController;
import _69.network.api.IoFilter;
import _69.network.api.IoSession;

/**
 * The <tt>IoFilterAdapter</tt> that implements from <tt>IoFilter</tt> with a empty implementation.
 *
 * @author keyhom
 */
public class IoFilterAdapter implements IoFilter {

    /**
     * Creates an IoFilterAdapter instance.
     */
    public function IoFilterAdapter() {
    }

    /**
     * @inheritDoc
     */
    public function sessionCreated(session:IoSession):void {
    }

    /**
     * @inheritDoc
     */
    public function sessionOpened(session:IoSession):void {
    }

    /**
     * @inheritDoc
     */
    public function sessionClosed(session:IoSession):void {
    }

    /**
     * @inheritDoc
     */
    public function messageReceived(session:IoSession, message:Object, chain:IoChainController):void {
        chain.callNextFilter(session, message);
    }

    /**
     * @inheritDoc
     */
    public function messageWritting(session:IoSession, message:Object, chain:IoChainController):void {
        chain.callNextFilter(session, message);
    }

    /**
     * @inheritDoc
     */
    public function messageSent(session:IoSession, message:Object):void {
    }

    /**
     * @inheritDoc
     */
    public function errorCaught(session:IoSession, e:Error):void {
    }

}
}
// vim:ft=as3
