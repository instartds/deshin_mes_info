package foren.unilite.modules.accnt.agc;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service( "agc210skrService" )
public class Agc210skrServiceImpl extends TlabAbstractServiceImpl {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    
    /**
     * 결산부속명세서 데이터 생성
     * 
     * @param jobId
     * @throws Exception
     */
    public String accntAgc190Rkr( Map<String, Object> param ) throws Exception {
        String ERROR_DESC = null;
        
        try {
            super.commonDao.queryForObject("agc210skrService.USP_ACCNT_AGC190RKR", param);
            
            ERROR_DESC = ObjUtils.getSafeString(param.get("ERROR_DESC"));
        } catch (Exception ex) {
            logger.error(ex.getMessage());
            throw new Exception(ex.getMessage());
        }
        
        return ERROR_DESC;
    }
    
    /**
     * 1. 현금 및 현금등가물
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public List<Map<String, Object>> getWorkGubun01( Map param ) throws Exception {
        return super.commonDao.list("agc210skrService.getWorkGubun01", param);
    }
    
    /**
     * 2. 단기금융상품/장기금융상품
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public List<Map<String, Object>> getWorkGubun02( Map param ) throws Exception {
        return super.commonDao.list("agc210skrService.getWorkGubun02", param);
    }
    
    /**
     * 3. 외상매출금
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public List<Map<String, Object>> getWorkGubun03( Map param ) throws Exception {
        return super.commonDao.list("agc210skrService.getWorkGubun03", param);
    }
    
    /**
     * 4. 받을어음/지급어음
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public List<Map<String, Object>> getWorkGubun04( Map param ) throws Exception {
        return super.commonDao.list("agc210skrService.getWorkGubun04", param);
    }
    
    /**
     * 5. 거래처별적요 : 미수금, 선급금 등
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public List<Map<String, Object>> getWorkGubun05( Map param ) throws Exception {
        return super.commonDao.list("agc210skrService.getWorkGubun05", param);
    }
    
    /**
     * 6. 미수수익
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public List<Map<String, Object>> getWorkGubun06( Map param ) throws Exception {
        return super.commonDao.list("agc210skrService.getWorkGubun06", param);
    }
    
    /**
     * 7. 선급비용
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public List<Map<String, Object>> getWorkGubun07( Map param ) throws Exception {
        return super.commonDao.list("agc210skrService.getWorkGubun07", param);
    }
    
    /**
     * 8. 재고자산명세서
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public List<Map<String, Object>> getWorkGubun08( Map param ) throws Exception {
        return super.commonDao.list("agc210skrService.getWorkGubun08", param);
    }
    
    /**
     * 9. 보증금
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public List<Map<String, Object>> getWorkGubun09( Map param ) throws Exception {
        return super.commonDao.list("agc210skrService.getWorkGubun09", param);
    }
    
    /**
     * 10. 유형자산
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public List<Map<String, Object>> getWorkGubun10( Map param ) throws Exception {
        return super.commonDao.list("agc210skrService.getWorkGubun10", param);
    }
    
    /**
     * 11. 무형자산
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public List<Map<String, Object>> getWorkGubun11( Map param ) throws Exception {
        return super.commonDao.list("agc210skrService.getWorkGubun11", param);
    }
    
    /**
     * 12. 계정별묶음 : 예수금, 미지급비용 등
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public List<Map<String, Object>> getWorkGubun12( Map param ) throws Exception {
        return super.commonDao.list("agc210skrService.getWorkGubun12", param);
    }
    
    /**
     * 13. 감가상각비
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public List<Map<String, Object>> getWorkGubun13( Map param ) throws Exception {
        return super.commonDao.list("agc210skrService.getWorkGubun13", param);
    }
    
    /**
     * 14. 단기/장기차입금
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public List<Map<String, Object>> getWorkGubun14( Map param ) throws Exception {
        return super.commonDao.list("agc210skrService.getWorkGubun14", param);
    }
    /**
     * 데이터 초기화(삭제)
     * 
     * @param param
     * @throws Exception
     */
    @SuppressWarnings( "rawtypes" )
    public void multiDelete( Map param ) throws Exception {
        super.commonDao.delete("agc210skrService.multiDelete", param);
    }
}
