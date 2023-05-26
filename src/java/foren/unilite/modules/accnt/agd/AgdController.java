package foren.unilite.modules.accnt.agd;

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

import foren.framework.lib.listop.ListOp;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.model.NavigatorInfo;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.modules.accnt.AccntCommonServiceImpl;

/**
 *    프로그램명 : 작업지시조정
 *    작  성  자 : (주)포렌 개발실
 */
@Controller
public class AgdController extends UniliteCommonController {
	
	@Resource(name="accntCommonService")
	private AccntCommonServiceImpl accntCommonService;

	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	final static String JSP_PATH = "/accnt/agd/";
 
	
	/* 급상여자동기표
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/agd100ukr.do")
	public String agd100ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		//param에 COMP_CODE 정보 추가
		param.put("S_COMP_CODE",loginVO.getCompCode());

		//ChargeCode 가져오기
		List<Map<String, Object>> getChargeCode = accntCommonService.fnGetChargeCode(param, loginVO);			
		model.addAttribute("getChargeCode",ObjUtils.toJsonStr(getChargeCode));	

		return JSP_PATH + "agd100ukr";
	}
	
	@RequestMapping(value="/accnt/agd110ukr.do")
	public String agd110ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		//param에 COMP_CODE 정보 추가
		param.put("S_COMP_CODE",loginVO.getCompCode());

		return JSP_PATH + "agd110ukr";
	}
	
	@RequestMapping(value = "/accnt/agd111ukr.do")
	public String agd111ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		//param에 COMP_CODE 정보 추가
		param.put("S_COMP_CODE",loginVO.getCompCode());

		//부가세 유형 콤보 가져오기(S024)
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		List<CodeDetailVO> gsList1 = codeInfo.getCodeList("S024", "", false);
		Object list1= "";
		for(CodeDetailVO map : gsList1)	{
			if(!"50".equals(map.getCodeNo()))	{
				if(list1.equals("")){
					list1 =  map.getCodeNo();
				}else{
					list1 = list1 + ";" + map.getCodeNo();
				}
			}
		}
		model.addAttribute("gsList1", list1);

		return JSP_PATH + "agd111ukr";
	}
	@RequestMapping(value = "/accnt/agd151ukr.do")
	public String agd115ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		return JSP_PATH + "agd151ukr";
	}
	@RequestMapping(value="/accnt/agd120ukr.do")
	public String agd120ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		//param에 COMP_CODE 정보 추가
		param.put("S_COMP_CODE",loginVO.getCompCode());

		return JSP_PATH + "agd120ukr";
	}
	
	@RequestMapping(value="/accnt/agd121ukr.do")
	public String agd121ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		//param에 COMP_CODE 정보 추가
		param.put("S_COMP_CODE",loginVO.getCompCode());

		return JSP_PATH + "agd121ukr";
	}
	
	@RequestMapping(value="/accnt/agd130ukr.do")
	public String agd130ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		//param에 COMP_CODE 정보 추가
		param.put("S_COMP_CODE",loginVO.getCompCode());

		return JSP_PATH + "agd130ukr";
	}
	
	@RequestMapping(value="/accnt/agd131ukr.do")
	public String agd131ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		//param에 COMP_CODE 정보 추가
		param.put("S_COMP_CODE",loginVO.getCompCode());

		return JSP_PATH + "agd131ukr";
	}
	
	@RequestMapping(value="/accnt/agd150ukr.do")
	public String agd150ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		//param에 COMP_CODE 정보 추가
		param.put("S_COMP_CODE",loginVO.getCompCode());

		return JSP_PATH + "agd150ukr";
	}

	@RequestMapping(value="/accnt/agd160ukr.do")
	public String agd160ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model)throws Exception{
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		List<Map<String, Object>> getChargeCode = accntCommonService.fnGetChargeCode(param, loginVO);		// ChargeCode관련			
		model.addAttribute("getChargeCode",ObjUtils.toJsonStr(getChargeCode));	
		
		return JSP_PATH+"agd160ukr";
	}
	
	@RequestMapping(value="/accnt/agd170ukr.do")
	public String agd170ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model)throws Exception{
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		List<Map<String, Object>> getChargeCode = accntCommonService.fnGetChargeCode(param, loginVO);		// ChargeCode관련			
		model.addAttribute("getChargeCode",ObjUtils.toJsonStr(getChargeCode));	
		
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode()); 

		List<CodeDetailVO> gsListA012 = codeInfo.getCodeList("A012", "", false);
		Object list1= "";
		for(CodeDetailVO map : gsListA012)	{
			if("2".equals(map.getRefCode1()))	{
				if(list1.equals("")){
				list1 =  map.getCodeNo();
				}else{
					list1 = list1 + ";" + map.getCodeNo();
				}
			}
		}
		model.addAttribute("gsListA012", list1);

		
		return JSP_PATH + "agd170ukr";
	}
	
	@RequestMapping(value="/accnt/agd200ukr.do")
	public String agd200ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		//param에 COMP_CODE 정보 추가
		param.put("S_COMP_CODE",loginVO.getCompCode());

		return JSP_PATH + "agd200ukr";
	}
	
	@RequestMapping(value="/accnt/agd210ukr.do")
	public String agd210ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		//param에 COMP_CODE 정보 추가
		param.put("S_COMP_CODE",loginVO.getCompCode());

		return JSP_PATH + "agd210ukr";
	}
	
	@RequestMapping(value="/accnt/agd230ukr.do")
	public String agd230ukr(	)throws Exception{
		return JSP_PATH+"agd230ukr";
	}
	
	@RequestMapping(value="/accnt/agd250ukr.do")
	public String agd250ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		//param에 COMP_CODE 정보 추가
		param.put("S_COMP_CODE",loginVO.getCompCode());

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode()); 
		List<CodeDetailVO> gsListB004 = codeInfo.getCodeList("B004", "", false);
		
		String roundPt = "0";
		for(CodeDetailVO map : gsListB004)	{
			if("Y".equals(map.getRefCode1()))	{
				roundPt = map.getRefCode2();
				if(roundPt == null || roundPt.equals("")) {
					roundPt = "0";
				}
			}
		}
		model.addAttribute("ROUND_POINT", roundPt);

		return JSP_PATH + "agd250ukr";
	}
	
	@RequestMapping(value="/accnt/agd260ukr.do")
	public String agd260ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		//param에 COMP_CODE 정보 추가
		param.put("S_COMP_CODE",loginVO.getCompCode());

		return JSP_PATH + "agd260ukr";
	}
	
	@RequestMapping(value="/accnt/agd330ukr.do")
	public String agd330ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		//param에 COMP_CODE 정보 추가
		param.put("S_COMP_CODE",loginVO.getCompCode());

		return JSP_PATH + "agd330ukr";
	}
	
	@RequestMapping(value="/accnt/agd335ukr.do")
	public String agd335ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		//param에 COMP_CODE 정보 추가
		param.put("S_COMP_CODE",loginVO.getCompCode());

		return JSP_PATH + "agd335ukr";
	}
	/**
	 * 고정자산취득자동기표
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/agd320ukr.do")
	public String agd320ukr(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		//param에 COMP_CODE 정보 추가
		param.put("S_COMP_CODE",loginVO.getCompCode());

		//ChargeCode 가져오기
		List<Map<String, Object>> getChargeCode = accntCommonService.fnGetChargeCode(param, loginVO);			
		if(getChargeCode.size() > 0){
			model.addAttribute("getChargeCode",getChargeCode.get(0).get("SUB_CODE"));
		}else{
			model.addAttribute("getChargeCode","");
		}	
		
		return JSP_PATH + "agd320ukr";
	}
	/**
	 * 자금이체자동기표
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/agd340ukr.do")
	public String agd340ukr(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		//param에 COMP_CODE 정보 추가
		param.put("S_COMP_CODE",loginVO.getCompCode());
		
		return JSP_PATH + "agd340ukr";
	}
	
	/**
	 * 비용->선급비용 대체자동기표 (agd390ukr)
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/accnt/agd390ukr.do")
	public String agd390ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model)throws Exception{
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode()); 
		
		List<Map<String, Object>> getChargeCode = accntCommonService.fnGetChargeCode(param, loginVO);		// ChargeCode관련			
		model.addAttribute("getChargeCode",ObjUtils.toJsonStr(getChargeCode));	
		
		return JSP_PATH + "agd390ukr";
	}
	
	
	/**
	 * 선급비용 -> 비용 대체자동기표 (agd400ukr)
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/accnt/agd400ukr.do")
	public String agd400ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model)throws Exception{
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode()); 

		List<Map<String, Object>> getChargeCode = accntCommonService.fnGetChargeCode(param, loginVO);		// ChargeCode관련			
		model.addAttribute("getChargeCode",ObjUtils.toJsonStr(getChargeCode));	
		
		return JSP_PATH + "agd400ukr";
	}

	
	/**
	 * 매출 -> 선수금 대체자동기표 (agd410ukr)
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/accnt/agd410ukr.do")
	public String agd410ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model)throws Exception{
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode()); 
		
		List<Map<String, Object>> getChargeCode = accntCommonService.fnGetChargeCode(param, loginVO);		// ChargeCode관련			
		model.addAttribute("getChargeCode",ObjUtils.toJsonStr(getChargeCode));	
		
		return JSP_PATH + "agd410ukr";
	}

	
	/**
	 * 선수금 -> 매출 대체자동기표 (agd420ukr)
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/accnt/agd420ukr.do")
	public String agd420ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model)throws Exception{
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode()); 
		
		List<Map<String, Object>> getChargeCode = accntCommonService.fnGetChargeCode(param, loginVO);		// ChargeCode관련			
		model.addAttribute("getChargeCode",ObjUtils.toJsonStr(getChargeCode));	
		
		return JSP_PATH + "agd420ukr";
	}

	/**
	 * 불공제원가산입자동기표 (agd430ukr)
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/accnt/agd430ukr.do")
	public String agd430ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model)throws Exception{
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode()); 
		
		List<Map<String, Object>> getChargeCode = accntCommonService.fnGetChargeCode(param, loginVO);		// ChargeCode관련			
		model.addAttribute("getChargeCode",ObjUtils.toJsonStr(getChargeCode));	
		
		return JSP_PATH + "agd430ukr";
	}

	/**
     * 전표생성용 인터페이스정보조회
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/accnt/agd360skr.do")
    public String agd360skr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");        
        
        param.put("S_COMP_CODE",loginVO.getCompCode());

        return JSP_PATH + "agd360skr";
    }
    

    /**
      * 차입금자동기표
     * @return
      * @throws Exception
      */
     @RequestMapping(value = "/accnt/agd370ukr.do")
     public String agd370ukr(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
         final String[] searchFields = {  };
         NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
         LoginVO session = _req.getSession();
         Map<String, Object> param = navigator.getParam();
         String page = _req.getP("page");

        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
         CodeDetailVO cdo = null;
         //param에 COMP_CODE 정보 추가
        param.put("S_COMP_CODE",loginVO.getCompCode());
        
         return JSP_PATH + "agd370ukr";
     }
     
     @RequestMapping(value="/accnt/agd440ukr.do")
     public String agd440ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
         final String[] searchFields = {  };
         NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
         LoginVO session = _req.getSession();
         Map<String, Object> param = navigator.getParam();
         String page = _req.getP("page");

         //param에 COMP_CODE 정보 추가
         param.put("S_COMP_CODE",loginVO.getCompCode());

         return JSP_PATH + "agd440ukr";
     }
     @RequestMapping(value="/accnt/agd441ukr.do")
     public String agd441ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
         final String[] searchFields = {  };
         NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
         LoginVO session = _req.getSession();
         Map<String, Object> param = navigator.getParam();
         String page = _req.getP("page");

         //param에 COMP_CODE 정보 추가
         param.put("S_COMP_CODE",loginVO.getCompCode());

         return JSP_PATH + "agd441ukr";
     }

     @RequestMapping(value="/accnt/agd500ukr.do")
     public String agd500ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
         final String[] searchFields = {  };
         NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
         LoginVO session = _req.getSession();
         Map<String, Object> param = navigator.getParam();
         String page = _req.getP("page");

         return JSP_PATH + "agd500ukr";
     }
     
}
