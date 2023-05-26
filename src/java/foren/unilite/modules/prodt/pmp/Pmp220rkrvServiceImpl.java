package foren.unilite.modules.prodt.pmp;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("pmp220rkrvService")
public class Pmp220rkrvServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * 
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "mrt")
	public List<Map<String, Object>>  printList(Map param) throws Exception {
		return  super.commonDao.list("pmp220rkrvServiceImpl.printList", param);
	}
	
	/**
	 * 
	 * @param param 검색항목
	 * @return	
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "mrt")
	public List<Map<String, Object>>  printList2(Map param) throws Exception {
		return  super.commonDao.list("pmp220rkrvServiceImpl.printList2", param);
	}
}
