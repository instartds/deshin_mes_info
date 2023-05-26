package foren.unilite.modules.human.hpa;

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


@Service("hpa640ukrService")
public class Hpa640ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	/**
	 * 연간입퇴사자 목록 조회  
	 * @param param
	 * @return
	 * @throws Exception
	 */
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hpa")
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return (List) super.commonDao.list("hpa640ukrServiceImpl.selectList", param);
	}
	
	/**
	 *년월차 기초등록 저장
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "busmaintain")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {

		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteDetail")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("updateDetail")) {
					updateList = (List<Map>)dataListMap.get("data");	
				} 
			}			
			if(deleteList != null) this.deleteDetail(deleteList, user);
			if(updateList != null) this.updateDetail(updateList, user);				
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hpa")
	public List<Map> updateDetail(List<Map> paramList, LoginVO user) throws Exception {
		String checkYn = "N";
		for(Map param :paramList ) {
//			super.commonDao.update("hpa640ukrServiceImpl.updateList", param);			
			param.put("CHECK", checkYn);
			Map err = (Map) super.commonDao.select("hpa640ukrServiceImpl.updateList", param);
			checkYn = "Y";
			if(!ObjUtils.isEmpty(err.get("ERROR_DESC"))){
				String errorDesc = ObjUtils.getSafeString(err.get("ERROR_DESC"));
				String[] messsage = errorDesc.split(";");
			   throw new  UniDirectValidateException(this.getMessage(messsage[0], user));					
			}
		}
		
		return paramList;
	}
	/**
	 * 삭제
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hpa")
	public List<Map> deleteDetail(List<Map> paramList, LoginVO user) throws Exception {		
		String checkYn = "N";
		for(Map param :paramList )	{			
			param.put("CHECK", checkYn);
			Map err = (Map) super.commonDao.select("hpa640ukrServiceImpl.deleteList", param);
			checkYn = "Y";
			if(!ObjUtils.isEmpty(err.get("ERROR_DESC"))){
				String errorDesc = ObjUtils.getSafeString(err.get("ERROR_DESC"));
				String[] messsage = errorDesc.split(";");
			   throw new  UniDirectValidateException(this.getMessage(messsage[0], user));					
			}
		}
		return paramList;
	}
	// sync All
//	@ExtDirectMethod(group = "hbs")
//	public Integer syncAll(Map param) throws Exception {
//		logger.debug("syncAll:" + param);
//		return  0;
//	}

}
