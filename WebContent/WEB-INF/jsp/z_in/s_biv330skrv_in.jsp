<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_biv330skrv_in"  >
	<t:ExtComboStore comboType="BOR120"  pgmId="s_biv330skrv_in" />	<!-- 사업장 -->
    <t:ExtComboStore comboType="AU" comboCode="B055" />			<!-- 고객분류 -->
    <t:ExtComboStore comboType="AU" comboCode="S010" />			<!-- 영업담당 -->
</t:appConfig>
<style type="text/css">
.x-change-cell {
background-color: #FFFFC6;
}
.x-change-cell2 {
background-color: #FDE3FF;
}
</style>

<script type="text/javascript" >
function appMain() {

	/** Model 정의
	 * @type
	 */
	Unilite.defineModel('s_biv330skrv_inModel', {
		fields: [
			{name: 'COMP_CODE',		text:'COMP_CODE',	type:'string'},
			{name: 'DIV_CODE',		text:'DIV_CODE',	type:'string'},
			{name: 'BASIS_YYYYMM',	text:'<t:message code="system.label.inventory.tranyearmonth" default="수불년월"/>',		type:'string'},
			{name: 'ITEM_CODE',		text:'<t:message code="system.label.inventory.item" default="품목"/>',				type:'string'},
			{name: 'ITEM_NAME',		text:'<t:message code="system.label.inventory.itemname" default="품목명"/>',			type:'string'},
			{name: 'SPEC',			text:'<t:message code="system.label.inventory.spec" default="규격"/>',				type:'string'},

			{name: 'BASIS_Q',		text:'기초',			type:'uniQty'},
			{name: 'IN_Q1',			text:'정상입고',		type:'uniQty'},
			{name: 'IN_Q1_2',		text:'정상입고(기타)',		type:'uniQty'},
			{name: 'IN_Q2',			text:'반품입고',		type:'uniQty'},
			{name: 'IN_Q4',			text:'포장입고',		type:'uniQty'},
			{name: 'IN_REP_Q',		text:'타계정입고',		type:'uniQty'},
			{name: 'IN_Q3',			text:'기타입고',		type:'uniQty'},
			{name: 'IN_TOT_Q',		text:'입고합계',		type:'uniQty'},
			{name: 'OUT_Q1',		text:'정상출고',		type:'uniQty'},
			{name: 'OUT_Q2',		text:'QC/자가사용출고',	type:'uniQty'},
			{name: 'OUT_Q3',		text:'불량폐기출고',		type:'uniQty'},
			{name: 'OUT_Q4',		text:'생산불량출고',		type:'uniQty'},
			{name: 'OUT_Q5',		text:'포장출고',		type:'uniQty'},
			{name: 'OUT_REP_Q',		text:'타계정출고',		type:'uniQty'},
			{name: 'OUT_Q6',		text:'기타출고',		type:'uniQty'},
			{name: 'OUT_TOT_Q',		text:'출고합계',		type:'uniQty'},
			{name: 'STOCK_Q',		text:'재고',			type:'uniQty'},

			{name: 'BASIS_AMT',		text:'기초',			type:'uniPrice'},
			{name: 'IN_AMT1',		text:'정상입고',		type:'uniPrice'},
			{name: 'IN_AMT1_2',		text:'정상입고(기타)',	type:'uniPrice'},
			{name: 'IN_AMT2',		text:'반품입고',		type:'uniPrice'},
			{name: 'IN_AMT4',		text:'포장입고',		type:'uniPrice'},
			{name: 'IN_REP_AMT',	text:'타계정입고',		type:'uniPrice'},
			{name: 'IN_AMT3',		text:'기타입고',		type:'uniPrice'},
			{name: 'IN_TOT_AMT',	text:'입고합계',		type:'uniPrice'},
			{name: 'OUT_AMT1',		text:'정상출고',		type:'uniPrice'},
			{name: 'OUT_AMT2',		text:'QC/자가사용출고',	type:'uniPrice'},
			{name: 'OUT_AMT3',		text:'불량폐기출고',		type:'uniPrice'},
			{name: 'OUT_AMT4',		text:'생산불량출고',		type:'uniPrice'},
			{name: 'OUT_AMT5',		text:'포장출고',		type:'uniPrice'},
			{name: 'OUT_REP_AMT',	text:'타계정출고',		type:'uniPrice'},
			{name: 'OUT_AMT6',		text:'기타출고',		type:'uniPrice'},
			{name: 'OUT_TOT_AMT',	text:'출고합계',		type:'uniPrice'},
			{name: 'AVERAGE_P',		text:'재고단가',		type:'uniUnitPrice'},
			{name: 'STOCK_AMT',		text:'재고',			type:'uniPrice'}
		]
	});



	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore = Unilite.createStore('s_biv330skrv_inMasterStore1',{
		model	: 's_biv330skrv_inModel',
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
				read: 's_biv330skrv_inService.selectList'
			}
		},
		loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params: param
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
//				if(!Ext.isEmpty(records)){
//				}
			},
			write: function(proxy, operation){
			},
			update:function( store, record, operation, modifiedFieldNames, eOpts ) {
			},
			remove: function( store, records, index, isMove, eOpts ) {
			}
		}/*,
		groupField: 'AGENT_TYPE'*/
	});



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
				xtype: 'container',
				layout: {type: 'uniTable', columns: 1},
				items: [{
					fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>',
					name		: 'DIV_CODE',
					xtype		: 'uniCombobox',
					comboType	: 'BOR120',
					value		: UserInfo.divCode,
					allowBlank	: false,
					listeners	: {
						change: function(combo, newValue, oldValue, eOpts) {
							panelResult.setValue('DIV_CODE', newValue);
						}
					}
				},{
					fieldLabel	: '<t:message code="system.label.inventory.account" default="계정"/>',
					name		: 'ITEM_ACCOUNT',
					xtype		: 'uniCombobox',
					comboType	: 'AU',
					comboCode	: 'B020',
					allowBlank	: false,
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('ITEM_ACCOUNT', newValue);
						}
					}
				},{
					fieldLabel	: '<t:message code="system.label.inventory.tranyearmonth" default="수불년월"/>',
					name		: 'BASIS_YYYYMM',
					xtype		: 'uniMonthfield',
					allowBlank	: false,
					listeners	: {
						change: function(combo, newValue, oldValue, eOpts) {
							panelResult.setValue('BASIS_YYYYMM', newValue);
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
			fieldLabel	: '<t:message code="system.label.inventory.account" default="계정"/>',
			name		: 'ITEM_ACCOUNT',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B020',
			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('ITEM_ACCOUNT', newValue);
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.inventory.tranyearmonth" default="수불년월"/>',
			name		: 'BASIS_YYYYMM',
			xtype		: 'uniMonthfield',
			allowBlank	: false,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					panelSearch.setValue('BASIS_YYYYMM', newValue);
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
	var masterGrid = Unilite.createGrid('s_biv330skrv_inGrid', {
		store	: directMasterStore,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {useRowNumberer: true},
		selModel: 'rowmodel',
		features: [ {id: 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
		 			{id: 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: true}],
		columns: [
//			{dataIndex: 'COMP_CODE',	width: 73},
//			{dataIndex: 'DIV_CODE',		width: 73},
			{dataIndex: 'BASIS_YYYYMM',	width: 100, hidden: true},
			{dataIndex: 'ITEM_CODE',	width: 100,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '', '총계');
				}
			},
			{dataIndex: 'ITEM_NAME',	width: 200},
			{dataIndex: 'SPEC',			width: 200},
			{text:'수량',
				columns: [
					{dataIndex: 'BASIS_Q'		, width: 110	,summaryType: 'sum' },
					{dataIndex: 'IN_Q1'			, width: 110	,summaryType: 'sum' },
					{dataIndex: 'IN_Q1_2'		, width: 110	,summaryType: 'sum' },
					{dataIndex: 'IN_Q2'			, width: 110	,summaryType: 'sum' },
					{dataIndex: 'IN_Q4'			, width: 110	,summaryType: 'sum' },					
					{dataIndex: 'IN_REP_Q'		, width: 110	,summaryType: 'sum' },
					{dataIndex: 'IN_Q3'			, width: 110	,summaryType: 'sum' },
					{dataIndex: 'IN_TOT_Q'		, width: 110	,summaryType: 'sum', hidden:true },
					{dataIndex: 'OUT_Q1'		, width: 110	,summaryType: 'sum' },
					{dataIndex: 'OUT_Q2'		, width: 110	,summaryType: 'sum' },
					{dataIndex: 'OUT_Q3'		, width: 110	,summaryType: 'sum' },
					{dataIndex: 'OUT_Q4'		, width: 110	,summaryType: 'sum' },
					{dataIndex: 'OUT_Q5'		, width: 110	,summaryType: 'sum' },
					{dataIndex: 'OUT_REP_Q'		, width: 110	,summaryType: 'sum' },
					{dataIndex: 'OUT_Q6'		, width: 110	,summaryType: 'sum' },
					{dataIndex: 'OUT_TOT_Q'		, width: 110	,summaryType: 'sum', hidden:true },
					{dataIndex: 'STOCK_Q'		, width: 110	,summaryType: 'sum' }
				]
			},
			{ text:'금액',
				columns: [
					{dataIndex: 'BASIS_AMT'		, width: 110	,summaryType: 'sum' },
					{dataIndex: 'IN_AMT1'		, width: 110	,summaryType: 'sum' },
					{dataIndex: 'IN_AMT1_2'		, width: 110	,summaryType: 'sum' },
					{dataIndex: 'IN_AMT2'		, width: 110	,summaryType: 'sum' },
					{dataIndex: 'IN_AMT4'		, width: 110	,summaryType: 'sum' },
					{dataIndex: 'IN_REP_AMT'	, width: 110	,summaryType: 'sum' },
					{dataIndex: 'IN_AMT3'		, width: 110	,summaryType: 'sum' },					
					{dataIndex: 'IN_TOT_AMT'	, width: 110	,summaryType: 'sum', hidden:true },
					{dataIndex: 'OUT_AMT1'		, width: 110	,summaryType: 'sum' },
					{dataIndex: 'OUT_AMT2'		, width: 110	,summaryType: 'sum' },
					{dataIndex: 'OUT_AMT3'		, width: 110	,summaryType: 'sum' },
					{dataIndex: 'OUT_AMT4'		, width: 110	,summaryType: 'sum' },
					{dataIndex: 'OUT_AMT5'		, width: 110	,summaryType: 'sum' },
					{dataIndex: 'OUT_REP_AMT'	, width: 110	,summaryType: 'sum' },
					{dataIndex: 'OUT_AMT6'		, width: 110	,summaryType: 'sum' },
					{dataIndex: 'OUT_TOT_AMT'	, width: 110	,summaryType: 'sum', hidden:true },
					{dataIndex: 'AVERAGE_P'		, width: 110 },
					{dataIndex: 'STOCK_AMT'		, width: 110	,summaryType: 'sum' }
				]
			}
		], 
		listeners: {
//			selectionChange: function( gird, selected, eOpts )	{
			select: function(grid, selected, index, rowIndex, eOpts ){
			}
		}/*,//20190911 안 이뻐서 일단 대기
		viewConfig: {
			getRowClass: function(record, rowIndex, rowParams, store){
				var cls = '';
				if(record.get('GUBUN') == '06') {
					cls = 'x-change-cell_dark';
				} else if(record.get('GUBUN') == '04'){
					cls = 'x-change-cell_normal';
				}
				return cls;
			}
		}*/
	});



	Unilite.Main({
		id			: 's_biv330skrv_inApp',
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
		fnInitBinding: function(params) {
			panelSearch.setValue('DIV_CODE'		, UserInfo.divCode);
			panelResult.setValue('DIV_CODE'		, UserInfo.divCode);
//			panelSearch.setValue('ITEM_ACCOUNT'	, '');
//			panelResult.setValue('ITEM_ACCOUNT'	, '');
			panelSearch.setValue('BASIS_YYYYMM'	, UniDate.get('today'));
			panelResult.setValue('BASIS_YYYYMM'	, UniDate.get('today'));
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.getStore().loadData({})
			this.fnInitBinding();
		},
		onQueryButtonDown: function() {
			if(!this.isValidSearchForm()){
				return false;
			}
			masterGrid.getStore().loadStoreRecords();
		}
	});
};
</script>