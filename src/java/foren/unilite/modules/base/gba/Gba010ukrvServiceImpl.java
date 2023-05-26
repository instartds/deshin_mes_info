package foren.unilite.modules.base.gba;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;

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
import foren.framework.lib.tree.GenericTreeDataMap;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.com.fileman.FileMnagerService;
import foren.unilite.modules.com.tree.UniTreeHelper;
import foren.unilite.modules.com.tree.UniTreeNode;

@Service("gba010ukrvService")
public class Gba010ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	
	
	@ExtDirectMethod(value = ExtDirectMethodType.TREE_LOAD, group = "base")
	public UniTreeNode selectList(Map param) throws Exception {		
		/**
		*1. result Class 확인(foren.framework.lib.tree.GenericTreeDataMap)!
		*2. SQL의 수행 결과 순서는 parent가 child보더 먼저 나오게 구성 되어야 함.
		*3. id와 parentId는 필수 !
		*4. 최상의 node는 parentId가 root로 지정 되어야 함.
		*/
		List<GenericTreeDataMap> menuList = super.commonDao.list("gba010ukrvServiceImpl.selectList", param);
		
		GenericTreeDataMap rootData = new GenericTreeDataMap();
		rootData.put("id", "rootData");
		rootData.put("parentId", "root");
		rootData.put("BUDG_CODE", "코드");
		rootData.put("BUDG_NAME", "분류구성도");//분류구성도
		rootData.put("expanded", "true");
		menuList.add(0, rootData);
		
		return UniTreeHelper.makeTreeAndGetRootNode(menuList);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")
	public List<Map>  insertMulti(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		logger.debug("\n insertMulti: {}",paramList );
		for(Map param :paramList )	{
			
			 Map chkMap = (Map)super.commonDao.select("gba010ukrvServiceImpl.checkPK", param);
			 if( ObjUtils.parseInt(chkMap.get("CNT")) > 0) 	{
				 logger.debug("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  CNT:{}",ObjUtils.parseInt(chkMap.get("CNT")));
					throw new  UniDirectValidateException(this.getMessage("2627", user));
			 }
			 Map data = (Map) paramMaster.get("data");
			 param.put("DIV_CODE", data.get("DIV_CODE"));
			  super.commonDao.insert("gba010ukrvServiceImpl.insert", param);
			 
		}
		return paramList;
	}
    
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")
	public List<Map>  updateMulti(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		logger.debug("\n updateMulti: {}",paramList );
		for(Map param :paramList )	{	
			Map data = (Map) paramMaster.get("data");
			 param.put("DIV_CODE", data.get("DIV_CODE"));
			 if(!param.get("BUDG_NAME").toString().equals("분류구성도") || !param.get("BUDG_CODE").toString().equals("코드")) {
				 super.commonDao.update("gba010ukrvServiceImpl.update", param);
			 }
		}
		return paramList;
	}
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")
	public List<Map>  deleteMulti(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		logger.debug("\n deleteMulti: {}",paramList );
		for(Map param :paramList )	{
			Map data = (Map) paramMaster.get("data");
			 param.put("DIV_CODE", data.get("DIV_CODE"));
			 super.commonDao.update("gba010ukrvServiceImpl.delete", param);
		}
		return paramList;
	}
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "base")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
				
		Map<String, Object> rMap;

		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteMulti")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insertMulti")) {		
					insertList = (List<Map>)dataListMap.get("data");		
					
				} else if(dataListMap.get("method").equals("updateMulti")) {
					updateList = (List<Map>)dataListMap.get("data");	
				} 
			}
			if(deleteList != null) this.deleteMulti(deleteList, paramMaster, user);
			if(insertList != null) this.insertMulti(insertList, paramMaster, user);
			if(updateList != null) this.updateMulti(updateList, paramMaster, user);				
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")
	public Integer  syncAll(Map param) throws Exception {
		logger.debug("syncAll:" + param);
		return  0;
	}
}
