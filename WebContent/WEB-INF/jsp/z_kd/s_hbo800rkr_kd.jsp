<%@page language="java" contentType="text/html; charset=utf-8" pageEncoding="UTF-8"%>
<t:appConfig pgmId="s_hbo800rkr_kd"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="H005"/>	<!-- 직위 -->
	<t:ExtComboStore comboType="AU" comboCode="H006"/>	<!-- 직책 -->
	<t:ExtComboStore comboType="AU" comboCode="H008"/>	<!-- 담당업무 -->
	<t:ExtComboStore comboType="AU" comboCode="H011"/>	<!-- 고용형태 -->
	<t:ExtComboStore comboType="AU" comboCode="H032" opts='2;3;4;5' /> <!-- 지급구분 -->
	<t:ExtComboStore items="${COST_POOL_LIST}" storeId="costPoolCombo" /> <!--창고-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

var costPool = '${COST_POOL}'; // 증명번호 마지막 번호
if(!costPool){
	costPool ='Cost Pool';
}

function appMain() {
	var joinRetrStore = Unilite.createStore('s_hbo800rkr_kdJoin_RetrStore', {
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
		items: [{
			xtype: 'radiogroup',		            		
			fieldLabel: '출력선택',						            		
			id: 'optPrintGb',
			labelWidth: 90,
			items: [{
				boxLabel: '명세서', 
				width: 150, 
				name: 'optPrintGb',
				checked: true, 
				inputValue: '4'
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
			fieldLabel	: '지급년월',
			xtype		: 'uniMonthfield',
    		value		: UniDate.get('today'),
			name		: 'PAY_YYYYMM',                    
			id			: 'PAY_YYYYMM',
			allowBlank	: false
		},{
			fieldLabel	: '상여구분',
			name		: 'PROV_TYPE',
			id			: 'PROV_TYPE',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'H032',
			value		: '2',
	        tdAttrs		: {width: 300},  
			allowBlank	: false				
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
	    }),{
			fieldLabel	: '급여지급방식',
			name		: 'PAY_CODE', 
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'H028',
			allowBlank	: true
		},{
			fieldLabel	: '지급차수',
			name		: 'PAY_PROV_FLAG', 
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'H031',  
			allowBlank	: true
		},{
            fieldLabel	: '고용형태',
            xtype		: 'uniCombobox', 
            name		: 'PAY_GUBUN', 	
            comboType	: 'AU',
            comboCode	: 'H011',
		    listeners	: {
		    	change: function(field, newValue, oldValue, eOpts) {      
		    		panelResult.setValue('PAY_GUBUN', newValue);
		    	}
     		}
        },{
			fieldLabel	: '사원구분',
			name		: 'EMPLOY_TYPE', 
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'H024',
			allowBlank	: true
		},{
			fieldLabel: '사원그룹',
			name: 'EMPLOY_GROUP', 
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'H181'
		},{
			fieldLabel: '직렬',
			name: 'AFFIL_CODE',
			id: 'AFFIL_CODE',
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'H173'
		},Unilite.popup('Employee',{
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
		 	fieldLabel: '적요사항',
		 	xtype: 'textareafield',
		 	name: 'REMARK',
		 	height : 40,
		 	hidden : true,
		 	width: 325
		},
		{
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
		id: 's_hbo800rkr_kdApp',
		fnInitBinding : function() {
			panelResult2.setValue('DIV_CODE', UserInfo.divCode);
			
			UniAppManager.setToolbarButtons(['print'], false);
			UniAppManager.setToolbarButtons(['query', 'reset', 'newData', 'save', 'detail', 'delete'], false);
			
		},
        onPrintButtonDown: function() {
        	
	        if(!panelResult2.getInvalidMessage()) return;   
	        var doc_Kind = Ext.getCmp('optPrintGb').getChecked()[0].inputValue;

			/*if(doc_Kind == '1' ){
				strType='1';
			}else if(doc_Kind == '2'){
				strType='2';
			}
			else if(doc_Kind == '3'){
				strType='1';
			}
			else if(doc_Kind == '4'){
				strType='1';
			}*/
			
			var param  = Ext.getCmp('resultForm').getValues();			// 상단 증명서 종류
			var param2 = Ext.getCmp('resultForm2').getValues();			// 하단 검색조건
			
			param.strType   = '1';
			param.DOC_KIND  = Ext.getCmp('optPrintGb').getChecked()[0].inputValue;
			
			param.DIV_CODE      = param2.DIV_CODE;
			
			param.FR_DEPT_CODE  = param2.FR_DEPT_CODE;
			param.TO_DEPT_CODE  = param2.TO_DEPT_CODE;
			
			param.PAY_CODE     	= param2.PAY_CODE;
			param.PAY_PROV_FLAG = param2.PAY_PROV_FLAG;
			
			param.PAY_GUBUN     = param2.PAY_GUBUN;
			param.EMPLOY_TYPE   = param2.EMPLOY_TYPE;
			
			param.EMPLOY_GROUP  = param2.EMPLOY_GROUP;
			param.AFFIL_CODE    = param2.AFFIL_CODE;
			
			param.PERSON_NUMB   = param2.PERSON_NUMB;
			
			param.stryymm       = param2.PAY_YYYYMM;
			param.PAY_YYYYMM    = param2.PAY_YYYYMM;
			param.PROV_TYPE     = param2.PROV_TYPE;
			
			param.format_i = '0';
			
/*			if (param2.REMARK == ''){
				param.REMARK = '@';
			}else {
				param.REMARK = param2.REMARK;
			}*/
			
			
            //Ext.getBody().mask("Loading...");
            //s_hbo800rkr_kdService.initPrintData(param, function(){
            	//Ext.getBody().unmask();
		        var win = Ext.create('widget.CrystalReport', {
		            url: CPATH+'/z_kd/s_hbo800crkr_kd.do',
		            prgID: 's_hbo800crkr_kd',
		            extParam: param
		        });
		        win.center();
		        win.show();		
            //});
			
/*	        var win = Ext.create('widget.PDFPrintWindow', {
	            url: CPATH+'/hbo/hbo800rkrPrint.do',
	            prgID: prgID1,
	            extParam: param2
	            });
	            win.center();
	            win.show();*/
	            
	    }
	}); //End of 	Unilite.Main( {
};

</script>
