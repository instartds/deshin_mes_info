package foren.unilite.multidb.cubrid.fn;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;


public class NboxProcedure_final {

	public static int SP_NBOX_ApprovalLink(String sType, String sCompanyID, String sDocumentID, String sUserID) throws Exception {	
		int iRtn = 0;
		String sRtn = "";

		Connection conn = null;
		PreparedStatement  pstmt = null;
		PreparedStatement  pstmt1 = null;
		ResultSet rs = null;
		ResultSet rs1 = null;

		StringBuffer sql = new StringBuffer();
		
		try {
			
			String sSpName = "";

			Class.forName("cubrid.jdbc.driver.CUBRIDDriver");
			conn = DriverManager.getConnection("jdbc:default:connection");
			//			conn = DriverManager.getConnection("jdbc:CUBRID:192.168.1.220:33000:OmegaPlus:::?charset=UTF-8","unilite","UNILITE");
			conn.setAutoCommit(false);

			

			sql.append(" SELECT ");
			sql.append(" linkcode.spname ");
			sql.append(" FROM ");
			sql.append(" tbapprovaldoc doc ");
			sql.append(" INNER JOIN tbapprovalform form ON doc.formid = form.formid ");
			sql.append(" INNER JOIN tblinkcodebyform link ON form.formid = link.formid ");
			sql.append(" INNER JOIN tblinkcode linkcode ON link.linkid = linkcode.linkid ");
			sql.append(" WHERE ");
			sql.append(" doc.documentid = '").append(sDocumentID).append("' ");

			pstmt = conn.prepareStatement(sql.toString());

			rs = pstmt.executeQuery();

			while(rs.next()){
				sSpName = rs.getString(1);

				iRtn = 0;

				sql.setLength(0);
				sql.append(" SELECT ");
				sql.append(" SP_NBOX_ApprovalLink_Temp( ");
				sql.append(" '").append(sSpName).append("' ");
				sql.append(" ,'").append(sType).append("' ");
				sql.append(" ,'").append(sCompanyID).append("' ");
				sql.append(" ,'").append(sDocumentID).append("' ");
				sql.append(" ,'").append(sUserID).append("') ");
				sql.append(" FROM ");
				sql.append(" db_root ");

				pstmt1 = conn.prepareStatement(sql.toString());

				rs1 = pstmt1.executeQuery();

				while(rs1.next()){
					iRtn = rs1.getInt(1);                	
				}

				rs1.close();
				pstmt1.close();

				if (iRtn != 0){
					sRtn = "SQL Server error encountered in sp_ApproveLink";
					throw new Exception(sRtn);   
				}
			}

			rs.close();
			pstmt.close();

			conn.commit();

			return iRtn;
		} catch (Exception e) {
			conn.rollback();
			throw new Exception(e.getMessage());   
		} finally {
			if (rs != null) rs.close();
			if (rs1 != null) rs1.close();
			if (pstmt != null) pstmt.close();
			if (pstmt1 != null) pstmt1.close();
			if (conn != null) conn.close();
		}

	}


	public static int SP_NBOX_ApprovalLink_Temp(String sSpName, String sType, String sCompanyID, String sDocumentID, String sUserID ) throws Exception {	
		int iRtn = 0;
		
		Connection conn = null;
		PreparedStatement  pstmt = null;
		ResultSet rs = null;

		try {
			Class.forName("cubrid.jdbc.driver.CUBRIDDriver");
			conn = DriverManager.getConnection("jdbc:default:connection");
			//			conn = DriverManager.getConnection("jdbc:CUBRID:192.168.1.220:33000:OmegaPlus:::?charset=UTF-8","unilite","UNILITE");

			StringBuffer sql = new StringBuffer();

			if (sSpName.equals("SP_NBOX_ApprovalLink01")){
				/*
				sql.setLength(0);
	        	sql.append(" SELECT ");
				sql.append(" SP_NBOX_ApprovalLink01( ");
				sql.append(" '").append(sSpName).append("' ");
				sql.append(" ,'").append(sType).append("' ");
				sql.append(" ,'").append(sCompanyID).append("' ");
				sql.append(" ,'").append(sDocumentID).append("' ");
				sql.append(" ,'").append(sUserID).append("') ");
				sql.append(" FROM ");
				sql.append(" db_root ");

				pstmt1 = conn.prepareStatement(sql.toString());

				rs = pstmt.executeQuery();

	            while(rs.next()){
	            	iRtn = rs.getInt(1);                	
	            }

	            rs.close();
	        	pstmt.close();

				 */
			}
			else if (sSpName.equals("SP_NBOX_ApprovalLink02")){
				/*
				sql.setLength(0);
	        	sql.append(" SELECT ");
				sql.append(" SP_NBOX_ApprovalLink02( ");
				sql.append(" '").append(sSpName).append("' ");
				sql.append(" ,'").append(sType).append("' ");
				sql.append(" ,'").append(sCompanyID).append("' ");
				sql.append(" ,'").append(sDocumentID).append("' ");
				sql.append(" ,'").append(sUserID).append("') ");
				sql.append(" FROM ");
				sql.append(" db_root ");

				pstmt1 = conn.prepareStatement(sql.toString());

				rs = pstmt.executeQuery();

	            while(rs.next()){
	            	iRtn = rs.getInt(1);                	
	            }

	            rs.close();
	        	pstmt.close();
				 */
			}

			return iRtn;
			
		} catch (Exception e) {
			throw new Exception(e.getMessage());   
		} finally {
			if (rs != null) rs.close();
			if (pstmt != null) pstmt.close();
			if (conn != null) conn.close();
		}
	}


	/**
	 * SP명 : SP_NBOX_ApprovalExecute
	 * @param : ExecuteType, CompanyID, DocumentID, UserID, LangCode
	 * @return
	 * @throws SQLException
	 * @throws Exception
	 */
	public static String SP_NBOX_ApprovalExecute(String ExecuteType, String CompanyID, String DocumentID, String UserID, String LangCode ) throws Exception {	
		String sRtnErrorDesc = "";  /*output*/

		Connection  conn = null;
		PreparedStatement pstmt = null;
		ResultSet   rs = null;
		
		StringBuffer  sql = new StringBuffer();
		
		try{
			String sGradeLevel = "";
			String sSignuserid = "";
			
			Class.forName("cubrid.jdbc.driver.CUBRIDDriver");
			conn = DriverManager.getConnection("jdbc:default:connection");
			//			conn = DriverManager.getConnection("jdbc:CUBRID:192.168.1.220:33000:OmegaPlus:::?charset=UTF-8","unilite","UNILITE");

			if (ExecuteType.equals("DRAFT") ){
				//EXEC SP_NBOX_ApprovalExecute_DRAFT @CompanyID, @DocumentID, @UserID, @LangCode, @ErrorDesc output
				sql.setLength(0);
				sql.append("SELECT SP_NBOX_ApprovalExecute_DRAFT(?, ?, ?, ?)  ");
				sql.append("FROM   DB_ROOT ");

				pstmt = conn.prepareStatement(sql.toString());
				
				pstmt.setString(1, CompanyID);
				pstmt.setString(2, DocumentID);
				pstmt.setString(3, UserID);
				pstmt.setString(4, LangCode);

				rs = pstmt.executeQuery();

				while(rs.next()){
					sRtnErrorDesc = rs.getString(1);
				}
				
				rs.close();
				pstmt.close();


			} else if (ExecuteType.equals("DRAFTCANCEL")){
				//EXEC SP_NBOX_ApprovalExecute_DRAFTCANCEL @CompanyID, @DocumentID, @UserID, @LangCode, @ErrorDesc output
				sql.setLength(0);
				sql.append("SELECT SP_NBOX_ApprovalExecute_DRAFTCANCEL(?, ?, ?, ?)  ");
				sql.append("FROM   DB_ROOT ");

				pstmt = conn.prepareStatement(sql.toString());
				
				pstmt.setString(1, CompanyID);
				pstmt.setString(2, DocumentID);
				pstmt.setString(3, UserID);
				pstmt.setString(4, LangCode);

				rs = pstmt.executeQuery();

				while(rs.next()){
					sRtnErrorDesc = rs.getString(1);
				}
				
				rs.close();
				pstmt.close();

			}else if (ExecuteType.equals("CONFIRM")){
				//EXEC SP_NBOX_ApprovalExecute_CONFIRM @CompanyID, @DocumentID, @UserID, @LangCode, @ErrorDesc output
				sql.setLength(0);
				sql.append("SELECT SP_NBOX_ApprovalExecute_CONFIRM(?, ?, ?, ?)  ");
				sql.append("FROM   DB_ROOT ");

				pstmt = conn.prepareStatement(sql.toString());
				
				pstmt.setString(1, CompanyID);
				pstmt.setString(2, DocumentID);
				pstmt.setString(3, UserID);
				pstmt.setString(4, LangCode);

				rs = pstmt.executeQuery();

				while(rs.next()){
					sRtnErrorDesc = rs.getString(1);
				}
				
				rs.close();
				pstmt.close();

			}else if (ExecuteType.equals("CONFIRMCANCEL")){
				//EXEC SP_NBOX_ApprovalExecute_CONFIRMCANCEL @CompanyID, @DocumentID, @UserID, @LangCode, @ErrorDesc output
				sql.setLength(0);
				sql.append(" SELECT ");
				sql.append(" grade_level  ");
				sql.append(" FROM bsa300t ");
				sql.append(" WHERE ");
				sql.append(" comp_code = ? ");
				sql.append(" and user_id = ? ");
				
				pstmt = conn.prepareStatement(sql.toString());
				
				pstmt.setString(1, CompanyID);
				pstmt.setString(2, UserID);

				rs = pstmt.executeQuery();

				while(rs.next()){
					sGradeLevel = rs.getString(1);
				}
				
				rs.close();
				pstmt.close();
				
				if (sGradeLevel != null && sGradeLevel.toUpperCase().equals("G1")){
					sql.setLength(0);
					sql.append(" SELECT ");
					sql.append(" b.signuserid ");
					sql.append(" FROM ");
					sql.append(" tbapprovaldoc a ");
					sql.append(" INNER JOIN tbapprovaldocline b ON a.documentid = b.documentid ");
					sql.append(" WHERE ");
					sql.append(" a.documentid = ? ");
					sql.append(" AND a.status = 'C' ");
					sql.append(" AND b.signflag = 'Y' ");
					sql.append(" AND b.lastflag = 'Y' ");
					sql.append(" AND b.signuserid <> ? ");
					
					pstmt = conn.prepareStatement(sql.toString());
					
					pstmt.setString(1, DocumentID);
					pstmt.setString(2, UserID);

					rs = pstmt.executeQuery();

					while(rs.next()){
						sSignuserid = rs.getString(1);
						
						if (sSignuserid != null && !sSignuserid.equals(UserID)){
							UserID = sSignuserid;
						}	
					}
					
					rs.close();
					pstmt.close();
					
				}
				
				sql.setLength(0);
				sql.append("SELECT SP_NBOX_ApprovalExecute_CONFIRMCANCEL(?, ?, ?, ?)  ");
				sql.append("FROM   DB_ROOT ");

				pstmt = conn.prepareStatement(sql.toString());
				
				pstmt.setString(1, CompanyID);
				pstmt.setString(2, DocumentID);
				pstmt.setString(3, UserID);
				pstmt.setString(4, LangCode);

				rs = pstmt.executeQuery();

				while(rs.next()){
					sRtnErrorDesc = rs.getString(1);
				}
				
				rs.close();
				pstmt.close();
				
			}else if (ExecuteType.equals("RETURN")){
				//EXEC SP_NBOX_ApprovalExecute_RETURN @CompanyID, @DocumentID, @UserID, @LangCode, @ErrorDesc output
				sql.setLength(0);
				sql.append("SELECT SP_NBOX_ApprovalExecute_RETURN(?, ?, ?, ?)  ");
				sql.append("FROM   DB_ROOT ");

				pstmt = conn.prepareStatement(sql.toString());
				
				pstmt.setString(1, CompanyID);
				pstmt.setString(2, DocumentID);
				pstmt.setString(3, UserID);
				pstmt.setString(4, LangCode);

				rs = pstmt.executeQuery();

				while(rs.next()){
					sRtnErrorDesc = rs.getString(1);
				}
				
				rs.close();
				pstmt.close();
			
			}else if (ExecuteType.equals("RETURNCANCEL")){
				//EXEC SP_NBOX_ApprovalExecute_RETURNCANCEL @CompanyID, @DocumentID, @UserID, @LangCode, @ErrorDesc output
				sql.setLength(0);
				sql.append("SELECT SP_NBOX_ApprovalExecute_RETURNCANCEL(?, ?, ?, ?)  ");
				sql.append("FROM   DB_ROOT ");

				pstmt = conn.prepareStatement(sql.toString());
				
				pstmt.setString(1, CompanyID);
				pstmt.setString(2, DocumentID);
				pstmt.setString(3, UserID);
				pstmt.setString(4, LangCode);

				rs = pstmt.executeQuery();

				while(rs.next()){
					sRtnErrorDesc = rs.getString(1);
				}
				
				rs.close();
				pstmt.close();

			}else {
				sRtnErrorDesc = "";
			}
			
			if (sRtnErrorDesc != null && !sRtnErrorDesc.equals(""))
				throw new Exception(sRtnErrorDesc);
			
			return sRtnErrorDesc;

		} catch (Exception e) {
			throw new Exception(e.getMessage());   
		} finally {
			if (rs != null) rs.close();
			if (pstmt != null) pstmt.close();
			if (conn != null) conn.close();
		}
	}


	/** SP명 : SP_NBOX_ApprovalExecute_CONFIRM
	 * @param sCompanyID, sDocumentID, sUserID, sLangCode
	 * @return
	 * @throws Exception
	 */
	public static String SP_NBOX_ApprovalExecute_CONFIRM(String sCompanyID, String sDocumentID, String sUserID, String sLangCode ) throws Exception {	

		String sRtnErrorDesc = "";	//OUTPUT	-- (반환) 에러명세

		Connection conn = null;
		PreparedStatement  pstmt = null;
		ResultSet rs = null;

		StringBuffer sql = new StringBuffer();
		
		try {
			int iSeq = 0;
			String sLastFlag = "";
			int iCnt = 0;
			String sSignImgUrl = "";
			int iNextSeq = 0;
			int sRtn = 0;

			
			
			Class.forName("cubrid.jdbc.driver.CUBRIDDriver");
			conn = DriverManager.getConnection("jdbc:default:connection");
			//			conn = DriverManager.getConnection("jdbc:CUBRID:192.168.1.220:33000:OmegaPlus:::?charset=UTF-8","unilite","UNILITE");

			sql.append(" SELECT ");
			sql.append(" Seq ");
			sql.append(" ,NVL(LastFlag,'N') ");
			sql.append(" FROM ");
			sql.append(" tbapprovaldocline ");
			sql.append(" WHERE ");
			sql.append(" documentid = '").append(sDocumentID).append("' ");
			sql.append(" AND signuserid = '").append(sUserID).append("' ");

			pstmt = conn.prepareStatement(sql.toString());

			rs = pstmt.executeQuery();

			while(rs.next()){
				iSeq = rs.getInt(1);
				sLastFlag = rs.getString(2);
			}

			rs.close();
			pstmt.close();

			sql.setLength(0);
			sql.append(" SELECT ");
			sql.append(" COUNT(*) ");
			sql.append(" FROM ");
			sql.append(" tbapprovaldocline ");
			sql.append(" WHERE ");
			sql.append(" documentid = '").append(sDocumentID).append("' ");
			sql.append(" AND Seq < ").append(iSeq).append(" ");
			sql.append(" AND SignDate IS NULL ");

			pstmt = conn.prepareStatement(sql.toString());

			rs = pstmt.executeQuery();

			while(rs.next()){
				iCnt = rs.getInt(1);
			}
			rs.close();
			pstmt.close();

			if (iCnt >= 1){
				sRtnErrorDesc = "이전 결재자가 결재를 아직 하지 않았습니다.";
				throw new Exception(sRtnErrorDesc);
			}

			sql.setLength(0);
			sql.append(" SELECT ");
			sql.append(" NVL(m.fid, 'X0007') ");
			sql.append(" FROM ");
			sql.append(" tbUserSign m ");
			sql.append(" WHERE ");
			sql.append(" m.UserID = '").append(sUserID).append("' ");
			sql.append(" AND m.CompanyID = '").append(sCompanyID).append("' ");
			sql.append(" AND m.InsertDate = ( SELECT  ");
			sql.append(" MAX(n.InsertDate) ");
			sql.append(" FROM ");
			sql.append(" tbusersign n ");
			sql.append(" WHERE ");
			sql.append(" m.userid = n.userid ");
			sql.append(" AND m.companyid = n.companyid ");
			sql.append(" AND n.insertdate <= SYSTIMESTAMP ) ");

			pstmt = conn.prepareStatement(sql.toString());

			rs = pstmt.executeQuery();

			while(rs.next()){
				sSignImgUrl = rs.getString(1);
			}

			rs.close();
			pstmt.close();

			//--결재승인
			sql.setLength(0);
			sql.append(" UPDATE tbapprovaldocline SET");
			sql.append(" [status] = 'C' ");
			sql.append(" ,signdate = SYSTIMESTAMP ");
			sql.append(" ,signimgurl ='").append(sSignImgUrl).append("' ");
			sql.append(" ,signflag = (CASE WHEN '").append(sLastFlag).append("'  = 'Y' THEN 'Y' ELSE 'N' END) ");
			sql.append(" ,updateuserid = '").append(sUserID).append("' ");  
			sql.append(" ,updatedate = SYSTIMESTAMP ");
			sql.append(" WHERE ");
			sql.append(" documentid = '").append(sDocumentID).append("' ");
			sql.append(" AND Seq = ").append(iSeq).append(" ");

			pstmt = conn.prepareStatement(sql.toString());

			pstmt.executeUpdate();

			pstmt.close();

			//--중간결재자인경우
			if(sLastFlag != null && sLastFlag.equals("N")){
				iNextSeq = iSeq + 1;

				sql.setLength(0);
				sql.append(" UPDATE tbapprovaldocline SET");
				sql.append(" signflag = 'Y' ");
				sql.append(" ,updateuserid = '").append(sUserID).append("' ");  
				sql.append(" ,updatedate = SYSTIMESTAMP ");
				sql.append(" WHERE ");
				sql.append(" documentid = '").append(sDocumentID).append("' ");
				sql.append(" AND Seq = ").append(iNextSeq).append(" ");

				pstmt = conn.prepareStatement(sql.toString());

				pstmt.executeUpdate();

				pstmt.close();

				/* 다음 결재자에게 Alarm 전송 */
				sql.setLength(0);
				sql.append(" SELECT SP_NBOX_Note_ApprovalSign(? , 'A', ?, ?, ?) FROM db_root ");

				pstmt = conn.prepareStatement(sql.toString());
				
				pstmt.setString(1, sCompanyID);
				pstmt.setString(2, sDocumentID);
				pstmt.setInt(3, iSeq);
				pstmt.setString(4, sUserID);

				rs = pstmt.executeQuery();

				while(rs.next()){
					sRtnErrorDesc = rs.getString(1);
				}

				rs.close();
				pstmt.close();

				//오류리턴시
				if(sRtnErrorDesc != null && !sRtnErrorDesc.equals("")){
					throw new Exception(sRtnErrorDesc);
				}
				
				/* 다음 결재자가 부재자일 경우, 결재 승인 */
				sql.setLength(0);
				sql.append(" SELECT SP_NBOX_ApprovalExecute_LEAVE_SIGN(? , ?, ?, ?, ?) FROM db_root ");

				pstmt = conn.prepareStatement(sql.toString());
				pstmt.setString(1, sCompanyID);
				pstmt.setString(2, sDocumentID);
				pstmt.setInt(3, iSeq);
				pstmt.setString(4, sUserID);
				pstmt.setString(5, sLangCode);

				rs = pstmt.executeQuery();

				while(rs.next()){
					sRtnErrorDesc = rs.getString(1);
				}
				rs.close();
				pstmt.close();

				//오류 리턴시
				if(sRtnErrorDesc != null && !sRtnErrorDesc.equals("")){
					throw new Exception(sRtnErrorDesc);
				}
			}

			//--마지막 결재자인경우
			if(sLastFlag != null && sLastFlag.equals("Y"))
			{
				sql.setLength(0);
				sql.append(" UPDATE tbapprovaldoc SET");
				sql.append(" [status] = 'C' ");
				sql.append(" ,lastsignadate = SYSTIMESTAMP ");  
				sql.append(" ,documentno = nfnGetApprovalDocumentNo('").append(sCompanyID).append("', documentid, categoryid, '").append(sLangCode).append("') ");
				sql.append(" ,updateuserid = '").append(sUserID).append("' ");  
				sql.append(" ,updatedate = SYSTIMESTAMP ");
				sql.append(" WHERE ");
				sql.append(" documentid = '").append(sDocumentID).append("' ");

				pstmt = conn.prepareStatement(sql.toString());

				pstmt.executeUpdate();

				pstmt.close();
				
				sql.setLength(0);
				sql.append(" SELECT SP_NBOX_ApprovalLink('A', ?, ?, ?) FROM db_root ");

				pstmt = conn.prepareStatement(sql.toString());
				pstmt.setString(1, sCompanyID);
				pstmt.setString(2, sDocumentID);
				pstmt.setString(3, sUserID);

				rs = pstmt.executeQuery();

				while(rs.next()){
					sRtn = rs.getInt(1);
				}
				rs.close();
				pstmt.close();

				//오류 리턴시
				if (sRtn != 0){
					sRtnErrorDesc = "SQL Server error encountered in sp_ApproveLink";
					throw new Exception(sRtnErrorDesc);
				}

				sql.setLength(0);
				sql.append(" SELECT SP_NBOX_Note_ApprovalClose(? , 'A', ?, ?, ?) FROM db_root ");

				pstmt = conn.prepareStatement(sql.toString());
				
				pstmt.setString(1, sCompanyID);
				pstmt.setString(2, sDocumentID);
				pstmt.setInt(3, iSeq);
				pstmt.setString(4, sUserID);

				rs = pstmt.executeQuery();

				while(rs.next()){
					sRtnErrorDesc = rs.getString(1);
				}
				
				rs.close();
				pstmt.close();

				if(sRtnErrorDesc != null && !sRtnErrorDesc.equals("")){
					throw new Exception(sRtnErrorDesc);
				}
			}

			//--본인에게 온 결재 Alarm(쪽지 수신함)을 읽음처리함
			sql.setLength(0);
			sql.append(" UPDATE tbnotercv SET");
			sql.append(" rcvdate = SYSTIMESTAMP ");  
			sql.append(" WHERE ");
			sql.append(" referenceid = '").append(sDocumentID).append("' ");
			sql.append(" AND rcvuserid = '").append(sUserID).append("' ");
			sql.append(" AND rcvdate IS NULL ");

			pstmt = conn.prepareStatement(sql.toString());

			pstmt.executeUpdate();

			pstmt.close();

			sRtnErrorDesc = "";
			//			return sErrorDesc;		//-- (반환) 에러명세

			//		} catch (Exception e) {
			//			conn.setAutoCommit(true);
			//			throw e;
			//
			//		}

			
			return sRtnErrorDesc;
			
		} catch (Exception e) {
			throw new Exception(e.getMessage());   
		} finally {
			if (rs != null) rs.close();
			if (pstmt != null) pstmt.close();
			if (conn != null) conn.close();
		}
	}


	/** SP명 : SP_NBOX_ApprovalExecute_CONFIRMCANCEL
	 * @param sCompanyID, sDocumentID, sUserID, sLangCode
	 * @return
	 * @throws Exception
	 */
	public static String SP_NBOX_ApprovalExecute_CONFIRMCANCEL(String sCompanyID, String sDocumentID, String sUserID, String sLangCode) throws Exception {	
		String sRtnErrorDesc = ""; //OUTPUT	-- (반환) 에러명세

		Connection conn = null;
		PreparedStatement  pstmt = null;
		ResultSet rs = null;

		StringBuffer sql = new StringBuffer();
		
		try {
			int iSeq = 0;
			String sLastFlag = "";
			String sSignImgUrl = "";
			int iNextSeq = 0;
			int iPrevseq = 0;
			int sRtn = 0;
			
			

			Class.forName("cubrid.jdbc.driver.CUBRIDDriver");
			conn = DriverManager.getConnection("jdbc:default:connection");
			//			conn = DriverManager.getConnection("jdbc:CUBRID:192.168.1.220:33000:OmegaPlus:::?charset=UTF-8","unilite","UNILITE");

			sql.append(" SELECT ");
			sql.append(" seq ");
			sql.append(" ,NVL(lastflag, 'N') ");
			sql.append(" FROM ");
			sql.append(" tbapprovaldocline ");
			sql.append(" WHERE ");
			sql.append(" documentid = '").append(sDocumentID).append("' ");
			sql.append(" AND signuserid = '").append(sUserID).append("' ");

			pstmt = conn.prepareStatement(sql.toString());

			rs = pstmt.executeQuery();

			while(rs.next()){
				iSeq = rs.getInt(1);
				sLastFlag = rs.getString(2);
			}

			rs.close();
			pstmt.close();

			sSignImgUrl = "X0005";

			iNextSeq = iSeq + 1;
			iPrevseq = iSeq - 1;

			sql.setLength(0);
			sql.append(" UPDATE tbapprovaldocline SET");
			sql.append(" signflag = 'N' ");
			sql.append(" ,updateuserid = '").append(sUserID).append("' ");
			sql.append(" ,updatedate = SYSTIMESTAMP ");
			sql.append(" WHERE ");
			sql.append(" documentid = '").append(sDocumentID).append("' ");
			sql.append(" AND seq = ").append(iNextSeq).append(" ");

			pstmt = conn.prepareStatement(sql.toString());

			pstmt.executeUpdate();

			pstmt.close();

			sql.setLength(0);
			sql.append(" UPDATE tbapprovaldocline SET");
			sql.append(" [status] = 'A' ");
			sql.append(" ,signdate = NULL ");
			sql.append(" ,signimgurl = '").append(sSignImgUrl).append("' ");
			sql.append(" ,signflag = 'Y'");
			sql.append(" ,updateuserid = '").append(sUserID).append("' ");
			sql.append(" ,updatedate = SYSTIMESTAMP ");
			sql.append(" WHERE ");
			sql.append(" documentid = '").append(sDocumentID).append("' ");
			sql.append(" AND seq = ").append(iSeq).append(" ");

			pstmt = conn.prepareStatement(sql.toString());

			pstmt.executeUpdate();

			pstmt.close();

			if(sLastFlag != null && sLastFlag.equals("Y")){

				sql.setLength(0);
				sql.append(" UPDATE tbapprovaldoc SET");
				sql.append(" [status] = 'B' ");
				sql.append(" ,lastsignadate = NULL ");
				sql.append(" ,documentno = nfngetcommoncodevalue('").append(sCompanyID).append("', 'NXA0', 'X0001') ");
				sql.append(" ,updateuserid = '").append(sUserID).append("' ");
				sql.append(" ,updatedate = SYSTIMESTAMP ");
				sql.append(" WHERE ");
				sql.append(" documentid = '").append(sDocumentID).append("' ");

				pstmt = conn.prepareStatement(sql.toString());

				pstmt.executeUpdate();

				pstmt.close();
			}

			sql.setLength(0);
			sql.append(" SELECT SP_NBOX_ApprovalLink('B', ?, ?, ?) FROM db_root ");

			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(1, sCompanyID);
			pstmt.setString(2, sDocumentID);
			pstmt.setString(3, sUserID);

			rs = pstmt.executeQuery();

			while(rs.next()){
				sRtn = rs.getInt(1);
			}
			
			rs.close();
			pstmt.close();

			if(sRtn !=0){
				sRtnErrorDesc = "SQL Server error encountered in sp_ApproveLink";
				throw new Exception(sRtnErrorDesc); 
			}

			/* 부재자 결재 승인 취소 */
			sql.setLength(0);
			sql.append(" SELECT SP_NBOX_ApprovalExecute_LEAVE_SIGNCANCEL(? , ?, ?, ?, ?) FROM db_root ");

			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(1, sCompanyID);
			pstmt.setString(2, sDocumentID);
			pstmt.setInt(3, iSeq);
			pstmt.setString(4, sUserID);
			pstmt.setString(5, sLangCode);

			rs = pstmt.executeQuery();

			while(rs.next()){
				sRtnErrorDesc = rs.getString(1);
			}
			rs.close();
			pstmt.close();

			if(sRtnErrorDesc != null && !sRtnErrorDesc.equals("")){
				throw new Exception(sRtnErrorDesc);
			}

			sRtnErrorDesc = "";
			//			return sErrorDesc;
			//
			//		} catch (Exception e) {
			//			conn.setAutoCommit(true);
			//			throw e;   
			//		}
			
			return sRtnErrorDesc;
			
		} catch (Exception e) {
			throw new Exception(e.getMessage());   
		} finally {
			if (rs != null) rs.close();
			if (pstmt != null) pstmt.close();
			if (conn != null) conn.close();
		}
	}


	/** SP명 : SP_NBOX_ApprovalExecute_DRAFT
	 * @param sCompanyID, sDocumentID, sUserID, sLangCode
	 * @return
	 * @throws Exception
	 */
	public static String SP_NBOX_ApprovalExecute_DRAFT(String sCompanyID, String sDocumentID, String sUserID, String sLangCode) throws Exception {	
		String  sRtnErrorDesc = "";	//OUTPUT	-- (반환) 에러명세
		
		Connection conn = null;
		PreparedStatement  pstmt = null;
		PreparedStatement  pstmt1 = null;
		ResultSet rs = null;
		ResultSet rs1 = null;

		StringBuffer sql = new StringBuffer();
		try {

			int iSeq = 0;
			String sSignImgUrl = "";
			String sWorkId = "";
			String sHolidayId = "";
			String sWorkCode = "";
			String sHolidayCode = "";
			int iNextSeq = 0;
			String sDataCode = "";
			String sDataValueName = "";
			String sDataId = "";

			Class.forName("cubrid.jdbc.driver.CUBRIDDriver");
			conn = DriverManager.getConnection("jdbc:default:connection");
			//			conn = DriverManager.getConnection("jdbc:CUBRID:192.168.1.220:33000:OmegaPlus:::?charset=UTF-8","unilite","UNILITE");
			conn.setAutoCommit(false);

			

			sql.append(" SELECT ");
			sql.append(" seq ");
			sql.append(" FROM ");
			sql.append(" tbapprovaldocline ");
			sql.append(" WHERE ");
			sql.append(" documentid = '").append(sDocumentID).append("' ");
			sql.append(" AND signuserid = '").append(sUserID).append("' ");

			pstmt = conn.prepareStatement(sql.toString());

			rs = pstmt.executeQuery();

			while(rs.next()){
				iSeq = rs.getInt(1);
			}

			rs.close();
			pstmt.close();

			sql.setLength(0);
			sql.append(" SELECT ");
			sql.append(" NVL(m.fid, 'X0007') ");
			sql.append(" FROM ");
			sql.append(" tbusersign m ");
			sql.append(" WHERE ");
			sql.append(" m.userid = '").append(sUserID).append("' ");
			sql.append(" AND m.insertdate = ");
			sql.append(" (SELECT ");
			sql.append(" MAX(n.insertdate) ");
			sql.append(" FROM ");
			sql.append(" tbusersign n ");
			sql.append(" WHERE ");
			sql.append(" m.userid = n.userid  ");
			sql.append(" AND m.companyid = n.companyid ");
			sql.append(" AND n.insertdate <= SYSTIMESTAMP) ");

			pstmt = conn.prepareStatement(sql.toString());

			rs = pstmt.executeQuery();

			while(rs.next()){
				sSignImgUrl = rs.getString(1);
			}

			rs.close();
			pstmt.close();

			sql.setLength(0);
			sql.append(" SELECT ");
			sql.append(" MAX(CASE WHEN code.datacode = '@WorkCode' THEN data1.datavalue ELSE '' END) ");
			sql.append(" ,MAX(CASE WHEN code.datacode = '@HolidayCode' THEN data1.datavalue ELSE '' END) ");
			sql.append(" FROM ");
			sql.append(" tblinkdatacodebyapproval data1 ");
			sql.append(" INNER JOIN tblinkdatacode code ON data1.dataid = code.dataid ");
			sql.append(" WHERE ");
			sql.append(" data1.documentid = '").append(sDocumentID).append("' ");

			pstmt = conn.prepareStatement(sql.toString());

			rs = pstmt.executeQuery();

			while(rs.next()){
				sWorkId = rs.getString(1);
				sHolidayId = rs.getString(2);
			}

			rs.close();
			pstmt.close();

			sql.setLength(0);
			sql.append(" SELECT ");
			sql.append(" workcode ");
			sql.append(" FROM ");
			sql.append(" tbworkcode ");
			sql.append(" WHERE ");
			sql.append(" workid = '").append(sWorkId).append("' ");

			pstmt = conn.prepareStatement(sql.toString());

			rs = pstmt.executeQuery();

			while(rs.next()){
				sWorkCode = rs.getString(1);
			}
			rs.close();
			pstmt.close();

			sql.setLength(0);
			sql.append(" SELECT ");
			sql.append(" holidaycode ");
			sql.append(" FROM ");
			sql.append(" tbworkholidaycode ");
			sql.append(" WHERE ");
			sql.append(" holidayid = '").append(sHolidayId).append("' ");

			pstmt = conn.prepareStatement(sql.toString());

			rs = pstmt.executeQuery();

			while(rs.next()){
				sHolidayCode = rs.getString(1);
			}

			rs.close();
			pstmt.close();


			/* 문서의 상태 변경 */
			sql.setLength(0);
			sql.append(" UPDATE tbapprovaldoc SET");
			sql.append(" [status] = 'B' ");
			sql.append(" ,draftdate = SYSTIMESTAMP ");
			sql.append(" ,contents	 = nfngetapprovalcontentsetc(companyid, documentid, contents) ");
			sql.append(" ,frm_contents = contents ");
			sql.append(" ,workcode = NVL('").append(sWorkCode).append("','') ");
			sql.append(" ,holidaycode = NVL('").append(sHolidayCode).append("','') ");
			sql.append(" ,updateuserid = '").append(sUserID).append("' ");
			sql.append(" ,updatedate = SYSTIMESTAMP ");
			sql.append(" WHERE ");
			sql.append(" documentid = '").append(sDocumentID).append("' ");

			pstmt = conn.prepareStatement(sql.toString());

			pstmt.executeUpdate();

			pstmt.close();

			/* 결재자의 직책을 변경함 : 2016-06-04,parka */
			sql.setLength(0);
			sql.append(" UPDATE ");
			sql.append(" tbapprovaldocline a ");
			sql.append(" INNER JOIN bsa300t b ON a.signuserid = b.user_id ");
			sql.append(" SET");
			sql.append(" a.signuserrolename = nfngetuserabilname(b.comp_code, b.user_id, '").append(sLangCode).append("') ");
			sql.append(" WHERE ");
			sql.append(" a.documentid = '").append(sDocumentID).append("' ");

			pstmt = conn.prepareStatement(sql.toString());

			pstmt.executeUpdate();

			pstmt.close();

			/* 상신자의 결재상태를 '결재'로 변경 */
			sql.setLength(0);
			sql.append(" UPDATE tbapprovaldocline SET");
			sql.append(" [status] = 'C' ");
			sql.append(" ,signdate = SYSTIMESTAMP ");
			sql.append(" ,signimgurl = '").append(sSignImgUrl).append("' ");
			sql.append(" ,signflag = 'N' ");
			sql.append(" ,updateuserid = '").append(sUserID).append("' ");
			sql.append(" ,updatedate = SYSTIMESTAMP ");
			sql.append(" WHERE ");
			sql.append(" documentid = '").append(sDocumentID).append("' ");
			sql.append(" AND seq = ").append(iSeq).append(" ");

			pstmt = conn.prepareStatement(sql.toString());

			pstmt.executeUpdate();

			pstmt.close();

			iNextSeq = iSeq + 1;

			/* 다음 결재자의 Sign 대상자 여부를 'Y'로 UPDATE */
			sql.setLength(0);
			sql.append(" UPDATE tbapprovaldocline SET");
			sql.append(" signflag = 'Y' ");
			sql.append(" ,updateuserid = '").append(sUserID).append("' ");
			sql.append(" ,updatedate = SYSTIMESTAMP ");
			sql.append(" WHERE ");
			sql.append(" documentid = '").append(sDocumentID).append("' ");
			sql.append(" AND seq = ").append(iNextSeq).append(" ");

			pstmt = conn.prepareStatement(sql.toString());

			pstmt.executeUpdate();

			pstmt.close();


			/* 다음 결재자에게 Alarm 전송 */
			sql.setLength(0);
			sql.append(" SELECT SP_NBOX_Note_ApprovalSign(? , 'A', ?, ?, ?) FROM db_root ");

			pstmt = conn.prepareStatement(sql.toString());
			pstmt.setString(1, sCompanyID);
			pstmt.setString(2, sDocumentID);
			pstmt.setInt(3, iSeq);
			pstmt.setString(4, sUserID);

			rs = pstmt.executeQuery();

			while(rs.next()){
				sRtnErrorDesc = rs.getString(1);
			}
			
			rs.close();
			pstmt.close();

			//오류 리턴시
			if(sRtnErrorDesc != null && !sRtnErrorDesc.equals("")){
				throw new Exception(sRtnErrorDesc);
			}

			/* 다음 결재자가 부재자일 경우, 결재 승인 */
			sql.setLength(0);
			sql.append(" SELECT SP_NBOX_ApprovalExecute_LEAVE_SIGN(? , ?, ?, ?, ?) FROM db_root ");

			pstmt = conn.prepareStatement(sql.toString());
			pstmt.setString(1, sCompanyID);
			pstmt.setString(2, sDocumentID);
			pstmt.setInt(3, iSeq);
			pstmt.setString(4, sUserID);
			pstmt.setString(5, sLangCode);

			rs = pstmt.executeQuery();

			while(rs.next()){
				sRtnErrorDesc = rs.getString(1);
			}
			
			rs.close();
			pstmt.close();

			//오류 리턴시
			if(sRtnErrorDesc != null && !sRtnErrorDesc.equals("")){
				throw new Exception(sRtnErrorDesc);
			}
			
			sql.setLength(0);
			sql.append(" SELECT ");
			sql.append(" code.datacode ");
			sql.append(" ,NVL(data1.datavaluename,'') ");
			sql.append(" ,data1.dataid ");
			sql.append(" FROM ");
			sql.append(" tblinkdatacodebyapproval data1 ");
			sql.append(" INNER JOIN tblinkdatacode code ON data1.dataid = code.dataid ");
			sql.append(" WHERE ");
			sql.append(" data1.documentid  = '").append(sDocumentID).append("' ");

			pstmt = conn.prepareStatement(sql.toString());

			rs = pstmt.executeQuery();

			while(rs.next()){
				sDataCode = rs.getString(1);
				sDataValueName = rs.getString(2);
				sDataId = rs.getString(3);

				sql.setLength(0);
				sql.append(" SELECT ");
				sql.append(" CASE '").append(sDataCode).append("' ");
				sql.append(" WHEN '@DraftDate' THEN TO_CHAR(NVL(a.draftdate, SYSTIMESTAMP),'yyyy-mm-dd') ");
				sql.append(" WHEN '@EmpName' THEN a.draftusername ");
				sql.append(" WHEN '@DeptName' THEN a.draftdeptname ");
				sql.append(" WHEN '@RoleName' THEN a.draftuserpos ");
				sql.append(" WHEN '@HpNo' THEN b.phone ");
				sql.append(" WELSE '").append(sDataValueName).append("' END ");
				sql.append(" FROM ");
				sql.append(" tbapprovaldoc a ");
				sql.append(" INNER JOIN bsa300t b ON a.companyid = b.comp_code AND a.draftuserid = b.user_id ");
				sql.append(" WHERE ");
				sql.append(" a.DocumentID = '").append(sDocumentID).append("' ");

				pstmt1 = conn.prepareStatement(sql.toString());

				rs1 = pstmt1.executeQuery();

				while(rs1.next()){
					sDataValueName = rs1.getString(1);
				}
				
				rs1.close();
				pstmt1.close();

				sql.setLength(0);
				sql.append(" UPDATE tblinkdatacodebyapproval SET");
				sql.append(" datavaluename = '").append(sDataValueName).append("' ");
				sql.append(" WHERE ");
				sql.append(" documentid = '").append(sDocumentID).append("' ");
				sql.append(" AND dataid = '").append(sDataId).append("' ");

				pstmt1 = conn.prepareStatement(sql.toString());

				pstmt1.executeUpdate();

				pstmt1.close();
			}

			rs.close();
			pstmt.close();

			sRtnErrorDesc = "";
			
			conn.commit();
			
			return sRtnErrorDesc;
			
		} catch (Exception e) {
			conn.rollback();
			throw new Exception(e.getMessage());   
		} finally {
			if (rs != null) rs.close();
			if (rs1 != null) rs1.close();
			if (pstmt != null) pstmt.close();
			if (pstmt1 != null) pstmt1.close();
			if (conn != null) conn.close();
		}

	}

	/** SP명 : SP_NBOX_ApprovalExecute_DRAFTCANCEL
	 * @param sCompanyID, sDocumentID, sUserID, sLangCode
	 * @return
	 * @throws Exception
	 */
	public static String  SP_NBOX_ApprovalExecute_DRAFTCANCEL(String sCompanyID, String sDocumentID, String sUserID, String sLangCode ) throws Exception {	
		String sRtnErrorDesc = ""; //OUTPUT	-- (반환) 에러명세

		Connection conn = null;
		PreparedStatement  pstmt = null;
		PreparedStatement  pstmt1 = null;
		ResultSet rs = null;
		ResultSet rs1 = null;

		try {

			int iSeq = 0;
			String sSignImgUrl = "";
			String sDataCode = "";
			String sDataValueName = "";
			String sDataId = "";
			
			StringBuffer sql = new StringBuffer();
			
			Class.forName("cubrid.jdbc.driver.CUBRIDDriver");
			conn = DriverManager.getConnection("jdbc:default:connection");
			//			conn = DriverManager.getConnection("jdbc:CUBRID:192.168.1.220:33000:OmegaPlus:::?charset=UTF-8","unilite","UNILITE");
			conn.setAutoCommit(false);
			
			sql.append(" SELECT ");
			sql.append(" seq ");
			sql.append(" FROM ");
			sql.append(" tbapprovaldocline ");
			sql.append(" WHERE ");
			sql.append(" documentid = '").append(sDocumentID).append("' ");
			sql.append(" AND signuserid = '").append(sUserID).append("' ");

			pstmt = conn.prepareStatement(sql.toString());

			rs = pstmt.executeQuery();

			while(rs.next()){
				iSeq = rs.getInt(1);
			}
			
			rs.close();
			pstmt.close();

			sSignImgUrl = "X0005";
			
			sql.setLength(0);
			sql.append(" UPDATE tbapprovaldoc SET");
			sql.append(" [status] = 'A' ");
			sql.append(" ,draftdate = SYSTIMESTAMP ");
			//sql.append(" ,contents = frm_contents ");
			sql.append(" ,updateuserid = '").append(sUserID).append("' ");
			sql.append(" ,updatedate = SYSTIMESTAMP ");
			sql.append(" WHERE ");
			sql.append(" documentid = '").append(sDocumentID).append("' ");

			pstmt = conn.prepareStatement(sql.toString());

			pstmt.executeUpdate();

			pstmt.close();

			sql.setLength(0);
			sql.append(" UPDATE tbapprovaldocline SET");
			sql.append(" [status] = 'A' ");
			sql.append(" ,signdate = NULL ");
			sql.append(" ,signimgurl = '").append(sSignImgUrl).append("' ");
			sql.append(" ,signflag = 'Y' ");
			sql.append(" ,updateuserid = '").append(sUserID).append("' ");
			sql.append(" ,updatedate = SYSTIMESTAMP ");
			sql.append(" WHERE ");
			sql.append(" documentid = '").append(sDocumentID).append("' ");
			sql.append(" AND seq = ").append(iSeq).append(" ");

			pstmt = conn.prepareStatement(sql.toString());

			pstmt.executeUpdate();

			pstmt.close();

			sql.setLength(0);
			sql.append(" UPDATE tbapprovaldocline SET");
			sql.append(" signflag = 'N' ");
			sql.append(" ,updateuserid = '").append(sUserID).append("' ");
			sql.append(" ,updatedate = SYSTIMESTAMP ");
			sql.append(" WHERE ");
			sql.append(" documentid = '").append(sDocumentID).append("' ");
			sql.append(" AND seq = ").append(iSeq + 1).append(" ");

			pstmt = conn.prepareStatement(sql.toString());

			pstmt.executeUpdate();

			pstmt.close();

			sql.setLength(0);
			sql.append(" SELECT ");
			sql.append(" code.datacode ");
			sql.append(" ,NVL(data1.datavaluename,'') ");
			sql.append(" ,data1.dataid ");
			sql.append(" FROM ");
			sql.append(" tblinkdatacodebyapproval data1 ");
			sql.append(" INNER JOIN tblinkdatacode code ON data1.dataid = code.dataid ");
			sql.append(" WHERE ");
			sql.append(" data1.documentid  = '").append(sDocumentID).append("' ");

			pstmt = conn.prepareStatement(sql.toString());

			rs = pstmt.executeQuery();

			while(rs.next()){
				sDataCode = rs.getString(1);
				sDataValueName = rs.getString(2);
				sDataId = rs.getString(3);

				sql.setLength(0);
				sql.append(" SELECT ");
				sql.append(" CASE '").append(sDataCode).append("' ");
				sql.append(" WHEN '@DraftDate' THEN TO_CHAR(NVL(a.draftdate, SYSTIMESTAMP),'yyyy-mm-dd') ");
				sql.append(" WHEN '@EmpName' THEN a.draftusername ");
				sql.append(" WHEN '@DeptName' THEN a.draftdeptname ");
				sql.append(" WHEN '@RoleName' THEN a.draftuserpos ");
				sql.append(" WHEN '@HpNo' THEN b.phone ");
				sql.append(" WELSE '").append(sDataValueName).append("' END ");
				sql.append(" FROM ");
				sql.append(" tbapprovaldoc a ");
				sql.append(" INNER JOIN bsa300t b ON a.companyid = b.comp_code AND a.draftuserid = b.user_id ");
				sql.append(" WHERE ");
				sql.append(" a.DocumentID = '").append(sDocumentID).append("' ");

				pstmt1 = conn.prepareStatement(sql.toString());

				rs1 = pstmt1.executeQuery();

				while(rs1.next()){
					sDataValueName = rs1.getString(1);
				}
				
				rs1.close();
				pstmt1.close();

				sql.setLength(0);
				sql.append(" UPDATE tblinkdatacodebyapproval SET");
				sql.append(" datavaluename = '").append(sDataValueName).append("' ");
				sql.append(" WHERE ");
				sql.append(" documentid = '").append(sDocumentID).append("' ");
				sql.append(" AND dataid = '").append(sDataId).append("' ");

				pstmt1 = conn.prepareStatement(sql.toString());

				pstmt1.executeUpdate();

				pstmt1.close();
			}

			rs.close();
			pstmt.close();

			sql.setLength(0);
			sql.append(" UPDATE tbnotercv SET");
			sql.append(" rcvdate = SYSTIMESTAMP ");
			sql.append(" WHERE ");
			sql.append(" referenceid = '").append(sDocumentID).append("' ");
			sql.append(" AND senduserid = '").append(sUserID).append("' ");
			sql.append(" AND rcvdate IS NULL ");

			pstmt = conn.prepareStatement(sql.toString());

			pstmt.executeUpdate();

			sRtnErrorDesc = "";
		
			conn.commit();
			
			return sRtnErrorDesc;		//-- (반환) 에러명세
			
		} catch (Exception e) {
			conn.rollback();
			throw new Exception(e.getMessage());   
		} finally {
			if (rs != null) rs.close();
			if (rs1 != null) rs1.close();
			if (pstmt != null) pstmt.close();
			if (pstmt1 != null) pstmt1.close();
			if (conn != null) conn.close();
		}
	}


	/**
	 * SP명 : SP_NBOX_ApprovalExecute_LEAVE_SIGN
	 * @param CompanyID, DocumentID, Seq, UserID, LangCode
	 * @return
	 * @throws SQLException
	 * @throws Exception
	 */
	public static String SP_NBOX_ApprovalExecute_LEAVE_SIGN(String CompanyID, String DocumentID, int Seq, String UserID, String LangCode) throws Exception{
		String sRtnErrorDesc = "";  /*output*/

		Connection  conn = null;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		ResultSet   rs = null;
		ResultSet   rs1 = null;
		
		StringBuffer  sql = new StringBuffer();
		
		try{
			int iRowCnt = 0;
			String sSignUserID = "";
			int iSignSeq = 0;
			String sLastFlag = "";
			int iNextSeq = 0;
			int iRtn = 0;
			
			

			Class.forName("cubrid.jdbc.driver.CUBRIDDriver");
			conn = DriverManager.getConnection("jdbc:default:connection");
			//			conn = DriverManager.getConnection("jdbc:CUBRID:192.168.1.220:33000:OmegaPlus:::?charset=UTF-8","unilite","UNILITE");

			conn.setAutoCommit(false);

			//Declare loop_cur cursor
			sql.setLength(0);
			sql.append("SELECT SIGNUSERID ");
			sql.append("       ,SEQ ");
			sql.append("       ,LASTFLAG ");
			sql.append("FROM   TBAPPROVALDOCLINE l ");
			sql.append("WHERE  l.DOCUMENTID =  ? ");
			sql.append("AND    l.Seq >=  ? ");

			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(1, DocumentID);
			pstmt.setInt(2, Seq);

			rs = pstmt.executeQuery();

			while(rs.next()){
				sSignUserID = rs.getString(1);
				iSignSeq = rs.getInt(2);
				sLastFlag = rs.getString(3);

				sql.setLength(0);
				sql.append("SELECT COUNT(*) ");
				sql.append("FROM   (SELECT c.* ");
				sql.append("        FROM   TBAPPROVALUSERCONFIG c ");
				sql.append("               INNER JOIN TBAPPROVALUSERLEAVECONFIG cl ");
				sql.append("                       ON c.COMPANYID = cl.COMPANYID ");
				sql.append("                          AND c.USERID = cl.USERID ");
				sql.append("        WHERE  c.COMPANYID =  ?  ");
				sql.append("               AND c.USERID =  ?  ");
				sql.append("               AND c.LEAVEFLAG = 1 ");
				sql.append("               AND Cast(TO_CHAR(SYSDATETIME, 'YYYY-MM-DD') AS DATETIME) BETWEEN ");
				sql.append("                   cl.FROMDATE AND cl.TODATE) TOPT ");
				sql.append("WHERE  ROWNUM = 1");

				pstmt1 = conn.prepareStatement(sql.toString());
				
				pstmt1.setString(1, CompanyID);
				pstmt1.setString(2, sSignUserID);

				rs1 = pstmt1.executeQuery();

				while(rs1.next()){
					iRowCnt = rs1.getInt(1);
				}
				
				rs1.close();
				pstmt1.close();

				if (iRowCnt > 0){
					///* 상신자의 결재상태를 '결재'로 변경 */
					sql.setLength(0);
					sql.append("UPDATE TBAPPROVALDOCLINE ");
					sql.append("SET    STATUS = 'C' ");
					sql.append("       ,SIGNDATE = SYSDATETIME ");
					sql.append("       ,SIGNIMGURL = 'X0008' ");
					sql.append("       ,SIGNFLAG = 'N' ");
					sql.append("       ,UPDATEUSERID =  ?  ");
					sql.append("       ,UPDATEDATE = SYSDATETIME ");
					sql.append("WHERE  DOCUMENTID =  ?  ");
					sql.append("       AND SEQ =  ?  ");

					pstmt1 = conn.prepareStatement(sql.toString());
					
					pstmt1.setString(1, UserID);
					pstmt1.setString(2, DocumentID);
					pstmt1.setInt(3, iSignSeq);

					pstmt1.executeUpdate();
					
					pstmt1.close();
				
					if(sLastFlag.equals("Y")){
						sql.setLength(0);
						sql.append("UPDATE TBAPPROVALDOC ");
						sql.append("SET    STATUS = 'C' ");
						sql.append("       ,LASTSIGNADATE = SYSDATETIME ");
						sql.append("       ,DOCUMENTNO = nfnGetApprovalDocumentNo( ? , DOCUMENTID, CATEGORYID,  ? ) ");
						sql.append("       ,UPDATEUSERID =  ?  ");
						sql.append("       ,UPDATEDATE = SYSDATETIME ");
						sql.append("WHERE  DOCUMENTID =  ?  ");

						pstmt1 = conn.prepareStatement(sql.toString());
						
						pstmt1.setString(1, CompanyID);
						pstmt1.setString(2, LangCode);
						pstmt1.setString(3, UserID);
						pstmt1.setString(4, DocumentID);

						pstmt1.executeUpdate();
						
						pstmt1.close();
						
						sql.setLength(0);
						sql.append("UPDATE TBAPPROVALDOCLINE ");
						sql.append("SET    SIGNFLAG = 'Y' ");
						sql.append("WHERE  DOCUMENTID =  ?  ");
						sql.append("       AND SEQ =  ? ");

						pstmt1 = conn.prepareStatement(sql.toString());
						
						pstmt1.setString(1, DocumentID);
						pstmt1.setInt(2, iSignSeq);

						pstmt1.executeUpdate();
						
						pstmt1.close();

						///* 결재 연동 데이터 생성 */
						//EXEC SP_NBOX_ApprovalLink 'A', @CompanyID, @DocumentID, @UserID, @Rtn output
						iRtn = 0;
						
						sql.setLength(0);
						sql.append("SELECT SP_NBOX_ApprovalLink('A', ?, ?, ?)  ");
						sql.append("FROM   DB_ROOT ");

						pstmt1 = conn.prepareStatement(sql.toString());
						
						pstmt1.setString(1, CompanyID);
						pstmt1.setString(2, DocumentID);
						pstmt1.setString(3, UserID);

						rs1 = pstmt1.executeQuery();

						while(rs1.next()){
							iRtn = rs1.getInt(1);

						}
						
						rs1.close();
						pstmt1.close();

						///* 상신자에게 결재종료 Alarm 전송 */
						sql.setLength(0);
						sql.append("SELECT SP_NBOX_Note_ApprovalClose(?, 'A', ?, ?, ?)  ");
						sql.append("FROM   DB_ROOT ");
						//EXEC SP_NBOX_Note_ApprovalClose @CompanyID, 'A', @DocumentID, @SignSeq, @UserID, @ErrorDesc output 
						pstmt1 = conn.prepareStatement(sql.toString());
						
						pstmt1.setString(1, CompanyID);
						pstmt1.setString(2, DocumentID);
						pstmt1.setInt(3, iSignSeq);
						pstmt1.setString(4, UserID);

						rs1 = pstmt1.executeQuery();

						while(rs1.next()){
							//							Rtn = rs.getInt(1);
							sRtnErrorDesc = rs1.getString(1);
						}
						
						rs1.close();
						pstmt1.close();

						if(sRtnErrorDesc != null && !sRtnErrorDesc.equals("")){
							throw new Exception(sRtnErrorDesc);
						}

					} else {
						iNextSeq = iSignSeq + 1;
						/* 다음 결재자의 Sign 대상자 여부를 'Y'로 UPDATE */
						sql.setLength(0);
						sql.append("UPDATE TBAPPROVALDOCLINE ");
						sql.append("SET    SIGNFLAG = 'Y' ");
						sql.append("       ,UPDATEUSERID =  ?  ");
						sql.append("       ,UPDATEDATE = SYSDATETIME ");
						sql.append("WHERE  DOCUMENTID =  ?  ");
						sql.append("       AND SEQ =  ?  ");

						pstmt1 = conn.prepareStatement(sql.toString());
						
						pstmt1.setString(1, UserID);
						pstmt1.setString(2, DocumentID);
						pstmt1.setInt(3, iNextSeq);

						pstmt1.executeUpdate();
						
						pstmt1.close();

						
						///* 다음 결재자에게 Alarm 전송 */
						sql.setLength(0);
						sql.append("SELECT SP_NBOX_Note_ApprovalSign(?, 'A', ?, ?, ?)  ");
						sql.append("FROM   DB_ROOT ");
						//EXEC SP_NBOX_Note_ApprovalSign @CompanyID, 'A', @DocumentID, @NextSeq, @UserID, @ErrorDesc output
						pstmt1 = conn.prepareStatement(sql.toString());
						
						pstmt1.setString(1, CompanyID);
						pstmt1.setString(2, DocumentID);
						pstmt1.setInt(3, iNextSeq);
						pstmt1.setString(4, UserID);

						rs1 = pstmt1.executeQuery();

						while(rs.next()){
							sRtnErrorDesc = rs.getString(1);
						}
						
						rs1.close();
						pstmt1.close();
						
						if(sRtnErrorDesc != null && !sRtnErrorDesc.equals("")){
							throw new Exception(sRtnErrorDesc);
						}
					}					
					
				} else {
					/* 다음 결재자가 부재상태가 아니라면. 부재 결재를 진행하지 않는다. */
					sRtnErrorDesc = "";
				}
			}
			rs.close();
			pstmt.close();
			
			conn.commit();

			return sRtnErrorDesc;
			
		} catch (Exception e) {
			conn.rollback();
			throw new Exception(e.getMessage());   
		} finally {
			if (rs != null) rs.close();
			if (rs1 != null) rs1.close();
			if (pstmt != null) pstmt.close();
			if (pstmt1 != null) pstmt1.close();
			if (conn != null) conn.close();
		}
	}

	/**
	 * SP명 : SP_NBOX_ApprovalExecute_LEAVE_SIGNCANCEL
	 * @param : CompanyID, DocumentID, Seq, UserID, LangCode
	 * @return
	 * @throws SQLException
	 * @throws Exception
	 */
	@SuppressWarnings("unused")
	public static String SP_NBOX_ApprovalExecute_LEAVE_SIGNCANCEL(String CompanyID, String DocumentID, int Seq, String UserID, String LangCode) throws Exception{
		String sRtnErrorDesc = "";  /*output*/

		Connection  conn = null;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		ResultSet   rs = null;
		ResultSet   rs1 = null;
		
		StringBuffer  sql = new StringBuffer();
		
		try{
			
			int rowCnt = 0;
			String SignUserID = "";
			int SignSeq = 0;
			String LastFlag = "";
			int NextSeq = 0;
			String SignImgUrl = "";
			
			
						
			Class.forName("cubrid.jdbc.driver.CUBRIDDriver");
			conn = DriverManager.getConnection("jdbc:default:connection");
			//			conn = DriverManager.getConnection("jdbc:CUBRID:192.168.1.220:33000:OmegaPlus:::?charset=UTF-8","unilite","UNILITE");
			conn.setAutoCommit(false);

			//Declare loop_cur cursor
			sql.setLength(0);
			sql.append("SELECT SIGNUSERID ");
			sql.append("       ,SEQ ");
			sql.append("       ,LASTFLAG ");
			sql.append("FROM   TBAPPROVALDOCLINE l ");
			sql.append("WHERE  l.DOCUMENTID =  ? ");
			sql.append("AND    l.Seq <=  ? ");
			sql.append("order by l.seq desc ");

			pstmt = conn.prepareStatement(sql.toString());
			pstmt.setString(1, DocumentID);
			pstmt.setInt(2, Seq);

			rs = pstmt.executeQuery();

			while(rs.next()){
				SignUserID = rs.getString(1);
				SignSeq = rs.getInt(2);
				LastFlag = rs.getString(3);

				sql.setLength(0);
				sql.append("SELECT COUNT(*) ");
				sql.append("FROM   (SELECT c.* ");
				sql.append("        FROM   TBAPPROVALUSERCONFIG c ");
				sql.append("               INNER JOIN TBAPPROVALUSERLEAVECONFIG cl ");
				sql.append("                       ON c.COMPANYID = cl.COMPANYID ");
				sql.append("                          AND c.USERID = cl.USERID ");
				sql.append("        WHERE  c.COMPANYID =  ?  ");
				sql.append("               AND c.USERID =  ?  ");
				sql.append("               AND c.LEAVEFLAG = 1 ");
				sql.append("               AND Cast(TO_CHAR(SYSDATETIME, 'YYYY-MM-DD') AS DATETIME) BETWEEN ");
				sql.append("                   cl.FROMDATE AND cl.TODATE) TOPT ");
				sql.append("WHERE  ROWNUM = 1");

				pstmt1 = conn.prepareStatement(sql.toString());
				
				pstmt1.setString(1, CompanyID);
				pstmt1.setString(2, SignUserID);

				rs1 = pstmt1.executeQuery();

				while(rs1.next()){
					rowCnt = rs1.getInt(1);
				}
				
				rs1.close();
				pstmt1.close();

				if (rowCnt > 0){

					NextSeq = SignSeq + 1;
					SignImgUrl = "X0005";

					sql.setLength(0);
					sql.append("UPDATE TBAPPROVALDOCLINE ");
					sql.append("SET    SIGNFLAG = 'N' ");
					sql.append("       ,UPDATEUSERID =  ?  ");
					sql.append("       ,UPDATEDATE = SYSDATETIME ");
					sql.append("WHERE  DOCUMENTID =  ?  ");
					sql.append("       AND SEQ =  ?  ");

					pstmt1 = conn.prepareStatement(sql.toString());
					
					pstmt1.setString(1, UserID);
					pstmt1.setString(2, DocumentID);
					pstmt1.setInt(3, NextSeq);

					pstmt1.executeUpdate();
					
					pstmt1.close();

					sql.setLength(0);
					sql.append("UPDATE TBAPPROVALDOCLINE ");
					sql.append("SET    STATUS = 'A' ");
					sql.append("       ,SIGNDATE = NULL ");
					sql.append("       ,SIGNIMGURL =  ?  ");
					sql.append("       ,SIGNFLAG = 'Y' ");
					sql.append("       ,UPDATEUSERID =  ?  ");
					sql.append("       ,UPDATEDATE = SYSDATETIME ");
					sql.append("WHERE  DOCUMENTID =  ?  ");
					sql.append("       AND SEQ =  ?  ");

					pstmt1 = conn.prepareStatement(sql.toString());
					
					pstmt1.setString(1, SignImgUrl);
					pstmt1.setString(2, UserID);
					pstmt1.setString(3, DocumentID);
					pstmt1.setInt(4, SignSeq);

					pstmt1.executeUpdate();
					
					pstmt1.close();

					/*IF @@ERROR <> 0 
					BEGIN
						GOTO EXITCUR ;
					END */

				}else {
					
				}
			}
			
			rs.close();
			pstmt.close();
			
			sRtnErrorDesc = "";
			
			conn.commit();
			
			return sRtnErrorDesc;
			
		} catch (Exception e) {
			conn.rollback();
			throw new Exception(e.getMessage());   
		} finally {
			if (rs != null) rs.close();
			if (rs1 != null) rs1.close();
			if (pstmt != null) pstmt.close();
			if (pstmt1 != null) pstmt1.close();
			if (conn != null) conn.close();
		}		
	}


	/**
	 * SP명 : SP_NBOX_ApprovalExecute_RETURN
	 * @param CompanyID, DocumentID, UserID, LangCode
	 * @return
	 * @throws SQLException
	 * @throws Exception
	 */
	@SuppressWarnings("unused")
	public static String SP_NBOX_ApprovalExecute_RETURN(String CompanyID, String DocumentID, String UserID, String LangCode) throws Exception {
		String sRtnErrorDesc = "";  /*output*/

		Connection  conn = null;
		PreparedStatement pstmt = null;
		ResultSet   rs = null;
		
		StringBuffer  sql = new StringBuffer();
		
		try{
			int Seq = 0 ;
			String LastFlag = "";
			String SignImgUrl = "";
			
			
			
			Class.forName("cubrid.jdbc.driver.CUBRIDDriver");
			conn = DriverManager.getConnection("jdbc:default:connection");
			//			conn = DriverManager.getConnection("jdbc:CUBRID:192.168.1.220:33000:OmegaPlus:::?charset=UTF-8","unilite","UNILITE");

			sql.setLength(0);
			sql.append("SELECT SEQ , ");
			sql.append("       NVL(LASTFLAG,'N') ");
			sql.append("FROM   TBAPPROVALDOCLINE ");
			sql.append("WHERE  DOCUMENTID =  ?  ");
			sql.append("AND    SIGNUSERID =  ?  ");

			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(1, DocumentID);
			pstmt.setString(2, UserID);

			rs = pstmt.executeQuery();
			
			while(rs.next()){
				Seq = rs.getInt(1);
				LastFlag = rs.getString(2);
			}
			
			rs.close();
			pstmt.close();

			SignImgUrl = "X0006";

			sql.setLength(0);
			sql.append("UPDATE TBAPPROVALDOCLINE ");
			sql.append("SET    [STATUS] = 'R' ");
			sql.append("       , SIGNDATE = SYSDATETIME ");
			sql.append("       , SIGNIMGURL =  ?  ");
			sql.append("       , UPDATEUSERID =  ?  ");
			sql.append("       , UPDATEDATE = SYSDATETIME ");
			sql.append("WHERE  DOCUMENTID =  ?  ");
			sql.append("   AND SEQ =  ?  ");

			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(1, SignImgUrl);
			pstmt.setString(2, UserID);
			pstmt.setString(3, DocumentID);
			pstmt.setInt(4, Seq);

			pstmt.executeUpdate();
			
			pstmt.close();

			sql.setLength(0);
			sql.append("UPDATE TBAPPROVALDOC ");
			sql.append("SET    [STATUS] = 'R' ");
			sql.append("       , LASTSIGNADATE = SYSDATETIME ");
			sql.append("       , DOCUMENTNO = nfnGetApprovalReturnDocumentNo( ? , DOCUMENTID, ");
			sql.append("                      CATEGORYID, ");
			sql.append("                         ?  ) ");
			sql.append("       , UPDATEUSERID =  ?   ");
			sql.append("       , UPDATEDATE = SYSDATETIME ");
			sql.append("WHERE  DOCUMENTID =  ?  ");

			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(1, CompanyID);
			pstmt.setString(2, LangCode);
			pstmt.setString(3, UserID);
			pstmt.setString(4, DocumentID);

			pstmt.executeUpdate();
			
			pstmt.close();

			/* 상신자에게 반려 Alarm 전송 */
			//EXEC SP_NBOX_Note_ApprovalReturn @CompanyID, 'A', @DocumentID, @Seq, @UserID, @ErrorDesc output  
			sql.setLength(0);
			sql.append("SELECT SP_NBOX_Note_ApprovalReturn(?, 'A', ?, ?, ?)  ");
			sql.append("FROM   DB_ROOT ");

			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(1, CompanyID);
			pstmt.setString(2, DocumentID);
			pstmt.setInt(3, Seq);
			pstmt.setString(4, UserID);

			rs = pstmt.executeQuery();

			while(rs.next()){
				sRtnErrorDesc = rs.getString(1);
			}
			
			rs.close();
			pstmt.close();
			
			if(sRtnErrorDesc != null && !sRtnErrorDesc.equals("")){
				throw new Exception(sRtnErrorDesc);
			}
			
			return sRtnErrorDesc;

		} catch (Exception e) {
			throw new Exception(e.getMessage());   
		} finally {
			if (rs != null) rs.close();
			if (pstmt != null) pstmt.close();
			if (conn != null) conn.close();
		}
	}


	/**
	 * SP명 : SP_NBOX_ApprovalExecute_RETURNCANCEL
	 * @param CompanyID, DocumentID, UserID, LangCode
	 * @return
	 * @throws SQLException
	 * @throws Exception
	 */
	@SuppressWarnings("unused")
	public static String SP_NBOX_ApprovalExecute_RETURNCANCEL(String CompanyID, String DocumentID, String UserID, String LangCode) throws Exception {
		String sRtnErrorDesc = "";  /*output*/

		Connection  conn = null;
		PreparedStatement pstmt = null;
		ResultSet   rs = null;

		try{
			int Seq = 0 ;
			String LastFlag = "";
			String SignImgUrl = "";
			
			StringBuffer  sql = new StringBuffer();
			
			Class.forName("cubrid.jdbc.driver.CUBRIDDriver");
			conn = DriverManager.getConnection("jdbc:default:connection");
			//			conn = DriverManager.getConnection("jdbc:CUBRID:192.168.1.220:33000:OmegaPlus:::?charset=UTF-8","unilite","UNILITE");

			sql.setLength(0);
			sql.append("SELECT SEQ , ");
			sql.append("       NVL(LASTFLAG,'N') ");
			sql.append("FROM   TBAPPROVALDOCLINE ");
			sql.append("WHERE  DOCUMENTID =  ?  ");
			sql.append("AND    SIGNUSERID =  ?  ");

			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(1, DocumentID);
			pstmt.setString(2, UserID);

			rs = pstmt.executeQuery();

			while(rs.next()){
				Seq = rs.getInt(1);
				LastFlag = rs.getString(2);
			}
			
			rs.close();
			pstmt.close();

			SignImgUrl = "X0005";

			sql.setLength(0);
			sql.append("UPDATE TBAPPROVALDOCLINE ");
			sql.append("SET    [STATUS] = 'A' ");
			sql.append("       , SIGNDATE = null ");
			sql.append("       , SIGNIMGURL =  ?  ");
			sql.append("       , UPDATEUSERID =  ?  ");
			sql.append("       , UPDATEDATE = SYSDATETIME ");
			sql.append("WHERE  DOCUMENTID =  ?  ");
			sql.append("   AND SEQ =  ?  ");

			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(1, SignImgUrl);
			pstmt.setString(2, UserID);
			pstmt.setString(3, DocumentID);
			pstmt.setInt(4, Seq);

			pstmt.executeUpdate();
			
			pstmt.close();

			sql.setLength(0);
			sql.append("UPDATE TBAPPROVALDOC ");
			sql.append("SET    [STATUS] = 'B' ");
			sql.append("       , LASTSIGNADATE = null ");
			sql.append("       , DOCUMENTNO = nfnGetCommonCodeValue( ? , 'NXA0', 'X0001') ");
			sql.append("       , UPDATEUSERID =  ?   ");
			sql.append("       , UPDATEDATE = SYSDATETIME ");
			sql.append("WHERE  DOCUMENTID =  ?  ");

			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(1, CompanyID);
			pstmt.setString(2, UserID);
			pstmt.setString(3, DocumentID);

			pstmt.executeUpdate();
			
			pstmt.close();

			sRtnErrorDesc = "";
			
			return sRtnErrorDesc;
			
		} catch (Exception e) {
			throw new Exception(e.getMessage());   
		} finally {
			if (rs != null) rs.close();
			if (pstmt != null) pstmt.close();
			if (conn != null) conn.close();
		}
	}


	/**
	 * SP명 : SP_NBOX_LinkComboList
	 * @param comp_code, main_code, sub_code 
	 * @return 
	 * @throws SQLException
	 * @throws Exception
	 */
	public static String SP_NBOX_LinkComboList(String comp_code, String main_code, String sub_code) throws Exception {
		String sRtnUUID = ""; //임시테이블 UniqueKey

		Connection  conn = null;
		PreparedStatement pstmt = null;
		ResultSet   rs = null;
		
		try{
			String table = ""; 
			String code = ""; 
			String name = ""; 
			String sort = ""; 
			String uRef = ""; 
			String sqlCommand = ""; 

			int uIdx = 0; 
			String getmonth = ""; 
			String uMonthCd = ""; 
			String uMonthNm = ""; 
			
			StringBuffer  sql = new StringBuffer();
			
			Class.forName("cubrid.jdbc.driver.CUBRIDDriver");
			conn = DriverManager.getConnection("jdbc:default:connection");
			//			conn = DriverManager.getConnection("jdbc:CUBRID:192.168.1.220:33000:OmegaPlus:::?charset=UTF-8","unilite","UNILITE");

			sql.setLength(0);
			sql.append("SELECT REF_CODE1 ");
			sql.append("       ,REF_CODE2 ");
			sql.append("       ,REF_CODE3 ");
			sql.append("       ,REF_CODE4 ");
			sql.append("       ,REF_CODE5 ");
			sql.append("FROM   BSA100T ");
			sql.append("WHERE  COMP_CODE =  ?  ");
			sql.append("       AND MAIN_CODE =  ?  ");
			sql.append("       AND SUB_CODE =  ? ");

			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(1, comp_code);
			pstmt.setString(2, main_code);
			pstmt.setString(3, sub_code);

			rs = pstmt.executeQuery();

			while(rs.next()){
				table = rs.getString(1);
				code = rs.getString(2);
				name = rs.getString(3);
				sort = rs.getString(4);
				uRef = rs.getString(5);
			}
			
			rs.close();
			pstmt.close();

			//임의삭제
			if(table == null ||table.equals("")) {
				//				throw new SQLException("table 없음");
				table = "DB_ROOT";
			} 	
			//			if(code == null ||code.equals("")) {
			////				throw new SQLException("code 없음");
			//				code = "test_code_value";
			//			}
			//			if(name == null ||name.equals("")) {
			////				throw new SQLException("name 없음");
			//				name = "test_name_value";
			//			}
			//			if(sort == null ||sort.equals("")) {
			////				throw new SQLException("sort 없음");
			//				sort = "test_sort_value";
			//			}



			//임시테이블 UniqueKey 생성
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

			if(uRef.equals("U")){
				//@getmonth
				sql.setLength(0);
				sql.append("SELECT TO_CHAR(SYSDATETIME, 'YYYY-MM-') + '01'");

				pstmt = conn.prepareStatement(sql.toString());

				rs = pstmt.executeQuery();
				
				while(rs.next()){
					getmonth = rs.getString(1);
				}
				
				rs.close();
				pstmt.close();

				//@sqlCommand
				sqlCommand = " SELECT '" + sRtnUUID + "' AS KEY_VALUE, '' AS CODE, '' AS NAME ";

				for(uIdx = -3; uIdx<3; uIdx++){
					//@uMonthCd
					sql.setLength(0);
					sql.append("SELECT TO_CHAR(ADD_MONTHS( ? ,  ? ), 'YYYY-MM') ");
					sql.append("FROM   DB_ROOT");

					pstmt = conn.prepareStatement(sql.toString());
					
					pstmt.setString(1, getmonth);
					pstmt.setInt(2, uIdx);

					rs = pstmt.executeQuery();
					
					while(rs.next()){
						uMonthCd = rs.getString(1);
					}
					
					rs.close();
					pstmt.close();

					//@@uMonthNm
					sql.setLength(0);
					sql.append("SELECT REPLACE(TO_CHAR(ADD_MONTHS( ? ,  ? ), 'YYYY-MM'),'-','년')+'월' ");
					sql.append("FROM   DB_ROOT");

					pstmt = conn.prepareStatement(sql.toString());
					
					pstmt.setString(1, getmonth);
					pstmt.setInt(2, uIdx);

					rs = pstmt.executeQuery();
					
					while(rs.next()){
						uMonthNm = rs.getString(1);
					}
					
					rs.close();
					pstmt.close();

					sqlCommand = sqlCommand  + " UNION ALL SELECT '" + sRtnUUID + "', '" + uMonthCd + "', '" + uMonthNm + "'";
				}

			} else {
				sqlCommand = "SELECT '" + sRtnUUID + "' as KEY_VALUE, '" + code + "' as CODE, '" + name + "' as NAME " + " from " + table ; //+ " order by " + sort;
			}

			//Exec(@sqlCommand);
			sql.setLength(0);
			sql.append("INSERT INTO T_LINKCOMBOLIST ");
			sql.append("SELECT * FROM ( ");
			sql.append(sqlCommand);
			sql.append(" ) ");
			//			sql.append("WHERE (code != '' or NAME != '') ");

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


	/** SP명 : SP_NBOX_Note_ApprovalClose
	 * @param sCompanyID, sRcvType, sReferenceID, iSeq, sUserID
	 * @return
	 * @throws Exception
	 */
	public static String SP_NBOX_Note_ApprovalClose(String sCompanyID, String sRcvType, String sReferenceID, int iSeq, String sUserID ) throws Exception {	

		String sRtnErrorDesc = "";  //OUTPUT	-- (반환) 에러명세

		Connection conn = null;
		PreparedStatement  pstmt = null;
		ResultSet rs = null;

		try {

			String sDraftUserID = "";
			String sDraftUserName = "";
			String sDraftDate = "";
			String sAlarmType = "";
			String sCloseAlarmFlag = "";
			String sSignUserID = "";
			String sSignUserName = "";
			String sDocumentNo = "";
			String sSubject = "";
			String sMaxID = "";
			String sRcvNoteID = "";
			String sContents = "";

			StringBuffer sql = new StringBuffer();
			
			Class.forName("cubrid.jdbc.driver.CUBRIDDriver");
			conn = DriverManager.getConnection("jdbc:default:connection");
			//			conn = DriverManager.getConnection("jdbc:CUBRID:192.168.1.220:33000:OmegaPlus:::?charset=UTF-8","unilite","UNILITE");

			sql.append(" SELECT ");
			sql.append(" draftuserid ");
			sql.append(" ,draftusername ");
			sql.append(" ,TO_CHAR(draftdate,'yyyy-mm-dd') ");
			sql.append(" FROM ");
			sql.append(" tbapprovaldoc ");
			sql.append(" WHERE ");
			sql.append(" documentid = '").append(sReferenceID).append("' ");

			pstmt = conn.prepareStatement(sql.toString());

			rs = pstmt.executeQuery();

			while(rs.next()){
				sDraftUserID = rs.getString(1);
				sDraftUserName = rs.getString(2);
				sDraftDate = rs.getString(3);
			}

			rs.close();
			pstmt.close();

			sAlarmType = "Z";
			sCloseAlarmFlag = "N";

			sql.setLength(0);
			sql.append(" SELECT ");
			sql.append(" alarmtype ");
			sql.append(" ,CASE WHEN closealarmflag = 1 THEN 'Y' ELSE 'N' END ");
			sql.append(" FROM ");
			sql.append(" tbapprovaluserconfig ");
			sql.append(" WHERE ");
			sql.append(" companyid = '").append(sCompanyID).append("' ");
			sql.append(" AND userid = '").append(sDraftUserID).append("' ");

			pstmt = conn.prepareStatement(sql.toString());

			rs = pstmt.executeQuery();

			while(rs.next()){
				sAlarmType = rs.getString(1);
				sCloseAlarmFlag = rs.getString(2);
			}

			rs.close();
			pstmt.close();

			if (sCloseAlarmFlag != null && sCloseAlarmFlag.equals("N")){

				sql.setLength(0);
				sql.append(" SELECT ");
				sql.append(" NVL(closealarmflag,'N') ");
				sql.append(" FROM ");
				sql.append(" tbapprovaldoc ");
				sql.append(" WHERE ");
				sql.append(" documentid = '").append(sReferenceID).append("' ");

				pstmt = conn.prepareStatement(sql.toString());

				rs = pstmt.executeQuery();

				while(rs.next()){
					sCloseAlarmFlag = rs.getString(1);
				}

				rs.close();
				pstmt.close();
			}

			if ((sAlarmType != null && sAlarmType.equals("A")) &&
					(sCloseAlarmFlag != null && sCloseAlarmFlag.equals("Y"))){

				sql.setLength(0);
				sql.append(" SELECT ");
				sql.append(" signuserid ");
				sql.append(" ,signusername ");
				sql.append(" FROM ");
				sql.append(" tbapprovaldocline ");
				sql.append(" WHERE ");
				sql.append(" documentid = '").append(sReferenceID).append("' ");
				sql.append(" AND seq = ").append(iSeq).append(" ");

				pstmt = conn.prepareStatement(sql.toString());

				rs = pstmt.executeQuery();

				while(rs.next()){
					sSignUserID = rs.getString(1);
					sSignUserName = rs.getString(2);
				}

				rs.close();
				pstmt.close();

				sql.setLength(0);
				sql.append(" SELECT ");
				sql.append(" documentno ");
				sql.append(" ,subject ");
				sql.append(" FROM ");
				sql.append(" tbapprovaldoc ");
				sql.append(" WHERE ");
				sql.append(" documentid = '").append(sReferenceID).append("' ");

				pstmt = conn.prepareStatement(sql.toString());

				rs = pstmt.executeQuery();

				while(rs.next()){
					sDocumentNo = rs.getString(1);
					sSubject = rs.getString(2);
				}

				rs.close();
				pstmt.close();

				sql.setLength(0);
				sql.append(" SELECT ");
				sql.append(" MAX(tbnotercv.rcvnoteid)  ");
				sql.append(" FROM ");
				sql.append(" tbnotercv ");
				sql.append(" WHERE ");
				sql.append(" SUBSTRING(tbnotercv.rcvnoteid , 1, 1) = nfngetcommoncodevalue('").append(sCompanyID).append("', 'NZ01', 'X0009') ");

				pstmt = conn.prepareStatement(sql.toString());

				rs = pstmt.executeQuery();

				while(rs.next()){
					sMaxID = rs.getString(1);
				}

				rs.close();
				pstmt.close();

				sql.setLength(0);
				sql.append(" SELECT ");
				sql.append(" nfngetmaxid(nfngetcommoncodevalue('").append(sCompanyID).append("', 'NZ01', 'X0009'), '").append(sMaxID).append("')  ");
				sql.append(" FROM ");
				sql.append(" db_root ");

				pstmt = conn.prepareStatement(sql.toString());

				rs = pstmt.executeQuery();

				while(rs.next()){
					sRcvNoteID = rs.getString(1);
				}

				rs.close();
				pstmt.close();

				sContents = "&#149;승인 되었습니다.\r\n\r\n&#149;제목 : " + sSubject + "\r\n&#149;상신일 : " + sDraftDate;

				sql.setLength(0);
				sql.append(" INSERT INTO tbnotercv");
				sql.append(" ( ");
				sql.append(" rcvnoteid ");
				sql.append(" ,rcvuserid ");
				sql.append(" ,rcvusername ");
				sql.append(" ,rcvdate ");
				sql.append(" ,rcvtype ");
				sql.append(" ,referenceid ");
				sql.append(" ,contents ");
				sql.append(" ,senduserid ");
				sql.append(" ,sendusername ");
				sql.append(" ,senddate ");
				sql.append(" ,deleteflag ");
				sql.append(" ,insertuserid ");
				sql.append(" ,insertdate ");
				sql.append(" ,updateuserid ");
				sql.append(" ,updatedate ");
				sql.append(" ) ");
				sql.append(" VALUES ");
				sql.append(" ( ");
				sql.append(" '").append(sRcvNoteID).append("' ");
				sql.append(" ,'").append(sDraftUserID).append("' ");
				sql.append(" ,'").append(sDraftUserName).append("' ");
				sql.append(" ,NULL ");
				sql.append(" ,'").append(sRcvType).append("' ");
				sql.append(" ,'").append(sReferenceID).append("' ");
				sql.append(" ,'").append(sContents).append("' ");
				sql.append(" ,'").append(sSignUserID).append("' ");
				sql.append(" ,'").append(sSignUserName).append("' ");
				sql.append(" ,SYSTIMESTAMP ");
				sql.append(" ,'N' ");
				sql.append(" ,'").append(sUserID).append("' ");
				sql.append(" ,SYSTIMESTAMP ");
				sql.append(" ,'").append(sUserID).append("' ");
				sql.append(" ,SYSTIMESTAMP ");
				sql.append(" ) ");

				pstmt = conn.prepareStatement(sql.toString());

				pstmt.executeUpdate();

				pstmt.close();
			}

			sRtnErrorDesc = "";
			
			return sRtnErrorDesc;		//-- (반환) 에러명세

		} catch (Exception e) {
			throw new Exception(e.getMessage());   
		} finally {
			if (rs != null) rs.close();
			if (pstmt != null) pstmt.close();
			if (conn != null) conn.close();
		}
	}


	/**
	 * SP명 : SP_NBOX_Note_ApprovalReturn
	 * @param CompanyID, RcvType, ReferenceID, Seq, UserID
	 * @return 
	 * @throws SQLException
	 * @throws Exception
	 */
	public static String SP_NBOX_Note_ApprovalReturn(String CompanyID, String RcvType, String ReferenceID, int Seq, String UserID) throws Exception {
		String sRtnErrorDesc = "";  /*output -- (반환) 에러명세 */

		Connection  conn = null;
		PreparedStatement pstmt = null;
		ResultSet   rs = null;

		try{
			String DraftUserID = "";
			String DraftUserName = "";
			String DraftDate = "";
			String AlarmType = "";
			String CloseAlarmFlag = "";

			StringBuffer  sql = new StringBuffer();
			
			Class.forName("cubrid.jdbc.driver.CUBRIDDriver");
			conn = DriverManager.getConnection("jdbc:default:connection");
			//			conn = DriverManager.getConnection("jdbc:CUBRID:192.168.1.220:33000:OmegaPlus:::?charset=UTF-8","unilite","UNILITE");
			
			sql.setLength(0);
			sql.append("SELECT DRAFTUSERID ");
			sql.append("       , DRAFTUSERNAME ");
			sql.append("       , TO_CHAR(CAST(DRAFTDATE AS DATETIME), 'YYYY-MM-DD') ");
			sql.append("FROM   TBAPPROVALDOC ");
			sql.append("WHERE  DOCUMENTID =  ?  ");

			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(1, ReferenceID);

			rs = pstmt.executeQuery();

			while(rs.next()){
				DraftUserID = rs.getString(1);
				DraftUserName = rs.getString(2);
				DraftDate = rs.getString(3);
			}
			
			rs.close();
			pstmt.close();

			AlarmType = "Z";
			CloseAlarmFlag = "N";

			sql.setLength(0);
			sql.append("SELECT ALARMTYPE ");
			sql.append("       , CASE ");
			sql.append("           WHEN CLOSEALARMFLAG = 1 THEN 'Y' ");
			sql.append("           ELSE 'N' ");
			sql.append("         END ");
			sql.append("FROM   TBAPPROVALUSERCONFIG ");
			sql.append("WHERE  COMPANYID =  ?  ");
			sql.append("   AND USERID =  ?  ");

			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(1, CompanyID);
			pstmt.setString(2, DraftUserID);

			rs = pstmt.executeQuery();

			while(rs.next()){
				AlarmType = rs.getString(1);
				CloseAlarmFlag = rs.getString(2);
			}
			
			rs.close();
			pstmt.close();

			if (CloseAlarmFlag.equals("N")){
				sql.setLength(0);
				sql.append("SELECT NVL(CLOSEALARMFLAG, 'N') ");
				sql.append("FROM   TBAPPROVALDOC ");
				sql.append("WHERE  DOCUMENTID =  ?  ");

				pstmt = conn.prepareStatement(sql.toString());
				
				pstmt.setString(1, ReferenceID);

				rs = pstmt.executeQuery();

				while(rs.next()){
					CloseAlarmFlag = rs.getString(1);
				}
				
				rs.close();
				pstmt.close();
			}

			if (AlarmType.equals("A") && CloseAlarmFlag.equals("Y")){
				String MaxID = "";
				String RcvNoteID = "";
				String SignUserID = "";
				String SignUserName = "";
				String Subject = "";
				String DocumentNo = "";
				String Contents = "";

				//@SignUserID, @SignUserName
				sql.setLength(0);
				sql.append("SELECT SIGNUSERID ");
				sql.append("       , SIGNUSERNAME ");
				sql.append("FROM   TBAPPROVALDOCLINE ");
				sql.append("WHERE  DOCUMENTID =  ?  ");
				sql.append("   AND SEQ =  ? ");

				pstmt = conn.prepareStatement(sql.toString());
				
				pstmt.setString(1, ReferenceID);
				pstmt.setInt(2, Seq);

				rs = pstmt.executeQuery();

				while(rs.next()){
					SignUserID = rs.getString(1);
					SignUserName = rs.getString(2);
				}
				
				rs.close();
				pstmt.close();

				//@DocumentNo, @Subject
				sql.setLength(0);
				sql.append("SELECT DOCUMENTNO ");
				sql.append("       , SUBJECT ");
				sql.append("FROM   TBAPPROVALDOC ");
				sql.append("WHERE  DOCUMENTID =  ? ");

				pstmt = conn.prepareStatement(sql.toString());
				
				pstmt.setString(1, ReferenceID);

				rs = pstmt.executeQuery();

				while(rs.next()){
					DocumentNo = rs.getString(1);
					Subject = rs.getString(2);
				}
				
				rs.close();
				pstmt.close();

				//@MaxID 
				sql.setLength(0);
				sql.append("SELECT Max(TBNOTERCV.RCVNOTEID) ");
				sql.append("FROM   TBNOTERCV ");
				sql.append("WHERE  Substring(TBNOTERCV.RCVNOTEID, 1, 1) = ");
				sql.append("       nfnGetCommonCodeValue( ? , 'NZ01', 'X0009')");

				pstmt = conn.prepareStatement(sql.toString());
				
				pstmt.setString(1, CompanyID);

				rs = pstmt.executeQuery();

				while(rs.next()){
					MaxID = rs.getString(1);
				}
				
				rs.close();
				pstmt.close();

				if(MaxID == null || MaxID.equals("")){
					MaxID = "";
				}

				//@RcvNoteID 
				sql.setLength(0);
				sql.append("SELECT nfnGetMaxID(nfnGetCommonCodeValue( ? , 'NZ01', 'X0009'),  ? ) ");
				sql.append("FROM   DB_ROOT");

				pstmt = conn.prepareStatement(sql.toString());
				
				pstmt.setString(1, CompanyID);
				pstmt.setString(2, MaxID);

				rs = pstmt.executeQuery();

				while(rs.next()){
					RcvNoteID = rs.getString(1);
				}
				
				rs.close();
				pstmt.close();

				Contents = "&#149;반려 되었습니다.\r\n\r\n&#149;제목 : " + Subject + "\r\n&#149;상신일 : " + DraftDate;

				sql.setLength(0);
				sql.append("INSERT INTO TBNOTERCV ");
				sql.append("            (RCVNOTEID ");
				sql.append("             , RCVUSERID ");
				sql.append("             , RCVUSERNAME ");
				sql.append("             , RCVDATE ");
				sql.append("             , RCVTYPE ");
				sql.append("             , REFERENCEID ");
				sql.append("             , CONTENTS ");
				sql.append("             , SENDUSERID ");
				sql.append("             , SENDUSERNAME ");
				sql.append("             , SENDDATE ");
				sql.append("             , DELETEFLAG ");
				sql.append("             , INSERTUSERID ");
				sql.append("             , INSERTDATE ");
				sql.append("             , UPDATEUSERID ");
				sql.append("             , UPDATEDATE) ");
				sql.append("VALUES      ( ?  ");
				sql.append("              ,  ?  ");
				sql.append("              , ?  ");
				sql.append("              , NULL ");
				sql.append("              , ?  ");
				sql.append("              , ?  ");
				sql.append("              , ?  ");
				sql.append("              , ?  ");
				sql.append("              , ?  ");
				sql.append("              , SYSDATETIME ");
				sql.append("              , 'N' ");
				sql.append("              , ?  ");
				sql.append("              , SYSDATETIME ");
				sql.append("              , ?  ");
				sql.append("              , SYSDATETIME )");

				pstmt = conn.prepareStatement(sql.toString());
				
				pstmt.setString(1, RcvNoteID);
				pstmt.setString(2, DraftUserID);
				pstmt.setString(3, DraftUserName);
				pstmt.setString(4, RcvType);
				pstmt.setString(5, ReferenceID);
				pstmt.setString(6, Contents);
				pstmt.setString(7, SignUserID);
				pstmt.setString(8, SignUserName);
				pstmt.setString(9, UserID);
				pstmt.setString(10, UserID);

				pstmt.executeUpdate();
				
				pstmt.close();
			}
			
			sRtnErrorDesc = "";
			
			return sRtnErrorDesc;

		} catch (Exception e) {
			throw new Exception(e.getMessage());   
		} finally {
			if (rs != null) rs.close();
			if (pstmt != null) pstmt.close();
			if (conn != null) conn.close();
		}
	}



	/**
	 * SP명 : SP_NBOX_Note_ApprovalSign
	 * @param CompanyID, RcvType, ReferenceID, Seq, UserID
	 * @return 
	 * @throws SQLException
	 * @throws Exception
	 */
	public static String SP_NBOX_Note_ApprovalSign(String CompanyID, String RcvType, String ReferenceID, int Seq, String UserID) throws Exception {
		String sRtnErrorDesc = "";  /*output -- (반환) 에러명세 */

		Connection  conn = null;
		PreparedStatement pstmt = null;
		ResultSet   rs = null;
		
		try{
			String SignUserID = "";
			String SignUserName = "";
			String AlarmType = "";
			String SignAlarmFlag = "";
			
			StringBuffer  sql = new StringBuffer();
			
			Class.forName("cubrid.jdbc.driver.CUBRIDDriver");
			conn = DriverManager.getConnection("jdbc:default:connection");
			//			conn = DriverManager.getConnection("jdbc:CUBRID:192.168.1.220:33000:OmegaPlus:::?charset=UTF-8","unilite","UNILITE");
			conn.setAutoCommit(false);

			
			sql.setLength(0);
			sql.append("SELECT SIGNUSERID ");
			sql.append("       ,SIGNUSERNAME ");
			sql.append("FROM   TBAPPROVALDOCLINE ");
			sql.append("WHERE  DOCUMENTID =  ?  ");
			sql.append("       AND SEQ =  (?  + 1)");

			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(1, ReferenceID);
			pstmt.setInt(2, Seq);

			rs = pstmt.executeQuery();
			
			while(rs.next()){
				SignUserID = rs.getString(1);
				SignUserName = rs.getString(2);
			}
			
			rs.close();
			pstmt.close();

			AlarmType = "Z";
			SignAlarmFlag = "";
			
			sql.setLength(0);
			sql.append("SELECT ALARMTYPE ");
			sql.append("       ,CASE ");
			sql.append("          WHEN SIGNALARMFLAG = 1 THEN 'Y' ");
			sql.append("          ELSE 'N' ");
			sql.append("        END ");
			sql.append("FROM   TBAPPROVALUSERCONFIG ");
			sql.append("WHERE  COMPANYID =  ?  ");
			sql.append("       AND USERID =  ?  ");

			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(1, CompanyID);
			pstmt.setString(2, SignUserID);

			rs = pstmt.executeQuery();
			
			while(rs.next()){
				AlarmType = rs.getString(1);
				SignAlarmFlag = rs.getString(2);
			}
			
			rs.close();
			pstmt.close();

			///* 쪽지알람 */
			if (AlarmType.equals("A") && SignAlarmFlag.equals("Y")){
				String MaxID = "";
				String RcvNoteID = "";
				String DraftUserID = "";
				String DraftUserName = "";
				String DraftDate = "";
				String Subject = "";
				String Contents = "";

				sql.setLength(0);
				sql.append("SELECT DRAFTUSERID ");
				sql.append("       ,DRAFTUSERNAME ");
				sql.append("       ,TO_CHAR(SYSDATETIME, 'YYYY-MM-DD') ");
				sql.append("       ,SUBJECT ");
				sql.append("FROM   TBAPPROVALDOC ");
				sql.append("WHERE  DOCUMENTID =  ?  ");

				pstmt = conn.prepareStatement(sql.toString());
				
				pstmt.setString(1, ReferenceID);

				rs = pstmt.executeQuery();

				while(rs.next()){
					DraftUserID = rs.getString(1);
					DraftUserName = rs.getString(2);
					DraftDate = rs.getString(3);
					Subject = rs.getString(4);
				}
				
				rs.close();
				pstmt.close();

				//@MaxID
				sql.setLength(0);
				sql.append("SELECT Max(TBNOTERCV.RCVNOTEID) ");
				sql.append("FROM   TBNOTERCV ");
				sql.append("WHERE  Substring(TBNOTERCV.RCVNOTEID, 1, 1) = nfnGetCommonCodeValue( ? , 'NZ01', 'X0009')");

				pstmt = conn.prepareStatement(sql.toString());
				
				pstmt.setString(1, CompanyID);

				rs = pstmt.executeQuery();

				while(rs.next()){
					MaxID = rs.getString(1);
				}
				
				rs.close();
				pstmt.close();

				//@RcvNoteID 
				sql.setLength(0);
				sql.append("SELECT nfnGetMaxID(nfnGetCommonCodeValue( ? , 'NZ01', 'X0009'),  ? )");

				pstmt = conn.prepareStatement(sql.toString());
				
				pstmt.setString(1, CompanyID);
				pstmt.setString(2, MaxID);

				rs = pstmt.executeQuery();

				while(rs.next()){
					RcvNoteID = rs.getString(1);
				}
				
				rs.close();
				pstmt.close();

				Contents ="[결재요청] 기안자[" + DraftUserName + "]로 부터 결재 요청이 되었습니다."
						+ "\r\n\r\n&#149;제목 : " + Subject + "\r\n&#149;상신일 : " + DraftDate ;

				sql.setLength(0);
				sql.append("INSERT INTO TBNOTERCV ");
				sql.append("            (RCVNOTEID ");
				sql.append("             ,RCVUSERID ");
				sql.append("             ,RCVUSERNAME ");
				sql.append("             ,RCVDATE ");
				sql.append("             ,RCVTYPE ");
				sql.append("             ,REFERENCEID ");
				sql.append("             ,CONTENTS ");
				sql.append("             ,SENDUSERID ");
				sql.append("             ,SENDUSERNAME ");
				sql.append("             ,SENDDATE ");
				sql.append("             ,DELETEFLAG ");
				sql.append("             ,INSERTUSERID ");
				sql.append("             ,INSERTDATE ");
				sql.append("             ,UPDATEUSERID ");
				sql.append("             ,UPDATEDATE) ");
				sql.append("VALUES      (  ?  ");
				sql.append("              , ?  ");
				sql.append("              ,nfnGetUserName( ?   ? ) ");
				sql.append("              ,NULL ");
				sql.append("              , ?  ");
				sql.append("              , ?  ");
				sql.append("              , ?  ");
				sql.append("              , ?  ");
				sql.append("              ,nfnGetUserName( ? ,  ? ) ");
				sql.append("              ,SYSDATETIME ");
				sql.append("              ,'N' ");
				sql.append("              , ?  ");
				sql.append("              ,SYSDATETIME ");
				sql.append("              , ?  ");
				sql.append("              ,SYSDATETIME )");

				pstmt = conn.prepareStatement(sql.toString());
				
				pstmt.setString(1, RcvNoteID);
				pstmt.setString(2, SignUserID);
				pstmt.setString(3, CompanyID);
				pstmt.setString(4, SignUserID);
				pstmt.setString(5, RcvType);
				pstmt.setString(6, ReferenceID);
				pstmt.setString(7, Contents);
				pstmt.setString(8, DraftUserID);
				pstmt.setString(9, CompanyID);
				pstmt.setString(10, DraftUserID);
				pstmt.setString(11, UserID);
				pstmt.setString(12, UserID);

				pstmt.executeUpdate();
				
				pstmt.close();
			}

			sRtnErrorDesc = "";
			
			return sRtnErrorDesc;
			
		} catch (Exception e) {

			throw new Exception(e.getMessage());   
		} finally {
			if (rs != null) rs.close();
			if (pstmt != null) pstmt.close();
			if (conn != null) conn.close();
		}
		
	}





}