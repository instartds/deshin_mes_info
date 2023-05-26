<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bpr540skrv">
	<t:ExtComboStore comboType="BOR120"/>				<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B018"/>	<!-- 예/아니오 -->
	<t:ExtComboStore comboType="AU" comboCode="B020"/>	<!-- 품목계정 -->
</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>

<script type="text/javascript">

function appMain() {
	var BsaCodeInfo={
		'gsBomPathYN'	:'${gsBomPathYN}',		//BOM PATH 관리여부(B082)
		'gsExchgRegYN'	:'${gsExchgRegYN}',		//대체품목 등록여부(B081)
		'gsItemCheck'	:'PROD'					//품목구분(PROD:모품목, CHILD:자품목)
	}

	/** Model 정의
	 * @type
	 */
	Unilite.defineModel('bpr540skrvModel', {
		fields: [
			{name: 'COMP_CODE'		,text: '<t:message code="system.label.base.companycode" default="법인코드"/>'			,type: 'string', defaultValue: UserInfo.compCode},
			{name: 'DIV_CODE'		,text:'<t:message code="system.label.base.division" default="사업장"/>'				,type:'string'},
			{name: 'PROD_ITEM_CODE'	,text:'<t:message code="system.label.base.parentitemcode" default="모품목코드"/>'		,type:'string'},
			{name: 'CHILD_ITEM_CODE',text: '<t:message code="system.label.base.childitemcode" default="자품목코드"/>'		,type: 'string', defaultValue: '$'},
			{name: 'ITEM_CODE'		,text:'<t:message code="system.label.base.itemcode" default="품목코드"/>'				,type:'string'},
			{name: 'ITEM_NAME'		,text:'<t:message code="system.label.base.itemname" default="품목명"/>'				,type:'string'},
			{name: 'SPEC'			,text:'<t:message code="system.label.base.spec" default="규격"/>'						,type:'string'},
			{name: 'START_DATE'		,text: '<t:message code="system.label.base.startdate" default="시작일"/>'				,type: 'uniDate', defaultValue: UniDate.get('today')},
			{name: 'STOP_DATE'		,text: '<t:message code="system.label.base.enddate" default="종료일"/>'				,type: 'uniDate', defaultValue: '2999.12.31'},
			{name: 'STOCK_UNIT'		,text:'<t:message code="system.label.base.inventoryunit" default="재고단위"/>'			,type:'string'},
			{name: 'UNIT_Q'			,text:'<t:message code="system.label.base.originunitqty" default="원단위량"/>'			,type: 'float', decimalPrecision: 6, format:'0,000.000000'},
			{name: 'PROD_UNIT_Q'	,text:'<t:message code="system.label.base.parentitembaseqty" default="모품목기준수"/>'	,type:'uniQty'},
			{name: 'LOSS_RATE'		,text:'<t:message code="system.label.base.lossrate" default="LOSS율"/>'				,type: 'float', decimalPrecision: 6, format:'0,000.000000'},
			{name: 'SEQ'			,text:'<t:message code="system.label.base.seq" default="순번"/>'						,type:'string'},
			{name: 'ITEM_ACCOUNT'	,text:'<t:message code="system.label.base.itemaccount" default="품목계정"/>'			,type:'string', comboType:'AU', comboCode:'B020'}
		]
	});


	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore = Unilite.createStore('bpr540skrvMasterStore', {
		model	: 'bpr540skrvModel',
		uniOpt	: {
			isMaster	: true,			// 상위 버튼 연결
			editable	: false,		// 수정 모드 사용
			deletable	: false,		// 삭제 가능 여부
			useNavi		: false			// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy	: {
			type: 'direct',
			api	: {
				read: 'bpr540skrvService.selectMasterList'
			}
		},
		loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params: param
			});
		},
		groupField: ''
	});

	var directDetailStore = Unilite.createStore('bpr540skrvDetailStore', {
		model	: 'bpr540skrvModel',
		uniOpt	: {
			isMaster	: true,			// 상위 버튼 연결
			editable	: false,		// 수정 모드 사용
			deletable	: false,		// 삭제 가능 여부
			useNavi		: false			// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy	: {
			type: 'direct',
			api	: {
				read: 'bpr540skrvService.selectDetailList'
			}
		},
		loadStoreRecords: function(record) {
			var param= Ext.getCmp('searchForm').getValues();
			if(record) {
				param.ITEM_CODE = record.get('ITEM_CODE');
			}
			console.log( param );
			this.load({
				params: param
			});
		},
		groupField: ''
	});


	/** 검색조건 (Search Panel)
	 * @type
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title		: '<t:message code="system.label.base.searchconditon" default="검색조건"/>',
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
			title		: '<t:message code="system.label.base.basisinfo2" default="기본정보"/>',
			itemId		: 'search_panel1',
			layout		: {type: 'uniTable', columns: 1},
			defaultType	: 'uniTextfield',
			items		: [{
				fieldLabel	: '<t:message code="system.label.base.division" default="사업장"/>',
				name		: 'DIV_CODE',
				value		: UserInfo.divCode,
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				allowBlank	: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.base.itemaccount" default="품목계정"/>',
				name		: 'ITEM_ACCOUNT',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'B020',
				allowBlank	: false,
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelResult.setValue('ITEM_ACCOUNT', newValue);
					}
				}
			},
			Unilite.popup('DIV_PUMOK',{
				fieldLabel		: '<t:message code="system.label.base.item" default="품목"/>',
				valueFieldName	: 'ITEM_CODE',
				textFieldName	: 'ITEM_NAME',
				validateBlank	: false,
				listeners		: {
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('ITEM_CODE', newValue);
						if(Ext.isEmpty(newValue)) {
							panelSearch.setValue('ITEM_NAME', '');

							panelResult.setValue('ITEM_CODE', '');
							panelResult.setValue('ITEM_NAME', '');
						}
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('ITEM_NAME', newValue);
						if(Ext.isEmpty(newValue)) {
							panelSearch.setValue('ITEM_CODE', '');

							panelResult.setValue('ITEM_CODE', '');
							panelResult.setValue('ITEM_NAME', '');
						}
					},
					applyextparam: function(popup){
						popup.setExtParam({
							'DIV_CODE'		: panelSearch.getValue('DIV_CODE'),
							'ITEM_ACCOUNT'	: panelSearch.getValue('ITEM_ACCOUNT')
						});
						if(panelSearch.down('#optsel').getChecked()[0].inputValue == "0"){
							popup.setExtParam({'ITEM_ACCOUNT_FILTER': ['10','20','40']});
						}
					}
				}
			}),{
				xtype		: 'uniCombobox',
				fieldLabel	: '<t:message code="system.label.base.useyn" default="사용여부"/>',
				name		: 'USE_YN',
				comboType	: 'AU',
				comboCode	: 'B018',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('USE_YN', newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.base.deploymentgubun" default="전개구분"/>',
				xtype		: 'radiogroup',
				itemId		: 'optsel',
				items		: [{
					boxLabel	: '<t:message code="system.label.base.explosion" default="정전개"/>',
					name		: 'OPTSEL',
					inputValue	: '0',
					width		: 120,
					checked		: true
				}, {
					boxLabel	: '<t:message code="system.label.base.implosion" default="역전개"/>',
					name		: 'OPTSEL',
					inputValue	: '1',
					width		: 60
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.getField('OPTSEL').setValue(newValue.OPTSEL);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.base.itemsearch" default="품목검색"/>',
				xtype		: 'radiogroup',
				items		: [{
					boxLabel	: '<t:message code="system.label.base.currentapplieditem" default="현재적용품목"/>',
					name		: 'ITEM_SEARCH',
					width		: 120,
					inputValue	: 'C',
					checked		: true
				},{
					boxLabel	: '<t:message code="system.label.base.whole" default="전체"/>',
					name		: 'ITEM_SEARCH',
					width		: 60,
					inputValue	: 'A'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						//panelResult.getField('RDO').setValue({RDO: newValue});
						panelResult.getField('ITEM_SEARCH').setValue(newValue.ITEM_SEARCH);
						UniAppManager.app.onQueryButtonDown();
					}
				}
			}/*,{//코디에서 사용하는 프로그램: 집약정전개 조회(bpr530skrv), 제조BOM 등록(bpr560ukrv), 연구소처방등록(bpr580ukrv), 제조BOM 조회(bpr581skrv), 기본정보등록(mba030ukrv - 외주P/L 조회) - 20190718일 PATH_CODE 관련 조회조건 주석 (윤전무님)으로 신규 프로그램에서도 주석
				xtype		: 'uniRadiogroup',
				fieldLabel	: '<t:message code="system.label.base.standardpathyn" default="표준Path 여부"/>',
				name		: 'StPathY',
				comboType	: 'AU',
				comboCode	: 'A020',
				width		: 284,
				hidden		: BsaCodeInfo.gsBomPathYN =='Y' ? false:true,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.getField('StPathY').setValue(newValue.StPathY);
					}
				}
			}*/]
		}]
	});

	var panelResult = Unilite.createSearchForm('panelResultForm', {
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		region	: 'north',
		layout	: {type : 'uniTable', columns : 4},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel	: '<t:message code="system.label.base.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			value		: UserInfo.divCode,
			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.base.itemaccount" default="품목계정"/>',
			name		: 'ITEM_ACCOUNT',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B020',
			allowBlank	: false,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					panelSearch.setValue('ITEM_ACCOUNT', newValue);
				}
			}
		},
		Unilite.popup('DIV_PUMOK',{
			fieldLabel		: '<t:message code="system.label.base.item" default="품목"/>',
			valueFieldName	: 'ITEM_CODE',
			textFieldName	: 'ITEM_NAME',
			validateBlank	: false,
			listeners		: {
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('ITEM_CODE', newValue);
					if(Ext.isEmpty(newValue)) {
						panelResult.setValue('ITEM_NAME', '');

						panelSearch.setValue('ITEM_CODE', '');
						panelSearch.setValue('ITEM_NAME', '');
					}
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('ITEM_NAME', newValue);
					if(Ext.isEmpty(newValue)) {
						panelResult.setValue('ITEM_CODE', '');

						panelSearch.setValue('ITEM_CODE', '');
						panelSearch.setValue('ITEM_NAME', '');
					}
				},
				applyextparam: function(popup){
					popup.setExtParam({
						'DIV_CODE'		: panelSearch.getValue('DIV_CODE'),
						'ITEM_ACCOUNT'	: panelSearch.getValue('ITEM_ACCOUNT')
					});
					if(panelResult.down('#optsel').getChecked()[0].inputValue == "0"){
						popup.setExtParam({'ITEM_ACCOUNT_FILTER': ['10','20','40']});
					}
				}
			}
		}),{
			xtype		: 'uniCombobox',
			fieldLabel	: '<t:message code="system.label.base.useyn" default="사용여부"/>',
			name		: 'USE_YN',
			comboType	: 'AU',
			comboCode	: 'B018',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('USE_YN', newValue);
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.base.deploymentgubun" default="전개구분"/>',
			xtype		: 'radiogroup',
			itemId		: 'optsel',
			items		: [{
				boxLabel	: '<t:message code="system.label.base.explosion" default="정전개"/>',
				name		: 'OPTSEL',
				inputValue	: '0',
				width		: 70,
				checked		: true
			}, {
				boxLabel	: '<t:message code="system.label.base.implosion" default="역전개"/>',
				name		: 'OPTSEL',
				inputValue	: '1',
				width		: 60
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.getField('OPTSEL').setValue(newValue.OPTSEL);
					directDetailStore.loadData({});
					UniAppManager.app.onQueryButtonDown();
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.base.itemsearch" default="품목검색"/>',
			xtype		: 'radiogroup',
			items		: [{
				boxLabel	: '<t:message code="system.label.base.currentapplieditem" default="현재적용품목"/>',
				name		: 'ITEM_SEARCH',
				width		: 100,
				inputValue	: 'C',
				checked: true
			},{
				boxLabel	: '<t:message code="system.label.base.whole" default="전체"/>',
				name		: 'ITEM_SEARCH',
				inputValue	: 'A'
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.getField('ITEM_SEARCH').setValue(newValue.ITEM_SEARCH);
					directDetailStore.loadData({});
					UniAppManager.app.onQueryButtonDown();
				}
			}
		},{
			xtype: 'component'
		}/*,{//코디에서 사용하는 프로그램: 집약정전개 조회(bpr530skrv), 제조BOM 등록(bpr560ukrv), 연구소처방등록(bpr580ukrv), 제조BOM 조회(bpr581skrv), 기본정보등록(mba030ukrv - 외주P/L 조회) - 20190718일 PATH_CODE 관련 조회조건 주석 (윤전무님)으로 신규 프로그램에서도 주석
			xtype		: 'uniRadiogroup',
			fieldLabel	: '<t:message code="system.label.base.standardpathyn" default="표준Path 여부"/>',
			name		: 'StPathY',
			comboType	: 'AU',
			comboCode	: 'A020',
			width		: 280,
			hidden		: BsaCodeInfo.gsBomPathYN =='Y' ? false:true,
			value		: 'Y',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.getField('StPathY').setValue(newValue.StPathY);
				}
			}
		}*/]
	});



	/** Master Grid1 정의(Grid Panel),
	 * @type
	 */
	var masterGrid = Unilite.createGrid('bpr540skrvGrid1', {
		store	: directMasterStore,
		layout	: 'fit',
		region	: 'center',
		selModel: 'rowmodel',
		uniOpt	: {
			expandLastColumn	: false,
			useRowNumberer		: true,
			useMultipleSorting	: true,
			useGroupSummary		: false,
			useLiveSearch		: true,
			onLoadSelectFirst	: true,
			filter: {
				useFilter	: true,
				autoCreate	: true
			}
		},
		features: [ {id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false },
					{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false}],
		columns	: [
			{dataIndex: 'COMP_CODE'			, width: 66	, hidden: true},
			{dataIndex: 'DIV_CODE'			, width: 66	, hidden: true},
			{dataIndex: 'PROD_ITEM_CODE'	, width: 90	, hidden: true},
			{dataIndex: 'CHILD_ITEM_CODE'	, width: 66	, hidden: true},
			{dataIndex: 'ITEM_CODE'			, width: 120},
			{dataIndex: 'ITEM_NAME'			, width: 250},
			{dataIndex: 'SPEC'				, width: 250},
			{dataIndex: 'ITEM_ACCOUNT'		, width: 80	, align: 'center'},
//			{dataIndex: 'STOCK_UNIT'		, width: 80	, align: 'center'},
//			{dataIndex: 'UNIT_Q'			, width: 100},
			{dataIndex: 'START_DATE'		, width: 100, hidden: false},
			{dataIndex: 'STOP_DATE'			, width: 100, hidden: false}
		],
		listeners:{
			selectionChange: function( gird, selected, eOpts ) {
				directDetailStore.loadStoreRecords(selected[0]);
			}
		}
	});

	var detailGrid = Unilite.createGrid('bpr581skrvGrid1', {
		store	: directDetailStore,
		layout	: 'fit',
		region	: 'east',
		uniOpt	: {
			expandLastColumn	: false,
			useRowNumberer		: true,
			useMultipleSorting	: true,
			useGroupSummary		: false,
			useLiveSearch		: true,
			onLoadSelectFirst	: true,
			filter: {
				useFilter	: true,
				autoCreate	: true
			}
		},
		features: [ {id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false },
					{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false}],
		columns: [
			{dataIndex: 'COMP_CODE'			, width: 66	, hidden: true},
			{dataIndex: 'DIV_CODE'			, width: 66	, hidden: true},
			{dataIndex: 'PROD_ITEM_CODE'	, width: 90	, hidden: true},
			{dataIndex: 'CHILD_ITEM_CODE'	, width: 66	, hidden: true},
			{dataIndex: 'ITEM_CODE'			, width: 120},
			{dataIndex: 'ITEM_NAME'			, width: 250},
			{dataIndex: 'SPEC'				, width: 250},
			{dataIndex: 'ITEM_ACCOUNT'		, width: 80	, align: 'center'},
			{dataIndex: 'STOCK_UNIT'		, width: 80	, align: 'center'},
			{dataIndex: 'UNIT_Q'			, width: 100}
		]
	});



	Unilite.Main({
		id			: 'bpr540skrvApp',
		borderItems : [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [{
				region	: 'center',
				layout	: {type: 'vbox', align: 'stretch'},
				border	: false,
				flex	: .7,
				items	: [masterGrid]
			},
			detailGrid,
			panelResult
			]
		},
		panelSearch
		],
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE'	, UserInfo.divCode);
			panelSearch.getField('OPTSEL').setValue('C');
			panelSearch.getField('ITEM_SEARCH').setValue('C');
			panelSearch.setValue('StPathY'	, 'Y');

			panelResult.setValue('DIV_CODE'	, UserInfo.divCode);
			panelResult.getField('OPTSEL').setValue('C');
			panelResult.getField('ITEM_SEARCH').setValue('C');
			panelResult.setValue('StPathY'	, 'Y');

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
			masterGrid.getStore().loadData({});
			detailGrid.getStore().loadData({});
			masterGrid.getStore().loadStoreRecords();
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.getStore().loadData({});
			detailGrid.getStore().loadData({});
			this.fnInitBinding();
		}
	});
};
</script>