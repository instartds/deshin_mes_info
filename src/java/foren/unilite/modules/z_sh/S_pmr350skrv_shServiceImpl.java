package foren.unilite.modules.z_sh;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import foren.framework.model.LoginVO;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("s_pmr350skrv_shService")
@SuppressWarnings({"rawtypes", "unchecked"})
public class S_pmr350skrv_shServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * 컬럼 조회 (P003)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List selectColumns(LoginVO loginVO) throws Exception {
		return (List)super.commonDao.list("s_pmr350skrv_shServiceImpl.selectColumns" ,loginVO);
	}



	/**
	 * 
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
	
		return  super.commonDao.list("s_pmr350skrv_shServiceImpl.selectList", param);
	}
	
}
