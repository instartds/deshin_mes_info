package foren.unilite.modules.sales.sgp;

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

@Service("sgp101ukrvService")
public class Sgp101ukrvServiceImpl extends TlabAbstractServiceImpl  {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@Resource(name = "fileMnagerService")
	private FileMnagerService fileMnagerService;
		
	
	/**
	 * 고객별 정보 조회
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "base")
	public List<Map> selectList(Map param, LoginVO user) throws Exception {
		return  super.commonDao.list("sgp101ukrvService.selectList", param);
	}
	/**
	 * 확정여부 정보 조회(확정취소 일때)
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "base")
	public List<Map> selectConfirmN(Map param, LoginVO user) throws Exception {
		return  super.commonDao.list("sgp101ukrvService.selectConfirmN", param);
	}
	/**
	 * 기초데이터 대상 부서 조회
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "base")
	public List<Map> createBaseData(Map param, LoginVO user) throws Exception {
		return  super.commonDao.list("sgp101ukrvService.createBaseData", param);
	}

	/**
	 * 확정여부 정보 조회(확정할때)
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "base")
	public List<Map> selectConfirmY(Map param, LoginVO user) throws Exception {
		return  super.commonDao.list("sgp101ukrvService.selectConfirmY", param);
	}
	
	/**
	 * 확정여부 'N'으로 set
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")
	public void confirmSetN(Map param, LoginVO user) throws Exception {
		 super.commonDao.update("sgp101ukrvService.confirmSetN", param);	
	}
	
	/**
	 * 확정여부 'Y'으로 set
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")
	public void confirmSetY(Map param, LoginVO user) throws Exception {
		 super.commonDao.update("sgp101ukrvService.confirmSetY", param);	
	}
	
	
	
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "busmaintain")
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
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")
	public Integer  insertDetail(List<Map> paramList, LoginVO user) throws Exception {		
		try {			
			for(Map param : paramList )	{
				super.commonDao.update("sgp101ukrvService.insertDetail", param);				 				 
			}	
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("2627", user));
		}		
		return 0;
	}	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")
	public Integer updateDetail(List<Map> paramList, LoginVO user) throws Exception {		
		 for(Map param :paramList )	{
			 super.commonDao.update("sgp101ukrvService.updateDetail", param);			 
		 }
		 return 0;
	} 
	
	
	@ExtDirectMethod(group = "base", needsModificatinAuth = true)
	public Integer deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {		
		 for(Map param :paramList )	{			 
			 try {
				 super.commonDao.delete("sgp101ukrvService.deleteDetail", param);				 						
			 }catch(Exception e)	{
	    			throw new  UniDirectValidateException(this.getMessage("547",user));
	    	}
		 }
		 return 0;
	}
	
}
