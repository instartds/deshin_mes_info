package foren.unilite.modules.cost.cbm;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.service.impl.TlabCodeService;
import foren.unilite.com.validator.UniDirectValidateException;

@Service("cbm020ukrvService")
public class Cbm020ukrvServiceImpl extends TlabAbstractServiceImpl {
	
	@Resource( name = "tlabCodeService" )
    protected TlabCodeService tlabCodeService;
	
	@ExtDirectMethod(group = "cost", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList1(Map param, LoginVO loginVO) throws Exception {
		
		CodeInfo codeInfo = tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO applyUnit = codeInfo.getCodeInfo("CC06","ref_code1", "Y");
		param.put("APPLYUNIT", applyUnit.getCodeNo());
		return super.commonDao.list("cbm020ukrvServiceImpl.selectList1", param);
	}
	
	@ExtDirectMethod(group = "cost", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectCopy1(Map param, LoginVO loginVO) throws Exception {
		CodeInfo codeInfo = tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO applyUnit = codeInfo.getCodeInfo("CC06","ref_code1", "Y");
		List<Map<String, Object>> rList ;
		if("02".equals(applyUnit.getCodeNo()) )	{
			rList = super.commonDao.list("cbm020ukrvServiceImpl.selectCopy1", param);
		} else {
			rList = super.commonDao.list("cbm020ukrvServiceImpl.selectCopy1_110", param);
		}
		return rList;
	}
	@ExtDirectMethod(group = "cost", value = ExtDirectMethodType.STORE_SYNCALL)
	public List<Map> saveAll1(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		 if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			
			CodeInfo codeInfo = tlabCodeService.getCodeInfo(user.getCompCode());
			CodeDetailVO applyUnit = codeInfo.getCodeInfo("CC06","ref_code1", "Y");
			String strApplyUnit = applyUnit.getCodeNo();
			
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteDetail1")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insertDetail1")) {		
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("updateDetail1")) {
					updateList = (List<Map>)dataListMap.get("data");	
				} 
			}
			
			Map paramMasterData = (Map) paramMaster.get("data");
			if("02".equals(strApplyUnit))	{	
				if("Y".equals(ObjUtils.getSafeString(paramMasterData.get("isCopy"))))	{
					this.deleteCopyDetail1(paramMasterData);
				}
			
				if(insertList != null) this.insertDetail1(insertList, user);
				if(updateList != null) this.updateDetail1(updateList, user);			
			} else {
				if("Y".equals(ObjUtils.getSafeString(paramMasterData.get("isCopy"))))	{
					this.deleteCopyDetail1_110(paramMasterData);
				}
			
				if(insertList != null) this.insertDetail1_110(insertList, user);
				if(updateList != null) this.updateDetail1_110(updateList, user);			
			}
		}
	 	paramList.add(0, paramMaster);
	 	return  paramList;
	}	

	@ExtDirectMethod(group = "cost", value = ExtDirectMethodType.STORE_MODIFY)		// INSERT
	public Integer insertDetail1(List<Map> paramList, LoginVO user) throws Exception {		
		for(Map param :paramList )	{	
			super.commonDao.update("cbm020ukrvServiceImpl.insertDetail1", param);
		}
		return 0;
	}	
	
	@ExtDirectMethod(group = "cost", value = ExtDirectMethodType.STORE_MODIFY)		// UPDATE
	public Integer updateDetail1(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param :paramList )	{	
			super.commonDao.update("cbm020ukrvServiceImpl.updateDetail1", param);
		}
		 return 0;
	} 
	
	@ExtDirectMethod(group = "cost", value = ExtDirectMethodType.STORE_MODIFY)		// DELETE
	public Integer deleteDetail1(Map param) throws Exception {
		return 0;
	}

	@ExtDirectMethod(group = "cost", value = ExtDirectMethodType.STORE_MODIFY)		// DELETE
	public Integer deleteCopyDetail1(Map param) throws Exception {
		super.commonDao.update("cbm020ukrvServiceImpl.deleteCopyDetail1", param);
		return 0;
	}
	
	@ExtDirectMethod(group = "cost", value = ExtDirectMethodType.STORE_MODIFY)		// INSERT
	public Integer insertDetail1_110(List<Map> paramList, LoginVO user) throws Exception {		
		for(Map param :paramList )	{	
			super.commonDao.update("cbm020ukrvServiceImpl.insertDetail1_110", param);
		}
		return 0;
	}	
	
	@ExtDirectMethod(group = "cost", value = ExtDirectMethodType.STORE_MODIFY)		// UPDATE
	public Integer updateDetail1_110(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param :paramList )	{	
			super.commonDao.update("cbm020ukrvServiceImpl.updateDetail1_110", param);
		}
		 return 0;
	} 

	@ExtDirectMethod(group = "cost", value = ExtDirectMethodType.STORE_MODIFY)		// DELETE
	public Integer deleteCopyDetail1_110(Map param) throws Exception {
		super.commonDao.update("cbm020ukrvServiceImpl.deleteCopyDetail1_110", param);
		return 0;
	}
	
	
	@ExtDirectMethod(group = "cost", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList2(Map param) throws Exception {
		return super.commonDao.list("cbm020ukrvServiceImpl.selectList2", param);
	}

	@ExtDirectMethod(group = "cost", value = ExtDirectMethodType.STORE_SYNCALL)
	public List<Map> saveAll2(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		 if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteDetail2")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insertDetail2")) {		
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("updateDetail2")) {
					updateList = (List<Map>)dataListMap.get("data");	
				} 
			}			
			if(deleteList != null) this.deleteDetail2(deleteList, user);
			if(insertList != null) this.insertDetail2(insertList, user);
			if(updateList != null) this.updateDetail2(updateList, user);				
		}
	 	paramList.add(0, paramMaster);
	 	return  paramList;
	}	

	@ExtDirectMethod(group = "cost", value = ExtDirectMethodType.STORE_MODIFY)		// INSERT
	public Integer insertDetail2(List<Map> paramList, LoginVO user) throws Exception {		
		for(Map param :paramList )	{	
			super.commonDao.update("cbm020ukrvServiceImpl.insertDetail2", param);
		}
		return 0;
	}	
	
	@ExtDirectMethod(group = "cost", value = ExtDirectMethodType.STORE_MODIFY)		// UPDATE
	public Integer updateDetail2(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param :paramList )	{	
			super.commonDao.update("cbm020ukrvServiceImpl.updateDetail2", param);
		}
		 return 0;
	} 
	
	@ExtDirectMethod(group = "cost", value = ExtDirectMethodType.STORE_MODIFY)		// DELETE
	public Integer deleteDetail2(List<Map> paramList,  LoginVO user) throws Exception {
		for(Map param :paramList )	{	
			super.commonDao.update("cbm020ukrvServiceImpl.deleteDetail2", param);
		}
		return 0;
	}

}