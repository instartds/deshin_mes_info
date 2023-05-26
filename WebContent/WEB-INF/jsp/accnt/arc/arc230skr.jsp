<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="arc230skr"  >
	<t:ExtComboStore comboType="AU" comboCode="J501" /> <!-- 채권구분 -->
	<t:ExtComboStore comboType="AU" comboCode="J504" /> <!-- 구분 -->
	<t:ExtComboStore comboType="AU" comboCode="J505" /> <!-- 수금관리항목 -->
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}	
</style>	
</t:appConfig>
<script type="text/javascript" >

//그리드 날짜 세팅을 위한 변수 선언
var frDay			= '';
var toDay			= '';
var frComparisonDay = '';
var toComparisonDay = '';

function appMain() {
	Unilite.defineModel('Arc230skrModel', {
		fields:[
			{name: 'RECE_GUBUN'			, text: '채권구분'		, type: 'string', comboType:'AU', comboCode:'J501'},
			{name: 'RECE_COMP_CODE'		, text: '회사코드'		, type: 'string'},
			{name: 'RECE_COMP_NAME'		, text: '회사명'		, type: 'string'},  
			{name: 'CONF_RECE_NO'		, text: '채권번호'		, type: 'string'},
			{name: 'CUSTOM_NAME'		, text: '거래처명'		, type: 'string'},
			{name: 'TOP_NAME'			, text: '대표자'		, type: 'string'},
			{name: 'CONF_DRAFTER_NAME'	, text: '법무담당자'	, type: 'string'},
			{name: 'MNG_GUBUN'			, text: '구분'		, type: 'string', comboType:'AU', comboCode:'J504'},
			{name: 'TOT_CARRYOVER_AMT'	, text: '이월'		, type: 'uniPrice'},
			{name: 'TOT_RECEIVE_AMT'	, text: '접수'		, type: 'uniPrice'},
			{name: 'COLLECT_AMT'		, text: '수금'		, type: 'uniPrice'},
			{name: 'TOT_CONVERT_AMT'	, text: '사후전환'		, type: 'uniPrice'},
			{name: 'TOT_ADJUST_AMT'		, text: '조정'		, type: 'uniPrice'},
			{name: 'TOT_BALANCE_AMT'	, text: '잔액'		, type: 'uniPrice'},
			{name: 'TOT_DISPOSAL_AMT'	, text: '대손처리'		, type: 'uniPrice'},
			{name: 'TOT_BOOKVALUE_AMT'	, text: '장부가액'		, type: 'uniPrice'},
			{name: 'TOT_CARRYOVER_AMT2'	, text: '이월'		, type: 'uniPrice'},
			{name: 'TOT_RECEIVE_AMT2'	, text: '접수'		, type: 'uniPrice'},
			{name: 'COLLECT_AMT2'		, text: '수금'		, type: 'uniPrice'},
			{name: 'TOT_CONVERT_AMT2'	, text: '사후전환'		, type: 'uniPrice'},
			{name: 'TOT_ADJUST_AMT2'	, text: '조정'		, type: 'uniPrice'},
			{name: 'TOT_BALANCE_AMT2'	, text: '잔액'		, type: 'uniPrice'},
			{name: 'TOT_DISPOSAL_AMT2'	, text: '대손처리'		, type: 'uniPrice'},
			{name: 'TOT_BOOKVALUE_AMT2'	, text: '장부가액'		, type: 'uniPrice'}
	   ]
	});	



	var masterStore = Unilite.createStore('Arc230skrmasterStore',{
		model: 'Arc230skrModel',
		uniOpt: {
			isMaster	: true,				// 상위 버튼 연결
			editable	: false,			// 수정 모드 사용
			deletable	: false,			// 삭제 가능 여부
			useNavi		: false				// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
		   type: 'direct',
			api: {			
				read: 'arc230skrService.selectList'					
			}
		},
		loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			this.load({
				params : param
			});
		},
		listeners: {
		   	load: function(store, records, successful, eOpts) {
		   	},
		   	add: function(store, records, index, eOpts) {
		   	},
		   	update: function(store, record, operation, modifiedFieldNames, eOpts) {
		   	},
		   	remove: function(store, record, index, isMove, eOpts) {
		   	}
		}
	});
	
	
	
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title		: '검색조건',
		width		: 360,
		defaultType	: 'uniSearchSubPanel',
		collapsed	: UserInfo.appOption.collapseLeftSearch,
		listeners	: {
//			collapse: function () {
//				panelResult.show();
//			},
//			expand: function() {
//				panelResult.hide();
//			}
		},
		items		: [{	
			title		: '기본정보', 	
	   		itemId		: 'search_panel1',
			layout		: {type: 'uniTable', columns: 1},
			defaultType	: 'uniTextfield',
			items: [{ 
				fieldLabel		: '조회기간',
				xtype			: 'uniDateRangefield',
				startFieldName	: 'DATE_FR',
				endFieldName	: 'DATE_TO',
				allowBlank		: false,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('DATE_FR', newValue);
					}
					frDay = newValue;;
					setText();
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('DATE_TO', newValue);							
					}
					toDay = newValue;;
					setText();
				}
			},{ 
				fieldLabel		: '비교기간',
				xtype			: 'uniDateRangefield',
				startFieldName	: 'COMPARISON_DATE_FR',
				endFieldName	: 'COMPARISON_DATE_TO',
				allowBlank		: false,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('COMPARISON_DATE_FR', newValue);
					}
					frComparisonDay = newValue;;
					setText();
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('COMPARISON_DATE_TO', newValue);							
					}
					toComparisonDay = newValue;;
					setText();
				}
			},{
				xtype	: 'container',
				layout	: {type : 'uniTable', columns : 1},
				width	: 300,
				items	: [{
					xtype		: 'radiogroup',							
					fieldLabel	: '집계방법',
					items		: [{
						boxLabel	: '회사별', 
						width		: 70,
						name		: 'AGGREGATION_METHOD',
						inputValue	: 'C',
						checked		: true  
					},{
						boxLabel	: '담당자별',
						name		: 'AGGREGATION_METHOD', 
						width		: 70,
						inputValue	: 'P' 
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.getField('AGGREGATION_METHOD').setValue(newValue.AGGREGATION_METHOD);				 
						}
					}
				}]
			},{
			fieldLabel	: '채권구분',
			name		: 'CHECKBOX1',
			xtype		: 'uniCheckboxgroup', 
			items		: [{
	        	boxLabel	: '일반채권',
	        	name		: 'GENERAL_BOND',
				width		: 70,
	        	inputValue	: 'Y',
	        	checked		: true,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('GENERAL_BOND', newValue);
					}
				}
	        },{
	        	boxLabel	: '사후관리',
	        	name		: 'CONVERT_AMT',
				width		: 70,
	        	inputValue	: 'Y',
	        	checked		: true,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('CONVERT_AMT', newValue);
					}
				}
	        },{
	        	boxLabel	: '선조치',
	        	name		: 'PRE_ACT',
				width		: 70,
	        	inputValue	: 'Y',
	        	checked		: true,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('PRE_ACT', newValue);
					}
				}
	        }]
		}]	
		}]
	});
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		region	: 'north',
		layout	: {type : 'uniTable', columns : 2},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{ 
			fieldLabel		: '조회기간',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'DATE_FR',
			endFieldName	: 'DATE_TO',
			allowBlank		: false,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('DATE_FR', newValue);
				}
				frDay = newValue;
				setText();
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('DATE_TO', newValue);							
				}
				toDay = newValue;
				setText();
			}
		},{
			xtype	: 'container',
			layout	: {type : 'uniTable', columns : 1},
			width	: 300,
			items	: [{
				xtype		: 'radiogroup',							
				fieldLabel	: '집계방법',
				items		: [{
					boxLabel	: '회사별', 
					width		: 70,
					name		: 'AGGREGATION_METHOD',
					inputValue	: 'C',
					checked		: true  
				},{
					boxLabel	: '담당자별',
					name		: 'AGGREGATION_METHOD', 
					width		: 70,
					inputValue	: 'P' 
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.getField('AGGREGATION_METHOD').setValue(newValue.AGGREGATION_METHOD);				 
					}
				}
			}]
		},{ 
			fieldLabel		: '비교기간',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'COMPARISON_DATE_FR',
			endFieldName	: 'COMPARISON_DATE_TO',
			allowBlank		: false,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('COMPARISON_DATE_FR', newValue);
				}
				frComparisonDay = newValue;;
				setText();
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('COMPARISON_DATE_TO', newValue);							
				}
				toComparisonDay = newValue;;
				setText();
			}
		},{
			fieldLabel	: '채권구분',
			name		: 'CHECKBOX1',
			xtype		: 'uniCheckboxgroup', 
			items		: [{
	        	boxLabel	: '일반채권',
	        	name		: 'GENERAL_BOND',
				width		: 70,
	        	inputValue	: 'Y',
	        	checked		: true,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('GENERAL_BOND', newValue);
					}
				}
	        },{
	        	boxLabel	: '사후관리',
	        	name		: 'CONVERT_AMT',
				width		: 70,
	        	inputValue	: 'Y',
	        	checked		: true,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('CONVERT_AMT', newValue);
					}
				}
	        },{
	        	boxLabel	: '선조치',
	        	name		: 'PRE_ACT',
				width		: 70,
	        	inputValue	: 'Y',
	        	checked		: true,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('PRE_ACT', newValue);
					}
				}
	        }]
		}]
	});
	
	
	
	/** Master Grid1 정의(Grid Panel) @type
	 * 
	 */	
	var masterGrid = Unilite.createGrid('Arc230skrGrid', {
		region		: 'center',
		excelTitle	: '법무채권총괄표',
		store		: masterStore,
//		selModel	: 'rowmodel',
		features: [ {id: 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
					{id: 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false		, dock:'bottom'}
		],
		uniOpt: {
			useMultipleSorting	: true,
			useLiveSearch		: true,
			onLoadSelectFirst	: true,
			dblClickToEdit		: false,
			useGroupSummary		: false,
			useContextMenu		: false,
			useRowNumberer		: true,
			expandLastColumn	: true,
//			useRowContext		: true,
			filter: {
				useFilter		: true,
				autoCreate		: true
			}
		},
		/*viewConfig: {
			getRowClass: function(record, rowIndex, rowParams, store){
				if(record.get('TYPE_FLAG') == 'S'){
					return 'x-change-cell_Background_normal_Text_blue';	
				}
			}
		},*/
		columns:[
			{dataIndex: 'RECE_GUBUN'					, width: 80		, hidden: true},
			{dataIndex: 'RECE_COMP_CODE'				, width: 120	, hidden: true},
			{dataIndex: 'RECE_COMP_NAME'				, width: 120	, hidden: true},
			{dataIndex: 'CONF_RECE_NO'					, width: 120	, hidden: true},
			{dataIndex: 'CUSTOM_NAME'					, width: 120},
			{dataIndex: 'TOP_NAME'						, width: 80		, hidden: true		,align:'center'},
			{dataIndex: 'CONF_DRAFTER_NAME'				, width: 120	, hidden: true},
			{dataIndex: 'MNG_GUBUN'						, width: 100	, hidden: true		,align:'center'},
			{text: '~'	, itemId: 'period'				,
				columns:[
					{dataIndex: 'TOT_CARRYOVER_AMT'		, width: 120},
					{dataIndex: 'TOT_RECEIVE_AMT'		, width: 120},
					{dataIndex: 'COLLECT_AMT'			, width: 120},
					{dataIndex: 'TOT_CONVERT_AMT'		, width: 120},
					{dataIndex: 'TOT_ADJUST_AMT'		, width: 120		, hidden: true},
					{dataIndex: 'TOT_BALANCE_AMT'		, width: 120},
					{dataIndex: 'TOT_DISPOSAL_AMT'		, width: 120		, hidden: true},
					{dataIndex: 'TOT_BOOKVALUE_AMT'		, width: 120		, hidden: true}
				]
			},
			{text: '~'	, itemId: 'comparison_period'	,
				columns:[
					{dataIndex: 'TOT_CARRYOVER_AMT2'	, width: 120},
					{dataIndex: 'TOT_RECEIVE_AMT2'		, width: 120},
					{dataIndex: 'COLLECT_AMT2'			, width: 120},
					{dataIndex: 'TOT_CONVERT_AMT2'		, width: 120},
					{dataIndex: 'TOT_ADJUST_AMT2'		, width: 120		, hidden: true},
					{dataIndex: 'TOT_BALANCE_AMT2'		, width: 120},
					{dataIndex: 'TOT_DISPOSAL_AMT2'		, width: 120		, hidden: true},
					{dataIndex: 'TOT_BOOKVALUE_AMT2'	, width: 120		, hidden: true}
				]
			}
		],
//		uniRowContextMenu:{
//			items: [
//				{	text: '법무채권등록 보기',   
//					handler: function(menuItem, event) {
//						var param = menuItem.up('menu');
//						masterGrid.gotoArc200ukr(param.record);
//					}
//				}
//			]
//		},
		listeners: {
//			itemmouseenter:function(view, record, item, index, e, eOpts )	{  
//				view.ownerGrid.setCellPointer(view, item);
//			}
		}
//		onItemcontextmenu:function( menu, grid, record, item, index, event  )	{ 
//	  		return true;
//	  	},
//		gotoArc200ukr:function(record)	{
//			if(record)	{
//				var params = {
//					action:'select', 
//					'PGM_ID' : 'arc230skr',
//					'CONF_RECE_NO' : record.data['CONF_RECE_NO']
//					
//					//파라미터 추후 추가
//				}
//		  		var rec1 = {data : {prgID : 'arc200ukr', 'text':''}};							
//				parent.openTab(rec1, '/accnt/arc200ukr.do', params);
//			}
//		}
	});   
	
	 Unilite.Main( {
		id 			: 'Arc230skrApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			borde	: false,
			items	: [
				masterGrid, panelResult
			]
		},
			panelSearch  	
		], 
		fnInitBinding : function() {
			panelSearch.setValue('DATE_FR', UniDate.get('startOfYear'));
			panelSearch.setValue('DATE_TO', UniDate.get('endOfYear'));
			panelResult.setValue('DATE_FR', UniDate.get('startOfYear'));
			panelResult.setValue('DATE_TO', UniDate.get('endOfYear'));
			
			panelSearch.setValue('COMPARISON_DATE_FR', UniDate.get('startOfLastYear'));
			panelSearch.setValue('COMPARISON_DATE_TO', UniDate.get('endOfLastYear'));
			panelResult.setValue('COMPARISON_DATE_FR', UniDate.get('startOfLastYear'));
			panelResult.setValue('COMPARISON_DATE_TO', UniDate.get('endOfLastYear'));
			
			UniAppManager.setToolbarButtons('reset'	, true);
			
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('DATE_FR');
		},
		onQueryButtonDown : function()	{		
			if(!this.isValidSearchForm()){					//필수체크
				 return;
			}
			masterStore.loadStoreRecords();
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			masterStore.clearData();
			this.fnInitBinding();
		}
	});	
	
	function setText() {
		var resutlFrDay				= Ext.Date.dateFormat(frDay, 'Y.m.d')
		var resutlToDay				= Ext.Date.dateFormat(toDay, 'Y.m.d')
		var resutlFrComparisonDay	= Ext.Date.dateFormat(frComparisonDay, 'Y.m.d')
		var resutlToComparisonDay	= Ext.Date.dateFormat(toComparisonDay, 'Y.m.d')
   		masterGrid.down('#period').setText(resutlFrDay + ' ~ ' + resutlToDay);
   		masterGrid.down('#comparison_period').setText(resutlFrComparisonDay + ' ~ ' + resutlToComparisonDay);
	}

};


</script>
