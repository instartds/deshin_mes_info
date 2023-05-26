<%@page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="foren.framework.utils.*"%>
<%@ page import="java.util.*"%>
<%@ page import="foren.unilite.com.service.TlabDbAdminService"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<TITLE>Table Index Info</TITLE>
<style id="GLS-ID-11 테이블설계서 V0.3_22544_Styles">
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
	text-align: center;
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
		<col class=xl9022544 width=60 style='mso-width-source: userset; mso-width-alt: 1223; width: 60pt'>
		<col class=xl9022544 width=60 style='mso-width-source: userset; mso-width-alt: 2503; width: 60pt'>
		<col class=xl9022544 width=150 style='mso-width-source: userset; mso-width-alt: 1422; width: 150pt'>
		<col class=xl9022544 width=125 style='mso-width-source: userset; mso-width-alt: 4380; width: 125pt'>
		<col class=xl9022544 width=124 style='mso-width-source: userset; mso-width-alt: 3527; width: 124pt'>
		<col class=xl9022544 width=80 style='mso-width-source: userset; mso-width-alt: 3527; width: 80pt'>
		<tr height=18 style='mso-height-source: userset; height: 14.1pt'>
			<td colspan=6 class=xl8929578 >인덱스 정의서</td>
		</tr>
		<%
			TlabDbAdminService commonService = (TlabDbAdminService) ObjUtils.getBean("TraDbAdminService");
					String owner = "GLS";
				    Map param = new HashMap();
				    param.put("owner",owner);

				    List<Map> list = commonService.getIdxTablelList(owner);
				    for (Map rec : list) {
		%>

		<tr height=18 style='mso-height-source: userset; height: 14.1pt'>
			<td colspan=2 class=xl8522544>시스템명</td>
			<td class=xl9222544 style='border-left: none'><%=ObjUtils.nvl(rec.get("sub_system"), "&nbsp;") %></td>
			<td class=xl8522544 style=' border-left: none'>작성자</td>
			<td colspan=2 class=xl8922544 style='border-left: none'><%=ObjUtils.nvl(rec.get("writer"), "&nbsp;") %></td>
		</tr>
		<tr height=18 style='mso-height-source: userset; height: 14.1pt'>
			<td colspan=2 class=xl8522544>테이블명</td>
			<td  class=xl8922544 style='border-left: none'><%=rec.get("name")%></td>
			<td class=xl8522544 style='border-top: none; border-left: none'>인덱스명</td>
			<td colspan=2 class=xl8922544 style='border-left: none'><%=ObjUtils.nvl(rec.get("index_name"), "&nbsp;")%></td>
		</tr>
		<tr height=18 style='mso-height-source: userset; height: 14.1pt'>
			<td class=xl8622544 style='border-top: none'>번호</td>
			<td colspan=2 class=xl8622544 style='border-left: none'>컬럼명</td>
			<td class=xl8622544 style='border-top: none; border-left: none'>UNIQUNESS</td>
			<td class=xl8622544 style='border-top: none; border-left: none'>TYPE</td>
			<td class=xl8622544 style='border-top: none; border-left: none'>NULL</td>
		</tr>
		<%
		    param.put("tableName", rec.get("name"));
		        List<Map<String, Object>> cols = commonService
		                .getIdxColumnList(param);
		        for (Map col : cols) {
		%>

		<tr height=18 style='mso-height-source: userset; height: 14.1pt'>
			<td class=xl8722544 style='border-top: none'><%=col.get("column_position")%></td>
			<td colspan="2" class=xl9122544 style='border-top: none; border-left: none' ><%=col.get("column_name")%></td>
			<td class=xl9122544 style='border-top: none; border-left: none' align='center'><%=col.get("uniqueness")%></td>
			<td class=xl9122544 style='border-top: none; border-left: none' align='center'><%=col.get("data_type")%>(<%=col.get("column_length")%>)</td>
			<td class=xl9122544 style='border-top: none; border-left: none' align='center'><%=("N".equals(col.get("nullable")) ? "Not Null"
                            : "Null")%></td>

		</tr>

		<%
		    }
		%>
		<tr>
			<td colspan="6">&nbsp;</td>
		</tr>
		<%
		    }
		%>
	</table>
</body>
</html>