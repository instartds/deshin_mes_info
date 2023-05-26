<%@page language="java" contentType="text/html; charset=utf-8"%>
<%@page import="java.util.*"%>
<%@page import="foren.framework.utils.*"%>
<%@page import="org.apache.commons.lang.ArrayUtils"%>
<%@page import="gudusoft.gsqlparser.*"%>
<%@page import="gudusoft.gsqlparser.pp.para.*"%>
<%@page import="gudusoft.gsqlparser.pp.para.styleenums.*"%>
<%@page import="gudusoft.gsqlparser.pp.stmtformatter.*"%>


<%
    String rawSql = "SELECT PARNTS_ROLE, CHLDRN_ROLE, a, b, c FROM COMTNROLES_HIERARCHY";
	Sql sql = new Sql();
    String formatedSql = sql.sqlFormat(rawSql);
%>
<%!public class Sql {
        public  String sqlFormat(String sql) {
            TGSqlParser sqlparser = new TGSqlParser(EDbVendor.dbvoracle);
            sqlparser.sqltext = sql;
            String result;
            int ret = sqlparser.parse();
            if (ret == 0) {
                GFmtOpt option = GFmtOptFactory.newInstance();
                // umcomment next line generate formatted sql in html
                //option.outputFmt =  GOutputFmt.ofhtml;
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
            return result;
        }
    }%>
<html>
<head>
<title>Sql Format Test</title>
</head>
<body>
	<pre>
<%=formatedSql%>
	</pre>
</body>
</html>