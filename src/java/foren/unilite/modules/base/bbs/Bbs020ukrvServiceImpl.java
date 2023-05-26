package foren.unilite.modules.base.bbs;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.validation.BindingResult;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.service.impl.TlabMenuService;


@Service("bbs020ukrvService")
public class Bbs020ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger	logger	= LoggerFactory.getLogger(this.getClass());

	@Resource(name = "tlabMenuService")
	 TlabMenuService tlabMenuService;
	/**
	 *  입력데이타형태입력 조회
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_LOAD, group = "base")
	public Object select(Map param) throws Exception {		
		
		return super.commonDao.select("bbs020ukrvServiceImpl.select", param);
	}
	
	
	/**
	 *  입력데이타형태입력 입력/수정
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "base")
	public ExtDirectFormPostResult save(Bbs020ukrvModel param, LoginVO user,  BindingResult result) throws Exception {
		param.setS_COMP_CODE(user.getCompCode());
		param.setS_USER_ID(user.getUserID());
		super.commonDao.update("bbs020ukrvServiceImpl.save", param);
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
		tlabMenuService.reload();	
		return extResult;
	}
	

}
