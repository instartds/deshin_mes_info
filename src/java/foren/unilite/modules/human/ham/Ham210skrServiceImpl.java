package foren.unilite.modules.human.ham;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("ham210skrService")
public class Ham210skrServiceImpl extends TlabAbstractServiceImpl {
	/**
	 * 자료목록조회  
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "ham")
	public List<Map<String, Object>> selectList1(Map param) throws Exception {
		
		return (List) super.commonDao.list("ham210skrServiceImpl.selectList1", param);
	}
	
	@ExtDirectMethod(group = "ham")
	public List<Map<String, Object>> selectList2(Map param) throws Exception {
		
		return (List) super.commonDao.list("ham210skrServiceImpl.selectList2", param);
	}
}
