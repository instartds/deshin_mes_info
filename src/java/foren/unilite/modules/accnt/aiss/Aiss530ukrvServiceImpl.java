package foren.unilite.modules.accnt.aiss;

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

@Service("aiss530ukrvService")
public class Aiss530ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	/**
	 * 자산손상등록
	 * 자산손상 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return super.commonDao.list("aiss530ukrvServiceImpl.selectList", param);
	}	
	
	/**
	 * 자산손상등록
	 * 자산참조 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList2(Map param) throws Exception {
		return super.commonDao.list("aiss530ukrvServiceImpl.selectList2", param);
	}
	
	// sync All
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "hpa")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		
		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("insertList")) {
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("updateList")) {
					updateList = (List<Map>)dataListMap.get("data");	
				} else if(dataListMap.get("method").equals("deleteList")) {
					deleteList = (List<Map>)dataListMap.get("data");
				} 
			}			
			//입력
			if(insertList != null) this.insertList(insertList, paramMaster, user);
			//수정
			if(updateList != null) this.updateList(updateList, paramMaster, user);
			//삭제
			if(deleteList != null) this.deleteList(deleteList, paramMaster, user);
		}
	 	paramList.add(0, paramMaster);
				
	 	return  paramList;
	}
	
	/**
	 * 신규(추가)
	 * @throws UniDirectValidateException 
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "aiss")
	private void insertList(List<Map> paramList, Map paramMaster, LoginVO user) throws UniDirectValidateException {
		// TODO Auto-generated method stub
		for(Map param :paramList )	{
			 Map err = (Map) super.commonDao.select("aiss530ukrvServiceImpl.checkData", param);
			 if(!ObjUtils.isEmpty(err.get("ERROR_DESC"))){
				String errorDesc = ObjUtils.getSafeString(err.get("ERROR_DESC"));
				String errorCode = ObjUtils.getSafeString(err.get("ERROR_CODE"));
				if (ObjUtils.isNotEmpty(errorDesc)) {
					String[] messsage = errorDesc.split(",");
				    throw new  UniDirectValidateException(this.getMessage(errorCode, user) + "\n" + messsage[0] + "\n" + messsage[1]);
				} else {
				    throw new  UniDirectValidateException(this.getMessage(errorCode, user));
				}
			 }
			
			super.commonDao.insert("aiss530ukrvServiceImpl.insertList", param);							
		}
		return;
	}

	/**
	 * 수정
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "aiss")
	public List<Map> updateList(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");

		for(Map param :paramList )	{			
			 Map err = (Map) super.commonDao.select("aiss530ukrvServiceImpl.checkData", param);
			 if(!ObjUtils.isEmpty(err.get("ERROR_DESC"))){
				String errorDesc = ObjUtils.getSafeString(err.get("ERROR_DESC"));
				String errorCode = ObjUtils.getSafeString(err.get("ERROR_CODE"));
				if (ObjUtils.isNotEmpty(errorDesc)) {
					String[] messsage = errorDesc.split(",");
				    throw new  UniDirectValidateException(this.getMessage(errorCode, user) + "\n" + messsage[0] + "\n" + messsage[1]);
				} else {
				    throw new  UniDirectValidateException(this.getMessage(errorCode, user));
				}
			 }
			
			super.commonDao.update("aiss530ukrvServiceImpl.updateList", param);							
		}
		return paramList;
	}
	
	/**
	 * 삭제
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hpa")
	public void deleteList(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");

		for(Map param :paramList )	{
			 Map err = (Map) super.commonDao.select("aiss530ukrvServiceImpl.checkDelete", param);
			 if(!ObjUtils.isEmpty(err.get("ERROR_DESC"))){
				String errorDesc = ObjUtils.getSafeString(err.get("ERROR_DESC"));
				String errorCode = ObjUtils.getSafeString(err.get("ERROR_CODE"));
				if (ObjUtils.isNotEmpty(errorDesc)) {
					String[] messsage = errorDesc.split(",");
				    throw new  UniDirectValidateException(this.getMessage(errorCode, user) + "\n" + messsage[0] + "\n" + messsage[1]);
				} else {
				    throw new  UniDirectValidateException(this.getMessage(errorCode, user));
				}
			 }
			 super.commonDao.delete("aiss530ukrvServiceImpl.deleteList", param);
		}	
		return;
	}
	
}
