package foren.unilite.modules.trade.tis;

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
import foren.framework.utils.ObjUtils;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.modules.com.combo.ComboServiceImpl;
import foren.unilite.modules.trade.tis.Tis100ukrvServiceImpl;

@Controller
public class TisContoroller extends UniliteCommonController {
	@Resource(name="UniliteComboServiceImpl")
	private ComboServiceImpl comboService;
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	final static String JSP_PATH = "/trade/tis/";

	@Resource(name="tis100ukrvService")
	private Tis100ukrvServiceImpl tis100ukrvService;

	@RequestMapping(value = "/trade/tis100ukrv.do")
	public String tis100ukrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());

		Map<String, Object> gsOwnCustInfo = tis100ukrvService.getOwnCustInfo(param); //자사 코드(수출자) 가져오기
		model.addAttribute("gsOwnCustInfo",ObjUtils.toJsonStr(gsOwnCustInfo));

		return JSP_PATH + "tis100ukrv";
	}

	@RequestMapping(value = "/trade/tis110skrv.do")
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

		return JSP_PATH + "tis110skrv";
	}

	/**
	 * 미착현황 (tis120skrv) - 20191219 신규 생성
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/trade/tis120skrv.do")
	public String mms220skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
	
		param.put("S_COMP_CODE",loginVO.getCompCode());
	//	CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
	
		return JSP_PATH + "tis120skrv";
	}
}