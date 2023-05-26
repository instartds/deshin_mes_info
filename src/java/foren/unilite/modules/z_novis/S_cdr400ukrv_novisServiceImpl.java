package foren.unilite.modules.z_novis;

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

@Service("s_cdr400ukrv_novisService")
@SuppressWarnings({ "unchecked", "rawtypes" })
public class S_cdr400ukrv_novisServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * 수주관리대장(노비스) (s_cdr400ukrv_novis) 조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "cost")
	public List<Map<String, Object>>  selectList (Map param) throws Exception {
		return super.commonDao.list("s_cdr400ukrv_novisServiceImpl.selectList", param);
	}

	
	@ExtDirectMethod(group = "cost", value = ExtDirectMethodType.FORM_LOAD)        // 저장전 데이터 체크
	public Object checkDetail(Map param) throws Exception {
		return super.commonDao.select("s_cdr400ukrv_novisServiceImpl.checkDetail", param);
	}
	
	
	@ExtDirectMethod(group = "cost", value = ExtDirectMethodType.STORE_READ)		// 엑셀 업로드
    public List<Map<String, Object>> selectExcelUploadSheet1(Map param) throws Exception {
        return super.commonDao.list("s_cdr400ukrv_novisServiceImpl.selectExcelUploadSheet1", param);
    }
    	
	
    public void excelValidate(String jobID, Map param) {							// 엑셀 Validate
		super.commonDao.update("s_cdr400ukrv_novisServiceImpl.excelValidate", param);		

	}	


	/**
	 * 수주관리대장(노비스) (s_cdr400ukrv_novis) 저장
	 * @param paramList
	 * @param paramMasterd
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");	

		if(paramList != null) {
			List<Map> insertDetail = null;
			List<Map> deleteDetail = null;
			
			
			super.commonDao.delete("s_cdr400ukrv_novisServiceImpl.deleteDetail", dataMaster);
			
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("insertDetail")) {
					insertDetail = (List<Map>)dataListMap.get("data");
				}
				if(dataListMap.get("method").equals("deleteDetail")) {
					deleteDetail = (List<Map>)dataListMap.get("data");
				}				
			}
			if(insertDetail != null) this.insertDetail(insertDetail, user, dataMaster);
			if(deleteDetail != null) this.deleteDetail(deleteDetail, user, dataMaster);
		}
		paramList.add(0, paramMaster);
		return  paramList;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
	public Integer insertDetail(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		for(Map param :paramList ) {
			param.put("DIV_CODE", paramMaster.get("DIV_CODE"));
			param.put("COST_YYYYMM", paramMaster.get("COST_YYYYMM"));
			super.commonDao.update("s_cdr400ukrv_novisServiceImpl.insertDetail", param);
		}
		return 0;
	} 
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
	public Integer deleteDetail(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		for(Map param :paramList ) {
			param.put("DIV_CODE", paramMaster.get("DIV_CODE"));
			param.put("COST_YYYYMM", paramMaster.get("COST_YYYYMM"));
			super.commonDao.update("s_cdr400ukrv_novisServiceImpl.deleteDetail", param);
		}
		return 0;
	} 	
	
}