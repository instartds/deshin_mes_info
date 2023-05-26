package foren.unilite.modules.human;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.sec.cipher.ase.AES256Cipher;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.com.combo.ComboItemModel;

@Service( "humanCommonService" )
public class HumanCommonServiceImpl extends TlabAbstractServiceImpl {
	private AES256Cipher encrypt = new AES256Cipher();
    
    private final Logger logger = LoggerFactory.getLogger(this.getClass());

    /**
     * 암호화 필드 관련
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(group = "human")
    public String encryptField(Map param) throws Exception {
        String rtnV = "";
        rtnV = encrypt.encryto(ObjUtils.getSafeString(param.get("DECRYP_WORD").toString().replace("-", "")));
        return rtnV;
    } 
    /**
     * 사업명
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "unchecked", "rawtypes" } )
    @ExtDirectMethod( group = "hum", value = ExtDirectMethodType.STORE_READ )
    public String getCostPool( Map param ) throws Exception {
        
        List<Map> qureyValue = (List<Map>)super.commonDao.list("humanCommonService.getCostPoolName", param);
        
        String certi = "";
        
        if (qureyValue.size() == 0) {
            certi = "Cost Pool";
        } else {
            certi = (String)qureyValue.get(0).get("REF_CODE2");
        }
        
        return certi;
    }
    
    /**
     * 사업명
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "unchecked", "rawtypes" } )
    @ExtDirectMethod( group = "hum", value = ExtDirectMethodType.STORE_READ )
    public List<Map<String, Object>> getCostPoolName( Map param ) throws Exception {
        return super.commonDao.list("humanCommonService.getCostPoolName", param);
    }
    
    /**
     * 고용보험율
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "unchecked", "rawtypes" } )
    @ExtDirectMethod( group = "hum", value = ExtDirectMethodType.STORE_READ )
    public List<Map<String, Object>> getEmployRate( Map param ) throws Exception {
        return super.commonDao.list("humanCommonService.getEmployRate", param);
    }
    
    /**
     * 마감정보
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "unchecked", "rawtypes" } )
    @ExtDirectMethod( group = "human" )
    public boolean fnCloseYn( String closeType, String closeDate, LoginVO user ) throws Exception {
        
        Map param = new HashMap();
        param.put("CLOSE_DATE", closeDate);
        param.put("S_COMP_CODE", user.getCompCode());
        param.put("CLOSE_TYPE", closeType);
        Map checkCloseYn = (Map)super.commonDao.select("humanCommonService.fncloseYN", param);
        //마감정보이 되지 않았을 때
        if (!ObjUtils.isEmpty(checkCloseYn.get("MSG"))) {
            throw new UniDirectValidateException(this.getMessage(ObjUtils.getSafeString(checkCloseYn.get("MSG")), user));
        } else {
            return true;
        }
    }
    
    /**
     * 마감정보(개인별)
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "unchecked", "rawtypes" } )
    @ExtDirectMethod( group = "human" )
    public boolean fnCloseYn2( String personNum, String closeDate, LoginVO user ) throws Exception {
        
        Map param = new HashMap();
        param.put("PERSON_NUMB", personNum);
        param.put("S_COMP_CODE", user.getCompCode());
        param.put("CLOSE_DATE", closeDate);
        Map checkCloseYn = (Map)super.commonDao.select("humanCommonService.fncloseYN2", param);
        //마감정보이 되지 않았을 때
        if (!ObjUtils.isEmpty(checkCloseYn.get("MSG"))) {
            throw new UniDirectValidateException(this.getMessage(ObjUtils.getSafeString(checkCloseYn.get("MSG")), user));
        } else {
            return true;
        }
    }
    
    @SuppressWarnings( { "unchecked", "rawtypes" } )
    @Transactional( readOnly = true )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "human" )
    public List<ComboItemModel> getCodeList( LoginVO loginVO ) throws Exception {
        Map inParam = new HashMap();
        inParam.put("S_COMP_CODE", loginVO.getCompCode());
        
        return (List<ComboItemModel>)super.commonDao.list("humanCommonService.getCodeList", inParam);
        
    }
    @ExtDirectMethod( group = "human" )
    public Map<String,Object> fnGetAdjustmentStdDate( Map param ) throws Exception {
        return (Map<String,Object>)super.commonDao.select("humanCommonService.fnGetAdjustmentStdDate", param);
        
    }
    
    @ExtDirectMethod( group = "human" )
    public Map<String,Object> fnGetTaxAdjustmentYear( Map param ) throws Exception {
    	Map<String,Object> yearMap = this.fnGetAdjustmentStdDate(param);
    	Map<String,Object> rMap = new HashMap();
    	if(yearMap != null)	{
	    	String stdMD = ObjUtils.getSafeString(yearMap.get("CODE_NAME"));
	    	String sysYear = ObjUtils.getSafeString(yearMap.get("SYS_YEAR"));
	    	String sysMD = ObjUtils.getSafeString(yearMap.get("SYS_MD"));
	    	String lastYear = ObjUtils.getSafeString(yearMap.get("LAST_YEAR"));
	    	
	    	if(stdMD != null && Integer.parseInt("1"+sysMD) <= Integer.parseInt("1"+stdMD) )	{
	    		rMap.put("taxAdjustmentYear", lastYear );
	    	}else {
	    		rMap.put("taxAdjustmentYear", sysYear );
	    	}
    	}
    	return rMap;
    }
    /**
     * 그룹웨어 사용여부
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "human" )
    public Object fnGWUseYN( Map param ) throws Exception {
        return super.commonDao.select("humanCommonService.fnGWUseYN", param);
    }
    
    /**
     * 사업장 정보 조회
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "human" )
    public Object selectDivInfo( Map param ) throws Exception {
        return super.commonDao.select("humanCommonService.selectDivInfo", param);
    }
    
}
