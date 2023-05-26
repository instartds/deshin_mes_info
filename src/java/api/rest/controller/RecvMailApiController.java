package api.rest.controller;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import api.rest.service.MailServiceImpl;
import api.rest.utils.RestUtils;
import foren.framework.model.ExtHtttprequestParam;
import foren.unilite.com.UniliteCommonController;

/**
 * <pre>
 * 메일 수신여부 확인을 위한 API Controller
 * - JBill 등의 전자결재 미결메일 발송 시 메일 수신여부 확인.
 * 사내메일만 확인 가능하다.
 * </pre>
 * 
 * @author 박종영
 */
@Controller
public class RecvMailApiController extends UniliteCommonController {
    
    private final Logger    logger = LoggerFactory.getLogger(this.getClass());
    RestUtils               utils  = new RestUtils();
    
    /**
     * 메일 수신 Service
     */
    @Resource( name = "mailServiceImpl" )
    private MailServiceImpl mailServiceImpl;
    
    /**
     * 메일 수신 여부 확인
     * 
     * @param _req
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/api/mailRecv", method = RequestMethod.GET )
    public void getInf001( ExtHtttprequestParam _req, HttpServletRequest request ) throws Exception {
        String serial = request.getParameter("serial");
        
        try {
            logger.info("여기..................." + serial);
            mailServiceImpl.updateRecv(serial);
        } catch (Exception e) {
            logger.error(e.getMessage());
        }
        
    }
    
}
