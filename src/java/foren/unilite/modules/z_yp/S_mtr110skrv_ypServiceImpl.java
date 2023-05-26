package foren.unilite.modules.z_yp;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("s_mtr110skrv_ypService")
public class S_mtr110skrv_ypServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 *
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {

		List<Map<String, Object>> selectList =  super.commonDao.list("s_mtr110skrv_ypServiceImpl.selectList", param);
		return  selectList;
	}

	/**
	 *
	 * userID에 따른 납품창고
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public Object  userWhcode(Map param) throws Exception {

		return  super.commonDao.select("s_mtr110skrv_ypServiceImpl.userWhcode", param);
	}
}
