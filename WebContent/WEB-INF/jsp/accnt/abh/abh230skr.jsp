<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="abh230skr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->   
	<t:ExtComboStore comboType="AU" comboCode="A103" /> <!-- 입출금 구분 --> 
	<t:ExtComboStore comboType="AU" comboCode="A023" /> <!--결의회계구분-->		 
	<t:ExtComboStore comboType="AU" comboCode="B004" /> <!-- 화폐단위 -->
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}	
</style>	
</t:appConfig>
<script type="text/javascript" >

var gsChargeCode  = Ext.isEmpty(${getChargeCode}) ? ['']: ${getChargeCode};   //ChargeCode 관련 전역변수
function appMain() {


	/** Model 정의 
	 * @type 
	 */
	Unilite.defineModel('abh230skrModel', {		
		fields: [
			{name: 'SEND_DATE'			, text: '이체일자'  		, type: 'string'  },			 	 	
			{name: 'PAY_CUSTOM_CODE'	, text: '지급처'  		, type: 'string'  },			 	 	
			{name: 'CUSTOM_NAME'		, text: '지급처명'  		, type: 'string'  },			 	 	
			{name: 'COMPANY_NUM'		, text: '사업자번호'  		, type: 'string'  },			 	 	
			{name: 'REMARK'				, text: '적요'  			, type: 'string'  },			 	 	
			{name: 'J_AMT_I'			, text: '실지급액'  		, type: 'uniPrice'},			 	 	
			{name: 'SEND_YN'			, text: '이체여부'  		, type: 'string'  },			 	 	
			{name: 'RETURN_YN'			, text: '반송여부'  		, type: 'string'  },			 	 	
			{name: 'REASON_MSG'			, text: '반송사유'  		, type: 'string'  },			 	 	
			{name: 'ORG_AC_DATE'		, text: '발생일'  		, type: 'string'  },			 	 	
			{name: 'ORG_SLIP_NUM'		, text: '번호'  			, type: 'string'  },			 	 	
			{name: 'ACCNT'				, text: '계정코드'  		, type: 'string'  },			 	 	
			{name: 'ACCNT_NAME'			, text: '계정명'  		, type: 'string'  },			 	 	
			{name: 'BANK_CODE'			, text: '은행코드'  		, type: 'string'  },			 	 	
			{name: 'BANK_NAME'			, text: '은행명'  		, type: 'string'  },			 	 	
			{name: 'ACCOUNT_NUM'		, text: '계좌번호'  		, type: 'string'  },			 	 	
			{name: 'ACCOUNT_NUM_EXPOS'	, text: '계좌번호'			, type: 'string'	, type: 'string'	, defaultValue:'***************'},
			{name: 'BANKBOOK_NAME'		, text: '예금주명'  		, type: 'string'  }
		]
	});
	
	
	
	/** Store 정의(Service 정의)
	 * @type 
	 */					
	var masterStore = Unilite.createStore('abh230skrMasterStore',{
		model	: 'abh230skrModel',
		uniOpt	: {
			isMaster	: true,				// 상위 버튼 연결 
			editable	: false,			// 수정 모드 사용 
			deletable	: false,			// 삭제 가능 여부 
			useNavi 	: false				// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy	: {
			type: 'direct',
			api	: {			
				   read: 'abh230skrService.selectList'					
			}
		},
		
		loadStoreRecords : function()	{
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		},
		
		listeners: {
		  	load: function(store, records, successful, eOpts) {
//				//조회된 데이터가 있을 때, 합계 보이게 설정 변경
//				var viewNormal = masterGrid.getView();
//				if(store.getCount() > 0){
//					viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
//				
//				}else{
//					viewNormal.getFeature('masterGridTotal').toggleSummaryRow(false);
//					alert (Msg.sMB015)
//				}
			}		  		
	  	}			
	});

	
	
	/** 검색조건 (Search Panel)
	 * @type 
	 */ 
	var panelSearch = Unilite.createSearchPanel('searchForm', {		  
		title		: '검색조건',		 
		defaultType	: 'uniSearchSubPanel',
		collapsed	: UserInfo.appOption.collapseLeftSearch,
		listeners	: {
			collapse: function () {
				panelResult.show();
			},
			expand: function() {
				panelResult.hide();
			}
		},
		items: [{	 
			title	: '기본정보',   
			itemId	: 'search_panel1',
			layout	: {type: 'uniTable', columns: 1},
			items	: [{ 
				fieldLabel		: '이체일자',
				xtype			: 'uniDateRangefield',
				startFieldName	: 'SEND_DATE_FR',
				endFieldName	: 'SEND_DATE_TO',
				startDate		: UniDate.get('today'),
				endDate			: UniDate.get('today'),
				allowBlank		: false,					
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('SEND_DATE_FR', newValue);						
//						panelResult.setValue('SEND_DATE_TO', newValue);						
					}
//					if(panelSearch) {
//						panelSearch.setValue('SEND_DATE_TO',newValue);
//					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('SEND_DATE_TO', newValue);						
					}
				}
			},{
				fieldLabel	: '사업장',
				name		: 'DIV_CODE', 
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				multiSelect	: false, 
				typeAhead	: false,
// 				value		: UserInfo.divCode,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},
			Unilite.popup('CUST',{
				fieldLabel		: '지급처', 
				valueFieldName	: 'PAY_CUSTOM_CODE',
				textFieldName	: 'PAY_CUSTOM_NAME',
				valueFieldWidth	: 90,
				textFieldWidth	: 140,
				listeners: {
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('PAY_CUSTOM_CODE', newValue);	
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('PAY_CUSTOM_NAME', newValue);	
					}
				}
			}),{
				xtype		: 'radiogroup',							
				fieldLabel	: '이체결과',
				id			: 'resultTransfer_S',
				items		: [{
					boxLabel	: '전체', 
					name		: 'RESULT_TRANSFER',
					width		: 60,
					inputValue	: 'A', 
					checked		: true   
				},{
					boxLabel	: '이체완료', 
					name		: 'RESULT_TRANSFER',
					width		: 90,
					inputValue	: 'Y'
				},{
					boxLabel	: '오류', 
					name		: 'RESULT_TRANSFER',
					width		: 70,
					inputValue	: 'E'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {	
						panelResult.getField('RESULT_TRANSFER').setValue(newValue.RESULT_TRANSFER);
					}
				}
			},{
				xtype		: 'uniTextfield',
				fieldLabel	: '예금주',
				name		: 'RCPT_NAME',
				width		: 325,
		 		listeners	: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('RCPT_NAME', newValue);
					}
				}
			}, {               
                //복호화 플래그(복호화 버튼 누를시 플래그 'Y')
                name:'DEC_FLAG', 
                xtype: 'uniTextfield',
                hidden: true
            }]
		}]
	});	
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 3
//		,tableAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/},
//		tdAttrs	: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
		},
		padding	: '1 1 1 1',
		border	: true,
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		items	: [{ 
			fieldLabel	: '이체일자',
			xtype		: 'uniDateRangefield',
			startFieldName: 'SEND_DATE_FR',
			endFieldName: 'SEND_DATE_TO',
			startDate	: UniDate.get('today'),
			endDate		: UniDate.get('today'),
			allowBlank	: false,					
			tdAttrs		: {width: 380},  
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('SEND_DATE_FR', newValue);						
//					panelSearch.setValue('SEND_DATE_TO', newValue);						
				}
//				if(panelResult) {
//					panelResult.setValue('SEND_DATE_TO',newValue);
//				}

			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('SEND_DATE_TO', newValue);						
				}
			}
		},{
			fieldLabel	: '사업장',
			name		: 'DIV_CODE', 
			xtype		: 'uniCombobox',
			multiSelect	: false, 
			typeAhead	: false,
			// value:UserInfo.divCode,
			comboType	: 'BOR120',
			colspan		: 2,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},
		Unilite.popup('CUST',{
			fieldLabel		: '지급처', 
			valueFieldName	: 'PAY_CUSTOM_CODE',
			textFieldName	: 'PAY_CUSTOM_NAME',
			valueFieldWidth	: 90,
			textFieldWidth	: 140,
			listeners: {
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('PAY_CUSTOM_CODE', newValue);	
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('PAY_CUSTOM_NAME', newValue);	
				}
			}
		}),{
			xtype		: 'radiogroup',							
			fieldLabel	: '이체결과',
			id			: 'resultTransfer_R',
			colspan		: 2,
			items		: [{
				boxLabel	: '전체', 
				name		: 'RESULT_TRANSFER',
				width		: 60,
				inputValue	: 'A',
				checked		: true 
			},{
				boxLabel	: '이체완료', 
				name		: 'RESULT_TRANSFER',
				width		: 90,
				inputValue	: 'Y'  
			},{
				boxLabel	: '오류', 
				name		: 'RESULT_TRANSFER',
				width		: 70,
				inputValue	: 'E'
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {	
					panelSearch.getField('RESULT_TRANSFER').setValue(newValue.RESULT_TRANSFER);
				}
			}
		},{
			xtype		: 'uniTextfield',
			fieldLabel	: '예금주',
			name		: 'RCPT_NAME',
			width		: 325,
	 		listeners	: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('RCPT_NAME', newValue);
				}
			}
		}]	
	}); 
	
	
	
	/* Master Grid1 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid = Unilite.createGrid('abh230skrGrid', {
		// for tab		
		layout	: 'fit',
		region	: 'center',
		store	: masterStore,
		uniOpt	: {					
			useMultipleSorting	: true,		
			useLiveSearch		: true,		
			onLoadSelectFirst	: false,			
			dblClickToEdit		: false,		
			useGroupSummary		: false,		
			useContextMenu		: false,	
			useRowNumberer		: true,	
			expandLastColumn	: false,		
			useRowContext		: false,	
			filter: {				
				useFilter		: true,
				autoCreate		: true
			}			
		},
        tbar:[{
            xtype:'button',
            text:'이체결과현황 출력',
            handler:function()  {                
                var param = panelResult.getValues();
                var win = Ext.create('widget.PDFPrintWindow', {
                url: CPATH+'/abh/abh230rkrPrint.do',
                prgID: 'abh230rkr',
                   extParam: {                          
                      SEND_DATE_FR      : param.SEND_DATE_FR,
                      SEND_DATE_TO      : param.SEND_DATE_TO,
                      PAY_CUSTOM_CODE   : param.PAY_CUSTOM_CODE,
                      PAY_CUSTOM_NAME   : param.PAY_CUSTOM_NAME,
                      RESULT_TRANSFER   : param.RESULT_TRANSFER,
                      RCPT_NAME         : param.RCPT_NAME,
                      JIM_ITEM_NAME     : param.JIM_ITEM_NAME
                   }
                });
                win.center();
                win.show();
            }
        }],				
		features: [ {id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false },
				   	{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false} ],
		columns	: [ 
	  			{ dataIndex: 'SEND_DATE'			, width: 120},
				{ dataIndex: 'PAY_CUSTOM_CODE'		, width: 100},
				{ dataIndex: 'CUSTOM_NAME'			, width: 140},
				{ dataIndex: 'COMPANY_NUM'			, width: 140},
				{ dataIndex: 'REMARK'				, width: 220},
				{ dataIndex: 'J_AMT_I'				, width: 140},
				{ dataIndex: 'SEND_YN'				, width: 100},
				{ dataIndex: 'RETURN_YN'			, width: 100},
				{ dataIndex: 'REASON_MSG'			, width: 180},
				{ dataIndex: 'ORG_AC_DATE'			, width: 120},
				{ dataIndex: 'ORG_SLIP_NUM'			, width: 100},
				{ dataIndex: 'ACCNT'				, width: 100	, hidden: true},
				{ dataIndex: 'ACCNT_NAME'			, width: 140},
				{ dataIndex: 'BANK_CODE'			, width: 100	, hidden: true},
				{ dataIndex: 'BANK_NAME'			, width: 140},
				{ dataIndex: 'ACCOUNT_NUM'			, width: 140	, hidden: true},
				{ dataIndex: 'ACCOUNT_NUM_EXPOS'	, width: 160	, align:'center'},
				{ dataIndex: 'BANKBOOK_NAME'		, width: 120}
		] ,
		listeners:{
			onGridDblClick:function(grid, record, cellIndex, colName, td)	{
				if(colName =="ACCOUNT_NUM_EXPOS") {
					grid.ownerGrid.openCryptPopup(record);
				}
			}			
		},
		openCryptPopup:function( record )	{
			if(record)	{
				var params = {'BANK_ACCOUNT': record.get('ACCOUNT_NUM'), 'GUBUN_FLAG': '2', 'INPUT_YN': 'N'}
				Unilite.popupCipherComm('grid', record, 'ACCOUNT_NUM_EXPOS', 'ACCOUNT_NUM', params);
			}
				
		}		
	});   	
	
	var decrypBtn = Ext.create('Ext.Button',{
        text:'복호화',
        width: 80,
        handler: function() {
            var needSave = !UniAppManager.app.getTopToolbar().getComponent('save').isDisabled();
            if(needSave){
               alert(Msg.sMB154); //먼저 저장하십시오.
               return false;
            }
            panelSearch.setValue('DEC_FLAG', 'Y');
            UniAppManager.app.onQueryButtonDown();
            panelSearch.setValue('DEC_FLAG', '');
        }
    });
	
	Unilite.Main({
		id  		: 'abh230skrApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	:[
				masterGrid, panelResult
			]
		},
			panelSearch  	
		],
		
		fnInitBinding : function() {
			if((Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE == ''){					//회계담당자가 없을 경우 알림 메세지
				Ext.Msg.alert('확인',Msg.sMA0054);
			}
			this.setDefault();
            
			var tbar = masterGrid._getToolBar();
            tbar[0].insert(tbar.length + 1, decrypBtn);
            
			//초기화 시 이체일자로 포커스 이동
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('SEND_DATE_FR');
		},
		
		onQueryButtonDown : function()	{			
			if(!this.isValidSearchForm()){
				return false;
			}
			masterGrid.getStore().loadStoreRecords();
		},
		
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			
			masterGrid.getStore().loadData({});
			masterStore.clearData();
			
			this.fnInitBinding();
		},											
		
		setDefault: function(){
			//panelSearch 초기값 세팅
			panelSearch.setValue('SEND_DATE_FR', UniDate.get('today'));
			panelSearch.setValue('SEND_DATE_TO', UniDate.get('today'));
			panelSearch.getField('RESULT_TRANSFER').setValue('A');
			
			//panelResult 초기값 세팅
			panelResult.setValue('SEND_DATE_FR', UniDate.get('today'));
			panelResult.setValue('SEND_DATE_TO', UniDate.get('today'));
			panelSearch.getField('RESULT_TRANSFER').setValue('A');

			UniAppManager.setToolbarButtons(['reset'], true);
		}
	});
};


</script>
