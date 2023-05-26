<%@page language="java" contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@page import="foren.framework.utils.*" %>
<%@page import="java.util.*" %>
<%@page import="org.apache.regexp.RE" %>
<%@page import="org.apache.commons.lang.ArrayUtils"%>
<%@page import="gudusoft.gsqlparser.*"%>
<%@page import="gudusoft.gsqlparser.pp.para.*"%>
<%@page import="gudusoft.gsqlparser.pp.para.styleenums.*"%>
<%@page import="gudusoft.gsqlparser.pp.stmtformatter.*"%>
<%!public static class Sql {
        public  static String sqlFormat(String sql) {
            String result="";
            if(sql != null  && sql !="") {
	            TGSqlParser sqlparser = new TGSqlParser(EDbVendor.dbvoracle);
	            sqlparser.sqltext = sql;
	            int ret = sqlparser.parse();
	            if (ret == 0) {
	                GFmtOpt option = GFmtOptFactory.newInstance();
	                option.tabSize = 4;
	                option.caseFuncname = TCaseOption.CoUppercase;
	//                option.caseIdentifier = TCaseOption.CoNoChange;
	                option.caseIdentifier = TCaseOption.CoNoChange;
	                //option.insertColumnlistStyle = TAlignStyle.
	                 option.selectColumnlistComma = TLinefeedsCommaOption.LfAfterComma;
	                        
	
	                result = FormatterFactory.pp(sqlparser, option);
	            } else {
	                result = "SQL Formatter >> " + sqlparser.getErrormessage() + "\n Source SQL is " + sql;
	            }
            }
            return result;
        }
        
        
        public  static String mapper(String sql, List<String> arr) {
            String rv = "";
			if ((sql != null) && (arr != null)) {
	    		
	    		int i = 0;
	    		int idx = 0;
	    		try { 
		    		while (sql.length()>0) {
		    		    idx =sql.indexOf('?');
		    		    if(idx > 0) {
			    			rv = rv + sql.substring(0,idx);
			    			rv = rv + "'" + arr.get(i).trim() + "'";		    			
			    			if(sql.length() > idx ) {
			    				sql = sql.substring( idx + 1);
			    			}
			    			  i++;
		    		    } else {
			    			//rv = rv + ", '" + arr.get(i).trim() + "' ";		 
		    		        rv = rv + sql;
		    		        sql = "";
		    		    }
		    		}
	    		} catch (Exception e) {
	    		    	System.out.println(" >> " + e.getMessage());
	    		}
			}
			return rv;
        }
        
        public static List<String> tokenizer(String source, String deli) {
            if (source == null)
                return null;
            if (deli == null)
                deli = " ";
            int idx = source.indexOf(deli);
            List<String> list = new ArrayList<String>();
            while (idx > -1) {
                String sub = source.substring(0, idx);
                source = source.substring(idx + 1);
                idx = source.indexOf(deli);
                list.add(sub);
            }
            list.add(source);
            return list;
            // String[] result = (String[]) list.toArray(new String[list.size()]);
            // return result;
        }
    }
    
    
    
    %>
<%
		String sql = request.getParameter("sql");
	
		request.setAttribute("sql", Sql.sqlFormat(sql));
		String dataStr = request.getParameter("datas");
		List<String> data = GStringUtils.tokenizer(dataStr,",");
		String rv = Sql.mapper(sql, data);
		rv = rv.replaceAll("'null'","null");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<head>
</head>
<body>
<form method="post">
	<label> SQL: <textarea name="sql" type="text" cols="80" rows="15">${sql }</textarea></label><br/>
	<label> Data: <textarea name="datas" type="text" cols="80" rows="10">${param.datas }</textarea></label>
	<input type="submit" /><br/>
	<%=data %><hr/>
	<pre>
	<%=Sql.sqlFormat(rv )%>
	</pre>
</form>
</body>
</html>