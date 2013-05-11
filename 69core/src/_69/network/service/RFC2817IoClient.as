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

package _69.network.service {

import _69.net.RFC2817Socket;

import flash.net.Socket;

/**
 * Represents a <tt>IoClient</tt> implementation that its <tt>Socket</tt> is the
 * <tt>RFC2817Socket</tt> instead, for pass-through a HTTP proxy to communicate
 * with the remote end-point.
 *
 * @author keyhom
 */
public class RFC2817IoClient extends DefaultIoClient {

    /**
     * Creates a RFC2817IoClient instance.
     */
    public function RFC2817IoClient(proxyHost:String, proxyPort:uint = 0) {
        super();
        if (null == proxyHost || proxyHost.length == 0)
            proxyHost = '127.0.0.1';
        if (0 == proxyPort)
            throw new ArgumentError("proxyPort assign to '0' was not allowed.");

        this._proxyHost = proxyHost;
        this._proxyPort = proxyPort;
    }

    /** @private */
    private var _proxyHost:String;
    /** @private */
    private var _proxyPort:uint;

    /**
     * @inheritDoc
     */
    override protected function newSocket():Socket {
        var socks:RFC2817Socket = new RFC2817Socket();
        socks.setProxyInfo(_proxyHost, _proxyPort);
        return socks;
    }

}
}
// vim:ft=as3
