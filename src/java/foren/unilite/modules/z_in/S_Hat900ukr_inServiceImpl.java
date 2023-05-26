package foren.unilite.modules.z_in;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("s_hat900ukr_inService")
public class S_Hat900ukr_inServiceImpl extends TlabAbstractServiceImpl {

	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	/**
	 * 조회
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_in")
	public List<Map> selectList(Map param, LoginVO user) throws Exception {
		return super.commonDao.list("s_hat900ukr_inServiceImpl.selectList", param);
	}

	/**
     * 
     * 엑셀의 내용을 읽어옴
     * @param param
     * @return
     * @throws Exception
     */
	//UPLOAD 데이터 이관 전 월근태 데이터 삭제
	@ExtDirectMethod(group = "z_in", value = ExtDirectMethodType.STORE_MODIFY)
	public Map<String, Object> fnDeleteAll(Map param) throws Exception {
		super.commonDao.list("s_hat900ukr_inServiceImpl.deleteAll", param);
		return param;
	}

    public void excelValidate(String jobID, Map param) {
	    logger.debug("validate: {}", jobID);
		super.commonDao.update("s_hat900ukr_inServiceImpl.excelValidate", param);
	}
	
}
