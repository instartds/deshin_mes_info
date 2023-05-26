package foren.unilite.modules.accnt.atx;

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
import foren.unilite.com.tags.ComboItemModel;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.base.bdc.Bdc100ukrvService;
import foren.unilite.modules.com.fileman.FileMnagerService;

@Service("atx550ukrService")
public class Atx550ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	
	
	/**
	 * 조회
	 * @param param
	 * @return List
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "Accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList (Map param, LoginVO user) throws Exception {
		List<Map<String, Object>> selectData = (List<Map<String, Object>>) super.commonDao.list("atx550ukrServiceImpl.selectList", param);
		if(ObjUtils.isNotEmpty(selectData)){
			return selectData;
			
		} else {
			List<Map<String, Object>> returnData = (List<Map<String, Object>>) super.commonDao.list("atx550ukrServiceImpl.makeList", param);
	        String errorDesc ="";
	        if(ObjUtils.isNotEmpty(returnData)){
	            errorDesc = ObjUtils.getSafeString(returnData.get(0).get("ERROR_DESC"));
		        if(ObjUtils.isNotEmpty(errorDesc)){
		            throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
		        }
	        } 
	        return returnData;
        }
	}
	
	/**
	 * atx550t 데이터 유무 체크
	 * @param param
	 * @return List
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "Accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> checkData (Map param) throws Exception {
		return super.commonDao.list("atx550ukrServiceImpl.checkData", param);
	}
	
	
	/**
	 * 저장
	 * @param paramList, paramMaster, user
	 * @return List
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "Accnt")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class}) 
	public List<Map> saveAll(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		 
		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			
			for(Map dataListMap: paramList) {
				//panelSearch(subForm)에서 넘어온 DESC_REMARK, TERM_DIVI를 dataListMap에 insert
				dataListMap.put("DESC_REMARK"	, dataMaster.get("DESC_REMARK"));
				dataListMap.put("TERM_DIVI"		, dataMaster.get("TERM_DIVI"));
				
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
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "Accnt")
	public Integer insertList(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {		
		try {
			for(Map param : paramList )	{			 
				super.commonDao.update("atx550ukrServiceImpl.insertList", param);
			}	
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("2627", user));
		}
		return 0;
	}	

	
	/**
	 * 수정
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "Accnt")
	public Integer updateList(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		for(Map param :paramList )	{	
			super.commonDao.update("atx550ukrServiceImpl.updateList", param);
		}
		return 0;
	} 
	
	/**
	 * 삭제
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "Accnt")
	public void deleteList(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		for(Map param :paramList )	{
			 super.commonDao.delete("atx550ukrServiceImpl.deleteList", param);
		}	
		return;
	}
}
