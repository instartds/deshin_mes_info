package foren.unilite.modules.eis.em;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectStoreReadRequest;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service( "emi110skrvService" )
public class Emi110skrvServiceImpl extends TlabAbstractServiceImpl {

	/**
	 * 제품창고모니터링
	 *
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */

    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "eis")       
    public List<Map<String, Object>>  selectList(Map param) throws Exception {    
        
        return super.commonDao.list("emi110skrvServiceImpl.selectList", param);
        
    }

}
