package foren.unilite.multidb.cubrid.fn;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Date;

public class NboxFunction_final {


	/* ***********************************  
	함수명   : nfnCompanyIDList  
	입력인자 : 사용자ID, Comp_Code 
	반환값   : 임시테이블에 사용되는 UUID           
	 *********************************** */ 

	public static String nfnCompanyIDList(String sUserID, String sCompcode) throws Exception {
		String sRtnUUID = "";

		Connection conn = null;
		PreparedStatement  pstmt = null;
		ResultSet rs = null;

		try{
			Class.forName("cubrid.jdbc.driver.CUBRIDDriver");
			conn = DriverManager.getConnection("jdbc:default:connection");
			//			conn = DriverManager.getConnection("jdbc:CUBRID:192.168.1.220:33000:OmegaPlus:::?charSet=utf-8","unilite","UNILITE");

			StringBuffer sql = new StringBuffer();

			sql.append(" SELECT ");
			sql.append(" nfngetuniquekey() AS unique_key "); 
			sql.append(" FROM ");
			sql.append(" db_root ");
			pstmt = conn.prepareStatement(sql.toString());

			rs = pstmt.executeQuery();

			while(rs.next()){
				sRtnUUID = rs.getString(1);
			}

			rs.close();    
			pstmt.close();
			
			sql.setLength(0);
			sql.append(" INSERT INTO t_nfnCompanyIDList ");
			sql.append(" ( ");
			sql.append(" key_value ");
			sql.append(" ,companyid ");
			sql.append(" ) ");
			sql.append(" SELECT ");
			sql.append(" '").append(sRtnUUID).append("' ");
			sql.append(" ,comp_code ");
			sql.append(" FROM  ");
			sql.append(" bor100t  ");
			sql.append(" WHERE  COMP_CODE = nfnGetGroupCodeByUser('").append(sUserID).append("','").append(sCompcode).append("') ");

			pstmt = conn.prepareStatement(sql.toString());

			pstmt.executeUpdate();

			pstmt.close();

			return sRtnUUID;
			
		} catch (Exception e) {
			throw new Exception(e.getMessage());   
		} finally {
			if (rs != null) rs.close();
			if (pstmt != null) pstmt.close();
			if (conn != null) conn.close();
		}
	}


	/* ***********************************  
	함수명   : nfnDeleteTableByKeyValue  
	입력인자 : 테이블명, Key Value 
	반환값   : 임시테이블에 해당 Key Value의 값을 삭제 합니다.           
	 *********************************** */ 
	public static int nfnDeleteTableByKeyValue(String sTableName, String sKeyValue) throws Exception {
		int iRtnDelFlag = 0;

		Connection conn = null;
		PreparedStatement  pstmt = null;
		
		try{

			Class.forName("cubrid.jdbc.driver.CUBRIDDriver");
			conn = DriverManager.getConnection("jdbc:default:connection");
//			conn = DriverManager.getConnection("jdbc:CUBRID:192.168.1.220:33000:OmegaPlus:::?charSet=utf-8","unilite","UNILITE");

			StringBuffer sql = new StringBuffer();

			sql.append(" DELETE ");
			sql.append(" FROM ");
			sql.append(" ").append(sTableName).append(" ");
			sql.append(" WHERE  key_value = '").append(sKeyValue).append("' ");

			pstmt = conn.prepareStatement(sql.toString());

			pstmt.executeUpdate();

			pstmt.close();

			iRtnDelFlag = 1;

			return iRtnDelFlag;
		} catch (Exception e) {
			throw new Exception(e.getMessage());  
		} finally {
			if (pstmt != null) pstmt.close();
			if (conn != null) conn.close();
		}
	}

	/* ***********************************  
	함수명   : nfnDeptTreeData  
	입력인자 : comp_code 
	반환값   : 부서           
	 *********************************** */
	public static String nfnDeptTreeData(String sCompcode) throws Exception {
		String sRtnUUID = "";

		Connection conn = null;
		PreparedStatement  pstmt = null;
		ResultSet rs = null;

		try{

			Class.forName("cubrid.jdbc.driver.CUBRIDDriver");
			conn = DriverManager.getConnection("jdbc:default:connection");
			//			conn = DriverManager.getConnection("jdbc:CUBRID:192.168.1.220:33000:OmegaPlus:::?charSet=utf-8","unilite","UNILITE");

			StringBuffer sql = new StringBuffer();

			sql.append(" SELECT ");
			sql.append(" nfngetuniquekey() AS unique_key "); 
			sql.append(" FROM ");
			sql.append(" db_root ");

			pstmt = conn.prepareStatement(sql.toString());

			rs = pstmt.executeQuery();

			while(rs.next()){
				sRtnUUID = rs.getString(1);
			}

			rs.close();    
			pstmt.close();
			
			sql.setLength(0);
			sql.append(" INSERT INTO t_nfnDeptTreeData ");
			sql.append(" ( ");
			sql.append(" key_value ");
			sql.append(" ,id ");
			sql.append(" ,parentid ");
			sql.append(" ,comp_code ");
			sql.append(" ,div_code ");
			sql.append(" ,tree_code ");
			sql.append(" ,TEXT ");
			sql.append(" ) ");
			sql.append(" SELECT ");
			sql.append(" '").append(sRtnUUID).append("' ");
			sql.append(" ,id ");
			sql.append(" ,parentid "); 
			sql.append(" ,comp_code ");
			sql.append(" ,div_code ");    
			sql.append(" ,tree_code ");                                      
			sql.append(" ,tree_name AS TEXT ");
			sql.append(" FROM  ");
			sql.append(" ( ");
			sql.append(" SELECT ");
			sql.append(" d.tree_level AS id ");
			sql.append(" ,CASE WHEN LENGTH(tree_level) = 1 THEN 'root' ELSE SUBSTRING(tree_level, 1, LENGTH(tree_level) - 3) END AS parentid ");
			sql.append(" ,d.comp_code ");
			//sql.append(" ,CASE WHEN LENGTH(tree_level) = 1 THEN d.comp_code ELSE d.type_level END AS div_code ");
			sql.append(" ,d.type_level AS div_code ");
			sql.append(" ,d.tree_code ");
			sql.append(" ,d.tree_name ");
			sql.append(" FROM   bsa210t d ");
			sql.append(" INNER JOIN bor100t c ON d.comp_code = c.comp_code ");
			sql.append(" WHERE  d.comp_code LIKE '").append(sCompcode).append("' ");
			sql.append(" AND NVL(d.use_yn, 'N') = 'Y' ");
			sql.append(" ) s ");
			sql.append(" ORDER BY s.id ");

			pstmt = conn.prepareStatement(sql.toString());

			pstmt.executeUpdate();

			pstmt.close();

			return sRtnUUID;
			
		} catch (Exception e) {
			throw new Exception(e.getMessage());  
		} finally {
			if (rs != null) rs.close();
			if (pstmt != null) pstmt.close();
			if (conn != null) conn.close();
		}
	}

	/* ***********************************  
		함수명   : nfnDocRcvUserByDeptType  
		입력인자 : Comp_Code, 부서ID 
		반환값   : 해당부서원 전원          
	 *********************************** */ 
	public static String nfnDocRcvUserByDeptType(String sCompCode, String sId) throws Exception  {
		String sRtnUUID = "";

		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try{
			String sKeyValue1 = "";
			int iLvl = 0;
			boolean bFlag = true;
			int iCnt = 0;

			Class.forName("cubrid.jdbc.driver.CUBRIDDriver");
			conn = DriverManager.getConnection("jdbc:default:connection");
			//			conn = DriverManager.getConnection("jdbc:CUBRID:192.168.1.220:33000:OmegaPlus:::?charSet=utf-8","unilite","UNILITE");

			StringBuffer sql = new StringBuffer();

			sql.append(" SELECT ");
			sql.append(" nfnDeptTreeData('").append(sCompCode).append("') "); 
			sql.append(" FROM ");
			sql.append(" db_root ");

			pstmt = conn.prepareStatement(sql.toString());

			rs = pstmt.executeQuery();

			while(rs.next()){
				sKeyValue1 = rs.getString(1);
			}
		
			rs.close();    
			pstmt.close();
			
			sql.setLength(0);
			sql.append(" SELECT ");
			sql.append(" nfngetuniquekey() AS unique_key "); 
			sql.append(" FROM ");
			sql.append(" db_root ");

			pstmt = conn.prepareStatement(sql.toString());

			rs = pstmt.executeQuery();

			while(rs.next()){
				sRtnUUID = rs.getString(1);
			}

			rs.close();    
			pstmt.close();
			
			if (sRtnUUID == null || sRtnUUID.equals(""))
				return "";

			iLvl = iLvl + 1;

			sql.setLength(0);
			sql.append(" INSERT INTO t_nfndocrcvuserbydepttype ");
			sql.append(" ( ");
			sql.append(" key_value ");
			sql.append(" ,id ");
			sql.append(" ,parentid ");
			sql.append(" ,tree_code ");
			sql.append(" ,text ");
			sql.append(" ,depttype ");
			sql.append(" ,dept_code ");
			sql.append(" ,sort ");
			sql.append(" ,lvl ");
			sql.append(" ) ");
			sql.append(" SELECT ");
			sql.append(" '").append(sRtnUUID).append("' ");
			sql.append(" ,id ");
			sql.append(" ,parentid ");
			sql.append(" ,tree_code ");
			sql.append(" ,text ");
			sql.append(" ,'D' AS depttype ");
			sql.append(" ,tree_code AS dept_code ");
			sql.append(" ,CAST(id AS varchar) AS sort ");
			sql.append(" ,").append(String.valueOf(iLvl)).append(" AS lvl ");
			sql.append(" FROM ");
			sql.append(" t_nfndepttreedata ");
			sql.append(" WHERE  ");
			sql.append(" key_value = '").append(sKeyValue1).append("' ");
			sql.append(" and id =  '").append(sId).append("' "); 

			pstmt = conn.prepareStatement(sql.toString());

			pstmt.executeUpdate();

			pstmt.close();

			while(bFlag){

				iCnt = 0;

				if (iLvl > 15)
					break;

				sql.setLength(0);
				sql.append(" SELECT ");
				sql.append(" COUNT(*) ");
				sql.append(" FROM ");
				sql.append(" t_nfndocrcvuserbydepttype ");
				sql.append(" WHERE ");
				sql.append(" key_value = '").append(sRtnUUID).append("' ");
				sql.append(" AND lvl = ").append(String.valueOf(iLvl));	

				pstmt = conn.prepareStatement(sql.toString());

				rs = pstmt.executeQuery();

				while(rs.next()){
					iCnt = rs.getInt(1);
				}

				rs.close();    
				pstmt.close();

				if (iCnt > 0){
					bFlag = true;
				}
				else{
					bFlag = false;
					break;
				}

				if (bFlag){

					sql.setLength(0);
					sql.append(" INSERT INTO t_nfndocrcvuserbydepttype ");
					sql.append(" ( ");
					sql.append(" key_value ");
					sql.append(" ,id ");
					sql.append(" ,parentid ");
					sql.append(" ,tree_code ");
					sql.append(" ,text ");
					sql.append(" ,depttype ");
					sql.append(" ,dept_code ");
					sql.append(" ,sort ");
					sql.append(" ,lvl ");
					sql.append(" ) ");
					sql.append(" SELECT ");
					sql.append(" '").append(sRtnUUID).append("' ");
					sql.append(" ,a.id ");
					sql.append(" ,a.parentId ");
					sql.append(" ,a.tree_code ");
					sql.append(" ,a.text ");
					sql.append(" ,a.depttype ");
					sql.append(" ,a.dept_code ");
					sql.append(" ,CAST(a.sort AS varchar) AS sort ");
					sql.append(" ,(b.lvl + 1) AS lvl ");
					sql.append(" FROM ");
					sql.append(" ( ");
					sql.append(" SELECT ");
					sql.append(" id ");
					sql.append(" ,parentId ");
					sql.append(" ,tree_code ");
					sql.append(" ,text ");
					sql.append(" ,'D' AS depttype ");
					sql.append(" ,tree_code AS dept_code ");
					sql.append(" ,id AS sort ");
					sql.append(" FROM ");
					sql.append(" t_nfndepttreedata ");
					sql.append(" WHERE ");
					sql.append(" key_value = '").append(sKeyValue1).append("' ");
					sql.append(" UNION ALL ");
					sql.append(" SELECT ");
					sql.append(" m.user_id AS id ");
					sql.append(" ,n.id AS parentid ");
					sql.append(" ,user_id AS tree_code ");
					sql.append(" ,user_name AS text ");
					sql.append(" ,'P' AS depttype ");
					sql.append(" ,m.dept_code AS dept_code ");
					sql.append(" ,n.id  + '000' + CAST(ROW_NUMBER() OVER( PARTITION BY m.dept_code ORDER BY m.post_code) AS varchar) AS sort ");
					sql.append(" FROM ");
					sql.append(" bsa300t m ");
					sql.append(" INNER JOIN t_nfndepttreedata n ON m.dept_code = n.tree_code AND n.key_value = '").append(sKeyValue1).append("' ");
					sql.append(" WHERE");
					sql.append(" m.comp_code = '").append(sCompCode).append("' ");
					sql.append(" AND m.lock_yn = 'N' ) a ");
					sql.append(" INNER JOIN t_nfndocrcvuserbydepttype b ON a.parentId = b.id AND b.lvl = ").append(String.valueOf(iLvl)).append(" AND b.key_value = '").append(sRtnUUID).append("' ");

					pstmt = conn.prepareStatement(sql.toString());

					pstmt.executeUpdate();

					pstmt.close();

				}

				iLvl = iLvl + 1;
			}

			sql.setLength(0);
			sql.append(" SELECT ");
			sql.append(" nfnDeleteTableByKeyValue('t_nfndepttreedata', '").append(sKeyValue1).append("') ");
			sql.append(" FROM db_root ");

			pstmt = conn.prepareStatement(sql.toString());

			pstmt.executeQuery();

			pstmt.close();
			
			return sRtnUUID;
			
		} catch (Exception e) {
			throw new Exception(e.getMessage());
		} finally {
			if (rs != null) rs.close();
			if (pstmt != null) pstmt.close();
			if (conn != null) conn.close();
		}
	}

	/* ***********************************  
	함수명   : nfnGetApprovalCommentCount  
	입력인자 : 문서ID 
	반환값   : 해당문서의 댓글 갯수           
	 *********************************** */ 	
	public static int nfnGetApprovalCommentCount(String sDocumentID) throws Exception {
		int iRtn = 0;

		Connection conn = null;
		PreparedStatement  pstmt = null;
		ResultSet rs = null;

		try{
			Class.forName("cubrid.jdbc.driver.CUBRIDDriver");
			conn = DriverManager.getConnection("jdbc:default:connection");
//			conn = DriverManager.getConnection("jdbc:CUBRID:192.168.1.220:33000:OmegaPlus:::?charSet=utf-8","unilite","UNILITE");

			StringBuffer sql = new StringBuffer();

			sql.append(" SELECT ");
			sql.append(" COUNT(*) ");
			sql.append(" FROM ");
			sql.append(" tbApprovalDocComment ");
			sql.append(" WHERE ");
			sql.append(" DocumentID = '").append(sDocumentID).append("' ");

			pstmt = conn.prepareStatement(sql.toString());

			rs = pstmt.executeQuery();

			while(rs.next()){
				iRtn = rs.getInt(1);
			}

			rs.close();
			pstmt.close();

			return iRtn;
			
		} catch (Exception e) {
			throw new Exception(e.getMessage());
		} finally {
			if (rs != null) rs.close();
			if (pstmt != null) pstmt.close();
			if (conn != null) conn.close();
		}
	}


	/** 함수명 : nfnGetApprovalContents
	 * @param CompanyID, DocumentID, Contents
	 * @return
	 * @throws Exception
	 */
	public static String nfnGetApprovalContents(String CompanyID, String DocumentID, String Contents) throws SQLException, Exception {
		String ReturnContents = "";
		
		Connection  conn = null;
		PreparedStatement pstmt = null;
		ResultSet   rs = null;
		
		//-- 양식별 문서 Contents  Flag
		try{
			String ContentsViewFlag = "";
			
			Class.forName("cubrid.jdbc.driver.CUBRIDDriver");
			conn = DriverManager.getConnection("jdbc:default:connection");
			//			conn = DriverManager.getConnection("jdbc:CUBRID:192.168.1.220:33000:OmegaPlus:::?charSet=utf-8","unilite","UNILITE");
			
			StringBuffer  sql = new StringBuffer();
			
			sql.setLength(0);
			sql.append("SELECT nfnGetApprovalContentsEtc( ?,  ?,  ? ) 	");
			sql.append("FROM   DB_ROOT 									");

			pstmt = conn.prepareStatement(sql.toString());
			pstmt.setString(1, CompanyID);
			pstmt.setString(2, DocumentID);
			pstmt.setString(3, Contents);

			rs = pstmt.executeQuery();

			while(rs.next()){
				ReturnContents = rs.getString(1);
			}
			
			rs.close();
			pstmt.close();

			sql.setLength(0);
			sql.append("SELECT CASE formID 														");
			sql.append("         WHEN nfnGetCommonCodeValue( ?  , 'NX04', 						");
			sql.append("              nfnGetMenuBox( ?  , '4000009')) THEN 'A' 					");
			sql.append("         ELSE 'Z' 														");
			sql.append("       END 																");
			sql.append("FROM   TBAPPROVALDOC 													");
			sql.append("WHERE  CompanyID =  ?   												");
			sql.append("       AND DocumentID =  ?  											");

			pstmt = conn.prepareStatement(sql.toString());
			pstmt.setString(1, CompanyID);
			pstmt.setString(2, CompanyID);
			pstmt.setString(3, CompanyID);
			pstmt.setString(4, DocumentID);

			rs = pstmt.executeQuery();

			while(rs.next()){
				ContentsViewFlag = rs.getString(1);
			}
			
			rs.close();
			pstmt.close();

			if (ContentsViewFlag.equals("A")){
				sql.setLength(0);
				sql.append("SELECT nfnGetApprovalContentsA( ? ,  ? ,  ?  ) 	");
				sql.append("FROM   DB_ROOT									");

				pstmt = conn.prepareStatement(sql.toString());
				pstmt.setString(1, CompanyID);
				pstmt.setString(2, DocumentID);
				pstmt.setString(3, ReturnContents);

				rs = pstmt.executeQuery();

				while(rs.next()){
					ReturnContents = rs.getString(1);
				}
				
				rs.close();
				pstmt.close();
			}

			return ReturnContents;
			
		} catch (Exception e) {
			throw new Exception(e.getMessage());
		} finally {
			if (rs != null) rs.close();
			if (pstmt != null) pstmt.close();
			if (conn != null) conn.close();
		}
	}

	/** 함수명 : nfnGetApprovalContentsA
	 * @param CompanyID, DocumentID, Contents
	 * @return
	 * @throws Exception
	 */
	public static String nfnGetApprovalContentsA(String CompanyID, String DocumentID, String Contents)  throws SQLException, Exception {	
		String ReturnContents = "";

		Connection  conn = null;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;
		ResultSet rs2 = null;
		
		try{
			String Title = "";
			double TotalAmount = 0.000;
			String LoopContents = "";
			String startMark = "";
			String endMark = "";
			String ExpenseDate = "";
			String ExpenseReason = "";
			String AcctName = "";
			double Supply = 0.000;
			double Vat = 0.000;
			String Remark = "";
			String LoopData = "";
			String LoopSummaryData = "";

			StringBuffer  sql = new StringBuffer();
			
			Class.forName("cubrid.jdbc.driver.CUBRIDDriver");
			conn = DriverManager.getConnection("jdbc:default:connection");
			//			conn = DriverManager.getConnection("jdbc:CUBRID:192.168.1.220:33000:OmegaPlus:::?charSet=utf-8","unilite","UNILITE");
			conn.setAutoCommit(false);
			
			//-- Document Data
			sql.setLength(0);
			sql.append("SELECT SUBJECT ");
			sql.append("FROM   tbapprovaldoc ");
			sql.append("WHERE  DOCUMENTID = ?  ");

			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(1, DocumentID);

			rs = pstmt.executeQuery();

			while(rs.next()){
				Title = rs.getString(1);
			}
			
			rs.close();
			pstmt.close();

			ReturnContents = Contents;
			ReturnContents = ReturnContents.replace("@TITLE", Title);

			startMark = "<tr id=\"Loop\">";
			endMark = "</tr>";

			sql.setLength(0);
			sql.append("SELECT substr( ? , POSITION( ?  IN  ? ), LENGTH( ? ))");

			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(1, ReturnContents);
			pstmt.setString(2, startMark);
			pstmt.setString(3, ReturnContents);
			pstmt.setString(4, ReturnContents);

			rs = pstmt.executeQuery();

			while(rs.next()){
				LoopContents = rs.getString(1);
			}
			
			rs.close();
			pstmt.close();

			sql.setLength(0);
			sql.append("SELECT substr( ? , 1, POSITION( ?  IN  ? ) ");
			sql.append("                                + LENGTH( ? ))");

			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(1, LoopContents);
			pstmt.setString(2, endMark);
			pstmt.setString(3, LoopContents);
			pstmt.setString(4, endMark);

			rs = pstmt.executeQuery();

			while(rs.next()){
				LoopContents = rs.getString(1);
			}
			
			rs.close();
			pstmt.close();
			
			//-- Expense Detail Data
			sql.setLength(0);
			sql.append("SELECT ExpenseDate ");
			sql.append("       ,ExpenseReason ");
			sql.append("       ,AcctName ");
			sql.append("       ,Supply ");
			sql.append("       ,Vat ");
			sql.append("       ,Remark ");
			sql.append("FROM   tbapprovalexpensedetail ");
			sql.append("WHERE  DocumentID =  ?  ");
			sql.append("ORDER  BY Seq");

			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(1, DocumentID);

			rs = pstmt.executeQuery();

			while(rs.next()){
				ExpenseDate = rs.getString(1);  
				ExpenseReason = rs.getString(2);
				AcctName = rs.getString(3);
				Supply = rs.getDouble(4);
				Vat = rs.getDouble(5);
				Remark = rs.getString(6);

				LoopData = LoopContents;

				sql.setLength(0);
				sql.append("SELECT Replace(Replace(Replace(Replace(Replace(Replace( ? , '@DATE', ");
				sql.append("          TO_CHAR(Cast( ?  AS DATETIME), 'YYYY-MM-DD')), '@REASON',  ? ), ");
				sql.append("          '@ACCT_NM',  ? ), '@SUPPLY', Replace(FORMAT( ? , 2), '.00', '') ), ");
				sql.append("          '@VAT', Replace(FORMAT( ? , 2), '.00', '')), '@ETC',  ? )");

				pstmt2 = conn.prepareStatement(sql.toString());
				
				pstmt2.setString(1, LoopData);
				pstmt2.setString(2, ExpenseDate);
				pstmt2.setString(3, ExpenseReason);
				pstmt2.setString(4, AcctName);
				pstmt2.setDouble(5, Supply);
				pstmt2.setDouble(6, Vat);
				pstmt2.setString(7, Remark);

				rs2 = pstmt2.executeQuery();

				while(rs2.next()){
					LoopData = rs2.getString(1);
				}
				
				rs2.close();
				pstmt2.close();

				if( TotalAmount == 0){
					TotalAmount = 0;
				}
				if( Supply == 0){
					Supply = 0;
				}
				if( Vat == 0){
					Vat = 0;
				}

				TotalAmount = TotalAmount + Supply + Vat;
				LoopSummaryData = LoopSummaryData + LoopData;

			}
			
			rs.close();
			pstmt.close();

			if(LoopContents ==null || LoopContents.equals("")){
				LoopContents = "";
			}

			if(LoopSummaryData ==null || LoopSummaryData.equals("")){
				LoopSummaryData = "";
			}


			ReturnContents = ReturnContents.replace(LoopContents, LoopSummaryData);

			sql.setLength(0);
			sql.append("SELECT Replace( ? , '@MONEYSUM' ");
			sql.append("        , Replace(FORMAT( ? , 2), '.00', ''))");

			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(1, ReturnContents);
			pstmt.setDouble(2, TotalAmount);

			rs = pstmt.executeQuery();

			while(rs.next()){
				ReturnContents = rs.getString(1);
			}
			
			rs.close();
			pstmt.close();
			conn.commit();
			
			return ReturnContents;
			
		} catch (Exception e) {
			conn.rollback();
			throw new Exception(e.getMessage());   
		} finally {
			if (rs != null) rs.close();
			if (rs2 != null) rs2.close();
			if (pstmt != null) pstmt.close();
			if (pstmt2 != null) pstmt2.close();
			if (conn != null) conn.close();
		}
	}

	/** 함수명 : nfnGetApprovalContentsEtc
	 * @param CompanyID, DocumentID, Contents
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unused")
	public static String nfnGetApprovalContentsEtc(String CompanyID, String DocumentID, String Contents) throws SQLException, Exception {
		String ReturnContents = "";

		Connection  conn = null;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		ResultSet   rs = null;
		ResultSet   rs2 = null;
		
		//-- Link Data
		try{
			String uDataCode = "";
			String uDataValueName = "";
			String uDataID = "";
			String uFromDate = "";
			String uToDate = "";
			String uFrDayOfWeek = "";
			String uToDayOfWeek = "";
			String uFormId = "";
			String UserDeptName = "";
			String UserName = "";
			String uDate = "";
			String nRtn = "";
			int nCnt = 0;
			int nDays = 0;
			int nDiffDays = 0;
			String DraftUserID = "";
			
			StringBuffer  sql = new StringBuffer();
			
			Class.forName("cubrid.jdbc.driver.CUBRIDDriver");
			conn = DriverManager.getConnection("jdbc:default:connection");
			//			conn = DriverManager.getConnection("jdbc:CUBRID:192.168.1.220:33000:OmegaPlus:::?charSet=utf-8","unilite","UNILITE");
			conn.setAutoCommit(false);
			
			ReturnContents = Contents;
			
			//DECLARE LinkData cursor
			sql.setLength(0);
			sql.append("SELECT code.DATACODE 							");
			sql.append("       ,NVL(DATAVALUENAME, '') 				");
			sql.append("       ,tbdata.DATAID 							");
			sql.append("FROM   tblinkdatacodebyapproval tbdata 		");
			sql.append("       INNER JOIN TBLINKDATACODE code 			");
			sql.append("               ON tbdata.DATAID = code.DATAID 	");
			sql.append("WHERE  tbdata.DOCUMENTID =  ? 					");

			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(1, DocumentID);

			rs = pstmt.executeQuery();

			while(rs.next()){
				
				uDataCode = rs.getString(1);
				uDataValueName = rs.getString(2);
				uDataID = rs.getString(3);

				//--시작일과 요일
				if (uDataCode == "@FromDate" ){
					sql.setLength(0);
					sql.append("SELECT  CASE DAYOFWEEK( ? ) 					");
					sql.append("                          WHEN '1' THEN '일요일' 	");
					sql.append("                          WHEN '2' THEN '월요일' 	");
					sql.append("                          WHEN '3' THEN '화요일' 	");
					sql.append("                          WHEN '4' THEN '수요일' 	");
					sql.append("                          WHEN '5' THEN '목요일' 	");
					sql.append("                          WHEN '6' THEN '금요일' 	");
					sql.append("                          WHEN '7' THEN '토요일' 	");
					sql.append("                          ELSE '' 				");
					sql.append("                        END 					");
					sql.append("FROM   db_root									");

					pstmt2 = conn.prepareStatement(sql.toString());
					
					pstmt2.setString(1, uDataValueName);

					rs2 = pstmt2.executeQuery();

					while(rs2.next()){
						uFrDayOfWeek = rs2.getString(1);
					}
					
					rs2.close();
					pstmt2.close();

					uDataValueName = uDataValueName + " (" + uFrDayOfWeek.substring(0, 1) + ") ";

				}
				
				//--종료일과 요일
				if (uDataCode == "@ToDate" ){
					sql.setLength(0);
					sql.append("SELECT  CASE DAYOFWEEK( ? ) 					");
					sql.append("                          WHEN '1' THEN '일요일' 	");
					sql.append("                          WHEN '2' THEN '월요일' 	");
					sql.append("                          WHEN '3' THEN '화요일' 	");
					sql.append("                          WHEN '4' THEN '수요일' 	");
					sql.append("                          WHEN '5' THEN '목요일' 	");
					sql.append("                          WHEN '6' THEN '금요일' 	");
					sql.append("                          WHEN '7' THEN '토요일' 	");
					sql.append("                          ELSE '' 				");
					sql.append("                        END 					");
					sql.append("FROM   db_root									");

					pstmt2 = conn.prepareStatement(sql.toString());
					
					pstmt2.setString(1, uDataValueName);

					rs2 = pstmt2.executeQuery();

					while(rs2.next()){
						uToDayOfWeek = rs2.getString(1);

					}
					
					rs2.close();
					pstmt2.close();

					uDataValueName = uDataValueName + " (" + uToDayOfWeek.substring(0, 1) + ") ";

				}
				ReturnContents = ReturnContents.replace(uDataCode, uDataValueName);

			}
			
			rs.close();
			pstmt.close();

			sql.setLength(0);
			sql.append("SELECT Replace(Replace(Replace(Replace(Replace( ? , '@DraftDate', 						");
			sql.append("       SUBSTR(TO_CHAR(NVL(a.DRAFTDATE, 													");
			sql.append("       SYSDATETIME), 																	");
			sql.append("       'YYYYMMDD'), 1, 																	");
			sql.append("       4) 																				");
			sql.append("       + '년' + ' ' 																		");
			sql.append("       + SUBSTR(TO_CHAR(NVL(a.DRAFTDATE, 												");
			sql.append("       SYSDATETIME 																		");
			sql.append("       ), 																				");
			sql.append("       'YYYYMMDD'), 																	");
			sql.append("       5 																				");
			sql.append("       , 2) 																			");
			sql.append("       + '월' + ' ' 																		");
			sql.append("       + SUBSTR(TO_CHAR(NVL(a.DRAFTDATE, 												");
			sql.append("       SYSDATETIME 																		");
			sql.append("       ), 																				");
			sql.append("       'YYYYMMDD'),																		");
			sql.append("       7, 2) 																			");
			sql.append("       + '일'), '@EmpName', 																");
			sql.append("       NVL(a.DRAFTUSERNAME, '')), 																");
			sql.append("       '@DeptName', NVL(a.DRAFTDEPTNAME, '')), '@RoleName', NVL(a.DRAFTUSERPOS, '')), '@HpNo', NVL(b.PHONE, '')) 	");
			sql.append("FROM   tbapprovaldoc a 																	");
			sql.append("       INNER JOIN bsa300t b 															");
			sql.append("               ON a.COMPANYID = b.COMP_CODE 											");
			sql.append("                  AND a.DRAFTUSERID = b.USER_ID 										");
			sql.append("WHERE  a.DOCUMENTID =  ?  																");

			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(1, ReturnContents);
			pstmt.setString(2, DocumentID);

			rs = pstmt.executeQuery();

			while(rs.next()){
				ReturnContents = rs.getString(1);
			}
			
			rs.close();
			pstmt.close();

			uDataCode = "";
			uDataValueName = "";
			
			sql.setLength(0);
			sql.append("SELECT  DRAFTUSERID 			");
			sql.append("FROM   tbapprovaldoc 			");
			sql.append("WHERE  COMPANYID =  ?  			");
			sql.append("       AND DOCUMENTID =  ?  	");

			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(1, CompanyID);
			pstmt.setString(2, DocumentID);

			rs = pstmt.executeQuery();

			while(rs.next()){
				DraftUserID = rs.getString(1);
			}
			
			rs.close();
			pstmt.close();

			//	-- Function Data
			//DECLARE LinkFunction cursor
			sql.setLength(0);
			sql.append("SELECT fun.FUNCTIONCODE 									");
			sql.append("FROM   tblinkfunctioncodebyform form 						");
			sql.append("       INNER JOIN tblinkfunctioncode fun 					");
			sql.append("               ON form.COMPANYID = fun.COMPANYID 			");
			sql.append("                  AND form.FUNCTIONID = fun.FUNCTIONID 	");
			sql.append("       INNER JOIN tbapprovaldoc doc 						");
			sql.append("               ON form.COMPANYID = doc.COMPANYID 			");
			sql.append("                  AND form.FORMID = doc.FORMID 			");
			sql.append("WHERE  doc.DOCUMENTID =  ?  								");

			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(1, DocumentID);

			rs = pstmt.executeQuery();

			while(rs.next()){
				uDataCode = rs.getString(1);
				uDataValueName = "";

				sql.setLength(0);
				sql.append("SELECT CASE  ?  																	");
				sql.append("         WHEN '@UserDeptName@' THEN nfnGetLinkUserDeptName( ? ,  ? ) 				");
				sql.append("         WHEN '@UserName@' THEN nfnGetLinkUserName( ?  ,  ?  ) 						");
				sql.append("         WHEN '@DocDocumentNo@' THEN nfnGetLinkDocDocumentNo( ?  ,  ?  ) 			");
				sql.append("         WHEN '@DocDraftDate@' THEN nfnGetLinkDocDraftDate( ?  ,  ?  ) 				");
				sql.append("         WHEN '@DocSubject@' THEN nfnGetLinkDocSubject( ?  ,  ?  ) 					");
				sql.append("         ELSE '' 																	");
				sql.append("       END 																			");
				sql.append("FROM   db_root																		");

				pstmt2 = conn.prepareStatement(sql.toString());
				
				pstmt2.setString(1, uDataCode);
				pstmt2.setString(2, CompanyID);
				pstmt2.setString(3, DraftUserID);
				pstmt2.setString(4, CompanyID);
				pstmt2.setString(5, DraftUserID);
				pstmt2.setString(6, CompanyID);
				pstmt2.setString(7, DraftUserID);
				pstmt2.setString(8, CompanyID);
				pstmt2.setString(9, DraftUserID);
				pstmt2.setString(10, CompanyID);
				pstmt2.setString(11, DraftUserID);

				rs2 = pstmt2.executeQuery();

				while(rs2.next()){
					uDataValueName = rs2.getString(1);
				}
				
				rs2.close();
				pstmt2.close();

				ReturnContents =  ReturnContents.replace(uDataCode, uDataValueName);

			}
			
			rs.close();
			pstmt.close();


			//DECLARE LinkSignImage cursor
			uDataCode = "";
			uDataValueName = "";

			sql.setLength(0);
			sql.append("SELECT signimg.SIGNIMAGECODE 									");
			sql.append("FROM   tblinksignimagecodebyform form 							");
			sql.append("       INNER JOIN tblinksignimagecode signimg 					");
			sql.append("               ON form.COMPANYID = signimg.COMPANYID 			");
			sql.append("                  AND form.SIGNIMAGEID = signimg.SIGNIMAGEID 	");
			sql.append("       INNER JOIN tbapprovaldoc doc 							");
			sql.append("               ON form.COMPANYID = doc.COMPANYID 				");
			sql.append("                  AND form.FORMID = doc.FORMID	 				");
			sql.append("WHERE  doc.DOCUMENTID =  ?  									");

			pstmt = conn.prepareStatement(sql.toString());
			pstmt.setString(1, DocumentID);

			rs = pstmt.executeQuery();

			while(rs.next()){
				uDataCode = rs.getString(1);
				uDataValueName = "";

				//-- @UserDeptName
				sql.setLength(0);
				sql.append("SELECT CASE @uDataCode 													");
				sql.append("         WHEN '@Sign101@' THEN nfnGetLinkDocSignImage101( ?  ,  ?  , 1) ");
				sql.append("         WHEN '@Sign102@' THEN nfnGetLinkDocSignImage102( ?  ,  ?  , 2) ");
				sql.append("         WHEN '@Sign103@' THEN nfnGetLinkDocSignImage103( ?  ,  ?  , 3) ");
				sql.append("         WHEN '@Sign104@' THEN nfnGetLinkDocSignImage104( ?  ,  ?  , 4) ");
				sql.append("         WHEN '@Sign105@' THEN nfnGetLinkDocSignImage105( ?  ,  ?  , 5) ");
				sql.append("         WHEN '@Sign106@' THEN nfnGetLinkDocSignImage106( ?  ,  ?  , 6) ");
				sql.append("         WHEN '@Sign201@' THEN nfnGetLinkDocSignImage201( ?  ,  ?  , 1) ");
				sql.append("         WHEN '@Sign202@' THEN nfnGetLinkDocSignImage202( ?  ,  ?  , 2) ");
				sql.append("         WHEN '@Sign203@' THEN nfnGetLinkDocSignImage203( ?  ,  ?  , 3) ");
				sql.append("         WHEN '@Sign204@' THEN nfnGetLinkDocSignImage204( ?  ,  ?  , 4) ");
				sql.append("         WHEN '@Sign205@' THEN nfnGetLinkDocSignImage205( ?  ,  ?  , 5) ");
				sql.append("         WHEN '@Sign206@' THEN nfnGetLinkDocSignImage206( ?  ,  ?  , 6) ");
				sql.append("         ELSE '' 														");
				sql.append("       END 																");
				sql.append("FROM   db_root															");

				pstmt2 = conn.prepareStatement(sql.toString());
				
				pstmt2.setString(1, uDataCode);
				pstmt2.setString(2, CompanyID);
				pstmt2.setString(3, DocumentID);
				pstmt2.setString(4, CompanyID);
				pstmt2.setString(5, DocumentID);
				pstmt2.setString(6, CompanyID);
				pstmt2.setString(7, DocumentID);
				pstmt2.setString(8, CompanyID);
				pstmt2.setString(9, DocumentID);
				pstmt2.setString(10, CompanyID);
				pstmt2.setString(11, DocumentID);
				pstmt2.setString(12, CompanyID);
				pstmt2.setString(13, DocumentID);
				pstmt2.setString(14, CompanyID);
				pstmt2.setString(15, DocumentID);
				pstmt2.setString(16, CompanyID);
				pstmt2.setString(17, DocumentID);
				pstmt2.setString(18, CompanyID);
				pstmt2.setString(19, DocumentID);
				pstmt2.setString(20, CompanyID);
				pstmt2.setString(21, DocumentID);
				pstmt2.setString(22, CompanyID);
				pstmt2.setString(23, DocumentID);
				pstmt2.setString(24, CompanyID);
				pstmt2.setString(25, DocumentID);

				rs2 = pstmt2.executeQuery();

				while(rs2.next()){
					uDataValueName = rs2.getString(1);
				}
				
				rs2.close();
				pstmt2.close();

				ReturnContents = ReturnContents.replace(uDataCode, uDataValueName);
			}
			
			rs.close();
			pstmt.close();

			conn.commit();

			return ReturnContents;
			
		} catch (Exception e) {
			conn.rollback();
			throw new Exception(e.getMessage());
		} finally {
			if (rs != null) rs.close();
			if (rs2 != null) rs2.close();
			if (pstmt != null) pstmt.close();
			if (pstmt2 != null) pstmt2.close();
			if (conn != null) conn.close();
		}
	}

	/* ***********************************  
	함수명   : nfnGetApprovalDocumentNo  
	입력인자 : comp_code, 문서ID,  문서카달로그ID, 언어 
	반환값   : 문서번호 생성           
	 *********************************** */ 	
	public static String nfnGetApprovalDocumentNo(String sCompcode, String sDocumentID, String sCategoryID, String sLanguage) throws Exception {
		String sRtn = "";

		Connection conn = null;
		PreparedStatement  pstmt = null;
		ResultSet rs = null;

		StringBuffer sql = new StringBuffer();
		
		try{

			String sCategoryNm = "";
			String sDraftDeptName = "";
			String sDraftUserID = "";
			Timestamp tDraftDate = null; 
			String sDivCode = "";
			String sMaxDocumentNo = "";
			String sMaxTempNo = "";
			int iLen = 0;

			Class.forName("cubrid.jdbc.driver.CUBRIDDriver");
			conn = DriverManager.getConnection("jdbc:default:connection");
//			conn = DriverManager.getConnection("jdbc:CUBRID:192.168.1.220:33000:OmegaPlus:::?charSet=utf-8","unilite","UNILITE");

			

			sql.append(" SELECT ");
			sql.append(" NVL(nfnGetCommonCodeName('").append(sCompcode).append("','NA02','").append(sCategoryID).append("','").append(sLanguage).append("'), '') ");
			sql.append(" FROM db_root ");

			pstmt = conn.prepareStatement(sql.toString());
			
			rs = pstmt.executeQuery();

			while(rs.next()){
				sCategoryNm = rs.getString(1);
			}

			rs.close();
			pstmt.close();

			sql.setLength(0);
			sql.append(" SELECT ");
			sql.append(" draftdeptname ");
			sql.append(" ,draftuserID ");
			sql.append(" ,draftdate ");
			sql.append(" FROM ");
			sql.append(" tbApprovalDoc ");
			sql.append(" WHERE ");
			sql.append(" documentid = '").append(sDocumentID).append("' ");
			sql.append(" AND companyid = '").append(sCompcode).append("' ");

			pstmt = conn.prepareStatement(sql.toString());
			
			rs = pstmt.executeQuery();

			while(rs.next()){
				sDraftDeptName = rs.getString(1);
				sDraftUserID = rs.getString(2);
				tDraftDate = rs.getTimestamp(3);
			}

			rs.close();
			pstmt.close();

			sql.setLength(0);
			sql.append(" SELECT ");
			sql.append(" div_code ");
			sql.append(" FROM ");
			sql.append(" bsa300t ");
			sql.append(" WHERE user_id = '").append(sDraftUserID).append("' ");
			sql.append(" AND comp_code = '").append(sCompcode).append("' ");

			pstmt = conn.prepareStatement(sql.toString());            
			
			rs = pstmt.executeQuery();

			while(rs.next()){
				sDivCode = rs.getString(1);
			}

			rs.close();
			pstmt.close();

			sql.setLength(0);
			sql.append(" SELECT ");
			sql.append(" MAX(RIGHT(a.documentno, 3)) ");
			sql.append(" FROM ");
			sql.append(" tbApprovalDoc a ");
			sql.append(" INNER JOIN bsa300t b ON a.draftuserid = b.user_id AND a.CompanyID = b.comp_code ");
			sql.append(" WHERE ");
			sql.append(" a.companyid = '").append(sCompcode).append("' ");

			if (tDraftDate == null)
				sql.append(" AND YEAR(a.draftdate) = YEAR(SYSTIMESTAMP) ");
			else{
				sql.append(" AND YEAR(a.draftdate) = YEAR('").append(tDraftDate.toString()).append("') ");
			}

			sql.append(" AND b.div_code = '").append(sDivCode).append("' ");
			sql.append(" AND a.documentno <> nfnGetCommonCodeValue('").append(sCompcode).append("', 'NXA0', 'X0001') ");

			pstmt = conn.prepareStatement(sql.toString());
			
			rs = pstmt.executeQuery();

			while(rs.next()){
				sMaxDocumentNo = rs.getString(1);
			}

			rs.close();
			pstmt.close();

			if (sMaxDocumentNo == null || sMaxDocumentNo.equals("")){
				sMaxDocumentNo = sCategoryNm + "-" + sDraftDeptName + "-001";
			}
			else{
				sMaxTempNo = "000" + Integer.toString(Integer.parseInt(sMaxDocumentNo) + 1); 
				iLen = sMaxTempNo.length();
				sMaxDocumentNo = sCategoryNm + "-" + sDraftDeptName + "-" + sMaxTempNo.substring(iLen - 3, iLen);            	
			}

			sRtn = sMaxDocumentNo;
			
			return sRtn;
			
		} catch (Exception e) {
			throw new Exception(e.getMessage());
		} finally {
			if (rs != null) rs.close();
			if (pstmt != null) pstmt.close();
			if (conn != null) conn.close();
		}
	}


	/* ***********************************  
	함수명   : nfnGetApprovalFileCount  
	입력인자 : 문서ID 
	반환값   : 해당문서의 첨부파일 갯수           
	 *********************************** */ 	
	public static int nfnGetApprovalFileCount(String sDocumentID) throws Exception {
		int iRtn = 0;

		Connection conn = null;
		PreparedStatement  pstmt = null;
		ResultSet rs = null;

		try{
			Class.forName("cubrid.jdbc.driver.CUBRIDDriver");
			conn = DriverManager.getConnection("jdbc:default:connection");
//			conn = DriverManager.getConnection("jdbc:CUBRID:192.168.1.220:33000:OmegaPlus:::?charSet=utf-8","unilite","UNILITE");

			StringBuffer sql = new StringBuffer();

			sql.append(" SELECT ");
			sql.append(" COUNT(*) ");
			sql.append(" FROM ");
			sql.append(" tbApprovalFileUpload ");
			sql.append(" WHERE ");
			sql.append(" DocumentID = '").append(sDocumentID).append("' ");

			pstmt = conn.prepareStatement(sql.toString());

			rs = pstmt.executeQuery();

			while(rs.next()){
				iRtn = rs.getInt(1);
			}

			rs.close();
			pstmt.close();

			return iRtn;
			
		} catch (Exception e) {
			throw new Exception(e.getMessage());   
		} finally {
			if (rs != null) rs.close();
			if (pstmt != null) pstmt.close();
			if (conn != null) conn.close();
		}
	}


	/* ***********************************  
	함수명   : nfnGetApprovalReturnDocumentNo  
	입력인자 : comp_code, 문서ID,  문서카달로그ID, 언어 
	반환값   : 반려 문서번호 생성           
	 *********************************** */ 	
	public static String nfnGetApprovalReturnDocumentNo(String sCompcode, String sDocumentID, String sCategoryID, String sLanguage) throws Exception {
		String sRtn = "";

		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		StringBuffer sql = new StringBuffer();
		
		try{
			String sCategoryNm = "";
			String sDraftDeptName = "";
			String sDraftUserID = "";
			Timestamp tDraftDate = null; 
			String sDivCode = "";
			String sMaxDocumentNo = "";
			String sMaxTempNo = "";
			int iLen = 0;
			
			
			
			Class.forName("cubrid.jdbc.driver.CUBRIDDriver");
			conn = DriverManager.getConnection("jdbc:default:connection");
//			conn = DriverManager.getConnection("jdbc:CUBRID:192.168.1.220:33000:OmegaPlus:::?charSet=utf-8","unilite","UNILITE");

			sCategoryNm = "반려";

			sql.setLength(0);
			sql.append(" SELECT ");
			sql.append(" NVL(nfnGetCommonCodeName('").append(sCompcode).append("','NA05','R','").append(sLanguage).append("'), '') ");
			sql.append(" FROM db_root ");

			pstmt = conn.prepareStatement(sql.toString());
			
			rs = pstmt.executeQuery();

			while(rs.next()){
				sCategoryNm = rs.getString(1);
			}

			rs.close();
			pstmt.close();

			sql.setLength(0);
			sql.append(" SELECT ");
			sql.append(" draftdeptname ");
			sql.append(" ,draftuserID ");
			sql.append(" ,draftdate ");
			sql.append(" FROM ");
			sql.append(" tbApprovalDoc ");
			sql.append(" WHERE ");
			sql.append(" documentid = '").append(sDocumentID).append("' ");
			sql.append(" AND companyid = '").append(sCompcode).append("' ");

			pstmt = conn.prepareStatement(sql.toString());
			
			rs = pstmt.executeQuery();

			while(rs.next()){
				sDraftDeptName = rs.getString(1);
				sDraftUserID = rs.getString(2);
				tDraftDate = rs.getTimestamp(3);
			}

			rs.close();
			pstmt.close();

			sql.setLength(0);
			sql.append(" SELECT ");
			sql.append(" div_code ");
			sql.append(" FROM ");
			sql.append(" bsa300t ");
			sql.append(" WHERE user_id = '").append(sDraftUserID).append("' ");
			sql.append(" AND comp_code = '").append(sCompcode).append("' ");

			pstmt = conn.prepareStatement(sql.toString());
			
			rs = pstmt.executeQuery();

			while(rs.next()){
				sDivCode = rs.getString(1);
			}

			rs.close();
			pstmt.close();

			sql.setLength(0);
			sql.append(" SELECT ");
			sql.append(" MAX(RIGHT(a.documentno, 3)) ");
			sql.append(" FROM ");
			sql.append(" tbApprovalDoc a ");
			sql.append(" INNER JOIN bsa300t b ON a.draftuserid = b.user_id AND a.CompanyID = b.comp_code ");
			sql.append(" WHERE ");
			sql.append(" a.companyid = '").append(sCompcode).append("' ");

			if (tDraftDate == null)
				sql.append(" AND YEAR(a.draftdate) = YEAR(SYSTIMESTAMP) ");
			else{
				sql.append(" AND YEAR(a.draftdate) = YEAR('").append(tDraftDate.toString()).append("') ");
			}

			sql.append(" AND b.div_code = '").append(sDivCode).append("' ");
			sql.append(" AND a.documentno <> nfnGetCommonCodeValue('").append(sCompcode).append("', 'NXA0', 'X0001') ");

			pstmt = conn.prepareStatement(sql.toString());
			
			rs = pstmt.executeQuery();

			while(rs.next()){
				sMaxDocumentNo = rs.getString(1);
			}

			rs.close();
			pstmt.close();

			if (sMaxDocumentNo == null || sMaxDocumentNo.equals("")){
				sMaxDocumentNo = sCategoryNm + "-" + sDraftDeptName + "-001";
			}
			else{
				sMaxTempNo = "000" + Integer.toString(Integer.parseInt(sMaxDocumentNo) + 1); 
				iLen = sMaxTempNo.length();
				sMaxDocumentNo = sCategoryNm + "-" + sDraftDeptName + "-" + sMaxTempNo.substring(iLen - 3, iLen);            	
			}

			sRtn = sMaxDocumentNo;

			return sRtn;
			
		} catch (Exception e) {
			throw new Exception(e.getMessage());   
		} finally {
			if (rs != null) rs.close();
			if (pstmt != null) pstmt.close();
			if (conn != null) conn.close();
		}
	}


	/** 함수명 : nfnGetCabinetItem
	 * @param comp_code, pgm_seq, up_pgm_div, user_id
	 * @return
, Exception
	 */
	public static String nfnGetCabinetItem(String comp_code, String pgm_seq, String up_pgm_div, String user_id) throws SQLException, Exception {
		String sRtnUUID = "";		//UniqueKey
		
		Connection  conn = null;
		PreparedStatement pstmt = null;
		ResultSet   rs = null;

		try{
			int iLvl = 0;
			boolean bFlag = true;
			int iCnt = 0;
			String t_nfnMenuListByUser_key = "";
			
			StringBuffer  sql = new StringBuffer();
			
			Class.forName("cubrid.jdbc.driver.CUBRIDDriver");
			conn = DriverManager.getConnection("jdbc:default:connection");
			//conn = DriverManager.getConnection("jdbc:CUBRID:192.168.1.220:33000:OmegaPlus:::?charSet=utf-8","unilite","UNILITE");

			//UniqueKey 생성
			sql.setLength(0);
			sql.append("SELECT nfnGetUniqueKey() ");
			sql.append("FROM   DB_ROOT "); 

			pstmt = conn.prepareStatement(sql.toString());
			
			rs = pstmt.executeQuery();

			while(rs.next()){
				sRtnUUID = rs.getString(1);
			}
			
			rs.close();
			pstmt.close();

			//nfnMenuListByUser 호출
			//리턴값으로 임시테이블(t_nfnMenuListByUser)의 key값을 리턴받는다.

			
			sql.setLength(0);
			sql.append("SELECT nfnMenuListByUser( ? ,  ? ,  ? ) ");
			sql.append("FROM   DB_ROOT ");
			
			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(1, comp_code);
			pstmt.setString(2, pgm_seq);
			pstmt.setString(3, user_id);
			
			rs = pstmt.executeQuery();

			while(rs.next()){
				t_nfnMenuListByUser_key = rs.getString(1);	//t_nfnMenuListByUser 테이블 key_value
			}
			
			rs.close();
			pstmt.close();

			//재귀쿼리
			iLvl = iLvl + 1;

			sql.setLength(0);
			sql.append("INSERT INTO t_nfngetcabinetitem ");
			sql.append("            (KEY_VALUE ");
			sql.append("             ,PGM_ID ");
			sql.append("             ,PGM_NAME ");
			sql.append("             ,LVL) ");
			sql.append("SELECT  ?  ");
			sql.append("       ,m.PGM_ID ");
			sql.append("       ,m.PGM_NAME ");
			sql.append("       , ?  AS lvl ");
			sql.append("FROM   BSA400T m ");
			sql.append("WHERE  m.COMP_CODE =  ?  ");
			sql.append("       AND m.PGM_SEQ =  ?  ");
			sql.append("       AND m.PGM_ID =  ? ");

			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(1, sRtnUUID);
			pstmt.setInt(2, iLvl);
			pstmt.setString(3, comp_code);
			pstmt.setString(4, pgm_seq);
			pstmt.setString(5, up_pgm_div);

			pstmt.executeUpdate();
			
			pstmt.close();

			while(bFlag){

				iCnt = 0;

				if (iLvl > 15)
					break;

				sql.setLength(0);
				sql.append(" SELECT ");
				sql.append(" COUNT(*) ");
				sql.append(" FROM ");
				sql.append(" t_nfngetcabinetitem ");
				sql.append(" WHERE ");
				sql.append(" key_value = '").append(sRtnUUID).append("' ");
				sql.append(" AND lvl = ").append(String.valueOf(iLvl));	

				pstmt = conn.prepareStatement(sql.toString());

				rs = pstmt.executeQuery();

				while(rs.next()){
					iCnt = rs.getInt(1);
				}

				rs.close();    
				pstmt.close();

				if (iCnt > 0){
					bFlag = true;
				}
				else{
					bFlag = false;
					break;
				}

				if (bFlag){
					sql.setLength(0);
					sql.append("INSERT INTO t_nfngetcabinetitem ");
					sql.append("            (KEY_VALUE ");
					sql.append("             ,PGM_ID ");
					sql.append("             ,PGM_NAME ");
					sql.append("             ,LVL) ");
					sql.append("SELECT  ?     AS key_value ");
					sql.append("       ,b.PGM_ID ");
					sql.append("       ,b.PGM_NAME ");
					sql.append("       ,(  ?  + 1 ) AS lvl ");
					sql.append("FROM   t_nfngetcabinetitem a ");
					sql.append("       INNER JOIN (SELECT PGM_ID ");
					sql.append("                          ,PGM_NAME ");
					sql.append("                          ,UP_PGM_DIV ");
					sql.append("                          ,TYPE ");
					sql.append("                   FROM   BSA400T ");
					sql.append("                   WHERE  COMP_CODE =  ?  ");
					sql.append("                          AND PGM_SEQ =  ?  ");
					sql.append("                   UNION ALL ");
					sql.append("                   SELECT PGM_ID ");
					sql.append("                          ,PGM_NAME ");
					sql.append("                          ,UP_PGM_DIV ");
					sql.append("                          ,TYPE ");
					sql.append("                   FROM   TBMENU ");
					sql.append("                   WHERE  COMP_CODE =  ?  ");
					sql.append("                          AND PGM_SEQ =  ? ) b ");
					sql.append("               ON a.PGM_ID = b.UP_PGM_DIV ");
					sql.append("       INNER JOIN (SELECT * ");
					sql.append("                   FROM   t_nfnmenulistbyuser ");
					sql.append("                   WHERE  KEY_VALUE =  ? ) c ");
					sql.append("               ON b.PGM_ID = c.PGM_ID ");
					sql.append("WHERE  a.KEY_VALUE =  ?  ");
					sql.append("       AND a.LVL =  ? ");

					pstmt = conn.prepareStatement(sql.toString());
					pstmt.setString(1, sRtnUUID);
					pstmt.setInt(2, iLvl);
					pstmt.setString(3, comp_code);
					pstmt.setString(4, pgm_seq);
					pstmt.setString(5, comp_code);
					pstmt.setString(6, pgm_seq);
					pstmt.setString(7, t_nfnMenuListByUser_key);
					pstmt.setString(8, sRtnUUID);
					pstmt.setInt(9, iLvl);

					pstmt.executeUpdate();

					pstmt.close();

				}

				iLvl = iLvl + 1;

			}

			//임시테이블(t_nfnmenulistbyuser) 삭제
			sql.setLength(0);
			sql.append(" SELECT ");
			sql.append(" nfnDeleteTableByKeyValue('t_nfnmenulistbyuser', '").append(t_nfnMenuListByUser_key).append("') ");
			sql.append(" FROM db_root ");
			
			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.executeQuery();
			
			pstmt.close();
			
			return sRtnUUID;

		} catch (Exception e) {
			throw new Exception(e.getMessage());
		} finally {
			if (rs != null) rs.close();
			if (pstmt != null) pstmt.close();
			if (conn != null) conn.close();
		}
	}

	/** 함수명 : nfnGetCommonCodeName
	 * @param sCompCode, sMainCode, sSubCode, sLangCode
	 * @return
	 * @throws Exception
	 */
	public static String nfnGetCommonCodeName(String sCompCode, String sMainCode, String sSubCode, String sLangCode) throws SQLException, Exception {
		String sCodeName = "";

		Connection  conn = null;
		PreparedStatement pstmt = null;
		ResultSet   rs = null;
		
		try{
			int rsCnt = 0;
			
			StringBuffer  sql = new StringBuffer();
			
			Class.forName("cubrid.jdbc.driver.CUBRIDDriver");
			conn = DriverManager.getConnection("jdbc:default:connection");
			//			conn = DriverManager.getConnection("jdbc:CUBRID:192.168.1.220:33000:OmegaPlus:::?charSet=utf-8","unilite","UNILITE");
			
			if(sSubCode == null || sSubCode.equals("")){
				return sCodeName;
			}
			
			sql.setLength(0);
			sql.append(" SELECT ");
			sql.append(" COUNT(*) ");
			sql.append(" FROM   bsa100t ");
			sql.append(" WHERE  comp_code =  '").append(sCompCode).append("' ");
			sql.append("       AND main_code =  '").append(sMainCode).append("' ");
			sql.append("       AND sub_code =  '").append(sSubCode).append("' ");

			pstmt = conn.prepareStatement(sql.toString());

			rs = pstmt.executeQuery();

			while(rs.next()){
				rsCnt = rs.getInt(1);
			}
			
			rs.close();
			pstmt.close();

			if (rsCnt == 1){

				sql.setLength(0);
				sql.append(" SELECT CASE  LOWER('").append(sLangCode).append("') ");
				sql.append("         WHEN 'en' THEN NVL(code_name_en, code_name) ");
				sql.append("         WHEN 'cn' THEN NVL(code_name_cn, code_name) ");
				sql.append("         WHEN 'jp' THEN NVL(code_name_jp, code_name) ");
				sql.append("         ELSE code_name ");
				sql.append("       END ");
				sql.append(" FROM   bsa100t ");
				sql.append(" WHERE  comp_code =  '").append(sCompCode).append("' ");
				sql.append("       AND main_code =  '").append(sMainCode).append("' ");
				sql.append("       AND sub_code =  '").append(sSubCode).append("' ");

				pstmt = conn.prepareStatement(sql.toString());

				rs = pstmt.executeQuery();

				while(rs.next()){
					sCodeName = rs.getString(1);
				}

				rs.close();
				pstmt.close();
			}
			else {
				sCodeName = "";
			}

			return sCodeName;
			
		} catch (Exception e) {
			throw new Exception(e.getMessage());
		} finally {
			if (rs != null) rs.close();
			if (pstmt != null) pstmt.close();
			if (conn != null) conn.close();
		}
	}

	/** 함수명 : nfnGetCommonCodeValue
	 * @param sCompCode, sMainCode, sSubCode
	 * @return
	 * @throws Exception
	 */
	public static String nfnGetCommonCodeValue(String sCompCode, String sMainCode, String sSubCode)  throws SQLException, Exception {	
		String sCodeValue = "";

		Connection  conn = null;
		PreparedStatement pstmt = null;
		ResultSet   rs = null;		

		try{
			int rsCnt = 0;
			
			
			StringBuffer  sql = new StringBuffer();
			
			Class.forName("cubrid.jdbc.driver.CUBRIDDriver");
			conn = DriverManager.getConnection("jdbc:default:connection");
			//			conn = DriverManager.getConnection("jdbc:CUBRID:192.168.1.220:33000:OmegaPlus:::?charSet=utf-8","unilite","UNILITE");

			if (sSubCode == null || sSubCode.equals("")) {
				return sCodeValue;
			}

			sql.setLength(0);
			sql.append("SELECT  COUNT(*) ");
			sql.append("FROM   bsa100t ");
			sql.append("WHERE  comp_code =  '").append(sCompCode).append("' ");
			sql.append("       AND main_code =  '").append(sMainCode).append("' ");
			sql.append("       AND sub_code =  '").append(sSubCode).append("' ");

			pstmt = conn.prepareStatement(sql.toString());

			rs = pstmt.executeQuery();

			while(rs.next()){
				rsCnt = rs.getInt(1);
			}

			rs.close();
			pstmt.close();

			if(rsCnt == 1){

				sql.setLength(0);
				sql.append("SELECT  ref_code1 ");
				sql.append("FROM   bsa100t ");
				sql.append("WHERE  comp_code =  '").append(sCompCode).append("' ");
				sql.append("       AND main_code =  '").append(sMainCode).append("' ");
				sql.append("       AND sub_code =  '").append(sSubCode).append("' ");

				pstmt = conn.prepareStatement(sql.toString());

				rs = pstmt.executeQuery();

				while(rs.next()){
					sCodeValue = rs.getString(1);
				}

				rs.close();
				pstmt.close();
			}
			else {
				sCodeValue = "";
			}

			return sCodeValue;
			
		} catch (Exception e) {
			throw new Exception(e.getMessage());
		} finally {
			if (rs != null) rs.close();
			if (pstmt != null) pstmt.close();
			if (conn != null) conn.close();
		}
	}

	/* ***********************************  
	함수명   : nfnGetDeptName  
	입력인자 : Comp_Code, 부서코드  
	반환값   : 부서명            
	 *********************************** */ 	
	public static String nfnGetDeptName(String sCompcode, String sDeptCode) throws Exception {
		String sRtn = "";

		Connection conn = null;
		PreparedStatement  pstmt = null;
		ResultSet rs = null;

		try{

			Class.forName("cubrid.jdbc.driver.CUBRIDDriver");
			conn = DriverManager.getConnection("jdbc:default:connection");
//			conn = DriverManager.getConnection("jdbc:CUBRID:192.168.1.220:33000:OmegaPlus:::?charSet=utf-8","unilite","UNILITE");

			StringBuffer sql = new StringBuffer();

			sql.append(" SELECT ");
			sql.append(" tree_name ");
			sql.append(" FROM  ");
			sql.append(" bsa210t ");
			sql.append(" WHERE ");
			sql.append(" comp_code = ").append("'").append(sCompcode).append("' ");
			sql.append(" AND tree_code = ").append("'").append(sDeptCode).append("' ");

			pstmt = conn.prepareStatement(sql.toString());

			rs = pstmt.executeQuery();

			while(rs.next()){
				sRtn = rs.getString(1);
			}

			rs.close();
			pstmt.close();

			return sRtn;
			
		} catch (Exception e) {
			throw new Exception(e.getMessage());
		} finally {
			if (rs != null) rs.close();
			if (pstmt != null) pstmt.close();
			if (conn != null) conn.close();
		}
	}

	/* ***********************************  
		함수명   : nfnGetDocList  
		입력인자 : 결재함ID, Comp_Code, 사용자ID, 언어, 메뉴ID, 검색어 
		반환값   : 결재함리스트           
	 *********************************** */ 
	public static String nfnGetDocList(String sBox, String sCompCode, String sUserId, String sLangCode, String sMenuId, String sSearchText, String sDivCode) throws Exception  {
		String sRtnUUID = "";

		Connection conn = null;
		PreparedStatement  pstmt = null;
		ResultSet rs = null;

		StringBuffer sql = new StringBuffer();
	
		
		try{

			String sKeyValue1 = "";
			String sGradeLevel = "";

			Class.forName("cubrid.jdbc.driver.CUBRIDDriver");
			conn = DriverManager.getConnection("jdbc:default:connection");
			//			conn = DriverManager.getConnection("jdbc:CUBRID:192.168.1.220:33000:OmegaPlus:::?charSet=utf-8","unilite","UNILITE");
//쿼리를 보니까 'null'이라고 null이라는 문자가 들어와서 문자비교해서 null이면 공백으로 다시 돌리는 부분을 넣었습니다.
//해당 class 다시 큐브리드 서버에 올리시고 서버 내렸다 올리신 후에 다시 조회 해 보십시요... 
//급한 일이 생겨서 먼저 들어가봐야 할것 같습니다. 만약 해결 안돼면 내일 다시 전화 주십시요..
			if (sSearchText.equals("null"))	sSearchText = "";
			if (sDivCode.equals("null"))	sDivCode = "";

			sql.append(" SELECT ");
			sql.append(" nfngetuniquekey() AS unique_key "); 
			sql.append(" FROM ");
			sql.append(" db_root ");
			
		
			pstmt = conn.prepareStatement(sql.toString());

			rs = pstmt.executeQuery();

			while(rs.next()){
				sRtnUUID = rs.getString(1);
			}

			rs.close();    
			pstmt.close();


			if (sBox.toUpperCase().equals("XA003") || sBox.toUpperCase().equals("XA004") || sBox.toUpperCase().equals("XA011") 
					|| sBox.toUpperCase().equals("XA005") || sBox.toUpperCase().equals("XA006") || sBox.toUpperCase().equals("XA007")
					|| sBox.toUpperCase().equals("XA008") || sBox.toUpperCase().equals("XA009") || sBox.toUpperCase().equals("XA010")
					|| sBox.toUpperCase().equals("XA012") || sBox.toUpperCase().equals("XA013")){
				/* 미결문서 */

				sql.setLength(0);
				sql.append(" SELECT ");
				sql.append(" nfnCompanyIDList('").append(sUserId).append("','").append(sCompCode).append("') ");
				sql.append(" FROM db_root ");

			
				pstmt = conn.prepareStatement(sql.toString());

				rs = pstmt.executeQuery();

				while(rs.next()){
					sKeyValue1 = rs.getString(1);
				}

				rs.close();
				pstmt.close();
			}

			if (sBox.toUpperCase().equals("XA009")) {

				sql.setLength(0);
				sql.append(" SELECT ");
				sql.append(" grade_level "); 
				sql.append(" FROM ");   
				sql.append(" bsa300t "); 
				sql.append(" WHERE ");  
				sql.append(" comp_code = '").append(sCompCode).append("' ");
				sql.append(" AND user_id = '").append(sUserId).append("' ");

	
				pstmt = conn.prepareStatement(sql.toString());

				rs = pstmt.executeQuery();

				while(rs.next()){
					sGradeLevel = rs.getString(1);
				}

				rs.close();
				pstmt.close();
			}

			sql.setLength(0);
			sql.append(" INSERT INTO t_nfnGetDocList ");
			sql.append(" ( ");
			sql.append(" key_value ");
			sql.append(" ,fileattachflag ");
			sql.append(" ,documentid ");
			sql.append(" ,documentno ");
			sql.append(" ,subject ");
			sql.append(" ,contents ");
			sql.append(" ,[status] ");
			sql.append(" ,statusname ");
			sql.append(" ,readdate ");
			sql.append(" ,insertdate ");
			sql.append(" ,enddate ");
			sql.append(" ,draftdate ");
			sql.append(" ,draftuserid ");
			sql.append(" ,draftusername ");
			sql.append(" ,draftuserpos ");
			sql.append(" ,rcvtypename ");
			sql.append(" ,rcvusername ");
			sql.append(" ,readchk ");
			sql.append(" ,closingflag ");
			sql.append(" ) ");

			/* 임시문서 */
			if (sBox.toUpperCase().equals("XA001")){
				sql.append(" SELECT ");
				sql.append(" '").append(sRtnUUID).append("' ");
				sql.append(" ,nfnGetApprovalFileCount(documentid) ");
				sql.append(" ,documentid ");
				sql.append(" ,documentno ");
				sql.append(" ,subject + CASE WHEN nfnGetApprovalCommentCount(documentid) > 0 THEN '...[☞:' + CAST(nfnGetApprovalCommentCount(documentid) AS VARCHAR) + ']' ELSE ''  END "); 
				sql.append(" ,contents ");
				sql.append(" ,[status] ");
				sql.append(" ,nfnGetCommonCodeName('").append(sCompCode).append("','NA05', [status],'").append(sLangCode).append("') ");
				sql.append(" ,null ");
				sql.append(" ,insertdate ");
				sql.append(" ,lastsignadate ");
				sql.append(" ,draftdate ");
				sql.append(" ,draftuserid ");
				sql.append(" ,draftusername ");
				sql.append(" ,draftuserpos ");
				sql.append(" ,'' ");
				sql.append(" ,'' ");
				sql.append(" ,1 "); 
				sql.append(" ,'N'");
				sql.append(" FROM ");
				sql.append(" tbapprovaldoc ");
				sql.append(" WHERE ");
				sql.append(" companyid = '").append(sCompCode).append("' ");
				sql.append(" AND draftuserid = '").append(sUserId).append("' ");
				sql.append(" AND [status] = 'A' ");
				sql.append(" AND (subject LIKE '%' + '").append(sSearchText).append("' + '%' OR ");
				sql.append(" documentno LIKE '%' + '").append(sSearchText).append("' + '%' OR ");
				sql.append(" draftusername LIKE '%' + '").append(sSearchText).append("' + '%' ) ");
			}
			else if (sBox.toUpperCase().equals("XA002")) {
				/* 기안문서 */
				sql.append(" SELECT ");
				sql.append(" '").append(sRtnUUID).append("' ");
				sql.append(" ,nfnGetApprovalFileCount(documentid) ");
				sql.append(" ,documentid ");
				sql.append(" ,documentno ");
				sql.append(" ,subject + CASE WHEN nfnGetApprovalCommentCount(documentid) > 0 THEN '...[☞:' + CAST(nfnGetApprovalCommentCount(documentid) AS VARCHAR) + ']' ELSE ''  END "); 
				sql.append(" ,contents ");
				sql.append(" ,[status] ");
				sql.append(" ,nfnGetCommonCodeName('").append(sCompCode).append("','NA05', [status],'").append(sLangCode).append("') ");
				sql.append(" ,null ");
				sql.append(" ,draftdate ");
				sql.append(" ,lastsignadate ");
				sql.append(" ,draftdate ");
				sql.append(" ,draftuserid ");
				sql.append(" ,draftusername ");
				sql.append(" ,draftuserpos ");
				sql.append(" ,'' ");
				sql.append(" ,'' ");
				sql.append(" ,1 "); 
				sql.append(" ,CASE WHEN [status] IN ('C','R') THEN 'Y' ELSE 'N' END ");
				sql.append(" FROM ");
				sql.append(" tbapprovaldoc ");
				sql.append(" WHERE ");
				sql.append(" companyid = '").append(sCompCode).append("' ");
				sql.append(" AND draftuserid = '").append(sUserId).append("' ");
				sql.append(" AND [status] IN ('B','C','R') ");
				sql.append(" AND NVL(ucabinetid, '') = '' ");
				sql.append(" AND (subject LIKE '%' + '").append(sSearchText).append("' + '%' OR ");
				sql.append(" documentno LIKE '%' + '").append(sSearchText).append("' + '%' OR ");
				sql.append(" draftusername LIKE '%' + '").append(sSearchText).append("' + '%' ) ");
			}
			else if (sBox.toUpperCase().equals("XA003")) {
				/* 미결문서 */
				sql.append(" SELECT ");
				sql.append(" '").append(sRtnUUID).append("' ");
				sql.append(" ,nfnGetApprovalFileCount(a.documentid) ");
				sql.append(" ,a.documentid ");
				sql.append(" ,a.documentno ");
				sql.append(" ,a.subject + CASE WHEN nfnGetApprovalCommentCount(a.documentid) > 0 THEN '...[☞:' + CAST(nfnGetApprovalCommentCount(a.documentid) AS VARCHAR) + ']' ELSE ''  END "); 
				sql.append(" ,a.contents ");
				sql.append(" ,a.[status] ");
				sql.append(" ,nfnGetCommonCodeName('").append(sCompCode).append("','NA05', a.[status],'").append(sLangCode).append("') ");
				sql.append(" ,null ");
				sql.append(" ,a.draftdate ");
				sql.append(" ,a.lastsignadate ");
				sql.append(" ,a.draftdate ");
				sql.append(" ,a.draftuserid ");
				sql.append(" ,a.draftusername ");
				sql.append(" ,a.draftuserpos ");
				sql.append(" ,'' ");
				sql.append(" ,'' ");
				sql.append(" ,1 "); 
				sql.append(" ,'N' ");
				sql.append(" FROM ");
				sql.append(" tbapprovaldoc a ");
				sql.append(" INNER JOIN tbapprovaldocline b ON a.documentid = b.documentid AND b.signuserid = '").append(sUserId).append("' AND b.signflag = 'Y' AND b.[status] = 'A' ");
				sql.append(" WHERE ");
				sql.append(" a.companyid IN (SELECT companyid FROM t_nfncompanyidlist WHERE key_value = '").append(sKeyValue1).append("') ");
				sql.append(" AND a.[status] = 'B' ");
				sql.append(" AND (a.subject LIKE '%' + '").append(sSearchText).append("' + '%' OR ");
				sql.append(" a.documentno LIKE '%' + '").append(sSearchText).append("' + '%' OR ");
				sql.append(" a.draftusername LIKE '%' + '").append(sSearchText).append("' + '%' ) ");
			}
			else if (sBox.toUpperCase().equals("XA004")) {
				/* 기결문서 */
				sql.append(" SELECT ");
				sql.append(" '").append(sRtnUUID).append("' ");
				sql.append(" ,nfnGetApprovalFileCount(a.documentid) ");
				sql.append(" ,a.documentid ");
				sql.append(" ,a.documentno ");
				sql.append(" ,a.subject + CASE WHEN nfnGetApprovalCommentCount(a.documentid) > 0 THEN '...[☞:' + CAST(nfnGetApprovalCommentCount(a.documentid) AS VARCHAR) + ']' ELSE ''  END "); 
				sql.append(" ,a.contents ");
				sql.append(" ,a.[status] ");
				sql.append(" ,nfnGetCommonCodeName('").append(sCompCode).append("','NA05', a.[status],'").append(sLangCode).append("') ");
				sql.append(" ,null ");
				sql.append(" ,a.draftdate ");
				sql.append(" ,a.lastsignadate ");
				sql.append(" ,a.draftdate ");
				sql.append(" ,a.draftuserid ");
				sql.append(" ,a.draftusername ");
				sql.append(" ,a.draftuserpos ");
				sql.append(" ,'' ");
				sql.append(" ,'' ");
				sql.append(" ,1 "); 
				sql.append(" ,CASE WHEN a.[status] IN ('C','R') THEN 'Y' ELSE 'N' END ");
				sql.append(" FROM ");
				sql.append(" tbapprovaldoc a ");
				sql.append(" INNER JOIN tbapprovaldocline b ON a.documentid = b.documentid AND b.signuserid = '").append(sUserId).append("' AND b.[status] = 'C' ");
				sql.append(" WHERE ");
				sql.append(" a.companyid IN (SELECT companyid FROM t_nfncompanyidlist WHERE key_value = '").append(sKeyValue1).append("') ");
				sql.append(" AND a.[status] IN ('B','C') ");
				sql.append(" AND (a.subject LIKE '%' + '").append(sSearchText).append("' + '%' OR ");
				sql.append(" a.documentno LIKE '%' + '").append(sSearchText).append("' + '%' OR ");
				sql.append(" a.draftusername LIKE '%' + '").append(sSearchText).append("' + '%' ) ");
			}
			else if (sBox.toUpperCase().equals("XA011")) {
				/* 반려문서 */
				sql.append(" SELECT ");
				sql.append(" '").append(sRtnUUID).append("' ");
				sql.append(" ,nfnGetApprovalFileCount(a.documentid) ");
				sql.append(" ,a.documentid ");
				sql.append(" ,a.documentno ");
				sql.append(" ,a.subject + CASE WHEN nfnGetApprovalCommentCount(a.documentid) > 0 THEN '...[☞:' + CAST(nfnGetApprovalCommentCount(a.documentid) AS VARCHAR) + ']' ELSE ''  END "); 
				sql.append(" ,a.contents ");
				sql.append(" ,a.[status] ");
				sql.append(" ,nfnGetCommonCodeName('").append(sCompCode).append("','NA05', a.[status],'").append(sLangCode).append("') ");
				sql.append(" ,null ");
				sql.append(" ,a.draftdate ");
				sql.append(" ,a.lastsignadate ");
				sql.append(" ,a.draftdate ");
				sql.append(" ,a.draftuserid ");
				sql.append(" ,a.draftusername ");
				sql.append(" ,a.draftuserpos ");
				sql.append(" ,'' ");
				sql.append(" ,'' ");
				sql.append(" ,1 "); 
				sql.append(" ,CASE WHEN a.[status] IN ('C','R') THEN 'Y' ELSE 'N' END ");
				sql.append(" FROM ");
				sql.append(" tbapprovaldoc a ");
				sql.append(" INNER JOIN tbapprovaldocline b ON a.documentid = b.documentid AND b.signuserid = '").append(sUserId).append("' AND b.[status] = 'R' ");
				sql.append(" WHERE ");
				sql.append(" a.companyid IN (SELECT companyid FROM t_nfncompanyidlist WHERE key_value = '").append(sKeyValue1).append("') ");
				sql.append(" AND a.[status] IN ('B','R') ");
				sql.append(" AND (a.subject LIKE '%' + '").append(sSearchText).append("' + '%' OR ");
				sql.append(" a.documentno LIKE '%' + '").append(sSearchText).append("' + '%' OR ");
				sql.append(" a.draftusername LIKE '%' + '").append(sSearchText).append("' + '%' ) ");
			}
			else if (sBox.toUpperCase().equals("XA005")) {
				/* 예결문서 */
				sql.append(" SELECT ");
				sql.append(" '").append(sRtnUUID).append("' ");
				sql.append(" ,nfnGetApprovalFileCount(a.documentid) ");
				sql.append(" ,a.documentid ");
				sql.append(" ,a.documentno ");
				sql.append(" ,a.subject + CASE WHEN nfnGetApprovalCommentCount(a.documentid) > 0 THEN '...[☞:' + CAST(nfnGetApprovalCommentCount(a.documentid) AS VARCHAR) + ']' ELSE ''  END "); 
				sql.append(" ,a.contents ");
				sql.append(" ,a.[status] ");
				sql.append(" ,nfnGetCommonCodeName('").append(sCompCode).append("','NA05', a.[status],'").append(sLangCode).append("') ");
				sql.append(" ,null ");
				sql.append(" ,a.draftdate ");
				sql.append(" ,a.lastsignadate ");
				sql.append(" ,a.draftdate ");
				sql.append(" ,a.draftuserid ");
				sql.append(" ,a.draftusername ");
				sql.append(" ,a.draftuserpos ");
				sql.append(" ,'' ");
				sql.append(" ,'' ");
				sql.append(" ,1 "); 
				sql.append(" ,CASE WHEN a.[status] IN ('C','R') THEN 'Y' ELSE 'N' END ");
				sql.append(" FROM ");
				sql.append(" tbapprovaldoc a ");
				sql.append(" INNER JOIN tbapprovaldocline b ON a.documentid = b.documentid AND b.signuserid = '").append(sUserId).append("' ");
				sql.append(" WHERE ");
				sql.append(" a.companyid IN (SELECT companyid FROM t_nfncompanyidlist WHERE key_value = '").append(sKeyValue1).append("') ");
				sql.append(" AND a.[status] = 'B' ");
				sql.append(" AND (a.subject LIKE '%' + '").append(sSearchText).append("' + '%' OR ");
				sql.append(" a.documentno LIKE '%' + '").append(sSearchText).append("' + '%' OR ");
				sql.append(" a.draftusername LIKE '%' + '").append(sSearchText).append("' + '%' ) ");
			}
			else if (sBox.toUpperCase().equals("XA006")) {
				/* 참조함 */
				sql.append(" SELECT ");
				sql.append(" '").append(sRtnUUID).append("' ");
				sql.append(" ,nfnGetApprovalFileCount(a.documentid) ");
				sql.append(" ,a.documentid ");
				sql.append(" ,a.documentno ");
				sql.append(" ,a.subject + CASE WHEN nfnGetApprovalCommentCount(a.documentid) > 0 THEN '...[☞:' + CAST(nfnGetApprovalCommentCount(a.documentid) AS VARCHAR) + ']' ELSE ''  END "); 
				sql.append(" ,a.contents ");
				sql.append(" ,a.[status] ");
				sql.append(" ,nfnGetCommonCodeName('").append(sCompCode).append("','NA05', a.[status],'").append(sLangCode).append("') ");
				sql.append(" ,b.readdate ");
				sql.append(" ,a.draftdate ");
				sql.append(" ,a.lastsignadate ");
				sql.append(" ,a.draftdate ");
				sql.append(" ,a.draftuserid ");
				sql.append(" ,a.draftusername ");
				sql.append(" ,a.draftuserpos ");
				sql.append(" ,'' ");
				sql.append(" ,b.rcvusername ");
				sql.append(" ,CASE WHEN b.readdate IS NULL THEN 0 ELSE 1 END "); 
				sql.append(" ,CASE WHEN a.[status] IN ('C','R') THEN 'Y' ELSE 'N' END ");
				sql.append(" FROM ");
				sql.append(" tbapprovaldoc a ");
				sql.append(" INNER JOIN tbapprovaldocrcvuser b ON a.documentid = b.documentid AND b.rcvuserid = '").append(sUserId).append("' AND b.rcvtype = 'R' ");
				sql.append(" WHERE ");
				sql.append(" a.companyid IN (SELECT companyid FROM t_nfncompanyidlist WHERE key_value = '").append(sKeyValue1).append("') ");
				sql.append(" AND a.[status] IN ('B','C') ");
				sql.append(" AND (a.subject LIKE '%' + '").append(sSearchText).append("' + '%' OR ");
				sql.append(" a.documentno LIKE '%' + '").append(sSearchText).append("' + '%' OR ");
				sql.append(" a.draftusername LIKE '%' + '").append(sSearchText).append("' + '%' ) ");
			}
			else if (sBox.toUpperCase().equals("XA007")) {
				/* 수신함 */
				sql.append(" SELECT ");
				sql.append(" '").append(sRtnUUID).append("' ");
				sql.append(" ,nfnGetApprovalFileCount(a.documentid) ");
				sql.append(" ,a.documentid ");
				sql.append(" ,a.documentno ");
				sql.append(" ,a.subject + CASE WHEN nfnGetApprovalCommentCount(a.documentid) > 0 THEN '...[☞:' + CAST(nfnGetApprovalCommentCount(a.documentid) AS VARCHAR) + ']' ELSE ''  END "); 
				sql.append(" ,a.contents ");
				sql.append(" ,a.[status] ");
				sql.append(" ,nfnGetCommonCodeName('").append(sCompCode).append("','NA05', a.[status],'").append(sLangCode).append("') ");
				sql.append(" ,b.readdate ");
				sql.append(" ,a.draftdate ");
				sql.append(" ,a.lastsignadate ");
				sql.append(" ,a.draftdate ");
				sql.append(" ,a.draftuserid ");
				sql.append(" ,a.draftusername ");
				sql.append(" ,a.draftuserpos ");
				sql.append(" ,'' ");
				sql.append(" ,b.rcvusername ");
				sql.append(" ,CASE WHEN b.readdate IS NULL THEN 0 ELSE 1 END "); 
				sql.append(" ,CASE WHEN a.[status] IN ('C','R') THEN 'Y' ELSE 'N' END ");
				sql.append(" FROM ");
				sql.append(" tbapprovaldoc a ");
				sql.append(" INNER JOIN tbapprovaldocrcvuser b ON a.documentid = b.documentid AND b.rcvuserid = '").append(sUserId).append("' AND b.rcvtype = 'C' ");
				sql.append(" WHERE ");
				sql.append(" a.companyid IN (SELECT companyid FROM t_nfncompanyidlist WHERE key_value = '").append(sKeyValue1).append("') ");
				sql.append(" AND a.[status] = 'C' ");
				sql.append(" AND (a.subject LIKE '%' + '").append(sSearchText).append("' + '%' OR ");
				sql.append(" a.documentno LIKE '%' + '").append(sSearchText).append("' + '%' OR ");
				sql.append(" a.draftusername LIKE '%' + '").append(sSearchText).append("' + '%' ) ");
			}
			else if (sBox.toUpperCase().equals("XA008")) {
				/* 발신함 */
				sql.append(" SELECT ");
				sql.append(" '").append(sRtnUUID).append("' ");
				sql.append(" ,nfnGetApprovalFileCount(a.documentid) ");
				sql.append(" ,a.documentid ");
				sql.append(" ,a.documentno ");
				sql.append(" ,a.subject + CASE WHEN nfnGetApprovalCommentCount(a.documentid) > 0 THEN '...[☞:' + CAST(nfnGetApprovalCommentCount(a.documentid) AS VARCHAR) + ']' ELSE ''  END "); 
				sql.append(" ,a.contents ");
				sql.append(" ,a.[status] ");
				sql.append(" ,nfnGetCommonCodeName('").append(sCompCode).append("','NA05', a.[status],'").append(sLangCode).append("') ");
				sql.append(" ,b.readdate ");
				sql.append(" ,a.draftdate ");
				sql.append(" ,a.lastsignadate ");
				sql.append(" ,a.draftdate ");
				sql.append(" ,a.draftuserid ");
				sql.append(" ,a.draftusername ");
				sql.append(" ,a.draftuserpos ");
				sql.append(" ,nfnGetCommonCodeName('").append(sCompCode).append("','NA07',b.depttype,'").append(sLangCode).append("') + '[' + nfnGetCommonCodeName('").append(sCompCode).append("','NA06',b.rcvtype,'").append(sLangCode).append("') +']' ");
				sql.append(" ,b.rcvusername ");
				sql.append(" ,1 "); 
				sql.append(" ,CASE WHEN a.[status] IN ('C','R') THEN 'Y' ELSE 'N' END ");
				sql.append(" FROM ");
				sql.append(" tbapprovaldoc a ");
				sql.append(" INNER JOIN tbapprovaldocrcvuser b ON a.documentid = b.documentid ");
				sql.append(" WHERE ");
				sql.append(" a.companyid IN (SELECT companyid FROM t_nfncompanyidlist WHERE key_value = '").append(sKeyValue1).append("') ");
				sql.append(" AND a.[status] IN ('B','C') ");
				sql.append(" AND a.draftuserid = '").append(sUserId).append("' ");
				sql.append(" AND (a.subject LIKE '%' + '").append(sSearchText).append("' + '%' OR ");
				sql.append(" a.documentno LIKE '%' + '").append(sSearchText).append("' + '%' OR ");
				sql.append(" a.draftusername LIKE '%' + '").append(sSearchText).append("' + '%' ) ");
			}
			else if (sBox.toUpperCase().equals("XA009")) {
				/* 회사문서 */
				sql.append(" SELECT ");
				sql.append(" '").append(sRtnUUID).append("' ");
				sql.append(" ,nfnGetApprovalFileCount(a.documentid) ");
				sql.append(" ,a.documentid ");
				sql.append(" ,a.documentno ");
				sql.append(" ,a.subject + CASE WHEN nfnGetApprovalCommentCount(a.documentid) > 0 THEN '...[☞:' + CAST(nfnGetApprovalCommentCount(a.documentid) AS VARCHAR) + ']' ELSE ''  END "); 
				sql.append(" ,a.contents ");
				sql.append(" ,a.[status] ");
				sql.append(" ,nfnGetCommonCodeName('").append(sCompCode).append("','NA05', [status],'").append(sLangCode).append("') ");
				sql.append(" ,null ");
				sql.append(" ,a.draftdate ");
				sql.append(" ,a.lastsignadate ");
				sql.append(" ,a.draftdate ");
				sql.append(" ,a.draftuserid ");
				sql.append(" ,a.draftusername ");
				sql.append(" ,a.draftuserpos ");
				sql.append(" ,'' ");
				sql.append(" ,'' ");
				sql.append(" ,1 "); 
				sql.append(" ,CASE WHEN a.[status] IN ('C','R') THEN 'Y' ELSE 'N' END ");
				sql.append(" FROM ");
				sql.append(" tbapprovaldoc a ");
				sql.append(" INNER JOIN bsa300t b ON a.companyid = b.comp_code AND a.draftuserid = b.user_id ");
				sql.append(" WHERE ");
				sql.append(" a.companyid IN (SELECT companyid FROM t_nfncompanyidlist WHERE key_value = '").append(sKeyValue1).append("') ");
				sql.append(" AND a.[status] = 'C' ");
				sql.append(" AND (b.div_code = (SELECT div_code FROM bsa300t WHERE comp_code = '").append(sCompCode).append("' AND user_id = '").append(sUserId).append("') ");
				sql.append(" OR '01'  = (SELECT div_code FROM bsa300t WHERE comp_code = '").append(sCompCode).append("' AND user_id = '").append(sUserId).append("')) ");
				sql.append(" AND a.cabinetid = '").append(sMenuId).append("' ");
				sql.append(" AND (a.securegrade >= NVL('").append(sGradeLevel).append("', 'GZ') ");
				sql.append(" OR a.draftuserid = '").append(sUserId).append("' ");
				sql.append(" OR (SELECT COUNT(1) FROM tbapprovaldocline b WHERE a.documentid = b.documentid AND b.signuserid = '").append(sUserId).append("' ) > 0 ");
				sql.append(" OR (SELECT COUNT(1) FROM tbapprovaldocrcvuser c WHERE a.documentid = c.documentid AND c.rcvuserid = '").append(sUserId).append("') > 0 ) ");
				
				if (sDivCode != null && !sDivCode.equals("") )
					sql.append(" AND b.div_code = '").append(sDivCode).append("' ");
				
				sql.append(" AND (a.subject LIKE '%' + '").append(sSearchText).append("' + '%' OR ");
				sql.append(" a.documentno LIKE '%' + '").append(sSearchText).append("' + '%' OR ");
				sql.append(" a.draftusername LIKE '%' + '").append(sSearchText).append("' + '%' ) ");
			}
			else if (sBox.toUpperCase().equals("XA010")) {
				/* 개인문서 */
				sql.append(" SELECT ");
				sql.append(" '").append(sRtnUUID).append("' ");
				sql.append(" ,nfnGetApprovalFileCount(documentid) ");
				sql.append(" ,documentid ");
				sql.append(" ,documentno ");
				sql.append(" ,subject + CASE WHEN nfnGetApprovalCommentCount(documentid) > 0 THEN '...[☞:' + CAST(nfnGetApprovalCommentCount(documentid) AS VARCHAR) + ']' ELSE ''  END "); 
				sql.append(" ,contents ");
				sql.append(" ,[status] ");
				sql.append(" ,nfnGetCommonCodeName('").append(sCompCode).append("','NA05', [status],'").append(sLangCode).append("') ");
				sql.append(" ,null ");
				sql.append(" ,draftdate ");
				sql.append(" ,lastsignadate ");
				sql.append(" ,draftdate ");
				sql.append(" ,draftuserid ");
				sql.append(" ,draftusername ");
				sql.append(" ,draftuserpos ");
				sql.append(" ,'' ");
				sql.append(" ,'' ");
				sql.append(" ,1 "); 
				sql.append(" ,CASE WHEN [status] IN ('C','R') THEN 'Y' ELSE 'N' END ");
				sql.append(" FROM ");
				sql.append(" tbapprovaldoc  ");
				sql.append(" WHERE ");
				sql.append(" companyid IN (SELECT companyid FROM t_nfncompanyidlist WHERE key_value = '").append(sKeyValue1).append("') ");
				sql.append(" AND [status] IN ('C','R') ");
				sql.append(" AND cabinetid = '").append(sMenuId).append("' ");
				sql.append(" AND draftuserid = '").append(sUserId).append("' ");
				sql.append(" AND (subject LIKE '%' + '").append(sSearchText).append("' + '%' OR ");
				sql.append(" documentno LIKE '%' + '").append(sSearchText).append("' + '%' OR ");
				sql.append(" draftusername LIKE '%' + '").append(sSearchText).append("' + '%' ) ");
			}
			else if (sBox.toUpperCase().equals("XA012")) {
				/* 기결문서 상세 */
				sql.append(" SELECT ");
				sql.append(" '").append(sRtnUUID).append("' ");
				sql.append(" ,nfnGetApprovalFileCount(a.documentid) ");
				sql.append(" ,a.documentid ");
				sql.append(" ,a.documentno ");
				sql.append(" ,a.subject + CASE WHEN nfnGetApprovalCommentCount(a.documentid) > 0 THEN '...[☞:' + CAST(nfnGetApprovalCommentCount(a.documentid) AS VARCHAR) + ']' ELSE ''  END "); 
				sql.append(" ,a.contents ");
				sql.append(" ,a.[status] ");
				sql.append(" ,nfnGetCommonCodeName('").append(sCompCode).append("','NA05', [status],'").append(sLangCode).append("') ");
				sql.append(" ,null ");
				sql.append(" ,a.draftdate ");
				sql.append(" ,a.lastsignadate ");
				sql.append(" ,a.draftdate ");
				sql.append(" ,a.draftuserid ");
				sql.append(" ,a.draftusername ");
				sql.append(" ,a.draftuserpos ");
				sql.append(" ,d.dataname ");
				sql.append(" ,(CASE WHEN d.datacode = '@Days' THEN c.datavaluename + '일' ");
				sql.append(" WHEN d.datacode = '@WorkCode' THEN (SELECT workname FROM tbworkcode WHERE workid = c.datavalue) "); 
				sql.append(" WHEN d.datacode = '@HolidayCode' THEN (SELECT holidayname FROM tbworkholidaycode WHERE holidayid = c.datavalue) "); 
				sql.append(" ELSE c.datavalue END) ");
				sql.append(" ,1 "); 
				sql.append(" ,CASE WHEN a.[status] IN ('C','R') THEN 'Y' ELSE 'N' END ");
				sql.append(" FROM ");
				sql.append(" tbapprovaldoc a ");
				sql.append(" INNER JOIN tbapprovaldocline b ON a.documentid = b.documentid AND b.signuserid = '").append(sUserId).append("' ");
				sql.append(" LEFT JOIN tblinkdatacodebyapproval c ON a.documentid = c.documentid "); 
				sql.append(" INNER JOIN tbLinkDataCode d ON c.DataID = d.DataID AND c.companyid = d.companyid ");
				sql.append(" WHERE ");
				sql.append(" a.companyid IN (SELECT companyid FROM t_nfncompanyidlist WHERE key_value = '").append(sKeyValue1).append("') ");
				sql.append(" AND (a.subject LIKE '%' + '").append(sSearchText).append("' + '%' OR ");
				sql.append(" a.documentno LIKE '%' + '").append(sSearchText).append("' + '%' OR ");
				sql.append(" a.draftusername LIKE '%' + '").append(sSearchText).append("' + '%' ) ");
			}
			else if (sBox.toUpperCase().equals("XA013")) {
				/* 진행문서 */
				sql.append(" SELECT ");
				sql.append(" '").append(sRtnUUID).append("' ");
				sql.append(" ,nfnGetApprovalFileCount(a.documentid) ");
				sql.append(" ,a.documentid ");
				sql.append(" ,a.documentno ");
				sql.append(" ,a.subject + CASE WHEN nfnGetApprovalCommentCount(a.documentid) > 0 THEN '...[☞:' + CAST(nfnGetApprovalCommentCount(a.documentid) AS VARCHAR) + ']' ELSE ''  END "); 
				sql.append(" ,a.contents ");
				sql.append(" ,a.[status] ");
				sql.append(" ,nfnGetCommonCodeName('").append(sCompCode).append("','NA05', [status],'").append(sLangCode).append("') ");
				sql.append(" ,null ");
				sql.append(" ,a.draftdate ");
				sql.append(" ,a.lastsignadate ");
				sql.append(" ,a.draftdate ");
				sql.append(" ,a.draftuserid ");
				sql.append(" ,a.draftusername ");
				sql.append(" ,a.draftuserpos ");
				sql.append(" ,'' ");
				sql.append(" ,'' ");
				sql.append(" ,1 "); 
				sql.append(" ,CASE WHEN a.[status] IN ('C','R') THEN 'Y' ELSE 'N' END ");
				sql.append(" FROM ");
				sql.append(" tbapprovaldoc a ");
				sql.append(" INNER JOIN tbapprovaldocline b ON a.documentid = b.documentid AND b.signuserid = '").append(sUserId).append("' ");
				sql.append(" WHERE ");
				sql.append(" a.companyid IN (SELECT companyid FROM t_nfncompanyidlist WHERE key_value = '").append(sKeyValue1).append("') ");
				sql.append(" AND a.[status] = 'B' ");
				sql.append(" AND (a.subject LIKE '%' + '").append(sSearchText).append("' + '%' OR ");
				sql.append(" a.documentno LIKE '%' + '").append(sSearchText).append("' + '%' OR ");
				sql.append(" a.draftusername LIKE '%' + '").append(sSearchText).append("' + '%' ) ");
			}


			pstmt = conn.prepareStatement(sql.toString());

			pstmt.executeUpdate();

			pstmt.close();

			if (sBox.toUpperCase().equals("XA003") || sBox.toUpperCase().equals("XA004") || sBox.toUpperCase().equals("XA011") 
					|| sBox.toUpperCase().equals("XA005") || sBox.toUpperCase().equals("XA006") || sBox.toUpperCase().equals("XA007")
					|| sBox.toUpperCase().equals("XA008") || sBox.toUpperCase().equals("XA009") || sBox.toUpperCase().equals("XA010")
					|| sBox.toUpperCase().equals("XA012") || sBox.toUpperCase().equals("XA013")){

				sql.setLength(0);
				sql.append(" SELECT ");
				sql.append(" nfnDeleteTableByKeyValue('t_nfncompanyidlist', '").append(sKeyValue1).append("') ");
				sql.append(" FROM db_root ");

				
				pstmt = conn.prepareStatement(sql.toString());

				pstmt.executeQuery();

				pstmt.close();
			}

			
			return sRtnUUID;
			
		} catch (Exception e) {
			throw new Exception(e.getMessage());
		} finally {
			if (rs != null) rs.close();
			if (pstmt != null) pstmt.close();
			if (conn != null) conn.close();
		} 
	}

	/* ***********************************  
	함수명   : nfnCompanyIDList  
	입력인자 : 사용자ID, Comp_Code 
	반환값   : 임시테이블에 사용되는 UUID           
	 *********************************** */ 	
	public static String nfnGetGroupCodeByUser(String sUserID, String sCompcode) throws Exception {
		String sRtn = "";

		Connection conn = null;
		PreparedStatement  pstmt = null;
		ResultSet rs = null;

		try{

			Class.forName("cubrid.jdbc.driver.CUBRIDDriver");
			conn = DriverManager.getConnection("jdbc:default:connection");
//			conn = DriverManager.getConnection("jdbc:CUBRID:192.168.1.220:33000:OmegaPlus:::?charSet=utf-8","unilite","UNILITE");

			StringBuffer sql = new StringBuffer();

			sql.append(" SELECT ");
			sql.append(" group_code ");
			sql.append(" FROM  ");
			sql.append(" bsa300t ");
			sql.append(" WHERE ");
			sql.append(" user_id = ").append("'").append(sUserID).append("' ");
			sql.append(" AND comp_code = ").append("'").append(sCompcode).append("' ");
			sql.append(" AND use_yn = 'Y' ");

			pstmt = conn.prepareStatement(sql.toString());

			rs = pstmt.executeQuery();

			while(rs.next()){
				sRtn = rs.getString(1);
			}

			rs.close();
			pstmt.close();

			return sRtn;
			
		} catch (Exception e) {
			throw new Exception(e.getMessage());
		} finally {
			if (rs != null) rs.close();
			if (pstmt != null) pstmt.close();
			if (conn != null) conn.close();
		}
	}


	/** 함수명 : nfnGetLinkDocDocumentNo
	 * @param CompanyID, DocumentID
	 * @return
	 * @throws Exception
	 */
	public static String nfnGetLinkDocDocumentNo(String CompanyID, String DocumentID) throws Exception {
		String sRtnDocumentNo = "";

		Connection  conn = null;
		PreparedStatement pstmt = null;
		ResultSet   rs = null;

		try{
			StringBuffer  sql = new StringBuffer();
			
			Class.forName("cubrid.jdbc.driver.CUBRIDDriver");
			conn = DriverManager.getConnection("jdbc:default:connection");
			//			conn = DriverManager.getConnection("jdbc:CUBRID:192.168.1.220:33000:OmegaPlus:::?charSet=utf-8","unilite","UNILITE");

			sql.setLength(0);
			sql.append("SELECT   NVL(DOCUMENTNO, '') ");
			sql.append("FROM   TBAPPROVALDOC ");
			sql.append("WHERE  COMPANYID =  ?  ");
			sql.append("       AND DOCUMENTID =  ?  ");

			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(1, CompanyID);
			pstmt.setString(2, DocumentID);

			rs = pstmt.executeQuery();

			while(rs.next()){
				sRtnDocumentNo = rs.getString(1);
			}
			
			rs.close();
			pstmt.close();

			return sRtnDocumentNo;
			
		} catch (Exception e) {
			throw new Exception(e.getMessage());
		} finally {
			if (rs != null) rs.close();
			if (pstmt != null) pstmt.close();
			if (conn != null) conn.close();
		}
	}

	/** 함수명 : nfnGetInterfaceForm
	 * @param sCompCode, sGubun, sInterfaceKey
	 * @return
	 * @throws Exception
	 */
	public static String nfnGetInterfaceForm(String sCompCode, String sGubun, String sInterfaceKey) throws  Exception {
		String sRtnUUID = "";

		Connection conn = null;
		PreparedStatement  pstmt = null;
		ResultSet rs = null;
		
		StringBuffer sql = new StringBuffer();
		
		try{
			StringBuffer sContents = new StringBuffer();
			
			int iCodeLevel = 0;
			int iLevelNum1 = 0;
			int iLevelNum2 = 0;
			int iLevelNum3 = 0;
			int iLevelNum4 = 0;
			int iLevelNum5 = 0;
			int iLevelNum6 = 0;
			int iLevelNum7 = 0;
			int iLevelNum8 = 0;
			
			String sBudgCode = "";
			String sBudgCode1 = "";
            String sTempBudgCode = "";
            String sTempBudgCode1 = "";
            int iCnt = 0;
            
            Class.forName("cubrid.jdbc.driver.CUBRIDDriver");
			conn = DriverManager.getConnection("jdbc:default:connection");
//			conn = DriverManager.getConnection("jdbc:CUBRID:192.168.1.220:33000:OmegaPlus:::?charSet=utf-8","unilite","UNILITE");

			

			sql.append(" SELECT ");
			sql.append(" nfngetuniquekey() AS unique_key "); 
			sql.append(" FROM ");
			sql.append(" db_root ");

			pstmt = conn.prepareStatement(sql.toString());

			rs = pstmt.executeQuery();

			while(rs.next()){
				sRtnUUID = rs.getString(1);
			}

			rs.close();    
			pstmt.close();
			
			
			sql.setLength(0);
			sql.append(" SELECT ");
			sql.append(" CODE_LEVEL ");
			sql.append(" ,LEVEL_NUM1 ");
			sql.append(" ,LEVEL_NUM2 ");
			sql.append(" ,LEVEL_NUM3 ");
			sql.append(" ,LEVEL_NUM4 ");
			sql.append(" ,LEVEL_NUM5 ");
			sql.append(" ,LEVEL_NUM6 ");
			sql.append(" ,LEVEL_NUM7 ");
			sql.append(" ,LEVEL_NUM8 ");
			sql.append(" FROM "); 
			sql.append(" afb300t ");
			sql.append(" WHERE comp_code = '").append(sCompCode).append("' ");
			sql.append(" AND base_code = '01' ");
			sql.append(" AND ac_yyyy = CAST(YEAR(SYSTIMESTAMP) AS VARCHAR) ");
			
            pstmt = conn.prepareStatement(sql.toString());
            
            rs = pstmt.executeQuery();
            
            while(rs.next()){
            	iCodeLevel = rs.getInt(1);
            	iLevelNum1 = rs.getInt(2);
            	iLevelNum2 = rs.getInt(3);
            	iLevelNum3 = rs.getInt(4);
            	iLevelNum4 = rs.getInt(5);
            	iLevelNum5 = rs.getInt(6);
            	iLevelNum6 = rs.getInt(7);
            	iLevelNum7 = rs.getInt(8);
            	iLevelNum8 = rs.getInt(9);
            }

            rs.close();
            pstmt.close();
			
			
			if (sGubun.equals("1")){//지출
				
				sContents.setLength(0); 
				sContents.append(" <table border=\"1\" cellpadding=\"3px\" cellspacing=\"0\" style=\"border-collapse:collapse; width:1000px\"> ");
				sContents.append(" <tbody> ");
				sContents.append(" <tr> ");
				sContents.append(" <td style=\"text-align:center;\"><b>지출명</b></td> ");
				sContents.append(" <td style=\"text-align:center;\"><b>예산과목</b></td> ");
				sContents.append(" <td style=\"text-align:center;\"><b>부문</b></td> ");
				sContents.append(" <td style=\"text-align:center;\"><b>세부사업</b></td> ");
				sContents.append(" <td style=\"text-align:center;\"><b>세목</b></td> ");
				sContents.append(" <td style=\"text-align:center;\"><b>거래처</b></td> ");
				sContents.append(" <td style=\"text-align:center;\"><b>현지화금액</b></td> ");
				sContents.append(" <td style=\"text-align:center;\"><b>외화금액</b></td> ");
				sContents.append(" </tr> ");
	            
	            sql.setLength(0);
				sql.append(" SELECT ");
				sql.append(" A.TITLE ");  									// 지출명
				sql.append(" ,A1.BUDG_CODE "); 								// 예산과목
				sql.append(" ,NVL(B.BUDG_NAME, '')    AS BUDG_NAME_1 ");	//부문
				sql.append(" ,NVL(C.BUDG_NAME, '')    AS BUDG_NAME_3 ");	//세부사업
				sql.append(" ,NVL(D.BUDG_NAME, '')    AS BUDG_NAME_6 ");	//세목
				sql.append(" ,NVL(A1.CUSTOM_NAME, '') AS CUSTOM_NAME ");  	// 거래처코드
				sql.append(" ,FORMAT(NVL(A1.TOT_AMT_I, 0), 2) AS TOT_AMT_I ");  		// 현지화금액
				sql.append(" ,FORMAT(NVL(A1.LOC_AMT_I, 0), 2) AS LOC_AMT_I ");  		// 외화금액
				sql.append(" FROM "); 
				sql.append(" AFB700T A ");
				sql.append(" INNER JOIN AFB710T A1 ON A1.COMP_CODE = A.COMP_CODE AND A1.PAY_DRAFT_NO = A.PAY_DRAFT_NO ");
				sql.append(" LEFT JOIN AFB400T B ON B.COMP_CODE = A.COMP_CODE AND B.AC_YYYY   = SUBSTRING(A.PAY_DATE,1,4) AND B.BUDG_CODE = SUBSTRING(A1.BUDG_CODE,1,3) ");
				sql.append(" LEFT JOIN AFB400T C ON C.COMP_CODE = A.COMP_CODE AND C.AC_YYYY   = SUBSTRING(A.PAY_DATE,1,4) AND C.BUDG_CODE = SUBSTRING(A1.BUDG_CODE,1,11) "); 
				sql.append(" LEFT JOIN AFB400T D ON D.COMP_CODE = A.COMP_CODE AND D.AC_YYYY   = SUBSTRING(A.PAY_DATE,1,4) AND D.BUDG_CODE = A1.BUDG_CODE ");
				sql.append(" WHERE  A.pay_draft_no = '").append(sInterfaceKey).append("' "); 

	            pstmt = conn.prepareStatement(sql.toString());
	            
	            rs = pstmt.executeQuery();
	            
	            while(rs.next()){
	            	sBudgCode = rs.getString(2);

	            	sTempBudgCode = "";
	            	iCnt = iCnt + 1;
	            
	            	if (iCodeLevel > 0){
	    				if (iCodeLevel >= 1 && iLevelNum1 != 0){
	    					sTempBudgCode = sBudgCode.substring(0, iLevelNum1);
	    				}
	    		
    					if (iCodeLevel >= 2 && iLevelNum2 != 0){
    						sTempBudgCode = sTempBudgCode + '-' + sBudgCode.substring(iLevelNum1 , iLevelNum1 + iLevelNum2);
    					}
    			
    					if (iCodeLevel >= 3 && iLevelNum3 != 0){
    						sTempBudgCode = sTempBudgCode + '-' + sBudgCode.substring(iLevelNum1 + iLevelNum2, iLevelNum1 + iLevelNum2 + iLevelNum3);
    					}
    			
    					if (iCodeLevel >= 4 && iLevelNum4 != 0){
    						sTempBudgCode = sTempBudgCode + '-' + sBudgCode.substring(iLevelNum1 + iLevelNum2 + iLevelNum3, iLevelNum1 + iLevelNum2 + iLevelNum3 + iLevelNum4);
    					}
    			
    					if (iCodeLevel >= 5 && iLevelNum5 != 0){
    						sTempBudgCode = sTempBudgCode + '-' + sBudgCode.substring(iLevelNum1 + iLevelNum2 + iLevelNum3 + iLevelNum4, iLevelNum1 + iLevelNum2 + iLevelNum3 + iLevelNum4 + iLevelNum5);
    					}
    			
    					if (iCodeLevel >= 6 && iLevelNum6 != 0){
    						sTempBudgCode = sTempBudgCode + '-' + sBudgCode.substring(iLevelNum1 + iLevelNum2 + iLevelNum3 + iLevelNum4 + iLevelNum5, iLevelNum1 + iLevelNum2 + iLevelNum3 + iLevelNum4 + iLevelNum5 + iLevelNum6);
    					}
    			
    					if (iCodeLevel >= 7 && iLevelNum7 != 0){
    						sTempBudgCode = sTempBudgCode + '-' + sBudgCode.substring(iLevelNum1 + iLevelNum2 + iLevelNum3 + iLevelNum4 + iLevelNum5 + iLevelNum6, iLevelNum1 + iLevelNum2 + iLevelNum3 + iLevelNum4 + iLevelNum5 + iLevelNum6 + iLevelNum7);
    					}
    			
    					if (iCodeLevel >= 8 && iLevelNum8 != 0){
    						sTempBudgCode = sTempBudgCode + '-' + sBudgCode.substring(iLevelNum1 + iLevelNum2 + iLevelNum3 + iLevelNum4 + iLevelNum5 + iLevelNum6 + iLevelNum7, iLevelNum1 + iLevelNum2 + iLevelNum3 + iLevelNum4 + iLevelNum5 + iLevelNum6 + iLevelNum7 + iLevelNum8);
    					}
    			
	            	}
	            
	            	sContents.append(" <tr> ");
	            	sContents.append(" <td> ").append(rs.getString(1)).append(" </td> ");
	            	sContents.append(" <td> ").append(sTempBudgCode).append(" </td> ");
	            	sContents.append(" <td> ").append(rs.getString(3)).append(" </td> ");
	            	sContents.append(" <td> ").append(rs.getString(4)).append(" </td> ");
	            	sContents.append(" <td> ").append(rs.getString(5)).append(" </td> ");
	            	sContents.append(" <td> ").append(rs.getString(6)).append(" </td> ");
	            	sContents.append(" <td> ").append(rs.getString(7)).append(" </td> ");
	            	sContents.append(" <td> ").append(rs.getString(8)).append(" </td> ");
	            	sContents.append(" </tr> ");
	            
	            }
		            
	            rs.close();
	            pstmt.close();
	            
	            if (iCnt == 0){
	            	sContents.append(" <tr> " );
	            	sContents.append(" <td>&nbsp;</td> ");
	            	sContents.append(" <td>&nbsp;</td> ");
	            	sContents.append(" <td>&nbsp;</td> ");
	            	sContents.append(" <td>&nbsp;</td> ");
	            	sContents.append(" <td>&nbsp;</td> ");
	            	sContents.append(" <td>&nbsp;</td> ");
	            	sContents.append(" <td>&nbsp;</td> ");
	            	sContents.append(" <td>&nbsp;</td> ");
	            	sContents.append(" </tr> " );
	            }
	            
	            sContents.append(" </tbody> ");
	            sContents.append(" </table> ");
			}
			else if (sGubun.equals("2")){//수입

				sContents.setLength(0); 
				sContents.append(" <table border=\"1\" cellpadding=\"3px\" cellspacing=\"0\" style=\"border-collapse:collapse; width:1000px\"> ");
				sContents.append(" <tbody> ");
				sContents.append(" <tr> ");
				sContents.append(" <td style=\"text-align:center;\"><b>타이틀</b></td> ");
				sContents.append(" <td style=\"text-align:center;\"><b>입금일자</b></td> ");
				sContents.append(" <td style=\"text-align:center;\"><b>입금액</b></td> ");
				sContents.append(" <td style=\"text-align:center;\"><b>예산과목</b></td> ");
				sContents.append(" <td style=\"text-align:center;\"><b>예산명</b></td> ");
				sContents.append(" <td style=\"text-align:center;\"><b>실입금일</b></td> ");
				sContents.append(" <td style=\"text-align:center;\"><b>입금계좌</b></td> ");
				sContents.append(" <td style=\"text-align:center;\"><b>계좌번호</b></td> ");
				sContents.append(" <td style=\"text-align:center;\"><b>적요</b></td> ");
				sContents.append(" </tr> ");
	            
	            sql.setLength(0);
				sql.append(" SELECT "); 
				sql.append(" NVL(A.TITLE, '') ");      // 타이틀
				sql.append(" ,NVL(TO_CHAR(TO_DATE(A.IN_DATE, 'yyyymmdd'), 'yyyy-mm-dd'), '') ");   // 입급일자
				sql.append(" ,NVL(B.COMP_CODE, '') "); // 법인코드
				sql.append(" ,FORMAT(NVL(B.IN_AMT_I, 0), 2) ");  // 입금액
				sql.append(" ,NVL(B.BUDG_CODE, '') "); // 예산과목
				sql.append(" ,NVL(C.BUDG_NAME, '') "); // 예산명
				sql.append(" ,NVL(TO_CHAR(TO_DATE(B.INOUT_DATE, 'yyyymmdd'), 'yyyy-mm-dd'), '') ");// 실입금일
				sql.append(" ,NVL(D.SAVE_NAME, '')  ");  // 입금계좌
				sql.append(" ,NVL(B.BANK_NUM, '')  "); // 계좌번호
				sql.append(" ,NVL(B.REMARK, '')  ");   // 적요 
				sql.append(" FROM AFB800T A ");
				sql.append(" INNER JOIN AFB810T B ON B.COMP_CODE = A.COMP_CODE AND B.IN_DRAFT_NO = A.IN_DRAFT_NO ");
				sql.append(" LEFT JOIN AFB400T C ON C.COMP_CODE = B.COMP_CODE AND C.AC_YYYY = SUBSTRING(A.IN_DATE,1,4)  AND C.BUDG_CODE = B.BUDG_CODE ");                                            
				sql.append(" LEFT JOIN afs100t D ON D.COMP_CODE = A.COMP_CODE AND A.DEPT_CODE = D.DEPT_CODE  AND B.ACCT_NO = D.SAVE_CODE ");
				sql.append(" WHERE A.COMP_CODE  = '").append(sCompCode).append("' ");
				sql.append(" AND a.in_draft_no = '").append(sInterfaceKey).append("' "); 

	            pstmt = conn.prepareStatement(sql.toString());
	            
	            rs = pstmt.executeQuery();
	            
	            while(rs.next()){
	            	sBudgCode = rs.getString(5);

	            	sTempBudgCode = "";
	            	iCnt = iCnt + 1;
	            
	            	if (iCodeLevel > 0){
	    				if (iCodeLevel >= 1 && iLevelNum1 != 0){
	    					sTempBudgCode = sBudgCode.substring(0, iLevelNum1);
	    				}
	    		
    					if (iCodeLevel >= 2 && iLevelNum2 != 0){
    						sTempBudgCode = sTempBudgCode + '-' + sBudgCode.substring(iLevelNum1 , iLevelNum1 + iLevelNum2);
    					}
    			
    					if (iCodeLevel >= 3 && iLevelNum3 != 0){
    						sTempBudgCode = sTempBudgCode + '-' + sBudgCode.substring(iLevelNum1 + iLevelNum2, iLevelNum1 + iLevelNum2 + iLevelNum3);
    					}
    			
    					if (iCodeLevel >= 4 && iLevelNum4 != 0){
    						sTempBudgCode = sTempBudgCode + '-' + sBudgCode.substring(iLevelNum1 + iLevelNum2 + iLevelNum3, iLevelNum1 + iLevelNum2 + iLevelNum3 + iLevelNum4);
    					}
    			
    					if (iCodeLevel >= 5 && iLevelNum5 != 0){
    						sTempBudgCode = sTempBudgCode + '-' + sBudgCode.substring(iLevelNum1 + iLevelNum2 + iLevelNum3 + iLevelNum4, iLevelNum1 + iLevelNum2 + iLevelNum3 + iLevelNum4 + iLevelNum5);
    					}
    			
    					if (iCodeLevel >= 6 && iLevelNum6 != 0){
    						sTempBudgCode = sTempBudgCode + '-' + sBudgCode.substring(iLevelNum1 + iLevelNum2 + iLevelNum3 + iLevelNum4 + iLevelNum5, iLevelNum1 + iLevelNum2 + iLevelNum3 + iLevelNum4 + iLevelNum5 + iLevelNum6);
    					}
    			
    					if (iCodeLevel >= 7 && iLevelNum7 != 0){
    						sTempBudgCode = sTempBudgCode + '-' + sBudgCode.substring(iLevelNum1 + iLevelNum2 + iLevelNum3 + iLevelNum4 + iLevelNum5 + iLevelNum6, iLevelNum1 + iLevelNum2 + iLevelNum3 + iLevelNum4 + iLevelNum5 + iLevelNum6 + iLevelNum7);
    					}
    			
    					if (iCodeLevel >= 8 && iLevelNum8 != 0){
    						sTempBudgCode = sTempBudgCode + '-' + sBudgCode.substring(iLevelNum1 + iLevelNum2 + iLevelNum3 + iLevelNum4 + iLevelNum5 + iLevelNum6 + iLevelNum7, iLevelNum1 + iLevelNum2 + iLevelNum3 + iLevelNum4 + iLevelNum5 + iLevelNum6 + iLevelNum7 + iLevelNum8);
    					}
    			
	            	}
	            
	            	sContents.append(" <tr> ");
	            	sContents.append(" <td> ").append(rs.getString(1)).append(" </td> ");
	            	sContents.append(" <td> ").append(rs.getString(2)).append(" </td> ");
	            	sContents.append(" <td> ").append(rs.getString(4)).append(" </td> ");
	            	sContents.append(" <td> ").append(sTempBudgCode).append(" </td> ");
	            	sContents.append(" <td> ").append(rs.getString(6)).append(" </td> ");
	            	sContents.append(" <td> ").append(rs.getString(7)).append(" </td> ");
	            	sContents.append(" <td> ").append(rs.getString(8)).append(" </td> ");
	            	sContents.append(" <td> ").append(rs.getString(9)).append(" </td> ");
	            	sContents.append(" <td> ").append(rs.getString(10)).append(" </td> ");
	            	sContents.append(" </tr> ");
	            
	            }
		            
	            rs.close();
	            pstmt.close();
	            
	            if (iCnt == 0){
	            	sContents.append(" <tr> " );
	            	sContents.append(" <td>&nbsp;</td> ");
	            	sContents.append(" <td>&nbsp;</td> ");
	            	sContents.append(" <td>&nbsp;</td> ");
	            	sContents.append(" <td>&nbsp;</td> ");
	            	sContents.append(" <td>&nbsp;</td> ");
	            	sContents.append(" <td>&nbsp;</td> ");
	            	sContents.append(" <td>&nbsp;</td> ");
	            	sContents.append(" <td>&nbsp;</td> ");
	            	sContents.append(" <td>&nbsp;</td> ");
	            	sContents.append(" </tr> " );
	            }
	            
	            sContents.append(" </tbody> ");
	            sContents.append(" </table> ");
			}
			else if (sGubun.equals("3")){//정정
				sContents.setLength(0); 
				sContents.append(" <table border=\"1\" cellpadding=\"3px\" cellspacing=\"0\" style=\"border-collapse:collapse; width:1000px\"> ");
				sContents.append(" <tbody> ");
				sContents.append(" <tr> ");
				sContents.append(" <td style=\"text-align:center;\"><b>정정및반납일자</b></td> ");
				sContents.append(" <td style=\"text-align:center;\"><b>원인행위</b></td> ");
				sContents.append(" <td style=\"text-align:center;\"><b>예산과목</b></td> ");
				sContents.append(" <td style=\"text-align:center;\"><b>부문</b></td> ");
				sContents.append(" <td style=\"text-align:center;\"><b>세부사업</b></td> ");
				sContents.append(" <td style=\"text-align:center;\"><b>세목</b></td> ");
				sContents.append(" <td style=\"text-align:center;\"><b>정정금액</b></td> ");
				sContents.append(" <td style=\"text-align:center;\"><b>적요</b></td> ");
				sContents.append(" </tr> ");
	            
	            sql.setLength(0);
				sql.append(" SELECT ");
				sql.append(" NVL(A.COMP_CODE, '') ");
				sql.append(" , NVL(TO_CHAR(TO_DATE(A.EX_DATE, 'yyyymmdd'), 'yyyy-mm-dd'), '') ");    // 정정및반납일자 
				sql.append(" , NVL(E.CODE_NAME, '') "); 						 // 원인행위 
				sql.append(" , NVL(A.BUDG_CODE, '') ");   					 // 예산과목 
				sql.append(" , NVL(B.BUDG_NAME, '') AS BUDG_NAME_1 "); 		 // 부문
				sql.append(" , NVL(C.BUDG_NAME, '') AS BUDG_NAME_3 "); 		 // 세부사업
				sql.append(" , NVL(D.BUDG_NAME, '') AS BUDG_NAME_6 ");		 // 세목
				sql.append(" , FORMAT(NVL(A.REF_EX_AMT, 0), 2) ");   					 // 
				sql.append(" , NVL(TO_CHAR(TO_DATE(A.REF_EX_DATE, 'yyyymmdd'), 'yyyy-mm-dd'), '') ");//  
				sql.append(" , FORMAT(NVL(A.EX_AMT, 0), 2) ");  						 // 정정금액 
				sql.append(" , NVL(A.REMARK, '')  ");						 // 적요 
				sql.append(" FROM AFB730T A ");
				sql.append("  LEFT JOIN AFB400T B ON B.COMP_CODE = A.COMP_CODE "); 
				sql.append("  AND B.AC_YYYY   = SUBSTRING(A.EX_DATE,1,4) ");
				sql.append("  AND B.BUDG_CODE = SUBSTRING(A.BUDG_CODE,1,3) ");
				sql.append("  LEFT JOIN AFB400T C ON C.COMP_CODE = A.COMP_CODE  ");
				sql.append("  AND C.AC_YYYY   = SUBSTRING(A.EX_DATE,1,4) ");
				sql.append("  AND C.BUDG_CODE = SUBSTRING(A.BUDG_CODE,1,11)  ");
				sql.append("  LEFT JOIN AFB400T D ON D.COMP_CODE = A.COMP_CODE  ");
				sql.append("  AND D.AC_YYYY   = SUBSTRING(A.EX_DATE,1,4) ");
				sql.append("  AND D.BUDG_CODE = A.BUDG_CODE ");
				sql.append("  LEFT JOIN bsa100t E ON A.COMP_CODE = E.COMP_CODE  ");
				sql.append("  AND A.AC_TYPE = E.SUB_CODE AND E.MAIN_CODE = 'A402'  ");
				sql.append("  WHERE  A.doc_no = '").append(sInterfaceKey).append("' ");  

	            pstmt = conn.prepareStatement(sql.toString());
	            
	            rs = pstmt.executeQuery();
	            
	            while(rs.next()){
	            	sBudgCode = rs.getString(4);

	            	sTempBudgCode = "";
	            	iCnt = iCnt + 1;
	            
	            	if (iCodeLevel > 0){
	    				if (iCodeLevel >= 1 && iLevelNum1 != 0){
	    					sTempBudgCode = sBudgCode.substring(0, iLevelNum1);
	    				}
	    		
    					if (iCodeLevel >= 2 && iLevelNum2 != 0){
    						sTempBudgCode = sTempBudgCode + '-' + sBudgCode.substring(iLevelNum1 , iLevelNum1 + iLevelNum2);
    					}
    			
    					if (iCodeLevel >= 3 && iLevelNum3 != 0){
    						sTempBudgCode = sTempBudgCode + '-' + sBudgCode.substring(iLevelNum1 + iLevelNum2, iLevelNum1 + iLevelNum2 + iLevelNum3);
    					}
    			
    					if (iCodeLevel >= 4 && iLevelNum4 != 0){
    						sTempBudgCode = sTempBudgCode + '-' + sBudgCode.substring(iLevelNum1 + iLevelNum2 + iLevelNum3, iLevelNum1 + iLevelNum2 + iLevelNum3 + iLevelNum4);
    					}
    			
    					if (iCodeLevel >= 5 && iLevelNum5 != 0){
    						sTempBudgCode = sTempBudgCode + '-' + sBudgCode.substring(iLevelNum1 + iLevelNum2 + iLevelNum3 + iLevelNum4, iLevelNum1 + iLevelNum2 + iLevelNum3 + iLevelNum4 + iLevelNum5);
    					}
    			
    					if (iCodeLevel >= 6 && iLevelNum6 != 0){
    						sTempBudgCode = sTempBudgCode + '-' + sBudgCode.substring(iLevelNum1 + iLevelNum2 + iLevelNum3 + iLevelNum4 + iLevelNum5, iLevelNum1 + iLevelNum2 + iLevelNum3 + iLevelNum4 + iLevelNum5 + iLevelNum6);
    					}
    			
    					if (iCodeLevel >= 7 && iLevelNum7 != 0){
    						sTempBudgCode = sTempBudgCode + '-' + sBudgCode.substring(iLevelNum1 + iLevelNum2 + iLevelNum3 + iLevelNum4 + iLevelNum5 + iLevelNum6, iLevelNum1 + iLevelNum2 + iLevelNum3 + iLevelNum4 + iLevelNum5 + iLevelNum6 + iLevelNum7);
    					}
    			
    					if (iCodeLevel >= 8 && iLevelNum8 != 0){
    						sTempBudgCode = sTempBudgCode + '-' + sBudgCode.substring(iLevelNum1 + iLevelNum2 + iLevelNum3 + iLevelNum4 + iLevelNum5 + iLevelNum6 + iLevelNum7, iLevelNum1 + iLevelNum2 + iLevelNum3 + iLevelNum4 + iLevelNum5 + iLevelNum6 + iLevelNum7 + iLevelNum8);
    					}
    			
	            	}
	            
	            	sContents.append(" <tr> ");
	            	sContents.append(" <td> ").append(rs.getString(2)).append(" </td> ");
	            	sContents.append(" <td> ").append(rs.getString(3)).append(" </td> ");
	            	sContents.append(" <td> ").append(sTempBudgCode).append(" </td> ");
	            	sContents.append(" <td> ").append(rs.getString(5)).append(" </td> ");
	            	sContents.append(" <td> ").append(rs.getString(6)).append(" </td> ");
	            	sContents.append(" <td> ").append(rs.getString(7)).append(" </td> ");
	            	sContents.append(" <td> ").append(rs.getString(10)).append(" </td> ");
	            	sContents.append(" <td> ").append(rs.getString(11)).append(" </td> ");
	            	sContents.append(" </tr> ");
	            
	            }
		            
	            rs.close();
	            pstmt.close();
	            
	            if (iCnt == 0){
	            	sContents.append(" <tr> " );
	            	sContents.append(" <td>&nbsp;</td> ");
	            	sContents.append(" <td>&nbsp;</td> ");
	            	sContents.append(" <td>&nbsp;</td> ");
	            	sContents.append(" <td>&nbsp;</td> ");
	            	sContents.append(" <td>&nbsp;</td> ");
	            	sContents.append(" <td>&nbsp;</td> ");
	            	sContents.append(" <td>&nbsp;</td> ");
	            	sContents.append(" <td>&nbsp;</td> ");
	            	sContents.append(" </tr> " );
	            }
	            
	            sContents.append(" </tbody> ");
	            sContents.append(" </table> ");
			}
			else if (sGubun.equals("4")){//세목조정
				sContents.setLength(0);
				sContents.append(" <table border=\"1\" cellpadding=\"3px\" cellspacing=\"0\" style=\"border-collapse:collapse; width:1000px\"> ");
				sContents.append(" <tbody> ");
				sContents.append(" <tr> ");
				sContents.append(" <td style=\"text-align:center;\"><b>예산과목</b></td> ");
				sContents.append(" <td style=\"text-align:center;\"><b>부문</b></td> ");
				sContents.append(" <td style=\"text-align:center;\"><b>세부사업</b></td> ");
				sContents.append(" <td style=\"text-align:center;\"><b>세목</b></td> ");
				sContents.append(" <td style=\"text-align:center;\"><b>세목조정월</b></td> ");
				sContents.append(" <td style=\"text-align:center;\"><b>세목조정 예산과목</b></td> ");
				sContents.append(" <td style=\"text-align:center;\"><b>세목조정할 예산명</b></td> ");
				sContents.append(" <td style=\"text-align:center;\"><b>세목조정금액(현지화)</b></td> ");
				sContents.append(" <td style=\"text-align:center;\"><b>적요(현지화)</b></td> ");
				sContents.append(" </tr> ");
	            
	            sql.setLength(0);
				sql.append(" SELECT ");
				sql.append(" NVL(A.BUDG_CODE, '') ");
				sql.append(" , NVL(B.BUDG_NAME,'')    AS BUDG_NAME_1 ");     				//부문
				sql.append(" , NVL(C.BUDG_NAME,'')    AS BUDG_NAME_3 ");     				//세부사업        
				sql.append(" , NVL(D.BUDG_NAME,'')    AS BUDG_NAME_6 ");     				//세목
				sql.append(" , NVL(TO_CHAR(TO_DATE(A.DIVERT_YYYYMM, 'yyyymm'), 'yyyy-mm'), '') ");  	// 세목조정월
				sql.append(" , NVL(A.DIVERT_BUDG_CODE, '') ");   									// 세목조정 예산과목
				sql.append(" , NVL(E.BUDG_NAME, '')   AS DIVERT_BUDG_NAME "); 				//세목조정할 예산명
				sql.append(" , FORMAT(NVL(A.DIVERT_BUDG_I, 0), 2) ");    										// 세목조정금액(현지화)
				sql.append(" , NVL(A.REMARK, '') ");         										// 적요
				sql.append(" FROM ");
				sql.append(" AFB520T A ");  
				sql.append(" LEFT JOIN AFB400T B ON B.COMP_CODE = A.COMP_CODE AND B.AC_YYYY = SUBSTRING(A.BUDG_YYYYMM,1,4) AND B.BUDG_CODE = SUBSTRING(A.BUDG_CODE,1,3) ");
				sql.append(" LEFT JOIN AFB400T C ON C.COMP_CODE = A.COMP_CODE AND C.AC_YYYY = SUBSTRING(A.BUDG_YYYYMM,1,4) AND C.BUDG_CODE = SUBSTRING(A.BUDG_CODE,1,11)  ");
				sql.append(" LEFT JOIN AFB400T D ON D.COMP_CODE = A.COMP_CODE AND D.AC_YYYY = SUBSTRING(A.BUDG_YYYYMM,1,4) AND D.BUDG_CODE = A.BUDG_CODE ");
				sql.append(" LEFT JOIN AFB400T E ON E.COMP_CODE = A.COMP_CODE AND E.AC_YYYY   = SUBSTRING(A.BUDG_YYYYMM,1,4) AND E.BUDG_CODE = A.DIVERT_BUDG_CODE ");
				sql.append(" WHERE A.DOC_NO = '").append(sInterfaceKey).append("' ");  

	            pstmt = conn.prepareStatement(sql.toString());
	            
	            rs = pstmt.executeQuery();
	            
	            while(rs.next()){
	            	sBudgCode = rs.getString(1);
	            	sBudgCode1 = rs.getString(6);

	            	sTempBudgCode = "";
	            	sTempBudgCode1 = "";
	            	iCnt = iCnt + 1;
	            
	            	if (iCodeLevel > 0){
	    				if (iCodeLevel >= 1 && iLevelNum1 != 0){
	    					sTempBudgCode = sBudgCode.substring(0, iLevelNum1);
	    					sTempBudgCode1 = sBudgCode1.substring(0, iLevelNum1);
	    				}
	    		
    					if (iCodeLevel >= 2 && iLevelNum2 != 0){
    						sTempBudgCode = sTempBudgCode + '-' + sBudgCode.substring(iLevelNum1 , iLevelNum1 + iLevelNum2);
    						sTempBudgCode1 = sTempBudgCode1 + '-' + sBudgCode1.substring(iLevelNum1 , iLevelNum1 + iLevelNum2);
    					}
    			
    					if (iCodeLevel >= 3 && iLevelNum3 != 0){
    						sTempBudgCode = sTempBudgCode + '-' + sBudgCode.substring(iLevelNum1 + iLevelNum2, iLevelNum1 + iLevelNum2 + iLevelNum3);
    						sTempBudgCode1 = sTempBudgCode1 + '-' + sBudgCode1.substring(iLevelNum1 + iLevelNum2, iLevelNum1 + iLevelNum2 + iLevelNum3);
    					}
    			
    					if (iCodeLevel >= 4 && iLevelNum4 != 0){
    						sTempBudgCode = sTempBudgCode + '-' + sBudgCode.substring(iLevelNum1 + iLevelNum2 + iLevelNum3, iLevelNum1 + iLevelNum2 + iLevelNum3 + iLevelNum4);
    						sTempBudgCode1 = sTempBudgCode1 + '-' + sBudgCode1.substring(iLevelNum1 + iLevelNum2 + iLevelNum3, iLevelNum1 + iLevelNum2 + iLevelNum3 + iLevelNum4);
    					}
    			
    					if (iCodeLevel >= 5 && iLevelNum5 != 0){
    						sTempBudgCode = sTempBudgCode + '-' + sBudgCode.substring(iLevelNum1 + iLevelNum2 + iLevelNum3 + iLevelNum4, iLevelNum1 + iLevelNum2 + iLevelNum3 + iLevelNum4 + iLevelNum5);
    						sTempBudgCode1 = sTempBudgCode1 + '-' + sBudgCode1.substring(iLevelNum1 + iLevelNum2 + iLevelNum3 + iLevelNum4, iLevelNum1 + iLevelNum2 + iLevelNum3 + iLevelNum4 + iLevelNum5);
    					}
    			
    					if (iCodeLevel >= 6 && iLevelNum6 != 0){
    						sTempBudgCode = sTempBudgCode + '-' + sBudgCode.substring(iLevelNum1 + iLevelNum2 + iLevelNum3 + iLevelNum4 + iLevelNum5, iLevelNum1 + iLevelNum2 + iLevelNum3 + iLevelNum4 + iLevelNum5 + iLevelNum6);
    						sTempBudgCode1 = sTempBudgCode1 + '-' + sBudgCode1.substring(iLevelNum1 + iLevelNum2 + iLevelNum3 + iLevelNum4 + iLevelNum5, iLevelNum1 + iLevelNum2 + iLevelNum3 + iLevelNum4 + iLevelNum5 + iLevelNum6);
    					}
    			
    					if (iCodeLevel >= 7 && iLevelNum7 != 0){
    						sTempBudgCode = sTempBudgCode + '-' + sBudgCode.substring(iLevelNum1 + iLevelNum2 + iLevelNum3 + iLevelNum4 + iLevelNum5 + iLevelNum6, iLevelNum1 + iLevelNum2 + iLevelNum3 + iLevelNum4 + iLevelNum5 + iLevelNum6 + iLevelNum7);
    						sTempBudgCode1 = sTempBudgCode1 + '-' + sBudgCode1.substring(iLevelNum1 + iLevelNum2 + iLevelNum3 + iLevelNum4 + iLevelNum5 + iLevelNum6, iLevelNum1 + iLevelNum2 + iLevelNum3 + iLevelNum4 + iLevelNum5 + iLevelNum6 + iLevelNum7);
    					}
    			
    					if (iCodeLevel >= 8 && iLevelNum8 != 0){
    						sTempBudgCode = sTempBudgCode + '-' + sBudgCode.substring(iLevelNum1 + iLevelNum2 + iLevelNum3 + iLevelNum4 + iLevelNum5 + iLevelNum6 + iLevelNum7, iLevelNum1 + iLevelNum2 + iLevelNum3 + iLevelNum4 + iLevelNum5 + iLevelNum6 + iLevelNum7 + iLevelNum8);
    						sTempBudgCode1 = sTempBudgCode1 + '-' + sBudgCode1.substring(iLevelNum1 + iLevelNum2 + iLevelNum3 + iLevelNum4 + iLevelNum5 + iLevelNum6 + iLevelNum7, iLevelNum1 + iLevelNum2 + iLevelNum3 + iLevelNum4 + iLevelNum5 + iLevelNum6 + iLevelNum7 + iLevelNum8);
    					}
    			
	            	}
	            
	            	sContents.append(" <tr> ");
	            	sContents.append(" <td> ").append(sTempBudgCode).append(" </td> ");
	            	sContents.append(" <td> ").append(rs.getString(2)).append(" </td> ");
	            	sContents.append(" <td> ").append(rs.getString(3)).append(" </td> ");
	            	sContents.append(" <td> ").append(rs.getString(4)).append(" </td> ");
	            	sContents.append(" <td> ").append(rs.getString(5)).append(" </td> ");
	            	sContents.append(" <td> ").append(sTempBudgCode1).append(" </td> ");
	            	sContents.append(" <td> ").append(rs.getString(7)).append(" </td> ");
	            	sContents.append(" <td> ").append(rs.getString(8)).append(" </td> ");
	            	sContents.append(" <td> ").append(rs.getString(9)).append(" </td> ");
	            	sContents.append(" </tr> ");
	            
	            }
		            
	            rs.close();
	            pstmt.close();
	            
	            if (iCnt == 0){
	            	sContents.append(" <tr> " );
	            	sContents.append(" <td>&nbsp;</td> ");
	            	sContents.append(" <td>&nbsp;</td> ");
	            	sContents.append(" <td>&nbsp;</td> ");
	            	sContents.append(" <td>&nbsp;</td> ");
	            	sContents.append(" <td>&nbsp;</td> ");
	            	sContents.append(" <td>&nbsp;</td> ");
	            	sContents.append(" <td>&nbsp;</td> ");
	            	sContents.append(" <td>&nbsp;</td> ");
	            	sContents.append(" <td>&nbsp;</td> ");
	            	sContents.append(" </tr> " );
	            }
	            
	            sContents.append(" </tbody> ");
	            sContents.append(" </table> ");

		     
			}
			else if (sGubun.equals("5")){//이체
				sContents.setLength(0); 
				sContents.append(" <table border=\"1\" cellpadding=\"3px\" cellspacing=\"0\" style=\"border-collapse:collapse; width:1000px\"> ");
				sContents.append(" <tbody> ");
				sContents.append(" <tr> ");
				sContents.append(" <td style=\"text-align:center;\"><b>이체결의일자</b></td> ");
				sContents.append(" <td style=\"text-align:center;\"><b>예산과목</b></td> ");
				sContents.append(" <td style=\"text-align:center;\"><b>부문</b></td> ");
				sContents.append(" <td style=\"text-align:center;\"><b>세부사업</b></td> ");
				sContents.append(" <td style=\"text-align:center;\"><b>세목</b></td> ");
				sContents.append(" <td style=\"text-align:center;\"><b>화폐단위</b></td> ");
				sContents.append(" <td style=\"text-align:center;\"><b>환율</b></td> ");
				sContents.append(" <td style=\"text-align:center;\"><b>금액(외화)</b></td> ");
				sContents.append(" <td style=\"text-align:center;\"><b>금액(현지화)</b></td> ");
				sContents.append(" <td style=\"text-align:center;\"><b>이체계좌 (+)</b></td> ");
				sContents.append(" <td style=\"text-align:center;\"><b>본계좌(-)</b></td> ");
				sContents.append(" <td style=\"text-align:center;\"><b>적요</b></td> ");
				sContents.append(" </tr> ");
	            
	            sql.setLength(0);
				sql.append(" SELECT "); 
				sql.append(" NVL(TO_CHAR(TO_DATE(A.EX_DATE, 'yyyymmdd'), 'yyyy-mm-dd'), '') ");  	// 이체결의 일자
				sql.append(" ,NVL(A.BUDG_CODE, '') ");  						// 예산과목 
				sql.append(" ,NVL(B.BUDG_NAME, '')    AS BUDG_NAME_1 ");		//부문
				sql.append(" ,NVL(C.BUDG_NAME, '')    AS BUDG_NAME_3 ");		//세부사업
				sql.append(" ,NVL(D.BUDG_NAME, '')    AS BUDG_NAME_6 ");		//세목
				sql.append(" ,NVL(A.CURR_UNIT, '') ");   					// 화폐단위
				sql.append(" ,NVL(A.CURR_RATE, 0) ");  						//  환율
				sql.append(" ,FORMAT(NVL(A.CURR_AMT, 0), 2) ");  						// 금액(외화)
				sql.append(" ,FORMAT(NVL(A.EX_AMT, 0), 2) ");     						// 금액(현지화)
				sql.append(" ,NVL(E.SAVE_NAME, '') ");  						// 이체계좌 (+)
				sql.append(" ,NVL(E2.SAVE_NAME, '')   AS REF_SAVE_NAME"); 	//  본계좌(-)
				sql.append(" ,NVL(A.REMARK, '') ");   						// 적요 
				sql.append(" FROM AFB740T A ");  
				sql.append(" LEFT JOIN AFB400T B ON B.COMP_CODE = A.COMP_CODE AND B.AC_YYYY   = SUBSTRING(A.EX_DATE,1,4) AND B.BUDG_CODE = SUBSTRING(A.BUDG_CODE,1,3) ");
				sql.append(" LEFT JOIN AFB400T C ON C.COMP_CODE = A.COMP_CODE AND C.AC_YYYY   = SUBSTRING(A.EX_DATE,1,4) AND C.BUDG_CODE = SUBSTRING(A.BUDG_CODE,1,11) "); 
				sql.append(" LEFT JOIN AFB400T D ON D.COMP_CODE = A.COMP_CODE AND D.AC_YYYY   = SUBSTRING(A.EX_DATE,1,4) AND D.BUDG_CODE = A.BUDG_CODE ");
				sql.append(" LEFT JOIN AFS100T E ON E.COMP_CODE = A.COMP_CODE AND E.DEPT_CODE = A.DEPT_CODE AND E.SAVE_CODE = A.ACCT_NO ");
				sql.append(" LEFT JOIN AFS100T E2 ON E2.COMP_CODE = A.COMP_CODE AND E2.DEPT_CODE = A.DEPT_CODE AND E2.SAVE_CODE = A.REF_ACCT_NO ");
				sql.append(" WHERE A.doc_no = '").append(sInterfaceKey).append("' "); 

	            pstmt = conn.prepareStatement(sql.toString());
	            
	            rs = pstmt.executeQuery();
	            
	            while(rs.next()){
	            	sBudgCode = rs.getString(2);

	            	sTempBudgCode = "";
	            	iCnt = iCnt + 1;
	            
	            	if (iCodeLevel > 0){
	    				if (iCodeLevel >= 1 && iLevelNum1 != 0){
	    					sTempBudgCode = sBudgCode.substring(0, iLevelNum1);
	    				}
	    		
    					if (iCodeLevel >= 2 && iLevelNum2 != 0){
    						sTempBudgCode = sTempBudgCode + '-' + sBudgCode.substring(iLevelNum1 , iLevelNum1 + iLevelNum2);
    					}
    			
    					if (iCodeLevel >= 3 && iLevelNum3 != 0){
    						sTempBudgCode = sTempBudgCode + '-' + sBudgCode.substring(iLevelNum1 + iLevelNum2, iLevelNum1 + iLevelNum2 + iLevelNum3);
    					}
    			
    					if (iCodeLevel >= 4 && iLevelNum4 != 0){
    						sTempBudgCode = sTempBudgCode + '-' + sBudgCode.substring(iLevelNum1 + iLevelNum2 + iLevelNum3, iLevelNum1 + iLevelNum2 + iLevelNum3 + iLevelNum4);
    					}
    			
    					if (iCodeLevel >= 5 && iLevelNum5 != 0){
    						sTempBudgCode = sTempBudgCode + '-' + sBudgCode.substring(iLevelNum1 + iLevelNum2 + iLevelNum3 + iLevelNum4, iLevelNum1 + iLevelNum2 + iLevelNum3 + iLevelNum4 + iLevelNum5);
    					}
    			
    					if (iCodeLevel >= 6 && iLevelNum6 != 0){
    						sTempBudgCode = sTempBudgCode + '-' + sBudgCode.substring(iLevelNum1 + iLevelNum2 + iLevelNum3 + iLevelNum4 + iLevelNum5, iLevelNum1 + iLevelNum2 + iLevelNum3 + iLevelNum4 + iLevelNum5 + iLevelNum6);
    					}
    			
    					if (iCodeLevel >= 7 && iLevelNum7 != 0){
    						sTempBudgCode = sTempBudgCode + '-' + sBudgCode.substring(iLevelNum1 + iLevelNum2 + iLevelNum3 + iLevelNum4 + iLevelNum5 + iLevelNum6, iLevelNum1 + iLevelNum2 + iLevelNum3 + iLevelNum4 + iLevelNum5 + iLevelNum6 + iLevelNum7);
    					}
    			
    					if (iCodeLevel >= 8 && iLevelNum8 != 0){
    						sTempBudgCode = sTempBudgCode + '-' + sBudgCode.substring(iLevelNum1 + iLevelNum2 + iLevelNum3 + iLevelNum4 + iLevelNum5 + iLevelNum6 + iLevelNum7, iLevelNum1 + iLevelNum2 + iLevelNum3 + iLevelNum4 + iLevelNum5 + iLevelNum6 + iLevelNum7 + iLevelNum8);
    					}
    			
	            	}
	            
	            	sContents.append(" <tr> ");
	            	sContents.append(" <td> ").append(rs.getString(1)).append(" </td> ");
	            	sContents.append(" <td> ").append(sTempBudgCode).append(" </td> ");
	            	sContents.append(" <td> ").append(rs.getString(3)).append(" </td> ");
	            	sContents.append(" <td> ").append(rs.getString(4)).append(" </td> ");
	            	sContents.append(" <td> ").append(rs.getString(5)).append(" </td> ");
	            	sContents.append(" <td> ").append(rs.getString(6)).append(" </td> ");
	            	sContents.append(" <td> ").append(String.valueOf(rs.getDouble(7))).append(" </td> ");
	            	sContents.append(" <td> ").append(rs.getString(8)).append(" </td> ");
	            	sContents.append(" <td> ").append(rs.getString(9)).append(" </td> ");
	            	sContents.append(" <td> ").append(rs.getString(10)).append(" </td> ");
	            	sContents.append(" <td> ").append(rs.getString(11)).append(" </td> ");
	            	sContents.append(" <td> ").append(rs.getString(12)).append(" </td> ");
	            	sContents.append(" </tr> ");
	            
	            }
		            
	            rs.close();
	            pstmt.close();
	            
	            if (iCnt == 0){
	            	sContents.append(" <tr> " );
	            	sContents.append(" <td>&nbsp;</td> ");
	            	sContents.append(" <td>&nbsp;</td> ");
	            	sContents.append(" <td>&nbsp;</td> ");
	            	sContents.append(" <td>&nbsp;</td> ");
	            	sContents.append(" <td>&nbsp;</td> ");
	            	sContents.append(" <td>&nbsp;</td> ");
	            	sContents.append(" <td>&nbsp;</td> ");
	            	sContents.append(" <td>&nbsp;</td> ");
	            	sContents.append(" <td>&nbsp;</td> ");
	            	sContents.append(" <td>&nbsp;</td> ");
	            	sContents.append(" <td>&nbsp;</td> ");
	            	sContents.append(" <td>&nbsp;</td> ");
	            	sContents.append(" </tr> " );
	            }
	            
	            sContents.append(" </tbody> ");
	            sContents.append(" </table> ");
			}
			else if (sGubun.equals("6")){//이월
				sContents.setLength(0); 
				sContents.append(" <table border=\"1\" cellpadding=\"3px\" cellspacing=\"0\" style=\"border-collapse:collapse; width:1000px\"> ");
				sContents.append(" <tbody> ");
				sContents.append(" <tr> ");
				sContents.append(" <td style=\"text-align:center;\"><b>구분</b></td> ");
				sContents.append(" <td style=\"text-align:center;\"><b>예산과목</b></td> ");
				sContents.append(" <td style=\"text-align:center;\"><b>부문</b></td> ");
				sContents.append(" <td style=\"text-align:center;\"><b>세부사업</b></td> ");
				sContents.append(" <td style=\"text-align:center;\"><b>세목</b></td> ");
				sContents.append(" <td style=\"text-align:center;\"><b>이월년월</b></td> ");
				sContents.append(" <td style=\"text-align:center;\"><b>이월금액</b></td> ");
				sContents.append(" </tr> ");
	            
	            sql.setLength(0);
				sql.append(" SELECT "); 
				sql.append(" NVL(CASE WHEN A.BUDG_GUBUN = '2' THEN '이월' ");  // 2: 이월 , 3: 불용액  으로 보여주기 
				sql.append("      WHEN A.BUDG_GUBUN = '3' THEN '불용액' ");  
				sql.append("      ELSE '' END, '') ");  
				sql.append(" ,NVL(A.BUDG_CODE, '') ");
				sql.append(" ,NVL(B.BUDG_NAME, '')    AS BUDG_NAME_1 ");//부문
				sql.append(" ,NVL(C.BUDG_NAME, '')    AS BUDG_NAME_3 ");//세부사업
				sql.append(" ,NVL(D.BUDG_NAME, '')    AS BUDG_NAME_6 ");//세목
				sql.append(" ,NVL(TO_CHAR(TO_DATE(A.IWALL_YYYYMM, 'yyyymm'), 'yyyy-mm'), '') ");  // 이월년월 
				sql.append(" ,FORMAT(NVL(A.IWALL_AMT_I, 0), 2) ");    				// 이월금액
				sql.append(" FROM AFB530T A ");
				sql.append(" LEFT JOIN AFB400T B ON B.COMP_CODE = A.COMP_CODE AND B.AC_YYYY   = SUBSTRING(A.IWALL_YYYYMM,1,4) AND B.BUDG_CODE = SUBSTRING(A.BUDG_CODE,1,3) ");
				sql.append(" LEFT JOIN AFB400T C ON C.COMP_CODE = A.COMP_CODE AND C.AC_YYYY   = SUBSTRING(A.IWALL_YYYYMM,1,4) AND C.BUDG_CODE = SUBSTRING(A.BUDG_CODE,1,11) "); 
				sql.append(" LEFT JOIN AFB400T D ON D.COMP_CODE = A.COMP_CODE AND D.AC_YYYY   = SUBSTRING(A.IWALL_YYYYMM,1,4) AND D.BUDG_CODE = A.BUDG_CODE ");
				sql.append(" WHERE  a.doc_no = '").append(sInterfaceKey).append("' "); 

	            pstmt = conn.prepareStatement(sql.toString());
	            
	            rs = pstmt.executeQuery();
	            
	            while(rs.next()){
	            	sBudgCode = rs.getString(2);

	            	sTempBudgCode = "";
	            	iCnt = iCnt + 1;
	            
	            	if (iCodeLevel > 0){
	    				if (iCodeLevel >= 1 && iLevelNum1 != 0){
	    					sTempBudgCode = sBudgCode.substring(0, iLevelNum1);
	    				}
	    		
    					if (iCodeLevel >= 2 && iLevelNum2 != 0){
    						sTempBudgCode = sTempBudgCode + '-' + sBudgCode.substring(iLevelNum1 , iLevelNum1 + iLevelNum2);
    					}
    			
    					if (iCodeLevel >= 3 && iLevelNum3 != 0){
    						sTempBudgCode = sTempBudgCode + '-' + sBudgCode.substring(iLevelNum1 + iLevelNum2, iLevelNum1 + iLevelNum2 + iLevelNum3);
    					}
    			
    					if (iCodeLevel >= 4 && iLevelNum4 != 0){
    						sTempBudgCode = sTempBudgCode + '-' + sBudgCode.substring(iLevelNum1 + iLevelNum2 + iLevelNum3, iLevelNum1 + iLevelNum2 + iLevelNum3 + iLevelNum4);
    					}
    			
    					if (iCodeLevel >= 5 && iLevelNum5 != 0){
    						sTempBudgCode = sTempBudgCode + '-' + sBudgCode.substring(iLevelNum1 + iLevelNum2 + iLevelNum3 + iLevelNum4, iLevelNum1 + iLevelNum2 + iLevelNum3 + iLevelNum4 + iLevelNum5);
    					}
    			
    					if (iCodeLevel >= 6 && iLevelNum6 != 0){
    						sTempBudgCode = sTempBudgCode + '-' + sBudgCode.substring(iLevelNum1 + iLevelNum2 + iLevelNum3 + iLevelNum4 + iLevelNum5, iLevelNum1 + iLevelNum2 + iLevelNum3 + iLevelNum4 + iLevelNum5 + iLevelNum6);
    					}
    			
    					if (iCodeLevel >= 7 && iLevelNum7 != 0){
    						sTempBudgCode = sTempBudgCode + '-' + sBudgCode.substring(iLevelNum1 + iLevelNum2 + iLevelNum3 + iLevelNum4 + iLevelNum5 + iLevelNum6, iLevelNum1 + iLevelNum2 + iLevelNum3 + iLevelNum4 + iLevelNum5 + iLevelNum6 + iLevelNum7);
    					}
    			
    					if (iCodeLevel >= 8 && iLevelNum8 != 0){
    						sTempBudgCode = sTempBudgCode + '-' + sBudgCode.substring(iLevelNum1 + iLevelNum2 + iLevelNum3 + iLevelNum4 + iLevelNum5 + iLevelNum6 + iLevelNum7, iLevelNum1 + iLevelNum2 + iLevelNum3 + iLevelNum4 + iLevelNum5 + iLevelNum6 + iLevelNum7 + iLevelNum8);
    					}
    			
	            	}
	            
	            	sContents.append(" <tr> ");
	            	sContents.append(" <td> ").append(rs.getString(1)).append(" </td> ");
	            	sContents.append(" <td> ").append(sTempBudgCode).append(" </td> ");
	            	sContents.append(" <td> ").append(rs.getString(3)).append(" </td> ");
	            	sContents.append(" <td> ").append(rs.getString(4)).append(" </td> ");
	            	sContents.append(" <td> ").append(rs.getString(5)).append(" </td> ");
	            	sContents.append(" <td> ").append(rs.getString(6)).append(" </td> ");
	            	sContents.append(" <td> ").append(rs.getString(7)).append(" </td> ");
	            	sContents.append(" </tr> ");
	            
	            }
		            
	            rs.close();
	            pstmt.close();
	            
	            if (iCnt == 0){
	            	sContents.append(" <tr> " );
	            	sContents.append(" <td>&nbsp;</td> ");
	            	sContents.append(" <td>&nbsp;</td> ");
	            	sContents.append(" <td>&nbsp;</td> ");
	            	sContents.append(" <td>&nbsp;</td> ");
	            	sContents.append(" <td>&nbsp;</td> ");
	            	sContents.append(" <td>&nbsp;</td> ");
	            	sContents.append(" <td>&nbsp;</td> ");
	            	sContents.append(" </tr> " );
	            }
	            
	            sContents.append(" </tbody> ");
	            sContents.append(" </table> ");
			}
			
			sql.setLength(0);
			sql.append(" INSERT INTO t_nfngetinterfaceform ");
			sql.append(" ( ");
			sql.append(" key_value ");
			sql.append(" ,formid ");
			sql.append(" ,contents ");
			sql.append(" ) ");
			sql.append(" SELECT ");
			sql.append(" '").append(sRtnUUID).append("' ");
			sql.append(" ,a.formid ");
			sql.append(" ,REPLACE(a.contents, '@TABLE1','").append(sContents.toString()).append("') ");
			sql.append(" FROM  ");
			sql.append(" tbapprovalform a ");
			sql.append(" INNER JOIN bsa100t b ON a.companyid = b.comp_code AND a.formid = b.ref_code1 AND b.main_code = 'NZ09' ");
			sql.append(" WHERE a.companyid = '").append(sCompCode).append("' ");  
			sql.append(" AND b.sub_code = '").append(sGubun).append("' ");

			pstmt = conn.prepareStatement(sql.toString());

			pstmt.executeUpdate();

			pstmt.close();
			
			return sRtnUUID;
			
		} catch (Exception e) {
			throw new Exception(e.getMessage());
		} finally {
			if (rs != null) rs.close();
			if (pstmt != null) pstmt.close();
			if (conn != null) conn.close();
		}
	}
	
	/** 함수명 : nfnTestForm
	 * @param sCompCode
	 * @return
	 * @throws Exception
	 */
	public static String nfnTestForm() throws  Exception {
		String sRtnUUID = "";

		Connection conn = null;
		PreparedStatement  pstmt = null;
		ResultSet rs = null;
 
		try{
			Class.forName("cubrid.jdbc.driver.CUBRIDDriver");
			//conn = DriverManager.getConnection("jdbc:default:connection");
			//conn = DriverManager.getConnection("jdbc:CUBRID:192.168.1.220:33000:OmegaPlus:::?charSet=utf-8","unilite","UNILITE");

			sRtnUUID = "test";

			return sRtnUUID;
			
		} catch (Exception e) {
			throw new Exception(e.getMessage());
		} finally {
			if (rs != null) rs.close();
			if (pstmt != null) pstmt.close();
			if (conn != null) conn.close();
		}
	}
	
	/** 함수명 : nfnGetLinkDocDraftDate
	 * @param CompanyID, DocumentID
	 * @return
	 * @throws Exception
	 */
	public static String nfnGetLinkDocDraftDate(String CompanyID, String DocumentID) throws Exception {
		String sRtnDraftDate = "";

		Connection  conn = null;
		PreparedStatement pstmt = null;
		ResultSet   rs = null;
		
		try{
			Class.forName("cubrid.jdbc.driver.CUBRIDDriver");
			conn = DriverManager.getConnection("jdbc:default:connection");
			//			conn = DriverManager.getConnection("jdbc:CUBRID:192.168.1.220:33000:OmegaPlus:::?charSet=utf-8","unilite","UNILITE");

			StringBuffer  sql = new StringBuffer();
			
			sql.setLength(0);
			sql.append("SELECT  NVL(TO_CHAR(DRAFTDATE, 'YYYY-MM-DD'), '') ");
			sql.append("FROM   TBAPPROVALDOC ");
			sql.append("WHERE  COMPANYID =  ?  ");
			sql.append("       AND DOCUMENTID =  ?  ");

			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(1, CompanyID);
			pstmt.setString(2, DocumentID);

			rs = pstmt.executeQuery();

			while(rs.next()){
				sRtnDraftDate = rs.getString(1);
			}
			
			rs.close();
			pstmt.close();

			return sRtnDraftDate;
			
		} catch (Exception e) {
			throw new Exception(e.getMessage());
		} finally {
			if (rs != null) rs.close();
			if (pstmt != null) pstmt.close();
			if (conn != null) conn.close();
		}
		

	}

	/** 함수명 : nfnGetLinkDocSignImage206
	 * @param CompanyID, DocumentID, Seq
	 * @return
	 * @throws Exception
	 */
	public static String nfnGetLinkDocSignImage206(String CompanyID, String DocumentID, int Seq) throws Exception{
		String sRtnSignImage = "";

		String SignImageUrl = "";
		String Status = "";
		String SignImageFullUrl = "";
		String SignUserID = "";
		String SignUserName = "";
		String SignUserPosName = "";
		String SignDate = "";

		Connection  conn = null;
		ResultSet   rs = null;
		PreparedStatement pstmt = null;
		StringBuffer  sql = new StringBuffer();

		try{
			Class.forName("cubrid.jdbc.driver.CUBRIDDriver");
			conn = DriverManager.getConnection("jdbc:default:connection");
			//			conn = DriverManager.getConnection("jdbc:CUBRID:192.168.1.220:33000:OmegaPlus:::?charSet=utf-8","unilite","UNILITE");

			sql.setLength(0);
			sql.append("SELECT Max(aa.SIGNIMAGEURL) 															");
			sql.append("       ,Max(aa.STATUS) 																	");
			sql.append("       ,Max(aa.SIGNUSERID) 																");
			sql.append("       ,Max(aa.SIGNDATE) 																");
			sql.append("FROM  (SELECT NVL(CASE 																	");
			sql.append("                    WHEN ROW_NUMBER() 													");
			sql.append("                           OVER ( 														");
			sql.append("                             ORDER BY SEQ ) = 6 THEN SIGNIMGURL 						");
			sql.append("                    ELSE '' 															");
			sql.append("                  END, '')  SignImageUrl 												");
			sql.append("              ,NVL(CASE 																");
			sql.append("                     WHEN ROW_NUMBER() 													");
			sql.append("                            OVER ( 														");
			sql.append("                              ORDER BY SEQ ) = 6 THEN STATUS 							");
			sql.append("                     ELSE '' 															");
			sql.append("                   END, '') AS Status 													");
			sql.append("              ,NVL(CASE 																");
			sql.append("                     WHEN ROW_NUMBER() 													");
			sql.append("                            OVER ( 														");
			sql.append("                              ORDER BY SEQ ) = 6 THEN SIGNUSERID 						");
			sql.append("                     ELSE '' 															");
			sql.append("                   END, '') SignUserID 													");
			sql.append("              ,NVL(CASE 																");
			sql.append("                     WHEN ROW_NUMBER() 													");
			sql.append("                            OVER ( 														");
			sql.append("                              ORDER BY SEQ ) = 6 THEN TO_CHAR(SIGNDATE, 'YYYY-MM-DD') 	");
			sql.append("                     ELSE '' 															");
			sql.append("                   END, '') SignDate 													");
			sql.append("       FROM   TBAPPROVALDOCLINE 														");
			sql.append("       WHERE  DOCUMENTID =  ?   														");
			sql.append("              AND LINETYPE = 'B') aa													");

			pstmt = conn.prepareStatement(sql.toString());
			pstmt.setString(1, DocumentID);

			rs = pstmt.executeQuery();

			while(rs.next()){
				SignImageUrl = rs.getString(1);
				Status = rs.getString(2);
				SignUserID = rs.getString(3);
				SignDate = rs.getString(4);
			}
			rs.close();
			pstmt.close();

			if(SignDate == null || SignDate.equals("")){
				SignDate = "";
			}


			sql.setLength(0);
			sql.append("SELECT NVL(nfnGetUserName( ? ,  ? ), '') 	");
			sql.append("FROM   DB_ROOT								");

			pstmt = conn.prepareStatement(sql.toString());
			pstmt.setString(1, CompanyID);
			pstmt.setString(2, SignUserID);

			rs = pstmt.executeQuery();

			while(rs.next()){
				SignUserName = rs.getString(1);
			}
			rs.close();
			pstmt.close();


			sql.setLength(0);
			sql.append("SELECT NVL(nfnGetUserPosName( ?  ,  ? , 'ko'), '') 		");
			sql.append("FROM   DB_ROOT											");

			pstmt = conn.prepareStatement(sql.toString());
			pstmt.setString(1, CompanyID);
			pstmt.setString(2, SignUserID);

			rs = pstmt.executeQuery();

			while(rs.next()){
				SignUserPosName = rs.getString(1);
			}
			rs.close();
			pstmt.close();


			String tmpStatus = "";
			if(Status == "C"){
				if (SignImageUrl == null || SignImageUrl.equals("")){
					tmpStatus = "X0007";
				}else {
					tmpStatus = SignImageUrl;
				}
			}else if (Status == "R"){
				tmpStatus = "X0006";
			}else{
				tmpStatus = "X0005";
			}

			SignImageFullUrl = "/nboxfile/myinfosign/" + tmpStatus ;


			if(SignUserID == null || SignUserID.equals("")){
				SignImageFullUrl = "";
			}

			sql.setLength(0);
			sql.append("SELECT nfnGetLinkDocSignStyle( ? ) 				");
			sql.append("FROM   DB_ROOT									");

			pstmt = conn.prepareStatement(sql.toString());
			pstmt.setString(1, CompanyID);

			rs = pstmt.executeQuery();

			while(rs.next()){
				sRtnSignImage = rs.getString(1);
			}
			rs.close();
			pstmt.close();

			sRtnSignImage = sRtnSignImage.replace("@SIGNUSERNAME@", SignUserName + " " + SignUserPosName);
			sRtnSignImage = sRtnSignImage.replace("@SIGNIMAGEURL@", SignImageFullUrl);
			sRtnSignImage = sRtnSignImage.replace("@SIGNDATE@", SignDate);

			return sRtnSignImage;
			
		} catch (Exception e) {
			throw new Exception(e.getMessage());
		} finally {
			if (rs != null) rs.close();
			if (pstmt != null) pstmt.close();
			if (conn != null) conn.close();
		}	
	}


	/** 함수명 : nfnGetLinkDocSignImage205
	 * @param CompanyID, DocumentID, Seq
	 * @return
	 * @throws Exception
	 */
	public static String nfnGetLinkDocSignImage205(String CompanyID, String DocumentID, int Seq) throws Exception{
		String sRtnSignImage = "";

		Connection  conn = null;
		PreparedStatement pstmt = null;
		ResultSet   rs = null;
		
		try{
			String SignImageUrl = "";
			String Status = "";
			String SignImageFullUrl = "";
			String SignUserID = "";
			String SignUserName = "";
			String SignUserPosName = "";
			String SignDate = "";
			String tmpStatus = "";

			StringBuffer  sql = new StringBuffer();
			
			Class.forName("cubrid.jdbc.driver.CUBRIDDriver");
			conn = DriverManager.getConnection("jdbc:default:connection");
			//			conn = DriverManager.getConnection("jdbc:CUBRID:192.168.1.220:33000:OmegaPlus:::?charSet=utf-8","unilite","UNILITE");

			sql.setLength(0);
			sql.append("SELECT Max(aa.SIGNIMAGEURL)  																");
			sql.append("       ,Max(aa.STATUS)   																	");
			sql.append("       ,Max(aa.SIGNUSERID)   																");
			sql.append("       ,Max(aa.SIGNDATE)   																	");
			sql.append("FROM  (SELECT NVL(CASE   																	");
			sql.append("                    WHEN ROW_NUMBER()   													");
			sql.append("                           OVER (   														");
			sql.append("                             ORDER BY SEQ ) = 5 THEN SIGNIMGURL   							");
			sql.append("                    ELSE ''   																");
			sql.append("                  END, '')  SignImageUrl   													");
			sql.append("              ,NVL(CASE   																	");
			sql.append("                     WHEN ROW_NUMBER()   													");
			sql.append("                            OVER (   														");
			sql.append("                              ORDER BY SEQ ) = 5 THEN STATUS   								");
			sql.append("                     ELSE ''   																");
			sql.append("                   END, '') AS Status   													");
			sql.append("              ,NVL(CASE   																	");
			sql.append("                     WHEN ROW_NUMBER()   													");
			sql.append("                            OVER ( 															");
			sql.append("                              ORDER BY SEQ ) = 5 THEN SIGNUSERID 							");
			sql.append("                     ELSE '' 																");
			sql.append("                   END, '') SignUserID 														");
			sql.append("              ,NVL(CASE 																	");
			sql.append("                     WHEN ROW_NUMBER() 														");
			sql.append("                            OVER ( 															");
			sql.append("                              ORDER BY SEQ ) = 5 THEN TO_CHAR(SIGNDATE, 'YYYY-MM-DD') 		");
			sql.append("                     ELSE '' 																");
			sql.append("                   END, '') SignDate 														");
			sql.append("       FROM   TBAPPROVALDOCLINE 															");
			sql.append("       WHERE  DOCUMENTID =  ?   															");
			sql.append("              AND LINETYPE = 'B') aa														");

			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(1, DocumentID);

			rs = pstmt.executeQuery();

			while(rs.next()){
				SignImageUrl = rs.getString(1);
				Status = rs.getString(2);
				SignUserID = rs.getString(3);
				SignDate = rs.getString(4);
			}
			
			rs.close();
			pstmt.close();

			if(SignDate == null || SignDate.equals("")){
				SignDate = "";
			}

			sql.setLength(0);
			sql.append("SELECT NVL(nfnGetUserName( ?  ,  ?  ), '') 	");
			sql.append("FROM   DB_ROOT								");

			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(1, CompanyID);
			pstmt.setString(2, SignUserID);

			rs = pstmt.executeQuery();

			while(rs.next()){
				SignUserName = rs.getString(1);
			}
			
			rs.close();
			pstmt.close();

			sql.setLength(0);
			sql.append("SELECT NVL(nfnGetUserPosName( ?  ,  ?  , 'ko'), '') 	");
			sql.append("FROM   DB_ROOT											");

			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(1, CompanyID);
			pstmt.setString(2, SignUserID);

			rs = pstmt.executeQuery();

			while(rs.next()){
				SignUserPosName = rs.getString(1);
			}
			
			rs.close();
			pstmt.close();

			if(Status == "C"){
				if (SignImageUrl == null || SignImageUrl.equals("")){
					tmpStatus = "X0007";
				}else {
					tmpStatus = SignImageUrl;
				}
			}else if (Status == "R"){
				tmpStatus = "X0006";
			}else{
				tmpStatus = "X0005";
			}

			SignImageFullUrl = "/nboxfile/myinfosign/" + tmpStatus ;

			if(SignUserID == null || SignUserID.equals("")){
				SignImageFullUrl = "";
			}

			sql.setLength(0);
			sql.append("SELECT nfnGetLinkDocSignStyle( ?  ) 	");
			sql.append("FROM   DB_ROOT							");

			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(1, CompanyID);

			rs = pstmt.executeQuery();

			while(rs.next()){
				sRtnSignImage = rs.getString(1);
			}
			
			rs.close();
			pstmt.close();

			sRtnSignImage = sRtnSignImage.replace("@SIGNUSERNAME@", SignUserName + " " + SignUserPosName);
			sRtnSignImage = sRtnSignImage.replace("@SIGNIMAGEURL@", SignImageFullUrl);
			sRtnSignImage = sRtnSignImage.replace("@SIGNDATE@", SignDate);

			return sRtnSignImage;
			
		} catch (Exception e) {
			throw new Exception(e.getMessage());
		} finally {
			if (rs != null) rs.close();
			if (pstmt != null) pstmt.close();
			if (conn != null) conn.close();
		}
	}


	/** 함수명 : nfnGetLinkDocSignImage204
	 * @param CompanyID, DocumentID, Seq
	 * @return
	 * @throws Exception
	 */
	public static String nfnGetLinkDocSignImage204(String CompanyID, String DocumentID, int Seq) throws Exception{
		String sRtnSignImage = "";

		Connection  conn = null;
		PreparedStatement pstmt = null;
		ResultSet   rs = null;
		
		try{
			String SignImageUrl = "";
			String Status = "";
			String SignImageFullUrl = "";
			String SignUserID = "";
			String SignUserName = "";
			String SignUserPosName = "";
			String SignDate = "";
			String tmpStatus = "";
			
			StringBuffer  sql = new StringBuffer();
			
			Class.forName("cubrid.jdbc.driver.CUBRIDDriver");
			conn = DriverManager.getConnection("jdbc:default:connection");
			//			conn = DriverManager.getConnection("jdbc:CUBRID:192.168.1.220:33000:OmegaPlus:::?charSet=utf-8","unilite","UNILITE");

			sql.setLength(0);
			sql.append("SELECT Max(aa.SIGNIMAGEURL) ");
			sql.append("       ,Max(aa.STATUS) ");
			sql.append("       ,Max(aa.SIGNUSERID) ");
			sql.append("       ,Max(aa.SIGNDATE) ");
			sql.append("FROM  (SELECT NVL(CASE ");
			sql.append("                    WHEN ROW_NUMBER() ");
			sql.append("                           OVER ( ");
			sql.append("                             ORDER BY SEQ ) = 4 THEN SIGNIMGURL ");
			sql.append("                    ELSE '' ");
			sql.append("                  END, '')  SignImageUrl ");
			sql.append("              ,NVL(CASE ");
			sql.append("                     WHEN ROW_NUMBER() ");
			sql.append("                            OVER ( ");
			sql.append("                              ORDER BY SEQ ) = 4 THEN STATUS ");
			sql.append("                     ELSE '' ");
			sql.append("                   END, '') AS Status ");
			sql.append("              ,NVL(CASE ");
			sql.append("                     WHEN ROW_NUMBER() ");
			sql.append("                            OVER ( ");
			sql.append("                              ORDER BY SEQ ) = 4 THEN SIGNUSERID ");
			sql.append("                     ELSE '' ");
			sql.append("                   END, '') SignUserID ");
			sql.append("              ,NVL(CASE ");
			sql.append("                     WHEN ROW_NUMBER() ");
			sql.append("                            OVER ( ");
			sql.append("                              ORDER BY SEQ ) = 4 THEN TO_CHAR(SIGNDATE, 'YYYY-MM-DD') ");
			sql.append("                     ELSE '' ");
			sql.append("                   END, '') SignDate ");
			sql.append("       FROM   TBAPPROVALDOCLINE ");
			sql.append("       WHERE  DOCUMENTID =  ?   ");
			sql.append("              AND LINETYPE = 'B') aa");

			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(1, DocumentID);

			rs = pstmt.executeQuery();

			while(rs.next()){
				SignImageUrl = rs.getString(1);
				Status = rs.getString(2);
				SignUserID = rs.getString(3);
				SignDate = rs.getString(4);
			}
			
			rs.close();
			pstmt.close();

			if(SignDate == null || SignDate.equals("")){
				SignDate = "";
			}

			sql.setLength(0);
			sql.append("SELECT NVL(nfnGetUserName( ?  ,  ?  ), '') ");
			sql.append("FROM   DB_ROOT");

			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(1, CompanyID);
			pstmt.setString(2, SignUserID);

			rs = pstmt.executeQuery();

			while(rs.next()){
				SignUserName = rs.getString(1);
			}
			
			rs.close();
			pstmt.close();

			sql.setLength(0);
			sql.append("SELECT NVL(nfnGetUserPosName( ?  ,  ?  , 'ko'), '') 	");
			sql.append("FROM   DB_ROOT											");

			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(1, CompanyID);
			pstmt.setString(2, SignUserID);

			rs = pstmt.executeQuery();

			while(rs.next()){
				SignUserPosName = rs.getString(1);
			}
			
			rs.close();
			pstmt.close();

			if(Status == "C"){
				if (SignImageUrl == null || SignImageUrl.equals("")){
					tmpStatus = "X0007";
				}else {
					tmpStatus = SignImageUrl;
				}
			}else if (Status == "R"){
				tmpStatus = "X0006";
			}else{
				tmpStatus = "X0005";
			}

			SignImageFullUrl = "/nboxfile/myinfosign/" + tmpStatus ;


			if(SignUserID == null || SignUserID.equals("")){
				SignImageFullUrl = "";
			}

			sql.setLength(0);
			sql.append("SELECT nfnGetLinkDocSignStyle( ?  ) 	");
			sql.append("FROM   DB_ROOT							");

			pstmt = conn.prepareStatement(sql.toString());
			pstmt.setString(1, CompanyID);

			rs = pstmt.executeQuery();

			while(rs.next()){
				sRtnSignImage = rs.getString(1);
			}
			rs.close();
			pstmt.close();

			sRtnSignImage = sRtnSignImage.replace("@SIGNUSERNAME@", SignUserName + " " + SignUserPosName);
			sRtnSignImage = sRtnSignImage.replace("@SIGNIMAGEURL@", SignImageFullUrl);
			sRtnSignImage = sRtnSignImage.replace("@SIGNDATE@", SignDate);
			
			return sRtnSignImage;

		} catch (Exception e) {
			throw new Exception(e.getMessage());
		} finally {
			if (rs != null) rs.close();
			if (pstmt != null) pstmt.close();
			if (conn != null) conn.close();
		}
	}


	/** 함수명 : nfnGetLinkDocSignImage203
	 * @param CompanyID, DocumentID, Seq
	 * @return
	 * @throws Exception
	 */
	public static String nfnGetLinkDocSignImage203(String CompanyID, String DocumentID, int Seq) throws Exception{
		String sRtnSignImage = "";
		
		Connection  conn = null;
		PreparedStatement pstmt = null;
		ResultSet   rs = null;

		try{
			String SignImageUrl = "";
			String Status = "";
			String SignImageFullUrl = "";
			String SignUserID = "";
			String SignUserName = "";
			String SignUserPosName = "";
			String SignDate = "";
			String tmpStatus = "";

			StringBuffer  sql = new StringBuffer();
			
			Class.forName("cubrid.jdbc.driver.CUBRIDDriver");
			conn = DriverManager.getConnection("jdbc:default:connection");
			//			conn = DriverManager.getConnection("jdbc:CUBRID:192.168.1.220:33000:OmegaPlus:::?charSet=utf-8","unilite","UNILITE");

			sql.setLength(0);
			sql.append("SELECT Max(aa.SIGNIMAGEURL) ");
			sql.append("       ,Max(aa.STATUS) ");
			sql.append("       ,Max(aa.SIGNUSERID) ");
			sql.append("       ,Max(aa.SIGNDATE) ");
			sql.append("FROM  (SELECT NVL(CASE ");
			sql.append("                    WHEN ROW_NUMBER() ");
			sql.append("                           OVER ( ");
			sql.append("                             ORDER BY SEQ ) = 3 THEN SIGNIMGURL ");
			sql.append("                    ELSE '' ");
			sql.append("                  END, '')  SignImageUrl ");
			sql.append("              ,NVL(CASE ");
			sql.append("                     WHEN ROW_NUMBER() ");
			sql.append("                            OVER ( ");
			sql.append("                              ORDER BY SEQ ) = 3 THEN STATUS ");
			sql.append("                     ELSE '' ");
			sql.append("                   END, '') AS Status ");
			sql.append("              ,NVL(CASE ");
			sql.append("                     WHEN ROW_NUMBER() ");
			sql.append("                            OVER ( ");
			sql.append("                              ORDER BY SEQ ) = 3 THEN SIGNUSERID ");
			sql.append("                     ELSE '' ");
			sql.append("                   END, '') SignUserID ");
			sql.append("              ,NVL(CASE ");
			sql.append("                     WHEN ROW_NUMBER() ");
			sql.append("                            OVER ( ");
			sql.append("                              ORDER BY SEQ ) = 3 THEN TO_CHAR(SIGNDATE, 'YYYY-MM-DD') ");
			sql.append("                     ELSE '' ");
			sql.append("                   END, '') SignDate ");
			sql.append("       FROM   TBAPPROVALDOCLINE ");
			sql.append("       WHERE  DOCUMENTID =  ?   ");
			sql.append("              AND LINETYPE = 'B') aa");

			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(1, DocumentID);

			rs = pstmt.executeQuery();

			while(rs.next()){
				SignImageUrl = rs.getString(1);
				Status = rs.getString(2);
				SignUserID = rs.getString(3);
				SignDate = rs.getString(4);
			}
			
			rs.close();
			pstmt.close();

			if(SignDate == null || SignDate.equals("")){
				SignDate = "";
			}

			sql.setLength(0);
			sql.append("SELECT NVL(nfnGetUserName( ?  ,  ?  ), '') 		");
			sql.append("FROM   DB_ROOT									");

			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(1, CompanyID);
			pstmt.setString(2, SignUserID);

			rs = pstmt.executeQuery();

			while(rs.next()){
				SignUserName = rs.getString(1);
			}
			
			rs.close();
			pstmt.close();

			sql.setLength(0);
			sql.append("SELECT NVL(nfnGetUserPosName( ?  ,  ?  , 'ko'), '') 	");
			sql.append("FROM   DB_ROOT											");

			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(1, CompanyID);
			pstmt.setString(2, SignUserID);

			rs = pstmt.executeQuery();

			while(rs.next()){
				SignUserPosName = rs.getString(1);
			}
			
			rs.close();
			pstmt.close();			

			if(Status == "C"){
				if (SignImageUrl == null || SignImageUrl.equals("")){
					tmpStatus = "X0007";
				}else {
					tmpStatus = SignImageUrl;
				}
			}else if (Status == "R"){
				tmpStatus = "X0006";
			}else{
				tmpStatus = "X0005";
			}

			SignImageFullUrl = "/nboxfile/myinfosign/" + tmpStatus ;


			if(SignUserID == null || SignUserID.equals("")){
				SignImageFullUrl = "";
			}

			sql.setLength(0);
			sql.append("SELECT nfnGetLinkDocSignStyle( ? ) 	");
			sql.append("FROM   DB_ROOT						");

			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(1, CompanyID);

			rs = pstmt.executeQuery();

			while(rs.next()){
				sRtnSignImage = rs.getString(1);
			}
			rs.close();
			pstmt.close();

			sRtnSignImage = sRtnSignImage.replace("@SIGNUSERNAME@", SignUserName + " " + SignUserPosName);
			sRtnSignImage = sRtnSignImage.replace("@SIGNIMAGEURL@", SignImageFullUrl);
			sRtnSignImage = sRtnSignImage.replace("@SIGNDATE@", SignDate);

			return sRtnSignImage;
			
		} catch (Exception e) {
			throw new Exception(e.getMessage());
		} finally {
			if (rs != null) rs.close();
			if (pstmt != null) pstmt.close();
			if (conn != null) conn.close();
		}
	}


	/** 함수명 : nfnGetLinkDocSignImage202
	 * @param CompanyID, DocumentID, Seq
	 * @return
	 * @throws Exception
	 */
	public static String nfnGetLinkDocSignImage202(String CompanyID, String DocumentID, int Seq) throws Exception{
		String sRtnSignImage = "";

		Connection  conn = null;
		PreparedStatement pstmt = null;
		ResultSet   rs = null;

		try{
			String SignImageUrl = "";
			String Status = "";
			String SignImageFullUrl = "";
			String SignUserID = "";
			String SignUserName = "";
			String SignUserPosName = "";
			String SignDate = "";
			String tmpStatus = "";
		
			StringBuffer  sql = new StringBuffer();
			
			Class.forName("cubrid.jdbc.driver.CUBRIDDriver");
			conn = DriverManager.getConnection("jdbc:default:connection");
			//			conn = DriverManager.getConnection("jdbc:CUBRID:192.168.1.220:33000:OmegaPlus:::?charSet=utf-8","unilite","UNILITE");

			sql.setLength(0);
			sql.append("SELECT Max(aa.SIGNIMAGEURL) ");
			sql.append("       ,Max(aa.STATUS) ");
			sql.append("       ,Max(aa.SIGNUSERID) ");
			sql.append("       ,Max(aa.SIGNDATE) ");
			sql.append("FROM  (SELECT NVL(CASE ");
			sql.append("                    WHEN ROW_NUMBER() ");
			sql.append("                           OVER ( ");
			sql.append("                             ORDER BY SEQ ) = 2 THEN SIGNIMGURL ");
			sql.append("                    ELSE '' ");
			sql.append("                  END, '')  SignImageUrl ");
			sql.append("              ,NVL(CASE ");
			sql.append("                     WHEN ROW_NUMBER() ");
			sql.append("                            OVER ( ");
			sql.append("                              ORDER BY SEQ ) = 2 THEN STATUS ");
			sql.append("                     ELSE '' ");
			sql.append("                   END, '') AS Status ");
			sql.append("              ,NVL(CASE ");
			sql.append("                     WHEN ROW_NUMBER() ");
			sql.append("                            OVER ( ");
			sql.append("                              ORDER BY SEQ ) = 2 THEN SIGNUSERID ");
			sql.append("                     ELSE '' ");
			sql.append("                   END, '') SignUserID ");
			sql.append("              ,NVL(CASE ");
			sql.append("                     WHEN ROW_NUMBER() ");
			sql.append("                            OVER ( ");
			sql.append("                              ORDER BY SEQ ) = 2 THEN TO_CHAR(SIGNDATE, 'YYYY-MM-DD') ");
			sql.append("                     ELSE '' ");
			sql.append("                   END, '') SignDate ");
			sql.append("       FROM   TBAPPROVALDOCLINE ");
			sql.append("       WHERE  DOCUMENTID =  ?   ");
			sql.append("              AND LINETYPE = 'B') aa");

			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(1, DocumentID);

			rs = pstmt.executeQuery();

			while(rs.next()){
				SignImageUrl = rs.getString(1);
				Status = rs.getString(2);
				SignUserID = rs.getString(3);
				SignDate = rs.getString(4);
			}
			
			rs.close();
			pstmt.close();

			if(SignDate == null || SignDate.equals("")){
				SignDate = "";
			}

			sql.setLength(0);
			sql.append("SELECT NVL(nfnGetUserName( ? ,  ? ), '') 	");
			sql.append("FROM   DB_ROOT								");

			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(1, CompanyID);
			pstmt.setString(2, SignUserID);

			rs = pstmt.executeQuery();

			while(rs.next()){
				SignUserName = rs.getString(1);
			}
			
			rs.close();
			pstmt.close();

			sql.setLength(0);
			sql.append("SELECT NVL(nfnGetUserPosName( ? ,  ? , 'ko'), '') 	");
			sql.append("FROM   DB_ROOT										");

			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(1, CompanyID);
			pstmt.setString(2, SignUserID);

			rs = pstmt.executeQuery();

			while(rs.next()){
				SignUserPosName = rs.getString(1);
			}
			
			rs.close();
			pstmt.close();
			

			if(Status == "C"){
				if (SignImageUrl == null || SignImageUrl.equals("")){
					tmpStatus = "X0007";
				}else {
					tmpStatus = SignImageUrl;
				}
			}else if (Status == "R"){
				tmpStatus = "X0006";
			}else{
				tmpStatus = "X0005";
			}

			SignImageFullUrl = "/nboxfile/myinfosign/" + tmpStatus ;


			if(SignUserID == null || SignUserID.equals("")){
				SignImageFullUrl = "";
			}

			sql.setLength(0);
			sql.append("SELECT nfnGetLinkDocSignStyle( ? ) 		");
			sql.append("FROM   DB_ROOT							");

			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(1, CompanyID);

			rs = pstmt.executeQuery();

			while(rs.next()){
				sRtnSignImage = rs.getString(1);
			}
			
			rs.close();
			pstmt.close();

			sRtnSignImage = sRtnSignImage.replace("@SIGNUSERNAME@", SignUserName + " " + SignUserPosName);
			sRtnSignImage = sRtnSignImage.replace("@SIGNIMAGEURL@", SignImageFullUrl);
			sRtnSignImage = sRtnSignImage.replace("@SIGNDATE@", SignDate);

			return sRtnSignImage;
			
		} catch (Exception e) {
			throw new Exception(e.getMessage());
		} finally {
			if (rs != null) rs.close();
			if (pstmt != null) pstmt.close();
			if (conn != null) conn.close();
		}
	}


	/** 함수명 : nfnGetLinkDocSignImage201
	 * @param CompanyID, DocumentID, Seq
	 * @return
	 * @throws Exception
	 */
	public static String nfnGetLinkDocSignImage201(String CompanyID, String DocumentID, int Seq) throws Exception{
		String sRtnSignImage = "";

		Connection  conn = null;
		PreparedStatement pstmt = null;
		ResultSet   rs = null;
		
		try{
			String SignImageUrl = "";
			String Status = "";
			String SignImageFullUrl = "";
			String SignUserID = "";
			String SignUserName = "";
			String SignUserPosName = "";
			String SignDate = "";
			String tmpStatus = "";

			StringBuffer  sql = new StringBuffer();
			
			Class.forName("cubrid.jdbc.driver.CUBRIDDriver");
			conn = DriverManager.getConnection("jdbc:default:connection");
			//			conn = DriverManager.getConnection("jdbc:CUBRID:192.168.1.220:33000:OmegaPlus:::?charSet=utf-8","unilite","UNILITE");

			sql.setLength(0);
			sql.append("SELECT Max(aa.SIGNIMAGEURL) ");
			sql.append("       ,Max(aa.STATUS) ");
			sql.append("       ,Max(aa.SIGNUSERID) ");
			sql.append("       ,Max(aa.SIGNDATE) ");
			sql.append("FROM  (SELECT NVL(CASE ");
			sql.append("                    WHEN ROW_NUMBER() ");
			sql.append("                           OVER ( ");
			sql.append("                             ORDER BY SEQ ) = 1 THEN SIGNIMGURL ");
			sql.append("                    ELSE '' ");
			sql.append("                  END, '')  SignImageUrl ");
			sql.append("              ,NVL(CASE ");
			sql.append("                     WHEN ROW_NUMBER() ");
			sql.append("                            OVER ( ");
			sql.append("                              ORDER BY SEQ ) = 1 THEN STATUS ");
			sql.append("                     ELSE '' ");
			sql.append("                   END, '') AS Status ");
			sql.append("              ,NVL(CASE ");
			sql.append("                     WHEN ROW_NUMBER() ");
			sql.append("                            OVER ( ");
			sql.append("                              ORDER BY SEQ ) = 1 THEN SIGNUSERID ");
			sql.append("                     ELSE '' ");
			sql.append("                   END, '') SignUserID ");
			sql.append("              ,NVL(CASE ");
			sql.append("                     WHEN ROW_NUMBER() ");
			sql.append("                            OVER ( ");
			sql.append("                              ORDER BY SEQ ) = 1 THEN TO_CHAR(SIGNDATE, 'YYYY-MM-DD') ");
			sql.append("                     ELSE '' ");
			sql.append("                   END, '') SignDate ");
			sql.append("       FROM   TBAPPROVALDOCLINE ");
			sql.append("       WHERE  DOCUMENTID =  ?   ");
			sql.append("              AND LINETYPE = 'B') aa");

			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(1, DocumentID);

			rs = pstmt.executeQuery();

			while(rs.next()){
				SignImageUrl = rs.getString(1);
				Status = rs.getString(2);
				SignUserID = rs.getString(3);
				SignDate = rs.getString(4);
			}
			
			rs.close();
			pstmt.close();

			if(SignDate == null || SignDate.equals("")){
				SignDate = "";
			}

			sql.setLength(0);
			sql.append("SELECT NVL(nfnGetUserName( ? ,  ? ), '') 	");
			sql.append("FROM   DB_ROOT								");

			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(1, CompanyID);
			pstmt.setString(2, SignUserID);

			rs = pstmt.executeQuery();

			while(rs.next()){
				SignUserName = rs.getString(1);
			}
			
			rs.close();
			pstmt.close();

			sql.setLength(0);
			sql.append("SELECT NVL(nfnGetUserPosName( ? ,  ? , 'ko'), '') 	");
			sql.append("FROM   DB_ROOT										");

			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(1, CompanyID);
			pstmt.setString(2, SignUserID);

			rs = pstmt.executeQuery();

			while(rs.next()){
				SignUserPosName = rs.getString(1);
			}
			
			rs.close();
			pstmt.close();

			if(Status == "C"){
				if (SignImageUrl == null || SignImageUrl.equals("")){
					tmpStatus = "X0007";
				}else {
					tmpStatus = SignImageUrl;
				}
			}else if (Status == "R"){
				tmpStatus = "X0006";
			}else{
				tmpStatus = "X0005";
			}

			SignImageFullUrl = "/nboxfile/myinfosign/" + tmpStatus ;

			if(SignUserID == null || SignUserID.equals("")){
				SignImageFullUrl = "";
			}

			sql.setLength(0);
			sql.append("SELECT nfnGetLinkDocSignStyle( ? ) ");
			sql.append("FROM   DB_ROOT");

			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(1, CompanyID);

			rs = pstmt.executeQuery();

			while(rs.next()){
				sRtnSignImage = rs.getString(1);
			}
			rs.close();
			pstmt.close();

			sRtnSignImage = sRtnSignImage.replace("@SIGNUSERNAME@", SignUserName + " " + SignUserPosName);
			sRtnSignImage = sRtnSignImage.replace("@SIGNIMAGEURL@", SignImageFullUrl);
			sRtnSignImage = sRtnSignImage.replace("@SIGNDATE@", SignDate);

			return sRtnSignImage;

		} catch (Exception e) {
			throw new Exception(e.getMessage());
		} finally {
			if (rs != null) rs.close();
			if (pstmt != null) pstmt.close();
			if (conn != null) conn.close();
		}
	}

	/** 함수명 : nfnGetLinkDocSignImage106
	 * @param CompanyID, DocumentID, Seq
	 * @return
	 * @throws Exception
	 */
	public static String nfnGetLinkDocSignImage106(String CompanyID, String DocumentID, int Seq) throws Exception{
		String sRtnSignImage = "";

		Connection  conn = null;
		PreparedStatement pstmt = null;
		ResultSet   rs = null;

		try{
			String SignImageUrl = "";
			String Status = "";
			String SignImageFullUrl = "";
			String SignUserID = "";
			String SignUserName = "";
			String SignUserPosName = "";
			String SignDate = "";
			String tmpStatus = "";
			
			StringBuffer  sql = new StringBuffer();
			
			Class.forName("cubrid.jdbc.driver.CUBRIDDriver");
			conn = DriverManager.getConnection("jdbc:default:connection");
			//			conn = DriverManager.getConnection("jdbc:CUBRID:192.168.1.220:33000:OmegaPlus:::?charSet=utf-8","unilite","UNILITE");

			sql.setLength(0);
			sql.append("SELECT Max(aa.SIGNIMAGEURL) ");
			sql.append("       ,Max(aa.STATUS) ");
			sql.append("       ,Max(aa.SIGNUSERID) ");
			sql.append("       ,Max(aa.SIGNDATE) ");
			sql.append("FROM  (SELECT NVL(CASE ");
			sql.append("                    WHEN ROW_NUMBER() ");
			sql.append("                           OVER ( ");
			sql.append("                             ORDER BY SEQ ) = 6 THEN SIGNIMGURL ");
			sql.append("                    ELSE '' ");
			sql.append("                  END, '')  SignImageUrl ");
			sql.append("              ,NVL(CASE ");
			sql.append("                     WHEN ROW_NUMBER() ");
			sql.append("                            OVER ( ");
			sql.append("                              ORDER BY SEQ ) = 6 THEN STATUS ");
			sql.append("                     ELSE '' ");
			sql.append("                   END, '') AS Status ");
			sql.append("              ,NVL(CASE ");
			sql.append("                     WHEN ROW_NUMBER() ");
			sql.append("                            OVER ( ");
			sql.append("                              ORDER BY SEQ ) = 6 THEN SIGNUSERID ");
			sql.append("                     ELSE '' ");
			sql.append("                   END, '') SignUserID ");
			sql.append("              ,NVL(CASE ");
			sql.append("                     WHEN ROW_NUMBER() ");
			sql.append("                            OVER ( ");
			sql.append("                              ORDER BY SEQ ) = 6 THEN TO_CHAR(SIGNDATE, 'YYYY-MM-DD') ");
			sql.append("                     ELSE '' ");
			sql.append("                   END, '') SignDate ");
			sql.append("       FROM   TBAPPROVALDOCLINE ");
			sql.append("       WHERE  DOCUMENTID =  ?   ");
			sql.append("              AND LINETYPE = 'A') aa");

			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(1, DocumentID);

			rs = pstmt.executeQuery();

			while(rs.next()){
				SignImageUrl = rs.getString(1);
				Status = rs.getString(2);
				SignUserID = rs.getString(3);
				SignDate = rs.getString(4);
			}
			
			rs.close();
			pstmt.close();

			if(SignDate == null || SignDate.equals("")){
				SignDate = "";
			}

			sql.setLength(0);
			sql.append("SELECT NVL(nfnGetUserName( ? ,  ? ), '') 	");
			sql.append("FROM   DB_ROOT								");

			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(1, CompanyID);
			pstmt.setString(2, SignUserID);

			rs = pstmt.executeQuery();

			while(rs.next()){
				SignUserName = rs.getString(1);
			}
			
			rs.close();
			pstmt.close();

			sql.setLength(0);
			sql.append("SELECT NVL(nfnGetUserPosName( ? ,  ? , 'ko'), '') 	");
			sql.append("FROM   DB_ROOT										");

			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(1, CompanyID);
			pstmt.setString(2, SignUserID);

			rs = pstmt.executeQuery();

			while(rs.next()){
				SignUserPosName = rs.getString(1);
			}
			
			rs.close();
			pstmt.close();

			if(Status == "C"){
				if (SignImageUrl == null || SignImageUrl.equals("")){
					tmpStatus = "X0007";
				}else {
					tmpStatus = SignImageUrl;
				}
			}else if (Status == "R"){
				tmpStatus = "X0006";
			}else{
				tmpStatus = "X0005";
			}

			SignImageFullUrl = "/nboxfile/myinfosign/" + tmpStatus ;

			if(SignUserID == null || SignUserID.equals("")){
				SignImageFullUrl = "";
			}

			sql.setLength(0);
			sql.append("SELECT nfnGetLinkDocSignStyle( ? ) 	");
			sql.append("FROM   DB_ROOT						");

			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(1, CompanyID);

			rs = pstmt.executeQuery();

			while(rs.next()){
				sRtnSignImage = rs.getString(1);
			}
			
			rs.close();
			pstmt.close();

			sRtnSignImage = sRtnSignImage.replace("@SIGNUSERNAME@", SignUserName + " " + SignUserPosName);
			sRtnSignImage = sRtnSignImage.replace("@SIGNIMAGEURL@", SignImageFullUrl);
			sRtnSignImage = sRtnSignImage.replace("@SIGNDATE@", SignDate);

			return sRtnSignImage;
			
		} catch (Exception e) {
			throw new Exception(e.getMessage());
		} finally {
			if (rs != null) rs.close();
			if (pstmt != null) pstmt.close();
			if (conn != null) conn.close();
		}
	}

	/** 함수명 : nfnGetLinkDocSignImage105
	 * @param CompanyID, DocumentID, Seq
	 * @return
	 * @throws Exception
	 */
	public static String nfnGetLinkDocSignImage105(String CompanyID, String DocumentID, int Seq) throws Exception{
		String sRtnSignImage = "";

		Connection  conn = null;
		PreparedStatement pstmt = null;
		ResultSet   rs = null;

		try{
			String SignImageUrl = "";
			String Status = "";
			String SignImageFullUrl = "";
			String SignUserID = "";
			String SignUserName = "";
			String SignUserPosName = "";
			String SignDate = "";
			String tmpStatus = "";
		
			StringBuffer  sql = new StringBuffer();
			
			Class.forName("cubrid.jdbc.driver.CUBRIDDriver");
			conn = DriverManager.getConnection("jdbc:default:connection");
			//			conn = DriverManager.getConnection("jdbc:CUBRID:192.168.1.220:33000:OmegaPlus:::?charSet=utf-8","unilite","UNILITE");

			sql.setLength(0);
			sql.append("SELECT Max(aa.SIGNIMAGEURL) ");
			sql.append("       ,Max(aa.STATUS) ");
			sql.append("       ,Max(aa.SIGNUSERID) ");
			sql.append("       ,Max(aa.SIGNDATE) ");
			sql.append("FROM  (SELECT NVL(CASE ");
			sql.append("                    WHEN ROW_NUMBER() ");
			sql.append("                           OVER ( ");
			sql.append("                             ORDER BY SEQ ) = 5 THEN SIGNIMGURL ");
			sql.append("                    ELSE '' ");
			sql.append("                  END, '')  SignImageUrl ");
			sql.append("              ,NVL(CASE ");
			sql.append("                     WHEN ROW_NUMBER() ");
			sql.append("                            OVER ( ");
			sql.append("                              ORDER BY SEQ ) = 5 THEN STATUS ");
			sql.append("                     ELSE '' ");
			sql.append("                   END, '') AS Status ");
			sql.append("              ,NVL(CASE ");
			sql.append("                     WHEN ROW_NUMBER() ");
			sql.append("                            OVER ( ");
			sql.append("                              ORDER BY SEQ ) = 5 THEN SIGNUSERID ");
			sql.append("                     ELSE '' ");
			sql.append("                   END, '') SignUserID ");
			sql.append("              ,NVL(CASE ");
			sql.append("                     WHEN ROW_NUMBER() ");
			sql.append("                            OVER ( ");
			sql.append("                              ORDER BY SEQ ) = 5 THEN TO_CHAR(SIGNDATE, 'YYYY-MM-DD') ");
			sql.append("                     ELSE '' ");
			sql.append("                   END, '') SignDate ");
			sql.append("       FROM   TBAPPROVALDOCLINE ");
			sql.append("       WHERE  DOCUMENTID =  ?   ");
			sql.append("              AND LINETYPE = 'A') aa");

			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(1, DocumentID);

			rs = pstmt.executeQuery();

			while(rs.next()){
				SignImageUrl = rs.getString(1);
				Status = rs.getString(2);
				SignUserID = rs.getString(3);
				SignDate = rs.getString(4);
			}
			
			rs.close();
			pstmt.close();

			if(SignDate == null || SignDate.equals("")){
				SignDate = "";
			}

			sql.setLength(0);
			sql.append("SELECT NVL(nfnGetUserName( ? ,  ? ), '') 	");
			sql.append("FROM   DB_ROOT								");

			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(1, CompanyID);
			pstmt.setString(2, SignUserID);

			rs = pstmt.executeQuery();

			while(rs.next()){
				SignUserName = rs.getString(1);
			}
			
			rs.close();
			pstmt.close();

			sql.setLength(0);
			sql.append("SELECT NVL(nfnGetUserPosName( ? ,  ? , 'ko'), '') 	");
			sql.append("FROM   DB_ROOT										");

			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(1, CompanyID);
			pstmt.setString(2, SignUserID);

			rs = pstmt.executeQuery();

			while(rs.next()){
				SignUserPosName = rs.getString(1);
			}
			
			rs.close();
			pstmt.close();
			

			if(Status == "C"){
				if (SignImageUrl == null || SignImageUrl.equals("")){
					tmpStatus = "X0007";
				}else {
					tmpStatus = SignImageUrl;
				}
			}else if (Status == "R"){
				tmpStatus = "X0006";
			}else{
				tmpStatus = "X0005";
			}

			SignImageFullUrl = "/nboxfile/myinfosign/" + tmpStatus ;


			if(SignUserID == null || SignUserID.equals("")){
				SignImageFullUrl = "";
			}

			sql.setLength(0);
			sql.append("SELECT nfnGetLinkDocSignStyle( ? ) 	");
			sql.append("FROM   DB_ROOT						");

			pstmt = conn.prepareStatement(sql.toString());
			pstmt.setString(1, CompanyID);

			rs = pstmt.executeQuery();

			while(rs.next()){
				sRtnSignImage = rs.getString(1);
			}
			
			rs.close();
			pstmt.close();

			sRtnSignImage = sRtnSignImage.replace("@SIGNUSERNAME@", SignUserName + " " + SignUserPosName);
			sRtnSignImage = sRtnSignImage.replace("@SIGNIMAGEURL@", SignImageFullUrl);
			sRtnSignImage = sRtnSignImage.replace("@SIGNDATE@", SignDate);

			return sRtnSignImage;
			
		} catch (Exception e) {
			throw new Exception(e.getMessage());
		} finally {
			if (rs != null) rs.close();
			if (pstmt != null) pstmt.close();
			if (conn != null) conn.close();
		}
	}

	/** 함수명 : nfnGetLinkDocSignImage104
	 * @param CompanyID, DocumentID, Seq
	 * @return
	 * @throws Exception
	 */
	public static String nfnGetLinkDocSignImage104(String CompanyID, String DocumentID, int Seq) throws Exception{
		String sRtnSignImage = "";

		Connection  conn = null;
		PreparedStatement pstmt = null;
		ResultSet   rs = null;

		try{
			String SignImageUrl = "";
			String Status = "";
			String SignImageFullUrl = "";
			String SignUserID = "";
			String SignUserName = "";
			String SignUserPosName = "";
			String SignDate = "";
			String tmpStatus = "";
			
			StringBuffer  sql = new StringBuffer();
			
			Class.forName("cubrid.jdbc.driver.CUBRIDDriver");
			conn = DriverManager.getConnection("jdbc:default:connection");
			//			conn = DriverManager.getConnection("jdbc:CUBRID:192.168.1.220:33000:OmegaPlus:::?charSet=utf-8","unilite","UNILITE");

			sql.setLength(0);
			sql.append("SELECT Max(aa.SIGNIMAGEURL) ");
			sql.append("       ,Max(aa.STATUS) ");
			sql.append("       ,Max(aa.SIGNUSERID) ");
			sql.append("       ,Max(aa.SIGNDATE) ");
			sql.append("FROM  (SELECT NVL(CASE ");
			sql.append("                    WHEN ROW_NUMBER() ");
			sql.append("                           OVER ( ");
			sql.append("                             ORDER BY SEQ ) = 4 THEN SIGNIMGURL ");
			sql.append("                    ELSE '' ");
			sql.append("                  END, '')  SignImageUrl ");
			sql.append("              ,NVL(CASE ");
			sql.append("                     WHEN ROW_NUMBER() ");
			sql.append("                            OVER ( ");
			sql.append("                              ORDER BY SEQ ) = 4 THEN STATUS ");
			sql.append("                     ELSE '' ");
			sql.append("                   END, '') AS Status ");
			sql.append("              ,NVL(CASE ");
			sql.append("                     WHEN ROW_NUMBER() ");
			sql.append("                            OVER ( ");
			sql.append("                              ORDER BY SEQ ) = 4 THEN SIGNUSERID ");
			sql.append("                     ELSE '' ");
			sql.append("                   END, '') SignUserID ");
			sql.append("              ,NVL(CASE ");
			sql.append("                     WHEN ROW_NUMBER() ");
			sql.append("                            OVER ( ");
			sql.append("                              ORDER BY SEQ ) = 4 THEN TO_CHAR(SIGNDATE, 'YYYY-MM-DD') ");
			sql.append("                     ELSE '' ");
			sql.append("                   END, '') SignDate ");
			sql.append("       FROM   TBAPPROVALDOCLINE ");
			sql.append("       WHERE  DOCUMENTID =  ?   ");
			sql.append("              AND LINETYPE = 'A') aa");

			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(1, DocumentID);

			rs = pstmt.executeQuery();

			while(rs.next()){
				SignImageUrl = rs.getString(1);
				Status = rs.getString(2);
				SignUserID = rs.getString(3);
				SignDate = rs.getString(4);
			}
			
			rs.close();
			pstmt.close();

			if(SignDate == null || SignDate.equals("")){
				SignDate = "";
			}

			sql.setLength(0);
			sql.append("SELECT NVL(nfnGetUserName( ? ,  ? ), '') 	");
			sql.append("FROM   DB_ROOT								");

			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(1, CompanyID);
			pstmt.setString(2, SignUserID);

			rs = pstmt.executeQuery();

			while(rs.next()){
				SignUserName = rs.getString(1);
			}
			
			rs.close();
			pstmt.close();

			sql.setLength(0);
			sql.append("SELECT NVL(nfnGetUserPosName( ? ,  ? , 'ko'), '') 	");
			sql.append("FROM   DB_ROOT										");

			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(1, CompanyID);
			pstmt.setString(2, SignUserID);

			rs = pstmt.executeQuery();

			while(rs.next()){
				SignUserPosName = rs.getString(1);
			}
			rs.close();
			pstmt.close();

			if(Status == "C"){
				if (SignImageUrl == null || SignImageUrl.equals("")){
					tmpStatus = "X0007";
				}else {
					tmpStatus = SignImageUrl;
				}
			}else if (Status == "R"){
				tmpStatus = "X0006";
			}else{
				tmpStatus = "X0005";
			}

			SignImageFullUrl = "/nboxfile/myinfosign/" + tmpStatus ;

			if(SignUserID == null || SignUserID.equals("")){
				SignImageFullUrl = "";
			}

			sql.setLength(0);
			sql.append("SELECT nfnGetLinkDocSignStyle( ? ) 	");
			sql.append("FROM   DB_ROOT						");

			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(1, CompanyID);

			rs = pstmt.executeQuery();

			while(rs.next()){
				sRtnSignImage = rs.getString(1);
			}
			rs.close();
			pstmt.close();

			sRtnSignImage = sRtnSignImage.replace("@SIGNUSERNAME@", SignUserName + " " + SignUserPosName);
			sRtnSignImage = sRtnSignImage.replace("@SIGNIMAGEURL@", SignImageFullUrl);
			sRtnSignImage = sRtnSignImage.replace("@SIGNDATE@", SignDate);

			return sRtnSignImage;
			
		} catch (Exception e) {
			throw new Exception(e.getMessage());
		} finally {
			if (rs != null) rs.close();
			if (pstmt != null) pstmt.close();
			if (conn != null) conn.close();
		}
	}

	/** 함수명 : nfnGetLinkDocSignImage103
	 * @param CompanyID, DocumentID, Seq
	 * @return
	 * @throws Exception
	 */
	public static String nfnGetLinkDocSignImage103(String CompanyID, String DocumentID, int Seq) throws Exception{
		String sRtnSignImage = "";

		Connection  conn = null;
		PreparedStatement pstmt = null;
		ResultSet   rs = null;
		
		try{
			String SignImageUrl = "";
			String Status = "";
			String SignImageFullUrl = "";
			String SignUserID = "";
			String SignUserName = "";
			String SignUserPosName = "";
			String SignDate = "";
			String tmpStatus = "";
		
			StringBuffer  sql = new StringBuffer();
			
			Class.forName("cubrid.jdbc.driver.CUBRIDDriver");
			conn = DriverManager.getConnection("jdbc:default:connection");
			//			conn = DriverManager.getConnection("jdbc:CUBRID:192.168.1.220:33000:OmegaPlus:::?charSet=utf-8","unilite","UNILITE");

			sql.setLength(0);
			sql.append("SELECT Max(aa.SIGNIMAGEURL) ");
			sql.append("       ,Max(aa.STATUS) ");
			sql.append("       ,Max(aa.SIGNUSERID) ");
			sql.append("       ,Max(aa.SIGNDATE) ");
			sql.append("FROM  (SELECT NVL(CASE ");
			sql.append("                    WHEN ROW_NUMBER() ");
			sql.append("                           OVER ( ");
			sql.append("                             ORDER BY SEQ ) = 3 THEN SIGNIMGURL ");
			sql.append("                    ELSE '' ");
			sql.append("                  END, '')  SignImageUrl ");
			sql.append("              ,NVL(CASE ");
			sql.append("                     WHEN ROW_NUMBER() ");
			sql.append("                            OVER ( ");
			sql.append("                              ORDER BY SEQ ) = 3 THEN STATUS ");
			sql.append("                     ELSE '' ");
			sql.append("                   END, '') AS Status ");
			sql.append("              ,NVL(CASE ");
			sql.append("                     WHEN ROW_NUMBER() ");
			sql.append("                            OVER ( ");
			sql.append("                              ORDER BY SEQ ) = 3 THEN SIGNUSERID ");
			sql.append("                     ELSE '' ");
			sql.append("                   END, '') SignUserID ");
			sql.append("              ,NVL(CASE ");
			sql.append("                     WHEN ROW_NUMBER() ");
			sql.append("                            OVER ( ");
			sql.append("                              ORDER BY SEQ ) = 3 THEN TO_CHAR(SIGNDATE, 'YYYY-MM-DD') ");
			sql.append("                     ELSE '' ");
			sql.append("                   END, '') SignDate ");
			sql.append("       FROM   TBAPPROVALDOCLINE ");
			sql.append("       WHERE  DOCUMENTID =  ?   ");
			sql.append("              AND LINETYPE = 'A') aa");

			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(1, DocumentID);

			rs = pstmt.executeQuery();

			while(rs.next()){
				SignImageUrl = rs.getString(1);
				Status = rs.getString(2);
				SignUserID = rs.getString(3);
				SignDate = rs.getString(4);
			}
			
			rs.close();
			pstmt.close();

			if(SignDate == null || SignDate.equals("")){
				SignDate = "";
			}

			sql.setLength(0);
			sql.append("SELECT NVL(nfnGetUserName( ? ,  ? ), '') 	");
			sql.append("FROM   DB_ROOT								");

			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(1, CompanyID);
			pstmt.setString(2, SignUserID);

			rs = pstmt.executeQuery();

			while(rs.next()){
				SignUserName = rs.getString(1);
			}
			
			rs.close();
			pstmt.close();

			sql.setLength(0);
			sql.append("SELECT NVL(nfnGetUserPosName( ? ,  ? , 'ko'), '') 	");
			sql.append("FROM   DB_ROOT										");

			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(1, CompanyID);
			pstmt.setString(2, SignUserID);

			rs = pstmt.executeQuery();

			while(rs.next()){
				SignUserPosName = rs.getString(1);
			}
			
			rs.close();
			pstmt.close();

			if(Status == "C"){
				if (SignImageUrl == null || SignImageUrl.equals("")){
					tmpStatus = "X0007";
				}else {
					tmpStatus = SignImageUrl;
				}
			}else if (Status == "R"){
				tmpStatus = "X0006";
			}else{
				tmpStatus = "X0005";
			}

			SignImageFullUrl = "/nboxfile/myinfosign/" + tmpStatus ;


			if(SignUserID == null || SignUserID.equals("")){
				SignImageFullUrl = "";
			}

			sql.setLength(0);
			sql.append("SELECT nfnGetLinkDocSignStyle( ? ) 	");
			sql.append("FROM   DB_ROOT						");

			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(1, CompanyID);

			rs = pstmt.executeQuery();

			while(rs.next()){
				sRtnSignImage = rs.getString(1);
			}
			rs.close();
			pstmt.close();

			sRtnSignImage = sRtnSignImage.replace("@SIGNUSERNAME@", SignUserName + " " + SignUserPosName);
			sRtnSignImage = sRtnSignImage.replace("@SIGNIMAGEURL@", SignImageFullUrl);
			sRtnSignImage = sRtnSignImage.replace("@SIGNDATE@", SignDate);

			return sRtnSignImage;
			
		} catch (Exception e) {
			throw new Exception(e.getMessage());
		} finally {
			if (rs != null) rs.close();
			if (pstmt != null) pstmt.close();
			if (conn != null) conn.close();
		}
	}

	/** 함수명 : nfnGetLinkDocSignImage102
	 * @param CompanyID, DocumentID, Seq
	 * @return
	 * @throws Exception
	 */
	public static String nfnGetLinkDocSignImage102(String CompanyID, String DocumentID, int Seq) throws Exception{
		String sRtnSignImage = "";

		Connection  conn = null;
		PreparedStatement pstmt = null;
		ResultSet   rs = null;

		try{
			String SignImageUrl = "";
			String Status = "";
			String SignImageFullUrl = "";
			String SignUserID = "";
			String SignUserName = "";
			String SignUserPosName = "";
			String SignDate = "";
			String tmpStatus = "";
			
			StringBuffer  sql = new StringBuffer();
			
			Class.forName("cubrid.jdbc.driver.CUBRIDDriver");
			conn = DriverManager.getConnection("jdbc:default:connection");
			//			conn = DriverManager.getConnection("jdbc:CUBRID:192.168.1.220:33000:OmegaPlus:::?charSet=utf-8","unilite","UNILITE");

			sql.setLength(0);
			sql.append("SELECT Max(aa.SIGNIMAGEURL) ");
			sql.append("       ,Max(aa.STATUS) ");
			sql.append("       ,Max(aa.SIGNUSERID) ");
			sql.append("       ,Max(aa.SIGNDATE) ");
			sql.append("FROM  (SELECT NVL(CASE ");
			sql.append("                    WHEN ROW_NUMBER() ");
			sql.append("                           OVER ( ");
			sql.append("                             ORDER BY SEQ ) = 2 THEN SIGNIMGURL ");
			sql.append("                    ELSE '' ");
			sql.append("                  END, '')  SignImageUrl ");
			sql.append("              ,NVL(CASE ");
			sql.append("                     WHEN ROW_NUMBER() ");
			sql.append("                            OVER ( ");
			sql.append("                              ORDER BY SEQ ) = 2 THEN STATUS ");
			sql.append("                     ELSE '' ");
			sql.append("                   END, '') AS Status ");
			sql.append("              ,NVL(CASE ");
			sql.append("                     WHEN ROW_NUMBER() ");
			sql.append("                            OVER ( ");
			sql.append("                              ORDER BY SEQ ) = 2 THEN SIGNUSERID ");
			sql.append("                     ELSE '' ");
			sql.append("                   END, '') SignUserID ");
			sql.append("              ,NVL(CASE ");
			sql.append("                     WHEN ROW_NUMBER() ");
			sql.append("                            OVER ( ");
			sql.append("                              ORDER BY SEQ ) = 2 THEN TO_CHAR(SIGNDATE, 'YYYY-MM-DD') ");
			sql.append("                     ELSE '' ");
			sql.append("                   END, '') SignDate ");
			sql.append("       FROM   TBAPPROVALDOCLINE ");
			sql.append("       WHERE  DOCUMENTID =  ?   ");
			sql.append("              AND LINETYPE = 'A') aa");

			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(1, DocumentID);

			rs = pstmt.executeQuery();

			while(rs.next()){
				SignImageUrl = rs.getString(1);
				Status = rs.getString(2);
				SignUserID = rs.getString(3);
				SignDate = rs.getString(4);
			}
			
			rs.close();
			pstmt.close();

			if(SignDate == null || SignDate.equals("")){
				SignDate = "";
			}

			sql.setLength(0);
			sql.append("SELECT NVL(nfnGetUserName( ? ,  ? ), '') 	");
			sql.append("FROM   DB_ROOT								");

			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(1, CompanyID);
			pstmt.setString(2, SignUserID);

			rs = pstmt.executeQuery();

			while(rs.next()){
				SignUserName = rs.getString(1);
			}
			
			rs.close();
			pstmt.close();

			sql.setLength(0);
			sql.append("SELECT NVL(nfnGetUserPosName( ? ,  ? , 'ko'), '') 	");
			sql.append("FROM   DB_ROOT										");

			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(1, CompanyID);
			pstmt.setString(2, SignUserID);

			rs = pstmt.executeQuery();

			while(rs.next()){
				SignUserPosName = rs.getString(1);
			}
			
			rs.close();
			pstmt.close();

			if(Status == "C"){
				if (SignImageUrl == null || SignImageUrl.equals("")){
					tmpStatus = "X0007";
				}else {
					tmpStatus = SignImageUrl;
				}
			}else if (Status == "R"){
				tmpStatus = "X0006";
			}else{
				tmpStatus = "X0005";
			}

			SignImageFullUrl = "/nboxfile/myinfosign/" + tmpStatus ;

			if(SignUserID == null || SignUserID.equals("")){
				SignImageFullUrl = "";
			}

			sql.setLength(0);
			sql.append("SELECT nfnGetLinkDocSignStyle( ? ) 	");
			sql.append("FROM   DB_ROOT						");

			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(1, CompanyID);

			rs = pstmt.executeQuery();

			while(rs.next()){
				sRtnSignImage = rs.getString(1);
			}
			
			rs.close();
			pstmt.close();

			sRtnSignImage = sRtnSignImage.replace("@SIGNUSERNAME@", SignUserName + " " + SignUserPosName);
			sRtnSignImage = sRtnSignImage.replace("@SIGNIMAGEURL@", SignImageFullUrl);
			sRtnSignImage = sRtnSignImage.replace("@SIGNDATE@", SignDate);

			return sRtnSignImage;

		} catch (Exception e) {
			throw new Exception(e.getMessage());
		} finally {
			if (rs != null) rs.close();
			if (pstmt != null) pstmt.close();
			if (conn != null) conn.close();
		}
	}

	/** 함수명 : nfnGetLinkDocSignImage101
	 * @param CompanyID, DocumentID, Seq
	 * @return
	 * @throws Exception
	 */
	public static String nfnGetLinkDocSignImage101(String CompanyID , String DocumentID, int Seq) throws Exception{
		String sRtnSignImage = "";
		
		Connection  conn = null;
		PreparedStatement pstmt = null;
		ResultSet   rs = null;
		
		try{
			String SignImageUrl = "";
			String Status = "";
			String SignImageFullUrl = "";
			String SignUserID = "";
			String SignUserName = "";
			String SignUserPosName = "";
			String SignDate = "";
			String tmpStatus = "";
			
			StringBuffer  sql = new StringBuffer();
			
			Class.forName("cubrid.jdbc.driver.CUBRIDDriver");
			conn = DriverManager.getConnection("jdbc:default:connection");
			//			conn = DriverManager.getConnection("jdbc:CUBRID:192.168.1.220:33000:OmegaPlus:::?charSet=utf-8","unilite","UNILITE");

			sql.setLength(0);
			sql.append("SELECT Max(aa.SIGNIMAGEURL) ");
			sql.append("       ,Max(aa.STATUS) ");
			sql.append("       ,Max(aa.SIGNUSERID) ");
			sql.append("       ,Max(aa.SIGNDATE) ");
			sql.append("FROM  (SELECT NVL(CASE ");
			sql.append("                    WHEN ROW_NUMBER() ");
			sql.append("                           OVER ( ");
			sql.append("                             ORDER BY SEQ ) = 1 THEN SIGNIMGURL ");
			sql.append("                    ELSE '' ");
			sql.append("                  END, '')  SignImageUrl ");
			sql.append("              ,NVL(CASE ");
			sql.append("                     WHEN ROW_NUMBER() ");
			sql.append("                            OVER ( ");
			sql.append("                              ORDER BY SEQ ) = 1 THEN STATUS ");
			sql.append("                     ELSE '' ");
			sql.append("                   END, '') AS Status ");
			sql.append("              ,NVL(CASE ");
			sql.append("                     WHEN ROW_NUMBER() ");
			sql.append("                            OVER ( ");
			sql.append("                              ORDER BY SEQ ) = 1 THEN SIGNUSERID ");
			sql.append("                     ELSE '' ");
			sql.append("                   END, '') SignUserID ");
			sql.append("              ,NVL(CASE ");
			sql.append("                     WHEN ROW_NUMBER() ");
			sql.append("                            OVER ( ");
			sql.append("                              ORDER BY SEQ ) = 1 THEN TO_CHAR(SIGNDATE, 'YYYY-MM-DD') ");
			sql.append("                     ELSE '' ");
			sql.append("                   END, '') SignDate ");
			sql.append("       FROM   TBAPPROVALDOCLINE ");
			sql.append("       WHERE  DOCUMENTID =  ?   ");
			sql.append("              AND LINETYPE = 'A') aa");

			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(1, DocumentID);

			rs = pstmt.executeQuery();

			while(rs.next()){
				SignImageUrl = rs.getString(1);
				Status = rs.getString(2);
				SignUserID = rs.getString(3);
				SignDate = rs.getString(4);
			}
			
			rs.close();
			pstmt.close();

			if(SignDate == null || SignDate.equals("")){
				SignDate = "";
			}

			sql.setLength(0);
			sql.append("SELECT NVL(nfnGetUserName( ? ,  ? ), '') 	");
			sql.append("FROM   DB_ROOT								");

			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(1, CompanyID);
			pstmt.setString(2, SignUserID);

			rs = pstmt.executeQuery();

			while(rs.next()){
				SignUserName = rs.getString(1);
			}
			
			rs.close();
			pstmt.close();

			sql.setLength(0);
			sql.append("SELECT NVL(nfnGetUserPosName( ? ,  ? , 'ko'), '') 	");
			sql.append("FROM   DB_ROOT										");

			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(1, CompanyID);
			pstmt.setString(2, SignUserID);

			rs = pstmt.executeQuery();

			while(rs.next()){
				SignUserPosName = rs.getString(1);
			}
			rs.close();
			pstmt.close();

			if(Status == "C"){
				if (SignImageUrl == null || SignImageUrl.equals("")){
					tmpStatus = "X0007";
				}else {
					tmpStatus = SignImageUrl;
				}
			}else if (Status == "R"){
				tmpStatus = "X0006";
			}else{
				tmpStatus = "X0005";
			}

			SignImageFullUrl = "/nboxfile/myinfosign/" + tmpStatus ;

			if(SignUserID == null || SignUserID.equals("")){
				SignImageFullUrl = "";
			}

			sql.setLength(0);
			sql.append("SELECT nfnGetLinkDocSignStyle( ? ) ");
			sql.append("FROM   DB_ROOT");

			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(1, CompanyID);

			rs = pstmt.executeQuery();

			while(rs.next()){
				sRtnSignImage = rs.getString(1);
			}
			rs.close();
			pstmt.close();

			sRtnSignImage = sRtnSignImage.replace("@SIGNUSERNAME@", SignUserName + " " + SignUserPosName);
			sRtnSignImage = sRtnSignImage.replace("@SIGNIMAGEURL@", SignImageFullUrl);
			sRtnSignImage = sRtnSignImage.replace("@SIGNDATE@", SignDate);

			return sRtnSignImage;
		} catch (Exception e) {
			throw new Exception(e.getMessage());
		} finally {
			if (rs != null) rs.close();
			if (pstmt != null) pstmt.close();
			if (conn != null) conn.close();
		}	
	}

	/** 함수명 : nfnGetLinkDocSignStyle
	 * @param CompanyID
	 * @return
	 * @throws Exception
	 */
	public static String nfnGetLinkDocSignStyle(String CompanyID)  throws Exception {
		String sRtnSignImage = "";
		
		try{

			sRtnSignImage += " " + "<table style=\"width:100%; height:100%;\">";
			sRtnSignImage += " " + "<tr><td style=\"height:20pt; text-align:center; font-family: Arial, sans-serif; border-bottom:1px solid #000000;\"><span lang=\"EN-US\" style=\"font-size: 9pt; font-family: Arial, sans-serif;\">@SIGNUSERNAME@</span></td></tr>";
			sRtnSignImage += " " + "<tr><td style=\"height:50pt; text-align:center;\"><img src=\"@SIGNIMAGEURL@\"/></td></tr>";
			sRtnSignImage += " " + "<tr><td style=\"height:20pt; text-align:center; border-top:1px solid #000000;\"><span lang=\"EN-US\" style=\"font-size: 9pt; font-family: Arial, sans-serif;\">@SIGNDATE@</span></td></tr>";
			sRtnSignImage += " " + "</table>"; 

			return sRtnSignImage;
			
		} catch (Exception e) {
			throw new Exception(e.getMessage());
		} finally {
			
		}
	}

	/** 함수명 : nfnGetLinkDocSubject
	 * @param CompanyID, DocumentID
	 * @return
	 * @throws Exception
	 */
	public static String nfnGetLinkDocSubject(String CompanyID, String DocumentID) throws Exception {
		String sRtnSubject = "";

		Connection  conn = null;
		PreparedStatement pstmt = null;
		ResultSet   rs = null;
		
		try{
			StringBuffer  sql = new StringBuffer();
			
			Class.forName("cubrid.jdbc.driver.CUBRIDDriver");
			conn = DriverManager.getConnection("jdbc:default:connection");
			//			conn = DriverManager.getConnection("jdbc:CUBRID:192.168.1.220:33000:OmegaPlus:::?charSet=utf-8","unilite","UNILITE");

			sql.setLength(0);
			sql.append("SELECT   NVL(SUBJECT, '') ");
			sql.append("FROM   TBAPPROVALDOC ");
			sql.append("WHERE  COMPANYID =  ?  ");
			sql.append("       AND DOCUMENTID =  ?  ");

			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(1, CompanyID);
			pstmt.setString(2, DocumentID);

			rs = pstmt.executeQuery();

			while(rs.next()){
				sRtnSubject = rs.getString(1);
			}
			
			rs.close();
			pstmt.close();

			return sRtnSubject;
			
		} catch (Exception e) {
			throw new Exception(e.getMessage());
		} finally {
			if (rs != null) rs.close();
			if (pstmt != null) pstmt.close();
			if (conn != null) conn.close();
		}
	}

	/** 함수명 : nfnGetLinkUserDeptName
	 * @param CompCode, UserID
	 * @return
	 * @throws Exception
	 */
	public static String nfnGetLinkUserDeptName(String CompCode, String UserID) throws Exception {
		String sRtnDeptName = "";

		Connection  conn = null;
		PreparedStatement pstmt = null;
		ResultSet   rs = null;
		
		try{
			StringBuffer  sql = new StringBuffer();
			
			Class.forName("cubrid.jdbc.driver.CUBRIDDriver");
			conn = DriverManager.getConnection("jdbc:default:connection");
			//			conn = DriverManager.getConnection("jdbc:CUBRID:192.168.1.220:33000:OmegaPlus:::?charSet=utf-8","unilite","UNILITE");

			sql.setLength(0);
			sql.append("SELECT  TREE_NAME ");
			sql.append("FROM   BSA300T ");
			sql.append("       INNER JOIN BSA210T ");
			sql.append("               ON BSA300T.COMP_CODE = BSA210T.COMP_CODE ");
			sql.append("                  AND BSA300T.DEPT_CODE = BSA210T.TREE_CODE ");
			sql.append("WHERE  BSA300T.COMP_CODE =  ?  ");
			sql.append("       AND BSA300T.USER_ID =  ?  ");

			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(1, CompCode);
			pstmt.setString(2, UserID);

			rs = pstmt.executeQuery();

			while(rs.next()){
				sRtnDeptName = rs.getString(1);
			}
			rs.close();
			pstmt.close();

			if(sRtnDeptName.equals("")){
				sRtnDeptName = UserID;
			}

			return sRtnDeptName;
			
		} catch (Exception e) {
			throw new Exception(e.getMessage());
		} finally {
			if (rs != null) rs.close();
			if (pstmt != null) pstmt.close();
			if (conn != null) conn.close();
		}
	}

	/** 함수명 : nfnGetLinkUserName
	 * @param CompCode, UserID
	 * @return
	 * @throws Exception
	 */
	public static String nfnGetLinkUserName(String CompCode, String UserID) throws Exception {
		String sRtnUserName = "";

		Connection  conn = null;
		PreparedStatement pstmt = null;
		ResultSet   rs = null;
		
		try{
			StringBuffer  sql = new StringBuffer();
			
			Class.forName("cubrid.jdbc.driver.CUBRIDDriver");
			conn = DriverManager.getConnection("jdbc:default:connection");
			//			conn = DriverManager.getConnection("jdbc:CUBRID:192.168.1.220:33000:OmegaPlus:::?charSet=utf-8","unilite","UNILITE");

			sql.setLength(0);
			sql.append("SELECT  USER_NAME ");
			sql.append("FROM   BSA300T ");
			sql.append("WHERE  COMP_CODE =  ?  ");
			sql.append("       AND USER_ID =  ?  ");

			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(1, CompCode);
			pstmt.setString(2, UserID);

			rs = pstmt.executeQuery();

			while(rs.next()){
				sRtnUserName = rs.getString(1);
			}
			rs.close();
			pstmt.close();

			if(sRtnUserName.equals("")){
				sRtnUserName = UserID;
			}

			return sRtnUserName;
			
		} catch (Exception e) {
			throw new Exception(e.getMessage());
		} finally {
			if (rs != null) rs.close();
			if (pstmt != null) pstmt.close();
			if (conn != null) conn.close();
		}
	}

	/** 함수명 : nfnGetMaxID
	 * @param PreFix, MaxID
	 * @return
	 * @throws Exception
	 */
	public static String nfnGetMaxID(String PreFix, String MaxID) throws Exception {
		String sRtnMaxNewID = "";
		
		try{
			String MaxDate = "";
			String MaxSerial = "";
			String MaxNewDate = "";
			Date ToDay = new Date();
			String InitSerial = "";
			int intMS = 0;
			String stIntMS = "";
	
			if (MaxID == null ||MaxID.equals("")){
	
				SimpleDateFormat formatter = new SimpleDateFormat("YYYYMMdd");
				MaxNewDate = formatter.format( ToDay ); 
	
				InitSerial = "000001";
				sRtnMaxNewID = PreFix + MaxNewDate + InitSerial;
	
			} else{
	
				SimpleDateFormat formatter = new SimpleDateFormat("YYYYMMdd");
				MaxNewDate = formatter.format( ToDay ); 
	
				MaxDate =  MaxID.substring(1, 9);
	
				//			if(MaxDate == MaxNewDate){
				//				MaxSerial = MaxID.substring(9, 15);
				//				
				//				int intMS = Integer.parseInt(MaxSerial) + 1;
				//				String stIntMS = "000000" + Integer.toString(intMS);		
				//				MaxNewID = PreFix + MaxDate + stIntMS.substring(stIntMS.length()-6, stIntMS.length());
				//				
				//			}else {
				//				MaxSerial = MaxID.substring(9, 15);
				//				
				//				int intMS = Integer.parseInt(MaxSerial) + 1;
				//				String stIntMS = "000000" + Integer.toString(intMS);		
				//				MaxNewID = PreFix + MaxDate + stIntMS.substring(stIntMS.length()-6, stIntMS.length());
				//			}
	
				MaxSerial = MaxID.substring(9, 15);
	
				intMS = Integer.parseInt(MaxSerial) + 1;
				stIntMS = "000000" + Integer.toString(intMS);		
				sRtnMaxNewID = PreFix + MaxDate + stIntMS.substring(stIntMS.length()-6, stIntMS.length());
	
			}
	
			return sRtnMaxNewID;
			
		} catch (Exception e) {
			throw new Exception(e.getMessage());
		} finally {

		}
	}

	/** 함수명 : nfnGetMaxIDByContents
	 * @param CompanyID, ContentsCode
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("resource")
	public static String nfnGetMaxIDByContents(String CompanyID, String ContentsCode) throws Exception {

		String sRtnReturnID = "";
		
		Connection  conn = null;
		PreparedStatement pstmt = null;
		ResultSet   rs = null;
		
		try{
			String MaxID = "";
			String TempID = "";
			
			StringBuffer  sql = new StringBuffer();
			
			Class.forName("cubrid.jdbc.driver.CUBRIDDriver");
			conn = DriverManager.getConnection("jdbc:default:connection");
			//			conn = DriverManager.getConnection("jdbc:CUBRID:192.168.1.220:33000:OmegaPlus:::?charSet=utf-8","unilite","UNILITE");

			sql.setLength(0);
			sql.append("SELECT nfnGetCommonCodeValue( ? , 'NZ01',  ?  ) ");
			sql.append("       + TO_CHAR(SYSTIMESTAMP, 'yyyymmdd') + '%' ");
			sql.append("FROM   DB_ROOT");

			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(1, CompanyID);
			pstmt.setString(2, ContentsCode);

			rs = pstmt.executeQuery();

			while(rs.next()){
				TempID = rs.getString(1);
			}
			
			rs.close();
			pstmt.close();

			//--X0001	사용자생성메뉴
			if(ContentsCode.equals("X0001")){
				sql.setLength(0);
				sql.append("SELECT  MAX(TBMENU.PGM_ID) ");
				sql.append("FROM   TBMENU ");
				sql.append("WHERE  TBMENU.PGM_ID LIKE  ? ");

				pstmt = conn.prepareStatement(sql.toString());
				
				pstmt.setString(1, TempID);

				rs = pstmt.executeQuery();

				while(rs.next()){
					MaxID = rs.getString(1);
				}
				
				rs.close();
				pstmt.close();

			} else if(ContentsCode.equals("X0002")){		//--X0002	게시판
				sql.setLength(0);
				sql.append("SELECT   Max(TBNOTICE.NOTICEID) ");
				sql.append("FROM   TBNOTICE ");
				sql.append("WHERE  TBNOTICE.NOTICEID LIKE @TempID");

				pstmt = conn.prepareStatement(sql.toString());
				
				pstmt.setString(1, TempID);

				rs = pstmt.executeQuery();

				while(rs.next()){
					MaxID = rs.getString(1);
				}
				
				rs.close();
				pstmt.close();

			} else if(ContentsCode.equals("X0003")){		//--X0003	전자결재
				sql.setLength(0);
				sql.append("SELECT  MAX(TBAPPROVALDOC.DOCUMENTID) ");
				sql.append("FROM   TBAPPROVALDOC ");
				sql.append("WHERE  TBAPPROVALDOC.DOCUMENTID LIKE  ?  ");

				pstmt = conn.prepareStatement(sql.toString());
				
				pstmt.setString(1, TempID);

				rs = pstmt.executeQuery();

				while(rs.next()){
					MaxID = rs.getString(1);
				}
				
				rs.close();
				pstmt.close();

			} else if(ContentsCode.equals("X0004")){		//--X0004	문서서식
				sql.setLength(0);
				sql.append("SELECT   Max(TBAPPROVALFORM.FORMID) ");
				sql.append("FROM   TBAPPROVALFORM ");
				sql.append("WHERE  TBAPPROVALFORM.FORMID LIKE  ?  ");

				pstmt = conn.prepareStatement(sql.toString());
				
				pstmt.setString(1, TempID);

				rs = pstmt.executeQuery();

				while(rs.next()){
					MaxID = rs.getString(1);
				}
				
				rs.close();
				pstmt.close();

			} else if(ContentsCode.equals("X0005")){		//--X0005	결재경로
				sql.setLength(0);
				sql.append("SELECT  Max(TBAPPROVALPATH.PATHID) ");
				sql.append("FROM   TBAPPROVALPATH ");
				sql.append("WHERE  TBAPPROVALPATH.PATHID LIKE  ?  ");

				pstmt = conn.prepareStatement(sql.toString());
				
				pstmt.setString(1, TempID);

				rs = pstmt.executeQuery();

				while(rs.next()){
					MaxID = rs.getString(1);
				}
				
				rs.close();
				pstmt.close();

			} else if(ContentsCode.equals("X0006")){		//--X0006	업무일지
				sql.setLength(0);
				sql.append("SELECT   Max(TBJOURNAL.JOURNALID) ");
				sql.append("FROM   TBJOURNAL ");
				sql.append("WHERE  TBJOURNAL.JOURNALID LIKE  ?  ");

				pstmt = conn.prepareStatement(sql.toString());
				
				pstmt.setString(1, TempID);

				rs = pstmt.executeQuery();

				while(rs.next()){
					MaxID = rs.getString(1);
				}
				
				rs.close();
				pstmt.close();

			} else if(ContentsCode.equals("X0007")){		//--X0007	업무일지경로
				sql.setLength(0);
				sql.append("SELECT  Max(TBJOURNALPATH.PATHID) ");
				sql.append("FROM   TBJOURNALPATH ");
				sql.append("WHERE  TBJOURNALPATH.PATHID LIKE  ?  ");

				pstmt = conn.prepareStatement(sql.toString());
				
				pstmt.setString(1, TempID);

				rs = pstmt.executeQuery();

				while(rs.next()){
					MaxID = rs.getString(1);
				}
				
				rs.close();
				pstmt.close();
			} else if(ContentsCode.equals("X0008")){		//--X0008	보낸쪽지
				sql.setLength(0);
				sql.append("SELECT   Max(TBNOTESEND.SENDNOTEID) ");
				sql.append("FROM   TBNOTESEND ");
				sql.append("WHERE  TBNOTESEND.SENDNOTEID LIKE  ?  ");

				pstmt = conn.prepareStatement(sql.toString());
				
				pstmt.setString(1, TempID);

				rs = pstmt.executeQuery();

				while(rs.next()){
					MaxID = rs.getString(1);
				}
				
				rs.close();
				pstmt.close();

			} else if(ContentsCode.equals("X0009")){		//--X0009	받은쪽지
				sql.setLength(0);
				sql.append("SELECT   Max(TBNOTERCV.RCVNOTEID) ");
				sql.append("FROM   TBNOTERCV ");
				sql.append("WHERE  TBNOTERCV.RCVNOTEID LIKE  ?  ");

				pstmt = conn.prepareStatement(sql.toString());
				
				pstmt.setString(1, TempID);

				rs = pstmt.executeQuery();

				while(rs.next()){
					MaxID = rs.getString(1);
				}
				
				rs.close();
				pstmt.close();

			} else if(ContentsCode.equals("X0010")){		//--X0010	근태코드
				sql.setLength(0);
				sql.append("SELECT   Max(TBWORKCODE.WORKID) ");
				sql.append("FROM   TBWORKCODE ");
				sql.append("WHERE  TBWORKCODE.WORKID LIKE  ?  ");

				pstmt = conn.prepareStatement(sql.toString());
				
				pstmt.setString(1, TempID);

				rs = pstmt.executeQuery();

				while(rs.next()){
					MaxID = rs.getString(1);
				}
				
				rs.close();
				pstmt.close();

			} else if(ContentsCode.equals("X0011")){		//--X0011	연차코드
				sql.setLength(0);
				sql.append("SELECT   Max(TBWORKHOLIDAYCODE.HOLIDAYID) ");
				sql.append("FROM   TBWORKHOLIDAYCODE ");
				sql.append("WHERE  TBWORKHOLIDAYCODE.HOLIDAYID LIKE  ?  ");

				pstmt = conn.prepareStatement(sql.toString());
				
				pstmt.setString(1, TempID);

				rs = pstmt.executeQuery();

				while(rs.next()){
					MaxID = rs.getString(1);
				}
				
				rs.close();
				pstmt.close();

			} else if(ContentsCode.equals("X0012")){		//--X0012	연동코드
				sql.setLength(0);
				sql.append("SELECT   Max(TBLINKCODE.LINKID) ");
				sql.append("FROM   TBLINKCODE ");
				sql.append("WHERE  TBLINKCODE.LINKID LIKE  ?  ");

				pstmt = conn.prepareStatement(sql.toString());
				
				pstmt.setString(1, TempID);

				rs = pstmt.executeQuery();

				while(rs.next()){
					MaxID = rs.getString(1);
				}
				
				rs.close();
				pstmt.close();

			}else if(ContentsCode.equals("X0013")){		//--X0013	연동데이터코드
				sql.setLength(0);
				sql.append("SELECT   Max(TBLINKDATACODE.DATAID) ");
				sql.append("FROM   TBLINKDATACODE ");
				sql.append("WHERE  TBLINKDATACODE.DATAID LIKE  ?  ");

				pstmt = conn.prepareStatement(sql.toString());
				
				pstmt.setString(1, TempID);

				rs = pstmt.executeQuery();

				while(rs.next()){
					MaxID = rs.getString(1);
				}
				
				rs.close();
				pstmt.close();

			} else if(ContentsCode.equals("X0014")){		//--X0014	주소록
				sql.setLength(0);
				sql.append("SELECT   Max(TBCONTACT.CONTACTID) ");
				sql.append("FROM   TBCONTACT ");
				sql.append("WHERE  TBCONTACT.CONTACTID LIKE  ?  ");

				pstmt = conn.prepareStatement(sql.toString());
				
				pstmt.setString(1, TempID);

				rs = pstmt.executeQuery();

				while(rs.next()){
					MaxID = rs.getString(1);
				}
				
				rs.close();
				pstmt.close();

			} else if(ContentsCode.equals("X0015")){		//--X0015	주소록 폴더
				sql.setLength(0);
				sql.append("SELECT   Max(TBCONTACTFOLDER.FOLDERID) ");
				sql.append("FROM   TBCONTACTFOLDER ");
				sql.append("WHERE  TBCONTACTFOLDER.FOLDERID LIKE  ?  ");

				pstmt = conn.prepareStatement(sql.toString());
				
				pstmt.setString(1, TempID);

				rs = pstmt.executeQuery();

				while(rs.next()){
					MaxID = rs.getString(1);
				}
				
				rs.close();
				pstmt.close();

			} else if(ContentsCode.equals("X0016")){		//--X0016	스케쥴
				sql.setLength(0);
				sql.append("SELECT   Max(TBSCHEDULE.SCHEDULEID) ");
				sql.append("FROM   TBSCHEDULE ");
				sql.append("WHERE  TBSCHEDULE.SCHEDULEID LIKE  ?  ");

				pstmt = conn.prepareStatement(sql.toString());
				
				pstmt.setString(1, TempID);

				rs = pstmt.executeQuery();

				while(rs.next()){
					MaxID = rs.getString(1);
				}
				
				rs.close();
				pstmt.close();

			} else if(ContentsCode.equals("X0017")){		//--X0017	스케쥴반복ID
				sql.setLength(0);
				sql.append("SELECT   Max(TBSCHEDULERECURRENCE.RECURID) ");
				sql.append("FROM   TBSCHEDULERECURRENCE ");
				sql.append("WHERE  TBSCHEDULERECURRENCE.RECURID LIKE  ?  ");

				pstmt = conn.prepareStatement(sql.toString());
				
				pstmt.setString(1, TempID);

				rs = pstmt.executeQuery();

				while(rs.next()){
					MaxID = rs.getString(1);
				}
				
				rs.close();
				pstmt.close();

			} else if(ContentsCode.equals("X0018")){		//--X0018	부재자설정ID
				sql.setLength(0);
				sql.append("SELECT  Max(LEAVEID) ");
				sql.append("FROM   TBAPPROVALUSERLEAVECONFIG ");
				sql.append("WHERE  LEAVEID LIKE  ?  ");

				pstmt = conn.prepareStatement(sql.toString());
				
				pstmt.setString(1, TempID);

				rs = pstmt.executeQuery();

				while(rs.next()){
					MaxID = rs.getString(1);
				}
				
				rs.close();
				pstmt.close();

			} else if(ContentsCode.equals("X0020")){//--X0020 근태( tbWorkStatus )
				sql.setLength(0);
				sql.append("SELECT  Max(TBWORKSTATUS.WORKSTATUSID) ");
				sql.append("FROM   TBWORKSTATUS ");
				sql.append("WHERE  TBWORKSTATUS.WORKSTATUSID LIKE  ?  ");

				pstmt = conn.prepareStatement(sql.toString());
				
				pstmt.setString(1, TempID);

				rs = pstmt.executeQuery();

				while(rs.next()){
					MaxID = rs.getString(1);
				}
				
				rs.close();
				pstmt.close();

			} else if(ContentsCode.equals("X0021")){		//--X0021 연결
				sql.setLength(0);
				sql.append("SELECT   Max(TBLINKCONNECTID.CONNECTID) ");
				sql.append("FROM   TBLINKCONNECTID ");
				sql.append("WHERE  TBLINKCONNECTID.CONNECTID LIKE  ?  ");

				pstmt = conn.prepareStatement(sql.toString());
				
				pstmt.setString(1, TempID);

				rs = pstmt.executeQuery();

				while(rs.next()){
					MaxID = rs.getString(1);
				}
				
				rs.close();
				pstmt.close();
			}

			sql.setLength(0);
			sql.append("SELECT nfnGetMaxID(nfnGetCommonCodeValue( ? , 'NZ01',  ? ), ");
			sql.append("        ? ) ");
			sql.append("FROM   DB_ROOT");

			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(1, CompanyID);
			pstmt.setString(2, ContentsCode);
			pstmt.setString(3, MaxID);

			rs = pstmt.executeQuery();

			while(rs.next()){
				sRtnReturnID = rs.getString(1);
			}
			
			rs.close();
			pstmt.close();

			return sRtnReturnID;
			
		} catch (Exception e) {
			throw new Exception(e.getMessage());
		} finally {
			if (rs != null) rs.close();
			if (pstmt != null) pstmt.close();
			if (conn != null) conn.close();
		}
	}

	/** 함수명 : nfnGetMenuBox
	 * @param s_Comp_Code, s_Pgm_ID
	 * @return
	 * @throws Exception
	 */
	public static String nfnGetMenuBox(String s_Comp_Code, String s_Pgm_ID)  throws Exception {	
		String sReturn = "";

		Connection  conn = null;
		PreparedStatement pstmt = null;
		ResultSet   rs = null;
		
		try{
			StringBuffer  sql = new StringBuffer();
			
			Class.forName("cubrid.jdbc.driver.CUBRIDDriver");
			conn = DriverManager.getConnection("jdbc:default:connection");
			//			conn = DriverManager.getConnection("jdbc:CUBRID:192.168.1.220:33000:OmegaPlus:::?charSet=utf-8","unilite","UNILITE");

			sql.setLength(0);
			sql.append("SELECT  SUB_CODE ");
			sql.append("FROM   BSA100T ");
			sql.append("WHERE  COMP_CODE =  ?  ");
			sql.append("       AND MAIN_CODE = 'NZ05' ");
			sql.append("       AND REF_CODE1 =  ?  ");

			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(1, s_Comp_Code);
			pstmt.setString(2, s_Pgm_ID);

			rs = pstmt.executeQuery();

			while(rs.next()){
				sReturn = rs.getString(1);
			}
			
			rs.close();
			pstmt.close();

			return sReturn;
			
		} catch (Exception e) {
			throw new Exception(e.getMessage());
		} finally {
			if (rs != null) rs.close();
			if (pstmt != null) pstmt.close();
			if (conn != null) conn.close();
		}
	}

	/* ***********************************  
	함수명   : nfnGetUniqueKey  
	입력인자 :  
	반환값   : unique Key           
	 *********************************** */ 
	public static String nfnGetUniqueKey() throws Exception {
		String sRtnUUID = "";

		Connection conn = null;
		PreparedStatement  pstmt = null;
		ResultSet rs = null;

		try{
			StringBuffer sql = new StringBuffer();
			
			Class.forName("cubrid.jdbc.driver.CUBRIDDriver");
			conn = DriverManager.getConnection("jdbc:default:connection");
//			conn = DriverManager.getConnection("jdbc:CUBRID:192.168.1.220:33000:OmegaPlus:::?charSet=utf-8","unilite","UNILITE");
			
			sql.append(" SELECT ");
			sql.append(" ( SELECT TO_CHAR(RANDOM(), '0000000000') + TO_CHAR(SYSDATETIME, 'YYYYMMDDHH24MISSFF') + TO_CHAR(RANDOM()%10000, '00000') ) AS unique_key "); 
			sql.append(" FROM ");
			sql.append(" db_root ");

			pstmt = conn.prepareStatement(sql.toString());

			rs = pstmt.executeQuery();

			while(rs.next()){
				sRtnUUID = rs.getString(1);
			}

			rs.close();    
			pstmt.close();
			
			return sRtnUUID;
			
		} catch (Exception e) {
			throw new Exception(e.getMessage());
		} finally {
			if (rs != null) rs.close();
			if (pstmt != null) pstmt.close();
			if (conn != null) conn.close();
		}
	}

	/** 함수명 : nfnGetUserAbilName
	 * @param CompCode, UserID, Language
	 * @return
	 * @throws Exception
	 */
	public static String nfnGetUserAbilName(String CompCode, String UserID, String Language ) throws Exception {

		String sRtnPosName = "";

		Connection  conn = null;
		PreparedStatement pstmt = null;
		ResultSet   rs = null;
		
		try{
			StringBuffer  sql = new StringBuffer();
			
			Class.forName("cubrid.jdbc.driver.CUBRIDDriver");
			conn = DriverManager.getConnection("jdbc:default:connection");
			//			conn = DriverManager.getConnection("jdbc:CUBRID:192.168.1.220:33000:OmegaPlus:::?charSet=utf-8","unilite","UNILITE");

			sql.setLength(0);
			sql.append("SELECT nfnGetCommonCodeName( ? , 'H006', ABIL_CODE,  ? ) ");
			sql.append("FROM   BSA300T ");
			sql.append("WHERE  COMP_CODE =  ?  ");
			sql.append("   AND USER_ID =  ?  ");

			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(1, CompCode);
			pstmt.setString(2, Language);
			pstmt.setString(3, CompCode);
			pstmt.setString(4, UserID);

			rs = pstmt.executeQuery();

			while(rs.next()){
				sRtnPosName = rs.getString(1);
			}
			
			rs.close();
			pstmt.close();

			return sRtnPosName;
			
		} catch (Exception e) {
			throw new Exception(e.getMessage());
		} finally {
			if (rs != null) rs.close();
			if (pstmt != null) pstmt.close();
			if (conn != null) conn.close();
		}
	}

	/** 함수명 : nfnGetUserDeptName
	 * @param CompCode, UserID
	 * @return
	 * @throws Exception
	 */
	public static String nfnGetUserDeptName(String CompCode, String UserID ) throws Exception {
		String sRtnDeptName = "";

		Connection  conn = null;
		PreparedStatement pstmt = null;
		ResultSet   rs = null;
		
		try{
			StringBuffer  sql = new StringBuffer();
			
			Class.forName("cubrid.jdbc.driver.CUBRIDDriver");
			conn = DriverManager.getConnection("jdbc:default:connection");
			//			conn = DriverManager.getConnection("jdbc:CUBRID:192.168.1.220:33000:OmegaPlus:::?charSet=utf-8","unilite","UNILITE");

			sql.setLength(0);
			sql.append("SELECT TREE_NAME ");
			sql.append("FROM   BSA300T ");
			sql.append("       INNER JOIN BSA210T ");
			sql.append("               ON BSA300T.COMP_CODE = BSA210T.COMP_CODE ");
			sql.append("                  AND BSA300T.DEPT_CODE = BSA210T.TREE_CODE ");
			sql.append("WHERE  BSA300T.COMP_CODE =  ?  ");
			sql.append("   AND BSA300T.USER_ID =  ?  ");

			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(1, CompCode);
			pstmt.setString(2, UserID);

			rs = pstmt.executeQuery();

			while(rs.next()){
				sRtnDeptName = rs.getString(1);
			}
			rs.close();
			pstmt.close();

			return sRtnDeptName;
			
		} catch (Exception e) {
			throw new Exception(e.getMessage());
		} finally {
			if (rs != null) rs.close();
			if (pstmt != null) pstmt.close();
			if (conn != null) conn.close();
		}
	}

	/** 함수명 : nfnGetUserName
	 * @param CompCode, UserID
	 * @return
	 * @throws Exception
	 */
	public static String nfnGetUserName(String CompCode, String UserID) throws Exception {
		String sRtnUserName = "";

		Connection  conn = null;
		PreparedStatement pstmt = null;
		ResultSet   rs = null;
		
		try{
			StringBuffer  sql = new StringBuffer();
			
			Class.forName("cubrid.jdbc.driver.CUBRIDDriver");
			conn = DriverManager.getConnection("jdbc:default:connection");
			//			conn = DriverManager.getConnection("jdbc:CUBRID:192.168.1.220:33000:OmegaPlus:::?charSet=utf-8","unilite","UNILITE");

			sql.setLength(0);
			sql.append("SELECT  USER_NAME ");
			sql.append("FROM   BSA300T ");
			sql.append("WHERE  COMP_CODE =  ?  ");
			sql.append("       AND USER_ID =  ?  ");

			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(1, CompCode);
			pstmt.setString(2, UserID);

			rs = pstmt.executeQuery();

			while(rs.next()){
				sRtnUserName = rs.getString(1);
			}
			
			rs.close();
			pstmt.close();

			if (sRtnUserName == null || sRtnUserName.equals("")){
				sRtnUserName = UserID;
			}

			return sRtnUserName;
			
		} catch (Exception e) {
			throw new Exception(e.getMessage());
		} finally {
			if (rs != null) rs.close();
			if (pstmt != null) pstmt.close();
			if (conn != null) conn.close();
		}
	}

	/** 함수명 : nfnGetUserPosName
	 * @param CompCode, UserID, Language
	 * @return
	 * @throws Exception
	 */
	public static String nfnGetUserPosName(String CompCode, String UserID, String Language) throws Exception {
		String sRtnPosName = "";

		Connection  conn = null;
		PreparedStatement pstmt = null;
		ResultSet   rs = null;
		
		try{
			StringBuffer  sql = new StringBuffer();
			
			Class.forName("cubrid.jdbc.driver.CUBRIDDriver");
			conn = DriverManager.getConnection("jdbc:default:connection");
			//			conn = DriverManager.getConnection("jdbc:CUBRID:192.168.1.220:33000:OmegaPlus:::?charSet=utf-8","unilite","UNILITE");

			sql.setLength(0);
			sql.append("SELECT nfnGetCommonCodeName( ? , 'H005', post_code,  ? ) ");
			sql.append("FROM   BSA300T ");
			sql.append("WHERE  comp_code =  ?  ");
			sql.append("       AND user_id =  ? ");

			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(1, CompCode);
			pstmt.setString(2, Language);
			pstmt.setString(3, CompCode);
			pstmt.setString(4, UserID);

			rs = pstmt.executeQuery();

			while(rs.next()){
				sRtnPosName = rs.getString(1);
			}
			
			rs.close();
			pstmt.close();

			if (sRtnPosName == null || sRtnPosName.equals("")){
				sRtnPosName = UserID;
			}

			return sRtnPosName;
			
		} catch (Exception e) {
			throw new Exception(e.getMessage());
		} finally {
			if (rs != null) rs.close();
			if (pstmt != null) pstmt.close();
			if (conn != null) conn.close();
		}
	}

	/** 함수명 : nfnMenuListByUser
	 * @param COMP_CODE, PGM_SEQ, USER_ID
	 * @return
	 * @throws Exception
	 */
	public static String nfnMenuListByUser(String COMP_CODE, String PGM_SEQ, String USER_ID) throws Exception {
		String sRtnUUID = "";		//UniqueKey
		
		Connection  conn = null;
		PreparedStatement pstmt = null;
		ResultSet   rs = null;
		
		try{
			int iLvl = 0;
			boolean bFlag = true;
			int iCnt = 0;
			
			StringBuffer  sql = new StringBuffer();
			
			Class.forName("cubrid.jdbc.driver.CUBRIDDriver");
			conn = DriverManager.getConnection("jdbc:default:connection");
			//conn = DriverManager.getConnection("jdbc:CUBRID:192.168.1.220:33000:OmegaPlus:::?charSet=utf-8","unilite","UNILITE");

			//UniqueKey 생성
			sql.setLength(0);
			sql.append("SELECT nfnGetUniqueKey() ");
			sql.append("FROM   DB_ROOT ");

			pstmt = conn.prepareStatement(sql.toString());
			rs = pstmt.executeQuery();

			while(rs.next()){
				sRtnUUID = rs.getString(1);
			}
			
			rs.close();
			pstmt.close();

			iLvl = iLvl + 1;

			sql.setLength(0);
			sql.append("INSERT INTO t_nfnmenulistbyuser ");
			sql.append("            (KEY_VALUE ");
			sql.append("             ,COMP_CODE ");
			sql.append("             ,PGM_SEQ ");
			sql.append("             ,PGM_ID ");
			sql.append("             ,PGM_NAME ");
			sql.append("             ,UP_PGM_DIV ");
			sql.append("             ,[TYPE] ");
			sql.append("             ,USE_YN ");
			sql.append("             ,LVL) ");
			sql.append("SELECT  ?  AS KEY_VALUE ");
			sql.append("       ,COMP_CODE ");
			sql.append("       ,PGM_SEQ ");
			sql.append("       ,PGM_ID ");
			sql.append("       ,PGM_NAME ");
			sql.append("       ,UP_PGM_DIV ");
			sql.append("       ,TYPE ");
			sql.append("       ,USE_YN ");
			sql.append("       , ?      AS lvl ");
			sql.append("FROM   BSA400T ");
			sql.append("WHERE  COMP_CODE =  ?  ");
			sql.append("       AND PGM_SEQ =  ?  ");
			sql.append("       AND TYPE = '9' ");
			sql.append("       AND USE_YN = '1' ");
			sql.append("       AND UP_PGM_DIV =  ?  ");

			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(1, sRtnUUID);
			pstmt.setInt(2, iLvl);
			pstmt.setString(3, COMP_CODE);
			pstmt.setString(4, PGM_SEQ);
			pstmt.setString(5, PGM_SEQ);

			pstmt.executeUpdate();
			
			pstmt.close();

			while(bFlag){

				iCnt = 0;
				if (iLvl > 15)
					break;

				sql.setLength(0);
				sql.append(" SELECT ");
				sql.append(" COUNT(*) ");
				sql.append(" FROM ");
				sql.append(" t_nfnmenulistbyuser ");
				sql.append(" WHERE ");
				sql.append(" key_value = '").append(sRtnUUID).append("' ");
				sql.append(" AND lvl = ").append(String.valueOf(iLvl));	

				pstmt = conn.prepareStatement(sql.toString());

				rs = pstmt.executeQuery();

				while(rs.next()){
					iCnt = rs.getInt(1);
				}

				rs.close();    
				pstmt.close();

				if (iCnt > 0){
					bFlag = true;
				}
				else{
					bFlag = false;
					break;
				}

				if (bFlag){
					sql.setLength(0);
					sql.append("INSERT INTO t_nfnmenulistbyuser ");
					sql.append("            (KEY_VALUE ");
					sql.append("             ,COMP_CODE ");
					sql.append("             ,PGM_SEQ ");
					sql.append("             ,PGM_ID ");
					sql.append("             ,PGM_NAME ");
					sql.append("             ,UP_PGM_DIV ");
					sql.append("             ,[TYPE] ");
					sql.append("             ,USE_YN ");
					sql.append("             ,LVL) ");
					sql.append("SELECT  ?       AS key_value ");
					sql.append("       ,TA.COMP_CODE ");
					sql.append("       ,TA.PGM_SEQ ");
					sql.append("       ,TA.PGM_ID ");
					sql.append("       ,TA.PGM_NAME ");
					sql.append("       ,TA.UP_PGM_DIV ");
					sql.append("       ,TA.TYPE ");
					sql.append("       ,TA.USE_YN ");
					sql.append("       ,( tb.LVL + 1 ) AS lvl ");
					sql.append("FROM   (SELECT COMP_CODE ");
					sql.append("               ,PGM_SEQ ");
					sql.append("               ,PGM_ID ");
					sql.append("               ,PGM_NAME ");
					sql.append("               ,UP_PGM_DIV ");
					sql.append("               ,TYPE ");
					sql.append("               ,USE_YN ");
					sql.append("        FROM   BSA400T ");
					sql.append("        WHERE  COMP_CODE =  ? ");
					sql.append("               AND PGM_SEQ =  ?  ");
					sql.append("               AND TYPE = '9' ");
					sql.append("               AND USE_YN = '1' ");
					sql.append("        UNION ALL ");
					sql.append("        SELECT T1.COMP_CODE ");
					sql.append("               ,T1.PGM_SEQ ");
					sql.append("               ,T1.PGM_ID ");
					sql.append("               ,T1.PGM_NAME ");
					sql.append("               ,T1.UP_PGM_DIV ");
					sql.append("               ,T1.TYPE ");
					sql.append("               ,T1.USE_YN ");
					sql.append("        FROM   BSA400T T1 ");
					sql.append("               INNER JOIN BSA500T T2 ");
					sql.append("                       ON ( T1.COMP_CODE = T2.COMP_CODE ");
					sql.append("                            AND T1.PGM_ID = T2.PGM_ID ) ");
					sql.append("        WHERE  T1.COMP_CODE =  ?  ");
					sql.append("               AND T1.PGM_SEQ =  ?  ");
					sql.append("               AND T1.TYPE NOT IN ( '0', '9' ) ");
					sql.append("               AND T1.USE_YN = '1' ");
					sql.append("               AND T2.USER_ID =  ?  ");
					sql.append("        UNION ALL ");
					sql.append("        SELECT T1.COMP_CODE ");
					sql.append("               ,T1.PGM_SEQ ");
					sql.append("               ,T1.PGM_ID ");
					sql.append("               ,T1.PGM_NAME ");
					sql.append("               ,T1.UP_PGM_DIV ");
					sql.append("               ,T1.TYPE ");
					sql.append("               ,T1.USE_YN ");
					sql.append("        FROM   TBMENU T1 ");
					sql.append("               INNER JOIN TBMENUUSER T2 ");
					sql.append("                       ON ( T1.COMP_CODE = T2.COMP_CODE ");
					sql.append("                            AND T1.PGM_ID = T2.PGM_ID ) ");
					sql.append("        WHERE  T1.COMP_CODE =  ?  ");
					sql.append("               AND T1.PGM_SEQ =  ?  ");
					sql.append("               AND T1.TYPE <> '0' ");
					sql.append("               AND T1.USE_YN = '1' ");
					sql.append("               AND T2.USER_ID =  ? ) TA ");
					sql.append("       INNER JOIN t_nfnmenulistbyuser TB ");
					sql.append("               ON ( TB.PGM_ID = TA.UP_PGM_DIV )");
					sql.append("               and tb.key_value =  ?  ");
					sql.append("               and tb.lvl =  ? ");

					pstmt = conn.prepareStatement(sql.toString());
					
					pstmt.setString(1, sRtnUUID);
					pstmt.setString(2, COMP_CODE);
					pstmt.setString(3, PGM_SEQ);
					pstmt.setString(4, COMP_CODE);
					pstmt.setString(5, PGM_SEQ);
					pstmt.setString(6, USER_ID);
					pstmt.setString(7, COMP_CODE);
					pstmt.setString(8, PGM_SEQ);
					pstmt.setString(9, USER_ID);
					pstmt.setString(10, sRtnUUID);
					pstmt.setInt(11, iLvl);

					pstmt.executeUpdate();

					pstmt.close();

				}

				iLvl = iLvl + 1;
			}

			return sRtnUUID;
			
		} catch (Exception e) {
			throw new Exception(e.getMessage());   
		} finally {
			if (rs != null) rs.close();
			if (pstmt != null) pstmt.close();
			if (conn != null) conn.close();
		}
	}

	/* ***********************************  
		함수명   : nfnSelectDeptTree  
		입력인자 : Comp_Code, 사용자ID, 권한구분, 사업장 
		반환값   : 트리형태 부서, 부서원          
	 *********************************** */ 
	public static String nfnSelectDeptTree(String sCompCode, String sUserId, String sAuthFlag, String sDivCode) throws Exception  {
		String sRtnUUID = "";

		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try{
			String sKeyValue1 = "";
			String sKeyValue2 = "";
			int iLvl = 0;
			boolean bFlag = true;
			int iCnt = 0;
			String sTempParentId = "";
			
			StringBuffer sql = new StringBuffer();

			Class.forName("cubrid.jdbc.driver.CUBRIDDriver");
			conn = DriverManager.getConnection("jdbc:default:connection");
			//			conn = DriverManager.getConnection("jdbc:CUBRID:192.168.1.220:33000:OmegaPlus:::?charSet=utf-8","unilite","UNILITE");

			sql.append(" SELECT ");
			sql.append(" nfnDeptTreeData('").append(sCompCode).append("') "); 
			sql.append(" FROM ");
			sql.append(" db_root ");

			pstmt = conn.prepareStatement(sql.toString());

			rs = pstmt.executeQuery();

			while(rs.next()){
				sKeyValue1 = rs.getString(1);
			}

			rs.close();    
			pstmt.close();

			sql.setLength(0);
			sql.append(" SELECT ");
			sql.append(" nfnCompanyIDList('").append(sUserId).append("', '").append(sCompCode).append("') "); 
			sql.append(" FROM ");
			sql.append(" db_root ");

			pstmt = conn.prepareStatement(sql.toString());

			rs = pstmt.executeQuery();

			while(rs.next()){
				sKeyValue2 = rs.getString(1);
			}

			rs.close();    
			pstmt.close();

			sql.setLength(0);
			sql.append(" SELECT ");
			sql.append(" nfngetuniquekey() AS unique_key "); 
			sql.append(" FROM ");
			sql.append(" db_root ");

			pstmt = conn.prepareStatement(sql.toString());

			rs = pstmt.executeQuery();

			while(rs.next()){
				sRtnUUID = rs.getString(1);
			}

			rs.close();    
			pstmt.close();

			iLvl = iLvl + 1;

			sql.setLength(0);
			sql.append(" INSERT INTO t_nfnselectdepttree ");
			sql.append(" ( ");
			sql.append(" key_value ");
			sql.append(" ,id ");
			sql.append(" ,parentid ");
			sql.append(" ,comp_code ");
			sql.append(" ,div_code ");
			sql.append(" ,tree_code ");
			sql.append(" ,text ");
			sql.append(" ,depttype ");
			sql.append(" ,dept_code ");
			sql.append(" ,email ");
			sql.append(" ,sort ");
			sql.append(" ,lvl ");
			sql.append(" ) ");
			sql.append(" SELECT ");
			sql.append(" '").append(sRtnUUID).append("' ");
			sql.append(" ,id ");
			sql.append(" ,parentid ");
			sql.append(" ,comp_code ");
			sql.append(" ,div_code ");
			sql.append(" ,tree_code ");
			sql.append(" ,text ");
			sql.append(" ,'P' AS depttype ");
			sql.append(" ,tree_code AS dept_code ");
			sql.append(" ,CAST('' AS varchar) AS email");
			sql.append(" ,CAST(id AS varchar) AS sort ");
			sql.append(" ,").append(String.valueOf(iLvl)).append(" AS lvl ");
			sql.append(" FROM ");
			sql.append(" t_nfndepttreedata ");
			sql.append(" WHERE  ");
			sql.append(" key_value = '").append(sKeyValue1).append("' ");
			sql.append(" and UPPER(parentid) = 'ROOT' "); 

			pstmt = conn.prepareStatement(sql.toString());

			pstmt.executeUpdate();

			pstmt.close();

			while(bFlag){

				iCnt = 0;

				if (iLvl > 15)
					break;

				sql.setLength(0);
				sql.append(" SELECT ");
				sql.append(" COUNT(*) ");
				sql.append(" FROM ");
				sql.append(" t_nfnselectdepttree ");
				sql.append(" WHERE ");
				sql.append(" key_value = '").append(sRtnUUID).append("' ");
				sql.append(" AND lvl = ").append(String.valueOf(iLvl));	

				pstmt = conn.prepareStatement(sql.toString());

				rs = pstmt.executeQuery();

				while(rs.next()){
					iCnt = rs.getInt(1);
				}

				rs.close();    
				pstmt.close();

				if (iCnt > 0){
					bFlag = true;
				}
				else{
					bFlag = false;
					break;
				}

				if (bFlag){

					sql.setLength(0);
					sql.append(" INSERT INTO t_nfnselectdepttree ");
					sql.append(" ( ");
					sql.append(" key_value ");
					sql.append(" ,id ");
					sql.append(" ,parentid ");
					sql.append(" ,comp_code ");
					sql.append(" ,div_code ");
					sql.append(" ,tree_code ");
					sql.append(" ,text ");
					sql.append(" ,depttype ");
					sql.append(" ,dept_code ");
					sql.append(" ,email ");
					sql.append(" ,sort ");
					sql.append(" ,lvl ");
					sql.append(" ) ");
					sql.append(" SELECT ");
					sql.append(" '").append(sRtnUUID).append("' ");
					sql.append(" ,a.id ");
					sql.append(" ,a.parentId ");
					sql.append(" ,a.comp_code ");
					sql.append(" ,a.div_code ");
					sql.append(" ,a.tree_code ");
					sql.append(" ,a.text ");
					sql.append(" ,a.depttype ");
					sql.append(" ,a.dept_code ");
					sql.append(" ,CAST(a.email AS varchar) AS email ");
					sql.append(" ,CAST(a.sort AS varchar) AS sort ");
					sql.append(" ,(b.lvl + 1) AS lvl ");
					sql.append(" FROM ");
					sql.append(" ( ");
					sql.append(" SELECT ");
					sql.append(" id ");
					sql.append(" ,parentId ");
					sql.append(" ,comp_code ");
					sql.append(" ,div_code ");
					sql.append(" ,tree_code ");
					sql.append(" ,text ");
					sql.append(" ,'D' AS depttype ");
					sql.append(" ,tree_code AS dept_code ");
					sql.append(" ,'' AS email ");
					sql.append(" ,id AS sort ");
					sql.append(" FROM ");
					sql.append(" t_nfndepttreedata ");
					sql.append(" WHERE ");
					sql.append(" key_value = '").append(sKeyValue1).append("' ");
					sql.append(" UNION ALL ");
					sql.append(" SELECT ");
					sql.append(" m.user_id AS id ");
					sql.append(" ,n.id AS parentid ");
					sql.append(" ,m.comp_code AS comp_code ");
					sql.append(" ,m.div_code AS div_code ");
					sql.append(" ,user_id AS tree_code ");
					sql.append(" ,user_name AS text ");
					sql.append(" ,'P' AS depttype ");
					sql.append(" ,m.dept_code AS dept_code ");
					sql.append(" ,m.user_name + ' &lt;' + NVL(m.email_addr ,'') + '&gt;' AS email ");
					sql.append(" ,n.id  + '000' + CAST(ROW_NUMBER() OVER( PARTITION BY m.dept_code ORDER BY m.post_code, m.abil_code, m.user_name) AS varchar) AS sort ");
					sql.append(" FROM ");
					sql.append(" bsa300t m ");
					sql.append(" INNER JOIN t_nfndepttreedata n ON m.dept_code = n.tree_code AND n.key_value = '").append(sKeyValue1).append("' ");
					sql.append(" WHERE");
					sql.append(" m.comp_code IN ( SELECT companyid FROM t_nfncompanyidlist WHERE key_value = '").append(sKeyValue2).append("') ");
					if (sAuthFlag != null && sAuthFlag.equals("1"))
						sql.append(" AND m.div_code = '").append(sDivCode).append("' ");
					sql.append(" AND m.lock_yn = 'N' ) a ");
					sql.append(" INNER JOIN t_nfnselectdepttree b ON a.parentId = b.id AND b.lvl = ").append(String.valueOf(iLvl)).append(" AND b.key_value = '").append(sRtnUUID).append("' ");

					pstmt = conn.prepareStatement(sql.toString());

					pstmt.executeUpdate();

					pstmt.close();

				}

				iLvl = iLvl + 1;
			}

			sql.setLength(0);
			sql.append(" SELECT ");
			sql.append(" nfnDeleteTableByKeyValue('t_nfndepttreedata', '").append(sKeyValue1).append("') ");
			sql.append(" FROM db_root ");

			pstmt = conn.prepareStatement(sql.toString());

			pstmt.executeQuery();

			pstmt.close();

			sql.setLength(0);
			sql.append(" SELECT ");
			sql.append(" nfnDeleteTableByKeyValue('t_nfncompanyidlist', '").append(sKeyValue2).append("') ");
			sql.append(" FROM db_root ");

			pstmt = conn.prepareStatement(sql.toString());

			pstmt.executeQuery();

			pstmt.close();

			return sRtnUUID;
			
		} catch (Exception e) {
			throw new Exception(e.getMessage());   
		} finally {
			if (rs != null) rs.close();
			if (pstmt != null) pstmt.close();
			if (conn != null) conn.close();
		}
	}

}
