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

@Service( "s_hat910skr_kdServiceImpl" )
public class S_hat910skr_kdServiceImpl extends TlabAbstractServiceImpl {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    
    /**
     * 경력사항조회
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "hum" )
    public List<Map<String, Object>> selectList( Map param , LoginVO loginVO ) throws Exception {
        param.put("LANG_TYPE", loginVO.getLanguage());
        
        return super.commonDao.list("s_hat910skr_kdService.selectList", param);
    }
}
