<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="sat300skrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="sat300skrv" />				<!-- 사업장 -->
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
	Unilite.defineModel('sat300skrvMasterModel',{
		fields: [
 			  {name : 'DIV_CODE'        	, text : '사업장코드'     	, type : 'string'   , comboType: "BOR120" }
 			, {name : 'RESERVE_NO'          , text : '예약번호'     	, type : 'string'   }
 			, {name : 'RESERVE_SEQ'         , text : '예약순번'     	, type : 'string'   }
 			, {name : 'ASST_CODE'           , text : '자산코드'     	, type : 'string'   }
			, {name : 'ASST_NAME'           , text : '자산명'      	, type : 'string'   }
			, {name : 'SERIAL_NO'           , text : 'S/N'          , type : 'string'   }
 			, {name : 'RESERVE_DATE'        , text : '예약요청일'      	, type : 'uniDate'  }
 			, {name : 'REQ_OUT_DATE'        , text : '예약출고일'      	, type : 'uniDate'  }
 			, {name : 'CUSTOM_NAME'         , text : '납품처'         	, type : 'string'   }
			, {name : 'USE_FR_DATE'         , text : '시작사용기간'     	, type : 'uniDate'  }
			, {name : 'USE_TO_DATE'         , text : '종료사용기간'     	, type : 'uniDate'  }
			, {name : 'AGENT_CUSTOM_CODE'   , text : '대리점 거래처코드' 	, type : 'string'   }
			, {name : 'AGENT_CUSTOM_NAME'   , text : '대리점 거래처코드' 	, type : 'string'   }
			, {name : 'USE_GUBUN'           , text : '사용구분'        , type : 'string'   , comboType: "AU"	,comboCode:"S178"}
			, {name : 'DELIVERY_METH'       , text : '배송방법'       	, type : 'string'   , comboType: "AU"	,comboCode:"S175"}
			, {name : 'REQ_USER'            , text : '예약요청자'     	, type : 'string'   }
			, {name : 'REQ_USER_NAME'       , text : '예약요청자'     	, type : 'string'   }
			, {name : 'REMARK'              , text : '비고'       	, type : 'string'   }
			, {name : 'ASST_STATUS'         , text : '현재상태'       	, type : 'string'    , comboType: "AU"	,comboCode:"S177"}
			, {name : 'ASST_INFO'           , text : '자산정보'  		, type : 'string'   , comboType: "AU"	,comboCode:"S178"}
			, {name : 'ASST_GUBUN'          , text : '구분'  			, type : 'string'  	, comboType: "AU"	,comboCode:"S179"}
			, {name : 'REQ_YN'              , text : '출고요청여부'  	, type : 'string'  	, comboType: "AU"	,comboCode:"B131"}
			, {name : 'RESERVE_YN'          , text : '예약여부'  	, type : 'string'  	, comboType: "AU"	,comboCode:"B131"}
			
		]
	});
	

	// 마스터 스토어 정의
	var masterStore = Unilite.createStore('sat300skrvMasterStore',{
		model	: 'sat300skrvMasterModel',
		proxy	: Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
			api: {
				read	: 'sat300skrvService.selectMaster'
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
			fieldLabel	: '납품처',
			name		: 'CUSTOM_NAME'
		},{
			fieldLabel	: '자산',
			name		: 'ASST'
		},{
			fieldLabel	: '상태',
			name		: 'REQ_YN',
			xtype       : 'uniRadiogroup',
			value       : 'N',
			items : [
				{name:'REQ_YN', boxLabel:'예약' , inputValue : 'N' , width : 80 },
				{name:'REQ_YN', boxLabel:'출고요청' , inputValue : 'Y' , width : 80 }
			]
		}]
	});// End of var panelResult = Unilite.createSearchForm('searchForm',{
		
	// 마스터 그리드
	var masterGrid = Unilite.createGrid('sat300skrvGrid',{
		store	: masterStore,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			expandLastColumn	: true,
			useRowNumberer		: false,
			onLoadSelectFirst	: false
		},
		selModel: Ext.create('Ext.selection.CheckboxModel', { mode : "MULTI" , checkOnly : false, toggleOnClick:true }),
		tbar    : [
			{
				xtype   : 'button',
				text    : '출고요청',
				handler : function() {
					if(UniAppManager.app._needSave())	{
						Unilite.messageBox("저장할 데이터가 있습니다. 저장 후 실행하세요.");
						return;
					}
					
					if(!Ext.isEmpty(masterGrid.getSelectedRecords()) )	{
						var params = masterGrid.getSelectedRecord().data;
						var selectdRecords = masterGrid.getSelectedRecords();
						var asstData = [];
						var check1 = true, message1='';
						var check2 = true, message2='';
						var check3 = true, message3='';
						if(selectdRecords && selectdRecords.length > 0)	{
							Ext.each(selectdRecords, function(data, idx){ 
								if(params.RESERVE_NO != data.get("RESERVE_NO"))	{
									check1 = false;
									message1 += data.get("ASST_NAME")+"("+data.get("ASST_CODE")+")\n";
									return;
								}
								if(data.get("ASST_STATUS") != 'S')	{
									check2 = false;
									message2 += data.get("ASST_NAME")+"("+data.get("ASST_CODE")+")\n";
									return;
								}
								if(data.get("REQ_USER") != UserInfo.userID)	{
									check3 = false;
									message3 += data.get("ASST_NAME")+"("+data.get("ASST_CODE")+")\n";
									return;
								}
								asstData.push(data.data);
							})
						}
						if(!check1)	{
							Unilite.messageBox("예약번호가 다른자산이 선택되었습니다.", message1, '', {'showDetail' : true });
							return;
						}
						if(!check2)	{
							Unilite.messageBox("보유되지 않은 자산이 선택되었습니다.", message2, '',{'showDetail' : true });
							return;
						}
						if(!check3)	{
							Unilite.messageBox("예약담당자만 출고 요청할 수 있습니다.", message3, '', {'showDetail' : true });
							return;
						}
						params.ASST_DATA = asstData;
						var rec = {data : {prgID : 'sat200ukrv', 'text':''}};
						parent.openTab(rec, '/sales/sat200ukrv.do', params);
					
					} else {
						Unilite.messageBox("출고요청내용을 선택하세요.");
					}
				}
			}
		],
		columns	: [
			  {dataIndex : 'RESERVE_DATE'   , width : 80  }
			, {dataIndex : 'REQ_USER_NAME' 	, width : 100 }
			, {dataIndex : 'ASST_CODE'      , width : 100 }
			, {dataIndex : 'ASST_NAME'      , width : 150 }
			, {dataIndex : 'SERIAL_NO'      , width : 150 }
			, {dataIndex : 'REQ_OUT_DATE'   , width : 80  }
			, {dataIndex : 'USE_FR_DATE'    , width : 100 }
			, {dataIndex : 'USE_TO_DATE'  	, width : 100 }
			, {dataIndex : 'CUSTOM_NAME'   	, width : 150 , hidden : true}
			, {dataIndex : 'USE_GUBUN'     	, width : 100 , hidden : true}
			, {dataIndex : 'DELIVERY_METH' 	, width : 100 }
			, {dataIndex : 'ASST_INFO'      , width : 100 }
			, {dataIndex : 'ASST_GUBUN'     , width : 100 }
			, {dataIndex : 'ASST_STATUS'    , width : 100 }
			, {dataIndex : 'REQ_YN'         , width : 100 }
			, {dataIndex : 'RESERVE_NO'     , width : 110 }
			, {dataIndex : 'RESERVE_SEQ'    , width : 80  }
			
		],
		listeners:{
			onGridDblClick:function(grid, record, cellIndex, colName) {
				var params = {
						DIV_CODE   : record.get("DIV_CODE"),
						RESERVE_NO  : record.get('RESERVE_NO')
				}
				
				var rec = {data : {prgID : 'sat300ukrv', 'text':''}};
				parent.openTab(rec, '/sales/sat300ukrv.do', params);
			}
		}
	});
	
	Unilite.Main( {
		id			: 'sat300skrvApp',
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
