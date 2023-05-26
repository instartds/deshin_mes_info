package foren.unilite.modules.busoperate.gop;

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


@Service("gop300ukrvService")
public class Gop300ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger	logger	= LoggerFactory.getLogger(this.getClass());

	@ExtDirectMethod(group = "busoperate", value = ExtDirectMethodType.STORE_READ)
	public List<Map<Object, String>>  selectList(Map param) throws Exception {	
		return  super.commonDao.list("gop300ukrvServiceImpl.selectList", param);
	}
	
	@ExtDirectMethod(group = "busoperate", value = ExtDirectMethodType.STORE_READ)
	public List<Map<Object, String>>  summary(Map param) throws Exception {	
		return  super.commonDao.list("gop300ukrvServiceImpl.summary", param);
	}
	
	@ExtDirectMethod(group = "busoperate", value = ExtDirectMethodType.STORE_READ)
	public List<Map<Object, String>>  selectOpChange(Map param) throws Exception {	
		return  super.commonDao.list("gop300ukrvServiceImpl.selectOpChange", param);	
	}	
	
	@ExtDirectMethod(group = "busoperate", value = ExtDirectMethodType.STORE_READ)
	public List<Map<Object, String>>  driverList(Map param) throws Exception {	
		return  super.commonDao.list("gop300ukrvServiceImpl.driverList", param);
	}
	
	@ExtDirectMethod(group = "busoperate", value = ExtDirectMethodType.STORE_READ)
	public List<Map<Object, String>>  busList(Map param) throws Exception {	
		return  super.commonDao.list("gop300ukrvServiceImpl.busList", param);
	}
	
	@ExtDirectMethod(group = "busoperate", value = ExtDirectMethodType.STORE_SYNCALL)
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		
		List<Map> dataList = new ArrayList<Map>();
		if(paramList != null)	{
			for(Map param: paramList) {
				dataList = (List<Map>)param.get("data");
				if(param.get("method").equals("update")) {
					param.put("data", update(dataList) );	
				} 
			}
		}	
		paramList.add(0, paramMaster);
		return  paramList;
	}
	
	@ExtDirectMethod(group = "busoperate", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map>  update(List<Map> paramList) throws Exception {		
		for(Map param :paramList )	{
			String departureTime =  ObjUtils.getSafeString(param.get("DEPARTURE_TIME"));
			String dutyFrTime =  ObjUtils.getSafeString(param.get("DUTY_FR_TIME"));
			String dutyToTime =  ObjUtils.getSafeString(param.get("DUTY_TO_TIME"));
			
			param.put("DEPARTURE_TIME", ObjUtils.getSafeString(param.get("DEPARTURE_TIME")).replaceAll("\\:", "") );
			param.put("DUTY_FR_TIME", ObjUtils.getSafeString(param.get("DUTY_FR_TIME")).replaceAll("\\:", "") );
			param.put("DUTY_TO_TIME", ObjUtils.getSafeString(param.get("DUTY_TO_TIME")).replaceAll("\\:", "") );
			super.commonDao.update("gop300ukrvServiceImpl.update", param);		
			
			param.put("DEPARTURE_TIME", departureTime );
			param.put("DUTY_FR_TIME", dutyFrTime );
			param.put("DUTY_TO_TIME", dutyToTime );
		}
		return  paramList;
	}
	
	@ExtDirectMethod(group = "busoperate", value = ExtDirectMethodType.STORE_READ)
	public List<Map<Object, String>>  selectConfirmList(Map param) throws Exception {	
		return  super.commonDao.list("gop300ukrvServiceImpl.selectConfirmList", param);
	}
	
	@ExtDirectMethod(group = "busoperate", value = ExtDirectMethodType.STORE_SYNCALL)
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAllConfirm(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		
		List<Map> dataList = new ArrayList<Map>();
		if(paramList != null)	{
			for(Map param: paramList) {
				dataList = (List<Map>)param.get("data");
				if(param.get("method").equals("updateConfirm")) {
					param.put("data", updateConfirm(dataList) );	
				} 
			}
		}	
		paramList.add(0, paramMaster);
		return  paramList;
	}
	
	@ExtDirectMethod(group = "busoperate", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map>  updateConfirm(List<Map> paramList) throws Exception {		
		for(Map param :paramList )	{
			super.commonDao.update("gop300ukrvServiceImpl.updateConfirm", param);		
		}
		return  paramList;
	}
	
	@ExtDirectMethod(group = "busoperate", value = ExtDirectMethodType.STORE_READ)
	public List<Map<Object, String>>  selectRouteList(Map param) throws Exception {	
		return  super.commonDao.list("gop300ukrvServiceImpl.selectRouteList", param);
	}
	
}
