<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="agc100rkr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A093" /> <!-- 재무제표양식차수-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

var getStDt = ${getStDt};


function appMain() {   
	var panelSearch = Unilite.createSearchForm('agc100rkrForm', {
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
			fieldLabel: '기준일',
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
			colspan:2
			
		},{
			fieldLabel: '당기시작년월',
			xtype: 'uniMonthfield',
			name: 'ST_DATE',
			allowBlank:false
		},{
			fieldLabel: '재무제표양식차수',
			name:'FORM_DIVISION', 
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'A093',
			value : '01',
			allowBlank:false
		},{
		xtype: 'radiogroup',		            		
		fieldLabel: '과목명',
		items: [{
			boxLabel: '과목명1', 
			width: 70, 
			name: 'REF_ITEM',
			inputValue: '0'
		},{
			boxLabel : '과목명2', 
			width: 70,
			name: 'REF_ITEM',
			inputValue: '1'
		},{
			boxLabel: '과목명3', 
			width: 70, 
			name: 'REF_ITEM',
			inputValue: '2' 
		}]
		},{
			xtype: 'radiogroup',		            		
			fieldLabel: '과목구분',	      
			id:'rdoSubjectDiviS',
			items: [{
				boxLabel: '과목', 
				width: 70, 
				name: 'SUB_JECT_DIVI',
				inputValue: '1'
			},{
				boxLabel : '세목', 
				width: 70,
				name: 'SUB_JECT_DIVI',
				inputValue: '2'
			}]
		},{
			xtype: 'radiogroup',		            		
			fieldLabel: '잔액계산기준',
			items: [{
				boxLabel: '잔액별 잔액', 
				width: 85, 
				name: 'CALC_JAN_AMT',
				inputValue: '1'
			},{
				boxLabel : '잔액별 합계', 
				width: 85,
				name: 'CALC_JAN_AMT',
				inputValue: '2'
			}]
		},
		{
    		xtype: 'radiogroup',		            		
    		fieldLabel: '당월포함여부',
    		id: 'radio4',
    		hidden:true,
    		items: [{
    			boxLabel: '포함' , width: 82, name: 'MON_ICD_YN', inputValue: '1'
    		}, {
    			boxLabel: '미포함' , width: 82, name: 'MON_ICD_YN', inputValue: '2'
    		}]
      },{
    		xtype: 'radiogroup',		            		
    		fieldLabel: '페이지설정',
    		id: 'radio5',
    		hidden:true,
    		items: [{
    			boxLabel: '세로' , width: 82, name: 'PG_LW', inputValue: '1',checked: true
    		}, {
    			boxLabel: '가로' , width: 82, name: 'PG_LW', inputValue: '2'
    		}]
      },{
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
	 
		id : 'agc100rkrApp',
		fnInitBinding : function(params) {
			panelSearch.setValue('ST_DATE',getStDt[0].STDT);
			panelSearch.setValue('ACCNT_DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('FR_DATE', UniDate.get('startOfMonth'));
			panelSearch.setValue('TO_DATE', UniDate.get('today'));
			
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			
			if(!Ext.isEmpty(params && params.PGM_ID)){
                this.processParams(params);
			}
			else {
				panelSearch.getField('SUB_JECT_DIVI').setValue('1');
				panelSearch.getField('CALC_JAN_AMT').setValue('1');
				panelSearch.getField('REF_ITEM').setValue('0');
				panelSearch.getField('MON_ICD_YN').setValue('1');
			}
		},
		//링크로 넘어오는 params 받는 부분 
        processParams: function(params) {
            this.uniOpt.appParams = params;
            if(params.PGM_ID == 'agc100skr') {
            	panelSearch.setValue('FR_DATE'			,params.FR_DATE);
                panelSearch.setValue('TO_DATE'			,params.TO_DATE);
                panelSearch.setValue('ACCNT_DIV_CODE'	,params.DIV_CODE);
                panelSearch.setValue('ST_DATE'			,params.ST_DATE);
                panelSearch.setValue('FORM_DIVISION'	,params.FORM_DIVISION);
                panelSearch.getField('SUB_JECT_DIVI'	).setValue(params.SUB_JECT_DIVI.SUB_JECT_DIVI);
                panelSearch.getField('CALC_JAN_AMT'		).setValue(params.CALC_JAN_AMT.CALC_JAN_AMT);
                panelSearch.getField('REF_ITEM'			).setValue(params.REF_ITEM.REF_ITEM);
                panelSearch.getField('MON_ICD_YN'		).setValue(params.MON_ICD_YN);
                //panelSearch.setValue('ZERO_ACCOUNT',params.ZERO_ACCOUNT);
            }
        },
		onQueryButtonDown : function()	{
		},
		onDetailButtonDown:function() {
		},
		onPrintButtonDown: function() {
			
			if(!panelSearch.getInvalidMessage()) return;    //필수체크
			var param= panelSearch.getValues();
			
            param.PGM_ID = 'agc100rkr';  //프로그램ID
            param.MAIN_CODE = 'A126'; //해당 모듈의 출력정보를 가지고 있는 공통코드
            param.sTxtValue2_fileTitle = '합계잔액시산표';
            
            param.ACCNT_DIV_CODE = panelSearch.getValue('ACCNT_DIV_CODE').join(",");
			param.ACCNT_DIV_NAME = panelSearch.getField('ACCNT_DIV_CODE').getRawValue();
			param.PAGE_TYPE = Ext.getCmp('radio4').getValue().MON_ICD_YN;
			param.ZERO_ACCOUNT = 'N';
			param.MSG_DESC = '합    계';
			
			var reportGubun = '${gsReportGubun}';
			if(Ext.isEmpty(reportGubun) || reportGubun == 'CR'){
				var win = Ext.create('widget.CrystalReport', {
					url: CPATH+'/Accnt/agc100crkr.do',
					prgID: 'agc100crkr',
					extParam: param
				});
			}
			else {
				var win = Ext.create('widget.ClipReport', {
					url: CPATH+'/accnt/agc100clrkrv.do',
					prgID: 'agc100rkr',
					extParam: param
				});
			}
			win.center();
			win.show();
		}
		
	});
};


</script>
