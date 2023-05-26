/**
 * <pre>
  * @FileName : UntdEcrytDcdn.java
  * @Project : kWebComm
  * @Date : 2016. 1. 6. 
  * @작성자 : kyhkim2015
  * @변경이력 :
  * @프로그램 설명 : 해외홍보문화원 프로젝트 시 Uracle의 암호화 모듈임.
  *                - 해외정보문화원 프로젝트에서만 사용.
  * </pre>
  */
package foren.unilite.utils.ext;

import javax.crypto.Cipher;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

import sun.misc.BASE64Decoder;
import sun.misc.BASE64Encoder;

/**
 * @author kyhkim2015
 */
public class UntdEcrytDcdn {
    
    /**
     * 입력데이터 암호화 (key사용)
     * 
     * @param insrData
     * @return String
     */
    public static String encryptKey( String str ) throws Exception {
        String encKey = "kwebEnc";
        Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
        byte[] keyBytes = new byte[16];
        byte[] b = encKey.getBytes("UTF-8");
        int len = b.length;
        if (len > keyBytes.length) len = keyBytes.length;
        System.arraycopy(b, 0, keyBytes, 0, len);
        SecretKeySpec keySpec = new SecretKeySpec(keyBytes, "AES");
        IvParameterSpec ivSpec = new IvParameterSpec(keyBytes);
        cipher.init(Cipher.ENCRYPT_MODE, keySpec, ivSpec);
        
        byte[] results = cipher.doFinal(str.getBytes("UTF-8"));
        BASE64Encoder encoder = new BASE64Encoder();
        
        return encoder.encode(results);
    }
    
    /**
     * 입력데이터 복호화 (key사용)
     * 
     * @param insrData
     * @return String
     */
    public static String decryptKey( String str ) throws Exception {
        String encKey = "kwebEnc";
        Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
        byte[] keyBytes = new byte[16];
        byte[] b = encKey.getBytes("UTF-8");
        int len = b.length;
        if (len > keyBytes.length) len = keyBytes.length;
        System.arraycopy(b, 0, keyBytes, 0, len);
        SecretKeySpec keySpec = new SecretKeySpec(keyBytes, "AES");
        IvParameterSpec ivSpec = new IvParameterSpec(keyBytes);
        cipher.init(Cipher.DECRYPT_MODE, keySpec, ivSpec);
        
        BASE64Decoder decoder = new BASE64Decoder();
        byte[] results = cipher.doFinal(decoder.decodeBuffer(str));
        
        return new String(results, "UTF-8");
    }
    
    public static void main( String[] args ) throws Exception {
        
        // 암복호기 생성
        // 암복호기에 사용되는 key value 는 "kwebEnc"
        // 테스트상 encryptKey, decryptKey 메소드에 하드코딩 되어있음. properties 파일로 추출해도 됨.
        
        // 테스트 아이디
        String userId = "0613test";
        System.out.println("암호화 전 userId >>> " + userId);
        
        // 아이디 암호화
        // AES/CBC 방식으로 암호화 후 BASE64로 인코딩
        String encryptedUserId = UntdEcrytDcdn.encryptKey(userId);
        System.out.println("암호화 후 userId >>> " + encryptedUserId);
        
        // 아이디 복호화
        // BASE64로 디코딩 후 AES/CBC 방식으로 복호화  
        String decryptedUserId = UntdEcrytDcdn.decryptKey(encryptedUserId);
        System.out.println("복호화 후 userId >>> " + decryptedUserId);
        
    }
    
}
