<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hpb400rkr">
	<t:ExtComboStore comboType="BOR120"/>					<!-- 사업장 -->
	<t:ExtComboStore comboType="BOR120" comboCode="BILL"/>	<!-- 신고사업장 -->
</t:appConfig>

<script type="text/javascript" >

var gsUserDept= '${deptData}';

function appMain() {
	var gsDED_TYPE;
	var TypeStore = Unilite.createStore('TypeStore', {
		fields	: ['text', 'value'],
		data	: [
			{'text':'거주자사업소득'		, 'value':'1'},
			{'text':'거주자기타소득'		, 'value':'2'},
			{'text':'비거주자사업기타소득'	, 'value':'3'},
			{'text':'이자, 배당소득'		, 'value':'4'}
		]
	});


	/** 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchForm('agb100rkrForm', {
		region	: 'center',
		disabled:false,
		border	: false,
		flex	: 1,
		layout	: {
			type	: 'uniTable',
			columns	: 1
		},
		defaults:{
			labelWidth: 90
		},
		defaultType: 'uniTextfield',
		padding	: '20 0 0 0',
		width	: 400,
		items	: [{
			fieldLabel	: '출력선택',
			xtype		: 'radiogroup',
			id			: 'radio1',
			items		: [{
				boxLabel: '발행자보고용'		, width: 100	, name: 'REPORT_TYPE', inputValue: '0', checked: true
			},{
				boxLabel: '소득자용'		, width: 75		, name: 'REPORT_TYPE', inputValue: '1'
			},{
				boxLabel: '발행자보관용'		, width: 100	, name: 'REPORT_TYPE', inputValue: '2'
			},{
				boxLabel: '지급일자별 집계표'	, width: 120	, name: 'REPORT_TYPE', inputValue: '3'
			}]
		},{
			fieldLabel	: '신고사업장',
			name		: 'DIV_CODE', 
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			comboCode	: 'BILL',
			allowBlank	: false
		},{
			fieldLabel	: '신고서종류',
			name		: 'MEDIUM_TYPE', 
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: '',
			store		: TypeStore,
			value		: '1',
			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					switch (newValue){
						case "1":
							gsDED_TYPE ="1";
						break;
						case "2":
							gsDED_TYPE ="2";
						break;
						case "3":
							gsDED_TYPE ="1,2";
						break;
						case "4":
							gsDED_TYPE ="10,20";
						break;
					}
					panelSearch.setValue('DED_TYPE', gsDED_TYPE);
				}
			}
		},
		Unilite.popup('DEPT',{
			fieldLabel		: '부서',
			valueFieldName	: 'DEPT_CODE_FR',
			textFieldName	: 'DEPT_NAME_FR',
			itemId			: 'DEPT_CODE_FR',
			autoPopup		: true
		}),
		Unilite.popup('DEPT',{
			fieldLabel		: '~',
			itemId			: 'DEPT_CODE_TO',
			valueFieldName	: 'DEPT_CODE_TO',
			textFieldName	: 'DEPT_NAME_TO',
			autoPopup		: true
		}),{
			fieldLabel		: '지급년월',
			xtype			: 'uniMonthRangefield',
			startFieldName	: 'SUPP_DATE_FR',
			endFieldName	: 'SUPP_DATE_TO',
			startDate		: UniDate.get('today'),
			endDate			: UniDate.get('today'),
			allowBlank		: false
		},{
			fieldLabel	: '지급일자',
			id			: 'SUPP_DATE',
			xtype		: 'uniDatefield',
			name		: 'SUPP_DATE'
		},{
			fieldLabel		: '귀속년월',
			xtype			: 'uniMonthRangefield',
			startFieldName	: 'PAY_YYYYMM_FR',
			endFieldName	: 'PAY_YYYYMM_TO'
		},{
			fieldLabel	: '제출년월일',
			id			: 'RECE_DATE',
			xtype		: 'uniDatefield',
			name		: 'RECE_DATE',
			allowBlank	: false
		},
		Unilite.popup('EARNER',{
			fieldLabel		: '소득자',
			validateBlank	: false,
			autoPopup		: false,
			valueFieldName	: 'PERSON_NUMB',
			textFieldName	: 'NAME', 
			listeners		: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('PERSON_NUMB'	, panelSearch.getValue('PERSON_NUMB'));
						panelSearch.setValue('NAME'			, panelSearch.getValue('NAME'));
					},
					scope: this
				},
				onClear: function(type) {
					panelSearch.setValue('PERSON_NUMB'	, '');
					panelSearch.setValue('NAME'			, '');
				},
				applyextparam: function(popup){
					popup.setExtParam({'DED_TYPE': panelSearch.getValue('DED_TYPE')});		//소득자타입(1사업,2기타,10이자,20배당)
					popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});		//신고사업장
				}
			}
		}),{
			xtype	: 'button',
			text	: '출력',
			width	: 230,
			margin	: '0 0 0 95',
			handler	: function() {
				UniAppManager.app.onPrintButtonDown();
			}
		},{
			fieldLabel	: 'DED_TYPE',
			name		: 'DED_TYPE', 
			value		: '1',
			hidden		: true
		}]
	});



	Unilite.Main({
		id		: 'hpb400rkrApp',
		items	: [ panelSearch],
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE'		, UserInfo.divCode);
			panelSearch.setValue('SUPP_DATE_FR'	, UniDate.get('today'));
			panelSearch.setValue('SUPP_DATE_TO'	, UniDate.get('today'));

			var today		= UniDate.get('today');
			var strReceDate	= UniDate.getDbDateStr(today).substring(0, 4)
							+ UniDate.getDbDateStr(today).substring(4, 6)
							+ "10"
			panelSearch.setValue('RECE_DATE'	, strReceDate);

			gsDED_TYPE = '1';
			if (!Ext.isEmpty(gsUserDept)){
				panelSearch.setValue('DEPT_CODE_FR', gsUserDept[0].DEPT_CODE);
				panelSearch.setValue('DEPT_NAME_FR', gsUserDept[0].DEPT_NAME);
				panelSearch.setValue('DEPT_CODE_TO', gsUserDept[0].DEPT_CODE);
				panelSearch.setValue('DEPT_NAME_TO', gsUserDept[0].DEPT_NAME);
			}
			UniAppManager.setToolbarButtons('reset',false);
			UniAppManager.setToolbarButtons('print',false);
		},
		onPrintButtonDown: function() {
			var param			= panelSearch.getValues();
			param.DIV_NAME		= panelSearch.getField('DIV_CODE').getRawValue();
			param.TITLE_NAME	= panelSearch.getField('MEDIUM_TYPE').getRawValue();
			param.PGM_ID		= 'hpb400rkr';
			var sReportType		= Ext.getCmp('radio1').getChecked()[0].inputValue;
			var sMediumType		= panelSearch.getValue('MEDIUM_TYPE');

			if(sReportType == '3') {
				param.sTxtValue2_fileTitle	= '기타(사업)소득 집계표';
				param.DATE_FR				= param.SUPP_DATE_FR + '01';
				//param.DATE_TO				= UniDate.getDbDateStr(new Date(param.SUPP_DATE_TO.substring(0, 4), param.SUPP_DATE_TO.substring(5, 6), 0));
				param.DATE_TO				= param.SUPP_DATE_TO + '31';
			} else {
				if(sMediumType == '4') {
					param.sTxtValue2_fileTitle = '이자배당소득원천징수영수증';
				//20200807 주석: 클립리포트로 대체 / 조건별 분개 로직 추가(java)
				} else if(sMediumType == '1') {
					if(sReportType == '0') {
						param.sTxtValue2_fileTitle = '이자배당소득원천징수영수증';
					} else if(sReportType == '1') {
						param.sTxtValue2_fileTitle = '이자배당소득원천징수영수증';
					} else if(sReportType == '2') {
						param.sTxtValue2_fileTitle = '이자배당소득원천징수영수증';
					}
				} else if(sMediumType == '2') {
/*				} else {
					var win = Ext.create('widget.PDFPrintWindow', {
						url		: CPATH+'/human/hpb400rkrPrint.do',
						prgID	: 'hpb400rkr',
						extParam: param
					});
					win.center();
					win.show();*/
				}
			}
			var win = Ext.create('widget.ClipReport', {
				url		: CPATH+'/human/hpb400clrkrv.do',
				prgID	: 'hpb400rkr',
				extParam: param
			});
			win.center();
			win.show();
		}
	});
};
</script>