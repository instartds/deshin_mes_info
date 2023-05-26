package foren.unilite.modules.human.had;

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



@Service("had840rkrService")
public class Had840rkrServiceImpl  extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "had")			// 조회
	public List<Map<String, Object>>  selectList2016_Query1(Map param) throws Exception {
		return  super.commonDao.list("had840rkrServiceImpl.selectList2016_Query1", param);	
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "had")			// 조회
	public List<Map<String, Object>>  selectList2016_Query2(Map param) throws Exception {
		return  super.commonDao.list("had840rkrServiceImpl.selectList2016_Query2", param);	
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "had")			// 조회
	public List<Map<String, Object>>  selectList2018_Query1(Map param) throws Exception {
		return  super.commonDao.list("had840rkrServiceImpl.selectList2018_Query1", param);	
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "had")			// 조회
	public List<Map<String, Object>>  selectList2018_Query2(Map param) throws Exception {
		return  super.commonDao.list("had840rkrServiceImpl.selectList2018_Query2", param);	
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "had")			// 조회
	public List<Map<String, Object>>  selectList2019_Query1(Map param) throws Exception {
		return  super.commonDao.list("had840rkrServiceImpl.selectList2019_Query1", param);	
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "had")			// 조회
	public List<Map<String, Object>>  selectList2019_Query2(Map param) throws Exception {
		return  super.commonDao.list("had840rkrServiceImpl.selectList2019_Query2", param);	
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "had")			// 조회
	public List<Map<String, Object>>  selectList2020_Query1(Map param) throws Exception {
		return  super.commonDao.list("had840rkrServiceImpl.selectList2020_Query1", param);	
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "had")			// 조회
	public List<Map<String, Object>>  selectList2020_Query2(Map param) throws Exception {
		return  super.commonDao.list("had840rkrServiceImpl.selectList2020_Query2", param);	
	}
	
}
