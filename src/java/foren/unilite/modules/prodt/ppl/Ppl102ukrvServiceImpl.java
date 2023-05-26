package foren.unilite.modules.prodt.ppl;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
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

@Service("ppl102ukrvService")
@SuppressWarnings({ "unchecked", "rawtypes" })
public class Ppl102ukrvServiceImpl  extends TlabAbstractServiceImpl {

	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	/**
	 * 작업장 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@Transactional(readOnly=true) //, isolation=TransactionDefinition.ISOLATION_READ_UNCOMMITTED) 
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public Object  fnWorkShopCode(Map param) throws Exception {	

		return  super.commonDao.select("ppl102ukrvServiceImpl.fnWorkShopCode", param);
	}

	/**
	 * 생산계획 등록 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectDetailList(Map param) throws Exception {
		return super.commonDao.list("ppl102ukrvServiceImpl.selectDetailList", param);
	}



	/**
	 * Main Grid saveAll
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "prodt")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		List<Map> dataList = new ArrayList<Map>();
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		
		for(Map paramData: paramList) {
			dataList = (List<Map>) paramData.get("data");
			
			if(paramData.get("method").equals("insertDetail"))	
				this.insertDetail(dataList, dataMaster, user);
			if(paramData.get("method").equals("updateDetail"))	
				this.updateDetail(dataList, dataMaster, user);
			if(paramData.get("method").equals("deleteDetail"))
				this.deleteDetail(dataList, dataMaster, user);
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	/* Main Grid directProxy */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")		// INSERT
	public Integer insertDetail(List<Map> paramList, Map dataMaster, LoginVO user) throws Exception {
		for (Map param : paramList) {
			if(param.get("WORK_SHOP_CODE") == null) {
				param.put("WORK_SHOP_CODE", "*");
			}
			
			for(int i = 1; i < 32; i++) {
//				if(ObjUtils.parseInt(param.get("DAY"+i+"_Q")) != 0) {
					param.put("WK_PLAN_Q", param.get("DAY"+i+"_Q"));
					if(i < 10) {
						param.put("PRODT_PLAN_DATE", dataMaster.get("FR_DATE").toString() + "0" + i + "");
					}else {
						param.put("PRODT_PLAN_DATE", dataMaster.get("FR_DATE").toString() + i );
					}
					
					//20181120 이전로직은 오류 메시지 -> 삭제로 변경
//					Map cnt = (Map) super.commonDao.select("ppl102ukrvServiceImpl.checkBeforeInsert", param);
					super.commonDao.update("ppl102ukrvServiceImpl.checkBeforeInsert", param);
//					if(ObjUtils.parseInt(cnt.get("CNT")) > 0) {
//						throw new UniDirectValidateException(this.getMessage("2627", user));
//					}
					
					
					if(ObjUtils.parseDouble(param.get("WK_PLAN_Q")) != 0) {
						Map<String, Object> spParam = new HashMap<String, Object>();
						
						SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMdd");
						Date dateGet = new Date();
						String dateGetString = dateFormat.format(dateGet);
						
						spParam.put("COMP_CODE", user.getCompCode());
						spParam.put("DIV_CODE", user.getDivCode());
						spParam.put("TABLE_ID", "PPL100T");
						spParam.put("PREFIX", "P");
						spParam.put("BASIS_DATE", dateGetString);
						spParam.put("AUTO_TYPE", "1");
						super.commonDao.queryForObject("ppl102ukrvServiceImpl.spAutoNum", spParam);
						
						param.put("KEY_NUMBER", ObjUtils.getSafeString(spParam.get("KEY_NUMBER")));
						super.commonDao.update("ppl102ukrvServiceImpl.insertDetail", param);
					}
//				}
			}
		}
		return 0;
	}	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")		// UPDATE
	public Integer updateDetail(List<Map> paramList, Map dataMaster, LoginVO user) throws Exception {
		for (Map param : paramList) {
			if(param.get("WORK_SHOP_CODE") == null) {
				param.put("WORK_SHOP_CODE", "*");
			}
			
			for(int i = 1; i < 32; i++) {
				param.put("WK_PLAN_Q", param.get("DAY"+i+"_Q"));
				if(i < 10) {
					param.put("PRODT_PLAN_DATE", dataMaster.get("FR_DATE").toString() + "0" + i + "");
				} else {
					param.put("PRODT_PLAN_DATE", dataMaster.get("FR_DATE").toString() + i);
				}
				
				Map wkPlanNum = (Map) super.commonDao.select("ppl102ukrvServiceImpl.getWkPlanNum", param);
				System.out.println(wkPlanNum);
				if(wkPlanNum != null && wkPlanNum.get("WK_PLAN_NUM") != null) {
					param.put("WK_PLAN_NUM", wkPlanNum.get("WK_PLAN_NUM"));
					super.commonDao.update("ppl102ukrvServiceImpl.updateDetail", param);
					
				} else {
					if(ObjUtils.parseInt(param.get("DAY"+i+"_Q")) != 0) {
						Map<String, Object> spParam = new HashMap<String, Object>();
						
						SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMdd");
						Date dateGet = new Date();
						String dateGetString = dateFormat.format(dateGet);
						
						spParam.put("COMP_CODE", user.getCompCode());
						spParam.put("DIV_CODE", user.getDivCode());
						spParam.put("TABLE_ID", "PPL100T");
						spParam.put("PREFIX", "P");
						spParam.put("BASIS_DATE", dateGetString);
						spParam.put("AUTO_TYPE", "1");
						super.commonDao.queryForObject("ppl102ukrvServiceImpl.spAutoNum", spParam);
						
						param.put("KEY_NUMBER", ObjUtils.getSafeString(spParam.get("KEY_NUMBER")));
						super.commonDao.update("ppl102ukrvServiceImpl.insertDetail", param);
					}
				}
			}
		}
		return 0;
	} 
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")		// DELETE
	public Integer deleteDetail(List<Map> paramList, Map dataMaster, LoginVO user) throws Exception {
		for(Map param : paramList )	{
//			if(param.get("GUBUN").toString().equals("계획")) {
				for(int i = 1; i < 32; i++) {
					String s = "WK_PLAN_NUM" + i;
					if(param.get(s) != null) {
						param.put("WK_PLAN_NUM", param.get(s));
						
						if(i < 10) {
							param.put("PRODT_PLAN_DATE", dataMaster.get("FR_DATE").toString() + "0" + i + "");
							
						} else {
							param.put("PRODT_PLAN_DATE", dataMaster.get("FR_DATE").toString() + i);
						}
						logger.debug("param:" + param);
						System.out.println(param.toString());
						super.commonDao.update("ppl102ukrvServiceImpl.deleteDetail", param);
					}
				}
//			}
		}
		return 0;
	}






	/**
	 * 엑셀 업로드
	 * @param jobID
	 * @param param
	 * @throws Exception
	 */
	public void excelValidate(String jobID, Map param) throws Exception {
		logger.debug("validate: {}", jobID);
		//UPLOAD 전 데이터 존재여부 체크
		List<Map> getData = (List<Map>) super.commonDao.list("ppl102ukrvServiceImpl.getData", param);
		
		if(!getData.isEmpty()){
			//excel 파일의 데이터 체크
			for(Map data : getData )  {
				param.put("ROWNUM"			, data.get("_EXCEL_ROWNUM"));
				param.put("COMP_CODE"		, data.get("COMP_CODE"));
				param.put("ITEM_CODE"		, data.get("ITEM_CODE"));
				param.put("WORK_SHOP_CODE"	, data.get("WORK_SHOP_CODE"));

				//업로드 된 데이터의 품목코드 / 작업장 기등록여부 확인
				Map existYn = (Map) super.commonDao.select("ppl102ukrvServiceImpl.checkItem", param);
				if (existYn.get("CHECK_DATA1").equals("N")) {
					if(ObjUtils.isNotEmpty(data.get("ITEM_CODE"))) {
						param.put("MSG", "품목코드 [" + data.get("ITEM_CODE") +"]를 먼저 등록한 후 업로드 해 주세요.");
						super.commonDao.update("ppl102ukrvServiceImpl.insertErrorMsg", param);
					}
				}
				if (existYn.get("CHECK_DATA2").equals("N")) {
					if(ObjUtils.isNotEmpty(data.get("WORK_SHOP_CODE"))) {
						param.put("MSG", "작업장코드 [" + data.get("WORK_SHOP_CODE") +"]를 먼저 등록한 후 업로드 해 주세요.");
						super.commonDao.update("ppl102ukrvServiceImpl.insertErrorMsg", param);
					}
				}
			}
		} 
	}
	
	@ExtDirectMethod(group = "sgp", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectExcelUploadSheet1(Map param) throws Exception {
		return super.commonDao.list("ppl102ukrvServiceImpl.selectExcelUploadSheet1", param);
	}
	
	/**
	 * 업로드 한 데이터를 masterGrid1에 set하기 위해 select
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sgp", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectUploadData(Map param) throws Exception {
		return super.commonDao.list("ppl102ukrvServiceImpl.selectUploadData", param);
	}
}
