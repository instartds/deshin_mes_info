package foren.unilite.modules.z_yp;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

import org.slf4j.Logger;

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

@Service("s_hpa350ukr_ypService")
public class S_hpa350ukr_ypServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	/**
	 * 컬럼 조회
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List selectColumns(LoginVO loginVO) throws Exception {
		return (List) super.commonDao.list(
				"s_hpa350ukr_ypServiceImpl.selectColumns", loginVO.getCompCode());
	}

	/**
	 * 급여내역일괄조정 데이터 조회
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@Transactional(readOnly = true)
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hpa")
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return (List) super.commonDao.list("s_hpa350ukr_ypServiceImpl.selectList", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "hpa")
	 @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class}) 
	 public List<Map> saveAll(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
		 
		 Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		 if(paramList != null)	{
				List<Map> deleteList = null;
				List<Map> updateList = null;
				for(Map dataListMap: paramList) {
					if(dataListMap.get("method").equals("deleteList")) {
						deleteList = (List<Map>)dataListMap.get("data");
					} else if(dataListMap.get("method").equals("updateList")) {
						updateList = (List<Map>)dataListMap.get("data");	
					} 
				}			
				if(deleteList != null) this.deleteList(deleteList, dataMaster, user);
				if(updateList != null) this.updateList(updateList, dataMaster, user);				
			}
		 	paramList.add(0, paramMaster);
				
		 	return  paramList;
	}

	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_MODIFY, needsModificatinAuth = true)		// DELETE
	public Integer deleteList(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
		 for(Map param :paramList )	{	
			param.put("S_COMP_CODE"	, paramMaster.get("S_COMP_CODE"));
			param.put("PAY_YYYYMM"	, paramMaster.get("PAY_YYYYMM"));
			param.put("SUPP_TYPE"	, paramMaster.get("SUPP_TYPE"));
     		
			param.put("CALC_TAX_YN"	, paramMaster.get("CALC_TAX_YN"));
			param.put("CALC_HIR_YN"	, paramMaster.get("CALC_HIR_YN"));
     		param.put("CALC_IND_YN"	, paramMaster.get("CALC_IND_YN"));
     		
     		param.put("DELETE_YN", "Y");
	     		
     		Map ErrMap = (Map) super.commonDao.queryForObject("s_hpa350ukr_ypServiceImpl.payroll", param);
    		
    		String errorDesc = ObjUtils.getSafeString(ErrMap.get("ErrorDesc"));
    		if(!"".equals(errorDesc))	{
    			throw new  UniDirectValidateException(errorDesc);
    		}
		 }
		 return 0;
	} 

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hpa")
	public List<Map> updateList(List<Map> paramList, Map master, LoginVO user) throws Exception {
		Map compCodeMap = new HashMap();
		compCodeMap.put("S_COMP_CODE", user.getCompCode());
		List<Map> chkList = (List<Map>) super.commonDao.list("s_hpa350ukr_ypServiceImpl.checkCompCode", compCodeMap);
		for (Map<String, Object> param : paramList) {
				Map<String, Object> updateData = new HashMap();
				updateData.put("S_COMP_CODE", user.getCompCode());
				updateData.put("PAY_YYYYMM", param.get("PAY_YYYYMM"));
				updateData.put("SUPP_TYPE", master.get("SUPP_TYPE"));
				updateData.put("PERSON_NUMB", param.get("PERSON_NUMB"));
				
				updateData.put("BUSI_SHARE_I", param.get("BUSI_SHARE_I"));
				updateData.put("ANU_BASE_I2", param.get("ANU_BASE_I2"));
				updateData.put("MED_I2", param.get("MED_I2"));
				updateData.put("MED_I2", param.get("WORKER_COMPEN_I"));
				updateData.put("MED_I2", param.get("OLD_MED_COMPEN_I"));
				
		             
	     		for(Map.Entry<String, Object> entry : param.entrySet()) {
	     			if(entry.getKey().indexOf("WAGES_PAY") > -1)	{
	     				updateData.put("WAGES_CODE", entry.getKey().replaceAll("WAGES_PAY", ""));
	     				updateData.put("AMOUNT_I", entry.getValue());
	     				super.commonDao.update("s_hpa350ukr_ypServiceImpl.updateList1", updateData);
	     			}
	     			if(entry.getKey().indexOf("WAGES_DED") > -1)	{
	     				updateData.put("DED_CODE", entry.getKey().replaceAll("WAGES_DED", ""));
	     				updateData.put("DED_AMOUNT_I", entry.getValue());
	     				super.commonDao.update("s_hpa350ukr_ypServiceImpl.updateList2", updateData);
	     			}
	        	}
	     		
	     		super.commonDao.update("s_hpa350ukr_ypServiceImpl.updateList3", updateData);
	     		
	     		Map<String, Object> paramMaster = new HashMap();
	     		paramMaster.put("S_COMP_CODE", master.get("S_COMP_CODE"));
	     		paramMaster.put("PAY_YYYYMM", master.get("PAY_YYYYMM"));
	     		paramMaster.put("SUPP_TYPE", master.get("SUPP_TYPE"));
	     		paramMaster.put("PERSON_NUMB", param.get("PERSON_NUMB"));
	     		paramMaster.put("DEPT_CODE", param.get("DEPT_CODE"));
	     		
	     		paramMaster.put("PAY_PROV_FLAG", param.get("PAY_PROV_FLAG"));
	     		paramMaster.put("CALC_TAX_YN", master.get("CALC_TAX_YN"));
	     		paramMaster.put("CALC_HIR_YN", master.get("CALC_HIR_YN"));
	     		paramMaster.put("CALC_IND_YN", master.get("CALC_IND_YN"));
	     		
	     		paramMaster.put("SUPP_DATE", param.get("SUPP_DATE"));
	     		paramMaster.put("PAY_CODE", param.get("PAY_CODE"));
	     		paramMaster.put("DELETE_YN", "N");
	     		
	     		//'{"COMP_CODE":"${S_COMP_CODE}","PAY_YYYYMM":"${PAY_YYYYMM}","SUPP_DATE":"${SUPP_DATE}","SUPP_TYPE":"${SUPP_TYPE}","DIV_CODE":"${DIV_CODE}","DEPT_CODE":"${DEPT_CODE}","PAY_CODE":"${PAY_CODE}","PAY_PROV_FLAG":"${PAY_PROV_FLAG}","PERSON_NUMB":"${PERSON_NUMB}","BATCH_YN":"N","CALC_TAX_YN":"${CALC_TAX_YN}","CALC_HIR_YN":"${CALC_HIR_YN}","CALC_IND_YN":"${CALC_IND_YN}","UPDATE_DB_USER":"${S_USER_ID}","LANG_TYPE":"${S_LANG_CODE}"}'
	    		Map ErrMap = (Map) super.commonDao.select("s_hpa350ukr_ypServiceImpl.payroll", paramMaster);
	    		
	    		String errorDesc = ObjUtils.getSafeString(ErrMap.get("ErrorDesc"));
	    		if(!"".equals(errorDesc))	{
	    			throw new  UniDirectValidateException(errorDesc);
	    		}
		}
		return paramList;
	}
	
	/**
	 * 판매단가 엑셀업로드
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public void excelValidate(String jobID, Map param) throws Exception {
		logger.debug("validate: {}", jobID);
		//UPLOAD 전 데이터 존재여부 체크
		List<Map> getData = (List<Map>) super.commonDao.list("s_hpa350ukr_ypServiceImpl.getData", param);
		
		if(!getData.isEmpty()){
			//excel 파일의 데이터 체크
			for(Map data : getData )  { 
                param.put("ROWNUM", data.get("_EXCEL_ROWNUM"));
				param.put("COMP_CODE", data.get("COMP_CODE"));
				param.put("PERSON_NUMB", data.get("PERSON_NUMB"));
				param.put("PAY_YYYYMM", data.get("PAY_YYYYMM"));

				//업로드 된 데이터의 품목코드 기등록여부 확인
/*				String itemExistYn =  (String) super.commonDao.select("s_hpa350ukr_ypServiceImpl.checkItem", param);
				if (itemExistYn.equals("N")) {					
					param.put("MSG", "품목코드 [" + data.get("ITEM_CODE") +"]를 먼저 등록한 후 업로드 해 주세요.");
					super.commonDao.update("s_hpa350ukr_ypServiceImpl.insertErrorMsg", param);
				}*/
				
				//업로드 된 데이터의 거래처 기등록여부 확인
				String custExistYn =  (String) super.commonDao.select("s_hpa350ukr_ypServiceImpl.checkPersonNum", param);
				if (custExistYn.equals("N")) {
					param.put("MSG", "사번 [" + data.get("PERSON_NUMB") +"]을 확인하십시오.");
					super.commonDao.update("s_hpa350ukr_ypServiceImpl.insertErrorMsg", param);
				}
				
				//HPA600T(월급상여내역) 기등록여부 확인
				String hpa600ExistYn =  (String) super.commonDao.select("s_hpa350ukr_ypServiceImpl.checkData", param);
				if (hpa600ExistYn.equals("N")) {
					param.put("MSG", "월급상여내역이 등록되지 않았습니다.");
					super.commonDao.update("s_hpa350ukr_ypServiceImpl.insertErrorMsg", param);
				}
				
				//마감여부 확인
				String closeYn =  (String) super.commonDao.select("s_hpa350ukr_ypServiceImpl.checkCloseYN", param);
				if (closeYn.equals("Y")) {
					param.put("MSG", "해당 사원 [" + data.get("PERSON_NUMB") +"]은 마감되었습니다.");
					super.commonDao.update("s_hpa350ukr_ypServiceImpl.insertErrorMsg", param);
				}
			}
		}
	}
	
	@ExtDirectMethod(group = "hpa", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectExcelUploadSheet1(Map param) throws Exception {
		return super.commonDao.list("s_hpa350ukr_ypServiceImpl.selectExcelUploadSheet1", param);
	}
	
	@ExtDirectMethod(group = "hpa", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> updateDataHpa400(Map param) throws Exception {
		return super.commonDao.list("s_hpa350ukr_ypServiceImpl.updateDataHpa400", param);
	}
	
	@ExtDirectMethod(group = "hpa", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> updateDataHpa600(Map param) throws Exception {
		return super.commonDao.list("s_hpa350ukr_ypServiceImpl.updateDataHpa600", param);
	}
}
