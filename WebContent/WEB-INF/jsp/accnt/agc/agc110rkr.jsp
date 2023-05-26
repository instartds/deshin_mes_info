<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="agc110rkr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B004" /> <!-- 화폐유형-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

var getStDt	= ${getStDt};			//당기시작월 관련 전역변수

function appMain() {   
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
				xtype: 'radiogroup',
				id:'QUERY_TYPE',
				fieldLabel: '보고서유형',	
				items: [{
					boxLabel: '판매비와관리비', 
					width: 110, 
					name: 'QUERY_TYPE',
					inputValue: '1'
				},{
					boxLabel : '제조경비', 
					width: 90,
					name: 'QUERY_TYPE',
					inputValue: '2'
				},{
					boxLabel: '용역경비', 
					width: 90, 
					name: 'QUERY_TYPE',
					inputValue: '3' 
				},{
					boxLabel: '용역경비2', 
					width: 90, 
					name: 'QUERY_TYPE',
					inputValue: '4' 
				}]
			},{
		 		fieldLabel: '기준년도',
		 		xtype: 'uniYearField',
		 		name: 'START_DATE',
		 		allowBlank:false,
		 		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
					}
				}
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
			Unilite.popup('DEPT',{ 
		    	fieldLabel: '부서',   
		    	popupWidth: 325,
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
				popupWidth: 325,
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
			}),Unilite.popup('PJT',{ 
		    	fieldLabel: '프로젝트',  
		    	popupWidth: 325,
		    	valueFieldName: 'PJT_CODE',
				textFieldName: 'PJT_NAME'
			}),{
				xtype: 'radiogroup',		            		
				fieldLabel: '과목구분',
				//id: 'ACCOUNT_DIVI',
				items: [{
					boxLabel: '과목', 
					width: 70, 
					name: 'ACCOUNT_DIVI',
					inputValue: '1'
				},{
					boxLabel : '세목', 
					width: 70,
					name: 'ACCOUNT_DIVI',
					inputValue: '2'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
					}
				}
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
		fnInitBinding : function(params) {
			panelSearch.setValue('ACCNT_DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('START_DATE', new Date().getFullYear());
			
			UniAppManager.setToolbarButtons('reset',false);
			UniAppManager.setToolbarButtons('print',false);
			
			if(!Ext.isEmpty(params && params.PGM_ID)){
                this.processParams(params);
			}
			else {
				panelSearch.getField('QUERY_TYPE').setValue('1');
				panelSearch.getField('ACCOUNT_DIVI').setValue('1');
				panelSearch.getField('REF_ITEM').setValue('0');
			}
		},
		//링크로 넘어오는 params 받는 부분 
        processParams: function(params) {
            this.uniOpt.appParams = params;
            if(params.PGM_ID == 'agc110skr') {
            	panelSearch.setValue('START_DATE'		,params.START_DATE);
                panelSearch.setValue('ST_DATE'			,params.ST_DATE);
                panelSearch.setValue('ACCNT_DIV_CODE'	,params.ACCNT_DIV_CODE);
                panelSearch.setValue('DEPT_CODE_FR'		,params.DEPT_CODE_FR);
                panelSearch.setValue('DEPT_NAME_FR'		,params.DEPT_NAME_FR);
                panelSearch.setValue('DEPT_CODE_TO'		,params.DEPT_CODE_TO);
                panelSearch.setValue('DEPT_NAME_TO'		,params.DEPT_NAME_TO);
                panelSearch.setValue('PJT_CODE'			,params.PJT_CODE);
                panelSearch.setValue('PJT_NAME'			,params.PJT_NAME);
                panelSearch.getField('ACCOUNT_DIVI'		).setValue(params.ACCOUNT_DIVI.ACCOUNT_DIVI);
                panelSearch.getField('REF_ITEM'			).setValue(params.REF_ITEM.REF_ITEM);
                panelSearch.getField('QUERY_TYPE'		).setValue(params.PAGE_TYPE);
            }
        },
		onQueryButtonDown : function()	{
		},
		onDetailButtonDown:function() {
		},
		onPrintButtonDown: function() {
			if(!panelSearch.getInvalidMessage()) return;    //필수체크
			var param= panelSearch.getValues();
			
            param.PGM_ID = 'agc110rkr';  //프로그램ID
            param.MAIN_CODE = 'A126'; //해당 모듈의 출력정보를 가지고 있는 공통코드
            param.sTxtValue2_fileTitle = '경비명세서';
            
            param.ACCNT_DIV_CODE = panelSearch.getValue('ACCNT_DIV_CODE').join(",");
			param.ACCNT_DIV_NAME = panelSearch.getField('ACCNT_DIV_CODE').getRawValue();
			param.PAGE_TYPE = Ext.getCmp('QUERY_TYPE').getValue().QUERY_TYPE;
			param.MSG_DESC = '합    계';
			param.PAGE_TYPE_NAME = Ext.getCmp('QUERY_TYPE').getChecked()[0].boxLabel;
			
			var reportGubun = '${gsReportGubun}';
			if(Ext.isEmpty(reportGubun) || reportGubun == 'CR'){
				var win = Ext.create('widget.PDFPrintWindow', {
					url: CPATH+'/agc/agc110rkrPrint.do',
					prgID: 'agc110rkr',
					extParam: param
				});
			}
			else {
				var win = Ext.create('widget.ClipReport', {
					url: CPATH+'/accnt/agc110clrkrv.do',
					prgID: 'agc110rkr',
					extParam: param
				});
			}
			win.center();
			win.show();
		}
		
	});
};


</script>
