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
 * ACAUTOSLIP 정보
 * 
 * @author 박종영
 */
@Service( "acautoslipServiceImpl" )
public class AcautoslipServiceImpl extends TlabAbstractServiceImpl {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    private RestUtils    utils  = new RestUtils();
    
    /**
     * ACAUTOSLIP 정보 조회
     * 
     * @param paramMap
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "stdbase" )
    @SuppressWarnings( { "unchecked", "rawtypes" } )
    public List<Map<String, Object>> selectList( Map param ) throws Exception {
        return super.commonDao.list("AcautoslipServiceImpl.selectList", param);
    }
    
    /**************************************************************/
    /*********************** Web Service 용 ***********************/
    /**************************************************************/
    
    /**
     * ACAUTOSLIP 정보 저장 ( Web Service 용 )
     * 
     * @param paramList
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public Map saveAutoSlipTemp( List<Map<String, Object>> paramList, String jobId ) throws Exception {
        
        Map rtnMap = new HashMap();
        Map param = new HashMap();
        param.put("JOB_ID", jobId);
        
        try {
            saveAll(paramList, jobId);
        } catch (Exception e) {
            param.put("PROC_ERR_MSG", utils.errParse(e.getMessage()));
            logger.error("Detail Error map :: {}", param);
            super.commonDao.insert("AcautoslipServiceImpl.insertError", param);
        }
        
        /*
         * Error가 발생한 데이터 Key 조회
         */
        String errMsg = (String)( (Map)super.commonDao.select("AcautoslipServiceImpl.selectErrorList", param) ).get("ERR_KEY_SEQNO");
        logger.debug("errMsg :: {}", errMsg);
        if (errMsg.startsWith("1/")) {
            rtnMap.put("ERROR_DESC", errMsg);
        }
        
        return rtnMap;
        
    }
    
    /**
     * ACAUTOSLIP 정보 저장 ( Web Service 용 )
     * 
     * @param paramList
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public String saveAll( List<Map<String, Object>> paramList, String jobId ) throws Exception {
        int intCnt = 0;
        
        for (Map param : paramList) {
            param.put("JOB_ID", jobId);
            intCnt = intCnt + insertMulti(param);
        }
        
        return "" + intCnt;
    }
    
    /**
     * Temp 폴더에 데이터를 Insert 한다. ( Web Service 용 )
     * 
     * @param jobId
     * @param paramMap
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public Map saveTempToMain( String jobId ) throws Exception {
        Map rtnMap = new HashMap();
        Map param = new HashMap();
        param.put("JOB_ID", jobId);
        
        try {
            super.commonDao.delete("AcautoslipServiceImpl.deleteMulti", param);
            super.commonDao.insert("AcautoslipServiceImpl.insertTempMulti", param);
        } catch (Exception e) {
            param.put("PROC_ERR_MSG", utils.errorMsg(e.getMessage()));
            logger.error("Error Map :: {}", param);
            super.commonDao.insert("AcautoslipServiceImpl.insertError", param);
        }
        
        /*
         * Error가 발생한 데이터 Key 조회
         */
        String errMsg = (String)( (Map)super.commonDao.select("AcautoslipServiceImpl.selectErrorList", param) ).get("ERR_KEY_SEQNO");
        logger.debug("errMsg :: {}", errMsg);
        if (errMsg.startsWith("1/")) {
            rtnMap.put("ERROR_DESC", errMsg);
        }
        
        return rtnMap;
    }
    
    /**
     * ACAUTOSLIP 정보 입력 ( Web Service 용 )
     * 
     * @param paramMap
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    public int insertMulti( Map paramMap ) throws Exception {
        return super.commonDao.insert("AcautoslipServiceImpl.insertMulti", paramMap);
    }
    
}
