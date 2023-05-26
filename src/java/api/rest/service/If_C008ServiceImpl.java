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
 * 보광 매입 대체 자동기표 IF
 * 
 * @author 박종영
 */
@Service( "if_C008ServiceImpl" )
public class If_C008ServiceImpl extends TlabAbstractServiceImpl {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    private RestUtils    utils  = new RestUtils();
           
    /**
     * 매입대체자동기표_입고_MASTER
     * 
     * @param paramMap
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "accnt" )
    @SuppressWarnings( { "unchecked", "rawtypes" } )
    public List<Map<String, Object>> selectINRCVList( Map param ) throws Exception {
        return super.commonDao.list("if_C008ServiceImpl.selectINRCVList", param);
    }
    
    /**
     * 매입대체자동기표_입고_DETAIL
     * 
     * @param paramMap
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "accnt" )
    @SuppressWarnings( { "unchecked", "rawtypes" } )
    public List<Map<String, Object>> selectINRCVSList( Map param ) throws Exception {
        return super.commonDao.list("if_C008ServiceImpl.selectINRCVSList", param);
    }
    
    /**************************************************************/
    /*********************** Web Service 용 ***********************/
    /**************************************************************/
   
    

    /**
     * <pre>
     * 보광 매입대체 자동기표 IF ( Web Service 용 ) 한 Transaction 정리
     * 
     * 매입대체자동기표_입고_MASTER(S_INRCV_JS)
     * 매입대체자동기표_입고_DETAIL(S_INRCVS_JS)
     * </pre>
     * 
     * @param paramList
     * @return 
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked", "unused" } )
    public Map apiSaveIF( List<Map<String, Object>> masterDataList, List<Map<String, Object>> detailDataList, String jobId) throws Exception {
        
        String inrcvValue = null;
        String inrcvsValue = null;
        
        Map rtnMap = new HashMap();
        Map param = new HashMap();
        param.put("JOB_ID", jobId);
        
        try {
            inrcvValue = saveINRCVAll(jobId, masterDataList);
            inrcvsValue = saveINRCVSAll(jobId, masterDataList, detailDataList);
        } catch (Exception e) {
            param.put("PROC_ERR_MSG", utils.errParse(e.getMessage()));
            logger.error("Detail Error map :: {}", param);
            super.commonDao.insert("if_C008ServiceImpl.insertError", param);
        }
        
        /*
         * Error가 발생한 데이터 Key 조회
         */
        String errMsg = (String)( (Map)super.commonDao.list("if_C008ServiceImpl.selectErrorList", param).get(0) ).get("ERR_KEY_SEQNO");
        logger.debug("errMsg :: {}", errMsg);
        if(errMsg.startsWith("1/")) {
            rtnMap.put("ERROR_DESC", (String)rtnMap.get("ERROR_DESC") + "," + errMsg);
        }
        
        return rtnMap;
       
    }
    
    
    /**
     * <pre>
     * 보광 매입대체 자동기표 IF ( Web Service 용 ) 한 Transaction 정리
     * 
     * 매입대체자동기표_입고_MASTER(S_INRCV_JS)
     * 매입대체자동기표_입고_DETAIL(S_INRCVS_JS)
     * </pre>
     * 
     * @param paramList
     * @return
     * @throws Exception
     */
    @Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
    @SuppressWarnings( { "rawtypes", "unchecked", "unused" } )
    public Map apiSaveAll( List<Map<String, Object>> masterDataList, List<Map<String, Object>> detailDataList) throws Exception {
        
        /*
         * Job ID 생성
         */
        String jobId = utils.makeExcelJobID();
        String inrcvValue = null;
        String inrcvsValue = null;
        
        try {
            inrcvValue = saveINRCVAll(jobId, masterDataList);
            inrcvsValue = saveINRCVSAll(jobId, masterDataList, detailDataList);
        } catch (Exception e) {
            logger.info("--------------------------");
            e.printStackTrace();
            Map param = new HashMap();
            param.put("JOB_ID", jobId);
            super.commonDao.update("if_C008ServiceImpl.deleteMulti", param);
            
            param.put("PROC_ERR_MSG", utils.errParse(e.getMessage()));
            logger.error("Detail Error map :: {}", param);
            super.commonDao.insert("if_C008ServiceImpl.insertError", param);
            
            logger.info("--------------------------");
            
            throw new Exception(utils.errParse(e.getMessage()));
        }
        
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("COMP_CODE", masterDataList.get(0).get("COMP_CODE"));
        map.put("APP_ID", masterDataList.get(0).get("APP_ID"));
        map.put("IF_DATE", jobId.substring(0, 8));
        map.put("IF_TIME", jobId.substring(8, jobId.length()));
        
        /*
         * 전표 처리 한다.
         */
        authSlipInterface(map);
        List list = super.commonDao.list("if_C008ServiceImpl.selectAutoResultSp", map);
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
            super.commonDao.list("if_C008ServiceImpl.USP_ACCNT_AutoSlipB1_JS", map);
        } catch (Exception ex) {
            map.put("PROC_ERR_MSG", utils.errorMsg(ex.getMessage()));
            logger.error("Error Map :: {}", map);
            super.commonDao.insert("if_C008ServiceImpl.insertError", map);
        }
    }

    /**
     * Temp 테이블에서 매입대체테이블로 정보를 저장한다.
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
            super.commonDao.list("if_C008ServiceImpl.USP_ACCNT_IFC0008", param); 
        } catch (Exception e) {
            param.put("PROC_ERR_MSG", utils.errorMsg(e.getMessage()));
            logger.error("Error Map :: {}", param);
            super.commonDao.insert("if_C008ServiceImpl.insertError", param);
            super.commonDao.update("if_C008ServiceImpl.deleteMulti", param);
        }
        /*
         * Error가 발생한 데이터 Key 조회
         */
        String errMsg = (String)( (Map)super.commonDao.list("if_C008ServiceImpl.selectErrorList", param).get(0) ).get("ERR_KEY_SEQNO");
        logger.debug("errMsg :: {}", errMsg);
        if(errMsg.startsWith("1/")) {
            param.put("ERROR_DESC", errMsg);
        }
        return param; 
    }
 
    /**
     * 매입대체자동기표를 실행한다
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
             * 매입대체자동기표 IF Procedure를 호출한다.
             */
            authSlipInterface(map);
            List list = super.commonDao.list("if_C008ServiceImpl.selectAutoResultSp", map);
            Map cnt = (Map)super.commonDao.select("if_C008ServiceImpl.selectErrorSpCnt", map);
            logger.info("list :: {}", list);
            logger.info("CNT :: {}", cnt);
            rtnMap.put("RESULT", list);
            rtnMap.put("CNT", cnt.get("CNT"));
        } catch (Exception e) {
            e.printStackTrace();
            map.put("PROC_ERR_MSG", utils.errorMsg(e.getMessage()));
            logger.error("Error Map :: {}", map);
            super.commonDao.insert("if_C008ServiceImpl.insertError", map);
            super.commonDao.update("if_C008ServiceImpl.deleteMulti", map);
        }
        
        /*
         * Error가 발생한 데이터 Key 조회
         */
        String errMsg = (String)( (Map)super.commonDao.list("if_C008ServiceImpl.selectErrorList", map).get(0) ).get("ERR_KEY_SEQNO");
        logger.debug("errMsg :: {}", errMsg);
        if(errMsg.startsWith("1/")) {
            rtnMap.put("ERROR_DESC", (String)rtnMap.get("ERROR_DESC") + "," + errMsg);
        }
        
        return rtnMap;
    }
    
    
    /**
     * 매입대체자동기표_입고_MASTER 저장 ( Web Service 용 )
     * 
     * @param paramList
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public String saveINRCVAll( String jobId, List<Map<String, Object>> paramList ) throws Exception {
        int intCnt = 0;
        
        for (Map param : paramList) {
            param.put("JOB_ID", jobId);
            param.put("IF_DATE", jobId.substring(0, 8));
            param.put("IF_TIME", jobId.substring(8, jobId.length()));
            
            if ("V11".equals((String)param.get("COMP_CODE"))) {
                param.put("COMP_CODE", "V10");
            }
            
            intCnt = insertINRCVMulti(param);

        }
        
        return "" + intCnt;
        
    }
    
    /**
     * 매입대체자동기표_입고_DETAIL 저장 ( Web Service 용 )
     * 
     * @param paramList
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public String saveINRCVSAll( String jobId, List<Map<String, Object>> masterList, List<Map<String, Object>> detailList ) throws Exception {
        int intCnt = 0;
        
        Map masParam = (Map)masterList.get(0);
        for (Map param : detailList) {
            param.put("JOB_ID", jobId);
            param.put("IF_DATE", jobId.substring(0, 8));
            param.put("IF_TIME", jobId.substring(8, jobId.length()));
            param.put("SUPP_TYPE", masParam.get("SUPP_TYPE"));
            param.put("PAY_YYYYMM", masParam.get("PAY_YYYYMM"));
            param.put("SUPP_DATE", masParam.get("SUPP_DATE"));
            
            if ("V10".equals(param.get("COMP_CODE"))) {
                param.put("IN_RSDEPT1", "11" + ((String)param.get("IN_RSDEPT1")));
            }
            if ("V11".equals((String)param.get("COMP_CODE"))) {
                param.put("COMP_CODE", "V10");
                param.put("IN_RSDEPT1", "12" + ((String)param.get("IN_RSDEPT1")));
            }
            
            intCnt = insertINRCVSMulti(param);
        }
        return "" + intCnt;
        
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
        return super.commonDao.insert("if_C008ServiceImpl.insertHBS300TMulti", paramMap);
    }
    
    /**
     * 매입대체자동기표_입고_MASTER 입력 ( Web Service 용 )
     * 
     * @param paramMap
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    public int insertINRCVMulti( Map paramMap ) throws Exception {
        return super.commonDao.insert("if_C008ServiceImpl.insertINRCVMulti", paramMap);
    }
    
    /**
     * 매입대체자동기표_입고_DETAIL 입력 ( Web Service 용 )
     * 
     * @param paramMap
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    public int insertINRCVSMulti( Map paramMap ) throws Exception {
        return super.commonDao.insert("if_C008ServiceImpl.insertINRCVSMulti", paramMap);
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
        return super.commonDao.update("if_C008ServiceImpl.updateHBS300TMulti", paramMap);
    }
    
    /**
     * 매입대체자동기표_입고_MASTER 수정 ( Web Service 용 )
     * 
     * @param paramMap
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    public int updateINRCVMulti( Map paramMap ) throws Exception {
        return super.commonDao.update("if_C008ServiceImpl.updateINRCVMulti", paramMap);
    }
    
    /**
     * 매입대체자동기표_입고_DETAIL 수정 ( Web Service 용 )
     * 
     * @param paramMap
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    public int updateINRCVSMulti( Map paramMap ) throws Exception {
        return super.commonDao.update("if_C008ServiceImpl.updateINRCVSMulti", paramMap);
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
        return super.commonDao.update("if_C008ServiceImpl.deleteHBS300TMulti", paramMap);
    }
    
    /**
     * 매입대체자동기표_입고_MASTER 삭제 ( Web Service 용 )
     * 
     * @param paramMap
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    public int deleteINRCVMulti( Map paramMap ) throws Exception {
        return super.commonDao.update("if_C008ServiceImpl.deleteINRCVMulti", paramMap);
    }
    
    /**
     * 매입대체자동기표_입고_DETAIL 삭제 ( Web Service 용 )
     * 
     * @param paramMap
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    public int deleteINRCVSMulti( Map paramMap ) throws Exception {
        return super.commonDao.update("if_C008ServiceImpl.deleteINRCVSMulti", paramMap);
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
        return (Map)super.commonDao.select("if_C008ServiceImpl.selectErrorList", param);
    }

    

    
}
