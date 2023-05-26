<%@page language="java" contentType="text/html; charset=utf-8"%>
<!DOCTYPE html  >
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />

<link rel="stylesheet" type="text/css" href='<c:url value="/extjs/resources/Z_temp4.22/index.css" />' />
<script type="text/javascript" charset="UTF-8" src='<c:url value="/extjs/ext-all-debug.js" />'></script>

<script type="text/javascript">
	Ext.require('*');
	Ext.onReady(function() {
		var panel = Ext.create('Ext.Panel', { 
			id: 'main-panel',  
			width: '500px',
			renderTo: Ext.getBody(),
			layout: { type: 'vbox' ,
		        align: 'stretch'},
			// applied to child components
			defaults: {height : 100 },
			
			items: [ 
		         	{ title: 'Item 1-1', flex: 1}, 
		         	{ title: 'Item 1-2', flex: 1 }, 
		         	{ title: 'Item 1-3', flex: 1}
		     ] });
	}); // onready
</script>
</head>
<body>
</body>
</html>