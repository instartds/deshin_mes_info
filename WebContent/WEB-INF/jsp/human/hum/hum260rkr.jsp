<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hum260rkr">
	<t:ExtComboStore comboType="BOR120"/>		<!-- 사업장 -->
</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>

<script type="text/javascript" >

function appMain() {
	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 2
//		,tableAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/},
//			tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
		},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel	: '<t:message code="system.label.human.printselection" default="출력선택"/>',
			xtype		: 'radiogroup',
			id			: 'optPrintGb',
			labelWidth	: 90,
			items		: [{
				boxLabel	: '<t:message code="system.label.human.monthlystaffanalysis" default="월별인원현황분석표"/>', 
				name		: 'optPrint',
				inputValue	: '0',
				width		: 160,
				checked		: true
			},{
				boxLabel	: '<t:message code="system.label.human.deptlystaffanalysis" default="부서별인원현황분석표"/>',
				name		: 'optPrint',
				inputValue	: '1',
				width		: 160
			},{
				boxLabel	: '<t:message code="system.label.human.deptlystaffanalysis" default="부서별인원현황분석표"/>(<t:message code="system.label.human.continuity" default="연속"/>)',
				name		: 'optPrint',
				inputValue	: '2',
				width		: 190
			}],
			listeners: {
				change: function(radiogroup, newValue, oldValue, eOpts) {
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
			fieldLabel	: '<t:message code="system.label.human.division" default="사업장"/>',
			name		: 'DIV_CODE', 
			xtype		: 'uniCombobox',
			value		: UserInfo.divCode,
			comboType	: 'BOR120'
		},{ 
			fieldLabel		: '<t:message code="system.label.human.applyyymm" default="기준년월"/>',
			xtype			: 'uniMonthRangefield',
			startFieldName	: 'YYYYMM_FR',
			endFieldName	: 'YYYYMM_TO',
			startDate		: UniDate.get('today'),
			endDate			: UniDate.get('today'),
			tdAttrs			: {width: 380},
			allowBlank		: false,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
			}
		},
		Unilite.popup('DEPT',{
			fieldLabel		: '<t:message code="system.label.human.department" default="부서"/>',
			valueFieldName	: 'DEPT_CODE_FR',
			textFieldName	: 'DEPT_NAME_FR',
			validateBlank	: false,
			listeners: {
				onClear: function(type) {
					panelResult2.setValue('DEPT_CODE_FR', '');
					panelResult2.setValue('DEPT_NAME_FR', '');
				}
			}
		}),
		Unilite.popup('DEPT',{
			fieldLabel		: '~',
			valueFieldName	: 'DEPT_CODE_TO',
			textFieldName	: 'DEPT_NAME_TO',
			validateBlank	: false,
			listeners		: {
				onClear: function(type) {
					panelResult2.setValue('DEPT_CODE_TO', '');
					panelResult2.setValue('DEPT_NAME_TO', '');
				}
			}
		}),{
			fieldLabel	: '<t:message code="system.label.human.irregularworkinclude" default="비정규직포함"/>',
			xtype		: 'radiogroup',
			id			: 'rdoNonjobYN',
			labelWidth	: 90,
			items		: [{
				boxLabel	: '<t:message code="system.label.human.do" default="한다"/>', 
				name		: 'rdoNonjobYN',
				inputValue	: 'Y',
				width		: 80,
				checked		: true
			},{
				boxLabel	: '<t:message code="system.label.human.donot" default="안한다"/>',
				name		: 'rdoNonjobYN',
				inputValue	: 'N',
				width		: 90
			}]
		},{
			fieldLabel	: '<t:message code="system.label.human.pagenumprint" default="페이지번호출력"/>',
			xtype		: 'radiogroup',
			id			: 'rdoPageYN',
			labelWidth	: 90,
			items		: [{
				boxLabel	: '<t:message code="system.label.human.do" default="한다"/>',
				name		: 'rdoPageYN',
				inputValue	: 'Y', 
				width		: 80,
				checked		: true
			},{
				boxLabel	: '<t:message code="system.label.human.donot" default="안한다"/>',
				name		: 'rdoPageYN',
				inputValue	: 'N',
				width		: 90
			}]
		},{
			xtype	: 'button',
			text	: '<t:message code="system.label.human.print" default="출력"/>',
			width	: 235,
			tdAttrs	: {'align':'left', style:'padding-left:95px'},
			handler	: function() {
				UniAppManager.app.onPrintButtonDown();
			}
		}]
	});



	Unilite.Main({
		id			: 'hum260rkrApp',
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
			UniAppManager.setToolbarButtons(['print'], false);
			UniAppManager.setToolbarButtons(['query', 'reset', 'newData', 'save', 'detail', 'delete'], false);
		},
		onPrintButtonDown: function() {
			//20200806 필수체크로직 추가
			if(!panelResult2.getInvalidMessage()) return;

			//20200806 추가: clip report로 대체
			var doc_Kind	= Ext.getCmp('optPrintGb').getChecked()[0].inputValue;
			var title_Doc	= '';
			var divName		= '';

			if(doc_Kind == '2') {
				title_Doc = Ext.getCmp('optPrintGb').items.items[1].boxLabel;
			} else {
				title_Doc = Ext.getCmp('optPrintGb').getChecked()[0].boxLabel;
			}
			if(Ext.isEmpty(panelResult2.getValue("DIV_CODE"))) {
				divName = '전체사업장';
			} else {
				divName = panelResult2.getField("DIV_CODE").getRawValue();
			}

			var param					= Ext.merge(panelResult.getValues(), panelResult2.getValues());
			param.PGM_ID				= 'hum260rkr';
			param.DOC_KIND				= doc_Kind;
			param.sTxtValue2_fileTitle	= title_Doc;
			param.DIV_NAME				= divName;
			param.NONJOBYN              = Ext.getCmp('rdoNonjobYN').getChecked()[0].inputValue;

			var win = Ext.create('widget.ClipReport', {
				url		: CPATH+'/human/hum260clrkrPrint.do',
				prgID	: 'hum260rkr',
				extParam: param
			});
			win.center();
			win.show();

			//20200806 주석: clip report로 대체
/*			var frMonth = panelResult2.getValue('YYYYMM_FR');
			var toMonth = panelResult2.getValue('YYYYMM_TO');
			var divName = '';

			if(panelResult2.getValue("DIV_CODE") == '' || panelResult2.getValue("DIV_CODE") == null){
				divName = '전체사업장';
			} else {
				divName = panelResult2.getField("DIV_CODE").getRawValue();
			}
			frMonth = UniDate.getDbDateStr(frMonth);
			toMonth = UniDate.getDbDateStr(toMonth);

			if( frMonth > toMonth ){		// 근무기간 Check
				return false;
			}
			var doc_Kind = Ext.getCmp('optPrintGb').getValue().optPrint;
			var title_Doc = '';
			if(doc_Kind == '0' ){
				title_Doc = '<t:message code="system.label.human.monthlystaffanalysis" default="월별인원현황분석표"/>'; 
				//prgID1	= 'hum970rkr';
			}else if(doc_Kind == '1'){
				title_Doc = '<t:message code="system.label.human.deptlystaffanalysis" default="부서별인원현황분석표"/>'; 
				//prgID1	  = 'hum970rkr';
			}
			else if(doc_Kind == '2'){
				title_Doc = '<t:message code="system.label.human.deptlystaffanalysis" default="부서별인원현황분석표"/>'; 
				//prgID1	= 'hum970rkr';
			}

			var param  = Ext.getCmp('resultForm').getValues();			// 상단 증명서 종류
			var param2 = Ext.getCmp('resultForm2').getValues();			// 하단 검색조건 

			var param = {
				// 월별인원현황분석표 : 0, 부서별인원현황분석표 : 1 , 부서별인원현황분석표(연속) : 2
				DOC_KIND		: Ext.getCmp('optPrintGb').getValue().optPrint,			// bParam(0) // 증명서 종류
				DIV_CODE		: param2.DIV_CODE,										// bParam(1)
				YYYYMM_FR		: param2.YYYYMM_FR,										// bParam(2)
				YYYYMM_TO		: param2.YYYYMM_TO,										// bParam(3) 
				DEPT_CODE_FR	: param2.DEPT_CODE_FR,									// bParam(4)
				DEPT_CODE_TO	: param2.DEPT_CODE_TO,									// bParam(5)
				NONJOBYN		: Ext.getCmp('rdoNonjobYN').getChecked()[0].inputValue,	// bParam(6)
				// 레포트로 파라미터 넘기기 매개변수 (조회와 관련 없음)
				TITLE			: title_Doc,											// 제목
				//COMP_NAME		: UserInfo.divCode,										//회사명
				DIV_NAME		: divName,
				//panelResult2.getField("DIV_CODE").getRawValue();
				PAGE_YN			: Ext.getCmp('rdoPageYN').getChecked()[0].inputValue	//페이지출력여부
				SYS_DATE		: UniDate.getDbDateStr(UniDate.get('today'))
			}
			var win = Ext.create('widget.CrystalReport', {
				url		: CPATH+'/human/hum260crkr.do',
				prgID	: 'hum260crkr',
				extParam: param
			});
			win.center();
			win.show();*/
		}
	});	//End of Unilite.Main({
};
</script>