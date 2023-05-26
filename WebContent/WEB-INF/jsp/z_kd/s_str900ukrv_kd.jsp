<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_str900ukrv_kd">
	<t:ExtComboStore comboType="BOR120"  pgmId="s_str900ukrv_kd"  />	<!-- 사업장 -->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList"/>		<!-- 창고 -->
	<t:ExtComboStore comboType="AU" comboCode="WB20"/>
	<t:ExtComboStore comboType="AU" comboCode="WB23"/>
	<t:ExtComboStore comboType="AU" comboCode="WB24"/>
</t:appConfig>
<script type="text/javascript" >

var BsaCodeInfo = {	//컨트롤러에서 값을 받아옴.
	gsBalanceOut: '${gsBalanceOut}'
};

var excelWindow;	// 엑셀참조
var csvWindow;		// CSV참조
var csvCloseBtn = 'N';
function appMain() {
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_str900ukrv_kdService.selectList',
			update	: 's_str900ukrv_kdService.updateDetail',
			destroy	: 's_str900ukrv_kdService.deleteDetail',
			syncAll	: 's_str900ukrv_kdService.saveAll'
		}
	});

	/** Model 정의
	 * @type
	 */
	Unilite.defineModel('s_str900ukrv_kdModel', {
		fields: [
			{name: 'UNIQUE_ID'			,text:'검수키'			,type: 'string'},
			{name: 'COMP_CODE'			,text:'법인코드'		,type: 'string'},
			{name: 'DIV_CODE'			,text:'사업장'			,type: 'string', xtype: 'uniCombobox', comboType: 'BOR120'},
			{name: 'OUT_DATE'			,text:'매출일'			,type: 'uniDate'},
			{name: 'IN_DATE'			,text:'입고일'			,type: 'uniDate'},
			{name: 'WH_CODE'			,text:'하치장'		,type: 'string', store: Ext.data.StoreManager.lookup('whList')},
			{name: 'CUSTOM_CODE'		,text:'출고처'			,type: 'string'},
			{name: 'CUSTOM_NAME'		,text:'출고처명'		,type: 'string'},
			{name: 'SALES_CUSTOM_CODE'	,text:'매출처'			,type: 'string'},
			{name: 'SALES_CUSTOM_NAME'	,text:'매출처명'		,type: 'string'},
			{name: 'OEM_ITEM_CODE'		,text:'품번'			,type: 'string'},
			{name: 'IN_Q'				,text:'입고인정량'		,type: 'uniQty'},
			{name: 'OUT_Q'				,text:'매출수량'		,type: 'uniQty'},
			{name: 'IN_P'				,text:'매출인정단가'		,type: 'uniUnitPrice'},
			{name: 'IN_O'				,text:'매출인정금액'		,type: 'uniPrice'},
			{name: 'IN_FLAG'			,text:'입고구분'		,type: 'string', comboType:"AU", comboCode:"WB20"},
			{name: 'LV_TYPE'			,text:'내수/수출'		,type: 'string', comboType:"AU", comboCode:"WB23"},
			{name: 'STATUS_FLAG'		,text:'진행상태'		,type: 'string', comboType:"AU", comboCode:"WB24"},
			{name: 'INFO_REMARK'		,text:'진행정보'		,type: 'string'},
			{name: 'FILE_TYPE'			,text:'파일형태'		,type: 'string'},
//			{name: 'FILE_WONBON'		,text:'원본내용'		,type: 'string'},
//			{name: 'DEPT_CODE'			,text:'부서코드'		,type: 'string'},
//			{name: 'DEPT_NAME'			,text:'부서명'			,type: 'string'},
//			{name: 'INOUT_PRSN'			,text:'담당자'			,type: 'string'},
			{name: 'INSERT_DB_USER'		,text:'입력ID'		,type: 'string'},
			{name: 'INSERT_DB_TIME'		,text:'입력일'			,type: 'string'},
			{name: 'UPDATE_DB_USER'		,text:'수정ID'		,type: 'string'},
			{name: 'UPDATE_DB_TIME'		,text:'수정일'			,type: 'string'},
			{name: 'TEMPC_01'			,text:'여유컬럼'		,type: 'string'},
			{name: 'TEMPC_02'			,text:'여유컬럼'		,type: 'string'},
			{name: 'TEMPC_03'			,text:'여유컬럼'		,type: 'string'},
			{name: 'TEMPN_01'			,text:'여유컬럼'		,type: 'string'},
			{name: 'TEMPN_02'			,text:'여유컬럼'		,type: 'string'},
			{name: 'TEMPN_03'			,text:'여유컬럼'		,type: 'string'}
		]
	});

	// 엑셀
	Unilite.Excel.defineModel('excel.s_str900.sheet01', {
		fields: [
			{name: 'COMP_CODE'			,text:'법인코드'		,type: 'string'},
			{name: 'DIV_CODE'			,text:'사업장'			,type: 'string'},
			{name: 'UNIQUE_ID'			,text:'검수키'			,type: 'string'},
			{name: 'IN_DATE'			,text:'입고일'			,type: 'uniDate'},
			{name: 'WH_CODE'			,text:'하치장'		,type: 'string'},
			{name: 'OEM_ITEM_CODE'		,text:'품번'			,type: 'string'},
			{name: 'IN_Q'				,text:'매출인정량'		,type: 'uniQty'},
			{name: 'IN_P'				,text:'매출인정단가'		,type: 'uniUnitPrice'},
			{name: 'IN_O'				,text:'매출인정금액'		,type: 'uniPrice'},
			{name: 'IN_FLAG'			,text:'입고구분'		,type: 'string'},
			{name: 'LV_TYPE'			,text:'내수/수출'		,type: 'string'},
			{name: 'FILE_TYPE'			,text:'파일형태'		,type: 'string'},
			{name: 'INSERT_DB_USER'		,text:'입력ID'		,type: 'string'},
			{name: 'INSERT_DB_TIME'		,text:'입력일'			,type: 'string'},
			{name: 'UPDATE_DB_USER'		,text:'수정ID'		,type: 'string'},
			{name: 'UPDATE_DB_TIME'		,text:'수정일'			,type: 'string'},
			{name: 'TEMPC_01'			,text:'여유컬럼'		,type: 'string'},
			{name: 'TEMPC_02'			,text:'여유컬럼'		,type: 'string'},
			{name: 'TEMPC_03'			,text:'여유컬럼'		,type: 'string'},
			{name: 'TEMPN_01'			,text:'여유컬럼'		,type: 'string'},
			{name: 'TEMPN_02'			,text:'여유컬럼'		,type: 'string'},
			{name: 'TEMPN_03'			,text:'여유컬럼'		,type: 'string'}
		]
	});

	function openExcelWindow() {
		var me = this;
		var vParam = {};
		var appName = 'Unilite.com.excel.ExcelUploadWin';
		if(!excelWindow) {
			excelWindow = Ext.WindowMgr.get(appName);
			excelWindow = Ext.create( appName, {
				modal: false,
				excelConfigName: 's_str900',
				/*grids: [{
					itemId	: 'grid01',
					title	: '매출등록(Excel)',
					model	: 'excel.s_str900.sheet01',
					readApi	: 's_str900ukrv_kdService.selectExcelUploadSheet1',
					useCheckbox: false,
					columns	: [
						{ dataIndex: 'COMP_CODE'		, width: 90, hidden: true},
						{ dataIndex: 'DIV_CODE'			, width: 90, hidden: true},
						{ dataIndex: 'UNIQUE_ID'		, width: 90},
						{ dataIndex: 'IN_DATE'			, width: 90},
						{ dataIndex: 'WH_CODE'			, width: 90},
						{ dataIndex: 'OEM_ITEM_CODE'	, width: 110},
						{ dataIndex: 'IN_Q'				, width: 120},
						{ dataIndex: 'IN_P'				, width: 120},
						{ dataIndex: 'IN_O'				, width: 120},
						{ dataIndex: 'IN_FLAG'			, width: 100},
						{ dataIndex: 'LV_TYPE'			, width: 100},
						{ dataIndex: 'FILE_TYPE'		, width: 90},
						{ dataIndex: 'INSERT_DB_USER'	, width: 90, hidden: true},
						{ dataIndex: 'INSERT_DB_TIME'	, width: 90, hidden: true},
						{ dataIndex: 'UPDATE_DB_USER'	, width: 90, hidden: true},
						{ dataIndex: 'UPDATE_DB_TIME'	, width: 90, hidden: true},
						{ dataIndex: 'TEMPC_01'			, width: 90, hidden: true},
						{ dataIndex: 'TEMPC_02'			, width: 90, hidden: true},
						{ dataIndex: 'TEMPC_03'			, width: 90, hidden: true},
						{ dataIndex: 'TEMPN_01'			, width: 90, hidden: true},
						{ dataIndex: 'TEMPN_02'			, width: 90, hidden: true},
						{ dataIndex: 'TEMPN_03'			, width: 90, hidden: true}
					]
				}],*/
				listeners: {
					
			/*		close: function() {
						this.hide();
					},
					hide: function() {
						excelWindow.down('#grid01').getStore().loadData({});
						this.hide();
					}*/
					
					show: function(){
						Ext.getCmp('pageAll').getEl().mask('엑셀업로드중...');
					},
					close: function() {
						this.hide();
					},
					hide: function() {
						Ext.getCmp('pageAll').getEl().unmask();
					}
				
					
				},
		/*		onApply:function()  {
					excelWindow.getEl().mask('로딩중...','loading-indicator');
					var me		= this;
					var grid	= this.down('#grid01');
					var records	= grid.getStore().getAt(0);
					var param	= {"_EXCEL_JOBID": records.get('_EXCEL_JOBID')};
					s_str900ukrv_kdService.insertSBtr900tKd(param, function(provider, response) {
						s_str900ukrv_kdService.selectResultCount(param, function(provider, response) {
							console.log("response",response)
							excelWindow.getEl().unmask();
							grid.getStore().removeAll();
							me.hide();
							Unilite.messageBox('전체: ' + provider[0].ALL_COUNT + ',  ' + '성공: ' + provider[0].SUCESS_COUNT + ',  ' + '실패: ' + provider[0].ERROR_COUNT)
						})
					});
					UniAppManager.app.onQueryButtonDown();
				}*/
				uploadFile: function() {
					var me = this,
					frm = me.down('#uploadForm');
					if(Ext.isEmpty(frm.getValue('excelFile'))){
						Unilite.messageBox(UniUtils.getMessage('system.message.commonJS.excel.requiredText','선택된 파일이 없습니다.'));
						return false;
					}
					frm.submit({
						params: me.extParam,
						waitMsg: 'Uploading...',
						success: function(form, action) {
							me.jobID = action.result.jobID;
							me.readGridData(me.jobID);
							me.hide();
							var param = inputTable.getValues();
							param.DIV_CODE		= panelResult.getValue('DIV_CODE');
							param.JOB_ID	= action.result.jobID;
							param.JOB_TYPE	= 'EXCEL';
							param.PROCESS_FLAG = 'N';
							masterGrid.getEl().mask('로딩중...', 'loading-indicator');
							s_str900ukrv_kdService.autoOutTrans(param, function(provider, response) {
								if(provider) {
									if(!Ext.isEmpty(provider.ErrorDesc)) {
										Unlite.messageBox(provider.ErrorDesc);
									} else if(!Ext.isEmpty(provider.RESULT_CNT_01))	{
										var messageDesc = "    총 건수\t\t\t\t: "+ provider.RESULT_CNT_01 +" 건\n"
														+ "        - 입고구분 미존재\t: "+ provider.RESULT_CNT_02 +" 건\n"
														+ "        - 하치장 미존재\t\t: "+ provider.RESULT_CNT_03 +" 건\n"
														+ "        - 내수/수출구분오류\t: "+ provider.RESULT_CNT_04 +" 건\n"
														+ "        - 품목 미등록\t\t: "+ provider.RESULT_CNT_05 +" 건\n"
														+ "        - 판매단가 미등록\t: "+ provider.RESULT_CNT_06 +" 건\n"
														+ "        - 검수제외품목\t\t: "+ provider.RESULT_CNT_07 +" 건\n"
														+ "        - 매출처 미존재\t\t: "+ provider.RESULT_CNT_08 +" 건\n"
														+ "    정상처리\t\t\t: "+ provider.RESULT_CNT_09 +" 건\n" 
														+ "    중복된 건수\t\t\t: "+ provider.RESULT_CNT_10 +" 건\n" ;
										Unilite.messageBox("실행결과",messageDesc, "실행결과",{showDetail:true});
	
										directMasterStore.loadStoreRecords();
									} else {
										UniAppManager.updateStatus(Msg.sMB011);
										directMasterStore.loadStoreRecords();
									}
	
								}else{
									//sp 호출후 에러 발생시 upload temp테이블 삭제
									s_str900ukrv_kdService.deleteTemp(param, function(provider, response) {});
								}
								masterGrid.getEl().unmask();
							});
							
						},
						
						failure: function(form, action) {
							Unilite.messageBox('Upload에 실패하였습니다.');
						}
					});
				},
				_setToolBar: function() {
					var me = this;
					me.tbar = [{
						xtype: 'button',
						text : UniUtils.getLabel('system.label.commonJS.excel.btnUpload','업로드'),
						tooltip : UniUtils.getLabel('system.label.commonJS.excel.btnUpload','업로드'), 
						handler: function() { 
							me.jobID = null;
							me.uploadFile();
						}
					},{
						xtype: 'button',
						text : 'Read Data',
						tooltip : 'Read Data', 
						hidden: true,
						handler: function() { 
							if(me.jobID != null) {
								me.readGridData(me.jobID);
//								me.down('tabpanel').setActiveTab(1);
							} else {
								Unilite.messageBox(UniUtils.getMessage('system.message.commonJS.excel.requiredText','Upload된 파일이 없습니다.'))
							}
						}
					},{
						xtype: 'button',
						hidden:true,
						text : UniUtils.getLabel('system.label.commonJS.excel.btnApply','적용'),
						tooltip : UniUtils.getLabel('system.label.commonJS.excel.btnApply','적용'), 
						handler: function() { 
							var grids = me.down('grid');
							var isError = false;
							if(Ext.isDefined(grids.getEl())) {
								grids.getEl().mask();
							}
							Ext.each(grids, function(grid,i){
								if(me.grids[0].useCheckbox) {
									var records = grid.getSelectionModel().getSelection();
								} else {
									var records = grid.getStore().data.items;
								}
		//						var records = grid.getStore().data.items;
								return Ext.each(records, function(record,i){	
									if(record.get('_EXCEL_HAS_ERROR') == 'Y') {
										console.log("_EXCEL_HAS_ERROR : ", record.get('_EXCEL_HAS_ERROR'));
										isError = true;	 
										return false;
									}
								});
							}); 
							if(Ext.isDefined(grids.getEl())) {
								grids.getEl().unmask();
							}
							if(!isError) {
								me.onApply();
							}else {
								Unilite.messageBox(UniUtils.getMessage('system.message.commonJS.excel.rowErrorText',"에러가 있는 행은 적용이 불가능합니다."));
							}
						}
					},'->',{
						xtype: 'button',
						text : UniUtils.getLabel('system.label.commonJS.excel.btnClose','닫기'),
						tooltip : UniUtils.getLabel('system.label.commonJS.excel.btnClose','닫기'), 
						handler: function() { 
							me.hide();
						}
					}]
				}
				
				
				
				
			});
		}
		excelWindow.center();
		excelWindow.show();
	}

	function openCsvWindow() {
		var me = this;
		var vParam = {};
		var appName = 'Unilite.com.excel.CSVUpload';
		if (!csvWindow) {
			csvWindow = Ext.create(appName, {
				modal		: false,
				csvConfigName: 's_tpl200ukr_kd',
				listeners	: {
				
					
					beforehide: function(me, eOpt) {
					},
					beforeclose: function( me, eOpts ) {
					},
					hide: function ( me, eOpts ) {
						
						
						if(csvCloseBtn == 'Y'){
							Ext.getCmp('pageAll').getEl().unmask();
							csvCloseBtn = 'N';
						}else if(me.fileIds != null && me.fileIds.length > 0 ) {
							console.log("me.fileIds.length :: " + me.fileIds.length);
							console.log("me.fileIds :: " + me.fileIds[0]);
//							panelResult.getEl().mask('저장중...','loading-indicator');		// mask on
							panelResult.setValue('FILE_ID', me.fileIds[0]);				// 추가 파일 담기
							panelResult.setValue('CSV_LOAD_YN', 'Y');					// 초기값 세팅
							panelResult.setValue('PGM_ID', 's_str900ukrv_kd');			// 초기값 세팅
							csvUploadStore.loadStoreRecords();							// csv 파일 읽고, 조회하기
							
							
							
//							var param = panelResult.getValues();
//							param.FILE_ID = me.fileIds[0];
//							s_str900ukrv_kdService.selectList(param, function(provider, response) {
//								s_str900ukrv_kdService.selectResultCount2(param, function(provider, response) {
//									panelResult.getEl().unmask();						// mask off
//									Unilite.messageBox('전체: ' + provider[0].ALL_COUNT + ',  ' + '성공: ' + provider[0].SUCESS_COUNT + ',  ' + '실패: ' + provider[0].ERROR_COUNT)
//								})
//							});
//							UniAppManager.app.onQueryButtonDown();
						} else {
							console.log('업로드된 파일 없음.');
						}
					},
					show: function ( me, eOpts ) {
						Ext.getCmp('pageAll').getEl().mask('CSV업로드중...');
					}
				},
				_setToolBar: function() {
					var me = this;
					me.tbar = [
						{
							xtype: 'button',
							text : UniUtils.getLabel('system.label.commonJS.excel.btnUpload','업로드'),
							tooltip : UniUtils.getLabel('system.label.commonJS.excel.btnUpload','업로드'), 
							handler: function() { 
								
								if(Ext.isEmpty(Ext.getCmp('excelFile').getValue())){
									Unilite.messageBox(UniUtils.getMessage('system.message.commonJS.excel.requiredText','선택된 파일이 없습니다.'));
									return false;	
								}
								if( me.fileExtention != 'csv') {
									Unilite.messageBox(UniUtils.getMessage('system.message.commonJS.excel.csvInvalidText','csv 파일이 아닙니다.'));
									return false;
								}

								me.fileIds = null;
								me.fileExtention = null;
								
								me.uploadFile();
							}
						},
						'->',   // 업로드버튼과 닫기 버튼을 양쪽으로 분배한다.
						{
							xtype: 'button',
							text : UniUtils.getLabel('system.label.commonJS.excel.btnClose','닫기'),
							tooltip : UniUtils.getLabel('system.label.commonJS.excel.btnClose','닫기'), 
							handler: function() { 
								csvCloseBtn = 'Y';
								me.hide();
							}
						}
						
					]
				}
			});
		}
		csvWindow.center();
		csvWindow.show();
	}



	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore = Unilite.createStore('s_str900ukrv_kdMasterStore1',{
		model	: 's_str900ukrv_kdModel',
		proxy	: directProxy,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결
			editable	: true,		// 수정 모드 사용
			deletable	: true,		// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		autoLoad: false,
		loadStoreRecords : function()   {
			var param= panelResult.getValues();
			this.load({
				params : param
			});
		},
		saveStore: function() {
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
			var toUpdate = this.getUpdatedRecords();
			var toDelete = this.getRemovedRecords();
			var list = [].concat(toUpdate, toCreate);
			console.log("inValidRecords : ", inValidRecs);
			console.log("list:", list);
			console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));

			//1. 마스터 정보 파라미터 구성
			var paramMaster= panelResult.getValues();	//syncAll 수정
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						panelResult.getForm().wasDirty = false;
						panelResult.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);
						directMasterStore.loadStoreRecords();
						if(directMasterStore.getCount() == 0) {
							UniAppManager.app.onResetButtonDown();
						}
					}
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('s_str900ukrv_kdmasterGrid');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});

	var csvUploadStore = Unilite.createStore('csvUploadStore1',{
		model	: 's_str900ukrv_kdModel',
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy	: {
			type: 'direct',
			api: {read: 's_str900ukrv_kdService.select'}
		},
		loadStoreRecords : function() {
			var param= panelResult.getValues();	//조회폼 파라미터 수집
			console.log( param );
			this.load({							//그리드에 Load..
				params : param,
				callback : function(records, operation, success) {
					if(success) {		//조회후 처리할 내용
						var param = inputTable.getValues();
						param.DIV_CODE		= panelResult.getValue('DIV_CODE');
						param.JOB_ID = records[0].get('FILE_ID');
						param.JOB_TYPE = 'CSV';
						param.COL04 = records[0].get('COL04');
						param.PROCESS_FLAG = 'N';
//						masterGrid.getEl().mask('로딩중...', 'loading-indicator');
						s_str900ukrv_kdService.autoOutTrans(param, function(provider, response) {
							if(provider) {
								if(!Ext.isEmpty(provider.ErrorDesc)) {
									Unlite.messageBox(provider.ErrorDesc);
								} else if(!Ext.isEmpty(provider.RESULT_CNT_01))	{
									var messageDesc = "    총 건수\t\t\t\t: "+ provider.RESULT_CNT_01 +" 건\n"
													+ "        - 입고구분 미존재\t: "+ provider.RESULT_CNT_02 +" 건\n"
													+ "        - 하치장 미존재\t\t: "+ provider.RESULT_CNT_03 +" 건\n"
													+ "        - 내수/수출구분오류\t: "+ provider.RESULT_CNT_04 +" 건\n"
													+ "        - 품목 미등록\t\t: "+ provider.RESULT_CNT_05 +" 건\n"
													+ "        - 판매단가 미등록\t: "+ provider.RESULT_CNT_06 +" 건\n"
													+ "        - 검수제외품목\t\t: "+ provider.RESULT_CNT_07 +" 건\n"
													+ "        - 매출처 미존재\t\t: "+ provider.RESULT_CNT_08 +" 건\n"
													+ "    정상처리\t\t\t: "+ provider.RESULT_CNT_09 +" 건\n" 
													+ "    중복된 건수\t\t\t: "+ provider.RESULT_CNT_10 +" 건\n" ;
									Unilite.messageBox("실행결과",messageDesc, "실행결과",{showDetail:true});

									directMasterStore.loadStoreRecords();
								} else {
									UniAppManager.updateStatus(Msg.sMB011);
									directMasterStore.loadStoreRecords();
								}

							}else{
								//sp 호출후 에러 발생시 upload temp테이블 삭제
								s_str900ukrv_kdService.deleteTemp(param, function(provider, response) {});	
							}
//							masterGrid.getEl().unmask();
							Ext.getCmp('pageAll').getEl().unmask();
							
							
						});
						
						
					}
				}
			});
		}
	});



	/** 검색조건 (Search Panel)
	 * @type
	 */
	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 2},
		padding	: '1 1 1 1',
		border	: true,
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		id		: 'RESULT_SEARCH',
		items	: [{
			fieldLabel	: '사업장',
			name		: 'DIV_CODE',
			value		: UserInfo.divCode,
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false
		},{
			fieldLabel		: '입고일자',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'IN_DATE_FR',
			endFieldName	: 'IN_DATE_TO',
			startDate		: UniDate.get('startOfMonth'),
			endDate			: UniDate.get('today'),
			allowBlank		: false
		},
		Unilite.popup('AGENT_CUST',{
			fieldLabel		: '출고처',
			valueFieldName	: 'CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME',
			allowBlank		: true
		}),{
			fieldLabel	: '조회조건',
			xtype		: 'radiogroup',
			id			: 'rdoSelect',
			items		: [{
				boxLabel	: '전체',
				name		: 'STATUS_FLAG',
				inputValue	: '$',
				width		: 50
			},{
				boxLabel	: '올림',
				name		: 'STATUS_FLAG',
				inputValue	: '1',
				width		: 50
			},{
				boxLabel	: '에러',
				name		: 'STATUS_FLAG',
				inputValue	: '2',
				width		: 50
			},{
				boxLabel	: '완료',
				name		: 'STATUS_FLAG',
				inputValue	: '4',
				width		: 50
			}]
		},{
			fieldLabel	: 'FILE_ID',
			name		: 'FILE_ID',
			xtype		: 'uniTextfield',
			hidden		: true
		},{
			fieldLabel	: 'CSV_LOAD_YN',
			name		: 'CSV_LOAD_YN',
			xtype		: 'uniTextfield',
			hidden		: true
		},{
			fieldLabel	: 'PGM_ID',
			name		: 'PGM_ID',
			xtype		: 'uniTextfield',
			hidden		: true
		}],
		setAllFieldsReadOnly: function(b) {
			var r= true
			if(b) {
				var invalid = this.getForm().getFields().filterBy(function(field) {
					return !field.validate();
				});
				if(invalid.length > 0) {
					r=false;
					var labelText = ''
					if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
						var labelText = invalid.items[0]['fieldLabel']+'은(는)';
					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
						var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
					}
					Unilite.messageBox(labelText+Msg.sMB083);
					invalid.items[0].focus();
				} else {
					//this.mask();
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) ) {
							if (item.holdable == 'hold') {
								item.setReadOnly(true);
							}
						}
						if(item.isPopupField) {
							var popupFC = item.up('uniPopupField') ;
							if(popupFC.holdable == 'hold') {
								popupFC.setReadOnly(true);
							}
						}
					})
				}
			} else {
				//this.unmask();
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) ) {
						if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					}
					if(item.isPopupField) {
						var popupFC = item.up('uniPopupField') ;
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		},
		setLoadRecord: function(record) {
			var me = this;
			me.uniOpt.inLoading=false;
			me.setAllFieldsReadOnly(true);
		}
	});

	var inputTable = Unilite.createSearchForm('detailForm', { //createForm
		layout	: {type : 'uniTable', columns : 4},
		disabled: false,
		border	: true,
		padding	: '1 1 1 1',
		region	: 'center',
		masterGrid: masterGrid,
		items	: [
			Unilite.popup('DEPT',{
				fieldLabel		: '부서',
				valueFieldName	: 'DEPT_CODE',
				textFieldName	: 'DEPT_NAME',
				allowBlank		: false
			}),{
				fieldLabel	: '영업담당',
				name		: 'INOUT_PRSN',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'S010',
				allowBlank	: false
			},
//			{
//				fieldLabel	: '작업구분',
//				xtype		: 'radiogroup',
//				id			: 'rdoSelect2',
//				items		: [{
//					boxLabel	: '등록',
//					name		: 'PROCESS_FLAG',
//					inputValue	: 'N',
//					width		: 70
//				},{
//					boxLabel	: '삭제',
//					name		: 'PROCESS_FLAG',
//					inputValue	: 'D',
//					width		: 50
//				}]
//			},
			{
				xtype: 'component'
			},	
			{
				xtype: 'component'
			},{
				fieldLabel	: '입고일'  ,
				xtype		: 'uniDatefield',		//필드 타입
				name		: 'INOUT_DATE',			//Query mapping name
				allowBlank	: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						var param	= panelResult.getValues();
						var outDate	= UniDate.getDbDateStr(newValue);
						param.INOUT_DATE = outDate;
						s_str900ukrv_kdService.selectOutDate(param, function(provider, response) {
							if(!Ext.isEmpty(provider) && provider != '' && UniDate.getDbDateStr(newValue).replace(/\./g,'').length == 8) {
								inputTable.setValue('OUT_DATE', provider[0].OUT_DATE);
							}
						});
					}
				}
			},{
				fieldLabel	: '매출일',
				xtype		: 'uniDatefield',		//필드 타입
				name		: 'OUT_DATE',			//Query mapping name
				allowBlank	: false
			},{
				xtype: 'component'
			},{
				xtype	: 'button',		//필드 타입
				text	: '작업취소',
				margin: '0 0 0 50',
				width	: 80,
				handler	: function() {
					if(inputTable.setAllFieldsReadOnly(true) == false) {
						return false;
					} else if(Ext.isEmpty(panelResult.getValue('CUSTOM_CODE'))) {
						Unilite.messageBox('출고처는 필수입력값 입니다.');
						return false;
					} else {
						var param			= inputTable.getValues();
						param.CUSTOM_CODE	= panelResult.getValue('CUSTOM_CODE');
						param.DIV_CODE		= panelResult.getValue('DIV_CODE');
						param.PROCESS_FLAG = 'D';
						masterGrid.getEl().mask('로딩중...', 'loading-indicator');
						s_str900ukrv_kdService.autoOutTrans(param, function(provider, response) {
							if(provider) {
								if(!Ext.isEmpty(provider.ErrorDesc)) {
									Unlite.messageBox(provider.ErrorDesc);
								} else if(!Ext.isEmpty(provider.RESULT_CNT_01))	{
									var messageDesc = "    총 건수\t\t\t\t: "+ provider.RESULT_CNT_01 +" 건\n"
													+ "        - 입고구분 미존재\t: "+ provider.RESULT_CNT_02 +" 건\n"
													+ "        - 하치장 미존재\t\t: "+ provider.RESULT_CNT_03 +" 건\n"
													+ "        - 내수/수출구분오류\t: "+ provider.RESULT_CNT_04 +" 건\n"
													+ "        - 품목 미등록\t\t: "+ provider.RESULT_CNT_05 +" 건\n"
													+ "        - 판매단가 미등록\t: "+ provider.RESULT_CNT_06 +" 건\n"
													+ "        - 검수제외품목\t\t: "+ provider.RESULT_CNT_07 +" 건\n"
													+ "        - 매출처 미존재\t\t: "+ provider.RESULT_CNT_08 +" 건\n"
													+ "    정상처리\t\t\t: "+ provider.RESULT_CNT_09 +" 건\n" ;
									Unilite.messageBox("실행결과",messageDesc, "실행결과",{showDetail:true});

									directMasterStore.loadStoreRecords();
								} else {
									UniAppManager.updateStatus(Msg.sMB011);
									directMasterStore.loadStoreRecords();
								}

							}
							masterGrid.getEl().unmask();
						});
					}
				}
			}
		],
		setAllFieldsReadOnly: function(b) {
			var r= true
			if(b) {
				var invalid = this.getForm().getFields().filterBy(function(field) {
					return !field.validate();
				});
				if(invalid.length > 0) {
					r=false;
					var labelText = ''
					if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
						var labelText = invalid.items[0]['fieldLabel']+'은(는)';
					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
						var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
					}
					Unilite.messageBox(labelText+Msg.sMB083);
					invalid.items[0].focus();
				} else {
					//this.mask();
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) ) {
							if (item.holdable == 'hold') {
								item.setReadOnly(true);
							}
						}
						if(item.isPopupField) {
							var popupFC = item.up('uniPopupField') ;
							if(popupFC.holdable == 'hold') {
								popupFC.setReadOnly(true);
							}
						}
					})
				}
			} else {
				//this.unmask();
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) ) {
						if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					}
					if(item.isPopupField) {
						var popupFC = item.up('uniPopupField') ;
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		},
		setLoadRecord: function(record) {
			var me = this;
			me.uniOpt.inLoading=false;
			me.setAllFieldsReadOnly(true);
		}
	});



	var masterGrid = Unilite.createGrid('s_str900ukrv_kdmasterGrid', {
		store	: directMasterStore,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			expandLastColumn	: false,
			useMultipleSorting	: true,
			useGroupSummary		: false,
			useLiveSearch		: true,
			useContextMenu		: true,
			filter: {
				useFilter	: true,
				autoCreate	: true
			}
		},
		tbar	: [{
			xtype	: 'splitbutton',
			itemId	: 'orderTool',
			text	: '참조...',
			iconCls	: 'icon-referance',
			menu	: Ext.create('Ext.menu.Menu', {
				items: [{
						text	: '엑셀업로드',
						handler	: function(grid, record) {
							if(panelResult.setAllFieldsReadOnly(true) == false) {
								return false;
							}
							openExcelWindow();
						}
					},{
						text	: 'CSV업로드',
						handler	: function(grid, record) {
							if(panelResult.setAllFieldsReadOnly(true) == false) {
								return false;
							}
							openCsvWindow();
						}
					}
				]
			})
		}],
		columns:  [
			{ dataIndex: 'UNIQUE_ID'			, width: 100},
			{ dataIndex: 'COMP_CODE'			, width: 90, hidden: true},
			{ dataIndex: 'DIV_CODE'				, width: 90, hidden: true},
			{ dataIndex: 'OUT_DATE'				, width: 80},
			{ dataIndex: 'IN_DATE'				, width: 80},
			{ dataIndex: 'WH_CODE'				, width: 90},
			{ dataIndex: 'CUSTOM_CODE'			, width: 110},
			{ dataIndex: 'CUSTOM_NAME'			, width: 200},
			{ dataIndex: 'SALES_CUSTOM_CODE'	, width: 110},
			{ dataIndex: 'SALES_CUSTOM_NAME'	, width: 200},
			{ dataIndex: 'OEM_ITEM_CODE'		, width: 120},
			{ dataIndex: 'IN_Q'					, width: 90},
			{ dataIndex: 'OUT_Q'				, width: 90},
			{ dataIndex: 'IN_P'					, width: 100},
			{ dataIndex: 'IN_O'					, width: 100},
			{ dataIndex: 'IN_FLAG'				, width: 90},
			{ dataIndex: 'LV_TYPE'				, width: 100},
			{ dataIndex: 'STATUS_FLAG'			, width: 100},
			{ dataIndex: 'INFO_REMARK'			, width: 160},
			{ dataIndex: 'FILE_TYPE'			, width: 90},
//			{ dataIndex: 'FILE_WONBON'			, width: 200, hidden: true},
//			{ dataIndex: 'DEPT_CODE'			, width: 110},
//			{ dataIndex: 'DEPT_NAME'			, width: 200},
//			{ dataIndex: 'INOUT_PRSN'			, width: 90},
			{ dataIndex: 'INSERT_DB_USER'		, width: 90, hidden: true},
			{ dataIndex: 'INSERT_DB_TIME'		, width: 90, hidden: true},
			{ dataIndex: 'UPDATE_DB_USER'		, width: 90, hidden: true},
			{ dataIndex: 'UPDATE_DB_TIME'		, width: 90, hidden: true},
			{ dataIndex: 'TEMPC_01'				, width: 90, hidden: true},
			{ dataIndex: 'TEMPC_02'				, width: 90, hidden: true},
			{ dataIndex: 'TEMPC_03'				, width: 90, hidden: true},
			{ dataIndex: 'TEMPN_01'				, width: 90, hidden: true},
			{ dataIndex: 'TEMPN_02'				, width: 90, hidden: true},
			{ dataIndex: 'TEMPN_03'				, width: 90, hidden: true}
		],
		listeners: {
			beforeedit : function( editor, e, eOpts ) {
				return false;
			}
		}
	});



	Unilite.Main({
		id			: 's_str900ukrv_kdApp',
		borderItems	: [{
			id		: 'pageAll',
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [{
					xtype	: 'container',
					region	: 'center',
					layout	: 'fit',
					items	: [ masterGrid ]
				},
				panelResult,
				{
					xtype	: 'container',
					region	: 'north',
					highth	: 20,
					layout	: 'fit',
					items	: [ inputTable ]
				}
			]
		}],
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['save', 'newData', 'reset', 'deleteAll'], false);
			this.setDefault();
		},
		onQueryButtonDown : function()  {
			if(panelResult.setAllFieldsReadOnly(true) == false) {
				return false;
			}
			directMasterStore.loadStoreRecords();
			UniAppManager.setToolbarButtons(['reset','delete', 'deleteAll'], true);
			UniAppManager.setToolbarButtons('newData', false);
		},
		onResetButtonDown: function() {
			panelResult.setAllFieldsReadOnly(false);
			inputTable.setAllFieldsReadOnly(false);
			panelResult.clearForm();
			directMasterStore.loadData({});
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function () {
			directMasterStore.saveStore();
		},
		onDeleteDataButtonDown: function() {
			var selRow = masterGrid.getSelectedRecord();
			if(!Ext.isEmpty(selRow)) {
				if(selRow.data.STATUS_FLAG == '1' || selRow.data.STATUS_FLAG == '2') {
					if(selRow.phantom === true) {
						masterGrid.deleteSelectedRow();
					}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
						masterGrid.deleteSelectedRow();
					}
				}else{
					Unilite.messageBox('진행상태: 올림, 전체오류 일경우에만 삭제가능합니다.');
					return false;
				}
			}
		},
		onDeleteAllButtonDown: function() {
			var records = directMasterStore.data.items;
			var isNewData = false;
			var isErr = false;
			Ext.each(records, function(record,i) {
				if(record.get('STATUS_FLAG') != '1' && record.get('STATUS_FLAG') != '2') {
					Unilite.messageBox('진행상태: 올림, 전체오류 일경우에만 삭제가능합니다.');
					isErr = true;
					return false;
				}
			});
			if(isErr){
				return false;
			}
			Ext.each(records, function(record,i) {
				if(record.phantom){					 //신규 레코드일시 isNewData에 true를 반환
					isNewData = true;
				}else{								  //신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
					if(confirm('전체삭제 하시겠습니까?')) {
						var deletable = true;
						if(deletable){
							masterGrid.reset();
							UniAppManager.app.onSaveDataButtonDown();
						}
						isNewData = false;
					}
					return false;
				}
			});
			if(isNewData){							  //신규 레코드들만 있을시 그리드 리셋
				masterGrid.reset();
				UniAppManager.app.onResetButtonDown();  //삭제후 RESET..
			}
		},

		setDefault: function() {
			panelResult.setValue('DIV_CODE'		, UserInfo.divCode);
			panelResult.setValue('STATUS_FLAG'	, '$');
			panelResult.setValue('IN_DATE_FR'	, UniDate.get('startOfMonth'));
			panelResult.setValue('IN_DATE_TO'	, UniDate.get('today'));
			inputTable.setValue('INOUT_DATE'	, UniDate.get('today'));
			//20200106 추가
//			inputTable.setValue('PROCESS_FLAG'	, 'N');

			var param	= panelResult.getValues();
			var outDate	= UniDate.getDbDateStr(inputTable.getValue('INOUT_DATE'));
			param.INOUT_DATE = outDate;
			s_str900ukrv_kdService.selectOutDate(param, function(provider, response) {
				if(!Ext.isEmpty(provider) && provider != '' &&  UniDate.getDbDateStr(outDate).replace(/\./g,'').length == 8) {
					inputTable.setValue('OUT_DATE', provider[0].OUT_DATE)
				}
			});
		}
	});
};
</script>