package api.rest.controller;

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

import api.rest.service.AcautoslipServiceImpl;
import api.rest.service.CommonServiceImpl;
import api.rest.service.If_C008ServiceImpl;
import api.rest.service.If_C010ServiceImpl;
import api.rest.service.S_bsarpaid_jukrServiceImpl;
import api.rest.service.S_insdept_jukrServiceImpl;
import api.rest.utils.RestUtils;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.ObjUtils;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;

/**
 * <pre>
 * 보광 Web Service를 위한 API Controller
 * </pre>
 * 
 * @author 박종영
 */
@Controller
public class BokwangApiController extends UniliteCommonController {
    
    private final Logger               logger = LoggerFactory.getLogger(this.getClass());
    
    RestUtils                          utils  = new RestUtils();
    /**
     * Log 테이블 관리
     */
    @Resource( name = "commonServiceImpl" )
    private CommonServiceImpl       commonServiceImpl;
    
    /**
     * 보광 매입대체 자동기표 Service
     */
    @Resource( name = "if_C008ServiceImpl" )
    private If_C008ServiceImpl         if_C008ServiceImpl;
    
    /**
     * 수불대체자동기표(보광)_현장재고 Service
     */
    @Resource( name = "s_insdept_jukrServiceImpl" )
    private S_insdept_jukrServiceImpl  s_insdept_jukrServiceImpl;
    
    /**
     * 보광 매출대체 자동기표 Service
     */
    @Resource( name = "if_C010ServiceImpl" )
    private If_C010ServiceImpl         if_C010ServiceImpl;
    
    /**
     * 후불대체자동기표(보광)_후불회수 Service
     */
    @Resource( name = "s_bsarpaid_jukrServiceImpl" )
    private S_bsarpaid_jukrServiceImpl s_bsarpaid_jukrServiceImpl;
    
    /**
     * AC Autoslip Service
     */
    @Resource( name = "acautoslipServiceImpl" )
    private AcautoslipServiceImpl      acautoslipServiceImpl;
    
    /**
     * <pre>
     * 1. 매입대체 자동기표 ( 보광용 ) 
     * 2. 수불대체 자동기표 ( 보광용 )
     * 3. 매출대체 자동기표 ( 보광용 )
     * 4. 후불대체 자동기표 ( 보광용 )
     * </pre>
     * 
     * @param _req
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/api/saveBogwangInf", method = RequestMethod.POST )
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public ModelAndView saveBogwangInf( ExtHtttprequestParam _req, HttpServletRequest request ) throws Exception {
        logger.debug("logger 시작 ----------------------------");
        logger.debug("gubun : {}", _req.getP("gubun"));
        logger.debug("접속자 IP :: " + request.getRemoteAddr());
        logger.debug("----------------------------");
        
        boolean webServiceYn = ConfigUtil.getBooleanValue("common.dataOption.web-service", false);
        logger.debug("webServiceYn :: {}", webServiceYn);
        
        if (webServiceYn) {
            
            Map rtnMsg = new HashMap();
            
            if (_req.getP("gubun") != null && _req.getP("gubun").equals("1")) {
                return saveBogwangInf001(_req, request);      // 매입대체 자동기표 ( 보광용 ) 
            } else if (_req.getP("gubun") != null && _req.getP("gubun").equals("2")) {
                return saveBogwangInf002(_req, request);      // 수불대체자동기표(보광)_현장재고
            } else if (_req.getP("gubun") != null && _req.getP("gubun").equals("3")) {
                return saveBogwangInf003(_req, request);      // 보광 매출대체 자동기표
            } else if (_req.getP("gubun") != null && _req.getP("gubun").equals("4")) {
                return saveBogwangInf004(_req, request);      // 후불대체자동기표(보광)_후불회수
            } else if (_req.getP("gubun") != null && _req.getP("gubun").equals("5")) {
                return saveBogwangInf005(_req, request);
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
     * 매입대체 자동기표
     * 
     * @param _req
     * @param request
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public ModelAndView saveBogwangInf001( ExtHtttprequestParam _req, HttpServletRequest request ) throws Exception {
        
        Map rtnMsg = new HashMap();
        Map logMap = new HashMap();
        
        //Job ID 생성
        String jobId = utils.makeJobID();
        
        /*
         * Logging 시작 
         */
        logMap.put("BATCH_SEQ", jobId);
        logMap.put("BATCH_ID", "IF_C0010");
        logMap.put("CLIENT_IP", request.getRemoteAddr());
        commonServiceImpl.insertLog(logMap);
        
        try {
            List<Map<String, Object>> masterDataList = (List<Map<String, Object>>)_req.getObject("header_data");
            logger.debug("masterDataList : {}", masterDataList);
            
            if (masterDataList == null || masterDataList.size() == 0) {
                /*
                 * Logging 끝
                 */
                logMap.put("STATUS", "1");
                logMap.put("RESULT_MSG", "전송된 데이터가 없습니다. [매입대체자동기표_입고]");
                commonServiceImpl.updateLog(logMap);
                
                return ViewHelper.getJsonView(utils.convErrorMessage("Error", "전송된 데이터가 없습니다. [매입대체자동기표_입고]"));
            }
            
            List<Map<String, Object>> detailDataList = (List<Map<String, Object>>)_req.getObject("detail_data");
            logger.debug("detailDataList : {}", detailDataList);
            
            if (detailDataList == null || detailDataList.size() == 0) {
                /*
                 * Logging 끝
                 */
                logMap.put("STATUS", "1");
                logMap.put("RESULT_MSG", "전송된 데이터가 없습니다. [매입대체자동기표_입고 상세]");
                commonServiceImpl.updateLog(logMap);
                
                return ViewHelper.getJsonView(utils.convErrorMessage("Error", "전송된 데이터가 없습니다. [매입대체자동기표_입고 상세]"));
            }
            
            try {
                
                //Temp insert
                Map rtnMap = if_C008ServiceImpl.apiSaveIF(masterDataList, detailDataList, jobId);
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
                rtnMap = if_C008ServiceImpl.saveTempToMain(jobId);
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
                
                //매입대체자동기표를 실행한다
                rtnMap = if_C008ServiceImpl.callPoc(jobId, masterDataList);
                rtnMsg.put("if_num", rtnMap.get("RESULT"));
                
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
                    if (ObjUtils.isNotEmpty(rtnMap.get("CNT")) && !"0".equals(rtnMap.get("CNT").toString())) {
                        rtnMsg.put("status", "1");
                        rtnMsg.put("message", "오류 데이터가 존재합니다.");
                        
                        /*
                         * Logging 끝
                         */
                        logMap.put("STATUS", "1");
                        logMap.put("RESULT_MSG", "오류 데이터가 존재합니다.");
                    } else {
                        rtnMsg.put("status", "0");
                        rtnMsg.put("message", "");
                        
                        /*
                         * Logging 끝
                         */
                        logMap.put("STATUS", "0");
                        logMap.put("RESULT_MSG", "");
                    }
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
            
            logger.debug("rtnMsg :: {}", rtnMsg);
            
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
     * 수불대체자동기표
     * 
     * @param _req
     * @param request
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public ModelAndView saveBogwangInf002( ExtHtttprequestParam _req, HttpServletRequest request ) throws Exception {
        
        Map rtnMsg = new HashMap();
        Map logMap = new HashMap();
        
        //Job ID 생성
        String jobId = utils.makeJobID();
        
        /*
         * Logging 시작 
         */
        logMap.put("BATCH_SEQ", jobId);
        logMap.put("BATCH_ID", "IF_C0010");
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
                logMap.put("RESULT_MSG", "전송된 데이터가 없습니다. [수불대체자동기표]");
                commonServiceImpl.updateLog(logMap);
                
                return ViewHelper.getJsonView(utils.convErrorMessage("Error", "전송된 데이터가 없습니다. [수불대체자동기표]"));
            }
            
            try {
                
                //Temp insert
                Map rtnMap = s_insdept_jukrServiceImpl.apiSaveIF(dataList, jobId);
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
                rtnMap = s_insdept_jukrServiceImpl.saveTempToMain(jobId);
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
                
                //수불대체자동기표를 실행한다
                rtnMap = s_insdept_jukrServiceImpl.callPoc(jobId, dataList);
                rtnMsg.put("if_num", rtnMap.get("RESULT"));
                
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
                    if (ObjUtils.isNotEmpty(rtnMap.get("CNT")) && !"0".equals(rtnMap.get("CNT").toString())) {
                        rtnMsg.put("status", "1");
                        rtnMsg.put("message", "오류 데이터가 존재합니다.");
                        
                        /*
                         * Logging 끝
                         */
                        logMap.put("STATUS", "1");
                        logMap.put("RESULT_MSG", "오류 데이터가 존재합니다.");
                    } else {
                        rtnMsg.put("status", "0");
                        rtnMsg.put("message", "");
                        
                        /*
                         * Logging 끝
                         */
                        logMap.put("STATUS", "0");
                        logMap.put("RESULT_MSG", "");
                    }
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
            
            logger.debug("rtnMsg :: {}", rtnMsg);
            
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
     * 매출대체자동기표
     * 
     * @param _req
     * @param request
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public ModelAndView saveBogwangInf003( ExtHtttprequestParam _req, HttpServletRequest request ) throws Exception {
        
        Map rtnMsg = new HashMap();
        Map logMap = new HashMap();
        
        //Job ID 생성
        String jobId = utils.makeJobID();
        
        /*
         * Logging 시작 
         */
        logMap.put("BATCH_SEQ", jobId);
        logMap.put("BATCH_ID", "IF_C0010");
        logMap.put("CLIENT_IP", request.getRemoteAddr());
        commonServiceImpl.insertLog(logMap);
        
        try {
            List<Map<String, Object>> BSAROCC = (List<Map<String, Object>>)_req.getObject("BSAROCC");
            logger.debug("BSAROCC : {}", BSAROCC);
            
            if (BSAROCC == null || BSAROCC.size() == 0) {
                /*
                 * Logging 끝
                 */
                logMap.put("STATUS", "1");
                logMap.put("RESULT_MSG", "전송된 데이터가 없습니다. [매출대체자동기표_입고]");
                commonServiceImpl.updateLog(logMap);
                
                return ViewHelper.getJsonView(utils.convErrorMessage("Error", "전송된 데이터가 없습니다. [매출대체자동기표_입고]"));
            }
            
            List<Map<String, Object>> BSSALESUM = (List<Map<String, Object>>)_req.getObject("BSSALESUM");
            logger.debug("BSSALESUM : {}", BSSALESUM);
            
            if (BSSALESUM == null || BSSALESUM.size() == 0) {
                /*
                 * Logging 끝
                 */
                logMap.put("STATUS", "1");
                logMap.put("RESULT_MSG", "전송된 데이터가 없습니다. [매출대체자동기표_입고 상세]");
                commonServiceImpl.updateLog(logMap);
                
                return ViewHelper.getJsonView(utils.convErrorMessage("Error", "전송된 데이터가 없습니다. [매출대체자동기표_입고 상세]"));
            }
            
            List<Map<String, Object>> BSPAYSUM = (List<Map<String, Object>>)_req.getObject("BSPAYSUM");
            logger.debug("BSPAYSUM : {}", BSPAYSUM);
            
            if (BSPAYSUM == null || BSPAYSUM.size() == 0) {
                /*
                 * Logging 끝
                 */
                logMap.put("STATUS", "1");
                logMap.put("RESULT_MSG", "전송된 데이터가 없습니다. [매출대체자동기표_입고 상세]");
                commonServiceImpl.updateLog(logMap);
                
                return ViewHelper.getJsonView(utils.convErrorMessage("Error", "전송된 데이터가 없습니다. [매출대체자동기표_입고 상세]"));
            }
            
            try {

                
                //Temp insert
                Map rtnMap = if_C010ServiceImpl.apiSaveIF(BSAROCC, BSSALESUM, BSPAYSUM, jobId);
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
                rtnMap = if_C010ServiceImpl.saveTempToMain(jobId);
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
                
                //수불대체자동기표를 실행한다
                rtnMap = if_C010ServiceImpl.callPoc(jobId, BSAROCC);
                rtnMsg.put("if_num", rtnMap.get("RESULT"));
                
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
                    if (ObjUtils.isNotEmpty(rtnMap.get("CNT")) && !"0".equals(rtnMap.get("CNT").toString())) {
                        rtnMsg.put("status", "1");
                        rtnMsg.put("message", "오류 데이터가 존재합니다.");
                        
                        /*
                         * Logging 끝
                         */
                        logMap.put("STATUS", "1");
                        logMap.put("RESULT_MSG", "오류 데이터가 존재합니다.");
                    } else {
                        rtnMsg.put("status", "0");
                        rtnMsg.put("message", "");
                        
                        /*
                         * Logging 끝
                         */
                        logMap.put("STATUS", "0");
                        logMap.put("RESULT_MSG", "");
                    }
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
            
            logger.debug("rtnMsg :: {}", rtnMsg);
            
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
     * 후풀대체자동기표
     * 
     * @param _req
     * @param request
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public ModelAndView saveBogwangInf004( ExtHtttprequestParam _req, HttpServletRequest request ) throws Exception {
        
        Map rtnMsg = new HashMap();
        Map logMap = new HashMap();
        
        //Job ID 생성
        String jobId = utils.makeJobID();
        
        /*
         * Logging 시작 
         */
        logMap.put("BATCH_SEQ", jobId);
        logMap.put("BATCH_ID", "IF_C0010");
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
                logMap.put("RESULT_MSG", "전송된 데이터가 없습니다. [후불대체전표]");
                commonServiceImpl.updateLog(logMap);
                
                return ViewHelper.getJsonView(utils.convErrorMessage("Error", "전송된 데이터가 없습니다. [후불대체전표]"));
            }
            
            try {
                
                //Temp insert
                Map rtnMap = s_bsarpaid_jukrServiceImpl.apiSaveIF(dataList, jobId);
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
                rtnMap = s_bsarpaid_jukrServiceImpl.saveTempToMain(jobId);
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
                
                //후불대체자동기표를 실행한다
                rtnMap = s_bsarpaid_jukrServiceImpl.callPoc(jobId, dataList);
                rtnMsg.put("if_num", rtnMap.get("RESULT"));
                
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
                    if (ObjUtils.isNotEmpty(rtnMap.get("CNT")) && !"0".equals(rtnMap.get("CNT").toString())) {
                        rtnMsg.put("status", "1");
                        rtnMsg.put("message", "오류 데이터가 존재합니다.");
                        
                        /*
                         * Logging 끝
                         */
                        logMap.put("STATUS", "1");
                        logMap.put("RESULT_MSG", "오류 데이터가 존재합니다.");
                    } else {
                        rtnMsg.put("status", "0");
                        rtnMsg.put("message", "");
                        
                        /*
                         * Logging 끝
                         */
                        logMap.put("STATUS", "0");
                        logMap.put("RESULT_MSG", "");
                    }
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
            
            logger.debug("rtnMsg :: {}", rtnMsg);
            
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
     * ACAUTOSLIP
     * 
     * @param _req
     * @param request
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public ModelAndView saveBogwangInf005( ExtHtttprequestParam _req, HttpServletRequest request ) throws Exception {
        
        Map rtnMsg = new HashMap();
        Map logMap = new HashMap();
        
        //Job ID 생성
        String jobId = utils.makeJobID();
        
        /*
         * Logging 시작 
         */
        logMap.put("BATCH_SEQ", jobId);
        logMap.put("BATCH_ID", "IF_C0010");
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
                logMap.put("RESULT_MSG", "전송된 데이터가 없습니다. [ACAUTOSLIP]");
                commonServiceImpl.updateLog(logMap);
                
                return ViewHelper.getJsonView(utils.convErrorMessage("Error", "전송된 데이터가 없습니다. [ACAUTOSLIP]"));
            }
            
            try {
                
                //Temp insert
                Map rtnMap = acautoslipServiceImpl.saveAutoSlipTemp(dataList, jobId);
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
                rtnMap = acautoslipServiceImpl.saveTempToMain(jobId);
                logger.debug("결과 rtnMap :: {}", rtnMap);
                
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
            
            logger.debug("rtnMsg :: {}", rtnMsg);
            
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
}
