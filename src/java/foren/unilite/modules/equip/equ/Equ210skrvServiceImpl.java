package foren.unilite.modules.equip.equ;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;


@Service("equ210skrvService")
public class Equ210skrvServiceImpl  extends TlabAbstractServiceImpl {
	
	@ExtDirectMethod(group = "equit", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return (List<Map<String, Object>>)super.commonDao.list("equ210skrvServiceImpl.selectList", param);		
	}
	
	
}
