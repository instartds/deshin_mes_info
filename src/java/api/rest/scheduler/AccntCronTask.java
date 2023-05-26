package api.rest.scheduler;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.annotation.Scheduled;

import api.rest.service.Abh300IFServiceImpl;
import api.rest.service.AppvConfServiceImpl;
import api.rest.service.CommonServiceImpl;
import api.rest.service.HistAcctServiceImpl;
import api.rest.service.If_agd360ukrServiceImpl;
import api.rest.service.If_agd365ukrServiceImpl;
import api.rest.service.If_bsa300t1_jsServiceImpl;
import api.rest.service.If_bsa300t2_jsServiceImpl;
import api.rest.utils.RestUtils;
import foren.framework.utils.ConfigUtil;

/**
 * <pre>
 * Scheduler Class
 * 
 * 
 * 
 * 초 0-59 , - * / 
 * 분 0-59 , - * / 
 * 시 0-23 , - * / 
 * 일 1-31 , - * ? / L W
 * 월 1-12 or JAN-DEC , - * / 
 * 요일 1-7 or SUN-SAT , - * ? / L # 
 * 년(옵션) 1970-2099 , - * /
 * * : 모든 값
 * ? : 특정 값 없음
 * - : 범위 지정에 사용
 * , : 여러 값 지정 구분에 사용
 * / : 초기값과 증가치 설정에 사용
 * L : 지정할 수 있는 범위의 마지막 값
 * W : 월~금요일 또는 가장 가까운 월/금요일
 * # : 몇 번째 무슨 요일 2#1 => 첫 번째 월요일
 *  
 * 예제) Expression Meaning 
 * 초 분 시 일 월 주(년)
 *  "0 0 12 * * ?" : 아무 요일, 매월, 매일 12:00:00
 *  "0 15 10 ? * *" : 모든 요일, 매월, 아무 날이나 10:15:00 
 *  "0 15 10 * * ?" : 아무 요일, 매월, 매일 10:15:00 
 *  "0 15 10 * * ? *" : 모든 연도, 아무 요일, 매월, 매일 10:15 
 *  "0 15 10 * * ? : 2005" 2005년 아무 요일이나 매월, 매일 10:15 
 *  "0 * 14 * * ?" : 아무 요일, 매월, 매일, 14시 매분 0초 
 *  "0 0/5 14 * * ?" : 아무 요일, 매월, 매일, 14시 매 5분마다 0초 
 *  "0 0/5 14,18 * * ?" : 아무 요일, 매월, 매일, 14시, 18시 매 5분마다 0초 
 *  "0 0-5 14 * * ?" : 아무 요일, 매월, 매일, 14:00 부터 매 14:05까지 매 분 0초 
 *  "0 10,44 14 ? 3 WED" : 3월의 매 주 수요일, 아무 날짜나 14:10:00, 14:44:00 
 *  "0 15 10 ? * MON-FRI" : 월~금, 매월, 아무 날이나 10:15:00 
 *  "0 15 10 15 * ?" : 아무 요일, 매월 15일 10:15:00 
 *  "0 15 10 L * ?" : 아무 요일, 매월 마지막 날 10:15:00 
 *  "0 15 10 ? * 6L" : 매월 마지막 금요일 아무 날이나 10:15:00 
 *  "0 15 10 ? * 6L 2002-2005" : 2002년부터 2005년까지 매월 마지막 금요일 아무 날이나 10:15:00 
 *  "0 15 10 ? * 6#3" : 매월 3번째 금요일 아무 날이나 10:15:00
 *  
 * ※셈플
 * 매일 5초 간격                                                cron = "0/5 * * * * *"
 * 매일 1분 간격                                                cron = "0 0/1 * * * *"
 * 매일 12시에 실행                                             cron = "0 0 12 * * *"
 * 매일 14시, 18시에 시작해서 5분 간격으로 실행                 cron = "0 0/5 14,18 * * *"
 * 매일 14시에 0분, 1분, 2분, 3분, 4분, 5분에 실행              cron = "0 0-5 14 * * *"
 * </pre>
 * 
 * @author 박종영
 */
public class AccntCronTask {
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
     * 매일 6시에 실행
     * </pre>
     */
    @Scheduled( cron = "0 0 6 * * *" )
    public void scheduleRun01() {
        Calendar calendar = Calendar.getInstance();
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        logger.debug("[{}] scheduleRun01 실행 : {}", "ACCNT", dateFormat.format(calendar.getTime()));
        
        boolean jobYn = ConfigUtil.getBooleanValue("common.cron.accnt.schedule01", false);
        logger.debug("[{}] scheduleRun01 실행 : 여부 :: {}", "ACCNT", jobYn);
        
        try {
            if (jobYn) {
                // 회계전표 Temp 테이블 
                if_agd360ukrServiceImpl.deleteTemp();
                // 회계전표 취소
                if_agd365ukrServiceImpl.deleteTemp();
                // 인사 사원정보
                if_bsa300t2_jsServiceImpl.deleteTemp();
                // 가수금확인 및 자동기표
                abh300IFService.deleteTemp();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    /**
     * 매일 10시, 11시에 시작해서 10분 간격으로 실행
     */
    @Scheduled( cron = "0 0 12 * * *" )
    public void scheduleRun02() {
        Calendar calendar = Calendar.getInstance();
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        logger.debug("[{}] scheduleRun02 실행 : {}", "ACCNT", dateFormat.format(calendar.getTime()));
        
        boolean jobYn = ConfigUtil.getBooleanValue("common.cron.accnt.schedule02", false);
        logger.debug("[{}] scheduleRun02 실행 : 여부 :: {}", "ACCNT", jobYn);
        
        try {
            if (jobYn) {
                //if_agd360ukrServiceImpl.deleteTemp();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    /**
     * <pre>
     * 그룹웨어 사용자 정보 인터페이스
     * 그룹웨어 -> MIS
     * 매일 새벽 1시 30분 실행 ( WAS 2에서만 실행 )
     * </pre>
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @Scheduled( cron = "0 30 1 * * *" )
    public void scheduleRun03() {
        Calendar calendar = Calendar.getInstance();
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        logger.debug("[{}] scheduleRun03 실행 : {}", "ACCNT", dateFormat.format(calendar.getTime()));
        
        boolean jobYn = ConfigUtil.getBooleanValue("common.cron.accnt.schedule03", false);
        logger.debug("[{}] scheduleRun03 실행 : 여부 :: {}", "ACCNT", jobYn);
        
        RestUtils utils = new RestUtils();
        
        /*
         * Job ID 생성
         */
        String jobId = utils.makeExcelJobID();
        Map logParam = new HashMap();
        int inCnt = 0;
        
        try {
            if (jobYn) {
                logParam.put("BATCH_SEQ", jobId);
                logParam.put("BATCH_ID", "IF_0001");           // 사용자 정보 인터페이스
                commonServiceImpl.insertLog(logParam);
                
                inCnt = if_bsa300t1_jsServiceImpl.infGWtoMIS2();
                
                logParam.put("STATUS", "0");
                logParam.put("RESULT_MSG", "그룹웨어 사용자 " + inCnt + "건 인터페이스 성공");           // 사용자 정보 인터페이스
                commonServiceImpl.updateLog(logParam);
            }
        } catch (Exception e) {
            e.printStackTrace();
            
            if (jobYn) {
                try {
                    logParam.put("STATUS", "1");
                    logParam.put("RESULT_MSG", "실패 [ " + utils.errorMsg(e.getMessage()) + "]");
                    commonServiceImpl.updateLog(logParam);
                } catch (Exception ee) {
                    ee.printStackTrace();
                }
            }
        }
    }
        
    /**
     * <pre>
     * 전자결재 인터페이스
     * 그룹웨어 -> MIS
     * 전자결재의 상태를 시간마다 체크해서 update 한다.
     * 
     * 0 0 0-23 * * * : 매 시간 마다. ( WAS 2에서만 실행 )
     * </pre>
     */
    @SuppressWarnings( { "unchecked", "rawtypes" } )
    @Scheduled( cron = "0 0 0-23 * * *" )
    public void scheduleRun04() {
        Calendar calendar = Calendar.getInstance();
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        logger.debug("[{}] scheduleRun04 실행 : {}", "ACCNT", dateFormat.format(calendar.getTime()));
        
        boolean jobYn = ConfigUtil.getBooleanValue("common.cron.accnt.schedule04", false);
        logger.debug("[{}] scheduleRun04 실행 : 여부 :: {}", "ACCNT", jobYn);
        
        RestUtils utils = new RestUtils();
        
        /*
         * Job ID 생성
         */
        String jobId = utils.makeExcelJobID();
        Map logParam = new HashMap();
        
        try {
            if (jobYn) {
                logParam.put("BATCH_SEQ", jobId);
                logParam.put("BATCH_ID", "IF_0002");           // 전자결재
                commonServiceImpl.insertLog(logParam);
                
                appvConfServiceImpl.getApprovalStatus_WS02();
                
                logParam.put("STATUS", "0");
                logParam.put("RESULT_MSG", "SUCC");           // 사용자 정보 인터페이스
                commonServiceImpl.updateLog(logParam);
            }
        } catch (Exception e) {
            e.printStackTrace();
            
            if (jobYn) {
                try {
                    logParam.put("STATUS", "1");
                    logParam.put("RESULT_MSG", "실패 [ " + utils.errorMsg(e.getMessage()) + "]");
                    commonServiceImpl.updateLog(logParam);
                } catch (Exception ee) {
                    ee.printStackTrace();
                }
            }
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
     * 0 30 2 * * * : 매일 2시 30분 ( WAS 2에서만 실행 )
     * </pre>
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @Scheduled( cron = "0 30 2 * * *" )
    public void scheduleRun05() {
        Calendar calendar = Calendar.getInstance();
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        logger.debug("[{}] scheduleRun05 실행 : {}", "ACCNT", dateFormat.format(calendar.getTime()));
        
        boolean jobYn = ConfigUtil.getBooleanValue("common.cron.accnt.schedule05", false);
        logger.debug("[{}] scheduleRun05 실행 : 여부 :: {}", "ACCNT", jobYn);
        
        RestUtils utils = new RestUtils();
        
        /*
         * Job ID 생성
         */
        String jobId = utils.makeExcelJobID();
        Map logParam = new HashMap();
        
        try {
            if (jobYn) {
                logParam.put("BATCH_SEQ", jobId);
                logParam.put("BATCH_ID", "IF_0009");           // 사용자 정보 I/F  
                commonServiceImpl.insertLog(logParam);
                
                if_bsa300t2_jsServiceImpl.procBsa300tIf(jobId);
                
                logParam.put("STATUS", "0");
                logParam.put("RESULT_MSG", "SUCC");           // 사용자 정보 인터페이스
                commonServiceImpl.updateLog(logParam);
            }
        } catch (Exception e) {
            e.printStackTrace();
            
            if (jobYn) {
                try {
                    logParam.put("STATUS", "1");
                    logParam.put("RESULT_MSG", "실패 [ " + utils.errorMsg(e.getMessage()) + "]");
                    commonServiceImpl.updateLog(logParam);
                } catch (Exception ee) {
                    ee.printStackTrace();
                }
            }
        }
    }
    
    /**
     * <pre>
     * 가수금정보 인터페이스 스케줄
     *  
     * 0 10 8-21 * * * : 매일 2시 30분 ( WAS 2에서만 실행 )
     * </pre>
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @Scheduled( cron = "0 10 8-21 * * *" )
    public void scheduleRun06() {
        Calendar calendar = Calendar.getInstance();
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        logger.debug("[{}] scheduleRun06 실행 : {}", "ACCNT", dateFormat.format(calendar.getTime()));
        
        boolean jobYn = ConfigUtil.getBooleanValue("common.cron.accnt.schedule06", false);
        logger.debug("[{}] scheduleRun06 실행 : 여부 :: {}", "ACCNT", jobYn);
        
        RestUtils utils = new RestUtils();
        
        /*
         * Job ID 생성
         */
        String jobId = utils.makeExcelJobID();
        Map logParam = new HashMap();
        
        try {
            if (jobYn) {
/*
                logParam.put("BATCH_SEQ", jobId);
                logParam.put("BATCH_ID", "IF_0011");           // 가수금확인 및 자동기표 I/F  
                commonServiceImpl.insertLog(logParam);
                
                abh300IFService.runInterface(jobId);
                
                logParam.put("STATUS", "0");
                logParam.put("RESULT_MSG", "SUCC");           // 가수금확인 및 자동기표
                commonServiceImpl.updateLog(logParam);
*/
            }
        } catch (Exception e) {
            e.printStackTrace();
            
            if (jobYn) {
                try {
                    logParam.put("STATUS", "1");
                    logParam.put("RESULT_MSG", "실패 [ " + utils.errorMsg(e.getMessage()) + "]");
                    commonServiceImpl.updateLog(logParam);
                } catch (Exception ee) {
                    ee.printStackTrace();
                }
            }
        }
    }
    
}
