package foren.unilite.modules.matrl.mba;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import foren.framework.lib.listop.ListOp;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.model.NavigatorInfo;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.modules.com.combo.ComboServiceImpl;

@Controller
public class MbaController extends UniliteCommonController {

	@Resource(name="UniliteComboServiceImpl")
	private ComboServiceImpl comboService;

	private final Logger	logger		= LoggerFactory.getLogger(this.getClass());

	final static String		JSP_PATH	= "/matrl/mba/";
	
	
	@RequestMapping(value = "/matrl/testpage1.do")
	public String testpage1(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
		
		model.addAttribute("COMBO_COLLECT_DAY", comboService.getCollectDay(param));
		
		model.addAttribute("PRGID", param.get("prgID")); 
		model.addAttribute("PRGNAME", param.get("prgName"));

		
		return JSP_PATH + "testpage1";
	}	
	
	
	
	@RequestMapping(value = "/matrl/mba010ukrv.do")
	public String mba010ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));  
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));   
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param)); 
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
		
		return JSP_PATH + "mba010ukrv";
	}
	
	
	
	@RequestMapping(value = "/matrl/mba020ukrv.do")
	public String mba020ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));  
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));   
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param)); 
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
		
		return JSP_PATH + "mba020ukrv";
	}
	
	
	
	@RequestMapping(value = "/matrl/mba030ukrv.do")
	public String mba030ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));  
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));   
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param)); 
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
		
		return JSP_PATH + "mba030ukrv";
	}
	
	
	
	/**
	 * 거래처별 구매단가 등록 (mba031ukrv)
	 */
	@RequestMapping(value = "/matrl/mba031ukrv.do",method = RequestMethod.GET)
	public String mba031ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE",loginVO.getCompCode());
	
		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));  
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));   
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		
		List<CodeDetailVO> gsDefaultMoney = codeInfo.getCodeList("B004", "", false);		//기본 화폐단위
		for(CodeDetailVO map : gsDefaultMoney)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsDefaultMoney", map.getCodeNo());
			}
		}
		return JSP_PATH + "mba031ukrv";
	}
	
	
	
	@RequestMapping(value = "/matrl/mba032ukrv.do")
	public String mba032ukrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
								
		return JSP_PATH + "mba032ukrv";
	}
	
	
	
	/**
	 * 구매단가 등록 (mba033ukrv)
	 */
	@RequestMapping(value = "/matrl/mba033ukrv.do")
	public String mba033ukrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;		
		
		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		
		List<CodeDetailVO> gsMoneyUnit = codeInfo.getCodeList("B004", "", false);
		for(CodeDetailVO map : gsMoneyUnit) {
			if("Y".equals(map.getRefCode1()))   {
				model.addAttribute("gsMoneyUnit", map.getCodeNo());
			}
		}
		
		return JSP_PATH + "mba033ukrv";
	}
}

	
	
	
