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
 * 재고실사등록 库存清点登记
 * @author Administrator
 *
 */
@Service("pdi100ukrvService")
public class Pdi100ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	


	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveStockInventory(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
		logger.debug("[saveAll] paramDetail:" + paramList);

		String keyValue = getLogKey();						
		List<Map> dataList = new ArrayList<Map>();
		List<List<Map>> resultList = new ArrayList<List<Map>>();
		
	
		for(Map param: paramList) {			
			
			String oprFlag =  param.get("CRUD").toString();
				param.put("KEY_VALUE", keyValue);
				param.put("OPR_FLAG", oprFlag);
				
				param.put("data", super.commonDao.insert("pdi100ukrvServiceImpl.insertLogMaster", param));

		}
		//4.출하지시저장 Stored Procedure 실행
		Map<String, Object> spParam = new HashMap<String, Object>();

		spParam.put("KeyValue", keyValue);
		spParam.put("LangCode", user.getLanguage());
		
	    super.commonDao.queryForObject("pdi100ukrvServiceImpl.spReceiving", spParam);
		
		String ErrorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
		
		//출하지시 마스터 출하지시 번호 update
//		for(Map param : paramList )	{
		if(!ObjUtils.isEmpty(ErrorDesc)){
			paramMaster.put("COUNT_DATE", "");
			String[] messsage = ErrorDesc.split(";");
			paramMaster.put("ERROR", this.getMessage(messsage[0], user));
			paramList.add(0, paramMaster);	
			
		    throw new  Exception(this.getMessage(messsage[0], user));
		} else {
		    paramMaster.put("COUNT_DATE", ObjUtils.getSafeString(spParam.get("CountDate")));
			
		}
		paramList.add(0, paramMaster);
		
		return  paramList;
	}
	

	
}
