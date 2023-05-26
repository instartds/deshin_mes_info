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
 * 로케이션 등록
 * @author Administrator
 *
 */
@Service("pdi310ukrvService")
public class Pdi310ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	/**
	 * 
	 */
	public List selectStorageList(Map param)throws UniDirectException{
		return super.commonDao.list("pdi310ukrvServiceImpl.selectStorageList", param);
	}


	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveInLocation(List<Map> paramList, Map paramMaster, LoginVO user, String itemLocation, String itemcode) throws Exception {
		String keyValue = getLogKey();						
		List<Map> dataList = new ArrayList<Map>();
		List<List<Map>> resultList = new ArrayList<List<Map>>();
		Map<String, Object> spParam = new HashMap<String, Object>();

			spParam.put("comp_code",paramMaster.get("comp_code"));
			spParam.put("div_code",paramMaster.get("div_code"));
			spParam.put("LangCode", user.getLanguage());
			spParam.put("item_location", itemLocation);
			spParam.put("item_code", itemcode);
			super.commonDao.queryForObject("pdi310ukrvServiceImpl.spReceiving", spParam);
		
			String ErrorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
		
			paramList = super.commonDao.list("pdi310ukrvServiceImpl.selectItemLocationChk", spParam);
				
				if(!ObjUtils.isEmpty(ErrorDesc)){
					paramMaster.put("LOCATION", "");
					String[] messsage = ErrorDesc.split(";");
					paramMaster.put("ERROR", this.getMessage(messsage[0], user));
					paramList.add(0, paramMaster);	
				
					throw new  Exception(this.getMessage(messsage[0], user));
				} else {
			    paramMaster.put("LOCATION", ObjUtils.getSafeString(spParam.get("item_location")));
			
				}
				
			paramList.add(0, paramMaster);
	
		
	
	
		return  paramList;
	}	
}
