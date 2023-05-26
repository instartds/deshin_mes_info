package foren.unilite.modules.accnt.abh;

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
public class AbhController extends UniliteCommonController {
	
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	final static String JSP_PATH = "/accnt/abh/";
	
	@Resource(name="accntCommonService")
	private AccntCommonServiceImpl accntCommonService;
	
	@Resource(name="abh200ukrService")
	private Abh200ukrServiceImpl abh200ukrService;
	
	@Resource(name="abh201ukrService")
    private Abh201ukrServiceImpl abh201ukrService;
	
	@Resource(name="abh220ukrService")
    private Abh220ukrServiceImpl abh220ukrService;
	
	@Resource(name="abh222ukrService")
    private Abh222ukrServiceImpl abh222ukrService;	
	
	/**
	 * 이체지급자동기표방법등록(ABH010UKR)
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/accnt/abh010ukr.do")
	public String abh010ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());

		return JSP_PATH + "abh010ukr";
	}
	
	
	/**
	 * 이체지급자동기표방법등록(ABH020UKR)
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/accnt/abh020ukr.do")
	public String abh020ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());

		List<Map<String, Object>> getChargeCode = accntCommonService.fnGetChargeCode(param, loginVO);		// ChargeCode관련			
		model.addAttribute("getChargeCode",ObjUtils.toJsonStr(getChargeCode));

		return JSP_PATH + "abh020ukr";
	}

	/**
	 * 은행코드 MAPPING(ABH100UKR)
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/accnt/abh100ukr.do")
	public String abh100ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());

		return JSP_PATH + "abh100ukr";
	}

	/**
	 * 법인카드엑셀업로드/대사
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/accnt/abh610ukr.do")
	public String abh610ukr(	)throws Exception{
		return JSP_PATH+"abh610ukr";
	}		
		
	/**
	 * 이체지급등록_(정규)
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/abh200ukr.do",method = RequestMethod.GET)
	public String abh200ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE",loginVO.getCompCode());
	
		List<Map<String, Object>> getChargeCode = accntCommonService.fnGetChargeCode(param, loginVO);		// ChargeCode관련			
		model.addAttribute("getChargeCode",ObjUtils.toJsonStr(getChargeCode));
		
		Map mainAccount = (Map)abh200ukrService.fnGetMainAccount(param);

		if(mainAccount == null){
			model.addAttribute("gsSaveCode", "");
			model.addAttribute("gsSaveName", "");
			model.addAttribute("gsSaveAccount", "");
		}else{
			model.addAttribute("gsSaveCode", mainAccount.get("SAVE_CODE"));
			model.addAttribute("gsSaveName", mainAccount.get("SAVE_NAME"));
			model.addAttribute("gsSaveAccount", mainAccount.get("BANK_ACCOUNT"));
		}
		
		
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		
		
		return JSP_PATH + "abh200ukr";
	}
	/**
     * 이체지급등록_J
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/accnt/abh201ukr.do",method = RequestMethod.GET)
    public String abh201ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        param.put("S_COMP_CODE",loginVO.getCompCode());
    
        List<Map<String, Object>> getChargeCode = accntCommonService.fnGetChargeCode(param, loginVO);       // ChargeCode관련         
        model.addAttribute("getChargeCode",ObjUtils.toJsonStr(getChargeCode));
        
        Map mainAccount = (Map)abh201ukrService.fnGetMainAccount(param);

        if(mainAccount == null){
            model.addAttribute("gsSaveCode", "");
            model.addAttribute("gsSaveName", "");
            model.addAttribute("gsSaveAccount", "");
        }else{
            model.addAttribute("gsSaveCode", mainAccount.get("SAVE_CODE"));
            model.addAttribute("gsSaveName", mainAccount.get("SAVE_NAME"));
            model.addAttribute("gsSaveAccount", mainAccount.get("BANK_ACCOUNT"));
        }
        
        
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;

        
        
        return JSP_PATH + "abh201ukr";
    }
	/**
	 * 이체지급확정
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/accnt/abh220ukr.do")
	public String abh220ukr(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		
		List<Map<String, Object>> getChargeCode = accntCommonService.fnGetChargeCode(param, loginVO);		// ChargeCode관련			
		model.addAttribute("getChargeCode",ObjUtils.toJsonStr(getChargeCode));
		
		Map getCmsId = (Map)abh220ukrService.getCmsId(param);// CMS_ID 관련    
		
		if(!ObjUtils.isEmpty(getCmsId)){
		    model.addAttribute("getCmsId",getCmsId.get("CMS_ID"));
		}
		return JSP_PATH+"abh220ukr";
	}
	
	/**
	 * 이체지급대상등록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/accnt/abh222ukr.do")
	public String abh222ukr(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		
		return JSP_PATH+"abh222ukr";
	}	

	
	
	/** 
	 * 이체결과조회 (ABH230SKR)
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/accnt/abh230skr.do")
	public String abh230skr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		
		List<Map<String, Object>> getChargeCode = accntCommonService.fnGetChargeCode(param, loginVO);		// ChargeCode관련			
		model.addAttribute("getChargeCode",ObjUtils.toJsonStr(getChargeCode));

		return JSP_PATH + "abh230skr";
	}
	
	
	
	/**
	 * 이체자료 엑셀업로드
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/accnt/abh230ukr.do")
	public String abh230ukr(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		
		List<Map<String, Object>> getChargeCode = accntCommonService.fnGetChargeCode(param, loginVO);		// ChargeCode관련			
		model.addAttribute("getChargeCode",ObjUtils.toJsonStr(getChargeCode));
		
//		Map getCmsId = (Map)abh230ukrService.getCmsId(param);// CMS_ID 관련    
		
//		if(!ObjUtils.isEmpty(getCmsId)){
//		    model.addAttribute("getCmsId",getCmsId.get("CMS_ID"));
//		}
		return JSP_PATH+"abh230ukr";
	}

	
	
	/** 
	 * 입출거래내역(ABH300SKR)
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/accnt/abh300skr.do")
	public String abh300skr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		
		List<Map<String, Object>> getChargeCode = accntCommonService.fnGetChargeCode(param, loginVO);		// ChargeCode관련			
		model.addAttribute("getChargeCode",ObjUtils.toJsonStr(getChargeCode));

		return JSP_PATH + "abh300skr";
	}
	
	/**
	 * 가수금자동기표(ABH300UKR)
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/accnt/abh300ukr.do")
	public String abh300ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		
		List<Map<String, Object>> getChargeCode = accntCommonService.fnGetChargeCode(param, loginVO);		// ChargeCode관련			
		model.addAttribute("getChargeCode",ObjUtils.toJsonStr(getChargeCode));

		return JSP_PATH + "abh300ukr";
	}
	
	/**
	 * 자금집금내역등록(ABH800UKR)
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/accnt/abh800ukr.do")
	public String abh800ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		
		List<Map<String, Object>> getChargeCode = accntCommonService.fnGetChargeCode(param, loginVO);		// ChargeCode관련			
		model.addAttribute("getChargeCode",ObjUtils.toJsonStr(getChargeCode));

		return JSP_PATH + "abh800ukr";
	}
	
	/**
	 * 가상계좌내역조회(ABH900SKR)
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/accnt/abh900skr.do")
	public String abh900skr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		
		return JSP_PATH + "abh900skr";
	}
	
	/**
	 * 전자어음 가수금자동기표(ABH900UKR)
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/accnt/abh900ukr.do")
	public String abh900ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		
		List<Map<String, Object>> getChargeCode = accntCommonService.fnGetChargeCode(param, loginVO);		// ChargeCode관련			
		model.addAttribute("getChargeCode",ObjUtils.toJsonStr(getChargeCode));

		return JSP_PATH + "abh900ukr";
	}

}