package foren.unilite.modules.accnt.afb;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("afb240skrService")
public class Afb240skrServiceImpl  extends TlabAbstractServiceImpl {
	
	/**
	 * 부서모델 생성
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "accnt")
	public List<Map<String, Object>>  getAllDeptList(Map param) throws Exception {	
		return  super.commonDao.list("afb240skrvServiceImpl.getAllDeptList", param);

	}
	
	/**
	 * 부서컬럼 생성
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "accnt")
	public List<Map<String, Object>>  getDeptList(Map param) throws Exception {	
		return  super.commonDao.list("afb240skrvServiceImpl.getDeptList", param);

	}

	/**
	 * 부서별예산실적조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "accnt")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {	
		return  super.commonDao.list("afb240skrvServiceImpl.selectList", param);

	}
	
	/**
	 * 부서명 가져오기
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "accnt")
	public List<Map<String, Object>>  dept(Map param) throws Exception {	
		return  super.commonDao.list("afb240skrvServiceImpl.dept", param);

	}
}
