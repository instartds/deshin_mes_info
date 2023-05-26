package foren.unilite.modules.matrl.map;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("map110skrvService")
public class Map110skrvServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 *
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {

		return  super.commonDao.list("map110skrvServiceImpl.selectList", param);
	}
	/**
	 * 외상매입현황출력쿼리
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectMainReportList(Map param) throws Exception {
		return super.commonDao.list("map110skrvServiceImpl.selectMainReportList", param);
	}//grid
}
