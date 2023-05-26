package foren.unilite.modules.sales.str;

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
import foren.unilite.modules.crm.cmd.Cmd100ukrvModel;
import foren.unilite.modules.sales.SalesCommonServiceImpl;
import foren.unilite.modules.sales.sof.Sof100ukrvModel;

@Service("str107ukrvService")
@SuppressWarnings({"unchecked", "rawtypes"})
public class Str107ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Resource(name="salesCommonService")
	private SalesCommonServiceImpl SalesUtil;
	/**
	 *
	 * 출고정보 Detail 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectDetailList(Map param) throws Exception {
		return super.commonDao.list("str107ukrvServiceImpl.selectDetailList", param);
	}


	/**
	 *
	 * 출고정보검색 조회(Master)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectOrderNumMasterList(Map param) throws Exception {
		return super.commonDao.list("str107ukrvServiceImpl.selectOrderNumMaster", param);
	}

	/**
	 *
	 * 출하지시 참조 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectRequestiList(Map param) throws Exception {
		return super.commonDao.list("str107ukrvServiceImpl.selectRequestiList", param);
	}

	/**
	 *
	 * 수주(오퍼) 참조 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectSalesOrderList(Map param) throws Exception {
		return super.commonDao.list("str107ukrvServiceImpl.selectSalesOrderList", param);
	}
	/**
	 *
	 * 창고조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public Object  deptWhcode(Map param) throws Exception {

		return  super.commonDao.select("str107ukrvServiceImpl.deptWhcode", param);
	}
	/**
	 * 출고정보 저장
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		logger.debug("[saveAll] paramDetail:" + paramList);

		//1.로그테이블에서 사용할 KeyValue 생성
		String keyValue = getLogKey();

		//2.출하지시 로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
		List<Map> dataList = new ArrayList<Map>();
//		List<List<Map>> resultList = new ArrayList<List<Map>>();

		for(Map paramData: paramList) {

			dataList = (List<Map>) paramData.get("data");
			logger.debug("paramData.get('data') : " + dataList);
			String oprFlag = "N";
			if(paramData.get("method").equals("insertDetail"))	oprFlag="N";
			if(paramData.get("method").equals("updateDetail"))	oprFlag="U";
			if(paramData.get("method").equals("deleteDetail"))	oprFlag="D";

			for(Map param:  dataList) {
				param.put("KEY_VALUE", keyValue);
				param.put("OPR_FLAG", oprFlag);
//				param.put("PICK_BOX_QTY", 0);
//				param.put("PICK_EA_QTY", 0);
//				param.put("PICK_STATUS", "");
				param.put("data", super.commonDao.insert("str107ukrvServiceImpl.insertLogMaster", param));
			}
		}
		//출고등록 Stored Procedure 실행
		Map<String, Object> spParam = new HashMap<String, Object>();

		spParam.put("KeyValue", keyValue);
		spParam.put("LangCode", user.getLanguage());

		super.commonDao.queryForObject("str107ukrvServiceImpl.spReceiving", spParam);

		String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
		String salePrsnChk = ObjUtils.getSafeString(spParam.get("SalePrsnChk"));



		//출하지시 마스터 출하지시 번호 update
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");

		//운송정보용 맵 세팅
		Map<String, Object> spParamDvry = new HashMap<String, Object>();
		spParamDvry.put("COMP_CODE", 		dataMaster.get("S_COMP_CODE"));
		spParamDvry.put("DIV_CODE", 		dataMaster.get("DIV_CODE"));
		spParamDvry.put("DVRY_DATE", 		dataMaster.get("DVRY_DATE"));
		spParamDvry.put("CAR_NO", 			dataMaster.get("CAR_NO"));
		spParamDvry.put("CARRIER_TYPE", 	dataMaster.get("CARRIER_TYPE"));
		spParamDvry.put("DRIVER", 			dataMaster.get("DRIVER"));
		spParamDvry.put("DRIVER_MOBILENO", 	dataMaster.get("DRIVER_MOBILENO"));
		spParamDvry.put("PALLET_TYPE", 		dataMaster.get("PALLET_TYPE"));
		spParamDvry.put("PALLET_CNT", 	    dataMaster.get("PALLET_CNT"));
		spParamDvry.put("CREATE_LOC", 		dataMaster.get("CREATE_LOC"));
		spParamDvry.put("REMARK", 			dataMaster.get("REMARK"));
		spParamDvry.put("INOUT_NUM", 		ObjUtils.getSafeString(spParam.get("InOutNum")));
		spParamDvry.put("S_USER_ID", 	    dataMaster.get("S_USER_ID"));
		String dvryManageYn = (String)dataMaster.get("DVRY_MANAGE_YN");

		if(ObjUtils.isNotEmpty(dvryManageYn)&& dvryManageYn.equals("Y")){

			int chkCnt  = (int) super.commonDao.queryForObject("str107ukrvServiceImpl.selectDvryChk", spParamDvry); //기존 운송정보 존재 여부 체크
			int chkCnt2 = (int) super.commonDao.queryForObject("str107ukrvServiceImpl.selectInoutChk", spParamDvry);//수불정보 존재 여부 체크

			if(chkCnt2 > 0 && chkCnt == 0 ){   //수불정보가 있고 운송정보가 없을 경우 운송정보 insert

				super.commonDao.insert("str107ukrvServiceImpl.insertDvry", spParamDvry);

			}else if(chkCnt2 > 0 && chkCnt > 0){//수불정보가 있고  운송정보도 있을 경우 운송정보 update

				super.commonDao.update("str107ukrvServiceImpl.updateDvry", spParamDvry);

			}else{								//그외에는 운송정보 delete

				super.commonDao.delete("str107ukrvServiceImpl.deleteDvry", spParamDvry);

			}
		}
//		if(!errorDesc.isEmpty()){
//			dataMaster.put("INOUT_NUM", "");
//			throw new Exception(errorDesc);
//		} else {
//			dataMaster.put("INOUT_NUM", ObjUtils.getSafeString(spParam.get("InOutNum")));
//		}
	//  if(errorDesc.isEmpty())){


		if(!ObjUtils.isEmpty(errorDesc)){
			dataMaster.put("INOUT_NUM", "");
			throw new UniDirectValidateException(this.getMessage(errorDesc, user));
		} else {
			dataMaster.put("INOUT_NUM", ObjUtils.getSafeString(spParam.get("InOutNum")));
			if(!ObjUtils.isEmpty(salePrsnChk)){
				dataMaster.put("SALE_PRSN_CHK", salePrsnChk);
			}
			//수주번호 그리드에 SET
			for(Map param: paramList) {
				dataList = (List<Map>)param.get("data");
				if(param.get("method").equals("insertDetail")) {
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
	public List<Map> insertDetail(List<Map> params, LoginVO user) throws Exception {
		return params;
	}

	/**
	 * 출고 Detail 수정
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> updateDetail(List<Map> params, LoginVO user) throws Exception {
		return params;
	}

	/**
	 * 출고 Detail 삭제
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_MODIFY)
	public void deleteDetail(List<Map> params, LoginVO user) throws Exception {
	}




	/**
	 * 메인리포트_라벨 - 20200311 추가: 라벨출력 컬럼 추가에 따른 로직 신규 추가 - 신환코스텍
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map<String, Object>>  mainReport_label(Map param) throws Exception {
		return  super.commonDao.list("str107ukrvServiceImpl.mainReport_label", param);
	}

	/**
	 * 기본양식_라벨 출력 - 20200311 추가: 라벨출력 컬럼 추가에 따른 로직 신규 추가 - 신환코스텍
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  mainReport_basicLabel(Map param) throws Exception {
		return  super.commonDao.list("str107ukrvServiceImpl.mainReport_basicLabel", param);
	}

	/**
	 * 후공정 가져오는 쿼리 - 20200311 추가: 라벨출력 컬럼 추가에 따른 로직 신규 추가 - 신환코스텍
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  mainReport_label_afterProg(Map param) throws Exception {
		return  super.commonDao.list("str107ukrvServiceImpl.mainReport_label_afterProg", param);
	}

	@ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "sales")
	public ExtDirectFormPostResult syncForm(Str107ukrvModel dataMaster,  LoginVO user,  BindingResult result) throws Exception {

		String keyValue = getLogKey();

		dataMaster.setCOMP_CODE(user.getCompCode());
		dataMaster.setS_USER_ID(user.getUserID());
		int chkCnt  = (int) super.commonDao.queryForObject("str107ukrvServiceImpl.selectDvryChk", dataMaster); //기존 운송정보 존재 여부 체크
		int chkCnt2 = (int) super.commonDao.queryForObject("str107ukrvServiceImpl.selectInoutChk", dataMaster);//수불정보 존재 여부 체크


		if(chkCnt2 > 0 && chkCnt == 0 ){   //수불정보가 있고 운송정보가 없을 경우 운송정보 insert

			super.commonDao.insert("str107ukrvServiceImpl.insertDvry", dataMaster);

		}else if(chkCnt2 > 0 && chkCnt > 0){//수불정보가 있고  운송정보도 있을 경우 운송정보 update

			super.commonDao.update("str107ukrvServiceImpl.updateDvry", dataMaster);

		}else{								//그외에는 운송정보 delete

			super.commonDao.delete("str107ukrvServiceImpl.deleteDvry", dataMaster);

		}

		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);

//		dataMaster.setS_COMP_CODE(user.getCompCode());
//		super.commonDao.update("sof100ukrvServiceImpl.updateMasterForm", dataMaster);
//		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
		return extResult;
	}
}