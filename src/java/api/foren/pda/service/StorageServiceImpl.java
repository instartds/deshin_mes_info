package api.foren.pda.service;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.ObjectUtils;
import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.exception.UniDirectException;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;

@Service("storageService")
public class StorageServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	


	
	/**
	 * po master list
	 */
	public List selectPoList(Map param)throws UniDirectException{
		return super.commonDao.list("storageService.selectPoList", param);
	}
	/**
	 * po detail list
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectPoDetailList(Map param) throws Exception {
		return super.commonDao.list("storageService.selectPoDetailList", param);
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveInStorage(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
		logger.debug("[saveAll] paramDetail:" + paramList);

		String keyValue = getLogKey();						
		List<Map> dataList = new ArrayList<Map>();
		List<List<Map>> resultList = new ArrayList<List<Map>>();
		
	
		for(Map param: paramList) {			
			
			String oprFlag =  param.get("CRUD").toString();
				param.put("KEY_VALUE", keyValue);
				param.put("OPR_FLAG", oprFlag);
				
				if(param.get("LOT_ASSIGNED_YN") == null){
					param.put("LOT_ASSIGNED_YN",'Y');
				}
				
				if(oprFlag.equals("N")  && param.get("ACCOUNT_YNC").equals("Y") && !param.get("INOUT_TYPE_DETAIL").equals("91") && param.get("PRICE_YN").equals("Y")){
					if(ObjUtils.parseInt(param.get("ORDER_UNIT_FOR_P"))<= 0){
//						throw new  UniDirectValidateException("입고유형이 금액보정이 아닐때  구매단가가 0 이거나 0보다 작을 수 없습니다");
		    			throw new  UniDirectValidateException(this.getMessage("800004",user));
					}else{
						param.put("data", super.commonDao.insert("storageService.insertLogDetail", param));
					}
				}else{
					if("N".equals(oprFlag) || "D".equals(oprFlag)){
						param.put("data", super.commonDao.insert("storageService.insertLogDetail", param));
					}else{
						param.put("data", super.commonDao.insert("storageService.updateLogDetail", param));
					}
				}
		}
		//4.저장 Stored Procedure 실행
		Map<String, Object> spParam = new HashMap<String, Object>();
		
		spParam.put("KeyValue", keyValue);
		spParam.put("LangCode", user.getLanguage());
		spParam.put("CreateType", "2");
		if("other".equals(paramMaster.get("type"))){
			super.commonDao.queryForObject("storageService.spReceiving_pdm110ukrv", spParam);
		}else{
			super.commonDao.queryForObject("storageService.spReceiving", spParam);
		}
		
		String ErrorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
		
		//마스터번호 update
//		for(Map param : paramList )	{
		if(!ObjUtils.isEmpty(ErrorDesc)){
			paramMaster.put("INOUT_NUM", "");

			String[] messsage = ErrorDesc.split(";");
			paramMaster.put("ERROR", this.getMessage(messsage[0], user));
			paramList.add(0, paramMaster);	
			
		    throw new  Exception(this.getMessage(messsage[0], user));
		} else {
		    logger.debug("[INOUT_NUM" + ObjUtils.getSafeString(spParam.get("InOutNum")));
			//마스터에 SET
		    paramMaster.put("INOUT_NUM", ObjUtils.getSafeString(spParam.get("InOutNum")));
			for(Map param: paramList)  {
				
				param.put("INOUT_NUM", ObjUtils.getSafeString(spParam.get("InOutNum")));
			
	
			}		
			
		}
		paramList.add(0, paramMaster);
		
		return  paramList;
	}
	
	public List<Map<String, Object>> selectItemByBarCode(Map param) {
		return super.commonDao.list("storageService.selectItemByBarCode", param);
	}

	
}
