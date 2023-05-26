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
 * 회계세금계산서정보 관리
 * 
 * @author 박종영
 */
@Service( "if_s_atx110t_jukrServiceImpl" )
public class If_s_atx110t_jukrServiceImpl extends TlabAbstractServiceImpl {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    private RestUtils    utils  = new RestUtils();
    
    /**
     * 회계세금계산서정보 관리 조회
     * 
     * @param paramMap
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "stdbase" )
    @SuppressWarnings( { "unchecked", "rawtypes" } )
    public List<Map<String, Object>> selectList( Map param ) throws Exception {
        return super.commonDao.list("if_s_atx110t_jukrServiceImpl.selectList", param);
    }
    
    /**************************************************************/
    /*********************** Web Service 용 ***********************/
    /**************************************************************/
    
    /**
     * <pre>
     * 회계세금계산서정보 관리 저장 ( Web Service 용 )
     * </pre>
     * 
     * @param paramList
     * @return
     * @throws Exception
     */
    @Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public String apiSaveAll( List<Map<String, Object>> paramList ) throws Exception {
        
        /*
         * Job ID 생성
         */
        String jobId = utils.makeExcelJobID();
        
        /*
         * Temp 폴더에 데이터를 Insert 한다.
         */
        Map param = saveIssuTemp(jobId, paramList);
        
        /*
         * Temp 테이블에서 회계세금계산서정보 으로 데이터를 저장 한다.
         */
        saveTempToIssu(jobId);
        
        /*
         * Error가 발생한 데이터 Key 조회
         */
        param.put("JOB_ID", jobId);
        
        /*
         * 세금계산서를 처리 한다.
         */
        accntAtx100TInterface(param);
        
        String errKeySeqno = (String)( (Map)super.commonDao.list("if_s_atx110t_jukrServiceImpl.selectErrorList", param).get(0) ).get("ERR_KEY_SEQNO");
        
        return errKeySeqno;
        
    }
    
    /**
     * <pre>
     * 회계세금계산서정보 관리 저장 ( Web Service 용 )
     * </pre>
     * 
     * @param paramList
     * @return
     * @throws Exception
     */
    @Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public String apiSaveAllOneTran( List<Map<String, Object>> paramList ) throws Exception {
        
        /*
         * Job ID 생성
         */
        String jobId = utils.makeExcelJobID();
        
        /*
         * Temp 폴더에 데이터를 Insert 한다.
         */
        Map param = saveIssuTemp(jobId, paramList);
        
        /*
         * Temp 테이블에서 회계세금계산서정보 으로 데이터를 저장 한다.
         */
        saveTempToIssu(jobId);
        
        /*
         * Error가 발생한 데이터 Key 조회
         */
        param.put("JOB_ID", jobId);
        
        /*
         * 세금계산서를 처리 한다.
         */
        accntAtx100TInterface(param);
        
        String errKeySeqno = (String)( (Map)super.commonDao.list("if_s_atx110t_jukrServiceImpl.selectErrorList", param).get(0) ).get("ERR_KEY_SEQNO");
        
        return errKeySeqno;
        
    }
    
    /**
     * Temp 폴더에 데이터를 Insert 한다. ( Web Service 용 )
     * 
     * @param jobId
     * @param paramMap
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    private Map saveIssuTemp( String jobId, List<Map<String, Object>> paramList ) throws Exception {
        Map rtnMap = new HashMap();
        String keySeqNo = "";
        String IF_SEQ = "";
        String COMP_CODE = "";
        String IF_DATE = "";
        String IF_TIME = "";
        String INSERT_DB_USER = "";
        Map rMap = null;
        
        for (Map param : paramList) {
            if (param.get("IF_SEQ") instanceof Double) {
                IF_SEQ = ( (Double)param.get("IF_SEQ") ).toString();
            } else {
                IF_SEQ = (String)param.get("IF_SEQ");
            }
            
            rMap = (Map)super.commonDao.queryForObject("commonServiceImpl.getRefCode", param);
            logger.info("rMap :: {}", rMap);
            if( rMap != null ) {
                param.put("COMP_CODE", rMap.get("REF_CODE1"));
            }
            logger.info("param :: {}", param);
            
            keySeqNo = (String)param.get("IF_NUM") + "|" + IF_SEQ;
            COMP_CODE = (String)param.get("COMP_CODE");
            INSERT_DB_USER = (String)param.get("INSERT_DB_USER");
            param.put("JOB_ID", jobId);
            param.put("IF_DATE", IF_DATE = jobId.substring(0, 8));
            param.put("IF_TIME", IF_TIME = jobId.substring(8, jobId.length()));
            param.put("KEY_SEQNO", keySeqNo);
            param.put("GUBUN", "2");            // 현재는 부가세신고용 '2' 밖에 없음. ( 1: 회계의 세금계산서 )
            
            super.commonDao.insert("if_s_atx110t_jukrServiceImpl.insertTempMulti", param);
        }
        
        rtnMap.put("COMP_CODE", COMP_CODE);
        rtnMap.put("IF_DATE", IF_DATE);
        rtnMap.put("IF_TIME", IF_TIME);
        rtnMap.put("INSERT_DB_USER", INSERT_DB_USER);
        
        return rtnMap;
    }
    
    /**
     * 회계세금계산서 및 부가세신고용정보 ( Web Service 용 )
     * 
     * @param paramList
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public Map apiSaveTemp( Map param, List<Map<String, Object>> paramList ) throws Exception {
        Map rtnMap = null;
        
        String jobId = (String)param.get("JOB_ID");
        String gubun = (String)param.get("GUBUN");
        
        try {
            /*
             * Temp 폴더에 데이터를 Insert 한다.
             */
            rtnMap = saveIssuTempPB(jobId, gubun, paramList);
        } catch (Exception e) {
            rtnMap = new HashMap();
            rtnMap.put("ERR_CODE", "1");
            rtnMap.put("ERR_MSG", utils.errParse(e.getMessage()));
            logger.error("Detail Error map :: {}", rtnMap);
        }
        
        return rtnMap;
    }
    
    /**
     * 회계세금계산서 및 부가세신고용정보 ( Web Service 용 )
     * 
     * @param paramList
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public String apiSaveAllPB( Map param, List<Map<String, Object>> paramList ) throws Exception {
        
        String jobId = (String)param.get("JOB_ID");
        String errKeySeqno = null;
        
        try {

            /*
             * Temp 테이블에서 회계세금계산서정보 으로 데이터를 저장 한다.
             */
            saveTempToIssu(jobId);
            
            /*
             * Error가 발생한 데이터 Key 조회
             */
            param.put("JOB_ID", jobId);
            
            errKeySeqno = (String)( (Map)super.commonDao.list("if_s_atx110t_jukrServiceImpl.selectErrorListPB", param).get(0) ).get("ERR_KEY_SEQNO");
            logger.info("파워빌더는 오류이면 전체 Rollback 해야 함...... {}", errKeySeqno);
            if (errKeySeqno.startsWith("0/") != true) {
                logger.info("파워빌더는 오류이면 전체 Rollback 해야 함...... {}", errKeySeqno);
                super.commonDao.update("if_s_atx110t_jukrServiceImpl.deleteMulti", param);
            } else {
                /*
                 * 세금계산서를 처리 한다.
                 */
                accntAtx100TInterface(param);
                List list = super.commonDao.list("if_agd360ukrServiceImpl.selectAGD361T", param);
                logger.info("결과 :: {}", list);
            }
        } catch (Exception e) {
            e.printStackTrace();
            
        }
        
        return errKeySeqno;
        
    }
    
    /**
     * <pre>
     * 파워빌더용
     * Temp 폴더에 데이터를 Insert 한다. ( Web Service 용 )
     * </pre>
     * 
     * @param jobId
     * @param paramMap
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    private Map saveIssuTempPB( String jobId, String gubun, List<Map<String, Object>> paramList ) throws Exception {
        Map rtnMap = new HashMap();
        String keySeqNo = "";
        String COMP_CODE = "";
        String IF_DATE = "";
        String IF_TIME = "";
        String INSERT_DB_USER = "";
        Map rMap = null;
        
        for (Map param : paramList) {
            
            rMap = (Map)super.commonDao.queryForObject("commonServiceImpl.getRefCode", param);
            logger.info("rMap :: {}", rMap);
            if( rMap != null ) {
                param.put("COMP_CODE", rMap.get("REF_CODE1"));
            }
            logger.info("param :: {}", param);
            
            keySeqNo = (String)param.get("IF_NUM");
            COMP_CODE = (String)param.get("COMP_CODE");
            INSERT_DB_USER = (String)param.get("INSERT_DB_USER");
            param.put("JOB_ID", jobId);
            param.put("IF_DATE", IF_DATE = jobId.substring(0, 8));
            param.put("IF_TIME", IF_TIME = jobId.substring(8, jobId.length()));
            param.put("KEY_SEQNO", keySeqNo);
            param.put("GUBUN", gubun);
            
            super.commonDao.insert("if_s_atx110t_jukrServiceImpl.insertTempMulti", param);
        }
        
        rtnMap.put("JOB_ID", jobId);
        rtnMap.put("GUBUN", gubun);
        rtnMap.put("COMP_CODE", COMP_CODE);
        rtnMap.put("IF_DATE", IF_DATE);
        rtnMap.put("IF_TIME", IF_TIME);
        rtnMap.put("INSERT_DB_USER", INSERT_DB_USER);
        
        return rtnMap;
    }
    
    /**
     * 세금계산서 처리 한다.
     * 
     * @param jobId
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    private void accntAtx100TInterface( Map param ) throws Exception {
        try {
            super.commonDao.list("if_s_atx110t_jukrServiceImpl.USP_JOINS_ACCNT_S_ATX110T_JS", param);
        } catch (Exception ex) {
            logger.error(ex.getMessage());
        }
    }
    
    /**
     * Temp 테이블에서 전자세금계산서_발행원장 으로 데이터를 저장 한다. ( Web Service 용 )
     * 
     * @param jobId
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    private void saveTempToIssu( String jobId ) throws Exception {
        Map param = new HashMap();
        param.put("JOB_ID", jobId);
        
        try {
            super.commonDao.delete("if_s_atx110t_jukrServiceImpl.USP_ACCNT_ATX110T_JS", param);
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
    public void deleteTempIssu() throws Exception {
        Map param = new HashMap();
        
        try {
            super.commonDao.delete("if_s_atx110t_jukrServiceImpl.deleteTemp", param);
        } catch (Exception ex) {
            logger.error(ex.getMessage());
        }
    }
    
    /**
     * 회계세금계산서정보 관리 입력 ( Web Service 용 )
     * 
     * @param paramMap
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    public int insertMulti( Map paramMap ) throws Exception {
        return super.commonDao.insert("if_s_atx110t_jukrServiceImpl.insertMulti", paramMap);
    }
    
    /**
     * 회계세금계산서정보 관리 수정 ( Web Service 용 )
     * 
     * @param paramMap
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    public int uptStatusAtx110_1( Map paramMap ) throws Exception {
        return super.commonDao.update("if_s_atx110t_jukrServiceImpl.uptStatusAtx110", paramMap);
    }
    
    /**
     * 메일재전송 관리 수정 ( Web Service 용 )
     * 
     * @param paramMap
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    public int uptStatusAtx110_2( Map paramMap ) throws Exception {
        return super.commonDao.update("if_s_atx110t_jukrServiceImpl.uptMailStatus", paramMap);
    }
    
    /**
     * 회계세금계산서정보 관리 수정 ( Web Service 용 )
     * 
     * @param paramMap
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    public int updateMulti( Map paramMap ) throws Exception {
        return super.commonDao.update("if_s_atx110t_jukrServiceImpl.updateMulti", paramMap);
    }
    
    /**
     * 회계세금계산서정보 관리 삭제 ( Web Service 용 )
     * 
     * @param paramMap
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    public int deleteMulti( Map paramMap ) throws Exception {
        return super.commonDao.update("if_s_atx110t_jukrServiceImpl.deleteMulti", paramMap);
    }
    
}
