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


@Service("pmr210ukrvService")
@SuppressWarnings({"rawtypes", "unchecked"})

public class Pmr210ukrvServiceImpl extends TlabAbstractServiceImpl {
		private final Logger logger = LoggerFactory.getLogger(this.getClass());	
	
		@ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_READ)		//조회
		public List<Map<String, Object>> selectDetailList(Map param) throws Exception {
			return super.commonDao.list("pmr210ukrvServiceImpl.selectDetailList", param);
		}
		
		
		
		/** 저장 로직
		 * 
		 * @param param
		 * @return
		 * @throws Exception
		 */
		@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "prodt")
//		@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class}) 
		public List<Map> saveAll(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
			Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
			String inoutNum = "";
			
			if(paramList != null)	{
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

							this.insertDetail(param, dataMaster, user, inoutSeq);
							dataMaster.put("PRODT_INOUT_NUM", inoutNum);
							inoutSeq++;
							
						} else {
							this.updateDetail(param, dataMaster, user);
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
				super.commonDao.insert("pmr210ukrvServiceImpl.insertDetail", param);
				
//				super.commonDao.update("pmr210ukrvServiceImpl.SP_STOCK_PeriodicAverage", param);
				Map b049 = (Map) super.commonDao.select("pmr210ukrvServiceImpl.selectB049", param);
				
				if("1".equals(b049.get("ESTIMATEM_METHOD"))) {
					if("1".equals(b049.get("AVERAGECALC_PERIOD"))) {
						super.commonDao.update("pmr210ukrvServiceImpl.SP_STOCK_PeriodicAverage", param);
						
					} else {
						super.commonDao.update("pmr210ukrvServiceImpl.SP_STOCK_PeriodicAverageMonthly", param);
					}
				}
				String errorDesc = ObjUtils.getSafeString(param.get("ErrorDesc"));
				if(!ObjUtils.isEmpty(errorDesc)) {
//					throw new UniDirectValidateException(this.getMessage(errorDesc, user));
					throw new Exception(errorDesc);
				} 
//				}
				//BTR100T 추가 후, PMP200T/PMP350T의 수량 UPDATE
				super.commonDao.update("pmr210ukrvServiceImpl.updatePMP", param);
				
			} catch(Exception e){
				throw new  UniDirectValidateException(this.getMessage("8114", user));
			}
			
			return 0;
		} 
		
		@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")			// UPDATE
		public Integer updateDetail(Map param, Map paramMaster, LoginVO user) throws Exception {
//			for(Map param :paramList )	{	
//			param.put("INOUT_DATE"		, paramMaster.get("INOUT_DATE"));
			param.put("WORK_SHOP_CODE"	, paramMaster.get("WORK_SHOP_CODE"));
//			param.put("WH_CODE"			, paramMaster.get("WH_CODE"));

			super.commonDao.update("pmr210ukrvServiceImpl.updateDetail", param);
				
//			super.commonDao.update("pmr210ukrvServiceImpl.SP_STOCK_PeriodicAverage", param);
			Map b049 = (Map) super.commonDao.select("pmr210ukrvServiceImpl.selectB049", param);
			
			if("1".equals(b049.get("ESTIMATEM_METHOD"))) {
				if("1".equals(b049.get("AVERAGECALC_PERIOD"))) {
					super.commonDao.update("pmr210ukrvServiceImpl.SP_STOCK_PeriodicAverage", param);
					
				} else {
					super.commonDao.update("pmr210ukrvServiceImpl.SP_STOCK_PeriodicAverageMonthly", param);
				}
			}
			String errorDesc = ObjUtils.getSafeString(param.get("ErrorDesc"));
			if(!ObjUtils.isEmpty(errorDesc)) {
//				throw new UniDirectValidateException(this.getMessage(errorDesc, user));
				throw new Exception(errorDesc);
			}
//			}
			//BTR100T 변경 후, PMP200T/PMP350T의 수량 UPDATE
			super.commonDao.update("pmr210ukrvServiceImpl.updatePMP", param);
			return 0;
		} 
		
		
		@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")			// DELETE
		public Integer deleteDetail(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
			for(Map param :paramList )	{
				try {
					param.put("WORK_SHOP_CODE"	, paramMaster.get("WORK_SHOP_CODE"));
//					param.put("WH_CODE"			, paramMaster.get("WH_CODE"));

					super.commonDao.delete("pmr210ukrvServiceImpl.deleteDetail", param);
					
//					super.commonDao.update("pmr210ukrvServiceImpl.SP_STOCK_PeriodicAverage", param);
					Map b049 = (Map) super.commonDao.select("pmr210ukrvServiceImpl.selectB049", param);
					
					if("1".equals(b049.get("ESTIMATEM_METHOD"))) {
						if("1".equals(b049.get("AVERAGECALC_PERIOD"))) {
							super.commonDao.update("pmr210ukrvServiceImpl.SP_STOCK_PeriodicAverage", param);
							
						} else {
							super.commonDao.update("pmr210ukrvServiceImpl.SP_STOCK_PeriodicAverageMonthly", param);
						}
					}
					String errorDesc = ObjUtils.getSafeString(param.get("ErrorDesc"));
					if(!ObjUtils.isEmpty(errorDesc)) {
//						throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
						throw new Exception(errorDesc);
					}
					//BTR100T 삭제 후, PMP200T/PMP350T의 수량, 수불번호, 수불순번 UPDATE
					super.commonDao.update("pmr210ukrvServiceImpl.deletePMP", param);

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
		public List<Map<String, Object>> getOutstockData(Map param) throws Exception {
			return super.commonDao.list("pmr210ukrvServiceImpl.getOutstockData", param);
		}
		
		/**
		 * 작업지시번호 입력 시, 해당관련 데이터 조회
		 * @param param
		 * @return
		 * @throws Exception
		 */
		@ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_READ)
		public List<Map<String, Object>> getWhCode(Map param) throws Exception {
			return super.commonDao.list("pmr210ukrvServiceImpl.getWhCode", param);
		}
}
