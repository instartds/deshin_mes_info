<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<t:appConfig pgmId="acm400skr">
	<t:ExtComboStore comboType="BOR120"/>					<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A003" />		<!-- 매입/매출구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B066" />		<!-- 계산서종류 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript">

function appMain() {
	/**
	 * Model 정의
	 * @type
	 */
	Unilite.defineModel('Agb251skrModel', {
		fields: [
			{name: 'PUB_DATE'			, text: '계산서일'		, type: 'uniDate'},
			{name: 'COMPANY_NUM'		, text: '사업자번호'		, type: 'string'},
			{name: 'CUSTOM_NAME'		, text: '거래처명'		, type: 'string'},
			{name: 'ERP_SUPPLY_AMT'		, text: '공급가액'		, type: 'uniPrice'},
			{name: 'ERP_TAX_AMT'		, text: '세액'		, type: 'uniPrice'},
			{name: 'ERP_SUM_AMT'		, text: '합계'		, type: 'uniPrice'},
			{name: 'ERP_CNT'			, text: '건수'		, type: 'uniPrice'},
			{name: 'CMS_SUPPLY_AMT'		, text: '공급가액'		, type: 'uniPrice'},
			{name: 'CMS_TAX_AMT'		, text: '세액'		, type: 'uniPrice'},
			{name: 'CMS_SUM_AMT'		, text: '합계'		, type: 'uniPrice'},
			{name: 'CMS_CNT'			, text: '건수'		, type: 'uniPrice'},
			{name: 'COMP_YN'			, text: '일치여부'		, type: 'string'}
		]
	});

	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */
	var directMasterStore = Unilite.createStore('agb251skrMasterStore',{
		model: 'Agb251skrModel',
		uniOpt: {
			isMaster : true,		// 상위 버튼 연결 
			editable : false,		// 수정 모드 사용 
			deletable: false,		// 삭제 가능 여부 
			useNavi  : false		// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {
				read: 'acm400skrService.selectList'
			}
		},
		loadStoreRecords: function() {
			var param = Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	
	/**
	 * 검색조건 (Search Panel)
	 * @type
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '검색조건',
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
			title		: '기본정보',
			itemId		: 'search_panel1',
			layout		: {type: 'uniTable', columns: 1},
			defaultType	: 'uniTextfield',
			items		: [{
				fieldLabel			: '기준일',
				xtype				: 'uniDateRangefield',
				startFieldName		: 'PUB_DATE_FR',
				endFieldName		: 'PUB_DATE_TO',
				allowBlank			: false,
				onStartDateChange	: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('PUB_DATE_FR', newValue);
					}
				},
				onEndDateChange		: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('PUB_DATE_TO', newValue);
					}
				}
			},{
				fieldLabel	: '매입/매출구분',
				name		: 'INOUT_DIVI',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'A003',
				allowBlank	: false,
				listeners	: {
					change	: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('INOUT_DIVI', newValue);
					}
				}
			},{
				fieldLabel	: '사업자번호',
				name		: 'COMPANY_NUM',
				xtype		: 'uniTextfield',
				allowBlank	: true,
				listeners	: {
					change	: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('COMPANY_NUM', newValue);
					}
				}
			},{
				fieldLabel	: '계산서종류',
				name		: 'BILL_TYPE',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'B066',
				allowBlank	: false,
				listeners	: {
					change	: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('BILL_TYPE', newValue);
					}
				}
			},{
				fieldLabel	: '신고사업장',
				name		: 'BILL_DIV_CODE', 
				xtype		: 'uniCombobox',
				value		: UserInfo.divCode,
				comboType	: 'BOR120',
				allowBlank	: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('BILL_DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel	: '대사결과',
				name		: 'COMP_YN',
				xtype		: 'radiogroup',
				items: [{
					boxLabel	: '전체',
					width		: 70,
					inputValue	: 'A'
				},{
					boxLabel	: '일치',
					width		: 70,
					inputValue	: 'Y'
				},{
					boxLabel	: '불일치',
					width		: 70,
					inputValue	: 'N'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('COMP_YN', newValue);
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
			fieldLabel			: '기준일',
			xtype				: 'uniDateRangefield',
			startFieldName		: 'PUB_DATE_FR',
			endFieldName		: 'PUB_DATE_TO',
			allowBlank			: false,
			onStartDateChange	: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('PUB_DATE_FR', newValue);
				}
			},
			onEndDateChange		: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('PUB_DATE_TO', newValue);
				}
			}
		},{
			fieldLabel	: '매입/매출구분',
			name		: 'INOUT_DIVI',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'A003',
			allowBlank	: false,
			listeners	: {
				change	: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('INOUT_DIVI', newValue);
				}
			}
		},{
			fieldLabel	: '사업자번호',
			name		: 'COMPANY_NUM',
			xtype		: 'uniTextfield',
			allowBlank	: true,
			listeners	: {
				change	: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('COMPANY_NUM', newValue);
				}
			}
		},{
			fieldLabel	: '계산서종류',
			name		: 'BILL_TYPE',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B066',
			allowBlank	: false,
			listeners	: {
				change	: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('BILL_TYPE', newValue);
				}
			}
		},{
			fieldLabel	: '신고사업장',
			name		: 'BILL_DIV_CODE', 
			xtype		: 'uniCombobox',
			value		: UserInfo.divCode,
			comboType	: 'BOR120',
			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('BILL_DIV_CODE', newValue);
				}
			}
		},{
			fieldLabel	: '대사결과',
			name		: 'COMP_YN',
			xtype		: 'radiogroup',
			items: [{
				boxLabel	: '전체',
				width		: 60,
				inputValue	: 'A'
			},{
				boxLabel	: '일치',
				width		: 60,
				inputValue	: 'Y'
			},{
				boxLabel	: '불일치',
				width		: 70,
				inputValue	: 'N'
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('COMP_YN', newValue);
				}
			}
		}]
	});

	/**
	 * Master Grid1 정의(Grid Panel)
	 * @type
	 */
	var masterGrid = Unilite.createGrid('agb251skrGrid', {
		layout : 'fit',
		region : 'center',
		store  : directMasterStore,
		uniOpt : {
			useMultipleSorting	: true,
			useLiveSearch		: true,
			onLoadSelectFirst	: false,
			dblClickToEdit		: false,
			useGroupSummary		: false,
			useContextMenu		: false,
			useRowNumberer		: true,
			expandLastColumn	: false,
			useRowContext		: true,
			lockable			: false,
			filter: {
				useFilter		: true,
				autoCreate		: true
			}
		},
		features: [{
			id				: 'masterGridSubTotal',
			ftype			: 'uniGroupingsummary',
			showSummaryRow	: false
		},{
			id				: 'masterGridTotal',
			ftype			: 'uniSummary',
			showSummaryRow	: true
		}],
		columns: [
			{dataIndex: 'PUB_DATE'			, width:  80	,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
				}
			},
			{dataIndex: 'COMPANY_NUM'		, width:  120	, align:'center',
				renderer: function(value, meta, record) {
					var rv = String(value);
					
					if(!Ext.isEmpty(rv)) {
						if(rv.length == 10) {
							value = rv.substring(0, 3) + '-' + rv.substring(3, 5) + '-' + rv.substring(5, 10);
						}
						else if(rv.length == 13) {
							value = rv.substring(0, 6) + '-' + rv.substring(6, 13);
						}
						else {
							value = rv;
						}
					}
					
					return value;
				}
			},
			{dataIndex: 'CUSTOM_NAME'		, width: 120	},
			{text:'ERP 자료'					,
				columns	: [
					{dataIndex: 'ERP_SUPPLY_AMT'	, width: 120	, summaryType: 'sum'},
					{dataIndex: 'ERP_TAX_AMT'		, width: 120	, summaryType: 'sum'},
					{dataIndex: 'ERP_SUM_AMT'		, width: 120	, summaryType: 'sum'},
					{dataIndex: 'ERP_CNT'			, width: 120	, summaryType: 'sum'}
				]
			},
			{text:'국세청 자료'					,
				columns	: [
					{dataIndex: 'CMS_SUPPLY_AMT'	, width: 120	, summaryType: 'sum'},
					{dataIndex: 'CMS_TAX_AMT'		, width: 120	, summaryType: 'sum'},
					{dataIndex: 'CMS_SUM_AMT'		, width: 120	, summaryType: 'sum'},
					{dataIndex: 'CMS_CNT'			, width: 120	, summaryType: 'sum'}
				]
			},
			{dataIndex: 'COMP_YN'			, width:  80	}
		]
	});

	Unilite.Main( {
		border: false,
		borderItems:[{
			region : 'center',
			layout : 'border',
			border : false,
			items  : [
					masterGrid, panelResult
				]
			},
			panelSearch
		],
		id : 'acm400skrApp',
		fnInitBinding : function() {
			if(!UserInfo.appOption.collapseLeftSearch) {
				activeSForm = panelSearch;
			} else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('PUB_DATE_FR');
			
			panelSearch.setValue('PUB_DATE_FR', UniDate.get('startOfMonth'));
			panelSearch.setValue('PUB_DATE_TO', UniDate.get('today'));
			panelSearch.setValue('INOUT_DIVI', '1');
			panelSearch.setValue('COMPANY_NUM', '');
			panelSearch.setValue('BILL_TYPE', '1');
			panelSearch.setValue('COMP_YN', {COMP_YN:'A'});
			
			panelResult.setValue('PUB_DATE_FR', UniDate.get('startOfMonth'));
			panelResult.setValue('PUB_DATE_TO', UniDate.get('today'));
			panelResult.setValue('INOUT_DIVI', '1');
			panelResult.setValue('COMPANY_NUM', '');
			panelResult.setValue('BILL_TYPE', '1');
			panelResult.setValue('COMP_YN', {COMP_YN:'A'});
			
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown : function() {
			if(!this.isValidSearchForm()){
				return false;
			}
			directMasterStore.loadStoreRecords();
		}
	});
};


</script>