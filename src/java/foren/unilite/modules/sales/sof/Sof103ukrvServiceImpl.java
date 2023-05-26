package foren.unilite.modules.sales.sof;

import java.lang.reflect.Array;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.logging.InjectLogger;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;

@Service("sof103ukrvService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Sof103ukrvServiceImpl  extends TlabAbstractServiceImpl {
//	/**
//	 * 조회 로직 - 일단 사용 안 함
//	 * @param param
//	 * @return
//	 * @throws Exception
//	 */
//	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
//	public List<Map<String, Object>>  selectList(Map param) throws Exception {
//		return  super.commonDao.list("sof103ukrvServiceImpl.selectList", param);
//	}

	/*
	 * 엑셀업로드 관련 로직
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)		// 엑셀 업로드
	public List<Map<String, Object>> selectExcelUploadSheet(Map param) throws Exception {
		return super.commonDao.list("sof103ukrvServiceImpl.selectExcelUploadSheet", param);
	}

	public void excelValidate(String jobID, Map param) {							// 엑셀 Validate
		super.commonDao.update("sof103ukrvServiceImpl.excelValidate", param);
		/* 사업장에 대한 품목정보가 존재하지 않을때 B141 품목자동생성방법 1수동, 2자동 SUB_CODE = '2' 의 REF_CODE1 = 'Y' 일때 */
		/* BPR220T에 품목계정이 '제품'으로 되어있는 데이터를 기본으로 하여 BPR100T에 INSERT 하고 아니면 에러 update . */
		Map checkB141 = (Map) super.commonDao.select("sof103ukrvServiceImpl.checkB141", param);
		String checkValue = "1";
		
		if(ObjUtils.isNotEmpty(checkB141)){
			checkValue = ObjUtils.getSafeString(checkB141.get("SUB_CODE"));
		}
		List<Map<String, Object>> checkItemCodeList = super.commonDao.list("sof103ukrvServiceImpl.checkItemCode", param);
		if(ObjUtils.isNotEmpty(checkItemCodeList)){
			for(Map dataMap : checkItemCodeList){
				param.put("ITEM_CODE", dataMap.get("ITEM_CODE"));
				param.put("ITEM_NAME", dataMap.get("ITEM_NAME"));
				if(checkValue.equals("2")){
					super.commonDao.update("sof103ukrvServiceImpl.insertItemCode", param);
				} else {
					super.commonDao.update("sof103ukrvServiceImpl.updateItemCode", param);
				}
			}
		}
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		if(paramList != null)   {
			List<Map> insertList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("insertDetail")) {
					insertList = (List<Map>)dataListMap.get("data");
				}
			}
			if(insertList != null) this.insertDetail(insertList, user,dataMaster);
		}
		paramList.add(0, paramMaster);
		return paramList;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
	public void insertDetail(List<Map> paramList, LoginVO user, Map dataMaster) throws Exception {
		String keyValue = getLogKey();
		ArrayList<String> keyArry = new ArrayList<String>();
		for(Map param : paramList) {
			param.put("KEY_VALUE", keyValue.substring(0,19) + ObjUtils.getSafeString(param.get("CUST_NO")));
			param.put("OPR_FLAG", "N");
			//금액, 세액 합계 MASTER에 넣기위해서  2번 루프 실행
//			if("1".equals(ObjUtils.getSafeString(param.get("CUST_SEQ")))){
//				keyArry.add(ObjUtils.getSafeString(param.get("KEY_VALUE"))); 
//				super.commonDao.insert("sof103ukrvServiceImpl.insertLogMaster", param);
//			}
			param.put("SER_NO", param.get("CUST_SEQ"));
			super.commonDao.insert("sof103ukrvServiceImpl.insertLogDetail", param);
		}
		for(Map param : paramList) {
			if("1".equals(ObjUtils.getSafeString(param.get("CUST_SEQ")))){
				keyArry.add(ObjUtils.getSafeString(param.get("KEY_VALUE"))); 
				super.commonDao.insert("sof103ukrvServiceImpl.insertLogMaster", param);
			}
		}
		
//		ArrayList<String> orderNumArry = new ArrayList<String>();
		for(int i=0; i < keyArry.size(); i++){
			Map<String, Object> spParam = new HashMap<String, Object>();
			spParam.put("KeyValue", keyArry.get(i));
			spParam.put("LangCode", user.getLanguage());

			super.commonDao.queryForObject("sof103ukrvServiceImpl.spSalesOrder", spParam);
			
			String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
			if(!ObjUtils.isEmpty(errorDesc)){
				String[] messsage = errorDesc.split(";");
				throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
			} else {
//				orderNumArry.add(ObjUtils.getSafeString(spParam.get("OrderNum")));
			}
		}
//		String orderNum = "";
//		for(String dorderNum : orderNumArry)	{
//			orderNum = orderNum+"'"+dorderNum+"',";
//		}
//		if(!"".equals(orderNum))	{
//			orderNum = orderNum.substring(0, orderNum.length()-1);
//			dataMaster.put("orderNums", orderNum);
//		}
		return;
	}
}