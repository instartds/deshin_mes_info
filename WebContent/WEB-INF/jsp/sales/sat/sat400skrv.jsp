<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="sat400skrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="sat400skrv" />				<!-- 사업장 -->
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
	
	
	//마스터 모델
	Unilite.defineModel('sat400skrvMasterModel',{
		fields: [
 			  {name : 'DIV_CODE'        	, text : '사업장코드'     	, type : 'string'   , comboType: "BOR120" }
 			, {name : 'CHANGE_NO'          	, text : '요청번호'     	, type : 'string'   }
 			, {name : 'CHANGE_SEQ'         	, text : '요청순번'     	, type : 'string'   }
 			, {name : 'ASST_CODE'           , text : '자산코드'     	, type : 'string'   }
			, {name : 'ASST_NAME'           , text : '자산명'      	, type : 'string'   }
			, {name : 'SERIAL_NO'           , text : 'S/N'         	, type : 'string'   }
 			, {name : 'RESERVE_DATE'        , text : '요청일'      	, type : 'uniDate'  }
 			, {name : 'CUSTOM_NAME'         , text : '현납품처'       	, type : 'string'   }
 			, {name : 'MOVE_CUST_NM'        , text : '이동납품처'      	, type : 'string'   }
			, {name : 'USE_FR_DATE'         , text : '시작사용기간'     	, type : 'uniDate'  }
			, {name : 'USE_TO_DATE'         , text : '종료사용기간'     	, type : 'uniDate'  }
			, {name : 'REQ_USER'            , text : '요청자'     		, type : 'string'   }
			, {name : 'REQ_USER_NAME'       , text : '요청자'     		, type : 'string'   }
			, {name : 'RETURN_DATE'        	, text : '예상반납일'      	, type : 'uniDate'  }
			, {name : 'ASST_INFO'           , text : '자산정보'  		, type : 'string'   , comboType: "AU"	,comboCode:"S178"}
			, {name : 'ASST_GUBUN'          , text : '구분'  			, type : 'string'  	, comboType: "AU"	,comboCode:"S179"}
			, {name : 'ASST_STATUS'         , text : '현재상태'  		, type : 'string'  	, comboType: "AU"	,comboCode:"S177"}
		]
	});
	

	// 마스터 스토어 정의
	var masterStore = Unilite.createStore('sat400skrvMasterStore',{
		model	: 'sat400skrvMasterModel',
		proxy	: Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
			api: {
				read	: 'sat400skrvService.selectList'
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

	var panelResult =  Unilite.createSearchForm('resultForm',{
		region: 'north',	
		layout : {type : 'uniTable', columns : 4},
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
			fieldLabel	: '요청일',
			startFieldName: 'RESERVE_DATE_FR',
			endFieldName  : 'RESERVE_DATE_TO',
			xtype       : 'uniDateRangefield',
			startDate   : UniDate.get('aMonthAgo'),
			endDate     : UniDate.today(),
			allowBlank  : false
		},{
			fieldLabel	: '구분',
			name		: 'GUBUN',
			xtype       : 'uniRadiogroup',
			items : [
				{name:'GUBUN', boxLabel:'전체' , inputValue : ''  , width : 80 , checked : true},
				{name:'GUBUN', boxLabel:'이동' , inputValue : '2' , width : 80 },
				{name:'GUBUN', boxLabel:'연장' , inputValue : '1' , width : 80 }
				
			]
		}]
	});// End of var panelResult = Unilite.createSearchForm('searchForm',{
		
	// 마스터 그리드
	var masterGrid = Unilite.createGrid('sat400skrvGrid',{
		store	: masterStore,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			expandLastColumn	: true,
			useRowNumberer		: false,
			onLoadSelectFirst	: false
		},
		columns	: [
			  {dataIndex : 'DIV_CODE'      	, width : 80  , hidden : true}
			, {dataIndex : 'RESERVE_DATE'   , width : 100 }
			, {dataIndex : 'CUSTOM_NAME'  	, width : 100 }
			, {dataIndex : 'MOVE_CUST_NM'  	, width : 100 }

			, {dataIndex : 'USE_FR_DATE'   	, width : 100 }
			, {dataIndex : 'USE_TO_DATE'   	, width : 100 }
			, {dataIndex : 'REQ_USER'       , width : 100 , hidden : true}
			, {dataIndex : 'REQ_USER_NAME'  , width : 110 }
			, {dataIndex : 'RETURN_DATE'    , width : 100 }
			, {dataIndex : 'ASST_CODE'      , width : 100 }
			, {dataIndex : 'ASST_NAME'      , width : 150 }
			, {dataIndex : 'SERIAL_NO'     	, width : 150 }
			, {dataIndex : 'ASST_INFO'      , width : 100 }
			, {dataIndex : 'ASST_GUBUN'     , width : 100 }
			, {dataIndex : 'ASST_STATUS'    , width : 100 }
			, {dataIndex : 'CHANGE_NO'     	, width : 120 }
			, {dataIndex : 'CHANGE_SEQ'     , width : 100 }
		],                 
		listeners:{
			onGridDblClick:function(grid, record, cellIndex, colName) {
				var params = {
						DIV_CODE: record.get("DIV_CODE"),
						CHANGE_NO  : record.get('CHANGE_NO')
				}
				
				var rec = {data : {prgID : 'sat400ukrv', 'text':''}};
				parent.openTab(rec, '/sales/sat400ukrv.do', params);
			}
		}
	});
	
	Unilite.Main( {
		id			: 'sat400skrvApp',
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
			this.fnInitBinding();
		},
		
	});// End of Unilite.Main( {
};
</script>
