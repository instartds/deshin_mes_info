package foren.unilite.modules.com.potal;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

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
public class MainControllerForGroupware extends UniliteCommonController {
	
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

	/**
	 * 일반 메인 페이지 
	 * @param loginVo
	 * @param model
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/main_groupware.do", method = RequestMethod.GET)
	public String index(LoginVO loginVo, ModelMap model, HttpServletRequest request) throws Exception {
		
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
			logger.debug("#############################################    "+ modules.toString() + "####################################");
		}else {
			logger.debug("#############################################     modules is null  ####################################");
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
		
		return JSP_PATH + "main_groupware";
	}	
	
	@RequestMapping(value = "/main_groupwarelgsaas.do", method = RequestMethod.GET)
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
			logger.debug("#############################################    "+ modules.toString() + "####################################");
		}else {
			logger.debug("#############################################     modules is null  ####################################");
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
		return JSP_PATH + "main_groupware_lgsaas";
	}	
	
	private StringBuffer getContextListJson() {
		
       return JsonUtils.toJsonStr(Unilite.getContextList());
	}

}
