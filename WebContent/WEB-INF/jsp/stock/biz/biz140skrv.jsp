<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="biz140skrv"  >
	<t:ExtComboStore comboType="BOR120"  pgmId="biz140skrv"/>			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B020" />					<!-- 품목계정 -->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store"/>
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store"/>
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store"/>
</t:appConfig>

<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>

<script type="text/javascript" >

function appMain() {
	/** Model 정의
	 * @type
	 */
	Unilite.defineModel('Biz140skrvModel', {
		fields: [
			{name: 'DIV_CODE'			,text: '<t:message code="system.label.inventory.division" default="사업장"/>'				,type: 'string'},
			{name: 'CUSTOM_CODE'		,text: '<t:message code="system.label.inventory.subcontractorcode" default="외주처코드"/>'	,type: 'string'},
			{name: 'COUNT_DATE'			,text: '<t:message code="system.label.inventory.stockcountingdate" default="실사일"/>'		,type: 'uniDate'},
			{name: 'COUNT_CONT_DATE'	,text: '<t:message code="system.label.inventory.stockcountingdate" default="실사일"/>'		,type: 'uniDate'},
			{name: 'ITEM_ACCOUNT'		,text: '<t:message code="system.label.inventory.itemaccount" default="품목계정"/>'			,type: 'string'},
			{name: 'ITEM_LEVEL1'		,text: '<t:message code="system.label.inventory.large" default="대"/>'					,type: 'string'},
			{name: 'ITEM_LEVEL2'		,text: '<t:message code="system.label.inventory.middle" default="중"/>'					,type: 'string'},
			{name: 'ITEM_LEVEL3'		,text: '<t:message code="system.label.inventory.small" default="소"/>'					,type: 'string'},
			{name: 'ITEM_CODE'			,text: '<t:message code="system.label.inventory.item" default="품목"/>'					,type: 'string'},
			{name: 'ITEM_NAME'			,text: '<t:message code="system.label.inventory.itemname" default="품목명"/>'				,type: 'string'},
			{name: 'SPEC'				,text: '<t:message code="system.label.inventory.spec" default="규격"/>'					,type: 'string'},
			{name: 'STOCK_UNIT'			,text: '<t:message code="system.label.inventory.inventoryunit" default="재고단위"/>'		,type: 'string'},
			{name: 'GOOD_STOCK_BOOK_Q'	,text: '<t:message code="system.label.inventory.good" default="양품"/>'					,type: 'uniQty'},
			{name: 'BAD_STOCK_BOOK_Q'	,text: '<t:message code="system.label.inventory.defect" default="불량"/>'					,type: 'uniQty'},
			{name: 'LOCATION'			,text: 'Location'	,type: 'string'}
		]
	});

	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('biz140skrvMasterStore1',{
		model	: 'Biz140skrvModel',
		uniOpt	: {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy	: {
			type: 'direct',
			api	: {
				 read: 'biz140skrvService.selectList'
			}
		},
		loadStoreRecords : function() {
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		groupField: ''
	});



	/** 검색조건 (Search Panel)
	 * @type
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title		: '<t:message code="system.label.inventory.searchconditon" default="검색조건"/>',
		defaultType	: 'uniSearchSubPanel',
		collapsed	: UserInfo.appOption.collapseLeftSearch,
		listeners	: {
			collapse: function () {
				panelResult.show();
			},
			expand: function() {
				panelResult.hide();
			}
		},
		items		: [{
			title		: '<t:message code="system.label.inventory.basisinfo" default="기본정보"/>',
			itemId		: 'search_panel1',
			layout		: {type: 'uniTable', columns: 1},
			defaultType	: 'uniTextfield',
			items		: [{
				fieldLabel	: '<t:message code="system.label.inventory.division" default="사업장"/>',
				name		: 'DIV_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				allowBlank	: false,
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},
			Unilite.popup('CUST',{
				fieldLabel		: '<t:message code="system.label.inventory.subcontractor" default="외주처"/>',
				valueFieldName	: 'CUSTOM_CODE',
				textFieldName	: 'CUSTOM_NAME',
				allowBlank		: false,
				listeners		: {
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('CUSTOM_CODE', newValue);
						if(Ext.isEmpty(newValue)) {
							panelSearch.setValue('CUSTOM_NAME', newValue);
							panelResult.setValue('CUSTOM_NAME', newValue);
						}
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('CUSTOM_NAME', newValue);
					},
					onSelected: {
						fn: function(records, type) {
						},
						scope: this
					},
					onClear: function(type) {
					},
					applyextparam: function(popup){
						//popup.setExtParam({'AGENT_CUST_FILTER': ['3']});
						//popup.setExtParam({'CUSTOM_TYPE': ['3']});
					}
				}
			}),
			Unilite.popup('COUNT_DATE_OUT',{
				fieldLabel	: '<t:message code="system.label.inventory.stockcountingdate" default="실사일"/>',
				name		: 'COUNT_DATE',
				allowBlank	: false,
				listeners	: {
					onSelected: {
						fn: function(records, type) {
							var countDATE = UniDate.getDbDateStr(records[0]['COUNT_DATE']).substring(0, 8);
							countDATE = countDATE.substring(0,4) + '.' + countDATE.substring(4,6) + '.' + countDATE.substring(6,8);
							panelSearch.setValue('COUNT_DATE', countDATE);
							panelResult.setValue('COUNT_DATE', panelSearch.getValue('COUNT_DATE'));
							panelResult.setValue('CUSTOM_CODE', records[0]['CUSTOM_CODE']);
							panelResult.setValue('CUSTOM_NAME', records[0]['CUSTOM_NAME']);
							panelSearch.setValue('CUSTOM_CODE', records[0]['CUSTOM_CODE']);
							panelSearch.setValue('CUSTOM_NAME', records[0]['CUSTOM_NAME']);
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('COUNT_DATE', '');
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						popup.setExtParam({'CUSTOM_CODE': panelResult.getValue('CUSTOM_CODE')});
					}
				}
			}),{
				fieldLabel	: '<t:message code="system.label.inventory.itemaccount" default="품목계정"/>',
				name		: 'ITEM_ACCOUNT',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'B020',
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelResult.setValue('ITEM_ACCOUNT', newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.inventory.majorgroup" default="대분류"/>',
				name		: 'ITEM_LEVEL1',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('itemLeve1Store'),
				child		: 'ITEM_LEVEL2',
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelResult.setValue('ITEM_LEVEL1', newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.inventory.middlegroup" default="중분류"/>',
				name		: 'ITEM_LEVEL2',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('itemLeve2Store'),
				child		: 'ITEM_LEVEL3',
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelResult.setValue('ITEM_LEVEL2', newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.inventory.minorgroup" default="소분류"/>',
				name		: 'ITEM_LEVEL3',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('itemLeve3Store'),
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelResult.setValue('ITEM_LEVEL3', newValue);
					}
				}
			}]
		}]
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 3},
		padding	: '1 1 1 1',
		border	: true,
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		items	: [{
			fieldLabel	: '<t:message code="system.label.inventory.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},
		Unilite.popup('CUST',{
			fieldLabel		: '<t:message code="system.label.inventory.subcontractor" default="외주처"/>',
			valueFieldName	: 'CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME',
			allowBlank		: false,
			listeners		: {
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('CUSTOM_CODE', newValue);
					if(Ext.isEmpty(newValue)) {
						panelSearch.setValue('CUSTOM_NAME', newValue);
						panelResult.setValue('CUSTOM_NAME', newValue);
					}
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('CUSTOM_NAME', newValue);
				},
				onSelected: {
					fn: function(records, type) {
					},
					scope: this
				},
				onClear: function(type) {
				},
				applyextparam: function(popup){
				//	popup.setExtParam({'AGENT_CUST_FILTER': ['3']});
				//	popup.setExtParam({'CUSTOM_TYPE': ['3']});
				}
			}
		}),
		Unilite.popup('COUNT_DATE_OUT',{
			fieldLabel	: '<t:message code="system.label.inventory.stockcountingdate" default="실사일"/>',
			name		: 'COUNT_DATE',
			allowBlank	: false,
			labelWidth	: 177,
			listeners	: {
				onSelected: {
					fn: function(records, type) {
						var countDATE = UniDate.getDbDateStr(records[0]['COUNT_DATE']).substring(0, 8);
						countDATE = countDATE.substring(0,4) + '.' + countDATE.substring(4,6) + '.' + countDATE.substring(6,8);
						panelResult.setValue('COUNT_DATE', countDATE);
						panelSearch.setValue('COUNT_DATE', panelResult.getValue('COUNT_DATE'));
						panelResult.setValue('CUSTOM_CODE', records[0]['CUSTOM_CODE']);
						panelResult.setValue('CUSTOM_NAME', records[0]['CUSTOM_NAME']);
						panelSearch.setValue('CUSTOM_CODE', records[0]['CUSTOM_CODE']);
						panelSearch.setValue('CUSTOM_NAME', records[0]['CUSTOM_NAME']);
					},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.setValue('COUNT_DATE', '');
				},
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
					popup.setExtParam({'CUSTOM_CODE': panelResult.getValue('CUSTOM_CODE')});
				}
			}
		}),{
			fieldLabel	: '<t:message code="system.label.inventory.itemaccount" default="품목계정"/>',
			name		: 'ITEM_ACCOUNT',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B020',
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					panelSearch.setValue('ITEM_ACCOUNT', newValue);
				}
			}
		},{
			xtype	: 'container',
			layout	: {type : 'uniTable', columns : 3},
			colspan	: 2,
			items	: [{
				fieldLabel	: '<t:message code="system.label.inventory.majorgroup" default="대분류"/>',
				name		: 'ITEM_LEVEL1',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('itemLeve1Store'),
				child		: 'ITEM_LEVEL2',
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelSearch.setValue('ITEM_LEVEL1', newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.inventory.middlegroup" default="중분류"/>',
				name		: 'ITEM_LEVEL2',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('itemLeve2Store'),
				child		: 'ITEM_LEVEL3',
				labelWidth	: 50,
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelSearch.setValue('ITEM_LEVEL2', newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.inventory.minorgroup" default="소분류"/>',
				name		: 'ITEM_LEVEL3',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('itemLeve3Store'),
				labelWidth	: 50,
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelSearch.setValue('ITEM_LEVEL3', newValue);
					}
				}
			}]
		}]
	});



	/** Master Grid1 정의(Grid Panel)
	 * @type
	 */
	var masterGrid = Unilite.createGrid('biz140skrvGrid1', {
		store	: directMasterStore1,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			expandLastColumn	: true,
			useRowNumberer		: true,
			useMultipleSorting	: true
		},
		features: [ {id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
					{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false}],
		columns	: [
			{ dataIndex: 'DIV_CODE'						, width:66,hidden: true},
			{ dataIndex: 'CUSTOM_CODE'					, width:66,hidden: true},
			{ dataIndex: 'COUNT_DATE'					, width:66,hidden: true},
			{ dataIndex: 'COUNT_CONT_DATE'				, width:66,hidden: true},
			{ dataIndex: 'ITEM_ACCOUNT'					, width:80},
			{
				text	: '<t:message code="system.label.inventory.itemgroup" default="품목분류"/>',
				columns	: [
					{ dataIndex: 'ITEM_LEVEL1'			, width:100},
					{ dataIndex: 'ITEM_LEVEL2'			, width:100},
					{ dataIndex: 'ITEM_LEVEL3'			, width:100}
				]
			},
			{ dataIndex: 'ITEM_CODE'					, width:110},
			{ dataIndex: 'ITEM_NAME'					, width:150},
			{ dataIndex: 'SPEC'							, width:120},
			{ dataIndex: 'STOCK_UNIT'					, width:66},
			{
				text	: '<t:message code="system.label.inventory.systemqty" default="전산수량"/>',
				columns	: [
					{ dataIndex: 'GOOD_STOCK_BOOK_Q'	, width:100},
					{ dataIndex: 'BAD_STOCK_BOOK_Q'		, width:100}
				]
			},
			{ dataIndex: 'LOCATION'						, width:100}
		]
	});



	Unilite.Main({
		id			: 'biz140skrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				panelResult, masterGrid
			]
		},
			panelSearch
		],
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE', UserInfo.divCode);

			//초기화 시 포커스 이동
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch) {
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('DIV_CODE');
		},
		onQueryButtonDown : function() {
			if(!this.isValidSearchForm()){
				return false;
			}
			masterGrid.getStore().loadStoreRecords();
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.getStore().loadData({});
			this.fnInitBinding();
		}
	});
};
</script>