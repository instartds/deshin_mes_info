package foren.unilite.modules.prodt.ppl;

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

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;

import org.apache.commons.exec.CommandLine;
import org.apache.commons.exec.DefaultExecutor;
import org.apache.commons.exec.PumpStreamHandler;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;


@Service("ppl301ukrvService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Ppl301ukrvServiceImpl  extends TlabAbstractServiceImpl {
	@InjectLogger
	public static   Logger  logger  ;// = LoggerFactory.getLogger(this.getClass());

	/**
	 * 간트챠트 데이터 가져오기
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sof")
	public String selectMaster(Map param) throws Exception {
		List<Map> dataList = new ArrayList<Map>();
		if(param.get("DUMMY_YN").equals("Y")){
			dataList = super.commonDao.list("ppl301ukrvServiceImpl.selectDummy", param);
		}else{
			dataList = super.commonDao.list("ppl301ukrvServiceImpl.selectMaster", param);
		}

		JsonObject jsonobject     		= new JsonObject();
		JsonObject eventDataParent      = new JsonObject();
		JsonObject resourceDataParent   = new JsonObject();

		JsonObject eventData      		= new JsonObject();
		JsonObject resourceData   		= new JsonObject();


		JsonObject timeRangesData   	= new JsonObject();
		JsonArray  infoArray1      		= new JsonArray();
		JsonArray  infoArray2      		= new JsonArray();
		JsonArray  infoArray3      		= new JsonArray();


		jsonobject.addProperty("success", true);
		int i = 1;
		int j = 1;
		String id = "";
		String dId = "";
		String progCode = "";
		String equCode  = "";
		String orderNum = "";
		String orderSeq = "";
		String eventId = "";
		String lunchStartTime = "";
		String lunchEndTime = "";
		String morningBreakStartTime = "";
		String morningBreakEndTime = "";
		String afterBreakStartTime = "";
		String afterBreakEndTime = "";


		for(Map jsonData : dataList) {
			JsonObject eventDataDetail      = new JsonObject();
			JsonObject resourceDataDetail   = new JsonObject();


			if(! progCode.equals((String) jsonData.get("PROG_WORK_CODE"))  && ! equCode.equals((String) jsonData.get("EQU_CODE"))
			   || progCode.equals((String) jsonData.get("PROG_WORK_CODE"))  && ! equCode.equals((String) jsonData.get("EQU_CODE")))
			{
				i = i + 1;
			    id = Integer.toString(i);

				resourceDataDetail.addProperty("id", 		 id);
				resourceDataDetail.addProperty("name", 	   	 (String) jsonData.get("RESOURCES_ROWS_NAME"));
				resourceDataDetail.addProperty("category", 	 (String) jsonData.get("RESOURCES_ROWS_CATEGORY"));
				resourceDataDetail.addProperty("type",  	 (String) jsonData.get("RESOURCES_ROWS_TYPE"));
				resourceDataDetail.addProperty("image",  	 "mike");
				resourceDataDetail.addProperty("equCode",  	 (String) jsonData.get("EQU_CODE"));
				resourceDataDetail.addProperty("progWorkCode",  	 (String) jsonData.get("PROG_WORK_CODE"));
				infoArray2.add(resourceDataDetail);
			}

			eventDataDetail.addProperty("id", 			(String) jsonData.get("EVENTS_ROWS_ID"));
			eventDataDetail.addProperty("name", 		(String) jsonData.get("EVENTS_ROWS_NAME"));
			eventDataDetail.addProperty("resourceId", 	id);
			eventDataDetail.addProperty("startDate",  	(String) jsonData.get("EVENTS_ROWS_START_DATE"));
			eventDataDetail.addProperty("endDate",    	(String) jsonData.get("EVENTS_ROWS_END_DATE"));
			eventDataDetail.addProperty("iconCls",    	(String) jsonData.get("EVENTS_ROWS_ICONCLS"));
			eventDataDetail.addProperty("wkPlanNum",    (String) jsonData.get("WK_PLAN_NUM"));
			eventDataDetail.addProperty("lotNo",    	(String) jsonData.get("LOT_NO"));
			eventDataDetail.addProperty("equCode",    	(String) jsonData.get("EQU_CODE"));
			eventDataDetail.addProperty("progWorkCode", (String) jsonData.get("PROG_WORK_CODE"));
			eventDataDetail.addProperty("scheduleNo",   String.valueOf(jsonData.get("SCHEDULE_NO")));
			eventDataDetail.addProperty("planTime",     String.valueOf(jsonData.get("PLAN_TIME")));
			eventDataDetail.addProperty("actSetM",   	String.valueOf(jsonData.get("ACT_SET_M")));
			eventDataDetail.addProperty("actOutM",   	String.valueOf(jsonData.get("ACT_OUT_M")));
			eventDataDetail.addProperty("orderNum",   	String.valueOf(jsonData.get("ORDER_NUM")));
			infoArray1.add(eventDataDetail);
			//logger.debug("eventDataDetail" + eventDataDetail);


			progCode = (String) jsonData.get("PROG_WORK_CODE");
			equCode  = (String) jsonData.get("EQU_CODE");
			eventId  = (String) jsonData.get("EVENTS_ROWS_ID");
		}


		String fromDate = (String) param.get("FROM_DATE");
		fromDate = fromDate.substring(0, 4)+ "-" + fromDate.substring(4, 6) + "-" +  fromDate.substring(6, 8);
		if(dataList.size() > 0){
			lunchStartTime  	   = (String) dataList.get(0).get("LUNCH_START_TIME");
			lunchEndTime    	   = (String) dataList.get(0).get("LUNCH_END_TIME");
			morningBreakStartTime  = (String) dataList.get(0).get("MORNING_REST_START_TIME");
			morningBreakEndTime	   = (String) dataList.get(0).get("MORNING_REST_END_TIME");
			afterBreakStartTime	   = (String) dataList.get(0).get("AFTERNOON_REST_START_TIME");
			afterBreakEndTime  	   = (String) dataList.get(0).get("AFTERNOON_REST_END_TIME");
		}

		JsonObject lunchDataDetail        = new JsonObject();
		JsonObject morningBreakDataDetail = new JsonObject();
		JsonObject afterDataDetail   	  = new JsonObject();

		lunchDataDetail.addProperty("id", 1);
		lunchDataDetail.addProperty("name", "lunch");
		lunchDataDetail.addProperty("recurrenceRule", "FREQ=DAILY");
		lunchDataDetail.addProperty("startDate", fromDate + " " + lunchStartTime);
		lunchDataDetail.addProperty("endDate"  , fromDate + " " + lunchEndTime);
		infoArray3.add(lunchDataDetail);

		morningBreakDataDetail.addProperty("id", 2);
		morningBreakDataDetail.addProperty("name", "morning break");
		morningBreakDataDetail.addProperty("recurrenceRule", "FREQ=DAILY");
		morningBreakDataDetail.addProperty("startDate", fromDate + " " + morningBreakStartTime);
		morningBreakDataDetail.addProperty("endDate"  , fromDate + " " + morningBreakEndTime);
		infoArray3.add(morningBreakDataDetail);

		afterDataDetail.addProperty("id", 3);
		afterDataDetail.addProperty("name", "after break");
		afterDataDetail.addProperty("recurrenceRule", "FREQ=DAILY");
		afterDataDetail.addProperty("startDate", fromDate + " " + afterBreakStartTime);
		afterDataDetail.addProperty("endDate"  , fromDate + " " + afterBreakEndTime);
		infoArray3.add(afterDataDetail);

		eventData.add("rows"      , infoArray1);
		resourceData.add("rows"   , infoArray2);
		timeRangesData.add("rows" , infoArray3);


		 jsonobject.add("events"   , eventData);
		 jsonobject.add("resources", resourceData);
		 jsonobject.add("timeRanges", timeRangesData);


		  //dependency 관련 로직 추가 21.08.23
		  JsonObject dependencyData 		= new JsonObject();

		  List<Map>  dependencytList 	= new ArrayList<Map>();//aps input data map
		  JsonArray  infoArray4      		= new JsonArray();

		  dependencytList = super.commonDao.list("ppl301ukrvServiceImpl.selectDependencyList", param);
		  if(dependencytList.size() > 0){
				 for(Map dependencyParam:  dependencytList) {
					 JsonObject dependencyDetail   = new JsonObject();
					 dependencyDetail.addProperty("id", 	 String.valueOf(dependencyParam.get("DEPENDENCY_ID")));
					 dependencyDetail.addProperty("from",    String.valueOf(dependencyParam.get("FR_ID")));
					 dependencyDetail.addProperty("to", 	 String.valueOf(dependencyParam.get("TO_ID")));
					 infoArray4.add(dependencyDetail);
				 }
		  }
		  dependencyData.add("rows" , infoArray4);
		  jsonobject.add("dependencies", dependencyData);

		 Gson gson = new GsonBuilder().setPrettyPrinting().create();
		 //Gson gson = new GsonBuilder().disableHtmlEscaping().create();
	     String json = gson.toJson(jsonobject);
	     System.out.println(json);
		 return json;
	}

	/**
	 * APS결과 그리드에 보여줄 데이터
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sof")
	public List<Map<String, Object>>   selectDetailList(Map param) throws Exception {
		List<Map<String, Object>> dataList = new ArrayList<Map<String, Object>>();
		if(param.get("DUMMY_YN").equals("Y")){
			dataList = super.commonDao.list("ppl301ukrvServiceImpl.selectDummyDetailList", param);
		}else{
			dataList = super.commonDao.list("ppl301ukrvServiceImpl.selectDetailList", param);
		}
		return  dataList;
	}

	/**
	 * 간트챠트 APS 입력 데이터 생성
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sof")
	public String insertApsInputData(Map param, LoginVO loginVO, String path) throws Exception {
		List<Map> apsInputRawDataList = new ArrayList<Map>();//aps input Raw data map
		List<Map> apsInputList 		  = new ArrayList<Map>();//aps input data map

		param.put("COMP_CODE", loginVO.getCompCode());
		apsInputRawDataList = super.commonDao.list("ppl301ukrvServiceImpl.selectApsInputRawDataList1", param);

		//1.로그테이블에서 사용할 Key 생성
		String keyValue = getLogKey();
		String retVal   = "";
		if(apsInputRawDataList.size() > 0){
			 for(Map apsParam:  apsInputRawDataList) {
				 apsParam.put("MRP_CONTROL_NUM", keyValue);
				 apsParam.put("DIV_CODE", (String) param.get("DIV_CODE"));
				 apsParam.put("COMP_CODE", loginVO.getCompCode());
				 super.commonDao.insert("ppl301ukrvServiceImpl.insertEstiListPlan", apsParam);
			 }
			   Map<String, Object> spParam = new HashMap<String, Object>();

				spParam.put("KeyValue"  , keyValue);
				spParam.put("PadStockYn", "N");
				spParam.put("LangCode"  , "ko");

				super.commonDao.queryForObject("ppl301ukrvServiceImpl.spProdtPlan", spParam);

				String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));

				if(!ObjUtils.isEmpty(errorDesc)){
//					String[] messsage = errorDesc.split(";");

				    throw new  UniDirectValidateException(errorDesc);
//				    throw new  UniDirectValidateException(this.getMessage(errorDesc, loginVO));
				} else {
					
					
					
					System.out.println("Python Call");
					String   fullPath = path + "\\APS_21210906_F1.py";
					String   apsKey	  = (String) super.commonDao.select("ppl301ukrvServiceImpl.selecApsKey", spParam);
			        String[] command  = new String[14];
//			        command[0]        = "C://Users/Administrator/AppData/Local/Programs/Python/Python38/python.exe";
			        command[0]        = "C://Users/chaeseongmin/AppData/Local/Programs/Python/Python38/python.exe";
			        //command[0]        = "python";
//			        command[1] 	      = "D://OmegaPlus/Apps/omegaplus/WebContent/resources/js/python_files/codi_crp_aps.py";
			        command[1] 		  = fullPath;							//파이썬 실행을 위한 파일 경로 및 파일명
			        command[2] 		  = apsKey;   								//파이썬 aps 로그키, 나중에 삭제 등 여러 작업을 할 때 관련된 부분 전체 삭제를 위한 키 값
			        command[3] 		  = loginVO.getCompCode(); 					//법인코드
			        command[4] 		  = (String) param.get("DIV_CODE");			//사업장코드
			        command[5]		  = null;									//작업장코드
			        command[6]		  = null;									//공정코드
			        command[7] 		  = keyValue;								//T_PPL100t 로그키
			        
//			        기본 시작일자 base_start_day, 다음날로 이월이 가능한 최소 근무 근무시간 remaining_time  파라미터 제거 20210902
//			        command[8] 		  = (String) param.get("BASE_START_DATE");	//기본 시작 일자
			        command[8]		  = null;									//split_type 제조 는 'B'  , 포장은 'C' 가 될 수 있음
			        command[9] 	  	  = "P";									//validate 추후 사용 예정 ( 'Y','N','P' ) - 일단은 'Y' 나 'P' 만 사용
//			        command[11] 	  = (String) param.get("REMAINING_TIME");	//다음날로 이월이 가능한 최소 근무 근무시간
			        command[10] 	  = "N";									//debug YN


			        command[11] 	  = null;									//수주번호
				    command[12] 	  = null;									//수주순번

			        command[13] 		  = (String) param.get("FROM_DATE");	//기본 시작 일자
			        
			        apsInputList 	  = super.commonDao.list("ppl301ukrvServiceImpl.selectApsInputList", spParam);
			        
			        for(Map apsInputParam:  apsInputList) {
			        	
			        	 command[5] = (String) apsInputParam.get("WORK_SHOP_CODE");
			        	 command[6] = (String) apsInputParam.get("PROG_WORK_CODE");

					     command[11] 	  = ObjUtils.getSafeString(apsInputParam.get("ORDER_NUM"));
					     command[12] 	   = ObjUtils.getSafeString(apsInputParam.get("SEQ"));


			        	 if("WSH10".equals((String) apsInputParam.get("WORK_SHOP_CODE")) ||
			        		"WSK10".equals((String) apsInputParam.get("WORK_SHOP_CODE")) ||
			        		"WSH20".equals((String) apsInputParam.get("WORK_SHOP_CODE")) ||
			        		"WSK20".equals((String) apsInputParam.get("WORK_SHOP_CODE"))
			        			 ){
			        		 command[8] = "B" ;
			        	 }else{
			        		 command[8] = "C" ;
			        	 }

			        	 CommandLine commandLine = CommandLine.parse(command[0]);
			             for (int i = 1, n = command.length; i < n; i++) {
			                 commandLine.addArgument(command[i]);
			                 //System.out.println("command" + i + ": " + command[i]);
			                 logger.debug("command" + i + ": " + command[i]);
			             }

			             ByteArrayOutputStream outputStream  = new ByteArrayOutputStream();
			             PumpStreamHandler pumpStreamHandler = new PumpStreamHandler(outputStream);
			             DefaultExecutor executor 			 = new DefaultExecutor();
			             executor.setStreamHandler(pumpStreamHandler);
			             try{
			            	 int result = executor.execute(commandLine);
				            //System.out.println("result: " + result);
				             //System.out.println("output: " + outputStream.toString());
				             //logger.debug("result: " + result);
				             //logger.debug("output: " + outputStream.toString());
			             }catch(Exception e){
			            	 e.printStackTrace();
			            	 throw new  UniDirectValidateException("44;"+e.getMessage());
			             }
			             	//UPDATE T_PPL100T SET PRODT_START_TIME
		        		Map<String, Object> updatePSTparam = new HashMap<String, Object>();
	        		 	updatePSTparam.put("S_COMP_CODE", loginVO.getCompCode());
	     		 		updatePSTparam.put("DIV_CODE", param.get("DIV_CODE"));
	     		 		updatePSTparam.put("MRP_CONTROL_NUM", keyValue);
	 		 			updatePSTparam.put("APS_KEY", apsKey);
	 		 			updatePSTparam.put("ORDER_NUM", apsInputParam.get("ORDER_NUM"));
	 		 			updatePSTparam.put("SEQ", apsInputParam.get("SEQ"));
			        	super.commonDao.update("ppl301ukrvServiceImpl.updatePST", updatePSTparam);
			        		
			        }
			        
					retVal = apsKey;
					
					
					
				}
		}else{
			// throw new  UniDirectValidateException(this.getMessage("생성할 INPUT 데이터가 없습니다.", loginVO));
			 retVal = "no_input";

		}
		return retVal;
	}
	/**
	 * aps파라미터 저장
	 * @param paramList	리스트의  update 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sof")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {


		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");

		List<Map> dataList = new ArrayList<Map>();
		List<List<Map>> resultList = new ArrayList<List<Map>>();
		if(paramList != null)	{
			List<Map> updateList = null;
			for(Map param: paramList) {
				if(param.get("method").equals("updateDetail")) {
					updateList = (List<Map>)param.get("data");
				}
			}
			if(updateList != null) this.updateDetail(updateList, user);
		}

		paramList.add(0, paramMaster);

		return  paramList;
	}

	/**
	 * aps 설정 정보 업데이트
	 */
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "prodt" )
	public List<Map> updateDetail(List<Map> params, LoginVO user) throws Exception {
		try {
			for(Map param: params)	{

					super.commonDao.update("ppl301ukrvServiceImpl.updateApsParameterData", param);

			}
		}catch(Exception e){
			throw new UniDirectValidateException(this.getMessage("설정 저장중 오류가 발생했습니다.", user));
		}

		return params;
	}
	/**
	 * APS그리드 디테일 내역 저장
	 * @param paramList	리스트의  update 정보
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sof")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll2(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {


		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");

		List<Map> dataList = new ArrayList<Map>();
		String saveFlag = (String) dataMaster.get("SAVE_FLAG");
		String divCode = (String) dataMaster.get("DIV_CODE");
 		if(paramList != null)	{
			List<Map> updateList = null;
			for(Map param: paramList) {
				if(param.get("method").equals("updateList")) {
					updateList = (List<Map>)param.get("data");
				}
			}
			if(updateList != null) this.updateList(updateList, user, saveFlag, divCode);
		}

		paramList.add(0, paramMaster);

		return  paramList;
	}
	/**
	 * APS 디테일 내역 저장 / DUMMY데이터와 NORMAL데이터 업데이트 쿼리 따로 실행
	 */
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "prodt" )
	public List<Map> updateList(List<Map> params, LoginVO user, String saveFlag, String divCode) throws Exception {
		try {
			for(Map param: params)	{
				param.put("DIV_CODE", divCode);
				if(param.get("DUMMY_YN").equals("Y")){//DUMMY데이터인 경우
					super.commonDao.update("ppl301ukrvServiceImpl.updateApsDumyUpdate", param);
				}else if(saveFlag.equals("FIX")){
					super.commonDao.update("ppl301ukrvServiceImpl.updateApsFixData", param);
				}else{
					if((boolean) param.get("CONFIRM_YN")){
						super.commonDao.update("ppl301ukrvServiceImpl.updateApsConfirmData", param);
						Map<String, Object> map = new HashMap<String, Object>();
						map.put("S_COMP_CODE",user.getCompCode());
						map.put("S_USER_ID",user.getUserID());
						map.put("DIV_CODE",divCode);
						map.put("TABLE","PPL100T");
						map.put("TYPE","P");
						String sAutoNo = null;
						Map<String, Object> autoNumMap = (Map<String, Object>)super.commonDao.select("ppl301ukrvServiceImpl.selectAutoNum",map);

						map.put("CAL_TYPE","3");
						map.put("OPTION_DATE", param.get("PLAN_START_DATE"));
						Map<String, Object> calMap = (Map<String, Object>)super.commonDao.select("prodtCommonServiceImpl.getCalNo",map);
						param.put("WEEK_NUM", calMap.get("CAL_NO"));
						if(autoNumMap != null){
							sAutoNo = autoNumMap.get("AUTO_NUM")+"";
							param.put("WK_PLAN_NUM", sAutoNo);
							param.put("DIV_CODE",divCode);
							super.commonDao.insert("ppl301ukrvServiceImpl.insertPpl100tApsData", param);
							super.commonDao.update("ppl301ukrvServiceImpl.updateApsWkPlanNum", param);
						}
					}else{
						super.commonDao.update("ppl301ukrvServiceImpl.updateApsConfirmData", param);
						super.commonDao.delete("ppl301ukrvServiceImpl.deletePpl100tApsData", param);
					}

				}
			}
		}catch(Exception e){
			throw new UniDirectValidateException(this.getMessage("설정 저장중 오류가 발생했습니다.", user));
		}

		return params;
	}

	/**
	 *
	 * aps파라미터
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectApsParameter(Map param) throws Exception {
		return super.commonDao.list("ppl301ukrvServiceImpl.selectApsParameterList", param);
	}

	/**
	 *
	 * 수주정보 참조 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectEstiList(Map param) throws Exception {
		return super.commonDao.list("ppl301ukrvServiceImpl.selectEstiList", param);
	}
}
