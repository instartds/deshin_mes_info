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
//		var panel = Ext.create('Ext.Panel', {
//		    html: 'Panel HTML'
//		});
//		
//		var button = Ext.create('Ext.Button', {
//		    renderTo: Ext.getBody(),
//		    text: 'Click Me'
//		});
//		
//		button.on({
//		    click: {
//		        //scope: panel,
//		        fn: function() {
//		            Ext.Msg.alert(this.getXType());
//		        }
//		    }
//		});
		
		var container = Ext.create('Ext.Container', {
		    renderTo: Ext.getBody(),
		    html: 'Click Me!',
		    listeners: {
		        click: function(){
		            Ext.Msg.alert('I have been clicked!')  // This won't fire without the code
		 } } });        
		 
		 container.getEl().on('click', function(){ 
		    this.fireEvent('click', container); 
		}, container);
	}); // onready
</script>
</head>
<body>
</body>
</html>