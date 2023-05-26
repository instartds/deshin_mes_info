<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_mpo250ukrv_kodi"  >
	<t:ExtComboStore comboType="BOR120"  />	<!-- 사업장 -->
	<t:ExtComboStore comboType="O" />		<!-- 창고-->
	<t:ExtComboStore comboType="W" />		<!-- 작업장  -->
	<t:ExtComboStore comboType="AU" comboCode="M002" /> <!-- 진행상태 -->
	<t:ExtComboStore comboType="AU" comboCode="Z019"/>	<!-- 입고에정일변경사유 -->
	<t:ExtComboStore comboType="AU" comboCode="B020" opts="60;70"/> <!-- 품목계정 -->
<t:ExtComboStore items="${COMBO_ORDER_WEEK}" storeId="orderWeekList" /><!--발주주차관련-->


</t:appConfig>

<style type="text/css">
.x-change-cell {
background-color: #FFFFC6;
}
</style>

<script type="text/javascript" >

function appMain() {

	// GroupField string type으로 변환
	function dateToString(v, record){
		return UniDate.safeFormat(v);
	}

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy', {
		api: {
			read	: 's_mpo250ukrv_kodiService.selectMasterList',
			update	: 's_mpo250ukrv_kodiService.updateDetail',
			syncAll	: 's_mpo250ukrv_kodiService.saveAll'
		}
	});

	Unilite.defineModel('masterModel', {
		fields: [
            { name: 'OUT_DIV_CODE'   	,text:'사업장'             ,type: 'string'},
    		{ name: 'CUSTOM_CODE'  		,text:'거래처'             ,type: 'string'},
            { name: 'CUSTOM_NAME'       ,text:'거래처명'            ,type: 'string'},
            { name: 'ITEM_CODE'         ,text:'품목코드'            ,type: 'string'},
            { name: 'ITEM_NAME'         ,text:'품목명'            	,type: 'string'},
        	{ name: 'ORDER_Q'           ,text:'수주량'            	,type: 'uniQty'},
            { name: 'ORDER_DATE'       	,text:'수주일'             ,type: 'uniDate'},
            { name: 'DVRY_DATE'       	,text:'납기일'             ,type: 'uniDate'},
            { name: 'DVRY_CUSTOM_NAME'  ,text:'발주거래처'           ,type: 'string'},
            { name: 'CHLD_ITEM_CODE'    ,text:'부자재코드'           ,type: 'string'},
            { name: 'CHLD_ITEM_NAME'    ,text:'부자재명'            ,type: 'string'},
            { name: 'ORDER_UNIT'        ,text:'구매단위'            ,type: 'string'},
            { name: 'CALC_PLAN_QTY'     ,text:'구매계획량'           ,type: 'uniQty'},
            { name: 'ORDER_PLAN_DATE'   ,text:'구매요청일'           ,type: 'uniDate'},
            { name: 'ORDER_REQ_Q'       ,text:'구매요청량'           ,type: 'uniQty'},
            { name: 'PL_QTY'            ,text:'총소요량'            ,type: 'uniQty'},
            { name: 'INIT_DVRY_DATE'    ,text:'입고요청일'           ,type: 'uniDate'},
            { name: 'IN_DVRY_DATE'      ,text:'입고예정일'           ,type: 'uniDate',allowBlank:false},
            { name: 'REASON'       		,text:'입고예정일 변경사유'      ,type: 'string', comboType: 'AU', comboCode: 'Z019'},
            { name: 'INOUT_DATE'       	,text:'입고일'             ,type: 'uniDate'},
            { name: 'IN_ORDER_DATE'     ,text:'발주일'             ,type: 'uniDate'},
            { name: 'IN_ORDER_Q'       	,text:'발주량'             ,type: 'uniQty'},
            { name: 'NOR_RECEIPT_Q'     ,text:'(정상)접수량'         ,type: 'uniQty'},
            { name: 'FREE_RECEIPT_Q'    ,text:'(무상)접수량'         ,type: 'uniQty'},
            { name: 'INSTOCK_Q'       	,text:'실입고량'            ,type: 'uniQty'},
            { name: 'SUPPLY_GUBUN'      ,text:'자급구분'            ,type: 'string'},
            { name: 'INSTOCK_YN'       	,text:'입고여부'            ,type: 'string'},
            { name: 'REMARK'       		,text:'비고'            	 ,type: 'string'},
            { name: 'DIV_CODE'       	,text:'발주사업장'           ,type: 'string'},
            { name: 'DVRY_CUSTOM_CODE'  ,text:'발주거래처'           ,type: 'string'},
            { name: 'DVRY_ORDER_NUM'    ,text:'발주번호'            ,type: 'string'},
            { name: 'DVRY_ORDER_SEQ'    ,text:'발주순번'            ,type: 'int' },
            { name: 'ORDER_NUM'         ,text:'수주번호+품목코드+납기일'  ,type: 'string'}


        ]
	});

	var cardNoStore = Unilite.createStore('orderWeekStore',{
        proxy: {
           type: 'direct',
            api: {
                read: 's_mpo250ukrv_kodiService.getOrderWeek'
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
		proxy	: directProxy,
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,	// 상위 버튼 연결
			editable	: true,		// 수정 모드 사용
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
			
			var toCreate= this.getNewRecords();
			var toUpdate= this.getUpdatedRecords();
			var toDelete= this.getRemovedRecords();
			var list	= [].concat(toUpdate, toCreate);
			var isErr	= false;
			console.log("list:", list);

			Ext.each(list, function(record, index) {
				if(record.data['INIT_DVRY_DATE'] != record.data['IN_DVRY_DATE']) {				

					if(record.get('REASON')== ''){
						Unilite.messageBox('입고예정일이 변경될 경우 입고예정일의 변경사유가 필수입력입니다.');
						isErr = true;
						return false;
					}
				}
			})
			if(isErr) return false;
			
			var inValidRecs = this.getInvalidRecords();
			if(inValidRecs.length == 0 ) {				
				config = {
					success: function(batch, option) {
						masterStore.loadStoreRecords();
					}
				};
				this.syncAllDirect(config);

			} else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load:function( store, records, successful, operation, eOpts ) {
//				if(records && records.length > 0){
//					masterGrid.setShowSummaryRow(true);
//				}
			}
		}
		, groupField: 'ORDER_NUM'
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
			},
			Unilite.popup('AGENT_CUST', {
				fieldLabel		: '<t:message code="system.label.purchase.custom" default="거래처"/>',
				valueFieldName	: 'CUSTOM_CODE',
				textFieldName	: 'CUSTOM_NAME',
				listeners		: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('CUSTOM_CODE', panelSearch.getValue('CUSTOM_CODE'));
							panelResult.setValue('CUSTOM_NAME', panelSearch.getValue('CUSTOM_NAME'));
						},
						scope: this
					},
					onClear: function(type) {
						panelResult.setValue('CUSTOM_CODE', '');
						panelResult.setValue('CUSTOM_NAME', '');
					},
					applyextparam: function(popup){
						popup.setExtParam({'AGENT_CUST_FILTER':	['1','2']});
						popup.setExtParam({'CUSTOM_TYPE':	['1','2']});
					}
				}
			}),{
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
//				allowBlank: false,
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
			},{
                xtype: 'radiogroup',
                fieldLabel: '<t:message code="system.label.purchase.receiptcomplateyn" default="입고완료여부"/>',
                items: [{
                    boxLabel: '<t:message code="system.label.purchase.whole" default="전체"/>',
                    width: 50,
                    name: 'COMPLETED_YN',
                    inputValue: 'A',
                    checked: true
                },{
                    boxLabel: '<t:message code="system.label.purchase.incompleted" default="미완료"/>',
                    width: 60, name: 'COMPLETED_YN',
                    inputValue: 'N'
                },{
                    boxLabel: '<t:message code="system.label.purchase.completion" default="완료"/>',
                    width: 80, name: 'COMPLETED_YN',
                    inputValue: 'Y'
                }],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.getField('COMPLETED_YN').setValue(newValue.COMPLETED_YN);
					}
				}
            },{
				fieldLabel: '<t:message code="system.label.inventory.account" default="품목계정"/>',
				name:'ITEM_ACCOUNT',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'B020',
				value: '70',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ITEM_ACCOUNT', newValue);
					}

				}
			},
			Unilite.popup('ORDER_NUM',{
				fieldLabel		: '<t:message code="system.label.purchase.sono" default="수주번호"/>',
				valueFieldName	: 'ORDER_NUM',
				textFieldName	: 'ORDER_NUM',
				listeners		: {
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('ORDER_NUM', newValue);
					}
				}
			}),
			Unilite.popup('DIV_PUMOK', {
					fieldLabel		: '<t:message code="system.label.sales.item" default="품목"/>',
					valueFieldName	: 'ITEM_CODE',
					textFieldName	: 'ITEM_NAME',
					autoPopup		: true,
					listeners		: {
						onValueFieldChange: function(field, newValue){
							panelResult.setValue('ITEM_CODE', newValue);
						},
						onTextFieldChange: function(field, newValue){
							panelResult.setValue('ITEM_NAME', newValue);
						},
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
						}
					}
				})
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
		},
		Unilite.popup('AGENT_CUST', {
			fieldLabel		: '<t:message code="system.label.purchase.custom" default="거래처"/>',
			valueFieldName	: 'CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME',
			listeners		: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('CUSTOM_CODE', panelResult.getValue('CUSTOM_CODE'));
						panelSearch.setValue('CUSTOM_NAME', panelResult.getValue('CUSTOM_NAME'));
					},
					scope: this
				},
				onClear: function(type) {
					panelSearch.setValue('CUSTOM_CODE', '');
					panelSearch.setValue('CUSTOM_NAME', '');
				},
				applyextparam: function(popup){
					popup.setExtParam({'AGENT_CUST_FILTER':	['1','2']});
					popup.setExtParam({'CUSTOM_TYPE':	['1','2']});
				}
			}
		}),{
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
//			allowBlank: false,
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
		},{
            xtype: 'radiogroup',
            fieldLabel: '<t:message code="system.label.purchase.receiptcomplateyn" default="입고완료여부"/>',
            items: [{
                boxLabel: '<t:message code="system.label.purchase.whole" default="전체"/>',
                width: 50,
                name: 'COMPLETED_YN',
                inputValue: 'A',
                checked: true
            },{
                boxLabel: '<t:message code="system.label.purchase.incompleted" default="미완료"/>',
                width: 60, name: 'COMPLETED_YN',
                inputValue: 'N'
            },{
                boxLabel: '<t:message code="system.label.purchase.completion" default="완료"/>',
                width: 80, name: 'COMPLETED_YN',
                inputValue: 'Y'
            }],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.getField('COMPLETED_YN').setValue(newValue.COMPLETED_YN);
				}
			}
        },{
			fieldLabel: '<t:message code="system.label.inventory.account" default="품목계정"/>',
			name:'ITEM_ACCOUNT',
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'B020',
			value: '70',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('ITEM_ACCOUNT', newValue);
				}

			}
		},
		Unilite.popup('ORDER_NUM',{
			fieldLabel		: '<t:message code="system.label.purchase.sono" default="수주번호"/>',
			valueFieldName	: 'ORDER_NUM',
			textFieldName	: 'ORDER_NUM',
			listeners		: {
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('ORDER_NUM', newValue);
				}
			}
		}),
		Unilite.popup('DIV_PUMOK', {
			fieldLabel		: '<t:message code="system.label.sales.item" default="품목"/>',
			valueFieldName	: 'ITEM_CODE',
			textFieldName	: 'ITEM_NAME',
			autoPopup		: true,
			listeners		: {
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('ITEM_CODE', newValue);
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('ITEM_NAME', newValue);
				},
				applyextparam: function(popup) {
					popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
				}
			}
		})]
    });

	var masterGrid = Unilite.createGrid('masterGrid', {
		layout: 'fit',
		region	: 'center',
		uniOpt	: {
			useGroupSummary		: false,
			useLiveSearch		: true,
			useContextMenu		: true,
			useMultipleSorting	: true,
			useRowNumberer		: false,
			expandLastColumn	: false,
			filter				: {
				useFilter	: false,
				autoCreate	: false
			}
		},
		store: masterStore,
		selModel:'rowmodel',
    	features: [
    	    		{id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true},
    	    	    {id : 'masterGridTotal' ,   ftype: 'uniSummary', 	     showSummaryRow: true}
    	],
    	viewConfig: {
			getRowClass: function(record, rowIndex, rowParams, store){
				var cls = '';
				
				if(record.get('INSTOCK_YN') == '입고완료'){
					cls = 'x-change-cell_light';
				}
				return cls;
			}
		},
		columns: [


            { dataIndex: 'OUT_DIV_CODE'       ,  width: 100, hidden: true },
            { dataIndex: 'CUSTOM_CODE'        ,  width: 100 , locked: true, hidden: true},
            { dataIndex: 'CUSTOM_NAME'        ,  width: 250 , locked: true},
            { dataIndex: 'ITEM_CODE'          ,  width: 100 , locked: true},
            { dataIndex: 'ITEM_NAME'          ,  width: 250 , locked: true},
            { dataIndex: 'ORDER_Q'            ,  width: 120 , locked: true},
            { dataIndex: 'ORDER_DATE'         ,  width: 100 , locked: true, align:'center'},
            { dataIndex: 'DVRY_DATE'          ,  width: 100 , locked: true, align:'center'},
            { dataIndex: 'DVRY_CUSTOM_NAME'   ,  width: 150},
            { dataIndex: 'CHLD_ITEM_CODE'     ,  width: 100 },
            { dataIndex: 'CHLD_ITEM_NAME'     ,  width: 250 },
            { dataIndex: 'ORDER_UNIT'         ,  width: 80 , hidden: true, align:'center'},
            { dataIndex: 'CALC_PLAN_QTY'      ,  width: 120, hidden: true },
            { dataIndex: 'ORDER_PLAN_DATE'    ,  width: 100 , hidden: true, align:'center'},
            { dataIndex: 'ORDER_REQ_Q'        ,  width: 120, hidden: true },
            { dataIndex: 'PL_QTY'             ,  width: 120, hidden: true },
            { dataIndex: 'INIT_DVRY_DATE'     ,  width: 100 , align:'center'},
            { dataIndex: 'IN_DVRY_DATE'       ,  width: 100 , align:'center'},
            { dataIndex: 'REASON'             ,  width: 200 },
            { dataIndex: 'INOUT_DATE'         ,  width: 100 , align:'center'},
            { dataIndex: 'IN_ORDER_DATE'      ,  width: 100 , align:'center'},
            { dataIndex: 'IN_ORDER_Q'         ,  width: 120 },
            { dataIndex: 'NOR_RECEIPT_Q'      ,  width: 120, hidden: true },
            { dataIndex: 'FREE_RECEIPT_Q'     ,  width: 120, hidden: true },
            { dataIndex: 'INSTOCK_Q'          ,  width: 120 },
            { dataIndex: 'SUPPLY_GUBUN'       ,  width: 100 , align:'center'},
            { dataIndex: 'INSTOCK_YN'         ,  width: 100 , align:'center'},
            { dataIndex: 'REMARK'             ,  width: 200 },
            { dataIndex: 'DIV_CODE'       	  ,  width: 100, hidden: true },
            { dataIndex: 'DVRY_CUSTOM_CODE'   ,  width: 100, hidden: true },
            { dataIndex: 'DVRY_ORDER_NUM'     ,  width: 100, hidden: true },
            { dataIndex: 'DVRY_ORDER_SEQ'     ,  width: 100, hidden: true },
            { dataIndex: 'ORDER_NUM'          ,  width: 100, hidden: true }
  		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				if (UniUtils.indexOf(e.field, ['IN_DVRY_DATE','REASON', 'REMARK'])) {
					return true;
				} else {
					return false;
				}
			}
		}
	});

	Unilite.Main({
		id: 's_mpo250ukrv_kodiApp',
		borderItems: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items: [
				panelResult, masterGrid
			]
		},
			panelSearch
		],

		fnInitBinding: function() {
			this.fnInitInputFields();
			panelSearch.setValue('ORDER_WEEK','');
			panelResult.setValue('ORDER_WEEK','');
			panelSearch.setValue('ORDER_DATE_FR','');
			panelResult.setValue('ORDER_DATE_TO','');
			panelSearch.setValue('ORDER_DATE_FR','');
			panelResult.setValue('ORDER_DATE_TO','');
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			masterStore.clearData();

			this.fnInitInputFields();
		},
		onQueryButtonDown: function() {
			if(!panelSearch.getInvalidMessage()) return;   //필수체크
			masterStore.loadStoreRecords();
		},
		onSaveDataButtonDown: function(config) {
			if(!panelSearch.getInvalidMessage()) return;   //필수체크

			masterStore.saveStore();
		},
		fnInitInputFields: function(){
			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			panelResult.setValue('DIV_CODE', UserInfo.divCode);

			/*s_mpo250ukrv_kodiService.getThisWeek({}, function(provider, response) {
				if(!Ext.isEmpty(provider)){
					panelSearch.setValue('ORDER_WEEK',provider.CAL_NO, false);
				}
			})*/

			UniAppManager.setToolbarButtons(['reset'], true);
			UniAppManager.setToolbarButtons(['print','newData','delete','save'], false);
		}
	});



};
</script>