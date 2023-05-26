package foren.framework.web.crystalreport;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Calendar;
import java.util.Collection;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.businessobjects.prompting.objectmodel.common.IPromptValue.IString;
import com.crystaldecisions.sdk.occa.report.application.DBOptions;
import com.crystaldecisions.sdk.occa.report.application.DataDefController;
import com.crystaldecisions.sdk.occa.report.application.ISubreportClientDocument;
import com.crystaldecisions.sdk.occa.report.application.ParameterFieldController;
import com.crystaldecisions.sdk.occa.report.application.PrintOutputController;
import com.crystaldecisions.sdk.occa.report.application.ReportClientDocument;
import com.crystaldecisions.sdk.occa.report.application.DatabaseController;
import com.crystaldecisions.sdk.occa.report.application.OpenReportOptions;
import com.crystaldecisions.sdk.occa.report.data.ConnectionInfo;
import com.crystaldecisions.sdk.occa.report.data.Field;
import com.crystaldecisions.sdk.occa.report.data.FieldDisplayNameType;
import com.crystaldecisions.sdk.occa.report.data.Fields;
import com.crystaldecisions.sdk.occa.report.data.IConnectionInfo;
import com.crystaldecisions.sdk.occa.report.data.IDataDefinition;
import com.crystaldecisions.sdk.occa.report.data.IField;
import com.crystaldecisions.sdk.occa.report.data.ParameterField;
import com.crystaldecisions.sdk.occa.report.data.ParameterFieldRangeValue;
import com.crystaldecisions.sdk.occa.report.data.RangeValueBoundType;
import com.crystaldecisions.sdk.occa.report.data.Values;
import com.crystaldecisions.sdk.occa.report.exportoptions.ReportExportFormat;
import com.crystaldecisions.sdk.occa.report.lib.IStrings;
import com.crystaldecisions.sdk.occa.report.lib.ReportSDKException;

import foren.framework.dao.TlabAbstractDAO;
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.ObjUtils;

public class CrystalReportDoc {

	 private Logger logger = LoggerFactory.getLogger(CrystalReportDoc.class);

	 @Resource(name = "tlabAbstractDAO")
	 protected TlabAbstractDAO dao;
	 

	 public CrystalReportFactory generateReport(String file, String menuId, Map param, String query, List<Map<String, String>> subReports,  HttpServletRequest request ) throws Exception {
		//return 	generateReport(file, null, menuId, param, queryId, subReports,  request, rsList );
		 return 	generateReport(file, null, menuId, param, query, subReports,  request );
	 }
	 
	 public CrystalReportFactory generateReportLog(String file, ReportClientDocument clientDoc, String menuId, Map param, String query, List<Map<String, String>> subReports,  HttpServletRequest request  ) throws Exception {
		 	
		 	
		 	CrystalReportFactory cr = new CrystalReportFactory();
		 	cr.setRptFile(file, menuId);
		 	
		 	if(clientDoc == null) {
		 		clientDoc = new ReportClientDocument();
		 	}
		 	logger.debug("@@@@@@@@@@@@@   ReportClientDocument 생성 ");
		 	clientDoc.setReportAppServer(ReportClientDocument.inprocConnectionString);
		 	logger.debug("@@@@@@@@@@@@@   clientDoc.setReportAppServer ");
	        clientDoc.open(cr.getRptFile(),  OpenReportOptions._openAsReadOnly);
	        logger.debug("@@@@@@@@@@@@@   clientDoc.open ");
		 	cr.setParam(param);
		 	logger.debug("@@@@@@@@@@@@@   setParam ");
		 	String username = ConfigUtil.getString("crystalreport.username");
	 		String password = ConfigUtil.getString("crystalreport.password");
	 		DatabaseController dbController = null;
	 		int replaceParams = DBOptions._ignoreCurrentTableQualifiers;//_doNotVerifyDB;
	        
	 		
		 	try{
		 		logger.debug("@@@@@@@@@@@@@   dbController 시작");
		        dbController = clientDoc.getDatabaseController();
		        logger.debug("@@@@@@@@@@@@@   oldConnectionInfo");
		        IConnectionInfo oldConnectionInfo = dbController.getConnectionInfos(null).getConnectionInfo(0);                                        
		        logger.debug("@@@@@@@@@@@@@   newConn ");
		 		IConnectionInfo newConn = cr.getConnectionInfo();
	 			logger.debug("@@@@@@@@@@@@@ new Connection Info : "+newConn.getAttributes().get("JDBC Connection String"));
	 			dbController.replaceConnection(oldConnectionInfo, newConn, null, replaceParams);
		        dbController.logon(cr.getConnectionInfo(), username, password);
		        logger.debug("@@@@@@@@@@@@@   dbController.logon ");
		 	} catch (ReportSDKException ce)	{
	 			logger.error(ce.getMessage());
	 		}
	         
	        logger.debug("@@@@@@@@@@@@@  dbController 끝 ");

	        
	        Connection dbConnection = null;
			PreparedStatement stmt = null;
			ResultSet rs1 = null;
			PreparedStatement subStmt = null;
		    ResultSet subRs = null;
		        
			String sql = "";
			
			try {
				Class.forName(ConfigUtil.getString("crystalreport.jdbcDriver"));
				
			} catch (ClassNotFoundException e) {
				logger.error(e.getMessage());
			}

			try {
				String serverName = ConfigUtil.getString("crystalreport.serverName");
		 	    String port = ConfigUtil.getString("crystalreport.port");
		 	    String dbName = ConfigUtil.getString("crystalreport.databaseName");
		 		String connectionURL = serverName + ":" + port + ";databaseName=" + dbName;
		 		logger.debug("##############   Param, SQL 시작 ");
		 		if(query != null)	{
					dbConnection = DriverManager.getConnection(connectionURL, username,password);
					
					logger.debug("##############   sql : "+query);
					
					stmt = dbConnection.prepareStatement(query);
					logger.debug("##############   prepareStatement ");
			        rs1 = stmt.executeQuery();
			        logger.debug("##############   executeQuery ");
			        
			        if(dbController != null && dbController.getDatabase() != null && dbController.getDatabase().getTables().getTable(0).getAlias() != null)	{
			        	logger.debug("##############   table alias: "+dbController.getDatabase().getTables().getTable(0).getAlias());
			        	dbController.setDataSource(rs1, dbController.getDatabase().getTables().getTable(0).getAlias(), "Command");
			        }
		 		}
		 		
		 		if(subReports != null)	{
		 			Map<String, Object> subParam = (Map<String, Object>)cr.getParamMap();
		 			logger.debug("@@@@@@@@@@@@@   SUB Report 시작 ");
			    	for(Map<String, String> subReport : subReports)	{
			    		CrystalReportDoc subDoc = new CrystalReportDoc();
			    		logger.debug("@@@@@@@@@@@@@   Sub CrystalReportDoc 생성");
			    		ISubreportClientDocument subClientDoc = clientDoc.getSubreportController().getSubreport(subReport.get("NAME"));
			    		logger.debug("@@@@@@@@@@@@@   getSubreport : "+subReport.get("NAME"));
			    		CrystalReportFactory subCr = new CrystalReportFactory();
			    		subCr.setRptFile(subReport.get("NAME"), menuId);
					 	
			    		subCr.setParam(param);
			    		logger.debug("@@@@@@@@@@@@@  setParam ");
				        DatabaseController subDBController = subClientDoc.getDatabaseController();
				        logger.debug("@@@@@@@@@@@@@   subDBController ");
				        
				        IConnectionInfo subOldConnectionInfo = subDBController.getConnectionInfos(null).getConnectionInfo(0);                                        
				        logger.debug("@@@@@@@@@@@@@   subOldConnectionInfo ");
				       
				        if(dbConnection == null) {
				        	dbConnection = DriverManager.getConnection(connectionURL, username,password);
				        }
				        
						logger.debug("@@@@@@@@@@@@@  subReport SQL :  " + subReport.get("SQL"));
						subStmt = dbConnection.prepareStatement(subReport.get("SQL"));
						logger.debug("##############   subStmt ");
						subRs = subStmt.executeQuery(); 
				        logger.debug("##############   subRs ");

				        subDBController.setDataSource(subRs, subDBController.getDatabase().getTables().getTable(0).getAlias(), "Command");
				        logger.debug("##############   setDataSource ");
				        subDBController.replaceConnection(subOldConnectionInfo, subCr.getConnectionInfo(), null, replaceParams);
				        logger.debug("@@@@@@@@@@@@@ new sub Connection Info : "+subCr.getConnectionInfo().getAttributes().get("JDBC Connection String"));
			 			
				        ParameterFieldController subParamController = subClientDoc.getDataDefController().getParameterFieldController();
				        logger.debug("@@@@@@@@@@@@@  subParamController ");
				        Fields subpFields = subClientDoc.getDataDefController().getDataDefinition().getParameterFields() ;
				       
			        	
				        Iterator subPFIterator = subpFields.iterator();
				        while(subPFIterator.hasNext())	{
				        	ParameterField field = (ParameterField) subPFIterator.next();
				        	
				        	if(field.getName().indexOf("Pm-ado.")!=0)	{
				        		logger.debug("%%%%%%%%%%%%%%%%   "+field.getName());
				        		if(!"undefined".equals(subParam.get(field.getName())))	{
				        			subParamController.setCurrentValue("",field.getName(),subParam.get(field.getName()));
				        			logger.debug("%%%%%%%%%%%%%%%%   toVariantTypeString : "+ field.getType().toVariantTypeString());
				        		}
				        		
				        	}
				        	
				        }
				        
			    	}
		        }
		 		
		        ParameterFieldController paramController = clientDoc.getDataDefController().getParameterFieldController();
			       
		 		Map<String, Object> bParam = (Map<String, Object>)cr.getParamMap();
		     
		        Fields params = clientDoc.getDataDefController().getDataDefinition().getParameterFields();
		        

	        	Fields pFields = clientDoc.getDataDefinition().getParameterFields() ;
		        Iterator pfIterator = pFields.iterator();
		        while(pfIterator.hasNext())	{
		        	ParameterField field = (ParameterField) pfIterator.next();
		        	logger.debug("%%%%%%%%%%%%%%%%   "+field.getName());
		        	if(!"undefined".equals(bParam.get(field.getName())))	{
		        		paramController.setCurrentValue("",field.getName(),bParam.get(field.getName()));
		        		logger.debug("%%%%%%%%%%%%%%%%   toVariantTypeString : "+ field.getType().toVariantTypeString());
		        	}
	        		
		        }

		        
		        ByteArrayInputStream byteArrayInputStream;
		        //PrintOutputController pCon = clientDoc.getPrintOutputController();
		    	byteArrayInputStream = (ByteArrayInputStream) clientDoc.getPrintOutputController().export(ReportExportFormat.PDF);
		    	logger.debug("##############   byteArrayInputStream ");
		    	cr.setInputStream(byteArrayInputStream);
		        logger.debug("##############   setInputStream ");
			} catch (SQLException e) {
				logger.error("   >>>>>>>  query : " + query);
				logger.error(e.toString());
				
			} catch (Throwable e2)	{
				logger.error(e2.toString());
				e2.printStackTrace();
			} finally {
				if(dbConnection != null) try {dbConnection.close();
					logger.debug("##############   dbConnection.close() ");
				}catch(SQLException e){};
				if(stmt != null) try {stmt.close();}catch(SQLException e){};
				if(rs1 != null) try {rs1.close();}catch(SQLException e){};
				if(subStmt != null) try {subStmt.close();}catch(SQLException e){};
				if(subRs != null) try {subRs.close();}catch(SQLException e){};
				
			}
	        
	        cr.setReportClientDocument(clientDoc);
	        
		 	return cr;
	 }
	 
	 public CrystalReportFactory generateReport(String file, ReportClientDocument clientDoc, String menuId, Map param, String query, List<Map<String, String>> subReports,  HttpServletRequest request  ) throws Exception {
		 	
		 	
		 	CrystalReportFactory cr = new CrystalReportFactory();
		 	cr.setRptFile(file, menuId);
		 	
		 	if(clientDoc == null) {
		 		clientDoc = new ReportClientDocument();
		 	}
		 	//logger.debug("@@@@@@@@@@@@@   ReportClientDocument 생성 ");
		 	clientDoc.setReportAppServer(ReportClientDocument.inprocConnectionString);
		 	//logger.debug("@@@@@@@@@@@@@   clientDoc.setReportAppServer ");
	        clientDoc.open(cr.getRptFile(),  OpenReportOptions._openAsReadOnly);
	        //logger.debug("@@@@@@@@@@@@@   clientDoc.open ");
		 	cr.setParam(param);
		 	//logger.debug("@@@@@@@@@@@@@   setParam ");
		 	String username = ConfigUtil.getString("crystalreport.username");
	 		String password = ConfigUtil.getString("crystalreport.password");
	 		DatabaseController dbController = null;
	 		int replaceParams = DBOptions._ignoreCurrentTableQualifiers;//_doNotVerifyDB;
	        
	 		
		 	try{
		 		//logger.debug("@@@@@@@@@@@@@   dbController 시작");
		        dbController = clientDoc.getDatabaseController();
		        //logger.debug("@@@@@@@@@@@@@   oldConnectionInfo");
		        IConnectionInfo oldConnectionInfo = dbController.getConnectionInfos(null).getConnectionInfo(0);                                        
		        //logger.debug("@@@@@@@@@@@@@   newConn ");
		 		IConnectionInfo newConn = cr.getConnectionInfo();
	 			//logger.debug("@@@@@@@@@@@@@ new Connection Info : "+newConn.getAttributes().get("JDBC Connection String"));
	 			dbController.replaceConnection(oldConnectionInfo, newConn, null, replaceParams);
		        dbController.logon(cr.getConnectionInfo(), username, password);
		        //logger.debug("@@@@@@@@@@@@@   dbController.logon ");
		 	} catch (ReportSDKException ce)	{
	 			logger.error(ce.getMessage());
	 		}
	         
	        //logger.debug("@@@@@@@@@@@@@  dbController 끝 ");

	        
	        Connection dbConnection = null;
			PreparedStatement stmt = null;
			ResultSet rs1 = null;
			PreparedStatement subStmt = null;
		    ResultSet subRs = null;
		        
			String sql = "";
			
			try {
				Class.forName(ConfigUtil.getString("crystalreport.jdbcDriver"));
				
			} catch (ClassNotFoundException e) {
				logger.error(e.getMessage());
			}

			try {
				String serverName = ConfigUtil.getString("crystalreport.serverName");
		 	    String port = ConfigUtil.getString("crystalreport.port");
		 	    String dbName = ConfigUtil.getString("crystalreport.databaseName");
		 		String connectionURL = serverName + ":" + port + ";databaseName=" + dbName;
		 		//logger.debug("##############   Param, SQL 시작 ");
		 		if(query != null)	{
					dbConnection = DriverManager.getConnection(connectionURL, username,password);
					
					logger.debug("##############   sql : "+query);
					
					stmt = dbConnection.prepareStatement(query);
					//logger.debug("##############   prepareStatement ");
			        rs1 = stmt.executeQuery();
			        //logger.debug("##############   executeQuery ");
			        
			        if(dbController != null && dbController.getDatabase() != null && dbController.getDatabase().getTables().getTable(0).getAlias() != null)	{
			        	//logger.debug("##############   table alias: "+dbController.getDatabase().getTables().getTable(0).getAlias());
			        	dbController.setDataSource(rs1, dbController.getDatabase().getTables().getTable(0).getAlias(), "Command");
			        }
		 		}
		 		
		 		if(subReports != null)	{
		 			Map<String, Object> subParam = (Map<String, Object>)cr.getParamMap();
		 			//logger.debug("@@@@@@@@@@@@@   SUB Report 시작 ");
			    	for(Map<String, String> subReport : subReports)	{
			    		CrystalReportDoc subDoc = new CrystalReportDoc();
			    		//logger.debug("@@@@@@@@@@@@@   Sub CrystalReportDoc 생성");
			    		ISubreportClientDocument subClientDoc = clientDoc.getSubreportController().getSubreport(subReport.get("NAME"));
			    		//logger.debug("@@@@@@@@@@@@@   getSubreport : "+subReport.get("NAME"));
			    		CrystalReportFactory subCr = new CrystalReportFactory();
			    		subCr.setRptFile(subReport.get("NAME"), menuId);
					 	
			    		subCr.setParam(param);
			    		//logger.debug("@@@@@@@@@@@@@  setParam ");
			    		
			    		//if(ObjUtils.isNotEmpty(subReport.get("SQL")))	{
				        DatabaseController subDBController = subClientDoc.getDatabaseController();
				        //logger.debug("@@@@@@@@@@@@@   subDBController ");
				        
				        IConnectionInfo subOldConnectionInfo = subDBController.getConnectionInfos(null).getConnectionInfo(0);                                        
				        //logger.debug("@@@@@@@@@@@@@   subOldConnectionInfo ");
				        // SQL이 없는 경우는 RPT파일에 등록된 sql 사용
				        if(ObjUtils.isNotEmpty(subReport.get("SQL")))	{
					        if(dbConnection == null) {
					        	dbConnection = DriverManager.getConnection(connectionURL, username,password);
					        }
				       
							//logger.debug("@@@@@@@@@@@@@  subReport SQL :  " + subReport.get("SQL"));
							subStmt = dbConnection.prepareStatement(subReport.get("SQL"));
							//logger.debug("##############   subStmt ");
							subRs = subStmt.executeQuery(); 
					        //logger.debug("##############   subRs ");
	
					        subDBController.setDataSource(subRs, subDBController.getDatabase().getTables().getTable(0).getAlias(), "Command");
					        //logger.debug("##############   setDataSource ");
				        }
				        subDBController.replaceConnection(subOldConnectionInfo, subCr.getConnectionInfo(), null, replaceParams);
				        //logger.debug("@@@@@@@@@@@@@ new sub Connection Info : "+subCr.getConnectionInfo().getAttributes().get("JDBC Connection String"));
			    		
				        ParameterFieldController subParamController = subClientDoc.getDataDefController().getParameterFieldController();
				        //logger.debug("@@@@@@@@@@@@@  subParamController ");
				        Fields subpFields = subClientDoc.getDataDefController().getDataDefinition().getParameterFields() ;
				       
			        	
				        Iterator subPFIterator = subpFields.iterator();
				        while(subPFIterator.hasNext())	{
				        	ParameterField field = (ParameterField) subPFIterator.next();
				        	
				        	if(field.getName().indexOf("Pm-ado.")!=0)	{
				        		logger.debug("%%%%%%%%%%%%%%%%   "+field.getName());
				        		if(!"undefined".equals(subParam.get(field.getName())))	{
				        			subParamController.setCurrentValue("",field.getName(),subParam.get(field.getName()));
				        			logger.debug("%%%%%%%%%%%%%%%%   toVariantTypeString : "+ field.getType().toVariantTypeString());
				        		}
				        		
				        	}
				        	
				        }
				        
			    	}
		        }
		 		
		        ParameterFieldController paramController = clientDoc.getDataDefController().getParameterFieldController();
			       
		 		Map<String, Object> bParam = (Map<String, Object>)cr.getParamMap();
		     
		        Fields params = clientDoc.getDataDefController().getDataDefinition().getParameterFields();
		        

	        	Fields pFields = clientDoc.getDataDefinition().getParameterFields() ;
		        Iterator pfIterator = pFields.iterator();
		        while(pfIterator.hasNext())	{
		        	ParameterField field = (ParameterField) pfIterator.next();
		        	logger.debug("%%%%%%%%%%%%%%%%   "+field.getName());
		        	if(!"undefined".equals(bParam.get(field.getName())))	{
		        		paramController.setCurrentValue("",field.getName(),bParam.get(field.getName()));
		        		logger.debug("%%%%%%%%%%%%%%%%   toVariantTypeString : "+ field.getType().toVariantTypeString());
		        	}
	        		
		        }

		        
		        ByteArrayInputStream byteArrayInputStream;
		        //PrintOutputController pCon = clientDoc.getPrintOutputController();
		    	byteArrayInputStream = (ByteArrayInputStream) clientDoc.getPrintOutputController().export(ReportExportFormat.PDF);
		    	//logger.debug("##############   byteArrayInputStream ");
		    	cr.setInputStream(byteArrayInputStream);
		        //logger.debug("##############   setInputStream ");
			} catch (SQLException e) {
				logger.error("   >>>>>>>  query : " + query);
				logger.error(e.toString());
				
			} catch (Throwable e2)	{
				logger.error(e2.toString());
				e2.printStackTrace();
			} finally {
				if(dbConnection != null) try {dbConnection.close();
					logger.debug("##############   dbConnection.close() ");
				}catch(SQLException e){};
				if(stmt != null) try {stmt.close();}catch(SQLException e){};
				if(rs1 != null) try {rs1.close();}catch(SQLException e){};
				if(subStmt != null) try {subStmt.close();}catch(SQLException e){};
				if(subRs != null) try {subRs.close();}catch(SQLException e){};
				
			}
	        
	        cr.setReportClientDocument(clientDoc);
	        
		 	return cr;
	 }
}
