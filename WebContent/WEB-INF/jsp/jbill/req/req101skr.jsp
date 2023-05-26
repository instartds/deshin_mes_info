<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
//http://accnt.joins.net/jbill/req/req101skr.do?COMP_CODE=F20&KEY_VALUE=F201020161209020939890018
%>
<meta name="decorator" content="jbill_gw"/>
<script type="text/javascript" >
document.title = "전자결재 - 결재 문서 VIEW";
var MANUAL_YN ='N';
var PGM_ID = "req101skr";
function appMain() {
     Ext.create('Ext.Viewport',  {
     	xtype:'container',
        title : '상세정보',
        defaults:{
            collapsible: false
        },
    	items:[
    		{xtype:'component', itemId:'htmlItem', html:Ext.String.htmlDecode("${htmlData}")}
    	],
    	renderTo : Ext.getBody()
    });
}  
</script>