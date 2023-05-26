package api.rest.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.codehaus.jackson.JsonGenerationException;
import org.codehaus.jackson.map.JsonMappingException;
import org.codehaus.jackson.map.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import api.rest.service.ProductApiServiceImpl;
import api.rest.utils.RestUtils;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;

/**
 * <pre>
 * 출판 상품정보 인터페이스
 * - 출판의 상품정보가 기준정보 상품정보에 등록되면, 등록된 내용을 MIS의 상품으로 등록함.
 * </pre>
 * 
 * @author 박종영
 */
@Controller
public class ProductApiController extends UniliteCommonController {
    
    private final Logger          logger = LoggerFactory.getLogger(this.getClass());
    
    RestUtils                     utils  = new RestUtils();
    
    /**
     * Service 상품정보 Service
     */
    @Resource( name = "productApiService" )
    private ProductApiServiceImpl productApiService;
    
    /**
     * 상품정보 등록, 수정, 삭제(단건)
     * 
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/api/saveBpr100t", method = RequestMethod.POST )
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public ModelAndView saveBpr100t( ExtHtttprequestParam _req, HttpServletRequest request ) throws Exception {
        
        logger.debug("logger 시작 ----------------------------");
        logger.debug("data :: " + _req.getObject("data"));
        logger.debug("접속자 IP :: " + request.getRemoteAddr());
        logger.debug("----------------------------");
        
        Map<String, Object> inData = null;
        try {
            inData = (Map<String, Object>)_req.getObject("data");
            logger.debug("inData : {}", inData);
        } catch (ClassCastException cce) {
            return ViewHelper.getJsonView(utils.convErrorMessage("Error", "JSON Object 오류입니다. (JSON 배열은 안됩니다.)"));
        } catch (Exception e) {
            return ViewHelper.getJsonView(utils.convErrorMessage("Error", utils.errorMsg(e.getMessage())));
        }
        
        if (inData == null) {
            return ViewHelper.getJsonView(utils.convErrorMessage("Error", "전송된 데이터가 없습니다."));
        }
        
        Map rtnMsg = new HashMap();
        
        try {
            // Temp에서 상품Tb로 insert
            productApiService.saveBpr100t(inData);
            
            rtnMsg.put("status", "0");
            rtnMsg.put("message", "");
        } catch (Exception e) {
            e.printStackTrace();
            rtnMsg.put("status", "1");
            rtnMsg.put("message", e.getMessage());
        }
        
        logger.debug("logMap :: {}", rtnMsg);
        
        return ViewHelper.getJsonView(rtnMsg);
    }
    
    /**
     * List 타입 -> Json 타입으로 변환
     * 
     * @param list
     * @param indent Json 문자열 정렬여부
     * @return
     */
    @SuppressWarnings( "rawtypes" )
    public String listToJson( List list ) {
        StringBuffer sb = new StringBuffer();
        ObjectMapper objMapper = new ObjectMapper();
        
        try {
            sb.append(objMapper.writeValueAsString(list));
        } catch (JsonGenerationException e) {
            logger.error(e.getMessage());
            return "";
        } catch (JsonMappingException e) {
            logger.error(e.getMessage());
            return "";
        } catch (IOException e) {
            logger.error(e.getMessage());
            return "";
        }
        
        return sb.toString();
    }
    
}
