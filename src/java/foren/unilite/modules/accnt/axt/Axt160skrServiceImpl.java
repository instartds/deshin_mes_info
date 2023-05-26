package foren.unilite.modules.accnt.axt;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service( "axt160skrService" )
public class Axt160skrServiceImpl extends TlabAbstractServiceImpl {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    
    /**
     * 가족사항조회
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "accnt" )
    public List<Map<String, Object>> selectList( Map param ) throws Exception {
        
        return super.commonDao.list("axt160skrService.selectList", param);
    }
}
