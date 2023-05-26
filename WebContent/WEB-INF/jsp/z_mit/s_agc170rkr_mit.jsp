<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_agc170rkr_mit"  >
	<t:ExtComboStore comboType="BOR120"/>								<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A054" opts= '20;30'/>	<!-- 재무제표양식구분-->
	<t:ExtComboStore comboType="AU" comboCode="B042"/>					<!-- 금액단위-->
	<t:ExtComboStore comboType="AU" comboCode="A093"/>					<!-- 재무제표양식차수-->
</t:appConfig>
<script type="text/javascript" >

var fnSetFormTitle = ${fnSetFormTitle};

var BsaCodeInfo =  {
	gsFinancialY: '${gsFinancialY}',
	gsAssets	: '${gsAssets}',		//자산 //1999
	gsDebt		: '${gsDebt}'			//부채  // 5000
};

function appMain() {
	var getStDt = ${getStDt};
//	var fnGetSession = ${fnGetSession};

	var panelSearch = Unilite.createSearchForm('s_agc170rkr_mitForm', {
		region	: 'center',
		disabled:false,
		border	: false,
		flex	: 1,
		layout	: {
			type	: 'uniTable',
			columns	: 1
		},
		defaults:{
			padding		: '0 0 3 0',
			width		: 370,
			labelWidth	: 120
		},
		defaultType	: 'uniTextfield',
		padding		: '20 0 0 0',
		items		: [{
			fieldLabel	: '보고서유형',
			xtype		: 'radiogroup',
			name		: 'TYPE',
			items		: [{
				boxLabel	: '손익<br>계산서',
//				name		: 'TYPE',
				width		: 70,
				inputValue	: '20'
			},{
				boxLabel	: '제조원가명세서',
//				name		: 'TYPE',
				width		: 70,
				inputValue	: '30'
			},{
				boxLabel	: '도급원가명세서',
//				name		: 'TYPE',
				width		: 70,
				inputValue	: '31'
			}]
		},{
			fieldLabel		: '출력기간',
			xtype			: 'uniMonthRangefield',
			startFieldName	: 'START_DATE',
			endFieldName	: 'END_DATE',
			allowBlank		: false,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
			}
		},{ 
			fieldLabel	: '사업장',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			typeAhead	: false,
			value		: UserInfo.divCode,
			//20200716 사업장 멀티선택로직 추가
			multiSelect	: true, 
			comboType	: 'BOR120',
			width		: 343,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '금액단위',
			name		: 'AMT_UNIT', 
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B042',
			width		: 343,
			allowBlank	: false
		},{
			fieldLabel	: '과목명',
			xtype		: 'radiogroup',
			id			: 'radio1',
			name		: 'ACCOUNT_NAME',
			width		: 360,
			items		: [{
				boxLabel	: '과목명1',
				width		: 70,
//				name		: 'ACCOUNT_NAME',
				inputValue	: '0'
			},{
				boxLabel	: '과목명2',
				width		: 70,
//				name		: 'ACCOUNT_NAME',
				inputValue	: '1'
			},{
				boxLabel	: '과목명3',
				width		: 70, 
//				name		: 'ACCOUNT_NAME',
				inputValue	: '2' 
			}]
		},{
			fieldLabel	: '과목출력',
			xtype		: 'radiogroup',
			id			: 'radio2',
			name		: 'PRINT',
			width		: 283,
			items		: [{
				boxLabel	: '한다', 
				width		: 70,
//				name		: 'PRINT',
				inputValue: '1'
			},{
				boxLabel	: '안한다', 
				width		: 70,
//				name		: 'PRINT',
				inputValue	: '2',
				checked		: true 
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '재무제표양식차수',
			name		: 'GUBUN', 
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'A093',
			value		: BsaCodeInfo.gsFinancialY,
			width		: 343,
			allowBlank	: false
		},{
			xtype	: 'component',
			height	: 10
		},{
			xtype		: 'button',
			text		: '출	력',
			tdAttrs		: {'align':'center', style:'padding-left:95px'},
			width		: 220,
			handler		: function() {
				UniAppManager.app.onPrintButtonDown();
			}
		}]
	});

	Unilite.Main({
		id		: 's_agc170rkr_mitApp',
		border	: false,
		items	: [
			panelSearch
		],
		fnInitBinding : function(params) {
			var gsThisStDate = getStDt[0].STDT;
			panelSearch.setValue('START_DATE'	, gsThisStDate);			// 당기시작년월
			panelSearch.setValue('END_DATE'		, UniDate.get('today'));	// 당기시작년월
			panelSearch.setValue('DIV_CODE'		, UserInfo.divCode);
			panelSearch.setValue('AMT_UNIT'		, Ext.data.StoreManager.lookup( 'CBS_AU_B042' ).getAt(0).get ('value'));
			panelSearch.getField('ACCOUNT_NAME').setValue(UserInfo.refItem);

			UniAppManager.setToolbarButtons(['detail', 'reset', 'print'], false);

			if(params && params.PGM_ID == 's_agc170skr_mit') {
				panelSearch.setValue('TYPE'			, params.TYPE);
				panelSearch.setValue('START_DATE'	, params.START_DATE);
				panelSearch.setValue('END_DATE'		, params.END_DATE);
				panelSearch.setValue('DIV_CODE'		, params.DIV_CODE);
				panelSearch.setValue('AMT_UNIT'		, params.AMT_UNIT);
				panelSearch.setValue('ACCOUNT_NAME'	, params.ACCOUNT_NAME);
				panelSearch.setValue('PRINT'		, params.PRINT);
				panelSearch.setValue('GUBUN'		, params.GUBUN);
			}
		},
		onPrintButtonDown: function() {
			if(!panelSearch.getInvalidMessage()) return;	//필수체크

			var stDate = panelSearch.getValues().START_DATE;
			var edDate = panelSearch.getValues().END_DATE;
			
			if(stDate.substring(0, 4) != edDate.substring(0, 4)) {
				alert("회기를 초과하여 출력하실 수 없습니다.");
				return;
			}
			
//				alert(UniDate.diffDays(panelSearch.getValue('START_DATE'), panelSearch.getValue('END_DATE')));
			var reportGubun = '${gsReportGubun}';
			var param = panelSearch.getValues();
			param.PGM_ID				= 's_agc170rkr_mit';	//프로그램ID
			param.MAIN_CODE				= 'A126';			//해당 모듈의 출력정보를 가지고 있는 공통코드
			param.sTxtValue2_fileTitle	= "월별재무제표(" + panelSearch.getField('TYPE').getChecked()[0].boxLabel.replace('<br>', '') + ")";
			param.DIV_NAME				= panelSearch.getField('DIV_CODE').getRawValue();
			param.AMT_NAME				= panelSearch.getField('AMT_UNIT').getDisplayValue();
			param.DIVI					= param.TYPE;
			//20200716 사업장 멀티선택로직 추가
			if(!Ext.isEmpty(panelSearch.getValue('DIV_CODE'))) {
				var items = '';
				var divCode = panelSearch.getValue('DIV_CODE');
				Ext.each(divCode, function(item, i) {
					if(i == 0) {
						items = item;
					} else {
						items = items + ',' + item;
					}
				});
				param.DIV_CODE = items;
			}

			agc130skrService.fnCheckExistABA131(param, function(provider, response) {
				if(provider && provider.length > 0) {
					var win = Ext.create('widget.ClipReport', {
						url		: CPATH+'/z_mit/s_agc170clrkr_mit.do',
						prgID	: 's_agc170rkr_mit',
						extParam: param
					});
					win.center();
					win.show();
				} else {
					Unilite.messageBox('집계항목설정 내역을 적용한 데이터가 존재하지 않습니다.\n회계-기초등록-집계항목설정 메뉴에서 집계항목적용 후 작업하십시오.');
				}
			});
/*		},
		fnCalSession: function(value){
			var sThisStDate = ''; var sNextStDate = ''; var sSession ='';
			var sSign ='';
			
			
			if(value == 'START_DATE'){
				var sStDate  = UniDate.getDbDateStr(panelSearch.getValue('START_DATE')).substring(0, 6);		 입력된 당기시작년월 
				
				var sThisStDate = UniDate.getDbDateStr(getStDt[0].STDT).substring(0, 6);
				 기본 당기시작년월  
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
					formatDate = date.getFullYear().toString() + mm + dd;
					break;
					
				case "ym":
					formatDate = date.getFullYear().toString() + mm;
					break;
			}
			return formatDate;
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
			
			if(targetObj == 'START_DATE'){
				panelSearch.setValue('START_DATE', sStDate);
				fn = true;
			}
			
			if(targetObj == ''){
				fn = true;
			}
			return fn;*/
		}
	});
};
</script>