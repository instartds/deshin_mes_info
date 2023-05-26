<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="agb120rkr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B042" /> <!-- 금액단위-->
	<t:ExtComboStore comboType="AU" comboCode="A093" /> <!-- 재무제표양식차수-->
</t:appConfig>
<script type="text/javascript" >

var BsaCodeInfo = {
	gsReportGubun: '${gsReportGubun}'	//20200724 추가: 필수체크로직 / clip report 추가
};
var getStDt = Ext.isEmpty(${getStDt}) ? []: ${getStDt} ;
var getChargeCode = Ext.isEmpty(${getChargeCode}) ? ['']: ${getChargeCode} ;

function appMain() {   
	var panelSearch = Unilite.createSearchForm('agb120rkrForm', {
		region: 'center',
		disabled :false,
		border: false,
		flex:1,
		layout: {
			type: 'uniTable',
			columns:1
		},
		defaults:{
			labelWidth:90
		},
		defaultType: 'uniTextfield',
		padding:'20 0 0 0',
		width:400,
		items : [{
			fieldLabel: '전표일',
			xtype: 'uniDateRangefield',
			startFieldName: 'AC_DATE_FR',
			endFieldName: 'AC_DATE_TO',
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today'),
			allowBlank:false
		 },{ 
			fieldLabel: '사업장',
			name: 'DIV_CODE',
			xtype: 'uniCombobox',
				multiSelect: true, 
//				typeAhead: false,
			value : UserInfo.divCode,
			comboType: 'BOR120'
		},
		 { 
			fieldLabel: '당기시작년월',
			name: 'START_DATE',
			xtype: 'uniMonthfield',
			allowBlank:false,
			width:250
	 	},
		 Unilite.popup('DEPT',{
				fieldLabel: '부서',
				valueFieldName:'DEPT_CODE_FR',
				textFieldName:'DEPT_NAME_FR',
				autoPopup: true,
				extParam:{'CUSTOM_TYPE':'3'}
		}),
		  	Unilite.popup('DEPT',{
				fieldLabel: '~',
				valueFieldName:'DEPT_CODE_TO',
				textFieldName:'DEPT_NAME_TO',
				autoPopup: true,
//					validateBlank:false,						//autoPopup: true, 추가하면서 주석처리
				extParam:{'CUSTOM_TYPE':'3'}
		}),
	   
		 {
			xtype: 'radiogroup',
			fieldLabel: '과목명',
			id: 'radio1',
			items: [{
				boxLabel: '과목명1', width: 82, name: 'ACCOUNT_NAME', inputValue: '0'//, checked: true
			}, {
				boxLabel: '과목명2', width: 82, name: 'ACCOUNT_NAME', inputValue: '1'
			}, {
				boxLabel: '과목명3', width: 82, name: 'ACCOUNT_NAME', inputValue: '2'
			}]
		 },
		 {
				xtype: 'radiogroup',							
				fieldLabel: '과목구분',
				id: 'radio2',
				items: [{
					boxLabel: '과목', width: 82 , name: 'ACCNT_DIVI', inputValue: '1'//, checked: true
				}, {
					boxLabel: '세목', width: 82 , name: 'ACCNT_DIVI', inputValue: '2'
				}]
		  },
		  {
				xtype: 'radiogroup',							
				fieldLabel: '집계항목',
				id: 'radio3',
				items: [{
					boxLabel: '적용' , width: 82, name: 'SUM_DIVI', inputValue: '1'
				}, {
					boxLabel: '미적용' , width: 82, name: 'SUM_DIVI', inputValue: '2'//,checked: true
				}]
		  },
		{xtype:'uniCheckboxgroup',fieldLabel:'조건',
			items:[{ 
				name: 'CHK_TERM',
				xtype:'checkbox',
				boxLabel: ' 당일발생 ',
				checked:false,
				inputValue:'1',
				boxLabelAlign:'before'
			}]
		 },
			{
			 	xtype:'button',
			 	text:'출	력',
			 	width:235,
			 	tdAttrs:{'align':'center', style:'padding-left:95px'},
			 	handler:function()	{
			 		UniAppManager.app.onPrintButtonDown();
			 	}
			}
   		]
   	});
	
   
   
	
	 Unilite.Main( {
	 	border: false,
	 	items:[
	 		panelSearch
	 		],
	 
		id : 'agb120rkrApp',
		fnInitBinding : function(params) {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			//사용자 ID에 따라 과목명 default 값 다르게 가져옴
			panelSearch.getField('ACCOUNT_NAME').setValue(UserInfo.refItem);
			//당기시작월 세팅
			panelSearch.setValue('START_DATE',getStDt[0].STDT);
			panelSearch.setValue('AC_DATE_FR',UniDate.get('startOfMonth'));
			panelSearch.setValue('AC_DATE_TO',UniDate.get('today'));
//			CALL fnPrintinit()
//			'Call InitCombo(cParam)
//			Call fnSanction(rsSheet)
			
			UniAppManager.setToolbarButtons('reset',false);
			UniAppManager.setToolbarButtons('print',false);
			
			if(!Ext.isEmpty(params.AC_DATE_FR)){
				this.processParams(params);
			}
		},
		//링크로 넘어오는 params 받는 부분 
		processParams: function(param) {
			//agb120skr.jsp(총계정원장)에서 링크걸려옴
			panelSearch.setValue('AC_DATE_FR'	, param.AC_DATE_FR),
			panelSearch.setValue('AC_DATE_TO'	, param.AC_DATE_TO),
			panelSearch.setValue('DIV_CODE'		, param.ACCNT_DIV_CODE),
			panelSearch.setValue('CHK_TERM'		, param.CHK_TERM),
			panelSearch.setValue('DEPT_CODE_FR'	, param.DEPT_CODE_FR),
			panelSearch.setValue('DEPT_CODE_TO'	, param.DEPT_CODE_TO),
			panelSearch.setValue('DEPT_NAME_FR'	, param.DEPT_NAME_FR),
			panelSearch.setValue('DEPT_NAME_TO'	, param.DEPT_NAME_TO),
			panelSearch.setValue('START_DATE'	, param.START_DATE),

			panelSearch.getField('ACCOUNT_NAME').setValue(param.ACCOUNT_NAME);
			panelSearch.getField('ACCNT_DIVI').setValue(param.ACCNT_DIVI);
			panelSearch.getField('SUM_DIVI').setValue(param.SUM_DIVI);
		},
		onPrintButtonDown: function() {
			//20200724 추가: 필수체크로직 / clip report 추가
			if(!this.isValidSearchForm()){
				return false;
			}
			var reportGubun = BsaCodeInfo.gsReportGubun;
			if(reportGubun.toUpperCase() == 'CLIP'){
				var param			= panelSearch.getValues();
				param.PGM_ID		= 'agb120rkr';
				param.MAIN_CODE		= 'A126';
				param.ACCNT_DIV_NAME= panelSearch.getField('DIV_CODE').getRawValue();
				param.PRINT_YN		= 'Y';
				//20200716 사업장 멀티선택로직 추가
				if(!Ext.isEmpty(panelSearch.getValue('DIV_CODE'))) {
					var items = '';
					var divCode = panelSearch.getValue('DIV_CODE');
					Ext.each(divCode, function(item, i) {
						if(i == 0) {
							items = item;
						} else {
							items = items + ',' + item;
						}
					});
					param.DIV_CODE = items;
					param.item = items;
				}
				var win = Ext.create('widget.ClipReport', {
					url		: CPATH+'/accnt/agb120clrkrPrint.do',
					prgID	: 'agb120rkr',
					extParam: param
				});
				win.center();
				win.show();
			} else {
				var win = Ext.create('widget.PDFPrintWindow', {
					url: CPATH+'/agb/agb120rkr.do',
					prgID: 'agb120rkr',
					extParam: panelSearch.getValues()
				})
				win.center();
				win.show();
			}
		}
	});
};
</script>