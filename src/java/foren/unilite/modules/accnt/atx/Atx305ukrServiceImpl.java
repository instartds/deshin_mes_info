package foren.unilite.modules.accnt.atx;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.utils.AES256DecryptoUtils;

@Service( "atx305ukrService" )
public class Atx305ukrServiceImpl extends TlabAbstractServiceImpl {
    private final Logger         logger = LoggerFactory.getLogger(this.getClass());
    
    @Resource( name = "atx305ukrService" )
    private Atx305ukrServiceImpl atx305ukrService;
    
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "accnt" )
    public List<Map<String, Object>> getDivList( Map param ) throws Exception {
        return super.commonDao.list("atx305ukrServiceImpl.divList", param);
    }
    
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "accnt" )
    public List<Map<String, Object>> getBillDivList( Map param ) throws Exception {
        return super.commonDao.list("atx305ukrServiceImpl.billDivList", param);
    }
    
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "accnt" )
    public List<Map<String, Object>> selectMasterCodeList( Map param ) throws Exception {
        return super.commonDao.list("atx305ukrServiceImpl.selectMasterCodeList", param);
    }
        
    
    /**
     * 파일 생성전 validation 체크
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "accnt" )
    public Map<String, Object> fnGetFileCheck( Map spParam, LoginVO user ) throws Exception {
        List<String> divList = new ArrayList();	//작업대상 사업장				
        List<Map<String, Object>> paramDivList = null;
        AES256DecryptoUtils decrypto = new AES256DecryptoUtils();
        
        if (!ObjUtils.isEmpty(spParam.get("BILL_DIV_CODE"))) {
            String[] paramDivArry = ( (String)spParam.get("BILL_DIV_CODE") ).split(",");
            for (String divCode : paramDivArry) {
                divList.add(divCode);
            }
        }
        
        Map<String, Object> spResult = new HashMap();
        Map result = new HashMap();
        String errorDesc = "";
        int divCnt = 0;
        if (divList.size() == 0) {
            throw new UniDirectValidateException(this.getMessage("55425", user));
        }
        for (String divCd : divList) {
            spParam.put("DIV_CODE", divCd);
            spParam.put("DIV_COUNT", divCnt);
            spParam.put("COMP_CODE", user.getCompCode());
            divCnt++;
            Map<String, Object> bankAccnt = new HashMap();
            bankAccnt = (Map<String, Object>)super.commonDao.select("atx305ukrServiceImpl.getBankAccnt", spParam);	//암호화된 계좌 가져오기			
            if (ObjUtils.isEmpty(bankAccnt)) {
                spParam.put("BANK_ACCOUNT", "");
            } else {
                String decriptBkAccnt = decrypto.getDecrypto("1", bankAccnt.get("BANK_ACCOUNT").toString());
                spParam.put("BANK_ACCOUNT", decriptBkAccnt);
            }
            //			String decriptBkAccnt =  seed.decryto(bankAccnt.get);
            //			if(ObjUtils.isEmpty(decriptBkAccnt)){
            //				spParam.put("BANK_ACCOUNT", "");
            //			}else{
            //				spParam.put("BANK_ACCOUNT", decriptBkAccnt);
            //			}			
            spResult = (Map)super.commonDao.select("atx305ukrServiceImpl.sp_getFileText", spParam);
            if(spResult != null)	{
	            errorDesc = ObjUtils.getSafeString(spResult.get("ERROR_DESC"));
	            if (!ObjUtils.isEmpty(errorDesc)) {
	                throw new UniDirectValidateException(this.getMessage(errorDesc, user) + "\n" + errorDesc);
	            }
            }else {
            	throw new UniDirectValidateException("부가세 처리할 대상이 없습니다.");
            }
        }
        
        //List<Map<String, Object>> decrypList = (List<Map<String, Object>>)super.commonDao.list("atx305ukrServiceImpl.selectFileList", spParam);
        //String MEM_NUM = "";
        
        //for (Map dec : decrypList) {
        //    dec.put("ORG_MEM_NUM", (String)dec.get("MEM_NUM"));
        //    
        //    MEM_NUM = decrypto.getDecrypto("1", (String)dec.get("MEM_NUM"));
        //    
        //    dec.put("MEM_NUM", MEM_NUM);
        //    dec.put("S_COMP_CODE", user.getCompCode());
        //    dec.put("DIV_CODE", divList.get(0));
        //    dec.put("PUB_DATE_FR", spParam.get("PUB_DATE_FR"));
        //    dec.put("PUB_DATE_TO", spParam.get("PUB_DATE_TO"));
        //    
        //    super.commonDao.update("atx305ukrServiceImpl.updateDecrypto", dec);
        //}
        
        result.put("ERROR_DESC", "success");
        
        return result;
    }
    
    /**
     * 파일 생성
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "accnt" )
    public Map<String, Object> fnGetFileText( Map spParam, LoginVO user ) throws Exception {
    	String errorDesc = "", returnText = "";
        Map result = (Map)super.commonDao.select("atx305ukrServiceImpl.sp_getFileText", spParam);
        if(result != null){
	        returnText = ObjUtils.getSafeString(result.get("RETURN_TEXT"));
	        errorDesc = ObjUtils.getSafeString(result.get("ERROR_DESC"));
	        //		System.out.print(returnText);
	        if (!ObjUtils.isEmpty(errorDesc)) {
	            errorDesc = this.getMessage(errorDesc, user);
	        }
	        result.put("ERROR_DESC", errorDesc);
        }
        
        
        return result;
    }
    
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "accnt" )
    public Map<String, Object> getBankAccnt( Map param ) throws Exception {
        return (Map)super.commonDao.select("atx305ukrServiceImpl.getBankAccnt", param);
    }
    
}
