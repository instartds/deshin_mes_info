package foren.unilite.modules.z_sd;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("s_hpa902rkr_sdcService")
public class S_Hpa902rkr_sdcServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hpa")
	public List<Map<String, Object>> selectSupplyList(Map param) throws Exception {
		String sSetCurrMonthYn = "N";
		
		if(param.containsKey("SET_CURR_MONTH_YN") && param.get("SET_CURR_MONTH_YN").equals("Y"))
			super.commonDao.update("s_hpa902rkr_sdcServiceImpl.updateSupplyListByCurrMonth", param);
		
		return (List) super.commonDao.list("s_hpa902rkr_sdcServiceImpl.selectSupplyList", param);
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hpa")
	public List<Map<String, Object>> selectDeductList(Map param) throws Exception {
		String sSetCurrMonthYn = "N";
		
		if(param.containsKey("SET_CURR_MONTH_YN") && param.get("SET_CURR_MONTH_YN").equals("Y"))
			super.commonDao.update("s_hpa902rkr_sdcServiceImpl.updateDeductListByCurrMonth", param);
		
		return (List) super.commonDao.list("s_hpa902rkr_sdcServiceImpl.selectDeductList", param);
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "hpa")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> syncSupplyList(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		List<Map> updateList = null;
		
		if(paramList != null)   {
			for(Map dataListMap : paramList) {
				if(dataListMap.get("method").equals("updateSupplyList")) {
					updateList = (List<Map>)dataListMap.get("data");
				}
			}
		}

		if(updateList != null) updateSupplyList(updateList, user);
		
//		if(updateList != null) {
//			for(Map param : updateList )	{
//				super.commonDao.insert("s_hpa902rkr_sdcServiceImpl.updateSupplyItem", param);
//			}
//		}
		
		paramList.add(0, paramMaster);

		return paramList;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
	public void updateSupplyList(List<Map> params, LoginVO user) throws Exception {
		for(Map param : params) {
			super.commonDao.update("s_hpa902rkr_sdcServiceImpl.updateSupplyItem", param);
		}

		return;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "hpa")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> syncDeductList(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		List<Map> updateList = null;
		
		if(paramList != null)   {
			for(Map dataListMap : paramList) {
				if(dataListMap.get("method").equals("updateDetail")) {
					updateList = (List<Map>)dataListMap.get("data");
				}
			}
		}

		if(updateList != null) updateDeductList(updateList, user);
		
//		if(updateList != null) {
//			for(Map param : updateList )	{
//				super.commonDao.insert("s_hpa902rkr_sdcServiceImpl.updateDeductItem", param);
//			}
//		}
		
		paramList.add(0, paramMaster);

		return paramList;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
	public void updateDeductList(List<Map> params, LoginVO user) throws Exception {
		for(Map param : params) {
			super.commonDao.update("s_hpa902rkr_sdcServiceImpl.updateDeductItem", param);
		}

		return;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hpa")
	public List<Map<String, Object>> selectPrintList(Map param) throws Exception {
		return (List) super.commonDao.list("s_hpa902rkr_sdcServiceImpl.selectPrintList", param);
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hpa")
	public List<Map<String, Object>> selectPrintHeader(Map param) throws Exception {
		return (List) super.commonDao.list("s_hpa902rkr_sdcServiceImpl.selectPrintHeader", param);
	}

}
