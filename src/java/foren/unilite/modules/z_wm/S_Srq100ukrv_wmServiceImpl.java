package foren.unilite.modules.z_wm;

import java.io.File;
import java.io.FileInputStream;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.annotation.Resource;

import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.DataFormat;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
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
import foren.framework.model.LoginVO;
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.service.impl.TlabCodeService;
import foren.unilite.com.validator.UniDirectValidateException;


@Service("s_srq100ukrv_wmService")
@SuppressWarnings({"rawtypes", "unchecked"})
public class S_Srq100ukrv_wmServiceImpl extends TlabAbstractServiceImpl  {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Resource(name = "externalDAO_WM")
	protected ExternalDAO_WM extDao;

	//20201223 추가: 주소정제 데이터 가져오기 위해 추가
	@Resource(name = "externalDAO_JUSO_WM")
	protected ExternalDAO_JUSO_WM extDaoJuso;

	//20201216 추가: playauto 배송정보 업데이트 api 호출 
	@Resource(name="s_api_wmService")
	private S_api_wmServiceImpl S_api_wmService;




	/**
	 * 출하지시등록(WM) 조회
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_wm")
	public List<Map> selectList(Map param, LoginVO user) throws Exception {
		if(ObjUtils.isNotEmpty(param.get("orderInfo"))) {
			String[] orderInfoArry	= param.get("orderInfo").toString().split(",");
			List<Map> orderInfoList	= new ArrayList<Map>();
			for(int i=0; i<ObjUtils.parseInt(param.get("dataCount")); i++){
				Map map = new HashMap();
				map.put("ORDER_INFO", orderInfoArry[i]);
				orderInfoList.add(map);
			}
			param.put("ORDER_LIST"	, orderInfoList);
		}

		return super.commonDao.list("s_srq100ukrv_wmServiceImpl.selectList", param);
	}





	/**
	 * 출하지시등록(WM) 저장
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
		List<Map> dataList				= new ArrayList<Map>();
		Map<String, Object> dataMaster	= (Map<String, Object>) paramMaster.get("data");

		for(Map paramData: paramList) {
			dataList = (List<Map>) paramData.get("data");
			logger.debug("paramData.get('data') : " + dataList);

			for(Map param: dataList) {
				//2.출하지시등록 로그테이블에 KEY_VALUE 업데이트
				param.put("KEY_VALUE"	, keyValue);
//				param.put("OPR_FLAG"	, oprFlag);
				param.put("data", super.commonDao.insert("s_srq100ukrv_wmServiceImpl.insertLogDetail", param));
			}
		}

		//3.출하지시등록 Stored Procedure 실행
		Map<String, Object> spParam = new HashMap<String, Object>();
		spParam.put("KeyValue", keyValue);
		spParam.put("LangCode", user.getLanguage());
		super.commonDao.queryForObject("s_srq100ukrv_wmServiceImpl.spReceiving", spParam);

		String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));

		if(!ObjUtils.isEmpty(errorDesc)){
			dataMaster.put("KEY_VALUE", "");
			throw new UniDirectValidateException(this.getMessage(errorDesc, user));
		} else {
			//4.대한통운 배송데이터 interface / playauto, 쇼핑몰 연동로직 호출
			for(Map paramData: paramList) {
				dataList = (List<Map>) paramData.get("data");
				for(Map param: dataList) {
					param.put("KEY_VALUE", keyValue);
					this.insertTrnOrder(param, user, dataMaster);
				}
			}
			//20210303 추가: 임시 테이블에 저장 후 insert하는 로직으로 변경, 20210309 수정: 체크/메세지 로직 추가
			if(dataMaster.get("CPATH").equals("/wm")) {
				List<Map> CarriageBillData	= super.commonDao.list("s_srq100ukrv_wmServiceImpl.getCarriageBillData", spParam);
				if(CarriageBillData.size() > 0) {
					for(Map param: CarriageBillData) {
						List<Map<String, Object>> CarriageList	= new ArrayList();
						CarriageList.add(param);
//						String interfaceMsg = extDao.update("s_srq100ukrv_wmServiceImpl.insertTrnOrder_confirm", CarriageList);
						if(ObjUtils.isEmpty(extDao.update("s_srq100ukrv_wmServiceImpl.insertTrnOrder_confirm", CarriageList))) {
							throw new UniDirectValidateException("대한통운 interface 중 오류가 발생했습니다.\n관리자에게 문의하세요");
						}
					}
				}
			}
			dataMaster.put("KEY_VALUE", keyValue);
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


	/**
	 * 대한통운(배송의뢰) 데이터 insert
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "z_wm")
	public List<Map<String, Object>> insertTrnOrder(Map param, LoginVO user, Map dataMaster) throws Exception {
		//20201218 추가: api 오류 메세지 받기 위해 추가
		String apiError = "";
		try {
			//20201221 수정: 배송방법 공통코드 값으로 변경하면서 관련로직 수정
			if("N".equals(param.get("OPR_FLAG")) && ("01".equals(param.get("DELIV_METHOD")) || "02".equals(param.get("DELIV_METHOD")) || "03".equals(param.get("DELIV_METHOD")))) {
				//전화번호 정제, 20201204 수정: 전화번호 없으면 핸드폰번호로, 핸드폰번호 없으면 전화번호로 대체해서 실행, 20210218 수정: 쇼핑몰에서는 전화번호가 없으면 --가 넘어옴 해당로직 수정 - .toString().replace("--", "") 추가
				String[] rTelNum1 = phoneNumberSplit((String) ObjUtils.nvl(param.get("TELEPHONE_NUM1").toString().replace("--", ""), param.get("TELEPHONE_NUM2")));
				String[] rTelNum2 = phoneNumberSplit((String) ObjUtils.nvl(param.get("TELEPHONE_NUM2").toString().replace("--", ""), param.get("TELEPHONE_NUM1")));
				param.put("TELEPHONE_NUM1_1", rTelNum1[0]);
				param.put("TELEPHONE_NUM1_2", rTelNum1[1]);
				param.put("TELEPHONE_NUM1_3", rTelNum1[2]);
				param.put("TELEPHONE_NUM2_1", rTelNum2[0]);
				param.put("TELEPHONE_NUM2_2", rTelNum2[1]);
				param.put("TELEPHONE_NUM2_3", rTelNum2[2]);

				//20210218 수정: 쇼핑몰에서는 전화번호가 없으면 --가 넘어옴 해당로직 수정 - .toString().replace("--", "")
				if(ObjUtils.isNotEmpty(ObjUtils.nvl(param.get("ORDER_TEL1").toString().replace("--", ""), param.get("ORDER_TEL2")))) {
					String[] oTelNum1 = phoneNumberSplit((String) ObjUtils.nvl(param.get("ORDER_TEL1").toString().replace("--", ""), param.get("ORDER_TEL2")));
					String[] oTelNum2 = phoneNumberSplit((String) ObjUtils.nvl(param.get("ORDER_TEL2").toString().replace("--", ""), param.get("ORDER_TEL1")));
					param.put("ORDER_TEL1_1"	, oTelNum1[0]);
					param.put("ORDER_TEL1_2"	, oTelNum1[1]);
					param.put("ORDER_TEL1_3"	, oTelNum1[2]);
					param.put("ORDER_TEL2_1"	, oTelNum2[0]);
					param.put("ORDER_TEL2_2"	, oTelNum2[1]);
					param.put("ORDER_TEL2_3"	, oTelNum2[2]);
				} else {
					//20210218 수정: 전화번호 없으면 "" 넘어가도록 수정
					param.put("ORDER_TEL1_1"	, "");
					param.put("ORDER_TEL1_2"	, "");
					param.put("ORDER_TEL1_3"	, "");
					param.put("ORDER_TEL2_1"	, "");
					param.put("ORDER_TEL2_2"	, "");
					param.put("ORDER_TEL2_3"	, "");
				}

				//운송장번호 채번
				//20210422 추가: 할당 받은 대역대 여부 체크로직 추가
				int chkLastSeq = (int) super.commonDao.queryForObject("s_srq100ukrv_wmServiceImpl.selectLastSeq", param);
				if(chkLastSeq >= 543190600) {					//최초할당 받은 대역 마지막 값 - 543190600
					apiError = "송장대역을 재할당 받아야 합니다. 관리자에게 문의하세요.";
					throw new UniDirectValidateException(apiError);
				}
				List<Map> dataList	= super.commonDao.list("s_srq100ukrv_wmServiceImpl.makeInvoiceNum", param);
				String invoiceNum	= (String) dataList.get(0).get("INVOICE_NUM");
				String invoiceNum2	= "";
				int i				= 0;

				//20210226 추가: && !"9999".equals(param.get("NUMBER"))
				//20210302 추가: TEST에서는 아래로직 수행하지 않도록 로직 추가, 20210303 추가: 수동입력의 경우 api 실행하지 않음 - "2324".equals(param.get("NUMBER"))로 변경
				if("2324".equals(param.get("NUMBER")) && dataMaster.get("CPATH").equals("/wm")) {
					//20210226 추가: play auto 출고지시로 상태 변경 - 출고등록(WM)에서 여기로 이동
					Map<String,Object> outStockOrderMap	= new HashMap();
					String url							= "https://openapi.playauto.io/api/order/instruction";
					String[] bundle_codes				= new String[] {(String) param.get("BUNDLE_NO")};
					Boolean auto_bundle					= false;
					outStockOrderMap.put("url"			, url);
					outStockOrderMap.put("bundle_codes"	, bundle_codes);
					outStockOrderMap.put("auto_bundle"	, auto_bundle);

/////////(참고) 운송장번호 중복으로 작업 시에 PLAY AUTO와 interface 생략하려면 여기 주석 처리하고 진행해야함
					apiError = S_api_wmService.updateAPIoutStockOrderStatus(outStockOrderMap, user);
					if(!"0".equals(apiError)) {
						if(!apiError.contains("e2009")) {
							throw new UniDirectValidateException(apiError);
						}
					}

					//play auto 운송장 정보 update - 주석: 주석 해제는 보류 테스트할 데이터가 없읍............................
					param.put("INVOICE_NUM", invoiceNum);
					apiError = S_api_wmService.updateAPITrsIvoiceNum(param, user);		//20201216 추가 - 채번된 송장번호 playauto 정보에 update, 20201218 수정: api 오류 메세지 받기 위해 추가
					if(!"0".equals(apiError)) {
						throw new UniDirectValidateException(apiError);
					}
/////////여기까지
				}

				for(Map param2: dataList) {
					//20210217 추가: 필수조건 '우편번호' 체크
					if(ObjUtils.isEmpty(param2.get("ZIP_CODE"))) {
						apiError = "발송인의 우편주소는 필수입력 입니다.";
						throw new UniDirectValidateException(apiError);
					}
					//20210219 추가: 필수조건 수신인 '우편번호' 체크로직 추가
					if(ObjUtils.isEmpty(param.get("ZIP_NUM"))) {
						apiError = "수신의 우편주소는 필수입력 입니다.";
						throw new UniDirectValidateException(apiError);
					}
					List<Map<String, Object>> paramList = new ArrayList();
					if(i == 0) {
						invoiceNum2 = (String) param2.get("INVOICE_NUM");
					} else {
						invoiceNum2 = invoiceNum2 + ',' + (String) param2.get("INVOICE_NUM");
					}
					param.put("ISSUE_REQ_NUM"		, param2.get("ISSUE_REQ_NUM"));
					param.put("ISSUE_REQ_DATE"		, param2.get("ISSUE_REQ_DATE"));
					param.put("INVOICE_NUM"			, param2.get("INVOICE_NUM"));
					param.put("SENDR_NM"			, param2.get("DIV_NAME"));
					param.put("SENDR_TEL_NO1"		, phoneNumberSplit((String) param2.get("TELEPHON"))[0]);
					param.put("SENDR_TEL_NO2"		, phoneNumberSplit((String) param2.get("TELEPHON"))[1]);
					param.put("SENDR_TEL_NO3"		, phoneNumberSplit((String) param2.get("TELEPHON"))[2]);
					param.put("SENDR_ZIP_NO"		, param2.get("ZIP_CODE"));
					param.put("SENDR_ADDR"			, addressSplit((String) param2.get("ADDR"))[0]);
					param.put("SENDR_DETAIL_ADDR"	, addressSplit((String) param2.get("ADDR"))[1]);
					param.put("RCVR_ADDR"			, addressSplit((String) param.get("ADDRESS1"))[0]);
					param.put("RCVR_DETAIL_ADDR"	, addressSplit((String) param.get("ADDRESS1"))[1]);
//					//20210114 추가: 우편번호 관련 체크로직 추가
					param.put("SENDR_ZIP_NO"		, ((String) param.get("SENDR_ZIP_NO")).replace("-", ""));
					param.put("ZIP_NUM"				, ((String) param.get("ZIP_NUM")).replace("-", ""));

					//20210303 수정: 임시테이블에 INSERT
					if(dataMaster.get("CPATH").equals("/wm")) {
						super.commonDao.update("s_srq100ukrv_wmServiceImpl.insertTrnOrder", param);
					}
					i = i + 1;
				}
				param.put("INVOICE_NUM"		, invoiceNum);
				param.put("INVOICE_NUM2"	, invoiceNum2);
			//20201230 추가: 신규 데이터 중, "택배배송이 아닌" 경우 송장번호에 오늘 날짜 등록
			} else if("N".equals(param.get("OPR_FLAG")) && (!"01".equals(param.get("DELIV_METHOD")) && !"02".equals(param.get("DELIV_METHOD"))
					&& !"03".equals(param.get("DELIV_METHOD"))&& !"90".equals(param.get("DELIV_METHOD")))) {		//20210624 추가: 묶음배송도 제외
				SimpleDateFormat sdf	= new SimpleDateFormat("yyyyMMdd");
				String datestr			= sdf.format(new Date());

				//20210319 추가: 택배배송 아닌 경우에도 playauto interface 로직 필요
				if("2324".equals(param.get("NUMBER")) && dataMaster.get("CPATH").equals("/wm")) {
					Map<String,Object> outStockOrderMap	= new HashMap();
					String url							= "https://openapi.playauto.io/api/order/instruction";
					String[] bundle_codes				= new String[] {(String) param.get("BUNDLE_NO")};
					Boolean auto_bundle					= false;
					outStockOrderMap.put("url"			, url);
					outStockOrderMap.put("bundle_codes"	, bundle_codes);
					outStockOrderMap.put("auto_bundle"	, auto_bundle);

/////////(참고) 운송장번호 중복으로 작업 시에 PLAY AUTO와 interface 생략하려면 여기 주석 처리하고 진행해야함
					apiError = S_api_wmService.updateAPIoutStockOrderStatus(outStockOrderMap, user);
					if(!"0".equals(apiError)) {
						if(!apiError.contains("e2009")) {
							throw new UniDirectValidateException(apiError);
						}
					}

					param.put("INVOICE_NUM", datestr);
					apiError = S_api_wmService.updateAPITrsIvoiceNum(param, user);
					if(!"0".equals(apiError)) {
						throw new UniDirectValidateException(apiError);
					}
/////////여기까지
				}
				param.put("INVOICE_NUM"	, datestr);
				param.put("INVOICE_NUM2", datestr);
			//20201230 추가: 송장번호 변경 시 playauto 정보 update
			} else if("U".equals(param.get("OPR_FLAG")) && ("01".equals(param.get("DELIV_METHOD")) || "02".equals(param.get("DELIV_METHOD")) || "03".equals(param.get("DELIV_METHOD")))) {
				//20210308 - 수정 시에도 택배배송일 경우 운송장 채번하는 로직 추가
				String invoiceNum	= (String) param.get("INVOICE_NUM");
				String invoiceNum2	= (String) param.get("INVOICE_NUM2");

				//전화번호 정제, 20201204 수정: 전화번호 없으면 핸드폰번호로, 핸드폰번호 없으면 전화번호로 대체해서 실행, 20210218 수정: 쇼핑몰에서는 전화번호가 없으면 --가 넘어옴 해당로직 수정 - .toString().replace("--", "") 추가
				String[] rTelNum1 = phoneNumberSplit((String) ObjUtils.nvl(param.get("TELEPHONE_NUM1").toString().replace("--", ""), param.get("TELEPHONE_NUM2")));
				String[] rTelNum2 = phoneNumberSplit((String) ObjUtils.nvl(param.get("TELEPHONE_NUM2").toString().replace("--", ""), param.get("TELEPHONE_NUM1")));
				param.put("TELEPHONE_NUM1_1", rTelNum1[0]);
				param.put("TELEPHONE_NUM1_2", rTelNum1[1]);
				param.put("TELEPHONE_NUM1_3", rTelNum1[2]);
				param.put("TELEPHONE_NUM2_1", rTelNum2[0]);
				param.put("TELEPHONE_NUM2_2", rTelNum2[1]);
				param.put("TELEPHONE_NUM2_3", rTelNum2[2]);

				//20210218 수정: 쇼핑몰에서는 전화번호가 없으면 --가 넘어옴 해당로직 수정 - .toString().replace("--", "")
				if(ObjUtils.isNotEmpty(ObjUtils.nvl(param.get("ORDER_TEL1").toString().replace("--", ""), param.get("ORDER_TEL2")))) {
					String[] oTelNum1 = phoneNumberSplit((String) ObjUtils.nvl(param.get("ORDER_TEL1").toString().replace("--", ""), param.get("ORDER_TEL2")));
					String[] oTelNum2 = phoneNumberSplit((String) ObjUtils.nvl(param.get("ORDER_TEL2").toString().replace("--", ""), param.get("ORDER_TEL1")));
					param.put("ORDER_TEL1_1"	, oTelNum1[0]);
					param.put("ORDER_TEL1_2"	, oTelNum1[1]);
					param.put("ORDER_TEL1_3"	, oTelNum1[2]);
					param.put("ORDER_TEL2_1"	, oTelNum2[0]);
					param.put("ORDER_TEL2_2"	, oTelNum2[1]);
					param.put("ORDER_TEL2_3"	, oTelNum2[2]);
				} else {
					//20210218 수정: 전화번호 없으면 "" 넘어가도록 수정
					param.put("ORDER_TEL1_1"	, "");
					param.put("ORDER_TEL1_2"	, "");
					param.put("ORDER_TEL1_3"	, "");
					param.put("ORDER_TEL2_1"	, "");
					param.put("ORDER_TEL2_2"	, "");
					param.put("ORDER_TEL2_3"	, "");
				}

				List<Map> dataList;
				if(invoiceNum.length() <= 8) {
					//운송장번호 채번
					//20210422 추가: 할당 받은 대역대 여부 체크로직 추가
					int chkLastSeq = (int) super.commonDao.queryForObject("s_srq100ukrv_wmServiceImpl.selectLastSeq", param);
					if(chkLastSeq >= 543190600) {					//최초할당 받은 대역 마지막 값 - 543190600
						apiError = "송장대역을 재할당 받아야 합니다. 관리자에게 문의하세요.";
						throw new UniDirectValidateException(apiError);
					}
					dataList = super.commonDao.list("s_srq100ukrv_wmServiceImpl.makeInvoiceNum", param);
					invoiceNum	= (String) dataList.get(0).get("INVOICE_NUM");
					invoiceNum2	= "";
				} else {
					//운송장번호 보내는 정보만 가져옴
					dataList = super.commonDao.list("s_srq100ukrv_wmServiceImpl.makeInvoiceNum2", param);
				}
				int i = 0;

				for(Map param2: dataList) {
					//20210217 추가: 필수조건 '우편번호' 체크
					if(ObjUtils.isEmpty(param2.get("ZIP_CODE"))) {
						apiError = "발송인의 우편주소는 필수입력 입니다.";
						throw new UniDirectValidateException(apiError);
					}
					//20210219 추가: 필수조건 수신인 '우편번호' 체크로직 추가
					if(ObjUtils.isEmpty(param.get("ZIP_NUM"))) {
						apiError = "수신의 우편주소는 필수입력 입니다.";
						throw new UniDirectValidateException(apiError);
					}
					List<Map<String, Object>> paramList = new ArrayList();
					if(i == 0) {
						invoiceNum2 = (String) param2.get("INVOICE_NUM");
					} else {
						invoiceNum2 = invoiceNum2 + ',' + (String) param2.get("INVOICE_NUM");
					}
					param.put("ISSUE_REQ_NUM"		, param2.get("ISSUE_REQ_NUM"));
					param.put("ISSUE_REQ_DATE"		, param2.get("ISSUE_REQ_DATE"));
					param.put("INVOICE_NUM"			, param2.get("INVOICE_NUM"));
					param.put("SENDR_NM"			, param2.get("DIV_NAME"));
					param.put("SENDR_TEL_NO1"		, phoneNumberSplit((String) param2.get("TELEPHON"))[0]);
					param.put("SENDR_TEL_NO2"		, phoneNumberSplit((String) param2.get("TELEPHON"))[1]);
					param.put("SENDR_TEL_NO3"		, phoneNumberSplit((String) param2.get("TELEPHON"))[2]);
					param.put("SENDR_ZIP_NO"		, param2.get("ZIP_CODE"));
					param.put("SENDR_ADDR"			, addressSplit((String) param2.get("ADDR"))[0]);
					param.put("SENDR_DETAIL_ADDR"	, addressSplit((String) param2.get("ADDR"))[1]);
					param.put("RCVR_ADDR"			, addressSplit((String) param.get("ADDRESS1"))[0]);
					param.put("RCVR_DETAIL_ADDR"	, addressSplit((String) param.get("ADDRESS1"))[1]);
					//20210114 추가: 우편번호 관련 체크로직 추가
					param.put("SENDR_ZIP_NO"		, ((String) param.get("SENDR_ZIP_NO")).replace("-", ""));
					param.put("ZIP_NUM"				, ((String) param.get("ZIP_NUM")).replace("-", ""));

					//20210303 수정: 임시테이블에 INSERT
					if(dataMaster.get("CPATH").equals("/wm")) {
						super.commonDao.update("s_srq100ukrv_wmServiceImpl.insertTrnOrder", param);
					}
					i = i + 1;
				}

				//20210226 추가: && !"9999".equals(param.get("NUMBER"))
				//20210302 추가: TEST에서는 아래로직 수행하지 않도록 로직 추가, 20210303 추가: 수동입력의 경우 api 실행하지 않음 - "2324".equals(param.get("NUMBER"))로 변경
				if("2324".equals(param.get("NUMBER")) && dataMaster.get("CPATH").equals("/wm")) {
					//20210226 추가: play auto 출고지시로 상태 변경 - 출고등록(WM)에서 여기로 이동
					Map<String,Object> outStockOrderMap	= new HashMap();
					String url							= "https://openapi.playauto.io/api/order/instruction";
					String[] bundle_codes				= new String[] {(String) param.get("BUNDLE_NO")};
					Boolean auto_bundle					= false;
					outStockOrderMap.put("url"			, url);
					outStockOrderMap.put("bundle_codes"	, bundle_codes);
					outStockOrderMap.put("auto_bundle"	, auto_bundle);

					apiError = S_api_wmService.updateAPIoutStockOrderStatus(outStockOrderMap, user);
					if(!"0".equals(apiError)) {
						if(!apiError.contains("e2009")) {
							throw new UniDirectValidateException(apiError);
						}
					}

					//play auto 운송장 정보 update - 주석: 주석 해제는 보류 테스트할 데이터가 없읍............................
					param.put("INVOICE_NUM", invoiceNum);
					apiError = S_api_wmService.updateAPITrsIvoiceNum(param, user);		//20201216 추가 - 채번된 송장번호 playauto 정보에 update, 20201218 수정: api 오류 메세지 받기 위해 추가
					if(!"0".equals(apiError)) {
						throw new UniDirectValidateException(apiError);
					}
				}
				param.put("INVOICE_NUM"		, invoiceNum);
				param.put("INVOICE_NUM2"	, invoiceNum2);
			} else if("D".equals(param.get("OPR_FLAG"))) {
				param.put("INVOICE_NUM"		, "");
				param.put("INVOICE_NUM2"	, "");
			}
			//SOF110T.INVOICE_NUM, INVOICE_NUM2 정보 update, 20201229 수정: 위치 이동 / mothod 호출로 변경
			this.updateSof110t_invoiceNum(param);

			//삭제가 아니고, NUMBER(SOL_NO)가 '99999'(쇼핑몰 데이터)인 데이터는 IF_ORDER_LIST_PUT에 insert, 20210111 수정: "99999" -> "9999"
			if(!"D".equals(param.get("OPR_FLAG")) && "9999".equals(param.get("NUMBER"))) {
				this.insertIfOrderListPut(param);
			}
		} catch(Exception e) {
			//20201218 수정: interface, api 오류 메세지 구분 위해 추가, 20210218 체크로직 추가: && ObjUtils.isNotEmpty(apiError)
			if(!"0".equals(apiError) && ObjUtils.isNotEmpty(apiError)) {
				throw new UniDirectValidateException(apiError);
			} else {
				throw new UniDirectValidateException("택배 interface 중 오류가 발생했습니다.");
			}
		}
		return null;
	}

	/**
	 * 주소 정제
	 * @param phoneNumber
	 * @return
	 * @throws Exception
	 */
	public static String[] addressSplit(String address) throws Exception{
		String[] array	= address.split(" ");
		String str1		= "";
		String str2		= "";
		if(array.length >= 4) {					//20210303 로직 수정
			for(int i=0; i<array.length; i++) {
				if(i == 0) {
					str1 = array[i];
				} else if(i > 0 && i <= 2) {
					str1 = str1 + " " + array[i];
				} else {
					str2 = str2 + " " + array[i];
				}
			}
		} else {
			for(int i=0; i<array.length; i++) {
				if(i == 0) {
					str1 = array[i];
				} else {
					str2 = str2 + " "  + array[i];
				}
			}
		}
		return new String[]{str1, str2};
	}

	/**
	 * 전화번호 정제
	 * @param phoneNumber
	 * @return
	 * @throws Exception
	 */
	public static String[] phoneNumberSplit(String phoneNumber) throws Exception{
		//20210218 수정: 안심번호 관련 데이터 추가 - 0503, 0504, 0507, 0508
//		Pattern tellPattern = Pattern.compile("^(01\\d{1}|02|0505|0502|0506|0\\d{1,2})-?(\\d{3,4})-?(\\d{4})");
		Pattern tellPattern = Pattern.compile("^(01\\d{1}|02|0502|0503|0504|0505|0506|0507|0508|0\\d{1,2})-?(\\d{3,4})-?(\\d{4})");
		Matcher matcher = tellPattern.matcher(phoneNumber);
		if(matcher.matches()) {
			//정규식에 적합하면 matcher.group으로 리턴
			return new String[]{ matcher.group(1), matcher.group(2), matcher.group(3)};
		}else{
			//20210218 수정: 전화번호 없으면 "" 넘어가도록 수정
			if(phoneNumber.equals("--")) {
				String str1 = "";
				String str2 = "";
				String str3 = "";
				return new String[]{str1, str2, str3};
			} else {
				//정규식에 적합하지 않으면 substring으로 휴대폰 번호 나누기
				String str1 = phoneNumber.substring(0, 3);
				String str2 = phoneNumber.substring(3, 7);
				String str3 = phoneNumber.substring(7, 11);
				return new String[]{str1, str2, str3};
			}
		}
	}


	/**
	 * sof110t에 invoice_num update: 20201229 추가 - mothod 호출로 변경
	 * @param paramList
	 * @param user
	 * @param paramMaster
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_wm")
	public void updateSof110t_invoiceNum(Map param) throws Exception {
		//20210624 추가: 묶음배송의 경우, BUNDLE_NO가 같고 택배배송(01, 02, 03)인 데이터의 운송장 번호로 update
		if("90".equals(param.get("DELIV_METHOD"))) {
			super.commonDao.update("s_srq100ukrv_wmServiceImpl.updateSof110t_invoiceNum2", param);
		} else {
			super.commonDao.update("s_srq100ukrv_wmServiceImpl.updateSof110t_invoiceNum", param);
		}
		return;
	}

	/**
	 * IF_ORDER_LIST_PUT에 insert: 20201229 추가 - 쇼핑몰 데이터(NUMBER(SOL_NO) = '99999')인 경우
	 * @param paramList
	 * @param user
	 * @param paramMaster
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_wm")
	public void insertIfOrderListPut(Map param) throws Exception {
		super.commonDao.update("s_srq100ukrv_wmServiceImpl.insertIfOrderListPut", param);
		return;
	}





	/**
	 * 출하지시서 출력 - 20201223 추가
	 * @param paramList
	 * @param user
	 * @param paramMaster
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "z_wm", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> orderReqMPrintList(Map param) throws Exception {
		return super.commonDao.list("s_srq100ukrv_wmServiceImpl.orderReqMPrintList", param);
	}

	@ExtDirectMethod(group = "z_wm", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> orderReqPrintList(Map param) throws Exception {
		return super.commonDao.list("s_srq100ukrv_wmServiceImpl.orderReqPrintList", param);
	}



	/**
	 * 운송장 출력 - 20201223 추가
	 * @param paramList
	 * @param user
	 * @param paramMaster
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "z_wm", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> getData(Map param) throws Exception {
		return super.commonDao.list("s_srq100ukrv_wmServiceImpl.getData", param);
	}

	@ExtDirectMethod(group = "z_wm", value = ExtDirectMethodType.STORE_READ)
	public Map<String, Object> printCarriageBillData(Map param) throws Exception {
		return extDaoJuso.procExec("s_srq100ukrv_wmServiceImpl.printCarriageBillData", param);
	}




	/**
	 * 출하지시서 출력 후, 상태값 변경(SRQ100T.PRINT_YN) - 20210208 추가
	 * @param params
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "z_wm", value = ExtDirectMethodType.STORE_MODIFY)
	public int updatePrintStatus(Map param, LoginVO user) throws Exception {
		String[] orderReqInfoArry	= param.get("orderReqInfo").toString().split(",");
		List<Map> orderReqInfoList	= new ArrayList<Map>();

		for(int i=0; i<ObjUtils.parseInt(param.get("dataCount")); i++) {
			Map map = new HashMap();
			map.put("ORDER_REQ_INFO", orderReqInfoArry[i]);
			orderReqInfoList.add(map);
		}
		param.put("ORDER_REQ_LIST", orderReqInfoList);
		super.commonDao.update("s_srq100ukrv_wmServiceImpl.updatePrintStatus", param);
		return 0;
	}


	/**
	 * 주소 정제 test
	 * @param phoneNumber
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "z_wm")
	public static String[] addressSplit2(String address) throws Exception{
		String[] array	= address.split(" ");
		String str1		= "";
		String str2		= "";
		if(array.length >= 4) {
			for(int i=0; i<array.length; i++) {
				if(i == 0) {
					str1 = array[i];
				} else if(i > 0 && i <= 2) {
					str1 = str1 + " " + array[i];
				} else {
					str2 = str2 + " " + array[i];
				}
			}
		} else {
			for(int i=0; i<array.length; i++) {
				if(i == 0) {
					str1 = array[i];
				} else {
					str2 = str2 + " "  + array[i];
				}
			}
		}
		return new String[]{str1, str2};
	}


	/**
	 * 20210310 추가: 수동 cj interface
	 * @param phoneNumber
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "z_wm")
	public String CJ_interface(Map params) throws Exception{
		List<Map> CarriageBillData	= super.commonDao.list("s_srq100ukrv_wmServiceImpl.CJ_interface", params);
		if(CarriageBillData.size() > 0) {
			for(Map param: CarriageBillData) {
				List<Map<String, Object>> CarriageList	= new ArrayList();
				CarriageList.add(param);
				Object interfaceMsg = extDao.update("s_srq100ukrv_wmServiceImpl.insertTrnOrder_confirm", CarriageList);
				if(!"0".equals(interfaceMsg)) {
//					throw new UniDirectValidateException("대한통운 interface 중 오류가 발생했습니다.\n" + interfaceMsg);
				}
			}
		}
		return "";
	}




	/**
	 * 2020617 추가: 선택된 데이터만 엑셀 다운로드 하는 기능을 구현하기 위해 추가(사용 안 함 - 공통 프로세스로직 사용하도록 변경)
	 * @param paramList
	 * @param user
	 * @param paramMaster
	 * @return
	 * @throws Exception
	 */
/*	public Workbook makeExcel( Map param ) throws Exception {
		Workbook workbook	= new XSSFWorkbook();
		Sheet sheet			= workbook.createSheet("Sheet1");
		DataFormat formet	= workbook.createDataFormat();
		Row headerRow		= null;
		Row row				= null;
		//폰트 설정
		Font Font			= workbook.createFont();
		Font.setFontHeightInPoints((short)10);
		Font.setFontName("맑은 고딕");

		//Style00: 기본
		CellStyle style00 = workbook.createCellStyle();
		style00.setBorderTop(CellStyle.BORDER_THIN);
		style00.setBorderBottom(CellStyle.BORDER_THIN);
		style00.setBorderLeft(CellStyle.BORDER_THIN);
		style00.setBorderRight(CellStyle.BORDER_THIN);
		style00.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
		style00.setDataFormat(formet.getFormat("@"));			//cell서식을 text로 설정
		style00.setFont(Font);

		//Style01: 중앙정렬
		CellStyle style01 = workbook.createCellStyle();
		style01.setBorderTop(CellStyle.BORDER_THIN);
		style01.setBorderBottom(CellStyle.BORDER_THIN);
		style01.setBorderLeft(CellStyle.BORDER_THIN);
		style01.setBorderRight(CellStyle.BORDER_THIN);
		style01.setAlignment(CellStyle.ALIGN_CENTER);
		style01.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
		style01.setFont(Font);

		//Style03: 숫자
		CellStyle style02 = workbook.createCellStyle();
		style02.setBorderTop(CellStyle.BORDER_THIN);
		style02.setBorderBottom(CellStyle.BORDER_THIN);
		style02.setBorderLeft(CellStyle.BORDER_THIN);
		style02.setBorderRight(CellStyle.BORDER_THIN);
		style02.setAlignment(CellStyle.ALIGN_RIGHT);
		style02.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
		style02.setDataFormat(formet.getFormat("#,##0"));		//기본포맷
		style02.setFont(Font);

		String[] columnCodeArry = param.get("columnCode").toString().split(",");	//컬럼 변수명: 데이터 가져올 때 사용
		String[] columnNameArry = param.get("columnName").toString().split(",");	//컬럼명: 엑셀파일에 컬럼명 설정
		String[] columnSizeArry = param.get("columnSize").toString().split(",");	//컬럼 넓이: 엑셀파일에 컬럼 넓이 설정
		String[] columnSortArry = param.get("columnSort").toString().split(",");	//컬럼 정렬: 정렬에 따라 엑셀파일 컬럼 속성 결정
		String[] columnFomtArry = param.get("columnFomt").toString().split("/");	//컬럼 형식: 숫자포맷의 표시 형식

		//컬럼 헤더 관련 로직
		headerRow = sheet.createRow(0);
		for(int i = 0; i < ObjUtils.parseInt(param.get("columnCount")); i++){
			headerRow.createCell(i);
			headerRow.getCell(i).setCellStyle(style01);
			sheet.setColumnWidth(i, ObjUtils.parseInt(columnSizeArry[i]) * 33);
			headerRow.getCell(i).setCellValue(columnNameArry[i].toString());
		}

		//데이터 가져오는 로직
		String[] orderInfoArry	= param.get("orderInfo").toString().split(",");
		List<Map> orderInfoList	= new ArrayList<Map>();
		for(int i=0; i<ObjUtils.parseInt(param.get("dataCount")); i++){
			Map map = new HashMap();
			map.put("COMP_CODE"	, param.get("S_COMP_CODE"));
			map.put("DIV_CODE"	, param.get("DIV_CODE"));
			map.put("ORDER_INFO", orderInfoArry[i]);
			orderInfoList.add(map);
		}
		param.put("ORDER_LIST"	, orderInfoList);
		List<Map> list1 = super.commonDao.list("s_srq100ukrv_wmServiceImpl.makeExcel", param);

		//가져온 데이터 엑셀에 set하는 로직
		for(int j = 0; j < list1.size(); j++) {
			row = sheet.createRow(j+1);
			for(int i = 0; i < ObjUtils.parseInt(param.get("columnCount")); i++){
				row.createCell(i);
				//cell data input
				Object inputValue = list1.get(j).get(columnCodeArry[i]);
				//cell style 설정
				if(!"undefined".equals(columnFomtArry[i]) && ObjUtils.isNotEmpty(columnFomtArry[i])) {		//숫자포맷이 존재할 경우
					String part1 = columnFomtArry[i].toString().substring(0, 4).replace("0", "#");			//넘어온 숫자의 포맷을 엑셀숫자 포맷 형식에 맞게 변경
					String part2 = columnFomtArry[i].toString().substring(4);
					//포맷에 맞게 데이터 변환
					DecimalFormat df = new DecimalFormat(part1 + part2);
					inputValue = df.format(inputValue);

					if(columnFomtArry[i].length() != 5) {							//숫자포맷이 존재할 경우 해당 숫자형식 cell에 적용하기 위한 로직(정렬보다 숫자포맷 존재여부 부터 체크)
						CellStyle style_ext = workbook.createCellStyle();
						style_ext.setDataFormat(formet.getFormat(part1 + part2));
						style_ext.setBorderTop(CellStyle.BORDER_THIN);
						style_ext.setBorderBottom(CellStyle.BORDER_THIN);
						style_ext.setBorderLeft(CellStyle.BORDER_THIN);
						style_ext.setBorderRight(CellStyle.BORDER_THIN);
						style_ext.setAlignment(CellStyle.ALIGN_CENTER);
						style_ext.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
						style_ext.setFont(Font);
						row.getCell(i).setCellStyle(style_ext);
					} else {
						row.getCell(i).setCellStyle(style02);
					}
				} else if("center".equals(columnSortArry[i].toString())) {			//가운데 정렬
					row.getCell(i).setCellStyle(style01);
				} else if("right".equals(columnSortArry[i].toString())) {			//오른쪽 정렬(숫자포맷 없는 경우)
					row.getCell(i).setCellStyle(style02);
				} else {															//왼쪽 정렬
					row.getCell(i).setCellStyle(style00);
				}
				if(ObjUtils.isEmpty(inputValue)) {
					inputValue = "";
				}
				row.getCell(i).setCellValue(inputValue.toString());
//				HSSFFormulaEvaluator.evaluateAllFormulaCells(workbook);				//엑셀의 계산식 사용
			}
		}
		return workbook;
	}*/
}