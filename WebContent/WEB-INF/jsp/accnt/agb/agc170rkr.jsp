<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="agc170rkr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A054"  opts= '20;30'/> <!-- 재무제표양식구분-->
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
	
//	var fnGetSession = ${fnGetSession};
	
	var panelSearch = Unilite.createSearchForm('agc170rkrForm', {
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
//			width: 3,
			allowBlank: false,
			value:'20'
			
//			holdable: 'hold'
		}
			,{
		 		fieldLabel: '당기시작년월',
		 		xtype: 'uniMonthfield',
		 		name: 'START_DATE',
		 		allowBlank:false
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
//						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},
			{
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
	 		}
		,
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
	 
		id : 'agc170rkrApp',
		fnInitBinding : function() {
			
			
//			panelResult.down('#innerText').hide(); // 재무상태표  자산 - 부채 Field hide
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			
			panelSearch.setValue('AMT_UNIT'  ,Ext.data.StoreManager.lookup( 'CBS_AU_B042' ).getAt(0).get ('value'));
			
			var gsThisStDate = getStDt[0].STDT;
			panelSearch.setValue('START_DATE', gsThisStDate); // 당기시작년월
			panelSearch.getField('ACCOUNT_NAME').setValue(UserInfo.refItem);
			UniAppManager.setToolbarButtons('print',false);
			
		},
		onQueryButtonDown : function()	{
		},
		onDetailButtonDown:function() {
		},
		onPrintButtonDown: function() {
//			var param= Ext.getCmp('searchForm').getValues();
			var win = Ext.create('widget.PDFPrintWindow', {
				url: CPATH+'/agc/agc170rkrPrint.do',
				prgID: 'agc170rkr',
				extParam: {
					TYPE     			: panelSearch.getValue('TYPE').TYPE,
					DIV_CODE            : panelSearch.getValue('DIV_CODE'),
					DIV_NAME            : panelSearch.getField('DIV_CODE').getRawValue(),
					START_DATE			: UniAppManager.app.fnFormatDate(panelSearch.getValue('START_DATE'),"ym"),
					AMT_UNIT			: panelSearch.getValue('AMT_UNIT'),
					PRINT    			: panelSearch.getValue('radio1').PRINT,
					ACCOUNT_NAME    	: panelSearch.getValue('radio2').ACCOUNT_NAME,
					GUBUN				: panelSearch.getValue('GUBUN')
					
				}
				});
			win.center();
			win.show();   				
		}
		,
		
		fnCalSession: function(value){
			var sThisStDate = ''; var sNextStDate = ''; var sSession ='';
			var sSign ='';
			
			
			if(value == 'START_DATE'){
				var sStDate  = UniDate.getDbDateStr(panelSearch.getValue('START_DATE')).substring(0, 6);		/* 입력된 당기시작년월 */
				
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
			return fn;
		}
		
	
	});
};


</script>
