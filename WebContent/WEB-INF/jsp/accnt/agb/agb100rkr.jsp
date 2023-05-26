<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="agb100rkr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B042" /> <!-- 금액단위-->
	<t:ExtComboStore comboType="AU" comboCode="A093" /> <!-- 재무제표양식차수-->
</t:appConfig>
<script type="text/javascript" >

var BsaCodeInfo =  {
	
};
var getStDt = Ext.isEmpty(${getStDt}) ? []: ${getStDt} ;	
var gsChargeCode  = Ext.isEmpty(${getChargeCode}) ? ['']: ${getChargeCode};   //ChargeCode 관련 전역변수

function appMain() {   
	var panelSearch = Unilite.createSearchForm('agb100rkrForm', {
		region: 'center',
    	disabled :false,
    	border: false,
    	flex:1,
    	layout: {
	    	type: 'uniTable',
			columns:1
	    },
	    defaults:{
	    	width:325,
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
			typeAhead: false,
			value : UserInfo.divCode,
			comboType: 'BOR120'
		},
		Unilite.popup('ACCNT',{
	    	fieldLabel: '계정과목',
	    	valueFieldName: 'ACCNT_CODE_FR',
	    	textFieldName: 'ACCNT_NAME_FR',
	    	autoPopup: true,
	    	listeners: {
	    		applyExtParam:{
                    scope:this,
                    fn:function(popup){
                        var param = {
                            'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
                        }
                        popup.setExtParam(param);
                    }
                }
	    	}
	    }),	    
	    Unilite.popup('ACCNT',{
	    	fieldLabel: '~',
			valueFieldName: 'ACCNT_CODE_TO',
	    	textFieldName: 'ACCNT_NAME_TO',  	
	    	autoPopup: true,
            listeners: {
                applyExtParam:{
                    scope:this,
                    fn:function(popup){
                        var param = {
                            'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
                        }
                        popup.setExtParam(param);
                    }
                }
            }
		}),
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
//			        validateBlank:false,						//autoPopup: true, 추가하면서 주석처리
				extParam:{'CUSTOM_TYPE':'3'}
	    }),
	   
         {
    		xtype: 'uniRadiogroup',		            		
    		fieldLabel: '과목명',
    		id: 'radio1',
    		items: [{
    			boxLabel: '과목명1', width: 82, name: 'ACCOUNT_NAME', inputValue: '0'
    		}, {
    			boxLabel: '과목명2', width: 82, name: 'ACCOUNT_NAME', inputValue: '1'
    		}, {
    			boxLabel: '과목명3', width: 82, name: 'ACCOUNT_NAME', inputValue: '2'
    		}]
         }, { 
				fieldLabel: '당기시작년월',
				name: 'START_DATE',
                xtype: 'uniMonthfield',
                allowBlank:false,
                width:250
         },
		{xtype:'uniCheckboxgroup',fieldLabel:'출력조건',
            items:[{ 
            	name: 'check1',
            	xtype:'checkbox',
            	boxLabel: '계정과목별 페이지 처리',
            	checked:true,
            	inputValue:'1',
            	boxLabelAlign:'before'
            }]
         },
         {
         	xtype:'button',
         	text:'출    력',
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
	 
		id : 'agb100rkrApp',
		fnInitBinding : function(params) {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			//사용자 ID에 따라 과목명 default 값 다르게 가져옴
			
			panelSearch.setValue('AC_DATE_FR',UniDate.get('startOfMonth'));
			panelSearch.setValue('AC_DATE_TO',UniDate.get('today'));
			//당기시작월 세팅
            panelSearch.setValue('START_DATE',getStDt[0].STDT);
            
			
//			CALL fnPrintinit()
//			'Call InitCombo(cParam)
//			Call fnSanction(rsSheet)
			
			UniAppManager.setToolbarButtons('reset',false);
			UniAppManager.setToolbarButtons('print',false);
			if(!Ext.isEmpty(params && params.PGM_ID)){
                this.processParams(params);
			}else{
				panelSearch.getField('ACCOUNT_NAME').setValue(UserInfo.refItem);
			}
		},
		onQueryButtonDown : function()	{
		},
		onDetailButtonDown:function() {
		},
		onPrintButtonDown: function() {
			var param= panelSearch.getValues();
			param.DIV_CODE = panelSearch.getValue('DIV_CODE').join(",");
			param.DIV_NAME = panelSearch.getField('DIV_CODE').getRawValue();
			/* param["DIV_NAME"]=panelSearch.getField('DIV_CODE').getRawValue();
			param["DIV_CODE"]=panelSearch.getValue('DIV_CODE'); */
			/* param["DIV_CODE"] = panelSearch.getField("ACCNT_DIV_CODE").toString().split(","); */
			param["PGM_ID"]='agb100rkr';
			param["sTxtValue2_fileTitle"]='총계정원장';
			param["GROUP_YN"] = panelSearch.getValue('check1')=="1"?true:false;
			var win = Ext.create('widget.ClipReport', {
				url: CPATH+'/accnt/agb100clrkrPrint.do',
				prgID: 'agb100rkr',
				extParam: param
//					{
					
//					AC_DATE_FR		: panelSearch.getValue('AC_DATE_FR'),
//					AC_DATE_TO		: panelSearch.getValue('AC_DATE_TO'),
//					DIV_CODE        : panelSearch.getValue('DIV_CODE'),
//					DIV_NAME        : panelSearch.getField('DIV_CODE').getRawValue(),
//					ACCNT_CODE_FR   : panelSearch.getValue('ACCNT_CODE_FR'),
//					ACCNT_CODE_FR	: panelSearch.getValue('ACCNT_CODE_TO'),
//					DEPT_CODE_FR 	: panelSearch.getValue('DEPT_CODE_FR'),
//					DEPT_CODE_TO	: panelSearch.getValue('DEPT_CODE_TO'),
//					START_DATE		: panelSearch.getValue('START_DATE'),
//					LANG            : UserInfo.userLang,
//					ACCOUNT_NAME    : panelSearch.getValue('radio1').ACCOUNT_NAME,
//					GROUP_YN        : panelSearch.getValue('check1'),
//					PGM_ID          : 'agb100rkr'
//				}
				});
			win.center();
			win.show();   				
		},
		//링크로 넘어오는 params 받는 부분 
        processParams: function(params) {
            this.uniOpt.appParams = params;
            if(params.PGM_ID == 'agb100skr') {
            	panelSearch.getField('ACCOUNT_NAME').setValue('');
            	panelSearch.setValue('AC_DATE_FR',params.AC_DATE_FR);
                panelSearch.setValue('AC_DATE_TO',params.AC_DATE_TO);
                panelSearch.setValue('DIV_CODE',params.DIV_CODE);
                panelSearch.setValue('START_DATE',params.START_DATE);
                panelSearch.setValue('DEPT_CODE_FR',params.DEPT_CODE_FR);
                panelSearch.setValue('DEPT_NAME_FR',params.DEPT_NAME_FR);
                panelSearch.setValue('DEPT_CODE_TO',params.DEPT_CODE_TO);
                panelSearch.setValue('DEPT_NAME_TO',params.DEPT_NAME_TO);
                panelSearch.setValue('ACCNT_CODE_FR',params.ACCNT_CODE_FR);
                panelSearch.setValue('ACCNT_NAME_FR',params.ACCNT_NAME_FR);
                panelSearch.setValue('ACCNT_CODE_TO',params.ACCNT_CODE_TO);
                panelSearch.setValue('ACCNT_NAME_TO',params.ACCNT_NAME_TO);
                panelSearch.getField('ACCOUNT_NAME').setValue(params.ACCOUNT_NAME);
            }
        }
		
	});
};



</script>
