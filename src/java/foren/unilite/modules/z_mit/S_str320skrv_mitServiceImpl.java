package foren.unilite.modules.z_mit;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("s_str320skrv_mitService")
@SuppressWarnings({ "unchecked", "rawtypes" })
public class S_str320skrv_mitServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * 반품현황 그리드1 조회 목록 
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
	public List<Map<String, Object>>  selectList1(Map param) throws Exception {
		return  super.commonDao.list("s_str320skrv_mitServiceImpl.selectList", param); 
	}

	/**
	 * 출력(REPORT main data) - 20200525 수정: printMainData 사용하지 않고 printList만 사용하도록 변경
	 * @param param
	 * @return
	 * @throws Exception
	 */
//	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
//	public List<Map<String, Object>> printMainData(Map param) throws Exception {
//		return  super.commonDao.list("s_str320skrv_mitServiceImpl.printMainData", param);
//	}

	/**
	 * 출력(REPORT detail list)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
	public List<Map<String, Object>> printList(Map param) throws Exception {
		return  super.commonDao.list("s_str320skrv_mitServiceImpl.printList", param);
	}
}
