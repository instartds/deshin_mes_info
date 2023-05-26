package foren.unilite.modules.z_jw;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

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
import foren.unilite.modules.prodt.pmp.Pmp160ukrvModel;


@Service("s_pmr100ukrv_jwService")
@SuppressWarnings({"rawtypes", "unchecked"})

public class S_pmr100ukrv_jwServiceImpl extends TlabAbstractServiceImpl {
		private final Logger logger = LoggerFactory.getLogger(this.getClass());	
	
		@ExtDirectMethod(group = "z_jw", value = ExtDirectMethodType.STORE_READ)		// 작업지시조회
		public List<Map<String, Object>> selectDetailList(Map param) throws Exception {
			return super.commonDao.list("s_pmr100ukrv_jwServiceImpl.selectDetailList", param);
		}
		// END OF 작업실적등록
		
		@ExtDirectMethod(group = "z_jw", value = ExtDirectMethodType.STORE_READ)		// 작업지시번호별등록 조회
		public List<Map<String, Object>> selectDetailList2(Map param) throws Exception {
			return super.commonDao.list("s_pmr100ukrv_jwServiceImpl.selectDetailList2", param);
		}
		// END OF 작업지시번호별등록 조회		
		@ExtDirectMethod(group = "z_jw", value = ExtDirectMethodType.STORE_READ)		// 공정별등록 조회1
		public List<Map<String, Object>> selectDetailList3(Map param) throws Exception {
			return super.commonDao.list("s_pmr100ukrv_jwServiceImpl.selectDetailList3", param);
		}
		// END OF 공정별등록 조회1
			
		@ExtDirectMethod(group = "z_jw", value = ExtDirectMethodType.STORE_READ)		// 공정별등록 조회2
		public List<Map<String, Object>> selectDetailList4(Map param) throws Exception {
			return super.commonDao.list("s_pmr100ukrv_jwServiceImpl.selectDetailList4", param);
		}
		// END OF 공정별등록2
		
		@ExtDirectMethod(group = "z_jw", value = ExtDirectMethodType.STORE_READ)		// 불량내역등록 조회
		public List<Map<String, Object>> selectDetailList5(Map param) throws Exception {
			return super.commonDao.list("s_pmr100ukrv_jwServiceImpl.selectDetailList5", param);
		}
		// END OF 불량내역등록
		
		@ExtDirectMethod(group = "z_jw", value = ExtDirectMethodType.STORE_READ)		// 특이사항등록 조회
		public List<Map<String, Object>> selectDetailList6(Map param) throws Exception {
			return super.commonDao.list("s_pmr100ukrv_jwServiceImpl.selectDetailList6", param);
		}
		
		@ExtDirectMethod(group = "z_jw", value = ExtDirectMethodType.STORE_READ)		// 특이사항등록 조회
		public List<Map<String, Object>> selectClipList(Map param) throws Exception {
			return super.commonDao.list("s_pmr100ukrv_jwServiceImpl.selectClipList", param);
		}
		
		@ExtDirectMethod(group = "z_jw", value = ExtDirectMethodType.STORE_READ)		// 특이사항등록 조회
		public List<Map<String, Object>> printList2(Map param) throws Exception {
			return super.commonDao.list("s_pmr100ukrv_jwServiceImpl.printList2", param);
		}
		// END OF 특이사항등록
		
		
		
		/**
		 *  detail2 저장(작지번호별)
		 * 
		 * @param param
		 * @return
		 * @throws Exception
		 */
		@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "z_jw")
		@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class}) 
		public List<Map> saveAll2(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
			logger.debug("[saveAll] paramDetail:" + paramList);
			  
			List<Map> dataList = new ArrayList<Map>();
			for(Map paramData: paramList) {
				dataList = (List<Map>) paramData.get("data");
				String oprFlag = "N";
				if(paramData.get("method").equals("insertDetail2")) oprFlag="N";
				if(paramData.get("method").equals("updateDetail2")) oprFlag="U";
				if(paramData.get("method").equals("deleteDetail2")) oprFlag="D";
			
				for(Map param:  dataList) {

					Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
					Map<String, Object> spParam = new HashMap<String, Object>();
					SimpleDateFormat dateFormat = new SimpleDateFormat ("yyyyMMdd");
					Date dateGet = new Date ();
					String dateGetString = dateFormat.format(dateGet);
					
					String prodtNum = (String) dataMaster.get("PRODT_NUM");
					spParam.put("COMP_CODE"		, user.getCompCode());			
					spParam.put("DIV_CODE"		, dataMaster.get("DIV_CODE"));
					spParam.put("TABLE_ID"		, "PMR110T");
					spParam.put("PREFIX"		, "P");
					spParam.put("WORK_SHOP_CODE", dataMaster.get("WORK_SHOP_CODE"));
					spParam.put("BASIS_DATE"	, dateGetString);
					spParam.put("AUTO_TYPE"		, "1");

					param.put("PRODT_TYPE"	, "2");  // (1: 공정별, 2: 작지별, 3: ......)
					param.put("STATUS"		, oprFlag);
					param.put("USER_ID"		, user.getUserID());										
					
					if(param.get("STATUS").equals("N")) {
						//생산실적번호 자동채번
						super.commonDao.queryForObject("s_pmr100ukrv_jwServiceImpl.spAutoNum", spParam);
						prodtNum = ObjUtils.getSafeString(spParam.get("KEY_NUMBER"));
						param.put("PRODT_NUM",  prodtNum);
						
						//LOT_NO 자동채번
						String newLotNo = (String) super.commonDao.select("s_pmr100ukrv_jwServiceImpl.fnGetLotNo", spParam);
						param.put("LOT_NO", newLotNo);

						super.commonDao.update("s_pmr100ukrv_jwServiceImpl.insertDetail2", param);
					
					} else if(param.get("STATUS").equals("N") && param.get("FLAG").equals("U")) {						
						super.commonDao.update("s_pmr100ukrv_jwServiceImpl.updateDetail2", param);
					} 
					
					if(param.get("STATUS").equals("D")) {
						super.commonDao.update("s_pmr100ukrv_jwServiceImpl.deleteDetail2", param);
					}

					param.put("COMP_CODE", user.getCompCode());
					param.put("DIV_CODE", param.get("DIV_CODE"));
					param.put("PRODT_NUM", param.get("PRODT_NUM"));
					param.put("WKORD_NUM", param.get("WKORD_NUM"));
					
					param.put("GOOD_WH_CODE", param.get("GOOD_WH_CODE"));
					param.put("GOOD_WH_CELL_CODE", param.get("GOOD_WH_CELL_CODE"));
					param.put("GOOD_PRSN", param.get("GOOD_PRSN"));
					param.put("GOOD_Q", ObjUtils.parseDouble(param.get("GOOD_PRODT_Q")));
					
					
					param.put("BAD_WH_CODE", param.get("BAD_WH_CODE"));
					param.put("BAD_WH_CELL_CODE", param.get("BAD_WH_CELL_CODE"));
					param.put("BAD_PRSN", param.get("BAD_PRSN"));
					param.put("BAD_Q", ObjUtils.parseDouble(param.get("BAD_PRODT_Q")));
					param.put("CONTROL_STATUS", param.get("CONTROL_STATUS"));	
					
					
					super.commonDao.update("s_pmr100ukrv_jwServiceImpl.spReceiving", param);
					String errorDesc = ObjUtils.getSafeString(param.get("ERROR_DESC"));
					if(!ObjUtils.isEmpty(errorDesc)) {
//						String[] messsage = errorDesc.split(";");
						throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
					} 
					
					dataMaster.put("CONTROL_STATUS", param.get("CONTROL_STATUS"));
				}
			}
			
			paramList.add(0, paramMaster);
			return  paramList;
		}
		
		@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_jw")		  // INSERT
		public Integer insertDetail2(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
			
			return 0;
		} 
		
		@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_jw")		  // UPDATE
		public Integer updateDetail2(List<Map> paramList, LoginVO user) throws Exception {
			
			return 0;
		} 
		
		@ExtDirectMethod(group = "base", needsModificatinAuth = true)						// DELETE
		public Integer deleteDetail2(List<Map> paramList,  LoginVO user) throws Exception {
			
			return 0;
		}
		
		
		
		/**
		 *  detail3 저장(공정별)
		 * 
		 * @param param
		 * @return
		 * @throws Exception
		 */
		@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "z_jw")
		@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class}) 
		public List<Map> saveAll3(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
			logger.debug("[saveAll] paramDetail:" + paramList);
			  
			List<Map> dataList = new ArrayList<Map>();
			for(Map paramData: paramList) {
				dataList = (List<Map>) paramData.get("data");
				String oprFlag = "N";
				if(paramData.get("method").equals("insertDetail3")) oprFlag="N";
				if(paramData.get("method").equals("updateDetail3")) oprFlag="N";
				if(paramData.get("method").equals("deleteDetail3")) oprFlag="D";
			
				for(Map param:  dataList) {
					Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
					Map<String, Object> spParam = new HashMap<String, Object>();
					SimpleDateFormat dateFormat = new SimpleDateFormat ("yyyyMMdd");
					Date dateGet = new Date ();
					String dateGetString = dateFormat.format(dateGet);
					
					String prodtNum	= (String) dataMaster.get("PRODT_NUM");
					spParam.put("COMP_CODE"		, user.getCompCode());			
					spParam.put("DIV_CODE"		, dataMaster.get("DIV_CODE"));
					spParam.put("TABLE_ID"		, "PMR100T");
					spParam.put("PREFIX"		, "P");
					spParam.put("WORK_SHOP_CODE", dataMaster.get("WORK_SHOP_CODE"));
//					spParam.put("BASIS_DATE"	, dateGetString);
					spParam.put("AUTO_TYPE"		, "1");

					param.put("PRODT_TYPE",  "1");		// (1: 공정별, 2: 작지별, 3: ......)
					param.put("STATUS",	 oprFlag);
					param.put("USER_ID",	user.getUserID());					

					if(param.get("STATUS").equals("N")) {
						int arrayCount = (int) param.get("ARRAY_CNT");
						int passQ	= (int) param.get("PASS_Q");
						int gWorkQ	= (int) param.get("GOOD_WORK_Q");
						int bWorkQ	= (int) param.get("BAD_WORK_Q");
						if(arrayCount == 0/* || !dataMaster.get("WORK_SHOP_CODE").equals("WC30")*/) {// 20201229 배열문제로 저장안되는 문제 수정.
							arrayCount = 1;
						}
						String[] tempc01= new String[arrayCount];
						
						//작업장이 슬리팅일 경우 배열수 로직 수행
//						if(dataMaster.get("WORK_SHOP_CODE").equals("WC30")) {
						//작업장이 슬리팅일 경우 배열수 로직 수행
							
							//배열수(ARRAY_CNT)에 따른 수량 계산
							//나눈 후, 몫  계산
							int passQ_share	= passQ  / arrayCount;
							int gWorkQ_share= gWorkQ / arrayCount;
							int bWorkQ_share= bWorkQ / arrayCount;
							//나눈 후, 나머지  계산
							int passQ_rest	= passQ  % arrayCount;
							int gWorkQ_rest	= gWorkQ % arrayCount;
							int bWorkQ_rest	= bWorkQ % arrayCount;
						
//						//작업장이 슬리팅이 아닐 경우 그대로 진행
//						} else {
//							arrayCount = 1;
//							//나눈 후, 몫  계산
//							int passQ_share	= passQ;
//							int gWorkQ_share= gWorkQ;
//							int bWorkQ_share= bWorkQ;
//							//나눈 후, 나머지  계산
//							int passQ_rest	= 0;
//							int gWorkQ_rest	= 0;
//							int bWorkQ_rest	= 0;
//						}
						
						for(int i=0 ; i < arrayCount ; i++) {
							//생산실적번호 자동채번
							spParam.put("BASIS_DATE"	, dateGetString);
							super.commonDao.queryForObject("s_pmr100ukrv_jwServiceImpl.spAutoNum", spParam);
							prodtNum	= ObjUtils.getSafeString(spParam.get("KEY_NUMBER"));
							tempc01[i]	= prodtNum;  
							param.put("PRODT_NUM"	, prodtNum);
							param.put("TEMPC_01"	, tempc01[i]);
							
							//생산량 계산
							if(i < gWorkQ_rest) {
//								param.put("PASS_Q_SAVE"			, passQ_share + 1);
								param.put("PASS_Q_SAVE"			, gWorkQ_share + 1);
							} else {
//								param.put("PASS_Q_SAVE"			, passQ_share);
								param.put("PASS_Q_SAVE"			, gWorkQ_share);
							}
							//양품수량 계산
							if(i < gWorkQ_rest) {
								param.put("GOOD_WORK_Q_SAVE"	, gWorkQ_share + 1);
							} else {
								param.put("GOOD_WORK_Q_SAVE"	, gWorkQ_share);
							}
							//불량품수량 계산
							param.put("BAD_WORK_Q_SAVE"			, 0);
//							if(i < bWorkQ_rest) {
//								param.put("BAD_WORK_Q_SAVE"		, bWorkQ_share + 1);
//							} else {
//								param.put("BAD_WORK_Q_SAVE"		, bWorkQ_share);
//							}
							
							if(ObjUtils.parseDouble(param.get("GOOD_WORK_Q_SAVE")) != 0) {
								//LOT_NO 자동채번
								if(param.get("LINE_END_YN").equals("Y")) {
									spParam.put("BASIS_DATE"	, param.get("PRODT_DATE"));
									String newLotNo = (String) super.commonDao.select("s_pmr100ukrv_jwServiceImpl.fnGetLotNo", spParam);
									param.put("LOT_NO", newLotNo);
								}
								super.commonDao.update("s_pmr100ukrv_jwServiceImpl.insertDetail3", param);
								
								param.put("COMP_CODE"		, user.getCompCode());
								param.put("DIV_CODE"		, param.get("DIV_CODE"));
								param.put("PRODT_NUM"		, param.get("PRODT_NUM"));
								param.put("WKORD_NUM"		, param.get("WKORD_NUM"));
								param.put("CONTROL_STATUS"	, param.get("CONTROL_STATUS"));
	//							param.put("STATUS", param.get("FLAG"));
								param.put("USER_ID"			, user.getUserID());
			/*					if(param.get("LINE_END_YN").equals("Y")) {	
									param.put("GOOD_Q", param.get("GOOD_WORK_Q"));
									param.put("GOOD_WH_CODE", param.get("GOOD_WH_CODE"));
									param.put("GOOD_PRSN", param.get("GOOD_PRSN"));
									param.put("GOOD_WH_CELL_CODE", param.get("GOOD_WH_CELL_CODE"));
									param.put("BAD_Q", param.get("BAD_WORK_Q"));
									param.put("BAD_WH_CODE", param.get("BAD_WH_CODE"));
									param.put("BAD_PRSN", param.get("BAD_PRSN"));
									param.put("BAD_WH_CELL_CODE", param.get("BAD_WH_CELL_CODE"));
								} else {
									param.put("GOOD_WH_CODE", "");
									param.put("GOOD_WH_CELL_CODE", "");
									param.put("GOOD_PRSN", "");
									param.put("GOOD_Q", zero);
									param.put("BAD_WH_CODE", "");
									param.put("BAD_WH_CELL_CODE", "");
									param.put("BAD_PRSN", "");
									param.put("BAD_Q", zero);
								}*/
								param.put("GOOD_Q"	, ObjUtils.parseDouble(param.get("GOOD_WORK_Q_SAVE")));
								param.put("BAD_Q"	, ObjUtils.parseDouble(param.get("BAD_WORK_Q_SAVE")));
								
								super.commonDao.update("s_pmr100ukrv_jwServiceImpl.spReceiving", param);
								String errorDesc = ObjUtils.getSafeString(param.get("ERROR_DESC"));
								if(!ObjUtils.isEmpty(errorDesc)) {
									throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
								}
							}
							//불량수량 따로 처리
							if(i == arrayCount - 1 && bWorkQ > 0) {
								//생산실적번호 자동채번
								spParam.put("BASIS_DATE"	, dateGetString);
								super.commonDao.queryForObject("s_pmr100ukrv_jwServiceImpl.spAutoNum", spParam);
								prodtNum	= ObjUtils.getSafeString(spParam.get("KEY_NUMBER"));
								param.put("PRODT_NUM"	, prodtNum);

								spParam.put("BASIS_DATE"	, param.get("PRODT_DATE"));
								String newLotNo = (String) super.commonDao.select("s_pmr100ukrv_jwServiceImpl.fnGetLotNo", spParam);
								param.put("LOT_NO", newLotNo);
								
								param.put("PASS_Q_SAVE"			, bWorkQ);
								param.put("GOOD_WORK_Q_SAVE"	, 0);
								param.put("BAD_WORK_Q_SAVE"		, bWorkQ);
								super.commonDao.update("s_pmr100ukrv_jwServiceImpl.insertDetail3", param);
								
								param.put("COMP_CODE"		, user.getCompCode());
								param.put("DIV_CODE"		, param.get("DIV_CODE"));
								param.put("PRODT_NUM"		, param.get("PRODT_NUM"));
								param.put("WKORD_NUM"		, param.get("WKORD_NUM"));
								param.put("CONTROL_STATUS"	, param.get("CONTROL_STATUS"));
								param.put("USER_ID"			, user.getUserID());
								param.put("GOOD_Q"	, ObjUtils.parseDouble(param.get("GOOD_WORK_Q_SAVE")));
								param.put("BAD_Q"	, ObjUtils.parseDouble(param.get("BAD_WORK_Q_SAVE")));
								
								super.commonDao.update("s_pmr100ukrv_jwServiceImpl.spReceiving", param);
								String errorDesc1 = ObjUtils.getSafeString(param.get("ERROR_DESC"));
								if(!ObjUtils.isEmpty(errorDesc1)) {
									throw new  UniDirectValidateException(this.getMessage(errorDesc1, user));
								}
							}
						}
					
					} else if(param.get("STATUS").equals("N") && param.get("FLAG").equals("U")) {
						super.commonDao.update("s_pmr100ukrv_jwServiceImpl.updateDetail3", param);
						
						param.put("COMP_CODE", user.getCompCode());
						param.put("DIV_CODE", param.get("DIV_CODE"));
						param.put("PRODT_NUM", param.get("PRODT_NUM"));
						param.put("WKORD_NUM", param.get("WKORD_NUM"));
						param.put("CONTROL_STATUS", param.get("CONTROL_STATUS"));
//						param.put("STATUS", param.get("FLAG"));
						param.put("USER_ID", user.getUserID());
/*						if(param.get("LINE_END_YN").equals("Y")) {	
							param.put("GOOD_Q", param.get("GOOD_WORK_Q"));
							param.put("GOOD_WH_CODE", param.get("GOOD_WH_CODE"));
							param.put("GOOD_PRSN", param.get("GOOD_PRSN"));
							param.put("GOOD_WH_CELL_CODE", param.get("GOOD_WH_CELL_CODE"));
							param.put("BAD_Q", param.get("BAD_WORK_Q"));
							param.put("BAD_WH_CODE", param.get("BAD_WH_CODE"));
							param.put("BAD_PRSN", param.get("BAD_PRSN"));
							param.put("BAD_WH_CELL_CODE", param.get("BAD_WH_CELL_CODE"));
						} else {
							param.put("GOOD_WH_CODE", "");
							param.put("GOOD_WH_CELL_CODE", "");
							param.put("GOOD_PRSN", "");
							param.put("GOOD_Q", zero);
							param.put("BAD_WH_CODE", "");
							param.put("BAD_WH_CELL_CODE", "");
							param.put("BAD_PRSN", "");
							param.put("BAD_Q", zero);
						}*/
						param.put("GOOD_Q", ObjUtils.parseDouble(param.get("GOOD_WORK_Q")));
						param.put("BAD_Q", ObjUtils.parseDouble(param.get("BAD_WORK_Q")));
						
						super.commonDao.update("s_pmr100ukrv_jwServiceImpl.spReceiving", param);
						String errorDesc = ObjUtils.getSafeString(param.get("ERROR_DESC"));
						if(!ObjUtils.isEmpty(errorDesc)) {
//							String[] messsage = errorDesc.split(";");
							throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
						} 
					} 
					dataMaster.put("CONTROL_STATUS"	, param.get("CONTROL_STATUS"));
					dataMaster.put("PRODT_NUM"		, prodtNum);
				}
			}
			
			paramList.add(0, paramMaster);
			return  paramList;
		}
		
		@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_jw")		  // INSERT
		public Integer insertDetail3(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
			
			return 0;
		} 
		
		@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_jw")		  // UPDATE
		public Integer updateDetail3(List<Map> paramList, LoginVO user) throws Exception {
			
			return 0;
		} 
		
		@ExtDirectMethod(group = "base", needsModificatinAuth = true)						// DELETE
		public Integer deleteDetail3(List<Map> paramList,  LoginVO user) throws Exception {
			
			return 0;
		}
	
		

		@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
		@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class}) 
		public List<Map> saveAll4(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
			logger.debug("[saveAll] paramDetail:" + paramList);
			Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
			
			
			List<Map> dataList = new ArrayList<Map>();
			for(Map paramData: paramList) {	
				dataList = (List<Map>) paramData.get("data");
				String oprFlag = "N";
				if(paramData.get("method").equals("insertDetail4")) oprFlag="N";
				if(paramData.get("method").equals("updateDetail4")) oprFlag="U";
				if(paramData.get("method").equals("deleteDetail4")) oprFlag="D";
		  
				for(Map param:  dataList) {
					param.put("USER_ID", user.getUserID());
					if(("Y".equals(dataMaster.get("MOLDPUNCHQ_YN")) || "y".equals(dataMaster.get("MOLDPUNCHQ_YN")))
						&& ("WC10".equals(dataMaster.get("WORK_SHOP_CODE")) || "WC20".equals(dataMaster.get("WORK_SHOP_CODE")))) {
						//이력정보 수정
						param.put("ARRAY_CNT", ObjUtils.parseDouble(param.get("GOOD_WORK_Q")) + ObjUtils.parseDouble(param.get("BAD_WORK_Q")));
						super.commonDao.update("s_pmr100ukrv_jwServiceImpl.SP_EQUIT_EQU201UKRV_JW", param);
						String errorDesc1 = ObjUtils.getSafeString(param.get("ERROR_DESC"));
						if(!ObjUtils.isEmpty(errorDesc1)) {
							String[] messsage1 = errorDesc1.split(";");
							throw new  UniDirectValidateException(this.getMessage(messsage1[0], user));
						} 
					}
					
					super.commonDao.update("s_pmr100ukrv_jwServiceImpl.deleteDetail3", param);

					param.put("COMP_CODE"		, user.getCompCode());
					param.put("DIV_CODE"		, param.get("DIV_CODE"));
					param.put("PRODT_NUM"		, param.get("PRODT_NUM"));
					param.put("WKORD_NUM"		, param.get("WKORD_NUM"));
					param.put("CONTROL_STATUS"	, param.get("CONTROL_STATUS"));
					param.put("PRODT_TYPE"		, "1");
					param.put("STATUS"			, oprFlag);
					param.put("GOOD_Q"			, ObjUtils.parseDouble(param.get("GOOD_WORK_Q")));
					param.put("BAD_Q"			, ObjUtils.parseDouble(param.get("BAD_WORK_Q")));
					
					super.commonDao.update("s_pmr100ukrv_jwServiceImpl.spReceiving", param);
					String errorDesc2 = ObjUtils.getSafeString(param.get("ERROR_DESC"));
					if(!ObjUtils.isEmpty(errorDesc2)) {
						String[] messsage2 = errorDesc2.split(";");
						throw new  UniDirectValidateException(this.getMessage(messsage2[0], user));
					} 
					dataMaster.put("CONTROL_STATUS", param.get("CONTROL_STATUS"));
				}
			}

			paramList.add(0, paramMaster);
			return  paramList;
	  }
	  
		@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")		  // INSERT
		public Integer insertDetail4(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
			  
			  return 0;
		} 
	  
		@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")		  // UPDATE
		public Integer updateDetail4(List<Map> paramList, LoginVO user) throws Exception {
			  
			  return 0;
		} 
  
		@ExtDirectMethod(group = "base", needsModificatinAuth = true)						// DELETE
		public Integer deleteDetail4(List<Map> paramList,  LoginVO user) throws Exception {
			  
			return 0;
		}

 

	  /**
		*  detail5 저장 (불량)
		* 
		* @param param
		* @return
		* @throws Exception
		*/	  
	  @ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "z_jw")
	  @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class}) 
	  public List<Map> saveAll5(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
		  
		  if(paramList != null)  {
				 List<Map> insertList = null;
				 List<Map> updateList = null;
				 List<Map> deleteList = null;
				 for(Map dataListMap: paramList) {
					 if(dataListMap.get("method").equals("deleteDetail5")) {
						 deleteList = (List<Map>)dataListMap.get("data");
					 }else if(dataListMap.get("method").equals("insertDetail5")) {
						 insertList = (List<Map>)dataListMap.get("data");
					 } else if(dataListMap.get("method").equals("updateDetail5")) {
						 updateList = (List<Map>)dataListMap.get("data");
					 }
				 }
				 if(deleteList != null) this.deleteDetail5(deleteList, user);
				 if(insertList != null) this.insertDetail5(insertList, user);
				 if(updateList != null) this.updateDetail5(updateList, user);
			 }
			 paramList.add(0, paramMaster);
				 
			 return  paramList;
	 }
	  
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_jw")	 // INSERT
	public Integer  insertDetail5(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param : paramList ) {
			super.commonDao.update("s_pmr100ukrv_jwServiceImpl.insertDetail5", param);
		}
		return 0;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_jw")	  // UPDATE
	public Integer updateDetail5(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param :paramList ) {
//			super.commonDao.update("s_pmr100ukrv_jwServiceImpl.updateDetail5", param);
			super.commonDao.update("s_pmr100ukrv_jwServiceImpl.deleteDetail5", param);
			super.commonDao.update("s_pmr100ukrv_jwServiceImpl.insertDetail5", param);
		}
		return 0;
	}

	@ExtDirectMethod(group = "base", needsModificatinAuth = true)		// DELETE
	public Integer deleteDetail5(List<Map> paramList,  LoginVO user) throws Exception {
		for(Map param :paramList ) {	
			super.commonDao.update("s_pmr100ukrv_jwServiceImpl.deleteDetail5", param);
		}
		return 0;
	} 



	/**
	*  detail6 저장 (특이)
	* 
	* @param param
	* @return
	* @throws Exception
	*/
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "z_jw")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class}) 
	public List<Map> saveAll6(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
		if(paramList != null)  {
			 List<Map> insertList = null;
			 List<Map> updateList = null;
			 List<Map> deleteList = null;
			 for(Map dataListMap: paramList) {
				 if(dataListMap.get("method").equals("deleteDetail6")) {
					 deleteList = (List<Map>)dataListMap.get("data");
				 }else if(dataListMap.get("method").equals("insertDetail6")) {
					 insertList = (List<Map>)dataListMap.get("data");
				 } else if(dataListMap.get("method").equals("updateDetail6")) {
					 updateList = (List<Map>)dataListMap.get("data");	
				 } 
			 }			
			 if(deleteList != null) this.deleteDetail6(deleteList, user);
			 if(insertList != null) this.insertDetail6(insertList, user);
			 if(updateList != null) this.updateDetail6(updateList, user);
		 }
		 paramList.add(0, paramMaster);

		 return  paramList;
	 }
	  
	  @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_jw")	 // INSERT
	  public Integer  insertDetail6(List<Map> paramList, LoginVO user) throws Exception {
		  for(Map param : paramList ) {			
			  super.commonDao.update("s_pmr100ukrv_jwServiceImpl.insertDetail6", param);
		  } 
		  return 0;
	  }	
		 
	  @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_jw")	  // UPDATE
	  public Integer updateDetail6(List<Map> paramList, LoginVO user) throws Exception {
		  for(Map param :paramList ) {	
			  super.commonDao.update("s_pmr100ukrv_jwServiceImpl.updateDetail6", param);
		  }
		  return 0;
	  } 
		 
	  @ExtDirectMethod(group = "z_jw", needsModificatinAuth = true)		// DELETE
	  public Integer deleteDetail6(List<Map> paramList,  LoginVO user) throws Exception {
		  for(Map param :paramList ) {	
			  super.commonDao.update("s_pmr100ukrv_jwServiceImpl.deleteDetail6", param);
		  }
		  return 0;
	  }
	  
	  
	  
	  
	  
	  
  	
  	@ExtDirectMethod(group = "z_jw", value = ExtDirectMethodType.STORE_READ)		// 목형정보 조회
  	public List<Map<String, Object>> selectWoodenInfo (Map param) throws Exception {
  		return super.commonDao.list("s_pmr100ukrv_jwServiceImpl.selectWoodenInfo", param);
  	}
  	
  	
	/**
	 *  Wooden Infomation 저장 (목형정보 저장)
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */  
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "z_jw")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class}) 
	public List<Map> saveWoodenInfoAll (List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		
		if(paramList != null)  {
				List<Map> insertList = null;
				List<Map> updateList = null;
				List<Map> deleteList = null;
				for(Map dataListMap: paramList) {
					if(dataListMap.get("method").equals("deleteWoodenInfoDetail")) {
						deleteList = (List<Map>)dataListMap.get("data");
					}else if(dataListMap.get("method").equals("insertWoodenInfoDetail")) {
						insertList = (List<Map>)dataListMap.get("data");
					} else if(dataListMap.get("method").equals("updateWoodenInfoDetail")) {
						updateList = (List<Map>)dataListMap.get("data");	
					} 
				}			
				if(deleteList != null) this.deleteWoodenInfoDetail(deleteList, user);
				if(insertList != null) this.insertWoodenInfoDetail(insertList, user);
				if(updateList != null) this.updateWoodenInfoDetail(updateList, dataMaster, user);
			}
			paramList.add(0, paramMaster);
				
			return  paramList;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_jw")	 // INSERT
	public Integer  insertWoodenInfoDetail(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param : paramList ) {			
			super.commonDao.update("s_pmr100ukrv_jwServiceImpl.insertWoodenInfoDetail", param);
		} 
		return 0;
	}	
		
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_jw")	  // UPDATE
	public Integer updateWoodenInfoDetail (List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		try {
			for(Map param :paramList ) {
				super.commonDao.update("s_pmr100ukrv_jwServiceImpl.updateWoodenInfoDetail", param);
				
				//이력정보 생성
				param.put("PRODT_NUM"		, paramMaster.get("PRODT_NUM"));
				param.put("WKORD_NUM"		, paramMaster.get("WKORD_NUM"));
				param.put("PRODT_DATE"		, paramMaster.get("PRODT_DATE"));
				param.put("PRODT_QTY"		, paramMaster.get("PRODT_QTY"));
				param.put("PRESS_CNT"		, paramMaster.get("PRESS_CNT"));
				param.put("WORK_SHOP_CODE"	, paramMaster.get("WORK_SHOP_CODE"));
				super.commonDao.update("s_pmr100ukrv_jwServiceImpl.insertWoodenInfoLogDetail", param);
			}
			
		} catch (Exception e) {
			throw new UniDirectValidateException(this.getMessage("814", user));
		}
		return 0;
	} 
		
	@ExtDirectMethod(group = "z_jw", needsModificatinAuth = true)		// DELETE
	public Integer deleteWoodenInfoDetail(List<Map> paramList,  LoginVO user) throws Exception {
		try {
			for(Map param :paramList ) {

				super.commonDao.update("s_pmr100ukrv_jwServiceImpl.deleteWoodenInfoDetail", param);
			}
			
		} catch (Exception e) {
			throw new UniDirectValidateException(this.getMessage("547", user));
		}
		return 0;
	}

}
