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

@Service( "s_hat890skr_kdService" )
@SuppressWarnings( { "unchecked", "rawtypes" } )
public class S_Hat890skr_kdServiceImpl extends TlabAbstractServiceImpl {
    
    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    
    /**
     * 근태대장 조회
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "hpa" )
    public List<Map<String, Object>> selectList( Map param, LoginVO loginVO ) throws Exception {
        param.put("LANG_TYPE", loginVO.getLanguage());
        
        return super.commonDao.list("s_hat890skr_kdServiceImpl.selectList", param);
    }
}