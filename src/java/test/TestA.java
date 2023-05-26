package test;

/**
 * @Class Name : TestA.java
 * @Description : !!! Describe Class
 * @author SangJoon Kim
 * @since Aug 2, 2012
 * @version 1.0
 * @see 
 *
 * @Modification Information
 * <pre>
 *    Date                Changer         Comment
 *  ===========    =========    ===========================
 *  Aug 2, 2012 by SangJoon Kim: initial version
 * </pre>
 */

public class TestA {
    public TestA() {
        String a = InStatic.getA();
    }
    
    static class InStatic {
        private static InStatic instance;
        
        public InStatic() {
            instance = new InStatic();
        }
        
        public String getT() {
            return "A";
        }
        
        public static String getA() {
            String t = instance.getA();
            return "static";
        }
    }
    
}
