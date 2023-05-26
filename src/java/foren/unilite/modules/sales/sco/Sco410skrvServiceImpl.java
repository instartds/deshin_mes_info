package foren.unilite.modules.sales.sco;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("sco410skrvService")
public class Sco410skrvServiceImpl  extends TlabAbstractServiceImpl {


	/**
	 * 거래원장상세조회 목록
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {	
		return  super.commonDao.list("sco410skrvServiceImpl.selectList", param);

	}
	
}
