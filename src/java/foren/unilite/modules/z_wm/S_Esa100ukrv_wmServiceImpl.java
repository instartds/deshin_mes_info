package foren.unilite.modules.z_wm;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

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

import com.google.gson.Gson;

import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;

@Service("s_esa100ukrv_wmService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class S_Esa100ukrv_wmServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	//20210118 추가: CJ대한통운 interface 위해 추가
	@Resource(name = "externalDAO_WM")
	protected ExternalDAO_WM extDao;

	//20210118 추가: CJ대한통운 주소정제 데이터 가져오기 위해 추가
	@Resource(name = "externalDAO_JUSO_WM")
	protected ExternalDAO_JUSO_WM extDaoJuso;



	/**
	 * 거래처 정보 가져오는 로직
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_wm")
	public List<Map> getCustomInfo(Map param) throws Exception{
		return super.commonDao.list("s_esa100ukrv_wmServiceImpl.getCustomInfo", param);
	}

	/**
	 * 수주정보(팝업) 가져오는 로직
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_wm")
	public List<Map> selectOrderNumDetailList(Map param) throws Exception{
		return super.commonDao.list("s_esa100ukrv_wmServiceImpl.selectOrderNumDetailList", param);
	}

	/**
	 * 검색팝업 조회 쿼리
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_wm")
	public List<Map> searchPopupList(Map param) throws Exception{
		return super.commonDao.list("s_esa100ukrv_wmServiceImpl.searchPopupList", param);
	}



	/**
	 * masterForm 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "z_wm", value = ExtDirectMethodType.FORM_LOAD)
	public Object selectForm(Map param) throws Exception {
		return super.commonDao.select("s_esa100ukrv_wmServiceImpl.selectMaster", param);
	}

	/**
	 * 상담내역(S_EAS130T_WM) 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_wm")
	public List<Map> selectOutLineList(Map param) throws Exception{
		return super.commonDao.list("s_esa100ukrv_wmServiceImpl.selectOutLineList", param);
	}

	/**
	 * detailGrid 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_wm")
	public List<Map> selectList(Map param) throws Exception{
		return super.commonDao.list("s_esa100ukrv_wmServiceImpl.selectList", param);
	}

	/**
	 * detailGrid2 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_wm")
	public List<Map> selectList2(Map param) throws Exception{
		return super.commonDao.list("s_esa100ukrv_wmServiceImpl.selectList2", param);
	}





	/**
	 * masterForm 저장
	 * @param dataMaster
	 * @param user
	 * @param result
	 * @return
	 * @throws Exception
	 */
//	@ExtDirectMethod(group = "z_wm", value = ExtDirectMethodType.FORM_LOAD)
//	public Object checkFinishData(Map param) throws Exception {
//		return super.commonDao.select("s_esa100ukrv_wmServiceImpl.checkFinishData", param);
//	}

	@ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "z_wm")
	public ExtDirectFormPostResult syncForm(S_Esa100ukrv_wmModel dataMaster,  LoginVO user,  BindingResult result) throws Exception {
		dataMaster.setS_COMP_CODE(user.getCompCode());
		dataMaster.setS_USER_ID(user.getUserID());
		if(ObjUtils.isEmpty(dataMaster.getAS_NUM())) {
			dataMaster.setAS_NUM((String) super.commonDao.select("s_esa100ukrv_wmServiceImpl.getAutoNumComp", dataMaster));
			super.commonDao.update("s_esa100ukrv_wmServiceImpl.insertMaster"			, dataMaster);
			super.commonDao.update("s_esa100ukrv_wmServiceImpl.insertOutLineList"		, dataMaster);	//상담이력 데이터 insert
		} else {
			if("Y".equals(dataMaster.getDELETE_ALL())) {
				super.commonDao.update("s_esa100ukrv_wmServiceImpl.deleteMaster"		, dataMaster);
				super.commonDao.update("s_esa100ukrv_wmServiceImpl.deleteOutLineList"	, dataMaster);	//상담이력 데이터 삭제
				super.commonDao.update("s_esa100ukrv_wmServiceImpl.deleteDetail"		, dataMaster);	//고객주문정보(S_EAS110T)WM 삭제
				super.commonDao.update("s_esa100ukrv_wmServiceImpl.deleteDetail2"		, dataMaster);	//AS 주문옵션정보
			} else {
				super.commonDao.update("s_esa100ukrv_wmServiceImpl.updateMaster"		, dataMaster);
				super.commonDao.update("s_esa100ukrv_wmServiceImpl.updateOutLineList"	, dataMaster);	//상담이력 데이터 변경
			}
		}
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
		extResult.addResultProperty("resultData", dataMaster);
		return extResult;
	}



	/**
	 * detail(고객주문정보) 저장
	 * @param paramList
	 * @param paramMaster
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "z_wm")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		if(paramList != null) {
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteDetail")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insertDetail")) {
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("updateDetail")) {
					updateList = (List<Map>)dataListMap.get("data");
				}
			}
			if(deleteList != null) this.deleteDetail(deleteList, user);
			if(insertList != null) this.insertDetail(insertList, user, dataMaster);
			if(updateList != null) this.updateDetail(updateList, user);
		}
		paramList.add(0, paramMaster);
		return paramList;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_wm")
	public void insertDetail(List<Map> paramList, LoginVO user, Map dataMaster) throws Exception {
		for(Map param : paramList) {
			param.put("AS_NUM", dataMaster.get("AS_NUM"));
			super.commonDao.insert("s_esa100ukrv_wmServiceImpl.insertDetail", param);
		}
		return;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_wm")
	public void updateDetail(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param :paramList )  {
			super.commonDao.update("s_esa100ukrv_wmServiceImpl.updateDetail", param);
		}
		return;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_wm")
	public void deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {
		for(Map param :paramList ) {
			super.commonDao.delete("s_esa100ukrv_wmServiceImpl.deleteDetail", param);
		}
		return;
	}



	/**
	 * detail2(주문옵션정보) 저장
	 * @param paramList
	 * @param paramMaster
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "z_wm")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll2(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		if(paramList != null) {
			List<Map> insertList2 = null;
			List<Map> updateList2 = null;
			List<Map> deleteList2 = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteDetail2")) {
					deleteList2 = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insertDetail2")) {
					insertList2 = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("updateDetail2")) {
					updateList2 = (List<Map>)dataListMap.get("data");
				}
			}
			if(deleteList2 != null) this.deleteDetail2(deleteList2, user);
			if(insertList2 != null) this.insertDetail2(insertList2, user, dataMaster);
			if(updateList2 != null) this.updateDetail2(updateList2, user);
		}
		paramList.add(0, paramMaster);
		return paramList;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_wm")
	public void insertDetail2(List<Map> paramList, LoginVO user, Map dataMaster) throws Exception {
		for(Map param : paramList ) {
			param.put("AS_NUM", dataMaster.get("AS_NUM"));
			super.commonDao.insert("s_esa100ukrv_wmServiceImpl.insertDetail2", param);
		}
		return;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_wm")
	public void updateDetail2(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param :paramList )  {
			super.commonDao.update("s_esa100ukrv_wmServiceImpl.updateDetail2", param);
		}
		return;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_wm")
	public void deleteDetail2(List<Map> paramList,  LoginVO user) throws Exception {
		for(Map param :paramList ) {
			super.commonDao.delete("s_esa100ukrv_wmServiceImpl.deleteDetail2", param);
		}
		return;
	}



	/**
	 * 대한통운(배송의뢰) 데이터 insert - 20210118 추가
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "z_wm")
	public String insertTrnOrder(Map param, LoginVO user) throws Exception {
		//20210217 추가: 필수조건 '우편번호' 체크
		String apiError = "";
		try {
			//전화번호 정제, 전화번호 없으면 핸드폰번호로, 핸드폰번호 없으면 전화번호로 대체해서 실행, 20210218 수정: 쇼핑몰에서는 전화번호가 없으면 --가 넘어옴 해당로직 수정 - .toString().replace("--", "") 추가
			String[] rTelNum1 = phoneNumberSplit((String) ObjUtils.nvl(param.get("PHONE").toString().replace("--", ""), param.get("HPHONE")));
			String[] rTelNum2 = phoneNumberSplit((String) ObjUtils.nvl(param.get("HPHONE").toString().replace("--", ""), param.get("PHONE")));
			param.put("TELEPHONE_NUM1_1", rTelNum1[0]);
			param.put("TELEPHONE_NUM1_2", rTelNum1[1]);
			param.put("TELEPHONE_NUM1_3", rTelNum1[2]);
			param.put("TELEPHONE_NUM2_1", rTelNum2[0]);
			param.put("TELEPHONE_NUM2_2", rTelNum2[1]);
			param.put("TELEPHONE_NUM2_3", rTelNum2[2]);

			//운송장번호 채번
			//20210422 추가: 할당 받은 대역대 여부 체크로직 추가
			int chkLastSeq = (int) super.commonDao.queryForObject("s_srq100ukrv_wmServiceImpl.selectLastSeq", param);
			if(chkLastSeq >= 543190600) {					//최초할당 받은 대역 마지막 값 - 543190600
				apiError = "송장대역을 재할당 받아야 합니다. 관리자에게 문의하세요.";
				throw new UniDirectValidateException(apiError);
			}
			List<Map> dataList	= super.commonDao.list("s_esa100ukrv_wmServiceImpl.makeInvoiceNum", param);
			String invoiceNum	= (String) dataList.get(0).get("INVOICE_NUM");
			String invoiceNum2	= "";
			int i				= 0;

			for(Map param2: dataList) {
				//20210217 추가: 필수조건 '우편번호' 체크
				if(ObjUtils.isEmpty(param2.get("ZIP_CODE"))) {
					apiError = "발송인의 우편주소는 필수입력 입니다.";
					throw new UniDirectValidateException(apiError);
				}
				List<Map<String, Object>> paramList = new ArrayList();
				if(i == 0) {
					invoiceNum2 = (String) param2.get("INVOICE_NUM");
				} else {
					invoiceNum2 = invoiceNum2 + ',' + (String) param2.get("INVOICE_NUM");
				}
				param.put("AS_NUM"				, param2.get("AS_NUM"));
				param.put("AS_DATE"				, param2.get("AS_DATE"));
				if((boolean) param.get("InvoiceYn")) {		//20210218: 운송장 출력일 경우에만 신규 invoice_num 입력
					param.put("INVOICE_NUM"		, param2.get("INVOICE_NUM"));
				}
				param.put("SENDR_NM"			, param2.get("DIV_NAME"));
				param.put("SENDR_TEL_NO1"		, phoneNumberSplit((String) param2.get("TELEPHON"))[0]);
				param.put("SENDR_TEL_NO2"		, phoneNumberSplit((String) param2.get("TELEPHON"))[1]);
				param.put("SENDR_TEL_NO3"		, phoneNumberSplit((String) param2.get("TELEPHON"))[2]);
				param.put("SENDR_ZIP_NO"		, param2.get("ZIP_CODE"));
				param.put("SENDR_ADDR"			, addressSplit((String) param2.get("ADDR"))[0]);
				param.put("SENDR_DETAIL_ADDR"	, addressSplit((String) param2.get("ADDR"))[1]);
				param.put("RCVR_ADDR"			, addressSplit((String) param.get("ADDR1") + (String) param.get("ADDR2"))[0]);
				param.put("RCVR_DETAIL_ADDR"	, addressSplit((String) param.get("ADDR1") + (String) param.get("ADDR2"))[1]);
				//우편번호 확인 / '-' 제거
				if(ObjUtils.isEmpty(param.get("SENDR_ZIP_NO"))) {
					return "발송자의 우편번호는 필수 입력 입니다. 사업장 정보를 확인하세요";
				}
				param.put("SENDR_ZIP_NO"		, ((String) param.get("SENDR_ZIP_NO")).replace("-", ""));
				param.put("ZIP_NUM"				, ((String) param.get("ZIP_CODE")).replace("-", ""));
				paramList.add(param);

				//20210218 추가: 에러메세지 표시하도록 로직 추가
				//20210302 추가: TEST에서는 아래로직 수행하지 않도록 로직 추가
				if(param.get("CPATH").equals("/wm")) {
					if((boolean) param.get("InvoiceYn")) {		//운송장 출력일 경우
//						extDao.update("s_esa100ukrv_wmServiceImpl.insertTrnOrder", paramList);
						if(ObjUtils.isEmpty(extDao.update("s_esa100ukrv_wmServiceImpl.insertTrnOrder", paramList))) {
							apiError = "interface 필수정보를 확인하세요.";
							throw new UniDirectValidateException(apiError);
						}
					} else {									//반송요청일 경우
//						extDao.update("s_esa100ukrv_wmServiceImpl.insertTrnOrder2", paramList);
						if(ObjUtils.isEmpty(extDao.update("s_esa100ukrv_wmServiceImpl.insertTrnOrder2", paramList))) {
							apiError = "interface 필수정보를 확인하세요.";
							throw new UniDirectValidateException(apiError);
						}
					}
				}
				i = i + 1;
			}
			if((boolean) param.get("InvoiceYn")) {		//20210218: 운송장 출력일 경우에만 신규 invoice_num 입력
				param.put("INVOICE_NUM"		, invoiceNum);
				param.put("INVOICE_NUM2"	, invoiceNum2);
	
				this.updateSEas110t_WM_invoiceNum(param);
			}
		} catch(Exception e) {
			//20210217 수정: interface, 필수체크 오류 메세지 구분 위해 추가
			if(ObjUtils.isNotEmpty(apiError)) {
				throw new UniDirectValidateException(apiError);
			} else {
				throw new UniDirectValidateException("택배 interface 중 오류가 발생했습니다.");
			}
		}
		return "success";		//20210217 수정: jsp exception처리 위해서 return 값 null -> success로 변경
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
		if(array.length > 4) {
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
	 * S_EAS110T_WM에 invoice_num update: 20210118 추가
	 * @param paramList
	 * @param user
	 * @param paramMaster
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_wm")
	public void updateSEas110t_WM_invoiceNum(Map param) throws Exception {
		super.commonDao.update("s_esa100ukrv_wmServiceImpl.updateSEas110t_WM_invoiceNum", param);
		return;
	}



	/**
	 * 운송장 출력 - 20210119 추가
	 * @param paramList
	 * @param user
	 * @param paramMaster
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "z_wm", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> getData(Map param) throws Exception {
		return super.commonDao.list("s_esa100ukrv_wmServiceImpl.getData", param);
	}

	@ExtDirectMethod(group = "z_wm", value = ExtDirectMethodType.STORE_READ)
	public Map<String, Object> printCarriageBillData(Map param) throws Exception {
		return extDaoJuso.procExec("s_esa100ukrv_wmServiceImpl.printCarriageBillData", param);
	}
}