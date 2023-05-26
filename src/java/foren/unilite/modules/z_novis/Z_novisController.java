package foren.unilite.modules.z_novis;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import foren.framework.lib.listop.ListOp;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.model.NavigatorInfo;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.modules.com.combo.ComboServiceImpl;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.com.code.CodeDetailVO;

@Controller
public class Z_novisController extends UniliteCommonController {
	final static String		JSP_PATH	= "/z_novis/";
	private final Logger	logger		= LoggerFactory.getLogger(this.getClass());

	@Resource(name="UniliteComboServiceImpl")
	private ComboServiceImpl comboService;

	@Resource(name="s_mes100skrv_novisService")
	private S_mes100skrv_novisServiceImpl s_mes100skrv_novisService;
	
	/**
	 * 원가계산수불부등록(엑셀업로드)
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_novis/s_cdr400ukrv_novis.do")
	public String s_cdr400ukrv_novis(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE", loginVO.getCompCode());
		return JSP_PATH + "s_cdr400ukrv_novis";
	}
	

	@RequestMapping(value = "/z_novis/s_cdr400skrv_novis.do")
	public String s_cdr400skrv_novis(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());	

		return JSP_PATH + "s_cdr400skrv_novis";
	}	
	
	/**
	 * 제품정보등록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_novis/s_bpr110ukrv_novis.do")
	public String s_bpr110ukrv_novis(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		
		param.put("S_COMP_CODE", loginVO.getCompCode());
		return JSP_PATH + "s_bpr110ukrv_novis";
	}

	/**
	 * 생산계획일정
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_novis/s_ppl102ukrv_novis.do")
	public String s_ppl102ukrv_novis(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE", loginVO.getCompCode());
		return JSP_PATH + "s_ppl102ukrv_novis";
	}


	/**
	 * 수주관리대장(노비스) (s_sof101skrv_novis)
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_novis/s_sof101ukrv_novis.do")
	public String s_sof101ukrv_novis(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));

		param.put("S_COMP_CODE", loginVO.getCompCode());
		return JSP_PATH + "s_sof101ukrv_novis";
	}
	
	@RequestMapping(value = "/z_novis/s_mes100skrv_novis")
	public String s_mes100skrv_novis(ExtHtttprequestParam _req, ModelMap model) throws Exception {
		List<Map> pageList = s_mes100skrv_novisService.selectPagenation(null);
		List<Map> cboList = s_mes100skrv_novisService.selectCboItemInfo(null);
		model.addAttribute("navi",pageList.get(0));
		model.addAttribute("cboItem",cboList);
		return JSP_PATH + "s_mes100skrv_novis";
	}
	
	@RequestMapping(value = "/z_novis/s_mes100skrv_novisSelectList")
	@ResponseBody
	public List<Map> s_mes100skrv_novisSelectList(ExtHtttprequestParam _req) throws Exception {
		List<Map> list = s_mes100skrv_novisService.selectList();
		
		return list;
	}
	
	@RequestMapping(value = "/z_novis/s_mes100skrv_novisQtyList")
	@ResponseBody
	public List<Map> s_mes100skrv_novisQtyList(ExtHtttprequestParam _req) throws Exception {
		List<Map> list = s_mes100skrv_novisService.qtyList();
		
		return list;
	}
	
	@RequestMapping(value = "/z_novis/s_mes100skrv_novisSelectProductionCnt")
	@ResponseBody
	public List<Map> s_mes100skrv_novisSelectProductionCnt(ExtHtttprequestParam _req) throws Exception {
		List<Map> list = s_mes100skrv_novisService.selectProductionCnt();
		
		return list;
	}
	
	@RequestMapping(value = "/z_novis/s_mes100skrv_novisSelectProductionCnt2")
	@ResponseBody
	public List<Map> s_mes100skrv_novisSelectProductionCnt2(ExtHtttprequestParam _req) throws Exception {
		Map param = _req.getParameterMap();
		List<Map> list = s_mes100skrv_novisService.selectProductionCnt2(param);
		
		return list;
	}
	
	@RequestMapping(value = "/z_novis/s_mes100skrv_novisSelectPageData")
	@ResponseBody
	public List<Map> s_mes100skrv_novisSelectPageData(ExtHtttprequestParam _req) throws Exception {
		Map param = _req.getParameterMap();
		List<Map> list = s_mes100skrv_novisService.selectPageData(param);
		
		return list;
	}

	@RequestMapping(value = "/z_novis/s_mes100skrv_novisSelectPagenation")
	@ResponseBody
	public List<Map> s_mes100skrv_novisSelectPagenation(ExtHtttprequestParam _req) throws Exception {
		Map param = _req.getParameterMap();
		List<Map> list = s_mes100skrv_novisService.selectPagenation(param);
		
		return list;
	}
	
	@RequestMapping(value = "/z_novis/s_mes100skrv_novisMergeItem")
	@ResponseBody
	public int s_mes100skrv_novisMergeItem(ExtHtttprequestParam _req) throws Exception {
		Map param = _req.getParameterMap();
		int iCnt = s_mes100skrv_novisService.mergeItem(param);
		
		return iCnt;
	}
	
	
	
	
	@RequestMapping(value = "/z_novis/s_sof130rkrv_novis.do")
	public String s_sof130rkrv_novis(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		List<CodeDetailVO> gsLabelCustom = codeInfo.getCodeList("S105", "", false);		//라벨거래처
		for(CodeDetailVO map : gsLabelCustom)	{
			if("Y".equals(map.getRefCode2()))	{
				model.addAttribute("gsLabelCustomCode", map.getRefCode1());
				model.addAttribute("gsLabelCustomName", map.getCodeName());
			}
		}

		return JSP_PATH + "s_sof130rkrv_novis";
	}
	
	
	/**
	 * 검사라벨출력
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_novis/s_pmp270skrv_novis.do")
	public String pmp270skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));

		cdo = codeInfo.getCodeInfo("B259", "1");    //사이트 구분 운영코드
		 if(ObjUtils.isNotEmpty(cdo)){
			 if(ObjUtils.isNotEmpty(cdo.getCodeName())){
			 	model.addAttribute("gsSiteCode", cdo.getCodeName().toUpperCase());
			 }else{
			 	model.addAttribute("gsSiteCode", "STANDARD");
			 }
	     }else {
	            model.addAttribute("gsSiteCode", "STANDARD");
	     }

		return JSP_PATH + "s_pmp270skrv_novis";
	}
	
}
