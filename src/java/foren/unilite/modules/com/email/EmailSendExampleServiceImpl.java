package foren.unilite.modules.com.email;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.MailSender;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.BindingResult;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;

@Service("emailSendExampleService")
public class EmailSendExampleServiceImpl  extends TlabAbstractServiceImpl {
	
	 private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	 @Resource( name = "emailSendService" )
	 private EmailSendServiceImpl emailSendService;

	@ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "com")
    public ExtDirectFormPostResult sendEmail( EmailModel emailModel, LoginVO user, BindingResult result) throws Exception {
			
        	/**
        	* Map을 사용할 경우
        	* param.put("TO", emailModel.getTO());
        	* param.put("FROM", emailModel.getFROM());
        	* param.put("SUBJECT", emailModel.getSUBJECT());
        	* param.put("TEXT" , emailModel.getTEXT());
        	* param.put("COMP_CODE" ,user.getCompCode());// Email sender 정보를 공통코드 BS32 사용할 경우 COMP_CODE 필요
        	* emailSendService.sendMail(param);
        	**/
		
			/**
			 * EmailModel을 사용할 경우
			 *  첨부파일 : emailModel.setFILE("C:\\_My\\downloads\\test.pdf");
			 *  TEXT에 html 사용 : emailModel.setHasHtmlText(true);
			 **/
			emailModel.setCOMP_CODE(user.getCompCode()); 	// Email sender 정보를 공통코드 BS32 사용할 경우 COMP_CODE 필요
			emailModel.setHasHtmlText(true);
        	emailSendService.sendMail(emailModel);
        	
        
        ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
        return extResult;
    }
 
}
