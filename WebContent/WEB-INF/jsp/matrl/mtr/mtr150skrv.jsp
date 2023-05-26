<%--
'   프로그램명 : 미출고현황조회 (구매재고)
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
<t:appConfig pgmId="mtr150skrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" /><!--창고-->
	<t:ExtComboStore items="${COMBO_WS_LIST}" storeId="wsList" /> <!-- 작업장 -->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />
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

	Unilite.defineModel('Mtr150skrvModel', {
		fields: [
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'		,type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'		,type: 'string'},
			{name: 'SPEC'				, text: '<t:message code="system.label.purchase.spec" default="규격"/>'		,type: 'string'},
			{name: 'STOCK_UNIT'			, text: '<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>'		,type: 'string'},
			{name: 'OUTSTOCK_REQ_DATE'	, text: '<t:message code="system.label.purchase.issuerequestdate" default="출고요청일"/>'	,type: 'uniDate'},
			{name: 'OUTSTOCK_NUM'		, text: '<t:message code="system.label.purchase.issuerequestno" default="출고요청번호"/>'	,type: 'string'},
			{name: 'DIV_NM'				, text: '<t:message code="system.label.purchase.division" default="사업장"/>'		,type: 'string'},
			{name: 'WORK_SHOP_NAME'		, text: '<t:message code="system.label.purchase.workcenter" default="작업장"/>'		,type: 'string'},
			{name: 'OUTSTOCK_REQ_Q'		, text: '<t:message code="system.label.purchase.issuerequestqty" default="출고요청량"/>'	,type: 'uniQty'},
			{name: 'OUTSTOCK_Q'			, text: '<t:message code="system.label.purchase.issuedqty" default="출고량"/>'		,type: 'uniQty'},
			{name: 'NOT_Q'				, text: '<t:message code="system.label.purchase.unissuedqty" default="미출고량"/>'		,type: 'uniQty'},
			{name: 'STOCK_Q'		   	, text: '<t:message code="system.label.purchase.inventoryqty" default="재고량"/>'		,type: 'uniQty'},
			{name: 'REMARK'		        , text: '<t:message code="system.label.purchase.remarks" default="비고"/>'		,type: 'string'},
			{name: 'PROJECT_NO'			, text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'		,type: 'string'}
		]
	});//End of Unilite.defineModel('Mtr150skrvModel', {


	Unilite.defineModel('Mtr150skrvModel2', {
		fields: [
			{name: 'DIV_NM'				, text: '<t:message code="system.label.purchase.mfgplace" default="제조처"/>'		,type: 'string'},
			{name: 'WORK_SHOP_NAME'		, text: '<t:message code="system.label.purchase.workcenter" default="작업장"/>'		,type: 'string'},
			{name: 'OUTSTOCK_REQ_DATE'	, text: '<t:message code="system.label.purchase.issuerequestdate" default="출고요청일"/>'	,type: 'uniDate'},
			{name: 'OUTSTOCK_NUM'		, text: '<t:message code="system.label.purchase.issuerequestno" default="출고요청번호"/>'	,type: 'string'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'		,type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.purchase.itemname2" default="품명"/>'		,type: 'string'},
			{name: 'SPEC'				, text: '<t:message code="system.label.purchase.spec" default="규격"/>'		,type: 'string'},
			{name: 'STOCK_UNIT'			, text: '<t:message code="system.label.purchase.unit" default="단위"/>'		,type: 'string'},
			{name: 'OUTSTOCK_REQ_Q'		, text: '<t:message code="system.label.purchase.issuerequestqty" default="출고요청량"/>'	,type: 'uniQty'},
			{name: 'OUTSTOCK_Q'			, text: '<t:message code="system.label.purchase.issuedqty" default="출고량"/>'		,type: 'uniQty'},
			{name: 'NOT_Q'				, text: '<t:message code="system.label.purchase.unissuedqty" default="미출고량"/>'		,type: 'uniQty'},
			{name: 'STOCK_Q'		   	, text: '<t:message code="system.label.purchase.inventoryqty" default="재고량"/>'		,type: 'uniQty'},
			{name: 'CUSTOM_NAME'		, text: '<t:message code="system.label.purchase.soplace" default="수주처"/>'		,type: 'string'},
			{name: 'REMARK'		        , text: '<t:message code="system.label.purchase.remarks" default="비고"/>'		,type: 'string'},
			{name: 'PROJECT_NO'			, text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'	,type: 'string'}
		]
	});//End of Unilite.defineModel('Mtr150skrvModel', {



	/**
	 * Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('mtr150skrvMasterStore1',{
		model: 'Mtr150skrvModel',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결
			editable: false,			// 수정 모드 사용
			deletable: false,			// 삭제 가능 여부
			useNavi : false			// prev | newxt 버튼 사용
		},
			autoLoad: false,
			proxy: {
				type: 'direct',
				api: {
					read: 'mtr150skrvService.selectList'
				}
			},
			loadStoreRecords: function(){
				var param= Ext.getCmp('searchForm').getValues();
				console.log( param );
				this.load({
					params: param
				});
			},
			groupField: 'ITEM_CODE'
	});//End of var directMasterStore1 = Unilite.createStore('mtr150skrvMasterStore1',{





	var directMasterStore2 = Unilite.createStore('mtr150skrvMasterStore2',{
		model: 'Mtr150skrvModel2',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결
			editable: false,			// 수정 모드 사용
			deletable: false,			// 삭제 가능 여부
			useNavi : false			// prev | newxt 버튼 사용
		},
			autoLoad: false,
			proxy: {
				type: 'direct',
				api: {
					read: 'mtr150skrvService.selectList2'
				}
			},
			loadStoreRecords: function(){
				var param= Ext.getCmp('searchForm').getValues();
				console.log( param );
				this.load({
					params: param
				});
			},
			groupField: 'WORK_SHOP_NAME'
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
			items: [{
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
			},
				{
				fieldLabel: '<t:message code="system.label.purchase.workcenter" default="작업장"/>',
				name: 'WORK_SHOP_CODE',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('wsList'),allowBlank:true,
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
				fieldLabel: '<t:message code="system.label.purchase.issuerequestdate" default="출고요청일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'OUTSTOCK_REQ_DATE_FR',
				endFieldName: 'OUTSTOCK_REQ_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				width: 315,
				allowBlank: false,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('OUTSTOCK_REQ_DATE_FR',newValue);

                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('OUTSTOCK_REQ_DATE_TO',newValue);
			    	}
			    }
			},
				Unilite.popup('DIV_PUMOK', {
					fieldLabel: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',
					valueFieldName: 'ITEM_CODE',
					textFieldName: 'ITEM_NAME',
//					textFieldWidth: 170,
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
				})
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
	   						var labelText = invalid.items[0]['fieldLabel']+':';
	   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
	   						var labelText = invalid.items[0].ownerCt['fieldLabel']+':';
	   					}

					   	alert(labelText+'<t:message code="system.message.purchase.datacheck001" default="필수입력 항목입니다."/>');
					   	invalid.items[0].focus();
					} else {
					//	this.mask();
	   				}
		  		} else {
  					this.unmask();
  				}
				return r;
  			}
	});//End of var panelSearch = Unilite.createSearchForm('searchForm',{

	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
					fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
					name: 'DIV_CODE',
					xtype: 'uniCombobox',
					comboType: 'BOR120',
					allowBlank: false,
					value: UserInfo.divCode,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelSearch.setValue('DIV_CODE', newValue);
							panelResult.setValue('WORK_SHOP_CODE', '');
						}
					}
				},{
				fieldLabel: '<t:message code="system.label.purchase.issuerequestdate" default="출고요청일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'OUTSTOCK_REQ_DATE_FR',
				endFieldName: 'OUTSTOCK_REQ_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				allowBlank: false,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
	            	if(panelSearch) {
						panelSearch.setValue('OUTSTOCK_REQ_DATE_FR',newValue);
	            	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('OUTSTOCK_REQ_DATE_TO',newValue);
			    	}
			    }
			},
				{
				fieldLabel: '<t:message code="system.label.purchase.workcenter" default="작업장"/>',
				name: 'WORK_SHOP_CODE',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('wsList'),allowBlank:true,
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
			},
				Unilite.popup('DIV_PUMOK', {
					fieldLabel: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',
					valueFieldName: 'ITEM_CODE',
					textFieldName: 'ITEM_NAME',
//					textFieldWidth: 170,
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
				})],
				setAllFieldsReadOnly: function(b) {
		            var r= true;
		            if(b) {
		                var invalid = this.getForm().getFields().filterBy(function(field) {
                            return !field.validate();
                        });
		                if(invalid.length > 0) {
		                    r=false;
		                    var labelText = '';
		                    if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
		                        var labelText = invalid.items[0]['fieldLabel']+':';
		                    } else if(Ext.isDefined(invalid.items[0].ownerCt)) {
		                        var labelText = invalid.items[0].ownerCt['fieldLabel']+':';
		                    }
		                    invalid.items[0].focus();
		                } else {
		                }
		            } else {
		                var fields = this.getForm().getFields();
		                Ext.each(fields.items, function(item) {
		                    if(Ext.isDefined(item.holdable) )   {
		                        if (item.holdable == 'hold') {
		                            item.setReadOnly(false);
		                        }
		                    }
		                    if(item.isPopupField)   {
		                        var popupFC = item.up('uniPopupField')  ;
		                        if(popupFC.holdable == 'hold' ) {
		                            item.setReadOnly(false);
		                        }
		                    }
		                })
		            }
		            return r;
        }
    });		// end of var panelResult = Unilite.createSearchForm('resultForm',{

    /**
     * Master Grid1 정의(Grid Panel)
     * @type
     */
	var masterGrid = Unilite.createGrid('mtr150skrvGrid1', {
    	// for tab
		layout: 'fit',
		region:'center',
		uniOpt: {
    		useGroupSummary: true,
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
			showSummaryRow: true
		},{
			id: 'masterGridTotal',
			ftype: 'uniSummary',
			showSummaryRow: true
		}],
		store: directMasterStore1,
		columns: [
			{dataIndex: 'ITEM_CODE'			, width: 120,locked: true},
			{dataIndex: 'ITEM_NAME'			, width: 200,locked: true},
			{dataIndex: 'SPEC'				, width: 150},
			{dataIndex: 'STOCK_UNIT'		, width: 66 , align:'center'},
			{dataIndex: 'OUTSTOCK_REQ_DATE'	, width: 100},
			{dataIndex: 'OUTSTOCK_NUM'		, width: 120},
			{dataIndex: 'DIV_NM'			, width: 100, hidden: true},
			{dataIndex: 'WORK_SHOP_NAME'	, width: 100},
			{dataIndex: 'OUTSTOCK_REQ_Q'	, width: 100},
			{dataIndex: 'OUTSTOCK_Q'		, width: 80},
			{dataIndex: 'NOT_Q'				, width: 80	,summaryType:'sum'},
			{dataIndex: 'STOCK_Q'			, width: 80},
			{dataIndex: 'REMARK'			, width: 133},
			{dataIndex: 'PROJECT_NO'		, width: 100}
		]
	});//End of var masterGrid = Unilite.createGrid('mtr150skrvGrid1', {




	var masterGrid2 = Unilite.createGrid('mtr150skrvGrid2', {
    	// for tab
		layout: 'fit',
		region:'center',
		uniOpt: {
    		useGroupSummary: true,
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
			showSummaryRow: true
		},{
			id: 'masterGridTotal',
			ftype: 'uniSummary',
			showSummaryRow: true
		}],
		store: directMasterStore2,
		columns: [
			{dataIndex: 'DIV_NM'				, width: 120},
			{dataIndex: 'WORK_SHOP_NAME'		, width: 100},
			{dataIndex: 'OUTSTOCK_REQ_DATE'		, width: 80},
			{dataIndex: 'OUTSTOCK_NUM'			, width: 120},
			{dataIndex: 'ITEM_CODE'				, width: 140},
			{dataIndex: 'ITEM_NAME'				, width: 150},
			{dataIndex: 'SPEC'					, width: 150},
			{dataIndex: 'STOCK_UNIT'			, width: 60 , align:'center'},
			{dataIndex: 'OUTSTOCK_REQ_Q'		, width: 100},
			{dataIndex: 'OUTSTOCK_Q'			, width: 80},
			{dataIndex: 'NOT_Q'					, width: 80 ,summaryType:'sum'},
			{dataIndex: 'STOCK_Q'				, width: 80},
			{dataIndex: 'CUSTOM_NAME'			, width: 80},
			{dataIndex: 'REMARK'				, width: 133},
			{dataIndex: 'PROJECT_NO'			, width: 100}
		]
	});


	//创建标签页面板
	var tab = Unilite.createTabPanel('tabPanel',{
        activeTab: 0,
        region: 'center',
        items: [
                 {
                     title: '<t:message code="system.label.purchase.itemby" default="품목별"/>'
                     ,xtype:'container'
                     ,layout:{type:'vbox', align:'stretch'}
                     ,items:[masterGrid]
                     ,id: 'mtr150skrvGridTab'
                 },
                 {
                     title: '<t:message code="system.label.purchase.workcenterper" default="작업장별"/>'
                     ,xtype:'container'
                     ,layout:{type:'vbox', align:'stretch'}
                     ,items:[masterGrid2]
                     ,id: 'mtr150skrvGridTab2'
                 }
        ],
        listeners:  {
            tabChange:  function ( tabPanel, newCard, oldCard, eOpts )  {
                var newTabId = newCard.getId();
                console.log("newCard:  " + newCard.getId());
                console.log("oldCard:  " + oldCard.getId());
                //탭 넘길때마다 초기화
                UniAppManager.setToolbarButtons(['save', 'newData' ], false);
                panelResult.setAllFieldsReadOnly(false);
//              Ext.getCmp('confirm_check').hide(); //확정버튼 hidden

            }
        }
    });


	Unilite.Main({
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				tab, panelResult
			]
		},
			panelSearch
		],
		id: 'mtr150skrvApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			UniAppManager.setToolbarButtons('reset', true);
			UniAppManager.setToolbarButtons('save', false);
		},
		onQueryButtonDown: function() {
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
				var activeTabId = tab.getActiveTab().getId();
				if(activeTabId == 'mtr150skrvGridTab'){
					masterGrid.getStore().loadStoreRecords();
//					var viewLocked = masterGrid.lockedGrid.getView();
//					var viewNormal = masterGrid.normalGrid.getView();
//					console.log("viewLocked: ",viewLocked);
//					console.log("viewNormal: ",viewNormal);
//				    viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
//				    viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
//				    viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
//				    viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
				    UniAppManager.setToolbarButtons('excel',true);
				}else if(activeTabId == 'mtr150skrvGridTab2'){
					masterGrid2.getStore().loadStoreRecords();
//					var viewLocked = masterGrid.lockedGrid.getView();
//					var viewNormal = masterGrid.normalGrid.getView();
//					console.log("viewLocked: ",viewLocked);
//					console.log("viewNormal: ",viewNormal);
//				    viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
//				    viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
//				    viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
//				    viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
				    UniAppManager.setToolbarButtons('excel',true);
				}
			}
		},
		onResetButtonDown: function() {
			panelSearch.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			masterGrid2.reset();
			directMasterStore1.clearData();
			directMasterStore2.clearData();
			this.fnInitBinding();
		},
		checkForNewDetail:function() {
			return panelSearch.setAllFieldsReadOnly(true);
        }
	});//End of Unilite.Main({
};


</script>
