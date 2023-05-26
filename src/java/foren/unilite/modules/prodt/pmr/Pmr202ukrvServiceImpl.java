package foren.unilite.modules.prodt.pmr;

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


@Service("pmr202ukrvService")
@SuppressWarnings({"rawtypes", "unchecked"})
public class Pmr202ukrvServiceImpl extends TlabAbstractServiceImpl {
		private final Logger logger = LoggerFactory.getLogger(this.getClass());

		@ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_READ)		//조회
		public List<Map<String, Object>> selectDetailList(Map param) throws Exception {
			//Map<String, Object> dataMaster = (Map<String, Object>) param.get("data");
			String registerYn = (String) param.get("REGISTER_YN") ;
			if(registerYn.equals("N")){//미등록시
				return super.commonDao.list("pmr202ukrvServiceImpl.selectDetailList", param);
			}else{
				return super.commonDao.list("pmr202ukrvServiceImpl.selectDetailList2", param);
			}
			//return super.commonDao.list("pmr202ukrvServiceImpl.selectDetailList", param);
		}



		/** 저장 로직
		 *
		 * @param param
		 * @return
		 * @throws Exception
		 */
		@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "prodt")
		public List<Map> saveAll(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
			Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
			String inoutNum = "";

			if(paramList != null) {
				List<Map> allData		= null;
				List<Map> deleteDetail	= null;

				for(Map dataListMap: paramList) {
					if(dataListMap.get("method").equals("deleteDetail")) {
						deleteDetail = (List<Map>)dataListMap.get("data");
					} else {
						allData = (List<Map>)dataListMap.get("data");
						for(Map param: allData) {
							if(ObjUtils.isEmpty(param.get("PRODT_INOUT_NUM")) && inoutNum == "") {
								Map<String, Object> spParam	= new HashMap<String, Object>();

								spParam.put("COMP_CODE"		, user.getCompCode());
								spParam.put("DIV_CODE"		, param.get("DIV_CODE"));
								spParam.put("TABLE_ID"		, "BTR100T");
								spParam.put("PREFIX"		, "P");
								spParam.put("BASIS_DATE"	, dataMaster.get("INOUT_DATE"));
								spParam.put("AUTO_TYPE"		, "1");
								//수불번호 신규채번
								super.commonDao.queryForObject("s_pmr100ukrv_ypServiceImpl.spAutoNum", spParam);
								inoutNum = ObjUtils.getSafeString(spParam.get("KEY_NUMBER"));
							}
						}
					}
				}
				if(deleteDetail != null) this.deleteDetail(deleteDetail, dataMaster, user);
				if(allData != null) {
					int inoutSeq = 1;
					for(Map param: allData) {
						if(ObjUtils.isEmpty(param.get("PRODT_INOUT_NUM"))) {
							param.put("PRODT_INOUT_NUM"	, inoutNum);
							param.put("PRODT_INOUT_SEQ"	, ObjUtils.getSafeString(inoutSeq));
							param.put("INOUT_DATE"		, dataMaster.get("INOUT_DATE"));
							param.put("WORK_SHOP_CODE"	, dataMaster.get("WORK_SHOP_CODE"));

							//btr100t에서 조회한 경우에는 basis_num에 inout_num을 입력하여 조회할 때 조건으로 사용
							if(param.get("QUERY_FLAG").equals("2")) {
								param.put("OUTSTOCK_NUM"	, param.get("INOUT_NUM"));
							}

							if(param.get("QUERY_FLAG").equals("3")) {
								param.put("OUTSTOCK_NUM"	, dataMaster.get("REF_WKORD_NUM"));
//								param.put("REF_WKORD_NUM"	, dataMaster.get("REF_WKORD_NUM"));
							}

							this.insertDetail(param, dataMaster, user, inoutSeq);
							dataMaster.put("PRODT_INOUT_NUM", inoutNum);
							inoutSeq++;
						} else {
							this.updateDetail(param, dataMaster, user);
						}
					}
				}
				//20200330 추가: 작업 후 마지막에  USP_PRODT_PMR202UKRV_SITE 호출하는 로직 추가 
				Map<String, Object> spParam2 = new HashMap<String, Object>();
				for(Map dataListMap: paramList) {
					List<Map> allList = (List<Map>)dataListMap.get("data");
					for(Map param: allList) {
						spParam2.put("COMP_CODE"	, user.getCompCode());
						spParam2.put("DIV_CODE"		, param.get("DIV_CODE"));
						spParam2.put("WKORD_NUM"	, param.get("REF_WKORD_NUM"));
						spParam2.put("PRODT_DATE"	, dataMaster.get("INOUT_DATE"));		//panel의 출고일
						spParam2.put("S_USER_ID"	, user.getUserID());
						super.commonDao.queryForObject("pmr202ukrvServiceImpl.USP_PRODT_PMR202UKRV_SITE", spParam2);

						String errorDesc = ObjUtils.getSafeString(spParam2.get("ErrorDesc"));
						if (!ObjUtils.isEmpty(errorDesc)) {
							throw new UniDirectValidateException(this.getMessage(errorDesc, user));
						}
					}
				}
			}
			paramList.add(0, paramMaster);
			return  paramList;
		}

		@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")			// INSERT
		public Integer insertDetail(Map param, Map paramMaster, LoginVO user, int inoutSeq) throws Exception {
			try {
//				for(Map param : paramList ) {
//				param.put("WH_CODE"			, paramMaster.get("WH_CODE"));
				super.commonDao.insert("pmr202ukrvServiceImpl.insertDetail", param);
			} catch(Exception e){
				throw new  UniDirectValidateException(this.getMessage("8114", user));
			}
			Map b049 = (Map) super.commonDao.select("pmr202ukrvServiceImpl.selectB049", param);

			if("1".equals(b049.get("ESTIMATEM_METHOD"))) {
				if("1".equals(b049.get("AVERAGECALC_PERIOD"))) {
					Map selInoutDate = (Map) super.commonDao.select("pmr202ukrvServiceImpl.selectInoutDate", param);
					param.put("INOUT_DATE", selInoutDate.get("INOUT_DATE"));
					//20191118 INOUT_TYPE이 조회된 값이 없으므로 하드코딩 (출고: "2")
					param.put("INOUT_TYPE", "2");

					super.commonDao.update("pmr202ukrvServiceImpl.SP_STOCK_PeriodicAverage", param);

				} else {
					//20191118 INOUT_TYPE이 조회된 값이 없으므로 하드코딩 (출고: "2")
					param.put("INOUT_TYPE", "2");
					super.commonDao.update("pmr202ukrvServiceImpl.SP_STOCK_PeriodicAverageMonthly", param);
				}
			}

			String errorDesc = ObjUtils.getSafeString(param.get("ErrorDesc"));
			if(!ObjUtils.isEmpty(errorDesc)) {
//				throw new UniDirectValidateException(this.getMessage(errorDesc, user));
				throw new Exception(errorDesc);
			}
//				}
			try {
				if(param.get("QUERY_FLAG").equals("1")) {
					//BTR100T 추가 후, PMP200T/PMP350T의 수량 UPDATE
					super.commonDao.update("pmr202ukrvServiceImpl.updatePMP", param);
				}
			} catch(Exception e){
				throw new  UniDirectValidateException(this.getMessage("8114", user));
			}

			return 0;
		}

		@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")			// UPDATE
		public Integer updateDetail(Map param, Map paramMaster, LoginVO user) throws Exception {
//			for(Map param :paramList ) {
//			param.put("INOUT_DATE"		, paramMaster.get("INOUT_DATE"));
			param.put("WORK_SHOP_CODE"	, paramMaster.get("WORK_SHOP_CODE"));
//			param.put("WH_CODE"			, paramMaster.get("WH_CODE"));

			super.commonDao.update("pmr202ukrvServiceImpl.updateDetail", param);

			Map b049 = (Map) super.commonDao.select("pmr202ukrvServiceImpl.selectB049", param);

			if("1".equals(b049.get("ESTIMATEM_METHOD"))) {
				if("1".equals(b049.get("AVERAGECALC_PERIOD"))) {
					Map selInoutDate = (Map) super.commonDao.select("pmr202ukrvServiceImpl.selectInoutDate", param);
					param.put("INOUT_DATE", selInoutDate.get("INOUT_DATE"));

					super.commonDao.update("pmr202ukrvServiceImpl.SP_STOCK_PeriodicAverage", param);

				} else {
					super.commonDao.update("pmr202ukrvServiceImpl.SP_STOCK_PeriodicAverageMonthly", param);
				}
			}
			String errorDesc = ObjUtils.getSafeString(param.get("ErrorDesc"));
			if(!ObjUtils.isEmpty(errorDesc)) {
//				throw new UniDirectValidateException(this.getMessage(errorDesc, user));
				throw new Exception(errorDesc);
			}
//			}
			if(param.get("QUERY_FLAG").equals("1")) {
				//BTR100T 변경 후, PMP200T/PMP350T의 수량 UPDATE
				super.commonDao.update("pmr202ukrvServiceImpl.updatePMP", param);
			}
			return 0;
		}

		@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")			// DELETE
		public Integer deleteDetail(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
			for(Map param :paramList) {
				try {
					param.put("WORK_SHOP_CODE"	, paramMaster.get("WORK_SHOP_CODE"));
//					param.put("WH_CODE"			, paramMaster.get("WH_CODE"));
					Map selInoutDate = (Map) super.commonDao.select("pmr202ukrvServiceImpl.selectInoutDate", param);
					param.put("INOUT_DATE", selInoutDate.get("INOUT_DATE"));

					super.commonDao.delete("pmr202ukrvServiceImpl.deleteDetail", param);
				//20191118 중복로직 주석
//				} catch(Exception e) {
//					throw new  UniDirectValidateException(this.getMessage("547",user));
//				}

					Map b049 = (Map) super.commonDao.select("pmr202ukrvServiceImpl.selectB049", param);
	
					if("1".equals(b049.get("ESTIMATEM_METHOD"))) {
						if("1".equals(b049.get("AVERAGECALC_PERIOD"))) {
	
							super.commonDao.update("pmr202ukrvServiceImpl.SP_STOCK_PeriodicAverage", param);
	
						} else {
							super.commonDao.update("pmr202ukrvServiceImpl.SP_STOCK_PeriodicAverageMonthly", param);
						}
					}
					String errorDesc = ObjUtils.getSafeString(param.get("ErrorDesc"));
					if(!ObjUtils.isEmpty(errorDesc)) {
//						throw new UniDirectValidateException(this.getMessage(errorDesc, user));
						throw new Exception(errorDesc);
					}

				//20191118 중복로직 주석
//				try {
					if(param.get("QUERY_FLAG").equals("1")) {
						//BTR100T 삭제 후, PMP200T/PMP350T의 수량, 수불번호, 수불순번 UPDATE
						super.commonDao.update("pmr202ukrvServiceImpl.deletePMP", param);
					}

				} catch(Exception e) {
					throw new  UniDirectValidateException(this.getMessage("547",user));
				}
			}
			return 0;
		}




		/**
		 * 작업지시번호 입력 시, 해당관련 데이터 조회
		 * @param param
		 * @return
		 * @throws Exception
		 */
		@ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_READ)
		public List<Map<String, Object>> getWhCode(Map param) throws Exception {
			return super.commonDao.list("pmr202ukrvServiceImpl.getWhCode", param);
		}



		/**
		 * 라벨출력시 사용할 데이터 관련
		 * @param param
		 * @return
		 * @throws Exception
		 */
		@ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_READ)
		public List<Map<String, Object>> selectClipPrintList(Map param) throws Exception {
			System.out.println("[param1]" + param);
			return super.commonDao.list("pmr202ukrvServiceImpl.selectClipPrintList", param);
		}






	/**
	 * 진척이력 조회: 20200330 추가
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_mit")
	public List<Map> selectWorkProgressList(Map param) throws Exception{
		return super.commonDao.list("pmr202ukrvServiceImpl.selectWorkProgressList", param);
	}

	/**
	 * 진척이력 저장: 20200330 추가
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "z_mit")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> savetWorkProgress (List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteWorkProgress")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insertWorkProgress")) {
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("updateWorkProgress")) {
					updateList = (List<Map>)dataListMap.get("data");
				}
			}
//				if(deleteList != null) this.deleteWorkProgress(deleteList, user);
//				if(insertList != null) this.insertWorkProgress(insertList, user);
			if(updateList != null) this.updateWorkProgress(updateList, user);
		}
		paramList.add(0, paramMaster);
		return	paramList;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_mit")	// UPDATE
	public Integer updateWorkProgress(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param : paramList) {
			super.commonDao.update("pmr202ukrvServiceImpl.updateWorkProgress", param);
		}
		return 0;
	}
}