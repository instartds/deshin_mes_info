package foren.unilite.modules.accnt.atx;

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
import foren.unilite.com.tags.ComboItemModel;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.base.bdc.Bdc100ukrvService;
import foren.unilite.modules.com.fileman.FileMnagerService;



@Service("atx450rkrService")
public class Atx450rkrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	
	
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)	// 제일 먼저 조회
	public List<Map<String, Object>> selectList1(Map param) throws Exception {
		return super.commonDao.list("atx450rkrServiceImpl.selectList1", param);
	}

	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)	// 1번쨰 그리드
	public List<Map<String, Object>> selectList2(Map param) throws Exception {
		return super.commonDao.list("atx450rkrServiceImpl.selectList2", param);
	}
	
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)	// 2번쨰 그리드
	public List<Map<String, Object>> selectList3(Map param) throws Exception {
		return super.commonDao.list("atx450rkrServiceImpl.selectList3", param);
	}
	
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)	// 3번쨰 그리드
	public List<Map<String, Object>> selectList4(Map param) throws Exception {
		return super.commonDao.list("atx450rkrServiceImpl.selectList4", param);
	}
	
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)	// 4번쨰 그리드
	public List<Map<String, Object>> selectList5(Map param) throws Exception {
		return super.commonDao.list("atx450rkrServiceImpl.selectList5", param);
	}
}
