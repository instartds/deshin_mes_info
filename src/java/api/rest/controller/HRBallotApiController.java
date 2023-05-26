package api.rest.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import api.rest.service.CommonServiceImpl;
import api.rest.service.If_C001ServiceImpl;
import api.rest.service.If_C002ServiceImpl;
import api.rest.service.If_C005ServiceImpl;
import api.rest.service.If_s_hpa650t_jukrServiceImpl;
import api.rest.utils.RestUtils;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.utils.ConfigUtil;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;

/**
 * <pre>
 * 인사 자동기표 Web Service를 위한 API Controller
 * 1. 급상여자동기표 
 * 2. 퇴직급여 : 퇴직급여, 퇴직급여공제 
 * 3. 자동기표취소 
 * 4. 원천세
 * </pre>
 * 
 * @author 박종영
 */
@Controller
public class HRBallotApiController extends UniliteCommonController {
    
    private final Logger                 logger = LoggerFactory.getLogger(this.getClass());
    
    RestUtils                            utils  = new RestUtils();
    
    /**
     * Log 테이블 관리
     */
    @Resource( name = "commonServiceImpl" )
    private CommonServiceImpl       commonServiceImpl;
    
    /**
     * 인사자동기표취소 Service
     */
    @Resource( name = "if_s_hpa650t_jukrServiceImpl" )
    private If_s_hpa650t_jukrServiceImpl if_s_hpa650t_jukrServiceImpl;
    
    /**
     * 인사 급상여자동기표 IF Service
     */
    @Resource( name = "if_C001ServiceImpl" )
    private If_C001ServiceImpl           if_C001ServiceImpl;
    
    /**
     * 인사 퇴직금자동기표 IF Service
     */
    @Resource( name = "if_C002ServiceImpl" )
    private If_C002ServiceImpl           if_C002ServiceImpl;
    
    /**
     * 인사 원청세정보 IF Service
     */
    @Resource( name = "if_C005ServiceImpl" )
    private If_C005ServiceImpl           if_C005ServiceImpl;
    
    /**
     * <pre>
     * 1. 급상여자동기표
     * 2. 퇴직급여 : 퇴직급여, 퇴직급여공제
     * 3. 자동기표취소
     * 4. 원천세
     * </pre>
     * 
     * @param _req
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/api/saveHrInf", method = RequestMethod.POST )
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public ModelAndView saveHrInf( ExtHtttprequestParam _req, HttpServletRequest request ) throws Exception {
        logger.debug("logger 시작 ----------------------------");
        logger.debug("gubun : {}", _req.getP("gubun"));
        logger.debug("접속자 IP :: " + request.getRemoteAddr());
        logger.debug("----------------------------");
        
        boolean webServiceYn = ConfigUtil.getBooleanValue("common.dataOption.web-service", false);
        logger.debug("webServiceYn :: {}", webServiceYn);
        
        if (webServiceYn) {
            Map rtnMsg = new HashMap();
            
            if (_req.getP("gubun") != null && _req.getP("gubun").equals("1")) {
                return saveHrInf001(_req, request);      // 급상여자동기표
            } else if (_req.getP("gubun") != null && _req.getP("gubun").equals("2")) {
                return saveHrInf002(_req, request);      // 퇴직급여 : 퇴직급여, 퇴직급여공제
            } else if (_req.getP("gubun") != null && _req.getP("gubun").equals("3")) {
                return saveHrInf004(_req, request);      // 자동기표취소
            } else if (_req.getP("gubun") != null && _req.getP("gubun").equals("4")) {
                return saveHrInf003(_req, request);      // 원천세
            } else {
                rtnMsg.put("status", "1");
                rtnMsg.put("message", "구분코드 오류");
            }
            
            return ViewHelper.getJsonView(rtnMsg);
        } else {
            return ViewHelper.getJsonView(null);
        }

    }
    
    /**
     * <pre>
     * 인사 급상여자동기표 IF
     * IF_C0001
     * 
     * I/F연계 수당공제코드(S_HBS300T_JS)            - wages_data
     * I/F연계 월별수당공제금액_MASTER(S_HPA600T_JS) - pay_master
     * I/F연계 월별수당공제금액_DETAIL(S_HPA610T_JS) - pay_detail
     * </pre>
     * 
     * @param request
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public ModelAndView saveHrInf001( ExtHtttprequestParam _req, HttpServletRequest request ) throws Exception {
        
        Map rtnMsg = new HashMap();
        Map logMap = new HashMap();
        
        // Job ID 생성
        String jobId = utils.makeJobID();

        /*
         * Logging 시작 
         */
        logMap.put("BATCH_SEQ", jobId);
        logMap.put("BATCH_ID", "IF_C0001");
        logMap.put("CLIENT_IP", request.getRemoteAddr());
        commonServiceImpl.insertLog(logMap);
        
        try {
            List<Map<String, Object>> wagesDataList = (List<Map<String, Object>>)_req.getObject("wages_data");
            logger.debug("wagesDataList : {}", wagesDataList);
            
            if (wagesDataList == null || wagesDataList.size() == 0) {
                // 안들어 올수 있음. - 2016.11.22
                //return ViewHelper.getJsonView(utils.convErrorMessage("Error", "전송된 마스터 데이터가 없습니다."));
            }
            
            List<Map<String, Object>> masterDataList = (List<Map<String, Object>>)_req.getObject("pay_master");
            logger.debug("masterDataList : {}", masterDataList);
            
            if (masterDataList == null || masterDataList.size() == 0) {
                /*
                 * Logging 끝
                 */
                logMap.put("STATUS", "1");
                logMap.put("RESULT_MSG", "전송된 상세 데이터가 없습니다.[마스터]");
                commonServiceImpl.updateLog(logMap);
                
                return ViewHelper.getJsonView(utils.convErrorMessage("Error", "전송된 상세 데이터가 없습니다.[마스터]"));
            }
            
            List<Map<String, Object>> detailDataList = (List<Map<String, Object>>)_req.getObject("pay_detail");
            logger.debug("detailDataList : {}", detailDataList);
            
            if (detailDataList == null || detailDataList.size() == 0) {
                /*
                 * Logging 끝
                 */
                logMap.put("STATUS", "1");
                logMap.put("RESULT_MSG", "전송된 상세 데이터가 없습니다.[상세]");
                commonServiceImpl.updateLog(logMap);
                
                return ViewHelper.getJsonView(utils.convErrorMessage("Error", "전송된 상세 데이터가 없습니다.[상세]"));
            }
            
            try {
                
                /*
                 * Temp 테이블에 데이터를 Insert 한다.
                 */
                Map rtnMap = if_C001ServiceImpl.apiSaveAll(jobId, wagesDataList, masterDataList, detailDataList);
                logger.debug("결과 rtnMap :: {}", rtnMap);
                
                if (rtnMap.get("ERROR_DESC") != null && ( (String)rtnMap.get("ERROR_DESC") ).length() > 0) {
                    rtnMsg.put("status", "1");
                    rtnMsg.put("message", rtnMap.get("ERROR_DESC"));
                    
                    /*
                     * Logging 끝
                     */
                    logMap.put("STATUS", "1");
                    logMap.put("RESULT_MSG", rtnMap.get("ERROR_DESC"));
                    commonServiceImpl.updateLog(logMap);
                    
                    return ViewHelper.getJsonView(rtnMsg);
                }
                
                /*
                 * Temp 테이블에서 Main 테이블로 데이터를 Insert 한다. 오류 발생 시 Main 테이블은 Delete 한다.
                 */
                rtnMap = if_C001ServiceImpl.saveTempToMain(jobId);
                logger.debug("결과 rtnMap :: {}", rtnMap);
                
                if (rtnMap.get("ERROR_DESC") != null && ( (String)rtnMap.get("ERROR_DESC") ).length() > 0) {
                    rtnMsg.put("status", "1");
                    rtnMsg.put("message", rtnMap.get("ERROR_DESC"));
                    
                    /*
                     * Logging 끝
                     */
                    logMap.put("STATUS", "1");
                    logMap.put("RESULT_MSG", rtnMap.get("ERROR_DESC"));
                    commonServiceImpl.updateLog(logMap);
                    
                    return ViewHelper.getJsonView(rtnMsg);
                }
                
                rtnMap = if_C001ServiceImpl.callProc01(jobId, masterDataList);
                logger.info("보내는 결과 rtnMap :: {}", rtnMap);
                
                if (rtnMap.get("ERROR_DESC") != null && ( (String)rtnMap.get("ERROR_DESC") ).length() > 0) {
                    rtnMsg.put("status", "1");
                    rtnMsg.put("message", rtnMap.get("ERROR_DESC"));
                    
                    /*
                     * Logging 끝
                     */
                    logMap.put("STATUS", "1");
                    logMap.put("RESULT_MSG", rtnMap.get("ERROR_DESC"));
                    
                } else {
                    rtnMsg.put("status", "0");
                    rtnMsg.put("message", "");
                    rtnMsg.put("AC_DATE", rtnMap.get("AC_DATE"));
                    rtnMsg.put("SLIP_NUM", rtnMap.get("SLIP_NUM"));
                    
                    /*
                     * Logging 끝
                     */
                    logMap.put("STATUS", "0");
                    logMap.put("RESULT_MSG", "");
                }

                commonServiceImpl.updateLog(logMap);
                
            } catch (Exception e) {
                e.printStackTrace();
                rtnMsg = utils.convErrorMessage("Error", e.getMessage());
                
                /*
                 * Logging 끝
                 */
                logMap.put("STATUS", "1");
                logMap.put("RESULT_MSG", e.getMessage());
                commonServiceImpl.updateLog(logMap);
            }
            
            logger.debug("rtnMsg :: {}", rtnMsg);
            
            return ViewHelper.getJsonView(rtnMsg);
            
        } catch (ClassCastException cce) {
            rtnMsg.put("status", "1");
            rtnMsg.put("message", "전송된 데이터가 없거나, json 오류입니다.");
            
            /*
             * Logging 끝
             */
            logMap.put("STATUS", "1");
            logMap.put("RESULT_MSG", "전송된 데이터가 없거나, json 오류입니다.");
            commonServiceImpl.updateLog(logMap);
            
            return ViewHelper.getJsonView(rtnMsg);
        } catch (Exception e) {
            throw new Exception(e.getMessage());
        }
    }
    
    /**
     * <pre>
     * 인사 퇴직금자동기표
     * IF_C0002
     * 
     * 퇴직급여(S_HRT500T_JS)          : data
     * 월별수당공제금액(S_HRT510T_JS)  : data
     * </pre>
     * 
     * @param request
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public ModelAndView saveHrInf002( ExtHtttprequestParam _req, HttpServletRequest request ) throws Exception {
        
        Map rtnMsg = new HashMap();
        Map logMap = new HashMap();
        
        /*
         * Job ID 생성
         */
        String jobId = utils.makeExcelJobID();

        /*
         * Logging 시작 
         */
        logMap.put("BATCH_SEQ", jobId);
        logMap.put("BATCH_ID", "IF_C0002");
        logMap.put("CLIENT_IP", request.getRemoteAddr());
        commonServiceImpl.insertLog(logMap);
        
        try {
            List<Map<String, Object>> masterDataList = (List<Map<String, Object>>)_req.getObject("ret_master");
            logger.debug("masterDataList : {}", masterDataList);
            
            if (masterDataList == null || masterDataList.size() == 0) {
                /*
                 * Logging 끝
                 */
                logMap.put("STATUS", "1");
                logMap.put("RESULT_MSG", "전송된 데이터가 없습니다.[퇴직급여]");
                commonServiceImpl.updateLog(logMap);
                
                return ViewHelper.getJsonView(utils.convErrorMessage("Error", "전송된 데이터가 없습니다.[퇴직급여]"));
            }
            
            if (masterDataList.size() > 1) {
                /*
                 * Logging 끝
                 */
                logMap.put("STATUS", "1");
                logMap.put("RESULT_MSG", "1건 이상의 데이터는 처리할 수 없습니다.[퇴직급여]");
                commonServiceImpl.updateLog(logMap);
                
                return ViewHelper.getJsonView(utils.convErrorMessage("Error", "1건 이상의 데이터는 처리할 수 없습니다.[퇴직급여]"));
            }
            
            List<Map<String, Object>> detailDataList = (List<Map<String, Object>>)_req.getObject("ret_detail");
            logger.debug("detailDataList : {}", detailDataList);
/*
            if (detailDataList == null || detailDataList.size() == 0) {
                logMap.put("STATUS", "1");
                logMap.put("RESULT_MSG", "전송된 데이터가 없습니다.[퇴직급여공제]");
                commonServiceImpl.updateLog(logMap);
                
                return ViewHelper.getJsonView(utils.convErrorMessage("Error", "전송된 데이터가 없습니다.[퇴직급여공제]"));
            }
*/
            try {
                
                /*
                 * Temp 테이블에 데이터를 Insert 한다.
                 */
                Map rtnMap = if_C002ServiceImpl.apiSaveAll(jobId, masterDataList, detailDataList);
                logger.debug("결과 rtnMap :: {}", rtnMap);
                
                if (rtnMap.get("ERROR_DESC") != null && ( (String)rtnMap.get("ERROR_DESC") ).length() > 0) {
                    rtnMsg.put("status", "1");
                    rtnMsg.put("message", rtnMap.get("ERROR_DESC"));
                    
                    /*
                     * Logging 끝
                     */
                    logMap.put("STATUS", "1");
                    logMap.put("RESULT_MSG", rtnMap.get("ERROR_DESC"));
                    commonServiceImpl.updateLog(logMap);
                    
                    return ViewHelper.getJsonView(rtnMsg);
                }
                
                /*
                 * Temp 테이블에서 Main 테이블로 데이터를 Insert 한다. 오류 발생 시 Main 테이블은 Delete 한다.
                 */
                rtnMap = if_C002ServiceImpl.saveTempToMain(jobId);
                logger.debug("결과 rtnMap :: {}", rtnMap);
                
                if (rtnMap.get("ERROR_DESC") != null && ( (String)rtnMap.get("ERROR_DESC") ).length() > 0) {
                    rtnMsg.put("status", "1");
                    rtnMsg.put("message", rtnMap.get("ERROR_DESC"));
                    
                    /*
                     * Logging 끝
                     */
                    logMap.put("STATUS", "1");
                    logMap.put("RESULT_MSG", rtnMap.get("ERROR_DESC"));
                    commonServiceImpl.updateLog(logMap);
                    
                    return ViewHelper.getJsonView(rtnMsg);
                }
                
                rtnMap = if_C002ServiceImpl.callProc01(jobId, masterDataList);
                logger.info("보내는 결과 rtnMap :: {}", rtnMap);
                
                if (rtnMap.get("ERROR_DESC") != null && ( (String)rtnMap.get("ERROR_DESC") ).length() > 0) {
                    rtnMsg.put("status", "1");
                    rtnMsg.put("message", rtnMap.get("ERROR_DESC"));
                    
                    /*
                     * Logging 끝
                     */
                    logMap.put("STATUS", "1");
                    logMap.put("RESULT_MSG", rtnMap.get("ERROR_DESC"));

                } else {
                    rtnMsg.put("status", "0");
                    rtnMsg.put("message", "");
                    rtnMsg.put("AC_DATE", rtnMap.get("AC_DATE"));
                    rtnMsg.put("SLIP_NUM", rtnMap.get("SLIP_NUM"));
                    
                    /*
                     * Logging 끝
                     */
                    logMap.put("STATUS", "0");
                    logMap.put("RESULT_MSG", "");
                }


                commonServiceImpl.updateLog(logMap);
                
            } catch (Exception e) {
                e.printStackTrace();
                rtnMsg = utils.convErrorMessage("Error", e.getMessage());
                
                /*
                 * Logging 끝
                 */
                logMap.put("STATUS", "1");
                logMap.put("RESULT_MSG", e.getMessage());
                commonServiceImpl.updateLog(logMap);
            }
            
            logger.debug("rtnMsg :: {}", rtnMsg);
            
            return ViewHelper.getJsonView(rtnMsg);
            
        } catch (ClassCastException cce) {
            rtnMsg.put("status", "1");
            rtnMsg.put("message", "전송된 데이터가 없거나, json 오류입니다.");
            
            return ViewHelper.getJsonView(rtnMsg);
        } catch (Exception e) {
            throw new Exception(e.getMessage());
        }
    }
    
    /**
     * 원천세 : 원천세
     * 
     * @param _req
     * @param request
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public ModelAndView saveHrInf003( ExtHtttprequestParam _req, HttpServletRequest request ) throws Exception {
        
        Map rtnMsg = new HashMap();
        Map logMap = new HashMap();
        
        /*
         * Job ID 생성
         */
        String jobId = utils.makeExcelJobID();

        /*
         * Logging 시작 
         */
        logMap.put("BATCH_SEQ", jobId);
        logMap.put("BATCH_ID", "IF_C0005");
        logMap.put("CLIENT_IP", request.getRemoteAddr());
        commonServiceImpl.insertLog(logMap);
        
        try {
            List<Map<String, Object>> dataList = (List<Map<String, Object>>)_req.getObject("data");
            logger.debug("dataList : {}", dataList);
            
            if (dataList == null || dataList.size() == 0) {
                /*
                 * Logging 끝
                 */
                logMap.put("STATUS", "1");
                logMap.put("RESULT_MSG", "전송된 데이터가 없습니다.[원천세]");
                commonServiceImpl.updateLog(logMap);
                
                return ViewHelper.getJsonView(utils.convErrorMessage("Error", "전송된 데이터가 없습니다.[원천세]"));
            }
            
            List<Map<String, Object>> masterDataList = (List<Map<String, Object>>)_req.getObject("pay_master");
            logger.debug("masterDataList : {}", masterDataList);
            
            if (masterDataList == null || masterDataList.size() == 0) {
                /*
                 * Logging 끝
                 */
                logMap.put("STATUS", "1");
                logMap.put("RESULT_MSG", "전송된 데이터가 없습니다.[원천세 급상여 마스터]");
                commonServiceImpl.updateLog(logMap);
                
                return ViewHelper.getJsonView(utils.convErrorMessage("Error", "전송된 데이터가 없습니다.[원천세 급상여 마스터]"));
            }
            
            if (masterDataList.size() > 1) {
                /*
                 * Logging 끝
                 */
                logMap.put("STATUS", "1");
                logMap.put("RESULT_MSG", "1건 이상의 데이터는 처리할 수 없습니다.[원천세 급상여 마스터]");
                commonServiceImpl.updateLog(logMap);
                
                return ViewHelper.getJsonView(utils.convErrorMessage("Error", "1건 이상의 데이터는 처리할 수 없습니다.[원천세 급상여 마스터]"));
            }
            
            List<Map<String, Object>> detailDataList = (List<Map<String, Object>>)_req.getObject("pay_detail");
            logger.debug("detailDataList : {}", detailDataList);
            
            if (detailDataList == null || detailDataList.size() == 0) {
                /*
                 * Logging 끝
                 */
                logMap.put("STATUS", "1");
                logMap.put("RESULT_MSG", "전송된 데이터가 없습니다.[원천세 급상여 상세]");
                commonServiceImpl.updateLog(logMap);
                
                return ViewHelper.getJsonView(utils.convErrorMessage("Error", "전송된 데이터가 없습니다.[원천세 급상여 상세]"));
            }
            
            try {
                /*
                 * Temp 테이블에 데이터를 Insert 한다.
                 */
                Map rtnMap = if_C005ServiceImpl.apiSaveAll(jobId, dataList, masterDataList, detailDataList);
                logger.debug("결과 rtnMap :: {}", rtnMap);
                
                if (rtnMap.get("ERROR_DESC") != null && ( (String)rtnMap.get("ERROR_DESC") ).length() > 0) {
                    rtnMsg.put("status", "1");
                    rtnMsg.put("message", rtnMap.get("ERROR_DESC"));
                    
                    /*
                     * Logging 끝
                     */
                    logMap.put("STATUS", "1");
                    logMap.put("RESULT_MSG", rtnMap.get("ERROR_DESC"));
                    commonServiceImpl.updateLog(logMap);
                    
                    return ViewHelper.getJsonView(rtnMsg);
                }
                
                /*
                 * Temp 테이블에서 Main 테이블로 데이터를 Insert 한다. 오류 발생 시 Main 테이블은 Delete 한다.
                 */
                String msg = if_C005ServiceImpl.saveTempToMain(jobId);
                logger.debug("결과 msg :: {}", msg);
                
                if (msg.startsWith("1/")) {
                    rtnMsg.put("status", "1");
                    rtnMsg.put("message", msg);
                    /*
                     * Logging 끝
                     */
                    logMap.put("STATUS", "1");
                    logMap.put("RESULT_MSG", rtnMap.get("ERROR_DESC"));
                } else {
                    rtnMsg.put("status", "0");
                    rtnMsg.put("message", "");
                    
                    /*
                     * Logging 끝
                     */
                    logMap.put("STATUS", "0");
                    logMap.put("RESULT_MSG", "");
                }

                commonServiceImpl.updateLog(logMap);
                
            } catch (Exception e) {
                e.printStackTrace();
                rtnMsg = utils.convErrorMessage("Error", e.getMessage());
                
                /*
                 * Logging 끝
                 */
                logMap.put("STATUS", "1");
                logMap.put("RESULT_MSG", e.getMessage());
                commonServiceImpl.updateLog(logMap);
            }
            
            logger.debug("rtnMsg :: {}", rtnMsg);
            
            return ViewHelper.getJsonView(rtnMsg);
            
        } catch (ClassCastException cce) {
            rtnMsg.put("status", "1");
            rtnMsg.put("message", "전송된 데이터가 없거나, json 오류입니다.");
            
            /*
             * Logging 끝
             */
            logMap.put("STATUS", "1");
            logMap.put("RESULT_MSG", "전송된 데이터가 없거나, json 오류입니다.");
            commonServiceImpl.updateLog(logMap);
            
            return ViewHelper.getJsonView(rtnMsg);
        } catch (Exception e) {
            throw new Exception(e.getMessage());
        }
    }
    
    /**
     * 자동기표취소
     * 
     * @param _req
     * @param request
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public ModelAndView saveHrInf004( ExtHtttprequestParam _req, HttpServletRequest request ) throws Exception {
        Map rtnMsg = new HashMap();
        Map logMap = new HashMap();
        
        /*
         * Job ID 생성
         */
        String jobId = utils.makeExcelJobID();

        /*
         * Logging 시작 
         */
        logMap.put("BATCH_SEQ", jobId);
        logMap.put("BATCH_ID", "IF_C0004");
        logMap.put("CLIENT_IP", request.getRemoteAddr());
        commonServiceImpl.insertLog(logMap);
        
        List<Map<String, Object>> dataList = (List<Map<String, Object>>)_req.getObject("data");
        logger.debug("dataList : {}", dataList);
        
        if (dataList == null || dataList.size() == 0) {
            /*
             * Logging 끝
             */
            logMap.put("STATUS", "1");
            logMap.put("RESULT_MSG", "전송된 마스터 데이터가 없습니다.");
            commonServiceImpl.updateLog(logMap);
            
            return ViewHelper.getJsonView(utils.convErrorMessage("Error", "전송된 마스터 데이터가 없습니다."));
        }
        
        try {

            
            /*
             * Temp 테이블에 데이터를 Insert 한다.
             */
            String rtnValue = if_s_hpa650t_jukrServiceImpl.apiSaveAll(jobId, dataList);
            logger.debug("결과 rtnValue :: {}", rtnValue);
            
            if (!rtnValue.startsWith("0")) {
                rtnMsg.put("status", "1");
                rtnMsg.put("message", rtnValue);
                
                /*
                 * Logging 끝
                 */
                logMap.put("STATUS", "1");
                logMap.put("RESULT_MSG", rtnValue);
                commonServiceImpl.updateLog(logMap);
                
                return ViewHelper.getJsonView(rtnMsg);
            }
            
            /*
             * Temp 테이블에서 Main 테이블로 데이터를 Insert 한다. 오류 발생 시 Main 테이블은 Delete 한다.
             */
            rtnValue = if_s_hpa650t_jukrServiceImpl.saveTempToMain(jobId);
            logger.debug("결과 rtnValue :: {}", rtnValue);
            
            if (!rtnValue.startsWith("0")) {
                rtnMsg.put("status", "1");
                rtnMsg.put("message", rtnValue);
                
                /*
                 * Logging 끝
                 */
                logMap.put("STATUS", "1");
                logMap.put("RESULT_MSG", rtnValue);
                commonServiceImpl.updateLog(logMap);
                
                return ViewHelper.getJsonView(rtnMsg);
            }
            
            rtnValue = if_s_hpa650t_jukrServiceImpl.callProc01(jobId);
            logger.debug("결과 rtnValue :: {}", rtnValue);
            
            if (rtnValue.startsWith("0")) {
                rtnMsg.put("status", "0");
                rtnMsg.put("message", "");

                /*
                 * Logging 끝
                 */
                logMap.put("STATUS", "0");
                logMap.put("RESULT_MSG", "");
                
            } else {
                rtnMsg.put("status", "1");
                rtnMsg.put("message", rtnValue);
                

                /*
                 * Logging 끝
                 */
                logMap.put("STATUS", "1");
                logMap.put("RESULT_MSG", rtnValue);
            }

            commonServiceImpl.updateLog(logMap);
            
        } catch (Exception e) {
            e.printStackTrace();
            rtnMsg = utils.convErrorMessage("Error", e.getMessage());
            
            /*
             * Logging 끝
             */
            logMap.put("STATUS", "1");
            logMap.put("RESULT_MSG", e.getMessage());
            commonServiceImpl.updateLog(logMap);
        }
        
        logger.debug("rtnMsg :: {}", rtnMsg);
        
        return ViewHelper.getJsonView(rtnMsg);
    }
    
    /**
     * 급여연계 : 수당공제코드, 사원정보, 월별수당공제금액
     * 
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/api/getHrInf001", method = RequestMethod.POST )
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public ModelAndView getHrInf001( ExtHtttprequestParam _req, HttpServletRequest request ) throws Exception {
        
        List<Map<String, Object>> dataList = (List<Map<String, Object>>)_req.getObject("data");
        logger.debug("dataList : {}", dataList);
        
        if (dataList == null || dataList.size() == 0) {
            return ViewHelper.getJsonView(utils.convErrorMessage("Error", "전송된 마스터 데이터가 없습니다."));
        }
        
        //List list = bom100ukrService.selectList(dataList);
        
        Map map = new HashMap();
        map.put("status", "0");
        map.put("message", "정상처리되었습니다.");
        
        return ViewHelper.getJsonView(map);
    }
    
    /**
     * 퇴직급여 : 퇴직급여, 퇴직급여공제
     * 
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/api/getHrInf002", method = RequestMethod.POST )
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public ModelAndView getHrInf002( ExtHtttprequestParam _req, HttpServletRequest request ) throws Exception {
        
        List<Map<String, Object>> dataList = (List<Map<String, Object>>)_req.getObject("data");
        logger.debug("dataList : {}", dataList);
        
        if (dataList == null || dataList.size() == 0) {
            return ViewHelper.getJsonView(utils.convErrorMessage("Error", "전송된 데이터가 없습니다."));
        }
        
        //List list = bom100ukrService.selectList(dataList);
        Map map = new HashMap();
        map.put("status", "0");
        map.put("message", "정상처리되었습니다.");
        
        List list = new ArrayList();
        list.add(map);
        
        return ViewHelper.getJsonView(list);
    }
    
    /**
     * 원천세 : 원천세
     * 
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/api/getHrInf003", method = RequestMethod.POST )
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public ModelAndView getHrInf003( ExtHtttprequestParam _req, HttpServletRequest request ) throws Exception {
        
        List<Map<String, Object>> dataList = (List<Map<String, Object>>)_req.getObject("data");
        logger.debug("dataList : {}", dataList);
        
        if (dataList == null || dataList.size() == 0) {
            return ViewHelper.getJsonView(utils.convErrorMessage("Error", "전송된 데이터가 없습니다."));
        }
        
        //List list = if_C005ServiceImpl.selectList(dataList);
        Map map = new HashMap();
        map.put("status", "0");
        map.put("message", "정상처리되었습니다.");
        
        List list = new ArrayList();
        list.add(map);
        
        return ViewHelper.getJsonView(list);
    }
    
}
