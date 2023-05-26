<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<t:appConfig pgmId="s_agb200skr_mit">
	<t:ExtComboStore comboType="BOR120" pgmId="s_agb200skr_mit" /> 			<!-- 사업장 -->        
</t:appConfig>

<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}  

.x-change-cell_light_Yellow {	background-color: #FFFFA1;	}
.x-change-cell_yellow 		{	background-color: #FAED7D;	}

</style>

<script type="text/javascript">
function appMain() {
	var getStDt = ${getStDt};
	var gsChargeCode  = Ext.isEmpty(${getChargeCode}) ? ['']: ${getChargeCode};   //ChargeCode 관련 전역변수
	
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('S_agb200skr_mitModel', {
		fields: [
			{name: 'ACCNT'   		, text: '계정코드' 		,type: 'string'},
			{name: 'ACCNT_NAME'   	, text: '계정과목명'		,type: 'string'},
			{name: 'CUSTOM_CODE'	, text: '거래처' 		,type: 'string'},
			{name: 'CUSTOM_NAME'	, text: '거래처명' 		,type: 'string'},
			{name: 'COMPANY_NUM'	, text: '사업자번호' 	,type: 'string'},
			{name: 'TOP_NUM'		, text: '주민등록 번호'	,type: 'string'},
			{name: 'TOP_NUM_EXPOS'	, text: '주민등록 번호'	,type: 'string'},
			{name: 'IWALL_AMT'   	, text: '이월금액'		,type: 'uniPrice'},
			{name: 'BUSI_AMT'   	, text: '거래합계'		,type: 'uniPrice'},
			{name: 'DR_AMT_I'		, text: '차변금액'		,type: 'uniPrice'},
			{name: 'CR_AMT_I'  		, text: '대변금액'		,type: 'uniPrice'},
			{name: 'JAN_AMT_I'  	, text: '잔액' 		,type: 'uniPrice'},
			{name: 'GUBUN'			, text: '구분' 		,type: 'string'},
			{name: 'SORT_ACCNT'		, text: 'SORT_ACCNT',type: 'string'}
		]
	});

	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('s_agb200skr_mitMasterStore1',{
		model: 'S_agb200skr_mitModel',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결 
			editable: false,			// 수정 모드 사용 
			deletable:false,			// 삭제 가능 여부 
			useNavi : false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {
				read: 'S_agb200skr_mitService.selectList'
			}
		},
		loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		groupField: 'ACCNT',
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
								'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
							}
							popup.setExtParam(param);
						}
					}
				}
			}),{
				xtype: 'radiogroup',		            		
				fieldLabel: '거래합계',
				id: 'printKind',
				items: [{
					boxLabel: '미출력', 
					width: 70, 
					name: 'SUM',
					inputValue: '1',
					checked: true  
				},{
					boxLabel : '출력', 
					width: 70,
					name: 'SUM',
					inputValue: '2'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.getField('SUM').setValue(newValue.SUM);
						
						if(!UniAppManager.app.isValidSearchForm()){
							return false;
						}
						else {
							if(newValue.SUM == '1' ) {
								masterGrid.getColumn('BUSI_AMT').setVisible(false);
								masterGrid.reset();
								UniAppManager.app.onQueryButtonDown();
							}
							else if(newValue.SUM == '2' ) {
								masterGrid.getColumn('BUSI_AMT').setVisible(true);
								masterGrid.reset();
								UniAppManager.app.onQueryButtonDown();
							}
						}
					}
				}
			},
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
			}),{
				xtype: 'radiogroup',		            		
				fieldLabel: '금액기준',
				items: [{
					boxLabel: '발생', 
					width: 70, 
					name: 'JAN',
					inputValue: '1',
					checked: true  
				},{
					boxLabel : '잔액', 
					width: 70,
					name: 'JAN',
					inputValue: '2'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.getField('JAN').setValue(newValue.JAN);
						UniAppManager.app.onQueryButtonDown();
					}
				}
			}
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
				fieldLabel: '사업자등록번호',
				items: [{
					boxLabel: '출력', 
					width: 70, 
					name: 'COMP_NUM_YN',
					inputValue: 'A'
				},{
					boxLabel : '미출력', 
					width: 70,
					name: 'COMP_NUM_YN',
					inputValue: 'B',
					checked: true  
				}]
			}]		
		}]
	});	//end panelSearch
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
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
							'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
						}
						popup.setExtParam(param);
					}
				}
			}
		}),{
			xtype: 'radiogroup',		            		
			fieldLabel: '거래합계',
			items: [{
				boxLabel: '미출력', 
				width: 70, 
				name: 'SUM',
				inputValue: '1',
				checked: true  
			},{
				boxLabel : '출력', 
				width: 70,
				name: 'SUM',
				inputValue: '2'
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {		
					panelSearch.getField('SUM').setValue(newValue.SUM);
					
					if(!UniAppManager.app.isValidSearchForm()) {
						return false;
					}
					else {
						if(newValue.SUM == '1' ){
							masterGrid.getColumn('BUSI_AMT').setVisible(false);
							masterGrid.reset();
							UniAppManager.app.onQueryButtonDown();
						}else if(newValue.SUM == '2' ){
							masterGrid.getColumn('BUSI_AMT').setVisible(true);
							masterGrid.reset();
							UniAppManager.app.onQueryButtonDown();
						}
					}
				}
			}
		},
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
		}),{
			xtype: 'radiogroup',
			fieldLabel: '금액기준',
			items: [{
				boxLabel: '발생', 
				width: 70, 
				name: 'JAN',
				inputValue: '1',
				checked: true  
			},{
				boxLabel : '잔액', 
				width: 70,
				name: 'JAN',
				inputValue: '2'
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.getField('JAN').setValue(newValue.JAN);
					UniAppManager.app.onQueryButtonDown();
				}
			}
		}]
	});

	/**
	 * Master Grid1 정의(Grid Panel)
	 * @type 
	 */

	var masterGrid = Unilite.createGrid('s_agb200skr_mitGrid1', {
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
			}
		},
		store: directMasterStore,
		features: [{
			id: 'masterGridSubTotal',
			ftype: 'uniGroupingsummary', 
			showSummaryRow: true 
		},{
			id: 'masterGridTotal', 	
			ftype: 'uniSummary', 	  
			showSummaryRow: true
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
			{dataIndex: 'COMPANY_NUM'		, width: 120 , align : 'center'},
			{dataIndex: 'TOP_NUM_EXPOS'		, width: 120 , align : 'center'},
			{dataIndex: 'IWALL_AMT'   		, width: 130 , summaryType: 'sum'},
			{dataIndex: 'BUSI_AMT'   		, width: 130 , summaryType: 'sum'},
			{dataIndex: 'DR_AMT_I'			, width: 130 , summaryType: 'sum'},
			{dataIndex: 'CR_AMT_I'  		, width: 130 , summaryType: 'sum'},
			{dataIndex: 'JAN_AMT_I'  		, width: 130 , summaryType: 'sum'}
		],
		listeners: {
			itemmouseenter:function(view, record, item, index, e, eOpts ) {
				view.ownerGrid.setCellPointer(view, item);
			},
			onGridDblClick :function( grid, record, cellIndex, colName ) {
				if(!record.phantom) {
					masterGrid.gotoS_agb200skr_mit(record);
				}
			}
		},
		onItemcontextmenu:function( menu, grid, record, item, index, event  ) {
			return true;
		},
		uniRowContextMenu:{
			items: [{
				text	: '거래처별원장(영업) 보기',
				itemId:'agbItem',
				handler	: function(menuItem, event) {
					var param = menuItem.up('menu');
					masterGrid.gotoS_agb200skr_mit(param.record);
				}
			}]
		},
		gotoS_agb200skr_mit : function(record) {
			if(record.get("GUBUN") == '1') {
				if(record) {
					var params = {
						'PGM_ID'			: 's_agb200skr_mit',
						'FR_DATE' 			: panelSearch.getValue('FR_DATE'),								/* gsParam(0) */
						'TO_DATE'			: panelSearch.getValue('TO_DATE'),								/* gsParam(1) */
						'ACCNT_DIV_CODE' 	: panelSearch.getValue('ACCNT_DIV_CODE'),						/* gsParam(2) */
						'ACCNT'				: record.data['ACCNT'],											/* gsParam(7) */	
						'ACCNT_NAME' 		: record.data['ACCNT_NAME'],									/* gsParam(8) */
						'CUSTOM_CODE'		: record.data['CUSTOM_CODE'],  									/* gsParam(9) */
						'CUSTOM_NAME'		: record.data['CUSTOM_NAME'],	  	 							/* gsParam(10) */
						'START_DATE' 		: panelSearch.getValue('START_DATE'),							/* gsParam(11) */
						'ACCOUNT_NAME'		: Ext.getCmp('accountNameSe').getValue().ACCOUNT_NAME,			/* gsParam(12) */
						'ACCOUNT_LEVEL'		: Ext.getCmp('accountLevelSe').getValue().ACCOUNT_LEVEL			/* gsParam(13) */
					}
					var rec1 = {data : {prgID : 's_agb210skr_mit', 'text':''}};							
					parent.openTab(rec1, '/z_mit/s_agb210skr_mit.do', params);
				}
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
		id : 's_agb200skr_mitApp',
		fnInitBinding : function() {
			panelResult.setValue('ACCNT_DIV_CODE', UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail', false);
			UniAppManager.setToolbarButtons('reset', false);
			masterGrid.getColumn('BUSI_AMT').hidden = true;
			
			panelSearch.setValue('FR_DATE', UniDate.get('startOfMonth'));
			panelResult.setValue('FR_DATE', UniDate.get('startOfMonth'));
			
			panelSearch.setValue('TO_DATE', UniDate.get('today'));
			panelResult.setValue('TO_DATE', UniDate.get('today'));
			
			panelSearch.getField('ACCOUNT_NAME').setValue(UserInfo.refItem);
			
			panelSearch.setValue('START_DATE', getStDt[0].STDT);
			
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('FR_DATE');
		},
		onQueryButtonDown : function()	{
			if(!UniAppManager.app.isValidSearchForm()) {
				return false;
			}
			
			directMasterStore.loadStoreRecords();
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden()) {
				as.show();
			}
			else {
				as.hide()
			}
		},
		onPrintButtonDown: function() {
			var params		= Ext.getCmp('searchForm').getValues();
			var record		= masterGrid.getSelectedRecord();
			var divName		= '';
			var prgId		= '';
			var outputType	= '';
			
			if(panelSearch.getValue('ACCNT_DIV_CODE') == '' || panelSearch.getValue('ACCNT_DIV_CODE') == null ) {
				divName = Msg.sMAW002;  // 전체
			}
			else {
				divName = panelSearch.getField('ACCNT_DIV_CODE').getRawValue();
			}

			if(Ext.getCmp('printKind').getChecked()[0].inputValue  == '1') {
				prgId      = 'agb200rkr'; 	// 거래합계 미출력
				outputType = 'N';
			}
			else {
				prgId      = 'agb201rkr';    // 거래합계 출력
				outputType = 'Y';
			}

			var win = Ext.create('widget.PDFPrintWindow', {
				url: CPATH+'/accnt/agb200rkrPrint.do',
				prgID: prgId,
				extParam: {
					COMP_CODE		 		: UserInfo.compCode,
					FR_DATE  				: params.FR_DATE,			/* 전표일 FR */
					TO_DATE					: params.TO_DATE,			/* 전표일 TO */
					ACCNT_DIV_CODE			: params.ACCNT_DIV_CODE,	/* 사업장 CODE*/
					ACCNT_DIV_NAME			: divName,					/* 사업장 NAME */
					ACCNT_CODE_FR			: params.ACCNT_CODE_FR,		/* 계정과목 FR */
					ACCNT_NAME_FR			: params.ACCNT_NAME_FR,
					ACCNT_CODE_TO			: params.ACCNT_CODE_TO,		/* 계정과목 TO */
					ACCNT_NAME_TO			: params.ACCNT_NAME_TO,
					CUST_CODE_FR			: params.CUST_CODE_FR,		/* 거래처 FR */
					CUST_NAME_FR			: params.CUST_NAME_FR,
					CUST_CODE_TO			: params.CUST_CODE_TO,		/* 거래처 TO */
					CUST_NAME_TO			: params.CUST_NAME_TO,
					START_DATE				: params.START_DATE,
					ACCOUNT_NAME			: params.ACCOUNT_NAME,		/* 과목명 */
					SUM						: params.SUM,				/* 거래합계 */
					JAN						: params.JAN,				/* 금액기준 */
					ACCOUNT_LEVEL			: params.ACCOUNT_LEVEL,		/* 과목구분*/
					SANCTION_NO				: fnAgb200Init.PT_SANCTION_NO,
					OUTPUT_TYPE				: outputType,
					COMP_NUM_YN				: params.COMP_NUM_YN		/* 사업자등록번호 출력구분 report 용*/
				}
			});
			win.center();
			win.show();
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
		}
	});
};

</script>
