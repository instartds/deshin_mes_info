package foren.unilite.multidb.cubrid.fn;

import java.io.UnsupportedEncodingException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import cubrid.jdbc.driver.CUBRIDConnection;

public class FN_BUDG_FUNCTION {
    
    /**
     * <pre>
     * 함수명 : fnGetHanGul 
     * 입력인자 : 
     * 반환값 : 기본포맷에따라 변환된 날짜
     * </pre>
     * 
     * @param sCompcode
     * @param sYy
     * @return
     */
    public static String fnGetHanGul() {
        return "한글";
    }
    
    /**
     * <pre>
     * 함수명 : fnGetToday 
     * 입력인자 : 
     * 반환값 : 기본포맷에따라 변환된 날짜
     * </pre>
     * 
     * @param sCompcode
     * @param sYy
     * @return
     */
    public static String fnGetToday() {
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        String rtnValue = "";
        
        try {
            Class.forName("cubrid.jdbc.driver.CUBRIDDriver");
            conn = DriverManager.getConnection("jdbc:default:connection:");
            ( (CUBRIDConnection)conn ).setCharset("utf-8");
            
            StringBuffer sql = new StringBuffer();
            sql.append("SELECT TO_CHAR(SYSDATE, 'YYYYMMDD') AS TO_DAY FROM DB_ROOT\n");
            
            System.out.println("=======================================================");
            System.out.println(sql.toString());
            System.out.println("=======================================================");
            
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql.toString());
            rs.next();
            rtnValue = rs.getString("TO_DAY");
            
            rs.close();
            stmt.close();
        } catch (SQLException e) {
            System.err.println(e.getMessage());
        } catch (Exception e) {
            System.err.println(e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {}
        }
        
        return rtnValue;
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
    @SuppressWarnings( "resource" )
    public static String fnGetBudgAcYyyy( String sCompcode, String sDate ) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int calc_months = 0;
        int years = 0;
        String rtnValue = null;
        
        if (sCompcode == null || sCompcode.trim().length() == 0) return "회사코드 누락";
        if (sDate.length() > 8) {
            return "기준일자 오류";
        } else if (sDate.length() == 4) {
            sDate = sDate + "0101";
        } else if (sDate.length() == 6) {
            sDate = sDate + "01";
        }
        
        try {
            Class.forName("cubrid.jdbc.driver.CUBRIDDriver");
            conn = DriverManager.getConnection("jdbc:default:connection:");
            ( (CUBRIDConnection)conn ).setCharset("utf-8");
            
            // 01. 변수값을 할당합니다.
            // 회계기간 시작일부터 (파라메터)일자까지의 개월수
            StringBuffer sql = new StringBuffer();
            if (sDate == null || sDate.trim().length() == 0) {
                sql.append("SET @TODATE = CURDATE();\n");
            } else {
                sql.append("SET @TODATE = TO_DATE('" + sDate + "', 'YYYYMMDD' );\n");
            }
            System.out.println("=======================================================");
            System.out.println(sql.toString());
            System.out.println("=======================================================");
            
            pstmt = conn.prepareStatement(sql.toString());
            pstmt.executeUpdate();
            
            sql = new StringBuffer();
            sql.append("SET @FNDATE = (\n");
            sql.append("    SELECT TO_DATE(FN_DATE, 'YYYYMMDD' )\n");
            sql.append("      FROM BOR100T\n");
            sql.append("     WHERE COMP_CODE = ?\n");
            sql.append(");\n");
            sql.append("\n");
            
            System.out.println("=======================================================");
            System.out.println(sql.toString());
            System.out.println("=======================================================");
            
            pstmt = conn.prepareStatement(sql.toString());
            pstmt.setString(1, sCompcode);
            pstmt.executeUpdate();
            
            // 02. 할당된 변수를 이용하여 개월수를 년수로 계산
            sql = new StringBuffer();
            sql.append("SELECT CAST(TRUNC(MONTHS_BETWEEN(@TODATE, @FNDATE), 0) AS INT) AS CALC_MONTH \n");
            
            System.out.println("=======================================================");
            System.out.println(sql.toString());
            System.out.println("=======================================================");
            
            pstmt = conn.prepareStatement(sql.toString());
            rs = pstmt.executeQuery();
            
            rs.next();
            
            calc_months = rs.getInt("CALC_MONTH");
            
            // 02. 할당된 변수를 이용하여 개월수를 년수로 계산
            sql = new StringBuffer();
            if (calc_months >= 0) {
                sql.append("SELECT ROUND((? / 12), 1) AS YEARS FROM DB_ROOT\n");
            } else {
                sql.append("SELECT ROUND(((? + 1) / 12), 1) - 1 AS YEARS FROM DB_ROOT\n");
            }
            
            System.out.println("=======================================================");
            System.out.println(sql.toString());
            System.out.println("=======================================================");
            
            pstmt = conn.prepareStatement(sql.toString());
            pstmt.setInt(1, calc_months);
            rs = pstmt.executeQuery();
            
            rs.next();
            
            years = rs.getInt("YEARS");
            
            // 03. 회계년도 계산
            sql = new StringBuffer();
            sql.append("SELECT YEAR(ADDDATE( @FNDATE , INTERVAL + ? YEAR)) AS ACYYYY\n");
            
            System.out.println("=======================================================");
            System.out.println(sql.toString());
            System.out.println("=======================================================");
            
            pstmt = conn.prepareStatement(sql.toString());
            pstmt.setInt(1, years);
            rs = pstmt.executeQuery();
            
            rs.next();
            
            rtnValue = rs.getString("ACYYYY");
/*
            // 04. 사용한 변수를 삭제합니다.
            sql = new StringBuffer();
            sql.append("DEALLOCATE VARIABLE @TODATE;\n");
            sql.append("DEALLOCATE VARIABLE @FNDATE;\n");
            
            System.out.println("=======================================================");
            System.out.println(sql.toString());
            System.out.println("=======================================================");
            
            pstmt = conn.prepareStatement(sql.toString());
            pstmt.executeUpdate();
*/
            pstmt.close();
            rs.close();
            
        } catch (SQLException e) {
            System.err.println(e.getMessage());
            rtnValue = e.getMessage();
        } catch (Exception e) {
            System.err.println(e.getMessage());
            rtnValue = e.getMessage();
        } finally {
            try {
                if (rs != null) rs.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {}
        }
        
        return rtnValue;
    }
    
}
