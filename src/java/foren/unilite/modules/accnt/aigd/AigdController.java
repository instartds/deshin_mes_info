package foren.unilite.modules.accnt.aigd;

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
import foren.unilite.modules.accnt.aba.Aba410ukrServiceImpl;
import foren.unilite.modules.accnt.ass.Ass100ukrServiceImpl;
import foren.unilite.modules.com.combo.ComboServiceImpl;


/**
 *    프로그램명 : IFRS 자산관리
 *    작  성  자 : (주)포렌 개발실
 */
@Controller
public class AigdController extends UniliteCommonController {
	
	@Resource(name="UniliteComboServiceImpl")
	private ComboServiceImpl comboService;
	
	
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	final static String JSP_PATH = "/accnt/aigd/";
	
	@Resource(name="accntCommonService")
	private AccntCommonServiceImpl accntCommonService;
	 
	
	/**
	 * 고정자산취득자동기표
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/aigd320ukrv.do")
	public String aigd320ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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
		
		return JSP_PATH + "aigd320ukrv";
	}
	
	/**
	 * 감가상각(IFRS) 자동기표
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/aigd330ukrv.do")
	public String aigd330ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        param.put("S_COMP_CODE",loginVO.getCompCode());
        List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);		//당기시작년월, 상각년월
        model.addAttribute("getStDt",ObjUtils.toJsonStr(getStDt));	
        
		return JSP_PATH + "aigd330ukrv";
	}
	/**
	 * 회계 IFRS - 자산변동내역조회
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/accnt/aigd340ukrv.do")
	public String aigd340ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);		//당기시작년월
		model.addAttribute("getStDt",ObjUtils.toJsonStr(getStDt));	
		
		//ChargeCode 가져오기
		List<Map<String, Object>> getChargeCode = accntCommonService.fnGetChargeCode(param, loginVO);		// ChargeCode관련			
		model.addAttribute("getChargeCode",ObjUtils.toJsonStr(getChargeCode));	
		
		return JSP_PATH+"aigd340ukrv";
	}
}
