package test.jasper;

import java.io.File;

import net.sf.jasperreports.engine.JasperCompileManager;
import net.sf.jasperreports.engine.JasperReport;
import net.sf.jasperreports.engine.design.JasperDesign;
import net.sf.jasperreports.engine.util.JRLoader;
import net.sf.jasperreports.engine.xml.JRXmlLoader;

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

public class JasperTest {

    public final static String JAVA_ROOT_PATH = "D:\\Foren\\_DEV\\workspace\\g3erp\\WebContent\\WEB-INF\\report\\hum960rkr";

    public static void main(String args[]) throws Exception {
        String fileName = JAVA_ROOT_PATH + "/hum960rkr.jasper";
        File jrxmlFile = new File(fileName);
        if (!jrxmlFile.exists()) {
            System.out.println("파일 not found");
        }
        //JasperDesign jasDesign = JRXmlLoader.load(fileName);
        JasperReport jasReport =(JasperReport)JRLoader.loadObject(jrxmlFile);
        System.out.println(jasReport.getClass());
//        JasperReport jasReport = JasperCompileManager.compileReport(jasDesign);
        // JasperReport jasReport = (JasperReport)
        // JRLoader.loadObject(FileUtils.openInputStream(jrxmlFile));
    }
}
