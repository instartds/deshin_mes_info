<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="agb500skr">
	<t:ExtComboStore comboType="BOR120" pgmId="agb500skr"/>		<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B004"/>			<!-- 화폐단위-->
	<t:ExtComboStore comboType="AU" comboCode="A244"/>
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
	Unilite.defineModel('Agb500skrModel', {
		fields: [
			{name: 'GUBUN'			, text: '구분'			,type: 'string'},
			{name: 'PEND_DATA_CODE'	, text: '거래처'			,type: 'string'},
			{name: 'PEND_DATA_NAME'	, text: '거래처명'			,type: 'string'},
			{name: 'ACCNT'			, text: '계정코드'			,type: 'string'},
			{name: 'ACCNT_NAME'		, text: '계정과목명'		,type: 'string'},
			{name: 'ORG_AC_DATE'	, text: '전표일'			,type: 'uniDate'},
			{name: 'ORG_SLIP_NUM'	, text: '전표번호'			,type: 'string'},
			{name: 'ORG_SLIP_SEQ'	, text: '전표순번'			,type: 'int'},
			{name: 'REMARK'			, text: '적요'			,type: 'string'},
			{name: 'BLN_I1'			, text: '선수/선급금액'		,type: 'uniPrice'},
			{name: 'BLN_I2'			, text: '채권/채무금액'		,type: 'uniPrice'},
			{name: 'MONEY_UNIT'		, text: '화폐'			,type: 'string'},
			{name: 'FOR_BLN_I1'		, text: '외화 선수/선급금액'	,type: 'float', decimalPrecision:3, format:'0,000.00'},
			{name: 'FOR_BLN_I2'		, text: '외화 채권/채무금액'	,type: 'float', decimalPrecision:3, format:'0,000.00'},
			{name: 'DIV_CODE'		, text: '사업장'			,type: 'string',  comboType:"BOR120"}
			
		]
	});

	/** Store 정의(Service 정의)
	 * @type 
	 */
	var directMasterStore = Unilite.createStore('agb500skrMasterStore1',{
		model	: 'Agb500skrModel',
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
				read: 'agb500skrService.selectList'
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
			},
			Unilite.popup('CUST',{ 
				fieldLabel		: '거래처', 
				valueFieldName	: 'FR_CUSTOM',
				textFieldName	: 'FR_CUSTOM_NAME',
				allowBlank:true,
				autoPopup:false,
				validateBlank:false,
				listeners		: {
								onValueFieldChange:function( elm, newValue, oldValue) {						
									panelResult.setValue('FR_CUSTOM', newValue);
									
									if(!Ext.isObject(oldValue)) {
										panelResult.setValue('FR_CUSTOM_NAME', '');
										panelSearch.setValue('FR_CUSTOM_NAME', '');
									}
								},
								onTextFieldChange:function( elm, newValue, oldValue) {
									panelResult.setValue('FR_CUSTOM_NAME', newValue);
									
									if(!Ext.isObject(oldValue)) {
										panelResult.setValue('FR_CUSTOM', '');
										panelSearch.setValue('FR_CUSTOM', '');
									}
								}
				}
			}),
			Unilite.popup('CUST',{ 
				fieldLabel		: '~',
				allowBlank:true,
				autoPopup:false,
				validateBlank:false,				
				valueFieldName	: 'TO_CUSTOM',
				textFieldName	: 'TO_CUSTOM_NAME',
				listeners		: {
								onValueFieldChange:function( elm, newValue, oldValue) {						
									panelResult.setValue('TO_CUSTOM', newValue);
									
									if(!Ext.isObject(oldValue)) {
										panelResult.setValue('TO_CUSTOM_NAME', '');
										panelSearch.setValue('TO_CUSTOM_NAME', '');
									}
								},
								onTextFieldChange:function( elm, newValue, oldValue) {
									panelResult.setValue('TO_CUSTOM_NAME', newValue);
									
									if(!Ext.isObject(oldValue)) {
										panelResult.setValue('TO_CUSTOM', '');
										panelSearch.setValue('TO_CUSTOM', '');
									}
								}
				}
			}),{
				fieldLabel	: '구분',
				name		: 'GUBUN', 
				xtype		: 'uniCombobox',
				value		: '1',
				comboType	: 'AU',
				comboCode   : 'A244',
				width		: 325,
				colspan		: 2,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('GUBUN', newValue);
					}
				}
			}]
		}]
		
	});	//end panelSearch

	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 3},
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
			colspan		: 2,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('ACCNT_DIV_CODE', newValue);
				}
			}
		},
		Unilite.popup('CUST',{ 
			fieldLabel		: '거래처', 
			valueFieldName	: 'FR_CUSTOM',
			textFieldName	: 'FR_CUSTOM_NAME',
			allowBlank:true,
			autoPopup:false,
			validateBlank:false,
			listeners		: {
							onValueFieldChange:function( elm, newValue, oldValue) {						
								panelSearch.setValue('FR_CUSTOM', newValue);
								
								if(!Ext.isObject(oldValue)) {
									panelResult.setValue('FR_CUSTOM_NAME', '');
									panelSearch.setValue('FR_CUSTOM_NAME', '');
								}
							},
							onTextFieldChange:function( elm, newValue, oldValue) {
								panelSearch.setValue('FR_CUSTOM_NAME', newValue);
								
								if(!Ext.isObject(oldValue)) {
									panelResult.setValue('FR_CUSTOM', '');
									panelSearch.setValue('FR_CUSTOM', '');
								}
							}
			}
		}),
		Unilite.popup('CUST',{ 
			fieldLabel		: '~', 
			valueFieldName	: 'TO_CUSTOM',
			textFieldName	: 'TO_CUSTOM_NAME',
			allowBlank:true,
			autoPopup:false,
			validateBlank:false,
			listeners		: {
							onValueFieldChange:function( elm, newValue, oldValue) {						
								panelSearch.setValue('TO_CUSTOM', newValue);
								
								if(!Ext.isObject(oldValue)) {
									panelResult.setValue('TO_CUSTOM_NAME', '');
									panelSearch.setValue('TO_CUSTOM_NAME', '');
								}
							},
							onTextFieldChange:function( elm, newValue, oldValue) {
								panelSearch.setValue('TO_CUSTOM_NAME', newValue);
								
								if(!Ext.isObject(oldValue)) {
									panelResult.setValue('TO_CUSTOM', '');
									panelSearch.setValue('TO_CUSTOM', '');
								}
							}			
			}
		}),{
			fieldLabel	: '구분',
			name		: 'GUBUN', 
			xtype		: 'uniCombobox',
			value		: '1',
			comboType	: 'AU',
			comboCode   : 'A244',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('GUBUN', newValue);
				}
			}
		}]
	});

	/** Master Grid1 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid = Unilite.createGrid('agb500skrGrid1', {
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
			},
			state: {
				useState: false,			//그리드 설정 버튼 사용 여부
				useStateList: false		//그리드 설정 목록 사용 여부
			}
		},
		enableColumnHide:false,
		sortableColumns	: false,
		enableColumnMove : false,
		viewConfig: {
	        getRowClass: function(record, rowIndex, rowParams, store){
	        	var cls = '';
	        	
	          	if(record.get('ACCNT_DIVI') == '2') {
					cls = 'x-change-cell_light';
				}else if(record.get('ACCNT_DIVI') == '1'){
					cls = 'x-change-cell_medium_light';
				} else if(record.get('ACCNT_DIVI') == '0'){ 
					cls = 'x-change-cell_normal';
					
				} else if(record.get('ACCNT') == '합계') {
					cls = 'x-change-cell_dark';
				}
				
				if(record.get('GUBUN') == '2'){
					cls = 'x-change-celltext_red';	
				}
				return cls;
	        }
	    },
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
			{dataIndex: 'GUBUN'				, width: 100 ,align : 'center', hidden : true},
			{dataIndex: 'PEND_DATA_CODE'	, width: 100 },
			{dataIndex: 'PEND_DATA_NAME'	, width: 300}, 
			{dataIndex: 'ACCNT'				, width: 100},
			{dataIndex: 'ACCNT_NAME'		, width: 200},
			{dataIndex: 'ORG_AC_DATE'		, width: 100},
			{dataIndex: 'ORG_SLIP_NUM'		, width: 80, align:'center'},
			{dataIndex: 'ORG_SLIP_SEQ'		, width: 80, align:'center'},
			{dataIndex: 'REMARK'			, width: 300},
			{dataIndex: 'BLN_I1'			, width: 130},
			{dataIndex: 'BLN_I2'			, width: 130},
			{dataIndex: 'MONEY_UNIT'		, width: 88},
			{dataIndex: 'FOR_BLN_I1'		, width: 130},
			{dataIndex: 'FOR_BLN_I2'		, width: 130},
			{dataIndex: 'DIV_CODE'			, width: 100}
		], 
		viewConfig: {
			getRowClass: function(record, rowIndex, rowParams, store){
				var cls = '';
				
				//소계
				if(record.get('GUBUN') == '2'){
					cls = 'x-change-cell_light';
				}
				//합계
				if(record.get('GUBUN') == '3'){
					cls = 'x-change-cell_normal';
				}
				return cls;
			}
		}
	});



	Unilite.Main({
		id			: 'agb500skrApp',
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
					FR_CUSTOM		: param.CUST_CODE_FR,		/* 거래처 FR */
					FR_CUSTOM_NAME	: param.CUST_NAME_FR,
					TO_CUSTOM		: param.CUST_CODE_TO,		/* 거래처 TO */
					TO_CUSTOM_NAME	: param.CUST_NAME_TO,
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
				
				
				panelSearch.setValue('FR_CUSTOM',params.CUSTOM_CODE);
				panelSearch.setValue('TO_CUSTOM',params.CUSTOM_CODE);
				panelSearch.setValue('FR_CUSTOM_NAME',params.CUSTOM_NAME);
				panelSearch.setValue('TO_CUSTOM_NAME',params.CUSTOM_NAME);
				
				Ext.getCmp('accountNameSe').setValue().ACCOUNT_NAME;
				Ext.getCmp('accountLevelSe').setValue().ACCOUNT_LEVEL;

				panelResult.setValue('FR_DATE',params.FR_DATE);
				panelResult.setValue('TO_DATE',params.TO_DATE);
				panelResult.setValue('ACCNT_DIV_CODE',params.ACCNT_DIV_CODE);
				panelResult.setValue('ACCNT_DIV_NAME',params.ACCNT_DIV_NAME);

				panelResult.setValue('FR_CUSTOM',params.CUSTOM_CODE);
				panelResult.setValue('TO_CUSTOM',params.CUSTOM_CODE);
				panelResult.setValue('FR_CUSTOM_NAME',params.CUSTOM_NAME);
				panelResult.setValue('TO_CUSTOM_NAME',params.CUSTOM_NAME);

				masterGrid.getStore().loadStoreRecords();
			}
		}
	});
};
</script>