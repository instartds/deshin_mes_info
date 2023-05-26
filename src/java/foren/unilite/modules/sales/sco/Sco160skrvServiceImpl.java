package foren.unilite.modules.sales.sco;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.BindingResult;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.extjs.UniliteExtjsUtils;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.com.fileman.FileMnagerService;
import foren.unilite.modules.sales.SalesCommonServiceImpl;

@Service("sco160skrvService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Sco160skrvServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * 미수금현황 조회 (sco160skrv): 그리드 조회전 컬럼목록 가져오는 로직
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sco")
	public List<Map<String, Object>>  getColumn(Map param) throws Exception {
		return super.commonDao.list("sco160skrvServiceImpl.getColumn", param);
	}

	/**
	 * 미수금현황 조회 (sco160skrv): 그리드 조회 목록
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sco")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
		return super.commonDao.list("sco160skrvServiceImpl.selectList", param);
	}
}
