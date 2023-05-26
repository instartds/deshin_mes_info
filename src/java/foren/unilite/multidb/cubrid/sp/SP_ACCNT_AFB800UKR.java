package foren.unilite.multidb.cubrid.sp;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;


public class SP_ACCNT_AFB800UKR {
    public static void main( String[] args ) throws Exception {
        USP_ACCNT_AFB800UKR("20170623163809791029", "ko", "unilite5");
    } 
	/*
    create procedure SP_ACCNT_AFB700UKR(KEY_VALUE varchar, LANG_TYPE varchar, USER_ID varchar,RTN_IN_DRAFT_NO varchar ERROR_DESC varchar)
    as language java
           name 'SP_ACCNT.USP_ACCNT_AFB700UKR(java.lang.String, java.lang.String, java.lang.String, java.lang.String, java.lang.String)'

    질의문으로 수행 : CALL SP_ACCNT('', '', '', '', '', '')
	 */

	//	@SuppressWarnings({ "resource", "null" })
	//	public static void USP_ACCNT_AFB700UKR(String KEY_VALUE, String LANG_TYPE, String USER_ID, String RTN_IN_DRAFT_NO, String ERROR_DESC) throws Exception {
	//	public static List<Map<String, Object>> USP_ACCNT_AFB700UKR( Map param ) throws Exception {
//	@SuppressWarnings({ "resource", "unused" })
	public static String USP_ACCNT_AFB800UKR( String KEY_VALUE, String LANG_TYPE, String USER_ID ) throws Exception {
	    
	   
		//	public static Map<String, Object> USP_ACCNT_AFB700UKR( String KEY_VALUE, String LANG_TYPE, String USER_ID, String RTN_IN_DRAFT_NO, String ERROR_DESC ) throws Exception {	


		//		List<Map<String, Object>> rList = null;        
		//        Map<String, Object> rMap = null;

//		String KEY_VALUE = param.get("KEY_VALUE") == null ? "" : (String)param.get("KEY_VALUE");
//		String LANG_TYPE = param.get("LANG_TYPE") == null ? "" : (String)param.get("LANG_TYPE");
//		String USER_ID = param.get("USER_ID") == null ? "" : (String)param.get("USER_ID");
//		String RTN_IN_DRAFT_NO = "";      /* out */
		String ERROR_DESC = "";              /* out */


		//        Map<String, Object> rMap = null;    
//		Map<String, Object> rMap = new HashMap<String, Object>();


		Connection  conn = null;
		ResultSet   rs = null;
		PreparedStatement pstmt = null;


        String OPR_FLAG = "";
		String COMP_CODE = "";
		String IN_DRAFT_NO = "";
		String IN_DATE = "";
		String SLIP_DATE = "";
		String DRAFTER = "";
		String DEPT_CODE = "";
		String DIV_CODE = "";
		String ACCNT_GUBUN = "";
		double TOT_AMT_I = 0.0;
		String TITLE = "";
		String TITLE_DESC = "";
		String RETURN_REASON = "";
		String RETURN_PRSN = "";
		String RETURN_DATE = "";
		String RETURN_TIME = "";
		String STATUS = "";
		String EX_DATE = "";
		String EX_NUM = "";
		String AC_GUBUN = "";
		

        String TMP_SLIP_DATE = "";
		
		
		

        String LinkedGW = "";
        
        String BUDG_GUBUN = "";
        String GWIF_TYPE = "";
        String DateFormat = "";
        String PayCloseFg = "";
        
        
        String ExStatus = "";
        String ExDate = "";
        String ExNum = "";
        String OrgSlipDate = "";
        String OldSlipDate = "";
        
        BUDG_GUBUN = "1";           //본예산
        GWIF_TYPE  = "2" ;          //수입결의 
        
        
        int tmp800urk = 0;      // exist 처리할 임의 변수
        int tmp_rowcnt = 0;     //rowcount 체크
/*		
//////////////////////////////////////////////////	
		//변수선언1
		String OPR_FLAG = "";
		String COMP_CODE = "";
		String IN_DRAFT_NO = "";
		String IN_DATE = "";
		String SLIP_DATE = "";

		String DRAFTER = "";
//		String PAY_USER = "";
		String DEPT_CODE = "";
		String DIV_CODE = "";
		String BUDG_GUBUN = "";

//		String ACCNT_GUBUN = "";
		double TOT_AMT_I = 0.0;
		String TITLE = "";
		String TITLE_DESC = "";
//		String DRAFT_NO = "";

//		String PAY_DTL_NO = "";
//		String RETURN_REASON = "";
//		String RETURN_PRSN = "";
//		String RETURN_DATE = "";
//		String RETURN_TIME = "";

		String STATUS = "";
		String EX_DATE = "";
//		String RETURN_CODE = "";
//		String PASSWORD = "";
		String REF_CODE6 = "";

		// 변수 추가 선언 
		String AC_GUBUN = "";		
		String ACCT_NO = "";		
		String AC_TYPE = "";		
//		String NEXT_GUBUN = "";		
		String CONTRACT_GUBUN = "";				

		//변수선언2      
		int SEQ = 0;
		String BUDG_CODE = "";

		String ACCNT = "";
//		String PJT_CODE = "";
//		String BIZ_REMARK = "";
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
//		String CHECK_PASSWORD = "";

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


		GWIF_TYPE  = "1" ;

		int tmp800urk = 0;		// exist 처리할 임의 변수
		int tmp_rowcnt = 0;		//rowcount 체크

////////////////////////////////////////////////////////////////////
*/		
		try {

			Class.forName("cubrid.jdbc.driver.CUBRIDDriver");
						conn = DriverManager.getConnection("jdbc:default:connection");
//			conn = DriverManager.getConnection("jdbc:CUBRID:192.168.1.220:33000:OmegaPlus:::?charset=UTF-8","unilite","UNILITE");

			conn.setAutoCommit(false);



			//-- 1. 수입결의마스터 ----------
			StringBuffer sql = new StringBuffer();
			

            sql.append("SELECT OPR_FLAG, ");
    		sql.append("       COMP_CODE, ");    
    		sql.append("       IN_DRAFT_NO, ");  
    		sql.append("       IN_DATE, ");      
    		sql.append("       SLIP_DATE, ");    
    		sql.append("       DRAFTER, ");      
    		sql.append("       DEPT_CODE, ");    
    		sql.append("       DIV_CODE, ");     
    		sql.append("       ACCNT_GUBUN, ");  
    		sql.append("       TOT_AMT_I, ");
    		sql.append("       TITLE, ");        
    		sql.append("       TITLE_DESC, ");   
    		sql.append("       RETURN_REASON, ");
    		sql.append("       RETURN_PRSN, ");  
    		sql.append("       RETURN_DATE, ");  
    		sql.append("       RETURN_TIME, ");  
    		sql.append("       STATUS, ");       
    		sql.append("       EX_DATE, ");      
    		sql.append("       EX_NUM, ");       
    		sql.append("       AC_GUBUN ");     
            sql.append("FROM   L_AFB800T ");
            sql.append("WHERE  KEY_VALUE = ? ");
	
			pstmt = conn.prepareStatement(sql.toString());          
			pstmt.setString(1, KEY_VALUE);
			rs = pstmt.executeQuery();

			while(rs.next()){
			    OPR_FLAG	     = rs.getString(1);     
			    COMP_CODE	     = rs.getString(2);    
			    IN_DRAFT_NO	     = rs.getString(3);  
			    IN_DATE	         = rs.getString(4);      
			    SLIP_DATE	     = rs.getString(5);    
			    DRAFTER	         = rs.getString(6);      
			    DEPT_CODE	     = rs.getString(7);    
			    DIV_CODE	     = rs.getString(8);     
			    ACCNT_GUBUN	     = rs.getString(9);  
			    TOT_AMT_I	     = rs.getDouble(10);    
			    TITLE	         = rs.getString(11);        
			    TITLE_DESC	     = rs.getString(12);   
			    RETURN_REASON	 = rs.getString(13);
			    RETURN_PRSN	     = rs.getString(14);  
			    RETURN_DATE	     = rs.getString(15);  
			    RETURN_TIME	     = rs.getString(16);  
			    STATUS	         = rs.getString(17);       
			    EX_DATE	         = rs.getString(18);      
			    EX_NUM	         = rs.getString(19);       
			    AC_GUBUN	     = rs.getString(20);     
			    
			}

			rs.close();
			pstmt.close();

			sql.setLength(0);
			sql.append("SELECT  DECODE(SUBSTR(?, 5,2) , '01', A.acc_mm01, '02', A.acc_mm02, '03', A.acc_mm03, '04', A.acc_mm04, "); 
			sql.append("        '05', A.acc_mm05, '06', A.acc_mm06, '07', A.acc_mm07, '08', A.acc_mm08, ");   
			sql.append("        '09', A.acc_mm09, '10', A.acc_mm10, '11', A.acc_mm11, '12', A.acc_mm12, '13',   A.acc_mm13 ) CLOSE_YN ");                                                                                             
			sql.append("  FROM afb910T A ");
			sql.append(" WHERE A.ac_yyyy = ? ");
			sql.append("  AND A.dept_code = ? ");



			pstmt= conn.prepareStatement(sql.toString());
			pstmt.setString(1, SLIP_DATE);
			pstmt.setString(2, SLIP_DATE.substring(0,4));
			pstmt.setString(3, DEPT_CODE);

			rs = pstmt.executeQuery();

			while(rs.next()){
				PayCloseFg = rs.getString(1);
			}
			rs.close();
			pstmt.close();

			System.out.println("PayCloseFg : " + PayCloseFg );

			if  ( PayCloseFg == null || PayCloseFg.equals("") ) {
				PayCloseFg = "N";

			}

			/*	//IF ( @@ROWCOUNT = 0 )
			sql.setLength(0);
			sql.append("SELECT count(*) ");
			sql.append("FROM   afb010t  ");
			sql.append("WHERE  comp_code = ? ");
			sql.append("       AND close_date = ? ");

			pstmt= conn.prepareStatement(sql.toString());
			pstmt.setString(1, COMP_CODE);
			pstmt.setString(2, SLIP_DATE);

			rs = pstmt.executeQuery();

			while(rs.next()){
				tmp_rowcnt= 0; //rowcount 초기화
				tmp_rowcnt = rs.getInt(1);

			}
			rs.close();
			pstmt.close();
			 */

			/*			if (tmp_rowcnt ==0){
				ERROR_DESC	= "55354;";
				//-- 기초등록-예산마감등록 메뉴에서 예산마감정보를 먼저 등록하십시오.

				rMap.put("RTN_IN_DRAFT_NO", IN_DRAFT_NO);
				rMap.put("ERROR_DESC", ERROR_DESC);


				System.out.println("에러코드 : " + IN_DRAFT_NO);
				System.out.println("에러상세 : " +ERROR_DESC);

				return rMap;
			}

			 */
			if ( PayCloseFg.equals("Y")){
				//-- 해당년도의 수입결의업무가 마감되었으므로 입력, 수정, 삭제가 불가합니다.
				sql.setLength(0);
				sql.append("SELECT '55531;' + Fngettxt('A0273') + ' : ' ");
				sql.append("       + To_char(Cast(? AS DATETIME), 'YYYY.MM.DD')");

				pstmt= conn.prepareStatement(sql.toString());
				pstmt.setString(1, SLIP_DATE);

				rs = pstmt.executeQuery();

				while(rs.next()){
					ERROR_DESC = rs.getString(1);

				}
				rs.close();
				pstmt.close();

//				rMap.put("RTN_IN_DRAFT_NO", IN_DRAFT_NO);
//				rMap.put("ERROR_DESC", ERROR_DESC);


				System.out.println("수입결의번호 : " + IN_DRAFT_NO);
				System.out.println("에러상세 : " +ERROR_DESC);

                return IN_DRAFT_NO + "|" + ERROR_DESC;

			}


			//-- 수입결의번호의 전표일자를 변수에 담음. 일자 수정시 AFB510T에 UPDATE하는 로직에서 일자를 사용함    
			System.out.println("OPR_FLAG : " +OPR_FLAG);
			if (!OPR_FLAG.equals("N")) {

				sql.setLength(0);
				sql.append("SELECT * ");
				sql.append("FROM   (SELECT slip_date ");
				sql.append("        FROM   afb800t ");
				sql.append("        WHERE  comp_code = ? ");
				sql.append("               AND in_draft_no = ? ) TOPT ");
				sql.append("WHERE  rownum = 1");


				pstmt= conn.prepareStatement(sql.toString());
				pstmt.setString(1, COMP_CODE);
				pstmt.setString(2, IN_DRAFT_NO);

				rs = pstmt.executeQuery();

				while(rs.next()){
					TMP_SLIP_DATE = rs.getString(1);

				}
				rs.close();
				pstmt.close();

				if  ( TMP_SLIP_DATE == null || TMP_SLIP_DATE.equals("") ) {
					OldSlipDate = SLIP_DATE;

				}else {
					OldSlipDate = TMP_SLIP_DATE;

				}

			}

			System.out.println("OPR_FLAG : " +OPR_FLAG);
			//-- 결재상태/기표여부 체크
			if (!OPR_FLAG.equals("N")) {

				//--  [ 날짜 포맷 유형 설정 ] --------------
				sql.setLength(0);
				sql.append("SELECT * ");
				sql.append("FROM   (SELECT M1.code_name ");
				sql.append("        FROM   bsa100t M1 ");
				sql.append("        WHERE  M1.comp_code = ? ");
				sql.append("        AND	 M1.main_code = 'B044' ");
				sql.append("        AND 	 M1.ref_code1 = 'Y') TOPT ");
				sql.append("WHERE  rownum = 1");


				pstmt= conn.prepareStatement(sql.toString());
				pstmt.setString(1, COMP_CODE);

				rs = pstmt.executeQuery();

				while(rs.next()){
					DateFormat = rs.getString(1);

				}
				rs.close();
				pstmt.close();

				if  ( DateFormat == null || DateFormat.equals("") ) {
					DateFormat = "YYYY/MM/DD";

				}

				//--  [ 그룹웨어 연동여부 설정 ] -------------
				sql.setLength(0);
				sql.append("SELECT * ");
				sql.append("FROM   (SELECT M1.REF_CODE1  ");
				sql.append("        FROM   bsa100t M1 ");
				sql.append("        WHERE  M1.comp_code = ?  ");
				sql.append("        AND 	 M1.main_code = 'A169' ");
				sql.append("        AND 	 M1.sub_code = '21') TOPT ");
				sql.append("WHERE  rownum = 1");

				pstmt= conn.prepareStatement(sql.toString());
				pstmt.setString(1, COMP_CODE);

				rs = pstmt.executeQuery();

				while(rs.next()){
					LinkedGW = rs.getString(1);

				}
				rs.close();
				pstmt.close();

				System.out.println("LinkedGW : " +LinkedGW);

				if  ( LinkedGW == null || LinkedGW.equals("") ) {
					LinkedGW = "N";

				}

				//--  [ 등록된 수정자 설정 ] ------
				sql.setLength(0);
				sql.append("SELECT 1 ");
				sql.append("FROM   bsa100t M1 ");
				sql.append("WHERE  comp_code = ?  ");
				sql.append("       AND main_code = 'A179' ");
				sql.append("       AND sub_code = ? ");

				pstmt= conn.prepareStatement(sql.toString());
				pstmt.setString(1, COMP_CODE);
				pstmt.setString(2, USER_ID);

				rs = pstmt.executeQuery();

				while(rs.next()){
					tmp800urk = 0; //exits 초기화
					tmp800urk = rs.getInt(1);

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
				sql.append("            FROM                AFB800T   A ");
				sql.append("                    LEFT  JOIN  BSA100T   M1  ON M1.COMP_CODE  = A.COMP_CODE ");
				sql.append("                                                          AND M1.MAIN_CODE  = 'S091' ");
				sql.append("                                                          AND M1.SUB_CODE   = A.COMP_CODE ");
				sql.append("                    LEFT  JOIN  T_GWIF    B   ON B.GWIF_ID     = M1.REF_CODE1 +  ?  + A.IN_DRAFT_NO ");
				sql.append("            WHERE   A.COMP_CODE     =  ?  ");
				sql.append("            AND     A.IN_DRAFT_NO  =  ?  ");


				pstmt= conn.prepareStatement(sql.toString());
				pstmt.setString(1, LinkedGW);
				pstmt.setString(2, DateFormat);
				pstmt.setString(3, GWIF_TYPE);
				pstmt.setString(4, COMP_CODE);
				pstmt.setString(5, IN_DRAFT_NO);

				rs = pstmt.executeQuery();

				while(rs.next()){
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
				sql.append("            FROM                AFB800T   A ");
				sql.append("                    LEFT  JOIN  BSA100T   M1  ON M1.COMP_CODE  = A.COMP_CODE ");
				sql.append("                                                          AND M1.MAIN_CODE  = 'S091' ");
				sql.append("                                                          AND M1.SUB_CODE   = A.COMP_CODE ");
				sql.append("                    LEFT  JOIN  T_GWIF    B   ON B.GWIF_ID     = M1.REF_CODE1 +  ?  + A.IN_DRAFT_NO ");
				sql.append("            WHERE   A.COMP_CODE     =  ?  ");
				sql.append("            AND     A.IN_DRAFT_NO  =  ?  ");
				sql.append(") TOPT WHERE ROWNUM = 1  ");

				pstmt= conn.prepareStatement(sql.toString());
				pstmt.setString(1, LinkedGW);
				pstmt.setString(2, DateFormat);
				pstmt.setString(3, GWIF_TYPE);
				pstmt.setString(4, COMP_CODE);
				pstmt.setString(5, IN_DRAFT_NO);

				rs = pstmt.executeQuery();

				while(rs.next()){
					tmp_rowcnt = 0;
					tmp_rowcnt = rs.getInt(1);

				}
				rs.close();
				pstmt.close();


				if (tmp_rowcnt == 0){
					//-- 작업할 자료가 존재하지 않습니다.
					ERROR_DESC = "54361;";

//					rMap.put("RTN_IN_DRAFT_NO", IN_DRAFT_NO);
//					rMap.put("ERROR_DESC", ERROR_DESC);

					System.out.println("수입결의번호 : " + IN_DRAFT_NO);
					System.out.println("에러상세 : " +ERROR_DESC);
					
	                return IN_DRAFT_NO + "|" + ERROR_DESC;
				}


				if (!ExStatus.equals("0")){
					//-- 전자결재가 진행중이므로 수정/삭제할 수 없습니다.
					ERROR_DESC = "90004;";

//					rMap.put("RTN_IN_DRAFT_NO", IN_DRAFT_NO);
//					rMap.put("ERROR_DESC", ERROR_DESC);

					System.out.println("수입결의번호 : " + IN_DRAFT_NO);
					System.out.println("에러상세 : " +ERROR_DESC);

	                return IN_DRAFT_NO + "|" + ERROR_DESC;

				}

				if(ExStatus.equals("5")) {
					//-- 반려 처리된 자료이므로 수정/삭제할 수 없습니다.

					/*
					ERROR_DESC = "56304;";

					rMap.put("RTN_IN_DRAFT_NO", IN_DRAFT_NO);
					rMap.put("ERROR_DESC", ERROR_DESC);

					System.out.println("에러코드 : " + IN_DRAFT_NO);
					System.out.println("에러상세 : " +ERROR_DESC);
					return rMap;
					 */
				}

			}


			//-- 1.1. 수입결의번호 생성 
			if ( IN_DRAFT_NO == null || IN_DRAFT_NO.equals("") ) {

				sql.setLength(0);
				sql.append(" SELECT '1'+ ? + ?  + TO_CHAR  (NVL(MAX(CAST (SUBSTRING(IN_DRAFT_NO, 10) AS INT)),0) +1, '0000') ");
				sql.append(" FROM AFB800T ");
				sql.append(" WHERE COMP_CODE = ? ");
				sql.append(" AND DEPT_CODE = ? ");
				sql.append(" AND SUBSTRING(IN_DATE,0,4) = ? ");
				pstmt= conn.prepareStatement(sql.toString());

				pstmt.setString(1, DEPT_CODE);
				pstmt.setString(2, IN_DATE.substring(0,4));
				pstmt.setString(3, COMP_CODE);
				pstmt.setString(4, DEPT_CODE);
				pstmt.setString(5, IN_DATE.substring(0,4));

				rs = pstmt.executeQuery();

				while(rs.next()){
					IN_DRAFT_NO = rs.getString(1);

				}
				rs.close();
				pstmt.close();


			}        

			//-- 1.2. 지급명세서 참조에 대한 처리

			//-- 1.3. 수입결의마스터 데이터반영
			if (OPR_FLAG.equals("D")){

				sql.setLength(0);
				sql.append("DELETE FROM afb800t ");
				sql.append("WHERE  comp_code = ?  ");
				sql.append("       AND in_draft_no = ? ");

				pstmt = conn.prepareStatement(sql.toString());
				pstmt.setString(1, COMP_CODE);
				pstmt.setString(2, IN_DRAFT_NO);

				pstmt.executeUpdate();            	  

				pstmt.close();

			}

			if(OPR_FLAG.equals("U")) {
				sql.setLength(0);
				sql.append("UPDATE AFB800T ");
				sql.append("   SET IN_DATE           = ? , ");
				sql.append("       SLIP_DATE         = ? , ");
				sql.append("       DRAFTER           = ? , ");
				sql.append("       DEPT_CODE         = ? , ");
				sql.append("       DIV_CODE          = ? , ");
				sql.append("       ACCNT_GUBUN       = ? , ");
				sql.append("       TOT_AMT_I         = ? , ");
				sql.append("       TITLE             = ? , ");
				sql.append("       TITLE_DESC        = ? , ");
				sql.append("       RETURN_REASON     = ? , ");
				sql.append("       RETURN_PRSN       = ? , ");
				sql.append("       RETURN_DATE       = ? , ");
				sql.append("       RETURN_TIME       = ? , ");
				sql.append("       STATUS            = ? , ");
				sql.append("       EX_DATE           = ? , ");
				sql.append("       EX_NUM            = ? , ");
				sql.append("       UPDATE_DB_USER    = ? , ");
				sql.append("       UPDATE_DB_TIME    = sysdatetime ");
				sql.append("WHERE COMP_CODE          = ?  ");
				sql.append("  AND IN_DRAFT_NO       = ? ");

				pstmt = conn.prepareStatement(sql.toString());
				pstmt.setString(1, IN_DATE);        
				pstmt.setString(2, SLIP_DATE);
				pstmt.setString(3, DRAFTER);
				pstmt.setString(4, DEPT_CODE);
				pstmt.setString(5, DIV_CODE);
				pstmt.setString(6, ACCNT_GUBUN);
				pstmt.setDouble(7, TOT_AMT_I);
				pstmt.setString(8, TITLE);
				pstmt.setString(9, TITLE_DESC);
				pstmt.setString(10, RETURN_REASON);
				pstmt.setString(11, RETURN_PRSN);
				pstmt.setString(12, RETURN_DATE);
				pstmt.setString(13, RETURN_TIME);
				pstmt.setString(14, STATUS);
				pstmt.setString(15, EX_DATE);
				pstmt.setString(16, EX_NUM);
				pstmt.setString(17, USER_ID);
				pstmt.setString(18, COMP_CODE);
				pstmt.setString(19, IN_DRAFT_NO);
				
				pstmt.executeUpdate();            	  

				pstmt.close();

			}

			if (OPR_FLAG.equals("N")) {
				sql.setLength(0);
				sql.append("INSERT INTO AFB800T ");
				sql.append("            (COMP_CODE ");  
                sql.append("			,IN_DRAFT_NO ");   
                sql.append("			,IN_DATE ");       
                sql.append("			,SLIP_DATE ");     
                sql.append("			,DRAFTER ");       
                sql.append("			,DEPT_CODE ");     
                sql.append("			,DIV_CODE ");      
                sql.append("			,TOT_AMT_I ");     
                sql.append("			,TITLE ");         
                sql.append("			,TITLE_DESC ");    
                sql.append("			,RETURN_REASON "); 
                sql.append("			,RETURN_PRSN ");   
                sql.append("			,RETURN_DATE ");   
                sql.append("			,RETURN_TIME ");   
                sql.append("			,STATUS ");        
                sql.append("			,EX_DATE ");       
                sql.append("			,EX_NUM ");        
                sql.append("			,AC_GUBUN ");      

				sql.append("            ,INSERT_DB_USER ");
				sql.append("            ,INSERT_DB_TIME ");
				sql.append("            ,UPDATE_DB_USER ");
				sql.append("            ,UPDATE_DB_TIME) ");
				sql.append("SELECT   ? ");
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
				
				
				pstmt.setString(1, COMP_CODE ); 
				pstmt.setString(2, IN_DRAFT_NO );   
				pstmt.setString(3, IN_DATE );       
				pstmt.setString(4, SLIP_DATE );     
				pstmt.setString(5, DRAFTER );       
				pstmt.setString(6, DEPT_CODE );     
				pstmt.setString(7, DIV_CODE );      
				pstmt.setDouble(8, TOT_AMT_I );     
				pstmt.setString(9, TITLE );         
				pstmt.setString(10, TITLE_DESC );    
				pstmt.setString(11, RETURN_REASON ); 
				pstmt.setString(12, RETURN_PRSN );   
				pstmt.setString(13, RETURN_DATE );   
				pstmt.setString(14, RETURN_TIME );   
				pstmt.setString(15, STATUS );        
				pstmt.setString(16, EX_DATE );       
				pstmt.setString(17, EX_NUM );        
				pstmt.setString(18, AC_GUBUN );      

                pstmt.setString(19, USER_ID ); 
                pstmt.setString(20, USER_ID );
				
                
				pstmt.executeUpdate();            	  

				pstmt.close();

			}
			
		
			
			
			
			
			
			
			
			
			//-- 2. 수입결의디테일 데이터반영

			ResultSet   rs2 = null;
			PreparedStatement pstmt2 = null;				
			StringBuffer sql2 = new StringBuffer();

			sql2.setLength(0);
			sql2.append("SELECT  A.OPR_FLAG        ");
            sql2.append("       ,A.COMP_CODE       ");
            sql2.append("       ,A.SEQ             ");
            sql2.append("       ,A.BUDG_CODE       ");
            sql2.append("       ,A.BILL_DATE       ");
            sql2.append("       ,A.BILL_REMARK     ");
            sql2.append("       ,A.CUSTOM_CODE     ");
            sql2.append("       ,A.IN_AMT_I        ");
            sql2.append("       ,A.INOUT_DATE      ");
            sql2.append("       ,A.REMARK          ");
            sql2.append("       ,A.DEPT_CODE       ");
            sql2.append("       ,B.TREE_NAME AS DEPT_NAME       ");
            sql2.append("       ,A.DIV_CODE        ");
            sql2.append("       ,A.ACCT_NO         ");
            sql2.append("       ,A.BANK_NUM        ");
            
            sql2.append("FROM   L_AFB810T A ");
            sql2.append("LEFT JOIN BSA210T B ON B.COMP_CODE = A.COMP_CODE ");
            sql2.append("                   AND B.TREE_CODE = A.DEPT_CODE ");
            sql2.append("WHERE  A.KEY_VALUE = ? ");
			

			pstmt2 = conn.prepareStatement(sql2.toString());   
			pstmt2.setString(1, KEY_VALUE);

			rs2 = pstmt2.executeQuery();


			String cur_OPR_FLAG     = ""; 
			String cur_COMP_CODE    = ""; 
			   int cur_SEQ          = 0; 
			String cur_BUDG_CODE    = ""; 
			String cur_BILL_DATE    = ""; 
			String cur_BILL_REMARK  = ""; 
			String cur_CUSTOM_CODE  = ""; 
			double cur_IN_AMT_I     = 0.0; 
			String cur_INOUT_DATE   = ""; 
			String cur_REMARK       = ""; 
			String cur_DEPT_CODE    = ""; 
			String cur_DEPT_NAME    = ""; 
			String cur_DIV_CODE     = ""; 
			String cur_ACCT_NO      = ""; 
			String cur_BANK_NUM     = ""; 

			while(rs2.next()){ 
			    
			    cur_OPR_FLAG       = rs2.getString(1);
			    cur_COMP_CODE      = rs2.getString(2);
			    cur_SEQ            = rs2.getInt(3);
			    cur_BUDG_CODE      = rs2.getString(4);
			    cur_BILL_DATE      = rs2.getString(5);
			    cur_BILL_REMARK    = rs2.getString(6);
			    cur_CUSTOM_CODE    = rs2.getString(7);
			    cur_IN_AMT_I       = rs2.getDouble(8);
			    cur_INOUT_DATE     = rs2.getString(9);
			    cur_REMARK         = rs2.getString(10);
			    cur_DEPT_CODE      = rs2.getString(11);
			    cur_DEPT_NAME      = rs2.getString(12);
			    cur_DIV_CODE       = rs2.getString(13);
			    cur_ACCT_NO        = rs2.getString(14);
			    cur_BANK_NUM       = rs2.getString(15);

				
			/*	@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@확인필요 

				if (cur_OPR_FLAG.equals("D")) {
					sql.setLength(0);
					sql.append("SELECT NVL(trans_seq, 0) ");
					sql.append("FROM   afb710t ");
					sql.append("WHERE  comp_code = ? ");
					sql.append("       AND pay_draft_no = ?  ");
					sql.append("       AND seq = ? ");

					pstmt= conn.prepareStatement(sql.toString());
					pstmt.setString(1, cur_COMP_CODE);
					pstmt.setString(2, IN_DRAFT_NO);
					pstmt.setInt(3, cur_SEQ);

					rs = pstmt.executeQuery();

					while(rs.next()){
						//--이미 참조적용된 자료입니다. 확인 후 다시 작업하십시오.
						TransSeq = rs.getInt(1);

					}
					rs.close();
					pstmt.close(); 



					if(TransSeq > 1){

						ERROR_DESC = "56306;";

						sql.setLength(0);
						sql.append("SELECT '56306;' + Fngettxt('A0304') + ' : ' ");
						sql.append("       + ?  + Fngettxt('A0031') + ' : ' ");
						sql.append("       + Cast( ? AS VARCHAR) + Fngettxt('A0096') ");
						sql.append("       + ' : ' + Cast(?  AS VARCHAR)");

						pstmt= conn.prepareStatement(sql.toString());
						pstmt.setString(1, IN_DRAFT_NO);
						pstmt.setInt(2, cur_SEQ);
						pstmt.setInt(3, TransSeq);

						rs = pstmt.executeQuery();

						while(rs.next()){
							//  -- 이체가 된 건은 수정하거나 삭제할 수 없습니다.
							ERROR_DESC = rs.getString(1);

						}
						rs.close();
						pstmt.close(); 

						rMap.put("RTN_IN_DRAFT_NO", IN_DRAFT_NO);
						rMap.put("ERROR_DESC", ERROR_DESC);

						System.out.println("수입결의번호 : " + IN_DRAFT_NO);
						System.out.println("에러상세 : " +ERROR_DESC);
						return rMap;
					}

				}
*/
				
				//-- 2.3. 신규입력일 때, 순번채번
				if (cur_OPR_FLAG.equals("N")) {

					sql.setLength(0);
					sql.append("SELECT Nvl(Max(seq), 0) ");
					sql.append("FROM   afb810t ");
					sql.append("WHERE  comp_code = ?  ");
					sql.append("       AND in_draft_no = ? ");

					pstmt= conn.prepareStatement(sql.toString());
					pstmt.setString(1, cur_COMP_CODE);
					pstmt.setString(2, IN_DRAFT_NO);

					rs = pstmt.executeQuery();

					while(rs.next()){
						cur_SEQ = rs.getInt(1);

					}
					rs.close();
					pstmt.close(); 

					if (cur_SEQ == 0 ){
						cur_SEQ = 1;

					}else {
						cur_SEQ = cur_SEQ + 1;
					}

				}

			

				//-- 2.7. 예산금액 반영
				int AFB800URK_CNT = 0 ;

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
				sql.append("			   AND rownum = 1 ");

				pstmt= conn.prepareStatement(sql.toString());
				pstmt.setString(1, cur_COMP_CODE);
				pstmt.setString(2, SLIP_DATE);
				pstmt.setString(3, cur_DEPT_CODE);
				pstmt.setString(4, cur_BUDG_CODE);
				pstmt.setString(5, BUDG_GUBUN);
				pstmt.setString(6, cur_ACCT_NO);


				rs = pstmt.executeQuery();

				while(rs.next()){
					AFB800URK_CNT = rs.getInt(1);

				}
				rs.close();
				pstmt.close();

				if (AFB800URK_CNT == 0) {

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
					sql.append("              LEFT( ? , 4)  + '01', ");
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
					pstmt.setString(5, BUDG_GUBUN);
					pstmt.setString(6, USER_ID);
					pstmt.setString(7, USER_ID);
					pstmt.setString(8, cur_ACCT_NO);

					pstmt.executeUpdate();            	  

					pstmt.close();

				}
 
			

			    if (!cur_OPR_FLAG.equals("N")) {
                    
                    //--  [ 수정 전, 금액 반영 ] --------
                    sql.setLength(0);
                    sql.append(" UPDATE AFB510T B, ( ");
                    sql.append("     SELECT A.IN_AMT_I, A.COMP_CODE, A.IN_DRAFT_NO, A.SEQ, A1.IN_DATE, ");
                    sql.append("            A.DEPT_CODE, A.BUDG_CODE, A.ACCT_NO ");
                    sql.append("       FROM AFB810T A ");
                    sql.append(" INNER JOIN AFB800T A1 ON A1.COMP_CODE = A.COMP_CODE ");
                    sql.append("                      AND A1.IN_DRAFT_NO = A.IN_DRAFT_NO ");
                    sql.append(" ) S ");
                    sql.append("   SET B.REQ_AMT = NVL(B.REQ_AMT, 0) - NVL(S.IN_AMT_I, 0) ");
                    sql.append("     , B.UPDATE_DB_USER = ? ");
                    sql.append("     , B.UPDATE_DB_TIME = NOW() ");
                    sql.append(" WHERE S.COMP_CODE = B.COMP_CODE ");
                    sql.append("   AND S.DEPT_CODE = B.DEPT_CODE ");
                    sql.append("   AND S.IN_DRAFT_NO = ? ");
                    sql.append("   AND S.SEQ = ? ");
                    sql.append("   AND S.BUDG_CODE = B.BUDG_CODE ");
                    sql.append("   AND B.BUDG_YYYYMM = LEFT(S.IN_DATE, 4) + '01' ");
                    sql.append("   AND '1' = B.BUDG_GUBUN ");
                    sql.append("   AND S.ACCT_NO = B.ACCT_NO ");
                    
                    System.out.println("=============--  [ 수정 전, 금액 반영() ] ----==================");
                    System.out.println(sql.toString());
                    System.out.println("=======================================================");
                    
                    pstmt = conn.prepareStatement(sql.toString());
                    pstmt.setString(1, USER_ID);
                    pstmt.setString(2, IN_DRAFT_NO);
                    pstmt.setInt(3, cur_SEQ);
                    
                    pstmt.executeUpdate();
                    
                    pstmt.close();
                    
                }
				
				
				
				
				
				//--  [ 수정 후, 금액 반영 ] ----
				if(!cur_OPR_FLAG.equals("D")){

					sql.setLength(0);
					sql.append("UPDATE afb510t ");
					sql.append("SET    req_amt = Nvl(req_amt, 0) + ? ");
                    sql.append("      , UPDATE_DB_USER = ? ");
                    sql.append("      , UPDATE_DB_TIME = NOW() ");
					sql.append("WHERE  comp_code = ? ");
					sql.append("       AND budg_yyyymm = LEFT( ? , 4)  + '01' ");
					sql.append("       AND dept_code = ? ");
					sql.append("       AND budg_code = ? ");
					sql.append("       AND budg_gubun = ? ");
					sql.append("       AND acct_no = ? ");

					System.out.println("=============--  [ 수정 후, 금액 반영() ] ----==================");
                    System.out.println(sql.toString());
                    System.out.println("=======================================================");
                    
					pstmt = conn.prepareStatement(sql.toString());
					pstmt.setDouble(1, cur_IN_AMT_I);
                    pstmt.setString(2, USER_ID);
                    
                    pstmt.setString(3, cur_COMP_CODE);
                    pstmt.setString(4, SLIP_DATE);
                    pstmt.setString(5, cur_DEPT_CODE);
                    pstmt.setString(6, cur_BUDG_CODE);
                    pstmt.setString(7, BUDG_GUBUN);
                    pstmt.setString(8, cur_ACCT_NO);
                    
					pstmt.executeUpdate();            	  

					pstmt.close();

				}

				//--2.8. 수입결의디테일 데이터반영
				if (cur_OPR_FLAG.equals("D")) {
					sql.setLength(0);
					sql.append("DELETE FROM afb810t ");
					sql.append("WHERE  comp_code =  ?  ");
					sql.append("       AND in_draft_no =  ?  ");
					sql.append("       AND seq =  ?  ");

					pstmt = conn.prepareStatement(sql.toString());
					pstmt.setString(1, cur_COMP_CODE);
					pstmt.setString(2, IN_DRAFT_NO);
					pstmt.setInt(3, cur_SEQ);          

					pstmt.executeUpdate();            	  

					pstmt.close();

				}

				if (cur_OPR_FLAG.equals("U")) {
					sql.setLength(0);
					sql.append("UPDATE AFB810T ");
					sql.append("SET    BUDG_CODE         = ?  ");
                    sql.append("     , BILL_DATE         = ?  ");
                    sql.append("     , BILL_REMARK       = ?  ");
                    sql.append("     , CUSTOM_CODE       = ?  ");
                    sql.append("     , IN_AMT_I          = ?  ");
                    sql.append("     , INOUT_DATE        = ?  ");
                    sql.append("     , REMARK            = ?  ");
                    sql.append("     , DEPT_CODE         = ?  ");
                    sql.append("     , DEPT_NAME         = ?  ");
                    sql.append("     , DIV_CODE          = ?  ");
                    sql.append("     , ACCT_NO           = ?  ");
                    sql.append("     , BANK_NUM          = ?  ");
                    sql.append("     , UPDATE_DB_USER    = ?  ");
                    sql.append("     , UPDATE_DB_TIME    = SYSDATETIME  ");
                    sql.append("WHERE COMP_CODE     = ?  ");
                    sql.append("AND IN_DRAFT_NO  = ?  ");
                    sql.append("AND SEQ          = ?  ");
					
                    pstmt = conn.prepareStatement(sql.toString());
                    pstmt.setString(1, cur_BUDG_CODE);
                    pstmt.setString(2, cur_BILL_DATE);
                    pstmt.setString(3, cur_BILL_REMARK);
                    pstmt.setString(4, cur_CUSTOM_CODE);
                    pstmt.setDouble(5, cur_IN_AMT_I);
                    pstmt.setString(6, cur_INOUT_DATE);
                    pstmt.setString(7, cur_REMARK);
                    pstmt.setString(8, cur_DEPT_CODE);
                    pstmt.setString(9, cur_DEPT_NAME);
                    pstmt.setString(10, cur_DIV_CODE);
                    pstmt.setString(11, cur_ACCT_NO);
                    pstmt.setString(12, cur_BANK_NUM);
                    pstmt.setString(13, USER_ID);  
                    

                    pstmt.setString(14, cur_COMP_CODE );
                    pstmt.setString(15, IN_DRAFT_NO );
                    pstmt.setInt(16, cur_SEQ );  
					
					
                    pstmt.executeUpdate();               

                    pstmt.close();
					
			/*		
					sql.append("SET    BUDG_CODE = ?  ");
					sql.append("       ,ACCNT = ?  ");
//					sql.append("       ,PJT_CODE = ?  ");
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
					//					sql.append("       ,IN_BANKBOOK_NUM = ? ");
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
//					sql.append("       ,DRAFT_NO = ? ");
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
					sql.append("       AND IN_DRAFT_NO = ? ");
					sql.append("       AND SEQ = ?");

					pstmt = conn.prepareStatement(sql.toString());
					pstmt.setString(1, cur_BUDG_CODE);
					pstmt.setString(2, cur_ACCNT);
//					pstmt.setString(3, cur_PJT_CODE);
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
					pstmt.setString(16, cur_CUSTOM_CODE);      //확인필
					pstmt.setString(17, cur_CUSTOM_NAME);       //확인필
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
//					pstmt.setString(37, cur_DRAFT_NO);        
					pstmt.setInt(38, cur_DRAFT_SEQ);
					pstmt.setInt(39, cur_TRANS_SEQ);
					pstmt.setString(40, USER_ID);  

					pstmt.setString(41, cur_CURR_UNIT);  
					pstmt.setDouble(42, cur_CURR_RATE);  
					pstmt.setString(43, cur_CHECK_NO);           //확인필
					pstmt.setString(44, cur_ACCT_NO);  
					pstmt.setDouble(45, cur_BUDG_AMT_I);  


					pstmt.setString(46, cur_COMP_CODE );
					pstmt.setString(47, IN_DRAFT_NO );
					pstmt.setInt(48, cur_SEQ );  

					pstmt.executeUpdate();            	  

					pstmt.close();
*/
				}


				if (cur_OPR_FLAG.equals("N")) {
					sql.setLength(0);
					sql.append("INSERT INTO AFB810T ");
					sql.append("            (COMP_CODE ");
					sql.append("            ,IN_DRAFT_NO ");
					sql.append("            ,SEQ ");
					sql.append("            ,BUDG_CODE ");  
					sql.append("            ,BILL_DATE ");     
					sql.append("            ,BILL_REMARK ");   
					sql.append("            ,CUSTOM_CODE ");   
					sql.append("            ,IN_AMT_I ");      
					sql.append("            ,INOUT_DATE ");    
					sql.append("            ,REMARK ");        
					sql.append("            ,DEPT_CODE ");     
					sql.append("            ,DEPT_NAME ");     
					sql.append("            ,DIV_CODE ");      
					sql.append("            ,ACCT_NO ");       
					sql.append("            ,BANK_NUM ");  
					
					sql.append("            ,INSERT_DB_USER ");
					sql.append("            ,INSERT_DB_TIME ");
					sql.append("            ,UPDATE_DB_USER ");
					sql.append("            ,UPDATE_DB_TIME) ");


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
					sql.append("       ,SYSDATETIME ");
					sql.append("       , ?  ");
					sql.append("       ,SYSDATETIME ");


					pstmt = conn.prepareStatement(sql.toString());
					pstmt.setString(1, cur_COMP_CODE);
                    pstmt.setString(2, IN_DRAFT_NO);
                    pstmt.setInt(3, cur_SEQ);        
                    pstmt.setString(4, cur_BUDG_CODE);  
                    pstmt.setString(5, cur_BILL_DATE);  
                    pstmt.setString(6, cur_BILL_REMARK);
                    pstmt.setString(7, cur_CUSTOM_CODE);
                    pstmt.setDouble(8, cur_IN_AMT_I);   
                    pstmt.setString(9, cur_INOUT_DATE); 
                    pstmt.setString(10, cur_REMARK);     
                    pstmt.setString(11, cur_DEPT_CODE);  
                    pstmt.setString(12, cur_DEPT_NAME);  
                    pstmt.setString(13, cur_DIV_CODE);   
                    pstmt.setString(14, cur_ACCT_NO);    
                    pstmt.setString(15, cur_BANK_NUM);   
                    
					pstmt.setString(16, USER_ID);
					pstmt.setString(17, USER_ID);


					pstmt.executeUpdate();            	  

					pstmt.close();

				}


			}

			rs2.close();
			pstmt2.close();

			
			//-- 3. 수입결의마스터 삭제 또는 수입결의디테일의 순번 재설정
			//--  [ 변수 값 할당 ] ---------
//			SEQ = 0;

			//--  [ 그룹웨어 연동여부 설정 ] ---------
			sql.setLength(0);
			sql.append("select * from ( ");
			sql.append("SELECT M1.ref_code1 ");
			sql.append("FROM   bsa100t M1 ");
			sql.append("WHERE  M1.comp_code = ? ");
			sql.append("       AND M1.main_code = 'A169' ");
			sql.append("       AND M1.sub_code = '21' ");
			sql.append(") TOPT where rownum = 1");

			pstmt= conn.prepareStatement(sql.toString());
			pstmt.setString(1, COMP_CODE);

			rs = pstmt.executeQuery();

			while(rs.next()){
				LinkedGW = rs.getString(1);

			}
			rs.close();
			pstmt.close();

			if(LinkedGW == null || LinkedGW.equals("")){
				LinkedGW = "N";

			}

			//--  [ 수입결의마스터 상태 조회 ] ----------
			sql.setLength(0);
			sql.append("SELECT CASE ");
			sql.append("       WHEN ? = 'Y' THEN Nvl(B.gw_status, '0') ");
			sql.append("       ELSE A.status ");
			sql.append("       END ");
			sql.append("FROM   afb800t A ");
			sql.append("       LEFT JOIN bsa100t M1 ");
			sql.append("              ON M1.comp_code = A.comp_code ");
			sql.append("                 AND M1.main_code = 'S091' ");
			sql.append("                 AND M1.sub_code = A.comp_code ");
			sql.append("       LEFT JOIN t_gwif B ");
			sql.append("              ON B.gwif_id = M1.ref_code1 +  ?  + A.in_draft_no ");
			sql.append("WHERE  A.comp_code =  ?  ");
			sql.append("       AND A.in_draft_no =  ? ");

			pstmt= conn.prepareStatement(sql.toString());
			pstmt.setString(1, LinkedGW );
			pstmt.setString(2, GWIF_TYPE );
			pstmt.setString(3, COMP_CODE );
			pstmt.setString(4, IN_DRAFT_NO);

			rs = pstmt.executeQuery();

			while(rs.next()){
				ExStatus = rs.getString(1);

			}
			rs.close();
			pstmt.close();

			if(ExStatus == null || ExStatus.equals("")){
				ExStatus = "0";

			}

			//--  [ 수입결의디테일 건수 조회 ] ----------------
			int RecordCount = 0;

			sql.setLength(0);
			sql.append("SELECT Count(1) ");
			sql.append("FROM   afb810t ");
			sql.append("WHERE  comp_code =  ?  ");
			sql.append("       AND in_draft_no =  ? ");

			pstmt= conn.prepareStatement(sql.toString());
			pstmt.setString(1, COMP_CODE );
			pstmt.setString(2, IN_DRAFT_NO );

			rs = pstmt.executeQuery();

			while(rs.next()){
				RecordCount = rs.getInt(1);

			}
			rs.close();
			pstmt.close();



			//--  [ 수입결의마스터 삭제 또는 수입결의디테일 순번재설성] -------
			if (RecordCount == 0 && ExStatus.equals("0") ) {

				//-- 수입결의마스터 삭제
				sql.setLength(0);
				sql.append("DELETE FROM afb800t ");
				sql.append("WHERE  comp_code =  ?  ");
				sql.append("       AND in_draft_no =  ? ");

				pstmt = conn.prepareStatement(sql.toString());
				pstmt.setString(1, COMP_CODE );
				pstmt.setString(2, IN_DRAFT_NO);

				pstmt.executeUpdate();            	  

				pstmt.close();

			}

			if (RecordCount > 0) {

				//-- 수입결의디테일 순번재설정
				for (int seq_810t = 0;  seq_810t < RecordCount;  seq_810t++){
					sql.setLength(0);
					sql.append("UPDATE afb810t ");
					sql.append("   SET seq =  ?  ");
					sql.append("WHERE  comp_code =  ?  ");
					sql.append("       AND in_draft_no =  ? ");
					sql.append("       AND ROWNUM = ? ");

					pstmt = conn.prepareStatement(sql.toString());
					pstmt.setInt(1, seq_810t );
					pstmt.setString(2, COMP_CODE);
					pstmt.setString(3, IN_DRAFT_NO );
					pstmt.setInt(4, seq_810t);

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


//		RTN_IN_DRAFT_NO = IN_DRAFT_NO ;           

//		rMap.put("RTN_IN_DRAFT_NO", IN_DRAFT_NO);
//		rMap.put("ERROR_DESC", ERROR_DESC);

		System.out.println("수입결의번호 : " + IN_DRAFT_NO);
		System.out.println("에러상세 : " +ERROR_DESC);

//		return rMap;

        return IN_DRAFT_NO + "|" + ERROR_DESC;



	}




}