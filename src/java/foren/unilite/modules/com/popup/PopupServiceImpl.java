package foren.unilite.modules.com.popup;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.lib.tree.GenericTreeDataMap;
import foren.framework.model.LoginVO;
import foren.framework.utils.ArrayUtil;
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.GStringUtils;
import foren.framework.utils.JsonUtils;
import foren.framework.utils.MapUtils;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.service.impl.TlabCodeService;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.com.combo.ComboServiceImpl;
import foren.unilite.modules.com.tree.UniTreeHelper;
import foren.unilite.modules.com.tree.UniTreeNode;
import foren.unilite.modules.z_mit.ExternalDAO_MIT;
import foren.unilite.multidb.cubrid.fn.CommonServiceImpl_KOCIS_CUBRID;
import foren.unilite.utils.AES256DecryptoUtils;
import foren.unilite.utils.AES256EncryptoUtils;
import foren.unilite.utils.DevFreeUtils;

@Service( "popupService" )
@SuppressWarnings({"unchecked", "rawtypes"})
public class PopupServiceImpl extends TlabAbstractServiceImpl {
	private final Logger				logger   = LoggerFactory.getLogger(this.getClass());
	private AES256EncryptoUtils			encrypto = new AES256EncryptoUtils();
	private AES256DecryptoUtils			decrypto = new AES256DecryptoUtils();

	@Resource( name = "UniliteComboServiceImpl" )
	private ComboServiceImpl			comboService;

	@Resource( name = "tlabCodeService" )
	private TlabCodeService				tlabCodeService;

	@Resource( name = "commonServiceImpl_KOCIS_CUBRID" )
	private CommonServiceImpl_KOCIS_CUBRID commonServiceImpl_KOCIS_CUBRID;

	@Resource( name = "externalDAO_MIT" )
    protected ExternalDAO_MIT externalDAO;

	private String getNumreicCode( String type, String code, String compCode ) {
		CodeInfo codeInfo = tlabCodeService.getCodeInfo(compCode);

		if ("CUSTOM_CODE".equals(type)) {
			CodeDetailVO cdo = codeInfo.getCodeInfo("BS37", "10");
			if (cdo != null) {
				if ("Y".equals(cdo.getRefCode1()) && cdo.getRefCode2() != null) {
					int len = Integer.parseInt(cdo.getRefCode2());
					if (code.length() < len) {
						logger.debug("##############   code before : " + code);
						if (Pattern.matches("^[0-9]+$", code)) {
							code = String.format("%0" + len + "d", Long.parseLong(code));
						}
						logger.debug("##############   code before : " + code);
					}
				}
			}
		}

		if ("ITEM_CODE".equals(type)) {
			CodeDetailVO cdo = codeInfo.getCodeInfo("BS36", "10");
			if (cdo != null) {
				if ("Y".equals(cdo.getRefCode1()) && cdo.getRefCode2() != null) {
					int len = Integer.parseInt(cdo.getRefCode2());
					if (code.length() < len) {
						if (Pattern.matches("^[0-9]+$", code)) {
							code = String.format("%0" + len + "d", Long.parseLong(code));
						}
					}
				}
			}
		}
		return code;
	}

	/**
	 * 거래처 목록 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> custPopup( Map param ) throws Exception {
		if (param.containsKey("TYPE")) {
			String type = ObjUtils.getSafeString(param.get("TYPE"));
			if ("VALUE".equals(type)) {
				MapUtils.putIf(param, "RDO", "1");
			} else {
				MapUtils.putIf(param, "RDO", "2");
			}
		} else {
			MapUtils.putIf(param, "RDO", "1");
			String rdo = ObjUtils.getSafeString(param.get("RDO"));
			if ("1".equals(rdo)) {
				param.put("CUSTOM_CODE", GStringUtils.trim(ObjUtils.getSafeString(param.get("TXT_SEARCH"))));
			} else {
				param.put("CUSTOM_NAME", GStringUtils.trim(ObjUtils.getSafeString(param.get("TXT_SEARCH"))));
			}
		}
		if (!ObjUtils.isEmpty(param.get("CUSTOM_TYPE"))) {
			ArrayUtil.object2arryaInMap(param, "CUSTOM_TYPE"); // CUSTOM_TYPE : array 만들기
		}
		if (!ObjUtils.isEmpty(param.get("AGENT_TYPE"))) {
			ArrayUtil.object2arryaInMap(param, "AGENT_TYPE"); // AGENT_TYPE : array 만들기
		}
		if (ObjUtils.isNotEmpty(param.get("CUSTOM_CODE")) && "true".equals(ObjUtils.getSafeString(param.get("isFieldSearch")))) {
			param.put("CUSTOM_CODE", this.getNumreicCode("CUSTOM_CODE", param.get("CUSTOM_CODE").toString(), param.get("S_COMP_CODE").toString()));
		}
		logger.debug(ObjUtils.toJsonStr(param).toString());

		List<Map<String, Object>> rsltList = super.commonDao.list("popupServiceImpl.custPopup", param);
		if (DevFreeUtils.getOrDefault(param.get("DEC_FLAG"), "").equals("Y")) {  //복호화된 상태로 조회 시..
			if (!ObjUtils.isEmpty(rsltList)) {
				for (Map decMap : rsltList) {
					if (!ObjUtils.isEmpty(decMap.get("TOP_NUM"))) { //주민번호 복호화
						try {
							String repreNum = (String)decMap.get("TOP_NUM");
							//decryto() second 파라미터 : "RR"-주민번호   "RP"-여권번호   "RV"-비자번호  "RB"-계좌번호   "RC"-신용카드번호   "RF"-외국인 등록번호
							decMap.put("TOP_NUM_MASK", decrypto.decryto(decMap.get("TOP_NUM").toString(), "RR"));
							decMap.put("TOP_NUM_VAL", decrypto.decryto(decMap.get("TOP_NUM").toString(), "RR"));
						} catch (Exception e) {
							decMap.put("TOP_NUM_MASK", "데이타 오류(" + decMap.get("TOP_NUM").toString() + ")");
							decMap.put("TOP_NUM_VAL", "데이타 오류(" + decMap.get("TOP_NUM").toString() + ")");
						}
					} else {
						decMap.put("TOP_NUM_MASK", "");
					}

					String repreNum = (String)decMap.get("TOP_NUM");
					if (ObjUtils.isNotEmpty(repreNum)) {
						decMap.put("TOP_NUM_EXPOS", decrypto.getDecrypto("1", repreNum));
					} else {
						decMap.put("TOP_NUM_EXPOS", "");
					}
				}
			}
			return (List)rsltList;

		} else {
			for (Map rsltMap : rsltList) {
				String crdtNum = (String)rsltMap.get("TOP_NUM");
				if (ObjUtils.isNotEmpty(crdtNum)) {
					rsltMap.put("TOP_NUM_EXPOS", decrypto.getDecrypto("1", crdtNum));
				} else {
					rsltMap.put("TOP_NUM_EXPOS", "");
				}
			}
		}
		return rsltList;
	}

	/**
	 * 거래처(거래처분류조건포함)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "Popup" )
	public List<Map<String, Object>> agentCustPopup( Map param ) throws Exception {
		if (param.containsKey("TYPE")) {
			String type = ObjUtils.getSafeString(param.get("TYPE"));
			if ("VALUE".equals(type)) {
				MapUtils.putIf(param, "RDO", "1");
			} else {
				MapUtils.putIf(param, "RDO", "2");
			}
		} else {
			MapUtils.putIf(param, "RDO", "1");
			String rdo = ObjUtils.getSafeString(param.get("RDO"));
			if ("1".equals(rdo)) {
				param.put("CUSTOM_CODE", param.get("TXT_SEARCH"));
			} else {
				param.put("CUSTOM_NAME", param.get("TXT_SEARCH"));
			}
		}

		if (!ObjUtils.isEmpty(param.get("CUSTOM_TYPE"))) {
			ArrayUtil.object2arryaInMap(param, "CUSTOM_TYPE"); // CUSTOM_TYPE : array 만들기

		}
		if (ObjUtils.isNotEmpty(param.get("CUSTOM_CODE")) && "true".equals(ObjUtils.getSafeString(param.get("isFieldSearch")))) {
			param.put("CUSTOM_CODE", this.getNumreicCode("CUSTOM_CODE", param.get("CUSTOM_CODE").toString(), param.get("S_COMP_CODE").toString()));
		}
		if (!ObjUtils.isEmpty(param.get("AGENT_CUST_FILTER"))) {
			String[] str2 = (ObjUtils.getSafeString(param.get("AGENT_CUST_FILTER"))).split(",");
			param.put("AGENT_CUST_FILTER", str2);
		}

		return super.commonDao.list("popupServiceImpl.agentCustPopup", param);
	}

	/**
	 * 금융기관(은행) 목록 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> bankPopup( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.bankPopup", param);
	}

	/**
	 * 부표코드
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> buCodePopup( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.buCodePopup", param);
	}

	/**
	 * 지점정보
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> bussOfficeCode( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.bussOfficeCode", param);
	}

	/**
	 * 사업소득자 공통코드
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> saupPopupCode( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.saupPopupCode", param);
	}

	/**
	 * 금융상품코드 - Main
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> prizePopup( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.prizePopup", param);
	}

	/**
	 * 금융상품코드 - Sub
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> prizePopup2( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.prizePopup2", param);
	}

	/**
	 * 사업소득자 필드 생성
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "Popup" )
	// 사업소득자
	public List<Map<String, Object>> fnHCD100T( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.fnHCD100T", param);
	}

	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> hcd100TPopup( Map param ) throws Exception {
		List<Map> loopData = (List<Map>)super.commonDao.list("popupServiceImpl.fnHCD100T", param);

		param.put("sMainCode", loopData);
		return super.commonDao.list("popupServiceImpl.saupPopupCode", param);
	}

	/**
	 * 우편번호 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> zipPopup( Map param ) throws Exception {
		String postalCode = ObjUtils.getSafeString(param.get("ZIP_CODE"));
		if (postalCode != null) {
			param.put("ZIP_CODE", postalCode.replace("-", ""));
		}
		return super.commonDao.list("popupServiceImpl.ZipCodePopup", param);
	}

	/**
	 * 사용자 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "Popup" )
	public List<Map<String, Object>> userPopup( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.userPopup", param);
	}

	/**
	 * 사용자(COMP_CODE 조건없이) 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "Popup" )
	public List<Map<String, Object>> userNoCompPopup( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.userNoCompPopup", param);
	}

	/**
	 * 사원조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> employeePopup( Map param, LoginVO loginVO ) throws Exception {
		//FIXME 권한 조건 추가
		/*
		 * If aParam(5) = "Au" Then sRtnVal = goInterface.CallFunction(gsCert,"uniLITE5Popup.CPopup","GetHumanMasterAu", sCompCode ,sParam1, sParam2, fnDefaultDate(txtBaseDt.Value) ,"POP",rsObj, AuParam) Else sRtnVal = goInterface.CallFunction(gsCert,"uniLITE5Popup.CPopup","GetHumanMaster", sCompCode ,sParam1, sParam2, fnDefaultDate(txtBaseDt.Value) ,"POP",rsObj) End If
		 */
		//param.put("PAY_GUBUN","");

		if (param.get("pStrOpt") != null) {
			String strOpt = param.get("pStrOpt").toString().substring(0, 3);
			param.put("pStrOpt", strOpt);
		}
		param.put("DEPT_AUTH", loginVO.getDeptAuthYn());
		List<Map<String, Object>> rsltList = super.commonDao.list("popupServiceImpl.employeePopup", param);

		if (DevFreeUtils.getOrDefault(param.get("DEC_FLAG"), "").equals("Y")) {  //복호화된 상태로 조회 시..
			if (!ObjUtils.isEmpty(rsltList)) {
				for (Map decMap : rsltList) {
					if (!ObjUtils.isEmpty(decMap.get("REPRE_NUM"))) { //주민번호 복호화
						try {
							//decryto() second 파라미터 : "RR"-주민번호   "RP"-여권번호   "RV"-비자번호  "RB"-계좌번호   "RC"-신용카드번호   "RF"-외국인 등록번호
							decMap.put("REPRE_NUM_MASK", decrypto.decryto(decMap.get("REPRE_NUM").toString(), "RR"));
							decMap.put("REPRE_NUM_VAL", decrypto.decryto(decMap.get("REPRE_NUM").toString(), "RR"));
						} catch (Exception e) {
							decMap.put("REPRE_NUM_MASK", "데이타 오류(" + decMap.get("REPRE_NUM").toString() + ")");
							decMap.put("REPRE_NUM_VAL", "데이타 오류(" + decMap.get("REPRE_NUM").toString() + ")");
						}
					} else {
						decMap.put("REPRE_NUM_MASK", "");
					}

					String repreNum = (String)decMap.get("REPRE_NUM");
					if (ObjUtils.isNotEmpty(repreNum)) {
						decMap.put("REPRE_NUM_EXPOS", decrypto.getDecrypto("1", repreNum));
					} else {
						decMap.put("REPRE_NUM_EXPOS", "");
					}
				}
			}
			return (List)rsltList;

		} else {
			for (Map rsltMap : rsltList) {
				String crdtNum = (String)rsltMap.get("REPRE_NUM");
				if (ObjUtils.isNotEmpty(crdtNum)) {
					rsltMap.put("REPRE_NUM_EXPOS", decrypto.getDecrypto("1", crdtNum));
				} else {
					rsltMap.put("REPRE_NUM_EXPOS", "");
				}
			}
		}
		return rsltList;
	}

	/**
	 * 사원조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> employeePopup1( Map param ) throws Exception {
		//FIXME 권한 조건 추가
		/*
		 * If aParam(5) = "Au" Then sRtnVal = goInterface.CallFunction(gsCert,"uniLITE5Popup.CPopup","GetHumanMasterAu", sCompCode ,sParam1, sParam2, fnDefaultDate(txtBaseDt.Value) ,"POP",rsObj, AuParam) Else sRtnVal = goInterface.CallFunction(gsCert,"uniLITE5Popup.CPopup","GetHumanMaster", sCompCode ,sParam1, sParam2, fnDefaultDate(txtBaseDt.Value) ,"POP",rsObj) End If
		 */
		//param.put("PAY_GUBUN","");

		if (param.get("pStrOpt") != null) {
			String strOpt = param.get("pStrOpt").toString().substring(0, 3);
			param.put("pStrOpt", strOpt);
		}

		List<Map<String, Object>> rsltList = super.commonDao.list("popupServiceImpl.employeePopup1", param);

		if (DevFreeUtils.getOrDefault(param.get("DEC_FLAG"), "").equals("Y")) {  //복호화된 상태로 조회 시..
			if (!ObjUtils.isEmpty(rsltList)) {
				for (Map decMap : rsltList) {
					if (!ObjUtils.isEmpty(decMap.get("REPRE_NUM"))) { //주민번호 복호화
						try {
							//decryto() second 파라미터 : "RR"-주민번호   "RP"-여권번호   "RV"-비자번호  "RB"-계좌번호   "RC"-신용카드번호   "RF"-외국인 등록번호
							decMap.put("REPRE_NUM_MASK", decrypto.decryto(decMap.get("REPRE_NUM").toString(), "RR"));
							decMap.put("REPRE_NUM_VAL", decrypto.decryto(decMap.get("REPRE_NUM").toString(), "RR"));
						} catch (Exception e) {
							decMap.put("REPRE_NUM_MASK", "데이타 오류(" + decMap.get("REPRE_NUM").toString() + ")");
							decMap.put("REPRE_NUM_VAL", "데이타 오류(" + decMap.get("REPRE_NUM").toString() + ")");
						}
					} else {
						decMap.put("REPRE_NUM_MASK", "");
					}

					String repreNum = (String)decMap.get("REPRE_NUM");
					if (ObjUtils.isNotEmpty(repreNum)) {
						decMap.put("REPRE_NUM_EXPOS", decrypto.getDecrypto("1", repreNum));
					} else {
						decMap.put("REPRE_NUM_EXPOS", "");
					}
				}
			}
			return (List)rsltList;

		} else {
			for (Map rsltMap : rsltList) {
				String crdtNum = (String)rsltMap.get("REPRE_NUM");
				if (ObjUtils.isNotEmpty(crdtNum)) {
					rsltMap.put("REPRE_NUM_EXPOS", decrypto.getDecrypto("1", crdtNum));
				} else {
					rsltMap.put("REPRE_NUM_EXPOS", "");
				}
			}
		}
		return rsltList;
	}
	/**
	 * 일용직사원조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> parttimeEmployeePopup( Map param, LoginVO loginVO ) throws Exception {
		//FIXME 권한 조건 추가
		/*
		 * If aParam(5) = "Au" Then sRtnVal = goInterface.CallFunction(gsCert,"uniLITE5Popup.CPopup","GetHumanMasterAu", sCompCode ,sParam1, sParam2, fnDefaultDate(txtBaseDt.Value) ,"POP",rsObj, AuParam) Else sRtnVal = goInterface.CallFunction(gsCert,"uniLITE5Popup.CPopup","GetHumanMaster", sCompCode ,sParam1, sParam2, fnDefaultDate(txtBaseDt.Value) ,"POP",rsObj) End If
		 */
		//param.put("PAY_GUBUN","");

		if (param.get("pStrOpt") != null) {
			String strOpt = param.get("pStrOpt").toString().substring(0, 3);
			param.put("pStrOpt", strOpt);
		}
		param.put("DEPT_AUTH", loginVO.getDeptAuthYn());
		List<Map<String, Object>> rsltList = super.commonDao.list("popupServiceImpl.parttimeEmployeePopup", param);

		if (DevFreeUtils.getOrDefault(param.get("DEC_FLAG"), "").equals("Y")) {  //복호화된 상태로 조회 시..
			if (!ObjUtils.isEmpty(rsltList)) {
				for (Map decMap : rsltList) {
					if (!ObjUtils.isEmpty(decMap.get("REPRE_NUM"))) { //주민번호 복호화
						try {
							//decryto() second 파라미터 : "RR"-주민번호   "RP"-여권번호   "RV"-비자번호  "RB"-계좌번호   "RC"-신용카드번호   "RF"-외국인 등록번호
							decMap.put("REPRE_NUM_MASK", decrypto.decryto(decMap.get("REPRE_NUM").toString(), "RR"));
							decMap.put("REPRE_NUM_VAL", decrypto.decryto(decMap.get("REPRE_NUM").toString(), "RR"));
						} catch (Exception e) {
							decMap.put("REPRE_NUM_MASK", "데이타 오류(" + decMap.get("REPRE_NUM").toString() + ")");
							decMap.put("REPRE_NUM_VAL", "데이타 오류(" + decMap.get("REPRE_NUM").toString() + ")");
						}
					} else {
						decMap.put("REPRE_NUM_MASK", "");
					}

					String repreNum = (String)decMap.get("REPRE_NUM");
					if (ObjUtils.isNotEmpty(repreNum)) {
						decMap.put("REPRE_NUM_EXPOS", decrypto.getDecrypto("1", repreNum));
					} else {
						decMap.put("REPRE_NUM_EXPOS", "");
					}
				}
			}
			return (List)rsltList;

		} else {
			for (Map rsltMap : rsltList) {
				String crdtNum = (String)rsltMap.get("REPRE_NUM");
				if (ObjUtils.isNotEmpty(crdtNum)) {
					rsltMap.put("REPRE_NUM_EXPOS", decrypto.getDecrypto("1", crdtNum));
				} else {
					rsltMap.put("REPRE_NUM_EXPOS", "");
				}
			}
		}
		return rsltList;
	}

	/**
	 * 부서조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> deptPopup( Map param, LoginVO loginVO) throws Exception {
		if (ObjUtils.isNotEmpty(param.get("DIV_CODE")) && ( param.get("DIV_CODE") instanceof String )) {
			String[] divCode = new String[1];
			divCode[0] = (String)param.get("DIV_CODE");
			param.put("DIV_CODE", divCode);
		}
		param.put("DEPT_AUTH", loginVO.getDeptAuthYn());
		return super.commonDao.list("popupServiceImpl.deptPopup", param);
	}

	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> shopPopup( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.shopPopup", param);
	}

	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> lotPopup( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.lotPopup", param);
	}

	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> hsPopup( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.hsPopup", param);
	}

	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> lotNoPopup( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.lotNoPopup", param);
	}

	/**20190508
	 * 기타출고 등록(LOT)에서 사용하는 현재고 존재하는 데이터만 보여주는 LOT팝업
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> lotStockPopup( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.lotStockPopup", param);
	}

	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> lotNoYpPopup( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.lotNoYpPopup", param);
	}

	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> lotNoYpPopup2( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.lotNoYpPopup2", param);
	}

	/* 계획번호 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> planNumPopup( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.planNumPopup", param);
	}

	/* 의뢰번호 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> reqNumPopup( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.reqNumPopup", param);
	}

	/* 의뢰번호2 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> reqNum2Popup( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.reqNum2Popup", param);
	}

	/* 관세환급번호 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> returnNumPopup( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.returnNumPopup", param);
	}

	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> itemPopup( Map param , LoginVO loginVO) throws Exception {
		if (ObjUtils.isNotEmpty(param.get("ITEM_CODE")) && "true".equals(ObjUtils.getSafeString(param.get("isFieldSearch")))) {
			param.put("ITEM_CODE", this.getNumreicCode("ITEM_CODE", param.get("ITEM_CODE").toString(), param.get("S_COMP_CODE").toString()));
		}
		//201910 검색항목 조회 관련 로직 추가
		String findType = ObjUtils.getSafeString(param.get("TXTFIND_TYPE"));
		if(!"".equals(findType))	{
			param.put("QRY_TYPE", findType);
			Map searchType = (Map) super.commonDao.select("bpr300ukrvService.selectSearchType", param);
			if(!ObjUtils.isEmpty(searchType)) {
				String qryType	= (String) searchType.get("REF_CODE1");
				int idx			= qryType.indexOf(".");
				String qryType2	= qryType.substring(idx+1);

				param.put("QRY_TYPE", qryType2);
			}
		}
		return super.commonDao.list("popupServiceImpl.itemPopup", param);
	}

	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> workShopPopup( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.workShopPopup", param);
	}

	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> creditCard2( Map param ) throws Exception {
		//return  super.commonDao.list("popupServiceImpl.creditCard2", param);
		List<Map<String, Object>> rsltList = super.commonDao.list("popupServiceImpl.creditCard2", param);

		for (Map rsltMap : rsltList) {
			String crdtNum = (String)rsltMap.get("CRDT_FULL_NUM");
			if (ObjUtils.isNotEmpty(crdtNum)) {
				rsltMap.put("CRDT_FULL_NUM_EXPOS", decrypto.getDecrypto("1", crdtNum));
			} else {
				rsltMap.put("CRDT_FULL_NUM_EXPOS", "");
			}

			String accountNum = (String)rsltMap.get("ACCOUNT_NUM");
			if (ObjUtils.isNotEmpty(accountNum)) {
				rsltMap.put("ACCOUNT_NUM_EXPOS", decrypto.getDecrypto("1", accountNum));
			} else {
				rsltMap.put("ACCOUNT_NUM_EXPOS", "");
			}
		}
		return rsltList;
	}

	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> creditCard3( Map param ) throws Exception { //--joins 신용카드 팝업 관련  (암복호화)
		//return  super.commonDao.list("popupServiceImpl.creditCard2", param);
		String crdtFullNum = (String)param.get("CRDT_FULL_NUM");
		//logger.debug("===================== bankAccnt " + bankAccnt);
		if (!ObjUtils.isEmpty(crdtFullNum)) {
			String decCrdtFullNum = encrypto.encryto(crdtFullNum);
			param.put("CRDT_FULL_NUM", decCrdtFullNum);
		}

		List<Map<String, Object>> rsltList = super.commonDao.list("popupServiceImpl.creditCard3", param);

		for (Map rsltMap : rsltList) {
			String crdtNum = (String)rsltMap.get("CRDT_FULL_NUM");
			if (ObjUtils.isNotEmpty(crdtNum)) {
				rsltMap.put("CRDT_FULL_NUM_EXPOS", decrypto.getDecrypto("1", crdtNum));
			} else {
				rsltMap.put("CRDT_FULL_NUM_EXPOS", "");
			}

			String accountNum = (String)rsltMap.get("ACCOUNT_NUM");
			if (ObjUtils.isNotEmpty(accountNum)) {
				rsltMap.put("ACCOUNT_NUM_EXPOS", decrypto.getDecrypto("1", accountNum));
			} else {
				rsltMap.put("ACCOUNT_NUM_EXPOS", "");
			}
		}
		return rsltList;
	}

	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> itemPopup2( Map param ) throws Exception {
		if (ObjUtils.isNotEmpty(param.get("ITEM_CODE")) && "true".equals(ObjUtils.getSafeString(param.get("isFieldSearch")))) {
			param.put("ITEM_CODE", this.getNumreicCode("ITEM_CODE", param.get("ITEM_CODE").toString(), param.get("S_COMP_CODE").toString()));
		}
		return super.commonDao.list("popupServiceImpl.itemPopup2", param);
	}

	private void setSpecSearch(Map param, LoginVO loginVO)	{
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = codeInfo.getCodeInfo("B137", "10");

		if(!ObjUtils.isEmpty(cdo) )	{
			param.put("SPEC_SEARCH",GStringUtils.toUpperCase(cdo.getRefCode1()));
		} else {
			param.put("SPEC_SEARCH","N");
		}
		//return param;
	}

	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> divPumokPopup( Map param, LoginVO loginVO ) throws Exception {
		//		if(param.containsKey("TYPE")) {
		//			String type = ObjUtils.getSafeString(param.get("TYPE"));
		//			if("VALUE".equals(type)) {
		//				MapUtils.putIf(param, "RDO", "1");
		//			} else {
		//				MapUtils.putIf(param, "RDO", "2");
		//			}
		//		} else {
		//			MapUtils.putIf(param, "RDO", "1");
		//			String rdo = ObjUtils.getSafeString(param.get("RDO"));
		//			if("1".equals(rdo)) {
		//				param.put("ITEM_CODE", param.get("ITEM_SEARCH"));
		//			} else {
		//				param.put("ITEM_NAME", param.get("ITEM_SEARCH"));
		//			}
		//		}
		//20181205 검색항목 조회 관련 로직 추가
		String findType = ObjUtils.getSafeString(param.get("FIND_TYPE"));
		if(!"".equals(findType))	{
			param.put("QRY_TYPE", findType);
			Map searchType = (Map) super.commonDao.select("bpr300ukrvService.selectSearchType", param);
			if(!ObjUtils.isEmpty(searchType)) {
				String qryType	= (String) searchType.get("REF_CODE1");
				int idx			= qryType.indexOf(".");
				String qryType2	= qryType.substring(idx+1);

				param.put("QRY_TYPE", qryType2);
			}
		}

		this.setSpecSearch(param, loginVO);
		if(ObjUtils.isNotEmpty(param.get("ITEM_ACCOUNT"))){
			param.put("ITEM_ACCOUNT_ARRAY", ArrayUtil.toArray(param.get("ITEM_ACCOUNT"))); // multiSelect 조건을 위해  ITEM_ACCOUNT 배열형식으로 변환
		}
		if(ObjUtils.isNotEmpty(param.get("ITEM_ACCOUNT_JSP_PARAM"))){
			String itemAccountJspParam = (String) param.get("ITEM_ACCOUNT_JSP_PARAM");
			String [] itemAccountJspParams = itemAccountJspParam.split(",");
			param.put("ITEM_ACCOUNT_JSP_PARAMS", itemAccountJspParams);
		}
		if (ObjUtils.isNotEmpty(param.get("ITEM_CODE")) && "true".equals(ObjUtils.getSafeString(param.get("isFieldSearch")))) {
			param.put("ITEM_CODE", this.getNumreicCode("ITEM_CODE", param.get("ITEM_CODE").toString(), param.get("S_COMP_CODE").toString()));
		}
		List<Map<String, Object>> rList=null;
		if(ObjUtils.isEmpty(param.get("CUSTOM_ORDER_PUMOK_YN"))){
			param.put("CUSTOM_ORDER_PUMOK_YN", "N");
		}
		if(param.get("TXT_SEARCH2") == null || ObjUtils.isEmpty(param.get("TXT_SEARCH2")) )	{
			if(param.get("CUSTOM_ORDER_PUMOK_YN").equals("Y")){//거래처단가에 등록된 품목만 조회하도록 설정했을 경우
				logger.debug("[[CUSTOM_ORDER_PUMOK_YN1]]");
				rList = super.commonDao.list("popupServiceImpl.customDivPumok", param);
			}else{
				rList = super.commonDao.list("popupServiceImpl.divPumok_code", param);
				if(rList != null && rList.size() != 1)	{
					rList = super.commonDao.list("popupServiceImpl.divPumok", param);
				}
			}
		}else {
			if(param.get("CUSTOM_ORDER_PUMOK_YN").equals("Y")){//거래처단가에 등록된 품목만 조회하도록 설정했을 경우
				logger.debug("[[CUSTOM_ORDER_PUMOK_YN2]]");
				rList = super.commonDao.list("popupServiceImpl.customDivPumok", param);
			}else{
				rList = super.commonDao.list("popupServiceImpl.divPumok", param);
			}
		}
		return rList ;
	}

	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> custPumokPopup( Map param ) throws Exception {
		if (param.containsKey("TYPE")) {
			String type = ObjUtils.getSafeString(param.get("TYPE"));
			if ("VALUE".equals(type)) {
				MapUtils.putIf(param, "RDO", "1");
			} else {
				MapUtils.putIf(param, "RDO", "2");
			}
		} else {
			MapUtils.putIf(param, "RDO", "1");
			String rdo = ObjUtils.getSafeString(param.get("RDO"));
			if ("1".equals(rdo)) {
				param.put("ITEM_CODE", param.get("ITEM_SEARCH"));
			} else {
				param.put("ITEM_NAME", param.get("ITEM_SEARCH"));
			}
		}
		if (ObjUtils.isNotEmpty(param.get("ITEM_CODE")) && "true".equals(ObjUtils.getSafeString(param.get("isFieldSearch")))) {
			param.put("ITEM_CODE", this.getNumreicCode("ITEM_CODE", param.get("ITEM_CODE").toString(), param.get("S_COMP_CODE").toString()));
		}
		return super.commonDao.list("popupServiceImpl.custPumok", param);
	}

	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> commissionDivPumokPopup( Map param ) throws Exception {
		if (param.containsKey("TYPE")) {
			String type = ObjUtils.getSafeString(param.get("TYPE"));
			if ("VALUE".equals(type)) {
				MapUtils.putIf(param, "RDO", "1");
			} else {
				MapUtils.putIf(param, "RDO", "2");
			}
		} else {
			MapUtils.putIf(param, "RDO", "1");
			String rdo = ObjUtils.getSafeString(param.get("RDO"));
			if ("1".equals(rdo)) {
				param.put("ITEM_CODE", param.get("ITEM_SEARCH"));
			} else {
				param.put("ITEM_NAME", param.get("ITEM_SEARCH"));
			}
		}
		if (ObjUtils.isNotEmpty(param.get("ITEM_CODE")) && "true".equals(ObjUtils.getSafeString(param.get("isFieldSearch")))) {
			param.put("ITEM_CODE", this.getNumreicCode("ITEM_CODE", param.get("ITEM_CODE").toString(), param.get("S_COMP_CODE").toString()));
		}
		return super.commonDao.list("popupServiceImpl.commissionDivPumok", param);
	}

	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> divPumok2Popup( Map param ) throws Exception {
		if (param.containsKey("TYPE")) {
			String type = ObjUtils.getSafeString(param.get("TYPE"));
			if ("VALUE".equals(type)) {
				MapUtils.putIf(param, "RDO", "1");
			} else {
				MapUtils.putIf(param, "RDO", "2");
			}
		} else {
			MapUtils.putIf(param, "RDO", "1");
			String rdo = ObjUtils.getSafeString(param.get("RDO"));
			if ("1".equals(rdo)) {
				param.put("ITEM_CODE", param.get("ITEM_SEARCH"));
			} else {
				param.put("ITEM_NAME", param.get("ITEM_SEARCH"));
			}
		}
		if (ObjUtils.isNotEmpty(param.get("ITEM_CODE")) && "true".equals(ObjUtils.getSafeString(param.get("isFieldSearch")))) {
			param.put("ITEM_CODE", this.getNumreicCode("ITEM_CODE", param.get("ITEM_CODE").toString(), param.get("S_COMP_CODE").toString()));
		}
		return super.commonDao.list("popupServiceImpl.divPumok2", param);
	}

	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> itemGroupPopup( Map param ) throws Exception {
		if (param.containsKey("TYPE")) {
			String type = ObjUtils.getSafeString(param.get("TYPE"));
			if ("VALUE".equals(type)) {
				MapUtils.putIf(param, "RDO", "1");
			} else {
				MapUtils.putIf(param, "RDO", "2");
			}
		} else {
			MapUtils.putIf(param, "RDO", "1");
			String rdo = ObjUtils.getSafeString(param.get("RDO"));
			if ("1".equals(rdo)) {
				param.put("ITEM_CODE", param.get("ITEM_SEARCH"));
			} else {
				param.put("ITEM_NAME", param.get("ITEM_SEARCH"));
			}
		}
		if (ObjUtils.isNotEmpty(param.get("ITEM_CODE")) && "true".equals(ObjUtils.getSafeString(param.get("isFieldSearch")))) {
			param.put("ITEM_CODE", this.getNumreicCode("ITEM_CODE", param.get("ITEM_CODE").toString(), param.get("S_COMP_CODE").toString()));
		}
		logger.debug(ObjUtils.toJsonStr(param).toString());
		return super.commonDao.list("popupServiceImpl.itemGroup", param);
	}

	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> divItemGroupPopup( Map param ) throws Exception {
		if (param.containsKey("TYPE")) {
			String type = ObjUtils.getSafeString(param.get("TYPE"));
			if ("VALUE".equals(type)) {
				MapUtils.putIf(param, "RDO", "1");
			} else {
				MapUtils.putIf(param, "RDO", "2");
			}
		} else {
			MapUtils.putIf(param, "RDO", "1");
			String rdo = ObjUtils.getSafeString(param.get("RDO"));
			if ("1".equals(rdo)) {
				param.put("ITEM_CODE", param.get("ITEM_SEARCH"));
			} else {
				param.put("ITEM_NAME", param.get("ITEM_SEARCH"));
			}
		}

		logger.debug(ObjUtils.toJsonStr(param).toString());
		if (ObjUtils.isNotEmpty(param.get("ITEM_CODE")) && "true".equals(ObjUtils.getSafeString(param.get("isFieldSearch")))) {
			param.put("ITEM_CODE", this.getNumreicCode("ITEM_CODE", param.get("ITEM_CODE").toString(), param.get("S_COMP_CODE").toString()));
		}
		return super.commonDao.list("popupServiceImpl.divItemGroup", param);
	}

	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> safferTaxPopup( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.safferTaxPopup", param);
	}

	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> driverPopup( Map param ) throws Exception {
		logger.debug(ObjUtils.toJsonStr(param).toString());
		return super.commonDao.list("popupServiceImpl.driver", param);
	}

	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> vehiclePopup( Map param ) throws Exception {
		logger.debug(ObjUtils.toJsonStr(param).toString());
		return super.commonDao.list("popupServiceImpl.vehicle", param);
	}

	/**
	 * 관리번호 조회
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> projectPopup( Map param ) throws Exception {
		logger.debug(ObjUtils.toJsonStr(param).toString());
		return super.commonDao.list("popupServiceImpl.project", param);
	}

	/**
	 * 프로젝트 팝업
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> pjtPopup( Map param ) throws Exception {
		logger.debug(ObjUtils.toJsonStr(param).toString());
		return super.commonDao.list("popupServiceImpl.pjtPopup", param);
	}

	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> countdatePopup( Map param ) throws Exception {
		logger.debug(ObjUtils.toJsonStr(param).toString());
		return super.commonDao.list("popupServiceImpl.countdate", param);
	}

	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> custBillPrsnPopup( Map param ) throws Exception {
		logger.debug(ObjUtils.toJsonStr(param).toString());
		return super.commonDao.list("popupServiceImpl.custBillPrsnPopup", param);
	}

	/**
	 * 수불번호 조회
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> inoutNumPopup( Map param ) throws Exception {
		logger.debug(ObjUtils.toJsonStr(param).toString());
		return super.commonDao.list("popupServiceImpl.inoutNumPopup", param);
	}

	/**
	 * 수주번호 조회
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> orderNumPopup( Map param ) throws Exception {
		logger.debug(ObjUtils.toJsonStr(param).toString());
		return super.commonDao.list("popupServiceImpl.orderNumPopup", param);
	}

	/**
	 * 수주번호 조회(detail)
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> orderNumPopup2( Map param ) throws Exception {
		logger.debug(ObjUtils.toJsonStr(param).toString());
		return super.commonDao.list("popupServiceImpl.orderNumPopup2", param);
	}

	/**
	 * 원본세금계산서 조회
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> TaxBillSearchPopup( Map param ) throws Exception {
		logger.debug(ObjUtils.toJsonStr(param).toString());
		return super.commonDao.list("popupServiceImpl.TaxBillSearchPopup", param);
	}

	/**
	 * 정비사 조회
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> mechanicPopup( Map param ) throws Exception {
		logger.debug(ObjUtils.toJsonStr(param).toString());
		return super.commonDao.list("popupServiceImpl.mechanic", param);
	}

	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> getBomCopyPopup( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.getBomCopy", param);
	}

	/**
	 * 신용카드거래처
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> custCreditCard( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.custCreditCard", param);
	}

	/**
	 * 신용카드사
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> creditCard( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.creditCard", param);
	}

	/**
	 * 출고요청번호
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> outStockNum( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.outStockNum", param);
	}

	/**
	 * 진열대 조회
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> binPopup( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.binPopup", param);
	}

	/**
	 * 장비 조회
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> posPopup( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.posPopup", param);
	}

	/**
	 * 공정정보
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> progWorkCode( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.progWorkCode", param);
	}

	/**
	 * 설비정보
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> equipCode( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.equipCode", param);
	}

	/**
	 * 금형정보
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> moldCode( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.moldCode", param);
	}

	/**
	 * 작업지시정보
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> wkordNum( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.wkordNum", param);
	}

	/**
	 * 무역 수입 NEGO 관리번호 팝업
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> negoIncomNoPopup( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.negoIncomNoPopup", param);
	}

	/**
	 * 무역 수출 NEGO 관리번호 팝업
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> negoNoPopup( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.negoNoPopup", param);
	}

	/**
	 * 무역 수입 NEGO 관리번호 팝업
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> passIncomNoPopup( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.passIncomNoPopup", param);
	}

	/**
	 * 무역 수입 OFFER 관리번호 팝업
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> incomOfferNoPopup( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.incomOfferNoPopup", param);
	}

	/**
	 * 무역 수입 B/L 관리번호 팝업
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> incomBlNoPopup( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.incomBlNoPopup", param);
	}

	/**
	 * 배송처
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> deliveryPopup( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.deliveryPopup", param);
	}
	/* -----------------------------------------회계팝업 시작------------------------------------- */

	/**
	 * 사업장 팝업
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> accntDivCodePopup( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.accntDivCodePopup", param);
	}

	/**
	 * 계정과목
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> accntsPopup( Map param ) throws Exception {
		List<Map> prodAcnt = (List<Map>)super.commonDao.list("popupServiceImpl.accntsPopup1", param);
		if (!ObjUtils.isEmpty(prodAcnt)) {
			param.put("PROD_ACCNT", prodAcnt.get(0).get("PROD_ACCNT"));
			param.put("USE_DEPT", prodAcnt.get(0).get("USE_DEPT"));
		} else {
			param.put("PROD_ACCNT", "0");
			param.put("USE_DEPT", "2");
		}
		return super.commonDao.list("popupServiceImpl.accntsPopup2", param);
	}

	/**
	 * 외화계정
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> foreignAccntPopup( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.foreignAccntPopup", param);
	}

	/**
	 * 환산계정
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> exchangeAccntPopup( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.exchangeAccntPopup", param);
	}

	/**
	 * 지출결의 계정과목
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> accntsPayPopup( Map param ) throws Exception {
		String message = "";
		if(ObjUtils.isEmpty(param.get("GUBUN")))	{
			message += "구분값을 입력하세요.\r\n";
		}
		if(ObjUtils.isEmpty(param.get("PAY_DIVI")))	{
			message += "결제방법값을 입력하세요\\r\\n";
		}
		if(ObjUtils.isEmpty(param.get("PAY_TYPE")))	{
			message += "지출유형값을 입력하세요\\r\\n";
		}
		if(ObjUtils.isEmpty(param.get("MAKE_SALE")))	{
			message += "제조판관값을 입력하세요\\r\\n";
		}
		if(!ObjUtils.isEmpty(message))	{
			 throw new  UniDirectValidateException(message);
		}
		return super.commonDao.list("popupServiceImpl.accntsPayPopup", param);
	}
	/**
	 * 계정과목과 관리항목
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> accntPopupWithAcCode( Map param ) throws Exception {
		List<Map> prodAcnt = (List<Map>)super.commonDao.list("popupServiceImpl.accntsPopup1", param);
		if (!ObjUtils.isEmpty(prodAcnt)) {
			param.put("PROD_ACCNT", prodAcnt.get(0).get("PROD_ACCNT"));
			param.put("USE_DEPT", prodAcnt.get(0).get("USE_DEPT"));
		} else {
			param.put("PROD_ACCNT", "0");
			param.put("USE_DEPT", "2");
		}
		return super.commonDao.list("popupServiceImpl.accntsPopupWithAcCode", param);
	}

	/**
	 * 관리항목
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> managePopup( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.managePopup", param);
	}

	/**
	 * 관리항목(사용자)
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> userManagePopup( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.userManagePopup", param);
	}

	/**
	 * 적요
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> remarkPopup( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.remarkPopup", param);
	}

	/**
	 * 적요(물류)
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> remarkDistributionPopup( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.remarkDistributionPopup", param);
	}

	/**
	 * 기간비용
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> costPopup( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.costPopup", param);
	}

	/**
	 * 회계담당자
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> accntPrsnPopup( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.accntPrsPopup", param);
	}

	/**
	 * 경비코드
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> expensePopup( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.expensePopup", param);
	}

	/**
	 * 수당/공제코드
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> allowPopup( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.allowPopup", param);	//정규
	}

	/**
	 * 소득자
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> earnerPopup( Map param ) throws Exception {
		List<Map<String, Object>> rsltList = super.commonDao.list("popupServiceImpl.earnerPopup", param);

		if (DevFreeUtils.getOrDefault(param.get("DEC_FLAG"), "").equals("Y")) {  //복호화된 상태로 조회 시..
			if (!ObjUtils.isEmpty(rsltList)) {
				for (Map decMap : rsltList) {
					if (!ObjUtils.isEmpty(decMap.get("REPRE_NUM"))) { //주민번호 복호화
						try {
							//decryto() second 파라미터 : "RR"-주민번호   "RP"-여권번호   "RV"-비자번호  "RB"-계좌번호   "RC"-신용카드번호   "RF"-외국인 등록번호
							decMap.put("REPRE_NUM_MASK", decrypto.decryto(decMap.get("REPRE_NUM").toString(), "RR"));
							decMap.put("REPRE_NUM_VAL", decrypto.decryto(decMap.get("REPRE_NUM").toString(), "RR"));
						} catch (Exception e) {
							decMap.put("REPRE_NUM_MASK", "데이타 오류(" + decMap.get("REPRE_NUM").toString() + ")");
							decMap.put("REPRE_NUM_VAL", "데이타 오류(" + decMap.get("REPRE_NUM").toString() + ")");
						}
					} else {
						decMap.put("REPRE_NUM_MASK", "");
					}

					String repreNum = (String)decMap.get("REPRE_NUM");
					if (ObjUtils.isNotEmpty(repreNum)) {
						decMap.put("REPRE_NUM_EXPOS", decrypto.getDecrypto("1", repreNum));
					} else {
						decMap.put("REPRE_NUM_EXPOS", "");
					}
				}
			}
			return (List)rsltList;

		} else {
			for (Map rsltMap : rsltList) {
				String crdtNum = (String)rsltMap.get("REPRE_NUM");
				if (ObjUtils.isNotEmpty(crdtNum)) {
					rsltMap.put("REPRE_NUM_EXPOS", decrypto.getDecrypto("1", crdtNum));
				} else {
					rsltMap.put("REPRE_NUM_EXPOS", "");
				}
			}
		}
		return rsltList;
	}

	/**
	 * 부동산
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> realtyPopup( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.realtyPopup", param);
	}

	/**
	 * 자산코드
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> assetPopup( Map param ) throws Exception {
		List<Map> assTable = (List<Map>)super.commonDao.list("popupServiceImpl.assetPopup1", param);
		if (!ObjUtils.isEmpty(assTable) && assTable.get(0).get("REF_CODE1").equals("Y")) {
			param.put("ASST", "AISS300T");
		} else {
			param.put("ASST", "ASS300T");
		}
		return super.commonDao.list("popupServiceImpl.assetPopup2", param);
	}

	/**
	 * CostPool
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> costPoolPopup( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.costPoolPopup", param);
	}

	/**
	 * CostPoolCbm600t
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> costPoolCbm600tPopup( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.costPoolCbm600tPopup", param);
	}

	/**
	 * 단위
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> unitPopup( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.unitPopup", param);
	}

	/**
	 * 어음종류
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> noteTypePopup( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.noteTypePopup", param);
	}

	/**
	 * 어음번호
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> noteNumPopup( Map param ) throws Exception {
		String sGubun = ObjUtils.getSafeString(param.get("sGubun"));
		String drCr = ObjUtils.getSafeString(param.get("DR_CR"));
		String specDivi = ObjUtils.getSafeString(param.get("SPEC_DIVI"));
		logger.debug("DR_CR : " + drCr);
		logger.debug("SPEC_DIVI : " + specDivi);
		String sqlGbn = "AFN100t";
		if ("1".equals(drCr)) {
			if ("D1".equals(specDivi)) {
				param.put("AC_CD", "D1");
				String[] noteStsList = { "2", "3" };
				param.put("NOTE_STS_LIST", noteStsList);

			} else if ("D3".equals(specDivi)) {
				param.put("AC_CD", "D3");
				String[] noteStsList = { "1", "6" };
				param.put("NOTE_STS_LIST", noteStsList);

			} else if ("D4".equals(specDivi)) {
				param.put("AC_CD", "D1");
				String[] noteStsList = { "2", "3" };
				param.put("NOTE_STS_LIST", noteStsList);

			} else {
				param.put("AC_CD", "D1");
				String[] noteStsList = { "1", "2", "3", "5" };
				param.put("NOTE_STS_LIST", noteStsList);
			}

		} else {
			if ("D1".equals(specDivi)) {
				param.put("AC_CD", "D1");
				String[] noteStsList = { "1", "6" };
				param.put("NOTE_STS_LIST", noteStsList);

			} else if ("D3".equals(specDivi)) {
				//param.put("NOTE_DIVI", "1");
				//param.put("PROC_SW", "2");
				sqlGbn = "AFN200T";
			} else if ("D4".equals(specDivi)) {
				String[] acCdList = { "D4", "D1" };
				param.put("AC_CD_LIST", acCdList);
				String[][] noteStsList = { { "1", "4" }, { "2", "4" } };
				param.put("NOTE_STS_LIST1", noteStsList);

			} else {
				String[] acCdList = { "D4", "D1" };
				param.put("AC_CD_LIST", acCdList);
				String[][] noteStsList = { { "1", "4" }, { "2", "4" } };
				param.put("NOTE_STS_LIST1", noteStsList);
			}
		}
		logger.debug("param:" + JsonUtils.toJsonStr(param));

		String sqlId = "popupServiceImpl.noteNumPopup";
		if ("AFN200T".equals(sqlGbn)) {
			sqlId = "popupServiceImpl.noteNumPopupD3";
		}
		return super.commonDao.list(sqlId, param);
	}

	/**
	 * 수표번호
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> checkNumPopup( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.checkNumPopup", param);
	}

	/**
	 * 화폐단위
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> moneyPopup( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.moneyPopup", param);
	}

	/**
	 * L/C번호(수출)
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> exLcnoPopup( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.exLcnoPopup", param);
	}

	/**
	 * L/C번호(수입)
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> inLcnoPopup( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.inLcnoPopup", param);
	}

	/**
	 * B/L번호(수출)
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> exBlnoPopup( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.exBlnoPopup", param);
	}

	/**
	 * B/L번호(수입)
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> inBlnoPopup( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.inBlnoPopup", param);
	}

	/**
	 * 수출신고번호
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> passBlSerPopup( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.passSerNoPopup", param);
	}

	/**
	 * 프로젝트
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> acProjectPopup( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.acProjectPopup", param);
	}

	/**
	 * 급호
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "Popup" )
	// 급호
	public List<Map<String, Object>> fnHum100P1( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.fnHum100P1", param);
	}

	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> payGradePopup( Map param ) throws Exception {
		List<Map> loopData = (List<Map>)super.commonDao.list("popupServiceImpl.fnHum100P1", param);

		param.put("sWagesCode", loopData);
		return super.commonDao.list("popupServiceImpl.payGradePopup", param);
	}

	/**
	 * 자금항목
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> fundPopup( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.fundPopup", param);
	}

	/**
	 * 신용카드번호
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> creditNoPopup( Map param ) throws Exception {
		//return super.commonDao.list("popupServiceImpl.creditNoPopup", param);

		List<Map<String, Object>> rsltList = super.commonDao.list("popupServiceImpl.creditNoPopup", param);

		if (DevFreeUtils.getOrDefault(param.get("DEC_FLAG"), "").equals("Y")) {  //복호화된 상태로 조회 시..
			if (!ObjUtils.isEmpty(rsltList)) {
				for (Map decMap : rsltList) {
					if (!ObjUtils.isEmpty(decMap.get("CRDT_FULL_NUM"))) { //신용카드번호 복호화
						try {
							//decryto() second 파라미터 : "RR"-주민번호   "RP"-여권번호   "RV"-비자번호  "RB"-계좌번호   "RC"-신용카드번호   "RF"-외국인 등록번호
							decMap.put("CRDT_FULL_NUM_MASK", decrypto.decryto(decMap.get("CRDT_FULL_NUM").toString(), "RC"));
							decMap.put("CRDT_FULL_NUM_VAL", decrypto.decryto(decMap.get("CRDT_FULL_NUM").toString(), "RC"));
						} catch (Exception e) {
							decMap.put("CRDT_FULL_NUM_MASK", "데이타 오류(" + decMap.get("CRDT_FULL_NUM").toString() + ")");
							decMap.put("CRDT_FULL_NUM_VAL", "데이타 오류(" + decMap.get("CRDT_FULL_NUM").toString() + ")");
						}
					} else {
						decMap.put("CRDT_FULL_NUM_MASK", "");
					}

					if (!ObjUtils.isEmpty(decMap.get("ACCOUNT_NUM"))) {//계좌번호 복호화
						try {
							//decryto() second 파라미터 : "RR"-주민번호   "RP"-여권번호   "RV"-비자번호  "RB"-계좌번호   "RC"-신용카드번호   "RF"-외국인 등록번호
							decMap.put("ACCOUNT_NUM_MASK", decrypto.decryto(decMap.get("ACCOUNT_NUM").toString(), "RB"));
							decMap.put("ACCOUNT_NUM_VAL", decrypto.decryto(decMap.get("ACCOUNT_NUM").toString(), "RB"));
						} catch (Exception e) {
							decMap.put("ACCOUNT_NUM_MASK", "데이타 오류(" + decMap.get("ACCOUNT_NUM").toString() + ")");
							decMap.put("ACCOUNT_NUM_VAL", "데이타 오류(" + decMap.get("ACCOUNT_NUM").toString() + ")");
						}
					} else {
						decMap.put("ACCOUNT_NUM_MASK", "");
					}

					String crdtNum = (String)decMap.get("CRDT_FULL_NUM");
					if (ObjUtils.isNotEmpty(crdtNum)) {
						decMap.put("CRDT_FULL_NUM_EXPOS", decrypto.getDecrypto("1", crdtNum));
					} else {
						decMap.put("CRDT_FULL_NUM_EXPOS", "");
					}

					String accntNum = (String)decMap.get("ACCOUNT_NUM");
					if (ObjUtils.isNotEmpty(accntNum)) {
						decMap.put("ACCOUNT_NUM_EXPOS", decrypto.getDecrypto("1", accntNum));
					} else {
						decMap.put("ACCOUNT_NUM_EXPOS", "");
					}
				}
			}
			return (List)rsltList;

		} else {
			if (!ObjUtils.isEmpty(rsltList)) {
				for (Map rsltMap : rsltList) {
					String crdtNum = (String)rsltMap.get("CRDT_FULL_NUM");
					if (ObjUtils.isNotEmpty(crdtNum)) {
						rsltMap.put("CRDT_FULL_NUM_EXPOS", decrypto.getDecrypto("1", crdtNum));
					} else {
						rsltMap.put("CRDT_FULL_NUM_EXPOS", "");
					}

					String accntNum = (String)rsltMap.get("ACCOUNT_NUM");
					if (ObjUtils.isNotEmpty(accntNum)) {
						rsltMap.put("ACCOUNT_NUM_EXPOS", decrypto.getDecrypto("1", accntNum));
					} else {
						rsltMap.put("ACCOUNT_NUM_EXPOS", "");
					}
				}
			}
		}
		return rsltList;
	}

	/**
	 * 신용카드번호-JOINS
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> creditNoPopupJ( Map param ) throws Exception {
		String returnStr = "";

		//카드번호 param 암호화
		if (!ObjUtils.isEmpty(param.get("CRDT_FULL_NUM_EXPOS"))) {
			String crdtFullNum = (String)param.get("CRDT_FULL_NUM_EXPOS");
			returnStr = encrypto.encryto(crdtFullNum);
			param.put("CRDT_FULL_NUM_EXPOS", returnStr);
		} else if (!ObjUtils.isEmpty(param.get("SEARCH_CRDT_FULL_NUM"))) {
			String crdtFullNum = (String)param.get("SEARCH_CRDT_FULL_NUM");
			returnStr = encrypto.encryto(crdtFullNum);
			param.put("SEARCH_CRDT_FULL_NUM", returnStr);
		}
		//		확인필요
		List<Map<String, Object>> rsltList = super.commonDao.list("popupServiceImpl.creditNoPopupJ", param);

		if (DevFreeUtils.getOrDefault(param.get("DEC_FLAG"), "").equals("Y")) {  //복호화된 상태로 조회 시..
			if (!ObjUtils.isEmpty(rsltList)) {
				for (Map decMap : rsltList) {
					if (!ObjUtils.isEmpty(decMap.get("CRDT_FULL_NUM"))) { //신용카드번호 복호화
						try {
							//decryto() second 파라미터 : "RR"-주민번호   "RP"-여권번호   "RV"-비자번호  "RB"-계좌번호   "RC"-신용카드번호   "RF"-외국인 등록번호
							decMap.put("CRDT_FULL_NUM_MASK", decrypto.decryto(decMap.get("CRDT_FULL_NUM").toString(), "RC"));
							decMap.put("CRDT_FULL_NUM_VAL", decrypto.decryto(decMap.get("CRDT_FULL_NUM").toString(), "RC"));
						} catch (Exception e) {
							decMap.put("CRDT_FULL_NUM_MASK", "데이타 오류(" + decMap.get("CRDT_FULL_NUM").toString() + ")");
							decMap.put("CRDT_FULL_NUM_VAL", "데이타 오류(" + decMap.get("CRDT_FULL_NUM").toString() + ")");
						}
					} else {
						decMap.put("CRDT_FULL_NUM_MASK", "");
					}

					if (!ObjUtils.isEmpty(decMap.get("ACCOUNT_NUM"))) {//계좌번호 복호화
						try {
							//decryto() second 파라미터 : "RR"-주민번호   "RP"-여권번호   "RV"-비자번호  "RB"-계좌번호   "RC"-신용카드번호   "RF"-외국인 등록번호
							decMap.put("ACCOUNT_NUM_MASK", decrypto.decryto(decMap.get("ACCOUNT_NUM").toString(), "RB"));
							decMap.put("ACCOUNT_NUM_VAL", decrypto.decryto(decMap.get("ACCOUNT_NUM").toString(), "RB"));
						} catch (Exception e) {
							decMap.put("ACCOUNT_NUM_MASK", "데이타 오류(" + decMap.get("ACCOUNT_NUM").toString() + ")");
							decMap.put("ACCOUNT_NUM_VAL", "데이타 오류(" + decMap.get("ACCOUNT_NUM").toString() + ")");
						}
					} else {
						decMap.put("ACCOUNT_NUM_MASK", "");
					}

					String crdtNum = (String)decMap.get("CRDT_FULL_NUM");
					if (ObjUtils.isNotEmpty(crdtNum)) {
						decMap.put("CRDT_FULL_NUM_EXPOS", decrypto.getDecrypto("1", crdtNum));
					} else {
						decMap.put("CRDT_FULL_NUM_EXPOS", "");
					}

					String accntNum = (String)decMap.get("ACCOUNT_NUM");
					if (ObjUtils.isNotEmpty(accntNum)) {
						decMap.put("ACCOUNT_NUM_EXPOS", decrypto.getDecrypto("1", accntNum));
					} else {
						decMap.put("ACCOUNT_NUM_EXPOS", "");
					}
				}
			}
			return (List)rsltList;

		} else {
			if (!ObjUtils.isEmpty(rsltList)) {
				for (Map rsltMap : rsltList) {
					String crdtNum = (String)rsltMap.get("CRDT_FULL_NUM");
					if (ObjUtils.isNotEmpty(crdtNum)) {
						rsltMap.put("CRDT_FULL_NUM_EXPOS", decrypto.getDecrypto("1", crdtNum));
					} else {
						rsltMap.put("CRDT_FULL_NUM_EXPOS", "");
					}

					String accntNum = (String)rsltMap.get("ACCOUNT_NUM");
					if (ObjUtils.isNotEmpty(accntNum)) {
						rsltMap.put("ACCOUNT_NUM_EXPOS", decrypto.getDecrypto("1", accntNum));
					} else {
						rsltMap.put("ACCOUNT_NUM_EXPOS", "");
					}
				}
			}
		}
		return rsltList;
	}

	/**
	 * 매입매출구분
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> purSaleTypePopup( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.purSaleTypePopup", param);
	}

	/**
	 * 증빙유형
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> proofPopup( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.proofPopup", param);
	}

	/**
	 * 전자발행여부
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> emissionPopup( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.emissionPopup", param);
	}

	/**
	 * <pre>
	 * 통장번호
	 * seed.decryto(bankAccntCode) 에서 NullPointException오류가 발행하면,
	 * 암호화 되지 않은 계좌번호가 들어있을 때 발행함.
	 * </pre>
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> bankBookPopup( Map param ) throws Exception {

		//return super.commonDao.list("popupServiceImpl.creditNoPopup", param);
		List<Map<String, Object>> rsltList = super.commonDao.list("popupServiceImpl.bankBookPopup", param);

		if (DevFreeUtils.getOrDefault(param.get("DEC_FLAG"), "").equals("Y")) {  //복호화된 상태로 조회 시..
			if (!ObjUtils.isEmpty(rsltList)) {
				for (Map decMap : rsltList) {
					if (!ObjUtils.isEmpty(decMap.get("DEPOSIT_NUM"))) { //계좌번호 복호화
						try {
							//decryto() second 파라미터 : "RR"-주민번호   "RP"-여권번호   "RV"-비자번호  "RB"-계좌번호   "RC"-신용카드번호   "RF"-외국인 등록번호
							decMap.put("DEPOSIT_NUM_MASK", decrypto.decryto(decMap.get("DEPOSIT_NUM").toString(), "RB"));
							decMap.put("DEPOSIT_NUM_VAL", decrypto.decryto(decMap.get("DEPOSIT_NUM").toString(), "RB"));
						} catch (Exception e) {
							decMap.put("DEPOSIT_NUM_MASK", "데이타 오류(" + decMap.get("DEPOSIT_NUM").toString() + ")");
							decMap.put("DEPOSIT_NUM_VAL", "데이타 오류(" + decMap.get("DEPOSIT_NUM").toString() + ")");
						}
					} else {
						decMap.put("CRDT_FULL_NUM_MASK", "");
					}

					String crdtNum = (String)decMap.get("DEPOSIT_NUM");
					if (ObjUtils.isNotEmpty(crdtNum)) {
						decMap.put("DEPOSIT_NUM_EXPOS", decrypto.getDecrypto("1", crdtNum));
					} else {
						decMap.put("DEPOSIT_NUM_EXPOS", "");
					}
				}
			}
			return (List)rsltList;

		} else {
			for (Map rsltMap : rsltList) {
				String crdtNum = (String)rsltMap.get("DEPOSIT_NUM");
				if (ObjUtils.isNotEmpty(crdtNum)) {
					rsltMap.put("DEPOSIT_NUM_EXPOS", decrypto.getDecrypto("1", crdtNum));
				} else {
					rsltMap.put("DEPOSIT_NUM_EXPOS", "");
				}
			}
		}
		return rsltList;
	}

	/**
	 * 통장코드
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> bankBookCodePopup( Map param ) throws Exception {
		//return super.commonDao.list("popupServiceImpl.creditNoPopup", param);
		List<Map<String, Object>> rsltList = super.commonDao.list("popupServiceImpl.bankBookCodePopup", param);
		for (Map rsltMap : rsltList) {
			String crdtNum = (String)rsltMap.get("BANK_ACCOUNT");
			if (ObjUtils.isNotEmpty(crdtNum)) {
				rsltMap.put("BANK_ACCOUNT", decrypto.decryto(crdtNum));
			} else {
				rsltMap.put("BANK_ACCOUNT", "");
			}
		}
		return rsltList;
	}

	/**
	 * 차입금번호
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> debtNoPopup( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.debtNoPopup", param);
	}

	/**
	 * 계좌 번호
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> bankAccntPopup( Map param ) throws Exception {
		String bankAccnt = (String)param.get("BANK_ACCOUNT");
		//logger.debug("===================== bankAccnt " + bankAccnt);
		if (!ObjUtils.isEmpty(bankAccnt)) {
			String decBankAccnt = encrypto.encryto(bankAccnt);
			param.put("BANK_ACCOUNT", decBankAccnt);
		}

		List<Map<String, Object>> rsltList = super.commonDao.list("popupServiceImpl.bankAccntPopup", param);

		for (Map rsltMap : rsltList) {
			String bankAccntCode = (String)rsltMap.get("BANK_ACCNT_CODE");
			if (ObjUtils.isNotEmpty(bankAccntCode)) {
				rsltMap.put("BANK_ACCNT_EXPOS", decrypto.getDecrypto("1", bankAccntCode));
			} else {
				rsltMap.put("BANK_ACCNT_EXPOS", "");
			}
		}
		return rsltList;  //  super.commonDao.list("popupServiceImpl.bankAccntPopup", param);
	}

	/**
	 * 거래은행 번호
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> businessBankPopup( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.businessBankPopup", param);
	}

	/**
	 * 통화코드 번호
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> moneyUnitPopup( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.moneyUnitPopup", param);
	}

	/* BUDG_NAME컬럼수 */
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "accnt" )
	// BUDG_NAME컬럼수
	public List<Map<String, Object>> selectBudgName( Map param ) throws Exception {
		List<Map<String, Object>> rList = null;
		String dbms = ConfigUtil.getString("common.dbms", "");

		if (dbms.equals("") || dbms.equals("SQL")) {
			// default :: MS-SQL 용
			return super.commonDao.list("accntCommonService.selectBudgName", param);
		} else if (dbms.equals("CUBRID")) {
			return commonServiceImpl_KOCIS_CUBRID.fnGetBudgLevelName(param);
		}
		return rList;
	}

	/**
	 * 예산과목
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> budgPopup( Map param ) throws Exception {
		//		List<Map> codeLevelInfoList = (List<Map>)super.commonDao.list("popupServiceImpl.codeLevel", param);
		String dbms = ConfigUtil.getString("common.dbms", "");
		List<Map<String, Object>> rList = null;

		if (dbms.equals("") || dbms.equals("SQL")) {
			// default :: MS-SQL 용
			if(!param.get("BUDG_TYPE").toString().equals("")){
				return super.commonDao.list("popupServiceImpl.budgPopupGba", param);
			}

			List budgNameInfoList = super.commonDao.list("accntCommonService.selectBudgName", param);
			param.put("budgNameInfoList", budgNameInfoList);

			String acYyyy = "";
			acYyyy = param.get("AC_YYYY").toString();
			String pAcYyyy = acYyyy.toString().substring(0, 4);
			int acDateLength = pAcYyyy.length();
			if (pAcYyyy.isEmpty() || acDateLength != 4) {
				Map acDate = (Map)super.commonDao.queryForObject("popupServiceImpl.selectAcYyyy", param);
				String acYyyy2 = "";
				acYyyy2 = acDate.get("AC_YYYY").toString();
				String sAcYyyy = acYyyy2.toString().substring(0, 4);
				param.put("AC_YYYY", sAcYyyy);
				return super.commonDao.list("popupServiceImpl.budgPopup", param);
			} else {
				String acYyyy3 = "";
				acYyyy3 = param.get("AC_YYYY").toString();
				String bAcYyyy = acYyyy3.toString().substring(0, 4);
				param.put("AC_YYYY", bAcYyyy);
				return super.commonDao.list("popupServiceImpl.budgPopup", param);
			}
		} else if (dbms.equals("CUBRID")) {
			String acYyyy = "";
			acYyyy = param.get("AC_YYYY").toString();
			String pAcYyyy = acYyyy.toString().substring(0, 4);
			int acDateLength = pAcYyyy.length();
			if (pAcYyyy.isEmpty() || acDateLength != 4) {
				Map acDate = null;
				if (param.get("AC_YYYY") == null || ( (String)param.get("AC_YYYY") ).length() == 0) {
					acDate = (Map)super.commonDao.queryForObject("popupServiceImpl.selectAcYyyy_01", param);
				} else {
					acDate = (Map)super.commonDao.queryForObject("popupServiceImpl.selectAcYyyy_02", param);
				}
				String acYyyy2 = acDate.get("AC_YYYY").toString();
				String sAcYyyy = acYyyy2.toString().substring(0, 4);
				param.put("AC_YYYY", sAcYyyy);

			} else {
				param.put("AC_YYYY", pAcYyyy);
			}

			Map rMap = (Map)super.commonDao.queryForObject("popupServiceImpl.budgPopup_01", param);
			List list = commonServiceImpl_KOCIS_CUBRID.fnGetBudgLevelName(param);
			List iList = new ArrayList<Map<String, Object>>();
			for (int i = 0; i < list.size(); i++) {
				iList.add(rMap.get("LEVEL_LEN" + ( i + 1 )));
			}

			param.put("TYPE_KEY", rMap.get("TYPE_KEY"));
			param.put("budgNameInfoList", iList);
			logger.info("iList :: {}", iList);

			super.commonDao.update("popupServiceImpl.budgPopup_02", param);

			rList = super.commonDao.list("popupServiceImpl.budgPopup_03", param);

			super.commonDao.update("popupServiceImpl.budgPopup_04", param);
		}

		return rList;
	}

	/**
	 * 지급처
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> payCustomPopup( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.payCustomPopup", param);
	}

	/**
	 * 회사정보
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "Popup" )
	public List<Map<String, Object>> compPopup( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.compPopup", param);
	}

	/**
	 * 채권번호
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "Popup" )
	public List<Map<String, Object>> confRecePopup( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.confRecePopup", param);
	}

	/**
	 * 가지급전표
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> advmReqSlipNo( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.advmReqSlipNo", param);
	}

	/**
	 * 공통코드 동적 팝업
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> commonPopup( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.commonPopup", param);
	}

	/**
	 * 사용자정의 동적 팝업
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> userDefinePopup( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.userDefinePopup", param);
	}

	@ExtDirectMethod( value = ExtDirectMethodType.TREE_LOAD, group = "Popup" )
	public UniTreeNode deptTreeList( Map param ) throws Exception {
		/**
		 * 1. result Class 확인(foren.framework.lib.tree.GenericTreeDataMap)! 2. SQL의 수행 결과 순서는 parent가 child보더 먼저 나오게 구성 되어야 함. 3. id와 parentId는 필수 ! 4. 최상의 node는 parentId가 root로 지정 되어야 함.
		 */
		List<GenericTreeDataMap> menuList = super.commonDao.list("popupServiceImpl.deptTreeList", param);
		return UniTreeHelper.makeTreeAndGetRootNode(menuList);
	}

	@ExtDirectMethod( value = ExtDirectMethodType.TREE_LOAD, group = "Popup" )
	public UniTreeNode pjtTreeList( Map param ) throws Exception {
		/**
		 * 1. result Class 확인(foren.framework.lib.tree.GenericTreeDataMap)! 2. SQL의 수행 결과 순서는 parent가 child보더 먼저 나오게 구성 되어야 함. 3. id와 parentId는 필수 ! 4. 최상의 node는 parentId가 root로 지정 되어야 함.
		 */
		List<GenericTreeDataMap> menuList = super.commonDao.list("popupServiceImpl.pjtTreeList", param);
		return UniTreeHelper.makeTreeAndGetRootNode(menuList);
	}

	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> pjtPopupW( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.pjtPopupW", param);
	}

	//팝업 USE_YN = 'Y' 인 데이터
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> pjtPopupGridList( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.pjtTreeList2", param);
	}

	/**
	 * 구매카드정보 팝업
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> purchaseCardPopup( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.purchaseCardPopup", param);
	}

	/**
	 * 공통코드 관련 (ABA210T) - 관리항목
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> comAba210Popup( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.comAba210Popup", param);
	}

	/**
	 * 미결항목 관련 (ABA900T) - 미결항목
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> comAba900Popup( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.comAba900Popup", param);
	}

	/* -----------------------------------------회계팝업 끝------------------------------------- */
	/**
	 * 비과세코드 (인사)
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> nonTaxPopup( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.nonTaxPopup", param);
	}

	/**
	 * 템플릿 팝업
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> templatePopup( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.templatePopup", param);
	}

	/**
	 * IFRS - 자산코드
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> IFRSassetPopup( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.fnGetAsset", param);
	}

	/**
	 * 예산과목(CODE_NAME) 관련
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> selectBudgName( Map param, LoginVO loginVO ) throws Exception {
		List<Map<String, Object>> rList = null;
		String dbms = ConfigUtil.getString("common.dbms", "");

		param.put("S_COMP_CODE", loginVO.getCompCode());
		param.put("S_USER_ID", loginVO.getUserID());

		if (dbms.equals("") || dbms.equals("SQL")) {
			// default :: MS-SQL 용
			return super.commonDao.list("popupServiceImpl.selectBudgName", param);
		} else if (dbms.equals("CUBRID")) {
			param.put("S_COMP_CODE", loginVO.getCompCode());
			param.put("S_USER_ID", loginVO.getUserID());

			return commonServiceImpl_KOCIS_CUBRID.fnGetBudgLevelName(param);
		}
		return rList;
	}

	/**
	 * 카드번호 암복호화 관련 CRDT_FULL_NUM
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public String incryptDecryptPopup( Map param ) throws Exception {
		String returnStr = "";

		String incDrcGbn = (String)param.get("INCDRC_GUBUN");
		if ("INC".equals(incDrcGbn)) {
			String targetStr = (String)param.get("DECRYP_WORD");
			logger.debug("=============INC  targetStr = " + targetStr);
			returnStr = encrypto.encryto(decrypto.getDecrypto("1", targetStr));
		} else if ("DEC".equals(incDrcGbn)) {
			String targetStr = (String)param.get("INCRYP_WORD");
			logger.debug("=============DEC  targetStr = " + targetStr);
			returnStr = decrypto.getDecrypto("1", targetStr);
		} else {
			returnStr = "";
		}

		logger.debug("=============  incDrcGbn = " + incDrcGbn + "======  returnStr = " + returnStr);
		//String det = seed.decryto(ent);

		return returnStr;
	}

	@ExtDirectMethod( group = "Popup" , value = ExtDirectMethodType.FORM_LOAD)
	public Object incryptDecryptPopupForm( Map param ) throws Exception {
		String returnStr = "";
		Map r = new HashMap();
		String incDrcGbn = (String)param.get("INCDRC_GUBUN");
		if ("INC".equals(incDrcGbn)) {
			String targetStr = (String)param.get("DECRYP_WORD");
			logger.debug("=============INC  targetStr = " + targetStr);
			returnStr = encrypto.encryto(decrypto.getDecrypto("1", targetStr));
			r.put("INC_WORD", returnStr);
			r.put("DECRYP_WORD", targetStr);
		} else if ("DEC".equals(incDrcGbn)) {
			String targetStr = (String)param.get("INCRYP_WORD");
			logger.debug("=============DEC  targetStr = " + targetStr);
			returnStr = decrypto.getDecrypto("1", targetStr);
			r.put("INC_WORD", targetStr);
			r.put("DECRYP_WORD", returnStr);

		} else {
			returnStr = "";
		}

		logger.debug("=============  incDrcGbn = " + incDrcGbn + "======  returnStr = " + returnStr);
		//String det = seed.decryto(ent);

		return r;
	}

	/**
	 * 일반 암복호화 관련
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public String encryptPopup( Map param ) throws Exception {
		String returnStr = "";
		String strEncrypt = ObjUtils.getSafeString(param.get("INC_WORD"));
		String strDecrypt = ObjUtils.getSafeString(param.get("DECRYPT"));
		String cryptGbn = ObjUtils.getSafeString(param.get("CRYPTGBN"));

		if ("ToEncrypt".equals(cryptGbn)) {
			returnStr = encrypto.encryto(strDecrypt);
		} else {
			returnStr = decrypto.getDecrypto("1", strEncrypt);
		}

		return returnStr;
	}

	/**
	 * 암복호화 관련 읽기용 팝업관련 20181002
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public String decryptPopup( Map param ) throws Exception {
		String returnStr = "";
		returnStr = decrypto.getDecryptWithType(param.get("INCRYP_WORD"),param.get("S_COMP_CODE") , "", "");
		return returnStr;
	}

	/**
	 * 클레임번호 팝업
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> claimPopup( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.claimPopup", param);
	}

	//관리코드팝업(Z_ZCC600T_KD)
	@ExtDirectMethod(group = "Popup")
	public List<Map<String, Object>> entryNumPopup1( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.entryNumPopup1", param);
	}
	//관리코드팝업(Z_ZCC700T_KD)
	@ExtDirectMethod(group = "Popup")
	public List<Map<String, Object>> entryNumPopup2( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.entryNumPopup2", param);
	}
	//장비번호 (EQU_CODE)
	@ExtDirectMethod(group = "Popup")
	public List<Map<String, Object>> equCodePopup( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.equCodePopup", param);
	}

	/**
	 * 설비정보_정규
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> equMachCodePopup( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.equMachCodePopup", param);
	}

	/**
	 * 금형정보_정규
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> equMoldCodePopup( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.equMoldCodePopup", param);
	}

	/**
	 * 코어정보_정규
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> coreCodePopup( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.coreCodePopup", param);
	}

	//소모공구 정보 (TREE_CODE)
	@ExtDirectMethod(group = "Popup")
	public List<Map<String, Object>> treeCodePopup( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.treeCodePopup", param);
	}
	//접수번호 (AS_NUM)
	@ExtDirectMethod(group = "Popup")
	public List<Map<String, Object>> asNumPopup( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.asNumPopup", param);
	}

	/**
	 * SMS 전송용 데이터 조회(발신자 번호 조회)
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public Object selectSendPhon( Map param ) throws Exception {
		return super.commonDao.select("popupServiceImpl.selectSendPhon", param);
	}

	/**
	 * SMS 전송용 데이터 조회(거래처 정보 조회 : 뿌리오 agent)
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> selectSMSData( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.selectSMSData", param);
	}

	/**
	 * SMS 발송 (뿌리오 agent)
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "popup")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveSMS(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		if(paramList != null)   {
			List<Map> insertList = null;

			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("sendSMS")) {
					insertList = (List<Map>)dataListMap.get("data");
				}
			}
			if(insertList != null) this.sendSMS(insertList, paramMaster, user);
		}
		paramList.add(0, paramMaster);
		return  paramList;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "popup")
	private void sendSMS( List<Map> paramList, Map paramMaster, LoginVO user ) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>)paramMaster.get("data");
		String sendPhon = (String)dataMaster.get("SEND_PHONE");

		for(Map param: paramList)	  {
			String keyValue = getLogKey();
			param.put("KEY_VALUE"	, keyValue);
			param.put("SEND_PHONE"	, sendPhon);

			super.commonDao.insert("popupServiceImpl.insertSMSMsg", param);
		}
		return;
	}

	//모니터정보 팝업(Z_ZEE200T_KD)
	@ExtDirectMethod(group = "Popup")
	public List<Map<String, Object>> mRegNumPopup( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.mRegNumPopup", param);
	}

	//SW정보 팝업(Z_ZEE100T_KD)
	@ExtDirectMethod(group = "Popup")
	public List<Map<String, Object>> swCodePopup( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.swCodePopup", param);
	}

	/**
	 * 농가입고정보 데이터 조회()
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> farmInout( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.farmInout", param);
	}

	/**
	 * 사업자별 품목정보 팝업(양평)
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> divPumokPopup_YP( Map param, LoginVO loginVO ) throws Exception {
		this.setSpecSearch(param, loginVO);

		if (ObjUtils.isNotEmpty(param.get("ITEM_CODE")) && "true".equals(ObjUtils.getSafeString(param.get("isFieldSearch")))) {
			param.put("ITEM_CODE", this.getNumreicCode("ITEM_CODE", param.get("ITEM_CODE").toString(), param.get("S_COMP_CODE").toString()));
		}
		return super.commonDao.list("popupServiceImpl.divPumok_YP", param);
	}
	
	/**
	 * 사업자별 품목정보 팝업(엠아이텍(대리점))
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> divPumokPopup_Agent( Map param, LoginVO loginVO ) throws Exception {
		this.setSpecSearch(param, loginVO);
		StringBuilder errorMessage = new StringBuilder("");
		
		if (ObjUtils.isNotEmpty(param.get("ITEM_CODE")) && "true".equals(ObjUtils.getSafeString(param.get("isFieldSearch")))) {
			param.put("ITEM_CODE", this.getNumreicCode("ITEM_CODE", param.get("ITEM_CODE").toString(), param.get("S_COMP_CODE").toString()));
		}
		List<Map<String, Object>> r =  externalDAO.list("popupServiceImpl.divPumok_Agent", param ,errorMessage);
		if(ObjUtils.isNotEmpty(errorMessage))	{
    		throw new	UniDirectValidateException(errorMessage.toString());
    	}
		return  r;
	}

	/**
	 * 작업지시정보_KDG
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> wkordNum_KDG( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.wkordNum_KDG", param);
	}

	/**
	 * 목형정보
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> woodenCode( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.woodenCode", param);
	}

	/**
	 * 작업지시정보_JW
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> wkordNum_JW( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.wkordNum_JW", param);
	}

	/**
	 * 창고 팝업
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> whCodePopup( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.whCodePopup", param);
	}

	/**
	 * Program 팝업
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> programPopup( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.programPopup", param);
	}

	/**
	 * 성분 팝업
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> chemicalPopup( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.chemicalPopup", param);
	}

	/**
	 * 자동분개 목록 팝업
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> selectAutoPopup( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.selectAutoPopup", param);
	}

	/**
	 * LAP NO 팝업
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> labNoPopup( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.labNoPopup", param);
	}

	/**20190909
	 * LOT ITEM 팝업: 그리드용 (멀티 선택), 현재고 > 0, 품목 팝업 대신 사용 (출고등록(건별)(LOT팝업) (str106ukrv))
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> lotItemPopup( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.lotItemPopup", param);
	}

	/**
	 * LOT 재고 팝업 (MIT) - 20191113 추가
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> lotNoPopup_mit( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.lotNoPopup_mit", param);
	}

	/**
	 * 실사일(외주) 팝업 - 20200217 신규 생성
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> countdateoutPopup( Map param ) throws Exception {
		logger.debug(ObjUtils.toJsonStr(param).toString());
		return super.commonDao.list("popupServiceImpl.countdateoutPopup", param);
	}

	/**
	 * 출하지시번호 조회 팝업 - 20200228 신규 생성
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> issueReqNumPopup( Map param ) throws Exception {
		logger.debug(ObjUtils.toJsonStr(param).toString());
		return super.commonDao.list("popupServiceImpl.issueReqNumPopup", param);
	}

	/**
	 * MIT IFRS - 자산코드
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> s_asset_mitPopup( Map param ) throws Exception {

		return super.commonDao.list("popupServiceImpl.s_asset_mitPopup", param);
	}

	/**
	 * LOT 재고 팝업 (IN) - 20200605 추가
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> lotNoPopup_in( Map param ) throws Exception {
		return super.commonDao.list("popupServiceImpl.lotNoPopup_in", param);
	}
	/**
	 *
	 * 구매확인서번호
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "Popup")
	public List<Map<String, Object>> selectPurchDocNoPopupList(Map param) throws Exception {
		return super.commonDao.list("popupServiceImpl.selectPurchDocNoPopup", param);
	}

	/**
	 *
	 * 판매이력 S/N팝업(MIT)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "Popup")
	public List<Map<String, Object>> selectSasLotPopupList(Map param) throws Exception {
		return super.commonDao.list("popupServiceImpl.selectSaslotPopup", param);
	}
	/**
	 *
	 * 접수번호팝업(MIT)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "Popup")
	public List<Map<String, Object>> selectReceiptNumPopup(Map param) throws Exception {
		return super.commonDao.list("popupServiceImpl.selectReceiptNumPopup", param);
	}

	/**
	 *
	 * 수리견적번호팝업(MIT)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "Popup")
	public List<Map<String, Object>> selectQuotNumPopup(Map param) throws Exception {
		return super.commonDao.list("popupServiceImpl.selectQuotNumPopup", param);
	}

	/**
	 *
	 * 수리번호팝업(MIT)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "Popup")
	public List<Map<String, Object>> selectRepairNumPopup(Map param) throws Exception {
		return super.commonDao.list("popupServiceImpl.selectRepairNumPopup", param);
	}

	/**
	 *
	 * 수리이력팝업(MIT)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "Popup")
	public List<Map<String, Object>> selectRepairHistoryPopup(Map param) throws Exception {
		return super.commonDao.list("popupServiceImpl.selectRepairHistoryPopup", param);
	}

	/**
	 *
	 * 공정불량팝업
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "Popup")
	public List<Map<String, Object>> selectBadCodePopup(Map param) throws Exception {
		return super.commonDao.list("popupServiceImpl.selectBadCodePopup", param);
	}


	/**
	 * 사업자별 품목정보 팝업(월드와이드메모리) - 20201125 추가
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> divPumokPopup_WM( Map param, LoginVO loginVO ) throws Exception {
		this.setSpecSearch(param, loginVO);
		if (ObjUtils.isNotEmpty(param.get("ITEM_CODE")) && "true".equals(ObjUtils.getSafeString(param.get("isFieldSearch")))) {
			param.put("ITEM_CODE", this.getNumreicCode("ITEM_CODE", param.get("ITEM_CODE").toString(), param.get("S_COMP_CODE").toString()));
		}
		return super.commonDao.list("popupServiceImpl.divPumok_WM", param);
	}

	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> asDivPumokPopup( Map param, LoginVO loginVO ) throws Exception {

		if(ObjUtils.isNotEmpty(param.get("ITEM_ACCOUNT"))){
			param.put("ITEM_ACCOUNT_ARRAY", ArrayUtil.toArray(param.get("ITEM_ACCOUNT"))); // multiSelect 조건을 위해  ITEM_ACCOUNT 배열형식으로 변환
		}
		if (ObjUtils.isNotEmpty(param.get("ITEM_CODE")) && "true".equals(ObjUtils.getSafeString(param.get("isFieldSearch")))) {
			param.put("ITEM_CODE", this.getNumreicCode("ITEM_CODE", param.get("ITEM_CODE").toString(), param.get("S_COMP_CODE").toString()));
		}
		List<Map<String, Object>> rList= super.commonDao.list("popupServiceImpl.as_Pumok_code", param);

		return rList ;
	}

	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> selectASAssetPopup( Map param, LoginVO loginVO ) throws Exception {

		List<Map<String, Object>> rList= super.commonDao.list("popupServiceImpl.selectASAssetPopup", param);

		return rList ;
	}

	/**
	 * 외부 사용자용 팝업 - 20210803
	 * @param param
	 * @param loginVO
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> vmiPumokPopup( Map param, LoginVO loginVO ) throws Exception {
		List<Map<String, Object>> rList = null;
		rList = super.commonDao.list("popupServiceImpl.vmiPumok", param);
		return rList ;
	}
	
	/**
	 * 모델 팝업 - 멕아이씨에스 20210823
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> modelPopup( Map param, LoginVO loginVO ) throws Exception {
		return super.commonDao.list("popupServiceImpl.selectModelPopup_MICS", param);
	}
	
	/**
	 * 202109 jhj: 원산지 팝업 (양평농협 전용)
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Popup" )
	public List<Map<String, Object>> wonsangiPopup( Map param, LoginVO loginVO ) throws Exception {
		return super.commonDao.list("popupServiceImpl.selectWonsangiPopup", param);
	}
}