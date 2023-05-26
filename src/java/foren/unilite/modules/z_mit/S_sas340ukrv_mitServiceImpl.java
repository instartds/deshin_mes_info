package foren.unilite.modules.z_mit;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
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

import com.google.gson.Gson;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.lib.tree.GenericTreeDataMap;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.com.tree.UniTreeHelper;
import foren.unilite.modules.com.tree.UniTreeNode;



@Service("s_sas340ukrv_mitService")
public class S_sas340ukrv_mitServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	/**
	 * 마스터그리드 조회
	 * 
	 * @param param
	 * @param loginVO
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_mit")
	public List<Map<String, Object>> selectList(Map param, LoginVO loginVO) throws Exception {		
		return (List) super.commonDao.list("s_sas340ukrv_mitServiceImpl.selectList", param);
	}
	/**
	 * 마스터 그리드 저장
	 * @param paramList
	 * @param paramMaster
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "z_mit")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster,  LoginVO user) throws Exception {	
		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteList")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insertList")) {		
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("updateList")) {
					updateList = (List<Map>)dataListMap.get("data");	
				} 
			}			
			if(deleteList != null) this.deleteList(deleteList, user);
			if(insertList != null) this.insertList(insertList, user);
			if(updateList != null) this.updateList(updateList, user);				
		}
		
		paramList.add(0, paramMaster);		
		return  paramList;
	}
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_mit")		
	public Integer  insertList(List<Map> paramList, LoginVO user) throws Exception {		
		for(Map param : paramList )	{			 
				super.commonDao.update("s_sas340ukrv_mitServiceImpl.insertList", param);
		}	
		return 0;
	}	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_mit")		// UPDATE
	public Integer updateList(List<Map> paramList, LoginVO user) throws Exception {
		 for(Map param :paramList )	{	
			 super.commonDao.update("s_sas340ukrv_mitServiceImpl.updateList", param);
		 }
		 return 0;
	} 
	
	
	@ExtDirectMethod(group = "z_mit", needsModificatinAuth = true)		// DELETE
	public Integer deleteList(List<Map> paramList,  LoginVO user) throws Exception {
		 for(Map param :paramList )	{	
			Map<String, Object> checkData = (Map<String, Object>) super.commonDao.select("s_sas340ukrv_mitServiceImpl.selectCheckList", param);
			 if(checkData != null && ObjUtils.isNotEmpty(checkData.get("IN_DATE")))	{
				 
				 throw new	UniDirectValidateException("이력데이타는 삭제할 수 없습니다.");
			 }
			super.commonDao.update("s_sas340ukrv_mitServiceImpl.deleteList", param);
		 }
		 return 0;
	}
}
