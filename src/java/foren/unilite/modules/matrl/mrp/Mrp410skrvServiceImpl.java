package foren.unilite.modules.matrl.mrp;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("mrp410skrvService")
public class Mrp410skrvServiceImpl  extends TlabAbstractServiceImpl {

    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "matrl")      // 계획기간FR
    public List<Map<String, Object>>  planDateFrSet(Map param) throws Exception {  
        return  super.commonDao.list("mrp410skrvService.planDateFrSet", param);
    }	
	
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "matrl")		 // 1~20주까지 구하기
    public List<Map<String, Object>>  selectWeek(Map param) throws Exception {  
        return  super.commonDao.list("mrp410skrvService.selectWeek", param);

    }
    
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "matrl")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {	
		List<Map> sWeek = (List<Map>) super.commonDao.list("mrp410skrvService.selectWeek", param);
	    for(int i=0; i<sWeek.size(); i++){
            param.put("sWeek"+i, sWeek.get(i).get("CAL_NO"));
        }
		return  super.commonDao.list("mrp410skrvService.selectList", param);

	}	
	
}
