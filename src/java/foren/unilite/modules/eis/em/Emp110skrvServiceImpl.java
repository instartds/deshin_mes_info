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

@Service( "emp110skrvService" )
public class Emp110skrvServiceImpl extends TlabAbstractServiceImpl {

	/**
	 * 자재예약현황 조회
	 *
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings( { "rawtypes", "unchecked" } )
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_BUFFERED, group = "eis" )		//STORE_READ  일때  page, start, limit 값 못가져옴..
	public Map<String, Object> selectList( Map param) throws Exception {

		Map<String, Object> rMap = new HashMap();
	        
        Map<String, Object> rTotal = new HashMap();
        List<Map<String, Object>> rList = new ArrayList();

        rList = (List)super.commonDao.list("emp110skrvServiceImpl.selectList", param);

        int total = 0;
        if (rList.size() > 0) {
            Map<String, Object> tmpMap = (Map<String, Object>)rList.get(0);
            total = ObjUtils.parseInt(tmpMap.get("TOTAL"));
        }
        rMap.put("data", rList);
        rMap.put("total", total);

        return rMap;
		
	}

}
