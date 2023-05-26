package foren.unilite.modules.z_kd;


import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.math.NumberUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;

@Service("s_set210ukrv_kdService")
public class S_set210ukrv_kdServiceImpl  extends TlabAbstractServiceImpl {

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "set")
	public List<Map<String, Object>>  selectMaster(Map param) throws Exception {
		if("child".equals(param.get("OP_FLAG"))){
			return  super.commonDao.list("s_set210ukrv_kdServiceImpl.selectComponseGen1", param);
		}
		return  super.commonDao.list("s_set210ukrv_kdServiceImpl.selectMaster", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "set")
	public List<Map<String, Object>>  selectMaster2(Map param) throws Exception {
		if("child".equals(param.get("OP_FLAG"))){
			return  super.commonDao.list("s_set210ukrv_kdServiceImpl.selectComponseGen2", param);
		}
		return  super.commonDao.list("s_set210ukrv_kdServiceImpl.selectMaster2", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "set")
	public List<Map<String, Object>>  selectWorkNoMaster(Map param) throws Exception {
		return  super.commonDao.list("s_set210ukrv_kdServiceImpl.selectWorkNoMaster", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "set")
	public Object  selectStockQty(Map param) throws Exception {
		return  super.commonDao.select("s_set210ukrv_kdServiceImpl.selectStockQty", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "set")
	public Object selectAverageP(Map param) throws Exception {
		String baseYm = (String) param.get("BASIS_YYYYMM");
		if(StringUtils.isNotBlank(baseYm)){
			baseYm = baseYm.substring(0, 10).replaceAll("-", "");
			param.put("BASIS_YYYYMM", baseYm);
		}
		
		return  super.commonDao.select("s_set210ukrv_kdServiceImpl.selectAverageP", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "matrl")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {

		  //1.로그테이블에서 사용할 KeyValue 생성
		  String keyValue = getLogKey();
		  
		  //2.출하지시 로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
		  List<Map> dataList = new ArrayList<Map>();
		  List<List<Map>> resultList = new ArrayList<List<Map>>();
		  
		  Map<String, Object> spParam = new HashMap<String, Object>();
		  
		  boolean addAssembleFlag = true;
		  
		  for(Map paramData: paramList) {

			  dataList = (List<Map>) paramData.get("data");
			  String oprFlag = "N";
			  if(paramData.get("method").equals("insertDetail")||paramData.get("method").equals("insertDetail2")) oprFlag="N";
			  if(paramData.get("method").equals("updateDetail")||paramData.get("method").equals("updateDetail2")) oprFlag="U";
			  if(paramData.get("method").equals("deleteDetail")||paramData.get("method").equals("deleteDetail2")) oprFlag="D";

			  for(Map param: dataList) {
				  if(addAssembleFlag){
					  Map paramMasterData = (Map)paramMaster.get("data");
					  
					  Map newMap = new HashMap();
					  if("1".equals(paramMasterData.get("OptFlag"))){
						  newMap = getAssembleMap(param, paramMasterData);
					  }else{
						  newMap = getDisAssembleMap(param, paramMasterData);
					  }
					  spParam.put("OptFlag", paramMasterData.get("OptFlag"));
					 
					  if(!ObjUtils.isEmpty(paramMasterData.get("WORK_NUM"))){
						  newMap.put("KEY_VALUE", keyValue);
						  newMap.put("OPR_FLAG", "U");
						  super.commonDao.insert("s_set210ukrv_kdServiceImpl.updateLogDetail", newMap);
					  }else{
						  newMap.put("KEY_VALUE", keyValue);
						  newMap.put("OPR_FLAG", "N");
						  super.commonDao.insert("s_set210ukrv_kdServiceImpl.insertLogDetail", newMap);
					  }
					  
					  addAssembleFlag = false;
				  }
				  param.put("KEY_VALUE", keyValue);
				  param.put("OPR_FLAG", oprFlag);
				  if("N".equals(oprFlag) || "D".equals(oprFlag)){
					  param.put("data", super.commonDao.insert("s_set210ukrv_kdServiceImpl.insertLogDetail", param));
				  }else{
					  param.put("data", super.commonDao.insert("s_set210ukrv_kdServiceImpl.updateLogDetail", param));
				  }
			  }
		  }
		  
			spParam.put("KeyValue", keyValue);
			spParam.put("LangCode", user.getLanguage());

			super.commonDao.queryForObject("spSet210ukrv", spParam);
			String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
			
			//접수등록 마스터 출하지시 번호 update
			Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
			
			if(!ObjUtils.isEmpty(errorDesc)){
				dataMaster.put("INOUT_NUM", "");
				String[] messsage = errorDesc.split(";");
			    throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
			} else {
				//마스터에 SET
				dataMaster.put("INOUT_NUM", ObjUtils.getSafeString(spParam.get("InOutNum")));
				//그리드에 SET
				for(Map param: paramList) {
					dataList = (List<Map>)param.get("data");
					if(param.get("method").equals("insertDetail")) {
						List<Map> datas = (List<Map>)param.get("data");
						for(Map data: datas){
							data.put("INOUT_NUM", ObjUtils.getSafeString(spParam.get("InOutNum")));
						}
					}
				}
			}
			
		  paramList.add(0, paramMaster);
		  return  paramList;
	}
	
	public Map getAssembleMap(Map oldMap, Map paramMaster){
		
		Map newMap = new HashMap();
		newMap.putAll(oldMap);
		
		double inoutP = NumberUtils.toDouble((String) paramMaster.get("INOUT_P"));
		double inoutQ = NumberUtils.toDouble((String) paramMaster.get("SET_QTY"));
		
		newMap.put("INOUT_NUM", paramMaster.get("WORK_NUM"));
		newMap.put("INOUT_SEQ", 1);
		newMap.put("ITEM_CODE", paramMaster.get("ITEM_CODE"));
		newMap.put("ITEM_NAME", paramMaster.get("ITEM_NAME"));
		newMap.put("SPEC", paramMaster.get("SPEC"));
		newMap.put("STOCK_UNIT", "EA");
		newMap.put("CONST_Q", 0);
		newMap.put("WH_CODE", paramMaster.get("WH_CODE"));
		newMap.put("WH_CELL_CODE", paramMaster.get("WH_CELL_CODE"));
		newMap.put("MAKER_TYPE", paramMaster.get("MAKER_TYPE"));
		newMap.put("LOT_NO", paramMaster.get("LOT_NO"));
		newMap.put("INOUT_Q", inoutQ);
		newMap.put("CURRENT_STOCK", 0);
		newMap.put("DIV_CODE", paramMaster.get("DIV_CODE"));
		newMap.put("INOUT_CODE", paramMaster.get("DIV_CODE"));
		newMap.put("INOUT_DATE", paramMaster.get("CREATE_DATE"));
		newMap.put("ITEM_STATUS", "1");
		newMap.put("INOUT_TYPE", "1");//입고
		newMap.put("INOUT_METH", "2");
		newMap.put("INOUT_TYPE_DETAIL", "98");
		newMap.put("INOUT_CODE_TYPE", "*");
		newMap.put("INOUT_P", paramMaster.get("INOUT_P"));
		newMap.put("INOUT_I", paramMaster.get("INOUT_I"));
		newMap.put("INOUT_FOR_P", inoutP);
		newMap.put("INOUT_FOR_O", inoutQ * inoutP);
		newMap.put("EXCHG_RATE_O", "1");
		newMap.put("ORDER_UNIT", "EA");
		newMap.put("TRNS_RATE", "1");
		newMap.put("ORDER_UNIT_Q", inoutQ);
		newMap.put("ORDER_UNIT_P", inoutP);
		newMap.put("ORDER_UNIT_O", inoutQ * inoutP);
		newMap.put("ORDER_UNIT_FOR_P", inoutP);
		newMap.put("CREATE_LOC", "1");
		newMap.put("SALE_C_YN", "N");
		newMap.put("SALE_DIV_CODE", "*");
		
		//CUSTOM_CODE TO SALE_CUSTOM_CODE
		newMap.put("SALE_CUSTOM_CODE","*");
		
		
		newMap.put("BILL_TYPE", "*");
		newMap.put("SALE_TYPE", "*");
		newMap.put("PERSONS_NUM", ObjUtils.isEmpty(paramMaster.get("PERSONS_NUM"))?"0":paramMaster.get("PERSONS_NUM"));
		newMap.put("WORK_TIME", ObjUtils.isEmpty(paramMaster.get("WORK_TIME"))?"0":paramMaster.get("WORK_TIME"));
		newMap.put("GONG_SU", ObjUtils.isEmpty(paramMaster.get("GONG_SU"))?"0":paramMaster.get("GONG_SU"));
		newMap.put("MAKER_TYPE", paramMaster.get("MAKER_TYPE"));
		newMap.put("REMARK", paramMaster.get("REMARK"));
		newMap.put("INOUT_PRSN", paramMaster.get("INOUT_PRSN"));
		newMap.put("WORK_SHOP_CODE", paramMaster.get("WORK_SHOP_CODE"));
		
		return newMap;
	}
	
	public Map getDisAssembleMap(Map oldMap, Map paramMaster){
		
		Map newMap = new HashMap();
		newMap.putAll(oldMap);
		
		double inoutP = NumberUtils.toDouble((String) paramMaster.get("INOUT_P"));
		double inoutQ = NumberUtils.toDouble((String) paramMaster.get("SET_QTY"));
		
		newMap.put("INOUT_NUM", paramMaster.get("WORK_NUM"));
		newMap.put("INOUT_SEQ", 1);
		newMap.put("ITEM_CODE", paramMaster.get("ITEM_CODE"));
		newMap.put("ITEM_NAME", paramMaster.get("ITEM_NAME"));
		newMap.put("SPEC", paramMaster.get("SPEC"));
		newMap.put("STOCK_UNIT", "EA");
		newMap.put("CONST_Q", 0);
		newMap.put("WH_CODE", paramMaster.get("WH_CODE"));
		newMap.put("WH_CELL_CODE", paramMaster.get("WH_CELL_CODE"));
		newMap.put("MAKER_TYPE", paramMaster.get("MAKER_TYPE"));
		newMap.put("LOT_NO", paramMaster.get("LOT_NO"));
		newMap.put("INOUT_Q", inoutQ);
		newMap.put("DIV_CODE", paramMaster.get("DIV_CODE"));
		newMap.put("INOUT_CODE", paramMaster.get("DIV_CODE"));
		newMap.put("INOUT_DATE", paramMaster.get("CREATE_DATE"));
		newMap.put("ITEM_STATUS", "1");
		newMap.put("INOUT_TYPE", "2");
		newMap.put("INOUT_METH", "2");
		newMap.put("INOUT_TYPE_DETAIL", "98");
		newMap.put("INOUT_CODE_TYPE", "*");
		newMap.put("INOUT_P", paramMaster.get("INOUT_P"));
		newMap.put("INOUT_I", paramMaster.get("INOUT_I"));
		newMap.put("EXCHG_RATE_O", "1");
		newMap.put("ORDER_UNIT", "EA");
		newMap.put("TRNS_RATE", "1");
		newMap.put("ORDER_UNIT_Q", inoutQ);
		newMap.put("ORDER_UNIT_P", inoutP);
		newMap.put("ORDER_UNIT_O", inoutQ * inoutP);
		newMap.put("ORDER_UNIT_FOR_P", inoutP);
		newMap.put("INOUT_FOR_P", inoutP);
		newMap.put("INOUT_FOR_O", inoutQ * inoutP);
		newMap.put("CREATE_LOC", "1");
		newMap.put("SALE_C_YN", "N");
		newMap.put("SALE_DIV_CODE", "*");
		newMap.put("SALE_CUSTOM_CODE", "*");
		newMap.put("BILL_TYPE", "*");
		newMap.put("SALE_TYPE", "*");
		newMap.put("SALE_DIV_CODE", "*");
		newMap.put("PERSONS_NUM", ObjUtils.isEmpty(paramMaster.get("PERSONS_NUM"))?"0":paramMaster.get("PERSONS_NUM"));
		newMap.put("WORK_TIME", ObjUtils.isEmpty(paramMaster.get("WORK_TIME"))?"0":paramMaster.get("WORK_TIME"));
		newMap.put("GONG_SU", ObjUtils.isEmpty(paramMaster.get("GONG_SU"))?"0":paramMaster.get("GONG_SU"));
		newMap.put("REMARK", paramMaster.get("REMARK"));
		newMap.put("INOUT_PRSN", paramMaster.get("INOUT_PRSN"));
		newMap.put("WORK_SHOP_CODE", paramMaster.get("WORK_SHOP_CODE"));
		
		return newMap;
	}
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "matrl")
	public Integer insertDetail(List<Map> paramList, LoginVO user) throws Exception {		
		return 0;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "matrl")
	public Integer updateDetail(List<Map> paramList, LoginVO user) throws Exception {
		 return 0;
	} 
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "matrl")
	public Integer deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {
		 return 0;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "matrl")
	public Integer insertDetail2(List<Map> paramList, LoginVO user) throws Exception {		
		return 0;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "matrl")
	public Integer updateDetail2(List<Map> paramList, LoginVO user) throws Exception {
		return 0;
	} 
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "matrl")
	public Integer deleteDetail2(List<Map> paramList,  LoginVO user) throws Exception {
		return 0;
	}
}