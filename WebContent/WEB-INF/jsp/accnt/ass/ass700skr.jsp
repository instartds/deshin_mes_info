<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="ass700skr">
	<t:ExtComboStore comboType="BOR120"/>				<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A091"/>	<!-- 변동구분 -->
</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

var gsChargeCode  = Ext.isEmpty(${getChargeCode}) ? ['']: ${getChargeCode};	//ChargeCode 관련 전역변수
function appMain() {
	/** Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Ass700skrModel', {
		fields: [
			{name: 'ALTER_DIVI'		,text: '변동구분코드'		,type: 'string'},
			{name: 'ALTER_DIVINM'	,text: '변동구분'		,type: 'string'},
			{name: 'SEQ'			,text: '순번'			,type: 'string'},
			{name: 'ALTER_DATE'		,text: '변동일'		,type: 'uniDate'},
			{name: 'ASST'			,text: '자산코드'		,type: 'string'},
			{name: 'ASST_NAME'		,text: '자산명'		,type: 'string'},
			{name: 'ACCNT_NAME'		,text: '계정과목'		,type: 'string'},
			{name: 'DRB_YEAR'		,text: '내용년수'		,type: 'string'},
			{name: 'ACQ_DATE'		,text: '취득일'		,type: 'uniDate'},
			{name: 'ACQ_AMT_I'		,text: '취득금액'		,type: 'uniPrice'},
			{name: 'ACQ_Q'			,text: '변동수량'		,type: 'uniQty'},
			{name: 'ALTER_AMT_I'	,text: '변동금액'		,type: 'uniPrice'},
			{name: 'REMARK'			,text: '변동사유'		,type: 'string'},
			{name: 'MONEY_UNIT_NM'	,text: '화폐단위'		,type: 'string'},
			{name: 'EXCHG_RATE_O'	,text: '환율'			,type: 'uniER'},
			{name: 'FOR_ACQ_AMT_I'	,text: '외화변동액'		,type: 'uniFC'},
			{name: 'PRE_DIV_NAME'	,text: '이동전 자산사업장'	,type: 'string'},
			{name: 'PRE_DEPT_NAME'	,text: '이동전 자산부서'	,type: 'string'},
			{name: 'DIV_NAME'		,text: '사업장'		,type: 'string'},
			{name: 'TREE_NAME'		,text: '부서'			,type: 'string'},
			{name: 'EX_DATE'		,text: '결의일'		,type: 'uniDate'},
			{name: 'EX_NUM'			,text: '결의번호'		,type: 'string'},
			{name: 'AGREE_YN'		,text: '승인여부'		,type: 'string'}
		]
	});

	/** Store 정의(Service 정의)
	 * @type 
	 */
	var directMasterStore = Unilite.createStore('ass700skrMasterStore1',{
		model: 'Ass700skrModel',
		uniOpt : {
			isMaster: true,			// 상위 버튼 연결 
			editable: false,		// 수정 모드 사용 
			deletable:false,		// 삭제 가능 여부 
			useNavi : false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {
				read: 'ass700skrService.selectList'
			}
		},
		loadStoreRecords : function()	{
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		groupField: 'ALTER_DIVINM',
		listeners: {
			load: function(store, records, successful, eOpts) {
				var viewNormal = masterGrid.normalGrid.getView();
				var viewLocked = masterGrid.lockedGrid.getView();
				if(store.getCount() > 0){
					viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
					viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
				}else{
					viewNormal.getFeature('masterGridTotal').toggleSummaryRow(false);
					viewLocked.getFeature('masterGridTotal').toggleSummaryRow(false);
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
			itemId: 'search_panel1',
			layout: {type: 'uniTable', columns: 1},
			defaultType: 'uniTextfield',
			items : [{ 
				fieldLabel: '변동기간',
				xtype: 'uniDateRangefield',
				startFieldName: 'ALTER_DATE_FR',
				endFieldName: 'ALTER_DATE_TO',
				width: 470,
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				allowBlank:false,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('ALTER_DATE_FR',newValue);
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('ALTER_DATE_TO',newValue);
					}
				}
			},{
				fieldLabel: '변동구분'	,
				name:'ALTER_DIVI', 
				xtype: 'uniCombobox', 
				comboType:'AU',
				comboCode:'A091',
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelResult.setValue('ALTER_DIVI', newValue);
					}
				} 
			},
			Unilite.popup('ACCNT', {
				fieldLabel: '계정과목', 
				valueFieldName: 'ACCNT_CODE', 
				textFieldName: 'ACCNT_NAME',
				autoPopup: true,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('ACCNT_CODE', panelSearch.getValue('ACCNT_CODE'));
							panelResult.setValue('ACCNT_NAME', panelSearch.getValue('ACCNT_NAME'));
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('ACCNT_CODE', '');
						panelResult.setValue('ACCNT_NAME', '');
					},
					applyExtParam:{
						scope:this,
						fn:function(popup){
							var param = {
								'ADD_QUERY' : "SPEC_DIVI = 'K' AND SLIP_SW = 'Y' AND GROUP_YN = 'N'",
								'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
							}
							popup.setExtParam(param);
						}
					}
				}
			}),
			Unilite.popup('ASSET', {
				fieldLabel: '자산코드', 
				valueFieldName: 'ASSET_CODE', 
				textFieldName: 'ASSET_NAME', 
				popupWidth: 710,
				autoPopup: true,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('ASSET_CODE', panelSearch.getValue('ASSET_CODE'));
							panelResult.setValue('ASSET_NAME', panelSearch.getValue('ASSET_NAME'));
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('ASSET_CODE', '');
						panelResult.setValue('ASSET_NAME', '');
					}
				}
			}),
			Unilite.popup('ASSET',{ 
				fieldLabel: '~', 
				valueFieldName: 'ASSET_CODE2', 
				textFieldName: 'ASSET_NAME2', 
				popupWidth: 710,
				autoPopup: true,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('ASSET_CODE2', panelSearch.getValue('ASSET_CODE2'));
							panelResult.setValue('ASSET_NAME2', panelSearch.getValue('ASSET_NAME2'));
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('ASSET_CODE2', '');
						panelResult.setValue('ASSET_NAME2', '');
					}
				}
			}),{
				xtype: 'button',
				text: '출력',
				width: 100,
				margin: '0 0 0 120',
				handler : function() {
					var me = this;
					panelSearch.getEl().mask('로딩중...','loading-indicator');
					var param = panelSearch.getValues();
				}
			}]
		},{
			title: '추가정보',
			itemId: 'search_panel2',
			layout: {type: 'uniTable', columns: 1},
			defaultType: 'uniTextfield',
			items : [{
				fieldLabel: '사업장',
				name:'DIV_CODE', 
				xtype: 'uniCombobox',
				multiSelect: true, 
				typeAhead: false,
//				value:UserInfo.divCode,		//20200902 주석: UNILITE와 통일
				comboType:'BOR120',
				width: 325
			},
			Unilite.popup('DEPT', {
				fieldLabel: '부서', 
				popupHeight: 400,
				autoPopup: true
			})]
		}],
		setAllFieldsReadOnly: function(b) {
			var r= true
			if(b) {
				var invalid = this.getForm().getFields().filterBy(function(field) {
					return !field.validate();
				});
				if(invalid.length > 0) {
					r=false;
					var labelText = ''
					if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
						var labelText = invalid.items[0]['fieldLabel']+'은(는)';
					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
						var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
					}
					alert(labelText+Msg.sMB083);
					invalid.items[0].focus();
				} else {
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) )	{
							if (item.holdable == 'hold') {
								item.setReadOnly(true); 
							}
						} 
						if(item.isPopupField)	{
							var popupFC = item.up('uniPopupField')	;
							if(popupFC.holdable == 'hold') {
								popupFC.setReadOnly(true);
							}
						}
					})
				}
			} else {
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) )	{
						if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					} 
					if(item.isPopupField)	{
						var popupFC = item.up('uniPopupField');
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		}
	});	

	var panelResult = Unilite.createSearchForm('resultForm',{
		region: 'north',
		hidden: !UserInfo.appOption.collapseLeftSearch,
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{ 
			fieldLabel: '변동기간',
			xtype: 'uniDateRangefield',
			startFieldName: 'ALTER_DATE_FR',
			endFieldName: 'ALTER_DATE_TO',
			width: 470,
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today'),
			allowBlank:false,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('ALTER_DATE_FR',newValue);
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('ALTER_DATE_TO',newValue);
				}
			}
		},{
			fieldLabel: '변동구분'	,
			name:'ALTER_DIVI', 
			xtype: 'uniCombobox', 
			comboType:'AU',
			comboCode:'A091',
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
					panelSearch.setValue('ALTER_DIVI', newValue);
				}
			} 
		},{
			xtype: 'button',
			text: '출력',
			width: 100,
			margin: '0 0 0 300',
			handler : function() {
				var me = this;
				//panelSearch.getEl().mask('로딩중...','loading-indicator');
				var param = panelSearch.getValues();
			}
		},
		Unilite.popup('ACCNT', {
			fieldLabel: '계정과목', 
			valueFieldName: 'ACCNT_CODE', 
			textFieldName: 'ACCNT_NAME',
			autoPopup: true,
			listeners: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('ACCNT_CODE', panelResult.getValue('ACCNT_CODE'));
						panelSearch.setValue('ACCNT_NAME', panelResult.getValue('ACCNT_NAME'));
					},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.setValue('ACCNT_CODE', '');
					panelSearch.setValue('ACCNT_NAME', '');
				},
				applyExtParam:{
					scope:this,
					fn:function(popup){
						var param = {
							'ADD_QUERY' : "SPEC_DIVI = 'K' AND SLIP_SW = 'Y' AND GROUP_YN = 'N'",
							'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
						}
						popup.setExtParam(param);
					}
				}
			}
		}),
		Unilite.popup('ASSET', {
			fieldLabel: '자산코드', 
			valueFieldName: 'ASSET_CODE', 
			textFieldName: 'ASSET_NAME', 
//					textFieldWidth:170, 
//					validateBlank:false, 
			popupWidth: 710,
			autoPopup: true,
			listeners: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('ASSET_CODE', panelResult.getValue('ASSET_CODE'));
						panelSearch.setValue('ASSET_NAME', panelResult.getValue('ASSET_NAME'));
					},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.setValue('ASSET_CODE', '');
					panelSearch.setValue('ASSET_NAME', '');
				}
			}
		}),
		Unilite.popup('ASSET',{ 
			fieldLabel: '~', 
			valueFieldName: 'ASSET_CODE2', 
			textFieldName: 'ASSET_NAME2', 
//					textFieldWidth: 170, 
//					validateBlank: false, 
			labelWidth:10,
			popupWidth: 710,
			autoPopup: true,
			listeners: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('ASSET_CODE2', panelResult.getValue('ASSET_CODE2'));
						panelSearch.setValue('ASSET_NAME2', panelResult.getValue('ASSET_NAME2'));
					},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.setValue('ASSET_CODE2', '');
					panelSearch.setValue('ASSET_NAME2', '');
				}
			}
		})],
		setAllFieldsReadOnly: function(b) {
			var r= true
			if(b) {
				var invalid = this.getForm().getFields().filterBy(function(field) {
					return !field.validate();
				});
				if(invalid.length > 0) {
					r=false;
					var labelText = ''
	
					if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
						var labelText = invalid.items[0]['fieldLabel']+'은(는)';
					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
						var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
					}
					alert(labelText+Msg.sMB083);
					invalid.items[0].focus();
				} else {
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) )	{
							if (item.holdable == 'hold') {
								item.setReadOnly(true); 
							}
						} 
						if(item.isPopupField)	{
							var popupFC = item.up('uniPopupField');
							if(popupFC.holdable == 'hold') {
								popupFC.setReadOnly(true);
							}
						}
					})
				}
			} else {
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) )	{
						if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					} 
					if(item.isPopupField)	{
						var popupFC = item.up('uniPopupField');
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		}
	});	

	/** Master Grid1 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid = Unilite.createGrid('ass700skrGrid1', {
		store		: directMasterStore, 
		region		: 'center',
		excelTitle	: '자산변동내역조회',
		uniOpt		: {
			useMultipleSorting	: true,
			useLiveSearch		: true,
			onLoadSelectFirst	: true,
			dblClickToEdit		: false,
			useGroupSummary		: true,
			useContextMenu		: false,
			useRowNumberer		: true,
			expandLastColumn	: true,
			useRowContext		: false,
			filter: {
				useFilter		: true,
				autoCreate		: true
			}
		},
		features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true },
					{id : 'masterGridTotal',	ftype: 'uniSummary',	  showSummaryRow: true} ],
		columns:  [		
			{ dataIndex: 'ALTER_DIVI'		, width: 80, hidden: true},
			{ dataIndex: 'ALTER_DIVINM'		, width: 80, locked: true,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
				}
			},
			{ dataIndex: 'SEQ'				, width: 80, hidden: true},
			{ dataIndex: 'ALTER_DATE'		, width: 80, locked: true},
			{ dataIndex: 'ASST'				, width: 150,align:'center', locked: true},
			{ dataIndex: 'ASST_NAME'		, width: 200},
			{ dataIndex: 'ACCNT_NAME'		, width: 100},
			{ dataIndex: 'DRB_YEAR'			, width: 88,align:'right'},
			{ dataIndex: 'ACQ_DATE'			, width: 100},
			{ dataIndex: 'ACQ_AMT_I'		, width: 100,summaryType: 'sum'},
			{ dataIndex: 'ACQ_Q'			, width: 88},
			{ dataIndex: 'ALTER_AMT_I'		, width: 100,summaryType: 'sum'},
			{ dataIndex: 'REMARK'			, width: 200},
			{ dataIndex: 'MONEY_UNIT_NM'	, width: 88,align:'center'},
			{ dataIndex: 'EXCHG_RATE_O'		, width: 66},
			{ dataIndex: 'FOR_ACQ_AMT_I'	, width: 100,summaryType: 'sum'},
			{ dataIndex: 'PRE_DIV_NAME'		, width: 113},
			{ dataIndex: 'PRE_DEPT_NAME'	, width: 120},
			{ dataIndex: 'DIV_NAME'			, width: 113},
			{ dataIndex: 'TREE_NAME'		, width: 120},
			{ dataIndex: 'EX_DATE'			, width: 100},
			{ dataIndex: 'EX_NUM'			, width: 66,align:'center'},
			{ dataIndex: 'AGREE_YN'			, width: 53, hidden: true}
		]
	});



	Unilite.Main({
		id			: 'ass700skrApp',
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
			UniAppManager.setToolbarButtons('save',false);
			UniAppManager.setToolbarButtons('reset',false);

			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('ALTER_DATE_FR');

			var viewNormal = masterGrid.normalGrid.getView();
			var viewLocked = masterGrid.lockedGrid.getView();
			viewNormal.getFeature('masterGridTotal').toggleSummaryRow(false);
			viewLocked.getFeature('masterGridTotal').toggleSummaryRow(false);

			this.setDefault();
		},
		onQueryButtonDown : function()	{
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
				masterGrid.getStore().loadStoreRecords();
				var viewLocked = masterGrid.lockedGrid.getView();
				var viewNormal = masterGrid.normalGrid.getView();
				console.log("viewLocked: ", viewLocked);
				console.log("viewNormal: ", viewNormal);
				viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
				viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
				viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
				viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
//				UniAppManager.setToolbarButtons('reset',true);
			}
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			this.fnInitBinding();
		},
		setDefault: function() {
			panelSearch.setValue('ALTER_DATE_FR',UniDate.get('startOfMonth'));
			panelSearch.setValue('ALTER_DATE_TO',UniDate.get('today'));
			panelResult.setValue('ALTER_DATE_FR',UniDate.get('startOfMonth'));
			panelResult.setValue('ALTER_DATE_TO',UniDate.get('today'));
		},
		checkForNewDetail:function() {
			return panelSearch.setAllFieldsReadOnly(true);
		}
	});
};
</script>