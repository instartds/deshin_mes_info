package foren.unilite.modules.base;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.tags.ComboItemModel;

@Service( "baseCommonService" )
@SuppressWarnings( { "unchecked", "rawtypes" } )
public class BaseCommonServiceImpl extends TlabAbstractServiceImpl {

	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@ExtDirectMethod( group = "base", value = ExtDirectMethodType.STORE_READ )
	public Object fnAutoNo( Map param ) throws Exception {
		return super.commonDao.select("baseCommonServiceImpl.fnAutoNo", param);
	}

	@ExtDirectMethod( group = "base", value = ExtDirectMethodType.STORE_READ )
	public Object fnLastYyMm( Map param ) throws Exception {
		return super.commonDao.select("baseCommonServiceImpl.fnLastYyMm", param);
	}

	@ExtDirectMethod( group = "base", value = ExtDirectMethodType.STORE_READ )
	public Object fnStockQ( Map param ) throws Exception {
		return super.commonDao.select("baseCommonServiceImpl.fnStockQ", param);
	}

	@ExtDirectMethod( group = "base", value = ExtDirectMethodType.STORE_READ )
	public Object fnStockPrice( Map param ) throws Exception {
		return super.commonDao.select("baseCommonServiceImpl.fnStockPrice", param);
	}

	@ExtDirectMethod( group = "base", value = ExtDirectMethodType.STORE_READ )
	public List<ComboItemModel> fnRecordCombo( Map param ) throws Exception {
		return super.commonDao.list("baseCommonServiceImpl.fnRecordCombo", param);
	}

	@ExtDirectMethod( group = "base", value = ExtDirectMethodType.STORE_READ )
	public List<ComboItemModel> getCodeWithCondition( Map param ) throws Exception {
		return super.commonDao.list("baseCommonServiceImpl.getCodeWithCondition", param);
	}

	@ExtDirectMethod( group = "base", value = ExtDirectMethodType.STORE_READ )
	public Object getEtaxRunUrl() throws Exception {
		return super.commonDao.select("baseCommonServiceImpl.getEtaxRunUrl", null);
	}

	/**
	 * 인쇄 Log 입력
	 * 데이터 구성 srq110skrv에서 onPrintButtonDown 참조
	 * 	 */
	@ExtDirectMethod(group = "base", value = ExtDirectMethodType.STORE_MODIFY)
	public void printLogSave(Map params, LoginVO user) throws Exception {
		List<Map> detailRecords= new ArrayList<Map>();
		String[] orderNumList = ((String) params.get("ORDER_NUM")).split(",");

		for(String orderNum: orderNumList){
			Map<String, String> orderNumSeq = new HashMap<String, String>();
			String[] orderNumSeqStrList = orderNum.split("\\|");
			orderNumSeq.put("BASIS_NUM", orderNumSeqStrList[0]);
			orderNumSeq.put("BASIS_SEQ", orderNumSeqStrList[1]);
			orderNumSeq.put("COMP_CODE", user.getCompCode());
			orderNumSeq.put("DIV_CODE", (String) params.get("DIV_CODE"));
			orderNumSeq.put("PGM_ID", (String) params.get("PGM_ID"));
			orderNumSeq.put("USER_ID", user.getUserID());
			detailRecords.add(orderNumSeq);
			}

		for(Map param: detailRecords)		{
			super.commonDao.insert("baseCommonServiceImpl.printLogSave", param);
		}
	}

	@ExtDirectMethod( group = "base", value = ExtDirectMethodType.STORE_READ )
	public Object getUserLoginInfo(Map params, LoginVO user) throws Exception {
		Map<String, Object> spParam = new HashMap<String, Object>();
		spParam.put("COMP_CODE", user.getCompCode());
		spParam.put("USER_ID"  , user.getUserID());
		return super.commonDao.select("baseCommonServiceImpl.getUserLoginInfo", spParam);
	}

	/**
	 * 외부사용자 로그인 정보 - 20210427 추가
	 * @param params
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "base", value = ExtDirectMethodType.STORE_READ )
	public Object getUserLoginInfo2(Map params, LoginVO user) throws Exception {
		Map<String, Object> spParam = new HashMap<String, Object>();
		spParam.put("COMP_CODE", user.getCompCode());
		spParam.put("USER_ID"  , user.getUserID());
		return super.commonDao.select("baseCommonServiceImpl.getUserLoginInfo2", spParam);
	}

	/**
	 * 20210427 추가 - old비밀번호 check
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "base", value = ExtDirectMethodType.STORE_READ )
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
		return super.commonDao.select("baseCommonServiceImpl.oldPwdCheck", param);
	}

	/**
	 * 20210427 추가 - 입력한 비밀번호가 현재 비밀번호와 같은지 조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "base", value = ExtDirectMethodType.STORE_READ )
	public Object pwDuplicateCheck( Map param ) throws Exception {
//		param.put("NEW_PWD", enc.encrypt(ObjUtils.getSafeString(param.get("NEW_PWD"))));
		return super.commonDao.select("baseCommonServiceImpl.pwDuplicateCheck", param);
	}

	/**
	 * 20210427 추가 - 최근비밀번호 체크갯수
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "base", value = ExtDirectMethodType.STORE_READ )
	public Object pwCheckQ( Map param ) throws Exception {
		return super.commonDao.select("baseCommonServiceImpl.pwCheckQ", param);
	}

	/**
	 * 20210427 추가 - 입력한 비밀번호가 이전사용한 x개의 비밀번호와 같은지 조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "base", value = ExtDirectMethodType.STORE_READ )
	public Object pwSameCheck( Map param ) throws Exception {
		return super.commonDao.select("baseCommonServiceImpl.pwSameCheck", param);
	}

	/**
	 * 20210427 추가 - 저장전 비밀번호 암호화 적용 여부 체크
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "base", value = ExtDirectMethodType.STORE_READ )
	public Object encryptionYN( Map param ) throws Exception {
		return super.commonDao.select("baseCommonServiceImpl.encryptionYN", param);
	}

	/**
	 * 20210427 추가 - 비밀번호 규칙 check
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "base", value = ExtDirectMethodType.STORE_READ )
	public List<Map<String, Object>> pwRuleCheck( Map param ) throws Exception {
		return super.commonDao.list("baseCommonServiceImpl.pwRuleCheck", param);
	}

	/**
	 * 20210427 추가 - 비밀번호 암호화 체크 및 대소문자 구분 여부
	 * @return
	 */
	private Map<String, Object> checkEncryptYN() {
		return (Map<String, Object>)super.commonDao.select("baseCommonServiceImpl.checkEncryptYN");
	}

	/**
	 * 20210427 추가 - 암호화된 비밀번호 저장
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "base", value = ExtDirectMethodType.STORE_READ )
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
		super.commonDao.update("baseCommonServiceImpl.insertPasswordLog", param);
		return super.commonDao.update("baseCommonServiceImpl.encryptionSavePw", param);
	}
}