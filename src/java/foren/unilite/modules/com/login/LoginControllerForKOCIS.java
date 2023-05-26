package foren.unilite.modules.com.login;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
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
import foren.framework.web.view.ViewerSupport;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.com.constants.CommonConstants;
import foren.unilite.utils.ext.UntdEcrytDcdn;

@Controller
public class LoginControllerForKOCIS extends UniliteCommonController {
    
    private final Logger     logger = LoggerFactory.getLogger(this.getClass());
    
    @Resource( name = "loginService" )
    private LoginServiceImpl loginService;
    
    /**
     * <pre>
     * 비밀번호 암호화 객체
     * </pre>
     */
    private EncryptSHA256    enc    = new EncryptSHA256();
    
    /**
     * <pre>
     * 로그인 처리 프로세스
     * </pre>
     * 
     * @param request
     * @param _req
     * @param session
     * @param response
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/login/kocisLogin.do" )
    public String loginProcessForKOCIS( HttpServletRequest request, ExtHtttprequestParam _req, HttpSession session, HttpServletResponse response ) throws Exception {
        String success = null;
        Map<String, Object> param = _req.getParameterMap();
        logger.debug("param : {}", param);
        
        ModelAndView rView = this.dbLoginProcessForKOCIS(request, _req, session);
        
        if (rView != null) {
            Map<String, Object> rModel = rView.getModel();
            if (rModel != null) {
                Map<String, Object> rMap = (Map<String, Object>)rModel.get(ViewerSupport.DATA_SOURCE_KEY);
                if (rMap != null) {
                    logger.debug("@@@@@@@@@@@@@@@@@     rMap   : " + ObjUtils.toJsonStr(rMap));
                    success = ObjUtils.getSafeString(rMap.get("success"));
                }
            }
        }
        
        if (success.equals("fail")) {
            return "redirect:/login/login.do";
        } else {
            return "redirect:/";
        }
        
        //return rView;
    }
    
    /**
     * <pre>
     * DB 로그인 처리
     * </pre>
     * 
     * @param request
     * @param _req
     * @param session
     * @param response
     * @return
     * @throws Exception
     */
    public ModelAndView dbLoginProcessForKOCIS( HttpServletRequest request, ExtHtttprequestParam _req, HttpSession session ) throws Exception {
        
        Map<String, Object> param = _req.getParameterMap();
        logger.debug("param : {}", param);
        
        // 라인센스 확인
        if (!LicenseManager.getInstance().isAuth()) {
            param.put("success", "fail");
            param.put("message", LicenseManager.getInstance().getLicenseException().getMessage());
            return ViewHelper.getJsonView(param);
        }
        
        
        String userid = "";
        try {
            userid = UntdEcrytDcdn.decryptKey((String)param.get("userid"));
        } catch(Exception e) {
            userid = "";
        }
        param.put("userid", userid);
        
        // 사용자 확인
        List<Map<String, Object>> mapUserList = loginService.selectUserList(param);
        if (mapUserList.size() == 0) {
            param.put("success", "fail");
            param.put("message", "User not Finded");
            return ViewHelper.getJsonView(param);
        }
        
        // 라인센스 확인
        if (!LicenseManager.getInstance().getLicenseProcessor().verifyUserCount(mapUserList, (String)param.get("userid"))) {
            param.put("success", "fail");
            param.put("message", "Registered User exceed.");
        } else {
            boolean isCaseSensitiveYN = false;
            CodeInfo codeInfo = this.tlabCodeService.getCodeInfo("MASTER");
            CodeDetailVO cdo = null;
            
            cdo = codeInfo.getCodeInfo("B110", "40");   //대소문자 구분
            if (!ObjUtils.isEmpty(cdo)) {
                if (cdo.getRefCode1().equals("Y")) {
                    isCaseSensitiveYN = true;
                } else {
                    isCaseSensitiveYN = false;
                }
            }
            logger.debug("isCaseSensitiveYN = {}", isCaseSensitiveYN);
            /*
             * if (!isCaseSensitiveYN) { param.put("userpw", StringUtils.upperCase(ObjUtils.getSafeString(param.get("userpw")))); } param.put("userpw", enc.encrypt(ObjUtils.getSafeString(param.get("userpw")))); String userId = loginService.passwordCheck(param); param.clear(); if (_req.containsKey(TlabSessionInterceptor.RETURN_URL_ATTRIBUTE_NAME)) { param.put("return_url", _req.getP(TlabSessionInterceptor.RETURN_URL_ATTRIBUTE_NAME)); }
             */
            String userId = (String)param.get("userid");            // ID 만을 가지고 로그인 함.
            param.clear();
            param.put("return_url", "/");
            
            logger.debug("userId is {}", userId);
            // 중복 로그인 체크
            if (!ObjUtils.isEmpty(userId)) {
                if (SessionPool.isUserLogined(userId) && "F".equals(_req.getP("confirm"))) {
                    param.put("success", "fail");
                    param.put("alreadyLogin", "true");
                    param.put("message", MessageUtils.getMessage("msg.login.closePreviousSession", _req));
                    
                } else {
                    
                    SessionPool.removeByUsn(userId);
                    // 실제 로그인.
                    LoginVO userSession = _loginProcForKOCIS(userId, request, _req, session);
                    String language = LocaleUtils.getSimpleLocale(request);
                    userSession.setLanguage(language);
                    
                    if (userSession != null) {
                        param.put("success", "true");
                        if (!param.containsKey("return_url")) {
                            param.put("return_url", session.getAttribute(TlabSessionInterceptor.RETURN_URL_ATTRIBUTE_NAME));
                        }
                        
                        param.put("message", MessageUtils.getMessage("msg.login.loginsuccess", userSession.getUserName(), _req));
                    }
                }
                
            } else {
                param.put("success", "fail");
                param.put("message", MessageUtils.getMessage("msg.login.loginFail", _req));
            }
        }
        logger.debug("USN is {}", param);
        return ViewHelper.getJsonView(param);
        
    }
    
    /**
     * userid를 이용 하여 상세 정보를 읽어 온다.
     * 
     * @param usn
     * @param request
     * @param _req
     * @param session
     * @return
     */
    private LoginVO _loginProcForKOCIS( String usn, HttpServletRequest request, ExtHtttprequestParam _req, HttpSession session ) {
        LoginVO userSession = loginService.getUserInfoByUserID(usn);
        logger.debug("MAIN_COMP_CODE : " + userSession.getMainCompCode());
        //          Map<String, Object> param = new HashMap<String, Object>();
        if (userSession != null && !ObjUtils.isEmpty(userSession.getUserID())) {
            userSession.setRemoteIP(request.getRemoteAddr());
            Map<String, Object> userMap = new HashMap<String, Object>();
            userMap.put("test", userSession.getUserID() + userSession.getUserName());
            userSession.setUserMap(userMap);
            if (userSession.hasRole(CommonConstants.ROLE_ROOT)) {
                userSession.setHasAdminAuth(true);
            }
            session.setAttribute(CommonConstants.SESSION_KEY, userSession);
            logger.debug("-----------------------------------------------------------------------------");
        }
        
        return userSession;
    }
    

    @RequestMapping( value = "/login/logOutKocis.do" )
    public String kocisLogoutProcess( HttpServletRequest request, ModelMap model, HttpSession session ) throws Exception {
        Object s = session.getAttribute(CommonConstants.SESSION_KEY);
        if (s != null && s instanceof LoginVO) {
            LoginVO user = (LoginVO)s;
            SessionPool.removeByUsn(user.getUsn());
            Map<String, Object> param = new HashMap<String, Object>();
            param.put("usn", user.getUsn());
        }
        
        session.setAttribute(CommonConstants.SESSION_KEY, null);
        
        return "/com/login/logOutKocis";
    }
    
}
