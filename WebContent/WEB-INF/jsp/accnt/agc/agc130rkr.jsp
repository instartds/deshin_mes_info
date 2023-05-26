<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="agc130rkr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A054"  opts= '10;20;30;31;32;40;35;45'/> <!-- 재무제표양식구분-->
	<t:ExtComboStore comboType="AU" comboCode="B042" /> <!-- 금액단위-->
	<t:ExtComboStore comboType="AU" comboCode="A093" /> <!-- 재무제표양식차수-->
</t:appConfig>
<script type="text/javascript" >

var fnSetFormTitle = ${fnSetFormTitle};

var BsaCodeInfo =  {
	gsFinancialY: '${gsFinancialY}',
	gsAssets : '${gsAssets}',//자산 //1999
	gsDebt   : '${gsDebt}'	//부채  // 5000
};


function appMain() {   
	
	
//	var len = fnSetFormTitle.length; 
//	var tabTitle1 ='대차대조표';
//	var tabTitle2 ='손익계산서';
//	var tabTitle3 ='제조원가명세서';
//	var tabTitle4 ='용역원가명세서';
//	var tabTitle5 ='용역원가명세서2';
//	var tabTitle6 ='이익잉여금처분계산서';
//	var tabTitle7 ='자본변동표';
//	
//	var hideTab1 = true;
//	var hideTab2 = true;
//	var hideTab3 = true;
//	var hideTab4 = true;
//	var hideTab5 = true;
//	var hideTab6 = true;
//	var hideTab7 = true;
//	
//	for(var i=0 ; i < len ; i++) { 
//		if(fnSetFormTitle[i].SUB_CODE == '10'){
//			if(fnSetFormTitle[i].USE_YN == 'Y'){
//				hideTab1 = false;
//			}
//			tabTitle1 = fnSetFormTitle[i].CODE_NAME;
//		}
//		if(fnSetFormTitle[i].SUB_CODE == '20'){
//			if(fnSetFormTitle[i].USE_YN == 'Y'){
//				hideTab2 = false;
//			}
//			tabTitle2 = fnSetFormTitle[i].CODE_NAME;
//		}
//		if(fnSetFormTitle[i].SUB_CODE == '30'){
//			if(fnSetFormTitle[i].USE_YN == 'Y'){
//				hideTab3 = false;
//			}
//			tabTitle3 = fnSetFormTitle[i].CODE_NAME;
//		}
//		if(fnSetFormTitle[i].SUB_CODE == '31'){
//			if(fnSetFormTitle[i].USE_YN == 'Y'){
//				hideTab4 = false;
//			}
//			tabTitle4 = fnSetFormTitle[i].CODE_NAME;
//		}
//		if(fnSetFormTitle[i].SUB_CODE == '32'){
//			if(fnSetFormTitle[i].USE_YN == 'Y'){
//				hideTab5 = false;
//			}
//			tabTitle5 = fnSetFormTitle[i].CODE_NAME;
//		}
//		if(fnSetFormTitle[i].SUB_CODE == '40'){
//			if(fnSetFormTitle[i].USE_YN == 'Y'){
//				hideTab6 = false;
//			}
//			tabTitle6 = fnSetFormTitle[i].CODE_NAME;
//		}
//		if(fnSetFormTitle[i].SUB_CODE == '35'){
//			if(fnSetFormTitle[i].USE_YN == 'Y'){
//				hideTab7 = false;
//			}
//			tabTitle7 = fnSetFormTitle[i].CODE_NAME;
//		}
//	}
	
	/* 
	 * 대차대조표 				agc130skrs1
	 * 손익계산서				agc130skrs1
	 * 제조원가명세서			agc130skrs1
	 * 용역원가명세서			agc130skrs1
	 * 용역원가명세서2			agc130skrs1
	 * 이익잉여금처분계산서		agc130skrs2
	 * 자본변동표				agc130skrs3
	 * */
	var getStDt = ${getStDt};
	
	var fnGetSession = ${fnGetSession};
	
	var panelSearch = Unilite.createSearchForm('agc130rkrForm', {
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
			fieldLabel: '보고서유형',
//			colspan: 2,
			name :'TYPE',
			xtype: 'uniRadiogroup',
			comboType: 'AU',
			comboCode: 'A054',
			width: 1200,
			allowBlank: false
//			,
//			value:'10'
			
//			holdable: 'hold'
		},
		
		{ 
	        	fieldLabel: '당기전표일',
				xtype: 'uniDateRangefield',  
				startFieldName: 'THIS_DATE_FR',
				endFieldName: 'THIS_DATE_TO',
				allowBlank:false,
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					UniAppManager.app.fnSetStDate(newValue, 'THIS_START_DATE', getStDt[0].STDT);
					UniAppManager.app.fnCalPrevDate(newValue, panelSearch.getValue('PREV_DATE_FR'), 'PREV_START_DATE' , "PREV_DATE_FR");
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
//			    	UniAppManager.app.fnSetStDate(newValue, 'THIS_START_DATE', getStDt[0].STDT);
					UniAppManager.app.fnCalPrevDate(newValue, panelSearch.getValue('PREV_DATE_FR'), '' , "PREV_DATE_TO");
			    }
			},{ 
	        	fieldLabel: '전기전표일',
				xtype: 'uniDateRangefield',  
				startFieldName: 'PREV_DATE_FR',
				endFieldName: 'PREV_DATE_TO',
				allowBlank:false,
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					UniAppManager.app.fnSetStDate(newValue, 'PREV_START_DATE', getStDt[0].STDT);
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    }
			},{ 
				fieldLabel: '사업장',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				multiSelect: true, 
		        typeAhead: false,
				value : UserInfo.divCode,
				comboType: 'BOR120',
				width: 325,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
//						panelSearch.setValue('DIV_CODE', newValue);
					}
				}
			},
			{
		 		fieldLabel: '당기시작년월',
		 		xtype: 'uniMonthfield',
		 		name: 'THIS_START_DATE',
		 		allowBlank:false
			},{
		 		fieldLabel: '전기시작년월',
		 		xtype: 'uniMonthfield',
		 		name: 'PREV_START_DATE',
		 		allowBlank:false
			},{
		 		fieldLabel: '금액단위',
		 		name:'AMT_UNIT', 
		 		xtype: 'uniCombobox',
		 		comboType:'AU',
		 		comboCode:'B042',
		 		allowBlank:false
	 		},{
				xtype: 'radiogroup',		            		
				fieldLabel: '과목명',		
				id: 'radio1',
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
				}
				]
			},{
				xtype: 'radiogroup',		            		
				fieldLabel: '과목출력',
				id: 'radio2',
				items: [{
					boxLabel: '한다', 
					width: 70, 
					name: 'PRINT',
					inputValue: '1'
				},{
					boxLabel : '안한다', 
					width: 70,
					name: 'PRINT',
					inputValue: '2',
					checked: true 
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						if(newValue){
							UniAppManager.app.onQueryButtonDown();
						}
					}
				}
	 		}
			,{
		 		fieldLabel: '재무제표양식차수',
		 		name:'GUBUN', 
		 		xtype: 'uniCombobox',
		 		comboType:'AU',
		 		comboCode:'A093',
		 		value: BsaCodeInfo.gsFinancialY,
		 		allowBlank:false
	 		},{
				xtype: 'radiogroup',		            		
				fieldLabel: '페이지설정',	
				id: 'radio3',
				name: 'PAGE_TYPE',
				items: [{
					boxLabel: '세로', 
					width: 70, 
					//name: 'PAGE_TYPE',
					inputValue: '0',    //纵向
					checked: true 
				},{
					boxLabel : '가로', 
					width: 70,
					//name: 'PAGE_TYPE',
					inputValue: '1'    //横向
				}
				]
			}
		,
         {
         	xtype:'button',
         	text:'출    력',
         	width:235,
         	tdAttrs:{'align':'left', style:'padding-left:95px'},
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
	 
		id : 'agc130rkrApp',
		fnInitBinding : function(param) {
			
			
//			panelSearch.down('#innerText').hide(); // 재무상태표  자산 - 부채 Field hide
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			
			panelSearch.setValue('AMT_UNIT'  ,Ext.data.StoreManager.lookup( 'CBS_AU_B042' ).getAt(0).get ('value'));
			
			var gsThisStDate = getStDt[0].STDT;
			var gsPrevStDate = UniDate.getDbDateStr(gsThisStDate).substring(0, 4)-1 + UniDate.getDbDateStr(gsThisStDate).substring(4, 8);
			var thisDate = UniDate.get('today');
			var PrevDate = UniDate.getDbDateStr(thisDate).substring(0, 4)-1 + UniDate.getDbDateStr(thisDate).substring(4, 8);
			
			panelSearch.setValue('THIS_DATE_FR', gsThisStDate);    // 당기시작일 FR
			panelSearch.setValue('THIS_DATE_TO', thisDate);		   // 당기시작일 TO
			panelSearch.setValue('PREV_DATE_FR', gsPrevStDate);    // 전기시작일 FR
			panelSearch.setValue('PREV_DATE_TO', PrevDate);        // 전기시작일 TO
			panelSearch.setValue('THIS_START_DATE', gsThisStDate); // 당기시작년월
			panelSearch.setValue('PREV_START_DATE', gsPrevStDate); // 전기시작년월
//			panelSearch.getField('PRINT').setValue(UserInfo.refItem);
			panelSearch.getField('ACCOUNT_NAME').setValue(UserInfo.refItem);
//			panelSearch.getField('GUBUN').setValue(UserInfo.refItem);
//			panelSearch.getField('PAGE_TYPE').setValue(UserInfo.refItem);
			
			
			
			//UniAppManager.app.fnCalSession("THIS_START_DATE");
			//UniAppManager.app.fnCalSession("PREV_START_DATE");
			
			UniAppManager.setToolbarButtons('print',false);
			if(param){
			   this.processParams(param);
			}
			else {
				panelSearch.getField('TYPE').setValue('10');
			}
			
		},
        processParams: function(param) {
            panelSearch.setValue('DEPTCD', param.DEPTCD);
            panelSearch.setValue('WORK_DATE', param.WORK_DATE);
            panelSearch.setValue('THIS_DATE_FR', param.THIS_DATE_FR);
            panelSearch.setValue('THIS_DATE_TO', param.THIS_DATE_TO);
            panelSearch.setValue('PREV_DATE_FR', param.PREV_DATE_FR);
            panelSearch.setValue('PREV_DATE_TO', param.PREV_DATE_TO);
            panelSearch.setValue('DIV_CODE', param.DIV_CODE);
            panelSearch.setValue('THIS_START_DATE', param.THIS_START_DATE);
            panelSearch.setValue('PREV_START_DATE', param.PREV_START_DATE);
            panelSearch.setValue('AMT_UNIT', param.AMT_UNIT);
            panelSearch.getField('ACCOUNT_NAME').setValue(param.ACCOUNT_NAME);
            panelSearch.getField('PRINT').setValue(param.PRINT);
            
            panelSearch.getField('TYPE').setValue(param.TYPE);
        },
		onQueryButtonDown : function()	{
		},
		onDetailButtonDown:function() {
		},
		onPrintButtonDown: function() {
			if(!panelSearch.getInvalidMessage()) return;    //필수체크
			var param= panelSearch.getValues();
			
            param.PGM_ID = 'agc130rkr';  //프로그램ID
            param.MAIN_CODE = 'A126'; //해당 모듈의 출력정보를 가지고 있는 공통코드
            param.sTxtValue2_fileTitle = panelSearch.getField('TYPE').getChecked()[0].boxLabel;
            
            param.DIV_CODE = panelSearch.getValue('DIV_CODE').join(",");
			param.DIV_NAME = panelSearch.getField('DIV_CODE').getRawValue();
			param.MSG_DESC = '합    계';
			
			param.THIS_SESSION = UniAppManager.app.fnCalSession('THIS_START_DATE');
			param.PREV_SESSION = UniAppManager.app.fnCalSession('PREV_START_DATE');
			param.DIVI		   = param.TYPE;
			
			var reportGubun = '${gsReportGubun}';
			
			if(Ext.isEmpty(reportGubun) || reportGubun == 'CR'){
				var win = Ext.create('widget.PDFPrintWindow', {
					url: CPATH+'/agc/agc130rkrPrint.do',
					prgID: 'agc130rkr',
					extParam: {
						TYPE     			: panelSearch.getValue('TYPE').TYPE,
						THIS_DATE_FR		: UniAppManager.app.fnFormatDate(panelSearch.getValue('THIS_DATE_FR'),"ymd"),
						THIS_DATE_TO		: UniAppManager.app.fnFormatDate(panelSearch.getValue('THIS_DATE_TO'),"ymd"),
						PREV_DATE_FR		: UniAppManager.app.fnFormatDate(panelSearch.getValue('PREV_DATE_FR'),"ymd"),
						PREV_DATE_TO		: UniAppManager.app.fnFormatDate(panelSearch.getValue('PREV_DATE_TO'),"ymd"),
						DIV_CODE            : panelSearch.getValue('DIV_CODE'),
						DIV_NAME            : panelSearch.getField('DIV_CODE').getRawValue(),
						THIS_START_DATE		: UniAppManager.app.fnFormatDate(panelSearch.getValue('THIS_START_DATE'),"ym"),
						PREV_START_DATE		: UniAppManager.app.fnFormatDate(panelSearch.getValue('PREV_START_DATE'),"ym"),
						AMT_UNIT			: panelSearch.getValue('AMT_UNIT'),
						PRINT    			: panelSearch.getValue('radio1').PRINT,
						ACCOUNT_NAME    	: panelSearch.getValue('radio2').ACCOUNT_NAME,
						GUBUN				: panelSearch.getValue('GUBUN'),
						PAGE_TYPE    		: panelSearch.getValue('radio3').PAGE_TYPE,
						THIS_SESSION        : UniAppManager.app.fnCalSession('THIS_START_DATE'),
						PREV_SESSION        : UniAppManager.app.fnCalSession('PREV_START_DATE'),
						PGM_ID          	: 'agc130rkr'
					}
				});
				
				win.center();
				win.show();
			}
			else {
				agc130skrService.fnCheckExistABA131(param, function(provider, response) {
					if(provider && provider.length > 0) {
						var win = Ext.create('widget.ClipReport', {
							url: CPATH+'/accnt/agc130clrkrv.do',
							prgID: 'agc130rkr',
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
		}
		,
		
		fnCalSession: function(value){
			var sThisStDate = ''; var sNextStDate = ''; var sSession ='';
			var sSign ='';
			
			
			if(value == 'THIS_START_DATE'){
				var sStDate  = UniDate.getDbDateStr(panelSearch.getValue('THIS_START_DATE')).substring(0, 6);		/* 입력된 당기시작년월 */
				
				var sThisStDate = UniDate.getDbDateStr(getStDt[0].STDT).substring(0, 6);								
				/* 기본 당기시작년월 */ 
				var sSession	= fnGetSession[0].SESSION;
				
				if(sStDate < sThisStDate){
				
					var sessionCalc = UniDate.getDbDateStr(sThisStDate).substring(0, 4) - UniDate.getDbDateStr(sStDate).substring(0, 4);
					var sSession = sSession - sessionCalc; 
				}
				var fanalSession 	= sSession;	
				
				return fanalSession;
			}
			else if(value == 'PREV_START_DATE'){
				var sStDate  = UniDate.getDbDateStr(panelSearch.getValue('PREV_START_DATE')).substring(0, 6);		/* 입력된 당기시작년월 */
				
				var sThisStDate = UniDate.getDbDateStr(getStDt[0].STDT).substring(0, 6);								
				/* 기본 당기시작년월 */ 
				var sSession	= fnGetSession[0].SESSION;
				
				if(sStDate < sThisStDate){
				
					var sessionCalc = UniDate.getDbDateStr(sThisStDate).substring(0, 4) - UniDate.getDbDateStr(sStDate).substring(0, 4);
					var sSession = sSession - sessionCalc; 
				}
				var fanalSession 	= sSession;	
				
				return fanalSession;
			}
		},
		fnFormatDate:function  (strTime,format) {
			
		    var date = new Date(strTime);
		    var formatDate;
		    var mm = date.getMonth()>=9?(date.getMonth()+1).toString():("0"+(date.getMonth()+1).toString()) ;
		    var dd  = date.getDate()>=10?date.getDate().toString():("0"+date.getDate().toString());
		    switch (format){
		    	case "ymd":
		    		formatDate = 
		    		 date.getFullYear().toString() +mm+dd;
		    	break;
		    	case "ym":
		    		formatDate = date.getFullYear().toString() + mm;
		    	break;
		    	
		    }
		    return formatDate;
		},
		
		fnCheckData:function(newValue){
			var prevDateFr = panelSearch.getField('PREV_DATE_FR').getSubmitValue();  // 전기전표일 FR
			var prevDateTo = panelSearch.getField('PREV_DATE_TO').getSubmitValue();  // 전기전표일 TO
			
			var thisDateFr = panelSearch.getField('THIS_DATE_FR').getSubmitValue();  // 당기전표일 FR
			var thisDataTo = panelSearch.getField('THIS_DATE_TO').getSubmitValue();  // 당기전표일 TO
			
			
			var thisStartDate = panelSearch.getField('THIS_START_DATE').getSubmitValue();  // 당기시작년월
			var prevStartDate = panelSearch.getField('PREV_START_DATE').getSubmitValue();  // 전기시작년월

			var r= true
			
			if(thisDateFr > thisDataTo) {
				alert('당기전표일: 시작일이 종료일보다 클수는 없습니다.');
				//당기전표일: 시작일이 종료일보다 클수는 없습니다.
				//alert('<t:message code="unilite.msg.sMAW036"/>' + '<t:message code="unilite.msg.sMB084"/>');
				panelSearch.setValue('THIS_DATE_FR',thisDateFr);
//				panelSearch.setValue('THIS_DATE_FR',thisDateFr);						
				panelSearch.getField('THIS_DATE_FR').focus();
				r = false;
				return false;
			}

			if(prevDateFr > prevDateTo) {
				alert('전기전표일: 시작일이 종료일보다 클수는 없습니다.');
				//전기전표일: 시작일이 종료일보다 클수는 없습니다.
				//alert('<t:message code="unilite.msg.sMAW037"/>' + '<t:message code="unilite.msg.sMB084"/>');
				panelSearch.setValue('PREV_DATE_FR',prevDateFr);
//				panelSearch.setValue('PREV_DATE_FR',prevDateFr);						
				panelSearch.getField('PREV_DATE_FR').focus();
				r = false;
				return false;
			}
			
			if(thisDateFr < prevDateTo) {
				alert('전기전표일이 당기전표일보다 클 수 없습니다.');
				//전기전표일이 당기전표일보다 클 수 없습니다.
				//alert('<t:message code="unilite.msg.sMA0324"/>');
				panelSearch.setValue('PREV_DATE_FR',prevDateFr);
//				panelSearch.setValue('PREV_DATE_FR',prevDateFr);						
				panelSearch.getField('PREV_DATE_FR').focus();
				r = false;
				return false;
			}
			return r;
		},

		fnSetStDate: function(dateObj, targetObj, sStDt){
			if(dateObj == null){
				return false;
			}
			var sTempDate = ''; var sStDate   = '';	
			var fn = false;
			
			sTempDate = UniDate.getDbDateStr(dateObj).substring(0, 6);
			sStDate   = UniDate.getDbDateStr(sTempDate).substring(0, 4) + UniDate.getDbDateStr(sStDt).substring(4, 6);
			
			if(sTempDate < sStDate){
				sStDate = (UniDate.getDbDateStr(sStDate).substring(0, 4) - 1) + (UniDate.getDbDateStr(sStDate).substring(4, 6));
			}
			
			if(targetObj == 'THIS_START_DATE'){
				panelSearch.setValue('THIS_START_DATE', sStDate);
				fn = true;
			}
			if(targetObj == 'PREV_START_DATE'){
				panelSearch.setValue('PREV_START_DATE', sStDate);
				fn = true;
			}
			if(targetObj == ''){
				fn = true;
			}
			return fn;
		},
		
		// 당기전표일 변경시 전기전표일 자동계산
		fnCalPrevDate: function(sDate, oPrevDate, oPrevStDate, chageValue){
			if(sDate == null){
				return false;
			}
			else{
				oPrevDate = (UniDate.getDbDateStr(sDate).substring(0, 4) - 1) + (UniDate.getDbDateStr(sDate).substring(4, 8));
				if(chageValue == 'PREV_DATE_FR' ){
					panelSearch.setValue('PREV_DATE_FR', oPrevDate);
//					panelSearch.setValue('PREV_DATE_FR', oPrevDate);
				}
				if(chageValue == 'PREV_DATE_TO' ){
					panelSearch.setValue('PREV_DATE_TO', oPrevDate);
//					panelSearch.setValue('PREV_DATE_TO', oPrevDate);
				}
				if(oPrevStDate){
					UniAppManager.app.fnSetStDate(oPrevDate, oPrevStDate, getStDt[0].STDT);	
				}
			}
		}
	});
};


</script>
