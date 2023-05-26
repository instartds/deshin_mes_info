package foren.unilite.modules.z_kocis;

import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
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

@Service("s_hpa350ukrService_KOCIS")
@SuppressWarnings({"rawtypes","unchecked"})
public class S_Hpa350ukrServiceImpl_KOCIS extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	/**
	 * 컬럼 조회
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List selectColumns(LoginVO loginVO) throws Exception {
		Map param = new HashMap(); 
		param.put("S_COMP_CODE", loginVO.getCompCode());
		return (List) super.commonDao.list(
				"s_hpa350ukrServiceImpl_KOCIS.selectColumns", param);
	}

	/**
	 * 급여내역일괄조정 데이터 조회
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@Transactional(readOnly = true)
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hpa")
	public List<Map<String, Object>> selectList(Map param) throws Exception {
        List WageCodeArray	= new ArrayList();
		
		String KeyValue	= (String) super.commonDao.select("s_hpa350ukrServiceImpl_KOCIS.getKeyValue", param);
		List<Map> ColumnName	= (List<Map>) super.commonDao.list("s_hpa350ukrServiceImpl_KOCIS.selectColumns", param);
		
		for(Map WageCodeList: ColumnName) {
			WageCodeArray.add(WageCodeList.get("WAGES_CODES"));
		}

		param.put("KEY_VALUE"		, KeyValue);
		param.put("WAGES_CODE"		, WageCodeArray);
		return (List) super.commonDao.list("s_hpa350ukrServiceImpl_KOCIS.selectList", param);
	}
	
	
	
	
	
	/**
	 * 급여내역일괄조정 등록
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "human")
	 @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class}) 
	 public List<Map> saveAll(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
		 if(paramList != null)	{
				List<Map> deleteList = null;
				List<Map> updateList = null;
				
				for(Map dataListMap: paramList) {
					//저장가능여부 확인
					List<Map>  checkDataList = (List<Map>)dataListMap.get("data");
					for(Map param :checkDataList )	{	
						String check_saveable = (String) super.commonDao.select("s_hpa350ukrServiceImpl_KOCIS.checkUpdateAvailable", param);
						if(!check_saveable.equals("Y")) {
			    			throw new  UniDirectValidateException(check_saveable);
						}
					}
					
					if(dataListMap.get("method").equals("deleteList")) {
						deleteList = (List<Map>)dataListMap.get("data");
					} else if(dataListMap.get("method").equals("updateList")) {
						updateList = (List<Map>)dataListMap.get("data");	
					} 
				}			
				if(deleteList != null) this.deleteList(deleteList, user);
				if(updateList != null) this.updateList(updateList, user);				
			}
		 	paramList.add(0, paramMaster);
				
		 	return  paramList;
	}

	/**
	 * 지급 내역 / 공제내역을 삭제함
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "human")		// DELETE
	public Integer deleteList(List<Map> paramList,  LoginVO user) throws Exception {
		Map compCodeMap = new HashMap();
		compCodeMap.put("S_COMP_CODE", user.getCompCode());
		List<Map> chkList = (List) super.commonDao.list("s_hpa350ukrServiceImpl_KOCIS.checkCompCode", compCodeMap);
		 for(Map param :paramList )	{	
			 for(Map checkCompCode : chkList) {
				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				 super.commonDao.update("s_hpa350ukrServiceImpl_KOCIS.deleteList", param);
			 }
		 }
		 return 0;
	} 

	/**
	 * 지급 내역 수정
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hpa")
	public List<Map> updateList(List<Map> paramList, LoginVO user) throws Exception {
		Map compCodeMap = new HashMap();
		compCodeMap.put("S_COMP_CODE", user.getCompCode());
		
		
//		List<Map> chkList = (List<Map>) super.commonDao.list("s_hpa350ukrServiceImpl_KOCIS.checkCompCode", compCodeMap);
		for (Map param : paramList) {
			int count1				= 0;
			int count2				= 0;
			String WAGES_PAY		= "";
			String WAGES_DED		= "";
			
			Iterator<String> keys	= param.keySet().iterator();
			
			while (keys.hasNext()) {
				String key = keys.next();
				if(ObjUtils.isNotEmpty(param.get(key))) {
					String value = param.get(key).toString();
					//지급항목 데이터 추출
					if (key.indexOf("WAGES_PAY") != -1) {
						WAGES_PAY = WAGES_PAY + key.replace("WAGES_PAY", "") + ":" + value + ";";
						count1++;
					}
					//공제항목 데이터 추출
					if (key.indexOf("WAGES_DED") != -1) {
						WAGES_DED = WAGES_DED + key.replace("WAGES_DED", "") + ":" + value + ";";
						count2++;
					}
				}
			}
			//지급항목 데이터 가공
			if (WAGES_PAY.length() == WAGES_PAY.lastIndexOf(";") + 1) {
//				WAGES_PAY = WAGES_PAY.substring(0,(WAGES_PAY.length() - 1));
				
				for(int i = 0; i < count1; i++){
					String temp1 = WAGES_PAY.split(";")[i];
					param.put("WAGES_CODE"	, temp1.split(":")[0]);
					param.put("AMOUNT_I"	, temp1.substring(4));
					super.commonDao.update("s_hpa350ukrServiceImpl_KOCIS.updateList1", param);
				}
			}
			//공제항목 데이터 가공
			if (WAGES_DED.length() == WAGES_DED.lastIndexOf(";") + 1) {
//				WAGES_DED = WAGES_DED.substring(0,(WAGES_DED.length() - 1));
				
				for(int i = 0; i < count2; i++){
					String temp2 = WAGES_DED.split(";")[i];
					param.put("DED_CODE"		, temp2.split(":")[0]);
					param.put("DED_AMOUNT_I"	, temp2.substring(4));
					super.commonDao.update("s_hpa350ukrServiceImpl_KOCIS.updateList2", param);
				}
			}
			
			super.commonDao.update("s_hpa350ukrServiceImpl_KOCIS.updateList", param);
		}
		return paramList;

	}
	
}
