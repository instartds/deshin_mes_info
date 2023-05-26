package foren.unilite.modules.z_kodi;

import java.util.ArrayList;
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


@Service("s_hat510ukr_kodiService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class S_hat510ukr_kodiServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	/**
	 * 일근태현황조회  
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@Transactional(readOnly = true)
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hat")
	public List<Map<String, Object>> selectList(Map param) throws Exception {		
		List dutyCode = (List)super.commonDao.list("s_hat510ukr_kodiServiceImpl.selectDutycode1", param);		
		param.put("DUTY_CODE", dutyCode);		
		return (List) super.commonDao.list("s_hat510ukr_kodiServiceImpl.selectDataList", param);
	}
	
	/**
	 * 근태코드 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List selectDutycode(String comp_code) throws Exception {
		return (List)super.commonDao.list("s_hat510ukr_kodiServiceImpl.selectDutycode" ,comp_code);
	}
	
	/**
	 * 근태코드 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hat")
	public List selectDutycode2(Map param) throws Exception {
		return (List)super.commonDao.list("s_hat510ukr_kodiServiceImpl.selectDutycode1" ,param);
		
	}
	
	/**
	 * 근태코드 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List selectDate(String comp_code) throws Exception {
		return (List)super.commonDao.list("s_hat510ukr_kodiServiceImpl.selectDutycode" ,comp_code);
	}
	


	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hat")
	public List<Map<String, Object>> selectExcelUploadSheet(Map param) throws Exception {
		//List dutyCode = (List)super.commonDao.list("s_hat510ukr_kodiServiceImpl.selectDutycode1", param);		
		//param.put("DUTY_CODE", dutyCode);				
		return super.commonDao.list("s_hat510ukr_kodiServiceImpl.selectExcelUploadSheet", param);
	}
	
	/**
	 * 퇴직급여 엑셀업로드
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public void excelValidate(String jobID, Map param) throws Exception {
		logger.debug("validate: {}", jobID);
		//UPLOAD 전 데이터 존재여부 체크
		List<Map> getData = (List<Map>) super.commonDao.list("s_hat510ukr_kodiServiceImpl.getData", param);
		
		if(!getData.isEmpty()){
			//excel 파일의 데이터 체크
			for(Map data : getData )  { 
                param.put("ROWNUM", data.get("_EXCEL_ROWNUM"));
				param.put("COMP_CODE", data.get("COMP_CODE"));
			
			}
		}
	}
	
	/**저장**/
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "hat")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
	
		if(paramList != null)	{
			List<Map> insertList = null;

			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("insertDetail")) {		
					insertList = (List<Map>)dataListMap.get("data");
				} 
			}			
			if(insertList != null) this.insertDetail(insertList, user, dataMaster);
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hat")
	public void  insertDetail(List<Map> paramList, LoginVO user, Map dataMaster) throws Exception {
		super.commonDao.update("s_hat510ukr_kodiServiceImpl.deleteDetail", dataMaster);
	
		for(Map param : paramList )	{
			
			
			
			
			List<Map> dutyCode = (List<Map>)super.commonDao.list("s_hat510ukr_kodiServiceImpl.selectDutycode2", param);		
			param.put("DUTY_CODE", dutyCode);
			
			for(Map dutycodeMap : dutyCode){
				param.put("DUTY_YYYYMMDD", ObjUtils.getSafeString(param.get("DUTY_YYYYMM")) + ObjUtils.getSafeString(dutycodeMap.get("DATE_DAY")));
				param.put("DUTY_NUM_BASE", param.get("DUTY_NUM_BASE_" + ObjUtils.getSafeString(dutycodeMap.get("DATE_DAY"))));
				param.put("DUTY_CODE_NAME", param.get("DUTY_CODE_" + ObjUtils.getSafeString(dutycodeMap.get("DATE_DAY"))));
				param.put("DUTY_NUM_51", param.get("DUTY_NUM_51_" + ObjUtils.getSafeString(dutycodeMap.get("DATE_DAY"))));
				param.put("DUTY_NUM_52", param.get("DUTY_NUM_52_" + ObjUtils.getSafeString(dutycodeMap.get("DATE_DAY"))));
				param.put("DUTY_NUM_54", param.get("DUTY_NUM_54_" + ObjUtils.getSafeString(dutycodeMap.get("DATE_DAY"))));
				param.put("DUTY_NUM_56", param.get("DUTY_NUM_56_" + ObjUtils.getSafeString(dutycodeMap.get("DATE_DAY"))));
				
				super.commonDao.update("s_hat510ukr_kodiServiceImpl.insertDetail", param);
				
			}
			//DATE_DAY
			//, DUTY_YYYYMMDD : , #{DUTY_YYYYMM} + '${item.DATE_DAY}'
			//, DUTY_TIME : CONVERT(INT, #{DUTY_NUM_52_${item.DATE_DAY}})
			
			//51 : 
			
			
			}	
		
		return ;
	}		
	
	
}
