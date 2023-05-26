<%--
'   프로그램명 : 작업지시별출고형황출력
'
'   작  성  자 : (주)포렌 개발실
'   작  성  일 :
'
'   최종수정자 :
'   최종수정일 :
'
'   버      전 : OMEGA Plus V6.0.0
--%>

<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="mtr280skrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="mtr260skrv"/> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B020" /> <!-- 품목계정 -->
	<t:ExtComboStore comboType="WU" />        <!-- 작업장-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333; font-weight: normal; padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {

	Ext.create('Ext.data.Store', {
		storeId:"printType",
	    fields: ['text', 'value'],
	    data : [
	        {text:"의료기기",   value:"A"},
	        {text:"산업체"	 ,   value:"B"}
	    ]
	});

	Unilite.defineModel('Mtr280skrvModel', {
	    fields: [
			{name: 'WKORD_NUM' 				, text: '작업지시번호'		, type: 'string'},
			{name: 'PRODT_WKORD_DATE'    , text: '작업지시일자'          		, type: 'uniDate'},
			{name: 'WEEK_NUM'      			, text: '계획주차'          		, type: 'string'},
			{name: 'ITEM_CODE' 				, text: '품목코드'				, type: 'string'},
			{name: 'ITEM_NAME' 				, text: '품목명'					, type: 'string'},
			{name: 'SPEC'      					, text: '규격'						, type: 'string'},
			{name: 'STOCK_UNIT'				, text: '단위'						, type: 'string'},
			{name: 'WKORD_Q'					, text: '작업지시량'					, type: 'uniQty'},
			{name: 'WORK_Q'					, text: '실적량'					, type: 'uniQty'},
			{name: 'ITEM_ACCOUNT'			, text: '품목계정'				, type: 'string'		, xtype: 'uniCombobox'		, comboType: 'AU'		, comboCode: 'B020'},
			{name: 'LOT_NO'						, text: 'LOT NO'				, type: 'string'},
			{name: 'WORK_SHOP_CODE'		, text: '작업장'				, type: 'string'		, xtype: 'uniCombobox'		, comboType: 'WU'	},
			{name: 'REMARK'						, text: '비고'	, type: 'string'}
		]
	});

	/**
	 * Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore = Unilite.createStore('mtr260skrvMasterStore1', {
		model: 'Mtr280skrvModel',
		uniOpt: {
           	isMaster: true,			// 상위 버튼,상태바 연결
           	editable: false,		// 수정 모드 사용
           	deletable: false,		// 삭제 가능 여부
            useNavi: false			// prev | next 버튼 사용
		},
        autoLoad: false,
        proxy: {
        	type: 'direct',
            api: {
            	read: 'mtr260skrvService.selectList1'
		    }
		},
		loadStoreRecords: function() {
			var param= panelResult.getValues();
			this.load({
				params: param
			});
		},
        listeners: {
            load: function(store, records, successful, eOpts) {

            },
            update: function(store, record, operation, modifiedFieldNames, eOpts) {

            }
        }
	});

	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '검색조건',
        defaultType: 'uniSearchSubPanel',
        collapsed: UserInfo.appOption.collapseLeftSearch,//true,
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
				fieldLabel: '사업장',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				allowBlank: false,
				value: UserInfo.divCode,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						combo.changeDivCode(combo, newValue, oldValue, eOpts);
						panelResult.setValue('DIV_CODE', newValue);
						panelSearch.setValue('WORK_SHOP_CODE', '');
						panelResult.setValue('WORK_SHOP_CODE', '');
					}
				}
			},{
	            fieldLabel: '작업지시번호',
	            name:'WKORD_NUM',
	            xtype: 'uniTextfield',
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelResult.setValue('WKORD_NUM', newValue);
					}
				}
	        },{
				fieldLabel: '작업지시일',
		        xtype: 'uniDateRangefield',
		        startFieldName: 'PRODT_START_DATE',
		        endFieldName: 'PRODT_END_DATE',
		        width: 470,
		        startDate: UniDate.get('today'),
		        endDate: UniDate.get('today'),
		        onStartDateChange: function(field, newValue, oldValue, eOpts) {
		        	if(panelResult) {
						panelResult.setValue('PRODT_START_DATE',newValue);
		        	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('PRODT_END_DATE',newValue);
			    	}
				}
	        },{
	            fieldLabel: '품목계정',
	            name:'ITEM_ACCOUNT',
	            xtype: 'uniCombobox',
	            comboType:'AU',
	            comboCode:'B020',
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelResult.setValue('ITEM_ACCOUNT', newValue);
					}
				}
	        },{
				fieldLabel : '작업장',
				name : 'WORK_SHOP_CODE',
				xtype : 'uniCombobox',
				comboType:'WU',
				listeners : {
					change : function(combo, newValue,oldValue, eOpts) {
						panelResult.setValue('WORK_SHOP_CODE', newValue);
					},beforequery:function( queryPlan, eOpts ) {
						var store = queryPlan.combo.store;
						var prStore = panelResult.getField('WORK_SHOP_CODE').store;
						store.clearFilter();
						prStore.clearFilter();
						if(!Ext.isEmpty(panelResult.getValue('DIV_CODE'))){
							 store.filterBy(function(record){
								 return record.get('option') == panelResult.getValue('DIV_CODE');
							 })
							  prStore.filterBy(function(record){
								 return record.get('option') == panelResult.getValue('DIV_CODE');
							 })
						}else{
							store.filterBy(function(record){
								return false;
							})
							prStore.filterBy(function(record){
								return false;
							})
						}

					}
				}
			}
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
   						var labelText = invalid.items[0]['fieldLabel']+' : ';
   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
   						var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
   					}
				   	alert(labelText+'필수입력 항목입니다.');
				   	invalid.items[0].focus();
				}
	  		}
			return r;
  		}
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [
			{
				fieldLabel: '사업장',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				allowBlank: false,
				value: UserInfo.divCode,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						combo.changeDivCode(combo, newValue, oldValue, eOpts);
						panelSearch.setValue('DIV_CODE', newValue);
						panelSearch.setValue('WORK_SHOP_CODE', '');
						panelResult.setValue('WORK_SHOP_CODE', '');
					}
				}
			},{
			    fieldLabel: '작업지시번호',
			    name:'WKORD_NUM',
			    xtype: 'uniTextfield',
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelSearch.setValue('WKORD_NUM', newValue);
					}
				}
			},{
				fieldLabel: '작업지시일',
			    xtype: 'uniDateRangefield',
			    startFieldName: 'PRODT_START_DATE',
			    endFieldName: 'PRODT_END_DATE',
			    startDate: UniDate.get('today'),
			    endDate: UniDate.get('today'),
			    onStartDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('PRODT_START_DATE',newValue);
			    	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('PRODT_END_DATE',newValue);
			    	}
				}
			},{
			    fieldLabel: '품목계정',
			    name:'ITEM_ACCOUNT',
			    xtype: 'uniCombobox',
			    comboType:'AU',
			    comboCode:'B020',
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelSearch.setValue('ITEM_ACCOUNT', newValue);
					}
				}
			},{
				fieldLabel : '작업장',
				name : 'WORK_SHOP_CODE',
				xtype : 'uniCombobox',
				comboType:'WU',
				listeners : {
					change : function(combo, newValue,oldValue, eOpts) {
						panelSearch.setValue('WORK_SHOP_CODE', newValue);
					},beforequery:function( queryPlan, eOpts ) {
						var store = queryPlan.combo.store;
						var prStore = panelSearch.getField('WORK_SHOP_CODE').store;
						store.clearFilter();
						prStore.clearFilter();
						if(!Ext.isEmpty(panelSearch.getValue('DIV_CODE'))){
							 store.filterBy(function(record){
								 return record.get('option') == panelSearch.getValue('DIV_CODE');
							 })
							  prStore.filterBy(function(record){
								 return record.get('option') == panelSearch.getValue('DIV_CODE');
							 })
						}else{
							store.filterBy(function(record){
								return false;
							})
							prStore.filterBy(function(record){
								return false;
							})
						}

					}
				}
			},{
			     fieldLabel: 'ITEM_PRINT',
			     xtype: 'uniTextfield',
			     name: 'ITEM_PRINT',
			     hidden: true
			 }
		]
    });

	/**
     * Master Grid1 정의(Grid Panel),
     * @type
     */
    var masterGrid = Unilite.createGrid('mtr260skrvGrid1', {
    	layout: 'fit',
    	region:'center',
    	selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: false, toggleOnClick: false,
            listeners: {
                select: function(grid, selectRecord, index, rowIndex, eOpts ){
                	var selectedDetails = masterGrid.getSelectedRecords();
                	if(Ext.isEmpty(selectedDetails)){
                		UniAppManager.setToolbarButtons(['print'], false);
                    }else{
                    	UniAppManager.setToolbarButtons(['print'], true);
                    }
                },
                deselect:  function(grid, selectRecord, index, eOpts ){
                	var selectedDetails = masterGrid.getSelectedRecords();
                    if(Ext.isEmpty(selectedDetails)){
                    	UniAppManager.setToolbarButtons(['print'], false);
                    }else{
                    	UniAppManager.setToolbarButtons(['print'], true);
                    }
                }
            }
        }),
        uniOpt: {
        	expandLastColumn: true,
    		useGroupSummary: false,
    		useLiveSearch: false,
			useContextMenu: false,
			useRowContext 		: true,
			onLoadSelectFirst: false,
            filter: {
                useFilter: false,
                autoCreate: false
            }

        },
    	store: directMasterStore,
        features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           		  {id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: true} ],
        columns: [
			{dataIndex: 'WKORD_NUM' 		       , width: 120,
					summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
	              	return Unilite.renderSummaryRow(summaryData, metaData, '', '총계');
	            }
			},
			{dataIndex: 'PRODT_WKORD_DATE'               	, width: 100},
			{dataIndex: 'WEEK_NUM'                 		, width: 125		, align: 'center', hidden: true},
			{dataIndex: 'ITEM_CODE' 		       			, width: 110},
			{dataIndex: 'ITEM_NAME' 		       		, width: 250},
			{dataIndex: 'SPEC'      		       				, width: 120},
			{dataIndex: 'STOCK_UNIT'		       		, width: 80, align: 'center'},
			{dataIndex: 'WKORD_Q'			       		, width: 100		, summaryType: 'sum'},
			{dataIndex: 'WORK_Q'			       		, width: 100		, summaryType: 'sum'},
			{dataIndex: 'ITEM_ACCOUNT'	           	, width: 100, align: 'center'},
			{dataIndex: 'LOT_NO'			       			, width: 100, align: 'center'},
			{dataIndex: 'WORK_SHOP_CODE'       , width: 120			, hidden: true},
			{dataIndex: 'REMARK'					, width: 250		, hidden : false}
		],
		 listeners: {
	        	cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
					//beforeRowIndex = rowIndex;
				}
			 }
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
			panelSearch
		],
		id: 'mtr260skrvApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
        	panelSearch.setValue('PRODT_END_DATE', UniDate.get('today'));
			panelSearch.setValue('PRODT_START_DATE', UniDate.get('today'));
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
        	panelResult.setValue('PRODT_END_DATE', UniDate.get('today'));
			panelResult.setValue('PRODT_START_DATE', UniDate.get('today'));
		},
		onQueryButtonDown: function()	{
			if(!panelSearch.setAllFieldsReadOnly(true)){
	    		return false;
	    	}
			masterGrid.getStore().loadStoreRecords();
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.getStore().loadData({})
			this.fnInitBinding();
		},
		onPrintButtonDown: function(){
			var param = panelResult.getValues();
			var selectedDetails = masterGrid.getSelectedRecords();
              param["PGM_ID"]= PGM_ID;
              param["MAIN_CODE"]= 'M030';
          	var itemPrint = "";
          	//var wkordNum = "";
          	Ext.each(selectedDetails, function(record, idx) {
	          		if(idx ==0) {
	          			itemPrint = record.get('WKORD_NUM');
	          			wkordNum = record.get('WKORD_NUM');
	              	}else{
	              		itemPrint = itemPrint + ',' + record.get('WKORD_NUM');
	              		wkordNum = wkordNum + ',' +  record.get('WKORD_NUM');
	              	}
				});
          	param.ITEM_PRINT = itemPrint;
          	param.WKORD_NUMS = wkordNum;
			var win = Ext.create('widget.ClipReport', {
				url: CPATH+'/matrl/mtr280clskrv.do',
				prgID: 'mtr260skrv',
				extParam: param
			});
			win.center();
			win.show();
		}
	});

    Unilite.createValidator('validator01', {
		store: directMasterStore,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			var rv = true;
			switch(fieldName) {
				case "*" :
					//to-do...
				break;
			}
			return rv;
		}
	});
};
</script>
