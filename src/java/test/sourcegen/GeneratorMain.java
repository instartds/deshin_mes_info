package test.sourcegen;

/**
 * @Class Name : Generator.java
 * @Description : !!! Describe Class
 * @author SangJoon Kim
 * @since 2012. 4. 27.
 * @version 1.0
 * @see 
 *
 * @Modification Information
 * <pre>
 *    Date                Changer         Comment
 *  ===========    =========    ===========================
 *  2012. 4. 27. by SangJoon Kim: initial version
 * </pre>
 */

public class GeneratorMain {
    public static void main(String args[]) throws Exception {
        System.out.println("==============");
        
        Generator gen = new Generator();
        gen.generate();
        System.out.println("======End========");
       
    }
}
