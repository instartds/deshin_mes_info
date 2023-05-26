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
 * 재고이동입고 入库库存移动
 * @author Administrator
 *
 */
@Service("pdi210ukrvService")
public class Pdi210ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	


	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveInStockMove(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
		logger.debug("[saveAll] paramDetail:" + paramList);

		String keyValue = getLogKey();						
		List<Map> dataList = new ArrayList<Map>();
		List<List<Map>> resultList = new ArrayList<List<Map>>();
		
	
		for(Map param: paramList) {			
			
			String oprFlag =  param.get("CRUD").toString();
				param.put("KEY_VALUE", keyValue);
				param.put("OPR_FLAG", oprFlag);
				param.put("CREATE_LOC", '4');	// 쿼리의 고정값
			    param.put("SALE_C_YN", 'N');	// 쿼리의 고정값
			    param.put("SALE_DIV_CODE", '*');		// 쿼리의 고정값
			    param.put("SALE_CUSTOM_CODE", '*');		// 쿼리의 고정값
			    param.put("BILL_TYPE", '*');	// 쿼리의 고정값
			    param.put("SALE_TYPE", '*');	// 쿼리의 고정값
				param.put("data", super.commonDao.insert("pdi210ukrvServiceImpl.insertLogMaster", param));

		}
		//4.출하지시저장 Stored Procedure 실행
		Map<String, Object> spParam = new HashMap<String, Object>();

		spParam.put("KeyValue", keyValue);
		spParam.put("LangCode", user.getLanguage());
		
	    super.commonDao.queryForObject("pdi210ukrvServiceImpl.spReceiving", spParam);
		
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
		    paramMaster.put("INOUT_NUM", ObjUtils.getSafeString(spParam.get("InoutNum")));
			for(Map param: paramList)  {
				
				param.put("INOUT_NUM", ObjUtils.getSafeString(spParam.get("InoutNum")));
			
	
			}		
			
		}
		paramList.add(0, paramMaster);
		
		return  paramList;
	}
	

	
}
