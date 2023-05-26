package foren.unilite.modules.busmaintain.gre;

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
import foren.unilite.com.utils.UniliteUtil;
import ch.ralscha.extdirectspring.util.ParametersResolver;
import foren.framework.extjs.UniliteExtjsUtils;

@Service("gre200ukrvService")
public class Gre200ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger	logger	= LoggerFactory.getLogger(this.getClass());

	/**
	 * 정비내역 목록
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "busmaintain", value = ExtDirectMethodType.STORE_READ)
	public List<Map<Object, String>>  selectList(Map param) throws Exception {	
		return  super.commonDao.list("gre200ukrvServiceImpl.selectList", param);
	}
	
	/**
	 * 정비내역
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "busmaintain", value = ExtDirectMethodType.FORM_LOAD)
	public Object  select(Map param) throws Exception {	
		return  super.commonDao.select("gre200ukrvServiceImpl.select", param);
	}
	
	/**
	 * 정비상세 목록
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "busmaintain")
	public List<Map<Object, String>>  selectDetailList(Map param) throws Exception {	
		return  super.commonDao.list("gre200ukrvServiceImpl.selectDetailList", param);
	}
	
	/**
	 * 정비사원 목록
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "busmaintain")
	public List<Map<Object, String>>  selectMechanicList(Map param) throws Exception {	
		return  super.commonDao.list("gre200ukrvServiceImpl.selectMechanicList", param);
	}
	/**
	 * 정비내역 저장 (Store 저장)
	 * @param paramList
	 * @param paramMaster
	 * @param user
	 * @return
	 * @throws Exception
	 */
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "busmaintain")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
				
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		Map<String, Object> rMap;

		if(dataMaster.get("START_TIME") != null) {
			dataMaster.put("START_TIME",  dataMaster.get("START_TIME").toString().replaceAll("\\:", ""));
		}
		
		if(dataMaster.get("END_TIME") != null) {
			dataMaster.put("END_TIME",  dataMaster.get("END_TIME").toString().replaceAll("\\:", ""));
		}
		if(dataMaster.get("VEHICLE_COUNT") == null 		|| ObjUtils.isEmpty(dataMaster.get("VEHICLE_COUNT"))) 	dataMaster.put("VEHICLE_COUNT",0);
		if(dataMaster.get("RUN_DISTANCE") == null 		|| ObjUtils.isEmpty(dataMaster.get("RUN_DISTANCE"))) 		dataMaster.put("RUN_DISTANCE",0);
		if(dataMaster.get("WORKING_TIME") == null 		|| ObjUtils.isEmpty(dataMaster.get("WORKING_TIME"))) 		dataMaster.put("WORKING_TIME",0);
		if(dataMaster.get("WT_PER_MECHANIC") == null 	|| ObjUtils.isEmpty(dataMaster.get("WT_PER_MECHANIC"))) 	dataMaster.put("WT_PER_MECHANIC",0);
		if(dataMaster.get("WT_PER_VEHICLE") == null 	|| ObjUtils.isEmpty(dataMaster.get("WT_PER_VEHICLE"))) 	dataMaster.put("WT_PER_VEHICLE",0);
		if(dataMaster.get("MECHANIC_NUMBER") == null 	|| ObjUtils.isEmpty(dataMaster.get("MECHANIC_NUMBER"))) 	dataMaster.put("MECHANIC_NUMBER",0);
	
		if(ObjUtils.isEmpty(dataMaster.get("MAINTAIN_NUM")))	{
			rMap = (Map<String, Object>) super.commonDao.queryForObject("gre200ukrvServiceImpl.insert", dataMaster);
			dataMaster.put("MAINTAIN_NUM", rMap.get("MAINTAIN_NUM"));
		}else {
			super.commonDao.update("gre200ukrvServiceImpl.update", dataMaster);
		}
		
		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteDetail")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insertDetail")) {		
					insertList = (List<Map>)dataListMap.get("data");		
					for(Map tmp : insertList)	{
						tmp.put("MAINTAIN_NUM", dataMaster.get("MAINTAIN_NUM"));
					}
				} else if(dataListMap.get("method").equals("updateDetail")) {
					updateList = (List<Map>)dataListMap.get("data");	
				} 
			}
			
			if(deleteList != null) this.deleteDetail(deleteList);
			if(insertList != null) this.insertDetail(insertList);
			if(updateList != null) this.updateDetail(updateList);				
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	/**
	 * 정비내역 저장 (Form 저장)
	 * @param param
	 * @param user
	 * @param result
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "busmaintain" , value = ExtDirectMethodType.FORM_POST)
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public ExtDirectFormPostResult  insertMaster(Gre200ukrvModel param, LoginVO user,  BindingResult result) throws Exception {
			param.setS_COMP_CODE(user.getCompCode());
			param.setS_USER_ID(user.getUserID());
			Map<String, Object> rMap = null;
			
			if(param.getSTART_TIME() != null) {
				param.setSTART_TIME(param.getSTART_TIME().toString().replaceAll("\\:", ""));
			}
			
			if(param.getEND_TIME() != null) {
				param.setEND_TIME(param.getEND_TIME().toString().replaceAll("\\:", ""));
			}
			
			if(param.getVEHICLE_COUNT() == null 	|| ObjUtils.isEmpty(param.getVEHICLE_COUNT())) param.setVEHICLE_COUNT(0);
			if(param.getRUN_DISTANCE() == null 		|| ObjUtils.isEmpty(param.getRUN_DISTANCE())) param.setRUN_DISTANCE(0);
			if(param.getWORKING_TIME() == null 		|| ObjUtils.isEmpty(param.getWORKING_TIME())) param.setWORKING_TIME(0);
			if(param.getWT_PER_MECHANIC() == null 	|| ObjUtils.isEmpty(param.getWT_PER_MECHANIC())) param.setWT_PER_MECHANIC(0);
			if(param.getWT_PER_VEHICLE() == null 	|| ObjUtils.isEmpty(param.getWT_PER_VEHICLE())) param.setWT_PER_VEHICLE(0);
			if(param.getMECHANIC_NUMBER() == null 	|| ObjUtils.isEmpty(param.getMECHANIC_NUMBER())) param.setMECHANIC_NUMBER(0);
			
			if(ObjUtils.isEmpty(param.getMAINTAIN_NUM()))	{
				rMap = (Map<String, Object>) super.commonDao.queryForObject("gre200ukrvServiceImpl.insert", param);
			}else {
				super.commonDao.update("gre200ukrvServiceImpl.update", param);
			}
			ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
			if(ObjUtils.isEmpty(param.getMAINTAIN_NUM()))	{
				extResult.addResultProperty("MAINTAIN_NUM", ObjUtils.getSafeString(rMap.get("MAINTAIN_NUM")));
			}
		return extResult;
	}
	
	
	/**
	 * 정비상세내역 등록
	 * @param paramList
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "busmaintain")
	public Integer  insertDetail(List<Map> paramList) throws Exception {
		for(Map param : paramList) 	{
			super.commonDao.update("gre200ukrvServiceImpl.insertDetail", param);	
		}
		return 0;
	}
	
	/**
	 * 정비상세내역 수정
	 * @param paramList
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "busmaintain")
	public Integer  updateDetail(List<Map> paramList) throws Exception {
		for(Map param : paramList) 	{
			int r = super.commonDao.update("gre200ukrvServiceImpl.updateDetail", param);
		}
		return 0;
	}
	
	/**
	 * 정비상세내역 삭제
	 * @param paramList
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "busmaintain")
	public Integer  deleteDetail(List<Map> paramList) throws Exception {
		for(Map param : paramList) 	{
			int r = super.commonDao.update("gre200ukrvServiceImpl.deleteDetail", param);	
		}
		return 0;
	}
	
	
	
	
	/**
	 * 정비사원 저장
	 * @param param
	 * @return
	 * @throws Exception
	 */
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "busmaintain")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveMechanicAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
				
		Map<String, Object> rMap;

		
		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteMechanic")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insertMechanic")) {		
					insertList = (List<Map>)dataListMap.get("data");		
				} else if(dataListMap.get("method").equals("updateMechanic")) {
					updateList = (List<Map>)dataListMap.get("data");	
				} 
			}
			
			if(deleteList != null) this.deleteMechanic(deleteList);
			if(insertList != null) this.insertMechanic(insertList);
			if(updateList != null) this.updateMechanic(updateList);				
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	/**
	 * 정비사원 등록
	 * @param paramList
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "busmaintain")
	public Integer  insertMechanic(List<Map> paramList) throws Exception {
		for(Map param : paramList) 	{
			super.commonDao.update("gre200ukrvServiceImpl.insertMechanic", param);	
		}
		return 0;
	}
	
	/**
	 * 정비사원 수정
	 * @param paramList
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "busmaintain")
	public Integer  updateMechanic(List<Map> paramList) throws Exception {
		for(Map param : paramList) 	{
			int r = super.commonDao.update("gre200ukrvServiceImpl.updateMechanic", param);
		}
		return 0;
	}
	
	/**
	 * 정비사원 삭제
	 * @param paramList
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "busmaintain")
	public Integer  deleteMechanic(List<Map> paramList) throws Exception {
		for(Map param : paramList) 	{
			int r = super.commonDao.update("gre200ukrvServiceImpl.deleteMechanic", param);	
		}
		return 0;
	}
	
}
