package foren.unilite.modules.base.bpr;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("bpr300rkrvService")
public class Bpr300rkrvServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * 라벨출력시 사용할 데이터 관련
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "base", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectPrintList(Map param) throws Exception {
		return super.commonDao.list("str800ukrvServiceImpl.selectPrintList", param);
	}
	/**
	 * 
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "base")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
	
		return  super.commonDao.list("bpr300rkrvServiceImpl.selectList", param);
	}
	
	/**
	 * 라벨출력시 사용할 데이터 관련
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "base", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectClipPrintList(Map param) throws Exception {
		System.out.println("[param1]" + param);
		return super.commonDao.list("bpr300rkrvServiceImpl.selectClipPrintList", param);
	}
}
