package foren.unilite.modules.z_kodi;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("s_pmr830skrv_kodiService")
public class S_pmr830skrv_kodiServiceImpl  extends TlabAbstractServiceImpl {

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  selectList1(Map param) throws Exception {
		return  super.commonDao.list("s_pmr830skrv_kodiServiceImpl.selectList1", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  selectList2(Map param) throws Exception {
		return  super.commonDao.list("s_pmr830skrv_kodiServiceImpl.selectList2", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  selectList3(Map param) throws Exception {
		return  super.commonDao.list("s_pmr830skrv_kodiServiceImpl.selectList3", param);
	}	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  selectList4(Map param) throws Exception {
		return  super.commonDao.list("s_pmr830skrv_kodiServiceImpl.selectList4", param);
	}		
	
	
	public List selectBadcodes(String comp_code) throws Exception {
		return (List)super.commonDao.list("s_pmr830skrv_kodiServiceImpl.selectBadcodes" ,comp_code);
	}
	
	public List selectBadcodeRemarks(String comp_code) throws Exception {
		return (List)super.commonDao.list("s_pmr830skrv_kodiServiceImpl.selectBadcodeRemarks" ,comp_code);
	}		

}
