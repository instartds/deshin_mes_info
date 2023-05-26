package foren.unilite.multidb.cubrid.z_kocis;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
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
     * Detail 조회
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public int saveBsa300T( Map param ) throws Exception {
        int insCount = 0;
        
        try {
            List<Map<String, Object>> rList = super.commonDao.list("commonServiceImpl.saveUserList", null);
            logger.info("rList :; " + rList);
            Map<String, Object> iMap = null;
            String yn = null;
            
            for (int i = 0; i < rList.size(); i++) {
                logger.info("rList.get(" + i + ") :; " + rList.get(i));
                
                String COMP_CODE = (String)( (Map<String, Object>)rList.get(i) ).get("COMP_CODE");
                String DEPT_CODE = (String)( (Map<String, Object>)rList.get(i) ).get("DEPT_CODE");
                String ORGN_NM = (String)( (Map<String, Object>)rList.get(i) ).get("ORGN_NM");
                String REF_ORGN_CD = (String)( (Map<String, Object>)rList.get(i) ).get("REF_ORGN_CD");
                DEPT_CODE = DEPT_CODE == null ? "" : DEPT_CODE.trim();
                ORGN_NM = ORGN_NM == null ? "" : ORGN_NM.trim();
                REF_ORGN_CD = REF_ORGN_CD == null ? "" : REF_ORGN_CD.trim();
                
                //                logger.info("COMP_CODE :; " + COMP_CODE);
                //                logger.info("DEPT_CODE :; " + DEPT_CODE);
                //                logger.info("ORGN_NM :; " + ORGN_NM);
                //                logger.info("REF_ORGN_CD :; " + REF_ORGN_CD);
                
                iMap = (Map<String, Object>)rList.get(i);
                if (REF_ORGN_CD.length() > 0) {
                    iMap.put("DIV_CODE", REF_ORGN_CD);
                    iMap.put("TREE_CODE", REF_ORGN_CD);
                    if (ORGN_NM.equals("")) {
                        iMap.put("ORGN_NM", REF_ORGN_CD);
                    } else {
                        iMap.put("ORGN_NM", ORGN_NM);
                    }
                } else {
                    iMap.put("DIV_CODE", DEPT_CODE);
                    iMap.put("TREE_CODE", DEPT_CODE);
                    if (ORGN_NM.equals("")) {
                        iMap.put("ORGN_NM", DEPT_CODE);
                    } else {
                        iMap.put("ORGN_NM", ORGN_NM);
                    }
                }
                
                logger.info("iMap :; " + iMap);
                
                // 사업장존재여부 확인 후 없으면 Insert
                // DEPT_CODE와 REF_ORGN_CD를 받는데... REF_ORGN_CD 가 우선 적용됨.
                yn = (String)super.commonDao.queryForObject("commonServiceImpl.getWorkSpaceYn", iMap);
                // System.out.println("yn1 :: " + yn);
                if (yn.equals("N")) {
                    // System.out.println("inCnt 1 :: " + saveWorkSpace(conn, iMap));
                    saveWorkSpace(iMap);
                }
                
                logger.info("사업장존재여부 확인 종료...");
                
                // 부서존재여부 확인 후 없으면 Insert
                // DEPT_CODE와 REF_ORGN_CD를 받는데... REF_ORGN_CD 가 우선 적용됨.
                yn = (String)super.commonDao.queryForObject("commonServiceImpl.getDeptYn", iMap);
                // System.out.println("yn2 :: " + yn);
                if (yn.equals("N")) {
                    // System.out.println("inCnt 2 :: " + saveDept(conn, iMap));
                    saveDept(iMap);
                }
                
                logger.info("부서존재여부 확인 종료...");
                
                // 권한 그룹 등록
                saveAuthority(iMap);
                
                // 사용자 등록
                insCount = insCount + saveUser(iMap);
                
            }
            
        } catch (Exception e) {
            throw new SQLException(e.getMessage());
        }
        
        return insCount;
    }
    
    /**
     * <pre>
     * 사업장 등록
     * </pre>
     * 
     * @param conn
     * @param iMap
     * @return
     * @throws SQLException
     * @throws Exception
     */
    public int saveWorkSpace( Map<String, Object> iMap ) throws Exception {
        try {
            String COMP_CODE = iMap.get("COMP_CODE") == null ? "" : ((String)iMap.get("COMP_CODE")).trim();
            String DIV_CODE = iMap.get("DIV_CODE") == null ? "" : ((String)iMap.get("DIV_CODE")).trim();
            String DIV_NAME = iMap.get("DIV_NAME") == null ? "" : ((String)iMap.get("DIV_NAME")).trim();
            String BILL_DIV_CODE = iMap.get("BILL_DIV_CODE") == null ? "" : ((String)iMap.get("BILL_DIV_CODE")).trim();
            
            Map<String, Object> param = new HashMap<String, Object>();
            param.put("COMP_CODE", COMP_CODE);
            param.put("DIV_CODE", DIV_CODE);
            if(DIV_NAME.equals("")) {
                param.put("DIV_NAME", DIV_CODE);
            } else {
                param.put("DIV_NAME", DIV_NAME);
            }
            if(BILL_DIV_CODE.equals("")) {
                param.put("BILL_DIV_CODE", DIV_CODE);
            } else {
                param.put("BILL_DIV_CODE", BILL_DIV_CODE);
            }
            
            return super.commonDao.insert("commonServiceImpl.saveWorkSpace", param);
        } catch (Exception e) {
            throw new Exception("[saveWorkSpace] 사업장 등록을 정상처리하지 못 했습니다.");
        }
    }
    
    /**
     * <pre>
     * 사업장정보 등록
     * </pre>
     * 
     * @param conn
     * @param rList
     * @param i
     * @throws SQLException
     * @throws Exception
     */
    public int saveDept( Map<String, Object> iMap ) throws Exception {
        try {
            String COMP_CODE = iMap.get("COMP_CODE") == null ? "" : ((String)iMap.get("COMP_CODE")).trim();
            String TREE_CODE = iMap.get("TREE_CODE") == null ? "" : ((String)iMap.get("TREE_CODE")).trim();
            String TREE_NAME = iMap.get("TREE_NAME") == null ? "" : ((String)iMap.get("TREE_NAME")).trim();
            String TYPE_LEVEL = iMap.get("TYPE_LEVEL") == null ? "" : ((String)iMap.get("TYPE_LEVEL")).trim();
            
            Map<String, Object> param = new HashMap<String, Object>();
            param.put("COMP_CODE", COMP_CODE);
            param.put("TREE_CODE", TREE_CODE);
            if(TREE_NAME.equals("")) {
                param.put("TREE_NAME", TREE_CODE);
            } else {
                param.put("TREE_NAME", TREE_NAME);
            }
            if(TYPE_LEVEL.equals("")) {
                param.put("TYPE_LEVEL", TREE_CODE);
            } else {
                param.put("TYPE_LEVEL", TYPE_LEVEL);
            }
            
            return super.commonDao.insert("commonServiceImpl.saveDept", param);
        } catch (Exception e) {
            throw new Exception("[saveDept] 사업장정보 등록을 정상처리하지 못 했습니다.");
        }
    }
    
    /**
     * <pre>
     * 권한 그룹 등록
     * </pre>
     * 
     * @param conn
     * @param rList
     * @param i
     * @throws SQLException
     * @throws Exception
     */
    public int saveAuthority( Map<String, Object> inMap ) throws Exception {
        int rtnValue = 0;
        
        logger.info("saveAuthority :: inMap :: " + inMap);
        
        String ISYESAN = (String)inMap.get("ISYESAN");
        String ISINSA = (String)inMap.get("ISINSA");
        String ISMULPUM = (String)inMap.get("ISMULPUM");
        String ISGYUELJAE = (String)inMap.get("ISGYUELJAE");
        String ISADMIN = (String)inMap.get("ISADMIN");
        String POST = (String)inMap.get("POST");
        String COMP_CODE = (String)inMap.get("COMP_CODE");
        String USER_ID = (String)inMap.get("USER_ID");
        
        logger.info("ISYESAN :: " + ISYESAN);
        logger.info("ISINSA :: " + ISINSA);
        logger.info("ISMULPUM :: " + ISMULPUM);
        logger.info("ISGYUELJAE :: " + ISGYUELJAE);
        logger.info("ISADMIN :: " + ISADMIN);
        
        Map<String, Object> param = new HashMap<String, Object>();
        try {
            /*
             * 직위(POST) 국내직원 : E04 해외 사용자 : E03 홍보원장 : E02 
             * 문화원장 : E01 인 경우 문화원장 권한 08 부여 하게 바랍니다
             */
            if (POST.equals("E01")) {
                param.put("COMP_CODE", COMP_CODE);
                param.put("GROUP_CODE", "08");
                param.put("USER_ID", USER_ID);
                
                rtnValue = super.commonDao.insert("commonServiceImpl.saveAuthority", param);
            } else {
                // System.out.println("ISYESAN :: " + ISYESAN);
                // 예산권한
                if (ISYESAN.equals("Y")) {
                    param.put("COMP_CODE", COMP_CODE);
                    param.put("GROUP_CODE", "02");
                    param.put("USER_ID", USER_ID);
                    
                    rtnValue = super.commonDao.insert("commonServiceImpl.saveAuthority", param);
                }
                
                // System.out.println("ISINSA :: " + ISINSA);
                
                // 인사권한
                if (ISINSA.equals("Y")) {
                    param.put("COMP_CODE", COMP_CODE);
                    param.put("GROUP_CODE", "03");
                    param.put("USER_ID", USER_ID);
                    
                    rtnValue = super.commonDao.insert("commonServiceImpl.saveAuthority", param);
                }
                
                // System.out.println("ISMULPUM :: " + ISMULPUM);
                
                // 물품권한
                if (ISMULPUM.equals("Y")) {
                    param.put("COMP_CODE", COMP_CODE);
                    param.put("GROUP_CODE", "06");
                    param.put("USER_ID", USER_ID);
                    
                    rtnValue = super.commonDao.insert("commonServiceImpl.saveAuthority", param);
                }
                
                // System.out.println("ISGYUELJAE :: " + ISGYUELJAE);
                
                // 결재권한
                if (ISGYUELJAE.equals("Y")) {
                    param.put("COMP_CODE", COMP_CODE);
                    param.put("GROUP_CODE", "07");
                    param.put("USER_ID", USER_ID);
                    
                    rtnValue = super.commonDao.insert("commonServiceImpl.saveAuthority", param);
                }
                
                // System.out.println("ISADMIN :: " + ISADMIN);
                
                // Admin권한
                if (ISADMIN.equals("Y")) {
                    param.put("COMP_CODE", COMP_CODE);
                    param.put("GROUP_CODE", "00");
                    param.put("USER_ID", USER_ID);
                    
                    rtnValue = super.commonDao.insert("commonServiceImpl.saveAuthority", param);
                }
            }
            
        } catch (Exception e) {
            throw new Exception("[saveAuthority] 권한설정을 정상처리하지 못 했습니다.");
        }
        
        return rtnValue;
    }
    
    /**
     * <pre>
     * 사용자 등록
     * </pre>
     * 
     * @param conn
     * @param rList
     * @param i
     * @return
     * @throws SQLException
     * @throws Exception
     */
    public int saveUser( Map<String, Object> inMap ) throws SQLException, Exception {
        
        Map<String, Object> param = new HashMap<String, Object>();
        
        param.put("COMP_CODE", inMap.get("COMP_CODE"));
        param.put("USER_ID", inMap.get("USER_ID"));
        param.put("PERSON_NUMB", inMap.get("PERSON_NUMB"));
        param.put("USER_NAME", inMap.get("USER_NAME"));
        
        String DEPT_CODE = (String)inMap.get("DEPT_CODE");
        String REF_ORGN_CD = (String)inMap.get("REF_ORGN_CD");
        DEPT_CODE = DEPT_CODE == null ? "" : DEPT_CODE.trim();
        REF_ORGN_CD = REF_ORGN_CD == null ? "" : REF_ORGN_CD.trim();
        
        if (REF_ORGN_CD.length() > 0) {
            param.put("DIV_CODE", REF_ORGN_CD);
            param.put("DEPT_CODE", REF_ORGN_CD);
        } else {
            param.put("DIV_CODE", DEPT_CODE);
            param.put("DEPT_CODE", DEPT_CODE);
        }
        
        param.put("ZIP_CODE", inMap.get("ZIP_CODE"));
        param.put("KOR_ADDR", inMap.get("KOR_ADDR"));
        param.put("EMAIL", inMap.get("EMAIL"));
        param.put("TELEPHON", inMap.get("TELEPHON"));
        param.put("PHONE", inMap.get("PHONE"));
        param.put("PASSWORD", inMap.get("PASSWORD"));
        param.put("POST", inMap.get("POST"));
        
        try {
            return super.commonDao.insert("commonServiceImpl.saveUser", param);
        } catch (Exception e) {
            throw new Exception("[saveUser] 사용자 등록을 정상처리하지 못 했습니다.");
        }
    }
    
    /**
     * Detail 조회
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( "rawtypes" )
    public int deleteBsa300T( Map param ) throws Exception {
        return super.commonDao.delete("commonServiceImpl.deleteUserManager", param);
    }
    
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
            throw ex;
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
            throw ex;
        }
    }
    
}
