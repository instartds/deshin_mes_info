package foren.unilite.modules.accnt.agj;

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
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;

@Service("agj130ukrService")
public class AGJ130ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	/**
	 * 결의전표업로드  - 목록 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "accnt")
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return super.commonDao.list("agj130ukrServiceImpl.selectList", param);
	}
	
	/**
	 * 결의전표업로드  - 엑셀업로드
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public void insertExcelAgj110T_XLS(List<Map> paramList) throws Exception {
		for(Map param :paramList )	{
			super.commonDao.list("agj130ukrServiceImpl.insertExcelAgj110T_XLS", param);
		}
		return;
	}
	
	
	
	/**
	 * 결의전표업로드  - 전체저장
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>)paramMaster.get("data");
		
		if (paramList != null) {
			List<Map> insertExcelAgj110T_XLS = null;
			List<Map> updateDetail = null;
			List<Map> deleteDetail = null;
			
			for (Map dataListMap : paramList) {
				if (dataListMap.get("method").equals("insertExcelAgj110T_XLS")) {
					insertExcelAgj110T_XLS = (List<Map>)dataListMap.get("data");
				} else if (dataListMap.get("method").equals("updateDetail")) {
					updateDetail = (List<Map>)dataListMap.get("data");
				} else if (dataListMap.get("method").equals("deleteDetail")) {
					deleteDetail = (List<Map>)dataListMap.get("data");
				}
			}
			if(insertExcelAgj110T_XLS != null) this.insertExcelAgj110T_XLS(insertExcelAgj110T_XLS);
			if(updateDetail != null) this.updateDetail(updateDetail);
			if(deleteDetail != null) this.deleteDetail(deleteDetail);
		}
		paramList.add(0, paramMaster);
		
		return paramList;
	}
	
	/**
	 * 결의전표업로드  - 삭제
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public void deleteDetail(List<Map> paramList) throws Exception {
		for(Map param : paramList ){
			super.commonDao.update("agj130ukrServiceImpl.deleteDetail", param);
		}
		return;
	}

	/**
	 * 결의전표업로드  - excelValidate
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public void excelValidate(String jobID, Map param) throws Exception {
		//logger.debug("validate: {}", jobID);
		param.put("_EXCEL_JOBID", jobID);
		super.commonDao.update("agj130ukrServiceImpl.updateError", param);
		
	}
	
	
	/**
	 * 결의전표업로드  - 실 테이블에 insert
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public void insertList(List<Map> paramList) throws Exception {
		for(Map param : paramList ) {
			super.commonDao.update("agj130ukrServiceImpl.insertList", param);
		}
		return;
	}
	
	
	/**
	 * 결의전표업로드  - 수정
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public void updateDetail(List<Map> paramList) throws Exception {
		for(Map param : paramList ) {
			super.commonDao.update("agj130ukrServiceImpl.updateDetail", param);
		}
		return;
	}
	
	
	
	/**
	 * 결의전표업로드  - 전체삭제
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public void deleteAll(Map param) throws Exception {
		super.commonDao.update("agj130ukrServiceImpl.deleteAll", param);
	}

	
}
