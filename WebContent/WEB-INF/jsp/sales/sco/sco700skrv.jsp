<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="sco700skrv"  >
	<t:ExtComboStore comboType="BOR120"  pgmId="sco700skrv" />	<!-- 사업장 -->
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
	/** 구분 컬럼 스토어 생성 - 20190911 추가
	 */
	var gubunStore = Unilite.createStore('gubunStore',{
		fields	: ['text','value'],
		data	: [{
			text	: '',
			value	: '01'
		},{
			text	: '발행',
			value	: '02'
		},{
			text	: '수금',
			value	: '03'
		},{
			text	: '',
			value	: '04'
		},{
			text	: '미발행',
			value	: '05'
		},{
			text	: '합계',
			value	: '06'
		}]
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

							combo.changeDivCode(combo, newValue, oldValue, eOpts);
							var field = panelResult.getField('BUSI_PRSN');
							field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);
						}
					}
				},{
					fieldLabel		: '<t:message code="system.label.sales.inquiryperiod" default="조회기간"/>',
					xtype			: 'uniDateRangefield',
					startFieldName	: 'FrDate',
					endFieldName	: 'ToDate',
					allowBlank		: false,
					startDate		: UniDate.get('startOfMonth'),
					endDate			: UniDate.get('today'),
					onStartDateChange: function(field, newValue, oldValue, eOpts) {
						if(panelResult) {
							panelResult.setValue('FrDate', newValue);
						}
					},
					onEndDateChange: function(field, newValue, oldValue, eOpts) {
						if(panelResult) {
							panelResult.setValue('ToDate', newValue);
						}
					}
				},{
					fieldLabel	: '<t:message code="system.label.sales.clienttype" default="고객분류"/>',
					name		: 'AGENT_TYPE',
					xtype		: 'uniCombobox',
					comboType	: 'AU',
					comboCode	: 'B055',
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('AGENT_TYPE', newValue);
						}
					}
				},{
					fieldLabel	: '<t:message code="system.label.sales.salescharge" default="영업담당"/>',
					name		: 'BUSI_PRSN',
					xtype		: 'uniCombobox',
					comboType	: 'AU',
					comboCode	: 'S010',
					onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
						if(eOpts){
							combo.filterByRefCode('refCode1', newValue, eOpts.parent);
						} else {
							combo.divFilterByRefCode('refCode1', newValue, divCode);
						}
					},
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('BUSI_PRSN', newValue);
						}
					}
				},
				Unilite.popup('AGENT_CUST',{
					fieldLabel		: '<t:message code="system.label.sales.custom" default="거래처"/>',
					validateBlank	: false,
					listeners		: {
						onValueFieldChange: function(field, newValue){
							panelResult.setValue('CUSTOM_CODE', newValue);
						},
						onTextFieldChange: function(field, newValue){
							panelResult.setValue('CUSTOM_NAME', newValue);
//						},
//						onSelected: {
//							fn: function(records, type) {
//								panelResult.setValue('CUSTOM_CODE', panelSearch.getValue('CUSTOM_CODE'));
//								panelResult.setValue('CUSTOM_NAME', panelSearch.getValue('CUSTOM_NAME'));
//							},
//							scope: this
//						},
//						onClear: function(type) {
//							panelResult.setValue('CUSTOM_CODE', '');
//							panelResult.setValue('CUSTOM_NAME', '');
						}
					}
				})]
			}]
		}],
		setAllFieldsReadOnly: function(b) {
			var r= true
			if(b) {
				var invalid = this.getForm().getFields().filterBy(function(field) {
					return !field.validate();
				});
				if(invalid.length > 0) {
					var labelText = ''
					r = false;
					if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
						var labelText = invalid.items[0]['fieldLabel']+' : ';
					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
						var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
					}
					Unilite.messageBox(labelText+'<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
					invalid.items[0].focus();
				}
			}
			return r;
		}
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

					combo.changeDivCode(combo, newValue, oldValue, eOpts);
					var field = panelSearch.getField('BUSI_PRSN');
					field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);
				}
			}
		},{
			fieldLabel		: '<t:message code="system.label.sales.inquiryperiod" default="조회기간"/>',
			xtype			: 'uniDateRangefield',
			allowBlank		: false,
			startFieldName	: 'FrDate',
			endFieldName	: 'ToDate',
			startDate		: UniDate.get('startOfMonth'),
			endDate			: UniDate.get('today'),
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('FrDate', newValue);
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('ToDate', newValue);
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.clienttype" default="고객분류"/>',
			name		: 'AGENT_TYPE',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B055',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('AGENT_TYPE', newValue);
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.salescharge" default="영업담당"/>',
			name		: 'BUSI_PRSN',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'S010',
			onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
				if(eOpts){
					combo.filterByRefCode('refCode1', newValue, eOpts.parent);
				} else {
					combo.divFilterByRefCode('refCode1', newValue, divCode);
				}
			},
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('BUSI_PRSN', newValue);
				}
			}
		},
		Unilite.popup('AGENT_CUST',{
			fieldLabel		: '<t:message code="system.label.sales.custom" default="거래처"/>',
			validateBlank	: false,
			listeners		: {
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('CUSTOM_CODE', newValue);
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('CUSTOM_NAME', newValue);
//				},
//				onSelected: {
//					fn: function(records, type) {
//						panelSearch.setValue('CUSTOM_CODE', panelResult.getValue('CUSTOM_CODE'));
//						panelSearch.setValue('CUSTOM_NAME', panelResult.getValue('CUSTOM_NAME'));
//					},
//					scope: this
//				},
//				onClear: function(type) {
//					panelSearch.setValue('CUSTOM_CODE', '');
//					panelSearch.setValue('CUSTOM_NAME', '');
				}
			}
		})]
	});



	/** Model 정의
	 * @type
	 */
	Unilite.defineModel('sco700skrvModel', {
		fields: [
			{name: 'COMP_CODE'				, text: 'COMP_CODE'	,type:'string'},
			{name: 'DIV_CODE'				, text: '<t:message code="system.label.sales.division" default="사업장"/>'						, type: 'string', comboType: 'BOR120'},
			{name: 'AGENT_TYPE'				, text: '<t:message code="system.label.sales.clienttype" default="고객분류"/>'					, type: 'string', comboType:'AU',comboCode:'B055'},
			{name: 'CUSTOM_CODE'			, text: '<t:message code="system.label.sales.custom" default="거래처"/>'						, type: 'string'},
			{name: 'CUSTOM_NAME'			, text: '<t:message code="system.label.sales.customname" default="거래처명"/>'					, type: 'string'},
			{name: 'BUSI_PRSN'				, text: '<t:message code="system.label.sales.salescharge" default="영업담당"/>'					, type: 'string', comboType:'AU', comboCode:'S010'},
			{name: 'CARRY_OVER_AMT'			, text: '<t:message code="system.label.sales.carryoveramount" default="이월금액"/>'				, type: 'uniPrice'},
			{name: 'PERIOD_ISSUE_AMT'		, text: '<t:message code="system.label.sales.periodissueamount" default="기간내발행금액"/>'		, type: 'uniPrice'},
			{name: 'DEPOSIT_AMT'			, text: '<t:message code="system.label.sales.depositamount" default="입금액"/>'				, type: 'uniPrice'},
			{name: 'CARD_AMT'			    , text: '카드매출'					, type: 'uniPrice'},
			{name: 'BALANCE_AMT'			, text: '<t:message code="system.label.sales.balanceamount3" default="잔액(VAT포함)"/>'			, type: 'uniPrice'},
			{name: 'CARRYOVER_UNISSUED_AMT'	, text: '<t:message code="system.label.sales.carryoverunissuedamount" default="이월미발행금액"/>'	, type: 'uniPrice'},
			{name: 'CARRYOVER_NONISSUED_VAT', text: '<t:message code="system.label.sales.carryovernonissuedVAT" default="이월미발행VAT"/>'	, type: 'uniPrice'},
			{name: 'PERIOD_UNISSUED_AMT'	, text: '<t:message code="system.label.sales.periodunissuedamount" default="기간내미발행금액"/>'	, type: 'uniPrice'},
			{name: 'PERIOD_NOTISSUED_VAT'	, text: '<t:message code="system.label.sales.periodnotissuedVAT" default="기간내미발행VAT"/>'		, type: 'uniPrice'},
			{name: 'TOTAL_BALANCE'			, text: '<t:message code="system.label.sales.totalbalance" default="총잔액"/>'					, type: 'uniPrice'}
		]
	});

	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore = Unilite.createStore('sco700skrvMasterStore1',{
		model	: 'sco700skrvModel',
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
				read: 'sco700skrvService.selectList'
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
//					Ext.each(records, function(record, i){
//						//20190911 로직 추가 - 월합계의 경우 이전 행의 미수잔액을 그대로 보여 줌
//						if(record.get('GUBUN') == '04') {
//							var preRecord = store.getAt(i-1);		//대상행의 이전 행
//							record.set('BALANCE_AMT', preRecord.get('BALANCE_AMT'));
//						}
//						//20190911 로직 추가 - 미발행의 경우 이전행의 미수잔액에 미발행된 매출액을 더해서 미수잔액을 표기
//						if(record.get('GUBUN') == '05') {
//							var preRecord = store.getAt(i-1);		//대상행의 이전 행
//							record.set('BALANCE_AMT', preRecord.get('BALANCE_AMT') + record.get('SALE_AMT') - record.get('COLLECT_AMT'));
//						}
//						//20190911 로직 추가 - 합계의 경우 이전행의 미수잔액을 표시 
//						if(record.get('GUBUN') == '06') {
//							var preRecord = store.getAt(i-1);		//대상행의 이전 행
//							record.set('BALANCE_AMT', preRecord.get('BALANCE_AMT'));
//						}
//					});
//					this.commitChanges();
//				}
			},
			write: function(proxy, operation){
			},
			update:function( store, record, operation, modifiedFieldNames, eOpts ) {
			},
			remove: function( store, records, index, isMove, eOpts ) {
			}
		},
		groupField: 'AGENT_TYPE'
	});

	/** Master Grid1 정의(Grid Panel)
	 * @type
	 */
	var masterGrid = Unilite.createGrid('sco700skrvGrid', {
		store	: directMasterStore,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {useRowNumberer: true},
		selModel: 'rowmodel',
		features: [ {id: 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: true},
		 			{id: 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: true}],
		columns: [
			{ dataIndex: 'COMP_CODE'				, width: 120	, hidden: true},
			{ dataIndex: 'DIV_CODE'					, width: 133	, hidden: true},
			{ dataIndex: 'AGENT_TYPE'				, width: 100	, align: 'center',
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '', '총계');
				}
			},
			{ dataIndex: 'CUSTOM_CODE'				, width: 133,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, 'OEM계', '');
				}
			},
			{ dataIndex: 'CUSTOM_NAME'				, width: 200},
			{ dataIndex: 'BUSI_PRSN'				, width: 100	, align: 'center'},
			{ dataIndex: 'CARRY_OVER_AMT'			, width: 120	, summaryType: 'sum'},
			{ dataIndex: 'PERIOD_ISSUE_AMT'			, width: 120	, summaryType: 'sum'},
			{ dataIndex: 'DEPOSIT_AMT'				, width: 120	, summaryType: 'sum'},
			{ dataIndex: 'CARD_AMT'					, width: 120	, summaryType: 'sum'},
			{ dataIndex: 'BALANCE_AMT'				, width: 120	, summaryType: 'sum'	, tdCls:'x-change-cell'},
			{ dataIndex: 'CARRYOVER_UNISSUED_AMT'	, width: 120	, summaryType: 'sum'},
			{ dataIndex: 'CARRYOVER_NONISSUED_VAT'	, width: 120	, summaryType: 'sum'},
			{ dataIndex: 'PERIOD_UNISSUED_AMT'		, width: 120	, summaryType: 'sum'},
			{ dataIndex: 'PERIOD_NOTISSUED_VAT'		, width: 120	, summaryType: 'sum'},
			{ dataIndex: 'TOTAL_BALANCE'			, width: 120	, summaryType: 'sum'	, tdCls:'x-change-cell'}
		], 
		listeners: {
			//20210527 추가: 마우스오른쪽 버튼 링크기능 추가
			itemmouseenter:function(view, record, item, index, e, eOpts ) {
				view.ownerGrid.setCellPointer(view, item);
			},
			select: function(grid, selected, index, rowIndex, eOpts ){
			}
		},
		//20210527 추가: 마우스오른쪽 버튼 링크기능 추가
		onItemcontextmenu:function( menu, grid, record, item, index, event, e, eOpts ) {
			menu.down('#gsLinkPgID1').show();
			return true;
		},
		uniRowContextMenu:{
			items: [{
				text	: '거래처별원장(매입/매출)',
				itemId	: 'gsLinkPgID1',
				handler	: function(menuItem, event) {
					var param = menuItem.up('menu');
					masterGrid.gotoSsa615skrv(param.record);
				}
			}]
		},
		gotoSsa615skrv:function(record) {
			if(record) {
				var params		= {
					action			: 'select',
					'PGM_ID'		: PGM_ID,
					'DIV_CODE'		: panelResult.getValue('DIV_CODE'),
					'FrDate'		: panelResult.getValue('FrDate'),
					'ToDate'		: panelResult.getValue('ToDate'),
					'CUSTOM_CODE'	: record.get('CUSTOM_CODE'),
					'CUSTOM_NAME'	: record.get('CUSTOM_NAME')
				}
				var rec1= {data: {prgID: 'ssa615skrv', 'text': ''}};
				parent.openTab(rec1, '/sales/ssa615skrv.do', params, CHOST + CPATH);
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
		id			: 'sco700skrvApp',
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
			panelSearch.setValue('DIV_CODE'	, UserInfo.divCode);
			panelResult.setValue('DIV_CODE'	, UserInfo.divCode);
			panelSearch.setValue('FrDate'	, UniDate.get('startOfMonth'));
			panelResult.setValue('FrDate'	, UniDate.get('startOfMonth'));
			panelSearch.setValue('ToDate'	, UniDate.get('today'));
			panelResult.setValue('ToDate'	, UniDate.get('today'));
			
			var pCombo	= panelSearch.getField('DIV_CODE');
			var combo	= panelSearch.getField('BUSI_PRSN').filterByRefCode('refCode1', pCombo.getValue(), pCombo);

			var field = panelSearch.getField('BUSI_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
			var field = panelResult.getField('BUSI_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.getStore().loadData({})
			this.fnInitBinding();
		},
		onQueryButtonDown: function() {
			if(!panelSearch.setAllFieldsReadOnly(true)){
				return false;
			}
			masterGrid.getStore().loadStoreRecords();
		}
	});
};
</script>