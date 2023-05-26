package foren.unilite.modules.sales.sat;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("sat200skrvService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Sat200skrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Transactional(readOnly = true)
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
	public  List<Map<String, Object>> selectMaster(Map param, LoginVO loginVO) throws Exception {		
		return  super.commonDao.list("sat200skrvServiceImpl.selectMaster", param);
	}
	
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return super.commonDao.list("sat200skrvServiceImpl.selectList", param);
	}
	
	// CLIP 출력물 : 신청서  Master
	public List<Map<String, Object>> selectPrintList1Master(Map param) throws Exception {
		return super.commonDao.list("sat200skrvServiceImpl.selectPrintList1Master", param);
	}
	
	// CLIP 출력물 : 신청서  Detail
	public List<Map<String, Object>> selectPrintList1Detail(Map param) throws Exception {
		return super.commonDao.list("sat200skrvServiceImpl.selectPrintList1Detail", param);
	}
	
}
