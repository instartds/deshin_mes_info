package foren.unilite.modules.human.hrt;

import java.io.FileOutputStream;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.ss.usermodel.Workbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.google.gson.Gson;

import foren.framework.lib.listop.ListOp;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.model.NavigatorInfo;
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.ObjUtils;
import foren.framework.web.view.FileDownloadInfo;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.modules.com.combo.ComboServiceImpl;
import foren.unilite.modules.human.HumanCommonServiceImpl;

@Controller
public class HrtController extends UniliteCommonController {

	private final Logger	logger		= LoggerFactory.getLogger(this.getClass());

	final static String		JSP_PATH	= "/human/hrt/";
	
	@Resource( name = "humanCommonService" )
    private HumanCommonServiceImpl humanCommonService;
	@Resource(name="UniliteComboServiceImpl")
	private ComboServiceImpl comboService;
	
	@Resource(name="hrt300ukrService")
	private Hrt300ukrServiceImpl hrt300ukrService;

	@Resource(name="hrt700ukrService")
	private Hrt700ukrServiceImpl hrt700ukrService;

//	@Resource(name="hrt700skrService")
//	private Hrt700skrServiceImpl hrt700skrService;
	
	@Resource(name="hrt800ukrService")
	private Hrt800ukrServiceImpl hrt800ukrService;
	
	@Resource(name="hrt110ukrService")
	private Hrt110ukrServiceImpl hrt110ukrService;
	
	@Resource(name="hrt501ukrService")
	private Hrt501ukrServiceImpl hrt501ukrService;
	
	@Resource(name="hrt506ukrService")
	private Hrt506ukrServiceImpl hrt506ukrService;
	
	@Resource(name="hrt502ukrService")
	private Hrt502ukrServiceImpl hrt502ukrService;
	
	@Resource(name="hrtExcelService")
	private HrtExcelServiceImpl hrtExcelService;
	
	
	@RequestMapping(value = "/human/hrt700skr.do")
	public String hrt700skr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
//		final String[] searchFields = {  };
//		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
//		LoginVO session = _req.getSession();
//		Map<String, Object> param = navigator.getParam();
//		String page = _req.getP("page");
//		
//		param.put("S_COMP_CODE",loginVO.getCompCode());
//		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));  
//		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));   
//		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param)); 
//		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
		
		return JSP_PATH + "hrt700skr";
	}

	@RequestMapping(value = "/human/hrt110ukr.do")
	public String hrt110ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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
		
		return JSP_PATH + "hrt110ukr";
	}
	
	@RequestMapping(value = "/human/hrt800ukr.do")
	public String hrt800ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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
		
		return JSP_PATH + "hrt800ukr";
	}
	
	@RequestMapping(value = "/human/hrt300ukr.do")
	public String hrt300ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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
		
		return JSP_PATH + "hrt300ukr";
	}
	
	@RequestMapping(value = "/human/hrt501ukr.do")
	public String hrt501ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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
		
		return JSP_PATH + "hrt501ukr";
	}
	
	@RequestMapping(value = "/human/hrt506ukr.do")
	public String hrt506ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		//그룹웨어 사용여부
        Map param = new HashMap();
        param.put("S_COMP_CODE", loginVO.getCompCode());
        Map gsGWUseYN = (Map)humanCommonService.fnGWUseYN(param);
        
        if (gsGWUseYN != null && gsGWUseYN.size() > 0) {
        	model.addAttribute("gsGWUseYN", gsGWUseYN.get("SUB_CODE"));
        } else {
        	model.addAttribute("gsGWUseYN", "00");
        	
        }

        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = codeInfo.getCodeInfo("B609", "GW_URL");
        if(!ObjUtils.isEmpty(cdo))
        	model.addAttribute("groupUrl", cdo.getCodeName());
        else
        	model.addAttribute("groupUrl", "about:blank");

		return JSP_PATH + "hrt506ukr";
	}
	
	@RequestMapping(value = "/human/hrt502ukr.do")
	public String hrt502ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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
		
		return JSP_PATH + "hrt502ukr";
	}
	
	@RequestMapping(value = "/human/hrt507ukr.do")
	public String hrt507ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		return JSP_PATH + "hrt507ukr";
	}
	
	@RequestMapping(value="/human/hrt510rkr.do")
	public String hrt510rkr(ExtHtttprequestParam _req,LoginVO loginVO, ListOp listOp, ModelMap model)throws Exception{
		//S_COMP_CODE 가져오기
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE",loginVO.getCompCode());

		//20200730 추가: 리포트 프로그램 설정값 가져오기(크리스탈,jasper 또는 ClipReport)
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		List<CodeDetailVO> gsReportGubun = codeInfo.getCodeList("H184", "", false);
		for(CodeDetailVO map : gsReportGubun) {
			if("hrt510rkr".equals(map.getCodeName())) {
				model.addAttribute("gsReportGubun", map.getRefCode10());
			}
		}
		return JSP_PATH + "hrt510rkr";
	}


	/**
	 * 퇴직연금계산 (hrt700ukr) - 20200324 신규 등록
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/human/hrt700ukr.do")
	public String hrt700ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();
		param.put("S_COMP_CODE",loginVO.getCompCode());

		Gson gson = new Gson();
		String colData = gson.toJson(hrt700ukrService.selectColumns(param));
		model.addAttribute("colData", colData);

		return JSP_PATH + "hrt700ukr";
	}

	/**
	 * 퇴직연금조회 (hrt710skr) - 20200326 신규 등록
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/human/hrt710skr.do")
	public String hrt710skr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();
		param.put("S_COMP_CODE",loginVO.getCompCode());

		return JSP_PATH + "hrt710skr";
	}


	@RequestMapping(value = "/human/hrt730rkr.do")
	public String hrt730rkr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
				
		return JSP_PATH + "hrt730rkr";
	}
	/**
	 * 퇴직추계액 프로시져
	 */
//	@RequestMapping(value = "/human/hrt300proc.do")
//	public ModelAndView hrt300ukr(@RequestParam Map<String, String> param, LoginVO loginVO) throws Exception {				
//		Map result = hrt300ukrService.procHrt300(param, loginVO);		
//		return ViewHelper.getJsonView(result);
//	}
	
	/**
	 *  퇴직소득 전산 매체 신고 파일 생성
	 * @param param
	 * @param loginVO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/human/createRetireFile.do")
	public ModelAndView hrt800ukr(ExtHtttprequestParam _req, LoginVO user) throws Exception {
		Map param = _req.getParameterMap();
		FileDownloadInfo fInfo = null;
		Integer calYear = Integer.parseInt(ObjUtils.getSafeString(param.get("CAL_YEAR")));
		
		if (calYear <= 2019) {
			fInfo = hrt800ukrService.doBatch(param);
		}
		else {
			fInfo = hrt800ukrService.doBatch2020(param, user);
		}
		logger.debug("download File Info : "+ fInfo.getPath());
		
	    return ViewHelper.getFileDownloadView(fInfo);
	}
	
	/**
	 * 계산식을 저장함
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/human/hrt110ukrInsertCalcSentence.do")
	public ModelAndView hbs020ukrInsertCalcSentence(@RequestParam String data, LoginVO user) throws Exception {
		
		Object rv = hrt110ukrService.insertList04(data, user);
		return ViewHelper.getJsonView(rv);
	}
	
	private Object getMessage(String string, LoginVO user) {
		// TODO Auto-generated method stub
		return null;
	}

	/**
	 * 사번으로 임원/직원을 구분함
	 * @param param
	 * @param loginVO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/human/checkRetrOTKind.do")
	public ModelAndView checkRetroOTKind(@RequestParam Map<String, String> param, LoginVO loginVO) throws Exception {
		param.put("S_COMP_CODE", loginVO.getCompCode());
		Map result = hrt501ukrService.checkRetroOTKind(param);
		return ViewHelper.getJsonView(result);
	}
	
	/**
	 * 지급총액 계산
	 * @param param
	 * @param loginVO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/human/fnSuppTotI.do")
	public ModelAndView fnRetireProcSTChangedSuppTotal(@RequestParam Map<String, String> param, LoginVO loginVO) throws Exception {
		param.put("S_USER_ID", loginVO.getUserID());
		Map result = hrt501ukrService.fnSuppTotI(param);
		return ViewHelper.getJsonView(result);
	}
	
	/**
	 * 지급총액 계산
	 * @param param
	 * @param loginVO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/human/fnSuppTotI502.do")
	public ModelAndView fnRetireProcSTChangedSuppTotal502(@RequestParam Map<String, String> param, LoginVO loginVO) throws Exception {
		param.put("S_USER_ID", loginVO.getUserID());
		Map result = hrt502ukrService.fnSuppTotI(param);
		return ViewHelper.getJsonView(result);
	}
	
	/**
	 * 지급총액 계산
	 * @param param
	 * @param loginVO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/human/fnDateChanged.do")
	public ModelAndView fnDateChanged(@RequestParam Map<String, String> param, LoginVO loginVO) throws Exception {
		param.put("S_USER_ID", loginVO.getUserID());
		Map result = hrt502ukrService.fnDateChanged(param);
		return ViewHelper.getJsonView(result);
	}
	
	/**
     * 퇴직금 재정산
     * @param param
     * @param loginVO
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/human/retireProcStChangedSuppTotal.do")
    public ModelAndView retireProcStChangedSuppTotal(@RequestParam Map<String, String> param, LoginVO loginVO) throws Exception {
        param.put("S_COMP_CODE", loginVO.getCompCode());
        param.put("S_LANG_CODE", loginVO.getLanguage());
        param.put("S_USER_ID", loginVO.getUserID());
        Map result = hrt506ukrService.retireProcStChangedSuppTotal(param, loginVO);
        return ViewHelper.getJsonView(result);
    }
    
    /**
     * 퇴직금 계산
     * @param param
     * @param loginVO
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/human/ProcSt.do")
    public ModelAndView ProcSt(@RequestParam Map<String, String> param, LoginVO loginVO) throws Exception {
        param.put("S_COMP_CODE", loginVO.getCompCode());
        param.put("S_LANG_CODE", loginVO.getLanguage());
        param.put("S_USER_ID", loginVO.getUserID());
        Map result = hrt506ukrService.ProcSt(param, loginVO);
        return ViewHelper.getJsonView(result);
    }
    
    
    /**
     * 퇴직금 소득영수증(2016년 이후)
     * 
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/human/hrt716rkr.do" )
    public String hrt716rkr() throws Exception {
        return JSP_PATH + "hrt716rkr";
    }
    
	@ResponseBody
	@RequestMapping(value = "/human/hrt716rkrExcelDown.do")
	public ModelAndView hrt716rkrDownLoadExcel(ExtHtttprequestParam _req, HttpServletResponse response) throws Exception{	

		Map<String, Object> paramMap = _req.getParameterMap();
		Workbook wb = hrtExcelService.makeExcel(paramMap);
        String title = "퇴직소득 원천징수영수증";
        
        return ViewHelper.getExcelDownloadView(wb, title);
	}
	
	
	/**
	 * 퇴직연금수당
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/human/hrt900ukr.do")
	public String hrt900ukr(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();		
			
		return JSP_PATH + "hrt900ukr";
	}	
}
