<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"  isErrorPage="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Unilite</title>

<script language="javascript">
var isErrorPage=true;
function fncGoAfterErrorPage(){
    history.back(-1);
}
</script>
</head>

<body style="background-color:#0B3358;color:#FFF;'">

<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td align="center" valign="top">
			<br />
			<br />
		    <br />
		    <br />
		    <br />
			<table width="600" border="0" cellpadding="0" cellspacing="0" >
				<tr>
					<td align="center">
						<table width="100%" border="0" cellspacing="9" cellpadding="0">
							<tr>
								<td>
									<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td align="left">&nbsp;</td>
									</tr>
									<tr>
										<td><br/><br/><br/></td>
									</tr>
									<tr>
										<td><img src="<c:url value='/resources/css/theme_01/logo.png' />"/></td>
									</tr>
									<tr>
										<td align="center"><table width="520" border="0" cellspacing="2" cellpadding="2">
									<tr>
										<td align="center"><span style="font-size:82pt;"><strong>404</strong></span></td>
									</tr>
									<tr>
										<td align="center" ><hr/></td>
									</tr>
									<tr>
										<td align="center" >Page Not Found</td>
									</tr>
									</table>
			  					</td>
			  				</tr>
			  				<tr>
			    				<td><br/><br/></td>
			  				</tr>
			  				<tr>
			    				<td align="center"><a href="javascript:fncGoAfterErrorPage();"><span style="color:#FFF;">Back</span></a></td>
			  				</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</body>
</html>
