<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="agb140rkr"  >

	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->   
	<t:ExtComboStore comboType="AU" comboCode="A011" /> <!-- 입력경로 -->      
	<t:ExtComboStore comboType="AU" comboCode="A014" /> <!-- 승인상태 -->       
	<t:ExtComboStore comboType="AU" comboCode="B001" /> <!--?-->
	<t:ExtComboStore comboType="AU" comboCode="A023" /> <!--결의회계구분-->
	
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

function appMain() {   
	var getStDt = ${getStDt};				/* 당기시작년월 */
	var gsChargeCode = ${getChargeCode};	/* ChargeCode */
	
	var panelSearch = Unilite.createSearchForm('agb140rkrForm', {
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
		items : [
	{ 
	    fieldLabel: '전표일',
		xtype: 'uniDateRangefield',  
		startFieldName: 'FR_DATE',
		endFieldName: 'TO_DATE',
		allowBlank:false,
		width: 315
		
		
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
		listeners: {
			change: function(field, newValue, oldValue, eOpts) {						
				
			}
		}
	},
	Unilite.popup('ACCNT',{
    	fieldLabel: '범위지정',
    	colspan: 1,
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
    	colspan: 1,
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
        validateBlank:false,
        autoPopup:false,
        valueFieldName: 'DEPT_CODE_FR',
		textFieldName: 'DEPT_NAME_FR'
    }),
      	Unilite.popup('DEPT',{
        fieldLabel: '~',
        validateBlank:false,
        autoPopup:false,
        valueFieldName: 'DEPT_CODE_TO',
		textFieldName: 'DEPT_NAME_TO'
    }),
    { 
		fieldLabel: '당기시작년월',
		colspan: 4,
		name: 'START_DATE',
        xtype: 'uniMonthfield',
        readOnly:false,
        width:250
     },{
			xtype: 'radiogroup',		            		
			fieldLabel: '거래합계',
			id:'PANEL_SUM',
			items: [{
				boxLabel: '미출력', 
				width: 90, 
				name: 'SUM',
				inputValue: '1'//,
				//checked: true  
			},{
				boxLabel : '출력', 
				width: 90,
				name: 'SUM',
				inputValue: '2'
			}]
     },{
			xtype: 'radiogroup',		            		
			fieldLabel: '금액기준',
			id:'JAN',
			items: [{
				boxLabel: '발생', 
				width: 90, 
				name: 'JAN',
				inputValue: 'Y'//,
				//checked: true  
			},{
				boxLabel : '잔액', 
				width: 90,
				name: 'JAN',
				inputValue: 'N'
			}]
     },{
			xtype: 'radiogroup',		            		
			fieldLabel: '출력조건',
			items: [{
				boxLabel: '계정잔액1', 
				width: 90, 
				name: 'BOOK_DATA',
				inputValue: '1',
				checked: true  
			},{
				boxLabel : '계정잔액2', 
				width: 90,
				name: 'BOOK_DATA',
				inputValue: '2'
			}]
     },{
			xtype: 'radiogroup',		            		
			fieldLabel: ' ',
			items: [{
				boxLabel: '코드순', 
				width: 90, 
				name: 'CODE',
				inputValue: '1',
				checked: true  
			},{
				boxLabel : '명순', 
				width: 90,
				name: 'CODE',
				inputValue: '2'
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
	 
		id : 'agb140rkrApp',
		fnInitBinding : function(params) {
			panelSearch.setValue('ACCNT_DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('FR_DATE',UniDate.get('startOfMonth'));
			panelSearch.setValue('TO_DATE',UniDate.get('today'));
			UniAppManager.app.fnSetStDate(UniDate.get('startOfMonth'));
		//	panelSearch.setValue('START_DATE',getStDt[0].STDT);
			
			//Ext.getCmp('PANEL_SUM').setValue("1");
			//Ext.getCmp('JAN').setValue("Y");
			
			if(!Ext.isEmpty(params.FR_DATE)){
                this.processParams(params);
            }
		},
        //링크로 넘어오는 params 받는 부분 
        processParams: function(param) {
        	//agb140skr.jsp(계정명세)에서 링크걸려옴
            panelSearch.setValue('FR_DATE', param.FR_DATE),
            panelSearch.setValue('TO_DATE', param.TO_DATE),
            panelSearch.setValue('START_DATE', param.START_DATE),
            panelSearch.setValue('ACCNT_CODE_FR', param.ACCNT_CODE),
            panelSearch.setValue('ACCNT_NAME_FR', param.ACCNT_NAME),
            panelSearch.setValue('ACCNT_CODE_TO', param.ACCNT_CODE),
            panelSearch.setValue('ACCNT_NAME_TO', param.ACCNT_NAME),
            panelSearch.setValue('ACCNT_DIV_CODE', param.DIV_CODE),
            panelSearch.setValue('DEPT_CODE_FR', param.DEPT_CODE_FR),
            panelSearch.setValue('DEPT_CODE_FR', param.DEPT_CODE_TO),
            panelSearch.setValue('DEPT_NAME_TO', param.DEPT_NAME_FR),
            panelSearch.setValue('DEPT_NAME_TO', param.DEPT_NAME_TO),
            Ext.getCmp('PANEL_SUM').setValue(param.PANEL_SUM),
            Ext.getCmp('JAN').setValue(param.JAN)
        },
		onQueryButtonDown : function()	{
		},
		onDetailButtonDown:function() {
		},
		onPrintButtonDown: function() {
			var param= panelSearch.getValues();
			
			param["sTxtValue2_fileTitle"]='계 정 명 세';	
			
			param.ACCNT_DIV_CODE = panelSearch.getValue('ACCNT_DIV_CODE').join(",");
			param.ACCNT_DIV_NAME = panelSearch.getField('ACCNT_DIV_CODE').getRawValue();
			var sumYn = panelSearch.getValues().SUM;
			if(sumYn =='1'){
				param.SUM_YN = 'N';
			}else
			{
				param.SUM_YN = 'Y';
			}
			param.ACCNT_NAME_FR = panelSearch.getValue('ACCNT_NAME_FR');
			param.ACCNT_NAME_TO = panelSearch.getValue('ACCNT_NAME_TO');
			
			var win = Ext.create('widget.ClipReport', {
				url: CPATH+'/accnt/agb140clrkr.do',
				prgID: 'agb140rkr',
				extParam: param
			});
			win.center();
			win.show();   				
		},
		fnSetStDate:function(newValue) {
        	if(newValue == null){
				return false;
			}else{
		    	if(UniDate.getDbDateStr(newValue).substring(0, 6) < (UniDate.getDbDateStr(newValue).substring(0, 4) + UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6))){
					panelSearch.setValue('START_DATE', UniDate.getDbDateStr(newValue).substring(0, 4)-1 + UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6));
				}else{
					panelSearch.setValue('START_DATE', UniDate.getDbDateStr(newValue).substring(0, 4) + UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6));
				}
			}
        }		
		
	});
};


</script>
