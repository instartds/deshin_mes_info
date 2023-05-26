package foren.unilite.modules.prodt.pmr;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import foren.framework.model.LoginVO;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("pmr350skrvService")
@SuppressWarnings({"rawtypes", "unchecked"})
public class Pmr350skrvServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * 컬럼 조회 (P003)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List selectColumns(LoginVO loginVO) throws Exception {
		return (List)super.commonDao.list("pmr350skrvServiceImpl.selectColumns" ,loginVO);
	}



	/**
	 * 
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
	
		return  super.commonDao.list("pmr350skrvServiceImpl.selectList", param);
	}
	
}
