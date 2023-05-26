package foren.unilite.modules.sales.str;

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

@Service("str411ukrvService")
@SuppressWarnings({ "unchecked", "rawtypes" })
public class Str411ukrvServiceImpl  extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	/**
	 * 전자거래명세서 발행(매출) - 웹캐시 MASTER 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>>  WebCashMaster(Map param) throws Exception {
		return  super.commonDao.list("str411ukrvServiceImpl.WebCashMaster", param);
	}

	/**
	 * 전자거래명세서 발행 Detail 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>>  selectDetail(Map param) throws Exception {
		return  super.commonDao.list("str411ukrvServiceImpl.selectDetail", param);
	}

	/**
	 * 연계시스템 및 품명수정여부, 출력여부, 출력파일명 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>>  getGsBillYN(Map param) throws Exception {
		return  super.commonDao.list("str411ukrvServiceImpl.getGsBillYN", param);
	}



	/**
	 * 저장
	 * @param paramList 리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		
		if(paramList != null) {
			List<Map> insertDetail = null;
			List<Map> updateDetail = null;
			List<Map> deleteDetail = null;
			
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("insertDetail")) {
					insertDetail = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("updateDetail")) {
					updateDetail = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("deleteDetail")) {
					deleteDetail = (List<Map>)dataListMap.get("data");
				}
			}
			if(insertDetail != null) this.insertDetail(insertDetail, user, dataMaster);
			if(updateDetail != null) this.updateDetail(updateDetail, user, dataMaster);
			if(deleteDetail != null) this.deleteDetail(deleteDetail, user, dataMaster);
		}
		paramList.add(0, paramMaster);
		return  paramList;
	}

	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> insertDetail(List<Map> params, LoginVO user, Map paramMaster) throws Exception {
		return params;
	}

	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_MODIFY)
	public Integer updateDetail(List<Map> params, LoginVO user, Map paramMaster) throws Exception {
		for(Map param : params) {
			super.commonDao.update("str411ukrvServiceImpl.updateDetail", param);
		}
		return 0;
	}

	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_MODIFY)
	public void deleteDetail(List<Map> params, LoginVO user, Map paramMaster) throws Exception {
	}







	/**
	 * 전자거래명세서 저장(Web Cash)
	 * @param paramList
	 * @param paramMaster
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_SYNCALL)
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> fnWebCash(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		List<Map> dataList = new ArrayList<Map>();
		Map<String, Object> dataMaster = (Map<String, Object>)paramMaster.get("data");
		String keyValue	= getLogKey();	
		Map<String, Object> spParam = new HashMap<String, Object>();

		if(paramList != null) {
			for(Map param: paramList) {
				if(param.get("method").equals("fnProgWebCash")) {
					dataList = (List<Map>)param.get("data");
					param.put("data", fnProgWebCash(dataList, paramMaster, user, keyValue) );
				}
			}
			//SP호출
			spParam.put("COMP_CODE"	, user.getCompCode());
			spParam.put("KEY_VALUE"	, keyValue);
			spParam.put("UNIT_TYPE"	, dataMaster.get("UNIT_TYPE"));		//1:판매단위, 2: 재고단위
			spParam.put("LOGIN_ID"	, user.getUserID());
			spParam.put("ERROR_DESC", "");

			super.commonDao.update("str411ukrvServiceImpl.spReceiving", spParam);

			String errorDesc = ObjUtils.getSafeString(spParam.get("ERROR_DESC"));
			if(ObjUtils.isNotEmpty(errorDesc)){
				String messsage = errorDesc.replaceAll("\\;", "");
				throw new  UniDirectValidateException(this.getMessage(messsage, user));
			}
		}
		paramList.add(0, paramMaster);
		return  paramList;
	}

	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> fnProgWebCash(List<Map> paramList, Map paramMaster, LoginVO user, String keyValue) throws Exception {
		for(Map param : paramList) {
			param.put("KEY_VALUE", keyValue);
			super.commonDao.update("str411ukrvServiceImpl.fnProgWebCash", param);
		}
		return paramList;
	}







	/**
	 * 전자거래명세서 출력(Web Cash)
	 * @param paramList
	 * @param paramMaster
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_SYNCALL)
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> fnPrintTransStat(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		List<Map> dataList = new ArrayList<Map>();
		Map<String, Object> dataMaster = (Map<String, Object>)paramMaster.get("data");
		String keyValue	= getLogKey();

		if(paramList != null) {
			for(Map param: paramList) {
				if(param.get("method").equals("fnMakePrintData")) {
					dataList = (List<Map>)param.get("data");
					this.fnMakePrintData(dataList, dataMaster, user, keyValue);
				}
			}
		}
		dataMaster.put("KEY_VALUE", keyValue);
		paramList.add(0, paramMaster);
		return  paramList;
	}

	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> fnMakePrintData(List<Map> paramList, Map paramMaster, LoginVO user, String keyValue) throws Exception {
		int i = 0;
		for(Map param : paramList) {
			i++;
			param.put("RPT_SEQ"		, i);
			param.put("KEY_VALUE"	, keyValue);
			super.commonDao.update("str411ukrvServiceImpl.fnMakePrintData", param);
		}
		return paramList;
	}

	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map<String, Object>> fnPrintData(Map param) throws Exception {
		return super.commonDao.list("str411ukrvServiceImpl.fnPrintData", param);
	}
}