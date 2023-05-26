<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="mpo320skrv"  >
<t:ExtComboStore comboType="BOR120" pgmId="mpo320skrv"/> 			<!-- 사업장 -->
<t:ExtComboStore comboType="AU" comboCode="B020" /> <!-- 품목계정 -->
<t:ExtComboStore comboType="AU" comboCode="B001" /> <!-- 품목계정 -->	
<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" /><!--창고-->
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

	Unilite.defineModel('Mpo320skrvModel', {
	    fields: [
			{name: 'ITEM_CODE'		     		,text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'		,type: 'string'},
			{name: 'ITEM_NAME'		     		,text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'		,type: 'string'},
			{name: 'SPEC'			     		,text: '<t:message code="system.label.purchase.spec" default="규격"/>'			,type: 'string'},
			{name: 'ITEM_MODEL'			     	,text: '<t:message code="system.label.base.model" default="모델"/>'			,type: 'string'},
			{name: 'STOCK_UNIT'		     		,text: '<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>'		,type: 'string'},
			{name: 'CUSTOM_NAME'	     		,text: '<t:message code="system.label.purchase.custom" default="거래처"/>'		,type: 'string'},
			{name: 'APLY_START_DATE'     		,text: '<t:message code="system.label.purchase.applystartdate" default="적용시작일"/>'		,type: 'uniDate'},
			{name: 'APLY_END_DATE'     			,text: '적용종료일'		,type: 'uniDate'},
			{name: 'MONEY_UNIT'		     		,text: '<t:message code="system.label.purchase.currency" default="화폐"/>'			,type: 'string'},
			{name: 'CODE_NAME'		     		,text: '화폐명'		,type: 'string'},
			{name: 'ORDER_UNIT'		     		,text: '<t:message code="system.label.purchase.purchaseunit" default="구매단위"/>'		,type: 'string'},
			{name: 'ITEM_P'			     		,text: '<t:message code="system.label.purchase.price" default="단가"/>'			,type: 'uniUnitPrice'},
			{name: 'CUSTOM_CODE'	     		,text: '<t:message code="system.label.purchase.customcode" default="거래처코드"/>'		,type: 'string'}
		]
	});//End of Unilite.defineModel('Mpo320skrvModel', {
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('mpo320skrvMasterStore1',{
		model: 'Mpo320skrvModel',
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
				read: 'mpo320skrvService.selectList'                	
		    }
		},
		loadStoreRecords: function(){
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params: param
			});
		},
		groupField: 'CUSTOM_NAME'
	});//End of var directMasterStore1 = Unilite.createStore('mpo320skrvMasterStore1',{

	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
    var panelSearch = Unilite.createSearchPanel('searchForm', {		
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
			items:[{fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>', 
				name: 'DIV_CODE', 
				xtype: 'uniCombobox', 
				comboType: 'BOR120', 
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>', 
				name: 'ITEM_ACCOUNT', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'B020',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ITEM_ACCOUNT', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.majorgroup" default="대분류"/>', 
				name: 'ITEM_LEVEL1', 
				xtype: 'uniCombobox', 
				store: Ext.data.StoreManager.lookup('itemLeve1Store'), 
				child: 'ITEM_LEVEL2',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ITEM_LEVEL1', newValue);
					}
				}
			},{ 
				fieldLabel: '<t:message code="system.label.purchase.middlegroup" default="중분류"/>', 
				name: 'ITEM_LEVEL2', 
				xtype: 'uniCombobox', 
				store: Ext.data.StoreManager.lookup('itemLeve2Store'), 
				child: 'ITEM_LEVEL3',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ITEM_LEVEL2', newValue);
					}
				}
			},{ 
				fieldLabel: '<t:message code="system.label.purchase.minorgroup" default="소분류"/>', 
				name: 'ITEM_LEVEL3', 
				xtype: 'uniCombobox', 
				store: Ext.data.StoreManager.lookup('itemLeve3Store'),
				parentNames:['ITEM_LEVEL1','ITEM_LEVEL2'],
                levelType:'ITEM',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ITEM_LEVEL3', newValue);
					}
				}
			}, 
				Unilite.popup('DIV_PUMOK', { 
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
				Unilite.popup('CUST', {
				fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>', 
				valueFieldName: 'CUSTOM_CODE', 
				textFieldName: 'CUSTOM_NAME',
				allowBlank:true,	// 2021.08 표준화 작업
				autoPopup:false,	// 2021.08 표준화 작업
				validateBlank:false,// 2021.08 표준화 작업
				listeners: {
							onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
								panelSearch.setValue('CUSTOM_CODE', newValue);
								panelResult.setValue('CUSTOM_CODE', newValue);
								if(!Ext.isObject(oldValue)) {
									panelSearch.setValue('CUSTOM_NAME', '');
									panelResult.setValue('CUSTOM_NAME', '');
								}
							},
							onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
								panelSearch.setValue('CUSTOM_NAME', newValue);
								panelResult.setValue('CUSTOM_NAME', newValue);
								if(!Ext.isObject(oldValue)) {
									panelSearch.setValue('CUSTOM_CODE', '');
									panelResult.setValue('CUSTOM_CODE', '');
								}
							}
					}
				}),
			{
				xtype: 'radiogroup',		            		
				fieldLabel: ' ',						            		
				items: [{
					boxLabel: '현재적용단가', 
					width: 110, 
					name: 'rdoSelect', 
					inputValue: 'C', 
					checked: true 
				},{
					boxLabel: '<t:message code="system.label.purchase.whole" default="전체"/>', 
					width: 80, 
					name: 'rdoSelect', 
					inputValue: 'A'
				}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.getField('rdoSelect').setValue(newValue.rdoSelect);
							
						}
					}
			}]	            			 
		}]
	});//End of var panelSearch = Unilite.createSearchForm('searchForm', {
		var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>', 
				name: 'DIV_CODE', 
				xtype: 'uniCombobox', 
				comboType: 'BOR120', 
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>', 
				name: 'ITEM_ACCOUNT', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'B020',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ITEM_ACCOUNT', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.majorgroup" default="대분류"/>', 
				name: 'ITEM_LEVEL1', 
				xtype: 'uniCombobox', 
				store: Ext.data.StoreManager.lookup('itemLeve1Store'), 
				child: 'ITEM_LEVEL2',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ITEM_LEVEL1', newValue);
					}
				}
			},{ 
				fieldLabel: '<t:message code="system.label.purchase.middlegroup" default="중분류"/>', 
				name: 'ITEM_LEVEL2', 
				xtype: 'uniCombobox', 
				store: Ext.data.StoreManager.lookup('itemLeve2Store'), 
				child: 'ITEM_LEVEL3',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('ITEM_LEVEL2', newValue);
					}
				}
			},{ 
				fieldLabel: '<t:message code="system.label.purchase.minorgroup" default="소분류"/>', 
				name: 'ITEM_LEVEL3', 
				xtype: 'uniCombobox', 
				store: Ext.data.StoreManager.lookup('itemLeve3Store'),
				parentNames:['ITEM_LEVEL1','ITEM_LEVEL2'],
                levelType:'ITEM',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('ITEM_LEVEL3', newValue);
					}
				}
			}, 
				Unilite.popup('DIV_PUMOK', { 
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
				Unilite.popup('CUST', {
				fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>', 
				valueFieldName: 'CUSTOM_CODE', 
				textFieldName: 'CUSTOM_NAME', 
				allowBlank:true,	// 2021.08 표준화 작업
				autoPopup:false,	// 2021.08 표준화 작업
				validateBlank:false,// 2021.08 표준화 작업
				listeners: {
							onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
								panelSearch.setValue('CUSTOM_CODE', newValue);
								panelResult.setValue('CUSTOM_CODE', newValue);
								if(!Ext.isObject(oldValue)) {
									panelSearch.setValue('CUSTOM_NAME', '');
									panelResult.setValue('CUSTOM_NAME', '');
								}
							},
							onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
								panelSearch.setValue('CUSTOM_NAME', newValue);
								panelResult.setValue('CUSTOM_NAME', newValue);
								if(!Ext.isObject(oldValue)) {
									panelSearch.setValue('CUSTOM_CODE', '');
									panelResult.setValue('CUSTOM_CODE', '');
								}
							}
					}
				}),
			{
				xtype: 'radiogroup',		            		
				fieldLabel: ' ',						            		
				items: [{
					boxLabel: '현재적용단가', 
					width: 110, 
					name: 'rdoSelect', 
					inputValue: 'C', 
					checked: true 
				},{
					boxLabel: '<t:message code="system.label.purchase.whole" default="전체"/>', 
					width: 80, 
					name: 'rdoSelect', 
					inputValue: 'A'
				}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.getField('rdoSelect').setValue(newValue.rdoSelect);
							
						}
					}
			}]	            			 
    });		// end of var panelResult = Unilite.createSearchForm('resultForm',{
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
	var masterGrid = Unilite.createGrid('mpo320skrvGrid1', {
    	// for tab    	
		layout: 'fit',
		region:'center',
		excelTitle: '거래처별 구매단가현황 조회',
		uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: false,
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
			showSummaryRow: false
		}],
		store: directMasterStore1,
		columns: [
			{dataIndex: 'ITEM_CODE'			,      		width: 120},
        	{dataIndex: 'ITEM_NAME'			,      		width: 250},
        	{dataIndex: 'SPEC'				,      		width: 88},
        	{dataIndex: 'ITEM_MODEL'		,      		width: 100},
        	
        	{dataIndex: 'STOCK_UNIT'	 	,      		width: 66,align:'center'},
        	{dataIndex: 'CUSTOM_NAME'	 	,      		width: 166},
        	{dataIndex: 'APLY_START_DATE'	,      		width: 106},
        	{dataIndex: 'APLY_END_DATE'	,      		width: 106},
        	{dataIndex: 'MONEY_UNIT'		,      		width: 53,align:'center'},
        	{dataIndex: 'CODE_NAME'			,      		width: 66, hidden: true},
        	{dataIndex: 'ORDER_UNIT'		,      		width: 66,align:'center'},
        	{dataIndex: 'ITEM_P'			,      		width: 80},
        	{dataIndex: 'CUSTOM_CODE'  		,      		width: 80, hidden: true}
		] 
	});//End of var masterGrid = Unilite.createGrid('mpo320skrvGrid1', {   

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
		id: 'mpo320skrvApp',
		fnInitBinding: function(){
			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			panelResult.setValue('DIV_CODE', UserInfo.divCode);
			UniAppManager.setToolbarButtons('save', false);
			UniAppManager.setToolbarButtons('reset', true);
		},
		onQueryButtonDown: function(){			
			masterGrid.getStore().loadStoreRecords();/*
			var viewLocked = masterGrid.lockedGrid.getView();
			var viewNormal = masterGrid.normalGrid.getView();
			console.log("viewLocked: ",viewLocked);
			console.log("viewNormal: ",viewNormal);
		    viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
		    viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
		    viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
		    viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);*/
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			this.fnInitBinding();
		}
	});//End of Unilite.Main({
};
</script>