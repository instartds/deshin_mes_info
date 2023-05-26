package foren.unilite.modules.sales.sof;

import java.lang.reflect.Array;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.logging.InjectLogger;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;

@Service("sof102ukrvService")
public class Sof102ukrvServiceImpl  extends TlabAbstractServiceImpl {
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
		return  super.commonDao.list("sof102ukrvServiceImpl.selectList", param);
	}
	
	
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)		// 엑셀 업로드
    public List<Map<String, Object>> selectExcelUploadSheet1(Map param) throws Exception {
        return super.commonDao.list("sof102ukrvServiceImpl.selectExcelUploadSheet1", param);
    }
    
    public void excelValidate(String jobID, Map param) {							// 엑셀 Validate
		super.commonDao.update("sof102ukrvServiceImpl.excelValidate", param);
		
		
		

		/* 사업장에 대한 품목정보가 존재하지 않을때 B141 품목자동생성방법 1수동, 2자동 SUB_CODE = '2' 의 REF_CODE1 = 'Y' 일때 */
		/* BPR220T에 품목계정이 '제품'으로 되어있는 데이터를 기본으로 하여 BPR100T에 INSERT 하고 아니면 에러 update . */
		Map checkB141 = (Map) super.commonDao.select("sof102ukrvServiceImpl.checkB141", param);
		
		String checkValue = "1";
		
		if(ObjUtils.isNotEmpty(checkB141)){
			checkValue = ObjUtils.getSafeString(checkB141.get("SUB_CODE"));
		}
		
		
    	List<Map<String, Object>> checkItemCodeList = super.commonDao.list("sof102ukrvServiceImpl.checkItemCode", param);
    	if(ObjUtils.isNotEmpty(checkItemCodeList)){
	    	for(Map dataMap : checkItemCodeList){
	    		param.put("ITEM_CODE", dataMap.get("ITEM_CODE"));
	    		param.put("ITEM_NAME", dataMap.get("ITEM_NAME"));
	    		if(checkValue.equals("2")){
	    			super.commonDao.update("sof102ukrvServiceImpl.insertItemCode", param);
	    		}else{
	    			super.commonDao.update("sof102ukrvServiceImpl.updateItemCode", param);
	    		}
	    	}
    	}
	}
    
    
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		
		if(paramList != null)   {
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
//				if(dataListMap.get("method").equals("deleteDetail")) {
//					deleteList = (List<Map>)dataListMap.get("data");
				if(dataListMap.get("method").equals("insertDetail")) {
					insertList = (List<Map>)dataListMap.get("data");
				}
				
//				else if(dataListMap.get("method").equals("updateDetail")) {
//					updateList = (List<Map>)dataListMap.get("data");
//				}
			}
//			if(deleteList != null) this.deleteDetail(deleteList, user);
			if(insertList != null) this.insertDetail(insertList, user,dataMaster);
//			if(updateList != null) this.updateDetail(updateList, user);
		}
		paramList.add(0, paramMaster);

		return paramList;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
	public void insertDetail(List<Map> paramList, LoginVO user, Map dataMaster) throws Exception {
		
		String keyValue = getLogKey();
		ArrayList<String> keyArry = new ArrayList<String>();
		for(Map param : paramList ) {
			param.put("KEY_VALUE", keyValue.substring(0,19) + ObjUtils.getSafeString(param.get("CUST_NO")));
			param.put("OPR_FLAG", "N");
			if("1".equals(ObjUtils.getSafeString(param.get("CUST_SEQ")))){
				keyArry.add(ObjUtils.getSafeString(param.get("KEY_VALUE"))); 
				super.commonDao.insert("sof102ukrvServiceImpl.insertLogMaster", param);
			}
			param.put("SER_NO", param.get("CUST_SEQ"));
			super.commonDao.insert("sof102ukrvServiceImpl.insertLogDetail", param);

		}
		
		ArrayList<String> orderNumArry = new ArrayList<String>();
		for(int i=0; i < keyArry.size(); i++){
			
			Map<String, Object> spParam = new HashMap<String, Object>();
			
			spParam.put("KeyValue", keyArry.get(i));
			spParam.put("LangCode", user.getLanguage());

			super.commonDao.queryForObject("sof102ukrvServiceImpl.spSalesOrder", spParam);
			
			String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
			
			if(!ObjUtils.isEmpty(errorDesc)){
				String[] messsage = errorDesc.split(";");
			    throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
			}else{
				orderNumArry.add(ObjUtils.getSafeString(spParam.get("OrderNum")));
			}
		}
		String orderNum = "";
	  	for(String dorderNum : orderNumArry)	{
	  		orderNum = orderNum+"'"+dorderNum+"',";
	  	}
	  	if(!"".equals(orderNum))	{
	  		orderNum = orderNum.substring(0, orderNum.length()-1);
		  	dataMaster.put("orderNums", orderNum);
  	    }
		return;
	}
	
/*	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
	public void updateDetail(List<Map> params, LoginVO user) throws Exception {
		for(Map param: params){
			super.commonDao.update("sof102ukrvServiceImpl.updateDetail", param);
		}

		return;
	}*/
}