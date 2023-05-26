package foren.unilite.modules.stock.btr;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.utils.UniliteUtil;
import foren.unilite.com.validator.UniDirectValidateException;

@Service("btr160ukrvService")
public class Btr160ukrvServiceImpl  extends TlabAbstractServiceImpl {
	
	
	/**
	 * Lot재고정보 조회
	 * @param param 
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "stock")
	public List<Map<String, Object>>  lotStockList(Map param) throws Exception {
		
		return  super.commonDao.list("btr160ukrvServiceImpl.lotStockList", param);
	}
	
	/**
	 * 재고 이동정보 조회
	 * @param param 
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "stock")
	public List<Map<String, Object>>  moveList(Map param) throws Exception {
		
		return  super.commonDao.list("btr160ukrvServiceImpl.moveList", param);
	}
		
	/**
	 * 재고 이동선택 팝업 
	 * @param param 
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "stock")
	public List<Map<String, Object>>  movePopupList(Map param) throws Exception {
		
		return  super.commonDao.list("btr160ukrvServiceImpl.movePopupList", param);
	}	
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "stock")
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		
		String keyValue = getLogKey();				
		List<Map> dataList = new ArrayList<Map>();
		List<List<Map>> resultList = new ArrayList<List<Map>>();
		if(paramList != null)	{
			for(Map param: paramList) {
				dataList = (List<Map>)param.get("data");
	
				if(param.get("method").equals("insert")) {
					param.put("data", insert(dataList, keyValue, "N") );		
				} else if(param.get("method").equals("delete")) {
					param.put("data", insert(dataList, keyValue, "D") );	
				}
			}
		}

		Map<String, Object> spParam = new HashMap<String, Object>();

		spParam.put("KeyValue", keyValue);
		spParam.put("LangCode", user.getLanguage());

		super.commonDao.queryForObject("btr160ukrvServiceImpl.lotStockMoving", spParam);
		
		String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));

		if(!errorDesc.isEmpty()){
			throw new Exception(errorDesc);
		} else {
			for(Map param: paramList) {
				dataList = (List<Map>)param.get("data");	
				if(param.get("method").equals("insert")) {
					List<Map> datas = (List<Map>)param.get("data");
					for(Map data: datas){
						data.put("STOCKMOVE_NUM", ObjUtils.getSafeString(spParam.get("RtnStockMoveNum")));
					}
				}
			}
		}
		
		//5.수주마스터 정보 + 수주디테일 정보 결과셋 리턴
		//마스터정보가 없을 경우에도 작성
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	public List<Map> insertLogDetails(List<Map> params, String keyValue, String oprFlag) throws Exception {
		for(Map param: params)		{
			param.put("KEY_VALUE", keyValue);
			param.put("OPR_FLAG", oprFlag);
			
			super.commonDao.insert("sof100ukrvServiceImpl.insertLogDetail", param);
		}		

		return params;
	}
	
	@ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> insert(List<Map> params, String keyValue, String oprFlag) throws Exception {
		for(Map param: params)		{
			param.put("KEY_VALUE", keyValue);
			param.put("OPR_FLAG", oprFlag);
			
			super.commonDao.insert("btr160ukrvServiceImpl.insertLog", param);
		}		

		return params;
	}
	
	@ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> delete(List<Map> params) throws Exception {
			

		return params;
	}
	
}
