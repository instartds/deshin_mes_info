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


@Service("gop100ukrvService")
public class Gop100ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger	logger	= LoggerFactory.getLogger(this.getClass());

	@ExtDirectMethod(group = "busoperate", value = ExtDirectMethodType.STORE_READ)
	public List<Map<Object, String>>  selectList(Map param) throws Exception {	
		return  super.commonDao.list("gop100ukrvServiceImpl.selectList", param);
	}
	
	@ExtDirectMethod(group = "busoperate", value = ExtDirectMethodType.STORE_READ)
	public List<Map<Object, String>>  selectListForXls(Map param) throws Exception {	
		return  super.commonDao.list("gop100ukrvServiceImpl.selectListForXls", param);
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
			logger.debug(" ObjUtils.getSafeString(param.get(OPERATION_DATE)) : "+ ObjUtils.getSafeString(param.get("OPERATION_DATE")) );
			logger.debug(" ObjUtils.getSafeString(param.get(OPERATION_DATE)).replaceAll : "+ ObjUtils.getSafeString(param.get("OPERATION_DATE")).replaceAll("\\.", "") );
			param.put("OPERATION_DATE", ObjUtils.getSafeString(param.get("OPERATION_DATE")).replaceAll("\\.", "") );
			super.commonDao.update("gop100ukrvServiceImpl.update", param);		
		}
		return  paramList;
	}
	
	@ExtDirectMethod(group = "busoperate", value = ExtDirectMethodType.STORE_READ)
	public List<Map<Object, String>>  selectConfirmList(Map param) throws Exception {	
		return  super.commonDao.list("gop100ukrvServiceImpl.selectConfirmList", param);
	}
	/*
	@ExtDirectMethod(group = "busoperate", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map>  updateConfirm(List<Map> paramList) throws Exception {		
		for(Map param :paramList )	{			
			super.commonDao.update("gop100ukrvServiceImpl.updateConfirm", param);		
		}
		return  paramList;
	}*/
	
	@ExtDirectMethod(group = "busoperate", value = ExtDirectMethodType.STORE_SYNCALL)
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveConfirm(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		
		List<Map> dataList = new ArrayList<Map>();
		if(paramList != null)	{
			for(Map param: paramList) {
				dataList = (List<Map>)param.get("data");
				if(param.get("method").equals("updateConfirm")) {
					param.put("data", updateConfirm(dataList, user) );	
				} 
			}
		}		
		paramList.add(0, paramMaster);
		return  paramList;
	}
	
	@ExtDirectMethod(group = "busoperate", value = ExtDirectMethodType.STORE_MODIFY)
	public  List<Map>  updateConfirm(List<Map> paramList, LoginVO user) throws Exception {				
		for(Map param :paramList )	{
			String keyValue = getLogKey();	
			param.put("KEY_VALUE", keyValue);
			if( !"Y".equals(ObjUtils.getSafeString(param.get("CONFIRM_END")) ) ) 	{
				super.commonDao.update("gop100ukrvServiceImpl.saveConfirm", param);		
				super.commonDao.update("gop100ukrvServiceImpl.confirm", param);	
			}
		}
		return  paramList;
	}
	
	@ExtDirectMethod(group = "busoperate", value = ExtDirectMethodType.STORE_MODIFY)
	public Object  excuteData(Map param, LoginVO user) throws Exception {		
	
		String keyValue = getLogKey();	
		
		param.put("KEY_VALUE", keyValue);
		
		// 로그테이블 저장
		super.commonDao.update("gop100ukrvServiceImpl.saveAllocation", param);	
		
		//배차프로시저실행
		super.commonDao.update("gop100ukrvServiceImpl.operationVehicleAllocation", param);
		/*String errorDesc = ObjUtils.getSafeString(param.get("ErrorDesc"));
		if(ObjUtils.isNotEmpty(errorDesc)){				
			String[] messsage = errorDesc.split(";");
			if(messsage != null && messsage.length > 0)	{
				throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
			}
		}*/
		return param;
	}
}
