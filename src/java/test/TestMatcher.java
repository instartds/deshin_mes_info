package test;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import test.jasper.JasperTest;

/**
 * @Class Name : JasperTest.java
 * @Description : !!! Describe Class
 * @author SangJoon Kim
 * @since Jun 25, 2012
 * @version 1.0
 * @see
 * 
 * @Modification Information
 * 
 *               <pre>
 *    Date                Changer         Comment
 *  ===========    =========    ===========================
 *  Jun 25, 2012 by SangJoon Kim: initial version
 * </pre>
 */

public class TestMatcher {
    private final static Logger logger = LoggerFactory.getLogger(JasperTest.class);


    public static void main(String args[]) throws Exception {

        validateValue("12345");
        validateValue("ABCD");
        validateValue("A1234");
        validateValue("A1234");
        validateValue("123");
        validateValue("1234");
        validateValue("A 34");
        validateValue(null);
        String t = "2012MRKD12345";
        System.out.println( t.substring(2));
               
        
    }
    
    public static void validateValue(String codes) {
        Pattern p = Pattern.compile ("[A-Z[0-9]]{4}");
        Matcher matcher = p.matcher (codes);
        System.out.println("[" +codes + "] is " + matcher.matches() + ".");
    }
}
