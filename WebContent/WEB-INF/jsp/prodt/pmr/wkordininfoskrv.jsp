<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="wkordininfoskrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="wkordininfoskrv" /> 					  <!-- 사업장 -->
    <t:ExtComboStore comboType="AU" comboCode="P001"  /> 		  <!-- 진행상태 -->  
	<t:ExtComboStore comboType="W" /><!-- 작업장  -->
</t:appConfig>
<style type="text/css">
.x-change-cell {
background-color: #FFFFC6;
}
.x-change-cell_Red {
background-color: #FF0000;
}
.x-change-cell_Green {
background-color: #1DDB16;
}
</style>
<script type="text/javascript" >

function appMain() {
	
	var statusStore = Unilite.createStore('statusComboStore', {  
	    fields: ['text', 'value'],
		data :  [
	        {'text':'동작중', 'value':'R'},
	        {'text':'멈춤'	, 'value':'P'},
	        {'text':'정지'	, 'value':'S'}
		]
	});

	Unilite.defineModel('wkordininfoskrvModel', {
		fields: [
	    	{name: 'IP'    	, text: 'IP'  , type: 'string'},
	    	{name: 'STATUS'    	, text: 'STATUS'  , type: 'string'/*,store: Ext.data.StoreManager.lookup('statusComboStore')*/},
	    	{name: 'PROG_WORK_CODE'    	, text: '공정코드'  , type: 'string'},
	    	{name: 'WKORD_NUM'       	, text: '작업지시번호'  , type: 'string'},
	    	{name: 'ITEM_CODE'       	, text: '품번'  , type: 'string'},
	    	{name: 'ITEM_NAME'       	, text: '품명'  , type: 'string'},
	    	{name: 'WKORD_Q'       		, text: '작업지시량'  , type: 'uniQty'},
	    	{name: 'CAVIT_BASE_Q'       , text: '캐비티수'  , type: 'uniQty'},
	    	{name: 'SHOT_Q'       		, text: '샷수'  , type: 'uniQty'},
	    	{name: 'PASS_Q'       		, text: '생산량'  , type: 'uniQty'},
	    	{name: 'GOOD_WORK_Q'       	, text: '양품량'  , type: 'uniQty'},
	    	{name: 'BAD_WORK_Q'       	, text: '불량량'  , type: 'uniQty'}
	    	
//	    	
//	    	{name: ''       	, text: ''  , type: 'string'},
//	    	{name: ''       	, text: ''  , type: 'string'},
//	    	{name: ''       	, text: ''  , type: 'string'},
//	    	{name: ''       	, text: ''  , type: 'string'},
//	    	{name: ''       	, text: ''  , type: 'string'},
//	    	{name: ''       	, text: ''  , type: 'string'},
//	    	{name: ''       	, text: ''  , type: 'string'},
//	    	{name: ''       	, text: ''  , type: 'string'},
//	    	{name: ''       	, text: ''  , type: 'string'},
//	    	{name: ''       	, text: ''  , type: 'string'},
//	    	{name: ''       	, text: ''  , type: 'string'},
//	    	{name: ''       	, text: ''  , type: 'string'}

		]
	});
	
	var directMasterStore1 = Unilite.createStore('wkordininfoskrvMasterStore1',{
		model: 'wkordininfoskrvModel',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결
			editable: false,			// 수정 모드 사용
			deletable: false,			// 삭제 가능 여부
			useNavi: false			// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {			
				read: 'wkordininfoskrvService.selectList'                	
			}
		},
		loadStoreRecords: function() {
			var param= panelSearch.getValues();
			console.log( param );
			this.load({
				params: param
			});
		},
		
		listeners:{
			load: function(store, records, successful, eOpts) {
				
			}
		}
		
		
	});

    var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '<t:message code="system.label.product.searchconditon" default="검색조건"/>',
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
		items:[{	
			title: '<t:message code="system.label.product.basisinfo" default="기본정보"/>', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items: [{
        		fieldLabel: '사업장',
        		name: 'DIV_CODE',
        		value : UserInfo.divCode,
        		xtype: 'uniCombobox',
        		comboType: 'BOR120',
        		allowBlank: false,
        		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
					}
        		}
			},{
				fieldLabel:'작업지시번호', 
				xtype: 'uniTextfield',
				name: 'WKORD_NUM',
				width:200,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {      
						panelResult.setValue('WKORD_NUM', newValue);
					}
				}
		    }
				
		    	
		    		
		    			/*
		    				{
        		fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
        		name: 'DIV_CODE',
        		value : UserInfo.divCode,
        		xtype: 'uniCombobox',
        		comboType: 'BOR120',
        		allowBlank: false,
        		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
						panelSearch.setValue('WORK_SHOP_CODE','');
					}
        		}
			},{
				fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
				name: 'WORK_SHOP_CODE',
				xtype: 'uniCombobox',
				comboType:'W',
				allowBlank:false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('WORK_SHOP_CODE', newValue);
					},
                    beforequery:function( queryPlan, eOpts )   {
                        var store = queryPlan.combo.store;
                        var prStore = panelResult.getField('WORK_SHOP_CODE').store;
                        store.clearFilter();
                        prStore.clearFilter();
                        if(!Ext.isEmpty(panelSearch.getValue('DIV_CODE'))){
                            store.filterBy(function(record){
                                return record.get('option') == panelSearch.getValue('DIV_CODE');
                            });
                            prStore.filterBy(function(record){
                                return record.get('option') == panelSearch.getValue('DIV_CODE');
                            });
                        }else{
                            store.filterBy(function(record){
                                return false;   
                            });
                            prStore.filterBy(function(record){
                                return false;   
                            });
                        }
                    }
				}
			},{
	        	fieldLabel: '<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>',
	        	xtype: 'uniDateRangefield',
	        	startFieldName: 'PRODT_START_DATE_FR',
	        	endFieldName: 'PRODT_START_DATE_TO',
	        	width: 315,
	        	startDate: UniDate.get('mondayOfWeek'),
	        	endDate: UniDate.get('sundayOfNextWeek'),
	        	onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('PRODT_START_DATE_FR',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('PRODT_START_DATE_TO',newValue);
			    	}
			    }
			},
			Unilite.popup('DIV_PUMOK',{ 
				fieldLabel: '<t:message code="system.label.product.item" default="품목"/>',
        		listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('ITEM_CODE', panelSearch.getValue('ITEM_CODE'));
							panelResult.setValue('ITEM_NAME', panelSearch.getValue('ITEM_NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('ITEM_CODE', '');
						panelResult.setValue('ITEM_NAME', '');
					}
				}
			}),
			{
			    xtype: 'container',
				layout: {type : 'uniTable', columns : 3},
				width:300,
				items :[{
					fieldLabel:'<t:message code="system.label.product.workorderno" default="작업지시번호"/>', 
					xtype: 'uniTextfield',
					name: 'WKORD_NUM_FR',
					width:200,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {      
							panelResult.setValue('WKORD_NUM_FR', newValue);
						}
					}
				},{
					xtype:'component', 
					html:'~',
					style: {
						marginTop: '3px !important',
						font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
					}
				},{
					fieldLabel:'', 
					xtype: 'uniTextfield',
					name: 'WKORD_NUM_TO', 
					width: 110,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {      
							panelResult.setValue('WKORD_NUM_TO', newValue);
						}
					}
				}]
			},{	
				xtype: 'radiogroup',		            		
				fieldLabel: '   ',						            		
				labelWidth:90,
				items: [{
					boxLabel: '<t:message code="system.label.product.whole" default="전체"/>',
					width: 60,
					name: 'WORK_END_YN',
					inputValue: '',
					checked: true
				},{
					boxLabel: '<t:message code="system.label.product.process" default="진행"/>',
					width: 60,
					name: 'WORK_END_YN' ,
					inputValue: 'N'
				},{
					boxLabel: '<t:message code="system.label.product.completion" default="완료"/>',
					width: 60,
					name: 'WORK_END_YN' ,
					inputValue: 'Y'
				},{
					boxLabel: '<t:message code="system.label.product.closing" default="마감"/>',
					width: 60,
					name: 'WORK_END_YN' ,
					inputValue: 'F'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.getField('WORK_END_YN').setValue(newValue.WORK_END_YN);
					}
				}
			}
			*/
			
			
			]
		}]
	});
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 2},
		padding:'1 1 1 1',
		border:true,
		items:[{
    		fieldLabel: '사업장',
    		name: 'DIV_CODE',
    		value : UserInfo.divCode,
    		xtype: 'uniCombobox',
    		comboType: 'BOR120',
    		allowBlank: false,
    		colspan:1,
    		listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DIV_CODE', newValue);
				}
    		}
		},{
			fieldLabel:'작업지시번호', 
			xtype: 'uniTextfield',
			name: 'WKORD_NUM',
			width:200,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {      
					panelSearch.setValue('WKORD_NUM', newValue);
				}
			}
	    }
			
				
					
		/*				{
    		fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
    		name: 'DIV_CODE',
    		value : UserInfo.divCode,
    		xtype: 'uniCombobox',
    		comboType: 'BOR120',
    		allowBlank: false,
    		colspan:1,
    		listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DIV_CODE', newValue);
					panelResult.setValue('WORK_SHOP_CODE','');
				}
    		}
		},{
        	fieldLabel: '<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>',
        	xtype: 'uniDateRangefield',
        	startFieldName: 'PRODT_START_DATE_FR',
        	endFieldName: 'PRODT_START_DATE_TO',
        	width: 315,
        	startDate: UniDate.get('mondayOfWeek'),
        	endDate: UniDate.get('sundayOfNextWeek'),
        	onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
					panelSearch.setValue('PRODT_START_DATE_FR',newValue);
					// panelSearch.getField('ISSUE_REQ_DATE_FR').validate();
					
            	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('PRODT_START_DATE_TO',newValue);
		    		// panelSearch.getField('ISSUE_REQ_DATE_TO').validate();
		    	}
		    }
		},{
			fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
			name: 'WORK_SHOP_CODE',
			xtype: 'uniCombobox',
			comboType:'W',
			allowBlank:false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('WORK_SHOP_CODE', newValue);
				},
                beforequery:function( queryPlan, eOpts )   {
                    var store = queryPlan.combo.store;
                    var prStore = panelSearch.getField('WORK_SHOP_CODE').store;
                    store.clearFilter();
                    prStore.clearFilter();
                    if(!Ext.isEmpty(panelResult.getValue('DIV_CODE'))){
                        store.filterBy(function(record){
                            return record.get('option') == panelResult.getValue('DIV_CODE');
                        });
                        prStore.filterBy(function(record){
                            return record.get('option') == panelResult.getValue('DIV_CODE');
                        });
                    }else{
                        store.filterBy(function(record){
                            return false;   
                        });
                        prStore.filterBy(function(record){
                            return false;   
                        });
                    }
                }
				
			}
		},
			Unilite.popup('DIV_PUMOK',{ 
				fieldLabel: '<t:message code="system.label.product.item" default="품목"/>', 
				validateBlank:true,
				colspan:2,
        		listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('ITEM_CODE', panelResult.getValue('ITEM_CODE'));
							panelSearch.setValue('ITEM_NAME', panelResult.getValue('ITEM_NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('ITEM_CODE', '');
						panelSearch.setValue('ITEM_NAME', '');
					}
				}
		}),
		{
		    xtype: 'container',
			layout: {type : 'uniTable', columns : 3},
			width:300,
			items :[{
				fieldLabel:'<t:message code="system.label.product.workorderno" default="작업지시번호"/>', 
				xtype: 'uniTextfield',
				name: 'WKORD_NUM_FR',
				width:200,
					listeners: {
					change: function(field, newValue, oldValue, eOpts) {      
						panelSearch.setValue('WKORD_NUM_FR', newValue);
					}
				}
			},{
				xtype:'component', 
				html:'~',
				style: {
					marginTop: '3px !important',
					font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
				}
			},{
				fieldLabel:'', 
				xtype: 'uniTextfield',
				name: 'WKORD_NUM_TO', 
				width: 110,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {      
						panelSearch.setValue('WKORD_NUM_TO', newValue);
					}
				}
			}]
		},{	
			xtype: 'radiogroup',		            		
			fieldLabel: '   ',						            		
			labelWidth:90,
			items: [{
				boxLabel: '<t:message code="system.label.product.whole" default="전체"/>',
				width: 60,
				name: 'WORK_END_YN',
				inputValue: '',
				checked: true
			},{
				boxLabel: '<t:message code="system.label.product.process" default="진행"/>',
				width: 60,
				name: 'WORK_END_YN' ,
				inputValue: 'N'
			},{
				boxLabel: '<t:message code="system.label.product.completion" default="완료"/>',
				width: 60,
				name: 'WORK_END_YN' ,
				inputValue: 'Y'
			},{
				boxLabel: '<t:message code="system.label.product.closing" default="마감"/>',
				width: 60,
				name: 'WORK_END_YN' ,
				inputValue: 'F'
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.getField('WORK_END_YN').setValue(newValue.WORK_END_YN);
					
					setTimeout(function(){
						UniAppManager.app.onQueryButtonDown();
					}, 50);
				}
			}
		}
		*/
		
		
		]
    });
    
	var masterGrid = Unilite.createGrid('wkordininfoskrvGrid1', {
    	// for tab
		layout: 'fit',
		region: 'center',
		uniOpt:{
        	expandLastColumn: true,
    		useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
    		useGroupSummary: false,
			useRowNumberer: false,
			onLoadSelectFirst:true,
			filter: {
				useFilter: true,
				autoCreate: true
			}
        },
		features: [{
			id: 'masterGridSubTotal', 
			ftype: 'uniGroupingsummary', 
			showSummaryRow: true
		},{
			id: 'masterGridTotal', 
			ftype: 'uniSummary', 
			showSummaryRow: true
		}],
		store: directMasterStore1,
		selModel:  'rowmodel',
		columns: [
			{dataIndex: 'IP'       				, width: 100},
			{dataIndex: 'STATUS'       			, width: 100,
				renderer: function(value, metaData, record) {
					if(record.get('STATUS') == 'S'){
						metaData.tdCls = 'x-change-cell_Red';
					}else{
						metaData.tdCls = 'x-change-cell_Green';
					}
					return value;
				}
			
			},
			{dataIndex: 'PROG_WORK_CODE'       	, width: 80},
			{dataIndex: 'WKORD_NUM'            	, width: 120},
			{dataIndex: 'ITEM_CODE'            	, width: 120},
			{dataIndex: 'ITEM_NAME'            	, width: 200},
			{dataIndex: 'WKORD_Q'              	, width: 100},
			
			{dataIndex: 'CAVIT_BASE_Q'       	, width: 100},
			{dataIndex: 'SHOT_Q'       	       	, width: 100},
			{dataIndex: 'PASS_Q'       	       	, width: 100,tdCls:'x-change-cell'},
			{dataIndex: 'GOOD_WORK_Q'       	, width: 100,tdCls:'x-change-cell'},
			{dataIndex: 'BAD_WORK_Q'           	, width: 100},
			
			{
	            text: '명령',
	            width: 120,
	            xtype: 'widgetcolumn',
	            widget: {
	                xtype: 'button',
	                text: '센서 스타트',
	                listeners: {
	                	buffer:1,
	                	click: function(button, event, eOpts) {
	                        var record = event.record.data;
//	                        alert(record.PASS_Q);
	                        var httpRequest = new XMLHttpRequest();
	                        httpRequest.open('GET', 'http://localhost:8080/op90/wkordSts?COMP_CODE=MASTER&DIV_CODE=03&PROG_WORK_CODE=%2301&IP=192.168.1.1&STS=R', true);
							httpRequest.send();
							
							
							setTimeout( function() {
								directMasterStore1.loadStoreRecords();
			   				}, 500 );
	                	}
	                }
	            }
	        },{
	            text: '명령',
	            width: 120,                                                                           
	            xtype: 'widgetcolumn',
	            widget: {
	                xtype: 'button',
	                text: '센서 중지',
	                listeners: {
	                	buffer:1,
	                	click: function(button, event, eOpts) {
	                        var record = event.record.data;
//	                        alert(record.PASS_Q);
	                        var httpRequest = new XMLHttpRequest();
	                        httpRequest.open('GET', 'http://localhost:8080/op90/wkordSts?COMP_CODE=MASTER&DIV_CODE=03&PROG_WORK_CODE=%2301&IP=192.168.1.1&STS=S', true);
							httpRequest.send();
							
							
							setTimeout( function() {
								directMasterStore1.loadStoreRecords();
			   				}, 500 );
	                	}
	                }
	            }
	        },{
	            text: '명령',
	            width: 120,
	            xtype: 'widgetcolumn',
	            widget: {
	                xtype: 'button',
	                text: '센서 일시중지',
	                listeners: {
	                	buffer:1,
	                	click: function(button, event, eOpts) {
	                        var record = event.record.data;
	                        alert(record.PASS_Q);
	                	}
	                }
	            }
	        },{
	            text: '명령',
	            width: 120,
	            xtype: 'widgetcolumn',
	            widget: {
	                xtype: 'button',
	                text: '센서 REBOOT',
	                listeners: {
	                	buffer:1,
	                	click: function(button, event, eOpts) {
	                        var record = event.record.data;
	                        alert(record.PASS_Q);
	                	}
	                }
	            }
	        },{
	            text: '명령',
	            width: 120,
	            xtype: 'widgetcolumn',
	            widget: {
	                xtype: 'button',
	                text: '센서 상태',
	                listeners: {
	                	buffer:1,
	                	click: function(button, event, eOpts) {
	                        var record = event.record.data;
	                        alert(record.PASS_Q);
	                	}
	                }
	            }
	        },{
	            text: '명령',
	            width: 120,
	            xtype: 'widgetcolumn',
	            widget: {
	                xtype: 'button',
	                text: '센서 카운트 수신',
	                listeners: {
	                	buffer:1,
	                	click: function(button, event, eOpts) {
	                        var record = event.record.data;
	                        alert(record.PASS_Q);
	                	}
	                }
	            }
	        },{
	            text: '명령',
	            width: 120,
	            xtype: 'widgetcolumn',
	            widget: {
	                xtype: 'button',
	                text: '센서 카운트 리셋',
	                listeners: {
	                	buffer:1,
	                	click: function(button, event, eOpts) {
	                        var record = event.record.data;
	                        alert(record.PASS_Q);
	                	}
	                }
	            }
	        },{
	            text: '명령',
	            width: 120,
	            xtype: 'widgetcolumn',
	            widget: {
	                xtype: 'button',
	                text: '수신 인터벌 조정',
	                listeners: {
	                	buffer:1,
	                	click: function(button, event, eOpts) {
	                        var record = event.record.data;
	                        alert(record.PASS_Q);
	                	}
	                }
	            }
	        }
	        
			
		]
	/*	viewConfig: {
	        getRowClass: function(record, rowIndex, rowParams, store){
	        	var cls = '';
	        	if(record.get('STATUS') == 'S'){
					cls = 'x-change-celltext_red';	
				}
				return cls;
	        }
	    }*/
	});
	
	Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult
			]
		},
			panelSearch  	
		],	
		id: 'wkordininfoskrvApp',
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons(['reset'], true);
			UniAppManager.setToolbarButtons(['print','save'], false);
			
//			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
//			panelResult.setValue('DIV_CODE', UserInfo.divCode);
			
//			panelSearch.setValue('PRODT_START_DATE_FR', UniDate.get('mondayOfWeek'));
//			panelResult.setValue('PRODT_START_DATE_FR', UniDate.get('mondayOfWeek'));
//			
//			panelSearch.setValue('PRODT_START_DATE_TO', UniDate.get('sundayOfNextWeek'));
//			panelResult.setValue('PRODT_START_DATE_TO', UniDate.get('sundayOfNextWeek'));
		},
		onQueryButtonDown: function() {
			if(!panelResult.getInvalidMessage()) return false;
			directMasterStore1.loadStoreRecords();
			
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			directMasterStore1.clearData();
			this.fnInitBinding();
		}
	});
};


</script>