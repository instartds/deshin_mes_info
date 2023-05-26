package foren.unilite.modules.matrl.mrp;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("mrp600skrvService")
public class Mrp600skrvServiceImpl  extends TlabAbstractServiceImpl {


	/**
	 * 매입처별 제품별 판매현황 그리드 조회 목록
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "mrt")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {	
		return  super.commonDao.list("mrp600skrvServiceImpl.selectList", param);

	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_LOAD, group = "base")        /*폼 조회*/
    public Object selectMaster(Map param) throws Exception {        
        
        return super.commonDao.select("mrp600skrvServiceImpl.selectMaster", param);
    }
	
}
