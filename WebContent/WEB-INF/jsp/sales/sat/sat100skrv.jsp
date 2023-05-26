<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="sat100skrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="sat100skrv" />				<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="S177"/>						<!-- 현재상태 -->
	<t:ExtComboStore comboType="AU" comboCode="S178"/>						<!-- 자산정보 -->
	<t:ExtComboStore comboType="AU" comboCode="S179"/>						<!-- 구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B131"/>						<!-- 예/아니오 -->
</t:appConfig>

<style type="text/css">
.search-hr {height: 1px;}
</style>
<script type="text/javascript">

function appMain() {

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'sat100skrvService.selectList'
		}
	});

	//마스터 폼
	var panelResult = Unilite.createSearchForm('resultForm',{
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
			value		: UserInfo.divCode
		},{
			fieldLabel	: '자산',
			name		: 'ASST',
			colspan     : 2
		},{
			fieldLabel	: '납품처',
			name		: 'NOW_LOC'
		},{
			fieldLabel	: 'S/N',
			name		: 'SERIAL_NO'
		},{
			xtype		: 'uniCheckboxgroup',
			fieldLabel	: '현재상태',
			name		: 'ASST_STATUS',
			comboType	: 'AU',
			comboCode   : 'S177',
			allowBlank  : false,
			initAllTrue : true,
			width       : 400
		}]
	});// End of var panelResult = Unilite.createSearchForm('searchForm',{

	//마스터 모델
	Unilite.defineModel('sat100skrvModel',{
		fields: [
 			  {name : 'DIV_CODE'        , text : '사업장코드'     	, type : 'string'   ,comboType: "BOR120" }
			, {name : 'ASST_CODE'       , text : '자산코드'     	, type : 'string'   }
			, {name : 'ASST_NAME'       , text : '자산명'      	, type : 'string'   }
			, {name : 'SERIAL_NO'       , text : 'S/N'          , type : 'string'   }
			, {name : 'ASST_INFO'       , text : '자산정보'  		, type : 'string'   , comboType: "AU"	,comboCode:"S178" }
			, {name : 'ASST_GUBUN'      , text : '구분'  			, type : 'string'  	, comboType: "AU"	,comboCode:"S179" }
			, {name : 'NOW_LOC'         , text : '현위치'       	, type : 'string'	}
			, {name : 'ASST_STATUS'     , text : '현재상태'  		, type : 'string'  	, comboType: "AU"	,comboCode:"S177" }
			, {name : 'RESERVE_YN'      , text : '예약상태'   		, type : 'string'  	, comboType: "AU"	,comboCode:"B131" }
			, {name : 'ACCNT_ASST'      , text : '회계자산코드'    	, type : 'string'   }
			, {name : 'ACCNT_ASST_NAME' , text : '회계자산명'    	, type : 'string'   }
			, {name : 'INOUT_DATE'   	, text : '창고입고일'    	, type : 'uniDate'  }
			, {name : 'RETURN_DATE'  	, text : '반납예정일'    	, type : 'uniDate'  }
			, {name : 'RESERVE_NO'  	, text : '예약번호'    	, type : 'string'   }
			, {name : 'RESERVE_SEQ'  	, text : '예약번호순번'    	, type : 'int'      }
			, {name : 'RESERVE_STATUS'  , text : '예약상태'    	, type : 'string'   }
			, {name : 'RESERVE_DATE'  	, text : '사용예정일'    	, type : 'uniDate'  }
			, {name : 'RESERVE_USER_ID'	,text : '예약담당자'    	, type : 'string'   }
			, {name : 'RESERVE_USER_NAME',text : '예약담당자'    	, type : 'string'   }
			, {name : 'EXT_REQ_YN'  	, text : '연장/이동여부'    	, type : 'string'   }
			, {name : 'REQ_NO'  		, text : '출고요청번호'    	, type : 'string'   }
			, {name : 'REQ_SEQ'  		, text : '출고요청순번'    	, type : 'string'   }
			, {name : 'USE_GUBUN'  		, text : '사용구분'    	, type : 'string'   ,comboType   : 'AU', comboCode   : 'S178'}
			, {name : 'OUT_DATE'  		, text : '출고일'    	, type : 'uniDate'  }
		]
	});// End of Unilite.defineModel('Ssa101ukrvModel',{

	// 마스터 스토어 정의
	var masterStore = Unilite.createStore('sat100skrvStore',{
		model	: 'sat100skrvModel',
		proxy	: directProxy,
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

	// 마스터 그리드
	var masterGrid = Unilite.createGrid('sat100skrvGrid',{
		store	: masterStore,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			expandLastColumn	: true,
			useRowNumberer		: false,
			onLoadSelectFirst	: false
		},
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }),
		tbar    : [
			{
				xtype   : 'button',
				text    : '출고요청',
				handler : function() {
					if(UniAppManager.app._needSave())	{
						Unilite.messageBox("저장할 데이터가 있습니다. 저장 후 출고요청하세요.");
						return;
					}
					if(!Ext.isEmpty(masterGrid.getSelectedRecords()) )	{
						var asstData = masterGrid.selectedData("S", "출고요청");
						if(!Ext.isEmpty(asstData))	{
							var params = {
								DIV_CODE  : panelResult.getValue("DIV_CODE"),
								ASST_DATA : asstData
							}
							var rec = {data : {prgID : 'sat200ukrv', 'text':''}};
							parent.openTab(rec, '/sales/sat200ukrv.do', params);
						}
					} else {
						Unilite.messageBox("출고요청할 자산을 선택하세요.");
					}
				}
			},{
				xtype   : 'button',
				text    : '예약신청',
				handler : function() {
					if(UniAppManager.app._needSave())	{
						Unilite.messageBox("저장할 데이터가 있습니다. 저장 후 출고요청하세요.");
						return;
					}
					if(!Ext.isEmpty(masterGrid.getSelectedRecords()) )	{
						var asstData = masterGrid.selectedData("O","예약");
						if(!Ext.isEmpty(asstData))	{
							var params = {
								DIV_CODE  : panelResult.getValue("DIV_CODE"),
								ASST_DATA : asstData
							}
							var rec = {data : {prgID : 'sat300ukrv', 'text':''}};
							parent.openTab(rec, '/sales/sat300ukrv.do', params);
						}
					} else {
						Unilite.messageBox("예약할 자산을 선택하세요.");
					}
				}
			},{
				xtype   : 'button',
				text    : '연장/이동',
				handler : function() {
					if(UniAppManager.app._needSave())	{
						Unilite.messageBox("저장할 데이터가 있습니다. 저장 후 출고요청하세요.");
						return;
					}
					if(!Ext.isEmpty(masterGrid.getSelectedRecords()) )	{
						var asstData = masterGrid.selectedData("O","연장/이동");
						if(!Ext.isEmpty(asstData))	{
							var params = masterGrid.getSelectedRecords()[0].data;
							params.ASST_DATA = asstData;
							var rec = {data : {prgID : 'sat400ukrv', 'text':''}};
							parent.openTab(rec, '/sales/sat400ukrv.do', params);
						}
					} else {
						Unilite.messageBox("연장/이동할 자산을 선택하세요.");
					}
				}
			}
		],
		columns	: [
			  {dataIndex : 'ASST_CODE'      , width : 100 }
			, {dataIndex : 'ASST_NAME'      , width : 150 }
			, {dataIndex : 'SERIAL_NO'      , width : 150 }
			, {dataIndex : 'ASST_INFO'      , width : 80 }
			, {dataIndex : 'ASST_GUBUN'     , width : 80 }
			, {dataIndex : 'NOW_LOC'        , width : 150 }
			, {dataIndex : 'ASST_STATUS'    , width : 80 }
			, {dataIndex : 'USE_GUBUN'      , width : 80 }
			, {dataIndex : 'OUT_DATE'       , width : 80 }
			, {dataIndex : 'RESERVE_YN'     , width : 100 , hidden : true}
			, {dataIndex : 'INOUT_DATE'   	, width : 80 }
			, {dataIndex : 'RETURN_DATE'  	, width : 80 }
			, {dataIndex : 'RESERVE_NO'  	, width : 110 }
			, {dataIndex : 'RESERVE_SEQ'  	, width : 70 , hidden : true}
			, {dataIndex : 'RESERVE_STATUS' , width : 80 }
			, {dataIndex : 'RESERVE_DATE'  	, width : 80 }
			, {dataIndex : 'RESERVE_USER_NAME'  		, width : 100 }
			, {dataIndex : 'ACCNT_ASST'           , width : 100,
				  editor : Unilite.popup('ASSET_G', {
						autoPopup: true,
						textFieldName:'ACCNT_ASST',
						DBtextFieldName: 'ASSET_CODE',
						listeners: {
							'onSelected': {
								fn: function(records, type) {
									console.log('records : ', records);
									if(records && records.length > 0)	{
										var grdRecord = masterGrid.uniOpt.currentRecord;
										grdRecord.set('ACCNT_ASST'		, records[0]['ASSET_CODE']);
										grdRecord.set('ACCNT_ASST_NAME'	, records[0]['ASSET_NAME']);
									}
								},
								scope: this
							},
							'onClear': function(type) {
								var grdRecord = masterGrid.uniOpt.currentRecord;
								grdRecord.set('ACCNT_ASST'	, '');
								grdRecord.set('ACCNT_ASST_NAME'	, '');
							}
						}
					  })
			  }
			, {dataIndex : 'ACCNT_ASST_NAME'	  , width : 150,
				  editor : Unilite.popup('ASSET_G', {
					autoPopup: true,
					textFieldName:'ACCNT_ASST_NAME',
					DBtextFieldName: 'ASSET_NAME',
					listeners: {
						'onSelected': {
							fn: function(records, type) {
								if(records && records.length > 0)	{
									var grdRecord = masterGrid.uniOpt.currentRecord;
									grdRecord.set('ACCNT_ASST'		, records[0]['ASSET_CODE']);
									grdRecord.set('ACCNT_ASST_NAME'	, records[0]['ASSET_NAME']);
								}
							},
							scope: this
						},
						'onClear': function(type) {
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('ACCNT_ASST'	, '');
							grdRecord.set('ACCNT_ASST_NAME'	, '');
						}
					}
				  })
			}
		],
		listeners :{
			beforeedit: function( editor, e, eOpts ) {
				if(e.field == 'ASST_STATUS' && (e.record.get("ASST_STATUS") =="S" || e.record.get("ASST_STATUS") =="B" )) {
					return true;
				} if(e.field == 'ASST_STATUS' ) {
					return false;
				} 
			} 
		},
		selectedData : function(status, btn)	{
			var me = this;
			var selData = new Array();
			var selRecords = me.getSelectedRecords();

			var statusCheck = true;
			var statusErr = "";
			Ext.each(selRecords, function(record, idx){
				if(btn == "출고요청" && !Ext.isEmpty(status) && record.get("ASST_STATUS") != status)	{
					statusCheck = false;
					statusErr += record.get("ASST_NAME")+"("+record.get("ASST_CODE")+")\n"
				} else if(btn == "출고요청" && !Ext.isEmpty(status) && record.get("ASST_STATUS") == status &&  record.get("RESERVE_STATUS") == "Y" && UserInfo.userID != record.get("RESERVE_USER_ID"))	{
					statusCheck = false;
					statusErr += record.get("ASST_NAME")+"("+record.get("ASST_CODE")+") 예약담당자가 아닙니다.\n"
				} else if(btn == "예약" && !Ext.isEmpty(status) && (record.get("ASST_STATUS") == "R" || record.get("RESERVE_STATUS") == "Y") )	{
					statusCheck = false;
					statusErr += record.get("ASST_NAME")+"("+record.get("ASST_CODE")+")\n"
				} else if(btn == "연장/이동" && !Ext.isEmpty(status) && record.get("ASST_STATUS") != "O" )	{
					statusCheck = false;
					statusErr += record.get("ASST_NAME")+"("+record.get("ASST_CODE")+")\n"
				} else {
					selData.push(record.data);
				}
			});
			if(!statusCheck){
				selData = null;
				if(btn == "출고요청")	{
					Unilite.messageBox("출고요청 할 수 없는 자산이 선택되었습니다. 현재상태를 확인하세요.", statusErr, '', {'showDetail' : true });
				} else if( btn == "예약")	{
					Unilite.messageBox("예약 할 수 없는 자산이 선택되었습니다. 현재상태를 확인하세요.", statusErr, '', {'showDetail' : true });
				} else if( btn == "연장/이동")	{
					Unilite.messageBox("연장/이동 할 수 없는 자산이 선택되었습니다. 현재상태를 확인하세요.", statusErr, '', {'showDetail' : true });
				} else {
					Unilite.messageBox("선택된 자산의 현재상태를 확인하세요.", statusErr, '',  {'showDetail' : true });
				}
			}
			return selData;
		},
		selectedAsstCode : function()	{
			var me = this;
			var selAsstCode = new Array();
			var selRecords = me.getSelectedRecords();
			Ext.each(selRecords, function(record, idx){
				selAsstCode.push(record.get("ASST_CODE"));
			})
			return selAsstCode;
		}
	});

	Unilite.Main( {
		id			: 'sat100skrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				panelResult, masterGrid
			]
		}],
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons(['reset']	, true);
			this.setDefault();
		},
		setDefault: function() {
			panelResult.setValue('DIV_CODE', UserInfo.divCode);
			var asstStatusStore = Ext.data.StoreManager.lookup("CBS_AU_S177");
			if(asstStatusStore)	{
				var values = new Array();
				Ext.each(asstStatusStore.getData().items, function(data){
					values.push(data.get("value"));
				});
				panelResult.setValue('ASST_STATUS',values)
			}
		},
		onQueryButtonDown: function() {
			if(!panelResult.getInvalidMessage()) return;	//필수체크
			masterStore.loadStoreRecords();
		},
		onResetButtonDown: function() {
			panelResult.clearForm();
			masterStore.loadData({});
			this.fnInitBinding();
		}
	});
};
</script>
