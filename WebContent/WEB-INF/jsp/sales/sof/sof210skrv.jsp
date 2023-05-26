<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="sof210skrv">
	<t:ExtComboStore comboType="BOR120" pgmId="sof210skrv"/>			<!-- 사업장 -->
</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>

<script type="text/javascript" >

function appMain() {
	Unilite.defineModel('sof210skrvModel', {
		fields: [
			{name: 'COMP_CODE'			,text: 'COMP_CODE'	,type: 'string'},
			{name: 'DIV_CODE'			,text: '<t:message code="system.label.sales.issuedivision" default="출고사업장"/>'			,type: 'string',comboType: 'BOR120'},
			{name: 'SALE_CUSTOM_CODE'	,text: '<t:message code="system.label.sales.custom" default="거래처"/>'					,type: 'string'},
			{name: 'SALE_CUSTOM_NAME'	,text: '<t:message code="system.label.sales.customname" default="거래처명"/>'				,type: 'string'},
			{name: 'PROD_ITEM_CODE'		,text: '<t:message code="system.label.sales.item" default="품목"/>'						,type: 'string'},
			{name: 'PROD_ITEM_NAME'		,text: '<t:message code="system.label.sales.itemname" default="품목명"/>'					,type: 'string'},
			{name: 'MODEL_COL'			,text: '모델'			,type: 'string'},
			{name: 'ORDER_Q'			,text: '<t:message code="system.label.sales.soqty" default="수주량"/>'						,type: 'uniQty'},
			{name: 'ORDER_DATE'			,text: '<t:message code="system.label.sales.sodate" default="수주일"/>'					,type: 'uniDate'},
			{name: 'INSERT_DATE'		,text: '<t:message code="system.label.sales.entrydate" default="등록일"/>'					,type: 'uniDate'},
			{name: 'DVRY_DATE'			,text: '<t:message code="system.label.sales.deliverydate" default="납기일"/>'				,type: 'uniDate'},
			{name: 'ORDER_NUM'			,text: '<t:message code="system.label.sales.sono" default="수주번호"/>'						,type: 'string'},
			{name: 'SER_NO'				,text: '<t:message code="system.label.sales.seq" default="순번"/>'						,type: 'integer'},
			{name: 'LEVEL_COL'			,text: '레벨'			,type: 'integer'},
			{name: 'ITEM_ACCOUNT'		,text: '<t:message code="system.label.sales.itemaccount" default="품목계정"/>'				,type: 'string'},
			{name: 'ITEM_LEVEL_COL'		,text: '품목레벨'		,type: 'string'},
			{name: 'ITEM_CODE'			,text: '<t:message code="system.label.sales.item" default="품목"/>'						,type: 'string'},
			{name: 'ITEM_NAME'			,text: '<t:message code="system.label.sales.itemname" default="품목명"/>'					,type: 'string'},
			{name: 'SPEC'				,text: '<t:message code="system.label.sales.spec" default="규격"/>'						,type: 'string'},
			{name: 'STOCK_UNIT'			,text: '<t:message code="system.label.sales.unit" default="단위"/>'						,type: 'string'},
			{name: 'CUSTOM_CODE'		,text: '업체코드'		,type: 'string'},
			{name: 'CUSTOM_NAME'		,text: '업체명'		,type: 'string'},
			{name: 'UNIT_Q'				,text: '<t:message code="system.label.purchase.originunitqty" default="원단위량"/>'			,type: 'float', decimalPrecision: 6, format:'0,000.000000'},
			{name: 'PROD_UNIT_Q'		,text: '<t:message code="system.label.purchase.parentitembaseqty" default="모품목기준수"/>'	,type: 'number'},
			{name: 'LOSS_RATE'			,text: '<t:message code="system.label.purchase.lossrate" default="Loss율"/>'				,type: 'uniPercent'},
			{name: 'NEED_Q'				,text: '<t:message code="system.label.purchase.requiredqty" default="소요량"/>'			,type: 'float', decimalPrecision: 2, format:'0,000.00'},
			{name: 'EQU_CODE'			,text: '금형번호'		,type: 'string'},
			{name: 'EQU_NAME'			,text: '금형명'		,type: 'string'},
			{name: 'T_IDX'				,text: 'T_IDX'																			,type: 'int'}
		]
	});

	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('sof210skrvMasterStore1',{
		model	: 'sof210skrvModel',
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy	: {
			type: 'direct',
			api: {
				read: 'sof210skrvService.selectList'
			}
		},
		loadStoreRecords : function() {
			var param= Ext.getCmp('searchForm').getValues();
			var authoInfo = pgmInfo.authoUser;			//권한정보(N-전체,A-자기사업장>5-자기부서)
			var deptCode = UserInfo.deptCode;			//부서코드
			if(authoInfo == "5" && Ext.isEmpty(panelSearch.getValue('DEPT_CODE'))){
				param.DEPT_CODE = deptCode;
			}
			console.log( param );
			this.load({
				params : param
			});
		},
		listeners:{
			load:function( store, records, successful, operation, eOpts ) {
				if(records && records.length > 0){
//					Ext.each(records, function(record, i) {
//						record.set('ITEM_LEVEL', record.get('ITEM_LEVEL').replace(' ', '&nbsp;'));
//					});
				}
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
			title		: '<t:message code="system.label.sales.basisinfo" default="기본정보"/>',
   			itemId		: 'search_panel1',
			layout		: {type: 'uniTable', columns: 1},
			defaultType	: 'uniTextfield',
			items		: [{
				fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>',
				name		: 'DIV_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				allowBlank	: false,
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
						combo.changeDivCode(combo, newValue, oldValue, eOpts);
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel		: '<t:message code="system.label.sales.sodate" default="수주일"/>',
				startFieldName	: 'ORDER_DATE_FR',
				endFieldName	: 'ORDER_DATE_TO',
				xtype			: 'uniDateRangefield',
				width			: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('ORDER_DATE_FR', newValue);
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('ORDER_DATE_TO', newValue);
					}
				}
			},{	//20200921 추가: 조회조건 등록일 추가
				fieldLabel		: '<t:message code="system.label.sales.entrydate" default="등록일"/>',
				startFieldName	: 'INSERT_DATE_FR',
				endFieldName	: 'INSERT_DATE_TO',
				xtype			: 'uniDateRangefield',
				width			: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('INSERT_DATE_FR', newValue);
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('INSERT_DATE_TO', newValue);
					}
				}
			},
			Unilite.popup('AGENT_CUST',{
				fieldLabel		: '<t:message code="system.label.sales.custom" default="거래처"/>',
				validateBlank	: false,
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
					applyextparam: function(popup){
					}
				}
			}),
			Unilite.popup('DIV_PUMOK',{
				fieldLabel		: '<t:message code="system.label.sales.item" default="품목"/>',
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
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}
			})]
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
			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
			fieldLabel		: '<t:message code="system.label.sales.sodate" default="수주일"/>',
			startFieldName	: 'ORDER_DATE_FR',
			endFieldName	: 'ORDER_DATE_TO',
			xtype			: 'uniDateRangefield',
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('ORDER_DATE_FR', newValue);
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('ORDER_DATE_TO', newValue);
				}
			}
		},{	//20200921 추가: 조회조건 등록일 추가
			fieldLabel		: '<t:message code="system.label.sales.entrydate" default="등록일"/>',
			startFieldName	: 'INSERT_DATE_FR',
			endFieldName	: 'INSERT_DATE_TO',
			xtype			: 'uniDateRangefield',
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('INSERT_DATE_FR', newValue);
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('INSERT_DATE_TO', newValue);
				}
			}
		},
		Unilite.popup('AGENT_CUST',{
			fieldLabel		: '<t:message code="system.label.sales.custom" default="거래처"/>',
			validateBlank	: false,
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
				applyextparam: function(popup){
				}
			}
		}),
		Unilite.popup('DIV_PUMOK',{
			fieldLabel		: '<t:message code="system.label.sales.item" default="품목"/>',
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
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
				}
			}
		})]
	});

	/** Master Grid1 정의(Grid Panel)
	 * @type
	 */
	var masterGrid = Unilite.createGrid('sof210skrvGrid1', {
		store	: directMasterStore1,
		layout	: 'fit',
		region	: 'center',
		features: [ {id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false },
					{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false} ],
		columns:  [
			{dataIndex: 'COMP_CODE'			,width: 120	,hidden: true},
			{dataIndex: 'DIV_CODE'			,width: 120	,hidden: true},
			{dataIndex: 'SALE_CUSTOM_CODE'	,width: 100},
			{dataIndex: 'SALE_CUSTOM_NAME'	,width: 150},
			{dataIndex: 'MODEL_COL'				,width: 120},
			{dataIndex: 'PROD_ITEM_CODE'	,width: 120},
			{dataIndex: 'PROD_ITEM_NAME'	,width: 250},
			{dataIndex: 'ORDER_Q'			,width: 80},
			{dataIndex: 'ORDER_DATE'		,width: 80},
			{dataIndex: 'INSERT_DATE'		,width: 80},
			{dataIndex: 'DVRY_DATE'			,width: 80},
			{dataIndex: 'ORDER_NUM'			,width: 110},
			{dataIndex: 'SER_NO'			,width: 66	,align: 'center'},
			{dataIndex: 'LEVEL_COL'				,width: 80	,align: 'center'},
			{dataIndex: 'ITEM_ACCOUNT'		,width: 100	,align: 'center'},
			{dataIndex: 'ITEM_LEVEL_COL'		,width: 200,
				renderer:function(value){
					return '<div style="white-space: pre;">'+(value ? value:'&nbsp;')+'</div>';
				}
			},
			{dataIndex: 'ITEM_CODE'			,width: 120},
			{dataIndex: 'ITEM_NAME'			,width: 250},
			{dataIndex: 'SPEC'				,width: 150},
			{dataIndex: 'STOCK_UNIT'		,width: 80	,align: 'center'},
			{dataIndex: 'CUSTOM_CODE'		,width: 100},
			{dataIndex: 'CUSTOM_NAME'		,width: 150},
			{dataIndex: 'UNIT_Q'			,width: 80},
			{dataIndex: 'PROD_UNIT_Q'		,width: 80},
			{dataIndex: 'LOSS_RATE'			,width: 80},
			{dataIndex: 'NEED_Q'			,width: 80},
			{dataIndex: 'EQU_CODE'		,width: 100},
			{dataIndex: 'EQU_NAME'		,width: 150}
			
		]
	});



	Unilite.Main({
		id			: 'sof210skrvApp',
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
			panelSearch.setValue('DIV_CODE'		, UserInfo.divCode);
			panelSearch.setValue('ORDER_DATE_FR', UniDate.get('startOfMonth'));
			panelSearch.setValue('ORDER_DATE_TO', UniDate.get('today'));
			//20200921 추가: 조회조건 등록일 추가
			panelSearch.setValue('INSERT_DATE_FR', UniDate.get('startOfMonth'));
			panelSearch.setValue('INSERT_DATE_TO', UniDate.get('today'));

			panelResult.setValue('DIV_CODE'		, UserInfo.divCode);
			panelResult.setValue('ORDER_DATE_FR', UniDate.get('startOfMonth'));
			panelResult.setValue('ORDER_DATE_TO', UniDate.get('today'));
			//20200921 추가: 조회조건 등록일 추가
			panelResult.setValue('INSERT_DATE_FR', UniDate.get('startOfMonth'));
			panelResult.setValue('INSERT_DATE_TO', UniDate.get('today'));
		},
		onQueryButtonDown : function() {
			if(!this.isValidSearchForm()){
				return false;
			}
			directMasterStore1.loadStoreRecords();
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			directMasterStore1.loadData({});
			this.fnInitBinding();
		}
	});
};
</script>