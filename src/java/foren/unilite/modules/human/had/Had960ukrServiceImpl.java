package foren.unilite.modules.human.had;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.poi.ss.formula.functions.T;
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


@Service("had960ukrService")
public class Had960ukrServiceImpl  extends TlabAbstractServiceImpl {
	
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		// 이전/이후 사번 조회
		if(ObjUtils.isNotEmpty(param.get("DIR_TYPE")))	{
			Map<String, Object> dMap = (Map<String, Object>) super.commonDao.select("had960ukrServiceImpl.selectDir", param);	
			if(ObjUtils.isNotEmpty(dMap.get("PERSON_NUMB")))	{
				param.put("PERSON_NUMB", dMap.get("PERSON_NUMB"));
			}
		}				
		return (List<Map<String, Object>>)super.commonDao.list("had960ukrServiceImpl.selectList", param);		
	}
	
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectChkData(Map param) throws Exception {
		return (List<Map<String, Object>>)super.commonDao.list("had960ukrServiceImpl.selectChkData", param);		
	}
	
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectLast(Map param) throws Exception {
		return (List<Map<String, Object>>)super.commonDao.list("had960ukrServiceImpl.selectLast", param);		
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
			if(deleteList != null) this.delete(deleteList );
			if(insertList != null) this.insert(insertList );
			if(updateList != null) this.update(updateList );				
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	} 
	
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map<String, Object>> delete(List<Map<String, Object>> paramList) throws Exception {
		for(Map param : paramList) {
			super.commonDao.update("had960ukrServiceImpl.delete", param);
		}
		return paramList;
	}
	
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map<String, Object>> insert(List<Map<String, Object>> paramList) throws Exception {
		for(Map param : paramList) {
			param.put("DEFAULT_DED_YN"		, this.getCheckboxValueYN(param.get("DEFAULT_DED_YN")));
			param.put("HOUSEHOLDER_YN"		, this.getCheckboxValueCode(param.get("HOUSEHOLDER_YN")));
			param.put("DEFORM_DED_YN"		, this.getCheckboxValueYN(param.get("DEFORM_DED_YN")));
			param.put("BRING_CHILD_DED_YN"	, this.getCheckboxValueYN(param.get("BRING_CHILD_DED_YN")));
			param.put("WOMAN_DED_YN"		, this.getCheckboxValueYN(param.get("WOMAN_DED_YN")));
			param.put("ONE_PARENT_DED_YN"	, this.getCheckboxValueYN(param.get("ONE_PARENT_DED_YN")));
			param.put("OLD_DED_YN"			, this.getCheckboxValueYN(param.get("OLD_DED_YN")));
			param.put("MANY_CHILD_DED_YN"	, this.getCheckboxValueYN(param.get("MANY_CHILD_DED_YN")));
			param.put("BIRTH_ADOPT_DED_YN"	, this.getCheckboxValueYN(param.get("BIRTH_ADOPT_DED_YN")));
			super.commonDao.insert("had960ukrServiceImpl.insert", param);
			param.put("DIVI"	, "");
			param.put("DEFAULT_DED_YN"		, this.getCheckboxValueTF(param.get("DEFAULT_DED_YN"),"DEFAULT_DED_YN"));
			param.put("HOUSEHOLDER_YN"		, this.getCheckboxValueTF(param.get("HOUSEHOLDER_YN"),"HOUSEHOLDER_YN"));
			param.put("DEFORM_DED_YN"		, this.getCheckboxValueTF(param.get("DEFORM_DED_YN"),"DEFORM_DED_YN"));
			param.put("BRING_CHILD_DED_YN"	, this.getCheckboxValueTF(param.get("BRING_CHILD_DED_YN"),"BRING_CHILD_DED_YN"));
			param.put("WOMAN_DED_YN"		, this.getCheckboxValueTF(param.get("WOMAN_DED_YN"),"WOMAN_DED_YN"));
			param.put("ONE_PARENT_DED_YN"	, this.getCheckboxValueTF(param.get("ONE_PARENT_DED_YN"),"ONE_PARENT_DED_YN"));
			param.put("OLD_DED_YN"			, this.getCheckboxValueTF(param.get("OLD_DED_YN"),"OLD_DED_YN"));
			param.put("MANY_CHILD_DED_YN"	, this.getCheckboxValueTF(param.get("MANY_CHILD_DED_YN"),"MANY_CHILD_DED_YN"));
			param.put("BIRTH_ADOPT_DED_YN"	, this.getCheckboxValueTF(param.get("BIRTH_ADOPT_DED_YN"),"BIRTH_ADOPT_DED_YN"));
		}
		return paramList;		
	}
	
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map<String, Object>> update(List<Map<String, Object>> paramList) throws Exception {
		for(Map param : paramList) {
			param.put("DEFAULT_DED_YN"		, this.getCheckboxValueYN(param.get("DEFAULT_DED_YN")));
			param.put("HOUSEHOLDER_YN"		, this.getCheckboxValueCode(param.get("HOUSEHOLDER_YN")));
			param.put("DEFORM_DED_YN"		, this.getCheckboxValueYN(param.get("DEFORM_DED_YN")));
			param.put("BRING_CHILD_DED_YN"	, this.getCheckboxValueYN(param.get("BRING_CHILD_DED_YN")));
			param.put("WOMAN_DED_YN"		, this.getCheckboxValueYN(param.get("WOMAN_DED_YN")));
			param.put("ONE_PARENT_DED_YN"	, this.getCheckboxValueYN(param.get("ONE_PARENT_DED_YN")));
			param.put("OLD_DED_YN"			, this.getCheckboxValueYN(param.get("OLD_DED_YN")));
			param.put("MANY_CHILD_DED_YN"	, this.getCheckboxValueYN(param.get("MANY_CHILD_DED_YN")));
			param.put("BIRTH_ADOPT_DED_YN"	, this.getCheckboxValueYN(param.get("BIRTH_ADOPT_DED_YN")));
			super.commonDao.update("had960ukrServiceImpl.update", param);
			param.put("DIVI"	, "");
			param.put("DEFAULT_DED_YN"		, this.getCheckboxValueTF(param.get("DEFAULT_DED_YN"),"DEFAULT_DED_YN"));
			param.put("HOUSEHOLDER_YN"		, this.getCheckboxValueTF(param.get("HOUSEHOLDER_YN"),"HOUSEHOLDER_YN"));
			param.put("DEFORM_DED_YN"		, this.getCheckboxValueTF(param.get("DEFORM_DED_YN"),"DEFORM_DED_YN"));
			param.put("BRING_CHILD_DED_YN"	, this.getCheckboxValueTF(param.get("BRING_CHILD_DED_YN"),"BRING_CHILD_DED_YN"));
			param.put("WOMAN_DED_YN"		, this.getCheckboxValueTF(param.get("WOMAN_DED_YN"),"WOMAN_DED_YN"));
			param.put("ONE_PARENT_DED_YN"	, this.getCheckboxValueTF(param.get("ONE_PARENT_DED_YN"),"ONE_PARENT_DED_YN"));
			param.put("OLD_DED_YN"			, this.getCheckboxValueTF(param.get("OLD_DED_YN"),"OLD_DED_YN"));
			param.put("MANY_CHILD_DED_YN"	, this.getCheckboxValueTF(param.get("MANY_CHILD_DED_YN"),"MANY_CHILD_DED_YN"));
			param.put("BIRTH_ADOPT_DED_YN"	, this.getCheckboxValueTF(param.get("BIRTH_ADOPT_DED_YN"),"BIRTH_ADOPT_DED_YN"));
		}
		return paramList;		
	}
	
	/**
	 * 체크박스  
	 * @param obj
	 * @return Y or N 
	 */
	private String getCheckboxValueYN(Object obj)	{
		String rValue = "N";
		if("true".equals(ObjUtils.getSafeString(obj).toLowerCase()))	{
			rValue = "Y";
		}
		return rValue;
	}
	private String getCheckboxValueCode(Object obj)	{
		String rValue = "0";
		if("true".equals(ObjUtils.getSafeString(obj).toLowerCase()))	{
			rValue = "1";
		}
		return rValue;
	}
	

	private String getCheckboxValueTF(Object obj, String fieldName)	{
		String rValue = "false";
		if("HOUSEHOLDER_YN".equals(fieldName))	{
			if("1".equals(ObjUtils.getSafeString(obj)))	{
				rValue = "true";
			}else {
				rValue = "false";
			}
		}else if("Y".equals(ObjUtils.getSafeString(obj).toUpperCase()))	{
			rValue = "true";
		}
		return rValue;
	}
}
