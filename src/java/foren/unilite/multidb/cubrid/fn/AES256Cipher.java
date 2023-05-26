package foren.unilite.multidb.cubrid.fn;

import java.io.UnsupportedEncodingException;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.security.spec.AlgorithmParameterSpec;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

import org.apache.commons.codec.binary.Base64;

public class AES256Cipher {
    
    private final static byte[] pbUserKey = "ForenERP1234%^&*".getBytes();
    private final static byte[] ivBytes   = "(*&uniLITESym678".getBytes();
    
    public static void main( String[] args ) {
        String rtnMessage = fnCipherEncrypt("TEST");   // rSFqvNZQ8kDKLbX/3OyNdg==
        System.out.println("rtnMessage :: " + rtnMessage);
        
        rtnMessage = fnCipherDecrypt("rSFqvNZQ8kDKLbX/3OyNdg==", "");   // 
        System.out.println("rtnMessage :: " + rtnMessage);
    }
    
    /**
     * AES256 암호화 처리
     */
    public static String fnCipherEncrypt( String str ) {
        String rtnValue = null;
        
        try {
            byte[] textBytes = str.getBytes("UTF-8");
            AlgorithmParameterSpec ivSpec = new IvParameterSpec(ivBytes);
            SecretKeySpec newKey = new SecretKeySpec(pbUserKey, "AES");
            Cipher cipher = null;
            cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
            cipher.init(Cipher.ENCRYPT_MODE, newKey, ivSpec);
            
            rtnValue = Base64.encodeBase64String(cipher.doFinal(textBytes));
        } catch (UnsupportedEncodingException uee) {
            rtnValue = uee.getMessage();
        } catch (NoSuchAlgorithmException nae) {
            rtnValue = nae.getMessage();
        } catch (NoSuchPaddingException nspe) {
            rtnValue = nspe.getMessage();
        } catch (InvalidKeyException ike) {
            rtnValue = ike.getMessage();
        } catch (InvalidAlgorithmParameterException iape) {
            rtnValue = iape.getMessage();
        } catch (IllegalBlockSizeException ibse) {
            rtnValue = ibse.getMessage();
        } catch (BadPaddingException bpe) {
            rtnValue = bpe.getMessage();
        } catch (Exception e) {
            rtnValue = e.getMessage();
        }
        
        return rtnValue;
    }
    
    /**
     * AES256 복호화 처리
     */
    public static String decryto( String str ) {
        String rtnValue = null;
        
        try {
            byte[] textBytes = Base64.decodeBase64(str);
            AlgorithmParameterSpec ivSpec = new IvParameterSpec(ivBytes);
            SecretKeySpec newKey = new SecretKeySpec(pbUserKey, "AES");
            Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
            cipher.init(Cipher.DECRYPT_MODE, newKey, ivSpec);
            
            rtnValue = new String(cipher.doFinal(textBytes), "UTF-8");
        } catch (UnsupportedEncodingException uee) {
            rtnValue = uee.getMessage();
        } catch (NoSuchAlgorithmException nae) {
            rtnValue = nae.getMessage();
        } catch (NoSuchPaddingException nspe) {
            rtnValue = nspe.getMessage();
        } catch (InvalidKeyException ike) {
            rtnValue = ike.getMessage();
        } catch (InvalidAlgorithmParameterException iape) {
            rtnValue = iape.getMessage();
        } catch (IllegalBlockSizeException ibse) {
            rtnValue = ibse.getMessage();
        } catch (BadPaddingException bpe) {
            rtnValue = bpe.getMessage();
        } catch (Exception e) {
            rtnValue = e.getMessage();
        }
        
        return rtnValue;
    }
    
    /**
     * <pre>
     * AES256 복호화 
     * 필드구분
     * "R" 로 시작하는 문자열 또는 "R"이 아닌 문자열 
     * (주민번호:A, 여권번호:P, 비자번호:V, 개인계좌번호:B, 신용카드번호:C, 외국인등록번호:F)
     * 
     * 개인정보보호법에 의거하여
     * 카드번호는 1234-5678-****-1111 (9-12번째 자리만 * 처리)
     * 계좌번호는 123-561111-***** (끝에 5자리만 * 처리)
     * 주민번호 800101-1****** (뒤에 6자리만 * 처리)
     * </pre>
     * 
     * @param source
     * @param blockSize
     * @return
     */
    public static String fnCipherDecrypt( String encryptedText, String gubun ) {
        
        String A = "";
        String B = "";
        String result = "";
        
        if (gubun.length() == 2) {
            A = gubun.substring(0, 1);
            B = gubun.substring(1, 2);
        } else if (gubun.length() == 1) {
            A = gubun;
            B = gubun;
        }
        
        result = decryto(encryptedText);
        result = result.replaceAll("-", "");
        StringBuilder builder = new StringBuilder();
        if (A.equals("R")) {
            if (B.equals("R")) {    // 주민번호 뒷자리 * 처리
                if (result.length() == 13) {
                    builder.append(result.substring(0, 6)).append("-").append(result.substring(6, 7)).append("******");
                    result = builder.toString();
                    return result;
                } else {
                    return result;
                }
            } else if (B.equals("P")) {    // 여권번호
                return result;
            } else if (B.equals("V")) {    // 비자번호
                return result;
            } else if (B.equals("B")) {    // 개인계좌번호
                if (result.length() > 5) {
                    builder.append(result.substring(0, result.length() - 5)).append("*****");
                    result = builder.toString();
                    return result;
                } else {
                    return result;
                }
            } else if (B.equals("C")) {    // 신용카드번호
                if (result.length() == 16) {
                    builder.append(result.substring(0, 8)).append("****").append("-").append(result.substring(12, 16));
                    result = builder.toString();
                    return result;
                } else {
                    return result;
                }
            } else if (B.equals("F")) {    // 외국인등록번호
                if (result.length() == 13) {
                    builder.append(result.substring(0, 6)).append("-").append(result.substring(6, 7)).append("******");
                    result = builder.toString();
                    return result;
                } else {
                    return result;
                }
            } else {
                return "";
            }
            
        } else if (!A.equals("")) {
            if (B.equals("R")) {    // 주민번호 뒷자리 * 처리
                if (result.length() == 13) {
                    builder.append(result.substring(0, 6)).append("-").append(result.substring(6, 7)).append("******");
                    result = builder.toString();
                    return result;
                } else {
                    return result;
                }
            } else if (B.equals("P")) {    // 여권번호
                return result;
            } else if (B.equals("V")) {    // 비자번호
                return result;
            } else if (B.equals("B")) {    // 개인계좌번호
                if (result.length() > 5) {
                    builder.append(result.substring(0, result.length() - 5)).append("*****");
                    result = builder.toString();
                    return result;
                } else {
                    return result;
                }
            } else if (B.equals("C")) {    // 신용카드번호
                if (result.length() == 16) {
                    builder.append(result.substring(0, 8)).append("-").append("****").append("-").append(result.substring(12, 16));
                    result = builder.toString();
                    return result;
                } else {
                    return result;
                }
            } else if (B.equals("F")) {    // 외국인등록번호
                if (result.length() == 13) {
                    builder.append(result.substring(0, 6)).append("-").append(result.substring(6, 7)).append("******");
                    result = builder.toString();
                    return result;
                } else {
                    return result;
                }
            } else {
                return "";
            }
        }
        
        return result;
    }
    
}