<%@page language="java" contentType="text/html; charset=utf-8"%>
<%@page import="foren.framework.utils.*" %>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.SQLException"%>
<%
Connection dbConnection = null;
PreparedStatement stmt = null;
ResultSet rs = null;
String sql = "";

  try { 
	  Class.forName("oracle.jdbc.driver.OracleDriver");
  
  } catch (ClassNotFoundException e) { 
	  System.out.print(e.getMessage()); 
  }
 
try {
	
   dbConnection =  DriverManager.getConnection("jdbc:oracle:thin:@210.98.159.153:1523:OPENDBT", "widememory","widememorydev!#$1");
   sql = "SELECT MAX(RCPT_YMD) AS RCPT_YMD , TO_CHAR(SYSDATE, 'MM-DD-YYYY HH24:MI:SS')  as RCPT_YMD2 FROM V_RCPT_WIDEMEMORY010";
	// dbConnection =  DriverManager.getConnection("jdbc:oracle:thin:@203.248.116.111:1521:CGISDEV", "widememory","widememorydev$#!1");
	// sql = "SELECT MAX(RCPT_YMD) AS RCPT_YMD , TO_CHAR(SYSDATE, 'MM-DD-YYYY HH24:MI:SS')  as RCPT_YMD2 FROM V_RCPT_WIDEMEMORY010";
	
	stmt = dbConnection.prepareStatement(sql);
    rs = stmt.executeQuery();
    while(rs.next())	{

    	out.print(rs.getString("RCPT_YMD"));
    	out.print(rs.getString("RCPT_YMD2"));
    	
    }
} catch (SQLException e) {
	System.out.print(e.toString());
	rs = null;
} catch (Throwable e2)	{
	System.out.print(e2.toString());
	rs = null;
} finally {
	if(dbConnection != null) try {dbConnection.close();}catch(SQLException e){};
	if(stmt != null) try {stmt.close();}catch(SQLException e){};
	//if(rs != null) try {rs.close();}catch(SQLException e){};
}
%>