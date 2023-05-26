package foren.unilite.modules.accnt.axt;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;


@Service( "axt110skrService" )
@SuppressWarnings( { "unchecked", "rawtypes" } )
public class Axt110skrServiceImpl extends TlabAbstractServiceImpl {
    
    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    
    /**
     * SK대비표 조회
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "accnt" )
    public List<Map<String, Object>> selectList( Map param, LoginVO loginVO ) throws Exception {
        param.put("LANG_TYPE", loginVO.getLanguage());
        
        
    	logger.debug("===========================================================");
    	logger.debug((String) param.get("S_COMP_CODE"));
    	logger.debug((String) param.get("S_USER_ID"));
    	logger.debug((String) param.get("LANG_TYPE"));

    	logger.debug((String) param.get("ST_YYYY"));
    	logger.debug((String) param.get("DIV_CODE"));
        logger.debug((String) param.get("KEY_VALUE"));
        
        
        return super.commonDao.list("axt110skrService.selectList", param);
    }
}



