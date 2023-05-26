package foren.unilite.modules.base.bpr;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.lib.tree.GenericTreeDataMap;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("bpr530skrvService")
public class Bpr530skrvServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * 집약정전개 조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "bpr")
	public List<Map<String, Object>>  selectList1(Map<String, Object> param) throws Exception {
		Map map = (Map) super.commonDao.select("bpr530skrvServiceImpl.selectList1", param);
		param.put("ITEM_CODE", map.get("ITEM_CODE"));
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		selectList2(param,list);
		return  list;
	}
	
	/**
     * 집약정전개 조회2
     * @param param 검색항목
	 * @param list 
     * @return
     * @throws Exception
     */ 
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "bpr")
    public List<Map<String, Object>>  selectList2(Map<String, Object> param, List<Map<String, Object>> list) throws Exception {
    	List<Map<String, Object>> tempList = super.commonDao.list("bpr530skrvServiceImpl.selectList2", param);
    	if(tempList != null && tempList.size()>0){
			for(Map<String, Object> map : tempList){
				list.add(map);
				param.put("ITEM_CODE", map.get("ITEM_CODE"));
				selectList2(param,list);
			}
		}
        return  list;
    }
}
