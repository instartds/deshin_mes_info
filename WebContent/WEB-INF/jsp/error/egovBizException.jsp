<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%
String contextPath = request.getContextPath();
request.setAttribute("CPATH",contextPath);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Error Message(Biz)</title>

<link href="<c:url value='/css/egovframework/com/cmm/com.css' />" rel="stylesheet" type="text/css" />

<script language="javascript">
var isErrorPage=true;
function fncGoAfterErrorPage(){
    history.back(-2);
}
</script>
</head>

<body>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td align="center" valign="top"><br />
    <br />
    <br />
    <table width="600" border="0" cellpadding="0" cellspacing="0" background="${CPATH}/resources/images/error/blue_bg.jpg">
      <tr>
        <td align="center"><table width="100%" border="0" cellspacing="9" cellpadding="0">
          <tr>
            <td bgcolor="#FFFFFF"><table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td align="left"><img src="${CPATH}/resources/images/error/er_logo.jpg" width="379" height="57" alt="에러로고이미지"/></td>
              </tr>
              <tr>
                <td><br />
                  <br /></td>
              </tr>
              <tr>
                <td align="center"><table width="520" border="0" cellspacing="2" cellpadding="2">
                  <tr>
                    <td width="74" rowspan="2" align="center"><img src="${CPATH}/resources/images/error/danger.jpg" width="74" height="74" alt="Warning"/></td>
                    <td width="399" align="left" class="lt_text2">Unknown Error !!! </td>
                  </tr>
                </table>
                  <table width="500" border="0" cellspacing="2" cellpadding="2">
                                  </table></td>
              </tr>
              <tr>
                <td><br />
                  <br /></td>
              </tr>
              <tr>
                <td align="center"><a href="javascript:fncGoAfterErrorPage();"><img src="<c:url value='/resources/images/error/go_history.jpg' />" width="90" height="29" alt="바로가기 버튼이미지"/></a></td>
              </tr>
            </table>
              <br /></td>
          </tr>
        </table></td>
      </tr>
    </table>
    </td>
  </tr>
</table>
</body>
</html>
