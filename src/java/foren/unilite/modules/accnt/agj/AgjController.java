package foren.unilite.modules.accnt.agj;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.DataFormat;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.lib.listop.ListOp;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.model.NavigatorInfo;
import foren.framework.utils.GStringUtils;
import foren.framework.utils.ObjUtils;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.com.tags.ComboItemModel;
import foren.unilite.modules.accnt.AccntCommonServiceImpl;
import foren.unilite.modules.com.combo.ComboServiceImpl;
import foren.unilite.modules.com.popup.PopupServiceImpl;
import foren.unilite.utils.AES256DecryptoUtils;

@Controller
public class AgjController extends UniliteCommonController {
    
    @Resource( name = "accntCommonService" )
    private AccntCommonServiceImpl accntCommonService;
    
    @Resource( name = "UniliteComboServiceImpl" )
    private ComboServiceImpl       comboService;
    
    @Resource( name = "agj100ukrService" )
    private Agj100ukrServiceImpl   agj100ukrService;
    
    @Resource( name = "agj106ukrService" )
    private Agj106ukrServiceImpl   agj106ukrService;
    
    @Resource( name = "agj200ukrService" )
    private Agj200ukrServiceImpl   agj200ukrService;
    
    @Resource( name = "agj240skrService" )
    private Agj240skrServiceImpl   agj240skrService;
    
    @Resource( name = "agj800ukrService" )
    private Agj800ukrServiceImpl   agj800ukrService;
    
    @Resource( name = "agj400ukrService" )
    private Agj400ukrServiceImpl   agj400ukrService;
    
    
    @Resource( name = "popupService" )
    private PopupServiceImpl       popupService;
    
    private final Logger           logger   = LoggerFactory.getLogger(this.getClass());
    
    final static String            JSP_PATH = "/accnt/agj/";
    
    /**
     * 결의전표입력
     * 
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @RequestMapping( value = "/accnt/agj100ukr.do" )
    public String agj100ukr( LoginVO loginVO, ModelMap model ) throws Exception {
        
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        
        //화폐단위
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
        model.addAttribute("gsBillDivCode", ObjUtils.isNotEmpty(billDivMap) ? ObjUtils.isNotEmpty(billDivMap) ? billDivMap.get("BILL_DIV_CODE") : "" : "");
        
        //미결여부
        Map param2 = new HashMap();
        param2.put("S_COMP_CODE", loginVO.getCompCode());
        param2.put("COL", "PEND_YN");
        Map gsPendMap = (Map)accntCommonService.fnGetAccntBasicInfo_a(param2);
        model.addAttribute("gsPendYn", gsPendMap.get("OPTION"));
        
        //입력자 코드/명
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
        Map<String, Object> rMap = (Map<String, Object>)agj100ukrService.selectOption(paramMap);
        
        model.addAttribute("gbAutoMappingA6", rMap.get("ID_AUTOMAPPING"));	//'결의전표 관리항목 사번에 로그인정보 자동매핑함
        model.addAttribute("gsDivChangeYN", rMap.get("DIV_CHANGE_YN"));	//'귀속부서 입력시 사업장 자동 변경 사용여부
        model.addAttribute("gsRemarkCopy", rMap.get("REMARK_COPY"));		//'전표_적요 copy방식_적요 빈 값 상태에서 Enter칠 때 copy
        model.addAttribute("gsAmtEnter", rMap.get("AMT_ENTER"));			//'전표_금액이 0이면 마지막 행에서 Enter안넘어감(부가세 제외)
        
        //접속자부서
        Map param5 = new HashMap();
        param5.put("S_COMP_CODE", loginVO.getCompCode());
        Map gsDeptCode = (Map)accntCommonService.fnGetDeptcodeCode(param5, loginVO);
        model.addAttribute("gsDeptCode", gsDeptCode.get("TREE_CODE"));
        model.addAttribute("gsDeptName", gsDeptCode.get("TREE_NAME"));
        
        // 현금 계정
        Map cashAccntMap = (Map)agj100ukrService.getCashAccnt(paramMap);
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
        
        //입력경로 중 (Z0 제외)
        List<ComboItemModel> inputPath = comboService.getComboList("AU", "A011", loginVO, null, null);
        List<ComboItemModel> comboInputPath = new ArrayList<ComboItemModel>();
        for (ComboItemModel map : inputPath) {
            if (!"Z0".equals(map.getRefCode2())) {
                comboInputPath.add(map);
            }
        }
        model.addAttribute("comboInputPath", comboInputPath);
        
        //사유 구분
        CodeDetailVO cdo = codeInfo.getCodeInfo("A165", "46");
        if (cdo != null) {
            model.addAttribute("reasonGbn", ObjUtils.getSafeString(cdo.getRefCode1()));
        }
        
        //amt point
        Map<String, Object> amtPoint = (Map<String, Object>)accntCommonService.fnGetAmtPoint(param1);
        model.addAttribute("gsAmtPoint", ( ObjUtils.isNotEmpty(amtPoint.get("AMT_POINT")) ? amtPoint.get("AMT_POINT") : 0 ));
        
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
        CodeDetailVO cdo2 = codeInfo.getCodeInfo("A083", "400");
        if (cdo2 != null) {
        	model.addAttribute("reportUrl", ObjUtils.nvlObj(cdo2.getCodeName(), "/accnt/agj270crkr.do"));
            model.addAttribute("reportPrgID", ObjUtils.nvlObj(cdo2.getRefCode1(), "agj270rkr"));
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
        
        //전표_귀속부서 팝업창 오픈시 검색어 공백 처리
        CodeDetailVO inDeptCodeBlankYN = codeInfo.getCodeInfo("A165", "75");
        if (inDeptCodeBlankYN != null) {
        	model.addAttribute("inDeptCodeBlankYN", GStringUtils.toUpperCase(ObjUtils.nvl(ObjUtils.getSafeString(inDeptCodeBlankYN.getRefCode1()),"N")));
        } else {
        	model.addAttribute("inDeptCodeBlankYN", "N");
        }
        return JSP_PATH + "agj100ukr";
    }
    
    /**
     * 결의전표입력(전표번호별)
     * 
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked", "unused" } )
    @RequestMapping( value = "/accnt/agj105ukr.do" )
    public String agj105ukr( LoginVO loginVO, ModelMap model ) throws Exception {
        
        //신고사업장
        Map param = new HashMap();
        param.put("DIV_CODE", loginVO.getDivCode());
        param.put("S_COMP_CODE", loginVO.getCompCode());
        Map billDivMap = (Map)accntCommonService.fnGetBillDivCode(param);
        model.addAttribute("gsBillDivCode", ObjUtils.isNotEmpty(billDivMap) ? billDivMap.get("BILL_DIV_CODE") : "");
        
        String toDaty = new SimpleDateFormat("yyyyMMdd").format(new Date());
        Map param1 = new HashMap();
        param1.put("EX_DATE", toDaty);
        param1.put("S_COMP_CODE", loginVO.getCompCode());
        Map<String, Object> maxSlipNumMap = (Map<String, Object>)agj100ukrService.getSlipNum(param1);
        model.addAttribute("initExDate", toDaty);
        model.addAttribute("initExNum", maxSlipNumMap.get("SLIP_NUM"));
        
        Map param3 = new HashMap();
        param3.put("S_COMP_CODE", loginVO.getCompCode());
        param3.put("S_USER_ID", loginVO.getUserID());
        Map chargeMap = (Map)accntCommonService.fnGetChargeInfo(param3);
        
        Map paramMap = new HashMap();
        paramMap.put("S_COMP_CODE", loginVO.getCompCode());
        Map<String, Object> rMap = (Map<String, Object>)agj100ukrService.selectOption(paramMap);
        
        Map cashAccntMap = (Map)agj100ukrService.getCashAccnt(paramMap);
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
        
        Map param2 = new HashMap();
        param2.put("S_COMP_CODE", loginVO.getCompCode());
        param2.put("COL", "PEND_YN");
        Map gsPendMap = (Map)accntCommonService.fnGetAccntBasicInfo_a(param2);
        model.addAttribute("gsPendYn", gsPendMap.get("OPTION"));
        
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
        
        Map<String, Object> amtPoint = (Map<String, Object>)accntCommonService.fnGetAmtPoint(param3);
        model.addAttribute("gsAmtPoint", ( ObjUtils.isNotEmpty(amtPoint.get("AMT_POINT")) ? amtPoint.get("AMT_POINT") : 0 ));
        
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
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
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
        
        return JSP_PATH + "agj105ukr";
    }
    
    
    
    
    
    
    /**
     * 결의전표입력(건별-기안용)
     *
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked", "unused" } )
    @RequestMapping( value = "/accnt/agj106ukr.do" )
    public String agj106ukr( LoginVO loginVO, ModelMap model ) throws Exception {

        //신고사업장
        Map param = new HashMap();
        param.put("DIV_CODE", loginVO.getDivCode());
        param.put("S_COMP_CODE", loginVO.getCompCode());
        Map billDivMap = (Map)accntCommonService.fnGetBillDivCode(param);
        model.addAttribute("gsBillDivCode", ObjUtils.isNotEmpty(billDivMap) ? billDivMap.get("BILL_DIV_CODE") : "");

        String toDaty = new SimpleDateFormat("yyyyMMdd").format(new Date());
        Map param1 = new HashMap();
        param1.put("EX_DATE", toDaty);
        param1.put("S_COMP_CODE", loginVO.getCompCode());
        Map<String, Object> maxSlipNumMap = (Map<String, Object>)agj100ukrService.getSlipNum(param1);
        model.addAttribute("initExDate", toDaty);
        model.addAttribute("initExNum", maxSlipNumMap.get("SLIP_NUM"));

        Map param3 = new HashMap();
        param3.put("S_COMP_CODE", loginVO.getCompCode());
        param3.put("S_USER_ID", loginVO.getUserID());
        Map chargeMap = (Map)accntCommonService.fnGetChargeInfo(param3);

        Map paramMap = new HashMap();
        paramMap.put("S_COMP_CODE", loginVO.getCompCode());
        Map<String, Object> rMap = (Map<String, Object>)agj100ukrService.selectOption(paramMap);

        Map cashAccntMap = (Map)agj100ukrService.getCashAccnt(paramMap);
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

        Map param2 = new HashMap();
        param2.put("S_COMP_CODE", loginVO.getCompCode());
        param2.put("COL", "PEND_YN");
        Map gsPendMap = (Map)accntCommonService.fnGetAccntBasicInfo_a(param2);
        model.addAttribute("gsPendYn", gsPendMap.get("OPTION"));

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

        Map<String, Object> amtPoint = (Map<String, Object>)accntCommonService.fnGetAmtPoint(param3);
        model.addAttribute("gsAmtPoint", ( ObjUtils.isNotEmpty(amtPoint.get("AMT_POINT")) ? amtPoint.get("AMT_POINT") : 0 ));

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
        
        //그룹웨어 사용여부
        Map param5 = new HashMap();
        param5.put("S_COMP_CODE", loginVO.getCompCode());
        Map gsGWUseYN = (Map)accntCommonService.fnGWUseYN(param5);
        
        if (gsGWUseYN != null && gsGWUseYN.size() > 0) {
        	model.addAttribute("gsGWUseYN", gsGWUseYN.get("SUB_CODE"));
        } else {
        	model.addAttribute("gsGWUseYN", "00");
        	
        }
        
       //그룹웨어 결재상신경로
        Map param6 = new HashMap();
        param6.put("S_COMP_CODE", loginVO.getCompCode());

        List<Map<String, Object>> gwurl = accntCommonService.fnGWUrl(param6);

        String gsGWUrl = "";
        
        if(gwurl.size() > 0){
        	 for(Map map : gwurl){
        		 gsGWUrl = gsGWUrl + map.get("REF_CODE1");
 	        }
        	
        } else {
        	gsGWUrl = "";
        	
        }
        
        model.addAttribute("gsGWUrl", gsGWUrl);
        
		model.addAttribute("COMBO_DRAFT_CODE", agj106ukrService.fnGetA134MakeCombo(param));  

    	
               
        return JSP_PATH + "agj106ukr";
    }
    
    
    
    
    
    
    /**
     * 결의미결 반제 입력
     * 
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked", "unused" } )
    @RequestMapping( value = "/accnt/agj110ukr.do" )
    public String agj110ukr( LoginVO loginVO, ModelMap model ) throws Exception {
        
        //신고사업장
        Map param = new HashMap();
        param.put("DIV_CODE", loginVO.getDivCode());
        param.put("S_COMP_CODE", loginVO.getCompCode());
        Map billDivMap = (Map)accntCommonService.fnGetBillDivCode(param);
        model.addAttribute("gsBillDivCode", ObjUtils.isNotEmpty(billDivMap) ? billDivMap.get("BILL_DIV_CODE") : "");
        
        String toDaty = new SimpleDateFormat("yyyyMMdd").format(new Date());
        Map param1 = new HashMap();
        param1.put("EX_DATE", toDaty);
        param1.put("S_COMP_CODE", loginVO.getCompCode());
        Map<String, Object> maxSlipNumMap = (Map<String, Object>)agj100ukrService.getSlipNum(param1);
        model.addAttribute("initExDate", toDaty);
        model.addAttribute("initExNum", maxSlipNumMap.get("SLIP_NUM"));
        
        Map param3 = new HashMap();
        param3.put("S_COMP_CODE", loginVO.getCompCode());
        param3.put("S_USER_ID", loginVO.getUserID());
        Map chargeMap = (Map)accntCommonService.fnGetChargeInfo(param3);
        
        Map paramMap = new HashMap();
        paramMap.put("S_COMP_CODE", loginVO.getCompCode());
        Map<String, Object> rMap = (Map<String, Object>)agj100ukrService.selectOption(paramMap);
        
        Map cashAccntMap = (Map)agj100ukrService.getCashAccnt(paramMap);
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
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
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
        
        return JSP_PATH + "agj110ukr";
    }
    
    /**
     * 회계전표입력
     * 
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked", "unused" } )
    @RequestMapping( value = "/accnt/agj200ukr.do" )
    public String agj200ukr( LoginVO loginVO, ModelMap model ) throws Exception {
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
        Map<String, Object> rMap = (Map<String, Object>)agj200ukrService.selectOption(paramMap);
        
        model.addAttribute("gsDivChangeYN", rMap.get("DIV_CHANGE_YN"));	//'귀속부서 입력시 사업장 자동 변경 사용여부
        model.addAttribute("gsDivUseYN", rMap.get("DIV_CODE_USE"));	//'사업장 입력조건 사용
        model.addAttribute("gsRemarkCopy", rMap.get("REMARK_COPY"));		//'전표_적요 copy방식_적요 빈 값 상태에서 Enter칠 때 copy
        model.addAttribute("gsAmtEnter", rMap.get("AMT_ENTER"));			//'전표_금액이 0이면 마지막 행에서 Enter안넘어감(부가세 제외)
        
        Map cashAccntMap = (Map)agj100ukrService.getCashAccnt(paramMap);
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
      
        //전표_귀속부서 팝업창 오픈시 검색어 공백 처리
        CodeDetailVO inDeptCodeBlankYN = codeInfo.getCodeInfo("A165", "75");
        if (inDeptCodeBlankYN != null) {
        	model.addAttribute("inDeptCodeBlankYN", GStringUtils.toUpperCase(ObjUtils.nvl(ObjUtils.getSafeString(inDeptCodeBlankYN.getRefCode1()),"N")));
        } else {
        	model.addAttribute("inDeptCodeBlankYN", "N");
        }
        
        return JSP_PATH + "agj200ukr";
    }
    
    /**
     * 회계전표입력(전표번호별)
     * 
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked", "unused" } )
    @RequestMapping( value = "/accnt/agj205ukr.do" )
    public String agj205ukr( LoginVO loginVO, ModelMap model ) throws Exception {
        
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
        Map<String, Object> maxSlipNumMap = (Map<String, Object>)agj200ukrService.getSlipNum(param1);
        model.addAttribute("initAcDate", toDaty);
        model.addAttribute("initSlipNum", maxSlipNumMap.get("SLIP_NUM"));
        
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
        
        Map paramMap = new HashMap();
        paramMap.put("S_COMP_CODE", loginVO.getCompCode());
        Map<String, Object> rMap = (Map<String, Object>)agj200ukrService.selectOption(paramMap);
        
        Map<String, Object> amtPoint = (Map<String, Object>)accntCommonService.fnGetAmtPoint(paramMap);
        model.addAttribute("gsAmtPoint", ( ObjUtils.isNotEmpty(amtPoint.get("AMT_POINT")) ? amtPoint.get("AMT_POINT") : 0 ));
        
        model.addAttribute("gsDivChangeYN", rMap.get("DIV_CHANGE_YN"));	//'귀속부서 입력시 사업장 자동 변경 사용여부
        model.addAttribute("gsDivUseYN", rMap.get("DIV_CODE_USE"));	//'사업장 입력조건 사용
        model.addAttribute("gsRemarkCopy", rMap.get("REMARK_COPY"));		//'전표_적요 copy방식_적요 빈 값 상태에서 Enter칠 때 copy
        model.addAttribute("gsAmtEnter", rMap.get("AMT_ENTER"));			//'전표_금액이 0이면 마지막 행에서 Enter안넘어감(부가세 제외)
        
        Map cashAccntMap = (Map)agj100ukrService.getCashAccnt(paramMap);
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
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
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
        
        return JSP_PATH + "agj205ukr";
    }
    
    /**
     * 회계전표 보완(전표번호별)
     * 
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked", "unused" } )
    @RequestMapping( value = "/accnt/agj206ukr.do" )
    public String agj206ukr( LoginVO loginVO, ModelMap model ) throws Exception {
        
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
        Map<String, Object> maxSlipNumMap = (Map<String, Object>)agj200ukrService.getSlipNum(param1);
        model.addAttribute("initAcDate", toDaty);
        model.addAttribute("initSlipNum", maxSlipNumMap.get("SLIP_NUM"));
        
        Map param3 = new HashMap();
        param3.put("S_COMP_CODE", loginVO.getCompCode());
        param3.put("S_USER_ID", loginVO.getUserID());
        Map chargeMap = (Map)accntCommonService.fnGetChargeInfo(param3);
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
        
        Map paramMap = new HashMap();
        paramMap.put("S_COMP_CODE", loginVO.getCompCode());
        Map<String, Object> rMap = (Map<String, Object>)agj200ukrService.selectOption(paramMap);
        
        Map<String, Object> amtPoint = (Map<String, Object>)accntCommonService.fnGetAmtPoint(paramMap);
        model.addAttribute("gsAmtPoint", ( ObjUtils.isNotEmpty(amtPoint.get("AMT_POINT")) ? amtPoint.get("AMT_POINT") : 0 ));
        
        model.addAttribute("gsDivChangeYN", rMap.get("DIV_CHANGE_YN"));	//'귀속부서 입력시 사업장 자동 변경 사용여부
        model.addAttribute("gsDivUseYN", rMap.get("DIV_CODE_USE"));	//'사업장 입력조건 사용
        model.addAttribute("gsRemarkCopy", rMap.get("REMARK_COPY"));		//'전표_적요 copy방식_적요 빈 값 상태에서 Enter칠 때 copy
        model.addAttribute("gsAmtEnter", rMap.get("AMT_ENTER"));			//'전표_금액이 0이면 마지막 행에서 Enter안넘어감(부가세 제외)
        
        Map cashAccntMap = (Map)agj100ukrService.getCashAccnt(paramMap);
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
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = codeInfo.getCodeInfo("A083", "400");
        if (cdo != null) {
        	model.addAttribute("reportUrl", ObjUtils.nvlObj(cdo.getCodeName(), "/accnt/agj270crkr.do"));
            model.addAttribute("reportPrgID", ObjUtils.nvlObj(cdo.getRefCode1(), "agj270rkr"));
        } else {
        	model.addAttribute("reportUrl", "/accnt/agj270crkr.do");
            model.addAttribute("reportPrgID", "agj270rkr");
        }
        
        //전표_귀속부서 팝업창 오픈시 검색어 공백 처리
        CodeDetailVO inDeptCodeBlankYN = codeInfo.getCodeInfo("A165", "75");
        if (inDeptCodeBlankYN != null) {
        	model.addAttribute("inDeptCodeBlankYN", GStringUtils.toUpperCase(ObjUtils.nvl(ObjUtils.getSafeString(inDeptCodeBlankYN.getRefCode1()),"N")));
        } else {
        	model.addAttribute("inDeptCodeBlankYN", "N");
        }
        
        return JSP_PATH + "agj206ukr";
    }
    
    /**
     * 전표조회
     * 
     * @return
     * @throws Exception
     */
	@SuppressWarnings( { "rawtypes", "unused" } )
	@RequestMapping( value = "/accnt/agj240skr.do" )
	public String agj240skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE", loginVO.getCompCode());
		
		Map chargeMap = (Map)accntCommonService.fnGetChargeInfo(param);//부서구분-> 1:회계부서,2:현업부서
		if (ObjUtils.isNotEmpty(chargeMap)) {
		    //            model.addAttribute("chargeCode", chargeMap.get("CHARGE_CODE"));
		    //            model.addAttribute("chargeName", chargeMap.get("CHARGE_NAME"));
		    model.addAttribute("gsChargeDivi", chargeMap.get("CHARGE_DIVI"));
		    //            model.addAttribute("gsChargePNumb", chargeMap.get("CHARGE_PNUMB"));
		    //            model.addAttribute("gsChargePName", chargeMap.get("CHARGE_PNAME"));
		} else {
		    
		    //            model.addAttribute("chargeCode", "");
		    //            model.addAttribute("chargeName", "");
		    model.addAttribute("gsChargeDivi", "");
		    //            model.addAttribute("gsChargePNumb", "");
		    //            model.addAttribute("gsChargePName", "");
		}
		
		boolean isKDG = false;
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		List<CodeDetailVO> gsSiteGubun = codeInfo.getCodeList("B259", "", false);		//모듈별 출력 설정에서 ClipReport추가로 인한 리포트 프로그램 설정값 가져오기(크리스탈,jasper 또는 ClipReport)
		for(CodeDetailVO map : gsSiteGubun)	{
			if("KDG".equals(map.getCodeName()))	{
				isKDG = true;
			}
		}
		
		if (isKDG) {
			model.addAttribute("exSlipPgmID", "agj106ukr");
		} else {
			model.addAttribute("exSlipPgmID", "agj105ukr");
		}
		
		return JSP_PATH + "agj240skr";
    }
    
    /**
     * 전표조회 - Excel 다운로드
     * 
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @RequestMapping( value = "/accnt/agj240excel.do" )
    public ModelAndView agj240excel( ExtHtttprequestParam _req, LoginVO loginVO ) throws Exception {
        AES256DecryptoUtils decrypto = new AES256DecryptoUtils();
        String excelFileName = "전표조회목록";
        
        SXSSFWorkbook workbook = new SXSSFWorkbook();
        Sheet sheet = workbook.createSheet("Sheet1");
        Row headerRow = null;
        Row row = null;
        
        DataFormat formet = workbook.createDataFormat();
        
        // Style 00 : 기본
        CellStyle style00 = workbook.createCellStyle();
        style00.setBorderBottom(CellStyle.BORDER_HAIR);
        style00.setBorderLeft(CellStyle.BORDER_HAIR);
        style00.setBorderRight(CellStyle.BORDER_HAIR);
        style00.setBorderTop(CellStyle.BORDER_HAIR);
        
        // Style 01 : 중앙정렬
        CellStyle style01 = workbook.createCellStyle();
        style01.setBorderBottom(CellStyle.BORDER_HAIR);
        style01.setBorderLeft(CellStyle.BORDER_HAIR);
        style01.setBorderRight(CellStyle.BORDER_HAIR);
        style01.setBorderTop(CellStyle.BORDER_HAIR);
        style01.setAlignment(CellStyle.ALIGN_CENTER);
        style01.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        
        // Style 03 : 숫자
        CellStyle style03 = workbook.createCellStyle();
        style03.setBorderBottom(CellStyle.BORDER_HAIR);
        style03.setBorderLeft(CellStyle.BORDER_HAIR);
        style03.setBorderRight(CellStyle.BORDER_HAIR);
        style03.setBorderTop(CellStyle.BORDER_HAIR);
        style03.setDataFormat(formet.getFormat("#,##0"));
        
        headerRow = sheet.createRow(0);
        
        String[] titleA = { "전표일", "번호", "순번", "계정코드", "계정과목명", "차변금액", "대변금액", "적요", "거래처코드", "거래처명", "사업장", "귀속부서코드", "귀속부서명", "관리항목1", "관리항목1", "관리항목명1", "관리항목2", "관리항목2", "관리항목명2", "관리항목3", "관리항목3", "관리항목명3", "관리항목4", "관리항목4", "관리항목명4", "관리항목5", "관리항목5", "관리항목명5", "관리항목6", "관리항목6", "관리항목명6", "증빙유형", "신용카드/현금영수증번호", "불공제사유", "결의일", "번호", "화폐단위", "환율", "외화금액", "입력자", "입력일", "승인자", "승인일", "승인시작일", "승인종료일", "POSTIT_YN", "POSTIT", "POSTIT_USER_ID", "INPUT_PATH", "MOD_DIVI", "ACCNT_DIV_CODE", "AUTO_NUM", "INPUT_DIVI" };
        
        logger.info("titleA.length :: {}", titleA.length);
        
        // Header Cell 생성
        for (int j = 0; j < titleA.length; j++) {
            headerRow.createCell(j);
        }
        
        // Header Title
        for (int j = 0; j < titleA.length; j++) {
            headerRow.getCell(j).setCellValue(titleA[j]);
        }
        
        // Header Style
        for (int j = 0; j < titleA.length; j++) {
            headerRow.getCell(j).setCellStyle(style01);
        }
        
        // Header Width
        for (int j = 0; j < titleA.length; j++) {
            sheet.setColumnWidth(j, 18 * 256);  //  n * 256의 형태로 한 이유는 1글자가 256의 크기를 갖기 때문 ....
        }
        
        logger.info("ACCNT_DIV_CODE :: {}", _req.getParameterValues("ACCNT_DIV_CODE"));
        String[] accntDivCode = _req.getParameterValues("ACCNT_DIV_CODE");
        List accntDivList = new ArrayList();
        for (int i = 0; i < accntDivCode.length; i++) {
            logger.info("accntDivCode[" + i + "] :: {}", accntDivCode[i]);
            if (accntDivCode[i].length() > 0) {
                accntDivList.add(accntDivCode[i]);
            }
        }
        
        Map<String, Object> param = new HashMap<String, Object>();
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        param.put("SLIP_TYPE", ( _req.getP("SLIP_TYPE") == null ) ? "" : _req.getP("SLIP_TYPE"));
        param.put("AC_DATE_FR", ( _req.getP("AC_DATE_FR") == null ) ? "" : _req.getP("AC_DATE_FR"));
        param.put("AC_DATE_TO", ( _req.getP("AC_DATE_TO") == null ) ? "" : _req.getP("AC_DATE_TO"));
        param.put("INPUT_DATE_FR", ( _req.getP("INPUT_DATE_FR") == null ) ? "" : _req.getP("INPUT_DATE_FR"));
        param.put("INPUT_DATE_TO", ( _req.getP("INPUT_DATE_TO") == null ) ? "" : _req.getP("INPUT_DATE_TO"));
        param.put("ACCNT_DIV_CODE", accntDivList);                                                                                   // 사업장은 MultiCombo
        param.put("IN_DEPT_CODE", ( _req.getP("IN_DEPT_CODE") == null ) ? "" : _req.getP("IN_DEPT_CODE"));
        param.put("IN_DEPT_NAME", ( _req.getP("IN_DEPT_NAME") == null ) ? "" : _req.getP("IN_DEPT_NAME"));
        param.put("CUSTOM_CODE", ( _req.getP("CUSTOM_CODE") == null ) ? "" : _req.getP("CUSTOM_CODE"));
        param.put("CUSTOM_NAME", ( _req.getP("CUSTOM_NAME") == null ) ? "" : _req.getP("CUSTOM_NAME"));
        param.put("SLIP_DIVI", ( _req.getP("SLIP_DIVI") == null ) ? "" : _req.getP("SLIP_DIVI"));
        param.put("AP_STS", ( _req.getP("AP_STS") == null ) ? "" : _req.getP("AP_STS"));
        param.put("AGENT_TYPE", ( _req.getP("AGENT_TYPE") == null ) ? "" : _req.getP("AGENT_TYPE"));
        param.put("DEPT_CODE", ( _req.getP("DEPT_CODE") == null ) ? "" : _req.getP("DEPT_CODE"));
        param.put("DEPT_NAME", ( _req.getP("DEPT_NAME") == null ) ? "" : _req.getP("DEPT_NAME"));
        param.put("MONEY_UNIT", ( _req.getP("MONEY_UNIT") == null ) ? "" : _req.getP("MONEY_UNIT"));
        param.put("ACCNT", ( _req.getP("ACCNT") == null ) ? "" : _req.getP("ACCNT"));
        param.put("ACCNT_NAME", ( _req.getP("ACCNT_NAME") == null ) ? "" : _req.getP("ACCNT_NAME"));
        param.put("INPUT_PATH", ( _req.getP("INPUT_PATH") == null ) ? "" : _req.getP("INPUT_PATH"));
        param.put("SLIP_NUM_FR", ( _req.getP("SLIP_NUM_FR") == null ) ? "" : _req.getP("SLIP_NUM_FR"));
        param.put("SLIP_NUM_TO", ( _req.getP("SLIP_NUM_TO") == null ) ? "" : _req.getP("SLIP_NUM_TO"));
        param.put("INCLUDE_DELETE", ( _req.getP("INCLUDE_DELETE").equals("false") ) ? "N" : _req.getP("INCLUDE_DELETE"));
        param.put("POSTIT", ( _req.getP("POSTIT") == null ) ? "" : _req.getP("POSTIT"));
        param.put("EX_NUM_FR", ( _req.getP("EX_NUM_FR") == null ) ? "" : _req.getP("EX_NUM_FR"));
        param.put("EX_NUM_TO", ( _req.getP("EX_NUM_TO") == null ) ? "" : _req.getP("EX_NUM_TO"));
        param.put("AMT_I_FR", ( _req.getP("AMT_I_FR") == null ) ? "" : _req.getP("AMT_I_FR"));
        param.put("AMT_I_TO", ( _req.getP("AMT_I_TO") == null ) ? "" : _req.getP("AMT_I_TO"));
        param.put("FOR_AMT_I_FR", ( _req.getP("FOR_AMT_I_FR") == null ) ? "" : _req.getP("FOR_AMT_I_FR"));
        param.put("FOR_AMT_I_TO", ( _req.getP("FOR_AMT_I_TO") == null ) ? "" : _req.getP("FOR_AMT_I_TO"));
        param.put("CHARGE_CODE", ( _req.getP("CHARGE_CODE") == null ) ? "" : _req.getP("CHARGE_CODE"));
        param.put("REMARK", ( _req.getP("REMARK") == null ) ? "" : _req.getP("REMARK"));
        param.put("POSTIT_YN", ( _req.getP("POSTIT_YN").equals("false") ) ? "N" : _req.getP("POSTIT_YN"));
        param.put("INCLUD_YN", ( _req.getP("INCLUD_YN").equals("false") ) ? "N" : _req.getP("INCLUD_YN"));
        
        logger.info("param :: {}", param);
        
        List<Map<String, Object>> list01 = agj240skrService.selectExcelList(param);
        
        /*******************************************************************************************
         * 0. Excel 다운로드 시작
         *******************************************************************************************/
        
        if (list01.size() > 0) {
            
            int i = 0;
            int j = 0;
            
            for (Map<String, Object> map : list01) {
                ++i;
                row = sheet.createRow(i);
                
                double SLIP_NUM = map.get("SLIP_NUM") == null ? 0 : ( (BigDecimal)map.get("SLIP_NUM") ).doubleValue();
                double SLIP_SEQ = map.get("SLIP_SEQ") == null ? 0 : ( (BigDecimal)map.get("SLIP_SEQ") ).doubleValue();
                
                row.createCell(j++).setCellValue((String)map.get("AC_DATE"));             // 전표일
                row.createCell(j++).setCellValue(SLIP_NUM);                               // 번호 
                row.createCell(j++).setCellValue(SLIP_SEQ);                               // 순번
                row.createCell(j++).setCellValue((String)map.get("ACCNT"));               // 계정코드
                row.createCell(j++).setCellValue((String)map.get("ACCNT_NAME"));          // 계정과목명
                
                double DR_AMT_I = map.get("DR_AMT_I") == null ? 0 : ( (BigDecimal)map.get("DR_AMT_I") ).doubleValue();
                double CR_AMT_I = map.get("CR_AMT_I") == null ? 0 : ( (BigDecimal)map.get("CR_AMT_I") ).doubleValue();
                
                row.createCell(j++).setCellValue(DR_AMT_I);                                // 차변금액
                row.createCell(j++).setCellValue(CR_AMT_I);                                // 대변금액
                row.createCell(j++).setCellValue((String)map.get("REMARK"));               // 적요
                row.createCell(j++).setCellValue((String)map.get("CUSTOM_CODE"));          // 거래처코드      
                row.createCell(j++).setCellValue((String)map.get("CUSTOM_NAME"));          // 거래처명       
                row.createCell(j++).setCellValue((String)map.get("DIV_NAME"));             // 사업장
                row.createCell(j++).setCellValue((String)map.get("DEPT_CODE"));            // 귀속부서코드
                row.createCell(j++).setCellValue((String)map.get("DEPT_NAME"));            // 귀속부서명
                row.createCell(j++).setCellValue((String)map.get("AC_CODE1"));             // 관리항목1
                row.createCell(j++).setCellValue((String)map.get("AC_DATA1"));             // 관리항목1
                row.createCell(j++).setCellValue((String)map.get("AC_DATA_NAME1"));        // 관리항목명1
                row.createCell(j++).setCellValue((String)map.get("AC_CODE2"));             // 관리항목2
                row.createCell(j++).setCellValue((String)map.get("AC_DATA2"));             // 관리항목2
                row.createCell(j++).setCellValue((String)map.get("AC_DATA_NAME2"));        // 관리항목명2
                row.createCell(j++).setCellValue((String)map.get("AC_CODE3"));             // 관리항목3
                row.createCell(j++).setCellValue((String)map.get("AC_DATA3"));             // 관리항목3
                row.createCell(j++).setCellValue((String)map.get("AC_DATA_NAME3"));        // 관리항목명3
                row.createCell(j++).setCellValue((String)map.get("AC_CODE4"));             // 관리항목4
                row.createCell(j++).setCellValue((String)map.get("AC_DATA4"));             // 관리항목4
                row.createCell(j++).setCellValue((String)map.get("AC_DATA_NAME4"));        // 관리항목명4
                row.createCell(j++).setCellValue((String)map.get("AC_CODE5"));             // 관리항목5
                row.createCell(j++).setCellValue((String)map.get("AC_DATA5"));             // 관리항목5
                row.createCell(j++).setCellValue((String)map.get("AC_DATA_NAME5"));        // 관리항목명5
                row.createCell(j++).setCellValue((String)map.get("AC_CODE6"));             // 관리항목6
                row.createCell(j++).setCellValue((String)map.get("AC_DATA6"));             // 관리항목6
                row.createCell(j++).setCellValue((String)map.get("AC_DATA_NAME6"));        // 관리항목명6
                row.createCell(j++).setCellValue((String)map.get("PROOF_KIND"));           // 증빙유형 		
                
                if (map.get("CREDIT_NUM_EXPOS") == null || ( (String)map.get("CREDIT_NUM_EXPOS") ).length() == 0) {
                    row.createCell(j++).setCellValue("");    // 신용카드/현금영수증번호
                } else {
                    row.createCell(j++).setCellValue(decrypto.getDecrypto("1", (String)map.get("CREDIT_NUM_EXPOS")));    // 신용카드/현금영수증번호
                }
                
                double EX_NUM = map.get("EX_NUM") == null ? 0 : ( (BigDecimal)map.get("EX_NUM") ).doubleValue();
                double EXCHG_RATE_O = map.get("EXCHG_RATE_O") == null ? 0 : ( (BigDecimal)map.get("EXCHG_RATE_O") ).doubleValue();
                double FOR_AMT_I = map.get("FOR_AMT_I") == null ? 0 : ( (BigDecimal)map.get("FOR_AMT_I") ).doubleValue();
                double AUTO_NUM = map.get("AUTO_NUM") == null ? 0 : ( (Long)map.get("AUTO_NUM") ).doubleValue();
                
                row.createCell(j++).setCellValue((String)map.get("REASON_CODE"));         // 불공제사유
                row.createCell(j++).setCellValue((String)map.get("EX_DATE"));             // 결의일
                row.createCell(j++).setCellValue(EX_NUM);                                 // 번호
                row.createCell(j++).setCellValue((String)map.get("MONEY_UNIT"));          // 화폐단위
                row.createCell(j++).setCellValue(EXCHG_RATE_O);                           // 환율
                row.createCell(j++).setCellValue(FOR_AMT_I);                              // 외화금액
                row.createCell(j++).setCellValue((String)map.get("CHARGE_NAME"));         // 입력자
                row.createCell(j++).setCellValue((String)map.get("INPUT_DATE"));          // 입력일
                row.createCell(j++).setCellValue((String)map.get("AP_CHARGE_NAME"));      // 승인자
                row.createCell(j++).setCellValue((String)map.get("AP_DATE"));             // 승인일
                row.createCell(j++).setCellValue((String)map.get("AC_DATE_FR"));          // 승인시작일
                row.createCell(j++).setCellValue((String)map.get("AC_DATE_TO"));          // 승인종료일
                row.createCell(j++).setCellValue((String)map.get("POSTIT_YN"));           // POSTIT_YN
                row.createCell(j++).setCellValue((String)map.get("POSTIT"));              // POSTIT
                row.createCell(j++).setCellValue((String)map.get("POSTIT_USER_ID"));      // POSTIT_USER_ID
                row.createCell(j++).setCellValue((String)map.get("INPUT_PATH"));          // INPUT_PATH
                row.createCell(j++).setCellValue((String)map.get("MOD_DIVI"));            // MOD_DIVI
                row.createCell(j++).setCellValue((String)map.get("ACCNT_DIV_CODE"));      // ACCNT_DIV_CODE
                row.createCell(j++).setCellValue(AUTO_NUM);                               // AUTO_NUM
                row.createCell(j++).setCellValue((String)map.get("INPUT_DIVI"));          // INPUT_DIVI
                
                j = 0;
                
                row.getCell(j++).setCellStyle(style00);
                row.getCell(j++).setCellStyle(style00);
                row.getCell(j++).setCellStyle(style00);
                row.getCell(j++).setCellStyle(style00);
                row.getCell(j++).setCellStyle(style00);
                row.getCell(j++).setCellStyle(style03);  // 숫자
                row.getCell(j++).setCellStyle(style03);  // 숫자
                row.getCell(j++).setCellStyle(style00);
                row.getCell(j++).setCellStyle(style00);
                row.getCell(j++).setCellStyle(style00);
                row.getCell(j++).setCellStyle(style00);
                row.getCell(j++).setCellStyle(style00);
                row.getCell(j++).setCellStyle(style00);
                row.getCell(j++).setCellStyle(style00);
                row.getCell(j++).setCellStyle(style00);
                row.getCell(j++).setCellStyle(style00);
                row.getCell(j++).setCellStyle(style00);
                row.getCell(j++).setCellStyle(style00);
                row.getCell(j++).setCellStyle(style00);
                row.getCell(j++).setCellStyle(style00);
                row.getCell(j++).setCellStyle(style00);
                row.getCell(j++).setCellStyle(style00);
                row.getCell(j++).setCellStyle(style00);
                row.getCell(j++).setCellStyle(style00);
                row.getCell(j++).setCellStyle(style00);
                row.getCell(j++).setCellStyle(style00);
                row.getCell(j++).setCellStyle(style00);
                row.getCell(j++).setCellStyle(style00);
                row.getCell(j++).setCellStyle(style00);
                row.getCell(j++).setCellStyle(style00);
                row.getCell(j++).setCellStyle(style00);
                row.getCell(j++).setCellStyle(style00);
                row.getCell(j++).setCellStyle(style00);
                row.getCell(j++).setCellStyle(style00);
                row.getCell(j++).setCellStyle(style00);
                row.getCell(j++).setCellStyle(style03);  // 숫자
                row.getCell(j++).setCellStyle(style00);
                row.getCell(j++).setCellStyle(style03);  // 숫자
                row.getCell(j++).setCellStyle(style03);  // 숫자
                row.getCell(j++).setCellStyle(style00);
                row.getCell(j++).setCellStyle(style00);
                row.getCell(j++).setCellStyle(style00);
                row.getCell(j++).setCellStyle(style00);
                row.getCell(j++).setCellStyle(style00);
                row.getCell(j++).setCellStyle(style00);
                row.getCell(j++).setCellStyle(style00);
                row.getCell(j++).setCellStyle(style00);
                row.getCell(j++).setCellStyle(style00);
                row.getCell(j++).setCellStyle(style00);
                row.getCell(j++).setCellStyle(style00);
                row.getCell(j++).setCellStyle(style00);
                row.getCell(j++).setCellStyle(style03);  // 숫자
                row.getCell(j++).setCellStyle(style00);
                
                j = 0;
            }
        }
        
        return ViewHelper.getExcelDownloadView(workbook, excelFileName);
    }
    
    /**
     * 전표조회(전표번호별)
     * 
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unused" } )
    @RequestMapping( value = "/accnt/agj245skr.do" )
    public String agj245skr( String popupID, ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        
        Map chargeMap = (Map)accntCommonService.fnGetChargeInfo(param);//부서구분-> 1:회계부서,2:현업부서
        if (ObjUtils.isNotEmpty(chargeMap)) {
            //            model.addAttribute("chargeCode", chargeMap.get("CHARGE_CODE"));
            //            model.addAttribute("chargeName", chargeMap.get("CHARGE_NAME"));
            model.addAttribute("gsChargeDivi", chargeMap.get("CHARGE_DIVI"));
            //            model.addAttribute("gsChargePNumb", chargeMap.get("CHARGE_PNUMB"));
            //            model.addAttribute("gsChargePName", chargeMap.get("CHARGE_PNAME"));
        } else {
            
            //            model.addAttribute("chargeCode", "");
            //            model.addAttribute("chargeName", "");
            model.addAttribute("gsChargeDivi", "");
            //            model.addAttribute("gsChargePNumb", "");
            //            model.addAttribute("gsChargePName", "");
        }
        
        return JSP_PATH + "agj245skr";
    }
    
    /**
     * 전표출력
     * 
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "unused" } )
    @RequestMapping( value = "/accnt/agj270skr.do", method = RequestMethod.GET )
    public String agj270skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;
        //입력자 코드/명
        param.put("S_USER_ID", loginVO.getUserID());
        Map chargeMap = (Map)accntCommonService.fnGetChargeInfo(param);
        if (ObjUtils.isNotEmpty(chargeMap)) {
            model.addAttribute("chargeCode", chargeMap.get("CHARGE_CODE"));
            model.addAttribute("chargeName", chargeMap.get("CHARGE_NAME"));
            model.addAttribute("chargeDivi", chargeMap.get("CHARGE_DIVI"));
            model.addAttribute("chargePNumb", chargeMap.get("CHARGE_PNUMB"));
        } else {
        	model.addAttribute("chargeCode", "");
            model.addAttribute("chargeName", "");
            model.addAttribute("chargeDivi", "");
            model.addAttribute("chargePNumb", "");
        }
        //List<Map<String, Object>> getReturnYn = accntCommonService.fnGetAccntBasicInfo(param);		//프린트		
        //model.addAttribute("getReturnYn",ObjUtils.toJsonStr(getReturnYn));
        
        return JSP_PATH + "agj270skr";
    }
    
    /**
     * 관리항목별전표조회
     * 
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/accnt/agj250skr.do" )
    public String agj250skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        
        List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);		//당기시작년월		
        model.addAttribute("getStDt", ObjUtils.toJsonStr(getStDt));
        
        List<Map<String, Object>> getChargeCode = accntCommonService.fnGetChargeCode(param, loginVO);		// ChargeCode관련			
        model.addAttribute("getChargeCode", ObjUtils.toJsonStr(getChargeCode));
        return JSP_PATH + "agj250skr";
    }
    
    /**
     * 기초잔액등록
     * 
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @RequestMapping( value = "/accnt/agj800ukr.do" )
    public String agj800ukr( LoginVO loginVO, ModelMap model ) throws Exception {
    	
    	Map param1 = new HashMap();
        param1.put("DIV_CODE", loginVO.getDivCode());
        param1.put("S_COMP_CODE", loginVO.getCompCode());
        Map<String, Object> amtPoint = (Map<String, Object>)accntCommonService.fnGetAmtPoint(param1);
        model.addAttribute("gsAmtPoint", ( ObjUtils.isNotEmpty(amtPoint.get("AMT_POINT")) ? amtPoint.get("AMT_POINT") : 0 ));
        
        Map param3 = new HashMap();
        param3.put("S_COMP_CODE", loginVO.getCompCode());
        param3.put("S_USER_ID", loginVO.getUserID());
        Map chargeMap = (Map)accntCommonService.fnGetChargeInfo(param3);
        
        model.addAttribute("gsChargeCD", ObjUtils.isNotEmpty(chargeMap) ? chargeMap.get("CHARGE_CODE") : "");
        
        Map<String, Object> stdate = agj800ukrService.selectStdt(loginVO);
        model.addAttribute("gsSTDT", ObjUtils.isNotEmpty(stdate) ? stdate.get("STDT") : "");
        
        return JSP_PATH + "agj800ukr";
    }
    
    /**
     * 자동기표 등록
     * 
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked", "unused" } )
    @RequestMapping( value = "/accnt/agj260ukr.do" )
    public String agj260ukr( String popupID, ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        List<CodeDetailVO> MoneyUnit = codeInfo.getCodeList("B004", "", false);
        
        for (CodeDetailVO map : MoneyUnit) {
            if ("Y".equals(map.getRefCode1())) {
                model.addAttribute("gsLocalMoney", map.getCodeNo());
            }
        }
        
        Map param1 = new HashMap();
        param1.put("DIV_CODE", loginVO.getDivCode());
        param1.put("S_COMP_CODE", loginVO.getCompCode());
        Map billDivMap = (Map)accntCommonService.fnGetBillDivCode(param1);
        model.addAttribute("gsBillDivCode", ObjUtils.isNotEmpty(billDivMap) ? billDivMap.get("BILL_DIV_CODE") : "");
        
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
            model.addAttribute("gsChargePNumb", chargeMap.get("CHARGE_PNUMB"));
            model.addAttribute("gsChargePName", chargeMap.get("CHARGE_PNAME"));
        } else {
            model.addAttribute("chargeCode", "");
            model.addAttribute("chargeName", "");
            model.addAttribute("gsChargePNumb", "");
            model.addAttribute("gsChargePName", "");
        }
        
        Map paramMap = new HashMap();
        paramMap.put("S_COMP_CODE", loginVO.getCompCode());
        Map<String, Object> rMap = (Map<String, Object>)agj100ukrService.selectOption(paramMap);
        
        model.addAttribute("gbAutoMappingA6", rMap.get("ID_AUTOMAPPING"));	//'결의전표 관리항목 사번에 로그인정보 자동매핑함
        model.addAttribute("gsDivChangeYN", rMap.get("DIV_CHANGE_YN"));	//'귀속부서 입력시 사업장 자동 변경 사용여부
        model.addAttribute("gsRemarkCopy", rMap.get("REMARK_COPY"));		//'전표_적요 copy방식_적요 빈 값 상태에서 Enter칠 때 copy
        model.addAttribute("gsAmtEnter", rMap.get("AMT_ENTER"));			//'전표_금액이 0이면 마지막 행에서 Enter안넘어감(부가세 제외)
        
        Map cashAccntMap = (Map)agj100ukrService.getCashAccnt(paramMap);
        Map accParam = new HashMap();
        accParam.put("ACCNT_CD", ObjUtils.getSafeString(cashAccntMap.get("ACCNT")));
        Map<String, Object> cashAccnt = (Map<String, Object>)accntCommonService.fnGetAccntInfo(accParam, loginVO);
        String strCashAccnt = "{";
        for (String key : cashAccnt.keySet()) {
            if (ObjUtils.isNotEmpty(cashAccnt.get(key))) {
                strCashAccnt += "'" + key + "' : '" + cashAccnt.get(key) + "',";
            }
        }
        if (strCashAccnt.length() > 1) {
            strCashAccnt = strCashAccnt.substring(0, strCashAccnt.length() - 1) + "}";
        } else {
            strCashAccnt = "{}";
        }
        model.addAttribute("cashAccntInfo", strCashAccnt);
        
        List<ComboItemModel> inputPath = comboService.getComboList("AU", "A011", loginVO, null, null);
        List<ComboItemModel> comboInputPath = new ArrayList<ComboItemModel>();
        for (ComboItemModel map : inputPath) {
            if (!"Z0".equals(map.getRefCode2())) {
                comboInputPath.add(map);
            }
        }
        model.addAttribute("comboInputPath", comboInputPath);
        
        Map<String, Object> amtPoint = (Map<String, Object>)accntCommonService.fnGetAmtPoint(param1);
        model.addAttribute("gsAmtPoint", ( ObjUtils.isNotEmpty(amtPoint.get("AMT_POINT")) ? amtPoint.get("AMT_POINT") : 0 ));
        
        
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
        CodeDetailVO cdo2 = codeInfo.getCodeInfo("A083", "400");
        if (cdo2 != null) {
        	model.addAttribute("reportUrl", ObjUtils.nvlObj(cdo2.getCodeName(), "/accnt/agj270crkr.do"));
            model.addAttribute("reportPrgID", ObjUtils.nvlObj(cdo2.getRefCode1(), "agj270rkr"));
        } else {
        	model.addAttribute("reportUrl", "/accnt/agj270crkr.do");
            model.addAttribute("reportPrgID", "agj270rkr");
        }
        
        //전표_귀속부서 팝업창 오픈시 검색어 공백 처리
        CodeDetailVO inDeptCodeBlankYN = codeInfo.getCodeInfo("A165", "75");
        if (inDeptCodeBlankYN != null) {
        	model.addAttribute("inDeptCodeBlankYN", GStringUtils.toUpperCase(ObjUtils.nvl(ObjUtils.getSafeString(inDeptCodeBlankYN.getRefCode1()),"N")));
        } else {
        	model.addAttribute("inDeptCodeBlankYN", "N");
        }
        
        return JSP_PATH + "agj260ukr";
    }
    
    /**
     * 전표승인
     * 
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @RequestMapping( value = "/accnt/agj230ukr.do" )
    public String agj230ukr( String popupID, ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        
        List<CodeDetailVO> apYn = codeInfo.getCodeList("A014", "", false);
        
        for (CodeDetailVO map : apYn) {
            if ("Y".equals(map.getRefCode1())) {
                model.addAttribute("gsDefaultApsts", map.getCodeNo());
            }
        }
        
        CodeDetailVO autoLoadYn = codeInfo.getCodeInfo("A165", "50");
        model.addAttribute("gsAutoReQuery", autoLoadYn.getRefCode1());
        
        Map param1 = new HashMap();
        param1.put("COL", "SLIP_NUM2");
        param1.put("S_COMP_CODE", loginVO.getCompCode());
        
        Map rMap1 = (Map)accntCommonService.fnGetAccntBasicInfo_a(param1);
        model.addAttribute("gsAutoSlipNum", ObjUtils.getSafeString(rMap1.get("OPTION")));
        
        Map param3 = new HashMap();
        param3.put("S_COMP_CODE", loginVO.getCompCode());
        param3.put("S_USER_ID", loginVO.getUserID());
        Map chargeMap = (Map)accntCommonService.fnGetChargeInfo(param3);
        if (ObjUtils.isNotEmpty(chargeMap)) {
            model.addAttribute("chargeCode", chargeMap.get("CHARGE_CODE"));
            model.addAttribute("chargeName", chargeMap.get("CHARGE_NAME"));
            model.addAttribute("chargeDivi", chargeMap.get("CHARGE_DIVI"));
            model.addAttribute("chargePNumb", chargeMap.get("CHARGE_PNUMB"));
        } else {
            
            model.addAttribute("chargeCode", "");
            model.addAttribute("chargeName", "");
            model.addAttribute("chargeDivi", "");
            model.addAttribute("chargePNumb", "");
        }
        
        //전표_귀속부서 팝업창 오픈시 검색어 공백 처리
        CodeDetailVO inDeptCodeBlankYN = codeInfo.getCodeInfo("A165", "75");
        if (inDeptCodeBlankYN != null) {
        	model.addAttribute("inDeptCodeBlankYN", GStringUtils.toUpperCase(ObjUtils.nvl(ObjUtils.getSafeString(inDeptCodeBlankYN.getRefCode1()),"N")));
        } else {
        	model.addAttribute("inDeptCodeBlankYN", "N");
        }

		boolean isKDG = false;
		List<CodeDetailVO> gsSiteGubun = codeInfo.getCodeList("B259", "", false);		//모듈별 출력 설정에서 ClipReport추가로 인한 리포트 프로그램 설정값 가져오기(크리스탈,jasper 또는 ClipReport)
		for(CodeDetailVO map : gsSiteGubun)	{
			if("KDG".equals(map.getCodeName()))	{
				isKDG = true;
			}
		}
		
		if (isKDG) {
			model.addAttribute("exSlipPgmID", "agj106ukr");
		} else {
			model.addAttribute("exSlipPgmID", "agj105ukr");
		}

		CodeDetailVO gsShowCompNum = codeInfo.getCodeInfo("A165", "81");		//사업자등록번호 표시여부
		if (gsShowCompNum != null) {
			model.addAttribute("showCompNum", GStringUtils.toUpperCase(ObjUtils.nvl(ObjUtils.getSafeString(gsShowCompNum.getRefCode1()), "N")));
		} else {
			model.addAttribute("showCompNum", "N");
		}
		
        return JSP_PATH + "agj230ukr";
    }
    
    /**
     * 전표승인(극동용)
     * 
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @RequestMapping( value = "/accnt/agj231ukr.do" )
    public String agj231ukr( String popupID, ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        
        List<CodeDetailVO> apYn = codeInfo.getCodeList("A014", "", false);
        
        for (CodeDetailVO map : apYn) {
            if ("Y".equals(map.getRefCode1())) {
                model.addAttribute("gsDefaultApsts", map.getCodeNo());
            }
        }
        
        CodeDetailVO autoLoadYn = codeInfo.getCodeInfo("A165", "50");
        model.addAttribute("gsAutoReQuery", autoLoadYn.getRefCode1());
        
        Map param1 = new HashMap();
        param1.put("COL", "SLIP_NUM2");
        param1.put("S_COMP_CODE", loginVO.getCompCode());
        
        Map rMap1 = (Map)accntCommonService.fnGetAccntBasicInfo_a(param1);
        model.addAttribute("gsAutoSlipNum", ObjUtils.getSafeString(rMap1.get("OPTION")));
        
        Map param3 = new HashMap();
        param3.put("S_COMP_CODE", loginVO.getCompCode());
        param3.put("S_USER_ID", loginVO.getUserID());
        Map chargeMap = (Map)accntCommonService.fnGetChargeInfo(param3);
        if (ObjUtils.isNotEmpty(chargeMap)) {
            model.addAttribute("chargeCode", chargeMap.get("CHARGE_CODE"));
            model.addAttribute("chargeName", chargeMap.get("CHARGE_NAME"));
        } else {
            
            model.addAttribute("chargeCode", "");
            model.addAttribute("chargeName", "");
        }
        
        return JSP_PATH + "agj231ukr";
    }
    
    /**
     * 전표이력 일괄삭제 * @return
     * 
     * @throws Exception
     */
    @RequestMapping( value = "/accnt/agj280ukr.do" )
    public String agj280ukr( String popupID, ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        return JSP_PATH + "agj280ukr";
    }
    
    /**
     * 전표엑셀업로드
     * 
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/accnt/agj500ukr.do" )
    public String agj500ukr( LoginVO loginVO, ModelMap model ) throws Exception {
        
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        
        return JSP_PATH + "agj500ukr";
    }
    
    /**
     * 지출결의내역 조회
     * 
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/accnt/agj400skr.do" )
    public String agj400skr( ) throws Exception {
        
        return JSP_PATH + "agj400skr";
    }
    
    /**
     * 지출결의 등록
     * 
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/accnt/agj400ukr.do" )
    public String agj400ukr(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
    	final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		param.put("S_COMP_CODE", loginVO.getCompCode());
		param.put("COL","AMT_POINT");
		Map fnGetAccntBasicInfo_aMap = (Map)accntCommonService.fnGetAccntBasicInfo_a(param);
		model.addAttribute("gsAmtPoint", fnGetAccntBasicInfo_aMap.get("OPTION"));
		
		/**
		 * 공공예산관련 옵션 
		 */
		Map selectCheck1Map = (Map) agj400ukrService.selectCheck1(param);
		model.addAttribute("gsIdMapping", selectCheck1Map.get("MAPPING"));
		model.addAttribute("gsLinkedGW", selectCheck1Map.get("GWIF"));
		model.addAttribute("gsDraftRef", selectCheck1Map.get("DRAFT_REF"));
		model.addAttribute("gsDtlMaxRows", selectCheck1Map.get("DTL_MAX_ROWS"));
		model.addAttribute("gsContents", selectCheck1Map.get("CONTENTS"));
		model.addAttribute("gsMultiCode", selectCheck1Map.get("MULTI_CODE"));
		model.addAttribute("gsTotAmtIn", selectCheck1Map.get("TOT_AMT_IN"));
		model.addAttribute("gsAppBtnUse", selectCheck1Map.get("APP_BTN_USE"));
		model.addAttribute("gsPendCodeYN", selectCheck1Map.get("PEND_CODE_YN"));
		model.addAttribute("gsCrdtRef", selectCheck1Map.get("CRDT_REF"));
		model.addAttribute("gsPayDtlRef", selectCheck1Map.get("PAY_DTL_REF"));
		
		Map selectCheck3Map = (Map)agj400ukrService.selectCheck3(param);
		if(!ObjUtils.isEmpty(selectCheck3Map)){
		    model.addAttribute("gsChargeCode", selectCheck3Map.get("CHARGE_CODE"));
	        model.addAttribute("gsChargeDivi", selectCheck3Map.get("CHARGE_DIVI"));
		}		
		//화폐단위
        List<CodeDetailVO> MoneyUnit = codeInfo.getCodeList("B004", "", false);
        String gsLobalMoney = "";
        for (CodeDetailVO map : MoneyUnit) {
            if ("Y".equals(map.getRefCode1())) {
            	gsLobalMoney = map.getCodeNo();
               
            }
        }
        model.addAttribute("gsLocalMoney", gsLobalMoney);
		
        return JSP_PATH + "agj400ukr";
    }
	
	/**
	 * 결의전표업로드
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/accnt/agj130ukr.do" )
	public String agj130ukr(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("AC_ITEM_LIST", comboService.getAcItemList(param));
		
		return JSP_PATH + "agj130ukr";
	}
	
}
