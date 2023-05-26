package foren.unilite.modules.human.hat;

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


@Service("hat605ukrService")
public class Hat605ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	/**
	 * 일근태현황조회  
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@Transactional(readOnly = true)
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "human")
	public List<Map<String, Object>> selectList(Map param) throws Exception {		
			
		return (List) super.commonDao.list("hat605ukrServiceImpl.selectList", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "hbs")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {	
		if(paramList != null)	{
			List<Map> updateList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("updateList")) {
					updateList = (List<Map>)dataListMap.get("data");	
				} 
			}			
			if(updateList != null) this.updateList(updateList, user);				
		}
		paramList.add(0, paramMaster);
			
		return  paramList;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "human")
	public List<Map> updateList(List<Map> paramList, LoginVO user) throws Exception {
		Map prevParam = new HashMap();
		List<Map> empList = new ArrayList<Map>();
		for(Map param :paramList ) {
			super.commonDao.update("hat605ukrServiceImpl.updateList", param);
			
			if(prevParam != null && prevParam.get("PERSON_NUMB") != null)	{
				if(!ObjUtils.getSafeString(prevParam.get("PERSON_NUMB")).equals(ObjUtils.getSafeString(param.get("PERSON_NUMB"))))	{
					prevParam = param;
					empList.add(param);
				}
			} else {
				prevParam = param;
				empList.add(param);
			}
		}
		
		for(Map spParam :empList ) {
			execProc(spParam,  user);
		}
		
		return paramList;
	}
	
	@ExtDirectMethod( group = "human")
	public Object  execProc(Map spParam, LoginVO user) throws Exception {
		
		spParam.put("DEPT_CODE_FR", "");
		spParam.put("DEPT_CODE_TO", "");
		
		if(spParam.get("DUTY_YYYYMMDD") != null && ObjUtils.getSafeString(spParam.get("DUTY_YYYYMMDD")).length() == 8)	{
			spParam.put("DUTY_YYYYMM", ObjUtils.getSafeString(spParam.get("DUTY_YYYYMMDD")).substring(0,6));
		} else {
			spParam.put("DUTY_YYYYMM", "");
		}
		
		Map errorMap = (Map) super.commonDao.select("hat605ukrServiceImpl.USP_HUMAN_HAT600UKR_REWORK", spParam);
//		String errorDesc = (String) errorMap.get("errorDesc");
		if(!ObjUtils.isEmpty(errorMap.get("errorDesc"))){
			String errorDesc = (String) errorMap.get("errorDesc");
		    throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
		}else{
			return true;
		}	
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "human")
	public List<Map<String, Object>> selectCancelList(Map param) throws Exception {		
			
		return (List) super.commonDao.list("hat605ukrServiceImpl.selectCancelList", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "human")
	public List<Map> updateCancelList(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param :paramList ) {
			super.commonDao.update("hat605ukrServiceImpl.updateCancelList", param);
			execProc(param,  user);
		}		
		return paramList;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "hbs")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveCancel(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {	
		if(paramList != null)	{
			List<Map> updateList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("updateCancelList")) {
					updateList = (List<Map>)dataListMap.get("data");	
				} 
			}			
			if(updateList != null) this.updateCancelList(updateList, user);				
		}
		paramList.add(0, paramMaster);
			
		return  paramList;
	}
}
