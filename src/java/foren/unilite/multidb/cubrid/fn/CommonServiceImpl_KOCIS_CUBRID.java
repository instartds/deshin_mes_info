package foren.unilite.multidb.cubrid.fn;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.utils.DateUtis;

@Service( "commonServiceImpl_KOCIS_CUBRID" )
public class CommonServiceImpl_KOCIS_CUBRID extends TlabAbstractServiceImpl {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    
    /**
     * <pre>
     * CUBRID 용
     * 32자리의 Unique key 생성
     * 
     * - 2017.05.18 박종영
     * </pre>
     * 
     * @param param
     * @param loginVO
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    public String fngGetUniqueKey( Map param ) throws Exception {
        Map rMap = (Map)super.commonDao.queryForObject("commonServiceImpl_KOCIS_CUBRID.selectUniqueKey", null);
        
        return (String)rMap.get("UNIQUE_KEY");
    }
    
    /**
     * <pre>
     * CUBRID 용
     * BSA300T의 REF_ITEM 을 리턴합니다.
     * 
     * - 2017.05.18 박종영
     * </pre>
     * 
     * @param param
     * @param loginVO
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    public String getRefItem_01( Map param ) throws Exception {
        Map rMap = (Map)super.commonDao.queryForObject("commonServiceImpl_KOCIS_CUBRID.getRefItem_01", null);
        
        return (String)rMap.get("REF_ITEM");
    }
    
    /**
     * <pre>
     * CUBRID 용
     * 그룹웨어 연동여부 설정
     * BSA100T의 'A169' 코드에 대한 REF_ITEM 을 리턴합니다.
     * 
     * - 2017.05.25 박종영
     * </pre>
     * 
     * @param param
     * @param loginVO
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    public String getRefItem_02( Map param ) throws Exception {
        Map rMap = (Map)super.commonDao.queryForObject("commonServiceImpl_KOCIS_CUBRID.getRefItem_02", null);
        
        return (String)rMap.get("REF_ITEM");
    }
    
    /**
     * <pre>
     * CUBRID 용
     * BSA100T의 'B044' 코드에 대해 정의된 Date Format 을 리턴합니다.
     * 
     * - 2017.05.18 박종영
     * </pre>
     * 
     * @param param
     * @param loginVO
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    public String getDateFormat_01( Map param ) throws Exception {
        Map rMap = (Map)super.commonDao.queryForObject("commonServiceImpl_KOCIS_CUBRID.getDateFormat_01", null);
        
        return (String)rMap.get("DATE_FORMAT");
    }
    
    /**
     * <pre>
     * CUBRID 용
     * MS-SQL -> CUBRID 변환 작업 중 MS-SQL의 fnGetBudgLevelName 함수를 변환하기위해 생성함.
     * 
     * param 객체셈플
     * param.put("S_COMP_CODE", loginVO.getCompCode());       // 법인코드
     * param.put("S_USER_ID", 'unilite5');                    // 사용자ID
     * 
     * - 2017.05.18 박종영
     * </pre>
     * 
     * @param param
     * @param loginVO
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public List<Map<String, Object>> fnGetBudgLevelName( Map param ) throws Exception {
        List<Map<String, Object>> rList = null;
        
        Map rMap = null;
        String AC_YYYY = null;
        int CODE_LEVEL = 0;
        
        try {
            AC_YYYY = (String)param.get("AC_YYYY");
            if (AC_YYYY == null || AC_YYYY.equals("")) {
                rMap = (Map)super.commonDao.queryForObject("commonServiceImpl_KOCIS_CUBRID.fnGetBudgAcYyyy_01", param);
                logger.info("rMap :: {}", rMap);
                param.put("AC_YYYY", rMap.get("AC_YYYY"));
            }
            
            rMap = (Map)super.commonDao.queryForObject("commonServiceImpl_KOCIS_CUBRID.fnGetBudgLevelName_02", param);
            logger.info("rMap :: {}", rMap);
            CODE_LEVEL = (int)rMap.get("CODE_LEVEL");
            param.put("CODE_LEVEL", rMap.get("CODE_LEVEL"));
            
            rList = super.commonDao.list("commonServiceImpl_KOCIS_CUBRID.fnGetBudgLevelName_03", param);
            logger.info("rList :: {}", rList);
            if (CODE_LEVEL > rList.size()) {
                rMap = new HashMap();
                rMap.put("SUB_CODE", "");
                rMap.put("CODE_NAME", "");
                
                rList.add(rMap);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return rList;
    }
    
    /**
     * <pre>
     * 예산설정정보 조회
     * 
     * CUBRID 용
     * MS-SQL -> CUBRID 변환 작업 중 MS-SQL의 fnGetBudgInfo 함수를 변환하기위해 생성함.
     *
     * param 객체셈플
     * param.put("S_COMP_CODE", loginVO.getCompCode());       // 법인코드
     * param.put("BUDG_YYYYMM", '201705');                    // 예산년월
     * param.put("DEPT_CODE", '3300');                        // 예산부서
     * 
     * - 2017.05.18 박종영
     * </pre>
     * 
     * @param param
     * @param loginVO
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public Map<String, Object> fnGetBudgInfo( Map param ) throws Exception {
        
        Map rMap = null;
        String AC_YYYY = null;
        
        try {
            AC_YYYY = (String)param.get("AC_YYYY");
            if (AC_YYYY == null || AC_YYYY.equals("")) {
                rMap = (Map)super.commonDao.queryForObject("commonServiceImpl_KOCIS_CUBRID.fnGetBudgAcYyyy_01", param);
                logger.info("rMap :: {}", rMap);
                param.put("AC_YYYY", rMap.get("AC_YYYY"));
            }
            
            rMap = (Map)super.commonDao.queryForObject("commonServiceImpl_KOCIS_CUBRID.fnGetBudgInfo", param);
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return rMap;
    }
    
    /**
     * <pre>
     * 사용가능한 예산금액 가져오기
     * 
     * CUBRID 용
     * MS-SQL -> CUBRID 변환 작업 중 MS-SQL의 fnPossibleBudgAmt 함수를 변환하기위해 생성함.
     * 
     * param 객체셈플
     * param.put("S_COMP_CODE", loginVO.getCompCode());       // 법인코드
     * param.put("BUDG_YYYYMM", '201705');                    // 예산년월
     * param.put("DEPT_CODE", '3300');                        // 예산부서
     * param.put("BUDG_CODE", '1');                           // 예산과목
     * param.put("S_USER_ID", loginVO.getUserID());           // 예산구분(1:본월예산, 2:이월예산)
     * 
     * - 2017.05.18 박종영
     * </pre>
     * 
     * @param param
     * @param loginVO
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public Map<String, Object> fnPossibleBudgAmt( Map param ) throws Exception {
        
        Map rMap = null;
        
        String BUDG_GUBUN = param.get("BUDG_GUBUN") == null ? "" : (String)param.get("BUDG_GUBUN");  // (선택)예산구분(1:본월예산, 2:이월예산)
        String CTL_TERM_UNIT = null;
        
        if (param.get("S_COMP_CODE") == null) {
            param.put("S_COMP_CODE", "MASTER");
        }
        if (param.get("BUDG_YYYYMM") == null) {
            param.put("BUDG_YYYYMM", DateUtis.getToDay());
        }
        
        try {
            rMap = (Map)super.commonDao.queryForObject("commonServiceImpl_KOCIS_CUBRID.fnGetBudgAcYyyy_01", param);
            logger.info("rMap :: {}", rMap);
            param.put("AC_YYYY", rMap.get("AC_YYYY"));
            
            rMap = fnGetBudgInfo(param);
            
            // 예산통제단위(AFB300T.CTL_UNIT)에 따른 예산코드 찾기
            param.put("CTL_UNIT", rMap.get("CTL_UNIT"));
            param.put("CTL_CAL_UNIT", rMap.get("CTL_CAL_UNIT"));
            param.put("CTL_TERM_UNIT", rMap.get("CTL_TERM_UNIT"));
            rMap = (Map)super.commonDao.queryForObject("commonServiceImpl_KOCIS_CUBRID.fnPossibleBudgAmt_01", param);
            
            // 예산구분(@BUDG_GUBUN)이 '2:이월예산'이면 예산과목(@BUDG_CODE)의 설정에 상관없이
            // 실적집계대상기간을 '년'으로 설정
            // (이월예산은 사업년도의 첫째달&이월금액(BUDG_IWALL_I)에만 들어오므로.)
            if (BUDG_GUBUN.equals("2")) {
                CTL_TERM_UNIT = "4";
                param.put("CTL_TERM_UNIT", "4");
            }
            
            // 예산통제기간단위(AFB400T.CTL_TERM_UNIT)에 따라 실적집계 대상 기간 계산.
            // ('년'이면 회계기간 전체, '분기' 또는 '반기'일 경우 공통코드 정보 이용)
            if (CTL_TERM_UNIT.equals("4")) {
                rMap = (Map)super.commonDao.queryForObject("commonServiceImpl_KOCIS_CUBRID.fnPossibleBudgAmt_02", param);
            } else {
                rMap = (Map)super.commonDao.queryForObject("commonServiceImpl_KOCIS_CUBRID.fnPossibleBudgAmt_03", param);
            }
            
            param.put("FRYYYYMM", rMap.get("FRYYYYMM"));
            param.put("TOYYYYMM", rMap.get("TOYYYYMM"));
            
            rMap = (Map)super.commonDao.queryForObject("commonServiceImpl_KOCIS_CUBRID.fnPossibleBudgAmt_04", param);
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return rMap;
    }
    
}
