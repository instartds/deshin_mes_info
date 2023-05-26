package foren.unilite.modules.com.potal;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.google.gson.Gson;

import foren.framework.logging.InjectLogger;
import foren.framework.model.LoginVO;
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.JsonUtils;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.com.constants.Unilite;
import foren.unilite.com.menu.UniModuleModel;
import foren.unilite.com.service.impl.TlabMenuService;
import foren.unilite.modules.com.combo.ComboServiceImpl;

@Controller
@SuppressWarnings({"rawtypes", "unchecked"})
public class MainController extends UniliteCommonController {

	@InjectLogger
	public static   Logger	logger	;//	= LoggerFactory.getLogger(this.getClass());

	final static String		JSP_PATH	= "/com/main/";

	@Resource(name = "tlabMenuService")
	TlabMenuService tlabMenuService;

	@Resource(name = "mainMenuService")
	MainMenuServiceImpl mainMenuService;

	@Resource(name="UniliteComboServiceImpl")
	private ComboServiceImpl comboService;

	@Resource(name = "mainCommonService")
	MainCommonServiceImpl mainCommonService;

//	@RequestMapping(value = "/mainOld.do", method = RequestMethod.GET)
//	public String index() throws Exception {
//
//		return JSP_PATH + "main";
//	}



	/**
	 * 일반 메인 페이지
	 * @param loginVo
	 * @param model
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/main.do", method = RequestMethod.GET)
	public String index(LoginVO loginVo, ModelMap model, HttpServletRequest request) throws Exception {
		List<UniModuleModel> modules = new ArrayList() ;
		List<UniModuleModel> userModules = new ArrayList() ;
		// 모듈 아이콘 표시 속성
		logger.debug(">>>>>>>>>>>>>> loginVo.getLanguage()  :"+loginVo.getLanguage());
		String pShowModules = ObjUtils.getSafeString(ConfigUtil.getProperty("common.main.showAllModules"));
		if("false".equals(pShowModules))	{
			userModules = mainCommonService.getUserModules(loginVo);
			modules = tlabMenuService.getModules(loginVo.getCompCode());
		}else {
			modules = tlabMenuService.getModules(loginVo.getCompCode());
		}
		List<Map<String,String>> mods = new ArrayList<Map<String,String>>();
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("S_COMP_CODE", loginVo.getCompCode());
//		Object processMenu = mainMenuService.getProcessMenu(param);
		String firstModuleName ="";
		if(modules != null ) {
			for(int i = 0, len = modules.size(); i < len; i ++) {
				UniModuleModel module = modules.get(i) ;

				Map<String,String> rec = new HashMap<String,String>();
				rec.put("id", module.getId());
				rec.put("title", module.getCodeName(loginVo.getLanguage()));
				if("false".equals(pShowModules))	{
					for(UniModuleModel userModule : userModules)	{
						if(ObjUtils.getSafeString(module.getId()).equals(userModule.getId()) )	{
							rec.put("show", "true");
							break;
						}
					}
				}else {
					rec.put("show", "true");
				}

				mods.add(rec);
				if(i == 0 ) {
					firstModuleName = rec.get("title");
				}
			}
			logger.debug("#############################################	"+ modules.toString() + "####################################");
		}else {
			logger.debug("#############################################	 modules is null  ####################################");
		}
		if(mods != null && mods.size() > 0 ) {
			model.put("modulesStr", JsonUtils.toJsonStr(mods));
		} else {
			//model.put("modulesStr", "[{'id':'11','title':'DEMO'}]");
			model.put("modulesStr", "[]");
		}

		model.put("contextList", getContextListJson());
		model.put("contextName", Unilite.getCurrentContextName(request.getContextPath()));

		StringBuffer appOption = new StringBuffer();
		Map<String, Object> userUI = (Map<String, Object>)mainCommonService.getUserUI(loginVo);
		if(userUI == null || ObjUtils.isEmpty(userUI))	{
			appOption.append("{collapseMenuOnOpen: true, showPgmId: false, collapseLeftSearch: true}");
		}else {
			for (Map.Entry<String, Object> entry : userUI.entrySet())
			{
				if(entry.getKey().equals("downEnterKey"))	{
					userUI.put(entry.getKey(), ObjUtils.getSafeString(entry.getValue()));
				} else {
					userUI.put(entry.getKey(), Boolean.valueOf(ObjUtils.getSafeString(entry.getValue())));
				}
			}
			appOption = ObjUtils.toJsonStr(userUI);
		}
		model.put("appOption", appOption);

		//법인변경
		Map compParam = new HashMap();
		compParam.put("S_USER_ID", loginVo.getUserID());
		compParam.put("S_LANG_CODE", loginVo.getLanguage());

		List<Map<String, Object>> compList = mainCommonService.compList(compParam);
		model.put("compList", ObjUtils.toJsonStr(compList));

		logger.debug("Model {} ", model);
		logger.debug("####  LoginVO.getToken() {} ", loginVo.getToken());

		//비밀번호 대소문자 구분
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVo.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("B110", "40");	//대소문자 구분
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("caseSensYN",cdo.getRefCode1());
		}

		cdo = codeInfo.getCodeInfo("B906", "10");	//회사문구
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("companyTitle", ObjUtils.nvlObj(cdo.getCodeName(loginVo.getLanguage()),"시너지시스템즈는 대한민국 기업IT화에 앞장서는 ERP Solution 전문업체입니다."));
		} else {
			model.addAttribute("companyTitle", "시너지시스템즈는 대한민국 기업IT화에 앞장서는 ERP Solution 전문업체입니다.");
		}

		logger.debug("Model {} ", model);

		return JSP_PATH + "main";
	}
	/**
	 * 모바일 메인 페이지(bootstrap)
	 * @param loginVo
	 * @param model
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/main_m.do", method = RequestMethod.GET)
	public String index_m(LoginVO loginVo, ModelMap model, HttpServletRequest request) throws Exception {

		model.addAttribute("compName"	, loginVo.getCompName());
		model.addAttribute("userName"	, loginVo.getUserName());
		return JSP_PATH + "main_m";
	}


	/**
	 * 일반 모바일 메인 페이지
	 * @param loginVo
	 * @param model
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/mMain_old.do", method = RequestMethod.GET)
	public String mobileIndex(LoginVO loginVo, ModelMap model, HttpServletRequest request) throws Exception {
		return JSP_PATH + "mMain";
	}

	/**
	 * 일반 모바일 메인 페이지
	 * @param loginVo
	 * @param model
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/mMain.do", method = RequestMethod.GET)
	public String mobileIndex2(LoginVO loginVo, ModelMap model, HttpServletRequest request) throws Exception {
		return JSP_PATH + "mMain2";
	}

	/**
	 * 일반 모바일 메인 페이지
	 * @param loginVo
	 * @param model
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/mMain_menu.do", method = RequestMethod.GET)
	public String mobileIndex3(LoginVO loginVo, ModelMap model, HttpServletRequest request) throws Exception {
		return JSP_PATH + "mMain3";
	}

	/**
	 * <pre>
	 * 일반 메인 페이지
	 *  - 해외정보문화원 프로젝트에서 사용
	 * </pre>
	 *
	 * @param loginVo
	 * @param model
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/mainKocis.do", method = RequestMethod.GET)
	public String KocisIndex(LoginVO loginVo, ModelMap model, HttpServletRequest request) throws Exception {
		List<UniModuleModel> modules = new ArrayList() ;
		List<UniModuleModel> userModules = new ArrayList() ;
		// 모듈 아이콘 표시 속성
		String pShowModules = ObjUtils.getSafeString(ConfigUtil.getProperty("common.main.showAllModules"));
		if("false".equals(pShowModules))	{
			userModules = mainCommonService.getUserModules(loginVo);
			modules = tlabMenuService.getModules(loginVo.getCompCode());
		}else {
			modules = tlabMenuService.getModules(loginVo.getCompCode());
		}
		List<Map<String,String>> mods = new ArrayList<Map<String,String>>();
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("S_COMP_CODE", loginVo.getCompCode());
//	  Object processMenu = mainMenuService.getProcessMenu(param);
		String firstModuleName ="";
		if(modules != null ) {
			for(int i = 0, len = modules.size(); i < len; i ++) {
				UniModuleModel module = modules.get(i) ;

				Map<String,String> rec = new HashMap<String,String>();
				rec.put("id", module.getId());
				rec.put("title", module.getCodeName(loginVo.getLanguage()));
				if("false".equals(pShowModules))	{
					for(UniModuleModel userModule : userModules)	{
						if(ObjUtils.getSafeString(module.getId()).equals(userModule.getId()) )  {
							rec.put("show", "true");
							break;
						}
					}
				}else {
					rec.put("show", "true");
				}

				mods.add(rec);
				if(i == 0 ) {
					firstModuleName = rec.get("title");
				}
			}
			logger.debug("#############################################	"+ modules.toString() + "####################################");
		}else {
			logger.debug("#############################################	 modules is null  ####################################");
		}
		if(mods != null && mods.size() > 0 ) {
			model.put("modulesStr", JsonUtils.toJsonStr(mods));
		} else {
			//model.put("modulesStr", "[{'id':'11','title':'DEMO'}]");
			model.put("modulesStr", "[]");
		}

		model.put("contextList", getContextListJson());
		model.put("contextName", Unilite.getCurrentContextName(request.getContextPath()));

		StringBuffer appOption = new StringBuffer();
		Map<String, Object> userUI = (Map<String, Object>)mainCommonService.getUserUI(loginVo);
		if(userUI == null || ObjUtils.isEmpty(userUI))  {
			appOption.append("{collapseMenuOnOpen: true, showPgmId: false, collapseLeftSearch: true}");
		}else {
			for (Map.Entry<String, Object> entry : userUI.entrySet())
			{
				if(entry.getKey().equals("downEnterKey"))	{
					userUI.put(entry.getKey(), ObjUtils.getSafeString(entry.getValue()));
				} else {
					userUI.put(entry.getKey(), Boolean.valueOf(ObjUtils.getSafeString(entry.getValue())));
				}
				//userUI.put(entry.getKey(), Boolean.valueOf(ObjUtils.getSafeString(entry.getValue())));
			}
			appOption = ObjUtils.toJsonStr(userUI);
		}
		model.put("appOption", appOption);

		//법인변경
		Map compParam = new HashMap();
		compParam.put("S_USER_ID", loginVo.getUserID());
		compParam.put("S_LANG_CODE", loginVo.getLanguage());

		List<Map<String, Object>> compList = mainCommonService.compList(compParam);
		model.put("compList", ObjUtils.toJsonStr(compList));

		logger.debug("Model {} ", model);
		logger.debug("####  LoginVO.getToken() {} ", loginVo.getToken());

		//비밀번호 대소문자 구분
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVo.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("B110", "40");   //대소문자 구분
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("caseSensYN",cdo.getRefCode1());
		}

		logger.debug("Model {} ", model);

		return JSP_PATH + "mainKocis";
	}

	/**
	 * <pre>
	 * 일반 메인 페이지
	 *  - JOINS 프로젝트에서 사용
	 * </pre>
	 *
	 * @param loginVo
	 * @param model
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/misMain.do", method = {RequestMethod.GET,  RequestMethod.POST})
	public String misIndex(LoginVO loginVo, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {

		List<UniModuleModel> modules = new ArrayList() ;
		List<UniModuleModel> userModules = new ArrayList() ;
		logger.debug("common.main.showAllModules : "+ObjUtils.getSafeString(ConfigUtil.getProperty("common.main.showAllModules")));
		//if("false".equals(ObjUtils.getSafeString(ConfigUtil.getProperty("common.main.showAllModules"))))	{
			userModules = mainCommonService.getUserModules(loginVo);
			modules = tlabMenuService.getModules(loginVo.getCompCode());
		//}else {
		//	modules = tlabMenuService.getModules(loginVo.getCompCode());
		//}
		List<Map<String,String>> mods = new ArrayList<Map<String,String>>();
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("S_COMP_CODE", loginVo.getCompCode());
//		Object processMenu = mainMenuService.getProcessMenu(param);
		String firstModuleName ="";

		if(modules != null ) {
			for(int i = 0, len = modules.size(); i < len; i ++) {
				UniModuleModel module = modules.get(i) ;

				Map<String,String> rec = new HashMap<String,String>();
				rec.put("id", module.getId());
				rec.put("title", module.getCodeName(loginVo.getLanguage()));

				for(UniModuleModel userModule : userModules)	{
					if(ObjUtils.getSafeString(module.getId()).equals(userModule.getId()) )	{
						rec.put("show", "true");
						break;
					}
				}

				mods.add(rec);
				if(i == 0 ) {
					firstModuleName = rec.get("title");
				}
			}
			logger.debug("#############################################	"+ modules.toString() + "####################################");
		}else {
			logger.debug("#############################################	 modules is null  ####################################");
		}

		if(mods != null && mods.size() > 0 ) {
			model.put("modulesStr", JsonUtils.toJsonStr(mods));
		} else {
			//model.put("modulesStr", "[{'id':'11','title':'DEMO'}]");
			model.put("modulesStr", "[]");
		}

		model.put("contextList", getContextListJson());
		model.put("contextName", Unilite.getCurrentContextName(request.getContextPath()));

		StringBuffer appOption = new StringBuffer();
		Map<String, Object> userUI = (Map<String, Object>)mainCommonService.getUserUI(loginVo);
		if(userUI == null || ObjUtils.isEmpty(userUI))	{
			appOption.append("{collapseMenuOnOpen: true, showPgmId: false, collapseLeftSearch: true}");
		}else {
			for (Map.Entry<String, Object> entry : userUI.entrySet())
			{
				userUI.put(entry.getKey(), Boolean.valueOf(ObjUtils.getSafeString(entry.getValue())));
			}
			appOption = ObjUtils.toJsonStr(userUI);
		}
		model.put("appOption", appOption);

		Map compParam = new HashMap();
		compParam.put("S_USER_ID", loginVo.getUserID());
		compParam.put("S_LANG_CODE", loginVo.getLanguage());

		List<Map<String, Object>> compList = mainCommonService.compList(compParam);
		model.put("compList", ObjUtils.toJsonStr(compList));

		logger.debug("Model {} ", model);
		logger.debug("####  LoginVO.getToken() {} ", loginVo.getToken());

		//비밀번호 대소문자 구분
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVo.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("B110", "40");	//대소문자 구분
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("caseSensYN",cdo.getRefCode1());
		}

		response.setHeader("Access-Control-Allow-Origin", "*");
		response.setHeader("Access-Control-Allow-Methods","POST,GET,OPTIONS");
		//response.setHeader("Access-Control-Allow-Headers", "Content-Type");
		response.setHeader("Access-Control-Allow-Headers", "x-requested-with");
		return JSP_PATH + "misMain";
	}

	/**
	 * <pre>
	 * 일반 메인 페이지
	 *  - JOINS 프로젝트(Jbill)에서 사용
	 * </pre>
	 *
	 * @param loginVo
	 * @param model
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/jbillMain.do", method = {RequestMethod.GET,  RequestMethod.POST})
	public String jbillIndex(LoginVO loginVo, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {

		List<UniModuleModel> modules = new ArrayList() ;
		List<UniModuleModel> userModules = new ArrayList() ;
		logger.debug("common.main.showAllModules : "+ObjUtils.getSafeString(ConfigUtil.getProperty("common.main.showAllModules")));
		//if("false".equals(ObjUtils.getSafeString(ConfigUtil.getProperty("common.main.showAllModules"))))	{
			userModules = mainCommonService.getUserModules(loginVo);
			modules = tlabMenuService.getModules(loginVo.getCompCode());
		//}else {
		//	modules = tlabMenuService.getModules(loginVo.getCompCode());
		//}
		List<Map<String,String>> mods = new ArrayList<Map<String,String>>();
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("S_COMP_CODE", loginVo.getCompCode());
//		Object processMenu = mainMenuService.getProcessMenu(param);
		String firstModuleName ="";

		if(modules != null ) {
			for(int i = 0, len = modules.size(); i < len; i ++) {
				UniModuleModel module = modules.get(i) ;

				Map<String,String> rec = new HashMap<String,String>();
				rec.put("id", module.getId());
				rec.put("title", module.getCodeName(loginVo.getLanguage()));

				for(UniModuleModel userModule : userModules)	{
					if(ObjUtils.getSafeString(module.getId()).equals(userModule.getId()) )	{
						rec.put("show", "true");
						break;
					}
				}

				mods.add(rec);
				if(i == 0 ) {
					firstModuleName = rec.get("title");
				}
			}
			logger.debug("#############################################	"+ modules.toString() + "####################################");
		}else {
			logger.debug("#############################################	 modules is null  ####################################");
		}

		if(mods != null && mods.size() > 0 ) {
			model.put("modulesStr", JsonUtils.toJsonStr(mods));
		} else {
			//model.put("modulesStr", "[{'id':'11','title':'DEMO'}]");
			model.put("modulesStr", "[]");
		}

		model.put("contextList", getContextListJson());
		model.put("contextName", Unilite.getCurrentContextName(request.getContextPath()));

		StringBuffer appOption = new StringBuffer();
		Map<String, Object> userUI = (Map<String, Object>)mainCommonService.getUserUI(loginVo);
		if(userUI == null || ObjUtils.isEmpty(userUI))	{
			appOption.append("{collapseMenuOnOpen: true, showPgmId: false, collapseLeftSearch: true}");
		}else {
			for (Map.Entry<String, Object> entry : userUI.entrySet())
			{
				userUI.put(entry.getKey(), Boolean.valueOf(ObjUtils.getSafeString(entry.getValue())));
			}
			appOption = ObjUtils.toJsonStr(userUI);
		}
		model.put("appOption", appOption);

		Map compParam = new HashMap();
		compParam.put("S_USER_ID", loginVo.getUserID());
		compParam.put("S_LANG_CODE", loginVo.getLanguage());

		List<Map<String, Object>> compList = mainCommonService.compList(compParam);
		model.put("compList", ObjUtils.toJsonStr(compList));

		logger.debug("Model {} ", model);
		logger.debug("####  LoginVO.getToken() {} ", loginVo.getToken());

		//비밀번호 대소문자 구분
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVo.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("B110", "40");	//대소문자 구분
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("caseSensYN",cdo.getRefCode1());
		}

		response.setHeader("Access-Control-Allow-Origin", "*");
		response.setHeader("Access-Control-Allow-Methods","POST,GET,OPTIONS");
		//response.setHeader("Access-Control-Allow-Headers", "Content-Type");
		response.setHeader("Access-Control-Allow-Headers", "x-requested-with");
		return JSP_PATH + "jbillMain";
	}

	/**
	 * <pre>
	 * 일반 메인 페이지
	 *  - 버스운수 프로젝트에서 사용
	 * </pre>
	 *
	 * @param loginVo
	 * @param model
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/main_bus.do", method = RequestMethod.GET)
	public String main_bus(LoginVO loginVo, ModelMap model, HttpServletRequest request) throws Exception {

		List<UniModuleModel> modules = tlabMenuService.getModules(loginVo.getCompCode());
		List<Map<String,String>> mods = new ArrayList<Map<String,String>>();
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("S_COMP_CODE", loginVo.getCompCode());
//		Object processMenu = mainMenuService.getProcessMenu(param);
		String firstModuleName ="";
		if(modules != null ) {
			for(int i = 0, len = modules.size(); i < len; i ++) {
				UniModuleModel module = modules.get(i) ;

				Map<String,String> rec = new HashMap<String,String>();
				rec.put("id", module.getId());
				rec.put("title", module.getCodeName(loginVo.getLanguage()));
				mods.add(rec);
				if(i == 0 ) {
					firstModuleName = rec.get("title");
				}
			}
		}
		if(mods != null && mods.size() > 0 ) {
			model.put("modulesStr", JsonUtils.toJsonStr(mods));
		} else {
			//model.put("modulesStr", "[{'id':'11','title':'DEMO'}]");
			model.put("modulesStr", "[]");
		}

		model.put("contextList", getContextListJson());
		model.put("contextName", Unilite.getCurrentContextName(request.getContextPath()));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVo.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("GO41", "10");
		if(!ObjUtils.isEmpty(cdo))	{
			model.addAttribute("gttStartTime",ObjUtils.nvlObj(cdo.getRefCode1(),"0400"));
			model.addAttribute("gttEndTime",ObjUtils.nvlObj(cdo.getRefCode2(),"0859"));
			model.addAttribute("refreshGttTime",ObjUtils.nvlObj(cdo.getRefCode3(),"-1"));
		}else {
			model.addAttribute("refreshTime","-1");
		}

		cdo = codeInfo.getCodeInfo("GO41", "20");
		if(!ObjUtils.isEmpty(cdo))	{
			model.addAttribute("startTime",ObjUtils.nvlObj(cdo.getRefCode1(),"0900"));
			model.addAttribute("endTime",ObjUtils.nvlObj(cdo.getRefCode2(),"2359"));
			model.addAttribute("refreshTime",ObjUtils.nvlObj(cdo.getRefCode3(),"-1"));
		}else {
			model.addAttribute("refreshTime","-1");
		}

		cdo = codeInfo.getCodeInfo("GO40", "10");
		if(!ObjUtils.isEmpty(cdo))	{
			model.addAttribute("refreshNoticeTime",ObjUtils.nvlObj(cdo.getRefCode1(),"-1"));
		}else {
			model.addAttribute("refreshNoticeTime","-1");
		}

		StringBuffer appOption = new StringBuffer();
		Map<String, Object> userUI = (Map<String, Object>)mainCommonService.getUserUI(loginVo);
		if(userUI == null || ObjUtils.isEmpty(userUI))	{
			appOption.append("{collapseMenuOnOpen: true, showPgmId: false, collapseLeftSearch: true}");
		}else {
			for (Map.Entry<String, Object> entry : userUI.entrySet())
			{
				userUI.put(entry.getKey(), Boolean.valueOf(ObjUtils.getSafeString(entry.getValue())));
			}
			appOption = ObjUtils.toJsonStr(userUI);
		}
		model.put("appOption", appOption);

		logger.debug("Model {} ", model);
		return JSP_PATH + "main_bus";
	}

	/**
	 * <pre>
	 * 일반 메인 페이지
	 *  - 연세대 프로젝트에서 사용
	 * </pre>
	 *
	 * @param loginVo
	 * @param model
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/main_ysu.do", method = RequestMethod.GET)
	public String index_ysu(LoginVO loginVo, ModelMap model, HttpServletRequest request) throws Exception {

		List<UniModuleModel> modules = tlabMenuService.getModules(loginVo.getCompCode());
		List<Map<String,String>> mods = new ArrayList<Map<String,String>>();
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("S_COMP_CODE", loginVo.getCompCode());

		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
//		Object processMenu = mainMenuService.getProcessMenu(param);
		String firstModuleName ="";
		if(modules != null ) {
			for(int i = 0, len = modules.size(); i < len; i ++) {
				UniModuleModel module = modules.get(i) ;

				Map<String,String> rec = new HashMap<String,String>();
				rec.put("id", module.getId());
				rec.put("title", module.getCodeName(loginVo.getLanguage()));
				mods.add(rec);
				if(i == 0 ) {
					firstModuleName = rec.get("title");
				}
			}
			logger.debug("#############################################	"+ modules.toString() + "####################################");
		}else {
			logger.debug("#############################################	 modules is null  ####################################");
		}
		if(mods != null && mods.size() > 0 ) {
			model.put("modulesStr", JsonUtils.toJsonStr(mods));
		} else {
			//model.put("modulesStr", "[{'id':'11','title':'DEMO'}]");
			model.put("modulesStr", "[]");
		}

		model.put("contextList", getContextListJson());
		model.put("contextName", Unilite.getCurrentContextName(request.getContextPath()));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVo.getCompCode());
		CodeDetailVO cdo =  codeInfo.getCodeInfo("YP34", "1");;
		if(!ObjUtils.isEmpty(cdo)){
			model.put("TopMsg", cdo.getCodeName());
		}

		StringBuffer appOption = new StringBuffer();
		Map<String, Object> userUI = (Map<String, Object>)mainCommonService.getUserUI(loginVo);
		if(userUI == null || ObjUtils.isEmpty(userUI))	{
			appOption.append("{collapseMenuOnOpen: true, showPgmId: false, collapseLeftSearch: true}");
		}else {
			for (Map.Entry<String, Object> entry : userUI.entrySet())
			{
				userUI.put(entry.getKey(), Boolean.valueOf(ObjUtils.getSafeString(entry.getValue())));
			}
			appOption = ObjUtils.toJsonStr(userUI);
		}
		model.put("appOption", appOption);

		//비밀번호 대소문자 구분

		CodeDetailVO cdo2 = null;

		cdo2 = codeInfo.getCodeInfo("B110", "40");	//대소문자 구분
		if(!ObjUtils.isEmpty(cdo2)){
			model.addAttribute("caseSensYN",cdo2.getRefCode1());
		}

		logger.debug("Model {} ", model);
		return JSP_PATH + "main_ysu";
	}

	/**
	 * <pre>
	 * 일반 메인 페이지
	 *  - 연세대 프로젝트에서 사용
	 * </pre>
	 *
	 * @param loginVo
	 * @param model
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/main_ysu_ext.do", method = RequestMethod.GET)
	public String index_ysu_ext(LoginVO loginVo, ModelMap model, HttpServletRequest request) throws Exception {


		model.put("contextList", getContextListJson());
		model.put("contextName", Unilite.getCurrentContextName(request.getContextPath()));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVo.getCompCode());
		CodeDetailVO cdo =  codeInfo.getCodeInfo("YP34", "1");;
		if(!ObjUtils.isEmpty(cdo)){
			model.put("TopMsg", cdo.getCodeName());
		}

		logger.debug("Model {} ", model);
		return JSP_PATH + "main_ysu_ext";
	}


	/**
	 * <pre>
	 * 일반 메인 페이지
	 *  - LGSAAS 프로젝트에서 사용
	 * </pre>
	 *
	 * @param loginVo
	 * @param model
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/main_lgsaas.do", method = RequestMethod.GET)
	public String index_lgsaas(LoginVO loginVo, ModelMap model, HttpServletRequest request) throws Exception {

		List<UniModuleModel> modules = tlabMenuService.getModules(loginVo.getCompCode());
		List<Map<String,String>> mods = new ArrayList<Map<String,String>>();
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("S_COMP_CODE", loginVo.getCompCode());
//		Object processMenu = mainMenuService.getProcessMenu(param);
		String firstModuleName ="";
		if(modules != null ) {
			for(int i = 0, len = modules.size(); i < len; i ++) {
				UniModuleModel module = modules.get(i) ;

				Map<String,String> rec = new HashMap<String,String>();
				rec.put("id", module.getId());
				rec.put("title", module.getCodeName(loginVo.getLanguage()));
				mods.add(rec);
				if(i == 0 ) {
					firstModuleName = rec.get("title");
				}
			}
			logger.debug("#############################################	"+ modules.toString() + "####################################");
		}else {
			logger.debug("#############################################	 modules is null  ####################################");
		}
		if(mods != null && mods.size() > 0 ) {
			model.put("modulesStr", JsonUtils.toJsonStr(mods));
		} else {
			//model.put("modulesStr", "[{'id':'11','title':'DEMO'}]");
			model.put("modulesStr", "[]");
		}

		model.put("contextList", getContextListJson());
		model.put("contextName", Unilite.getCurrentContextName(request.getContextPath()));

		StringBuffer appOption = new StringBuffer();
		Map<String, Object> userUI = (Map<String, Object>)mainCommonService.getUserUI(loginVo);
		if(userUI == null || ObjUtils.isEmpty(userUI))	{
			appOption.append("{collapseMenuOnOpen: true, showPgmId: false, collapseLeftSearch: true}");
		}else {
			for (Map.Entry<String, Object> entry : userUI.entrySet())
			{
				userUI.put(entry.getKey(), Boolean.valueOf(ObjUtils.getSafeString(entry.getValue())));
			}
			appOption = ObjUtils.toJsonStr(userUI);
		}
		model.put("appOption", appOption);

		logger.debug("Model {} ", model);
		return JSP_PATH + "main_lgsaas";
	}

	/**
	 * 극동 가스켓 메인 페이지
	 * @param loginVo
	 * @param model
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/main_KDG.do", method = RequestMethod.GET)
	public String index_KDG(LoginVO loginVo, ModelMap model, HttpServletRequest request) throws Exception {

		List<UniModuleModel> modules = tlabMenuService.getModules(loginVo.getCompCode());
		List<Map<String,String>> mods = new ArrayList<Map<String,String>>();
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("S_COMP_CODE", loginVo.getCompCode());
//		Object processMenu = mainMenuService.getProcessMenu(param);
		String firstModuleName ="";
		if(modules != null ) {
			for(int i = 0, len = modules.size(); i < len; i ++) {
				UniModuleModel module = modules.get(i) ;

				Map<String,String> rec = new HashMap<String,String>();
				rec.put("id", module.getId());
				rec.put("title", module.getCodeName(loginVo.getLanguage()));
				mods.add(rec);
				if(i == 0 ) {
					firstModuleName = rec.get("title");
				}
			}
			logger.debug("#############################################	"+ modules.toString() + "####################################");
		}else {
			logger.debug("#############################################	 modules is null  ####################################");
		}
		if(mods != null && mods.size() > 0 ) {
			model.put("modulesStr", JsonUtils.toJsonStr(mods));
		} else {
			//model.put("modulesStr", "[{'id':'11','title':'DEMO'}]");
			model.put("modulesStr", "[]");
		}

		model.put("contextList", getContextListJson());
		model.put("contextName", Unilite.getCurrentContextName(request.getContextPath()));

		StringBuffer appOption = new StringBuffer();
		Map<String, Object> userUI = (Map<String, Object>)mainCommonService.getUserUI(loginVo);
		if(userUI == null || ObjUtils.isEmpty(userUI))	{
			appOption.append("{collapseMenuOnOpen: true, showPgmId: false, collapseLeftSearch: true}");
		}else {
			for (Map.Entry<String, Object> entry : userUI.entrySet())
			{
				if(entry.getKey().equals("downEnterKey"))	{
					userUI.put(entry.getKey(), ObjUtils.getSafeString(entry.getValue()));
				} else {
					userUI.put(entry.getKey(), Boolean.valueOf(ObjUtils.getSafeString(entry.getValue())));
				}
				//userUI.put(entry.getKey(), Boolean.valueOf(ObjUtils.getSafeString(entry.getValue())));
			}
			appOption = ObjUtils.toJsonStr(userUI);
		}
		model.put("appOption", appOption);

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVo.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("B906", "10");	//회사문구
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("companyTitle", ObjUtils.nvlObj(cdo.getCodeName(loginVo.getLanguage()),"시너지시스템즈는 대한민국 기업IT화에 앞장서는 ERP Solution 전문업체입니다."));
		} else {
			model.addAttribute("companyTitle", "시너지시스템즈는 대한민국 기업IT화에 앞장서는 ERP Solution 전문업체입니다.");
		}

		logger.debug("Model {} ", model);

		return JSP_PATH + "main_KDG";
	}
	@RequestMapping(value = "/main_inno.do", method = RequestMethod.GET)
	public String index_inno(LoginVO loginVo, ModelMap model, HttpServletRequest request) throws Exception {

		List<UniModuleModel> modules = tlabMenuService.getModules(loginVo.getCompCode());
		List<Map<String,String>> mods = new ArrayList<Map<String,String>>();
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("S_COMP_CODE", loginVo.getCompCode());

		String firstModuleName ="";
		if(modules != null ) {
			for(int i = 0, len = modules.size(); i < len; i ++) {
				UniModuleModel module = modules.get(i) ;

				Map<String,String> rec = new HashMap<String,String>();
				rec.put("id", module.getId());
				rec.put("title", module.getCodeName(loginVo.getLanguage()));
				mods.add(rec);
				if(i == 0 ) {
					firstModuleName = rec.get("title");
				}
			}
			logger.debug("#############################################	"+ modules.toString() + "####################################");
		}else {
			logger.debug("#############################################	 modules is null  ####################################");
		}
		if(mods != null && mods.size() > 0 ) {
			model.put("modulesStr", JsonUtils.toJsonStr(mods));
		} else {
			model.put("modulesStr", "[]");
		}

		model.put("contextList", getContextListJson());
		model.put("contextName", Unilite.getCurrentContextName(request.getContextPath()));

		StringBuffer appOption = new StringBuffer();
		Map<String, Object> userUI = (Map<String, Object>)mainCommonService.getUserUI(loginVo);
		if(userUI == null || ObjUtils.isEmpty(userUI))	{
			appOption.append("{collapseMenuOnOpen: true, showPgmId: false, collapseLeftSearch: true}");
		}else {
			for (Map.Entry<String, Object> entry : userUI.entrySet())
			{
				if(entry.getKey().equals("downEnterKey"))	{
					userUI.put(entry.getKey(), ObjUtils.getSafeString(entry.getValue()));
				} else {
					userUI.put(entry.getKey(), Boolean.valueOf(ObjUtils.getSafeString(entry.getValue())));
				}
				//userUI.put(entry.getKey(), Boolean.valueOf(ObjUtils.getSafeString(entry.getValue())));
			}
			appOption = ObjUtils.toJsonStr(userUI);
		}
		model.put("appOption", appOption);

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVo.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("B906", "10");	//회사문구
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("companyTitle", ObjUtils.nvlObj(cdo.getCodeName(loginVo.getLanguage()),"시너지시스템즈는 대한민국 기업IT화에 앞장서는 ERP Solution 전문업체입니다."));
		} else {
			model.addAttribute("companyTitle", "시너지시스템즈는 대한민국 기업IT화에 앞장서는 ERP Solution 전문업체입니다.");
		}

		logger.debug("Model {} ", model);

		return JSP_PATH + "main_inno";
	}
	/**
	 * 양평공사 메인 페이지
	 * @param loginVo
	 * @param model
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/main_yp.do", method = RequestMethod.GET)
	public String index_YP(LoginVO loginVo, ModelMap model, HttpServletRequest request) throws Exception {

		List<UniModuleModel> modules = tlabMenuService.getModules(loginVo.getCompCode());
		List<Map<String,String>> mods = new ArrayList<Map<String,String>>();
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("S_COMP_CODE", loginVo.getCompCode());
//		Object processMenu = mainMenuService.getProcessMenu(param);
		String firstModuleName ="";
		if(modules != null ) {
			for(int i = 0, len = modules.size(); i < len; i ++) {
				UniModuleModel module = modules.get(i) ;

				Map<String,String> rec = new HashMap<String,String>();
				rec.put("id", module.getId());
				rec.put("title", module.getCodeName(loginVo.getLanguage()));
				mods.add(rec);
				if(i == 0 ) {
					firstModuleName = rec.get("title");
				}
			}
			logger.debug("#############################################	"+ modules.toString() + "####################################");
		}else {
			logger.debug("#############################################	 modules is null  ####################################");
		}
		if(mods != null && mods.size() > 0 ) {
			model.put("modulesStr", JsonUtils.toJsonStr(mods));
		} else {
			//model.put("modulesStr", "[{'id':'11','title':'DEMO'}]");
			model.put("modulesStr", "[]");
		}

		model.put("contextList", getContextListJson());
		model.put("contextName", Unilite.getCurrentContextName(request.getContextPath()));

		StringBuffer appOption = new StringBuffer();
		Map<String, Object> userUI = (Map<String, Object>)mainCommonService.getUserUI(loginVo);
		if(userUI == null || ObjUtils.isEmpty(userUI))	{
			appOption.append("{collapseMenuOnOpen: true, showPgmId: false, collapseLeftSearch: true}");
		}else {
			for (Map.Entry<String, Object> entry : userUI.entrySet())
			{
				if(entry.getKey().equals("downEnterKey"))	{
					userUI.put(entry.getKey(), ObjUtils.getSafeString(entry.getValue()));
				} else {
					userUI.put(entry.getKey(), Boolean.valueOf(ObjUtils.getSafeString(entry.getValue())));
				}
				//userUI.put(entry.getKey(), Boolean.valueOf(ObjUtils.getSafeString(entry.getValue())));
			}
			appOption = ObjUtils.toJsonStr(userUI);
		}
		model.put("appOption", appOption);

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVo.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("B906", "10");	//회사문구
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("companyTitle", ObjUtils.nvlObj(cdo.getCodeName(loginVo.getLanguage()),"시너지시스템즈는 대한민국 기업IT화에 앞장서는 ERP Solution 전문업체입니다."));
		} else {
			model.addAttribute("companyTitle", "시너지시스템즈는 대한민국 기업IT화에 앞장서는 ERP Solution 전문업체입니다.");
		}

		logger.debug("Model {} ", model);

		return JSP_PATH + "main_yp";
	}

	/**
	 * <pre>
	 *
	 * 양평공사 외부사용자용
	 * </pre>
	 *
	 * @param loginVo
	 * @param model
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/main_yp_ext.do", method = RequestMethod.GET)
	public String index_yp_ext(LoginVO loginVo, ModelMap model, HttpServletRequest request) throws Exception {

		model.put("contextList", getContextListJson());
		model.put("contextName", Unilite.getCurrentContextName(request.getContextPath()));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVo.getCompCode());
		CodeDetailVO cdo =  codeInfo.getCodeInfo("YP34", "1");;
		if(!ObjUtils.isEmpty(cdo)){
			model.put("TopMsg", cdo.getCodeName());
		}
		Gson gson = new Gson();
		Map<String, String> param = new HashMap<String, String>();
		param.put("S_COMP_CODE", loginVo.getCompCode());
		param.put("PGM_SEQ", "95"); //양평공사용.. B007 SUB_CODE(WEB업무 )
		String pgmData = gson.toJson(mainMenuService.getExtUserMenu(param));
		model.put("pgmData", pgmData);
		logger.debug("Model {} ", model);
		return JSP_PATH + "main_yp_ext";
	}

	/**
	 * 일반 메인 페이지
	 * @param loginVo
	 * @param model
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/main_SDC.do", method = RequestMethod.GET)
	public String index_SDC(LoginVO loginVo, ModelMap model, HttpServletRequest request) throws Exception {
		List<UniModuleModel> modules = new ArrayList() ;
		List<UniModuleModel> userModules = new ArrayList() ;
		// 모듈 아이콘 표시 속성
		String pShowModules = ObjUtils.getSafeString(ConfigUtil.getProperty("common.main.showAllModules"));
		if("false".equals(pShowModules))	{
			userModules = mainCommonService.getUserModules(loginVo);
			modules = tlabMenuService.getModules(loginVo.getCompCode());
		}else {
			modules = tlabMenuService.getModules(loginVo.getCompCode());
		}
		List<Map<String,String>> mods = new ArrayList<Map<String,String>>();
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("S_COMP_CODE", loginVo.getCompCode());
//	  Object processMenu = mainMenuService.getProcessMenu(param);
		String firstModuleName ="";
		if(modules != null ) {
			for(int i = 0, len = modules.size(); i < len; i ++) {
				UniModuleModel module = modules.get(i) ;

				Map<String,String> rec = new HashMap<String,String>();
				rec.put("id", module.getId());
				rec.put("title", module.getCodeName(loginVo.getLanguage()));
				if("false".equals(pShowModules))	{
					for(UniModuleModel userModule : userModules)	{
						if(ObjUtils.getSafeString(module.getId()).equals(userModule.getId()) )  {
							rec.put("show", "true");
							break;
						}
					}
				}else {
					rec.put("show", "true");
				}

				mods.add(rec);
				if(i == 0 ) {
					firstModuleName = rec.get("title");
				}
			}
			logger.debug("#############################################	"+ modules.toString() + "####################################");
		}else {
			logger.debug("#############################################	 modules is null  ####################################");
		}
		if(mods != null && mods.size() > 0 ) {
			model.put("modulesStr", JsonUtils.toJsonStr(mods));
		} else {
			//model.put("modulesStr", "[{'id':'11','title':'DEMO'}]");
			model.put("modulesStr", "[]");
		}

		model.put("contextList", getContextListJson());
		model.put("contextName", Unilite.getCurrentContextName(request.getContextPath()));

		StringBuffer appOption = new StringBuffer();
		Map<String, Object> userUI = (Map<String, Object>)mainCommonService.getUserUI(loginVo);
		if(userUI == null || ObjUtils.isEmpty(userUI))  {
			appOption.append("{collapseMenuOnOpen: true, showPgmId: false, collapseLeftSearch: true}");
		}else {
			for (Map.Entry<String, Object> entry : userUI.entrySet())
			{
				if(entry.getKey().equals("downEnterKey"))	{
					userUI.put(entry.getKey(), ObjUtils.getSafeString(entry.getValue()));
				} else {
					userUI.put(entry.getKey(), Boolean.valueOf(ObjUtils.getSafeString(entry.getValue())));
				}
				//userUI.put(entry.getKey(), Boolean.valueOf(ObjUtils.getSafeString(entry.getValue())));
			}
			appOption = ObjUtils.toJsonStr(userUI);
		}
		model.put("appOption", appOption);

		//법인변경
		Map compParam = new HashMap();
		compParam.put("S_USER_ID", loginVo.getUserID());
		compParam.put("S_LANG_CODE", loginVo.getLanguage());

		List<Map<String, Object>> compList = mainCommonService.compList(compParam);
		model.put("compList", ObjUtils.toJsonStr(compList));

		logger.debug("Model {} ", model);
		logger.debug("####  LoginVO.getToken() {} ", loginVo.getToken());

		//비밀번호 대소문자 구분
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVo.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("B110", "40");   //대소문자 구분
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("caseSensYN",cdo.getRefCode1());
		}

		logger.debug("Model {} ", model);

		return JSP_PATH + "main_SDC";
	}


	private StringBuffer getContextListJson() {

	   return JsonUtils.toJsonStr(Unilite.getContextList());
	}

	@RequestMapping(value = "/dummy.do", method = RequestMethod.GET)
	public String dummy() throws Exception {

		return JSP_PATH + "dummy";
	}

	@RequestMapping(value = "/process.do", method = RequestMethod.GET)
	public String processPage(String processID) throws Exception {
		String viewFile = "/com/process/" + processID ;
		return viewFile;
	}

	 /**
	 * <pre>
	 * kodi vmi
	 * </pre>
	 *
	 * @param loginVo
	 * @param model
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/main_kodi_vmi.do", method = RequestMethod.GET)
	public String main_kodi_vmi(LoginVO loginVo, ModelMap model, HttpServletRequest request) throws Exception {


		model.put("contextList", getContextListJson());
		model.put("contextName", Unilite.getCurrentContextName(request.getContextPath()));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVo.getCompCode());
		CodeDetailVO cdo = null;
		cdo = codeInfo.getCodeInfo("B906", "10");	//회사문구
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("companyTitle", ObjUtils.nvlObj(cdo.getCodeName(loginVo.getLanguage()),"시너지시스템즈는 대한민국 기업IT화에 앞장서는 ERP Solution 전문업체입니다."));
		} else {
			model.addAttribute("companyTitle", "시너지시스템즈는 대한민국 기업IT화에 앞장서는 ERP Solution 전문업체입니다.");
		}

		logger.debug("Model {} ", model);
		return JSP_PATH + "main_kodi_vmi";
	}

	 /**
	 * <pre>
	 * inno vmi
	 * </pre>
	 *
	 * @param loginVo
	 * @param model
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/main_inno_vmi.do", method = RequestMethod.GET)
	public String main_inno_vmi(LoginVO loginVo, ModelMap model, HttpServletRequest request) throws Exception {


		model.put("contextList", getContextListJson());
		model.put("contextName", Unilite.getCurrentContextName(request.getContextPath()));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVo.getCompCode());
		CodeDetailVO cdo = null;
		cdo = codeInfo.getCodeInfo("B906", "10");	//회사문구
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("companyTitle", ObjUtils.nvlObj(cdo.getCodeName(loginVo.getLanguage()),"시너지시스템즈는 대한민국 기업IT화에 앞장서는 ERP Solution 전문업체입니다."));
		} else {
			model.addAttribute("companyTitle", "시너지시스템즈는 대한민국 기업IT화에 앞장서는 ERP Solution 전문업체입니다.");
		}

		logger.debug("Model {} ", model);
		return JSP_PATH + "main_inno_vmi";
	}

	/**
	 * 엠아이텍 메인 페이지
	 * @param loginVo
	 * @param model
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/main_mit.do", method = RequestMethod.GET)
	public String index_mit(LoginVO loginVo, ModelMap model, HttpServletRequest request) throws Exception {
		List<UniModuleModel> modules = new ArrayList() ;
		List<UniModuleModel> userModules = new ArrayList() ;
		// 모듈 아이콘 표시 속성
		logger.debug(">>>>>>>>>>>>>> loginVo.getLanguage()  :"+loginVo.getLanguage());
		String pShowModules = ObjUtils.getSafeString(ConfigUtil.getProperty("common.main.showAllModules"));
		if("false".equals(pShowModules))	{
			userModules = mainCommonService.getUserModules(loginVo);
			modules = tlabMenuService.getModules(loginVo.getCompCode());
		}else {
			modules = tlabMenuService.getModules(loginVo.getCompCode());
		}
		List<Map<String,String>> mods = new ArrayList<Map<String,String>>();
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("S_COMP_CODE", loginVo.getCompCode());
//		Object processMenu = mainMenuService.getProcessMenu(param);
		String firstModuleName ="";
		if(modules != null ) {
			for(int i = 0, len = modules.size(); i < len; i ++) {
				UniModuleModel module = modules.get(i) ;

				Map<String,String> rec = new HashMap<String,String>();
				rec.put("id", module.getId());
				rec.put("title", module.getCodeName(loginVo.getLanguage()));
				if("false".equals(pShowModules))	{
					for(UniModuleModel userModule : userModules)	{
						if(ObjUtils.getSafeString(module.getId()).equals(userModule.getId()) )	{
							rec.put("show", "true");
							break;
						}
					}
				}else {
					rec.put("show", "true");
				}

				mods.add(rec);
				if(i == 0 ) {
					firstModuleName = rec.get("title");
				}
			}
			logger.debug("#############################################	"+ modules.toString() + "####################################");
		}else {
			logger.debug("#############################################	 modules is null  ####################################");
		}
		if(mods != null && mods.size() > 0 ) {
			model.put("modulesStr", JsonUtils.toJsonStr(mods));
		} else {
			//model.put("modulesStr", "[{'id':'11','title':'DEMO'}]");
			model.put("modulesStr", "[]");
		}

		model.put("contextList", getContextListJson());
		model.put("contextName", Unilite.getCurrentContextName(request.getContextPath()));

		StringBuffer appOption = new StringBuffer();
		Map<String, Object> userUI = (Map<String, Object>)mainCommonService.getUserUI(loginVo);
		if(userUI == null || ObjUtils.isEmpty(userUI))	{
			appOption.append("{collapseMenuOnOpen: true, showPgmId: false, collapseLeftSearch: true}");
		}else {
			for (Map.Entry<String, Object> entry : userUI.entrySet())
			{
				if(entry.getKey().equals("downEnterKey"))	{
					userUI.put(entry.getKey(), ObjUtils.getSafeString(entry.getValue()));
				} else {
					userUI.put(entry.getKey(), Boolean.valueOf(ObjUtils.getSafeString(entry.getValue())));
				}
			}
			appOption = ObjUtils.toJsonStr(userUI);
		}
		model.put("appOption", appOption);

		//법인변경
		Map compParam = new HashMap();
		compParam.put("S_USER_ID", loginVo.getUserID());
		compParam.put("S_LANG_CODE", loginVo.getLanguage());

		List<Map<String, Object>> compList = mainCommonService.compList(compParam);
		model.put("compList", ObjUtils.toJsonStr(compList));

		logger.debug("Model {} ", model);
		logger.debug("####  LoginVO.getToken() {} ", loginVo.getToken());

		//비밀번호 대소문자 구분
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVo.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("B110", "40");	//대소문자 구분
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("caseSensYN",cdo.getRefCode1());
		}

		cdo = codeInfo.getCodeInfo("B906", "10");	//회사문구
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("companyTitle", ObjUtils.nvlObj(cdo.getCodeName(loginVo.getLanguage()),"시너지시스템즈는 대한민국 기업IT화에 앞장서는 ERP Solution 전문업체입니다."));
		} else {
			model.addAttribute("companyTitle", "시너지시스템즈는 대한민국 기업IT화에 앞장서는 ERP Solution 전문업체입니다.");
		}

		logger.debug("Model {} ", model);

		return JSP_PATH + "main_mit";
	}



	/**
	 * 신환(이노코스텍) 메인 페이지
	 * @param loginVo
	 * @param model
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/main_shin.do", method = RequestMethod.GET)
	public String main_shin(LoginVO loginVo, ModelMap model, HttpServletRequest request) throws Exception {
		List<UniModuleModel> modules = new ArrayList() ;
		List<UniModuleModel> userModules = new ArrayList() ;
		// 모듈 아이콘 표시 속성
		logger.debug(">>>>>>>>>>>>>> loginVo.getLanguage()  :"+loginVo.getLanguage());
		String pShowModules = ObjUtils.getSafeString(ConfigUtil.getProperty("common.main.showAllModules"));
		if("false".equals(pShowModules))	{
			userModules = mainCommonService.getUserModules(loginVo);
			modules = tlabMenuService.getModules(loginVo.getCompCode());
		}else {
			modules = tlabMenuService.getModules(loginVo.getCompCode());
		}
		List<Map<String,String>> mods = new ArrayList<Map<String,String>>();
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("S_COMP_CODE", loginVo.getCompCode());
//		Object processMenu = mainMenuService.getProcessMenu(param);
		String firstModuleName ="";
		if(modules != null ) {
			for(int i = 0, len = modules.size(); i < len; i ++) {
				UniModuleModel module = modules.get(i) ;

				Map<String,String> rec = new HashMap<String,String>();
				rec.put("id", module.getId());
				rec.put("title", module.getCodeName(loginVo.getLanguage()));
				if("false".equals(pShowModules))	{
					for(UniModuleModel userModule : userModules)	{
						if(ObjUtils.getSafeString(module.getId()).equals(userModule.getId()) )	{
							rec.put("show", "true");
							break;
						}
					}
				}else {
					rec.put("show", "true");
				}

				mods.add(rec);
				if(i == 0 ) {
					firstModuleName = rec.get("title");
				}
			}
			logger.debug("#############################################	"+ modules.toString() + "####################################");
		}else {
			logger.debug("#############################################	 modules is null  ####################################");
		}
		if(mods != null && mods.size() > 0 ) {
			model.put("modulesStr", JsonUtils.toJsonStr(mods));
		} else {
			//model.put("modulesStr", "[{'id':'11','title':'DEMO'}]");
			model.put("modulesStr", "[]");
		}

		model.put("contextList", getContextListJson());
		model.put("contextName", Unilite.getCurrentContextName(request.getContextPath()));

		StringBuffer appOption = new StringBuffer();
		Map<String, Object> userUI = (Map<String, Object>)mainCommonService.getUserUI(loginVo);
		if(userUI == null || ObjUtils.isEmpty(userUI))	{
			appOption.append("{collapseMenuOnOpen: true, showPgmId: false, collapseLeftSearch: true}");
		}else {
			for (Map.Entry<String, Object> entry : userUI.entrySet())
			{
				if(entry.getKey().equals("downEnterKey"))	{
					userUI.put(entry.getKey(), ObjUtils.getSafeString(entry.getValue()));
				} else {
					userUI.put(entry.getKey(), Boolean.valueOf(ObjUtils.getSafeString(entry.getValue())));
				}
			}
			appOption = ObjUtils.toJsonStr(userUI);
		}
		model.put("appOption", appOption);

		//법인변경
		Map compParam = new HashMap();
		compParam.put("S_USER_ID", loginVo.getUserID());
		compParam.put("S_LANG_CODE", loginVo.getLanguage());

		List<Map<String, Object>> compList = mainCommonService.compList(compParam);
		model.put("compList", ObjUtils.toJsonStr(compList));

		logger.debug("Model {} ", model);
		logger.debug("####  LoginVO.getToken() {} ", loginVo.getToken());

		//비밀번호 대소문자 구분
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVo.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("B110", "40");	//대소문자 구분
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("caseSensYN",cdo.getRefCode1());
		}

		cdo = codeInfo.getCodeInfo("B906", "10");	//회사문구
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("companyTitle", ObjUtils.nvlObj(cdo.getCodeName(loginVo.getLanguage()),"시너지시스템즈는 대한민국 기업IT화에 앞장서는 ERP Solution 전문업체입니다."));
		} else {
			model.addAttribute("companyTitle", "시너지시스템즈는 대한민국 기업IT화에 앞장서는 ERP Solution 전문업체입니다.");
		}

		logger.debug("Model {} ", model);

		return JSP_PATH + "main_shin";
	}



	 /**
	 * <pre>
	 * shin vmi
	 * </pre>
	 *
	 * @param loginVo
	 * @param model
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/main_shin_vmi.do", method = RequestMethod.GET)
	public String main_shin_vmi(LoginVO loginVo, ModelMap model, HttpServletRequest request) throws Exception {


		model.put("contextList", getContextListJson());
		model.put("contextName", Unilite.getCurrentContextName(request.getContextPath()));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVo.getCompCode());
		CodeDetailVO cdo = null;
		cdo = codeInfo.getCodeInfo("B906", "10");	//회사문구
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("companyTitle", ObjUtils.nvlObj(cdo.getCodeName(loginVo.getLanguage()),"시너지시스템즈는 대한민국 기업IT화에 앞장서는 ERP Solution 전문업체입니다."));
		} else {
			model.addAttribute("companyTitle", "시너지시스템즈는 대한민국 기업IT화에 앞장서는 ERP Solution 전문업체입니다.");
		}

		logger.debug("Model {} ", model);
		return JSP_PATH + "main_shin_vmi";
	}


	/**
	 * kodi 메인 페이지
	 * @param loginVo
	 * @param model
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/main_kodi.do", method = RequestMethod.GET)
	public String index_kodi(LoginVO loginVo, ModelMap model, HttpServletRequest request) throws Exception {
		List<UniModuleModel> modules = new ArrayList() ;
		List<UniModuleModel> userModules = new ArrayList() ;
		// 모듈 아이콘 표시 속성
		logger.debug(">>>>>>>>>>>>>> loginVo.getLanguage()  :"+loginVo.getLanguage());
		String pShowModules = ObjUtils.getSafeString(ConfigUtil.getProperty("common.main.showAllModules"));
		if("false".equals(pShowModules))	{
			userModules = mainCommonService.getUserModules(loginVo);
			modules = tlabMenuService.getModules(loginVo.getCompCode());
		}else {
			modules = tlabMenuService.getModules(loginVo.getCompCode());
		}
		List<Map<String,String>> mods = new ArrayList<Map<String,String>>();
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("S_COMP_CODE", loginVo.getCompCode());
//		Object processMenu = mainMenuService.getProcessMenu(param);
		String firstModuleName ="";
		if(modules != null ) {
			for(int i = 0, len = modules.size(); i < len; i ++) {
				UniModuleModel module = modules.get(i) ;

				Map<String,String> rec = new HashMap<String,String>();
				rec.put("id", module.getId());
				rec.put("title", module.getCodeName(loginVo.getLanguage()));
				if("false".equals(pShowModules))	{
					for(UniModuleModel userModule : userModules)	{
						if(ObjUtils.getSafeString(module.getId()).equals(userModule.getId()) )	{
							rec.put("show", "true");
							break;
						}
					}
				}else {
					rec.put("show", "true");
				}

				mods.add(rec);
				if(i == 0 ) {
					firstModuleName = rec.get("title");
				}
			}
			logger.debug("#############################################	"+ modules.toString() + "####################################");
		}else {
			logger.debug("#############################################	 modules is null  ####################################");
		}
		if(mods != null && mods.size() > 0 ) {
			model.put("modulesStr", JsonUtils.toJsonStr(mods));
		} else {
			//model.put("modulesStr", "[{'id':'11','title':'DEMO'}]");
			model.put("modulesStr", "[]");
		}

		model.put("contextList", getContextListJson());
		model.put("contextName", Unilite.getCurrentContextName(request.getContextPath()));

		StringBuffer appOption = new StringBuffer();
		Map<String, Object> userUI = (Map<String, Object>)mainCommonService.getUserUI(loginVo);
		if(userUI == null || ObjUtils.isEmpty(userUI))	{
			appOption.append("{collapseMenuOnOpen: true, showPgmId: false, collapseLeftSearch: true}");
		}else {
			for (Map.Entry<String, Object> entry : userUI.entrySet())
			{
				if(entry.getKey().equals("downEnterKey"))	{
					userUI.put(entry.getKey(), ObjUtils.getSafeString(entry.getValue()));
				} else {
					userUI.put(entry.getKey(), Boolean.valueOf(ObjUtils.getSafeString(entry.getValue())));
				}
			}
			appOption = ObjUtils.toJsonStr(userUI);
		}
		model.put("appOption", appOption);

		//법인변경
		Map compParam = new HashMap();
		compParam.put("S_USER_ID", loginVo.getUserID());
		compParam.put("S_LANG_CODE", loginVo.getLanguage());

		List<Map<String, Object>> compList = mainCommonService.compList(compParam);
		model.put("compList", ObjUtils.toJsonStr(compList));

		logger.debug("Model {} ", model);
		logger.debug("####  LoginVO.getToken() {} ", loginVo.getToken());

		//비밀번호 대소문자 구분
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVo.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("B110", "40");	//대소문자 구분
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("caseSensYN",cdo.getRefCode1());
		}

		cdo = codeInfo.getCodeInfo("B906", "10");	//회사문구
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("companyTitle", ObjUtils.nvlObj(cdo.getCodeName(loginVo.getLanguage()),"시너지시스템즈는 대한민국 기업IT화에 앞장서는 ERP Solution 전문업체입니다."));
		} else {
			model.addAttribute("companyTitle", "시너지시스템즈는 대한민국 기업IT화에 앞장서는 ERP Solution 전문업체입니다.");
		}

		logger.debug("Model {} ", model);

		return JSP_PATH + "main_kodi";
	}

	/**
	 * 에이치설퍼 메인 페이지
	 * @param loginVo
	 * @param model
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/main_hs.do", method = RequestMethod.GET)
	public String index_hs(LoginVO loginVo, ModelMap model, HttpServletRequest request) throws Exception {
		List<UniModuleModel> modules = new ArrayList() ;
		List<UniModuleModel> userModules = new ArrayList() ;
		// 모듈 아이콘 표시 속성
		logger.debug(">>>>>>>>>>>>>> loginVo.getLanguage()  :"+loginVo.getLanguage());
		String pShowModules = ObjUtils.getSafeString(ConfigUtil.getProperty("common.main.showAllModules"));
		if("false".equals(pShowModules))	{
			userModules = mainCommonService.getUserModules(loginVo);
			modules = tlabMenuService.getModules(loginVo.getCompCode());
		}else {
			modules = tlabMenuService.getModules(loginVo.getCompCode());
		}
		List<Map<String,String>> mods = new ArrayList<Map<String,String>>();
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("S_COMP_CODE", loginVo.getCompCode());
//		Object processMenu = mainMenuService.getProcessMenu(param);
		String firstModuleName ="";
		if(modules != null ) {
			for(int i = 0, len = modules.size(); i < len; i ++) {
				UniModuleModel module = modules.get(i) ;

				Map<String,String> rec = new HashMap<String,String>();
				rec.put("id", module.getId());
				rec.put("title", module.getCodeName(loginVo.getLanguage()));
				if("false".equals(pShowModules))	{
					for(UniModuleModel userModule : userModules)	{
						if(ObjUtils.getSafeString(module.getId()).equals(userModule.getId()) )	{
							rec.put("show", "true");
							break;
						}
					}
				}else {
					rec.put("show", "true");
				}

				mods.add(rec);
				if(i == 0 ) {
					firstModuleName = rec.get("title");
				}
			}
			logger.debug("#############################################	"+ modules.toString() + "####################################");
		}else {
			logger.debug("#############################################	 modules is null  ####################################");
		}
		if(mods != null && mods.size() > 0 ) {
			model.put("modulesStr", JsonUtils.toJsonStr(mods));
		} else {
			//model.put("modulesStr", "[{'id':'11','title':'DEMO'}]");
			model.put("modulesStr", "[]");
		}

		model.put("contextList", getContextListJson());
		model.put("contextName", Unilite.getCurrentContextName(request.getContextPath()));

		StringBuffer appOption = new StringBuffer();
		Map<String, Object> userUI = (Map<String, Object>)mainCommonService.getUserUI(loginVo);
		if(userUI == null || ObjUtils.isEmpty(userUI))	{
			appOption.append("{collapseMenuOnOpen: true, showPgmId: false, collapseLeftSearch: true}");
		}else {
			for (Map.Entry<String, Object> entry : userUI.entrySet())
			{
				if(entry.getKey().equals("downEnterKey"))	{
					userUI.put(entry.getKey(), ObjUtils.getSafeString(entry.getValue()));
				} else {
					userUI.put(entry.getKey(), Boolean.valueOf(ObjUtils.getSafeString(entry.getValue())));
				}
			}
			appOption = ObjUtils.toJsonStr(userUI);
		}
		model.put("appOption", appOption);

		//법인변경
		Map compParam = new HashMap();
		compParam.put("S_USER_ID", loginVo.getUserID());
		compParam.put("S_LANG_CODE", loginVo.getLanguage());

		List<Map<String, Object>> compList = mainCommonService.compList(compParam);
		model.put("compList", ObjUtils.toJsonStr(compList));

		logger.debug("Model {} ", model);
		logger.debug("####  LoginVO.getToken() {} ", loginVo.getToken());

		//비밀번호 대소문자 구분
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVo.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("B110", "40");	//대소문자 구분
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("caseSensYN",cdo.getRefCode1());
		}

		cdo = codeInfo.getCodeInfo("B906", "10");	//회사문구
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("companyTitle", ObjUtils.nvlObj(cdo.getCodeName(loginVo.getLanguage()),"시너지시스템즈는 대한민국 기업IT화에 앞장서는 ERP Solution 전문업체입니다."));
		} else {
			model.addAttribute("companyTitle", "시너지시스템즈는 대한민국 기업IT화에 앞장서는 ERP Solution 전문업체입니다.");
		}

		logger.debug("Model {} ", model);

		return JSP_PATH + "main_hs";
	}

	/**
	 * <pre>
	 * cov_vmi
	 * </pre>
	 *
	 * @param loginVo
	 * @param model
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/main_cov_vmi.do", method = RequestMethod.GET)
	public String main_cove_vmi(LoginVO loginVo, ModelMap model, HttpServletRequest request) throws Exception {

		model.put("contextList", getContextListJson());
		model.put("contextName", Unilite.getCurrentContextName(request.getContextPath()));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVo.getCompCode());
		CodeDetailVO cdo = null;
		cdo = codeInfo.getCodeInfo("B906", "10");	//회사문구
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("companyTitle", ObjUtils.nvlObj(cdo.getCodeName(loginVo.getLanguage()),"시너지시스템즈는 대한민국 기업IT화에 앞장서는 ERP Solution 전문업체입니다."));
		} else {
			model.addAttribute("companyTitle", "시너지시스템즈는 대한민국 기업IT화에 앞장서는 ERP Solution 전문업체입니다.");
		}

		logger.debug("Model {} ", model);
		return JSP_PATH + "main_cov_vmi";
	}


	/**
	 * 월드와이드메모리 메인페이지 추가(현황판 설정 위해) - 20201109 추가
	 * @param loginVo
	 * @param model
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/main_wm.do", method = RequestMethod.GET)
	public String index_wm(LoginVO loginVo, ModelMap model, HttpServletRequest request) throws Exception {
		List<UniModuleModel> modules = new ArrayList() ;
		List<UniModuleModel> userModules = new ArrayList() ;
		// 모듈 아이콘 표시 속성
		logger.debug(">>>>>>>>>>>>>> loginVo.getLanguage()  :"+loginVo.getLanguage());
		String pShowModules = ObjUtils.getSafeString(ConfigUtil.getProperty("common.main.showAllModules"));
		if("false".equals(pShowModules))	{
			userModules = mainCommonService.getUserModules(loginVo);
			modules = tlabMenuService.getModules(loginVo.getCompCode());
		}else {
			modules = tlabMenuService.getModules(loginVo.getCompCode());
		}
		List<Map<String,String>> mods = new ArrayList<Map<String,String>>();
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("S_COMP_CODE", loginVo.getCompCode());
//		Object processMenu = mainMenuService.getProcessMenu(param);
		String firstModuleName ="";
		if(modules != null ) {
			for(int i = 0, len = modules.size(); i < len; i ++) {
				UniModuleModel module = modules.get(i) ;

				Map<String,String> rec = new HashMap<String,String>();
				rec.put("id", module.getId());
				rec.put("title", module.getCodeName(loginVo.getLanguage()));
				if("false".equals(pShowModules))	{
					for(UniModuleModel userModule : userModules)	{
						if(ObjUtils.getSafeString(module.getId()).equals(userModule.getId()) )	{
							rec.put("show", "true");
							break;
						}
					}
				}else {
					rec.put("show", "true");
				}

				mods.add(rec);
				if(i == 0 ) {
					firstModuleName = rec.get("title");
				}
			}
			logger.debug("#############################################	"+ modules.toString() + "####################################");
		}else {
			logger.debug("#############################################	 modules is null  ####################################");
		}
		if(mods != null && mods.size() > 0 ) {
			model.put("modulesStr", JsonUtils.toJsonStr(mods));
		} else {
			//model.put("modulesStr", "[{'id':'11','title':'DEMO'}]");
			model.put("modulesStr", "[]");
		}

		model.put("contextList", getContextListJson());
		model.put("contextName", Unilite.getCurrentContextName(request.getContextPath()));

		StringBuffer appOption = new StringBuffer();
		Map<String, Object> userUI = (Map<String, Object>)mainCommonService.getUserUI(loginVo);
		if(userUI == null || ObjUtils.isEmpty(userUI))	{
			appOption.append("{collapseMenuOnOpen: true, showPgmId: false, collapseLeftSearch: true}");
		}else {
			for (Map.Entry<String, Object> entry : userUI.entrySet())
			{
				if(entry.getKey().equals("downEnterKey"))	{
					userUI.put(entry.getKey(), ObjUtils.getSafeString(entry.getValue()));
				} else {
					userUI.put(entry.getKey(), Boolean.valueOf(ObjUtils.getSafeString(entry.getValue())));
				}
			}
			appOption = ObjUtils.toJsonStr(userUI);
		}
		model.put("appOption", appOption);

		//법인변경
		Map compParam = new HashMap();
		compParam.put("S_USER_ID", loginVo.getUserID());
		compParam.put("S_LANG_CODE", loginVo.getLanguage());

		List<Map<String, Object>> compList = mainCommonService.compList(compParam);
		model.put("compList", ObjUtils.toJsonStr(compList));

		logger.debug("Model {} ", model);
		logger.debug("####  LoginVO.getToken() {} ", loginVo.getToken());

		//비밀번호 대소문자 구분
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVo.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("B110", "40");	//대소문자 구분
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("caseSensYN",cdo.getRefCode1());
		}

		cdo = codeInfo.getCodeInfo("B906", "10");	//회사문구
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("companyTitle", ObjUtils.nvlObj(cdo.getCodeName(loginVo.getLanguage()),"시너지시스템즈는 대한민국 기업IT화에 앞장서는 ERP Solution 전문업체입니다."));
		} else {
			model.addAttribute("companyTitle", "시너지시스템즈는 대한민국 기업IT화에 앞장서는 ERP Solution 전문업체입니다.");
		}

		logger.debug("Model {} ", model);

		return JSP_PATH + "main_wm";
	}

	/**
	 * <pre>
	 * wm vmi
	 * </pre>
	 *
	 * @param loginVo
	 * @param model
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/main_wm_vmi.do", method = RequestMethod.GET)
	public String main_wm_vmi(LoginVO loginVo, ModelMap model, HttpServletRequest request) throws Exception {


		model.put("contextList", getContextListJson());
		model.put("contextName", Unilite.getCurrentContextName(request.getContextPath()));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVo.getCompCode());
		CodeDetailVO cdo = null;
		cdo = codeInfo.getCodeInfo("B906", "10");	//회사문구
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("companyTitle", ObjUtils.nvlObj(cdo.getCodeName(loginVo.getLanguage()),"시너지시스템즈는 대한민국 기업IT화에 앞장서는 ERP Solution 전문업체입니다."));
		} else {
			model.addAttribute("companyTitle", "시너지시스템즈는 대한민국 기업IT화에 앞장서는 ERP Solution 전문업체입니다.");
		}

		logger.debug("Model {} ", model);
		return JSP_PATH + "main_wm_vmi";
	}


	/**
	 * kodi 메인 페이지
	 * @param loginVo
	 * @param model
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/main_dsinfo.do", method = RequestMethod.GET)
	public String index_dsinfo(LoginVO loginVo, ModelMap model, HttpServletRequest request) throws Exception {
		List<UniModuleModel> modules = new ArrayList() ;
		List<UniModuleModel> userModules = new ArrayList() ;
		// 모듈 아이콘 표시 속성
		logger.debug(">>>>>>>>>>>>>> loginVo.getLanguage()  :"+loginVo.getLanguage());
		String pShowModules = ObjUtils.getSafeString(ConfigUtil.getProperty("common.main.showAllModules"));
		if("false".equals(pShowModules))	{
			userModules = mainCommonService.getUserModules(loginVo);
			modules = tlabMenuService.getModules(loginVo.getCompCode());
		}else {
			modules = tlabMenuService.getModules(loginVo.getCompCode());
		}
		List<Map<String,String>> mods = new ArrayList<Map<String,String>>();
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("S_COMP_CODE", loginVo.getCompCode());
//		Object processMenu = mainMenuService.getProcessMenu(param);
		String firstModuleName ="";
		if(modules != null ) {
			for(int i = 0, len = modules.size(); i < len; i ++) {
				UniModuleModel module = modules.get(i) ;

				Map<String,String> rec = new HashMap<String,String>();
				rec.put("id", module.getId());
				rec.put("title", module.getCodeName(loginVo.getLanguage()));
				if("false".equals(pShowModules))	{
					for(UniModuleModel userModule : userModules)	{
						if(ObjUtils.getSafeString(module.getId()).equals(userModule.getId()) )	{
							rec.put("show", "true");
							break;
						}
					}
				}else {
					rec.put("show", "true");
				}

				mods.add(rec);
				if(i == 0 ) {
					firstModuleName = rec.get("title");
				}
			}
			logger.debug("#############################################	"+ modules.toString() + "####################################");
		}else {
			logger.debug("#############################################	 modules is null  ####################################");
		}
		if(mods != null && mods.size() > 0 ) {
			model.put("modulesStr", JsonUtils.toJsonStr(mods));
		} else {
			//model.put("modulesStr", "[{'id':'11','title':'DEMO'}]");
			model.put("modulesStr", "[]");
		}

		model.put("contextList", getContextListJson());
		model.put("contextName", Unilite.getCurrentContextName(request.getContextPath()));

		StringBuffer appOption = new StringBuffer();
		Map<String, Object> userUI = (Map<String, Object>)mainCommonService.getUserUI(loginVo);
		if(userUI == null || ObjUtils.isEmpty(userUI))	{
			appOption.append("{collapseMenuOnOpen: true, showPgmId: false, collapseLeftSearch: true}");
		}else {
			for (Map.Entry<String, Object> entry : userUI.entrySet())
			{
				if(entry.getKey().equals("downEnterKey"))	{
					userUI.put(entry.getKey(), ObjUtils.getSafeString(entry.getValue()));
				} else {
					userUI.put(entry.getKey(), Boolean.valueOf(ObjUtils.getSafeString(entry.getValue())));
				}
			}
			appOption = ObjUtils.toJsonStr(userUI);
		}
		model.put("appOption", appOption);

		//법인변경
		Map compParam = new HashMap();
		compParam.put("S_USER_ID", loginVo.getUserID());
		compParam.put("S_LANG_CODE", loginVo.getLanguage());

		List<Map<String, Object>> compList = mainCommonService.compList(compParam);
		model.put("compList", ObjUtils.toJsonStr(compList));

		logger.debug("Model {} ", model);
		logger.debug("####  LoginVO.getToken() {} ", loginVo.getToken());

		//비밀번호 대소문자 구분
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVo.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("B110", "40");	//대소문자 구분
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("caseSensYN",cdo.getRefCode1());
		}

		cdo = codeInfo.getCodeInfo("B906", "10");	//회사문구
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("companyTitle", ObjUtils.nvlObj(cdo.getCodeName(loginVo.getLanguage()),"시너지시스템즈는 대한민국 기업IT화에 앞장서는 ERP Solution 전문업체입니다."));
		} else {
			model.addAttribute("companyTitle", "시너지시스템즈는 대한민국 기업IT화에 앞장서는 ERP Solution 전문업체입니다.");
		}

		logger.debug("Model {} ", model);
		logger.debug("getUserID {} "+  loginVo.getUserID());
		logger.debug("getRoleList {} "+  loginVo.getRoleList());



		Map groupParam = new HashMap();
		groupParam.put("S_USER_ID", loginVo.getUserID());
		groupParam.put("S_COMP_CODE", loginVo.getCompCode());

		//Map userM = mainCommonService.getGroupDetailList(groupParam);
		List<Map<String, Object>> userM = mainCommonService.getGroupDetailList(groupParam);
		//model.put("userM", ObjUtils.toJsonStr(userM));
		//userM = mainCommonService.getGroupDetailList(groupParam);
		//CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVo.getCompCode());

		//String jsonStr = userM.toJSONString();
		String name = userM.get(0).get("GROUP_CODE").toString();

		logger.debug("11111111111:"+ name);

		if(name.equals("11") )	{
			logger.debug("1222222222:"+ name);
			return JSP_PATH + "main_dsinfo";
		}else {
			logger.debug("33333333333:"+ name);
			return JSP_PATH + "main_kodi";
		}


		//return JSP_PATH + "main_dsinfo";
	}
}