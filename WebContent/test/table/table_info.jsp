<% //@page language="java" contentType="text/html; charset=utf-8"%>
<%@page language="java" contentType="application/octet-stream; charset=utf-8"%>
<%@page import="foren.framework.utils.*"%>
<%@page import="java.util.*"%>
<%@ page import="foren.unilite.com.service.TlabDbAdminService"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<TITLE>Table Info</TITLE>
<style id="테이블설계서 V0.3_22544_Styles">
<!--
table {
	mso-displayed-decimal-separator: "\.";
	mso-displayed-thousand-separator: "\,";
}

.font522544 {
	color: windowtext;
	font-size: 8.0pt;
	font-weight: 400;
	font-style: normal;
	text-decoration: none;
	font-family: 돋움, monospace;
	mso-font-charset: 129;
}

.xl8522544 {
	padding-top: 1px;
	padding-right: 1px;
	padding-left: 1px;
	mso-ignore: padding;
	color: windowtext;
	font-size: 10.0pt;
	font-weight: 400;
	font-style: normal;
	text-decoration: none;
	font-family: "맑은 고딕", monospace;
	mso-font-charset: 129;
	mso-number-format: General;
	text-align: center;
	vertical-align: middle;
	border: .5pt solid windowtext;
	background: silver;
	mso-pattern: black none;
	white-space: nowrap;
}

.xl8622544 {
	padding-top: 1px;
	padding-right: 1px;
	padding-left: 1px;
	mso-ignore: padding;
	color: windowtext;
	font-size: 10.0pt;
	font-weight: 400;
	font-style: normal;
	text-decoration: none;
	font-family: "맑은 고딕", monospace;
	mso-font-charset: 129;
	mso-number-format: General;
	text-align: center;
	vertical-align: middle;
	border: .5pt solid windowtext;
	background: silver;
	mso-pattern: black none;
	white-space: nowrap;
}

.xl8722544 {
	padding-top: 1px;
	padding-right: 1px;
	padding-left: 1px;
	mso-ignore: padding;
	color: windowtext;
	font-size: 10.0pt;
	font-weight: 400;
	font-style: normal;
	text-decoration: none;
	font-family: "맑은 고딕", monospace;
	mso-font-charset: 129;
	mso-number-format: General;
	text-align: center;
	vertical-align: middle;
	border: .5pt solid windowtext;
	mso-background-source: auto;
	mso-pattern: auto;
	white-space: nowrap;
}

.xl8822544 {
	padding-top: 1px;
	padding-right: 1px;
	padding-left: 1px;
	mso-ignore: padding;
	color: windowtext;
	font-size: 10.0pt;
	font-weight: 400;
	font-style: normal;
	text-decoration: none;
	font-family: "맑은 고딕", monospace;
	mso-font-charset: 129;
	mso-number-format: General;
	text-align: center;
	vertical-align: middle;
	border: .5pt solid windowtext;
	mso-background-source: auto;
	mso-pattern: auto;
	white-space: nowrap;
}

.xl8922544 {
	padding-top: 1px;
	padding-right: 1px;
	padding-left: 1px;
	mso-ignore: padding;
	color: windowtext;
	font-size: 10.0pt;
	font-weight: 400;
	font-style: normal;
	text-decoration: none;
	font-family: "맑은 고딕", monospace;
	mso-font-charset: 129;
	mso-number-format: General;
	text-align: center;
	vertical-align: middle;
	border: .5pt solid windowtext;
	mso-background-source: auto;
	mso-pattern: auto;
	white-space: nowrap;
}

.xl9022544 {
	padding-top: 1px;
	padding-right: 1px;
	padding-left: 1px;
	mso-ignore: padding;
	color: windowtext;
	font-size: 10.0pt;
	font-weight: 400;
	font-style: normal;
	text-decoration: none;
	font-family: "맑은 고딕", monospace;
	mso-font-charset: 129;
	mso-number-format: General;
	text-align: left;
	vertical-align: middle;
	mso-background-source: auto;
	mso-pattern: auto;
	white-space: nowrap;
}

.xl9122544 {
	padding-top: 1px;
	padding-right: 1px;
	padding-left: 1px;
	mso-ignore: padding;
	color: black;
	font-size: 10.0pt;
	font-weight: 400;
	font-style: normal;
	text-decoration: none;
	font-family: "맑은 고딕", monospace;
	mso-font-charset: 129;
	mso-number-format: General;
	text-align: general;
	vertical-align: middle;
	border: .5pt solid windowtext;
	mso-background-source: auto;
	mso-pattern: auto;
	white-space: nowrap;
}

.xl9222543 {
	padding-top: 1px;
	padding-right: 1px;
	padding-left: 1px;
	mso-ignore: padding;
	color: windowtext;
	font-size: 12.0pt;
	font-weight: 400;
	font-style: normal;
	text-decoration: none;
	font-family: "맑은 고딕", monospace;
	mso-font-charset: 129;
	mso-number-format: General;
	text-align: center;
	vertical-align: middle;
	border: .5pt solid windowtext;
	mso-background-source: auto;
	mso-pattern: auto;
	white-space: nowrap;
}

.xl9222544 {
	padding-top: 1px;
	padding-right: 1px;
	padding-left: 1px;
	mso-ignore: padding;
	color: windowtext;
	font-size: 12.0pt;
	font-weight: 400;
	font-style: normal;
	text-decoration: none;
	font-family: "맑은 고딕", monospace;
	mso-font-charset: 129;
	mso-number-format: General;
	text-align: left;
	vertical-align: middle;
	border: .5pt solid windowtext;
	mso-background-source: auto;
	mso-pattern: auto;
	white-space: nowrap;
}

.xl9322544 {
	padding-top: 1px;
	padding-right: 1px;
	padding-left: 1px;
	mso-ignore: padding;
	color: windowtext;
	font-size: 12.0pt;
	font-weight: 700;
	font-style: normal;
	text-decoration: none;
	font-family: "맑은 고딕", monospace;
	mso-font-charset: 129;
	mso-number-format: General;
	text-align: center;
	vertical-align: middle;
	border: .5pt solid windowtext;
	background: yellow;
	mso-pattern: black none;
	white-space: nowrap;
}

.xl9422544 {
	padding-top: 1px;
	padding-right: 1px;
	padding-left: 1px;
	mso-ignore: padding;
	color: windowtext;
	font-size: 12.0pt;
	font-weight: 400;
	font-style: normal;
	text-decoration: none;
	font-family: "맑은 고딕", monospace;
	mso-font-charset: 129;
	mso-number-format: General;
	text-align: center;
	vertical-align: middle;
	border: .5pt solid windowtext;
	background: yellow;
	mso-pattern: black none;
	white-space: nowrap;
}

.xl9522544 {
	padding-top: 1px;
	padding-right: 1px;
	padding-left: 1px;
	mso-ignore: padding;
	color: black;
	font-size: 10.0pt;
	font-weight: 400;
	font-style: normal;
	text-decoration: none;
	font-family: "맑은 고딕", monospace;
	mso-font-charset: 129;
	mso-number-format: General;
	text-align: left;
	vertical-align: middle;
	border: .5pt solid windowtext;
	mso-background-source: auto;
	mso-pattern: auto;
	white-space: nowrap;
}

ruby {
	ruby-align: left;
}

rt {
	color: windowtext;
	font-size: 8.0pt;
	font-weight: 400;
	font-style: normal;
	text-decoration: none;
	font-family: 돋움, monospace;
	mso-font-charset: 129;
	mso-char-type: none;
}
-->
</style>
</head>
<body>
		
	<table border=0 cellpadding=0 cellspacing=0 width=1063 class=xl9022544
		style='border-collapse: collapse; table-layout: fixed; width: 799pt'>
		<col class=xl9022544 width=13 style='mso-width-source: userset; mso-width-alt: 223; width: 12pt'>
		<col class=xl9022544 width=43 style='mso-width-source: userset; mso-width-alt: 1223; width: 32pt'>
		<col class=xl9022544 width=88 style='mso-width-source: userset; mso-width-alt: 2503; width: 66pt'>
		<col class=xl9022544 width=50 style='mso-width-source: userset; mso-width-alt: 1422; width: 38pt'>
		<col class=xl9022544 width=154 style='mso-width-source: userset; mso-width-alt: 4380; width: 116pt'>
		<tr height=18 style='mso-height-source: userset; height: 14.1pt'>
			<td class=xl8522544>No</td>
			<td class=xl8522544>System</td>
			<td class=xl8522544>Entity Name</td>
			<td class=xl8522544 style=' border-left: none'>Table Name</td>
			<td class=xl8522544>Description</td>
		</tr>

<%
	TlabDbAdminService commonService = (TlabDbAdminService) ObjUtils.getBean("UnipassDbAdminService");
	String owner = "UNIPASS";
    Map param = new HashMap();
    param.put("owner", owner);
    param.put("prefix", new String[] {"CM_","EX_"});

    List<Map> list = commonService.getTablelList(param);
    int cnt = 0;
    for (Map rec : list) {
%>

		<tr height=18 style='mso-height-source: userset; height: 14.1pt'>
			<td class=xl9222543 style=''><%=++cnt %></td>
			<td class=xl9222543 style=''><%=ObjUtils.nvl(rec.get("subSystem"), "&nbsp;") %></td>
			<td class=xl8922544 style='border-left: none'><%=rec.get("comments")%></td>
			<td class=xl8922544 style='border-left: none'><%=rec.get("name")%></td>
			<td class=xl9222544 style='border-left: none'>
			         <%=ObjUtils.nvl(rec.get("description"), "&nbsp;")%></td>
		</tr>		
		<%
		    }
		%>
		</table>
		
	<table border=0 cellpadding=0 cellspacing=0 width=1063 class=xl9022544
		style='border-collapse: collapse; table-layout: fixed; width: 799pt'>
		<col class=xl9022544 width=43 style='mso-width-source: userset; mso-width-alt: 1223; width: 32pt'>
		<col class=xl9022544 width=88 style='mso-width-source: userset; mso-width-alt: 2503; width: 66pt'>
		<col class=xl9022544 width=50 style='mso-width-source: userset; mso-width-alt: 1422; width: 38pt'>
		<col class=xl9022544 width=154 style='mso-width-source: userset; mso-width-alt: 4380; width: 116pt'>
		<col class=xl9022544 width=124 style='mso-width-source: userset; mso-width-alt: 3527; width: 93pt'>
		<col class=xl9022544 width=83 style='mso-width-source: userset; mso-width-alt: 2360; width: 62pt'>
		<col class=xl9022544 width=79 style='mso-width-source: userset; mso-width-alt: 2247; width: 59pt'>
		<col class=xl9022544 width=34 span=2 style='mso-width-source: userset; mso-width-alt: 967; width: 26pt'>
		<col class=xl9022544 width=249 style='mso-width-source: userset; mso-width-alt: 7082; width: 187pt'>
		<col class=xl9022544 width=99 style='mso-width-source: userset; mso-width-alt: 2816; width: 74pt'>
		<tr height=18 style='mso-height-source: userset; height: 14.1pt'>
			<td colspan=11 class=xl8929578 width=1037 style='width: 779pt'>Table Scheme</td>
		</tr>
		<%


		    list = commonService.getTablelList(param);
		    for (Map rec : list) {
		%>

		<tr height=18 style='mso-height-source: userset; height: 14.1pt'>
			<td colspan=2 class=xl8522544>System</td>
			<td colspan=2 class=xl9222543 style='border-left: none'><%=ObjUtils.nvl(rec.get("subSystem"), "&nbsp;")%></td>
			<td class=xl8522544 style='border-left: none'>Writer</td>
			<td colspan=4 class=xl8922544 style='border-left: none'><%=ObjUtils.nvl(rec.get("writer"), "&nbsp;")%></td>
			<td class=xl8522544 style='border-left: none'>Retention Period</td>
			<td class=xl8922544 style='border-left: none'>5 years</td>
		</tr>
		<tr height=18 style='mso-height-source: userset; height: 14.1pt'>
			<td colspan=2 class=xl8522544>Entity Name</td>
			<td colspan=2 class=xl8922544 style='border-left: none'><%=rec.get("name")%></td>
			<td class=xl8522544 style='border-top: none; border-left: none'>Table Name</td>
			<td colspan=4 class=xl8922544 style='border-left: none'><%=ObjUtils.nvl(rec.get("comments"), "&nbsp;")%></td>
			<td class=xl8522544 style='border-top: none; border-left: none'>TableSpace</td>
			<td class=xl8922544 style='border-top: none; border-left: none'></td>
		</tr>
		<tr height=18 style='mso-height-source: userset; height: 14.1pt'>
			<td colspan=2 class=xl8522544>Description</td>
			<td colspan=9 class=xl9222544 style='border-left: none'><%=ObjUtils.nvl(rec.get("description"), "&nbsp;")%></td>
		</tr>
		<tr height=18 style='mso-height-source: userset; height: 14.1pt'>
			<td class=xl8622544 style='border-top: none'>No.</td>
			<td colspan=2 class=xl8622544 style='border-left: none'>Column Name</td>
			<td class=xl8622544 style='border-top: none; border-left: none'>Column ID</td>
			<td class=xl8622544 style='border-top: none; border-left: none'>TYPE</td>
			<td class=xl8622544 style='border-top: none; border-left: none'>LENGTH</td>
			<td class=xl8622544 style='border-top: none; border-left: none'>NULL</td>
			<td class=xl8622544 style='border-top: none; border-left: none'>PK</td>
			<td class=xl8622544 style='border-top: none; border-left: none'>FK</td>
			<td class=xl8622544 style='border-top: none; border-left: none' colspan="2">Definition</td>
		</tr>
		<%
		    param.put("tableName", rec.get("name"));
		        List<Map<String, Object>> cols = commonService
		                .getColumnList(param);
		        for (Map col : cols) {
		%>

		<tr height=18 style='mso-height-source: userset; height: 14.1pt'>
			<td class=xl8722544 style='border-top: none'><%=col.get("id")%></td>
			<td colspan=2 class=xl9522544 style='border-left: none'><%=col.get("comments")%></td>
			<td class=xl9122544 style='border-top: none; border-left: none'><%=col.get("name")%></td>
			<td class=xl9122544 style='border-top: none; border-left: none' align='center'><%=col.get("type")%></td>
			<td class=xl8822544 style='border-top: none; border-left: none' align='center'><%=col.get("length")%></td>
			<td class=xl9122544 style='border-top: none; border-left: none' align='center'><%=("N".equals(col.get("nullable")) ? "Not Null"
                            : "Null")%></td>
			<td class=xl9122544 style='border-top: none; border-left: none' align='center'><%=ObjUtils.nvl(col.get("pk"), "&nbsp;")%></td>
			<td class=xl9122544 style='border-top: none; border-left: none' align='center'><%="R".equals(col.get("constraint_type")) ? "Yes"
                            : "&nbsp;"%></td>
			<td class=xl8822544 style='border-top: none; border-left: none' colspan="2"><%=ObjUtils.nvl(col.get("description"), "&nbsp;")%></td>

		</tr>

		<%
		    }
		%>
		<tr>
			<td colspan="11">&nbsp;</td>
		</tr>
		<%
		    }
		%>
	</table>
</body>
</html>