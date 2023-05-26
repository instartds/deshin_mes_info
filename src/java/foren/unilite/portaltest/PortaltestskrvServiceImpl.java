package foren.unilite.portaltest;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("portaltestskrvService")
public class PortaltestskrvServiceImpl  extends TlabAbstractServiceImpl {


	/**
	 * 
	 * @param param 팀별 월매출현황
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "main")
	public List<Map<String, Object>>  selectList1(Map param) throws Exception {	
		return  super.commonDao.list("portaltestskrvServiceImpl.selectList1", param);
	}
	/**
	 * 
	 * @param param 대분류별 월매출현황
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "main")
	public List<Map<String, Object>>  selectList2(Map param) throws Exception {	
		return  super.commonDao.list("portaltestskrvServiceImpl.selectList2", param);
	}
	/**
	 * 
	 * @param param 부서별 일매출/월누계
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "main")
	public List<Map<String, Object>>  selectList3(Map param) throws Exception {	
		return  super.commonDao.list("portaltestskrvServiceImpl.selectList3", param);
	}
	/**
	 * 
	 * @param param TOP 10 매출 상품
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "main")
	public List<Map<String, Object>>  selectList4(Map param) throws Exception {	
		return  super.commonDao.list("portaltestskrvServiceImpl.selectList4", param);
	}
}
