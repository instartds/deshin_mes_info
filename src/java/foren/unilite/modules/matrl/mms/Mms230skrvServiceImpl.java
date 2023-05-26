package foren.unilite.modules.matrl.mms;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("mms230skrvService")
@SuppressWarnings({ "unchecked", "rawtypes" })
public class Mms230skrvServiceImpl extends TlabAbstractServiceImpl {

	/**
	 * 수입검사현황II (mms230skrv)
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "mms")
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return super.commonDao.list("mms230skrvServiceImpl.selectList", param);
	}


	/**
	 * 검사방식(Q005) 컬럼 가져오는 로직 추가
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "mms")
	public List<Map<String, Object>> selectQ005(LoginVO loginVO) throws Exception {
		return super.commonDao.list("mms230skrvServiceImpl.selectQ005", loginVO);
	}

	/**
	 * 불량코드(수입검사)(Q014) 컬럼 가져오는 로직 추가
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "mms")
	public List<Map<String, Object>> selectQ014(LoginVO loginVO) throws Exception {
		return super.commonDao.list("mms230skrvServiceImpl.selectQ014", loginVO);
	}
}