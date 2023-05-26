package foren.unilite.modules.sales.str;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("str800skrvService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Str800skrvServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * 라벨출력시 사용할 데이터 관련
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectPrintList(Map param) throws Exception {
		return super.commonDao.list("str800ukrvServiceImpl.selectPrintList", param);
	}
	
	/**
	 * 라벨출력시 사용할 데이터 관련
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectPrintList2(Map param) throws Exception {
		return super.commonDao.list("str800skrvServiceImpl.selectPrintList2", param);
	}
	
	/**
	 * 
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
	
		return  super.commonDao.list("str800skrvServiceImpl.selectList", param);
	}
}
