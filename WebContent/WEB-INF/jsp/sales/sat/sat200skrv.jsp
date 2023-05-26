<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="sat200skrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="sat200skrv" />				<!-- 사업장 -->
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
	
	var typeStore = Ext.create('Ext.data.Store', {
	    fields: ['value', 'text'],
	    data : [
	        {'value':'1', 'text':'출고요청'},
	        {'value':'2', 'text':'예약'}
	    ]
	});
	
	
	//마스터 모델
	Unilite.defineModel('sat200skrvMasterModel',{
		fields: [
 			  {name : 'DIV_CODE'        	, text : '사업장코드'     	, type : 'string'   , comboType: "BOR120" }
 			, {name : 'REQ_NO'          	, text : '출고요청번호'     	, type : 'string'   }
 			, {name : 'REQ_SEQ'         	, text : '요청순번'      	, type : 'string'   }
 			, {name : 'REQ_DATE'            , text : '출고요청일'      	, type : 'uniDate'  }
			, {name : 'CUSTOM_NAME'         , text : '납품처'         	, type : 'string'   }
			, {name : 'SAT210T_COUNT'       , text : '수량'          	, type : 'uniQty'   }
			, {name : 'AGENT_CUSTOM_CODE'   , text : '대리점 거래처코드' 	, type : 'string'   }
			, {name : 'AGENT_CUSTOM_NAME'   , text : '대리점 거래처코드' 	, type : 'string'   }
			, {name : 'OUT_DATE'            , text : '출고예정일'      	, type : 'uniDate'  }
			, {name : 'USE_GUBUN'           , text : '사용구분'        , type : 'string'   , comboType: "AU"	,comboCode:"S178"}
			, {name : 'DELIVERY_METH'       , text : '배송방법'       	, type : 'string'   , comboType: "AU"	,comboCode:"S175"}
			, {name : 'REQ_USER'            , text : '출고요청자'     	, type : 'string'   }
			, {name : 'REQ_USER_NAME'       , text : '출고요청자'     	, type : 'string'   }
			, {name : 'REMARK'              , text : '요청사항'       	, type : 'string'   }
			, {name : 'INOUT_DATE'          , text : '출고일'       	, type : 'uniDate'  }
			, {name : 'INOUT_NUM'           , text : '출고번호'       	, type : 'string'   }
		]
	});
	
	Unilite.defineModel('sat200skrvDetailModel',{
		fields: [
 			  {name : 'DIV_CODE'        , text : '사업장코드'     	, type : 'string'      , comboType: "BOR120" }
 			, {name : 'REQ_NO'          , text : '출고요청번호'     	, type : 'string'    }
 			, {name : 'REQ_SEQ'         , text : '요청순번'      	, type : 'string'    }
 			, {name : 'ASST_CODE'       , text : '자산코드'     	, type : 'string'       }
			, {name : 'ASST_NAME'       , text : '자산명'      	, type : 'string'       }
			, {name : 'SERIAL_NO'       , text : 'S/N'          , type : 'string'       }
			, {name : 'ASST_INFO'       , text : '자산정보'  		, type : 'string'   , comboType: "AU"	,comboCode:"S178"  }
			, {name : 'ASST_GUBUN'      , text : '구분'  			, type : 'string'  	, comboType: "AU"	,comboCode:"S179"  }
			, {name : 'OUT_YN'          , text : '출고여부'  		, type : 'string'  	, comboType: "AU"	,comboCode:"B131" }
			
		]
	});// End of Unilite.defineModel('Ssa101ukrvModel',{

	// 마스터 스토어 정의
	var masterStore = Unilite.createStore('sat200skrvMasterStore',{
		model	: 'sat200skrvMasterModel',
		proxy	: Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
			api: {
				read	: 'sat200skrvService.selectMaster'
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

	var detailStore = Unilite.createStore('sat200skrvDetailStore',{
		model	: 'sat200skrvDetailModel',
		proxy	: Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
			api: {
				read	: 'sat200skrvService.selectList'
			}
		}),
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결
			editable	: false,		// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			allDeletable: false,	// 전체 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		loadStoreRecords: function(param) {
			
			console.log(param);
			this.load({
				params : param
			});
		}
	});
	//마스터 폼
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
			fieldLabel	: '납품처',
			name		: 'CUSTOM_NAME'
		},{
			fieldLabel	: '자산',
			name		: 'ASST'
		},{
			fieldLabel	: '상태',
			name		: 'OUT_YN',
			xtype       : 'uniRadiogroup',
			value       : 'N',
			items : [
				{name:'OUT_YN', boxLabel:'요청' , inputValue : 'N' , width : 80 },
				{name:'OUT_YN', boxLabel:'완료' , inputValue : 'Y' , width : 80 }
			]
			
		}]
	});// End of var panelResult = Unilite.createSearchForm('searchForm',{
		
	// 마스터 그리드
	var masterGrid = Unilite.createGrid('sat200skrvGrid',{
		store	: masterStore,
		layout	: 'fit',
		region	: 'center',
		flex : .7,
		selModel: Ext.create('Ext.selection.CheckboxModel', { mode : "SINGLE" , checkOnly : false, toggleOnClick:true }),
		uniOpt	: {
			expandLastColumn	: true,
			useRowNumberer		: false,
			onLoadSelectFirst	: false
		},
		tbar    : [
				{
					xtype   : 'button',
					text    : '신청서',
					handler : function() {
						if(UniAppManager.app._needSave())	{
							Unilite.messageBox("저장할 데이터가 있습니다. 저장 후 실행하세요.");
							return;
						}
					
						if(!Ext.isEmpty(masterGrid.getSelectedRecord()) )	{
							var params = masterGrid.getSelectedRecord().data;
							
							masterGrid.printBtn(params, 'APPLY');
						} else {
							Unilite.messageBox("출고요청내용을 선택하세요.");
						}
					}
				},
			{
				xtype   : 'button',
				text    : '출고요청 수정',
				handler : function() {
					if(UniAppManager.app._needSave())	{
						Unilite.messageBox("저장할 데이터가 있습니다. 저장 후 실행하세요.");
						return;
					}
				
					if(!Ext.isEmpty(masterGrid.getSelectedRecord()) )	{
						var params = masterGrid.getSelectedRecord().data;
						var rec = {data : {prgID : 'sat200ukrv', 'text':''}};
						parent.openTab(rec, '/sales/sat200ukrv.do', params);
					} else {
						Unilite.messageBox("출고요청내용을 선택하세요.");
					}
				}
			},{
				xtype   : 'button',
				text    : '출고',
				handler : function() {
					if(UniAppManager.app._needSave())	{
						Unilite.messageBox("저장할 데이터가 있습니다. 저장 후 실행하세요.");
						return;
					}
					if(!Ext.isEmpty(masterGrid.getSelectedRecord()) )	{
						var params = masterGrid.getSelectedRecord().data;
						
						var rec = {data : {prgID : 'sat600ukrv', 'text':''}};
						parent.openTab(rec, '/sales/sat600ukrv.do', params);
					} else {
						Unilite.messageBox("출고할 자산을 선택하세요.");
					}
					
				}
			}
		],
		columns	: [
			  {dataIndex : 'REQ_DATE'        , width : 80  }
			, {dataIndex : 'CUSTOM_NAME'     , width : 150 }
			, {dataIndex : 'SAT210T_COUNT'   , width : 70  }
			, {dataIndex : 'USE_GUBUN'       , width : 100 }
			, {dataIndex : 'REQ_USER_NAME'   , width : 150 }
			, {dataIndex : 'INOUT_DATE'      , width : 80  }
			, {dataIndex : 'DELIVERY_METH'   , width : 100 }
			, {dataIndex : 'REQ_NO'          , width : 100 }
			, {dataIndex : 'INOUT_NUM'       , width : 110 }
		],
		listeners:{
			selectionchange:function(grid, selected)	{
				if(!Ext.isEmpty(selected))	{
					detailStore.loadStoreRecords(selected[0].data);
				} else {
					detailStore.loadData({});
				}
			}
		},
		// 출력
		printBtn:function(record, gubun){
			var param				= {};
			param['DIV_CODE']		= record.DIV_CODE;
			param['REQ_NO']			= record.REQ_NO; // 출고요청번호
			param['PGM_ID']			= PGM_ID;       
			param['GUBUN']			= gubun;         // 신청서 : 'APPLY', 인수증 : 'TAKE'
			param['MAIN_CODE']		= 'S036';

			var win = Ext.create('widget.ClipReport', {
				url		 : CPATH+'/sales/sat200clskrv.do',
				prgID	 : 'sat200skrv',
				extParam : param
			});
			win.center();
			win.show();
		}
	});
	
	var detailGrid = Unilite.createGrid('sat200skrvDetailGrid',{
		store	: detailStore,
		layout	: 'fit',
		region	: 'south',
		uniOpt	: {
			expandLastColumn	: true,
			useRowNumberer		: false,
			onLoadSelectFirst	: false
		},
		flex : .3,
		columns	: [
			  {dataIndex : 'ASST_CODE'      , width : 100 }
			, {dataIndex : 'ASST_NAME'      , width : 150 }
			, {dataIndex : 'SERIAL_NO'      , width : 150 }
			, {dataIndex : 'ASST_INFO'      , width : 100 }
			, {dataIndex : 'ASST_GUBUN'     , width : 100 }
			, {dataIndex : 'OUT_YN'         , width : 100 }
		]
	});
	Unilite.Main( {
		id			: 'sat200skrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				panelResult, 
				{
					xtype : 'panel',
					region  : 'center',
					layout	: 'border',
					border	: false,
					items :[
						masterGrid, 
						detailGrid
					]
				}
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
