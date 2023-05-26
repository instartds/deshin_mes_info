package foren.unilite.modules.z_yp;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;


@Service("s_mpo131skrv_ypService")
@SuppressWarnings({"rawtypes", "unchecked"})
public class S_mpo131skrv_ypServiceImpl extends TlabAbstractServiceImpl {
	private final Logger	logger  = LoggerFactory.getLogger(this.getClass());
	
	/** 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "z_yp", value = ExtDirectMethodType.STORE_READ)	  // 조회
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return super.commonDao.list("s_mpo131skrv_ypServiceImpl.selectList", param);
	}
	
	
	
	/**
	 * 기준일자 입력 시, 주차 가져오는 로직
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "z_yp", value = ExtDirectMethodType.STORE_READ)
	public Object getCalNo(Map param) throws Exception {
		return super.commonDao.list("s_mpo131skrv_ypServiceImpl.getCalNo", param);
	}
	

	/**
	 * 주차 입력 시, 날짜 가져오는 로직
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "z_yp", value = ExtDirectMethodType.STORE_READ)
	public Object getCalDate(Map param) throws Exception {
		return super.commonDao.list("s_mpo131skrv_ypServiceImpl.getCalDate", param);
	}

}
