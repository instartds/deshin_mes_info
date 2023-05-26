<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_pmr200skrv_sh"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->     
	<t:ExtComboStore comboType="W" /><!-- 작업장  -->
	<t:ExtComboStore comboType="AU" comboCode="B020" /> <!-- 품목계정 -->

</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {   
	var chkinterval = null;
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('model1', {
	    fields: [  	  
	    	{name: 'SO_NUM'	, text: '<t:message code="system.label.product.sono" default="수주번호"/>'				, type: 'string'},
		    {name: 'ITEM_CODE'  , text: '<t:message code="system.label.product.item" default="품목"/>'				, type: 'string'},
		    {name: 'ITEM_NAME'  , text: '<t:message code="system.label.product.itemname" default="품목명"/>'			, type: 'string'},
	    	{name: 'WKORD_Q'	, text: '<t:message code="system.label.product.workorderqty" default="작업지시량"/>'	, type: 'uniQty'},
	    	{name: 'WORK_Q'		, text: '작업량'		, type: 'uniQty'},
	    	{name: 'JAN_Q'		, text: '잔량'		, type: 'uniQty'},
	    	{name: 'WKORD_STATUS'			, text: '완료여부'		, type: 'string'}
	
	    ]
	});
	
	var detailStore = Unilite.createStore('detailStore',{
		model: 'model1',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: false,		// 수정 모드 사용 
            deletable: false,		// 삭제 가능 여부 
	        useNavi : false			// prev | next 버튼 사용
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {			
            	read: 's_pmr200skrv_shService.selectList'                	
            }
        }
		,loadStoreRecords : function()	{
			var param = Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params: param
			});
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
	
	var panelSearch = Unilite.createSearchPanel('searchForm',{
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
		items: [{	
			title: '<t:message code="system.label.product.basisinfo" default="기본정보"/>', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items: [{
	        	fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
	        	name:'DIV_CODE', 
	        	xtype: 'uniCombobox', 
	        	comboType:'BOR120', 
	        	allowBlank: false,
	        	value : UserInfo.divCode,
	        	listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
						panelSearch.setValue('WORK_SHOP_CODE','');
					}
				}
	        },{
				fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
				name:'WORK_SHOP_CODE', 
				xtype: 'uniCombobox', 
				comboType:'W',
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
	        	fieldLabel: '일자', 
				xtype: 'uniDateRangefield', 
				startFieldName: 'PRODT_WKORD_DATE_FR',
	        	endFieldName:'PRODT_WKORD_DATE_TO',
				startDate: UniDate.get('today'),
				endDate: UniDate.get('today'),
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
	                	if(panelResult) {
							panelResult.setValue('PRODT_WKORD_DATE_FR',newValue);
							//panelResult.getField('ISSUE_REQ_DATE_FR').validate();
	                	}
				    },
				    onEndDateChange: function(field, newValue, oldValue, eOpts) {
				    	if(panelResult) {
				    		panelResult.setValue('PRODT_WKORD_DATE_TO',newValue);
				    		//panelResult.getField('ISSUE_REQ_DATE_TO').validate();				    		
				    	}
				    }
			}]	            			 
		}]
    });    
	
    var panelResult = Unilite.createSimpleForm('panelResultForm', {
		region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
    	items: [{
        	fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
        	name:'DIV_CODE', 
        	xtype: 'uniCombobox', 
        	comboType:'BOR120', 
        	allowBlank: false,
        	value : UserInfo.divCode,
        	listeners: {
			change: function(field, newValue, oldValue, eOpts) {						
				panelSearch.setValue('DIV_CODE', newValue);
				panelResult.setValue('WORK_SHOP_CODE','');
				}
			}
        },{
			fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
			name:'WORK_SHOP_CODE', 
			xtype: 'uniCombobox', 
			comboType:'W',
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
		},{
        	fieldLabel: '일자', 
			xtype: 'uniDateRangefield', 
			startFieldName: 'PRODT_WKORD_DATE_FR',
        	endFieldName:'PRODT_WKORD_DATE_TO',
			startDate: UniDate.get('today'),
			endDate: UniDate.get('today'),
			width: 315,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
					panelSearch.setValue('PRODT_WKORD_DATE_FR',newValue);
					//panelSearch.getField('ISSUE_REQ_DATE_FR').validate();
					
            	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('PRODT_WKORD_DATE_TO',newValue);
		    		//panelSearch.getField('ISSUE_REQ_DATE_TO').validate();				    		
		    	}
		    }
		}]	            			 
    });
    
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var detailGrid = Unilite.createGrid('detailGrid', {
    	layout : 'fit',
    	region:'center',
        store : detailStore, 
        uniOpt:{
        	expandLastColumn: false,
    		useLiveSearch: false,
			useContextMenu: false,
			useMultipleSorting: true,
    		useGroupSummary: false,
			useRowNumberer: false,
			onLoadSelectFirst	: false,
			filter: {
				useFilter: true,
				autoCreate: true
			}
        },
    	features: [ 
    		{id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true},
    	    {id: 'masterGridTotal',    ftype: 'uniSummary', 	    showSummaryRow: true} 
    	],
        columns: [
			{dataIndex: 'SO_NUM'	     			,         	width: 100},
			{dataIndex: 'ITEM_CODE'       			,         	width: 150},
			{dataIndex: 'ITEM_NAME'       			,         	width: 300},
			{dataIndex: 'WKORD_Q'	     			,         	width: 120},
			{dataIndex: 'WORK_Q'		     		,         	width: 120},
			{dataIndex: 'JAN_Q'		     			,         	width: 120},
			{dataIndex: 'WKORD_STATUS'		     	,         	width: 80, align:'center'}					
		]
    });
    
	Unilite.Main({
		borderItems:[{
			region:'center',
			layout: 'border',
 			border: false,
         	items:[
				detailGrid, panelResult
			]
		},
			panelSearch
		],	
		id  : 's_pmr200skrv_shApp',
		fnInitBinding : function() {
			this.fnInitInputFields();
		},
		onQueryButtonDown : function()	{		
			if(!panelResult.getInvalidMessage()) return;   //필수체크
			detailStore.loadStoreRecords();
			clearInterval(chkinterval);
			chkinterval = setInterval(function(){ detailStore.loadStoreRecords();}, 30000);
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			detailGrid.reset();
			detailStore.clearData();
			clearInterval(chkinterval);
			this.fnInitInputFields();
		},
		fnInitInputFields: function(){
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			
			panelSearch.setValue('PRODT_WKORD_DATE_FR',UniDate.get('today'));
			panelSearch.setValue('PRODT_WKORD_DATE_TO',UniDate.get('today'));
			panelResult.setValue('PRODT_WKORD_DATE_FR',UniDate.get('today'));
			panelResult.setValue('PRODT_WKORD_DATE_TO',UniDate.get('today'));
			UniAppManager.setToolbarButtons('save', false);
		}
	});
};


</script>
