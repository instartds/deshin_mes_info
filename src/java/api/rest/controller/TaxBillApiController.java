package api.rest.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONArray;
import net.sf.json.JSONException;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import api.rest.service.CommonServiceImpl;
import api.rest.service.If_s_atx110t_jukrServiceImpl;
import api.rest.utils.RestUtils;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.utils.ConfigUtil;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.com.constants.Unilite;

/**
 * <pre>
 * 회계세금계산서정보 Web Service를 위한 API Controller
 * </pre>
 * 
 * @author 박종영
 */
@Controller
public class TaxBillApiController extends UniliteCommonController {
    
    private final Logger                 logger = LoggerFactory.getLogger(this.getClass());
    
    RestUtils                            utils  = new RestUtils();
    
    /**
     * Log 테이블 관리
     */
    @Resource( name = "commonServiceImpl" )
    private CommonServiceImpl            commonServiceImpl;
    
    /**
     * 회계세금계산서정보 Service
     */
    @Resource( name = "if_s_atx110t_jukrServiceImpl" )
    private If_s_atx110t_jukrServiceImpl if_s_atx110t_jukrServiceImpl;
    
    /**
     * <pre>
     * 회계세금계산서정보 관리
     * IF_C0013
     * </pre>
     * 
     * @param _req
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/api/saveInf003", method = RequestMethod.POST )
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public ModelAndView saveInf003( ExtHtttprequestParam _req, HttpServletRequest request ) throws Exception {
        
        logger.debug("logger 시작 ----------------------------");
        logger.debug("gubun : {}", _req.getP("gubun"));
        logger.debug("접속자 IP :: " + request.getRemoteAddr());
        logger.debug("----------------------------");
        
        boolean webServiceYn = ConfigUtil.getBooleanValue("common.dataOption.web-service", false);
        logger.debug("webServiceYn :: {}", webServiceYn);
        
        if (webServiceYn) {
            Map rtnMsg = new HashMap();
            Map logMap = new HashMap();
            /*
             * Job ID 생성
             */
            String jobId = utils.makeJobID();
            
            /*
             * Logging 시작
             */
            logMap.put("BATCH_SEQ", jobId);
            logMap.put("BATCH_ID", "IF_C0013");
            logMap.put("CLIENT_IP", request.getRemoteAddr());
            commonServiceImpl.insertLog(logMap);
            
            String gubun = _req.getP("gubun");
            //String gubun = (String)_req.getObject("gubun");
            List<Map<String, Object>> dataList = (List<Map<String, Object>>)_req.getObject("data");
            logger.debug("dataList : {}", dataList);
            
            if (gubun == null || gubun.length() == 0) {
                /*
                 * Logging 끝
                 */
                logMap.put("STATUS", "1");
                logMap.put("RESULT_MSG", "구분코드가 존재하지 않습니다.");
                commonServiceImpl.updateLog(logMap);
                
                return ViewHelper.getJsonView(utils.convErrorMessage("Error", "구분코드가 존재하지 않습니다."));
            }
            if (!gubun.equals("2")) {
                /*
                 * Logging 끝
                 */
                logMap.put("STATUS", "1");
                logMap.put("RESULT_MSG", "구분코드가 부가세신고용('2')가 아닙니다.");
                commonServiceImpl.updateLog(logMap);
                
                return ViewHelper.getJsonView(utils.convErrorMessage("Error", "구분코드가 부가세신고용('2')가 아닙니다."));
            }
            
            if (dataList == null || dataList.size() == 0) {
                /*
                 * Logging 끝
                 */
                logMap.put("STATUS", "1");
                logMap.put("RESULT_MSG", "전송된 상세 데이터가 없습니다.");
                commonServiceImpl.updateLog(logMap);
                
                return ViewHelper.getJsonView(utils.convErrorMessage("Error", "전송된 상세 데이터가 없습니다."));
            }
            
            try {
                
                String rtnValue = if_s_atx110t_jukrServiceImpl.apiSaveAll(dataList);
                if (rtnValue.startsWith("0/")) {
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
            
            logger.debug("logMap :: {}", rtnMsg);
            
            return ViewHelper.getJsonView(rtnMsg);
        } else {
            return ViewHelper.getJsonView(null);
        }
    }
    
    /**
     * <pre>
     * 회계세금계산서 및 부가세신고용정보 ( 파워빌더용 )
     * IF_C0009
     * </pre>
     * 
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/api/saveInfPB003", method = RequestMethod.POST )
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public ModelAndView saveInfPB003( HttpServletRequest request ) throws Exception {
        
        boolean webServiceYn = ConfigUtil.getBooleanValue("common.dataOption.web-service", false);
        logger.debug("webServiceYn :: {}", webServiceYn);
        
        if (webServiceYn) {
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
            logMap.put("BATCH_ID", "IF_C0013");
            logMap.put("CLIENT_IP", request.getRemoteAddr());
            commonServiceImpl.insertLog(logMap);
            
            logger.debug("logger 시작 ----------------------------");
            logger.debug("contextName :: " + Unilite.getCurrentContextName(request.getContextPath()));
            logger.debug("data : " + request.getParameter("data"));
            logger.debug("gubun : " + request.getParameter("gubun"));
            logger.debug("접속자 IP :: " + request.getRemoteAddr());
            logger.debug("----------------------------");
            
            if (request.getParameter("gubun") == null || request.getParameter("gubun").length() == 0) {
                
                /*
                 * Logging 끝
                 */
                logMap.put("STATUS", "1");
                logMap.put("RESULT_MSG", "구분코드가 존재하지 않습니다.");
                commonServiceImpl.updateLog(logMap);
                
                rtnMsg.put("message", "1/구분코드가 존재하지 않습니다.");
                return ViewHelper.getJsonView(rtnMsg);
            }
            
            if (request.getParameter("data") == null || request.getParameter("data").length() == 0) {
                /*
                 * Logging 끝
                 */
                logMap.put("STATUS", "1");
                logMap.put("RESULT_MSG", "전송된 데이터가 없습니다.");
                commonServiceImpl.updateLog(logMap);
                
                rtnMsg.put("message", "1/전송된 데이터가 없습니다.");
                return ViewHelper.getJsonView(rtnMsg);
            }
            
            String data = null;
            String platstr = System.getProperty("os.name");
            JSONObject jsonObj = null;
            
            if (platstr.indexOf("Windows") != -1) {
                data = new String(request.getParameter("data").getBytes("iso-8859-1"), "euc-kr");
            } else {
                data = new String(request.getParameter("data").getBytes("iso-8859-1"), "utf-8");
            }
            
            try {
                jsonObj = JSONObject.fromObject(JSONSerializer.toJSON(data));
            } catch (JSONException jsonexception) {
                /*
                 * Logging 끝
                 */
                logMap.put("STATUS", "1");
                logMap.put("RESULT_MSG", "JSON 문자열 오류.");
                commonServiceImpl.updateLog(logMap);
                
                rtnMsg.put("message", "1/JSON 문자열 오류.");
                return ViewHelper.getJsonView(rtnMsg);
            }
            
            List dataList = utils.jsonToList((JSONArray)jsonObj.get("data"));
            
            try {
                
                Map param = new HashMap();
                param.put("JOB_ID", jobId);
                param.put("GUBUN", request.getParameter("gubun"));
                
                param = if_s_atx110t_jukrServiceImpl.apiSaveTemp(param, dataList);
                if (param.get("ERR_CODE") != null && ( (String)param.get("ERR_CODE") ).equals("1")) {
                    /*
                     * Logging 끝
                     */
                    logMap.put("STATUS", "1");
                    logMap.put("RESULT_MSG", param.get("ERR_MSG"));
                    commonServiceImpl.updateLog(logMap);
                    
                    rtnMsg.put("message", "1/" + param.get("ERR_MSG"));  // Power Builder는 status 를 보내지 않음.
                    return ViewHelper.getJsonView(rtnMsg);
                }
                
                String rtnValue = if_s_atx110t_jukrServiceImpl.apiSaveAllPB(param, dataList);
                logger.info("rtnValue :: {}", rtnValue);
                rtnMsg.put("message", rtnValue);  // Power Builder는 status 를 보내지 않음.
                
                /*
                 * Logging 끝
                 */
                logMap.put("STATUS", "0");
                logMap.put("RESULT_MSG", "");
                commonServiceImpl.updateLog(logMap);
                
            } catch (Exception e) {
                e.printStackTrace();
                rtnMsg.put("message", "1/" + e.getMessage());
                
                /*
                 * Logging 끝
                 */
                logMap.put("STATUS", "1");
                logMap.put("RESULT_MSG", e.getMessage());
                commonServiceImpl.updateLog(logMap);
                
                return ViewHelper.getJsonView(rtnMsg);
            }
            
            logger.debug("logMap :: {}", rtnMsg);
            
            return ViewHelper.getJsonView(rtnMsg);
        } else {
            return ViewHelper.getJsonView(null);
        }
    }
    
    /**
     * <pre>
     * 회계세금계산서정보 관리
     * IF_C0013
     * </pre>
     * 
     * @param _req
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/api/uptStatusAtx110", method = RequestMethod.POST )
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public ModelAndView uptStatusAtx110( ExtHtttprequestParam _req, HttpServletRequest request ) throws Exception {
        Map rtnMsg = new HashMap();
        Map logMap = new HashMap();
        
        /*
         * Job ID 생성
         */
        String jobId = utils.makeJobID();
        
        /*
         * Logging 시작
         */
        logMap.put("BATCH_SEQ", jobId);
        logMap.put("BATCH_ID", "IF_C0013");
        logMap.put("CLIENT_IP", request.getRemoteAddr());
        commonServiceImpl.insertLog(logMap);
        
        logger.debug("logger 시작 ----------------------------");
        logger.debug("접속자 IP :: " + request.getRemoteAddr());
        logger.debug("----------------------------");
        
        List<Map<String, Object>> dataList = (List<Map<String, Object>>)_req.getObject("data");
        List<Map<String, Object>> headerList = (List<Map<String, Object>>)_req.getObject("header");
        logger.debug("dataList : {}", dataList);
        logger.debug("headerList : {}", headerList);
        
        if (dataList == null || dataList.size() == 0) {
            /*
             * Logging 끝
             */
            logMap.put("STATUS", "1");
            logMap.put("RESULT_MSG", "전송된 상세 데이터가 없습니다.");
            commonServiceImpl.updateLog(logMap);
            
            return ViewHelper.getJsonView(utils.convErrorMessage("Error", "전송된 상세 데이터가 없습니다."));
        }
        
        try {
            
            Map inMap = dataList.get(0);
            Map hMap = headerList.get(0);
            logger.debug("PUSH 정보 :: {}", inMap);
            logger.debug("HEADER 정보 :: {}", hMap);
            if (hMap.get("IF_ID") != null && ( (String)hMap.get("IF_ID") ).equals("IF_G0010")) {
                logger.debug("세금계산서 메일재전송 정보 Update :: {}", inMap);
                // 세금계산서 메일재전송 정보 Update
                if_s_atx110t_jukrServiceImpl.uptStatusAtx110_2(inMap);
            } else {
                logger.debug("회계세금계산서 정보 Update :: {}", inMap);
                // 회계세금계산서 정보 Update
                if_s_atx110t_jukrServiceImpl.uptStatusAtx110_1(inMap);
            }
            
            rtnMsg.put("status", "0");
            rtnMsg.put("message", "");
            
            /*
             * Logging 끝
             */
            logMap.put("STATUS", "0");
            logMap.put("RESULT_MSG", "");
            commonServiceImpl.updateLog(logMap);
            
        } catch (Exception e) {
            e.printStackTrace();
            
            rtnMsg.put("status", "1");
            rtnMsg.put("message", e.getMessage());
            
            /*
             * Logging 끝
             */
            logMap.put("STATUS", "1");
            logMap.put("RESULT_MSG", e.getMessage());
            commonServiceImpl.updateLog(logMap);
        }
        
        logger.debug("logMap :: {}", rtnMsg);
        
        return ViewHelper.getJsonView(rtnMsg);
    }
}
