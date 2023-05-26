<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="sat600skrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="sat600skrv" />				<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="S175"/>						<!-- 배송방법 -->
	<t:ExtComboStore comboType="AU" comboCode="S178"/>						<!-- 자산정보 -->
	<t:ExtComboStore comboType="AU" comboCode="S179"/>						<!-- 구분 -->
	<t:ExtComboStore comboType="AU" comboCode="S177"/>						<!-- 현재상태 -->
	<t:ExtComboStore comboType="AU" comboCode="B131"/>						<!-- 예/아니오 -->
</t:appConfig>

<style type="text/css">
.search-hr {height: 1px;}
</style>
<script type="text/javascript">

function appMain() {
	
	var inoutTypeStore = Ext.create('Ext.data.Store', {
		storeId : 'CBS_AU_INOUTMETHOD',
	    fields: ['value', 'text'],
	    data : [
	        {'value':'1', 'text':'입고'},
	        {'value':'2', 'text':'출고'}
	    ]
	});
	
	var inoutMethodStore = Ext.create('Ext.data.Store', {
		
	    fields: ['value', 'text'],
	    data : [
	        {'value':'', 'text':'정상'},
	        {'value':'1', 'text':'연장'},
	        {'value':'2', 'text':'이동'}
	    ]
	});
	
	//마스터 모델
	Unilite.defineModel('sat600skrvModel',{
		fields: [
 			  {name : 'DIV_CODE'        	, text : '사업장코드'     	, type : 'string'   , comboType: "BOR120" }
 			, {name : 'INOUT_NUM'           , text : '수불번호'       	, type : 'string'   }
			, {name : 'ASST_CODE'           , text : '자산코드'    	, type : 'string'   }
			, {name : 'ASST_NAME'           , text : '자산명'      	, type : 'string'   }
			, {name : 'SERIAL_NO'           , text : 'S/N'         	, type : 'string'   }
			, {name : 'INOUT_TYPE'          , text : '수불구분 '   		, type : 'string'    , store: inoutTypeStore   }
			, {name : 'INOUT_METH'          , text : '수불방법'      	, type : 'string'    , store: inoutMethodStore }
			, {name : 'INOUT_DATE'          , text : '입출고일'       	, type : 'uniDate'   }
			, {name : 'CUSTOM_NAME'         , text : '납품처명'        , type : 'string'   }
			, {name : 'USE_FR_DATE'         , text : '시작사용기간'     	, type : 'uniDate'   }
			, {name : 'USE_TO_DATE'         , text : '종료사용기간'     	, type : 'uniDate'   }
			, {name : 'REST_DAYS'           , text : '잔여일'        	, type : 'int'      }
			, {name : 'DELAY_DAYS'          , text : '연체일'        	, type : 'int'      }
			, {name : 'INOUT_NUM'           , text : '수불번호'       	, type : 'string'   }
			, {name : 'INOUT_SEQ'           , text : '출고순번'    	, type : 'uniPrice' }
			, {name : 'BASIS_NUM'           , text : '참조번호'       	, type : 'string'   }
			, {name : 'REMARK'              , text : '비고'       	, type : 'string'   }
			, {name : 'REQ_NO'              , text : '비고'       	, type : 'string'   }
			, {name : 'REQ_SEQ'             , text : '비고'       	, type : 'string'   }
			, {name : 'USE_GUBUN'  		, text : '사용구분'    	, type : 'string'   ,comboType   : 'AU', comboCode   : 'S178'}
		]
	});
	

	// 마스터 스토어 정의
	var masterStore = Unilite.createStore('sat600skrvMasterStore',{
		model	: 'sat600skrvModel',
		proxy	: Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
			api: {
				read	: 'sat600skrvService.selectList'
			}
		}),
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,		// 상위 버튼 연결
			editable	: false,		// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			allDeletable: false,	// 전체 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		loadStoreRecords: function() {
			var param		= panelResult.getValues();

			console.log(param);
			this.load({
				params : param
			});
		}
	});

	//마스터 폼
	var panelResult =  Unilite.createSearchForm('resultForm',{
		region: 'north',	
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel	: '사업장',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false,
			tdAttrs     : {width : 350},
			value		: UserInfo.divCode
		},{
			fieldLabel	: '입출고일',
			startFieldName: 'INOUT_DATE_FR',
			endFieldName  : 'INOUT_DATE_TO',
			xtype       : 'uniDateRangefield',
			startDate   : UniDate.get('aMonthAgo'),
			endDate     : UniDate.today(),
			allowBlank  : false
		},{
			xtype		: 'uniCheckboxgroup',
			fieldLabel	: '유형',
			name		: 'INOUT_TYPE',
			//store       : Ext.data.StoreManager.lookup('inoutMethodStore'),
			comboType   : 'AU',
			comboCode   : 'INOUTMETHOD',
			allowBlank  : false,
			initAllTrue : true,
			width       : 300,
			/*  _getStore  : function() {
			    	var storeId = 'inoutMethodStore';
			    	var mStore =	Ext.data.StoreManager.lookup(storeId)
				 	return mStore;
			 } */
		},{
			fieldLabel	: '납품처',
			name		: 'CUSTOM_NAME'
		},{
			fieldLabel	: '자산',
			name		: 'ASST'
		}]
	});// End of var panelResult = Unilite.createSearchForm('searchForm',{
		
	// 마스터 그리드
	var masterGrid = Unilite.createGrid('sat600skrvGrid',{
		store	: masterStore,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			expandLastColumn	: false
		},
		columns	: [
			  {dataIndex : 'DIV_CODE'       , width : 100  , hidden : true}
			, {dataIndex : 'ASST_CODE'      , width : 100 }
			, {dataIndex : 'ASST_NAME'      , width : 150 }
			, {dataIndex : 'SERIAL_NO'      , width : 150 }
			
			, {dataIndex : 'INOUT_TYPE'     , width : 80  }
			, {dataIndex : 'INOUT_METH'     , width : 80 }
			, {dataIndex : 'INOUT_DATE'     , width : 100 }
			, {dataIndex : 'CUSTOM_NAME'    , width : 150 }
			, {dataIndex : 'USE_GUBUN'      , width : 80 }
			, {dataIndex : 'USE_FR_DATE'    , width : 100 }
			, {dataIndex : 'USE_TO_DATE'    , width : 100 }
			, {dataIndex : 'REST_DAYS'      , width : 80 }
			, {dataIndex : 'DELAY_DAYS'     , width : 80 }
			, {dataIndex : 'INOUT_NUM'      , width : 110 }
			, {dataIndex : 'INOUT_SEQ'      , width : 100 , hidden : true}
			, {dataIndex : 'BASIS_NUM'      , width : 110 }
			, {dataIndex : 'REMARK'         , minWidth : 150 , flex  : 1 }
			
		],
		listeners:{
			onGridDblClick:function(grid, record, cellIndex, colName) {
				if(record.get('INOUT_TYPE')=='1')	{
					var params = {
							DIV_CODE: record.get("DIV_CODE"),
							INOUT_NUM: record.get('INOUT_NUM'),
							BASIS_NUM: record.get('BASIS_NUM')
					}
					
					var rec = {data : {prgID : 'sat610ukrv', 'text':''}};
					parent.openTab(rec, '/sales/sat610ukrv.do', params);
				} else if(record.get('INOUT_TYPE')=='2')	{
					var params = {
						DIV_CODE: record.get("DIV_CODE"),
						INOUT_NUM: record.get('INOUT_NUM')
					}
					var rec = {data : {prgID : 'sat600ukrv', 'text':''}};
					parent.openTab(rec, '/sales/sat600ukrv.do', params);
				}
			},
			afterrenderX: function(grid) {
				var me = this;
				this.contextMenu = Ext.create('Ext.menu.Menu', {});
				
				this.contextMenu.add({
					text: '출고등록',   iconCls : '',
					handler: function(menuItem, event) {
						var records = grid.getSelectionModel().getSelection();
						var record = records[0];
						var params = {
							DIV_CODE: record.get("DIV_CODE"),
							INOUT_NUM: record.get('INOUT_TYPE')=='2' ? record.get('INOUT_NUM') : record.get('BASIS_NUM')
						}
						var rec = {data : {prgID : 'sat600ukrv', 'text':''}};
						parent.openTab(rec, '/sales/sat600ukrv.do', params);
					}
				});
				this.contextMenu.add({
					text: '입고등록',   iconCls : '',
					handler: function(menuItem, event) {
						var records = grid.getSelectionModel().getSelection();
						var record = records[0];
						var params = {};
						if(record.get('INOUT_TYPE')=='1')	{
							params = {
								DIV_CODE: record.get("DIV_CODE"),
								INOUT_NUM: record.get('INOUT_NUM'),
								BASIS_NUM: record.get('BASIS_NUM')
							}
						} else {
							params = {
								DIV_CODE: record.get("DIV_CODE"),
								INOUT_NUM: null,
								BASIS_NUM: record.get('INOUT_NUM')
							}
						}
						var rec = {data : {prgID : 'sat610ukrv', 'text':''}};
						parent.openTab(rec, '/sales/sat610ukrv.do', params);
					}
				});
			}
		}
	});
	
	
	Unilite.Main( {
		id			: 'sat600skrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				panelResult, 
				masterGrid
			]
		}],
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons(['reset']	, true);
			this.setDefault();
			
		},
		setDefault: function() {
			
			panelResult.setValue('DIV_CODE', UserInfo.divCode);
			panelResult.getForm().wasDirty = false;
			panelResult.resetDirtyStatus();

			UniAppManager.setToolbarButtons('save', false);
		},
		onQueryButtonDown: function() {
			if(!panelResult.getInvalidMessage()) return;	//필수체크
			masterStore.loadStoreRecords();
		},
		onResetButtonDown: function() {
			panelResult.clearForm();
			masterStore.loadData({});
			detailStore.loadData({});
			this.fnInitBinding();
		},
		
	});// End of Unilite.Main( {
};
</script>
