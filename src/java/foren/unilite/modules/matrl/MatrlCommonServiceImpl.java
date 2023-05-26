package foren.unilite.modules.matrl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.TransactionDefinition;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;


@Service("matrlCommonService")
@SuppressWarnings("rawtypes")
public class MatrlCommonServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	/**
	 * 현재고량 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@Transactional(readOnly=true) //, isolation=TransactionDefinition.ISOLATION_READ_UNCOMMITTED)
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public Object fnStockQ(Map param) throws Exception {	
		return super.commonDao.select("matrlCommonServiceImpl.fnStockQ", param);
	}

	/**
	 * 현재고량 조회_극동(사이트)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@Transactional(readOnly=true) //, isolation=TransactionDefinition.ISOLATION_READ_UNCOMMITTED)
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public Object fnStockQ_kd(Map param) throws Exception {
		return super.commonDao.select("matrlCommonServiceImpl.fnStockQ_kd", param);
	}


	/**
	 * 창고변경 시, 창고에 설정되어 있는 기본창고cell 가져오는 로직 추가: 20201113 추가
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public Object getWhCellCode(Map param) throws Exception {
		return super.commonDao.select("matrlCommonServiceImpl.getWhCellCode", param);
	}
}