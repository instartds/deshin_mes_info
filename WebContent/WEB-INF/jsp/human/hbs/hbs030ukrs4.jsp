<%@page language="java" contentType="text/html; charset=utf-8"%>
	 {
		title:'<t:message code="system.label.human.simpleincometax" default="간이소득세액표"/>',
		id:'hbs030ukrGrid4',
		itemId: 'hbs030ukrPanel4',
		border: false,
		xtype: 'container',
		layout: {type: 'vbox', align: 'stretch'},
		items:[{				
			xtype: 'uniDetailForm',
			id:'hbs030ukrPanel4Form',
			itemId:'hbs030ukrPanel4Form',
			disabled:false,
			layout: {type: 'table',columns:1},
			items:[{
				fieldLabel: '<t:message code="system.label.human.taxyear" default="세액년도"/>',
				xtype: 'uniMonthfield',
				value: new Date().getFullYear(),
			    name: 'TAX_YYYY4',
			    id : 'TAX_YYYY4',
				allowBlank: false
			}/*,{ 
			    		xtype: 'uniDetailFormSimple',
			        	layout: {type: 'hbox'},
			        	width:700,
			        	margin:'0 0 0 40',
			        	fileUpload: true,
			        	itemId: 'uploadForm',
			        	id: 'uploadForm',
			        	url: CPATH+'/excel/upload.do',
				    	fileUpload: true,
			        	items : [{ 
		     	                xtype: 'filefield',
		     	                buttonOnly: false,
		     	                //flex: 1,
		     	               // margin:'0 0 0 40',
		     	                width:600,
		     	                name: 'excelFile',
		     	                buttonText: '파일선택',
		     	                listeners: {
		     	                    change: function( filefield, value, eOpts )    {
		     	                            var fileExtention = value.substring(value.lastIndexOf("."));
		     	                            console.log("new file's extension is ",fileExtention);
		     	                            
		     	                     } // change
		     	                } // listeners
			                   } , {
						xtype: 'button',
						text: 'UpLoad',
						width: 60,
						margin: '0 0 5 5',
						handler: function(btn) {
							Ext.getCmp('uploadForm').getForm().submit({ // *중요  uploadForm 을 가져와야함   
																params: { excelConfigName: 'hbs030' },
																success: function(form, action) {
																
																	Ext.Msg.alert('Success', 'Upload 되었습니다.');
																},
													            failure: function(form, action) {
													                Ext.Msg.alert('Failed', action.result.msg);
													            }
																
															});						
						}
					}//
			     			]
			  }*/
			 
			]},{
			xtype: 'uniGridPanel',
			itemId:'uniGridPanel4',
		    store : hbs030ukrs4Store,
		    uniOpt: {
	    		expandLastColumn: false,
			 	copiedRow: true
	//		 	useContextMenu: true,
	        },
	        features: [{
	    		id: 'masterGridSubTotal',
	    		ftype: 'uniGroupingsummary', 
	    		showSummaryRow: false 
	    	},{
	    		id: 'masterGridTotal', 	
	    		ftype: 'uniSummary', 	  
	    		showSummaryRow: false
	    	}],	    
			tbar: [{
			xtype: 'splitbutton',
           	itemId:'refTool',
			text: '<t:message code="system.label.human.reference" default="참조..."/>',
			iconCls : 'icon-referance',
			menu: Ext.create('Ext.menu.Menu', {
				items: [{
					itemId: 'excelBtn',
					text: '<t:message code="system.label.human.excelrefer" default="엑셀참조"/>',
		        	handler: function() {
			        	openExcelWindow();
			        }
				}]
			})
		}],
			columns: [
        	  	{dataIndex: 'TAX_YYYY',  width: 80,  text: '<t:message code="system.label.human.docyyyy" default="년도"/>',  align:'center', hidden: true},
				{text: '<t:message code="system.label.human.salaryyi" default="월급여액"/>',
		   		   columns:[
		        	 
		        	  {text: '<t:message code="system.label.human.notincludetax" default="(비과세소득은 제외)"/>',
							columns:[
								{dataIndex: 'TAX_STRT_AMOUNT',  width: 80,  text: '<t:message code="system.label.human.taxstrtamount" default="이상"/>'},
		                		{dataIndex: 'TAX_END_AMOUNT',   width: 80,  text: '<t:message code="system.label.human.taxendamount" default="미만"/>'}
		                		    ]
		               }
		            ]
		 		},
		 		{text: '<t:message code="system.label.human.deductedfanilymember" default="공 제 대 상 가족의 수 (본인 · 배우자를 각각 1인으로 봄)"/>',
					columns:[
		             
		             	{dataIndex: 'DED_GRADE1',  width: 80,  text: '1'},
		             	{dataIndex: 'DED_GRADE2',  width: 80,  text: '2'},
		             {text: '3',
							columns:[
								{dataIndex: 'DED_GRADE3',  		width: 80,  text: '<t:message code="system.label.human.general" default="일반"/>'},
		                		{dataIndex: 'DED_GRADE3_CHILD',  width: 80,  text: '<t:message code="system.label.human.dedgrade" default="다자녀"/>'}
		                	]
		            },{text: '4',
		                	columns:[ 	 
		                		{dataIndex: 'DED_GRADE4',  		width: 80,  text: '<t:message code="system.label.human.general" default="일반"/>'},
		                		{dataIndex: 'DED_GRADE4_CHILD',  width: 80,  text: '<t:message code="system.label.human.dedgrade" default="다자녀"/>'}
		                	]
		            },{text: '5',
		                	columns:[ 	
		                		{dataIndex: 'DED_GRADE5',  		width: 80,  text: '<t:message code="system.label.human.general" default="일반"/>'},
		                		{dataIndex: 'DED_GRADE5_CHILD',  width: 80,  text: '<t:message code="system.label.human.dedgrade" default="다자녀"/>'}
		                	 ]
		            },{text: '6',
		                	columns:[ 	 
		                		{dataIndex: 'DED_GRADE6',  		width: 80,  text: '<t:message code="system.label.human.general" default="일반"/>' },
		                		{dataIndex: 'DED_GRADE6_CHILD',  width: 80,  text: '<t:message code="system.label.human.dedgrade" default="다자녀"/>'}
		                	]
					},{text: '7',
		                	columns:[ 	 
		                		{dataIndex: 'DED_GRADE7',  		width: 80,  text: '<t:message code="system.label.human.general" default="일반"/>'},
		                		{dataIndex: 'DED_GRADE7_CHILD',  width: 80,  text: '<t:message code="system.label.human.dedgrade" default="다자녀"/>'}
		                	]
					},{text: '8',
		                	columns:[ 	 
		                		{dataIndex: 'DED_GRADE8',  		width: 80,  text: '<t:message code="system.label.human.general" default="일반"/>'},
		                		{dataIndex: 'DED_GRADE8_CHILD',  width: 80,  text: '<t:message code="system.label.human.dedgrade" default="다자녀"/>'}
		                	]
					},{text: '9',
		                	columns:[ 	 
		                		{dataIndex: 'DED_GRADE9',  		width: 80,  text: '<t:message code="system.label.human.general" default="일반"/>'},
		                		{dataIndex: 'DED_GRADE9_CHILD',  width: 80,  text: '<t:message code="system.label.human.dedgrade" default="다자녀"/>'}
		                	]
					},{text: '10',
		                	columns:[ 	 
		                		{dataIndex: 'DED_GRADE10',  		width: 80,  text: '<t:message code="system.label.human.general" default="일반"/>'},
		                		{dataIndex: 'DED_GRADE10_CHILD',     width: 80,  text: '<t:message code="system.label.human.dedgrade" default="다자녀"/>'}
		                	]
					},{text: '11',
		                	columns:[ 	 
		                		{dataIndex: 'DED_GRADE11',  		width: 80,  text: '<t:message code="system.label.human.general" default="일반"/>'},
		                		{dataIndex: 'DED_GRADE11_CHILD',  	width: 80,  text: '<t:message code="system.label.human.dedgrade" default="다자녀"/>'}
		                	]
					},{dataIndex: 'INSERT_USER_ID',  width: 80,   text: '<t:message code="system.label.human.user" default="사용자"/>', hidden: true}
					, {dataIndex: 'INSERT_DB_TIME',  width: 80,   text: '<t:message code="system.label.human.useday1" default="사용일"/>', hidden: true}
	       ]
		}]						
	}]
}