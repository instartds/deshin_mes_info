package api.rest.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import api.rest.utils.RestUtils;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

/**
 * 인사 퇴직금자동기표 IF
 * 
 * @author 박종영
 */
@Service( "if_C002ServiceImpl" )
public class If_C002ServiceImpl extends TlabAbstractServiceImpl {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    private RestUtils    utils  = new RestUtils();
    
    /**
     * I/F연계 퇴직급여 조회
     * 
     * @param paramMap
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "accnt" )
    @SuppressWarnings( { "unchecked", "rawtypes" } )
    public List<Map<String, Object>> selectHRT500TList( Map param ) throws Exception {
        return super.commonDao.list("if_C002ServiceImpl.selectHRT500TList", param);
    }
    
    /**
     * I/F연계 월별수당공제금액 조회
     * 
     * @param paramMap
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "accnt" )
    @SuppressWarnings( { "unchecked", "rawtypes" } )
    public List<Map<String, Object>> selectHRT510TList( Map param ) throws Exception {
        return super.commonDao.list("if_C002ServiceImpl.selectHRT510TList", param);
    }
    
    /**************************************************************/
    /*********************** Web Service 용 ***********************/
    /**************************************************************/
    
    /**
     * <pre>
     * 인사 퇴직자동기표 저장 ( Web Service 용 )
     *  - Temp 테이블이 Insert
     *  
     * 퇴직급여(S_HRT500T_JS)
     * 월별수당공제금액(S_HRT510T_JS)
     * </pre>
     * 
     * @param jobId
     * @param masterParamList
     * @param detailParamList
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public Map apiSaveAll( String jobId, List<Map<String, Object>> masterParamList, List<Map<String, Object>> detailParamList ) throws Exception {
        
        Map rtnMap = new HashMap();
        
        Map param = new HashMap();
        param.put("JOB_ID", jobId);
        
        try {
            
            saveHRT500TAll(jobId, masterParamList);
            saveHRT510TAll(jobId, masterParamList, detailParamList);
            
        } catch (Exception e) {
            
            param.put("PROC_ERR_MSG", utils.errorMsg(e.getMessage()));
            logger.error("Error Map :: {}", param);
            super.commonDao.insert("if_C002ServiceImpl.insertError", param);
            
        }
        
        /*
         * Error가 발생한 데이터 Key 조회
         */
        String errMsg = (String)( (Map)super.commonDao.list("if_C002ServiceImpl.selectErrorList", param).get(0) ).get("ERR_KEY_SEQNO");
        logger.debug("errMsg :: {}", errMsg);
        if (errMsg.startsWith("1/")) {
            rtnMap.put("ERROR_DESC", (String)rtnMap.get("ERROR_DESC") + "," + errMsg);
        }
        
        return rtnMap;
    }
    
    /**
     * <pre>
     * 인사 퇴직자동기표 저장 ( Web Service 용 )
     *  - Temp 테이블 -> Main 테이블 Insert
     *  
     * 퇴직급여(S_HRT500T_JS)
     * 월별수당공제금액(S_HRT510T_JS)
     * </pre>
     * 
     * @param jobId
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public Map saveTempToMain( String jobId ) throws Exception {
        
        Map param = new HashMap();
        param.put("JOB_ID", jobId);
        
        try {
            
            super.commonDao.select("if_C002ServiceImpl.USP_ACCNT_IFC0002", param);
            
        } catch (Exception e) {
            
            param.put("PROC_ERR_MSG", utils.errorMsg(e.getMessage()));
            logger.error("Error Map :: {}", param);
            super.commonDao.insert("if_C002ServiceImpl.insertError", param);
            
        }
        
        /*
         * Error가 발생한 데이터 Key 조회
         */
        String errMsg = (String)( (Map)super.commonDao.list("if_C002ServiceImpl.selectErrorList", param).get(0) ).get("ERR_KEY_SEQNO");
        logger.debug("errMsg :: {}", errMsg);
        if (errMsg.startsWith("1/")) {
            param.put("ERROR_DESC", errMsg);
            
            super.commonDao.update("if_C002ServiceImpl.deleteMulti", param);
        }
        
        return param;
    }
    
    /**
     * <pre>
     * 인사 퇴직자동기표 저장 ( Web Service 용 )
     *  - 프로시져 처리
     *  
     * 퇴직급여(S_HRT500T_JS)
     * 월별수당공제금액(S_HRT510T_JS)
     * </pre>
     * 
     * @param masterParamList
     * @param detailParamList
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public Map callProc01( String jobId, List<Map<String, Object>> masterParamList ) throws Exception {
        
        Map rtnMap = null;
        
        Map param = new HashMap();
        param.put("JOB_ID", jobId);
        
        try {
            /*
             * 인사 퇴직자동기표 IF Procedure를 호출한다.
             */
            callProc01(masterParamList);
            
            List<Map<String, Object>> rtnList = this.selectHRT500TList(masterParamList.get(0));
            logger.info("rtnList :: {}", rtnList);
            rtnMap = (Map)rtnList.get(0);
            
        } catch (Exception e) {
            
            super.commonDao.update("if_C002ServiceImpl.deleteMulti", param);
            
            param.put("PROC_ERR_MSG", utils.errorMsg(e.getMessage()));
            logger.error("Error Map :: {}", param);
            super.commonDao.insert("if_C002ServiceImpl.insertError", param);
            
        }
        
        /*
         * Error가 발생한 데이터 Key 조회
         */
        String errMsg = (String)( (Map)super.commonDao.list("if_C002ServiceImpl.selectErrorList", param).get(0) ).get("ERR_KEY_SEQNO");
        if (errMsg.startsWith("1/")) {
            rtnMap.put("ERROR_DESC", (String)rtnMap.get("ERROR_DESC") + "," + errMsg);
        }
        
        return rtnMap;
    }
    
    /**
     * 인사 퇴직자동기표 IF Procedure를 호출한다.
     * 
     * @param masterDataList
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    private void callProc01( List<Map<String, Object>> masterDataList ) throws Exception {
        try {
            Map param = (Map)masterDataList.get(0);
            
            super.commonDao.select("if_C002ServiceImpl.USP_ACCNT_AutoSlip22_JS", param);
        } catch (Exception ex) {
            logger.error(ex.getMessage());
            throw new Exception(ex.getMessage());
        }
    }
    
    /**
     * I/F연계 퇴직급여 저장 ( Web Service 용 )
     * 
     * @param paramList
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public String saveHRT500TAll( String jobId, List<Map<String, Object>> paramList ) throws Exception {
        int intCnt = 0;
        int uptCnt = 0;
        int delCnt = 0;
        int noCnt = 0;
        Map rMap = null;
        for (Map param : paramList) {
            param.put("JOB_ID", jobId);
            
            rMap = (Map)super.commonDao.queryForObject("commonServiceImpl.getRefCode", param);
            logger.info("rMap :: {}", rMap);
            if( rMap != null ) {
                param.put("COMP_CODE", rMap.get("REF_CODE1"));
            }
            logger.info("param :: {}", param);
            
            if ("I".equals((String)param.get("STATUS"))) {
                intCnt = intCnt + insertHRT500TMulti(param);
            } else if ("U".equals((String)param.get("STATUS"))) {
                uptCnt = intCnt + updateHRT500TMulti(param);
            } else if ("D".equals((String)param.get("STATUS"))) {
                delCnt = intCnt + deleteHRT500TMulti(param);
            } else {
                ++noCnt;
            }
        }
        return intCnt + "|" + uptCnt + "|" + delCnt + "|" + noCnt;
        
    }
    
    /**
     * I/F연계 퇴직급여공제 저장 ( Web Service 용 )
     * 
     * @param jobId
     * @param masterParamList
     * @param detailParamList
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public String saveHRT510TAll( String jobId, List<Map<String, Object>> masterParamList, List<Map<String, Object>> detailParamList ) throws Exception {
        int intCnt = 0;
        int uptCnt = 0;
        int delCnt = 0;
        int noCnt = 0;
        
        Map masParam = (Map)masterParamList.get(0);
        for (Map param : detailParamList) {
            
            param.put("JOB_ID", jobId);
            param.put("COMP_CODE", masParam.get("COMP_CODE"));
            param.put("SUPP_DATE", masParam.get("SUPP_DATE"));
            param.put("PERSON_NUMB", masParam.get("PERSON_NUMB"));
            param.put("INSERT_USER", masParam.get("INSERT_USER"));
            
            if ("I".equals((String)param.get("STATUS"))) {
                intCnt = intCnt + insertHRT510TMulti(param);
            } else if ("U".equals((String)param.get("STATUS"))) {
                uptCnt = intCnt + updateHRT510TMulti(param);
            } else if ("D".equals((String)param.get("STATUS"))) {
                delCnt = intCnt + deleteHRT510TMulti(param);
            } else {
                ++noCnt;
            }
        }
        
        return intCnt + "|" + uptCnt + "|" + delCnt + "|" + noCnt;
        
    }
    
    /**
     * I/F연계 퇴직급여 입력 ( Web Service 용 )
     * 
     * @param paramMap
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    public int insertHRT500TMulti( Map paramMap ) throws Exception {
        return super.commonDao.insert("if_C002ServiceImpl.insertHRT500TMulti", paramMap);
    }
    
    /**
     * I/F연계 퇴직급여공제 입력 ( Web Service 용 )
     * 
     * @param paramMap
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    public int insertHRT510TMulti( Map paramMap ) throws Exception {
        return super.commonDao.insert("if_C002ServiceImpl.insertHRT510TMulti", paramMap);
    }
    
    /**
     * I/F연계 퇴직급여 수정 ( Web Service 용 )
     * 
     * @param paramMap
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    public int updateHRT500TMulti( Map paramMap ) throws Exception {
        return super.commonDao.update("if_C002ServiceImpl.updateHRT500TMulti", paramMap);
    }
    
    /**
     * I/F연계 퇴직급여공제 수정 ( Web Service 용 )
     * 
     * @param paramMap
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    public int updateHRT510TMulti( Map paramMap ) throws Exception {
        return super.commonDao.update("if_C002ServiceImpl.updateHRT510TMulti", paramMap);
    }
    
    /**
     * I/F연계 퇴직급여 삭제 ( Web Service 용 )
     * 
     * @param paramMap
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    public int deleteHRT500TMulti( Map paramMap ) throws Exception {
        return super.commonDao.update("if_C002ServiceImpl.deleteHRT500TMulti", paramMap);
    }
    
    /**
     * I/F연계 퇴직급여공제 삭제 ( Web Service 용 )
     * 
     * @param paramMap
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    public int deleteHRT510TMulti( Map paramMap ) throws Exception {
        return super.commonDao.update("if_C002ServiceImpl.deleteHRT510TMulti", paramMap);
    }
    
}
