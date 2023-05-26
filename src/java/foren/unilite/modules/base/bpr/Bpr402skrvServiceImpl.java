package foren.unilite.modules.base.bpr;

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

@Service("bpr402skrvService")
public class Bpr402skrvServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * 판매단가/고객품목 그리드1 조회 목록
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "base")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
		
		return  super.commonDao.list("bpr402skrvServiceImpl.selectList", param);
	}

	/**
	 * 판매단가/고객품목 그리드2 조회 목록
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "base")
	public List<Map<String, Object>>  selectList2(Map param) throws Exception {
		
		return  super.commonDao.list("bpr402skrvServiceImpl.selectList2", param);
	}
	

	
}
