package foren.unilite.modules.pos.pos;

import java.io.File;
import java.util.HashMap;
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
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.modules.com.combo.ComboServiceImpl;
import foren.unilite.modules.sales.sco.Sco300skrvServiceImpl;

@Controller
public class PosContoroller extends UniliteCommonController {

	private final Logger	logger		= LoggerFactory.getLogger(this.getClass());

	final static String		JSP_PATH	= "/pos/pos/";
	
	@Resource(name="UniliteComboServiceImpl")
	private ComboServiceImpl comboService;
	
	@Resource(name = "pos101skrvService")
	private Pos101skrvServiceImpl pos101skrvService;
	
	
	/* pos별 시간대별 상품별 판매현황*/
	@RequestMapping(value = "/pos/pos100skrv.do")
	public String pos100skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");		
		
		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_POS_NO", comboService.getPosNo(param));
		
		
		return JSP_PATH + "pos100skrv";
	}
	
	/* pos별 시간대별 상품별 판매현황 (상세)*/
	@RequestMapping(value = "/pos/pos101skrv.do")
	public String pos101skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");	
		
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		
		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_POS_NO", comboService.getPosNo(param));
		
		
		return JSP_PATH + "pos101skrv";
	}
		
	@RequestMapping(value = "/pos/pos110skrv.do")
	public String pos110skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_POS_NO", comboService.getPosNo(param));
		
		
		return JSP_PATH + "pos110skrv";
	}	
	
	/*Pos별 입금형태별 매출현황*/
	@RequestMapping(value = "/pos/pos120skrv.do")
	public String pos120skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_POS_NO", comboService.getPosNo(param));
		
		return JSP_PATH + "pos120skrv";
	}	
	
	/* 상품별매출현황 */
	@RequestMapping(value = "/pos/pos130skrv.do")
	public String pos130skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));  
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));   
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param)); 
		model.addAttribute("COMBO_POS_NO", comboService.getPosNo(param));
		
		return JSP_PATH + "pos130skrv";
	}	
	/* 상품별  POS 매출현황 */
	@RequestMapping(value = "/pos/pos140skrv.do")
	public String pos140skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");		
		
		param.put("S_COMP_CODE",loginVO.getCompCode());
		
		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));  
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));   
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param)); 
		model.addAttribute("COMBO_POS_NO", comboService.getPosNo(param));
		
		
		return JSP_PATH + "pos140skrv";
	}
	
	
	/*Pos별 신용카드사 집계표*/
	@RequestMapping(value = "/pos/pos200skrv.do")
	public String pos200skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_POS_NO", comboService.getPosNo(param));
		
		return JSP_PATH + "pos200skrv";
	}	
	
	/*신용카드사별 승인내역*/
	@RequestMapping(value = "/pos/pos210skrv.do")
	public String pos210skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		model.addAttribute("COMBO_POS_NO", comboService.getPosNo(param));
		
		return JSP_PATH + "pos210skrv";
	}	
	
	/*신용카드매출대사*/
	@RequestMapping(value = "/pos/pos220skrv.do")
	public String pos220skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		model.addAttribute("COMBO_POS_NO", comboService.getPosNo(param));
		
		return JSP_PATH + "pos220skrv";
	}	
	
	/*Pos별 정산내역*/
	@RequestMapping(value = "/pos/pos300skrv.do")
	public String pos300skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		model.addAttribute("COMBO_POS_NO", comboService.getPosNo(param));
		
		return JSP_PATH + "pos300skrv";
	}	
	
	/* POS 등록 */
	@RequestMapping(value = "/pos/bsa240ukrv.do")
	public String bsa240ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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
		
		return JSP_PATH + "bsa240ukrv";
	}
	
	/* 프리셋 등록 */ 
	@RequestMapping(value = "/pos/bsa260ukrv.do")
	public String bsa260ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		
		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));  
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));   
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param)); 
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
		
		return JSP_PATH + "bsa260ukrv";
	}
	
	@RequestMapping(value="/pos/pos101skrvSign.do")
    public ModelAndView signViewer(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		Map param = new HashMap();
		param.put("DIV_CODE", _req.getP("DIV_CODE"));
        param.put("COLLECT_NUM", _req.getP("COLLECT_NUM"));
        param.put("COLLECT_SEQ", _req.getP("COLLECT_SEQ"));
        
        File sign = pos101skrvService.getSign(param, loginVO);
        
        return ViewHelper.getImageView(sign);
    }
	
}
