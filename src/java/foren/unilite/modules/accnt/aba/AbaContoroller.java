package foren.unilite.modules.accnt.aba;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
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
import foren.unilite.com.tags.ComboItemModel;
import foren.unilite.modules.accnt.AccntCommonServiceImpl;
import foren.unilite.modules.com.combo.ComboServiceImpl;
import foren.unilite.modules.accnt.aba.aba060ukrsServiceImpl;
import foren.unilite.modules.accnt.agj.Agj100ukrServiceImpl;
import foren.unilite.modules.accnt.aiga.Aiga240ukrvServiceImpl;


@Controller
public class AbaContoroller extends UniliteCommonController {
	
	@Resource(name="UniliteComboServiceImpl")
	private ComboServiceImpl comboService;
	
	@Resource(name="aba410ukrService")
	private Aba410ukrServiceImpl aba410ukrService;
	
	@Resource(name="aba411ukrService")
	private Aba411ukrServiceImpl aba411ukrService;	

	@Resource(name="aba060ukrsService")
	private aba060ukrsServiceImpl aba060ukrsService;
	
	@Resource(name="accntCommonService")
	private AccntCommonServiceImpl accntCommonService;
	
	@Resource(name="agj100ukrService")
	private Agj100ukrServiceImpl agj100ukrService;

	@Resource(name="aiga240ukrvService")
	private Aiga240ukrvServiceImpl aiga240ukrvService;
	
	private final Logger	logger		= LoggerFactory.getLogger(this.getClass());

	final static String		JSP_PATH	= "/accnt/aba/";	
	
	/**
	 * 계정과목등록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/aba400ukr.do")
	public String aba400ukr(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("AC_ITEM_LIST", comboService.getAcItemList(param));
		return JSP_PATH + "aba400ukr";
	}
	
	/**
	 * 계정과목간편등록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/aba401ukr.do")
	public String aba401ukr(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("AC_ITEM_LIST", comboService.getAcItemList(param));
		return JSP_PATH + "aba401ukr";
	}	
	
	/**
	 * 계정상세등록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/aba410ukr.do")
	public String aba410ukr(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("PEND_LIST", aba410ukrService.getPendList(param));
		
		return JSP_PATH + "aba410ukr";
	}
	
	/**
	 * 예산계정관리
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/aba411ukr.do")
	public String aba411ukr(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("PEND_LIST", aba411ukrService.getPendList(param));
		
		return JSP_PATH + "aba411ukr";
	}	
	
	/**
	 * 관리항목등록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/aba200ukr.do")
	public String aba200ukr(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		return JSP_PATH + "aba200ukr";
	}
	
	/**
	 * 집계항목설정
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/aba130ukr.do")
	public String aba130ukr(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		
		
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		int i = 0;
		List<CodeDetailVO> gsGubun = codeInfo.getCodeList("A093", "", false);	//재무제표 양식차수 정보		
		for(CodeDetailVO map : gsGubun)	{
			if("Y".equals(map.getRefCode1())){
				model.addAttribute("gsGubun", map.getCodeNo());
				i++;
			}			 
		}
		if(i == 0) model.addAttribute("gsGubun", "");
		
		return JSP_PATH + "aba130ukr";
	}
	
	/**
	 * 시산표설정
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/aba035ukr.do")
	public String aba035ukr(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		int i = 0;
		List<CodeDetailVO> gsGubun = codeInfo.getCodeList("A093", "", false);	//재무제표 양식차수 정보		
		for(CodeDetailVO map : gsGubun)	{
			if("Y".equals(map.getRefCode1())){
				model.addAttribute("gsGubun", map.getCodeNo());
				i++;
			}			 
		}
		if(i == 0) model.addAttribute("gsGubun", "");
		
		return JSP_PATH + "aba035ukr";
	}
	
	/**
	 * 기준코드등록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/aba050ukr.do")
	public String aba050ukr(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE",loginVO.getCompCode());
		
		// 콤보 가져오기 
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
				
		// LIST로 담아서 리턴
		List<CodeDetailVO> gsList = codeInfo.getCodeList("A054", "", false);
		Object list= "";
		for(CodeDetailVO map : gsList)	{
			if("A".equals(map.getRefCode1()))	{
				if(list.equals("")){
					list =  map.getCodeNo();
				}else{
					list = list + ";" + map.getCodeNo();
				}
			}
		}
		model.addAttribute("gsList", list);	

		return JSP_PATH + "aba050ukr";
	}
	
	/**
	 * 회계업무 설정
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/aba060ukr.do")
	public String aba060ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model)throws Exception{
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE",loginVO.getCompCode());
		
		List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);		//당기시작년월		
		model.addAttribute("getStDt",ObjUtils.toJsonStr(getStDt));	

		List<Map<String, Object>> getChargeCode = accntCommonService.fnGetChargeCode(param, loginVO);		// ChargeCode관련			
		model.addAttribute("getChargeCode",ObjUtils.toJsonStr(getChargeCode));
		
		
		param.put("Z0", 1);
		model.addAttribute("AC_ITEM_COMBO", comboService.getAcItemCombo(param));
		
		
		param.put("Z0", 1);
		param.put("Z1", 2);
		model.addAttribute("AC_ITEM_COMBO2", comboService.getAcItemCombo(param));
		
		Map<String, Object> reqParam = _req.getParameterMap();
		List<ComboItemModel> setDivi = null;
		setDivi = aiga240ukrvService.selectSetDivi(reqParam);
		
		if(setDivi == null)	{
			setDivi.add( new ComboItemModel() );
		}
		model.addAttribute("SET_DIVI",setDivi);
		List<ComboItemModel> amtDivi = null;
		amtDivi = aiga240ukrvService.selectAmtDivi(reqParam);
		
		if(amtDivi == null)	{
			amtDivi.add( new ComboItemModel() );
		}
		model.addAttribute("AMT_DIVI",amtDivi);
		
		return JSP_PATH + "aba060ukr";
	}
	
	/**
     * 회계업무설정
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/accnt/aba061ukr.do")
    public String aba061ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model)throws Exception{
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        param.put("S_COMP_CODE",loginVO.getCompCode());
        
        List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);        //당기시작년월        
        model.addAttribute("getStDt",ObjUtils.toJsonStr(getStDt));  

        List<Map<String, Object>> getChargeCode = accntCommonService.fnGetChargeCode(param, loginVO);       // ChargeCode관련         
        model.addAttribute("getChargeCode",ObjUtils.toJsonStr(getChargeCode));
        
        
        param.put("Z0", 1);
        model.addAttribute("AC_ITEM_COMBO", comboService.getAcItemCombo(param));
        
        
        param.put("Z0", 1);
        param.put("Z1", 2);
        model.addAttribute("AC_ITEM_COMBO2", comboService.getAcItemCombo(param));
        
        return JSP_PATH + "aba061ukr";
    }
    /**
     * 급상여,거래유형등 방법등록
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/accnt/aba062ukr.do")
    public String aba062ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model)throws Exception{
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        param.put("S_COMP_CODE",loginVO.getCompCode());
        
        List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);        //당기시작년월        
        model.addAttribute("getStDt",ObjUtils.toJsonStr(getStDt));  

        List<Map<String, Object>> getChargeCode = accntCommonService.fnGetChargeCode(param, loginVO);       // ChargeCode관련         
        model.addAttribute("getChargeCode",ObjUtils.toJsonStr(getChargeCode));
        
        
        param.put("Z0", 1);
        model.addAttribute("AC_ITEM_COMBO", comboService.getAcItemCombo(param));
        
        
        param.put("Z0", 1);
        param.put("Z1", 2);
        model.addAttribute("AC_ITEM_COMBO2", comboService.getAcItemCombo(param));
        
        return JSP_PATH + "aba062ukr";
    }
	/**
	 * 기본정보 등록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/aba070ukr.do")
	public String aba070ukr(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		return JSP_PATH + "aba070ukr";
	
	}	
	
	/**
	 * 표준적요등록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/aba700ukr.do")
	public String aba700ukr(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
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
		
		return JSP_PATH + "aba700ukr";
	}
	
	/**
	 * 자동분개등록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/aba800ukr.do")
	public String aba800ukr(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
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
		
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;		
		if(getChargeCode.size() > 0){
			cdo = codeInfo.getCodeInfo("A009", (String) getChargeCode.get(0).get("SUB_CODE"));	//자동채번여부(출고번호)정보 조회
		}
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsChargeDivi",cdo.getRefCode2());
		}else {
			model.addAttribute("gsChargeDivi", "2");
		}
		
		List<CodeDetailVO> proofKindList = codeInfo.getCodeList("A022");		//증빙유형 리스트
		if(!ObjUtils.isEmpty(proofKindList))	model.addAttribute("proofKindList",ObjUtils.toJsonStr(proofKindList));
		
		
		Map paramMap = new HashMap();
        paramMap.put("S_COMP_CODE", loginVO.getCompCode());
        Map<String, Object> rMap = (Map<String, Object>)agj100ukrService.selectOption(paramMap);
        
        model.addAttribute("gbAutoMappingA6", rMap.get("ID_AUTOMAPPING"));	//'결의전표 관리항목 사번에 로그인정보 자동매핑함
        model.addAttribute("gsDivChangeYN", rMap.get("DIV_CHANGE_YN"));	//'귀속부서 입력시 사업장 자동 변경 사용여부
        model.addAttribute("gsRemarkCopy", rMap.get("REMARK_COPY"));		//'전표_적요 copy방식_적요 빈 값 상태에서 Enter칠 때 copy
        model.addAttribute("gsAmtEnter", rMap.get("AMT_ENTER"));			//'전표_금액이 0이면 마지막 행에서 Enter안넘어감(부가세 제외)
        
        
        Map param1 = new HashMap();
        param1.put("DIV_CODE", loginVO.getDivCode());
        param1.put("S_COMP_CODE", loginVO.getCompCode());
        Map<String, Object> amtPoint = (Map<String, Object>)accntCommonService.fnGetAmtPoint(param1);
        model.addAttribute("gsAmtPoint", ( ObjUtils.isNotEmpty(amtPoint.get("AMT_POINT")) ? amtPoint.get("AMT_POINT") : 0 ));
        
		return JSP_PATH + "aba800ukr";
	}
	
	/**
	 * 기간비용등록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/aba900ukr.do")
	public String aba900ukr(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);		//당기시작년월		
		model.addAttribute("getStDt",ObjUtils.toJsonStr(getStDt));
		
		List<Map<String, Object>> getChargeCode = accntCommonService.fnGetChargeCode(param, loginVO);			
		if(getChargeCode.size() > 0){
			model.addAttribute("getChargeCode",getChargeCode.get(0).get("SUB_CODE"));
		}else{
			model.addAttribute("getChargeCode","");
		}
		return JSP_PATH + "aba900ukr";
	}
	
	/**
	 * 전표마감등록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/aba160ukr.do",method = RequestMethod.GET)
	public String aba160ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE",loginVO.getCompCode());
	
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		return JSP_PATH + "aba160ukr";
	}
	/**
	 * 신용카드정보등록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/aba500ukr.do",method = RequestMethod.GET)
	public String aba500ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE",loginVO.getCompCode());
	
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		return JSP_PATH + "aba500ukr";
	}
	
	/**
     * 테스트페이지   
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/accnt/test001ukr.do")
    public String test001ukr(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
        return JSP_PATH + "test001ukr";
    }
	
}
