<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hat820rkr">
		<t:ExtComboStore comboType="BOR120"  pgmId="hat820rkr"/><!-- 신고사업장 -->
		<t:ExtComboStore comboType="AU" comboCode="H028"/>		<!-- 급여지급방식-->
		<t:ExtComboStore comboType="AU" comboCode="H031"/>		<!-- 급여지급일구분-->
		<t:ExtComboStore comboType="AU" comboCode="A074"/>		<!-- 귀속분기-->
</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>

<script type="text/javascript" >

function appMain() {
	var panelResult = Unilite.createSearchForm('resultForm2',{
		region	: 'west',
		layout	: {type : 'uniTable', columns : 1},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel	: '<t:message code="system.label.human.dutyyyyymm1" default="해당년월"/>',
			id			: 'frToDate',
			xtype		: 'uniMonthfield',
			name		: 'DUTY_YYYYMM',
			value		: new Date(),
			allowBlank	: false,
			width		: 325,
			listeners	: {
				blur	: {
					fn:function() {
					}
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.human.division" default="사업장"/>',
			name		: 'DIV_CODE', 
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			multiSelect	: false, 
			typeAhead	: false,
			width		: 325
		},
		Unilite.popup('DEPT',{
			fieldLabel		: '<t:message code="system.label.human.department" default="부서"/>',
			valueFieldName	: 'FR_DEPT_CODE',
			textFieldName	: 'FR_DEPT_NAME',
			validateBlank	: false, 
			listeners		: {
				onClear: function(type) {
					panelResult.setValue('FR_DEPT_CODE', '');
					panelResult.setValue('FR_DEPT_NAME', '');
				}
			}
		}),
		Unilite.popup('DEPT',{
			fieldLabel		: '~',
			valueFieldName	: 'TO_DEPT_CODE',
			textFieldName	: 'TO_DEPT_NAME',
			validateBlank	: false, 
			listeners		: {
				onClear: function(type) {
					panelResult.setValue('TO_DEPT_CODE', '');
					panelResult.setValue('TO_DEPT_NAME', '');
				}
			}
		}),{
			fieldLabel	: '<t:message code="system.label.human.paymethodcode" default="급여지급방식"/>',
			name		: 'PAY_CODE', 
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'H028',
			width		: 325
			
		},{
			fieldLabel	: '<t:message code="system.label.human.payprovflag2" default="지급차수"/>',
			name		: 'PAY_PROV_FLAG', 
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'H031',
			width		: 325
		},{ 
			fieldLabel	: '<t:message code="system.label.human.paygubun" default="고용형태"/>',
			name		: 'PAY_GUBUN',
			id			: 'PAY_GUBUN',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'H011',
			width		: 325,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},
		Unilite.popup('Employee',{
			fieldLabel		: '<t:message code="system.label.human.employee" default="사원"/>',
			valueFieldName	: 'PERSON_NUMB',
			textFieldName	: 'NAME',
			validateBlank	: false,
			autoPopup		: true,
			id				: 'PERSON_NUMB',
			listeners		: {
				applyextparam: function(popup){	
					popup.setExtParam({'BASE_DT': '00000000'});
				},
				onClear: function(type) {
					panelResult.setValue('PERSON_NUMB'	, '');
					panelResult.setValue('NAME'			, '');
				}
			}
		}),{
			xtype	: 'button',
			text	: '<t:message code="system.label.human.print" default="출력"/>',
			width	: 235,
			tdAttrs	: {'align':'center', style:'padding-left:95px'},
			handler	: function()	{
				UniAppManager.app.onPrintButtonDown();
			}
		}]
	});



	Unilite.Main({
		id			: 'hat820rkrApp',
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
			UniAppManager.setToolbarButtons(['print'], false);
			UniAppManager.setToolbarButtons(['query', 'reset', 'newData', 'save', 'detail', 'delete'], false);
		},
		onPrintButtonDown: function() {
			if(!panelResult.getInvalidMessage()) return;

			//20200812 추가: clip report로 대체
			var param					= panelResult.getValues();
			param.PGM_ID				= 'hat820rkr';
			param.sTxtValue2_fileTitle	= Msg.sMHT0085;

			var win = Ext.create('widget.ClipReport', {
				url		: CPATH+'/human/hat820clrkrPrint.do',
				prgID	: 'hat820rkr',
				extParam: param
			});
			win.center();
			win.show();

			//20200812 주석: clip report로 대체
/*			//var param  = Ext.getCmp('resultForm').getValues();		// 상단 증명서 종류
			//sMHT0085
			var param = Ext.getCmp('resultForm2').getValues();			// 하단 검색조건
			param.TITLE = Msg.sMHT0085;
			var win = Ext.create('widget.PDFPrintWindow', {
				url		: CPATH+'/human/hat820rkrPrint.do',
				prgID	: 'hat820rkr',
				extParam: param
			});
			win.center();
			win.show();*/
		}
	}); //End of 	Unilite.Main( {
};
</script>