package api.rest.service;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.utils.AES256DecryptoUtils;
import foren.unilite.utils.AES256EncryptoUtils;

/**
 * 입출금 거래내역 암호화 인터페이스
 * 
 * @author 박종영
 */
@Service( "histAcctServiceImpl" )
public class HistAcctServiceImpl extends TlabAbstractServiceImpl {
    @SuppressWarnings( "unused" )
    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    
    /**
     * 입출금 거래내역 암호화 인터페이스
     * 
     * @param paramList
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
    public int apiAccntSaveAll02( String jobId ) throws Exception {
        AES256EncryptoUtils encrypto = new AES256EncryptoUtils();
        AES256DecryptoUtils decrypto = new AES256DecryptoUtils();
        
        int inCnt = 0;
        
        List<Map<String, Object>> paramList = null;
        paramList = super.commonDao.list("histAcctServiceImpl.selectAccntList", null);
        
        for (Map map : paramList) {
            if (ObjUtils.isNotEmpty(map.get("ACCOUNT_NUM"))) {
//                map.put("T_ACCT_NO", seed.encryto((String)map.get("ACCOUNT_NUM")).trim());
                
              //update로직에서 암호화 필드가 있을시  decrypt후에 encrypt를 다시 해줘야 중복 암호화가 발생하지 않는다. 단 insert로직은 상관 없음  
                map.put("T_ACCT_NO", encrypto.encryto(decrypto.getDecrypto("1", (String) map.get("ACCOUNT_NUM"))));
            } else {
                map.put("T_ACCT_NO", encrypto.encryto(""));
            }
            
            map.put("JOB_ID", jobId);
            map.put("REFER_YN", "Y");
            
            super.commonDao.update("histAcctServiceImpl.updateAccnt", map); //T_ACCT_NO, JOB_ID update
            inCnt = inCnt + super.commonDao.insert("histAcctServiceImpl.insertAccnt", map); //ABH300T insert
        }
        
        return inCnt;
    }
    
}
