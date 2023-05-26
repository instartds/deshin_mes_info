package foren.unilite.modules.human.hpb;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;



@Service("hpb510skrService")
public class Hpb510skrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	/**
	 * 조회 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hpb", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList1(Map param) throws Exception {
		
		return (List) super.commonDao.list("hpb510skrvServiceImpl.selectBizAtypeList", param);
	}
	
	@ExtDirectMethod(group = "hpb", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList2(Map param) throws Exception {
		
		return (List) super.commonDao.list("hpb510skrvServiceImpl.selectBizBtypeList", param);
	}
	
	@ExtDirectMethod(group = "hpb", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList3(Map param) throws Exception {
		
		return (List) super.commonDao.list("hpb510skrvServiceImpl.selectBizCtypeList", param);
	} 
	
	@ExtDirectMethod(group = "hpb", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectListIntr1(Map param) throws Exception {
		
		return (List) super.commonDao.list("hpb510skrvServiceImpl.selectIntrAtypeList", param);
	}
	
	@ExtDirectMethod(group = "hpb", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectListIntr2(Map param) throws Exception {
		
		return (List) super.commonDao.list("hpb510skrvServiceImpl.selectIntrBtypeList", param);
	}
	
	@ExtDirectMethod(group = "hpb", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectListIntr3(Map param) throws Exception {
		
		return (List) super.commonDao.list("hpb510skrvServiceImpl.selectIntrCtypeList", param);
	} 
}
