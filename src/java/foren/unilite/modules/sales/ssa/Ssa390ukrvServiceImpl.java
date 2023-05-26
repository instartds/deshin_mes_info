package foren.unilite.modules.sales.ssa;

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
import foren.unilite.modules.sales.SalesCommonServiceImpl;

@Service("ssa390ukrvService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Ssa390ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Resource(name="salesCommonService")
	private SalesCommonServiceImpl SalesUtil;

	/**
	 * 매출정보검색팝업 조회(Master)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectSalesNumMasterList(Map param) throws Exception {
		return super.commonDao.list("ssa390ukrvServiceImpl.selectSalesNumMaster", param);
	}

	/**
	 * 매출정보검색팝업 조회(Detail)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectSalesNumDetailList(Map param) throws Exception {
		return super.commonDao.list("ssa390ukrvServiceImpl.selectSalesNumDetail", param);
	}


	/**
	 * 영업담당자의 부서 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public Object getDeptName(Map param) throws Exception {
		return super.commonDao.select("ssa390ukrvServiceImpl.getDeptName", param);
	}

	/**
	 * 계약참조 팝업 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectSalesOrderList(Map param) throws Exception {
		return super.commonDao.list("ssa390ukrvServiceImpl.selectSalesOrderList", param);
	}

	/**
	 * 계약참조 데이터 적용
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> setSalesOrderList(Map param) throws Exception {
		return super.commonDao.list("ssa390ukrvServiceImpl.setSalesOrderList", param);
	}



	/**
	 * 매출정보 Master 조회
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.FORM_LOAD)
	public Object selectMaster(Map param) throws Exception {
		return super.commonDao.select("ssa390ukrvServiceImpl.selectMaster", param);
	}

	/**
	 *
	 * 매출정보 Detail 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectDetailList(Map param) throws Exception {
		return super.commonDao.list("ssa390ukrvServiceImpl.selectDetailList", param);
	}

	/**
	 * LOT 연계여부 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> getGsManageLotNoYN(Map param) throws Exception {
		return super.commonDao.list("ssa390ukrvServiceImpl.getGsManageLotNoYN", param);
	}

	/**
	 * ref_code2 = 반품환입인 총건수
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public Object getGlSubCdTotCnt(Map param) throws Exception {
		return super.commonDao.select("ssa390ukrvServiceImpl.getGlSubCdTotCnt", param);
	}

	/**
	 * 마감 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public Object getGetClosingInfo(Map param) throws Exception {
		return super.commonDao.select("ssa390ukrvServiceImpl.getGetClosingInfo", param);
	}






	/**
	 * 매출정보 저장
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		//logger.debug("[saveAll] paramMaster:" + paramMaster);
		//logger.debug("[saveAll] paramDetail:" + paramList);

		//1.로그테이블에서 사용할 Key 생성
		String keyValue = getLogKey();

		//2.매출마스터 로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");

		dataMaster.put("KEY_VALUE", keyValue);

		if (ObjUtils.isEmpty(dataMaster.get("BILL_NUM") )) {
			dataMaster.put("OPR_FLAG", "N");
		} else {
			dataMaster.put("OPR_FLAG", "U");
		}

		super.commonDao.insert("ssa390ukrvServiceImpl.insertLogMaster", dataMaster);

		//3.매출디테일 로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
		List<Map> dataList = new ArrayList<Map>();
		List<List<Map>> resultList = new ArrayList<List<Map>>();

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

		//4.매출저장 Stored Procedure 실행
		Map<String, Object> spParam = new HashMap<String, Object>();

		spParam.put("KeyValue", keyValue);
		spParam.put("LangCode", user.getLanguage());

		super.commonDao.queryForObject("ssa390ukrvServiceImpl.spReceiving", spParam);

		String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));

	//  if(errorDesc.isEmpty())){
		if(!ObjUtils.isEmpty(errorDesc)){
			dataMaster.put("BILL_NUM", "");
			/*String[] messsage = errorDesc.split(";");
		    throw new  UniDirectValidateException(this.getMessage(messsage[0], user));*/
			throw new	UniDirectValidateException(this.getMessage(errorDesc, user));
		} else {
			//SCN100T 상태값 업데이트
			super.commonDao.update("ssa390ukrvServiceImpl.updateScn100t", dataMaster);
			
			dataMaster.put("BILL_NUM", ObjUtils.getSafeString(spParam.get("BillNum")));
			//매출번호 그리드에 SET
			for(Map param: paramList) {
				dataList = (List<Map>)param.get("data");
				if(param.get("method").equals("insertDetail")) {
					List<Map> datas = (List<Map>)param.get("data");
					for(Map data: datas){
						data.put("BILL_NUM", ObjUtils.getSafeString(spParam.get("BillNum")));
					}
				}
			}
		}

		//5.매출마스터 정보 + 매출디테일 정보 결과셋 리턴
		paramList.add(0, paramMaster);

		return  paramList;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "sales")
	public ExtDirectFormPostResult syncForm(Ssa390ukrvModel dataMaster,  LoginVO user,  BindingResult result) throws Exception {
		dataMaster.setCOMP_CODE(user.getCompCode());
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
		Map<String, Object> spParam = new HashMap<String, Object>();
		spParam.put("BILL_TYPE", dataMaster.getBILL_TYPE());
		spParam.put("CARD_CUST_CD", dataMaster.getCARD_CUST_CD());
		spParam.put("ORDER_TYPE", dataMaster.getORDER_TYPE());
		spParam.put("PROJECT_NO", dataMaster.getPROJECT_NO());
		spParam.put("TAX_TYPE", dataMaster.getTAX_TYPE());
		spParam.put("REMARK", dataMaster.getREMARK());
		spParam.put("COMP_CODE", dataMaster.getCOMP_CODE());
		spParam.put("DIV_CODE", dataMaster.getDIV_CODE());
		spParam.put("BILL_NUM", dataMaster.getBILL_NUM());

		spParam.put("MONEY_UNIT", dataMaster.getMONEY_UNIT());
		spParam.put("EXCHG_RATE_O", dataMaster.getEXCHG_RATE_O());
		//20190709 추가
		spParam.put("SALE_PRSN", dataMaster.getSALE_PRSN());

		super.commonDao.update("ssa390ukrvServiceImpl.updateMaster", spParam);
		return extResult;
	}

	/**
	 * 매출디테일 로그정보 저장
	 */
	public List<Map> insertLogDetails(List<Map> params, String keyValue, String oprFlag) throws Exception {
		for(Map param: params)		{
			param.put("KEY_VALUE", keyValue);
			param.put("OPR_FLAG", oprFlag);

			super.commonDao.insert("ssa390ukrvServiceImpl.insertLogDetail", param);
		}
		return params;
	}


	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> insertDetail(List<Map> params, LoginVO user) throws Exception {
		return params;
	}

	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> updateDetail(List<Map> params, LoginVO user) throws Exception {
		return params;
	}

	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_MODIFY)
	public void deleteDetail(List<Map> params, LoginVO user) throws Exception {
	}



	/**
	 * 창고조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public Object  deptWhcode(Map param) throws Exception {
		return  super.commonDao.select("ssa390ukrvServiceImpl.deptWhcode", param);
	}
}
