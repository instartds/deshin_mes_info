<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="agb280skr"  >
	<t:ExtComboStore comboType="BOR120"  />				<!-- 사업장 --> 
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

var gsChargeCode  = Ext.isEmpty(${getChargeCode}) ? ['']: ${getChargeCode};		//ChargeCode 관련 전역변수

function appMain() {
	
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Agb280skrModel', {
		fields: [  	  
			{name: 'COMP_CODE'			, text: '법인코드'		,type: 'string'},
			{name: 'AC_CODE'			, text: 'AC코드'		,type: 'string'},
			{name: 'PEND_CD'			, text: '관리항목명칭코드'	,type: 'string'},
			{name: 'PEND_NAME'			, text: '관리항목명칭'	,type: 'string'},
			{name: 'ACCNT'				, text: '계정코드'		,type: 'string'},
			{name: 'ACCNT_NAME'			, text: '계정과목명'		,type: 'string'},
			{name: 'CUSTOM_CODE'		, text: '거래처' 		,type: 'string'},
			{name: 'CUSTOM_NAME'		, text: '거래처명'		,type: 'string'},
			{name: 'DR_AMT_I'			, text: '차변금액'		,type: 'uniPrice'},
			{name: 'CR_AMT_I'			, text: '대변금액'		,type: 'uniPrice'},
			{name: 'REMARK'				, text: '적요'		,type: 'string'},
			{name: 'AC_DATE'			, text: '전표일자'		,type: 'uniDate'},
			{name: 'SLIP_NUM'			, text: '번호'		,type: 'string'},
			{name: 'SLIP_SEQ'			, text: '순번'		,type: 'string'},
			{name: 'DIV_CODE'			, text: '사업장'		,type: 'string'},
			{name: 'DIV_NAME'			, text: '사업장'		,type: 'string'},
			{name: 'DEPT_CODE'			, text: '부서코드'		,type: 'string'},
			{name: 'DEPT_NAME'			, text: '부서명'		,type: 'string'},
			{name: 'MONEY_UNIT'			, text: '화폐단위'		,type: 'string'},
			{name: 'EXCHG_RATE_O'		, text: '환율'		,type: 'uniER'},
			{name: 'DR_FOR_AMT_I'		, text: '차변외화금액'	,type: 'uniFC'},
			{name: 'CR_FOR_AMT_I'		, text: '대변외화금액'	,type: 'uniFC'},
			{name: 'INPUT_PATH'			, text: '입력경로'		,type: 'string'},
			{name: 'INPUT_DIVI'			, text: '입력경로'		,type: 'string'},
			{name: 'GUBUN'				, text: '구분'		,type: 'string'}
		]
	});
	
	// GroupField string type으로 변환
	function dateToString(v, record){
		return UniDate.safeFormat(v);
	}
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('agb280skrMasterStore1',{
		model: 'Agb280skrModel',
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
				read: 'agb280skrService.selectList'
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
			Unilite.popup('MANAGE',{
				itemId :'MANAGE',
				fieldLabel: '관리항목',
				allowBlank:false,
				autoPopup:true,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('MANAGE_CODE', panelSearch.getValue('MANAGE_CODE'));
							panelResult.setValue('MANAGE_NAME', panelSearch.getValue('MANAGE_NAME'));
							/**
							 * 관리항목 팝업을 작동했을때의 동적 필드 생성(항상 FR과 TO필드 2개를 생성 해준다..) 
							 * 생성된 필드가 팝업일시 필드name은 아래와 같음
							 * 				FR 필드								TO 필드
							 *  valueFieldName    textFieldName	 ~	 valueFieldName	  textFieldName
							 * DYNAMIC_CODE_FR, DYNAMIC_NAME_FR  ~  DYNAMIC_CODE_TO, DYNAMIC_NAME_TO
							 * --------------------------------------------------------------------------
							 * 생성된 필드가 uniTextfield, uniNumberfield, uniDatefield일시 필드 name은 아래와 같음
							 * 		FR 필드				 ~				TO 필드
							 * 	DYNAMIC_CODE_FR			 ~			DYNAMIC_CODE_TO
							 * */
							var param = {AC_CD : panelSearch.getValue('MANAGE_CODE')};
							accntCommonService.fnGetAcCode(param, function(provider, response)	{
								var dataMap = provider;
								UniAccnt.changeFields(panelSearch, dataMap, panelResult);
								UniAccnt.changeFields(panelResult, dataMap, panelSearch);
								
								masterGrid.getColumn('PEND_CD').setText(provider.AC_NAME);
								masterGrid.getColumn('PEND_NAME').setText(provider.AC_NAME + '명');
								
								Ext.getCmp('EXSUM').setFieldLabel(provider.AC_NAME + '별합계');
							});
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('MANAGE_CODE', '');
						panelResult.setValue('MANAGE_NAME', '');
						/**
						 * onClear시 removeField..
						 */
						UniAccnt.removeField(panelSearch, panelResult);
					},
					applyextparam: function(popup){
						
					}
				}
			}),{
				xtype: 'container',
				//colspan:  ?,
				itemId: 'formFieldArea1',
				layout: {
					type: 'table',
					columns:1,
					itemCls:'table_td_in_uniTable',
					tdAttrs: {
						width: 350
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
								'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
							}
							popup.setExtParam(param);
						}
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
			items:[
				Unilite.popup('DEPT',{
					fieldLabel: '부서',
					valueFieldName: 'DEPT_CODE_FR',
					textFieldName: 'DEPT_NAME_FR',
					autoPopup:true,
					listeners: {
						applyextparam: function(popup){
							//popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
			}),
			Unilite.popup('DEPT',{
				fieldLabel: '~',
				valueFieldName: 'DEPT_CODE_TO',
				textFieldName: 'DEPT_NAME_TO',
				autoPopup:true,
				listeners: {
					applyextparam: function(popup){
						//popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}
			}),
			Unilite.popup('CUST',{
			    fieldLabel: '거래처',
			    valueFieldName: 'CUST_CODE',
				textFieldName: 'CUST_NAME',
				autoPopup:true,
				listeners: {
					applyextparam: function(popup){
						//popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}
			}),
			Unilite.popup('REMARK',{
				fieldLabel: '적요',
				validateBlank:false,
				autoPopup:true,
				valueFieldName:'REMARK_CODE',
				textFieldName:'REMARK_NAME'
			}),{
				xtype: 'radiogroup',
				id:'EXSUM',
				//itemId:'sumLabel',
				fieldLabel: '관리항목별합계',
				items: [{
					boxLabel: '미출력',
					width: 70, 
					name: 'SUM',
					inputValue: '1',
					checked:true
				},{
					boxLabel : '출력',
					width: 70,
					name: 'SUM',
					inputValue: '2'
				}]/*,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						if(!UniAppManager.app.isValidSearchForm()){
							return false;
						}else{
							if(newValue.SUM == '1' ){
								directMasterStore.loadStoreRecords();	
							}else if(newValue.SUM == '2' ){
								directMasterStore.loadStoreRecords();	
							}
						}
					}
				}*/
			}]
		}]
	});	//end panelSearch  
	
	/**
	 * Master Grid1 정의(Grid Panel)
	 * @type 
	 */
	
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
			Unilite.popup('MANAGE',{
				itemId :'MANAGE',
				fieldLabel: '관리항목',
				allowBlank:false,
 				autoPopup:true,
				colspan:2,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('MANAGE_CODE', panelResult.getValue('MANAGE_CODE'));
							panelSearch.setValue('MANAGE_NAME', panelResult.getValue('MANAGE_NAME'));
							/**
							 * 관리항목 팝업을 작동했을때의 동적 필드 생성(항상 FR과 TO필드 2개를 생성 해준다..) 
							 * 생성된 필드가 팝업일시 필드name은 아래와 같음
							 * 				FR 필드								TO 필드
							 *  valueFieldName    textFieldName	 ~	 valueFieldName	  textFieldName
							 * DYNAMIC_CODE_FR, DYNAMIC_NAME_FR  ~  DYNAMIC_CODE_TO, DYNAMIC_NAME_TO
							 * --------------------------------------------------------------------------
							 * 생성된 필드가 uniTextfield, uniNumberfield, uniDatefield일시 필드 name은 아래와 같음
							 * 		FR 필드				 ~				TO 필드
							 * 	DYNAMIC_CODE_FR			 ~			DYNAMIC_CODE_TO
							 * */
							var param = {AC_CD : panelResult.getValue('MANAGE_CODE')};
							accntCommonService.fnGetAcCode(param, function(provider, response)	{
								var dataMap = provider;
								UniAccnt.changeFields(panelResult, dataMap, panelSearch);
								UniAccnt.changeFields(panelSearch, dataMap, panelResult);
								
								masterGrid.getColumn('PEND_CD').setText(provider.AC_NAME);
								masterGrid.getColumn('PEND_NAME').setText(provider.AC_NAME + '명');
								
								Ext.getCmp('EXSUM').setFieldLabel(provider.AC_NAME + '별합계');
							});
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('MANAGE_CODE', '');
						panelSearch.setValue('MANAGE_NAME', '');
						/**
						 * onClear시 removeField..
						 */
						UniAccnt.removeField(panelSearch, panelResult);
					},
					applyextparam: function(popup){
						
					}
				}
			}),{
				xtype: 'container',
				colspan: 2,
				itemId: 'formFieldArea1',
				layout: {
					type: 'table',
					columns:2,
					itemCls:'table_td_in_uniTable',
					tdAttrs: {
						width: 350
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
								'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
							}
							popup.setExtParam(param);
						}
					}
				}
		})]
	});
	
	var masterGrid = Unilite.createGrid('agb280skrGrid1', {
		layout : 'fit',
		region : 'center',
		store : directMasterStore,
		uniOpt:{	
			expandLastColumn: false,	//마지막 컬럼 * 사용 여부
			useRowNumberer: true,		//첫번째 컬럼 순번 사용 여부
			useLiveSearch: true,		//찾기 버튼 사용 여부
			useRowContext: true,
			onLoadSelectFirst: true,
			filter: {					//필터 사용 여부
				useFilter: true,
				autoCreate: true
			}
		},
		enableColumnHide :false,
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
			showSummaryRow: false
		}],
		columns: [
			//{dataIndex: 'COMP_CODE'		, width: 66, hidden:true},
			//{dataIndex: 'AC_CODE'			, width: 66, hidden:true},
			{dataIndex: 'PEND_CD'			, width: 120 /*,locked:true*/},
			{dataIndex: 'PEND_NAME'			, width: 250 /*,locked:true*/,
				renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
					if(record.get("GUBUN") == '3'){
						var val = '총계';
						return val;
					}
					return val;
				}
			},
			{dataIndex: 'ACCNT'				, width: 120  /*,locked:true*/,
				renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
					if(record.get("GUBUN") == '2'){
						var val = '소계';
						return val;
					}
					return val;
				}
			},
			{dataIndex: 'ACCNT_NAME'		, width: 250 /*,locked:true*/},
			{dataIndex: 'CUSTOM_CODE'		, width: 100 /*,locked:true*/},
			{dataIndex: 'CUSTOM_NAME'		, width: 166 /*,locked:true*/},
			{dataIndex: 'DR_AMT_I'			, width: 130},
			{dataIndex: 'CR_AMT_I'			, width: 130},
			{dataIndex: 'REMARK'			, width: 333},
			{dataIndex: 'AC_DATE'			, width: 100},
			{dataIndex: 'SLIP_NUM'			, width: 60,
				renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
					if(record.get("GUBUN") == '2' || record.get("GUBUN") == '3'){
						var val = '';
						return val;
					}
					return val;
				}
			},
			{dataIndex: 'SLIP_SEQ'			, width: 60,
				renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
					if(record.get("GUBUN") == '2' || record.get("GUBUN") == '3'){
						var val = '';
						return val;
					}
					return val;
				}
			},
			//{dataIndex: 'DIV_CODE'		, width: 80 , hidden:true},
			{dataIndex: 'DIV_NAME'			, width: 120},
			{dataIndex: 'DEPT_CODE'			, width: 88},
			{dataIndex: 'DEPT_NAME'			, width: 120},
			{dataIndex: 'MONEY_UNIT'		, width: 66},
			{dataIndex: 'EXCHG_RATE_O'		, width: 80,
				renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
					if(record.get("GUBUN") == '2' || record.get("GUBUN") == '3'){
						var val = '';
						return val;
					}
					return val;
				}
			}, 				
			{dataIndex: 'DR_FOR_AMT_I'		, width: 100},
			{dataIndex: 'CR_FOR_AMT_I'		, width: 100}
			//{dataIndex: 'INPUT_PATH'		, width: 66 , hidden:true},
			//{dataIndex: 'INPUT_DIVI'		, width: 66 , hidden:true},
			//{dataIndex: 'GUBUN'		  	, width: 66 , hidden:true}
		],
		listeners: {
			itemmouseenter:function(view, record, item, index, e, eOpts ) {
				view.ownerGrid.setCellPointer(view, item);
			},
			onGridDblClick :function( grid, record, cellIndex, colName ) {
				masterGrid.gotoAgb(record);
			}
		},
		onItemcontextmenu:function( menu, grid, record, item, index, event  ) {
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
		},
		uniRowContextMenu:{
			items: [{
				text: '회계전표입력 이동',   
				itemId	: 'linkAgj200ukr',
				handler: function(menuItem, event) {
					var param = menuItem.up('menu');
					masterGrid.gotoAgb(param.record);
				}
			},{	text: '회계전표입력(전표번호별) 이동',  
				itemId	: 'linkAgj205ukr', 
				handler: function(menuItem, event) {
					var param = menuItem.up('menu');
					masterGrid.gotoAgb(param.record);
				}
			},{	text: 'Dgj100urk',  
				itemId	: 'linkDgj100ukr', 
				handler: function(menuItem, event) {
					var param = menuItem.up('menu');
					masterGrid.gotoAgb(param.record);
				}
			}]
		},
		gotoAgb:function(record) {
			if(record)	{
				var params = {
					action:'select',
					'PGM_ID'	 : 'agb280skr',
					'AC_DATE_FR' : record.data['AC_DATE'],		/* gsParam(0) */
					'AC_DATE_TO' : record.data['AC_DATE'],		/* gsParam(1) */
					'INPUT_PATH' : record.data['INPUT_PATH'],	/* gsParam(2) */
					'SLIP_NUM'   : record.data['SLIP_NUM'],		/* gsParam(3) */
					'SLIP_SEQ'   : record.data['SLIP_SEQ'],		/* gsParam(4) */
					//''   : record.data[''],/* gsParam(5) */
					'DIV_CODE'   : record.data['DIV_CODE']		/* gsParam(6) */
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
		id : 'agb280skrApp',
		fnInitBinding : function(params) {	
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('FR_DATE',UniDate.get('startOfMonth'));
			panelResult.setValue('FR_DATE',UniDate.get('startOfMonth'));
		
			panelSearch.setValue('TO_DATE',UniDate.get('today'));
			panelResult.setValue('TO_DATE',UniDate.get('today'));
			
			if(!Ext.isEmpty(params && params.PGM_ID)){
				this.processParams(params);
			}
			
			var activeSForm;
			if(!UserInfo.appOption.collapseLeftSearch) {
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('FR_DATE');
		},
		onQueryButtonDown : function()	{
			if(!UniAppManager.app.isValidSearchForm()){
				return false;
			}
			directMasterStore.loadStoreRecords();
		},
        processParams: function(params) {
			this.uniOpt.appParams = params;
			
			if(params.PGM_ID == 'agb290skr') {
				panelSearch.setValue('FR_DATE',params.AC_DATE_FR);
				panelSearch.setValue('TO_DATE',params.AC_DATE_TO);
				panelSearch.setValue('ACCNT_DIV_CODE',params.ACCNT_DIV_CODE);
				
				panelSearch.setValue('MANAGE_CODE',params.MANAGE_CODE);
				panelSearch.setValue('MANAGE_NAME',params.MANAGE_NAME);
				
				panelResult.setValue('MANAGE_CODE',params.MANAGE_CODE);
				panelResult.setValue('MANAGE_NAME',params.MANAGE_NAME);
				
				var param = {AC_CD : panelSearch.getValue('MANAGE_CODE')};
				accntCommonService.fnGetAcCode(param, function(provider, response) {
					var dataMap = provider;
					UniAccnt.changeFields(panelSearch, dataMap, panelResult);
					UniAccnt.changeFields(panelResult, dataMap, panelSearch);
					
					masterGrid.getColumn('PEND_CD').setText(provider.AC_NAME);
					masterGrid.getColumn('PEND_NAME').setText(provider.AC_NAME + '명');
					
					panelSearch.setValue('DYNAMIC_CODE_FR',params.PEND_CD);
					panelSearch.setValue('DYNAMIC_NAME_FR',params.PEND_NAME);
					panelSearch.setValue('DYNAMIC_CODE_TO',params.PEND_CD);
					panelSearch.setValue('DYNAMIC_NAME_TO',params.PEND_NAME);
					
					panelResult.setValue('DYNAMIC_CODE_FR',params.PEND_CD);
					panelResult.setValue('DYNAMIC_NAME_FR',params.PEND_NAME);
					panelResult.setValue('DYNAMIC_CODE_TO',params.PEND_CD);
					panelResult.setValue('DYNAMIC_NAME_TO',params.PEND_NAME);
					
					panelSearch.setValue('ACCNT_CODE_FR',params.ACCNT);
					panelSearch.setValue('ACCNT_NAME_FR',params.ACCNT_NAME);
					panelSearch.setValue('ACCNT_CODE_TO',params.ACCNT);
					panelSearch.setValue('ACCNT_NAME_TO',params.ACCNT_NAME);
					
					panelSearch.setValue('DEPT_CODE_FR',params.DEPT_CODE_FR);
					panelSearch.setValue('DEPT_NAME_FR',params.DEPT_NAME_FR);
					panelSearch.setValue('DEPT_CODE_TO',params.DEPT_CODE_TO);
					panelSearch.setValue('DEPT_NAME_TO',params.DEPT_NAME_TO);
					
					panelResult.setValue('FR_DATE',params.AC_DATE_FR);
					panelResult.setValue('TO_DATE',params.AC_DATE_TO);
					panelResult.setValue('ACCNT_DIV_CODE',params.ACCNT_DIV_CODE);
					
					panelResult.setValue('ACCNT_CODE_FR',params.ACCNT);
					panelResult.setValue('ACCNT_NAME_FR',params.ACCNT_NAME);
					panelResult.setValue('ACCNT_CODE_TO',params.ACCNT);
					panelResult.setValue('ACCNT_NAME_TO',params.ACCNT_NAME);
					
					panelSearch.getField('SUM').setValue(params.P_EX_SUM);
					
					masterGrid.getStore().loadStoreRecords();
				});
			}
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');
			if(as.isHidden()) {
				as.show();
			}else {
				as.hide()
			}
		}
	});
};

</script>
