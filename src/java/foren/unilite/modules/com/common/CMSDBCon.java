package foren.unilite.modules.com.common;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.List;

import foren.unilite.com.code.CodeDetailVO;

public class CMSDBCon {

	public static Connection DBConn(List<CodeDetailVO> dbInfoList){
		
		String driver = "org.mariadb.jdbc.Driver"; 
		Connection conn = null;
		
		// 도메인 (IP:포트/데이터베이스명)
		String url = "jdbc:mariadb://" + dbInfoList.get(0).getRefCode1() + ":" + dbInfoList.get(0).getRefCode2() + "/" + dbInfoList.get(0).getRefCode3() + "?useSSL=true";
		// User
		String user = dbInfoList.get(0).getRefCode4(); 
		// Password
		String password = dbInfoList.get(0).getRefCode5();

		try {
			Class.forName(driver);
			conn = DriverManager.getConnection(url, user, password);
			if (conn != null) {
				System.out.println(">>>>>>>>DB CONNECT SUCCESS!!!");
			}
		} catch (SQLException | ClassNotFoundException ex) {
			System.out.println(">>>>>>>>>>>> DB CONNECT FAIL!!");
			ex.printStackTrace();
		}
		
		return conn;
	}
}
