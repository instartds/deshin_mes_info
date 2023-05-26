package foren.unilite.modules.accnt.agj;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;



@Service("agj206ukrService")
public class Agj206ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "Accnt")
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
	
		
		//로그테이블에서 사용할 Key 생성		
		String keyValue = getLogKey();			

		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
	
		//로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
		List<Map> dataList = new ArrayList<Map>();

		Map sParam = new HashMap();
		
		Map autoMap = (Map) super.commonDao.select("agj206ukrServiceImpl.getMaxAutoNum", sParam);
		int i=  Integer.parseInt(autoMap.get("MAX_AUTO_NUM").toString());
		if(paramList != null)	{
			for(Map param: paramList) {
				dataList = (List<Map>)param.get("data");
				for(Map paramData: dataList) {
					paramData.put("KEY_VALUE", keyValue);		
					paramData.put("AUTO_NUM", i);
					super.commonDao.update("agj206ukrServiceImpl.insertLog", paramData);	
					i++;
				}
				
			}
		}

		//Stored Procedure 실행
		
		
		sParam.put("CompCode", user.getCompCode());
		sParam.put("KeyValue", keyValue);
		sParam.put("UserID", user.getUserID());
		sParam.put("UserLang", user.getLanguage());
		
		super.commonDao.queryForObject("agj206ukrServiceImpl.spAccntAcSlip", sParam);
		
		String errorDesc = ObjUtils.getSafeString(sParam.get("ErrorDesc"));

		if(ObjUtils.isNotEmpty(errorDesc))	{
			throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
		} else {
			
			if(paramList != null)	{
				List<Map> dataList2 = new ArrayList<Map>();
				for(Map param: paramList) {
					dataList2 = (List<Map>)param.get("data");
						for(Map paramData: dataList2) {
							Map rMap= (Map) super.commonDao.select("agj206ukrServiceImpl.selectLog", paramData);
							
							paramData.put("OPR_FLAG", "L");
							paramData.put("SLIP_NUM", rMap.get("SLIP_NUM"));
							
							paramData.put("OLD_SLIP_NUM", rMap.get("SLIP_NUM"));
							paramData.put("OLD_AC_DATE", paramData.get("AC_DATE"));
							paramData.put("OLD_SLIP_SEQ", paramData.get("SLIP_SEQ"));
							dataMaster.put("SLIP_NUM",rMap.get("SLIP_NUM"));
						}
				}
				//super.commonDao.update("agj100ukrServiceImpl.deleteLog", sParam);
			}
		}
		paramList.add(0, paramMaster);		
		return  paramList;
	}
	
	@ExtDirectMethod(group = "Accnt", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> insert(List<Map> params) throws Exception {
		return params;
	}
	@ExtDirectMethod(group = "Accnt", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> update(List<Map> params) throws Exception {
		return params;
	}
	@ExtDirectMethod(group = "Accnt", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> delete(List<Map> params) throws Exception {
		return params;
	}
}
