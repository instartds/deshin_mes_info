package foren.unilite.modules.com.login;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.xml.namespace.QName;

import mw.sso.sp.profile.MWAssertionConsumerProfileImpl;
import mw.sso.sp.profile.MWAuthnRequestProfileImpl;
import mw.sso.sp.profile.MWSingleLogoutProfileImpl;

import org.apache.commons.lang.StringUtils;
import org.opensaml.common.SAMLException;
import org.opensaml.common.SAMLObject;
import org.opensaml.saml2.core.AuthnRequest;
import org.opensaml.saml2.core.LogoutRequest;
import org.opensaml.saml2.core.LogoutResponse;
import org.opensaml.saml2.core.Response;
import org.opensaml.saml2.core.NameID;
import org.opensaml.saml2.core.StatusCode;
import org.opensaml.saml2.metadata.provider.MetadataProviderException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.i18n.SessionLocaleResolver;

import devonframe.sso.saml.context.SAMLContextProvider;
import devonframe.sso.saml.context.SAMLCredential;
import devonframe.sso.saml.context.SAMLMessageContext;
import devonframe.sso.saml.storage.SAMLMessageStorage;
import devonframe.sso.sp.profile.AuthnRequestProfileImpl;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.sec.license.LicenseManager;
import foren.framework.sessionpool.SessionPool;
import foren.framework.utils.ConfigUtil;
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
public class LoginForLGSaaSController extends UniliteCommonController {
	
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	final static String JSP_PATH = "/com/login/";
	
    @Resource(name = "loginService")
    private LoginServiceImpl loginService;
    
    @Resource(name="contextProvider")
    SAMLContextProvider contextProvider;
    
    @Resource(name="authnRequestProfile")
    MWAuthnRequestProfileImpl authnRequestProfile;
    
    @Resource(name="assertionConsumerProfile")
    MWAssertionConsumerProfileImpl assertionConsumerProfile;

	
	    /**
	     * LG SaaS SAML 로그인
	     * @param model
	     * @param request
	     * @param response
	     * @param session
	     * @return
	     */
	    
		@RequestMapping(value="/login/loginFormForLGSaaS.do",method = RequestMethod.GET)
		public void singleSignOn(HttpServletRequest request, HttpServletResponse response	)throws Exception{
			SAMLMessageContext<SAMLObject, AuthnRequest, NameID> messageContext =   	contextProvider.buildOutboundMessageContext(request, response);
	    	/*Identity Provider로부터의 응답을 검증하기 위하여 요청을 캐슁한다. */
	    	SAMLMessageStorage storage = new SAMLMessageStorage(request);
	    	authnRequestProfile.sendAuthenticationRequest(messageContext, storage);
		}
		
		
	    @RequestMapping("/sso/assertionConsumer.do")
	    public ModelAndView assertionConsumer(ModelMap model, HttpServletRequest request, HttpServletResponse response, HttpSession session, ExtHtttprequestParam _req) throws MetadataProviderException, SAMLException {
	    	LoginVO loginUser = new LoginVO();
	    	Map<String, Object> params = _req.getParameterMap();
	    	logger.debug("param : {}", params);
		    try {
		    	SAMLMessageContext<Response, SAMLObject, NameID> messageContext = contextProvider.buildOutboundMessageContext(request, response);
			    /*인증 결과에 대하여 해당 인증 요청이 있었는 지 여부를 검증 목적*/
			    SAMLMessageStorage storage = new SAMLMessageStorage(session);
			    
			    SAMLCredential credential = assertionConsumerProfile.processAssertionResponse(messageContext, storage);
			    /*Identity Provider가 제공한 계정정보인 SAMLCredential로부터 사용자 정보 설정*/ 
			    loginUser.setUserID(credential.getNameId());
			    logger.debug("##################  credential             : "+credential.toString());
			    logger.debug("##################  credential.getNameId() : "+credential.getNameId());
		    } catch (Exception mp) {
		    	params.put("success", "fail");
        		params.put("message", "fail to get assertionConsumerProfile");
		    	logger.debug("##################  login Error : "+mp.toString());
		    }
		    
		    
		    if( loginUser.getUserID() != null ) {
			    /* 사용자 세션을 생성한다.*/
		    	
			    session.setAttribute("loginUser", loginUser);
			    session.setAttribute(SessionLocaleResolver.LOCALE_SESSION_ATTRIBUTE_NAME, new Locale(_req.getP("LOCALE")));
			    logger.debug("##################  1 : ");
		        if(!LicenseManager.getInstance().isAuth()) {
		        	logger.debug("##################  1 : false");
		        	params.put("success", "fail");
		        	params.put("message", LicenseManager.getInstance().getLicenseException().getMessage());
	            	return ViewHelper.getJsonView(params);
	            }
		        List<Map<String, Object>> mapUserList = loginService.selectUserList(params);
		        logger.debug("##################  2 : ");
	        	if(!LicenseManager.getInstance().getLicenseProcessor().verifyUserCount(mapUserList, loginUser.getUserID())) {
	        		params.put("success", "fail");
	        		params.put("message", "Registered User exceed.");
	        	}else{
			       
	        		logger.debug("##################  3 : ");
			        String userId = loginUser.getUserID();
		
			        params.clear();
			        if(_req.containsKey(TlabSessionInterceptor.RETURN_URL_ATTRIBUTE_NAME)) {
			        	params.put("return_url", request.getParameter(TlabSessionInterceptor.RETURN_URL_ATTRIBUTE_NAME));
			        }else {
			        	params.put("TLAB_RETURN_URL", ConfigUtil.getProperty("common.main.mainUrl"));
			        	params.put("return_url", ConfigUtil.getProperty("common.main.mainUrl"));
			        }
			        logger.debug("userId is {}", userId);
			        // 중복 로그인 체크
			        logger.debug("##################  4 : ");
			        if (!ObjUtils.isEmpty(userId)) {
			        	logger.debug("##################  5 : ");
			            if (SessionPool.isUserLogined(userId)  && "F".equals(_req.getP("confirm")) ) {
			            	params.put("success", "fail");
			            	params.put("alreadyLogin", "true");
			            	params.put("message", MessageUtils.getMessage("msg.login.closePreviousSession", _req));
		
			            } else {
			            	logger.debug("##################  6 : ");           	
			                SessionPool.removeByUsn(userId);
					    	LoginVO userSession = loginService.getUserInfoByUserID(userId);
					    	if (userSession != null && !ObjUtils.isEmpty(userId)) {
					            userSession.setRemoteIP(request.getRemoteAddr());
			
					            if (userSession.hasRole( CommonConstants.ROLE_ROOT ) ) {
					                userSession.setHasAdminAuth(true);
					            }
			
					            
					            session.setAttribute(CommonConstants.SESSION_KEY, userSession);
					            logger.debug("##################  7 : ");
					        }
					    	
			                String language = LocaleUtils.getSimpleLocale(request);
			                userSession.setLanguage(language);
		
			                if (userSession != null) {
			                	params.put("success", "true");
			                    if(! params.containsKey("return_url")) {
			                    	params.put("return_url", session.getAttribute(TlabSessionInterceptor.RETURN_URL_ATTRIBUTE_NAME));
			                    }
			                    logger.debug("##################  8 : ");
			                    params.put("message", MessageUtils.getMessage("msg.login.loginsuccess", userSession.getUserName(), _req));
			                } else {
			                	params.put("success", "fail");
			                	params.put("message", MessageUtils.getMessage("msg.login.loginFail", _req));
		
			                }
		            	}
			        }
	        	}

		    }
		    logger.debug("##################  request.getSession().getAttribute(loginUser) : "+ request.getSession().getAttribute("loginUser"));
		    logger.debug("##################  return url : "+ params.get("return_url"));
		    try{
		    	response.sendRedirect(request.getContextPath() + ConfigUtil.getProperty("common.main.mainUrl").toString());
		    }catch(IOException e)	{
		    	logger.debug("##################  redirect ");
		    }
		    return ViewHelper.getJsonView(params);
	    }
	    
	    
	    
	    
	    @Resource(name="singleLogoutProfile")
	    private MWSingleLogoutProfileImpl sloProfile = null;
	    
	    @RequestMapping("/login/logout.do")
	    public void logout(ModelMap model,HttpServletRequest request,HttpServletResponse response,HttpSession session) throws Exception {
	    	Object s = session.getAttribute(CommonConstants.SESSION_KEY);
	        if (s != null && s instanceof LoginVO) {
	            LoginVO user = (LoginVO) s;
	            SessionPool.removeByUsn(user.getUsn());
	            Map<String, Object> param = new HashMap<String, Object>();
	            param.put("usn", user.getUsn());
	        }
	        
		    if( session == null )
		    	request.getRequestDispatcher("/main.do").forward(request, response);
		    LoginVO user = (LoginVO)session.getAttribute("loginUser");
		    session.invalidate();
		    
		   
		    SAMLMessageContext messageContext = contextProvider.buildOutboundMessageContext(request, response);
		    sloProfile.sendLogoutRequest(messageContext, user.getUserID());
	    }
	    
	    @RequestMapping("/login/singleLogout.do")
	    public void singleLogout(ModelMap model,  HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {
	    	
	    	Object s = session.getAttribute(CommonConstants.SESSION_KEY);
	        if (s != null && s instanceof LoginVO) {
	            LoginVO user = (LoginVO) s;
	            SessionPool.removeByUsn(user.getUsn());
	            Map<String, Object> param = new HashMap<String, Object>();
	            param.put("usn", user.getUsn());
	        }

	        logger.debug("##########################  1");
		    SAMLMessageContext messageContext = contextProvider.buildInboundMessageContext(request,response);
		    logger.debug("##########################  2");
		    sloProfile.processLogout(messageContext);
		    logger.debug("##########################  3");
		    SAMLObject inboundMessage = messageContext.getInboundSAMLMessage();
		    logger.debug("##########################  4");
		    if( inboundMessage instanceof LogoutRequest ) {
		    	LogoutRequest logoutRequest = (LogoutRequest)inboundMessage;
		    	logger.debug("##########################  5");
		    	if( session != null ) { session.invalidate(); }
		    	logger.debug("##########################  6");
	    		messageContext = contextProvider.buildOutboundMessageContext(request, response);
	    		logger.debug("##########################  7");
	    		sloProfile.sendLogoutResponse(messageContext, QName.valueOf(StatusCode.SUCCESS_URI));
	    		logger.debug("##########################  8");
	    	} else {
	    		LogoutResponse logoutResponse = (LogoutResponse)inboundMessage;
	    		StatusCode status = logoutResponse.getStatus().getStatusCode();
	    		response.sendRedirect(request.getContextPath() + "/main.do");
	    	}
    	}
	    private boolean checkLoginPage(HttpServletRequest request, HttpServletResponse response, String loginPage) throws IOException	{
	    	boolean r = true;
	    
	    	if(ConfigUtil.getString("common.login.loginPage") != null && !loginPage.equals(ConfigUtil.getString("common.login.loginPage")))	{
	    		r = false;
	    		response.sendRedirect(request.getContextPath() + ConfigUtil.getString("common.login.loginPage"));
	    	}
	    	return r;
	    }
}
