package foren.unilite.modules.matrl.mpo;

import java.util.ArrayList;
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


@Service("mpo200ukrvService")
@SuppressWarnings({ "unchecked", "rawtypes" })
public class Mpo200ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	


	/**
	 * 엑셀업로드
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)		// 엑셀 업로드
	public List<Map<String, Object>> selectExcelUploadSheet1(Map param) throws Exception {
		return super.commonDao.list("mpo200ukrvServiceImpl.selectExcelUploadSheet1", param);
	}

	public void excelValidate(String jobID, Map param) {							// 엑셀 Validate
		super.commonDao.update("mpo200ukrvServiceImpl.excelValidate", param);
	}



	/**
	 * 구매오더확정 master 조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> gridUp(Map param) throws Exception {
		return super.commonDao.list("mpo200ukrvServiceImpl.gridUp", param);
	}

	/**
	 * 구매오더확정 detail 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> gridDown(Map param) throws Exception {
		return super.commonDao.list("mpo200ukrvServiceImpl.gridDown", param);
	}

	/**
	 * 구매요청정보 조정 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectAdjustList(Map param) throws Exception {   
		List<Map> chkList = (List) super.commonDao.list("mpo200ukrvServiceImpl.selectAdjustList1", param);
		String BaseDates = "";
		String FromItems = "";
		for(Map check : chkList) {
			BaseDates += check.get("ORDER_PLAN_DATE") + "|#";
			FromItems += check.get("ORDER_PLAN_DATE") + "|#";
		}
		param.put("BASE_DATE", BaseDates);
		param.put("FROM_ITEM", FromItems);
		
		return super.commonDao.list("mpo200ukrvServiceImpl.selectAdjustList2", param);
	}



	/**
	 * 구매오더 확정 sp호출
	 * @param paramList 리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})   
	public List<Map> orderConfirm(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		//1.로그테이블에서 사용할 KeyValue 생성
		String keyValue = getLogKey();
		Map<String, Object> masterParam = new HashMap<String, Object>();
		masterParam.put("KEY_VALUE", keyValue);

		//2.출하지시 로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
		List<Map> dataList = new ArrayList<Map>();
		for(Map paramData: paramList) {
			dataList = (List<Map>) paramData.get("data");
			for(Map param: dataList) {
				param.put("KEY_VALUE"	, keyValue);
				param.put("OPR_FLAG"	, "N");
				param.put("data"		, super.commonDao.update("mpo200ukrvServiceImpl.insertLogDetail", param));
			}
			super.commonDao.update("mpo200ukrvServiceImpl.insertLogMaster", masterParam);
		}

		//3.구매오더 확정 SP 호출
		List<Map> orderConfirmList = super.commonDao.list("mpo200ukrvServiceImpl.getOrderConfirmList", masterParam);
		for(Map spParam: orderConfirmList) {
			spParam.put("LangCode", user.getLanguage());
			super.commonDao.queryForObject("mpo200ukrvServiceImpl.USP_MATRL_Mpo200ukr", spParam);
			String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));

			if(!ObjUtils.isEmpty(errorDesc)){
				String[] messsage = errorDesc.split(";");
				throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
			}
		}
//		Map<String, Object> spParam = new HashMap<String, Object>();
//		spParam.put("KeyValue", keyValue);
//		spParam.put("LangCode", user.getLanguage());
//
//		super.commonDao.queryForObject("mpo200ukrvServiceImpl.USP_MATRL_Mpo200ukr", spParam);
//		String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
//
//		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
//		if(!ObjUtils.isEmpty(errorDesc)){
//			dataMaster.put("ORDER_NUM", "");
//			String[] messsage = errorDesc.split(";");
//			throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
//		} else {
//			dataMaster.put("ORDER_NUM", ObjUtils.getSafeString(spParam.get("OrderNum")));
//			for(Map param: paramList) {
//				dataList = (List<Map>)param.get("data");
//				if(param.get("method").equals("insertDetail")) {
//					List<Map> datas = (List<Map>)param.get("data");
//					for(Map data: datas){
//						data.put("ORDER_NUM", ObjUtils.getSafeString(spParam.get("OrderNum")));
//					}
//				}
//			}
//		}
		paramList.add(0, paramMaster);
		return  paramList;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "matrl")		// UPDATE
	public Integer insertDetail(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		return 0;
	}



	/**
	 * 구매요청정보 저장탭 저장
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "matrl")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		if(paramList != null) {
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("insertAdjust")) {
					insertList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("updateAdjust")) {
					updateList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("deleteAdjust")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}
			}
			if(insertList != null) this.insertAdjust(insertList, user);
			if(updateList != null) this.updateAdjust(updateList, paramMaster, user); 
			if(deleteList != null) this.deleteAdjust(deleteList, user);
		}
		paramList.add(0, paramMaster);
		return paramList;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "matrl")
	public void insertAdjust(List<Map> paramList, LoginVO user) throws Exception {
		String keyValue = getLogKey();
		for(Map param : paramList ) {
			param.put("KEY_VALUE", keyValue);
			param.put("OPR_FLAG", "N");
			
			super.commonDao.insert("mpo200ukrvServiceImpl.insertAdjust", param);
		}
		Map<String, Object> spParam = new HashMap<String, Object>();
		spParam.put("KeyValue", keyValue);
		super.commonDao.queryForObject("mpo070ukrvServiceImpl.USP_MATRL_MPO070UKRV", spParam);
		
		String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
		
		if(ObjUtils.isNotEmpty(errorDesc)){
			throw new  UniDirectValidateException(errorDesc);
		}
		return;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "matrl")		// UPDATE
	public void updateAdjust(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		for(Map param :paramList ) {
			super.commonDao.update("mpo200ukrvServiceImpl.updateAdjust", param);
		}
		return;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "matrl")
	public void deleteAdjust(List<Map> paramList,  LoginVO user) throws Exception {
		for(Map param :paramList ) {
			super.commonDao.delete("mpo200ukrvServiceImpl.deleteAdjust", param);
		}
		return;
	}
}