<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="agb240rkr">
	<t:ExtComboStore comboType="BOR120"/>				<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B042"/>	<!-- 금액단위-->
	<t:ExtComboStore comboType="AU" comboCode="A093"/>	<!-- 재무제표양식차수-->
</t:appConfig>

<script type="text/javascript">

var BsaCodeInfo = {
};
var getStDt		= Ext.isEmpty(${getStDt}) ? []: ${getStDt} ;
var gsChargeCode= Ext.isEmpty(${getChargeCode}) ? ['']: ${getChargeCode};	//ChargeCode 관련 전역변수

function appMain() {
	var panelSearch = Unilite.createSearchForm('agb240rkrForm', {
		region	: 'center',
		disabled:false,
		border	: false,
		flex	: 1,
		layout	: {
			type	: 'uniTable',
			columns	: 1
		},
		defaults:{
			width		: 325,
			labelWidth	: 90
		},
		padding	: '20 0 0 0',
		width	: 400,
		items	: [{
			fieldLabel		: '전표일',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'FR_DATE',
			endFieldName	: 'TO_DATE',
			startDate		: UniDate.get('startOfMonth'),
			endDate			: UniDate.get('today'),
			allowBlank		: false
		 },{ 
			fieldLabel	: '사업장',
			name		: 'ACCNT_DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			multiSelect	: true,
			value		: UserInfo.divCode
		},
		Unilite.popup('ACCNT',{
			fieldLabel		: '계정과목',
			valueFieldName	: 'ACCOUNT_CODE_FR',
			textFieldName	: 'ACCOUNT_NAME_FR',
			autoPopup		: true,
			listeners		: {
				applyExtParam:{
					scope:this,
					fn:function(popup){
						var param = {
							'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
						}
						popup.setExtParam(param);
					}
				}
			}
		}),
		Unilite.popup('ACCNT',{
			fieldLabel		: '~',
			valueFieldName	: 'ACCOUNT_CODE_TO',
			textFieldName	: 'ACCOUNT_NAME_TO',
			autoPopup		: true,
			listeners		: {
				applyExtParam:{
					scope:this,
					fn:function(popup){
						var param = {
							'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
						}
						popup.setExtParam(param);
					}
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
			fieldLabel	: '당기시작년월',
			name		: 'ST_DATE',
			xtype		: 'uniMonthfield',
			allowBlank	: false,
			width		: 250
		},{
			fieldLabel	: '과목명',
			xtype		: 'uniRadiogroup',
			id			: 'radio1',
			items		: [{
				boxLabel: '과목명1', width: 82, name: 'ACCOUNT_NAME', inputValue: '0'
			},{
				boxLabel: '과목명2', width: 82, name: 'ACCOUNT_NAME', inputValue: '1'
			},{
				boxLabel: '과목명3', width: 82, name: 'ACCOUNT_NAME', inputValue: '2'
			}]
		},{
			fieldLabel	: '출력조건',
			xtype		: 'uniCheckboxgroup',
			items		: [{
				boxLabel	: '계정과목별 페이지 처리',
				name		: 'CHECK1',
				xtype		: 'checkbox',
				checked		: true,
				inputValue	: '1',
				boxLabelAlign:'before'
			}]
		},{
			xtype	: 'button',
			text	: '출	력',
			width	: 235,
			tdAttrs	: {
				'align'	: 'center',
				style	: 'padding-left:95px'},
			handler:function()	{
				UniAppManager.app.onPrintButtonDown();
			}
		}]
	});



	Unilite.Main({
		id		: 'agb240rkrApp',
		border	: false,
		items	: [
			panelSearch
		],
		fnInitBinding : function(params) {
			panelSearch.setValue('ACCNT_DIV_CODE',UserInfo.divCode);
			//사용자 ID에 따라 과목명 default 값 다르게 가져옴
			panelSearch.setValue('FR_DATE', UniDate.get('startOfMonth'));
			panelSearch.setValue('TO_DATE', UniDate.get('today'));
			//당기시작월 세팅
			panelSearch.setValue('ST_DATE', getStDt[0].STDT);

			UniAppManager.setToolbarButtons('reset',false);
			UniAppManager.setToolbarButtons('print',false);
			if(!Ext.isEmpty(params && params.PGM_ID)){
				this.processParams(params);
			}else{
				panelSearch.getField('ACCOUNT_NAME').setValue(UserInfo.refItem);
			}
		},
		onQueryButtonDown : function()	{
		},
		onPrintButtonDown: function() {
			if(!this.isValidSearchForm()){
				return false;
			}
			var param			= panelSearch.getValues();
			param.PGM_ID		= 'agb240rkr';
			param.MAIN_CODE		= 'A126';
			param.ACCNT_DIV_NAME= panelSearch.getField('ACCNT_DIV_CODE').getRawValue();
			param.GROUP_YN		= panelSearch.getValue('CHECK1')=="1" ? true:false;
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
				url		: CPATH+'/accnt/agb240clrkrPrint.do',
				prgID	: 'agb240rkr',
				extParam: param
			});
			win.center();
			win.show();
		},
		//링크로 넘어오는 params 받는 부분 
		processParams: function(params) {
			this.uniOpt.appParams = params;
			if(params.PGM_ID == 'agb240skr') {
				panelSearch.getField('ACCOUNT_NAME').setValue('');
				panelSearch.setValue('FR_DATE'			, params.FR_DATE);
				panelSearch.setValue('TO_DATE'			, params.TO_DATE);
				panelSearch.setValue('ACCNT_DIV_CODE'	, params.ACCNT_DIV_CODE);
				panelSearch.setValue('ACCOUNT_CODE_FR'	, params.ACCOUNT_CODE_FR);
				panelSearch.setValue('ACCOUNT_NAME_FR'	, params.ACCOUNT_NAME_FR);
				panelSearch.setValue('ACCOUNT_CODE_TO'	, params.ACCOUNT_CODE_TO);
				panelSearch.setValue('ACCOUNT_NAME_TO'	, params.ACCOUNT_NAME_TO);
				panelSearch.setValue('CUST_CODE_FR'		, params.CUST_CODE_FR);
				panelSearch.setValue('CUST_NAME_FR'		, params.CUST_NAME_FR);
				panelSearch.setValue('CUST_CODE_TO'		, params.CUST_CODE_TO);
				panelSearch.setValue('CUST_NAME_TO'		, params.CUST_NAME_TO);
				panelSearch.setValue('ST_DATE'			, params.ST_DATE);
				panelSearch.getField('ACCOUNT_NAME').setValue(params.ACCOUNT_NAME);
			}
		}
	});
};
</script>