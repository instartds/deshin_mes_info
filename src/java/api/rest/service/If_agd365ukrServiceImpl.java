package api.rest.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import api.rest.exception.CustomException;
import api.rest.utils.RestUtils;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

/**
 * 전표자동기표 관리
 * 
 * @author 박종영
 */
@Service( "if_agd365ukrServiceImpl" )
public class If_agd365ukrServiceImpl extends TlabAbstractServiceImpl {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    private RestUtils    utils  = new RestUtils();
    
    /**
     * 전표자동기표 관리 조회
     * 
     * @param paramMap
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "stdbase" )
    @SuppressWarnings( { "unchecked", "rawtypes" } )
    public List<Map<String, Object>> selectList( Map param ) throws Exception {
        return super.commonDao.list("if_agd365ukrServiceImpl.selectList", param);
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
        return (Map)super.commonDao.select("if_agd365ukrServiceImpl.selectErrorList", param);
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
        return (Map)super.commonDao.select("if_agd365ukrServiceImpl.selectErrorListPB", param);
    }
    
    /**************************************************************/
    /*********************** Web Service 용 ***********************/
    /**************************************************************/
    
    /**
     * 전표자동기표취소 저장 ( Web Service 용 )
     * 
     * @param paramList
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public Map apiSaveAll( String jobId, Map<String, Object> param ) throws Exception {

        /*
         * 전표취소 처리 한다.
         */
        authSlipInterface(param);
        List list = super.commonDao.list("if_agd365ukrServiceImpl.selectAGD361T", param);
        logger.info("결과 :: {}", list);
        
        /*
         * 결과를 반환한다.
         */
        param = new HashMap();
        param.put("JOB_ID", jobId);
        param.put("RESULT", list);
        
        return param;
    }
    
    /**
     * 전표자동기표취소 저장 ( Web Service 용 )
     * 
     * @param paramList
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public Map apiSaveAllOneTran( List<Map<String, Object>> paramList ) throws Exception {
        /*
         * Job ID 생성
         */
        String jobId = utils.makeJobID();
        
        /*
         * Temp 폴더에 데이터를 Insert 한다.
         */
        Map param = saveIfAgd365T(jobId, paramList);
        
        /*
         * Temp 테이블에서 전자세금계산서_발행원장 으로 데이터를 저장 한다.
         */
        saveTempToAgd365T(jobId);
        
        /*
         * 전표취소 처리 한다.
         */
        authSlipInterface(param);
        List list = super.commonDao.list("if_agd365ukrServiceImpl.selectAGD361T", param);
        logger.info("결과 :: {}", list);
        
        /*
         * 결과를 반환한다.
         */
        param = new HashMap();
        param.put("JOB_ID", jobId);
        param.put("RESULT", list);
        
        return param;
    }
    
    /**
     * 전표자동기표취소 저장 ( Web Service 용 )
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
        Map param = saveIfAgd365TPB(jobId, paramList);
        
        /*
         * Temp 테이블에서 전자세금계산서_발행원장 으로 데이터를 저장 한다.
         */
        saveTempToAgd365T(jobId);
        
        /*
         * 전표취소 처리 한다.
         */
        authSlipInterface(param);
        List list = super.commonDao.list("if_agd365ukrServiceImpl.selectAGD361T", param);
        logger.info("결과 :: {}", list);
        
        /*
         * 결과를 반환한다.
         */
        param = new HashMap();
        param.put("JOB_ID", jobId);
        param.put("RESULT", list);
        
        return param;
    }
    
    /**
     * Temp 폴더에 데이터를 Insert 한다. ( Web Service 용 )
     * 
     * @param jobId
     * @param paramMap
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public Map saveIfAgd365T( String jobId, List<Map<String, Object>> paramList ) throws Exception {
        String compCode = "";
        String appId = "";
        String ifDate = "";
        String ifTime = "";
        Map rMap = null;
        
        for (Map param : paramList) {
            
            rMap = (Map)super.commonDao.queryForObject("commonServiceImpl.getRefCode", param);
            logger.info("rMap :: {}", rMap);
            if( rMap != null ) {
                param.put("COMP_CODE", rMap.get("REF_CODE1"));
            }
            logger.info("param :: {}", param);
            
            compCode = (String)param.get("COMP_CODE");
            appId = (String)param.get("APP_ID");
            param.put("JOB_ID", jobId);
            param.put("IF_DATE", ifDate = jobId.substring(0, 8));
            param.put("IF_TIME", ifTime = jobId.substring(8, jobId.length()));
            param.put("KEY_SEQNO", param.get("INDEX_NUM"));
            param.put("S_USER_ID", "WebService");
            
            try {
                try {
                    // Validation Check
                    insertDataValidate(param);
                } catch (Exception e) {
                    logger.error(e.getMessage());
                    throw new CustomException(e.getMessage(), param);
                }
                
                try {
                    super.commonDao.insert("if_agd365ukrServiceImpl.insertTempMulti", param);
                } catch (Exception e) {
                    logger.error(e.getMessage());
                    throw new CustomException(e.getMessage(), param);
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
        
        return rtnMap;
    }
    
    /**
     * Temp 폴더에 데이터를 Insert 한다. ( Web Service 용 )
     * 
     * @param jobId
     * @param paramMap
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    private Map saveIfAgd365TPB( String jobId, List<Map<String, Object>> paramList ) throws Exception {
        String compCode = "";
        String appId = "";
        String ifDate = "";
        String ifTime = "";
        Map rMap = null;
        
        for (Map param : paramList) {
            rMap = (Map)super.commonDao.queryForObject("commonServiceImpl.getRefCode", param);
            logger.info("rMap :: {}", rMap);
            if( rMap != null ) {
                param.put("COMP_CODE", rMap.get("REF_CODE1"));
            }
            logger.info("param :: {}", param);
            
            compCode = (String)param.get("COMP_CODE");
            appId = (String)param.get("APP_ID");
            param.put("JOB_ID", jobId);
            param.put("IF_DATE", ifDate = jobId.substring(0, 8));
            param.put("IF_TIME", ifTime = jobId.substring(8, jobId.length()));
            param.put("KEY_SEQNO", param.get("INDEX_NUM"));
            param.put("S_USER_ID", "WebService");
            
            try {
                try {
                    super.commonDao.insert("if_agd365ukrServiceImpl.insertTempMulti", param);
                } catch (Exception e) {
                    logger.error(e.getMessage());
                    throw new CustomException(e.getMessage(), param);
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
        
        return rtnMap;
    }
    
    /**
     * 전표취소 처리 한다.
     * 
     * @param jobId
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    private void authSlipInterface( Map param ) throws Exception {
        
        try {
            super.commonDao.list("if_agd365ukrServiceImpl.USP_ACCNT_AUTOSLIP_INTERFACE_CANCEL_JS", param);
        } catch (Exception ex) {
            logger.error(ex.getMessage());
        }
    }
    
    /**
     * Temp 테이블에서 취소테이블로 데이터를 저장 한다. ( Web Service 용 )
     * 
     * @param jobId
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public void saveTempToAgd365T( String jobId ) throws Exception {
        Map param = new HashMap();
        param.put("JOB_ID", jobId);
        
        try {
            super.commonDao.delete("if_agd365ukrServiceImpl.USP_ACCNT_AGD365T", param);
        } catch (Exception ex) {
            logger.error(ex.getMessage());
        }
    }
    
    /**
     * TEMP 테이블 데이터 삭제 ( Web Service 용 )
     * 
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    public void deleteTemp() throws Exception {
        Map param = new HashMap();
        
        try {
            super.commonDao.delete("if_agd365ukrServiceImpl.deleteTemp", param);
        } catch (Exception ex) {
            logger.error(ex.getMessage());
        }
    }
    
    /**
     * 전표취소 등록, 수정 시 Validation Check
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
        if (!(paramMap.get("INDEX_NUM") instanceof Double)) {
            if (( (String)paramMap.get("INDEX_NUM") ) == null || "".equals(( (String)paramMap.get("INDEX_NUM") ).trim())) {
                throw new CustomException("연계key번호" + "은(는) 필수입력항목입니다.");
            }
        }
        if (( (String)paramMap.get("AC_DATE") ) == null || "".equals(( (String)paramMap.get("AC_DATE") ).trim())) {
            throw new CustomException("전표일자" + "은(는) 필수입력항목입니다.");
        }
        if (!( paramMap.get("SLIP_NUM") instanceof Double )) {
            if (( (String)paramMap.get("SLIP_NUM") ) == null || "".equals(( (String)paramMap.get("SLIP_NUM") ).trim())) {
                throw new CustomException("전표번호" + "은(는) 필수입력항목입니다.");
            }
        }
    }
    
}
