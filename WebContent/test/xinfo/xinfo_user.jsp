<%@page language="java" contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ page import="java.util.*"%>
<%@ page import="java.net.*"%>
<%@ page import="foren.framework.model.*"%>
<%
	String className = request.getParameter("class_name");
	if (className != null ) {
		try {
			//Class cls =	getClass().getResource(className).getClass();
			Class cls = Class.forName(className);
			JarFinder jf = new JarFinder(); 
			out.print("Jar File : [ " + jf.getCodeSource(cls) + " ] ") ;
			//File jarFile = new File(cls.getProtectionDomain().getCodeSource().getLocation().toURI());
			//out.print("Jar File : [ " + jarFile.getAbsolutePath() + " ]") ;
		} catch (Exception e) {
			out.print("Jar find Error : " + e.getMessage() );
		}
	}
%>
<%!
public class JarFinder {
/**
* Method returns code source of given class.
* This is URL of classpath folder, zip or jar file.
* If code source is unknown, returns null (for example, for classes java.io.*).
*
* @param clazz    For example, java.sql.SQLException.class
* @return for example, "file:/C:/jdev10/jdev/mywork/classes/"
*                             or "file:/C:/works/projects/classes12.zip"
*/

	public  String getCodeSource(Class clazz)
	{
	if (clazz == null ||
	    clazz.getProtectionDomain() == null ||
	    clazz.getProtectionDomain().getCodeSource() == null ||
	    clazz.getProtectionDomain().getCodeSource().getLocation() == null)
	
	   // This typically happens for system classloader
	   // (java.lang.* etc. classes)
	   return null;
	
		return clazz.getProtectionDomain()
	         .getCodeSource().getLocation().toString();
	}
}
 %>
<br />
<form>
	<label> Class Name to find jar : <input name="class_name" value="${param.class_name }" size="100" /> </label> <input type="submit" />
</form>
tl:hasRole(loginVO, 'CUO')= [${t:hasRole(pageContext, 'CUO') }] <br/>
tl:hasRole(loginVO, 'CUOX') = [${t:hasRole(pageContext, 'CUOX') }] <br/>
CPATH =[<c:out value="${CPATH }" />]<br/>
cur_dr = [<c:out value="${cur_dt }" />]<br />
hdate = [<sbt:out value="${cur_dt }" format="hdate" />]<br />
JASPER_IMAGE_PATH = [<%=foren.framework.context.FwContext.getRealPath("/WEB-INF/report/image/")%>]<br/>
Current JSP Spec = [
<c:out value="JSP 1.2" />
, ${'JSP 2.0'} ] (${(0mod 5)}) (${(1mod 5)}) (${(2mod 5)}) (${(3mod 5)}) (${(4mod 5)}) (${(5mod 5)}) (${(6mod 5)})
<%
out.println("<h3>- Session Informations -</h3>");
out.println("<table border=\"0\" cellpadding=\"5\">");

out.println("<tr><td bgcolor=\"#B0E2FF\">Session ID</td><td>");
out.println(session.getId() + "</td></tr>");
out.println("<tr><td bgcolor=\"#B0E2FF\">Creation Time</td><td>");
out.println(new Date(session.getCreationTime()) + "</td></tr>");
out.println("<tr><td bgcolor=\"#B0E2FF\">Last Access Time</td><td>");
out.println(new Date(session.getLastAccessedTime()) + "</td></tr>");
out.println("<tr><td bgcolor=\"#B0E2FF\">is New</td><td>");
out.println(session.isNew() + "</td></tr>");
out.println("<tr><td bgcolor=\"#B0E2FF\">Max Inactive Interval(Time out seconds)</td><td>");
out.println(session.getMaxInactiveInterval() + "</td></tr>");
String inactiveTime = request.getParameter("inactive");
try {
	int interval = Integer.parseInt(inactiveTime);
	if (interval != session.getMaxInactiveInterval()) {
			session.setMaxInactiveInterval(interval);
			out.println("<tr><td bgcolor=\"#B0E2FF\">New Max Inactive Interval</td><td>");
			out.println(session.getMaxInactiveInterval() + "</td></tr>");
	}
} catch (NumberFormatException nfe) {
}

StringBuffer reqUrl= request.getRequestURL(); 
URL url = new URL(reqUrl.toString());
request.setAttribute("URL", url);
out.println("</table>");
%>
URL : protocol : ${URL.protocol}<br/>
URL : host : ${URL.host}<br/>
URL : port : ${URL.port}<br/>
URL : context : ${pageContext.request.contextPath}
<table width="800" border="1" cellpadding="2" cellspacing="0">
	<tr>
		<th>param</th>
		<th>values</th>
	</tr>
	<tr>
		<td>pageContext.request.contextPath</td>
		<td><c:out value="${pageContext.request.contextPath}" /></td>
	</tr>
	<tr>
		<td>pageContext.request</td>
		<td><c:out value="${pageContext.request}" /></td>
	</tr>
	<tr>
		<td>pageContext.request.getServerName</td>
		<td><c:out value="${pageContext.request.serverName}" /></td>
	</tr>
	<tr>
		<td>pageContext.request.getServerPort</td>
		<td><c:out value="${pageContext.request.serverPort}" /></td>
	</tr>
	<tr>
		<td>pageContext.request.getRequestURI</td>
		<td><c:out value="${pageContext.request.requestURI}" /></td>
	</tr>
	<tr>
		<td>pageContext.request.servletPath</td>
		<td><c:out value="${pageContext.request.servletPath}" /></td>
	</tr>
	<tr>
		<td>pageContext.request.pathInfo</td>
		<td><c:out value="${pageContext.request.pathInfo}" /></td>
	</tr>
	<tr>
		<td>pageContext.request.method</td>
		<td><c:out value="${pageContext.request.method}" /></td>
	</tr>
	<tr>
		<td>pageContext.request.requestURL</td>
		<td><c:out value="${pageContext.request.requestURL}" /></td>
	</tr>
	<tr>
		<td>pageContext.request.queryString</td>
		<td><c:out value="${pageContext.request.queryString}" /></td>
	</tr>
	<tr>
		<td>pageContext.request.remoteAddr</td>
		<td><c:out value="${pageContext.request.remoteAddr}" /></td>
	</tr>
	<tr>
		<td>pageContext.request.requestedSessionId</td>
		<td><c:out value="${pageContext.request.cookies[0].name}" />
		</td>
	</tr>
	<tr>
		<td>pageContext.response</td>
		<td><c:out value="${pageContext.response}" />
		</td>
	</tr>	
	<tr>
		<td>KEY_MENU_NODE</td>
		<td><c:out value="${KEY_MENU_NODE}" />
		</td>
	</tr>	
	<tr>
		<td>FRAMEWORK_SPRING_CURRENT_URI</td>
		<td><c:out value="${FRAMEWORK_SPRING_CURRENT_URI}" />
		</td>
	</tr>		

	<tr>
		<td colspan="2">
			<h3>Parameter info:</h3>
		</td>
	</tr>

	<c:forEach var="aKey" items="${paramValues}">
		<tr>
			<td><c:out value="${aKey.key}" /></td>
			<td><c:forEach var="val" items="${aKey.value}">
					[<c:out value="${val}" />]<br />
				</c:forEach></td>
		</tr>
	</c:forEach>
	<tr>
		<td colspan="2">
			<h3>Header info:</h3>
		</td>
	</tr>
	<c:forEach var="aKey" items="${headerValues}">
		<tr>
			<td><c:out value="${aKey.key}" /></td>
			<td><c:forEach var="val" items="${aKey.value}">
		     [<c:out value="${val}" />]<br />
				</c:forEach></td>
		</tr>
	</c:forEach>

	<tr>
		<td colspan="2">
			<h3>cookies:</h3>
		</td>
	</tr>
	<c:forEach var="aKey" items="${pageContext.request.cookies}">
		<tr>
			<td><c:out value="${aKey.name}" /></td>
			<td><c:forEach var="val" items="${aKey.value}">
	     [<c:out value="${val}" />]<br />
				</c:forEach></td>
		</tr>
	</c:forEach>

	<tr>
		<td colspan="2">
			<h3>sessionScope:</h3>
		</td>
	</tr>
	<c:forEach var="aKey" items="${sessionScope}">
		<tr>
			<td><c:out value="${aKey.key}" /></td>
			<td>[<c:out value="${aKey.value}" />] <c:if test="${aKey.key == 'msession'}">
					<br />
				userid = <c:out value="${aKey.value.userid}" /> , nm = <c:out value="${aKey.value.nm}" />
					<br />

				</c:if></td>
		</tr>
	</c:forEach>
	<tr>
		<td colspan="2">
			<h3>requestScope:</h3>
		</td>
	</tr>
	<c:forEach var="aKey" items="${requestScope}">
		<tr>
			<td><c:out value="${aKey.key}" /></td>
			<td>[<c:out value="${aKey.value}" />] </td>
		</tr>
	</c:forEach>	
	<tr>
		<td colspan="2">
			<h3>pageScope:</h3>
		</td>
	</tr>
	<c:forEach var="aKey" items="${pageScope}">
		<tr>
			<td><c:out value="${aKey.key}" /></td>
			<td>[<c:out value="${aKey.value}" />] </td>
		</tr>
	</c:forEach>	
</table>