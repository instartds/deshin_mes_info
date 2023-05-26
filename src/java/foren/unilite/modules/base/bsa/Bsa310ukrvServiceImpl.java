package foren.unilite.modules.base.bsa;

import java.io.Console;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.sec.cipher.seed.EncryptSHA256;
import foren.framework.utils.MessageUtils;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.utils.UniliteUtil;
import foren.unilite.com.validator.UniDirectValidateException;



@Service( "bsa310ukrvService" )
@SuppressWarnings( { "rawtypes", "unchecked" } )
public class Bsa310ukrvServiceImpl extends TlabAbstractServiceImpl {
	
	private final Logger	logger	= LoggerFactory.getLogger(this.getClass());
	private EncryptSHA256	enc		= new EncryptSHA256();

	/**
	 * old비밀번호 check
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "base", value = ExtDirectMethodType.STORE_READ )
	public Object oldPwdCheck( Map param ) throws Exception {
		param.put("OLD_PWD", enc.encrypt(ObjUtils.getSafeString(param.get("OLD_PWD"))));
		return super.commonDao.select("bsa310ukrvServiceImpl.oldPwdCheck", param);
	}

	/**
	 * 비밀번호 규칙 check
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "base", value = ExtDirectMethodType.STORE_READ )
	public List<Map<String, Object>> pwRuleCheck( Map param ) throws Exception {
		return super.commonDao.list("bsa310ukrvServiceImpl.pwRuleCheck", param);
	}

	/**
	 * 생일, 전화번호 체크
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "base", value = ExtDirectMethodType.STORE_READ )
	public Object birthTelCheck( Map param ) throws Exception {
		return super.commonDao.select("bsa310ukrvServiceImpl.birthTelCheck", param);
	}

	/**
	 * 최근비밀번호 체크갯수
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "base", value = ExtDirectMethodType.STORE_READ )
	public Object pwCheckQ( Map param ) throws Exception {
		return super.commonDao.select("bsa310ukrvServiceImpl.pwCheckQ", param);
	}

	/**
	 * 입력한 비밀번호가 현재 비밀번호와 같은지 조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "base", value = ExtDirectMethodType.STORE_READ )
	public Object pwDuplicateCheck( Map param ) throws Exception {
		param.put("NEW_PWD", enc.encrypt(ObjUtils.getSafeString(param.get("NEW_PWD"))));
		return super.commonDao.select("bsa310ukrvServiceImpl.pwDuplicateCheck", param);
	}

	/**
	 * 입력한 비밀번호가 이전사용한 x개의 비밀번호와 같은지 조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "base", value = ExtDirectMethodType.STORE_READ )
	public Object pwSameCheck( Map param ) throws Exception {
		return super.commonDao.select("bsa310ukrvServiceImpl.pwSameCheck", param);
	}

	/**
	 * 저장전 비밀번호 암호화 적용 여부 체크
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "base", value = ExtDirectMethodType.STORE_READ )
	public Object encryptionYN( Map param ) throws Exception {
		return super.commonDao.select("bsa310ukrvServiceImpl.encryptionYN", param);
	}

	/**
	 * 암호화된 비밀번호 저장
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "base", value = ExtDirectMethodType.STORE_READ )
	public Object encryptionSavePw( Map param ) throws Exception {
		param.put("CHG_PWD", enc.encrypt(ObjUtils.getSafeString(param.get("NEW_PWD"))));
		return super.commonDao.update("bsa310ukrvServiceImpl.encryptionSavePw", param);
	}

	/**
	 * 비암호화된 비밀번호 저장
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "base", value = ExtDirectMethodType.STORE_READ )
	public Object notEncryptionSavePw( Map param ) throws Exception {
		return super.commonDao.update("bsa310ukrvServiceImpl.notEncryptionSavePw", param);
	}

	/**
	 * 비암호화된 비밀번호 저장
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "base")
	public Map<String, Object> selectPasswordValidate( Map param, LoginVO user, ExtHtttprequestParam _req ) throws Exception {
		Map<String, Object> rtn = new HashMap<String, Object>();
		String newPwd = ObjUtils.getSafeString(param.get("NEW_PWD"));
		String userId = user.getUserID();
		String errorMessage = "";

		Map<String, Object> oldPwdChk = (Map<String, Object>) this.oldPwdCheck(param);
		if(oldPwdChk == null) {
			errorMessage += MessageUtils.getMessage("system.label.base.oldpassword", _req)+"가 일치하지 않습니다."; //
		}
		if(newPwd.indexOf(userId) > -1){
			errorMessage += MessageUtils.getMessage("system.message.base.passconfirm2", _req); // 부적합 - 비밀번호에 아이디 포함 오류
		}

		Map<String, Object> birthTelCheck = (Map<String, Object>) this.birthTelCheck(param);
		if(birthTelCheck != null) {
			String birthDay = ObjUtils.getSafeString(birthTelCheck.get("BIR"));
			if(newPwd.indexOf(birthDay) > -1) {
				if(!"".equals(errorMessage))	errorMessage += "\n";
				errorMessage +=  MessageUtils.getMessage("system.message.base.passconfirm3", _req); //"부적합 - 비밀번호에 생일 포함오류";
			}
			String tel = ObjUtils.getSafeString(birthTelCheck.get("TEL"));
			if(newPwd.indexOf(tel) > -1) {
				if(!"".equals(errorMessage))	errorMessage += "\n";
				errorMessage += MessageUtils.getMessage("system.message.base.passconfirm4", _req); //"부적합 - 비밀번호에 전화번호 뒷자리 4자 포함오류";
			}
		}

		// 비밀번호가 암호화 되어 param값이 변경 되므로 새로 생성
		Map<String, Object> encParam = new HashMap();
		encParam.put("S_USER_ID", param.get("S_USER_ID"));
		encParam.put("NEW_PWD", param.get("NEW_PWD"));
		Map<String, Object> duplicatCheck = (Map<String, Object>) this.pwDuplicateCheck(encParam);

		if(duplicatCheck != null) {
			if(!"".equals(errorMessage))	errorMessage += "\n";
			errorMessage += MessageUtils.getMessage("system.message.base.passconfirm10", _req); //"부적합 - 이전 비밀번호와 동일오류";
		}

		Map<String, Object> pwCheckQ = (Map<String, Object>) this.pwCheckQ(param);
		int dCycleCnt = 0;
		if(pwCheckQ != null) { 
			dCycleCnt = ObjUtils.parseInt(pwCheckQ.get("CYCLE_CNT"), 0);
			if(dCycleCnt == 0){
				dCycleCnt = 2;
			}
		}

		param.put("DCYCLE_CNT", dCycleCnt);
		Map<String, Object> pwSameCheck = (Map<String, Object>)  this.pwSameCheck(param);
		if(pwSameCheck != null) {
			if(!"".equals(errorMessage))	errorMessage += "\n";
			errorMessage += MessageUtils.getMessage("system.message.base.passconfirm8", _req)+ ObjUtils.getSafeString(dCycleCnt, "1") + MessageUtils.getMessage("system.message.base.passconfirm9", _req) ; //"부적합 - 최근 사용한 " + ObjUtils.getSafeString(dCycleCnt) + "개의 비밀번호와 동일오류";
		}
		String strAlpabet = "abcdeghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
		String strNumber  = "01234567890";
		String strSpecial = "-!\"#$%&`()*+`-./:;<=>?{|}~@[,]^_";
		String strSer1 = "qazwsxedcrfvtgbyhnujmikolpQAZWSXEDCRFVTGBYHNUJMIKOLP";
		String strSer2 = "plokmijnuhbygvtfcrdxeszwaqPLOKMIJNUHBYGVTFCRDXESZWAQ";
		String strSer3 = "qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM";
		String strSer4 = "poiuytrewqlkjhgfdsamnbvcxzPOIUYTREWQLKJHGFDSAMNBVCXZ";
		int  chkN = 0
			,chkS = 0
			,chkA = 0
			,chkSe =0;
		String temp = "";
		for (int i=0 ; i <= newPwd.length()-1 ; i++) {
			if (strAlpabet.indexOf(newPwd.charAt(i)) > -1) {
				chkA = 1;
			}
			if (strNumber.indexOf(newPwd.charAt(i)) > -1) {
				chkN = 1;
			}
			if (strSpecial.indexOf(newPwd.charAt(i)) > -1) {
				chkS = 1;
			}
			if(newPwd.length() -3 > i) {
				if (strAlpabet.indexOf(newPwd.substring(i,i+3)) > -1) {
					temp =newPwd.substring(i,i+3);
					chkSe++;
				}
				if (strNumber.indexOf(newPwd.substring(i,i+3)) > -1) {
					temp =newPwd.substring(i,i+3);
					chkSe++;
				}
				if (strSer1.indexOf(newPwd.substring(i,i+3)) > -1) {
					temp =newPwd.substring(i,i+3);
					chkSe++;
				}
				if (strSer2.indexOf(newPwd.substring(i,i+3)) > -1) {
					temp =newPwd.substring(i,i+3);
					chkSe++;
				}
				if (strSer3.indexOf(newPwd.substring(i,i+3)) > -1) {
					temp =newPwd.substring(i,i+3);
					chkSe++;
				}
				if (strSer4.indexOf(newPwd.substring(i,i+3)) > -1) {
					temp =newPwd.substring(i,i+3);
					chkSe++;
				}
			}
		}
		if(chkSe > 0){
			logger.debug(" ######	temp : "+ temp);;
			if(!"".equals(errorMessage))	errorMessage += "\n";
			errorMessage += MessageUtils.getMessage("system.message.base.passconfirm5", _req); //"부적합 - 연속적인 문자/숫자가 3단어 이상 포함 오류";
		}
		else if(newPwd.length() < 9){
			if(!"".equals(errorMessage))	errorMessage += "\n";
			errorMessage += MessageUtils.getMessage("system.message.base.passconfirm6", _req); //"부적합 - 비밀번호 9자리 이상 오류";
		}else if((chkN + chkA + chkS) < 3) {
			if(!"".equals(errorMessage))	errorMessage += "\n";
			errorMessage += MessageUtils.getMessage("system.message.base.passconfirm7", _req); //"부적합 - 영대/소문자, 숫자, 특수문자 모두 포함 오류";
		}
		if(!"".equals(errorMessage)) {
			rtn.put("errorMessage", errorMessage);
		}
		logger.debug("###################  errorMessage : "+errorMessage);
		return rtn;
	}
}