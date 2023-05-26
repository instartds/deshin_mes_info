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
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

/**
 * 보광 매출 대체 자동기표 IF
 * 
 * @author 박종영
 */
@Service( "if_C010ServiceImpl" )
public class If_C010ServiceImpl extends TlabAbstractServiceImpl {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    private RestUtils    utils  = new RestUtils();
           
    /**
     * 매출대체자동기표(보광)_후불발생
     * 
     * @param paramMap
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "accnt" )
    @SuppressWarnings( { "unchecked", "rawtypes" } )
    public List<Map<String, Object>> selectBSAROCCList( Map param ) throws Exception {
        return super.commonDao.list("if_C010ServiceImpl.selectBSAROCCList", param);
    }
    
    /**
     * 매출대체자동기표(보광)_영업장별 매출집계
     * 
     * @param paramMap
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "accnt" )
    @SuppressWarnings( { "unchecked", "rawtypes" } )
    public List<Map<String, Object>> selectBSSALESUMList( Map param ) throws Exception {
        return super.commonDao.list("if_C010ServiceImpl.selectBSSALESUMList", param);
    }
    
    
    /**
     * 매출대체자동기표(보광)_지불수단별 매출집계
     * 
     * @param paramMap
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "accnt" )
    @SuppressWarnings( { "unchecked", "rawtypes" } )
    public List<Map<String, Object>> selectBSPAYSUMList( Map param ) throws Exception {
        return super.commonDao.list("if_C010ServiceImpl.selectBSPAYSUMList", param);
    }
    
    /**************************************************************/
    /*********************** Web Service 용 ***********************/
    /**************************************************************/
 
    
    /**
     * <pre>
     * 보광 매입대체 자동기표 IF ( Web Service 용 ) 한 Transaction 정리
     * 
     * 매출대체자동기표(보광)_후불발생(S_BSAROCC_JS)
     * 매출대체자동기표(보광)_영업장별 매출집계(S_BSSALESUM_JS)
     * 매출대체자동기표(보광)_지불수단별 매출집계(S_BSPAYSUM_JS)
     * </pre>
     * 
     * @param paramList
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked", "unused" } )
    public Map apiSaveIF( List<Map<String, Object>> BSAROCC, List<Map<String, Object>> BSSALESUM, List<Map<String, Object>> BSPAYSUM, String jobId) throws Exception {
        Map rtnMap = new HashMap();
        Map param = new HashMap();
        param.put("JOB_ID", jobId);
        
        try {
            saveBSAROCCAll(jobId, BSAROCC);
            saveBSSALESUMAll(jobId, BSSALESUM);
            saveBSPAYSUMAll(jobId, BSPAYSUM);
        } catch (Exception e) {
            param.put("PROC_ERR_MSG", utils.errParse(e.getMessage()));
            logger.error("Detail Error map :: {}", param);
            super.commonDao.insert("if_C010ServiceImpl.insertError", param);;
        }
        
        /*
         * Error가 발생한 데이터 Key 조회
         */
        String errMsg = (String)( (Map)super.commonDao.list("if_C010ServiceImpl.selectErrorList", param).get(0) ).get("ERR_KEY_SEQNO");
        logger.debug("errMsg :: {}", errMsg);
        if(errMsg.startsWith("1/")) {
            rtnMap.put("ERROR_DESC", (String)rtnMap.get("ERROR_DESC") + "," + errMsg);
        }
        
        return rtnMap;
    }
    
    /**
     * Temp 테이블에서 매출대체자동기표로 정보를 저장한다.
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
            super.commonDao.list("if_C010ServiceImpl.USP_ACCNT_IFC0010", param); 
        } catch (Exception e) {
            param.put("PROC_ERR_MSG", utils.errorMsg(e.getMessage()));
            logger.error("Error Map :: {}", param);
            super.commonDao.insert("if_C010ServiceImpl.insertError", param);
            super.commonDao.update("if_C010ServiceImpl.deleteMulti", param);
        }
        /*
         * Error가 발생한 데이터 Key 조회
         */
        String errMsg = (String)( (Map)super.commonDao.list("if_C010ServiceImpl.selectErrorList", param).get(0) ).get("ERR_KEY_SEQNO");
        logger.debug("errMsg :: {}", errMsg);
        if(errMsg.startsWith("1/")) {
            param.put("ERROR_DESC", errMsg);
        }
        return param; 
    }
    
    
    /**
     * 매출대체자동기표를 실행한다
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
             * 매출대체자동기표 IF Procedure를 호출한다.
             */
            authSlipInterface(map);
            List list = super.commonDao.list("if_C010ServiceImpl.selectAutoResultSp", map);
            Map cnt = (Map)super.commonDao.select("if_C010ServiceImpl.selectErrorSpCnt", map);
            logger.info("list :: {}", list);
            rtnMap.put("RESULT", list);
            rtnMap.put("CNT", cnt.get("CNT"));
        } catch (Exception e) {
            e.printStackTrace();
            map.put("PROC_ERR_MSG", utils.errorMsg(e.getMessage()));
            logger.error("Error Map :: {}", map);
            super.commonDao.insert("if_C010ServiceImpl.insertError", map);
            super.commonDao.update("if_C010ServiceImpl.deleteMulti", map);
        }
        
        /*
         * Error가 발생한 데이터 Key 조회
         */
        String errMsg = (String)( (Map)super.commonDao.list("if_C010ServiceImpl.selectErrorList", map).get(0) ).get("ERR_KEY_SEQNO");
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
     * 매출대체자동기표(보광)_후불발생(S_BSAROCC_JS)
     * 매출대체자동기표(보광)_영업장별 매출집계(S_BSSALESUM_JS)
     * 매출대체자동기표(보광)_지불수단별 매출집계(S_BSPAYSUM_JS)
     * </pre>
     * 
     * @param paramList
     * @return
     * @throws Exception
     */
    @Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
    @SuppressWarnings( { "rawtypes", "unchecked", "unused" } )
    public Map apiSaveAll( List<Map<String, Object>> BSAROCC, List<Map<String, Object>> BSSALESUM, List<Map<String, Object>> BSPAYSUM ) throws Exception {
        
        /*
         * Job ID 생성
         */
        String jobId = utils.makeExcelJobID();
        String inrcvValue = null;
        String inrcvsValue = null;
        
        try {
            inrcvValue = saveBSAROCCAll(jobId, BSAROCC);
            inrcvsValue = saveBSSALESUMAll(jobId, BSSALESUM);
            inrcvsValue = saveBSPAYSUMAll(jobId, BSPAYSUM);
        } catch (Exception e) {
            logger.info("--------------------------");
            e.printStackTrace();
            Map param = new HashMap();
            param.put("JOB_ID", jobId);
            super.commonDao.update("if_C010ServiceImpl.deleteMulti", param);
            
            param.put("PROC_ERR_MSG", utils.errParse(e.getMessage()));
            logger.error("Detail Error map :: {}", param);
            super.commonDao.insert("if_C010ServiceImpl.insertError", param);
            
            logger.info("--------------------------");
            
            throw new Exception(utils.errParse(e.getMessage()));
        }
        
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("COMP_CODE", BSAROCC.get(0).get("COMP_CODE"));
        map.put("APP_ID", BSAROCC.get(0).get("APP_ID"));
        map.put("IF_DATE", jobId.substring(0, 8));
        map.put("IF_TIME", jobId.substring(8, jobId.length()));
        
        /*
         * 전표 처리 한다.
         */
        authSlipInterface(map);
        List list = super.commonDao.list("if_C010ServiceImpl.selectAutoResultSp", map);
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
            super.commonDao.list("if_C010ServiceImpl.USP_ACCNT_AutoSlipB3_JS", map);
        } catch (Exception ex) {
            logger.error(ex.getMessage());
            map.put("PROC_ERR_MSG", utils.errorMsg(ex.getMessage()));
            logger.error("Error Map :: {}", map);
            super.commonDao.insert("if_C010ServiceImpl.insertError", map);
        }
    }

    /**
     * 매출대체자동기표(보광)_후불발생 저장 ( Web Service 용 )
     * 
     * @param paramList
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public String saveBSAROCCAll( String jobId, List<Map<String, Object>> BSAROCC ) throws Exception {
        int intCnt = 0;
        int uptCnt = 0;
        int delCnt = 0;
        int noCnt = 0;
        
        for (Map param : BSAROCC) {
            param.put("JOB_ID", jobId);
            param.put("IF_DATE", jobId.substring(0, 8));
            param.put("IF_TIME", jobId.substring(8, jobId.length()));
            
            if ("V11".equals(param.get("COMP_CODE"))) {
                param.put("COMP_CODE", "V10");
            }
            
            if ("I".equals((String)param.get("STATUS"))) {
                intCnt = intCnt + insertBSAROCCMulti(param);
            } else if ("U".equals((String)param.get("STATUS"))) {
                uptCnt = intCnt + updateBSAROCCMulti(param);
            } else if ("D".equals((String)param.get("STATUS"))) {
                delCnt = intCnt + deleteBSAROCCMulti(param);
            } else {
                ++noCnt;
            }
        }
        return intCnt + "|" + uptCnt + "|" + delCnt + "|" + noCnt;
        
    }
    
    /**
     * 매출대체자동기표(보광)_영업장별 매출집계 저장 ( Web Service 용 )
     * 
     * @param paramList
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public String saveBSSALESUMAll( String jobId, List<Map<String, Object>> BSSALESUM ) throws Exception {
        int intCnt = 0;
        int uptCnt = 0;
        int delCnt = 0;
        int noCnt = 0;
        
        for (Map param : BSSALESUM) {
            param.put("JOB_ID", jobId);
            param.put("IF_DATE", jobId.substring(0, 8));
            param.put("IF_TIME", jobId.substring(8, jobId.length()));
            
            if ("V11".equals(param.get("COMP_CODE"))) {
                param.put("COMP_CODE", "V10");
            }
            
            if ("I".equals((String)param.get("STATUS"))) {
                intCnt = intCnt + insertBSSALESUMMulti(param);
            } else if ("U".equals((String)param.get("STATUS"))) {
                uptCnt = intCnt + updateBSSALESUMMulti(param);
            } else if ("D".equals((String)param.get("STATUS"))) {
                delCnt = intCnt + deleteBSSALESUMMulti(param);
            } else {
                ++noCnt;
            }
        }
        return intCnt + "|" + uptCnt + "|" + delCnt + "|" + noCnt;
        
    }
    
    /**
     * 매출대체자동기표(보광)_지불수단별 매출집계 저장 ( Web Service 용 )
     * 
     * @param paramList
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public String saveBSPAYSUMAll( String jobId, List<Map<String, Object>> BSPAYSUM ) throws Exception {
        int intCnt = 0;
        int uptCnt = 0;
        int delCnt = 0;
        int noCnt = 0;
        
        for (Map param : BSPAYSUM) {
            param.put("JOB_ID", jobId);
            param.put("IF_DATE", jobId.substring(0, 8));
            param.put("IF_TIME", jobId.substring(8, jobId.length()));
            
            if ("V11".equals(param.get("COMP_CODE"))) {
                param.put("COMP_CODE", "V10");
            }
            
            if ("I".equals((String)param.get("STATUS"))) {
                intCnt = intCnt + insertBSPAYSUMMulti(param);
            } else if ("U".equals((String)param.get("STATUS"))) {
                uptCnt = intCnt + updateBSPAYSUMMulti(param);
            } else if ("D".equals((String)param.get("STATUS"))) {
                delCnt = intCnt + deleteBSPAYSUMMulti(param);
            } else {
                ++noCnt;
            }
        }
        return intCnt + "|" + uptCnt + "|" + delCnt + "|" + noCnt;
        
    }
    

    
    /**
     * 매출대체자동기표(보광)_후불발생 입력 ( Web Service 용 )
     * 
     * @param paramMap
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    public int insertBSAROCCMulti( Map paramMap ) throws Exception {
        return super.commonDao.insert("if_C010ServiceImpl.insertBSAROCCMulti", paramMap);
    }
    
    /**
     * 매출대체자동기표(보광)_영업장별 매출집계 입력 ( Web Service 용 )
     * 
     * @param paramMap
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    public int insertBSSALESUMMulti( Map paramMap ) throws Exception {
        return super.commonDao.insert("if_C010ServiceImpl.insertBSSALESUMMulti", paramMap);
    }
    
    /**
     * 매출대체자동기표(보광)_지불수단별 매출집계 입력 ( Web Service 용 )
     * 
     * @param paramMap
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    public int insertBSPAYSUMMulti( Map paramMap ) throws Exception {
        return super.commonDao.insert("if_C010ServiceImpl.insertBSPAYSUMMulti", paramMap);
    }
    
    /**
     * 매출대체자동기표(보광)_후불발생 수정 ( Web Service 용 )
     * 
     * @param paramMap
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    public int updateBSAROCCMulti( Map paramMap ) throws Exception {
        return super.commonDao.update("if_C010ServiceImpl.updateBSAROCCMulti", paramMap);
    }
    
    /**
     * 매출대체자동기표(보광)_영업장별 매출집계 수정 ( Web Service 용 )
     * 
     * @param paramMap
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    public int updateBSSALESUMMulti( Map paramMap ) throws Exception {
        return super.commonDao.update("if_C010ServiceImpl.updateBSSALESUMMulti", paramMap);
    }
    
    /**
     * 매출대체자동기표(보광)_지불수단별 매출집계 수정 ( Web Service 용 )
     * 
     * @param paramMap
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    public int updateBSPAYSUMMulti( Map paramMap ) throws Exception {
        return super.commonDao.update("if_C010ServiceImpl.updateBSPAYSUMMulti", paramMap);
    }
    
    /**
     * 매출대체자동기표(보광)_후불발생 삭제 ( Web Service 용 )
     * 
     * @param paramMap
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    public int deleteBSAROCCMulti( Map paramMap ) throws Exception {
        return super.commonDao.update("if_C010ServiceImpl.deleteBSAROCCMulti", paramMap);
    }
    
    /**
     * 매출대체자동기표(보광)_영업장별 매출집계 삭제 ( Web Service 용 )
     * 
     * @param paramMap
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    public int deleteBSSALESUMMulti( Map paramMap ) throws Exception {
        return super.commonDao.update("if_C010ServiceImpl.deleteBSSALESUMMulti", paramMap);
    }
    
    /**
     * 매출대체자동기표(보광)_지불수단별 매출집계 삭제 ( Web Service 용 )
     * 
     * @param paramMap
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    public int deleteBSPAYSUMMulti( Map paramMap ) throws Exception {
        return super.commonDao.update("if_C010ServiceImpl.deleteBSPAYSUMMulti", paramMap);
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
        return (Map)super.commonDao.select("if_C010ServiceImpl.selectErrorList", param);
    }

}
