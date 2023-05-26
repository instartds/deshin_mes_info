package foren.unilite.modules.accnt.afn;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.BindingResult;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.extjs.UniliteExtjsUtils;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.accnt.atx.Atx520ukrModel;
import foren.unilite.modules.base.bdc.Bdc100ukrvService;
import foren.unilite.modules.com.fileman.FileMnagerService;



@Service("afn210ukrService")
public class Afn210ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	
	
	
	private String getNumreicCode(String type, String code)	{
		if("NOTE_NUM_NUMBER".equals(type))	{
			int len = 8;
			if(code.length() < len)		{
				if(Pattern.matches("^[0-9]+$", code)){
					code = String.format("%0"+len+"d", Long.parseLong(code));
				}						
			}
		}
		return code;
	}
	/**저장**/
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "accnt")
	public ExtDirectFormPostResult syncMaster(Afn210ukrModel param, LoginVO user,  BindingResult result) throws Exception {

		param.setS_USER_ID(user.getUserID());
		param.setS_COMP_CODE(user.getCompCode());
		
//		Long frNoteNum = Long.parseLong(this.getNumreicCode("NOTE_NUM_NUMBER", param.getTxtFrNo2().toString()));
//		Long toNoteNum = Long.parseLong(this.getNumreicCode("NOTE_NUM_NUMBER", param.getTxtToNo2().toString()));
		
		Long frNoteNum = Long.parseLong(param.getTxtFrNo2());
		Long toNoteNum = Long.parseLong(param.getTxtToNo2());
		
		for(long i = frNoteNum; i < toNoteNum+1; i++) {
			param.setNOTE_NUM(param.getTxtFrNo1() + this.getNumreicCode("NOTE_NUM_NUMBER", Long.toString(i)));
			
			super.commonDao.update("afn210ukrServiceImpl.insertForm", param);
		
		}
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);

		return extResult;
	}
	
}
