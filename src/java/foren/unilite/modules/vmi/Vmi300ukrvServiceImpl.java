package foren.unilite.modules.vmi;

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


@Service("vmi300ukrvService")
@SuppressWarnings( { "rawtypes", "unchecked" } )
public class Vmi300ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger	= LoggerFactory.getLogger(this.getClass());
	private EncryptSHA256 enc	= new EncryptSHA256();
	
	/**
	 * old비밀번호 check
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "vmi", value = ExtDirectMethodType.STORE_READ )
	public Object oldPwdCheck( Map param ) throws Exception {
		boolean bSecurityFlag	= false;
		String sCaseSensitiveYN	= "N";

		Map<String, Object> setInfo = this.checkEncryptYN();
		if (setInfo == null) bSecurityFlag = false;
		else {
			bSecurityFlag = true;
			sCaseSensitiveYN = (String)setInfo.get("CASE_SENS_YN");
		}
		if ("N".equals(sCaseSensitiveYN)) {
			param.put("OLD_PWD", param.get("OLD_PWD").toString().toUpperCase());
		}
		return super.commonDao.select("vmi300ukrvServiceImpl.oldPwdCheck", param);
	}

	/**
	 * 20210426 추가 - 비밀번호 규칙 check
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "vmi", value = ExtDirectMethodType.STORE_READ )
	public List<Map<String, Object>> pwRuleCheck( Map param ) throws Exception {
		return super.commonDao.list("vmi300ukrvServiceImpl.pwRuleCheck", param);
	}

	/**
	 * 20210426 추가 - 최근비밀번호 체크갯수
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "vmi", value = ExtDirectMethodType.STORE_READ )
	public Object pwCheckQ( Map param ) throws Exception {
		return super.commonDao.select("vmi300ukrvServiceImpl.pwCheckQ", param);
	}

	/**
	 * 20210426 추가 - 입력한 비밀번호가 현재 비밀번호와 같은지 조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "vmi", value = ExtDirectMethodType.STORE_READ )
	public Object pwDuplicateCheck( Map param ) throws Exception {
//		param.put("NEW_PWD", enc.encrypt(ObjUtils.getSafeString(param.get("NEW_PWD"))));
		return super.commonDao.select("vmi300ukrvServiceImpl.pwDuplicateCheck", param);
	}

	/**
	 * 20210426 추가 - 입력한 비밀번호가 이전사용한 x개의 비밀번호와 같은지 조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "vmi", value = ExtDirectMethodType.STORE_READ )
	public Object pwSameCheck( Map param ) throws Exception {
		return super.commonDao.select("vmi300ukrvServiceImpl.pwSameCheck", param);
	}



	/**
	 * 20210426 추가 - 저장전 비밀번호 암호화 적용 여부 체크
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "vmi", value = ExtDirectMethodType.STORE_READ )
	public Object encryptionYN( Map param ) throws Exception {
		return super.commonDao.select("vmi300ukrvServiceImpl.encryptionYN", param);
	}

	/**
	 * 암호화된 비밀번호 저장
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "vmi", value = ExtDirectMethodType.STORE_READ )
	public Object encryptionSavePw( Map param ) throws Exception {
		boolean bSecurityFlag	= false;
		String sCaseSensitiveYN	= "N";

		Map<String, Object> setInfo = this.checkEncryptYN();
		if (setInfo == null) bSecurityFlag = false;
		else {
			bSecurityFlag = true;
			sCaseSensitiveYN = (String)setInfo.get("CASE_SENS_YN");
		}

		if ("N".equals(sCaseSensitiveYN)) {
			param.put("NEW_PWD", param.get("NEW_PWD").toString().toUpperCase());
		}
		super.commonDao.update("vmi300ukrvServiceImpl.insertPasswordLog", param);
		return super.commonDao.update("vmi300ukrvServiceImpl.encryptionSavePw", param);
	}

	/**
	 * 비밀번호 암호화 체크 및 대소문자 구분 여부
	 * @return
	 */
	private Map<String, Object> checkEncryptYN() {
		return (Map<String, Object>)super.commonDao.select("vmi300ukrvServiceImpl.checkEncryptYN");
	}
}