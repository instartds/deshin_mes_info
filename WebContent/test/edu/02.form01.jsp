<%@page language="java" contentType="text/html; charset=utf-8"%>
<!DOCTYPE html  >
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link rel="stylesheet" type="text/css" href='<c:url value="/extjs/resources/Z_temp4.22/index.css" />' />
<link rel="stylesheet" type="text/css" href='<c:url value="/resources/css/unilite.css" />' />
<script type="text/javascript" charset="UTF-8" src='<c:url value="/extjs/ext-all-debug.js" />'></script>
<script type="text/javascript" charset="UTF-8" src='<c:url value="/test/Foren/BasicForm.js" />'></script>

<script type="text/javascript" charset="UTF-8" src='<c:url value="/api.js" />'></script>

<script type="text/javascript">
	Ext.Loader.setConfig({
		enabled : true,
		scriptCharset : 'UTF-8',
		paths: {
	        	"Foren": '/g3erp/test/Foren'
	    }
	});
	Ext.require('*');
	Ext.onReady(function() {
		
		Ext.direct.Manager.addProvider(Ext.app.REMOTING_API);
		
		var set1 =  Ext.create('Ext.form.FieldSet',{	
				title:'기본정보',
	        	xtype: 'fieldset', 
	 		    defaultType: 'combobox',
	 		    layout : {type: 'table' , columns: 3},
	        	items: [   // checkbox , combo , datefield
		         	{ fieldLabel: 'Customer Name', name: 'F1', flex: 1, allowBlank: false, 
		         		xtype: 'textfield',
		         		listeners: {
		         			Xblur: function(field, newValue, oldValue, eOpts) {
		         				
								var form = this.up('form');
								
								
									form.updateRecord();
								
		         			}
		         		}
		         	}, 
		         	{ fieldLabel: 'Client Type', name: 'F2',  flex: 1 }, 
		         	{ fieldLabel: 'Project Name', name: 'F3',  flex: 1}
		         ],
		         getForm: function() {
		         	return this.up('form');
		         }
		        
			});
		var set2 = {	
				 title:'계획',
	        	 xtype: 'fieldset', 
	 		     defaultType: 'textfield',
	 		     layout : {type: 'table' , columns: 3},
	        	 items: [   // checkbox , combo , datefield
		         	{ fieldLabel: 'Save', name: 'F4', flex: 1, allowBlank: false}, 
		         	{ fieldLabel: 'Estimate Date', name: 'F5',  flex: 1 }, 
		         	{ fieldLabel: 'Meeting', name: 'F6',  flex: 1}
		         ]
			};
		var tbar = Ext.create('Ext.toolbar.Toolbar', {
		    items: [
		        {
		            text: 'Button',
		            iconCls: 'icon-save',
		            handler: function(button, eventObject) {
		            	alert('Hi!');
		            }
		        },
		        {
		            xtype: 'splitbutton',
		            text : 'Split Button'
		        },
		        // begin using the right-justified button container
		        '->', // same as { xtype: 'tbfill' }
		        {
		            xtype    : 'textfield',
		            name     : 'field1',
		            emptyText: 'enter search term'
		        },
		        // add a vertical separator bar between toolbar items
		        '-', // same as {xtype: 'tbseparator'} to create Ext.toolbar.Separator
		        'text 1', // same as {xtype: 'tbtext', text: 'text1'} to create Ext.toolbar.TextItem
		        { xtype: 'tbspacer' },// same as ' ' to create Ext.toolbar.Spacer
		        'text 2',
		        { xtype: 'tbspacer', width: 50 }, // add a 50px space
		        'text 3'
		    ]
		});	
		
		Ext.define('foren.testModel', {
			extend: 'Ext.data.Model',
			fields: [
				{name: 'F1', type: 'string' },
				{name: 'F2', type: 'string'},
				{name: 'F3', type: 'string'},
				{name:'updateDate', type:'string'}
			]
		});
		
		Ext.create('Ext.data.Store', {
		    storeId:'simpsonsStore',
		    //fields:['F1', 'F2', 'F3'],
		    model: 'foren.testModel',
		    data:{'items':[
		        { 'F1': 'DDDLisa',  "F2":"lisa@simpsons.com",  "F3":"555-111-1224", updateDate: "updatedate"  },
		        { 'F1': 'Bart',  "F2":"bart@simpsons.com",  "F3":"555-222-1234"  },
		        { 'F1': 'Homer', "F2":"home@simpsons.com",  "F3":"555-222-1244"  },
		        { 'F1': 'Marge', "F2":"marge@simpsons.com", "F3":"555-222-1254"  },
		        { 'F1': 'Marge', "F2":"marge@simpsons.com", "F3":"555-222-1254"  },
		        { 'F1': 'Marge', "F2":"marge@simpsons.com", "F3":"555-222-1254"  },
		        { 'F1': 'Marge', "F2":"marge@simpsons.com", "F3":"555-222-1254"  },
		        { 'F1': 'Marge', "F2":"marge@simpsons.com", "F3":"555-222-1254"  },
		        { 'F1': 'Lisa',  "F2":"lisa@simpsons.com",  "F3":"555-111-1224"  },
		        { 'F1': 'Bart',  "F2":"bart@simpsons.com",  "F3":"555-222-1234"  },
		        { 'F1': 'Homer', "F2":"home@simpsons.com",  "F3":"555-222-1244"  },
		        { 'F1': 'Marge', "F2":"marge@simpsons.com", "F3":"555-222-1254"  },
		        { 'F1': 'Marge', "F2":"marge@simpsons.com", "F3":"555-222-1254"  },
		        { 'F1': 'Marge', "F2":"marge@simpsons.com", "F3":"555-222-1254"  },
		        { 'F1': 'Marge', "F2":"marge@simpsons.com", "F3":"555-222-1254"  },
		        { 'F1': 'Marge', "F2":"marge@simpsons.com", "F3":"555-222-1254"  },
		        { 'F1': 'Lisa',  "F2":"lisa@simpsons.com",  "F3":"555-111-1224"  },
		        { 'F1': 'Bart',  "F2":"bart@simpsons.com",  "F3":"555-222-1234"  },
		        { 'F1': 'Homer', "F2":"home@simpsons.com",  "F3":"555-222-1244"  },
		        { 'F1': 'Marge', "F2":"marge@simpsons.com", "F3":"555-222-1254"  },
		        { 'F1': 'Marge', "F2":"marge@simpsons.com", "F3":"555-222-1254"  },
		        { 'F1': 'Marge', "F2":"marge@simpsons.com", "F3":"555-222-1254"  },
		        { 'F1': 'Marge', "F2":"marge@simpsons.com", "F3":"555-222-1254"  },
		        { 'F1': 'Marge', "F2":"marge@simpsons.com", "F3":"555-222-1254"  },
		        { 'F1': 'Marge', "F2":"marge@simpsons.com", "F3":"555-222-1254"  }
		    ]},
		    proxy: {
		        type: 'memory',
		        reader: {
		            type: 'json',
		            root: 'items'
		        }
		    }
		});
		
		var grid1= Ext.create('Ext.grid.Panel', {
		    title: 'Simpsons',
		    store: Ext.data.StoreManager.lookup('simpsonsStore'),
		    columns: [
		        { text: 'Customer Name',  dataIndex: 'F1' },
		        { text: 'Client Type', dataIndex: 'F2', flex: 1 },
		        { text: 'Project Name', dataIndex: 'F3' }
		    ],
			flex: 1,
		    listeners : {
		    	selectionchange: function( grid, selected, eOpts ) {
		    		console.log(selected);
		    		var rec = selected[0];
		            if (rec) {
		                var frm = this.getForm();
		                frm.setActiveRecord(rec);
		            }
		    	}
		    },
		    getForm: function() {
		    	var frm=  Ext.getCmp('mainForm');
		    	
		    	frm = this.up('viewport').down('form');
		    	
		    	return frm;
		    }
		});
		
		var formPanel =  Ext.create('Foren.BasicForm', {
			//xtype: 'forenBaseForm',
			'tbar': tbar,
			id: 'cmb100uskv.mainForm',
			layout: { type: 'vbox' , alignstrech: true},
			items: [ set1, set2 ] ,
	 		 activeRecord: null,
		      setActiveRecord: function(record) {
		         	this.activeRecord = record;
		         	//var form = this.getForm();
		         	this.loadRecord(record);
		      },
		      updateRecord: function() {
		      	var rec = this.activeRecord; //this.getRecord();
		      	this.updateRecord(rec);
		      }
		});
		
		var appMain = Ext.create('Ext.Viewport', { 
		    layout : {	type: 'vbox',  align: 'stretch' },
			renderTo: Ext.getBody(),
			items : [ formPanel, grid1  ]
		});//
		
	}); // onready
</script>
</head>
<body>
</body>
</html>