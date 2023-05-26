package foren.unilite.modules.z_wm;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.Date;
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
import foren.framework.utils.GStringUtils;
import foren.framework.utils.ObjUtils;

@Service("externalDAO_JUSO_WM")
@SuppressWarnings({ "unchecked", "rawtypes", "static-access" })
public class ExternalDAO_JUSO_WM {
	/** The logger. */
	private Logger logger	= LoggerFactory.getLogger(this.getClass());
	private String jndiName	= "jdbc/CJ_JUSO";

	@Resource(name = "tlabAbstractDAO")
	protected TlabAbstractDAO dao;


	/**
	 * connection
	 * @return
	 * @throws Exception
	 */
	private Connection oracleConnection() throws Exception {
//		수동 테스트
//		String url = "jdbc:oracle:thin:@(DESCRIPTION =(FAILOVER = ON)(LOAD_BALANCE = OFF)(ADDRESS = (PROTOCOL=TCP)(HOST = 61.33.235.97)(PORT = 1521))(ADDRESS = (PROTOCOL=TCP)(HOST = 61.33.235.98)(PORT = 1521))(CONNECT_DATA =(SERVICE_NAME = CGIS)))";
//		String user = "widememory";
//		String password = "widememory$#!1";
//		Connection conn = DriverManager.getConnection(url, user, password);
//		return conn;
		Connection dbConnection	= null;
		Context ctx				= new InitialContext();
		DataSource ds			= (DataSource)ctx.lookup("java:comp/env/"+jndiName);
		dbConnection			= ds.getConnection();
		return dbConnection;
		// return rs;
	}

	/**
	 * select
	 * @param queryId
	 * @param param
	 * @return
	 */
	public List<Map<String, Object>> list(String queryId, Map param) {
		Connection dbConnection	= null;
		PreparedStatement pstmt	= null;
		ResultSet rs			= null;
		String sql				= "";
		List<Map<String,Object>> rList = new ArrayList();
		try {
			dbConnection = this.oracleConnection();
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
		} catch (Throwable e2) {
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

	/**
	 * procedure 호출
	 * @param queryId
	 * @param param
	 * @return
	 */
	public Map<String, Object> procExec(String queryId, Map<String, Object> param) {
		Connection dbConnection	= null;
		CallableStatement cs	= null;
		String sql				= "";
		Map<String, Object> rMap= new HashMap<String, Object>();
		try {
			logger.debug("############  success connect !!");
			dbConnection						=  this.oracleConnection();
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
						logger.debug("############ VARCHAR  IN setParam "+String.valueOf(numberOfParameters)+" ("+mapping.getProperty()+") : "+ObjUtils.getSafeString(param.get(mapping.getProperty())));
					} else if ("NUMERIC".equals(ObjUtils.getSafeString(mapping.getJdbcType()))){ 
						cs.setDouble(numberOfParameters,  ObjUtils.parseDouble(param.get(mapping.getProperty()))); 
						logger.debug("############ NUMERIC IN setParam "+String.valueOf(numberOfParameters)+" : "+ObjUtils.getSafeString(param.get(mapping.getProperty())));
					} else if ("INTEGER".equals(ObjUtils.getSafeString(mapping.getJdbcType()))){ 
						cs.setDouble(numberOfParameters, ObjUtils.parseDouble(param.get(mapping.getProperty()))); 
						logger.debug("############ INTEGER IN setParam "+String.valueOf(numberOfParameters)+" : "+ObjUtils.getSafeString(param.get(mapping.getProperty())));
					} else if ("FLOAT".equals(ObjUtils.getSafeString(mapping.getJdbcType()))){ 
						cs.setDouble(numberOfParameters, ObjUtils.parseDouble(param.get(mapping.getProperty()))); 
						logger.debug("############ FLOAT IN setParam "+String.valueOf(numberOfParameters)+" : "+ObjUtils.getSafeString(param.get(mapping.getProperty())));
					} else if ("DATE".equals(ObjUtils.getSafeString(mapping.getJdbcType()))){ 
						SimpleDateFormat format = new SimpleDateFormat("yyyyMMdd");
						java.util.Date parsed = format.parse(ObjUtils.getSafeString(param.get(mapping.getProperty())));
						java.sql.Date dateValue = new java.sql.Date(parsed.getTime());
						cs.setDate(numberOfParameters, dateValue ); 
						logger.debug("############ DATE IN setParam "+String.valueOf(numberOfParameters)+" : "+ObjUtils.getSafeString(param.get(mapping.getProperty())));
					} 
				} else {
					if("VARCHAR".equals(ObjUtils.getSafeString(mapping.getJdbcType()))){
						cs.registerOutParameter(numberOfParameters, java.sql.Types.VARCHAR);
						logger.debug("############ VARCHAR  OUT setParam "+String.valueOf(numberOfParameters));
					} else if ("NUMERIC".equals(ObjUtils.getSafeString(mapping.getJdbcType()))){
						cs.registerOutParameter(numberOfParameters,  java.sql.Types.NUMERIC); 
						logger.debug("############ NUMERIC OUT setParam "+String.valueOf(numberOfParameters));
					} else if ("INTEGER".equals(ObjUtils.getSafeString(mapping.getJdbcType()))){ 
						cs.registerOutParameter(numberOfParameters,  java.sql.Types.INTEGER); 
						logger.debug("############ INTEGER OUT setParam "+String.valueOf(numberOfParameters));
					} else if ("FLOAT".equals(ObjUtils.getSafeString(mapping.getJdbcType()))){ 
						cs.registerOutParameter(numberOfParameters,  java.sql.Types.FLOAT); 
						logger.debug("############ FLOAT OUT setParam "+String.valueOf(numberOfParameters));
					} else if ("DATE".equals(ObjUtils.getSafeString(mapping.getJdbcType()))){ 
						SimpleDateFormat format = new SimpleDateFormat("yyyyMMdd");
						java.util.Date parsed = format.parse(ObjUtils.getSafeString(param.get(mapping.getProperty())));
						java.sql.Date dateValue = new java.sql.Date(parsed.getTime());
						cs.registerOutParameter(numberOfParameters,  java.sql.Types.DATE); 
						logger.debug("############ DATE OUT setParam "+String.valueOf(numberOfParameters));
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
			logger.error(e.toString());
		} catch (Throwable e2) {
			logger.debug(">>>>>>>  queryId : " + queryId);
			logger.error(e2.toString());
			e2.printStackTrace();
		} finally {
			if(dbConnection != null) try {dbConnection.close();}catch(SQLException e){};
			if(cs != null) try {cs.close();}catch(SQLException e){};
			logger.debug(">>>>>>>  queryId : " + queryId);
			logger.debug(">>>>>>>  SQL : " + sql);
		}
		return rMap;
	}

	private String replaceParameter2Value(String sql, String value) {
		return GStringUtils.replaceFirst(sql,"?", value);
	}
}