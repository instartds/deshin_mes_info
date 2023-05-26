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
import foren.unilite.com.validator.UniDirectValidateException;


@Service("gop200ukrvService")
public class Gop200ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger	logger	= LoggerFactory.getLogger(this.getClass());

	@ExtDirectMethod(group = "busoperate", value = ExtDirectMethodType.STORE_READ)
	public List<Map<Object, String>>  selectList(Map param) throws Exception {	
		return  super.commonDao.list("gop200ukrvServiceImpl.selectList", param);
	}
	
	@ExtDirectMethod(group = "busoperate", value = ExtDirectMethodType.STORE_READ)
	public List<Map<Object, String>>  driverList(Map param) throws Exception {	
		return  super.commonDao.list("gop200ukrvServiceImpl.driverList", param);
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
			param.put("OPERATION_DATE", ObjUtils.getSafeString(param.get("OPERATION_DATE")).replaceAll("\\.", "") );
			
			String firstDepartureTime = ObjUtils.getSafeString(param.get("FIRST_DEPARTURE_TIME")).replaceAll("\\:", "");
			if(firstDepartureTime.length()==4) 		param.put("FIRST_DEPARTURE_TIME",  firstDepartureTime);//firstDepartureTime = firstDepartureTime;
			else if(firstDepartureTime.length() > 4) param.put("FIRST_DEPARTURE_TIME",  firstDepartureTime.substring(0, 4));
			
			String lastDepartureTime = ObjUtils.getSafeString(param.get("LAST_DEPARTURE_TIME")).replaceAll("\\:", "");
			if(lastDepartureTime.length()==4) 		param.put("LAST_DEPARTURE_TIME",  lastDepartureTime);//lastDepartureTime = lastDepartureTime;
			else if(lastDepartureTime.length() > 4) param.put("LAST_DEPARTURE_TIME",  lastDepartureTime.substring(0, 4));
			
			String dutyFrTime = ObjUtils.getSafeString(param.get("DUTY_FR_TIME")).replaceAll("\\:", "") ;
			if(dutyFrTime.length()==4) 			param.put("DUTY_FR_TIME", dutyFrTime);//dutyFrTime = dutyFrTime;
			else if(dutyFrTime.length() > 4) 	param.put("DUTY_FR_TIME", dutyFrTime.substring(0, 4));
			
			String dutyToTime = ObjUtils.getSafeString(param.get("DUTY_TO_TIME")).replaceAll("\\:", "");
			if(dutyToTime.length()==4) 		 param.put("DUTY_TO_TIME",  dutyToTime); //dutyToTime = dutyToTime;
			else if(dutyToTime.length() > 4) param.put("DUTY_TO_TIME",  dutyToTime.substring(0, 4));
			
			super.commonDao.update("gop200ukrvServiceImpl.update", param);		
		}
		return  paramList;
	}
	
	@ExtDirectMethod(group = "busoperate", value = ExtDirectMethodType.STORE_READ)
	public List<Map<Object, String>>  selectConfirmList(Map param) throws Exception {	
		return  super.commonDao.list("gop200ukrvServiceImpl.selectConfirmList", param);
	}
	
	@ExtDirectMethod(group = "busoperate", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map>  updateConfirm(List<Map> paramList, LoginVO user) throws Exception {		
		for(Map param :paramList )	{
			String keyValue = getLogKey();	
			param.put("KEY_VALUE", keyValue);
			super.commonDao.update("gop200ukrvServiceImpl.saveConfirm", param);		
			super.commonDao.update("gop200ukrvServiceImpl.confirm", param);		
			
			String errorDesc = ObjUtils.getSafeString(param.get("ErrorDesc"));
			if(ObjUtils.isNotEmpty(errorDesc)){				
				String messsage = errorDesc.replaceAll("\\;", "");
				throw new  UniDirectValidateException(this.getMessage(messsage, user));
			}
		}
		return  paramList;
	}

}
