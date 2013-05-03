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

package $69.logging.targets {

/**
 * Provides a logger target that uses the global <code>trace()</code> method to output log messages.
 * <br/>
 * The <tt>TraceTarget</tt> was duplicated from <tt>mx.logging.targets.TraceTarget</tt>.
 */
public class TraceTarget extends LineFormattedTarget {

    /**
     * Creates a TraceTarget instance.
     *
     * <p>Constructs an instance of a logger target that will send the log data to the global <code>trace()</code>
     * method. All output will be directed to flashlog.txt by default.</p>
     */
    public function TraceTarget() {
        super();
    }

    /**
     * @inheritDoc
     */
    override protected function internalLog(message:String):void {
        trace(message);
    }
}
}
// vim:ft=as3
