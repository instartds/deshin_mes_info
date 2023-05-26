package foren.unilite.modules.com.login; 

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.ExpiredJwtException;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

//import net.sf.ehcache.CacheManager;
//import net.sf.ehcache.Ehcache;
//import net.sf.ehcache.Element;



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
import foren.framework.sec.cipher.seed.EncryptSHA256;
import foren.framework.sec.license.LicenseManager;
import foren.framework.sessionpool.SessionPool;
import foren.framework.utils.JsonUtils;
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
public class LoginControllerForYp extends UniliteCommonController {
    
    private final Logger            logger   = LoggerFactory.getLogger(this.getClass());
    
    final static String             JSP_PATH = "/com/login/";
    
    @Resource( name = "loginService" )
    private LoginServiceImpl        loginService;
    
    @Resource( name = "LoginExtUserService" )
    private LoginExtUserServiceImpl LoginExtUserService;
    
    /**
     * <pre>
     * 비밀번호 암호화 객체
     * </pre>
     */
    private EncryptSHA256           enc      = new EncryptSHA256();
    
    /**
     * <pre>
     * 표준로그인 페이지
     * </pre>
     * 
     * @param request
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/login/login_yp.do", method = RequestMethod.GET )
    public String index( HttpServletRequest request, ModelMap model ) throws Exception {
        model.addAttribute("serveletPath", request.getServletPath());
        
        return JSP_PATH + "loginForm_yp";
    }
    
    /**
     * 외부사용자 로그인
     * 
     * @param request
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/login/loginForExtUser_yp.do", method = RequestMethod.GET )
    public String loginForExtUser( HttpServletRequest request, ModelMap model ) throws Exception {
        model.addAttribute("serveletPath", request.getServletPath());
        
        return JSP_PATH + "loginFormForExtUser_yp";
    }
    
}
