package foren.unilite.modules.accnt.aiss;

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
public class AissController extends UniliteCommonController {
	
	@Resource(name="UniliteComboServiceImpl")
	private ComboServiceImpl comboService;
	
	
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	final static String JSP_PATH = "/accnt/aiss/";
	
	@Resource(name="accntCommonService")
	private AccntCommonServiceImpl accntCommonService;
	 
	/**
	 * 회계 IFRS - 자산정보엑셀업로드
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/accnt/aiss310ukrv.do")
	public String aiss310ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);		//당기시작년월
		model.addAttribute("getStDt",ObjUtils.toJsonStr(getStDt));	
		
		//ChargeCode 가져오기
		List<Map<String, Object>> getChargeCode = accntCommonService.fnGetChargeCode(param, loginVO);			
		if(getChargeCode.size() > 0){
			model.addAttribute("getChargeCode",getChargeCode.get(0).get("SUB_CODE"));
		}else{
			model.addAttribute("getChargeCode","");
		}
		
		return JSP_PATH + "aiss310ukrv";
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
	@RequestMapping(value="/accnt/aiss500skrv.do")
	public String aiss500skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);		//당기시작년월
		model.addAttribute("getStDt",ObjUtils.toJsonStr(getStDt));	
		//ChargeCode 가져오기
	
		List<Map<String, Object>> getChargeCode = accntCommonService.fnGetChargeCode(param, loginVO);
        if(getChargeCode == null){
            model.addAttribute("getChargeCode", "");
        }else{
            if(getChargeCode.get(0).get("SUB_CODE").equals("")){
                model.addAttribute("getChargeCode","");
            }else{
                if(getChargeCode.size() > 0){
                    model.addAttribute("getChargeCode",getChargeCode.get(0).get("SUB_CODE"));
                }else{
                    model.addAttribute("getChargeCode","");
                }
            }
        }
		
		
		return JSP_PATH+"aiss500skrv";
	}
	
	/** 자산정보등록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/aiss300ukrv.do")
	public String aiss300ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));  
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));   
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		model.addAttribute("costPoolCombo", comboService.getHumanCostPool(param));
		
		//ChargeCode 가져오기
		List<Map<String, Object>> getChargeCode = accntCommonService.fnGetChargeCode(param, loginVO);			
		if(getChargeCode.size() > 0){
			model.addAttribute("getChargeCode",getChargeCode.get(0).get("SUB_CODE"));
		}else{
			model.addAttribute("getChargeCode","");
		}	
		
		List<Map<String, Object>> getAccntBasicInfo = accntCommonService.fnGetAccntBasicInfo(param, loginVO);		// AMT_POINT 관련			
		model.addAttribute("getAccntBasicInfo",getAccntBasicInfo.get(0).get("AMT_POINT"));
		if(getAccntBasicInfo.get(0).get("ASST_AUTOCD").equals("1")){
			model.addAttribute("gsAutocd", "Y");
		}else{
			model.addAttribute("gsAutocd", "N");
		}
		
		if(getAccntBasicInfo != null && ObjUtils.isNotEmpty(getAccntBasicInfo.get(0).get("GOV_GRANT_CONT"))) {
			model.addAttribute("gsGovGrandCont", getAccntBasicInfo.get(0).get("GOV_GRANT_CONT"));
		}else{
			model.addAttribute("gsGovGrandCont", "2");
		}
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		
//		cdo = codeInfo.getCodeInfo("A151", "1");	//자산코드 자동채번(Y)/수동채번(N)
//		if(!ObjUtils.isEmpty(cdo)){
//			model.addAttribute("gsAutoType",cdo.getRefCode1());
//		}else {
//			model.addAttribute("gsAutoType", "N");
//		}
		
		int i = 0;
		List<CodeDetailVO> gsMoneyUnit = codeInfo.getCodeList("B004", "", false);	//자국화폐단위 정보		
		for(CodeDetailVO map : gsMoneyUnit)	{
			if("Y".equals(map.getRefCode1())){
				model.addAttribute("gsMoneyUnit", map.getCodeNo());
				i++;
			}			 
		}
		if(i == 0) model.addAttribute("gsMoneyUnit", "KRW");

		return JSP_PATH + "aiss300ukrv";
	}
	
	
	/**
	 * 회계 IFRS - 자산변동내역등록
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/accnt/aiss500ukrv.do")
	public String aiss500ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);		//당기시작년월
		model.addAttribute("getStDt",ObjUtils.toJsonStr(getStDt));	
		//ChargeCode 가져오기
		List<Map<String, Object>> getChargeCode = accntCommonService.fnGetChargeCode(param, loginVO);			
		if(getChargeCode.size() > 0){
			model.addAttribute("getChargeCode",getChargeCode.get(0).get("SUB_CODE"));
		}else{
			model.addAttribute("getChargeCode","");
		}
		
		/**
		 * 기본 셋팅 값 관련
		 */
		param.put("COL","AMT_POINT");
		Map fnGetAccntBasicInfo_aMap = (Map)accntCommonService.fnGetAccntBasicInfo_a(param);
		model.addAttribute("gsAmtPoint", fnGetAccntBasicInfo_aMap.get("OPTION"));
		
		
		return JSP_PATH+"aiss500ukrv";
	}
	
	/** 자산재평가등록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/aiss510ukrv.do")
	public String aiss510ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		return JSP_PATH + "aiss510ukrv";
	}

	/**
	 * 회계 IFRS - 자산손상등록
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/accnt/aiss520ukrv.do")
	public String aiss520ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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
		
		return JSP_PATH+"aiss520ukrv";
	}
	/**
	 * 회계 IFRS - 자산매각폐기일괄등록
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/accnt/aiss530ukrv.do")
	public String aiss530ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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
		
		return JSP_PATH+"aiss530ukrv";
	}
	/**
	 * 회계 IFRS - 자산대장조회
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/accnt/aiss300skrv.do")
	public String aiss300skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		List<Map<String, Object>> getChargeCode = accntCommonService.fnGetChargeCode(param, loginVO);
		if(getChargeCode == null){
			model.addAttribute("getChargeCode", "");
		}else{
			if(getChargeCode.get(0).get("SUB_CODE").equals("")){
				model.addAttribute("getChargeCode","");
			}else{
				if(getChargeCode.size() > 0){
					model.addAttribute("getChargeCode",getChargeCode.get(0).get("SUB_CODE"));
				}else{
					model.addAttribute("getChargeCode","");
				}
			}
		}

		List<Map<String, Object>> getAccntBasicInfo = accntCommonService.fnGetAccntBasicInfo(param, loginVO);				
		if(getAccntBasicInfo != null && ObjUtils.isNotEmpty(getAccntBasicInfo.get(0).get("GOV_GRANT_CONT"))) {
			model.addAttribute("gsGovGrandCont", getAccntBasicInfo.get(0).get("GOV_GRANT_CONT"));
		}else{
			model.addAttribute("gsGovGrandCont", "2");
		}
		return JSP_PATH+"aiss300skrv";
	}
}
