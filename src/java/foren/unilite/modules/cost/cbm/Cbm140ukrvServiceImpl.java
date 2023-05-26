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
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.tags.ComboItemModel;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.cost.CostCommonServiceImpl;

@Service("cbm140ukrvService")
public class Cbm140ukrvServiceImpl extends TlabAbstractServiceImpl {
	@Resource(name = "costCommonService")
    private CostCommonServiceImpl costCommonService;
	
	@ExtDirectMethod(group = "cost", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList1(Map param, LoginVO user) throws Exception {
		this.addAllocationCostPoolList(param, user);
		return super.commonDao.list("cbm140ukrvServiceImpl.selectList1", param);
	}
	@ExtDirectMethod(group = "cost", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectCopy1(Map param, LoginVO user) throws Exception {
		this.addAllocationCostPoolList(param, user);
		return super.commonDao.list("cbm140ukrvServiceImpl.selectCopy1", param);
	}
	@ExtDirectMethod(group = "cost", value = ExtDirectMethodType.STORE_SYNCALL)
	public List<Map> saveAll1(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		 if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			Map paramData = (Map) paramMaster.get("data");
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteDetail1")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insertDetail1")) {		
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("updateDetail1")) {
					updateList = (List<Map>)dataListMap.get("data");	
				} 
			}
			
			if("Y".equals(paramMaster.get("isCopy")))	{
				this.deleteCopyDetail1(paramMaster);
			}

			if(insertList != null) this.insertDetail1(insertList, paramData, user);
			if(updateList != null) this.updateDetail1(updateList, paramData, user);				
		}
	 	paramList.add(0, paramMaster);
	 	return  paramList;
	}	

	@ExtDirectMethod(group = "cost", value = ExtDirectMethodType.STORE_MODIFY)		// INSERT
	public Integer insertDetail1(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {		
		Map allocationMap = this.addAllocationCostPoolList(paramMaster, user);
		String[] allocationList = (String[]) allocationMap.get("ALLOCATION_COST_POOL_LIST");
		for(Map param :paramList )	{
			super.commonDao.update("cbm140ukrvServiceImpl.insertDetail1", param);
			if("51".equals(ObjUtils.getSafeString(param.get("ALLOCATION_CODE"))))	{
				for(String allocationCostPool : allocationList){
					Object value = param.get("ALLOCATION_COST_POOL_"+allocationCostPool);
					if(value != null)	{
						param.put("ALLOCATION_COST_POOL", allocationCostPool);
						param.put("ALLOCATION_VALUE", value);
						super.commonDao.update("cbm140ukrvServiceImpl.insertDetail2", param);
					}
				}
			}
		}
		return 0;
	}	
	
	@ExtDirectMethod(group = "cost", value = ExtDirectMethodType.STORE_MODIFY)		// UPDATE
	public Integer updateDetail1(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		Map allocationMap = this.addAllocationCostPoolList(paramMaster, user);
		String[] allocationList = (String[]) allocationMap.get("ALLOCATION_COST_POOL_LIST");
		for(Map param :paramList )	{	
			super.commonDao.update("cbm140ukrvServiceImpl.updateDetail1", param);
			if("51".equals(ObjUtils.getSafeString(param.get("ALLOCATION_CODE"))))	{
				for(String allocationCostPool : allocationList){
					Object value = param.get("ALLOCATION_COST_POOL_"+allocationCostPool);
					if(value != null)	{
						param.put("ALLOCATION_COST_POOL", allocationCostPool);
						param.put("ALLOCATION_VALUE", value);
						super.commonDao.update("cbm140ukrvServiceImpl.updateDetail2", param);
					}
				}
			}
		}
		 return 0;
	} 
	
	@ExtDirectMethod(group = "cost", value = ExtDirectMethodType.STORE_MODIFY)		// DELETE
	public Integer deleteDetail1(Map param) throws Exception {
		return 0;
	}

	@ExtDirectMethod(group = "cost", value = ExtDirectMethodType.STORE_MODIFY)		// DELETE
	public Integer deleteCopyDetail1(Map param) throws Exception {
		super.commonDao.update("cbm140ukrvServiceImpl.deleteCopyDetail1", param);
		return 0;
	}
	
	private Map addAllocationCostPoolList(Map param, LoginVO user)	 throws Exception {
		Map paramMap = new HashMap();
		paramMap.put("S_COMP_CODE", user.getCompCode());
 		paramMap.put("USE_YN", "Y");
 		paramMap.put("ALLOCATION_YN", "Y");
 		paramMap.put("DIV_CODE", param.get("DIV_CODE"));
		List<Map> allocationCosts = super.commonDao.list("cbm140ukrvServiceImpl.getCostPool", paramMap);
		String[] allocationCostArr = new String[allocationCosts.size()];
		if(allocationCosts != null && allocationCosts.size() > 0)	{
			for(int i = 0 ; i < allocationCosts.size(); i++ )	{
				Map item = allocationCosts.get(i);
				allocationCostArr[i] = ObjUtils.getSafeString(item.get("COST_POOL_CODE"));
			}
			if(param == null)	{
				param = new HashMap();
			}
			param.put("ALLOCATION_COST_POOL_LIST",  allocationCostArr);
		}
		return param;
	}
	
	@ExtDirectMethod(group = "cost")
	protected List<Map> getCostPools(Map param, LoginVO user)	{
		return super.commonDao.list("cbm140ukrvServiceImpl.getCostPool", param);
	}

	/**
	 * 파일 생성전 validation 체크
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Map<String, Object> fnCopyPrevMonth(Map param, LoginVO user) throws Exception {
		Map<String, Object>  spResult = new HashMap();
		Map result = new HashMap();
		String errorDesc = "";
		
		spResult = (Map) super.commonDao.select("cbm140ukrvServiceImpl.fnCopyPrevMonth", param);
		errorDesc = (String) spResult.get("ERROR_DESC");
		
		if(!ObjUtils.isEmpty(errorDesc)){
			String[] messsage = errorDesc.split(";");
			throw new UniDirectValidateException(this.getMessage(messsage[0], user));
		}
		result.put("ERROR_DESC", "success");
		
		return result;
	}
}