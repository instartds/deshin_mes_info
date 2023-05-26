package foren.unilite.modules.com.email;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import foren.framework.lib.fileupload.FileUploadModel;
import foren.framework.lib.listop.ListOp;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.ObjUtils;
import foren.framework.web.view.FileDownloadInfo;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.com.validator.UniDirectValidateException;

@Controller
public class EmailController extends UniliteCommonController {
    
    private final Logger      logger = LoggerFactory.getLogger(this.getClass());
    
    @Resource( name = "emailSendService" )
    private EmailSendServiceImpl emailSendService;
    
    @RequestMapping( value = "/com/sendEmail.do" )
    public ModelAndView sendEmail( ExtHtttprequestParam _req, ListOp listOp, ModelMap model, LoginVO user ) throws Exception {
        Map param = _req.getParameterMap();
        Map<String, Object> rv = new HashMap<String, Object>();
        rv.put("success", Boolean.TRUE);
        
        try{

            String email = ObjUtils.getSafeString(param.get("EMAIL"));
            String subject = ObjUtils.getSafeString(param.get("SUBJECT"));
            String body	 = ObjUtils.getSafeString(param.get("BODY"));
        	//emailSendService.sendMail(email, subject, body);
        }catch(Exception e)	{
        	rv.put("success", Boolean.FALSE);
        	rv.put("message", e.getMessage());
        	logger.error(e.getMessage());
        	e.printStackTrace();
        }
        return ViewHelper.getJsonView(rv);
    }
    
    @RequestMapping( value = "/com/sendMultiEmail.do" )
    public ModelAndView sendMultiEmail( ExtHtttprequestParam _req, ListOp listOp, ModelMap model, LoginVO user ) throws Exception {
        Map param = _req.getParameterMap();
        Map<String, Object> rv = new HashMap<String, Object>();
        rv.put("success", Boolean.TRUE);
        try{
        	String[] email = (String[]) param.get("EMAIL");
            String subject = ObjUtils.getSafeString(param.get("SUBJECT"));
            String body	 = ObjUtils.getSafeString(param.get("BODY"));
           //emailSendService.sendMail(email, subject, body);
        }catch(Exception e)	{
        	rv.put("success", Boolean.FALSE);
        	rv.put("message", e.getMessage());
        }
        return ViewHelper.getJsonView(rv);
    }
    
}
