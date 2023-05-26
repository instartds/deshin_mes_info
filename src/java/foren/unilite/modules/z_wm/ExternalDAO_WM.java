package foren.unilite.modules.z_wm;

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

import javax.annotation.Resource;
import javax.naming.Context;
import javax.naming.InitialContext;

import javax.sql.DataSource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import foren.framework.dao.TlabAbstractDAO;
import foren.framework.utils.ConfigUtil;

@Service("externalDAO_WM")
public class ExternalDAO_WM  {
	/** The logger. */
	private Logger logger = LoggerFactory.getLogger(this.getClass());
	private String jndiName = "jdbc/CJ_ORACLE";
	
	@Resource(name = "tlabAbstractDAO")
	protected TlabAbstractDAO dao;
	
	private Connection oracleConnection() throws Exception { 

		Connection dbConnection = null;
		Context ctx = new InitialContext();
		DataSource ds = (DataSource)ctx.lookup("java:comp/env/"+jndiName);
		dbConnection = ds.getConnection();
		return dbConnection;
		
       // return rs;
	}
	
	public List<Map<String, Object>> list(String queryId, Map param)	{
		Connection dbConnection = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = "";
		List<Map<String,Object>> rList = new ArrayList();
		try {
			  
			dbConnection =  this.oracleConnection();
			
			sql = dao.mappedSqlString(queryId, param);
			
			pstmt = dbConnection.prepareStatement(sql);
			
	        rs = pstmt.executeQuery();
	        
	        ResultSetMetaData md = rs.getMetaData();
	        int columns = md.getColumnCount();
	        while (rs.next()){
	            Map<String, Object> row = new HashMap<String, Object>(columns);
	            for(int i = 1; i <= columns; ++i){
	                row.put(md.getColumnName(i), rs.getObject(i));
	            }
	            rList.add(row);
	        }
		} catch (SQLException e) {
			logger.debug("   >>>>>>>  queryId : " + queryId);
			logger.debug("   >>>>>>>  SQL : " + sql);
			logger.error(e.toString());
			rs = null;
		} catch (Throwable e2)	{
			e2.printStackTrace();
			logger.debug("   >>>>>>>  queryId : " + queryId);
			logger.error(e2.toString());
			rs = null;
		} finally {
			if(dbConnection != null) try {dbConnection.close();}catch(SQLException e){};
			if(pstmt != null) try {pstmt.close();}catch(SQLException e){};
			//if(rs != null) try {rs.close();}catch(SQLException e){};
		}
		
		return rList;
	}
	
	public Map<String, Object> select(String queryId, Map param)	{
		Connection dbConnection = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = "";
		Map<String, Object> rMap  = null;
		try {
			  
			dbConnection =  this.oracleConnection();
			
			sql = dao.mappedSqlString(queryId, param);
			
			pstmt = dbConnection.prepareStatement(sql);
			
	        rs = pstmt.executeQuery();
	        
	        ResultSetMetaData md = rs.getMetaData();
	        int columns = md.getColumnCount();
	        rMap = new HashMap<String, Object>(columns);
            for(int i = 1; i <= columns; ++i){
            	rMap.put(md.getColumnName(i), rs.getObject(i));
            }
		} catch (SQLException e) {
			logger.error(e.toString());
			rs = null;
		} catch (Throwable e2)	{
			logger.debug("   >>>>>>>  queryId : " + queryId);
			logger.error(e2.toString());
			rs = null;
		} finally {
			if(dbConnection != null) try {dbConnection.close();}catch(SQLException e){};
			if(pstmt != null) try {pstmt.close();}catch(SQLException e){};
			if(rs != null) try {rs.close();}catch(SQLException e){};
			logger.debug("   >>>>>>>  queryId : " + queryId);
			logger.debug("   >>>>>>>  SQL : " + sql);
		}
		
		return rMap;
	}
	
	public int update(String queryId, List<Map<String, Object>> paramList)	{
		Connection dbConnection = null;
		PreparedStatement pstmt = null;
		String sql = "";
		int r = 0 ;
		boolean autoCommit = true;
		try {
			dbConnection =  this.oracleConnection();
			autoCommit = dbConnection.getAutoCommit();
			dbConnection.setAutoCommit(false);
			for(Map param : paramList) {
				sql = dao.mappedSqlString(queryId, param);
				pstmt = dbConnection.prepareStatement(sql);
		        r += pstmt.executeUpdate();
			}
			dbConnection.commit();
		} catch (SQLException e) {
			if(dbConnection != null) {
				try {
					dbConnection.rollback();
				}catch(SQLException e_conn){
					logger.error(e_conn.toString());
				};
			}
			logger.error(e.toString());
			
		} catch (Throwable e2)	{
			logger.debug("   >>>>>>>  queryId : " + queryId);
			logger.error(e2.toString());
			
		} finally {
			if(dbConnection != null) 
				try {
					dbConnection.setAutoCommit(autoCommit);
					dbConnection.close();
				}catch(SQLException e){
					
				};
			if(pstmt != null) try {pstmt.close();}catch(SQLException e){};
			logger.debug("   >>>>>>>  queryId : " + queryId);
			logger.debug("   >>>>>>>  SQL : " + sql);
		}
		
		return r;
	}

	/**
	 * 20210309 추가
	 * @param queryId
	 * @param paramList
	 * @return
	 */
	public String update2(String queryId, List<Map<String, Object>> paramList)	{
		Connection dbConnection = null;
		PreparedStatement pstmt = null;
		String sql = "";
		String r = "0" ;
		boolean autoCommit = true;
		try {
			dbConnection =  this.oracleConnection();
			autoCommit = dbConnection.getAutoCommit();
			dbConnection.setAutoCommit(false);
			for(Map param : paramList) {
				sql = dao.mappedSqlString(queryId, param);
				pstmt = dbConnection.prepareStatement(sql);
//		        r += pstmt.executeUpdate();
			}
			dbConnection.commit();
		} catch (SQLException e) {
			if(dbConnection != null) {
				try {
					dbConnection.rollback();
				}catch(SQLException e_conn){
					logger.error(e_conn.toString());
				};
			}
			logger.error(e.toString());
			r = e.toString();
			
		} catch (Throwable e2)	{
			logger.debug("   >>>>>>>  queryId : " + queryId);
			logger.error(e2.toString());
			r = e2.toString();
			
		} finally {
			if(dbConnection != null) 
				try {
					dbConnection.setAutoCommit(autoCommit);
					dbConnection.close();
				}catch(SQLException e){
					
				};
			if(pstmt != null) try {pstmt.close();}catch(SQLException e){};
			logger.debug("   >>>>>>>  queryId : " + queryId);
			logger.debug("   >>>>>>>  SQL : " + sql);
		}
		return r;
	}
}