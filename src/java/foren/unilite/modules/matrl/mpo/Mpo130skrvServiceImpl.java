package foren.unilite.modules.matrl.mpo;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("mpo130skrvService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Mpo130skrvServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * 발주현황
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "mpo")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
		
		return  super.commonDao.list("mpo130skrvServiceImpl.selectList", param);
	}

	private int parseInt(String text) {
		// TODO Auto-generated method stub
		return 0;
	}

	/**
	 * 
	 * userID에 따른 납품창고 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public Object  userWhcode(Map param) throws Exception {	
		
		return  super.commonDao.select("mpo130skrvServiceImpl.userWhcode", param);
	}


	/**
	 * LINK PG 정보 가져오기
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "mpo")
	public List<Map<String, Object>> getLinkList(Map param) throws Exception {
		
		return  super.commonDao.list("mpo130skrvServiceImpl.getLinkList", param);
	}

}
