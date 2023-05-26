<%@page language="java" contentType="text/html; charset=utf-8" pageEncoding="UTF-8"%>
<t:appConfig pgmId="s_hat530rkr_hs"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >


function appMain() {

	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 2},
		padding:'1 1 1 1',
		items: [{
			xtype: 'hiddenfield',		            		
			fieldLabel: '<t:message code="system.label.human.printselection" default="출력선택"/>',						            		
			id: 'optPrintGb',
			labelWidth: 90,
			
			items: [{
				boxLabel: '<t:message code="system.label.human.bypersondutyinfo" default="개인별 일근태현황"/>', 
				width: 150, 
				name: 'optPrintGb',
				inputValue: '1',
				checked: true  
			},{
				boxLabel: '<t:message code="system.label.human.bydeptdutyinfo" default="부서별 일근태현황"/>', 
				width: 150, 
				name: 'optPrintGb',
				inputValue: '2'
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
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'west',
		layout : {type : 'uniTable', columns : 1},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel: '<t:message code="system.label.human.dutydate" default="근태일"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'DUTY_DATE_FR',
			endFieldName: 'DUTY_DATE_TO',
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today'),
			allowBlank:false
	     },{
			fieldLabel: '<t:message code="system.label.human.division" default="사업장"/>',
			name:'DIV_CODE', 
			id : 'DIV_CODE',
			xtype: 'uniCombobox',
			allowBlank	: false,
	        //multiSelect: true, 
	        //typeAhead: false,
	        comboType:'BOR120'
			//width: 325,
	        
		}
		,Unilite.popup('DEPT',{
	        fieldLabel: '<t:message code="system.label.human.department" default="부서"/>',
		    valueFieldName:'FR_DEPT_CODE',
		    textFieldName:'FR_DEPT_NAME',
		    itemId:'FR_DEPT_CODE',
			autoPopup: true,
            listeners: {
//                  onSelected: {
//                      fn: function(records, type) {
//                          panelResult.setValue('PERSON_NUMB', panelSearch.getValue('PERSON_NUMB'));
//                          panelResult.setValue('NAME', panelSearch.getValue('NAME'));
//                      },
//                      scope: this
//                  },
                    onClear: function(type) {
                        panelResult2.setValue('FR_DEPT_CODE', '');
                        panelResult2.setValue('FR_DEPT_NAME', '');
                    }
            }
	    }),Unilite.popup('DEPT',{
		        fieldLabel: '~',
		        itemId:'TO_DEPT_CODE',
			    valueFieldName:'TO_DEPT_CODE',
			    textFieldName:'TO_DEPT_NAME',
				autoPopup: true,
            listeners: {
//                  onSelected: {
//                      fn: function(records, type) {
//                          panelResult.setValue('PERSON_NUMB', panelSearch.getValue('PERSON_NUMB'));
//                          panelResult.setValue('NAME', panelSearch.getValue('NAME'));
//                      },
//                      scope: this
//                  },
                    onClear: function(type) {
                        panelResult2.setValue('TO_DEPT_CODE', '');
                        panelResult2.setValue('TO_DEPT_NAME', '');
                    }
            }
	    }),{
			fieldLabel	: '<t:message code="system.label.human.paymethodcode" default="급여지급방식"/>',
			name		: 'PAY_CODE', 
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'H028',
			allowBlank	: true
		},{
			fieldLabel	: '<t:message code="system.label.human.payprovflag2" default="지급차수"/>',
			name		: 'PAY_PROV_FLAG', 
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'H031',  
			allowBlank	: true
		},{
            fieldLabel	: '<t:message code="system.label.human.paygubun" default="고용형태"/>',
            xtype		: 'uniCombobox', 
            name		: 'PAY_GUBUN', 	
            comboType	: 'AU',
            comboCode	: 'H011',
		    listeners	: {
		    	change: function(field, newValue, oldValue, eOpts) {      
		    		panelResult.setValue('PAY_GUBUN', newValue);
		    	}
     		}
        },Unilite.popup('Employee',{
			fieldLabel: '<t:message code="system.label.human.employee" default="사원"/>',
		  	valueFieldName:'PERSON_NUMB',
		    textFieldName:'NAME',
			validateBlank:false,
			autoPopup:true,
			id : 'PERSON_NUMB', 
			listeners: {
				applyextparam: function(popup){	
					popup.setExtParam({'BASE_DT': '00000000'}); 
				},
				onClear: function(type) {
                        panelResult2.setValue('PERSON_NUMB', '');
                        panelResult2.setValue('NAME', '');
                }
			}
		}),{
         	xtype:'button',
         	text:'<t:message code="system.label.human.print" default="출력"/>',
         	width:235,
         	tdAttrs:{'align':'center', style:'padding-left:95px'},
         	handler:function()	{
         		UniAppManager.app.onPrintButtonDown();
         	}
     }]
	});		
	
	Unilite.Main({
	 	border: false,
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				panelResult, panelResult2
			]	
		}		
		], 
		id: 's_hat530rkr_hsApp',
		fnInitBinding : function() {
			panelResult2.setValue('DIV_CODE', UserInfo.divCode);
			
			UniAppManager.setToolbarButtons(['print'], false);
			UniAppManager.setToolbarButtons(['query', 'reset', 'newData', 'save', 'detail', 'delete'], false);
			
		},
        onPrintButtonDown: function() {
        	
        	//			var param2 = Ext.getCmp('resultForm2').getValues();			// 하단 검색조건
        	
	       var form	= panelFileDown;
					var param	= Ext.getCmp('resultForm2').getValues();
					form.submit({
						params	: param,
						success	: function() {
//									Ext.getCmp('bpr130ukrvApp').unmask();
						},
						failure: function(form, action){
//									Ext.getCmp('bpr130ukrvApp').unmask();
						}
					});
	            
	    }
	}); //End of 	Unilite.Main( {
	
		var panelFileDown = Unilite.createForm('FileDownForm', {
		url				: CPATH + '/z_hs/s_hat530rkr_hsExcelDownLoad.do',
		layout			: {type: 'uniTable', columns: 1},
		disabled		: false,
		autoScroll		: false,
		standardSubmit	: true,  
		items			: []
	});
};

</script>
