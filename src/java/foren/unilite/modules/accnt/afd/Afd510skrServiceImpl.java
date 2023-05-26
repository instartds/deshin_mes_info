package foren.unilite.modules.accnt.afd;

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

@Service( "afd510skrService" )
public class Afd510skrServiceImpl extends TlabAbstractServiceImpl {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    
    @ExtDirectMethod( value = ExtDirectMethodType.FORM_LOAD, group = "accnt" )
    public Object selectForm( Map param ) throws Exception {
        return super.commonDao.select("afd510skrService.selectAmtPoint", param);
    }
    
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_READ )
    public List<Map<String, Object>> selectMasterList( Map param ) throws Exception {
    	
    	Map<String, Object> amptPontMap = (Map<String, Object>) this.selectForm(param);
    	param.put("AMT_POINT", amptPontMap.get("AMT_POINT"));
    	
        AES256DecryptoUtils decrypto = new AES256DecryptoUtils();
        
        if (param.get("DEC_FLAG").equals("Y")) {//복호화버튼으로 조회시
            List<Map> decList = (List<Map>)super.commonDao.list("afd510skrService.selectMasterList", param);
            if (!ObjUtils.isEmpty(decList)) {
                for (Map decMap : decList) {
                    if (!ObjUtils.isEmpty(decMap.get("BANK_ACCOUNT"))) {
                        try {
                            //decryto() second 파라미터 : "RR"-주민번호   "RP"-여권번호   "RV"-비자번호  "RB"-계좌번호   "RC"-신용카드번호   "RF"-외국인 등록번호
                            decMap.put("BANK_ACCOUNT_EXPOS", decrypto.decryto(decMap.get("BANK_ACCOUNT").toString(), "RB"));
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
            return (List)super.commonDao.list("afd510skrService.selectMasterList", param);
        }
    }
}