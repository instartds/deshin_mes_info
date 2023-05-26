package foren.unilite.modules.matrl.mms;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("mms220skrvService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Mms220skrvServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * 미검사현황 조회 - 조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "mms")
	public List<Map<String, Object>> selectList (Map param) throws Exception {
		return  super.commonDao.list("mms220skrvServiceImpl.selectList", param);
	}
}
