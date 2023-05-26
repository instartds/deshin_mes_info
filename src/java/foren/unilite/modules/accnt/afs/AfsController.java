package foren.unilite.modules.accnt.afs;

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
import foren.unilite.modules.accnt.afs.Afs100ukrServiceImpl;

/**
 *    프로그램명 : 자금관리
 *    작  성  자 : (주)포렌 개발실
 */
@Controller
public class AfsController extends UniliteCommonController {
	
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	final static String JSP_PATH = "/accnt/afs/";

	@Resource(name="accntCommonService")
	private AccntCommonServiceImpl accntCommonService;
	
	@Resource(name="afs100ukrService")
	private Afs100ukrServiceImpl afs100ukrService;

	/**
	 * 통장정보등록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/afs100ukr.do",method = RequestMethod.GET)
	public String afs100ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		
		param.put("S_COMP_CODE",loginVO.getCompCode());
		param.put("PGM_ID", "afs100ukr_01");
		param.put("SHEET_ID", "grdSheet1");
		List<Map<String, Object>> getChargeCode = accntCommonService.fnGetChargeCode(param, loginVO);		// ChargeCode관련			
		model.addAttribute("getChargeCode",ObjUtils.toJsonStr(getChargeCode));
		
		List<Map<String, Object>> useColList = accntCommonService.getUseColList(param);		//프로그램별 사용 컬럼 관련			
		model.addAttribute("useColList",ObjUtils.toJsonStr(useColList));	
		
		List<CodeDetailVO> gsMoneyUnit = codeInfo.getCodeList("B004", "", false);			// 자사 화폐단위
		for(CodeDetailVO map : gsMoneyUnit)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsMoneyUnit", map.getCodeNo());
			}
		}

		return JSP_PATH + "afs100ukr";
	}
	
	/**
	 * 구매카드등록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/afs200ukr.do",method = RequestMethod.GET)
	public String afs200ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE",loginVO.getCompCode());
		
//		param.put("PGM_ID", "afs100ukr_01");
//		param.put("SHEET_ID", "grdSheet1");
		List<Map<String, Object>> getChargeCode = accntCommonService.fnGetChargeCode(param, loginVO);		// ChargeCode관련			
		model.addAttribute("getChargeCode",ObjUtils.toJsonStr(getChargeCode));
		
		List<Map<String, Object>> useColList = accntCommonService.getUseColList(param);		//프로그램별 사용 컬럼 관련			
		model.addAttribute("useColList",ObjUtils.toJsonStr(useColList));	
		
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		return JSP_PATH + "afs200ukr";
	}
	
	/**
	 * 예적금현황조회
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/accnt/afs510skr.do")
	public String afs510skr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model)throws Exception{
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);		//당기시작년월		
		model.addAttribute("getStDt",ObjUtils.toJsonStr(getStDt));
		
		List<Map<String, Object>> getChargeCode = accntCommonService.fnGetChargeCode(param, loginVO);		// ChargeCode관련			
		model.addAttribute("getChargeCode",ObjUtils.toJsonStr(getChargeCode));	

		boolean isKDG = false;
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		List<CodeDetailVO> gsSiteGubun = codeInfo.getCodeList("B259", "", false);		//모듈별 출력 설정에서 ClipReport추가로 인한 리포트 프로그램 설정값 가져오기(크리스탈,jasper 또는 ClipReport)
		for(CodeDetailVO map : gsSiteGubun)	{
			if("KDG".equals(map.getCodeName()))	{
				isKDG = true;
			}
		}
		
		if (isKDG) {
			model.addAttribute("exSlipPgmID", "agj205ukr");
		} else {
			model.addAttribute("exSlipPgmID", "agj200ukr");
		}
		
		return JSP_PATH+"afs510skr";
	}
	/**
	 * 예적금현황조회
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/accnt/afs510rkr.do")
	public String afs510rkr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model)throws Exception{
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);		//당기시작년월		
		model.addAttribute("getStDt",ObjUtils.toJsonStr(getStDt));
		
		List<Map<String, Object>> getChargeCode = accntCommonService.fnGetChargeCode(param, loginVO);		// ChargeCode관련			
		model.addAttribute("getChargeCode",ObjUtils.toJsonStr(getChargeCode));	

		return JSP_PATH+"afs510rkr";
	}
	
	/**
	 * 계좌잔액조회
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/accnt/afs520skr.do")
	public String afs520skr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model)throws Exception{
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);		//당기시작년월		
		model.addAttribute("getStDt",ObjUtils.toJsonStr(getStDt));
		
		List<Map<String, Object>> getChargeCode = accntCommonService.fnGetChargeCode(param, loginVO);		// ChargeCode관련			
		model.addAttribute("getChargeCode",ObjUtils.toJsonStr(getChargeCode));	
		
		return JSP_PATH+"afs520skr"; 
	}
	
	@RequestMapping(value="/accnt/afs520rkr.do")
	public String afs520rkr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model)throws Exception{
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);		//당기시작년월		
		model.addAttribute("getStDt",ObjUtils.toJsonStr(getStDt));
		
		List<Map<String, Object>> getChargeCode = accntCommonService.fnGetChargeCode(param, loginVO);		// ChargeCode관련			
		model.addAttribute("getChargeCode",ObjUtils.toJsonStr(getChargeCode));	
		
		return JSP_PATH+"afs520rkr"; 
	}
	
	/**
     * 예차입금현황조회
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/accnt/afs530skr.do")
    public String afs530skr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model)throws Exception{
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);        //당기시작년월        
        model.addAttribute("getStDt",ObjUtils.toJsonStr(getStDt));
        
        List<Map<String, Object>> getChargeCode = accntCommonService.fnGetChargeCode(param, loginVO);       // ChargeCode관련         
        model.addAttribute("getChargeCode",ObjUtils.toJsonStr(getChargeCode));  
        
        return JSP_PATH+"afs530skr";
    }

}
