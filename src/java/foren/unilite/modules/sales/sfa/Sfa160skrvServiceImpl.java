package foren.unilite.modules.sales.sfa;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("sfa160skrvService")
public class Sfa160skrvServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * 거래처 원장 그리드 조회 목록
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sof")
	public List<Map<String, Object>>  selectList1(Map param) throws Exception {		

		return  super.commonDao.list("sfa160skrvServiceImpl.selectList1", param);
	}	
	
	/**
     * 거래처 원장 그리드 조회 목록2
     * @param param 검색항목
     * @return
     * @throws Exception
     */ 
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sof")
    public List<Map<String, Object>>  selectList2(Map param) throws Exception {     

        return  super.commonDao.list("sfa160skrvServiceImpl.selectList2", param);
    }   
}
