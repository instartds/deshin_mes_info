package test.jasper;

import java.io.File;

import net.sf.jasperreports.engine.JasperCompileManager;
import net.sf.jasperreports.engine.export.JRPdfExporter;
import test.TestUtil;

/**
 * @Class Name : JasperSubdataSourceExample.java
 * @Description : !!! Describe Class
 * @author SangJoon Kim
 * @since Sep 6, 2012
 * @version 1.0
 * @see
 * 
 * @Modification Information
 * 
 *               <pre>
 *    Date                Changer         Comment
 *  ===========    =========    ===========================
 *  Sep 6, 2012 by SangJoon Kim: initial version
 * </pre>
 */

public class JasperCompiler {
    public final static String REPORT_PATH = "D:\\Foren\\_DEV\\workspace\\g3erp\\WebContent\\WEB-INF\\report\\hum960rkr";
    public final static String EXT_XML = ".jrxml";
    public final static String EXT_JASPER = ".jasper";
    public static void main(String args[]) throws Exception {
        String[] files = { 
                        "hum960rkr",
                        "hum960rkr_sub01",
                        "hum960rkr_sub02" ,
                        "hum960rkr_sub03",
                        "hum960rkr_sub04",
                        "hum960rkr_sub05",
                        "hum960rkr_sub06",
                        "hum960rkr_sub07",
                        "hum960rkr_sub08",
                        "hum960rkr_sub09",
                        "hum960rkr_sub10",
                        "hum960rkr_sub11"
        };

        for (String fileName : files) {
            File designFile  = new File(REPORT_PATH, fileName+EXT_XML) ;
            if(!designFile.exists()) {

                TestUtil.out(designFile.getCanonicalPath() + " 파일이 존재 하지 않습니다.");
                break;
            }
            String jasperFileName = designFile.getCanonicalPath().replace(EXT_XML, EXT_JASPER);
            File jasperFile = new File (jasperFileName);
            if(designFile.lastModified() > jasperFile.lastModified()) {
                TestUtil.out("Compile ", designFile.getCanonicalPath());
                JasperCompileManager.compileReportToFile(designFile.getCanonicalPath(),jasperFileName );
                TestUtil.out("  >> ", jasperFileName);
            } else {

                TestUtil.out(designFile.getCanonicalPath()," is not changed.");
            }
            
        }
        
        
        
    }

}
