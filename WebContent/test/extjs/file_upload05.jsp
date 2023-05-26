<%@page language="java" contentType="text/html; charset=utf-8"%>

<script type="text/javascript" >


Ext.onReady(function()
{		
	Ext.create('Ext.ux.uploadPanel.UploadPanel',{	
		renderTo: Ext.getBody(),
	   title : 'UploadPanel for extjs 4.0',	
	   file_size_limit : 10000,//MB	
	   upload_url : 'upload.do'
	
	});

});
</script>
