<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="afs510rkr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B004" /> <!-- 화폐유형-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

var BsaCodeInfo =  {
	
};
var getStDt = Ext.isEmpty(${getStDt}) ? []: ${getStDt} ;	
var gsChargeCode  = Ext.isEmpty(${getChargeCode}) ? ['']: ${getChargeCode};   //ChargeCode 관련 전역변수function appMain() {   
	var panelSearch = Unilite.createSearchForm('afs510rkrForm', {
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
			startFieldName: 'FR_DATE',
			endFieldName: 'TO_DATE',
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today'),
			allowBlank:false,
			width: 315,
			
		},{
			fieldLabel: '사업장',
			name:'ACCNT_DIV_CODE', 
			xtype: 'uniCombobox',
	        multiSelect: true, 
	        typeAhead: false,
	        value:UserInfo.divCode,
	        comboType:'BOR120',
			width: 325,
			colspan:2,
        },
        Unilite.popup('ACCNT',{ 
		    fieldLabel: '계정과목', 
		    valueFieldName: 'ACCNT_CODE',
			textFieldName: 'ACCNT_NAME',  
			listeners: {
                applyExtParam:{
                    scope:this,
                    fn:function(popup){
                        var param = {
                            'ADD_QUERY' : "substring(spec_divi,1,1) in ('B','C')",
                            'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
                        }
                        popup.setExtParam(param);
                    }
                }
            }
		}),
		Unilite.popup('BANK',{ 
		    fieldLabel: '은행', 
		    popupWidth: 500,
		     valueFieldName: 'BANK_CODE',
			textFieldName: 'BANK_NAME',
			listeners: {
				onSelected: {
					fn: function(records, type) {
					},
					scope: this
				},
				onClear: function(type)	{
				},
				applyextparam: function(popup){							
					//popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
				}
			}
		}),
		Unilite.popup('BANK_BOOK',{ 
		    fieldLabel: '통장', 
		    popupWidth: 910,
		    valueFieldName: 'FR_BANK_BOOK_CODE',
			textFieldName: 'FR_BANK_BOOK_NAME',
			listeners: {
				onSelected: {
					fn: function(records, type) {
					},
					scope: this
				},
				onClear: function(type)	{
				},
				applyextparam: function(popup){							
				}
			}	   
		}),
		Unilite.popup('BANK_BOOK',{ 
		    fieldLabel: ' ', 
		    popupWidth: 910,
		    valueFieldName: 'TO_BANK_BOOK_CODE',
			textFieldName: 'TO_BANK_BOOK_NAME',
			listeners: {
				onSelected: {
					fn: function(records, type) {
					},
					scope: this
				},
				onClear: function(type)	{
				},
				applyextparam: function(popup){							
				}
			}	   
		}),
		{
	 		fieldLabel: '화폐',
	 		name:'MONEY_UNIT', 
	 		xtype: 'uniCombobox',
	 		comboType:'AU',
	 		comboCode:'B004', 
	 		displayField: 'value',
	 		listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
				}
			}
 		},{
			fieldLabel: '당기시작년월',
 			xtype: 'uniMonthfield',
 			name: 'ST_DATE',
 			allowBlank:false
		},
		Unilite.popup('DEPT',{ 
		    fieldLabel: '부서', 
		    popupWidth: 910,
		    valueFieldName: 'DEPT_CODE_FR',
			textFieldName: 'DEPT_NAME_FR',
			listeners: {
				onSelected: {
					fn: function(records, type) {
					},
					scope: this
				},
				onClear: function(type)	{
				},
				applyextparam: function(popup){							
					//popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
				}
			}	  
		}),
		Unilite.popup('DEPT',{ 
			fieldLabel: '~', 
			popupWidth: 910,
			valueFieldName: 'DEPT_CODE_TO',
			textFieldName: 'DEPT_NAME_TO',
			listeners: {
				onSelected: {
					fn: function(records, type) {
					},
					scope: this
				},
				onClear: function(type)	{
				},
				applyextparam: function(popup){							
					//popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
				}
			}	  
		}),  	
	   	{
     		xtype:'uniCheckboxgroup',fieldLabel:'출력조건',
            items:[{ 
            	name: 'CHK_TERM',
            	xtype:'checkbox',
            	boxLabel: '통장별페이지정리 ',
            	checked:false,
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
	 
		id : 'afs510rkrApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			//당기시작월 세팅
			panelSearch.setValue('ST_DATE',getStDt[0].STDT);
			panelSearch.setValue('AC_DATE_FR',UniDate.get('startOfMonth'));
			panelSearch.setValue('AC_DATE_TO',UniDate.get('today'));
//			CALL fnPrintinit()
//			'Call InitCombo(cParam)
//			Call fnSanction(rsSheet)
			
			UniAppManager.setToolbarButtons('reset',false);
			UniAppManager.setToolbarButtons('print',false);
		},
		onQueryButtonDown : function()	{
		},
		onDetailButtonDown:function() {
		},
		onPrintButtonDown: function() {
			var param= panelSearch.getValues();
			param.ACCNT_DIV_NAME = panelSearch.getField('ACCNT_DIV_CODE').getRawValue();
			var win = Ext.create('widget.PDFPrintWindow', {
				url: CPATH+'/afs/afs510rkrPrint.do',
				prgID: 'afs510rkr',
				extParam: param
				});
			win.center();
			win.show();   				
		}
		
	});
};


</script>
