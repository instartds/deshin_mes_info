<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hum980rkr">
	<t:ExtComboStore comboType="BOR120"/>						<!-- 사업장 -->
	<t:ExtComboStore comboType="BOR120" comboCode="BILL"/>		<!-- 신고사업장 -->
</t:appConfig>

<script type="text/javascript" >

var gsUserDept= '${deptData}';

function appMain() {
	var gsDED_TYPE;
	//20200804 추가: 클립리포트 추가로 리포트 출력 방식 설정(CR:크리스탈 또는 jasper CLIP:클립리포트)
	var BsaCodeInfo = {
		gsReportGubun: '${gsReportGubun}'
	};


	/** 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchForm('hum980rkrForm', {
		region	: 'center',
		disabled: false,
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
		defaultType	: 'uniTextfield',
		padding		: '20 0 0 0',
		width		: 400,
		items		: [{
			fieldLabel	: '사업장',
			name		: 'DIV_CODE', 
			xtype		: 'uniCombobox',
			comboType	: 'BOR120'
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
			fieldLabel	: '직위',
			name		: 'POST_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'H005'
		},
		Unilite.popup('Employee',{
			fieldLabel		: '사원',
			valueFieldName	: 'PERSON_NUMB',
			textFieldName	: 'NAME',
			validateBlank	: false,
			autoPopup		: true,
			listeners		: {
				applyextparam: function(popup){	
					popup.setExtParam({'BASE_DT': '00000000'}); 
				}
			}
		}),{
			xtype		: 'radiogroup',
			fieldLabel	: '비정규직포함',
			items		: [{
				boxLabel: '한다', width: 100, name: 'PAY_GUBUN', inputValue: 'N'
			}, {
				boxLabel: '안한다', width: 100, name: 'PAY_GUBUN', inputValue: 'Y',checked: true
			}]
		},{
			xtype		: 'radiogroup',
			fieldLabel	: '퇴직자포함',
			items		: [{
				boxLabel: '한다', width: 100, name: 'RETR_YN', inputValue: 'Y'
			}, {
				boxLabel: '안한다', width: 100, name: 'RETR_YN', inputValue: 'N',checked: true
			}]
		},{
			xtype	: 'button',
			text	: '출력',
			width	: 235,
			tdAttrs:{'align':'center', style:'padding-left:95px'},
			handler:function()	{
				UniAppManager.app.onPrintButtonDown();
			}
		}]
	});



	Unilite.Main({
		id		: 'hum980rkrApp',
		items	: [ panelSearch],
		fnInitBinding : function() {
			//panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('reset', false);
			UniAppManager.setToolbarButtons('print', false);

			var today = UniDate.get('today');
			var strReceDate= UniDate.getDbDateStr(today).substring(0, 4) 
						   + UniDate.getDbDateStr(today).substring(4, 6)
						   + "10"
			gsDED_TYPE = '1';

			if (!Ext.isEmpty(gsUserDept)){
				panelSearch.setValue('DEPT_CODE_FR', gsUserDept[0].DEPT_CODE);
				panelSearch.setValue('DEPT_NAME_FR', gsUserDept[0].DEPT_NAME);
				panelSearch.setValue('DEPT_CODE_TO', gsUserDept[0].DEPT_CODE);
				panelSearch.setValue('DEPT_NAME_TO', gsUserDept[0].DEPT_NAME);
				panelSearch.down('#DEPT_CODE_FR').setDisabled(true);
				panelSearch.down('#DEPT_CODE_TO').setDisabled(true);
			}else{
				panelSearch.down('#DEPT_CODE_FR').setDisabled(false);
				panelSearch.down('#DEPT_CODE_TO').setDisabled(false);
			}
		},
		onPrintButtonDown: function() {
			if(!panelSearch.getInvalidMessage()) return;
			var param		= panelSearch.getValues();
			param.DIV_NAME	= panelSearch.getField('DIV_CODE').getRawValue();
			//20200804 추가: 클립리포트 추가로 리포트 출력 방식 설정(CR:크리스탈 또는 jasper CLIP:클립리포트)
			var reportGubun	= BsaCodeInfo.gsReportGubun
			if(reportGubun.toUpperCase() == 'CLIP'){
				param.PGM_ID				= 'hum980rkr';
				param.MAIN_CODE				= 'H184';
				param.sTxtValue2_fileTitle	= '인    사    카    드';
				var win = Ext.create('widget.ClipReport', {
					url		: CPATH+'/human/hum980clrkrPrint.do',
					prgID	: 'hum980rkr',
					extParam: param
				});
				win.center();
				win.show();
			} else {
				//기존로직
//				param["TITLE_NAME"]=panelSearch.getField('MEDIUM_TYPE').getRawValue();
//				param["PGM_ID"]='hum980rkr';
				var win = Ext.create('widget.PDFPrintWindow', {
					url		: CPATH+'/human/hum980rkrPrint.do',
					prgID	: 'hum980rkr',
					extParam: param
				});
				win.center();
				win.show();
			}
		}
	});
};
</script>