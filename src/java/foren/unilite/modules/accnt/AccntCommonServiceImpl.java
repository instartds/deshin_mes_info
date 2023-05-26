package foren.unilite.modules.accnt;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.accnt.agj.Agj100ukrServiceImpl;
import foren.unilite.modules.accnt.agj.Agj200ukrServiceImpl;

@Service( "accntCommonService" )
public class AccntCommonServiceImpl extends TlabAbstractServiceImpl {
    
    private final Logger         logger = LoggerFactory.getLogger(this.getClass());
    
    @Resource( name = "agj100ukrService" )
    private Agj100ukrServiceImpl agj100ukrService;
    
    @Resource( name = "agj200ukrService" )
    private Agj200ukrServiceImpl agj200ukrService;
    
    /**
     ** 재무제표 title
     * 
     * @param param 검색항목
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "accnt" )
    public List<Map<String, Object>> fnSetFormTitle( Map param ) throws Exception {
        return super.commonDao.list("accntCommonService.fnSetFormTitle", param);
    }
    
    /**
     * 레포트 출력 방식
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_READ )
    public List<Map<String, Object>> fnGetPrintSetting( Map param ) throws Exception {
        return super.commonDao.list("accntCommonService.fnGetPrintSetting", param);
    }
    
    /**
     * 당기순이익 코드 관련
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_READ )
    public Object fnGetProfitCode( Map param ) throws Exception {
        return super.commonDao.select("accntCommonService.fnGetProfitCode", param);
    }
    
    /**
     * 분기 가져오기
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_READ )
    public Object fnGetTermDivi( Map param ) throws Exception {
        return super.commonDao.select("accntCommonService.fnGetTermDivi", param);
    }
    
    /**
     * 기수 가져오기
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_READ )
    public List<Map<String, Object>> fnGetSession( Map param ) throws Exception {
        return super.commonDao.list("accntCommonService.fnGetSession", param);
    }
    
    /**
     * 당기시작년월 조회
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_READ )
    public List<Map<String, Object>> fnGetStDt( Map param ) throws Exception {
        return super.commonDao.list("accntCommonService.fnGetStDt", param);
    }
    
    /**
     * 당기종료년월 조회
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_READ )
    public List<Map<String, Object>> fnGetToDt( Map param ) throws Exception {
        return super.commonDao.list("accntCommonService.fnGetToDt", param);
    }
    
    /**
     * 계정코드 사용자정보(회계담당자) 파라미터 / ChargeCode
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_READ )
    public List<Map<String, Object>> fnGetChargeCode( Map param, LoginVO loginVO ) throws Exception {
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        param.put("S_USER_ID", loginVO.getUserID());
        
        return super.commonDao.list("accntCommonService.fnGetChargeCode", param);
    }
    
    /**
     * 프로그램별 사용 컬럼 관련
     * 
     * @param param 검색항목
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "accnt" )
    public List<Map<String, Object>> getUseColList( Map param ) throws Exception {
        return super.commonDao.list("accntCommonService.getUseColList", param);
    }
    
    /**
     * 동적 팝업 생성을 위한 관리항목 정보 불러오기..
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_READ )
    public Object fnGetAcCode( Map param, LoginVO loginVO ) throws Exception {
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        
        return super.commonDao.select("accntCommonService.fnGetAcCode", param);
    }
    
    /**
     * 동적 팝업 생성을 위한 계정과목 정보 불러오기..
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_READ )
    public Object fnGetAccntInfo( Map param, LoginVO loginVO ) throws Exception {
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        
        return super.commonDao.select("accntCommonService.fnGetAccntInfo", param);
    }
    
    /**
     * 계좌잔액 1,2조회
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_READ )
    public List<Map<String, Object>> getBookCombo( Map param, LoginVO loginVO ) throws Exception {
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        param.put("S_USER_ID", loginVO.getUserID());
        
        return super.commonDao.list("accntCommonService.getBookCombo", param);
    }
    
    /**
     * 기초잔액등록의 계정 관리항목조회
     * 
     * @param param
     * @param loginVO
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_READ )
    public Object fnGetAccntInfoForBookCode( Map param, LoginVO loginVO ) throws Exception {
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        Map<String, Object> rtnMap = (Map<String, Object>)super.commonDao.select("accntCommonService.fnGetAccntInfo", param);
        if (ObjUtils.isNotEmpty(rtnMap)) {
            Object bookCode1 = rtnMap.get("BOOK_CODE1"), bookCode2 = rtnMap.get("BOOK_CODE2");
            param.put("USE_YN", "Y");
            
            if (ObjUtils.isNotEmpty(bookCode1)) {
                String[] acCd1 = { ObjUtils.getSafeString(bookCode1) };
                param.put("AC_CD", acCd1);
                Map<String, Object> acInfo1 = (Map<String, Object>)this.getAcInfo(param);
                
                if (ObjUtils.isNotEmpty(acInfo1)) {
                    rtnMap.put("BOOK_TYPE1", acInfo1.get("DT_TYPE"));
                    rtnMap.put("BOOK_LEN1", acInfo1.get("DT_LEN"));
                    rtnMap.put("BOOK_POPUP1", acInfo1.get("DT_POPUP"));
                    rtnMap.put("BOOK_FMT1", acInfo1.get("DT_FMT"));
                }
            }
            
            if (ObjUtils.isNotEmpty(bookCode2)) {
                String[] acCd2 = { ObjUtils.getSafeString(bookCode1) };
                param.put("AC_CD", acCd2);
                Map<String, Object> acInfo2 = (Map<String, Object>)this.getAcInfo(param);
                
                if (ObjUtils.isNotEmpty(acInfo2)) {
                    rtnMap.put("BOOK_TYPE2", acInfo2.get("DT_TYPE"));
                    rtnMap.put("BOOK_LEN2", acInfo2.get("DT_LEN"));
                    rtnMap.put("BOOK_POPUP2", acInfo2.get("DT_POPUP"));
                    rtnMap.put("BOOK_FMT2", acInfo2.get("DT_FMT"));
                }
            }
        }
        return (Object)rtnMap;
    }
    
    /**
     * 증빙유형관련 부가세율
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_READ )
    public Object fnGetTaxRate( Map param ) throws Exception {
        return super.commonDao.select("accntCommonService.fnGetTaxRate", param);
    }
    
    /**
     * ABA100T AMT_POINT 가져오기
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_READ )
    public List<Map<String, Object>> fnGetAccntBasicInfo( Map param, LoginVO loginVO ) throws Exception {
        return super.commonDao.list("accntCommonService.fnGetAccntBasicInfo", param);
    }
    
    /**
     * ass300ukr(고정자산등록) 내용년수 변경 시 상각율 조회
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_READ )
    public Object fnGetDprRate( Map param ) throws Exception {
        return super.commonDao.select("accntCommonService.fnGetDprRate", param);
    }
    
    /**
     * ass300ukr(고정자산등록) 고정자산 기본정보 조회
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_READ )
    public Object fnGetDprInfoByAccnt( Map param ) throws Exception {
        return super.commonDao.select("accntCommonService.fnGetDprInfoByAccnt", param);
    }
    
    /**
     * 화폐단위에 따른 환율 자동계산
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_READ )
    public Object fnExchgRateO( Map param ) throws Exception {
        return super.commonDao.select("accntCommonService.fnExchgRateO", param);
    }
    
    /**
     * 결제유형의 참조코드1의 값 가져오기
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_READ )
    public Object fnGetRefCodes( Map param ) throws Exception {
        return super.commonDao.select("accntCommonService.fnGetRefCodes", param);
    }
    
    /**
     * 전표번호 중복 체크
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "accnt" )
    public Object fnGetExistSlipNum( Map param ) throws Exception {
        
        Map tParam = new HashMap();
        tParam.put("S_COMP_CODE", param.get("S_COMP_CODE"));
        if ("1".equals(ObjUtils.getSafeString(param.get("GUBUN")))) {
            tParam.put("COL", "SLIP_NUM2");
        } else {
            tParam.put("COL", "SLIP_NUM1");
        }
        Map rInfo = (Map)this.fnGetAccntBasicInfo_a(tParam);
        param.put("NUMBERING_RULE", rInfo.get("OPTION"));
        
        return super.commonDao.select("accntCommonService.fnGetExistSlipNum", param);
    }
    
    /**
     * 기본 셋팅 값 가져오기
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "accnt" )
    public Object fnGetAccntBasicInfo_a( Map param ) throws Exception {
        
        return super.commonDao.select("accntCommonService.fnGetAccntBasicInfo_a", param);
    }
    
    /**
     * 계정의 상세정보를 조회
     * 
     * @param param
     * @return
     * @throws Exception
     */
    /*
     * @ExtDirectMethod(group = "accnt") public List<Map<String, Object>> fnGetAccntInfo(Map param) throws Exception { return super.commonDao.list("accntCommonService.fnGetAccntInfo", param); }
     */
    
    /**
     * 계정의 비용에 대한 메세지
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "accnt" )
    public Object fnIsCostAccnt( Map param ) throws Exception {
        return super.commonDao.select("accntCommonService.fnIsCostAccnt", param);
    }
    
    /**
     * 어음번호의 발생금액 구하기
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "accnt" )
    public Object fnGetNoteAmt( Map param ) throws Exception {
        Map rtn = (Map)super.commonDao.select("accntCommonService.fnGetNoteAmt", param);
        if (ObjUtils.isNotEmpty(rtn) && ObjUtils.isNotEmpty(param.get("PROOF_KIND"))) {
            Map texRtn = (Map)this.fnGetTaxRate(param);
            rtn.putAll(texRtn);
        }
        return rtn;
    }
    
    /**
     * 신고사업장코드 가져오기
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "accnt" )
    public Object fnGetBillDivCode( Map param ) throws Exception {
        return super.commonDao.select("accntCommonService.fnGetBillDivCode", param);
    }
    
    /**
     * 신고사업장 총괄 관련
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "accnt" )
    public Object getTaxBase( Map param ) throws Exception {
        return super.commonDao.select("accntCommonService.getTaxBase", param);
    }
    
    /**
     * 사업자등록번호&승인번호 관련
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "accnt" )
    public Object getLicenseeInform( Map param ) throws Exception {
        return super.commonDao.select("accntCommonService.getLicenseeInform", param);
    }
    
    /**
     * 사용자ID로부터 회계담당자 코드, 담당자명, 사용부서, 사번 정보 가져오기
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "accnt" )
    public Object fnGetChargeInfo( Map param ) throws Exception {
        return super.commonDao.select("accntCommonService.fnGetChargeInfo", param);
    }
    
    /**
     * 매입매출방법등록 조회 (계정정보 Merge 됨)
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "accnt" )
    public List<Map<String, Object>> fnGetAutoMethod( Map param ) throws Exception {
        int slipNum = 0;
        if ("Y1".equals(param.get("INPUT_PATH"))) {
            Map slipInfo = (Map)agj100ukrService.getSlipNum(param);
            slipNum = Integer.parseInt(ObjUtils.getSafeString(slipInfo.get("SLIP_NUM")));
        } else {
            Map slipInfo = (Map)agj200ukrService.getSlipNum(param);
            slipNum = Integer.parseInt(ObjUtils.getSafeString(slipInfo.get("SLIP_NUM")));
        }
        List<Map<String, Object>> rList = super.commonDao.list("accntCommonService.fnGetAutoMethod", param);
        for (Map rData : rList) {
            rData.put("SLIP_NUM", slipNum);
        }
        return rList;
    }
    
    /**
     * 예산과목(CODE_NAME) 관련
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_READ )
    public List<Map<String, Object>> selectBudgName( Map param, LoginVO loginVO ) throws Exception {
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        param.put("S_USER_ID", loginVO.getUserID());
        
        return super.commonDao.list("accntCommonService.selectBudgName", param);
    }
    
    /**
     * 거래처정보 관련
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_READ )
    public Object fnCustInfo( Map param ) throws Exception {
        return super.commonDao.select("accntCommonService.fnCustInfo", param);
    }
    
    /**
     * 예산사용가능금액 관련
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_READ )
    public Object fnGetBudgetPossAmt( Map param ) throws Exception {
        if (param.get("DRAFT_NO") == null) {
            param.put("DRAFT_NO", "");
        }
        if (param.get("DRAFT_SEQ") == null) {
            param.put("DRAFT_SEQ", 0);
        }
        
        return super.commonDao.select("accntCommonService.fnGetBudgetPossAmt", param);
    }
    
    /**
     * 프로젝트에 설정된 통장코드 관련
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_READ )
    public Object fnGetSaveCodeofProject( Map param ) throws Exception {
        return super.commonDao.select("accntCommonService.fnGetSaveCodeofProject", param);
    }
    
    /**
     * 공통코드의 관련코드 가져오기
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_READ )
    public Object fnGetRefCode( Map param ) throws Exception {
        return super.commonDao.select("accntCommonService.fnGetRefCode", param);
    }
    
    /**
     * 외화 환율 가져오기
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_READ )
    public Object fnGetExchgRate( Map param, LoginVO user ) throws Exception {
        Map companyRate = (Map)super.commonDao.select("accntCommonService.fnGetExchgRateQ1", param);
        if (ObjUtils.isEmpty(companyRate)) {
            throw new UniDirectValidateException(this.getMessage("54302;", user));
        }
        String excBase = ObjUtils.getSafeString(companyRate.get("EXCHG_BASE"));
        String acDate = ObjUtils.getSafeString(param.get("AC_DATE"));
        String acMonth = "";
        if (acDate != null && acDate.length() == 8) {
            acMonth = acDate.substring(0, 5);
        }
        
        if ("2".equals(excBase)) {
            param.put("AC_DATE", acMonth);
            param.put("EXCHG_DIVI", "1");
        } else {
            param.put("AC_DATE", acDate);
            param.put("EXCHG_DIVI", "2");
        }
        List<Object> rList = (List<Object>)super.commonDao.list("accntCommonService.fnGetExchgRateQ2", param);
        Object rMap = null;
        if (rList.size() == 1) {
            rMap = rList.get(0);
        } else {
            rMap = super.commonDao.select("accntCommonService.fnGetExchgRateQ3", param);
        }
        return rMap;
    }
    
    /**
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_READ )
    public Object fnGetAmtPoint( Map param ) throws Exception {
        return super.commonDao.select("accntCommonService.fnGetAmtPoint", param);
    }
    
    /**
     * 관라항목 정보
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_READ )
    public Object getAcInfo( Map param ) throws Exception {
        return super.commonDao.select("accntCommonService.getAcInfo", param);
    }
    
    /**
     * 공통코드에서 원하는 컬럼의 값을 조회
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_READ )
    public Object fnGetCommon( Map param ) throws Exception {
        return super.commonDao.select("accntCommonService.fnGetCommon", param);
    }
    
    /**
     * 로그인 ID에 따른 사번 , 사원명 관련
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "accnt" )
    public Object getPersonName( Map param, LoginVO loginVO ) throws Exception {
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        param.put("S_USER_ID", loginVO.getUserID());
        
        param.put("S_PERSON_NUMB", loginVO.getPersonNumb());
        
        return super.commonDao.select("accntCommonService.getPersonName", param);
    }
    
    /**
     * 그룹계정코드 목록
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "accnt" )
    public Object selectGroupAccntCodes( Map param) throws Exception {
        return super.commonDao.list("accntCommonService.selectGroupAccntCodes", param);
    }
    
    
    /**
     * JBILL 부서에 따른 원가구분
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_READ )
    public Object setMakeSale_J( Map param ) throws Exception {
        return super.commonDao.select("accntCommonService.setMakeSale_J", param);
    }
    
    
    /**
     * 그룹웨어 사용여부
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "accnt" )
    public Object fnGWUseYN( Map param ) throws Exception {
        return super.commonDao.select("accntCommonService.fnGWUseYN", param);
    }
    
    /**
     * 그룹웨어 결재상신경로
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_READ )
    public List<Map<String, Object>> fnGWUrl( Map param ) throws Exception {
         return super.commonDao.list("accntCommonService.fnGWUrl", param);
    }
    
    /**
     * 환자손 계정 가져오기
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_READ )
    public Object getForeignProfitAccnt( Map param , LoginVO loginVO) throws Exception {
    	param.put("S_COMP_CODE", loginVO.getCompCode());
    	Map<String, Object> accntCd = (Map<String, Object>) super.commonDao.select("accntCommonService.getForeignProfit", param);
    	//Map accntParam = accntCommonService.fnGetAccntInfo({'ACCNT_CD':accnt}
    	if(accntCd == null)	{
    		return accntCd;
    	} else {
    		return this.fnGetAccntInfo(accntCd, loginVO);
    	}
    }
    
    
    

    
    /**
     * 당기순이익 코드 관련
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_READ )
    public Object fnGetDeptcodeCode( Map param, LoginVO loginVO ) throws Exception {
    	
    	param.put("S_USER_ID", loginVO.getUserID());
    	
        return super.commonDao.select("accntCommonService.fnGetDeptcodeCode", param);
    }
}
