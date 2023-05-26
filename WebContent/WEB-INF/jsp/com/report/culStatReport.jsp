<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
String orgnCd = request.getParameter("orgnCd") == null ? "" : request.getParameter("orgnCd").trim();
String orgnNm = request.getParameter("orgnNm") == null ? "" : request.getParameter("orgnNm").trim();
String year = request.getParameter("year") == null ? "" : request.getParameter("year").trim();
String month = request.getParameter("month") == null ? "" : request.getParameter("month").trim();
%>
<!DOCTYPE html>
<html style="height:100%">
<head>
<title>리포트 저장/출력 - 행정지원시스템</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<script src="/oz/ozhviewer/jquery-1.8.3.min.js"></script>
<link rel="stylesheet" href="/oz/ozhviewer/jquery-ui.css" type="text/css"/>
<script src="/oz/ozhviewer/jquery-ui.min.js"></script>
<link rel="stylesheet" href="/oz/ozhviewer/ui.dynatree.css" type="text/css"/>
<script type="text/javascript" src="/oz/ozhviewer/jquery.dynatree.js" charset="utf-8"></script>
<script type="text/javascript" src="/oz/ozhviewer/OZJSViewer.js" charset="utf-8"></script>
</head>
<body style="width:98%;height:98%">
<div id="OZViewer" style="width:98%;height:98%"></div>
<script type="text/javascript" >
   function SetOZParamters_OZViewer(){

       var oz;
       oz = document.getElementById("OZViewer");
       
       oz.sendToActionScript("connection.servlet","/oz/server");
       oz.sendToActionScript("connection.reportname","culStat.ozr");
       oz.sendToActionScript("odi.odinames","board");
       oz.sendToActionScript("odi.board.pcount","4");
       oz.sendToActionScript("odi.board.args1","param1=<%=orgnCd%>");
       oz.sendToActionScript("odi.board.args2","param2=<%=year%>");
       oz.sendToActionScript("odi.board.args3","param3=<%=month%>");
       oz.sendToActionScript("odi.board.args4","param4=<%=orgnNm%>");
       oz.sendToActionScript("toolbar.parameter","false");
       oz.sendToActionScript("toolbar.etc","false");
       oz.sendToActionScript("toolbar.useseparator","false");
       oz.sendToActionScript("toolbar.option","false");
       oz.sendToActionScript("toolbar.xlsx","true");
       oz.sendToActionScript("toolbar.save","false");
       oz.sendToActionScript("connection.fetchtype","concurrent");
       oz.sendToActionScript("information.debug","true");
      
       return true;

   }
   start_ozjs("OZViewer","/oz/ozhviewer/");
</script>
</body>
</html>
