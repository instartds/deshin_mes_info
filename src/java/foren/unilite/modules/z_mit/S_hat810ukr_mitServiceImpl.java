package foren.unilite.modules.z_mit;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

import org.slf4j.Logger;

import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.GStringUtils;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;


@Service("s_hat810ukr_mitService")
public class S_hat810ukr_mitServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@ExtDirectMethod(group = "z_mit")
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		List<Map<String, Object>> rList = null;
		rList = super.commonDao.list("s_hat810ukr_mitServiceImpl.selectList", param);
		if(rList == null || (rList != null && rList.size() == 0))	{
			Map checkCnt = this.selectCheckNewList(param);
			if(checkCnt != null && ObjUtils.parseInt(checkCnt.get("CNT")) > 0  )	{
				return   new ArrayList<Map<String,Object>>();
			} else {
				rList = super.commonDao.list("s_hat810ukr_mitServiceImpl.selectNewDataList", param);
			}
		}
		return   rList;
	}
	
	/**
	 * 신규여부
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_mit")
	public Map selectCheckNewList(Map param) throws Exception {
		return  (Map) super.commonDao.select("s_hat810ukr_mitServiceImpl.selectCheckNewDataList", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "z_mit")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		//Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		
		if(paramList != null)	{
			List<Map> updateList = null;
			List<Map> insertList = null;
			List<Map> deleteList = null;
			
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("updateList")) {
					updateList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insertList")) {
					insertList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("deleteList")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}
			}			
			if(deleteList != null) this.deleteList(deleteList, user);
			if(updateList != null) this.updateList(updateList, user);	
			if(insertList != null) this.insertList(insertList, user);	
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	/**
	 * 수정
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_mit")
	public List<Map> updateList(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param :paramList )	{
			String dutyYymm = ObjUtils.getSafeString(param.get("DUTY_YYMM"));
			param.put("DUTY_YYMM", GStringUtils.replace(dutyYymm, ".", ""));
			super.commonDao.update("s_hat810ukr_mitServiceImpl.updateList", param);		
			param.put("DUTY_YYMM",dutyYymm);
			param.put("FLAG", "");
		}
		return paramList;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_mit")
	public List<Map> deleteList(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param :paramList )	{	
			String dutyYymm = ObjUtils.getSafeString(param.get("DUTY_YYMM"));
			param.put("DUTY_YYMM", GStringUtils.replace(dutyYymm, ".", ""));
			super.commonDao.update("s_hat810ukr_mitServiceImpl.deleteList", param);	
		}
		return paramList;
	}
	/**
	 * 추가
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_mit")
	public List<Map> insertList(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param :paramList )	{			
			String dutyYymm = ObjUtils.getSafeString(param.get("DUTY_YYMM"));
			param.put("DUTY_YYMM", GStringUtils.replace(dutyYymm, ".", ""));
			super.commonDao.update("s_hat810ukr_mitServiceImpl.insertList", param);	
			param.put("DUTY_YYMM",dutyYymm);
		}
		return paramList;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_mit")
	public Map deleteAll(Map param,  LoginVO user) throws Exception {
		param.put("DUTY_YYMM", GStringUtils.replace(ObjUtils.getSafeString(param.get("DUTY_YYMM")), ".", ""));
		super.commonDao.delete("s_hat810ukr_mitServiceImpl.deleteAll", param);
		return param;
	}
	@ExtDirectMethod(group = "z_mit")
	public Object getLongYearSave_mit(Map param,  LoginVO user) throws Exception {
		return	super.commonDao.select("s_hat810ukr_mitServiceImpl.getLongYearSave_mit", param);	
	}

}
	
