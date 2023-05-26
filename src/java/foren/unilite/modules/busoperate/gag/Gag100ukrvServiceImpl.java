package foren.unilite.modules.busoperate.gag;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.BindingResult;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;


@Service("gag100ukrvService")
public class Gag100ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger	logger	= LoggerFactory.getLogger(this.getClass());

	@ExtDirectMethod(group = "busoperate", value = ExtDirectMethodType.STORE_READ)
	public List<Map<Object, String>>  searchList(Map param) throws Exception {	
		return  super.commonDao.list("gag100ukrvServiceImpl.searchList", param);
	}
	
	
	@ExtDirectMethod(group = "busoperate", value = ExtDirectMethodType.STORE_READ)
	public List<Map<Object, String>>  selectList(Map param) throws Exception {	
		return  super.commonDao.list("gag100ukrvServiceImpl.selectList", param);
	}
	
	@ExtDirectMethod(group = "busoperate", value = ExtDirectMethodType.STORE_READ)
	public List<Map<Object, String>>  detailList(Map param) throws Exception {	
		return  super.commonDao.list("gag100ukrvServiceImpl.detailList", param);
	}
	
	@ExtDirectMethod(group = "busoperate", value = ExtDirectMethodType.STORE_READ)
	public List<Map<Object, String>>  detailListForCash(Map param) throws Exception {	
		return  super.commonDao.list("gag100ukrvServiceImpl.detailListForCash", param);
	}
	
	@ExtDirectMethod(group = "busoperate", value = ExtDirectMethodType.STORE_READ)
	public Object  checkDate(Map param) throws Exception {	
		return  super.commonDao.select("gag100ukrvServiceImpl.chkPk", param);
	}
	
	@ExtDirectMethod(group = "busoperate", value = ExtDirectMethodType.STORE_SYNCALL)
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		
		List<Map> dataList = new ArrayList<Map>();
		if(paramList != null)	{
			for(Map param: paramList) {
				dataList = (List<Map>)param.get("data");
				if(param.get("method").equals("delete")) {
					param.put("data", delete(dataList) );	
				} 
				if(param.get("method").equals("update")) {
					param.put("data", update(dataList) );	
				} 
				if(param.get("method").equals("insert")) {
					param.put("data", insert(dataList) );	
				} 
			}
		}	
		paramList.add(0, paramMaster);
		return  paramList;
	}
	
	@ExtDirectMethod(group = "busoperate", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map>  insert(List<Map> paramList) throws Exception {		
		for(Map param :paramList )	{
				Map<String, Object> rm = (Map<String, Object>)super.commonDao.queryForObject("gag100ukrvServiceImpl.insert", param);		
				int opTotCnt =  ObjUtils.parseInt(param.get("OPERATION_TOT_COUNT"));
				for(int i=1 ; i <= opTotCnt; i++)	{
					param.put("OPERATION_COUNT", i);
					if(ObjUtils.parseInt( param.get("SELF_CNT")) < i)	{
						param.put("VEHICLE_CODE", "");
						param.put("OTHER_VEHICLE_YN", "Y");
					}else {
						param.put("OTHER_VEHICLE_YN", "N");
					}
					super.commonDao.update("gag100ukrvServiceImpl.insertDetail", param);		
				}
				if( rm != null)	{
					param.put("P_ASSIGN_START_DATE", rm.get("P_ASSIGN_START_DATE"));
					super.commonDao.queryForObject("gag100ukrvServiceImpl.updateDetailDefaults", param);
				}
		}
		return  paramList;
	}
	
	@ExtDirectMethod(group = "busoperate", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map>  update(List<Map> paramList) throws Exception {		
		for(Map param :paramList )	{
			if("Y".equals(ObjUtils.getSafeString( param.get("OTHER_VEHICLE_YN"))) )	{
				param.put("VEHICLE_CODE", "");
			}
			super.commonDao.update("gag100ukrvServiceImpl.update", param);		
		}
		return  paramList;
	}
	
	@ExtDirectMethod(group = "busoperate", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map>  delete(List<Map> paramList) throws Exception {		
		for(Map param :paramList )	{
			super.commonDao.update("gag100ukrvServiceImpl.delete", param);		
		}
		return  paramList;
	}
	
	@ExtDirectMethod(group = "busoperate", value = ExtDirectMethodType.STORE_SYNCALL)
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveDetail(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		
		List<Map> dataList = new ArrayList<Map>();
		if(paramList != null)	{
			for(Map param: paramList) {
				dataList = (List<Map>)param.get("data");
				if(param.get("method").equals("updateDetail")) {
					param.put("data", updateDetail(dataList) );	
				}  
			}
		}	
		paramList.add(0, paramMaster);
		return  paramList;
	}
	
	@ExtDirectMethod(group = "busoperate", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map>  updateDetail(List<Map> paramList) throws Exception {		
		for(Map param :paramList )	{
			super.commonDao.update("gag100ukrvServiceImpl.updateDetail", param);		
		}
		return  paramList;
	}
	
	@ExtDirectMethod(group = "busoperate")
	public Integer  syncAll(Map param) throws Exception {
		logger.debug("syncAll:" + param);
		return  0;
	}
	
	@ExtDirectMethod(group = "busoperate", value = ExtDirectMethodType.STORE_SYNCALL)
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveDetailForCash(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		
		List<Map> dataList = new ArrayList<Map>();
		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map param: paramList) {
				dataList = (List<Map>)param.get("data");
				if(param.get("method").equals("updateDetailForCash")) {
					updateList = (List<Map>)param.get("data");	
				} else if(param.get("method").equals("insertDetailForCash")) {
					insertList = (List<Map>)param.get("data");	
				} else if(param.get("method").equals("deleteDetailForCash")) {
					deleteList = (List<Map>)param.get("data");	
				}
			}
			
			if(deleteList != null) this.deleteDetailForCash(deleteList);	
			if(insertList != null) this.insertDetailForCash(insertList);
			if(updateList != null) this.updateDetailForCash(updateList);		
			
		}	
		paramList.add(0, paramMaster);
		return  paramList;
	}

	@ExtDirectMethod(group = "busoperate", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map>  insertDetailForCash(List<Map> paramList) throws Exception {		
		for(Map param :paramList )	{
			super.commonDao.update("gag100ukrvServiceImpl.insertDetailForCash", param);		
		}
		return  paramList;
	}
	
	@ExtDirectMethod(group = "busoperate", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map>  updateDetailForCash(List<Map> paramList) throws Exception {		
		for(Map param :paramList )	{
			super.commonDao.update("gag100ukrvServiceImpl.updateDetailForCash", param);		
		}
		return  paramList;
	}
	
	@ExtDirectMethod(group = "busoperate", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map>  deleteDetailForCash(List<Map> paramList) throws Exception {		
		for(Map param :paramList )	{
			super.commonDao.update("gag100ukrvServiceImpl.deleteDetailForCash", param);		
		}
		return  paramList;
	}

}
