package foren.unilite.modules.human.ham;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("ham200skrService")
public class Ham200skrServiceImpl extends TlabAbstractServiceImpl {
	/**
	 * 자료목록조회  
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "ham")
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		
		return (List) super.commonDao.list("ham200skrServiceImpl.selectList", param);
	}
}
