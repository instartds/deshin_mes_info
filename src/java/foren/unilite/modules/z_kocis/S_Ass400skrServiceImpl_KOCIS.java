package foren.unilite.modules.z_kocis;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("s_ass400skrService_KOCIS")
public class S_Ass400skrServiceImpl_KOCIS  extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
//	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "accnt")		// BUDG_NAME컬럼수
//	public List<Map<String, Object>>  selectBudgName(Map param) throws Exception {	
//		return  super.commonDao.list("afs100skrServiceImpl.selectBudgName", param);
//	}
//	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "accnt")		// 메인
	public List<Map<String, Object>>  selectList(Map param) throws Exception {	
//		super.commonDao.list("afs100skrServiceImpl.selectBudgName", param);
		return  super.commonDao.list("s_ass400skrServiceImpl_KOCIS.selectList", param);
	}
}
