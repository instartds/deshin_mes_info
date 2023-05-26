package foren.unilite.modules.z_mit;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("s_str340skrv_mitService")
@SuppressWarnings({ "unchecked", "rawtypes" })
public class S_str340skrv_mitServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * 월별반품현황  조회 쿼리 
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
		return  super.commonDao.list("s_str340skrv_mitServiceImpl.selectList", param); 
	}

	/**
	 * 출력(REPORT main data)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
	public List<Map<String, Object>> printMainData(Map param) throws Exception {
		return  super.commonDao.list("s_str340skrv_mitServiceImpl.printMainData", param);
	}

	/**
	 * 출력(REPORT detail list)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
	public List<Map<String, Object>> printSubReport(Map param) throws Exception {
		return  super.commonDao.list("s_str340skrv_mitServiceImpl.printSubReport", param);
	}

	/**
	 * 출력(REPORT detail list1)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
	public List<Map<String, Object>> printSubReport1(Map param) throws Exception {
		return  super.commonDao.list("s_str340skrv_mitServiceImpl.printSubReport1", param);
	}

	/**
	 * 출력(REPORT Chart list)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
	public List<Map<String, Object>> printChartReport(Map param) throws Exception {
		return  super.commonDao.list("s_str340skrv_mitServiceImpl.printChartReport", param);
	}
}
