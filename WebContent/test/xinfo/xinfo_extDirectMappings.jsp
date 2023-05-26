<%@page language="java" contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@page import="java.util.*"%>
<%@page import="ch.ralscha.extdirectspring.controller.*"%>
<%@page import="ch.ralscha.extdirectspring.util.*"%>
<%@page import="foren.framework.utils.*"%>

<style>
.list_panel {
	width: 100%;
	border-top: 1px solid #ccc;
}

.list_panel  th {
	border-right: 1px solid #ccc;
	border-bottom: 1px solid #ccc;
	padding: 4px;
	background-color: #829FC1;
	color: #fff;
}

.list_panel  td {
	border-right: 1px solid #ccc;
	border-bottom: 1px solid #ccc;
	padding: 4px;
	background-color: #fff;
}
</style>
<%	
	List<Map<String, Object>> apiList = new ArrayList<Map<String, Object>>();
	RouterController routerController = (RouterController) ObjUtils.getBean("routerController");
	Configuration configuration = routerController.getConfiguration();
	for (Map.Entry<MethodInfoCache.Key, MethodInfo> entry : MethodInfoCache.INSTANCE) {
		MethodInfo methodInfo = entry.getValue();
		Map<String, Object> rec = new HashMap<String, Object>();
		rec.put("type",methodInfo.getType());
		rec.put("group",methodInfo.getGroup());
		rec.put("needsModifyAuth",methodInfo.needsModifyAuth());
		rec.put("needsDownloadAuth",methodInfo.needsDownloadAuth());
		String action = entry.getKey().getBeanName();
		rec.put("name",action);
		rec.put("programID",action.substring(0,action.indexOf("Service")));
		if (methodInfo.getAction() != null) {
			rec.put("action", methodInfo.getAction());
		}
		apiList.add(rec);
	}
	Collections.sort(apiList, new Comparator<Map<String, Object>>() {

        public int compare(Map<String, Object> o1, Map<String, Object> o2) {
            int rv = 0;
            rv = o1.get("group").toString().compareTo(o2.get("group").toString());
            if(rv == 0) {
            	rv = o1.get("name").toString().compareTo(o2.get("name").toString());
            }
            return rv;
        }
        
    });
	request.setAttribute("apiList", apiList);
%>
<table class="list_panel">
	<thead>
		<tr>
			<th>#</th>
			<th>group</th>
			<th>program ID</th>
			<th>service</th>
			<th>action.method</th>
			<th>Type</th>
			<th>NeedModifyAuth</th>
			<th>needsDownloadAuth</th>
			<th>param length</th>
		</tr>
	</thead>
	<tbody>
	<c:forEach var="item" items="${apiList }" varStatus="status">
		<tr>
			<td>${status.count}</td>
			<td><c:out value="${item.group }" /></td>
			<td>${item.programID }</td>
			<td>${item.name }</td>
			<td>${item.name }.${item.action.name }</td>
			<td><c:out value="${item.type }" /></td>
			<td>${item.needsModifyAuth }</td>
			<td>${item.needsDownloadAuth }</td>
			<td>${item.action.len }</td>
		</tr>
	</c:forEach>
	</tbody>
</table>