package foren.unilite.modules.z_yp;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
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


@Service("s_pmr100ukrv_ypService")
@SuppressWarnings({"rawtypes", "unchecked"})
public class S_pmr100ukrv_ypServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	@ExtDirectMethod(group = "z_yp", value = ExtDirectMethodType.STORE_READ)		// 작업실적등록 조회
	public List<Map<String, Object>> selectDetailList(Map param) throws Exception {
		return super.commonDao.list("s_pmr100ukrv_ypServiceImpl.selectDetailList", param);
	}
	// END OF 작업실적 조회
	
	@ExtDirectMethod(group = "z_yp", value = ExtDirectMethodType.STORE_READ)		// 공정별등록 조회1
	public List<Map<String, Object>> selectDetailList2(Map param) throws Exception {
		return super.commonDao.list("s_pmr100ukrv_ypServiceImpl.selectDetailList2", param);
	}
	// END OF 제품
	
	@ExtDirectMethod(group = "z_yp", value = ExtDirectMethodType.STORE_READ)		// 공정별등록 조회1
	public List<Map<String, Object>> selectDetailList3(Map param) throws Exception {
		return super.commonDao.list("s_pmr100ukrv_ypServiceImpl.selectDetailList3", param);
	}
	// END OF 원재료
		
	@ExtDirectMethod(group = "z_yp", value = ExtDirectMethodType.STORE_READ)		// 공정별등록 조회2
	public List<Map<String, Object>> selectDetailList4(Map param) throws Exception {
		return super.commonDao.list("s_pmr100ukrv_ypServiceImpl.selectDetailList4", param);
	}
	// END OF 부산물
	
	@ExtDirectMethod(group = "z_yp", value = ExtDirectMethodType.STORE_READ)		// 원재료(작업지시)
	public List<Map<String, Object>> selectDetailList5(Map param) throws Exception {
		return super.commonDao.list("s_pmr100ukrv_ypServiceImpl.selectDetailList5", param);
	}
	// END OF 원재료(작업지시)
	
	
	
	
	
	
	
	
	
	
	
	/**
	 *	2. 제퓸 저장
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "z_yp")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class}) 
	public List<Map> saveAll2(List<Map> paramList,	Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster	= (Map<String, Object>) paramMaster.get("data");
 		
		List<Map> dataList = new ArrayList<Map>();
		for(Map paramData: paramList) {
			dataList		= (List<Map>) paramData.get("data");
			String oprFlag	= "N";
			
			if(paramData.get("method").equals("insertDetail2")) oprFlag="N";
			if(paramData.get("method").equals("updateDetail2")) oprFlag="N";
			if(paramData.get("method").equals("deleteDetail2")) oprFlag="D";

			for(Map param:  dataList) {
				Map<String, Object> spParam		= new HashMap<String, Object>();
				SimpleDateFormat dateFormat		= new SimpleDateFormat ("yyyyMMdd");
				Date dateGet					= new Date ();
				String dateGetString			= dateFormat.format(dateGet);
				
				String prodtNum = (String) param.get("PRODT_NUM");
				spParam.put("COMP_CODE"		, user.getCompCode());
				spParam.put("DIV_CODE"		, param.get("DIV_CODE"));
				spParam.put("TABLE_ID"		, "s_pmr100ukrv_yp");
				spParam.put("PREFIX"		, "P");
				spParam.put("BASIS_DATE"	, dateGetString);
				spParam.put("AUTO_TYPE"		, "1");

//				if(oprFlag.equals("N") && !prodtNum.isEmpty()) {
//					param.put("STATUS"		, "U");
//				} else {
					param.put("STATUS"		, oprFlag);
//				}
				param.put("USER_ID"		, user.getUserID());
				param.put("PRODT_TYPE"	, "1");
				

				if(param.get("STATUS").equals("N")) {
					//생산번호 자동채번
					super.commonDao.queryForObject("s_pmr100ukrv_ypServiceImpl.spAutoNum", spParam);
					prodtNum = ObjUtils.getSafeString(spParam.get("KEY_NUMBER"));
					

					param.put("PRODT_NUM"	, prodtNum);
					super.commonDao.update("s_pmr100ukrv_ypServiceImpl.insertList2", param);
					
//				} else if(param.get("STATUS").equals("U")) {
//					param.put("GOOD_WORK_Q"			, ObjUtils.parseDouble(param.get("GOOD_WORK_Q")));
//					param.put("BAD_WORK_Q"			, ObjUtils.parseDouble(param.get("BAD_WORK_Q")));
//					super.commonDao.update("s_pmr100ukrv_ypServiceImpl.updateList2", param);
					
				} else {
					param.put("CONTROL_STATUS", "2");
					super.commonDao.update("s_pmr100ukrv_ypServiceImpl.deleteList2", param);
				}
				
				double zero = 0;
				
				param.put("PRODT_TYPE"		, "2");
				param.put("STATUS"			, oprFlag);
				param.put("KEY_VALUE"		, dataMaster.get("KEY_VALUE"));
//				param.put("USER_ID"			, user.getUserID());
				
				if(!param.get("RESULT_YN").equals("2")) {
					param.put("GOOD_WH_CODE"		, "");
					param.put("GOOD_WH_CELL_CODE"	, "");
					param.put("GOOD_PRSN"			, "");
					param.put("GOOD_WORK_Q"			, zero);
					param.put("BAD_WH_CODE"			, "");
					param.put("BAD_WH_CELL_CODE"	, "");
					param.put("BAD_PRSN"			, "");
					param.put("BAD_WORK_Q"			, zero);

				} else {
					param.put("GOOD_WORK_Q"			, ObjUtils.parseDouble(param.get("GOOD_WORK_Q")));
					param.put("BAD_WORK_Q"			, ObjUtils.parseDouble(param.get("BAD_WORK_Q")));
				}
				
				super.commonDao.update("s_pmr100ukrv_ypServiceImpl.SP_PRODT_ProductionResult_YP", param);
				String errorDesc = ObjUtils.getSafeString(param.get("ErrorDesc"));
				if(!ObjUtils.isEmpty(errorDesc)) {
					throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
				} 
			}
		}
		paramList.add(0, paramMaster);
		return  paramList;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_yp")			// INSERT
	public Integer insertDetail2(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		/* 데이터 insert */
//		try {
//			for(Map param : paramList )	{	
//				super.commonDao.insert("s_pmr100ukrv_ypServiceImpl.insertList2", param);
//			}	
//		}catch(Exception e){
//			throw new  UniDirectValidateException(this.getMessage("8114", user));
//		}
		
		return 0;
	} 
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_yp")			// UPDATE
	public Integer updateDetail2(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
//		for(Map param :paramList )	{	
//			super.commonDao.update("s_pmr100ukrv_ypServiceImpl.updateList2", param);
//		}
		return 0;
	} 
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_yp")			// DELETE
	public Integer deleteDetail2(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
//		 for(Map param :paramList )	{
//			try {
//				super.commonDao.delete("s_pmr100ukrv_ypServiceImpl.deleteList2", param);
//				 
//			}catch(Exception e)	{
//				throw new  UniDirectValidateException(this.getMessage("547",user));
//			}	
//		}
		return 0;
	}
	
	
	
	
	
	
	/**
	 *	3. 원재료 저장
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
/*	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "z_yp")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class}) 
	public List<Map> saveAll3(List<Map> paramList,	Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		
		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("insertDetail3")) {
					insertList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("updateDetail3")) {		
					updateList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("deleteDetail3")) {
					deleteList = (List<Map>)dataListMap.get("data");	
				} 
			}			
			if(deleteList != null) this.deleteDetail3(deleteList, dataMaster, user);
			if(insertList != null) this.insertDetail3(insertList, dataMaster, user);
			if(updateList != null) this.updateDetail3(updateList, dataMaster, user);				
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_yp")			// INSERT
	public Integer insertDetail3(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		 데이터 insert 
		try {
			for(Map param : paramList )	{	
				super.commonDao.insert("s_pmr100ukrv_ypServiceImpl.insertList3", param);
			}	
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("8114", user));
		}
		
		return 0;
	} 
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_yp")			// UPDATE
	public Integer updateDetail3(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		for(Map param :paramList )	{	
			super.commonDao.update("s_pmr100ukrv_ypServiceImpl.updateDetail3", param);
		}
		return 0;
	} 
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_yp")			// DELETE
	public Integer deleteDetail3(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		
		return 0;
	}
*/	
	
	
	
	
	
	/**
	 *	4. 부산물 저장
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "z_yp")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class}) 
	public List<Map> saveAll4(List<Map> paramList,	Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		
		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("insertDetail4")) {
					insertList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("updateDetail4")) {		
					updateList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("deleteDetail4")) {
					deleteList = (List<Map>)dataListMap.get("data");	
				} 
			}			
			if(deleteList != null) this.deleteDetail4(deleteList, dataMaster, user);
			if(insertList != null) this.insertDetail4(insertList, dataMaster, user);
			if(updateList != null) this.updateDetail4(updateList, dataMaster, user);
		}
		paramList.add(0, paramMaster);
				
		return  paramList;

	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_yp")			// INSERT
	public Integer insertDetail4(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		/* 데이터 insert */
		try {
			Map<String, Object> spParam		= new HashMap<String, Object>();
			
			spParam.put("COMP_CODE"		, user.getCompCode());			
			spParam.put("DIV_CODE"		, paramMaster.get("DIV_CODE"));
			spParam.put("TABLE_ID"		, "BTR100T");
			spParam.put("PREFIX"		, "R");
			spParam.put("BASIS_DATE"	, paramMaster.get("PRODT_DATE"));
			spParam.put("AUTO_TYPE"		, "1");

			//수불번호 자동채번
			super.commonDao.queryForObject("s_pmr100ukrv_ypServiceImpl.spAutoNum", spParam);
			String inoutNum = ObjUtils.getSafeString(spParam.get("KEY_NUMBER"));
			
			int i = 1;
			for(Map param : paramList )	{
				param.put("INOUT_NUM"	, inoutNum);
				param.put("INOUT_SEQ"	, ObjUtils.getSafeString(i));
				param.put("INOUT_TYPE"	, "1");
				super.commonDao.insert("s_pmr100ukrv_ypServiceImpl.insertDetail4", param);
				i++;
				
				//재고 SP(SP_STOCK_PeriodicAverage) 호출
				super.commonDao.update("s_pmr100ukrv_ypServiceImpl.SP_STOCK_PeriodicAverage", param);
				String errorDesc = ObjUtils.getSafeString(param.get("ErrorDesc"));
				if(!ObjUtils.isEmpty(errorDesc)) {
					throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
				} 
			}	
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("8114", user));
		}
		
		return 0;
	} 
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_yp")			// UPDATE
	public Integer updateDetail4(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		for(Map param :paramList )	{	
			super.commonDao.update("s_pmr100ukrv_ypServiceImpl.updateDetail4", param);
			param.put("INOUT_TYPE"	, "1");

			//재고 SP(SP_STOCK_PeriodicAverage) 호출
			super.commonDao.update("s_pmr100ukrv_ypServiceImpl.SP_STOCK_PeriodicAverage", param);
			String errorDesc = ObjUtils.getSafeString(param.get("ErrorDesc"));
			if(!ObjUtils.isEmpty(errorDesc)) {
				throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
			} 
		}
		return 0;
	} 
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_yp")			// DELETE
	public Integer deleteDetail4(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		 for(Map param :paramList )	{
			try {
				super.commonDao.delete("s_pmr100ukrv_ypServiceImpl.deleteDetail4", param);
				param.put("INOUT_TYPE"	, "1");

				//재고 SP(SP_STOCK_PeriodicAverage) 호출
				super.commonDao.update("s_pmr100ukrv_ypServiceImpl.SP_STOCK_PeriodicAverage", param);
				String errorDesc = ObjUtils.getSafeString(param.get("ErrorDesc"));
				if(!ObjUtils.isEmpty(errorDesc)) {
					throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
				} 
			}catch(Exception e)	{
				throw new  UniDirectValidateException(this.getMessage("547",user));
			}	
		}
		return 0;
	}	
	
	
	
	
	
	
	/**
	 *	5. PMP200T 저장
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "z_yp")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class}) 
	public List<Map> saveAll5(List<Map> paramList,	Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		String keyValue = getLogKey();
		String oprFlag	= "N";
		
		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("insertDetail2")) oprFlag="N";
				if(dataListMap.get("method").equals("updateDetail2")) oprFlag="U";
				if(dataListMap.get("method").equals("deleteDetail2")) oprFlag="D";

				if(dataListMap.get("method").equals("insertDetail5")) {
					insertList = (List<Map>)dataListMap.get("data");
					for(Map insertData: insertList) {
						insertData.put("OPR_FLAG", oprFlag);
					}
				}else if(dataListMap.get("method").equals("updateDetail5")) {		
					updateList = (List<Map>)dataListMap.get("data");
					for(Map updateData: updateList) {
						updateData.put("OPR_FLAG", oprFlag);
					}
				} else if(dataListMap.get("method").equals("deleteDetail5")) {
					deleteList = (List<Map>)dataListMap.get("data");	
					for(Map deleteData: deleteList) {
						deleteData.put("OPR_FLAG", oprFlag);
					}
				} 
			}			
			if(deleteList != null) this.deleteDetail5(deleteList, dataMaster, user, keyValue);
			if(insertList != null) this.insertDetail5(insertList, dataMaster, user, keyValue);
			if(updateList != null) this.updateDetail5(updateList, dataMaster, user, keyValue);				
		}
		dataMaster.put("KEY_VALUE", keyValue);

		paramList.add(0, paramMaster);
		return  paramList;

	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_yp")			// INSERT
	public Integer insertDetail5(List<Map> paramList, Map paramMaster, LoginVO user, String keyValue) throws Exception {
		/* 데이터 insert(사용 안 함) */
		throw new  UniDirectValidateException("저장할 데이터가 없습니다.");
//		try {
//			for(Map param : paramList )	{	
//				super.commonDao.insert("s_pmr100ukrv_ypServiceImpl.insertDetail5", param);
//			}	
//		}catch(Exception e){
//			throw new  UniDirectValidateException(this.getMessage("8114", user));
//		}
//		
//		return 0;
	} 
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_yp")			// UPDATE
	public Integer updateDetail5(List<Map> paramList, Map paramMaster, LoginVO user, String keyValue) throws Exception {
//		spParam.put("COMP_CODE"		, user.getCompCode());			
//		spParam.put("DIV_CODE"		, paramMaster.get("DIV_CODE"));
//		spParam.put("TABLE_ID"		, "BTR100T");
//		spParam.put("PREFIX"		, "R");
//		spParam.put("BASIS_DATE"	, paramMaster.get("PRODT_DATE"));
//		spParam.put("AUTO_TYPE"		, "1");
//
//		//수불번호 자동채번
//		super.commonDao.queryForObject("s_pmr100ukrv_ypServiceImpl.spAutoNum", spParam);
//		String inoutNum = ObjUtils.getSafeString(spParam.get("KEY_NUMBER"));
		
//		int i = 1;
		for(Map param :paramList )	{	
			param.put("KEY_VALUE"	, keyValue);
//			param.put("INOUT_NUM"	, inoutNum);
//			param.put("INOUT_SEQ"	, ObjUtils.getSafeString(i));
//			param.put("INOUT_TYPE"	, "2");
//			param.put("PRODT_DATE"	, param.get("INOUT_DATE"));
			super.commonDao.update("s_pmr100ukrv_ypServiceImpl.updateDetail5", param);
//			i++;
			
//			//재고 SP(SP_STOCK_PeriodicAverage) 호출
//			super.commonDao.update("s_pmr100ukrv_ypServiceImpl.SP_STOCK_PeriodicAverage", param);
//			String errorDesc = ObjUtils.getSafeString(param.get("ErrorDesc"));
//			if(!ObjUtils.isEmpty(errorDesc)) {
//				throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
//			} 
		}
		return 0;
	} 
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_yp")			// DELETE
	public Integer deleteDetail5(List<Map> paramList, Map paramMaster, LoginVO user, String keyValue) throws Exception {
		 for(Map param :paramList )	{
			try {
				param.put("KEY_VALUE"	, keyValue);
				super.commonDao.delete("s_pmr100ukrv_ypServiceImpl.updateDetail5", param);
				 
			}catch(Exception e)	{
				throw new  UniDirectValidateException(this.getMessage("547",user));
			}	
		}
		return 0;
	}
}
