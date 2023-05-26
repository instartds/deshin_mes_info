<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<t:appConfig pgmId="s_agb160rkr_hs">
	<t:ExtComboStore comboType="BOR120"/>				<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A077"/>	<!-- 미결구분 -->
</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>

<script type="text/javascript" >

///////////////////////////////// 페이지 개발 전 확인사항 /////////////////////////////////
// 계정과목 팝업 선택시 미결항목 팝업이 유동적으로 변함(구현이 안되있어서 거래처 팝업으로 대체함.)
// 마스터그리드에서 조건에 따라서 페이지 링크가 달라짐(534Line & 595Line 확인해서 링크로 넘어간 페이지 파라미터 받을것.)

var gsChargeCode= Ext.isEmpty(${getChargeCode}) ? ['']: ${getChargeCode};   //ChargeCode 관련 전역변수
var BsaCodeInfo	= {
	gsReportGubun: '${gsReportGubun}'
};

function appMain() {
	var panelSearch = Unilite.createSearchForm('s_agb160rkr_hsForm', {
		region	: 'center',
		disabled: false,
		border	: false,
		flex	: 1,
		layout	: {
			type	: 'uniTable',
			columns	: 1
		},
		defaults: {
			width		: 325,
			labelWidth	: 90
		},
		defaultType: 'uniTextfield',
		padding	: '20 0 0 0',
		width	: 400,
		items	: [{
			xtype	: 'container',
			layout	: {type : 'uniTable'},
			items	: [{
				fieldLabel	: '발생일',
				xtype		: 'uniDatefield',
				name		: 'FR_DATE',
				value		: UniDate.get('startOfMonth'),
				width		: 197,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			},{ 
				fieldLabel	: '~',
				xtype		: 'uniDatefield',
				name		: 'TO_DATE',
				value		: UniDate.get('today'),
				allowBlank	: false,
				width		: 127,
				labelWidth	: 18,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			}]
		},
		Unilite.popup('ACCNT',{
			fieldLabel		: '계정과목',
			valueFieldName	: 'ACCNT_CODE',
			textFieldName	: 'ACCNT_NAME', 
			child			: 'ITEM',
			autoPopup		: true,
			listeners		: {
				onSelected: {
					fn: function(records, type) {
						var param = {ACCNT_CD : panelSearch.getValue('ACCNT_CODE')};
						accntCommonService.fnGetAccntInfo(param, function(provider, response) {
							var dataMap = provider;
							var opt = '1'	//opt: '1' 미결항목용		opt: '2' 계정잔액1,2용		opt: '3' 관리항목 1~6용
							UniAccnt.addMadeFields(panelSearch, dataMap,null, opt);
							panelSearch.down('#formFieldArea1').show();
							panelSearch.down('#serach_ViewPopup1').hide();
						});
					},
					scope: this
				},
				onClear: function(type) {
					panelSearch.down('#formFieldArea1').hide();
					panelSearch.down('#serach_ViewPopup1').show();
					//onClear시 removeField..
					UniAccnt.removeField(panelSearch, null);
				},
				applyExtParam:{
					scope	: this,
					fn		: function(popup){
						var param = {
							'ADD_QUERY'		: "SLIP_SW = 'Y' AND GROUP_YN = 'N' AND PEND_YN = 'Y'",
							'CHARGE_CODE'	: (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
						}
						popup.setExtParam(param);
					}
				}
			}
		}),{
			xtype	: 'container',
			itemId	: 'conArea1',
			items	: [{
				xtype	: 'container',
				itemId	: 'formFieldArea1',
				colspan	: 1,
				layout	: {
					type	: 'table', 
					columns	: 1,
					itemCls	: 'table_td_in_uniTable',
					tdAttrs	: {
						width: 350
					}
				}
			}]
		},{
			xtype	: 'container',
			itemId	: 'serach_ViewPopup1',
			colspan	: 1, 
			layout	: {
				type	: 'table', 
				columns	: 1,
				itemCls	: 'table_td_in_uniTable',
				tdAttrs	: {
					width: 350
				}
			},
			items	: [
				Unilite.popup('ACCNT_PRSN',{
				readOnly		: true,
				fieldLabel		: '미결항목',
				validateBlank	: false
			})]
		},{
			fieldLabel	: '사업장',
			name		:'ACCNT_DIV_CODE', 
			xtype		: 'uniCombobox',
			multiSelect	: true, 
			typeAhead	: false,
			value		: UserInfo.divCode,
			comboType	: 'BOR120',
			width		: 325,
			colspan		: 2,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},
		Unilite.popup('DEPT',{
			fieldLabel		: '부서',
			valueFieldName	: 'DEPT_CODE',
			textFieldName	: 'DEPT_NAME'
		}),
		Unilite.popup('DEPT',{
			fieldLabel		: '~',
			valueFieldName	: 'PEND_DEPT_CODE',
			textFieldName	: 'PEND_DEPT_NAME'
		}),{
			fieldLabel	: '미결구분',
			name		: 'PEND_YN', 
			xtype		: 'uniCombobox', 
			comboType	: 'AU',
			comboCode	: 'A077'
		},{ 
			fieldLabel		: '반제일',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'J_DATE_FR',
			endFieldName	: 'J_DATE_TO',
			width			: 325
		},{
			fieldLabel	: '출력조건',
			xtype		: 'uniCheckboxgroup',
			items		: [{
				boxLabel		: '계정별 페이지 처리',
				name			: 'CHECK',
				inputValue		: 'Y',
				uncheckedValue	: 'N',
				width			: 150
			}]
		},{
			xtype	: 'button',
			text	: '출력',
			width	: 235,
			tdAttrs	: {'align':'center', style:'padding-left:25px'},
			handler	: function() {
				UniAppManager.app.onPrintButtonDown();
			}
		}]
	});

	Unilite.Main({
		id		: 's_agb160rkr_hsApp',
		border	: false,
		items	: [
			panelSearch
		],
		fnInitBinding : function(params) {
			//20200803 추가
			if(!Ext.isEmpty(params && params.PGM_ID)){
				this.processParams(params);
				//20200803 추가: 미결항목 동적팝업 control로직 추가
				var param = {ACCNT_CD : panelSearch.getValue('ACCNT_CODE')};
				accntCommonService.fnGetAccntInfo(param, function(provider, response) {
					var dataMap = provider;
					var opt = '1'	//opt: '1' 미결항목용		opt: '2' 계정잔액1,2용		opt: '3' 관리항목 1~6용
					UniAccnt.addMadeFields(panelSearch, dataMap, null, opt);
					if(!Ext.isEmpty(params.PEND_CODE)){
						panelSearch.setValue('PEND_CODE', params.PEND_CODE);
						panelSearch.setValue('PEND_NAME', params.PEND_NAME);

						panelSearch.down('#formFieldArea1').show();
						panelSearch.down('#serach_ViewPopup1').hide();
					}
				})
			}else{
				panelSearch.setValue('ACCNT_DIV_CODE', UserInfo.divCode);
			}
			UniAppManager.setToolbarButtons('detail', false);
			UniAppManager.setToolbarButtons('reset'	, false);
			UniAppManager.setToolbarButtons('save'	, false);
		},
		//20200803 추가: 링크로 넘어오는 params 받는 부분 
		processParams: function(params) {
			this.uniOpt.appParams = params;
			if(params.PGM_ID == 's_agb160skr_hs') {
				panelSearch.setValue('FR_DATE'			, params.FR_DATE);
				panelSearch.setValue('TO_DATE'			, params.TO_DATE);
				panelSearch.setValue('ACCNT_DIV_CODE'	, params.ACCNT_DIV_CODE);
				panelSearch.setValue('ACCNT_CODE'		, params.ACCNT_CODE);
				panelSearch.setValue('ACCNT_NAME'		, params.ACCNT_NAME);
				panelSearch.setValue('PEND_YN'			, params.PEND_YN);
				panelSearch.setValue('J_DATE_FR'		, params.J_DATE_FR);
				panelSearch.setValue('J_DATE_TO'		, params.J_DATE_TO);
				panelSearch.setValue('DEPT_CODE'		, params.DEPT_CODE);
				panelSearch.setValue('DEPT_NAME'		, params.DEPT_NAME);
				panelSearch.setValue('PEND_DEPT_CODE'	, params.PEND_DEPT_CODE);
				panelSearch.setValue('PEND_DEPT_NAME'	, params.PEND_DEPT_NAME);
				panelSearch.getField('CHECK').setValue('N');
			}
		},
		onPrintButtonDown: function() {
			//20200803 추가: clip report 추가
			if(!this.isValidSearchForm()){
				return false;
			}
			
			var param			= panelSearch.getValues();
			param.PGM_ID		= 's_agb160rkr_hs';
			param.MAIN_CODE		= 'A126';
			param.ACCNT_DIV_NAME= panelSearch.getField('ACCNT_DIV_CODE').getRawValue();
			//20200804 추가: 사업장 선택없을 때, 출력 시 "전체사업장" 출력하도록 수정
			if(Ext.isEmpty(param.ACCNT_DIV_NAME)) {
				param.ACCNT_DIV_NAME = '전체사업장';
			}
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
				url			: CPATH+'/z_hs/s_agb160clrkrPrint.do',
				prgID		: 's_agb160rkr_hs',
				extParam	: param,
				submitType	: 'POST'
			});
			win.center();
			win.show();
		}
	});
};
</script>