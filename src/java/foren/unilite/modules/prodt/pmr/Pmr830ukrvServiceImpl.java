package foren.unilite.modules.prodt.pmr;

import java.util.HashMap;
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
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.com.fileman.FileMnagerService;

@Service("pmr830ukrvService")
public class Pmr830ukrvServiceImpl extends TlabAbstractServiceImpl  {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@Resource(name = "fileMnagerService")
	private FileMnagerService fileMnagerService;
	
	/**
	 * 신용카드사정보 조회
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map> selectDetailList(Map param, LoginVO user) throws Exception {
		return  super.commonDao.list("pmr830ukrvService.selectDetailList", param);
	}
		
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "prodt")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
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
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")
	public Integer  insertDetail(List<Map> paramList, LoginVO user) throws Exception {		
		try {			
			for(Map param : paramList )	{					
				 super.commonDao.update("pmr830ukrvService.insertDetail", param);
			}	
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("해당 작업장 점검시간의 생산일지가 등록되어 있습니다. ", user));
		}		
		return 0;
	}	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")
	public Integer updateDetail(List<Map> paramList, LoginVO user) throws Exception {		
		 for(Map param :paramList )	{
			 super.commonDao.update("pmr830ukrvService.updateDetail", param);
		 }
		 return 0;
	} 
	
	
	@ExtDirectMethod(group = "prodt", needsModificatinAuth = true)
	public Integer deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {		
		//try {
			for(Map param :paramList )	{
				super.commonDao.delete("pmr830ukrvService.deleteDetail", param);						
			 }
		// }
/*		 catch(Exception e){
 			throw new  UniDirectValidateException(this.getMessage("547",user));
		 }*/
		 return 0;
	}
		

}
