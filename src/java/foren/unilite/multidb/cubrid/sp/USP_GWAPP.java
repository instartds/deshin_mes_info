package foren.unilite.multidb.cubrid.sp;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

public class USP_GWAPP {


	@SuppressWarnings({ "unused", "rawtypes" })
	public static Map<String, Object> SP_GWAPP( Map param ) throws Exception {
	//public static void main(String[] args) {

		/*===============================================================================================================================
		  SP_GWAPP

		  DECLARE @RTN_CODE     NVARCHAR(10)
		        , @RTN_MSG      NVARCHAR(2000)
		  EXEC SP_GWAPP 'L6100A20131007001', 'HANDY', '1', '1', @RTN_CODE OUTPUT, @RTN_MSG OUTPUT
		  SELECT @RTN_CODE, @RTN_MSG
		===============================================================================================================================*/

		String GWIF_ID = param.get("GWIF_ID") == null ? "" : (String)param.get("GWIF_ID");   // 인터페이스 id 
		String SP_CALL = param.get("SP_CALL") == null ? "" : (String)param.get("SP_CALL");  // 예산관리 key 
		String USER_ID  = param.get("USER_ID") == null ? "" :  (String)param.get("USER_ID");  // 승인자 id 
		String DOC_NO  = param.get("DOC_NO") == null ? "" :  (String)param.get("DOC_NO");   // doc_no 
		String GUBUN   = param.get("GUBUN") == null ? "" :   (String)param.get("GUBUN");   // 메뉴구분
		String STATUS  = param.get("STATUS") == null ? "" :  (String)param.get("STATUS");   // 결재상태
				
//		String GWIF_ID = "L6100A20131007001"; 
//		String SP_CALL = "HANDY";
//		String GUBUN = "1";
//		String STATUS = "1";

		Map<String, Object> rMap = new HashMap<String, Object>();

		StringBuffer sql = new StringBuffer();
		Connection  conn = null;
		ResultSet   rs = null;
		PreparedStatement pstmt = null;

		String RTN_CODE = "";	/*output*/
		String RTN_MSG = "";	/*output*/


		try {

			Class.forName("cubrid.jdbc.driver.CUBRIDDriver");
			//				conn = DriverManager.getConnection("jdbc:default:connection");
			conn = DriverManager.getConnection("jdbc:CUBRID:192.168.1.220:33000:OmegaPlus:::","unilite","UNILITE");

			//conn.setAutoCommit(false);

			
			//-- LOG TABLE INSERT
			sql.setLength(0);
			sql.append("INSERT INTO L_SP_GWAPP ");
			sql.append("            (GWIF_ID ");
			sql.append("             ,SP_CALL ");
			sql.append("             ,GUBUN ");
			sql.append("             ,STATUS ");
			sql.append("             ,INSERT_DB_TIME) ");
			sql.append("VALUES      ( ?  ");
			sql.append("             , ?  ");
			sql.append("             , ?  ");
			sql.append("             , ?  ");
			sql.append("             ,SYSDATETIME)");

			pstmt = conn.prepareStatement(sql.toString());
			pstmt.setString(1, GWIF_ID ); 
			pstmt.setString(2, GWIF_ID ); 
			pstmt.setString(3, GUBUN ); 
			pstmt.setString(4, STATUS ); 

			pstmt.executeUpdate();            	  

			pstmt.close();

			
			System.out.println("-- LOG TABLE INSERT --");
			System.out.println("SQL : " + sql.toString());
			
			System.out.println("GWIF_ID : " + GWIF_ID);
			System.out.println("SP_CALL : " + SP_CALL);
			System.out.println("GUBUN : " + GUBUN);
			System.out.println("STATUS : " + STATUS);
			
			
			//-- 자동기표 CALL
			//IF @GUBUN = '1'	-- 지출결의
			if (GUBUN.equals("1")){
				if (STATUS.equals("1") || STATUS.equals("3") ){
					//SP 실행 
					//EXEC UNILITE.SP_APP_DRAFT_PAY @GWIF_ID, @SP_CALL, @RTN_CODE OUTPUT, @RTN_MSG OUTPUT
					
					//USP_APP_DRAFT_PAY snadp = new USP_APP_DRAFT_PAY();

					//String SPDP_GWIF_ID = "MASTER";
					//String SPDP_SP_CALL = "201701";

					//Map rResult =  snadp.SP_APP_DRAFT_PAY(SPDP_GWIF_ID, SPDP_SP_CALL );
					
					//RTN_CODE = rResult.get("RTN_CODE").toString();
					//RTN_MSG = rResult.get("RTN_MSG").toString();
					
					
					 
					sql.setLength(0);
					sql.append("UPDATE AFB700T ");
					sql.append("   SET  EX_DATE  = TO_CHAR(SYSDATE, 'YYYYMMDD')  ");
					sql.append("      , [STATUS]   =  ?  ");
					sql.append("      , UPDATE_DB_USER   =  ?  ");
					//sql.append("      , DOC_NO   =  ?  ");
					sql.append("      , UPDATE_DB_TIME   =  SYSDATETIME  ");
					sql.append("  WHERE COMP_CODE   = 'MASTER' ");
					sql.append("    AND PAY_DRAFT_NO = ? ");
					
					System.out.println("SQL : " + sql.toString());
					System.out.println("GWIF_ID : " + GWIF_ID);
					System.out.println("DOC_NO : " + DOC_NO);
					System.out.println("USER_ID : " + USER_ID);
					System.out.println("STATUS : " + STATUS);
					
					pstmt = conn.prepareStatement(sql.toString());
					pstmt.setString(1, STATUS ); 
					pstmt.setString(2,  USER_ID); 
					//pstmt.setString(3,  DOC_NO); 
					pstmt.setString(3, GWIF_ID ); 

					pstmt.executeUpdate();            	  

					pstmt.close();					
					
					System.out.println("SP_APP_DRAFT_PAY 호출 후 리턴값들");
					System.out.println("RTN_CODE :::::::::::" + RTN_CODE);
					System.out.println("RTN_MSG :::::::::::" + RTN_MSG);
					
					
				//반려 		
				}else if (STATUS.equals("5")){
					String CANCEL = "";
					//SP 실행
					//EXEC UNILITE.SP_APP_STOP_PAY @GWIF_ID, @SP_CALL, @CANCEL, @RTN_CODE OUTPUT, @RTN_MSG OUTPUT
					
					//USP_APP_STOP_PAY snasp = new USP_APP_STOP_PAY();

					//String SPSP_GWIF_ID = "MASTER";
					//String SPSP_SP_CALL = "201701";
					//String SPSP_CANCEL = "";

					//Map rResult =  snasp.SP_APP_STOP_PAY(SPSP_GWIF_ID, SPSP_SP_CALL, SPSP_CANCEL );
					
					//RTN_CODE = rResult.get("RTN_CODE").toString();
					//RTN_MSG = rResult.get("RTN_MSG").toString();
					
										
					sql.setLength(0);
					sql.append("UPDATE AFB700T ");
					sql.append("   SET  EX_DATE  = TO_CHAR(SYSDATE, 'YYYYMMDD')  ");
					sql.append("      , [STATUS]   =  ?  ");
					sql.append("      , UPDATE_DB_USER   =  ?  ");
					//sql.append("      , DOC_NO   =  ''  ");					
					sql.append("      , UPDATE_DB_TIME   =  SYSDATETIME  ");
					sql.append("  WHERE COMP_CODE   = 'MASTER' ");
					sql.append("    AND PAY_DRAFT_NO = ? ");
					
					
					pstmt = conn.prepareStatement(sql.toString());
					pstmt.setString(1, STATUS ); 
					pstmt.setString(2,  USER_ID); 
					pstmt.setString(3,  GWIF_ID ); 

					pstmt.executeUpdate();            	  

					pstmt.close();					
								
					
					
					System.out.println("SP_APP_STOP_PAY 호출 후 리턴값들");
					System.out.println("RTN_CODE :::::::::::" + RTN_CODE);
					System.out.println("RTN_MSG :::::::::::" + RTN_MSG);
					
				//승인 	

				}else if (STATUS.equals("9")){
					//SP 실행
					//EXEC UNILITE.SP_APP_END_PAY @GWIF_ID, @SP_CALL, @RTN_CODE OUTPUT, @RTN_MSG OUTPUT
					
					//USP_APP_END_PAY snaep = new USP_APP_END_PAY();

					//String SPEP_GWIF_ID = "MASTER";
					//String SPEP_SP_CALL = "201701";

					//Map rResult =  snaep.SP_APP_END_PAY(SPEP_GWIF_ID, SPEP_SP_CALL );
					
					//RTN_CODE = rResult.get("RTN_CODE").toString();
					//RTN_MSG = rResult.get("RTN_MSG").toString();
					
					sql.setLength(0);
					sql.append("UPDATE AFB700T ");
					sql.append("   SET  EX_DATE  = TO_CHAR(SYSDATE, 'YYYYMMDD')  ");
					sql.append("      , [STATUS]   =  ?  ");
					sql.append("      , UPDATE_DB_USER   =  ?  ");
					sql.append("      , DOC_NO   =  ?  ");
					sql.append("      , UPDATE_DB_TIME   =  SYSDATETIME  ");
					sql.append("  WHERE COMP_CODE   = 'MASTER' ");
					sql.append("    AND PAY_DRAFT_NO = ? ");
					
					
					pstmt = conn.prepareStatement(sql.toString());
					pstmt.setString(1, STATUS ); 
					pstmt.setString(2,  USER_ID); 
					pstmt.setString(3,  DOC_NO); 
					pstmt.setString(4, GWIF_ID ); 

					pstmt.executeUpdate();            	  

					pstmt.close();										
					System.out.println("0");

					sql.setLength(0);
					sql.append("SELECT a.pay_date, b.pay_draft_no, b.seq");
					sql.append("        FROM   afb700t a, afb710t b ");
					sql.append("        WHERE  a.comp_code = 'MASTER'  ");
					sql.append("          AND a.comp_code =  b.comp_code           " );
					sql.append("          AND a.pay_draft_no =  b.pay_draft_no   " );					
					sql.append("          AND a.pay_draft_no = ?  ");

					System.out.println("sql::" + sql.toString());
					pstmt= conn.prepareStatement(sql.toString());
					pstmt.setString(1, GWIF_ID);

					rs = pstmt.executeQuery();					
					
					while(rs.next()){
						//  -- 이체가 된 건은 수정하거나 삭제할 수 없습니다.
						//System.out.println("1");
						sql.setLength(0);							
		         		sql.append("		UPDATE  afb510t a, ( SELECT A.tot_amt_i, a.pay_draft_no, a.seq, a.dept_code , a.budg_code, a.acct_no, A1.budg_gubun FROM   afb710t A ");
					    sql.append("                       INNER JOIN afb700t A1  ");
					    sql.append("                          ON A1.comp_code = A.comp_code  ");
				        sql.append("     AND A1.pay_draft_no = A.pay_draft_no ");
				        sql.append("     AND A1.pay_draft_no =? ");
				        sql.append("     AND A.seq = ? ");
						sql.append("		             ) b ");
						sql.append("	SET    a.req_amt = NVL(a.req_amt, 0) - nvl(b.tot_amt_i,0) "); 
						sql.append("       ,a.ex_amt_i = NVL(a.ex_amt_i, 0) + nvl(b.tot_amt_i,0) ");
						sql.append("		WHERE  a.comp_code =  'MASTER'  ");
						sql.append("			AND a.comp_code = A.comp_code ");
	 					sql.append("		    AND a.budg_yyyymm = LEFT( ?, 4) + '01'  ");
						sql.append("		    AND B.dept_code = A.dept_code  ");
						sql.append("		    AND B.budg_code = A.budg_code  ");
						sql.append("		    AND B.acct_no = A.acct_no  ");
						sql.append("		    AND B.budg_gubun = A.budg_gubun ");

						
						System.out.println("SQL : " + sql.toString());
						
						pstmt = conn.prepareStatement(sql.toString());
						pstmt.setString(1,  rs.getString(2) ); 
						pstmt.setInt(2,  rs.getInt(3));  	
						pstmt.setString(3,  rs.getString(1) ); 
					

						pstmt.executeUpdate();            	  

						pstmt.close();	
						
						System.out.println("2");
					}
					rs.close();
					pstmt.close(); 					
					
					

									
					System.out.println("SP_APP_END_PAY 호출 후 리턴값들");
					System.out.println("RTN_CODE :::::::::::" + RTN_CODE);
					System.out.println("RTN_MSG :::::::::::" + RTN_MSG);

				}else if (STATUS.equals("C")){
					//SP 실행
					//EXEC UNILITE.SP_APP_END_PAY @GWIF_ID, @SP_CALL, @RTN_CODE OUTPUT, @RTN_MSG OUTPUT
					
					//USP_APP_END_PAY snaep = new USP_APP_END_PAY();

					//String SPEP_GWIF_ID = "MASTER";
					//String SPEP_SP_CALL = "201701";

					//Map rResult =  snaep.SP_APP_END_PAY(SPEP_GWIF_ID, SPEP_SP_CALL );
					
					//RTN_CODE = rResult.get("RTN_CODE").toString();
					//RTN_MSG = rResult.get("RTN_MSG").toString();
					
					sql.setLength(0);
					sql.append("UPDATE AFB700T ");
					sql.append("   SET  EX_DATE  = TO_CHAR(SYSDATE, 'YYYYMMDD')  ");
					sql.append("      , [STATUS]   =  ?  ");
					sql.append("      , UPDATE_DB_USER   =  ?  ");
					sql.append("      , DOC_NO   = ''  ");
					sql.append("      , UPDATE_DB_TIME   =  SYSDATETIME  ");
					sql.append("  WHERE COMP_CODE   = 'MASTER' ");
					sql.append("    AND PAY_DRAFT_NO = ? ");
					
					
					pstmt = conn.prepareStatement(sql.toString());
					pstmt.setString(1, STATUS ); 
					pstmt.setString(2,  USER_ID); 
					pstmt.setString(3, GWIF_ID ); 

					pstmt.executeUpdate();            	  

					pstmt.close();										
					

					sql.append("SELECT a.pay_date, pay_draft_no, seq");
					sql.append("        FROM   afb700t a, afb710t b ");
					sql.append("        WHERE  a.comp_code = 'MASTER'  ");
					sql.append("          AND a.comp_code =  b.comp_code           " );
					sql.append("          AND a.pay_draft_no =  b.pay_draft_no   " );					
					sql.append("          AND a.pay_draft_no = ?  ");

					pstmt= conn.prepareStatement(sql.toString());
					pstmt.setString(1, GWIF_ID);

					rs = pstmt.executeQuery();

					
					
					while(rs.next()){
						//  -- 이체가 된 건은 수정하거나 삭제할 수 없습니다.
						
						sql.setLength(0);							
		         		sql.append("		UPDATE  afb510t a, ( SELECT A.tot_amt_i, a.pay_draft_no, a.seq, a.dept_code , a.budg_code, a.acct_no, A1.budg_gubun FROM   afb710t A ");
					    sql.append("                       INNER JOIN afb700t A1  ");
					    sql.append("                          ON A1.comp_code = A.comp_code  ");
				        sql.append("     AND A1.pay_draft_no = A.pay_draft_no ");
				        sql.append("     AND A1.pay_draft_no =? ");
				        sql.append("     AND A.seq = ? ");
						sql.append("		             ) b ");
						sql.append("	SET    a.req_amt = NVL(a.req_amt, 0) +  nvl(b.tot_amt_i,0) "); 
						sql.append("          ,a.ex_amt_i = NVL(a.ex_amt_i, 0) - nvl(b.tot_amt_i,0) ");
						sql.append("		WHERE  a.comp_code =  'MASTER'  ");
						sql.append("			AND a.comp_code = A.comp_code ");
	 					sql.append("		    AND a.budg_yyyymm = LEFT( ?, 4) + '01'  ");
						sql.append("		    AND B.dept_code = A.dept_code  ");
						sql.append("		    AND B.budg_code = A.budg_code  ");
						sql.append("		    AND B.acct_no = A.acct_no  ");
						sql.append("		    AND B.budg_gubun = A.budg_gubun ");

						
						System.out.println("SQL : " + sql.toString());
						
						pstmt = conn.prepareStatement(sql.toString());
						pstmt.setString(1,  rs.getString(2) ); 
						pstmt.setInt(2,  rs.getInt(3));  	
						pstmt.setString(3,  rs.getString(1) ); 
					

						pstmt.executeUpdate();            	  

						pstmt.close();	

					}
					rs.close();
					pstmt.close(); 					
					
					

									
					System.out.println("SP_APP_END_PAY 호출 후 리턴값들");
					System.out.println("RTN_CODE :::::::::::" + RTN_CODE);
					System.out.println("RTN_MSG :::::::::::" + RTN_MSG);

				}				
				

			}else if (GUBUN.equals("2")){    //ELSE IF  @GUBUN = '2'	-- 수입결의
				if (STATUS.equals("1") || STATUS.equals("3") ){
					//SP실행
					//EXEC UNILITE.SP_APP_DRAFT_IN @GWIF_ID, @SP_CALL, @RTN_CODE OUTPUT, @RTN_MSG OUTPUT
					//USP_APP_DRAFT_IN snadi = new USP_APP_DRAFT_IN();

					//String SPDI_GWIF_ID = "MASTER";
					//String SPDI_SP_CALL = "201701";
//					String SPEP_CANCEL = "";

					//Map rResult =  snadi.SP_APP_DRAFT_IN(SPDI_GWIF_ID, SPDI_SP_CALL );
					
					//RTN_CODE = rResult.get("RTN_CODE").toString();
					//RTN_MSG = rResult.get("RTN_MSG").toString();
					
					sql.setLength(0);
					sql.append("UPDATE AFB800T ");
					sql.append("   SET  EX_DATE  = TO_CHAR(SYSDATE, 'YYYYMMDD')  ");
					sql.append("      , [STATUS]   =  ?  ");
					sql.append("      , UPDATE_DB_USER   =  ?  ");
					//sql.append("      , DOC_NO   =  ?  ");					
					sql.append("      , UPDATE_DB_TIME   =  SYSDATETIME  ");
					sql.append("  WHERE COMP_CODE   = 'MASTER' ");
					sql.append("    AND IN_DRAFT_NO = ? ");
					
					
					pstmt = conn.prepareStatement(sql.toString());
					pstmt.setString(1, STATUS ); 
					pstmt.setString(2,  USER_ID); 
					//pstmt.setString(3,  DOC_NO); 
					pstmt.setString(3, GWIF_ID ); 


					pstmt.executeUpdate();            	  

					pstmt.close();					
					
					
					System.out.println("SP_APP_DRAFT_IN 호출 후 리턴값들");
					System.out.println("RTN_CODE :::::::::::" + RTN_CODE);
					System.out.println("RTN_MSG :::::::::::" + RTN_MSG);

				}else if (STATUS.equals("5")){
					//SP 실행
					//EXEC UNILITE.SP_APP_STOP_IN @GWIF_ID, @SP_CALL, @RTN_CODE OUTPUT, @RTN_MSG OUTPUT
					//SP_NBOX_APP_STOP_IN snasi = new SP_NBOX_APP_STOP_IN();

					String SPSI_GWIF_ID = "MASTER";
					String SPSI_SP_CALL = "201701";
//					String SPEP_CANCEL = "";

					//Map rResult =  snasi.SP_APP_STOP_IN(SPSI_GWIF_ID, SPSI_SP_CALL );
					
					//RTN_CODE = rResult.get("RTN_CODE").toString();
					//RTN_MSG = rResult.get("RTN_MSG").toString();

					sql.setLength(0);
					sql.append("UPDATE AFB800T ");
					sql.append("   SET  EX_DATE  = TO_CHAR(SYSDATE, 'YYYYMMDD')  ");
					sql.append("      , [STATUS]   =  ?  ");
					sql.append("      , UPDATE_DB_USER   =  ?  ");
					sql.append("      , DOC_NO   =  ''  ");					
					sql.append("      , UPDATE_DB_TIME   =  SYSDATETIME  ");
					sql.append("  WHERE COMP_CODE   = 'MASTER' ");
					sql.append("    AND IN_DRAFT_NO = ? ");
					
					
					pstmt = conn.prepareStatement(sql.toString());
					pstmt.setString(1, STATUS ); 
					pstmt.setString(2,  USER_ID); 
					pstmt.setString(3, GWIF_ID ); 

					pstmt.executeUpdate();            	  

					pstmt.close();		
					
					 
					System.out.println("SP_APP_STOP_IN 호출 후 리턴값들");
					System.out.println("RTN_CODE :::::::::::" + RTN_CODE);
					System.out.println("RTN_MSG :::::::::::" + RTN_MSG);

				}else if (STATUS.equals("9")){
					//SP 실행
	
					
					sql.setLength(0);
					sql.append("UPDATE AFB800T ");
					sql.append("   SET  EX_DATE  = TO_CHAR(SYSDATE, 'YYYYMMDD')  ");
					sql.append("      , [STATUS]   =  ?  ");
					sql.append("      , UPDATE_DB_USER   =  ?  ");
					sql.append("      , DOC_NO   =  ?  ");					
					sql.append("      , UPDATE_DB_TIME   =  SYSDATETIME  ");
					sql.append("  WHERE COMP_CODE   = 'MASTER' ");
					sql.append("    AND IN_DRAFT_NO = ? ");
					
					
					pstmt = conn.prepareStatement(sql.toString());
					pstmt.setString(1, STATUS ); 
					pstmt.setString(2,  USER_ID); 
					pstmt.setString(3,  DOC_NO); 
					pstmt.setString(4, GWIF_ID ); 


					pstmt.executeUpdate();            	  

					pstmt.close();					
															
					
					System.out.println("SP_APP_END_IN 호출 후 리턴값들");
					System.out.println("RTN_CODE :::::::::::" + RTN_CODE);
					System.out.println("RTN_MSG :::::::::::" + RTN_MSG);

					
					
					sql.setLength(0);
					sql.append("SELECT a.in_date, b.in_draft_no, seq");
					sql.append("        FROM   afb800t a, afb810t b ");
					sql.append("        WHERE  a.comp_code = 'MASTER'  ");
					sql.append("          AND a.comp_code =  b.comp_code           " );
					sql.append("          AND a.in_draft_no =  b.in_draft_no   " );					
					sql.append("          AND a.in_draft_no = ?  ");

					pstmt= conn.prepareStatement(sql.toString());
					pstmt.setString(1, GWIF_ID);

					rs = pstmt.executeQuery();

					
					
					while(rs.next()){
						//  -- 이체가 된 건은 수정하거나 삭제할 수 없습니다.

						
						sql.setLength(0);							
		         		sql.append("		UPDATE  afb510t a, ( SELECT A.in_amt_i, a.IN_draft_no, a.seq, a.dept_code , a.budg_code, a.acct_no  FROM   afb810t A ");
					    sql.append("                       INNER JOIN afb800t A1  ");
					    sql.append("                          ON A1.comp_code = A.comp_code  ");
				        sql.append("     AND A1.in_draft_no = A.in_draft_no ");
				        sql.append("     AND A1.in_draft_no =? ");
				        sql.append("     AND A.seq = ? ");
						sql.append("		             ) b ");
						sql.append("	SET    a.req_amt = NVL(a.req_amt, 0) - nvl(b.in_amt_i,0) "); 
						sql.append("          ,a.ex_amt_i = NVL(a.ex_amt_i, 0) + nvl(b.in_amt_i,0) ");
						sql.append("		WHERE  a.comp_code =  'MASTER'  ");
						sql.append("			AND a.comp_code = A.comp_code ");
	 					sql.append("		    AND a.budg_yyyymm = LEFT( ?, 4) + '01'  ");
						sql.append("		    AND B.dept_code = A.dept_code  ");
						sql.append("		    AND B.budg_code = A.budg_code  ");
						sql.append("		    AND B.acct_no = A.acct_no  ");


						
						System.out.println("SQL : " + sql.toString());
						
						pstmt = conn.prepareStatement(sql.toString());
						pstmt.setString(1,  rs.getString(2) ); 
						pstmt.setInt(2,  rs.getInt(3));  	
						pstmt.setString(3,  rs.getString(1) ); 
					

						pstmt.executeUpdate();            	  

						pstmt.close();							
						
						

					}
					rs.close();
					pstmt.close(); 										
					
					
				}


			}

			else if (GUBUN.equals("3")){		//ELSE IF  @GUBUN = '3'	-- 정정반납결의 
				if (STATUS.equals("1") || STATUS.equals("3")  ){
					//SP 실행
					//EXEC UNILITE.SP_APP_DRAFT_DRAFT @GWIF_ID, @SP_CALL, @ERROR_DESC OUTPUT
					
					sql.setLength(0);
					sql.append("UPDATE AFB730T ");
					sql.append("   SET  [STATUS]   =  ?  ");
					sql.append("      , UPDATE_DB_USER   =  ?  ");
					//sql.append("      , IF_DOC_NO   =  ''  ");					
					sql.append("      , UPDATE_DB_TIME   =  SYSDATETIME  ");
					sql.append("  WHERE COMP_CODE   = 'MASTER' ");
					sql.append("    AND DOC_NO = ? ");
					
					
					pstmt = conn.prepareStatement(sql.toString());
					pstmt.setString(1, STATUS ); 
					pstmt.setString(2,  USER_ID); 
					pstmt.setString(3, GWIF_ID ); 

					pstmt.executeUpdate();            	  

					pstmt.close();		
					
					
					
				}else if (STATUS.equals("5")){
				//SP 실행
				//EXEC UNILITE.SP_APP_STOP_DRAFT @GWIF_ID, @SP_CALL, @ERROR_DESC OUTPUT
					
					sql.setLength(0);
					sql.append("UPDATE AFB730T ");
					sql.append("   SET  [STATUS]   =  ?  ");
					sql.append("      , AP_USER_ID   =  ?  ");
					sql.append("      , AP_DATE   = TO_CHAR(SYSDATE, 'YYYYMMDD')  ");	
					//sql.append("      , IF_DOC_NO   =  ''  ");					
					sql.append("      , UPDATE_DB_TIME   =  SYSDATETIME  ");
					sql.append("  WHERE COMP_CODE   = 'MASTER' ");
					sql.append("    AND DOC_NO = ? ");
					
					
					pstmt = conn.prepareStatement(sql.toString());
					pstmt.setString(1, STATUS ); 
					pstmt.setString(2,  USER_ID); 
					pstmt.setString(3, GWIF_ID ); 

					pstmt.executeUpdate();            	  

					pstmt.close();							
					
					
				}else if (STATUS.equals("9")){
				//SP 실행
				//EXEC UNILITE.SP_APP_END_DRAFT @GWIF_ID, @SP_CALL, @ERROR_DESC OUTPUT
					
					sql.setLength(0);
					sql.append("UPDATE AFB730T ");
					sql.append("   SET  [STATUS]   =  ?  ");
					sql.append("      , AP_USER_ID   =  ?  ");
					sql.append("      , AP_DATE   = TO_CHAR(SYSDATE, 'YYYYMMDD')  ");	
					sql.append("      , IF_DOC_NO   =  ?  ");					
					sql.append("      , UPDATE_DB_TIME   =  SYSDATETIME  ");
					sql.append("  WHERE COMP_CODE   = 'MASTER' ");
					sql.append("    AND DOC_NO = ? ");
										
					pstmt = conn.prepareStatement(sql.toString());
					pstmt.setString(1, STATUS ); 
					pstmt.setString(2,  USER_ID); 
					pstmt.setString(3,  DOC_NO); 
					pstmt.setString(4, GWIF_ID ); 

					pstmt.executeUpdate();            	  

					pstmt.close();							
					
					sql.setLength(0);
					sql.append("SELECT a.ac_yyyy, a.dept_code, a.acct_no, a.ac_type, a.budg_code, nvl(a.ex_amt,0), b.budg_code,  nvl(b.tot_amt_i,0)");
					sql.append("        FROM   afb730t a, afb710t b ");
					sql.append("        WHERE  a.comp_code = b.comp_code ");
					sql.append("          AND a.ref_doc_no =  b.pay_draft_no           " );
					sql.append("          AND a.ref_doc_seq =  b.seq   " );					
					sql.append("          AND a.dept_code =  b.dept_code   " );
					sql.append("          AND a.doc_no = ?  ");

					pstmt= conn.prepareStatement(sql.toString());
					pstmt.setString(1, GWIF_ID);

					rs = pstmt.executeQuery();					
					
					
					while(rs.next()){
					
						double gap_amt_i = rs.getDouble(6) - rs.getDouble(8) ;
						double from_amt_i = rs.getDouble(8);
						double to_amt_i   = rs.getDouble(6);
						String from_budg_code = rs.getString(7);
						String to_budg_code = rs.getString(5);
						String ac_yyyymm = rs.getString(1) + "01";
						String dept_code = rs.getString(2);
						String acct_no = rs.getString(3);
						
						
						//반납결의
						if ( "C0063".equals(rs.getString(4))) {
							
							
							sql.setLength(0);
							sql.append("UPDATE AFB510T ");
							sql.append("   SET  order_amt   =  order_amt - ?  ");			
							sql.append("      , UPDATE_DB_TIME   =  SYSDATETIME  ");
							sql.append("  WHERE COMP_CODE   = 'MASTER' ");
							sql.append("    AND budg_yyyymm = ? ");
							sql.append("    AND dept_code = ? ");
							sql.append("    AND acct_no = ? ");
							sql.append("    AND budg_code = ? ");
							
							pstmt = conn.prepareStatement(sql.toString());
							pstmt.setDouble(1, to_amt_i ); 
							pstmt.setString(2,  ac_yyyymm); 
							pstmt.setString(3,  dept_code); 
							pstmt.setString(4,  acct_no ); 
							pstmt.setString(5,  from_budg_code ); 
							
							pstmt.executeUpdate();            	  
	
							pstmt.close();									
							
							
						//정정결의 	
						}else {
							sql.setLength(0);
							sql.append("UPDATE AFB510T ");
							sql.append("   SET  order_amt   =  order_amt - ?  ");			
							sql.append("      , UPDATE_DB_TIME   =  SYSDATETIME  ");
							sql.append("  WHERE COMP_CODE   = 'MASTER' ");
							sql.append("    AND budg_yyyymm = ? ");
							sql.append("    AND dept_code = ? ");
							sql.append("    AND acct_no = ? ");
							sql.append("    AND budg_code = ? ");
							
							pstmt = conn.prepareStatement(sql.toString());
							pstmt.setDouble(1, from_amt_i ); 
							pstmt.setString(2,  ac_yyyymm); 
							pstmt.setString(3,  dept_code); 
							pstmt.setString(4,  acct_no ); 
							pstmt.setString(5,  from_budg_code ); 
							
							pstmt.executeUpdate();            	  
	
							pstmt.close();											
							
							sql.setLength(0);
							sql.append("UPDATE AFB510T ");
							sql.append("   SET  order_amt   =  order_amt + ?  ");			
							sql.append("      , UPDATE_DB_TIME   =  SYSDATETIME  ");
							sql.append("  WHERE COMP_CODE   = 'MASTER' ");
							sql.append("    AND budg_yyyymm = ? ");
							sql.append("    AND dept_code = ? ");
							sql.append("    AND acct_no = ? ");
							sql.append("    AND budg_code = ? ");
							
							pstmt = conn.prepareStatement(sql.toString());
							pstmt.setDouble(1, to_amt_i ); 
							pstmt.setString(2,  ac_yyyymm); 
							pstmt.setString(3,  dept_code); 
							pstmt.setString(4,  acct_no ); 
							pstmt.setString(5,  to_budg_code ); 
							
							pstmt.executeUpdate();            	  
	
							pstmt.close();								
							
						}
					}	
					
					rs.close();

					
				}

			}
			

			else if (GUBUN.equals("4")){		//ELSE IF  @GUBUN = '4'	-- 세목조정
				if (STATUS.equals("1") || STATUS.equals("3") ){
					//SP 실행
					//EXEC UNILITE.SP_APP_DRAFT_DRAFT @GWIF_ID, @SP_CALL, @ERROR_DESC OUTPUT

					sql.setLength(0);
					sql.append("UPDATE AFB520T ");
					sql.append("   SET  AP_STS   =  ?  ");
					sql.append("      , UPDATE_DB_USER   =  ?  ");
					//sql.append("      , IF_DOC_NO   =  ''  ");					
					sql.append("      , UPDATE_DB_TIME   =  SYSDATETIME  ");
					sql.append("  WHERE COMP_CODE   = 'MASTER' ");
					sql.append("    AND DOC_NO = ? ");
					
					
					pstmt = conn.prepareStatement(sql.toString());
					pstmt.setString(1, STATUS ); 
					pstmt.setString(2,  USER_ID); 
					pstmt.setString(3, GWIF_ID ); 

					pstmt.executeUpdate();            	  

					pstmt.close();	
					
					
					
				}else if (STATUS.equals("5")){
				//SP 실행
				//EXEC UNILITE.SP_APP_STOP_DRAFT @GWIF_ID, @SP_CALL, @ERROR_DESC OUTPUT

					sql.setLength(0);
					sql.append("UPDATE AFB520T ");
					sql.append("   SET  AP_STS   =  ?  ");
					sql.append("      , UPDATE_DB_USER   =  ?  ");
					//sql.append("      , IF_DOC_NO   =  ''  ");					
					sql.append("      , UPDATE_DB_TIME   =  SYSDATETIME  ");
					sql.append("  WHERE COMP_CODE   = 'MASTER' ");
					sql.append("    AND DOC_NO = ? ");
					
					
					pstmt = conn.prepareStatement(sql.toString());
					pstmt.setString(1, STATUS ); 
					pstmt.setString(2,  USER_ID); 
					pstmt.setString(3, GWIF_ID ); 

					pstmt.executeUpdate();            	  

					pstmt.close();						
					
					

				}else if (STATUS.equals("9")){
				//SP 실행
				//EXEC UNILITE.SP_APP_END_DRAFT @GWIF_ID, @SP_CALL, @ERROR_DESC OUTPUT
					
					sql.setLength(0);
					sql.append("UPDATE AFB520T ");
					sql.append("   SET  AP_STS   =  ?  ");
					sql.append("      , AP_USER_ID   =  ?  ");
					sql.append("      , AP_DATE   = TO_CHAR(SYSDATE, 'YYYYMMDD')  ");	
					sql.append("      , IF_DOC_NO   =  ?  ");					
					sql.append("      , UPDATE_DB_TIME   =  SYSDATETIME  ");
					sql.append("  WHERE COMP_CODE   = 'MASTER' ");
					sql.append("    AND DOC_NO = ? ");
					
					
					pstmt = conn.prepareStatement(sql.toString());
					pstmt.setString(1, STATUS ); 
					pstmt.setString(2,  USER_ID); 
					pstmt.setString(3,  DOC_NO);					
					pstmt.setString(4, GWIF_ID ); 

					pstmt.executeUpdate();            	  

					pstmt.close();								
					
					
					
				}

			}
			
			else if (GUBUN.equals("5")){		//ELSE IF  @GUBUN = '5'	-- 이체결의
				if (STATUS.equals("1") || STATUS.equals("3") ){
					//SP 실행
					//EXEC UNILITE.SP_APP_DRAFT_DRAFT @GWIF_ID, @SP_CALL, @ERROR_DESC OUTPUT
					
					sql.setLength(0);
					sql.append("UPDATE AFB740T ");
					sql.append("   SET  AP_STS   =  ?  ");
					sql.append("      , UPDATE_DB_USER   =  ?  ");
					//sql.append("      , IF_DOC_NO   =  ''  ");					
					sql.append("      , UPDATE_DB_TIME   =  SYSDATETIME  ");
					sql.append("  WHERE COMP_CODE   = 'MASTER' ");
					sql.append("    AND DOC_NO = ? ");
					
					
					pstmt = conn.prepareStatement(sql.toString());
					pstmt.setString(1, STATUS ); 
					pstmt.setString(2,  USER_ID); 
					pstmt.setString(3, GWIF_ID ); 

					pstmt.executeUpdate();            	  

					pstmt.close();						
					
					

				}else if (STATUS.equals("5")){
				//SP 실행
				//EXEC UNILITE.SP_APP_STOP_DRAFT @GWIF_ID, @SP_CALL, @ERROR_DESC OUTPUT
					sql.setLength(0);
					sql.append("UPDATE AFB740T ");
					sql.append("   SET  AP_STS   =  ?  ");
					sql.append("      , UPDATE_DB_USER   =  ?  ");
					//sql.append("      , IF_DOC_NO   =  ''  ");					
					sql.append("      , UPDATE_DB_TIME   =  SYSDATETIME  ");
					sql.append("  WHERE COMP_CODE   = 'MASTER' ");
					sql.append("    AND DOC_NO = ? ");
					
					
					pstmt = conn.prepareStatement(sql.toString());
					pstmt.setString(1, STATUS ); 
					pstmt.setString(2,  USER_ID); 
					pstmt.setString(3, GWIF_ID ); 

					pstmt.executeUpdate();            	  

					pstmt.close();			
					
					

				}else if (STATUS.equals("9")){
				//SP 실행
				//EXEC UNILITE.SP_APP_END_DRAFT @GWIF_ID, @SP_CALL, @ERROR_DESC OUTPUT
					
					sql.setLength(0);
					sql.append("UPDATE AFB740T ");
					sql.append("   SET  AP_STS   =  ?  ");
					sql.append("      , AP_USER_ID   =  ?  ");
					sql.append("      , AP_DATE   = TO_CHAR(SYSDATE, 'YYYYMMDD')  ");	
					sql.append("      , IF_DOC_NO   =  ?  ");					
					sql.append("      , UPDATE_DB_TIME   =  SYSDATETIME  ");
					sql.append("  WHERE COMP_CODE   = 'MASTER' ");
					sql.append("    AND DOC_NO = ? ");
					
					
					pstmt = conn.prepareStatement(sql.toString());
					pstmt.setString(1, STATUS ); 
					pstmt.setString(2,  USER_ID); 
					pstmt.setString(3,  DOC_NO);					
					pstmt.setString(4, GWIF_ID ); 

					pstmt.executeUpdate();            	  

					pstmt.close();							
					
					
				}

			}
			

			else if (GUBUN.equals("6")){		//ELSE IF  @GUBUN = '5'	-- 이월 불용승인 
				if (STATUS.equals("1") || STATUS.equals("3") ){
					//SP 실행
					//EXEC UNILITE.SP_APP_DRAFT_DRAFT @GWIF_ID, @SP_CALL, @ERROR_DESC OUTPUT
					
					sql.setLength(0);
					sql.append("UPDATE AFB530T ");
					sql.append("   SET  [STATUS]   =  ?  ");
					sql.append("      , UPDATE_DB_USER   =  ?  ");
					//sql.append("      , IF_DOC_NO   =  ''  ");					
					sql.append("      , UPDATE_DB_TIME   =  SYSDATETIME  ");
					sql.append("  WHERE COMP_CODE   = 'MASTER' ");
					sql.append("    AND DOC_NO = ? ");
					
					
					pstmt = conn.prepareStatement(sql.toString());
					pstmt.setString(1, STATUS ); 
					pstmt.setString(2,  USER_ID); 
					pstmt.setString(3, GWIF_ID ); 

					pstmt.executeUpdate();            	  

					pstmt.close();						
										
					

				}else if (STATUS.equals("5")){
				//SP 실행
				//EXEC UNILITE.SP_APP_STOP_DRAFT @GWIF_ID, @SP_CALL, @ERROR_DESC OUTPUT
					sql.setLength(0);
					sql.append("UPDATE AFB530T ");
					sql.append("   SET  [STATUS]   =  ?  ");
					sql.append("      , AP_USER_ID   =  ?  ");
					sql.append("      , AP_DATE   =   = TO_CHAR(SYSDATE, 'YYYYMMDD')  ");	
					//sql.append("      , IF_DOC_NO   =  ''  ");					
					sql.append("      , UPDATE_DB_TIME   =  SYSDATETIME  ");
					sql.append("  WHERE COMP_CODE   = 'MASTER' ");
					sql.append("    AND DOC_NO = ? ");
					
					
					pstmt = conn.prepareStatement(sql.toString());
					pstmt.setString(1, STATUS ); 
					pstmt.setString(2,  USER_ID); 
					pstmt.setString(3, GWIF_ID ); 

					pstmt.executeUpdate();            	  

					pstmt.close();									
					

				}else if (STATUS.equals("9")){
				//SP 실행
				//EXEC UNILITE.SP_APP_END_DRAFT @GWIF_ID, @SP_CALL, @ERROR_DESC OUTPUT
					sql.setLength(0);	
					sql.append("SELECT a.iwall_yyyymm, a.dept_code, a.acct_no, a.ac_gubun, a.budg_code, a.budg_gubun ,nvl(a.iwall_amt_i,0),  a.doc_no , a.seq ");
					sql.append("        FROM   afb530t a");
					sql.append("        WHERE  a.comp_code = 'MASTER' ");
					sql.append("          AND a.doc_no = ?  ");

					pstmt= conn.prepareStatement(sql.toString());
					pstmt.setString(1, GWIF_ID);

					rs = pstmt.executeQuery();					
										
					while(rs.next()){
						
						String iwall_yyyymm = rs.getString(1);
						String dept_code = rs.getString(2);
						String acct_no = rs.getString(3);
						String ac_gubun = rs.getString(4);
						String budg_code = rs.getString(5);
						String budg_gubun = rs.getString(6);						
						double iwall_amt_i = rs.getDouble(7);
						String doc_no = rs.getString(8);
						double seq= rs.getDouble(9);
						
						//이월
						if ( "2".equals(budg_gubun)   ){
							
							sql.setLength(0);	
							sql.append("MERGE INTO afb510t a USING ( "); 
							sql.append("          SELECT iwall_yyyymm, dept_code, acct_no,  budg_code, iwall_amt_i");
							sql.append("		    FROM afb530t  ");
							sql.append("		   WHERE doc_no = ?  ");
							sql.append("             AND seq =  ? ");  
							sql.append("		     AND  [STATUS] = '9' ");  
							sql.append("		     AND budg_gubun = '3' ");
							sql.append(") b ");
							sql.append(" ON  a.budg_yyyy = SUBSTRING(b.iwall_yyyymm	,1,4) ");								 
						    sql.append(" AND a.dept_code = b.dept_code ");
						    sql.append(" AND a.acct_no  = b.acct_no  ");
						    sql.append(" AND a.budg_code = b.budg_code ");
						    sql.append(" WHEN MATCHED THEN  ");
						    sql.append("	 	UPDATE   SET budg_iwall_i = budg_iwall_i + NVL(iwall_amt_i,0) ");
						    sql.append(" WHEN NOT MATCHED THEN   ");
						    sql.append(" 	INSERT (a.comp_code ,a.budg_yyyymm, a.dept_code , a.acct_no, a.budg_code ,a.budg_gubun ,a.budg_i , a.budg_conf_i , a.budg_conf_i , budg_conv_i , ");
						    sql.append("           a.budg_asgn_i,a.budg_supp_i,  a.budg_iwall_i, a,ex_amt_i, a.ac_amt_i , a.cal_divi, a.draft_amt, a.order_amt, a.req_amt   a.insert_db_user, a.insert_db_time ) ");
						    sql.append(" 	 VALUES('MASTER',  substring(b.iwall_yyyymm,1,4) + '01', b.dept_code, b.acct_no,  b.budg_code, '2', 0,0,0,0,0,0,b.iwall_amt_i,0,0,'2',0,0,0, 'unilate5', SYSDATE )  ");
			
						    
						    System.out.println("SQL : " + sql.toString());
						    
							pstmt = conn.prepareStatement(sql.toString());
							pstmt.setString(1, doc_no ); 
							pstmt.setDouble(2,  seq); 							

							pstmt.executeUpdate();            	  

							
							
						//불용액 이월 요청	
						}else {
							
							sql.setLength(0);	
							sql.append("MERGE INTO afb570t a USING ( "); 
							sql.append("          SELECT iwall_yyyymm, dept_code, acct_no,  budg_code, iwall_amt_i");
							sql.append("		    FROM afb530t  ");
							sql.append("		   WHERE doc_no = ?  ");
							sql.append("             AND seq =  ? ");  
							sql.append("		     AND  [STATUS] = '9' ");  
							sql.append("		     AND budg_gubun = '3' ");
							sql.append(") b ");
							sql.append(" ON  a.budg_yyyy = SUBSTRING(b.iwall_yyyymm	,1,4) ");								 
						    sql.append(" AND a.dept_code = b.dept_code ");
						    sql.append(" AND a.acct_no  = b.acct_no  ");
						    sql.append(" AND a.budg_code = b.budg_code ");
						    sql.append(" WHEN MATCHED THEN  ");
						    sql.append("	 	UPDATE   SET use_amt_i = use_amt_i + NVL(iwall_amt_i,0) ");
						    sql.append(" WHEN NOT MATCHED THEN   ");
						    sql.append(" 	INSERT (a.comp_code ,a.budg_yyyy, a.dept_code , a.acct_no, a.budg_code , a.use_amt_i , a.insert_db_user, a.insert_db_time ) ");
						    sql.append(" 	 VALUES('MASTER',  b.iwall_yyyymm, b.dept_code, b.acct_no,  b.budg_code, b.iwall_amt_i, 'unilate5', SYSDATE )  ");
			
						    System.out.println("SQL : " + sql.toString());
							pstmt = conn.prepareStatement(sql.toString());
							pstmt.setString(1, doc_no ); 
							pstmt.setDouble(2,  seq); 							

							pstmt.executeUpdate();            	  

							pstmt.close();									
							
							
						}
						
						
						
					
					}
					
					
					
				}

			} 
			
			

			if(RTN_CODE.equals("")){
				RTN_CODE = "1";
				
				
			}
			//conn.commit();


		} catch (SQLException e) { 
			System.err.println("SQLException : " + e.getMessage() + "::" + sql.toString());
		} catch (Exception e) { 
			System.err.println("Exception : " + e.getMessage() + "::" + sql.toString());
		} finally {
			if (rs != null)
				try {
					rs.close();
				} catch (SQLException e) {
					System.err.println("SQLException : " + e.getMessage() + "::" + sql.toString());
					e.printStackTrace();
				} 
			if (conn != null)
				try {
					conn.close();
				} catch (Exception e) {
					System.err.println("Exception : " + e.getMessage() + "::" + sql.toString());
					e.printStackTrace();
				}

		}
		
		System.out.println("RTN_CODE :: " + RTN_CODE);
		System.out.println("RTN_MSG :: " + RTN_MSG);
		
		
		rMap.put("RTN_CODE", RTN_CODE);
		rMap.put("RTN_MSG", RTN_MSG);
		
		System.out.println("rMap.get_RTN_CODE ::: " + rMap.get("RTN_CODE"));
		System.out.println("rMap.get_RTN_MSG ::: " + rMap.get("RTN_MSG"));
		System.out.println("=========SP_GWAPP 종료========");
		
		
	return rMap;

	}

}

