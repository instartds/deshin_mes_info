<%--
'   프로그램명 : 거래처별 입고금액 (man120skrv)
'   작   성   자 : 시너지시스템즈개발실
'   작   성   일 : 2020.03.12
'   최종수정자 :
'   최종수정일 :
'   버	  전 : OMEGA Plus V6.0.0
--%>
<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="man120skrv" >
	<t:ExtComboStore comboType="BOR120" pgmId="man120skrv"/>	<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B020"/>			<!-- 품목계정-->
	<t:ExtComboStore comboType="AU" comboCode="B042"/>			<!-- 금액단위-->
</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>

<script type="text/javascript" >


function appMain() {
	/** 검색조건 (Search Panel)
	 * @type
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title		: '<t:message code="system.label.purchase.searchconditon" default="검색조건"/>',
		defaultType	: 'uniSearchSubPanel',
		collapsed	: true,
		listeners	: {
			collapse: function () {
				panelResult.show();
			},
			expand: function() {
				panelResult.hide();
			}
		},
		items: [{
			title		: '<t:message code="system.label.purchase.basisinfo" default="기본정보"/>',
			itemId		: 'search_panel1',
			layout		: {type: 'uniTable', columns: 1},
			defaultType	: 'uniTextfield',
			items		: [{
				fieldLabel	: '<t:message code="system.label.purchase.division" default="사업장"/>',
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
				fieldLabel	: '<t:message code="system.label.purchase.basisyearmonth" default="기준년월"/>', 
				fieldStyle	: 'text-align:center;', 
				name		: 'BASIS_YYYYMM', 
				xtype		: 'uniMonthfield', 
				allowBlank	: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('BASIS_YYYYMM', newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.purchase.potype" default="발주형태"/>',
				xtype		: 'radiogroup',
				items		: [{
					boxLabel: '내자',
					name	: 'ORDER_FLAG',
					width	: 53,
					inputValue: '1'
				},{	//20200331 변경: 외주 -> 외자
					boxLabel: '외자',
					name	: 'ORDER_FLAG',
					width	: 53,
					inputValue: '2'
				}],
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.getField('ORDER_FLAG').setValue(newValue.ORDER_FLAG);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.sales.amountunit" default="금액단위"/>',
				name		: 'AMOUNT_UNIT',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'B042',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('AMOUNT_UNIT', newValue);
					}
				}
			}]
		}]
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		layout	: {type : 'uniTable', columns : 4},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel	: '<t:message code="system.label.purchase.division" default="사업장"/>',
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
			fieldLabel	: '<t:message code="system.label.purchase.basisyearmonth" default="기준년월"/>', 
			fieldStyle	: 'text-align:center;', 
			name		: 'BASIS_YYYYMM', 
			xtype		: 'uniMonthfield', 
			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('BASIS_YYYYMM', newValue);
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.purchase.potype" default="발주형태"/>',
			xtype		: 'radiogroup',
			items		: [{
				boxLabel: '내자',
				name	: 'ORDER_FLAG',
				width	: 53,
				inputValue: '1'
			},{	//20200331 변경: 외주 -> 외자
				boxLabel: '외자',
				name	: 'ORDER_FLAG',
				width	: 53,
				inputValue: '2'
			}],
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.getField('ORDER_FLAG').setValue(newValue.ORDER_FLAG);
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.amountunit" default="금액단위"/>',
			name		: 'AMOUNT_UNIT',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B042',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('AMOUNT_UNIT', newValue);
				}
			}
		}]
	});



	/** Model 정의 
	 * @type
	 */
	Unilite.defineModel('man120skrvModel', {
		fields: [
			{name: 'EX_NUM'			, text: '<t:message code="system.label.purchase.number" default="번호"/>'						, type: 'string'},
			{name: 'OCCUR_DATE'		, text: '<t:message code="system.label.base.caldate" default="발생일자"/>'						, type: 'uniDate'},
			{name: 'CUSTOM_CODE'	, text: '<t:message code="system.label.purchase.customcode" default="거래처코드"/>'				, type: 'string'},
			{name: 'CUSTOM_NAME'	, text: '<t:message code="system.label.purchase.customname" default="거래처명"/>'				, type: 'string'},
			{name: 'CHARGE_NAME'	, text: '비용명'		, type: 'string'},
			{name: 'AMT_UNIT'		, text: '환종'		, type: 'string'},
			{name: 'FOR_AMT'		, text: '<t:message code="system.label.purchase.foreigncurrencyamount" default="외화금액"/>'	, type: 'uniFC'},
			{name: 'EXCHANGE_RATE'	, text: '<t:message code="system.label.purchase.exchangerate" default="환율"/>'				, type: 'uniER'},
			{name: 'SUPP_AMT'		, text: '<t:message code="system.label.purchase.supplyamount" default="공급가액"/>'				, type:'uniPrice'},
			{name: 'TAX_AMT'		, text: '<t:message code="system.label.purchase.vatamount" default="부가세액"/>'				, type:'uniPrice'},
			{name: 'TOT_AMT'		, text: '<t:message code="system.label.purchase.totalamount" default="합계"/>'				, type:'uniPrice'},
			{name: 'INVOICE_DATE'	, text: 'Inv. Date'	, type: 'uniDate'},
			{name: 'IN_STATUS'		, text: '입고여부'		, type: 'string' /*,comboType: 'AU' ,comboCode: 'B010'*/},
			{name: 'BL_NO'			, text: '<t:message code="system.label.purchase.blno" default="B/L번호"/>'					, type: 'string'},
			{name: 'BL_SER_NO'		, text: '<t:message code="system.label.trade.blmanageno" default="B/L관리번호"/>'				, type: 'string'},
			{name: 'SO_SER_NO'		, text: '<t:message code="system.label.trade.somanageno" default="S/O관리번호"/>'				, type: 'string'}
		]
	});

	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore = Unilite.createStore('man120skrvMasterStore1', {
		model	: 'man120skrvModel',
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결 
			editable	: false,	// 수정 모드 사용 
			deletable	: false,	// 삭제 가능 여부 
			useNavi		: false		// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy	: {
			type: 'direct',
			api	: {
				read: 'man120skrvService.selectList'
			}
		},
		loadStoreRecords: function(){
			var param			= Ext.getCmp('searchForm').getValues();
			param.MONEY_UNIT	= UserInfo.currency; 
			console.log( param );
			this.load({
				params	: param,
				callback: function(records,options,success) {
					if(success) {
					}
				}
			});	
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
			},
			add: function(store, records, index, eOpts) {
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
			},
			remove: function(store, record, index, isMove, eOpts) {
			}
		},
		//20200331 추가: BL_NO
		groupField: 'BL_NO'
	});


	/** Grid 정의(Grid Panel)
	 * @type
	 */
	var masterGrid = Unilite.createGrid('man120skrvGrid1', {
		store	: directMasterStore,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			useGroupSummary		: false,
			useLiveSearch		: true,
			useContextMenu		: false,
			useMultipleSorting	: true,
			useRowNumberer		: true,
			expandLastColumn	: true,
			onLoadSelectFirst	: false,
			filter				: {
				useFilter	: false,
				autoCreate	: false
			}
		},
		features: [ 
			{id: 'masterGridSubTotal1'	, ftype: 'uniGroupingsummary'	, showSummaryRow: true},
			{id: 'masterGridTotal1'		, ftype: 'uniSummary'			, showSummaryRow: true}
		],
		selModel: 'rowmodel',
		columns	: [
			{dataIndex: 'COMP_CODE'		, width: 100, hidden: true},
			{dataIndex: 'DIV_CODE'		, width: 100, hidden: true},
			{dataIndex: 'EX_NUM'		, width: 80	, hidden: true},
			{dataIndex: 'OCCUR_DATE'	, width: 80	, align: 'center',
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.sales.subtotal" default="소계"/>', '<t:message code="system.label.sales.total" default="총계"/>');
				}
			},
			{dataIndex: 'CUSTOM_CODE'	, width: 120},
			{dataIndex: 'CUSTOM_NAME'	, width: 150},
			{dataIndex: 'CHARGE_NAME'	, width: 100},
			{dataIndex: 'AMT_UNIT'		, width: 80	, align: 'center'},
			{dataIndex: 'FOR_AMT'		, width: 100},
			{dataIndex: 'EXCHANGE_RATE'	, width: 100},
			{dataIndex: 'SUPP_AMT'		, width: 100, summaryType: 'sum'},
			{dataIndex: 'TAX_AMT'		, width: 100, summaryType: 'sum'},
			{dataIndex: 'TOT_AMT'		, width: 100, summaryType: 'sum'},
			{dataIndex: 'INVOICE_DATE'	, width: 90},
			{dataIndex: 'IN_STATUS'		, width: 80},
			{dataIndex: 'BL_NO'			, width: 110},
			{dataIndex: 'BL_SER_NO'		, width: 110, hidden: true},
			{dataIndex: 'SO_SER_NO'		, width: 110, hidden: true}
		],
		listeners:{
		}
	});



	Unilite.Main({
		id			: 'man120skrvApp',
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
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE'		, UserInfo.divCode);
			panelSearch.setValue('BASIS_YYYYMM'	, UniDate.get('startOfMonth'));
			panelSearch.getField('ORDER_FLAG').setValue('1');
			panelSearch.setValue('AMOUNT_UNIT'	, '1');					//20200331 변경: 2 -> 1

			panelResult.setValue('DIV_CODE'		, UserInfo.divCode);
			panelResult.setValue('BASIS_YYYYMM'	, UniDate.get('startOfMonth'));
			panelResult.getField('ORDER_FLAG').setValue('1');
			panelResult.setValue('AMOUNT_UNIT'	, '1');					//20200331 변경: 2 -> 1

			//초기화 시 포커스 이동
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch) {
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('DIV_CODE');
			UniAppManager.setToolbarButtons('reset', true);
		},
		onQueryButtonDown: function() {
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