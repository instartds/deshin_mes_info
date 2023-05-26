<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" type="text/css" href='<c:url value="/extjs/resources/Z_temp4.22/index.css" />' />
<link rel="stylesheet" type="text/css" href='<c:url value="/resources/css/unilite.css" />' />
<script type="text/javascript" charset="UTF-8" src='<c:url value="/extjs/ext-all-debug.js" />'></script>
<script type="text/javascript">
	Ext.require('*');
	Ext.onReady(function() {
		
		var store =	Ext.create('Ext.data.Store', {
		    storeId:'simpsonsStore',
		    fields:['F1', 'F2', 'F3'],
		    data:{'items':[
		        { 'F1': 'Lisa',  "F2":"lisa@simpsons.com",  "F3":"555-111-1224"  },
		        { 'F1': 'Bart',  "F2":"bart@simpsons.com",  "F3":"555-222-1234" },
		        { 'F1': 'Homer', "F2":"home@simpsons.com",  "F3":"555-222-1244"  },
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
		
		var grid1 = Ext.create('Ext.grid.Panel', {
		    title: 'Simpsons',
		    store: Ext.data.StoreManager.lookup('simpsonsStore'),
		    columns: [
		        { text: 'Name',  dataIndex: 'F1' },
		        { text: 'Email', dataIndex: 'F2', flex: 1 },
		        { text: 'Phone', dataIndex: 'F3' }
		    ],
		    flex: 1,
            listeners: {            	
            	 selectionchange: function(model, records) {
            	 	var rec = records[0];
			        if (rec) {
			            this.getForm().loadRecord(rec);
			        }
	            }
            },
		    getForm: function() {
		    	return Ext.getCmp('mainForm');
		    }
		    //height: 200
		    //width: 700
		});
		
		var tbar = Ext.create('Ext.toolbar.Toolbar', {
		    items: [
		        {
		            // xtype: 'button', // default for Toolbars
		            text: 'Button',
		            iconCls: 'icon-save',
		            handler: function() {
		            	alert("HI!");
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
		var formPanel = Ext.create('Ext.form.Panel', {
			id: 'mainForm',
			//width: '580px',
			renderTo: Ext.getBody(),
			padding: '5 5 0 5',
			//width: '100%',
			tbar: tbar,
			fieldDefaults: {
				msgTarget: 'qtip',
				labelAlign: 'right',
				labelWidth: 98,
				blankText: '갑을 입력해 주세요',
				labelSeperator: '',
				validateOnChange: false,
				autoFitErrors: true
			},
			layout: {
				type: 'vbox'//, align: 'stretch'
			},
			defaultType: 'textfield',
			items: [
				{
					title: '기본정보',
					xtype: 'fieldset',
					layout: {
						type:'table', 
						columns: 3,
						tableAttrs: {
				            style: {
				                width: '100%',
				                align: 'left'
				            }
				        }
					},
					items: [
						{fieldLabel: '고객명', 	name: 'F1', xtype:'combo'},
						{fieldLabel: '영업유형', 	name: 'F2', xtype:'combo'},
						{fieldLabel: '영업기회', 	name: 'F3', xtype: 'textfield'}
					]
				},
				{
					title: '계획',
					xtype: 'fieldset',
					layout: {
						type:'table', 
						columns: 3,
						tableAttrs: {
				            style: {
				                width: '100%',
				                align: 'left'
				            }
				        }
					},
					items: [
						{boxLabel: '제공여부', xtype:'checkboxfield', checked: true},
						{fieldLabel: '계획일자', xtype:'datefield'},
						{fieldLabel: '미팅동반여부', xtype:'checkboxfield'},
						{fieldLabel: '계획', xtype: 'textfield', colspan: 3, width: 700}

					]
				}
			]
		});
		
		var appMain = Ext.create('Ext.Viewport', {
			layout: {
				type: 'vbox', align: 'stretch'
			},
			items: [
				formPanel,
				grid1
			]
		
		});
		
	});
</script>
</head>
<body>

</body>
</html>