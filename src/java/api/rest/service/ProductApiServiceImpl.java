package api.rest.service;

import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

/**
 * 상품정보 관리
 * 
 * @author 박종영
 */
@Service( "productApiService" )
public class ProductApiServiceImpl extends TlabAbstractServiceImpl {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    
    /**
     * BPR100T 에 대이터를 저장한다.
     * 
     * @param jobId
     * @param paramMstrList
     * @param paramDetailList
     * @throws Exception
     */
    public void saveBpr100t( Map<String, Object> param ) throws Exception {
        try {
            param.put("S_USER_ID", "WebService");
            super.commonDao.insert("productApiService.saveBpr100t", param);
        } catch (Exception e) {
            logger.error(e.getMessage());
        }
    }
    
}
