<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="foren.unilite.com.service.*"%>
<%@ page import="foren.framework.lib.tree.*" %>
<%@ page import="foren.unilite.com.menu.*" %>
<%@ page import="foren.framework.utils.*" %>
<html>
<head>
<title>Menu</title>
<script type="text/javascript" charset="utf-8" src="<c:url value='/resources/js/jquery/jquery-1.6.2.js' />"></script>

<script>
/*
$(document).ready(function() {
	$("#menu_fg").change(function(){
		 var result = $(this).val();
		 window.location="?menu_fg="+result;  
	});
});
*/
</script>
<style>
	body, table{
		font-size: 12px;
		border:0;margin:0;padding:0;
	}
	#menuList  td{
		background: #efefef;
		
	}
	#menuList  th{
		background: #e0e0e0;		
	}
	a, a:link, a:active, a:visited{text-decoration:underline;color:#595858;}
	a:hover,a:focus{text-decoration:underline;color:#595858;}


</style>
</head>
<body>


<%
	//String menu_fg = "4020_FRT";
	String menu_fg = ObjUtils.nvl(request.getParameter("menu_fg"),"MASTER");
	List<GenericTreeNode<MenuItemModel>> list = null;
	TlabMenuService menuService = (TlabMenuService) ObjUtils.getBean(TlabMenuService.MENU_SERVICE_BEAN_ID);
	menuService.reload();
	
	String[] menu_fgs = {"MASTER"};//TlabMenuService.MENU_FGS;
	
	//MenuTree menuTree = menuService.getMenuTree(menu_fg);
	MenuTree menuTree = menuService.getMenuTree("MASTER");
	
	if(menuTree != null)  {
		 list = menuTree.toList();
	}
	request.setAttribute("list", list );
	
	request.setAttribute("menu_fgs", menu_fgs);
	request.setAttribute("menu_fg", menu_fg);
	
	String s_url=request.getParameter("s_url");
	
	if (s_url != null ) {
	    request.setAttribute("prgrm", menuTree.getProgramInfoNodeByURI(s_url));
	}
%>
<br/>
<form method="get">
URL : <input type="text" name="s_url" value="${param.s_url }"  /><br/>
[${prgrm.data.menuID }]
Sub Site : <select name="menu_fg" id="menu_fg">
	<option>==Site==</option> 
<c:forEach var="item" items="${menu_fgs }" >
	<option value="${item }" <c:if test="${item == menu_fg }">selected</c:if> >${item }</option>
</c:forEach>
	</select>	
	<input type="submit" value="조회"/>
</form>
<c:if test="${list eq null }">
List is null !!!
</c:if>
<c:if test="${list ne null }">
<c:out value="${fn:length(list) }" />
</c:if>
<table id="menuList" cellspacing="1" border="0" cellpadding="2"> 
	<thead>
	<tr>
		<th>#</th>
		<th>Level</th>
		<th>Menu No</th>
		<th>program_name</th>
		<th>auth</th>
		<th>menu_nm</th>
		<th>url</th>
		<th>check yn</th>
		<th>view yn</th>
		<th>Master URL</th>
	</tr>
	</thead>
	<tbody>
	<c:forEach var="item" items="${list}" varStatus="status">
		<tr>
			<td align="center"><c:out value="${status.count }"/></td>
			<td align="center"><c:out value="${item.data.level}"/></td>
			<td align="right"><c:out value="${item.data.menuID}"/></td>
			<td>${t:repeat('&nbsp;', (item.data.level-1)*2)}<c:out value="${item.data.programID}"/></td>
			<td align="left">${item.data.authList}</td>

			
			<td nowrap="nowrap">${t:repeat('&nbsp;', (item.data.level-1)*3)} -<c:choose>
				<c:when test="${!empty item.data.url}">
					<c:url var="url" value="${item.data.linkUrl}"/>
					<a href="${url}" target="PRG"><c:out value="${item.data.menuName }"/></a>
				</c:when>
				<c:otherwise>
					<c:out value="${item.data.menuName }"/>
				</c:otherwise>					
				</c:choose>				
			</td>
			<td>${item.data.url}</td>
			<td align="center">${item.data.checkYN}</td>
			<td align="center">${item.data.viewYN}</td>
			<td><c:out value="${item.data.masterUrl }"/></td>
			
		</tr>

	</c:forEach>
	</tbody>
</table>

</body>