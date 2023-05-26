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

import api.rest.service.CommonServiceImpl;
import api.rest.service.If_bsa210t_jsServiceImpl;
import api.rest.service.If_bsa300t2_jsServiceImpl;
import api.rest.utils.RestUtils;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.utils.ConfigUtil;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;

/**
 * <pre>
 * 사원정보/조직 Web Service를 위한 API Controller
 * </pre>
 * 
 * @author 박종영
 */
@Controller
public class UserInfoApiController extends UniliteCommonController {
    
    private final Logger              logger = LoggerFactory.getLogger(this.getClass());
    RestUtils                         utils  = new RestUtils();

    /**
     * Log 테이블 관리
     */
    @Resource( name = "commonServiceImpl" )
    private CommonServiceImpl       commonServiceImpl;
    
    /**
     * 인사 사원정보 Service
     */
    @Resource( name = "if_bsa300t2_jsServiceImpl" )
    private If_bsa300t2_jsServiceImpl if_bsa300t2_jsServiceImpl;
    
    /**
     * 인사 조직정보 Service
     */
    @Resource( name = "if_bsa210t_jsServiceImpl" )
    private If_bsa210t_jsServiceImpl  if_bsa210t_jsServiceImpl;
    
    /**
     * 인사시스템 - 사원정보, 부서정보 IF_A0001, IF_A0003
     * 
     * @param _req
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/api/saveUserInfo", method = RequestMethod.POST )
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public ModelAndView getInf001( ExtHtttprequestParam _req, HttpServletRequest request ) throws Exception {
        
        boolean webServiceYn = ConfigUtil.getBooleanValue("common.dataOption.web-service", false);
        logger.debug("webServiceYn :: {}", webServiceYn);
        
        if (webServiceYn) {
            Map rtnMsg = new HashMap();
            Map logMap = new HashMap();
            
            /*
             * Job ID 생성
             */
            String jobId = utils.makeJobID();
            
            
            logger.debug("logger 시작 ----------------------------");
            logger.debug("접속자 IP :: " + request.getRemoteAddr());
            logger.debug("----------------------------");
            
            try {
                
                String rtnValue = null;
                
                String gubun = _req.getP("gubun");
                
                if (gubun.equals("1")) {
                    /*
                     * Logging 시작 
                     */
                    logMap.put("BATCH_SEQ", jobId);
                    logMap.put("BATCH_ID", "IF_A0001");
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
                    
                    rtnValue = if_bsa300t2_jsServiceImpl.apiSaveAll(jobId, dataList);
                    boolean isDev = ConfigUtil.getBooleanValue("system.isDevelopServer", false);
                    if (!isDev) {
                        if_bsa300t2_jsServiceImpl.migDMSS(jobId);
                    }
                    
                    String[] rtnVal = rtnValue.split("\\|");
                    
                    if (!rtnVal[3].equals("0")) {
                        rtnMsg.put("status", "1");
                        rtnMsg.put("message", "Status 코드 없는 건수 : " + rtnVal[3]);
                    } else {
                        rtnMsg.put("status", "0");
                        rtnMsg.put("message", rtnVal[0]);
                        
    
                    }
    
                    /*
                     * Logging 끝
                     */
                    logMap.put("STATUS", "0");
                    logMap.put("RESULT_MSG", "인사사원정보 " + rtnVal[0] + "건 인터페이스 성공");
                    commonServiceImpl.updateLog(logMap);
                    
                } else if (gubun.equals("2")) {
    
                    /*
                     * Logging 시작 
                     */
                    logMap.put("BATCH_SEQ", jobId);
                    logMap.put("BATCH_ID", "IF_A0003");
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
    
                    
                    rtnValue = if_bsa210t_jsServiceImpl.apiSaveAll(jobId, dataList);
                    String[] rtnVal = rtnValue.split("\\|");
                    
                    logger.debug("rtnVal[0] :: {}", rtnVal[0]);
                    logger.debug("rtnVal[3] :: {}", rtnVal[3]);
                    
                    if (!rtnVal[3].equals("0")) {
                        rtnMsg.put("status", "1");
                    } else {
                        rtnMsg.put("status", "0");
                        rtnMsg.put("message", rtnVal[0]);
                    }
                    
    
                    /*
                     * Logging 끝
                     */
                    logMap.put("STATUS", "0");
                    logMap.put("RESULT_MSG", "인사부서정보 " + rtnVal[0] + "건 인터페이스 성공");
                    commonServiceImpl.updateLog(logMap);
                    
                } else {
                    rtnMsg.put("status", "1");
                    rtnMsg.put("message", "구분코드 오류");
                    
                    /*
                     * Logging 끝
                     */
                    logMap.put("STATUS", "1");
                    logMap.put("RESULT_MSG", "구분코드 오류");
                    commonServiceImpl.updateLog(logMap);
                }
            } catch (Exception e) {
                logger.debug("인사 임직원정보 Exception :: {}", e.getMessage());
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
        } else {
            return ViewHelper.getJsonView(null);
        }
    }
}
