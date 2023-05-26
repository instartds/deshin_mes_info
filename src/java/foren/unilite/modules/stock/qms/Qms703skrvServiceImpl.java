package foren.unilite.modules.stock.qms;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("qms703skrvService")
public class Qms703skrvServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * 구매자재 검사결과서출력
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "mms")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {

		return  super.commonDao.list("qms703skrvServiceImpl.selectList", param);
	}



}
