package api.rest.service;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.utils.AES256DecryptoUtils;
import foren.unilite.utils.AES256EncryptoUtils;

/**
 * 법인카드 암호화 인터페이스
 * 
 * @author 박종영
 */
@Service( "cardAcctServiceImpl" )
public class CardAcctServiceImpl extends TlabAbstractServiceImpl {
    @SuppressWarnings( "unused" )
    private final Logger        logger   = LoggerFactory.getLogger(this.getClass());
    private AES256EncryptoUtils encrypto = new AES256EncryptoUtils();
    private AES256DecryptoUtils decrypto = new AES256DecryptoUtils();
    
    /**
     * 법인카드 마스터 CARD_NO_ORG 필드 암호화
     * 
     * @throws Exception
     */
    @SuppressWarnings( { "unchecked", "rawtypes" } )
    @Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
    public int encCardNo() throws Exception {
        List<Map<String, Object>> cardList = null;
        int inCnt = 0;
        
        cardList = super.commonDao.list("cardAcctServiceImpl.selectCardList", null);
        
        // 카드 마스터의 카드번호 암호화
        if (cardList.size() > 0) {
            for (Map map : cardList) {
                try {
                    //update로직에서 암호화 필드가 있을시  decrypt후에 encrypt를 다시 해줘야 중복 암호화가 발생하지 않는다. 단 insert로직은 상관 없음  
                    map.put("CARD_NO_ORG", encrypto.encryto(decrypto.getDecrypto("1", (String)map.get("CARD_NO_ORG")).trim()));      // 평문을 암호화 한다.
                } catch (Exception e) {
                    throw new Exception("카드번호 암호화 오류 :: [" + (String)map.get("CARD_NO_ORG") + "]");
                }
                super.commonDao.update("cardAcctServiceImpl.updateCardNoOrg", map);
            }
        }
        
        return inCnt;
    }
    
    /**
     * 법인카드 마스터 CARD_NO_ORG 필드 복호화
     * 
     * @throws Exception
     */
    @SuppressWarnings( { "unchecked", "rawtypes" } )
    @Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
    public int decCardNo() throws Exception {
        List<Map<String, Object>> cardList = null;
        int inCnt = 0;
        
        cardList = super.commonDao.list("cardAcctServiceImpl.selectCardList", null);
        
        if (cardList.size() > 0) {
            for (Map map : cardList) {
                map.put("ORG_CARD_NO", map.get("CARD_NO"));
                try {
                    map.put("CARD_NO_ORG", decrypto.getDecrypto("1", (String)map.get("CARD_NO")));  // 법인카드 마스터 CARD_NO_ORG 필드 복호화
                } catch (Exception e) {
                    throw new Exception("카드번호 복호화 오류 :: [" + (String)map.get("CARD_NO_ORG") + "]");
                }
                super.commonDao.update("cardAcctServiceImpl.updateCardNoOrg", map);
            }
        }
        
        return inCnt;
    }
    
    /**
     * 법인카드 마스터 CARD_NO_ORG 필드 암호화
     * 
     * @throws Exception
     */
    @SuppressWarnings( { "unchecked", "rawtypes" } )
    @Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
    public int encCardMndNo() throws Exception {
        List<Map<String, Object>> cardMndList = null;
        int inCnt = 0;
        
        // 법인카드 사용내역의 비교를 위해 카드 마스터 복호화
        cardMndList = super.commonDao.list("cardAcctServiceImpl.selectCardMndList", null);
        
        // 법인카드 사용내역의 비교를 위해 카드 마스터 복호화
        if (cardMndList.size() > 0) {
            for (Map map : cardMndList) {
                try {
                    
                    map.put("ORG_CARD_NO", map.get("CARD_NO"));
                    
                    if (map.get("CARD_NO") == null) {
                        map.put("CARD_NO_ORG", encrypto.encryto(""));
                    } else {
                        //update로직에서 암호화 필드가 있을시  decrypt후에 encrypt를 다시 해줘야 중복 암호화가 발생하지 않는다. 단 insert로직은 상관 없음  
                        map.put("CARD_NO_ORG", encrypto.encryto(decrypto.getDecrypto("1", (String)map.get("CARD_NO"))));
                    }
                    
                } catch (Exception e) {
                    throw new Exception("카드번호 암호화 오류 :: [" + (String)map.get("CARD_NO") + "]");
                }
                
                super.commonDao.update("cardAcctServiceImpl.updateCardMndNoOrg", map);
            }
        }
        
        return inCnt;
    }
    
    /**
     * 법인카드 마스터 CARD_NO_ORG 필드 복호화
     * 
     * @throws Exception
     */
    @SuppressWarnings( { "unchecked", "rawtypes" } )
    @Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
    public int decCardMndNo() throws Exception {
        List<Map<String, Object>> cardMndList = null;
        int inCnt = 0;
        
        // 법인카드 사용내역의 비교를 위해 카드 마스터 복호화
        cardMndList = super.commonDao.list("cardAcctServiceImpl.selectCardMndList", null);
        
        if (cardMndList.size() > 0) {
            for (Map map : cardMndList) {
                try {
                    map.put("ORG_CARD_NO", map.get("CARD_NO"));
                    map.put("CARD_NO_ORG", decrypto.getDecrypto("1", (String)map.get("CARD_NO")));  // 암호화된 CARD_NO를 복호화 한다.
                } catch (Exception e) {
                    throw new Exception("카드번호 복호화 오류 :: [" + (String)map.get("CARD_NO_ORG") + "]");
                }
                super.commonDao.update("cardAcctServiceImpl.updateCardMndNoOrg", map);
            }
        }
        
        return inCnt;
    }
    
    /**
     * CARD_NO, CARD_NO_ORG 필드 암호화
     * 
     * @throws Exception
     */
    @SuppressWarnings( { "unchecked", "rawtypes" } )
    @Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
    public int saveCardAll02() throws Exception {
        List<Map<String, Object>> tempList = null;
        int inCnt = 0;
        
        super.commonDao.select("cardAcctServiceImpl.SP_EA_CARD_MASTER_UPLOAD", null);  //sp 호출
        
        tempList = super.commonDao.list("cardAcctServiceImpl.selectCardJobYnList", null);
        
        if (tempList.size() > 0) {
            for (Map map : tempList) {
                map.put("ORG_CARD_NO", map.get("CARD_NO"));
                try {
                    //update로직에서 암호화 필드가 있을시  decrypt후에 encrypt를 다시 해줘야 중복 암호화가 발생하지 않는다. 단 insert로직은 상관 없음  
                    map.put("CARD_NO", encrypto.encryto(decrypto.getDecrypto("1", (String)map.get("CARD_NO")).trim()));    // CARD_NO 필드 암호화
                } catch (Exception e) {
                    throw new Exception("카드번호 암호화 오류 :: [" + (String)map.get("CARD_NO_ORG") + "]");
                }
                inCnt = inCnt + super.commonDao.update("cardAcctServiceImpl.updateCardNo", map);
            }
        }
        
        return inCnt;
    }
    
    /**
     * <pre>
     * aba500t를 넣어주는 sp실행(암호화가 된 다음에 실행)...
     * SP_EA_CARD_MASTER_SYNC
     * </pre>
     * 
     * @throws Exception
     */
    @Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
    public void saveABA500T() throws Exception {
        super.commonDao.select("cardAcctServiceImpl.SP_EA_CARD_MASTER_SYNC", null);  //sp 호출
    }
    
    /**
     * 법인카드 승인(사용)내역
     * 
     * @throws Exception
     */
    @SuppressWarnings( { "unchecked", "rawtypes" } )
    @Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
    public int saveUseList02() throws Exception {
        List<Map<String, Object>> useList = null;
        int inCnt = 0;
        
        // 법인카드 사용내역 처리
        super.commonDao.select("cardAcctServiceImpl.SP_EA_USE_LIST_INSERT", null);  //sp 호출
        
        // 법인카드 사용내역의 카드번호 암호화
        useList = super.commonDao.list("cardAcctServiceImpl.selectUseList", null); //평문조회
        
        if (useList.size() > 0) {
            for (Map map : useList) {
                map.put("ORG_CARD_NO", map.get("CARD_NO"));
                try {
                    //update로직에서 암호화 필드가 있을시  decrypt후에 encrypt를 다시 해줘야 중복 암호화가 발생하지 않는다. 단 insert로직은 상관 없음  
                    map.put("CARD_NO", encrypto.encryto(decrypto.getDecrypto("1", (String)map.get("CARD_NO")).trim()));    // CARD_NO 필드 암호화
                } catch (Exception e) {
                    throw new Exception("카드번호 암호화 오류 :: [" + (String)map.get("CARD_NO") + "]");
                }
                inCnt = inCnt + super.commonDao.update("cardAcctServiceImpl.updateUseCardNo", map);
            }
        }
        
        return inCnt;
    }
    
    /**
     * 법인카드 청구
     * 
     * @throws Exception
     */
    @SuppressWarnings( { "unchecked", "rawtypes" } )
    @Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
    public int saveInvList02() throws Exception {
        List<Map<String, Object>> invList = null;
        int inCnt = 0;
        
        // 법인카드 청구의 카드번호 암호화
        super.commonDao.select("cardAcctServiceImpl.SP_EA_INV_LIST_INSERT", null);  //sp 호출
        
        // 법인카드 청구의 카드번호 암호화
        invList = super.commonDao.list("cardAcctServiceImpl.selectInvList", null); //평문조회
        
        if (invList.size() > 0) {
            for (Map map : invList) {
                map.put("ORG_CARD_NO", map.get("CARD_NO"));
                try {
                    //update로직에서 암호화 필드가 있을시  decrypt후에 encrypt를 다시 해줘야 중복 암호화가 발생하지 않는다. 단 insert로직은 상관 없음  
                    map.put("CARD_NO", encrypto.encryto(decrypto.getDecrypto("1", (String)map.get("CARD_NO")).trim()));    // CARD_NO 필드 암호화
                } catch (Exception e) {
                    throw new Exception("카드번호 암호화 오류 :: [" + (String)map.get("CARD_NO") + "]");
                }
                inCnt = inCnt + super.commonDao.update("cardAcctServiceImpl.updateInvCardNo", map);
            }
        }
        
        return inCnt;
    }
    
    /**
     * 스마트빌의 매입 전자세금계산서를 자동 입력
     * 
     * @throws Exception
     */
    @Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
    public int saveSmartBill02() throws Exception {
        int inCnt = 0;
        
        // 법인카드 한도의 카드번호 암호화
        super.commonDao.select("cardAcctServiceImpl.SMARTBILL_TAX_USE_INSERT", null);  //sp 호출
        
        return inCnt;
    }
}
