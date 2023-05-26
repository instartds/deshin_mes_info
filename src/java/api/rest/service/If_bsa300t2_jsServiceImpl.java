package api.rest.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import api.rest.utils.RestUtils;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.utils.AES256EncryptoUtils;

/**
 * 인사 사원정보
 * 
 * @author 박종영
 */
@Service( "if_bsa300t2_jsServiceImpl" )
public class If_bsa300t2_jsServiceImpl extends TlabAbstractServiceImpl {
    private AES256EncryptoUtils encrypto = new AES256EncryptoUtils();
    RestUtils                   utils    = new RestUtils();
    
    /**
     * 인사 사원정보 조회
     * 
     * @param paramMap
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "stdbase" )
    @SuppressWarnings( { "unchecked", "rawtypes" } )
    public List<Map<String, Object>> selectList( Map param ) throws Exception {
        return super.commonDao.list("if_bsa300t2_jsServiceImpl.selectList", param);
    }
    
    /**************************************************************/
    /*********************** Web Service 용 ***********************/
    /**************************************************************/
    
    /**
     * 인사 사원정보 저장 ( Web Service 용 )
     * 
     * @param jobId
     * @param paramList
     * @return
     * @throws Exception
     */
    public String apiSaveAll( String jobId, List<Map<String, Object>> paramList ) throws Exception {
        //Map map = new HashMap();
        //super.commonDao.update("if_bsa300t2_jsServiceImpl.deleteMulti", map);
        
        /*
         * Temp 폴더에 데이터를 Insert 한다.
         */
        return saveAll(jobId, paramList);
    }
    
    /**
     * 인사 사원정보 저장 ( Web Service 용 )
     * 
     * @param jobId
     * @param paramList
     * @return
     * @throws Exception
     */
    @Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public String saveAll( String jobId, List<Map<String, Object>> paramList ) throws Exception {
        String REPRE_NUM = null;
        String gubun = null;
        int intCnt = 0;
        int uptCnt = 0;
        int delCnt = 0;
        int noCnt = 0;
        
        for (Map param : paramList) {
            param.put("S_USER_ID", "WebService");
            param.put("JOB_ID", jobId);
            
            if (param.get("REPRE_NUM") != null) {
                REPRE_NUM = ( (String)param.get("REPRE_NUM") ).trim().replaceAll("-", "");
                if (REPRE_NUM.length() == 13) {
                    gubun = REPRE_NUM.substring(6, 7);
                    if (gubun.equals("1") || gubun.equals("2")) {
                        param.put("TEMPC_01", "19" + REPRE_NUM.substring(0, 6));
                    } else if (gubun.equals("3") || gubun.equals("4")) {
                        param.put("TEMPC_01", "20" + REPRE_NUM.substring(0, 6));
                    } else {
                        param.put("TEMPC_01", "");
                    }
                } else {
                    param.put("TEMPC_01", "");
                }
                param.put("REPRE_NUM", encrypto.encryto(REPRE_NUM));
            } else {
                param.put("REPRE_NUM", encrypto.encryto(""));
                param.put("TEMPC_01", encrypto.encryto(""));
            }
            if (param.get("BANKBOOK_NUM") != null) {
                param.put("BANKBOOK_NUM", encrypto.encryto(( (String)param.get("BANKBOOK_NUM") ).trim().replaceAll("-", "")));
            } else {
                param.put("BANKBOOK_NUM", encrypto.encryto(""));
            }
            
            if ("I".equals((String)param.get("STATUS"))) {
                intCnt = intCnt + insertMulti(param);
            } else {
                ++noCnt;
            }
        }
        
        return intCnt + "|" + uptCnt + "|" + delCnt + "|" + noCnt;
        
    }
    
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public int migDMSS( String jobId ) {
        
        Map param = new HashMap();
        param.put("JOB_ID", jobId);
        
        super.commonDao.delete("if_bsa300t2_jsServiceImpl.deleteMulti02", null);
        
        return super.commonDao.insert("if_bsa300t2_jsServiceImpl.insertMulti02", param);
    }
    
    /**
     * 인사 사원정보 입력 ( Web Service 용 )
     * 
     * @param paramMap
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    public int insertMulti( Map paramMap ) throws Exception {
        return super.commonDao.insert("if_bsa300t2_jsServiceImpl.insertMulti", paramMap);
    }
    
    /**
     * 인사 사원정보 수정 ( Web Service 용 )
     * 
     * @param paramMap
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    public int updateMulti( Map paramMap ) throws Exception {
        return super.commonDao.update("if_bsa300t2_jsServiceImpl.updateMulti", paramMap);
    }
    
    /**
     * 인사 사원정보 삭제 ( Web Service 용 )
     * 
     * @param paramMap
     * @return
     * @throws Exception
     */
    public int deleteTemp() throws Exception {
        return super.commonDao.delete("if_bsa300t2_jsServiceImpl.deleteTemp", null);
    }
    
    /**
     * 인사 사원정보 삭제 ( Web Service 용 )
     * 
     * @param paramMap
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    public int deleteMulti( Map paramMap ) throws Exception {
        return super.commonDao.update("if_bsa300t2_jsServiceImpl.deleteMulti", paramMap);
    }
    
    /**
     * <pre>
     * 사용자 정보 I/F
     * </pre>
     * 
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
    public void procBsa300tIf( String jobId ) throws Exception {
        
        try {
            Map idMap = (Map)super.commonDao.queryForObject("if_bsa300t2_jsServiceImpl.getJobId", null);
            Map map = new HashMap();
            map.put("JOB_ID", idMap.get("JOB_ID"));
            map.put("INSERT_DB_USER", "WebService");
            
            super.commonDao.queryForObject("if_bsa300t2_jsServiceImpl.USP_JOINS_ACCNT_IF_BSA300T_JS", map);
            
        } catch (Exception e) {
            throw new Exception(utils.errorMsg(e.getMessage()));
        }
    }
    
}
