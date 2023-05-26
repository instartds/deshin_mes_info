<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="agb210rkr">
	<t:ExtComboStore comboType="BOR120" pgmId="agb210rkr"/>	<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B004"/>		<!-- 화폐단위-->
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

<script type="text/javascript" >

var BsaCodeInfo = {
	gsReportGubun: '${gsReportGubun}'	//20200727 추가:clip report 추가
};

function appMain() {
	var getStDt			= ${getStDt};
	var getChargeCode	= ${getChargeCode};

	var panelSearch = Unilite.createSearchForm('agb210rkrForm', {
		region		: 'center',
		disabled	: false,
		border		: false,
		flex		: 1,
		layout		: {
			type	: 'uniTable',
			columns	: 1
		},
		defaults	:{
			width		: 325,
			labelWidth	: 90
		},
		defaultType	: 'uniTextfield',
		padding		: '20 0 0 0',
		width		: 400,
		items		: [{
			fieldLabel		: '전표일',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'FR_DATE',
			endFieldName	: 'TO_DATE',
			allowBlank		: false,
			width			: 315
		},
		Unilite.popup('ACCNT',{
			fieldLabel		: '계정과목',
//			validateBlank	: false,
			valueFieldName	: 'ACCNT_CODE_FR',
			textFieldName	: 'ACCNT_NAME_FR',
			autoPopup		: true,
			listeners		: {
				onValueFieldChange: function(field, newValue){
				},
				onTextFieldChange: function(field, newValue){
				},
				applyextparam: function(popup){
					popup.setExtParam({'ADD_QUERY'	: "(BOOK_CODE1='A4' OR BOOK_CODE2='A4')"});			//WHERE절 추카 쿼리
					popup.setExtParam({'CHARGE_CODE': ''/*gsChargeCode*/});			//bParam(3)
				}
			}
		}),
		Unilite.popup('ACCNT',{ 
			fieldLabel		: '~',
			valueFieldName	: 'ACCNT_CODE_TO',
			textFieldName	: 'ACCNT_NAME_TO',
			autoPopup		: true,
			listeners		: {
				onValueFieldChange: function(field, newValue){
				},
				onTextFieldChange: function(field, newValue){
				},
				applyextparam: function(popup){
					popup.setExtParam({'ADD_QUERY'	: "(BOOK_CODE1='A4' OR BOOK_CODE2='A4')"});			//WHERE절 추카 쿼리
					popup.setExtParam({'CHARGE_CODE': ''/*gsChargeCode*/});			//bParam(3)
				}
			}
		}),
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
											panelSearch.setValue('CUST_NAME_FR', '');
										}
									},
									onTextFieldChange:function( elm, newValue, oldValue) {										
										if(!Ext.isObject(oldValue)) {
											panelSearch.setValue('CUST_CODE_FR', '');
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
											panelSearch.setValue('CUST_NAME_TO', '');
										}
									},
									onTextFieldChange:function( elm, newValue, oldValue) {										
										if(!Ext.isObject(oldValue)) {
											panelSearch.setValue('CUST_CODE_TO', '');
										}
									}
				}
			}),{
			fieldLabel	: '사업장',
			name		: 'ACCNT_DIV_CODE', 
			xtype		: 'uniCombobox',
			multiSelect	: true, 
			typeAhead	: false,
			value		: UserInfo.divCode,
			comboType	: 'BOR120',
			width		: 325
		},{
			fieldLabel	: '당기시작년월',
			xtype		: 'uniMonthfield',
			name		: 'START_DATE',
			allowBlank	: false
		},{
			fieldLabel	: '화폐단위',
			name		: 'MONEY_UNIT', 
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B004',
			displayField: 'value'
		},{
			xtype		: 'radiogroup',
			fieldLabel	: '과목명',	
			id			: 'accountNameSe',
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
			id			: 'accountLevelSe',
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
			fieldLabel	: '출력형식',
			id			: 'printKind',
			items		: [{
				boxLabel	: '세로', 
				width		: 70, 
				name		: 'OUTPUT_TYPE',
				inputValue	: 'A'
			},{
				boxLabel	: '가로', 
				width		: 70,
				name		: 'OUTPUT_TYPE',
				inputValue	: 'B'
			}]
		},{
			xtype	: 'button',
			text	: '출	력',
			width	: 235,
			tdAttrs	: {'align':'center', style:'padding-left:95px'},
			handler	: function() {
				UniAppManager.app.onPrintButtonDown();
			}
		}]
	});



	Unilite.Main({
		id		: 'agb210rkrApp',
		border	: false,
		items	: [
			panelSearch
		],
		fnInitBinding: function(params) {
			UniAppManager.setToolbarButtons('detail', false);
			UniAppManager.setToolbarButtons('reset'	, false);

			//20200727 추가
			if(!Ext.isEmpty(params && params.PGM_ID)){
				this.processParams(params);
			}else{
				panelSearch.setValue('FR_DATE'			, UniDate.get('startOfMonth'));
				panelSearch.setValue('TO_DATE'			, UniDate.get('today'));
				panelSearch.setValue('ACCNT_DIV_CODE'	, UserInfo.divCode);
				panelSearch.setValue('START_DATE'		, getStDt[0].STDT);
				panelSearch.getField('ACCOUNT_NAME').setValue(UserInfo.refItem);
				panelSearch.getField('ACCOUNT_LEVEL').setValue('2');
				panelSearch.getField('OUTPUT_TYPE').setValue('B');
			}
		},
		//20200727 추가: 링크로 넘어오는 params 받는 부분 
		processParams: function(params) {
			this.uniOpt.appParams = params;
			if(params.PGM_ID == 'agb210skr') {
				panelSearch.setValue('FR_DATE'			, params.FR_DATE);
				panelSearch.setValue('TO_DATE'			, params.TO_DATE);
				panelSearch.setValue('ACCNT_DIV_CODE'	, params.ACCNT_DIV_CODE);
				panelSearch.setValue('ACCNT_CODE_FR'	, params.ACCNT_CODE_FR);
				panelSearch.setValue('ACCNT_NAME_FR'	, params.ACCNT_NAME_FR);
				panelSearch.setValue('ACCNT_CODE_TO'	, params.ACCNT_CODE_TO);
				panelSearch.setValue('ACCNT_NAME_TO'	, params.ACCNT_NAME_TO);
				panelSearch.setValue('CUST_CODE_FR'		, params.CUST_CODE_FR);
				panelSearch.setValue('CUST_NAME_FR'		, params.CUST_NAME_FR);
				panelSearch.setValue('CUST_CODE_TO'		, params.CUST_CODE_TO);
				panelSearch.setValue('CUST_NAME_TO'		, params.CUST_NAME_TO);
				panelSearch.setValue('START_DATE'		, params.START_DATE);
				panelSearch.getField('ACCOUNT_NAME').setValue(params.ACCOUNT_NAME);
				panelSearch.getField('ACCOUNT_LEVEL').setValue(params.ACCOUNT_LEVEL);
				panelSearch.getField('OUTPUT_TYPE').setValue(params.OUTPUT_TYPE);
			}
		},
		onPrintButtonDown: function() {
			//20200727 추가: 필수체크로직 / clip report 추가
			if(!this.isValidSearchForm()){
				return false;
			}
			var reportGubun = BsaCodeInfo.gsReportGubun;
			if(reportGubun.toUpperCase() == 'CLIP'){
				var param			= panelSearch.getValues();
				param.PGM_ID		= 'agb210rkr';
				param.MAIN_CODE		= 'A126';
				param.ACCNT_DIV_NAME= panelSearch.getField('ACCNT_DIV_CODE').getRawValue();
				param.PRINT_YN		= 'Y';
				//20200716 사업장 멀티선택로직 추가
				if(!Ext.isEmpty(panelSearch.getValue('ACCNT_DIV_CODE'))) {
					var items = '';
					var divCode = panelSearch.getValue('ACCNT_DIV_CODE');
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
					url		: CPATH+'/accnt/agb210clrkrPrint.do',
					prgID	: 'agb210rkr',
					extParam: param
				});
				win.center();
				win.show();
			} else {
				//기존 출력 로직
				var param= panelSearch.getValues();
				param.ACCNT_DIV_NAME = panelSearch.getField('ACCNT_DIV_CODE').getRawValue();
				var win = Ext.create('widget.PDFPrintWindow', {
					url		: CPATH+'/accnt/agb210rkrPrint.do',
					prgID	: 'agb210rkr',
					extParam: param
				});
				win.center();
				win.show();
			}
		}
	});
};
</script>