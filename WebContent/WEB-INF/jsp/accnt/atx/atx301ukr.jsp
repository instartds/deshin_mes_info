<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="atx301ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 					<!-- 사업장 -->
	<t:ExtComboStore comboType="BOR120"  comboCode="BILL" storeId="billDivCode" />	<!-- 신고사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A246"/>			<!-- 영세율 상호주의  -->
	<t:ExtComboStore comboType="AU" comboCode="B012"/>			<!-- 국가코드 -->
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
</t:appConfig>
<script type="text/javascript" >
var SumTableSub1Window;	// 예정신고누락분명세-매출
var SumTableSub2Window;	// 예정신고누락분명세-매입
var SumTableSub3Window;	// 그밖의공제매입세액
var SumTableSub4Window;	// 공제받지못할세액
var SumTableSub5Window;	// 그밖의공제.경감세액
var SumTableSub6Window;	// 가산세액계

var SumTableSetUpWindow; // 설정

var	AMT_26, TAX_26, AMT_27, TAX_27, AMT_28, AMT_29, AMT_5, TAX_5; // 예정신고누락분명세-매출
var AMT_10_32, TAX_10_32, AMT_10_33, TAX_10_33, AMT_TOT_10_34, TAX_TOT_10_34; // 예정신고누락분명세-매입
var AMT_31, TAX_31, AMT_63, TAX_63, AMT_32, TAX_32, AMT_33, TAX_33, TAX_55,
	TAX_34, TAX_35, TAX_14_47, AMT_10, TAX_10;// 그밖의공제매입세액
var AMT_37, TAX_37, AMT_38, TAX_38, AMT_39, TAX_39, AMT_12, TAX_12; // 공제받지못할세액
var TAX_16_46, TAX_64, TAX_41, TAX_16_47, TAX_42, TAX_15, TAX_78; // 그밖의공제.경감세액
var AMT_44, TAX_44, AMT_67, TAX_67, AMT_69, TAX_69, AMT_61, TAX_61, AMT_65,
	TAX_65, AMT_66, TAX_66, AMT_45, TAX_45, AMT_70, TAX_70, AMT_46, TAX_46,
	AMT_71, TAX_71, AMT_72, TAX_72, AMT_73, TAX_73, AMT_47, TAX_47, AMT_48,
	TAX_48, AMT_56, TAX_56, AMT_74, TAX_74, AMT_75, TAX_75, AMT_76, TAX_76,
	AMT_19, TAX_19; // 가산세액계
var DIVI, PRE_RE_CANCEL, BUSINESS_BANK_CODE, BUSINESS_BANK_NAME, BRANCH_NAME, BANK_ACCOUNT, CLOSE_DATE,
	CLOSE_REASON, COMP_TYPE1, COMP_CLASS1, COMP_CODE1, COMP_AMT1,
	COMP_TYPE2, COMP_CLASS2, COMP_CODE2, COMP_AMT2, COMP_TYPE3, COMP_CLASS3, COMP_CODE3, COMP_AMT3,
	COMP_CLASS4, COMP_CODE4, COMP_AMT4, AMT_TOT_25, FREE_TYPE1, FREE_CLASS1, FREE_CODE1, FREE_AMT1,
	FREE_TYPE2, FREE_CLASS2, FREE_CODE2, FREE_AMT2, FREE_CLASS3, FREE_CODE3, FREE_AMT3, AMT_TOT_52,
	AMT_53, AMT_54, DECLARE_DATE,
	ZERO_TAX_RECIP1, ZERO_TAX_CLASS1, ZERO_TAX_CODE1, ZERO_TAX_NATION1,
	ZERO_TAX_RECIP2, ZERO_TAX_CLASS2, ZERO_TAX_CODE2, ZERO_TAX_NATION2,
	ZERO_TAX_RECIP3, ZERO_TAX_CLASS3, ZERO_TAX_CODE3, ZERO_TAX_NATION3; // 설정

var SAVE_FLAG = '';

var resetButtonFlag = '';

var getTaxBase = '${getTaxBase}';
var getBillDivCode = '${getBillDivCode}';

function appMain() {

	/**
	 * 검색조건 (Search Panel)
	 * @type
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm',{
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
				fieldLabel     : '계산서일',
				xtype          : 'uniDateRangefield',
				startFieldName : 'txtFrPubDate',
				endFieldName   : 'txtToPubDate',
				width          : 470,
				startDate      : UniDate.get('startOfMonth'),
				endDate        : UniDate.get('today'),
				allowBlank     : false,
				holdable       : 'hold',
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('txtFrPubDate',newValue);
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('txtToPubDate',newValue);
					}
				}
			},{
				fieldLabel  : '신고사업장',
				name        : 'txtBillDivCode',
				xtype       : 'uniCombobox',
				store       : Ext.data.StoreManager.lookup('billDivCode'),
				allowBlank  : false,
				holdable    :'hold',
				listeners   : {
					change: function(combo, newValue, oldValue, eOpts) {
						panelResult.setValue('txtBillDivCode', newValue);
						if(combo.lastMutatedValue == "총괄"){
							panelSearch.setValue('txtBillDivCode_sub', getBillDivCode);
						}else{
							panelSearch.setValue('txtBillDivCode_sub','');
							panelSearch.getField('txtBillDivCode_sub').setReadOnly(true);
						}
					},
					afterrender: function(field) {
						if(getTaxBase == '2'){
							var divStore = field.getStore();
							divStore.insert(0, {"value":"00", "option":null, "text":"총괄"});
						}
					}
				}
			},{
				xtype       : 'radiogroup',
				fieldLabel  : '전자신고세액',
				id          : 'rdoElectricB',
				labelWidth  : 100,
				items       : [{
					boxLabel   : '공제',
					width      : 70,
					name       : 'rdoElectric',
					inputValue : 'A',
					checked    : true
				},{
					boxLabel   : '불공제',
					width      : 70,
					name       : 'rdoElectric',
					inputValue : 'B'
				}],
				listeners : {
					change : function(field, newValue, oldValue, eOpts) {
						panelResult.getField('rdoElectric').setValue(newValue.rdoElectric);
					}
				}
			},{
				xtype       : 'uniTextfield',
				fieldLabel  : '차수',
				name        : 'DEGREE',
				readOnly    : true,
				value       : '1'
			},{
				fieldLabel  : '총괄조회</br>신고사업장',
				name        : 'txtBillDivCode_sub',
				xtype       : 'uniCombobox',
				multiSelect : true,
				typeAhead   : false,
				comboType   : 'BOR120',
				comboCode   : 'BILL',
				width       : 325,
				readOnly    : true,
				listeners   : {
					change : function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('txtBillDivCode_sub', newValue);
					}
				}
			},{
				xtype       : 'radiogroup',
				fieldLabel  : '과세매출세액계산',
				id          : 'rdoSum1',
				labelWidth  : 100,
				columns     : 1,
				items       : [{
					boxLabel   : '부가세정보의 세액합계',
					width      : 150,
					name       : 'rdoSum',
					inputValue : '1',
					checked    : true
				},{
					boxLabel   : '공급가액 *10%로 재계산</br></br>((3)신용카드,현금영수증발행분은</br>공급가액 = 합계/1.1</br>세액 = 합계 - 공급가액)',
					width      : 600,
					name       : 'rdoSum',
					inputValue : '2'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.getField('rdoSum').setValue(newValue.rdoSum);
					}
				}
			},{
				xtype       : 'uniTextfield',
				fieldLabel  : 'RE_REFERENCE',
				name        : 'RE_REFERENCE',
				hidden      : true
			}]
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
							var popupFC = item.up('uniPopupField');
							if(popupFC.holdable == 'hold') {
								popupFC.setReadOnly(true);
							}
						}
					});
				}
			} else {
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) ) {
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
		region  : 'north',
		layout  : {type : 'uniTable', columns : 3},
		padding : '1 1 1 1',
		border  : true,
		hidden  : !UserInfo.appOption.collapseLeftSearch,
		items   : [{
			fieldLabel     : '계산서일',
			xtype          : 'uniDateRangefield',
			startFieldName : 'txtFrPubDate',
			endFieldName   : 'txtToPubDate',
			width          : 470,
			startDate      : UniDate.get('startOfMonth'),
			endDate        : UniDate.get('today'),
			allowBlank     : false,
			holdable       : 'hold',
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('txtFrPubDate',newValue);
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('txtToPubDate',newValue);
				}
			}
		},{
			fieldLabel     : '신고사업장',
			name           : 'txtBillDivCode',
			xtype          : 'uniCombobox',
			store          : Ext.data.StoreManager.lookup('billDivCode'),
			allowBlank     : false,
			holdable       : 'hold',
			labelWidth     : 130,
			listeners      : {
				change: function(combo, newValue, oldValue, eOpts) {
					panelSearch.setValue('txtBillDivCode', newValue);
					if(combo.lastMutatedValue == "총괄"){
						panelResult.setValue('txtBillDivCode_sub', getBillDivCode);
					}else{
						panelResult.setValue('txtBillDivCode_sub','');
						panelResult.getField('txtBillDivCode_sub').setReadOnly(true);
					}
				},
				afterrender: function(field) {
					if(getTaxBase == '2'){
						var divStore = field.getStore();
					 	divStore.insert(0, {"value":"00", "option":null, "text":"총괄"});
					}
				}
			}
		},{
			xtype      : 'uniTextfield',
			fieldLabel : '차수',
			name       : 'DEGREE',
			readOnly   : true,
			value      : '1'
		},{
			xtype      : 'radiogroup',
			fieldLabel : '전자신고세액',
			id         : 'rdoElectricA',
			items      : [{
				boxLabel   : '공제',
				width      : 50,
				name       : 'rdoElectric',
				inputValue : 'A',
				checked    : true
			},{
				boxLabel   : '불공제',
				width      : 70,
				name       : 'rdoElectric',
				inputValue : 'B'
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.getField('rdoElectric').setValue(newValue.rdoElectric);
				}
			}
		},{
			fieldLabel  : '총괄조회신고사업장',
			name        : 'txtBillDivCode_sub',
			xtype       : 'uniCombobox',
			multiSelect : true,
			typeAhead   : false,
			comboType   :'BOR120',
			comboCode   : 'BILL',
			labelWidth  : 130,
			width       : 325,
			readOnly    : true,
			listeners   : {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('txtBillDivCode_sub', newValue);
				}
			}
	    },{
			xtype      : 'radiogroup',
			fieldLabel : '과세매출세액계산',
			colspan    : 2,
			id         : 'rdoSum2',
			labelWidth : 100,
			items      : [{
				boxLabel   : '부가세정보의 세액합계',
				width      : 150,
				name       : 'rdoSum',
				inputValue : '1',
				checked    : true
			},{
				boxLabel   : '공급가액 *10%로 재계산 ((3)신용카드,현금영수증발행분은 공급가액 = 합계/1.1, 세액 = 합계 - 공급가액)',
				width      : 600,
				name       : 'rdoSum',
				inputValue : '2'
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.getField('rdoSum').setValue(newValue.rdoSum);
				}
			}
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
						if(Ext.isDefined(item.holdable) ) {
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

	var sumTableSub1 = Unilite.createForm('sub1Form',{	//예정신고누락분-매출
		padding     : '0 0 0 0',
		title       : '예정신고누락분명세',
		disabled    : false,
		flex        : 1.5,
		bodyPadding : 10,
		region      : 'center',
		layout      : {
			type       : 'uniTable',
			columns    : 7,
			tableAttrs : {style: 'border : 1px solid #ced9e7;', width: '100%'},
			tdAttrs    : {style: 'border : 1px solid #ced9e7;', align : 'center'}
		},
		items: [
			{ xtype: 'component',  html:'(7)</br>예정신고누락분명세', rowspan: 6},
			{ xtype: 'component',  html:'구&nbsp;&nbsp;&nbsp;&nbsp;분', colspan: 3},
			{ xtype: 'component',  html:'금&nbsp;&nbsp;&nbsp;&nbsp;액'},
			{ xtype: 'component',  html:'세&nbsp;&nbsp;&nbsp;&nbsp;율'},
			{ xtype: 'component',  html:'세&nbsp;&nbsp;&nbsp;&nbsp;액'},

			{ xtype: 'component',  html:'과&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;세', rowspan: 2},
			{ xtype: 'component',  html:'세 금 계 산 서'},
			{ xtype: 'component',  html:'(33)'},
			{ xtype: 'uniNumberfield', name: 'AMT_26', id: 'TempS1',value:0},
			{ xtype: 'component',  html:'10/100'},
			{ xtype: 'uniNumberfield', name: 'TAX_26', id: 'TempS2',value:0},

			{ xtype: 'component',  html:'기&nbsp;&nbsp;&nbsp;&nbsp;' +
				'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' +
				'&nbsp;&nbsp;타'},
			{ xtype: 'component',  html:'(34)'},
			{ xtype: 'uniNumberfield', name: 'AMT_27', id: 'TempS3',value:0},
			{ xtype: 'component',  html:'10/100'},
			{ xtype: 'uniNumberfield', name: 'TAX_27', id: 'TempS4',value:0},

			{ xtype: 'component',  html:'영 세 율', rowspan: 2},
			{ xtype: 'component',  html:'세 금 계 산 서'},
			{ xtype: 'component',  html:'(35)'},
			{ xtype: 'uniNumberfield', name: 'AMT_28', id: 'TempS5',value:0},
			{ xtype: 'component',  html:'0/100'},
			{ xtype: 'uniNumberfield', name: '', id: 'TempS6', readOnly:true},

			{ xtype: 'component',  html:'기&nbsp;&nbsp;&nbsp;&nbsp;' +
				'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' +
				'&nbsp;&nbsp;타'},
			{ xtype: 'component',  html:'(36)'},
			{ xtype: 'uniNumberfield', name: 'AMT_29', id: 'TempS7',value:0},
			{ xtype: 'component',  html:'0/100'},
			{ xtype: 'uniNumberfield', name: '', id: 'TempS8', readOnly:true},

			{ xtype: 'component',  html:'합&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' +
				'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' +
				'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' +
				'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;계', colspan: 2},
			{ xtype: 'component',  html:'(37)'},
			{ xtype: 'uniNumberfield', name: 'AMT_5', id: 'TempS9',value:0, readOnly:true},
			{ xtype: 'component',  html:''},
			{ xtype: 'uniNumberfield', name: 'TAX_5', id: 'TempS10',value:0, readOnly:true}
		],
		listeners : {
			uniOnChange:function( basicForm, dirty, eOpts ) {
				sumTableSub1.setValue('AMT_5', sumTableSub1.getValue('AMT_26')
											 + sumTableSub1.getValue('AMT_27')
											 + sumTableSub1.getValue('AMT_28')
											 + sumTableSub1.getValue('AMT_29'));
				sumTableSub1.setValue('TAX_5', sumTableSub1.getValue('TAX_26')
											 + sumTableSub1.getValue('TAX_27'));

				if(basicForm.isDirty()) {
					if(resetButtonFlag == 'Y'){
						UniAppManager.setToolbarButtons('save', false);
					}else{
						UniAppManager.setToolbarButtons('save', true);
					}
				} else {
					UniAppManager.setToolbarButtons('save', false);
				}
			}
		}
	});


	function openSumTableSub1Window() {			//예정신고누락분-매출
		if(!SumTableSub1Window) {
			SumTableSub1Window = Ext.create('widget.uniDetailWindow', {
				title: '예정신고누락분명세-매출',
				header: {
					titleAlign: 'center'
				},
				width       : 800,
				layout      : {type:'vbox', align:'stretch'},
				items       : [sumTableSub1],
				dockedItems : [{
					xtype: 'toolbar',
					dock: 'bottom',
					items: [
						'->',{ xtype: 'button', text: '확인',
							handler: function() {
								sumTable.setValue('AMT_5',sumTableSub1.getValue('AMT_5'));
								sumTable.setValue('TAX_5',sumTableSub1.getValue('TAX_5'));
								SumTableSub1Window.hide();
								UniAppManager.app.setSumTableSumValue();
							}
						},
						{ xtype: 'button', text: '닫기',
							handler: function() {
								SumTableSub1Window.close();
							}
						}
					]
				}],
				listeners : {
					show: function( panel, eOpts )	{
						sumTableSub1.getField('AMT_26').focus();
					 	AMT_26 = sumTableSub1.getValue('AMT_26');
					 	TAX_26 = sumTableSub1.getValue('TAX_26');
					 	AMT_27 = sumTableSub1.getValue('AMT_27');
					 	TAX_27 = sumTableSub1.getValue('TAX_27');
					 	AMT_28 = sumTableSub1.getValue('AMT_28');
					 	AMT_29 = sumTableSub1.getValue('AMT_29');
					 	AMT_5 = sumTableSub1.getValue('AMT_5');
					 	TAX_5 = sumTableSub1.getValue('TAX_5');
					},
					beforehide: function(me, eOpt)	{

					},
					beforeclose: function( panel, eOpts )	{
						sumTableSub1.setValue('AMT_26',AMT_26);
						sumTableSub1.setValue('TAX_26',TAX_26);
						sumTableSub1.setValue('AMT_27',AMT_27);
						sumTableSub1.setValue('TAX_27',TAX_27);
						sumTableSub1.setValue('AMT_28',AMT_28);
						sumTableSub1.setValue('AMT_29',AMT_29);
						sumTableSub1.setValue('AMT_5',AMT_5);
						sumTableSub1.setValue('TAX_5',TAX_5);
		 			}
				}
			})
		}
		SumTableSub1Window.center();
		SumTableSub1Window.show();
	}
	var sumTableSub2 = Unilite.createForm('sub2Form',{	//예정신고누락분-매입
		padding:'0 0 0 0',
		title:'예정신고누락분명세',
		disabled: false,
		flex: 1.5,
		bodyPadding: 10,
		region: 'center',
		layout: {
			type: 'uniTable',
			columns:6,
			tableAttrs: {style: 'border : 1px solid #ced9e7;', width: '100%'},
			tdAttrs: {style: 'border : 1px solid #ced9e7;', align : 'center'}
		},
		items: [
			{ xtype: 'component',  html:'(12)</br>예정신고누락분명세', rowspan: 4},
			{ xtype: 'component',  html:'구&nbsp;&nbsp;&nbsp;&nbsp;분', colspan: 2},
			{ xtype: 'component',  html:'금&nbsp;&nbsp;&nbsp;&nbsp;액'},
			{ xtype: 'component',  html:'세&nbsp;&nbsp;&nbsp;&nbsp;율'},
			{ xtype: 'component',  html:'세&nbsp;&nbsp;&nbsp;&nbsp;액'},

			{ xtype: 'component',  html:'세&nbsp;&nbsp;&nbsp;&nbsp;금&nbsp;&nbsp;&nbsp;&nbsp;' +
				'&nbsp;&nbsp;계&nbsp;&nbsp;&nbsp;&nbsp;산&nbsp;&nbsp;&nbsp;&nbsp;서'},
			{ xtype: 'component',  html:'(38)'},
			{ xtype: 'uniNumberfield', name: 'AMT_10_32', id: 'TempS11',value:0},
			{ xtype: 'component',  html:''},
			{ xtype: 'uniNumberfield', name: 'TAX_10_32', id: 'TempS12',value:0},

			{ xtype: 'component',  html:'그밖의 공 제 매 입 세 액'},
			{ xtype: 'component',  html:'(39)'},
			{ xtype: 'uniNumberfield', name: 'AMT_10_33', id: 'TempS13',value:0},
			{ xtype: 'component',  html:''},
			{ xtype: 'uniNumberfield', name: 'TAX_10_33', id: 'TempS14',value:0},

			{ xtype: 'component',  html:'합&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' +
				'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' +
				'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;계'},
			{ xtype: 'component',  html:'(40)'},
			{ xtype: 'uniNumberfield', name: 'AMT_TOT_10_34', id: 'TempS15',value:0, readOnly:true},
			{ xtype: 'component',  html:''},
			{ xtype: 'uniNumberfield', name: 'TAX_TOT_10_34', id: 'TempS16',value:0, readOnly:true}
		],
		listeners : {
			uniOnChange:function( basicForm, dirty, eOpts ) {
				sumTableSub2.setValue('AMT_TOT_10_34', sumTableSub2.getValue('AMT_10_32')
													 + sumTableSub2.getValue('AMT_10_33'));
				sumTableSub2.setValue('TAX_TOT_10_34', sumTableSub2.getValue('TAX_10_32')
													 + sumTableSub2.getValue('TAX_10_33'));

				if(basicForm.isDirty()) {
					if(resetButtonFlag == 'Y'){
						UniAppManager.setToolbarButtons('save', false);
					}else{
						UniAppManager.setToolbarButtons('save', true);
					}
				}else {
					UniAppManager.setToolbarButtons('save', false);
				}
			}
		}
	});


	function openSumTableSub2Window() {			//예정신고누락분-매입
		if(!SumTableSub2Window) {
			SumTableSub2Window = Ext.create('widget.uniDetailWindow', {
				title: '예정신고누락분명세-매입',
				header: {
					titleAlign: 'center'
				},
				width: 800,
				layout: {type:'vbox', align:'stretch'},
				items: [sumTableSub2],
				dockedItems: [{
					xtype: 'toolbar',
					dock: 'bottom',
					items: [
						'->',{ xtype: 'button', text: '확인',
							handler: function() {
								sumTable.setValue('AMT_TOT_10_34',sumTableSub2.getValue('AMT_TOT_10_34'));
								sumTable.setValue('TAX_TOT_10_34',sumTableSub2.getValue('TAX_TOT_10_34'));
								SumTableSub2Window.hide();
								UniAppManager.app.setSumTableSumValue();
							}
						},
						{ xtype: 'button', text: '닫기',
							handler: function() {
								SumTableSub2Window.close();
							}
						}
					]
				}],
				listeners : {
					show: function( panel, eOpts )	{
						sumTableSub2.getField('AMT_10_32').focus();
						AMT_10_32 		= sumTableSub2.getValue('AMT_10_32');
						TAX_10_32 		= sumTableSub2.getValue('TAX_10_32');
						AMT_10_33 		= sumTableSub2.getValue('AMT_10_33');
						TAX_10_33 		= sumTableSub2.getValue('TAX_10_33');
						AMT_TOT_10_34 	= sumTableSub2.getValue('AMT_TOT_10_34');
						TAX_TOT_10_34 	= sumTableSub2.getValue('TAX_TOT_10_34');
					},
					beforehide: function(me, eOpt)	{

					},
					beforeclose: function( panel, eOpts )	{
						sumTableSub2.setValue('AMT_10_32', AMT_10_32);
						sumTableSub2.setValue('TAX_10_32', TAX_10_32);
						sumTableSub2.setValue('AMT_10_33', AMT_10_33);
						sumTableSub2.setValue('TAX_10_33', TAX_10_33);
						sumTableSub2.setValue('AMT_TOT_10_34', AMT_TOT_10_34);
						sumTableSub2.setValue('TAX_TOT_10_34', TAX_TOT_10_34);
		 			}
				}
			})
		}
		SumTableSub2Window.center();
		SumTableSub2Window.show();
	}
	var sumTableSub3 = Unilite.createForm('sub3Form',{	//그밖의공제매입세액
		padding:'0 0 0 0',
		title:'그밖의 공제매입세액명세',
		disabled: false,
		flex: 1.5,
		bodyPadding: 10,
		region: 'center',
		layout: {
			type: 'uniTable',
			columns:7,
			tableAttrs: {style: 'border : 1px solid #ced9e7;', width: '100%'},
			tdAttrs: {style: 'border : 1px solid #ced9e7;', align : 'center'}
		},
		items: [
			{ xtype: 'component',  html:'(14)</br>그밖의 공제</br>매입세액명세', rowspan: 10},
			{ xtype: 'component',  html:'구&nbsp;&nbsp;&nbsp;&nbsp;분', colspan: 3},
			{ xtype: 'component',  html:'금&nbsp;&nbsp;&nbsp;&nbsp;액'},
			{ xtype: 'component',  html:'세&nbsp;&nbsp;&nbsp;&nbsp;율'},
			{ xtype: 'component',  html:'세&nbsp;&nbsp;&nbsp;&nbsp;액'},

			{ xtype: 'component',  html:'신용카드매출전표</br>수취명세서제출분',rowspan:2},
			{ xtype: 'component',  html:'일&nbsp;&nbsp;&nbsp;&nbsp;반&nbsp;&nbsp;&nbsp;&nbsp;' +
				'매&nbsp;&nbsp;&nbsp;&nbsp;입'},
			{ xtype: 'component',  html:'(41)'},
			{ xtype: 'uniNumberfield', name: 'AMT_31', id: 'TempS17',value:0},
			{ xtype: 'component',  html:''},
			{ xtype: 'uniNumberfield', name: 'TAX_31', id: 'TempS18',value:0},

			{ xtype: 'component',  html:'고 정 자 산 매 입'},
			{ xtype: 'component',  html:'(42)'},
			{ xtype: 'uniNumberfield', name: 'AMT_63', id: 'TempS19',value:0},
			{ xtype: 'component',  html:''},
			{ xtype: 'uniNumberfield', name: 'TAX_63', id: 'TempS20',value:0},

			{ xtype: 'component',  html:'의&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;제&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' +
				'매&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;입&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;세&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;액', colspan: 2},
			{ xtype: 'component',  html:'(43)'},
			{ xtype: 'uniNumberfield', name: 'AMT_32', id: 'TempS21',value:0},
			{ xtype: 'component',  html:''},
			{ xtype: 'uniNumberfield', name: 'TAX_32', id: 'TempS22',value:0},

			{ xtype: 'component',  html:'재 활 용 폐 자 원 등 매 입 세 액', colspan: 2},
			{ xtype: 'component',  html:'(44)'},
			{ xtype: 'uniNumberfield', name: 'AMT_33', id: 'TempS23',value:0},
			{ xtype: 'component',  html:''},
			{ xtype: 'uniNumberfield', name: 'TAX_33', id: 'TempS24',value:0},

			{ xtype: 'component',  html:'과 세 사 업 전 환&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;매 입 세 액', colspan: 2},
			{ xtype: 'component',  html:'(45)'},
			{ xtype: 'uniNumberfield', name: '', id: 'TempS25',readOnly:true},
			{ xtype: 'component',  html:''},
			{ xtype: 'uniNumberfield', name: 'TAX_55', id: 'TempS26',value:0},

			{ xtype: 'component',  html:'재&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;고&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' +
				'매&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;입&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;세&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;액', colspan: 2},
			{ xtype: 'component',  html:'(46)'},
			{ xtype: 'uniNumberfield', name: '', id: 'TempS27',readOnly:true},
			{ xtype: 'component',  html:''},
			{ xtype: 'uniNumberfield', name: 'TAX_34', id: 'TempS28',value:0},

			{ xtype: 'component',  html:'변&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;제&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' +
				'대&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;손&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;세&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;액', colspan: 2},
			{ xtype: 'component',  html:'(47)'},
			{ xtype: 'uniNumberfield', name: '', id: 'TempS29',readOnly:true},
			{ xtype: 'component',  html:''},
			{ xtype: 'uniNumberfield', name: 'TAX_35', id: 'TempS30',value:0},

			{ xtype: 'component',  html:'외 국 인 관광객에 대한 환급 세액', colspan: 2},
			{ xtype: 'component',  html:'(48)'},
			{ xtype: 'uniNumberfield', name: '', id: 'TempS31',readOnly:true},
			{ xtype: 'component',  html:''},
			{ xtype: 'uniNumberfield', name: 'TAX_14_47', id: 'TempS32',value:0},

			{ xtype: 'component',  html:'합&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' +
				'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' +
				'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' +
				'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;계', colspan: 2},
			{ xtype: 'component',  html:'(49)'},
			{ xtype: 'uniNumberfield', name: 'AMT_10', id: 'TempS33',value:0,readOnly:true},
			{ xtype: 'component',  html:''},
			{ xtype: 'uniNumberfield', name: 'TAX_10', id: 'TempS34',value:0,readOnly:true}
		],
		listeners : {
			uniOnChange:function( basicForm, dirty, eOpts ) {
				sumTableSub3.setValue('AMT_10', sumTableSub3.getValue('AMT_31')
											  + sumTableSub3.getValue('AMT_63')
											  + sumTableSub3.getValue('AMT_32')
											  + sumTableSub3.getValue('AMT_33'));
				sumTableSub3.setValue('TAX_10', sumTableSub3.getValue('TAX_31')
											  + sumTableSub3.getValue('TAX_63')
											  + sumTableSub3.getValue('TAX_32')
											  + sumTableSub3.getValue('TAX_33')
											  + sumTableSub3.getValue('TAX_55')
											  + sumTableSub3.getValue('TAX_34')
											  + sumTableSub3.getValue('TAX_35')
				 							  + sumTableSub3.getValue('TAX_14_47'));

				if(basicForm.isDirty()) {
					if(resetButtonFlag == 'Y'){
						UniAppManager.setToolbarButtons('save', false);
					}else{
						UniAppManager.setToolbarButtons('save', true);
					}
				}else {
					UniAppManager.setToolbarButtons('save', false);
				}
			}
		}
	});


	function openSumTableSub3Window() {			//그밖의공제매입세액
		if(!SumTableSub3Window) {
			SumTableSub3Window = Ext.create('widget.uniDetailWindow', {
				title: '기타공제매입세액명세',
				header: {
					titleAlign: 'center'
				},
				width: 800,
				layout: {type:'vbox', align:'stretch'},
				items: [sumTableSub3],
				dockedItems: [{
					xtype: 'toolbar',
					dock: 'bottom',
					items: [
						'->',{ xtype: 'button', text: '확인',
							handler: function() {
								sumTable.setValue('AMT_10',sumTableSub3.getValue('AMT_10'));
								sumTable.setValue('TAX_10',sumTableSub3.getValue('TAX_10'));
								SumTableSub3Window.hide();

							}
						},
						{ xtype: 'button', text: '닫기',
							handler: function() {
								SumTableSub3Window.close();
							}
						}
					]
				}],
				listeners : {
					show: function( panel, eOpts )	{
						sumTableSub3.getField('AMT_31').focus();
						AMT_31    = sumTableSub3.getValue('AMT_31');
						TAX_31    = sumTableSub3.getValue('TAX_31');
						AMT_63    = sumTableSub3.getValue('AMT_63');
						TAX_63    = sumTableSub3.getValue('TAX_63');
						AMT_32    = sumTableSub3.getValue('AMT_32');
						TAX_32    = sumTableSub3.getValue('TAX_32');
						AMT_33    = sumTableSub3.getValue('AMT_33');
						TAX_33    = sumTableSub3.getValue('TAX_33');
						TAX_55    = sumTableSub3.getValue('TAX_55');
						TAX_34    = sumTableSub3.getValue('TAX_34');
						TAX_35    = sumTableSub3.getValue('TAX_35');
						TAX_14_47 = sumTableSub3.getValue('TAX_14_47');
						AMT_10    = sumTableSub3.getValue('AMT_10');
						TAX_10    = sumTableSub3.getValue('TAX_10');

					},
					beforehide: function(me, eOpt)	{
						UniAppManager.app.setSumTableSumValue();
					},
					beforeclose: function( panel, eOpts )	{
						sumTableSub3.setValue('AMT_31', AMT_31);
						sumTableSub3.setValue('TAX_31', TAX_31);
						sumTableSub3.setValue('AMT_63', AMT_63);
						sumTableSub3.setValue('TAX_63', TAX_63);
						sumTableSub3.setValue('AMT_32', AMT_32);
						sumTableSub3.setValue('TAX_32', TAX_32);
						sumTableSub3.setValue('AMT_33', AMT_33);
						sumTableSub3.setValue('TAX_33', TAX_33);
						sumTableSub3.setValue('TAX_55', TAX_55);
						sumTableSub3.setValue('TAX_34', TAX_34);
						sumTableSub3.setValue('TAX_35', TAX_35);
						sumTableSub3.setValue('TAX_14_47', TAX_14_47);
						sumTableSub3.setValue('AMT_10', AMT_10);
						sumTableSub3.setValue('TAX_10', TAX_10);
					}
				}
			})
		}
		SumTableSub3Window.center();
		SumTableSub3Window.show();
	}
	var sumTableSub4 = Unilite.createForm('sub4Form',{	//공제받지못할세액
		padding:'0 0 0 0',
		title:'공제받지못할매입세액명세',
		disabled: false,
		flex: 1.5,
		bodyPadding: 10,
		region: 'center',
		layout: {
			type: 'uniTable',
			columns:6,
			tableAttrs: {style: 'border : 1px solid #ced9e7;', width: '100%'},
			tdAttrs: {style: 'border : 1px solid #ced9e7;', align : 'center'}
		},
		items: [
			{ xtype: 'component',  html:'(16)</br>공제받지못할</br>매입세액명세', rowspan: 5},
			{ xtype: 'component',  html:'구&nbsp;&nbsp;&nbsp;&nbsp;분', colspan: 2},
			{ xtype: 'component',  html:'금&nbsp;&nbsp;&nbsp;&nbsp;액'},
			{ xtype: 'component',  html:'세&nbsp;&nbsp;&nbsp;&nbsp;율'},
			{ xtype: 'component',  html:'세&nbsp;&nbsp;&nbsp;&nbsp;액'},

			{ xtype: 'component',  html:'공 제 받 지 못 할&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;매 입 세 액'},
			{ xtype: 'component',  html:'(50)'},
			{ xtype: 'uniNumberfield', name: 'AMT_37', id: 'TempS35',value:0},
			{ xtype: 'component',  html:''},
			{ xtype: 'uniNumberfield', name: 'TAX_37', id: 'TempS36',value:0},

			{ xtype: 'component',  html:'공 통 매 입 세 액 면 세 사 업 분'},
			{ xtype: 'component',  html:'(51)'},
			{ xtype: 'uniNumberfield', name: 'AMT_38', id: 'TempS37',value:0},
			{ xtype: 'component',  html:''},
			{ xtype: 'uniNumberfield', name: 'TAX_38', id: 'TempS38',value:0},

			{ xtype: 'component',  html:'대&nbsp;&nbsp;손&nbsp;&nbsp;처&nbsp;&nbsp;분&nbsp;&nbsp;' +
				'받&nbsp;&nbsp;은&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;세&nbsp;&nbsp;액'},
			{ xtype: 'component',  html:'(52)'},
			{ xtype: 'uniNumberfield', name: 'AMT_39', id: 'TempS39',value:0},
			{ xtype: 'component',  html:''},
			{ xtype: 'uniNumberfield', name: 'TAX_39', id: 'TempS40',value:0},

			{ xtype: 'component',  html:'합&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' +
				'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' +
				'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' +
				'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;계'},
			{ xtype: 'component',  html:'(53)'},
			{ xtype: 'uniNumberfield', name: 'AMT_12', id: 'TempS41',value:0,readOnly:true},
			{ xtype: 'component',  html:''},
			{ xtype: 'uniNumberfield', name: 'TAX_12', id: 'TempS42',value:0,readOnly:true}
		],
		listeners : {
			uniOnChange:function( basicForm, dirty, eOpts ) {
				sumTableSub4.setValue('AMT_12', sumTableSub4.getValue('AMT_37')
											  + sumTableSub4.getValue('AMT_38')
											  + sumTableSub4.getValue('AMT_39'));
				sumTableSub4.setValue('TAX_12', sumTableSub4.getValue('TAX_37')
											  + sumTableSub4.getValue('TAX_38')
											  + sumTableSub4.getValue('TAX_39'));

				if(basicForm.isDirty()) {
					if(resetButtonFlag == 'Y'){
						UniAppManager.setToolbarButtons('save', false);
					}else{
						UniAppManager.setToolbarButtons('save', true);
					}
				}else {
					UniAppManager.setToolbarButtons('save', false);
				}
			}
		}
	});


	function openSumTableSub4Window() {			//공제받지못할세액
		if(!SumTableSub4Window) {
			SumTableSub4Window = Ext.create('widget.uniDetailWindow', {
				title: '공제받지못할매입세액명세',
				header: {
					titleAlign: 'center'
				},
				width: 800,
				layout: {type:'vbox', align:'stretch'},
				items: [sumTableSub4],
				dockedItems: [{
					xtype: 'toolbar',
					dock: 'bottom',
					items: [
						'->',{ xtype: 'button', text: '확인',
							handler: function() {
								sumTable.setValue('AMT_TOT_12',sumTableSub4.getValue('AMT_12'));
								sumTable.setValue('TAX_TOT_12',sumTableSub4.getValue('TAX_12'));
								SumTableSub4Window.hide();

							}
						},
						{ xtype: 'button', text: '닫기',
							handler: function() {
								SumTableSub4Window.close();
							}
						}
					]
				}],
				listeners : {

					show: function( panel, eOpts )	{
						sumTableSub4.getField('AMT_37').focus();
						AMT_37 = sumTableSub4.getValue('AMT_37');
						TAX_37 = sumTableSub4.getValue('TAX_37');
						AMT_38 = sumTableSub4.getValue('AMT_38');
						TAX_38 = sumTableSub4.getValue('TAX_38');
						AMT_39 = sumTableSub4.getValue('AMT_39');
						TAX_39 = sumTableSub4.getValue('TAX_39');
						AMT_12 = sumTableSub4.getValue('AMT_12');
						TAX_12 = sumTableSub4.getValue('TAX_12');
					},
					beforehide: function(me, eOpt)	{
						UniAppManager.app.setSumTableSumValue();
					},
					 beforeclose: function( panel, eOpts )	{
						sumTableSub4.setValue('AMT_37', AMT_37);
						sumTableSub4.setValue('TAX_37', TAX_37);
						sumTableSub4.setValue('AMT_38', AMT_38);
						sumTableSub4.setValue('TAX_38', TAX_38);
						sumTableSub4.setValue('AMT_39', AMT_39);
						sumTableSub4.setValue('TAX_39', TAX_39);
						sumTableSub4.setValue('AMT_12', AMT_12);
						sumTableSub4.setValue('TAX_12', TAX_12);
		 			}
				}
			})
		}
		SumTableSub4Window.center();
		SumTableSub4Window.show();
	}
	var sumTableSub5 = Unilite.createForm('sub5Form',{	//그밖의공제.경감세액
		padding:'0 0 0 0',
		title:'그밖의 경감.공제세액명세',
		disabled: false,
		flex: 1.5,
		bodyPadding: 10,
		region: 'center',
		layout: {
			type: 'uniTable',
			columns:6,
			tableAttrs: {style: 'border : 1px solid #ced9e7;', width: '100%'},
			tdAttrs: {style: 'border : 1px solid #ced9e7;', align : 'center'}
		},
		items: [
			{ xtype: 'component',  html:'(18)</br>그밖의 경감.공제</br>세&nbsp;&nbsp;액&nbsp;&nbsp;&nbsp;&nbsp;명&nbsp;&nbsp;세', rowspan: 8},
			{ xtype: 'component',  html:'구&nbsp;&nbsp;&nbsp;&nbsp;분', colspan: 2},
			{ xtype: 'component',  html:'금&nbsp;&nbsp;&nbsp;&nbsp;액'},
			{ xtype: 'component',  html:'세&nbsp;&nbsp;&nbsp;&nbsp;율'},
			{ xtype: 'component',  html:'세&nbsp;&nbsp;&nbsp;&nbsp;액'},

			{ xtype: 'component',  html:'전&nbsp;&nbsp;자&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;신&nbsp;&nbsp;고&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' +
				'세&nbsp;&nbsp;액&nbsp;&nbsp;공&nbsp;&nbsp;제'},
			{ xtype: 'component',  html:'(54)'},
			{ xtype: 'uniNumberfield', name: '', id: 'TempS43',readOnly:true},
			{ xtype: 'component',  html:''},
			{ xtype: 'uniNumberfield', name: 'TAX_16_46', id: 'TempS44',value:0},

			{ xtype: 'component',  html:'전자세금계산서 발급 세 액 공 제'},
			{ xtype: 'component',  html:'(55)'},
			{ xtype: 'uniNumberfield', name: '', id: 'TempS45',readOnly:true},
			{ xtype: 'component',  html:''},
			{ xtype: 'uniNumberfield', name: 'TAX_64', id: 'TempS46',value:0},

			{ xtype: 'component',  html:'택 시 운 송 사 업 자 경 감 세 액'},
			{ xtype: 'component',  html:'(56)'},
			{ xtype: 'uniNumberfield', name: '', id: 'TempS47',readOnly:true},
			{ xtype: 'component',  html:''},
			{ xtype: 'uniNumberfield', name: 'TAX_41', id: 'TempS48',value:0},

			{ xtype: 'component',  html:'대&nbsp;&nbsp;리&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;납&nbsp;&nbsp;부&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' +
				'세&nbsp;&nbsp;액&nbsp;&nbsp;공&nbsp;&nbsp;제'},
			{ xtype: 'component',  html:'(57)'},
			{ xtype: 'uniNumberfield', name: '', id: 'TempS93',readOnly:true},
			{ xtype: 'component',  html:''},
			{ xtype: 'uniNumberfield', name: 'TAX_78', id: 'TempS94',value:0},

			{ xtype: 'component',  html:'현금 영수증 사 업 자 세 액 공 제'},
			{ xtype: 'component',  html:'(58)'},
			{ xtype: 'uniNumberfield', name: '', id: 'TempS49',readOnly:true},
			{ xtype: 'component',  html:''},
			{ xtype: 'uniNumberfield', name: 'TAX_16_47', id: 'TempS50',value:0},

			{ xtype: 'component',  html:'기&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' +
				'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' +
				'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' +
				'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;타'},
			{ xtype: 'component',  html:'(59)'},
			{ xtype: 'uniNumberfield', name: '', id: 'TempS51',readOnly:true},
			{ xtype: 'component',  html:''},
			{ xtype: 'uniNumberfield', name: 'TAX_42', id: 'TempS52',value:0},

			{ xtype: 'component',  html:'합&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' +
				'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' +
				'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' +
				'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;계'},
			{ xtype: 'component',  html:'(60)'},
			{ xtype: 'uniNumberfield', name: '', id: 'TempS53',readOnly:true},
			{ xtype: 'component',  html:''},
			{ xtype: 'uniNumberfield', name: 'TAX_15', id: 'TempS54',value:0,readOnly:true}
		],
		listeners : {
			uniOnChange:function( basicForm, dirty, eOpts ) {
				sumTableSub5.setValue('TAX_15', sumTableSub5.getValue('TAX_16_46')
											  + sumTableSub5.getValue('TAX_16_47')
											  + sumTableSub5.getValue('TAX_64')
											  + sumTableSub5.getValue('TAX_41')
											  + sumTableSub5.getValue('TAX_42')
											  + sumTableSub5.getValue('TAX_78'));

				if(basicForm.isDirty()) {
					if(resetButtonFlag == 'Y'){
						UniAppManager.setToolbarButtons('save', false);
					}else{
						UniAppManager.setToolbarButtons('save', true);
					}
				}else {
					UniAppManager.setToolbarButtons('save', false);
				}
			}
		}
	});


	function openSumTableSub5Window() {			//그밖의공제.경감세액
		if(!SumTableSub5Window) {
			SumTableSub5Window = Ext.create('widget.uniDetailWindow', {
				title: '기타경감.공제세액명세',
				header: {
					titleAlign: 'center'
				},
				width: 800,
				layout: {type:'vbox', align:'stretch'},
				items: [sumTableSub5],
				dockedItems: [{
					xtype: 'toolbar',
					dock: 'bottom',
					items: [
						'->',{ xtype: 'button', text: '확인',
							handler: function() {
								sumTable.setValue('TAX_15',sumTableSub5.getValue('TAX_15'));
								SumTableSub5Window.hide();

							}
						},
						{ xtype: 'button', text: '닫기',
							handler: function() {
								SumTableSub5Window.close();
							}
						}
					]
				}],
				listeners : {
					show: function( panel, eOpts )	{
						sumTableSub5.getField('TAX_16_46').focus();
						TAX_16_46 = sumTableSub5.getValue('TAX_16_46');
						TAX_64    = sumTableSub5.getValue('TAX_64');
						TAX_41    = sumTableSub5.getValue('TAX_41');
						TAX_16_47 = sumTableSub5.getValue('TAX_16_47');
						TAX_42    = sumTableSub5.getValue('TAX_42');
						TAX_15    = sumTableSub5.getValue('TAX_15');
						TAX_78    = sumTableSub5.getValue('TAX_78');
					},
					beforehide: function(me, eOpt)	{
						UniAppManager.app.setSumTableSumValue();
					},
					beforeclose: function( panel, eOpts )	{
					 	sumTableSub5.setValue('TAX_16_46', TAX_16_46);
					 	sumTableSub5.setValue('TAX_64', TAX_64);
					 	sumTableSub5.setValue('TAX_41', TAX_41);
					 	sumTableSub5.setValue('TAX_16_47', TAX_16_47);
					 	sumTableSub5.setValue('TAX_42', TAX_42);
					 	sumTableSub5.setValue('TAX_15', TAX_15);
					 	sumTableSub5.setValue('TAX_78', TAX_78);
		 			}
				}
			})
		}
		SumTableSub5Window.center();
		SumTableSub5Window.show();
	}
	var sumTableSub6 = Unilite.createForm('sub6Form',{	//가산세액계
		padding:'0 0 0 0',
		title:'가산세명세',
		disabled: false,
		flex: 1.5,
		bodyPadding: 10,
		region: 'center',
		layout: {
			type: 'uniTable',
			columns:7,
			tableAttrs: {style: 'border : 1px solid #ced9e7;', width: '100%'},
			tdAttrs: {style: 'border : 1px solid #ced9e7;', align : 'center'}
		},
		items: [
			{ xtype: 'component',  html:'(26)</br>가산세명세', rowspan: 20},
			{ xtype: 'component',  html:'구&nbsp;&nbsp;&nbsp;&nbsp;분', colspan: 3},
			{ xtype: 'component',  html:'금&nbsp;&nbsp;&nbsp;&nbsp;액'},
			{ xtype: 'component',  html:'세&nbsp;&nbsp;&nbsp;&nbsp;율'},
			{ xtype: 'component',  html:'세&nbsp;&nbsp;&nbsp;&nbsp;액'},

			{ xtype: 'component',  html:'사&nbsp;&nbsp;&nbsp;&nbsp;업&nbsp;&nbsp;&nbsp;&nbsp;' +
				'자&nbsp;&nbsp;&nbsp;&nbsp;미&nbsp;&nbsp;&nbsp;&nbsp;등&nbsp;&nbsp;&nbsp;&nbsp;록', colspan: 2},
			{ xtype: 'component',  html:'(61)'},
			{ xtype: 'uniNumberfield', name: 'AMT_44', id: 'TempS55',value:0},
			{ xtype: 'component',  html:'1/100'},
			{ xtype: 'uniNumberfield', name: 'TAX_44', id: 'TempS56',value:0},

			{ xtype: 'component',  html:'세금계산서', rowspan: 3},
			{ xtype: 'component',  html:'지연발급 등'},
			{ xtype: 'component',  html:'(62)'},
			{ xtype: 'uniNumberfield', name: 'AMT_67', id: 'TempS57',value:0},
			{ xtype: 'component',  html:'1/100'},
			{ xtype: 'uniNumberfield', name: 'TAX_67', id: 'TempS58',value:0},

			{ xtype: 'component',  html:'지 연 수 취'},
			{ xtype: 'component',  html:'(63)'},
			{ xtype: 'uniNumberfield', name: 'AMT_69', id: 'TempS59',value:0},
			{ xtype: 'component',  html:'5/1000'},
			{ xtype: 'uniNumberfield', name: 'TAX_69', id: 'TempS60',value:0},

			{ xtype: 'component',  html:'미 발 급 등'},
			{ xtype: 'component',  html:'(64)'},
			{ xtype: 'uniNumberfield', name: 'AMT_61', id: 'TempS61',value:0},
			{ xtype: 'component',  html:'뒤쪽참조'},
			{ xtype: 'uniNumberfield', name: 'TAX_61', id: 'TempS62',value:0},

			{ xtype: 'component',  html:'전자세금계산서</br>발급명세전송', rowspan: 2},
			{ xtype: 'component',  html:'지 연 전 송'},
			{ xtype: 'component',  html:'(65)'},
			{ xtype: 'uniNumberfield', name: 'AMT_65', id: 'TempS63',value:0},
			{ xtype: 'component',  html:'5/1000'},
			{ xtype: 'uniNumberfield', name: 'TAX_65', id: 'TempS64',value:0},

			{ xtype: 'component',  html:'미&nbsp;&nbsp;&nbsp;전&nbsp;&nbsp;&nbsp;송'},
			{ xtype: 'component',  html:'(66)'},
			{ xtype: 'uniNumberfield', name: 'AMT_66', id: 'TempS65',value:0},
			{ xtype: 'component',  html:'5/1000'},
			{ xtype: 'uniNumberfield', name: 'TAX_66', id: 'TempS66',value:0},

			{ xtype: 'component',  html:'세금계산서합계표', rowspan: 2},
			{ xtype: 'component',  html:'제출 불성실'},
			{ xtype: 'component',  html:'(67)'},
			{ xtype: 'uniNumberfield', name: 'AMT_45', id: 'TempS67',value:0},
			{ xtype: 'component',  html:'1/100'},
			{ xtype: 'uniNumberfield', name: 'TAX_45', id: 'TempS68',value:0},

			{ xtype: 'component',  html:'지 연 제 출'},
			{ xtype: 'component',  html:'(68)'},
			{ xtype: 'uniNumberfield', name: 'AMT_70', id: 'TempS69',value:0},
			{ xtype: 'component',  html:'5/1000'},
			{ xtype: 'uniNumberfield', name: 'TAX_70', id: 'TempS70',value:0},

			{ xtype: 'component',  html:'신고불성실', rowspan: 4},
			{ xtype: 'component',  html:'무신고(일반)'},
			{ xtype: 'component',  html:'(69)'},
			{ xtype: 'uniNumberfield', name: 'AMT_46', id: 'TempS71',value:0},
			{ xtype: 'component',  html:'뒤쪽참조'},
			{ xtype: 'uniNumberfield', name: 'TAX_46', id: 'TempS72',value:0},

			{ xtype: 'component',  html:'무신고(부당)'},
			{ xtype: 'component',  html:'(70)'},
			{ xtype: 'uniNumberfield', name: 'AMT_71', id: 'TempS73',value:0},
			{ xtype: 'component',  html:'뒤쪽참조'},
			{ xtype: 'uniNumberfield', name: 'TAX_71', id: 'TempS74',value:0},

			{ xtype: 'component',  html:'과소.초과환급신고(일반)'},
			{ xtype: 'component',  html:'(71)'},
			{ xtype: 'uniNumberfield', name: 'AMT_72', id: 'TempS75',value:0},
			{ xtype: 'component',  html:'뒤쪽참조'},
			{ xtype: 'uniNumberfield', name: 'TAX_72', id: 'TempS76',value:0},

			{ xtype: 'component',  html:'과소.초과환급신고(부당)'},
			{ xtype: 'component',  html:'(72)'},
			{ xtype: 'uniNumberfield', name: 'AMT_73', id: 'TempS77',value:0},
			{ xtype: 'component',  html:'뒤쪽참조'},
			{ xtype: 'uniNumberfield', name: 'TAX_73', id: 'TempS78',value:0},

			{ xtype: 'component',  html:'납&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;부' +
				'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;불&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;성' +
				'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;실',colspan:2},
			{ xtype: 'component',  html:'(73)'},
			{ xtype: 'uniNumberfield', name: 'AMT_47', id: 'TempS79',value:0},
			{ xtype: 'component',  html:'뒤쪽참조'},
			{ xtype: 'uniNumberfield', name: 'TAX_47', id: 'TempS80',value:0},

			{ xtype: 'component',  html:'영 세 율 과 세 표 준 신고불성실',colspan:2},
			{ xtype: 'component',  html:'(74)'},
			{ xtype: 'uniNumberfield', name: 'AMT_48', id: 'TempS81',value:0},
			{ xtype: 'component',  html:'5/1000'},
			{ xtype: 'uniNumberfield', name: 'TAX_48', id: 'TempS82',value:0},

			{ xtype: 'component',  html:'현 금 매 출 명 세 서&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;불 성 실',colspan:2},
			{ xtype: 'component',  html:'(75)'},
			{ xtype: 'uniNumberfield', name: 'AMT_56', id: 'TempS83',value:0},
			{ xtype: 'component',  html:'1/100'},
			{ xtype: 'uniNumberfield', name: 'TAX_56', id: 'TempS84',value:0},

			{ xtype: 'component',  html:'부동산임대공급가액명세서 불성실',colspan:2},
			{ xtype: 'component',  html:'(76)'},
			{ xtype: 'uniNumberfield', name: 'AMT_74', id: 'TempS85',value:0},
			{ xtype: 'component',  html:'1/100'},
			{ xtype: 'uniNumberfield', name: 'TAX_74', id: 'TempS86',value:0},

			{ xtype: 'component',  html:'매입자</br>납부특례', rowspan: 2},
			{ xtype: 'component',  html:'거래계좌 미사용'},
			{ xtype: 'component',  html:'(77)'},
			{ xtype: 'uniNumberfield', name: 'AMT_75', id: 'TempS87',value:0},
			{ xtype: 'component',  html:'뒤쪽참조'},
			{ xtype: 'uniNumberfield', name: 'TAX_75', id: 'TempS88',value:0},

			{ xtype: 'component',  html:'거래계좌 지연입금'},
			{ xtype: 'component',  html:'(78)'},
			{ xtype: 'uniNumberfield', name: 'AMT_76', id: 'TempS89',value:0},
			{ xtype: 'component',  html:'뒤쪽참조'},
			{ xtype: 'uniNumberfield', name: 'TAX_76', id: 'TempS90',value:0},

			{ xtype: 'component',  html:'합&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' +
				'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' +
				'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' +
				'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;계',colspan:2},
			{ xtype: 'component',  html:'(79)'},
			{ xtype: 'uniNumberfield', name: 'AMT_19', id: 'TempS91',value:0,readOnly:true},
			{ xtype: 'component',  html:'뒤쪽참조'},
			{ xtype: 'uniNumberfield', name: 'TAX_19', id: 'TempS92',value:0,readOnly:true}
		],
		listeners : {
			uniOnChange:function( basicForm, dirty, eOpts ) {
				sumTableSub6.setValue('AMT_19', sumTableSub6.getValue('AMT_44')
											  + sumTableSub6.getValue('AMT_67')
											  + sumTableSub6.getValue('AMT_69')
											  + sumTableSub6.getValue('AMT_61')
											  + sumTableSub6.getValue('AMT_65')
											  + sumTableSub6.getValue('AMT_66')
											  + sumTableSub6.getValue('AMT_45')
											  + sumTableSub6.getValue('AMT_70')
											  + sumTableSub6.getValue('AMT_46')
											  + sumTableSub6.getValue('AMT_71')
											  + sumTableSub6.getValue('AMT_72')
											  + sumTableSub6.getValue('AMT_73')
											  + sumTableSub6.getValue('AMT_47')
											  + sumTableSub6.getValue('AMT_48')
											  + sumTableSub6.getValue('AMT_56')
											  + sumTableSub6.getValue('AMT_74')
											  + sumTableSub6.getValue('AMT_75')
											  + sumTableSub6.getValue('AMT_76'));
				sumTableSub6.setValue('TAX_19', sumTableSub6.getValue('TAX_44')
											  + sumTableSub6.getValue('TAX_67')
											  + sumTableSub6.getValue('TAX_69')
											  + sumTableSub6.getValue('TAX_61')
											  + sumTableSub6.getValue('TAX_65')
											  + sumTableSub6.getValue('TAX_66')
											  + sumTableSub6.getValue('TAX_45')
											  + sumTableSub6.getValue('TAX_70')
											  + sumTableSub6.getValue('TAX_46')
											  + sumTableSub6.getValue('TAX_71')
											  + sumTableSub6.getValue('TAX_72')
											  + sumTableSub6.getValue('TAX_73')
											  + sumTableSub6.getValue('TAX_47')
											  + sumTableSub6.getValue('TAX_48')
											  + sumTableSub6.getValue('TAX_56')
											  + sumTableSub6.getValue('TAX_74')
											  + sumTableSub6.getValue('TAX_75')
											  + sumTableSub6.getValue('TAX_76'));

				if(basicForm.isDirty()) {
					if(resetButtonFlag == 'Y'){
						UniAppManager.setToolbarButtons('save', false);
				}else{
						UniAppManager.setToolbarButtons('save', true);
					}
				}else {
					UniAppManager.setToolbarButtons('save', false);
				}
			}
		}
	});


	function openSumTableSub6Window() {			//가산세액계
		if(!SumTableSub6Window) {
			SumTableSub6Window = Ext.create('widget.uniDetailWindow', {
			title: '가산세명세',
			header: {
					titleAlign: 'center'
				},
				width: 800,
				layout: {type:'vbox', align:'stretch'},
				items: [sumTableSub6],
				dockedItems: [{
					xtype: 'toolbar',
					dock: 'bottom',
					items: [
						'->',{ xtype: 'button', text: '확인',
							handler: function() {
								sumTable.setValue('TAX_TOT_19',sumTableSub6.getValue('TAX_19'));
								SumTableSub6Window.hide();

							}
						},
						{ xtype: 'button', text: '닫기',
							handler: function() {
								SumTableSub6Window.close();
							}
						}
					]
				}],

				listeners : {
					show: function( panel, eOpts )	{
						sumTableSub6.getField('AMT_44').focus();
						AMT_44 = sumTableSub6.getValue('AMT_44');
						TAX_44 = sumTableSub6.getValue('TAX_44');
						AMT_67 = sumTableSub6.getValue('AMT_67');
						TAX_67 = sumTableSub6.getValue('TAX_67');
						AMT_69 = sumTableSub6.getValue('AMT_69');
						TAX_69 = sumTableSub6.getValue('TAX_69');
						AMT_61 = sumTableSub6.getValue('AMT_61');
						TAX_61 = sumTableSub6.getValue('TAX_61');
						AMT_65 = sumTableSub6.getValue('AMT_65');
						TAX_65 = sumTableSub6.getValue('TAX_65');
						AMT_66 = sumTableSub6.getValue('AMT_66');
						TAX_66 = sumTableSub6.getValue('TAX_66');
						AMT_45 = sumTableSub6.getValue('AMT_45');
						TAX_45 = sumTableSub6.getValue('TAX_45');
						AMT_70 = sumTableSub6.getValue('AMT_70');
						TAX_70 = sumTableSub6.getValue('TAX_70');
						AMT_46 = sumTableSub6.getValue('AMT_46');
						TAX_46 = sumTableSub6.getValue('TAX_46');
						AMT_71 = sumTableSub6.getValue('AMT_71');
						TAX_71 = sumTableSub6.getValue('TAX_71');
						AMT_72 = sumTableSub6.getValue('AMT_72');
						TAX_72 = sumTableSub6.getValue('TAX_72');
						AMT_73 = sumTableSub6.getValue('AMT_73');
						TAX_73 = sumTableSub6.getValue('TAX_73');
						AMT_47 = sumTableSub6.getValue('AMT_47');
						TAX_47 = sumTableSub6.getValue('TAX_47');
						AMT_48 = sumTableSub6.getValue('AMT_48');
						TAX_48 = sumTableSub6.getValue('TAX_48');
						AMT_56 = sumTableSub6.getValue('AMT_56');
						TAX_56 = sumTableSub6.getValue('TAX_56');
						AMT_74 = sumTableSub6.getValue('AMT_74');
						TAX_74 = sumTableSub6.getValue('TAX_74');
						AMT_75 = sumTableSub6.getValue('AMT_75');
						TAX_75 = sumTableSub6.getValue('TAX_75');
						AMT_76 = sumTableSub6.getValue('AMT_76');
						TAX_76 = sumTableSub6.getValue('TAX_76');
						AMT_19 = sumTableSub6.getValue('AMT_19');
						TAX_19 = sumTableSub6.getValue('TAX_19');
					},
					beforehide: function(me, eOpt)	{
						UniAppManager.app.setSumTableSumValue();
					},
					beforeclose: function( panel, eOpts )	{
						sumTableSub6.setValue('AMT_44', AMT_44);
						sumTableSub6.setValue('TAX_44', TAX_44);
						sumTableSub6.setValue('AMT_67', AMT_67);
						sumTableSub6.setValue('TAX_67', TAX_67);
						sumTableSub6.setValue('AMT_69', AMT_69);
						sumTableSub6.setValue('TAX_69', TAX_69);
						sumTableSub6.setValue('AMT_61', AMT_61);
						sumTableSub6.setValue('TAX_61', TAX_61);
						sumTableSub6.setValue('AMT_65', AMT_65);
						sumTableSub6.setValue('TAX_65', TAX_65);
						sumTableSub6.setValue('AMT_66', AMT_66);
						sumTableSub6.setValue('TAX_66', TAX_66);
						sumTableSub6.setValue('AMT_45', AMT_45);
						sumTableSub6.setValue('TAX_45', TAX_45);
						sumTableSub6.setValue('AMT_70', AMT_70);
						sumTableSub6.setValue('TAX_70', TAX_70);
						sumTableSub6.setValue('AMT_46', AMT_46);
						sumTableSub6.setValue('TAX_46', TAX_46);
						sumTableSub6.setValue('AMT_71', AMT_71);
						sumTableSub6.setValue('TAX_71', TAX_71);
						sumTableSub6.setValue('AMT_72', AMT_72);
						sumTableSub6.setValue('TAX_72', TAX_72);
						sumTableSub6.setValue('AMT_73', AMT_73);
						sumTableSub6.setValue('TAX_73', TAX_73);
						sumTableSub6.setValue('AMT_47', AMT_47);
						sumTableSub6.setValue('TAX_47', TAX_47);
						sumTableSub6.setValue('AMT_48', AMT_48);
						sumTableSub6.setValue('TAX_48', TAX_48);
						sumTableSub6.setValue('AMT_56', AMT_56);
						sumTableSub6.setValue('TAX_56', TAX_56);
						sumTableSub6.setValue('AMT_74', AMT_74);
						sumTableSub6.setValue('TAX_74', TAX_74);
						sumTableSub6.setValue('AMT_75', AMT_75);
						sumTableSub6.setValue('TAX_75', TAX_75);
						sumTableSub6.setValue('AMT_76', AMT_76);
						sumTableSub6.setValue('TAX_76', TAX_76);
						sumTableSub6.setValue('AMT_19', AMT_19);
						sumTableSub6.setValue('TAX_19', TAX_19);
		 			}
				}
			})
		}
		SumTableSub6Window.center();
		SumTableSub6Window.show();
	}
	var sumTableSetUp = Unilite.createForm('setUpForm',{	//설정
		padding:'0 0 0 0',
		disabled: false,
		flex: 1.5,
		bodyPadding: 10,
		region: 'center',
		items: [{
			title:'신고서',
			xtype: 'fieldset',
			padding: '5 5 5 5',
			items: [{
				xtype: 'radiogroup',
				id: 'rdoSelect1',
				items: [{
					boxLabel: '예정',
					name: 'DIVI',
					inputValue: '1',
					checked: true
				},{
					boxLabel : '확정',
					name: 'DIVI',
					inputValue: '2'
				},{
					boxLabel: '기한 후 과세표준',
					name: 'DIVI',
					inputValue: '3'
				},{
					boxLabel: '영세율등 조기환급',
					name: 'DIVI',
					inputValue: '4'
				}],
				listeners: {
				}
			}]
		},{
			title: '조기환급구분',
			xtype: 'fieldset',
			padding: '5 5 5 5',
			items: [{
				xtype: 'radiogroup',
				id: 'rdoSelect2',
				items: [{
					boxLabel: '기본값',
					name: 'PRE_RE_CANCEL',
					inputValue: '0',
					checked: true
				},{
					boxLabel : '조기환급취소',
					name: 'PRE_RE_CANCEL',
					inputValue: '1'
				}],
				listeners: {

				}
			},{
				xtype:'component',
				html:"<font size='2' color='blue'>※영세율 또는 시설투자 환급에 해당되지만 조기환급을 받지 않는 경우 취소선택</font>"
			}]
		},{
			title: '국세환급금계좌신고',
			xtype: 'fieldset',
			padding: '5 5 5 5',
			layout: {
				type: 'uniTable',
				columns:2
			},
			items: [
				Unilite.popup('BUSINESS_BANK',{
				fieldLabel: '거래은행',
				valueFieldName:'BUSINESS_BANK_CODE',
				textFieldName:'BUSINESS_BANK_NAME',
				validateBlank : 'text'
			}),{
				fieldLabel: '지점',
				name:'BRANCH_NAME',
				xtype: 'uniTextfield'
			},
			{
				fieldLabel: '계좌번호',
				name: 'BANK_ACCOUNT_EXPOS',
				xtype: 'uniTextfield',
				readOnly:true,
				focusable:false,
				listeners:{
					afterrender:function(field)	{
						field.getEl().on('dblclick', field.onDblclick);
					}
				},
				onDblclick:function(event, elm) {
					sumTableSetUp.openCryptBankAccntPopup();
				}
			},
			{
				fieldLabel: '계좌번호(DB)',
				name: 'BANK_ACCOUNT',
				xtype: 'uniTextfield',
				maxLength:50,
				hidden: true
			}]
		},{
			title: '폐업신고',
			xtype: 'fieldset',
			padding: '5 5 5 5',
			layout: {
				type: 'uniTable',
				columns:2
			},
			items: [{
				fieldLabel: '폐업일자',
				xtype: 'uniDatefield',
				name:'CLOSE_DATE'
			},{
				fieldLabel: '폐업사유',
				xtype: 'uniTextfield',
				name:'CLOSE_REASON',
				labelWidth:170
			}]
		},{
			title: '영세율 상호주의',
			xtype: 'fieldset',
			padding: '5 5 5 5',
			layout: {
				type    : 'uniTable',
				columns : 3
			},
			items: [{
				fieldLabel  : '적용구분',
				xtype       : 'uniCombobox',
				name        : 'ZERO_TAX_RECIP1',
				comboType   : 'AU',
				comboCode   : 'A246'
			},{
				xtype       : 'container',
				layout      : {type: 'uniTable', columns: 2},
				defaultType : 'uniTextfield',
				items       : [{
					fieldLabel  : '업종',
					name        : 'ZERO_TAX_CODE1' ,
					xtype       : 'uniTextfield',
					width       : 150,
					labelWidth  : 70
				},{
					fieldLabel  : '업종명',
					name        : 'ZERO_TAX_CLASS1' ,
					xtype       : 'uniTextfield',
					width       : 90,
					hideLabel   : true
				}]
			},{
				fieldLabel  : '국가',
				xtype       : 'uniCombobox',
				name        : 'ZERO_TAX_NATION1',
				comboType   : 'AU',
				comboCode   : 'B012'
			},{
				fieldLabel  : '적용구분',
				xtype       : 'uniCombobox',
				name        : 'ZERO_TAX_RECIP2',
				comboType   : 'AU',
				comboCode   : 'A246',
				hidden      : true
			},{
				xtype       : 'container',
				layout      : {type: 'uniTable', columns: 2},
				defaultType : 'uniTextfield',
				hidden      : true,
				items       : [{
					fieldLabel  : '업종',
					name        : 'ZERO_TAX_CODE2' ,
					xtype       : 'uniTextfield',
					width       : 150,
					labelWidth  : 70
				},{
					fieldLabel  : '업종명',
					name        : 'ZERO_TAX_CLASS2' ,
					xtype       : 'uniTextfield',
					width       : 90,
					hideLabel   : true
				}]
			},{
				fieldLabel  : '국가',
				xtype       : 'uniCombobox',
				name        : 'ZERO_TAX_NATION2',
				comboType   : 'AU',
				comboCode   : 'B012',
				hidden      : true
			},{
				fieldLabel  : '적용구분',
				xtype       : 'uniCombobox',
				name        : 'CLOSE_DATE',
				comboType   : 'AU',
				comboCode   : 'A246',
				hidden      : true
			},{
				xtype       : 'container',
				layout      : {type: 'uniTable', columns: 2},
				defaultType : 'uniTextfield',
				hidden      : true,
				items       : [{
					fieldLabel  : '업종',
					name        : 'ZERO_TAX_RECIP3' ,
					xtype       : 'uniTextfield',
					width       : 150,
					labelWidth  : 70
				},{
					fieldLabel  : '업종명',
					name        : 'ZERO_TAX_CLASS' ,
					xtype       : 'uniTextfield',
					width       : 90,
					hideLabel   : true
				}]
			},{
				fieldLabel  : '국가',
				xtype       : 'uniCombobox',
				name        : 'ZERO_TAX_NATION3',
				comboType   : 'AU',
				comboCode   : 'B012',
				hidden      : true
			}]
		},{
			title: '과세표준명세',
			xtype: 'fieldset',
			padding: '5 5 5 5',
			layout: {
				type: 'uniTable',
				columns:5,
				tableAttrs: {style: 'border : 1px solid #ced9e7;', width: '100%'},
				tdAttrs: {style: 'border : 1px solid #ced9e7;', align : 'center'}
			},
			items: [
				{ xtype: 'component',  html:''},
				{ xtype: 'component',  html:'업태'},
				{ xtype: 'component',  html:'종목'},
				{ xtype: 'component',  html:'코드번호'},
				{ xtype: 'component',  html:'금액'},

				{ xtype: 'component',  html:'(28)'},
				{ xtype: 'uniTextfield', name: 'COMP_TYPE1', id: 'Tempset1'},
				{ xtype: 'uniTextfield', name: 'COMP_CLASS1', id: 'Tempset2'},
				{ xtype: 'uniTextfield', name: 'COMP_CODE1', id: 'Tempset3'},
				{ xtype: 'uniNumberfield', name: 'COMP_AMT1', id: 'Tempset4',value:0},

				{ xtype: 'component',  html:'(29)'},
				{ xtype: 'uniTextfield', name: 'COMP_TYPE2', id: 'Tempset5'},
				{ xtype: 'uniTextfield', name: 'COMP_CLASS2',id: 'Tempset6'},
				{ xtype: 'uniTextfield', name: 'COMP_CODE2', id: 'Tempset7'},
				{ xtype: 'uniNumberfield', name: 'COMP_AMT2', id: 'Tempset8',value:0},

				{ xtype: 'component',  html:'(30)'},
				{ xtype: 'uniTextfield', name: 'COMP_TYPE3', id: 'Tempset9'},
				{ xtype: 'uniTextfield', name: 'COMP_CLASS3',id: 'Tempset10'},
				{ xtype: 'uniTextfield', name: 'COMP_CODE3', id: 'Tempset11'},
				{ xtype: 'uniNumberfield', name: 'COMP_AMT3', id: 'Tempset12',value:0},

				{ xtype: 'component',  html:'(31)'},
				{ xtype: 'component',  html:'수입금액제외'},
				{ xtype: 'uniTextfield', name: 'COMP_CLASS4', id: 'Tempset13'},
				{ xtype: 'uniTextfield', name: 'COMP_CODE4', id: 'Tempset14'},
				{ xtype: 'uniNumberfield', name: 'COMP_AMT4', id: 'Tempset15',value:0},

				{ xtype: 'component',  html:'(32)'},
				{ xtype: 'component',  html:'합 계'},
				{ xtype: 'component',  html:''},
				{ xtype: 'component',  html:''},
				{ xtype: 'uniNumberfield', name: 'AMT_TOT_25', id: 'Tempset16',value:0,readOnly:true}
			]
		},{
			title: '면세사업수입금액',
			xtype: 'fieldset',
			padding: '5 5 5 5',
			layout: {
				type: 'uniTable',
				columns:5,
				tableAttrs: {style: 'border : 1px solid #ced9e7;', width: '100%'},
				tdAttrs: {style: 'border : 1px solid #ced9e7;', align : 'center'}
			},
			items: [
				{ xtype: 'component',  html:''},
				{ xtype: 'component',  html:'업태'},
				{ xtype: 'component',  html:'종목'},
				{ xtype: 'component',  html:'코드번호'},
				{ xtype: 'component',  html:'금액'},

				{ xtype: 'component',  html:'(80)'},
				{ xtype: 'uniTextfield', name: 'FREE_TYPE1', id: 'Tempset17'},
				{ xtype: 'uniTextfield', name: 'FREE_CLASS1', id: 'Tempset18'},
				{ xtype: 'uniTextfield', name: 'FREE_CODE1', id: 'Tempset19'},
				{ xtype: 'uniNumberfield', name: 'FREE_AMT1', id: 'Tempset20',value:0},

				{ xtype: 'component',  html:'(81)'},
				{ xtype: 'uniTextfield', name: 'FREE_TYPE2', id: 'Tempset21'},
				{ xtype: 'uniTextfield', name: 'FREE_CLASS2', id: 'Tempset22'},
				{ xtype: 'uniTextfield', name: 'FREE_CODE2', id: 'Tempset23'},
				{ xtype: 'uniNumberfield', name: 'FREE_AMT2', id: 'Tempset24',value:0},

				{ xtype: 'component',  html:'(82)'},
				{ xtype: 'component',  html:'수입금액제외'},
				{ xtype: 'uniTextfield', name: 'FREE_CLASS3', id: 'Tempset25'},
				{ xtype: 'uniTextfield', name: 'FREE_CODE3', id: 'Tempset26'},
				{ xtype: 'uniNumberfield', name: 'FREE_AMT3', id: 'Tempset27',value:0},

				{ xtype: 'component',  html:''},
				{ xtype: 'component',  html:''},
				{ xtype: 'component',  html:''},
				{ xtype: 'component',  html:'(83)합 계'},
				{ xtype: 'uniNumberfield', name: 'AMT_TOT_52', id: 'Tempset28',value:0,readOnly:true}
			]
		},{
			title: '계산서발급 및 수취내역',
			xtype: 'fieldset',
			padding: '5 5 5 5',
			layout: {
				type: 'uniTable',
				columns:5,
				tableAttrs: {style: 'border : 1px solid #ced9e7;', width: '100%'},
				tdAttrs: {style: 'border : 1px solid #ced9e7;', align : 'center'}
			},
			items: [
				{ xtype: 'component',  html:'(84)'},
				{ xtype: 'component',  html:'계산서 발급금액',colspan:3},
				{ xtype: 'uniNumberfield', name: 'AMT_53', id: 'Tempset29',value:0},

				{ xtype: 'component',  html:'(85)'},
				{ xtype: 'component',  html:'계산서 수취금액',colspan:3},
				{ xtype: 'uniNumberfield', name: 'AMT_54', id: 'Tempset30',value:0}
			]
		},{
			title: '신고년월일',
			xtype: 'fieldset',
			padding: '5 5 5 5',
			items: [{
				fieldLabel: ' ',
				xtype: 'uniDatefield',
				name:'DECLARE_DATE'
			}]
		}],

		openCryptBankAccntPopup:function() {
			var record = this;

			var params = {'BANK_ACCNT_CODE': this.getValue('BANK_ACCOUNT')};
			Unilite.popupCryptBankAccnt('form', record, 'BANK_ACCOUNT_EXPOS', 'BANK_ACCOUNT', params);

		},
		listeners : {
				uniOnChange:function( basicForm, dirty, eOpts ) {
				if(basicForm.isDirty()) {
					if(resetButtonFlag == 'Y'){
						UniAppManager.setToolbarButtons('save', false);
					}else{
						UniAppManager.setToolbarButtons('save', true);
					}
				}else {
					UniAppManager.setToolbarButtons('save', false);
				}
			}
		}
	});


	function openSumTableSetUpWindow() {			//설정
		if(!SumTableSetUpWindow) {
			SumTableSetUpWindow = Ext.create('widget.uniDetailWindow', {
				title: '설정',
				header: {
					titleAlign: 'center'
				},
				width: 800,
				height: 800,
				layout: {type:'vbox', align:'stretch'},
				items: [sumTableSetUp],
				dockedItems: [{
					xtype: 'toolbar',
					dock: 'bottom',
					items: [
						'->',{ xtype: 'button', text: '확인',
							handler: function() {
								if(Ext.getCmp('rdoSelect1').getValue().DIVI == '2'){
									if(Ext.getCmp('rdoElectricB').getValue().rdoElectric == 'A'){
										sumTableSub5.setValue('TAX_16_46',10000);
									}
									UniAppManager.app.setSumTableSub5SumValue();
									UniAppManager.app.setSumTableSumValue();
								}
								SumTableSetUpWindow.hide();
								UniAppManager.setToolbarButtons('save',true);
							}
						},
						{ xtype: 'button', text: '닫기',
							handler: function() {
								SumTableSetUpWindow.close();
								if(Ext.getCmp('rdoSelect1').getValue().DIVI == '2'){
									sumTableSub5.setValue('TAX_16_46',10000);
									UniAppManager.app.setSumTableSub5SumValue();
									UniAppManager.app.setSumTableSumValue();
								}
							}
						}
					]
				}],
				listeners : {
					show: function( panel, eOpts )	{
						DIVI = Ext.getCmp('rdoSelect1').getValue().DIVI;
						PRE_RE_CANCEL = Ext.getCmp('rdoSelect2').getValue().PRE_RE_CANCEL;

						BUSINESS_BANK_CODE = sumTableSetUp.getValue('BUSINESS_BANK_CODE');
						BUSINESS_BANK_NAME = sumTableSetUp.getValue('BUSINESS_BANK_NAME');
						BRANCH_NAME = sumTableSetUp.getValue('BRANCH_NAME');
						BANK_ACCOUNT = sumTableSetUp.getValue('BANK_ACCOUNT');
						CLOSE_DATE = sumTableSetUp.getValue('CLOSE_DATE');
						CLOSE_REASON = sumTableSetUp.getValue('CLOSE_REASON');
						COMP_TYPE1 = sumTableSetUp.getValue('COMP_TYPE1');
						COMP_CLASS1 = sumTableSetUp.getValue('COMP_CLASS1');
						COMP_CODE1 = sumTableSetUp.getValue('COMP_CODE1');
						COMP_AMT1 = sumTableSetUp.getValue('COMP_AMT1');
						COMP_TYPE2 = sumTableSetUp.getValue('COMP_TYPE2');
						COMP_CLASS2 = sumTableSetUp.getValue('COMP_CLASS2');
						COMP_CODE2 = sumTableSetUp.getValue('COMP_CODE2');
						COMP_AMT2 = sumTableSetUp.getValue('COMP_AMT2');
						COMP_TYPE3 = sumTableSetUp.getValue('COMP_TYPE3');
						COMP_CLASS3 = sumTableSetUp.getValue('COMP_CLASS3');
						COMP_CODE3 = sumTableSetUp.getValue('COMP_CODE3');
						COMP_AMT3 = sumTableSetUp.getValue('COMP_AMT3');
						COMP_CLASS4 = sumTableSetUp.getValue('COMP_CLASS4');
						COMP_CODE4 = sumTableSetUp.getValue('COMP_CODE4');
						COMP_AMT4 = sumTableSetUp.getValue('COMP_AMT4');
						AMT_TOT_25 = sumTableSetUp.getValue('AMT_TOT_25');
						FREE_TYPE1 = sumTableSetUp.getValue('FREE_TYPE1');
						FREE_CLASS1 = sumTableSetUp.getValue('FREE_CLASS1');
						FREE_CODE1 = sumTableSetUp.getValue('FREE_CODE1');
						FREE_AMT1 = sumTableSetUp.getValue('FREE_AMT1');
						FREE_TYPE2 = sumTableSetUp.getValue('FREE_TYPE2');
						FREE_CLASS2 = sumTableSetUp.getValue('FREE_CLASS2');
						FREE_CODE2 = sumTableSetUp.getValue('FREE_CODE2');
						FREE_AMT2 = sumTableSetUp.getValue('FREE_AMT2');
						FREE_CLASS3 = sumTableSetUp.getValue('FREE_CLASS3');
						FREE_CODE3 = sumTableSetUp.getValue('FREE_CODE3');
						FREE_AMT3 = sumTableSetUp.getValue('FREE_AMT3');
						AMT_TOT_52 = sumTableSetUp.getValue('AMT_TOT_52');
						AMT_53 = sumTableSetUp.getValue('AMT_53');
						AMT_54 = sumTableSetUp.getValue('AMT_54');
						DECLARE_DATE = sumTableSetUp.getValue('DECLARE_DATE');


						// 20210526 추가(영세율 상호주의)
						ZERO_TAX_RECIP1  = sumTableSetUp.getValue('ZERO_TAX_RECIP1');
						ZERO_TAX_CLASS1  = sumTableSetUp.getValue('ZERO_TAX_CLASS1');
						ZERO_TAX_CODE1   = sumTableSetUp.getValue('ZERO_TAX_CODE1');
						ZERO_TAX_NATION1 = sumTableSetUp.getValue('ZERO_TAX_NATION1');
						ZERO_TAX_RECIP2  = sumTableSetUp.getValue('ZERO_TAX_RECIP2');
						ZERO_TAX_CLASS2  = sumTableSetUp.getValue('ZERO_TAX_CLASS2');
						ZERO_TAX_CODE2   = sumTableSetUp.getValue('ZERO_TAX_CODE2');
						ZERO_TAX_NATION2 = sumTableSetUp.getValue('ZERO_TAX_NATION2');
						ZERO_TAX_RECIP3  = sumTableSetUp.getValue('ZERO_TAX_RECIP3');
						ZERO_TAX_CLASS3  = sumTableSetUp.getValue('ZERO_TAX_CLASS3');
						ZERO_TAX_CODE3   = sumTableSetUp.getValue('ZERO_TAX_CODE3');
						ZERO_TAX_NATION3 = sumTableSetUp.getValue('ZERO_TAX_NATION3');
					},
					beforehide: function(me, eOpt)	{
					},
					beforeclose: function( panel, eOpts )	{
						sumTableSetUp.getField('DIVI').setValue(DIVI);
						sumTableSetUp.getField('PRE_RE_CANCEL').setValue(PRE_RE_CANCEL);
						sumTableSetUp.setValue('BUSINESS_BANK_CODE', BUSINESS_BANK_CODE);
						sumTableSetUp.setValue('BUSINESS_BANK_NAME', BUSINESS_BANK_NAME);
						sumTableSetUp.setValue('BRANCH_NAME', BRANCH_NAME);
						sumTableSetUp.setValue('BANK_ACCOUNT', BANK_ACCOUNT);
						sumTableSetUp.setValue('CLOSE_DATE', CLOSE_DATE);
						sumTableSetUp.setValue('CLOSE_REASON', CLOSE_REASON);
						sumTableSetUp.setValue('COMP_TYPE1', COMP_TYPE1);
						sumTableSetUp.setValue('COMP_CLASS1', COMP_CLASS1);
						sumTableSetUp.setValue('COMP_CODE1', COMP_CODE1);
						sumTableSetUp.setValue('COMP_AMT1', COMP_AMT1);
						sumTableSetUp.setValue('COMP_TYPE2', COMP_TYPE2);
						sumTableSetUp.setValue('COMP_CLASS2', COMP_CLASS2);
						sumTableSetUp.setValue('COMP_CODE2', COMP_CODE2);
						sumTableSetUp.setValue('COMP_AMT2', COMP_AMT2);
						sumTableSetUp.setValue('COMP_TYPE3', COMP_TYPE3);
						sumTableSetUp.setValue('COMP_CLASS3', COMP_CLASS3);
						sumTableSetUp.setValue('COMP_CODE3', COMP_CODE3);
						sumTableSetUp.setValue('COMP_AMT3', COMP_AMT3);
						sumTableSetUp.setValue('COMP_CLASS4', COMP_CLASS4);
						sumTableSetUp.setValue('COMP_CODE4', COMP_CODE4);
						sumTableSetUp.setValue('COMP_AMT4', COMP_AMT4);
						sumTableSetUp.setValue('AMT_TOT_25', AMT_TOT_25);
						sumTableSetUp.setValue('FREE_TYPE1', FREE_TYPE1);
						sumTableSetUp.setValue('FREE_CLASS1', FREE_CLASS1);
						sumTableSetUp.setValue('FREE_CODE1', FREE_CODE1);
						sumTableSetUp.setValue('FREE_AMT1', FREE_AMT1);
						sumTableSetUp.setValue('FREE_TYPE2', FREE_TYPE2);
						sumTableSetUp.setValue('FREE_CLASS2', FREE_CLASS2);
						sumTableSetUp.setValue('FREE_CODE2', FREE_CODE2);
						sumTableSetUp.setValue('FREE_AMT2', FREE_AMT2);
						sumTableSetUp.setValue('FREE_CLASS3', FREE_CLASS3);
						sumTableSetUp.setValue('FREE_CODE3', FREE_CODE3);
						sumTableSetUp.setValue('FREE_AMT3', FREE_AMT3);
						sumTableSetUp.setValue('AMT_TOT_52', AMT_TOT_52);
						sumTableSetUp.setValue('AMT_53', AMT_53);
						sumTableSetUp.setValue('AMT_54', AMT_54);
						sumTableSetUp.setValue('DECLARE_DATE', DECLARE_DATE);


						// 20210526 추가(영세율 상호주의)
						sumTableSetUp.setValue('ZERO_TAX_RECIP1' , ZERO_TAX_RECIP1);
						sumTableSetUp.setValue('ZERO_TAX_CLASS1' , ZERO_TAX_CLASS1);
						sumTableSetUp.setValue('ZERO_TAX_CODE1'  , ZERO_TAX_CODE1);
						sumTableSetUp.setValue('ZERO_TAX_NATION1', ZERO_TAX_NATION1);
						sumTableSetUp.setValue('ZERO_TAX_RECIP2' , ZERO_TAX_RECIP2);
						sumTableSetUp.setValue('ZERO_TAX_CLASS2' , ZERO_TAX_CLASS2);
						sumTableSetUp.setValue('ZERO_TAX_CODE2'  , ZERO_TAX_CODE2);
						sumTableSetUp.setValue('ZERO_TAX_NATION2', ZERO_TAX_NATION2);
						sumTableSetUp.setValue('ZERO_TAX_RECIP3' , ZERO_TAX_RECIP3);
						sumTableSetUp.setValue('ZERO_TAX_CLASS3' , ZERO_TAX_CLASS3);
						sumTableSetUp.setValue('ZERO_TAX_CODE3'  , ZERO_TAX_CODE3);
						sumTableSetUp.setValue('ZERO_TAX_NATION3', ZERO_TAX_NATION3);
		 			}
				}
			})
		}
		SumTableSetUpWindow.center();
		SumTableSetUpWindow.show();
	}
	var sumTable = Unilite.createForm('detailForm',{
		padding:'0 0 0 0',
		disabled: false,
		flex: 1.5,
		bodyPadding: 10,
		region: 'center',
		layout: {
			type: 'uniTable',
			columns:11,
			tableAttrs: {style: 'border : 1px solid #ced9e7;', width: 1012},
			tdAttrs: {style: 'border : 1px solid #ced9e7;', align : 'center'}
		},
		tbar: [
		{
			xtype: 'toolbar',
			id:'temp5',
			margin: '0 0 0 0',
			width:500,
			border:false,
			layout: {
				type: 'hbox',
				align: 'center',
				pack:'center'

			},
			items:[{
				xtype: 'button',
				text: '재참조',
				width: 100,
				margin: '0 0 0 0',
				handler : function() {
					if(!UniAppManager.app.checkForNewDetail()){
						return false;
					}else{
						var param = {"txtFrPubDate": UniDate.getDbDateStr(panelSearch.getValue('txtFrPubDate')),
							"txtToPubDate": UniDate.getDbDateStr(panelSearch.getValue('txtToPubDate')),
							"txtBillDivCode": panelSearch.getValue('txtBillDivCode')
						};
						atx301ukrService.dataCheck(param, function(provider, response)	{
							if(!Ext.isEmpty(provider)){
								if(confirm('기존자료가 존재합니다. 재참조하는 경우 기존자료는 삭제됩니다. 재참조하시겠습니까?')) {
									sumTable.mask('loading...');
									panelSearch.setValue('RE_REFERENCE','Y');
									var param= panelSearch.getValues();

									sumTable.getForm().load({

										params: param,
										success: function(form, action) {
											UniAppManager.app.setSumTableSubData(action);
											UniAppManager.app.setSumTableSub1SumValue();
											UniAppManager.app.setSumTableSub2SumValue();
											UniAppManager.app.setSumTableSub3SumValue();
											UniAppManager.app.setSumTableSub4SumValue();
											UniAppManager.app.setSumTableSub5SumValue();
											UniAppManager.app.setSumTableSub6SumValue();
											UniAppManager.app.setSumTableSetUpSumValue();
											UniAppManager.app.setSumTableSumValue();

											SAVE_FLAG == 'U';
											// 정기신고와 수정신고내역 다른 값 표시
											var fields = sumTable.form.getFields()
											Ext.each(fields.items, function(item) {
												UniAppManager.app.setTableDiffValue(item.name, item.value);
											});

											sumTable.unmask();

											panelSearch.setValue('RE_REFERENCE','');
											UniAppManager.setToolbarButtons('delete',false);
											sumTable.getField('AMT_1').focus();
										},
										failure: function(form, action) {
											sumTable.unmask();
											panelSearch.setValue('RE_REFERENCE','');
										}
									});
									panelResult.setAllFieldsReadOnly(true);

								}else{
									return false;
								}
							}else{
								sumTable.mask('loading...');
									panelSearch.setValue('RE_REFERENCE','Y');
									var param= panelSearch.getValues();

									sumTable.getForm().load({

										params: param,
										success: function(form, action) {
											UniAppManager.app.setSumTableSubData(action);
											UniAppManager.app.setSumTableSub1SumValue();
											UniAppManager.app.setSumTableSub2SumValue();
											UniAppManager.app.setSumTableSub3SumValue();
											UniAppManager.app.setSumTableSub4SumValue();
											UniAppManager.app.setSumTableSub5SumValue();
											UniAppManager.app.setSumTableSub6SumValue();
											UniAppManager.app.setSumTableSetUpSumValue();
											UniAppManager.app.setSumTableSumValue();

											SAVE_FLAG = action.result.data.SAVE_FLAG;
											// 정기신고와 수정신고내역 다른 값 표시
											var fields = sumTable.form.getFields()
											Ext.each(fields.items, function(item) {
												UniAppManager.app.setTableDiffValue(item.name, item.value);
											});
											sumTable.unmask();

											panelSearch.setValue('RE_REFERENCE','');
											UniAppManager.setToolbarButtons('delete',false);
										},
										failure: function(form, action) {
											sumTable.unmask();
											panelSearch.setValue('RE_REFERENCE','');
										}
									});
									panelResult.setAllFieldsReadOnly(true);
							}
						});
					}
				}
			},{
				xtype: 'button',
				text: '설정',
				width: 100,
				margin: '0 0 0 0',
				handler : function() {
					openSumTableSetUpWindow()
				}
			},{
				xtype: 'button',
				text: '출력',
				width: 100,
				margin: '0 0 0 0',
				handler : function() {
					UniAppManager.app.onPrintButtonDown(1);
				}
			},{
				xtype: 'button',
				text: '납부서',
				width: 100,
				margin: '0 0 0 0',
				handler : function() {
					UniAppManager.app.onPrintButtonDown(2);
				}
			}]
	}],
		items: [
			// Title
			{ xtype: 'component',  html:'<b>정 기 신 고 내 역</b>', colspan: 7,tdAttrs: {width:1012,height:27}},
			{ xtype: 'component',  html:'<b>수 정 신 고 내 역</b>', colspan: 4,tdAttrs: {width:600,height:27}},

			// 정기
			{ xtype: 'component',  html:'구&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' +
				'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;분', colspan: 4,width:500,tdAttrs: {height:27}},
			{ xtype: 'component',  html:'금&nbsp;&nbsp;&nbsp;&nbsp;액',width: 180},
			{ xtype: 'component',  html:'세&nbsp;&nbsp;&nbsp;&nbsp;율', width:100},
			{ xtype: 'component',  html:'세&nbsp;&nbsp;&nbsp;&nbsp;액',width: 180},
			// 수정
			{ xtype: 'component',  html:'', colspan: 1,width:100,tdAttrs: {height:27}},
			{ xtype: 'component',  html:'금&nbsp;&nbsp;&nbsp;&nbsp;액',width: 180},
			{ xtype: 'component',  html:'세&nbsp;&nbsp;&nbsp;&nbsp;율', width:100},
			{ xtype: 'component',  html:'세&nbsp;&nbsp;&nbsp;&nbsp;액',width: 180},

			// 과세표준매출세액
			{ xtype: 'component', html:'과</br>세</br>표</br>준</br>매</br>출</br>세</br>액', rowspan: 9},
			{ xtype: 'component', html:'과</br>세', rowspan: 4},
			{ xtype: 'component', html:'세 금 계 산 서 교 부 분'},
			{ xtype: 'component', html:'(1)'},
			{ xtype: 'uniNumberfield', value:0,	name:'AMT_1_ROU',width: 180, readOnly:true},
			{ xtype: 'component', html:'10/100'},
			{ xtype: 'uniNumberfield', value:0,	name:'TAX_1_ROU',width: 180, readOnly:true},
			{ xtype: 'component', html:'(1)'},
			{ xtype: 'uniNumberfield', value:0,	name:'AMT_1',width: 180},
			{ xtype: 'component', html:'10/100'},
			{ xtype: 'uniNumberfield', value:0,	name:'TAX_1',width: 180},

			//과세
			{ xtype: 'component', html:'매&nbsp;&nbsp;입&nbsp;&nbsp;자&nbsp;&nbsp;' +
				'발행세금계산서', width: 250,tdAttrs: {width:250}},
			{ xtype: 'component', html:'(2)', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:0,	name:'AMT_57_ROU', width: '100%',tdAttrs: {width:'100%'}, readOnly:true},
			{ xtype: 'component', html:'10/100', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:0,	name:'TAX_57_ROU', width: '100%',tdAttrs: {width:'100%'}, readOnly:true},
			{ xtype: 'component', html:'(2)', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:0,	name:'AMT_57', width: '100%',tdAttrs: {width:'100%'}},
			{ xtype: 'component', html:'10/100', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:0,	name:'TAX_57', width: '100%',tdAttrs: {width:'100%'}},

			{ xtype: 'component', html:'신용카드 · 현금영수증발행분', width: 250,tdAttrs: {width:250}},
			{ xtype: 'component', html:'(3)', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:0,	name:'AMT_62_ROU', width: '100%',tdAttrs: {width:'100%'}, readOnly:true},
			{ xtype: 'component', html:'10/100', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:0,	name:'TAX_62_ROU', width: '100%',tdAttrs: {width:'100%'}, readOnly:true},
			{ xtype: 'component', html:'(3)', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:0,	name:'AMT_62', width: '100%',tdAttrs: {width:'100%'}},
			{ xtype: 'component', html:'10/100', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:0,	name:'TAX_62', width: '100%',tdAttrs: {width:'100%'}},

			{ xtype: 'component', html:'기타(정규영수증 외 매출분)', width: 250,tdAttrs: {width:250}},
			{ xtype: 'component', html:'(4)', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:0,	name:'AMT_2_ROU', width: '100%',tdAttrs: {width:'100%'}, readOnly:true},
			{ xtype: 'component', html:'10/100', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:0,	name:'TAX_2_ROU', width: '100%',tdAttrs: {width:'100%'}, readOnly:true},
			{ xtype: 'component', html:'(4)', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:0,	name:'AMT_2', width: '100%',tdAttrs: {width:'100%'}},
			{ xtype: 'component', html:'10/100', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:0,	name:'TAX_2', width: '100%',tdAttrs: {width:'100%'}},

			//영세
			{ xtype: 'component', html:'영</br>세', rowspan: 2, width: 100,tdAttrs: {width:100}},
			{ xtype: 'component', html:'세 금 계 산 서 교 부 분', width: 250,tdAttrs: {width:250}},
			{ xtype: 'component', html:'(5)', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:0,	name:'AMT_3_ROU', width: '100%',tdAttrs: {width:'100%'}, readOnly:true},
			{ xtype: 'component', html:'0/100', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', readOnly:true, width: '100%',tdAttrs: {width:'100%'}},
			{ xtype: 'component', html:'(5)', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:0,	name:'AMT_3', width: '100%',tdAttrs: {width:'100%'}},
			{ xtype: 'component', html:'0/100', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', readOnly:true, width: '100%',tdAttrs: {width:'100%'}},

			{ xtype: 'component', html:'기&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' +
				'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' +
				'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;타', width: 250,tdAttrs: {width:250}},
			{ xtype: 'component', html:'(6)', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:0,	name:'AMT_4_ROU', width: '100%',tdAttrs: {width:'100%'}, readOnly:true},
			{ xtype: 'component', html:'0/100', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', readOnly:true, width: '100%',tdAttrs: {width:'100%'}},
			{ xtype: 'component', html:'(6)', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:0,	name:'AMT_4', width: '100%',tdAttrs: {width:'100%'}},
			{ xtype: 'component', html:'0/100', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', readOnly:true, width: '100%',tdAttrs: {width:'100%'}},

			{ xtype: 'button', text: '예 정 신 고 누 락 분', colspan:2, width: '100%',tdAttrs: {width:'100%'},
				handler : function() {
					openSumTableSub1Window()
				}
			},
			{ xtype: 'component', html:'(7)', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:0,	name:'AMT_5_ROU', readOnly:true, width: '100%',tdAttrs: {width:'100%'}},
			{ xtype: 'component', html:'', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:0,	name:'TAX_5_ROU', readOnly:true, width: '100%',tdAttrs: {width:'100%'}},
			{ xtype: 'component', html:'(7)', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:0,	name:'AMT_5', readOnly:true, width: '100%',tdAttrs: {width:'100%'}},
			{ xtype: 'component', html:'', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:0,	name:'TAX_5', readOnly:true, width: '100%',tdAttrs: {width:'100%'}},

			{ xtype: 'component', html:'대&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;손&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' +
				'세&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;액&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;가&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;감'
				, colspan:2	, width: 350,tdAttrs: {width:350}},
			{ xtype: 'component', html:'(8)', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', readOnly:true, width: '100%',tdAttrs: {width:'100%'}},
			{ xtype: 'component', html:'', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:0,	name:'TAX_6_ROU', width: '100%',tdAttrs: {width:'100%'}, readOnly:true},
			{ xtype: 'component', html:'(8)', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', readOnly:true, width: '100%',tdAttrs: {width:'100%'}},
			{ xtype: 'component', html:'', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:0,	name:'TAX_6', width: '100%',tdAttrs: {width:'100%'}},

			//위쪽 컬럼 합계 표시해야함
			{ xtype: 'component', html:'합&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' +
				'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' +
				'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' +
				'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' +
				'&nbsp;&nbsp;계', colspan:2, width: 350,tdAttrs: {width:350}},
			{ xtype: 'component', html:'(9)', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:0,	name:'AMT_TOT_7_ROU', readOnly:true, width: '100%',tdAttrs: {width:'100%'}},
			{ xtype: 'component', html:'㉮', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:0,	name:'TAX_TOT_7_ROU', readOnly:true, width: '100%',tdAttrs: {width:'100%'}},
			{ xtype: 'component', html:'(9)', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:0,	name:'AMT_TOT_7', readOnly:true, width: '100%',tdAttrs: {width:'100%'}},
			{ xtype: 'component', html:'㉮', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:0,	name:'TAX_TOT_7', readOnly:true, width: '100%',tdAttrs: {width:'100%'}},
			//End of 과세표준매출세액

			//매입세액
			{ xtype: 'component', html:'매</br>입</br>세</br>액', rowspan: 8, width: 50,tdAttrs: {width:50}},
			{ xtype: 'component', html:'세금계산서</br>수취분', rowspan: 3, width: 100,tdAttrs: {width:100}},
			{ xtype: 'component', html:'일&nbsp;&nbsp;&nbsp;&nbsp;반&nbsp;&nbsp;&nbsp;매&nbsp;&nbsp;&nbsp;&nbsp;입', width: 250,tdAttrs: {width:250}},
			{ xtype: 'component', html:'(10)', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:0,	name:'AMT_8_ROU', width: '100%',tdAttrs: {width:'100%'}, readOnly:true},
			{ xtype: 'component', html:'', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:0,	name:'TAX_8_ROU', width: '100%',tdAttrs: {width:'100%'}, readOnly:true},
			{ xtype: 'component', html:'(10)', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:0,	name:'AMT_8', width: '100%',tdAttrs: {width:'100%'}},
			{ xtype: 'component', html:'', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:0,	name:'TAX_8', width: '100%',tdAttrs: {width:'100%'}},

			{ xtype: 'component', html:'수출기업 수입분 납부유예', width: 250,tdAttrs: {width:250}},
			{ xtype: 'component', html:'(10-1)', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', readOnly:true, width: '100%',tdAttrs: {width:'100%'}},
			{ xtype: 'component', html:'', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:0,	name:'TAX_10_1_ROU', width: '100%',tdAttrs: {width:'100%'}, readOnly:true},
			{ xtype: 'component', html:'(10-1)', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', readOnly:true, width: '100%',tdAttrs: {width:'100%'}},
			{ xtype: 'component', html:'', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:0,	name:'TAX_10_1', width: '100%',tdAttrs: {width:'100%'}},

			{ xtype: 'component', html:'고 정 자 산 매 입', width: 250,tdAttrs: {width:250}},
			{ xtype: 'component', html:'(11)', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:0,	name:'AMT_9_ROU', width: '100%',tdAttrs: {width:'100%'}, readOnly:true},
			{ xtype: 'component', html:'', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:0,	name:'TAX_9_ROU', width: '100%',tdAttrs: {width:'100%'}, readOnly:true},
			{ xtype: 'component', html:'(11)', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:0,	name:'AMT_9', width: '100%',tdAttrs: {width:'100%'}},
			{ xtype: 'component', html:'', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:0,	name:'TAX_9', width: '100%',tdAttrs: {width:'100%'}},

			{ xtype: 'button', text: '예 정 신 고 누 락 분', colspan:2, width: '100%',tdAttrs: {width:'100%'},
				handler : function() {
					openSumTableSub2Window()
				}
			},
			{ xtype: 'component', html:'(12)', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:0,	name:'AMT_TOT_10_34_ROU', readOnly:true, width: '100%',tdAttrs: {width:'100%'}},
			{ xtype: 'component', html:'', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:0,	name:'TAX_TOT_10_34_ROU', readOnly:true, width: '100%',tdAttrs: {width:'100%'}},
			{ xtype: 'component', html:'(12)', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:0,	name:'AMT_TOT_10_34', readOnly:true, width: '100%',tdAttrs: {width:'100%'}},
			{ xtype: 'component', html:'', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:0,	name:'TAX_TOT_10_34', readOnly:true, width: '100%',tdAttrs: {width:'100%'}},

			{ xtype: 'component', html:'매  입  자  발  행  세  금  계 산 서', colspan:2, width: 350,tdAttrs: {width:350}},
			{ xtype: 'component', html:'(13)', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:0,	name:'AMT_58_ROU', width: '100%',tdAttrs: {width:'100%'}, readOnly:true},
			{ xtype: 'component', html:'', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:0,	name:'TAX_58_ROU', width: '100%',tdAttrs: {width:'100%'}, readOnly:true},
			{ xtype: 'component', html:'(13)', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:0,	name:'AMT_58', width: '100%',tdAttrs: {width:'100%'}},
			{ xtype: 'component', html:'', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:0,	name:'TAX_58', width: '100%',tdAttrs: {width:'100%'}},

			{ xtype: 'button', text: '그 밖의 공 제 매 입 세 액', colspan:2, width: '100%',tdAttrs: {width:'100%'},
				handler : function() {
					openSumTableSub3Window()
				}
			},
			{ xtype: 'component', html:'(14)', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:0,	name:'AMT_10_ROU', readOnly:true, width: '100%',tdAttrs: {width:'100%'}},
			{ xtype: 'component', html:'', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:0,	name:'TAX_10_ROU', readOnly:true, width: '100%',tdAttrs: {width:'100%'}},
			{ xtype: 'component', html:'(14)', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:0,	name:'AMT_10', readOnly:true, width: '100%',tdAttrs: {width:'100%'}},
			{ xtype: 'component', html:'', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:0,	name:'TAX_10', readOnly:true, width: '100%',tdAttrs: {width:'100%'}},

			//위쪽 컬럼 합계 표시해야함(15, 16, 17)
			{ xtype: 'component', html:'합 계 ( ⑩ -(10-1) + ⑪ + ⑫ + ⑬ + ⑭ )', colspan:2, width: 350,tdAttrs: {width:350}},
			{ xtype: 'component', html:'(15)', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:0,	name:'AMT_TOT_11_ROU', readOnly:true, width: '100%',tdAttrs: {width:'100%'}},
			{ xtype: 'component', html:'', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:0,	name:'TAX_TOT_11_ROU', readOnly:true, width: '100%',tdAttrs: {width:'100%'}},
			{ xtype: 'component', html:'(15)', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:0,	name:'AMT_TOT_11', readOnly:true, width: '100%',tdAttrs: {width:'100%'}},
			{ xtype: 'component', html:'', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:0,	name:'TAX_TOT_11', readOnly:true, width: '100%',tdAttrs: {width:'100%'}},

			{ xtype: 'button', text: '공 제 받 지 못 할 세 액', colspan:2, width: '100%',tdAttrs: {width:'100%'},
				handler : function() {
					openSumTableSub4Window()
				}
			},
			{ xtype: 'component', html:'(16)', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:0,	name:'AMT_TOT_12_ROU', readOnly:true, width: '100%',tdAttrs: {width:'100%'}},
			{ xtype: 'component', html:'', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:0,	name:'TAX_TOT_12_ROU', readOnly:true, width: '100%',tdAttrs: {width:'100%'}},
			{ xtype: 'component', html:'(16)', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:0,	name:'AMT_TOT_12', readOnly:true, width: '100%',tdAttrs: {width:'100%'}},
			{ xtype: 'component', html:'', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:0,	name:'TAX_TOT_12', readOnly:true, width: '100%',tdAttrs: {width:'100%'}},
			// End of 매입세액

			// 차감계
			{ xtype: 'component', html:'차&nbsp;&nbsp;&nbsp;감&nbsp;&nbsp;&nbsp;계&nbsp;&nbsp;&nbsp;' +
				'(&nbsp;&nbsp;&nbsp;(15)&nbsp;&nbsp;&nbsp;-&nbsp;&nbsp;&nbsp;(16)&nbsp;&nbsp;&nbsp;)', colspan:3, width: 400,tdAttrs: {width:400}},
			{ xtype: 'component', html:'(17)', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:0,	name:'AMT_TOT_13_ROU', readOnly:true, width: '100%',tdAttrs: {width:'100%'}},
			{ xtype: 'component', html:'㉯', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:0,	name:'TAX_TOT_13_ROU', readOnly:true, width: '100%',tdAttrs: {width:'100%'}},
			{ xtype: 'component', html:'(17)', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:0,	name:'AMT_TOT_13', readOnly:true, width: '100%',tdAttrs: {width:'100%'}},
			{ xtype: 'component', html:'㉯', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:0,	name:'TAX_TOT_13', readOnly:true, width: '100%',tdAttrs: {width:'100%'}},
			// End of 차감계

			// 납부(환급)세액
			{ xtype: 'component', html:'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' +
			'&nbsp;&nbsp;&nbsp;&nbsp;납 부 (&nbsp;&nbsp;환 급&nbsp;&nbsp;) 세 액&nbsp;&nbsp;' +
			'(&nbsp;&nbsp;매 출 세 액 ㉮&nbsp;&nbsp;-&nbsp;&nbsp;매 입 세 액 ㉯&nbsp;&nbsp;)', colspan:5,/* width: 510,*/
			/*width: '100%',*/ tdAttrs: {align: 'left',width:'100%'}},

			{ xtype: 'component', html:'㉰', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:0,	name:'PAY_TAX_ROU', readOnly:true, width: '100%',tdAttrs: {width:'100%'}},
			{ xtype: 'component', html:'', width: 100,tdAttrs: {width:100}, colspan:2},
			{ xtype: 'component', html:'㉰', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:0,	name:'PAY_TAX', readOnly:true, width: '100%',tdAttrs: {width:'100%'}},
			//End of 납부(환급)세액

			//경감공제세액
			{ xtype: 'component', html:'경 감</br>공 제</br>세 액', rowspan: 3, width: 50,tdAttrs: {width:50}},
			{ xtype: 'button', text: '그 밖의 공 제 . 경 감 세 액', colspan:2, width: '100%',tdAttrs: {width:'100%'},
				handler : function() {
					openSumTableSub5Window()
				}
			},
			{ xtype: 'component', html:'(18)', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:'', readOnly:true, width: '100%',tdAttrs: {width:'100%'}},
			{ xtype: 'component', html:'', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:0,	name:'TAX_15_ROU', readOnly:true, width: '100%',tdAttrs: {width:'100%'}},
			{ xtype: 'component', html:'(18)', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:'', readOnly:true, width: '100%',tdAttrs: {width:'100%'}},
			{ xtype: 'component', html:'', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:0,	name:'TAX_15', readOnly:true, width: '100%',tdAttrs: {width:'100%'}},

			{ xtype: 'component', html:'신용카드 매 출 전 표  발 행 공 제 등', colspan:2, width: 350,tdAttrs: {width:350}},
			{ xtype: 'component', html:'(19)', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:0,	name:'AMT_14_ROU', width: '100%',tdAttrs: {width:'100%'}, readOnly:true},
			{ xtype: 'component', html:'', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:0,	name:'TAX_14_ROU', width: '100%',tdAttrs: {width:'100%'}, readOnly:true},
			{ xtype: 'component', html:'(19)', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:0,	name:'AMT_14', width: '100%',tdAttrs: {width:'100%'}},
			{ xtype: 'component', html:'', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:0,	name:'TAX_14', width: '100%',tdAttrs: {width:'100%'}},

			//위쪽 컬럼 합계 표시해야함
			{ xtype: 'component', html:'합&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' +
				'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' +
				'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' +
				'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' +
				'계', colspan:2, width: 350,tdAttrs: {width:350}},
			{ xtype: 'component', html:'(20)', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:'', readOnly:true, width: '100%',tdAttrs: {width:'100%'}},
			{ xtype: 'component', html:'㉱', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:0,	name:'TAX_TOT_16_ROU', readOnly:true, width: '100%',tdAttrs: {width:'100%'}},
			{ xtype: 'component', html:'(20)', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:'', readOnly:true, width: '100%',tdAttrs: {width:'100%'}},
			{ xtype: 'component', html:'㉱', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:0,	name:'TAX_TOT_16', readOnly:true, width: '100%',tdAttrs: {width:'100%'}},
			//End of 경겜공제세액

			{ xtype: 'component', html:'예&nbsp;&nbsp;&nbsp;&nbsp;정&nbsp;&nbsp;&nbsp;&nbsp;신' +
				'&nbsp;&nbsp;&nbsp;&nbsp;고&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;미&nbsp;&nbsp;&nbsp;&nbsp;환' +
				'&nbsp;&nbsp;&nbsp;&nbsp;급&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;세&nbsp;&nbsp;&nbsp;&nbsp;액', colspan:3, width: 400,tdAttrs: {width:400}},
			{ xtype: 'component', html:'(21)', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:'', readOnly:true, width: '100%',tdAttrs: {width:'100%'}},
			{ xtype: 'component', html:'㉲', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:0,	name:'TAX_17_ROU', width: '100%',tdAttrs: {width:'100%'}, readOnly:true},
			{ xtype: 'component', html:'(21)', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:'', readOnly:true, width: '100%',tdAttrs: {width:'100%'}},
			{ xtype: 'component', html:'㉲', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:0,	name:'TAX_17', width: '100%',tdAttrs: {width:'100%'}},

			{ xtype: 'component', html:'예&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;정&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' +
				'&nbsp;&nbsp;&nbsp;&nbsp;고&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;지&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' +
				'&nbsp;&nbsp;&nbsp;&nbsp;세&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;액', colspan:3, width: 400,tdAttrs: {width:400}},
			{ xtype: 'component', html:'(22)', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:'', readOnly:true, width: '100%',tdAttrs: {width:'100%'}},
			{ xtype: 'component', html:'㉳', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:0,	name:'TAX_18_ROU', width: '100%',tdAttrs: {width:'100%'}, readOnly:true},
			{ xtype: 'component', html:'(22)', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:'', readOnly:true, width: '100%',tdAttrs: {width:'100%'}},
			{ xtype: 'component', html:'㉳', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:0,	name:'TAX_18', width: '100%',tdAttrs: {width:'100%'}},

			{ xtype: 'component', html:'사 업 양 수 자 의&nbsp;&nbsp;&nbsp;대 리 납 부&nbsp;&nbsp;&nbsp;기 납 부 세 액', colspan:3, width: 400,tdAttrs: {width:400}},
			{ xtype: 'component', html:'(23)', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:'', readOnly:true, width: '100%',tdAttrs: {width:'100%'}},
			{ xtype: 'component', html:'㉴', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:0,	name:'TAX_23_ROU', width: '100%',tdAttrs: {width:'100%'}, readOnly:true},
			{ xtype: 'component', html:'(23)', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:'', readOnly:true, width: '100%',tdAttrs: {width:'100%'}},
			{ xtype: 'component', html:'㉴', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:0,	name:'TAX_23', width: '100%',tdAttrs: {width:'100%'}},

			{ xtype: 'component', html:'매&nbsp;&nbsp;입&nbsp;&nbsp;자&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' +
				'납&nbsp;&nbsp;부&nbsp;&nbsp;특&nbsp;&nbsp;례&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;기&nbsp;&nbsp;' +
				'납&nbsp;&nbsp;부&nbsp;&nbsp;세&nbsp;&nbsp;액', colspan:3, width: 400,tdAttrs: {width:400}},
			{ xtype: 'component', html:'(24)', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:'', readOnly:true, width: '100%',tdAttrs: {width:'100%'}},
			{ xtype: 'component', html:'㉵', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:0,	name:'TAX_59_ROU', width: '100%',tdAttrs: {width:'100%'}, readOnly:true},
			{ xtype: 'component', html:'(24)', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:'', readOnly:true, width: '100%',tdAttrs: {width:'100%'}},
			{ xtype: 'component', html:'㉵', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:0,	name:'TAX_59', width: '100%',tdAttrs: {width:'100%'}},

			{ xtype: 'component', html:'신 용 카 드 업 자 의&nbsp;&nbsp;대 리 납 부&nbsp;&nbsp;기 납 부 세 액', colspan:3, width: 400,tdAttrs: {width:400}},
			{ xtype: 'component', html:'(25)', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:'', readOnly:true, width: '100%',tdAttrs: {width:'100%'}},
			{ xtype: 'component', html:'㉶', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:0,	name:'TAX_77_ROU', width: '100%',tdAttrs: {width:'100%'}, readOnly:true},
			{ xtype: 'component', html:'(25)', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:'', readOnly:true, width: '100%',tdAttrs: {width:'100%'}},
			{ xtype: 'component', html:'㉶', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:0,	name:'TAX_77', width: '100%',tdAttrs: {width:'100%'}},

			//위쪽 컬럼 합계 표시해야함 (19, 20)
			{ xtype: 'button', text: '가&nbsp;&nbsp;&nbsp;산&nbsp;&nbsp;&nbsp;세&nbsp;&nbsp;&nbsp;액&nbsp;&nbsp;&nbsp;계', colspan:3, width: '100%',tdAttrs: {width:'100%'},
				handler : function() {
					openSumTableSub6Window();
				}
			},
			{ xtype: 'component', html:'(26)', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:'', readOnly:true, width: '100%',tdAttrs: {width:'100%'}},
			{ xtype: 'component', html:'㉷', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:0,	name:'TAX_TOT_19_ROU', readOnly:true, width: '100%',tdAttrs: {width:'100%'}},
			{ xtype: 'component', html:'(26)', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:'', readOnly:true, width: '100%',tdAttrs: {width:'100%'}},
			{ xtype: 'component', html:'㉷', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:0,	name:'TAX_TOT_19', readOnly:true, width: '100%',tdAttrs: {width:'100%'}},

			{ xtype: 'component', html:'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' +
				'&nbsp;&nbsp;&nbsp;&nbsp;차&nbsp;&nbsp;가&nbsp;&nbsp;감&nbsp;&nbsp;납&nbsp;&nbsp;' +
				'부&nbsp;&nbsp;할&nbsp;&nbsp;세&nbsp;&nbsp;액&nbsp;&nbsp;(&nbsp;&nbsp;' +
			'환&nbsp;&nbsp;급&nbsp;&nbsp;받&nbsp;&nbsp;을&nbsp;&nbsp;세&nbsp;&nbsp;액&nbsp;&nbsp;)' +
				'&nbsp;&nbsp;(&nbsp;&nbsp;㉰ - ㉱ - ㉲ - ㉳ - ㉴ - ㉵ - ㉶ + ㉷&nbsp;&nbsp;)',
				colspan:5, /*width: 550,*/ tdAttrs: {/*style: 'border : 1px solid #ced9e7;', */align: 'left',width:'100%'}},

			{ xtype: 'component', html:'(27)', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:0,	name:'TAX_TOT_20_ROU', readOnly:true, width: '100%',tdAttrs: {width:'100%'}},
			{ xtype: 'component', html:'', width: 100,tdAttrs: {width:100}, colspan:2},
			{ xtype: 'component', html:'(27)', width: 100,tdAttrs: {width:100}},
			{ xtype: 'uniNumberfield', value:0,	name:'TAX_TOT_20', readOnly:true, width: '100%',tdAttrs: {width:'100%'}}




		],
		api: {
			load: 'atx301ukrService.selectForm' ,
			submit: 'atx301ukrService.syncMaster'
		},

		listeners : {
			uniOnChange:function( basicForm, dirty, eOpts ) {
				console.log("onDirtyChange");
				if(basicForm.isDirty()) {
					if(resetButtonFlag == 'Y'){
						UniAppManager.setToolbarButtons('save', false);
					}else{
						UniAppManager.setToolbarButtons('save', true);
					}
				} else {
					UniAppManager.setToolbarButtons('save', false);
				}

			}
		}
	});



	Unilite.Main( {
		borderItems:[{
			region: 'center',
			layout: 'border',
			items:[
				sumTable, panelResult
			]
		},
			panelSearch
		],
		id  : 'atx301ukrApp',
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons('reset',false);

			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('txtFrPubDate');

			this.setDefault();
		},
		onQueryButtonDown : function()	{
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{

				sumTable.mask('loading...');
				var param= panelSearch.getValues();

				sumTable.getForm().load({
					params: param,
					success: function(form, action) {
						UniAppManager.app.setSumTableSubData(action);
						UniAppManager.app.setSumTableSub1SumValue();
						UniAppManager.app.setSumTableSub2SumValue();
						UniAppManager.app.setSumTableSub3SumValue();
						UniAppManager.app.setSumTableSub4SumValue();
						UniAppManager.app.setSumTableSub5SumValue();
						UniAppManager.app.setSumTableSub6SumValue();
						UniAppManager.app.setSumTableSetUpSumValue();
						UniAppManager.app.setSumTableSumValue();

						SAVE_FLAG = action.result.data.SAVE_FLAG;
						// 정기신고와 수정신고내역 다른 값 표시
						var fields = sumTable.form.getFields()
						Ext.each(fields.items, function(item) {
							UniAppManager.app.setTableDiffValue(item.name, item.value);
						});

						sumTable.unmask();
						if(SAVE_FLAG == 'U'){
							UniAppManager.setToolbarButtons('delete',true);
							UniAppManager.setToolbarButtons('save',false);
						}else if(SAVE_FLAG == 'N'){
							UniAppManager.setToolbarButtons('save',true);
						}


					},
					failure: function(form, action) {
						UniAppManager.setToolbarButtons('save',true);
						sumTable.unmask();
					}
				});
				UniAppManager.setToolbarButtons('reset',true);
				panelResult.setAllFieldsReadOnly(true);

			}
		},
		onResetButtonDown: function() {
			resetButtonFlag = 'Y';
			panelSearch.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);

			sumTable.clearForm();
			sumTableSub1.clearForm();
			sumTableSub2.clearForm();
			sumTableSub3.clearForm();
			sumTableSub4.clearForm();
			sumTableSub5.clearForm();
			sumTableSub6.clearForm();
			sumTableSetUp.clearForm();
			SAVE_FLAG = '';
			this.fnInitBinding();
			UniAppManager.setToolbarButtons(['save','delete'],false);

		},
		onSaveDataButtonDown: function() {
			var param = sumTable.getValues();

			param.SAVE_FLAG = SAVE_FLAG;

			param.txtFrPubDate = UniDate.getDbDateStr(panelSearch.getValue("txtFrPubDate"));
			param.txtToPubDate = UniDate.getDbDateStr(panelSearch.getValue("txtToPubDate"));
			param.txtBillDivCode = panelSearch.getValue("txtBillDivCode");


			//sumTableSub1
			param.AMT_26 = sumTableSub1.getValue("AMT_26");
			param.TAX_26 = sumTableSub1.getValue("TAX_26");
			param.AMT_27 = sumTableSub1.getValue("AMT_27");
			param.TAX_27 = sumTableSub1.getValue("TAX_27");
			param.AMT_28 = sumTableSub1.getValue("AMT_28");
			param.AMT_29 = sumTableSub1.getValue("AMT_29");

			//sumTableSub2
			param.AMT_10_32 = sumTableSub2.getValue("AMT_10_32");
			param.TAX_10_32 = sumTableSub2.getValue("TAX_10_32");
			param.AMT_10_33 = sumTableSub2.getValue("AMT_10_33");
			param.TAX_10_33 = sumTableSub2.getValue("TAX_10_33");

			//sumTableSub3
			param.AMT_31 = sumTableSub3.getValue("AMT_31");
			param.TAX_31 = sumTableSub3.getValue("TAX_31");
			param.AMT_63 = sumTableSub3.getValue("AMT_63");
			param.TAX_63 = sumTableSub3.getValue("TAX_63");
			param.AMT_32 = sumTableSub3.getValue("AMT_32");
			param.TAX_32 = sumTableSub3.getValue("TAX_32");
			param.AMT_33 = sumTableSub3.getValue("AMT_33");
			param.TAX_33 = sumTableSub3.getValue("TAX_33");
			param.TAX_55 = sumTableSub3.getValue("TAX_55");
			param.TAX_34 = sumTableSub3.getValue("TAX_34");
			param.TAX_35 = sumTableSub3.getValue("TAX_35");
			param.TAX_14_47 = sumTableSub3.getValue("TAX_14_47");

			//sumTableSub4
			param.AMT_37 = sumTableSub4.getValue("AMT_37");
			param.TAX_37 = sumTableSub4.getValue("TAX_37");
			param.AMT_38 = sumTableSub4.getValue("AMT_38");
			param.TAX_38 = sumTableSub4.getValue("TAX_38");
			param.AMT_39 = sumTableSub4.getValue("AMT_39");
			param.TAX_39 = sumTableSub4.getValue("TAX_39");
			param.AMT_12 = sumTableSub4.getValue("AMT_12");
			param.TAX_12 = sumTableSub4.getValue("TAX_12");

			//sumTableSub5
			param.TAX_16_46 = sumTableSub5.getValue("TAX_16_46");
			param.TAX_64    = sumTableSub5.getValue("TAX_64");
			param.TAX_41    = sumTableSub5.getValue("TAX_41");
			param.TAX_16_47 = sumTableSub5.getValue("TAX_16_47");
			param.TAX_42    = sumTableSub5.getValue("TAX_42");
			param.TAX_78    = sumTableSub5.getValue("TAX_78");

			//sumTableSub6
			param.AMT_44 = sumTableSub6.getValue("AMT_44");
			param.TAX_44 = sumTableSub6.getValue("TAX_44");
			param.AMT_67 = sumTableSub6.getValue("AMT_67");
			param.TAX_67 = sumTableSub6.getValue("TAX_67");
			param.AMT_69 = sumTableSub6.getValue("AMT_69");
			param.TAX_69 = sumTableSub6.getValue("TAX_69");
			param.AMT_61 = sumTableSub6.getValue("AMT_61");
			param.TAX_61 = sumTableSub6.getValue("TAX_61");
			param.AMT_65 = sumTableSub6.getValue("AMT_65");
			param.TAX_65 = sumTableSub6.getValue("TAX_65");
			param.AMT_66 = sumTableSub6.getValue("AMT_66");
			param.TAX_66 = sumTableSub6.getValue("TAX_66");
			param.AMT_45 = sumTableSub6.getValue("AMT_45");
			param.TAX_45 = sumTableSub6.getValue("TAX_45");
			param.AMT_70 = sumTableSub6.getValue("AMT_70");
			param.TAX_70 = sumTableSub6.getValue("TAX_70");
			param.AMT_46 = sumTableSub6.getValue("AMT_46");
			param.TAX_46 = sumTableSub6.getValue("TAX_46");
			param.AMT_71 = sumTableSub6.getValue("AMT_71");
			param.TAX_71 = sumTableSub6.getValue("TAX_71");
			param.AMT_72 = sumTableSub6.getValue("AMT_72");
			param.TAX_72 = sumTableSub6.getValue("TAX_72");
			param.AMT_73 = sumTableSub6.getValue("AMT_73");
			param.TAX_73 = sumTableSub6.getValue("TAX_73");
			param.AMT_47 = sumTableSub6.getValue("AMT_47");
			param.TAX_47 = sumTableSub6.getValue("TAX_47");
			param.AMT_48 = sumTableSub6.getValue("AMT_48");
			param.TAX_48 = sumTableSub6.getValue("TAX_48");
			param.AMT_56 = sumTableSub6.getValue("AMT_56");
			param.TAX_56 = sumTableSub6.getValue("TAX_56");
			param.AMT_74 = sumTableSub6.getValue("AMT_74");
			param.TAX_74 = sumTableSub6.getValue("TAX_74");
			param.AMT_75 = sumTableSub6.getValue("AMT_75");
			param.TAX_75 = sumTableSub6.getValue("TAX_75");
			param.AMT_76 = sumTableSub6.getValue("AMT_76");
			param.TAX_76 = sumTableSub6.getValue("TAX_76");
			param.AMT_19 = sumTableSub6.getValue("AMT_19");
			param.TAX_19 = sumTableSub6.getValue("TAX_19");

			//sumTableSetUp
			param.DIVI               = Ext.getCmp('rdoSelect1').getValue().DIVI;
			param.PRE_RE_CANCEL      = Ext.getCmp('rdoSelect2').getValue().PRE_RE_CANCEL;
			param.BUSINESS_BANK_CODE = sumTableSetUp.getValue("BUSINESS_BANK_CODE");
			param.BRANCH_NAME        = sumTableSetUp.getValue("BRANCH_NAME");
			param.BANK_ACCOUNT       = sumTableSetUp.getValue("BANK_ACCOUNT");
			param.CLOSE_DATE         = UniDate.getDbDateStr(sumTableSetUp.getValue("CLOSE_DATE"));
			param.CLOSE_REASON       = sumTableSetUp.getValue("CLOSE_REASON");
			param.COMP_TYPE1         = sumTableSetUp.getValue("COMP_TYPE1");
			param.COMP_CLASS1        = sumTableSetUp.getValue("COMP_CLASS1");
			param.COMP_CODE1         = sumTableSetUp.getValue("COMP_CODE1");
			param.COMP_AMT1          = sumTableSetUp.getValue("COMP_AMT1");
			param.COMP_TYPE2         = sumTableSetUp.getValue("COMP_TYPE2");
			param.COMP_CLASS2        = sumTableSetUp.getValue("COMP_CLASS2");
			param.COMP_CODE2         = sumTableSetUp.getValue("COMP_CODE2");
			param.COMP_AMT2          = sumTableSetUp.getValue("COMP_AMT2");
			param.COMP_TYPE3         = sumTableSetUp.getValue("COMP_TYPE3");
			param.COMP_CLASS3        = sumTableSetUp.getValue("COMP_CLASS3");
			param.COMP_CODE3         = sumTableSetUp.getValue("COMP_CODE3");
			param.COMP_AMT3          = sumTableSetUp.getValue("COMP_AMT3");
			param.COMP_CLASS4        = sumTableSetUp.getValue("COMP_CLASS4");
			param.COMP_CODE4         = sumTableSetUp.getValue("COMP_CODE4");
			param.COMP_AMT4          = sumTableSetUp.getValue("COMP_AMT4");
			param.FREE_TYPE1         = sumTableSetUp.getValue("FREE_TYPE1");
			param.FREE_CLASS1        = sumTableSetUp.getValue("FREE_CLASS1");
			param.FREE_CODE1         = sumTableSetUp.getValue("FREE_CODE1");
			param.FREE_AMT1          = sumTableSetUp.getValue("FREE_AMT1");
			param.FREE_TYPE2         = sumTableSetUp.getValue("FREE_TYPE2");
			param.FREE_CLASS2        = sumTableSetUp.getValue("FREE_CLASS2");
			param.FREE_CODE2         = sumTableSetUp.getValue("FREE_CODE2");
			param.FREE_AMT2          = sumTableSetUp.getValue("FREE_AMT2");
			param.FREE_CLASS3        = sumTableSetUp.getValue("FREE_CLASS3");
			param.FREE_CODE3         = sumTableSetUp.getValue("FREE_CODE3");
			param.FREE_AMT3          = sumTableSetUp.getValue("FREE_AMT3");
			param.AMT_53             = sumTableSetUp.getValue("AMT_53");
			param.AMT_54             = sumTableSetUp.getValue("AMT_54");
			param.DECLARE_DATE       = UniDate.getDbDateStr(sumTableSetUp.getValue("DECLARE_DATE"));
			param.AMT_TOT_25         = sumTableSetUp.getValue("AMT_TOT_25");
			param.AMT_TOT_52         = sumTableSetUp.getValue("AMT_TOT_52");
			// 20210526
			param.ZERO_TAX_RECIP1  = sumTableSetUp.getValue('ZERO_TAX_RECIP1');
			param.ZERO_TAX_CLASS1  = sumTableSetUp.getValue('ZERO_TAX_CLASS1');
			param.ZERO_TAX_CODE1   = sumTableSetUp.getValue('ZERO_TAX_CODE1');
			param.ZERO_TAX_NATION1 = sumTableSetUp.getValue('ZERO_TAX_NATION1');
			param.ZERO_TAX_RECIP2  = sumTableSetUp.getValue('ZERO_TAX_RECIP2');
			param.ZERO_TAX_CLASS2  = sumTableSetUp.getValue('ZERO_TAX_CLASS2');
			param.ZERO_TAX_CODE2   = sumTableSetUp.getValue('ZERO_TAX_CODE2');
			param.ZERO_TAX_NATION2 = sumTableSetUp.getValue('ZERO_TAX_NATION2');
			param.ZERO_TAX_RECIP3  = sumTableSetUp.getValue('ZERO_TAX_RECIP3');
			param.ZERO_TAX_CLASS3  = sumTableSetUp.getValue('ZERO_TAX_CLASS3');
			param.ZERO_TAX_CODE3   = sumTableSetUp.getValue('ZERO_TAX_CODE3');
			param.ZERO_TAX_NATION3 = sumTableSetUp.getValue('ZERO_TAX_NATION3');
			param.DEGREE		   = panelSearch.getValue('DEGREE');

			sumTable.getForm().submit({
				params : param,
				success : function(form, action) {
					sumTable.getForm().wasDirty = false;
					sumTable.resetDirtyStatus();
					UniAppManager.setToolbarButtons('save', false);
					UniAppManager.updateStatus(Msg.sMB011);// 저장되었습니다
					UniAppManager.app.onQueryButtonDown();
				}
			});
		},
		onDeleteDataButtonDown: function() {
			if(confirm('현재 데이터를 삭제 합니다.\n 삭제 하시겠습니까?')) {
				sumTable.clearForm();
				sumTableSub1.clearForm();
				sumTableSub2.clearForm();
				sumTableSub3.clearForm();
				sumTableSub4.clearForm();
				sumTableSub5.clearForm();
				sumTableSub6.clearForm();
				sumTableSetUp.clearForm();
				UniAppManager.app.setAllSumTableDefaultValue();
				UniAppManager.setToolbarButtons('delete',false);
				UniAppManager.setToolbarButtons('save',true);
				SAVE_FLAG = 'D';
			}
		},
		onPrintButtonDown: function(type) {
			var param = panelSearch.getValues();
			param["type"]=type;
			var win = Ext.create('widget.ClipReport', {
				url: CPATH+'/accnt/atx301clukr.do',
				prgID: 'atx301ukr',
				extParam: param
				});
			win.center();
			win.show();

		},
		setDefault: function() {
			if(resetButtonFlag != 'Y'){
				panelSearch.setValue('txtFrPubDate',UniDate.get('startOfMonth'));
				panelSearch.setValue('txtToPubDate',UniDate.get('today'));
				panelResult.setValue('txtFrPubDate',UniDate.get('startOfMonth'));
				panelResult.setValue('txtToPubDate',UniDate.get('today'));
			}
			panelSearch.setValue('txtBillDivCode',UserInfo.divCode);
			panelResult.setValue('txtBillDivCode',UserInfo.divCode);

			panelSearch.setValue('rdoElectric','A');
			panelResult.setValue('rdoElectric','A');

			panelSearch.setValue('rdoSum','1');
			panelResult.setValue('rdoSum','1');

			UniAppManager.app.setAllSumTableDefaultValue();
		},
		setSumTableSubData:function(action){
			//sumTableSub1
			sumTableSub1.setValue('AMT_26',action.result.data.AMT_26);
			sumTableSub1.setValue('TAX_26',action.result.data.TAX_26);
			sumTableSub1.setValue('AMT_27',action.result.data.AMT_27);
			sumTableSub1.setValue('TAX_27',action.result.data.TAX_27);
			sumTableSub1.setValue('AMT_28',action.result.data.AMT_28);
			sumTableSub1.setValue('AMT_29',action.result.data.AMT_29);
			sumTableSub1.setValue('AMT_5',action.result.data.AMT_5);
			sumTableSub1.setValue('TAX_5',action.result.data.TAX_5);

			//sumTableSub2
			sumTableSub2.setValue('AMT_10_32',action.result.data.AMT_10_32);
			sumTableSub2.setValue('TAX_10_32',action.result.data.TAX_10_32);
			sumTableSub2.setValue('AMT_10_33',action.result.data.AMT_10_33);
			sumTableSub2.setValue('TAX_10_33',action.result.data.TAX_10_33);
			sumTableSub2.setValue('AMT_TOT_10_34',action.result.data.AMT_TOT_10_34);
			sumTableSub2.setValue('TAX_TOT_10_34',action.result.data.TAX_TOT_10_34);

			//sumTableSub3
			sumTableSub3.setValue('AMT_31',action.result.data.AMT_31);
			sumTableSub3.setValue('TAX_31',action.result.data.TAX_31);
			sumTableSub3.setValue('AMT_63',action.result.data.AMT_63);
			sumTableSub3.setValue('TAX_63',action.result.data.TAX_63);
			sumTableSub3.setValue('AMT_32',action.result.data.AMT_32);
			sumTableSub3.setValue('TAX_32',action.result.data.TAX_32);
			sumTableSub3.setValue('AMT_33',action.result.data.AMT_33);
			sumTableSub3.setValue('TAX_33',action.result.data.TAX_33);
			sumTableSub3.setValue('TAX_55',action.result.data.TAX_55);
			sumTableSub3.setValue('TAX_34',action.result.data.TAX_34);
			sumTableSub3.setValue('TAX_35',action.result.data.TAX_35);
			sumTableSub3.setValue('TAX_14_47',action.result.data.TAX_14_47);
			sumTableSub3.setValue('AMT_10',action.result.data.AMT_10);
			sumTableSub3.setValue('TAX_10',action.result.data.TAX_10);

			//sumTableSub4
			sumTableSub4.setValue('AMT_37',action.result.data.AMT_37);
			sumTableSub4.setValue('TAX_37',action.result.data.TAX_37);
			sumTableSub4.setValue('AMT_38',action.result.data.AMT_38);
			sumTableSub4.setValue('TAX_38',action.result.data.TAX_38);
			sumTableSub4.setValue('AMT_39',action.result.data.AMT_39);
			sumTableSub4.setValue('TAX_39',action.result.data.TAX_39);
			sumTableSub4.setValue('AMT_12',action.result.data.AMT_12);
			sumTableSub4.setValue('TAX_12',action.result.data.TAX_12);

			//sumTableSub5
			sumTableSub5.setValue('TAX_16_46',action.result.data.TAX_16_46);
			sumTableSub5.setValue('TAX_64',action.result.data.TAX_64);
			sumTableSub5.setValue('TAX_41',action.result.data.TAX_41);
			sumTableSub5.setValue('TAX_16_47',action.result.data.TAX_16_47);
			sumTableSub5.setValue('TAX_42',action.result.data.TAX_42);
			sumTableSub5.setValue('TAX_15',action.result.data.TAX_15);
			sumTableSub5.setValue('TAX_78',action.result.data.TAX_78);

			//sumTableSub6
			sumTableSub6.setValue('AMT_44',action.result.data.AMT_44);
			sumTableSub6.setValue('TAX_44',action.result.data.TAX_44);
			sumTableSub6.setValue('AMT_67',action.result.data.AMT_67);
			sumTableSub6.setValue('TAX_67',action.result.data.TAX_67);
			sumTableSub6.setValue('AMT_69',action.result.data.AMT_69);
			sumTableSub6.setValue('TAX_69',action.result.data.TAX_69);
			sumTableSub6.setValue('AMT_61',action.result.data.AMT_61);
			sumTableSub6.setValue('TAX_61',action.result.data.TAX_61);
			sumTableSub6.setValue('AMT_65',action.result.data.AMT_65);
			sumTableSub6.setValue('TAX_65',action.result.data.TAX_65);
			sumTableSub6.setValue('AMT_66',action.result.data.AMT_66);
			sumTableSub6.setValue('TAX_66',action.result.data.TAX_66);
			sumTableSub6.setValue('AMT_45',action.result.data.AMT_45);
			sumTableSub6.setValue('TAX_45',action.result.data.TAX_45);
			sumTableSub6.setValue('AMT_70',action.result.data.AMT_70);
			sumTableSub6.setValue('TAX_70',action.result.data.TAX_70);
			sumTableSub6.setValue('AMT_46',action.result.data.AMT_46);
			sumTableSub6.setValue('TAX_46',action.result.data.TAX_46);
			sumTableSub6.setValue('AMT_71',action.result.data.AMT_71);
			sumTableSub6.setValue('TAX_71',action.result.data.TAX_71);
			sumTableSub6.setValue('AMT_72',action.result.data.AMT_72);
			sumTableSub6.setValue('TAX_72',action.result.data.TAX_72);
			sumTableSub6.setValue('AMT_73',action.result.data.AMT_73);
			sumTableSub6.setValue('TAX_73',action.result.data.TAX_73);
			sumTableSub6.setValue('AMT_47',action.result.data.AMT_47);
			sumTableSub6.setValue('TAX_47',action.result.data.TAX_47);
			sumTableSub6.setValue('AMT_48',action.result.data.AMT_48);
			sumTableSub6.setValue('TAX_48',action.result.data.TAX_48);
			sumTableSub6.setValue('AMT_56',action.result.data.AMT_56);
			sumTableSub6.setValue('TAX_56',action.result.data.TAX_56);
			sumTableSub6.setValue('AMT_74',action.result.data.AMT_74);
			sumTableSub6.setValue('TAX_74',action.result.data.TAX_74);
			sumTableSub6.setValue('AMT_75',action.result.data.AMT_75);
			sumTableSub6.setValue('TAX_75',action.result.data.TAX_75);
			sumTableSub6.setValue('AMT_76',action.result.data.AMT_76);
			sumTableSub6.setValue('TAX_76',action.result.data.TAX_76);
			sumTableSub6.setValue('AMT_19',action.result.data.AMT_19);
			sumTableSub6.setValue('TAX_19',action.result.data.TAX_19);

			//sumTableSetUp
			sumTableSetUp.setValue('DIVI',action.result.data.DIVI);
			sumTableSetUp.setValue('PRE_RE_CANCEL',action.result.data.PRE_RE_CANCEL);
			sumTableSetUp.setValue('BUSINESS_BANK_CODE',action.result.data.BUSINESS_BANK_CODE);
			sumTableSetUp.setValue('BUSINESS_BANK_NAME',action.result.data.BUSINESS_BANK_NAME);
			sumTableSetUp.setValue('BRANCH_NAME',action.result.data.BRANCH_NAME);
			sumTableSetUp.setValue('BANK_ACCOUNT',action.result.data.BANK_ACCOUNT);
			sumTableSetUp.setValue('CLOSE_DATE',action.result.data.CLOSE_DATE);
			sumTableSetUp.setValue('CLOSE_REASON',action.result.data.CLOSE_REASON);
			sumTableSetUp.setValue('COMP_TYPE1',action.result.data.COMP_TYPE1);
			sumTableSetUp.setValue('COMP_CLASS1',action.result.data.COMP_CLASS1);
			sumTableSetUp.setValue('COMP_CODE1',action.result.data.COMP_CODE1);
			sumTableSetUp.setValue('COMP_AMT1',action.result.data.COMP_AMT1);
			sumTableSetUp.setValue('COMP_TYPE2',action.result.data.COMP_TYPE2);
			sumTableSetUp.setValue('COMP_CLASS2',action.result.data.COMP_CLASS2);
			sumTableSetUp.setValue('COMP_CODE2',action.result.data.COMP_CODE2);
			sumTableSetUp.setValue('COMP_AMT2',action.result.data.COMP_AMT2);
			sumTableSetUp.setValue('COMP_TYPE3',action.result.data.COMP_TYPE3);
			sumTableSetUp.setValue('COMP_CLASS3',action.result.data.COMP_CLASS3);
			sumTableSetUp.setValue('COMP_CODE3',action.result.data.COMP_CODE3);
			sumTableSetUp.setValue('COMP_AMT3',action.result.data.COMP_AMT3);
			sumTableSetUp.setValue('COMP_CLASS4',action.result.data.COMP_CLASS4);
			sumTableSetUp.setValue('COMP_CODE4',action.result.data.COMP_CODE4);
			sumTableSetUp.setValue('COMP_AMT4',action.result.data.COMP_AMT4);
			sumTableSetUp.setValue('FREE_TYPE1',action.result.data.FREE_TYPE1);
			sumTableSetUp.setValue('FREE_CLASS1',action.result.data.FREE_CLASS1);
			sumTableSetUp.setValue('FREE_CODE1',action.result.data.FREE_CODE1);
			sumTableSetUp.setValue('FREE_AMT1',action.result.data.FREE_AMT1);
			sumTableSetUp.setValue('FREE_TYPE2',action.result.data.FREE_TYPE2);
			sumTableSetUp.setValue('FREE_CLASS2',action.result.data.FREE_CLASS2);
			sumTableSetUp.setValue('FREE_CODE2',action.result.data.FREE_CODE2);
			sumTableSetUp.setValue('FREE_AMT2',action.result.data.FREE_AMT2);
			sumTableSetUp.setValue('FREE_CLASS3',action.result.data.FREE_CLASS3);
			sumTableSetUp.setValue('FREE_CODE3',action.result.data.FREE_CODE3);
			sumTableSetUp.setValue('FREE_AMT3',action.result.data.FREE_AMT3);
			sumTableSetUp.setValue('AMT_53',action.result.data.AMT_53);
			sumTableSetUp.setValue('AMT_54',action.result.data.AMT_54);
			sumTableSetUp.setValue('DECLARE_DATE',action.result.data.DECLARE_DATE);
			// 20210526 추가
			sumTableSetUp.setValue('ZERO_TAX_RECIP1'  , action.result.data.ZERO_TAX_RECIP1);
			sumTableSetUp.setValue('ZERO_TAX_CLASS1'  , action.result.data.ZERO_TAX_CLASS1);
			sumTableSetUp.setValue('ZERO_TAX_CODE1'   , action.result.data.ZERO_TAX_CODE1);
			sumTableSetUp.setValue('ZERO_TAX_NATION1' , action.result.data.ZERO_TAX_NATION1);
			sumTableSetUp.setValue('ZERO_TAX_RECIP2'  , action.result.data.ZERO_TAX_RECIP2);
			sumTableSetUp.setValue('ZERO_TAX_CLASS2'  , action.result.data.ZERO_TAX_CLASS2);
			sumTableSetUp.setValue('ZERO_TAX_CODE2'   , action.result.data.ZERO_TAX_CODE2);
			sumTableSetUp.setValue('ZERO_TAX_NATION2' , action.result.data.ZERO_TAX_NATION2);
			sumTableSetUp.setValue('ZERO_TAX_RECIP3'  , action.result.data.ZERO_TAX_RECIP3);
			sumTableSetUp.setValue('ZERO_TAX_CLASS3'  , action.result.data.ZERO_TAX_CLASS3);
			sumTableSetUp.setValue('ZERO_TAX_CODE3'   , action.result.data.ZERO_TAX_CODE3);
			sumTableSetUp.setValue('ZERO_TAX_NATION3' , action.result.data.ZERO_TAX_NATION3);

		},
		setSumTableSub1SumValue:function(){
			sumTableSub1.setValue('AMT_5',
				sumTableSub1.getValue('AMT_26')	+ sumTableSub1.getValue('AMT_27')
				+ sumTableSub1.getValue('AMT_28') + sumTableSub1.getValue('AMT_29'));

			sumTableSub1.setValue('TAX_5',
				sumTableSub1.getValue('TAX_26') + sumTableSub1.getValue('TAX_27'));
		},
		setSumTableSub2SumValue:function(){
			sumTableSub2.setValue('AMT_TOT_10_34',
				sumTableSub2.getValue('AMT_10_32') + sumTableSub2.getValue('AMT_10_33'));

			sumTableSub2.setValue('TAX_TOT_10_34',
				sumTableSub2.getValue('TAX_10_32') + sumTableSub2.getValue('TAX_10_33'));
		},
		setSumTableSub3SumValue:function(){
			sumTableSub3.setValue('AMT_10',
				sumTableSub3.getValue('AMT_31') + sumTableSub3.getValue('AMT_63')
				+ sumTableSub3.getValue('AMT_32')+ sumTableSub3.getValue('AMT_33'));

			sumTableSub3.setValue('TAX_10',
				sumTableSub3.getValue('TAX_31') + sumTableSub3.getValue('TAX_63')
				+ sumTableSub3.getValue('TAX_32') + sumTableSub3.getValue('TAX_33')
				+ sumTableSub3.getValue('TAX_55') + sumTableSub3.getValue('TAX_34')
				+ sumTableSub3.getValue('TAX_35') + sumTableSub3.getValue('TAX_14_47'));
		},
		setSumTableSub4SumValue:function(){
			sumTableSub4.setValue('AMT_12',
				sumTableSub4.getValue('AMT_37') + sumTableSub4.getValue('AMT_38')
				+ sumTableSub4.getValue('AMT_39'));

			sumTableSub4.setValue('TAX_12',
				sumTableSub4.getValue('TAX_37') + sumTableSub4.getValue('TAX_38')
				+ sumTableSub4.getValue('TAX_39'));
		},
		setSumTableSub5SumValue:function(){
			sumTableSub5.setValue('TAX_15',
				sumTableSub5.getValue('TAX_16_46') + sumTableSub5.getValue('TAX_64')
				+ sumTableSub5.getValue('TAX_41') + sumTableSub5.getValue('TAX_16_47')
				+ sumTableSub5.getValue('TAX_42') + sumTableSub5.getValue('TAX_78'));
		},
		setSumTableSub6SumValue:function(){
			sumTableSub6.setValue('AMT_19',
				sumTableSub6.getValue('AMT_44') + sumTableSub6.getValue('AMT_67')
				+ sumTableSub6.getValue('AMT_69') + sumTableSub6.getValue('AMT_61')
				+ sumTableSub6.getValue('AMT_65') + sumTableSub6.getValue('AMT_66')
				+ sumTableSub6.getValue('AMT_45') + sumTableSub6.getValue('AMT_70')
				+ sumTableSub6.getValue('AMT_46') + sumTableSub6.getValue('AMT_71')
				+ sumTableSub6.getValue('AMT_72') + sumTableSub6.getValue('AMT_73')
				+ sumTableSub6.getValue('AMT_47') + sumTableSub6.getValue('AMT_48')
				+ sumTableSub6.getValue('AMT_56') + sumTableSub6.getValue('AMT_74')
				+ sumTableSub6.getValue('AMT_75') + sumTableSub6.getValue('AMT_76'));

			sumTableSub6.setValue('TAX_19',
				(sumTableSub6.getValue('TAX_44') + sumTableSub6.getValue('TAX_67')
				+ sumTableSub6.getValue('TAX_69') + sumTableSub6.getValue('TAX_61')
				+ sumTableSub6.getValue('TAX_65') + sumTableSub6.getValue('TAX_66')
				+ sumTableSub6.getValue('TAX_45') + sumTableSub6.getValue('TAX_70')
				+ sumTableSub6.getValue('TAX_46') + sumTableSub6.getValue('TAX_71')
				+ sumTableSub6.getValue('TAX_72') + sumTableSub6.getValue('TAX_73')
				+ sumTableSub6.getValue('TAX_47') + sumTableSub6.getValue('TAX_48')
				+ sumTableSub6.getValue('TAX_56') + sumTableSub6.getValue('TAX_74')
				+ sumTableSub6.getValue('TAX_75') + sumTableSub6.getValue('TAX_76')));

		},
		setSumTableSetUpSumValue:function(){
			sumTableSetUp.setValue('AMT_TOT_25',
				sumTableSetUp.getValue('COMP_AMT1') + sumTableSetUp.getValue('COMP_AMT2')
				+ sumTableSetUp.getValue('COMP_AMT3') + sumTableSetUp.getValue('COMP_AMT4'));

			sumTableSetUp.setValue('AMT_TOT_52',
				sumTableSetUp.getValue('FREE_AMT1') + sumTableSetUp.getValue('FREE_AMT2')
				+ sumTableSetUp.getValue('FREE_AMT3'));
		},
		setSumTableSumValue:function(){

			sumTable.setValue('AMT_TOT_7',
				sumTable.getValue('AMT_1') + sumTable.getValue('AMT_57')
				+ sumTable.getValue('AMT_62') + sumTable.getValue('AMT_2')
				+ sumTable.getValue('AMT_3') + sumTable.getValue('AMT_4')
				+ sumTable.getValue('AMT_5'));

			sumTable.setValue('TAX_TOT_7',
				sumTable.getValue('TAX_1') + sumTable.getValue('TAX_57')
				+ sumTable.getValue('TAX_62') + sumTable.getValue('TAX_2')
				+ sumTable.getValue('TAX_5') + sumTable.getValue('TAX_6'));

			sumTable.setValue('AMT_10', sumTableSub3.getValue('AMT_10'));

			sumTable.setValue('TAX_10', sumTableSub3.getValue('TAX_10'));

			sumTable.setValue('AMT_TOT_11',
				sumTable.getValue('AMT_8') + sumTable.getValue('AMT_9')
				+ sumTable.getValue('AMT_TOT_10_34') + sumTable.getValue('AMT_58')
				+ sumTable.getValue('AMT_10'));

			sumTable.setValue('TAX_TOT_11',
				sumTable.getValue('TAX_8') + sumTable.getValue('TAX_9')
				+ sumTable.getValue('TAX_TOT_10_34') + sumTable.getValue('TAX_58')
				+ sumTable.getValue('TAX_10')
				- sumTable.getValue('TAX_10_1'));


			sumTable.setValue('AMT_TOT_12', sumTableSub4.getValue('AMT_12'));

			sumTable.setValue('TAX_TOT_12',	sumTableSub4.getValue('TAX_12'));


			sumTable.setValue('AMT_TOT_13', sumTable.getValue('AMT_TOT_11') - sumTable.getValue('AMT_TOT_12'));

			sumTable.setValue('TAX_TOT_13', sumTable.getValue('TAX_TOT_11') - sumTable.getValue('TAX_TOT_12'));


			sumTable.setValue('PAY_TAX', sumTable.getValue('TAX_TOT_7') - sumTable.getValue('TAX_TOT_13'));

			sumTable.setValue('TAX_15', sumTableSub5.getValue('TAX_15'));

			sumTable.setValue('TAX_TOT_16', sumTable.getValue('TAX_15') + sumTable.getValue('TAX_14'));


			sumTable.setValue('TAX_TOT_19',	sumTableSub6.getValue('TAX_19'));


			sumTable.setValue('TAX_TOT_20',
				sumTable.getValue('PAY_TAX') - sumTable.getValue('TAX_TOT_16')
				- sumTable.getValue('TAX_17') - sumTable.getValue('TAX_18')
				- sumTable.getValue('TAX_23') - sumTable.getValue('TAX_59')
				- sumTable.getValue('TAX_77')
				+ sumTable.getValue('TAX_TOT_19'));
		},

		setSumTableSub1CalcValue : function(fieldName,newValue){
			if(Ext.getCmp('rdoSum1').getValue().rdoSum == '2'){
				if(fieldName == 'AMT_26'){
					sumTableSub1.setValue('TAX_26', newValue * 0.1);
				}else if(fieldName == 'AMT_27'){
					sumTableSub1.setValue('TAX_27', newValue * 0.1);
				}
			}
		},
		setSumTableSub6CalcValue : function(fieldName,newValue){
			if(fieldName == 'AMT_44'){
				sumTableSub6.setValue('TAX_44', newValue * 0.01);
			}else if(fieldName == 'AMT_67'){
				sumTableSub6.setValue('TAX_67', newValue * 0.01);
			}else if(fieldName == 'AMT_69'){
				sumTableSub6.setValue('TAX_69', newValue * 0.005);
			}else if(fieldName == 'AMT_61'){
				//sumTableSub6.setValue('TAX_61', newValue * 0.02);
			}else if(fieldName == 'AMT_65'){
				sumTableSub6.setValue('TAX_65', newValue * 0.005);
			}else if(fieldName == 'AMT_66'){
				sumTableSub6.setValue('TAX_66', newValue * 0.005);
			}else if(fieldName == 'AMT_45'){
				sumTableSub6.setValue('TAX_45', newValue * 0.01);
			}else if(fieldName == 'AMT_70'){
				sumTableSub6.setValue('TAX_70', newValue * 0.005);
			}else if(fieldName == 'AMT_48'){
				sumTableSub6.setValue('TAX_48', newValue * 0.005);
			}else if(fieldName == 'AMT_56'){
				sumTableSub6.setValue('TAX_56', newValue * 0.01);
			}else if(fieldName == 'AMT_74'){
				sumTableSub6.setValue('TAX_74', newValue * 0.01);
			}
		},
		setSumTableCalcValue : function(fieldName,newValue){
			if(Ext.getCmp('rdoSum1').getValue().rdoSum == '2'){
				if(fieldName == 'AMT_1'){
					sumTable.setValue('TAX_1', newValue * 0.1);
				}else if(fieldName == 'AMT_57'){
					sumTable.setValue('TAX_57', newValue * 0.1);
				}else if(fieldName == 'AMT_62'){
					sumTable.setValue('TAX_62', newValue * 0.1);
				}else if(fieldName == 'AMT_2'){
					sumTable.setValue('TAX_2', newValue * 0.1);
				}
			}
			if(fieldName == 'AMT_14'){
				sumTable.setValue('TAX_14', newValue * 0.01);
			}
		},
		setAllSumTableDefaultValue: function(){
			//sumTableSub1
			sumTableSub1.setValue('AMT_26',0);
			sumTableSub1.setValue('TAX_26',0);
			sumTableSub1.setValue('AMT_27',0);
			sumTableSub1.setValue('TAX_27',0);
			sumTableSub1.setValue('AMT_28',0);
			sumTableSub1.setValue('AMT_29',0);
			sumTableSub1.setValue('AMT_5',0);
			sumTableSub1.setValue('TAX_5',0);

			//sumTableSub2
			sumTableSub2.setValue('AMT_10_32',0);
			sumTableSub2.setValue('TAX_10_32',0);
			sumTableSub2.setValue('AMT_10_33',0);
			sumTableSub2.setValue('TAX_10_33',0);
			sumTableSub2.setValue('AMT_TOT_10_34',0);
			sumTableSub2.setValue('TAX_TOT_10_34',0);

			//sumTableSub3
			sumTableSub3.setValue('AMT_31',0);
			sumTableSub3.setValue('TAX_31',0);
			sumTableSub3.setValue('AMT_63',0);
			sumTableSub3.setValue('TAX_63',0);
			sumTableSub3.setValue('AMT_32',0);
			sumTableSub3.setValue('TAX_32',0);
			sumTableSub3.setValue('AMT_33',0);
			sumTableSub3.setValue('TAX_33',0);
			sumTableSub3.setValue('TAX_55',0);
			sumTableSub3.setValue('TAX_34',0);
			sumTableSub3.setValue('TAX_35',0);
			sumTableSub3.setValue('TAX_14_47',0);
			sumTableSub3.setValue('AMT_10',0);
			sumTableSub3.setValue('TAX_10',0);

			//sumTableSub4
			sumTableSub4.setValue('AMT_37',0);
			sumTableSub4.setValue('TAX_37',0);
			sumTableSub4.setValue('AMT_38',0);
			sumTableSub4.setValue('TAX_38',0);
			sumTableSub4.setValue('AMT_39',0);
			sumTableSub4.setValue('TAX_39',0);
			sumTableSub4.setValue('AMT_12',0);
			sumTableSub4.setValue('TAX_12',0);

			//sumTableSub5
			sumTableSub5.setValue('TAX_16_46',0);
			sumTableSub5.setValue('TAX_64',0);
			sumTableSub5.setValue('TAX_41',0);
			sumTableSub5.setValue('TAX_16_47',0);
			sumTableSub5.setValue('TAX_42',0);
			sumTableSub5.setValue('TAX_15',0);
			sumTableSub5.setValue('TAX_78',0);

			//sumTableSub6
			sumTableSub6.setValue('AMT_44',0);
			sumTableSub6.setValue('TAX_44',0);
			sumTableSub6.setValue('AMT_67',0);
			sumTableSub6.setValue('TAX_67',0);
			sumTableSub6.setValue('AMT_69',0);
			sumTableSub6.setValue('TAX_69',0);
			sumTableSub6.setValue('AMT_61',0);
			sumTableSub6.setValue('TAX_61',0);
			sumTableSub6.setValue('AMT_65',0);
			sumTableSub6.setValue('TAX_65',0);
			sumTableSub6.setValue('AMT_66',0);
			sumTableSub6.setValue('TAX_66',0);
			sumTableSub6.setValue('AMT_45',0);
			sumTableSub6.setValue('TAX_45',0);
			sumTableSub6.setValue('AMT_70',0);
			sumTableSub6.setValue('TAX_70',0);
			sumTableSub6.setValue('AMT_46',0);
			sumTableSub6.setValue('TAX_46',0);
			sumTableSub6.setValue('AMT_71',0);
			sumTableSub6.setValue('TAX_71',0);
			sumTableSub6.setValue('AMT_72',0);
			sumTableSub6.setValue('TAX_72',0);
			sumTableSub6.setValue('AMT_73',0);
			sumTableSub6.setValue('TAX_73',0);
			sumTableSub6.setValue('AMT_47',0);
			sumTableSub6.setValue('TAX_47',0);
			sumTableSub6.setValue('AMT_48',0);
			sumTableSub6.setValue('TAX_48',0);
			sumTableSub6.setValue('AMT_56',0);
			sumTableSub6.setValue('TAX_56',0);
			sumTableSub6.setValue('AMT_74',0);
			sumTableSub6.setValue('TAX_74',0);
			sumTableSub6.setValue('AMT_75',0);
			sumTableSub6.setValue('TAX_75',0);
			sumTableSub6.setValue('AMT_76',0);
			sumTableSub6.setValue('TAX_76',0);
			sumTableSub6.setValue('AMT_19',0);
			sumTableSub6.setValue('TAX_19',0);

			//sumTableSetUp
			sumTableSetUp.setValue('DIVI','1');
			sumTableSetUp.setValue('PRE_RE_CANCEL','0');
			sumTableSetUp.setValue('BUSINESS_BANK_CODE','');
			sumTableSetUp.setValue('BUSINESS_BANK_NAME','');
			sumTableSetUp.setValue('BRANCH_NAME','');
			sumTableSetUp.setValue('BANK_ACCOUNT','');
			sumTableSetUp.setValue('CLOSE_DATE','');
			sumTableSetUp.setValue('CLOSE_REASON','');
			sumTableSetUp.setValue('COMP_TYPE1','');
			sumTableSetUp.setValue('COMP_CLASS1','');
			sumTableSetUp.setValue('COMP_CODE1','');
			sumTableSetUp.setValue('COMP_AMT1',0);
			sumTableSetUp.setValue('COMP_TYPE2','');
			sumTableSetUp.setValue('COMP_CLASS2','');
			sumTableSetUp.setValue('COMP_CODE2','');
			sumTableSetUp.setValue('COMP_AMT2',0);
			sumTableSetUp.setValue('COMP_TYPE3','');
			sumTableSetUp.setValue('COMP_CLASS3','');
			sumTableSetUp.setValue('COMP_CODE3','');
			sumTableSetUp.setValue('COMP_AMT3',0);
			sumTableSetUp.setValue('COMP_CLASS4','');
			sumTableSetUp.setValue('COMP_CODE4','');
			sumTableSetUp.setValue('COMP_AMT4',0);
			sumTableSetUp.setValue('AMT_TOT_25',0);
			sumTableSetUp.setValue('FREE_TYPE1','');
			sumTableSetUp.setValue('FREE_CLASS1','');
			sumTableSetUp.setValue('FREE_CODE1','');
			sumTableSetUp.setValue('FREE_AMT1',0);
			sumTableSetUp.setValue('FREE_TYPE2','');
			sumTableSetUp.setValue('FREE_CLASS2','');
			sumTableSetUp.setValue('FREE_CODE2','');
			sumTableSetUp.setValue('FREE_AMT2',0);
			sumTableSetUp.setValue('FREE_CLASS3','');
			sumTableSetUp.setValue('FREE_CODE3','');
			sumTableSetUp.setValue('FREE_AMT3',0);
			sumTableSetUp.setValue('AMT_TOT_52',0);
			sumTableSetUp.setValue('AMT_53',0);
			sumTableSetUp.setValue('AMT_54',0);
			sumTableSetUp.setValue('DECLARE_DATE','');
			// 20210526 추가
			sumTableSetUp.setValue('ZERO_TAX_RECIP1'  , '');
			sumTableSetUp.setValue('ZERO_TAX_CLASS1'  , '');
			sumTableSetUp.setValue('ZERO_TAX_CODE1'   , '');
			sumTableSetUp.setValue('ZERO_TAX_NATION1' , '');
			sumTableSetUp.setValue('ZERO_TAX_RECIP2'  , '');
			sumTableSetUp.setValue('ZERO_TAX_CLASS2'  , '');
			sumTableSetUp.setValue('ZERO_TAX_CODE2'   , '');
			sumTableSetUp.setValue('ZERO_TAX_NATION2' , '');
			sumTableSetUp.setValue('ZERO_TAX_RECIP3'  , '');
			sumTableSetUp.setValue('ZERO_TAX_CLASS3'  , '');
			sumTableSetUp.setValue('ZERO_TAX_CODE3'   , '');
			sumTableSetUp.setValue('ZERO_TAX_NATION3' , '');

			//sumTable-수정
			sumTable.setValue('AMT_1',0);
			sumTable.setValue('TAX_1',0);
			sumTable.setValue('AMT_57',0);
			sumTable.setValue('TAX_57',0);
			sumTable.setValue('AMT_62',0);
			sumTable.setValue('TAX_62',0);
			sumTable.setValue('AMT_2',0);
			sumTable.setValue('TAX_2',0);
			sumTable.setValue('AMT_3',0);

			sumTable.setValue('AMT_4',0);

			sumTable.setValue('AMT_5',0);
			sumTable.setValue('TAX_5',0);
			sumTable.setValue('TAX_6',0);
			sumTable.setValue('AMT_TOT_7',0);
			sumTable.setValue('TAX_TOT_7',0);
			sumTable.setValue('AMT_8',0);
			sumTable.setValue('TAX_8',0);
			sumTable.setValue('AMT_9',0);
			sumTable.setValue('TAX_9',0);
			sumTable.setValue('AMT_TOT_10_34',0);
			sumTable.setValue('TAX_TOT_10_34',0);
			sumTable.setValue('AMT_58',0);
			sumTable.setValue('TAX_58',0);
			sumTable.setValue('AMT_10',0);
			sumTable.setValue('TAX_10',0);
			sumTable.setValue('AMT_TOT_11',0);
			sumTable.setValue('TAX_TOT_11',0);
			sumTable.setValue('AMT_TOT_12',0);
			sumTable.setValue('TAX_TOT_12',0);
			sumTable.setValue('AMT_TOT_13',0);
			sumTable.setValue('TAX_TOT_13',0);
			sumTable.setValue('PAY_TAX',0);
			sumTable.setValue('TAX_15',0);
			sumTable.setValue('AMT_14',0);
			sumTable.setValue('TAX_14',0);
			sumTable.setValue('TAX_TOT_16',0);
			sumTable.setValue('TAX_17',0);
			sumTable.setValue('TAX_18',0);
			sumTable.setValue('TAX_23',0);
			sumTable.setValue('TAX_59',0);
			sumTable.setValue('TAX_77',0);
			sumTable.setValue('TAX_TOT_19',0);
			sumTable.setValue('TAX_TOT_20',0);

			//sumTable-정기
			sumTable.setValue('AMT_1_ROU',0);
			sumTable.setValue('TAX_1_ROU',0);
			sumTable.setValue('AMT_57_ROU',0);
			sumTable.setValue('TAX_57_ROU',0);
			sumTable.setValue('AMT_62_ROU',0);
			sumTable.setValue('TAX_62_ROU',0);
			sumTable.setValue('AMT_2_ROU',0);
			sumTable.setValue('TAX_2_ROU',0);
			sumTable.setValue('AMT_3_ROU',0);

			sumTable.setValue('AMT_4_ROU',0);

			sumTable.setValue('AMT_5_ROU',0);
			sumTable.setValue('TAX_5_ROU',0);
			sumTable.setValue('TAX_6_ROU',0);
			sumTable.setValue('AMT_TOT_7_ROU',0);
			sumTable.setValue('TAX_TOT_7_ROU',0);
			sumTable.setValue('AMT_8_ROU',0);
			sumTable.setValue('TAX_8_ROU',0);
			sumTable.setValue('AMT_9_ROU',0);
			sumTable.setValue('TAX_9_ROU',0);
			sumTable.setValue('AMT_TOT_10_34_ROU',0);
			sumTable.setValue('TAX_TOT_10_34_ROU',0);
			sumTable.setValue('AMT_58_ROU',0);
			sumTable.setValue('TAX_58_ROU',0);
			sumTable.setValue('AMT_10_ROU',0);
			sumTable.setValue('TAX_10_ROU',0);
			sumTable.setValue('AMT_TOT_11_ROU',0);
			sumTable.setValue('TAX_TOT_11_ROU',0);
			sumTable.setValue('AMT_TOT_12_ROU',0);
			sumTable.setValue('TAX_TOT_12_ROU',0);
			sumTable.setValue('AMT_TOT_13_ROU',0);
			sumTable.setValue('TAX_TOT_13_ROU',0);
			sumTable.setValue('PAY_TAX_ROU',0);
			sumTable.setValue('TAX_15_ROU',0);
			sumTable.setValue('AMT_14_ROU',0);
			sumTable.setValue('TAX_14_ROU',0);
			sumTable.setValue('TAX_TOT_16_ROU',0);
			sumTable.setValue('TAX_17_ROU',0);
			sumTable.setValue('TAX_18_ROU',0);
			sumTable.setValue('TAX_23_ROU',0);
			sumTable.setValue('TAX_59_ROU',0);
			sumTable.setValue('TAX_77_ROU',0);
			sumTable.setValue('TAX_TOT_19_ROU',0);
			sumTable.setValue('TAX_TOT_20_ROU',0);

			UniAppManager.setToolbarButtons('save',false);

			resetButtonFlag = '';
		// 정기 신고와 수정신고의 날짜가 다를 경우 글씨 표시
		},setTableDiffValue : function(fieldName,newValue){
			// main table에 있는 값 빨간색으로 표시
			if(sumTable.getField(fieldName) == null || Ext.isEmpty(fieldName) || Ext.isEmpty(newValue)) return;

			// 해당하는 클래스 삭제
			if(sumTable.getField(fieldName).inputEl.hasCls('x-change-celltext_red')){
				sumTable.getField(fieldName).inputEl.removeCls('x-change-celltext_red');
			}

			var fieldCls = '';
			if(fieldName == 'AMT_1'){
				fieldCls = (newValue != sumTable.getValue('AMT_1_ROU')) ? 'x-change-celltext_red' : '';

			}else if(fieldName == 'TAX_1'){
				fieldCls = (newValue != sumTable.getValue('TAX_1_ROU')) ? 'x-change-celltext_red' : '';

			}else if(fieldName == 'AMT_57'){
				fieldCls = (newValue != sumTable.getValue('AMT_57_ROU')) ? 'x-change-celltext_red' : '';

			}else if(fieldName == 'TAX_57'){
				fieldCls = (newValue != sumTable.getValue('TAX_57_ROU')) ? 'x-change-celltext_red' : '';

			}else if(fieldName == 'AMT_62'){
				fieldCls = (newValue != sumTable.getValue('AMT_62_ROU')) ? 'x-change-celltext_red' : '';

			}else if(fieldName == 'TAX_62'){
				fieldCls = (newValue != sumTable.getValue('TAX_62_ROU')) ? 'x-change-celltext_red' : '';

			}else if(fieldName == 'AMT_2'){
				fieldCls = (newValue != sumTable.getValue('AMT_2_ROU')) ? 'x-change-celltext_red' : '';

			}else if(fieldName == 'TAX_2'){
				fieldCls = (newValue != sumTable.getValue('TAX_2_ROU')) ? 'x-change-celltext_red' : '';

			}else if(fieldName == 'AMT_3'){
				fieldCls = (newValue != sumTable.getValue('AMT_3_ROU')) ? 'x-change-celltext_red' : '';

			}else if(fieldName == 'AMT_4'){
				fieldCls = (newValue != sumTable.getValue('AMT_4_ROU')) ? 'x-change-celltext_red' : '';

			}else if(fieldName == 'AMT_5'){
				fieldCls = (newValue != sumTable.getValue('AMT_5_ROU')) ? 'x-change-celltext_red' : '';

			}else if(fieldName == 'TAX_5'){
				fieldCls = (newValue != sumTable.getValue('TAX_5_ROU')) ? 'x-change-celltext_red' : '';

			}else if(fieldName == 'TAX_6'){
				fieldCls = (newValue != sumTable.getValue('TAX_6_ROU')) ? 'x-change-celltext_red' : '';

			}else if(fieldName == 'AMT_TOT_7'){
				fieldCls = (newValue != sumTable.getValue('AMT_TOT_7_ROU')) ? 'x-change-celltext_red' : '';

			}else if(fieldName == 'TAX_TOT_7'){
				fieldCls = (newValue != sumTable.getValue('TAX_TOT_7_ROU')) ? 'x-change-celltext_red' : '';

			}else if(fieldName == 'AMT_8'){
				fieldCls = (newValue != sumTable.getValue('AMT_8_ROU')) ? 'x-change-celltext_red' : '';

			}else if(fieldName == 'TAX_8'){
				fieldCls = (newValue != sumTable.getValue('TAX_8_ROU')) ? 'x-change-celltext_red' : '';

			}else if(fieldName == 'TAX_10_1'){
				fieldCls = (newValue != sumTable.getValue('TAX_10_1_ROU')) ? 'x-change-celltext_red' : '';

			}else if(fieldName == 'AMT_9'){
				fieldCls = (newValue != sumTable.getValue('AMT_9_ROU')) ? 'x-change-celltext_red' : '';

			}else if(fieldName == 'TAX_9'){
				fieldCls = (newValue != sumTable.getValue('TAX_9_ROU')) ? 'x-change-celltext_red' : '';

			}else if(fieldName == 'AMT_TOT_10_34'){
				fieldCls = (newValue != sumTable.getValue('AMT_TOT_10_34_ROU')) ? 'x-change-celltext_red' : '';

			}else if(fieldName == 'TAX_TOT_10_34'){
				fieldCls = (newValue != sumTable.getValue('TAX_TOT_10_34_ROU')) ? 'x-change-celltext_red' : '';

			}else if(fieldName == 'AMT_58'){
				fieldCls = (newValue != sumTable.getValue('AMT_58_ROU')) ? 'x-change-celltext_red' : '';

			}else if(fieldName == 'TAX_58'){
				fieldCls = (newValue != sumTable.getValue('TAX_58_ROU')) ? 'x-change-celltext_red' : '';

			}else if(fieldName == 'AMT_10'){
				fieldCls = (newValue != sumTable.getValue('AMT_10_ROU')) ? 'x-change-celltext_red' : '';

			}else if(fieldName == 'TAX_10'){
				fieldCls = (newValue != sumTable.getValue('TAX_10_ROU')) ? 'x-change-celltext_red' : '';

			}else if(fieldName == 'AMT_TOT_11'){
				fieldCls = (newValue != sumTable.getValue('AMT_TOT_11_ROU')) ? 'x-change-celltext_red' : '';

			}else if(fieldName == 'TAX_TOT_11'){
				fieldCls = (newValue != sumTable.getValue('TAX_TOT_11_ROU')) ? 'x-change-celltext_red' : '';

			}else if(fieldName == 'AMT_TOT_12'){
				fieldCls = (newValue != sumTable.getValue('AMT_TOT_12_ROU')) ? 'x-change-celltext_red' : '';

			}else if(fieldName == 'TAX_TOT_12'){
				fieldCls = (newValue != sumTable.getValue('TAX_TOT_12_ROU')) ? 'x-change-celltext_red' : '';

			}else if(fieldName == 'AMT_TOT_13'){
				fieldCls = (newValue != sumTable.getValue('AMT_TOT_13_ROU')) ? 'x-change-celltext_red' : '';

			}else if(fieldName == 'TAX_TOT_13'){
				fieldCls = (newValue != sumTable.getValue('TAX_TOT_13_ROU')) ? 'x-change-celltext_red' : '';

			}else if(fieldName == 'PAY_TAX'){
				fieldCls = (newValue != sumTable.getValue('PAY_TAX_ROU')) ? 'x-change-celltext_red' : '';

			}else if(fieldName == 'TAX_15'){
				fieldCls = (newValue != sumTable.getValue('TAX_15_ROU')) ? 'x-change-celltext_red' : '';

			}else if(fieldName == 'AMT_14'){
				fieldCls = (newValue != sumTable.getValue('AMT_14_ROU')) ? 'x-change-celltext_red' : '';

			}else if(fieldName == 'TAX_14'){
				fieldCls = (newValue != sumTable.getValue('TAX_14_ROU')) ? 'x-change-celltext_red' : '';

			}else if(fieldName == 'TAX_TOT_16'){
				fieldCls = (newValue != sumTable.getValue('TAX_TOT_16_ROU')) ? 'x-change-celltext_red' : '';

			}else if(fieldName == 'TAX_17'){
				fieldCls = (newValue != sumTable.getValue('TAX_17_ROU')) ? 'x-change-celltext_red' : '';

			}else if(fieldName == 'TAX_18'){
				fieldCls = (newValue != sumTable.getValue('TAX_18_ROU')) ? 'x-change-celltext_red' : '';

			}else if(fieldName == 'TAX_23'){
				fieldCls = (newValue != sumTable.getValue('TAX_23_ROU')) ? 'x-change-celltext_red' : '';

			}else if(fieldName == 'TAX_59'){
				fieldCls = (newValue != sumTable.getValue('TAX_59_ROU')) ? 'x-change-celltext_red' : '';

			}else if(fieldName == 'TAX_77'){
				fieldCls = (newValue != sumTable.getValue('TAX_77_ROU')) ? 'x-change-celltext_red' : '';

			}else if(fieldName == 'TAX_TOT_19'){
				fieldCls = (newValue != sumTable.getValue('TAX_TOT_19_ROU')) ? 'x-change-celltext_red' : '';

			}else if(fieldName == 'TAX_TOT_20'){
				fieldCls = (newValue != sumTable.getValue('TAX_TOT_20_ROU')) ? 'x-change-celltext_red' : '';

			}else if(fieldName == 'COMP_AMT1'){
				fieldCls = (newValue != sumTable.getValue('COMP_AMT1_ROU')) ? 'x-change-celltext_red' : '';

			}else if(fieldName == 'COMP_AMT2'){
				fieldCls = (newValue != sumTable.getValue('COMP_AMT2_ROU')) ? 'x-change-celltext_red' : '';

			}else if(fieldName == 'COMP_AMT3'){
				fieldCls = (newValue != sumTable.getValue('COMP_AMT3_ROU')) ? 'x-change-celltext_red' : '';

			}else if(fieldName == 'COMP_AMT4'){
				fieldCls = (newValue != sumTable.getValue('COMP_AMT4_ROU')) ? 'x-change-celltext_red' : '';
			}
			sumTable.getField(fieldName).inputEl.addCls(fieldCls);
		},

		checkForNewDetail:function() {
			return panelSearch.setAllFieldsReadOnly(true);
		}
	});
	Unilite.createValidator('validator01', {
		forms: {'formA:':sumTable,
				'formB:':sumTableSub1,
				'formC:':sumTableSub2,
				'formD:':sumTableSub3,
				'formE:':sumTableSub4,
				'formF:':sumTableSub5,
				'formG:':sumTableSub6,
				'formH:':sumTableSetUp},
		validate: function( type, fieldName, newValue, lastValidValue, record, form, field) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'lastValidValue':lastValidValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case fieldName:
					UniAppManager.app.setSumTableSub1CalcValue(fieldName,newValue);
					UniAppManager.app.setSumTableSub6CalcValue(fieldName,newValue);
					UniAppManager.app.setSumTableCalcValue(fieldName,newValue);
					UniAppManager.app.setSumTableSub1SumValue();
					UniAppManager.app.setSumTableSub2SumValue();
					UniAppManager.app.setSumTableSub3SumValue();
					UniAppManager.app.setSumTableSub4SumValue();
					UniAppManager.app.setSumTableSub5SumValue();
					UniAppManager.app.setSumTableSub6SumValue();
					UniAppManager.app.setSumTableSetUpSumValue();
					UniAppManager.app.setSumTableSumValue();

					break;
			}
			// 정기신고와 수정신고내역 다른 값 표시
			var fields = sumTable.form.getFields()
			Ext.each(fields.items, function(item) {
				UniAppManager.app.setTableDiffValue(item.name, item.value);
			});
			return rv;
		}
	});
};

</script>
