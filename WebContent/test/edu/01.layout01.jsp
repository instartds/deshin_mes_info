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
			baseCls: 'x-plain', 
			width: '100%', //'500px'
			renderTo: Ext.getBody(),
			layout: { type: 'table', 
				columns: 3,
				tableAttrs: {
			    	style: {
			        	width: '100%'
			         }
			    }
			    },
			// applied to child components
			defaults: { height: 100 },
			items: [ 
		         	//{ title: 'Item 1-1' }, 
				this.panel_11 = Ext.create('Ext.panel.Panel', {title: 'Item 1-1' }),
		         	{ title: 'Item 1-2' }, 
		         	{ title: 'Item 1-3' },
		         	{ title: 'Item 2-1', colspan: 2}, 
		         	{ title: 'Item 2-2' }, 
		         	{ title: 'Item 2-3' } 
		     ] });
	}); // onready
</script>
</head>
<body>
</body>
</html>