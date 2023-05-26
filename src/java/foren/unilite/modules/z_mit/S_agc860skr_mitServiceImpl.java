package foren.unilite.modules.z_mit;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;

@Service("s_agc860skr_mitService") 
@SuppressWarnings({ "unchecked", "rawtypes" })
public class S_agc860skr_mitServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * 품목별 조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_mit")
	public List<Map<String, Object>> selectList1(Map param) throws Exception {
		return  super.commonDao.list("s_agc860skr_mitServiceImpl.selectList1", param);
	}
	
	/**
	 * 대륙별 조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_mit")
	public List<Map<String, Object>> selectList2(Map param) throws Exception {
		return  super.commonDao.list("s_agc860skr_mitServiceImpl.selectList2", param);
	}
}
