package foren.unilite.modules.accnt.acm;


import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;




import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;





import foren.framework.lib.listop.ListOp;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.model.NavigatorInfo;
import foren.framework.utils.GStringUtils;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.modules.accnt.AccntCommonServiceImpl;
import foren.unilite.modules.accnt.agj.Agj100ukrServiceImpl;
import foren.unilite.modules.com.combo.ComboServiceImpl;
import foren.unilite.modules.com.popup.PopupServiceImpl;


@Controller
public class AcmController extends UniliteCommonController {
	
    @Resource( name = "accntCommonService" )
    private AccntCommonServiceImpl accntCommonService;
    
    @Resource( name = "UniliteComboServiceImpl" )
    private ComboServiceImpl       comboService; 
    
    @Resource( name = "acm100ukrService" )
    private Acm100ukrServiceImpl   acm100ukrService;
    
    @Resource( name = "acm110ukrService" )
    private Acm110ukrServiceImpl   acm110ukrService;
    
    @Resource( name = "acm210ukrService" )
    private Acm210ukrServiceImpl   acm210ukrService;
    
    @Resource( name = "acm200ukrService" )
    private Acm200ukrServiceImpl   acm200ukrService;  
    
    @Resource( name = "popupService" )
    private PopupServiceImpl       popupService;    
    
    @Resource( name = "agj100ukrService" )
    private Agj100ukrServiceImpl   agj100ukrService;

	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	final static String JSP_PATH = "/accnt/acm/";
	
	

	/**
	 * 총계정원장
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/acm400skr.do")
	public String acm400skr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		return JSP_PATH + "acm400skr";
	}
    /**
     * CMS입출금자동기표
     * 
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked", "unused" } )
    @RequestMapping( value = "/accnt/acm100ukr.do" )
    public String acm100ukr( LoginVO loginVO, ModelMap model ) throws Exception {
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        
        List<CodeDetailVO> MoneyUnit = codeInfo.getCodeList("B004", "", false);
        
        for (CodeDetailVO map : MoneyUnit) {
            if ("Y".equals(map.getRefCode1())) {
                model.addAttribute("gsLocalMoney", map.getCodeNo());
            }
        }
        
        //신고사업장
        Map param1 = new HashMap();
        param1.put("DIV_CODE", loginVO.getDivCode());
        param1.put("S_COMP_CODE", loginVO.getCompCode());
        Map billDivMap = (Map)accntCommonService.fnGetBillDivCode(param1);
        model.addAttribute("gsBillDivCode", ObjUtils.isNotEmpty(billDivMap) ? billDivMap.get("BILL_DIV_CODE") : "");
        
        Map<String, Object> amtPoint = (Map<String, Object>)accntCommonService.fnGetAmtPoint(param1);
        model.addAttribute("gsAmtPoint", ( ObjUtils.isNotEmpty(amtPoint.get("AMT_POINT")) ? amtPoint.get("AMT_POINT") : 0 ));
        
        Map param2 = new HashMap();
        param2.put("S_COMP_CODE", loginVO.getCompCode());
        param2.put("COL", "PEND_YN");
        Map gsPendMap = (Map)accntCommonService.fnGetAccntBasicInfo_a(param2);
        model.addAttribute("gsPendYn", gsPendMap.get("OPTION"));
        
        Map param3 = new HashMap();
        param3.put("S_COMP_CODE", loginVO.getCompCode());
        param3.put("S_USER_ID", loginVO.getUserID());
        Map chargeMap = (Map)accntCommonService.fnGetChargeInfo(param3);
        if (ObjUtils.isNotEmpty(chargeMap)) {
            model.addAttribute("chargeCode", chargeMap.get("CHARGE_CODE"));
            model.addAttribute("chargeName", chargeMap.get("CHARGE_NAME"));
            model.addAttribute("gsChargeDivi", chargeMap.get("CHARGE_DIVI"));
            model.addAttribute("gsChargePNumb", chargeMap.get("CHARGE_PNUMB"));
            model.addAttribute("gsChargePName", chargeMap.get("CHARGE_PNAME"));
        } else {
            
            model.addAttribute("chargeCode", "");
            model.addAttribute("chargeName", "");
            model.addAttribute("gsChargeDivi", "");
            model.addAttribute("gsChargePNumb", "");
            model.addAttribute("gsChargePName", "");
        }
        
        Map paramMap = new HashMap();
        paramMap.put("S_COMP_CODE", loginVO.getCompCode());
        Map<String, Object> rMap = (Map<String, Object>)acm100ukrService.selectOption(paramMap);
        
        model.addAttribute("gsDivChangeYN", rMap.get("DIV_CHANGE_YN"));	//'귀속부서 입력시 사업장 자동 변경 사용여부
        model.addAttribute("gsDivUseYN", rMap.get("DIV_CODE_USE"));	//'사업장 입력조건 사용
        model.addAttribute("gsRemarkCopy", rMap.get("REMARK_COPY"));		//'전표_적요 copy방식_적요 빈 값 상태에서 Enter칠 때 copy
        model.addAttribute("gsAmtEnter", rMap.get("AMT_ENTER"));			//'전표_금액이 0이면 마지막 행에서 Enter안넘어감(부가세 제외)
        
        Map cashAccntMap = (Map)acm100ukrService.getCashAccnt(paramMap);
        Map accParam = new HashMap();
        String strCashAccnt = "{";
        if (ObjUtils.isNotEmpty(cashAccntMap)) {
            accParam.put("ACCNT_CD", ObjUtils.getSafeString(cashAccntMap.get("ACCNT")));
            Map<String, Object> cashAccnt = (Map<String, Object>)accntCommonService.fnGetAccntInfo(accParam, loginVO);
            
            for (String key : cashAccnt.keySet()) {
                if (ObjUtils.isNotEmpty(cashAccnt.get(key))) {
                    strCashAccnt += "'" + key + "' : '" + cashAccnt.get(key) + "',";
                }
            }
        }
        if (strCashAccnt.length() > 1) {
            strCashAccnt = strCashAccnt.substring(0, strCashAccnt.length() - 1) + "}";
        } else {
            strCashAccnt = "{}";
        }
        model.addAttribute("cashAccntInfo", strCashAccnt);
        
        //출력
        Map param4 = new HashMap();
        param4.put("S_COMP_CODE", loginVO.getCompCode());
        List<Map<String, Object>> prtSettings = accntCommonService.fnGetPrintSetting(param4);
        if (prtSettings != null && prtSettings.size() > 0) {
            model.addAttribute("slipPrint", ObjUtils.getSafeString(prtSettings.get(0).get("SLIP_PRINT")));
            model.addAttribute("prtReturnYn", ObjUtils.getSafeString(prtSettings.get(0).get("RETURN_YN")));
        } else {
            model.addAttribute("slipPrint", "");
            model.addAttribute("prtReturnYn", "");
        }
        //출력 url
        CodeDetailVO cdo = codeInfo.getCodeInfo("A083", "400");
        if (cdo != null) {
        	model.addAttribute("reportUrl", ObjUtils.nvlObj(cdo.getCodeName(), "/accnt/agj270crkr.do"));
            model.addAttribute("reportPrgID", ObjUtils.nvlObj(cdo.getRefCode1(), "agj270rkr"));
        } else {
        	model.addAttribute("reportUrl", "/accnt/agj270crkr.do");
            model.addAttribute("reportPrgID", "agj270rkr");
        }
        //거래처 복사
        CodeDetailVO customCodeCopy = codeInfo.getCodeInfo("A165", "47");
        if (customCodeCopy != null) {
        	 model.addAttribute("customCodeCopy", ObjUtils.nvl(ObjUtils.getSafeString(customCodeCopy.getRefCode1()),"N"));
        } else {
        	model.addAttribute("customCodeCopy", "N");
        }
        //거래처 자동팝업
        CodeDetailVO customCodeAutoPopup = codeInfo.getCodeInfo("A165", "48");
        if (customCodeCopy != null) {
        	model.addAttribute("customCodeAutoPopup", GStringUtils.toUpperCase(ObjUtils.nvl(ObjUtils.getSafeString(customCodeAutoPopup.getRefCode1()),"N")));
        } else {
        	model.addAttribute("customCodeAutoPopup", "N");
        }
        //외환차익
        Map foreignProfitMap = new HashMap();
        foreignProfitMap.put("PROFIT_DIVI", "K");
        Map<String, Object> resProfitEarnAccnt = (Map<String, Object>) accntCommonService.getForeignProfitAccnt(foreignProfitMap, loginVO);
        if (resProfitEarnAccnt != null) {
        	model.addAttribute("profitEarnAccnt", ObjUtils.nvl(ObjUtils.getSafeString(resProfitEarnAccnt.get("ACCNT")),""));
        } else {
        	model.addAttribute("profitEarnAccnt", "");
        }
        foreignProfitMap.put("PROFIT_DIVI", "L");
        Map<String, Object> resProfitLossAccnt = (Map<String, Object>) accntCommonService.getForeignProfitAccnt(foreignProfitMap, loginVO);
        if (resProfitLossAccnt != null) {
        	model.addAttribute("profitLossAccnt", ObjUtils.nvl(ObjUtils.getSafeString(resProfitLossAccnt.get("ACCNT")),""));
        } else {
        	model.addAttribute("profitLossAccnt", "");
        }
        return JSP_PATH + "acm100ukr";
    }	
    /**
     * CMS법인카드승인자동기표
     * 
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked", "unused" } )
    @RequestMapping( value = "/accnt/acm200ukr.do" )
    public String acm200ukr( LoginVO loginVO, ModelMap model ) throws Exception {
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        
        List<CodeDetailVO> MoneyUnit = codeInfo.getCodeList("B004", "", false);
        
        for (CodeDetailVO map : MoneyUnit) {
            if ("Y".equals(map.getRefCode1())) {
                model.addAttribute("gsLocalMoney", map.getCodeNo());
            }
        }
        
        //신고사업장
        Map param1 = new HashMap();
        param1.put("DIV_CODE", loginVO.getDivCode());
        param1.put("S_COMP_CODE", loginVO.getCompCode());
        Map billDivMap = (Map)accntCommonService.fnGetBillDivCode(param1);
        model.addAttribute("gsBillDivCode", ObjUtils.isNotEmpty(billDivMap) ? billDivMap.get("BILL_DIV_CODE") : "");
        
        Map<String, Object> amtPoint = (Map<String, Object>)accntCommonService.fnGetAmtPoint(param1);
        model.addAttribute("gsAmtPoint", ( ObjUtils.isNotEmpty(amtPoint.get("AMT_POINT")) ? amtPoint.get("AMT_POINT") : 0 ));
        
        Map param2 = new HashMap();
        param2.put("S_COMP_CODE", loginVO.getCompCode());
        param2.put("COL", "PEND_YN");
        Map gsPendMap = (Map)accntCommonService.fnGetAccntBasicInfo_a(param2);
        model.addAttribute("gsPendYn", gsPendMap.get("OPTION"));
        
        Map param3 = new HashMap();
        param3.put("S_COMP_CODE", loginVO.getCompCode());
        param3.put("S_USER_ID", loginVO.getUserID());
        Map chargeMap = (Map)accntCommonService.fnGetChargeInfo(param3);
        if (ObjUtils.isNotEmpty(chargeMap)) {
            model.addAttribute("chargeCode", chargeMap.get("CHARGE_CODE"));
            model.addAttribute("chargeName", chargeMap.get("CHARGE_NAME"));
            model.addAttribute("gsChargeDivi", chargeMap.get("CHARGE_DIVI"));
            model.addAttribute("gsChargePNumb", chargeMap.get("CHARGE_PNUMB"));
            model.addAttribute("gsChargePName", chargeMap.get("CHARGE_PNAME"));
        } else {
            
            model.addAttribute("chargeCode", "");
            model.addAttribute("chargeName", "");
            model.addAttribute("gsChargeDivi", "");
            model.addAttribute("gsChargePNumb", "");
            model.addAttribute("gsChargePName", "");
        }
        
        Map paramMap = new HashMap();
        paramMap.put("S_COMP_CODE", loginVO.getCompCode());
        Map<String, Object> rMap = (Map<String, Object>)acm200ukrService.selectOption(paramMap);
        
        model.addAttribute("gsDivChangeYN", rMap.get("DIV_CHANGE_YN"));	//'귀속부서 입력시 사업장 자동 변경 사용여부
        model.addAttribute("gsDivUseYN", rMap.get("DIV_CODE_USE"));	//'사업장 입력조건 사용
        model.addAttribute("gsRemarkCopy", rMap.get("REMARK_COPY"));		//'전표_적요 copy방식_적요 빈 값 상태에서 Enter칠 때 copy
        model.addAttribute("gsAmtEnter", rMap.get("AMT_ENTER"));			//'전표_금액이 0이면 마지막 행에서 Enter안넘어감(부가세 제외)
        
        Map cashAccntMap = (Map)acm200ukrService.getCashAccnt(paramMap);
        Map accParam = new HashMap();
        String strCashAccnt = "{";
        if (ObjUtils.isNotEmpty(cashAccntMap)) {
            accParam.put("ACCNT_CD", ObjUtils.getSafeString(cashAccntMap.get("ACCNT")));
            Map<String, Object> cashAccnt = (Map<String, Object>)accntCommonService.fnGetAccntInfo(accParam, loginVO);
            
            for (String key : cashAccnt.keySet()) {
                if (ObjUtils.isNotEmpty(cashAccnt.get(key))) {
                    strCashAccnt += "'" + key + "' : '" + cashAccnt.get(key) + "',";
                }
            }
        }
        if (strCashAccnt.length() > 1) {
            strCashAccnt = strCashAccnt.substring(0, strCashAccnt.length() - 1) + "}";
        } else {
            strCashAccnt = "{}";
        }
        model.addAttribute("cashAccntInfo", strCashAccnt);
        
        //출력
        Map param4 = new HashMap();
        param4.put("S_COMP_CODE", loginVO.getCompCode());
        List<Map<String, Object>> prtSettings = accntCommonService.fnGetPrintSetting(param4);
        if (prtSettings != null && prtSettings.size() > 0) {
            model.addAttribute("slipPrint", ObjUtils.getSafeString(prtSettings.get(0).get("SLIP_PRINT")));
            model.addAttribute("prtReturnYn", ObjUtils.getSafeString(prtSettings.get(0).get("RETURN_YN")));
        } else {
            model.addAttribute("slipPrint", "");
            model.addAttribute("prtReturnYn", "");
        }
        //출력 url
        CodeDetailVO cdo = codeInfo.getCodeInfo("A083", "400");
        if (cdo != null) {
        	model.addAttribute("reportUrl", ObjUtils.nvlObj(cdo.getCodeName(), "/accnt/agj270crkr.do"));
            model.addAttribute("reportPrgID", ObjUtils.nvlObj(cdo.getRefCode1(), "agj270rkr"));
        } else {
        	model.addAttribute("reportUrl", "/accnt/agj270crkr.do");
            model.addAttribute("reportPrgID", "agj270rkr");
        }
        //거래처 복사
        CodeDetailVO customCodeCopy = codeInfo.getCodeInfo("A165", "47");
        if (customCodeCopy != null) {
        	 model.addAttribute("customCodeCopy", ObjUtils.nvl(ObjUtils.getSafeString(customCodeCopy.getRefCode1()),"N"));
        } else {
        	model.addAttribute("customCodeCopy", "N");
        }
        //거래처 자동팝업
        CodeDetailVO customCodeAutoPopup = codeInfo.getCodeInfo("A165", "48");
        if (customCodeCopy != null) {
        	model.addAttribute("customCodeAutoPopup", GStringUtils.toUpperCase(ObjUtils.nvl(ObjUtils.getSafeString(customCodeAutoPopup.getRefCode1()),"N")));
        } else {
        	model.addAttribute("customCodeAutoPopup", "N");
        }
        //외환차익
        Map foreignProfitMap = new HashMap();
        foreignProfitMap.put("PROFIT_DIVI", "K");
        Map<String, Object> resProfitEarnAccnt = (Map<String, Object>) accntCommonService.getForeignProfitAccnt(foreignProfitMap, loginVO);
        if (resProfitEarnAccnt != null) {
        	model.addAttribute("profitEarnAccnt", ObjUtils.nvl(ObjUtils.getSafeString(resProfitEarnAccnt.get("ACCNT")),""));
        } else {
        	model.addAttribute("profitEarnAccnt", "");
        }
        foreignProfitMap.put("PROFIT_DIVI", "L");
        Map<String, Object> resProfitLossAccnt = (Map<String, Object>) accntCommonService.getForeignProfitAccnt(foreignProfitMap, loginVO);
        if (resProfitLossAccnt != null) {
        	model.addAttribute("profitLossAccnt", ObjUtils.nvl(ObjUtils.getSafeString(resProfitLossAccnt.get("ACCNT")),""));
        } else {
        	model.addAttribute("profitLossAccnt", "");
        }
        return JSP_PATH + "acm200ukr";
    }
    
    
    /**
     * 결의미결 반제 입력
     * 
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked", "unused" } )
    @RequestMapping( value = "/accnt/acm110ukr.do" )
    public String acm110ukr( LoginVO loginVO, ModelMap model ) throws Exception {
        
        //신고사업장
        Map param = new HashMap();
        param.put("DIV_CODE", loginVO.getDivCode());
        param.put("S_COMP_CODE", loginVO.getCompCode());
        Map billDivMap = (Map)accntCommonService.fnGetBillDivCode(param);
        model.addAttribute("gsBillDivCode", ObjUtils.isNotEmpty(billDivMap) ? billDivMap.get("BILL_DIV_CODE") : "");
        
        String toDaty = new SimpleDateFormat("yyyyMMdd").format(new Date());
        Map param1 = new HashMap();
        param1.put("AC_DATE", toDaty);
        param1.put("S_COMP_CODE", loginVO.getCompCode());
        Map<String, Object> maxSlipNumMap = (Map<String, Object>)acm110ukrService.getSlipNum(param1);
        model.addAttribute("initAcDate", toDaty);
        model.addAttribute("initSlipNum", maxSlipNumMap.get("SLIP_NUM"));
        
        Map param3 = new HashMap();
        param3.put("S_COMP_CODE", loginVO.getCompCode());
        param3.put("S_USER_ID", loginVO.getUserID());
        Map chargeMap = (Map)accntCommonService.fnGetChargeInfo(param3);
        
        Map paramMap = new HashMap();
        paramMap.put("S_COMP_CODE", loginVO.getCompCode());
        Map<String, Object> rMap = (Map<String, Object>)agj100ukrService.selectOption(paramMap);
        
        Map param2 = new HashMap();
        param2.put("S_COMP_CODE", loginVO.getCompCode());
        param2.put("COL", "PEND_YN");
        Map gsPendMap = (Map)accntCommonService.fnGetAccntBasicInfo_a(param2);
        model.addAttribute("gsPendYn", gsPendMap.get("OPTION"));
        
        if (ObjUtils.isNotEmpty(chargeMap)) {
            model.addAttribute("chargeCode", chargeMap.get("CHARGE_CODE"));
            model.addAttribute("chargeName", chargeMap.get("CHARGE_NAME"));
            model.addAttribute("gsChargePNumb", chargeMap.get("CHARGE_PNUMB"));
            model.addAttribute("gsChargePName", chargeMap.get("CHARGE_PNAME"));
            model.addAttribute("gsChargeDivi", chargeMap.get("CHARGE_DIVI"));
        } else {
            
            model.addAttribute("chargeCode", "");
            model.addAttribute("chargeName", "");
            model.addAttribute("gsChargePNumb", "");
            model.addAttribute("gsChargePName", "");
            model.addAttribute("gsChargeDivi", "");
        }
        
        Map<String, Object> amtPoint = (Map<String, Object>)accntCommonService.fnGetAmtPoint(param3);
        model.addAttribute("gsAmtPoint", ( ObjUtils.isNotEmpty(amtPoint.get("AMT_POINT")) ? amtPoint.get("AMT_POINT") : 0 ));
        
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = codeInfo.getCodeInfo("A083", "400");

        //거래처 복사
        CodeDetailVO customCodeCopy = codeInfo.getCodeInfo("A165", "47");
        if (customCodeCopy != null) {
        	 model.addAttribute("customCodeCopy", ObjUtils.nvl(ObjUtils.getSafeString(customCodeCopy.getRefCode1()),"N"));
        } else {
        	model.addAttribute("customCodeCopy", "N");
        }
        //거래처 자동팝업
        CodeDetailVO customCodeAutoPopup = codeInfo.getCodeInfo("A165", "48");
        if (customCodeCopy != null) {
        	model.addAttribute("customCodeAutoPopup", GStringUtils.toUpperCase(ObjUtils.nvl(ObjUtils.getSafeString(customCodeAutoPopup.getRefCode1()),"N")));
        } else {
        	model.addAttribute("customCodeAutoPopup", "N");
        }
        //외환차익
        Map foreignProfitMap = new HashMap();
        foreignProfitMap.put("PROFIT_DIVI", "K");
        Map<String, Object> resProfitEarnAccnt = (Map<String, Object>) accntCommonService.getForeignProfitAccnt(foreignProfitMap, loginVO);
        if (resProfitEarnAccnt != null) {
        	model.addAttribute("profitEarnAccnt", ObjUtils.nvl(ObjUtils.getSafeString(resProfitEarnAccnt.get("ACCNT")),""));
        } else {
        	model.addAttribute("profitEarnAccnt", "");
        }
        foreignProfitMap.put("PROFIT_DIVI", "L");
        Map<String, Object> resProfitLossAccnt = (Map<String, Object>) accntCommonService.getForeignProfitAccnt(foreignProfitMap, loginVO);
        if (resProfitLossAccnt != null) {
        	model.addAttribute("profitLossAccnt", ObjUtils.nvl(ObjUtils.getSafeString(resProfitLossAccnt.get("ACCNT")),""));
        } else {
        	model.addAttribute("profitLossAccnt", "");
        }
        
        //접속자부서
        Map param5 = new HashMap();
        param5.put("S_COMP_CODE", loginVO.getCompCode());
        Map gsDeptCode = (Map)accntCommonService.fnGetDeptcodeCode(param5, loginVO);
        model.addAttribute("gsDeptCode", gsDeptCode.get("TREE_CODE"));
        model.addAttribute("gsDeptName", gsDeptCode.get("TREE_NAME"));

        //전표_귀속부서 팝업창 오픈시 검색어 공백 처리
        CodeDetailVO inDeptCodeBlankYN = codeInfo.getCodeInfo("A165", "75");
        if (inDeptCodeBlankYN != null) {
        	model.addAttribute("inDeptCodeBlankYN", GStringUtils.toUpperCase(ObjUtils.nvl(ObjUtils.getSafeString(inDeptCodeBlankYN.getRefCode1()),"N")));
        } else {
        	model.addAttribute("inDeptCodeBlankYN", "N");
        }

        //전표_귀속부서 팝업창 오픈시 검색어 공백 처리
        CodeDetailVO multipleDivCodeAllowYN = codeInfo.getCodeInfo("A165", "80");
        if (multipleDivCodeAllowYN != null) {
        	model.addAttribute("multipleDivCodeAllowYN", GStringUtils.toUpperCase(ObjUtils.nvl(ObjUtils.getSafeString(multipleDivCodeAllowYN.getRefCode1()),"N")));
        } else {
        	model.addAttribute("multipleDivCodeAllowYN", "N");
        }
        
        return JSP_PATH + "acm110ukr";
    }
    
    /**
     * 법인카드승인내역자동기표
     * 
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked", "unused" } )
    @RequestMapping( value = "/accnt/acm210ukr.do" )
    public String acm210ukr( LoginVO loginVO, ModelMap model ) throws Exception {
        
        //신고사업장
        Map param = new HashMap();
        param.put("DIV_CODE", loginVO.getDivCode());
        param.put("S_COMP_CODE", loginVO.getCompCode());
        Map billDivMap = (Map)accntCommonService.fnGetBillDivCode(param);
        model.addAttribute("gsBillDivCode", ObjUtils.isNotEmpty(billDivMap) ? billDivMap.get("BILL_DIV_CODE") : "");
        
        String toDaty = new SimpleDateFormat("yyyyMMdd").format(new Date());
        Map param1 = new HashMap();
        param1.put("AC_DATE", toDaty);
        param1.put("S_COMP_CODE", loginVO.getCompCode());
        Map<String, Object> maxSlipNumMap = (Map<String, Object>)acm210ukrService.getSlipNum(param1);
        model.addAttribute("initAcDate", toDaty);
        model.addAttribute("initSlipNum", maxSlipNumMap.get("SLIP_NUM"));

        // 부가세 계정정보
        Map<String, Object> taxAccntMap = (Map<String, Object>)acm210ukrService.getTaxAccnt(param1);
        model.addAttribute("initTaxAccnt", taxAccntMap.get("ACCNT"));
        model.addAttribute("initTaxAccntNm", taxAccntMap.get("ACCNT_NAME"));
        
        
        Map param3 = new HashMap();
        param3.put("S_COMP_CODE", loginVO.getCompCode());
        param3.put("S_USER_ID", loginVO.getUserID());
        Map chargeMap = (Map)accntCommonService.fnGetChargeInfo(param3);
        
        Map paramMap = new HashMap();
        paramMap.put("S_COMP_CODE", loginVO.getCompCode());
        Map<String, Object> rMap = (Map<String, Object>)agj100ukrService.selectOption(paramMap);
        
        Map param2 = new HashMap();
        param2.put("S_COMP_CODE", loginVO.getCompCode());
        param2.put("COL", "PEND_YN");
        Map gsPendMap = (Map)accntCommonService.fnGetAccntBasicInfo_a(param2);
        model.addAttribute("gsPendYn", gsPendMap.get("OPTION"));
        
        if (ObjUtils.isNotEmpty(chargeMap)) {
            model.addAttribute("chargeCode", chargeMap.get("CHARGE_CODE"));
            model.addAttribute("chargeName", chargeMap.get("CHARGE_NAME"));
            model.addAttribute("gsChargePNumb", chargeMap.get("CHARGE_PNUMB"));
            model.addAttribute("gsChargePName", chargeMap.get("CHARGE_PNAME"));
            model.addAttribute("gsChargeDivi", chargeMap.get("CHARGE_DIVI"));
        } else {
            
            model.addAttribute("chargeCode", "");
            model.addAttribute("chargeName", "");
            model.addAttribute("gsChargePNumb", "");
            model.addAttribute("gsChargePName", "");
            model.addAttribute("gsChargeDivi", "");
        }
        
        Map<String, Object> amtPoint = (Map<String, Object>)accntCommonService.fnGetAmtPoint(param3);
        model.addAttribute("gsAmtPoint", ( ObjUtils.isNotEmpty(amtPoint.get("AMT_POINT")) ? amtPoint.get("AMT_POINT") : 0 ));
        
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = codeInfo.getCodeInfo("A083", "400");

        //거래처 복사
        CodeDetailVO customCodeCopy = codeInfo.getCodeInfo("A165", "47");
        if (customCodeCopy != null) {
        	 model.addAttribute("customCodeCopy", ObjUtils.nvl(ObjUtils.getSafeString(customCodeCopy.getRefCode1()),"N"));
        } else {
        	model.addAttribute("customCodeCopy", "N");
        }
        //거래처 자동팝업
        CodeDetailVO customCodeAutoPopup = codeInfo.getCodeInfo("A165", "48");
        if (customCodeCopy != null) {
        	model.addAttribute("customCodeAutoPopup", GStringUtils.toUpperCase(ObjUtils.nvl(ObjUtils.getSafeString(customCodeAutoPopup.getRefCode1()),"N")));
        } else {
        	model.addAttribute("customCodeAutoPopup", "N");
        }
        //외환차익
        Map foreignProfitMap = new HashMap();
        foreignProfitMap.put("PROFIT_DIVI", "K");
        Map<String, Object> resProfitEarnAccnt = (Map<String, Object>) accntCommonService.getForeignProfitAccnt(foreignProfitMap, loginVO);
        if (resProfitEarnAccnt != null) {
        	model.addAttribute("profitEarnAccnt", ObjUtils.nvl(ObjUtils.getSafeString(resProfitEarnAccnt.get("ACCNT")),""));
        } else {
        	model.addAttribute("profitEarnAccnt", "");
        }
        foreignProfitMap.put("PROFIT_DIVI", "L");
        Map<String, Object> resProfitLossAccnt = (Map<String, Object>) accntCommonService.getForeignProfitAccnt(foreignProfitMap, loginVO);
        if (resProfitLossAccnt != null) {
        	model.addAttribute("profitLossAccnt", ObjUtils.nvl(ObjUtils.getSafeString(resProfitLossAccnt.get("ACCNT")),""));
        } else {
        	model.addAttribute("profitLossAccnt", "");
        }
        
        //접속자부서
        Map param5 = new HashMap();
        param5.put("S_COMP_CODE", loginVO.getCompCode());
        Map gsDeptCode = (Map)accntCommonService.fnGetDeptcodeCode(param5, loginVO);
        model.addAttribute("gsDeptCode", gsDeptCode.get("TREE_CODE"));
        model.addAttribute("gsDeptName", gsDeptCode.get("TREE_NAME"));

        //전표_귀속부서 팝업창 오픈시 검색어 공백 처리
        CodeDetailVO inDeptCodeBlankYN = codeInfo.getCodeInfo("A165", "75");
        if (inDeptCodeBlankYN != null) {
        	model.addAttribute("inDeptCodeBlankYN", GStringUtils.toUpperCase(ObjUtils.nvl(ObjUtils.getSafeString(inDeptCodeBlankYN.getRefCode1()),"N")));
        } else {
        	model.addAttribute("inDeptCodeBlankYN", "N");
        }

        //전표_귀속부서 팝업창 오픈시 검색어 공백 처리
        CodeDetailVO multipleDivCodeAllowYN = codeInfo.getCodeInfo("A165", "80");
        if (multipleDivCodeAllowYN != null) {
        	model.addAttribute("multipleDivCodeAllowYN", GStringUtils.toUpperCase(ObjUtils.nvl(ObjUtils.getSafeString(multipleDivCodeAllowYN.getRefCode1()),"N")));
        } else {
        	model.addAttribute("multipleDivCodeAllowYN", "N");
        }
        
        return JSP_PATH + "acm210ukr";
    }
	
}
