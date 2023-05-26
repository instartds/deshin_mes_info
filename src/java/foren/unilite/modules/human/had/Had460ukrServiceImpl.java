package foren.unilite.modules.human.had;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.BindingResult;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;


@Service("had460ukrService")
public class Had460ukrServiceImpl  extends TlabAbstractServiceImpl {
	
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return (List<Map<String, Object>>)super.commonDao.list("had460ukrServiceImpl.selectList", param);		
	}
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "human")
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {	
		if(paramList != null)	{
			List<Map<String, Object>> deleteList = null;
			List<Map<String, Object>> insertList = null;
			List<Map<String, Object>> updateList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("delete")) {		
					deleteList = (List<Map<String, Object>>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("insert")) {		
					insertList = (List<Map<String, Object>>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("update")) {
					updateList = (List<Map<String, Object>>)dataListMap.get("data");	
				} 
			}	
			if(deleteList != null) {
				this.delete(deleteList );				
			}
 			if(insertList != null) {
				String sErr = this.getError(insertList.get(0));
				if(!"".equals(sErr))	{
					throw new  UniDirectValidateException(this.getMessage(sErr, user));
				}
				this.insert(insertList );
			}
			if(updateList != null) {
				String sErr = this.getError(updateList.get(0));
				if(!"".equals(sErr))	{
					throw new  UniDirectValidateException(this.getMessage(sErr, user));
				}
				this.update(updateList );				
			}
			//연말정산기초자료등록 테이블에 반영
			if(deleteList != null)	this.baseUpdate1(deleteList,"D");
			if(insertList != null)	this.baseUpdate1(insertList,"A");
			if(updateList != null)	this.baseUpdate1(updateList,"U");
			
			//주택청약관련 및 장기주식형저축소득공제 한도금액 체크하기
			if(insertList != null)	this.checkUpdate(insertList,"A", user);
			if(updateList != null)	this.checkUpdate(updateList,"U", user);
									
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	} 
	
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map<String, Object>> delete(List<Map<String, Object>> paramList) throws Exception {
		for(Map param : paramList) {
			super.commonDao.update("had460ukrServiceImpl.delete", param);
		}
		return paramList;
	}
	
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map<String, Object>> insert(List<Map<String, Object>> paramList) throws Exception {
		for(Map param : paramList) {
			super.commonDao.insert("had460ukrServiceImpl.insert", param);
		}
		return paramList;		
	}
	
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map<String, Object>> update(List<Map<String, Object>> paramList) throws Exception {
		for(Map param : paramList) {
			
			super.commonDao.update("had460ukrServiceImpl.update", param);
		}
		return paramList;		
	}
	
	private List<Map<String, Object>> baseUpdate1(List<Map<String, Object>> paramList, String workFlag) throws Exception {
		for(Map param : paramList) {
			param.put("WORK_FLAG", workFlag);
			super.commonDao.update("had460ukrServiceImpl.baseUpdate1", param);
		}
		return paramList;
	}
	
	private List<Map<String, Object>> checkUpdate(List<Map<String, Object>> paramList, String workFlag, LoginVO user) throws Exception {
		for(Map param : paramList) {
			param.put("WORK_FLAG", workFlag);
			Map errMap = (Map) super.commonDao.select("had460ukrServiceImpl.baseUpdate2", param);
			if(ObjUtils.isNotEmpty(errMap))	{
				String sErr = ObjUtils.getSafeString(errMap.get("ERROR_CODE"));
				if(ObjUtils.isNotEmpty(sErr)) throw new  UniDirectValidateException(this.getMessage(sErr, user));
			}
		}
		return paramList;
	}
	
	private String getError(Map param)	{
		String sErr = "";
		Map err = (Map) super.commonDao.select("had460ukrServiceImpl.selectCheck", param);
		if(ObjUtils.isNotEmpty(err))	{
			sErr = ObjUtils.getSafeString(err.get("ERROR_CODE"));
		}
		return sErr;
	}
}
