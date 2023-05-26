package foren.unilite.modules.accnt.arc;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.type.TypeFactory;

import foren.framework.lib.listop.ListOp;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.model.NavigatorInfo;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.modules.accnt.AccntCommonServiceImpl;
import foren.unilite.com.UniliteCommonController;

@Controller
public class ArcController extends UniliteCommonController {
	
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	final static String JSP_PATH = "/accnt/arc/";
	
	@Resource(name="accntCommonService")
	private AccntCommonServiceImpl accntCommonService;
	

	/**
	 * 대행수수료 요율등록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/accnt/arc010ukr.do")
	public String arc010ukr(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		
		Map getPersonName = (Map)accntCommonService.getPersonName(param, loginVO);// 로그인 ID에 따른 사번 , 사원명 관련
//		model.addAttribute("personName", getPersonName.get("PERSON_NAME"));
		if(getPersonName == null){
            model.addAttribute("personName", "");
        }else{
            model.addAttribute("personName", getPersonName.get("PERSON_NAME"));
        }
		
		return JSP_PATH + "arc010ukr";
	}
	
	/**
	 * 채권관리 기준코드등록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/accnt/arc020ukr.do")
	public String arc020ukr(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		
		Map getPersonName = (Map)accntCommonService.getPersonName(param, loginVO);// 로그인 ID에 따른 사번 , 사원명 관련
//		model.addAttribute("personName", getPersonName.get("PERSON_NAME"));
		if(getPersonName == null){
            model.addAttribute("personName", "");
        }else{
            model.addAttribute("personName", getPersonName.get("PERSON_NAME"));
        }
		
		return JSP_PATH + "arc020ukr";
	}
	
	/**
     * 채권관리 월마감등록
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/accnt/arc030ukr.do")
    public String arc030ukr(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;

        return JSP_PATH + "arc030ukr";
    }
    
	
	/**
	 * 채권등록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/accnt/arc100ukr.do")
	public String arc100ukr(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		
		Map getPersonName = (Map)accntCommonService.getPersonName(param, loginVO);// 로그인 ID에 따른 사번 , 사원명 관련
//		model.addAttribute("personName", getPersonName.get("PERSON_NAME"));
		if(getPersonName == null){
            model.addAttribute("personName", "");
        }else{
            model.addAttribute("personName", getPersonName.get("PERSON_NAME"));
        }
		cdo = codeInfo.getCodeInfo("B609", "appv_popup_url");    //그룹웨어 결재 관련 팝업 url
        if(!ObjUtils.isEmpty(cdo)){
            model.addAttribute("appv_popup_url",cdo.getCodeName());
        }else {
            model.addAttribute("appv_popup_url", "");
        }
		return JSP_PATH + "arc100ukr";
	}

	/** 
	 * 채권내역조회
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/accnt/arc100skr.do")
	public String arc100skr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		
		List<Map<String, Object>> getChargeCode = accntCommonService.fnGetChargeCode(param, loginVO);		// ChargeCode관련			
		model.addAttribute("getChargeCode",ObjUtils.toJsonStr(getChargeCode));

		return JSP_PATH + "arc100skr";
	}
	
	
	/** 
	 * 채권접수
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/accnt/arc110ukr.do")
	public String arc110ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		
		List<Map<String, Object>> getChargeCode = accntCommonService.fnGetChargeCode(param, loginVO);		// ChargeCode관련			
		model.addAttribute("getChargeCode",ObjUtils.toJsonStr(getChargeCode));

		return JSP_PATH + "arc110ukr";
	}
	
	
	
	
	
	
	
	
	/**
	 * 법무채권등록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/accnt/arc200ukr.do")
	public String arc200ukr(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		
		List<Map<String, Object>> getChargeCode = accntCommonService.fnGetChargeCode(param, loginVO);		// ChargeCode관련			
		model.addAttribute("getChargeCode",ObjUtils.toJsonStr(getChargeCode));
		
		Map getPersonName = (Map)accntCommonService.getPersonName(param, loginVO);// 로그인 ID에 따른 사번 , 사원명 관련
//      model.addAttribute("personName", getPersonName.get("PERSON_NAME"));
        if(getPersonName == null){
            model.addAttribute("personName", "");
        }else{
            model.addAttribute("personName", getPersonName.get("PERSON_NAME"));
        }
		
		return JSP_PATH + "arc200ukr";
	}
	
	
	/** 
     * 법무채권내역조회
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/accnt/arc200skr.do")
    public String arc200skr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE",loginVO.getCompCode());
        
        List<Map<String, Object>> getChargeCode = accntCommonService.fnGetChargeCode(param, loginVO);       // ChargeCode관련         
        model.addAttribute("getChargeCode",ObjUtils.toJsonStr(getChargeCode));

        return JSP_PATH + "arc200skr";
    }
    
    /**
     * 관리일지/수금등록
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/accnt/arc210ukr.do")
    public String arc210ukr(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;
        
        List<Map<String, Object>> getChargeCode = accntCommonService.fnGetChargeCode(param, loginVO);       // ChargeCode관련         
        model.addAttribute("getChargeCode",ObjUtils.toJsonStr(getChargeCode));
        
        return JSP_PATH + "arc210ukr";
    }
    /** 
     * 법무채권 건별현황
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/accnt/arc210skr.do")
    public String arc210skr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE",loginVO.getCompCode());
        
        List<Map<String, Object>> getChargeCode = accntCommonService.fnGetChargeCode(param, loginVO);       // ChargeCode관련         
        model.addAttribute("getChargeCode",ObjUtils.toJsonStr(getChargeCode));

        return JSP_PATH + "arc210skr";
    }
    /** 
     * 법무채권 원장조회
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/accnt/arc220skr.do")
    public String arc220skr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE",loginVO.getCompCode());
        
        List<Map<String, Object>> getChargeCode = accntCommonService.fnGetChargeCode(param, loginVO);       // ChargeCode관련         
        model.addAttribute("getChargeCode",ObjUtils.toJsonStr(getChargeCode));

        return JSP_PATH + "arc220skr";
    }
    /** 
     * 법무채권 총괄표
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/accnt/arc230skr.do")
    public String arc230skr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE",loginVO.getCompCode());
        
        List<Map<String, Object>> getChargeCode = accntCommonService.fnGetChargeCode(param, loginVO);       // ChargeCode관련         
        model.addAttribute("getChargeCode",ObjUtils.toJsonStr(getChargeCode));

        return JSP_PATH + "arc230skr";
    }
    /**
     * 비용청구등록
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/accnt/arc300ukr.do")
    public String arc300ukr(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;
        
        List<Map<String, Object>> getChargeCode = accntCommonService.fnGetChargeCode(param, loginVO);       // ChargeCode관련         
        model.addAttribute("getChargeCode",ObjUtils.toJsonStr(getChargeCode));
        
        return JSP_PATH + "arc300ukr";
    }
    /** 
     * 수수료청구등록
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/accnt/arc400ukr.do")
    public String arc400ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE",loginVO.getCompCode());
        
        List<Map<String, Object>> getChargeCode = accntCommonService.fnGetChargeCode(param, loginVO);       // ChargeCode관련         
        model.addAttribute("getChargeCode",ObjUtils.toJsonStr(getChargeCode));

        return JSP_PATH + "arc400ukr";
    }
    /** 
     * 수수료청구자동기표
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/accnt/arc500ukr.do")
    public String arc500ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE",loginVO.getCompCode());
        
        List<Map<String, Object>> getChargeCode = accntCommonService.fnGetChargeCode(param, loginVO);       // ChargeCode관련         
        model.addAttribute("getChargeCode",ObjUtils.toJsonStr(getChargeCode));

        return JSP_PATH + "arc500ukr";
    }
    
    
    
}