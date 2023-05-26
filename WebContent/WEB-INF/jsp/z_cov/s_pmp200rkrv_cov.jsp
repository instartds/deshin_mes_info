<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_pmp200rkrv_cov"  >
	<t:ExtComboStore comboType="BOR120" pgmId="s_pmp200rkrv_cov"  />	<!-- 사업장 -->
	<t:ExtComboStore comboType="W" /><!-- 작업장  -->

</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
	
	/**
	 *   Model 정의 
	 */
	Unilite.defineModel('s_pmp200rkrv_covModel', {
		fields: [
			{name: 'COMP_CODE'     		, text: '<t:message code="system.label.product.compcode" default="법인코드"/>'			, type: 'string'},
			{name: 'DIV_CODE'     		, text: '<t:message code="system.label.product.division" default="사업장"/>'			, type: 'string'},
			{name: 'WORK_SHOP_CODE'    	, text: '<t:message code="system.label.product.workcenter" default="작업장"/>'	, type: 'string', xtype: 'uniCombobox', comboType: 'W'},
			{name: 'ITEM_CODE'    		, text: '<t:message code="system.label.product.item" default="품목코드"/>'				, type: 'string'},
			{name: 'ITEM_NAME'    		, text: '<t:message code="system.label.product.itemname" default="품목명"/>'			, type: 'string'},
			{name: 'SPEC'     			, text: '<t:message code="system.label.product.spec" default="규격"/>'				, type: 'string'},
			{name: 'LOT_NO'     		, text: '<t:message code="system.label.product.lotno" default="LOTNO"/>'			, type: 'string'},
			{name: 'STOCK_UNIT'     	, text: '단위'		, type: 'string'},
			{name: 'WKORD_Q'			, text: '작업지시량'		, type: 'uniQty'},
			{name: 'WKORD_NUM'  		, text: '작업지시번호'	, type: 'string'},
			{name: 'PRODT_WKORD_DATE'   , text: '작업지시일'		, type: 'uniDate'},
			{name: 'REMARK'		  		, text: '비고'		, type: 'string'},
			{name: 'WORK_SHOP_NAME'		, text: '작업장명'		, type: 'string'}

		]
	});

	/**
	 * Store 정의(Service 정의)
	 */					
	var masterStore = Unilite.createStore('s_pmp200rkrv_covMasterStore1', {
		model: 's_pmp200rkrv_covModel',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결 
			editable: true,			// 수정 모드 사용 
			deletable:false,			// 삭제 가능 여부 
			useNavi : false			// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {			
				read: 's_pmp200rkrv_covService.selectList'                	
			}
		},
		loadStoreRecords: function(){
			var param= Ext.getCmp('searchForm').getValues();			
			console.log(param);
			this.load({
				params : param
			});
		}
		//,groupField:'INSPEC_DATE'
	});

	/**
	 * 검색조건 (Search Panel)
	 */
    var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '<t:message code="system.label.product.searchconditon" default="검색조건"/>',
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
			title: '<t:message code="system.label.product.basisinfo" default="기본정보"/>', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
			items: [{
				fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>', 
				name: 'DIV_CODE', 
				xtype: 'uniCombobox', 
				comboType: 'BOR120', 
				allowBlank: false,
				value: UserInfo.divCode,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
						panelSearch.setValue('WORK_SHOP_CODE','');

					}
				}
			},{
				fieldLabel: '작업지시일',
				xtype: 'uniDateRangefield',
				startFieldName: 'WKORD_DATE_FR',
				endFieldName: 'WKORD_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				width: 315, 
				allowBlank: false,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('WKORD_DATE_FR',newValue);
						
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('WKORD_DATE_TO',newValue);
			    	}
			    }
						                   
			},{
				fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
				name: 'WORK_SHOP_CODE', 
				xtype: 'uniCombobox', 
				comboType:'W',
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
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
			}]	            			 
		}]
	});
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout: {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		//margin: '0 0 0 20',
		border:true,
		items: [{
			fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>', 
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
			fieldLabel: '작업지시일',
			xtype: 'uniDateRangefield',
			startFieldName: 'WKORD_DATE_FR',
			endFieldName: 'WKORD_DATE_TO',
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today'),
			width: 315, 
			allowBlank: false,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
					panelSearch.setValue('WKORD_DATE_FR',newValue);
					
            	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('WKORD_DATE_TO',newValue);
		    	}
		    }
					                   
		},{
			fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
			name: 'WORK_SHOP_CODE', 
			xtype: 'uniCombobox', 
			comboType:'W',
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
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
		}
		,{
				xtype:'button',
				text:'라벨 출력',
				disabled:false,
				width: 100,
				tdAttrs : { style : 'padding-left : 30px;'},
				margin: '0 10 0 100',
				//colspan : 3,
				handler: function(){
//					var selectedRecord = masterGrid.getSelectedRecord();
//					
//					
//	//var selectedRecord = masterGrid.getSelectedRecords();
//					if(Ext.isEmpty(selectedRecord)){
//						Unilite.messageBox('<t:message code="system.message.product.message017" default="출력할 데이터가 없습니다."/>');
//						return;
//					}
//					var wkordNumList;

/*					Ext.each(selectedRecords, function(record, idx) {
						if(idx ==0) {
							wkordNumList= record.get("WKORD_NUM");
						} else {
							wkordNumList= wkordNumList  + ',' + record.get("WKORD_NUM");
						}
					});*/
					
					var records = masterGrid.getSelectionModel().getSelection();
					
					if(Ext.isEmpty(records)) {
						Unilite.messageBox('<t:message code="system.message.product.message017" default="출력할 데이터가 없습니다."/>');
						return;
					}
					
					var param = {};
					var queryString = '';
					
					
					Ext.each(records, function(record, idx){
						if(queryString == '') {
							var date;
							date = record.get('PRODT_WKORD_DATE');
							date = Ext.Date.format(date,'Y-m-d');
							
							queryString = record.get('WKORD_NUM') + '^'
										+ record.get('ITEM_CODE') + '^'
										+ record.get('ITEM_NAME') + '^'
										+ record.get('LOT_NO') + '^'
										+ record.get('WKORD_Q') + '^'
										+ record.get('WORK_SHOP_NAME') + '^'
										+ date + '^'
										+ record.get('REMARK') + '^';
						}
						else {
							var date;
							date = record.get('PRODT_WKORD_DATE');
							date = Ext.Date.format(date,'Y-m-d');
							
							queryString = queryString + '|'
										+ record.get('WKORD_NUM') + '^'
										+ record.get('ITEM_CODE') + '^'
										+ record.get('ITEM_NAME') + '^'
										+ record.get('LOT_NO') + '^'
										+ record.get('WKORD_Q') + '^'
										+ record.get('WORK_SHOP_NAME') + '^'
										+ date + '^'
										+ record.get('REMARK') + '^';
						}
					});
					
					param['QUERY_STRING'] = queryString;
					
//					var param = panelSearch.getValues();
//					
//					param["WKORD_NUM"]  = selectedRecord.get("WKORD_NUM");
//					param["ITEM_NAME"]  = selectedRecord.get("ITEM_NAME");
//					param["LOT_NO"]     = selectedRecord.get("LOT_NO");
//					param["PACK_QTY"]   = selectedRecord.get("PACK_QTY");
//					param["STOCK_UNIT"] = selectedRecord.get("STOCK_UNIT");
//					param["ITEM_CODE"]  = selectedRecord.get("ITEM_CODE");
//					
//					param["ITEM_CODE"]  = selectedRecord.get("ITEM_CODE");
//					param["START_NUM"]  = selectedRecord.get("START_NUM");
//					param["END_NUM"]    = selectedRecord.get("END_NUM");
					
					var win = null;
					win = Ext.create('widget.ClipReport', {
						url: CPATH+'/cov/s_pmp200clrkr_cov.do',
						prgID: 's_pmp200rkrv_cov',
						extParam: param,
						//20200519 추가
						submitType : 'POST'
					});
					win.center();
					win.show();
				}
			}
			]
    });
	
    /**
     * Master Grid1 정의(Grid Panel)
     */
	var masterGrid = Unilite.createGrid('s_pmp200rkrv_covGrid', {
		layout: 'fit',
		region:'center',
		uniOpt: {
			useMultipleSorting	: true,
    		useLiveSearch		: true,
    		onLoadSelectFirst	: false,
    		dblClickToEdit		: true,
    		useSqlTotal			: false,
			useContextMenu		: false,
			useRowNumberer		: false,
			expandLastColumn	: false,
			useRowContext		: false,
    		filter: {
				useFilter		: true,
				autoCreate		: true
			},
			state: {
				useState: false,			
				useStateList: false		
			}
        },
        selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false}),
		features: [{
			id: 'masterGridSubTotal', 
			ftype: 'uniGroupingsummary', 
			showSummaryRow: false
		},{
			id: 'masterGridTotal', 	
			ftype: 'uniSummary', 
			showSummaryRow: false
		}],
		store: masterStore,
		columns: [
			{dataIndex: 'COMP_CODE'    		,width: 130,hidden:true},
			{dataIndex: 'DIV_CODE'     		,width: 130,hidden:true},
			{dataIndex: 'WORK_SHOP_CODE'  	,width: 130},
			{dataIndex: 'ITEM_CODE'   		,width: 130},
			{dataIndex: 'ITEM_NAME'   		,width: 150,hidden:false},
			{dataIndex: 'SPEC'    			,width: 130},
			{dataIndex: 'LOT_NO'    		,width: 130},
			{dataIndex: 'STOCK_UNIT'     	,width: 130, align:'center'},
			{dataIndex: 'WKORD_Q'     		,width: 130, align:'right'},
			{dataIndex: 'WKORD_NUM' 		,width: 130, align:'center'},
			{dataIndex: 'PRODT_WKORD_DATE'  ,width: 130, align:'center'},
			{dataIndex: 'REMARK'  			,width: 130, align:'center'},
			{dataIndex: 'WORK_SHOP_NAME'	,width: 80, hidden:true}

		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				if (UniUtils.indexOf(e.field,[
					'PACK_QTY'
				])){
					return true;
				}else{
					return false;
				}
				
			}
		} 
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
		id: 's_pmp200rkrv_covApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('WKORD_DATE_FR',UniDate.get('startOfMonth'));
			panelResult.setValue('WKORD_DATE_FR',UniDate.get('startOfMonth'));
			panelSearch.setValue('WKORD_DATE_TO',UniDate.get('today'));
			panelResult.setValue('WKORD_DATE_TO',UniDate.get('today'));
			
			UniAppManager.setToolbarButtons(['reset'], true);
		},
		onQueryButtonDown: function() {
			if(!panelSearch.getInvalidMessage()) return;   //필수체크
			
			masterGrid.reset();
        	masterStore.clearData();
        	//UniAppManager.app.fnInitBinding();
        	
			masterStore.loadStoreRecords();
		},
        onResetButtonDown:function() {
        	panelSearch.clearForm();
        	panelResult.clearForm();
        	masterGrid.reset();
        	masterStore.clearData();
        	UniAppManager.app.fnInitBinding();
        }
	});
	
	
		/** Validation
	 */
	Unilite.createValidator('validator01', {
		store	: masterStore,
		grid	: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt, editor, e) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record, 'editor':editor, 'e':e});
			//Unilite.messageBox(type+ ' : ' + fieldName+ ' : ' +newValue+ ' : ' +oldValue+ ' : ' +record)
			var rv = true;
			
			
			return rv;
		}
	}); // validator
};
</script>