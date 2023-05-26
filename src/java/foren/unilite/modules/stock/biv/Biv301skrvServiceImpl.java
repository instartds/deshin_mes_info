package foren.unilite.modules.stock.biv;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.utils.UniliteUtil;
import foren.unilite.com.validator.UniDirectValidateException;

@Service("biv301skrvService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Biv301skrvServiceImpl  extends TlabAbstractServiceImpl {
	
	@ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)
	public Object  userWhcode(Map param) throws Exception {	
		return  super.commonDao.select("biv301skrvServiceImpl.userWhcode", param);
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "stock")
	public List<Map<String, Object>>  selectMaster(Map param) throws Exception {
		return  super.commonDao.list("biv301skrvServiceImpl.selectMasterList", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "stock")
	public List<Map<String, Object>>  selectMaster2(Map param) throws Exception {
		return  super.commonDao.list("biv301skrvServiceImpl.selectMasterList2", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "stock")
	public List<Map<String, Object>>  selectMaster3(Map param) throws Exception {
		return  super.commonDao.list("biv301skrvServiceImpl.selectMasterList3", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "stock")
	public List<Map<String, Object>> getgsWHGroupYN(Map param) throws Exception {
		return super.commonDao.list("biv301skrvServiceImpl.getgsWHGroupYN", param);
	}


	//20190715 추가: LOT별 현재고 현황
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "stock")
	public List<Map<String, Object>> detailDataList (Map param) throws Exception {
		return super.commonDao.list("biv301skrvServiceImpl.detailDataList", param);
	}
	
	//20210806추가: 출고예정량 더블클릭 시 팝업창
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "stock")
	public List<Map<String, Object>> selectIssuereqList (Map param) throws Exception {
		return super.commonDao.list("biv301skrvServiceImpl.selectIssuereqList", param);
	}
}
