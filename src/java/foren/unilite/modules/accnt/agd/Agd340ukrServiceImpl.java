package foren.unilite.modules.accnt.agd;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.BindingResult;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.extjs.UniliteExtjsUtils;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.base.bdc.Bdc100ukrvService;
import foren.unilite.modules.com.fileman.FileMnagerService;



@Service("agd340ukrService")
public class Agd340ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	/**
	 * 
	  * detail 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectDetailList(Map param) throws Exception {
		return super.commonDao.list("agd340ukrServiceImpl.selectDetailList", param);
	}	
	
	
	/**저장**/
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		
		if(paramList != null)	{
			List<Map> updateList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("updateDetail")) {
					updateList = (List<Map>)dataListMap.get("data");	
				} 
			}			
			if(updateList != null) this.updateDetail(updateList, user, paramMaster);				
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Integer updateDetail(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		String keyValue = getLogKey();	
		for(Map param :paramList )	{
			param.put("KEY_VALUE", keyValue);
			param.put("OPR_FLAG", dataMaster.get("oprFlag"));
			param.put("COMP_CODE", user.getCompCode());
			
			if(dataMaster.get("WORK").equals("Proc")){
			
				if(dataMaster.get("DATE_OPT").equals("C") || dataMaster.get("HDD_PROC_TYPE").equals("C")){
					param.put("PROC_DATE", "");
				}else{
					param.put("PROC_DATE", dataMaster.get("EX_DATE"));
				}
				param.put("PROC_TYPE", dataMaster.get("HDD_PROC_TYPE"));
			}
			/*else if(dataMaster.get("WORK").equals("Canc")){
				
			}*/
			
			super.commonDao.insert("agd340ukrServiceImpl.insertLogDetail", param);
			
			if(dataMaster.get("WORK").equals("Proc")){
				//3.자금이체자동기표 Stored Procedure 실행
				Map<String, Object> spParam = new HashMap<String, Object>();
		
				
				spParam.put("CompCode", user.getCompCode());
				spParam.put("UserId", user.getUserID());
				spParam.put("KeyValue", keyValue);
				spParam.put("LangCode", user.getLanguage());
				
				
				super.commonDao.queryForObject("spUspAccntAutoSlip70P", spParam);
				
				String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
				
		
				if(!ObjUtils.isEmpty(errorDesc)){
				    throw new  Exception(errorDesc);
				}
			}else if(dataMaster.get("WORK").equals("Canc")){
				//3.자금이체자동기표취소 Stored Procedure 실행
				Map<String, Object> spParam = new HashMap<String, Object>();
		
				spParam.put("CompCode", user.getCompCode());
				spParam.put("UserId", user.getUserID());
				spParam.put("KeyValue", keyValue);
				spParam.put("LangCode", user.getLanguage());
				
				super.commonDao.queryForObject("spUspAccntAutoSlip70CancelP", spParam);
				
				String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
				
		
				if(!ObjUtils.isEmpty(errorDesc)){
				    throw new  Exception(errorDesc);
				}
				
			}
		}
		 return 0;
	} 
	
	
}
