package foren.unilite.utils;

import foren.framework.sec.cipher.ase.AES256Cipher;

/**
 * <pre>
 * 개발 편의상 수정할 수 있는 Utility Class
 * </pre>
 * 
 * @author 박종영
 */
public class AES256EncryptoUtils extends AES256Cipher {
    public String getEncrypto( String gubun, String trgString ) {
        
        String rtnString = "";
        
        // 1. Exception 발생 시 입력값 리턴
        if (gubun.equals("1")) {
            try {
                rtnString = encryto(trgString);
            } catch (NullPointerException npe) {
                rtnString = trgString;
            } catch (Exception e) {
                rtnString = trgString;
            }
        }
        // 1. Exception 발생 시 "" 리턴
        else if (gubun.equals("2")) {
            try {
                rtnString = encryto(trgString);
            } catch (NullPointerException npe) {
                rtnString = "";
            } catch (Exception e) {
                rtnString = "";
            }
        }
        
        return rtnString;
    }
}
