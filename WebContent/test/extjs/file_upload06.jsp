<%@page language="java" contentType="text/html; charset=utf-8"%>
<style>
.mycss {
    background-position:center  !important;
    width: auto !important;
    background-repeat: no-repeat;
    background-image: url("yourIcon.png") !important; 
}
</style>

<script type="text/javascript" >


Ext.onReady(function()
{	
	
	var files = [
		{id:1,fid:'0143e8c17d91bd5e8983248cb0000000',name:'Quatation.doc',size:10240,status:6},
		{id:2,fid:'0143e8c17f65092ad644248cb0000000',name:'Price List.doc',size:20240,status:6}
	];
	
	var pnl = Ext.create('Ext.panel.Panel', {
	    defaults: {padding:5},
	    layout : {	type: 'vbox', pack: 'start', align: 'stretch' },
	    height:500,
		renderTo: Ext.getBody(),
	    title : 'File Management',
		
	    
	    items: [
			{ xtype:'toolbar',
	    	  items : [
	    	  		{xtype:'button',
							text : 'Files',
							handler : getSt
					},
					{xtype:'button',
							text : 'LoadData',
							handler : loadData
					},
					{xtype:'button',
							text : 'RestFP',
							handler : resetFP
					}]
	    	}, 	
    		{xtype:'form',
	         defaultType: 'uniTextfield',
	         layout : {type : 'uniTable', columns: 2 },
    		 items: [ 
    		 		 { name      : 'dae',
                        fieldLabel: 'Date',
                        allowBlank: false},
                        { name      : 'dae',
                        fieldLabel: 'Writer',
                        allowBlank: false},
                      { name      : 'dae',
                        fieldLabel: 'Type',
                        xtype :'uniCombobox',
                        allowBlank: false},
                      { name      : 'dae',
                        fieldLabel: 'Category',
                        xtype :'uniCombobox',
                        allowBlank: false},
                        
	            {fieldLabel: 'Description', name: 'txtContentStr', xtype: 'textareafield', grow : true, colspan : 2, width : 550, height : 100} 
	            ]},
	    	{
	    		xtype:'xuploadpanel',
		    	itemId:'fileUploadPanel',
		    	flex:1,
		    	listeners : {
		    		change: function() {
		    			console.log('data changed');
		    		},
		    		uploadcomplete: function() {
		    			console.log('uploadcomplete');
		    			
		    		},
		    		scope: this
		    	}
	    	}
	    ]
	});
	
	function getSt(files) {
		console.log("x");
		var fp = pnl.getComponent('fileUploadPanel');
		var addFiles = fp.getAddFiles();
		var removeFiles = fp.getRemoveFiles();
		console.log("addFiles: ", addFiles);
		console.log("removeFiles: ", removeFiles);
	};
	
	function loadData() {
		console.log("loadData");
		var fp = pnl.getComponent('fileUploadPanel');
		fp.loadData(files);
	};
	function resetFP() {
		console.log("resetFP");
		var fp = pnl.getComponent('fileUploadPanel');
		fp.reset();
		
	}
});
</script>
<form id="exportform" method="get" target="_blank">
        <input type="hidden" id="fid" name="fid" value="" />
        <input type="hidden" name="inline" value="N" />
</form>
