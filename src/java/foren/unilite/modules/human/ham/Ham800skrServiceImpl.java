package foren.unilite.modules.human.ham;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import foren.framework.model.LoginVO;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("ham800skrService")
public class Ham800skrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	/**
	 * 지급 내역 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "ham")
	public List<Map<String, Object>> selectList1(Map param) throws Exception {
		return (List) super.commonDao.list("ham800skrServiceImpl.selectList1", param);
	}
	
	/**
	 * 공제 내역 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "ham")
	public List<Map<String, Object>> selectList2(Map param) throws Exception {
		return (List) super.commonDao.list("ham800skrServiceImpl.selectList2", param);
	}
	
	/**
	 * 사원 정보 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "ham")
	public List<Map<String, Object>> selectList3(Map param) throws Exception {
		return (List) super.commonDao.list("ham800skrServiceImpl.selectList3", param);
	}
	
	/**
	 * Navi button 사용가능 여부 확인
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> checkAvailableNavi(Map param) throws Exception {
		return (List) super.commonDao.list("ham800skrServiceImpl.checkAvailableNavi", param);
	}
	public List selectColumns(LoginVO loginVO) throws Exception {
		return (List) super.commonDao.list(
				"ham800ukrServiceImpl.selectColumns", loginVO.getCompCode());
	}
	public String fnEndAmtCalc(Map param) {
		String result = super.commonDao.queryForObject("hpa330ukrServiceImpl.fnEndAmtCalc", param).toString();
		return result;
	}

}
