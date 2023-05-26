package foren.unilite.modules.z_mit;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.naming.Context;
import javax.naming.InitialContext;

import javax.sql.DataSource;

import org.apache.ibatis.mapping.BoundSql;
import org.apache.ibatis.mapping.ParameterMapping;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import foren.framework.dao.TlabAbstractDAO;
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.ObjUtils;

@Service("externalDAO_MIT")
public class ExternalDAO_MIT  {
	/** The logger. */
	private Logger logger = LoggerFactory.getLogger(this.getClass());
	private String jndiName = "jdbc/MIT_EXT";
	
	@Resource(name = "tlabAbstractDAO")
	protected TlabAbstractDAO dao;
	
	private Connection extConnection() throws Exception { 

		Connection dbConnection = null;
		Context ctx = new InitialContext();
		DataSource ds = (DataSource)ctx.lookup("java:comp/env/"+jndiName);
		dbConnection = ds.getConnection();
		return dbConnection;
		
	}
	
	public List<Map<String, Object>> list(String queryId, Map param, StringBuilder errorMessage)	{
		Connection dbConnection = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = "";
		List<Map<String,Object>> rList = new ArrayList();
		try {
			  
			dbConnection =  this.extConnection();
			
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
			logger.error(e.getMessage());
			errorMessage.append(e.getMessage());
			rs = null;
			e.printStackTrace();
		} catch (Throwable e2)	{
			e2.printStackTrace();
			logger.debug("   >>>>>>>  queryId : " + queryId);
			logger.error(e2.getMessage());
			errorMessage.append(e2.getMessage());
			rs = null;
			e2.printStackTrace();
		} finally {
			if(dbConnection != null) try {dbConnection.close();}catch(SQLException e){};
			if(pstmt != null) try {pstmt.close();}catch(SQLException e){};
			//if(rs != null) try {rs.close();}catch(SQLException e){};
		}
		
		return rList;
	}
	
	public Map<String, Object> select(String queryId, Map param, StringBuilder errorMessage)	{
		Connection dbConnection = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = "";
		Map<String, Object> rMap  = null;
		try {
			  
			dbConnection =  this.extConnection();
			
			sql = dao.mappedSqlString(queryId, param);
			
			pstmt = dbConnection.prepareStatement(sql);
			
	        rs = pstmt.executeQuery();
	        
	        ResultSetMetaData md = rs.getMetaData();
	        int columns = md.getColumnCount();
	        rMap = new HashMap<String, Object>(columns);
	        if(rs.next())	{
	            for(int i = 1; i <= columns; ++i){
	            	rMap.put(md.getColumnName(i), rs.getObject(i));
	            }
            }
		} catch (SQLException e) {
			logger.error(e.getMessage());
			errorMessage.append(e.getMessage());
			rs = null;
			e.printStackTrace();
		} catch (Throwable e2)	{
			logger.debug("   >>>>>>>  queryId : " + queryId);
			logger.error(e2.getMessage());
			errorMessage.append(e2.getMessage());
			rs = null;
			e2.printStackTrace();
		} finally {
			if(dbConnection != null) try {dbConnection.close();}catch(SQLException e){};
			if(pstmt != null) try {pstmt.close();}catch(SQLException e){};
			if(rs != null) try {rs.close();}catch(SQLException e){};
			logger.debug("   >>>>>>>  queryId : " + queryId);
			logger.debug("   >>>>>>>  SQL : " + sql);
		}
		
		return rMap;
	}
	
	public int update(String queryId, List<Map<String, Object>> paramList, StringBuilder errorMessage)	{
		Connection dbConnection = null;
		PreparedStatement pstmt = null;
		String sql = "";
		int r = 0 ;
		boolean autoCommit = true;
		try {
			dbConnection =  this.extConnection();
			autoCommit = dbConnection.getAutoCommit();
			dbConnection.setAutoCommit(false);
			for(Map param : paramList) {
				sql = dao.mappedSqlString(queryId, param);
				pstmt = dbConnection.prepareStatement(sql);
		        r += pstmt.executeUpdate();
			}
			dbConnection.commit();
		} catch (SQLException e) {

			errorMessage.append(e.getMessage());
			if(dbConnection != null) {
				try {
					dbConnection.rollback();
				}catch(SQLException e_conn){
					logger.error(e_conn.toString());
					errorMessage.append(e_conn.toString());
				};
			}
			logger.error(e.getMessage());
			e.printStackTrace();
		} catch (Throwable e2)	{
			logger.debug("   >>>>>>>  queryId : " + queryId);
			logger.error(e2.getMessage());
			errorMessage.append(e2.getMessage());
			e2.printStackTrace();
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
	
	public int update(String queryId, Map<String, Object> param, StringBuilder errorMessage)	{
		Connection dbConnection = null;
		PreparedStatement pstmt = null;
		String sql = "";
		int r = 0 ;
		boolean autoCommit = true;
		try {
			dbConnection =  this.extConnection();
			autoCommit = dbConnection.getAutoCommit();
			dbConnection.setAutoCommit(false);
			
			sql = dao.mappedSqlString(queryId, param);
			pstmt = dbConnection.prepareStatement(sql);
	        r = pstmt.executeUpdate();
			
			dbConnection.commit();
		} catch (SQLException e) {
			errorMessage.append( e.getMessage() );
			if(dbConnection != null) {
				try {
					dbConnection.rollback();
				}catch(SQLException e_conn){
					logger.error(e_conn.toString());
					errorMessage.append(e_conn.toString());
				};
			}
			logger.error(e.getMessage());
			e.printStackTrace();
		} catch (Throwable e2)	{
			logger.debug("   >>>>>>>  queryId : " + queryId);
			logger.error(e2.getMessage());
			errorMessage.append( e2.getMessage());
			e2.printStackTrace();
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
	
	public Map<String, Object> procExec(String queryId, Map<String, Object> param, StringBuilder errorMessage) {
		Connection dbConnection	= null;
		CallableStatement cs	= null;
		String sql				= "";
		Map<String, Object> rMap= new HashMap<String, Object>();
		try {
			dbConnection						=  this.extConnection();
			BoundSql boundSql					= dao.getSqlSession().getConfiguration().getMappedStatement(queryId).getBoundSql(param);
			List<ParameterMapping> mappedParams	= boundSql.getParameterMappings();
			sql									= boundSql.getSql();
			cs									= dbConnection.prepareCall(sql);
			int numberOfParameters				= 1;
			logger.debug("############  sql :"+sql);

			for(ParameterMapping mapping : mappedParams){
				logger.debug("MODE : "+mapping.getMode());
				if("IN".equals(mapping.getMode().toString())) {
					if("VARCHAR".equals(ObjUtils.getSafeString(mapping.getJdbcType()))){
						cs.setString(numberOfParameters, ObjUtils.getSafeString(param.get(mapping.getProperty())));
					} else if ("NUMERIC".equals(ObjUtils.getSafeString(mapping.getJdbcType()))){ 
						cs.setDouble(numberOfParameters,  ObjUtils.parseDouble(param.get(mapping.getProperty()))); 
					} else if ("INTEGER".equals(ObjUtils.getSafeString(mapping.getJdbcType()))){ 
						cs.setDouble(numberOfParameters, ObjUtils.parseDouble(param.get(mapping.getProperty()))); 
					} else if ("FLOAT".equals(ObjUtils.getSafeString(mapping.getJdbcType()))){ 
						cs.setDouble(numberOfParameters, ObjUtils.parseDouble(param.get(mapping.getProperty()))); 
					} else if ("DATE".equals(ObjUtils.getSafeString(mapping.getJdbcType()))){ 
						SimpleDateFormat format = new SimpleDateFormat("yyyyMMdd");
						java.util.Date parsed = format.parse(ObjUtils.getSafeString(param.get(mapping.getProperty())));
						java.sql.Date dateValue = new java.sql.Date(parsed.getTime());
						cs.setDate(numberOfParameters, dateValue ); 
					} 
				} else {
					if("VARCHAR".equals(ObjUtils.getSafeString(mapping.getJdbcType()))){
						cs.registerOutParameter(numberOfParameters, java.sql.Types.VARCHAR);
					} else if ("NUMERIC".equals(ObjUtils.getSafeString(mapping.getJdbcType()))){
						cs.registerOutParameter(numberOfParameters,  java.sql.Types.NUMERIC); 
					} else if ("INTEGER".equals(ObjUtils.getSafeString(mapping.getJdbcType()))){ 
						cs.registerOutParameter(numberOfParameters,  java.sql.Types.INTEGER); 
					} else if ("FLOAT".equals(ObjUtils.getSafeString(mapping.getJdbcType()))){ 
						cs.registerOutParameter(numberOfParameters,  java.sql.Types.FLOAT); 
					} else if ("DATE".equals(ObjUtils.getSafeString(mapping.getJdbcType()))){ 
						SimpleDateFormat format = new SimpleDateFormat("yyyyMMdd");
						java.util.Date parsed = format.parse(ObjUtils.getSafeString(param.get(mapping.getProperty())));
						java.sql.Date dateValue = new java.sql.Date(parsed.getTime());
						cs.registerOutParameter(numberOfParameters,  java.sql.Types.DATE); 
					} 
				}
				numberOfParameters ++;
			}
			cs.execute();
			numberOfParameters = 1;
			for(ParameterMapping mapping : mappedParams){
				if("OUT".equals(ObjUtils.getSafeString(mapping.getMode()))) {
					if("VARCHAR".equals(ObjUtils.getSafeString(mapping.getJdbcType()))){
						if(ObjUtils.isNotEmpty(cs.getString(numberOfParameters))) {
							rMap.put( ObjUtils.getSafeString(mapping.getProperty()), ObjUtils.getSafeString(cs.getString(numberOfParameters)));
//							logger.debug("############ VARCHAR  OUT getParam "+String.valueOf(numberOfParameters)+" : "+cs.getString(numberOfParameters));
						}
					} else if ("NUMERIC".equals(ObjUtils.getSafeString(mapping.getJdbcType()))){ 
						rMap.put( ObjUtils.getSafeString(mapping.getProperty()), cs.getDouble(numberOfParameters));
					} else if ("INTEGER".equals(ObjUtils.getSafeString(mapping.getJdbcType()))){ 
						rMap.put( ObjUtils.getSafeString(mapping.getProperty()), cs.getInt(numberOfParameters));
					} else if ("FLOAT".equals(ObjUtils.getSafeString(mapping.getJdbcType()))){ 
						rMap.put( ObjUtils.getSafeString(mapping.getProperty()), cs.getFloat(numberOfParameters));
					} else if ("DATE".equals(ObjUtils.getSafeString(mapping.getJdbcType()))){ 
						rMap.put( ObjUtils.getSafeString(mapping.getProperty()), cs.getDate(numberOfParameters).valueOf("yyyymmdd"));
					} 
				}
				numberOfParameters ++;
			} 
		} catch (SQLException e) {
			errorMessage.append(e.getMessage());
			e.printStackTrace();
		} catch (Throwable e2) {
			logger.debug(">>>>>>>  queryId : " + queryId);
			logger.error(e2.getMessage());
			e2.printStackTrace();
			errorMessage.append( e2.getMessage());
			e2.printStackTrace();
		} finally {
			if(dbConnection != null) try {dbConnection.close();}catch(SQLException e){};
			if(cs != null) try {cs.close();}catch(SQLException e){};
			logger.debug(">>>>>>>  queryId : " + queryId);
			logger.debug(">>>>>>>  SQL : " + sql);
		}
		return rMap;
	}
}
