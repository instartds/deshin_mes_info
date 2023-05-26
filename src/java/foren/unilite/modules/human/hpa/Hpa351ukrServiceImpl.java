package foren.unilite.modules.human.hpa;

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

@Service("hpa351ukrService")
public class Hpa351ukrServiceImpl extends TlabAbstractServiceImpl {
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
				"hpa351ukrServiceImpl.selectColumns", loginVO.getCompCode());
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
		return (List) super.commonDao.list("hpa351ukrServiceImpl.selectList",
				param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "human")
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
	     		
     		Map ErrMap = (Map) super.commonDao.queryForObject("hpa351ukrServiceImpl.payroll", param);
    		
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
		List<Map> chkList = (List<Map>) super.commonDao.list("hpa351ukrServiceImpl.checkCompCode", compCodeMap);
		for (Map<String, Object> param : paramList) {
				Map<String, Object> updateData = new HashMap();
				updateData.put("S_COMP_CODE", user.getCompCode());
				updateData.put("PAY_YYYYMM", param.get("PAY_YYYYMM"));
				updateData.put("SUPP_TYPE", master.get("SUPP_TYPE"));
				updateData.put("PERSON_NUMB", param.get("PERSON_NUMB"));
				
		             
	     		for(Map.Entry<String, Object> entry : param.entrySet()) {
	     			if(entry.getKey().indexOf("WAGES_PAY") > -1)	{
	     				updateData.put("WAGES_CODE", entry.getKey().replaceAll("WAGES_PAY", ""));
	     				updateData.put("AMOUNT_I", entry.getValue());
	     				super.commonDao.update("hpa351ukrServiceImpl.updateList1", updateData);
	     			}
	     			if(entry.getKey().indexOf("WAGES_DED") > -1)	{
	     				updateData.put("DED_CODE", entry.getKey().replaceAll("WAGES_DED", ""));
	     				updateData.put("DED_AMOUNT_I", entry.getValue());
	     				super.commonDao.update("hpa351ukrServiceImpl.updateList2", updateData);
	     			}
	        	}
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
	    		Map ErrMap = (Map) super.commonDao.select("hpa351ukrServiceImpl.payroll", paramMaster);
	    		
	    		String errorDesc = ObjUtils.getSafeString(ErrMap.get("ErrorDesc"));
	    		if(!"".equals(errorDesc))	{
	    			throw new  UniDirectValidateException(errorDesc);
	    		}
		}
		return paramList;
	}
}
