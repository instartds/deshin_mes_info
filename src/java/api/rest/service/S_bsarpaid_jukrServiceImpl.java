package api.rest.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import api.rest.utils.RestUtils;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

/**
 * 후불대체자동기표(보광)_후불회수
 * 
 * @author 박종영
 */
@Service( "s_bsarpaid_jukrServiceImpl" )
public class S_bsarpaid_jukrServiceImpl extends TlabAbstractServiceImpl {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    private RestUtils    utils  = new RestUtils();
    
    /**
     * 후불대체자동기표(보광)_후불회수 조회
     * 
     * @param paramMap
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "stdbase" )
    @SuppressWarnings( { "unchecked", "rawtypes" } )
    public List<Map<String, Object>> selectList( Map param ) throws Exception {
        return super.commonDao.list("s_bsarpaid_jukrServiceImpl.selectList", param);
    }
    
    /**************************************************************/
    /*********************** Web Service 용 ***********************/
    /**************************************************************/
  
    /**
     * 후불대체자동기표(보광)_후불회수 저장 ( Web Service 용 )
     * 
     * @param paramList
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public Map apiSaveIF( List<Map<String, Object>> paramList, String jobId) throws Exception {
        
        Map rtnMap = new HashMap();
        Map param = new HashMap();
        param.put("JOB_ID", jobId);
        
        try {
            saveAll(jobId, paramList);
        } catch (Exception e) {
            param.put("PROC_ERR_MSG", utils.errParse(e.getMessage()));
            logger.error("Detail Error map :: {}", param);
            super.commonDao.insert("s_bsarpaid_jukrServiceImpl.insertError", param);
        }
        
        /*
         * Error가 발생한 데이터 Key 조회
         */
        String errMsg = (String)( (Map)super.commonDao.list("s_bsarpaid_jukrServiceImpl.selectErrorList", param).get(0) ).get("ERR_KEY_SEQNO");
        logger.debug("errMsg :: {}", errMsg);
        if(errMsg.startsWith("1/")) {
            rtnMap.put("ERROR_DESC", (String)rtnMap.get("ERROR_DESC") + "," + errMsg);
        }
        
        return rtnMap;
        
    }
    
    
    /**
     * Temp 테이블에서 후불대체자동기표로 정보를 저장한다.
     * 
     * @param jobId
     * @return 
     * @throws Exception
     */
    @SuppressWarnings( { "unchecked", "rawtypes" } )
    public Map saveTempToMain( String jobId ) throws Exception {
        Map param = new HashMap();
        param.put("JOB_ID", jobId);
        
        try {
            super.commonDao.list("s_bsarpaid_jukrServiceImpl.USP_ACCNT_IFC0011", param); 
        } catch (Exception e) {
            param.put("PROC_ERR_MSG", utils.errorMsg(e.getMessage()));
            logger.error("Error Map :: {}", param);
            super.commonDao.insert("s_insdept_jukrServiceImpl.insertError", param);
            super.commonDao.update("s_insdept_jukrServiceImpl.deleteMulti", param);
        }
        /*
         * Error가 발생한 데이터 Key 조회
         */
        String errMsg = (String)( (Map)super.commonDao.list("s_bsarpaid_jukrServiceImpl.selectErrorList", param).get(0) ).get("ERR_KEY_SEQNO");
        logger.debug("errMsg :: {}", errMsg);
        if(errMsg.startsWith("1/")) {
            param.put("ERROR_DESC", errMsg);
        }
        return param; 
    }
    
    /**
     * 후불대체자동기표를 실행한다
     * 
     * @param jobId
     * @param paramList 
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    public Map callPoc( String jobId, List<Map<String, Object>> paramList ) throws Exception {
        
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("COMP_CODE", paramList.get(0).get("COMP_CODE"));
        map.put("APP_ID", paramList.get(0).get("APP_ID"));
        map.put("IF_DATE", jobId.substring(0, 8));
        map.put("IF_TIME", jobId.substring(8, jobId.length()));
        map.put("JOB_ID", jobId);
        
        Map<String, Object> rtnMap = new HashMap<String, Object>();
        
        try {
            /*
             * 후불대체자동기표 IF Procedure를 호출한다.
             */
            authSlipInterface(map);
            List list = super.commonDao.list("s_bsarpaid_jukrServiceImpl.selectAutoResultSp", map);
            Map cnt = (Map)super.commonDao.select("s_bsarpaid_jukrServiceImpl.selectErrorSpCnt", map);
            logger.info("list :: {}", list);
            rtnMap.put("RESULT", list);
            rtnMap.put("CNT", cnt.get("CNT"));
        } catch (Exception e) {
            e.printStackTrace();
            map.put("PROC_ERR_MSG", utils.errorMsg(e.getMessage()));
            logger.error("Error Map :: {}", map);
            super.commonDao.insert("s_bsarpaid_jukrServiceImpl.insertError", map);
            super.commonDao.update("s_bsarpaid_jukrServiceImpl.deleteMulti", map);
        }
        
        /*
         * Error가 발생한 데이터 Key 조회
         */
        String errMsg = (String)( (Map)super.commonDao.list("s_bsarpaid_jukrServiceImpl.selectErrorList", map).get(0) ).get("ERR_KEY_SEQNO");
        logger.debug("errMsg :: {}", errMsg);
        if(errMsg.startsWith("1/")) {
            rtnMap.put("ERROR_DESC", (String)rtnMap.get("ERROR_DESC") + "," + errMsg);
        }
        
        return rtnMap;
    }    
    
    
    /**
     * 후불대체자동기표(보광)_후불회수 저장 ( Web Service 용 )
     * 
     * @param paramList
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public Map apiSaveAll( List<Map<String, Object>> paramList ) throws Exception {
        
        /*
         * Job ID 생성
         */
        String jobId = utils.makeExcelJobID();
        String inrcvValue = null;
        
        try {
            inrcvValue = saveAll(jobId, paramList);
        } catch (Exception e) {
            logger.info("--------------------------");
            e.printStackTrace();
            Map param = new HashMap();
            param.put("JOB_ID", jobId);
            super.commonDao.update("s_bsarpaid_jukrServiceImpl.deleteMulti", param);
            
            param.put("PROC_ERR_MSG", utils.errParse(e.getMessage()));
            logger.error("Detail Error map :: {}", param);
            super.commonDao.insert("s_bsarpaid_jukrServiceImpl.insertError", param);
            
            logger.info("--------------------------");
            
            throw new Exception(utils.errParse(e.getMessage()));
        }
        
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("COMP_CODE", paramList.get(0).get("COMP_CODE"));
        map.put("APP_ID", paramList.get(0).get("APP_ID"));
        map.put("IF_DATE", jobId.substring(0, 8));
        map.put("IF_TIME", jobId.substring(8, jobId.length()));
        
        /*
         * 전표 처리 한다.
         */
        authSlipInterface(map);
        List list = super.commonDao.list("s_bsarpaid_jukrServiceImpl.selectAutoResultSp", map);
        logger.info("결과 :: {}", list);
        
       /* 
         * 결과를 반환한다.
         */
        map = new HashMap();
        map.put("JOB_ID", jobId);
        map.put("RESULT", list);
        
        return map;
        
        //return inrcvValue;
        
    }
    
    /**
     * 전표 처리 한다.
     * 
     * @param jobId
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    private void authSlipInterface( Map map ) throws Exception {
        try {
            super.commonDao.list("s_bsarpaid_jukrServiceImpl.USP_ACCNT_AutoSlipB4_JS", map);
        } catch (Exception ex) {
            logger.error(ex.getMessage());
            map.put("PROC_ERR_MSG", utils.errorMsg(ex.getMessage()));
            logger.error("Error Map :: {}", map);
            super.commonDao.insert("s_bsarpaid_jukrServiceImpl.insertError", map);
        }
    }
    
    /**
     * 후불대체자동기표(보광)_후불회수 저장 ( Web Service 용 )
     * 
     * @param paramList
     * @return
     * @throws Exception
     */
    @Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public String saveAll( String jobId, List<Map<String, Object>> paramList ) throws Exception {
        int intCnt = 0;
        int uptCnt = 0;
        int delCnt = 0;
        int noCnt = 0;
        
        for (Map param : paramList) {
            param.put("JOB_ID", jobId);
            param.put("IF_DATE", jobId.substring(0, 8));
            param.put("IF_TIME", jobId.substring(8, jobId.length()));
            
            if ("V11".equals((String)param.get("COMP_CODE"))) {
                param.put("COMP_CODE", "V10");
            }
            
            if ("I".equals((String)param.get("STATUS"))) {
                intCnt = intCnt + insertMulti(param);
            } else if ("U".equals((String)param.get("STATUS"))) {
                uptCnt = intCnt + updateMulti(param);
            } else if ("D".equals((String)param.get("STATUS"))) {
                delCnt = intCnt + deleteMulti(param);
            } else {
                ++noCnt;
            }
        }
        return intCnt + "|" + uptCnt + "|" + delCnt + "|" + noCnt;
        
    }
        
    /**
     * TEMP 테이블 데이터 삭제 ( Web Service 용 )
     * 
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    public void deleteTempIssu() throws Exception {
        Map param = new HashMap();
        
        try {
            super.commonDao.delete("s_bsarpaid_jukrServiceImpl.deleteTemp", param);
        } catch (Exception ex) {
            logger.error(ex.getMessage());
        }
    }
    
    /**
     * 후불대체자동기표(보광)_후불회수 입력 ( Web Service 용 )
     * 
     * @param paramMap
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    public int insertMulti( Map paramMap ) throws Exception {
        return super.commonDao.insert("s_bsarpaid_jukrServiceImpl.insertMulti", paramMap);
    }
    
    /**
     * 후불대체자동기표(보광)_후불회수 수정 ( Web Service 용 )
     * 
     * @param paramMap
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    public int updateMulti( Map paramMap ) throws Exception {
        return super.commonDao.update("s_bsarpaid_jukrServiceImpl.updateMulti", paramMap);
    }
    
    /**
     * 후불대체자동기표(보광)_후불회수 삭제 ( Web Service 용 )
     * 
     * @param paramMap
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    public int deleteMulti( Map paramMap ) throws Exception {
        return super.commonDao.update("s_bsarpaid_jukrServiceImpl.deleteMulti", paramMap);
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
        return (Map)super.commonDao.select("s_bsarpaid_jukrServiceImpl.selectErrorList", param);
    }
    
}
