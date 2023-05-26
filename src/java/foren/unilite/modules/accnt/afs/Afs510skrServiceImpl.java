package foren.unilite.modules.accnt.afs;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.utils.AES256DecryptoUtils;

@Service( "afs510skrService" )
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Afs510skrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	/**
	 * 전표 조회
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Accnt", value = ExtDirectMethodType.STORE_READ )
	public List<Map<String, Object>> selectList1( Map param ) throws Exception {
//		String returnStr = "";
//		AES256DecryptoUtils decrypto = new AES256DecryptoUtils();
		
		if (param.get("DEC_FLAG").equals("Y")) {
			List<Map> decList = (List<Map>)super.commonDao.list("afs510skrServiceImpl.selectList", param);
			if (!ObjUtils.isEmpty(decList)) {
				for (Map decMap : decList) {
					if (!ObjUtils.isEmpty(decMap.get("BANK_ACCOUNT"))) {
						try {
							//decryto() second 파라미터 : "RR"-주민번호   "RP"-여권번호   "RV"-비자번호  "RB"-계좌번호   "RC"-신용카드번호   "RF"-외국인 등록번호
							//20200907 수정: 복호화 오류 수정
//							decMap.put("BANK_ACCOUNT_EXPOS", decrypto.decryto(decMap.get("BANK_ACCOUNT").toString(), "RB"));
							decMap.put("BANK_ACCOUNT_EXPOS", decMap.get("BANK_ACCOUNT").toString());
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
			return (List)super.commonDao.list("afs510skrServiceImpl.selectList", param);
		}
	}

	@ExtDirectMethod( group = "Accnt", value = ExtDirectMethodType.STORE_READ )
	public List<Map<String, Object>> selectList2( Map param ) throws Exception {
		return (List)super.commonDao.list("afs510skrServiceImpl.selectList2", param);
	}
}