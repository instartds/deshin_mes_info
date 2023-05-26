package foren.unilite.modules.zDevelopPractice;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("mpo134skrvTestService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Mpo134skrvTestServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * 발주현황 조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "mpo")
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return  super.commonDao.list("mpo134skrvTestServiceImpl.selectList", param);
	}
}