<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<t:appConfig pgmId="agb330skr">
	<t:ExtComboStore comboType="BOR120" pgmId="agb330skr" /> 			<!-- 사업장 -->        
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
	Unilite.defineModel('Agb330skrMasterModel', {
		fields: [  	  
			{name: 'ACCNT'   				, text: '계정코드' 		,type: 'string'},
			{name: 'ACCNT_NAME'   			, text: '계정과목명'		,type: 'string'}
		]
	});
	
	Unilite.defineModel('Agb330skrDetailModel', {
		fields: [  	  
			{name: 'GUBUN'				, text: '구분' 				,type: 'string'},
			{name: 'COMP_CODE'			, text: '법인코드' 				,type: 'string'},
			{name: 'DIV_CODE'			, text: '사업장코드'				,type: 'string'},
			{name: 'ACCNT'				, text: '계정코드' 				,type: 'string'},
			{name: 'ACCNT_NAME'			, text: '계정명' 				,type: 'string'},
			{name: 'INPUT_PATH'			, text: '입력경로'				,type: 'string'},
			{name: 'AC_DATE'			, text: '일자' 				,type: 'string'},
			{name: 'SLIP_NUM'			, text: '전표번호'	 			,type: 'string'},
			{name: 'SLIP_SEQ'			, text: '순번' 				,type: 'string'},
			{name: 'REMARK'				, text: '적요' 				,type: 'string'},
			{name: 'CUSTOM_CODE'		, text: '거래처' 				,type: 'string'},
			{name: 'CUSTOM_NAME'		, text: '거래처명' 				,type: 'string'},
			{name: 'DR_AMT_I'			, text: '차변금액' 				,type: 'uniPrice'},
			{name: 'CR_AMT_I'			, text: '대변금액' 				,type: 'uniPrice'},
			{name: 'JAN_AMT_I'			, text: '잔액' 				,type: 'uniPrice'}
		]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */
	var directMasterStore = Unilite.createStore('agb330skrMasterStore',{
		model: 'Agb330skrMasterModel',
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
				read: 'agb330skrService.selectMasterList'
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
	
	var directDetailStore = Unilite.createStore('agb330skrDetailStore',{
		model: 'Agb330skrDetailModel',
		uniOpt: {
			isMaster: false,			// 상위 버튼 연결 
			editable: false,			// 수정 모드 사용 
			deletable:false,			// 삭제 가능 여부 
			useNavi : false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {			
				read: 'agb330skrService.selectDetailList'
			}
		},
		loadStoreRecords: function(accnt) {
			var param = Ext.getCmp('searchForm').getValues();
			param.ACCNT = accnt;
			
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
			}]
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
		}]
	});
	
	/**
	 * Master Grid1 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid = Unilite.createGrid('agb330skrMasterGrid', {
		layout : 'fit',
		region : 'west',
		flex   : 1,
		uniOpt : {
			expandLastColumn: false,	//마지막 컬럼 * 사용 여부
			useRowNumberer: true,		//첫번째 컬럼 순번 사용 여부
			useLiveSearch: true,		//찾기 버튼 사용 여부
			useRowContext: true,
			onLoadSelectFirst	: true,
			useLoadFocus:true,
			filter: {					//필터 사용 여부
				useFilter: true,
				autoCreate: true
			}
		},
		store: directMasterStore,
		selModel:'rowmodel',
		columns: [        
			{dataIndex: 'ACCNT'   			, width: 100	, align : 'center'	},
			{dataIndex: 'ACCNT_NAME'   		, width: 160	}
		],
		listeners: {
			selectionchangerecord : function( record ) {
				if(!Ext.isEmpty(record)) {
					var accnt = record.get('ACCNT');
					directDetailStore.loadStoreRecords(accnt);
				}
			}
		}
	});
	
	var detailGrid = Unilite.createGrid('agb330skrDetailGrid', {
		layout : 'fit',
		region : 'center',
		flex   : 4,
		uniOpt : {
			expandLastColumn: false,	//마지막 컬럼 * 사용 여부
			useRowNumberer: true,		//첫번째 컬럼 순번 사용 여부
			useLiveSearch: true,		//찾기 버튼 사용 여부
			useRowContext: true,
			onLoadSelectFirst	: false,
			useLoadFocus: false,
			filter: {					//필터 사용 여부
				useFilter: true,
				autoCreate: true
			}
		},
		store: directDetailStore,
		selModel:'rowmodel',
		viewConfig: {
			getRowClass: function(record, rowIndex, rowParams, store) {
				var cls = '';
				
				if(record.get('GUBUN') == '1') {
					cls = 'x-change-cell_light';
				}
				else if(record.get('GUBUN') == '0' || record.get('GUBUN') == '2') {
					cls = 'x-change-cell_normal';
				}
				
				return cls;
			}
		},
		columns: [
			{ dataIndex: 'GUBUN'			, width:80	, hidden: true		},
			{ dataIndex: 'COMNP_CODE'		, width:80	, hidden: true		},
			{ dataIndex: 'DIV_CODE'			, width:80	, hidden: true		},
			{ dataIndex: 'INPUT_PATH'		, width:80	, hidden: true		},
			{ dataIndex: 'AC_DATE'			, width:80	, align: 'center'	},
			{ dataIndex: 'REMARK'			, width:300	},
			{ dataIndex: 'CUSTOM_CODE'		, width:100	},
			{ dataIndex: 'CUSTOM_NAME'		, width:160	},
			{ dataIndex: 'DR_AMT_I'			, width:120	},
			{ dataIndex: 'CR_AMT_I'			, width:120	},
			{ dataIndex: 'JAN_AMT_I'		, width:120	},
			{ dataIndex: 'SLIP_NUM'			, width:70	, align: 'center'	},
			{ dataIndex: 'SLIP_SEQ'			, width:60	, align: 'center'	}
		],
		listeners: {
			onGridDblClick :function( grid, record, cellIndex, colName ) {
				if(Ext.isEmpty(record)) {
					return;
				}
				if(record.get('GUBUN') != '4') {
					return;
				}
				
				var param = {
					'PGM_ID'		: 'agb110skr',
					'AC_DATE' 		: record.get('AC_DATE'),
					'INPUT_PATH'	: record.get('INPUT_PATH'),
					'SLIP_NUM'		: record.get('SLIP_NUM'),
					'SLIP_SEQ'		: record.get('SLIP_SEQ'),
					'DIV_CODE'		: record.get('DIV_CODE')
				};
				
				var rec1 = {data : {prgID : 'agj205ukr', 'text':''}};
				parent.openTab(rec1, '/accnt/agj205ukr.do', param);
			}
		}
	});
	
	var mainPan = Unilite.createTabPanel('mainPanel', {
		region:'center',
		removePanelHeader: true,
		items: [
			{	layout: {type: 'hbox', align: 'stretch'},
				items: [
					masterGrid,
					detailGrid
				]
			}
		]
	});
	
	Unilite.Main({
		border: false,
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid,
				detailGrid,
				panelResult
			]
		},
			panelSearch  	
		],
		id : 'agb330skrApp',
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
