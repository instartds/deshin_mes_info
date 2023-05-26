package foren.unilite.modules.matrl.mms;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("mms210skrvService")
public class Mms210skrvServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * 구매자재 검사결과서출력
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "mms")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {

		return  super.commonDao.list("mms210skrvServiceImpl.selectList", param);
	}

	/**
	 * 시험의뢰서_메인리포트
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  mainReport(Map param) throws Exception {
		return  super.commonDao.list("mms210skrvServiceImpl.mainReport", param);
	}

	/**
	 * 시험의뢰서_서브리포트
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  subReport(Map param) throws Exception {
		return  super.commonDao.list("mms210skrvServiceImpl.subReport", param);
	}


}
