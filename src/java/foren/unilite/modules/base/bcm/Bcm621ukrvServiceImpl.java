package foren.unilite.modules.base.bcm;

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
import foren.unilite.com.utils.UniliteUtil;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.base.bdc.Bdc100ukrvService;
import foren.unilite.modules.com.fileman.FileMnagerService;



@Service("bcm621ukrvService")
public class Bcm621ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	
	
	

	@ExtDirectMethod(group = "base", value = ExtDirectMethodType.STORE_READ)	/* 조회1 */
	public List<Map<String, Object>> selectMaster(Map param) throws Exception {
		return super.commonDao.list("bcm621ukrvService.selectMasterList", param);
	}
	
	/**
	 * 
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(group = "base", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectDetail(Map param) throws Exception {
	
		return  super.commonDao.list("bcm621ukrvService.selectDetailList", param);
	}

	/*
	 * Master 등록
	 * 
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "base")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class}) 
	public List<Map> saveAll(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
		 
		 if(paramList != null)	{
				List<Map> insertList = null;
				List<Map> updateList = null;
				List<Map> deleteList = null;
				for(Map dataListMap: paramList) {
					if(dataListMap.get("method").equals("deleteMaster")) {
						deleteList = (List<Map>)dataListMap.get("data");
					}else if(dataListMap.get("method").equals("insertMaster")) {		
						insertList = (List<Map>)dataListMap.get("data");
					} else if(dataListMap.get("method").equals("updateMaster")) {
						updateList = (List<Map>)dataListMap.get("data");	
					} 
				}			
				if(deleteList != null) this.deleteMaster(deleteList, user);
				if(insertList != null) this.insertMaster(insertList, user);
				if(updateList != null) this.updateMaster(updateList, user);				
			}
		 	paramList.add(0, paramMaster);
				
		 	return  paramList;
	}
	 
	 
	 /**
		 * Master 삭제
		 * @param param
		 * @return
		 * @throws Exception
		 */
		@ExtDirectMethod(group = "base", needsModificatinAuth = true)
		public Integer deleteMaster(List<Map> paramList,  LoginVO user) throws Exception {
			 for(Map param :paramList )	{
				 try {
					 super.commonDao.delete("bcm621ukrvService.deleteMaster", param);
				 }catch(Exception e)	{
		    			throw new  UniDirectValidateException(this.getMessage("55523",user));//삭제할 수 없습니다.
				 }
			 }
			 return 0;
		}
		
		/**
		 * Master 입력
		 * @param param
		 * @return
		 * @throws Exception
		 */
		@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")
		public Integer  insertMaster(List<Map> paramList, LoginVO user) throws Exception {		
			try {
				for(Map param : paramList )	{
					super.commonDao.update("bcm621ukrvService.insertMaster", param);
				}
			}catch(Exception e){
				throw new  UniDirectValidateException(this.getMessage("2627", user));//중복되는 자료가 입력 되었습니다.
			}		
			return 0;
		}	
		
		
		/**
		 * Master 수정
		 * @param param
		 * @return
		 * @throws Exception
		 */
		@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")
		public Integer updateMaster(List<Map> paramList, LoginVO user) throws Exception {		
			 for(Map param :paramList )	{
				 super.commonDao.update("bcm621ukrvService.updateMaster", param);
			 }		 
			 return 0;
		}
		
		
		/*
		 * Detail 등록
		 * 
		 */
		@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "base")
		@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class}) 
		public List<Map> saveAll2(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
			 
			 if(paramList != null)	{
					List<Map> insertList = null;
					List<Map> updateList = null;
					List<Map> deleteList = null;
					for(Map dataListMap: paramList) {
						if(dataListMap.get("method").equals("deleteDetail")) {
							deleteList = (List<Map>)dataListMap.get("data");
						}else if(dataListMap.get("method").equals("insertDetail")) {		
							insertList = (List<Map>)dataListMap.get("data");
						} else if(dataListMap.get("method").equals("updateDetail")) {
							updateList = (List<Map>)dataListMap.get("data");	
						} 
					}			
					if(deleteList != null) this.deleteDetail(deleteList, user);
					if(insertList != null) this.insertDetail(insertList, user);
					if(updateList != null) this.updateDetail(updateList, user);				
				}
			 	paramList.add(0, paramMaster);
					
			 	return  paramList;
		}
				
		
		/**
		 * Detail 삭제
		 * @param param
		 * @return
		 * @throws Exception
		 */
		@ExtDirectMethod(group = "base", needsModificatinAuth = true)
		public Integer deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {
			 for(Map param :paramList )	{
				 try {
					 super.commonDao.delete("bcm621ukrvService.deleteDetail", param);
				 }catch(Exception e)	{
		    			throw new  UniDirectValidateException(this.getMessage("55523",user));//삭제할 수 없습니다.
				 }
			 }
			 return 0;
		}
		
		
		
		/**
		 * Detail 입력
		 * @param param
		 * @return
		 * @throws Exception
		 */
		@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")
		public Integer  insertDetail(List<Map> paramList, LoginVO user) throws Exception {		
			try {
				for(Map param : paramList )	{
					super.commonDao.update("bcm621ukrvService.insertDetail", param);
				}
			}catch(Exception e){
				throw new  UniDirectValidateException(this.getMessage("2627", user));//중복되는 자료가 입력 되었습니다.
			}		
			return 0;
		}	
		
		/**
		 * Detail 수정
		 * @param param
		 * @return
		 * @throws Exception
		 */
		@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")
		public Integer updateDetail(List<Map> paramList, LoginVO user) throws Exception {		
			 for(Map param :paramList )	{
				 super.commonDao.update("bcm621ukrvService.updateDetail", param);
			 }		 
			 return 0;
		} 
		
}
