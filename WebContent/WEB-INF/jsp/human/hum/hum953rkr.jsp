<%@page language="java" contentType="text/html; charset=utf-8" pageEncoding="UTF-8"%>
<t:appConfig pgmId="hum953rkr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
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
	var joinRetrStore = Unilite.createStore('hum953rkrJoin_RetrStore', {
	    fields: ['text', 'value', 'search'],
		data :  [
			        {'text':'재직자'		, 'value':'J'  , search:'재직자J'},
			        {'text':'퇴직자'		, 'value':'R'  , search:'퇴직자R'}
	    		]
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 2},
		padding:'1 1 1 1',
		border:true,
		items: [{
			xtype: 'radiogroup',		            		
			fieldLabel: '출력선택',						            		
			id: 'optPrintGb',
			labelWidth: 90,
			items: [{
				boxLabel: '부서,직위,입사일', 
				width: 150, 
				name: 'optPrintGb',
				inputValue: '1',
				checked: true  
			},{
				boxLabel: '직위,입사일', 
				width: 150, 
				name: 'optPrintGb',
				inputValue: '2'
			},{
				boxLabel: '입사일,직위', 
				width: 150, 
				name: 'optPrintGb',
				inputValue: '3'
			}],
			listeners: {
				/*change: function(field, newValue, oldValue, eOpts) {	
					if(Ext.getCmp('optPrintGb').getChecked()[0].inputValue == '1') {
						Ext.getCmp('PERSON_NUMB').setReadOnly(true);
						Ext.getCmp('DIV_CODE').setReadOnly(true);
						Ext.getCmp('DATE').setReadOnly(true);
					} else {
						Ext.getCmp('PERSON_NUMB').setReadOnly(false);
						Ext.getCmp('DIV_CODE').setReadOnly(false);
						Ext.getCmp('DATE').setReadOnly(false);
					}
				},*/
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
			fieldLabel: '사업장',
			name:'DIV_CODE', 
			id : 'DIV_CODE',
			xtype: 'uniCombobox',
	        //multiSelect: true, 
	        //typeAhead: false,
	        comboType:'BOR120'
			//width: 325,
	        
		},{
	 		fieldLabel: '기준일',
	 		xtype: 'uniDatefield',
	 		name: 'ANN_DATE',
	 		value: UniDate.get('today'),
	 		allowBlank: false
		},
			Unilite.treePopup('DEPTTREE',{
				fieldLabel: '부서',
				valueFieldName:'DEPT',
				textFieldName:'DEPT_NAME' ,
				valuesName:'DEPTS' ,
				DBvalueFieldName:'TREE_CODE',
				DBtextFieldName:'TREE_NAME',
				selectChildren:true,
				textFieldWidth:89,
				validateBlank:true,
				width:300,
				autoPopup:true,
				useLike:true
				/*listeners: {
	                'onValueFieldChange': function(field, newValue, oldValue  ){
	                    	panelResult.setValue('DEPT',newValue);
	                },
	                'onTextFieldChange':  function( field, newValue, oldValue  ){
	                    	panelResult.setValue('DEPT_NAME',newValue);
	                },
	                'onValuesChange':  function( field, records){
	                    	var tagfield = panelResult.getField('DEPTS') ;
	                    	tagfield.setStoreData(records)
	                }
				}*/
		}),{
			fieldLabel: '직위',
			name:'POST_CODE',
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'H005'
		},{
			fieldLabel: '직책',
			name:'ABIL_CODE',
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'H006'
		},{
			fieldLabel: '담당업무',
			name:'JOB_CODE',
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'H008'	
		},{
			fieldLabel: '고용형태',
			name:'EMP_CODE',
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'H011'
		},{
			fieldLabel: '재직형태',
			name:'JOIN_RETR',
			xtype: 'uniCombobox',
			store: Ext.data.StoreManager.lookup('hum953rkrJoin_RetrStore')
		},
		Unilite.popup('Employee',{
			fieldLabel: '사원',
		  	valueFieldName:'PERSON_NUMB',
		    textFieldName:'NAME',
			validateBlank:false,
			autoPopup:true,
			id : 'PERSON_NUMB', 
			listeners: {
				applyextparam: function(popup){	
					popup.setExtParam({'BASE_DT': '00000000'}); 
				}
			}
		}),{
         	xtype:'button',
         	text:'출    력',
         	width:235,
         	tdAttrs:{'align':'left', style:'padding-left:95px'},
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
		id: 'hum953rkrApp',
		fnInitBinding : function() {
			panelResult2.setValue('DIV_CODE', UserInfo.divCode);
			
//			UniAppManager.setToolbarButtons(['print'], false);
			UniAppManager.setToolbarButtons(['query', 'reset', 'newData', 'save', 'print', 'delete'], false);
			
		},
        onPrintButtonDown: function() {
//            var doc_Kind = Ext.getCmp('optPrintGb').getChecked()[0].inputValue;
        	
	        if(!panelResult2.getInvalidMessage()) return;   
			
			var title_Doc = '';
			var prgID1    = 'hum953rkr';
			
	/*		if(doc_Kind == '1' ){
				title_Doc = '부서, 직위, 입사일순'; 
				//prgID1    = 'hum953rkr1';
			}else if(doc_Kind == '2'){
				title_Doc = '직위, 입사일순'; 
				//prgID1 	  = 'hum953rkr2';
			}
			else if(doc_Kind == '3'){
				title_Doc = '입사일,직위순'; 
				//prgID1    = 'hum953rkr3';
			}
			*/
			var param1  = Ext.getCmp('resultForm').getValues();			// 상단 증명서 종류
			var param2 = Ext.getCmp('resultForm2').getValues();			// 하단 검색조건
			
            var list = [].concat(param1, param2);
//			var param = param1.concat(param2);
            var param = panelResult2.getValues();
            param.optPrintGb = panelResult.getValue('optPrintGb').optPrintGb;
//            param.PT_TITLENAME = '사원명부출력';
            
	        var win = Ext.create('widget.CrystalReport', {
	            url: CPATH+'/human/hum953crkr.do',
	            prgID: 'hum953rkr',
                extParam: param
                
                
                
                    
                    
/*	               extParam: {
	               	  DOC_KIND		: Ext.getCmp('optPrintGb').getChecked()[0].inputValue,		 //증명서 종류
	               	  // 부서,직위,입사일 : 1 , 직위,입사일 : 2, 입사일,직위 : 3
	               	  DIV_CODE		: param2.DIV_CODE,	   										 
	               	  DEPT_CODE		: param2.DEPTS, //TEST 필요
	               	  ANN_DATE 		: param2.ANN_DATE,	 
	               	  POST_CODE     : param2.POST_CODE,
	               	  ABIL_CODE		: param2.ABIL_CODE,
	               	  JOB_CODE      : param2.JOB_CODE,
	               	  EMP_CODE      : param2.EMP_CODE,
	               	  JOIN_RETR     : param2.JOIN_RETR,
	                  PERSON_NUMB  	: param2.PERSON_NUMB,  										 
	                  COMP_CODE     : UserInfo.compCode,	  									 
	                  // 레포트로 파라미터 넘기기 매개변수 (조회와 관련 없음)
	                  SUB_TITLE         : title_Doc
	               }*/
	            });
	            
	            win.center();
	            win.show();
	            
//	            win.items.map.configForm.getField('PT_TITLENAME').setValue("안녕");
//                win.configForm.setValue('PT_TITLENAME',param.PT_TITLENAME);
	    }
	}); //End of 	Unilite.Main( {
};

</script>
