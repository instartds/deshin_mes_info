package foren.unilite.modules.accnt.agc;

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



@Service("agc100skrService")
public class Agc100skrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_LOAD, group = "accnt")
	public Object selectMsg(Map param) throws Exception {		
		return super.commonDao.select("agc100skrServiceImpl.selectMsg", param);
	}
	
	/**
	 * 
	 * 누락된 계정항목 개수 조회 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public Object selectOmitCnt(Map param) throws Exception {
		return super.commonDao.select("agc100skrServiceImpl.selectOmitCnt", param);
	}
	
	/**
	 * 
	 * Detail 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)		// 당월포함
	public List<Map<String, Object>> selectList1(Map param) throws Exception {
		return super.commonDao.list("agc100skrServiceImpl.selectList", param);
	}	
	
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)		// 당월미포함
	public List<Map<String, Object>> selectList2(Map param) throws Exception {
		return super.commonDao.list("agc100skrServiceImpl.selectList2", param);
	}
}
