package foren.unilite.modules.com.login;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.ExpiredJwtException;

import java.io.IOException;
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

import com.clipsoft.server.common.utils.ConfigUtils;

import foren.framework.lib.listop.ListOp;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.sec.cipher.seed.EncryptSHA256;
import foren.framework.sec.license.LicenseManager;
import foren.framework.sessionpool.SessionPool;
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.JndiUtils;
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
import foren.unilite.modules.base.bsa.Bsa300ukrvServiceImpl;
import foren.unilite.modules.base.bsa.Bsa310ukrvServiceImpl;
import foren.unilite.modules.base.bsa.Bsa350ukrvServiceImpl;
import foren.unilite.modules.base.bsa.Bsa360ukrvServiceImpl;
import foren.unilite.modules.mobile.android.UserVO;

@Controller
public class LoginController extends UniliteCommonController {
    private final Logger            logger   = LoggerFactory.getLogger(this.getClass());
    final static String             JSP_PATH = "/com/login/";

    @Resource( name = "loginService" )
    private LoginServiceImpl        loginService;

    @Resource( name = "LoginExtUserService" )
    private LoginExtUserServiceImpl        loginExtUserService;

    @Resource( name = "LoginExtUserService" )
    private LoginExtUserServiceImpl LoginExtUserService;

    @Resource( name = "bsa310ukrvService" )
    private Bsa310ukrvServiceImpl bsa310ukrvService;

    @Resource( name = "bsa360ukrvService" )
    private Bsa360ukrvServiceImpl bsa360ukrvService;

    @Resource( name = "bsa300ukrvService" )
    private Bsa300ukrvServiceImpl bsa300ukrvService;

    @Resource( name = "bsa350ukrvService" )
    private Bsa350ukrvServiceImpl bsa350ukrvService;

    /**
     * <pre>
     * 비밀번호 암호화 객체
     * </pre>
     */
    private EncryptSHA256           enc      = new EncryptSHA256();

    /**
     * <pre>
     * 모바일 로그인 페이지(부트스트랩)
     * </pre>
     *
     * @param request
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/login/login_m.do", method = RequestMethod.GET )
    public String mIndex( HttpServletRequest request, ModelMap model ) throws Exception {
        model.addAttribute("serveletPath", request.getServletPath());

        return JSP_PATH + "loginForm_m";
    }

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
    @RequestMapping( value = "/login/login.do", method = RequestMethod.GET )
    public String index( HttpServletRequest request, ModelMap model ) throws Exception {
        model.addAttribute("serveletPath", request.getServletPath());

        return JSP_PATH + "loginForm";
    }

    /**
     * <pre>
     * 최초사용자 비밀번호변경 페이지
     * </pre>
     *
     * @param request
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/login/newUser.do", method = RequestMethod.GET )
    public String newUserForm( HttpServletRequest request, LoginVO loginVO, ModelMap model ) throws Exception {
        model.addAttribute("serveletPath", request.getServletPath());
        Map param = new HashMap();
        param.put("S_COMP_CODE", loginVO.getCompCode());
        Map<String, Object> pwCheckQ = (Map<String, Object>) bsa310ukrvService.pwCheckQ(param);
		if(pwCheckQ != null)	{
			String pastNum = ObjUtils.getSafeString(pwCheckQ.get("CYCLE_CNT"), "2");
			if("0".equals(pastNum)) 	{
				pastNum = "2";
			}
			 model.addAttribute("pastNum", pastNum);
		} else {
			model.addAttribute("pastNum", "2");
		}

        return JSP_PATH + "newUserForm";
    }

    /**
     * <pre>
     * 최초사용자 비밀번호변경 페이지(외부사용자)
     * </pre>
     *
     * @param request
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/login/newExtUser.do", method = RequestMethod.GET )
    public String newExtUserForm( HttpServletRequest request, LoginVO loginVO, ModelMap model ) throws Exception {
        model.addAttribute("serveletPath", request.getServletPath());
        Map param = new HashMap();
        param.put("S_COMP_CODE", loginVO.getCompCode());
        Map<String, Object> pwCheckQ = (Map<String, Object>) bsa360ukrvService.pwCheckQ(param);
		if(pwCheckQ != null)	{
			String pastNum = ObjUtils.getSafeString(pwCheckQ.get("CYCLE_CNT"), "2");
			if("0".equals(pastNum)) 	{
				pastNum = "2";
			}
			 model.addAttribute("pastNum", pastNum);
		} else {
			model.addAttribute("pastNum", "2");
		}

        return JSP_PATH + "newExtUserForm";
    }
    /**
     * <pre>
     * 최초사용자 비밀번호변경
     * </pre>
     *
     * @param request
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/login/updatePassword.do", method = { RequestMethod.GET, RequestMethod.POST, RequestMethod.OPTIONS } )
    public ModelAndView updatePassword( HttpServletRequest request, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model ) throws Exception {
    	Map<String, Object> r = new HashMap();
    	Map param = _req.getParamMap();
    	if(loginVO == null)	{
    		r.put("success", "false");
    		r.put("location", request.getContextPath()+"/login/login.do");
    		r.put("errorMessage", "최초 로그인 정보가 없습니다.");
    		return ViewHelper.getJsonView(r);
    	}

    	CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		//비밀번호 대문자 여부
		CodeDetailVO caseSenceYn = codeInfo.getCodeInfo("B110", "40");

    	Map sData = new HashMap();

    	if("N".equals(caseSenceYn.getRefCode1()))	{
    		sData.put("NEW_PWD", ObjUtils.getSafeString(param.get("NEW_PWD")).trim().toUpperCase());
    		sData.put("OLD_PWD", ObjUtils.getSafeString(param.get("OLD_PWD")).trim().toUpperCase());
    	} else {
    		sData.put("NEW_PWD", ObjUtils.getSafeString(param.get("NEW_PWD")).trim());
        	sData.put("OLD_PWD", ObjUtils.getSafeString(param.get("OLD_PWD")).trim());
    	}
    	sData.put("S_COMP_CODE", loginVO.getCompCode());
    	sData.put("S_USER_ID", loginVO.getUserID());

    	r = bsa310ukrvService.selectPasswordValidate(sData, loginVO, _req);
    	if(r.get("errorMessage") != null )	{
    		r.put("success", "false");
    		return ViewHelper.getJsonView(r);
    	}

    	Map<String, Object> encryptionYN = (Map<String, Object>) bsa310ukrvService.encryptionYN(sData);
    	if("Y".equals(encryptionYN.get("ENCRYPT_YN")))	{
    		bsa310ukrvService.encryptionSavePw(sData);
    	}else {
    		param.put("NEW_PWD", ObjUtils.getSafeString(sData.get("NEW_PWD")));
    		bsa310ukrvService.notEncryptionSavePw(sData);
    	}
    	Map<String, Object> logMap = new HashMap();
    	logMap.put("COMP_CODE", loginVO.getCompCode());
    	logMap.put("USER_ID", loginVO.getUserID());
    	logMap.put("PASSWORD", sData.get("NEW_PWD"));

    	bsa300ukrvService.insertPasswordLog(logMap);
    	loginService.updateFirstLogin(logMap);
    	r.put("success", "true");
    	return ViewHelper.getJsonView(r);
    }

    /**
     * <pre>
     * 최초사용자 비밀번호변경(외부사용자)
     * </pre>
     *
     * @param request
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/login/updateExtUserPassword.do", method = { RequestMethod.GET, RequestMethod.POST, RequestMethod.OPTIONS } )
    public ModelAndView updateExtUserPassword( HttpServletRequest request, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model ) throws Exception {
    	Map<String, Object> r = new HashMap();
    	Map param = _req.getParamMap();
    	if(loginVO == null)	{
    		r.put("success", "false");
    		r.put("location", request.getContextPath()+"/login/loginForExtUser.do");
    		r.put("errorMessage", "최초 로그인 정보가 없습니다.");
    		return ViewHelper.getJsonView(r);
    	}

    	CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		//비밀번호 대문자 여부
		CodeDetailVO caseSenceYn = codeInfo.getCodeInfo("B110", "40");

    	Map sData = new HashMap();

    	if("N".equals(caseSenceYn.getRefCode5()))	{
    		sData.put("NEW_PWD", ObjUtils.getSafeString(param.get("NEW_PWD")).trim().toUpperCase());
    		sData.put("OLD_PWD", ObjUtils.getSafeString(param.get("OLD_PWD")).trim().toUpperCase());
    	} else {
    		sData.put("NEW_PWD", ObjUtils.getSafeString(param.get("NEW_PWD")).trim());
        	sData.put("OLD_PWD", ObjUtils.getSafeString(param.get("OLD_PWD")).trim());
    	}
    	sData.put("S_COMP_CODE", loginVO.getCompCode());
    	sData.put("S_USER_ID", loginVO.getUserID());

    	r = bsa360ukrvService.selectPasswordValidate(sData, loginVO, _req);
    	if(r.get("errorMessage") != null )	{
    		r.put("success", "false");
    		return ViewHelper.getJsonView(r);
    	}

    	Map<String, Object> encryptionYN = (Map<String, Object>) bsa360ukrvService.encryptionYN(sData);
    	if("Y".equals(encryptionYN.get("ENCRYPT_YN")))	{
    		bsa360ukrvService.encryptionSavePw(sData);
    	}else {
    		param.put("NEW_PWD", ObjUtils.getSafeString(sData.get("NEW_PWD")));
    		bsa360ukrvService.notEncryptionSavePw(sData);
    	}
    	Map<String, Object> logMap = new HashMap();
    	logMap.put("COMP_CODE", loginVO.getCompCode());
    	logMap.put("USER_ID", loginVO.getUserID());
    	logMap.put("PASSWORD", sData.get("NEW_PWD"));

    	bsa350ukrvService.insertPasswordLog(logMap);
    	loginExtUserService.updateFirstLogin(logMap);
    	r.put("success", "true");
    	return ViewHelper.getJsonView(r);
    }


    @RequestMapping( value = "/login/m_loginProc.do" )
    public ModelAndView m_loginProcess( HttpServletRequest request, ExtHtttprequestParam _req, HttpSession session, HttpServletResponse response ) throws Exception {
        ModelAndView rView = null;
        Map<String, Object> param = _req.getParameterMap();
        logger.debug("param : {}", param);

        rView = this.m_dbLoginProcess(request, _req, session);

        return rView;


    }

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
    @RequestMapping( value = "/login/loginProc.do" )
    public ModelAndView loginProcess( HttpServletRequest request, ExtHtttprequestParam _req, HttpSession session, HttpServletResponse response ) throws Exception {
        ModelAndView rView = null;
        Map<String, Object> param = _req.getParameterMap();
        logger.debug("param : {}", param);

        rView = this.dbLoginProcess(request, _req, session);

        return rView;


    }
    public ModelAndView m_dbLoginProcess( HttpServletRequest request, ExtHtttprequestParam _req, HttpSession session ) throws Exception {

        Map<String, Object> param = _req.getParameterMap();

        //ResponseBase<UserVO> respons = new ResponseBase<UserVO>();
		//UserVO user = new UserVO();


        logger.debug("param : {}", param);
        String inputUserId = ObjUtils.getSafeString(param.get("userid"));

        // 라인센스 확인
        if (!LicenseManager.getInstance().isAuth()) {
            param.put("success", "fail");
            param.put("message", LicenseManager.getInstance().getLicenseException().getMessage());
            return ViewHelper.getJsonView(param);
        }

        // 사용자 확인
        List<Map<String, Object>> mapUserList = loginService.selectUserList(param);

        // 라인센스 확인
        if (!LicenseManager.getInstance().getLicenseProcessor().verifyUserCount(mapUserList, (String)param.get("userid"))) {
            param.put("success", "fail");


            param.put("message", "Registered User exceed.");
        } else {
            boolean isCaseSensitiveYN = false;
            CodeInfo codeInfo = this.tlabCodeService.getCodeInfo("MASTER");
            CodeDetailVO cdo = null;


           //로그인잠금횟수 체크

        	cdo = codeInfo.getCodeInfo("B110", "30");

    		param.put("maxCnt", cdo.getRefCode1());

        	Map<String, Object> loginFail = (Map<String, Object>)loginService.selectfailCount(param);

        	if("false".equals(loginFail.get("CHECK")))	{
        		if(cdo.getRefCode1()!= null){//실패 횟수 값이 있으면 메세지에 실패 횟수도 같이 보여줌(감리 보안 점검 대상)
        			int cntChk = Integer.parseInt(cdo.getRefCode1());
        			param.put("message", MessageUtils.getMessage("system.message.common.login007",cntChk,_req));
        		}else{
        			param.put("message", MessageUtils.getMessage("system.message.common.login008","로그인 실패로 계정이 잠겼습니다. 관리자에게 문의하세요.",_req));
        		}


	        }else {

	            cdo = codeInfo.getCodeInfo("B110", "40");   //대소문자 구분
	            if (!ObjUtils.isEmpty(cdo)) {
	                if (cdo.getRefCode1().equals("Y")) {
	                    isCaseSensitiveYN = true;
	                } else {
	                    isCaseSensitiveYN = false;
	                }
	            }
	            logger.debug("isCaseSensitiveYN = {}", isCaseSensitiveYN);
	            if (!isCaseSensitiveYN) {
	                param.put("userpw", StringUtils.upperCase(ObjUtils.getSafeString(param.get("userpw"))));
	            }



	            param.put("userpw", enc.encrypt(ObjUtils.getSafeString(param.get("userpw"))));

	            String userId = loginService.passwordCheck(param);

	            param.clear();
	           //if (_req.containsKey(TlabSessionInterceptor.RETURN_URL_ATTRIBUTE_NAME)) {
	                //param.put("return_url", _req.getP(TlabSessionInterceptor.RETURN_URL_ATTRIBUTE_NAME));
	           // }
	            logger.debug("userId is {}", userId);
	            // 중복 로그인 체크
	            if (!ObjUtils.isEmpty(userId)) {
	                if (SessionPool.isUserLogined(userId) && "F".equals(_req.getP("confirm"))) {
	                    param.put("success", "fail");
	                    param.put("alreadyLogin", "true");
	                    //param.put("message", MessageUtils.getMessage("msg.login.closePreviousSession", _req));
	                    param.put("message", MessageUtils.getMessage("system.message.common.login001", "이미 접속된 정보가 존재 합니다. 다시 로그인 하시면 이전 접속 정보는 해제 됩니다.", _req));
	                } else {

	                    SessionPool.removeByUsn(userId);
	                    // 실제 로그인.
	                    LoginVO userSession = _loginProc(userId, request, _req, session);
	                    String language = LocaleUtils.getSimpleLocale(request);
	                    userSession.setLanguage(language);

	                    if (userSession != null) {

	                        param.put("EmpNo", "true");
	                        param.put("PW", "true");
	                        param.put("SAWONNAME", "true");
	                        param.put("DEPTCD", "1111");
	                        param.put("DEPTNAME", "true");
	                        param.put("PlantCd", "001");
	                        param.put("TokenID", "001");
	                        param.put("resultCode", "C200");
	                        param.put("resultMsg", "001");

	                       // if (!param.containsKey("return_url")) {
	                        //    param.put("return_url", session.getAttribute(TlabSessionInterceptor.RETURN_URL_ATTRIBUTE_NAME));
	                        //}


	                       // param.put("message", MessageUtils.getMessage("system.message.common.login002",userSession.getUserName()+ " 로그인 되었습니다.", _req));
	                    }
	                }

	            } else {
	            	//로그인 실패갯수 update
	            	param.put("inputUserId", inputUserId);
	            	loginService.updateFailLogin(param);

	                param.put("success", "fail");

	                //param.put("message", MessageUtils.getMessage("msg.login.loginFail", "주어진 사용자 ID와 암호에 일치하는 사용자가 없습니다.",_req));
	                param.put("message", MessageUtils.getMessage("system.message.common.login009", loginFail.get("FAIL_CNT"),_req)); 	//로그인 시 기존 로그인 실패 횟수 및 비밀번호 자릿수 관련 메세지 추가 (감사 보안 검사 대상)
	            }
	        }
    	}
        logger.debug("USN is {}", param);

        return ViewHelper.getJsonView(param);

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
    public ModelAndView dbLoginProcess( HttpServletRequest request, ExtHtttprequestParam _req, HttpSession session ) throws Exception {

        Map<String, Object> param = _req.getParameterMap();
        logger.debug("param : {}", param);
        String inputUserId = ObjUtils.getSafeString(param.get("userid"));
        // 라인센스 확인
        if (!LicenseManager.getInstance().isAuth()) {
            param.put("success", "fail");
            param.put("message", LicenseManager.getInstance().getLicenseException().getMessage());
            return ViewHelper.getJsonView(param);
        }

        // 사용자 확인
        List<Map<String, Object>> mapUserList = loginService.selectUserList(param);

        // 라인센스 확인
        if (!LicenseManager.getInstance().getLicenseProcessor().verifyUserCount(mapUserList, (String)param.get("userid"))) {
            param.put("success", "fail");
            param.put("message", "Registered User exceed.");
        } else {
            boolean isCaseSensitiveYN = false;
            CodeInfo codeInfo = this.tlabCodeService.getCodeInfo("MASTER");
            CodeDetailVO cdo = null;


           //로그인잠금횟수 체크

        	cdo = codeInfo.getCodeInfo("B110", "30");

    		param.put("maxCnt", cdo.getRefCode1());

        	Map<String, Object> loginFail = (Map<String, Object>)loginService.selectfailCount(param);

        	if("false".equals(loginFail.get("CHECK")))	{
        		if(cdo.getRefCode1()!= null){//실패 횟수 값이 있으면 메세지에 실패 횟수도 같이 보여줌(감리 보안 점검 대상)
        			int cntChk = Integer.parseInt(cdo.getRefCode1());
        			param.put("message", MessageUtils.getMessage("system.message.common.login007",cntChk,_req));
        		}else{
        			param.put("message", MessageUtils.getMessage("system.message.common.login008","로그인 실패로 계정이 잠겼습니다. 관리자에게 문의하세요.",_req));
        		}


	        }else {

	            cdo = codeInfo.getCodeInfo("B110", "40");   //대소문자 구분
	            if (!ObjUtils.isEmpty(cdo)) {
	                if (cdo.getRefCode1().equals("Y")) {
	                    isCaseSensitiveYN = true;
	                } else {
	                    isCaseSensitiveYN = false;
	                }
	            }
	            logger.debug("isCaseSensitiveYN = {}", isCaseSensitiveYN);
	            if (!isCaseSensitiveYN) {
	                param.put("userpw", StringUtils.upperCase(ObjUtils.getSafeString(param.get("userpw"))));
	            }



	            param.put("userpw", enc.encrypt(ObjUtils.getSafeString(param.get("userpw"))));

	            String userId = loginService.passwordCheck(param);

	            param.clear();
	            if (_req.containsKey(TlabSessionInterceptor.RETURN_URL_ATTRIBUTE_NAME)) {
	                param.put("return_url", _req.getP(TlabSessionInterceptor.RETURN_URL_ATTRIBUTE_NAME));
	            }
	            logger.debug("userId is {}", userId);
	            // 중복 로그인 체크
	            if (!ObjUtils.isEmpty(userId)) {
	                if (SessionPool.isUserLogined(userId) && "F".equals(_req.getP("confirm"))) {
	                    param.put("success", "fail");
	                    param.put("alreadyLogin", "true");
	                    //param.put("message", MessageUtils.getMessage("msg.login.closePreviousSession", _req));
	                    param.put("message", MessageUtils.getMessage("system.message.common.login001", "이미 접속된 정보가 존재 합니다. 다시 로그인 하시면 이전 접속 정보는 해제 됩니다.", _req));
	                } else {

	                    SessionPool.removeByUsn(userId);
	                    // 실제 로그인.
	                    LoginVO userSession = _loginProc(userId, request, _req, session);
	                    String language = LocaleUtils.getSimpleLocale(request);
	                    userSession.setLanguage(language);

	                    if (userSession != null) {
	                        param.put("success", "true");
	                        if (!param.containsKey("return_url")) {
	                            param.put("return_url", session.getAttribute(TlabSessionInterceptor.RETURN_URL_ATTRIBUTE_NAME));
	                        }

	                        //param.put("message", MessageUtils.getMessage("msg.login.loginsuccess", userSession.getUserName(), _req));
	                        param.put("message", MessageUtils.getMessage("system.message.common.login002",userSession.getUserName()+ " 로그인 되었습니다.", _req));
	                    }
	                }

	            } else {
	            	//로그인 실패갯수 update
	            	param.put("inputUserId", inputUserId);
	            	loginService.updateFailLogin(param);

	                param.put("success", "fail");

	                //param.put("message", MessageUtils.getMessage("msg.login.loginFail", "주어진 사용자 ID와 암호에 일치하는 사용자가 없습니다.",_req));
	                param.put("message", MessageUtils.getMessage("system.message.common.login009", loginFail.get("FAIL_CNT"),_req)); 	//로그인 시 기존 로그인 실패 횟수 및 비밀번호 자릿수 관련 메세지 추가 (감사 보안 검사 대상)
	            }
	        }
    	}
        logger.debug("USN is {}", param);
        return ViewHelper.getJsonView(param);

    }

    /**
     * <pre>
     * 로그 아웃
     * </pre>
     *
     * @param request
     * @param model
     * @param session
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/login/actionLogout.do" )
    public String logoutProcess( HttpServletRequest request, ModelMap model, HttpSession session ) throws Exception {
        Object s = session.getAttribute(CommonConstants.SESSION_KEY);
        if (s != null && s instanceof LoginVO) {
            LoginVO user = (LoginVO)s;
            SessionPool.removeByUsn(user.getUsn());
            Map<String, Object> param = new HashMap<String, Object>();
            param.put("usn", user.getUsn());
        }

        session.setAttribute(CommonConstants.SESSION_KEY, null);

        return "forward:/";
    }

    @RequestMapping( value = "/login/logOutAll.do" )
    public String multiLogoutProcess( HttpServletRequest request, ModelMap model, HttpSession session ) throws Exception {
        Object s = session.getAttribute(CommonConstants.SESSION_KEY);
        if (s != null && s instanceof LoginVO) {
            LoginVO user = (LoginVO)s;
            SessionPool.removeByUsn(user.getUsn());
            Map<String, Object> param = new HashMap<String, Object>();
            param.put("usn", user.getUsn());
        }

        session.setAttribute(CommonConstants.SESSION_KEY, null);
        Map param = new HashMap();
        String hostName = request.getServerName();
        int portNum = request.getServerPort();

        String strPortNum = "";
        if (80 == portNum || 443 == portNum) {
            strPortNum = "";
        } else {
            strPortNum = ":" + String.valueOf(portNum);
        }

        String cpath = request.getContextPath();
        if (cpath != null) {
            cpath = cpath.replace("/", "");
            if (cpath.length() > 0) {
                cpath = "/" + cpath;
            }
        }
        param.put("currentUrl", hostName + strPortNum + cpath);

        List<String> logOutUrls = loginService.selectLogoutUrl(param);
        StringBuffer jsonUrls = JsonUtils.toJsonStr(logOutUrls);
        if (jsonUrls == null || jsonUrls.length() == 0) {
            jsonUrls = new StringBuffer();
            jsonUrls.append("[]");
        }
        model.addAttribute("logOutUrls", jsonUrls);

        return JSP_PATH + "logOutAll";
        //return "forward:/";
    }

    /**
     * 법인 변경
     *
     * @param request
     * @param _req
     * @param session
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/login/changeComp.do" )
    public String changeCompCode( HttpServletRequest request, ModelMap model, ExtHtttprequestParam _req, HttpSession session ) throws Exception {
        Map<String, Object> param = _req.getParameterMap();
        String userId = ObjUtils.getSafeString(param.get("S_USER_ID"));
        String chCompCode = ObjUtils.getSafeString(param.get("CH_COMP_CODE"));

        if (!_changeCompCode(chCompCode, userId, request, session)) {
            throw new Exception("해당 법인에 접근하실 수 없습니다.");
        }

        Map param2 = new HashMap();
        String hostName = request.getServerName();
        int portNum = request.getServerPort();

        String strPortNum = "";
        if (80 == portNum || 443 == portNum) {
            strPortNum = "";
        } else {
            strPortNum = ":" + String.valueOf(portNum);
        }

        String cpath = request.getContextPath();
        if (cpath != null) {
            cpath = cpath.replace("/", "");
            if (cpath.length() > 0) {
                cpath = "/" + cpath;
            }
        }
        param2.put("currentUrl", hostName + strPortNum + cpath);

        List<String> logOutUrls = loginService.selectLogoutUrl(param2);
        StringBuffer jsonUrls = JsonUtils.toJsonStr(logOutUrls);
        if (jsonUrls == null || jsonUrls.length() == 0) {
            jsonUrls = new StringBuffer();
            jsonUrls.append("[]");
        }
        model.addAttribute("logOutUrls", jsonUrls);
        return JSP_PATH + "logOutCompCd";

        //return "forward:/";
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
    private LoginVO _loginProc( String usn, HttpServletRequest request, ExtHtttprequestParam _req, HttpSession session ) {
        LoginVO userSession = loginService.getUserInfoByUserID(usn);

        if (userSession != null && !ObjUtils.isEmpty(userSession.getUserID())) {
            userSession.setRemoteIP(request.getRemoteAddr());
            Map<String, Object> userMap = new HashMap<String, Object>();
            userMap.put("test", userSession.getUserID() + userSession.getUserName());
            userSession.setUserMap(userMap);
            if (userSession.hasRole(CommonConstants.ROLE_ROOT)) {
                userSession.setHasAdminAuth(true);
            }
            String currency = this.getCurrency(userSession.getCompCode());
            userSession.setCurrency(currency);
            session.setAttribute(CommonConstants.SESSION_KEY, userSession);
            this.setLoginLog(userSession);

        }

        return userSession;
    }

    /**
     * 법인코드 변경
     *
     * @param request
     * @param _req
     * @param session
     * @return
     */
    @SuppressWarnings( "unchecked" )
    private boolean _changeCompCode( String chCompCode, String userId, HttpServletRequest request, HttpSession session ) {
        Map<String, Object> param = new HashMap();
        param.put("CH_COMP_CODE", chCompCode);
        param.put("S_USER_ID", userId);
        LoginVO userInfo = loginService.getUserInfoByCompCode(param);
        if (userInfo != null && !ObjUtils.isEmpty(userInfo.getUserID())) {
            userInfo.setRemoteIP(request.getRemoteAddr());
            Map<String, Object> userMap = new HashMap<String, Object>();
            userMap.put("test", userInfo.getUserID() + userInfo.getUserName());
            userInfo.setUserMap(userMap);
            if (userInfo.hasRole(CommonConstants.ROLE_ROOT)) {
                userInfo.setHasAdminAuth(true);
            }
            String currency = this.getCurrency(userInfo.getCompCode());
            userInfo.setCurrency(currency);
            session.setAttribute(CommonConstants.SESSION_KEY, userInfo);
        } else {

            Map<String, Object> compInfo = (Map<String, Object>)loginService.changeCompCode(param);
            if (ObjUtils.isNotEmpty(compInfo)) {
                LoginVO userSession = (LoginVO)session.getAttribute(CommonConstants.SESSION_KEY);
                logger.info("###################################################################");
                logger.info("1 MAIN_COMP_CODE : "+ userSession.getMainCompCode());
                logger.info("###################################################################");
                userSession.setCompCode(ObjUtils.getSafeString(compInfo.get("COMP_CODE")));
                if ("ko".equals(userSession.getLanguage())) {
                    userSession.setCompName(ObjUtils.getSafeString(compInfo.get("COMP_NAME")));
                } else {
                    userSession.setCompName(ObjUtils.getSafeString(compInfo.get("COMP_ENG_NAME")));
                }
                logger.info("###################################################################");
                logger.info("2 MAIN_COMP_CODE : "+ userSession.getMainCompCode());
                logger.info("###################################################################");
                session.setAttribute(CommonConstants.SESSION_KEY, userSession);
            } else {
                return false;
            }
        }
        return true;
    }

    /**
     * 외부사용자 로그인
     *
     * @param request
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/login/loginForExtUser.do", method = RequestMethod.GET )
    public String loginForExtUser( HttpServletRequest request, ModelMap model ) throws Exception {
        model.addAttribute("serveletPath", request.getServletPath());

        return JSP_PATH + "loginFormForExtUser";
    }

	@RequestMapping( value = "/login/loginProcForExtUser.do" )	//20210426 수정: 외부사용자 암호화 사용으로 일괄 수정
	public ModelAndView loginProcExtUser( HttpServletRequest request, ExtHtttprequestParam _req, HttpSession session ) throws Exception {
		Map<String, Object> param = _req.getParameterMap();
		logger.debug("param : {}", param);
		String inputUserId = ObjUtils.getSafeString(param.get("userid"));
		// 라인센스 확인
		if (!LicenseManager.getInstance().isAuth()) {
			param.put("success", "fail");
			param.put("message", LicenseManager.getInstance().getLicenseException().getMessage());
			return ViewHelper.getJsonView(param);
		}
		List<Map<String, Object>> mapUserList = LoginExtUserService.selectUserList(param);
		if (!LicenseManager.getInstance().getLicenseProcessor().verifyUserCount(mapUserList, (String)param.get("userid"))) {
			param.put("success", "fail");
			param.put("message", "Registered User exceed.");
		} else {
			boolean isCaseSensitiveYN = false;
			CodeInfo codeInfo = this.tlabCodeService.getCodeInfo("MASTER");
			CodeDetailVO cdo = null;

			//로그인잠금횟수 체크
			cdo = codeInfo.getCodeInfo("B110", "30");
			param.put("maxCnt", cdo.getRefCode5());
			Map<String, Object> loginFail = (Map<String, Object>)LoginExtUserService.selectfailCount(param);

			if("false".equals(loginFail.get("CHECK")))	{
				if(cdo.getRefCode5()!= null){//실패 횟수 값이 있으면 메세지에 실패 횟수도 같이 보여줌(감리 보안 점검 대상)
					int cntChk = Integer.parseInt(cdo.getRefCode5());
					param.put("message", MessageUtils.getMessage("system.message.common.login007",cntChk,_req));
				}else{
					param.put("message", MessageUtils.getMessage("system.message.common.login008","로그인 실패로 계정이 잠겼습니다. 관리자에게 문의하세요.",_req));
				}
			} else {
				cdo = codeInfo.getCodeInfo("B110", "40");	//대소문자 구분
				if (!ObjUtils.isEmpty(cdo)) {
					if (cdo.getRefCode5().equals("Y")) {
						isCaseSensitiveYN = true;
					} else {
						isCaseSensitiveYN = false;
					}
				}
				logger.debug("isCaseSensitiveYN = {}", isCaseSensitiveYN);
				if (!isCaseSensitiveYN) {
					param.put("userpw", StringUtils.upperCase(ObjUtils.getSafeString(param.get("userpw"))));
				}
//				param.put("userpw", enc.encrypt(ObjUtils.getSafeString(param.get("userpw"))));
				String userId = LoginExtUserService.passwordCheck(param);

				param.clear();
				if (_req.containsKey(TlabSessionInterceptor.RETURN_URL_ATTRIBUTE_NAME)) {
					param.put("return_url", _req.getP(TlabSessionInterceptor.RETURN_URL_ATTRIBUTE_NAME));
				}
				logger.debug("userId is {}", userId);
				// 중복 로그인 체크
				if (!ObjUtils.isEmpty(userId)) {
					if (SessionPool.isUserLogined(userId) && "F".equals(_req.getP("confirm"))) {
						param.put("success"		, "fail");
						param.put("alreadyLogin", "true");
						//param.put("message", MessageUtils.getMessage("msg.login.closePreviousSession", _req));
						param.put("message", MessageUtils.getMessage("system.message.common.login001", "이미 접속된 정보가 존재 합니다. 다시 로그인 하시면 이전 접속 정보는 해제 됩니다.",_req));
					} else {
						SessionPool.removeByUsn(userId);
						// 실제 로그인.
						LoginVO userSession	= _loginProcExtUser(userId, request, _req, session);
						String language		= LocaleUtils.getSimpleLocale(request);
						userSession.setLanguage(language);

						if (userSession != null) {
							param.put("success", "true");
							if (!param.containsKey("return_url")) {
								param.put("return_url", session.getAttribute(TlabSessionInterceptor.RETURN_URL_ATTRIBUTE_NAME));
							}
							//param.put("message", MessageUtils.getMessage("msg.login.loginsuccess", userSession.getUserName(), _req));
							param.put("message", MessageUtils.getMessage("system.message.common.login002", userSession.getUserName(), _req));
						} else {
							param.put("success", "fail");
							//param.put("message", MessageUtils.getMessage("msg.login.loginFail", _req));
							param.put("message", MessageUtils.getMessage("system.message.common.login003", "주어진 사용자 ID와 암호에 일치하는 사용자가 없습니다.",_req));
						}
					}
				} else {
					//로그인 실패갯수 update
					param.put("inputUserId", inputUserId);
					LoginExtUserService.updateFailLogin(param);
					param.put("success", "fail");
					//param.put("message", MessageUtils.getMessage("msg.login.loginFail", _req));
					param.put("message", MessageUtils.getMessage("system.message.common.login003", "주어진 사용자 ID와 암호에 일치하는 사용자가 없습니다.",_req));
				}
			}
		}
		logger.debug("USN is {}", param);
		return ViewHelper.getJsonView(param);
	}

	@RequestMapping(value="/login/mlogin.do",method = RequestMethod.GET)
	public String mobileIndex(HttpServletRequest request, ModelMap model	)throws Exception{
		model.addAttribute("serveletPath", request.getServletPath());
		return JSP_PATH+"mloginForm";
	}

	@RequestMapping(value="/login/loginToken.do",method = RequestMethod.GET)
	public ModelAndView getLoginToken(ExtHtttprequestParam _req, HttpServletRequest request, HttpSession session) throws Exception	{
		Map<String, Object> rv = new HashMap<String, Object>();
		Map<String, Object> param = _req.getParameterMap();
		rv.put("callback", param.get("callback"));
		LoginVO userSession = (LoginVO)session.getAttribute(CommonConstants.SESSION_KEY);
        if (ObjUtils.isNotEmpty(userSession)) {
            //토큰 유효 시간 1분
            long expTime = 1000 * 60;
            String loginToken = LoginTokenGenerator.createJWT(userSession.getUserID(), userSession.getUserID() + userSession.getCompCode(), request.getRequestURI(), expTime);
            logger.debug("Login token " + loginToken);
            ////Claims userInfo = LoginTokenGenerator.parseJWT(loginToken);
            rv.put("loginToken", loginToken);

        } else {
        	rv.put("success", "fail");
        	//rv.put("message", MessageUtils.getMessage("msg.login.loginFail", _req));
        	rv.put("message", MessageUtils.getMessage("system.message.common.login003", "주어진 사용자 ID와 암호에 일치하는 사용자가 없습니다.",_req));
        }
		return ViewHelper.getJsonPView(rv);
	}


	@RequestMapping(value="/login/decryptToken.do",method = { RequestMethod.GET, RequestMethod.POST, RequestMethod.OPTIONS } )
	public ModelAndView decrytToken(HttpServletRequest request, ExtHtttprequestParam _req) throws Exception	{
		Map<String, Object> rv = new HashMap<String, Object>();
		Map param = request.getParameterMap();
		try {
			Claims loginInfo = LoginTokenGenerator.parseJWT(ObjUtils.getSafeString(param.get("loginToken")));
            String userId = loginInfo.getId();
            String compCode = loginInfo.getIssuer();
            rv.put("userId", userId);
            rv.put("Issuer", compCode);
            if (compCode != null && userId != null && compCode.length() > userId.length()) {
                compCode = compCode.substring(userId.length(), compCode.length());
                rv.put("compCode", compCode);
            }
        } catch (ExpiredJwtException e) {
        	rv.put("success", "fail");
        	//rv.put("message", " ExpiredJwtException 유효하지 않은 인증정보입니다.");
        	rv.put("message", MessageUtils.getMessage("system.message.common.login004", "유효하지 않은 인증정보입니다.",_req));
        	logger.debug(e.getMessage());
        	e.printStackTrace();
        } catch (Exception e) {
        	//e.printStackTrace();
        	rv.put("success", "fail");
        	//rv.put("message", "Exception 유효하지 않은 인증정보입니다.");
        	rv.put("message", MessageUtils.getMessage("system.message.common.login004", "유효하지 않은 인증정보입니다.",_req));
        	logger.debug(e.getMessage());
        }
		return ViewHelper.getJsonView(rv);
	}

	@RequestMapping( value = "/login/connect.do", method = { RequestMethod.GET, RequestMethod.POST, RequestMethod.OPTIONS } )
    public String connect(HttpServletRequest request, HttpServletResponse response,ExtHtttprequestParam _req, HttpSession session) throws Exception, IOException {
		return JSP_PATH + "connect";
	}
	@RequestMapping( value = "/login/connectLogin.do", method = { RequestMethod.GET, RequestMethod.POST, RequestMethod.OPTIONS } )
    public ModelAndView siblingLogin(HttpServletRequest request, HttpServletResponse response,ExtHtttprequestParam _req, HttpSession session) throws Exception, IOException {
    Map<String, Object> param = _req.getParameterMap();
    String userId = "";
    String compCode = "";
    String redirectUrl = "";
    //Enumeration<String> t = request.getHeaderNames();
    String referer = request.getHeader("referer");
    logger.debug("Login token " + param.get("loginToken"));
    /*if (ObjUtils.isNotEmpty(referer) && referer.indexOf(ConfigUtil.getProperty("common.main.mainUrl").toString()) < 0) {
        param.put("success", "fail");
        param.put("message", "잘못된 접근 입니다.");
    } else {*/
        logger.debug("Login token " + param.get("loginToken"));
        try {
        	logger.debug(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> loginToken : "+ObjUtils.getSafeString(param.get("loginToken")));
            Claims loginInfo = LoginTokenGenerator.parseJWT(ObjUtils.getSafeString(param.get("loginToken")));
            logger.debug(ObjUtils.getSafeString(param.get("loginToken")));
            userId = loginInfo.getId();
            if(userId != null) 	{
            	logger.debug("userId : "+userId);
            }
            if(loginInfo.getIssuer()!= null) 	{
            	logger.debug("loginInfo.getIssuer() : "+loginInfo.getIssuer());
            }
            if(loginInfo.getSubject()!= null) 	{
            	logger.debug("loginInfo.getSubject() : "+loginInfo.getSubject());
            }
            compCode = "MASTER";/*loginInfo.getIssuer();
            if (compCode != null && userId != null && compCode.length() > userId.length()) {
                compCode = compCode.substring(userId.length(), compCode.length());
            }*/
            redirectUrl = loginInfo.getSubject();
        } catch (ExpiredJwtException e) {
            param.put("success", "fail");
            param.put("message", "유효하지 않은 인증정보입니다.");
            logger.debug(">>>>>>>>>>>>>>>>>>>>>>>> ExpiredJwtException : "+ ObjUtils.getSafeString(param.get("loginToken"))+"\n"+ e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            param.put("success", "fail");
            param.put("message", "유효하지 않은 인증정보입니다.");
            logger.debug(">>>>>>>>>>>>>>>>>>>>>>>> Exception : "+ ObjUtils.getSafeString(param.get("loginToken"))+"\n"+ e.getMessage());
            e.printStackTrace();
        }

        // 실제 로그인.
        LoginVO userSession = null;

        String language = LocaleUtils.getSimpleLocale(request);
        if (ObjUtils.isNotEmpty(userId)) {
            userSession = _loginProc(userId, request, _req, session);
            userSession.setLanguage(language);
            userSession.setFirstLoginYn("N");			// 토근료그인인 경우 최초로그인 비밀번호 변경 제외시킴
        }
        if (userSession != null ) {

            session.setAttribute(CommonConstants.SESSION_KEY, userSession);
            param.put("success", "true");

            if (!param.containsKey("return_url")) {
               // param.put("return_url", session.getAttribute(TlabSessionInterceptor.RETURN_URL_ATTRIBUTE_NAME));

            }
            param.put("message", MessageUtils.getMessage("msg.login.loginsuccess", userSession.getUserName(), _req));
            String mainUrl = request.getContextPath()+ObjUtils.getSafeString(ConfigUtil.getProperty("common.main.mainUrl"), "/main.do");//request.getContextPath()+redirectUrl;
            if(mainUrl == null)	{
            	mainUrl = ObjUtils.getSafeString(ConfigUtil.getProperty("common.main.mainUrl"), "/main.do");
            }
            //response.sendRedirect(mainUrl);

            // 코디의 경우 사업자코드의 00,01,02의 경우 omegapluskodi2 로 redirect 토큰 인증을 다시 해야 함
            String contextName = JndiUtils.getEnv("CONTEXT_NAME", "");
            logger.debug("KODI JWT Token :[contextName] "+contextName);
            if("omegapluskodi".equals(contextName))	{
            	String[] divCodeArr = {"00","01", "02"};
            	logger.debug("KODI JWT Token :[divCode] "+userSession.getDivCode());
            	if(java.util.Arrays.asList(divCodeArr).indexOf(userSession.getDivCode()) > -1)	{
            		 long expTime = 1000 * 60;
                     String loginToken = LoginTokenGenerator.createJWT(userSession.getUserID(), userSession.getUserID() + userSession.getCompCode(), request.getRequestURI(), expTime);
                    logger.debug("KODI JWT Token : "+loginToken);
                    mainUrl = "/omegapluskodi2/login/connect.do?loginToken="+loginToken;
            	}
            }
            param.put("return_url", mainUrl);
        } else {
            param.put("success", "fail");
            param.put("message", MessageUtils.getMessage("msg.login.loginFail", _req));
            //return ViewHelper.getJsonView(param);
        }
    //}
    return ViewHelper.getJsonPView(param);
}
    private LoginVO _loginProcExtUser( String usn, HttpServletRequest request, ExtHtttprequestParam _req, HttpSession session ) {
        LoginVO userSession = LoginExtUserService.getUserInfoByUserID(usn);

        //          Map<String, Object> param = new HashMap<String, Object>();
        if (userSession != null && !ObjUtils.isEmpty(userSession.getUserID())) {
            userSession.setRemoteIP(request.getRemoteAddr());

            if (userSession.hasRole(CommonConstants.ROLE_ROOT)) {
                userSession.setHasAdminAuth(true);
            }
            String currency = this.getCurrency(userSession.getCompCode());
            userSession.setCurrency(currency);
            session.setAttribute(CommonConstants.SESSION_KEY, userSession);
            this.setLoginLog(userSession);
        }

        return userSession;
    }

    private void setLoginLog(LoginVO userSession)	{
    	try{
        	Map logParam = new HashMap();
            logParam.put("USER_ID", userSession.getUserID());
            logParam.put("COMP_CODE", userSession.getCompCode());
            logParam.put("IP_ADDR", userSession.getRemoteIP());
        	loginService.updateLog(logParam);
        	loginService.updateFailCount(logParam);	//로그인 시 기존 로그인 실패 횟수 0으로 처리 로직 추가 (감사 보안 검사 대상)
        	if(!"Y".equals(userSession.getFirstLoginYn()))	{
        		loginService.setLastLoginTime(logParam);
        	}

        }catch(Exception e)	{
        	logger.error(" >>>>>>>  Login Log INSERT Error {},{},{}",  userSession.getCompCode(), userSession.getUserID(), userSession.getRemoteIP());
        }
    }

    private String getCurrency(String compCode) {
    	String currency = "KRW";
		CodeInfo codeInfo = tlabCodeService.getCodeInfo(compCode);
		if(codeInfo != null)	{
			CodeDetailVO cdo = codeInfo.getCodeInfo("B004", "REF_CODE1", "Y");
			if(cdo != null) {
				currency = cdo.getCodeNo();
			}
		}
	    return currency;
	}

    /**
     * <pre>
     * MES로그인 페이지
     * </pre>
     *
     * @param request
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/login/login_mes.do", method = RequestMethod.GET )
    public String loginMes( HttpServletRequest request, ModelMap model ) throws Exception {
        model.addAttribute("serveletPath", request.getServletPath());

        return JSP_PATH + "loginForm_mes";
    }
}
