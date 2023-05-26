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
public class BadgeController extends UniliteCommonController {
	
	@InjectLogger
	public static   Logger	logger	;//	= LoggerFactory.getLogger(this.getClass());

	final static String		JSP_PATH	= "/com/main/";
	
	/**
	 * 일반 메인 페이지 
	 * @param loginVo
	 * @param model
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/badge.do", method = RequestMethod.GET)
	public String badgeCount(LoginVO loginVo, ModelMap model, HttpServletRequest request) throws Exception {
		
		//비밀번호 대소문자 구분
		/*CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVo.getCompCode());
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
		*/
		logger.debug("Model {} ", model);
		
		return JSP_PATH + "main";
	}	
	
	
}
