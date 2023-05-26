<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="biv440skrv"  >
	<t:ExtComboStore comboType="BOR120"  />	<!-- 사업장 -->
	<t:ExtComboStore comboType="O" />		<!-- 창고-->
	<t:ExtComboStore comboType="W" />		<!-- 작업장  -->

	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />

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
        data :  [
            {'text':'<t:message code="system.label.purchase.confirm" default="확인"/>'  , 'value':'Y'},
            {'text':'<t:message code="system.label.purchase.notconfirm" default="미확인"/>'  , 'value':'N'}
        ]
    });

	Unilite.defineModel('detailModel', {
		fields: [
             { name: 'EXPIRY_TYPE'       ,text:'기한구분'            ,type: 'string'},
             { name: 'SEQ'       		,text:'번호'            ,type: 'int'},
             { name: 'ITEM_CODE'       	,text:'품목코드'            ,type: 'string'},
             { name: 'ITEM_NAME'       	,text:'품목명'            ,type: 'string'},
             { name: 'STOCK'       		,text:'현재고량'            ,type: 'uniQty'},
             { name: 'AVERAGE_P'       	,text:'평균단가'            ,type: 'uniUnitPrice'},
             { name: 'STOCK_AMT'       	,text:'재고금액'            ,type: 'uniPrice'},
             { name: 'GOOD_STOCK'       ,text:'양품수량'            ,type: 'uniQty'},
             { name: 'BAD_STOCK'       	,text:'불량수량'            ,type: 'uniQty'},
             { name: 'S_EXPIRY_DATE_YH'       ,text:'유통기한'            ,type: 'uniDate'},
             { name: 'S_INOUT_DATE'       ,text:'수불일자'            ,type: 'uniDate'},
             { name: 'LOT_NO'       		,text:'LOT NO'            ,type: 'string'},
             { name: 'REMARK'       		,text:'비고'            ,type: 'string'}



        ]
	});

	var detailStore = Unilite.createStore('detailStore',{
		model: 'detailModel',
		proxy: {
			type: 'direct',
			api: {
				read	: 'biv440skrvService.selectList'
			}
		},
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,	// 상위 버튼 연결
			editable	: false,		// 수정 모드 사용
			deletable	: false,		// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		loadStoreRecords : function()	{
			var param= panelSearch.getValues();
			this.load({
				params : param
			});
		},
		saveStore : function(config)	{
			var inValidRecs = this.getInvalidRecords();
			if(inValidRecs.length == 0 ) {
				config = {
					success: function(batch, option) {
						detailStore.loadStoreRecords();
					}
				};
				this.syncAllDirect(config);

			} else {
				detailGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
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
						panelSearch.setValue('WH_CODE','');
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.inventory.warehouse" default="창고"/>',
				name:'WH_CODE',
				xtype: 'uniCombobox',
				comboType:'O',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('WH_CODE', newValue);
					},
					beforequery:function( queryPlan, eOpts )   {
						var store = queryPlan.combo.store;
						var prStore = panelResult.getField('WH_CODE').store;
						store.clearFilter();
						prStore.clearFilter();
						if(!Ext.isEmpty(panelResult.getValue('DIV_CODE'))){
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
			},

			Unilite.popup('DIV_PUMOK',{
	        	fieldLabel: '<t:message code="system.label.inventory.item" default="품목"/>',
	        	valueFieldName: 'ITEM_CODE',
				textFieldName: 'ITEM_NAME',
				validateBlank: false,
	        	listeners: {
//							onSelected: {
//								fn: function(records, type) {
//									console.log('records : ', records);
//									panelResult.setValue('ITEM_CODE', panelSearch.getValue('ITEM_CODE'));
//									panelResult.setValue('ITEM_NAME', panelSearch.getValue('ITEM_NAME'));
//		                    	},
//								scope: this
//							},
//							onClear: function(type)	{
//								panelResult.setValue('ITEM_CODE', '');
//								panelResult.setValue('ITEM_NAME', '');
//							},
	        		onValueFieldChange: function(field, newValue){
                        panelResult.setValue('ITEM_CODE', newValue);
                    },
                    onTextFieldChange: function(field, newValue){
                        panelResult.setValue('ITEM_NAME', newValue);
                    },
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}
		   }),
			{
				fieldLabel: '<t:message code="system.label.inventory.majorgroup" default="대분류"/>',
				name: 'ITEM_LEVEL1' ,
				xtype: 'uniCombobox' ,
				store: Ext.data.StoreManager.lookup('itemLeve1Store') ,
				child: 'ITEM_LEVEL2',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ITEM_LEVEL1', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.inventory.middlegroup" default="중분류"/>',
				name: 'ITEM_LEVEL2' ,
				xtype: 'uniCombobox' ,
				store: Ext.data.StoreManager.lookup('itemLeve2Store') ,
				child: 'ITEM_LEVEL3',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ITEM_LEVEL2', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.inventory.minorgroup" default="소분류"/>',
				name: 'ITEM_LEVEL3' ,
				xtype: 'uniCombobox' ,
				store: Ext.data.StoreManager.lookup('itemLeve3Store'),
	            parentNames:['ITEM_LEVEL1','ITEM_LEVEL2'],
	            levelType:'ITEM',
				colspan:2,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ITEM_LEVEL3', newValue);
					}
				}
			},{
				fieldLabel:'기준일',
                xtype: 'uniDatefield',
                name: 'BASE_DATE',
                value: UniDate.get('today'),
				allowBlank: false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('BASE_DATE', newValue);
                    }
                }
			},{
				xtype: 'radiogroup',
				fieldLabel: '유통기한',
				labelWidth:90,
				colspan:3,
				items : [{
					boxLabel: '폐기',
					width: 60,
					name: 'EXPIRY_SEQ',
					inputValue: '1'
				},{
					boxLabel: '6개월',
					width: 60,
					name: 'EXPIRY_SEQ' ,
					inputValue: '2'
				},{
					boxLabel: '12개월',
					width: 60,
					name: 'EXPIRY_SEQ' ,
					inputValue: '3'
				},{
					boxLabel: '전체',
					width: 60,
					name: 'EXPIRY_SEQ' ,
					inputValue: '',
					checked: true
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.getField('EXPIRY_SEQ').setValue(newValue.EXPIRY_SEQ);
					}
				}
			}]
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
					panelResult.setValue('WH_CODE','');
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.inventory.warehouse" default="창고"/>',
			name:'WH_CODE',
			xtype: 'uniCombobox',
			comboType:'O',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('WH_CODE', newValue);
				},
				beforequery:function( queryPlan, eOpts )   {
					var store = queryPlan.combo.store;
					var psStore = panelSearch.getField('WH_CODE').store;
					store.clearFilter();
					psStore.clearFilter();
					if(!Ext.isEmpty(panelResult.getValue('DIV_CODE'))){
						store.filterBy(function(record){
							return record.get('option') == panelResult.getValue('DIV_CODE');
						});
						psStore.filterBy(function(record){
							return record.get('option') == panelResult.getValue('DIV_CODE');
						});
					}else{
						store.filterBy(function(record){
							return false;
						});
						psStore.filterBy(function(record){
							return false;
						});
					}
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
		},

		Unilite.popup('DIV_PUMOK',{
        	fieldLabel: '<t:message code="system.label.inventory.item" default="품목"/>',
        	valueFieldName: 'ITEM_CODE',
			textFieldName: 'ITEM_NAME',
			validateBlank: false,
        	listeners: {
//							onSelected: {
//								fn: function(records, type) {
//									console.log('records : ', records);
//									panelResult.setValue('ITEM_CODE', panelSearch.getValue('ITEM_CODE'));
//									panelResult.setValue('ITEM_NAME', panelSearch.getValue('ITEM_NAME'));
//		                    	},
//								scope: this
//							},
//							onClear: function(type)	{
//								panelResult.setValue('ITEM_CODE', '');
//								panelResult.setValue('ITEM_NAME', '');
//							},
        		onValueFieldChange: function(field, newValue){
                    panelSearch.setValue('ITEM_CODE', newValue);
                },
                onTextFieldChange: function(field, newValue){
                    panelSearch.setValue('ITEM_NAME', newValue);
                },
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
				}
			}
	   }),
		{
			fieldLabel: '<t:message code="system.label.inventory.majorgroup" default="대분류"/>',
			name: 'ITEM_LEVEL1' ,
			xtype: 'uniCombobox' ,
			store: Ext.data.StoreManager.lookup('itemLeve1Store') ,
			child: 'ITEM_LEVEL2',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('ITEM_LEVEL1', newValue);
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.inventory.middlegroup" default="중분류"/>',
			name: 'ITEM_LEVEL2' ,
			xtype: 'uniCombobox' ,
			store: Ext.data.StoreManager.lookup('itemLeve2Store') ,
			child: 'ITEM_LEVEL3',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('ITEM_LEVEL2', newValue);
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.inventory.minorgroup" default="소분류"/>',
			name: 'ITEM_LEVEL3' ,
			xtype: 'uniCombobox' ,
			store: Ext.data.StoreManager.lookup('itemLeve3Store'),
            parentNames:['ITEM_LEVEL1','ITEM_LEVEL2'],
            levelType:'ITEM',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('ITEM_LEVEL3', newValue);
				}
			}
		},{
			fieldLabel:'기준일',
            xtype: 'uniDatefield',
            name: 'BASE_DATE',
            value: UniDate.get('today'),
			allowBlank: false,
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelSearch.setValue('BASE_DATE', newValue);
                }
            }

		},{
			xtype: 'radiogroup',
			fieldLabel: '유통기한',
			labelWidth:90,
			colspan:3,
			items : [{
				boxLabel: '폐기',
				width: 60,
				name: 'EXPIRY_SEQ',
				inputValue: '1'
			},{
				boxLabel: '6개월',
				width: 60,
				name: 'EXPIRY_SEQ' ,
				inputValue: '2'
			},{
				boxLabel: '12개월',
				width: 60,
				name: 'EXPIRY_SEQ' ,
				inputValue: '3'
			},{
				boxLabel: '전체',
				width: 60,
				name: 'EXPIRY_SEQ' ,
				inputValue: '',
				checked: true
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.getField('EXPIRY_SEQ').setValue(newValue.EXPIRY_SEQ);
				}
			}
		}]
    });

	var detailGrid = Unilite.createGrid('detailGrid', {
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
				useState: true,
				useStateList: true
			}
		},
		features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true },
					{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: true} ],
		store: detailStore,
		columns: [
             { dataIndex: 'EXPIRY_TYPE'            ,  width: 100,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.inventory.subtotal" default="소계"/>', '<t:message code="system.label.inventory.total" default="총계"/>');
				}
             },
             { dataIndex: 'SEQ'       			,  width: 80 },
             { dataIndex: 'ITEM_CODE'       		,  width: 100 },
             { dataIndex: 'ITEM_NAME'       		,  width: 250 },
             { dataIndex: 'STOCK'       			,  width: 120, summaryType: 'sum' },
             { dataIndex: 'AVERAGE_P'       		,  width: 120, summaryType: 'sum' },
             { dataIndex: 'STOCK_AMT'       		,  width: 120, summaryType: 'sum' },
             { dataIndex: 'GOOD_STOCK'       	,  width: 120, summaryType: 'sum' },
             { dataIndex: 'BAD_STOCK'       		,  width: 120, summaryType: 'sum' },
             { dataIndex: 'S_EXPIRY_DATE_YH' 	,  width: 100 },
             { dataIndex: 'S_INOUT_DATE' 	,  width: 100 },
             { dataIndex: 'LOT_NO'       		,  width: 100 },
             { dataIndex: 'REMARK'       		,  width: 200 }
  		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {}
		}
	});
	Unilite.Main({
		borderItems: [{
			id: 'pageAll',
			region: 'center',
			layout: 'border',
			border: false,
			items: [
				detailGrid, panelResult
			]
		},
			panelSearch
		],
		id: 'biv440skrvApp',
		fnInitBinding: function() {
			this.fnInitInputFields();
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			detailGrid.reset();
			detailStore.clearData();

			this.fnInitInputFields();
		},
		onQueryButtonDown: function() {
            if(!panelSearch.getInvalidMessage()) return;   //필수체크
			panelSearch.getField('DIV_CODE').setReadOnly(true);
			detailStore.loadStoreRecords();
		},
		fnInitInputFields: function(){
			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			panelSearch.getField('DIV_CODE').setReadOnly(false);

			panelSearch.setValue('FR_ORDER_DATE', UniDate.get('startOfMonth'));
			panelSearch.setValue('TO_ORDER_DATE', UniDate.get('today'));

			UniAppManager.setToolbarButtons(['reset'], true);
			UniAppManager.setToolbarButtons(['print','newData','delete','save'], false);
		}
	});

};
</script>