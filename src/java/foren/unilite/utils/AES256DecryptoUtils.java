package foren.unilite.utils;

import javax.annotation.Resource;

import foren.framework.sec.cipher.ase.AES256Cipher;
import foren.framework.utils.GStringUtils;
import foren.framework.utils.ObjUtils;
import foren.framework.utils.SystemUtils;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.com.service.impl.TlabCodeService;

/**
 * 복호화 관련 utils
 * @author chaeseongmin
 *
 */
public class AES256DecryptoUtils extends AES256Cipher {


    
    public String getDecrypto( String gubun, String trgString ) {
        
        String rtnString = "";
        
        // 1. Exception 발생 시 입력값 리턴
        if (gubun.equals("1")) {
            try {
                rtnString = decryto(trgString);
            } catch (NullPointerException npe) {
                rtnString = trgString;
            } catch (Exception e) {
                rtnString = trgString;
            }
        }
        // 1. Exception 발생 시 "" 리턴
        else if (gubun.equals("2")) {
            try {
                rtnString = decryto(trgString);
            } catch (NullPointerException npe) {
                rtnString = "";
            } catch (Exception e) {
                rtnString = "";
            }
        }
        
        return rtnString;
    }
    
    
    /**
     * 마스크 포맷 복호화 (공통코드 B255 참고)
     * @param encryptStr 암호화필드값
     * @param compCode	 법인코드 (공통코드읽기위해)
     * @param programIdStr	프로그램아이디 (공통코드의 subCode과 매칭)
     * @param gubunStr	주민번호 A, 계좌번호 B, 카드번호 C, 외국인번호 F
     * @return
     */
    public String getDecryptWithType( Object encrypt, Object compCode, String programIdStr, String gubunStr ) throws Exception {
    	String rtVal = "";
    	if(ObjUtils.isNotEmpty(encrypt)){
	    	String encryptStr = ObjUtils.getSafeString(encrypt);
	    	String compCodeStr = ObjUtils.getSafeString(compCode);
	    	rtVal = decryto(encryptStr);
			rtVal = rtVal.replaceAll("-", "");
	        StringBuilder builder = new StringBuilder();
	        TlabCodeService tlabCodeService = SystemUtils.getCodeService();
			CodeInfo codeInfo = tlabCodeService.getCodeInfo(compCodeStr);
	        CodeDetailVO cdo = codeInfo.getCodeInfo("B255", programIdStr);	//주민번호관련 
	        if(ObjUtils.isEmpty(rtVal)){
				rtVal= "";
			}else{
		    	if("A".equals(GStringUtils.toUpperCase(gubunStr)) || "F".equals(GStringUtils.toUpperCase(gubunStr))){	//주민번호 or 외국인번호
		    		if(rtVal.length() == 13) {
			            if (!ObjUtils.isEmpty(cdo)) {
			        		String stringFormat = cdo.getRefCode1();
			        		if("RJ".equals(stringFormat)){
			        			builder.append(rtVal.substring(0, 6)).append("-").append("*******");
			        			rtVal = builder.toString();
			        			
			        		}else if("RR".equals(stringFormat)){
			        			builder.append(rtVal.substring(0, 6)).append("-").append(rtVal.substring(6, 7)).append("******");
			        			rtVal = builder.toString();
			        			
			        		}else if("A".equals(stringFormat)){
			        			builder.append(rtVal.substring(0, 6)).append("-").append(rtVal.substring(6));
			        			rtVal = builder.toString();
			        			
			        		}else if("RA".equals(stringFormat)){
			        			rtVal = "******-*******";
			        			
			        		}else{
			        			return rtVal;
			        		}
			            }else{
			    			return rtVal;
			    		}
		    		}else{
		    			return rtVal;
		    		}
		    	}else if("B".equals(GStringUtils.toUpperCase(gubunStr))){	//계좌번호
//		    		if(rtVal.length() > 5) {
		    			String rtV = "";
		    			for(int i=0; i< rtVal.length(); i++){
		    				rtV = rtV +"*";
		    			}
	        			rtVal = rtV;
//		    		}else{
//		    			return rtVal;
//		    		}
		    	}else if("C".equals(GStringUtils.toUpperCase(gubunStr))){	//카드번호 
//		    		if(rtVal.length() == 16) {
		    			String rtV = "";
		    			for(int i=0; i< rtVal.length(); i++){
		    				rtV = rtV +"*";
		    			}
	        			rtVal = rtV;
//		    		}else{
//		    			return rtVal;
//		    		}
		    	}else{
		    		return rtVal;
		    	}
			}
	    	return rtVal;
	    }else{
	    	return rtVal;
	    }
    }


}
