<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="btr910skrv"  >
	<t:ExtComboStore comboType="BOR120"  />							<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B020" />				<!-- 품목계정 -->
	<t:ExtComboStore comboType="AU" comboCode="B021" />				<!-- 양불구분 -->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList"/>	<!--창고-->
</t:appConfig>
<script type="text/javascript" >

var BsaCodeInfo = {		//컨트롤러에서 값을 받아옴.
	gsLotNoYN		: '${gsLotNoYN}',
	gsCellCodeYN	: '${gsCellCodeYN}'
};

function appMain() {
	/** Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Btr910skrvModel', {
		fields: [	 
			{name: 'INOUT_NUM',			text: '<t:message code="system.label.inventory.tranno" default="수불번호"/>',			type: 'string'},
			{name: 'INOUT_SEQ',			text: '<t:message code="system.label.inventory.seq" default="순번"/>',				type: 'int'},
			{name: 'INOUT_DATE',		text: '<t:message code="system.label.inventory.transdate" default="수불일"/>',			type: 'uniDate'},
			{name: 'ITEM_CODE',			text: '<t:message code="system.label.inventory.item" default="품목"/>',				type: 'string'},
			{name: 'ITEM_NAME',			text: '<t:message code="system.label.inventory.itemname" default="품목명"/>',			type: 'string'},
			{name: 'WH_CELL_CODE',		text: '<t:message code="system.label.inventory.warehousecell" default="창고Cell"/>',	type: 'string'},
			{name: 'LOT_NO',			text: '<t:message code="system.label.inventory.lotno" default="LOT번호"/>',			type: 'string'},
			{name: 'SPEC',				text: '<t:message code="system.label.inventory.spec" default="규격"/>',				type: 'string'},
			{name: 'ITEM_ACCOUNT',		text: '<t:message code="system.label.inventory.itemaccount" default="품목계정"/>',		type: 'string', comboType: 'AU'	, comboCode: 'B020'},
			{name: 'INOUT_TYPE_DETAIL',	text: '출고/입고 구분',	type: 'string'},
			{name: 'WH_CODE',			text: '<t:message code="system.label.inventory.warehouse" default="창고"/>',			type: 'string', store: Ext.data.StoreManager.lookup('whList')},
			{name: 'ITEM_STATUS',		text: '수불상태',		type: 'string', comboType: 'AU'	, comboCode: 'B021'},
			{name: 'INOUT_Q',			text: '수불량',		type: 'uniQty'}
		]
	});

	/** Store 정의(Service 정의)
	 * @type 
	 */
	var directMasterStore1 = Unilite.createStore('btr910skrvMasterStore1',{
			model	: 'Btr910skrvModel',
			uniOpt	: {
				isMaster	: true,		// 상위 버튼 연결 
				editable	: false,	// 수정 모드 사용 
				deletable	: false,	// 삭제 가능 여부 
				useNavi		: false		// prev | next 버튼 사용
			},
			autoLoad: false,
			proxy	: {
				type: 'direct',
				api	: {
					read: 'btr910skrvService.selectList'
				}
			},
			loadStoreRecords : function() {
				var param= Ext.getCmp('searchForm').getValues();
				console.log( param );
				this.load({
					params : param
				});
			},
			groupField: 'INOUT_NUM'
	});

	/** 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm',{
		title		: '<t:message code="system.label.sales.searchconditon" default="검색조건"/>',
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
		items: [{	
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
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel		: '<t:message code="system.label.inventory.transdate" default="수불일"/>',
				xtype			: 'uniDateRangefield',
				startFieldName	: 'INOUT_DATE_FR',
				endFieldName	: 'INOUT_DATE_TO',
				width			: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('INOUT_DATE_FR',newValue);
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('INOUT_DATE_TO',newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.inventory.warehouse" default="창고"/>',
				name		: 'WH_CODE',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('whList'),
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('WH_CODE', newValue);
					},
					beforequery:function( queryPlan, eOpts ) {
						var store = queryPlan.combo.store;
						store.clearFilter();
						if(!Ext.isEmpty(panelResult.getValue('DIV_CODE'))){
							 store.filterBy(function(record){
								 return record.get('option') == panelResult.getValue('DIV_CODE');
							})
						} else {
							store.filterBy(function(record){
								return false;
							})
						}
					}
				}
			},
			Unilite.popup('DIV_PUMOK',{ 
				fieldLabel		: '<t:message code="system.label.inventory.item" default="품목"/>',
				valueFieldName	: 'ITEM_CODE', 
				textFieldName	: 'ITEM_NAME', 
				validateBlank	: false,
				listeners		: {
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('ITEM_CODE', newValue);
						if(Ext.isEmpty(newValue)) {
							panelSearch.setValue('ITEM_NAME', newValue);
							panelResult.setValue('ITEM_NAME', newValue);
						}
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('ITEM_NAME', newValue);
					},
					onSelected: {
						fn: function(records, type) {
						},
						scope: this
					},
					onClear: function(type) {
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE'), 'ITEM_ACCOUNT': ['10','20']});
					}
				}
			})]
		}]
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 2},
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
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
			fieldLabel		: '<t:message code="system.label.inventory.transdate" default="수불일"/>',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'INOUT_DATE_FR',
			endFieldName	: 'INOUT_DATE_TO',
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('INOUT_DATE_FR',newValue);
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('INOUT_DATE_TO',newValue);
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.inventory.warehouse" default="창고"/>',
			name		: 'WH_CODE',
			xtype		: 'uniCombobox',
			store		: Ext.data.StoreManager.lookup('whList'),
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('WH_CODE', newValue);
				},
				beforequery:function( queryPlan, eOpts ) {
					var store = queryPlan.combo.store;
					store.clearFilter();
					if(!Ext.isEmpty(panelResult.getValue('DIV_CODE'))){
						 store.filterBy(function(record){
							 return record.get('option') == panelResult.getValue('DIV_CODE');
						})
					} else {
						store.filterBy(function(record){
							return false;
						})
					}
				}
			}
		},
		Unilite.popup('DIV_PUMOK',{ 
			fieldLabel		: '<t:message code="system.label.inventory.item" default="품목"/>',
			valueFieldName	: 'ITEM_CODE', 
			textFieldName	: 'ITEM_NAME',
			validateBlank	: false,
			listeners		: {
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('ITEM_CODE', newValue);
					if(Ext.isEmpty(newValue)) {
						panelSearch.setValue('ITEM_NAME', newValue);
						panelResult.setValue('ITEM_NAME', newValue);
					}
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('ITEM_NAME', newValue);
				},
				onSelected: {
					fn: function(records, type) {
					},
					scope: this
				},
				onClear: function(type) {
				},
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE'), 'ITEM_ACCOUNT': ['10','20']});
				}
			}
		})]
	});



	/** Master Grid 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid = Unilite.createGrid('biv910skrvGrid1', {
		store	: directMasterStore1,
		region	: 'center' ,
		layout	: 'fit',
		uniOpt	: {
			expandLastColumn	: true,
			useRowNumberer		: true,
			useMultipleSorting	: true
		},
		columns: [ 
			{dataIndex: 'INOUT_NUM',		width: 110},
			{dataIndex: 'INOUT_DATE',		width: 93},
			{dataIndex: 'ITEM_CODE',		width: 106},
			{dataIndex: 'ITEM_NAME',		width: 186},
			{dataIndex: 'WH_CELL_CODE',		width: 100, hidden: BsaCodeInfo.gsCellCodeYN == 'Y' ? false : true},
			{dataIndex: 'LOT_NO',			width: 100, hidden: BsaCodeInfo.gsLotNoYN == 'Y' ? false : true},
			{dataIndex: 'SPEC',				width: 186},
			{dataIndex: 'ITEM_ACCOUNT',		width: 86 , align: 'center'},
			{dataIndex: 'INOUT_TYPE_DETAIL',width: 100, align: 'center'},
			{dataIndex: 'WH_CODE',			width: 100},
			{dataIndex: 'ITEM_STATUS',		width: 93, align: 'center'},
			{dataIndex: 'INOUT_Q',			width: 100}
		]
	});


	Unilite.Main({
		id			: 'btr910skrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				masterGrid, panelResult
			]
		},
			panelSearch
		],
		fnInitBinding : function() {
			this.setDefault();
			//초기화 시 포커스 이동
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
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
		},
		setDefault: function() {
			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			panelSearch.setValue('INOUT_DATE_FR', UniDate.get('startOfMonth'));
			panelSearch.setValue('INOUT_DATE_TO', UniDate.get('today'));

			panelResult.setValue('DIV_CODE', UserInfo.divCode);
			panelResult.setValue('INOUT_DATE_FR', UniDate.get('startOfMonth'));
			panelResult.setValue('INOUT_DATE_TO', UniDate.get('today'));
		}
	});
};
</script>