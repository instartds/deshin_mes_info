package foren.unilite.modules.prodt.pms;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("pms410skrvService")
public class Pms410skrvServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * 생산 검사결과서출력
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {

		return  super.commonDao.list("pms410skrvServiceImpl.selectList", param);
	}

	/**
	 * 시험검사성적서_메인리포트
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  mainReport(Map param) throws Exception {
		return  super.commonDao.list("pms410skrvServiceImpl.mainReport", param);
	}

	/**
	 * 시험검사성적서_서브리포트
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  subReport(Map param) throws Exception {
		return  super.commonDao.list("pms410skrvServiceImpl.subReport", param);
	}

	/**
	 * 시험검사성적서_메인리포트_라벨
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  mainReport_label(Map param) throws Exception {
		return  super.commonDao.list("pms410skrvServiceImpl.mainReport_label", param);
	}
}
