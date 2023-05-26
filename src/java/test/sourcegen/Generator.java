package test.sourcegen;

import java.io.File;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;
import java.io.Writer;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import org.apache.velocity.Template;
import org.apache.velocity.VelocityContext;
import org.apache.velocity.app.Velocity;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import test.sourcegen.model.TGMethodVO;
import test.sourcegen.model.TGPackageVO;
import test.sourcegen.model.TGProgramListVO;
import test.sourcegen.model.TGProgramVO;
import test.sourcegen.support.SGStringUtils;
import foren.framework.lib.XMLDigester;
import foren.framework.utils.FileUtil;

/**
 * @Class Name : Generator.java
 * @Description : !!! Describe Class
 * @author SangJoon Kim
 * @since 2012. 4. 27.
 * @version 1.0
 * @see
 * 
 * @Modification Information
 * 
 *               <pre>
 *    Date                Changer         Comment
 *  ===========    =========    ===========================
 *  2012. 4. 27. by SangJoon Kim: initial version
 * </pre>
 */

public class Generator {

    private final Logger logger = LoggerFactory.getLogger(Generator.class);


    public final static String JAVA_ROOT_PATH =  "C:/TRA/workspace/tra_cmi/src/java/";
    public final static String BASE_FILE_PATH = JAVA_ROOT_PATH+"/test/sourcegen/";
    public final static String CONFIG_FILE_PATH = BASE_FILE_PATH + "config/";
    public final static String JSP_ROOT_PATH =  "C:/TRA/workspace/tra_cmi/source_gen/";

    private VelocityContext context;
    TGProgramListVO con;

    public Generator() throws Exception {
        context = new VelocityContext();

//       con = (TGProgramListVO) XMLDigester.digest(  CONFIG_FILE_PATH + "cmi_programList.xml", CONFIG_FILE_PATH + "config-digesterRules.xml");
        con = (TGProgramListVO) XMLDigester.digest(  CONFIG_FILE_PATH + "programList.xml", CONFIG_FILE_PATH + "config-digesterRules.xml");
        if (con == null) {
            throw new Exception("Config Fail!!!");
        }
    }

    private Properties setProperties() {
        Properties p = new Properties();
        p.setProperty("file.resource.loader.path", BASE_FILE_PATH + "vm");
        p.put("input.encoding", "UTF-8");
        return p;
    }

    public void generate() throws Exception {
        String packageName;
        for(TGPackageVO packageVO : con.getPackages()) {
             if(packageVO.isUse()) {
                for(TGProgramVO  programVO : packageVO.getPrograms() ) {
    
                    packageName = con.getBasePackageName() + "." + packageVO.getName();
                    genJavaAndSqlSource(programVO, packageName  );
                }
             }
        }
    }

    private StringBuffer genJsp() {
        StringBuffer sb = new StringBuffer();
        return sb;
    }
   
    
    

    private void genJavaAndSqlSource(TGProgramVO  programVO, String packageName) throws Exception {
        Velocity.init(setProperties());

       

        Map<String, String> param = new HashMap<String, String>();

        String controlPackageName = packageName +".web";
        String servicePackageName = packageName +".service";
        String serviceImplPackageName = packageName +".service.impl";
        param.put("controlPackageName",  controlPackageName);
        param.put("className", programVO.getControllName());
        param.put("description", "Get Manifest List");
        param.put("jspPath", programVO.getJspPath());
        param.put("serviceName", programVO.getServiceName());
        param.put("serviceImplName", programVO.getServiceImplName());
        param.put("importServiceName", servicePackageName +"." + programVO.getServiceName());
        param.put("importServiceImplName", serviceImplPackageName +"." + programVO.getServiceImplName());
        param.put("serviceInterfaceName", programVO.getServiceName());
        param.put("serviceClassName", programVO.getServiceName());
        param.put("serviceBeanName", programVO.getServiceBeanName());
        param.put("servicePackageName",  packageName +".service");
        param.put("serviceImplPackageName",  packageName +".service.impl");
        param.put("serviceImplPackageName",  packageName +".service.impl");

        _toFile(programVO, param, controlPackageName, programVO.getControllName() + ".java", "javaController.vm");
        _toFile(programVO, param, servicePackageName, programVO.getServiceName() + ".java", "javaService.vm");
        _toFile(programVO, param, serviceImplPackageName, programVO.getServiceImplName() + ".java", "javaServiceImpl.vm");
        _toFile(programVO, param, serviceImplPackageName, programVO.getServiceImplName() + "_SQL.xml", "SQL.xml.vm");


        // return writer.toString();

    }



    public StringBuffer genSql() {
        StringBuffer sb = new StringBuffer();
        return sb;
    }

    private void _toFile(TGProgramVO  programVO, Map<String, String> param, String packageName,  String fileName, String vmFilename) throws Exception {
        context.put("p", param);
        context.put("prg", programVO);
        String filepath = JAVA_ROOT_PATH + _package2Path(packageName);
        FileUtil.CheckAndMakeDir(filepath);
        File file = new File(filepath, fileName);

        logger.debug( " >> [" + JAVA_ROOT_PATH + _package2Path(packageName) + "/" +  fileName + "] file made. "  );
        Writer out = new OutputStreamWriter(new FileOutputStream(file), "UTF-8");
                
        Template t = Velocity.getTemplate(vmFilename);
        t.merge(context, out);        
        out.close();
        
        filepath = JSP_ROOT_PATH + programVO.getJspPath();        
        FileUtil.CheckAndMakeDir(filepath);
        for(TGMethodVO method : programVO.getMethods() ) {
            file = new File(filepath, method.getName() + ".jsp");
            logger.debug("JSP : " + filepath + method.getName() + ".jsp");
            out = new OutputStreamWriter(new FileOutputStream(file), "UTF-8");
            t = Velocity.getTemplate("jsp.vm");
            t.merge(context, out);        
            out.close();
        }
    }
    
    private String _package2Path(String packageName) {
        return  SGStringUtils.replace( packageName,".", "/");
    }
}
