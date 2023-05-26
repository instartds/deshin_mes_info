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
 * 경비관리(SAP) 암호화 인터페이스
 * 
 * @author 박종영
 */
@Service( "vendorAcctServiceImpl" )
public class VendorAcctServiceImpl extends TlabAbstractServiceImpl {
    @SuppressWarnings( "unused" )
    private final Logger        logger   = LoggerFactory.getLogger(this.getClass());
    private AES256EncryptoUtils encrypto = new AES256EncryptoUtils();
    private AES256DecryptoUtils decrypto = new AES256DecryptoUtils();
    
    /**
     * 경비관리(SAP) 거래처
     * 
     * @throws Exception
     */
    @SuppressWarnings( { "unchecked", "rawtypes" } )
    @Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
    public int saveVendorList02() throws Exception {
        List<Map<String, Object>> venList = null;
        int inCnt = 0;
        
        super.commonDao.select("vendorAcctServiceImpl.USP_ACCNT_BCM100T_VENDOR", null);  //sp 호출
        venList = super.commonDao.list("vendorAcctServiceImpl.selectVenList", null); //평문조회
        
        if (venList.size() > 0) {
            for (Map map : venList) {
                if (ObjUtils.isNotEmpty(map.get("TOP_NUM"))) {
                    //                    map.put("TOP_NUM", seed.encryto((String)map.get("TOP_NUM")).trim());   //암호화
                    
                    //update로직에서 암호화 필드가 있을시  decrypt후에 encrypt를 다시 해줘야 중복 암호화가 발생하지 않는다. 단 insert로직은 상관 없음  
                    map.put("TOP_NUM", encrypto.encryto(decrypto.getDecrypto("1", (String)map.get("TOP_NUM"))));
                    inCnt = inCnt + super.commonDao.update("vendorAcctServiceImpl.updateVenTopNum", map);
                }
            }
        }
        
        return inCnt;
    }
    
    /**
     * 경비관리(SAP) 거래처계좌관리
     * 
     * @throws Exception
     */
    @SuppressWarnings( { "unchecked", "rawtypes" } )
    @Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
    public int saveVendorAcctList02() throws Exception {
        List<Map<String, Object>> venList = null;
        int inCnt = 0;
        
        super.commonDao.select("vendorAcctServiceImpl.USP_ACCNT_BCM130T_VENDOR", null);  //sp 호출
        venList = super.commonDao.list("vendorAcctServiceImpl.selectVenAcctList", null); //평문조회
        
        if (venList.size() > 0) {
            for (Map map : venList) {
                if (ObjUtils.isNotEmpty(map.get("BANKBOOK_NUM"))) {
                    //                    map.put("BANKBOOK_NUM", seed.encryto((String)map.get("BANKBOOK_NUM")).trim()); //암호화
                    
                    //update로직에서 암호화 필드가 있을시  decrypt후에 encrypt를 다시 해줘야 중복 암호화가 발생하지 않는다. 단 insert로직은 상관 없음  
                    map.put("BANKBOOK_NUM", encrypto.encryto(decrypto.getDecrypto("1", (String)map.get("BANKBOOK_NUM"))));
                    inCnt = inCnt + super.commonDao.update("vendorAcctServiceImpl.updateVenAcct", map);
                }
            }
        }
        
        return inCnt;
    }
}
