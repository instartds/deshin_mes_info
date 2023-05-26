<%@page language="java" contentType="text/html; charset=utf-8"%>
	<t:appConfig pgmId="ass600rkr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->   
	<t:ExtComboStore comboType="AU" comboCode="A035" /> <!--상각완료여부-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
<script type="text/javascript" >
var gsChargeCode  = Ext.isEmpty(${getChargeCode}) ? ['']: ${getChargeCode};		//ChargeCode 관련 전역변수

function appMain() {   
	var panelSearch = Unilite.createSearchForm('ass600rkrForm', {
		region: 'center',
		disabled :false,
		border: false,
		flex:1,
		layout: {
			type: 'uniTable',
			columns:2
		},
		defaults:{
			width:325,
			labelWidth:90
		},
		defaultType: 'uniTextfield',
		padding:'20 0 0 0',
		width:400,
		autoScroll:true,
		items : [
		Unilite.popup('ASSET', {
			fieldLabel: '자산코드',
			valueFieldName: 'ASSET_CODE',
			textFieldName: 'ASSET_NAME',
			colspan:2,
			validateBlank:false, 
			popupWidth: 710,
			listeners: {
				onValueFieldChange: function(field, newValue){
				},
				onTextFieldChange: function(field, newValue){
				}
			}
		}),
		Unilite.popup('ASSET',{
			fieldLabel: '~',
			colspan:2,
			valueFieldName: 'ASSET_CODE2',
			textFieldName: 'ASSET_NAME2',
			popupWidth: 710,
			validateBlank:false,
			listeners: {
				onValueFieldChange: function(field, newValue){
				},
				onTextFieldChange: function(field, newValue){
				}
			}
		}),
		Unilite.popup('ACCNT', {
			fieldLabel: '계정과목',
			colspan:2,
			valueFieldName: 'ACCNT_CODE',
			textFieldName: 'ACCNT_NAME',
			validateBlank:false,
			listeners: {
				applyExtParam:{
					scope:this,
					fn:function(popup){
						var param = {
							'ADD_QUERY' : "SPEC_DIVI = 'K' AND SLIP_SW = 'Y'",
							'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
						}
						popup.setExtParam(param);
					}
				}
			}
		}),
		Unilite.popup('ACCNT',{
			fieldLabel: '~',
			colspan:2,
			valueFieldName: 'ACCNT_CODE2',
			textFieldName: 'ACCNT_NAME2',
			validateBlank: false, 
			listeners: {
				applyExtParam:{
					scope:this,
					fn:function(popup){
						var param = {
							'ADD_QUERY' : "SPEC_DIVI = 'K' AND SLIP_SW = 'Y'",
							'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
						}
						popup.setExtParam(param);
					}
				}
			}
		}),{
			fieldLabel: '사업장',
			name:'ACCNT_DIV_CODE',
			colspan:2,
			xtype: 'uniCombobox',
			multiSelect: true,
			typeAhead: false,
			value:UserInfo.divCode,
			comboType:'BOR120',
			width: 325,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel: '자산구분',
			name:'ASST_DIVI',
			colspan:2,
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'A042',
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel: '상각완료여부',
			name:'DPR_STS2',
			colspan:2,
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'A035',
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
				}
			}
		},
		Unilite.popup('AC_PROJECT', {
			fieldLabel: '프로젝트',
			colspan:2,
			valueFieldName: 'AC_PROJECT_CODE',
			textFieldName: 'AC_PROJECT_NAME',
			validateBlank:false,
			popupWidth: 710
		}),
		Unilite.popup('AC_PROJECT',{
			fieldLabel: '~',
			colspan:2,
			valueFieldName: 'AC_PROJECT_CODE2',
			textFieldName: 'AC_PROJECT_NAME2',
			validateBlank: false,
			popupWidth: 710
		}),{
			fieldLabel:'내용년수',
			colspan:1,
			xtype: 'uniNumberfield',
			name: 'DRB_YEAR_FR',
			maxLength:3
		},{
			fieldLabel:'~',
			colspan:1,
			xtype: 'uniNumberfield',
			name: 'DRB_YEAR_TO',
			maxLength:3
		},{
			fieldLabel:'취득가액',
			colspan:1,
			xtype: 'uniNumberfield',
			name: 'ACQ_AMT_I_FR'
		},{
			fieldLabel:'~',
			colspan:1,
			xtype: 'uniNumberfield',
			name: 'ACQ_AMT_I_TO'
		},{
			fieldLabel:'외화취득가액',
			colspan:1,
			xtype: 'uniNumberfield',
			name: 'FOR_ACQ_AMT_I_FR'
		},{
			fieldLabel:'~',
			colspan:1,
			xtype: 'uniNumberfield',
			name: 'FOR_ACQ_AMT_I_TO'
		},{
			fieldLabel: '취득일',
			xtype: 'uniDateRangefield',
			colspan:2,
			startFieldName: 'ACQ_DATE_FR',
			endFieldName: 'ACQ_DATE_TO',
			width: 315
		},{
			fieldLabel: '사용일',
			colspan:2,
			xtype: 'uniDateRangefield',
			startFieldName: 'USE_DATE_FR',
			endFieldName: 'USE_DATE_TO',
			width: 315
		},{
			fieldLabel: '상각년월',
			colspan:2,
			xtype: 'uniMonthRangefield',
			startFieldName: 'DPR_YYYYMM_FR',
			endFieldName: 'DPR_YYYYMM_TO',
			width: 315
		},{
			xtype: 'radiogroup',
			colspan:2,
			fieldLabel: '매각/폐기여부',
			id: 'rdoSelect',
			name: 'WASTE_SW',
			items : [{
				boxLabel: '전체',
				//name: 'WASTE_SW',
				inputValue: 'A',
				width:50
			},{
				boxLabel: '예',
				//name: 'WASTE_SW',
				inputValue: 'Y',
				width:40
			},{
				boxLabel: '아니오',
				//name: 'WASTE_SW',
				inputValue: 'N',
				width:60
			}]
		},{
			fieldLabel: '매각/폐기년월',
			colspan:2,
			xtype: 'uniMonthRangefield',
			startFieldName: 'WASTE_YYYYMM_FR',
			endFieldName: 'WASTE_YYYYMM_TO',
			width: 315
		},{
			xtype:'button',
			colspan:1,
			text:'출    력',
			width:235,
			tdAttrs:{'align':'center', style:'padding-left:95px'},
			handler:function()	{
				UniAppManager.app.onPrintButtonDown();
			}
		}]
	});
	
	Unilite.Main( {
		border: false,
		items:[
			panelSearch
		],
		id : 'ass600rkrApp',
		fnInitBinding : function(params) {
			UniAppManager.setToolbarButtons('reset',false);
			UniAppManager.setToolbarButtons('print',false);
			
			if(Ext.isEmpty(params)) {
				panelSearch.getField('WASTE_SW').setValue('A');
			}
			else {
				this.processParams(params);
			}
		},
		processParams: function(params) {
			this.uniOpt.appParams = params;
			
			panelSearch.setValue('ASSET_CODE'		, params.ASSET_CODE);
			panelSearch.setValue('ASSET_NAME'		, params.ASSET_NAME);
			panelSearch.setValue('ASSET_CODE2'		, params.ASSET_CODE2);
			panelSearch.setValue('ASSET_NAME2'		, params.ASSET_NAME2);
			panelSearch.setValue('ACCNT_CODE'		, params.ACCNT_CODE);
			panelSearch.setValue('ACCNT_NAME'		, params.ACCNT_NAME);
			panelSearch.setValue('ACCNT_CODE2'		, params.ACCNT_CODE2);
			panelSearch.setValue('ACCNT_NAME2'		, params.ACCNT_NAME2);
			panelSearch.setValue('ACCNT_DIV_CODE'	, params.DIV_CODE);
			panelSearch.setValue('ASST_DIVI'		, params.ASST_DIVI);
			panelSearch.setValue('DPR_STS2'			, params.DPR_STS2);
			panelSearch.setValue('AC_PROJECT_CODE'	, params.AC_PROJECT_CODE);
			panelSearch.setValue('AC_PROJECT_NAME'	, params.AC_PROJECT_NAME);
			panelSearch.setValue('AC_PROJECT_CODE2'	, params.AC_PROJECT_CODE2);
			panelSearch.setValue('AC_PROJECT_NAME2'	, params.AC_PROJECT_NAME2);
			panelSearch.setValue('DRB_YEAR_FR'		, params.DRB_YEAR_FR);
			panelSearch.setValue('DRB_YEAR_TO'		, params.DRB_YEAR_TO);
			panelSearch.setValue('ACQ_AMT_I_FR'		, params.ACQ_AMT_I_FR);
			panelSearch.setValue('ACQ_AMT_I_TO'		, params.ACQ_AMT_I_TO);
			panelSearch.setValue('FOR_ACQ_AMT_I_FR'	, params.FOR_ACQ_AMT_I_FR);
			panelSearch.setValue('FOR_ACQ_AMT_I_TO'	, params.FOR_ACQ_AMT_I_TO);
			panelSearch.setValue('ACQ_DATE_FR'		, params.ACQ_DATE_FR);
			panelSearch.setValue('ACQ_DATE_TO'		, params.ACQ_DATE_TO);
			panelSearch.setValue('USE_DATE_FR'		, params.USE_DATE_FR);
			panelSearch.setValue('USE_DATE_TO'		, params.USE_DATE_TO);
			panelSearch.setValue('DPR_YYYYMM_FR'	, params.DPR_YYYYMM_FR);
			panelSearch.setValue('DPR_YYYYMM_TO'	, params.DPR_YYYYMM_TO);
			//panelSearch.setValue('WASTE_SW'			, params.WASTE_SW);
			panelSearch.getField('WASTE_SW').setValue(params.WASTE_SW);
			panelSearch.setValue('WASTE_YYYYMM_FR'	, params.WASTE_YYYYMM_FR);
			panelSearch.setValue('WASTE_YYYYMM_TO'	, params.WASTE_YYYYMM_TO);
		},
		onQueryButtonDown : function() {
		},
		onDetailButtonDown:function() {
		},
		onPrintButtonDown: function() {
			var param = panelSearch.getValues();
			
			param.PGM_ID = 'ass600rkr';		//프로그램ID
			param.MAIN_CODE = 'A126';		//해당 모듈의 출력정보를 가지고 있는 공통코드
			param.sTxtValue2_fileTitle = '고정자산대장';
			
			param.ACCNT_DIV_NAME = panelSearch.getField('ACCNT_DIV_CODE').getRawValue();
			
//			var win = Ext.create('widget.PDFPrintWindow', {
//				url: CPATH+'/ass/ass600rkrPrint.do',
//				prgID: 'ass600rkr',
//				extParam: param
//			});
			
			var win = Ext.create('widget.ClipReport', {
				url: CPATH+'/accnt/ass600clrkrv.do',
				prgID: 'ass600rkr',
				extParam: param
			});
			win.center();
			win.show();
		}
	});
};

</script>