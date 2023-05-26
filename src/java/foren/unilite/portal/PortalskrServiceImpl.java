package foren.unilite.portal;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("portalskrService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class PortalskrServiceImpl  extends TlabAbstractServiceImpl {


	/**
	 * 
	 * @param param 공지사항 관련 
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "main")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {	
		return  super.commonDao.list("portalskrServiceImpl.selectList", param);
	}
	/**
	 * 수주금액
	 * @param param 
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "main")
	public List<Map<String, Object>>  SelectList1(Map param) throws Exception {	
		return  super.commonDao.list("portalskrServiceImpl.SelectList1", param);
	}
	
	/**
	 * 예상매출금액
	 * @param param 
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "main")
	public List<Map<String, Object>>  SelectList2(Map param) throws Exception {	
		return  super.commonDao.list("portalskrServiceImpl.SelectList2", param);
	}
	/**
	 * 매출금액
	 * @param param 
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "main")
	public List<Map<String, Object>>  SelectList3(Map param) throws Exception {	
		return  super.commonDao.list("portalskrServiceImpl.SelectList3", param);
	}
	
	/**
	 * 사업장별 생산현황
	 * @param param 
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "main")
	public List<Map<String, Object>>  SelectList4(Map param) throws Exception {	
		return  super.commonDao.list("portalskrServiceImpl.SelectList4", param);
	}
	
	/**
	 * 분류별 생산현황(김천사업장) , (화성사업장)
	 * @param param 
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "main")
	public List<Map<String, Object>>  SelectList5(Map param) throws Exception {	
		return  super.commonDao.list("portalskrServiceImpl.SelectList5", param);
	}
	/**
	 * DIV_NAME 불러오기
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "main")
	public List<Map<String, Object>>  getDivcode(Map param) throws Exception {	
		return  super.commonDao.list("portalskrServiceImpl.getDivcode", param);
	}
	/**
	 * kodi 수주금액
	 * @param param 
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "main")
	public List<Map<String, Object>>  kodiSelectList1(Map param) throws Exception {	
		return  super.commonDao.list("portalskrServiceImpl.kodiSelectList1", param);
	}
	
	/**
	 * kodi 예상매출금액
	 * @param param 
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "main")
	public List<Map<String, Object>>  kodiSelectList2(Map param) throws Exception {	
		return  super.commonDao.list("portalskrServiceImpl.kodiSelectList2", param);
	}
	/**
	 * kodi 매출금액
	 * @param param 
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "main")
	public List<Map<String, Object>>  kodiSelectList3(Map param) throws Exception {	
		return  super.commonDao.list("portalskrServiceImpl.kodiSelectList3", param);
	}
	
	/**
	 * kodi 사업장별 생산현황
	 * @param param 
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "main")
	public List<Map<String, Object>>  kodiSelectList4(Map param) throws Exception {	
		return  super.commonDao.list("portalskrServiceImpl.kodiSelectList4", param);
	}
	
	/**
	 * kodi 분류별 생산현황(김천사업장) , (화성사업장)
	 * @param param 
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "main")
	public List<Map<String, Object>>  kodiSelectList5(Map param) throws Exception {	
		return  super.commonDao.list("portalskrServiceImpl.kodiSelectList5", param);
	}
}