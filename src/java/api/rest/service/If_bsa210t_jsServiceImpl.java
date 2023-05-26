package api.rest.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

/**
 * 인사 조직정보
 * 
 * @author 박종영
 */
@Service( "if_bsa210t_jsServiceImpl" )
public class If_bsa210t_jsServiceImpl extends TlabAbstractServiceImpl {
    
    /**
     * 인사 조직정보 조회
     * 
     * @param paramMap
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "stdbase" )
    @SuppressWarnings( { "unchecked", "rawtypes" } )
    public List<Map<String, Object>> selectList( Map param ) throws Exception {
        return super.commonDao.list("if_bsa210t_jsServiceImpl.selectList", param);
    }
    
    /**************************************************************/
    /*********************** Web Service 용 ***********************/
    /**************************************************************/
    
    /**
     * 인사 조직정보 저장 ( Web Service 용 )
     * 
     * @param paramList
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    public String apiSaveAll( String jobId, List<Map<String, Object>> paramList ) throws Exception {
        //Map map = new HashMap();
        //super.commonDao.update("if_bsa210t_jsServiceImpl.deleteMulti", map);
        
        /*
         * Temp 폴더에 데이터를 Insert 한다.
         */
        return saveAll(jobId, paramList);
    }
    
    /**
     * 인사 조직정보 저장 ( Web Service 용 )
     * 
     * @param paramList
     * @return
     * @throws Exception
     */
    @Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public String saveAll( String jobId, List<Map<String, Object>> paramList ) throws Exception {
        int intCnt = 0;
        int uptCnt = 0;
        int delCnt = 0;
        int noCnt = 0;
        
        for (Map param : paramList) {
            param.put("JOB_ID", jobId);
            param.put("S_USER_ID", "WebService");
            param.put("S_USER_ID", "WebService");
            
            if ("I".equals((String)param.get("STATUS"))) {
                intCnt = intCnt + insertMulti(param);
            } else {
                ++noCnt;
            }
        }
        return intCnt + "|" + uptCnt + "|" + delCnt + "|" + noCnt;
        
    }
    
    /**
     * 인사 조직정보 입력 ( Web Service 용 )
     * 
     * @param paramMap
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    public int insertMulti( Map paramMap ) throws Exception {
        return super.commonDao.insert("if_bsa210t_jsServiceImpl.insertMulti", paramMap);
    }
    
    /**
     * 인사 조직정보 수정 ( Web Service 용 )
     * 
     * @param paramMap
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    public int updateMulti( Map paramMap ) throws Exception {
        return super.commonDao.update("if_bsa210t_jsServiceImpl.updateMulti", paramMap);
    }
    
    /**
     * 인사 조직정보 삭제 ( Web Service 용 )
     * 
     * @param paramMap
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    public int deleteMulti( Map paramMap ) throws Exception {
        return super.commonDao.update("if_bsa210t_jsServiceImpl.deleteMulti", paramMap);
    }
    
}
