package foren.unilite.modules.z_kocis;

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
import foren.unilite.modules.accnt.AccntCommonServiceImpl;



@Service("s_afb970ukrkocisService")
public class S_Afb970ukrkocisServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	@Resource(name="accntCommonService")
    private AccntCommonServiceImpl accntCommonService;
	
	/**
     * 월마감
     * @param param
     * @return
     * @throws Exception
     */
    
    @ExtDirectMethod(value = ExtDirectMethodType.FORM_LOAD, group = "z_kocis")
    public Object selectForm(Map param) throws Exception {
        
        return super.commonDao.select("s_afb970ukrkocisServiceImpl.selectForm", param);
    }
	/**
     * 상세리스트
     * @param param 검색항목
     * @return
     * @throws Exception
     */ 
    @ExtDirectMethod(group = "z_kocis", value = ExtDirectMethodType.STORE_READ)
    public List<Map<String, Object>> selectDetailList(Map param) throws Exception {
        return super.commonDao.list("s_afb970ukrkocisServiceImpl.selectDetailList", param);
    }
	
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_kocis")
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
    public Object closeMonth (Map param, LoginVO user) throws Exception {
        
        param.put("AC_YYYY", param.get("AC_YEAR"));
        
        String acMonth = "";
//        if(ObjUtils.getSafeString(param.get("AC_MONTH")).substring(0,1).equals("0")){
//            
//            acMonth = ObjUtils.getSafeString(param.get("AC_MONTH")).substring(1);
//        }else{
            acMonth = ObjUtils.getSafeString(param.get("AC_MONTH"));
//        }
        
        param.put("ACC_MM"+acMonth, "Y");
        
        Map beforeCheckClose = (Map) super.commonDao.select("s_afb970ukrkocisServiceImpl.checkAFB910T", param);
        if(ObjUtils.isNotEmpty(beforeCheckClose)){
            super.commonDao.update("s_afb970ukrkocisServiceImpl.updateClose", param);
        }else{
            super.commonDao.insert("s_afb970ukrkocisServiceImpl.insertClose", param);
        }
     
        Object objRtn = "SUCCESS";
        return objRtn;
    }
	
	
}
