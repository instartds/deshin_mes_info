<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_str340skrv_mit"  >
	<t:ExtComboStore comboType="BOR120" pgmId="s_str340skrv_mit" />				<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="S008" />							<!-- 반품유형 -->
	<t:ExtComboStore comboType="AU" comboCode="S073" />							<!-- 반품시 불량 처리유형 -->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />	<!-- 대분류 -->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />	<!-- 중분류 -->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />	<!-- 소분류 -->
</t:appConfig>

<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>

<script type="text/javascript" >

function appMain() {
	/** Model 정의
	 * @type
	 */
	Unilite.defineModel('s_str340skrv_mitModel1', {
		fields: [
			{name: 'INSPEC_NUM'			,text: '<t:message code="system.label.sales.returnmanageno" default="반품관리번호"/>'		,type: 'string'},
			{name: 'INOUT_DATE'			,text: '<t:message code="system.label.sales.returndate" default="반품일"/>'			,type: 'uniDate'},
			{name: 'CUSTOM_CODE'		,text: '<t:message code="system.label.sales.custom" default="거래처코드"/>'				,type: 'string'},
			{name: 'CUSTOM_NAME'		,text: '<t:message code="system.label.sales.customname" default="거래처명"/>'			,type: 'string'},
			{name: 'ITEM_CODE'			,text: '<t:message code="system.label.sales.item" default="품목"/>'					,type: 'string'},
			{name: 'ITEM_NAME'			,text: '<t:message code="system.label.sales.itemname" default="품목명"/>'				,type: 'string'},
			{name: 'SPEC'				,text: '<t:message code="system.label.sales.spec" default="규격"/>'					,type: 'string'},
			{name: 'LOT_NO'				,text: '<t:message code="system.label.sales.lotno" default="LOT번호"/>'				,type: 'string'},
			{name: 'ORDER_UNIT_Q'		,text: '<t:message code="system.label.sales.returnqty" default="반품량"/>'				,type: 'uniQty'},
			{name: 'INOUT_Q'			,text: '<t:message code="system.label.sales.returnqty_stock" default="반품량(재고)"/>'	,type: 'uniQty'},
			{name: 'INOUT_TYPE_DETAIL'	,text: '<t:message code="system.label.sales.returntype" default="반품유형"/>'			,type: 'string',comboType: 'AU',comboCode: 'S008'},
			{name: 'ACCOUNT_YNC'		,text: '매출처리결과'			,type: 'string'},
			{name: 'REMARK'				,text: '특이사항'			,type: 'string'},
			{name: 'PROC_METHOD'		,text: '처리방향'			,type: 'string',comboType: 'AU',comboCode: 'S073', allowBlank: false},
			{name: 'ITEM_LEVEL1' 		,text: '<t:message code="system.label.sales.majorgroup" default="대분류"/>'			,type: 'string' ,store: Ext.data.StoreManager.lookup('itemLeve1Store') ,child:'ITEM_LEVEL2'},
			{name: 'ITEM_LEVEL2' 		,text: '<t:message code="system.label.sales.middlegroup" default="중분류"/>'			,type: 'string' ,store: Ext.data.StoreManager.lookup('itemLeve2Store') ,child:'ITEM_LEVEL3'},
			{name: 'ITEM_LEVEL3' 		,text: '<t:message code="system.label.sales.minorgroup" default="소분류"/>'			,type: 'string' ,store: Ext.data.StoreManager.lookup('itemLeve3Store')},
			//HIDDEN 컬럼
			{name: 'DIV_CODE'			,text: '<t:message code="system.label.sales.trandivision" default="수불사업장"/>'		,type: 'string'},
			{name: 'INOUT_NUM'			,text: '<t:message code="system.label.sales.returnno" default="반품번호"/>'				,type: 'string'},
			{name: 'INOUT_SEQ'			,text: '순번'				,type: 'int'}
		]
	});

	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore = Unilite.createStore('s_str340skrv_mitMasterStore1',{
		model	: 's_str340skrv_mitModel1',
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
				read: 's_str340skrv_mitService.selectList'
			}
		},
		loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			var authoInfo = pgmInfo.authoUser;	//권한정보(N-전체,A-자기사업장>5-자기부서)
			var deptCode = UserInfo.deptCode;	//부서코드
			if(authoInfo == "5" && Ext.isEmpty(panelSearch.getValue('DEPT_CODE'))){
				param.DEPT_CODE = deptCode;
			}
			console.log( param );
			this.load({
				params: param
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				if(records != null && records.length > 0 ) {
					UniAppManager.setToolbarButtons('print', true);
				} else {
					UniAppManager.setToolbarButtons('print', false);
				}
			},
			add: function(store, records, index, eOpts) {
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
			},
			remove: function(store, record, index, isMove, eOpts) {
			}
		}
	});



	/** 검색조건 (Search Panel)
	 * @type
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
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
		items		: [{
			title	: '<t:message code="system.label.sales.basisinfo" default="기본정보"/>',
			itemId	: 'search_panel1',
			layout	: {type: 'vbox', align: 'stretch'},
			items	: [{
				xtype	: 'container',
				layout	: {type: 'uniTable', columns: 1},
				items	: [{
					fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>',
					name		: 'DIV_CODE',
					xtype		: 'uniCombobox',
					comboType	: 'BOR120',
					allowBlank	: false,
					value		: UserInfo.divCode,
					listeners	: {
						change: function(combo, newValue, oldValue, eOpts) {
							panelResult.setValue('DIV_CODE', newValue);
						}
					}
				},{
					fieldLabel	: '반품월',
					name		: 'INOUT_MONTH',
					xtype		: 'uniMonthfield',
					holdable	: 'hold',
					value		: new Date(),
					allowBlank	: false,
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('INOUT_MONTH', newValue);
						}
					}
				},{
					fieldLabel	: '<t:message code="system.label.sales.returnmanageno" default="반품관리번호"/>',
					name		: 'INSPEC_NUM',
					xtype		: 'uniTextfield',
					holdable	: 'hold',
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('INSPEC_NUM', newValue);
						}
					}
				},{
					fieldLabel	: '<t:message code="system.label.sales.majorgroup" default="대분류"/>',
					name		: 'ITEM_LEVEL1',
					xtype		: 'uniCombobox',
					store		: Ext.data.StoreManager.lookup('itemLeve1Store'),
					child		: 'ITEM_LEVEL2',
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('ITEM_LEVEL1', newValue);
						}
					}
				},{
					fieldLabel	: '<t:message code="system.label.sales.middlegroup" default="중분류"/>',
					name		: 'ITEM_LEVEL2',
					xtype		: 'uniCombobox',
					store		: Ext.data.StoreManager.lookup('itemLeve2Store'),
					child		: 'ITEM_LEVEL3',
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('ITEM_LEVEL2', newValue);
						}
					}
				},{
					fieldLabel	: '<t:message code="system.label.sales.minorgroup" default="소분류"/>',
					name		: 'ITEM_LEVEL3',
					xtype		: 'uniCombobox',
					store		: Ext.data.StoreManager.lookup('itemLeve3Store'),
					parentNames	: ['ITEM_LEVEL1','ITEM_LEVEL2'],
					levelType	: 'ITEM',
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('ITEM_LEVEL3', newValue);
						}
					}
				},{
					fieldLabel	: 'LOT_NO',
					name		: 'LOT_NO',
					xtype		: 'uniTextfield',
					listeners	: {
						change	: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('LOT_NO', newValue);
						}
					}
				}]
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
			fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			value		: UserInfo.divCode,
			allowBlank	: false,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
			fieldLabel	: '반품월',
			name		: 'INOUT_MONTH',
			xtype		: 'uniMonthfield',
			holdable	: 'hold',
			value		: new Date(),
			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('INOUT_MONTH', newValue);
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.returnmanageno" default="반품관리번호"/>',
			name		: 'INSPEC_NUM',
			xtype		: 'uniTextfield',
			holdable	: 'hold',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('INSPEC_NUM', newValue);
				}
			}
		},{
			xtype	: 'container',
			layout	: {type : 'uniTable', columns : 3},
			padding	: '0 0 3 0',
			colspan	: 2,
			items	: [{
				fieldLabel	: '품목분류',
				name		: 'ITEM_LEVEL1',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('itemLeve1Store'),
				child		: 'ITEM_LEVEL2',
				width		: 231,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('ITEM_LEVEL1', newValue);
					}
				}
			},{
				fieldLabel	: '',
				name		: 'ITEM_LEVEL2',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('itemLeve2Store'),
				child		: 'ITEM_LEVEL3',
				width		: 130,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('ITEM_LEVEL2', newValue);
					}
				}
			},{
				fieldLabel	: '',
				name		: 'ITEM_LEVEL3',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('itemLeve3Store'),
				parentNames	: ['ITEM_LEVEL1','ITEM_LEVEL2'],
				levelType	: 'ITEM',
				width		: 130,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('ITEM_LEVEL3', newValue);
					}
				}
			}]
		},{
			fieldLabel	: 'LOT_NO',
			name		: 'LOT_NO',
			xtype		: 'uniTextfield',
			listeners	: {
				change	: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('LOT_NO', newValue);
				}
			}
		}]
	});



	/** Master Grid1 정의(Grid Panel)
	 * @type
	 */
	var masterGrid = Unilite.createGrid('s_str340skrv_mitGrid1', {
		store	: directMasterStore,
		layout	: 'fit',
		region	: 'center',
		selModel: 'rowmodel',
		tbar	: [{
			fieldLabel	: '<t:message code="system.label.sales.selectionsummary" default="선택된 데이터 합계"/>',
			xtype		:'uniNumberfield',
			itemId		: 'selectionSummary',
			readOnly	: true,
			value		: 0,
			labelWidth	: 110,
			decimalPrecision:4,
			format		: '0,000.0000'
		}],
		features: [ {id: 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: true },
					{id: 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false} ],
		columns	: [
			{ dataIndex: 'DIV_CODE'				, width: 100	, hidden: true},
			{ dataIndex: 'INOUT_NUM'			, width: 100	, hidden: true},
			{ dataIndex: 'INOUT_SEQ'			, width: 100	, hidden: true},
			{ dataIndex: 'INSPEC_NUM'			, width: 110},
			{ dataIndex: 'CUSTOM_CODE'			, width: 100},
			{ dataIndex: 'CUSTOM_NAME'			, width: 150},
			{ dataIndex: 'ITEM_CODE'			, width: 100},
			{ dataIndex: 'ITEM_NAME'			, width: 220},
			{ dataIndex: 'SPEC'					, width: 160},
			{ dataIndex: 'LOT_NO'				, width: 100},
			{ dataIndex: 'ORDER_UNIT_Q'			, width: 100	, summaryType: 'sum'},
			{ dataIndex: 'INOUT_Q'				, width: 100	, hidden: true},
			{ dataIndex: 'INOUT_TYPE_DETAIL'	, width: 150},
			{ dataIndex: 'ACCOUNT_YNC'			, width: 90		, align: 'center'},
			{ dataIndex: 'REMARK'				, width: 200},
			{ dataIndex: 'PROC_METHOD'			, width: 80},
			{ dataIndex: 'ITEM_LEVEL1'			, width: 90},
			{ dataIndex: 'ITEM_LEVEL2'			, width: 90},
			{ dataIndex: 'ITEM_LEVEL3'			, width: 90}
		],
		listeners:{
			selectionchange:function( grid, selection, eOpts ) {/*
				if(selection && selection.startCell) {
					var columnName = selection.startCell.column.dataIndex;
					var displayField= Ext.getCmp("selectionSummary");
						if(selection.startCell.column.xtype == 'uniNnumberColumn' && selection.startCell.column.dataIndex == selection.endCell.column.dataIndex) {
						var startIdx = selection.startCell.rowIdx, endIdx = selection.endCell.rowIdx;
						var store = grid.store;
						var sum = 0;
						for(var i=startIdx; i <= endIdx; i++){
							var record = store.getAt(i);
							sum += record.get(columnName);
						}
						this.down('#selectionSummary').setValue(sum);
					} else {
						this.down('#selectionSummary').setValue(0);
					}
				}
				if(!Ext.isEmpty(masterGrid.getSelectedRecord()) && !Ext.isEmpty(masterGrid.getSelectedRecord().get('INSPEC_NUM'))) {
					panelSearch.setValue('INSPEC_NUM', masterGrid.getSelectedRecord().get('INSPEC_NUM'));
					panelResult.setValue('INSPEC_NUM', masterGrid.getSelectedRecord().get('INSPEC_NUM'));
					UniAppManager.setToolbarButtons('print', true);
				} else {
					panelSearch.setValue('INSPEC_NUM', '');
					panelResult.setValue('INSPEC_NUM', '');
					UniAppManager.setToolbarButtons('print', false);
				}
			*/},
			cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {/*
				if(record && !Ext.isEmpty(record.get('INSPEC_NUM'))) {
					panelSearch.setValue('INSPEC_NUM', record.get('INSPEC_NUM'));
					panelResult.setValue('INSPEC_NUM', record.get('INSPEC_NUM'));
					UniAppManager.setToolbarButtons('print', true);
				} else {
					panelSearch.setValue('INSPEC_NUM', '');
					panelResult.setValue('INSPEC_NUM', '');
					UniAppManager.setToolbarButtons('print', false);
				}
			*/}
		}
	});



	Unilite.Main({
		id			: 's_str340skrv_mitApp',
		borderItems	:[{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				masterGrid, panelResult
			]
		},
			panelSearch
		],
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE'		, UserInfo.divCode);
			panelSearch.setValue('INOUT_MONTH'	, new Date());
			panelResult.setValue('DIV_CODE'		, UserInfo.divCode);
			panelResult.setValue('INOUT_MONTH'	, new Date());

			UniAppManager.setToolbarButtons('print', false);

			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('DIV_CODE');
		},
		onQueryButtonDown: function() {
			if(!this.isValidSearchForm()){
				return false;
			}
			directMasterStore.loadStoreRecords();
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.getStore().loadData({})
			UniAppManager.setToolbarButtons('print', false);
			this.fnInitBinding();
		},
		onPrintButtonDown: function() {
			var win;
			var records = masterGrid.getStore().data.items;
			if(Ext.isEmpty(records)) {
				Unilite.messageBox('<t:message code="system.message.sales.message140" default="출력할 데이터가 없습니다."/>')
				return false;
			}
			var param = panelSearch.getValues();
			win = Ext.create('widget.ClipReport', {
				url		: CPATH + '/z_mit/s_str340clskrv_mit.do',
				prgID	: 's_str340skrv_mit',
				extParam: param
			});
			win.center();
			win.show();
		}
	});
};
</script>