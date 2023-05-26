<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="map150skrv" >
	<t:ExtComboStore comboType="BOR120" pgmId="map150skrv"/> <!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B055" /> <!-- 거래처분류 -->
	<t:ExtComboStore comboType="AU" comboCode="YP35" /> <!-- 지불일자 -->
	<t:ExtComboStore comboType="AU" comboCode="B034" /> <!-- 결제조건 -->
	<t:ExtComboStore comboType="AU" comboCode="YP36" /> <!-- 계산서 -->
	<t:ExtComboStore items="${COMBO_COLLECT_DAY}" storeId="collectDayList" /><!--차수-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
	/**
	 *   Model 정의 
	 * @type 
	 */

	
	Unilite.defineModel('Map150skrvModel', {
	    fields: [
	    	{name: 'CUSTOM_CODE'			, text: '<t:message code="system.label.purchase.customcode" default="거래처코드"/>'		, type: 'string'},
	    	{name: 'CUSTOM_NAME'			, text: '<t:message code="system.label.purchase.custom" default="거래처"/>'			, type: 'string'},
	    	{name: 'AMOUNT_TAX_01'			, text: '과세'			, type: 'uniPrice'},
	    	{name: 'AMOUNT_EXP_01'			, text: '면세'			, type: 'uniPrice'},
	    	{name: 'TAX_01'					, text: '<t:message code="system.label.purchase.vatamount" default="부가세액"/>'			, type: 'uniPrice'},
	    	{name: 'TOTAL_01'				, text: '<t:message code="system.label.purchase.totalamount" default="합계"/>'			, type: 'uniPrice'},
	    	{name: 'PAY_AMT_01'				, text: '지불확정금액'		, type: 'uniPrice'},
	    	{name: 'AMOUNT_TAX_02'			, text: '과세'			, type: 'uniPrice'},
	    	{name: 'AMOUNT_EXP_02'			, text: '면세'			, type: 'uniPrice'},
	    	{name: 'TAX_02'					, text: '<t:message code="system.label.purchase.vatamount" default="부가세액"/>'			, type: 'uniPrice'},
	    	{name: 'TOTAL_02'				, text: '<t:message code="system.label.purchase.totalamount" default="합계"/>'			, type: 'uniPrice'},
	    	{name: 'PAY_AMT_02'				, text: '지불확정금액'		, type: 'uniPrice'},
	    	{name: 'AMOUNT_TAX_03'			, text: '과세'			, type: 'uniPrice'},
	    	{name: 'AMOUNT_EXP_03'			, text: '면세'			, type: 'uniPrice'},
	    	{name: 'TAX_03'					, text: '<t:message code="system.label.purchase.vatamount" default="부가세액"/>'			, type: 'uniPrice'},
	    	{name: 'TOTAL_03'				, text: '<t:message code="system.label.purchase.totalamount" default="합계"/>'			, type: 'uniPrice'},
	    	{name: 'PAY_AMT_03'				, text: '지불확정금액'		, type: 'uniPrice'},
	    	{name: 'AMOUNT_TAX_TOTAL'		, text: '과세'			, type: 'uniPrice'},
	    	{name: 'AMOUNT_EXP_TOTAL'		, text: '면세'			, type: 'uniPrice'},
	    	{name: 'TAX_TOTAL'				, text: '<t:message code="system.label.purchase.vatamount" default="부가세액"/>'			, type: 'uniPrice'},
	    	{name: 'TOTAL'					, text: '<t:message code="system.label.purchase.totalamount" default="합계"/>'			, type: 'uniPrice'},
	    	{name: 'PAY_AMT_TOTAL'			, text: '지불확정금액'		, type: 'uniPrice'}
	    ]
	});
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('map150skrvMasterStore1', {
		model: 'Map150skrvModel',
		uniOpt: {
        	isMaster: true,			// 상위 버튼 연결 
        	editable: false,			// 수정 모드 사용 
        	deletable: false,			// 삭제 가능 여부 
            useNavi: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {			
				read: 'map150skrvService.selectList'                	
			}
		},
		loadStoreRecords: function(){
			var param = Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params: param
			});
				
		}/*,
		listeners: {
			load: function(store, records, successful, eOpts) {
				var count = masterGrid.getStore().getCount();
				if(count > 0) {	
					UniAppManager.setToolbarButtons(['print'], true);
				}
			}
		}*/
			
	});
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var masterForm = Unilite.createSearchPanel('searchForm', {		
		title: '<t:message code="system.label.purchase.searchconditon" default="검색조건"/>',
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
			title: '<t:message code="system.label.purchase.basisinfo" default="기본정보"/>', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
			items: [{
				fieldLabel: '<t:message code="system.label.purchase.billdate" default="계산서일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'FR_DATE',
				endFieldName: 'TO_DATE',
				startDate: UniDate.get('today'),
				endDate: UniDate.get('today'),
				allowBlank: false,
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('FR_DATE',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('TO_DATE',newValue);
			    	}
			    }
			},Unilite.popup('CUST', { 
					fieldLabel: '매입처', 
					valueFieldName: 'CUSTOM_CODE',
			   	 	textFieldName: 'CUSTOM_NAME',
					extParam: {'CUSTOM_TYPE': ['1','2']},
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('CUSTOM_CODE', masterForm.getValue('CUSTOM_CODE'));
								panelResult.setValue('CUSTOM_NAME', masterForm.getValue('CUSTOM_NAME'));
	                    	},
							scope: this
						},
						onClear: function(type)	{
								panelResult.setValue('CUSTOM_CODE', '');
								panelResult.setValue('CUSTOM_NAME', '');
						}
					}
			}),{ 
				fieldLabel: '지불년월',
				name: 'PAY_YYYYMM',
	            xtype: 'uniMonthfield',
	            width: 200,
	            listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('PAY_YYYYMM', newValue);
					}
				}
	        },
			{
				fieldLabel: '거래처분류', 
				name: 'AGENT_TYPE',
				xtype: 'uniCombobox',
				comboType:'AU', 
				comboCode:'B055',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('AGENT_TYPE', newValue);
					}
				}
			},{
	    		fieldLabel: '지불일자',
	    		name: 'COLLECT_DAY',
				xtype: 'uniCombobox',
				comboType:'AU', 
				comboCode:'YP35',
		 		listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('COLLECT_DAY', newValue);
						}
				}
			}/*,{
	    		fieldLabel: '차수',
	    		name: 'COLLECT_DAY_MAP050',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('collectDayList'),
		 		listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('COLLECT_DAY_MAP050', newValue);
						},
						beforequery: function(queryPlan, eOpts ) {
					        var pValue = masterForm.getValue('DIV_CODE') + '-' + UniDate.getDbDateStr(masterForm.getValue('PAY_YYYYMM')).substring(0, 6);
					        
					        queryPlan.combo.bindStore(Ext.data.StoreManager.lookup('collectDayList'));
					        
					        var store = queryPlan.combo.getStore();
					        if(!Ext.isEmpty(pValue)) {
					        	store.clearFilter(true);
					        	queryPlan.combo.queryFilter = null;    
					         	store.filter('option', pValue);
					        }else {
						         store.clearFilter(true);
						         queryPlan.combo.queryFilter = null; 
						         store.loadRawData(store.proxy.data);
					        }
					     }
				}
			}*/]
		}]
	});
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
				fieldLabel: '<t:message code="system.label.purchase.billdate" default="계산서일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'FR_DATE',
				endFieldName: 'TO_DATE',
				startDate: UniDate.get('today'),
				endDate: UniDate.get('today'),
				allowBlank: false,
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(masterForm) {
						masterForm.setValue('FR_DATE',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(masterForm) {
			    		masterForm.setValue('TO_DATE',newValue);
			    	}
			    }
			},Unilite.popup('CUST', { 
					fieldLabel: '매입처', 
					valueFieldName: 'CUSTOM_CODE',
			   	 	textFieldName: 'CUSTOM_NAME',
					extParam: {'CUSTOM_TYPE': ['1','2']},
					listeners: {
						onSelected: {
							fn: function(records, type) {
								masterForm.setValue('CUSTOM_CODE', panelResult.getValue('CUSTOM_CODE'));
								masterForm.setValue('CUSTOM_NAME', panelResult.getValue('CUSTOM_NAME'));
	                    	},
							scope: this
						},
						onClear: function(type)	{
								masterForm.setValue('CUSTOM_CODE', '');
								masterForm.setValue('CUSTOM_NAME', '');
						}
					}
			}),{ 
				fieldLabel: '지불년월',
				name: 'PAY_YYYYMM',
	            xtype: 'uniMonthfield',
	            width: 200,
	            listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						
						masterForm.setValue('PAY_YYYYMM', newValue);
					}
				}
	        },
			{
				fieldLabel: '거래처분류', 
				name: 'AGENT_TYPE',
				xtype: 'uniCombobox',
				comboType:'AU', 
				comboCode:'B055',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						masterForm.setValue('AGENT_TYPE', newValue);
					}
				}
			},{
	    		fieldLabel: '지불일자',
	    		name: 'COLLECT_DAY',
				xtype: 'uniCombobox',
				comboType:'AU', 
				comboCode:'YP35',
		 		listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							masterForm.setValue('COLLECT_DAY', newValue);
						}
				}
			}/*,{
	    		fieldLabel: '차수',
	    		name: 'COLLECT_DAY_MAP050',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('collectDayList'),
		 		listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							masterForm.setValue('COLLECT_DAY_MAP050', newValue);
						},
						beforequery: function(queryPlan, eOpts ) {
					        var pValue = masterForm.getValue('DIV_CODE') + '-' + UniDate.getDbDateStr(masterForm.getValue('PAY_YYYYMM')).substring(0, 6);
					        
					        queryPlan.combo.bindStore(Ext.data.StoreManager.lookup('collectDayList'));
					        
					        var store = queryPlan.combo.getStore();
					        if(!Ext.isEmpty(pValue)) {
					        	store.clearFilter(true);
					        	queryPlan.combo.queryFilter = null;    
					         	store.filter('option', pValue);
					        }else {
						         store.clearFilter(true);
						         queryPlan.combo.queryFilter = null; 
						         store.loadRawData(store.proxy.data);
					        }
					     }
				}
			}*/
		
		
		
		]
	});		
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
	var masterGrid = Unilite.createGrid('map150skrvGrid1', {
    	// for tab    	
		layout: 'fit',
		region: 'center',
		excelTitle: '전사매입현황',
        uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: false,
    		filter: {
				useFilter: false,
				autoCreate: false
			}
        },
        features: [{
        	id: 'masterGridSubTotal', 
        	ftype: 'uniGroupingsummary', 
        	showSummaryRow: false
		},{
			id: 'masterGridTotal', 
			ftype: 'uniSummary', 
			showSummaryRow: true
		}],
    	store: directMasterStore1,
	    	
        	columns: [
	        	{dataIndex: 'CUSTOM_CODE'					, width: 80},
	        	{dataIndex: 'CUSTOM_NAME'					, width: 150},
        	{ 
	      	text:'신촌캠퍼스',
     			columns: [
		        	{dataIndex: 'AMOUNT_TAX_01'					, width: 100,summaryType: 'sum'},
		        	{dataIndex: 'AMOUNT_EXP_01'					, width: 100,summaryType: 'sum'},
		        	{dataIndex: 'TAX_01'						, width: 100,summaryType: 'sum'},
		        	{dataIndex: 'TOTAL_01'						, width: 100,summaryType: 'sum'},
		        	{dataIndex: 'PAY_AMT_01'					, width: 100,summaryType: 'sum'}
        		]},
        	{ 
	      	text:'국제캠퍼스',
     			columns: [
		        	{dataIndex: 'AMOUNT_TAX_02'					, width: 100,summaryType: 'sum'},
		        	{dataIndex: 'AMOUNT_EXP_02'					, width: 100,summaryType: 'sum'},
		        	{dataIndex: 'TAX_02'						, width: 100,summaryType: 'sum'},
		        	{dataIndex: 'TOTAL_02'						, width: 100,summaryType: 'sum'},
		        	{dataIndex: 'PAY_AMT_02'					, width: 100,summaryType: 'sum'}
        	]},
        	{ 
	      	text:'원주캠퍼스',
     			columns: [
		        	{dataIndex: 'AMOUNT_TAX_03'					, width: 100,summaryType: 'sum'},
		        	{dataIndex: 'AMOUNT_EXP_03'					, width: 100,summaryType: 'sum'},
		        	{dataIndex: 'TAX_03'						, width: 100,summaryType: 'sum'},
		        	{dataIndex: 'TOTAL_03'						, width: 100,summaryType: 'sum'},
		        	{dataIndex: 'PAY_AMT_03'					, width: 100,summaryType: 'sum'}
		    ]},
		    { 
	      	text:'전사집계',
     			columns: [
     				{dataIndex: 'AMOUNT_TAX_TOTAL'					, width: 100,summaryType: 'sum'},
		        	{dataIndex: 'AMOUNT_EXP_TOTAL'					, width: 100,summaryType: 'sum'},
		        	{dataIndex: 'TAX_TOTAL'						, width: 100,summaryType: 'sum'},
		        	{dataIndex: 'TOTAL'						, width: 100,summaryType: 'sum'},
		        	{dataIndex: 'PAY_AMT_TOTAL'					, width: 100,summaryType: 'sum'}
 			]}
 			]
    });
	
	Unilite.Main({
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult
			]
		},
			masterForm  	
		],
		id: 'map150skrvApp',
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons('detail',false);
			masterForm.setValue('FR_DATE', UniDate.get('today'));
			masterForm.setValue('TO_DATE', UniDate.get('today'));
			panelResult.setValue('FR_DATE', UniDate.get('today'));
			panelResult.setValue('TO_DATE', UniDate.get('today'));
			masterForm.setValue('PAY_YYYYMM', UniDate.get('today'));
			panelResult.setValue('PAY_YYYYMM', UniDate.get('today'));
			UniAppManager.setToolbarButtons('save',false);
			UniAppManager.setToolbarButtons('reset',true);
		},
		onQueryButtonDown: function() {
			masterGrid.getStore().loadStoreRecords();
		},
		onResetButtonDown: function() {
			masterForm.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			this.fnInitBinding();
		}
      
/*        onSaveAsExcelButtonDown: function() {
			 masterGrid.downloadExcelXml();
		}*/
	});
	
};


</script>
