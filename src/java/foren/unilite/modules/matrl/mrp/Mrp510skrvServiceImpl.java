package foren.unilite.modules.matrl.mrp;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("mrp510skrvService")
public class Mrp510skrvServiceImpl extends TlabAbstractServiceImpl {

	/**
	 * 가용재고조회 마스터
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "mrp")
	public List<Map<String, Object>>  selectMaster(Map param) throws Exception {	
		return super.commonDao.list("mrp510skrvServiceImpl.selectMaster", param);
	}

	/**
	 * 가용재고조회 디테일
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "mrp")
	public List<Map<String, Object>>  selectDetail(Map param) throws Exception {	
		return super.commonDao.list("mrp510skrvServiceImpl.selectDetail", param);
	}

}
