<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hrt510rkr"  >
	<t:ExtComboStore comboType="AU" comboCode="H053" opts= 'R;M'/>	<!-- 정산구분-->
	<t:ExtComboStore comboType="AU" comboCode="H011"/>				<!-- 고용형태 -->
	<t:ExtComboStore comboType="AU" comboCode="H024"/>				<!-- 사원구분 -->
	<t:ExtComboStore comboType="AU" comboCode="H028"/>				<!-- 급여지급방식 -->
	<t:ExtComboStore comboType="AU" comboCode="H031"/>				<!-- 지급차수 -->
	<t:ExtComboStore comboType="AU" comboCode="H032"/>				<!-- 지급구분 -->
	<t:ExtComboStore comboType="AU" comboCode="H181"/>				<!-- 사원그룹 -->
	<t:ExtComboStore comboType="BOR120"/>							<!-- 사업장 -->
</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}	
</style>


<script type="text/javascript" >

function appMain() {
	//20200730 추가: 클립리포트 추가로 리포트 출력 방식 설정(CR:크리스탈 또는 jasper CLIP:클립리포트)
	var BsaCodeInfo = {
		gsReportGubun: '${gsReportGubun}'
	};

	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		region	: 'center',
		layout	: {type : 'uniTable', columns : 1},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel	: '정산구분',
			name		: 'RETR_TYPE',
			xtype		: 'uniCombobox', 
			comboType	: 'AU',
			comboCode	: 'H053',
			allowBlank	: true,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '정산일',
			xtype		: 'uniDatefield',
			name		: 'RETR_DATE',
			value		: new Date()
		},{
			fieldLabel	: '사업장',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			comboCode	: 'BILL'
		},
		Unilite.popup('DEPT',{
			fieldLabel		: '부서',
			valueFieldName	: 'DEPT_FR',
			textFieldName	: 'DEPT_NAME',
			validateBlank	: false,
			listeners		: {
				onClear: function(type) {
					panelResult.setValue('DEPT_FR'	, '');
					panelResult.setValue('DEPT_NAME', '');
				},
				applyextparam: function(popup) {
				}
			}
		}),
		Unilite.popup('DEPT', {
			fieldLabel		: '~',
			valueFieldName	: 'DEPT_TO',
			textFieldName	: 'DEPT_NAME2',
			validateBlank	: false,
			listeners		: {
				onClear: function(type) {
					panelResult.setValue('DEPT_TO'		, '');
					panelResult.setValue('DEPT_NAME2'	, '');
				},
				applyextparam: function(popup) {
				}
			}
		}),{
			fieldLabel	: '급여지급방식',
			name		: 'PAY_CODE', 	
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'H028'
		},{
			fieldLabel	: '지급차수',
			name		: 'PAY_PROV_FLAG',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'H031'
		},{
			fieldLabel	: '고용형태',
			name		: 'PAY_GUBUN',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'H011'
		},
		Unilite.popup('Employee',{
			fieldLabel		: '사원',
			valueFieldName	: 'PERSON_NUMB',
			textFieldName	: 'NAME',
			validateBlank	: false,
			autoPopup		: true,
			listeners		: {
				onClear: function(type) {
					panelResult.setValue('PERSON_NUMB', '');
					panelResult.setValue('NAME', '');
				},
				applyextparam: function(popup) {
				}
			}
		}),{
			xtype	: 'button',
			text	: '출력',
			width	: 230,
			tdAttrs	: {'align':'center', style:'padding-left:95px'},
			handler	: function() {
				UniAppManager.app.onPrintButtonDown();
			}
		}]
	});



	Unilite.Main({
		id			: 'hrt510rkrApp',
		border		: false,
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				panelResult
			]
		}],
		fnInitBinding : function() {
			panelResult.setValue('DIV_CODE', UserInfo.divCode);
			UniAppManager.setToolbarButtons(['detail', 'reset', 'save'], false);
		},
		onResetButtonDown: function() {
			panelResult.clearForm();
			this.fnInitBinding();
		},
		onPrintButtonDown: function() {
			var param		= Ext.getCmp('resultForm').getValues();
			//20200730 추가: 클립리포트 추가로 리포트 출력 방식 설정(CR:크리스탈 또는 jasper CLIP:클립리포트)
			var reportGubun	= BsaCodeInfo.gsReportGubun
			if(reportGubun.toUpperCase() == 'CLIP'){
				param.PGM_ID				= 'hrt510rkr';
				param.MAIN_CODE				= 'H184';
				param.STXTVALUE2_FILETITLE	= '퇴직금정산내역';
				var win = Ext.create('widget.ClipReport', {
					url		: CPATH+'/human/hrt510clrkrPrint.do',
					prgID	: 'hrt510rkr',
					extParam: param
				});
				win.center();
				win.show();
			} else {
				param.TITLE	= '퇴직금정산내역';
				var win = Ext.create('widget.CrystalReport', {
					url		: CPATH+'/human/hrt510crkr.do',
					prgID	: 'hrt510crkr',
					extParam: param
				});
				win.center();
				win.show();
			}
		}
	}); //End of
};
</script>