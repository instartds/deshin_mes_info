package foren.unilite.modules.human.hpa;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("hpa700rkrService")
public class Hpa700rkrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	/**
	 * 연차지급조서출력  조회 / 부서별지급대장
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@Transactional(readOnly = true)
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hum")
	public List<Map<String, Object>> selectList1(Map param) throws Exception {
		return (List) super.commonDao.list("hpa700rkrServiceImpl.selectList1", param);
	}

	/**
	 * 연차지급조서출력  조회 / 부서별집계표
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@Transactional(readOnly = true)
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hum")
	public List<Map<String, Object>> selectList2(Map param) throws Exception {
		return (List) super.commonDao.list("hpa700rkrServiceImpl.selectList2", param);
	}

	/**
	 * 연차지급조서출력  조회 / 명세서
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@Transactional(readOnly = true)
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hum")
	public List<Map<String, Object>> selectList3(Map param) throws Exception {
		return (List) super.commonDao.list("hpa700rkrServiceImpl.selectList3", param);
	}

	/**
	 * 연차지급조서출력  조회 / 명세서
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@Transactional(readOnly = true)
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hum")
	public List<Map<String, Object>> selectList3_sub(Map param) throws Exception {
		return (List) super.commonDao.list("hpa700rkrServiceImpl.selectList3_sub", param);
	}
}
