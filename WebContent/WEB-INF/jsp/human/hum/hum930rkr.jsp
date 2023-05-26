<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hum930rkr">
	<t:ExtComboStore comboType="BOR120" pgmId="hum930rkr"/>	<!-- 신고사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="H028"/>		<!-- 급여지급방식-->
	<t:ExtComboStore comboType="AU" comboCode="H031"/>		<!-- 급여지급일구분-->
	<t:ExtComboStore comboType="AU" comboCode="A074"/>		<!-- 귀속분기-->
</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>

<script type="text/javascript" >

function appMain() {
	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 2},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel	: '<t:message code="system.label.human.printselection" default="출력선택"/>',
			xtype		: 'radiogroup',
			id			: 'optPrintGb',
			labelWidth	: 90,
			items		: [{
				boxLabel	: '<t:message code="system.label.human.department" default="부서"/>/<t:message code="system.label.human.postcode" default="직위"/>', 
				name		: 'optPrintGb',
				inputValue	: '1', 
				width		: 120,
				checked		: true
			},{
				boxLabel	: '<t:message code="system.label.human.department" default="부서"/>/<t:message code="system.label.human.schshipcode1" default="학력"/>', 
				name		: 'optPrintGb',
				inputValue	: '2',
				width		: 120
			},{
				boxLabel	: '<t:message code="system.label.human.department" default="부서"/>/<t:message code="system.label.human.long" default="근속"/>', 
				name		: 'optPrintGb',
				inputValue	: '3',
				width		: 120
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
				},
				onTextSpecialKey: function(elm, e){
				}
			}
		}]
	});

	var panelResult2 = Unilite.createSearchForm('resultForm2',{
		region	: 'west',
		layout	: {type : 'uniTable', columns : 1},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel	: '<t:message code="system.label.human.basisdate" default="기준일"/>',
			xtype		: 'uniDatefield',
			name		: 'ANN_DATE',
			value		: UniDate.get('today'),
			allowBlank	: false,
			readOnly	: false,
			width		: 325
		},{
			fieldLabel	: '<t:message code="system.label.human.division" default="사업장"/>',
			name		:'DIV_CODE', 
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
					panelResult2.setValue('FR_DEPT_CODE', '');
					panelResult2.setValue('FR_DEPT_NAME', '');
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
					panelResult2.setValue('TO_DEPT_CODE', '');
					panelResult2.setValue('TO_DEPT_NAME', '');
				}
			}
		}),{
			fieldLabel: '<t:message code="system.label.human.paymethodcode" default="급여지급방식"/>',
			name:'PAY_CODE', 
			xtype: 'uniCombobox',
			width:325,
			comboType: 'AU',
			comboCode: 'H028'
			
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
			xtype		: 'uniCombobox',
			comboType	:'AU',
			comboCode	:'H011',
			width		: 325,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			text	:'<t:message code="system.label.human.print" default="출력"/>',
			xtype	: 'button',
			tdAttrs	: {'align':'center', style:'padding-left:95px'},
			width	: 235,
			handler	: function() {
				UniAppManager.app.onPrintButtonDown();
			}
		}]
	});



	Unilite.Main({
		id			: 'hum930rkrApp',
		border		: false,
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				panelResult, panelResult2
			]
		}],
		fnInitBinding : function() {
			panelResult2.setValue('DIV_CODE', UserInfo.divCode);
			UniAppManager.setToolbarButtons(['print'], false);
			UniAppManager.setToolbarButtons(['query', 'reset', 'newData', 'save', 'detail', 'delete'], false);
		},
		onPrintButtonDown: function() {
			if(!panelResult2.getInvalidMessage()) return;

			var doc_Kind	= Ext.getCmp('optPrintGb').getChecked()[0].inputValue;
			var title_Doc	= Msg.sMHT0073;
			if(doc_Kind == '1' ){
				title_Doc = Msg.sMHT0074;	//부서,직위별 인원현황 출력
			} else if(doc_Kind == '2'){
				title_Doc = Msg.sMHT0075;	//부서,학력별 인원현황 출력
			} else if(doc_Kind == '3'){
				title_Doc = Msg.sMHT0076;	//부서,근속별 인원현황 출력
			}

			//20200805 추가: clip report로 대체
			var param					= Ext.merge(panelResult.getValues(), panelResult2.getValues());
			param.PGM_ID				= 'hum930rkr';
			param.DOC_KIND				= doc_Kind;
			param.sTxtValue2_fileTitle	= title_Doc;
			var win = Ext.create('widget.ClipReport', {
				url		: CPATH+'/human/hum930clrkrPrint.do',
				prgID	: 'hum930rkr',
				extParam: param
			});
			win.center();
			win.show();

			//20200805 주석: clip report로 대체
/*			//var param  = Ext.getCmp('resultForm').getValues();		// 상단 증명서 종류
			var param		= Ext.getCmp('resultForm2').getValues();			// 하단 검색조건
			param.DOC_KIND	= doc_Kind;
			param.TITLE		= title_Doc;
			var win = Ext.create('widget.PDFPrintWindow', {
				url		: CPATH+'/hum/hum930rkrPrint.do',
				prgID	: 'hum930rkr',
				extParam: param
			});
			win.center();
			win.show();*/
		}
	});	//End of Unilite.Main( {
};
</script>