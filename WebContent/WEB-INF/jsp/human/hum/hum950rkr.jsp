<%@page language="java" contentType="text/html; charset=utf-8" pageEncoding="UTF-8"%>
<t:appConfig pgmId="hum950rkr"  >
	<t:ExtComboStore comboType="BOR120"  />			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="H005"/>	<!-- 직위 -->
	<t:ExtComboStore comboType="AU" comboCode="H006"/>	<!-- 직책 -->
	<t:ExtComboStore comboType="AU" comboCode="H008"/>	<!-- 담당업무 -->
	<t:ExtComboStore comboType="AU" comboCode="H011"/>	<!-- 고용형태 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}	
</style>
<script type="text/javascript" >

var certi_Num = ''; // 증명번호 마지막 번호

function appMain() {
	var joinRetrStore = Unilite.createStore('hum950rkrJoin_RetrStore', {
		fields	: ['text', 'value', 'search'],
		data	: [
			{'text':'<t:message code="system.label.human.incumbentstaff" default="재직자"/>'	, 'value':'J'	, search:'재직자J'},
			{'text':'<t:message code="system.label.human.retrstaff" default="퇴직자"/>'		, 'value':'R'	, search:'퇴직자R'}
		]
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 2},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			xtype		: 'radiogroup',
			fieldLabel	: '<t:message code="system.label.human.printselection" default="출력선택"/>',
			id			: 'optPrintGb',
			labelWidth	: 90,
			items		: [{
				boxLabel	: '<t:message code="system.label.human.department" default="부서"/>,<t:message code="system.label.human.postcode" default="직위"/>,<t:message code="system.label.human.joindate" default="입사일"/>', 
				width		: 150, 
				name		: 'optPrintGb',
				inputValue	: '1',
				hidden		: true		//20200806 수정: 기본 체크 1 -> 2로 변경 (1은 hidden)
			},{
				boxLabel	: '<t:message code="system.label.human.postcode" default="직위"/>,<t:message code="system.label.human.joindate" default="입사일"/>', 
				width		: 150, 
				name		: 'optPrintGb',
				inputValue	: '2',
				checked		: true		//20200806 수정: 기본 체크 1 -> 2로 변경 (1은 hidden)
			},{
				boxLabel	: '<t:message code="system.label.human.joindate" default="입사일"/>,<t:message code="system.label.human.postcode" default="직위"/>', 
				width		: 150, 
				name		: 'optPrintGb',
				inputValue	: '3'
			}],
			listeners: {
				onTextSpecialKey: function(elm, e){
					if (e.getKey() == e.ENTER) {
						panelResult2.getField('NAME').focus();  
					}
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
			comboType	: 'BOR120'
		},{
			fieldLabel	: '<t:message code="system.label.human.basisdate" default="기준일"/>',
			xtype		: 'uniDatefield',
			name		: 'ANN_DATE',
			value		: UniDate.get('today'),
			allowBlank	: false
		},
		Unilite.treePopup('DEPTTREE',{
			fieldLabel		: '<t:message code="system.label.human.department" default="부서"/>',
			valueFieldName	: 'DEPT',
			textFieldName	: 'DEPT_NAME' ,
			valuesName		: 'DEPTS' ,
			DBvalueFieldName: 'TREE_CODE',
			DBtextFieldName	: 'TREE_NAME',
			selectChildren	: true,
			textFieldWidth	: 89,
			validateBlank	: true,
			width			: 300,
			autoPopup		: true,
			useLike			: true
		}),{
			fieldLabel: '<t:message code="system.label.human.postcode" default="직위"/>',
			name:'POST_CODE',
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'H005'
		},{
			fieldLabel	: '<t:message code="system.label.human.abil" default="직책"/>',
			name		: 'ABIL_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'H006'
		},{
			fieldLabel	: '<t:message code="system.label.human.jobcode1" default="담당업무"/>',
			name		: 'JOB_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'H008'
		},{
			fieldLabel	: '<t:message code="system.label.human.paygubun" default="고용형태"/>',
			name		: 'EMP_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'H011'
		},{
			fieldLabel	: '<t:message code="system.label.human.incumbentstatus" default="재직형태"/>',
			name		: 'JOIN_RETR',
			xtype		: 'uniCombobox',
			store		: Ext.data.StoreManager.lookup('hum950rkrJoin_RetrStore')
		},
		Unilite.popup('Employee',{
			fieldLabel		: '<t:message code="system.label.human.employee" default="사원"/>',
			valueFieldName	: 'PERSON_NUMB',
			textFieldName	: 'NAME',
			validateBlank	: false,
			autoPopup		: true,
			listeners		: {
				applyextparam: function(popup){	
					popup.setExtParam({'BASE_DT': '00000000'});
				},
				onClear: function(type) {
					panelResult2.setValue('PERSON_NUMB', '');
					panelResult2.setValue('NAME', '');
				}
			}
		}),{
			xtype	: 'button',
			text	: '<t:message code="system.label.human.print" default="출력"/>',
			tdAttrs	: {'align':'left', style:'padding-left:95px'},
			width	: 235,
			handler	: function() {
				UniAppManager.app.onPrintButtonDown();
			}
		}]
	});



	Unilite.Main({
		id			: 'hum950rkrApp',
		border		: false,
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items:[
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

			//20200805 추가: clip report로 대체
			var doc_Kind	= Ext.getCmp('optPrintGb').getChecked()[0].inputValue;
			var title_Doc	= '';
			if(doc_Kind == '1' ){
				title_Doc = '부서, 직위, 입사일순';
			}else if(doc_Kind == '2'){
				title_Doc = '직위, 입사일순';
			}
			else if(doc_Kind == '3'){
				title_Doc = '입사일, 직위순';
			}

			var param					= Ext.merge(panelResult.getValues(), panelResult2.getValues());
			param.PGM_ID				= 'hum950rkr';
			param.DOC_KIND				= doc_Kind;
			param.TITLE_DOC				= title_Doc;
			param.sTxtValue2_fileTitle	= '사원명부출력';
			var win = Ext.create('widget.ClipReport', {
				url		: CPATH+'/human/hum950clrkrPrint.do',
				prgID	: 'hum950rkr',
				extParam: param
			});
			win.center();
			win.show();

			//20200805 주석: clip report로 대체
/*			var doc_Kind	= Ext.getCmp('optPrintGb').getChecked()[0].inputValue;
			var title_Doc	= '';
			var prgID1		= 'hum950rkr';

			if(doc_Kind == '1' ){
				title_Doc = '부서, 직위, 입사일순';
			}else if(doc_Kind == '2'){
				title_Doc = '직위, 입사일순';
			}
			else if(doc_Kind == '3'){
				title_Doc = '입사일,직위순';
			}
			var param	= Ext.getCmp('resultForm').getValues();			// 상단 증명서 종류
			var param2	= Ext.getCmp('resultForm2').getValues();		// 하단 검색조건

			var win = Ext.create('widget.PDFPrintWindow', {
				url		: CPATH+'/hum/hum950rkrPrint.do',
				prgID	: prgID1,
				extParam: {
					DOC_KIND	: doc_Kind,			//증명서 종류(부서,직위,입사일 : 1 , 직위,입사일 : 2, 입사일,직위 : 3)
					DIV_CODE	: param2.DIV_CODE,
					DEPT_CODE	: param2.DEPTS,		//TEST 필요
					ANN_DATE	: param2.ANN_DATE,
					POST_CODE	: param2.POST_CODE,
					ABIL_CODE	: param2.ABIL_CODE,
					JOB_CODE	: param2.JOB_CODE,
					EMP_CODE	: param2.EMP_CODE,
					JOIN_RETR	: param2.JOIN_RETR,
					PERSON_NUMB	: param2.PERSON_NUMB,
					COMP_CODE	: UserInfo.compCode,
					// 레포트로 파라미터 넘기기 매개변수 (조회와 관련 없음)
					SUB_TITLE	: title_Doc
				}
			});
			win.center();
			win.show();*/
		}
	}); //End of Unilite.Main( {
};
</script>