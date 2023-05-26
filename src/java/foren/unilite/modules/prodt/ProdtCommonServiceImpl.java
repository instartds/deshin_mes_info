package foren.unilite.modules.prodt;

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


@Service("prodtCommonService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class ProdtCommonServiceImpl extends TlabAbstractServiceImpl {
	
	private final Logger	logger		= LoggerFactory.getLogger(this.getClass());
	
	/**
	 * 생산 레포트 파일 존재여부 관련
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>>  checkReportInfo(Map param) throws Exception {	

		return  super.commonDao.list("prodtCommonServiceImpl.checkReportInfo", param);
	}



	/**
	 * comp_name 가져오는 쿼리 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_READ)
	public String getCompName(Map param) throws Exception {
		return (String) super.commonDao.select("prodtCommonServiceImpl.getCompName", param);
	}
	
	/**
	 * 주차 관련 (몇주차)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public Object  getCalNo(Map param) throws Exception {
		return  super.commonDao.select("prodtCommonServiceImpl.getCalNo", param);
	}
}
