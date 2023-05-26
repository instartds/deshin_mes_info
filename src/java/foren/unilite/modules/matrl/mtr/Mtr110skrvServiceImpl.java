package foren.unilite.modules.matrl.mtr;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("mtr110skrvService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Mtr110skrvServiceImpl extends TlabAbstractServiceImpl {

	/**
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		List<Map<String, Object>> selectList = super.commonDao.list("mtr110skrvServiceImpl.selectList", param);
		return selectList;
	}

	/**
	 * userID에 따른 납품창고 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public Object userWhcode(Map param) throws Exception {
		return super.commonDao.select("mtr110skrvServiceImpl.userWhcode", param);
	}



	/**
	 * 20200519 추가: 라벨출력 관련 데이터 조회로직 추가, 20200521 사용 안 함 -> 신규프로그램으로 대체 
	 * @param param
	 * @return
	 * @throws Exception
	 */
//	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
//	public List<Map<String, Object>> getPrintData(Map param) throws Exception {
//		return super.commonDao.list("mtr110skrvServiceImpl.getPrintData", param);
//	}
}