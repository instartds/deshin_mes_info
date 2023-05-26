<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="agb210skr">
	<t:ExtComboStore comboType="BOR120" pgmId="agb210skr"/>		<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B004"/>			<!-- 화폐단위-->
</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
	.x-change-cell_light_Yellow {
		background-color: #FFFFA1;
	}
	.x-change-cell_yellow {
		background-color: #FAED7D;
	}
</style>


<script type="text/javascript">

function appMain() {
	var getStDt			= ${getStDt};
	var getChargeCode	= ${getChargeCode};

	/** Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Agb210skrModel', {
		fields: [
			{name: 'ACCNT'			, text: '계정코드'			,type: 'string'},
			{name: 'ACCNT_NAME'		, text: '계정과목명'			,type: 'string'},
			{name: 'CUSTOM_CODE'	, text: '거래처'			,type: 'string'},
			{name: 'CUSTOM_NAME'	, text: '거래처명'			,type: 'string'},
			{name: 'AC_DATE'		, text: '전표일'			,type: 'uniDate'},
			{name: 'SLIP_NUM'		, text: '번호'			,type: 'string'},
			{name: 'SLIP_SEQ'		, text: '순번'			,type: 'string'},
			{name: 'REMARK'			, text: '적요'			,type: 'string'},
			{name: 'DR_AMT_I'		, text: '차변금액'			,type: 'uniPrice'},
			{name: 'CR_AMT_I'		, text: '대변금액'			,type: 'uniPrice'},
			{name: 'JAN_AMT_I'		, text: '잔액'			,type: 'uniPrice'},
			{name: 'MONEY_UNIT'		, text: '화폐'			,type: 'string'},
			{name: 'EXCHG_RATE'		, text: '환율'			,type: 'float', decimalPrecision:4, format:'0,000.0000'},
			{name: 'DR_FOR_AMT_I'	, text: '외화차변금액'		,type: 'float', decimalPrecision:3, format:'0,000.00'},
			{name: 'CR_FOR_AMT_I'	, text: '외화대변금액'		,type: 'float', decimalPrecision:3, format:'0,000.00'},
			{name: 'JAN_FOR_AMT_I'	, text: '외화잔액'			,type: 'float', decimalPrecision:3, format:'0,000.00'},
			{name: 'GUBUN'			, text: 'GUBUN'			,type: 'string'},
			{name: 'IWALL_GUBUN'	, text: 'IWALL_GUBUN'	,type: 'string'},
			{name: 'INPUT_PATH'		, text: 'INPUT_PATH'	,type: 'string'},
			{name: 'INPUT_DIVI'		, text: 'INPUT_DIVI'	,type: 'string'},
			{name: 'DIV_CODE'		, text: '사업장'			,type: 'string'}
		]
	});

	/** Store 정의(Service 정의)
	 * @type 
	 */
	var directMasterStore = Unilite.createStore('agb210skrMasterStore1',{
		model	: 'Agb210skrModel',
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결 
			editable	: false,	// 수정 모드 사용 
			deletable	: false,	// 삭제 가능 여부 
			useNavi		: false		// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy	: {
			type: 'direct',
			api	: {
				read: 'agb210skrService.selectList'
			}
		},
		loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		},/*
		groupField: 'ACCNT'*/
		listeners: {
			load: function(store, records, successful, eOpts) {
				var count = masterGrid.getStore().getCount();
				if(count > 0){
					//20200727 추가: 출력버튼 추가로 인쇄버튼 사용 안 함
					masterGrid.down('#printBtn').enable();
//					UniAppManager.setToolbarButtons(['print'], true);
				}else{
					//20200727 추가: 출력버튼 추가로 인쇄버튼 사용 안 함
					masterGrid.down('#printBtn').disable();
//					UniAppManager.setToolbarButtons(['print'], false);
				}
				
			}
		}
	});

	/** 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title		: '검색조건',
		defaultType	: 'uniSearchSubPanel',
		collapsed	: true,
		listeners	: {
			collapse: function () {
				panelResult.show();
			},
			expand: function() {
				panelResult.hide();
			}
		},
		items	: [{
			title		: '기본정보',
			itemId		: 'search_panel1',
			layout		: {type: 'uniTable', columns: 1},
			defaultType	: 'uniTextfield',
			items		: [{
				fieldLabel		: '전표일',
				xtype			: 'uniDateRangefield',
				startFieldName	: 'FR_DATE',
				endFieldName	: 'TO_DATE',
				allowBlank		: false,
				width			: 315,
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
				fieldLabel	: '사업장',
				name		: 'ACCNT_DIV_CODE', 
				xtype		: 'uniCombobox',
				multiSelect	: true, 
				typeAhead	: false,
				value		: UserInfo.divCode,
				comboType	: 'BOR120',
				width		: 325,
				colspan		: 2,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ACCNT_DIV_CODE', newValue);
					}
				}
			},/*{
				xtype	: 'container',
				layout	: {type : 'uniTable', columns : 2},
				items	: [
					Unilite.popup('ACCNT_DIV_CODE',{
	//				validateBlank	: false,
					listeners		: {
						onSelected: {
							fn: function(records, type) {
								if(records.length >= 2){
									panelSearch.down('#divLabel').setText('　외 ' + (records.length - 1) + '개 ');
	//								panelResult.down('#divLabel').setText('　외 ' + (records.length - 1) + '개 사업장');
								}else{
									panelSearch.down('#divLabel').setText('');
	//								panelResult.down('#divLabel').setText('');
								}
							},
							scope: this
						},
						onClear: function(type) {
							panelSearch.down('#divLabel').setText('');
	//						panelResult.down('#divLabel').setText('');
						},
						applyextparam: function(popup){
						}
					}
				}),{
					xtype	: 'label',
					name	: 'DIV_LABEL',
					itemId	: 'divLabel'
				}]
			},*/
			Unilite.popup('ACCNT',{
				fieldLabel		: '계정과목',
//				validateBlank	: false,
				valueFieldName	: 'ACCNT_CODE_FR',
				textFieldName	: 'ACCNT_NAME_FR',
				autoPopup		: true,
				listeners		: {
					/*onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('ACCNT_CODE_FR', panelResult.getValue('ACCNT_CODE_FR'));
							panelSearch.setValue('ACCNT_NAME_FR', panelResult.getValue('ACCNT_NAME_FR'));																											
						},
						scope: this
					},
					onClear: function(type) {
						panelSearch.setValue('ACCNT_CODE_FR', '');
						panelSearch.setValue('ACCNT_NAME_FR', '');
					},*/
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('ACCNT_CODE_FR', newValue);
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('ACCNT_NAME_FR', newValue);
					},
					applyextparam: function(popup){
						popup.setExtParam({'ADD_QUERY'	: "(BOOK_CODE1='A4' OR BOOK_CODE2='A4')"});			//WHERE절 추카 쿼리
						popup.setExtParam({'CHARGE_CODE': ''/*gsChargeCode*/});			//bParam(3)
					}
				}
			}),
			Unilite.popup('ACCNT',{ 
				fieldLabel		: '~',
				valueFieldName	: 'ACCNT_CODE_TO',
				textFieldName	: 'ACCNT_NAME_TO',
				autoPopup		: true,
				listeners		: {
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('ACCNT_CODE_TO', newValue);
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('ACCNT_NAME_TO', newValue);
					},
					/*onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('ACCNT_CODE_TO', panelResult.getValue('ACCNT_CODE_TO'));
							panelSearch.setValue('ACCNT_NAME_TO', panelResult.getValue('ACCNT_NAME_TO'));
						},
						scope: this
					},
					onClear: function(type) {
						panelSearch.setValue('ACCNT_CODE_TO', '');
						panelSearch.setValue('ACCNT_NAME_TO', '');
					},*/
					applyextparam: function(popup){
						popup.setExtParam({'ADD_QUERY'	: "(BOOK_CODE1='A4' OR BOOK_CODE2='A4')"});			//WHERE절 추카 쿼리
						popup.setExtParam({'CHARGE_CODE': ''/*gsChargeCode*/});			//bParam(3)
					}
				}
			}),
			Unilite.popup('CUST',{
				fieldLabel		: '거래처',
				valueFieldName	: 'CUST_CODE_FR',
				textFieldName	: 'CUST_NAME_FR', 
				allowBlank:true,
				autoPopup:false,
				validateBlank:false,
				listeners		: {
									onValueFieldChange:function( elm, newValue, oldValue) {						
										panelResult.setValue('CUST_CODE_FR', newValue);
										
										if(!Ext.isObject(oldValue)) {
											panelResult.setValue('CUST_NAME_FR', '');
											panelSearch.setValue('CUST_NAME_FR', '');
										}
									},
									onTextFieldChange:function( elm, newValue, oldValue) {
										panelResult.setValue('CUST_NAME_FR', newValue);
										
										if(!Ext.isObject(oldValue)) {
											panelResult.setValue('CUST_CODE_FR', '');
											panelSearch.setValue('CUST_CODE_FR', '');
										}
									}
				}
			}),
			Unilite.popup('CUST',{
				fieldLabel		: '~',
				valueFieldName	: 'CUST_CODE_TO',
				textFieldName	: 'CUST_NAME_TO', 
				allowBlank:true,
				autoPopup:false,
				validateBlank:false,
				listeners		: {
									onValueFieldChange:function( elm, newValue, oldValue) {						
										panelResult.setValue('CUST_CODE_TO', newValue);
										
										if(!Ext.isObject(oldValue)) {
											panelResult.setValue('CUST_NAME_TO', '');
											panelSearch.setValue('CUST_NAME_TO', '');
										}
									},
									onTextFieldChange:function( elm, newValue, oldValue) {
										panelResult.setValue('CUST_NAME_TO', newValue);
										
										if(!Ext.isObject(oldValue)) {
											panelResult.setValue('CUST_CODE_TO', '');
											panelSearch.setValue('CUST_CODE_TO', '');
										}
									}
				}
			})]},{
				title		:'추가정보',
 				id			: 'search_panel2',
				itemId		: 'search_panel2',
				defaultType	: 'uniTextfield',
				layout		: {type : 'uniTable', columns : 1},
				defaultType	: 'uniTextfield',
				items		: [{
					fieldLabel	: '당기시작년월',
					xtype		: 'uniMonthfield',
					name		: 'START_DATE',
					allowBlank	: false/*,
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('START_DATE', newValue);
						}
					}*/
				},{
					fieldLabel	: '화폐단위',
					name		: 'MONEY_UNIT', 
					xtype		: 'uniCombobox',
					comboType	: 'AU',
					comboCode	: 'B004',
					displayField: 'value'
				},{
					xtype		: 'radiogroup',
					fieldLabel	: '과목명',	
					id			: 'accountNameSe',
					items		: [{
						boxLabel	: '과목명1', 
						width		: 70, 
						name		: 'ACCOUNT_NAME',
						inputValue	: '0'
					},{
						boxLabel	: '과목명2', 
						width		: 70,
						name		: 'ACCOUNT_NAME',
						inputValue	: '1'
					},{
						boxLabel	: '과목명3', 
						width		: 70, 
						name		: 'ACCOUNT_NAME',
						inputValue	: '2' 
				}]/*,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.getField('ACCOUNT_NAME').setValue(newValue.ACCOUNT_NAME);
					}
				}*/
			},{
				xtype		: 'radiogroup',
				fieldLabel	: '과목구분',
				id			: 'accountLevelSe',
				items		: [{
					boxLabel	: '과목', 
					width		: 70, 
					name		: 'ACCOUNT_LEVEL',
					inputValue	: '1'
				},{
					boxLabel	: '세목', 
					width		: 70,
					name		: 'ACCOUNT_LEVEL',
					inputValue	: '2',
					checked		: true
				}]
			},{
				xtype		: 'radiogroup',
				fieldLabel	: '출력형식',
				id			: 'printKind',
				items		: [{
					boxLabel	: '세로', 
					width		: 70, 
					name		: 'OUTPUT_TYPE',
					inputValue	: 'A'
				},{
					boxLabel	: '가로', 
					width		: 70,
					name		: 'OUTPUT_TYPE',
					inputValue	: 'B',
					checked		: true  
				}]
			}]
				
		}]
		
	});	//end panelSearch

	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 2},
		padding	: '1 1 1 1',
		border	: true,
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		items	: [{
			fieldLabel		: '전표일',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'FR_DATE',
			endFieldName	: 'TO_DATE',
			allowBlank		: false,
			width			: 315,
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
			fieldLabel	: '사업장',
			name		: 'ACCNT_DIV_CODE', 
			xtype		: 'uniCombobox',
			multiSelect	: true, 
			typeAhead	: false,
			value		: UserInfo.divCode,
			comboType	: 'BOR120',
			width		: 325,
			colspan		: 2,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('ACCNT_DIV_CODE', newValue);
				}
			}
		},
		Unilite.popup('ACCNT',{
			fieldLabel		: '계정과목',
			valueFieldName	: 'ACCNT_CODE_FR',
			textFieldName	: 'ACCNT_NAME_FR',
			autoPopup		: true,
			listeners		: {
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('ACCNT_CODE_FR', newValue);
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('ACCNT_NAME_FR', newValue);
				},
				applyextparam: function(popup){
					popup.setExtParam({'ADD_QUERY'	: "(BOOK_CODE1='A4' OR BOOK_CODE2='A4')"});			//WHERE절 추카 쿼리
					popup.setExtParam({'CHARGE_CODE': ''/*gsChargeCode*/});			//bParam(3)
				}
			}
		}),
		Unilite.popup('ACCNT',{ 
			fieldLabel		: '~',
			valueFieldName	: 'ACCNT_CODE_TO',
			textFieldName	: 'ACCNT_NAME_TO',
			autoPopup		: true,
			listeners		: {
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('ACCNT_CODE_TO', newValue);
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('ACCNT_NAME_TO', newValue);
				},
				applyextparam: function(popup){
					popup.setExtParam({'ADD_QUERY'	: "(BOOK_CODE1='A4' OR BOOK_CODE2='A4')"});			//WHERE절 추카 쿼리
					popup.setExtParam({'CHARGE_CODE': ''/*gsChargeCode*/});			//bParam(3)
				}
			}
		}),
		Unilite.popup('CUST',{ 
			fieldLabel		: '거래처',
			valueFieldName	: 'CUST_CODE_FR',
			textFieldName	: 'CUST_NAME_FR', 
			allowBlank:true,
			autoPopup:false,
			validateBlank:false,
			listeners		: {
								onValueFieldChange:function( elm, newValue, oldValue) {						
									panelSearch.setValue('CUST_CODE_FR', newValue);
									
									if(!Ext.isObject(oldValue)) {
										panelResult.setValue('CUST_NAME_FR', '');
										panelSearch.setValue('CUST_NAME_FR', '');
									}
								},
								onTextFieldChange:function( elm, newValue, oldValue) {
									panelSearch.setValue('CUST_NAME_FR', newValue);
									
									if(!Ext.isObject(oldValue)) {
										panelResult.setValue('CUST_CODE_FR', '');
										panelSearch.setValue('CUST_CODE_FR', '');
									}
								}
			}
		}),	
		Unilite.popup('CUST',{ 
			fieldLabel		: '~',
			valueFieldName	: 'CUST_CODE_TO',
			textFieldName	: 'CUST_NAME_TO', 
			allowBlank:true,
			autoPopup:false,
			validateBlank:false,
			listeners		: {
								onValueFieldChange:function( elm, newValue, oldValue) {						
									panelSearch.setValue('CUST_CODE_TO', newValue);
									
									if(!Ext.isObject(oldValue)) {
										panelResult.setValue('CUST_NAME_TO', '');
										panelSearch.setValue('CUST_NAME_TO', '');
									}
								},
								onTextFieldChange:function( elm, newValue, oldValue) {
									panelSearch.setValue('CUST_NAME_TO', newValue);
									
									if(!Ext.isObject(oldValue)) {
										panelResult.setValue('CUST_CODE_TO', '');
										panelSearch.setValue('CUST_CODE_TO', '');
									}
								}
			}
		})/*,{
			fieldLabel	: '당기시작년월',
			xtype		: 'uniMonthfield',
			name		: 'START_DATE',
			hidden		: true,
			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('START_DATE', newValue);
				}
			}
		},{
			xtype		: 'radiogroup',
			fieldLabel	: '과목명',	
			colspan		: 2,
			hidden		: true,
			id			: 'accountNameRe',
			items		: [{
				boxLabel	: '과목명1', 
				width		: 70, 
				name		: 'ACCOUNT_NAME',
				inputValue	: '0'
			},{
				boxLabel	: '과목명2', 
				width		: 70,
				name		: 'ACCOUNT_NAME',
				inputValue	: '1'
			},{
				boxLabel	: '과목명3', 
				width		: 70, 
				name		: 'ACCOUNT_NAME',
				inputValue	: '2' 
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.getField('ACCOUNT_NAME').setValue(newValue.ACCOUNT_NAME);
				}
			}
		},{
			fieldLabel	: '화폐단위',
			name		: 'MONEY_UNIT', 
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B004',
			hidden		: true,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('MONEY_UNIT', newValue);
				}
			}
		},{
			xtype		: 'radiogroup',
			fieldLabel	: '과목구분',
			id			: 'accountLevelRe',
			hidden		: true,
			items		: [{
				boxLabel	: '과목', 
				width		: 70, 
				name		: 'ACCOUNT_LEVEL',
				inputValue	: '1'
			},{
				boxLabel	: '세목', 
				width		: 70,
				name		: 'ACCOUNT_LEVEL',
				inputValue	: '2',
				checked		: true
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.getField('ACCOUNT_LEVEL').setValue(newValue.ACCOUNT_LEVEL);
					UniAppManager.app.onQueryButtonDown();
				}
			}
		}*/]
	});

	/** Master Grid1 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid = Unilite.createGrid('agb210skrGrid1', {
		store	: directMasterStore,
		layout	: 'fit',
		region	: 'center',
		uniOpt	:{
			expandLastColumn	: false,	//마지막 컬럼 * 사용 여부
			useRowNumberer		: true,		//첫번째 컬럼 순번 사용 여부
			useLiveSearch		: true,		//찾기 버튼 사용 여부
			useRowContext		: true,
			onLoadSelectFirst	: true,
			filter				: {			//필터 사용 여부
				useFilter	: true,
				autoCreate	: true
			},
			excel: {
				useExcel		: true,		//엑셀 다운로드 사용 여부
				exportGroup		: false,	//group 상태로 export 여부
				onlyData		: false,
				summaryExport	: false
			}
		},
		enableColumnHide:false,
		sortableColumns	: false,
		//20200727 추가: 거래처별원장출력 (agb210rkr)로 링크가는 "출력" 버튼 생성
		tbar: [{
			text	: '출력',
			itemId	: 'printBtn',
			width	: 100,
			handler	: function() {
				var params		= panelSearch.getValues();
				params.PGM_ID	= 'agb210skr';
				//전송
				var rec1 = {data : {prgID : 'agb210rkr', 'text':''}};
				parent.openTab(rec1, '/accnt/agb210rkr.do', params);
			}
		}],
		features: [{
			id					: 'masterGridSubTotal',
			ftype				: 'uniGroupingsummary', 
			showSummaryRow		: false,
			enableGroupingMenu	: false 
		},{
			id					: 'masterGridTotal',
			ftype				: 'uniSummary',
			showSummaryRow		: false,
			enableGroupingMenu	: false 
		}],
		columns: [	
			{dataIndex: 'ACCNT'				, width: 100 ,align : 'center'},
			{dataIndex: 'ACCNT_NAME'		, width: 200},
			{dataIndex: 'CUSTOM_CODE'		, width: 100 },
			{dataIndex: 'CUSTOM_NAME'		, width: 300}, 
			{dataIndex: 'AC_DATE'			, width: 100},
			{dataIndex: 'SLIP_NUM'			, width: 66},
			{dataIndex: 'SLIP_SEQ'			, width: 66},
			{dataIndex: 'REMARK'			, width: 300},
			{dataIndex: 'DR_AMT_I'			, width: 130},
			{dataIndex: 'CR_AMT_I'			, width: 130},
			{dataIndex: 'JAN_AMT_I'			, width: 130},
			{dataIndex: 'MONEY_UNIT'		, width: 88},
			{dataIndex: 'EXCHG_RATE'		, width: 88},
			{dataIndex: 'DR_FOR_AMT_I'		, width: 130},
			{dataIndex: 'CR_FOR_AMT_I'		, width: 130},
			{dataIndex: 'JAN_FOR_AMT_I'		, width: 130}
		],
		listeners: {
			itemmouseenter:function(view, record, item, index, e, eOpts ) {
				view.ownerGrid.setCellPointer(view, item);
			},
			onGridDblClick :function( grid, record, cellIndex, colName ) {
				if(record.get("GUBUN") == '1'){
				masterGrid.gotoAgb(record);
				}
			}
		},
		onItemcontextmenu:function( menu, grid, record, item, index, event  ) {	 
			if(record.get("GUBUN") == '1'){
				if(record.get('INPUT_PATH') == '2') {
					menu.down('#linkAgj200ukr').hide();
					menu.down('#linkDgj100ukr').hide();
					menu.down('#linkAgj205ukr').show();
				} else if(record.get('INPUT_PATH') == 'Z3') {
					menu.down('#linkAgj200ukr').hide();
					menu.down('#linkAgj205ukr').hide();
					menu.down('#linkDgj100ukr').show();
				} else {
					menu.down('#linkAgj205ukr').hide();
					menu.down('#linkDgj100ukr').hide();
					menu.down('#linkAgj200ukr').show();
				}
				return true;
			}
		},	
		uniRowContextMenu:{
			items: [
				 {	text	: '회계전표입력 이동',   
					itemId	: 'linkAgj200ukr',
					handler	: function(menuItem, event) {
						var param = menuItem.up('menu');
						masterGrid.gotoAgb(param.record);
					}
				},{	text	: '회계전표입력(전표번호별) 이동',  
					itemId	: 'linkAgj205ukr', 
					handler	: function(menuItem, event) {
						var param = menuItem.up('menu');
						masterGrid.gotoAgb(param.record);
					}
				},{	text	: 'Dgj100urk',  
					itemId	: 'linkDgj100ukr', 
					handler	: function(menuItem, event) {
						var param = menuItem.up('menu');
						masterGrid.gotoAgb(param.record);
					}
				}
			]
		},
		gotoAgb:function(record) {
			if(record) {
				var params = {
					action:'select',
					'PGM_ID'	: 'agb210skr',
					'AC_DATE'	: UniDate.getDbDateStr(record.data['AC_DATE']),	/* gsParam(0) */
					'INPUT_PATH': record.data['INPUT_PATH'],					/* gsParam(2) */
					'SLIP_NUM'	: record.data['SLIP_NUM'],						/* gsParam(3) */
					'SLIP_SEQ'	: record.data['SLIP_SEQ'],						/* gsParam(4) */
//					''			: record.data[''],								/* gsParam(5) */
					'DIV_CODE'	: record.data['DIV_CODE']						/* gsParam(6) */
				}
				if(record.data['INPUT_DIVI'] == '2'){	
					var rec = {data : {prgID : 'agj205ukr', 'text':''}};
					parent.openTab(rec, '/accnt/agj205ukr.do', params);
				}
				else if(record.data['INPUT_PATH'] == 'Z3'){
					var rec = {data : {prgID : 'dgj100ukr', 'text':''}};
					parent.openTab(rec, '/accnt/dgj100ukr.do', params);
				}
				else{
					var rec = {data : {prgID : 'agj200ukr', 'text':''}};
					parent.openTab(rec, '/accnt/agj200ukr.do', params);
				}
			}
		},
		viewConfig: {
			getRowClass: function(record, rowIndex, rowParams, store){
				var cls = '';
				
				//이월금액
				if(record.get('GUBUN') == '0'){
					cls = 'x-change-cell_light';
				}
				//소계(월)
				if(record.get('GUBUN') == '3'){
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



	Unilite.Main({
		id			: 'agb210skrApp',
		border		: false,
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
					masterGrid, panelResult
				]
			},
			panelSearch
		],
		fnInitBinding : function(params) {
			panelSearch.setValue('ACCNT_DIV_CODE',UserInfo.divCode);
			panelResult.setValue('ACCNT_DIV_CODE',UserInfo.divCode);
			
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			
			panelSearch.getField('ACCOUNT_NAME').setValue(UserInfo.refItem);
				
			panelSearch.setValue('FR_DATE',UniDate.get('startOfMonth'));
			panelResult.setValue('FR_DATE',UniDate.get('startOfMonth'));
		
			panelSearch.setValue('TO_DATE',UniDate.get('today'));
			panelResult.setValue('TO_DATE',UniDate.get('today'));
			
			
			panelSearch.setValue('START_DATE',getStDt[0].STDT);
			
			if(!Ext.isEmpty(params && params.PGM_ID)){
				this.processParams(params);
			}
			
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch) {
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('FR_DATE');

			//20200727 추가: 출력버튼 추가
			masterGrid.down('#printBtn').disable();
		},
		onQueryButtonDown : function() {
			if(!UniAppManager.app.isValidSearchForm()){
				return false;
			}
			directMasterStore.loadStoreRecords();
		},
		onPrintButtonDown: function() {
			var param		= Ext.getCmp('searchForm').getValues();
			var prgId		= '';
			var outputType	= '';

			if(panelSearch.getValue('ACCNT_DIV_CODE') == '' || panelSearch.getValue('ACCNT_DIV_CODE') == null ){
				divName = Msg.sMAW002;  // 전체
			}else{
				divName = panelSearch.getField('ACCNT_DIV_CODE').getRawValue();
			}

			if(Ext.getCmp('printKind').getChecked()[0].inputValue  == 'A'){
				prgId	= 'agb210rkr'; 	// 세로모드
				outputType = 'HORIZON';
			}else{
				prgId	= 'agb211rkr';   // 가로모드
				outputType = 'VERTICAL'; 
			}

			var win = Ext.create('widget.PDFPrintWindow', {
				url: CPATH+'/accnt/agb210rkrPrint.do',
				prgID: prgId,
				extParam: {
					COMP_CODE		: UserInfo.compCode,
					FR_DATE			: param.FR_DATE,			/* 전표일 FR */
					TO_DATE			: param.TO_DATE,			/* 전표일 TO */
					ACCNT_DIV_CODE	: param.ACCNT_DIV_CODE,		/* 사업장 CODE*/
					ACCNT_DIV_NAME	: divName,					/* 사업장 NAME */
					ACCNT_CODE_FR	: param.ACCNT_CODE_FR,		/* 계정과목 FR */
					ACCNT_NAME_FR	: param.ACCNT_NAME_FR,
					ACCNT_CODE_TO	: param.ACCNT_CODE_TO,		/* 계정과목 TO */
					ACCNT_NAME_TO	: param.ACCNT_NAME_TO,
					CUST_CODE_FR	: param.CUST_CODE_FR,		/* 거래처 FR */
					CUST_NAME_FR	: param.CUST_NAME_FR,
					CUST_CODE_TO	: param.CUST_CODE_TO,		/* 거래처 TO */
					CUST_NAME_TO	: param.CUST_NAME_TO,
					START_DATE		: param.START_DATE,
					ACCOUNT_NAME	: param.ACCOUNT_NAME,		/* 과목명 */
					SUM				: param.SUM,				/* 거래합계 */
					JAN				: param.JAN,				/* 금액기준 */
					OUTPUT_TYPE		: outputType,
					ACCOUNT_LEVEL	: param.ACCOUNT_LEVEL		/* 과목구분*/
				}
			});
			win.center();
			win.show();  
		},	
		/*onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden()) {
				as.show();
			}else {
				as.hide()
			}
		},*/
		processParams: function(params) {
			this.uniOpt.appParams = params;
			if(params.PGM_ID == 'agb200skr') {
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

				/*panelResult.setValue('START_DATE',params.START_DATE);
				panelResult.setValue('ACCOUNT_NAME',params.ACCOUNT_NAME);
				panelResult.setValue('ACCOUNT_LEVEL',params.ACCOUNT_LEVEL);*/

				panelResult.setValue('CUST_CODE_FR',params.CUSTOM_CODE);
				panelResult.setValue('CUST_CODE_TO',params.CUSTOM_CODE);
				panelResult.setValue('CUST_NAME_FR',params.CUSTOM_NAME);
				panelResult.setValue('CUST_NAME_TO',params.CUSTOM_NAME);
				
				/*Ext.getCmp('accountNameRe').setValue().ACCOUNT_NAME;
				Ext.getCmp('accountLevelRe').setValue().ACCOUNT_LEVEL;*/
				masterGrid.getStore().loadStoreRecords();
			}
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