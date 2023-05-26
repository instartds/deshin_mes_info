package foren.unilite.modules.accnt.asc;

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
import foren.unilite.modules.accnt.AccntCommonServiceImpl;


@Controller
public class AscController extends UniliteCommonController {

	@Resource(name="accntCommonService")
	private AccntCommonServiceImpl accntCommonService;
	
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	final static String JSP_PATH = "/accnt/asc/";

	/* 감가상각비명세서
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/asc105skr.do")
	public String asc105skr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);		//당기시작년월, 상각년월
		model.addAttribute("getStDt",ObjUtils.toJsonStr(getStDt));	

		return JSP_PATH + "asc105skr";
	}

	/* 감가상각비상세내역조회
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/asc110skr.do")
	public String asc110skr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		//param에 COMP_CODE 정보 추가
		param.put("S_COMP_CODE",loginVO.getCompCode());

		List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);		//당기시작년월, 상각년월		
		model.addAttribute("getStDt",ObjUtils.toJsonStr(getStDt));	

		return JSP_PATH + "asc110skr";
	}

	/* 감가상각비집계표
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/asc125skr.do")
	public String asc125skr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		//param에 COMP_CODE 정보 추가
		param.put("S_COMP_CODE",loginVO.getCompCode());

		List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);		//당기시작년월, 상각년월		
		model.addAttribute("getStDt",ObjUtils.toJsonStr(getStDt));	

		return JSP_PATH + "asc125skr";
	}
	
	/**
	 * 감가상각 계산
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/accnt/asc100ukr.do")
	public String asc100ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model)throws Exception{
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		List<Map<String, Object>> getChargeCode = accntCommonService.fnGetChargeCode(param, loginVO);	//CHARGE코드			
		if(getChargeCode.size() > 0){
			model.addAttribute("getChargeCode",getChargeCode.get(0).get("SUB_CODE"));
		}else{
			model.addAttribute("getChargeCode","");
		}
		
		List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);		//당기시작년월		
		model.addAttribute("getStDt",ObjUtils.toJsonStr(getStDt));
		return JSP_PATH+"asc100ukr";
	}
	
}
