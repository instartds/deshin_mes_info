package foren.unilite.modules.z_hb;

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
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
//import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.extjs.UniliteExtjsUtils;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.com.fileman.FileMnagerService;
import foren.unilite.modules.matrl.mpo.Mpo501ukrvModel;

@Service("s_mpo502ukrv_hbService")
public class S_mpo502ukrv_hbServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	/**
     *
     * 긴급발주등록(SP) 조회
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
    public List<Map<String, Object>> selectOrderPrsn(Map param) throws Exception {
        return super.commonDao.list("s_mpo502ukrv_hbServiceImpl.selectOrderPrsn", param);
    }



    /**
     * 긴급발주등록 Master 조회
     *
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.FORM_LOAD)
    public Object selectMaster(Map param) throws Exception {
        return super.commonDao.select("s_mpo502ukrv_hbServiceImpl.selectMaster", param);
    }

	/**
	 *
	 * 긴급발주등록(SP) 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return super.commonDao.list("s_mpo502ukrv_hbServiceImpl.selectList", param);
	}

	/**
     *
     * 타발주 -> 그리드SET 조회
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
    public List<Map<String, Object>> selectList2(Map param) throws Exception {
        return super.commonDao.list("s_mpo502ukrv_hbServiceImpl.selectList2", param);
    }

	/**
	 *
	 * 긴급발주등록(SP) -> 발주번호 검색
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectOrderNumMasterList(Map param) throws Exception {
		return super.commonDao.list("s_mpo502ukrv_hbServiceImpl.selectOrderNumMasterList", param);
	}

	/**
	 *
	 * 긴급발주등록(SP) -> 타발주참조
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectOrderNumMasterList2(Map param) throws Exception {
		return super.commonDao.list("s_mpo502ukrv_hbServiceImpl.selectOrderNumMasterList2", param);
	}

	/**
     *
     * 긴급발주등록(SP) ->  발주요청등록 참조
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
    public List<Map<String, Object>> selectMrp400tList(Map param) throws Exception {
        return super.commonDao.list("s_mpo502ukrv_hbServiceImpl.selectMrp400tList", param);
    }

	/**
	 *
	 * 긴급발주등록(SP) -> BPR200T에서 품질대상여부(INSPEC_YN) 가져와서 그리드의 품질대상여부(INSPEC_FLAG)에 넣어준다.
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public Object  callInspecyn(Map param) throws Exception {

		return  super.commonDao.select("s_mpo502ukrv_hbServiceImpl.callInspecyn", param);
	}
	/**
	 *
	 *  구매담당 선택시 승인자 가져옴
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public Object  userName(Map param) throws Exception {

		return  super.commonDao.select("s_mpo502ukrv_hbServiceImpl.userName", param);
	}

	/**
	 *
	 * userID에 따른 납품창고
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public Object  userWhcode(Map param) throws Exception {

		return  super.commonDao.select("s_mpo502ukrv_hbServiceImpl.userWhcode", param);
	}

	/**
	 * 단가 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@Transactional(readOnly=true) //, isolation=TransactionDefinition.ISOLATION_READ_UNCOMMITTED)
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public Object  fnOrderPrice(Map param) throws Exception {

		return  super.commonDao.select("s_mpo502ukrv_hbServiceImpl.fnOrderPrice", param);
	}
	/**
	 *
	 * 품질검사여부 관련 (부서별)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public Object  callDeptInspecFlag(Map param) throws Exception {

		return  super.commonDao.select("s_mpo502ukrv_hbServiceImpl.callDeptInspecFlag", param);
	}


	/**
	 * 발주등록(SP)-> 저장
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "matrl")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		//logger.debug("[saveAll] paramMaster:" + paramMaster);
		//logger.debug("[saveAll] paramDetail:" + paramList);


		//1.로그테이블에서 사용할 Key 생성
		String keyValue = getLogKey();

		//2.발주마스터 로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");

		dataMaster.put("KEY_VALUE", keyValue);
		dataMaster.put("COMP_CODE", user.getCompCode());

		if (ObjUtils.isEmpty(dataMaster.get("ORDER_NUM") )) {
			dataMaster.put("OPR_FLAG", "N");
		} else {
			dataMaster.put("OPR_FLAG", "U");
		}

		super.commonDao.insert("s_mpo502ukrv_hbServiceImpl.insertLogMaster", dataMaster);

		//3.발주디테일 로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
		List<Map> dataList = new ArrayList<Map>();
		List<List<Map>> resultList = new ArrayList<List<Map>>();
		if(paramList != null)	{
			for(Map param: paramList) {
				dataList = (List<Map>)param.get("data");

				if(param.get("method").equals("insertDetail")) {
					param.put("data", insertLogDetails(dataList, keyValue, "N") );
				} else if(param.get("method").equals("updateDetail")) {
					param.put("data", insertLogDetails(dataList, keyValue, "U") );
				} else if(param.get("method").equals("deleteDetail")) {
					param.put("data", insertLogDetails(dataList, keyValue, "D") );
				}
			}
		}

		//4.발주저장 Stored Procedure 실행
		Map<String, Object> spParam = new HashMap<String, Object>();

		spParam.put("KeyValue", keyValue);
		spParam.put("LangCode", user.getLanguage());

		if ("4".equals(dataMaster.get("ORDER_TYPE"))){  // 외주
			super.commonDao.queryForObject("s_mpo502ukrv_hbServiceImpl.spPurchaseOutOrder", spParam);
		} else {
			super.commonDao.queryForObject("s_mpo502ukrv_hbServiceImpl.spPurchaseOrder", spParam);
		}

		String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));

		if(ObjUtils.isEmpty(errorDesc)){
			//마스터에 SET
			dataMaster.put("ORDER_NUM", ObjUtils.getSafeString(spParam.get("OrderNum")));
			//그리드에 SET
			for(Map param: paramList) {
				dataList = (List<Map>)param.get("data");
				if(param.get("method").equals("insertDetail")) {
					List<Map> datas = (List<Map>)param.get("data");
					for(Map data: datas){
						data.put("ORDER_NUM", ObjUtils.getSafeString(spParam.get("OrderNum")));
					}
				}
			}

		} else {
			dataMaster.put("ORDER_NUM", "");
			String[] messsage = errorDesc.split(";");
		    throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
		}

		//5.발주마스터 정보 + 발주디테일 정보 결과셋 리턴
		//마스터정보가 없을 경우에도 작성
		paramList.add(0, paramMaster);

		return  paramList;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "sales")
	public ExtDirectFormPostResult syncForm(Mpo501ukrvModel dataMaster,  LoginVO user,  BindingResult result) throws Exception {

		String keyValue = getLogKey();
		//2.발주마스터 로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
		dataMaster.setCOMP_CODE(user.getCompCode());
		dataMaster.setKEY_VALUE(keyValue);

		if (ObjUtils.isEmpty(dataMaster.getORDER_NUM() )) {
			dataMaster.setOPR_FLAG("N");
		} else {
			dataMaster.setOPR_FLAG("U");
		}

		super.commonDao.insert("s_mpo502ukrv_hbServiceImpl.insertLogMaster", dataMaster);

		//4.발주저장 Stored Procedure 실행
		Map<String, Object> spParam = new HashMap<String, Object>();

		spParam.put("KeyValue", keyValue);
		spParam.put("LangCode", user.getLanguage());

		super.commonDao.queryForObject("s_mpo502ukrv_hbServiceImpl.spPurchaseOrder", spParam);

		String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
		if(!ObjUtils.isEmpty(errorDesc)){
			extResult.addResultProperty("ORDER_NUM", "");
            String[] messsage = errorDesc.split(";");
            throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
		} else {
			extResult.addResultProperty("ORDER_NUM", ObjUtils.getSafeString(spParam.get("OrderNum")));
		}

//		dataMaster.setS_COMP_CODE(user.getCompCode());
//		super.commonDao.update("sof100ukrvServiceImpl.updateMasterForm", dataMaster);
//		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
		return extResult;
	}

	/**
	 * 발주등록 로그정보 저장
	 */
	public List<Map> insertLogDetails(List<Map> params, String keyValue, String oprFlag) throws Exception {
		for(Map param: params)	{
			param.put("KEY_VALUE", keyValue);
			param.put("OPR_FLAG", oprFlag);

			if(!oprFlag.equals("D")){
				super.commonDao.update("s_mpo502ukrv_hbServiceImpl.insertBpr400t", param);
			}
			super.commonDao.insert("s_mpo502ukrv_hbServiceImpl.insertLogDetail", param);
		}
		return params;
	}
	/**
	 * Detail 입력
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_MODIFY)
	public void insertDetail(List<Map> paramList, LoginVO user) throws Exception {
		return;
	}


	/**
	 * Detail 수정
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("rawtypes")
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_MODIFY)
	public void updateDetail(List<Map> paramList, LoginVO user) throws Exception {
		return;
	}

	/**
	 * Detail 삭제
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_MODIFY)
	public void deleteDetail(List<Map> paramList, LoginVO user) throws Exception {
		return;
	}



	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)		// 엑셀 업로드
    public List<Map<String, Object>> selectExcelUploadSheet1(Map param) throws Exception {
        return super.commonDao.list("s_mpo502ukrv_hbServiceImpl.selectExcelUploadSheet1", param);
    }

    public void excelValidate(String jobID, Map param) {							// 엑셀 Validate
	    logger.debug("validate: {}", jobID);
		super.commonDao.update("s_mpo502ukrv_hbServiceImpl.excelValidate", param);
	}

    @ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
    public List<Map<String, Object>> mainReport(Map param) throws Exception {
        return super.commonDao.list("s_mpo502ukrv_hbServiceImpl.mainReport", param);
    }

    @ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
    public List<Map<String, Object>> subReport(Map param) throws Exception {
        return super.commonDao.list("s_mpo502ukrv_hbServiceImpl.subReport", param);
    }

    /**
	 * 라벨출력
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  labelPrint1(Map param) throws Exception {
		return  super.commonDao.list("s_mpo502ukrv_hbServiceImpl.labelPrint1", param);
	}
}
