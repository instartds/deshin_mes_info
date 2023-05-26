package foren.unilite.modules.base.log;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("log900skrService")
public class Log900skrServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * 배치 및 인터페이스 LOG조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "log")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
	
		return  super.commonDao.list("log900skrServiceImpl.selectList", param);
	}

	
}
