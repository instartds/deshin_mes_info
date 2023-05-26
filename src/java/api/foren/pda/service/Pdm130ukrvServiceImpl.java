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

@Service("pdm130ukrvService")
public class Pdm130ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	
	
	/**
	 * po master list
	 */
	public List selectPoList(Map param)throws UniDirectException{
		return super.commonDao.list("pdm130ukrvService.selectPoList", param);
	}
	/**
	 * po detail list
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectPoDetailList(Map param) throws Exception {
		return super.commonDao.list("pdm130ukrvService.selectPoDetailList", param);
	}


	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveReceiptItem(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
		logger.debug("[saveAll] paramDetail:" + paramList);

		String keyValue = getLogKey();						
		List<Map> dataList = new ArrayList<Map>();
		List<List<Map>> resultList = new ArrayList<List<Map>>();
		
	
		for(Map param: paramList) {			
			
			String oprFlag =  param.get("CRUD").toString();
				param.put("KEY_VALUE", keyValue);
				param.put("OPR_FLAG", oprFlag);
				
				if("N".equals(oprFlag) || "D".equals(oprFlag)){
					param.put("data", super.commonDao.insert("pdm130ukrvServiceImpl.insertLogMaster", param));
				}else{
					param.put("data", super.commonDao.insert("pdm130ukrvServiceImpl.updateLogDetail", param));
				}
		}
		//4.저장 Stored Procedure 실행
		Map<String, Object> spParam = new HashMap<String, Object>();

		spParam.put("KeyValue", keyValue);
		spParam.put("LangCode", user.getLanguage());

		super.commonDao.queryForObject("pdm130ukrvServiceImpl.spImportReceipt", spParam);

		
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
		    logger.debug("[RECEIPT_NUM" + ObjUtils.getSafeString(spParam.get("RECEIPT_NUM")));
			//마스터에 SET
		    paramMaster.put("RECEIPT_NUM", ObjUtils.getSafeString(spParam.get("RECEIPT_NUM")));
			for(Map param: paramList)  {
				param.put("RECEIPT_NUM", ObjUtils.getSafeString(spParam.get("RECEIPT_NUM")));
			}		
		}
		paramList.add(0, paramMaster);
		return  paramList;
	}
	
}
