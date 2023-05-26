package foren.unilite.modules.z_wm;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.service.impl.TlabCodeService;
import foren.unilite.com.validator.UniDirectValidateException;


@Service("s_sof103ukrv_wmService")
@SuppressWarnings({"rawtypes", "unchecked"})
public class S_Sof103ukrv_wmServiceImpl extends TlabAbstractServiceImpl  {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());


	@Resource(name="s_api_wmService")
	private S_api_wmServiceImpl S_api_wmService;

	/**
	 * 새로 입력한 품목에 맞는 옵션정보 생성 - 20201030 추가
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_wm")
	public List<Map> getOpt(Map param, LoginVO user) throws Exception {
		List<Map> getOpt = super.commonDao.list("s_sof103ukrv_wmServiceImpl.getOpt", param); 
		return getOpt;
	}




	/**
	 * 주문등록(일괄)(WM) 조회 - SOF110T
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_wm")
	public List<Map> selectList(Map param, LoginVO user) throws Exception {
		return super.commonDao.list("s_sof103ukrv_wmServiceImpl.selectList", param);
	}

	/**
	 * 주문등록(일괄)(WM) 조회 - S_SOF115T_WM
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_wm")
	public List<Map> selectList2(Map param, LoginVO user) throws Exception {
		return super.commonDao.list("s_sof103ukrv_wmServiceImpl.selectList2", param);
	}






	/**주문등록(일괄)(WM) 저장 - SOF100T, SOF110T
	 * @param params
	 * @param user
	 * @param dataMaster
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "z_wm")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		//1.로그테이블에서 사용할 KeyValue 생성
		String keyValue					= getLogKey();
		//2.주문등록 로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
		List<Map> dataList				= new ArrayList<Map>();
		Map<String, Object> dataMaster	= (Map<String, Object>) paramMaster.get("data");

		for(Map paramData: paramList) {
			dataList = (List<Map>) paramData.get("data");
			logger.debug("paramData.get('data') : " + dataList);
			String oprFlag = "N";
			if(paramData.get("method").equals("insertDetail"))	oprFlag="N";
			if(paramData.get("method").equals("updateDetail"))	oprFlag="U";
			if(paramData.get("method").equals("deleteDetail"))	oprFlag="D";

			for(Map param: dataList) {
				param.put("KEY_VALUE"	, keyValue);
				param.put("OPR_FLAG"	, oprFlag);
				param.put("ORDER_PRSN"	, dataMaster.get("ORDER_PRSN"));
				param.put("ORDER_DATE"	, dataMaster.get("ORDER_DATE"));
				param.put("data", super.commonDao.insert("s_sof103ukrv_wmServiceImpl.insertLogDetail", param));
			}
		}

		//3.주문등록 Stored Procedure 실행
		Map<String, Object> spParam = new HashMap<String, Object>();
		spParam.put("KeyValue"	, keyValue);
		spParam.put("LangCode"	, user.getLanguage());
		spParam.put("SpFlag"	, "");
		spParam.put("CompCode"	, user.getCompCode());	//20210224 추가: 신규 데이터 없을 때, 다른 데이터 상태값 update하기 위해 추가
		spParam.put("DivCode"	, user.getDivCode());	//20210224 추가: 신규 데이터 없을 때, 다른 데이터 상태값 update하기 위해 추가
		spParam.put("UserId"	, user.getUserID());	//20210224 추가: 신규 데이터 없을 때, 다른 데이터 상태값 update하기 위해 추가
		super.commonDao.queryForObject("s_sof103ukrv_wmServiceImpl.spReceiving", spParam);

		String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));

		//출하지시 마스터 출하지시 번호 update
		if(!ObjUtils.isEmpty(errorDesc)){
			dataMaster.put("KEY_VALUE", "");
			throw new UniDirectValidateException(this.getMessage(errorDesc, user));
		} else {
			dataMaster.put("KEY_VALUE", keyValue);
			//수주번호 그리드에 SET
//			for(Map param: paramList) {
//				dataList = (List<Map>)param.get("data");
//				if(param.get("method").equals("insertDetail")) {
//					List<Map> datas = (List<Map>)param.get("data");
//					for(Map data: datas){
//						data.put("ORDER_NUM", ObjUtils.getSafeString(spParam.get("orderNum")));
//					}
//				}
//			}
		}
		paramList.add(0, paramMaster);
		return paramList;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_wm")
	public Integer insertDetail(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		return 0;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_wm")
	public Integer updateDetail(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		return 0;
	} 

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_wm")
	public Integer deleteDetail(List<Map> paramList,  LoginVO user, Map paramMaster) throws Exception {
		return 0;
	}




	/**주문등록(일괄)(WM) 옵션 저장 - S_SOF115T_WM
	 * @param params
	 * @param user
	 * @param dataMaster
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "z_wm")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll2(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster	= (Map<String, Object>) paramMaster.get("data");

		if(paramList != null) {
			List<Map> insertDetail2 = null;
			List<Map> updateDetail2 = null;
			List<Map> deleteDetail2 = null;
			
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("insertDetail2")) {
					insertDetail2 = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("updateDetail2")) {
					updateDetail2 = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("deleteDetail2")) {
					deleteDetail2 = (List<Map>)dataListMap.get("data");
				} 
			}
			if(insertDetail2 != null) this.insertDetail2(insertDetail2, user, dataMaster);
			if(updateDetail2 != null) this.updateDetail2(updateDetail2, user, dataMaster);
			if(deleteDetail2 != null) this.deleteDetail2(deleteDetail2, user, dataMaster);
		}
		paramList.add(0, paramMaster);
		return  paramList;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_wm")
	public Integer insertDetail2(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		try {
			for(Map param : paramList) {
				param.put("KEY_VALUE", paramMaster.get("KEY_VALUE"));
				super.commonDao.update("s_sof103ukrv_wmServiceImpl.insertDetail2", param);
			}
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("8114", user));
		}
		return 0;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_wm")
	public Integer updateDetail2(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		 for(Map param :paramList) {
			super.commonDao.update("s_sof103ukrv_wmServiceImpl.updateDetail2", param);
		 }
		return 0;
	} 

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_wm")
	public Integer deleteDetail2(List<Map> paramList,  LoginVO user, Map paramMaster) throws Exception {
		try {
			for(Map param : paramList) {
				super.commonDao.update("s_sof103ukrv_wmServiceImpl.deleteDetail2", param);
			}	
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("547", user));
		}
		return 0;
	}





	@ExtDirectMethod( group = "z_wm")
	public String insertAPIOrderList(Map params, LoginVO user) throws Exception {
		String url		= ObjUtils.getSafeString(params.get("api_url"));
		//첫 번째 호출: 조회조건 - wdate, status(신규주문)
		Map aprResult	= S_api_wmService.requestApiData(url, params, user);
		//두 번째 호출: 조회조건 - ord_status_mdate, status(신규주문 아닌 것)
		params.put("date_type"	, "ord_status_mdate");
		params.put("status"		, params.get("status2"));
		Map aprResult2	= S_api_wmService.requestApiData(url, params, user);

		params.put("jsonList"	, aprResult.get("results"));
		params.put("jsonList2"	, aprResult.get("results_prod"));
		params.put("jsonList3"	, aprResult2.get("results"));
		params.put("jsonList4"	, aprResult2.get("results_prod"));

		//조회 시, 적용된 일자(fr) 공통코드에 update
		Map sdateParam = new HashMap();
		sdateParam.put("SDATE"		, params.get("edate"));
		sdateParam.put("S_COMP_CODE", user.getCompCode());
		sdateParam.put("S_USER_ID"	, user.getUserID());
		this.updateSdate(sdateParam, user);

		return this.insertOrderList(params, user);
	}

	/**
	 * 주문 데이터 가져와서 INSERT하는 로직 , 20201029 수정: 자료 가져오기 시, 수주데이터 생성 후 조회하도록 수정
	 * @param paramList
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_wm")
	public String insertOrderList(Map param, LoginVO user) throws Exception {
		//20201026 추가: 데이터 가져올 때, key생성해서 해당 key데이터만 가져오도록 로직 추가 - detailGrid와의 관계에서 사용할 KeyValue 생성
		String keyValue			= getLogKey();								//getLogKey();	//20201126161916120885
		List<Map> paramList		= (List<Map>) param.get("jsonList");		//신규주문 조회
		List<Map> paramList2	= (List<Map>) param.get("jsonList2");		//신규주문 조회(prodt)
		List<Map> paramList3	= (List<Map>) param.get("jsonList3");
		List<Map> paramList4	= (List<Map>) param.get("jsonList4");
		String descripMsg		= "";										//20201208 추가
		String descripMsg2		= "";										//20210126 추가
		try {
			//1. Interface data 생성
			for(Map list : paramList) {
				list.put("COMP_CODE", param.get("S_COMP_CODE"));
				list.put("S_USER_ID", param.get("S_USER_ID"));

				//주문데이터 IF_PA_ORDER_GET에 insert
				super.commonDao.insert("s_sof103ukrv_wmServiceImpl.insertOrderList", list);
			}
			for(Map list3 : paramList3) {
				list3.put("COMP_CODE", param.get("S_COMP_CODE"));
				list3.put("S_USER_ID", param.get("S_USER_ID"));

				//주문데이터 IF_PA_ORDER_GET에 insert
				super.commonDao.insert("s_sof103ukrv_wmServiceImpl.insertOrderList", list3);
			}
			//1-1. 새로 가져온 데이터 갯수 체크
			int count = (int) super.commonDao.select("s_sof103ukrv_wmServiceImpl.countNewData", param);
			if(count == 0) {
				return ObjUtils.getSafeString(count);
			}
			for(Map list2 : paramList2) {
				//주문데이터 IF_PA_ORDER_GET에 sku_cd update
				super.commonDao.update("s_sof103ukrv_wmServiceImpl.updateOrderProdList", list2);
			}
			for(Map list4 : paramList4) {
				//주문데이터 IF_PA_ORDER_GET에 sku_cd update
				super.commonDao.update("s_sof103ukrv_wmServiceImpl.updateOrderProdList", list4);
			}

			//2. IF_PA_ORDER_GET의 data로 수주정보 / 수주옵션 데이터 생성
			param.put("KEY_VALUE", keyValue);
			super.commonDao.update("s_sof103ukrv_wmServiceImpl.insertOrderDetail", param);

			//2-1. Stored Procedure 실행
			Map<String, Object> spParam = new HashMap<String, Object>();
			spParam.put("KeyValue"	, keyValue);
			spParam.put("LangCode"	, user.getLanguage());
			spParam.put("SpFlag"	, "IF");
			spParam.put("CompCode"	, user.getCompCode());	//20210224 추가: 신규 데이터 없을 때, 다른 데이터 상태값 update하기 위해 추가
			spParam.put("DivCode"	, user.getDivCode());	//20210224 추가: 신규 데이터 없을 때, 다른 데이터 상태값 update하기 위해 추가
			spParam.put("UserId"	, user.getUserID());	//20210224 추가: 신규 데이터 없을 때, 다른 데이터 상태값 update하기 위해 추가
			super.commonDao.queryForObject("s_sof103ukrv_wmServiceImpl.spReceiving", spParam);

			String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));

			if(!ObjUtils.isEmpty(errorDesc)){
				throw new UniDirectValidateException(this.getMessage(errorDesc, user));
			}
			//20201208 추가, 20210126 일괄 수정
			int i				= 0;
			int j				= 0;
			List<Map> noRegData	= super.commonDao.list("s_sof103ukrv_wmServiceImpl.getNoRegiData", param);
			if(ObjUtils.isNotEmpty(noRegData)) {
				for(Map data : noRegData) {
					if(ObjUtils.isNotEmpty(data) && ObjUtils.isNotEmpty(data.get("BUNDLE_NO"))) {
						if(i == 0) {
							descripMsg = (String) data.get("BUNDLE_NO");
						} else {
							descripMsg = descripMsg + " ," + (String) data.get("BUNDLE_NO");
						}
						i++;
					}
					if(ObjUtils.isNotEmpty(data) && ObjUtils.isNotEmpty(data.get("ORDER_NAME"))) {
						if(j == 0) {
							descripMsg2 = (String) data.get("ORDER_NAME");
						} else {
							descripMsg2 = descripMsg2 + " ," + (String) data.get("ORDER_NAME");
						}
						j++;
					}
				}
			}
		} catch(Exception e) {
			throw new UniDirectValidateException(this.getMessage("8114", user));
		}
		//20210204 수정: 메세지 처리로직 수정
		if(ObjUtils.isNotEmpty(descripMsg + descripMsg2)) {
			return "SKU_CD 누락/오류:" + descripMsg + "\n" + "그룹번호 누락:" + descripMsg2;		//20210126 수정
		} else {
			return "";
		}
	}


	/**
	 * 조회 시, 적용된 일자(fr) 공통코드에 update
	 * @param paramList
	 * @param user
	 * @param paramMaster
	 * @return
	 * @throws Exception
	 */
	private void updateSdate(Map param, LoginVO user) throws Exception {
		super.commonDao.update("s_sof103ukrv_wmServiceImpl.updateSdate", param);
		return;
	}
}