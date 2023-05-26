package foren.unilite.modules.human.hpa;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

import org.slf4j.Logger;

import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;


@Service("hpa320ukrService")
public class Hpa320ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	/**
	 * 저장
	 * @param paramList
	 * @param paramMaster
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "human")
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> param = new HashMap();
		param.put("SAMPLE_SQL", "select top 1 getdate() as t from BSA100T");
		Map<String, Object> rtn = (Map<String, Object> )super.commonDao.select("hpa320ukrServiceImpl.selectSample", param);
		logger.debug("#####################################################################################################");
		logger.debug(" Test "+rtn.get("t"));
		logger.debug("#####################################################################################################");
		/*
		//1.로그테이블에서 사용할 Key 생성		
		String keyValue = getLogKey();			

		//2.마스터 로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");

		dataMaster.put("KEY_VALUE", keyValue);
		dataMaster.put("COMP_CODE", user.getCompCode());

		if (ObjUtils.isEmpty(dataMaster.get("ORDER_NUM") )) {
			dataMaster.put("OPR_FLAG", "N");
		} else {
			dataMaster.put("OPR_FLAG", "U");
		}

		super.commonDao.insert("hpa230ukrServiceImpl.insertLogMaster", dataMaster);
		
		//3.디테일 로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
		List<Map> dataList = new ArrayList<Map>();
		List<List<Map>> resultList = new ArrayList<List<Map>>();
		if(paramList != null)	{
			for(Map param: paramList) {
				dataList = (List<Map>)param.get("data");
	
				if(param.get("method").equals("insertDetail")) {
					param.put("data", insertLogDetails(dataList, keyValue, "N") );	
				} else if(param.get("method").equals("updateDetail")) {
					param.put("data", insertLogDetails(dataList, keyValue, "U") );	
				} else if(param.get("method").equals("deleteDetail")) {
					param.put("data", insertLogDetails(dataList, keyValue, "D") );	
				}
			}
		}

		//4.저장 Stored Procedure 실행
		Map<String, Object> spParam = new HashMap<String, Object>();

		spParam.put("KeyValue", keyValue);
		spParam.put("LangCode", user.getLanguage());

		super.commonDao.queryForObject("spName", spParam);
		
		String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));

		if(!errorDesc.isEmpty()){
			dataMaster.put("ORDER_NUM", "");
			throw new Exception(errorDesc);
		} else {
			//마스터에 SET
			dataMaster.put("ORDER_NUM", ObjUtils.getSafeString(spParam.get("OrderNum")));
			//그리드에 SET
			for(Map param: paramList) {
				dataList = (List<Map>)param.get("data");	
				if(param.get("method").equals("insertDetail")) {
					List<Map> datas = (List<Map>)param.get("data");
					for(Map data: datas){
						data.put("ORDER_NUM", ObjUtils.getSafeString(spParam.get("OrderNum")));
					}
				}
			}
		}
		*/
		//5.마스터 정보 + 디테일 정보 결과셋 리턴
		//마스터정보가 없을 경우에도 작성
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	public List<Map> insertLogDetails(List<Map> params, String keyValue, String oprFlag) throws Exception {
		for(Map param: params)		{
			param.put("KEY_VALUE", keyValue);
			param.put("OPR_FLAG", oprFlag);
			
			super.commonDao.insert("hpa230ukrServiceImpl.insertLogDetail", param);
		}		

		return params;
	}


	
}
	
