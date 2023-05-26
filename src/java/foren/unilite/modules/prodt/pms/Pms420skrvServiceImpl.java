package foren.unilite.modules.prodt.pms;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("pms420skrvService")
@SuppressWarnings({ "unchecked", "rawtypes" })
public class Pms420skrvServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * 공정출하검사현황 (pms420skrv)
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return  super.commonDao.list("pms420skrvServiceImpl.selectList", param);
	}
}