<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<t:appConfig pgmId="agb125rkr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
</t:appConfig>
<script type="text/javascript" >

var getStDt = Ext.isEmpty(${getStDt}) ? []: ${getStDt} ;

function appMain() {   
	var panelSearch = Unilite.createSearchForm('agb125rkrForm', {
		region: 'center',
		disabled:false,
		border: false,
		flex:1,
		layout: {
			type:'uniTable',
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
			name: 'ACCNT_DIV_CODE',
			xtype: 'uniCombobox',
			multiSelect: true,
			value : UserInfo.divCode,
			comboType: 'BOR120'
		},{ 
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
			extParam:{'CUSTOM_TYPE':'3'}
		}),{
			xtype: 'radiogroup',		            		
			fieldLabel: '과목명',
			id: 'radio1',
			items: [{boxLabel: '과목명1', width: 82, name: 'ACCOUNT_NAME', inputValue: '0', checked: true},{
					 boxLabel: '과목명2', width: 82, name: 'ACCOUNT_NAME', inputValue: '1'},{
					 boxLabel: '과목명3', width: 82, name: 'ACCOUNT_NAME', inputValue: '2'}]
		},{
			xtype: 'radiogroup',		            		
			fieldLabel: '과목구분',
			id: 'radio2',
			items: [{boxLabel: '과목', width: 82 , name: 'ACCNT_DIVI', inputValue: '1', checked: true},{
					 boxLabel: '세목', width: 82 , name: 'ACCNT_DIVI', inputValue: '2'}]
		},{
			xtype:'button',
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
		id : 'agb125rkrApp',
		fnInitBinding : function(params) {
			panelSearch.setValue('ACCNT_DIV_CODE',UserInfo.divCode);
			//사용자 ID에 따라 과목명 default 값 다르게 가져옴
			panelSearch.getField('ACCOUNT_NAME').setValue(UserInfo.refItem);
			//당기시작월 세팅
			panelSearch.setValue('START_DATE',getStDt[0].STDT);
			panelSearch.setValue('AC_DATE_FR',UniDate.get('startOfMonth'));
			panelSearch.setValue('AC_DATE_TO',UniDate.get('today'));
			
			UniAppManager.setToolbarButtons('reset',false);
			UniAppManager.setToolbarButtons('print',false);
			
			if(!Ext.isEmpty(params.AC_DATE_FR)){
				this.processParams(params);
			}
		},
		//링크로 넘어오는 params 받는 부분 
		processParams: function(param) {
			//agb125skr.jsp(일계표)에서 링크걸려옴
			panelSearch.setValue('AC_DATE_FR', param.AC_DATE_FR),
			panelSearch.setValue('AC_DATE_TO', param.AC_DATE_TO),
			panelSearch.setValue('DIV_CODE', param.ACCNT_DIV_CODE),
			panelSearch.setValue('CHK_TERM', param.CHK_TERM),
			panelSearch.setValue('DEPT_CODE_FR', param.DEPT_CODE_FR),
			panelSearch.setValue('DEPT_CODE_TO', param.DEPT_CODE_TO),
			panelSearch.setValue('DEPT_NAME_FR', param.DEPT_NAME_FR),
			panelSearch.setValue('DEPT_NAME_TO', param.DEPT_NAME_TO),
			panelSearch.setValue('START_DATE', param.START_DATE),
			
			panelSearch.getField('ACCOUNT_NAME').setValue(param.ACCOUNT_NAME);            
			panelSearch.getField('ACCNT_DIVI').setValue(param.ACCNT_DIVI);
		},
		onQueryButtonDown : function()	{
		},
		onDetailButtonDown:function() {
		},
		onPrintButtonDown: function() {
			var param = panelSearch.getValues();
			
			param.STXTVALUE2_FILETITLE = '일계표(2)';
			param.ACCNT_DIV_CODE = panelSearch.getValue('ACCNT_DIV_CODE').join(",");
			param.ACCNT_DIV_NAME = panelSearch.getField('ACCNT_DIV_CODE').getRawValue();
			
			var win = Ext.create('widget.ClipReport', {
				url: CPATH+'/accnt/agb125clrkr.do',
				prgID: 'agb125rkr',
				extParam: param
			})
			win.center();
			win.show();
		}
	});
};

</script>
