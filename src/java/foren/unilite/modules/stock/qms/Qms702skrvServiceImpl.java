package foren.unilite.modules.stock.qms;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("qms702skrvService")
public class Qms702skrvServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * 구매자재 검사결과서출력
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "mms")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {

		return  super.commonDao.list("qms702skrvServiceImpl.selectList", param);
	}

	/**
	 * 코팅검사성적서
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  printList(Map param) throws Exception {
		return  super.commonDao.list("qms702skrvServiceImpl.printList", param);
	}

	/**
	 * 공정성적서
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  printListProgWork(Map param) throws Exception {
		return  super.commonDao.list("qms702skrvServiceImpl.printListProgWork", param);
	}

}
