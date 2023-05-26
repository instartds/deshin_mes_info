package foren.unilite.modules.prodt.pms;

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



@Service("pms500ukrvService")
public class Pms500ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	
	

	/**
	 * 수주정보 Master 조회 
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	
	@ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_READ)		// 조회1
	public List<Map<String, Object>> selectMaster(Map param) throws Exception {
		return super.commonDao.list("pms500ukrvServiceImpl.selectMaster", param);
	}
	
	@ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_READ)		// 조회2
	public List<Map<String, Object>> selectMaster2(Map param) throws Exception {
		return super.commonDao.list("pms500ukrvServiceImpl.selectMaster2", param);
	}
	
	@ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.FORM_LOAD)		// 검색팝업
	public Object selectList(Map param) throws Exception {
		return super.commonDao.select("pms500ukrvServiceImpl.selectList", param);
	}
	
	@ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.FORM_LOAD)		// 참조
	public Object selectList3(Map param) throws Exception {
		return super.commonDao.select("pms500ukrvServiceImpl.selectList3", param);
	}
}
