<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="mrp100ukrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 		<!-- 사업장 -->
	<t:ExtComboStore comboType="WU" comboCode="O" /> <!-- 작업장 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>

<script type="text/javascript" >

function appMain() {
	//전체선택 버튼관련 변수 선언
	selDesel = 0;
	checkCount = 0;

	/**
	 *   Model 정의
	 * @type
	 */

	Unilite.defineModel('Mrp100ukrvModel', {
		fields: [
	    	{name: 'CHK'  					,text: '<t:message code="system.label.purchase.selection" default="선택"/>' 	 		,type: 'string'},
	    	{name: 'FLAG'  					,text: 'FLAG' 	 		,type: 'string'},
	    	{name: 'AGREE_STATUS'			,text: '<t:message code="system.label.purchase.confirmedpendingcode" default="확정여부코드"/>'		,type: 'string'},
	    	{name: 'AGREE_NAME'				,text: '<t:message code="system.label.purchase.confirmedpending" default="확정여부"/>'	 		,type: 'string'},
	    	{name: 'PLAN_NAME'				,text: '<t:message code="system.label.purchase.creationtype" default="생성구분"/>'	 		,type: 'string'},
	    	{name: 'WORK_SHOP_CODE'			,text: '<t:message code="system.label.purchase.workcentercode" default="작업장코드"/>'	 		,type: 'string'},
	    	{name: 'WORK_SHOP_NAME'			,text: '<t:message code="system.label.purchase.workcentername" default="작업장명"/>'	 		,type: 'string'},
	    	{name: 'ITEM_CODE'				,text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'	 		,type: 'string'},
	    	{name: 'ITEM_NAME'				,text: '<t:message code="system.label.purchase.itemname2" default="품명"/>'		 		,type: 'string'},
	    	{name: 'SPEC'		    		,text: '<t:message code="system.label.purchase.spec" default="규격"/>'		 		,type: 'string'},
	    	{name: 'PRODT_PLAN_DATE'		,text: '<t:message code="system.label.purchase.requestdate" default="요청일"/>' 	 		,type: 'uniDate'},
	    	{name: 'WK_PLAN_Q'				,text: '<t:message code="system.label.purchase.requestqty" default="요청량"/>' 	 		,type: 'uniQty'},
	    	{name: 'STOCK_UNIT'				,text: '<t:message code="system.label.purchase.unit" default="단위"/>'		 		,type: 'string'},
	    	{name: 'WK_PLAN_NUM'			,text: '<t:message code="system.label.purchase.productionplan" default="생산계획"/>' 	 		,type: 'string'},
	    	{name: 'PROJECT_NO'				,text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>' 	 		,type: 'string'},
	    	{name: 'DIV_CODE'				,text:'<t:message code="system.label.purchase.division" default="사업장"/>'			,type:'string'}
		]
	});

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'mrp100ukrvService.selectList',
			update: 'mrp100ukrvService.updateDetail',
			//create: 'mrp100ukrvService.insertDetail',
			//destroy: 'mrp100ukrvService.deleteDetail',
			syncAll: 'mrp100ukrvService.saveAll'
		}
	});

	/**
	 * Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('mrp100ukrvMasterStore1',{
		model: 'Mrp100ukrvModel',
		uniOpt : {
			isMaster: true,			// 상위 버튼 연결
			editable: false,			// 수정 모드 사용
			deletable: false,			// 삭제 가능 여부
			useNavi : false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: directProxy,
//			proxy: {
//				type: 'direct',
//                api: {
//					read: 'mrp100ukrvService.selectList'
//                }
//            },
		loadStoreRecords : function()	{
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore : function(config)	{

			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
        	var toUpdate = this.getUpdatedRecords();
        	console.log("toUpdate",toUpdate);
        	var rv = true;
   			var paramMaster= panelSearch.getValues();
        	if(inValidRecs.length == 0 )	{
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						panelResult.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);
						UniAppManager.app.onQueryButtonDown();
					 }
				};
				this.syncAllDirect(config);
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});

	/**
	 * 검색조건 (Search Panel)
	 * @type
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '<t:message code="system.label.purchase.searchconditon" default="검색조건"/>',
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
			title: '<t:message code="system.label.purchase.basisinfo" default="기본정보"/>',
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items : [{
				fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
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
				fieldLabel: '<t:message code="system.label.purchase.workcenter" default="작업장"/>',
				name: 'WORK_SHOP_CODE',
				xtype: 'uniCombobox',
				comboType: 'WU',
				comboCode: 'O',
//				store: Ext.data.StoreManager.lookup('wsList'),
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('WORK_SHOP_CODE', newValue);
					},
                    beforequery:function( queryPlan, eOpts )   {
                        var store = queryPlan.combo.store;
                        var prStore = panelSearch.getField('WORK_SHOP_CODE').store;
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
				fieldLabel: '<t:message code="system.label.purchase.requestperiod" default="요청기간"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'PRODT_PLAN_DATE_FR',
				endFieldName: 'PRODT_PLAN_DATE_TO',
				startDate: UniDate.get('today'),
				endDate: UniDate.get('nextWeek'),
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('PRODT_PLAN_DATE_FR',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('PRODT_PLAN_DATE_TO',newValue);
			    	}
			    }
			},
			Unilite.popup('DIV_PUMOK',{
					fieldLabel: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',
					validateBlank:false,
					valueFieldName:'ITEM_CODE',
	        		textFieldName:'ITEM_NAME',
					allowBlank:true,	// 2021.08 표준화 작업
					autoPopup:false,	// 2021.08 표준화 작업
					validateBlank:false,// 2021.08 표준화 작업
					listeners: {
								onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
									panelSearch.setValue('ITEM_CODE', newValue);
									panelResult.setValue('ITEM_CODE', newValue);
									if(!Ext.isObject(oldValue)) {
										panelSearch.setValue('ITEM_NAME', '');
										panelResult.setValue('ITEM_NAME', '');
									}
								},
								onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
									panelSearch.setValue('ITEM_NAME', newValue);
									panelResult.setValue('ITEM_NAME', newValue);
									if(!Ext.isObject(oldValue)) {
										panelSearch.setValue('ITEM_CODE', '');
										panelResult.setValue('ITEM_CODE', '');
									}
								},
							applyextparam: function(popup){	// 2021.08 표준화 작업
								popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
							}
						}
			}),
			{
				xtype: 'radiogroup',
				fieldLabel: '<t:message code="system.label.purchase.confirmedpending" default="확정여부"/>',
				//id: 'CONFIRM_TYPE',
				items: [{
					boxLabel: '<t:message code="system.label.purchase.whole" default="전체"/>',
					width:60,
					name: 'CONFIRM_TYPE',
					inputValue: '',
					checked: true
				},{
					boxLabel: '<t:message code="system.label.purchase.confirmation" default="확정"/>',
					width:60,
					name: 'CONFIRM_TYPE',
					inputValue: '2'
				},{
					boxLabel: '<t:message code="system.label.purchase.noconfirm" default="미확정"/>',
					width:60,
					name: 'CONFIRM_TYPE',
					inputValue: '1'
				}],
				listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.getField('CONFIRM_TYPE').setValue(newValue.CONFIRM_TYPE);
                    }
                }
			},{
				xtype: 'radiogroup',
				fieldLabel: '<t:message code="system.label.purchase.targettype" default="대상구분"/>',
				//id: 'TARGET_TYPE',
				items: [{
					boxLabel: '<t:message code="system.label.purchase.whole" default="전체"/>',
					width:60,
					name: 'TARGET_TYPE',
					inputValue: '',
					checked: true
				},{
					boxLabel: '<t:message code="system.label.purchase.productionplan" default="생산계획"/>',
					width:80,
					name: 'TARGET_TYPE',
					inputValue: '1'
				},{
					boxLabel: 'MRP <t:message code="system.label.purchase.convert" default="전환"/>',
					width:80,
					name: 'TARGET_TYPE',
					inputValue: '2'
				}],
				listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.getField('TARGET_TYPE').setValue(newValue.TARGET_TYPE);
                    }
                }
			}]
		}]
	});

	var panelResult = Unilite.createSearchForm('panelResultForm', {
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items : [{
				fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				allowBlank: false,
				value: UserInfo.divCode,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('DIV_CODE', newValue);
						panelResult.setValue('WORK_SHOP_CODE','');
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.workcenter" default="작업장"/>',
				name: 'WORK_SHOP_CODE',
				xtype: 'uniCombobox',
				comboType: 'WU',
				comboCode: 'O',
//				store: Ext.data.StoreManager.lookup('wsList'),
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('WORK_SHOP_CODE', newValue);
					},
                    beforequery:function( queryPlan, eOpts )   {
                        var store = queryPlan.combo.store;
                        var prStore = panelResult.getField('WORK_SHOP_CODE').store;
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
				fieldLabel: '<t:message code="system.label.purchase.requestperiod" default="요청기간"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'PRODT_PLAN_DATE_FR',
				endFieldName: 'PRODT_PLAN_DATE_TO',
				startDate: UniDate.get('today'),
				endDate: UniDate.get('nextWeek'),
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelSearch.setValue('PRODT_PLAN_DATE_FR',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelSearch.setValue('PRODT_PLAN_DATE_TO',newValue);
			    	}
			    }
			},
			Unilite.popup('DIV_PUMOK',{
	        	fieldLabel: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',
	        	valueFieldName: 'ITEM_CODE',
				textFieldName: 'ITEM_NAME',
				allowBlank:true,	// 2021.08 표준화 작업
				autoPopup:false,	// 2021.08 표준화 작업
				validateBlank:false,// 2021.08 표준화 작업
				listeners: {
							onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
								panelSearch.setValue('ITEM_CODE', newValue);
								panelResult.setValue('ITEM_CODE', newValue);
								if(!Ext.isObject(oldValue)) {
									panelSearch.setValue('ITEM_NAME', '');
									panelResult.setValue('ITEM_NAME', '');
								}
							},
							onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
								panelSearch.setValue('ITEM_NAME', newValue);
								panelResult.setValue('ITEM_NAME', newValue);
								if(!Ext.isObject(oldValue)) {
									panelSearch.setValue('ITEM_CODE', '');
									panelResult.setValue('ITEM_CODE', '');
								}
							},
						applyextparam: function(popup){	// 2021.08 표준화 작업
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
		   	}),
			{
				xtype: 'radiogroup',
				fieldLabel: '<t:message code="system.label.purchase.confirmedpending" default="확정여부"/>',
				//id: 'CONFIRM_TYPE',
				items: [{
					boxLabel: '<t:message code="system.label.purchase.whole" default="전체"/>',
					width:60,
					name: 'CONFIRM_TYPE',
					inputValue: '',
					checked: true
				},{
					boxLabel: '<t:message code="system.label.purchase.confirmation" default="확정"/>',
					width:60,
					name: 'CONFIRM_TYPE',
					inputValue: '2'
				},{
					boxLabel: '<t:message code="system.label.purchase.noconfirm" default="미확정"/>',
					width:60,
					name: 'CONFIRM_TYPE',
					inputValue: '1'
				}],
				listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelSearch.getField('CONFIRM_TYPE').setValue(newValue.CONFIRM_TYPE);
                    }
                }
			},{
				xtype: 'radiogroup',
				fieldLabel: '<t:message code="system.label.purchase.targettype" default="대상구분"/>',
				//id: 'TARGET_TYPE',
				items: [{
					boxLabel: '<t:message code="system.label.purchase.whole" default="전체"/>',
					width:60,
					name: 'TARGET_TYPE',
					inputValue: '',
					checked: true
				},{
					boxLabel: '<t:message code="system.label.purchase.productionplan" default="생산계획"/>',
					width:80,
					name: 'TARGET_TYPE',
					inputValue: '1'
				},{
					boxLabel: 'MRP <t:message code="system.label.purchase.convert" default="전환"/>',
					width:80,
					name: 'TARGET_TYPE',
					inputValue: '2'
				}],
				listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelSearch.getField('TARGET_TYPE').setValue(newValue.TARGET_TYPE);
                    }
                }
			}]
	});

    /**
     * Master Grid1 정의(Grid Panel)
     * @type
     */
	var masterGrid1 = Unilite.createGrid('mrp100ukrvGrid1', {
    	// for tab
		layout: 'fit',
		region: 'center',
		selModel: Ext.create('Ext.selection.CheckboxModel', {
			checkOnly : false,
			toggleOnClick:false,
			listeners: {
				beforeedit  : function( editor, e, eOpts ) {
	          		if(!e.record.phantom) {
	           			if(UniUtils.indexOf(e.field)) {
	      					return false;
	          			}
	          		} else {
			            if(UniUtils.indexOf(e.field)) {
	      					return false;
	          			}
	          		}
	         	},
    			select: function(grid, selectRecord, index, rowIndex, eOpts ){
    				if(selectRecord.get('AGREE_STATUS') == '1') {
    					selectRecord.set('AGREE_STATUS','2')
    					selectRecord.set('AGREE_NAME','<t:message code="system.label.purchase.confirmation" default="확정"/>')
    				} else {
    					selectRecord.set('AGREE_STATUS','1')
    					selectRecord.set('AGREE_NAME','<t:message code="system.label.purchase.noconfirm" default="미확정"/>')
    				}
    				//UniAppManager.setToolbarButtons(['save', 'newData', 'delete' ], false);
    				UniAppManager.setToolbarButtons(['save'], true);

//    				if (record.get('AGREE_STATUS') == '1') {
//    					record.set('AGREE_STATUS','2')
//    					record.set('AGREE_NAME','<t:message code="system.label.purchase.confirmation" default="확정"/>')
//    				} else {
//    					record.set('AGREE_STATUS','1')
//    					record.set('AGREE_NAME','<t:message code="system.label.purchase.noconfirm" default="미확정"/>')
//    				}
					//var itemName = record.get('ITEM_NAME');
    				//var agreeStatus = selectRecord.get('AGREE_STATUS')
    				//console.log("agreeStatus::::::::::"+agreeStatus)
    				//masterGrid1.setItemData('AGREE_STATUS','1')
    			},
	    		deselect:  function(grid, selectRecord, index, eOpts ){
//					var grdRecord = masterGrid.getStore().getAt(rowIndex);
	    			//sumSaleTaxAmtI = sumSaleTaxAmtI - selectRecord.get('SALE_TAX_AMT_I');
					//sumCheckedCount = sumCheckedCount - 1;
	    			//panelSearch.setValue('SELECTED_AMT', sumSaleTaxAmtI)
	    			//panelSearch.setValue('COUNT', sumCheckedCount)
	    			//addResult.setValue('SELECTED_AMT', sumSaleTaxAmtI)
	    			//addResult.setValue('COUNT', sumCheckedCount)
    				if(selectRecord.get('AGREE_STATUS') == '1') {
    					selectRecord.set('AGREE_STATUS','2')
    					selectRecord.set('AGREE_NAME','<t:message code="system.label.purchase.confirmation" default="확정"/>')
    				} else {
    					selectRecord.set('AGREE_STATUS','1')
    					selectRecord.set('AGREE_NAME','<t:message code="system.label.purchase.noconfirm" default="미확정"/>')
    				}
					selDesel = 0;
	    		}
    		}

		}),
		uniOpt:{
			expandLastColumn: true,
			useRowNumberer: true,
			useMultipleSorting: true,
			onLoadSelectFirst : false
        },
//		tbar: [{
//			text:'상세보기',
//			handler: function() {
//				var record = masterGrid.getSelectedRecord();
//				if(record) {
//					openDetailWindow(record);
//				}
//			}
//		}],
    	store: directMasterStore1,
    	features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
        columns: [
//			{ dataIndex: 'CHK'  			  				     , 	width:40},
//			{
//				xtype: 'rownumberer',
//				sortable:false,
//				//locked: true,
//				width: 35,
//				align:'center  !important',
//				resizable: true
//			},
			{ dataIndex: 'FLAG'  			  				     , 	width:40, hidden:true},
			{ dataIndex: 'AGREE_STATUS'	  				     	 , 	width:73, hidden:true},
			{ dataIndex: 'AGREE_NAME'		  				     , 	width:73},
			{ dataIndex: 'PLAN_NAME'		  				     , 	width:93},
			{ dataIndex: 'WORK_SHOP_CODE'	  				     , 	width:86, hidden:true},
			{ dataIndex: 'WORK_SHOP_NAME'	  				     , 	width:86},
			{ dataIndex: 'ITEM_CODE'		  				     , 	width:120},
			{ dataIndex: 'ITEM_NAME'		  				     , 	width:200},
			{ dataIndex: 'SPEC'		      				     	 , 	width:66},
			{ dataIndex: 'PRODT_PLAN_DATE'  				     , 	width:80},
			{ dataIndex: 'WK_PLAN_Q'		  				     , 	width:133},
			{ dataIndex: 'STOCK_UNIT'		  				     , 	width:46, align:'center'},
			{ dataIndex: 'WK_PLAN_NUM'	  				    	 , 	width:133},
			{ dataIndex: 'PROJECT_NO'		  				     , 	width:133},
			{ dataIndex: 'DIV_CODE'		  				     	 , 	width:133,hidden:true}
		]
	});

	Unilite.Main( {
		borderItems:[{
			border: false,
			region: 'center',
			layout: 'border',
			items:[
				masterGrid1, panelResult
			]
		}
		,panelSearch
		],
		id: 'mrp100ukrvApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown : function()	{
			if(!panelSearch.getInvalidMessage()) return;    //필수체크
			directMasterStore1.loadStoreRecords();
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		},
		onSaveDataButtonDown: function(config) {	// 저장 버튼
			//if(!panelSearch.getInvalidMessage()) return;    //필수체크
			directMasterStore1.saveStore();
//			UniAppManager.app.onQueryButtonDown();
			//directMasterStore1.loadStoreRecords();
//			var record = masterGrid.getSelectedRecord();
//			record.set('DR_CTL3', true);
		}
	});
};

</script>
