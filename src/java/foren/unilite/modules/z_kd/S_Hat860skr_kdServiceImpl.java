package foren.unilite.modules.z_kd;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service( "s_Hat860skr_kdServiceImpl" )
public class S_Hat860skr_kdServiceImpl extends TlabAbstractServiceImpl {
    
    @SuppressWarnings( "unused" )
    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    
    /**
     * 년월 개인별 일자별 근태현황
     * - 일단윈
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "unchecked", "rawtypes" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "hat" )
    public List<Map<String, Object>> selectList( Map param, LoginVO loginVO ) throws Exception {
        param.put("LANG_TYPE", loginVO.getLanguage());
        param.put("COMP_CODE", loginVO.getCompCode());
        param.put("LOGIN_ID", loginVO.getUserID());
        
        return super.commonDao.list("s_hat860skr_kdService.selectList", param);
    }
    
//    @SuppressWarnings( { "unchecked", "rawtypes" } )
//    @ExtDirectMethod( value = ExtDirectMethodType.FORM_LOAD, group = "hat" )
//    public Object selectList2( Map param, LoginVO loginVO ) throws Exception {
//    	System.out.println("sucess");
//    	System.out.println(param.values());
//        param.put("LANG_TYPE", loginVO.getLanguage());
//        param.put("COMP_CODE", loginVO.getCompCode());
//        param.put("LOGIN_ID", loginVO.getUserID());
//        
//        return super.commonDao.list("s_hat860skrService.selectList", param);
//    }
    
//    /**
//     * 년월 개인별 일자별 근태현황
//     * - 월단위
//     * 
//     * @param param
//     * @return
//     * @throws Exception
//     */
//    @SuppressWarnings( { "unchecked", "rawtypes" } )
//    @ExtDirectMethod( value = ExtDirectMethodType.FORM_LOAD, group = "hat" )
//    public Object selectList2( Map param, LoginVO loginVO ) throws Exception {
//        param.put("LANG_TYPE", loginVO.getLanguage());
//        param.put("COMP_CODE", loginVO.getCompCode());
//        param.put("LOGIN_ID", loginVO.getUserID());
//        
//        return super.commonDao.select("s_hat860skrService.selectList2", param);
//    }
}
