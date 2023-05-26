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

@Service( "s_hum500skr_kdService" )
@SuppressWarnings( { "unchecked", "rawtypes" } )
public class S_Hum500skr_kdServiceImpl extends TlabAbstractServiceImpl {
    
    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    
    /**
     * 공제대장조회
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "hum" )
    public List<Map<String, Object>> selectList( Map param, LoginVO loginVO ) throws Exception {
        param.put("LANG_TYPE", loginVO.getLanguage());
        
        return super.commonDao.list("s_hum500skr_kdServiceImpl.selectList", param);
    }
}
