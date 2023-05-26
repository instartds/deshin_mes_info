<%@page language="java" contentType="text/html; charset=utf-8"%>
<%@page import="foren.framework.utils.*"%>
<%@page import="java.util.*"%>
<%@ page import="foren.unilite.com.service.TlabDbAdminService"%>
<%
    //@page import="org.eclipse.datatools.modelbase.sql.query.util.*"
%>
<%
	TlabDbAdminService commonService = (TlabDbAdminService) ObjUtils.getBean("UnipassDbAdminService");
    String owner = "TRA_CM";
    Map param = new HashMap();
    param.put("owner", owner);

    List<Map> tableList = commonService.getTablelList(param);
    request.setAttribute("tableList", tableList);
    String tableName = request.getParameter("tableName");
    List<Map<String, Object>> cols = null;
    if (!ObjUtils.isEmpty(tableName)) {
        param.put("tableName", tableName);
        cols = commonService.getColumnList(param);
        request.setAttribute("cols", cols);
    }
	
	if(cols != null) {
	    StringBuffer sqlUpdate = new StringBuffer();
	    sqlUpdate.append("UPDATE " + tableName + " SET ");
	    int cnt = 0;
	    Map<String, String> pks = new HashMap<String, String>();
	    for(Map<String,Object> col : cols) {
	        if(cnt++ > 0) {
	            sqlUpdate.append(",");
	        }
	    	sqlUpdate.append(col.get("name") + " = #" + GStringUtils.toCamelCase((String)col.get("name")) +"#");
	    	if(!ObjUtils.isEmpty(col.get("pk"))) {
	    	    pks.put((String)col.get("name"), GStringUtils.toCamelCase((String)col.get("name")));
	    	}
	    }
	    if(!pks.isEmpty()) {
	        sqlUpdate.append(" WHERE ");
	        Set<String> keys = pks.keySet();
	        cnt = 0;
	        for(String key : keys) {
	            if(cnt++ > 0) {
		            sqlUpdate.append(" AND ");
		        }
	            sqlUpdate.append(key + " = #" + pks.get(key) + "# ");
	        }
	    }
	    request.setAttribute("sqlUpdate", GStringUtils.sqlFormat(sqlUpdate.toString()));
	    
	    
	    StringBuffer sqlInsert = new StringBuffer();
	    sqlInsert.append("INSERT INTO " + tableName + " ( ");
	     cnt = 0;
	    for(Map<String,Object> col : cols) {
	        if(cnt++ > 0) {
	            sqlInsert.append(",");
	        }
	        sqlInsert.append(col.get("name"));
	    }
	    sqlInsert.append(") VALUES (");
	    cnt = 0;
	    for(Map<String,Object> col : cols) {
	        if(cnt++ > 0) {
	            sqlInsert.append(",");
	        }
	        sqlInsert.append(" #" + GStringUtils.toCamelCase((String)col.get("name")) +"#");
	    	
	    }
	    sqlInsert.append(")");
	   
	    request.setAttribute("sqlInsert", GStringUtils.sqlFormat(sqlInsert.toString()));
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<TITLE>Table Info</TITLE>
</head>
<body>
	<form>
		<label>Table : <select name="tableName" ><c:forEach
					var="table" items="${tableList }">
					<option value="${table.name }" ${(table.name eq param.tableName)?'selected':'' }>${table.name } :	${table.comments }</option>
				</c:forEach></select></label> <input type="submit" /><br />
		<textarea cols="132" rows="10">
<c:if test="${!empty cols }" >### ${param.tableName } </c:if>		
		<c:forEach var="col" items="${cols }">
cm.${fn:toLowerCase(param.tableName) }.${tl:toCamelCase(col.name) }=${col.comments }		</c:forEach>
		</textarea>
		<c:if test="${!empty sqlUpdate }" >
			<textarea cols="132" rows="10">${sqlUpdate }</textarea>		
		</c:if>		
				<c:if test="${!empty sqlInsert }" >
			<textarea cols="132" rows="10">${sqlInsert }</textarea>		
		</c:if>		
	</form>

</body>
</html>