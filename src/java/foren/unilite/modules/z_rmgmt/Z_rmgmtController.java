package foren.unilite.modules.z_rmgmt;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;

@Controller
public class Z_rmgmtController extends UniliteCommonController {

	private final Logger logger = LoggerFactory.getLogger(this.getClass());
    final static String JSP_PATH = "/z_rmgmt/";
	
    @Resource(name="z_rmgmtService")
    Z_rmgmtServiceImpl z_rmgmtService;
    
    /**
     * 제조이력 조회 페이지 이동
     * */
    @RequestMapping(value = JSP_PATH + "main.do")
	public String main(Model model, LoginVO loginVO, @RequestParam Map param) throws Exception {
    	CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
    	CodeDetailVO cdo = null;

    	Map baseInfoParam = new HashMap();
    	baseInfoParam.put("S_COMP_CODE", loginVO.getCompCode());
    	
    	baseInfoParam.put("MAIN_CODE", "Z011");
    	List lZ011 = z_rmgmtService.selectCommInfo(baseInfoParam); //Mixer RPM코드
    	baseInfoParam.put("MAIN_CODE", "Z012");
    	List lZ012 = z_rmgmtService.selectCommInfo(baseInfoParam); //Mixer Time코드
    	baseInfoParam.put("MAIN_CODE", "Z013");
    	List lZ013 = z_rmgmtService.selectCommInfo(baseInfoParam); //분쇄도
    	baseInfoParam.put("MAIN_CODE", "Z014");
    	List lZ014 = z_rmgmtService.selectCommInfo(baseInfoParam); //공정차수
    	baseInfoParam.put("MAIN_CODE", "B140");
    	List lB140 = z_rmgmtService.selectCommInfo(baseInfoParam); //공정그룹
    	
    	
    	baseInfoParam.put("MAIN_CODE", "P505");
    	baseInfoParam.put("REF_CODE1", "02");
    	baseInfoParam.put("REF_CODE2", "RMG");
    	List lP505 = z_rmgmtService.selectCommInfo(baseInfoParam); //펄
    	
    	List lEqp = z_rmgmtService.selectEquInfo(baseInfoParam); //장비(믹서) 정보 
    	
    	model.addAttribute("Z011", lZ011);
    	model.addAttribute("Z011J", ObjUtils.toJsonStr(lZ011));
    	model.addAttribute("Z012", lZ012);
    	model.addAttribute("Z012J", ObjUtils.toJsonStr(lZ012));
    	model.addAttribute("Z013", lZ013);
    	model.addAttribute("Z013J", ObjUtils.toJsonStr(lZ013));
    	model.addAttribute("Z014J", ObjUtils.toJsonStr(lZ014));
    	model.addAttribute("B140", lB140);
    	model.addAttribute("B140J", ObjUtils.toJsonStr(lB140));
    	model.addAttribute("P505", lP505);
    	model.addAttribute("EQU", lEqp);
    	
    	model.addAttribute("param2", ObjUtils.toJsonStr(param));
    	
    	return JSP_PATH + "rmgmt-main";
	}
    
    /**
     * 제조이력 조회 페이지 header 조회
     * */
	@RequestMapping(value = JSP_PATH + "getHeader.do")
	@ResponseBody
	public List getHeader(Model model, LoginVO loginVO, @RequestParam Map param) throws Exception {
		param.put("S_COMP_CODE", loginVO.getCompCode());
    	List lRtn = z_rmgmtService.selectHeaderInfo(param);
    	
		return lRtn;
	}
	
	/**
     * 제조이력 조회 페이지 Aside 조회
     * */
	@RequestMapping(value = JSP_PATH + "getAside.do")
	@ResponseBody
	public List getAside(Model model, LoginVO loginVO, @RequestParam Map param) throws Exception {
		param.put("S_COMP_CODE", loginVO.getCompCode());
    	List lRtn = z_rmgmtService.selectAsideInfo(param);
    	
    	
		return lRtn;
	}
	
	/**
     * 제조이력 조회 페이지 body 조회
     * */
	@RequestMapping(value = JSP_PATH + "getBody.do")
	@ResponseBody
	public Map getBody(Model model, LoginVO loginVO, @RequestParam Map param) throws Exception {
		param.put("S_COMP_CODE", loginVO.getCompCode());
    	Map mRtn = z_rmgmtService.selectBodyInfo(param, "barcode");
    	
		return mRtn;
	}
	
	/**
     * 팝업에서 확인 시 제조이력 조회 페이지 body 조회
     * */
	@RequestMapping(value = JSP_PATH + "getBodyToPopup.do")
	@ResponseBody
	public Map getBodyToPopup(Model model, LoginVO loginVO, @RequestParam Map param) throws Exception {
		param.put("S_COMP_CODE", loginVO.getCompCode());
    	Map mRtn = z_rmgmtService.selectBodyInfo(param, "popup");
    	
		return mRtn;
	}
	
	/**
     * 제조이력 조회
     * */
	@RequestMapping(value = "/z_rmgmt/selectProdHistory.do", method = RequestMethod.POST)
	public @ResponseBody ModelMap selectProdHistory(ExtHtttprequestParam _req) throws Exception{

    	ModelMap mm = new ModelMap();
		Map<String, Object> param = _req.getParameterMap();
		
		//제조이력 조회
		List<Map<String, Object>> prodHistoryData = z_rmgmtService.selectProdHistory(param);
		
		mm.addAttribute("prodHistoryList", prodHistoryData);
		
		return mm;
	}
	
	 /**
     * 공정차수, 원료이력 조회
     * */
	@RequestMapping(value = "/z_rmgmt/selectChildHistory.do", method = RequestMethod.POST)
	public @ResponseBody ModelMap selectChildHistory(ExtHtttprequestParam _req) throws Exception{
	
		ModelMap mm = new ModelMap();
	
		Map<String, Object> param = _req.getParameterMap();
		// 공정차수 조회
		List<Map<String, Object>> wkordNumData = z_rmgmtService.selectWkordNum(param);
		// 제조이력 중 해당 공정 원료조회
		List<Map<String, Object>> childHistoryData = z_rmgmtService.selectChildHistory(param);
		
		mm.addAttribute("wkordNumSeqList", wkordNumData);
		mm.addAttribute("childHistoryList", childHistoryData);
	
		return mm;
	}
	
	 /**
     * 내용물 변경이력 검색
     * */
    @RequestMapping(value = "/z_rmgmt/selectHistDetail.do")
    @ResponseBody
	public List<Map> selectRmgmtHistDetail(LoginVO loginVO, @RequestParam Map param) throws Exception {
    	param.put("S_COMP_CODE", loginVO.getCompCode());

		return z_rmgmtService.selectRmgmtHistDetail(param);
	}
    
    /**
     * 제조이력 저장.
     * */
    @RequestMapping(value = "/z_rmgmt/saveRmgmt.do")
    @ResponseBody
	public Map saveRmgmt(LoginVO loginVO, @RequestParam Map param) throws Exception {
    	
    	Map mRtn = new HashMap();
    	
    	try {
    		z_rmgmtService.insRmgmt(param, loginVO);
    		mRtn.put("status", true);
    		mRtn.put("msg", "저장되었습니다.");
		} catch (Exception e) {
			e.printStackTrace();
			mRtn.put("status", false);
			mRtn.put("msg", "저장에 실패하였습니다. \n 원인 : " + e.getMessage());
		}
    	
    	return mRtn;
	}
}

