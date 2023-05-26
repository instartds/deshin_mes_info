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
 * 인사 급상여자동기표 IF
 * 
 * @author 박종영
 */
@Service( "if_C001ServiceImpl" )
public class If_C001ServiceImpl extends TlabAbstractServiceImpl {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    private RestUtils    utils  = new RestUtils();
    
    /**
     * I/F연계 수당공제코드 조회
     * 
     * @param paramMap
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "accnt" )
    @SuppressWarnings( { "unchecked", "rawtypes" } )
    public List<Map<String, Object>> selectHBS300TList( Map param ) throws Exception {
        return super.commonDao.list("if_C001ServiceImpl.selectHBS300TList", param);
    }
    
    /**
     * I/F연계 월별수당공제금액_MASTER
     * 
     * @param paramMap
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "accnt" )
    @SuppressWarnings( { "unchecked" } )
    public List<Map<String, Object>> selectHPA600TList( Map<String, Object> param ) throws Exception {
        return super.commonDao.list("if_C001ServiceImpl.selectHPA600TList", param);
    }
    
    /**
     * I/F연계 월별수당공제금액_DETAIL
     * 
     * @param paramMap
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "accnt" )
    @SuppressWarnings( { "unchecked" } )
    public List<Map<String, Object>> selectHPA610TList( Map<String, Object> param ) throws Exception {
        return super.commonDao.list("if_C001ServiceImpl.selectHPA610TList", param);
    }
    
    /**************************************************************/
    /*********************** Web Service 용 ***********************/
    /**************************************************************/
    
    /**
     * <pre>
     * 인사 급상여자동기표 IF ( Web Service 용 )
     *  - Temp 테이블이 Insert
     * 
     * I/F연계 수당공제코드(S_HBS300T_JS)
     * I/F연계 월별수당공제금액_MASTER(S_HPA600T_JS)
     * I/F연계 월별수당공제금액_DETAIL(S_HPA610T_JS)
     * </pre>
     * 
     * @param jobId
     * @param paramHBS300TList
     * @param masterDataList
     * @param detailDataList
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public Map apiSaveAll( String jobId, List<Map<String, Object>> paramHBS300TList, List<Map<String, Object>> masterDataList, List<Map<String, Object>> detailDataList ) throws Exception {
        
        Map rtnMap = new HashMap();
        
        Map param = new HashMap();
        param.put("JOB_ID", jobId);
        
        try {
            
            saveHBS300TAll(jobId, paramHBS300TList);
            saveHPA600TAll(jobId, masterDataList);
            saveHPA610TAll(jobId, masterDataList, detailDataList);
            
        } catch (Exception e) {
            
            param.put("PROC_ERR_MSG", utils.errorMsg(e.getMessage()));
            logger.error("Error Map :: {}", param);
            super.commonDao.insert("if_C001ServiceImpl.insertError", param);
            
        }
        
        /*
         * Error가 발생한 데이터 Key 조회
         */
        String errMsg = (String)( (Map)super.commonDao.list("if_C001ServiceImpl.selectErrorList", param).get(0) ).get("ERR_KEY_SEQNO");
        logger.debug("errMsg :: {}", errMsg);
        if (errMsg.startsWith("1/")) {
            rtnMap.put("ERROR_DESC", (String)rtnMap.get("ERROR_DESC") + "," + errMsg);
        }
        
        return rtnMap;
    }
    
    /**
     * <pre>
     * 인사 급상여자동기표 IF ( Web Service 용 )
     *  - Temp 테이블 -> Main 테이블 Insert
     *  
     * I/F연계 수당공제코드(S_HBS300T_JS)
     * I/F연계 월별수당공제금액_MASTER(S_HPA600T_JS)
     * I/F연계 월별수당공제금액_DETAIL(S_HPA610T_JS)
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
            super.commonDao.select("if_C001ServiceImpl.USP_ACCNT_IFC0001", param);
        } catch (Exception ex) {
            
            param.put("PROC_ERR_MSG", utils.errorMsg(ex.getMessage()));
            logger.error("Error Map :: {}", param);
            super.commonDao.insert("if_C001ServiceImpl.insertError", param);
            
        }
        
        /*
         * Error가 발생한 데이터 Key 조회
         */
        String errMsg = (String)( (Map)super.commonDao.list("if_C001ServiceImpl.selectErrorList", param).get(0) ).get("ERR_KEY_SEQNO");
        logger.debug("errMsg :: {}", errMsg);
        if (errMsg.startsWith("1/")) {
            param.put("ERROR_DESC", errMsg);
            
            super.commonDao.update("if_C001ServiceImpl.deleteMulti", param);
        }
        
        return param;
    }
    
    /**
     * <pre>
     * 인사 급상여자동기표 IF ( Web Service 용 )
     *  - 프로시져 처리
     * 
     * I/F연계 수당공제코드(S_HBS300T_JS)
     * I/F연계 월별수당공제금액_MASTER(S_HPA600T_JS)
     * I/F연계 월별수당공제금액_DETAIL(S_HPA610T_JS)
     * </pre>
     * 
     * @param jobId
     * @param masterDataList
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public Map callProc01( String jobId, List<Map<String, Object>> masterDataList ) throws Exception {
        
        Map rtnMap = null;
        
        Map param = new HashMap();
        param.put("JOB_ID", jobId);
        try {
            /*
             * 인사 급상여자동기표 IF Procedure를 호출한다.
             */
            callProc01(masterDataList);
            masterDataList.get(0).put("JOB_ID", jobId);
            List<Map<String, Object>> rtnList = this.selectHPA600TList(masterDataList.get(0));
            logger.info("rtnList :: {}", rtnList);
            rtnMap = (Map)rtnList.get(0);
            
        } catch (Exception e) {
            
            param.put("PROC_ERR_MSG", utils.errorMsg(e.getMessage()));
            logger.error("Error Map :: {}", param);
            super.commonDao.insert("if_C001ServiceImpl.insertError", param);
            
            super.commonDao.update("if_C001ServiceImpl.deleteMulti", param);
        }
        
        /*
         * Error가 발생한 데이터 Key 조회
         */
        String errMsg = (String)( (Map)super.commonDao.list("if_C001ServiceImpl.selectErrorList", param).get(0) ).get("ERR_KEY_SEQNO");
        logger.debug("errMsg :: {}", errMsg);
        if (errMsg.startsWith("1/")) {
            rtnMap.put("ERROR_DESC", (String)rtnMap.get("ERROR_DESC") + "," + errMsg);
        }
        
        return rtnMap;
    }
    
    /**
     * 인사 급상여자동기표 IF Procedure를 호출한다.
     * 
     * @param masterDataList
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    private void callProc01( List<Map<String, Object>> masterDataList ) throws Exception {
        try {
            Map param = (Map)masterDataList.get(0);
            
            super.commonDao.select("if_C001ServiceImpl.USP_ACCNT_AutoSlip20_JS", param);
        } catch (Exception ex) {
            logger.error(ex.getMessage());
            throw new Exception(ex.getMessage());
        }
    }
    
    /**
     * I/F연계 수당공제코드 저장 ( Web Service 용 )
     * 
     * @param paramList
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public String saveHBS300TAll( String jobId, List<Map<String, Object>> paramList ) throws Exception {
        int intCnt = 0;
        int uptCnt = 0;
        int delCnt = 0;
        int noCnt = 0;
        Map rMap = null;
        
        for (Map param : paramList) {
            param.put("JOB_ID", jobId);
            param.put("S_USER_ID", "WebService");
            
            rMap = (Map)super.commonDao.queryForObject("commonServiceImpl.getRefCode", param);
            logger.info("rMap :: {}", rMap);
            if( rMap != null ) {
                param.put("COMP_CODE", rMap.get("REF_CODE1"));
            }
            logger.info("param :: {}", param);
            
            if ("I".equals((String)param.get("STATUS"))) {
                intCnt = intCnt + insertHBS300TMulti(param);
            } else if ("U".equals((String)param.get("STATUS"))) {
                uptCnt = intCnt + updateHBS300TMulti(param);
            } else if ("D".equals((String)param.get("STATUS"))) {
                delCnt = intCnt + deleteHBS300TMulti(param);
            } else {
                ++noCnt;
            }
        }
        return intCnt + "|" + uptCnt + "|" + delCnt + "|" + noCnt;
        
    }
    
    /**
     * I/F연계 월별수당공제금액_MASTER 저장 ( Web Service 용 )
     * 
     * @param paramList
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public String saveHPA600TAll( String jobId, List<Map<String, Object>> paramList ) throws Exception {
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
                intCnt = intCnt + insertHPA600TMulti(param);
            } else if ("U".equals((String)param.get("STATUS"))) {
                uptCnt = intCnt + updateHPA600TMulti(param);
            } else if ("D".equals((String)param.get("STATUS"))) {
                delCnt = intCnt + deleteHPA600TMulti(param);
            } else {
                ++noCnt;
            }
        }
        return intCnt + "|" + uptCnt + "|" + delCnt + "|" + noCnt;
        
    }
    
    /**
     * I/F연계 월별수당공제금액_DETAIL 저장 ( Web Service 용 )
     * 
     * @param paramList
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public String saveHPA610TAll( String jobId, List<Map<String, Object>> masterList, List<Map<String, Object>> detailList ) throws Exception {
        int intCnt = 0;
        int uptCnt = 0;
        int delCnt = 0;
        int noCnt = 0;
        
        Map masParam = (Map)masterList.get(0);
        for (Map param : detailList) {
            param.put("JOB_ID", jobId);
            param.put("COMP_CODE", masParam.get("COMP_CODE"));
            param.put("SUPP_TYPE", masParam.get("SUPP_TYPE"));
            param.put("PAY_YYYYMM", masParam.get("PAY_YYYYMM"));
            param.put("SUPP_DATE", masParam.get("SUPP_DATE"));
            param.put("INSERT_USER", masParam.get("INSERT_USER"));
            logger.info("param :: {}", param);
            
            if ("I".equals((String)param.get("STATUS"))) {
                intCnt = intCnt + insertHPA610TMulti(param);
            } else if ("U".equals((String)param.get("STATUS"))) {
                uptCnt = intCnt + updateHPA610TMulti(param);
            } else if ("D".equals((String)param.get("STATUS"))) {
                delCnt = intCnt + deleteHPA610TMulti(param);
            } else {
                ++noCnt;
            }
        }
        return intCnt + "|" + uptCnt + "|" + delCnt + "|" + noCnt;
        
    }
    
    /**
     * I/F연계 수당공제코드 입력 ( Web Service 용 )
     * 
     * @param paramMap
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    public int insertHBS300TMulti( Map paramMap ) throws Exception {
        return super.commonDao.insert("if_C001ServiceImpl.insertHBS300TMulti", paramMap);
    }
    
    /**
     * I/F연계 월별수당공제금액_MASTER 입력 ( Web Service 용 )
     * 
     * @param paramMap
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    public int insertHPA600TMulti( Map paramMap ) throws Exception {
        return super.commonDao.insert("if_C001ServiceImpl.insertHPA600TMulti", paramMap);
    }
    
    /**
     * I/F연계 월별수당공제금액_DETAIL 입력 ( Web Service 용 )
     * 
     * @param paramMap
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    public int insertHPA610TMulti( Map paramMap ) throws Exception {
        return super.commonDao.insert("if_C001ServiceImpl.insertHPA610TMulti", paramMap);
    }
    
    /**
     * I/F연계 수당공제코드 수정 ( Web Service 용 )
     * 
     * @param paramMap
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    public int updateHBS300TMulti( Map paramMap ) throws Exception {
        return super.commonDao.update("if_C001ServiceImpl.updateHBS300TMulti", paramMap);
    }
    
    /**
     * I/F연계 월별수당공제금액_MASTER 수정 ( Web Service 용 )
     * 
     * @param paramMap
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    public int updateHPA600TMulti( Map paramMap ) throws Exception {
        return super.commonDao.update("if_C001ServiceImpl.updateHPA600TMulti", paramMap);
    }
    
    /**
     * I/F연계 월별수당공제금액_DETAIL 수정 ( Web Service 용 )
     * 
     * @param paramMap
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    public int updateHPA610TMulti( Map paramMap ) throws Exception {
        return super.commonDao.update("if_C001ServiceImpl.updateHPA610TMulti", paramMap);
    }
    
    /**
     * I/F연계 수당공제코드 삭제 ( Web Service 용 )
     * 
     * @param paramMap
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    public int deleteHBS300TMulti( Map paramMap ) throws Exception {
        return super.commonDao.update("if_C001ServiceImpl.deleteHBS300TMulti", paramMap);
    }
    
    /**
     * I/F연계 월별수당공제금액_MASTER 삭제 ( Web Service 용 )
     * 
     * @param paramMap
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    public int deleteHPA600TMulti( Map paramMap ) throws Exception {
        return super.commonDao.update("if_C001ServiceImpl.deleteHPA600TMulti", paramMap);
    }
    
    /**
     * I/F연계 월별수당공제금액_DETAIL 삭제 ( Web Service 용 )
     * 
     * @param paramMap
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    public int deleteHPA610TMulti( Map paramMap ) throws Exception {
        return super.commonDao.update("if_C001ServiceImpl.deleteHPA610TMulti", paramMap);
    }
}
