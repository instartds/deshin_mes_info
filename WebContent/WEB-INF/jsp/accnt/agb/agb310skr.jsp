<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<t:appConfig pgmId="agb310skr">
	<t:ExtComboStore comboType="BOR120" pgmId="agb310skr" /> 			<!-- 사업장 -->        
</t:appConfig>

<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>

<script type="text/javascript">

function appMain() {
	
	var getStDt = ${getStDt};
	
	/**
	 * Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Agb310skrModel', {
		fields: [  	  
			{name: 'ACCNT'   				, text: '계정코드' 		,type: 'string'},
			{name: 'ACCNT_NAME'   			, text: '계정과목명'		,type: 'string'},
			{name: 'PREV_JAN_AMT'  			, text: '전기(월)이월' 	,type: 'uniPrice'},
			{name: 'DR_AMT_I'				, text: '차변금액' 		,type: 'uniPrice'},
			{name: 'CR_AMT_I'  				, text: '대변금액' 		,type: 'uniPrice'},
			{name: 'JAN_AMT'	  			, text: '잔액' 		,type: 'uniPrice'}
		]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('agb310skrMasterStore',{
		model: 'Agb310skrModel',
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
				read: 'agb310skrService.selectList'                	
			}
		},
		loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '검색조건',
		defaultType: 'uniSearchSubPanel',
		collapsed:true,
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
				allowBlank:false,
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					panelResult.setValue('FR_DATE', newValue);
					UniAppManager.app.fnSetStDate(newValue);
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					panelResult.setValue('TO_DATE', newValue);
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
								'ADD_QUERY' : '',
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
				autoPopup: true,
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
								'ADD_QUERY' : '',
								'CHARGE_CODE': ''
							}
							popup.setExtParam(param);
						}
					}
				}
			}),
			Unilite.popup('CUST',{ 
				fieldLabel: '거래처',
				valueFieldName: 'CUST_CODE',
				textFieldName: 'CUST_NAME', 
				autoPopup:true,
				allowBlank:false,
				validateBlank:true,
				listeners: {
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('CUST_CODE', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('CUST_NAME', newValue);				
					},
					onSelected: {
						fn: function(records, type) {
							console.log('records : ', records);
							panelResult.setValue('CUSTOM_CODE', panelSearch.getValue('CUSTOM_CODE'));
							panelResult.setValue('CUSTOM_NAME', panelSearch.getValue('CUSTOM_NAME'));	
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('CUSTOM_CODE', '');
						panelResult.setValue('CUSTOM_NAME', '');
					}
				}
			})]
		},{
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
				name: 'ACCOUNT_NAME',
				items: [{
					boxLabel: '과목명1', 
					width: 70,
					inputValue: '0'
				},{
					boxLabel : '과목명2', 
					width: 70,
					inputValue: '1'
				},{
					boxLabel: '과목명3', 
					width: 70,
					inputValue: '2' 
				}]
			}]
		}]
	});
	
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
			width: 325,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				panelSearch.setValue('FR_DATE', newValue);
				UniAppManager.app.fnSetStDate(newValue);
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				panelSearch.setValue('TO_DATE', newValue);
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
							'ADD_QUERY' : '',
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
			autoPopup: true,
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
							'ADD_QUERY' : '',
							'CHARGE_CODE': ''
						}
						popup.setExtParam(param);
					}
				}
			}
		}),
		Unilite.popup('CUST',{ 
			fieldLabel: '거래처',
			valueFieldName: 'CUST_CODE',
			textFieldName: 'CUST_NAME', 
			colspan:2,
			autoPopup:true,
			allowBlank:false,
			validateBlank:true,
			listeners: {
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('CUST_CODE', newValue);								
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('CUST_NAME', newValue);				
				},
				onSelected: {
					fn: function(records, type) {
						console.log('records : ', records);
						panelSearch.setValue('CUSTOM_CODE', panelResult.getValue('CUSTOM_CODE'));
						panelSearch.setValue('CUSTOM_NAME', panelResult.getValue('CUSTOM_NAME'));	
					},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.setValue('CUSTOM_CODE', '');
					panelSearch.setValue('CUSTOM_NAME', '');
				}
			}
		})]
	});
	
	/**
	 * Master Grid1 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid = Unilite.createGrid('agb310skrGrid', {
		layout : 'fit',
		region : 'center',
		uniOpt : {	
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
			showSummaryRow: false 
		},{
			id: 'masterGridTotal', 	
			ftype: 'uniSummary', 	  
			showSummaryRow: true
		}],
		selModel:'rowmodel',
		columns: [        
			{dataIndex: 'ACCNT'   			, width: 100	, align : 'center'	,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
				}
			},
			{dataIndex: 'ACCNT_NAME'   		, width: 200	},
			{dataIndex: 'PREV_JAN_AMT'   	, width: 130	, summaryType: 'sum'	},
			{dataIndex: 'DR_AMT_I'			, width: 130	, summaryType: 'sum'	},
			{dataIndex: 'CR_AMT_I'  		, width: 130	, summaryType: 'sum'	},
			{dataIndex: 'JAN_AMT'  			, width: 130	, summaryType: 'sum'	}
		],
		listeners: {
			itemmouseenter:function(view, record, item, index, e, eOpts ) {
					view.ownerGrid.setCellPointer(view, item);
			},
			onGridDblClick :function( grid, record, cellIndex, colName ) {
                masterGrid.gotoAgb110(record);
        	}
		},
		gotoAgb110:function(record)	{
			if(record)	{
		    	var params = {
					action:'select',
					'PGM_ID'			: 'agb310skr',
					'FR_DATE' 			: panelSearch.getValue('FR_DATE'),
					'TO_DATE' 			: panelSearch.getValue('TO_DATE'),
					'ACCNT_DIV_CODE'	: panelSearch.getValue('ACCNT_DIV_CODE'),
					'ST_DATE'			: panelSearch.getValue('START_DATE'),
					'ACCNT' 			: record.get('ACCNT'),	
					'ACCNT_NAME' 		: record.get('ACCNT_NAME'),
					//20200330 추가
					'CUSTOM_CODE'		: panelSearch.getValue('CUST_CODE'),
					'CUSTOM_NAME'		: panelSearch.getValue('CUST_NAME')
				}
          		var rec1 = {data : {prgID : 'agb110skr', 'text':''}};							
				parent.openTab(rec1, '/accnt/agb110skr.do', params);
			}
	    }
	});
	
	Unilite.Main({
		border: false,
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult
			]
		},
			panelSearch  	
		],
		id : 'agb310skrApp',
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['detail', 'reset'], false);
			
			panelSearch.setValue('ACCNT_DIV_CODE',UserInfo.divCode);
			panelResult.setValue('ACCNT_DIV_CODE',UserInfo.divCode);
			
			panelSearch.setValue('FR_DATE',UniDate.get('startOfMonth'));
			panelResult.setValue('FR_DATE',UniDate.get('startOfMonth'));
			
			panelSearch.setValue('TO_DATE',UniDate.get('today'));
			panelResult.setValue('TO_DATE',UniDate.get('today'));
			
			panelSearch.getField('ACCOUNT_NAME').setValue(UserInfo.refItem);
			panelSearch.setValue('START_DATE', getStDt[0].STDT);
			
			var activeSForm;
			if(!UserInfo.appOption.collapseLeftSearch) {
				activeSForm = panelSearch;
			}
			else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('FR_DATE');
		},
		onQueryButtonDown : function()	{
			if(!UniAppManager.app.isValidSearchForm()){
				return false;
			}
			else {
				directMasterStore.loadStoreRecords();
			}
		},
		fnSetStDate:function(newValue) {
			if(newValue == null){
				return false;
			}
			else {
				if(UniDate.getDbDateStr(newValue).substring(0, 6) < (UniDate.getDbDateStr(newValue).substring(0, 4) + UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6))){
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
