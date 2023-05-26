package foren.unilite.modules.base.bif;

import java.util.HashMap;
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
import foren.framework.utils.JsonUtils;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.tags.ComboItemModel;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.com.combo.ComboServiceImpl;

@Service( "bif110ukrvService" )
public class Bif110ukrvServiceImpl extends TlabAbstractServiceImpl {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    
    @Resource(name="bifCommonService")
	private BifCommonServiceImpl bifCommonService;
	
    
    
    /**
     * 메신저 메세지 보내기
     * @param params 메세지에 변수와 변수값
     * @param pgmId  메세지 프로그램 ID
     * @param seq    메세지 순번
     * @param startTime 문자전송, 카카오톡 알림톡의 전송시간(YYMMDDhhmmss) 
     * @param user 
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(group = "base")
    public Object sendMessaage(Map<String, Object> params, String pgmId, int seq, String divCode, String startTime, LoginVO user) throws Exception {
    	Map rMap = new HashMap();
    	
    	rMap = (Map) bifCommonService.sendMessages(params, pgmId, seq, divCode, startTime, user);
    	
    	return rMap;
    	
    }
}
