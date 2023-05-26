package foren.unilite.modules.base.bsa;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.service.impl.TlabMenuService;

@Service("bsa610ukrvService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Bsa610ukrvServiceImpl extends TlabAbstractServiceImpl  {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	 @Resource(name = "tlabMenuService")
	 TlabMenuService tlabMenuService;
	
	@ExtDirectMethod(group = "Base")
	public List<Map<String, Object>> selectMastertList(Map param) throws Exception {
		return super.commonDao.list("bsa610ukrvService.selectMastertList", param);
	}
	
	@ExtDirectMethod(group = "Base")
	public List<Map<String, Object>> selectDetailList(Map param) throws Exception {
		return super.commonDao.list("bsa610ukrvService.selectDetailList", param);
	}	
	

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "base")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll1(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
				
		Map<String, Object> rMap;

		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deletePrograms1")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insertPrograms1")) {		
					insertList = (List<Map>)dataListMap.get("data");		
					
				} 
			}
			if(deleteList != null) this.deletePrograms1(deleteList);
			if(insertList != null) this.insertPrograms1(insertList,user);		
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "Base")
	public List<Map>  insertPrograms1(List<Map> paramList, LoginVO user) throws Exception {		
		for(Map param :paramList )	{		
			super.commonDao.insert("bsa610ukrvService.insertPrograms1", param);
		}
		tlabMenuService.reload();
		return  paramList;
	}	
	
	@ExtDirectMethod(group = "Base")
	public List<Map> deletePrograms1(List<Map> paramList) throws Exception {
		 for(Map param :paramList )	{	
		 super.commonDao.update("bsa610ukrvService.deletePrograms1", param);
		 }
		 tlabMenuService.reload(true);
		 return paramList;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "base")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll2(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
				
		Map<String, Object> rMap;

		if(paramList != null)	{
			List<Map> insertList2 = null;
			List<Map> updateList2 = null;
			List<Map> deleteList2 = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deletePrograms2")) {
					deleteList2 = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insertPrograms2")) {		
					insertList2 = (List<Map>)dataListMap.get("data");		
					
				} else if(dataListMap.get("method").equals("updatePrograms2")) {
					updateList2 = (List<Map>)dataListMap.get("data");	
				} 
			}
			if(deleteList2 != null) this.deletePrograms2(deleteList2);
			if(insertList2 != null) this.insertPrograms2(insertList2,user);
			if(updateList2 != null) this.updatePrograms2(updateList2);				
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "Base")
	public List<Map>  insertPrograms2(List<Map> paramList, LoginVO user) throws Exception {		
		for(Map param :paramList )	{		
			super.commonDao.insert("bsa610ukrvService.insertPrograms2", param);
		}
		tlabMenuService.reload();
		return  paramList;
	}	
	
	@ExtDirectMethod(group = "Base")
	public List<Map> deletePrograms2(List<Map> paramList) throws Exception {
		 for(Map param :paramList )	{	
		 super.commonDao.update("bsa610ukrvService.deletePrograms2", param);
		 }
		 tlabMenuService.reload(true);
		 return paramList;
	}
		
	@ExtDirectMethod(group = "Base")
	public List<Map> updatePrograms2(List<Map> paramList) throws Exception {
		 for(Map param :paramList )	{	
		 super.commonDao.update("bsa610ukrvService.updatePrograms2", param);
		 }
		 tlabMenuService.reload();
		 return paramList;
	} 	
		
	

}
