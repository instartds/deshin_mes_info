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

@Service("emailBeforeSendService")
public class EmaiBeforeSendServiceImpl  extends TlabAbstractServiceImpl {
	
	 private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	 @Resource( name = "emailSendService" )
	 private EmailSendServiceImpl emailSendService;

	@ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "com")
    public ExtDirectFormPostResult sendEmail( EmailModel emailModel, LoginVO user, BindingResult result) throws Exception {
		Map param = new HashMap();
		param.put("success", Boolean.TRUE);       
        	
    	/*param.put("TO", emailModel.getTO());
    	param.put("SUBJECT", emailModel.getSUBJECT());
    	param.put("TEXT" , emailModel.getTEXT());
    	emailSendService.sendMail(param);
    	*/
		emailModel.setCOMP_CODE(user.getCompCode());
    	emailSendService.sendMail(emailModel);
        	
        
        ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
        return extResult;
    }
 
}
