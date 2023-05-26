<%@page language="java" contentType="text/html; charset=utf-8"%>
<%@page import="foren.framework.utils.*"%>
<%@page import="java.util.*"%>

<%@page import="gudusoft.gsqlparser.*"%>
<%@page import="gudusoft.gsqlparser.pp.para.*"%>
<%@page import="gudusoft.gsqlparser.pp.para.styleenums.*"%>
<%@page import="gudusoft.gsqlparser.pp.stmtformatter.*"%>


<%@page import="foren.unilite.com.service.TlabDbAdminService"%>
<%
	TlabDbAdminService dbAdminService = (TlabDbAdminService) ObjUtils.getBean("tlabDbAdminService");
	
	Set<String> AVOID_UPDATE = new HashSet<String>(Arrays.asList(
		     new String[] {"INSERT_DB_USER", "INSERT_DB_TIME"}
	));
	
	
    String owner = "TRAINT";
    boolean isLeftComma = false;
    Map param = new HashMap();
    param.put("owner", owner);


    String tableName = request.getParameter("tableName").trim();
    List<Map<String, Object>> cols = null;
    List<Map<String, Object>> tCols = null;
    if (!ObjUtils.isEmpty(tableName)) {
        param.put("tableName", tableName);
        tCols = dbAdminService.getColumnList(param);
        request.setAttribute("cols", tCols);
        for(Map<String, Object> col : tCols) {
            if( "NUMBER".equals(col.get("type"))) {
                Object t =col.get("scale");
                if (t == null ) {
                    t = 0;
                }
                if(Double.parseDouble(ObjUtils.getSafeString(t,"0")) > 0 ) {
               	 col.put("excelType", "number");
                } else {
                    col.put("excelType", "integer");
                }      
            } else {
                col.put("excelType", "string");
            }
        }
        try {
        	//request.setAttribute("samples", dbAdminService.getSampleData(tableName));
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }
    

    SqlFmt sqlFmt = new SqlFmt();
	if(tCols != null) {
		cols = sqlFmt.colSort(tCols);
	    StringBuffer sqlUpdate = new StringBuffer();
	    sqlUpdate.append("UPDATE " + tableName + " SET  ");
	    int cnt = 0;
	    Map<String, String> pks = new HashMap<String, String>();
	    for(Map<String,Object> col : cols) {
	        String columnName = ((String)col.get("name")).toUpperCase();
	        String paramName = sqlFmt.getColumnValue(columnName);
	    	//sqlUpdate.append(columnName + " = #" + GStringUtils.toCamelCase(columnName) +"#");
	    	if(! AVOID_UPDATE.contains(columnName)) {
	    		if ( !sqlFmt.isSysCol(columnName)  ) {
	    			sqlUpdate.append("\n\t<isPropertyAvailable property=\"");
	    		
			    	sqlUpdate.append(columnName );
		    		sqlUpdate.append("\" >\n\t\t");
	    		} else {
	    			sqlUpdate.append("\n\t\t");
	    		}
	    		if(cnt > 0) {
		            sqlUpdate.append(" , ");
		        }
		    	sqlUpdate.append(columnName + " = ");
		    	sqlUpdate.append(paramName) ;
		    	
	    		if ( !sqlFmt.isSysCol(columnName)  ) {
	    			sqlUpdate.append("\n\t</isPropertyAvailable>");
	    		}
	    	}
	    	if(!ObjUtils.isEmpty(col.get("pk"))) {
	    	    //pks.put(columnName, GStringUtils.toCamelCase(columnName));
	    	    pks.put(columnName, columnName);
	    	}
	    	cnt ++;
	    }
	    
	    if(!pks.isEmpty()) {
	        sqlUpdate.append("\n WHERE \t");
	        Set<String> keys = pks.keySet();
	        cnt = 0;
	        for(String key : keys) {
	            if(cnt++ > 0) {
		            sqlUpdate.append("\n\t AND ");
		        }
	            sqlUpdate.append(key + " = #" + pks.get(key) + "# ");
	        }
	    }
	    request.setAttribute("sqlUpdate", sqlUpdate);
	    //request.setAttribute("sqlUpdate", sqlFmt.sqlFormat(sqlUpdate.toString(), isLeftComma, false));
	    //request.setAttribute("sqlUpdateH", sqlFmt.sqlFormat(sqlUpdate.toString(), isLeftComma, true));
	    
	    
	    StringBuffer sqlInsert = new StringBuffer();
	    sqlInsert.append("INSERT INTO " + tableName + " ( ");
	     cnt = 0;
	    for(Map<String,Object> col : cols) {
	    	String columnName = ((String)col.get("name")).toUpperCase();
	        
	        if ( !sqlFmt.isSysCol(columnName)  ) {
	        	sqlInsert.append("\n\t<isPropertyAvailable property=\"").append(columnName ).append("\" >\n\t\t");
    		} else {
    			sqlInsert.append("\n\t\t");
    		}
        	if(cnt > 0 ) sqlInsert.append(" , ");
			sqlInsert.append(columnName );
	    	
    		if ( !sqlFmt.isSysCol(columnName)  ) {
    			sqlInsert.append("\n\t</isPropertyAvailable>");
    		}
	       cnt ++;
	    }
	    sqlInsert.append("\n ) VALUES ( ");
	    cnt = 0;
	    for(Map<String,Object> col : cols) {

	        //sqlInsert.append(" #" + GStringUtils.toCamelCase((String)col.get("name")) +"#");
	        //sqlInsert.append(sqlFmt.getColumnValue((String)col.get("name")));
	        
	    	String columnName = ((String)col.get("name")).toUpperCase();
	        String pValue = sqlFmt.getColumnValue(columnName);
	        if ( !sqlFmt.isSysCol(columnName)  ) {
	        	sqlInsert.append("\n\t<isPropertyAvailable property=\"").append(columnName ).append("\" >\n\t\t");
    		} else {
    			sqlInsert.append("\n\t\t");
    		}
        	if(cnt > 0 ) sqlInsert.append(" , ");
			sqlInsert.append(pValue );
	    	
    		if ( !sqlFmt.isSysCol(columnName)  ) {
    			sqlInsert.append("\n\t</isPropertyAvailable>");
    		}
	       cnt ++;
	    	
	    }
	    sqlInsert.append("\n)");

	    request.setAttribute("sqlInsert", sqlInsert.toString());
	    //request.setAttribute("sqlInsert", sqlFmt.sqlFormat(sqlInsert.toString(), isLeftComma, false));
	    //request.setAttribute("sqlInsertH", sqlFmt.sqlFormat(sqlInsert.toString(), isLeftComma, true));
	}
	
%>
<%!
class SqlFmt {
	
	private  final Set<String> sysCols = new HashSet<String>(Arrays.asList(
			new String[] {"COMP_CODE", "UPDATE_DB_USER", "UPDATE_DB_TIME", "INSERT_DB_USER", "INSERT_DB_TIME"}
		));
	
	public boolean isSysCol(String key) {
		return sysCols.contains(key);
	}
	public String getColumnValue(String field) {
		if 	("COMP_CODE".equals(field)) {
			return "#S_COMP_CODE#";
		} else if 	("UPDATE_DB_USER".equals(field)) {
				return "#S_USER_ID#";
		} else if 	("UPDATE_DB_TIME".equals(field)) {
			return "getDate()";
		} else if 	("INSERT_DB_USER".equals(field)) {
			return "#S_USER_ID#";
		} else if 	("INSERT_DB_TIME".equals(field)) {
			return "getDate()";
		} else {
			return "#" + field +"#";
		}
		 
	}
	
	public List<Map<String, Object>> colSort(List<Map<String, Object>> cols) {
		List<Map<String, Object>> rv = new ArrayList();
		List<Map<String, Object>> rvt = new ArrayList();
		for(Map<String,Object> col : cols) {
	        String columnName = ((String)col.get("name")).toUpperCase();
	        if(isSysCol (columnName) ) {
	        	rv.add(col);
	        } else {
	        	rvt.add(col);
	        }
		}
		rv.addAll(rvt);
		return rv;
	}
	public  String sqlFormat(String sql, boolean leftComma, boolean lHtml) {
        //TGSqlParser sqlparser = new TGSqlParser(EDbVendor.dbvoracle);
        TGSqlParser sqlparser = new TGSqlParser(EDbVendor.dbvmssql);
        sqlparser.sqltext = sql;
        String result;
        int ret = sqlparser.parse();
        if (ret == 0) {
            	GFmtOpt gFmtOpt = GFmtOptFactory.newInstance();
            // umcomment next line generate formatted sql in html
            
            		gFmtOpt.outputFmt =  GOutputFmt.ofSql;
            	if(lHtml) {
            		//option.outputFmt =  GOutputFmt.ofhtml;
            		//gFmtOpt.outputFmt =  GOutputFmt.ofSql;
            	} else {

            		//gFmtOpt.outputFmt =  GOutputFmt.ofSql;
            	}
            	gFmtOpt.tabSize = 4;
            	gFmtOpt.caseFuncname = TCaseOption.CoLowercase;
            	gFmtOpt.caseIdentifier = TCaseOption.CoUppercase;
            	gFmtOpt.selectColumnlistStyle = TAlignStyle.AsStacked;
            	gFmtOpt.insertColumnlistStyle = TAlignStyle.AsStacked;
            	gFmtOpt.defaultCommaOption = TLinefeedsCommaOption.LfbeforeCommaWithSpace;
              /*
              if(leftComma) {
            	  gFmtOpt.selectColumnlistComma = TLinefeedsCommaOption.LfBeforeComma;
            	  gFmtOpt.defaultCommaOption = TLinefeedsCommaOption.LfBeforeComma;
              } else {
            	  gFmtOpt.defaultCommaOption = TLinefeedsCommaOption.LfAfterComma;
              }
              */
               result = FormatterFactory.pp(sqlparser, gFmtOpt);
        } else {
            result ="SQL Formatter >> " + sqlparser.getErrormessage() + "\n Source SQL is " + sql;
        }
        return result;
    }
}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <jsp:include page="commonHeader.jsp" />
	<TITLE>System Status</TITLE>
<style type="text/css">
	body,td {
		font-family: "Verdana", "Arial", "sans-serif";
		font-size: 12px;
	}
	
	.tdblue {
		background-color: #0000ff;
		color: #ffffff;
		text-align: center;
	}
	
	.tdred {
		background-color: #ff0000;
		color: #ffffff;
		text-align: center;
	}

	textarea {
		margin: 0;
		padding: 0;
		font-family: Verdana, Trebuchet MS, Tahoma, Verdana, Arial, sans-serif;
		font-size: 12px;
		height: 100%;
	}
</style>
</head>
<body>
	<script>
		$(function() {
			$("#tabs").tabs();
		});
	</script>
	
	<form>
	<div id="tabs" style="height:100%;">
		<ul>
			<li><a href="#tabs-sqlInsert">SQL-Insert</a></li>
			<li><a href="#tabs-sqlUpdate">SQL-Update</a></li>
			<li><a href="#tabs-excelUpload">Excel Upload</a></li>
			<li><a href="#tabs-Properties">Properties</a></li>
		</ul>

	
	<div id="tabs-sqlUpdate">
		<c:if test="${!empty sqlUpdate }" >
			<textarea cols="132" rows="30">${sqlUpdate }</textarea>	
			<br/>	
			${sqlUpdateH }
		</c:if>	
	</div>	
	<div id="tabs-sqlInsert">
		<c:if test="${!empty sqlInsert }" >
			<textarea cols="132" rows="30">${sqlInsert }</textarea>	
			
		</c:if>
	</div>
	<div id="tabs-excelUpload">		
		<textarea cols="132" rows="30">
&lt;sheet&gt;
		&lt;field col="0" name="No" title="No" type="int" check="true"  &gt;
			&lt;comments&gt;	
				Excel Line No (If this cell is empty rest below rows are not loaded).
			&lt;/comments&gt;
			&lt;samples&gt;
					1
					2
					3
			&lt;/samples&gt;
		&lt;/field>
		<c:forEach var="col" items="${cols }">
		&lt;field col="1" name="${t:toCamelCase(col.name) }" title="${col.comments }" type="${col.excelType }" &gt;
			&lt;comments&gt;	
			&lt;/comments&gt;
			&lt;samples&gt;
				<c:forEach var="rec" items="${samples }" >
				&lt;sample&gt;<c:out value="${rec[col.name] }" />&lt;/sample&gt;	 </c:forEach>	
			&lt;/samples&gt;
		&lt;/field&gt;	</c:forEach>
&lt;/sheet&gt;
		</textarea>	
		</div>
		<div id="tabs-Properties">
		<textarea cols="132" rows="30">
<c:if test="${!empty cols }" >### ${param.tableName } </c:if>		
		<c:forEach var="col" items="${cols }">
cm.${fn:toLowerCase(param.tableName) }.${t:toCamelCase(col.name) }=${col.comments }		</c:forEach>
		</textarea>
	</div>
	</div>
	</form>

</body>
</html>