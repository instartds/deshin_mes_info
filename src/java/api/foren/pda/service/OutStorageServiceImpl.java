package api.foren.pda.service;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.ObjectUtils;
import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.exception.UniDirectException;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;

@Service("outStorageService")
public class OutStorageServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	


	

	/**
	 * 
	 */
	public List<Map<String, Object>> selectOutRequestList(Map param) throws Exception {
		return super.commonDao.list("outStorageServiceImpl.selectPmp300List", param);
	}
/*	public List<Map<String, Object>> selectOutRequestList(Map param) throws Exception {
		return super.commonDao.list("outStorageServiceImpl.selectPmp100List", param);
	}*/
	public List<Map<String, Object>> selectOutInstructList(Map param) {
		// TODO Auto-generated method stub
		return super.commonDao.list("outStorageServiceImpl.selectSrq100", param);
	}
	
	public List<Map<String, Object>> selectOutStorageDetailList(Map param) {
		return super.commonDao.list("outStorageServiceImpl.selectOutStorageDetailList", param);
	}
	public List<Map<String, Object>> selectOutInstructDetailList(Map param) {
		if("YG".equals(param.get("TYPE"))){
			return super.commonDao.list("outStorageServiceImpl.selectOutInstructDetailList_yg", param);
		}else if("YG_ITEM".equals(param.get("TYPE"))){
			return super.commonDao.list("outStorageServiceImpl.selectOutInstructItem_yg1", param);
		}else {
			return super.commonDao.list("outStorageServiceImpl.selectOutInstructDetailList", param);
		}
		
	}
	
	

	
}
