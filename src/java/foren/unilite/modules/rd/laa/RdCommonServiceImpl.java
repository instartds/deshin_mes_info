package foren.unilite.modules.rd.laa;

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


@Service("rdCommonService")
@SuppressWarnings({"unchecked", "rawtypes"})
public class RdCommonServiceImpl extends TlabAbstractServiceImpl {
	private final Logger	logger		= LoggerFactory.getLogger(this.getClass());


	/** 공통코드에서 규제내역 조회
	 */
	@ExtDirectMethod(group = "laa", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> regurationList(Map param) throws Exception {
		return super.commonDao.list("rdCommonServiceImpl.regurationList", param);
	}

}
