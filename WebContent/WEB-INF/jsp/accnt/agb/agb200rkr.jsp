<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="agb200rkr">
	<t:ExtComboStore comboType="BOR120" pgmId="agb200skr"/>			<!-- 사업장 -->		
</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
	.x-change-cell_light_Yellow {
	background-color: #FFFFA1;
	}
	.x-change-cell_yellow {
	background-color: #FAED7D;
	}
</style>
<script type="text/javascript">

var BsaCodeInfo = {
	gsReportGubun: '${gsReportGubun}'	//20200727 추가: 필수체크로직 / clip report 추가
};

function appMain() {
	var getStDt		= ${getStDt};
	var gsChargeCode= Ext.isEmpty(${getChargeCode}) ? ['']: ${getChargeCode};   //ChargeCode 관련 전역변수
	var fnAgb200Init= ${fnAgb200Init};


	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'center',
		layout	: {type : 'uniTable', columns : 1},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel		: '전표일',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'FR_DATE',
			endFieldName	: 'TO_DATE',
			allowBlank		: false,
			width			: 315,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
			}
		},{
			fieldLabel	: '사업장',
			name		: 'ACCNT_DIV_CODE', 
			xtype		: 'uniCombobox',
			multiSelect	: true, 
			typeAhead	: false,
			value		: UserInfo.divCode,
			comboType	:'BOR120',
			width		: 325,
			colspan		: 2,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},
		Unilite.popup('ACCNT',{
			fieldLabel		: '계정과목',
//			validateBlank	: false,
			valueFieldName	: 'ACCNT_CODE_FR',
			textFieldName	: 'ACCNT_NAME_FR',
			autoPopup		: true,
			listeners		: {
				applyExtParam:{
					scope	: this,
					fn		: function(popup){
						var param = {
							'ADD_QUERY'		: "(BOOK_CODE1='A4' OR BOOK_CODE2='A4')",
							'CHARGE_CODE'	: (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
						}
						popup.setExtParam(param);
					}
				}
			}
		}),
		Unilite.popup('ACCNT',{ 
			fieldLabel		: '~',
			valueFieldName	: 'ACCNT_CODE_TO',
			textFieldName	: 'ACCNT_NAME_TO',
			autoPopup		: true,
			listeners		: {
				scope	: this,
				fn		: function(popup){
					var param = {
						'ADD_QUERY'		: "(BOOK_CODE1='A4' OR BOOK_CODE2='A4')",
						'CHARGE_CODE'	: (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
					}
					popup.setExtParam(param);
				}
			}
		}),{
			xtype		: 'radiogroup',
			fieldLabel	: '거래합계',
			id			: 'printKind',
			items		: [{
				boxLabel	: '미출력', 
				width		: 70, 
				name		: 'SUM',
				inputValue	: '1'
			},{
				boxLabel	: '출력', 
				width		: 70,
				name		: 'SUM',
				inputValue	: '2'
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},
			Unilite.popup('CUST',{ 
				fieldLabel		: '거래처',
				valueFieldName	: 'CUST_CODE_FR',
				textFieldName	: 'CUST_NAME_FR', 
				allowBlank:true,
				autoPopup:false,
				validateBlank:false,
				listeners		: {
									onValueFieldChange:function( elm, newValue, oldValue) {
										if(!Ext.isObject(oldValue)) {
											panelResult.setValue('CUST_NAME_FR', '');
										}
									},
									onTextFieldChange:function( elm, newValue, oldValue) {										
										if(!Ext.isObject(oldValue)) {
											panelResult.setValue('CUST_CODE_FR', '');
										}
									}
				}
			}),
			Unilite.popup('CUST',{ 
				fieldLabel		: '~',
				valueFieldName	: 'CUST_CODE_TO',
				textFieldName	: 'CUST_NAME_TO', 
				allowBlank:true,
				autoPopup:false,
				validateBlank:false,
				listeners		: {
									onValueFieldChange:function( elm, newValue, oldValue) {											
										if(!Ext.isObject(oldValue)) {
											panelResult.setValue('CUST_NAME_TO', '');
										}
									},
									onTextFieldChange:function( elm, newValue, oldValue) {										
										if(!Ext.isObject(oldValue)) {
											panelResult.setValue('CUST_CODE_TO', '');
										}
									}
				}
			}),{
			xtype		: 'radiogroup',
			fieldLabel	: '금액기준',
			items		: [{
				boxLabel	: '발생', 
				width		: 70, 
				name		: 'JAN',
				inputValue	: '1'
			},{
				boxLabel	: '잔액', 
				width		: 70,
				name		: 'JAN',
				inputValue	: '2'
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '당기시작년월',
			xtype		: 'uniMonthfield',
			name		: 'START_DATE',
			allowBlank	: false
		},{
			xtype		: 'radiogroup',
			fieldLabel	: '과목명',
			items		: [{
				boxLabel	: '과목명1', 
				width		: 70, 
				name		: 'ACCOUNT_NAME',
				inputValue	: '0'
			},{
				boxLabel	: '과목명2', 
				width		: 70,
				name		: 'ACCOUNT_NAME',
				inputValue	: '1'
			},{
				boxLabel	: '과목명3', 
				width		: 70, 
				name		: 'ACCOUNT_NAME',
				inputValue	: '2' 
			}]
		},{
			xtype		: 'radiogroup',
			fieldLabel	: '과목구분',
			items		: [{
				boxLabel	: '과목',
				width		: 70, 
				name		: 'ACCOUNT_LEVEL',
				inputValue	: '1'
			},{
				boxLabel	: '세목', 
				width		: 70,
				name		: 'ACCOUNT_LEVEL',
				inputValue	: '2'
			}]
		},{
			xtype		: 'radiogroup',
			fieldLabel	: '사업자등록번호',
			items		: [{
				boxLabel	: '출력', 
				width		: 70, 
				name		: 'COMP_NUM_YN',
				inputValue	: 'A'
			},{
				boxLabel	: '미출력', 
				width		: 70,
				name		: 'COMP_NUM_YN',
				inputValue	: 'B'  
			}]
		},{
			xtype	: 'button',
			text	: '출	력',
			width	: 235,
			tdAttrs	: {'align':'center', style:'padding-left:95px'},
			handler	: function()	{
				UniAppManager.app.onPrintButtonDown();
			}
		}]
	});


	 Unilite.Main({
		id			: 'agb200skrApp',
		border		: false,
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				panelResult
			]}
		],
		fnInitBinding : function(params) {
			UniAppManager.setToolbarButtons(['detail', 'reset', 'print'],false);

			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelResult;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('FR_DATE');

			//20200727 추가
			if(!Ext.isEmpty(params && params.PGM_ID)){
				this.processParams(params);
			}else{
				panelResult.setValue('ACCNT_DIV_CODE'	, UserInfo.divCode);
				panelResult.setValue('FR_DATE'			, UniDate.get('startOfMonth'));
				panelResult.setValue('TO_DATE'			, UniDate.get('today'));
				panelResult.setValue('START_DATE'		, getStDt[0].STDT);
				panelResult.getField('SUM').setValue('1');
				panelResult.getField('JAN').setValue('1');
				panelResult.getField('ACCOUNT_NAME').setValue(UserInfo.refItem);
				panelResult.getField('ACCOUNT_LEVEL').setValue('2');
				panelResult.getField('COMP_NUM_YN').setValue('B');
			}
		},
		//20200727 추가: 링크로 넘어오는 params 받는 부분 
		processParams: function(params) {
			this.uniOpt.appParams = params;
			if(params.PGM_ID == 'agb200skr') {
				panelResult.getField('ACCOUNT_NAME').setValue('');
				panelResult.setValue('FR_DATE'			, params.FR_DATE);
				panelResult.setValue('TO_DATE'			, params.TO_DATE);
				panelResult.setValue('ACCNT_DIV_CODE'	, params.ACCNT_DIV_CODE);
				panelResult.setValue('ACCNT_CODE_FR'	, params.ACCNT_CODE_FR);
				panelResult.setValue('ACCNT_NAME_FR'	, params.ACCNT_NAME_FR);
				panelResult.setValue('ACCNT_CODE_TO'	, params.ACCNT_CODE_TO);
				panelResult.setValue('ACCNT_NAME_TO'	, params.ACCNT_NAME_TO);
				panelResult.getField('SUM').setValue(params.SUM);
				panelResult.setValue('CUST_CODE_FR'		, params.CUST_CODE_FR);
				panelResult.setValue('CUST_NAME_FR'		, params.CUST_NAME_FR);
				panelResult.setValue('CUST_CODE_TO'		, params.CUST_CODE_TO);
				panelResult.setValue('CUST_NAME_TO'		, params.CUST_NAME_TO);
				panelResult.getField('JAN').setValue(params.JAN);
				panelResult.setValue('START_DATE'		, params.START_DATE);
				panelResult.getField('ACCOUNT_NAME').setValue(params.ACCOUNT_NAME);
				panelResult.getField('ACCOUNT_LEVEL').setValue(params.ACCOUNT_LEVEL);
				panelResult.getField('COMP_NUM_YN').setValue(params.COMP_NUM_YN);
			}
		},
		onPrintButtonDown: function() {
			//20200727 추가: 필수체크로직 / clip report 추가
			if(!this.isValidSearchForm()){
				return false;
			}
			var reportGubun = BsaCodeInfo.gsReportGubun;
			if(reportGubun.toUpperCase() == 'CLIP'){
				var param			= panelResult.getValues();
				param.PGM_ID		= 'agb200rkr';
				param.MAIN_CODE		= 'A126';
				param.ACCNT_DIV_NAME= panelResult.getField('ACCNT_DIV_CODE').getRawValue();
				param.PRINT_YN		= 'Y';
				//20200716 사업장 멀티선택로직 추가
				if(!Ext.isEmpty(panelResult.getValue('ACCNT_DIV_CODE'))) {
					var items = '';
					var divCode = panelResult.getValue('ACCNT_DIV_CODE');
					Ext.each(divCode, function(item, i) {
						if(i == 0) {
							items = item;
						} else {
							items = items + ',' + item;
						}
					});
					param.ACCNT_DIV_CODE = items;
					param.item = items;
				}
				var win = Ext.create('widget.ClipReport', {
					url		: CPATH+'/accnt/agb200clrkrPrint.do',
					prgID	: 'agb200rkr',
					extParam: param
				});
				win.center();
				win.show();
			} else {
				//기존 출력 로직
				var params		= panelResult.getValues();
				var divName		= '';
				var prgId		= '';
				var outputType	= '';
	
				if(panelResult.getValue('ACCNT_DIV_CODE') == '' || panelResult.getValue('ACCNT_DIV_CODE') == null ){
					divName = Msg.sMAW002;	// 전체
				}else{
					divName = panelResult.getField('ACCNT_DIV_CODE').getRawValue();
				}
	
				if(Ext.getCmp('printKind').getChecked()[0].inputValue == '1'){
					prgId	= 'agb200rkr';	// 거래합계 미출력
					outputType = 'N';
				}else{
					prgId	= 'agb201rkr';	// 거래합계 출력
					outputType = 'Y';
				}
				var win = Ext.create('widget.PDFPrintWindow', {
					url		: CPATH+'/accnt/agb200rkrPrint.do',
					prgID	: prgId,
					extParam: {
						COMP_CODE		: UserInfo.compCode,
						FR_DATE			: params.FR_DATE,			/* 전표일 FR */
						TO_DATE			: params.TO_DATE,			/* 전표일 TO */
						ACCNT_DIV_CODE	: params.ACCNT_DIV_CODE,	/* 사업장 CODE*/
						ACCNT_DIV_NAME	: divName,					/* 사업장 NAME */
						ACCNT_CODE_FR	: params.ACCNT_CODE_FR,		/* 계정과목 FR */
						ACCNT_NAME_FR	: params.ACCNT_NAME_FR,
						ACCNT_CODE_TO	: params.ACCNT_CODE_TO,		/* 계정과목 TO */
						ACCNT_NAME_TO	: params.ACCNT_NAME_TO,
						CUST_CODE_FR	: params.CUST_CODE_FR,		/* 거래처 FR */
						CUST_NAME_FR	: params.CUST_NAME_FR,
						CUST_CODE_TO	: params.CUST_CODE_TO,		/* 거래처 TO */
						CUST_NAME_TO	: params.CUST_NAME_TO,
						START_DATE		: params.START_DATE,
						ACCOUNT_NAME	: params.ACCOUNT_NAME,		/* 과목명 */
						SUM				: params.SUM,				/* 거래합계 */
						JAN				: params.JAN,				/* 금액기준 */
						ACCOUNT_LEVEL	: params.ACCOUNT_LEVEL,		/* 과목구분*/
						SANCTION_NO		: fnAgb200Init.PT_SANCTION_NO,
						OUTPUT_TYPE		: outputType,
						COMP_NUM_YN		: params.COMP_NUM_YN		/* 사업자등록번호 출력구분 report 용*/
					}
				});
				win.center();
				win.show();
			}
		},
		fnSetStDate:function(newValue) {
			if(newValue == null){
				return false;
			}else{
				if(UniDate.getDbDateStr(newValue).substring(0, 6) < (UniDate.getDbDateStr(newValue).substring(0, 4) + UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6))){
					panelResult.setValue('START_DATE', UniDate.getDbDateStr(newValue).substring(0, 4)-1 + UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6));
				}else{
					panelResult.setValue('START_DATE', UniDate.getDbDateStr(newValue).substring(0, 4) + UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6));
				}
			}
		},
		fnSanction: function(){
			//if()
			var sSan0  = fnAgb200Init.PT_SANCTION_YN;
			var sSan1  = fnAgb200Init.PT_SANCTION_NO;
			var sSan2  = fnAgb200Init.PT_SANCTION_PO;
			var sSan3  = '';
			var sSan4  = '';
			var sSan5  = '';
			var sSan6  = '';
			var sSan7  = '';
			var sSan8  = '';
			var sSan9  = '';
			var sSan10 = '';

			if(sSan1 == 0){
				sSan1 = "0"
			}
			if(sSan1 > 6){
				sSan1 = "6"
			}

			if(sSan1 == "1"){
				sSan10 = fnAgb200Init.PT_SANCTION_NM1;
			}
			else if(sSan1 == "2"){
				sSan9  = fnAgb200Init.PT_SANCTION_NM1;
				sSan10 = fnAgb200Init.PT_SANCTION_NM2;
			}
			else if(sSan1 == "3"){
				sSan8  = fnAgb200Init.PT_SANCTION_NM1;
				sSan9  = fnAgb200Init.PT_SANCTION_NM2;
				sSan10 = fnAgb200Init.PT_SANCTION_NM3;
			}
			else if(sSan1 == "4"){
				sSan7  = fnAgb200Init.PT_SANCTION_NM1;
				sSan8  = fnAgb200Init.PT_SANCTION_NM2;
				sSan9  = fnAgb200Init.PT_SANCTION_NM3;
				sSan10 = fnAgb200Init.PT_SANCTION_NM4;
			}
			else if(sSan1 == "5"){
				sSan6  = fnAgb200Init.PT_SANCTION_NM1;
				sSan7  = fnAgb200Init.PT_SANCTION_NM2;
				sSan8  = fnAgb200Init.PT_SANCTION_NM3;
				sSan9  = fnAgb200Init.PT_SANCTION_NM4;
				sSan10 = fnAgb200Init.PT_SANCTION_NM5;
			}
			else if(sSan1 == "6" || sSan1 == "7" || sSan1 == "8"){
				sSan5  = fnAgb200Init.PT_SANCTION_NM1;
				sSan6  = fnAgb200Init.PT_SANCTION_NM2;
				sSan7  = fnAgb200Init.PT_SANCTION_NM3;
				sSan8  = fnAgb200Init.PT_SANCTION_NM4;
				sSan9  = fnAgb200Init.PT_SANCTION_NM5;
				sSan10 = fnAgb200Init.PT_SANCTION_NM6;
			}
		}
	});
};
</script>