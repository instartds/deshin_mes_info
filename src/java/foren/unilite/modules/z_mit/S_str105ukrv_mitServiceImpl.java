package foren.unilite.modules.z_mit;

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
import foren.framework.lib.tree.GenericTreeDataMap;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.base.bdc.Bdc100ukrvService;
import foren.unilite.modules.com.fileman.FileMnagerService;
import foren.unilite.modules.com.tree.UniTreeHelper;
import foren.unilite.modules.crm.cmd.Cmd100ukrvModel;
import foren.unilite.modules.sales.SalesCommonServiceImpl;
import foren.unilite.modules.com.tree.UniTreeHelper;
import foren.unilite.modules.com.tree.UniTreeNode;

@Service("s_str105ukrv_mitService")
@SuppressWarnings({"unchecked", "rawtypes"})
public class S_str105ukrv_mitServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	@Resource(name="salesCommonService")
	private SalesCommonServiceImpl SalesUtil;


	/**
	 * 출고정보 조회(group by)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList (Map param) throws Exception {
		return super.commonDao.list("s_str105ukrv_mitServiceImpl.selectList", param);
	}

	/**
	 * 출고정보 조회(detail)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList2 (Map param) throws Exception {
		return super.commonDao.list("s_str105ukrv_mitServiceImpl.selectList2", param);
	}

	
	/**
	 * 출고정보검색 조회(Master)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectOrderNumMasterList(Map param) throws Exception {
		return super.commonDao.list("s_str105ukrv_mitServiceImpl.selectOrderNumMaster", param);
	}

	/**
	 * 출하지시 참조 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectRequestiList(Map param) throws Exception {
		return super.commonDao.list("s_str105ukrv_mitServiceImpl.selectRequestiList", param);
	}

	/**
	 * 수주(오퍼) 참조 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectSalesOrderList(Map param) throws Exception {
		return super.commonDao.list("s_str105ukrv_mitServiceImpl.selectSalesOrderList", param);
	}

	/**
	 * 창고조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public Object  deptWhcode(Map param) throws Exception {	
		return super.commonDao.select("s_str105ukrv_mitServiceImpl.deptWhcode", param);
	}




	/**
	 * 수주번호 입력 시 관련정보 조회: 20200130 추가 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> getOrderNum (Map param) throws Exception {
		return super.commonDao.list("s_str105ukrv_mitServiceImpl.getOrderNum", param);
	}

	/**
	 * 출하지시번호 입력 시 관련정보 조회: 20200401 추가 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> getIssueReqNum (Map param) throws Exception {
		return super.commonDao.list("s_str105ukrv_mitServiceImpl.getIssueReqNum", param);
	}
	
	/**
	 * 바코드 입력 시 관련정보 조회 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> getBarcodeInfo (Map param) throws Exception {
		return super.commonDao.list("s_str105ukrv_mitServiceImpl.getBarcodeInfo", param);
	}

	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> getFifo (Map param) throws Exception {
		String keyValue = getLogKey();
		param.put("KEY_VALUE", keyValue);
		return super.commonDao.list("s_str105ukrv_mitServiceImpl.getFifo", param);
	}




	/**
	 * 출고정보(BARCODE) 저장
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll2(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		logger.debug("[saveAll2] paramDetail:" + paramList);

		//1.로그테이블에서 사용할 KeyValue 생성
		String keyValue = getLogKey();
				
		//2.출하지시 로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
		List<Map> dataList = new ArrayList<Map>();
		
		for(Map paramData: paramList) {
			dataList = (List<Map>) paramData.get("data");

			logger.debug("paramData.get('data') : " + dataList);
			String oprFlag = "N";
			if(paramData.get("method").equals("insertDetail2"))	oprFlag="N";
			if(paramData.get("method").equals("updateDetail2"))	oprFlag="U";
			if(paramData.get("method").equals("deleteDetail2"))	oprFlag="D";

			for(Map param:  dataList) {
				param.put("KEY_VALUE", keyValue);
				param.put("OPR_FLAG", oprFlag);
				param.put("data", super.commonDao.insert("s_str105ukrv_mitServiceImpl.insertLogMaster", param));
			}
		}
		//출고등록 Stored Procedure 실행
		Map<String, Object> spParam = new HashMap<String, Object>();

		spParam.put("KeyValue", keyValue);
		spParam.put("LangCode", user.getLanguage());

		super.commonDao.queryForObject("s_str105ukrv_mitServiceImpl.spReceiving", spParam);
		
		String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
		
		//출하지시 마스터 출하지시 번호 update
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
				
//		if(!errorDesc.isEmpty()){
//			dataMaster.put("INOUT_NUM", "");
//			throw new Exception(errorDesc);
//		} else {
//			dataMaster.put("INOUT_NUM", ObjUtils.getSafeString(spParam.get("InOutNum")));
//		}
		if(!ObjUtils.isEmpty(errorDesc)){
			dataMaster.put("INOUT_NUM", "");
			String[] messsage = errorDesc.split(";");
			if(messsage.length == 1){			    
			    throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
			}else{
			    throw new  UniDirectValidateException(this.getMessage(messsage[0], user) + "\n" + messsage[1]);
			}
		} else {
			dataMaster.put("INOUT_NUM", ObjUtils.getSafeString(spParam.get("InOutNum")));
			//수주번호 그리드에 SET
			for(Map param: paramList) {
				dataList = (List<Map>)param.get("data");	
				if(param.get("method").equals("insertDetail2")) {
					List<Map> datas = (List<Map>)param.get("data");
					for(Map data: datas){
						data.put("INOUT_NUM", ObjUtils.getSafeString(spParam.get("InOutNum")));
					}
				}
			}
		}
		
		paramList.add(0, paramMaster);
		return  paramList;
	}
	
	/**
	 * 출고 Detail 입력
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> insertDetail2(List<Map> params, LoginVO user) throws Exception {
		return params;
	}
	
	/**
	 * 출고 Detail 수정
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> updateDetail2 (List<Map> params, LoginVO user) throws Exception {
		return params;
	}
	
	/**
	 * 출고 Detail 삭제
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_MODIFY)
	public void deleteDetail2 (List<Map> params, LoginVO user) throws Exception {
	}


	


	/**
	 * 거래명세서 출력 관련 쿼리 호출
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>>  clipselectsub(Map param) throws Exception {
		return super.commonDao.list("s_str105ukrv_mitServiceImpl.clipselectsub", param); 
	}







	/**
	 * 임시데이터 처리 관련
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> tempSelectList (Map param) throws Exception {
		return super.commonDao.list("s_str105ukrv_mitServiceImpl.tempSelectList", param);
	}
	
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> getTempBarcodeData (Map param) throws Exception {
		return super.commonDao.list("s_str105ukrv_mitServiceImpl.getTempBarcodeData", param);
	}
	/**저장**/
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> tempSaveAll (List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		if(paramList != null) {
			List<Map> tempInsertDetail = null;

			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("tempInsertDetail")) {
					tempInsertDetail = (List<Map>)dataListMap.get("data");
				}
			}
			if(tempInsertDetail != null) this.tempInsertDetail(tempInsertDetail, user, dataMaster);
		}
		paramList.add(0, paramMaster);
		return paramList;
	}

	/** 추가 / 수정 **/
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
	public Integer tempInsertDetail(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		try {
			Map<String, Object> spParam = new HashMap<String, Object>();
			if(ObjUtils.isEmpty(paramMaster.get("INOUT_NUM"))) {
				//출고번호 채번
				spParam.put("COMP_CODE"	, user.getCompCode());
				spParam.put("DIV_CODE"	, paramMaster.get("DIV_CODE"));
				spParam.put("TABLE_ID"	, "BTR100T");
				spParam.put("PREFIX"	, "S");
				spParam.put("INOUT_DATE", paramMaster.get("INOUT_DATE"));
				spParam.put("AUTO_TYPE"	, "1");
				spParam.put("InOutNum"	, "");
				super.commonDao.queryForObject("s_str105ukrv_mitServiceImpl.makeInoutNum", spParam);
			}
			for(Map param : paramList) {
				if(ObjUtils.isEmpty(paramMaster.get("INOUT_NUM"))) {
					param.put("INOUT_NUM", spParam.get("InOutNum"));
					super.commonDao.insert("s_str105ukrv_mitServiceImpl.tempInsertDetail", param);
				} else {
					super.commonDao.delete("s_str105ukrv_mitServiceImpl.tempDeleteDetail", param);
					super.commonDao.insert("s_str105ukrv_mitServiceImpl.tempInsertDetail", param);
				}
				if("1".equals(paramMaster.get("GUBUN"))) {
					//SOF110T.TEMPC_05에 INOUT_NUM UPDATE
					super.commonDao.update("s_str105ukrv_mitServiceImpl.updateSofDetail", param);
				} else {
					super.commonDao.update("s_str105ukrv_mitServiceImpl.updateSrqDetail", param);
				}
			}
		}catch(Exception e){
			throw new UniDirectValidateException(this.getMessage("8114", user));
		}
		return 0;
	}
	
	/** 삭제 **/
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
	public Integer tempDeleteDetail(Map param, LoginVO user, Map paramMaster) throws Exception {
		try {
			super.commonDao.delete("s_str105ukrv_mitServiceImpl.tempDeleteDetail2", param);
			if("1".equals(paramMaster.get("GUBUN"))) {
				//SOF110T.TEMPC_05에 INOUT_NUM UPDATE
				super.commonDao.update("s_str105ukrv_mitServiceImpl.updateSofDetail2", param);
			} else {
				super.commonDao.update("s_str105ukrv_mitServiceImpl.updateSrqDetail2", param);
			}
		} catch(Exception e) {
			throw new UniDirectValidateException(this.getMessage("547",user));
		}
		return 0;
	}
}
