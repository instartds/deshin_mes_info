package foren.unilite.modules.prodt.pmp;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("pmp130rkrvService")
public class Pmp130rkrvServiceImpl  extends TlabAbstractServiceImpl {
	/**
	 * 작업지시내역
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  mainReport(Map param) throws Exception {
		return  super.commonDao.list("pmp130rkrvServiceImpl.mainReport", param);
	}
	
	/**
	 * 자재내역
	 * @param param 검색항목
	 * @return	
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  subReport(Map param) throws Exception {
		return  super.commonDao.list("pmp130rkrvServiceImpl.subReport", param);
	}
	/**
	 * @param param 검색항목
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "mrt")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
		return  super.commonDao.list("pmp130rkrvServiceImpl.selectList", param);
	}

	/**
	 * @param param 검색항목
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "mrt")
	public List<Map<String, Object>>  selectPrintListByWorkShopCode(Map param) throws Exception {
		return  super.commonDao.list("pmp130rkrvServiceImpl.selectPrintListByWorkShopCode", param);
	}
}
