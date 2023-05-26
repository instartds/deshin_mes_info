<%@page language="java" contentType="text/html; charset=utf-8"%>
	 {
		title:'급여/상여',
		itemId: 'tab_pay',
		id:'tab_pay',
		border: false,
		xtype: 'container',
		layout: {type: 'vbox', align: 'stretch'},
		items:[{
			xtype: 'uniDetailForm',
			itemId: 'tab_payForm',
			disabled:false,
			autoScroll: false,
			layout: {type: 'uniTable', columns: 3},
			items:[{
				fieldLabel: '기표구분',
				name: 'DIVI',
				id:'DIVI3',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'A045',
				allowBlank: false,
				value: '1'
			}, {
				fieldLabel: '판관제조구분',
				name: 'SALE_DIVI',
				id:'SALE_DIVI3',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B027'
			},
			{
				margin:'0 0 0 100',
	        	xtype:'button',
	        	text:'전체복사',
	        	width: 130,
	        	tdAttrs:{'align':'center'},
	        	handler: function()	{
					var param = {
	        			'DIVI' 		: Ext.getCmp('DIVI3').getValue(),
	        			'SALE_DIVI' : Ext.getCmp('SALE_DIVI3').getValue()
	        		}
	        		aba060ukrsService.checkCount(param, function(provider, response) {
	        			if(!Ext.isEmpty(provider)){			
	        				if(provider[0].CNT > 0 ){	
			        			//if(confirm(Msg.sMA0092 + "\n" + Msg.sMA0093 + "\n" + Msg.sMA0094)){
				        		if(confirm('이미 데이터가 존재합니다.' + "\n" + '다시 생성하시면 기존 데이터가 삭제됩니다.' + "\n" + '그래도 생성하시겠습니까?')){	
					        		var param = {
					        			'DIVI' 		: Ext.getCmp('DIVI3').getValue(),
	        							'SALE_DIVI' : Ext.getCmp('SALE_DIVI3').getValue(),
					        			'ALL_COPY'	: 'C'
					        		}
					        		
					        		panelDetail.down('#aba060ukrs3Grid').reset();
									aba060ukrs3Store.clearData();
					        		panelDetail.down('#tab_pay').getEl().mask('로딩중...','loading-indicator');
					        		aba060ukrsService.selectList3(param, function(provider, response) {
										if(!Ext.isEmpty(provider)){
											
											
											Ext.each(provider, function(record,i){
												UniAppManager.app.onNewDataButtonDown();
								        		panelDetail.down('#aba060ukrs3Grid').setNewDataProvider(record);	
											});
										}
										panelDetail.down('#tab_pay').getEl().unmask();
					        		});
					        	}
		        			}
	        			}
	        		});
	        	}
			}],
			setAllFieldsReadOnly: function(b) {
					var r= true
					if(b) {
						var invalid = this.getForm().getFields().filterBy(function(field) {
																			return !field.validate();
																		});
	   	
		   				if(invalid.length > 0) {
							r=false;
		   					var labelText = ''
		   	
							if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
		   						var labelText = invalid.items[0]['fieldLabel']+'은(는)';
		   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
		   						var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
		   					}
		
						   	alert(labelText+Msg.sMB083);
						   	invalid.items[0].focus();
						} else {
						//	this.mask();		    
		   				}
			  		} else {
	  					this.unmask();
	  				}
					return r;
	  			}			
		}, {				
			xtype: 'uniGridPanel',
			itemId:'aba060ukrs3Grid',
		    store : aba060ukrs3Store,
		    uniOpt : {
		    	copiedRow           : true,
				useMultipleSorting	: true,			 
		    	useLiveSearch		: false,			
		    	onLoadSelectFirst	: true,	
		    	dblClickToEdit		: true,		
		    	useGroupSummary		: true,			
				useContextMenu		: false,		
				useRowNumberer		: true,			
				expandLastColumn	: false,		
				useRowContext		: false,	// rink 항목이 있을경우만 true			
			    	filter: {
					useFilter	: true,		
					autoCreate	: true		
				}
			},     
			columns: [{dataIndex: 'PAY_GUBUN'		,		width:80 },				  
					  {dataIndex: 'DIVI'			,		width:80 , hidden: true},			  
					  {dataIndex: 'ALLOW_TAG_A043'  ,		width:100 },	
					  {dataIndex: 'ALLOW_TAG_A066'  ,		width:100 },
					  {dataIndex: 'ALLOW_CODE'  	,		width:120 
						,'editor' : Unilite.popup('ALLOW_G',{
					 	 		DBtextFieldName: 'ALLOW_CODE',
					 	 		autoPopup:true,
		  						listeners: {
  									'onSelected': {
		 								fn: function(records, type) {
		 									grdRecord = Ext.getCmp('tab_pay').down('#aba060ukrs3Grid').getSelectedRecord();
											record = records[0];
											grdRecord.set('ALLOW_CODE',  record.ALLOW_CODE);
											grdRecord.set('ALLOW_NAME', record.ALLOW_NAME);
		 								},
		 								scope: this
		 							},
		 							'onClear': function(type) {
		 								grdRecord = Ext.getCmp('tab_pay').down('#aba060ukrs3Grid').getSelectedRecord();
										grdRecord.set('ALLOW_CODE', '');
										grdRecord.set('ALLOW_NAME', '');
		 							},
		 							applyextparam: function(popup){	
		 								grdRecord = Ext.getCmp('tab_pay').down('#aba060ukrs3Grid').getSelectedRecord();
		 								
										if(Ext.getCmp('DIVI3').getValue() == '1' ){
											popup.setExtParam({'ALLOW_TAG'  : grdRecord.data.ALLOW_TAG_A043});
										}else if(Ext.getCmp('DIVI3').getValue() == '2' ){
											popup.setExtParam({'ALLOW_TAG'  : grdRecord.data.ALLOW_TAG_A066});
										}
		 							}
		 						}
							})
					  },
					  {dataIndex: 'ALLOW_NAME' 		,		width:220 
						,'editor' : Unilite.popup('ALLOW_G',{ 
					 	 		autoPopup:true,
		  						listeners: {
  									'onSelected': {
		 								fn: function(records, type) {
		 									grdRecord = Ext.getCmp('tab_pay').down('#aba060ukrs3Grid').getSelectedRecord();
											record = records[0];
											grdRecord.set('ALLOW_CODE',  record.ALLOW_CODE);
											grdRecord.set('ALLOW_NAME', record.ALLOW_NAME);
		 								},
		 								scope: this
		 							},
		 							'onClear': function(type) {
		 								grdRecord = Ext.getCmp('tab_pay').down('#aba060ukrs3Grid').getSelectedRecord();
										grdRecord.set('ALLOW_CODE', '');
										grdRecord.set('ALLOW_NAME', '');
		 							},
		 							applyextparam: function(popup){	
		 								grdRecord = Ext.getCmp('tab_pay').down('#aba060ukrs3Grid').getSelectedRecord();
		 								
										if(Ext.getCmp('DIVI3').getValue() == '1' ){
											popup.setExtParam({'ALLOW_TAG'  : grdRecord.data.ALLOW_TAG_A043});
										}else if(Ext.getCmp('DIVI3').getValue() == '2' ){
											popup.setExtParam({'ALLOW_TAG'  : grdRecord.data.ALLOW_TAG_A066});
										}
		 							}
		 						}
							})
					  },	
					  {dataIndex: 'SALE_DIVI'  		,		width:166 },	
					  {dataIndex: 'EMPLOY_DIVI' 		,		width:100 },			  
					  {dataIndex: 'ACCNT'  			,		width:120 
					 	 ,'editor' : Unilite.popup('ACCNT_G',{
					 	 		DBtextFieldName: 'ACCNT_CODE',
					 	 		autoPopup:true,
//					 	 		extParam: {'CHARGE_CODE': getChargeCode[0].SUB_CODE,
//		    								'ADD_QUERY': "(SLIP_SW = 'Y' AND GROUP_YN = 'N')"}, 
		  						listeners: {
  									'onSelected': {
		 								fn: function(records, type) {
		 									grdRecord = Ext.getCmp('tab_pay').down('#aba060ukrs3Grid').getSelectedRecord();
											record = records[0];
											grdRecord.set('ACCNT',  record.ACCNT_CODE);
											grdRecord.set('ACCNT_NAME', record.ACCNT_NAME);
		 								},
		 								scope: this
		 							},
		 							'onClear': function(type) {
		 								grdRecord = Ext.getCmp('tab_pay').down('#aba060ukrs3Grid').getSelectedRecord();
										grdRecord.set('ACCNT', '');
										grdRecord.set('ACCNT_NAME', '');
		 							},
									'applyextparam': function(popup){							
										popup.setExtParam({
//											'CHARGE_CODE': getChargeCode[0].SUB_CODE,
		    								'ADD_QUERY': "(SLIP_SW = 'Y' AND GROUP_YN = 'N')"
	    								});
									}
		 						}
							})
					  },				  
					  {dataIndex: 'ACCNT_NAME' 		,		width:220 
					  	,'editor' : Unilite.popup('ACCNT_G',{
					  			autoPopup:true,
//					  			extParam: {'CHARGE_CODE': getChargeCode[0].SUB_CODE,
//		    								'ADD_QUERY': "(SLIP_SW = 'Y' AND GROUP_YN = 'N')"}, 
		  						listeners: {
  									'onSelected': {
		 								fn: function(records, type) {
		 									grdRecord = Ext.getCmp('tab_pay').down('#aba060ukrs3Grid').getSelectedRecord();
											record = records[0];
											grdRecord.set('ACCNT',  record.ACCNT_CODE);
											grdRecord.set('ACCNT_NAME', record.ACCNT_NAME);
		 								},
		 								scope: this
		 							},
		 							'onClear': function(type) {
		 								grdRecord = Ext.getCmp('tab_pay').down('#aba060ukrs3Grid').getSelectedRecord();
										grdRecord.set('ACCNT', '');
										grdRecord.set('ACCNT_NAME', '');
		 							},
									'applyextparam': function(popup){							
										popup.setExtParam({
//											'CHARGE_CODE': getChargeCode[0].SUB_CODE,
		    								'ADD_QUERY': "(SLIP_SW = 'Y' AND GROUP_YN = 'N')"
	    								});
									}
		 						}
							})
					  },			
					  {dataIndex: 'UPDATE_DB_USER'	,		width:66 , hidden: true},				  
					  {dataIndex: 'UPDATE_DB_TIME'	,		width:66 , hidden: true}				  
					  //{dataIndex: 'COMP_CODE'		,		width:66 , hidden: true}	
			],
			listeners: {
        		beforeedit: function( editor, e, eOpts ) {
		        	/*if(e.record.phantom == false) {
		        		if(UniUtils.indexOf(e.field, ['SALE_DIVI', 'BUSI_TYPE', 'SLIP_DIVI', 'EMPLOY_DIVI' ])) {
							return false;
						}
		        	}
		        	if(e.record.data.ALLOW_TAG_A066 == '1') {
		        		if(UniUtils.indexOf(e.field, ['ALLOW_CODE', 'ALLOW_NAME'])) {
							return false;
						}
		        	}*/
        			if(e.record.phantom == false) {
        				if(UniUtils.indexOf(e.field, ['ACCNT', 'ACCNT_NAME'])) {
							return true;
						} else {
							return false;
						}
        			}
        			return true;
	        	},
	        	edit: function(editor, e) {
	        		/*if(Ext.isEmpty(e.record.data.ALLOW_TAG_A043)) {
	        			Ext.getCmp('tab_pay').down('#aba060ukrs3Grid').getSelectedRecord().set('ALLOW_CODE' , '');
	        			Ext.getCmp('tab_pay').down('#aba060ukrs3Grid').getSelectedRecord().set('ALLOW_NAME' , '');
	        		}else {
	        			Ext.getCmp('tab_pay').down('#aba060ukrs3Grid').getSelectedRecord().set('ALLOW_CODE' , '');
	        			Ext.getCmp('tab_pay').down('#aba060ukrs3Grid').getSelectedRecord().set('ALLOW_NAME' , '');
	        		}
	        		if(e.record.data.ALLOW_TAG_A066 == '1') {
	        			Ext.getCmp('tab_pay').down('#aba060ukrs3Grid').getSelectedRecord().set('ALLOW_CODE' , '*');
	        		}else{
	        			Ext.getCmp('tab_pay').down('#aba060ukrs3Grid').getSelectedRecord().set('ALLOW_CODE' , '');
	        			Ext.getCmp('tab_pay').down('#aba060ukrs3Grid').getSelectedRecord().set('ALLOW_NAME' , '');
	        			
	        		}*/
	        		if(editor.context.field == 'DIVI')	{
	        			Ext.getCmp('tab_pay').down('#aba060ukrs3Grid').getSelectedRecord().set('ALLOW_CODE' , '');
	        			Ext.getCmp('tab_pay').down('#aba060ukrs3Grid').getSelectedRecord().set('ALLOW_NAME' , '');
	        		}
	        	}
			},	
        	setNewDataProvider:function(record){
				var grdRecord = this.getSelectedRecord();
		
				grdRecord.set('PAY_GUBUN'	 			,record['PAY_GUBUN']);
				grdRecord.set('DIVI'	 				,record['DIVI']);
				if(Ext.getCmp('DIVI3').getValue() == '1'){
					grdRecord.set('ALLOW_TAG_A043'	 		,record['ALLOW_TAG_A043']);
				}
				else{
					grdRecord.set('ALLOW_TAG_A066'	 		,record['ALLOW_TAG_A066']);
				}
				grdRecord.set('ALLOW_CODE'		 		,record['ALLOW_CODE']);
				grdRecord.set('ALLOW_NAME'				,record['ALLOW_NAME']);
				grdRecord.set('SALE_DIVI'				,record['SALE_DIVI']);
				grdRecord.set('ACCNT'					,record['ACCNT']);
				grdRecord.set('ACCNT_NAME'				,record['ACCNT_NAME']);
				grdRecord.set('UPDATE_DB_USER'			,record['UPDATE_DB_USER']);
				grdRecord.set('UPDATE_DB_TIME'			,record['UPDATE_DB_TIME']);
	        }						
		}]
	}