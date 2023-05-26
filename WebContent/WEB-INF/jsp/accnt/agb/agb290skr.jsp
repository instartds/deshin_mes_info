<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="agb290skr"  >
	<t:ExtComboStore comboType="BOR120"  />				<!-- 사업장 --> 
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

var gsChargeCode  = Ext.isEmpty(${getChargeCode}) ? ['']: ${getChargeCode};		//ChargeCode 관련 전역변수

function appMain() {
	
	var getStDt = ${getStDt};			/* 당기시작년월 */
	var getstMonth =  UniDate.getDbDateStr(getStDt[0].STDT).substring(0, 4) + UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6);	//getStDt[0].STDT;
	
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Agb290skrModel', {
		fields: [  	  
			{name: 'COMP_CODE'		, text: '법인코드'		,type: 'string'},
			{name: 'AC_CODE'		, text: 'AC코드'		,type: 'string'},
			{name: 'PEND_CD'		, text: '관리항목'		,type: 'string'},
			{name: 'PEND_NAME'		, text: '관리항목명칭'	,type: 'string'},
			{name: 'ACCNT'			, text: '계정코드'		,type: 'string'},
			{name: 'ACCNT_NAME'		, text: '계정과목명'		,type: 'string'},
			{name: 'WAL_AMT_I'		, text: '이월금액'		,type: 'uniPrice'},
			{name: 'DR_AMT_I'		, text: '차변금액'		,type: 'uniPrice'},
			{name: 'CR_AMT_I'		, text: '대변금액'		,type: 'uniPrice'},
			{name: 'JAN_AMT_I'		, text: '잔액'		,type: 'uniPrice'},
			{name: 'GUBUN'			, text: '구분'		,type: 'string'}
		]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('agb290skrMasterStore1',{
		model: 'Agb290skrModel',
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
				read: 'agb290skrService.selectList'
			}
		},
		loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			param.ST_MONTH = getstMonth;
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
			})]
		},{
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
			}),{
				xtype: 'radiogroup',
				id:'EXSUM',
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
			colspan: 3,
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
	/**
	 * Master Grid1 정의(Grid Panel)
	 * @type 
	 */
	
	var masterGrid = Unilite.createGrid('agb290skrGrid1', {
		layout : 'fit',
		region : 'center',
		store : directMasterStore,
		selModel : 'rowmodel',
		uniOpt:{
			expandLastColumn	: false,	//마지막 컬럼 * 사용 여부
			useRowNumberer		: true,		//첫번째 컬럼 순번 사용 여부
			useLiveSearch		: true,		//찾기 버튼 사용 여부
			useRowContext		: true,
			onLoadSelectFirst	: true,
			useSqlTotal			: true,
			filter: {					//필터 사용 여부
				useFilter: true,
				autoCreate: true
			}
		},
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
			{dataIndex: 'PEND_CD'		, width: 120},
			{dataIndex: 'PEND_NAME'		, width: 333,
				renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
					if(record.get("GUBUN") == '3'){
						var val = '총계'
						return val ;
					}
					return val;		
				}
			},
			{dataIndex: 'ACCNT'			, width: 120,
				renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
					if(record.get("GUBUN") == '2'){
						var val = '소계'
						return val ;
					}
					return val;		
				}
			},
			{dataIndex: 'ACCNT_NAME'	, width: 200},
			{dataIndex: 'WAL_AMT_I'		, width: 133},
			{dataIndex: 'DR_AMT_I'		, width: 133},
			{dataIndex: 'CR_AMT_I'		, width: 133},
			{dataIndex: 'JAN_AMT_I'		, width: 133}
		],
		listeners: {
			itemmouseenter:function(view, record, item, index, e, eOpts ) {
				view.ownerGrid.setCellPointer(view, item);
			},
			onGridDblClick :function( grid, record, cellIndex, colName ) {
				masterGrid.gotoAgb290skr(record);
			}
		},
		onItemcontextmenu:function( menu, grid, record, item, index, event  ) {
			//menu.showAt(event.getXY());
			return true;
		},
		uniRowContextMenu:{
			items: [{
				text	: '관리항목별원장 보기',
				itemId:'agbItem',
				handler	: function(menuItem, event) {
					var param = menuItem.up('menu');
					masterGrid.gotoAgb290skr(param.record);
				}
			}]
		},
		gotoAgb290skr:function(record)	{
			if(record.get("GUBUN") == '1'){
				if(record)	{
					var params = {
						action			: 'select',
						'PGM_ID'		: 'agb290skr',
						'AC_DATE_FR'    : panelSearch.getValue('FR_DATE'),						/* gsParam(0) */
						'AC_DATE_TO'    : panelSearch.getValue('TO_DATE'),						/* gsParam(1) */	
						'ACCNT_DIV_CODE': panelSearch.getValue('ACCNT_DIV_CODE'),				/* gsParam(2) */
						'P_EX_SUM'      : Ext.getCmp('EXSUM').getChecked()[0].inputValue,		/* gsParam(4) */
						'PEND_CD' 		: record.data['PEND_CD'],  								/* gsParam(5) */	
						'PEND_NAME'   	: record.data['PEND_NAME'],	  	 						/* gsParam(6) */	
						'ACCNT'   		: record.data['ACCNT'],	   								/* gsParam(7) */	
						'ACCNT_NAME'    : record.data['ACCNT_NAME'],	   						/* gsParam(8) */	
						
						'DEPT_CODE_FR'  : panelSearch.getValue('DEPT_CODE_FR'),					/* gsParam(9) */
						'DEPT_NAME_FR'  : panelSearch.getValue('DEPT_NAME_FR'),					/* gsParam(10) */
						'DEPT_CODE_TO'  : panelSearch.getValue('DEPT_CODE_TO'),					/* gsParam(11) */
						'DEPT_NAME_TO'  : panelSearch.getValue('DEPT_NAME_FR'),					/* gsParam(12) */
						'MANAGE_CODE'   : panelSearch.getValue('MANAGE_CODE'),					/* gsParam(15) */
						'MANAGE_NAME'   : panelSearch.getValue('MANAGE_NAME')					/* gsParam(16) */		
					}
		  			var rec1 = {data : {prgID : 'agb280skr', 'text':''}};
					parent.openTab(rec1, '/accnt/agb280skr.do', params);
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
		id : 'agb290skrApp',
		fnInitBinding : function() {
			//panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			
			panelSearch.setValue('FR_DATE',UniDate.get('startOfMonth'));
			panelResult.setValue('FR_DATE',UniDate.get('startOfMonth'));
			
			panelSearch.setValue('TO_DATE',UniDate.get('today'));
			panelResult.setValue('TO_DATE',UniDate.get('today'));
			
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
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');
			if(as.isHidden()) {
				as.show();
			}else {
				as.hide();
			}
		}
	});
};

</script>
