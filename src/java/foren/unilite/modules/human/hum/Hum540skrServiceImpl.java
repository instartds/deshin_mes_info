package foren.unilite.modules.human.hum;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service( "hum540skrService" )
@SuppressWarnings( { "unchecked", "rawtypes" } )
public class Hum540skrServiceImpl extends TlabAbstractServiceImpl {
    
    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    
    /**
     * 근로자명부조회
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "hum" )
    public List<Map<String, Object>> selectList( Map param, LoginVO loginVO ) throws Exception {
        param.put("LANG_TYPE", loginVO.getLanguage());
        
        return super.commonDao.list("hum540skrServiceImpl.selectList", param);
    }
}
