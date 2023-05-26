package foren.unilite.multidb.cubrid.sp;


import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.HashMap;
import java.util.Map;

import cubrid.jdbc.driver.CUBRIDConnection;
import cubrid.jdbc.driver.CUBRIDResultSet;


public class SP_ACCNT_GetPossibleBudgAmt {

//	@SuppressWarnings({ "resource", "unused" })
//	public static Map<String, Object> SP_ACCNT_GetPossibleBudgAmt( Map param ) throws Exception {
//	public static ResultSet SP_ACCNT_GetPossibleBudgAmt( String COMP_CODE, String BUDG_YYYYMM, String DEPT_CODE, String BUDG_CODE
//																, String BUDG_GUBUN, double BALN_I, double BUDG_I, double ACTUAL_I) throws Exception {

	@SuppressWarnings("resource")
	public static Map<String, Object> GetPossibleBudgAmt(String COMP_CODE, String BUDG_YYYYMM, String DEPT_CODE, String BUDG_CODE, String BUDG_GUBUN)throws Exception {
		
		

	    double BALN_I = 0.0;		/* out */
		double BUDG_I = 0.0;		/* out */
		double ACTUAL_I = 0.0;		/* out */
		Map<String, Object> rMap = new HashMap<String, Object>();

		StringBuffer sql = new StringBuffer();
		Connection  conn = null;
		ResultSet   rs = null;
		PreparedStatement pstmt = null;
		
		System.out.println("======시작========");

		try {

			Class.forName("cubrid.jdbc.driver.CUBRIDDriver");
//			conn = DriverManager.getConnection("jdbc:default:connection");
			conn = DriverManager.getConnection("jdbc:CUBRID:192.168.1.220:33000:OmegaPlus:::?charset=UTF-8","unilite","UNILITE");

//			conn.setAutoCommit(true);


			if (COMP_CODE == null || COMP_CODE.equals("")){
				COMP_CODE = "MASTER";

			}

			if (BUDG_YYYYMM == null || BUDG_YYYYMM.equals("")){

				sql.setLength(0);
				sql.append("SELECT TO_CHAR(SYSDATETIME, 'YYYYMM') ");

				pstmt= conn.prepareStatement(sql.toString());

				rs = pstmt.executeQuery();

				while(rs.next()){
					//  -- 이체가 된 건은 수정하거나 삭제할 수 없습니다.
					BUDG_YYYYMM = rs.getString(1);

				}
				rs.close();
				pstmt.close();

			}
			
			
			if (DEPT_CODE == null || DEPT_CODE.equals("")){
				DEPT_CODE = "";

			}
			if (BUDG_CODE == null || BUDG_CODE.equals("")){
				BUDG_CODE = "";

			}
			if (BUDG_GUBUN == null || BUDG_GUBUN.equals("")){
				BUDG_GUBUN = "";

			}
			
			//변수선언
			String AC_YYYY = "";			//--사업년도
			String CTL_UNIT = "";			//--예산통제단위    (1:관        , 2:항      , 3:세항, 4:세세항, 5:목)
			String CTL_CAL_UNIT = "";		//--예산통제계산단위(1:부서별    , 2:회사전체)
			String CTL_TERM_UNIT = "";		//--예산통제기간단위(1:월        , 2:분기    , 3:반기, 4:년)
			String CTL_BUDG_CODE = "";		//--예산통제단위에 따른, 실적집계 및 예산통제에 이용될 예산코드
			 								//--(예산통제단위가 최하위('목')이 아닐 경우, 사용자가 입력한 예산코드의 상위 예산코드가 된다.)
			String FrYyyyMm = "";			//--회계기간(FROM)
			String ToYyyyMm = "";			//--회계기간(TO)
			
			
//			StringBuffer  sql = new StringBuffer();
			sql.setLength(0);
			sql.append("SELECT fnGetBudgAcYyyy( ? , ? ) ");

			pstmt= conn.prepareStatement(sql.toString());
			pstmt.setString(1, COMP_CODE );
			pstmt.setString(2, BUDG_YYYYMM);

			rs = pstmt.executeQuery();

			while(rs.next()){
				AC_YYYY = rs.getString(1);

			}
			rs.close();
			pstmt.close();

/*			//임시삭제 fnGetBudgInfo 없음
			//--예산설정정보 조회
			sql.setLength(0);
			sql.append("SELECT CTL_UNIT, ");
			sql.append("       CTL_CAL_UNIT, ");
			sql.append("       CTL_TERM_UNIT ");
			sql.append("FROM   fnGetBudgInfo( ? , ? , ? )");

			pstmt= conn.prepareStatement(sql.toString());
			pstmt.setString(1, COMP_CODE );
			pstmt.setString(2, AC_YYYY);
			pstmt.setString(3, BUDG_CODE);

			rs = pstmt.executeQuery();

			while(rs.next()){
				CTL_UNIT = rs.getString(1);
				CTL_CAL_UNIT = rs.getString(2);
				CTL_TERM_UNIT = rs.getString(3);

			}
			
			System.out.println("======--예산설정정보 조회========");
			System.out.println("CTL_UNIT : " + CTL_UNIT);
			System.out.println("CTL_CAL_UNIT : " + CTL_CAL_UNIT);
			System.out.println("CTL_TERM_UNIT : " + CTL_TERM_UNIT);
			
			
			
			rs.close();
			pstmt.close();
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

			pstmt= conn.prepareStatement(sql.toString());
			pstmt.setString(1, CTL_UNIT );
			pstmt.setString(2, COMP_CODE );
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

			while(rs.next()){
				CTL_BUDG_CODE = rs.getString(1);

			}
			System.out.println("CTL_BUDG_CODE : " + CTL_BUDG_CODE);
			
			rs.close();
			pstmt.close();
			
			
			//--예산구분(@BUDG_GUBUN)이 '2:이월예산'이면 예산과목(@BUDG_CODE)의 설정에 상관없이
	        //--실적집계대상기간을 '년'으로 설정
	        //--(이월예산은 사업년도의 첫째달&이월금액(BUDG_IWALL_I)에만 들어오므로.)
			if (BUDG_GUBUN.equals("2")){
				CTL_TERM_UNIT = "4";
			}
			
			
			//--예산통제기간단위(AFB400T.CTL_TERM_UNIT)에 따라 실적집계 대상 기간 계산.
	        //--('년'이면 회계기간 전체, '분기' 또는 '반기'일 경우 공통코드 정보 이용)
			if (CTL_TERM_UNIT.equals("4")){
				sql.setLength(0);
				sql.append("SELECT ?  + SUBSTR(FN_DATE, 5, 2) ");
				sql.append("       ,LEFT( ? , 4) + SUBSTR(TO_DATE, 5, 2) ");
				sql.append("FROM   BOR100T ");
				sql.append("WHERE  COMP_CODE = ? ");

				pstmt= conn.prepareStatement(sql.toString());
				pstmt.setString(1, AC_YYYY );
				pstmt.setString(2, BUDG_YYYYMM);
				pstmt.setString(3, COMP_CODE);

				rs = pstmt.executeQuery();

				while(rs.next()){
					FrYyyyMm = rs.getString(1);
					ToYyyyMm = rs.getString(2);

				}
				System.out.println("======CTL_TERM_UNIT == 4========");
				System.out.println("FrYyyyMm : " + FrYyyyMm);
				System.out.println("ToYyyyMm : " + ToYyyyMm);
				
				
				rs.close();
				pstmt.close();
				
				
			}else if (CTL_TERM_UNIT.equals("2") || CTL_TERM_UNIT.equals("3")){
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

				pstmt= conn.prepareStatement(sql.toString());
				pstmt.setString(1, BUDG_YYYYMM );
				pstmt.setString(2, BUDG_YYYYMM);
				pstmt.setString(3, COMP_CODE);
				pstmt.setString(4, BUDG_YYYYMM);
				pstmt.setString(5, BUDG_YYYYMM);

				rs = pstmt.executeQuery();

				while(rs.next()){
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
			sql.append("                     + NVL(BUDG_IWALL_I, 0) - NVL(EX_AMT_I, 0) - ");
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

			pstmt= conn.prepareStatement(sql.toString());
			pstmt.setString(1, COMP_CODE );
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
            
            
            

			while(rs.next()){
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
    		System.out.println("BUDG_I : " +BUDG_I);
    		System.out.println("ACTUAL_I : " +ACTUAL_I);
    		

            return rMap;
			
			
			
			
			
//			conn.setAutoCommit(true);
			


		}catch (SQLException e) {
			System.err.println("SQLException : " + e.getMessage());
		} catch (Exception e) {
			System.err.println("Exception : " + e.getMessage());
		} finally {
			if (rs != null)
				try {
					rs.close();
				} catch (SQLException e) {
					System.err.println("SQLException : " + e.getMessage());
					e.printStackTrace();
				}
			if (conn != null)
				try {
					conn.close();
				} catch (SQLException e) {
					System.err.println("Exception : " + e.getMessage());
					e.printStackTrace();
				}

		}

		rMap.put("BALN_I", BALN_I);
		rMap.put("BUDG_I", BUDG_I);
		rMap.put("ACTUAL_I", ACTUAL_I);
//		
//		System.out.println("======종료=======");
//		System.out.println("BALN_I : " + BALN_I);
//		System.out.println("BUDG_I : " + BUDG_I);
//		System.out.println("ACTUAL_I : " + ACTUAL_I);
//		
//		String rtValue = BALN_I + ":" + BUDG_I + ":" + ACTUAL_I ;
		
//		rMap.put("RTN_PAY_DRAFT_NO", PAY_DRAFT_NO);
//		rMap.put("ERROR_DESC", ERROR_DESC);

		System.out.println("======종료 : 리턴되는 값=======");
		System.out.println("BALN_I : " + BALN_I);
		System.out.println("BUDG_I : " +BUDG_I);
		System.out.println("ACTUAL_I : " +ACTUAL_I);
		
		return rMap;
//		return rs;
			
			
	}			
			


}