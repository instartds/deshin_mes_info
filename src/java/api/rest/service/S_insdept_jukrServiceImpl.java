package api.rest.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import api.rest.exception.CustomException;
import api.rest.utils.RestUtils;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

/**
 * 수불대체자동기표(보광)_현장재고
 * 
 * @author 박종영
 */
@Service( "s_insdept_jukrServiceImpl" )
public class S_insdept_jukrServiceImpl extends TlabAbstractServiceImpl {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    private RestUtils    utils  = new RestUtils();
    
    /**
     * 수불대체자동기표(보광)_현장재고 조회
     * 
     * @param paramMap
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "stdbase" )
    @SuppressWarnings( { "unchecked", "rawtypes" } )
    public List<Map<String, Object>> selectList( Map param ) throws Exception {
        return super.commonDao.list("s_insdept_jukrServiceImpl.selectList", param);
    }
    
    /**************************************************************/
    /*********************** Web Service 용 ***********************/
    /**************************************************************/
    
    
    /**
     * 수불대체자동기표(보광)_현장재고 저장 ( Web Service 용 )
     * 
     * @param paramList
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked", "unused" } )
    public Map apiSaveIF( List<Map<String, Object>> paramList, String jobId) throws Exception {
        
        String inrcvValue = null;
        
        Map rtnMap = new HashMap();
        Map param = new HashMap();
        param.put("JOB_ID", jobId);
        
        try {
            inrcvValue = saveAll(jobId, paramList);
        } catch (Exception e) {
            param.put("PROC_ERR_MSG", utils.errParse(e.getMessage()));
            logger.error("Detail Error map :: {}", param);
            super.commonDao.insert("s_insdept_jukrServiceImpl.insertError", param);
        }
        
        /*
         * Error가 발생한 데이터 Key 조회
         */
        String errMsg = (String)( (Map)super.commonDao.list("s_insdept_jukrServiceImpl.selectErrorList", param).get(0) ).get("ERR_KEY_SEQNO");
        logger.debug("errMsg :: {}", errMsg);
        if(errMsg.startsWith("1/")) {
            rtnMap.put("ERROR_DESC", (String)rtnMap.get("ERROR_DESC") + "," + errMsg);
        }
        
        return rtnMap;
    }    
    
    /**
     * Temp 테이블에서 수불대체자동기표로 정보를 저장한다.
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
            super.commonDao.list("s_insdept_jukrServiceImpl.USP_ACCNT_IFC0009", param); 
        } catch (Exception e) {
            param.put("PROC_ERR_MSG", utils.errorMsg(e.getMessage()));
            logger.error("Error Map :: {}", param);
            super.commonDao.insert("s_insdept_jukrServiceImpl.insertError", param);
            super.commonDao.update("s_insdept_jukrServiceImpl.deleteMulti", param);
        }
        /*
         * Error가 발생한 데이터 Key 조회
         */
        String errMsg = (String)( (Map)super.commonDao.list("s_insdept_jukrServiceImpl.selectErrorList", param).get(0) ).get("ERR_KEY_SEQNO");
        logger.debug("errMsg :: {}", errMsg);
        if(errMsg.startsWith("1/")) {
            param.put("ERROR_DESC", errMsg);
        }
        return param; 
    }
    
    /**
     * 수불대체자동기표를 실행한다
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
             * 수불대체자동기표 IF Procedure를 호출한다.
             */
            authSlipInterface(map);
            List list = super.commonDao.list("s_insdept_jukrServiceImpl.selectAutoResultSp", map);
            Map cnt = (Map)super.commonDao.select("s_insdept_jukrServiceImpl.selectErrorSpCnt", map);
            logger.info("list :: {}", list);
            rtnMap.put("RESULT", list);
            rtnMap.put("CNT", cnt.get("CNT"));
        } catch (Exception e) {
            e.printStackTrace();
            map.put("PROC_ERR_MSG", utils.errorMsg(e.getMessage()));
            logger.error("Error Map :: {}", map);
            super.commonDao.insert("s_insdept_jukrServiceImpl.insertError", map);
            super.commonDao.update("s_insdept_jukrServiceImpl.deleteMulti", map);
        }
        
        /*
         * Error가 발생한 데이터 Key 조회
         */
        String errMsg = (String)( (Map)super.commonDao.list("s_insdept_jukrServiceImpl.selectErrorList", map).get(0) ).get("ERR_KEY_SEQNO");
        logger.debug("errMsg :: {}", errMsg);
        if(errMsg.startsWith("1/")) {
            rtnMap.put("ERROR_DESC", (String)rtnMap.get("ERROR_DESC") + "," + errMsg);
        }
        
        return rtnMap;
    }    
    
    /**
     * 수불대체자동기표(보광)_현장재고 저장 ( Web Service 용 )
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
        String inrcvsValue = null;
        
        try {
            inrcvValue = saveAll(jobId, paramList);
        } catch (Exception e) {
            logger.info("--------------------------");
            e.printStackTrace();
            Map param = new HashMap();
            param.put("JOB_ID", jobId);
            super.commonDao.update("s_insdept_jukrServiceImpl.deleteMulti", param);
            
            param.put("PROC_ERR_MSG", utils.errParse(e.getMessage()));
            logger.error("Detail Error map :: {}", param);
            super.commonDao.insert("s_insdept_jukrServiceImpl.insertError", param);
            
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
        List list = super.commonDao.list("s_insdept_jukrServiceImpl.selectAutoResultSp", map);
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
            super.commonDao.list("s_insdept_jukrServiceImpl.USP_ACCNT_AutoSlipB2_JS", map);
        } catch (Exception ex) {
            logger.error(ex.getMessage());
            map.put("PROC_ERR_MSG", utils.errorMsg(ex.getMessage()));
            logger.error("Error Map :: {}", map);
            super.commonDao.insert("s_insdept_jukrServiceImpl.insertError", map);
        }
    }
    
    
    /**
     * 수불대체자동기표(보광)_현장재고 저장 ( Web Service 용 )
     * 
     * @param paramList
     * @return
     * @throws Exception
     */
    @Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public String saveAll( String jobId, List<Map<String, Object>> paramList ) throws Exception {
        int intCnt = 0;
        
        for (Map param : paramList) {
            param.put("JOB_ID", jobId);
            param.put("IF_DATE", jobId.substring(0, 8));
            param.put("IF_TIME", jobId.substring(8, jobId.length()));
            
            if ("V10".equals(param.get("COMP_CODE"))) {
                param.put("IN_MDEPT1", "11" + ((String)param.get("IN_MDEPT1")));
            }
            if ("V11".equals((String)param.get("COMP_CODE"))) {
                param.put("COMP_CODE", "V10");
                param.put("IN_MDEPT1", "12" + ((String)param.get("IN_MDEPT1")));
            }
            
            // 계정코드는 6자리임.
            // 6자리보다 작으면 뒤에 '0'를 자리수만큼 붙임.
            String IN_MOACC = (String)param.get("IN_MOACC");
            if(IN_MOACC.length() != 6) {
                int st = IN_MOACC.length();
                for(int i = st; i < 6; i++) {
                    IN_MOACC = IN_MOACC + "0";
                }
                
                param.put("IN_MOACC", IN_MOACC);
            }
            
            String IN_MIACC = (String)param.get("IN_MIACC");
            if(IN_MIACC.length() != 6) {
                int st = IN_MIACC.length();
                for(int i = st; i < 6; i++) {
                    IN_MIACC = IN_MIACC + "0";
                }
                
                param.put("IN_MIACC", IN_MIACC);
            }
            
            intCnt = insertMulti(param);
        }
        
        return "" + intCnt;
        
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
            super.commonDao.delete("s_insdept_jukrServiceImpl.deleteTemp", param);
        } catch (Exception ex) {
            logger.error(ex.getMessage());
        }
    }
    
    /**
     * 수불대체자동기표(보광)_현장재고 입력 ( Web Service 용 )
     * 
     * @param paramMap
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    public int insertMulti( Map paramMap ) throws Exception {
        return super.commonDao.insert("s_insdept_jukrServiceImpl.insertMulti", paramMap);
    }
    
    /**
     * 수불대체자동기표(보광)_현장재고 수정 ( Web Service 용 )
     * 
     * @param paramMap
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    public int updateMulti( Map paramMap ) throws Exception {
        return super.commonDao.update("s_insdept_jukrServiceImpl.updateMulti", paramMap);
    }
    
    /**
     * 수불대체자동기표(보광)_현장재고 삭제 ( Web Service 용 )
     * 
     * @param paramMap
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    public int deleteMulti( Map paramMap ) throws Exception {
        return super.commonDao.update("s_insdept_jukrServiceImpl.deleteMulti", paramMap);
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
        return (Map)super.commonDao.select("s_insdept_jukrServiceImpl.selectErrorList", param);
    }

 
    
}
