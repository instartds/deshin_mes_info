<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="hum962rkr"  >
	<t:ExtComboStore comboType="BOR120"  /> 						<!-- 사업장 -->   
	<t:ExtComboStore comboType="BOR120"  comboCode="BILL" />		<!-- 신고사업장 -->
</t:appConfig>

<script type="text/javascript" >

//var gsUserDept = '${deptData}';
var sRefConfig = '${sRefConfig}';
var gsRepreName = '${gsRepreName}'
function appMain() {
	/*
	 * combobox 정의
	 */
//	var gsDED_TYPE;
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchForm('hum962rkrForm', {
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
	    items :[
	   {
			fieldLabel: '사업장',
			id: 'DIV_CODE', 
			name: 'DIV_CODE', 
			xtype: 'uniCombobox',
			comboType: 'BOR120'
			//allowBlank: false
		},Unilite.popup('DEPT',{
		        fieldLabel: '부서',
			    valueFieldName:'DEPT_CODE_FR',
			    textFieldName:'DEPT_NAME_FR',
			    itemId:'DEPT_CODE_FR',
    			autoPopup: true
	    }),Unilite.popup('DEPT',{
		        fieldLabel: '~',
		        itemId:'DEPT_CODE_TO',
			    valueFieldName:'DEPT_CODE_TO',
			    textFieldName:'DEPT_NAME_TO',
    			autoPopup: true
	    }),{
			fieldLabel: '직위',
			name:'POST_CODE',
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'H005'
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
		}),
		{
    		xtype: 'radiogroup',		            		
    		fieldLabel: '비정규직포함',
    		id: 'radio1',
    		items: [{
    			boxLabel: ' 한다', width: 100, name: 'PAY_GUBUN', inputValue: 'N'
    		}, {
    			boxLabel: '안한다', width: 100, name: 'PAY_GUBUN', inputValue: 'Y',checked: true
    		}]
		},{
    		xtype: 'radiogroup',		            		
    		fieldLabel: '퇴직자포함',
    		id: 'radio2',
    		items: [{
    			boxLabel: '한다', width: 100, name: 'RETR_YN', inputValue: 'Y'
    		}, {
    			boxLabel: '안한다', width: 100, name: 'RETR_YN', inputValue: 'N',checked: true
    		}]
		},
		{
    		xtype: 'radiogroup',		            		
    		fieldLabel: '별지작성',
    		id: 'radio3',
    		items: [{
    			boxLabel: ' 한다', width: 100, name: 'ADD_YN', inputValue: 'Y'
    		}, {
    			boxLabel: '안한다', width: 100, name: 'ADD_YN', inputValue: 'N',checked: true
    		}]
		},{
    		xtype: 'radiogroup',		            		
    		fieldLabel: '출력양식',
    		id: 'radio4',
    		items: [{
    			boxLabel: '한다', width: 100, name: 'PRINT_TYPE', inputValue: '1'
    		}, {
    			boxLabel: '안한다', width: 100, name: 'PRINT_TYPE', inputValue: '2',checked: true
    		}
    		
    		], 
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {	
//					alert(panelSearch.getValue('PRINT_TYPE'));
					if(panelSearch.getValue('PRINT_TYPE')){
						panelSearch.getField('ADD_YN').setDisabled(false);
						panelSearch.setValue('ADD_YN', "Y");
					}else{
						panelSearch.setValue('ADD_YN', "N");
						panelSearch.getField('ADD_YN').setDisabled(true);
					}
				}
			}
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
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
 
    Unilite.Main( {
		items 	: [ panelSearch],
		id  : 'hum962rkrApp',
		fnInitBinding : function() {
			//panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('reset',false);
			UniAppManager.setToolbarButtons('print',false);
			
			if (sRefConfig=="1"){
				panelSearch.setValue('PRINT_TYPE',"1");
			}else{
				panelSearch.setValue('PRINT_TYPE',"2");
				panelSearch.getField('ADD_YN').setDisabled(true);
			}
			
			
		},
		onQueryButtonDown : function()	{			
			
				/*masterGrid1.getStore().loadStoreRecords();
				var viewLocked = masterGrid1.lockedGrid.getView();
				var viewNormal = masterGrid1.normalGrid.getView();
				console.log("viewLocked : ",viewLocked);
				console.log("viewNormal : ",viewNormal);
			    viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			    viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
			    viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			    viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);*/				
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		},
		onPrintButtonDown: function() {
			if(!panelSearch.getInvalidMessage()) return;   
			var param= panelSearch.getValues();
			param["DIV_NAME"]=panelSearch.getField('DIV_CODE').getRawValue();
			param["REPRE_NAME"] = gsRepreName;
//			param["TITLE_NAME"]=panelSearch.getField('MEDIUM_TYPE').getRawValue();
//			param["PGM_ID"]='hum962rkr';
			var win = Ext.create('widget.PDFPrintWindow', {
				url: CPATH+'/human/hum962rkrPrint.do',
				prgID: 'hum962rkr',
				extParam: param
			});
			win.center();
			win.show();   				
		}
	});

};


</script>
			