package foren.unilite.modules.base.bsa;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service( "bsa510skrvService" )
public class Bsa510skrvServiceImpl extends TlabAbstractServiceImpl {
    
    /**
     * 사용자별 권한조회
     * 
     * @param param 검색항목
     * @return
     * @throws Exception
     */
    
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "base" )
    public List<Map<String, Object>> selectList( Map param ) throws Exception {
        
        return super.commonDao.list("bsa510skrvServiceImpl.selectList", param);
    }
    
}
