<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="agb110rkr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B042" /> <!-- 금액단위-->
	<t:ExtComboStore comboType="AU" comboCode="A093" /> <!-- 재무제표양식차수-->
</t:appConfig>
<script type="text/javascript" >

var BsaCodeInfo =  {
		gsReportGubun: '${gsReportGubun}'//클립리포트 추가로 인한 리포트 출력 방식 설정(CR:크리스탈 또는 jasper CLIP:클립리포트)
};
var getStDt = Ext.isEmpty(${getStDt}) ? []: ${getStDt} ;	
var gsChargeCode  = Ext.isEmpty(${getChargeCode}) ? ['']: ${getChargeCode};   //ChargeCode 관련 전역변수

function appMain() {   
	var panelSearch = Unilite.createSearchForm('agb110rkrForm', {
		region: 'center',
    	disabled :false,
    	border: false,
    	flex:1,
    	layout: {
	    	type: 'uniTable',
			columns:4
	    },
	    defaults:{
	    	width:325,
			labelWidth:90
	    },
		defaultType: 'uniTextfield',
		padding:'20 0 0 0',
		width:325,
		autoScroll:true,
		items : [{
			fieldLabel: '전표일',			
			xtype: 'uniDateRangefield',
			startFieldName: 'AC_DATE_FR',
			endFieldName: 'AC_DATE_TO',
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today'),
			allowBlank:false
	     },{
            xtype: 'radiogroup',    
            fieldLabel: '과목구분',
            id: 'ACCNT_DIVI_RADIO',
            colspan: 3,
            items: [{
                boxLabel: '과목', width: 82, name: 'ACCNT_DIVI', inputValue: '1'
            }, {
                boxLabel: '세목', width: 82, name: 'ACCNT_DIVI', inputValue: '2'
            }]
        }, 
/* 	     { 
			fieldLabel: '사업장',
			name: 'DIV_CODE',
			xtype: 'uniCombobox',
//				multiSelect: false, 
//				typeAhead: false,
			value : UserInfo.divCode,
			comboType: 'BOR120'
		}, */
		Unilite.popup('ACCNT',{
	    	fieldLabel: '범위지정',
	    	colspan: 1,
	    	valueFieldName: 'ACCNT_CODE_FR',
	    	textFieldName: 'ACCNT_NAME_FR',
	    	autoPopup: true,
		    listeners: {
		    	onSelected:{
		    		fn: function(records, type) {
		    			panelSearch.setReadOnlyByAcctCode();
					},
					scope: this
				
	    		},
	    		onClear: function(type)	{
	    			panelSearch.setReadOnlyByAcctCode();
	    		},
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
	    	colspan: 1,
			valueFieldName: 'ACCNT_CODE_TO',
	    	textFieldName: 'ACCNT_NAME_TO',  	
	    	autoPopup: true,
		    listeners: {
		    	onSelected:{
		    		fn: function(records, type) {
		    			panelSearch.setReadOnlyByAcctCode();
					},
					scope: this
	    		},
	    		onClear: function(type)	{
	    			panelSearch.setReadOnlyByAcctCode();
	    		},
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
		}),{
		  xtype: 'component',
		  colspan: 2
		},
    	Unilite.popup('ACCNT',{
    	    	fieldLabel: '내제외과목',
    	    	colspan: 1,
    	    	valueFieldName: 'ACCNT_CODE_EX1',
    	    	textFieldName: 'ACCNT_NAME_EX1',
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
	    	fieldLabel: ' ',
	    	colspan: 1,
	    	valueFieldName: 'ACCNT_CODE_EX2',
	    	textFieldName: 'ACCNT_NAME_EX2',
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
	    	fieldLabel: ' ',
	    	colspan: 1,
	    	valueFieldName: 'ACCNT_CODE_EX3',
	    	textFieldName: 'ACCNT_NAME_EX3',
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
	    	fieldLabel: ' ',
	    	colspan: 1,
	    	valueFieldName: 'ACCNT_CODE_EX4',
	    	textFieldName: 'ACCNT_NAME_EX4',
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
	    	fieldLabel: ' ',
	    	colspan: 1,
	    	valueFieldName: 'ACCNT_CODE_EX5',
	    	textFieldName: 'ACCNT_NAME_EX5',
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
    	fieldLabel: ' ',
    	colspan: 1,
    	valueFieldName: 'ACCNT_CODE_EX6',
    	textFieldName: 'ACCNT_NAME_EX6',
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
    	fieldLabel: ' ',
    	colspan: 1,
    	valueFieldName: 'ACCNT_CODE_EX7',
    	textFieldName: 'ACCNT_NAME_EX7',
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
    	fieldLabel: ' ',
    	colspan: 1,
    	valueFieldName: 'ACCNT_CODE_EX8',
    	textFieldName: 'ACCNT_NAME_EX8',
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
	    	fieldLabel: '개별과목지정',
	    	colspan: 1,
	    	valueFieldName: 'ACCNT_CODE_SP1',
	    	textFieldName: 'ACCNT_NAME_SP1',
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
	    	fieldLabel: ' ',
	    	colspan: 1,
	    	valueFieldName: 'ACCNT_CODE_SP2',
	    	textFieldName: 'ACCNT_NAME_SP2',
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
	    	fieldLabel: ' ',
	    	colspan: 1,
	    	valueFieldName: 'ACCNT_CODE_SP3',
	    	textFieldName: 'ACCNT_NAME_SP3',
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
	    	fieldLabel: ' ',
	    	colspan: 1,
	    	valueFieldName: 'ACCNT_CODE_SP4',
	    	textFieldName: 'ACCNT_NAME_SP4',
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
	    	fieldLabel: ' ',
	    	colspan: 1,
	    	valueFieldName: 'ACCNT_CODE_SP5',
	    	textFieldName: 'ACCNT_NAME_SP5',
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
	    	fieldLabel: ' ',
	    	colspan: 1,
	    	valueFieldName: 'ACCNT_CODE_SP6',
	    	textFieldName: 'ACCNT_NAME_SP6',
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
	    	fieldLabel: ' ',
	    	colspan: 1,
	    	valueFieldName: 'ACCNT_CODE_SP7',
	    	textFieldName: 'ACCNT_NAME_SP7',
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
            }		}),
		Unilite.popup('ACCNT',{
	    	fieldLabel: ' ',
	    	colspan: 1,
	    	valueFieldName: 'ACCNT_CODE_SP8',
	    	textFieldName: 'ACCNT_NAME_SP8',
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
		}),Unilite.popup('ACCNT',{
	    	fieldLabel: ' ',
	    	colspan: 1,
	    	valueFieldName: 'ACCNT_CODE_SP9',
	    	textFieldName: 'ACCNT_NAME_SP9',
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
	    	fieldLabel: ' ',
	    	colspan: 1,
	    	valueFieldName: 'ACCNT_CODE_SP10',
	    	textFieldName: 'ACCNT_NAME_SP10',
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
	    	fieldLabel: ' ',
	    	colspan: 1,
	    	valueFieldName: 'ACCNT_CODE_SP11',
	    	textFieldName: 'ACCNT_NAME_SP11',
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
	    	fieldLabel: ' ',
	    	colspan: 1,
	    	valueFieldName: 'ACCNT_CODE_SP12',
	    	textFieldName: 'ACCNT_NAME_SP12',
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
		}),Unilite.popup('ACCNT',{
	    	fieldLabel: ' ',
	    	colspan: 1,
	    	valueFieldName: 'ACCNT_CODE_SP13',
	    	textFieldName: 'ACCNT_NAME_SP13',
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
	    	fieldLabel: ' ',
	    	colspan: 1,
	    	valueFieldName: 'ACCNT_CODE_SP14',
	    	textFieldName: 'ACCNT_NAME_SP14',
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
	    	fieldLabel: ' ',
	    	colspan: 1,
	    	valueFieldName: 'ACCNT_CODE_SP15',
	    	textFieldName: 'ACCNT_NAME_SP15',
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
	    	fieldLabel: ' ',
	    	colspan: 1,
	    	valueFieldName: 'ACCNT_CODE_SP16',
	    	textFieldName: 'ACCNT_NAME_SP16',
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
		//more choose select
		{
			fieldLabel: '사업장',
			colspan: 4,
			name:'ACCNT_DIV_CODE', 
			xtype: 'uniCombobox',
	        multiSelect: true, 
	        typeAhead: false,
	        value:UserInfo.divCode,
	        comboType:'BOR120',
			width: 325,
			listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						
					}
				}
		},
	   /* 
         {
    		xtype: 'radiogroup',		            		
    		fieldLabel: '과목명',
    		id: 'radio1',
    		items: [{
    			boxLabel: '과목명1', width: 82, name: 'ACCOUNT_NAME', inputValue: '0'
    		}, {
    			boxLabel: '과목명2', width: 82, name: 'ACCOUNT_NAME', inputValue: '1'
    		}, {
    			boxLabel: '과목명3', width: 82, name: 'ACCOUNT_NAME', inputValue: '2'
    		}]
         },  */
         { 
			fieldLabel: '당기시작년월',
			colspan: 4,
			name: 'START_DATE',
            xtype: 'uniMonthfield',
            readOnly:false,
            width:250
         },
         Unilite.popup('ACCNT_PRSN',{
	    	fieldLabel: '입력자',
	    	colspan: 4,
		    valueFieldName:'CHARGE_CODE',
		    textFieldName:'CHARGE_NAME',
	    	validateBlank:false
		 }),
		 {
			xtype: 'container',
			colspan: 4,
			layout: {type : 'uniTable', columns : 3},
			width:600,
			items :[{
				fieldLabel:'금액', 
				xtype: 'uniNumberfield',
				name: 'FR_AMT_I', 
				width: 203
			},{
				xtype:'component', 
				html:'~',
				style: {
					marginTop: '3px !important',
					font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
				}
			},{
				fieldLabel:'', 
				xtype: 'uniNumberfield',
				name: 'TO_AMT_I', 
				width: 113
			}]
		},
		
		{
			xtype: 'container',
			colspan: 4,
			layout: {type : 'uniTable', columns : 3},
			width:600,
			items :[{
				fieldLabel:'외화금액', 
				xtype: 'uniNumberfield',
				name: 'FR_FOR_AMT_I', 
				width: 203
			},{
				xtype:'component', 
				html:'~',
				style: {
					marginTop: '3px !important',
					font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
				}
			},{
				fieldLabel:'', 
				xtype: 'uniNumberfield',
				name: 'TO_FOR_AMT_I', 
				width: 113
			}]
		},{
                xtype: 'uniTextfield',
                name: 'REMARK',
                fieldLabel: '적요',
                width: 325,
                colspan: 4
        },
	    Unilite.popup('DEPT',{
	        fieldLabel: '부서',
		    valueFieldName:'FR_DEPT_CODE',
		    textFieldName:'FR_DEPT_NAME',
	        validateBlank:false,
	        colspan: 4
	    }),
	      	Unilite.popup('DEPT',{
	        fieldLabel: '~',
	        colspan: 4,
		    valueFieldName:'TO_DEPT_CODE',
		    textFieldName:'TO_DEPT_NAME',
	        validateBlank:false
	    }), 
	    {
			fieldLabel: '출력조건',
			name: '',
			xtype: 'checkboxgroup', 
			width: 400, 
			colspan: 4,
			items: [{
	        	boxLabel: '수정삭제이력표시',
	        	name: 'INCLUDE_DELETE',
				width: 150,
				uncheckedValue: 'N',
	        	inputValue: 'Y'
	        }, {
				boxLabel: '각주',
	        	name: 'POSTIT_YN',
				width: 100,
				uncheckedValue: '',						//unilite에 체크 안 되어 있을 때 'N'으로 조회되나 데이터 조회 값은 ''이 들어간 것이 동일한 값을 가짐 일단 ''처리
	        	inputValue: 'Y',
        		listeners: {
   				 	change: function(field, newValue, oldValue, eOpts) {
   				 		if(panelSearch.getValue('POSTIT_YN')) {
							panelSearch.getField('POSTIT').setReadOnly(false);
   				 		} else {
							panelSearch.getField('POSTIT').setReadOnly(true);
   				 		}
					}
        		}
			}]
		},
	    {
	    	xtype: 'uniTextfield',
	    	fieldLabel: '각주',
	    	colspan: 4,
	    	width: 325,
	    	name:'POSTIT',
	    	readOnly: true
	    },
	     Unilite.popup('CUST',{
	        fieldLabel: '거래처',
	        colspan: 4,
			allowBlank:true,
			autoPopup:false,		        
	        validateBlank:false,
		    valueFieldName:'CUSTOM_CODE',
		    textFieldName:'CUSTOM_NAME',
			listeners: {
				onValueFieldChange:function( elm, newValue, oldValue) {	
					
					if(!Ext.isObject(oldValue)) {
						panelSearch.setValue('CUSTOM_NAME', '');
					}
				},
				onTextFieldChange:function( elm, newValue, oldValue) {
					
					if(!Ext.isObject(oldValue)) {
						panelSearch.setValue('CUSTOM_CODE', '');
					}
				}
			}	        
		}),
        {
            xtype: 'radiogroup',    
            colspan: 4,
            fieldLabel: '출력형식',
            id: 'RPT_SIZE_RADIO',
            items: [{
                boxLabel: '가로', 
                width: 82, 
                name: 'RPT_SIZE', 
                inputValue: '1'
            }, {
                boxLabel: '세로', 
                width: 82, 
                name: 'RPT_SIZE', 
                inputValue: '2'
                //checked : true
            }]
        },
         {
         	xtype:'button',
         	text:'출    력',
         	margin: '0 0 0 0',
         	colspan: 4,
         	tdAttrs: {align: 'center'},
         	width:235,
         	tdAttrs:{'align':'center', style:'padding-left:95px'},
         	handler:function()	{
         		UniAppManager.app.onPrintButtonDown();
         	}
         }
		],
	    setReadOnlyByAcctCode:function(){
			if(panelSearch.getValue('ACCNT_CODE_FR') || panelSearch.getValue('ACCNT_CODE_TO')) {
	 			for(var i=1;i<9;i++){
	 				panelSearch.getField('ACCNT_CODE_EX'+i).setReadOnly(false);
					panelSearch.getField('ACCNT_NAME_EX'+i).setReadOnly(false);
	 			}
	 				
	 		} else {
	 			for(var i=1;i<9;i++){
		 			panelSearch.getField('ACCNT_CODE_EX'+i).setReadOnly(true);
					panelSearch.getField('ACCNT_NAME_EX'+i).setReadOnly(true);
	 			}
	 		}
		}
	});
	
   
   
    
	 Unilite.Main( {
	 	border: false,
	 	items:[
	 		panelSearch
	 		],
	 
		id : 'agb110rkrApp',
		fnInitBinding : function(params) {
			panelSearch.getField('ACCNT_DIVI').setValue("1");
			panelSearch.getField('RPT_SIZE').setValue("1");
			panelSearch.setValue('ACCNT_DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('AC_DATE_FR',UniDate.get('startOfMonth'));
			panelSearch.setValue('AC_DATE_TO',UniDate.get('today'));
			panelSearch.setValue('START_DATE',getStDt[0].STDT);
			panelSearch.setReadOnlyByAcctCode();
			
			UniAppManager.setToolbarButtons('save',false);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			
			if(!Ext.isEmpty(params.AC_DATE_FR)){
                this.processParams(params);
            }
		},
        //링크로 넘어오는 params 받는 부분 
        processParams: function(param) {
        	//agb110skr.jsp(보조부)에서 링크걸려옴
        	if(param.CHECK_POST_IT == true){
                panelSearch.getField('POSTIT').setReadOnly(false);
            }else{
                panelSearch.getField('POSTIT').setReadOnly(true);
            }
            panelSearch.setValue('AC_DATE_FR', param.AC_DATE_FR),      
            panelSearch.setValue('AC_DATE_TO', param.AC_DATE_TO ),
            panelSearch.setValue('ACCNT_CODE_FR', param.ACCNT_CODE),      
            panelSearch.setValue('ACCNT_NAME_FR', param.ACCNT_NAME ),
            panelSearch.setValue('ACCNT_CODE_TO', param.ACCNT_CODE),      
            panelSearch.setValue('ACCNT_NAME_TO', param.ACCNT_NAME ),
            panelSearch.setValue('ACCNT_DIV_CODE', param.DIV_CODE ),  
            panelSearch.setValue('INCLUDE_DELETE', param.CHECK_DELETE ),
            panelSearch.setValue('POSTIT_YN', param.CHECK_POST_IT ),
            panelSearch.setValue('POSTIT', param.POST_IT ),
            panelSearch.setValue('START_DATE', param.START_DATE ),
            panelSearch.setValue('FR_AMT_I', param.AMT_FR ),
            panelSearch.setValue('TO_AMT_I', param.AMT_TO ),
            panelSearch.setValue('FR_FOR_AMT_I', param.FOR_AMT_FR ),
            panelSearch.setValue('TO_FOR_AMT_I', param.FOR_AMT_TO ),
            panelSearch.setValue('REMARK', param.REMARK ),
            panelSearch.setValue('CHARGE_CODE', param.CHARGE_CODE ),     
            panelSearch.setValue('CHARGE_NAME', param.CHARGE_NAME ),     
            panelSearch.setValue('CUSTOM_CODE', param.CUSTOM_CODE ),     
            panelSearch.setValue('CUSTOM_NAME', param.CUSTOM_NAME),  
            panelSearch.setValue('FR_DEPT_CODE', param.DEPT_CODE_FR),     
            panelSearch.setValue('TO_DEPT_CODE', param.DEPT_CODE_TO),
            panelSearch.setValue('FR_DEPT_NAME', param.DEPT_NAME_FR),     
            panelSearch.setValue('TO_DEPT_NAME', param.DEPT_NAME_TO),
            panelSearch.setValue('REMARK_CODE', param.REMARK_CODE),
            panelSearch.setValue('REMARK_NAME', param.REMARK_NAME),
            panelSearch.setValue('MONEY_UNIT', param.MONEY_UNIT)
        },
		onQueryButtonDown : function()	{
		},
		onDetailButtonDown:function() {
		},
		onPrintButtonDown: function() {
			
			/*var accnt_div_code = panelSearch.getField('ACCNT_DIV_CODE').getRawValue();
			
			var param = panelSearch.getValues();
			
			var param = {
                   AC_DATE_FR     : param.AC_DATE_FR,
                   AC_DATE_TO   : param.AC_DATE_TO,
                   ACCNT_DIVI    : param.ACCNT_DIVI,
                   START_DATE     : param.START_DATE, 
                   ACCNT_CODE_FR : param.ACCNT_CODE_FR,
                   ACCNT_CODE_TO : param.ACCNT_CODE_TO,
                   ACCNT_DIV_NAME     : accnt_div_code,
                   FR_DEPT_CODE    : param.FR_DEPT_CODE,			//지급일
                   TO_DEPT_CODE : param.TO_DEPT_CODE,		//지급차수
                   POSTIT    : param.POSTIT,			//고용형태
                   CHARGE_CODE  : param.CHARGE_CODE,		//사원구분
                   CUSTOM_CODE : param.CUSTOM_CODE,		//사원그룹
                   REMARK   : param.REMARK,			//직렬
                   CUSTOM_NAME  : param.CUSTOM_NAME,		//사원
                   
                   FR_AMT_I  : param.FR_AMT_I,		//사원
                   TO_AMT_I  : param.TO_AMT_I,		//사원
                   FR_FOR_AMT_I  : param.FR_FOR_AMT_I,		//사원
                   TO_FOR_AMT_I  : param.TO_FOR_AMT_I,		//사원
                   ACCNT_CODE_EX1  : param.ACCNT_CODE_EX1,		//사원
                   ACCNT_CODE_EX2  : param.ACCNT_CODE_EX2,		//사원
                   ACCNT_CODE_EX3  : param.ACCNT_CODE_EX3,		//사원
                   ACCNT_CODE_EX4  : param.ACCNT_CODE_EX4,		//사원
                   ACCNT_CODE_EX5  : param.ACCNT_CODE_EX5,		//사원
                   ACCNT_CODE_EX6  : param.ACCNT_CODE_EX6,		//사원
                   ACCNT_CODE_EX7  : param.ACCNT_CODE_EX7,		//사원
                   ACCNT_CODE_EX8  : param.ACCNT_CODE_EX8,		//사원
                   
                   ACCNT_CODE_SP1  : param.ACCNT_CODE_SP1,		//사원
                   ACCNT_CODE_SP2  : param.ACCNT_CODE_SP2,		//사원
                   ACCNT_CODE_SP3  : param.ACCNT_CODE_SP3,		//사원
                   ACCNT_CODE_SP4  : param.ACCNT_CODE_SP4,		//사원
                   ACCNT_CODE_SP5  : param.ACCNT_CODE_SP5,		//사원
                   ACCNT_CODE_SP6  : param.ACCNT_CODE_SP6,		//사원
                   ACCNT_CODE_SP7  : param.ACCNT_CODE_SP7,		//사원
                   ACCNT_CODE_SP8  : param.ACCNT_CODE_SP8,		//사원
                   ACCNT_CODE_SP9  : param.ACCNT_CODE_SP9,		//사원
                   ACCNT_CODE_SP10  : param.ACCNT_CODE_SP10,		//사원
                   ACCNT_CODE_SP11  : param.ACCNT_CODE_SP11,		//사원
                   ACCNT_CODE_SP12  : param.ACCNT_CODE_SP12,		//사원
                   ACCNT_CODE_SP13  : param.ACCNT_CODE_SP13,		//사원
                   ACCNT_CODE_SP14  : param.ACCNT_CODE_SP14,		//사원
                   ACCNT_CODE_SP15  : param.ACCNT_CODE_SP15,		//사원
                   ACCNT_CODE_SP16  : param.ACCNT_CODE_SP16,		//사원
                   
                   DIV_NAME  : param.DIV_NAME,		//사원
                   

                   FORMAT_I : '0'
            }*/
            
			var param= panelSearch.getValues();
            param.ACCNT_DIV_CODE = panelSearch.getValue('ACCNT_DIV_CODE').join(",");
			param.ACCNT_DIV_NAME = panelSearch.getField('ACCNT_DIV_CODE').getRawValue();
			param.FORMAT_I = '0';
			var reportGubun = BsaCodeInfo.gsReportGubun //초기화 시 가져온 구분값, 값이 없거나 CR이면 크리스탈리포트나 jasper리포트 출력
			if(Ext.isEmpty(reportGubun) || reportGubun == 'CR'){
				var win = Ext.create('widget.CrystalReport', {
	                url: CPATH+'/accnt/agb110crkr.do',
	                prgID: 'agb110crkr',
	                extParam: param
				});
			}else{
				var win = Ext.create('widget.ClipReport', {
	                url: CPATH+'/accnt/agb110clrkrPrint.do',
	                prgID: 'agb110crkr',
	                extParam: param
	            });
//				if(Ext.getCmp('RPT_SIZE_RADIO').getChecked()[0].inputValue == '1'){
//					var win = Ext.create('widget.ClipReport', {
//		                url: CPATH+'/accnt/agb110clrkr_1.do',
//		                prgID: 'agb110crkr',
//		                extParam: param
//		            });
//				}
//				if(Ext.getCmp('RPT_SIZE_RADIO').getChecked()[0].inputValue == '2'){
//					var win = Ext.create('widget.ClipReport', {
//		                url: CPATH+'/accnt/agb110clrkr_2.do',
//		                prgID: 'agb110crkr',
//		                extParam: param
//		            });
//				}
			}
			win.center();
			win.show();   
			
			/*var win = Ext.create('widget.PDFPrintWindow', {
				url: CPATH+'/agb/agb110rkrPrint.do',
				prgID: 'agb110rkr',
				extParam: param
			});
			win.center();
			win.show();*/   				
		}
		
		
	});
};


</script>
