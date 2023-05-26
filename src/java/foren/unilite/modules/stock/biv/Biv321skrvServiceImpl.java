package foren.unilite.modules.stock.biv;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.exolab.castor.mapping.xml.Param;
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
import foren.unilite.modules.base.bdc.Bdc100ukrvService;
import foren.unilite.modules.com.fileman.FileMnagerService;


@Service("biv321skrvService")
@SuppressWarnings({ "unchecked", "rawtypes" })
public class Biv321skrvServiceImpl  extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "stock")
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return super.commonDao.list("biv321skrvServiceImpl.selectList", param);
	}

	/**
	 * 사업장 정보의 재고평가기간 설정 가져오는 로직 추가 - 20200427 추가
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "stock")
	public List<Map<String, Object>> getYearEvaluation(Map param) throws Exception {
		return super.commonDao.list("biv321skrvServiceImpl.getYearEvaluation", param);
	}

	/**
	 * 사업장 정보의 재고평가기간 값 가져오는 로직 추가 - 20200427 추가, 20200429 주석
	 * @param param
	 * @return
	 * @throws Exception
	 */
/*	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "stock")
	public String getLastYYYYMM(Map param) throws Exception {
		return (String) super.commonDao.select("biv321skrvServiceImpl.getLastYYYYMM", param);
	}*/
}