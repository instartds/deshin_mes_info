package foren.unilite.modules.z_mit;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;

@Service("s_out210ukrv_mitService") 
@SuppressWarnings({ "unchecked", "rawtypes" })
public class S_out210ukrv_mitServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * 조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_mit")
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return   super.commonDao.list("s_out210ukrv_mitServiceImpl.selectList", param);
	}
	
	

	/**
	 * 생산집계
	 * @param paramList
	 * @param user
	 * @param paramMaster
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_mit")
	public Map excuteProduceCost(Map paramMaster , LoginVO user) throws Exception {
		super.commonDao.queryForObject("s_out210ukrv_mitServiceImpl.excuteProduceCost", paramMaster);
		return paramMaster;
	}

	@ExtDirectMethod(group = "z_mit")
	public void excelValidate(String jobID, Map param) {
		super.commonDao.update("s_out210ukrv_mitServiceImpl.excelValidate", param);
	}
	
	@ExtDirectMethod(group = "z_mit", value = ExtDirectMethodType.STORE_READ)
    public List<Map> selectExcelUploadSheet1(Map param) throws Exception {
    	Map<String, Object> paramMap = new HashMap();
    	List<Map> excelUploadMapList = super.commonDao.list("s_out210ukrv_mitServiceImpl.selectExcelUploadSheet1", param);

        return excelUploadMapList;
    }
	
	@ExtDirectMethod(group = "z_mit", value = ExtDirectMethodType.STORE_READ)
    public List<Map> selectExcelUpdatedList(Map param) throws Exception {
		return  super.commonDao.list("s_out210ukrv_mitServiceImpl.selectExcelUploadSheet2", param);
    }
}
