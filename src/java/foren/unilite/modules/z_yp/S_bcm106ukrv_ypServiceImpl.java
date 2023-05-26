package foren.unilite.modules.z_yp;

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

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.sec.license.LicenseManager;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.utils.UniliteUtil;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.com.fileman.FileMnagerService;

@Service("s_bcm106ukrv_ypService")
@SuppressWarnings({"unchecked", "rawtypes"})
public class S_bcm106ukrv_ypServiceImpl extends TlabAbstractServiceImpl  {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Resource(name = "fileMnagerService")
	private FileMnagerService fileMnagerService;
	
	/**
	 * 조회
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_yp")
	public List<Map> selectList(Map param, LoginVO user) throws Exception {
		return  super.commonDao.list("s_bcm106ukrv_ypServiceImpl.selectList", param);
	}
    
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "z_yp")
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
			if(updateList != null) this.updateDetail(updateList, paramMaster, user);				
			if(insertList != null) this.insertDetail(insertList, paramMaster, user);
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_yp")		// INSERT
	public Integer  insertDetail(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {		
		try {			
    		for(Map param : paramList )	{
				String farmCode = (String) super.commonDao.select("s_bcm106ukrv_ypServiceImpl.getFarmCode", param);
//				if(farmCode.equals("1")) {
//					farmCode = "01";
//				}
				param.put("FARM_CODE", farmCode);
				super.commonDao.update("s_bcm106ukrv_ypServiceImpl.insertDetail", param);
			}    			
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("2627", user));
		}		
		return 0;
	}	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_yp")		// UPDATE
	public Integer updateDetail(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		 for(Map param :paramList )	{	
				 super.commonDao.update("s_bcm106ukrv_ypServiceImpl.updateDetail", param);
		 }
		 return 0;
	} 
	
	
	@ExtDirectMethod(group = "z_yp", needsModificatinAuth = true)		// DELETE
	public Integer deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {
		 for(Map param :paramList )   {
             try {
                 super.commonDao.delete("s_bcm106ukrv_ypServiceImpl.deleteDetail", param);
             }catch(Exception e)    {
                    throw new  UniDirectValidateException(this.getMessage("547",user));
             }
         }
		 return 0;
	}
	
}
