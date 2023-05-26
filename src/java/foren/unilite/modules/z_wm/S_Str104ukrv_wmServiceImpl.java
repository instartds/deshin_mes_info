package foren.unilite.modules.z_wm;

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

@Service("s_str104ukrv_wmService")
@SuppressWarnings({"unchecked", "rawtypes"})
public class S_Str104ukrv_wmServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Resource(name="salesCommonService")
	private SalesCommonServiceImpl SalesUtil;

	//20210108 추가: playauto 출하지시 api 호출을 위해 추가
	@Resource(name="s_api_wmService")
	private S_api_wmServiceImpl S_api_wmService;



	/**
	 *
	 * 출고정보 Detail 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectDetailList(Map param) throws Exception {
		return super.commonDao.list("s_str104ukrv_wmServiceImpl.selectDetailList", param);
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
		return super.commonDao.list("s_str104ukrv_wmServiceImpl.selectOrderNumMaster", param);
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
		return super.commonDao.list("s_str104ukrv_wmServiceImpl.selectRequestiList", param);
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
		return super.commonDao.list("s_str104ukrv_wmServiceImpl.selectSalesOrderList", param);
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
		return  super.commonDao.select("s_str104ukrv_wmServiceImpl.deptWhcode", param);
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

		for(Map paramData: paramList) {
			dataList = (List<Map>) paramData.get("data");
			logger.debug("paramData.get('data') : " + dataList);
			String oprFlag = "N";
			if(paramData.get("method").equals("insertDetail"))	oprFlag="N";
			if(paramData.get("method").equals("updateDetail"))	oprFlag="U";
			if(paramData.get("method").equals("deleteDetail"))	oprFlag="D";

			for(Map param:  dataList) {
				param.put("KEY_VALUE"	, keyValue);
				param.put("OPR_FLAG"	, oprFlag);
				param.put("data"		, super.commonDao.insert("s_str104ukrv_wmServiceImpl.insertLogMaster", param));

				//20210226 추가: 삭제가 아니고, NUMBER(SOL_NO)가 '99999'(쇼핑몰 데이터)인 데이터는 IF_ORDER_LIST_PUT에 insert
				if(!"D".equals(param.get("OPR_FLAG")) && "9999".equals(param.get("NUMBER"))) {
					super.commonDao.update("s_str104ukrv_wmServiceImpl.insertIfOrderListPut", param);
				}
			}
		}
		//출고등록 Stored Procedure 실행
		Map<String, Object> spParam = new HashMap<String, Object>();
		spParam.put("KeyValue", keyValue);
		spParam.put("LangCode", user.getLanguage());
		super.commonDao.queryForObject("s_str104ukrv_wmServiceImpl.spReceiving", spParam);
		String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));

		//출고등록 마스터 출하지시 번호 update
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		if(!ObjUtils.isEmpty(errorDesc)){
			dataMaster.put("INOUT_NUM", "");
			throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
		} else {
			//20210205 추가: 출고번호 1개 생성 시에는 저장 후, 조회할 수 있도록 변경
			if(ObjUtils.isNotEmpty(spParam.get("InOutNum"))) {
				String[] inoutNum = ((String) spParam.get("InOutNum")).split(",");
				if(inoutNum.length == 1) {
					dataMaster.put("INOUT_NUM", inoutNum[0].toString());
				}
			}
			//수주번호 그리드에 SET
			for(Map param: paramList) {
				dataList = (List<Map>)param.get("data");
				//20210226 주석: 출하지시등록(WM)으로 로직 이동
//				if(param.get("method").equals("insertDetail")) {
//					//20210108 추가: 신규 등록의 경우 playauto 출고지시   API 호출 (https://openapi.playauto.io/api/order/instruction)
//					Map<String,Object> outStockOrderMap	= new HashMap();
//					String apiError						= "";
//					String url							= "https://openapi.playauto.io/api/order/instruction";
//					String[] bundle_codes				= new String[] {(String) dataMaster.get("bundle_codes")};
//					Boolean auto_bundle					= false;
//					outStockOrderMap.put("url"			, url);
//					outStockOrderMap.put("bundle_codes"	, bundle_codes);
//					outStockOrderMap.put("auto_bundle"	, auto_bundle);
//					//우선 주석 풀고 테스트 필요*************************************************************************
//					apiError = S_api_wmService.updateAPIoutStockOrderStatus(outStockOrderMap, user);
//					if(!"0".equals(apiError)) {
//						throw new UniDirectValidateException(apiError);
//					}
//				}
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
}