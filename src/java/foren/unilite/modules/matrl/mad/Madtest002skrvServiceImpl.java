package foren.unilite.modules.matrl.mad;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("madtest002skrvService")
public class Madtest002skrvServiceImpl  extends TlabAbstractServiceImpl {


	/**
	 * 매장별 매출금액
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "mad")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {	
		return  super.commonDao.list("madtest002skrvServiceImpl.selectList", param);
		
	

	}
	/**
	 * 사업장별 매출금액
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "mad")
	public List<Map<String, Object>>  selectList2(Map param) throws Exception {	
		return  super.commonDao.list("madtest002skrvServiceImpl.selectList2", param);

	}
	
	/**
	 * 매장별 시간별 매출금액
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "mad")
	public List<Map<String, Object>>  selectList4(Map param) throws Exception {	
		

		List<Map<String, Object>> rList = this.selectList001(param);
		String str = "";
		ArrayList arrShopCodes = new ArrayList(); 
		   for(Map<String, Object> map: rList  ) {
			   arrShopCodes.add(map.get("SHOP_CODE"));
//			   str = str+"["+map.get("SHOP_CODE")+"]";
//			   
//		   int i;
//		if(i != rList.size()) str = ",";
//		   	i++;
		   }
		   param.put("SHOP_CODES", arrShopCodes);
		return  super.commonDao.list("madtest002skrvServiceImpl.selectList4", param);

	}
	
	/**
	 * 사업장별 월별 매출금액
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "mad")
	public List<Map<String, Object>>  selectList5(Map param) throws Exception {	
		return  super.commonDao.list("madtest002skrvServiceImpl.selectList5", param);

	}
	
	
	
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "mad")
	public List<Map<String, Object>>  selectList001(Map param) throws Exception {	
		return  super.commonDao.list("madtest002skrvServiceImpl.selectList001", param);

	}
}
