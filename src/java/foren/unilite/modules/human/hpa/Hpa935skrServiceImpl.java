package foren.unilite.modules.human.hpa;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("hpa935skrService")
public class Hpa935skrServiceImpl extends TlabAbstractServiceImpl {
	/**
	 * 급여이체리스트 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hpa")
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		
		return (List) super.commonDao.list("hpa935skrServiceImpl.selectList", param);
	}
}
