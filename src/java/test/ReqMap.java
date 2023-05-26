package test;

import java.lang.reflect.Method;

import org.springframework.core.io.Resource;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;
import org.springframework.core.type.ClassMetadata;
import org.springframework.core.type.classreading.CachingMetadataReaderFactory;
import org.springframework.core.type.classreading.MetadataReader;
import org.springframework.web.bind.annotation.RequestMapping;

import foren.framework.utils.ArrayUtil;
import foren.framework.utils.ObjUtils;


/**
 * @Class Name : ReqMap.java
 * @Description : !!! Describe Class
 * @author SangJoon Kim
 * @since 2012-10-10
 * @version 1.0
 * @see
 * 
 * @Modification Information
 * 
 *               <pre>
 *    Date                Changer         Comment
 *  ===========    =========    ===========================
 *  2012-10-10 by SangJoon Kim: initial version
 * </pre>
 */

public class ReqMap {

    public static void main(String args[]) throws Exception {
        PathMatchingResourcePatternResolver resolver = new PathMatchingResourcePatternResolver();
        Resource[] rs1 = resolver.getResources("/unipass/cm/**/*Controller.class");
        Resource[] rs2 = resolver.getResources("/unipass/rm/**/*Controller.class");
         Resource[] rs = (Resource[]) ArrayUtil.addAll(rs1, rs2);
        String insStr = "INSERT INTO TRA_CM.Z_REQUEST_MAP ( CLASS_NAME, METHOD_NAME, PATH_NAME, SERVLET_NAME) VALUES ( ";

        for (Resource r : rs) {
            MetadataReader mr = new CachingMetadataReaderFactory().getMetadataReader(r);

            ClassMetadata cmd = mr.getClassMetadata();

            Class cls = Class.forName(cmd.getClassName());
            
            Method[] methods = cls.getMethods();
           out("\n" + cmd.getClassName());
            for (Method method : methods) {
                RequestMapping rmAnnotation = method.getAnnotation(RequestMapping.class);
                if (rmAnnotation != null) {
                        String url =  rmAnnotation.value()[0];
                        String tUrl = url.substring(0,url.lastIndexOf('/'));
                        String strDo = url.substring(url.lastIndexOf('/')+1);
                    //out(insStr + "'" +cls.getName() + "', '" + method.getName() + "', '" +tUrl +"', '" + strDo +"' );");
                    out(   "      " +tUrl +"/" + strDo +", " +  method.getName() );
                }
            }

        }
    }

    public static void out(Object object) {
        System.out.println(ObjUtils.getSafeString(object));
    }
}
