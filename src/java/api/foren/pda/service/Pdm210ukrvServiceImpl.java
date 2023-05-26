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
 * 기타출고(자재) 其他出库（材料）
 * @author Administrator
 *
 */
@Service("pdm210ukrvService")
public class Pdm210ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	


	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveStorage(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
		logger.debug("[saveAll] paramDetail:" + paramList);

		String keyValue = getLogKey();						
		List<Map> dataList = new ArrayList<Map>();
		List<List<Map>> resultList = new ArrayList<List<Map>>();
		
	
		for(Map param: paramList) {			
			
			String oprFlag =  param.get("CRUD").toString();
				param.put("KEY_VALUE", keyValue);
				param.put("OPR_FLAG", oprFlag);
				
				param.put("data", super.commonDao.insert("pdm210ukrvServiceImpl.insertLogMaster", param));

		}
		//4.출하지시저장 Stored Procedure 실행
		Map<String, Object> spParam = new HashMap<String, Object>();

		spParam.put("KEY_VALUE", keyValue);
		spParam.put("LangCode", user.getLanguage());
		spParam.put("GUBUN", "1");
		
	    super.commonDao.queryForObject("pdm210ukrvServiceImpl.spReseving", spParam);
		
		String ErrorDesc = ObjUtils.getSafeString(spParam.get("ERROR_DESC"));
		
		//출하지시 마스터 출하지시 번호 update
//		for(Map param : paramList )	{
		if(!ObjUtils.isEmpty(ErrorDesc)){
			paramMaster.put("INOUT_NUM", "");

			String[] messsage = ErrorDesc.split(";");
			paramMaster.put("ERROR", this.getMessage(messsage[0], user));
			paramList.add(0, paramMaster);	
			
		    throw new  Exception(this.getMessage(messsage[0], user));
		} else {
		    paramMaster.put("INOUT_NUM", ObjUtils.getSafeString(spParam.get("INOUT_NUM")));
			for(Map param: paramList)  {
				
				param.put("INOUT_NUM", ObjUtils.getSafeString(spParam.get("INOUT_NUM")));
			
	
			}		
			
		}
		paramList.add(0, paramMaster);
		
		return  paramList;
	}
	

	
}
