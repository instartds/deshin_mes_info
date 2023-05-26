<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="pmr200skrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="W" /><!-- 작업장  -->
	<t:ExtComboStore comboType="AU" comboCode="B020" /> <!-- 품목계정 -->

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
	Unilite.defineModel('Pmr200skrvModel1', {
	    fields: [
	    	{name: 'WORK_SHOP_NAME'	, text: '<t:message code="system.label.product.workcentername" default="작업장명"/>'		, type: 'string'},
	    	{name: 'WORK_SHOP_CODE'	, text: '<t:message code="system.label.product.workcenter" default="작업장"/>'		, type: 'string'},
		    {name: 'ITEM_CODE'     	, text: '<t:message code="system.label.product.item" default="품목"/>'		, type: 'string'},
		    {name: 'ITEM_NAME'     	, text: '<t:message code="system.label.product.itemname" default="품목명"/>'		, type: 'string'},
		    {name: 'ITEM_NAME1'     	, text: '<t:message code="system.label.product.itemname" default="품목명"/>1'		, type: 'string'},
		    {name: 'SPEC'          	, text: '<t:message code="system.label.product.spec" default="규격"/>'		, type: 'string'},
		    {name: 'STOCK_UNIT'    	, text: '<t:message code="system.label.product.unit" default="단위"/>'		, type: 'string'},
		    {name: 'PRODT_Q'       	, text: '<t:message code="system.label.product.totalproductionqty" default="총생산량"/>'		, type: 'uniQty'},
		    {name: 'GOOD_Q'        	, text: '<t:message code="system.label.product.goodoutputqty" default="양품생산량"/>'	, type: 'uniQty'},
		    {name: 'BAD_Q'         	, text: '<t:message code="system.label.product.defectoutputqty" default="불량"/>'	, type: 'uniQty'},
		    {name: 'IN_STOCK_Q'    	, text: '<t:message code="system.label.product.totalreceiptqty" default="총입고량"/>'	, type: 'uniQty'},
		    {name: 'UNIT_WGT'      	, text: '<t:message code="system.label.product.unitweight" default="단위중량"/>'		, type: 'string'},
		    {name: 'WGT_UNIT'      	, text: '<t:message code="system.label.product.weightunit" default="중량단위"/>'		, type: 'string'},
		    {name: 'PRODT_WGT_Q'   	, text: '<t:message code="system.label.product.totalproductionweight" default="총생산중량"/>'	, type: 'string'},
		    {name: 'GOOD_WGT_Q'    	, text: '<t:message code="system.label.product.goodoutputweight" default="양품생산중량"/>'	, type: 'string'},
		    {name: 'BAD_WGT_Q'     	, text: '<t:message code="system.label.product.defectproductionweight" default="불량생산중량"/>'	, type: 'string'},
		    {name: 'IN_STOCK_WGT_Q'	, text: '<t:message code="system.label.product.totalreceiptweight" default="총입고중량"/>'	, type: 'string'},
		    {name: 'MAN_HOUR'      	, text: '<t:message code="system.label.product.inputtime" default="투입공수"/>'		,type:'float', decimalPrecision: 2, format:'0,000.00'},
		    {name: 'PRODT_DATE'     , text: '<t:message code="system.label.product.productiondate" default="생산일"/>'      , type: 'uniDate'},
		    {name: 'WKORD_NUM'      , text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>'  , type: 'string'}

	    ]
	}); //End of Unilite.defineModel('Pmr200skrvModel1', {

	Unilite.defineModel('Pmr200skrvModel2', {
	    fields: [
	    	{name: 'PRODT_DATE'    	, text: '<t:message code="system.label.product.productiondate" default="생산일"/>'		, type: 'uniDate'},
		    {name: 'PRODT_Q'       	, text: '<t:message code="system.label.product.productionqty" default="생산량"/>'		, type: 'uniQty'},
		    {name: 'GOOD_Q'        	, text: '<t:message code="system.label.product.goodoutputqty" default="양품생산량"/>'	, type: 'uniQty'},
		    {name: 'BAD_Q'         	, text: '<t:message code="system.label.product. defectoutputqty" default="불량"/>'	, type: 'uniQty'},
		    {name: 'IN_STOCK_Q'    	, text: '<t:message code="system.label.product.receiptqty" default="입고량"/>'		, type: 'uniQty'},
		    {name: 'PRODT_WGT_Q'   	, text: '<t:message code="system.label.product.productionweight" default="생산중량"/>'		, type: 'string'},
		    {name: 'GOOD_WGT_Q'    	, text: '<t:message code="system.label.product.goodoutputweight" default="양품생산중량"/>'	, type: 'string'},
		    {name: 'BAD_WGT_Q'     	, text: '<t:message code="system.label.product.defectproductionweight" default="불량생산중량"/>'	, type: 'string'},
		    {name: 'IN_STOCK_WGT_Q'	, text: '<t:message code="system.label.product.receiptweight" default="입고중량"/>'		, type: 'string'},
		    {name: 'MAN_HOUR'      	, text: '<t:message code="system.label.product.inputtime" default="투입공수"/>'		,type:'float', decimalPrecision: 2, format:'0,000.00'},
		    {name: 'REMARK'        	, text: '<t:message code="system.label.product.remarks" default="비고"/>'		, type: 'string'},
		    {name: 'LOT_NO'        	, text: 'LOT_NO'		, type: 'string'}
	    ]
	});
	/**
	 * Store 정의(Service 정의)
	 * @type
	 */

	var directMasterStore1 = Unilite.createStore('pmr200skrvMasterStore1',{
		model: 'Pmr200skrvModel1',
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
            	read: 'pmr200skrvService.selectList'
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
           		if(records[0] != null){
      				panelSearch.setValue('TEMP_ITEM_CODE',records[0].get('ITEM_CODE'));
      				panelSearch.setValue('TEMP_WORK_SHOP_CODE',records[0].get('WORK_SHOP_CODE'));
	           		directMasterStore2.loadStoreRecords(records);
           		}
           	},
           	add: function(store, records, index, eOpts) {

           	},
           	update: function(store, record, operation, modifiedFieldNames, eOpts) {

           	},
           	remove: function(store, record, index, isMove, eOpts) {
           	}
		}
	}); //End of var directMasterStore1 = Unilite.createStore('pmr200skrvMasterStore1',{

	var directMasterStore2 = Unilite.createStore('pmr200skrvMasterStore2',{
		model: 'Pmr200skrvModel2',
		uniOpt: {
            isMaster: false,			// 상위 버튼 연결
            editable: false,			// 수정 모드 사용
            deletable:false,			// 삭제 가능 여부
	           useNavi : false			// prev | next 버튼 사용
            },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {
            	read: 'pmr200skrvService.selectDetailList'
            }
        }
		,loadStoreRecords: function()	{
			var param = Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		}
	});

	/**
	 * 검색조건 (Search Panel)
	 * @type
	 */

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
	        	fieldLabel: '<t:message code="system.label.product.resultsdate" default="실적일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'PRODT_DATE_FR',
	        	endFieldName:'PRODT_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
	                	if(panelResult) {
							panelResult.setValue('PRODT_DATE_FR',newValue);
							//panelResult.getField('ISSUE_REQ_DATE_FR').validate();
	                	}
				    },
				    onEndDateChange: function(field, newValue, oldValue, eOpts) {
				    	if(panelResult) {
				    		panelResult.setValue('PRODT_DATE_TO',newValue);
				    		//panelResult.getField('ISSUE_REQ_DATE_TO').validate();
				    	}
				    }
			},{
				fieldLabel: '<t:message code="system.label.product.itemaccount" default="품목계정"/>',
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
			},
				Unilite.popup('ITEM',{
					fieldLabel		: '<t:message code="system.label.product.item" default="품목"/>',
					valueFieldName	: 'ITEM_CODE',
					textFieldName	: 'ITEM_NAME',
					textFieldWidth	: 170,
					validateBlank	: false,
					width			: 380,
					listeners: {
						onValueFieldChange: function( elm, newValue, oldValue ) {
							panelResult.setValue('ITEM_CODE', newValue);
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('ITEM_NAME', '');
								panelSearch.setValue('ITEM_NAME', '');
							}
						},
						onTextFieldChange: function( elm, newValue, oldValue ) {
							panelResult.setValue('ITEM_NAME', newValue);
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('ITEM_CODE', '');
								panelSearch.setValue('ITEM_CODE', '');
							}
						}
					}
			}),{
				xtype: 'checkbox',
				name: 'REMARK_YN',
				inputValue :'Y',
				fieldLabel:'<t:message code="system.label.product.remarkrendering" default="비고표현"/>',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('REMARK_YN', newValue);

						if(newValue == false){
							masterGrid2.getColumn('REMARK').setVisible(false);
						}else{
							masterGrid2.getColumn('REMARK').setVisible(true);
						}
					}
				}
			},{
				fieldLabel: 'ITEM_CODE',
				name:'TEMP_ITEM_CODE',
				xtype: 'uniTextfield',
				hidden: true
			},{
				fieldLabel: 'WORK_SHOP_CODE',
				name:'TEMP_WORK_SHOP_CODE',
				xtype: 'uniTextfield',
				hidden: true
			},{
				xtype:'uniTextfield',
				fieldLabel:'수주번호',
				name:'SO_NUM',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('SO_NUM', newValue);
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
	        	fieldLabel: '<t:message code="system.label.product.resultsdate" default="실적일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'PRODT_DATE_FR',
	        	endFieldName:'PRODT_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
	            	if(panelSearch) {
						panelSearch.setValue('PRODT_DATE_FR',newValue);
						//panelSearch.getField('ISSUE_REQ_DATE_FR').validate();

	            	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('PRODT_DATE_TO',newValue);
			    		//panelSearch.getField('ISSUE_REQ_DATE_TO').validate();
			    	}
			    }
			},{
				fieldLabel: '<t:message code="system.label.product.itemaccount" default="품목계정"/>',
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
			},
				Unilite.popup('ITEM',{
					fieldLabel		: '<t:message code="system.label.product.item" default="품목"/>',
					valueFieldName	: 'ITEM_CODE',
					textFieldName	: 'ITEM_NAME',
					textFieldWidth	: 170,
					validateBlank	: false,
					width			: 380,
					listeners: {
						onValueFieldChange: function( elm, newValue, oldValue ) {
							panelSearch.setValue('ITEM_CODE', newValue);
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('ITEM_NAME', '');
								panelSearch.setValue('ITEM_NAME', '');
							}
						},
						onTextFieldChange: function( elm, newValue, oldValue ) {
							panelSearch.setValue('ITEM_NAME', newValue);
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('ITEM_CODE', '');
								panelSearch.setValue('ITEM_CODE', '');
							}
						}
					}

			}),{
				xtype: 'checkbox',
				name: 'REMARK_YN',
				inputValue :'Y',
				fieldLabel:'<t:message code="system.label.product.remarkrendering" default="비고표현"/>',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('REMARK_YN', newValue);

						if(newValue == false){
							masterGrid2.getColumn('REMARK').setVisible(false);
						}else{
							masterGrid2.getColumn('REMARK').setVisible(true);
						}
					}
				}
			},{
				xtype:'uniTextfield',
				fieldLabel:'수주번호',
				name:'SO_NUM',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('SO_NUM', newValue);
					}
				}
			}]
    });

    /**
     * Master Grid1 정의(Grid Panel)
     * @type
     */

    var masterGrid1 = Unilite.createGrid('pmr200skrvGrid1', {
    	layout : 'fit',
    	region:'center',
        store : directMasterStore1,
        uniOpt:{
        	expandLastColumn: true,
    		useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
    		useGroupSummary: false,
			useRowNumberer: false,
			onLoadSelectFirst	: true,
			filter: {
				useFilter: true,
				autoCreate: true
			}
        },
       /* tbar: [{
        	text:'상세보기',
        	handler: function() {
        		var record = masterGrid.getSelectedRecord();
	        	if(record) {
	        		openDetailWindow(record);
	        	}
        	}
        }],*/
    	features: [
    		{id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true},
    	    {id: 'masterGridTotal',    ftype: 'uniSummary', 	    showSummaryRow: true}
    	],
        columns: [
        	{dataIndex: 'WORK_SHOP_NAME'			,         	width: 100,
        	summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
		        return Unilite.renderSummaryRow(summaryData, metaData, '', '<t:message code="system.label.product.totalamount" default="합계"/>');
            }},
			{dataIndex: 'ITEM_CODE'     			,         	width: 106},
			{dataIndex: 'ITEM_NAME'     			,         	width: 140},
			{dataIndex: 'ITEM_NAME1'     			,         	width: 140, hidden:true},
			{dataIndex: 'SPEC'          			,         	width: 133},
			{dataIndex: 'STOCK_UNIT'    			,         	width: 53},
			{dataIndex: 'PRODT_Q'       			,         	width: 93 , summaryType: 'sum'},
			{dataIndex: 'GOOD_Q'        			,         	width: 93 , summaryType: 'sum'},
			{dataIndex: 'BAD_Q'         			,         	width: 93 , summaryType: 'sum'},
			{dataIndex: 'IN_STOCK_Q'    			,         	width: 93 , summaryType: 'sum'},
			{dataIndex: 'UNIT_WGT'      			,         	width: 66, hidden:true},
			{dataIndex: 'WGT_UNIT'      			,         	width: 53, hidden:true},
			{dataIndex: 'PRODT_WGT_Q'   			,         	width: 93, hidden:true},
			{dataIndex: 'GOOD_WGT_Q'    			,         	width: 93, hidden:true},
			{dataIndex: 'BAD_WGT_Q'     			,         	width: 93, hidden:true},
			{dataIndex: 'IN_STOCK_WGT_Q'			,         	width: 93, hidden:true},
			{dataIndex: 'MAN_HOUR'      			,         	width:80  , summaryType: 'sum'}
		],
		listeners: {
	    	cellclick: function( viewTable, td, cellIndex, record, tr, rowIndex, e, eOpts , colName) {
          		this.returnCell(record, colName);
          		directMasterStore2.loadStoreRecords(record);
   			}
       	},
        returnCell: function(record, colName){
        	var itemCode         = record.get("ITEM_CODE");
          	var workCode		 = record.get("WORK_SHOP_CODE");
          	panelSearch.setValues({'TEMP_ITEM_CODE':itemCode});
          	panelSearch.setValues({'TEMP_WORK_SHOP_CODE':workCode});
         }
    });

    var masterGrid2 = Unilite.createGrid('pmr200skrvGrid2', {
		layout : 'fit',
    	region:'east',
        store : directMasterStore2,
        uniOpt:{
        	expandLastColumn: true,
    		useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
    		useGroupSummary: true,
			useRowNumberer: false,
			onLoadSelectFirst	: true,
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
        	{dataIndex: 'PRODT_DATE'    	, width: 88 ,
        	summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
		        return Unilite.renderSummaryRow(summaryData, metaData, '', '<t:message code="system.label.product.totalamount" default="합계"/>');
            }},
			{dataIndex: 'PRODT_Q'       	, width: 80 , summaryType: 'sum'},
			{dataIndex: 'GOOD_Q'        	, width: 100},
			{dataIndex: 'BAD_Q'         	, width: 80},
			{dataIndex: 'IN_STOCK_Q'    	, width: 80 , summaryType: 'sum'},
			{dataIndex: 'PRODT_WGT_Q'   	, width: 80, hidden: true},
			{dataIndex: 'GOOD_WGT_Q'    	, width: 80, hidden: true},
			{dataIndex: 'BAD_WGT_Q'     	, width: 80, hidden: true},
			{dataIndex: 'IN_STOCK_WGT_Q'	, width: 80, hidden: true},
			{dataIndex: 'MAN_HOUR'      	, width: 100 , summaryType: 'sum'},
			{dataIndex: 'LOT_NO'			, width: 80, hidden: false, align:'center'},
			{dataIndex: 'REMARK'        	, width: 100, hidden: false}
		]
	});

	Unilite.Main( {
		borderItems:[{
         region:'center',
         layout: 'border',
         border: false,
         items:[
            masterGrid1, masterGrid2, panelResult
         ]
      },
         panelSearch
      ],
		id  : 'pmr200skrvApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);

//			masterGrid2.getColumn('REMARK').setHidden(true);
//			masterGrid2.getColumn('REMARK').setVisible(false);
		},
		onQueryButtonDown : function()	{
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
				directMasterStore1.loadStoreRecords();
				/*var viewNormal = masterGrid1.normalGrid.getView();
				var viewLocked = masterGrid1.lockedGrid.getView();

				console.log("viewNormal : ",viewNormal);
				console.log("viewLocked : ",viewLocked);

				viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
				viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
			    viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			    viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);*/
			    UniAppManager.setToolbarButtons('excel',true);
			}
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		},
		checkForNewDetail:function() {
			return panelSearch.setAllFieldsReadOnly(true);
        }
	});
};


</script>
