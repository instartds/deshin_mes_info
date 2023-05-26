package foren.unilite.modules.sales.srq;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("srq500rkrvService")
public class Srq500rkrvServiceImpl extends TlabAbstractServiceImpl {
	public final Logger logger = LoggerFactory.getLogger(this.getClass());

	/**
	 * 검사등록 -> 검사내역조회
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> checkMaxSeq(Map param) throws Exception {
		return super.commonDao.list("srq500rkrvServiceImpl.checkMaxSeq", param);
	}

	/**
	 * 검사등록 -> 검사내역조회
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectPrintList(Map param) throws Exception {
		return super.commonDao.list("srq500rkrvServiceImpl.selectPrintList", param);
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
	public Integer updateMaxSeq(Map param, LoginVO user) throws Exception {
		return super.commonDao.update("srq500rkrvServiceImpl.updateMaxSeq", param);
	}

}
