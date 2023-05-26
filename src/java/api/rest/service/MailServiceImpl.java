package api.rest.service;

import java.util.HashMap;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

/**
 * <pre>
 * 메일 발송 후 메일수신여부 확인 인터페이스
 * 사내메일만 확인 가능하다.
 * </pre>
 * 
 * @author 박종영
 */
@Service( "mailServiceImpl" )
public class MailServiceImpl extends TlabAbstractServiceImpl {
    /**
     * 메일 수신여부 UPDATE
     * 
     * @throws Exception
     */
    @SuppressWarnings( { "unchecked", "rawtypes" } )
    @Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
    public void updateRecv( String serial ) throws Exception {
        Map param = new HashMap();
        param.put("JOB_ID", serial);
        
        super.commonDao.update("mailServiceImpl.updateRecv", param);  //sp 호출
    }
}
