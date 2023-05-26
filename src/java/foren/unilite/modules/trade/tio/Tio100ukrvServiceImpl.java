package foren.unilite.modules.trade.tio;

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
@Service("tio100ukrvService")
public class Tio100ukrvServiceImpl extends TlabAbstractServiceImpl {
	
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	
	/**
	 * TIA100T form search
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_LOAD, group = "trade")
	public Object selectForMaster(Map param) throws Exception {
		return  super.commonDao.select("tio100ukrvServiceImpl.selectForMaster", param);
	}
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "trade")
	public List<Map<String, Object>>  selectOrderNumMasterList(Map param) throws Exception {
		List<Map<String, Object>> selectList =  super.commonDao.list("tio100ukrvServiceImpl.selectOrderNumMasterList", param);
		return  selectList;
	}
	/**
	 * TIA110T detail grid search
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "trade")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
		List<Map<String, Object>> selectList =  super.commonDao.list("tio100ukrvServiceImpl.selectList", param);
		return  selectList;
	}
	
	/**
	 * ref search
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "trade")
	public List<Map<String, Object>>  fnOrderDetail(Map param) throws Exception {
		List<Map<String, Object>> selectList =  super.commonDao.list("tio100ukrvServiceImpl.fnOrderDetail", param);
		return  selectList;
	}
	/**
	 * otherRef search
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "trade")
	public List<Map<String, Object>>  fnOfferDetail(Map param) throws Exception {
		List<Map<String, Object>> selectList =  super.commonDao.list("tio100ukrvServiceImpl.fnOfferDetail", param);
		return  selectList;
	}
	/**
	 * excel Validate
	 * @param jobID
	 * @param param
	 */
	 public void excelValidate(String jobID, Map param) {
		    logger.debug("validate: {}", jobID);
			//super.commonDao.update("afb100ukrServiceImpl.excelValidate", param);
	}
	 
 	
 	/**
 	 * excel search
 	 * @param param
 	 * @return
 	 * @throws Exception
 	 */
 	@ExtDirectMethod(group = "trade", value = ExtDirectMethodType.STORE_READ)
    public List<Map<String, Object>> selectExcelUploadSheet1(Map param) throws Exception {
        return super.commonDao.list("tio100ukrvServiceImpl.selectExcelUploadSheet1", param);
    }
 	/**
 	 * 용      도  :  자사코드 가져오기
 	 * 本公司代码导入
 	 * @param param
 	 * @return
 	 * @throws Exception
 	 */
 	@ExtDirectMethod(group = "trade", value = ExtDirectMethodType.STORE_READ)
    public Object fnGetCompany(Map param, LoginVO loginVO) throws Exception {
 		param.put("MAIN_CODE", "T000");
        return  super.commonDao.select("tio100ukrvServiceImpl.fnGetCompany", param);
    }
 	
 	@ExtDirectMethod(group = "trade", value = ExtDirectMethodType.STORE_READ)
    public Object fnGetPrice(Map param, LoginVO loginVO) throws Exception {
        return  super.commonDao.select("tio100ukrvServiceImpl.fnGetPrice", param);
    }
 	
 	@ExtDirectMethod(group = "trade", value = ExtDirectMethodType.STORE_READ)
    public Object fnGetInspec(Map param, LoginVO loginVO) throws Exception {
        return  super.commonDao.select("tio100ukrvServiceImpl.fnGetInspec", param);
    }
 	
 	@ExtDirectMethod(group = "trade", value = ExtDirectMethodType.STORE_READ)
    public Object fnGetAgreePrsn(Map param, LoginVO loginVO) throws Exception {
        return  super.commonDao.select("tio100ukrvServiceImpl.fnGetAgreePrsn", param);
    }
 	
// 	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "trade")
//	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
//	public List<Map> saveAll(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
//		logger.debug("[saveAll] paramDetail:" + paramList);
//
//		//1.로그테이블에서 사용할 KeyValue 생성
//		String keyValue = getLogKey();						
//				
//		//2.출하지시 로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
//		List<Map> dataList = new ArrayList<Map>();
//		List<List<Map>> resultList = new ArrayList<List<Map>>();
//		
//		for(Map paramData: paramList) {			
//			
//			dataList = (List<Map>) paramData.get("data");
//			String oprFlag = "N";
////				if(paramData.get("method").equals("insertDetail"))	oprFlag="N";
//			if(paramData.get("method").equals("updateList"))	oprFlag="U";
////				if(paramData.get("method").equals("deleteDetail"))	oprFlag="D";
//
//			for(Map<String, Object> param:  dataList) {
//				param.put("KEY_VALUE", keyValue);
//				param.put("OPR_FLAG", oprFlag);
//				param.put("data", super.commonDao.insert("tio100ukrvServiceImpl.insertLogMaster", param));
//			}
//		}
//
//		//4.출하지시저장 Stored Procedure 실행
//		Map<String, Object> spParam = new HashMap<String, Object>();
//
//		spParam.put("KEY_VALUE", keyValue);
//		spParam.put("LANG_CODE", user.getLanguage());
//		spParam.put("ERROR_DESC","");
//
//		super.commonDao.queryForObject("spMap300ukrv", spParam);
//		
//		String errorDesc = ObjUtils.getSafeString(spParam.get("ERROR_DESC"));
//		
//		if(!ObjUtils.isEmpty(errorDesc)){
//			String[] messsage = errorDesc.split(";");
//		    throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
//		} else {
//		}
//		
//		paramList.add(0, paramMaster);
//			
//		return  paramList;
//	}
 	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "trade")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
		logger.debug("[saveAll] paramDetail:" + paramList);

		//1.로그테이블에서 사용할 KeyValue 생성
		String keyValue = getLogKey();						
		//2.출하지시 로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		dataMaster.put("KEY_VALUE", keyValue);
		if (ObjUtils.isEmpty(dataMaster.get("SO_SER_NO") )) {
            dataMaster.put("OPR_FLAG", "N");
        } else {
            dataMaster.put("OPR_FLAG", "U");
        }
		super.commonDao.insert("tio100ukrvServiceImpl.insertLogMaster", dataMaster);
		
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
				param.put("OPR_FLAG", oprFlag);
				if("".equals(param.get("ORDER_SEQ"))){
					param.put("ORDER_SEQ", null);
				}
				if(ObjUtils.isEmpty(param.get("RECEIPT_QTY"))){
					param.put("RECEIPT_QTY", 0);
				}
				
				param.put("data", super.commonDao.insert("tio100ukrvServiceImpl.insertLogDetail", param));
//				if("N".equals(oprFlag) || "D".equals(oprFlag)){
//					param.put("data", super.commonDao.insert("tio100ukrvServiceImpl.insertLogDetail", param));
//				}else{
//					param.put("data", super.commonDao.insert("tio100ukrvServiceImpl.updateLogDetail", param));
//				}
			}
		}

		//4.출하지시저장 Stored Procedure 실행
		Map<String, Object> spParam = new HashMap<String, Object>();
		
		spParam.put("KeyValue", keyValue);
		spParam.put("LangCode", user.getLanguage());

	    super.commonDao.queryForObject("tio100ukrvServiceImpl.spTradeTia100ukrv", spParam);
		
		String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
		
		//출하지시 마스터 출하지시 번호 update
//		for(Map param : paramList )	{
		if(!ObjUtils.isEmpty(errorDesc)){
			dataMaster.put("SO_SER_NO", "");
			String[] messsage = errorDesc.split(";");
		    throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
		} else {
			//마스터에 SET
			dataMaster.put("SO_SER_NO", ObjUtils.getSafeString(spParam.get("SoSerNo")));
			//그리드에 SET
			for(Map param: paramList)  {
				dataList = (List<Map>)param.get("data");	
				if(param.get("method").equals("insertDetail")) {
					List<Map> datas = (List<Map>)param.get("data");
					for(Map data: datas){
						data.put("SO_SER_NO", ObjUtils.getSafeString(spParam.get("SoSerNo")));
					}
				}
			}		
			
		}
		paramList.add(0, paramMaster);
		
		return  paramList;
	}
	
	/**
	 * 수주 Detail 입력
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> insertDetail(List<Map> params, LoginVO user) throws Exception {
		for(Map param: params)		{
			super.commonDao.insert("mms510ukrvServiceImpl.insertDetail", param);
		}		

		return params;
	}
	
	/**
	 * 수주 Detail 수정
	 */
	@SuppressWarnings("rawtypes")
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> updateDetail(List<Map> params, LoginVO user) throws Exception {
		for(Map param: params)		{
			super.commonDao.insert("mms510ukrvServiceImpl.updateDetail", param);
		}		
		return params;
	}
	
	/**
	 * 수주 Detail 삭제
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_MODIFY)
	public void deleteDetail(List<Map> params, LoginVO user) throws Exception {
		for(Map<String, Object> param : params)	{
			super.commonDao.delete("mms510ukrvServiceImpl.deleteDetail", param);
		}
		super.commonDao.delete("mms510ukrvServiceImpl.checkDeleteAllDetail", params.get(0)); 
	}
	
    /**
     * 
     * 마스터 기안상태 조회
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
    public List<Map<String, Object>> selectGwData(Map param) throws Exception {
        return super.commonDao.list("tio100ukrvServiceImpl.selectGwData", param);
    }
}
