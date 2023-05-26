<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<t:appConfig pgmId="agc160rkr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B042" /> <!-- 금액단위-->
	<t:ExtComboStore comboType="AU" comboCode="A093" /> <!-- 재무제표양식차수-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

var fnSetFormTitle = ${fnSetFormTitle};
var BsaCodeInfo =  {
	gsFinancialY: '${gsFinancialY}'
}

function appMain() {
	
	var len = fnSetFormTitle.length; 
	var tabTitle1 ='손익계산서';
	var tabTitle2 ='제조원가명세서';
	var hideTab1  = true;
	var hideTab2  = true;
	
	for(var i=0 ; i < len ; i++) { 
		if(fnSetFormTitle[i].SUB_CODE == '10'){
			if(fnSetFormTitle[i].USE_YN == 'Y'){
				hideTab1 = false;
			}
			tabTitle1 = fnSetFormTitle[i].CODE_NAME;
		}
		if(fnSetFormTitle[i].SUB_CODE == '20'){
			if(fnSetFormTitle[i].USE_YN == 'Y'){
				hideTab2 = false;
			}
			tabTitle2 = fnSetFormTitle[i].CODE_NAME;
		}
	}
	
	var getStDt = ${getStDt};// 당기시작년월
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchForm('resultForm', {		
		region: 'center',
		layout : {type : 'uniTable', columns : 1},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
			xtype: 'radiogroup',
			fieldLabel: '보고서유형',
			name: 'DIVI',
			items: [{
				boxLabel : '손익계산서', 
				width: 110,
				inputValue: '20',
				checked:true
			},{
				boxLabel: '제조원가명세서', 
				width: 130,
				inputValue: '30' 
			}]
		},{
			fieldLabel: '전표일',
			xtype: 'uniDateRangefield',  
			startFieldName: 'DATE_FR',
			endFieldName: 'DATE_TO',
			allowBlank:false,
			width: 315,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
			}
		}, 
		Unilite.popup('AC_PROJECT',{
			fieldLabel: '프로젝트 1',
			allowBlank:false,
			valueFieldName: 'AC_PROJECT_CODE1',
			textFieldName: 'AC_PROJECT_NAME1',
			listeners: {
				onSelected: {
					fn: function(records, type) {
						panelResult.setValue('AC_PROJECT_CODE1', panelSearch.getValue('AC_PROJECT_CODE1'));
						panelResult.setValue('AC_PROJECT_NAME1', panelSearch.getValue('AC_PROJECT_NAME1'));				 																							
					},
					scope: this
				},
				onClear: function(type)	{
					panelResult.setValue('AC_PROJECT_CODE1', '');
					panelResult.setValue('AC_PROJECT_NAME1', '');
				},
				applyextparam: function(popup){							
					//popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
				}
			}
		}),
		Unilite.popup('AC_PROJECT',{
			fieldLabel: '프로젝트 2',
			valueFieldName: 'AC_PROJECT_CODE2',
			textFieldName: 'AC_PROJECT_NAME2',
			listeners: {
				onSelected: {
					fn: function(records, type) {
						panelResult.setValue('AC_PROJECT_CODE2', panelSearch.getValue('AC_PROJECT_CODE2'));
						panelResult.setValue('AC_PROJECT_NAME2', panelSearch.getValue('AC_PROJECT_NAME2'));				 																							
					},
					scope: this
				},
				onClear: function(type)	{
					panelResult.setValue('AC_PROJECT_CODE2', '');
					panelResult.setValue('AC_PROJECT_NAME2', '');
				},
				applyextparam: function(popup){							
					//popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
				}
			}
		}),
		Unilite.popup('AC_PROJECT',{
			fieldLabel: '프로젝트 3',
			valueFieldName: 'AC_PROJECT_CODE3',
			textFieldName: 'AC_PROJECT_NAME3',
			listeners: {
				onSelected: {
					fn: function(records, type) {
						panelResult.setValue('AC_PROJECT_CODE3', panelSearch.getValue('AC_PROJECT_CODE3'));
						panelResult.setValue('AC_PROJECT_NAME3', panelSearch.getValue('AC_PROJECT_NAME3'));				 																							
					},
					scope: this
				},
				onClear: function(type)	{
					panelResult.setValue('AC_PROJECT_CODE3', '');
					panelResult.setValue('AC_PROJECT_NAME3', '');
				},
				applyextparam: function(popup){							
					//popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
				}
			}
		}),
		Unilite.popup('AC_PROJECT',{
			fieldLabel: '프로젝트 4',
			valueFieldName: 'AC_PROJECT_CODE4',
			textFieldName: 'AC_PROJECT_NAME4',
			listeners: {
				onSelected: {
					fn: function(records, type) {
						panelResult.setValue('AC_PROJECT_CODE4', panelSearch.getValue('AC_PROJECT_CODE4'));
						panelResult.setValue('AC_PROJECT_NAME4', panelSearch.getValue('AC_PROJECT_NAME4'));				 																							
					},
					scope: this
				},
				onClear: function(type)	{
					panelResult.setValue('AC_PROJECT_CODE4', '');
					panelResult.setValue('AC_PROJECT_NAME4', '');
				},
				applyextparam: function(popup){							
					//popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
				}
			}
		}),
		Unilite.popup('AC_PROJECT',{
			fieldLabel: '프로젝트 5',
			valueFieldName: 'AC_PROJECT_CODE5',
			textFieldName: 'AC_PROJECT_NAME5',
			listeners: {
				onSelected: {
					fn: function(records, type) {
						panelResult.setValue('AC_PROJECT_CODE5', panelSearch.getValue('AC_PROJECT_CODE5'));
						panelResult.setValue('AC_PROJECT_NAME5', panelSearch.getValue('AC_PROJECT_NAME5'));				 																							
					},
					scope: this
				},
				onClear: function(type)	{
					panelResult.setValue('AC_PROJECT_CODE5', '');
					panelResult.setValue('AC_PROJECT_NAME5', '');
				},
				applyextparam: function(popup){							
					//popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
				}
			}
		}),
		Unilite.popup('AC_PROJECT',{
			fieldLabel: '프로젝트 6',
			valueFieldName: 'AC_PROJECT_CODE6',
			textFieldName: 'AC_PROJECT_NAME6',
			listeners: {
				onSelected: {
					fn: function(records, type) {
						panelResult.setValue('AC_PROJECT_CODE6', panelSearch.getValue('AC_PROJECT_CODE6'));
						panelResult.setValue('AC_PROJECT_NAME6', panelSearch.getValue('AC_PROJECT_NAME6'));				 																							
					},
					scope: this
				},
				onClear: function(type)	{
					panelResult.setValue('AC_PROJECT_CODE6', '');
					panelResult.setValue('AC_PROJECT_NAME6', '');
				},
				applyextparam: function(popup){							
					//popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
				}
			}
		}),{
			fieldLabel: '당기시작년월',
			xtype: 'uniMonthfield',
			name: 'START_DATE',
			allowBlank:false
		},{
			fieldLabel: '금액단위',
			name:'AMT_UNIT', 
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'B042',
			allowBlank:false,
			listeners: {
				afterrender: function(combo) {
					var recordSelected = combo.getStore().getAt(0);                     
					combo.setValue(recordSelected.get('value'));
				}
			}
		},{
			fieldLabel: '재무제표양식차수',
			name:'GUBUN', 
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'A093',
			value: BsaCodeInfo.gsFinancialY,
			allowBlank:false
		},{
			xtype: 'radiogroup',
			fieldLabel: '과목명',
			name: 'ACCOUNT_NAME',
			items: [{
				boxLabel: '과목명1',
				width: 70,
				checked:true,
				inputValue: '1'
			},{
				boxLabel : '과목명2',
				width: 70,
				inputValue: '2'
			},{
				boxLabel: '과목명3',
				width: 70,
				inputValue: '3'
			}]
		},{
			xtype:'button',
			text:'출    력',
			width:235,
			tdAttrs:{'align':'center', style:'padding-left:95px'},
			handler:function()	{
				UniAppManager.app.onPrintButtonDown();
			}
 		}]
	});

	Unilite.Main( {
		border: false,
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				panelSearch
			]
		}],
		id : 'agc160rkrApp',
		fnInitBinding : function(params) {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			UniAppManager.setToolbarButtons('query',false);
			panelSearch.setValue('DATE_FR',UniDate.get('startOfMonth'));
			
			panelSearch.setValue('DATE_TO',UniDate.get('today'));
			
			panelSearch.setValue('START_DATE',getStDt[0].STDT);
			panelSearch.getField('ACCOUNT_NAME').setValue(UserInfo.refItem);
			
			if(params && params.PGM_ID == 'agc160skr') {
				panelSearch.setValue('DATE_FR', params.DATE_FR);
				panelSearch.setValue('DATE_TO', params.DATE_TO);
				panelSearch.setValue('AC_PROJECT_CODE1', params.AC_PROJECT_CODE1);
				panelSearch.setValue('AC_PROJECT_CODE2', params.AC_PROJECT_CODE2);
				panelSearch.setValue('AC_PROJECT_CODE3', params.AC_PROJECT_CODE3);
				panelSearch.setValue('AC_PROJECT_CODE4', params.AC_PROJECT_CODE4);
				panelSearch.setValue('AC_PROJECT_CODE5', params.AC_PROJECT_CODE5);
				panelSearch.setValue('AC_PROJECT_CODE6', params.AC_PROJECT_CODE6);
				panelSearch.setValue('AC_PROJECT_NAME1', params.AC_PROJECT_NAME1);
				panelSearch.setValue('AC_PROJECT_NAME2', params.AC_PROJECT_NAME2);
				panelSearch.setValue('AC_PROJECT_NAME3', params.AC_PROJECT_NAME3);
				panelSearch.setValue('AC_PROJECT_NAME4', params.AC_PROJECT_NAME4);
				panelSearch.setValue('AC_PROJECT_NAME5', params.AC_PROJECT_NAME5);
				panelSearch.setValue('AC_PROJECT_NAME6', params.AC_PROJECT_NAME6);
				panelSearch.setValue('START_DATE', params.START_DATE);
				panelSearch.setValue('AMT_UNIT', params.AMT_UNIT);
				panelSearch.setValue('GUBUN', params.GUBUN);
				panelSearch.setValue('ACCOUNT_NAME', params.ACCOUNT_NAME);
				panelSearch.setValue('DIVI', params.DIVI);
			}
		},
		onQueryButtonDown : function() {
		},
		onDetailButtonDown:function() {
		},
		onPrintButtonDown: function() {
			if(!panelSearch.getInvalidMessage()) return;    //필수체크
			var param = panelSearch.getValues();
			
            param.PGM_ID = 'agc160rkr';  //프로그램ID
            param.MAIN_CODE = 'A126'; //해당 모듈의 출력정보를 가지고 있는 공통코드
            param.sTxtValue2_fileTitle = "프로젝트별재무제표(" + panelSearch.getField('DIVI').getChecked()[0].boxLabel + ")";
            
			param.AC_PROJECT_NAME1 = panelSearch.getValue('AC_PROJECT_NAME1');
			param.AC_PROJECT_NAME2 = panelSearch.getValue('AC_PROJECT_NAME2');
			param.AC_PROJECT_NAME3 = panelSearch.getValue('AC_PROJECT_NAME3');
			param.AC_PROJECT_NAME4 = panelSearch.getValue('AC_PROJECT_NAME4');
			param.AC_PROJECT_NAME5 = panelSearch.getValue('AC_PROJECT_NAME5');
			param.AC_PROJECT_NAME6 = panelSearch.getValue('AC_PROJECT_NAME6');
			
			var reportGubun = '${gsReportGubun}';
			
			if(!Ext.isEmpty(reportGubun) && reportGubun == 'CLIP'){
				agc150skrService.fnCheckExistABA131(param, function(provider, response) {
					if(provider && provider.length > 0) {
						var win = Ext.create('widget.ClipReport', {
							url: CPATH+'/accnt/agc160clrkrv.do',
							prgID: 'agc160rkr',
							extParam: param
						});
						
						win.center();
						win.show();
					}
					else {
						alert('집계항목설정 내역을 적용한 데이터가 존재하지 않습니다.\n회계-기초등록-집계항목설정 메뉴에서 집계항목적용 후 작업하십시오.');
					}
				});
			}
			else {
				alert('출력물이 지정되지 않았습니다. 공통코드 A126을 확인하여 주십시오.');
			}
		},
		fnCheckData:function(newValue){
			var dateFr = panelSearch.getField('DATE_FR').getSubmitValue();  // 전표일 FR
			var dateTo = panelSearch.getField('DATE_TO').getSubmitValue();  // 전표일 TO
			// 전기전표일


			var r= true
			
			if(dateFr > dateTo) {
				alert('시작일이 종료일보다 클수는 없습니다.');
				//당기전표일: 시작일이 종료일보다 클수는 없습니다.
				//alert('<t:message code="unilite.msg.sMAW036"/>' + '<t:message code="unilite.msg.sMB084"/>');
				panelSearch.setValue('DATE_FR',dateFr);
				panelSearch.getField('DATE_FR').focus();
				r = false;
				return false;
			}
			return r;
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