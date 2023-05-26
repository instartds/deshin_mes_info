package foren.unilite.modules.z_in;

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


@Service("s_pmr101ukrv_inService")
@SuppressWarnings({"rawtypes", "unchecked"})

public class S_pmr101ukrv_inServiceImpl extends TlabAbstractServiceImpl {
		private final Logger logger = LoggerFactory.getLogger(this.getClass());	

		@ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_READ)		// 작업지시조회
		public List<Map<String, Object>> selectDetailList(Map param) throws Exception {
			return super.commonDao.list("s_pmr101ukrv_inServiceImpl.selectDetailList", param);
		}

		@ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_READ)		// 불량내역등록 조회
		public List<Map<String, Object>> selectDetailList5(Map param) throws Exception {
			return super.commonDao.list("s_pmr101ukrv_inServiceImpl.selectDetailList5", param);
		}
		
		@ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_READ)		// 불량내역등록 조회
		public List<Map<String, Object>> fnRecordCombo(Map param) throws Exception {
			return super.commonDao.list("s_pmr101ukrv_inServiceImpl.fnRecordCombo", param);
		}

	/**
	 *  detail5 저장 (불량)
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "prodt")
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
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")	 // INSERT
	public Integer  insertDetail5(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param : paramList ) {
			super.commonDao.update("s_pmr101ukrv_inServiceImpl.insertDetail5", param);
		} 
		return 0;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")	// UPDATE
	public Integer updateDetail5(List<Map> paramList, LoginVO user) throws Exception {
		Map checkParam = paramList.get(0);
			List<Map> beforeSaveCheck = (List<Map>) super.commonDao.list("s_pmr101ukrv_inServiceImpl.beforeSaveCheck", checkParam);

			if(beforeSaveCheck != null && beforeSaveCheck.size() > 0){
				for(Map param :paramList )	{
					 super.commonDao.update("s_pmr101ukrv_inServiceImpl.updateDetail5", param);
				}
		}else{
			try {
				for(Map param : paramList )	{
					super.commonDao.update("s_pmr101ukrv_inServiceImpl.insertDetail5", param);
				}
			}catch(Exception e){
				throw new UniDirectValidateException(this.getMessage("2627", user));
			}
		}
		return 0;
	}

	@ExtDirectMethod(group = "base", needsModificatinAuth = true)	 // DELETE
	public Integer deleteDetail5(List<Map> paramList,  LoginVO user) throws Exception {
		for(Map param :paramList ) {   
			super.commonDao.update("s_pmr101ukrv_inServiceImpl.deleteDetail5", param);
		}
		return 0;
	}



	/**
	 * 20200406 추가: 생산라인 사용 중 확인로직
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public String fnCheckProgressCode( Map param, LoginVO user ) throws Exception {
		return (String) super.commonDao.select("s_pmr101ukrv_inServiceImpl.fnCheckProgressCode", param);
	}

	/**
	 * 20200407 추가: 생산라인 변경 시, 진행상태를 대기로 변경하기 위한 로직
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public String fnUpdateProgress( Map param, LoginVO user ) throws Exception {
		try {
			super.commonDao.update("s_pmr101ukrv_inServiceImpl.fnUpdateProgress", param);
		} catch(Exception e){
			throw new UniDirectValidateException(this.getMessage("작업도중 오류가 발생했습니다. 관리자에게 문의하시기 바랍니다.", user));
		}
		return "success";
	}

	/**
	 * 20200406 추가: MES에 데이터 연동 / pmp100t에 상태값 update하는 로직
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public String fnRunProdtLine( Map param, LoginVO user ) throws Exception {
		try {
			//오류발생 시, 사용할 Key 생성 - 20200416 추가
			String keyValue = getLogKey();
			param.put("KEY_VALUE", keyValue);

			//MES에 데이터 연동
			super.commonDao.update("s_pmr101ukrv_inServiceImpl.fnRunProdtLine", param);

			//PMP100T에 상태값 update
			super.commonDao.update("s_pmr101ukrv_inServiceImpl.fnUpdateProgress", param);

		} catch(Exception e){
			//오류 메세지 가져오는 로직 추가  - 20200416 추가 (MES쪽에서 개발 완료되면 주석 해제) - 20200417 주석 해제(MES에서 개발 완료)
			String errorDesc = (String) super.commonDao.select("s_pmr101ukrv_inServiceImpl.fnGetErrDesc", param);

			if(ObjUtils.isEmpty(errorDesc)) {
				throw new UniDirectValidateException(this.getMessage("작업도중 오류가 발생했습니다. 관리자에게 문의하시기 바랍니다.", user));
			} else {
				throw new UniDirectValidateException(this.getMessage(errorDesc, user));
			}
//			throw new UniDirectValidateException(this.getMessage("작업도중 오류가 발생했습니다. 관리자에게 문의하시기 바랍니다.", user));
		}
		return "success";
	}
}