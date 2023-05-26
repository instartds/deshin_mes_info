<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="ham950skr">
	<t:ExtComboStore comboType="AU" comboCode="A074"/>	<!-- 지급분기 -->
	<t:ExtComboStore comboType="BOR120"/>				<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="HS02"/>	<!-- 내외국인구분 -->
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
		title		: '검색조건',
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
			title		: '기본정보',
			id			: 'search_panel1',
			itemId		: 'search_panel1',
			layout		: {type: 'uniTable', columns: 1},
			defaultType	: 'uniTextfield',
			items		: [{
				fieldLabel	: '지급년월',
				name		: 'PAY_YYYYMM',
				xtype		: 'uniMonthfield',
				allowBlank	: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('PAY_YYYYMM', newValue);
					}
				}
			},
			Unilite.popup('ParttimeEmployee',{
				fieldLabel		: '사원',
				valueFieldName	: 'PERSON_NUMB',
				textFieldName	: 'NAME',
				validateBlank	: false,
				listeners		: {
					onValueFieldChange: function(field, newValue, oldValue){
						panelResult.setValue('PERSON_NUMB', newValue);

						if(!Ext.isObject(oldValue)) {
							panelResult.setValue('NAME', '');
							panelSearch.setValue('NAME', '');
						}
					},
					onTextFieldChange: function(field, newValue, oldValue){
						panelResult.setValue('NAME', newValue);

						if(!Ext.isObject(oldValue)) {
							panelResult.setValue('PERSON_NUMB', '');
							panelSearch.setValue('PERSON_NUMB', '');
						}
					}
				}
			})]
		}]
	});

	var panelResult = Unilite.createSearchForm('panelResultForm', {
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		region	: 'north',
		layout	: {type : 'uniTable', columns : 4},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{ 
			fieldLabel	: '지급년월',
			name		: 'PAY_YYYYMM',
			xtype		: 'uniMonthfield',
			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('PAY_YYYYMM', newValue);
				}
			}
		},
		Unilite.popup('ParttimeEmployee',{
			fieldLabel		: '사원',
			valueFieldName	: 'PERSON_NUMB',
			textFieldName	: 'NAME',
			validateBlank	: false,
			listeners		: {
				onValueFieldChange: function(field, newValue, oldValue){
					panelSearch.setValue('PERSON_NUMB', newValue);

					if(!Ext.isObject(oldValue)) {
						panelResult.setValue('NAME', '');
						panelSearch.setValue('NAME', '');
					}
				},
				onTextFieldChange: function(field, newValue, oldValue){
					panelSearch.setValue('NAME', newValue);

					if(!Ext.isObject(oldValue)) {
						panelResult.setValue('PERSON_NUMB', '');
						panelSearch.setValue('PERSON_NUMB', '');
					}
				}
			}
		})]
	});



	/** Model 정의 
	 * @type 
	 */
	Unilite.defineModel('ham950skrModel', {
		fields: [
			{name: 'N_GUBUN'			, text: '주민등록번호'	, type: 'string'},
			{name: 'REPRE_NUM'			, text: '주민등록번호'	, type: 'string'},
			{name: 'IN_FORE'			, text: '내외국인'		, type: 'string', comboType:'AU', comboCode:'HS02'},
			{name: 'PERSON_NUMB'		, text: '사번'		, type: 'string'},
			{name: 'NAME'				, text: '성명'		, type: 'string'},
			{name: 'JOIN_DATE'			, text: '입사일'		, type: 'uniDate'},
			{name: 'RETR_DATE'			, text: '퇴사일'		, type: 'uniDate'},
			{name: 'PAY_YYYY'			, text: '귀속년도'		, type: 'uniDate'},
			{name: 'QUARTER_TYPE'		, text: '귀속분기'		, type: 'string', comboType:'AU', comboCode:'A074'},
			{name: 'END_YYYYMM'			, text: '근로종료월'		, type: 'string'},
			{name: 'WORK_DAYS'			, text: '근무일수'		, type: 'uniNumber'},
			{name: 'TOTAL_AMOUNT_I'		, text: '과세소득'		, type: 'uniPrice'},
			{name: 'TAX_EXEMPTION_I'	, text: '비과세소득'		, type: 'uniPrice'},
			{name: 'IN_TAX_I'			, text: '소득세'		, type: 'uniPrice'},
			{name: 'LOCAL_TAX_I'		, text: '주민세'		, type: 'uniPrice'}
		]
	});

	/** Store 정의(Service 정의)
	 * @type 
	 */
	var directMasterStore1 = Unilite.createStore('ham950skrMasterStore1', {
		model	: 'ham950skrModel',
		uniOpt	: {
			isMaster	: true,			// 상위 버튼 연결 
			editable	: false,		// 수정 모드 사용 
			deletable	: false,		// 삭제 가능 여부 
			useNavi		: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy	: {
			type: 'direct',
			api	: {
				read: 'ham950skrService.selectList'
			}
		},
		loadStoreRecords: function(){
			var param= Ext.getCmp('searchForm').getValues();
			console.log(param);
			this.load({
				params: param
			});
		},
		listeners : {
		}
	});

	/** Master Grid1 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid = Unilite.createGrid('ham950skrGrid1', {
		store	: directMasterStore1,
		layout	: 'fit',
		region	: 'center',
		uniOpt	:{
			useMultipleSorting	: true,
			useLiveSearch		: true,
			onLoadSelectFirst	: true,
			dblClickToEdit		: false,
			useGroupSummary		: true,
			useContextMenu		: false,
			useRowNumberer		: true,
			expandLastColumn	: true,
			useRowContext		: true,
			filter: {
				useFilter		: true,
				autoCreate		: true
			}
		},
		features: [	{id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
					{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: true}
		],
		columns: [
			{text: '소득자',
				columns: [ 
					{ dataIndex:'N_GUBUN'		, width: 6, hidden: true},
					{ dataIndex:'REPRE_NUM'		, width: 126},
					{ dataIndex:'IN_FORE'		, width: 93},
					{ dataIndex:'PERSON_NUMB'	, width: 100,
						summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
							return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.human.subtotal" default="소계"/>', '<t:message code="system.label.human.total" default="총계"/>');
						}
					},
					{ dataIndex:'NAME'			, width: 100, summaryType: 'count',
						summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
							return '<div style="text-align:right;">' + this.formatNumber(value) + ' 명</div>';
						},
						formatNumber : function(val) {
							return val.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
						}
					},
					{ dataIndex:'JOIN_DATE'		,	width: 86},
					{ dataIndex:'RETR_DATE'		,	width: 86}
				]
			},
			{dataIndex: 'PAY_YYYY'			, width: 60, hidden: true},
			{dataIndex: 'QUARTER_TYPE'		, width: 73, hidden: true},
			{dataIndex: 'END_YYYYMM'		, width: 86, align: 'center'},
			{dataIndex: 'WORK_DAYS'			, width: 90},
			{dataIndex: 'TOTAL_AMOUNT_I'	, width: 100, summaryType: 'sum'},
			{dataIndex: 'TAX_EXEMPTION_I'	, width: 120, summaryType: 'sum'},
			{dataIndex: 'IN_TAX_I'			, width: 93, summaryType: 'sum'},
			{dataIndex: 'LOCAL_TAX_I'		, width: 86, summaryType: 'sum'}
		]
	});



	Unilite.Main({
		id			: 'ham950skrApp',
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
			panelSearch.setValue('PAY_YYYYMM', UniDate.add(UniDate.today(),{'months':-1} ));
			panelResult.setValue('PAY_YYYYMM', UniDate.add(UniDate.today(),{'months':-1} ));

			var activeSForm;
			if(!UserInfo.appOption.collapseLeftSearch) {
				activeSForm = panelSearch;
			} else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('PAY_YYYYMM');

			UniAppManager.setToolbarButtons(['save', 'reset', 'detail'], false);
			UniAppManager.setToolbarButtons('reset', true);
		},
		onQueryButtonDown : function()	{
			if(!this.isValidSearchForm()){
				return false;
			}
			masterGrid.getStore().loadStoreRecords();
		},
		onResetButtonDown:function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.getStore().loadData({});
			this.fnInitBinding();
		}
	});
};
</script>