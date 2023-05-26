package foren.unilite.modules.human.hum;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;

@Service("hum976rkrService")
public class Hum976rkrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	/**
	 * 인사기록카드 목록 조회  
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@Transactional(readOnly = true)
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hum")
	public List<Map<String, Object>> selectPrintMaster(Map param) throws Exception {
		return (List) super.commonDao.list("hum976rkrServiceImpl.selectPrintMaster", param);
	}


	/**
	 * 증명번호 마지막번호 참조
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hum")
	public String fnHum970ini(Map param) throws Exception {
				
		List<Map>qureyValue = (List<Map>) super.commonDao.list("hum976rkrServiceImpl.fnHum970ini", param);
		String retrDate = (String) qureyValue.get(0).get("CERTI_NUM");
		
		logger.debug("rsNUM : " + retrDate);
		
		
		return retrDate;
		
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "base")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {	
		if(paramList != null)	{
			List<Map> insertList = null;
			for(Map dataListMap: paramList) {
				 if(dataListMap.get("method").equals("insertDetail")) {		
					insertList = (List<Map>)dataListMap.get("data");
				} 
			}			
			if(insertList != null) this.insertDetail(insertList, user);			
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hum")		// INSERT
	public Integer  insertDetail(List<Map> paramList, LoginVO user) throws Exception {		
		try {
			for(Map param : paramList )	{	
				if(ObjUtils.isEmpty(super.commonDao.select("hum976rkrServiceImpl.selectProfNum", param))){
					super.commonDao.update("hum976rkrServiceImpl.insertDetail", param);
				}
			}
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("2627", user));
		}
		return 0;
	}	
}
