<%@ tag pageEncoding="UTF-8" %>
<%@ tag import="java.util.*"%>
<%@ tag import="foren.unilite.com.service.impl.*" %>
<%@ tag import="foren.framework.utils.*" %>
<%@ tag import="foren.unilite.com.menu.*" %>
<%@ attribute name="pgmId"  required="true"%>
<%@ attribute name="shape"  required="true"%>
<%@ attribute name="coords"  required="true"%>
<%
	String pgmId =  (String) jspContext.getAttribute("pgmId");
	TlabMenuService tlabMenuService = (TlabMenuService) ObjUtils.getBean(TlabMenuService.MENU_SERVICE_BEAN_ID);
	MenuNode menuNode = tlabMenuService.getMenuTree("MASTER").getNodeByMenuID(pgmId);
	request.setAttribute("T_PGMID", pgmId);
	if(menuNode != null) {
		MenuItemModel  mi = menuNode.getData();
		request.setAttribute("T_PGMNAME", " >> ["+pgmId+"] " + mi.getMenuName()); 
		request.setAttribute("T_MENUNODE", mi); 
		request.setAttribute("T_URL", mi.getLinkUrl()); 
	}
%>
<area shape="${shape }" coords="${coords }" alt="${T_PGMNAME }" title="${T_PGMNAME }"  href="javascript:openTab('${T_PGMID }', '${T_URL }')"  />
