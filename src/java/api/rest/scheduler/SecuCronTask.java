package api.rest.scheduler;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.annotation.Scheduled;

import api.rest.service.CardAcctServiceImpl;
import api.rest.service.CommonServiceImpl;
import api.rest.service.HistAcctServiceImpl;
import api.rest.service.VendorAcctServiceImpl;
import api.rest.utils.RestUtils;
import foren.framework.utils.ConfigUtil;

/**
 * <pre>
 * Scheduler Class
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
public class SecuCronTask {
    private final Logger          logger = LoggerFactory.getLogger(this.getClass());
    
    /**
     * 공통
     */
    @Resource( name = "commonServiceImpl" )
    private CommonServiceImpl     commonServiceImpl;
    
    /**
     * CMS연계
     */
    @Resource( name = "histAcctServiceImpl" )
    private HistAcctServiceImpl   histAcctServiceImpl;
    
    /**
     * 경비관리
     */
    @Resource( name = "vendorAcctServiceImpl" )
    private VendorAcctServiceImpl vendorAcctServiceImpl;
    
    /**
     * 법인카드
     */
    @Resource( name = "cardAcctServiceImpl" )
    private CardAcctServiceImpl   cardAcctServiceImpl;
    
    /**
     * <pre>
     * 입출금 거래내역 암호화 인터페이스
     * 매일 7시~23시 20분 실행
     * </pre>
     */
    @SuppressWarnings( { "unchecked", "rawtypes" } )
    @Scheduled( cron = "0 10,40 7-23 * * *" )
    public void scheduleRun01() {
        Calendar calendar = Calendar.getInstance();
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        logger.debug("[{}] scheduleRun01 실행 : {}", "ACCNT_MO", dateFormat.format(calendar.getTime()));
        
        boolean jobYn = ConfigUtil.getBooleanValue("common.cron.secu.schedule01", false);
        logger.debug("[{}] scheduleRun01 실행 : 여부 :: {}", "ACCNT", jobYn);
        
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
                logParam.put("BATCH_ID", "IF_0003");
                commonServiceImpl.insertLog(logParam);
                
                inCnt = histAcctServiceImpl.apiAccntSaveAll02(jobId);
                
                logParam.put("STATUS", "0");
                logParam.put("RESULT_MSG", "입출금 거래내역 계좌번호 " + inCnt + "건 암호화 성공");
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
     * 경비관리 - 거래처
     * 매일 12시 실행
     * </pre>
     */
    @SuppressWarnings( { "unchecked", "rawtypes" } )
    @Scheduled( cron = "0 0 12 * * *" )
    public void scheduleRun02() {
        Calendar calendar = Calendar.getInstance();
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        logger.debug("[{}] scheduleRun02 실행 : {}", "VENDOR", dateFormat.format(calendar.getTime()));
        
        boolean jobYn = ConfigUtil.getBooleanValue("common.cron.secu.schedule02", false);
        logger.debug("[{}] scheduleRun02 실행 : 여부 :: {}", "VENDOR", jobYn);
        
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
                logParam.put("BATCH_ID", "IF_0004");
                commonServiceImpl.insertLog(logParam);
                
                inCnt = vendorAcctServiceImpl.saveVendorList02();
                
                logParam.put("STATUS", "0");
                logParam.put("RESULT_MSG", "경비관리(SAP) 개인정보 " + inCnt + "건 암호화 성공");
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
     * 경비관리 - 계좌관리
     * 매일 12시 실행
     * </pre>
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @Scheduled( cron = "0 0 12 * * *" )
    public void scheduleRun03() {
        Calendar calendar = Calendar.getInstance();
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        logger.debug("[{}] scheduleRun03 실행 : {}", "VENDOR_ACCT", dateFormat.format(calendar.getTime()));
        
        boolean jobYn = ConfigUtil.getBooleanValue("common.cron.secu.schedule03", false);
        logger.debug("[{}] scheduleRun03 실행 : 여부 :: {}", "VENDOR_ACCT", jobYn);
        
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
                logParam.put("BATCH_ID", "IF_0005");
                commonServiceImpl.insertLog(logParam);
                
                inCnt = vendorAcctServiceImpl.saveVendorAcctList02();
                
                logParam.put("STATUS", "0");
                logParam.put("RESULT_MSG", "경비관리(SAP) 계좌번호 " + inCnt + "건 암호화 성공");
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
     * 법인카드 마스터, 승인(이용)내역, 청구내역
     * 매일 7,21시 30분 실행
     * </pre>
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @Scheduled( cron = "0 30 7,21 * * *" )
    public void scheduleRun04() {
        Calendar calendar = Calendar.getInstance();
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        logger.debug("[{}] scheduleRun04 실행 : {}", "CARD_MASTER", dateFormat.format(calendar.getTime()));
        
        boolean jobYn = ConfigUtil.getBooleanValue("common.cron.secu.schedule04", false);
        logger.debug("[{}] scheduleRun04 실행 : 여부 :: {}", "CARD_MASTER", jobYn);
        
        RestUtils utils = new RestUtils();
        
        /*
         * Job ID 생성
         */
        String jobId = null;
        Map logParam = new HashMap();
        int inCnt1 = 0;
        int inCnt2 = 0;
        int inCnt3 = 0;
        
        if (jobYn) {
            //
            // 법인카드 복호화 ( CARD_NO_ORG )
            // 법인카드MND 복호화 ( CARD_NO_ORG )
            //
            try {
                cardAcctServiceImpl.decCardNo();                           // 1. 법인카드 CARD_NO_ORG 복호화
                cardAcctServiceImpl.decCardMndNo();
            } catch (Exception e) {
                e.printStackTrace();
            }
            
            try {
                jobId = utils.makeExcelJobID();
                logParam.put("BATCH_SEQ", jobId);
                logParam.put("BATCH_ID", "IF_0006");
                commonServiceImpl.insertLog(logParam);
                
                //
                // 법인카드 암호화 ( CARD_NO )
                // JOB_YN = 'N' 인 데이터에 대해 법인카드 CARD_NO 암호화, JOB_YN = 'Y' 
                //
                inCnt1 = cardAcctServiceImpl.saveCardAll02();              // 2. 법인카드 CARD_NO 암호화
                cardAcctServiceImpl.saveABA500T();                         // 2. aba500t를 넣어주는 sp실행
                
                logParam.put("STATUS", "0");
                logParam.put("RESULT_MSG", "법인카드 마스터 카드번호 " + inCnt1 + "건 암호화 성공");
                commonServiceImpl.updateLog(logParam);
                
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
            
            //
            // 법인카드 승인(이용)내역
            //
            try {
                jobId = utils.makeExcelJobID();
                logParam.put("BATCH_SEQ", jobId);
                logParam.put("BATCH_ID", "IF_0007");
                commonServiceImpl.insertLog(logParam);
                
                inCnt2 = cardAcctServiceImpl.saveUseList02();
                
                logParam.put("STATUS", "0");
                logParam.put("RESULT_MSG", "법인카드 승인(이용)내역 " + inCnt2 + "건 암호화 성공");
                commonServiceImpl.updateLog(logParam);
                
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
            
            //
            // 법인카드 청구내역
            //
            /*
             * try { 
             * jobId = utils.makeExcelJobID(); 
             * logParam.put("BATCH_SEQ", jobId); 
             * logParam.put("BATCH_ID", "IF_0008"); 
             * commonServiceImpl.insertLog(logParam); 
             * inCnt3 = cardAcctServiceImpl.saveInvList02(); 
             * logParam.put("STATUS", "0"); 
             * logParam.put("RESULT_MSG", "법인카드 청구내역 " + inCnt3 + "건 암호화 성공"); 
             * commonServiceImpl.updateLog(logParam); 
             * } catch (Exception e) { 
             * e.printStackTrace(); 
             * if (jobYn) { 
             * try { 
             * logParam.put("STATUS", "1"); 
             * logParam.put("RESULT_MSG", "실패 [ " + utils.errorMsg(e.getMessage()) + "]"); 
             * commonServiceImpl.updateLog(logParam); 
             * } catch (Exception ee) { 
             * ee.printStackTrace(); 
             * } 
             * } 
             * }
             */
            //
            // 법인카드MND 암호화 ( CARD_NO_ORG )
            //
            try {
                cardAcctServiceImpl.encCardMndNo();
                cardAcctServiceImpl.encCardNo();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        
    }
        
    /**
     * <pre>
     * 스마트빌의 매입 전자세금계산서를 자동 입력
     * 매일 3시 실행
     * </pre>
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @Scheduled( cron = "0 10 6 * * *" )
    public void scheduleRun07() {
        Calendar calendar = Calendar.getInstance();
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        logger.debug("[{}] scheduleRun07 실행 : {}", "SMART_BILL", dateFormat.format(calendar.getTime()));
        
        boolean jobYn = ConfigUtil.getBooleanValue("common.cron.secu.schedule07", false);
        logger.debug("[{}] scheduleRun07 실행 : 여부 :: {}", "SMART_BILL", jobYn);
        
        RestUtils utils = new RestUtils();
        
        /*
         * Job ID 생성
         */
        String jobId = utils.makeExcelJobID();
        Map logParam = new HashMap();
        
        try {
            if (jobYn) {
                logParam.put("BATCH_SEQ", jobId);
                logParam.put("BATCH_ID", "IF_0010");
                commonServiceImpl.insertLog(logParam);
                
                cardAcctServiceImpl.saveSmartBill02();
                
                logParam.put("STATUS", "0");
                logParam.put("RESULT_MSG", "스마트빌의 매입 전자세금계산서 등록 성공");
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
    
}
