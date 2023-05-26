package foren.unilite.modules.z_mit;

import java.util.ArrayList;
import java.util.HashMap;
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

@Service("s_pmr300ukrv_mitService") 
@SuppressWarnings({ "unchecked", "rawtypes" })
public class S_pmr300ukrv_mitServiceImpl  extends TlabAbstractServiceImpl {

	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	/**
	 * 조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_mit")
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return  super.commonDao.list("s_pmr300ukrv_mitServiceImpl.selectList", param);
	}

	
	/**
	 *  저장
	 * @param paramList
	 * @param paramMaster
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "z_mit")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		String keyValue = getLogKey();
		List<Map> dataList = new ArrayList<Map>();
		
		if(paramList != null) {
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;

			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("insertList")) {
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("updateList")) {
					updateList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("deleteList")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}
				
				
				
			}
			if(deleteList != null) this.deleteList(deleteList, user, dataMaster);
			if(insertList != null) this.insertList(insertList, user, dataMaster);
			if(updateList != null) this.updateList(updateList, user, dataMaster);
			
			
			
			
			for(Map dataListMap: paramList) {
				  dataList = (List<Map>) dataListMap.get("data");
				  String oprFlag = "N";
				  if(dataListMap.get("method").equals("insertList")) oprFlag="N";
				  if(dataListMap.get("method").equals("updateList")) oprFlag="U";
				  if(dataListMap.get("method").equals("deleteList")) oprFlag="D";
	
				  for(Map param:  dataList) {
					  param.put("KEY_VALUE", keyValue);
					  param.put("OPR_FLAG", oprFlag);
					  
					  param.put("SALE_C_YN", 'N');	// 쿼리의 고정값
					  param.put("SALE_DIV_CODE", '*');		// 쿼리의 고정값
					  param.put("SALE_CUSTOM_CODE", '*');		// 쿼리의 고정값
					  param.put("BILL_TYPE", '*');	// 쿼리의 고정값
					  param.put("SALE_TYPE", '*');	// 쿼리의 고정값
					  param.put("data", super.commonDao.insert("s_pmr300ukrv_mitServiceImpl.insertLogMaster", param));
				  }
			}
		}
		
		//매출저장 Stored Procedure 실행
		Map<String, Object> spParam = new HashMap<String, Object>();

		spParam.put("KeyValue", keyValue);
		spParam.put("LangCode", user.getLanguage());

		super.commonDao.queryForObject("s_pmr300ukrv_mitServiceImpl.spReceiving", spParam);

		String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));


		if(!ObjUtils.isEmpty(errorDesc)){
			dataMaster.put("INOUT_NUM", "");
		    throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
		} else {
			
			dataMaster.put("INOUT_NUM", ObjUtils.getSafeString(spParam.get("InoutNum")));
		}

		List<Map> logDataList = (List<Map>) super.commonDao.list("s_pmr300ukrv_mitServiceImpl.selectLogInoutNum", spParam);
		for(Map logData: logDataList) {
			logData.put("S_USER_ID", user.getUserID());
			super.commonDao.update("s_pmr300ukrv_mitServiceImpl.updateInoutNum", logData);
			for(Map dataListMap: paramList) {
				  dataList = (List<Map>) dataListMap.get("data");
				  for(Map param:  dataList) {
					  if(ObjUtils.getSafeString(param.get("MANAGE_NO")).equals(ObjUtils.getSafeString(logData.get("MANAGE_NO"))) && 
							  ObjUtils.getSafeString(param.get("MANAGE_NO")).equals(ObjUtils.getSafeString(logData.get("MANAGE_NO")))
						)  {
						  param.put("INOUT_NUM", logData.get("INOUT_NUM"));
						  param.put("INOUT_SEQ", logData.get("INOUT_SEQ"));
						  
					  }
				  }
			}
		}
		
		
		paramList.add(0, paramMaster);
		return paramList;
	}

	/**
	 * 추가
	 * @param paramList
	 * @param user
	 * @param paramMaster
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_mit")
	public List<Map> insertList(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		if(paramList != null && paramList.size() > 0)	{
			String manage_no = (String) super.commonDao.select("s_pmr300ukrv_mitServiceImpl.autoNum", paramList.get(0));
			int i = 1;
			for(Map param :paramList) {
				param.put("MANAGE_NO", manage_no);
				param.put("MANAGE_SEQ", i);
				super.commonDao.update("s_pmr300ukrv_mitServiceImpl.insertList", param);
				i++;
			}
		}
		return paramList;
	}

	/**
	 * 수정
	 * @param paramList
	 * @param user
	 * @param paramMaster
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_mit")
	public List<Map> updateList(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		for(Map param :paramList) {
			super.commonDao.update("s_pmr300ukrv_mitServiceImpl.updateList", param);
		}
		return paramList;
	}

	/**
	 * 삭제
	 * @param paramList
	 * @param user
	 * @param paramMaster
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_mit")
	public List<Map> deleteList(List<Map> paramList,  LoginVO user, Map paramMaster) throws Exception {
		for(Map param :paramList ) {
			super.commonDao.delete("s_pmr300ukrv_mitServiceImpl.deleteList", param);
		}
		return paramList;
	}
	
}
