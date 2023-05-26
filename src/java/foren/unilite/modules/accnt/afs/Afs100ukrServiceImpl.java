package foren.unilite.modules.accnt.afs;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.utils.AES256DecryptoUtils;

@Service( "afs100ukrService" )
@SuppressWarnings( { "unchecked", "rawtypes" } )
public class Afs100ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	/**
	 * 통장정보등록 조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_READ )
	public List<Map<String, Object>> selectList( Map param ) throws Exception {
		AES256DecryptoUtils decrypto = new AES256DecryptoUtils();

		if (param.get("DEC_FLAG").equals("Y")) {//복호화버튼으로 조회시
			List<Map> decList = (List<Map>)super.commonDao.list("afs100ukrServiceImpl.selectList", param);
			if (!ObjUtils.isEmpty(decList)) {
				for (Map decMap : decList) {
					if (!ObjUtils.isEmpty(decMap.get("BANK_ACCOUNT"))) {
						try {
//							decryto() second 파라미터 : "RR"-주민번호   "RP"-여권번호   "RV"-비자번호  "RB"-계좌번호   "RC"-신용카드번호   "RF"-외국인 등록번호
//							decMap.put("BANK_ACCOUNT_EXPOS", decrypto.decryto(decMap.get("BANK_ACCOUNT").toString(), "RB"));		//20200625 수정: "RB"옵션 제거 - "RB"옵션은 1234**** 형태로 보임
							decMap.put("BANK_ACCOUNT_EXPOS", decrypto.decryto(decMap.get("BANK_ACCOUNT").toString(), ""));
						} catch (Exception e) {
							decMap.put("BANK_ACCOUNT_EXPOS", "데이타 오류(" + decMap.get("BANK_ACCOUNT").toString() + ")");
						}
					} else {
						decMap.put("BANK_ACCOUNT_EXPOS", "");
					}
				}
			}
			return (List)decList;
		} else {
			return (List<Map<String, Object>>)super.commonDao.list("afs100ukrServiceImpl.selectList", param);
		}
	}



	/** 저장 **/
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt" )
	@Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
	public List<Map> saveAll( List<Map> paramList, Map paramMaster, LoginVO user ) throws Exception {
		if (paramList != null) {
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for (Map dataListMap : paramList) {
				if (dataListMap.get("method").equals("deleteDetail")) {
					deleteList = (List<Map>)dataListMap.get("data");
				} else if (dataListMap.get("method").equals("insertDetail")) {
					insertList = (List<Map>)dataListMap.get("data");
				} else if (dataListMap.get("method").equals("updateDetail")) {
					updateList = (List<Map>)dataListMap.get("data");
				}
			}
			if (deleteList != null) this.deleteDetail(deleteList, user);
			if (insertList != null) this.insertDetail(insertList, user);
			if (updateList != null) this.updateDetail(updateList, user);
		}
		paramList.add(0, paramMaster);
		return paramList;
	}

	@ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "accnt" )
	public Integer insertDetail( List<Map> paramList, LoginVO user ) throws Exception {
		try {
			for (Map param : paramList) {
				super.commonDao.update("afs100ukrServiceImpl.insertDetail", param);
			}
		} catch (Exception e) {
			throw new UniDirectValidateException(this.getMessage("2627", user));
		}
		return 0;
	}

	@ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "accnt" )
	public Integer updateDetail( List<Map> paramList, LoginVO user ) throws Exception {
		for (Map param : paramList) {
			super.commonDao.insert("afs100ukrServiceImpl.updateDetail", param);
		}
		return 0;
	}

	@ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "accnt" )
	public Integer deleteDetail( List<Map> paramList, LoginVO user ) throws Exception {
		for (Map param : paramList) {
			try {
				super.commonDao.delete("afs100ukrServiceImpl.deleteDetail", param);
			} catch (Exception e) {
				throw new UniDirectValidateException(this.getMessage("547", user));
			}
		}
		return 0;
	}
}