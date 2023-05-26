package api.rest.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import api.rest.exception.CustomException;
import api.rest.utils.RestUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.utils.AES256EncryptoUtils;

/**
 * 전표자동기표 관리
 * 
 * @author 박종영
 */
@Service( "if_agd360ukrServiceImpl" )
public class If_agd360ukrServiceImpl extends TlabAbstractServiceImpl {
    private final Logger logger   = LoggerFactory.getLogger(this.getClass());
    private RestUtils    utils    = new RestUtils();
    AES256EncryptoUtils  encrypto = new AES256EncryptoUtils();
    
    /**
     * 전표자동기표 관리 조회
     * 
     * @param paramMap
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "unchecked", "rawtypes" } )
    public List<Map<String, Object>> selectList( Map param ) throws Exception {
        return super.commonDao.list("if_agd360ukrServiceImpl.selectList", param);
    }
    
    /**
     * 오류 리스트 반환
     * 
     * @param paramMap
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    public Map selectErrorList( Map param ) throws Exception {
        return (Map)super.commonDao.select("if_agd360ukrServiceImpl.selectErrorList", param);
    }
    
    /**
     * 오류 리스트 반환(파워빌더용)
     * 
     * @param paramMap
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    public Map selectErrorListPB( Map param ) throws Exception {
        return (Map)super.commonDao.select("if_agd360ukrServiceImpl.selectErrorListPB", param);
    }
    
    /**************************************************************/
    /*********************** Web Service 용 ***********************/
    /**************************************************************/
    
    /**
     * 전표자동기표 관리 저장 ( Web Service 용 )
     * 
     * @param paramList
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public Map apiSaveAll( String jobId, Map<String, Object> param ) throws Exception {
        
        /*
         * 전표 처리 한다.
         */
        authSlipInterface(param);
        List list = super.commonDao.list("if_agd360ukrServiceImpl.selectAGD361T", param);
        //logger.info("결과 :: {}", list);
        
        /*
         * 결과를 반환한다.
         */
        param = new HashMap();
        param.put("JOB_ID", jobId);
        param.put("RESULT", list);
        
        return param;
    }
    
    /**
     * 전표자동기표 관리 저장 ( Web Service 용 )
     * 
     * @param paramList
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public Map apiSaveAllOnTran( List<Map<String, Object>> paramList ) throws Exception {
        /*
         * Job ID 생성
         */
        String jobId = utils.makeJobID();
        
        /*
         * Temp 폴더에 데이터를 Insert 한다.
         */
        Map param = saveIfAgd360T(jobId, paramList);
        
        /*
         * Temp 테이블에서 전자세금계산서_발행원장 으로 데이터를 저장 한다.
         */
        saveTempToAgd360T(jobId);
        
        /*
         * 전표 처리 한다.
         */
        authSlipInterface(param);
        List list = super.commonDao.list("if_agd360ukrServiceImpl.selectAGD361T", param);
        //logger.info("결과 :: {}", list);
        
        /*
         * 결과를 반환한다.
         */
        param = new HashMap();
        param.put("JOB_ID", jobId);
        param.put("RESULT", list);
        
        return param;
    }
    
    /**
     * 전표자동기표 관리 저장 ( Web Service 용 )
     * 
     * @param paramList
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public Map apiSaveAllPB( List<Map<String, Object>> paramList ) throws Exception {
        /*
         * Job ID 생성
         */
        String jobId = utils.makeJobID();
        
        /*
         * Temp 폴더에 데이터를 Insert 한다.
         */
        Map param = saveIfAgd360TPB(jobId, paramList);
        
        /*
         * Temp 테이블에서 전자세금계산서_발행원장 으로 데이터를 저장 한다.
         */
        saveTempToAgd360T(jobId);
        
        /*
         * 전표 처리 한다.
         */
        authSlipInterface(param);
        List list = super.commonDao.list("if_agd360ukrServiceImpl.selectAGD361T", param);
        //logger.info("결과 :: {}", list);
        
        /*
         * 결과를 반환한다.
         */
        param = new HashMap();
        param.put("JOB_ID", jobId);
        param.put("RESULT", list);
        
        return param;
    }
    
    /**
     * Temp 폴더에 데이터를 Insert 한다.
     * 
     * @param jobId
     * @param paramMstrList
     * @param paramDetailList
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public Map saveIfAgd360T( String jobId, List<Map<String, Object>> paramList ) throws Exception {
        String spName = "";
        String proBubun = "B";    // Default : B(배치)
        String ifNum = "";
        String ifSeq = "";
        String indexNum = "";
        String compCode = "";
        String appId = "";
        String ifDate = "";
        String ifTime = "";
        int inCnt = 0;
        boolean chkFlag = false;
        Map rMap = null;
        for (Map param : paramList) {
            if (chkFlag == false) {
                
                logger.debug("param :: {}", param);
                Map urlMap = (Map)super.commonDao.select("if_agd360ukrServiceImpl.getCodeFromSPName", param);
                logger.debug("urlMap :: {}", urlMap);
                if (urlMap != null) {
                    spName = (String)urlMap.get("SP_NAME");
                    proBubun = (String)urlMap.get("PRO_GUBUN");
                }
                
                chkFlag = true;
            }
            
            rMap = (Map)super.commonDao.queryForObject("commonServiceImpl.getRefCode", param);
            logger.info("rMap :: {}", rMap);
            if (rMap != null) {
                param.put("COMP_CODE", rMap.get("REF_CODE1"));
            }
            logger.info("param :: {}", param);
            
            compCode = (String)param.get("COMP_CODE");
            appId = (String)param.get("APP_ID");
            ifNum = (String)param.get("IF_NUM");
            param.put("PRO_GUBUN", proBubun);
            
            if (!( param.get("IF_SEQ") instanceof Double )) {
                ifSeq = (String)param.get("IF_SEQ");
            } else {
                ifSeq = ( (Double)param.get("IF_SEQ") ).toString();
            }
            
            indexNum = (String)param.get("INDEX_NUM");
            if (indexNum == null || "".equals(indexNum.trim())) {
                param.put("INDEX_NUM", param.get("IF_NUM"));
                ifNum = (String)param.get("IF_NUM");
            }
            param.put("JOB_ID", jobId);
            param.put("IF_DATE", ifDate = jobId.substring(0, 8));
            param.put("IF_TIME", ifTime = jobId.substring(8, jobId.length()));
            param.put("KEY_SEQNO", ifNum + "|" + ifSeq);
            param.put("S_USER_ID", ( (String)param.get("INSERT_USER") ) == null ? "WebService" : ( (String)param.get("INSERT_USER") ));
            
            // 계좌번호 암호화
            if (param.get("BANK_ACCOUNT") != null) {
                param.put("BANK_ACCOUNT", encrypto.encryto(( (String)param.get("BANK_ACCOUNT") ).trim().replaceAll("-", "")));
            } else {
                param.put("BANK_ACCOUNT", encrypto.encryto(""));
            }
            // 카드번호 암호화
            if (param.get("CRDT_NUM") != null) {
                param.put("CRDT_NUM", encrypto.encryto(( (String)param.get("CRDT_NUM") ).trim().replaceAll("-", "")));
            } else {
                param.put("CRDT_NUM", encrypto.encryto(""));
            }
            
            try {
                // Validation Check
                insertDataValidate(param);
                
                try {
                    inCnt = inCnt + super.commonDao.insert("if_agd360ukrServiceImpl.insertMulti", param);
                } catch (Exception e) {
                    logger.error(e.getMessage());
                    throw new CustomException(utils.errParse(e.getMessage()), param);
                }
            } catch (CustomException ce) {
                try {
                    param.put("PROC_ERR_MSG", ce.getErrMsg());
                    logger.error("Detail Error map :: {}", param);
                    super.commonDao.insert("if_agd360ukrServiceImpl.insertError", param);
                } catch (Exception ex) {
                    logger.error(ex.getMessage());
                }
            } catch (Exception e) {
                try {
                    param.put("PROC_ERR_MSG", e.getMessage());
                    logger.error("Detail Error map :: {}", param);
                    super.commonDao.insert("if_agd360ukrServiceImpl.insertError", param);
                } catch (Exception ex) {
                    logger.error(ex.getMessage());
                }
            }
            
        }
        
        Map rtnMap = new HashMap();
        rtnMap.put("COMP_CODE", compCode);
        rtnMap.put("APP_ID", appId);
        rtnMap.put("IF_DATE", ifDate);
        rtnMap.put("IF_TIME", ifTime);
        rtnMap.put("PRO_GUBUN", proBubun);
        rtnMap.put("SP_NAME", spName);
        rtnMap.put("TEMP_IN_CNT", "" + inCnt);
        
        return rtnMap;
    }
    
    /**
     * Temp 폴더에 데이터를 Insert 한다.
     * 
     * @param jobId
     * @param paramMstrList
     * @param paramDetailList
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    private Map saveIfAgd360TPB( String jobId, List<Map<String, Object>> paramList ) throws Exception {
        String spName = "";
        String proBubun = "R";    // Default : B(배치), R(Real)
        String ifNum = "";
        String indexNum = "";
        String compCode = "";
        String appId = "";
        String ifDate = "";
        String ifTime = "";
        boolean chkFlag = false;
        Map rMap = null;
        
        for (Map param : paramList) {
            if (chkFlag == false) {
                
                logger.debug("param :: {}", param);
                Map urlMap = (Map)super.commonDao.select("if_agd360ukrServiceImpl.getCodeFromSPName", param);
                logger.debug("urlMap :: {}", urlMap);
                if (urlMap != null) {
                    spName = (String)urlMap.get("SP_NAME");
                    proBubun = (String)urlMap.get("PRO_GUBUN");
                }
                
                chkFlag = true;
            }
            
            rMap = (Map)super.commonDao.queryForObject("commonServiceImpl.getRefCode", param);
            logger.info("rMap :: {}", rMap);
            if (rMap != null) {
                param.put("COMP_CODE", rMap.get("REF_CODE1"));
            }
            logger.info("param :: {}", param);
            
            compCode = (String)param.get("COMP_CODE");
            appId = (String)param.get("APP_ID");
            ifNum = (String)param.get("IF_NUM");
            indexNum = (String)param.get("INDEX_NUM");
            param.put("PRO_GUBUN", proBubun);
            
            if (indexNum == null || "".equals(indexNum.trim())) {
                param.put("INDEX_NUM", param.get("IF_NUM"));
                ifNum = (String)param.get("IF_NUM");
            }
            param.put("JOB_ID", jobId);
            param.put("IF_DATE", ifDate = jobId.substring(0, 8));
            param.put("IF_TIME", ifTime = jobId.substring(8, jobId.length()));
            param.put("KEY_SEQNO", ifNum);
            param.put("S_USER_ID", ( (String)param.get("INSERT_USER") ) == null ? "WebService" : ( (String)param.get("INSERT_USER") ));
            
            if (param.get("BANK_ACCOUNT") != null) {
                param.put("BANK_ACCOUNT", encrypto.encryto(( (String)param.get("BANK_ACCOUNT") ).trim().replaceAll("-", "")));
            } else {
                param.put("BANK_ACCOUNT", encrypto.encryto(""));
            }
            
            try {
                try {
                    super.commonDao.insert("if_agd360ukrServiceImpl.insertMulti", param);
                } catch (Exception e) {
                    logger.error(e.getMessage());
                    throw new CustomException(utils.errParse(e.getMessage()), param);
                }
            } catch (CustomException ce) {
                try {
                    param.put("PROC_ERR_MSG", ce.getErrMsg());
                    logger.error("Detail Error map :: {}", param);
                    super.commonDao.insert("if_agd360ukrServiceImpl.insertError", param);
                } catch (Exception ex) {
                    logger.error(ex.getMessage());
                }
            } catch (Exception e) {
                try {
                    param.put("PROC_ERR_MSG", e.getMessage());
                    logger.error("Detail Error map :: {}", param);
                    super.commonDao.insert("if_agd360ukrServiceImpl.insertError", param);
                } catch (Exception ex) {
                    logger.error(ex.getMessage());
                }
            }
            
        }
        
        Map rtnMap = new HashMap();
        rtnMap.put("COMP_CODE", compCode);
        rtnMap.put("APP_ID", appId);
        rtnMap.put("IF_DATE", ifDate);
        rtnMap.put("IF_TIME", ifTime);
        rtnMap.put("PRO_GUBUN", proBubun);
        rtnMap.put("SP_NAME", spName);
        
        return rtnMap;
    }
    
    /**
     * 전표 처리 한다.
     * 
     * @param jobId
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    private void authSlipInterface( Map param ) throws Exception {
        try {
            logger.debug("param :: {}", param);
            String SP_NAME = (String)param.get("SP_NAME");
            String PRO_GUBUN = (String)param.get("PRO_GUBUN");
            
            // 배치는 SP를 실행하지 않는다.
            if (!PRO_GUBUN.equals("B")) {
                if (SP_NAME.equals("")) {
                    param.put("SP_NAME", "USP_ACCNT_AUTOSLIP_INTERFACE_JS");
                } else {
                    param.put("SP_NAME", SP_NAME);
                }
                logger.debug("param :: {}", param);
                
                Map map = (Map)super.commonDao.select("if_agd360ukrServiceImpl.CUSTROM_SP_CALL", param);
                
                logger.info("******************************* ERROR_DESC :: {}, {}", map.get("ERROR_DESC"), param);
            }
        } catch (Exception ex) {
            logger.info("******************************* ERROR_DESC2 :: {}, {} ", ex.getMessage(), param);
            logger.error(ex.getMessage());
        }
    }
    
    /**
     * Temp 테이블에서 전자세금계산서_발행원장 으로 데이터를 저장 한다.
     * 
     * @param jobId
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public void saveTempToAgd360T( String jobId ) throws Exception {
        Map param = new HashMap();
        param.put("JOB_ID", jobId);
        
        try {
            super.commonDao.select("if_agd360ukrServiceImpl.USP_ACCNT_AGD360T", param);
        } catch (Exception ex) {
            logger.error(ex.getMessage());
        }
    }
    
    /**
     * 전표 등록, 수정 시 Validation Check
     * 
     * @param paramMap
     * @return
     */
    @SuppressWarnings( { "rawtypes" } )
    private void insertDataValidate( Map paramMap ) throws CustomException {
        if (( (String)paramMap.get("COMP_CODE") ) == null || "".equals(( (String)paramMap.get("COMP_CODE") ).trim())) {
            throw new CustomException("법인코드" + "은(는) 필수입력항목입니다.");
        }
        if (( (String)paramMap.get("APP_ID") ) == null || "".equals(( (String)paramMap.get("APP_ID") ).trim())) {
            throw new CustomException("연계어플리케이션" + "은(는) 필수입력항목입니다.");
        }
        if (( (String)paramMap.get("IF_NUM") ) == null || "".equals(( (String)paramMap.get("IF_NUM") ).trim())) {
            throw new CustomException("연계key번호" + "은(는) 필수입력항목입니다.");
        }
        if (!( paramMap.get("IF_SEQ") instanceof Double )) {
            if (( (String)paramMap.get("IF_SEQ") ) == null || "".equals(( (String)paramMap.get("IF_SEQ") ).trim())) {
                throw new CustomException("순번" + "은(는) 필수입력항목입니다.");
            }
        }
        if (( (String)paramMap.get("GUBUN_1") ) == null || "".equals(( (String)paramMap.get("GUBUN_1") ).trim())) {
            throw new CustomException("구분1" + "은(는) 필수입력항목입니다.");
        }
        if (( (String)paramMap.get("GUBUN_2") ) == null || "".equals(( (String)paramMap.get("GUBUN_2") ).trim())) {
            throw new CustomException("구분2" + "은(는) 필수입력항목입니다.");
        }
        if (( (String)paramMap.get("GUBUN_3") ) == null || "".equals(( (String)paramMap.get("GUBUN_3") ).trim())) {
            throw new CustomException("구분3" + "은(는) 필수입력항목입니다.");
        }
        if (( (String)paramMap.get("GUBUN_4") ) == null || "".equals(( (String)paramMap.get("GUBUN_4") ).trim())) {
            throw new CustomException("구분4" + "은(는) 필수입력항목입니다.");
        }
        if (( (String)paramMap.get("BILL_TYPE") ) == null || "".equals(( (String)paramMap.get("BILL_TYPE") ).trim())) {
            throw new CustomException("부가세유형" + "은(는) 필수입력항목입니다.");
        }
        if (( (String)paramMap.get("BASE_DATE") ) == null || "".equals(( (String)paramMap.get("BASE_DATE") ).trim())) {
            throw new CustomException("일자(전표일자사용)" + "은(는) 필수입력항목입니다.");
        }
        if (( (String)paramMap.get("DEPT_CODE") ) == null || "".equals(( (String)paramMap.get("DEPT_CODE") ).trim())) {
            throw new CustomException("귀속부서코드" + "은(는) 필수입력항목입니다.");
        }
        if (( (String)paramMap.get("DEPT_NAME") ) == null || "".equals(( (String)paramMap.get("DEPT_NAME") ).trim())) {
            throw new CustomException("귀속부서명" + "은(는) 필수입력항목입니다.");
        }
        /*
         * if (( (String)paramMap.get("DIV_CODE") ) == null || "".equals(( (String)paramMap.get("DIV_CODE") ).trim())) { throw new CustomException("사업장" + "은(는) 필수입력항목입니다."); }
         */
        if (!( paramMap.get("SUPPLY_AMT") instanceof Double )) {
            if (( (String)paramMap.get("SUPPLY_AMT") ) == null || "".equals(( (String)paramMap.get("SUPPLY_AMT") ).trim())) {
                throw new CustomException("매출액/수금액" + "은(는) 필수입력항목입니다.");
            }
        }
        if (( (String)paramMap.get("INSERT_USER") ) == null || "".equals(( (String)paramMap.get("INSERT_USER") ).trim())) {
            throw new CustomException("전송자ID" + "은(는) 필수입력항목입니다.");
        }
        
        // 부가세유형이 '10' 이면
        if (( (String)paramMap.get("BILL_TYPE") ) != null && "10".equals(( (String)paramMap.get("BILL_TYPE") ).trim())) {
            //logger.info("세액 :: {} ", paramMap.get("TAX_AMT"));
            if (paramMap.get("TAX_AMT") instanceof Double) {
                if (( (Double)paramMap.get("TAX_AMT") ).longValue() == 0) {
                    throw new CustomException("부가세 유형이 '10'인 경우 세액" + "은(는) 0 일 수 없습니다.");
                }
            } else {
                if (( (String)paramMap.get("TAX_AMT") ) == null || "".equals(( (String)paramMap.get("TAX_AMT") ).trim())) {
                    throw new CustomException("부가세 유형이 '10'인 경우 세액" + "은(는) null 일 수 없습니다.");
                }
                if ("0".equals(( (String)paramMap.get("TAX_AMT") ).trim()) || "0.0".equals(( (String)paramMap.get("TAX_AMT") ).trim())) {
                    throw new CustomException("부가세 유형이 '10'인 경우 세액" + "은(는) 0 일 수 없습니다.");
                }
            }
        }
        
        // 사업자 번호가 있으면 거래처명은 필수
        if (( (String)paramMap.get("COMPANY_NUM") ) != null && !"".equals(( (String)paramMap.get("COMPANY_NUM") ).trim())) {
            if (( (String)paramMap.get("CUSTOM_NAME") ) == null || "".equals(( (String)paramMap.get("CUSTOM_NAME") ).trim())) {
                throw new CustomException("사업자번호 존재 시 거래처명" + "은(는) 필수입력항목입니다.");
            }
        }
        
        // 어음번호가 있으면 어음만기일, 어음발행처(은행)명은 필수
        if (( (String)paramMap.get("NOTE_NUM  ") ) != null && !"".equals(( (String)paramMap.get("NOTE_NUM  ") ).trim())) {
            if (( (String)paramMap.get("NOTE_DUE_DATE") ) == null || "".equals(( (String)paramMap.get("NOTE_DUE_DATE") ).trim())) {
                throw new CustomException("어음번호 존재 시 어음만기일" + "은(는) 필수입력항목입니다.");
            }
            if (( (String)paramMap.get("PUB_CUST_NAME") ) == null || "".equals(( (String)paramMap.get("PUB_CUST_NAME") ).trim())) {
                throw new CustomException("어음번호 존재 시 어음발행처(은행)명" + "은(는) 필수입력항목입니다.");
            }
        }
        
    }
    
    /**
     * TEMP 테이블 데이터 삭제
     * 
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    public void deleteTemp() throws Exception {
        Map param = new HashMap();
        
        try {
            super.commonDao.delete("if_agd360ukrServiceImpl.deleteTemp", param);
        } catch (Exception ex) {
            logger.error(ex.getMessage());
        }
    }
    
}
