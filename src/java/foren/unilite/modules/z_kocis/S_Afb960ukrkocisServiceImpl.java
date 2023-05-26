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



@Service("s_afb960ukrkocisService")
public class S_Afb960ukrkocisServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	@Resource(name="accntCommonService")
    private AccntCommonServiceImpl accntCommonService;
	
	/**
     * 연마감
     * @param param
     * @return
     * @throws Exception
     */
    
    @ExtDirectMethod(value = ExtDirectMethodType.FORM_LOAD, group = "accnt")
    public Object selectForm(Map param) throws Exception {
        
        return super.commonDao.select("s_afb960ukrkocisServiceImpl.selectForm", param);
    }
	/**
     * 상세리스트
     * @param param 검색항목
     * @return
     * @throws Exception
     */ 
    @ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
    public List<Map<String, Object>> selectDetailList(Map param) throws Exception {
        return super.commonDao.list("s_afb960ukrkocisServiceImpl.selectDetailList", param);
    }
	
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
    public Object closeMonth (Map param, LoginVO user) throws Exception {
        
        param.put("AC_YYYY", param.get("AC_YEAR"));
        
//        if(ObjUtils.getSafeString(param.get("AC_MONTH")).substring(0,1).equals("0")){
//            
//            acMonth = ObjUtils.getSafeString(param.get("AC_MONTH")).substring(1);
//        }else{
//        }
        
        
        Map beforeCheckClose = (Map) super.commonDao.select("s_afb960ukrkocisServiceImpl.checkAFB910T", param);
        if(ObjUtils.isNotEmpty(beforeCheckClose)){
            super.commonDao.update("s_afb960ukrkocisServiceImpl.updateClose", param);
        }else{
            super.commonDao.insert("s_afb960ukrkocisServiceImpl.insertClose", param);
        }
     
        Object objRtn = "SUCCESS";
        return objRtn;
    }
	
	
}
