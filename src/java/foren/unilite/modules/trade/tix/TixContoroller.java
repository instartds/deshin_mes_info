package foren.unilite.modules.trade.tix;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import foren.framework.lib.listop.ListOp;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.model.NavigatorInfo;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.modules.com.combo.ComboServiceImpl;

@Controller
public class TixContoroller extends UniliteCommonController {
	@Resource(name="UniliteComboServiceImpl")
	private ComboServiceImpl comboService;

	private final Logger	logger		= LoggerFactory.getLogger(this.getClass());

	final static String		JSP_PATH	= "/trade/tix/";

	@RequestMapping(value = "/trade/tix110skrv.do")
	public String tio110skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
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

		return JSP_PATH + "tix110skrv";
	}

	@RequestMapping(value = "/trade/tix100ukrv.do")
	public String tix100ukrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
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

		 List<CodeDetailVO> gsTradeCalcMethod = codeInfo.getCodeList("T125", "", false);//수입환산금액 원미만계산
	        for(CodeDetailVO map : gsTradeCalcMethod) {
	            if("Y".equals(map.getRefCode1()))   {
	                model.addAttribute("gsTradeCalcMethod", map.getCodeNo());
	            }
	        }

		return JSP_PATH + "tix100ukrv";
	}

	@RequestMapping(value = "/trade/tix101ukrv.do")
	public String tix101ukrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE",loginVO.getCompCode());

//		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
//		CodeDetailVO cdo = null;
//
//		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
//		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
//		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
//
//		 List<CodeDetailVO> gsTradeCalcMethod = codeInfo.getCodeList("T125", "", false);//수입환산금액 원미만계산
//	        for(CodeDetailVO map : gsTradeCalcMethod) {
//	            if("Y".equals(map.getRefCode1()))   {
//	                model.addAttribute("gsTradeCalcMethod", map.getCodeNo());
//	            }
//	        }

		return JSP_PATH + "tix101ukrv";
	}

	@RequestMapping(value = "/trade/tix200ukrv.do")
    public String tix200ukrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;


        return JSP_PATH + "tix200ukrv";
    }

}
