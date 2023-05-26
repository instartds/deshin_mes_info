<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="arc110ukr"  >
	<t:ExtComboStore comboType="AU" comboCode="J501" /> <!-- 채권구분 -->
	<t:ExtComboStore comboType="AU" comboCode="J502" /> <!-- 이관취소사유 -->
	<t:ExtComboStore comboType="AU" comboCode="J503" /> <!-- 접수상태 -->
	<t:ExtComboStore comboType="AU" comboCode="J504" /> <!-- 진행상태 -->
	<t:ExtComboStore comboType="AU" comboCode="J682" /> <!-- 결재상태(내부결재) -->
	
	
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
<script type="text/javascript" >
var getChargeCode = ${getChargeCode};

if(getChargeCode == '' ){
	getChargeCode = [{"SUB_CODE":""}];
}
var subFormWindow;

var mainGridReceiveRecord = '';

function appMain() {
	
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'arc110ukrService.selectList',
			update: 'arc110ukrService.updateDetail',
			syncAll: 'arc110ukrService.saveAll'
		}
	});	
	
	
	var directProxyDeadline = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			create: 'arc110ukrService.insertDeadlineDetail',
			syncAll: 'arc110ukrService.saveDeadlineAll'
		}
	});	
	
	var directProxyRequest = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			create: 'arc110ukrService.insertRequestDetail',
			syncAll: 'arc110ukrService.saveRequestAll'
		}
	});	
	
	
	
	
	
	
	var directProxyButton = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            create: 'arc110ukrService.insertDetailButton',
            syncAll: 'arc110ukrService.saveAllButton'
        }
    }); 
    
    var directProxyRequest = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            create: 'arc110ukrService.insertDetailRequest',
            syncAll: 'arc110ukrService.saveAllRequest'
        }
    }); 
	
	
	
	/**
	 *   Model 정의 
	 * @type 
	 */

	Unilite.defineModel('arc110ukrModel', {
	    fields: [
	    	{name: 'CHECK_VALUE'		,text: 'check'					,type: 'string'},
	    	{name: 'ROW_NUMBER'			,text: 'NO'						,type: 'int'},
	    	{name: 'DOC_STATUS'			,text: '결재상태'					,type: 'string', comboType:'AU', comboCode:'J682'},
	    	{name: 'DOC_STATUS_DETAIL'        ,text: '결재상태_REF_CODE1' ,type: 'string'},
	    	{name: 'ACCEPT_STATUS'		,text: '접수상태'					,type: 'string', comboType:'AU', comboCode:'J503'},
	    	{name: 'RECE_DATE'			,text: '접수일'					,type: 'uniDate'},
	    	{name: 'CONF_RECE_DATE'		,text: '이관일'					,type: 'uniDate'},
	    	{name: 'COMP_CODE'			,text: '회사코드'					,type: 'string'},
	    	{name: 'COMP_NAME'			,text: '회사명'					,type: 'string'},
	    	{name: 'CUSTOM_CODE'		,text: '거래처'					,type: 'string'},
	    	{name: 'CUSTOM_NAME'		,text: '거래처명'					,type: 'string'},
	    	{name: 'TOP_NAME'			,text: '대표자'					,type: 'string'},
	    	{name: 'RECE_GUBUN'			,text: '채권구분'					,type: 'string', comboType:'AU', comboCode:'J501'},
	    	{name: 'RECE_AMT'			,text: '금액'						,type: 'uniPrice'},
	    	{name: 'DRAFTER_NAME'		,text: '작성자'					,type: 'string'},
	    	{name: 'CANCEL_REASON'		,text: '접수마감사유'				,type: 'string', comboType:'AU', comboCode:'J502'},
	    	{name: 'RECE_NO'			,text: '채권접수번호'				,type: 'string'},
	    	{name: 'GWIF_ID'			,text: '결재연동번호'				,type: 'string'}
		]
	});
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directDetailStore = Unilite.createStore('arc110ukrDetailStore', {
		model: 'arc110ukrModel',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결 
			editable: false,			// 수정 모드 사용 
			deletable: false,			// 삭제 가능 여부 
			allDeletable:false,
			useNavi : false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: directProxy,
		saveStore: function() {				
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			var toCreate = this.getNewRecords();
       		var toUpdate = this.getUpdatedRecords();        		
       		var toDelete = this.getRemovedRecords();
       		var list = [].concat(toUpdate, toCreate);
			console.log("list:", list);
			var paramMaster= panelResult.getValues();	
			
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						var master = batch.operations[0].getResultSet();
						panelSearch.getForm().wasDirty = false;
						panelSearch.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);		
						
						directDetailStore.loadStoreRecords();
						
					/*	if (directDetailStore.count() == 0) {   
							UniAppManager.app.onResetButtonDown();
						}else{
							UniAppManager.app.onQueryButtonDown();
						}*/
					 } 
				};
				this.syncAllDirect(config);
			} else {
                var grid = Ext.getCmp('arc110ukrGrid');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		
		listeners: {
           	load: function(store, records, successful, eOpts) {
        	/*	if(store.getCount() > 0){
        			UniAppManager.setToolbarButtons(['print'], true);
        		}else{
        			UniAppManager.setToolbarButtons(['print'], true);
        		}*/
           	},
           	add: function(store, records, index, eOpts) {
           	},
           	update: function(store, record, operation, modifiedFieldNames, eOpts) {
           	},
           	remove: function(store, record, index, isMove, eOpts) {
           	}
		},
		loadStoreRecords: function(){
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params: param
			});
		}
	});
	
	var deadlineButtonStore = Unilite.createStore('Arc110ukrDeadlineButtonStore',{		
		uniOpt: {
			isMaster: false,			// 상위 버튼 연결 
			editable: false,			// 수정 모드 사용 
			deletable: false,			// 삭제 가능 여부 
			useNavi : false			// prev | newxt 버튼 사용
		},
		proxy: directProxyDeadline,
		saveStore: function() {
			var paramMaster = panelResult.getValues();
			paramMaster.CANCEL_REASON = subForm.getValue('CANCEL_REASON');
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						var master = batch.operations[0].getResultSet();
						
						directDetailStore.loadStoreRecords();
//						UniAppManager.app.onQueryButtonDown();
					 },
					 failure: function(batch, option) {
					 
					 }
				};
				this.syncAllDirect(config);
		},
		listeners: {
           	load: function(store, records, successful, eOpts) {
           	},
           	add: function(store, records, index, eOpts) {
           	},
           	update: function(store, record, operation, modifiedFieldNames, eOpts) {
           	},
           	remove: function(store, record, index, isMove, eOpts) {
           	}
		}
	});
	
	var requestButtonStore = Unilite.createStore('Arc110ukrRequestButtonStore',{		
		uniOpt: {
			isMaster: false,			// 상위 버튼 연결 
			editable: false,			// 수정 모드 사용 
			deletable: false,			// 삭제 가능 여부 
			useNavi : false			// prev | newxt 버튼 사용
		},
		proxy: directProxyRequest,
		saveStore: function() {				
			var inValidRecs = this.getInvalidRecords();
//			var toCreate = branchStore.data.items;
			var toCreate = this.getNewRecords();
       		var toUpdate = this.getUpdatedRecords();        		
       		var toDelete = this.getRemovedRecords();
//       		var paramList = branchStore.data.items;
			var paramMaster = panelResult.getValues();	//syncAll 수정
//			param.FR_INPUT_DATE = UniDate.getDbDateStr(panelSearch.getValue('FR_INPUT_DATE'));
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						var master = batch.operations[0].getResultSet();
						
						UniAppManager.app.onQueryButtonDown();
//						,,,,,,,,,,
					/*	panelSearch.getForm().wasDirty = false;
						panelSearch.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);		*/
						
					/*	if(panelResult.getValue('BRANCH_OPR_FLAG') == 'B' || panelResult.getValue('BRANCH_OPR_FLAG') == 'C'){
							UniAppManager.updateStatus(Msg.fsbMsgB0076);
						}else if(panelResult.getValue('BRANCH_OPR_FLAG') == 'R'){
							UniAppManager.updateStatus(Msg.fSbMsgA0526);
						}
						
						panelResult.setValue('BRANCH_OPR_FLAG', '');
						UniAppManager.app.onQueryButtonDown();*/
					 },
					 failure: function(batch, option) {
					 
					 }
				};
				this.syncAllDirect(config);
			} else {
                var grid = Ext.getCmp('arc110ukrGrid');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
           	load: function(store, records, successful, eOpts) {
           	},
           	add: function(store, records, index, eOpts) {
           	},
           	update: function(store, record, operation, modifiedFieldNames, eOpts) {
           	},
           	remove: function(store, record, index, isMove, eOpts) {
           	}
		}
	});
	
	
	
	
	
	
	
	
	var buttonStore = Unilite.createStore('Arc110ukrbuttonStore',{     
        uniOpt: {
            isMaster: false,            // 상위 버튼 연결 
            editable: false,            // 수정 모드 사용 
            deletable: false,           // 삭제 가능 여부 
            useNavi : false         // prev | newxt 버튼 사용
        },
        proxy: directProxyButton,
        saveStore: function() {             
            var inValidRecs = this.getInvalidRecords();

            var paramMaster = panelResult.getValues();
            
            paramMaster.BUTTON_FLAG = buttonFlag;
            
            if(buttonFlag == 'RD'){
                paramMaster.CANCEL_REASON = subForm.getValue('CANCEL_REASON');
            }
//          param.FR_INPUT_DATE = UniDate.getDbDateStr(panelSearch.getValue('FR_INPUT_DATE'));

                config = {
                    params: [paramMaster],
                    success: function(batch, option) {
                        var master = batch.operations[0].getResultSet();
                        
                        buttonFlag = '';
                        UniAppManager.app.onQueryButtonDown();

                    },
                    failure: function(batch, option) {
                        buttonFlag = '';
                        
                        
                    }
                };
                this.syncAllDirect(config);
            
        },
        listeners: {
            load: function(store, records, successful, eOpts) {
            },
            add: function(store, records, index, eOpts) {
            },
            update: function(store, record, operation, modifiedFieldNames, eOpts) {
            },
            remove: function(store, record, index, isMove, eOpts) {
            }
        }
    });
    
    var requestStore = Unilite.createStore('Abh220ukrRequestStore',{      
        uniOpt: {
            isMaster: false,            // 상위 버튼 연결 
            editable: false,            // 수정 모드 사용 
            deletable: false,           // 삭제 가능 여부 
            useNavi : false         // prev | newxt 버튼 사용
        },
        proxy: directProxyRequest,
        saveStore: function() {             
            
            var paramMaster = panelResult.getValues(); 
//          param.FR_INPUT_DATE = UniDate.getDbDateStr(panelSearch.getValue('FR_INPUT_DATE'));
            config = {
                params: [paramMaster],
                success: function(batch, option) {
                    var master = batch.operations[0].getResultSet();
                    
                    UniAppManager.app.onQueryButtonDown();
                    
                },
                failure: function(batch, option) {
                 
                    
                }
            };
            this.syncAllDirect(config);
        }
    });
	
	
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '검색조건',
        defaultType: 'uniSearchSubPanel',
        collapsed: UserInfo.appOption.collapseLeftSearch,
        listeners: {
	        collapse: function () {
	        	panelResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
	        }
	    },
		items: [{	
			title: '기본정보', 	
	   		itemId: 'search_panel1',
	        layout: {type: 'uniTable', columns: 1},
	        defaultType: 'uniTextfield',
			items: [{ 
	    		fieldLabel: '등록일',
			    xtype: 'uniDateRangefield',
			    startFieldName: 'RECE_DATE_FR',
			    endFieldName: 'RECE_DATE_TO',
			    startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
			    allowBlank: false,                	
	//			    deadlineable:'deadline',
	            onStartDateChange: function(field, newValue, oldValue, eOpts) {
	            	if(panelSearch) {
						panelResult.setValue('RECE_DATE_FR', newValue);
					}
	            },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelResult.setValue('RECE_DATE_TO', newValue);				    		
			    	}
			    }
			},
			Unilite.popup('COMP',{
				fieldLabel: '회사정보', 
				valueFieldName:'COMP_CODE',
			    textFieldName:'COMP_NAME',
			    validateBlank: false,
			    listeners: {
			    	onValueFieldChange: function(field, newValue){
						panelResult.setValue('COMP_CODE', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('COMP_NAME', newValue);				
					}
				}
			}),			
			{ 
	    		fieldLabel: '이관일',
			    xtype: 'uniDateRangefield',
			    startFieldName: 'CONF_RECE_DATE_FR',
			    endFieldName: 'CONF_RECE_DATE_TO',
	//		    startDate: UniDate.get('startOfMonth'),
	//			endDate: UniDate.get('today'),
	            onStartDateChange: function(field, newValue, oldValue, eOpts) {
	            	if(panelSearch) {
						panelResult.setValue('CONF_RECE_DATE_FR', newValue);
					}
	            },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelResult.setValue('CONF_RECE_DATE_TO', newValue);				    		
			    	}
			    }
			},				
			Unilite.popup('CUST',{
				fieldLabel: '거래처', 
				valueFieldName:'CUSTOM_CODE',
			    textFieldName:'CUSTOM_NAME',
			    validateBlank: false,
			    listeners: {
			    	onValueFieldChange: function(field, newValue){
						panelResult.setValue('CUSTOM_CODE', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('CUSTOM_NAME', newValue);				
					}
				}
			}),
			
			Unilite.popup('Employee',{
				fieldLabel: '작성자', 
				valueFieldWidth: 90,
				textFieldWidth: 140,
				valueFieldName:'DRAFTER',
			    textFieldName:'DRAFTER_NAME',
			    listeners: {
			    	onValueFieldChange: function(field, newValue){
						panelResult.setValue('DRAFTER', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('DRAFTER_NAME', newValue);				
					}
				}
			}),	
			{
                xtype: 'uniCombobox',
                fieldLabel: '결재상태',
                name:'DOC_STATUS',   
                comboType:'AU',
                comboCode:'J682',
                width: 325,
                multiSelect: true, 
                typeAhead: false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelResult.setValue('DOC_STATUS', newValue);
                    }
                }
            },{
				xtype: 'container',
				layout: {type : 'uniTable', columns : 2},
				width:500,
	//			colspan:2,
				items :[{
					xtype: 'radiogroup',		            		
					fieldLabel: '접수상태',
	//				colspan:2,
//					id: 'asStatus',
					items: [{
						boxLabel: '전체', 
						width: 45,
						name: 'ACCEPT_STATUS',
						inputValue: '',
						checked: true  
					},{
						boxLabel: '미접수', 
						width: 55,
						name: 'ACCEPT_STATUS',
						inputValue: '1' 
					},{
						boxLabel: '접수', 
						width: 45,
						name: 'ACCEPT_STATUS',
						inputValue: '2'
					},{
						boxLabel: '마감', 
						width: 45,
						name: 'ACCEPT_STATUS',
						inputValue: '3'
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {	
							panelResult.getField('ACCEPT_STATUS').setValue(newValue.ACCEPT_STATUS);					
						
							UniAppManager.app.onQueryButtonDown();
						}
					}
				},{
		    		xtype: 'uniCheckboxgroup',	
		    		fieldLabel: '',
		    		items: [{
		    			boxLabel: '마감제외',
//			    			width: 130,
		    			name: 'Check_Opt2',
		    			inputValue: 'Y',
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {
								panelResult.setValue('Check_Opt2', newValue);
							}
						}
		    		}]
				}]
			},{
				xtype: 'uniCombobox',
				fieldLabel: '접수마감사유',
				name:'CANCEL_REASON',	
			    comboType:'AU',
				comboCode:'J502',
	//			width:450,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('CANCEL_REASON', newValue);
					}
				}
			}]
		},{
			title: '추가정보',	
	   		itemId: 'search_panel2',
	        layout: {type: 'uniTable', columns: 1},
	        defaultType: 'uniTextfield',
			items: [{
	    		xtype:'uniTextfield',
	    		fieldLabel:'채권번호',
	    		name:'RECE_NO'
	    	},{
	    		xtype:'uniTextfield',
	    		fieldLabel:'이관채권번호',
	    		name:'CONF_RECE_NO'
	    	}]
		}]
	});
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		layout : {type : 'uniTable', columns : 2
//		tableAttrs: { /*style: 'border : 1px solid #ced9e7;',*/width: '100%'}
//        	tdAttrs: {style: 'border : 1px solid #ced9e7;'/*width: '100%'/*,align : 'left'*/}
		
		},
		padding:'1 1 1 1',
		border:true,
		items: [{ 
    		fieldLabel: '등록일',
		    xtype: 'uniDateRangefield',
		    startFieldName: 'RECE_DATE_FR',
		    endFieldName: 'RECE_DATE_TO',
		    startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today'),
		    allowBlank: false,                	
//			    deadlineable:'deadline',
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelResult) {
					panelSearch.setValue('RECE_DATE_FR', newValue);
				}
            },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelResult) {
		    		panelSearch.setValue('RECE_DATE_TO', newValue);				    		
		    	}
		    }
		},
		Unilite.popup('COMP',{
			fieldLabel: '회사정보', 
			valueFieldName:'COMP_CODE',
		    textFieldName:'COMP_NAME',
		    validateBlank: false,
		    listeners: {
		    	onValueFieldChange: function(field, newValue){
					panelSearch.setValue('COMP_CODE', newValue);								
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('COMP_NAME', newValue);				
				}
			}
		}),			
		{ 
    		fieldLabel: '이관일',
		    xtype: 'uniDateRangefield',
		    startFieldName: 'CONF_RECE_DATE_FR',
		    endFieldName: 'CONF_RECE_DATE_TO',
//		    startDate: UniDate.get('startOfMonth'),
//			endDate: UniDate.get('today'),
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelResult) {
					panelSearch.setValue('CONF_RECE_DATE_FR', newValue);
				}
            },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelResult) {
		    		panelSearch.setValue('CONF_RECE_DATE_TO', newValue);				    		
		    	}
		    }
		},				
		Unilite.popup('CUST',{
			fieldLabel: '거래처', 
			valueFieldName:'CUSTOM_CODE',
		    textFieldName:'CUSTOM_NAME',
		    validateBlank: false,
		    listeners: {
		    	onValueFieldChange: function(field, newValue){
					panelSearch.setValue('CUSTOM_CODE', newValue);								
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('CUSTOM_NAME', newValue);				
				}
			}
		}),
		Unilite.popup('Employee',{
			fieldLabel: '작성자', 
			valueFieldWidth: 90,
			textFieldWidth: 140,
			valueFieldName:'DRAFTER',
		    textFieldName:'DRAFTER_NAME',
		    listeners: {
		    	onValueFieldChange: function(field, newValue){
					panelSearch.setValue('DRAFTER', newValue);								
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('DRAFTER_NAME', newValue);				
				}
			}
		}),	
		{
            xtype: 'uniCombobox',
            fieldLabel: '결재상태',
            name:'DOC_STATUS',   
            comboType:'AU',
            comboCode:'J682',
            width: 325,
            multiSelect: true, 
            typeAhead: false,
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {                        
                    panelSearch.setValue('DOC_STATUS', newValue);
                }
            }
        },{
			xtype: 'container',
			layout: {type : 'uniTable', columns : 2},
			width:600,
//			colspan:2,
			items :[{
				xtype: 'radiogroup',		            		
				fieldLabel: '접수상태',
//				colspan:2,
//				id: 'acceptStatusPr',
				items: [{
					boxLabel: '전체', 
					width: 50,
					name: 'ACCEPT_STATUS',
					inputValue: '',
					checked: true  
				},{
					boxLabel: '미접수', 
					width: 60,
					name: 'ACCEPT_STATUS',
					inputValue: '1' 
				},{
					boxLabel: '접수', 
					width: 50,
					name: 'ACCEPT_STATUS',
					inputValue: '2'
				},{
					boxLabel: '마감', 
					width: 50,
					name: 'ACCEPT_STATUS',
					inputValue: '3'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {	
						
						panelSearch.getField('ACCEPT_STATUS').setValue(newValue.ACCEPT_STATUS);					
						
						UniAppManager.app.onQueryButtonDown();
					}
				}
			},{
	    		xtype: 'uniCheckboxgroup',	
	    		fieldLabel: '',
	    		items: [{
	    			boxLabel: '마감제외',
	    			width: 130,
	    			name: 'Check_Opt2',
	    			inputValue: 'Y',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelSearch.setValue('Check_Opt2', newValue);
						}
					}
	    		}]
			}]
		},{
			xtype: 'uniCombobox',
			fieldLabel: '접수마감사유',
			name:'CANCEL_REASON',	
		    comboType:'AU',
			comboCode:'J502',
//			width:450,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('CANCEL_REASON', newValue);
				}
			}
		}]
    });		
    var detailGrid = Unilite.createGrid('arc110ukrGrid', {
		layout: 'fit',
		region: 'center',
		excelTitle: '채권접수',
		uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: false,
			useMultipleSorting: true,
			onLoadSelectFirst: false,
			useRowNumberer: false,
			expandLastColumn: false,
			useRowContext: true,
    		state: {
				useState: true,			
				useStateList: true		
			}
        },
		features: [{
			id: 'detailGridSubTotal', 
			ftype: 'uniGroupingsummary', 
			showSummaryRow: false
		},{
			id: 'detailGridTotal', 
			ftype: 'uniSummary', 
			showSummaryRow: false
		}],
		tbar:[{
            xtype: 'button',
            text: '접수',   
            id: 'btnReceipt',
            name: '',
            width: 80,  
//          disabled:true,
            handler : function() {
                var selectedRecords = detailGrid.getSelectedRecords();
                if(selectedRecords.length > 0){
                    buttonStore.clearData();
                    Ext.each(selectedRecords, function(record,i){
                        record.phantom = true;
                        buttonStore.insert(i, record);
                    });
                    buttonFlag = 'R';
                    buttonStore.saveStore();
                }else{
                    Ext.Msg.alert('확인','접수 할 데이터를 선택해 주세요.');   
                }
            }
        },{
            xtype: 'button',
            text: '미접수',   
            id: 'btnReceiptCancel',
            name: '',
            width: 80,  
//          disabled:true,
            handler : function() {
                var selectedRecords = detailGrid.getSelectedRecords();
                if(selectedRecords.length > 0){
                    buttonStore.clearData();
                    Ext.each(selectedRecords, function(record,i){
                        record.phantom = true;
                        buttonStore.insert(i, record);
                    });
                    buttonFlag = 'RC';
                    buttonStore.saveStore();
                }else{
                    Ext.Msg.alert('확인','미접수 할 데이터를 선택해 주세요.');   
                }
            }
        },'','',{
            xtype: 'button',
            text: '접수마감',   
            id: 'btnReceiptDeadline',
            name: '',
            width: 80,  
//          disabled:true,
            handler : function() {
                var selectedRecords = detailGrid.getSelectedRecords();
                if(selectedRecords.length > 0){
                    buttonStore.clearData();
                    Ext.each(selectedRecords, function(record,i){
                        record.phantom = true;
                        buttonStore.insert(i, record);
                    });
                    buttonFlag = 'RD';
                    
                    openSubFormWindow();
                }else{
                    Ext.Msg.alert('확인','접수마감 할 데이터를 선택해 주세요.');   
                }
            }
        },'','',{
            xtype: 'button',
            text: '결재요청',   
            id: 'btnRequest',
            name: '',
            width: 80,  
//          disabled:true,
            handler : function() {
                var selectedRecords = detailGrid.getSelectedRecords();
                
                if(!Ext.isEmpty(selectedRecords)){
                    if(confirm('선택한 채권접수내역을 결재요청 처리하시겠습니까?')) { 
                        var sm = detailGrid.getSelectionModel();
                        var selRecords = detailGrid.getSelectionModel().getSelection();
                        Ext.each(selectedRecords, function(record,i){
                            if(record.get('ACCEPT_STATUS') != '2' || record.get('DOC_STATUS_DETAIL') != '10'){
                                alert(record.get('ROW_NUMBER') + "번째 이채권접수내역은 접수 상태가 아니거나 입력상태가 아닙니다.\n 접수 상태이면서 입력상태인 데이터만 결재요청이 가능합니다.");

                                sm.deselect(selRecords[i]);
                            }
                        });
                        
                        var newSelectedRecords = detailGrid.getSelectedRecords();
                        
                        if(!Ext.isEmpty(newSelectedRecords)){
                            requestStore.clearData();
                            Ext.each(newSelectedRecords, function(record,i){
                                record.phantom = true;
                                requestStore.insert(i, record);
                            });
                            
                            requestStore.saveStore(); 
                            
                        }else{
                            Ext.Msg.alert('확인','결재요청 처리할 데이터를 선택해 주세요.');
                        }
                    }else{
                       return false;    
                    }
                }else{
                    Ext.Msg.alert('확인','결재요청 처리할 데이터를 선택해 주세요.');
                }
            }
        },'->','->','->','->','->','->','->','->','->','->','->','->','->','->','->','->','->','->','->'],
		store: directDetailStore,
		selModel: Ext.create('Ext.selection.CheckboxModel', {checkOnly: true,
			listeners: {  
				select: function(grid, selectRecord, index, rowIndex, eOpts ){
					
					selectRecord.set('CHECK_VALUE','Y');
					
				},
				deselect:  function(grid, selectRecord, index, eOpts ){
					
					selectRecord.set('CHECK_VALUE','');
					
				}
			}
        }),
		columns: [
			{ dataIndex: 'CHECK_VALUE'			,width:60,hidden:true},
        	{ dataIndex: 'ROW_NUMBER'			,width:60, align:'center'},

			{ dataIndex: 'DOC_STATUS'				,width:100, align:'center'},
			{ dataIndex: 'DOC_STATUS_DETAIL'                ,width:100, align:'center',hidden:true},
			{ dataIndex: 'ACCEPT_STATUS'			,width:100, align:'center'},
			{ dataIndex: 'RECE_DATE'				,width:100, align:'center'},
			{ dataIndex: 'CONF_RECE_DATE'			,width:100, align:'center'},
			{ dataIndex: 'COMP_CODE'				,width:100},
			{ dataIndex: 'COMP_NAME'				,width:100},
			{ dataIndex: 'CUSTOM_CODE'				,width:100},
			{ dataIndex: 'CUSTOM_NAME'				,width:100},
			{ dataIndex: 'TOP_NAME'					,width:100, align:'center'},
			{ dataIndex: 'RECE_GUBUN'				,width:100, align:'center'},
			{ dataIndex: 'RECE_AMT'					,width:100},
			{ dataIndex: 'DRAFTER_NAME'				,width:100, align:'center'},
			{ dataIndex: 'CANCEL_REASON'			,width:100},
			{ dataIndex: 'RECE_NO'					,width:100},
			{ dataIndex: 'GWIF_ID'					,width:100}
        ],
        uniRowContextMenu:{
            items: [
                {   text: '채권등록 보기',   
                    handler: function(menuItem, event) {
                        var param = menuItem.up('menu');
                        detailGrid.gotoArc100ukr(param.record);
                    }
                }
            ]
        },
        listeners: {
        	itemmouseenter:function(view, record, item, index, e, eOpts )  {  
                view.ownerGrid.setCellPointer(view, item);
            }
		},
		onItemcontextmenu:function( menu, grid, record, item, index, event  ) { 
            return true;
        },
        gotoArc100ukr:function(record)  {
            if(record)  {
                var params = {
                    action:'select', 
                    'PGM_ID' : 'arc110ukr',
                    'RECE_NO' : record.data['RECE_NO']
                    
                    //파라미터 추후 추가
                }
                var rec1 = {data : {prgID : 'arc100ukr', 'text':''}};                           
                parent.openTab(rec1, '/accnt/arc100ukr.do', params);
            }
        }
    });   
    
    var subForm = Unilite.createSimpleForm('resultForm2',{
		region: 'center',
    	border:true,
	    items: [{
			xtype: 'container',
			layout: {type : 'uniTable', columns : 1},
			width:150,
			tdAttrs: {align : 'center'},
			items :[{
				xtype: 'uniCombobox',
				fieldLabel: '마감사유',
				name:'CANCEL_REASON',	
			    comboType:'AU',
				comboCode:'J502'
			}]
	    }]
    });	
  	function openSubFormWindow() {    		
//  		if(!UniAppManager.app.checkForNewDetail()) return false;

		if(!subFormWindow) {
			subFormWindow = Ext.create('widget.uniDetailWindow', {
                width: 300,				                
        		height: 90,
                layout:{type:'vbox', align:'stretch'},
                items: [subForm],
                tbar:  [
					'->',{	
						itemId : 'saveBtn',
						text: '확인',
						handler: function() {
							
							buttonStore.saveStore();
							subForm.clearForm();
							subFormWindow.hide();
						},
						disabled: false
					},{
						itemId : 'closeBtn',
						text: '닫기',
						handler: function() {
							subForm.clearForm();
							subFormWindow.hide();
//							draftNoGrid.reset();
//							draftNoSearch.clearForm();
						},
						disabled: false
					}
				],
                listeners : {
                	beforehide: function(me, eOpt)	{

					},
		 			beforeclose: function( panel, eOpts )	{

		 			},
		 			
		 			show: function ( panel, eOpts )	{
		 				
		 			}
		 			
				}
			})
		}
		subFormWindow.center();
		subFormWindow.show();
    }
    Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				panelResult, detailGrid
			]	
		},
			panelSearch
		],
		id  : 'arc110ukrApp',
		fnInitBinding: function(){
			UniAppManager.setToolbarButtons(['newData'], false);
			UniAppManager.setToolbarButtons(['reset'], true);
			this.setDefault();
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('RECE_DATE_FR');
		},
		onQueryButtonDown: function() {      
			if(!panelResult.getInvalidMessage()) return;	//필수체크
			
			directDetailStore.loadStoreRecords();		
		},
/*		onNewDataButtonDown: function()	{
			if(!panelResult.getInvalidMessage()) return;	//필수체크
		
//			 var compCode = UserInfo.compCode;
        	 
        	 var r = {
			
//				COMP_CODE: compCode
	        };
			detailGrid.createRow(r);
		},*/
		onResetButtonDown: function() {
//			panelSearch.clearForm();
//			panelResult.clearForm();
//			panelSearch.clearForm();
//            panelResult.clearForm();
//			this.setDefault();
			detailGrid.reset();
			directDetailStore.clearData();
			
			UniAppManager.setToolbarButtons('save', false);
		},
    
		onSaveDataButtonDown: function(config) {				
			directDetailStore.saveStore();

			
		},
		
	/*	onDeleteDataButtonDown: function() {
			var selRow = detailGrid.getSelectedRecord();
			
			if(selRow.phantom === true)	{
				detailGrid.deleteSelectedRow();
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				if(selRow.get('EX_DATE') == ''){
					detailGrid.deleteSelectedRow();
				}else{
					Ext.Msg.alert('확인','전표가 생성된 데이터 입니다.\n 삭제가 불가능 합니다.');
				}

			}
		},*/
		/*onDeleteAllButtonDown: function() {			
			var records = directDetailStore.data.items;
			var isNewData = false;
			Ext.each(records, function(record,i) {
				if(record.phantom){						//신규 레코드일시 isNewData에 true를 반환
					isNewData = true;
				}else{									//신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
					if(confirm('전체삭제 하시겠습니까?')) {
						var deletable = true;
						if(deletable){		
							detailGrid.reset();			
							UniAppManager.app.onSaveDataButtonDown();	
						}
						isNewData = false;							
					}
					return false;
				}
			});
			if(isNewData){								//신규 레코드들만 있을시 그리드 리셋		   
				detailGrid.reset();
				UniAppManager.app.onResetButtonDown();	//삭제후 RESET..
			}
		},*/
		setDefault: function(){
			
			panelSearch.setValue('RECE_DATE_FR', UniDate.get('startOfMonth'));
			panelSearch.setValue('RECE_DATE_TO', UniDate.get('today'));
			panelResult.setValue('RECE_DATE_FR', UniDate.get('startOfMonth'));
			panelResult.setValue('RECE_DATE_TO', UniDate.get('today'));
			
			panelSearch.getField('ACCEPT_STATUS').setValue('');	
			panelResult.getField('ACCEPT_STATUS').setValue('');	
		}
/*		onPrintButtonDown: function() {
	         //var records = panelSearch.down('#imageList').getSelectionModel().getSelection();
	         var param= Ext.getCmp('resultForm').getValues();
	         
	         var prgId = '';
	         
	         
//	         if(라디오 값에따라){
//	         	prgId = 'abh220rkr';	
//	         }else if{
//	         	prgId = 'abh221rkr';
//	         }
	         
	         
	         var win = Ext.create('widget.PDFPrintWindow', {
	            url: CPATH+'/abh/abh220rkrPrint.do',
//	            prgID:prgId,
	            prgID: 'abh220rkr',
	               extParam: {
	                    COMP_CODE:       	param.COMP_CODE       
//						INOUT_SEQ:  	    param.INOUT_SEQ,  	 
//						INOUT_NUM:          param.INOUT_NUM,      
//						DIV_CODE:           param.DIV_CODE, 
//						INOUT_CODE:         param.INOUT_CODE,      
//						INOUT_DATE:         param.INOUT_DATE,      
//						ITEM_CODE:          param.ITEM_CODE,       
//						INOUT_Q:            param.INOUT_Q,         
//						INOUT_P:            param.INOUT_P,         
//						INOUT_I:            param.INOUT_I,
//						INOUT_DATE_FR:      param.INOUT_DATE_FR,      
//						INOUT_DATE_TO:      param.INOUT_DATE_TO  
	               }
	            });
	            win.center();
	            win.show();
	               
	      }*/
		
	});
	Unilite.createValidator('validator01', {
		store: directDetailStore,
		grid: detailGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
		console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
			
			}
				return rv;
						}
			});	
			
};

</script>