package foren.unilite.modules.sales.srq;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("srq200rkrvService")
public class Srq200rkrvServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * 发货指示输出列表
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
	public List<Map<String, Object>>  selectReportList(Map param) throws Exception {
		return  super.commonDao.list("srq200rkrvServiceImpl.selectList", param);
	}
	
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectOrderNumMasterList(Map param) throws Exception {
		return super.commonDao.list("srq200rkrvServiceImpl.selectOrderNumMaster", param);
	}
	
	public List<Map<String, Object>>  clipselect(Map param) throws Exception {
		return  super.commonDao.list("srq200rkrvServiceImpl.clipselect", param); 
	}

	public List<Map<String, Object>>  clipselectsub(Map param) throws Exception {
		return  super.commonDao.list("srq200rkrvServiceImpl.clipselectsub", param); 
	}
	
}
