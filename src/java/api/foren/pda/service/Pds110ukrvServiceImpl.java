package api.foren.pda.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import foren.framework.exception.UniDirectException;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
/**
 * 기타출고(제품) 其他出库（产品）
 * @author Administrator
 *
 */
@Service("pds110ukrvService")
public class Pds110ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	


	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveOutStorageProduct(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
		logger.debug("[saveAll] paramDetail:" + paramList);

		String keyValue = getLogKey();						
		List<Map> dataList = new ArrayList<Map>();
		List<List<Map>> resultList = new ArrayList<List<Map>>();

		if("YG".equals(paramMaster.get("TYPE"))){
			Map map1 = new HashMap<>();//ORDER_UNIT_Q
			Map map2 = new HashMap<>();//INOUT_Q
			Map map3 = new HashMap<>();
			List<Map> ygList = new ArrayList<Map>();
			for(Map param: paramList) {
				String itemCode = param.get("ITEM_CODE")+"";
				if(!map1.containsKey(itemCode)){
					map1.put(itemCode, param.get("ORDER_UNIT_Q"));
					map2.put(itemCode, param.get("INOUT_Q"));
				}else{
					String oprFlag =  param.get("CRUD").toString();
					
					map1.put(itemCode, Integer.parseInt(map1.get(itemCode)+"")+Integer.parseInt(param.get("ORDER_UNIT_Q")+""));
					map2.put(itemCode, Integer.parseInt(map2.get(itemCode)+"")+Integer.parseInt(param.get("INOUT_Q")+""));
				}
			}
			for(Map param: paramList) {
				String itemCode = param.get("ITEM_CODE")+"";
				if(!map3.containsKey(itemCode)){
					map3.put(itemCode, itemCode);
					param.put("ORDER_UNIT_Q", map1.get(itemCode));
					param.put("INOUT_Q", map2.get(itemCode));
					ygList.add(param);
				}
				
			}
			for(Map param: ygList) {	
				String oprFlag =  param.get("CRUD").toString();
				param.put("KEY_VALUE", keyValue);
				param.put("OPR_FLAG", oprFlag);
				param.put("EXCHG_RATE_O",1);
				param.put("INOUT_TYPE_DETAIL",10);
				param.put("MONEY_UNIT","");
				param.put("SALE_CUSTOM_CODE","");
				param.put("BILL_TYPE","");
				param.put("SALE_TYPE","");
				param.put("PRICE_YN","");
				

				param.put("ISSUE_REQ_NUM",paramMaster.get("ISSUE_REQ_NUM"));
				
				Map tempMap = new HashMap();
				tempMap = (Map) super.commonDao.select("pds110ukrvServiceImpl.checkIssueReqSeq", param);
				if(tempMap != null){
					param.put("ISSUE_REQ_SEQ",tempMap.get("ISSUE_REQ_SEQ"));
				}else{
				    throw new  Exception("출하지시번호를 확인하십시오.");
				}
				
				param.put("data", super.commonDao.insert("pds110ukrvServiceImpl.insertLogMaster_yg", param));
			}
		}else {
			for(Map param: paramList) {			
				
				String oprFlag =  param.get("CRUD").toString();
					param.put("KEY_VALUE", keyValue);
					param.put("OPR_FLAG", oprFlag);
					
					param.put("ORDER_UNIT_P", ObjUtils.parseDouble(param.get("ORDER_UNIT_P")));
					param.put("ORDER_UNIT_O", ObjUtils.parseDouble(param.get("ORDER_UNIT_O")));
					param.put("EXCHG_RATE_O", ObjUtils.parseDouble(param.get("EXCHG_RATE_O")));
					param.put("TRANS_RATE", ObjUtils.parseDouble(param.get("TRANS_RATE")));
					param.put("INOUT_Q", ObjUtils.parseDouble(param.get("INOUT_Q")));				
					
					param.put("data", super.commonDao.insert("pds110ukrvServiceImpl.insertLogMaster", param));
			}	
		}
	
		
		//4.출하지시저장 Stored Procedure 실행
		Map<String, Object> spParam = new HashMap<String, Object>();

		spParam.put("KeyValue", keyValue);
		spParam.put("LangCode", user.getLanguage());
		
	    super.commonDao.queryForObject("pds110ukrvServiceImpl.spReceiving", spParam);
		
		String ErrorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
		
		//출하지시 마스터 출하지시 번호 update
//		for(Map param : paramList )	{
		if(!ObjUtils.isEmpty(ErrorDesc)){
			paramMaster.put("INOUT_NUM", "");
			String[] messsage = ErrorDesc.split(";");
			paramMaster.put("ERROR", this.getMessage(messsage[0], user));
			paramList.add(0, paramMaster);	
			
		    throw new  Exception(this.getMessage(messsage[0], user));
		} else {
			
		    paramMaster.put("INOUT_NUM", ObjUtils.getSafeString(spParam.get("InOutNum")));
		    if("YG".equals(paramMaster.get("TYPE"))){
		    	for(Map param: paramList)  {
		    		param.put("INOUT_NUM", ObjUtils.getSafeString(spParam.get("InOutNum")));
		    		String oprFlag =  param.get("CRUD").toString();
		    		if ("N".equals(oprFlag)) {
		    			if(param.get("BOX_BARCODE")!=null){
		    				super.commonDao.update("outStorageServiceImpl.updatePmr160t", param);
		    			};
					}
//					param.put("INOUT_NUM", ObjUtils.getSafeString(spParam.get("InOutNum")));
				
		
				}		
		    }
		    
			
		}
		paramList.add(0, paramMaster);
		
		return  paramList;
	}
	

	
}
