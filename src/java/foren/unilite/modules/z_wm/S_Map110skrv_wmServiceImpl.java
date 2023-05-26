package foren.unilite.modules.z_wm;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("s_map110skrv_wmService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class S_Map110skrv_wmServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
		return  super.commonDao.list("s_map110skrv_wmServiceImpl.selectList", param);
	}

	/**
	 * 외상매입현황출력쿼리
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectMainReportList(Map param) throws Exception {
		return super.commonDao.list("s_map110skrv_wmServiceImpl.selectMainReportList", param);
	}

	/**
	 * 계좌이체리스트 조회 쿼리 - 20210304 추가
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList2(Map param) throws Exception {
		return super.commonDao.list("s_map110skrv_wmServiceImpl.selectList2", param);
	}
}