<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="mpo250skrv"  >
	<t:ExtComboStore comboType="BOR120"  />	<!-- 사업장 -->
	<t:ExtComboStore comboType="O" />		<!-- 창고-->
	<t:ExtComboStore comboType="W" />		<!-- 작업장  -->
	<t:ExtComboStore comboType="AU" comboCode="M002" /> <!-- 진행상태 -->
<t:ExtComboStore items="${COMBO_ORDER_WEEK}" storeId="orderWeekList" /><!--발주주차관련-->
	

</t:appConfig>

<style type="text/css">
.x-change-cell {
background-color: #FFFFC6;
}
</style>

<script type="text/javascript" >

function appMain() {
	var gubunStore = Unilite.createStore('gubunComboStore', {  
        fields: ['text', 'value'],
        data: [
            {'text':'<t:message code="system.label.purchase.confirm" default="확인"/>'  , 'value':'Y'},
            {'text':'<t:message code="system.label.purchase.notconfirm" default="미확인"/>'  , 'value':'N'}
        ]
    });
	
	Unilite.defineModel('masterModel', {
		fields: [
//        	{ name: 'NM'       			,text:'순번'              ,type: 'int'},
            { name: 'IN_DIV_CODE'       ,text:'IN_DIV_CODE'             ,type: 'string'},
            { name: 'CUSTOM_CODE'       ,text:'거래처'             ,type: 'string'},
            { name: 'CUSTOM_NAME'       ,text:'거래처명'            ,type: 'string'},
            { name: 'ORDER_COUNT'       ,text:'발주건수'            ,type: 'uniQty'},
            { name: 'ORDER_UNIT_Q_SUM'  ,text:'발주수량'            ,type: 'uniQty'},
            { name: 'ITEM_COUNT'        ,text:'품목건수'            ,type: 'uniQty'},
            { name: 'INSTOCK_Q_SUM'     ,text:'대응수량'            ,type: 'uniQty'},
            { name: 'C_RESP_RATE'       ,text:'품목대응율(%)'        ,type: 'uniER'},
            { name: 'Q_RESP_RATE'       ,text:'수량대응율(%)'        ,type: 'uniER'}

        ]
	});	
	Unilite.defineModel('detailModel1', {
		fields: [
			{ name: 'ORDER_NUM'       ,text:'발주번호'         ,type: 'string'},
			{ name: 'ORDER_SEQ'       ,text:'순번'            ,type: 'int'},
			{ name: 'ITEM_CODE'       ,text:'품번'            ,type: 'string'},
			{ name: 'ITEM_NAME'       ,text:'품명'            ,type: 'string'},
			{ name: 'SPEC'       	  ,text:'규격'            ,type: 'string'},
			{ name: 'ORDER_UNIT'      ,text:'구매단위'         ,type: 'string'},
			{ name: 'ORDER_UNIT_Q'    ,text:'발주량'           ,type: 'uniQty'},
			{ name: 'TRNS_INSTOCK_Q'  ,text:'입고량'           ,type: 'uniQty'},
			{ name: 'NO_INSTOCK_Q'    ,text:'미입고량'          ,type: 'uniQty'},
			{ name: 'WAIT_INSPEC_Q'   ,text:'검사대기량'         ,type: 'uniQty'},
			{ name: 'DVRY_DATE'       ,text:'납기일'            ,type: 'uniDate'}

        ]
	});		
	Unilite.defineModel('detailModel2', {
		fields: [
			{ name: 'ORDER_NUM'            ,text:'발주번호'            ,type: 'string'},
			{ name: 'ORDER_SEQ'            ,text:'순번'            ,type: 'int'},
			{ name: 'ITEM_CODE'            ,text:'품번'            ,type: 'string'},
			{ name: 'ITEM_NAME'            ,text:'품명'            ,type: 'string'},
			{ name: 'SPEC'       	       ,text:'규격'            ,type: 'string'},
			{ name: 'ORDER_UNIT'           ,text:'구매단위'            ,type: 'string'},
			{ name: 'ORDER_UNIT_Q'         ,text:'발주량'            ,type: 'uniQty'},
			{ name: 'TRNS_INSTOCK_Q'       ,text:'입고량'            ,type: 'uniQty'},
			{ name: 'CONTROL_STATUS'       ,text:'발주상태'            ,type: 'string',comboType:'AU', comboCode:'M002'}

        ]
	});	
	
	
	var cardNoStore = Unilite.createStore('orderWeekStore',{
        proxy: {
           type: 'direct',
            api: {          
                read: 'mpo250skrvService.getOrderWeek'                   
            }
        },
        loadStoreRecords: function(comboStore) {
            var param= Ext.getCmp('searchForm').getValues();            
            console.log( param );
            this.load({
                params : param,
                callback : function(records,options,success)    {
                    var loadDataStore = comboStore;
                    if(success) {
                        if(loadDataStore){
                            loadDataStore.loadData(records.items);
                        }
                    }
                }
            });
        }
    });
    
	var masterStore = Unilite.createStore('masterStore',{
		model: 'masterModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,	// 상위 버튼 연결 
			editable	: false,		// 수정 모드 사용 
			deletable	: false,		// 삭제 가능 여부 
			useNavi		: false		// prev | next 버튼 사용
		},
		proxy: {
			type: 'direct',
			api: {
				read	: 'mpo250skrvService.selectMasterList'
			}
		},
		loadStoreRecords : function()	{
			var param= panelSearch.getValues();
			this.load({
				params : param
			});
		},
		listeners: {
           	load: function(store, records, successful, eOpts) {
           	}
		}
	});
	var detailStore1 = Unilite.createStore('detailStore1',{
		model: 'detailModel1',
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,	// 상위 버튼 연결 
			editable	: false,		// 수정 모드 사용 
			deletable	: false,		// 삭제 가능 여부 
			useNavi		: false		// prev | next 버튼 사용
		},
		proxy: {
			type: 'direct',
			api: {
				read	: 'mpo250skrvService.selectDetailList1'
			}
		},
		loadStoreRecords : function(param)	{
			param.ORDER_DATE_FR = UniDate.getDbDateStr(panelResult.getValue('ORDER_DATE_FR'));
			param.ORDER_DATE_TO = UniDate.getDbDateStr(panelResult.getValue('ORDER_DATE_TO'));
			this.load({
				params : param
			});
		},
		listeners: {
           	load: function(store, records, successful, eOpts) {
           	}
		}
	});
	var detailStore2 = Unilite.createStore('detailStore2',{
		model: 'detailModel2',
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,	// 상위 버튼 연결 
			editable	: false,		// 수정 모드 사용 
			deletable	: false,		// 삭제 가능 여부 
			useNavi		: false		// prev | next 버튼 사용
		},
		proxy: {
			type: 'direct',
			api: {
				read	: 'mpo250skrvService.selectDetailList2'
			}
		},
		loadStoreRecords : function(param)	{
			param.ORDER_DATE_FR = UniDate.getDbDateStr(panelResult.getValue('ORDER_DATE_FR'));
			param.ORDER_DATE_TO = UniDate.getDbDateStr(panelResult.getValue('ORDER_DATE_TO'));
			this.load({
				params : param
			});
		},
		listeners: {
           	load: function(store, records, successful, eOpts) {
           	}
		}
	});	
	
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '<t:message code="system.label.inventory.searchconditon" default="검색조건"/>',
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
			title: '<t:message code="system.label.inventory.basisinfo" default="기본정보"/>',
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items: [{
				fieldLabel: '<t:message code="system.label.inventory.division" default="사업장"/>',
				name:'DIV_CODE',
				xtype: 'uniCombobox',
				comboType:'BOR120',
				allowBlank:false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.inventory.itemaccount" default="품목계정"/>',
				name:'ITEM_ACCOUNT',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'B020',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ITEM_ACCOUNT', newValue);
					}
				}
			},{
		        xtype: 'uniCombobox',
		        fieldLabel: '수주납기주차',
		        name:'ORDER_WEEK',
		        store: Ext.data.StoreManager.lookup('orderWeekList'),
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						if(!Ext.isEmpty(field.valueCollection.items[0])){
							panelSearch.setValue('ORDER_DATE_FR', field.valueCollection.items[0].data.refCode1);
							panelSearch.setValue('ORDER_DATE_TO', field.valueCollection.items[0].data.refCode2);
						}
						panelResult.setValue('ORDER_WEEK', newValue);
					}
				}
		    },{
				fieldLabel: '주차일자',
				xtype: 'uniDateRangefield',
				startFieldName: 'ORDER_DATE_FR',
				endFieldName: 'ORDER_DATE_TO',
//				startDate: UniDate.get('startOfMonth'),
//				endDate: UniDate.get('today'),
				allowBlank: false,
				width: 315,
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
			}
		    
		    
		    ]
		}]
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
		items:[{
			fieldLabel: '<t:message code="system.label.inventory.division" default="사업장"/>',
			name:'DIV_CODE',
			xtype: 'uniCombobox',
			comboType:'BOR120',
			allowBlank:false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.inventory.itemaccount" default="품목계정"/>',
			name:'ITEM_ACCOUNT',
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'B020',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('ITEM_ACCOUNT', newValue);
				}
			}
		},{
	        xtype: 'uniCombobox',
	        fieldLabel: '수주납기주차',
	        name:'ORDER_WEEK',
	        store: Ext.data.StoreManager.lookup('orderWeekList'),
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					if(!Ext.isEmpty(field.valueCollection.items[0])){
						panelResult.setValue('ORDER_DATE_FR', field.valueCollection.items[0].data.refCode1);
						panelResult.setValue('ORDER_DATE_TO', field.valueCollection.items[0].data.refCode2);
					}
					panelSearch.setValue('ORDER_WEEK', newValue);
				}
			}
	    },{
			fieldLabel: '주차일자',
			xtype: 'uniDateRangefield',
			startFieldName: 'ORDER_DATE_FR',
			endFieldName: 'ORDER_DATE_TO',
//			startDate: UniDate.get('startOfMonth'),
//			endDate: UniDate.get('today'),
			allowBlank: false,
			width: 315,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
            		panelSearch.setValue('ORDER_DATE_FR',newValue);
            	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('ORDER_DATE_TO',newValue);
		    	}
		    }
		}]
    });

	var masterGrid = Unilite.createGrid('masterGrid', {
		layout: 'fit',
		region:'north',
		uniOpt: {
//            userToolbar:false,
			expandLastColumn: true,
			useLiveSearch: false,
			useContextMenu: false,
			useMultipleSorting: false,
			useGroupSummary: false,
			useRowNumberer: true,
			onLoadSelectFirst: true,
			filter: {
				useFilter: false,
				autoCreate: false
			},
			state: {
				useState: false,
				useStateList: false
			}
		},
		store: masterStore,
		selModel:'rowmodel',
    	features: [
    	    		{id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true},
    	    	    {id : 'masterGridTotal' ,   ftype: 'uniSummary', 	     showSummaryRow: true}
    	    	],
		columns: [
//             { dataIndex: 'NM'       			        ,  width: 60, align:'center' },
             { dataIndex: 'CUSTOM_CODE'                 ,  width: 100 },
             { dataIndex: 'CUSTOM_NAME'                 ,  width: 250 },
             { dataIndex: 'ORDER_COUNT'                 ,  width: 100 , summaryType: 'sum'},
             { dataIndex: 'ORDER_UNIT_Q_SUM'            ,  width: 120 , summaryType: 'sum'},
             { dataIndex: 'ITEM_COUNT'                  ,  width: 100 , summaryType: 'sum'},
             { dataIndex: 'INSTOCK_Q_SUM'               ,  width: 120 , summaryType: 'sum'},
             { dataIndex: 'C_RESP_RATE'                 ,  width: 120 , summaryType: 'average'},
             { dataIndex: 'Q_RESP_RATE'                 ,  width: 120 , summaryType: 'average'}
  		],
		listeners: {
			selectionchange: function( grid, selected, eOpts ){
				if(!Ext.isEmpty(selected) && !Ext.isEmpty(selected[0])){
					detailStore1.loadStoreRecords(selected[0].data);
					detailStore2.loadStoreRecords(selected[0].data);
				}
			}
		}
	});
	var detailGrid1 = Unilite.createGrid('detailGrid1', {
		layout: 'fit',
		region:'center',
		uniOpt: {
//            userToolbar:false,
			expandLastColumn: true,
			useLiveSearch: false,
			useContextMenu: false,
			useMultipleSorting: false,
			useGroupSummary: false,
			useRowNumberer: false,
			onLoadSelectFirst: true,
			filter: {
				useFilter: false,
				autoCreate: false
			},
			state: {
				useState: false,
				useStateList: false
			}
		},
		store: detailStore1,
		selModel:'rowmodel',
    	features: [
    	    		{id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true},
    	    	    {id : 'masterGridTotal' ,   ftype: 'uniSummary', 	     showSummaryRow: true}
    	    	],
		columns: [
             { dataIndex: 'ORDER_NUM'                 ,  width: 120 },
             { dataIndex: 'ORDER_SEQ'                 ,  width: 60 },
             { dataIndex: 'ITEM_CODE'                 ,  width: 100 },
             { dataIndex: 'ITEM_NAME'                 ,  width: 250 },
             { dataIndex: 'SPEC'       	              ,  width: 100 },
             { dataIndex: 'ORDER_UNIT'                ,  width: 80,align:'center' },
             { dataIndex: 'ORDER_UNIT_Q'              ,  width: 100 , summaryType: 'sum'},
             { dataIndex: 'TRNS_INSTOCK_Q'            ,  width: 100 , summaryType: 'sum'},
             { dataIndex: 'NO_INSTOCK_Q'              ,  width: 100 , summaryType: 'sum'},
             { dataIndex: 'WAIT_INSPEC_Q'       	  ,  width: 100 , summaryType: 'sum'},
             { dataIndex: 'DVRY_DATE'                 ,  width: 100 }
  		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {}
		}
	});
	var detailGrid2 = Unilite.createGrid('detailGrid2', {
		layout: 'fit',
		region:'center',
		uniOpt: {
//            userToolbar:false,
			expandLastColumn: true,
			useLiveSearch: false,
			useContextMenu: false,
			useMultipleSorting: false,
			useGroupSummary: false,
			useRowNumberer: false,
			onLoadSelectFirst: true,
			filter: {
				useFilter: false,
				autoCreate: false
			},
			state: {
				useState: false,
				useStateList: false
			}
		},
		store: detailStore2,
		selModel:'rowmodel',
    	features: [
    	    		{id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true},
    	    	    {id : 'masterGridTotal' ,   ftype: 'uniSummary', 	     showSummaryRow: true}
    	    	],
		columns: [
             { dataIndex: 'ORDER_NUM'               ,  width: 120 },               
             { dataIndex: 'ORDER_SEQ'               ,  width: 60 },                
             { dataIndex: 'ITEM_CODE'               ,  width: 100 },               
             { dataIndex: 'ITEM_NAME'               ,  width: 250 },               
             { dataIndex: 'SPEC'       	            ,  width: 100 },               
             { dataIndex: 'ORDER_UNIT'              ,  width: 80,align:'center' }, 
             { dataIndex: 'ORDER_UNIT_Q'            ,  width: 100 , summaryType: 'sum'},               
             { dataIndex: 'TRNS_INSTOCK_Q'          ,  width: 100 , summaryType: 'sum'},
             { dataIndex: 'CONTROL_STATUS'          ,  width: 100,align:'center' }
  		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {}
		}
	});
	
	var tab = Unilite.createTabPanel('tabPanel',{
		activeTab: 0,
		region: 'center',
		items: [{
			title: '미대응 조회',
			xtype:'container',
			layout:{type:'vbox', align:'stretch'},
			items:[detailGrid1]
		},{
			title: '대응 조회',
			xtype:'container',
			layout:{type:'vbox', align:'stretch'},
			items:[detailGrid2]
		}]
	});
	
	Unilite.Main({
		borderItems: [{
			id: 'pageAll',
			region: 'center',
			layout: 'border',
			border: false,
			items: [
				panelResult, masterGrid, tab 
			]
		},
			panelSearch
		],
		id: 'mpo250skrvApp',
		fnInitBinding: function() {
			this.fnInitInputFields();
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			masterStore.clearData();
			detailGrid1.reset();
			detailStore1.clearData();
			detailGrid2.reset();
			detailStore2.clearData();
			
			this.fnInitInputFields();
		},
		onQueryButtonDown: function() {
            if(!panelResult.getInvalidMessage()) return;   //필수체크
			masterStore.loadStoreRecords();
		},
		fnInitInputFields: function(){
			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			panelResult.setValue('DIV_CODE', UserInfo.divCode);
			
			mpo250skrvService.getThisWeek({}, function(provider, response) {
				if(!Ext.isEmpty(provider)){
					panelSearch.setValue('ORDER_WEEK',provider.CAL_NO, false);
				}
			})
			
			UniAppManager.setToolbarButtons(['reset'], true);
			UniAppManager.setToolbarButtons(['print','newData','delete','save'], false);
		}
	});
	
};
</script>