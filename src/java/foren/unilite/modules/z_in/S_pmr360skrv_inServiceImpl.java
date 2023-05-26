package foren.unilite.modules.z_in;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("s_pmr360skrv_inService")
@SuppressWarnings({"rawtypes", "unchecked"})
public class S_pmr360skrv_inServiceImpl extends TlabAbstractServiceImpl {

	/**
	 * 컬럼 조회 (P003)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List selectColumns(Map<String, Object> param) throws Exception {
		return (List)super.commonDao.list("s_pmr360skrv_inServiceImpl.selectColumns", param);
	}

	/**
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_in")
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return  super.commonDao.list("s_pmr360skrv_inServiceImpl.selectList", param);
	}

	/**
	 * 팝업SELET
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_in")
	public List<Map<String, Object>> selectPop1List(Map param) throws Exception {
		return  super.commonDao.list("s_pmr360skrv_inServiceImpl.selectPop1List", param);
	}
}