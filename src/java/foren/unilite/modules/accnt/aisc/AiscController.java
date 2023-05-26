package foren.unilite.modules.accnt.aisc;

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
public class AiscController extends UniliteCommonController {

	@Resource(name="accntCommonService")
	private AccntCommonServiceImpl accntCommonService;
	
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	final static String JSP_PATH = "/accnt/aisc/";

	/* 감가상각계산 및 자동기표	
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/aisc100ukrv.do")
	public String aisc100ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		return JSP_PATH + "aisc100ukrv";
	}
	
	/* 감가상각비명세서
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/aisc105skrv.do")
	public String aisc105skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		List<Map<String, Object>> getAccntBasicInfo = accntCommonService.fnGetAccntBasicInfo(param, loginVO);				
		if(getAccntBasicInfo != null && ObjUtils.isNotEmpty(getAccntBasicInfo.get(0).get("GOV_GRANT_CONT"))) {
			model.addAttribute("gsGovGrandCont", getAccntBasicInfo.get(0).get("GOV_GRANT_CONT"));
		}else{
			model.addAttribute("gsGovGrandCont", "2");
		}
		
		return JSP_PATH + "aisc105skrv";
	}

	/** 감가상각비명세서 2
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/accnt/aisc106skrv.do")
    public String aisc106skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

        List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);        //당기시작년월, 상각년월
        model.addAttribute("getStDt",ObjUtils.toJsonStr(getStDt));  

        return JSP_PATH + "aisc106skrv";
    }
	/* 감가상각비상세내역조회
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/aisc110skrv.do")
	public String aisc110skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		List<Map<String, Object>> getAccntBasicInfo = accntCommonService.fnGetAccntBasicInfo(param, loginVO);				
		if(getAccntBasicInfo != null && ObjUtils.isNotEmpty(getAccntBasicInfo.get(0).get("GOV_GRANT_CONT"))) {
			model.addAttribute("gsGovGrandCont", getAccntBasicInfo.get(0).get("GOV_GRANT_CONT"));
		}else{
			model.addAttribute("gsGovGrandCont", "2");
		}
		return JSP_PATH + "aisc110skrv";
	}

	/* 월별감가상각현황조회
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/aisc115skrv.do")
	public String aisc115skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		List<Map<String, Object>> getAccntBasicInfo = accntCommonService.fnGetAccntBasicInfo(param, loginVO);				
		if(getAccntBasicInfo != null && ObjUtils.isNotEmpty(getAccntBasicInfo.get(0).get("GOV_GRANT_CONT"))) {
			model.addAttribute("gsGovGrandCont", getAccntBasicInfo.get(0).get("GOV_GRANT_CONT"));
		}else{
			model.addAttribute("gsGovGrandCont", "2");
		}
		
		return JSP_PATH + "aisc115skrv";
	}
	/* 감가상각비집계표
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/aisc125skrv.do")
	public String aisc125skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		//param에 COMP_CODE 정보 추가
		param.put("S_COMP_CODE",loginVO.getCompCode());

		List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);		//당기시작년월, 상각년월		
		model.addAttribute("getStDt",ObjUtils.toJsonStr(getStDt));	

		return JSP_PATH + "aisc125skrv";
	}
	/** 감가상각비집계표 2
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/accnt/aisc126skrv.do")
    public String aisc126skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        //param에 COMP_CODE 정보 추가
        param.put("S_COMP_CODE",loginVO.getCompCode());

        List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);        //당기시작년월, 상각년월      
        model.addAttribute("getStDt",ObjUtils.toJsonStr(getStDt));  

        return JSP_PATH + "aisc126skrv";
    }
	/**
	 * 감가상각 계산
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/accnt/aisc100ukr.do")
	public String aisc100ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model)throws Exception{
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
		return JSP_PATH+"aisc100ukr";
	}
	
}
