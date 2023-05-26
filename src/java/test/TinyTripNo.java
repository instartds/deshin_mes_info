package test;


/**
 * @Class Name : TinyTripNo.java
 * @Description : !!! Describe Class
 * @author SangJoon Kim
 * @since 2012-10-29
 * @version 1.0
 * @see
 * 
 * @Modification Information
 * 
 *               <pre>
 *    Date                Changer         Comment
 *  ===========    =========    ===========================
 *  2012-10-29 by SangJoon Kim: initial version
 * </pre>
 */

public class TinyTripNo {

    public static void main(String args[]) throws Exception {
        String prefix = "INSERT INTO CM_BARCODE_SHORTEN (bar_code) values ('";
        String suffix = "');";
        for (int i = 0; i < 12; i++) {
            System.out.println( prefix + getShortCodeFromURL( 16) +suffix );
        }
    }




    public static String getShortCodeFromURL( int length) {

        //String charSet = "0123456789ABCDEFGHIJKLMNPQRSTUVWXYZ";
        String charSet = "0123456789abcdefghijklmnpqrstuvwxyz";
        
        StringBuffer t = new StringBuffer();
        for (int i = 0; i <length ; i++) {
            Double num =  Math.random() * charSet.length();
            t.append(charSet.charAt( num.intValue() ));
        }

        return t.toString();
    }
}
