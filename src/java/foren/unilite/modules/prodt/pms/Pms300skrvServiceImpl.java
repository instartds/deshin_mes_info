package foren.unilite.modules.prodt.pms;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("pms300skrvService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Pms300skrvServiceImpl extends TlabAbstractServiceImpl {

	/**
	 * "검사의뢰서출력", "라벨출력" 버튼설정 존재여부 확인 (P010) - 20210910
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public Object getReportSettingYn(Map param) throws Exception {
		return super.commonDao.select("pms300skrvServiceImpl.getReportSettingYn", param);
	}

	/**
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>> selectList1(Map param) throws Exception {
		return super.commonDao.list("pms300skrvServiceImpl.selectList1", param);
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>> selectList2(Map param) throws Exception {
		return super.commonDao.list("pms300skrvServiceImpl.selectList2", param);
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>> selectList3(Map param) throws Exception {
		return super.commonDao.list("pms300skrvServiceImpl.selectList3", param);
	}

	/**
	 * 접수및검사현황조회(검사의뢰서)_메인리포트
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>> mainReport(Map param) throws Exception {
		return super.commonDao.list("pms300skrvServiceImpl.mainReport", param);
	}

	/**
	 * 접수및검사현황조회(검사의뢰서)_메인리포트
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>> mainReport_2(Map param) throws Exception {
		return super.commonDao.list("pms300skrvServiceImpl.mainReport_2", param);
	}

	/**
	 * 접수및검사현황조회(검사의뢰서)_메인리포트
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>> mainReport_3(Map param) throws Exception {
		return super.commonDao.list("pms300skrvServiceImpl.mainReport_3", param);
	}
	/**
	 * 접수및검사현황조회(검사의뢰서)_서브리포트
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>> subReport(Map param) throws Exception {
		return super.commonDao.list("pms300skrvServiceImpl.subReport", param);
	}



	/**
	 * 접수및검사현황조회(검사의뢰서)_라벨
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>> mainReport_label(Map param) throws Exception {
		return super.commonDao.list("pms300skrvServiceImpl.mainReport_label", param);
	}

	/**
	 * 접수및검사현황조회(검사의뢰서)_라벨
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>> mainReport_label_2(Map param) throws Exception {
		return super.commonDao.list("pms300skrvServiceImpl.mainReport_label_2", param);
	}

	/**
	 * 접수및검사현황조회(검사의뢰서)_라벨
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>> mainReport_label_3(Map param) throws Exception {
		return super.commonDao.list("pms300skrvServiceImpl.mainReport_label_3", param);
	}
}