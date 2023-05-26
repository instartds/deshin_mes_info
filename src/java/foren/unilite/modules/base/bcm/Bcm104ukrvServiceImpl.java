package foren.unilite.modules.base.bcm;

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
import foren.unilite.com.utils.UniliteUtil;
import foren.unilite.com.validator.UniDirectValidateException;

@Service("bcm104ukrvService")
public class Bcm104ukrvServiceImpl extends TlabAbstractServiceImpl  {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	/**
	 * 거래처 조회
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "bcm")
	public List<Map<String, Object>>  selectDetailList(Map param) throws Exception {
		return  super.commonDao.list("bcm104ukrvServiceImpl.getDataList", param);
	}

	/**
	 * 취급품목 조회
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "bcm")
	public List<Map> selectPurchaseList(Map param, LoginVO user) throws Exception {
		return  super.commonDao.list("bcm104ukrvServiceImpl.selectPurchaseList", param);
	}
	
	/**
	 * 거래처코드 중복 체크
	 * @param param
	 * @return
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "bcm")
	public Object chkPK(Map param)	{
		return super.commonDao.select("bcm104ukrvServiceImpl.insertQuery06", param);
	}
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "busmaintain")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
				
//		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
//		Map<String, Object> rMap;
//		
//		if(ObjUtils.isEmpty(dataMaster.get("REQUEST_NUM")))	{
//			rMap = (Map<String, Object>) super.commonDao.queryForObject("gre100ukrvServiceImpl.insert", dataMaster);
//			dataMaster.put("REQUEST_NUM", rMap.get("REQUEST_NUM"));
//		}else {
//			super.commonDao.update("gre100ukrvServiceImpl.update", dataMaster);
//		}		
		String keyValue = getLogKey();
		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteDetail")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insertDetail")) {		
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("updateDetail")) {
					updateList = (List<Map>)dataListMap.get("data");	
				} 
			}			
			if(deleteList != null) this.deleteDetail(deleteList, user, keyValue, "D");
			if(insertList != null) this.insertDetail(insertList, user, keyValue, "N");
			if(updateList != null) this.updateDetail(updateList, user, keyValue, "U");				
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	/**
	 * 거래처 입력
	 * @param paramList
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "bcm")
	public List<Map>  insertDetail(List<Map> paramList, LoginVO user, String keyValue, String oprFlag) throws Exception {		
		int r = 0;
		String sDemo = "N";	
		boolean license = UniliteUtil.IsExceedUser("C");
		if(license	) 	sDemo="Y";

		//공통코드(B107:타법인 복사여부)에 따라 법인정보 조회
		try {
			Map<String, Object> uMap = new HashMap<String, Object>();
			uMap.put("S_COMP_CODE", user.getCompCode());
			List<Map<String, Object>> rsInfoList = (List<Map<String, Object>>)super.commonDao.list("bcm104ukrvServiceImpl.insertQuery01", uMap);
	
			for(Map param :paramList )	{				
				String sOrgCompCode = param.get("COMP_CODE").toString();
				Map compCodeMap = new HashMap();
				compCodeMap.put("S_COMP_CODE", user.getCompCode());
				compCodeMap.put("AGENT_TYPE", param.get("AGENT_TYPE"));
				if(ObjUtils.isEmpty(param.get("CUSTOM_CODE"))){
					List<Map> customCode = (List<Map>) super.commonDao.list("bcm104ukrvServiceImpl.getAutoCustomCode", compCodeMap);
					param.put("CUSTOM_CODE", customCode.get(0).get("CUSTOM_CODE"));
				}
			    for(Map rsInfo : rsInfoList) { 		    	
			    	param.put("START_DATE",UniliteUtil.chgDateFormat(param.get("START_DATE")));        
			    	param.put("STOP_DATE",UniliteUtil.chgDateFormat(param.get("STOP_DATE")));   
			    	param.put("CREDIT_YMD",UniliteUtil.chgDateFormat(param.get("CREDIT_YMD")));   
			    	if(param.get("TOP_NUM") != null) param.put("TOP_NUM",param.get("TOP_NUM").toString().replace("-", ""));   
			    	if(param.get("COMPANY_NUM") != null) param.put("COMPANY_NUM",param.get("COMPANY_NUM").toString().replace("-", ""));  
			    	
			    	if(param.get("ZIP_CODE") != null)	{
			    		param.put("ZIP_CODE", param.get("ZIP_CODE").toString().replace("-",""));
			    	}
			    	param.put("KEY_VALUE", keyValue);
	            	param.put("OPR_FLAG", oprFlag);
			    	r = super.commonDao.update("bcm104ukrvServiceImpl.insertMulti", param);
			    	super.commonDao.update("bcm104ukrvServiceImpl.insertMultiLog", param);
			        if( "Y".equals(sDemo)) {
			        	if(!license){		        		
			        		Map<String, Object> customCnt = (Map<String, Object>)super.commonDao.select("bcm104ukrvServiceImpl.insertQuery01", param);
			        		if(Integer.parseInt(customCnt.get("CNT").toString()) > 100 )	{
			        			throw new  UniDirectValidateException(this.getMessage("52104", user));
			        		}
			        	}
			        }
			       
			    }
	//	        param.put("COMP_CODE", sOrgCompCode);
	//	        param.put("CUSTOM_NAME1", param.get("CUSTOM_NAME") + "-CHANGE ON SERVER");
	
			}
		}catch(Exception e)	{
			logger.debug(e.toString());
			throw new  UniDirectValidateException(this.getMessage("2627", user));
		}

		return  paramList;
	}
	
	/**
	 * 거래처 수정
	 * @param paramList
	 * @param loginVO
	 * @return
	 * @throws Exception
	 */
	
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "bcm")
	public List<Map>  updateDetail(List<Map> paramList,  LoginVO user, String keyValue, String oprFlag) throws Exception {
		int r = 0;
		
		String sDemo = "N";	
		boolean license = UniliteUtil.IsExceedUser("C");
		if(license	) 	sDemo="Y";
		//try {
			//공통코드(B107:타법인 복사여부)에 따라 법인정보 조회
			Map<String, Object> uMap = new HashMap<String, Object>();
			uMap.put("S_COMP_CODE", user.getCompCode());
			List<Map<String, Object>> rsInfoList = (List<Map<String, Object>>)super.commonDao.list("bcm104ukrvServiceImpl.insertQuery01",uMap);
	
			for(Map param :paramList )	{
	
				String sOrgCompCode = param.get("COMP_CODE").toString();
			        
			    for(Map rsInfo : rsInfoList) { 		    	
			    	param.put("START_DATE",UniliteUtil.chgDateFormat(param.get("START_DATE")));        
			    	param.put("STOP_DATE",UniliteUtil.chgDateFormat(param.get("STOP_DATE")));   
			    	param.put("CREDIT_YMD",UniliteUtil.chgDateFormat(param.get("CREDIT_YMD")));   
			    	if(param.get("TOP_NUM") != null) param.put("TOP_NUM",param.get("TOP_NUM").toString().replace("-", ""));   
			    	if(param.get("COMPANY_NUM") != null) param.put("COMPANY_NUM",param.get("COMPANY_NUM").toString().replace("-", ""));   
			    	
			    	if(!sOrgCompCode.equals(rsInfo.get("COMP_CODE")))	{
			    		param.put("COMP_CODE", rsInfo.get("COMP_CODE"));
			    	}
			    	if(param.get("ZIP_CODE") != null)	{
			    		param.put("ZIP_CODE", param.get("ZIP_CODE").toString().replace("-",""));
			    	}
			    	param.put("KEY_VALUE", keyValue);
	            	param.put("OPR_FLAG", oprFlag);
			    	
			    	/*List<Map<String, Object>> rsCust = (List<Map.<String, Object>>)super.commonDao.list("bcm104ukrvServiceImpl.updateQuery04", param);
			    	if(rsCust.size() == 0)	{ 
			    		r = super.commonDao.update("bcm104ukrvServiceImpl.insertMulti", param);
			    	}else {*/
			    		r = super.commonDao.update("bcm104ukrvServiceImpl.updateMulti", param);
			    		super.commonDao.update("bcm104ukrvServiceImpl.updateMultiLog", param);
			    	//}
			    	
			        if( "Y".equals(sDemo)) {
			        	if(!license){		        		
			        		Map<String, Object> customCnt = (Map<String, Object>)super.commonDao.select("bcm104ukrvServiceImpl.insertQuery01", param);
			        		if(Integer.parseInt(customCnt.get("CNT").toString()) > 100 )	{
			        			// FIXME Message 처리 52104
			        			throw new  UniDirectValidateException(this.getMessage("52104", user));
			        		}
			        	}
			        }
			        param.put("COMP_CODE", sOrgCompCode);
	//		        param.put("CUSTOM_NAME1", param.get("CUSTOM_NAME") + "-CHANGE ON SERVER");
			    }
	
			}
//		}catch(Exception e)	{
//			logger.debug(e.getMessage());
//			throw new  UniDirectValidateException(this.getMessage("0", user));
//		}
		return  paramList;
	}
	
	/**
	 * 거래처 삭제
	 * @param paramList
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "bcm")
	public List<Map>  deleteDetail(List<Map> paramList,  LoginVO user, String keyValue, String oprFlag) throws Exception {
		int r = 0;

		String sDemo = "N";	
		boolean license = UniliteUtil.IsExceedUser("C");
		if(license	) 	sDemo="Y";

		
			//공통코드(B107:타법인 복사여부)에 따라 법인정보 조회
			Map<String, Object> uMap = new HashMap<String, Object>();
			uMap.put("S_COMP_CODE", user.getCompCode());
			List<Map<String, Object>> rsInfoList = (List<Map<String, Object>>)super.commonDao.list("bcm104ukrvServiceImpl.insertQuery01",uMap);
			for(Map param :paramList )	{
					String sOrgCompCode = param.get("COMP_CODE").toString();
		            
		            for(Map rsInfo : rsInfoList) { 	
		            	try {
			            	param.put("COMP_CODE", rsInfo.get("COMP_CODE"));
			            	param.put("KEY_VALUE", keyValue);
			            	param.put("OPR_FLAG", oprFlag);
			            	// 회계데이타가 남아 있는 경우 삭제 불가
			            	Map<String, Object> rsSheet = (Map<String, Object>)super.commonDao.select("bcm104ukrvServiceImpl.deleteQuery02", param);
					    	
			               if(Integer.parseInt(rsSheet.get("CNT").toString()) > 0 )		{
			            	   // FIXME Message 처리 547 "Custom Code : " + param.get("CUSTOM_CODE").toString();
			        			throw new  UniDirectValidateException(this.getMessage("547", user));
			               } else {
			            	   r = super.commonDao.delete("bcm104ukrvServiceImpl.deleteMulti", param);
			            	   super.commonDao.delete("bcm104ukrvServiceImpl.deleteMultiLog", param);
			            	   super.commonDao.delete("bcm104ukrvServiceImpl.deleteBCM120", param);
			               }
			               param.put("COMP_CODE", sOrgCompCode);
			            }catch(Exception e)	{
			    			throw new  UniDirectValidateException(this.getMessage("547", "Custom Code : "+param.get("CUSTOM_CODE")));
			    		}	
		            }
	
			}
		

		return  paramList;	
	}
	
	@ExtDirectMethod(group = "bcm")
	public Integer  syncAll(Map param) throws Exception {
		logger.debug("syncAll:" + param);
		return  0;
	}
	
	/**
	 * 거래처 전자문서정보 조회
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "bcm")
	public List<Map<String, Object>>  getBCM120List(Map param) throws Exception {
		return  super.commonDao.list("bcm104ukrvServiceImpl.getBCM120List", param);
	}

	/**
	 * 거래처 전자문서정보 입력
	 * @param paramList
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "bcm")
	public List<Map>  insertBCM120(List<Map> paramList) throws Exception {
		int r = 0;
		//공통코드(B107:타법인 복사여부)에 따라 법인정보 조회
		for(Map param :paramList )	{
		    	r = super.commonDao.update("bcm104ukrvServiceImpl.insertBCM120", param);
		}
		return  paramList;
	}
	
	/**
	 * 거래처 전자문서정보 수정
	 * @param paramList
	 * @param loginVO
	 * @return
	 * @throws Exception
	 */
	
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "bcm")
	public List<Map>  updateBCM120(List<Map> paramList,  LoginVO loginVO) throws Exception {
		int r = 0;
		for(Map param :paramList )	{
		    	r = super.commonDao.update("bcm104ukrvServiceImpl.updateBCM120", param);
		}
		return  paramList;
	}
	
	/**
	 * 거래처 전자문서정보 삭제
	 * @param paramList
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "bcm")
	public List<Map>  deleteBCM120(List<Map> paramList) throws Exception {
		int r = 0;
		for(Map param :paramList )	{
				  r = super.commonDao.delete("bcm104ukrvServiceImpl.deleteBCM120", param);
		}
		return  paramList;
	}
	
	
	/**
	 * 거래처 빠른등록
	 * @param paramList
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "bcm")
	public List<Map>  insertSimple(List<Map> paramList) throws Exception {
		
		for(Map param :paramList )	{
	    	Map result = (Map)super.commonDao.queryForObject("bcm104ukrvServiceImpl.insertSimple", param);
	        param.put("CUSTOM_CODE", result.get("CUSTOM_CODE"));
	    }
		return  paramList;
	}
	
	/**
	 * 현미지급금, 현재고금액 가져오기 
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
	public List<Map> getUnPayAmt(Map param, LoginVO user) throws Exception {
		return  super.commonDao.list("bcm104ukrvServiceImpl.getUnPayAmt", param);
	}

}
