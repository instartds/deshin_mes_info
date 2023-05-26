package foren.unilite.modules.human.ham;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("ham950skrService")
@SuppressWarnings({ "unchecked", "rawtypes" })
public class Ham950skrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	/**
	 * 월별일용근로소득내역조회 (ham950skr) - 20210805 신규 등록
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "ham")
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return (List) super.commonDao.list("ham950skrServiceImpl.selectList", param);
	}
}