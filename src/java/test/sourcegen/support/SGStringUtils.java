package test.sourcegen.support;

/**
 * @Class Name : SGStringUtils.java
 * @Description : String Utilities for Source Generator
 * @author SangJoon Kim
 * @since 2012. 4. 30.
 * @version 1.0
 * @see 
 *
 * @Modification Information
 * <pre>
 *    Date                Changer         Comment
 *  ===========    =========    ===========================
 *  2012. 4. 30. by SangJoon Kim: initial version
 * </pre>
 */

public class SGStringUtils {
    /**
     * Capitalize a <code>String</code>, changing the first letter to upper case
     * as per {@link Character#toUpperCase(char)}. No other letters are lower.
     * 
     * @param str
     *            the String to capitalize, may be <code>null</code>
     * @return the capitalized String, <code>null</code> if null
     */
    public static String capitalize(String str) {
        if (str == null || str.length() == 0) {
            return str;
        }
        return changeFirstCharacterCase(str, true);
    }

    /**
     * Uncapitalize a <code>String</code>, changing the first letter to lower
     * case as per {@link Character#toLowerCase(char)}. No other letters are
     * changed.
     * 
     * @param str
     *            the String to uncapitalize, may be <code>null</code>
     * @return the uncapitalized String, <code>null</code> if null
     */
    public static String uncapitalize(String str) {
        return changeFirstCharacterCase(str, false);
    }
    

    private static String changeFirstCharacterCase(String str,
            boolean capitalize) {
        if (str == null || str.length() == 0) {
            return str;
        }
        StringBuffer buf = new StringBuffer(str.length());
        if (capitalize) {
            buf.append(Character.toUpperCase(str.charAt(0)));
        } else {
            buf.append(Character.toLowerCase(str.charAt(0)));
        }
        buf.append(str.substring(1));
        return buf.toString();
    }
    
    
    public static String replace(String source, char ch, String replace) {
        return replace(source, ch, replace, -1);
    }

    public static String replace(String source, char ch, String replace, int max) {
        return replace(source, ch + "", replace, max);
    }

    public static String replace(String source, String original, String replace) {
        return replace(source, original, replace, -1);
    }

    public static String replace(String source, String original,
            String replace, int max) {
        if (null == source)
            return null;
        int nextPos = 0; //
        int currentPos = 0; //
        int len = original.length();
        StringBuffer result = new StringBuffer(source.length());
        while ((nextPos = source.indexOf(original, currentPos)) != -1) {
            result.append(source.substring(currentPos, nextPos));
            result.append(replace);
            currentPos = nextPos + len;
            if (--max == 0) {
                break;
            }
        }
        if (currentPos < source.length()) {
            result.append(source.substring(currentPos));
        }
        return result.toString();
    }
}
