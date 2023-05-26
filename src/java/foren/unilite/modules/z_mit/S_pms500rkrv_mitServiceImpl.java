package foren.unilite.modules.z_mit;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("s_pms500rkrv_mitService")
public class S_pms500rkrv_mitServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * 조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_mit")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
	
		return  super.commonDao.list("s_pms500rkrv_mitServiceImpl.selectList", param);
	}
	
	/**
	 * 레포트A1,A2,A3
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_mit")
	public List<Map<String, Object>>  printList_A(Map param) throws Exception {
	
		return  super.commonDao.list("s_pms500rkrv_mitServiceImpl.printList_A", param);
	}
	/**
	 * 레포트B1,B2
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_mit")
	public List<Map<String, Object>>  printList_B(Map param) throws Exception {
	
		return  super.commonDao.list("s_pms500rkrv_mitServiceImpl.printList_B", param);
	}
}
