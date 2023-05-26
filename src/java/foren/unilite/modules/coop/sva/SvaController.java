package foren.unilite.modules.coop.sva;

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
public class SvaController extends UniliteCommonController {

	private final Logger	logger		= LoggerFactory.getLogger(this.getClass());

	final static String		JSP_PATH	= "/coop/sva/";
	
	@Resource(name="UniliteComboServiceImpl")
	private ComboServiceImpl comboService;
	
	@RequestMapping(value = "/coop/sva100ukrv.do",method = RequestMethod.GET)
	
	public String sva100ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_VENDING_MACHINE_NO", comboService.getMachineNo(param));
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
		return JSP_PATH + "sva100ukrv";
	}
	
	/* 자판기등록 */ 
	
	@RequestMapping(value = "/coop/sva110ukrv.do",method = RequestMethod.GET)
		
	public String sva110ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_VENDING_MACHINE_NO", comboService.getMachineNo(param));
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
		return JSP_PATH + "sva110ukrv";
	}
	@RequestMapping(value = "/coop/sva120ukrv.do",method = RequestMethod.GET)
	
	public String sva120ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_VENDING_NO", comboService.getVendingNo(param));
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
		return JSP_PATH + "sva120ukrv";
	}
	@RequestMapping(value = "/coop/sva200skrv.do",method = RequestMethod.GET)
	
	public String sva200skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_VENDING_MACHINE_NO", comboService.getMachineNo(param));
		
		return JSP_PATH + "sva200skrv";
	}
	@RequestMapping(value = "/coop/sva300ukrv.do",method = RequestMethod.GET)
	
	public String sva300ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_VENDING_NO", comboService.getVendingNo(param));
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
		return JSP_PATH + "sva300ukrv";
	}
	/*
	 *  일자별투입현황조회
	 */
	@RequestMapping(value = "/coop/sva210skrv.do")
	public String sva210skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");		
		
		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_VENDING_MACHINE_NO", comboService.getMachineNo(param));
		
		return JSP_PATH + "sva210skrv";
	}
	
	@RequestMapping(value = "/coop/sva220skrv.do")
	public String sva220skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");		
		
		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_VENDING_MACHINE_NO", comboService.getMachineNo(param));
		
		return JSP_PATH + "sva220skrv";
	}


}

	
	
	
