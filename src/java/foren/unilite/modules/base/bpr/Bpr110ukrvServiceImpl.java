package foren.unilite.modules.base.bpr;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.com.tree.UniTreeHelper;
import foren.unilite.modules.com.tree.UniTreeNode;
import foren.framework.lib.tree.GenericTreeDataMap;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;

@Service("bpr110ukrvService")
public class Bpr110ukrvServiceImpl extends TlabAbstractServiceImpl  {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	
	/**
	 * 품목분류 조회
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "Base")
	public UniTreeNode selectList(Map param, LoginVO user) throws Exception {
		List<GenericTreeDataMap> treeList = super.commonDao.list("bpr110ukrvService.selectList", param);
		
		GenericTreeDataMap rootData = new GenericTreeDataMap();
		rootData.put("id"			, "rootData");
		rootData.put("parentId"		, "root");
		rootData.put("LEVEL_CODE"	, "코드");
		rootData.put("LEVEL_NAME"	, "분류구성도");
		rootData.put("expanded"		, "true");
		treeList.add(0				, rootData);

		return  UniTreeHelper.makeTreeAndGetRootNode(treeList);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "Base")
	public List<Map>  insert(List<Map> paramList, LoginVO user) throws Exception {		
		for(Map param :paramList )	{	
			 Map chkMap = (Map)super.commonDao.select("bpr110ukrvService.checkPK", param);
			 if( ObjUtils.parseInt(chkMap.get("CNT")) > 0) 	{
					throw new  UniDirectValidateException(this.getMessage("2627", user));
			 }
			super.commonDao.insert("bpr110ukrvService.insert", param);
		}
		
		/*Map searchParam = new HashMap();
		searchParam.put("S_COMP_CODE", user.getCompCode());
		UniTreeNode rList = this.selectList(searchParam, user);
		return  rList;*/
		return paramList;
	}	
	

	
	@ExtDirectMethod(group = "Base")
	public List<Map> delete(List<Map> paramList) throws Exception {
		 for(Map param :paramList )	{	
		 super.commonDao.update("bpr110ukrvService.delete", param);
		 }
		 return paramList;
	}
	
	
	@ExtDirectMethod(group = "Base")
	public List<Map> update(List<Map> paramList) throws Exception {
		 for(Map param :paramList )	{	
		 super.commonDao.update("bpr110ukrvService.update", param);
		 }
		 return paramList;
	} 

	
	@ExtDirectMethod(group = "Base")
	public Integer  syncAll(Map param) throws Exception {
		logger.debug("syncAll:" + param);
		return  0;
	}
	
	

}
