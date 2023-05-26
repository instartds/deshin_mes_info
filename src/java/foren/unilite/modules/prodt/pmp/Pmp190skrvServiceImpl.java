package foren.unilite.modules.prodt.pmp;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("pmp190skrvService")
public class Pmp190skrvServiceImpl  extends TlabAbstractServiceImpl {
	/**
	 * 후공정_신환1
	 * @param param 검색항목
	 * @return	
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  subReport_sh1(Map param) throws Exception {
		return  super.commonDao.list("pmp190skrvServiceImpl.subReport_sh1", param);
	}	
	/**
	 * 후공정_신환2
	 * @param param 검색항목
	 * @return	
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  subReport_sh2(Map param) throws Exception {
		return  super.commonDao.list("pmp190skrvServiceImpl.subReport_sh2", param);
	}
	/**
	 * 
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
	
		return  super.commonDao.list("pmp190skrvServiceImpl.selectList", param);
	}
	/**
	 * 작업지시내역
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  mainReport(Map param) throws Exception {
		return  super.commonDao.list("pmp190skrvServiceImpl.mainReport", param);
	}
	
	/**
	 * 자재내역
	 * @param param 검색항목
	 * @return	
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  subReport(Map param) throws Exception {
		return  super.commonDao.list("pmp190skrvServiceImpl.subReport", param);
	}
}
