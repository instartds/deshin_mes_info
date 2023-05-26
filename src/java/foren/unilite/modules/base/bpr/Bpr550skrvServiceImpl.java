package foren.unilite.modules.base.bpr;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("bpr550skrvService")
public class Bpr550skrvServiceImpl  extends TlabAbstractServiceImpl {
    
    /**
     * REF_ITEM 조회
     * @param param 검색항목
     * @return
     * @throws Exception
     */ 
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "bpr")
    public List<Map<String, Object>>  selectRefItem(Map param) throws Exception {
        return  super.commonDao.list("bpr550skrvServiceImpl.selectRefItem", param);
    }

	/**
	 * 집약정전개 조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "bpr")
	public List<Map<String, Object>>  selectList1(Map param) throws Exception {
		Map refItem = (Map) super.commonDao.queryForObject("bpr550skrvServiceImpl.selectRefItem", param);
		param.put("REF_ITEM", refItem.get("REF_ITEM"));
		return  super.commonDao.list("bpr550skrvServiceImpl.selectList1", param);
	}
	
	/**
     * 집약정전개 조회2
     * @param param 검색항목
     * @return
     * @throws Exception
     */ 
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "bpr")
    public List<Map<String, Object>>  selectList2(Map param) throws Exception {
        return  super.commonDao.list("bpr550skrvServiceImpl.selectList2", param);
    }
}
