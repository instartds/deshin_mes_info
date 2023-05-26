package foren.unilite.modules.z_kd;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service( "s_hpa730skr_kdService" )
public class S_hpa730skr_kdServiceImpl extends TlabAbstractServiceImpl {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    
    /**
     * 개별평정 조회
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "unchecked", "rawtypes" } )
    @ExtDirectMethod( group = "hpa" )
    public List<Map<String, Object>> selectList( Map param ) throws Exception {
        
        return (List)super.commonDao.list("s_hpa730skr_kdServiceImpl.selectList", param);
    }    
    
    /**
     * 
     * 마스터 기안상태 조회
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(group = "hpa", value = ExtDirectMethodType.STORE_READ)
    public List<Map<String, Object>> selectGwData(Map param) throws Exception {
        return super.commonDao.list("s_hpa730skr_kdService.selectGwData", param);
    }
}
