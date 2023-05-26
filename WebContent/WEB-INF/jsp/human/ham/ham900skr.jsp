<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="ham900skr"  >
	<t:ExtComboStore comboType="AU" comboCode="A074" />	<!-- 지급분기 -->
	<t:ExtComboStore comboType="BOR120" />				<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="HS02" />	<!-- 내외국인구분 -->
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
	Unilite.defineModel('Ham900skrModel', {
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
	});//End of Unilite.defineModel('Ham900skrModel', {
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */
	var directMasterStore1 = Unilite.createStore('ham900skrMasterStore1', {
		model: 'Ham900skrModel',
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
				read: 'ham900skrService.selectList'
			}
		},
		listeners : {
			/*load : function(store) {
				if (store.getCount() > 0) {
					showSummaryRow(true);
				}
			}*/
		},
		loadStoreRecords: function(){
			var param= Ext.getCmp('searchForm').getValues();
			console.log(param);
			this.load({
				params: param
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
			title: '기본정보',
			id: 'search_panel1',
   			itemId: 'search_panel1',
			layout: {type: 'uniTable', columns: 1},
			defaultType: 'uniTextfield',
			items: [{
				fieldLabel: '귀속년도',
				name: 'PAY_YYYY',
				xtype: 'uniYearField',
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('PAY_YYYY', newValue);
					}
				}
			},{
				fieldLabel: '지급분기',
				name: 'QUARTER_TYPE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'A074',
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('QUARTER_TYPE', newValue);
					}
				}
			},
			Unilite.popup('ParttimeEmployee',{
				fieldLabel: '사원',
				valueFieldName:'PERSON_NUMB',
				textFieldName:'NAME',
				validateBlank:false,
				autoPopup:true,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('PERSON_NUMB', panelSearch.getValue('PERSON_NUMB'));
							panelResult.setValue('NAME', panelSearch.getValue('NAME'));
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('PERSON_NUMB', '');
						panelSearch.setValue('NAME', '');
						panelResult.setValue('PERSON_NUMB', '');
						panelResult.setValue('NAME', '');
					},
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('PERSON_NUMB', newValue);
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('NAME', newValue);
					}
				}
			})]
		}]
	});//End of var panelSearch = Unilite.createSearchForm('searchForm', {
	
	var panelResult = Unilite.createSearchForm('panelResultForm', {
		hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
			items: [{ 
				fieldLabel: '귀속년도',
				name: 'PAY_YYYY',
				xtype: 'uniYearField',
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('PAY_YYYY', newValue);
					}
				}
			},{ 
				fieldLabel: '지급분기',
				name: 'QUARTER_TYPE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'A074',
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('QUARTER_TYPE', newValue);
					}
				}
			},
			Unilite.popup('ParttimeEmployee',{
				fieldLabel: '사원',
				valueFieldName:'PERSON_NUMB',
				textFieldName:'NAME',
				validateBlank:false,
				autoPopup:true,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('PERSON_NUMB', panelResult.getValue('PERSON_NUMB'));
							panelSearch.setValue('NAME', panelResult.getValue('NAME'));
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('PERSON_NUMB', '');
						panelResult.setValue('NAME', '');
						panelSearch.setValue('PERSON_NUMB', '');
						panelSearch.setValue('NAME', '');
					},
					
					onValueFieldChange: function(field, newValue){
						panelSearch.setValue('PERSON_NUMB', newValue);
					},
					onTextFieldChange: function(field, newValue){
						panelSearch.setValue('NAME', newValue);
					}
				}
			})]
	});
	
	/**
	 * Master Grid1 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid = Unilite.createGrid('ham900skrGrid1', {
		layout: 'fit',
		region: 'center',
		uniOpt:{
			useMultipleSorting	: true,
			useLiveSearch		: true,
			onLoadSelectFirst	: true,
			dblClickToEdit		: false,
			useGroupSummary		: true,
			useContextMenu		: false,
			useRowNumberer		: true,
			expandLastColumn	: false,
			useRowContext		: true,
			filter: {
				useFilter		: true,
				autoCreate		: true
			}
		},
		store: directMasterStore1,
		features: [	{id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
					{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: true}
		],
		columns: [
			{text: '소득자',
				columns: [ 
					{ dataIndex:'N_GUBUN'		,	width: 6, hidden: true},
					{ dataIndex:'REPRE_NUM'		,	width: 126},
					{ dataIndex:'IN_FORE'		,	width: 93},
					{ dataIndex:'PERSON_NUMB'	,	width: 100,
						summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
							return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.human.subtotal" default="소계"/>', '<t:message code="system.label.human.total" default="총계"/>');
						}
					},
					{ dataIndex:'NAME'			,	width: 100, summaryType: 'count',
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
	});//End of var masterGrid = Unilite.createGrid('ham900skrGrid1', {   

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
		id: 'ham900skrApp',
		fnInitBinding: function() {
			var yearSetting = '';
			
			if(moment().add(UniDate.get('today')).format('MMDD') <= "0229"){
				yearSetting = moment().add(UniDate.get('today')).format('YYYY') - 1;
				
				panelSearch.setValue('PAY_YYYY', yearSetting);
				panelResult.setValue('PAY_YYYY', yearSetting);
			}
			else{
				yearSetting = moment().add(UniDate.get('today')).format('YYYY');
				
				panelSearch.setValue('PAY_YYYY', yearSetting);
				panelResult.setValue('PAY_YYYY', yearSetting);
			}
			
			var fnfirstCombo = Ext.data.StoreManager.lookup('CBS_AU_A074').getAt(0).get('value');
			panelSearch.setValue('QUARTER_TYPE', fnfirstCombo);
			panelResult.setValue('QUARTER_TYPE', fnfirstCombo);
			
			var activeSForm;
			if(!UserInfo.appOption.collapseLeftSearch) {
				activeSForm = panelSearch;
			} else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('PAY_YYYY');
			
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			UniAppManager.setToolbarButtons('save',false);
		},
		onQueryButtonDown : function()	{
			if(!this.isValidSearchForm()){
				return false;
			}
			masterGrid.getStore().loadStoreRecords();
		}
		/*onResetButtonDown:function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			
			this.fnInitBinding();
		}*/
	});//End of Unilite.Main( {
	
	/*function showSummaryRow(viewable) {
		var viewLocked = masterGrid.lockedGrid.getView();
		var viewNormal = masterGrid.normalGrid.getView();
		viewLocked.getFeature('masterGridTotal').toggleSummaryRow(viewable);
		viewNormal.getFeature('masterGridTotal').toggleSummaryRow(viewable);
		masterGrid.getView().refresh();	
	}*/
};

</script>
