package test;

import java.net.Inet4Address;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @Class Name : TestIP.java
 * @Description : !!! Describe Class
 * @author SangJoon Kim
 * @since 2012-11-21
 * @version 1.0
 * @see 
 *
 * @Modification Information
 * <pre>
 *    Date                Changer         Comment
 *  ===========    =========    ===========================
 *  2012-11-21 by SangJoon Kim: initial version
 * </pre>
 */

public class TestIP {
    private final static Logger logger = LoggerFactory.getLogger(TestIP.class);


    public static void main(String args[]) throws Exception {
        String ip = Inet4Address.getLocalHost().getHostAddress();
        System.out.println("IP : " + ip);
    }
}
