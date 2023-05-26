package foren.unilite.modules.prodt.pmp;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("pmp285skrvService")
@SuppressWarnings({ "rawtypes", "unchecked" }) // 노란줄 경고 무시
public class Pmp285skrvServiceImpl  extends TlabAbstractServiceImpl {

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
		return super.commonDao.list("pmp285skrvServiceImpl.selectList", param);
	}
}