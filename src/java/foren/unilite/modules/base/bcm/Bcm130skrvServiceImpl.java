package foren.unilite.modules.base.bcm;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("bcm130skrvService")
public class Bcm130skrvServiceImpl  extends TlabAbstractServiceImpl {


	/**
	 * 변경이력 마스터 그리드 조회 
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "matrl")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {	
		return  super.commonDao.list("bcm130skrvServiceImpl.selectList", param);

	}
	
	/**
	 * 변경이력 우측폼  조회
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
	public Object getChangeHistory(Map param, LoginVO user) throws Exception {
		return  super.commonDao.list("bcm130skrvServiceImpl.getChangeHistory", param);
	}	
}
