<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="agc150rkr"  >
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
	var tabTitle1 ='대차대조표';
	var tabTitle2 ='손익계산서';
	var tabTitle3 ='제조원가명세서';
	var hideTab1  = true;
	var hideTab2  = true;
	var hideTab3  = true;
	
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
		if(fnSetFormTitle[i].SUB_CODE == '30'){
			if(fnSetFormTitle[i].USE_YN == 'Y'){
				hideTab3 = false;
			}
			tabTitle3 = fnSetFormTitle[i].CODE_NAME;
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
		},{ 
			fieldLabel: '사업장1',
			name: 'DIV_CODE1',
			xtype: 'uniCombobox',
			multiSelect: true, 
	        typeAhead: false,
	        allowBlank:false,
			comboType: 'BOR120',
			width: 325,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
				}
			}
		},{ 
			fieldLabel: '사업장2',
			name: 'DIV_CODE2',
			xtype: 'uniCombobox',
			multiSelect: true, 
	        typeAhead: false,
			comboType: 'BOR120',
			width: 325,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
				}
			}
		},{ 
			fieldLabel: '사업장3',
			name: 'DIV_CODE3',
			xtype: 'uniCombobox',
			multiSelect: true, 
	        typeAhead: false,
			comboType: 'BOR120',
			width: 325,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
				}
			}
		},{ 
			fieldLabel: '사업장4',
			name: 'DIV_CODE4',
			xtype: 'uniCombobox',
			multiSelect: true, 
	        typeAhead: false,
			comboType: 'BOR120',
			width: 325,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
				}
			}
		},{ 
			fieldLabel: '사업장5',
			name: 'DIV_CODE5',
			xtype: 'uniCombobox',
			multiSelect: true, 
	        typeAhead: false,
			comboType: 'BOR120',
			width: 325,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
				}
			}
		},{ 
			fieldLabel: '사업장6',
			name: 'DIV_CODE6',
			xtype: 'uniCombobox',
			multiSelect: true, 
	        typeAhead: false,
			comboType: 'BOR120',
			width: 325,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
				}
			}
		},{
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
				//name: 'ACCOUNT_NAME',
				checked:true,
				inputValue: '1'
			},{
				boxLabel : '과목명2', 
				width: 70,
				//name: 'ACCOUNT_NAME',
				inputValue: '2'
			},{
				boxLabel: '과목명3', 
				width: 70, 
				//name: 'ACCOUNT_NAME',
				inputValue: '3'
			}]
 		},{
			xtype: 'radiogroup',		            		
			fieldLabel: '보고서유형',
			name: 'DIVI',
			items: [{
				boxLabel: '대차대조표', 
				width: 70, 
				//name: 'DIVI',
				inputValue: '10',
				checked:true
			},{
				boxLabel : '손익계산서', 
				width: 70,
				//name: 'DIVI',
				inputValue: '20'
			},{
				boxLabel: '제조원가명세서', 
				width: 70, 
				//name: 'DIVI',
				inputValue: '30' 
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
	});	//end panelSearch  
	
	
    
    
    
	 Unilite.Main( {
	 	border: false,
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
					panelSearch
				]
			}  	
		], 
		id : 'agc150rkrApp',
		fnInitBinding : function(params) {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			UniAppManager.setToolbarButtons('query',false);
			panelSearch.setValue('DATE_FR',UniDate.get('startOfMonth'));
			
			panelSearch.setValue('DATE_TO',UniDate.get('today'));
			
			panelSearch.setValue('START_DATE',getStDt[0].STDT);
			panelSearch.getField('ACCOUNT_NAME').setValue(UserInfo.refItem);
			
			if(params && params.PGM_ID == 'agc150skr') {
				panelSearch.setValue('DATE_FR', params.DATE_FR);
				panelSearch.setValue('DATE_TO', params.DATE_TO);
				panelSearch.setValue('DIV_CODE1', params.DIV_CODE1);
				panelSearch.setValue('DIV_CODE2', params.DIV_CODE2);
				panelSearch.setValue('DIV_CODE3', params.DIV_CODE3);
				panelSearch.setValue('DIV_CODE4', params.DIV_CODE4);
				panelSearch.setValue('DIV_CODE5', params.DIV_CODE5);
				panelSearch.setValue('DIV_CODE6', params.DIV_CODE6);
				panelSearch.setValue('START_DATE', params.START_DATE);
				panelSearch.setValue('AMT_UNIT', params.AMT_UNIT);
				panelSearch.setValue('GUBUN', params.GUBUN);
				panelSearch.setValue('ACCOUNT_NAME', params.ACCOUNT_NAME);
				panelSearch.setValue('DIVI', params.DIVI);
			}
		},
		onQueryButtonDown : function()	{		
			if(!UniAppManager.app.isValidSearchForm()){
				return false;
			}else{
				var activeTabId = tab.getActiveTab().getId();			
			}
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
			if(!panelSearch.getInvalidMessage()) return;    //필수체크
			var param = panelSearch.getValues();
			
            param.PGM_ID = 'agc150rkr';  //프로그램ID
            param.MAIN_CODE = 'A126'; //해당 모듈의 출력정보를 가지고 있는 공통코드
            param.sTxtValue2_fileTitle = "사업장별재무제표(" + panelSearch.getField('DIVI').getChecked()[0].boxLabel + ")";
            
			param.GUBUN = '03';
            
			param.DIV_NAME1 = panelSearch.getField('DIV_CODE1').getDisplayValue();
			param.DIV_NAME2 = panelSearch.getField('DIV_CODE2').getDisplayValue();
			param.DIV_NAME3 = panelSearch.getField('DIV_CODE3').getDisplayValue();
			param.DIV_NAME4 = panelSearch.getField('DIV_CODE4').getDisplayValue();
			param.DIV_NAME5 = panelSearch.getField('DIV_CODE5').getDisplayValue();
			param.DIV_NAME6 = panelSearch.getField('DIV_CODE6').getDisplayValue();
			
			var reportGubun = '${gsReportGubun}';
			
			if(!Ext.isEmpty(reportGubun) && reportGubun == 'CLIP'){
				agc150skrService.fnCheckExistABA131(param, function(provider, response) {
					if(provider && provider.length > 0) {
						var win = Ext.create('widget.ClipReport', {
							url: CPATH+'/accnt/agc150clrkrv.do',
							prgID: 'agc150rkr',
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
			
//			//测试打印报表
//			var map = panelSearch.getValues();
//			var win = Ext.create('widget.PDFPrintWindow', {
//				url: CPATH+'/agc/agc150rkrPrint.do',
//				prgID: 'agc150rkr',
//				extParam: map
//				});
//			win.center();
//			win.show();
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
