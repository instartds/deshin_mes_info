<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<t:appConfig pgmId="agc140rkr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->   
	<t:ExtComboStore comboType="AU" comboCode="A076" /> <!-- 이익처분구분 -->      
	<t:ExtComboStore comboType="AU" comboCode="A093" /> <!-- 재무제표양식차수 -->
	<t:ExtComboStore comboType="AU" comboCode="B042" /> <!-- 금액단위 -->
</t:appConfig>

<script type="text/javascript" >

var fnGetSession= ${fnGetSession};
var getStDt		= Ext.isEmpty(${getStDt})	? [] : ${getStDt} ;								//당기시작월 관련 전역변수
var gsStDate	= Ext.isEmpty(getStDt)		? '' : getStDt[0].STDT;

function appMain() {
	
	var panelSearch = Unilite.createSearchForm('agc140rkrForm', {
		region: 'center',
		disabled :false,
		border: false,
		flex:1,
		layout: {
			type: 'uniTable',
			columns:1
		},
		defaults:{
			width:315,
			labelWidth:90
		},
		defaultType: 'uniTextfield',
		padding:'20 0 0 0',
		width:400,
		items : [{ 
			fieldLabel		: '전표일',
			xtype			: 'uniMonthRangefield',
			startFieldName	: 'FR_DATE',
			endFieldName	: 'TO_DATE',
			startDD			: 'first',
			endDD			: 'last',
			allowBlank		: false,
			holdable		: 'hold',
			width			: 380,
			tdAttrs			: {width: 380}, 
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				UniAppManager.app.fnSetStDate(newValue);
			}
		},{
			fieldLabel	: '사업장',
			xtype		: 'uniCombobox',
			name		: 'ACCNT_DIV_CODE', 
			comboType	: 'BOR120',
			multiSelect	: true, 
			typeAhead	: false,
			holdable	: 'hold'
		},{
			fieldLabel	: '귀속사업장',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false
		},{ 
			fieldLabel	: '당기시작년월',
			name		: 'ST_DATE',
			xtype		: 'uniMonthfield',
			allowBlank	: false,
			holdable	: 'hold'
		},{
			xtype		: 'radiogroup',		            		
			fieldLabel	: '과목명',
			name		: 'ACCT_NAME',
			items		: [{
				boxLabel	: '과목명1',
				width		: 80,
				//name		: 'ACCT_NAME',
				inputValue	: '0',
				checked		: true
			},{
				boxLabel	: '과목명2',
				width		: 80,
				//name		: 'ACCT_NAME',
				inputValue	: '1'
			},{
				boxLabel	: '과목명3',
				width		: 80,
				//name		: 'ACCT_NAME',
				inputValue	: '2'
			}]
		},{
			fieldLabel	: '금액단위',
			name		: 'AMT_UNIT', 
			xtype		: 'uniCombobox', 
			comboType	: 'AU',
			comboCode	: 'B042',
			allowBlank	: false
		},{
			fieldLabel	: '재무제표</br>양식차수',
			name		: 'GUBUN', 
			xtype		: 'uniCombobox', 
			comboType	: 'AU',
			comboCode	: 'A093',
			allowBlank	: false
		},{
			xtype		: 'radiogroup',		            		
			fieldLabel	: '과목명',
			name		: 'CASH_DIVI',
			items		: [{
				boxLabel	: '간접법',
				width		: 80,
				//name		: 'ACCT_NAME',
				inputValue	: '1'
			},{
				boxLabel	: '직접법',
				width		: 80,
				//name		: 'ACCT_NAME',
				inputValue	: '2'
			}]
		},{
			xtype:'button',
			text:'출    력',
			width:220,
			tdAttrs:{'align':'left', style:'padding-left:95px'},
			handler:function()	{
				UniAppManager.app.onPrintButtonDown();
			}
		}]
	});

	Unilite.Main( {
		id			: 'agc140rkrApp',
		border	: false,
		items	: [
			panelSearch
		],
		fnInitBinding : function(param) {
			panelSearch.setValue('FR_DATE'	, gsStDate);
			panelSearch.setValue('TO_DATE'	, UniDate.get('today'));
			panelSearch.setValue('DIV_CODE'	, UserInfo.divCode);
			panelSearch.setValue('ST_DATE'	, gsStDate);
			
			if(param && param.PGM_ID == 'agc140ukr') {
			   this.processParams(param);
			}
			else {
				panelSearch.setValue('ACCT_NAME', '0');
				panelSearch.setValue('AMT_UNIT'	, '1');
				panelSearch.setValue('GUBUN'	, '01');
				panelSearch.setValue('CASH_DIVI', '1');
			}
		},
        processParams: function(param) {
			panelSearch.setValue('FR_DATE'	, param.FR_DATE);
			panelSearch.setValue('TO_DATE'	, param.TO_DATE);
			panelSearch.setValue('DIV_CODE'	, param.DIV_CODE);
			panelSearch.setValue('ST_DATE'	, param.ST_DATE);
			panelSearch.setValue('ACCT_NAME', param.ACCT_NAME);
			panelSearch.setValue('AMT_UNIT'	, param.AMT_UNIT);
			panelSearch.setValue('GUBUN'	, param.GUBUN);
			panelSearch.setValue('CASH_DIVI', param.CASH_DIVI);
        },
		onPrintButtonDown: function() {
			if(!panelSearch.getInvalidMessage()) return;    //필수체크
			var param = panelSearch.getValues();
			
            param.PGM_ID = 'agc140rkr';  //프로그램ID
            param.MAIN_CODE = 'A126'; //해당 모듈의 출력정보를 가지고 있는 공통코드
            param.sTxtValue2_fileTitle = '현금흐름표';
            
            param.DIV_CODE = panelSearch.getValue('DIV_CODE');
			param.DIV_NAME = panelSearch.getField('DIV_CODE').getRawValue();
			param.MSG_DESC = '합    계';
			
			param.FR_DATE = param.FR_DATE + "01";
			param.TO_DATE = UniDate.get('endOfMonth', param.TO_DATE + "01");
			
			if(param.CASH_DIVI == '1') {
				param.TAB_SEL = "60";
			}
			else {
				param.TAB_SEL = "70";
			}
			
			param.THIS_SESSION = UniAppManager.app.fnCalSession('THIS_START_DATE');
			param.PREV_SESSION = UniAppManager.app.fnCalSession('PREV_START_DATE');
			
			var reportGubun = '${gsReportGubun}';
			
			if(!Ext.isEmpty(reportGubun) && reportGubun == 'CLIP'){
				agc140rkrService.checkList(param, function(provider, response) {
					if(provider && provider.length > 0) {
						//alert('준비중입니다.');
						//sreturn;
						
						var win = Ext.create('widget.ClipReport', {
							url: CPATH+'/accnt/agc140clrkrv.do',
							prgID: 'agc140rkr',
							extParam: param
						});
						
						win.center();
						win.show();
					}
					else {
						alert('등록된 현금흐름표가 존재하지 않습니다.');
					}
				});
			}
		}
		,
        //그리드 컬럼명 세팅
		fnCalSession: function(value){
			var sThisStDate = ''; var sNextStDate = ''; var sSession ='';
			var sSign ='';
			var sSession	= fnGetSession[0].SESSION;
			
			if(value == 'THIS_START_DATE'){
				var sStDate  = UniDate.getDbDateStr(panelSearch.getValue('ST_DATE')).substring(0, 6);		/* 입력된 당기시작년월 */
				var sThisStDate = UniDate.getDbDateStr(gsStDate).substring(0, 6);

				if(sStDate < sThisStDate){
					var sessionCalc = UniDate.getDbDateStr(sThisStDate).substring(0, 4) - UniDate.getDbDateStr(sStDate).substring(0, 4);
					sSession = sSession - sessionCalc; 
				}
			} else if(value == 'PREV_START_DATE'){
				var prevStDate = UniDate.add(panelSearch.getValue('ST_DATE'), {years: -1});
				var sStDate  = UniDate.getDbDateStr(prevStDate).substring(0, 6);		/* 입력된 당기시작년월 */
				var sThisStDate = UniDate.getDbDateStr(gsStDate).substring(0, 6);
				
				if(sStDate < sThisStDate){
					var sessionCalc = UniDate.getDbDateStr(sThisStDate).substring(0, 4) - UniDate.getDbDateStr(sStDate).substring(0, 4);
					sSession = sSession - sessionCalc; 
				}
			}
			return sSession;
		},
		//당기시작월 세팅
		fnSetStDate:function(newValue) {
        	if(newValue == null){
				return false;
			}else{
		    	if(UniDate.getDbDateStr(newValue).substring(0, 6) < (UniDate.getDbDateStr(newValue).substring(0, 4) + UniDate.getDbDateStr(gsStDate).substring(4, 6))){
					panelSearch.setValue('ST_DATE', UniDate.getDbDateStr(newValue).substring(0, 4)-1 + UniDate.getDbDateStr(gsStDate).substring(4, 6));
				}else{
					panelSearch.setValue('ST_DATE', UniDate.getDbDateStr(newValue).substring(0, 4) + UniDate.getDbDateStr(gsStDate).substring(4, 6));
				}
			}
        }
	});
	
};
</script>