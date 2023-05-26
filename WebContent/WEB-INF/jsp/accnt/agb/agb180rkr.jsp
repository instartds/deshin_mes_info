<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="agb180rkr"  >

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
	var sPendCode  = ''; /* 레포트용 */
	var sPendName  = ''; /* 레포트용 */	
	
	var panelSearch = Unilite.createSearchForm('agb180rkrForm', {
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
	Unilite.popup('MANAGE',{
				itemId :'MANAGE',
				fieldLabel: '관리항목',
				allowBlank:false,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							/**
							 * 관리항목 팝업을 작동했을때의 동적 필드 생성(항상 FR과 TO필드 2개를 생성
							 * 해준다..) 생성된 필드가 팝업일시 필드name은 아래와 같음 FR 필드 TO 필드
							 * valueFieldName textFieldName ~ valueFieldName
							 * textFieldName DYNAMIC_CODE_FR, DYNAMIC_NAME_FR ~
							 * DYNAMIC_CODE_TO, DYNAMIC_NAME_TO
							 * --------------------------------------------------------------------------
							 * 생성된 필드가 uniTextfield, uniNumberfield,
							 * uniDatefield일시 필드 name은 아래와 같음 FR 필드 ~ TO 필드
							 * DYNAMIC_CODE_FR ~ DYNAMIC_CODE_TO
							 */
							var param = {AC_CD : panelSearch.getValue('MANAGE_CODE')};
							accntCommonService.fnGetAcCode(param, function(provider, response)	{
								var dataMap = provider;
								UniAccnt.changeFields(panelSearch, dataMap, '');
																
								sPendCode  = provider.AC_NAME; 
								sPendName  = provider.AC_NAME + '명'; 
							});
						},			
						scope: this
					},
					applyextparam: function(popup){							
						
					}
				}
			}),{
			  	xtype: 'container',
			  	colspan:  2,
			  	itemId: 'formFieldArea1', 
			  	layout: {
			   		type: 'table', 
			   		columns:1,
			   		itemCls:'table_td_in_uniTable',
			   		tdAttrs: {
			    		width: 350
			   		}
		  		}
			 },
				Unilite.popup('ACCNT',{ 
			    	fieldLabel: '계정과목', 
			    	valueFieldName: 'ACCNT_CODE_FR',
					textFieldName: 'ACCNT_NAME_FR',
					autoPopup:false,
					autoPopup:true,
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
					autoPopup:false,
					autoPopup:true,
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
	{ 
		fieldLabel: '당기시작년월',
		colspan: 4,
		name: 'START_DATE',
        xtype: 'uniMonthfield',
        readOnly:false,
        width:250
     },{
			xtype: 'radiogroup',		            		
			fieldLabel: '과목명',	
			id:'accountNameSe',
			items: [{
				boxLabel: '과목명1', 
				width: 70, 
				name: 'ACCOUNT_NAME',
				inputValue: '0'
			},{
				boxLabel : '과목명2', 
				width: 70,
				name: 'ACCOUNT_NAME',
				inputValue: '1'
			},{
				boxLabel: '과목명3', 
				width: 70, 
				name: 'ACCOUNT_NAME',
				inputValue: '2' 
			}]		
		},{
    		xtype: 'uniCheckboxgroup',		            		
    		fieldLabel: '출력조건',
    		colspan: 4,
    		items: [{
    			boxLabel: '관리항목명칭별 페이지 처리',
    			width: 200,
    			name: 'CHECK',
    			inputValue: 'A',
    			uncheckedValue: 'B'
    		}]
        },{
				xtype: 'radiogroup',		            		
				fieldLabel: '거래합계',
				id:'printKind',
				items: [{
					boxLabel: '미출력', 
					width: 70, 
					name: 'SUM',
					inputValue: '1'
				},{
					boxLabel : '출력', 
					width: 70,
					name: 'SUM',
					inputValue: '2'
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
	 
		id : 'agb180rkrApp',
		fnInitBinding : function(params) {
			panelSearch.setValue('ACCNT_DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('FR_DATE',UniDate.get('startOfMonth'));
			panelSearch.setValue('TO_DATE',UniDate.get('today'));
			panelSearch.setValue('START_DATE',getStDt[0].STDT);
			
			if(!Ext.isEmpty(params.FR_DATE)){
                this.processParams(params);
            }			
			
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}	
		},
        // 링크로 넘어오는 params 받는 부분
		processParams: function(params) {
			this.uniOpt.appParams = params;
        	// agb180skr.jsp(관리항목별집계표)에서 링크걸려옴
            panelSearch.setValue('FR_DATE', params.FR_DATE),
            panelSearch.setValue('TO_DATE', params.TO_DATE),
            panelSearch.setValue('START_DATE', params.START_DATE),
            panelSearch.setValue('ACCNT_DIV_CODE', params.ACCNT_DIV_CODE),
            panelSearch.getField('SUM').setValue(params.SUM),       
            panelSearch.getField('CHECK').setValue(params.CHECK),
			panelSearch.setValue('MANAGE_CODE',params.MANAGE_CODE);
			panelSearch.setValue('MANAGE_NAME',params.MANAGE_NAME);  
			
				var param = {AC_CD : panelSearch.getValue('MANAGE_CODE')};
				accntCommonService.fnGetAcCode(param, function(provider, response)	{
					var dataMap = provider;
					UniAccnt.changeFields(panelSearch, dataMap, '');
					
					sPendCode  = provider.AC_NAME; 
					sPendName  = provider.AC_NAME + '명';
					
					panelSearch.setValue('DYNAMIC_CODE_FR',params.DYNAMIC_CODE_FR);
					panelSearch.setValue('DYNAMIC_NAME_FR',params.DYNAMIC_NAME_FR);
					panelSearch.setValue('DYNAMIC_CODE_TO',params.DYNAMIC_CODE_TO);
					panelSearch.setValue('DYNAMIC_NAME_TO',params.DYNAMIC_NAME_TO);					

					panelSearch.setValue('ACCNT_CODE_FR',params.ACCNT_CODE_FR);
					panelSearch.setValue('ACCNT_NAME_FR',params.ACCNT_NAME_FR);
					panelSearch.setValue('ACCNT_CODE_TO',params.ACCNT_CODE_TO);
					panelSearch.setValue('ACCNT_NAME_TO',params.ACCNT_NAME_TO);
					
					panelSearch.getField('ACCOUNT_NAME').setValue(params.ACCOUNT_NAME);	
					
				});	
        },
		onQueryButtonDown : function()	{
		},
		onDetailButtonDown:function() {
		},
		onPrintButtonDown: function() {
			var param= panelSearch.getValues();
			
			param["sTxtValue2_fileTitle"]='부서집계표';	
			
			param.ACCNT_DIV_CODE = panelSearch.getValue('ACCNT_DIV_CODE').join(",");
			param.ACCNT_DIV_NAME = panelSearch.getField('ACCNT_DIV_CODE').getRawValue();
			param.SUM_YN = panelSearch.getValues().SUM;
			param.PEND_CODE = sPendCode
			param.PEND_NAME = sPendName	
			
			var reportGubun = panelSearch.getValues().CHECK;
			
			if(Ext.isEmpty(reportGubun) || reportGubun == 'A'){
				var win = Ext.create('widget.ClipReport', {
					url: CPATH+'/accnt/agb180clrkr.do',
					prgID: 'agb180rkr',
					extParam: param
				});
			}
			if(Ext.isEmpty(reportGubun) || reportGubun == 'B'){
					var win = Ext.create('widget.ClipReport', {
						url: CPATH+'/accnt/agb181clrkr.do',
						prgID: 'agb180rkr',
						extParam: param
					});
				}	
			
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
