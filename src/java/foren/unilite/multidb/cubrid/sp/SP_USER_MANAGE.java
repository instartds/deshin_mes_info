package foren.unilite.multidb.cubrid.sp;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class SP_USER_MANAGE {
    
    public static void main( String[] args ) {
        String rtnMessage = SP_USER_MANAGE();
        System.out.println("rtnMessage :: " + rtnMessage);
    }
    
    /**
     * <pre>
     * 함수명 : fnGetBudgAcYyyy 
     * 입력인자 : 
     * 반환값 : 회계년도
     * </pre>
     * 
     * @param sCompcode
     * @param sDate
     * @return
     */
    public static String SP_USER_MANAGE() {
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        ResultSet rs = null;
        String rtnValue = null;
        
        try {
            Class.forName("cubrid.jdbc.driver.CUBRIDDriver");
            conn = DriverManager.getConnection("jdbc:default:connection:");
            //conn = DriverManager.getConnection("jdbc:cubrid:192.168.1.220:30000:OmegaPlus:::?charset=UTF-8", "unilite", "UNILITE");
            //conn = DriverManager.getConnection("jdbc:cubrid:211.241.199.190:30000:CRM:::?charset=UTF-8", "unilite", "UNILITE");
            conn.setAutoCommit(false);
            
            StringBuffer sql = new StringBuffer();
            sql.append("SELECT   'MASTER' AS COMP_CODE, TA.USER_ID AS \"USER_ID\" , TA.USER_ID AS PERSON_NUMB, TA.USER_NM AS user_name, TA.REF_ORGN_CD  \n");
            sql.append("        , TA.POST, TA.ORGN_CD AS dept_code, TA.ORGN_NM \n");
            sql.append("        , 'N' AS sso_user, ta.post_no AS zip_code, ta.adr1 + ' ' + ta.adr2 AS kor_addr, TA.email, ta.tel AS telephon \n");
            sql.append("        , ta.hp_no AS phone, 'D/4avRoIIVNTwjPW4AlhPpXuxCU4Mqdhryj/N6xaFQw=' AS PASSWORD  \n");
            sql.append("        , DECODE(SUM(isYesan) , 1, 'Y', 'N') AS ISyesan     -- 예산권한 \n");
            sql.append("        , DECODE(SUM(isYesan) , 1, 'Y', 'N') AS isInsa      -- 인사권한 \n");
            sql.append("        , DECODE(SUM(isYesan) , 1, 'Y', 'N') AS isMulPum    -- 물품권한 \n");
            sql.append("        , DECODE(SUM(isYesan) , 1, 'Y', 'N') AS isGyueljae  -- 결재권한 \n");
            sql.append("        , DECODE (TA.auth_id,'A100', 'Y','N') AS ISADMIN    -- 권리자 권한  \n");
            sql.append("  FROM \n");
            sql.append("  ( \n");
            sql.append("          SELECT  A.user_id, C.auth_id, F.menu_vw_auth_yn \n");
            sql.append("                , DECODE(F.menu_id, '660100', DECODE(F.menu_vw_auth_yn, 'Y', 1, 0), 0) AS ISYESAN \n");
            sql.append("                , DECODE(F.menu_id, '660200', DECODE(F.menu_vw_auth_yn, 'Y', 1, 0), 0) AS ISINSA \n");
            sql.append("                , DECODE(F.menu_id, '660300', DECODE(F.menu_vw_auth_yn, 'Y', 1, 0), 0) AS ISMULPUM \n");
            sql.append("                , DECODE(F.menu_id, '660400', DECODE(F.menu_vw_auth_yn, 'Y', 1, 0), 0) AS ISGYUELJAE \n");
            sql.append("                , C.AUTH_NM, A.[PASSWORD], A.USER_NM, A.ORGN_CD, E.ORGN_NM, E.ref_orgn_cd AS REF_ORGN_CD, A.POST, B.code_nm AS POST_NM \n");
            sql.append("                , A.EMAIL, A.TEL, A.HP_NO, A.POST_NO, A.ADR1, A.ADR2 \n");
            sql.append("            FROM tb_comm_user       A, \n");
            sql.append("                 tb_comm_cd         B, \n");
            sql.append("                 tb_comm_auth       C, \n");
            sql.append("                 tb_comm_user_auth  D, \n");
            sql.append("                 tb_comm_orgn       E, \n");
            sql.append("                 tb_comm_role       F  \n");
            sql.append("           WHERE B.p_code_id    = 'CMM01'     \n");
            sql.append("             AND a.post         = b.code_id   \n");
            sql.append("             AND a.user_id      = D.user_id   \n");
            sql.append("             AND C.auth_id      = D.auth_id   \n");
            sql.append("             AND a.orgn_cd      = E.orgn_cd   \n");
            sql.append("             AND c.auth_id      =  F.auth_id  \n");
            sql.append("             AND F.menu_id IN ( '660100',  '660200', '660300', '660400' ) \n");
            sql.append("             AND A.USER_ID NOT IN (  SELECT USER_ID FROM BSA300T  )       \n");
            sql.append(") TA  \n");
            sql.append("GROUP BY TA.USER_ID, TA.AUTH_ID, TA.USER_NM, TA.ORGN_CD, TA.ORGN_NM   \n");
            sql.append("       , TA.REF_ORGN_CD, TA.POST, TA.POST_NM, TA.EMAIL, TA.TEL        \n");
            sql.append("       , TA.HP_NO, TA.POST_NO, TA.ADR1, TA.ADR2   \n");
            
            // System.out.println("=======================================================");
            // System.out.println(sql.toString());
            // System.out.println("=======================================================");
            
            pstmt = conn.prepareStatement(sql.toString());
            rs = pstmt.executeQuery();
            
            List<Map<String, Object>> rList = getRsToList(rs);
            
            rs.close();
            pstmt.close();
            
            int insCount = 0;
            Map<String, Object> iMap = null;
            String yn = null;
            
            for (int i = 0; i < rList.size(); i++) {
                String COMP_CODE = (String)( (Map<String, Object>)rList.get(i) ).get("COMP_CODE");
                String DEPT_CODE = (String)( (Map<String, Object>)rList.get(i) ).get("DEPT_CODE");
                String ORGN_NM = (String)( (Map<String, Object>)rList.get(i) ).get("ORGN_NM");
                String REF_ORGN_CD = (String)( (Map<String, Object>)rList.get(i) ).get("REF_ORGN_CD");
                DEPT_CODE = DEPT_CODE == null ? "" : DEPT_CODE.trim();
                ORGN_NM = ORGN_NM == null ? "" : ORGN_NM.trim();
                REF_ORGN_CD = REF_ORGN_CD == null ? "" : REF_ORGN_CD.trim();
                
                //System.out.println("DEPT_CODE :: " + DEPT_CODE + ", REF_ORGN_CD :: " + REF_ORGN_CD );
                
                iMap = new HashMap<String, Object>();
                iMap.put("COMP_CODE", COMP_CODE);
                if (REF_ORGN_CD != null && REF_ORGN_CD.equals("")) {
                    iMap.put("DIV_CODE", DEPT_CODE);
                    iMap.put("TREE_CODE", DEPT_CODE);
                    if (ORGN_NM.equals("")) {
                        iMap.put("ORGN_NM", DEPT_CODE);
                    } else {
                        iMap.put("ORGN_NM", ORGN_NM);
                    }
                } else {
                    iMap.put("DIV_CODE", REF_ORGN_CD);
                    iMap.put("TREE_CODE", REF_ORGN_CD);
                    if (ORGN_NM.equals("")) {
                        iMap.put("ORGN_NM", REF_ORGN_CD);
                    } else {
                        iMap.put("ORGN_NM", ORGN_NM);
                    }
                }
                
                // 사업장존재여부 확인 후 없으면 Insert
                // DEPT_CODE와 REF_ORGN_CD를 받는데... REF_ORGN_CD 가 우선 적용됨.
                yn = getWorkSpaceYn(conn, iMap);
                // System.out.println("yn1 :: " + yn);
                if (yn.equals("N")) {
                    // System.out.println("inCnt 1 :: " + saveWorkSpace(conn, iMap));
                    saveWorkSpace(conn, iMap);
                }
                
                // 부서존재여부 확인 후 없으면 Insert
                // DEPT_CODE와 REF_ORGN_CD를 받는데... REF_ORGN_CD 가 우선 적용됨.
                yn = getDeptYn(conn, iMap);
                // System.out.println("yn2 :: " + yn);
                if (yn.equals("N")) {
                    // System.out.println("inCnt 2 :: " + saveDept(conn, iMap));
                    saveDept(conn, iMap);
                }
                
                // 사용자 등록
                insCount = insCount + saveUser(conn, (Map<String, Object>)rList.get(i));
                
                // 권한 그룹 등록
                saveAuthority(conn, (Map<String, Object>)rList.get(i));
            }
            
            if (pstmt != null) pstmt.close();
            
            rtnValue = "0|" + insCount;
            
            // System.out.println("rtnValue :: " + rtnValue);
            
        } catch (SQLException e) {
            rtnValue = "1|" + e.getMessage();
            try {
                conn.rollback();
            } catch (SQLException e1) {
                e1.printStackTrace();
            }
        } catch (Exception e) {
            rtnValue = "1|" + e.getMessage();
            try {
                conn.rollback();
            } catch (SQLException e1) {
                e1.printStackTrace();
            }
        } finally {
            try {
                conn.setAutoCommit(true);
                
                if (rs != null) rs.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {}
        }
        
        return rtnValue;
    }
    
    /**
     * <pre>
     * 사업장정보의 존재여부 확인
     * </pre>
     * 
     * @param conn
     * @param rList
     * @param i
     * @throws SQLException
     * @throws Exception
     */
    public static String getWorkSpaceYn( Connection conn, Map<String, Object> iMap ) throws SQLException, Exception {
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String renValue = null;
        
        StringBuffer sql = new StringBuffer();
        sql.append("SELECT DECODE(COUNT(1), 0, 'N', 'Y') AS YN FROM BOR120T WHERE COMP_CODE = ? AND DIV_CODE = ?    \n");
        
        // System.out.println("=======================================================");
        // System.out.println(sql.toString());
        // System.out.println("=======================================================");
        try {
            pstmt = conn.prepareStatement(sql.toString());
            
            pstmt.setString(1, (String)iMap.get("COMP_CODE"));
            pstmt.setString(2, (String)iMap.get("DIV_CODE"));
            rs = pstmt.executeQuery();
            
            rs.next();
            
            renValue = rs.getString("YN");
            
            if (pstmt != null) pstmt.close();
            
        } catch (SQLException e) {
            throw new SQLException("[getWorkSpaceYn] " + e.getMessage());
        } catch (Exception e) {
            throw new SQLException("[getWorkSpaceYn] " + e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
            } catch (SQLException e) {}
        }
        
        return renValue;
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
    public static int saveWorkSpace( Connection conn, Map<String, Object> iMap ) throws SQLException, Exception {
        PreparedStatement pstmt = null;
        int inCnt = 0;
        
        StringBuffer sql = new StringBuffer();
        sql.append("INSERT INTO BOR120T ( \n");
        sql.append("        COMP_CODE           , DIV_CODE             , DIV_NAME                 , BILL_DIV_CODE     \n");
        sql.append("      , INSERT_DB_USER      , INSERT_DB_TIME       , UPDATE_DB_USER           , UPDATE_DB_TIME    \n");
        sql.append(") values ( \n");
        sql.append("        ?, ?, ?, ?  \n");
        sql.append("      , 'MIG', NOW(), 'MIG', NOW()   \n");
        sql.append(") \n");
        
        // System.out.println("=======================================================");
        // System.out.println(sql.toString());
        // .out.println("=======================================================");
        try {
            pstmt = conn.prepareStatement(sql.toString());
            
            pstmt.setString(1, (String)iMap.get("COMP_CODE"));
            pstmt.setString(2, (String)iMap.get("DIV_CODE"));
            pstmt.setString(3, (String)iMap.get("ORGN_NM"));
            pstmt.setString(4, (String)iMap.get("DIV_CODE"));
            inCnt = pstmt.executeUpdate();
            
            if (pstmt != null) pstmt.close();
            
        } catch (SQLException e) {
            conn.rollback();
            throw new SQLException("[saveWorkSpace] " + e.getMessage());
        } catch (Exception e) {
            conn.rollback();
            throw new SQLException("[saveWorkSpace] " + e.getMessage());
        }
        
        return inCnt;
    }
    
    /**
     * <pre>
     * 부서정보의 존재여부 확인
     * </pre>
     * 
     * @param conn
     * @param rList
     * @param i
     * @throws SQLException
     * @throws Exception
     */
    public static String getDeptYn( Connection conn, Map<String, Object> iMap ) throws SQLException, Exception {
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String renValue = null;
        
        StringBuffer sql = new StringBuffer();
        sql.append("SELECT DECODE(COUNT(1), 0, 'N', 'Y') AS YN FROM BSA210T WHERE COMP_CODE = ? AND TREE_CODE = ?    \n");
        
        // System.out.println("=======================================================");
        // System.out.println(sql.toString());
        // System.out.println("=======================================================");
        try {
            pstmt = conn.prepareStatement(sql.toString());
            
            pstmt.setString(1, (String)iMap.get("COMP_CODE"));
            pstmt.setString(2, (String)iMap.get("TREE_CODE"));
            rs = pstmt.executeQuery();
            
            rs.next();
            
            renValue = rs.getString("YN");
            
            if (pstmt != null) pstmt.close();
            
        } catch (SQLException e) {
            throw new SQLException("[getDeptYn] " + e.getMessage());
        } catch (Exception e) {
            throw new SQLException("[getDeptYn] " + e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
            } catch (SQLException e) {}
        }
        
        return renValue;
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
    public static int saveDept( Connection conn, Map<String, Object> iMap ) throws SQLException, Exception {
        PreparedStatement pstmt = null;
        int inCnt = 0;
        
        StringBuffer sql = new StringBuffer();
        sql.append("INSERT INTO BSA210T ( \n");
        sql.append("        COMP_CODE           , TREE_CODE            , TREE_NAME                , TYPE_LEVEL             , TREE_LEVEL     \n");
        sql.append("      , INSERT_DB_USER      , INSERT_DB_TIME       , UPDATE_DB_USER           , UPDATE_DB_TIME    \n");
        sql.append(") values ( \n");
        sql.append("        ?, ?, ?, ?, '1'  \n");
        sql.append("      , 'MIG', NOW(), 'MIG', NOW()   \n");
        sql.append(") \n");
        
        // System.out.println("=======================================================");
        // System.out.println(sql.toString());
        // .out.println("=======================================================");
        try {
            pstmt = conn.prepareStatement(sql.toString());
            
            pstmt.setString(1, (String)iMap.get("COMP_CODE"));
            pstmt.setString(2, (String)iMap.get("TREE_CODE"));
            pstmt.setString(3, (String)iMap.get("ORGN_NM"));
            pstmt.setString(4, (String)iMap.get("TREE_CODE"));
            inCnt = pstmt.executeUpdate();
            
            if (pstmt != null) pstmt.close();
            
        } catch (SQLException e) {
            conn.rollback();
            throw new SQLException("[saveDept] " + e.getMessage());
        } catch (Exception e) {
            conn.rollback();
            throw new SQLException("[saveDept] " + e.getMessage());
        }
        
        return inCnt;
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
    public static int saveUser( Connection conn, Map<String, Object> inMap ) throws SQLException, Exception {
        PreparedStatement pstmt = null;
        int inCnt = 0;
        
        StringBuffer sql = new StringBuffer();
        sql.append("INSERT INTO BSA300T ( \n");
        sql.append("        COMP_CODE           , USER_ID              , PERSON_NUMB              , user_name              , erp_user    \n");
        sql.append("      , update_man          , update_date          , pwd_update_date          , div_code               , dept_code   \n");
        sql.append("      , fail_cnt            , lock_yn              , use_yn                   , ref_item               , user_level  \n");
        sql.append("      , sso_user            , zip_code             , kor_addr                 , email_addr             , telephon    \n");
        sql.append("      , phone               , password             , authority_level          , main_comp_yn           , end_date    \n");
        sql.append("      , grade_level         , group_code           , pos_id                   , pos_level              \n");
        sql.append("      , user_gubun          , auth_type            , lock_flag                , approve_flag           , last_login_date       \n");
        sql.append("      , join_date           , retr_date            , post_code                , abil_code              , birth_date     \n");
        sql.append("      , sex_code            , marry_yn             , ext_no                   , self_introe            , pos_pass       \n");
        sql.append("      , insert_db_user      , insert_db_time       , update_db_user           , update_db_time    \n");
        sql.append(") values ( \n");
        sql.append("        '" + (String)inMap.get("COMP_CODE") + "', '" + (String)inMap.get("USER_ID") + "', '" + (String)inMap.get("PERSON_NUMB") + "', '" + (String)inMap.get("USER_NAME") + "', 'Y' \n");  // 1
        
        //System.out.println("=======================================================");
        //System.out.println("USER_NAME :: " + (String)inMap.get("USER_NAME"));
        //System.out.println("=======================================================");
        
        String DEPT_CODE = (String)inMap.get("DEPT_CODE");
        String REF_ORGN_CD = (String)inMap.get("REF_ORGN_CD");
        DEPT_CODE = DEPT_CODE == null ? "" : DEPT_CODE.trim();
        REF_ORGN_CD = REF_ORGN_CD == null ? "" : REF_ORGN_CD.trim();
        
        if (REF_ORGN_CD != null && REF_ORGN_CD.equals("")) {
            sql.append("      , 'MIG', NOW(), NOW(), '" + DEPT_CODE + "', '" + DEPT_CODE + "' \n");  // 2
        } else {
            sql.append("      , 'MIG', NOW(), NOW(), '" + REF_ORGN_CD + "', '" + REF_ORGN_CD + "' \n");  // 2
        }
        
        sql.append("      , 0, 'N', 'Y', '0', '9' \n");  // 3
        sql.append("      , 'N', '" + (String)inMap.get("ZIP_CODE") + "', '" + (String)inMap.get("KOR_ADDR") + "', '" + (String)inMap.get("EMAIL") + "', '" + (String)inMap.get("TELEPHON") + "' \n");  // 4
        sql.append("      , '" + (String)inMap.get("PHONE") + "', '" + (String)inMap.get("PASSWORD") + "', '15', 'Y', '99991231'   \n");
        sql.append("      , 'G5', 'MASTER', 'pos_id', '1'   \n");
        sql.append("      , 'user_gubun', 'auth_type', 'lock_flag', 'approve_flag', NOW()   \n");
        sql.append("      , 'join_date', 'retr_date', '" + (String)inMap.get("POST") + "', 'abil_code', 'birth_date'   \n");
        sql.append("      , 'M', 'N', 'ext_no', '1', '1'   \n");
        sql.append("      , 'MIG', NOW(), 'MIG', NOW()   \n");
        sql.append(") \n");
        
        try {
            pstmt = conn.prepareStatement(sql.toString());
            
            // System.out.println("=======================================================");
            // System.out.println(sql.toString());
            // System.out.println("=======================================================");
            
            inCnt = pstmt.executeUpdate();
            
            // System.out.println("insCount :: " + insCount);
            
            pstmt.close();
            
        } catch (SQLException e) {
            conn.rollback();
            throw new SQLException("[saveUser] " + e.getMessage());
        } catch (Exception e) {
            conn.rollback();
            throw new SQLException("[saveUser] " + e.getMessage());
        }
        
        return inCnt;
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
    public static int saveUser2( Connection conn, Map<String, Object> inMap ) throws SQLException, Exception {
        PreparedStatement pstmt = null;
        int inCnt = 0;
        
        StringBuffer sql = new StringBuffer();
        sql.append("INSERT INTO BSA300T ( \n");
        sql.append("        COMP_CODE           , USER_ID              , PERSON_NUMB              , user_name              , erp_user    \n");
        sql.append("      , update_man          , update_date          , pwd_update_date          , div_code               , dept_code   \n");
        sql.append("      , fail_cnt            , lock_yn              , use_yn                   , ref_item               , user_level  \n");
        sql.append("      , sso_user            , zip_code             , kor_addr                 , email_addr             , telephon    \n");
        sql.append("      , phone               , password             , authority_level          , main_comp_yn           , end_date    \n");
        sql.append("      , grade_level         , group_code           , pos_id                   , pos_level              \n");
        sql.append("      , user_gubun          , auth_type            , lock_flag                , approve_flag           , last_login_date       \n");
        sql.append("      , join_date           , retr_date            , post_code                , abil_code              , birth_date     \n");
        sql.append("      , sex_code            , marry_yn             , ext_no                   , self_introe            , pos_pass       \n");
        sql.append("      , insert_db_user      , insert_db_time       , update_db_user           , update_db_time    \n");
        sql.append(") values ( \n");
        sql.append("        ?, ?, ?, ?, 'Y' \n");
        sql.append("      , 'MIG', NOW(), NOW(), ?, ? \n");
        sql.append("      , 0, 'N', 'Y', '0', '9' \n");
        sql.append("      , 'N', ?, ?, ?, ? \n");
        sql.append("      , ?, ?, '15', 'Y', '99991231'   \n");
        sql.append("      , 'G5', 'MASTER', 'pos_id', '1'   \n");
        sql.append("      , 'user_gubun', 'auth_type', 'lock_flag', 'approve_flag', NOW()   \n");
        sql.append("      , 'join_date', 'retr_date', 'post_code', 'abil_code', 'birth_date'   \n");
        sql.append("      , 'M', 'N', 'ext_no', '1', '1'   \n");
        sql.append("      , 'MIG', NOW(), 'MIG', NOW()   \n");
        sql.append(") \n");
        
        int j = 0;
        
        try {
            pstmt = conn.prepareStatement(sql.toString());
            
            pstmt.setString(++j, (String)inMap.get("COMP_CODE"));
            // System.out.println("j :: " + j + " :: " + inMap.get("COMP_CODE"));
            pstmt.setString(++j, (String)inMap.get("USER_ID"));
            // System.out.println("j :: " + j + " :: " + inMap.get("USER_ID"));
            pstmt.setString(++j, (String)inMap.get("PERSON_NUMB"));
            // System.out.println("j :: " + j + " :: " + inMap.get("PERSON_NUMB"));
            pstmt.setString(++j, (String)inMap.get("USER_NAME"));
            // System.out.println("j :: " + j + " :: " + inMap.get("USER_NAME"));
            
            String DEPT_CODE = (String)inMap.get("DEPT_CODE");
            String REF_ORGN_CD = (String)inMap.get("REF_ORGN_CD");
            DEPT_CODE = DEPT_CODE == null ? "" : DEPT_CODE.trim();
            REF_ORGN_CD = REF_ORGN_CD == null ? "" : REF_ORGN_CD.trim();
            
            String ISADMIN = (String)inMap.get("ISADMIN");
            if (ISADMIN.equals("Y")) {
                pstmt.setString(++j, "01");
                pstmt.setString(++j, "01");
            } else {
                // System.out.println("DEPT_CODE :: " + DEPT_CODE + ", REF_ORGN_CD :: " + REF_ORGN_CD);
                if (REF_ORGN_CD != null && REF_ORGN_CD.equals("")) {
                    pstmt.setString(++j, DEPT_CODE);
                    pstmt.setString(++j, DEPT_CODE);
                } else {
                    pstmt.setString(++j, REF_ORGN_CD);
                    pstmt.setString(++j, REF_ORGN_CD);
                }
            }
            
            pstmt.setString(++j, (String)inMap.get("ZIP_CODE"));
            // System.out.println("j :: " + j + " :: " + inMap.get("ZIP_CODE"));
            pstmt.setString(++j, (String)inMap.get("KOR_ADDR"));
            // System.out.println("j :: " + j + " :: " + inMap.get("KOR_ADDR"));
            pstmt.setString(++j, (String)inMap.get("EMAIL"));
            // System.out.println("j :: " + j + " :: " + inMap.get("EMAIL"));
            pstmt.setString(++j, (String)inMap.get("TELEPHON"));
            // System.out.println("j :: " + j + " :: " + inMap.get("TELEPHON"));
            
            pstmt.setString(++j, (String)inMap.get("PHONE"));
            // System.out.println("j :: " + j + " :: " + inMap.get("PHONE"));
            pstmt.setString(++j, (String)inMap.get("PASSWORD"));
            // System.out.println("j :: " + j + " :: " + inMap.get("PASSWORD"));
            
            // System.out.println("=======================================================");
            // System.out.println(sql.toString());
            // System.out.println("=======================================================");
            
            inCnt = pstmt.executeUpdate();
            
            // System.out.println("insCount :: " + insCount);
            
            pstmt.close();
            
        } catch (SQLException e) {
            conn.rollback();
            throw new SQLException("[saveUser] " + e.getMessage());
        } catch (Exception e) {
            conn.rollback();
            throw new SQLException("[saveUser] " + e.getMessage());
        }
        
        return inCnt;
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
    public static String saveAuthority( Connection conn, Map<String, Object> inMap ) throws SQLException, Exception {
        String rtnValue = null;
        PreparedStatement pstmt = null;
        
        StringBuffer sql = new StringBuffer();
        sql.append("INSERT INTO BSA530T ( \n");
        sql.append("        COMP_CODE           , group_code           , user_id   \n");
        sql.append("      , insert_db_user      , insert_db_time       , update_db_user           , update_db_time    \n");
        sql.append(") values ( \n");
        sql.append("        ?, ?, ?  \n");
        sql.append("      , 'MIG', NOW(), 'MIG', NOW()   \n");
        sql.append(") \n");
        
        String ISYESAN = (String)inMap.get("ISYESAN");
        String ISINSA = (String)inMap.get("ISINSA");
        String ISMULPUM = (String)inMap.get("ISMULPUM");
        String ISGYUELJAE = (String)inMap.get("ISGYUELJAE");
        String ISADMIN = (String)inMap.get("ISADMIN");
        String POST = (String)inMap.get("POST");
        String COMP_CODE = (String)inMap.get("COMP_CODE");
        String USER_ID = (String)inMap.get("USER_ID");
        rtnValue = ISYESAN + "|" + ISINSA + "|" + ISMULPUM + "|" + ISGYUELJAE + "|" + ISADMIN + "|" + POST + "|" + COMP_CODE + "|" + USER_ID;
        
        // System.out.println("=======================================================");
        // System.out.println(sql.toString());
        // .out.println("=======================================================");
        try {
            pstmt = conn.prepareStatement(sql.toString());
            
            /*
             * 직위(POST)   
             * 국내직원 : E04  
             * 해외 사용자 : E03
             * 홍보원장 : E02
             * 문화원장 : E01  인 경우  문화원장 권한 08 부여  하게 바랍니다
             */
            if (POST.equals("E01")) {
                pstmt.setString(1, COMP_CODE);
                pstmt.setString(2, "08");
                pstmt.setString(3, USER_ID);
                pstmt.executeUpdate();
                pstmt.clearParameters();
            } else {
                // System.out.println("ISYESAN :: " + ISYESAN);
                // 예산권한
                if (ISYESAN.equals("Y")) {
                    pstmt.setString(1, COMP_CODE);
                    pstmt.setString(2, "02");
                    pstmt.setString(3, USER_ID);
                    pstmt.executeUpdate();
                    pstmt.clearParameters();
                }
                
                // System.out.println("ISINSA :: " + ISINSA);
                
                // 인사권한
                if (ISINSA.equals("Y")) {
                    pstmt.setString(1, COMP_CODE);
                    pstmt.setString(2, "03");
                    pstmt.setString(3, USER_ID);
                    pstmt.executeUpdate();
                    pstmt.clearParameters();
                }
                
                // System.out.println("ISMULPUM :: " + ISMULPUM);
                
                // 물품권한
                if (ISMULPUM.equals("Y")) {
                    pstmt.setString(1, COMP_CODE);
                    pstmt.setString(2, "06");
                    pstmt.setString(3, USER_ID);
                    pstmt.executeUpdate();
                    pstmt.clearParameters();
                }
                
                // System.out.println("ISGYUELJAE :: " + ISGYUELJAE);
                
                // 결재권한
                if (ISGYUELJAE.equals("Y")) {
                    pstmt.setString(1, COMP_CODE);
                    pstmt.setString(2, "07");
                    pstmt.setString(3, USER_ID);
                    pstmt.executeUpdate();
                    pstmt.clearParameters();
                }
                
                // System.out.println("ISADMIN :: " + ISADMIN);
                
                // Admin권한
                if (ISADMIN.equals("Y")) {
                    pstmt.setString(1, COMP_CODE);
                    pstmt.setString(2, "00");
                    pstmt.setString(3, USER_ID);
                    pstmt.executeUpdate();
                    pstmt.clearParameters();
                }
            }
            
            if (pstmt != null) pstmt.close();
            
        } catch (SQLException e) {
            conn.rollback();
            throw new SQLException("[saveAuthority] " + e.getMessage());
        } catch (Exception e) {
            conn.rollback();
            throw new SQLException("[saveAuthority] " + e.getMessage());
        }
        
        return rtnValue;
    }
    
    /**
     * <pre>
     * CUBRID ResultSet 객체의 데이터를 List에 담아서 리턴하는 Utility Class 입니다.
     * </pre>
     * 
     * @param paramMap
     * @return
     * @throws Exception
     */
    public static List<Map<String, Object>> getRsToList( ResultSet rs ) throws Exception {
        List<Map<String, Object>> rList = new ArrayList<Map<String, Object>>();
        Map<String, Object> map = null;
        
        try {
            ResultSetMetaData rsmd = rs.getMetaData();
            
            while (rs.next()) {
                // logger.info("getRs() || getColumnCount :: " +
                // rsmd.getColumnCount());
                map = new HashMap<String, Object>();
                
                for (int i = 1; i <= rsmd.getColumnCount(); i++) {
                    
                    // System.out.println("getRs() ColumnName :: " +
                    // rsmd.getColumnName(i) + " :: ColumnType :: " +
                    // rsmd.getColumnType(i) + " :: Value :: " +
                    // rs.getString(rsmd.getColumnName(i)));
                    map.put(rsmd.getColumnName(i).toUpperCase(), rs.getString(rsmd.getColumnName(i)));
                }
                
                rList.add(map);
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {}
        
        return rList;
    }
    
}
