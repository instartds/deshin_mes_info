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
 * 인사 원천세 IF
 * 
 * @author 박종영
 */
@Service( "if_C005ServiceImpl" )
public class If_C005ServiceImpl extends TlabAbstractServiceImpl {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    private RestUtils    utils  = new RestUtils();
    
    /**
     * I/F연계 원천세 조회
     * 
     * @param paramMap
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "accnt" )
    @SuppressWarnings( { "unchecked", "rawtypes" } )
    public List<Map<String, Object>> selectHPA950TList( Map param ) throws Exception {
        return super.commonDao.list("if_C005ServiceImpl.selectHPA950TList", param);
    }
    
    /**
     * I/F연계 원천세 급상여 조회
     * 
     * @param paramMap
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "accnt" )
    @SuppressWarnings( { "unchecked", "rawtypes" } )
    public List<Map<String, Object>> selectHPA960TList( Map param ) throws Exception {
        return super.commonDao.list("if_C005ServiceImpl.selectHPA960TList", param);
    }
    
    /**************************************************************/
    /*********************** Web Service 용 ***********************/
    /**************************************************************/
    
    /**
     * <pre>
     * 인사 원천세 저장 ( Web Service 용 )
     * 
     * 원천세(S_HPA950T_JS)
     * 원천세 급상여(S_HPA960T_JS)
     * </pre>
     * 
     * @param jobId
     * @param dataList
     * @param masterParamList
     * @param detailParamList
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public Map apiSaveAll( String jobId, List<Map<String, Object>> dataList, List<Map<String, Object>> masterParamList, List<Map<String, Object>> detailParamList ) throws Exception {
        
        Map rtnMap = new HashMap();
        
        Map param = new HashMap();
        param.put("JOB_ID", jobId);
        
        param.put("COMP_CODE", masterParamList.get(0).get("COMP_CODE"));
        param.put("PAY_YYYYMM", masterParamList.get(0).get("PAY_YYYYMM"));
        
        try {
            
            Map map = (Map)super.commonDao.select("if_C005ServiceImpl.selectOrdNum", param);
            String ordNum = (String)map.get("ORD_NUM");
            saveHPA950TAll(jobId, ordNum, dataList);
            saveHPA960TAll(jobId, ordNum, masterParamList, detailParamList);
            
        } catch (Exception e) {
            
            param.put("PROC_ERR_MSG", utils.errParse(e.getMessage()));
            logger.error("Error Map :: {}", param);
            super.commonDao.insert("if_C005ServiceImpl.insertError", param);
            
        }
        
        /*
         * Error가 발생한 데이터 Key 조회
         */
        String errMsg = (String)( (Map)super.commonDao.list("if_C005ServiceImpl.selectErrorList", param).get(0) ).get("ERR_KEY_SEQNO");
        logger.debug("errMsg :: {}", errMsg);
        if (errMsg.startsWith("1/")) {
            rtnMap.put("ERROR_DESC", (String)rtnMap.get("ERROR_DESC") + "," + errMsg);
        }
        
        return rtnMap;
    }
    
    /**
     * <pre>
     * 인사 원천세 저장 ( Web Service 용 )
     * 
     * 원천세(S_HPA950T_JS)
     * 원천세 급상여(S_HPA960T_JS)
     * </pre>
     * 
     * @param jobId
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public String saveTempToMain( String jobId ) throws Exception {
        
        Map param = new HashMap();
        param.put("JOB_ID", jobId);
        
        try {
            
            super.commonDao.select("if_C005ServiceImpl.USP_ACCNT_IFC0005", param);
            
        } catch (Exception e) {
            
            //e.printStackTrace();
            super.commonDao.update("if_C005ServiceImpl.deleteMulti", param);
            
            param.put("PROC_ERR_MSG", utils.errParse(e.getMessage()));
            logger.error("Error Map :: {}", param);
            super.commonDao.insert("if_C005ServiceImpl.insertError", param);
            
        }
        
        /*
         * Error가 발생한 데이터 Key 조회
         */
        String errMsg = (String)( (Map)super.commonDao.list("if_C005ServiceImpl.selectErrorList", param).get(0) ).get("ERR_KEY_SEQNO");
        
        return errMsg;
    }
    
    /**
     * <pre>
     * 인사 원천세 저장 ( Web Service 용 )
     * 
     * 원천세(S_HPA950T_JS)
     * 원천세 급상여(S_HPA960T_JS)
     * </pre>
     * 
     * @param masterParamList
     * @param detailParamList
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public String callProc01( List<Map<String, Object>> dataList, List<Map<String, Object>> masterParamList, List<Map<String, Object>> detailParamList ) throws Exception {
        
        /*
         * Job ID 생성
         */
        String jobId = utils.makeExcelJobID();
        
        Map param = new HashMap();
        param.put("JOB_ID", jobId);
        
        param.put("COMP_CODE", masterParamList.get(0).get("COMP_CODE"));
        param.put("PAY_YYYYMM", masterParamList.get(0).get("PAY_YYYYMM"));
        
        try {
            Map map = (Map)super.commonDao.select("if_C005ServiceImpl.selectOrdNum", param);
            String ordNum = (String)map.get("ORD_NUM");
            saveHPA950TAll(jobId, ordNum, dataList);
            saveHPA960TAll(jobId, ordNum, masterParamList, detailParamList);
        } catch (Exception e) {
            logger.info("--------------------------");
            //e.printStackTrace();
            super.commonDao.update("if_C005ServiceImpl.deleteMulti", param);
            
            param.put("PROC_ERR_MSG", utils.errParse(e.getMessage()));
            logger.error("Error Map :: {}", param);
            super.commonDao.insert("if_C005ServiceImpl.insertError", param);
            
            logger.info("--------------------------");
        }
        
        /*
         * Error가 발생한 데이터 Key 조회
         */
        String errMsg = (String)( (Map)super.commonDao.list("if_C005ServiceImpl.selectErrorList", param).get(0) ).get("ERR_KEY_SEQNO");
        
        return errMsg;
    }
    
    /**
     * I/F연계 원천세 저장 ( Web Service 용 )
     * 
     * @param paramList
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public String saveHPA950TAll( String jobId, String ordNum, List<Map<String, Object>> paramList ) throws Exception {
        int intCnt = 0;
        int uptCnt = 0;
        int delCnt = 0;
        int noCnt = 0;
        Map rMap = null;
        
        for (Map param : paramList) {
            param.put("JOB_ID", jobId);
            param.put("IF_DATE", jobId.substring(0, 8));
            param.put("IF_TIME", jobId.substring(8, jobId.length()));
            param.put("ORD_NUM", ordNum);
            
            rMap = (Map)super.commonDao.queryForObject("commonServiceImpl.getRefCode", param);
            logger.info("rMap :: {}", rMap);
            if (rMap != null) {
                param.put("COMP_CODE", rMap.get("REF_CODE1"));
            }
            logger.info("param :: {}", param);
            
            if ("I".equals((String)param.get("STATUS"))) {
                intCnt = intCnt + insertHPA950TMulti(param);
            } else if ("U".equals((String)param.get("STATUS"))) {
                uptCnt = intCnt + updateHPA950TMulti(param);
            } else if ("D".equals((String)param.get("STATUS"))) {
                delCnt = intCnt + deleteHPA950TMulti(param);
            } else {
                ++noCnt;
            }
        }
        return intCnt + "|" + uptCnt + "|" + delCnt + "|" + noCnt;
        
    }
    
    /**
     * I/F연계 원천세 급상여 저장 ( Web Service 용 )
     * 
     * @param jobId
     * @param masterParamList
     * @param detailParamList
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public String saveHPA960TAll( String jobId, String ordNum, List<Map<String, Object>> masterParamList, List<Map<String, Object>> detailParamList ) throws Exception {
        int intCnt = 0;
        int uptCnt = 0;
        int delCnt = 0;
        int noCnt = 0;
        
        Map masParam = (Map)masterParamList.get(0);
        
        Map rMap = (Map)super.commonDao.queryForObject("commonServiceImpl.getRefCode", masParam);
        logger.info("rMap :: {}", rMap);
        if (rMap != null) {
            masParam.put("COMP_CODE", rMap.get("REF_CODE1"));
        }
        logger.info("param :: {}", masParam);
        
        for (Map param : detailParamList) {
            
            param.put("JOB_ID", jobId);
            param.put("IF_DATE", jobId.substring(0, 8));
            param.put("IF_TIME", jobId.substring(8, jobId.length()));
            param.put("ORD_NUM", ordNum);
            param.put("COMP_CODE", masParam.get("COMP_CODE"));
            param.put("PAY_YYYYMM", masParam.get("PAY_YYYYMM"));
            param.put("COMPANY_NUM", masParam.get("COMPANY_NUM"));
            param.put("INSERT_USER", masParam.get("INSERT_USER"));
            
            logger.info("param :: {}", param);
            
            if ("I".equals((String)param.get("STATUS"))) {
                intCnt = intCnt + insertHPA960TMulti(param);
            } else if ("U".equals((String)param.get("STATUS"))) {
                uptCnt = intCnt + updateHPA960TMulti(param);
            } else if ("D".equals((String)param.get("STATUS"))) {
                delCnt = intCnt + deleteHPA960TMulti(param);
            } else {
                ++noCnt;
            }
        }
        
        return intCnt + "|" + uptCnt + "|" + delCnt + "|" + noCnt;
        
    }
    
    /**
     * I/F연계 원천세 입력 ( Web Service 용 )
     * 
     * @param paramMap
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    public int insertHPA950TMulti( Map paramMap ) throws Exception {
        return super.commonDao.insert("if_C005ServiceImpl.insertHPA950TMulti", paramMap);
    }
    
    /**
     * I/F연계 원천세 급상여 입력 ( Web Service 용 )
     * 
     * @param paramMap
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    public int insertHPA960TMulti( Map paramMap ) throws Exception {
        return super.commonDao.insert("if_C005ServiceImpl.insertHPA960TMulti", paramMap);
    }
    
    /**
     * I/F연계 원천세 수정 ( Web Service 용 )
     * 
     * @param paramMap
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    public int updateHPA950TMulti( Map paramMap ) throws Exception {
        return super.commonDao.update("if_C005ServiceImpl.updateHPA950TMulti", paramMap);
    }
    
    /**
     * I/F연계 원천세 급상여 수정 ( Web Service 용 )
     * 
     * @param paramMap
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    public int updateHPA960TMulti( Map paramMap ) throws Exception {
        return super.commonDao.update("if_C005ServiceImpl.updateHPA960TMulti", paramMap);
    }
    
    /**
     * I/F연계 원천세 삭제 ( Web Service 용 )
     * 
     * @param paramMap
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    public int deleteHPA950TMulti( Map paramMap ) throws Exception {
        return super.commonDao.update("if_C005ServiceImpl.deleteHPA950TMulti", paramMap);
    }
    
    /**
     * I/F연계 원천세 급상여 삭제 ( Web Service 용 )
     * 
     * @param paramMap
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    public int deleteHPA960TMulti( Map paramMap ) throws Exception {
        return super.commonDao.update("if_C005ServiceImpl.deleteHPA960TMulti", paramMap);
    }
    
}
