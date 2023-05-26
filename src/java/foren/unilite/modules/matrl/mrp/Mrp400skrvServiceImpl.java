package foren.unilite.modules.matrl.mrp;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("mrp400skrvService")
public class Mrp400skrvServiceImpl  extends TlabAbstractServiceImpl {


	/**
	 * 매입처별 제품별 판매현황 그리드 조회 목록
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "mrt")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {	
		return  super.commonDao.list("mrp400skrvServiceImpl.selectList", param);

	}
	
	/**
	 * 매입처별 제품별 판매현황 그리드 조회 목록
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "mrt")
	public List<Map<String, Object>>  selectList2(Map param) throws Exception {	
		return  super.commonDao.list("mrp400skrvServiceImpl.selectList2", param);
		
	}
	
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "mrt")
    public Object  selectMrpPopHead(Map param) throws Exception {  
        return  super.commonDao.select("mrp400skrvServiceImpl.selectMrpPopHead", param);
    }
    
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "mrt")
    public List<Map<String, Object>>  selectMrpPopList(Map param) throws Exception {  
    	return  super.commonDao.list("mrp400skrvServiceImpl.selectMrpPopList", param);
    }
}
