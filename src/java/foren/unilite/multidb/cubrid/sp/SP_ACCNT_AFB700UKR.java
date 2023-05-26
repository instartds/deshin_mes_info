package foren.unilite.multidb.cubrid.sp;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

public class SP_ACCNT_AFB700UKR {
    public static void main( String[] args ) throws Exception {
        USP_ACCNT_AFB700UKR("20170711182410119083", "ko", "unilite5");
    }
    
    //@SuppressWarnings( { "resource", "unused", "rawtypes" } )
    //public static String USP_ACCNT_AFB700UKR( Map param ) throws Exception {
    public static String USP_ACCNT_AFB700UKR( String KEY_VALUE, String LANG_TYPE, String USER_ID ) {
        String rtnValue = null;
        
        try {
            rtnValue = excute_AFB700UKR( KEY_VALUE, LANG_TYPE, USER_ID );
        } catch(Exception e) {
            rtnValue = e.getMessage();
        }
        return rtnValue;
    }
    
    public static String excute_AFB700UKR( String KEY_VALUE, String LANG_TYPE, String USER_ID ) throws Exception {
        //String KEY_VALUE = param.get("KEY_VALUE") == null ? "" : (String)param.get("KEY_VALUE");
        //String LANG_TYPE = param.get("LANG_TYPE") == null ? "" : (String)param.get("LANG_TYPE");
        //String USER_ID = param.get("USER_ID") == null ? "" : (String)param.get("USER_ID");
        
        //String RTN_PAY_DRAFT_NO = ""; /* out */
        String ERROR_DESC = ""; /* out */
        
        //        Map<String, Object> rMap = null;    
        //Map<String, Object> rMap = new HashMap<String, Object>();
        
        Connection conn = null;
        ResultSet rs = null;
        PreparedStatement pstmt = null;
        
        //변수선언1
        String OPR_FLAG = "";
        String COMP_CODE = "";
        String PAY_DRAFT_NO = "";
        String PAY_DATE = "";
        String SLIP_DATE = "";
        
        String DRAFTER = "";
        String PAY_USER = "";
        String DEPT_CODE = "";
        String DIV_CODE = "";
        String BUDG_GUBUN = "";
        
        String ACCNT_GUBUN = "";
        double TOT_AMT_I = 0.0;
        String TITLE = "";
        String TITLE_DESC = "";
        String DRAFT_NO = "";
        
        String PAY_DTL_NO = "";
        String RETURN_REASON = "";
        String RETURN_PRSN = "";
        String RETURN_DATE = "";
        String RETURN_TIME = "";
        
        String STATUS = "";
        String EX_DATE = "";
        String RETURN_CODE = "";
        String PASSWORD = "";
        String REF_CODE6 = "";
        
        // 변수 추가 선언 
        String AC_GUBUN = "";
        String ACCT_NO = "";
        String AC_TYPE = "";
        String NEXT_GUBUN = "";
        String CONTRACT_GUBUN = "";
        
        //변수선언2      
        int SEQ = 0;
        String BUDG_CODE = "";
        
        String ACCNT = "";
        String PJT_CODE = "";
        String BIZ_REMARK = "";
        String BIZ_GUBUN = "";
        
        String PAY_DIVI = "";
        String PROOF_DIVI = "";
        double SUPPLY_AMT_I = 0.0;
        double TAX_AMT_I = 0.0;
        double ADD_REDUCE_AMT_I = 0.0;
        
        double INC_AMT_I = 0.0;
        double LOC_AMT_I = 0.0;
        double REAL_AMT_I = 0.0;
        String CUSTOM_CODE = "";
        
        String CUSTOM_NAME = "";
        String BE_CUSTOM_CODE = "";
        String PEND_CODE = "";
        String PAY_CUSTOM_CODE = "";
        String REMARK = "";
        
        String EB_YN = "";
        String IN_BANK_CODE = "";
        String IN_BANKBOOK_NUM = "";
        String IN_BANKBOOK_NAME = "";
        String CRDT_NUM = "";
        
        String APP_NUM = "";
        String SAVE_CODE = "";
        String REASON_CODE = "";
        String BILL_DATE = "";
        String SEND_DATE = "";
        
        String DEPT_NAME = "";
        String BILL_USER = "";
        String REFER_NUM = "";
        
        String DRAFT_SEQ = "";
        String TRANS_SEQ = "";
        
        //변수선언3
        String isIdMapping = "";
        String CHECK_PASSWORD = "";
        
        //변수선언4
        String GWIF_TYPE = "";
        String DateFormat = "";
        String LinkedGW = "";
        String Amender = "";
        String PayCloseFg = "";
        
        int TransSeq = 0;
        int DraftSeq = 0;
        String TMP_SLIP_DATE = "";
        String SYS_DATE = "";
        
        String OldSlipDate = "";
        
        //변수선언5
        String ExStatus = "";
        String ExDate = "";
        String ExNum = "";
        String OrgSlipDate = "";
        
        GWIF_TYPE = "1";
        
        int tmp700urk = 0;      // exist 처리할 임의 변수
        int tmp_rowcnt = 0;     //rowcount 체크
        
        StringBuffer sql = new StringBuffer();
        
        try {
            
            Class.forName("cubrid.jdbc.driver.CUBRIDDriver");
//            conn = DriverManager.getConnection("jdbc:default:connection");
            conn = DriverManager.getConnection("jdbc:CUBRID:211.241.199.190:30000:CRM:::", "unilite", "UNILITE");
//            conn = DriverManager.getConnection("jdbc:CUBRID:192.168.1.220:33000:OmegaPlus:::", "unilite", "UNILITE");
            
            conn.setAutoCommit(false);
            
            //-- 1. 지출결의마스터 ----------
            sql.append("SELECT opr_flag, ");
            sql.append("       comp_code, ");
            sql.append("       pay_draft_no, ");
            sql.append("       pay_date, ");
            sql.append("       slip_date, ");
            sql.append("       drafter, ");
            sql.append("       pay_user, ");
            sql.append("       dept_code, ");
            sql.append("       div_code, ");
            sql.append("       budg_gubun, ");
            sql.append("       accnt_gubun, ");
            sql.append("       tot_amt_i, ");
            sql.append("       title, ");
            sql.append("       title_desc, ");
            sql.append("       draft_no, ");
            sql.append("       pay_dtl_no, ");
            sql.append("       return_reason, ");
            sql.append("       return_prsn, ");
            sql.append("       return_date, ");
            sql.append("       return_time, ");
            sql.append("       status, ");
            sql.append("       ex_date, ");
            sql.append("       return_code, ");
            sql.append("       return_code,  ");
            sql.append("       ac_gubun,  ");
            sql.append("       acct_no,  ");
            sql.append("       ac_type,  ");
            sql.append("       next_gubun,  ");
            sql.append("       contract_gubun  ");
            sql.append("FROM   l_afb700t ");
            sql.append("WHERE  key_value = ?");
            
            pstmt = conn.prepareStatement(sql.toString());
            pstmt.setString(1, KEY_VALUE);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                OPR_FLAG = rs.getString(1);
                COMP_CODE = rs.getString(2);
                PAY_DRAFT_NO = rs.getString(3);
                PAY_DATE = rs.getString(4);
                SLIP_DATE = rs.getString(5);
                
                DRAFTER = rs.getString(6);
                PAY_USER = rs.getString(7);
                DEPT_CODE = rs.getString(8);
                DIV_CODE = rs.getString(9);
                BUDG_GUBUN = rs.getString(10);
                
                ACCNT_GUBUN = rs.getString(11);
                TOT_AMT_I = rs.getDouble(12);
                TITLE = rs.getString(13);
                TITLE_DESC = rs.getString(14);
                DRAFT_NO = rs.getString(15);
                
                PAY_DTL_NO = rs.getString(16);
                RETURN_REASON = rs.getString(17);
                RETURN_PRSN = rs.getString(18);
                RETURN_DATE = rs.getString(19);
                RETURN_TIME = rs.getString(20);
                
                STATUS = rs.getString(21);
                EX_DATE = rs.getString(22);
                RETURN_CODE = rs.getString(23);
                REF_CODE6 = rs.getString(24);
                AC_GUBUN = rs.getString(25);
                ACCT_NO = rs.getString(26);
                AC_TYPE = rs.getString(27);
                NEXT_GUBUN = rs.getString(28);
                CONTRACT_GUBUN = rs.getString(29);
                
            }
            
            rs.close();
            pstmt.close();
        } catch (SQLException e) {
            throw new Exception("[1] SQLException : " + e.getMessage());
        } catch (Exception e) {
            throw new Exception("[1] Exception : " + e.getMessage());
        }
        
        try {
            sql.setLength(0);
            sql.append("SELECT  DECODE(SUBSTR(?, 5,2) , '01', A.acc_mm01, '02', A.acc_mm02, '03', A.acc_mm03, '04', A.acc_mm04, ");
            sql.append("        '05', A.acc_mm05, '06', A.acc_mm06, '07', A.acc_mm07, '08', A.acc_mm08, ");
            sql.append("        '09', A.acc_mm09, '10', A.acc_mm10, '11', A.acc_mm11, '12', A.acc_mm12, '13',   A.acc_mm13 ) CLOSE_YN ");
            sql.append("  FROM afb910T A ");
            sql.append(" WHERE A.ac_yyyy = ? ");
            sql.append("  AND A.dept_code = ? ");
            
            pstmt = conn.prepareStatement(sql.toString());
            pstmt.setString(1, SLIP_DATE);
            pstmt.setString(2, SLIP_DATE.substring(0, 4));
            pstmt.setString(3, DEPT_CODE);
            
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                PayCloseFg = rs.getString(1);
            }
            rs.close();
            pstmt.close();
            
            System.out.println("PayCloseFg : " + PayCloseFg);
        } catch (SQLException e) {
            throw new Exception("[2] SQLException : " + e.getMessage());
        } catch (Exception e) {
            throw new Exception("[2] Exception : " + e.getMessage());
        }
        
        try {
            if (PayCloseFg == null || PayCloseFg.equals("")) {
                PayCloseFg = "N";
                
            }
            
            if (PayCloseFg.equals("Y")) {
                //-- 해당년도의 지출결의업무가 마감되었으므로 입력, 수정, 삭제가 불가합니다.
                sql.setLength(0);
                sql.append("SELECT '55531;' + Fngettxt('A0273') + ' : ' ");
                sql.append("       + To_char(Cast(? AS DATETIME), 'YYYY.MM.DD')");
                
                pstmt = conn.prepareStatement(sql.toString());
                pstmt.setString(1, SLIP_DATE);
                
                rs = pstmt.executeQuery();
                
                while (rs.next()) {
                    ERROR_DESC = rs.getString(1);
                    
                }
                rs.close();
                pstmt.close();
                
                //rMap.put("RTN_PAY_DRAFT_NO", PAY_DRAFT_NO);
                //rMap.put("ERROR_DESC", ERROR_DESC);
                
                System.out.println("지출결의번호 : " + PAY_DRAFT_NO);
                System.out.println("에러상세 : " + ERROR_DESC);
                
                //return rMap;
                return PAY_DRAFT_NO + "|" + ERROR_DESC;
            }
            
            //-- 지출결의번호의 전표일자를 변수에 담음. 일자 수정시 AFB510T에 UPDATE하는 로직에서 일자를 사용함    
            System.out.println("OPR_FLAG : " + OPR_FLAG);
            if (!OPR_FLAG.equals("N")) {
                
                sql.setLength(0);
                sql.append("SELECT * ");
                sql.append("FROM   (SELECT slip_date ");
                sql.append("        FROM   afb700t ");
                sql.append("        WHERE  comp_code = ? ");
                sql.append("               AND pay_draft_no = ? ) TOPT ");
                sql.append("WHERE  rownum = 1");
                
                pstmt = conn.prepareStatement(sql.toString());
                pstmt.setString(1, COMP_CODE);
                pstmt.setString(2, PAY_DRAFT_NO);
                
                rs = pstmt.executeQuery();
                
                while (rs.next()) {
                    TMP_SLIP_DATE = rs.getString(1);
                    
                }
                rs.close();
                pstmt.close();
                
                if (TMP_SLIP_DATE == null || TMP_SLIP_DATE.equals("")) {
                    OldSlipDate = SLIP_DATE;
                    
                } else {
                    OldSlipDate = TMP_SLIP_DATE;
                    
                }
                
            }
        } catch (SQLException e) {
            throw new Exception("[3] SQLException : " + e.getMessage());
        } catch (Exception e) {
            throw new Exception("[3] Exception : " + e.getMessage());
        }
        
        try {
            System.out.println("OPR_FLAG : " + OPR_FLAG);
            //-- 결재상태/기표여부 체크
            if (!OPR_FLAG.equals("N")) {
                
                //--  [ 날짜 포맷 유형 설정 ] --------------
                sql.setLength(0);
                sql.append("SELECT * ");
                sql.append("FROM   (SELECT M1.code_name ");
                sql.append("        FROM   bsa100t M1 ");
                sql.append("        WHERE  M1.comp_code = ? ");
                sql.append("        AND  M1.main_code = 'B044' ");
                sql.append("        AND      M1.ref_code1 = 'Y') TOPT ");
                sql.append("WHERE  rownum = 1");
                
                pstmt = conn.prepareStatement(sql.toString());
                pstmt.setString(1, COMP_CODE);
                
                rs = pstmt.executeQuery();
                
                while (rs.next()) {
                    DateFormat = rs.getString(1);
                    
                }
                rs.close();
                pstmt.close();
                
                if (DateFormat == null || DateFormat.equals("")) {
                    DateFormat = "YYYY/MM/DD";
                    
                }
                
                //--  [ 그룹웨어 연동여부 설정 ] -------------
                sql.setLength(0);
                sql.append("SELECT * ");
                sql.append("FROM   (SELECT M1.REF_CODE1  ");
                sql.append("        FROM   bsa100t M1 ");
                sql.append("        WHERE  M1.comp_code = ?  ");
                sql.append("        AND      M1.main_code = 'A169' ");
                sql.append("        AND      M1.sub_code = '20') TOPT ");
                sql.append("WHERE  rownum = 1");
                
                pstmt = conn.prepareStatement(sql.toString());
                pstmt.setString(1, COMP_CODE);
                
                rs = pstmt.executeQuery();
                
                while (rs.next()) {
                    LinkedGW = rs.getString(1);
                    
                }
                rs.close();
                pstmt.close();
                
                System.out.println("LinkedGW : " + LinkedGW);
                
                if (LinkedGW == null || LinkedGW.equals("")) {
                    LinkedGW = "N";
                    
                }
                
                //--  [ 등록된 수정자 설정 ] ------
                sql.setLength(0);
                sql.append("SELECT 1 ");
                sql.append("FROM   bsa100t M1 ");
                sql.append("WHERE  comp_code = ?  ");
                sql.append("       AND main_code = 'A179' ");
                sql.append("       AND sub_code = ? ");
                
                pstmt = conn.prepareStatement(sql.toString());
                pstmt.setString(1, COMP_CODE);
                pstmt.setString(2, USER_ID);
                
                rs = pstmt.executeQuery();
                
                while (rs.next()) {
                    tmp700urk = 0; //exits 초기화
                    tmp700urk = rs.getInt(1);
                    
                }
                rs.close();
                pstmt.close();
                
                //--  [ 결재상태 / 기표여부 조회] ------------
                sql.setLength(0);
                sql.append("SELECT  CASE WHEN  ?  = 'Y' THEN NVL(B.GW_STATUS, '0') ");
                sql.append("                                     ELSE A.STATUS ");
                sql.append("                                END ");
                sql.append("                  , REPLACE( ");
                sql.append("                                REPLACE( ");
                sql.append("                                REPLACE(  ?  , 'YYYY', SUBSTR(A.EX_DATE, 1, 4)) ");
                sql.append("                                                   , 'MM'  , SUBSTR(A.EX_DATE, 5, 2)) ");
                sql.append("                                                   , 'DD'  , SUBSTR(A.EX_DATE, 7, 2)) ");
                sql.append("                  , A.SLIP_DATE ");
                sql.append("            FROM                AFB700T   A ");
                sql.append("                    LEFT  JOIN  BSA100T   M1  ON M1.COMP_CODE  = A.COMP_CODE ");
                sql.append("                                                          AND M1.MAIN_CODE  = 'S091' ");
                sql.append("                                                          AND M1.SUB_CODE   = A.COMP_CODE ");
                sql.append("                    LEFT  JOIN  T_GWIF    B   ON B.GWIF_ID     = M1.REF_CODE1 +  ?  + A.PAY_DRAFT_NO ");
                sql.append("            WHERE   A.COMP_CODE     =  ?  ");
                sql.append("            AND     A.PAY_DRAFT_NO  =  ?  ");
                
                pstmt = conn.prepareStatement(sql.toString());
                pstmt.setString(1, LinkedGW);
                pstmt.setString(2, DateFormat);
                pstmt.setString(3, GWIF_TYPE);
                pstmt.setString(4, COMP_CODE);
                pstmt.setString(5, PAY_DRAFT_NO);
                
                rs = pstmt.executeQuery();
                
                while (rs.next()) {
                    ExStatus = rs.getString(1);
                    ExDate = rs.getString(2);
                    OrgSlipDate = rs.getString(3);
                    
                }
                
                rs.close();
                pstmt.close();
                
                //IF ( @@ROWCOUNT = 0 )
                sql.setLength(0);
                sql.append("SELECT count(*) FROM ( ");
                sql.append("SELECT  CASE WHEN  ?  = 'Y' THEN NVL(B.GW_STATUS, '0') ");
                sql.append("                                     ELSE A.STATUS ");
                sql.append("                                END ");
                sql.append("                  , REPLACE( ");
                sql.append("                                REPLACE( ");
                sql.append("                                REPLACE(  ?  , 'YYYY', SUBSTR(A.EX_DATE, 1, 4)) ");
                sql.append("                                                   , 'MM'  , SUBSTR(A.EX_DATE, 5, 2)) ");
                sql.append("                                                   , 'DD'  , SUBSTR(A.EX_DATE, 7, 2)) ");
                sql.append("                  , A.SLIP_DATE ");
                sql.append("            FROM                AFB700T   A ");
                sql.append("                    LEFT  JOIN  BSA100T   M1  ON M1.COMP_CODE  = A.COMP_CODE ");
                sql.append("                                                          AND M1.MAIN_CODE  = 'S091' ");
                sql.append("                                                          AND M1.SUB_CODE   = A.COMP_CODE ");
                sql.append("                    LEFT  JOIN  T_GWIF    B   ON B.GWIF_ID     = M1.REF_CODE1 +  ?  + A.PAY_DRAFT_NO ");
                sql.append("            WHERE   A.COMP_CODE     =  ?  ");
                sql.append("            AND     A.PAY_DRAFT_NO  =  ?  ");
                sql.append(") TOPT WHERE ROWNUM = 1  ");
                
                pstmt = conn.prepareStatement(sql.toString());
                pstmt.setString(1, LinkedGW);
                pstmt.setString(2, DateFormat);
                pstmt.setString(3, GWIF_TYPE);
                pstmt.setString(4, COMP_CODE);
                pstmt.setString(5, PAY_DRAFT_NO);
                
                rs = pstmt.executeQuery();
                
                while (rs.next()) {
                    tmp_rowcnt = 0;
                    tmp_rowcnt = rs.getInt(1);
                    
                }
                rs.close();
                pstmt.close();
                
                if (tmp_rowcnt == 0) {
                    //-- 작업할 자료가 존재하지 않습니다.
                    ERROR_DESC = "54361;";
                    
                    //                    rMap.put("RTN_PAY_DRAFT_NO", PAY_DRAFT_NO);
                    //                    rMap.put("ERROR_DESC", ERROR_DESC);
                    
                    System.out.println("지출결의번호 : " + PAY_DRAFT_NO);
                    System.out.println("에러상세 : " + ERROR_DESC);
                    //                    return rMap;
                    return PAY_DRAFT_NO + "|" + ERROR_DESC;
                }
                
                if (!ExStatus.equals("0")) {
                    //-- 전자결재가 진행중이므로 수정/삭제할 수 없습니다.
                    ERROR_DESC = "90004;";
                    
                    //rMap.put("RTN_PAY_DRAFT_NO", PAY_DRAFT_NO);
                    //                    rMap.put("ERROR_DESC", ERROR_DESC);
                    
                    System.out.println("지출결의번호 : " + PAY_DRAFT_NO);
                    System.out.println("에러상세 : " + ERROR_DESC);
                    //return rMap;
                    return PAY_DRAFT_NO + "|" + ERROR_DESC;
                }
                
            }
        } catch (SQLException e) {
            throw new Exception("[4] SQLException : " + e.getMessage());
        } catch (Exception e) {
            throw new Exception("[4] Exception : " + e.getMessage());
        }
        
        try {
            //-- 1.1. 지출결의번호 생성 
            if (PAY_DRAFT_NO == null || PAY_DRAFT_NO.equals("")) {
                
                sql.setLength(0);
                sql.append(" SELECT '2'+ ? + ?  + TO_CHAR  (NVL(MAX(CAST (SUBSTRING(PAY_DRAFT_NO, 10) AS INT)),0) +1, '00000') ");
                sql.append(" FROM AFB700T ");
                sql.append(" WHERE COMP_CODE = ? ");
                sql.append(" AND DEPT_CODE = ? ");
                sql.append(" AND SUBSTRING(PAY_DATE,0,4) = ? ");
                pstmt = conn.prepareStatement(sql.toString());
                
                pstmt.setString(1, DEPT_CODE);
                pstmt.setString(2, PAY_DATE.substring(0, 4));
                pstmt.setString(3, COMP_CODE);
                pstmt.setString(4, DEPT_CODE);
                pstmt.setString(5, PAY_DATE.substring(0, 4));
                
                rs = pstmt.executeQuery();
                
                while (rs.next()) {
                    PAY_DRAFT_NO = rs.getString(1);
                    
                }
                rs.close();
                pstmt.close();
                
            }
        } catch (SQLException e) {
            throw new Exception("[5] SQLException : " + e.getMessage());
        } catch (Exception e) {
            throw new Exception("[5] Exception : " + e.getMessage());
        }
        
        try {
            //-- 1.2. 지급명세서 참조에 대한 처리
            
            //-- 1.3. 지출결의마스터 데이터반영
            if (OPR_FLAG.equals("D")) {
                
                sql.setLength(0);
                sql.append("DELETE FROM afb700t ");
                sql.append("WHERE  comp_code = ?  ");
                sql.append("       AND pay_draft_no = ? ");
                
                pstmt = conn.prepareStatement(sql.toString());
                pstmt.setString(1, COMP_CODE);
                pstmt.setString(2, PAY_DRAFT_NO);
                
                pstmt.executeUpdate();
                
                pstmt.close();
                
            }
            
            if (OPR_FLAG.equals("U")) {
                sql.setLength(0);
                sql.append("UPDATE afb700t ");
                sql.append("SET    pay_date = ? , ");
                sql.append("       slip_date = ? , ");
                sql.append("       drafter = ? , ");
                sql.append("       pay_user = ? , ");
                sql.append("       dept_code = ? , ");
                sql.append("       div_code = ? , ");
                sql.append("       budg_gubun = ? , ");
                sql.append("       accnt_gubun = ? , ");
                sql.append("       tot_amt_i = ? , ");
                sql.append("       title = ? , ");
                sql.append("       title_desc = ? , ");
                sql.append("       draft_no = ? , ");
                sql.append("       pay_dtl_no = ? , ");
                sql.append("       return_reason = ? , ");
                sql.append("       return_prsn = ? , ");
                sql.append("       return_date = ? , ");
                sql.append("       return_time = ? , ");
                sql.append("       status = ? , ");
                sql.append("       ex_date = ? , ");
                sql.append("       return_code = ? , ");
                
                sql.append("       ac_gubun = ? , ");
                sql.append("       acct_no = ? , ");
                sql.append("       ac_type = ? , ");
                sql.append("       next_gubun = ? , ");
                sql.append("       contract_gubun = ? , ");
                
                sql.append("       update_db_user = ? , ");
                sql.append("       update_db_time = sysdatetime ");
                sql.append("WHERE  comp_code = ?  ");
                sql.append("       AND pay_draft_no = ? ");
                
                pstmt = conn.prepareStatement(sql.toString());
                pstmt.setString(1, PAY_DATE);
                pstmt.setString(2, SLIP_DATE);
                pstmt.setString(3, DRAFTER);
                pstmt.setString(4, PAY_USER);
                pstmt.setString(5, DEPT_CODE);
                pstmt.setString(6, DIV_CODE);
                pstmt.setString(7, BUDG_GUBUN);
                pstmt.setString(8, ACCNT_GUBUN);
                pstmt.setDouble(9, TOT_AMT_I);
                pstmt.setString(10, TITLE);
                pstmt.setString(11, TITLE_DESC);
                pstmt.setString(12, DRAFT_NO);
                pstmt.setString(13, PAY_DTL_NO);
                pstmt.setString(14, RETURN_REASON);
                pstmt.setString(15, RETURN_PRSN);
                pstmt.setString(16, RETURN_DATE);
                pstmt.setString(17, RETURN_TIME);
                pstmt.setString(18, STATUS);
                pstmt.setString(19, EX_DATE);
                pstmt.setString(20, RETURN_CODE);
                
                pstmt.setString(21, AC_GUBUN);
                pstmt.setString(22, ACCT_NO);
                pstmt.setString(23, AC_TYPE);
                pstmt.setString(24, NEXT_GUBUN);
                pstmt.setString(25, CONTRACT_GUBUN);
                
                pstmt.setString(26, USER_ID);
                pstmt.setString(27, COMP_CODE);
                pstmt.setString(28, PAY_DRAFT_NO);
                
                pstmt.executeUpdate();
                
                pstmt.close();
                
            }
            
            if (OPR_FLAG.equals("N")) {
                sql.setLength(0);
                sql.append("INSERT INTO AFB700T ");
                sql.append("            (COMP_CODE ");
                sql.append("             ,PAY_DRAFT_NO ");
                sql.append("             ,PAY_DATE ");
                sql.append("             ,SLIP_DATE ");
                sql.append("             ,DRAFTER ");
                sql.append("             ,PAY_USER ");
                sql.append("             ,DEPT_CODE ");
                sql.append("             ,DIV_CODE ");
                sql.append("             ,BUDG_GUBUN ");
                sql.append("             ,ACCNT_GUBUN ");
                sql.append("             ,TOT_AMT_I ");
                sql.append("             ,TITLE ");
                sql.append("             ,TITLE_DESC ");
                sql.append("             ,DRAFT_NO ");
                sql.append("             ,PAY_DTL_NO ");
                sql.append("             ,RETURN_REASON ");
                sql.append("             ,RETURN_PRSN ");
                sql.append("             ,RETURN_DATE ");
                sql.append("             ,RETURN_TIME ");
                sql.append("             ,STATUS ");
                sql.append("             ,EX_DATE ");
                sql.append("             ,RETURN_CODE ");
                
                sql.append("             ,AC_GUBUN ");
                sql.append("             ,ACCT_NO ");
                sql.append("             ,AC_TYPE ");
                sql.append("             ,NEXT_GUBUN ");
                sql.append("             ,CONTRACT_GUBUN ");
                
                sql.append("             ,INSERT_DB_USER ");
                sql.append("             ,INSERT_DB_TIME ");
                sql.append("             ,UPDATE_DB_USER ");
                sql.append("             ,UPDATE_DB_TIME) ");
                sql.append("SELECT   ? ");
                sql.append("       , ? ");
                sql.append("       , ?  ");
                sql.append("       , ? ");
                sql.append("       , ? ");
                sql.append("       , ? ");
                sql.append("       , ? ");
                sql.append("       , ? ");
                sql.append("       , ? ");
                sql.append("       , ? ");
                sql.append("       , ? ");
                sql.append("       , ? ");
                sql.append("       , ? ");
                sql.append("       , ? ");
                sql.append("       , ? ");
                sql.append("       , ? ");
                sql.append("       , ? ");
                sql.append("       , ? ");
                sql.append("       , ? ");
                sql.append("       , ? ");
                sql.append("       , ? ");
                sql.append("       , ? ");
                
                sql.append("       , ? ");
                sql.append("       , ? ");
                sql.append("       , ? ");
                sql.append("       , ? ");
                sql.append("       , ? ");
                
                sql.append("       , ? ");
                sql.append("       , SYSDATETIME ");
                sql.append("       , ? ");
                sql.append("       , SYSDATETIME ");
                
                pstmt = conn.prepareStatement(sql.toString());
                pstmt.setString(1, COMP_CODE);
                pstmt.setString(2, PAY_DRAFT_NO);
                pstmt.setString(3, PAY_DATE);
                pstmt.setString(4, SLIP_DATE);
                pstmt.setString(5, DRAFTER);
                pstmt.setString(6, PAY_USER);
                pstmt.setString(7, DEPT_CODE);
                pstmt.setString(8, DIV_CODE);
                pstmt.setString(9, BUDG_GUBUN);
                pstmt.setString(10, ACCNT_GUBUN);
                pstmt.setDouble(11, TOT_AMT_I);
                pstmt.setString(12, TITLE);
                pstmt.setString(13, TITLE_DESC);
                pstmt.setString(14, DRAFT_NO);
                pstmt.setString(15, PAY_DTL_NO);
                pstmt.setString(16, RETURN_REASON);
                pstmt.setString(17, RETURN_PRSN);
                pstmt.setString(18, RETURN_DATE);
                pstmt.setString(19, RETURN_TIME);
                pstmt.setString(20, STATUS);
                pstmt.setString(21, EX_DATE);
                pstmt.setString(22, RETURN_CODE);
                
                pstmt.setString(23, AC_GUBUN);
                pstmt.setString(24, ACCT_NO);
                pstmt.setString(25, AC_TYPE);
                pstmt.setString(26, NEXT_GUBUN);
                pstmt.setString(27, CONTRACT_GUBUN);
                
                pstmt.setString(28, USER_ID);
                pstmt.setString(29, USER_ID);
                
                pstmt.executeUpdate();
                
                pstmt.close();
                
            }
        } catch (SQLException e) {
            throw new Exception("[6] SQLException : " + e.getMessage());
        } catch (Exception e) {
            throw new Exception("[6] Exception : " + e.getMessage());
        }
        
        try {
            //-- 2. 지출결의디테일 데이터반영
            
            ResultSet rs2 = null;
            PreparedStatement pstmt2 = null;
            StringBuffer sql2 = new StringBuffer();
            
            sql2.setLength(0);
            sql2.append("SELECT  A.OPR_FLAG ");
            sql2.append("       ,A.COMP_CODE ");
            sql2.append("       ,A.SEQ ");
            sql2.append("       ,A.BUDG_CODE ");
            sql2.append("       ,A.ACCNT ");
            sql2.append("       ,A.PJT_CODE ");
            sql2.append("       ,A.BUDG_GUBUN ");
            sql2.append("       ,A.BIZ_REMARK ");
            sql2.append("       ,A.BIZ_GUBUN ");
            sql2.append("       ,A.PAY_DIVI ");
            sql2.append("       ,A.PROOF_DIVI ");
            sql2.append("       ,A.SUPPLY_AMT_I ");
            sql2.append("       ,A.TAX_AMT_I ");
            sql2.append("       ,A.ADD_REDUCE_AMT_I ");
            sql2.append("       ,A.TOT_AMT_I ");
            sql2.append("       ,A.INC_AMT_I ");
            sql2.append("       ,A.LOC_AMT_I ");
            sql2.append("       ,A.REAL_AMT_I ");
            sql2.append("       ,A.CUSTOM_CODE ");
            sql2.append("       ,A.CUSTOM_NAME ");
            sql2.append("       ,A.BE_CUSTOM_CODE ");
            sql2.append("       ,A.PEND_CODE ");
            sql2.append("       ,A.PAY_CUSTOM_CODE ");
            sql2.append("       ,A.REMARK ");
            sql2.append("       ,A.EB_YN ");
            sql2.append("       ,A.IN_BANK_CODE ");
            sql2.append("       ,A.IN_BANKBOOK_NUM ");
            sql2.append("       ,A.IN_BANKBOOK_NAME ");
            sql2.append("       ,A.CRDT_NUM ");
            sql2.append("       ,A.APP_NUM ");
            sql2.append("       ,A.SAVE_CODE ");
            sql2.append("       ,A.REASON_CODE ");
            sql2.append("       ,A.BILL_DATE ");
            sql2.append("       ,A.SEND_DATE ");
            sql2.append("       ,A.DEPT_CODE ");
            sql2.append("       ,NVL(B.TREE_NAME,'') AS DEPT_NAME ");
            sql2.append("       ,A.DIV_CODE ");
            sql2.append("       ,A.BILL_USER ");
            sql2.append("       ,A.REFER_NUM ");
            sql2.append("       ,NVL(A.DRAFT_NO,'') AS DRAFT_NO");
            sql2.append("       ,A.DRAFT_SEQ ");
            sql2.append("       ,A.TRANS_SEQ ");
            
            sql2.append("       ,A.CURR_UNIT ");
            sql2.append("       ,A.CURR_RATE ");
            sql2.append("       ,A.CHECK_NO ");
            sql2.append("       ,A.ACCT_NO ");
            sql2.append("       ,A.BUDG_AMT_I ");
            
            sql2.append("FROM   L_AFB710T A ");
            sql2.append("LEFT JOIN BSA210T B ON B.COMP_CODE = A.COMP_CODE ");
            sql2.append("                   AND B.TREE_CODE = A.DEPT_CODE ");
            sql2.append("WHERE  A.KEY_VALUE = ? ");
            
            pstmt2 = conn.prepareStatement(sql2.toString());
            pstmt2.setString(1, KEY_VALUE);
            
            rs2 = pstmt2.executeQuery();
            
            String cur_OPR_FLAG = "";
            String cur_COMP_CODE = "";
            int cur_SEQ = 0;
            String cur_BUDG_CODE = "";
            String cur_ACCNT = "";
            String cur_PJT_CODE = "";
            String cur_BUDG_GUBUN = "";
            String cur_BIZ_REMARK = "";
            String cur_BIZ_GUBUN = "";
            String cur_PAY_DIVI = "";
            String cur_PROOF_DIVI = "";
            double cur_SUPPLY_AMT_I = 0.0;
            double cur_TAX_AMT_I = 0.0;
            double cur_ADD_REDUCE_AMT_I = 0.0;
            double cur_TOT_AMT_I = 0.0;
            double cur_INC_AMT_I = 0.0;
            double cur_LOC_AMT_I = 0.0;
            double cur_REAL_AMT_I = 0.0;
            String cur_CUSTOM_CODE = "";
            String cur_CUSTOM_NAME = "";
            String cur_BE_CUSTOM_CODE = "";
            String cur_PEND_CODE = "";
            String cur_PAY_CUSTOM_CODE = "";
            String cur_REMARK = "";
            String cur_EB_YN = "";
            String cur_IN_BANK_CODE = "";
            String cur_IN_BANKBOOK_NUM = "";
            String cur_IN_BANKBOOK_NAME = "";
            String cur_CRDT_NUM = "";
            String cur_APP_NUM = "";
            String cur_SAVE_CODE = "";
            String cur_REASON_CODE = "";
            String cur_BILL_DATE = "";
            String cur_SEND_DATE = "";
            String cur_DEPT_CODE = "";
            String cur_DEPT_NAME = "";
            String cur_DIV_CODE = "";
            String cur_BILL_USER = "";
            String cur_REFER_NUM = "";
            String cur_DRAFT_NO = "";
            int cur_DRAFT_SEQ = 0;
            int cur_TRANS_SEQ = 0;
            
            String cur_CURR_UNIT = "";
            double cur_CURR_RATE = 0.0;
            String cur_CHECK_NO = "";
            String cur_ACCT_NO = "";
            double cur_BUDG_AMT_I = 0.0;
            
            while (rs2.next()) {
                cur_OPR_FLAG = rs2.getString(1);
                cur_COMP_CODE = rs2.getString(2);
                cur_SEQ = rs2.getInt(3);
                cur_BUDG_CODE = rs2.getString(4);
                cur_ACCNT = rs2.getString(5);
                cur_PJT_CODE = rs2.getString(6);
                cur_BUDG_GUBUN = rs2.getString(7);
                cur_BIZ_REMARK = rs2.getString(8);
                cur_BIZ_GUBUN = rs2.getString(9);
                cur_PAY_DIVI = rs2.getString(10);
                cur_PROOF_DIVI = rs2.getString(11);
                cur_SUPPLY_AMT_I = rs2.getDouble(12);
                cur_TAX_AMT_I = rs2.getDouble(13);
                cur_ADD_REDUCE_AMT_I = rs2.getDouble(14);
                cur_TOT_AMT_I = rs2.getDouble(15);
                cur_INC_AMT_I = rs2.getDouble(16);
                cur_LOC_AMT_I = rs2.getDouble(17);
                cur_REAL_AMT_I = rs2.getDouble(18);
                cur_CUSTOM_CODE = rs2.getString(19);
                cur_CUSTOM_NAME = rs2.getString(20);
                cur_BE_CUSTOM_CODE = rs2.getString(21);
                cur_PEND_CODE = rs2.getString(22);
                cur_PAY_CUSTOM_CODE = rs2.getString(23);
                cur_REMARK = rs2.getString(24);
                cur_EB_YN = rs2.getString(25);
                cur_IN_BANK_CODE = rs2.getString(26);
                cur_IN_BANKBOOK_NUM = rs2.getString(27);
                cur_IN_BANKBOOK_NAME = rs2.getString(28);
                cur_CRDT_NUM = rs2.getString(29);
                cur_APP_NUM = rs2.getString(30);
                cur_SAVE_CODE = rs2.getString(31);
                cur_REASON_CODE = rs2.getString(32);
                cur_BILL_DATE = rs2.getString(33);
                cur_SEND_DATE = rs2.getString(34);
                cur_DEPT_CODE = rs2.getString(35);
                cur_DEPT_NAME = rs2.getString(36);
                cur_DIV_CODE = rs2.getString(37);
                cur_BILL_USER = rs2.getString(38);
                cur_REFER_NUM = rs2.getString(39);
                cur_DRAFT_NO = rs2.getString(40);
                cur_DRAFT_SEQ = rs2.getInt(41);
                cur_TRANS_SEQ = rs2.getInt(42);
                
                cur_CURR_UNIT = rs2.getString(43);
                cur_CURR_RATE = rs2.getDouble(44);
                cur_CHECK_NO = rs2.getString(45);
                cur_ACCT_NO = rs2.getString(46);
                cur_BUDG_AMT_I = rs2.getDouble(47);
                
                if (cur_OPR_FLAG.equals("D")) {
                    sql.setLength(0);
                    sql.append("SELECT NVL(trans_seq, 0) ");
                    sql.append("FROM   afb710t ");
                    sql.append("WHERE  comp_code = ? ");
                    sql.append("       AND pay_draft_no = ?  ");
                    sql.append("       AND seq = ? ");
                    
                    pstmt = conn.prepareStatement(sql.toString());
                    pstmt.setString(1, cur_COMP_CODE);
                    pstmt.setString(2, PAY_DRAFT_NO);
                    pstmt.setInt(3, cur_SEQ);
                    
                    rs = pstmt.executeQuery();
                    
                    while (rs.next()) {
                        //--이미 참조적용된 자료입니다. 확인 후 다시 작업하십시오.
                        TransSeq = rs.getInt(1);
                        
                    }
                    rs.close();
                    pstmt.close();
                    
                    if (TransSeq > 1) {
                        
                        ERROR_DESC = "56306;";
                        
                        sql.setLength(0);
                        sql.append("SELECT '56306;' + Fngettxt('A0304') + ' : ' ");
                        sql.append("       + ?  + Fngettxt('A0031') + ' : ' ");
                        sql.append("       + Cast( ? AS VARCHAR) + Fngettxt('A0096') ");
                        sql.append("       + ' : ' + Cast(?  AS VARCHAR)");
                        
                        pstmt = conn.prepareStatement(sql.toString());
                        pstmt.setString(1, PAY_DRAFT_NO);
                        pstmt.setInt(2, cur_SEQ);
                        pstmt.setInt(3, TransSeq);
                        
                        rs = pstmt.executeQuery();
                        
                        while (rs.next()) {
                            //  -- 이체가 된 건은 수정하거나 삭제할 수 없습니다.
                            ERROR_DESC = rs.getString(1);
                            
                        }
                        rs.close();
                        pstmt.close();
                        
                        //                        rMap.put("RTN_PAY_DRAFT_NO", PAY_DRAFT_NO);
                        //                        rMap.put("ERROR_DESC", ERROR_DESC);
                        
                        System.out.println("지출결의번호 : " + PAY_DRAFT_NO);
                        System.out.println("에러상세 : " + ERROR_DESC);
                        //                        return rMap;
                        return PAY_DRAFT_NO + "|" + ERROR_DESC;
                    }
                    
                }
                
                //-- 2.3. 신규입력일 때, 순번채번
                if (cur_OPR_FLAG.equals("N")) {
                    
                    sql.setLength(0);
                    sql.append("SELECT Nvl(Max(seq), 0) ");
                    sql.append("FROM   afb710t ");
                    sql.append("WHERE  comp_code = ?  ");
                    sql.append("       AND pay_draft_no = ? ");
                    
                    pstmt = conn.prepareStatement(sql.toString());
                    pstmt.setString(1, cur_COMP_CODE);
                    pstmt.setString(2, PAY_DRAFT_NO);
                    
                    rs = pstmt.executeQuery();
                    
                    while (rs.next()) {
                        cur_SEQ = rs.getInt(1);
                        
                    }
                    rs.close();
                    pstmt.close();
                    
                    if (cur_SEQ == 0) {
                        cur_SEQ = 1;
                        
                    } else {
                        cur_SEQ = cur_SEQ + 1;
                    }
                    
                }
                
                //-- 2.4. 예산사용가능금액 초과여부 체크
                if (!cur_OPR_FLAG.equals("D")) {
                    // --  [ 지출결의디테일의 지급액 조회 ] ----------
                    double TotAmtI = 0;
                    
                    sql.setLength(0);
                    sql.append("SELECT Nvl(tot_amt_i, 0) ");
                    sql.append("FROM   afb710t ");
                    sql.append("WHERE  comp_code = ?  ");
                    sql.append("       AND pay_draft_no = ?  ");
                    sql.append("       AND seq = ? ");
                    
                    pstmt = conn.prepareStatement(sql.toString());
                    pstmt.setString(1, cur_COMP_CODE);
                    pstmt.setString(2, PAY_DRAFT_NO);
                    pstmt.setInt(3, cur_SEQ);
                    
                    rs = pstmt.executeQuery();
                    
                    while (rs.next()) {
                        //  -- -- 참조된 데이터가 삭제되었습니다.       확인 후 작업하십시요.
                        TotAmtI = rs.getInt(1);
                        
                    }
                    rs.close();
                    pstmt.close();
                    
                    if (TotAmtI == 0.0) {
                        TotAmtI = 0;
                        
                    }
                    
                    //--  [ 예산사용가능금액 체크 ] -------------
                    String BudgYYYYMM = "";
                    double BalnAmtI = 0.0;
                    double BudgI = 0.0;
                    double ActI = 0.0;
                    
                    BudgYYYYMM = SLIP_DATE.substring(0, 6);
                    
                    /*
                     * SP 실행 EXEC uniLITE.SP_ACCNT_GetPossibleBudgAmt @COMP_CODE, @BudgYYYYMM, @DEPT_CODE, @BUDG_CODE, @BUDG_GUBUN , @BalnAmtI OUTPUT, @BudgI OUTPUT, @ActI OUTPUT
                     */
                    
                    //SP_ACCNT_GetPossibleBudgAmt tm = new SP_ACCNT_GetPossibleBudgAmt();
                    
                    //Map rResult = SP_ACCNT_GetPossibleBudgAmt.GetPossibleBudgAmt(COMP_CODE, BudgYYYYMM, DEPT_CODE, cur_BUDG_CODE, BUDG_GUBUN);
                    Map rResult = GetPossibleBudgAmt(conn, COMP_CODE, BudgYYYYMM, DEPT_CODE, cur_BUDG_CODE, BUDG_GUBUN);
                    
                    String result1s = "";
                    String result2s = "";
                    String result3s = "";
                    
                    result1s = rResult.get("BALN_I").toString();
                    result2s = rResult.get("BUDG_I").toString();
                    result3s = rResult.get("ACTUAL_I").toString();
                    
                    BalnAmtI = Double.parseDouble(result1s);
                    BudgI = Double.parseDouble(result2s);
                    ActI = Double.parseDouble(result3s);
                    
                    //IF ( @@ROWCOUNT = 0 )
                    if (BalnAmtI == 0.0 && BudgI == 0.0 && ActI == 0.0) {
                        
                        ERROR_DESC = "54334;";
                        
                        sql.setLength(0);
                        
                        //                      sql.append("SELECT '54334;' + ? +'이고,'+ ? +'이고,' + Replace(Cast( ?  AS VARCHAR), '.000000', '') +'이다' AS AAA");
                        
                        sql.append("SELECT '54334;' + Fngettxt('A0012') + ' : ' +  ?  ");
                        sql.append("       + ' ' +  ?  + Fngettxt('A0040') + ' : 0' ");
                        sql.append("       + Fngettxt('A0041') + ' : 0' + Fngettxt('A0093') ");
                        sql.append("       + ' : ' ");
                        sql.append("       + Replace(Cast( ?  AS VARCHAR), '.000000', '')");
                        
                        pstmt = conn.prepareStatement(sql.toString());
                        pstmt.setString(1, cur_DEPT_CODE);
                        pstmt.setString(2, cur_DEPT_NAME);
                        pstmt.setDouble(3, cur_TOT_AMT_I);
                        
                        rs = pstmt.executeQuery();
                        
                        while (rs.next()) {
                            // --잔여예산(또는 예산금액)이 존재하지 않습니다.
                            ERROR_DESC = rs.getString(1);
                            
                        }
                        rs.close();
                        pstmt.close();
                        
                        //                        rMap.put("RTN_PAY_DRAFT_NO", PAY_DRAFT_NO);
                        //                        rMap.put("ERROR_DESC", ERROR_DESC);
                        
                        System.out.println("지출결의번호 : " + PAY_DRAFT_NO);
                        System.out.println("에러상세 : " + ERROR_DESC);
                        //                        return rMap;
                        return PAY_DRAFT_NO + "|" + ERROR_DESC;
                    }
                    
                    //-- 예산사용가능금액 및 실적금액에 수정전 지급액 반영
                    
                    BalnAmtI = BalnAmtI + TotAmtI;
                    ActI = ActI - TotAmtI;
                    
                    if (BalnAmtI < cur_TOT_AMT_I) {
                        
                        ERROR_DESC = "54381";
                        
                        sql.setLength(0);
                        sql.append("SELECT '54381;' + Fngettxt('A0012') + ' : ' +  ?  ");
                        sql.append("       + ' ' +  ?  + Fngettxt('A0040') + ' : ' ");
                        sql.append("       + Replace(Cast( ?  AS VARCHAR), '.000000', '') ");
                        sql.append("       + Fngettxt('A0041') + ' : ' ");
                        sql.append("       + Replace(Cast( ?  AS VARCHAR), '.000000', '') ");
                        sql.append("       + Fngettxt('A0093') + ' : ' ");
                        sql.append("       + Replace(Cast( ?  AS VARCHAR), '.000000', '') ");
                        
                        pstmt = conn.prepareStatement(sql.toString());
                        pstmt.setString(1, cur_DEPT_CODE);
                        pstmt.setString(2, cur_DEPT_NAME);
                        pstmt.setDouble(3, BudgI);
                        pstmt.setDouble(4, ActI);
                        pstmt.setDouble(5, cur_TOT_AMT_I);
                        
                        rs = pstmt.executeQuery();
                        
                        while (rs.next()) {
                            //--예산금액을 초과하였습니다.
                            ERROR_DESC = rs.getString(1);
                            
                        }
                        rs.close();
                        pstmt.close();
                        
                        //                        rMap.put("RTN_PAY_DRAFT_NO", PAY_DRAFT_NO);
                        //                        rMap.put("ERROR_DESC", ERROR_DESC);
                        
                        System.out.println("에러코드 : " + PAY_DRAFT_NO);
                        System.out.println("에러상세 : " + ERROR_DESC);
                        //                        return rMap;
                        return PAY_DRAFT_NO + "|" + ERROR_DESC;
                    }
                    
                }
                
                //-- 2.7. 예산금액 반영
                int AFB700URK_CNT = 0;
                
                sql.setLength(0);
                sql.append("SELECT COUNT(*) ");
                sql.append("        FROM   afb510t ");
                sql.append("        WHERE  comp_code =  ?  ");
                sql.append("               AND budg_yyyymm = LEFT( ? , 4)  + '01' ");
                sql.append("               AND dept_code =  ?  ");
                sql.append("               AND budg_code =  ?  ");
                sql.append("               AND budg_gubun =  ?  ");
                //sql.append("               AND budg_gubun =  ?  ");
                sql.append("               AND acct_no =  ?  ");
                sql.append("               AND rownum = 1 ");
                
                pstmt = conn.prepareStatement(sql.toString());
                pstmt.setString(1, cur_COMP_CODE);
                pstmt.setString(2, SLIP_DATE);
                pstmt.setString(3, cur_DEPT_CODE);
                pstmt.setString(4, cur_BUDG_CODE);
                pstmt.setString(5, cur_BUDG_GUBUN);
                pstmt.setString(6, cur_ACCT_NO);
                
                rs = pstmt.executeQuery();
                
                while (rs.next()) {
                    AFB700URK_CNT = rs.getInt(1);
                    
                }
                rs.close();
                pstmt.close();
                
                if (AFB700URK_CNT == 0) {
                    
                    sql.setLength(0);
                    sql.append("INSERT INTO afb510t ");
                    sql.append("            (comp_code, ");
                    sql.append("             budg_yyyymm, ");
                    sql.append("             dept_code, ");
                    sql.append("             budg_code, ");
                    sql.append("             budg_gubun, ");
                    sql.append("             budg_i, ");
                    sql.append("             budg_conf_i, ");
                    sql.append("             budg_conv_i, ");
                    sql.append("             budg_asgn_i, ");
                    sql.append("             budg_supp_i, ");
                    sql.append("             budg_iwall_i, ");
                    sql.append("             ex_amt_i, ");
                    sql.append("             ac_amt_i, ");
                    sql.append("             cal_divi, ");
                    sql.append("             draft_amt, ");
                    sql.append("             order_amt, ");
                    sql.append("             req_amt, ");
                    sql.append("             insert_db_user, ");
                    sql.append("             insert_db_time, ");
                    sql.append("             update_db_user, ");
                    sql.append("             update_db_time, ");
                    sql.append("             tempc_01, ");
                    sql.append("             tempc_02, ");
                    sql.append("             tempc_03, ");
                    sql.append("             tempn_01, ");
                    sql.append("             tempn_02, ");
                    sql.append("             tempn_03, ");
                    sql.append("             acct_no) ");
                    sql.append("VALUES      (  ? , ");
                    sql.append("              LEFT( ? , 4) + '01', ");
                    sql.append("               ? , ");
                    sql.append("               ? , ");
                    sql.append("               ? , ");
                    sql.append("              0, ");
                    sql.append("              0, ");
                    sql.append("              0, ");
                    sql.append("              0, ");
                    sql.append("              0, ");
                    sql.append("              0, ");
                    sql.append("              0, ");
                    sql.append("              0, ");
                    sql.append("              1, ");
                    sql.append("              0, ");
                    sql.append("              0, ");
                    sql.append("              0, ");
                    sql.append("               ? , ");
                    sql.append("              sysdatetime, ");
                    sql.append("               ? , ");
                    sql.append("              sysdatetime, ");
                    sql.append("              NULL, ");
                    sql.append("              NULL, ");
                    sql.append("              NULL, ");
                    sql.append("              0, ");
                    sql.append("              0, ");
                    sql.append("              0, ");
                    sql.append("              ? )");
                    
                    pstmt = conn.prepareStatement(sql.toString());
                    pstmt.setString(1, cur_COMP_CODE);
                    pstmt.setString(2, SLIP_DATE);
                    pstmt.setString(3, cur_DEPT_CODE);
                    pstmt.setString(4, cur_BUDG_CODE);
                    pstmt.setString(5, cur_BUDG_GUBUN);
                    pstmt.setString(6, USER_ID);
                    pstmt.setString(7, USER_ID);
                    pstmt.setString(8, cur_ACCT_NO);
                    
                    pstmt.executeUpdate();
                    
                    pstmt.close();
                    
                }
                
                if (!cur_OPR_FLAG.equals("N")) {
                    
                    //--  [ 수정 전, 금액 반영(지출요청예산(-), 기안예산(+)) ] --------
                    sql.setLength(0);
                    sql.append(" UPDATE AFB510T B, ( ");
                    sql.append("     SELECT A.TOT_AMT_I, A.COMP_CODE, A.PAY_DRAFT_NO, A.SEQ, A1.PAY_DATE, ");
                    sql.append("            A.BUDG_GUBUN, A.DEPT_CODE, A.BUDG_CODE, A.ACCT_NO ");
                    sql.append("       FROM AFB710T A ");
                    sql.append(" INNER JOIN AFB700T A1 ON A1.COMP_CODE = A.COMP_CODE ");
                    sql.append("                      AND A1.PAY_DRAFT_NO = A.PAY_DRAFT_NO ");
                    sql.append(" ) S ");
                    sql.append("   SET B.REQ_AMT = NVL(B.REQ_AMT, 0) - NVL(S.TOT_AMT_I, 0) ");
                    sql.append("     , B.UPDATE_DB_USER = ? ");
                    sql.append("     , B.UPDATE_DB_TIME = NOW() ");
                    sql.append(" WHERE S.COMP_CODE = B.COMP_CODE ");
                    sql.append("   AND S.DEPT_CODE = B.DEPT_CODE ");
                    sql.append("   AND S.PAY_DRAFT_NO = ? ");
                    sql.append("   AND S.SEQ = ? ");
                    sql.append("   AND S.BUDG_CODE = B.BUDG_CODE ");
                    sql.append("   AND B.BUDG_YYYYMM = LEFT(S.PAY_DATE, 4) + '01' ");
                    sql.append("   AND S.BUDG_GUBUN    = B.BUDG_GUBUN ");
                    sql.append("   AND S.ACCT_NO = B.ACCT_NO ");
                    
                    System.out.println("=============--  [ 수정 전, 금액 반영(지출요청예산(-), 기안예산(+)) ] ----==================");
                    System.out.println(sql.toString());
                    System.out.println("=======================================================");
                    
                    pstmt = conn.prepareStatement(sql.toString());
                    pstmt.setString(1, USER_ID);
                    pstmt.setString(2, PAY_DRAFT_NO);
                    pstmt.setInt(3, cur_SEQ);
                    
                    pstmt.executeUpdate();
                    
                    pstmt.close();
                    
                }
                
                //--  [ 수정 후, 금액 반영(지출요청예산(+), 기안예산(-)) ] ----
                if (!cur_OPR_FLAG.equals("D")) {
                    
                    sql.setLength(0);
                    sql.append(" UPDATE AFB510T ");
                    sql.append("    SET REQ_AMT = NVL(REQ_AMT, 0) + ? ");
                    sql.append("      , UPDATE_DB_USER = ? ");
                    sql.append("      , UPDATE_DB_TIME = NOW() ");
                    sql.append(" WHERE COMP_CODE = ? ");
                    sql.append("   AND BUDG_YYYYMM = LEFT( ? , 4) + '01' ");
                    sql.append("   AND DEPT_CODE = ? ");
                    sql.append("   AND BUDG_CODE = ? ");
                    sql.append("   AND BUDG_GUBUN = ? ");
                    sql.append("   AND ACCT_NO = ? ");
                    
                    System.out.println("=============--  [ 수정 후, 금액 반영(지출요청예산(+), 기안예산(-)) ] ----==================");
                    System.out.println(sql.toString());
                    System.out.println("=======================================================");
                    
                    pstmt = conn.prepareStatement(sql.toString());
                    pstmt.setDouble(1, cur_TOT_AMT_I);
                    pstmt.setString(2, USER_ID);
                    
                    pstmt.setString(3, cur_COMP_CODE);
                    pstmt.setString(4, SLIP_DATE);
                    pstmt.setString(5, cur_DEPT_CODE);
                    pstmt.setString(6, cur_BUDG_CODE);
                    pstmt.setString(7, cur_BUDG_GUBUN);
                    pstmt.setString(8, cur_ACCT_NO);
                    
                    pstmt.executeUpdate();
                    
                    pstmt.close();
                    
                }
                
                //--2.8. 지출결의디테일 데이터반영
                if (cur_OPR_FLAG.equals("D")) {
                    sql.setLength(0);
                    sql.append("DELETE FROM afb710t ");
                    sql.append("WHERE  comp_code =  ?  ");
                    sql.append("       AND pay_draft_no =  ?  ");
                    sql.append("       AND seq =  ?  ");
                    
                    pstmt = conn.prepareStatement(sql.toString());
                    pstmt.setString(1, cur_COMP_CODE);
                    pstmt.setString(2, PAY_DRAFT_NO);
                    pstmt.setInt(3, cur_SEQ);
                    
                    pstmt.executeUpdate();
                    
                    pstmt.close();
                    
                }
                
                if (cur_OPR_FLAG.equals("U")) {
                    sql.setLength(0);
                    sql.append("UPDATE AFB710T ");
                    sql.append("SET    BUDG_CODE = ?  ");
                    sql.append("       ,ACCNT = ?  ");
                    sql.append("       ,PJT_CODE = ?  ");
                    sql.append("       ,BUDG_GUBUN = ? ");
                    sql.append("       ,BIZ_REMARK = ? ");
                    sql.append("       ,BIZ_GUBUN = ? ");
                    sql.append("       ,PAY_DIVI = ? ");
                    sql.append("       ,PROOF_DIVI = ? ");
                    sql.append("       ,SUPPLY_AMT_I = ? ");
                    sql.append("       ,TAX_AMT_I = ? ");
                    sql.append("       ,ADD_REDUCE_AMT_I = ? ");
                    sql.append("       ,TOT_AMT_I = ? ");
                    sql.append("       ,INC_AMT_I = ? ");
                    sql.append("       ,LOC_AMT_I = ? ");
                    sql.append("       ,REAL_AMT_I = ? ");
                    sql.append("       ,CUSTOM_CODE = ? ");
                    sql.append("       ,CUSTOM_NAME = ? ");
                    sql.append("       ,BE_CUSTOM_CODE = ? ");
                    sql.append("       ,PEND_CODE = ? ");
                    sql.append("       ,PAY_CUSTOM_CODE = ? ");
                    sql.append("       ,REMARK = ? ");
                    sql.append("       ,EB_YN = ? ");
                    sql.append("       ,IN_BANK_CODE = ? ");
                    //                  sql.append("       ,IN_BANKBOOK_NUM = ? ");
                    sql.append("       ,BANK_NUM = ? ");                  //임시로 
                    sql.append("       ,IN_BANKBOOK_NAME = ? ");
                    sql.append("       ,CRDT_NUM = ? ");
                    sql.append("       ,APP_NUM = ? ");
                    sql.append("       ,SAVE_CODE = ? ");
                    sql.append("       ,REASON_CODE = ? ");
                    sql.append("       ,BILL_DATE = ? ");
                    sql.append("       ,SEND_DATE = ? ");
                    sql.append("       ,DEPT_CODE = ? ");
                    sql.append("       ,DEPT_NAME = ? ");
                    sql.append("       ,DIV_CODE = ? ");
                    sql.append("       ,BILL_USER = ? ");
                    sql.append("       ,REFER_NUM = ? ");
                    sql.append("       ,DRAFT_NO = ? ");
                    sql.append("       ,DRAFT_SEQ = ? ");
                    sql.append("       ,TRANS_SEQ = ? ");
                    sql.append("       ,UPDATE_DB_USER = ? ");
                    sql.append("       ,UPDATE_DB_TIME = SYSDATETIME ");
                    
                    sql.append("       ,CURR_UNIT = ? ");
                    sql.append("       ,CURR_RATE = ? ");
                    sql.append("       ,CHECK_NO = ? ");
                    sql.append("       ,ACCT_NO = ? ");
                    sql.append("       ,BUDG_AMT_I = ? ");
                    sql.append("WHERE  COMP_CODE = ? ");
                    sql.append("       AND PAY_DRAFT_NO = ? ");
                    sql.append("       AND SEQ = ?");
                    
                    pstmt = conn.prepareStatement(sql.toString());
                    pstmt.setString(1, cur_BUDG_CODE);
                    pstmt.setString(2, cur_ACCNT);
                    pstmt.setString(3, cur_PJT_CODE);
                    pstmt.setString(4, cur_BUDG_GUBUN);
                    pstmt.setString(5, cur_BIZ_REMARK);
                    pstmt.setString(6, cur_BIZ_GUBUN);
                    pstmt.setString(7, cur_PAY_DIVI);
                    pstmt.setString(8, cur_PROOF_DIVI);
                    pstmt.setDouble(9, cur_SUPPLY_AMT_I);
                    pstmt.setDouble(10, cur_TAX_AMT_I);
                    pstmt.setDouble(11, cur_ADD_REDUCE_AMT_I);
                    pstmt.setDouble(12, cur_TOT_AMT_I);
                    pstmt.setDouble(13, cur_INC_AMT_I);
                    pstmt.setDouble(14, cur_LOC_AMT_I);
                    pstmt.setDouble(15, cur_REAL_AMT_I);
                    pstmt.setString(16, cur_CUSTOM_CODE);
                    pstmt.setString(17, cur_CUSTOM_NAME);
                    pstmt.setString(18, cur_BE_CUSTOM_CODE);
                    pstmt.setString(19, cur_PEND_CODE);
                    pstmt.setString(20, cur_PAY_CUSTOM_CODE);
                    pstmt.setString(21, cur_REMARK);
                    pstmt.setString(22, cur_EB_YN);
                    pstmt.setString(23, cur_IN_BANK_CODE);
                    pstmt.setString(24, cur_IN_BANKBOOK_NUM);
                    pstmt.setString(25, cur_IN_BANKBOOK_NAME);
                    pstmt.setString(26, cur_CRDT_NUM);
                    pstmt.setString(27, cur_APP_NUM);
                    pstmt.setString(28, cur_SAVE_CODE);
                    pstmt.setString(29, cur_REASON_CODE);
                    pstmt.setString(30, cur_BILL_DATE);
                    pstmt.setString(31, cur_SEND_DATE);
                    pstmt.setString(32, cur_DEPT_CODE);
                    pstmt.setString(33, cur_DEPT_NAME);
                    pstmt.setString(34, cur_DIV_CODE);
                    pstmt.setString(35, cur_BILL_USER);
                    pstmt.setString(36, cur_REFER_NUM);
                    pstmt.setString(37, cur_DRAFT_NO);
                    pstmt.setInt(38, cur_DRAFT_SEQ);
                    pstmt.setInt(39, cur_TRANS_SEQ);
                    pstmt.setString(40, USER_ID);
                    
                    pstmt.setString(41, cur_CURR_UNIT);
                    pstmt.setDouble(42, cur_CURR_RATE);
                    pstmt.setString(43, cur_CHECK_NO);
                    pstmt.setString(44, cur_ACCT_NO);
                    pstmt.setDouble(45, cur_BUDG_AMT_I);
                    
                    pstmt.setString(46, cur_COMP_CODE);
                    pstmt.setString(47, PAY_DRAFT_NO);
                    pstmt.setInt(48, cur_SEQ);
                    
                    pstmt.executeUpdate();
                    
                    pstmt.close();
                    
                }
                
                if (cur_OPR_FLAG.equals("N")) {
                    sql.setLength(0);
                    sql.append("INSERT INTO AFB710T ");
                    sql.append("            (COMP_CODE ");
                    sql.append("             ,PAY_DRAFT_NO ");
                    sql.append("             ,SEQ ");
                    sql.append("             ,BUDG_CODE ");
                    sql.append("             ,ACCNT ");
                    sql.append("             ,PJT_CODE ");
                    sql.append("             ,BUDG_GUBUN ");
                    sql.append("             ,BIZ_REMARK ");
                    sql.append("             ,BIZ_GUBUN ");
                    sql.append("             ,PAY_DIVI ");
                    sql.append("             ,PROOF_DIVI ");
                    sql.append("             ,SUPPLY_AMT_I ");
                    sql.append("             ,TAX_AMT_I ");
                    sql.append("             ,ADD_REDUCE_AMT_I ");
                    sql.append("             ,TOT_AMT_I ");
                    sql.append("             ,INC_AMT_I ");
                    sql.append("             ,LOC_AMT_I ");
                    sql.append("             ,REAL_AMT_I ");
                    sql.append("             ,CUSTOM_CODE ");
                    sql.append("             ,CUSTOM_NAME ");
                    sql.append("             ,BE_CUSTOM_CODE ");
                    sql.append("             ,PEND_CODE ");
                    sql.append("             ,PAY_CUSTOM_CODE ");
                    sql.append("             ,REMARK ");
                    sql.append("             ,EB_YN ");
                    sql.append("             ,IN_BANK_CODE ");
                    //                  sql.append("             ,IN_BANKBOOK_NUM ");
                    sql.append("             ,BANK_NUM ");                  //임시로 
                    sql.append("             ,IN_BANKBOOK_NAME ");
                    sql.append("             ,CRDT_NUM ");
                    sql.append("             ,APP_NUM ");
                    sql.append("             ,SAVE_CODE ");
                    sql.append("             ,REASON_CODE ");
                    sql.append("             ,BILL_DATE ");
                    sql.append("             ,SEND_DATE ");
                    sql.append("             ,DEPT_CODE ");
                    sql.append("             ,DEPT_NAME ");
                    sql.append("             ,DIV_CODE ");
                    sql.append("             ,BILL_USER ");
                    sql.append("             ,REFER_NUM ");
                    sql.append("             ,DRAFT_NO ");
                    sql.append("             ,DRAFT_SEQ ");
                    sql.append("             ,TRANS_SEQ ");
                    sql.append("             ,INSERT_DB_USER ");
                    sql.append("             ,INSERT_DB_TIME ");
                    sql.append("             ,UPDATE_DB_USER ");
                    sql.append("             ,UPDATE_DB_TIME ");
                    
                    sql.append("             ,CURR_UNIT ");
                    sql.append("             ,CURR_RATE ");
                    sql.append("             ,CHECK_NO ");
                    sql.append("             ,ACCT_NO ");
                    sql.append("             ,BUDG_AMT_I )");
                    
                    sql.append("SELECT ? ");
                    sql.append("       , ?  ");
                    sql.append("       , ?  ");
                    sql.append("       , ?  ");
                    sql.append("       , ?  ");
                    sql.append("       , ?  ");
                    sql.append("       , ?  ");
                    sql.append("       , ?  ");
                    sql.append("       , ?  ");
                    sql.append("       , ?  ");
                    sql.append("       , ?  ");
                    sql.append("       , ?  ");
                    sql.append("       , ?  ");
                    sql.append("       , ?  ");
                    sql.append("       , ?  ");
                    sql.append("       , ?  ");
                    sql.append("       , ?  ");
                    sql.append("       , ?  ");
                    sql.append("       , ?  ");
                    sql.append("       , ?  ");
                    sql.append("       , ?  ");
                    sql.append("       , ?  ");
                    sql.append("       , ?  ");
                    sql.append("       , ?  ");
                    sql.append("       , ?  ");
                    sql.append("       , ?  ");
                    sql.append("       , ?  ");
                    sql.append("       , ?  ");
                    sql.append("       , ?  ");
                    sql.append("       , ?  ");
                    sql.append("       , ?  ");
                    sql.append("       , ?  ");
                    sql.append("       , ?  ");
                    sql.append("       , ?  ");
                    sql.append("       , ?  ");
                    sql.append("       , ?  ");
                    sql.append("       , ?  ");
                    sql.append("       , ?  ");
                    sql.append("       , ?  ");
                    sql.append("       , ?  ");
                    sql.append("       , ?  ");
                    sql.append("       , ?  ");
                    sql.append("       , ?  ");
                    sql.append("       ,SYSDATETIME ");
                    sql.append("       , ?  ");
                    sql.append("       ,SYSDATETIME");
                    
                    sql.append("       , ?  ");
                    sql.append("       , ?  ");
                    sql.append("       , ?  ");
                    sql.append("       , ?  ");
                    sql.append("       , ?  ");
                    
                    pstmt = conn.prepareStatement(sql.toString());
                    pstmt.setString(1, cur_COMP_CODE);
                    pstmt.setString(2, PAY_DRAFT_NO);
                    pstmt.setInt(3, cur_SEQ);
                    pstmt.setString(4, cur_BUDG_CODE);
                    pstmt.setString(5, cur_ACCNT);
                    
                    pstmt.setString(6, cur_PJT_CODE);
                    pstmt.setString(7, cur_BUDG_GUBUN);
                    pstmt.setString(8, cur_BIZ_REMARK);
                    pstmt.setString(9, cur_BIZ_GUBUN);
                    pstmt.setString(10, cur_PAY_DIVI);
                    
                    pstmt.setString(11, cur_PROOF_DIVI);
                    pstmt.setDouble(12, cur_SUPPLY_AMT_I);
                    pstmt.setDouble(13, cur_TAX_AMT_I);
                    pstmt.setDouble(14, cur_ADD_REDUCE_AMT_I);
                    pstmt.setDouble(15, cur_TOT_AMT_I);
                    
                    pstmt.setDouble(16, cur_INC_AMT_I);
                    pstmt.setDouble(17, cur_LOC_AMT_I);
                    pstmt.setDouble(18, cur_REAL_AMT_I);
                    pstmt.setString(19, cur_CUSTOM_CODE);
                    pstmt.setString(20, cur_CUSTOM_NAME);
                    
                    pstmt.setString(21, cur_BE_CUSTOM_CODE);
                    pstmt.setString(22, cur_PEND_CODE);
                    pstmt.setString(23, cur_PAY_CUSTOM_CODE);
                    pstmt.setString(24, cur_REMARK);
                    pstmt.setString(25, cur_EB_YN);
                    
                    pstmt.setString(26, cur_IN_BANK_CODE);
                    pstmt.setString(27, cur_IN_BANKBOOK_NUM);
                    pstmt.setString(28, cur_IN_BANKBOOK_NAME);
                    pstmt.setString(29, cur_CRDT_NUM);
                    pstmt.setString(30, cur_APP_NUM);
                    
                    pstmt.setString(31, cur_SAVE_CODE);
                    pstmt.setString(32, cur_REASON_CODE);
                    pstmt.setString(33, cur_BILL_DATE);
                    pstmt.setString(34, cur_SEND_DATE);
                    pstmt.setString(35, cur_DEPT_CODE);
                    
                    pstmt.setString(36, cur_DEPT_NAME);
                    pstmt.setString(37, cur_DIV_CODE);
                    pstmt.setString(38, cur_BILL_USER);
                    pstmt.setString(39, cur_REFER_NUM);
                    pstmt.setString(40, cur_DRAFT_NO);
                    
                    pstmt.setInt(41, cur_DRAFT_SEQ);
                    pstmt.setInt(42, cur_TRANS_SEQ);
                    pstmt.setString(43, USER_ID);
                    pstmt.setString(44, USER_ID);
                    
                    pstmt.setString(45, cur_CURR_UNIT);
                    pstmt.setDouble(46, cur_CURR_RATE);
                    pstmt.setString(47, cur_CHECK_NO);
                    pstmt.setString(48, cur_ACCT_NO);
                    pstmt.setDouble(49, cur_BUDG_AMT_I);
                    
                    pstmt.executeUpdate();
                    
                    pstmt.close();
                    
                }
                
            }
            
            rs2.close();
            pstmt2.close();
        } catch (SQLException e) {
            throw new Exception("[7] SQLException : " + e.getMessage());
        } catch (Exception e) {
            throw new Exception("[7] Exception : " + e.getMessage());
        }
        
        try {
            //-- 3. 지출결의마스터 삭제 또는 지출결의디테일의 순번 재설정
            //--  [ 변수 값 할당 ] ---------
            SEQ = 0;
            
            //--  [ 그룹웨어 연동여부 설정 ] ---------
            sql.setLength(0);
            sql.append("select * from ( ");
            sql.append("SELECT M1.ref_code1 ");
            sql.append("FROM   bsa100t M1 ");
            sql.append("WHERE  M1.comp_code = ? ");
            sql.append("       AND M1.main_code = 'A169' ");
            sql.append("       AND M1.sub_code = '20' ");
            sql.append(") TOPT where rownum = 1");
            
            pstmt = conn.prepareStatement(sql.toString());
            pstmt.setString(1, COMP_CODE);
            
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                LinkedGW = rs.getString(1);
                
            }
            rs.close();
            pstmt.close();
            
            if (LinkedGW == null || LinkedGW.equals("")) {
                LinkedGW = "N";
                
            }
            
            //--  [ 지출결의마스터 상태 조회 ] ----------
            sql.setLength(0);
            sql.append("SELECT CASE ");
            sql.append("       WHEN ? = 'Y' THEN Nvl(B.gw_status, '0') ");
            sql.append("       ELSE A.status ");
            sql.append("       END ");
            sql.append("FROM   afb700t A ");
            sql.append("       LEFT JOIN bsa100t M1 ");
            sql.append("              ON M1.comp_code = A.comp_code ");
            sql.append("                 AND M1.main_code = 'S091' ");
            sql.append("                 AND M1.sub_code = A.comp_code ");
            sql.append("       LEFT JOIN t_gwif B ");
            sql.append("              ON B.gwif_id = M1.ref_code1 +  ?  + A.pay_draft_no ");
            sql.append("WHERE  A.comp_code =  ?  ");
            sql.append("       AND A.pay_draft_no =  ? ");
            
            pstmt = conn.prepareStatement(sql.toString());
            pstmt.setString(1, LinkedGW);
            pstmt.setString(2, GWIF_TYPE);
            pstmt.setString(3, COMP_CODE);
            pstmt.setString(4, PAY_DRAFT_NO);
            
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                ExStatus = rs.getString(1);
                
            }
            rs.close();
            pstmt.close();
            
            if (ExStatus == null || ExStatus.equals("")) {
                ExStatus = "0";
                
            }
            
            //--  [ 지출결의디테일 건수 조회 ] ----------------
            int RecordCount = 0;
            
            sql.setLength(0);
            sql.append("SELECT Count(1) ");
            sql.append("FROM   afb710t ");
            sql.append("WHERE  comp_code =  ?  ");
            sql.append("       AND pay_draft_no =  ? ");
            
            pstmt = conn.prepareStatement(sql.toString());
            pstmt.setString(1, COMP_CODE);
            pstmt.setString(2, PAY_DRAFT_NO);
            
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                RecordCount = rs.getInt(1);
                
            }
            rs.close();
            pstmt.close();
            
            //--  [ 지출결의마스터 삭제 또는 지출결의디테일 순번재설성] -------
            if (RecordCount == 0 && ExStatus.equals("0")) {
                
                //-- 지출결의마스터 삭제
                sql.setLength(0);
                sql.append("DELETE FROM afb700t ");
                sql.append("WHERE  comp_code =  ?  ");
                sql.append("       AND pay_draft_no =  ? ");
                
                pstmt = conn.prepareStatement(sql.toString());
                pstmt.setString(1, COMP_CODE);
                pstmt.setString(2, PAY_DRAFT_NO);
                
                pstmt.executeUpdate();
                
                pstmt.close();
                
            }
            
            if (RecordCount > 0) {
                
                //-- 입력가능행수 체크
                int DtlMaxRows = 0;
                
                sql.setLength(0);
                sql.append("SELECT Cast(CASE ");
                sql.append("            WHEN Nvl(ref_code1, '') = '' THEN '0' ");
                sql.append("            ELSE ref_code1 ");
                sql.append("            END AS NUMERIC) ");
                sql.append("FROM   bsa100t ");
                sql.append("WHERE  comp_code =  ?  ");
                sql.append("       AND main_code = 'A169' ");
                sql.append("       AND sub_code = '41'");
                
                pstmt = conn.prepareStatement(sql.toString());
                pstmt.setString(1, COMP_CODE);
                
                rs = pstmt.executeQuery();
                
                while (rs.next()) {
                    DtlMaxRows = rs.getInt(1);
                    
                }
                rs.close();
                pstmt.close();
                
                if (DtlMaxRows != 0 && DtlMaxRows < RecordCount) {
                    //-- 입력가능한 행수를 초과하였습니다.
                    ERROR_DESC = "56307;";
                    
                    //                    rMap.put("RTN_PAY_DRAFT_NO", PAY_DRAFT_NO);
                    //                    rMap.put("ERROR_DESC", ERROR_DESC);
                    
                    System.out.println("지출결의번호 : " + PAY_DRAFT_NO);
                    System.out.println("에러상세 : " + ERROR_DESC);
                    //                    return rMap;
                    return PAY_DRAFT_NO + "|" + ERROR_DESC;
                }
                
                //-- 지출결의디테일 순번재설정
                for (int seq_710t = 0; seq_710t < RecordCount; seq_710t++) {
                    sql.setLength(0);
                    sql.append("UPDATE afb710t ");
                    sql.append("   SET seq =  ?  ");
                    sql.append("WHERE  comp_code =  ?  ");
                    sql.append("       AND pay_draft_no =  ? ");
                    sql.append("       AND ROWNUM = ? ");
                    
                    pstmt = conn.prepareStatement(sql.toString());
                    pstmt.setInt(1, seq_710t);
                    pstmt.setString(2, COMP_CODE);
                    pstmt.setString(3, PAY_DRAFT_NO);
                    pstmt.setInt(4, seq_710t);
                    
                    pstmt.executeUpdate();
                    
                    pstmt.close();
                    
                }
                
            }
            
            conn.setAutoCommit(true);
            
        } catch (SQLException e) {
            System.err.println("SQLException : " + e.getMessage());
            ERROR_DESC = "Sql Error";
            conn.rollback();
        } catch (Exception e) {
            System.err.println("Exception : " + e);
            System.err.println("Exception : " + e.getMessage());
            ERROR_DESC = "Sys Error";
            conn.rollback();
        } finally {
            if (rs != null) try {
                rs.close();
            } catch (SQLException e) {
                System.err.println("SQLException : " + e.getMessage());
                e.printStackTrace();
            }
            if (conn != null) try {
                conn.close();
            } catch (SQLException e) {
                System.err.println("Exception : " + e.getMessage());
                e.printStackTrace();
            }
            
        }
        
        //RTN_PAY_DRAFT_NO = PAY_DRAFT_NO;
        
        //        rMap.put("RTN_PAY_DRAFT_NO", PAY_DRAFT_NO);
        //        rMap.put("ERROR_DESC", ERROR_DESC);
        
        System.out.println("지출결의번호 : " + PAY_DRAFT_NO);
        System.out.println("에러상세 : " + ERROR_DESC);
        
        //        return rMap;
        return PAY_DRAFT_NO + "|" + ERROR_DESC;
    }
    
    public static Map<String, Object> GetPossibleBudgAmt( Connection conn, String COMP_CODE, String BUDG_YYYYMM, String DEPT_CODE, String BUDG_CODE, String BUDG_GUBUN ) throws Exception {
        
        double BALN_I = 0.0; /* out */
        double BUDG_I = 0.0; /* out */
        double ACTUAL_I = 0.0; /* out */
        Map<String, Object> rMap = new HashMap<String, Object>();
        
        StringBuffer sql = new StringBuffer();
//        Connection conn = null;
        ResultSet rs = null;
        PreparedStatement pstmt = null;
        
        System.out.println("======시작========");
        
        try {
            
//            Class.forName("cubrid.jdbc.driver.CUBRIDDriver");
//                      conn = DriverManager.getConnection("jdbc:default:connection");

//                      conn = DriverManager.getConnection("jdbc:CUBRID:211.241.199.190:30000:CRM:::", "unilite", "UNILITE");
//            conn = DriverManager.getConnection("jdbc:CUBRID:192.168.1.220:33000:OmegaPlus:::", "unilite", "UNILITE");
            
            //          conn.setAutoCommit(true);
            
            if (COMP_CODE == null || COMP_CODE.equals("")) {
                COMP_CODE = "MASTER";
                
            }
            
            if (BUDG_YYYYMM == null || BUDG_YYYYMM.equals("")) {
                
                sql.setLength(0);
                sql.append("SELECT TO_CHAR(SYSDATETIME, 'YYYYMM') ");
                
                pstmt = conn.prepareStatement(sql.toString());
                
                rs = pstmt.executeQuery();
                
                while (rs.next()) {
                    //  -- 이체가 된 건은 수정하거나 삭제할 수 없습니다.
                    BUDG_YYYYMM = rs.getString(1);
                    
                }
                rs.close();
                pstmt.close();
                
            }
            
            if (DEPT_CODE == null || DEPT_CODE.equals("")) {
                DEPT_CODE = "";
                
            }
            if (BUDG_CODE == null || BUDG_CODE.equals("")) {
                BUDG_CODE = "";
                
            }
            if (BUDG_GUBUN == null || BUDG_GUBUN.equals("")) {
                BUDG_GUBUN = "";
                
            }
            
            //변수선언
            String AC_YYYY = "";            //--사업년도
            String CTL_UNIT = "";           //--예산통제단위    (1:관        , 2:항      , 3:세항, 4:세세항, 5:목)
            String CTL_CAL_UNIT = "";       //--예산통제계산단위(1:부서별    , 2:회사전체)
            String CTL_TERM_UNIT = "";      //--예산통제기간단위(1:월        , 2:분기    , 3:반기, 4:년)
            String CTL_BUDG_CODE = "";      //--예산통제단위에 따른, 실적집계 및 예산통제에 이용될 예산코드
            //--(예산통제단위가 최하위('목')이 아닐 경우, 사용자가 입력한 예산코드의 상위 예산코드가 된다.)
            String FrYyyyMm = "";           //--회계기간(FROM)
            String ToYyyyMm = "";           //--회계기간(TO)
            
            //          StringBuffer  sql = new StringBuffer();
            sql.setLength(0);
            sql.append("SELECT fnGetBudgAcYyyy( ? , ? ) ");
            
            pstmt = conn.prepareStatement(sql.toString());
            pstmt.setString(1, COMP_CODE);
            pstmt.setString(2, BUDG_YYYYMM);
            
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                AC_YYYY = rs.getString(1);
                
            }
            rs.close();
            pstmt.close();
            
            /*
             * //임시삭제 fnGetBudgInfo 없음 //--예산설정정보 조회 sql.setLength(0); sql.append("SELECT CTL_UNIT, "); sql.append("       CTL_CAL_UNIT, "); sql.append("       CTL_TERM_UNIT "); sql.append("FROM   fnGetBudgInfo( ? , ? , ? )"); pstmt= conn.prepareStatement(sql.toString()); pstmt.setString(1, COMP_CODE ); pstmt.setString(2, AC_YYYY); pstmt.setString(3, BUDG_CODE); rs = pstmt.executeQuery(); while(rs.next()){ CTL_UNIT = rs.getString(1); CTL_CAL_UNIT = rs.getString(2); CTL_TERM_UNIT = rs.getString(3); } System.out.println("======--예산설정정보 조회========"); System.out.println("CTL_UNIT : " + CTL_UNIT); System.out.println("CTL_CAL_UNIT : " + CTL_CAL_UNIT); System.out.println("CTL_TERM_UNIT : " + CTL_TERM_UNIT); rs.close(); pstmt.close();
             */
            
            CTL_UNIT = "6";
            CTL_CAL_UNIT = "1";
            CTL_TERM_UNIT = "4";         //KOCIS  -> 년단위 통제 고정
            
            //--예산통제단위(AFB300T.CTL_UNIT)에 따른 예산코드 찾기
            sql.setLength(0);
            sql.append("SELECT B.BUDG_CODE ");
            sql.append("FROM   AFB410T AS A ");
            sql.append("       INNER JOIN AFB400T AS B ");
            sql.append("               ON B.COMP_CODE = A.COMP_CODE ");
            sql.append("                  AND B.AC_YYYY = A.AC_YYYY ");
            sql.append("                  AND A.BUDG_CODE LIKE B.BUDG_CODE + '%' ");
            sql.append("                  AND B.CODE_LEVEL = ? ");
            sql.append("WHERE  A.COMP_CODE = ? ");
            sql.append("       AND A.AC_YYYY = ? ");
            sql.append("       AND A.DEPT_CODE = ? ");
            sql.append("       AND A.BUDG_CODE = ? ");
            
            pstmt = conn.prepareStatement(sql.toString());
            pstmt.setString(1, CTL_UNIT);
            pstmt.setString(2, COMP_CODE);
            pstmt.setString(3, AC_YYYY);
            pstmt.setString(4, DEPT_CODE);
            pstmt.setString(5, BUDG_CODE);
            
            System.out.println("======--예산통제단위(AFB300T.CTL_UNIT)에 따른 예산코드 찾기========");
            System.out.println(sql.toString());
            System.out.println("CTL_UNIT : " + CTL_UNIT);
            System.out.println("COMP_CODE : " + COMP_CODE);
            System.out.println("AC_YYYY : " + AC_YYYY);
            System.out.println("DEPT_CODE : " + DEPT_CODE);
            System.out.println("BUDG_CODE : " + BUDG_CODE);
            System.out.println("====================================================");
            
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                CTL_BUDG_CODE = rs.getString(1);
                
            }
            System.out.println("CTL_BUDG_CODE : " + CTL_BUDG_CODE);
            
            rs.close();
            pstmt.close();
            
            //--예산구분(@BUDG_GUBUN)이 '2:이월예산'이면 예산과목(@BUDG_CODE)의 설정에 상관없이
            //--실적집계대상기간을 '년'으로 설정
            //--(이월예산은 사업년도의 첫째달&이월금액(BUDG_IWALL_I)에만 들어오므로.)
            if (BUDG_GUBUN.equals("2")) {
                CTL_TERM_UNIT = "4";
            }
            
            //--예산통제기간단위(AFB400T.CTL_TERM_UNIT)에 따라 실적집계 대상 기간 계산.
            //--('년'이면 회계기간 전체, '분기' 또는 '반기'일 경우 공통코드 정보 이용)
            if (CTL_TERM_UNIT.equals("4")) {
                sql.setLength(0);
                sql.append("SELECT ?  + SUBSTR(FN_DATE, 5, 2) ");
                sql.append("       ,LEFT( ? , 4) + SUBSTR(TO_DATE, 5, 2) ");
                sql.append("FROM   BOR100T ");
                sql.append("WHERE  COMP_CODE = ? ");
                
                pstmt = conn.prepareStatement(sql.toString());
                pstmt.setString(1, AC_YYYY);
                pstmt.setString(2, BUDG_YYYYMM);
                pstmt.setString(3, COMP_CODE);
                
                rs = pstmt.executeQuery();
                
                while (rs.next()) {
                    FrYyyyMm = rs.getString(1);
                    ToYyyyMm = rs.getString(2);
                    
                }
                System.out.println("======CTL_TERM_UNIT == 4========");
                System.out.println("FrYyyyMm : " + FrYyyyMm);
                System.out.println("ToYyyyMm : " + ToYyyyMm);
                
                rs.close();
                pstmt.close();
                
            } else if (CTL_TERM_UNIT.equals("2") || CTL_TERM_UNIT.equals("3")) {
                sql.setLength(0);
                sql.append("SELECT LEFT( ? , 4) ");
                sql.append("                   + RIGHT('00' + REF_CODE1, 2) ");
                sql.append("       ,LEFT( ? , 4) ");
                sql.append("                    + RIGHT('00' + REF_CODE2, 2) ");
                sql.append("FROM   BSA100T ");
                sql.append("WHERE  COMP_CODE =  ?  ");
                sql.append("       AND MAIN_CODE = CASE ");
                sql.append("                         WHEN  ?  = '2' THEN 'A074' --분기구분  ");
                sql.append("                         ELSE 'A075' --반기구분  ");
                sql.append("                       END ");
                sql.append("       AND SUB_CODE <> '$' ");
                sql.append("       AND REF_CODE1 <= Cast(RIGHT( ? , 2) AS NUMERIC) ");
                sql.append("       AND REF_CODE2 >= Cast(RIGHT( ? , 2) AS NUMERIC) ");
                
                pstmt = conn.prepareStatement(sql.toString());
                pstmt.setString(1, BUDG_YYYYMM);
                pstmt.setString(2, BUDG_YYYYMM);
                pstmt.setString(3, COMP_CODE);
                pstmt.setString(4, BUDG_YYYYMM);
                pstmt.setString(5, BUDG_YYYYMM);
                
                rs = pstmt.executeQuery();
                
                while (rs.next()) {
                    FrYyyyMm = rs.getString(1);
                    ToYyyyMm = rs.getString(2);
                    
                }
                System.out.println("===CTL_TERM_UNIT == 2 || CTL_TERM_UNIT == 3===");
                System.out.println("FrYyyyMm : " + FrYyyyMm);
                System.out.println("ToYyyyMm : " + ToYyyyMm);
                
                rs.close();
                pstmt.close();
            }
            
            //--실적금액 집계
            sql.setLength(0);
            sql.append("SELECT Sum(NVL(BUDG_CONF_I, 0) + NVL(BUDG_CONV_I, 0) ");
            sql.append("                     + NVL(BUDG_ASGN_I, 0) + NVL(BUDG_SUPP_I, 0) ");
            sql.append("                     + NVL(BUDG_IWALL_I, 0) + NVL(BUDG_TRANSFER_I, 0) - NVL(EX_AMT_I, 0) - ");
            sql.append("                     NVL(AC_AMT_I, 0) - ");
            sql.append("                                      NVL(DRAFT_AMT, 0) ");
            sql.append("                     - NVL(ORDER_AMT, 0) - NVL(REQ_AMT, 0)) AS BALN_I ");
            sql.append("       ,Sum(NVL(BUDG_CONF_I, 0) + NVL(BUDG_CONV_I, 0) ");
            sql.append("                      + NVL(BUDG_ASGN_I, 0) + NVL(BUDG_SUPP_I, 0) ");
            sql.append("                      + NVL(BUDG_IWALL_I, 0))  AS BUDG_I ");
            sql.append("       ,Sum(NVL(EX_AMT_I, 0) + NVL(AC_AMT_I, 0) ");
            sql.append("                        + NVL(DRAFT_AMT, 0) + NVL(ORDER_AMT, 0) ");
            sql.append("                        + NVL(REQ_AMT, 0))  AS ACTUAL_I ");
            sql.append("FROM   AFB510T ");
            sql.append("WHERE  COMP_CODE =  ?  ");
            sql.append("       AND ( ( BUDG_YYYYMM =  ?  ");
            sql.append("               AND  ?  = '1' ) ");
            sql.append("              OR ( BUDG_YYYYMM >= ? ");
            sql.append("                   AND BUDG_YYYYMM <= ? ");
            sql.append("                   AND  ?  <> '1' ) ) ");
            sql.append("       AND ( ( DEPT_CODE = ? ");
            sql.append("               AND  ?  = '1' ) ");
            sql.append("              OR (  ?  = '2' ) ) ");
            sql.append("       AND BUDG_CODE LIKE  ?  + '%' ");
            sql.append("       AND BUDG_GUBUN LIKE  ?  + '%'");
            
            pstmt = conn.prepareStatement(sql.toString());
            pstmt.setString(1, COMP_CODE);
            pstmt.setString(2, BUDG_YYYYMM);
            pstmt.setString(3, CTL_TERM_UNIT);
            pstmt.setString(4, FrYyyyMm);
            pstmt.setString(5, ToYyyyMm);
            pstmt.setString(6, CTL_TERM_UNIT);
            pstmt.setString(7, DEPT_CODE);
            pstmt.setString(8, CTL_CAL_UNIT);
            pstmt.setString(9, CTL_CAL_UNIT);
            pstmt.setString(10, CTL_BUDG_CODE);
            pstmt.setString(11, BUDG_GUBUN);
            
            rs = pstmt.executeQuery();
            
            //            ((CUBRIDResultSet)rs).setReturnable();
            
            while (rs.next()) {
                BALN_I = rs.getDouble(1);
                BUDG_I = rs.getDouble(2);
                ACTUAL_I = rs.getDouble(3);
                
            }
            
            rs.close();
            pstmt.close();
            
            rMap.put("BALN_I", BALN_I);
            rMap.put("BUDG_I", BUDG_I);
            rMap.put("ACTUAL_I", ACTUAL_I);
            
            System.out.println("BALN_I : " + BALN_I);
            System.out.println("BUDG_I : " + BUDG_I);
            System.out.println("ACTUAL_I : " + ACTUAL_I);
            
            return rMap;
            
            //          conn.setAutoCommit(true);
            
        } catch (SQLException e) {
            System.err.println("SQLException : " + e.getMessage());
        } catch (Exception e) {
            System.err.println("Exception : " + e.getMessage());
        } finally {
            if (rs != null) try {
                rs.close();
            } catch (SQLException e) {
                System.err.println("SQLException : " + e.getMessage());
                e.printStackTrace();
            }
/*            if (conn != null) try {
                conn.close();
            } catch (SQLException e) {
                System.err.println("Exception : " + e.getMessage());
                e.printStackTrace();
            }*/
            
        }
        
        rMap.put("BALN_I", BALN_I);
        rMap.put("BUDG_I", BUDG_I);
        rMap.put("ACTUAL_I", ACTUAL_I);
        //      
        //      System.out.println("======종료=======");
        //      System.out.println("BALN_I : " + BALN_I);
        //      System.out.println("BUDG_I : " + BUDG_I);
        //      System.out.println("ACTUAL_I : " + ACTUAL_I);
        //      
        //      String rtValue = BALN_I + ":" + BUDG_I + ":" + ACTUAL_I ;
        
        //      rMap.put("RTN_PAY_DRAFT_NO", PAY_DRAFT_NO);
        //      rMap.put("ERROR_DESC", ERROR_DESC);
        
        System.out.println("======종료 : 리턴되는 값=======");
        System.out.println("BALN_I : " + BALN_I);
        System.out.println("BUDG_I : " + BUDG_I);
        System.out.println("ACTUAL_I : " + ACTUAL_I);
        
        return rMap;
        //      return rs;
        
    }
}