package api.rest.scheduler;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

import api.rest.service.Abh300IFServiceImpl;
import api.rest.service.AppvConfServiceImpl;
import api.rest.service.CommonServiceImpl;
import api.rest.service.HistAcctServiceImpl;
import api.rest.service.If_agd360ukrServiceImpl;
import api.rest.service.If_agd365ukrServiceImpl;
import api.rest.service.If_bsa300t1_jsServiceImpl;
import api.rest.service.If_bsa300t2_jsServiceImpl;
import api.rest.utils.RestUtils;

/**
 * <pre>
 * Batch Class
 * </pre>
 * 
 * @author 박종영
 */
@Component("accntTask")
public class AccntBatchTask {
    private final Logger              logger = LoggerFactory.getLogger(this.getClass());
    
    /**
     * 공통
     */
    @Resource( name = "commonServiceImpl" )
    private CommonServiceImpl         commonServiceImpl;
    
    /**
     * 전표 자동기표 Service
     */
    @Resource( name = "if_agd360ukrServiceImpl" )
    private If_agd360ukrServiceImpl   if_agd360ukrServiceImpl;
    
    /**
     * 전표 자동기표취소 Service
     */
    @Resource( name = "if_agd365ukrServiceImpl" )
    private If_agd365ukrServiceImpl   if_agd365ukrServiceImpl;
    
    /**
     * 그룹웨어 -> MIS 사원정보 Service
     */
    @Resource( name = "if_bsa300t1_jsServiceImpl" )
    private If_bsa300t1_jsServiceImpl if_bsa300t1_jsServiceImpl;
    
    /**
     * 인사 사원정보 Service
     */
    @Resource( name = "if_bsa300t2_jsServiceImpl" )
    private If_bsa300t2_jsServiceImpl if_bsa300t2_jsServiceImpl;
    
    /**
     * 그룹웨어 결재정보 조회
     */
    @Resource( name = "appvConfServiceImpl" )
    private AppvConfServiceImpl       appvConfServiceImpl;
    
    /**
     * 입출금 거래내역
     */
    @Resource( name = "histAcctServiceImpl" )
    private HistAcctServiceImpl       histAcctServiceImpl;
    
    /**
     * 가수금확인 및 자동기표
     */
    @Resource( name = "abh300IFService" )
    private Abh300IFServiceImpl       abh300IFService;
    
    /**
     * <pre>
     * 일주일 이후의 Temp 테이블 데이터 삭제
     * </pre>
     */
    public void batchRun01() throws Exception {
        Calendar calendar = Calendar.getInstance();
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        logger.debug("[{}] batchRun01 실행 : {}", "ACCNT", dateFormat.format(calendar.getTime()));
        
        try {
            // 회계전표 Temp 테이블 
            if_agd360ukrServiceImpl.deleteTemp();
            // 회계전표 취소
            if_agd365ukrServiceImpl.deleteTemp();
            // 인사 사원정보
            if_bsa300t2_jsServiceImpl.deleteTemp();
            // 가수금확인 및 자동기표
            abh300IFService.deleteTemp();
        } catch (Exception e) {
            throw e;
        }
    }

    
    /**
     * <pre>
     * 그룹웨어 사용자 정보 인터페이스
     * 그룹웨어 -> MIS
     * </pre>
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public void batchRun03() throws Exception {
        Calendar calendar = Calendar.getInstance();
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        logger.debug("[{}] batchRun03 실행 : {}", "ACCNT", dateFormat.format(calendar.getTime()));
        
        RestUtils utils = new RestUtils();
        
        /*
         * Job ID 생성
         */
        String jobId = utils.makeExcelJobID();
        Map logParam = new HashMap();
        int inCnt = 0;
        
        try {
            logParam.put("BATCH_SEQ", jobId);
            logParam.put("BATCH_ID", "IF_0001");           // 사용자 정보 인터페이스
            commonServiceImpl.insertLog(logParam);
            
            inCnt = if_bsa300t1_jsServiceImpl.infGWtoMIS2();
            
            logParam.put("STATUS", "0");
            logParam.put("RESULT_MSG", "그룹웨어 사용자 " + inCnt + "건 인터페이스 성공");           // 사용자 정보 인터페이스
            commonServiceImpl.updateLog(logParam);
        } catch (Exception e) {
            
            try {
                logParam.put("STATUS", "1");
                logParam.put("RESULT_MSG", "실패 [ " + utils.errorMsg(e.getMessage()) + "]");
                commonServiceImpl.updateLog(logParam);
            } catch (Exception ee) {
                ee.printStackTrace();
            }
            
            throw e;
        }
    }
    
    /**
     * <pre>
     * 전자결재 인터페이스
     * 그룹웨어 -> MIS
     * 전자결재의 상태를 시간마다 체크해서 update 한다.
     * </pre>
     */   
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public void batchRun04() throws Exception {
        Calendar calendar = Calendar.getInstance();
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        logger.debug("[{}] batchRun04 실행 : {}", "ACCNT", dateFormat.format(calendar.getTime()));
        
        RestUtils utils = new RestUtils();
        
        /*
         * Job ID 생성
         */
        String jobId = utils.makeExcelJobID();
        Map logParam = new HashMap();
        
        try {
            logParam.put("BATCH_SEQ", jobId);
            logParam.put("BATCH_ID", "IF_0002");           // 전자결재
            commonServiceImpl.insertLog(logParam);
            
            appvConfServiceImpl.getApprovalStatus_WS02();
            
            logParam.put("STATUS", "0");
            logParam.put("RESULT_MSG", "SUCC");           // 사용자 정보 인터페이스
            commonServiceImpl.updateLog(logParam);
        } catch (Exception e) {
            try {
                logParam.put("STATUS", "1");
                logParam.put("RESULT_MSG", "실패 [ " + utils.errorMsg(e.getMessage()) + "]");
                commonServiceImpl.updateLog(logParam);
            } catch (Exception ee) {
                ee.printStackTrace();
            }
            
            throw e;
        }
    }
    
    /**
     * <pre>
     * 로그인 사용자 수정
     * - 인사정보의 임직원정보가 12시, 22시에 각각 Interface 됨.
     * - 그룹웨어 사용자는 2시에 Interface 됨.
     * - 인사정보 임직원정보와 그룹웨어 로그인 정보를 JOIN 해서 MIS 로그인 사용자를 생성함.
     *  
     * 그룹웨어 -> MIS
     * </pre>
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public void batchRun05() throws Exception {
        Calendar calendar = Calendar.getInstance();
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        logger.debug("[{}] batchRun05 실행 : {}", "ACCNT", dateFormat.format(calendar.getTime()));
        
        RestUtils utils = new RestUtils();
        
        /*
         * Job ID 생성
         */
        String jobId = utils.makeExcelJobID();
        Map logParam = new HashMap();
        
        try {
            logParam.put("BATCH_SEQ", jobId);
            logParam.put("BATCH_ID", "IF_0009");           // 사용자 정보 I/F  
            commonServiceImpl.insertLog(logParam);
            
            if_bsa300t2_jsServiceImpl.procBsa300tIf(jobId);
            
            logParam.put("STATUS", "0");
            logParam.put("RESULT_MSG", "SUCC");           // 사용자 정보 인터페이스
            commonServiceImpl.updateLog(logParam);
        } catch (Exception e) {
            
            try {
                logParam.put("STATUS", "1");
                logParam.put("RESULT_MSG", "실패 [ " + utils.errorMsg(e.getMessage()) + "]");
                commonServiceImpl.updateLog(logParam);
            } catch (Exception ee) {
                ee.printStackTrace();
            }
            
            throw e;
        }
    }
    
    /**
     * <pre>
     * 가수금정보 인터페이스 스케줄
     * </pre>
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public void batchRun06() throws Exception {
        Calendar calendar = Calendar.getInstance();
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        logger.debug("[{}] batchRun06 실행 : {}", "ACCNT", dateFormat.format(calendar.getTime()));
        
        RestUtils utils = new RestUtils();
        
        /*
         * Job ID 생성
         */
        String jobId = utils.makeExcelJobID();
        Map logParam = new HashMap();
        
        try {
            logParam.put("BATCH_SEQ", jobId);
            logParam.put("BATCH_ID", "IF_0011");           // 가수금확인 및 자동기표 I/F  
            commonServiceImpl.insertLog(logParam);
            
            abh300IFService.runInterface(jobId);
            
            logParam.put("STATUS", "0");
            logParam.put("RESULT_MSG", "SUCC");           // 가수금확인 및 자동기표
            commonServiceImpl.updateLog(logParam);
        } catch (Exception e) {
            
            try {
                logParam.put("STATUS", "1");
                logParam.put("RESULT_MSG", "실패 [ " + utils.errorMsg(e.getMessage()) + "]");
                commonServiceImpl.updateLog(logParam);
            } catch (Exception ee) {
                ee.printStackTrace();
            }
            
            throw e;
        }
    }
}
