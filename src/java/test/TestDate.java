package test;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import foren.framework.lib.calendar.MCalendar;


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

public class TestDate {


    public static void main(String args[]) throws Exception {
            String[] t = new String[] {"-7d","+7d","-1m", "+1m"};
            for(String d : t) {
                out (d, MCalendar.getDt(d));
            }
        
               
        
    }
    
    public static void out(String a, String b) {
        System.out.println("[" +a + "] is " +b+ ".");
    }
}
