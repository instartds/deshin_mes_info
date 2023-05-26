<%@page language="java" contentType="text/html; charset=utf-8" pageEncoding="UTF-8"%>
<t:appConfig pgmId="s_hat531rkr_yg"  >
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
			xtype: 'radiogroup',		            		
			fieldLabel: '출력선택',						            		
			id: 'optPrintGb',
			labelWidth: 90,
			items: [{
				boxLabel: '개인별 일근태현황', 
				width: 150, 
				name: 'optPrintGb',
				inputValue: '1',
				checked: true  
			},{
				boxLabel: '부서별 일근태현황', 
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
			fieldLabel: '근태일자',
			xtype: 'uniDateRangefield',
			startFieldName: 'DUTY_DATE_FR',
			endFieldName: 'DUTY_DATE_TO',
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today'),
			allowBlank:false
	     },{
			fieldLabel: '사업장',
			name:'DIV_CODE', 
			id : 'DIV_CODE',
			xtype: 'uniCombobox',
	        //multiSelect: true, 
	        //typeAhead: false,
	        comboType:'BOR120'
			//width: 325,
	        
		}
		,Unilite.popup('DEPT',{
	        fieldLabel: '부서',
		    valueFieldName:'FR_DEPT_CODE',
		    textFieldName:'FR_DEPT_NAME',
		    itemId:'FR_DEPT_CODE',
			autoPopup: true
	    }),Unilite.popup('DEPT',{
		        fieldLabel: '~',
		        itemId:'TO_DEPT_CODE',
			    valueFieldName:'TO_DEPT_CODE',
			    textFieldName:'TO_DEPT_NAME',
				autoPopup: true
	    }),Unilite.popup('Employee',{
			fieldLabel		: '사원',
		  	valueFieldName	: 'PERSON_NUMB',
			textFieldName	: 'NAME',
			validateBlank	: false,
			autoPopup		: true,
			listeners: {
				onValueFieldChange: function(field, newValue){
				},
				onTextFieldChange: function(field, newValue){
				}
			}
		})
		,{
                xtype: 'radiogroup',    
                fieldLabel: '비정규직 포함', 
                labelWidth: 90,
                items: [{
                    boxLabel: '한다', 
                    width: 50, 
                    name: 'PAY_GUBUN',
                    inputValue: 'Y',
                    checked: true  
                },{
                    boxLabel: '안한다',  
                    width: 70, 
                    name: 'PAY_GUBUN',
                    inputValue: 'N'
                }]
            }
		,{
         	xtype:'button',
         	text:'출    력',
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
		id: 's_hat531rkr_ygApp',
		fnInitBinding : function() {
			panelResult2.setValue('DIV_CODE', UserInfo.divCode);
			
			UniAppManager.setToolbarButtons(['print'], false);
			UniAppManager.setToolbarButtons(['query', 'reset', 'newData', 'save', 'detail', 'delete'], false);
			
		},
        onPrintButtonDown: function() {
        	
/*	        if(!panelResult2.getInvalidMessage()) return;   
	        var doc_Kind = Ext.getCmp('optPrintGb').getChecked()[0].inputValue;
			var title_Doc = '';
			var prgID1    = 'Shat530rkr';
			if(doc_Kind == '1' ){
				title_Doc = Msg.sMHT0081; 
			}else if(doc_Kind == '2'){
				title_Doc = Msg.sMHT0082; 
			}*/
			//var param  = Ext.getCmp('resultForm').getValues();			// 상단 증명서 종류
			var param = Ext.getCmp('resultForm2').getValues();			// 하단 검색조건
			/*param2.SUB_TITLE = title_Doc;
			param2.DOC_KIND = Ext.getCmp('optPrintGb').getChecked()[0].inputValue;
			*/
			
/*	        var win = Ext.create('widget.PDFPrintWindow', {
	            url: CPATH+'/z_yg/hat530rkrPrint.do',
	            prgID: prgID1,
	            extParam: param2
	            });*/
			
			var win = Ext.create('widget.CrystalReport', {
                url: CPATH+'/z_yg/s_hat531crkr_yg.do',
                prgID: 's_hat531crkr_yg',
                extParam: {
                          
                          DIV_CODE      : param.DIV_CODE,
                          DUTY_DATE_FR       : param.DUTY_DATE_FR,
                          DUTY_DATE_TO       : param.DUTY_DATE_TO,
                          FR_DEPT_CODE    : param.FR_DEPT_CODE,
                          TO_DEPT_CODE   : param.TO_DEPT_CODE,
                          PERSON_NUMB         : param.PERSON_NUMB,
                          PAY_GUBUN      : param.PAY_GUBUN
                          
                       }
            });
	            
	        win.center();
	        win.show();
	    }
	}); //End of 	Unilite.Main( {
};

</script>
