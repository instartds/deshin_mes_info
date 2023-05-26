package foren.unilite.modules.z_in;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("s_mtr110skrv_inService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class S_mtr110skrv_inServiceImpl extends TlabAbstractServiceImpl {

	/**
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		List<Map<String, Object>> selectList = super.commonDao.list("s_mtr110skrv_inServiceImpl.selectList", param);
		return selectList;
	}

	/**
	 * 라벨출력 관련 데이터 조회로직 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> getPrintData(Map param) throws Exception {
		return super.commonDao.list("s_mtr110skrv_inServiceImpl.getPrintData", param);
	}
}