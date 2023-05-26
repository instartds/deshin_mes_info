<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="mrp180ukrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B014" /> <!-- 조달구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B019" /> <!-- 국내외구분 --> 
	<t:ExtComboStore comboType="AU" comboCode="M201" /> <!-- 구매담당 -->
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

var outDivCode = UserInfo.divCode;

function appMain() {
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'mrp180ukrvService.selectMaster',
			update: 'mrp180ukrvService.updateDetail',
			create: 'mrp180ukrvService.insertDetail',
			destroy: 'mrp180ukrvService.deleteDetail',
			syncAll: 'mrp180ukrvService.saveAll'
		}
	});

	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Mrp180ukrvModel', {
	    fields: [
	    	{name: 'DIV_CODE'			    ,text: '<t:message code="system.label.purchase.division" default="사업장"/>' 				,type: 'string'},
	    	{name: 'ORDER_PLAN_DATE'	    ,text: '<t:message code="system.label.purchase.poreservedate" default="발주예정일"/>' 			,type: 'uniDate'},
	    	{name: 'CUSTOM_CODE'		 	,text: '<t:message code="system.label.purchase.customcode" default="거래처코드"/>' 			,type: 'string'},
	    	{name: 'CUSTOM_NAME'		    ,text: '<t:message code="system.label.purchase.custom" default="거래처"/>' 				,type: 'string'},
	    	{name: 'ITEM_CODE'			    ,text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>' 				,type: 'string'},
	    	{name: 'ITEM_NAME'			    ,text: '<t:message code="system.label.purchase.itemname2" default="품명"/>' 					,type: 'string'},
	    	{name: 'SPEC'				    ,text: '<t:message code="system.label.purchase.spec" default="규격"/>' 					,type: 'string'},
	    	{name: 'ORDER_PLAN_Q'		    ,text: '발주예정량' 			,type: 'uniQty'},
	    	{name: 'STOCK_UNIT'			    ,text: '<t:message code="system.label.purchase.unit" default="단위"/>' 					,type: 'string'},
	    	{name: 'BASIS_DATE'			 	,text: '생산시작일' 			,type: 'uniDate'},
	    	{name: 'REQ_PLAN_Q'			    ,text: '<t:message code="system.label.purchase.requestqty" default="요청량"/>' 				,type: 'uniQty'},
	    	{name: 'SUPPLY_TYPE'		    ,text: '<t:message code="system.label.purchase.procurementclassification" default="조달구분"/>' 				,type: 'string' ,  comboType:'AU', comboCode:'B014'},
	    	{name: 'DOM_FORIGN' 		    ,text: '<t:message code="system.label.purchase.domesticoverseasclass" default="국내외구분"/>' 			,type: 'string' ,  comboType:'AU', comboCode:'B019'},
	    	{name: 'ORDER_REQ_DEPT_CODE'    ,text: '<t:message code="system.label.purchase.requestdepartment" default="요청부서"/>' 				,type: 'string'},
	    	{name: 'ORDER_PRSN'			    ,text: '<t:message code="system.label.purchase.purchasecharge" default="구매담당"/>' 				,type: 'string' ,  comboType:'AU', comboCode:'M201'},
	    	{name: 'ORDER_YN'			    ,text: '<t:message code="system.label.purchase.processstatus" default="진행상태"/>' 				,type: 'string'},
	    	{name: 'ORDER_REQ_NUM'		    ,text: '<t:message code="system.label.purchase.requestno" default="요청번호"/>' 				,type: 'string'},
	    	{name: 'MRP_CONTROL_NUM'	    ,text: '<t:message code="system.label.purchase.grgiplanno" default="수급계획번호"/>' 			,type: 'string'},
	    	{name: 'ITEM_ACCOUNT'		    ,text: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>' 				,type: 'string'},
	    	{name: 'PURCH_LDTIME'		    ,text: '리드타임' 				,type: 'string'},
	    	{name: 'CREATE_DATE'		  	,text: '<t:message code="system.label.purchase.requestdate" default="요청일"/>' 				,type: 'uniDate'},
	    	{name: 'MRP_YN'			  	 	,text: '소요량구분' 			,type: 'string'},
	    	{name: 'COMP_CODE'			    ,text: 'COMP_CODE' 				,type: 'string'}
		]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var MasterStore = Unilite.createStore('mrp180ukrvMasterStore',{
			model: 'Mrp180ukrvModel',
			uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable: true,			// 삭제 가능 여부 
	            useNavi : false			// prev | newxt 버튼 사용
            },
            autoLoad: false,
            proxy: directProxy
//            proxy: {
//                type: 'direct',
//                api: {			
//                	   read: 'mrp180ukrvService.selectList'                	
//                }
//            }
			,loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();			
				console.log( param );
				this.load({
					params : param
				});
			}
			,saveStore : function(config)	{	
				var inValidRecs = this.getInvalidRecords();
				var toCreate = this.getNewRecords();
            	var toUpdate = this.getUpdatedRecords();
            	console.log("toUpdate",toUpdate);

            	var rv = true;
       	
            	if(inValidRecs.length == 0 )	{										
					config = {
						success: function(batch, option) {								
							panelResult.resetDirtyStatus();
							UniAppManager.setToolbarButtons('save', false);			
						 } 
					};					
					this.syncAllDirect(config);
				}else {
					masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			}

			//groupField: 'CUSTOM_NAME'
	});

	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '<t:message code="system.label.purchase.searchconditon" default="검색조건"/>',		
        defaultType: 'uniSearchSubPanel',
        collapsed:true,
        listeners: {
	        collapse: function () {
	            panelResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
	        }
        },		
		items: [{	
			title: '<t:message code="system.label.purchase.basisinfo" default="기본정보"/>', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items : [{
				fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				allowBlank: false,
				value: UserInfo.divCode,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
					}
				} 				
			},{
				fieldLabel: '<t:message code="system.label.purchase.poreservedate" default="발주예정일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'ORDER_DATE_FR',
				endFieldName: 'ORDER_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				width: 315,
				allowBlank: false,
	    		onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('ORDER_DATE_FR',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('ORDER_DATE_TO',newValue);
			    	}
			    }				
			},{
				fieldLabel: '<t:message code="system.label.purchase.procurementclassification" default="조달구분"/>', 
				name:'SUPPLY_TYPE', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'B014',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('SUPPLY_TYPE', newValue);
					}
				}				
			},{
				fieldLabel: '<t:message code="system.label.purchase.domesticoverseasclass" default="국내외구분"/>', 
				name:'DOM_FORIGN', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'B019',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DOM_FORIGN', newValue);
					}
				}
			},{
				fieldLabel: '생산시작일',
				xtype: 'uniDateRangefield',
				startFieldName: 'BASIS_DATE_FR',
				endFieldName: 'BASIS_DATE_TO',
				//startDate: UniDate.get('startOfMonth'),
				//endDate: UniDate.get('today'),
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('BASIS_DATE_FR',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('BASIS_DATE_TO',newValue);
			    	}
			    }				
			},
				Unilite.popup('CUST',{
					fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>', 
					textFieldWidth: 70,
					valueFieldName:'CUSTOM_CODE',
				    textFieldName:'CUSTOM_NAME',
				    //validateBlank:false,
		        	listeners: {
						onSelected: {
						fn: function(records, type) {
							console.log('records : ', records);
							panelResult.setValue('CUSTOM_CODE', panelSearch.getValue('CUSTOM_CODE'));
							panelResult.setValue('CUSTOM_NAME', panelSearch.getValue('CUSTOM_NAME'));	
		            	},
						scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('CUSTOM_CODE', '');
							panelResult.setValue('CUSTOM_NAME', '');
						},
						applyextparam: function(popup){							
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}					
				}),
				Unilite.popup('DIV_PUMOK',{
					fieldLabel: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>', 
//					textFieldWidth: 70,
					valueFieldName:'ITEM_CODE',
				    textFieldName:'ITEM_NAME',
				    //validateBlank:false,
		        	listeners: {
						onSelected: {
						fn: function(records, type) {
							console.log('records : ', records);
							panelResult.setValue('ITEM_CODE', panelSearch.getValue('ITEM_CODE'));
							panelResult.setValue('ITEM_NAME', panelSearch.getValue('ITEM_NAME'));	
		            	},
						scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('ITEM_CODE', '');
							panelResult.setValue('ITEM_NAME', '');
						},
						applyextparam: function(popup){							
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}					
				})
			]	
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
		          		var labelText = invalid.items[0]['fieldLabel']+':';
		        	} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
		          		var labelText = invalid.items[0].ownerCt['fieldLabel']+':';
		        	}
					alert(labelText+Msg.sMB083);
		        	invalid.items[0].focus();
		     	} else {
		      		//this.mask();
		      		var fields = this.getForm().getFields();
		      		Ext.each(fields.items, function(item) {
		       			if(Ext.isDefined(item.holdable) ) {
		         			if (item.holdable == 'hold') {
		         				item.setReadOnly(true); 
		        			}
		       			} 
		       			if(item.isPopupField) {
		        			var popupFC = item.up('uniPopupField') ;       
		        			if(popupFC.holdable == 'hold') {
		         				popupFC.setReadOnly(true);
		        			}
		       			}
		      		})
		       	}
		    } else {
		    	//this.unmask();
		       	var fields = this.getForm().getFields();
		     	Ext.each(fields.items, function(item) {
		      		if(Ext.isDefined(item.holdable) ) {
		        		if (item.holdable == 'hold') {
		        			item.setReadOnly(false);
		       			}
		      		} 
		      		if(item.isPopupField) {
		       			var popupFC = item.up('uniPopupField') ; 
		       			if(popupFC.holdable == 'hold' ) {
		        			item.setReadOnly(false);
		      			}
		      		}
		     	})
		    }
		    return r;
		},
		setLoadRecord: function(record) {
			var me = this;   
		   	me.uniOpt.inLoading=false;
		    me.setAllFieldsReadOnly(true);
		}
	});
	
	var panelResult = Unilite.createSearchForm('panelResultForm', {		
    	//hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
	    items : [{
				fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				allowBlank: false,
				value: UserInfo.divCode,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('DIV_CODE', newValue);
					}
				} 				
			},{
				fieldLabel: '<t:message code="system.label.purchase.poreservedate" default="발주예정일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'ORDER_DATE_FR',
				endFieldName: 'ORDER_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				width: 315,
				allowBlank: false,
	    		onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelSearch.setValue('ORDER_DATE_FR',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelSearch.setValue('ORDER_DATE_TO',newValue);
			    	}
			    }				
			},{
				fieldLabel: '<t:message code="system.label.purchase.procurementclassification" default="조달구분"/>', 
				name:'SUPPLY_TYPE', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'B014',
				colspan: 2,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('SUPPLY_TYPE', newValue);
					}
				}				
			},{
				fieldLabel: '<t:message code="system.label.purchase.domesticoverseasclass" default="국내외구분"/>', 
				name:'DOM_FORIGN', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'B019',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('DOM_FORIGN', newValue);
					}
				}
			},{
				fieldLabel: '생산시작일',
				xtype: 'uniDateRangefield',
				startFieldName: 'BASIS_DATE_FR',
				endFieldName: 'BASIS_DATE_TO',
				//startDate: UniDate.get('startOfMonth'),
				//endDate: UniDate.get('today'),
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelSearch.setValue('BASIS_DATE_FR',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelSearch.setValue('BASIS_DATE_TO',newValue);
			    	}
			    }				
			},
				Unilite.popup('CUST',{
					fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>', 
					//textFieldWidth: 70,
					valueFieldName:'CUSTOM_CODE',
				    textFieldName:'CUSTOM_NAME',
				    validateBlank:false,
				    colspan: 2,
		        	listeners: {
						onSelected: {
						fn: function(records, type) {
							console.log('records : ', records);
							panelSearch.setValue('CUSTOM_CODE', panelResult.getValue('CUSTOM_CODE'));
							panelSearch.setValue('CUSTOM_NAME', panelResult.getValue('CUSTOM_NAME'));	
		            	},
						scope: this
						},
						onClear: function(type)	{
							panelSearch.setValue('CUSTOM_CODE', '');
							panelSearch.setValue('CUSTOM_NAME', '');
						},
						applyextparam: function(popup){							
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}					
				}),
				Unilite.popup('DIV_PUMOK',{
					fieldLabel: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>', 
					//textFieldWidth: 70,
					valueFieldName:'ITEM_CODE',
				    textFieldName:'ITEM_NAME',
				    validateBlank:false,
		        	listeners: {
						onSelected: {
						fn: function(records, type) {
							console.log('records : ', records);
							panelSearch.setValue('ITEM_CODE', panelResult.getValue('ITEM_CODE'));
							panelSearch.setValue('ITEM_NAME', panelResult.getValue('ITEM_NAME'));	
		            	},
						scope: this
						},
						onClear: function(type)	{
							panelSearch.setValue('ITEM_CODE', '');
							panelSearch.setValue('ITEM_NAME', '');
						},
						applyextparam: function(popup){							
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}					
				})
		],
		
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
		          		var labelText = invalid.items[0]['fieldLabel']+':';
		        	} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
		          		var labelText = invalid.items[0].ownerCt['fieldLabel']+':';
		        	}
					alert(labelText+Msg.sMB083);
		        	invalid.items[0].focus();
		     	} else {
		      		//this.mask();
		      		var fields = this.getForm().getFields();
		      		Ext.each(fields.items, function(item) {
		       			if(Ext.isDefined(item.holdable) ) {
		         			if (item.holdable == 'hold') {
		         				item.setReadOnly(true); 
		        			}
		       			} 
		       			if(item.isPopupField) {
		        			var popupFC = item.up('uniPopupField') ;       
		        			if(popupFC.holdable == 'hold') {
		         				popupFC.setReadOnly(true);
		        			}
		       			}
		      		})
		       	}
		    } else {
		    	//this.unmask();
		       	var fields = this.getForm().getFields();
		     	Ext.each(fields.items, function(item) {
		      		if(Ext.isDefined(item.holdable) ) {
		        		if (item.holdable == 'hold') {
		        			item.setReadOnly(false);
		       			}
		      		} 
		      		if(item.isPopupField) {
		       			var popupFC = item.up('uniPopupField') ; 
		       			if(popupFC.holdable == 'hold' ) {
		        			item.setReadOnly(false);
		      			}
		      		}
		     	})
		    }
		    return r;
		},
		setLoadRecord: function(record) {
			var me = this;   
		   	me.uniOpt.inLoading=false;
		    me.setAllFieldsReadOnly(true);
		}
	});    
		
	
	/**
     * Master Grid 정의
     * @type 
     */    
    var masterGrid = Unilite.createGrid('mrp180ukrvGrid', {
    	// for tab    	
        layout : 'fit',
        region:'center',
        uniOpt:{	expandLastColumn: true,
        			useRowNumberer: true,
                    useMultipleSorting: true
        },
//        tbar: [{
//        	text:'상세보기',
//        	handler: function() {
//        		var record = masterGrid.getSelectedRecord();
//	        	if(record) {
//	        		openDetailWindow(record);
//	        	}
//        	}
//        }],
    	store: MasterStore,
    	features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
        columns:  [        
               		 { dataIndex: 'DIV_CODE'			  			  				 , 	width:0, hidden: true},
               		 { dataIndex: 'ORDER_PLAN_DATE'	  			  				     , 	width:86, locked: true},
               		 { dataIndex: 'CUSTOM_CODE'		  			  				     , 	width:86, locked: true,
						'editor' : Unilite.popup('CUST_G', {		
							 		textFieldName: 'CUSTOM_CODE',
							 		DBtextFieldName: 'CUSTOM_CODE',
							 		//valueFieldName:'CUSTOM_CODE',
				    				//textFieldName:'CUSTOM_NAME',
							 		//extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode, POPUP_TYPE: 'GRID_CODE'},	
		                    		autoPopup: true,							
									listeners: {'onSelected': {
											fn: function(records, type) {									
						                    	var grdRecord;
						                    	var selectedRecords = masterGrid.getSelectionModel().getSelection();
												if(selectedRecords && selectedRecords.length > 0 ) {
													grdRecord= selectedRecords[0];
												}		                    	
												grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
												grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
											},
											scope: this
										},
										'onClear': function(type) {
					                  		var grdRecord;
					                    	var selectedRecords = masterGrid.getSelectionModel().getSelection();
											if(selectedRecords && selectedRecords.length > 0 ) {
												grdRecord= selectedRecords[0];
											}
											grdRecord.set('CUSTOM_CODE','');
											grdRecord.set('CUSTOM_NAME','');
										},
										applyextparam: function(popup){							
											popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
										}
									}
						})                		 
               		 },
               		 { dataIndex: 'CUSTOM_NAME'		  			  				     , 	width:160, locked: true,
						'editor' : Unilite.popup('CUST_G', {		
		                    		autoPopup: true,
									listeners: {'onSelected': {
					                    fn: function(records, type  ){
					                    	var grdRecord;
					                    	var selectedRecords = masterGrid.getSelectionModel().getSelection();
											if(selectedRecords && selectedRecords.length > 0 ) {
												grdRecord= selectedRecords[0];
											}		                    	
											grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
											grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
					                    },
					                    scope: this
									},
									'onClear': function(type) {
				                  		var grdRecord;
				                    	var selectedRecords = masterGrid.getSelectionModel().getSelection();
										if(selectedRecords && selectedRecords.length > 0 ) {
											grdRecord= selectedRecords[0];
										}		                    	
										grdRecord.set('CUSTOM_CODE','');
										grdRecord.set('CUSTOM_NAME','');
									},
									applyextparam: function(popup){							
										popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
									}
								}
						})  
               		 },	
               		 { dataIndex: 'ITEM_CODE'			  			  				 , 	width:113, locked: true,
						'editor' : Unilite.popup('DIV_PUMOK_G', {		
							 		textFieldName: 'ITEM_CODE',
							 		DBtextFieldName: 'ITEM_CODE',
							 		//extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode, POPUP_TYPE: 'GRID_CODE'},
		                    		autoPopup: true,
									listeners: {'onSelected': {
											fn: function(records, type) {
												console.log('records : ', records);
												Ext.each(records, function(record,i) {
													console.log('record',record);
													if(i==0) {
														masterGrid.setItemData(record,false, masterGrid.uniOpt.currentRecord);
													} else {
														UniAppManager.app.onNewDataButtonDown();
														masterGrid.setItemData(record,false, masterGrid.getSelectedRecord());
													}
												}); 
											},
											scope: this
										},
										'onClear': function(type) {
											masterGrid.setItemData(null,true, masterGrid.uniOpt.currentRecord);
										},
										applyextparam: function(popup){							
											popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
										}
									}
						})               		 
               		 },               		 
               		 { dataIndex: 'ITEM_NAME'			  			  				 , 	width:146, locked: true,
						'editor' : Unilite.popup('DIV_PUMOK_G', {		
							 		textFieldName: 'ITEM_CODE',
							 		DBtextFieldName: 'ITEM_CODE',
							 		//extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode, POPUP_TYPE: 'GRID_CODE'},
		                    		autoPopup: true,
									listeners: {'onSelected': {
											fn: function(records, type) {
												console.log('records : ', records);
												Ext.each(records, function(record,i) {
													console.log('record',record);
													if(i==0) {
														masterGrid.setItemData(record,false, masterGrid.uniOpt.currentRecord);
													} else {
														UniAppManager.app.onNewDataButtonDown();
														masterGrid.setItemData(record,false, masterGrid.getSelectedRecord());
													}
												}); 
											},
											scope: this
										},
										'onClear': function(type) {
											masterGrid.setItemData(null,true, masterGrid.uniOpt.currentRecord);
										},
										applyextparam: function(popup){							
											popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
										}
									}
						})                		 
               		 },
               		 { dataIndex: 'SPEC'				  			  				 , 	width:135, hidden: true},
               		 { dataIndex: 'ORDER_PLAN_Q'		  			  				 , 	width:106},
               		 { dataIndex: 'STOCK_UNIT'			  			  				 , 	width:56, align: 'center'},
               		 { dataIndex: 'BASIS_DATE'			  			  				 , 	width:86},
               		 { dataIndex: 'REQ_PLAN_Q'			  			  				 , 	width:113, hidden: true},
               		 { dataIndex: 'SUPPLY_TYPE'		  			  				     , 	width:66, align: 'center'},
               		 { dataIndex: 'DOM_FORIGN' 		  			  				     , 	width:80, align: 'center'},
               		 { dataIndex: 'ORDER_REQ_DEPT_CODE'  			  				 , 	width:66, hidden: true},
               		 { dataIndex: 'ORDER_PRSN'			  			  				 , 	width:66},
               		 { dataIndex: 'ORDER_YN'			  			  				 , 	width:66, hidden: true},
               		 { dataIndex: 'ORDER_REQ_NUM'		  			  				 , 	width:120},
               		 { dataIndex: 'MRP_CONTROL_NUM'	  			  				     , 	width:133},
               		 { dataIndex: 'ITEM_ACCOUNT'		  			  				 , 	width:66, hidden: true},
               		 { dataIndex: 'PURCH_LDTIME'		  			  				 , 	width:66, hidden: true},
               		 { dataIndex: 'CREATE_DATE'			  			  				 , 	width:0, hidden: true},
               		 { dataIndex: 'MRP_YN'			  			  					 , 	width:0, hidden: true},
               		 { dataIndex: 'COMP_CODE'			  			  				 , 	width:46, hidden: true}
        ],
		listeners: {
        	beforeedit: function( editor, e, eOpts ) {
        		if(e.record.phantom == false) {
        		 	if(UniUtils.indexOf(e.field, ['BUILD_CODE']))
				   	{
						return false;
      				} else {
      					return true;
      				}
        		} else {
        			if(UniUtils.indexOf(e.field))
				   	{
						return true;
      				}
        		}
        	} 	
        }, 
        setItemData: function(record, dataClear, grdRecord) {   
            var grdRecord = this.uniOpt.currentRecord;
            if(dataClear) {                
                grdRecord.set('ITEM_CODE'			, '');
                grdRecord.set('ITEM_NAME'           , '');
                grdRecord.set('STOCK_UNIT'      	, '');
                grdRecord.set('BASIS_DATE'           , '');
                grdRecord.set('SUPPLY_TYPE'      	, '');
                grdRecord.set('DOM_FORIGN'           , '');               
                
            } else {
                grdRecord.set('ITEM_CODE'          , record['ITEM_CODE']);
                grdRecord.set('ITEM_NAME'          , record['ITEM_NAME']);
                grdRecord.set('STOCK_UNIT'      	, record['STOCK_UNIT']);
                grdRecord.set('BASIS_DATE'      	, UniDate.get('tomorrow'));
                grdRecord.set('SUPPLY_TYPE'      	, record['SUPPLY_TYPE']);
                grdRecord.set('DOM_FORIGN'      	, record['DOM_FORIGN']);                
            }
        }        
    });   
	
    Unilite.Main( {
		borderItems:[{
			border: false,
			region: 'center',
			layout: 'border',
			items:[
				masterGrid, panelResult
			]
		}	 
		,panelSearch
		],
		id  : 'mrp180ukrvApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			
			UniAppManager.setToolbarButtons('newData', true);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
		},
		
		onQueryButtonDown : function()	{			
			if(panelSearch.setAllFieldsReadOnly(true) == false){
				return false;
			}
			if(panelResult.setAllFieldsReadOnly(true) == false){
				return false;
			}
			MasterStore.loadStoreRecords();
			
//			var viewLocked = masterGrid.lockedGrid.getView();
//			var viewNormal = masterGrid.normalGrid.getView();
//			console.log("viewLocked : ",viewLocked);
//			console.log("viewNormal : ",viewNormal);
//		    viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
//		    viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
//		    viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
//		    viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
		},

		onNewDataButtonDown: function()	{		// 행추가
			//if(containerclick(masterGrid)) {
				var compCode    	=	UserInfo.compCode;   
				var divCode 		=	panelSearch.getValue('DIV_CODE');
				var orderPlanDate	=	UniDate.get('today');
				var customCode		=	'';      
				var customName		=	'';      
				var itemCode        =	'';
				var itemName        =	'';
				var spec            =	'';
				var orderPlanQ      =	'';
				var stockUnit       =	'';
				var basisDate       =	'';
				var reqPlanQ        =	'';
				var supplyType      =	'';
				var domForign       =	'';
				var orderReqDeptCode=	'';
				var orderPrsn       =	'';
				var orderYn         =	'';
				var orderReqNum     =	'';
				var mrpControlNum   =	'';
				var itemAccount     =	'';
				var purchLdtime     =	'';
				var createDate      =	'';
				var mrpYn 			=	'';
				
				var r = {            
					DIV_CODE			: divCode,
					ORDER_PLAN_DATE	    : orderPlanDate,
					CUSTOM_CODE 		: customCode,
					CUSTOM_NAME		    : customName,
					ITEM_CODE			: itemCode,
					ITEM_NAME			: itemName,
					SPEC				: spec,
					ORDER_PLAN_Q		: orderPlanQ,
					STOCK_UNIT			: stockUnit,
					BASIS_DATE			: basisDate,
					REQ_PLAN_Q			: reqPlanQ,
					SUPPLY_TYPE		   	: supplyType,
					DOM_FORIGN 		    : domForign,
					ORDER_REQ_DEPT_CODE : orderReqDeptCode,
					ORDER_PRSN			: orderPrsn,
					ORDER_YN			: orderYn,
					ORDER_REQ_NUM		: orderReqNum,
					MRP_CONTROL_NUM	    : mrpControlNum,
					ITEM_ACCOUNT		: itemAccount,
					PURCH_LDTIME		: purchLdtime,
					CREATE_DATE		  	: createDate,
					MRP_YN			  	: mrpYn,
					COMP_CODE           : compCode		
				};
				masterGrid.createRow(r);
		},
		
		onDeleteDataButtonDown: function() {
			if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				masterGrid.deleteSelectedRow();
			}
		},
		
		/*confirmSaveData: function(config)	{	// 저장하기전 원복 시키는 작업
			if(confirm(Msg.sMB061))	{
				this.onSaveDataButtonDown(config);
			} else {
				//this.rejectSave();
			}
		},*/
		
		onSaveDataButtonDown: function(config) {	// 저장 버튼
			MasterStore.saveStore();
		}		
		
//		onDetailButtonDown:function() {
//			var as = Ext.getCmp('AdvanceSerch');	
//			if(as.isHidden())	{
//				as.show();
//			}else {
//				as.hide()
//			}
//		}
	});
};

</script>
