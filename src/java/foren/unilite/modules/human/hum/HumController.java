package foren.unilite.modules.human.hum;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.google.gson.Gson;

import foren.framework.lib.listop.ListOp;
import foren.framework.logging.InjectLogger;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.model.NavigatorInfo;
import foren.framework.utils.GStringUtils;
import foren.framework.utils.ObjUtils;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.modules.com.combo.ComboServiceImpl;
import foren.unilite.modules.human.HumanCommonServiceImpl;
import foren.unilite.modules.human.HumanUtils;
import foren.unilite.modules.human.hpa.Hpa994ukrServiceImpl;

/**
 * 프로그램명 : 인사 - 인사관리 Controller 작 성 자 : (주)포렌 개발실
 */
@Controller
public class HumController extends UniliteCommonController {
	@InjectLogger
	public static Logger		   logger;							  //	= LoggerFactory.getLogger(this.getClass());
	
	final static String			JSP_PATH		   = "/human/hum/";
	public final static String	 FILE_TYPE_OF_PHOTO = "employeePhoto";
	
	@Resource( name = "humanCommonService" )
	private HumanCommonServiceImpl humanCommonService;
	
	@Resource( name = "UniliteComboServiceImpl" )
	private ComboServiceImpl	   comboService;
	
	@Resource( name = "hum100ukrService" )
	private Hum100ukrServiceImpl   hum100ukrService;
		
	@Resource( name = "hum200ukrService" )
	private Hum200ukrServiceImpl   hum200ukrService;
	
	@Resource( name = "hum290ukrService" )
	private Hum290ukrServiceImpl   hum290ukrService;
	
	@Resource( name = "hum910skrService" )
	private Hum910skrServiceImpl   hum910skrService;
	
	@Resource( name = "hum920skrService" )
	private Hum920skrServiceImpl   hum920skrService;
	
	@Resource( name = "hpa994ukrService" )
	private Hpa994ukrServiceImpl   hpa994ukrService;



	@RequestMapping( value = "/human/hum998ukr.do" )
	public String hum998ukr() throws Exception {
		return JSP_PATH + "hum998ukr";
	}
	
	@RequestMapping( value = "/human/hum999skr.do" )
	public String hum999skr() throws Exception {
		return JSP_PATH + "hum999skr";
	}
	
	@RequestMapping( value = "/human/hum999ukr.do" )
	public String hum999ukr() throws Exception {
		return JSP_PATH + "hum999ukr";
	}
	
	/**
	 * 인사자료등록
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/human/hum100ukr.do" )
	public String hum100ukrv( LoginVO loginVO, ModelMap model ) throws Exception {
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		
		CodeDetailVO cdo = codeInfo.getCodeInfo("H102", "01");
		if (!ObjUtils.isEmpty(cdo)) {
			if ("Y".equals(ObjUtils.getSafeString(cdo.getRefCode1()))) {
				model.addAttribute("autoNum", "true");	//Y:여신잔액(txtRemainCredit) visible
			} else {
				model.addAttribute("autoNum", "false");	//Y:여신잔액(txtRemainCredit) visible
			}
		}
		Map param = new HashMap();
		param.put("S_COMP_CODE", loginVO.getCompCode());
		model.addAttribute("BussOfficeCode", hpa994ukrService.getBussOfficeCode(param));
		
		List<Map<String, Object>> wageStd = hum100ukrService.fnHum100P2Codes(param);
		
		if (ObjUtils.isNotEmpty(wageStd)) {
			model.addAttribute("wageStd", ObjUtils.toJsonStr(wageStd));
		} else {
			model.addAttribute("wageStd", "[]");
		}
		
		model.addAttribute("costPoolCombo", comboService.getHumanCostPool(param));
		
		//Cost Pool 명칭변경
		CodeDetailVO cdo2 = codeInfo.getCodeInfo("H175", "10");
		if(cdo2 != null && "Y".equals(GStringUtils.toUpperCase(cdo2.getRefCode1(), "")))	{
			model.addAttribute("costPoolLabel", ObjUtils.getSafeString(cdo2.getRefCode2(),  "COST POOL"));
		} else {
			model.addAttribute("costPoolLabel", "COST POOL");
		}
		
		// 발령사항 탭 표시 여부
		CodeDetailVO tabCd = codeInfo.getCodeInfo("H175", "60");
		if(!ObjUtils.isEmpty(tabCd) && "Y".equals(tabCd.getRefCode1())){
			model.addAttribute("gsAnnounceTab",tabCd.getRefCode1());
		} else {
			model.addAttribute("gsAnnounceTab", "N");
		}
		// 학력사항 탭 표시여부 
		tabCd = codeInfo.getCodeInfo("H175", "61");
		if(!ObjUtils.isEmpty(tabCd) && "Y".equals(tabCd.getRefCode1())){
			model.addAttribute("gsAcademicBackgrTab",tabCd.getRefCode1());
		} else {
			model.addAttribute("gsAcademicBackgrTab", "N");
		}
		
		return JSP_PATH + "hum100ukr";
	}
	
	/**
	 * 인사자료등록
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/human/hum105ukr.do" )
	public String hum105ukr( LoginVO loginVO, ModelMap model ) throws Exception {
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		
		CodeDetailVO cdo = codeInfo.getCodeInfo("H102", "01");
		if (!ObjUtils.isEmpty(cdo)) {
			if ("Y".equals(ObjUtils.getSafeString(cdo.getRefCode1()))) {
				model.addAttribute("autoNum", "true");	//Y:여신잔액(txtRemainCredit) visible
			} else {
				model.addAttribute("autoNum", "false");	//Y:여신잔액(txtRemainCredit) visible
			}
		}
		Map param = new HashMap();
		param.put("S_COMP_CODE", loginVO.getCompCode());
		model.addAttribute("BussOfficeCode", hpa994ukrService.getBussOfficeCode(param));
		
		List<Map<String, Object>> wageStd = hum100ukrService.fnHum100P2Codes(param);
		
		if (ObjUtils.isNotEmpty(wageStd)) {
			model.addAttribute("wageStd", ObjUtils.toJsonStr(wageStd));
		} else {
			model.addAttribute("wageStd", "[]");
		}
		
		model.addAttribute("costPoolCombo", comboService.getHumanCostPool(param));
		
		return JSP_PATH + "hum105ukr";
	}
	
	
	/**
	 * 임금피크제등록
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/human/hum190ukr.do" )
	public String hum190ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE", loginVO.getCompCode());
		
		List<Map<String, Object>> wageStd = hum100ukrService.fnHum100P2Codes(param);
		
		if (ObjUtils.isNotEmpty(wageStd)) {
			model.addAttribute("wageStd", ObjUtils.toJsonStr(wageStd));
		} else {
			model.addAttribute("wageStd", "[]");
		}
		
		return JSP_PATH + "hum190ukr";
	}
	
	/**
	 * 인사기본자료일괄등록
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/human/hum110ukr.do" )
	public String hum110ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		
		Map param = new HashMap();
		param.put("S_COMP_CODE", loginVO.getCompCode());
		model.addAttribute("BussOfficeCode", hpa994ukrService.getBussOfficeCode(param));
		
		return JSP_PATH + "hum110ukr";
	}
	
	/**
	 * 인사추가자료조회
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/human/hum200ukr.do" )
	public String hum200ukrv() throws Exception {
		return JSP_PATH + "hum200ukr";
	}
	
	/**
	 * 발령등록
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/human/hum201ukr.do" )
	public String hum201ukrv( LoginVO loginVO, ModelMap model ) throws Exception {
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		
		Map param = new HashMap();
		param.put("S_COMP_CODE", loginVO.getCompCode());
		
		List<Map<String, Object>> wageStd = hum100ukrService.fnHum100P2Codes(param);
		
		if (ObjUtils.isNotEmpty(wageStd)) {
			model.addAttribute("wageStd", ObjUtils.toJsonStr(wageStd));
		} else {
			model.addAttribute("wageStd", "[]");
		}
		
		return JSP_PATH + "hum201ukr";
	}
	
	/**
	 * 발령등록(코베아)
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/human/hum205ukr.do" )
	public String hum205ukrv( LoginVO loginVO, ModelMap model ) throws Exception {
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		
		Map param = new HashMap();
		param.put("S_COMP_CODE", loginVO.getCompCode());
		
		List<Map<String, Object>> wageStd = hum100ukrService.fnHum100P2Codes(param);
		
		if (ObjUtils.isNotEmpty(wageStd)) {
			model.addAttribute("wageStd", ObjUtils.toJsonStr(wageStd));
		} else {
			model.addAttribute("wageStd", "[]");
		}
		
		return JSP_PATH + "hum205ukr";
	}
	
	
	
	/**
	 * 인사추가자료조회
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/human/hum210skr.do" )
	public String hum210skrv() throws Exception {
		return JSP_PATH + "hum210skr";
	}
	
	/**
	 * 인사변동조회
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/human/hum220skr.do" )
	public String hum220skrv() throws Exception {
		return JSP_PATH + "hum220skr";
	}
	
	/**
	 * 인사발령조회
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/human/hum230skr.do" )
	public String hum230skrv() throws Exception {
		return JSP_PATH + "hum230skr";
	}
	
	/**
	 * 고과사항조회
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/human/hum240skr.do" )
	public String hum240skrv() throws Exception {
		return JSP_PATH + "hum240skr";
	}
	
	/**
	 * 호봉승급관리
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/human/hum245ukr.do" )
	public String hum245ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		return JSP_PATH + "hum245ukr";
	}
	
	/**
	 * 기간별인원현황조회
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/human/hum250skr.do" )
	public String hum250skrv() throws Exception {
		return JSP_PATH + "hum250skr";
	}
	
	/**
	 * 결혼생일자명단조회
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/human/hum270skr.do" )
	public String hum270skr() throws Exception {
		return JSP_PATH + "hum270skr";
	}
	
	/**
	 * 연간 입퇴사자 현황 조회
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/human/hum280skr.do" )
	public String hum280skrv() throws Exception {
		return JSP_PATH + "hum280skr";
	}
	
	/**
	 * 평정관리(개별/종합)
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/human/hum290ukr.do" )
	public String hum290ukr( String popupID, ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		Gson gson = new Gson();
		String colData = gson.toJson(hum290ukrService.selectColumns(loginVO.getCompCode()));
		model.addAttribute("colData", colData);
		
		return JSP_PATH + "hum290ukr";
	}
	
	/**
	 * 평가점수등록 엑셀업로드
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/human/hum291ukr.do" )
	public String hum291ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE", loginVO.getCompCode());
		model.addAttribute("COMBO_HUMAN_COST_POOL", comboService.getHumanCostPool(param));			// 사업명
		
		model.addAttribute("CostPool", humanCommonService.getCostPool(param));					// H175 subCode 10의 Y/N Check
		
		return JSP_PATH + "hum291ukr";
	}
	
	/**
	 * 해외출장등록
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/human/hum900ukr.do" )
	public String hum900ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE", loginVO.getCompCode());
		
		return JSP_PATH + "hum900ukr";
	}
	
	/**
	 * 사원조회
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/human/hum920skr.do" )
	public String hum920skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE", loginVO.getCompCode());
		model.addAttribute("COMBO_HUMAN_COST_POOL", comboService.getHumanCostPool(param));
		
		List<Map<String, Object>> gsLicenseTab = hum920skrService.checkLicenseTab(param);		// 버스 재입사관리, 면허기타 Tab 사용여부
		model.addAttribute("gsLicenseTab", ObjUtils.toJsonStr(gsLicenseTab));
		
		List<Map<String, Object>> gsOnlyHuman = hum920skrService.checkOnlyHuman(param);			// 급여/고정공제 tab 사용못하는 인사담당자 id 여부	
		model.addAttribute("gsOnlyHuman", ObjUtils.toJsonStr(gsOnlyHuman));
		
		model.addAttribute("CostPool", humanCommonService.getCostPool(param));					// H175 subCode 10의 Y/N Check
		
		return JSP_PATH + "hum920skr";
	}
	
	/**
	 * 신체,주거,기타사항
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/human/hum301ukr.do" )
	public String hum301ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE", loginVO.getCompCode());
		model.addAttribute("COMBO_HUMAN_COST_POOL", comboService.getHumanCostPool(param));
		
		model.addAttribute("CostPool", humanCommonService.getCostPool(param));					// H175 subCode 10의 Y/N Check
		
		return JSP_PATH + "hum301ukr";
	}
	
	/**
	 * 학력사항
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/human/hum302ukr.do" )
	public String hum302ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE", loginVO.getCompCode());
		model.addAttribute("COMBO_HUMAN_COST_POOL", comboService.getHumanCostPool(param));			// 사업명
		
		model.addAttribute("CostPool", humanCommonService.getCostPool(param));					// H175 subCode 10의 Y/N Check
		
		return JSP_PATH + "hum302ukr";
	}
	
	/**
	 * 여권비자
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/human/hum303ukr.do" )
	public String hum303ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE", loginVO.getCompCode());
		model.addAttribute("COMBO_HUMAN_COST_POOL", comboService.getHumanCostPool(param));			// 사업명
		
		model.addAttribute("CostPool", humanCommonService.getCostPool(param));					// H175 subCode 10의 Y/N Check
		
		return JSP_PATH + "hum303ukr";
	}
	
	/**
	 * 교육연수사항등록
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/human/hum304ukr.do" )
	public String hum304ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE", loginVO.getCompCode());
		model.addAttribute("COMBO_HUMAN_COST_POOL", comboService.getHumanCostPool(param));			// 사업명
		
		model.addAttribute("CostPool", humanCommonService.getCostPool(param));					// H175 subCode 10의 Y/N Check
		
		return JSP_PATH + "hum304ukr";
	}
	
	/**
	 * 어학자격관리
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/human/hum305ukr.do" )
	public String hum305ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE", loginVO.getCompCode());
		model.addAttribute("COMBO_HUMAN_COST_POOL", comboService.getHumanCostPool(param));			// 사업명
		
		model.addAttribute("CostPool", humanCommonService.getCostPool(param));					// H175 subCode 10의 Y/N Check
		
		return JSP_PATH + "hum305ukr";
	}
	
	/**
	 * 해외출장등록
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/human/hum306ukr.do" )
	public String hum306ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE", loginVO.getCompCode());
		model.addAttribute("COMBO_HUMAN_COST_POOL", comboService.getHumanCostPool(param));			// 사업명
		
		model.addAttribute("CostPool", humanCommonService.getCostPool(param));					// H175 subCode 10의 Y/N Check
		
		return JSP_PATH + "hum306ukr";
	}
	
	/**
	 * 휴직산재관리
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/human/hum307ukr.do" )
	public String hum307ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE", loginVO.getCompCode());
		model.addAttribute("COMBO_HUMAN_COST_POOL", comboService.getHumanCostPool(param));			// 사업명
		
		model.addAttribute("CostPool", humanCommonService.getCostPool(param));					// H175 subCode 10의 Y/N Check
		
		return JSP_PATH + "hum307ukr";
	}
	
	/**
	 * 인사변동(발령관리)
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/human/hum308ukr.do" )
	public String hum308ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE", loginVO.getCompCode());
		model.addAttribute("COMBO_HUMAN_COST_POOL", comboService.getHumanCostPool(param));			// 사업명
		
		model.addAttribute("CostPool", humanCommonService.getCostPool(param));					// H175 subCode 10의 Y/N Check
		
		return JSP_PATH + "hum308ukr";
	}
	
	/**
	 * 고과사항등록
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/human/hum309ukr.do" )
	public String hum309ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE", loginVO.getCompCode());
		model.addAttribute("COMBO_HUMAN_COST_POOL", comboService.getHumanCostPool(param));			// 사업명
		
		model.addAttribute("CostPool", humanCommonService.getCostPool(param));					// H175 subCode 10의 Y/N Check
		
		return JSP_PATH + "hum309ukr";
	}
	
	/**
	 * 추천인관리
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/human/hum310ukr.do" )
	public String hum310ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE", loginVO.getCompCode());
		model.addAttribute("COMBO_HUMAN_COST_POOL", comboService.getHumanCostPool(param));			// 사업명
		
		model.addAttribute("CostPool", humanCommonService.getCostPool(param));					// H175 subCode 10의 Y/N Check
		
		return JSP_PATH + "hum310ukr";
	}
	
	/**
	 * 보증인관리
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/human/hum311ukr.do" )
	public String hum311ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE", loginVO.getCompCode());
		model.addAttribute("COMBO_HUMAN_COST_POOL", comboService.getHumanCostPool(param));			// 사업명
		
		model.addAttribute("CostPool", humanCommonService.getCostPool(param));					// H175 subCode 10의 Y/N Check
		
		return JSP_PATH + "hum311ukr";
	}
	
	/**
	 * 상벌사항관리
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/human/hum312ukr.do" )
	public String hum312ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE", loginVO.getCompCode());
		model.addAttribute("COMBO_HUMAN_COST_POOL", comboService.getHumanCostPool(param));			// 사업명
		
		model.addAttribute("CostPool", humanCommonService.getCostPool(param));					// H175 subCode 10의 Y/N Check
		
		return JSP_PATH + "hum312ukr";
	}
	
	/**
	 * 가족사항조회
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/human/hum315skr.do" )
	public String hum315skrv( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE", loginVO.getCompCode());
		//조회조건(사업명 : CBM600T 참조하여 콤보 가져오는 것)
		model.addAttribute("COMBO_HUMAN_COST_POOL", comboService.getHumanCostPool(param));			// 사업명
		
		model.addAttribute("CostPool", humanCommonService.getCostPool(param));					// H175 subCode 10의 Y/N Check
		
		return JSP_PATH + "hum315skr";
	}
	
	/**
	 * 경력사항조회
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/human/hum316skr.do" )
	public String hum316skrv( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE", loginVO.getCompCode());
		//조회조건(사업명 : CBM600T 참조하여 콤보 가져오는 것)
		model.addAttribute("COMBO_HUMAN_COST_POOL", comboService.getHumanCostPool(param));			// 사업명
		
		model.addAttribute("CostPool", humanCommonService.getCostPool(param));					// H175 subCode 10의 Y/N Check
		
		return JSP_PATH + "hum316skr";
	}
	
	/**
	 * 자격면허조회
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/human/hum317skr.do" )
	public String hum317skrv( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE", loginVO.getCompCode());
		//조회조건(사업명 : CBM600T 참조하여 콤보 가져오는 것)
		model.addAttribute("COMBO_HUMAN_COST_POOL", comboService.getHumanCostPool(param));			// 사업명
		
		model.addAttribute("CostPool", humanCommonService.getCostPool(param));					// H175 subCode 10의 Y/N Check
		
		return JSP_PATH + "hum317skr";
	}
	
	/**
	 * 개인별발령내역 조회
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/human/hum500skr.do" )
	public String hum500skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE", loginVO.getCompCode());
		
		return JSP_PATH + "hum500skr";
	}
	
	/**
	 * 근로자명부 조회
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/human/hum510skr.do" )
	public String hum510skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE", loginVO.getCompCode());
		
		return JSP_PATH + "hum510skr";
	}
	@RequestMapping( value = "/human/s_hum510skr_kva.do" )
	public String s_hum510skr_kva( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE", loginVO.getCompCode());
		
		return JSP_PATH + "s_hum510skr_kva";
	}
	
	/**
	 * 인원현황 조회
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/human/hum520skr.do" )
	public String hum520skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE", loginVO.getCompCode());
		
		return JSP_PATH + "hum520skr";
	}
	@RequestMapping( value = "/human/s_hum520skr_kva.do" )
	public String s_hum520skr_kva( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE", loginVO.getCompCode());
		
		return JSP_PATH + "s_hum520skr_kva";
	}
	
	/**
	 * 인원현황 조회
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/human/hum521skr.do" )
	public String hum521skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE", loginVO.getCompCode());
		
		return JSP_PATH + "hum521skr";
	}
	
	/**
	 * 노조가입현황 조회
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/human/hum522skr.do" )
	public String hum522skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE", loginVO.getCompCode());
		
		return JSP_PATH + "hum522skr";
	}
	
	/**
	 * 장애인 및 국가유공자 조회
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/human/hum523skr.do" )
	public String hum523skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE", loginVO.getCompCode());
		
		return JSP_PATH + "hum523skr";
	}
	
	/**
	 * 상벌사항 조회
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/human/hum530skr.do" )
	public String hum530skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE", loginVO.getCompCode());
		
		return JSP_PATH + "hum530skr";
	}
	
	/**
	 * 인사발령 급료변경 현황 조회
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/human/hum540skr.do" )
	public String hum540skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE", loginVO.getCompCode());
		
		return JSP_PATH + "hum540skr";
	}
	
	/**
	 * 직원인사 최종승진승급 현황 조회
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/human/hum550skr.do" )
	public String hum550skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE", loginVO.getCompCode());
		
		return JSP_PATH + "hum550skr";
	}
	
	/**
	 * 입퇴사별 인원현황 조회
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/human/hum560skr.do" )
	public String hum560skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE", loginVO.getCompCode());
		
		return JSP_PATH + "hum560skr";
	}
	@RequestMapping( value = "/human/s_hum560skr_kva.do" )
	public String s_hum560skr_kva( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE", loginVO.getCompCode());
		
		return JSP_PATH + "s_hum560skr_kva";
	}
	
	/**
	 * 입사일자별 근속현황표 조회
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/human/hum570skr.do" )
	public String hum570skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE", loginVO.getCompCode());
		
		return JSP_PATH + "hum570skr";
	}
	@RequestMapping( value = "/human/s_hum570skr_kva.do" )
	public String s_hum570skr_kva( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE", loginVO.getCompCode());
		
		return JSP_PATH + "s_hum570skr_kva";
	}
	
	/**
	 * 정년만기 해당자현황 조회
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/human/hum580skr.do" )
	public String hum580skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE", loginVO.getCompCode());
		
		return JSP_PATH + "hum580skr";
	}
	
	/**
	 * 연봉계약자 만기도래현황 명세서 조회
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/human/hum590skr.do" )
	public String hum590skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE", loginVO.getCompCode());
		
		return JSP_PATH + "hum590skr";
	}
	
	/**
	 * 임금피크제 조회
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/human/hum600skr.do" )
	public String hum600skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE", loginVO.getCompCode());
		
		return JSP_PATH + "hum600skr";
	}
	
	/**
	 * 임금피크제 조회(년도별/직급별)
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/human/hum610skr.do" )
	public String hum610skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE", loginVO.getCompCode());
		
		return JSP_PATH + "hum610skr";
	}
	
	/**
	 * 발령등록(성남도시공사)
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/human/hum760ukr.do" )
	public String hum760ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE", loginVO.getCompCode());
	  //조회조건(사업명 : CBM600T 참조하여 콤보 가져오는 것)
		model.addAttribute("COMBO_HUMAN_COST_POOL", comboService.getHumanCostPool(param));
		
		return JSP_PATH + "hum760ukr";
	}
	
	/**
	 * 해외출장 조회
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/human/hum910skr.do" )
	public String hum910skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		return JSP_PATH + "hum910skr";
	}
	
	/**
	 * 재직/퇴직증명서대장조회
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/human/hum971skr.do" )
	public String hum971skrv() throws Exception {
		return JSP_PATH + "hum971skr";
	}
	
	//	@RequestMapping(value="/human/viewPhoto.do",  method = RequestMethod.GET)
	//	public ModelAndView viewPhoto( String personNumb, ModelMap model, HttpServletRequest request)throws Exception{
	//		logger.debug("personNumb :{}", personNumb);
	//		File photo = HumanUtils.getHumanPhoto(personNumb);
	//		if(photo == null || !photo.canRead()) {
	////			String url = "/resources/images/human/noPhoto.png";
	////			return new ModelAndView("redirect:"+url);
	//			photo = new File( request.getServletContext().getRealPath("/resources/images/human/"), "noPhoto.png");
	//
	//		}
	//		return ViewHelper.getImageView(photo);
	//	}
	
	@RequestMapping( value = "/uploads/employeePhoto/{personNumb}" )
	public ModelAndView viewPhoto2( @PathVariable( "personNumb" ) String personNumb, ModelMap model, HttpServletRequest request ) throws Exception {
		File photo = HumanUtils.getHumanPhoto(personNumb);
		if (photo == null || !photo.canRead()) {
			//			String url = "/resources/images/human/noPhoto.png";
			//			return new ModelAndView("redirect:"+url);
			String path = request.getServletContext().getRealPath("/resources/images/human/");
			photo = new File(path, "noPhoto.png");
		}
		
		logger.debug("personNumb :{}, File = {} ", personNumb, photo.toPath());
		return ViewHelper.getImageView(photo);
	}
	
	/**
	 * 호봉승급관리 - 재참조
	 */
	@RequestMapping( value = "/human/fnHum240QStd2.do" )
	public ModelAndView fnHum240QStd2( @RequestParam Map<String, String> param, LoginVO loginVO ) throws Exception {
		List result = hum200ukrService.fnHum240QStd2(param, loginVO);
		
		return ViewHelper.getJsonView(result);
	}
	
	/**
	 * 사원명부출력
	 */
	@RequestMapping( value = "/human/hum950rkr.do" )
	public String hum950rkr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		return JSP_PATH + "hum950rkr";
	}
	
	/**
	 * 사원명부출력 - 성남도시개발공사
	 */
	@RequestMapping( value = "/human/hum953rkr.do" )
	public String hum953rkr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		return JSP_PATH + "hum953rkr";
	}
	/**
	 * 인사기록카드출력 chenaibo 20161214
	 */
	@RequestMapping( value = "/human/hum960rkr.do" )
	public String hum960rkr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		return JSP_PATH + "hum960rkr";
	}
	
	/**
	 * 인사기록카드출력 chenaibo 20161214
	 */
	@RequestMapping( value = "/human/hum961rkr.do" )
	public String hum961rkr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		return JSP_PATH + "hum961rkr";
	}
	
	/**
	 * 인사기록카드출력 chenaibo 20161214
	 */
	@RequestMapping( value = "/human/hum962rkr.do" )
	public String hum962rkr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo1 = null;
		CodeDetailVO cdo2 = null;
		
		cdo1 = codeInfo.getCodeInfo("H175", "40");
		if (!ObjUtils.isEmpty(cdo1)) model.addAttribute("sRefConfig", cdo1.getRefCode3());
		
		cdo2 = codeInfo.getCodeInfo("H171", "1");
		if (!ObjUtils.isEmpty(cdo2)) model.addAttribute("gsRepreName", cdo2.getCodeName());
		
		return JSP_PATH + "hum962rkr";
	}
	/**
	 * 인사기록카드출력 - 성남도시개발공사
	 */
	@RequestMapping( value = "/human/hum963rkr.do" )
	public String hum963rkr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		return JSP_PATH + "hum963rkr";
	}
	
	/**
	 * 인사기록카드출력(인사변동 내역 전체) - 성남도시개발공사
	 */
	@RequestMapping( value = "/human/hum964rkr.do" )
	public String hum964rkr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		return JSP_PATH + "hum964rkr";
	}
	
	/**
	 * 재직/경력증명서 출력
	 */
	@RequestMapping( value = "/human/hum970rkr.do" )
	public String hum970rkr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		List<CodeDetailVO> gsReportGubun = codeInfo.getCodeList("H184", "", false);
		for(CodeDetailVO map : gsReportGubun) {
			if("hum970clrkrv".equals(map.getCodeName())) {
				model.addAttribute("gsReportGubun", map.getRefCode10());
			}
		}
		
		return JSP_PATH + "hum970rkr";
	}
	
	/**
	 * 재직/경력증명서 출력(노비스바이오)
	 */
	@RequestMapping( value = "/human/hum976rkr.do" )
	public String hum976rkr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		return JSP_PATH + "hum976rkr";
	}
	/**
	 * 증명서발급 출력 (성남도시개발공사)
	 */
	@RequestMapping( value = "/human/hum973rkr.do" )
	public String hum973rkr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		return JSP_PATH + "hum973rkr";
	}
	/**
	 * 인사기록카드출력2 (hum980rkr)
	 */
	@RequestMapping( value = "/human/hum980rkr.do" )
	public String hum980rkr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		//20200804 추가: 리포트 프로그램 설정값 가져오기(크리스탈,jasper 또는 ClipReport)
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		List<CodeDetailVO> gsReportGubun = codeInfo.getCodeList("H184", "", false);
		for(CodeDetailVO map : gsReportGubun) {
			if("hum980rkr".equals(map.getCodeName())) {
				model.addAttribute("gsReportGubun", map.getRefCode10());
			}
		}
		return JSP_PATH + "hum980rkr";
	}

	/**
	 * 재직/경력증명서 출력 (공공)
	 */
	@RequestMapping( value = "/human/hum975rkr.do" )
	public String hum975rkr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		return JSP_PATH + "hum975rkr";
	}

	/**
	 * 입사자별근속현황표1
	 */
	@RequestMapping( value = "/human/hum101rkr.do" )
	public String hum101rkr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		return JSP_PATH + "hum101rkr";
	}

	/**
	 * 입사자별근속현황표2
	 */
	@RequestMapping( value = "/human/hum102rkr.do" )
	public String hum102rkr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		return JSP_PATH + "hum102rkr";
	}

	/**
	 * add by zhongshl
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/human/hum930rkr.do" )
	public String hum930rkr() throws Exception {
		return JSP_PATH + "hum930rkr";
	}

	/**
	 * 평가급 지급 기초관리
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/human/hum781ukr.do")
	public String hum781ukr(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		return JSP_PATH + "hum781ukr";
	}

	/**
	 * 기간별인원현황 출력
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/human/hum260rkr.do")
	public String hum260rkr(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		return JSP_PATH + "hum260rkr";
	}
	
	/**
	 * 일용직사원등록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/human/hum300ukr.do")
	public String hum300ukr(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		return JSP_PATH + "hum300ukr";
	}
}