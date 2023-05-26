package foren.unilite.modules.accnt.aga;

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
import foren.unilite.modules.com.combo.ComboServiceImpl;

/**
 *    프로그램명 : 
 *    작  성  자 : (주)포렌 개발실
 */
@Controller
public class AgaController extends UniliteCommonController {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	final static String JSP_PATH = "/accnt/aga/";
 
	@Resource(name="accntCommonService")
	private AccntCommonServiceImpl accntCommonService;

	@Resource(name="UniliteComboServiceImpl")
	private ComboServiceImpl comboService;


	
	/**
	 * 고정자산취득자동기표 방법등록 (aga320ukr)
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/aga320ukr.do",method = RequestMethod.GET)
	public String aga320ukr(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);		//당기시작년월		
		model.addAttribute("getStDt",ObjUtils.toJsonStr(getStDt));
		
		List<Map<String, Object>> getChargeCode = accntCommonService.fnGetChargeCode(param, loginVO);		// ChargeCode관련			
		model.addAttribute("getChargeCode",ObjUtils.toJsonStr(getChargeCode));	

		return JSP_PATH + "aga320ukr";
	}

	/**
	 * 예산전용내역조회
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/aga340ukr.do",method = RequestMethod.GET)
	public String aga340ukr(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);		//당기시작년월		
		model.addAttribute("getStDt",ObjUtils.toJsonStr(getStDt));

		return JSP_PATH + "aga340ukr";
	}
	
	/**
	 * 지출결의자동기표 방법등록 (aga350ukr)
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/aga350ukr.do",method = RequestMethod.GET)
	public String aga350ukr(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);		//당기시작년월		
		model.addAttribute("getStDt",ObjUtils.toJsonStr(getStDt));
		
		List<Map<String, Object>> getChargeCode = accntCommonService.fnGetChargeCode(param, loginVO);		// ChargeCode관련			
		model.addAttribute("getChargeCode",ObjUtils.toJsonStr(getChargeCode));	

		return JSP_PATH + "aga350ukr";
	}
	
	/**
	 * 매출수금등자동기표 방법등록 (aga360ukr)
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/aga360ukr.do",method = RequestMethod.GET)
	public String aga360ukr(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);		//당기시작년월		
		model.addAttribute("getStDt",ObjUtils.toJsonStr(getStDt));

		model.addAttribute("COMBO_APP_TYPE"		, comboService.getApplication(param));  
		model.addAttribute("COMBO_GUBUN_1"		, comboService.getGubun1(param));   
		model.addAttribute("COMBO_GUBUN_2"		, comboService.getGubun2(param));   
		model.addAttribute("COMBO_GUBUN_3"		, comboService.getGubun3(param));   
		model.addAttribute("COMBO_GUBUN_4"		, comboService.getGubun4(param));   
		model.addAttribute("COMBO_GUBUN_5"		, comboService.getGubun5(param));   

		return JSP_PATH + "aga360ukr";
	}
	
    /**
     * 차입금/예적금자동기표방법등록
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/accnt/aga370ukr.do",method = RequestMethod.GET)
    public String aga370ukr(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);        //당기시작년월        
        model.addAttribute("getStDt",ObjUtils.toJsonStr(getStDt));

        return JSP_PATH + "aga370ukr";
    }
	
	/**
	 * 급여자동기표 방법등록 (aga320ukr)
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/aga380ukr.do",method = RequestMethod.GET)
	public String aga380ukr(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		//param.put("S_COMP_CODE",loginVO.getCompCode());

		List<Map<String, Object>> getChargeCode = accntCommonService.fnGetChargeCode(param, loginVO);		// ChargeCode관련			
		model.addAttribute("getChargeCode",ObjUtils.toJsonStr(getChargeCode));
		
		return JSP_PATH + "aga380ukr";
	}

	
	/**
	 * 인터페이스 항목 정의 (aga361ukr)
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/aga361ukr.do",method = RequestMethod.GET)
	public String aga361ukr(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		model.addAttribute("COMBO_APP_TYPE"		, comboService.getApplication(param));  
		model.addAttribute("COMBO_GUBUN_1"		, comboService.getGubun1(param));   
		model.addAttribute("COMBO_GUBUN_2"		, comboService.getGubun2(param));   
		model.addAttribute("COMBO_GUBUN_3"		, comboService.getGubun3(param));   
		model.addAttribute("COMBO_GUBUN_4"		, comboService.getGubun4(param));   
		model.addAttribute("COMBO_GUBUN_5"		, comboService.getGubun5(param));   

		return JSP_PATH + "aga361ukr";
	}
	
}