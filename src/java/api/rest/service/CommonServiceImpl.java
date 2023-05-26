package api.rest.service;

import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

/**
 * Log 테이블 관리
 * 
 * @author 박종영
 */
@Service( "commonServiceImpl" )
public class CommonServiceImpl extends TlabAbstractServiceImpl {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    
    /**
     * Log 테이블 저장
     * 
     * @param jobId
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    public void insertLog( Map param ) throws Exception {
        try {
            super.commonDao.insert("commonServiceImpl.insertLog", param);
        } catch (Exception ex) {
            logger.error(ex.getMessage());
        }
    }
    
    /**
     * Log 테이블 수정
     * 
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    public void updateLog( Map param ) throws Exception {
        try {
            super.commonDao.delete("commonServiceImpl.updateLog", param);
        } catch (Exception ex) {
            logger.error(ex.getMessage());
        }
    }
    
}
