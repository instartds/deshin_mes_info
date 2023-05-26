package test.etc;


/**
 * @Class Name : CamelCaseTest.java
 * @Description : !!! Describe Class
 * @author SangJoon Kim
 * @since 2012. 5. 23.
 * @version 1.0
 * @see
 * 
 * @Modification Information
 * 
 *               <pre>
 *    Date                Changer         Comment
 *  ===========    =========    ===========================
 *  2012. 5. 23. by SangJoon Kim: initial version
 * </pre>
 */

public class CamelCaseTest {
    public static void main(String args[]) throws Exception {
            String[] test = {"LINE_NO", "CNTNR_NO", "CRG_REF_NO", "MBL_NO", "TYPE_OF_CNTNR", "CNTNR_SIZE", "SEAL_NO_1", "SEAL_NO_2", "SEAL_NO_3", "FRGHT_INDCTR", "NO_OF_PCKG", "PCKG_UNIT", "GRS_WGHT", "GRS_WGHT_UNIT", "GRS_VLUM", "GRS_VLUM_UNIT", "PLACE_OF_DLVRY"};
            for(String t : test) {
                System.out.println( t + " => "  + convert2CamelCase(t) );
            }
            
    }
    
    public static String convert2CamelCase(String underScore) {

        // '_' 가 나타나지 않으면 이미 camel case 로 가정함.
        // 단 첫째문자가 대문자이면 camel case 변환 (전체를 소문자로) 처리가
        // 필요하다고 가정함. --> 아래 로직을 수행하면 바뀜
        if (underScore.indexOf('_') < 0
            /*&& Character.isLowerCase(underScore.charAt(0) ) */) {
            return underScore;
        }
        StringBuilder result = new StringBuilder();
        boolean nextUpper = false;
        int len = underScore.length();

        for (int i = 0; i < len; i++) {
            char currentChar = underScore.charAt(i);
            if (currentChar =='_'  ) {
                nextUpper = true;
            } else {
                if (nextUpper) {
                    result.append(Character.toUpperCase(currentChar));
                    nextUpper = false;
                } else {
                    result.append(Character.toLowerCase(currentChar));
                }
            }
        }
        return result.toString();
    }
}
