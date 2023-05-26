package foren.unilite.modules.accnt.agd;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("agd500ukrService")
public class Agd500ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	/**
	 * 법인카드사용내역등록 - 목록 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "Accnt")
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return (List) super.commonDao.list("agd500ukrServiceImpl.selectList", param);
	}

	/**
	 * 마스터데이터 저장
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "Accnt")
	public List<Map> saveMaster(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		if(paramList != null) {
			List<Map<String, Object>> deleteList = null;
			List<Map<String, Object>> updateList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteMaster")) {
					deleteList = (List<Map<String, Object>>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("updateMaster")) {
					updateList = (List<Map<String, Object>>)dataListMap.get("data");
				}
			}
			
			if(deleteList != null) {
				this.deleteMaster(deleteList);
			}
			if(updateList != null) {
				this.updateMaster(updateList);
			}
		}
		paramList.add(0, paramMaster);
				
		return paramList;
	}

	@ExtDirectMethod(group = "Accnt", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map<String, Object>> deleteMaster(List<Map<String, Object>> paramList) throws Exception {
		for(Map param : paramList) {
			super.commonDao.update("agd500ukrServiceImpl.deleteMaster", param);
		}
		return paramList;
	}
	
	@ExtDirectMethod(group = "Accnt", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map<String, Object>> updateMaster(List<Map<String, Object>> paramList) throws Exception {
		for(Map param : paramList) {
			super.commonDao.update("agd500ukrServiceImpl.updateMaster", param);
		}
		return paramList;		
	}

	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)		// 엑셀 업로드
    public List<Map<String, Object>> selectExcelUploadSheet1(Map param) throws Exception {
        return super.commonDao.list("agd500ukrServiceImpl.selectExcelUploadSheet1", param);
    }
    
    public void excelValidate(String jobID, Map param) {							// 엑셀 Validate
	    logger.debug("validate: {}", jobID);
		super.commonDao.update("agd500ukrServiceImpl.excelValidate", param);
	}

	@ExtDirectMethod(group = "accnt")
	public List<Map<String, Object>> fnApplyAll(Map param) throws Exception {
		return super.commonDao.list("agd500ukrServiceImpl.applyAll", param);
	}
	
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_MODIFY)
	public Map<String, Object> fnDeleteAll(Map param) throws Exception {
		super.commonDao.update("agd500ukrServiceImpl.deleteAll", param);
		return param;
	}

}
