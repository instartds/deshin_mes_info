<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="afd600ukr">
	<t:ExtComboStore comboType="BOR120" />					<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A089" />		<!-- 차입구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B004" />		<!-- 화폐단위 -->
	<t:ExtComboStore comboType="AU" comboCode="A090" />		<!-- 상환주기 -->
	<t:ExtComboStore comboType="AU" comboCode="A241" />		<!-- 이자구분 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {
	color: #333333;
	font-weight: normal;
	padding: 1px 2px;
}
</style>
<script type="text/javascript">

var gsChargeCode  = Ext.isEmpty(${getChargeCode}) ? ['']: ${getChargeCode};		//ChargeCode 관련 전역변수

var BsaCodeInfo = {	// 컨트롤러에서 값을 받아옴
	 gsMoneyUnit:		'${gsMoneyUnit}'
	,gsAmtPoint:		'${gsAmtPoint}'
};

function appMain() {   
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'afd600ukrService.selectList',
			create: 'afd600ukrService.insertDetail',
			update: 'afd600ukrService.updateDetail',
			destroy: 'afd600ukrService.deleteDetail',
			syncAll: 'afd600ukrService.saveAll'
		}
	});
	/**
	 * Model 정의
	 * @type
	 */
	Unilite.defineModel('Afd600ukrModel', {
		fields: [
			{name: 'ACCNT'				, text: '계정과목'			,type: 'string'},
			{name: 'ACCNT_NAME'			, text: '계정과목명'			,type: 'string'},
			{name: 'AC_CODE1'			, text: '관리항목1'			,type: 'string'}, //거래처 구분 조건
			{name: 'LOANNO'				, text: '차입번호'			,type: 'string'},
			{name: 'LOAN_NAME'			, text: '차입명'			,type: 'string'},
			{name: 'ACCOUNT_NUM'		, text: '계좌번호(DB)'		,type: 'string'},
			{name: 'ACCOUNT_NUM_EXPOS'	, text: '계좌번호'			,type : 'string'}, 
			{name: 'CUSTOM'				, text: '차입처'			,type: 'string'},
			{name: 'CUSTOM_NAME'		, text: '차입처명'			,type: 'string'},
			{name: 'DIV_CODE'			, text: '사업장'			,type: 'string'},
			{name: 'DEPT_CODE'			, text: '차입부서'			,type: 'string'},
			{name: 'DEPT_NAME'			, text: '차입부서명'			,type: 'string'},
			{name: 'LOAN_GUBUN'			, text: '차입구분'			,type: 'string', comboType: 'AU', comboCode: 'A089'},
			{name: 'PUB_DATE'			, text: '차입일'			,type: 'uniDate'},
			{name: 'EXP_DATE'			, text: '만기일'			,type: 'uniDate'},
			{name: 'RENEW_DATE'			, text: '갱신일'			,type: 'uniDate'},
			{name: 'AMT_I'				, text: '차입금액'			,type: 'uniPrice'},
			{name: 'MONEY_UNIT'			, text: '화폐'			,type: 'string'},
			{name: 'EXCHG_RATE_O'		, text: '차입환율'			,type: 'uniER'},
			{name: 'FOR_AMT_I'			, text: '외화차입금액'		,type: 'uniFC'},
			{name: 'REMARK'				, text: '차입내용'			,type: 'string'},
			{name: 'INT_RATE'			, text: '이율'			,type: 'uniER'},
			{name: 'LCNO'				, text: 'L/C번호'			,type: 'string'},
			{name: 'REPAY_PERIOD'		, text: '차입상환주기'		,type: 'string'},
			{name: 'INT_PERIOD'			, text: '이자지급주기'		,type: 'string'},
			{name: 'FG_INT'				, text: '이자구분'			,type: 'string', comboType: 'AU' , comboCode: 'A241'},
			{name: 'MORTGAGE'			, text: '담보현황'			,type: 'string'},
			{name: 'REPAY_DATE'			, text: '차입금상환만료일'		,type: 'uniDate'},
			{name: 'EX_DATE'			, text: '결의전표일'			,type: 'uniDate'},
			{name: 'EX_NUM'				, text: '결의전표번호'		,type: 'string'},
			{name: 'AGREE_YN'			, text: '승인여부'			,type: 'string'},
			{name: 'AC_DATE'			, text: '회계전표일' 		,type: 'string'},
			{name: 'SLIP_NUM'			, text: '회계전표번호'		,type: 'string'},
			{name: 'REPAY_AMT_I'		, text: '원화상환금액'		,type: 'uniPrice'},
			{name: 'FORREPAY_AMT_I'		, text: '외화상환금액'		,type: 'uniFC'},
			{name: 'TERM_LOAN'			, text: '거치기간'			,type: 'int'}, 
			{name: 'TERM_PRINCIPAL'		, text: '상환기간'			,type: 'int'},
			{name: 'TEMPC_01'			, text: '상환조건'			,type: 'string'},
			{name: 'NOW_RATE'			, text: '표시현이율'			,type: 'uniER'}
		]
	});
	
	// GroupField string type으로 변환
	function dateToString(v, record){
		return UniDate.safeFormat(v);
	}
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */
	var directMasterStore = Unilite.createStore('afd600ukrMasterStore1',{
		model: 'Afd600ukrModel',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결 
			editable: true,			// 수정 모드 사용 
			deletable:true,			// 삭제 가능 여부 
			useNavi : false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: directProxy,
		loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore : function(config)	{
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
			var toUpdate = this.getUpdatedRecords();
			console.log("toUpdate",toUpdate);
			
			var rv = true;
			
			if(inValidRecs.length == 0 )	{
				config = {
					success: function(batch, option) {
						panelResult.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);
					 }
				};
				this.syncAllDirect(config);
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
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
			title: '기본정보', 	
			itemId: 'search_panel1',
			layout: {type: 'uniTable', columns: 1},
			defaultType: 'uniTextfield',
			items: [{ 
				fieldLabel: '기준일',
				xtype: 'uniDateRangefield',
				startFieldName: 'FR_EXDATE',
				endFieldName: 'TO_EXDATE',
				//startDate: UniDate.get('startOfMonth'),
				//endDate: UniDate.get('today'),
				//allowBlank: false,
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('FR_EXDATE',newValue);
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('TO_EXDATE',newValue);
					}
				}
			},{
				xtype: 'radiogroup',
				fieldLabel: ' ',
				items: [{
					boxLabel: '만기일',
					width: 70,
					name: 'DATE_GUBUN',
					inputValue: 'EXP',
					checked: true
				},{
					boxLabel : '갱신일',
					width: 70,
					name: 'DATE_GUBUN',
					inputValue: 'RENEW'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						if(!directMasterStore.isDirty())	{
							panelResult.getField('DATE_GUBUN').setValue(newValue.DATE_GUBUN);
							directMasterStore.loadStoreRecords();
						}
					}
				}
			},{
				fieldLabel: '사업장',
				name:'ACCNT_DIV_CODE', 
				xtype: 'uniCombobox',
				multiSelect: true, 
				typeAhead: false,
				value:UserInfo.divCode,
				comboType:'BOR120',
				width: 325,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ACCNT_DIV_CODE', newValue);
					}
				}
			},
				Unilite.popup('ACCNT',{ 
						fieldLabel: '계정과목', 
						valueFieldName: 'ACCOUNT_CODE',
						textFieldName: 'ACCOUNT_NAME',
						listeners: {
							onSelected: {
								fn: function(records, type) {
									panelResult.setValue('ACCOUNT_CODE', panelSearch.getValue('ACCOUNT_CODE'));
									panelResult.setValue('ACCOUNT_NAME', panelSearch.getValue('ACCOUNT_NAME'));
								},
								scope: this
							},
							onClear: function(type)	{
								panelResult.setValue('ACCOUNT_CODE', '');
								panelResult.setValue('ACCOUNT_NAME', '');
							},
							applyExtParam:{
								scope:this,
								fn:function(popup){
									var param = {
										'ADD_QUERY' : "ISNULL(SUBSTRING(SPEC_DIVI,1,1),'') IN ('P')",
										'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
									}
									popup.setExtParam(param);
								}
							}
						}
				}),
				Unilite.popup('CUST',{
					fieldLabel: '차입처',
					popupWidth: 600,
					allowBlank:true,
					autoPopup:false,
					validateBlank:false,					
					valueFieldName: 'CON_CUSTOM_CODE',
					textFieldName: 'CON_CUSTOM_NAME',
					listeners: {
						onValueFieldChange:function( elm, newValue, oldValue) {						
							panelResult.setValue('CON_CUSTOM_CODE', newValue);
							
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('CON_CUSTOM_NAME', '');
								panelSearch.setValue('CON_CUSTOM_NAME', '');
							}
						},
						onTextFieldChange:function( elm, newValue, oldValue) {
							panelResult.setValue('CON_CUSTOM_NAME', newValue);
							
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('CON_CUSTOM_CODE', '');
								panelSearch.setValue('CON_CUSTOM_CODE', '');
							}
						},
						onTextSpecialKey: function(elm, e){
							UniAppManager.app.onQueryButtonDown();
						}
					}
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
							var popupFC = item.up('uniPopupField') ;
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
		}
	});	//end panelSearch
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [
			{ 
				fieldLabel: '기준일',
				xtype: 'uniDateRangefield',
				startFieldName: 'FR_EXDATE',
				endFieldName:'TO_EXDATE',
				width: 315,
				//allowBlank: false,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelSearch) {
						panelSearch.setValue('FR_EXDATE',newValue);
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelSearch) {
						panelSearch.setValue('TO_EXDATE',newValue);
					}
				}
			},{
				xtype: 'radiogroup',
				//fieldLabel: ' ',
				padding: '0 0 0 0',
				items: [{
					boxLabel: '만기일',
					width: 70, 
					name: 'DATE_GUBUN',
					inputValue: 'EXP',
					checked: true
				},{
					boxLabel : '갱신일',
					width: 70,
					name: 'DATE_GUBUN',
					inputValue: 'RENEW'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						if(!directMasterStore.isDirty())	{
							panelSearch.getField('DATE_GUBUN').setValue(newValue.DATE_GUBUN);
							directMasterStore.loadStoreRecords();
						}
					}
				}
			},{
				fieldLabel: '사업장',
				name:'ACCNT_DIV_CODE',
				xtype: 'uniCombobox',
				multiSelect: true,
				typeAhead: false,
				value:UserInfo.divCode,
				comboType:'BOR120',
				padding: '0 0 0 -80',
				width: 325,
				colspan:2,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('ACCNT_DIV_CODE', newValue);
					}
				}
			},
			Unilite.popup('ACCNT',{
					fieldLabel: '계정과목',
					valueFieldName: 'ACCOUNT_CODE',
					textFieldName: 'ACCOUNT_NAME',
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelSearch.setValue('ACCOUNT_CODE', panelResult.getValue('ACCOUNT_CODE'));
								panelSearch.setValue('ACCOUNT_NAME', panelResult.getValue('ACCOUNT_NAME'));
							},
							scope: this
						},
						onClear: function(type)	{
							panelSearch.setValue('ACCOUNT_CODE', '');
							panelSearch.setValue('ACCOUNT_NAME', '');
						},
						applyExtParam:{
							scope:this,
							fn:function(popup){
								var param = {
									'ADD_QUERY' : "ISNULL(SUBSTRING(SPEC_DIVI,1,1),'') IN ('P')",
									'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
								}
								popup.setExtParam(param);
							}
						}
					}
			}),
			Unilite.popup('CUST',{
				fieldLabel: '차입처',
				popupWidth: 600,
				padding: '0 0 0 245',
				allowBlank:true,
				autoPopup:false,
				validateBlank:false,				
				valueFieldName: 'CON_CUSTOM_CODE',
				textFieldName: 'CON_CUSTOM_NAME',
				listeners: {
					onValueFieldChange:function( elm, newValue, oldValue) {						
						panelSearch.setValue('CON_CUSTOM_CODE', newValue);
						
						if(!Ext.isObject(oldValue)) {
							panelResult.setValue('CON_CUSTOM_NAME', '');
							panelSearch.setValue('CON_CUSTOM_NAME', '');
						}
					},
					onTextFieldChange:function( elm, newValue, oldValue) {
						panelSearch.setValue('CON_CUSTOM_NAME', newValue);
						
						if(!Ext.isObject(oldValue)) {
							panelResult.setValue('CON_CUSTOM_CODE', '');
							panelSearch.setValue('CON_CUSTOM_CODE', '');
						}
					},
					onTextSpecialKey: function(elm, e){
						UniAppManager.app.onQueryButtonDown();
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
							var popupFC = item.up('uniPopupField') ;
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
		}
	});	//end panelSearch 
	
	var inputTable = Unilite.createForm('detailForm', { //createForm
		layout : {type : 'uniTable', columns : 3},
		autoScroll:true,
		//disabled: false,
		border:true,
		padding:'1 1 1 1',
		region: 'center',
		masterGrid: masterGrid,
		items: [{
				layout: {type:'uniTable', column:2},
				xtype: 'container',
				items: [{
					fieldLabel: '차입번호',
					//labelWidth: 140,
					xtype: 'uniTextfield',
					allowBlank: false,
					name: 'LOANNO',
					flex:2,
					width:155
				},{
					xtype: 'uniTextfield',
					name: 'LOAN_NAME',
					allowBlank: false,
					flex:1,
					width:153,
					listeners: {
						specialKey: function(elm, e){
							if (e.getKey() == e.ENTER) {
								inputTable.getField('MONEY_UNIT').focus();
							}
						}
					}
				}]
			},{ 
		 		fieldLabel: '화폐단위',
		 		name:'MONEY_UNIT',
		 		xtype: 'uniCombobox',
			 	allowBlank: false,
		 		comboType:'AU',
		 		comboCode:'B004',
		 		displayField: 'value',
			 	labelWidth:90,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						var count = masterGrid.getStore().getCount();
						if(count > 0) {
							if(inputTable.getValue('MONEY_UNIT') == BsaCodeInfo.gsMoneyUnit) {
								inputTable.getField('EXCHG_RATE_O').setReadOnly(true);
								inputTable.getField('FOR_AMT_I').setReadOnly(true);
							} else {
								inputTable.getField('EXCHG_RATE_O').setReadOnly(false);
								inputTable.getField('FOR_AMT_I').setReadOnly(false);
							}
						} else {
							if(inputTable.getValue('MONEY_UNIT') == BsaCodeInfo.gsMoneyUnit) {
								inputTable.setValue('EXCHG_RATE_O', '0');
								inputTable.setValue('FOR_AMT_I', '0');
								inputTable.setValue('AMT_I', '0');
								inputTable.getField('EXCHG_RATE_O').setReadOnly(true);
								inputTable.getField('FOR_AMT_I').setReadOnly(true);
							} else {
								inputTable.getField('EXCHG_RATE_O').setReadOnly(false);
								inputTable.getField('FOR_AMT_I').setReadOnly(false);
							}
						}
					},
					specialKey: function(elm, e){
						if (e.getKey() == e.ENTER) {
							inputTable.getField('REPAY_PERIOD').focus();
						}
					}
				}
			},{ 
				fieldLabel: '차입상환주기',
				name:'REPAY_PERIOD',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'A090',
				listeners: {
					specialKey: function(elm, e){
						if (e.getKey() == e.ENTER) {
							inputTable.getField('ACCNT').focus();
						}
					}
				}
			},
			Unilite.popup('ACCNT',{ 
					fieldLabel: '계정과목',
//					textFieldWidth: 170,
					validateBlank: false,
					allowBlank: false,
					popupWidth: 500,
					valueFieldName: 'ACCNT',
					textFieldName: 'ACCNT_NAME',
					listeners: {
						onSelected:function(records){
							if(records && records.length > 0)	{
								inputTable.setValue("AC_CODE1", records[0].AC_CODE1);
							}
						},
						onClear:function()	{
							inputTable.setValue("AC_CODE1", "");
						},
						onTextSpecialKey: function(elm, e){
							if(inputTable.getField('MONEY_UNIT').getValue() != 'KRW'){
								if (e.getKey() == e.ENTER) {
									inputTable.getField('EXCHG_RATE_O').focus();
								}
							}else{
								if (e.getKey() == e.ENTER) {
									inputTable.getField('INT_PERIOD').focus();
								}
							}
						},
						applyExtParam:{
							scope:this,
							fn:function(popup){
								var param = {
									'ADD_QUERY' : "ISNULL(SUBSTRING(SPEC_DIVI,1,1),'') IN ('P')",
									'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
								}
								popup.setExtParam(param);
							}
						}
						
					}
			}),{
			 	xtype: 'uniTextfield',
				name:'AC_CODE1',
				hidden:true
			},{
				fieldLabel: '환율',
				xtype: 'uniNumberfield',
				labelWidth:90,
				name: 'EXCHG_RATE_O',
				type:"uniER",
				listeners: {
					blur: function(field) {
						if(!inputTable.uniOpt.inLoading)	{
							var newValue = field.getValue()
							if(newValue > 0)	{
								var numDigit = 0;
								if(UniFormat.Price.indexOf(".") > -1) {
									numDigit = (UniFormat.Price.length - (UniFormat.Price.indexOf(".")+1));
								}
								inputTable.setValue('AMT_I', UniAccnt.fnAmtWonCalc((newValue * inputTable.getValue('FOR_AMT_I')), BsaCodeInfo.gsAmtPoint, numDigit));
							} else {
								inputTable.setValue('AMT_I', 0);
							}
						}
					},
					specialKey: function(elm, e){
						if (e.getKey() == e.ENTER) {
							inputTable.getField('INT_PERIOD').focus();
						}
					}
				}
			},{ 
				fieldLabel: '이자지급주기',
				name:'INT_PERIOD', 
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'A090',
				listeners: {
					specialKey: function(elm, e){
						if (e.getKey() == e.ENTER) {
							inputTable.getField('DIV_CODE').focus();
						}
					}
				}
			},{ 
				fieldLabel: '사업장',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				allowBlank: false,
				value : '01',
				comboType: 'BOR120',
				listeners: {
					specialKey: function(elm, e){
						if (e.getKey() == e.ENTER) {
							inputTable.getField('FOR_AMT_I').focus();
						}
					}
				}
			},{
				fieldLabel: '외화차입금액',
				xtype: 'uniNumberfield',
				labelWidth:90,
				name: 'FOR_AMT_I',
				listeners: {
					blur: function(field, newValue, oldValue, eOpts) {
						var newValue = field.getValue()
						if(newValue > 0)	{
							var numDigit = 0;
							if(UniFormat.Price.indexOf(".") > -1) {
								numDigit = (UniFormat.Price.length - (UniFormat.Price.indexOf(".")+1));
							}
							inputTable.setValue('AMT_I', UniAccnt.fnAmtWonCalc((newValue * inputTable.getValue('EXCHG_RATE_O')), BsaCodeInfo.gsAmtPoint, numDigit));
						} else {
							inputTable.setValue('AMT_I', 0);
						}
					},
					specialKey: function(elm, e){
						if (e.getKey() == e.ENTER) {
							inputTable.getField('FG_INT').focus();
						}
					}
				}
			},{
				xtype: 'uniCombobox',
				fieldLabel: '이자구분',
				padding: '0 0 0 0',
				name : 'FG_INT',
				allowBlank:false,
				comboType:"AU",
				comboCode:"A241",
				listeners: {
					specialKey: function(elm, e){
						if (e.getKey() == e.ENTER) {
							inputTable.getField('CUSTOM').focus();
						}
					}
				}
			},{
				fieldLabel: '상환금액',
				xtype: 'uniNumberfield',
				name: 'REPAY_AMT_I',
				readOnly: true
			},
				Unilite.popup('CUST',{
					fieldLabel: '차입처',
					allowBlank:false,
					popupWidth: 600,
					valueFieldName: 'CUSTOM',
					textFieldName: 'CUSTOM_NAME',
					listeners: {
						onTextSpecialKey: function(elm, e){
							if (e.getKey() == e.ENTER) {
								inputTable.getField('AMT_I').focus();
							}
						},
						applyExtParam:{
							scope:this,
							fn:function(popup){
								var acCode = inputTable.getValue("AC_CODE1");
								var param = {};
								if(acCode == "A3")	{
									param = {'CUSTOM_TYPE':"4"}
								} else if(acCode == "A4")	{
									param = {'CUSTOM_TYPE':["1","2","3"]}
								} else 	{
									param = {'CUSTOM_TYPE':["1","2","3","4"]}
								}
								popup.setExtParam(param);
							}
						}
					}
			}),{
				fieldLabel: '차입금액',
				xtype: 'uniNumberfield',
				allowBlank: false,
				labelWidth:90,
				name: 'AMT_I',
				listeners: {
					specialKey: function(elm, e){
						if (e.getKey() == e.ENTER) {
							inputTable.getField('DEPT_CODE').focus();
						}
					}
				}
			},{
				fieldLabel: '외화상환금액',
				xtype: 'uniNumberfield',
				name: 'FORREPAY_AMT_I',
				readOnly: true
			},
				Unilite.popup('DEPT',{
					fieldLabel: '차입부서',
					popupWidth: 600,
					valueFieldName: 'DEPT_CODE',
					textFieldName: 'DEPT_NAME',
					listeners: {
						onTextSpecialKey: function(elm, e){
							if (e.getKey() == e.ENTER) {
								inputTable.getField('PUB_DATE').focus();
							}
						}
					}
			}),{
				fieldLabel: '차입일',
				xtype: 'uniDatefield',
				allowBlank: false,
				labelWidth:90,
				name: 'PUB_DATE',
				listeners: {
					specialKey: function(elm, e){
						if (e.getKey() == e.ENTER) {
							inputTable.getField('LCNO').focus();
						}
					}
				}
			},{
				fieldLabel: 'L/C번호',
				xtype: 'uniTextfield',
				name: 'LCNO',
				listeners: {
					specialKey: function(elm, e){
						if (e.getKey() == e.ENTER) {
							inputTable.getField('LOAN_GUBUN').focus();
						}
					}
				}
			},{ 
				fieldLabel: '차입구분',
				name:'LOAN_GUBUN',
				allowBlank: false,
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'A089',
				listeners: {
					specialKey: function(elm, e){
						if (e.getKey() == e.ENTER) {
							inputTable.getField('EXP_DATE').focus();
						}
					}
				}
			},{
				fieldLabel: '만기일',
				xtype: 'uniDatefield',
				allowBlank: false,
				labelWidth:90,
				name: 'EXP_DATE',
				listeners: {
					specialKey: function(elm, e){
						if (e.getKey() == e.ENTER) {
							inputTable.getField('INT_RATE').focus();
						}
					}
				}
			},{
				fieldLabel: '결의전표번호',
				xtype: 'uniTextfield',
				name: 'EX_NUM',
				readOnly: true
			},{
				fieldLabel: '차입이율',
				xtype: 'uniNumberfield',
				name: 'INT_RATE',
				decimalPrecision:2,
				validateBlank:false,
				suffixTpl: '%',
				listeners: {
					specialKey: function(elm, e){
						if (e.getKey() == e.ENTER) {
							inputTable.getField('REPAY_DATE').focus();
						}
					}
				}
			},{
				fieldLabel: '차입금상환만료일',
				labelWidth:90,
				xtype: 'uniDatefield',
				name: 'REPAY_DATE',
				listeners: {
					specialKey: function(elm, e){
						if (e.getKey() == e.ENTER) {
							inputTable.getField('RENEW_DATE').focus();
						}
					}
				}
			},{
				fieldLabel: '회계전표번호',
				xtype: 'uniTextfield',
				name: 'SLIP_NUM',
				readOnly: true
			},{ 
				fieldLabel:'계좌번호',
				name :'ACCOUNT_NUM_EXPOS',
				xtype: 'uniTextfield',
				readOnly:false,
				focusable:false,
				//hideLabel:true,
				listeners:{
					afterrender:function(field)	{
						field.getEl().on('dblclick', Ext.emptyFn);
						field.getEl().on('click', field.onDblclick);
					},
					change:function(field, newValue, oldValue)	{
						if(newValue != '**************')	{
							field.onDblclick();
							return false;
						}
					}
				},
				onDblclick:function(event, elm)	{
					inputTable.openCryptAcntNumPopup();
				}
			},
			{
				fieldLabel: '계좌번호',
				xtype: 'uniTextfield',
				//enforceMaxLength: true,
				//maxLength:32,
				name: 'ACCOUNT_NUM',
				hidden: true,
				listeners: {
					specialKey: function(elm, e){
						if (e.getKey() == e.ENTER) {
							inputTable.getField('TERM_LOAN').focus();
						}
					}
				}
			},{
				fieldLabel: '갱신일',
				xtype: 'uniDatefield',
				name: 'RENEW_DATE',
				labelWidth:90,
				colspan:2,
				listeners: {
					specialKey: function(elm, e){
						if (e.getKey() == e.ENTER) {
							inputTable.getField('TERM_LOAN').focus();
						}
					}
				}
			},{
				fieldLabel: '거치기간',
				xtype: 'uniNumberfield',
				name: 'TERM_LOAN',
				listeners: {
					specialKey: function(elm, e){
						if (e.getKey() == e.ENTER) {
							inputTable.getField('TERM_PRINCIPAL').focus();
						}
					}
				}
			},{
				fieldLabel: '상환기간',
				labelWidth:108,
				xtype: 'uniNumberfield',
				name: 'TERM_PRINCIPAL',
				listeners: {
					specialKey: function(elm, e){
						if (e.getKey() == e.ENTER) {
							inputTable.getField('TEMPC_01').focus();
						}
					}
				}
			},{
				fieldLabel: '상환조건', 
				xtype: 'uniTextfield',
				//enforceMaxLength: true,
				//maxLength:32,
				name: 'TEMPC_01',
				listeners: {
					specialKey: function(elm, e){
						if (e.getKey() == e.ENTER) {
							inputTable.getField('REMARK').focus();
						}
					}
				}
			},{
				fieldLabel: '차입내용',
				xtype: 'textareafield',
				name: 'REMARK',
				height : 40,
				width: 550,
				rowspan:2,
				listeners: {
					specialKey: function(elm, e){
						if (e.getKey() == e.ENTER) {
							inputTable.getField('MORTGAGE').focus();
						}
					}
				}
			},{
				fieldLabel: '담보현황',
				xtype: 'textareafield',
				name: 'MORTGAGE',
				height : 40,
				labelWidth:108,
				width: 550,
				rowspan:2,
				listeners: {
					specialKey: function(elm, e){
						if (e.getKey() == e.ENTER) {
							inputTable.getField('NOW_RATE').focus();
						}
					}
				}
			},{
				fieldLabel: '표시현이율',
				xtype: 'uniNumberfield',
				name: 'NOW_RATE',
				decimalPrecision:2,
				validateBlank:false,
				suffixTpl: '%'
			}],
			openCryptAcntNumPopup:function()	{
				var record = this;
				if(this.activeRecord)	{
					var params = {'BANK_ACCOUNT':this.getValue('ACCOUNT_NUM'), 'GUBUN_FLAG': '2', 'INPUT_YN': 'Y'};
					//Unilite.popupCryptCipherCardNo('form', record, 'CRDT_FULL_NUM_EXPOS', 'CRDT_FULL_NUM', params);
					Unilite.popupCipherComm('form', record, 'ACCOUNT_NUM_EXPOS', 'ACCOUNT_NUM', params);
				}
			},
			loadForm: function(record)	{
				// window 오픈시 form에 Data load
				var count = masterGrid.getStore().getCount();
				if(count > 0) {
					this.reset();
					this.setActiveRecord(record[0] || null);
					this.resetDirtyStatus();
				}
			},
//			api: {
//				submit: 'afd600ukrService.syncMaster'
//			},
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
		}
	});
	
	/**
	 * Master Grid1 정의(Grid Panel)
	 * @type 
	 */
	
	var masterGrid = Unilite.createGrid('afd600ukrGrid1', {
		layout : 'fit',
		region : 'center',
		store : directMasterStore, 
		uniOpt:{
			useMultipleSorting	: true,
			useLiveSearch		: false,
			onLoadSelectFirst	: true,
			dblClickToEdit		: false,
			useGroupSummary		: true,
			useContextMenu		: false,
			useRowNumberer		: true,
			expandLastColumn	: true,
			useRowContext		: false,	// rink 항목이 있을경우만 true
			filter: {
				useFilter	: false,
				autoCreate	: true
			}
		},
		store: directMasterStore,
		features: [{
			id: 'masterGridSubTotal',
			ftype: 'uniGroupingsummary',
			showSummaryRow: false 
			},{
			id: 'masterGridTotal',
			ftype: 'uniSummary',
			showSummaryRow: false
		}],
		columns: [
			{dataIndex: 'ACCNT'					, width: 100 , hidden: true},
			{dataIndex: 'ACCNT_NAME'			, width: 100 },
			{dataIndex: 'LOANNO'				, width: 100},
			{dataIndex: 'LOAN_NAME'				, width: 160 },
			{dataIndex: 'ACCOUNT_NUM'			, width: 150, hidden: true},
			{dataIndex: 'ACCOUNT_NUM_EXPOS'		, width: 150},
			{dataIndex: 'CUSTOM'				, width: 120 , hidden: true},
			{dataIndex: 'CUSTOM_NAME'			, width: 100},
			{dataIndex: 'DIV_CODE'				, width: 100 , hidden: true},
			{dataIndex: 'DEPT_CODE'				, width: 100 , hidden: true},
			{dataIndex: 'DEPT_NAME'				, width: 100 , hidden: true},
			{dataIndex: 'LOAN_GUBUN'			, width: 100},
			{dataIndex: 'PUB_DATE'				, width: 100},
			{dataIndex: 'EXP_DATE'				, width: 80},
			{dataIndex: 'RENEW_DATE'			, width: 80},
			{dataIndex: 'AMT_I'					, width: 80},
			{dataIndex: 'MONEY_UNIT'			, width: 100},
			{dataIndex: 'EXCHG_RATE_O'			, width: 66  , hidden: true},
			{dataIndex: 'FOR_AMT_I'				, width: 95},
			{dataIndex: 'REMARK'				, width: 200},
			{dataIndex: 'INT_RATE'				, width: 200 , hidden: true},
			{dataIndex: 'LCNO'					, width: 100 , hidden: true},
			{dataIndex: 'REPAY_PERIOD'			, width: 100 , hidden: true},
			{dataIndex: 'INT_PERIOD'			, width: 100 , hidden: true},
			{dataIndex: 'FG_INT'				, width: 100 , hidden: true},
			{dataIndex: 'MORTGAGE'				, width: 100 , hidden: true},
			{dataIndex: 'REPAY_DATE'			, width: 100 , hidden: true},
			{dataIndex: 'EX_DATE'				, width: 100 , hidden: true},
			{dataIndex: 'EX_NUM'				, width: 100 , hidden: true},
			{dataIndex: 'AGREE_YN'				, width: 100 , hidden: true},
			{dataIndex: 'AC_DATE'				, width: 100 , hidden: true},
			{dataIndex: 'SLIP_NUM'				, width: 100 , hidden: true},
			{dataIndex: 'REPAY_AMT_I'			, width: 100 , hidden: true},
			{dataIndex: 'FORREPAY_AMT_I'		, width: 100 , hidden: true},
			
			{dataIndex: 'TERM_LOAN'				, width: 100 , hidden: false},
			{dataIndex: 'TERM_PRINCIPAL'		, width: 100 , hidden: false},
			{dataIndex: 'TEMPC_01'				, width: 100 , hidden: false},
			{dataIndex: 'NOW_RATE'				, width: 100 , hidden: false}
		] ,
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				if(!e.record.phantom) {
					return false;
				} else {
					return false;
				}
//				if(e.record.data.ACCOUNT_NUM != ''){
//					e.record.data.set('ACCOUNT_NUM_EXPOS','***************');
//				}				
			},
			selectionchange:function( model1, selected, eOpts ){
				if(directMasterStore.count() == 0)	{
					inputTable.loadForm(null);
				} else {
					inputTable.loadForm(selected);
					if(inputTable.getValue('LOANNO') != '') {
						inputTable.getField('LOANNO').setReadOnly(true);
					} else {
						inputTable.getField('LOANNO').setReadOnly(false);
					}
					
					if(inputTable.getValue('ACCOUNT_NUM') != ''){
						inputTable.setValue('ACCOUNT_NUM_EXPOS', '***************');
					}else{
						inputTable.setValue('ACCOUNT_NUM_EXPOS', '');
					}
				}
			},
			onGridDblClick:function(grid, record, cellIndex, colName, td)	{
				if(colName =="ACCOUNT_NUM_EXPOS") {
					grid.ownerGrid.openCryptAcntNumPopup(record);
				}
			}
		},
		openCryptAcntNumPopup:function( record )	{
			if(record)	{
				var params = {'BANK_ACCOUNT': record.get('ACCOUNT_NUM'), 'GUBUN_FLAG': '2', 'INPUT_YN': 'N'}
				Unilite.popupCipherComm('grid', record, 'ACCOUNT_NUM_EXPOS', 'ACCOUNT_NUM', params);
			}
		}
	});
	
	Unilite.Main( {
		border: false,
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[{
					region : 'center',
					xtype : 'container',
					layout : 'fit',
					items : [ masterGrid ]
				},
				panelResult,
				{
					region : 'north',
					xtype : 'container',
					highth: 20,
					layout : 'fit',
					items : [ inputTable ]
				}
			]
		},
			panelSearch
		], 
		id : 'afd600ukrApp',
		fnInitBinding : function() {
			var activeSForm;
			if(!UserInfo.appOption.collapseLeftSearch) {
				activeSForm = panelSearch;
			} else {
				activeSForm = panelResult;
			}
//			panelResult.setValue('FR_EXDATE'		, UniDate.get('today'));
//			panelResult.setValue('TO_EXDATE'		, UniDate.get('today'));
//			panelSearch.setValue('FR_EXDATE'		, UniDate.get('today'));
//			panelSearch.setValue('TO_EXDATE'		, UniDate.get('today'));
//			activeSForm.onLoadSelectText('FR_EXDATE');
			panelSearch.setValue('ACCNT_DIV_CODE',UserInfo.divCode);
			inputTable.getField('LOANNO').setReadOnly(true);
			inputTable.getField('EXCHG_RATE_O').setReadOnly(true);
			inputTable.getField('FOR_AMT_I').setReadOnly(true);
			inputTable.setValue('MONEY_UNIT', BsaCodeInfo.gsMoneyUnit);
			inputTable.setValue('DIV_CODE', UserInfo.divCode);
			
			UniAppManager.setToolbarButtons('reset',true);
			UniAppManager.setToolbarButtons('newData',false);
		},
		onResetButtonDown: function() {		// 초기화
			panelSearch.clearForm();
			panelResult.clearForm();
			inputTable.clearForm();
			directMasterStore.loadData({});
			this.fnInitBinding();
			inputTable.getField('LOANNO').setReadOnly(false);
			inputTable.getField('EXCHG_RATE_O').setReadOnly(false);
			inputTable.getField('FOR_AMT_I').setReadOnly(false);
			UniAppManager.setToolbarButtons('delete',false);
			UniAppManager.setToolbarButtons('save',false);
			this.onNewDataButtonDown();
		},
		onQueryButtonDown : function()	{
			if(panelSearch.setAllFieldsReadOnly(true) == false){
				return false;
			}
			if(panelResult.setAllFieldsReadOnly(true) == false){
				return false;
			}
			
			directMasterStore.loadStoreRecords();
			
			UniAppManager.setToolbarButtons('reset',true);
			UniAppManager.setToolbarButtons('delete',true);
		},
		onNewDataButtonDown: function()	{		// 행추가
			var loanno = '';
			var moneyUnit = '';
			var repayPeriod = '';
			var accnt = '';
			var exchgRateO = '';
			var intPeriod = '';
			var divCode = '';
			var forAmtI = '';
			var repayAmtI = '';
			var custom = '';
			var amtI = '';
			var forrepayAmtI = '';
			var deptCode = '';
			var pubDate = '';
			var lcno = '';
			var loanGubun = '';
			var expDate = '';
			var exNum = '';
			var intRate = '';
			var repayDate = '';
			var slipNum = '';
			var accountNum = '';
			//var accntNumExpos = '***************';
			var renewDate = '';
			var remark = '';
			var mortgage = '';
			var fgint = '';
			
			var termLoan = '0';
			var termPrincipal = '0';
			var tempc_01 = '';
			
			var r = {
				LOANNO : 			loanno,
				MONEY_UNIT : 		moneyUnit,
				REPAY_PERIOD : 		repayPeriod,
				ACCNT : 			accnt,
				EXCHG_RATE_O : 		exchgRateO,
				INT_PERIOD : 		intPeriod,
				DIV_CODE : 			divCode,
				FOR_AMT_I : 		forAmtI,
				REPAY_AMT_I : 		repayAmtI,
				CUSTOM : 			custom,
				AMT_I : 			amtI,
				FORREPAY_AMT_I :	forrepayAmtI,
				DEPT_CODE : 		deptCode,
				PUB_DATE : 			pubDate,
				LCNO : 				lcno,
				LOAN_GUBUN : 		loanGubun, 
				EXP_DATE : 			expDate,
				EX_NUM : 			exNum,
				INT_RATE : 			intRate,
				REPAY_DATE : 		repayDate,
				SLIP_NUM : 			slipNum,
				ACCOUNT_NUM : 		accountNum,
				//ACCOUNT_NUM_EXPOS :	accntNumExpos,
				RENEW_DATE : 		renewDate,
				REMARK : 			remark,
				MORTGAGE : 			mortgage,
				FG_INT:				fgint,
				
				TERM_LOAN :			termLoan,
				TERM_PRINCIPAL :	termPrincipal,
				TEMPC_01 :			tempc_01
			};
			masterGrid.createRow(r);
			inputTable.getField('LOANNO').focus();
			UniAppManager.setToolbarButtons('reset',true);
		},
		onSaveDataButtonDown: function(config) {	// 저장 버튼
			if(inputTable.setAllFieldsReadOnly(true) == false){
				return false;
			}
			directMasterStore.saveStore();
		},
		onDeleteDataButtonDown: function() {
			if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				var param = inputTable.getValues();
				afd600ukrService.exDateAcDateCheck(param, function(provider, response) {
					if(!Ext.isEmpty(provider.EX_DATE) || !Ext.isEmpty(provider.AC_DATE)) {
						alert("전표가 발행된 건은 삭제할 수 없습니다.");
					} else {
						masterGrid.deleteSelectedRow();
						UniAppManager.app.onSaveDataButtonDown();
					}
				});
			}
		}
	});
};


</script>
