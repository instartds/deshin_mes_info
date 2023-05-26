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

@Service("sco150skrvService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Sco150skrvServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * 거래처별잔액현황 (sco150skrv): master 그리드 조회 목록
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sco")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
		return  super.commonDao.list("sco150skrvServiceImpl.selectList", param);
	}

	/**
	 * 거래처별잔액현황 (sco150skrv): detail 그리드 조회 목록
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sco")
	public List<Map<String, Object>>  selectList2(Map param) throws Exception {
		return  super.commonDao.list("sco150skrvServiceImpl.selectList2", param);
	}
}
