<%@page language="java" contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@page import="java.util.*"%>
<%@page import="java.net.*"%>
<%@page import="java.io.*"%>
<%@page import="java.text.*"%>
<%
    out.println("<h3>- System Informations -</h3>");
    out.println("<table border=\"0\" cellpadding=\"5\">");

    String getStr = "";
    InetAddress Address = InetAddress.getLocalHost();

    getStr = Address.getHostAddress();
    if (getStr.length() > 0) {
        out.println("<tr><td bgcolor=\"#B0E2FF\">IP Address</td><td>");
        out.println(getStr + "</td></tr>");
    }
    getStr = Address.getHostName();
    if (getStr.length() > 0) {
        out.println("<tr><td bgcolor=\"#B0E2FF\">Host name</td><td>");
        out.println(getStr + "</td></tr>");
    }
    URL url = application.getResource("/test.jsp");
    if (url != null) {
        getStr = url.getPath();
        if (getStr.length() > 0) {
            out.println("<tr><td bgcolor=\"#B0E2FF\">Test JSP Path</td><td>");
            out.println(getStr + "</td></tr>");
        }
    }

    out.println("<tr><td bgcolor=\"#B0E2FF\">Server Info</td><td>");
    out.println(application.getServerInfo() + "</td></tr>");
    out.println("<tr><td bgcolor=\"#B0E2FF\">Servlet/JSP version</td><td>");
    out.println(application.getMajorVersion() + "."
            + application.getMinorVersion() + "</td></tr>");
    SimpleDateFormat fmt = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    String time = fmt.format(new java.util.Date());
    out.println("<tr><td bgcolor=\"#B0E2FF\">Current system time</td><td>");
    out.println(time + "</td></tr>");
    out.println("<tr><td bgcolor=\"#B0E2FF\">Free Mem / total</td><td>");
    DecimalFormat f = (DecimalFormat) NumberFormat.getInstance();
    f.setDecimalSeparatorAlwaysShown(false);
    f.applyPattern("#,##0");
    int t = 1024 * 1024;
	Runtime rt = Runtime.getRuntime();
	long free = rt.freeMemory();
	long total = rt.totalMemory();
	long usedRatio = (total - free) * 100 / total;
    out.println(f.format(free / t) + "/" + f.format(total / t)
            + " MB (" + usedRatio + "%)</td></tr>");
    out.println("</table>");
%>

<table border="1">
	<thead>
		<tr>
			<th>key</th>
			<th>value</th>
		</tr>
	</thead>
	<tbody>
		<%
		    try {
		        java.util.Hashtable ht = System.getProperties();
		        java.util.Enumeration enu = ht.keys();
		        Object key = null;
		        while (enu.hasMoreElements()) {
		            key = enu.nextElement();
		            out.println("<tr>");
		            out.println("<td>" + key + "</td>");
		            out.println("<td>"
		                    + ht.get(key).toString().replace(":/", "<br/>/")
		                            .replace(";", "<br/>")
		                            .replace(",", "<br/>") + "</td>");
		            out.println("</tr>");
		        }
		    } catch (Exception e) {
		        System.err.println("Exception:[" + e.toString() + "]");
		    }
		%>
	</tbody>
</table>