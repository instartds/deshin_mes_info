package foren.unilite.modules.stock.biv;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.exolab.castor.mapping.xml.Param;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.BindingResult;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.extjs.UniliteExtjsUtils;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.base.bdc.Bdc100ukrvService;
import foren.unilite.modules.com.fileman.FileMnagerService;



@Service("biv201skrvService")
public class Biv201skrvServiceImpl  extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	
	
	@ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)
	public Object  userWhcode(Map param) throws Exception {	
		return  super.commonDao.select("biv201skrvServiceImpl.userWhcode", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "stock")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
	
		return  super.commonDao.list("biv201skrvServiceImpl.selectList", param);
	}
	
	
/*	*//**
	 * 제조품 실적처리-> 저장
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 *//*
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		//logger.debug("[saveAll] paramMaster:" + paramMaster);
		//logger.debug("[saveAll] paramDetail:" + paramList);

		
		
		String keyValue = getLogKey();			


		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");

		List<Map> dataList = new ArrayList<Map>();
		List<List<Map>> resultList = new ArrayList<List<Map>>();
		if(paramList != null)	{
			for(Map param: paramList) {
				dataList = (List<Map>)param.get("data");
	

				param.put("DIV_CODE", dataMaster.get("DIV_CODE"));
				param.put("SALE_DATE_FR", dataMaster.get("SALE_DATE_FR"));
				param.put("SALE_DATE_TO", dataMaster.get("SALE_DATE_TO"));
				
				
				if(param.get("method").equals("insertDetail")) {
					param.put("data", insertLogDetails(dataList, keyValue, "N") );	
				} else if(param.get("method").equals("updateDetail")) {
					param.put("data", insertLogDetails(dataList, keyValue, "U") );	
				} else if(param.get("method").equals("deleteDetail")) {
					param.put("data", insertLogDetails(dataList, keyValue, "D") );	
				}
			}
		}

		//4. Stored Procedure 실행
		Map<String, Object> spParam = new HashMap<String, Object>();

		spParam.put("KeyValue", keyValue);
		spParam.put("LangCode", user.getLanguage());

		super.commonDao.queryForObject("spPurchaseOrder", spParam);
		
		String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));

		if(!ObjUtils.isEmpty(errorDesc)){
			String[] messsage = errorDesc.split(";");
		    throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
		} else {
				
		}
		
		paramList.add(0, paramMaster);
				
		return  paramList;
	}*/
		/**
	 * 제조품 실적처리-> 저장
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "stock")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
		logger.debug("[saveAll] paramDetail:" + paramList);

		//1.로그테이블에서 사용할 KeyValue 생성
		String keyValue = getLogKey();						
		
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");

		List<Map> dataList = new ArrayList<Map>();
		List<List<Map>> resultList = new ArrayList<List<Map>>();
		
		for(Map paramData: paramList) {			
			
			dataList = (List<Map>) paramData.get("data");
			String oprFlag = "N";
			if(paramData.get("method").equals("insertDetail"))	oprFlag="N";
			if(paramData.get("method").equals("updateDetail"))	oprFlag="U";
			if(paramData.get("method").equals("deleteDetail"))	oprFlag="D";

			
			
			
			for(Map param:  dataList) {
				
				param.put("KEY_VALUE", keyValue);
				if(param.get("CHECK").equals("1")){
					param.put("OPR_FLAG", 'N');
				}else{
					param.put("OPR_FLAG", 'D');
				}
				
				
				param.put("DIV_CODE", dataMaster.get("DIV_CODE"));
				param.put("SALE_DATE_FR", dataMaster.get("SALE_DATE_FR"));
				param.put("SALE_DATE_TO", dataMaster.get("SALE_DATE_TO"));
			
				param.put("data", super.commonDao.insert("biv201skrvServiceImpl.insertLog", param));
			//	param.put("data", super.commonDao.update("map101ukrvServiceImpl.insertLogForm", param));
			}
		}

		//4.제조품 실적처리 Stored Procedure 실행
		Map<String, Object> spParam = new HashMap<String, Object>();

		spParam.put("KeyValue", keyValue);
		spParam.put("LangCode", user.getLanguage());

		super.commonDao.queryForObject("spRawItemReducing", spParam);
		
		String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
		
		
		if(!ObjUtils.isEmpty(errorDesc)){
			String[] messsage = errorDesc.split(";");
		    throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
		} else {
			
		}
		
		
		paramList.add(0, paramMaster);
		
		return  paramList;
	}
	
/*	public List<Map> insertLogDetails(List<Map> params, String keyValue, String oprFlag) throws Exception {
		for(Map param: params)		{
			param.put("KEY_VALUE", keyValue);
//			param.put("OPR_FLAG", oprFlag);
			if(param.get("CHECK").equals("1")){
				param.put("OPR_FLAG", 'N');
			}else{
				param.put("OPR_FLAG", 'D');
			}
			
			super.commonDao.insert("biv201skrvServiceImpl.insertLog", param);
		}		

		return params;
	}*/
	
	@ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> insertDetail(List<Map> params, LoginVO user) throws Exception {
		
		return params;
	}
//	@SuppressWarnings("rawtypes")
	@ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> updateDetail(List<Map> params, LoginVO user) throws Exception {
		
		return params;
	}

	@ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_MODIFY)
	public void deleteDetail(List<Map> params, LoginVO user) throws Exception {
	
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	

	
}
