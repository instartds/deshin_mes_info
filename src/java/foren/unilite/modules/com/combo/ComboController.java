package foren.unilite.modules.com.combo;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import foren.framework.lib.listop.ListOp;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.model.NavigatorInfo;
import foren.framework.utils.GStringUtils;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.com.tags.ComboItemModel;
import foren.unilite.com.tags.ComboService;

@Controller
public class ComboController extends UniliteCommonController {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
    @Resource(name = "UniliteComboServiceImpl")
    private ComboService comboService;
    
	@Resource(name= "UniliteComboServiceImpl")
	private ComboServiceImpl ComboServiceImpl;
	
	@RequestMapping(value="/com/getComboList.do",method = RequestMethod.GET)
	public ModelAndView getComboList(String comboType, String comboCode, String includeMainCode, LoginVO loginVO) throws Exception {
		List<ComboItemModel> rv = null;
		
		Map<String, Object> param = new HashMap<String, Object>();

		param.put("S_COMP_CODE", loginVO.getCompCode());
		
		Boolean bIncludeMainCode = false;
		if("true".equals(includeMainCode) || "True".equals(includeMainCode) || "TRUE".equals(includeMainCode))	{
			bIncludeMainCode = true;
		}
		rv = comboService.getComboList(comboType, comboCode, loginVO, param, null, bIncludeMainCode);
		
		
		// logger.debug("comboList is {}", rv);
        return ViewHelper.getJsonView(rv);
		
	}
	
	@RequestMapping(value="/com/getStateList.do",method = RequestMethod.GET)
	public ModelAndView getStateList(String comboType, String pgmId, String shtId, LoginVO loginVO) throws Exception {
		List<ComboItemModel> rv = null;

		Map<String, Object> param = new HashMap<String, Object>();
		param.put("COMP_CODE", loginVO.getCompCode());
		param.put("USER_ID", loginVO.getUserID());
		param.put("PGM_ID", pgmId);
		param.put("SHT_ID", shtId);
		
		rv = comboService.getComboList(comboType, "", loginVO, param, null, false);
		
		
		// logger.debug("comboList is {}", rv);
        return ViewHelper.getJsonView(rv);
		
	}

	@RequestMapping(value = "/base/bsa/combo_example.do")
	public String comboExample(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		model.addAttribute("WH_LIST", ComboServiceImpl.getWhList(param));
		model.addAttribute("WHU_LIST", ComboServiceImpl.getWhUList(param));
		model.addAttribute("WS_LIST", ComboServiceImpl.getWsList(param));
		model.addAttribute("WP_LIST", ComboServiceImpl.getProgWork(param));
		model.addAttribute("WSU_LIST", ComboServiceImpl.getWsUList(param));
		return "/base/bsa/combo_example";
	}

}
