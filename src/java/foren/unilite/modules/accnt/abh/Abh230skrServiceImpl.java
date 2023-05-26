package foren.unilite.modules.accnt.abh;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.utils.AES256DecryptoUtils;

@SuppressWarnings( { "unused", "rawtypes", "unchecked" } )
@Service( "abh230skrService" )
public class Abh230skrServiceImpl extends TlabAbstractServiceImpl {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    
    @ExtDirectMethod( group = "Accnt" )
    public List<Map<String, Object>> selectList( Map param, LoginVO user ) throws Exception {
        AES256DecryptoUtils decrypto = new AES256DecryptoUtils();
        
        String returnStr = "";
        if (param.get("DEC_FLAG").equals("Y")) {//복호화버튼으로 조회시
            List<Map> decList = (List<Map>)super.commonDao.list("abh230skrServiceImpl.selectList", param);
            if (!ObjUtils.isEmpty(decList)) {
                for (Map decMap : decList) {
                    if (!ObjUtils.isEmpty(decMap.get("ACCOUNT_NUM"))) {
                        try {
                            //decryto() second 파라미터 : "RR"-주민번호   "RP"-여권번호   "RV"-비자번호  "RB"-계좌번호   "RC"-신용카드번호   "RF"-외국인 등록번호
                            decMap.put("ACCOUNT_NUM_EXPOS", decrypto.decryto(decMap.get("ACCOUNT_NUM").toString(), "RB"));
                        } catch (Exception e) {
                            decMap.put("ACCOUNT_NUM_EXPOS", "데이타 오류(" + decMap.get("ACCOUNT_NUM").toString() + ")");
                        }
                    } else {
                        decMap.put("ACCOUNT_NUM_EXPOS", "");
                    }
                }
            }
            return (List)decList;
        } else {
            return (List)super.commonDao.list("abh230skrServiceImpl.selectList", param);
        }
    }
}
