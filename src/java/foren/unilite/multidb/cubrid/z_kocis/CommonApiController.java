package foren.unilite.multidb.cubrid.z_kocis;

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

import foren.framework.model.ExtHtttprequestParam;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.com.constants.Unilite;
import foren.unilite.utils.DevFreeUtils;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;

/**
 * <pre>
 * Web Service를 위한 API Controller
 * </pre>
 * 
 * @author 박종영
 */
@Controller
public class CommonApiController extends UniliteCommonController {
    
    private final Logger      logger = LoggerFactory.getLogger(this.getClass());
    
    /**
     * Web Service를 위한 Service
     */
    @Resource( name = "commonServiceImpl" )
    private CommonServiceImpl commonServiceImpl;
    
    /**
     * <pre>
     * 전표 자동기표
     * 오류의 확인은 IF_ERROR_MSG, AGD361T 두개 테이블을 확인해야 함.
     * IF_C0006
     * 
     * status  : "0" 성공, "1" 실패
     * message : 오류메시지 
     * if_num  : 전표처리 결과
     * 
     * status 가 "0" 이더라도 전표처리 결과에 따라 "AC_DATE", "SLIP_NUM"를 반환하지 않을 수 있음.
     * </pre>
     * 
     * @param _req
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/api/syncUser", method = { RequestMethod.POST, RequestMethod.GET } )
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public ModelAndView syncUser( ExtHtttprequestParam _req, HttpServletRequest request ) throws Exception {
        
        logger.debug("logger 시작 ----------------------------");
        logger.debug("contextName :: " + Unilite.getCurrentContextName(request.getContextPath()));
        logger.debug("접속자 IP :: " + request.getRemoteAddr());
        logger.debug("----------------------------");
        
        Map rtnMsg = new HashMap();
        Map logMap = new HashMap();
        
        /*
         * Job ID 생성
         */
        String jobId = DevFreeUtils.makeJobID();
        
        /*
         * Logging 시작
         */
        logMap.put("BATCH_SEQ", jobId);
        logMap.put("BATCH_ID", "IF_00001");
        logMap.put("CLIENT_IP", request.getRemoteAddr());
        commonServiceImpl.insertLog(logMap);
        
        try {
            String param = _req.getP("param");
            logger.info("param :; " + param);
            if (param != null) {
                JSONObject jsonObj = JSONObject.fromObject(JSONSerializer.toJSON(param));
                List dataList = DevFreeUtils.jsonToList((JSONArray)jsonObj.get("data"));
                logger.debug("dataList :: " + dataList);
                
                if (dataList != null) {
                    for (int i = 0; i < dataList.size(); i++) {
                        Map<String, Object> iMap = (Map)dataList.get(i);
                        commonServiceImpl.deleteBsa300T(iMap);
                    }
                }
            }
            /*
             * Temp 테이블에 데이터를 Insert 한다.
             */
            int rtnValue = commonServiceImpl.saveBsa300T(logMap);
            logger.info("rtnValue :: {}", rtnValue);
            
            if (rtnValue >= 0) {
                
                rtnMsg.put("status", "0");        // 
                rtnMsg.put("message", rtnValue + "건 등록 성공");        //
                
                /*
                 * Logging 끝
                 */
                logMap.put("STATUS", "0");
                logMap.put("RESULT_MSG", rtnValue + "건 등록 성공");
                
            }
            
            logger.info("logMap :: {}", logMap);
            
            commonServiceImpl.updateLog(logMap);
            
        } catch (Exception e) {
            e.printStackTrace();
            
            rtnMsg.put("status", "1");        // 
            rtnMsg.put("message", DevFreeUtils.errorMsg(e.getMessage()));        //
            
            logger.info("getMessage :: {}", DevFreeUtils.errorMsg(e.getMessage()));
            
            /*
             * Logging 끝
             */
            logMap.put("STATUS", "1");
            logMap.put("RESULT_MSG", DevFreeUtils.errorMsg(e.getMessage()));
            commonServiceImpl.updateLog(logMap);
        }
        
        logger.debug("rtnMsg :: {}", rtnMsg);
        
        return ViewHelper.getJsonView(rtnMsg);
    }
    
}
