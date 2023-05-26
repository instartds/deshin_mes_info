package foren.unilite.modules.human.ham;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.google.gson.Gson;

import foren.framework.lib.listop.ListOp;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.model.NavigatorInfo;
import foren.framework.utils.ObjUtils;
import foren.framework.web.view.FileDownloadInfo;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.modules.com.combo.ComboServiceImpl;
import foren.unilite.modules.human.hpa.Hpa994ukrServiceImpl;

@Controller
public class HamController extends UniliteCommonController {

	private final Logger	logger		= LoggerFactory.getLogger(this.getClass());

	final static String		JSP_PATH	= "/human/ham/";
	
	@Resource(name="UniliteComboServiceImpl")
	private ComboServiceImpl comboService;
	
	@Resource(name="ham600skrService")
	private Ham600skrServiceImpl ham600skrService;
	
	@Resource(name="ham800ukrService")
	private Ham800ukrServiceImpl ham800ukrService;
	
	@Resource(name="ham810ukrService")
	private Ham810ukrServiceImpl ham810ukrService;
	
	@Resource(name="ham800skrService")
	private Ham800skrServiceImpl ham800skrService;
	
	@Resource(name="ham920ukrService")
	private Ham920ukrServiceImpl ham920ukrService;
	
	@Resource(name="ham930ukrService")
	private Ham930ukrServiceImpl ham930ukrService;
	
	@Resource(name="hpa994ukrService")
	private Hpa994ukrServiceImpl hpa994ukrService;
	
	
	@RequestMapping(value = "/human/ham101ukr.do")
	public String ham101ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");		
		
		//자동채번 사용 여부 확인
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;
        cdo = codeInfo.getCodeInfo("H175", "41");
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsAutoCode",cdo.getRefCode1());  
			
		param.put("S_COMP_CODE",loginVO.getCompCode());

		return JSP_PATH + "ham101ukr";
	}
	
	
	@RequestMapping(value = "/human/ham200skr.do")
	public String ham200skr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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
		
		
		Map map = new HashMap();
        model.addAttribute("COMBO_DEPTS2", comboService.fnGetauthDepts(loginVO,map));//기관 콤보
		
		
		return JSP_PATH + "ham200skr";
	}
	
	@RequestMapping(value = "/human/ham210skr.do")
	public String ham210skr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
				
		return JSP_PATH + "ham210skr";
	}

	
	@RequestMapping(value = "/human/ham400skr.do")
	public String ham400skr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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
		
		return JSP_PATH + "ham400skr";
	}
	
		
	
	@RequestMapping(value = "/human/ham600skr.do")
	public String ham600skr(LoginVO loginVO, ModelMap model) throws Exception {
		Gson gson = new Gson();
		String colData = gson.toJson(ham600skrService.selectColumns(loginVO.getCompCode()));
		model.addAttribute("colData", colData);
		
		
		Map map = new HashMap();
        model.addAttribute("COMBO_DEPTS2", comboService.fnGetauthDepts(loginVO,map));//기관 콤보
		
		
		return JSP_PATH + "ham600skr";
	}

	@RequestMapping(value = "/human/ham800skr.do")
	public String ham800skr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
	
		return JSP_PATH + "ham800skr";
	}

	/**
	 *일용직급여등록(JOINS) 
	 * 
	 * 
	 */
	
	@RequestMapping(value = "/human/ham801ukr.do")
	public String ham801skr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
	
		return JSP_PATH + "ham801ukr";
	}
	
	/**
	 * Navi버튼 활성화를 결정
	 * @param param
	 * @param loginVO
	 * @return 현재 사원의 전후로 데이터가 있는지 확인
	 * @throws Exception
	 */
	@RequestMapping(value="/human/checkAvailableNavi.do")
	public ModelAndView checkAvailableNavi(@RequestParam Map<String, String> param, LoginVO loginVO) throws Exception {
		param.put("S_COMP_CODE", loginVO.getCompCode());
		List<Map<String, Object>> result = ham800skrService.checkAvailableNavi(param);
		return ViewHelper.getJsonView(result);
	}
	
	
	@RequestMapping(value = "/human/ham900skr.do")
	public String ham900skr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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
		
		return JSP_PATH + "ham900skr";
	}

	/**
	 * 월별일용근로소득내역조회 (ham950skr) - 20210805 신규 등록
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/human/ham950skr.do")
	public String ham950skr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
//		final String[] searchFields = {  };
//		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
//		LoginVO session = _req.getSession();
//		Map<String, Object> param = navigator.getParam();
//		String page = _req.getP("page");
//		param.put("S_COMP_CODE",loginVO.getCompCode());

		return JSP_PATH + "ham950skr";
	}
	
	@RequestMapping(value = "/human/ham100skr.do")
	public String ham100skr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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
		
		return JSP_PATH + "ham100skr";
	}
	
	/**
	 *  비정규직 사원등록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/human/ham100ukr.do")
	public String ham100ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		
		 CodeDetailVO cdo = codeInfo.getCodeInfo("H102", "01");
		if(!ObjUtils.isEmpty(cdo))	{
			if("Y".equals(ObjUtils.getSafeString(cdo.getRefCode1())) )	{
				model.addAttribute("autoNum","true");	//Y:여신잔액(txtRemainCredit) visible
			}else {
				model.addAttribute("autoNum","false");	//Y:여신잔액(txtRemainCredit) visible
			}
		}
		Map param = new HashMap();
		param.put("S_COMP_CODE", loginVO.getCompCode());
		model.addAttribute("BussOfficeCode", hpa994ukrService.getBussOfficeCode(param));
		
		
		model.addAttribute("costPoolCombo", comboService.getHumanCostPool(param));
		
		
		Map map = new HashMap();
        model.addAttribute("COMBO_DEPTS2", comboService.fnGetauthDepts(loginVO,map));//기관 콤보
		
		
		
		return JSP_PATH+"ham100ukr";
	}
	
/*	@RequestMapping(value = "/human/ham800ukr.do")
	public String ham800ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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
		
		return JSP_PATH + "ham800ukr";
	}*/
	
	@RequestMapping(value="/human/ham800ukr.do")
	public String ham800ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model)throws Exception{
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		
		Gson gson = new Gson();
		String colData = gson.toJson(ham800ukrService.fnAmtCal(loginVO));	
		model.addAttribute("colData", colData);
		
		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_SUPP_TYPE", comboService.getPayment(param));
		
		//
		CodeInfo codeInfo2 = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo2 = null;
        cdo2 = codeInfo.getCodeInfo("H175", "42");
        if(!ObjUtils.isEmpty(cdo2))  model.addAttribute("gsHireYN",cdo2.getRefCode1());  
		
		return JSP_PATH+"ham800ukr";
	
	}

	@RequestMapping(value = "/human/ham802ukr.do")
	public String ham802ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		
		Gson gson = new Gson();
		String colData = gson.toJson(ham800ukrService.fnAmtCal(loginVO));	
		model.addAttribute("colData", colData);
		
		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_SUPP_TYPE", comboService.getPayment(param));
		
		return JSP_PATH + "ham802ukr";
	}
	
/*	@RequestMapping(value="/human/fnInSurHam800.do")
	public ModelAndView fnInSur(@RequestParam Map<String, String> param, LoginVO loginVO) throws Exception {
		param.put("S_COMP_CODE", loginVO.getCompCode());
		Date now = new Date();
		SimpleDateFormat format = new SimpleDateFormat("yyyyMM");
		String date = format.format(now);
		String pay_yyyymm = date.substring(0, 4);
		param.put("PAY_YYYYMM", pay_yyyymm);
		Map result = ham800ukrService.fnInSur(param);
		return ViewHelper.getJsonView(result);
	}
	@RequestMapping(value="/human/fnEndAmtCalcHam800.do")
	public ModelAndView fnEndAmtCalc(@RequestParam Map<String, String> param, LoginVO loginVO) throws Exception {
		param.put("S_COMP_CODE", loginVO.getCompCode());
//		List<Map<String, Object>> result = hpa330ukrService.checkAvailableNavi(param);
		String result = ham800ukrService.fnEndAmtCalc(param);
		return ViewHelper.getJsonView(result);
	}*/
/*	@RequestMapping(value = "/human/ham810ukr.do")
	public String ham810ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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
		
		return JSP_PATH + "ham810ukr";
	}*/
	
	
	/**
	 * 일용근로소득 엑셀업로드
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/human/ham805ukr.do")
	public String ham805ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");		
		
		param.put("S_COMP_CODE",loginVO.getCompCode());
		Gson gson = new Gson();
//		String deptData = gson.toJson(ham805ukr.userDept(loginVO));
//		model.addAttribute("deptData", deptData);
		
		return JSP_PATH + "ham805ukr";
	}
	
	
	/**
	 * 일용근로소득 자동기표
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/human/ham820ukr.do")
	public String ham820ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");		
		
		param.put("S_COMP_CODE",loginVO.getCompCode());
		Gson gson = new Gson();
//		String deptData = gson.toJson(ham805ukr.userDept(loginVO));
//		model.addAttribute("deptData", deptData);
		
		return JSP_PATH + "ham820ukr";
	}

	
	@RequestMapping(value="/human/ham810ukr.do")
	public String ham810ukr(LoginVO loginVO, ModelMap model)throws Exception{
			Gson gson = new Gson();
			String colData = gson.toJson(ham810ukrService.selectColumns(loginVO));
			model.addAttribute("colData", colData);
			return JSP_PATH+"ham810ukr";
	}
	
	@RequestMapping(value = "/human/ham850ukr.do")
	public String ham850ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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
		
		return JSP_PATH + "ham850ukr";
	}
	
	@RequestMapping(value = "/human/ham920ukr.do")
	public String ham920ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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
		
		return JSP_PATH + "ham920ukr";
	}
	

	/**
	 * 일용근로자 전산신고자료생성 프로시져
	 */
	@RequestMapping(value = "/human/ham920proc.do")
	public ModelAndView hpa991ukr(@RequestParam Map<String, String> param, LoginVO loginVO) throws Exception {
		FileDownloadInfo fInfo = null;
		//Map result = ham920ukrService.createRetireFile(param, loginVO);
		fInfo = ham920ukrService.createRetireFile(param, loginVO);
				
		//return ViewHelper.getJsonView(result);
		return ViewHelper.getFileDownloadView(fInfo);
	}
	
	/**
	 * 일용근로자 전산신고자료생성(월별) 화면 open
	 */
	@RequestMapping(value = "/human/ham930ukr.do")
	public String ham930ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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
		
		return JSP_PATH + "ham930ukr";
	}
	
	/**
	 * 일용근로자 전산신고자료생성 프로시져(월별)
	 */
	@RequestMapping(value = "/human/ham930proc.do")
	public ModelAndView ham930proc(@RequestParam Map<String, String> param, LoginVO loginVO) throws Exception {
		
		FileDownloadInfo fInfo = ham930ukrService.createRetireFile(param, loginVO);

		return ViewHelper.getFileDownloadView(fInfo);
	}
	
	/**
	 * 일용근로소득지급조서
	 */
	@RequestMapping(value = "/human/ham910rkr.do")
	public String hum970rkr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");		
		
		return JSP_PATH + "ham910rkr";
	}
	
}
