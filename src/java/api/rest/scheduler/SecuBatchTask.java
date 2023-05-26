package api.rest.scheduler;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

import api.rest.service.CardAcctServiceImpl;
import api.rest.service.CommonServiceImpl;
import api.rest.service.HistAcctServiceImpl;
import api.rest.service.VendorAcctServiceImpl;
import api.rest.utils.RestUtils;

/**
 * <pre>
 * Batch Class
 * </pre>
 * 
 * @author 박종영
 */
@Component( "secuTask" )
public class SecuBatchTask {
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
    
    @SuppressWarnings( { "unchecked", "rawtypes" } )
    public void batchRun01() throws Exception {
        Calendar calendar = Calendar.getInstance();
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        logger.debug("[{}] batchRun01 실행 : {}", "ACCNT_MO", dateFormat.format(calendar.getTime()));
        
        RestUtils utils = new RestUtils();
        
        /*
         * Job ID 생성
         */
        String jobId = utils.makeExcelJobID();
        Map logParam = new HashMap();
        int inCnt = 0;
        
        try {
            logParam.put("BATCH_SEQ", jobId);
            logParam.put("BATCH_ID", "IF_0003");
            commonServiceImpl.insertLog(logParam);
            
            inCnt = histAcctServiceImpl.apiAccntSaveAll02(jobId);
            
            logParam.put("STATUS", "0");
            logParam.put("RESULT_MSG", "입출금 거래내역 계좌번호 " + inCnt + "건 암호화 성공");
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
    
    @SuppressWarnings( { "unchecked", "rawtypes" } )
    public void batchRun02() throws Exception {
        Calendar calendar = Calendar.getInstance();
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        logger.debug("[{}] batchRun02 실행 : {}", "VENDOR", dateFormat.format(calendar.getTime()));
        
        RestUtils utils = new RestUtils();
        
        /*
         * Job ID 생성
         */
        String jobId = utils.makeExcelJobID();
        Map logParam = new HashMap();
        int inCnt = 0;
        
        try {
            logParam.put("BATCH_SEQ", jobId);
            logParam.put("BATCH_ID", "IF_0004");
            commonServiceImpl.insertLog(logParam);
            
            inCnt = vendorAcctServiceImpl.saveVendorList02();
            
            logParam.put("STATUS", "0");
            logParam.put("RESULT_MSG", "경비관리(SAP) 개인정보 " + inCnt + "건 암호화 성공");
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
    
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public void batchRun03() throws Exception {
        Calendar calendar = Calendar.getInstance();
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        logger.debug("[{}] batchRun03 실행 : {}", "VENDOR_ACCT", dateFormat.format(calendar.getTime()));
        
        RestUtils utils = new RestUtils();
        
        /*
         * Job ID 생성
         */
        String jobId = utils.makeExcelJobID();
        Map logParam = new HashMap();
        int inCnt = 0;
        
        try {
            logParam.put("BATCH_SEQ", jobId);
            logParam.put("BATCH_ID", "IF_0005");
            commonServiceImpl.insertLog(logParam);
            
            inCnt = vendorAcctServiceImpl.saveVendorAcctList02();
            
            logParam.put("STATUS", "0");
            logParam.put("RESULT_MSG", "경비관리(SAP) 계좌번호 " + inCnt + "건 암호화 성공");
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
    
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public void batchRun04() throws Exception {
        Calendar calendar = Calendar.getInstance();
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        logger.debug("[{}] batchRun04 실행 : {}", "CARD_MASTER", dateFormat.format(calendar.getTime()));
        
        RestUtils utils = new RestUtils();
        
        /*
         * Job ID 생성
         */
        String jobId = null;
        Map logParam = new HashMap();
        int inCnt1 = 0;
        int inCnt2 = 0;
        int inCnt3 = 0;
        
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
            
            try {
                logParam.put("STATUS", "1");
                logParam.put("RESULT_MSG", "실패 [ " + utils.errorMsg(e.getMessage()) + "]");
                commonServiceImpl.updateLog(logParam);
            } catch (Exception ee) {
                ee.printStackTrace();
            }
            
            throw e;
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
            
            try {
                logParam.put("STATUS", "1");
                logParam.put("RESULT_MSG", "실패 [ " + utils.errorMsg(e.getMessage()) + "]");
                commonServiceImpl.updateLog(logParam);
            } catch (Exception ee) {
                ee.printStackTrace();
            }
            
            throw e;
        }
        
        //
        // 법인카드 청구내역
        //
        /*
         * try { jobId = utils.makeExcelJobID(); logParam.put("BATCH_SEQ", jobId); logParam.put("BATCH_ID", "IF_0008"); commonServiceImpl.insertLog(logParam); inCnt3 = cardAcctServiceImpl.saveInvList02(); logParam.put("STATUS", "0"); logParam.put("RESULT_MSG", "법인카드 청구내역 " + inCnt3 + "건 암호화 성공"); commonServiceImpl.updateLog(logParam); } catch (Exception e) { e.printStackTrace(); if (jobYn) { try { logParam.put("STATUS", "1"); logParam.put("RESULT_MSG", "실패 [ " + utils.errorMsg(e.getMessage()) + "]"); commonServiceImpl.updateLog(logParam); } catch (Exception ee) { ee.printStackTrace(); } } }
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
    
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public void batchRun07() throws Exception {
        Calendar calendar = Calendar.getInstance();
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        logger.debug("[{}] batchRun07 실행 : {}", "SMART_BILL", dateFormat.format(calendar.getTime()));
        
        RestUtils utils = new RestUtils();
        
        /*
         * Job ID 생성
         */
        String jobId = utils.makeExcelJobID();
        Map logParam = new HashMap();
        
        try {
            logParam.put("BATCH_SEQ", jobId);
            logParam.put("BATCH_ID", "IF_0010");
            commonServiceImpl.insertLog(logParam);
            
            cardAcctServiceImpl.saveSmartBill02();
            
            logParam.put("STATUS", "0");
            logParam.put("RESULT_MSG", "스마트빌의 매입 전자세금계산서 등록 성공");
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
