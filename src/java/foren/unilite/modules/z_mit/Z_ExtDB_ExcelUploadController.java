package foren.unilite.modules.z_mit;

import java.io.File;
import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.ss.usermodel.Workbook;
import org.slf4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.type.TypeFactory;

import foren.framework.logging.InjectLogger;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.FileInfoVO;
import foren.framework.model.LoginVO;
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.ObjUtils;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.excel.vo.ExcelUploadResult;
import foren.unilite.com.excel.vo.ExcelUploadWorkBookVO;
import foren.unilite.com.validator.UniDirectValidateException;

// TODO: Auto-generated Javadoc
/**
 * The Class ExcelUploadController.
 */
@Controller
public class Z_ExtDB_ExcelUploadController {
    
    /** The logger. */
    @InjectLogger
    private  Logger logger;
    
    /** The gen excel. */
    @Resource(name = "s_extDB_ExcelUpload_mitService")
    private S_ExtDB_ForenExcel_mitServiceImpl genExcel;

    /**
     * 외부 DB용 Upload.
     *
     * @param excelFile the excel file
     * @param excelConfigName the excel config name
     * @param model the model
     * @param user the user
     * @param eReq the e req
     * @param response the response
     * @return the model and view
     * @throws Exception the exception
     */
    @RequestMapping(value = "/excel/s_extDB_upload_mit.do")
    public ModelAndView upload(@RequestParam("excelFile") MultipartFile excelFile, @RequestParam("excelConfigName") String excelConfigName, ModelMap model, 
                    LoginVO user, ExtHtttprequestParam eReq, HttpServletResponse response) throws Exception {

    	
        Map<String,Object> rv = new HashMap<String,Object>();
        rv.put("jsonrpc", "2.0");
        
        Map param = eReq.getParameterMap();
        
        try {
            ExcelUploadResult result = genExcel.parseUploadedExcel(excelConfigName, excelFile, param);
            rv.put("success", true);
            rv.put("jobID", result.getJobID());
        } catch(Exception e) {
            rv.put("msg", e.getMessage());
            rv.put("success", false);
        }
        boolean  checkCors = (!"".equals(ConfigUtil.getString("servers[@domain]", "")));
        return checkCors ? ViewHelper.getJsObjectView(rv) : ViewHelper.getJsonView(rv);
        //return ViewHelper.getJsonView(rv);
    }

}
