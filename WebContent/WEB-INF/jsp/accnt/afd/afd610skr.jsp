<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="afd610skr" >
	<t:ExtComboStore comboType="BOR120" />						<!-- 사업장 -->
	<t:ExtComboStore comboType="B010" /> 						<!-- 질권여부 -->
	<t:ExtComboStore comboType="AU" comboCode="A089" />			<!-- 차입구분 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

var getStDt = ${getStDt};
var getChargeCode = ${getChargeCode};

function appMain() {
	var providerSTDT ='';
	/**
	 * Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Afd610Model', {
		fields: [
			{name: 'ACCNT'				, text: '계정과목'		, type: 'string'},
			{name: 'ACCNT_NAME'			, text: '계정과목명'		, type: 'string'},
			{name: 'CUSTOM'				, text: '차입처'		, type: 'string'},
			{name: 'CUSTOM_NAME'		, text: '차입처명'		, type: 'string'},
			{name: 'LOAN_GUBUN'			, text: '차입구분'		, type: 'string',comboType:'AU' ,comboCode:'A089' },
			{name: 'LOANNO'				, text: '차입번호'		, type: 'string'},
			{name: 'LOAN_NAME'			, text: '차입명'		, type: 'string'},
			{name: 'ACCOUNT_NUM'		, text: '계좌번호'		, type: 'string'},
			{name: 'PUB_DATE'			, text: '차입일'		, type: 'uniDate'},
			{name: 'EXP_DATE'			, text: '만기일'		, type: 'uniDate'},
			{name: 'RENEW_DATE'			, text: '갱신일'		, type: 'uniDate'},
			{name: 'INT_RATE'			, text: '이율'		, type: 'float', decimalPrecision:2, format:'0,000.00'},
			{name: 'AMT_I'				, text: '차입원화금액'	, type: 'uniPrice'},
			{name: 'REPAY_AMT_I'		, text: '원화상환금액'	, type: 'uniPrice'},
			{name: 'BALANCE_AMT_I'		, text: '잔액'		, type: 'uniPrice'},
			{name: 'REMARK'				, text: '차입내용'		, type: 'string'},
			{name: 'MONEY_UNIT'			, text: '화폐단위'		, type: 'string'},
			{name: 'FOR_AMT_I'			, text: '차입외화금액'	, type: 'uniFC'},
			{name: 'FORREPAY_AMT_I'		, text: '외화상환금액'	, type: 'uniFC'},
			{name: 'FOR_BALANCE_AMT_I'	, text: '외화잔액'		, type: 'uniFC'},
			{name: 'LCNO'				, text: 'l/C번호'		, type: 'string'},
			{name: 'DEPT_CODE'			, text: '차입부서'		, type: 'string'},
			{name: 'TREE_NAME'			, text: '차입부서명'		, type: 'string'}
		]
	});		// End of Ext.define('Afd610skrModel', {
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */
	var directMasterStore = Unilite.createStore('afd610MasterStore1',{
		model: 'Afd610Model',
		uniOpt: {
			isMaster: false,			// 상위 버튼 연결 
			editable: false,			// 수정 모드 사용 
			deletable:false,			// 삭제 가능 여부 
			useNavi : false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {
				read: 'afd610skrService.selectList1'
			}
		},
		loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		groupField: 'ACCNT_NAME'
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
			itemId: 'search_panel1',
			layout: {type: 'uniTable', columns: 1},
			defaultType: 'uniTextfield',
			items: [{
					fieldLabel: '기준일',
					xtype: 'uniDatefield',
					value: UniDate.get('today'),
					//width: 200,
					name: 'AC_DATE',
					allowBlank: false,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('AC_DATE', newValue);
						}
					}
				},{
					fieldLabel: '차입구분',
					name: 'LOAN_GUBUN',
					xtype: 'uniCombobox',
					comboType: 'AU',
					comboCode: 'A089',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('LOAN_GUBUN', newValue);
						}
					}
				},
				Unilite.popup('ACCNT',{
					fieldLabel: '계정과목',
		//			validateBlank:false,
					valueFieldName: 'ACCNT_CODE',
					textFieldName: 'ACCNT_NAME',
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
									'ADD_QUERY' : "ISNULL(SUBSTRING(SPEC_DIVI,1,1),'') IN ('P')",
									'CHARGE_CODE': (Ext.isEmpty(getChargeCode) && Ext.isEmpty(getChargeCode[0])) ? '':getChargeCode[0].SUB_CODE
								}
								popup.setExtParam(param);
							}
						}
						
					}
				}),
				Unilite.popup('CUST',{
					fieldLabel: '차입처',
					allowBlank:true,
					autoPopup:false,
					validateBlank:false,
					valueFieldName: 'CUSTOM_CODE',
					textFieldName: 'CUSTOM_NAME',
					listeners: {
							onValueFieldChange:function( elm, newValue, oldValue) {						
								panelResult.setValue('CUSTOM_CODE', newValue);
								
								if(!Ext.isObject(oldValue)) {
									panelResult.setValue('CUSTOM_NAME', '');
									panelSearch.setValue('CUSTOM_NAME', '');
								}
							},
							onTextFieldChange:function( elm, newValue, oldValue) {
								panelResult.setValue('CUSTOM_NAME', newValue);
								
								if(!Ext.isObject(oldValue)) {
									panelResult.setValue('CUSTOM_CODE', '');
									panelSearch.setValue('CUSTOM_CODE', '');
								}
							}
					}
				})
			]
		},{
			title: '추가정보', 	
			itemId: 'search_panel2',
			layout: {type: 'uniTable', columns: 1},
			defaultType: 'uniTextfield',
			items: [{ 
					fieldLabel: '당기시작년월',
					name:'ST_DATE',
					xtype: 'uniMonthfield',
	//				value: UniDate.get('today'),
					allowBlank:false,
					width: 200
				},{
					fieldLabel: '사업장',
					name:'ACCNT_DIV_CODE',
					xtype: 'uniCombobox',
					multiSelect: true,
					typeAhead: false,
					value:UserInfo.divCode,
					comboType:'BOR120',
					width: 325,
					colspan:2
			},{
				fieldLabel: '일자조건',
				width: 315,
				xtype: 'uniDateRangefield',
				startFieldName: 'DATE_FR',
				endFieldName: 'DATE_TO'
			},{
				xtype: 'radiogroup',
				id: 'rdoSelect',
				fieldLabel: ' ',
				items: [{
					boxLabel: '만기일',
					width: 60,
					name: 'rdoSelect',
					inputValue: 'EXP',
					checked: true  
				},{
					boxLabel : '갱신일',
					width: 60,
					inputValue: 'RENEW',
					name: 'rdoSelect'
				}]
			},
			Unilite.popup('DEPT',{
					fieldLabel: '차입부서',
					popupWidth: 910,
					valueFieldName: 'DEPT_CODE_FR',
					textFieldName: 'DEPT_NAME_FR'
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
					//this.mask();
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) ) {
							if (item.holdable == 'hold') {
								item.setReadOnly(true); 
							}
						} 
						if(item.isPopupField) {
							var popupFC = item.up('uniPopupField');
							if(popupFC.holdable == 'hold') {
								popupFC.setReadOnly(true);
							}
						}
					})
				}
			} else {
				//this.unmask();
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) ) {
						if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					} 
					if(item.isPopupField) {
						var popupFC = item.up('uniPopupField');
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		},
		setLoadRecord: function(record) {
			var me = this;   
			me.uniOpt.inLoading=false;
			me.setAllFieldsReadOnly(true);
		}
	});	//end panelSearch
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 2},
		padding:'1 1 1 1',
		border:true,
		items: [{
				fieldLabel: '기준일',
				xtype: 'uniDatefield',
				value: UniDate.get('today'),
				//width: 200,
				name: 'AC_DATE',
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('AC_DATE', newValue);
					}
				}
			},{
				fieldLabel: '차입구분',
				name: 'LOAN_GUBUN',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'A089',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('LOAN_GUBUN', newValue);
					}
				}
			},
			Unilite.popup('ACCNT',{
				fieldLabel: '계정과목',
	//			validateBlank:false,	 
				valueFieldName: 'ACCNT_CODE',
				textFieldName: 'ACCNT_NAME',
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
								'ADD_QUERY' : "ISNULL(SUBSTRING(SPEC_DIVI,1,1),'') IN ('P')",
								'CHARGE_CODE': (Ext.isEmpty(getChargeCode) && Ext.isEmpty(getChargeCode[0])) ? '':getChargeCode[0].SUB_CODE
							}
							popup.setExtParam(param);
						}
					}
				}
   	 		}),
			Unilite.popup('CUST',{
				fieldLabel: '차입처',
				allowBlank:true,
				autoPopup:false,
				validateBlank:false,
				valueFieldName: 'CUSTOM_CODE',
				textFieldName: 'CUSTOM_NAME',
				listeners: {
							onValueFieldChange:function( elm, newValue, oldValue) {						
								panelSearch.setValue('CUSTOM_CODE', newValue);
								
								if(!Ext.isObject(oldValue)) {
									panelResult.setValue('CUSTOM_NAME', '');
									panelSearch.setValue('CUSTOM_NAME', '');
								}
							},
							onTextFieldChange:function( elm, newValue, oldValue) {
								panelSearch.setValue('CUSTOM_NAME', newValue);
								
								if(!Ext.isObject(oldValue)) {
									panelResult.setValue('CUSTOM_CODE', '');
									panelSearch.setValue('CUSTOM_CODE', '');
								}
							}
				}
			})
		],
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
					//this.mask();
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) ) {
							if (item.holdable == 'hold') {
								item.setReadOnly(true); 
							}
						}
						if(item.isPopupField) {
							var popupFC = item.up('uniPopupField');
							if(popupFC.holdable == 'hold') {
								popupFC.setReadOnly(true);
							}
						}
					})
				}
			} else {
				//this.unmask();
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) ) {
						if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					} 
					if(item.isPopupField) {
						var popupFC = item.up('uniPopupField');
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		},
		setLoadRecord: function(record) {
			var me = this;
			me.uniOpt.inLoading=false;
			me.setAllFieldsReadOnly(true);
		}
	});
	
	/**
	 * Master Grid1 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid = Unilite.createGrid('afd610Grid1', {
		layout : 'fit',
		region : 'center',
		uniOpt:{
			useMultipleSorting	: true,
			useLiveSearch		: true,
			onLoadSelectFirst	: false,
			dblClickToEdit		: false,
			useGroupSummary		: true,
			useContextMenu		: false,
			useRowNumberer		: true,
			expandLastColumn	: true,
			useRowContext		: true,
			filter: {
				useFilter		: true,
				autoCreate		: true
			},
			excel: {
				useExcel: true,			//엑셀 다운로드 사용 여부
				exportGroup : true,		//group 상태로 export 여부
				onlyData:false,
				summaryExport:true
			}
		},
		store: directMasterStore,
		features: [{
			id: 'masterGridSubTotal',
			ftype: 'uniGroupingsummary',
			showSummaryRow: true 
		},{
			id: 'masterGridTotal',
			ftype: 'uniSummary',
			showSummaryRow: true
		}],
		columns: [
			{dataIndex: 'ACCNT'					, width: 0, hidden: true},
			{dataIndex: 'ACCNT_NAME'			, width: 100, align:'center',
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
			}},
			{dataIndex: 'CUSTOM'				, width: 0, hidden: true},
			{dataIndex: 'CUSTOM_NAME'			, width: 100},
			{dataIndex: 'LOAN_GUBUN'			, width: 100},
			{dataIndex: 'LOANNO'				, width: 73},
			{dataIndex: 'LOAN_NAME'				, width: 133},
			{dataIndex: 'ACCOUNT_NUM'			, width: 120},
			{dataIndex: 'PUB_DATE'				, width: 80},
			{dataIndex: 'EXP_DATE'				, width: 80},
			{dataIndex: 'RENEW_DATE'			, width: 80},
			{dataIndex: 'INT_RATE'				, width: 66},
			{dataIndex: 'AMT_I'					, width: 100, summaryType: 'sum'},
			{dataIndex: 'REPAY_AMT_I'			, width: 100, summaryType: 'sum'},
			{dataIndex: 'BALANCE_AMT_I'			, width: 100, summaryType: 'sum'},
			{dataIndex: 'REMARK'				, width: 200},
			{dataIndex: 'MONEY_UNIT'			, width: 66},
			{dataIndex: 'FOR_AMT_I'				, width: 100, summaryType: 'sum'},
			{dataIndex: 'FORREPAY_AMT_I'		, width: 100, summaryType: 'sum'},
			{dataIndex: 'FOR_BALANCE_AMT_I'		, width: 100, summaryType: 'sum'},
			{dataIndex: 'LCNO'					, width: 100},
			{dataIndex: 'DEPT_CODE'				, width: 100, hidden: true},
			{dataIndex: 'TREE_NAME'				, width: 100}
		]
	});	
	
	 Unilite.Main( {
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
		id : 'afd610App',
		fnInitBinding : function() {
			if(!UserInfo.appOption.collapseLeftSearch) {
				activeSForm = panelSearch;
			} else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('AC_DATE');
			panelSearch.setValue('ACCNT_DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			panelSearch.setValue('ST_DATE',getStDt[0].STDT);
		},
		onQueryButtonDown : function()	{
			if(panelSearch.setAllFieldsReadOnly(true) == false){
				return false;
			}
			if(panelResult.setAllFieldsReadOnly(true) == false){
				return false;
			}
			directMasterStore.loadStoreRecords();
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		},
		fnSetStDate:function(newValue) {
			if(newValue == null){
				return false;
			}else{
				if(UniDate.getDbDateStr(newValue).substring(0, 6) < (UniDate.getDbDateStr(newValue).substring(0, 4) + UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6))){
					panelSearch.setValue('ST_DATE', UniDate.getDbDateStr(newValue).substring(0, 4)-1 + UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6));
				}else{
					panelSearch.setValue('ST_DATE', UniDate.getDbDateStr(newValue).substring(0, 4) + UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6));
				}
			}
		}
	});
};


</script>
