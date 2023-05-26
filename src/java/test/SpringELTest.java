package test;

import java.util.HashMap;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.expression.MapAccessor;
import org.springframework.expression.ExpressionParser;
import org.springframework.expression.spel.standard.SpelExpressionParser;
import org.springframework.expression.spel.support.StandardEvaluationContext;

import foren.framework.utils.ObjUtils;


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

public class SpringELTest {
    private final static Logger logger = LoggerFactory.getLogger(SpringELTest.class);

    public static void main(String args[]) throws Exception {
        
        Map param = new HashMap();
        param.put("cnt", "a");

        StandardEvaluationContext elContext = new StandardEvaluationContext(param);
        elContext.addPropertyAccessor(new MapAccessor());
        
        String exp1 =  null;
        exp1 =  "'Hello World'";
        exp1=  "'a' == cnt ";
        String exp2 =  "'b' == cnt ";
//        Expression exp = parser.parseExpression(exp1);
        ExpressionParser spelParser = new SpelExpressionParser();
        out(" >>> " +spelParser.parseExpression(exp1).getValue(elContext) );
        out(" >>> " +spelParser.parseExpression(exp2).getValue(elContext) );
        
        
    }
    
    public static void out(String object) {
        System.out.println(ObjUtils.getSafeString(object));
    }
}
