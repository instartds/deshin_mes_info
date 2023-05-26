package foren.unilite.modules.cost.cdr;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.base.bdc.Bdc100ukrvService;
import foren.unilite.modules.com.fileman.FileMnagerService;



@Service("cdr200skrvService")
public class Cdr200skrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	
	
	/**
	 * 자판기기초재고등록 왼쪽
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(group = "cost", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		
		return super.commonDao.list("cdr200skrvServiceImpl.selectList", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_LOAD, group = "cost")
	public Object  selectWORK_SEQ(Map param) throws Exception {
		return  super.commonDao.select("cdr200skrvServiceImpl.selectWORK_SEQ", param);
	}
	
	
	
}