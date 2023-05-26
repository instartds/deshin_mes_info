package foren.unilite.modules.com.login;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.sec.license.LicenseManager;
import foren.framework.sessionpool.SessionPool;
import foren.framework.utils.LocaleUtils;
import foren.framework.utils.MessageUtils;
import foren.framework.utils.ObjUtils;
import foren.framework.web.interceptor.TlabSessionInterceptor;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.com.constants.CommonConstants;

@Controller
public class LoginControllerForGroupware extends UniliteCommonController {
	
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	final static String JSP_PATH = "/com/login/";
	
    @Resource(name = "loginService")
    private LoginServiceImpl loginService;
    
    
	@RequestMapping(value="/login/loginFormForGroupware.do",method = RequestMethod.GET)
	public String loginForGroupware(HttpServletRequest request, ModelMap model	)throws Exception{
		model.addAttribute("serveletPath", request.getServletPath());
        
		return JSP_PATH+"loginFormForGroupware";
	}
	    
}
