package foren.unilite.modules.human.hbs;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.google.gson.Gson;

import foren.framework.lib.listop.ListOp;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.model.NavigatorInfo;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.com.tags.ComboItemModel;
import foren.unilite.modules.com.combo.ComboServiceImpl;
import foren.unilite.modules.human.hpa.Hpa950skrServiceImpl;

@Controller
public class HbsController extends UniliteCommonController {
	
	@Resource(name="UniliteComboServiceImpl")
	private ComboServiceImpl comboService;

	@Resource(name="hbs020ukrService")
	private Hbs020ukrServiceImpl hbs020ukrService;
	
	@Resource(name="s_hbs200ukr_kdService")
	private S_hbs200ukr_kdServiceImpl s_hbs200ukr_kdService;	
	
	@Resource(name="hbs030ukrService")
	private Hbs030ukrServiceImpl hbs030ukrService;
	
	@Resource(name="hbs910ukrService")
	private Hbs910ukrServiceImpl hbs910ukrService;
	
	@Resource(name="hbs910ukrvService")
	private Hbs910ukrvServiceImpl hbs910ukrvService;
	
	@Resource(name="hbs920ukrService")
	private Hbs920ukrServiceImpl hbs920ukrService;
	
	@Resource(name="hbs930ukrService")
	private Hbs930ukrServiceImpl hbs930ukrService;
	
	@Resource(name="hbs940ukrService")
	private Hbs940ukrServiceImpl hbs940ukrService;
	
	@Resource(name="hbs950ukrService")
	private Hbs950ukrServiceImpl hbs950ukrService;
	
	@Resource(name="hbs810ukrService")
	private Hbs810ukrServiceImpl hbs810ukrService;
	
	@Resource(name="hbs820ukrService")
	private Hbs820ukrServiceImpl hbs820ukrService;
	
	
	private final Logger	logger		= LoggerFactory.getLogger(this.getClass());

	final static String		JSP_PATH	= "/human/hbs/";	
	
	/**
	 * 입사자구비서류등록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/human/hbs810ukr.do")
	public String hbs810ukr(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		return JSP_PATH + "hbs810ukr";
	}
	
	/**
	 * 계정상세등록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/human/hbs820ukr.do")
	public String hbs820ukr(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		return JSP_PATH + "hbs820ukr";
	}
	
	/**
	 * 관리항목등록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/human/hbs830ukr.do")
	public String hbs830ukr(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		return JSP_PATH + "hbs830ukr";
	}
	
	/**
	 * 집계항목설정
	 * @return
	 * @throws Exception
	 */
/*	@RequestMapping(value = "/human/hbs910ukr.do")
	public String hbs910ukr(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		return JSP_PATH + "hbs910ukr";
	}*/
	
	/**
	 * 시산표설정
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/human/hbs910ukrv.do")
	public String hbs910ukrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		Gson gson = new Gson();
		
		String colData = gson.toJson(hbs910ukrvService.selectColumns(loginVO));
		logger.debug("colData ======== "+ colData);
		model.addAttribute("colData", colData);
		return JSP_PATH + "hbs910ukrv";
	}
	
	/**
	 * 기준코드등록
	 * @return
	 * @throws Exception
	 */
/*	@RequestMapping(value = "/human/hbs920ukr.do")
	public String hbs920ukr(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		return JSP_PATH + "hbs920ukr";
	}*/
	
	/**
	 * 회계업무 설정
	 * @return
	 * @throws Exception
	 */
/*	@RequestMapping(value = "/human/hbs930ukr.do")
	public String hbs930ukr(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		return JSP_PATH + "hbs930ukr";
	}*/
	/**
	 * 기본정보 등록
	 * @return
	 * @throws Exception
	 */
/*	@RequestMapping(value = "/human/hbs940ukr.do")
	public String hbs940ukr(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		return JSP_PATH + "hbs940ukr";
	
	}*/		
	/**
	 * 전표마감등록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/human/hbs950ukr.do")
	public String hbs950ukr(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		String colData = "";
		try{
		colData = hbs950ukrService.selectCloseyyyy(loginVO.getCompCode());
		}catch(NullPointerException e){
			
		}
		model.addAttribute("colData", colData);
		return JSP_PATH + "hbs950ukr";
	}
	
	@RequestMapping(value = "/human/hbs010ukr.do")
	public String hbs010ukr(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		return JSP_PATH + "hbs010ukr";
	}
	
	@RequestMapping(value = "/human/hbs020ukr.do")
	public String hbs020ukr(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		// 급호봉 등록 탭의 컬럼 정보를 내려 받음
		Gson gson = new Gson();
		String colDataTab11 = gson.toJson(hbs020ukrService.getColumnData(loginVO.getCompCode()));
		int sub_length = hbs020ukrService.getSUB_LENGTH(loginVO.getCompCode());
		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("wagesCodeList", hbs020ukrService.getWagesCode(param));	//입/퇴사자지급기준등록 수당코드 list
		model.addAttribute("wagesCodeList2", hbs020ukrService.getWagesCode2(param));	//지급공제항목
		model.addAttribute("bonusTypeCodeList", hbs020ukrService.getBonusTypeCode(param));	//상여자지급기준 등록 상여구분 list
		model.addAttribute("colDataTab11", colDataTab11);
		model.addAttribute("sub_length", sub_length);
		model.addAttribute("paymCombo", comboService.getPayList(param));
		
		String colDataTab12 = gson.toJson(hbs020ukrService.getColumnData2(loginVO.getCompCode()));
		model.addAttribute("colDataTab12", colDataTab12);
		//급여관리기준등록 hbs020ukrs1 연차계산방식 기준 가져오기
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		List<CodeDetailVO> gsMoneyUnit = codeInfo.getCodeList("H194", "", false);	//자국화폐단위 정보		
		for(CodeDetailVO map : gsMoneyUnit)	{
			if("Y".equals(map.getRefCode1())){
				model.addAttribute("yearCalculation", map.getCodeNo());
			}			 
		}
		
		Map<String, Object> param2 = new HashMap<String, Object>();
		param2.put("S_COMP_CODE", loginVO.getCompCode());
		param2.put("S_LANG_CODE", loginVO.getLanguage());
		model.addAttribute("STD_CODE_STORE",  hbs020ukrService.tab15_GetComboData(param2));
		
		model.addAttribute("OT_KIND_01_STORE",  hbs020ukrService.tab15_GetComboData2(param2));
		model.addAttribute("OT_KIND_02_STORE", hbs020ukrService.tab15_GetComboData3(param2));
		model.addAttribute("COMBO_CNWK_DSNC", comboService.fnGetCnwkDsnc(param));//기관 콤보
		
		return JSP_PATH + "hbs020ukr";
	}
	
	@RequestMapping(value="/human/hbs020ukr5_1.do")
	public String hbs020ukr5_1(LoginVO loginVO, ModelMap model)throws Exception{
		
		return JSP_PATH+"hbs020ukrs5_1";
	}
	
	@RequestMapping(value = "/human/s_hbs200ukr_kd.do")
	public String s_hbs200ukr_kd(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();		
		// 급호봉 등록 탭의 컬럼 정보를 내려 받음
		Gson gson = new Gson();
		String colDataTab11 = gson.toJson(s_hbs200ukr_kdService.getColumnData(loginVO.getCompCode()));	
		
		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("colDataTab11", colDataTab11);
		
		return JSP_PATH + "s_hbs200ukr_kd";
	}	
	
	/**
	 * 급여관리 기준을 수정함
	 * @param param
	 * @param loginVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/human/hbs020ukrSubmitForm01.do")
	public ModelAndView hbs020ukrSubmitForm01(@RequestParam Map<String, Object> param, LoginVO loginVO, ModelMap model) throws Exception {
		int rv = 0;
		param.put("S_COMP_CODE", loginVO.getCompCode());
		param.put("S_USER_ID", loginVO.getUserID());
		rv = hbs020ukrService.updateList1(param);
		return ViewHelper.getJsonView(rv);
	}
	
	/**
	 * 지급/공제코드 콤보 데이터를 조회함
	 * @param comboCode
	 * @param loginVO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/human/hbs020ukrGetComboData.do")
	public ModelAndView hbs020ukrGetComboData(String comboCode, LoginVO loginVO) throws Exception {
		List<ComboItemModel> rv = null;
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("S_COMP_CODE", loginVO.getCompCode());
		param.put("S_LANG_CODE", loginVO.getLanguage());
		param.put("COMBO_CODE", comboCode);
		rv = hbs020ukrService.tab15_GetComboData(param);
		return ViewHelper.getJsonView(rv);
	}
	/**
	 * 분류값 콤보 데이터를 조회함
	 * @param comboCode
	 * @param loginVO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/human/hbs020ukrGetComboData3.do")
	public ModelAndView hbs020ukrGetComboData3(String comboCode, LoginVO loginVO, String SEARCH_FIELD) throws Exception {
		List<ComboItemModel> rv = null;
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("S_COMP_CODE", loginVO.getCompCode());
		param.put("S_LANG_CODE", loginVO.getLanguage());
		param.put("COMBO_CODE", comboCode);
		if (SEARCH_FIELD.indexOf(",") != -1) {
			String[] field = SEARCH_FIELD.split(",");
			param.put("SEARCH_FIELD", field[0]);
		} else {
			param.put("SEARCH_FIELD", SEARCH_FIELD);
		}
		rv = hbs020ukrService.tab15_GetComboData3(param);
		return ViewHelper.getJsonView(rv);
	}
	
	/**
	 * 연봉 일괄 데이터 생성
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/human/hbs020ukrInsertInitData.do")
	public ModelAndView hbs020ukrInsertInitData(@RequestParam Map<String, Object> param, LoginVO loginVO) throws Exception {
		int rv = 0;
		param.put("S_COMP_CODE", loginVO.getCompCode());
		rv = hbs020ukrService.insertBatchList12(param);
		return ViewHelper.getJsonView(rv);
	}
	
	/**
	 * 계산식을 저장함
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/human/hbs020ukrInsertCalcSentence.do",  method = {RequestMethod.GET, RequestMethod.POST} )
	public ModelAndView hbs020ukrInsertCalcSentence(@RequestParam String data) throws Exception {
		int rv = 0;
		rv = hbs020ukrService.insertList15(data);
		return ViewHelper.getJsonView(rv);
	}
	/**
	 * 입사구비서류등록 update or delete
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/human/hbs810ukrInsertDelete.do")
	public ModelAndView hbs810ukrInsertDelete(@RequestParam String data) throws Exception {
		int rv = 0;
		rv = hbs810ukrService.updateHbst810t(data);
		return ViewHelper.getJsonView(rv);
	}
	/**
	 * 입사구비서류등록 update or delete
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/human/hbs820ukrInsertDelete.do")
	public ModelAndView hbs820ukrInsertDelete(@RequestParam String data) throws Exception {
		int rv = 0;
		rv = hbs820ukrService.updateHbs820t(data);
		return ViewHelper.getJsonView(rv);
	}
	
	/**
	 * 급호봉을 저장함
	 * @param param
	 * @return
	 * @throws Exception
	 */
//	@RequestMapping(value = "/human/hbs020ukrInsertPayGrade.do")
//	public ModelAndView hbs020ukrInsertPayGrade(@RequestParam String data) throws Exception {
//		int rv = 0;
//		rv = hbs020ukrService.insertList11(data);
//		return ViewHelper.getJsonView(rv);
//	}
	
	/**
	 * 빈 엑셀 파일을 저장함
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/human/hbs020ukrExcelDown.do")
	public String hbs020ukrExcelDown() throws Exception {
		return "/excelForm/hbs020ukrExcelDownload";
	}
	
	@RequestMapping(value = "/human/hbs030ukr.do")
	public String hbs030ukr(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		return JSP_PATH + "hbs030ukr";
	}

	@RequestMapping(value = "/human/test.do")
	public ModelAndView testTransaction() throws Exception {
		String result =  hbs020ukrService.test();
		return ViewHelper.getJsonView(result);
	}
	
	/**
	 * 법정기준자료연도이월 Batch
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/human/doBatchHbs030ukr.do")
	public ModelAndView doBatchHbs030ukr(@RequestParam Map<String, String> param, LoginVO loginVO)throws Exception{
		param.put("S_COMP_CODE", loginVO.getCompCode());
		logger.debug(""+param);
		int result = hbs030ukrService.doBatch(param);
		return ViewHelper.getJsonView(result);
	    
	}
	/**
	 * 근태관리 마감정보등록 Batch
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/human/doBatchHbs910ukr.do")
	public ModelAndView doBatchHbs910ukr(@RequestParam Map<String, String> param, LoginVO loginVO)throws Exception{
		param.put("S_COMP_CODE", loginVO.getCompCode());
		logger.debug(""+param);
		int result = hbs910ukrService.doBatch(param);
		return ViewHelper.getJsonView(result);
	    
	}
	
	@RequestMapping(value="/human/hbs910ukr.do")
	public String hbs910ukr(LoginVO loginVO, ModelMap model)throws Exception{
		String colData = "";
		try{
		colData = hbs910ukrService.selectCloseyymm(loginVO.getCompCode());
		}catch(NullPointerException e){
			
		}
		model.addAttribute("colData", colData);
		return JSP_PATH+"hbs910ukr";
	}
	/**
	 * 급여관리 마감정보등록 Batch (개별 ServiceImpl에서 진행)
	 * @return
	 * @throws Exception
	
	@RequestMapping(value="/human/doBatchHbs920ukr.do")
	public ModelAndView doBatchHbs920ukr(@RequestParam Map<String, String> param, LoginVO loginVO)throws Exception{
		param.put("S_COMP_CODE", loginVO.getCompCode());
		logger.debug(""+param);
		int result = hbs920ukrService.doBatch(param);
		return ViewHelper.getJsonView(result);
    
	} */

	@RequestMapping(value="/human/hbs920ukr.do")
	public String hbs920ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		
		param.put("S_COMP_CODE",loginVO.getCompCode());
		
		//지급구분에서 refcode1이 1인 데이터만 가져오기
		List<CodeDetailVO> gsList1 = codeInfo.getCodeList("H032", "", false);
		Object list1= "";
		for(CodeDetailVO map : gsList1)	{
			if("1".equals(map.getRefCode1()))	{
				if(list1.equals("")){
				list1 =  map.getCodeNo();
				}else{
					list1 = list1 + ";" + map.getCodeNo();
				}
			}
		}
		model.addAttribute("gsList1", list1);

/**		colData 구하기 - fnInitBinding에서 호출해서 세팅(콤보 값이 변수로 넘어가야 함)
		String colData = "";
		try{
			colData = hbs920ukrService.selectCloseyymm(loginVO.getCompCode());
		}catch(NullPointerException e){
			
		}
		model.addAttribute("colData", colData);*/

		return JSP_PATH + "hbs920ukr";
	}
	
	
	/**
	 * 상여관리 마감정보등록 Batch
	 * @return
	 * @throws Exception
	 
	@RequestMapping(value="/human/doBatchHbs930ukr.do")
	public ModelAndView doBatchHbs930ukr(@RequestParam Map<String, String> param, LoginVO loginVO)throws Exception{
		param.put("S_COMP_CODE", loginVO.getCompCode());
		logger.debug(""+param);
		int result = hbs930ukrService.doBatch(param);
		return ViewHelper.getJsonView(result);
    
	}*/

	@RequestMapping(value="/human/hbs930ukr.do")
	public String hbs930ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		
		param.put("S_COMP_CODE",loginVO.getCompCode());
		
/**		String colData = "";
		try{
		colData = hbs930ukrService.selectCloseyymm(loginVO.getCompCode());
		}catch(NullPointerException e){
			
		}
		model.addAttribute("colData", colData);
*/		
		return JSP_PATH + "hbs930ukr";
	}
	/**
	 * 상여관리 마감정보등록 Batch
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/human/doBatchHbs940ukr.do")
	public ModelAndView doBatchHbs940ukr(@RequestParam Map<String, String> param, LoginVO loginVO)throws Exception{
		param.put("S_COMP_CODE", loginVO.getCompCode());
		logger.debug(""+param);
		int result = hbs940ukrService.doBatch(param);
		return ViewHelper.getJsonView(result);
    
	}

	@RequestMapping(value="/human/hbs940ukr.do")
	public String hbs940ukr(LoginVO loginVO, ModelMap model)throws Exception{
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		/*String colData = "";
		try{
		colData = hbs940ukrService.selectCloseyymm(loginVO.getCompCode());
		}catch(NullPointerException e){
			
		}
		model.addAttribute("colData", colData);*/
		
		List<CodeDetailVO> paymentType = codeInfo.getCodeList("H032", "", false);
		List<Map> payGubun = new ArrayList<Map>();
		for(CodeDetailVO map : paymentType)	{
			Map rMap = new HashMap();
			if(map.getCodeNo().equals("E") || map.getCodeNo().equals("F") || map.getCodeNo().equals("G") || map.getCodeNo().equals("N")){
				rMap.put("value",map.getCodeNo());
				rMap.put("text", map.getCodeName());
				rMap.put("option",map.getRefCode1());
				payGubun.add(rMap);
			}				
		}	
		model.addAttribute("payGubun", payGubun);
		
		return JSP_PATH+"hbs940ukr";
	}
	
	
	/**
	 * 연봉계약관리
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/human/hbs700ukr.do")
	public String hbs700ukr(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		return JSP_PATH + "hbs700ukr";
	}
	
	/**
     * 연봉계약출력
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/human/hbs700rkr.do")
    public String hbs700rkr(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
        return JSP_PATH + "hbs700rkr";
    }
    
    /**
     * 연봉직 내역 조회
     * 
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/human/hbs700skr.do" )
    public String hbs700skr() throws Exception {
        return JSP_PATH + "hbs700skr";
    }
	/**
	 * 연봉확정관리
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/human/hbs720ukr.do")
	public String hbs720ukr(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		return JSP_PATH + "hbs720ukr";
	}
	
	/**
	 * 담당자별업무수당
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/human/hbs211ukr.do")
	public String hbs211ukr(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();		
			
		return JSP_PATH + "hbs211ukr";
	}
	
	/**
	 * 연말정산마감등록(개인별)
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/human/hbs960ukr.do")
	public String hbs960ukr(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		return JSP_PATH + "hbs960ukr";
	}
	
}
