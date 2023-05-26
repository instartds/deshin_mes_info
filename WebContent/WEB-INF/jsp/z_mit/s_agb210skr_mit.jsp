<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<t:appConfig pgmId="s_agb210skr_mit">
	<t:ExtComboStore comboType="BOR120" pgmId="s_agb210skr_mit" /> 			<!-- 사업장 --> 
	<t:ExtComboStore comboType="AU" comboCode="B004" /> <!-- 화폐단위-->
</t:appConfig>

<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    

.x-change-cell_light_Yellow	{	background-color: #FFFFA1;	}
.x-change-cell_yellow		{	background-color: #FAED7D;	}
</style>

<script type="text/javascript">

function appMain() {
	var getStDt = ${getStDt};
	var getChargeCode = ${getChargeCode};
	
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('S_agb210skr_mitModel', {
		fields: [  	  
			{name: 'ACCNT'   				, text: '계정코드' 			,type: 'string'},
			{name: 'ACCNT_NAME'   			, text: '계정과목명'			,type: 'string'},
			{name: 'CUSTOM_CODE'			, text: '거래처' 			,type: 'string'},
			{name: 'CUSTOM_NAME'			, text: '거래처명' 			,type: 'string'},
			{name: 'AC_DATE'				, text: '전표일' 			,type: 'uniDate'},
			{name: 'SLIP_NUM'				, text: '번호' 			,type: 'string'},
			{name: 'SLIP_SEQ'				, text: '순번' 			,type: 'string'},
			{name: 'REMARK'					, text: '적요' 			,type: 'string'},
			{name: 'DR_AMT_I'				, text: '차변금액' 			,type: 'uniPrice'},
			{name: 'CR_AMT_I'				, text: '대변금액' 			,type: 'uniPrice'},
			{name: 'JAN_AMT_I'				, text: '잔액' 			,type: 'uniPrice'},
			{name: 'MONEY_UNIT'				, text: '화폐' 			,type: 'string'},
			{name: 'EXCHG_RATE'				, text: '환율' 			,type: 'float', decimalPrecision:4, format:'0,000.0000'},
			{name: 'DR_FOR_AMT_I'			, text: '외화차변금액' 		,type: 'float', decimalPrecision:3, format:'0,000.00'},
			{name: 'CR_FOR_AMT_I'			, text: '외화대변금액' 		,type: 'float', decimalPrecision:3, format:'0,000.00'},
			{name: 'JAN_FOR_AMT_I'			, text: '외화잔액' 			,type: 'float', decimalPrecision:3, format:'0,000.00'},
			{name: 'GUBUN'					, text: 'GUBUN' 		,type: 'string'},
			{name: 'IWALL_GUBUN'   			, text: 'IWALL_GUBUN' 	,type: 'string'},
			{name: 'INPUT_PATH'   			, text: 'INPUT_PATH' 	,type: 'string'},
			{name: 'INPUT_DIVI'				, text: 'INPUT_DIVI' 	,type: 'string'},
			{name: 'DIV_CODE'  				, text: '사업장' 			,type: 'string'}
		]
	});
	
//	// GroupField string type으로 변환
//	function dateToString(v, record){
//		return UniDate.safeFormat(v);
//	  }

	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('s_agb210skr_mitMasterStore1',{
		model: 'S_agb210skr_mitModel',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결 
			editable: false,		// 수정 모드 사용 
			deletable:false,		// 삭제 가능 여부 
			useNavi : false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {
				read: 'S_agb210skr_mitService.selectList'
			}
		},
		loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
			}
		}
	});

	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '검색조건',
		defaultType: 'uniSearchSubPanel',
		collapsed: true,
		listeners: {
			collapse: function () {
				panelResult.show();
			},
			expand: function() {
				panelResult.hide();
			}
		},
		items: [{
			title: '기본정보',
			itemId: 'search_panel1',
			layout: {type: 'uniTable', columns: 1},
			defaultType: 'uniTextfield',
			items: [{
				fieldLabel: '전표일',
				xtype: 'uniDateRangefield',
				startFieldName: 'FR_DATE',
				endFieldName: 'TO_DATE',
				allowBlank: false,
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('FR_DATE',newValue);
						UniAppManager.app.fnSetStDate(newValue);
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('TO_DATE',newValue);
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
						panelResult.setValue('ACCNT_DIV_CODE', newValue);
					}
				}
			},
			Unilite.popup('ACCNT',{ 
				fieldLabel: '계정과목', 
				valueFieldName: 'ACCNT_CODE_FR',
				textFieldName: 'ACCNT_NAME_FR',
				autoPopup:true,
				listeners: {
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('ACCNT_CODE_FR', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('ACCNT_NAME_FR', newValue);				
					},
					applyExtParam:{
						scope:this,
						fn:function(popup){
							var param = {
								'ADD_QUERY' : " EXISTS (SELECT 'X' FROM BSA100T X WHERE A.COMP_CODE = X.COMP_CODE AND A.ACCNT = X.SUB_CODE AND X.MAIN_CODE = 'AX01')",
								'CHARGE_CODE': ''
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
				autoPopup:true,
				listeners: {
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('ACCNT_CODE_TO', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('ACCNT_NAME_TO', newValue);				
					},
					applyExtParam:{
						scope:this,
						fn:function(popup){
							var param = {
								'ADD_QUERY' : " EXISTS (SELECT 'X' FROM BSA100T X WHERE A.COMP_CODE = X.COMP_CODE AND A.ACCNT = X.SUB_CODE AND X.MAIN_CODE = 'AX01')",
								'CHARGE_CODE': ''
							}
							popup.setExtParam(param);
						}
					}
				}
			}),
			Unilite.popup('CUST',{
				fieldLabel: '거래처',
				valueFieldName: 'CUST_CODE_FR',
				textFieldName: 'CUST_NAME_FR',
				autoPopup:true,
				listeners: {
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('CUST_CODE_FR', newValue);
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('CUST_NAME_FR', newValue);
					},
					applyextparam: function(popup){
						//popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}
			}),
			Unilite.popup('CUST',{
				fieldLabel: '~',
				valueFieldName: 'CUST_CODE_TO',
				textFieldName: 'CUST_NAME_TO',
				autoPopup:true,
				listeners: {
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('CUST_CODE_TO', newValue);
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('CUST_NAME_TO', newValue);
					},
					applyextparam: function(popup){
						//popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}
			})
		]},{
			title:'추가정보',
			id: 'search_panel2',
			itemId:'search_panel2',
			defaultType: 'uniTextfield',
			layout : {type : 'uniTable', columns : 1},
			defaultType: 'uniTextfield',
			items:[{
				fieldLabel: '당기시작년월',
				xtype: 'uniMonthfield',
				name: 'START_DATE',
				allowBlank:false
			},{
				fieldLabel: '화폐단위',
				name:'MONEY_UNIT', 
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'B004',
				displayField: 'value'
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
				xtype: 'radiogroup',		            		
				fieldLabel: '과목구분',
				id:'accountLevelSe',
				items: [{
					boxLabel: '과목', 
					width: 70, 
					name: 'ACCOUNT_LEVEL',
					inputValue: '1'
				},{
					boxLabel : '세목', 
					width: 70,
					name: 'ACCOUNT_LEVEL',
					inputValue: '2',
					checked: true  
				}]
			},{
				xtype: 'radiogroup',		            		
				fieldLabel: '출력형식',
				id:'printKind',
				items: [{
					boxLabel: '세로', 
					width: 70, 
					name: 'OUTPUT_TYPE',
					inputValue: 'A'
				},{
					boxLabel : '가로', 
					width: 70,
					name: 'OUTPUT_TYPE',
					inputValue: 'B',
					checked: true  
				}]
			}]
		}]
	});	//end panelSearch

	var panelResult = Unilite.createSearchForm('resultForm',{
		region: 'north',
		layout : {type : 'uniTable', columns : 2},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{ 
			fieldLabel: '전표일',
			xtype: 'uniDateRangefield',  
			startFieldName: 'FR_DATE',
			endFieldName: 'TO_DATE',
			allowBlank:false,
			width: 315,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('FR_DATE',newValue);
					UniAppManager.app.fnSetStDate(newValue);
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('TO_DATE',newValue);
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
					panelSearch.setValue('ACCNT_DIV_CODE', newValue);
				}
			}
		},
		Unilite.popup('ACCNT',{
			fieldLabel: '계정과목',
			valueFieldName: 'ACCNT_CODE_FR',
			textFieldName: 'ACCNT_NAME_FR', 
			autoPopup:true,
			listeners: {
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('ACCNT_CODE_FR', newValue);								
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('ACCNT_NAME_FR', newValue);				
				},
				applyExtParam:{
					scope:this,
					fn:function(popup){
						var param = {
							'ADD_QUERY' : " EXISTS (SELECT 'X' FROM BSA100T X WHERE A.COMP_CODE = X.COMP_CODE AND A.ACCNT = X.SUB_CODE AND X.MAIN_CODE = 'AX01')",
							'CHARGE_CODE': ''
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
			autoPopup:true,
			listeners: {
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('ACCNT_CODE_TO', newValue);								
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('ACCNT_NAME_TO', newValue);				
				},
				applyExtParam:{
					scope:this,
					fn:function(popup){
						var param = {
							'ADD_QUERY' : " EXISTS (SELECT 'X' FROM BSA100T X WHERE A.COMP_CODE = X.COMP_CODE AND A.ACCNT = X.SUB_CODE AND X.MAIN_CODE = 'AX01')",
							'CHARGE_CODE': ''
						}
						popup.setExtParam(param);
					}
				}
			}
		}),
		Unilite.popup('CUST',{
			fieldLabel: '거래처',
			valueFieldName: 'CUST_CODE_FR',
			textFieldName: 'CUST_NAME_FR',
			autoPopup:true,
			listeners: {
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('CUST_CODE_FR', newValue);
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('CUST_NAME_FR', newValue);
				},
				applyextparam: function(popup){
					//popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
				}
			}
		}),   	
		Unilite.popup('CUST',{
			fieldLabel: '~',
			valueFieldName: 'CUST_CODE_TO',
			textFieldName: 'CUST_NAME_TO',
			autoPopup:true,
			listeners: {
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('CUST_CODE_TO', newValue);
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('CUST_NAME_TO', newValue);
				},
				applyextparam: function(popup){
					//popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
				}
			}
		})]
	});

	/**
	 * Master Grid1 정의(Grid Panel)
	 * @type 
	 */

	var masterGrid = Unilite.createGrid('s_agb210skr_mitGrid1', {
		layout : 'fit',
		region : 'center',
		store : directMasterStore, 
		uniOpt:{	
			expandLastColumn: false,	//마지막 컬럼 * 사용 여부
			useRowNumberer: true,		//첫번째 컬럼 순번 사용 여부
			useLiveSearch: true,		//찾기 버튼 사용 여부
			useRowContext: true,			
			onLoadSelectFirst	: true,
			filter: {					//필터 사용 여부
				useFilter: true,
				autoCreate: true
			},
			excel: {
				useExcel: true,			//엑셀 다운로드 사용 여부
				exportGroup : false, 		//group 상태로 export 여부
				onlyData:false,
				summaryExport:false
			}
		},
		enableColumnHide: false,
		sortableColumns : false,
		store: directMasterStore,
		features: [{
			id: 'masterGridSubTotal',
			ftype: 'uniGroupingsummary',
			showSummaryRow: false,
			enableGroupingMenu:false
		},{
			id: 'masterGridTotal',
			ftype: 'uniSummary',
			showSummaryRow: false,
			enableGroupingMenu:false
		}],
		columns: [        
			{dataIndex: 'ACCNT'   			, width: 100 , align : 'center' ,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
				}
			},
			{dataIndex: 'ACCNT_NAME'   		, width: 200},
			{dataIndex: 'CUSTOM_CODE'		, width: 100},
			{dataIndex: 'CUSTOM_NAME'		, width: 300},
			
			{dataIndex: 'AC_DATE'			, width: 100},
			{dataIndex: 'SLIP_NUM'			, width:  66},
			{dataIndex: 'SLIP_SEQ'			, width:  66},
			{dataIndex: 'REMARK'			, width: 300},
			{dataIndex: 'DR_AMT_I'			, width: 130 , summaryType: 'sum'},
			{dataIndex: 'CR_AMT_I'  		, width: 130 , summaryType: 'sum'},
			{dataIndex: 'JAN_AMT_I'  		, width: 130 , summaryType: 'sum'},
			{dataIndex: 'MONEY_UNIT'		, width:  88},
			{dataIndex: 'EXCHG_RATE'		, width:  88},
			{dataIndex: 'DR_FOR_AMT_I'		, width: 130 , summaryType: 'sum'},
			{dataIndex: 'CR_FOR_AMT_I' 		, width: 130 , summaryType: 'sum'},
			{dataIndex: 'JAN_FOR_AMT_I'		, width: 130 , summaryType: 'sum'}
		],
		listeners: {
			
		},
		viewConfig: {
			getRowClass: function(record, rowIndex, rowParams, store) {
				var cls = '';
				
				//이월금액
				if(record.get('GUBUN') == '0') {
					cls = 'x-change-cell_light';
				}
				//소계(월)
				if(record.get('GUBUN') == '3') {
					cls = 'x-change-cell_normal';
				}
				//누계
				else if(record.get('GUBUN') == '4') {
					cls = 'x-change-cell_dark';
				}
				return cls;
			}
		}
	});

	Unilite.Main( {
		border: false,
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult
			]},
			panelSearch  	
		],
		id : 's_agb210skr_mitApp',
		fnInitBinding : function(params) {
			panelSearch.setValue('ACCNT_DIV_CODE', UserInfo.divCode);
			panelResult.setValue('ACCNT_DIV_CODE', UserInfo.divCode);
			
			UniAppManager.setToolbarButtons('detail', false);
			UniAppManager.setToolbarButtons('reset', false);
			
			panelSearch.setValue('FR_DATE', UniDate.get('startOfMonth'));
			panelResult.setValue('FR_DATE', UniDate.get('startOfMonth'));
			
			panelSearch.setValue('TO_DATE', UniDate.get('today'));
			panelResult.setValue('TO_DATE', UniDate.get('today'));
			
			panelSearch.getField('ACCOUNT_NAME').setValue(UserInfo.refItem);
			
			panelSearch.setValue('START_DATE', getStDt[0].STDT);
			
			var activeSForm;
			if(!UserInfo.appOption.collapseLeftSearch) {
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('FR_DATE');
			
			if(!Ext.isEmpty(params && params.PGM_ID)) {
				this.processParams(params);
			}
		},
		onQueryButtonDown : function()	{
			if(!UniAppManager.app.isValidSearchForm()) {
				return false;
			}
			
			directMasterStore.loadStoreRecords();
		},
		fnSetStDate:function(newValue) {
			if(newValue == null) {
				return false;
			}
			else {
				if(UniDate.getDbDateStr(newValue).substring(0, 6) < (UniDate.getDbDateStr(newValue).substring(0, 4) + UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6))) {
					panelSearch.setValue('START_DATE', UniDate.getDbDateStr(newValue).substring(0, 4)-1 + UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6));
				}
				else {
					panelSearch.setValue('START_DATE', UniDate.getDbDateStr(newValue).substring(0, 4) + UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6));
				}
			}
		},
		processParams: function(params) {
			this.uniOpt.appParams = params;
			if(params.PGM_ID == 's_agb200skr_mit') {
				panelSearch.setValue('FR_DATE',params.FR_DATE);
				panelSearch.setValue('TO_DATE',params.TO_DATE);
				panelSearch.setValue('ACCNT_DIV_CODE',params.ACCNT_DIV_CODE);
				panelSearch.setValue('ACCNT_DIV_NAME',params.ACCNT_DIV_NAME);
				
				panelSearch.setValue('ACCNT_CODE_FR',params.ACCNT);
				panelSearch.setValue('ACCNT_NAME_FR',params.ACCNT_NAME);
				panelSearch.setValue('ACCNT_CODE_TO',params.ACCNT);
				panelSearch.setValue('ACCNT_NAME_TO',params.ACCNT_NAME);
				
				panelSearch.setValue('START_DATE',params.START_DATE);
				panelSearch.setValue('ACCOUNT_NAME',params.ACCOUNT_NAME);
				panelSearch.setValue('ACCOUNT_LEVEL',params.ACCOUNT_LEVEL);
				
				panelSearch.setValue('CUST_CODE_FR',params.CUSTOM_CODE);
				panelSearch.setValue('CUST_CODE_TO',params.CUSTOM_CODE);
				panelSearch.setValue('CUST_NAME_FR',params.CUSTOM_NAME);
				panelSearch.setValue('CUST_NAME_TO',params.CUSTOM_NAME);
				
				Ext.getCmp('accountNameSe').setValue().ACCOUNT_NAME;
				Ext.getCmp('accountLevelSe').setValue().ACCOUNT_LEVEL;
				
				panelResult.setValue('FR_DATE',params.FR_DATE);
				panelResult.setValue('TO_DATE',params.TO_DATE);
				panelResult.setValue('ACCNT_DIV_CODE',params.ACCNT_DIV_CODE);
				panelResult.setValue('ACCNT_DIV_NAME',params.ACCNT_DIV_NAME);
				
				panelResult.setValue('ACCNT_CODE_FR',params.ACCNT);
				panelResult.setValue('ACCNT_NAME_FR',params.ACCNT_NAME);
				panelResult.setValue('ACCNT_CODE_TO',params.ACCNT);
				panelResult.setValue('ACCNT_NAME_TO',params.ACCNT_NAME);
				
				panelResult.setValue('CUST_CODE_FR',params.CUSTOM_CODE);
				panelResult.setValue('CUST_CODE_TO',params.CUSTOM_CODE);
				panelResult.setValue('CUST_NAME_FR',params.CUSTOM_NAME);
				panelResult.setValue('CUST_NAME_TO',params.CUSTOM_NAME);
				
				masterGrid.getStore().loadStoreRecords();
			}
		}
	});
};

</script>
