package api.rest.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import api.rest.utils.RestUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

/**
 * 인사 자동기표취소
 * 
 * @author 박종영
 */
@Service( "if_s_hpa650t_jukrServiceImpl" )
public class If_s_hpa650t_jukrServiceImpl extends TlabAbstractServiceImpl {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    private RestUtils    utils  = new RestUtils();
    
    /**
     * 인사 자동기표취소 조회
     * 
     * @param paramMap
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "unchecked", "rawtypes" } )
    public List<Map<String, Object>> selectList( Map param ) throws Exception {
        return super.commonDao.list("if_s_hpa650t_jukrServiceImpl.selectList", param);
    }
    
    /**************************************************************/
    /*********************** Web Service 용 ***********************/
    /**************************************************************/
    
    /**
     * Temp 테이블에 데이터를 Insert 한다. ( Web Service 용 )
     * 
     * @param jobId
     * @param paramMap
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public String apiSaveAll( String jobId, List<Map<String, Object>> paramList ) throws Exception {
        Map rMap = null;
        
        for (Map param : paramList) {
            param.put("JOB_ID", jobId);
            
            rMap = (Map)super.commonDao.queryForObject("commonServiceImpl.getRefCode", param);
            logger.info("rMap :: {}", rMap);
            if (rMap != null) {
                param.put("COMP_CODE", rMap.get("REF_CODE1"));
            }
            logger.info("param :: {}", param);
            
            param.put("IF_DATE", jobId.substring(0, 8));
            param.put("IF_TIME", jobId.substring(8, jobId.length()));
            param.put("KEY_SEQNO", (String)param.get("COMP_CODE") + (String)param.get("AC_DATE") + ( (Double)param.get("SLIP_NUM") ).intValue());
            
            try {
                super.commonDao.insert("if_s_hpa650t_jukrServiceImpl.saveIssuTemp", param);
            } catch (Exception ce) {
                param.put("PROC_ERR_MSG", ce.getMessage());
                logger.error("Detail Error map :: {}", param);
                super.commonDao.insert("if_s_hpa650t_jukrServiceImpl.insertError", param);
            }
        }
        
        /*
         * Error가 발생한 데이터 Key 조회
         */
        Map param = new HashMap();
        param.put("JOB_ID", jobId);
        return (String)( (Map)super.commonDao.select("if_s_hpa650t_jukrServiceImpl.selectErrorList", param) ).get("ERR_KEY_SEQNO");
    }
    
    /**
     * Temp 테이블에서 인사자동기표 취소 으로 데이터를 저장 한다. ( Web Service 용 )
     * 
     * @param jobId
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public String saveTempToMain( String jobId ) throws Exception {
        Map param = new HashMap();
        param.put("JOB_ID", jobId);
        
        try {
            super.commonDao.select("if_s_hpa650t_jukrServiceImpl.USP_ACCNT_HPA650T", param);
        } catch (Exception e) {
            param.put("PROC_ERR_MSG", e.getMessage());
            logger.error("Detail Error map :: {}", param);
            super.commonDao.insert("if_s_hpa650t_jukrServiceImpl.insertError", param);
            
            super.commonDao.delete("if_s_hpa650t_jukrServiceImpl.deleteMulti", param);
        }
        
        return (String)( (Map)super.commonDao.select("if_s_hpa650t_jukrServiceImpl.selectErrorList", param) ).get("ERR_KEY_SEQNO");
    }
    
    /**
     * 인사 자동기표취소 저장 ( Web Service 용 )
     * 
     * @param paramList
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public String callProc01( String jobId ) throws Exception {
        
        /*
         * Error가 발생한 데이터 Key 조회
         */
        Map param = new HashMap();
        param.put("JOB_ID", jobId);
        
        try {
            
            List<Map> rtnList = super.commonDao.list("if_s_hpa650t_jukrServiceImpl.selectList", param);
            for (Map rtnMap : rtnList) {
                super.commonDao.select("if_s_hpa650t_jukrServiceImpl.USP_ACCNT_AUTOSLIP_INTERFACE_PAY_CANCEL_JS", rtnMap);
            }
            
        } catch (Exception e) {
            try {
                param.put("PROC_ERR_MSG", e.getMessage());
                logger.error("Detail Error map :: {}", param);
                super.commonDao.insert("if_s_hpa650t_jukrServiceImpl.insertError", param);
                
                super.commonDao.update("if_s_hpa650t_jukrServiceImpl.deleteMulti", param);
            } catch (Exception ex) {
                logger.error(ex.getMessage());
            }
        }
        
        String errKeySeqno = (String)( (Map)super.commonDao.select("if_s_hpa650t_jukrServiceImpl.selectErrorList", param) ).get("ERR_KEY_SEQNO");
        
        return errKeySeqno;
        
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
            super.commonDao.delete("if_s_hpa650t_jukrServiceImpl.deleteTemp", param);
        } catch (Exception ex) {
            logger.error(ex.getMessage());
        }
    }
    
}
