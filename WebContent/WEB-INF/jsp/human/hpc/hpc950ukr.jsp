<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hpc950ukr">
	<t:ExtComboStore comboType="BOR120" comboCode="BILL" storeId="billDivCode" />	<!-- 신고사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A035" />	<!-- 완료구분-->
	<t:ExtComboStore comboType="AU" comboCode="A039" />	<!-- 매각구분-->
	<t:ExtComboStore comboType="AU" comboCode="B010" />	<!-- 자본적지출-->
	<t:ExtComboStore comboType="AU" comboCode="B004" />	<!-- 화폐단위-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {
	color: #333333;
	font-weight: normal;
	padding: 1px 2px;
}
#ext-element-3 {
	align: center
}
</style>

<script type="text/javascript">

function appMain() {
	var msgFlag						= 'N';
	var detailStore1_2isDirtyFlag	= 'N';
	var sTaxYM						= Ext.isEmpty(${selectDefaultTaxYM}) ? []: ${selectDefaultTaxYM};
	var gsrsPayYM					= Ext.isEmpty(${selectDefaultTaxYM}) ? []: ${selectDefaultTaxYM};
	var gsPayDateOpt				= '${gsPayDateOpt}'
	// 전자파일생성 팝업
	var createWindow;
	//신규자료생성
	var createDataWindow
	// 검색 팝업
	var searchWindow;
	// 신고서 출력 팝업
	var printWindow;
	
	var A40_ORG = {
		 'INCOME_CNT'          : 0
		,'INCOME_SUPP_TOTAL_I' : 0
		,'DEF_IN_TAX_I'        : 0
		,'ADD_TAX_I'           : 0
		,'RET_IN_TAX_I'        : 0
		,'IN_TAX_I'            : 0
	}
	var A25_ORG = {
		 'INCOME_CNT'          : 0
		,'INCOME_SUPP_TOTAL_I' : 0
		,'DEF_IN_TAX_I'        : 0
		,'ADD_TAX_I'           : 0
		,'RET_IN_TAX_I'        : 0
		,'IN_TAX_I'            : 0
	}

	var directProxy1 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'hpc950ukrService.selectList1',
			update	: 'hpc950ukrService.updateList',
			syncAll	: 'hpc950ukrService.saveAll1'
		}
	});
	var directProxy1_2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'hpc950ukrService.selectList1_2',
			update	: 'hpc950ukrService.updateList1_2',
			syncAll	: 'hpc950ukrService.saveAll1_2'
		}
	});
	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'hpc950ukrService.selectList2',
			update	: 'hpc950ukrService.updateList',
			syncAll	: 'hpc950ukrService.saveAll2'
		}
	});
	var directProxy3 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'hpc950ukrService.selectList3',
			update	: 'hpc950ukrService.updateList',
			syncAll	: 'hpc950ukrService.saveAll3'
		}
	});
	var directProxy4 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'hpc950ukrService.selectList4',
			update	: 'hpc950ukrService.updateList',
			syncAll	: 'hpc950ukrService.saveAll4'
		}
	});

	Unilite.defineModel('hpc950ukrModel1', {
		fields: [
			{name: 'SECT_CODE'				, text: '사업장'								,type: 'string'},
			{name: 'RPT_YYYYMM'				, text: '신고연월'								,type: 'string'},
			{name: 'SUPP_YYYYMM'			, text: '지급연월'								,type: 'string'},
			{name: 'PAY_YYYYMM'				, text: '귀속연월'								,type: 'string'},
			{name: 'INCGUBN'				, text: '구분'								,type: 'string'},
			{name: 'INCCODE'				, text: '코드'								,type: 'string'},
			{name: 'INCOME_CNT'				, text: '4.인원'								,type: 'float',decimalPrecision:0, format:'0,000'},
			{name: 'INCOME_SUPP_TOTAL_I'	, text: '5.총지급액'							,type: 'float',decimalPrecision:0, format:'0,000'},
			{name: 'DEF_IN_TAX_I'			, text: '6.소득세 등'							,type: 'float',decimalPrecision:0, format:'0,000'},
			{name: 'DEF_SP_TAX_I'			, text: '7.농어촌특별세'							,type: 'float',decimalPrecision:0, format:'0,000'},
			{name: 'ADD_TAX_I'				, text: '8.가산세'								,type: 'float',decimalPrecision:0, format:'0,000'},
			{name: 'RET_IN_TAX_I'			, text: '9.당월 조정</br>환급세액'					,type: 'float',decimalPrecision:0, format:'0,000'},
			{name: 'IN_TAX_I'				, text: '10.소득세 등</br>(가산세 포함)'				,type: 'float',decimalPrecision:0, format:'0,000'},
			{name: 'SP_TAX_I'				, text: '11.농어촌</br>특별세'					,type: 'float',decimalPrecision:0, format:'0,000'}, //, maxLength: 14
			{name: 'STATE_TYPE'				, text: '연말정산포함여부'							,type: 'string'},
			{name: 'COMP_CODE'				, text: 'COMP_CODE'							,type: 'string'},
			{name: 'COL_EDIT4'				, text: '4.인원INCOME_CNT_EDIT'				,type: 'string'},
			{name: 'COL_EDIT5'				, text: '5.총지급액INCOME_SUPP_TOTAL_I_EDIT'	,type: 'string'},
			{name: 'COL_EDIT6'				, text: '6.소득세 등DEF_IN_TAX_I_EDIT'			,type: 'string'},
			{name: 'COL_EDIT7'				, text: '7.농어촌특별세DEF_SP_TAX_I_EDIT'			,type: 'string'},
			{name: 'COL_EDIT8'				, text: '8.가산세ADD_TAX_I_EDIT'				,type: 'string'},
			{name: 'COL_EDIT9'				, text: '9.당월 조정</br>환급세액RET_IN_TAX_I_EDIT'	,type: 'string'},
			{name: 'COL_EDIT10'				, text: '10.소득세 등</br>(가산세 포함)IN_TAX_I_EDIT'	,type: 'string'},
			{name: 'COL_EDIT11'				, text: '11.농어촌</br>특별세SP_TAX_I_EDIT'		,type: 'string'},
			{name: 'INSERT_FLAG'			, text: 'INSERT_FLAG'						,type: 'string'}
		]
	});
	Unilite.defineModel('hpc950ukrModel1_2', {
		fields: [
			{name: 'SECT_CODE'				, text: '사업장'							,type: 'string'},
			{name: 'RPT_YYYYMM'				, text: '신고연월'								,type: 'string'},
			{name: 'SUPP_YYYYMM'			, text: '지급연월'								,type: 'string'},
			{name: 'PAY_YYYYMM'				, text: '귀속연월'								,type: 'string'},
			{name: 'LAST_IN_TAX_I'			, text: '12.전월미환급'					,type: 'float',decimalPrecision:0, format:'0,000'},
			{name: 'BEFORE_IN_TAX_I'		, text: '13.기환급신청'					,type: 'float',decimalPrecision:0, format:'0,000'},
			{name: 'BAL_AMT'				, text: '14.잔액 12-13'					,type: 'float',decimalPrecision:0, format:'0,000'},
			{name: 'RET_AMT'				, text: '15.일반환급'						,type: 'float',decimalPrecision:0, format:'0,000'},
			{name: 'TRUST_AMT'				, text: '16.신탁재산'						,type: 'float',decimalPrecision:0, format:'0,000'},
			{name: 'FIN_COMP_AMT'			, text: '17.금융등'						,type: 'float',decimalPrecision:0, format:'0,000'},
			{name: 'MERGER_AMT'				, text: '17.합병등'						,type: 'float',decimalPrecision:0, format:'0,000'},
			{name: 'ROW_IN_TAX_I'			, text: '18.조정대상환급</br>(14+15+16+17)'	,type: 'float',decimalPrecision:0, format:'0,000'},
			{name: 'TOTAL_IN_TAX_I'			, text: '19.당월조정</br>환급액계'				,type: 'float',decimalPrecision:0, format:'0,000'},
			{name: 'NEXT_IN_TAX_I'			, text: '20.차월이월</br>환급액(18-19)'		,type: 'float',decimalPrecision:0, format:'0,000'},
			{name: 'RET_IN_TAX_I'			, text: '21.환급신청액'						,type: 'float',decimalPrecision:0, format:'0,000'},
			{name: 'STATE_TYPE'				, text: 'STATE_TYPE'					,type: 'string'},
			{name: 'UPDATE_DATE'			, text: 'UPDATE_DATE'					,type: 'string'},
			{name: 'UPDATE_ID'				, text: 'UPDATE_ID'						,type: 'string'},
			{name: 'COMP_CODE'				, text: 'COMP_CODE'						,type: 'string'}
		]
	});

	/* Store 정의(Service 정의)
	 * @type 
	 */
	var detailStore1 = Unilite.createStore('hpc950ukrDetailStore1',{
		proxy	: directProxy1,
		model	: 'hpc950ukrModel1',
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결 
			editable	: true,		// 수정 모드 사용 
			deletable	: false,	// 삭제 가능 여부 
			useNavi		: false		// prev | newxt 버튼 사용
		},
		autoLoad: false,
		saveStore: function() {
			var inValidRecs			= this.getInvalidRecords();
			var paramMaster			= panelSearch.getValues();
			paramMaster.CLOSE_TYPE	= '1';
			var rv					= true;

			if(inValidRecs.length == 0 ) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						panelSearch.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);
						
						if(detailStore1_2isDirtyFlag == 'Y') {
							detailStore1_2.saveStore();
						} else {
							detailStore1.loadStoreRecords();
						}
						detailStore1_2isDirtyFlag = 'N';
//						detailStore1.loadStoreRecords();
//						UniAppManager.app.onQueryButtonDown();
					} 
				};
				this.syncAllDirect(config);
			} else {
//				alert(Msg.sMB083);
				detailGrid1.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
 		loadStoreRecords: function() {
			var param= panelSearch.getValues();
			console.log( param );
			if(panelSearch.getInvalidMessage())	{
				detailStore1.loadData({})
				detailStore1_2.loadData({});
				detailStore2.loadData({});
				detailStore3.loadData({});
				detailStore4.loadData({});
				hpc950ukrService.selectStatus(param, function(responseText) {
					if(responseText)	{
						if(responseText.ALL_DIV_YN == "Y") {
							panelSearch.getField("ALL_DIV_YN").setValue("Y");
							panelSearch.getField("ALL_DIV_YN").checked = true;
						}
						if(responseText.CLOSE_YN == "Y") {
							panelSearch.getField("CLOSE_YN").setValue("Y");
							panelSearch.getField("CLOSE_YN").checked = true;
							panelSearch.down("#closeCancelBtn").show();
							panelSearch.down("#closeBtn").hide();
						} else {
							panelSearch.getField("CLOSE_YN").setValue("");
							panelSearch.getField("CLOSE_YN").checked = false;
							panelSearch.down("#closeBtn").show();
							panelSearch.down("#closeCancelBtn").hide();
						}
						detailStore1.loadAllData();
					} else {
						if (!createDataWindow) {
							createDataWindow = Ext.create('widget.uniDetailWindow', {
									title		: '신고자료생성',
									width		: 500,
									height		: 250,
									defaultType	: 'uniTextfield',
									items		: [{
										xtype	: 'uniDetailFormSimple',
										id      : 'createNewDataForm',
										layout	: {type: 'uniTable', columns: 1, tableAttrs:{align:'center'}},
										items	: [{
											tdAttrs     : {style:'padding-top : 10px;'},
											fieldLabel	: '신고사업장',
											name		: 'DIV_CODE',
											xtype		: 'uniCombobox',
											comboType	: 'BOR120',
											comboCode	: 'BILL',
											readOnly    : true,
											labelWidth	: 90,
											allowBlank	: false
										},{
											fieldLabel	: '신고연월',
											xtype		: 'uniMonthfield',
											name		: 'RPT_YYYYMM',                    
											value		: UniDate.get('today'),   
											labelWidth	: 90, 
											readOnly    : true,                
											allowBlank	: false
										},{
											fieldLabel	: '귀속연월',
											xtype		: 'uniMonthfield',
											name		: 'PAY_YYYYMM',                    
											value		: UniDate.get('today'), 
											labelWidth	: 90,
											readOnly    : true,
											allowBlank	: false
										},{
											fieldLabel	: '지급연월',
											xtype		: 'uniMonthfield',
											name		: 'SUPP_YYYYMM',                    
											value		: UniDate.get('today'),     
											labelWidth	: 90,    
											readOnly    : true,           
											allowBlank	: false
										},{
											fieldLabel	: '통합생성',
											xtype		: 'checkbox',
											name		: 'ALL_DIV_YN',   
											inputValue  : 'Y',
											labelWidth	: 90     
										},{
											xtype		: 'container',
											tdAttrs     : {align : 'center'},
											layout		: {type: 'table', columns: 2},
											defaults	: { xtype: 'button' },
											//margin		: '0 0 0 200',
											items:[{
												text	: '자료생성',
												width	: 70,
												margin	: '0 0 5 10',
												handler	: function(btn) {	
													var form = Ext.getCmp("createNewDataForm");
													panelSearch.setValue("ALL_DIV_YN", form.getValue("ALL_DIV_YN"));
													var param = panelSearch.getValues();
													
													hpc950ukrService.createData(param, function(responseText) {
														if(responseText && responseText.ERROR_DESC)	{ 
															Unilite.messageBox(responseText.ERROR_DESC);
														} else {
															createDataWindow.hide();
															UniAppManager.updateStatus("신규자료가 생성되었습니다.");
															detailStore1.loadAllData();
														}
													});
												}
											},{
												text	: '닫기',
												width	: 70,
												margin	: '0 0 5 10',
												handler	: function(btn) {
													createDataWindow.hide();
												}
											}]
										}]
									}],
									listeners:{
										beforeshow : function(){
											var form = Ext.getCmp("createNewDataForm");
											form.setValues(panelSearch.getValues());
											if(!panelSearch.getField("ALL_DIV_YN").checked)	{
												form.setValue('ALL_DIV_YN', '');
											} else {
												form.setValue('ALL_DIV_YN', 'Y');
											}
										}
									}
								});
							}
							createDataWindow.center();
							createDataWindow.show();
						
						/* if(confirm('생성된 자료가 없습니다. 신규자료를 생성하시겠습니까?'))	{
							hpc950ukrService.createData(param, function(responseText) {
								if(responseText)	{
									UniAppManager.updateStatus("신규자료가 생성되었습니다.");
									detailStore1.loadAllData();
								}
							});
						} */
					}
				})
			}
		},
		loadAllData : function()	{
			var param= panelSearch.getValues();
			Ext.getBody().mask();
			detailStore1.load({
				params	: param,
				callback: function () {
					if (detailStore1.getCount() > 0)	{
						panelSearch.setDisableFields(true);
						Ext.getCmp('printBtn').setDisabled(false);
						detailStore1_2.load({
							params	: param,
							callback : function()	{
								detailStore2.load({
									params	: param,
									callback : function()	{
										detailStore3.load({
											params	: param,
											callback : function()	{
												detailStore4.load({
													params	: param,
													callback : function()	{
														Ext.getBody().unmask();
													}
												})
											}
										})
									}
								})
							}
						})
					} else {
						Ext.getCmp('printBtn').setDisabled(true);
						Ext.getBody().unmask();
						panelSearch.setDisableFields(false);
					}
				}
			});
		},
		saveAllData : function()	{

			var paramMaster			= panelSearch.getValues();
			var dirtyCheck = [];
			if(detailStore1.isDirty())		{
				dirtyCheck.push({'store' : detailStore1});
				if(detailStore1.getInvalidRecords().length > 0 ) {
					tab.setActiveTab(0);
					detailGrid1.uniSelectInvalidColumnAndAlert(detailStore1.getInvalidRecords());
					return;
				}
			}
			if(detailStore1_2.isDirty())	{
				dirtyCheck.push({'store' : detailStore1_2});
				if(detailStore1_2.getInvalidRecords().length > 0 ) {
					tab.setActiveTab(0);
					detailGrid1_2.uniSelectInvalidColumnAndAlert(detailStore1_2.getInvalidRecords());
					return;
				}
			}
			if(detailStore2.isDirty())		{
				dirtyCheck.push({'store' : detailStore2});
				if(detailStore2.getInvalidRecords().length > 0 ) {
					tab.setActiveTab(1);
					detailGrid2.uniSelectInvalidColumnAndAlert(detailStore2.getInvalidRecords());
					return;
				}
			}
			if(detailStore3.isDirty())		{
				dirtyCheck.push({'store' : detailStore3});
				if(detailStore3.getInvalidRecords().length > 0 ) {
					tab.setActiveTab(2);
					detailGrid3.uniSelectInvalidColumnAndAlert(detailStore3.getInvalidRecords());
					return;
				}
			}
			if(detailStore4.isDirty())		{
				dirtyCheck.push({'store' : detailStore4});
				if(detailStore4.getInvalidRecords().length > 0 ) {
					tab.setActiveTab(3);
					detailGrid4.uniSelectInvalidColumnAndAlert(detailStore4.getInvalidRecords());
					return;
				}
			}
			var checkSaveCount = dirtyCheck.length;
			
			if(checkSaveCount > 0)	{
				Ext.getBody().mask();
				dirtyCheck[0].store.syncAllDirect({
					params: [paramMaster],
					useSavedMessage : checkSaveCount == 1 ? true : false,
					success : function() {
						if(checkSaveCount > 1)	{
							dirtyCheck[1].store.syncAllDirect({
								params: [paramMaster],
								useSavedMessage : checkSaveCount == 2 ? true : false,
								success : function() {
									var records = detailStore1.getData();
									if(records) {
										Ext.each(records.items, function(record, idx){
											if(record.get("INCCODE") == "A25")	{
												A25_ORG = {
													 'INCOME_CNT'          : parseInt(record.get("INCOME_CNT"))
													,'INCOME_SUPP_TOTAL_I' : parseInt(record.get("INCOME_SUPP_TOTAL_I"))
													,'DEF_IN_TAX_I'        : parseInt(record.get("DEF_IN_TAX_I"))
													,'ADD_TAX_I'           : parseInt(record.get("ADD_TAX_I"))
													,'RET_IN_TAX_I'        : parseInt(record.get("RET_IN_TAX_I"))
													,'IN_TAX_I'            : parseInt(record.get("IN_TAX_I"))
												}
											}
											if(record.get("INCCODE") == "A40")	{
												A40_ORG = {
													 'INCOME_CNT'          : parseInt(record.get("INCOME_CNT"))
													,'INCOME_SUPP_TOTAL_I' : parseInt(record.get("INCOME_SUPP_TOTAL_I"))
													,'DEF_IN_TAX_I'        : parseInt(record.get("DEF_IN_TAX_I"))
													,'ADD_TAX_I'           : parseInt(record.get("ADD_TAX_I"))
													,'RET_IN_TAX_I'        : parseInt(record.get("RET_IN_TAX_I"))
													,'IN_TAX_I'            : parseInt(record.get("IN_TAX_I"))
												}
											}
	
										})
									}
									if(checkSaveCount > 2)	{	
										dirtyCheck[2].store.syncAllDirect({
											params: [paramMaster],
											useSavedMessage : checkSaveCount == 3 ? true : false,
											success : function() {
												if(checkSaveCount > 3)	{	
													dirtyCheck[3].store.syncAllDirect({
														params: [paramMaster],
														useSavedMessage : checkSaveCount == 4 ? true : false,
														success : function() {
															if(checkSaveCount > 4)	{	
																dirtyCheck[4].store.syncAllDirect({
																	params: [paramMaster],
																	useSavedMessage : true,
																	success : function() {
																		Ext.getBody().unmask();
																	}
																})
															} else {
																Ext.getBody().unmask();
															}
														}
													})
												} else {
													Ext.getBody().unmask();
												}
											}
										})
									} else {
										Ext.getBody().unmask();
									}
								}
							})
						}
					}
				})
			}
		},
		listeners:{
			load:function(store, records) {
				if(records.length > 0) {
					UniAppManager.setToolbarButtons('deleteAll', true);
					Ext.each(records, function(record, idx){
						if(record.get("INCCODE") == "A25")	{
							A25_ORG = {
								 'INCOME_CNT'          : parseInt(record.get("INCOME_CNT"))
								,'INCOME_SUPP_TOTAL_I' : parseInt(record.get("INCOME_SUPP_TOTAL_I"))
								,'DEF_IN_TAX_I'        : parseInt(record.get("DEF_IN_TAX_I"))
								,'ADD_TAX_I'           : parseInt(record.get("ADD_TAX_I"))
								,'RET_IN_TAX_I'        : parseInt(record.get("RET_IN_TAX_I"))
								,'IN_TAX_I'            : parseInt(record.get("IN_TAX_I"))
							}
						}
						if(record.get("INCCODE") == "A40")	{
							A40_ORG = {
								 'INCOME_CNT'          : parseInt(record.get("INCOME_CNT"))
								,'INCOME_SUPP_TOTAL_I' : parseInt(record.get("INCOME_SUPP_TOTAL_I"))
								,'DEF_IN_TAX_I'        : parseInt(record.get("DEF_IN_TAX_I"))
								,'ADD_TAX_I'           : parseInt(record.get("ADD_TAX_I"))
								,'RET_IN_TAX_I'        : parseInt(record.get("RET_IN_TAX_I"))
								,'IN_TAX_I'            : parseInt(record.get("IN_TAX_I"))
							}
						}

					})
				} else {
					UniAppManager.setToolbarButtons('deleteAll', false);
				}
			}
		}
	});
	var detailStore1_2 = Unilite.createStore('hpc950ukrDetailStore1_2',{
		model	: 'hpc950ukrModel1_2',
		proxy	: directProxy1_2,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결 
			editable	: true,		// 수정 모드 사용 
			deletable	: false,	// 삭제 가능 여부 
			useNavi		: false		// prev | newxt 버튼 사용
		},
		autoLoad: false,
		saveStore : function() {
			var inValidRecs = this.getInvalidRecords();
			var rv = true;
			var paramMaster = panelSearch.getValues();
			if(inValidRecs.length == 0 ) {
				config = {
					useSavedMessage : msgFlag == 'Y' ? true : false,
					params	: [paramMaster],
					success	: function(batch, option) {
						panelSearch.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);
						if(msgFlag == 'N') {
							detailStore1.loadStoreRecords();
						}
						detailStore1_2.loadStoreRecords();
						msgFlag == 'N';
					}
				};
				this.syncAllDirect(config);
			} else {
				detailGrid1_2.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		loadStoreRecords: function() {
			var param= panelSearch.getValues();
			console.log( param );
			detailStore1_2.load({
				params : param
			});
		}
	});
	/** 부표-거주자
	 */
	var detailStore2 = Unilite.createStore('hpc950ukrDetailStore2',{
		model	: 'hpc950ukrModel1',
		proxy	: directProxy2,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결 
			editable	: true,		// 수정 모드 사용 
			deletable	: false,	// 삭제 가능 여부 
			useNavi		: false		// prev | newxt 버튼 사용
		},
		autoLoad: false,
		loadStoreRecords: function() {
			var param= panelSearch.getValues();
			this.load({
				params : param
			});
		},
		saveStore : function() {
			var inValidRecs = this.getInvalidRecords();
			var paramMaster = panelSearch.getValues();
			paramMaster.CLOSE_TYPE	= '1';
			var rv = true;
			if(inValidRecs.length == 0 ) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						panelSearch.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);	
						UniAppManager.app.onQueryButtonDown();
					} 
				};
				this.syncAllDirect(config);
			} else {
				detailGrid2.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
			}
		}
	});
	/** 부표-비거주자
	 */
	var detailStore3 = Unilite.createStore('hpc950ukrDetailStore3',{
		model	: 'hpc950ukrModel1',
		proxy	: directProxy3,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결 
			editable	: true,		// 수정 모드 사용 
			deletable	: false,	// 삭제 가능 여부 
			useNavi		: false		// prev | newxt 버튼 사용
		},
		autoLoad: false,
		loadStoreRecords: function() {
			var param= panelSearch.getValues();
			this.load({
				params : param
			});
		},
		saveStore : function() {
			var inValidRecs = this.getInvalidRecords();
			var paramMaster = panelSearch.getValues();
			paramMaster.CLOSE_TYPE	= '1';
			var rv = true;
			if(inValidRecs.length == 0 ) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						panelSearch.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);
						UniAppManager.app.onQueryButtonDown();
					} 
				};
				this.syncAllDirect(config);
			} else {
				detailGrid3.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});
	/** 부표-법인원천
	 */
	var detailStore4 = Unilite.createStore('hpc950ukrDetailStore4',{
		model	: 'hpc950ukrModel1',
		proxy	: directProxy4,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결 
			editable	: true,		// 수정 모드 사용 
			deletable	: false,	// 삭제 가능 여부 
			useNavi		: false		// prev | newxt 버튼 사용
		},
		autoLoad: false,
		loadStoreRecords: function() {
			var param= panelSearch.getValues();
			this.load({
				params : param
			});
		},
		saveStore : function() {
			var inValidRecs = this.getInvalidRecords();
			var paramMaster = panelSearch.getValues();
			paramMaster.CLOSE_TYPE	= '1';
			var rv = true;
			if(inValidRecs.length == 0 ) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						panelSearch.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);	
						UniAppManager.app.onQueryButtonDown();
					}
				};
				this.syncAllDirect(config);
			} else {
				detailGrid4.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});
	var createDataStore = Unilite.createStore('hpc950ukrcreateDataStore',{
		proxy: {
			type: 'direct',
			api	: {
				read: 'hpc950ukrService.createData'
			}
		},
		loadStoreRecords: function() {
			var param= Ext.getCmp('createDataForm').getValues();
			console.log( param );
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

	var searchWinForm = Unilite.createSearchForm('SearchWinForm', {	// 검색 팝업창
		layout			: {type: 'uniTable', columns : 2},
		items			: [{
				fieldLabel	: '사업장'  ,
				name		: 'DIV_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				comboCode	: 'BILL',
				allowBlank	: false
			},{
				fieldLabel		: '신고연월',
				xtype			: 'uniMonthRangefield',
				startFieldName	: 'RPT_YYYYMM_FR',
				endFieldName	: 'RPT_YYYYMM_TO',
				width			: 350,
				startDate		: UniDate.add(UniDate.today(), {'months' : -6}),
				endDate			: UniDate.get('today')
			}
		]
	});
	Unilite.defineModel('hpc959ukrModel', {
		fields: [
			{name: 'DIV_CODE'				, text: '사업장'								,type: 'string', comboType :'BOR120'},
			{name: 'RPT_YYYYMM'				, text: '신고연월'								,type: 'uniMonth'},
			{name: 'SUPP_YYYYMM'			, text: '지급연월'								,type: 'uniMonth'},
			{name: 'PAY_YYYYMM'				, text: '귀속연월'								,type: 'uniMonth'},
			{name: 'ALL_DIV_YN'				, text: '통합생성여부'							,type: 'string'},
			{name: 'CLOSE_YN'				, text: '마감여부'								,type: 'string'},
			{name: 'LAST_IN_TAX_I'			, text: '전월미환급세액'						,type: 'uniPrice'},
			{name: 'NEXT_IN_TAX_I'			, text: '이월환급세액'							,type: 'uniPrice'},
			{name: 'TAX_AMOUNT'				, text: '납부세액'								,type: 'uniPrice'},
			{name: 'WORK_YN'				, text: '전자파일생성'							,type: 'string'},
			{name: 'WORK_DATE'				, text: '전자파일작성일'						,type: 'uniDate'},
			{name: 'HOMETEX_ID'				, text: '홈텍스ID'							,type: 'string'},
			{name: 'TAX_BASE_YN'			, text: '일괄납부여부'							,type: 'string'}
		]
	});
	var searchWinStore = Unilite.createStore('hpc959ukrStore',{
		model : 'hpc959ukrModel',
		uniOpt	: {
			isMaster	: false,		// 상위 버튼 연결 
			editable	: false,		// 수정 모드 사용 
			deletable	: false,	// 삭제 가능 여부 
			useNavi		: false		// prev | newxt 버튼 사용
		},
		proxy: {
			type: 'direct',
			api	: {
				read: 'hpc950ukrService.selectSearchList'
			}
		},
		loadStoreRecords: function() {
			var param= Ext.getCmp('SearchWinForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	var searchWinGrid = Unilite.createGrid('searchWinGrid', {	// 검색팝업창
		// title: '기본',
		layout : 'fit',
		store: searchWinStore,
		uniOpt:{
			useRowNumberer: false
		},
		columns:  [
					 { dataIndex: 'RPT_YYYYMM'		   ,  width: 80, align:'center'},
					 { dataIndex: 'PAY_YYYYMM'		   ,  width: 80, align:'center'},
					 { dataIndex: 'SUPP_YYYYMM'		   ,  width: 80, align:'center'},
					 { dataIndex: 'ALL_DIV_YN'		   ,  width: 100, align:'center'},
					 { dataIndex: 'CLOSE_YN'		   ,  width: 80, align:'center'},
					 { dataIndex: 'LAST_IN_TAX_I'	   ,  width: 110},
					 { dataIndex: 'TAX_AMOUNT'		   ,  width: 100},
					 { dataIndex: 'NEXT_IN_TAX_I'	   ,  width: 100},
					 { dataIndex: 'WORK_YN'			   ,  width: 100, align:'center'},
					 { dataIndex: 'WORK_DATE'		   ,  width: 100},
					 { dataIndex: 'HOMETEX_ID'		   ,  width: 100},
					 { dataIndex: 'TAX_BASE_YN'		   ,  width: 100, align:'center'}
		  ] ,
		  listeners: {
			  onGridDblClick: function(grid, record, cellIndex, colName) {
				    searchWinGrid.returnData(record);
				  	UniAppManager.app.onQueryButtonDown();
				  	searchWindow.hide();
			  }
		  },
		  returnData: function(record)	{
		  		if(Ext.isEmpty(record))	{
		  			record = this.getSelectedRecord();
		  		}
		  		panelSearch.uniOpt.inLoading = true;
		  		panelSearch.setValues(record.data);
		  		panelSearch.uniOpt.inLoading = false;
		  		if(record.get('ALL_DIV_YN') == 'Y')  panelSearch.getField('ALL_DIV_YN').checked = true;
		  		if(record.get('CLOSE_YN') == 'Y')  panelSearch.getField('CLOSE_YN').checked = true;
		  		
		  		UniAppManager.app.onQueryButtonDown();
	   	  }
	});
	var panelSearch = Unilite.createSearchForm('panelSearch', {
		region	: 'north',
		layout	: {type: 'uniTable', columns: 5,
			tableAttrs: { width: '100%' , border : 0}
		},
		padding: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel	: '신고사업장',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			comboCode	: 'BILL',
			allowBlank	: false,
			tdAttrs		: {width: 380},
			colspan		: 4
		},{
			xtype : 'container',
			layout :{type:'uniTable', columns:3,tableAttrs:{ border:0}},
			tdAttrs	: {align: 'right', style:'padding-right:10px;'},
			items : [{
					xtype : 'button',
					text  : '마감',
					itemId :'closeBtn',
					width : 100,
					tdAttrs : {width : 110, align : 'center'},
					handler : function() {
						if(detailGrid1.getStore().getCount() < 1) {
							alert('원천징수내역 조회후 진행해 주십시오.');
							return false;
						}
						panelSearch.setValue("CLOSE_YN","Y");
						var param = panelSearch.getValues();
						Ext.getBody().mask();
						hpc950ukrService.updateClose(param, function(responseText){
							Ext.getBody().unmask();
							if(responseText) {
								UniAppManager.updateStatus("마감처리 되었습니다.");
								panelSearch.down("#closeCancelBtn").show();
								panelSearch.down("#closeBtn").hide();
							}
						})
					}
				},{
					xtype : 'button',
					text  : '마감취소',
					width : 100,
					itemId :'closeCancelBtn',
					hidden : true,
					tdAttrs : {width : 110, align : 'center'},
					handler : function() {
						if(detailGrid1.getStore().getCount() < 1) {
							alert('원천징수내역 조회후 진행해 주십시오. 만약 원천징수내역이 없다면 신고자료생성을 먼저 진행해 주십시오.');
							return false;
						}
						panelSearch.setValue("CLOSE_YN","");
						panelSearch.getField("CLOSE_YN").checked = false;
						var param = panelSearch.getValues();
						param.CLOSE_YN = 'N';
						Ext.getBody().mask();
						hpc950ukrService.updateClose(param, function(responseText){
							Ext.getBody().unmask();
							if(responseText) {
								UniAppManager.updateStatus("마감취소 되었습니다.");
								panelSearch.down("#closeBtn").show();
								panelSearch.down("#closeCancelBtn").hide();
							}
						})
					}
				},{
					xtype : 'button',
					text  : '검색',
					width : 100,
					tdAttrs : {width : 110, align : 'right', style:'padding-right:10px;'},
					handler : function() {
						if(UniAppManager.app._needSave())	{
							if(confirm("저장 할 내용이 있습니다. 저장하시겠습니까? ")) {
								UniAppManager.app.onSaveDataButtonDown();
							}
							return;
						} 
						if(!searchWindow) {
							searchWindow = Ext.create('widget.uniDetailWindow', {
								title	: '원천징수이행상황신고 검색',
								width: 1080,
								height: 580,
								layout: {type:'vbox', align:'stretch'},
								items: [searchWinForm, searchWinGrid], //masterGrid],
								tbar:  ['->',
									{ itemId : 'saveBtn',
									text: '조회',
									handler: function() {
										searchWinStore.loadStoreRecords();
									},
									disabled: false
									}, {
										itemId : 'closeBtn',
										text: '닫기',
										handler: function() {
											searchWindow.hide();
										},
										disabled: false
									}
								],
								listeners : {beforehide: function(me, eOpt)
									{
									    searchWinForm.clearForm();
									    searchWinGrid.reset();
									},
									beforeclose: function( panel, eOpts )	{
										searchWinForm.clearForm();
										searchWinGrid.reset();
									},
									beforeshow : function()	{
										searchWinForm.setValue("DIV_CODE"     , panelSearch.getValue("DIV_CODE"));
										searchWinForm.setValue("RPT_YYYYMM_FR", UniDate.add(panelSearch.getValue("RPT_YYYYMM"), {'months': -12}));
										searchWinForm.setValue("RPT_YYYYMM_TO", panelSearch.getValue("RPT_YYYYMM"));
									}
								}
							})
						}
						searchWindow.show();
						searchWindow.center();
						searchWinStore.loadStoreRecords();
					}
				}]
		},{
			fieldLabel	: '신고연월',
			xtype		: 'uniMonthfield',
			name		: 'RPT_YYYYMM',
			allowBlank	: false,
			hidden      : true,
			tdAttrs		: {width: 250},
			listeners   : {
				change : function(field, newValue, oldValue, eOpt) {
					if(!panelSearch.uniOpt.inLoading)	{ 
						
					}
				}
			}
		},{
			fieldLabel	: '귀속연월',
			xtype		: 'uniMonthfield',
			name		: 'PAY_YYYYMM',
			allowBlank	: false,
			tdAttrs		: {width: 250}
		},{
			fieldLabel	: '지급연월',
			xtype		: 'uniMonthfield',
			name		: 'SUPP_YYYYMM',
			allowBlank	: false,
			tdAttrs		: {width: 250},
			listeners   : {
				change : function(field, newValue, oldValue, eOpt) {
					if(!panelSearch.uniOpt.inLoading)	{ 
						if(Ext.isDate(newValue))	{
							panelSearch.setValue('RPT_YYYYMM', UniDate.add(newValue, {'months' : 1}));
						}
					}
				}
			}
		},{ 
			fieldLabel	: '통합생성',
			name		: 'ALL_DIV_YN',
			xtype		: 'checkbox',
			inputValue  : 'Y'
		},{
			fieldLabel	: '마감여부',
			name		: 'CLOSE_YN',
			xtype		: 'checkbox',
			inputValue  : 'Y'
		},{
			fieldLabel	: '신고구분',
			name		: 'STATE_TYPE',
			xtype		: 'uniTextfield',
			hidden      : true,
			value		: '0',
			tdAttrs		: {align : 'center'}
		},{
			xtype	: 'container',
			layout	: {type: 'uniTable', columns: 2,tableAttrs:{ border:0}},
			tdAttrs	: {align: 'right', style:'padding-right:10px;'},
			items	: [{
				xtype	: 'button',
				text	: '신고서출력',
				itemId	: 'printBtn',
				id		: 'printBtn',
				width	: 100,
				tdAttrs : {width : 110, align:'center'},
				handler	: function(btn) {
					openPrintWindow();
				}
			},{
				xtype	: 'button',
				text	: '전자파일생성',
				width	: 100,
				tdAttrs : {width:110},
				handler	: function(btn) {
					if(UniAppManager.app._needSave())	{
						if(confirm("저장 할 내용이 있습니다. 저장하시겠습니까? ")) {
							UniAppManager.app.onSaveDataButtonDown();
						}
						return;
					} 
					humanCommonService.selectDivInfo({'DIV_CODE':panelSearch.getValue("DIV_CODE")} , function(responseText){
						var homeTaxId = "";
						if(responseText)	homeTaxId = responseText.HOMETAX_ID;
						if (!createWindow) {
							createWindow = Ext.create('widget.uniDetailWindow', {
								title		: '원천징수이행상황신고자료생성',
								width		: 330,
								height		: 280,
								defaultType	: 'uniTextfield',
								items		: [{
									xtype	: 'uniDetailFormSimple',
									layout	: {type: 'uniTable', columns: 1},
									id		: 'createDataForm',
									items	: [{
										tdAttrs     : {style:'padding-top : 10px;'},
										fieldLabel	: '신고사업장',
										id			: 'DIV_CODE',
										name		: 'DIV_CODE',
										xtype		: 'uniCombobox',
										comboType	: 'BOR120',
										comboCode	: 'BILL',
										readOnly    : true,
										labelWidth	: 110,
										allowBlank	: false
									},{
										fieldLabel	: '신고연월',
										id			: 'RPT_YYYYMM',
										xtype		: 'uniMonthfield',
										name		: 'RPT_YYYYMM',                    
										value		: UniDate.get('today'),   
										labelWidth	: 110, 
										readOnly    : true,                
										allowBlank	: false
									},{
										fieldLabel	: '귀속연월',
										id			: 'PAY_YYYYMM',
										xtype		: 'uniMonthfield',
										name		: 'PAY_YYYYMM',                    
										value		: UniDate.get('today'), 
										labelWidth	: 110,
										readOnly    : true,
										allowBlank	: false
									},{
										fieldLabel	: '지급연월',
										id			: 'SUPP_YYYYMM',
										xtype		: 'uniMonthfield',
										name		: 'SUPP_YYYYMM',                    
										value		: UniDate.get('today'),     
										labelWidth	: 110,    
										readOnly    : true,           
										allowBlank	: false
									},{
										
										fieldLabel	: '작성일자',
										id			: 'WORK_DATE',
										xtype		: 'uniDatefield',
										name		: 'WORK_DATE',                    
										value		: UniDate.get('today'), 
										labelWidth	: 110,                 
										allowBlank	: false
									},{
										fieldLabel	: '신고구분',
										name		: 'STATE_TYPE',
										xtype		: 'uniTextfield',
										labelWidth	: 90,
										allowBlank	: false,
										hidden      : true
									},{
										fieldLabel	: '홈텍스ID',
										name		: 'HOMETAX_ID',
										xtype		: 'uniTextfield',
										labelWidth	: 110,
										allowBlank	: false
									},{
										fieldLabel	: '일괄납부여부',
										name		: 'BATCH_YN', 
										xtype		: 'uniCombobox',
										comboType	: 'AU',
										comboCode	: 'B010',
										value		: 'N',
										labelWidth	: 110,
										allowBlank	: false
									},{
										xtype		: 'container',
										tdAttrs     : {align : 'center'},
										layout		: {type: 'table', columns: 2},
										defaults	: { xtype: 'button' },
										//margin		: '0 0 0 200',
										items:[{
											text	: '자료생성',
											width	: 70,
											margin	: '0 0 5 10',
											handler	: function(btn) {
												var form = Ext.getCmp('createDataForm');
												var param  = form.getValues();
												
												if(!form.isValid()){
													return;
												}
												Ext.getBody().mask('로딩중...','loading-indicator');
																
												hpc950ukrService.createFileExec(param, function(provider, response) {
													if (response.message != 'Server Error'){
														if (!Ext.isEmpty(provider)) {                    
	
															if(provider.RETURN_VALUE == '1'){      
																panelFileDown2.setValues(param);
																panelFileDown2.submit({
											                        params: param,
											                        success:function()  {
											                            Ext.getBody().unmask();
											                        },
											                        failure: function(form, action){
											                            Ext.getBody().unmask();
											                        }
											                    });
																
															}else {
																Ext.Msg.alert('실패', '원천징수이행상황신고자료생성을 실패하였습니다.');
																Ext.getBody().unmask();
															}
														}
													}
												});
												
												
											}
										},{
											text	: '닫기',
											width	: 70,
											margin	: '0 0 5 10',
											handler	: function(btn) {
												createWindow.hide();
												Ext.getBody().unmask();
											}
										}]
									}]
								}],
								listeners:{
									beforeshow : function(){
										var form = Ext.getCmp("createDataForm");
										form.setValues(panelSearch.getValues());
										form.setValue("WORK_TYPE", '1');
										form.setValue("WORK_DATE", UniDate.get('today'));
										form.setValue("HOMETAX_ID",createWindow.homeTaxId);
										
									}
								}
							});
						}
						createWindow.homeTaxId = homeTaxId
						createWindow.center();
						createWindow.show();
					})
				}
			}/* ,{
				xtype	: 'button',
				text	: '환급신청서작성',
				width	: 100,
				hidden  : true,
				handler	: function(btn) {
					if (detailGrid1.getStore().getCount() > 0) {
						var params = {
							PGM_ID		: 'hpc950ukr',
							DIV_CODE	:panelSearch.getValue('DIV_CODE'),
							TAX_YYYYMM	: panelSearch.getValue('RPT_YYYYMM')
						};
						var rec = {data : {prgID : 'hpa996ukr', 'text':'홈택스-원천징수세액환급신청서'}};
						parent.openTab(rec, '/human/hpa996ukr.do', params);
					} else {
						Ext.Msg.alert('확인', '작성할 자료가 없습니다.');
					}
				}
			} */]
		}],
		setDisableFields: function(disable)	{
			var me = this;
			this.getField("DIV_CODE").setReadOnly(disable);
			this.getField("PAY_YYYYMM").setReadOnly(disable);
			this.getField("SUPP_YYYYMM").setReadOnly(disable);
			this.getField("ALL_DIV_YN").setReadOnly(disable);
			this.getField("CLOSE_YN").setReadOnly(disable);
			this.getField("STATE_TYPE").setReadOnly(disable);
		}
	});

	var detailGrid1 = Unilite.createGrid('hpc950ukrGrid1', {
		store	: detailStore1,
		layout	: 'fit',
		region	: 'center',
		flex	: 4,
		uniOpt	: {
			useMultipleSorting	: false,
			useLiveSearch		: false,
			onLoadSelectFirst	: true,
			dblClickToEdit		: true,
			useGroupSummary		: false,
			useContextMenu		: false,
			useRowNumberer		: true,
			expandLastColumn	: true,
			useRowContext		: false,
			filter				: {
				useFilter	: false,
				autoCreate	: false
			}
		},
		sortableColumns	: false,
		enableColumnHide: false,
		
		columns: [
			{dataIndex: 'SECT_CODE'						, width: 133, hidden: true},
			{dataIndex: 'RPT_YYYYMM'					, width: 80, hidden: true},
			{dataIndex: 'PAY_YYYYMM'					, width: 80, hidden: true},
			{dataIndex: 'SUPP_YYYYMM'					, width: 80, hidden: true},
			{dataIndex: 'INCGUBN'						, width: 250},
			{dataIndex: 'INCCODE'						, width: 50 , align: 'center'},
			{text: '소득지급(과세미달,비과세포함)',
				columns: [
					{dataIndex: 'INCOME_CNT'			, width: 86,
						renderer: function(value, metaData, record) {
							if (UniUtils.indexOf(record.data.COL_EDIT4,'N')) {
								metaData.tdCls = 'x-change-cell_edit_x1';
								if(value == 0 ) {
									return '';
								} else{
									return Ext.util.Format.number(value,'0,000');
								}
							} else if(UniUtils.indexOf(record.data.COL_EDIT4,'D')) {
								metaData.tdCls = 'x-change-cell_edit_x2';
								return Ext.util.Format.number(value,'0,000');
							} else{
								return Ext.util.Format.number(value,'0,000');
							}
						}
					},
					{dataIndex: 'INCOME_SUPP_TOTAL_I'	, width: 120,
						renderer: function(value, metaData, record) {
							if (UniUtils.indexOf(record.data.COL_EDIT5,'N')) {
								metaData.tdCls = 'x-change-cell_edit_x1';
								if(value == 0 ) {
									return '';
								} else{
									return Ext.util.Format.number(value,'0,000');
								}
							} else if(UniUtils.indexOf(record.data.COL_EDIT5,'D')) {
								metaData.tdCls = 'x-change-cell_edit_x2';
								return Ext.util.Format.number(value,'0,000');
							} else{
								return Ext.util.Format.number(value,'0,000');
							}
						}
					}
				]
			},{text: '징수세액',
				columns: [
					{dataIndex: 'DEF_IN_TAX_I'			, width: 120,
						renderer: function(value, metaData, record) {
							if (UniUtils.indexOf(record.data.COL_EDIT6,'N')) {
								metaData.tdCls = 'x-change-cell_edit_x1';
								if(value == 0 ) {
									return '';
								} else{
									return Ext.util.Format.number(value,'0,000');
								}
							} else if(UniUtils.indexOf(record.data.COL_EDIT6,'D')) {
								metaData.tdCls = 'x-change-cell_edit_x2';
								return Ext.util.Format.number(value,'0,000');
							} else{
								return Ext.util.Format.number(value,'0,000');
							}
						}
					},
					{dataIndex: 'DEF_SP_TAX_I'			, width: 120,
						renderer: function(value, metaData, record) {
							if (UniUtils.indexOf(record.data.COL_EDIT7,'N')) {
								metaData.tdCls = 'x-change-cell_edit_x1';
								if(value == 0 ) {
									return '';
								} else{
									return Ext.util.Format.number(value,'0,000');
								}
							} else if(UniUtils.indexOf(record.data.COL_EDIT7,'D')) {
								metaData.tdCls = 'x-change-cell_edit_x2';
								return Ext.util.Format.number(value,'0,000');
							} else{
								return Ext.util.Format.number(value,'0,000');
							}
						}
					},
					{dataIndex: 'ADD_TAX_I'				, width: 120,
						renderer: function(value, metaData, record) {
							if (UniUtils.indexOf(record.data.COL_EDIT8,'N')) {
								metaData.tdCls = 'x-change-cell_edit_x1';
								if(value == 0 ) {
									return '';
								} else{
									return Ext.util.Format.number(value,'0,000');
								}
							} else if(UniUtils.indexOf(record.data.COL_EDIT8,'D')) {
								metaData.tdCls = 'x-change-cell_edit_x2';
								return Ext.util.Format.number(value,'0,000');
							} else{
								return Ext.util.Format.number(value,'0,000');
							}
						}
					}
				]
			},
			{dataIndex: 'RET_IN_TAX_I'					, width: 120,
				renderer: function(value, metaData, record) {
					if (UniUtils.indexOf(record.data.COL_EDIT9,'N')) {
						metaData.tdCls = 'x-change-cell_edit_x1';
						if(value == 0 ) {
							return '';
						} else{
							return Ext.util.Format.number(value,'0,000');
						}
					} else if(UniUtils.indexOf(record.data.COL_EDIT9,'D')) {
						metaData.tdCls = 'x-change-cell_edit_x2';
						return Ext.util.Format.number(value,'0,000');
					} else{
						return Ext.util.Format.number(value,'0,000');
					}
				}
			},
			{dataIndex: 'IN_TAX_I'						, width: 120,
				renderer: function(value, metaData, record) {
					if (UniUtils.indexOf(record.data.COL_EDIT10,'N')) {
						metaData.tdCls = 'x-change-cell_edit_x1';
						if(value == 0 ) {
							return '';
						} else{
							return Ext.util.Format.number(value,'0,000');
						}
					} else if(UniUtils.indexOf(record.data.COL_EDIT10,'D')) {
						metaData.tdCls = 'x-change-cell_edit_x2';
						return Ext.util.Format.number(value,'0,000');
					} else{
						return Ext.util.Format.number(value,'0,000');
					}
				}
			},
			{dataIndex: 'SP_TAX_I'						, width: 120,
				renderer: function(value, metaData, record) {
					if (UniUtils.indexOf(record.data.COL_EDIT11,'N')) {
						metaData.tdCls = 'x-change-cell_edit_x1';
						if(value == 0 ) {
							return '';
						} else{
							return Ext.util.Format.number(value,'0,000');
						}
					} else if(UniUtils.indexOf(record.data.COL_EDIT11,'D')) {
						metaData.tdCls = 'x-change-cell_edit_x2';
						return Ext.util.Format.number(value,'0,000');
					} else{
						return Ext.util.Format.number(value,'0,000');
					}
				}
			},
			{dataIndex: 'STATE_TYPE'					, width: 80, hidden: true},
			{dataIndex: 'COMP_CODE'						, width: 6, hidden: true}
//			{dataIndex: 'COL_EDIT4'		, width: 80},
//			{dataIndex: 'COL_EDIT5'		, width: 80},
//			{dataIndex: 'COL_EDIT6'		, width: 80},
//			{dataIndex: 'COL_EDIT7'		, width: 80},
//			{dataIndex: 'COL_EDIT8'		, width: 80},
//			{dataIndex: 'COL_EDIT9'		, width: 80},
//			{dataIndex: 'COL_EDIT10'	, width: 80},
//			{dataIndex: 'COL_EDIT11'	, width: 80}
		],
		listeners: {
			beforeedit: function(editor, e, eOpts) {
				if(UniUtils.indexOf(e.field, ['INCOME_CNT'])) {
					if(Ext.isEmpty(e.record.data.COL_EDIT4)) {
						return true;
					} else{
						return false;
					}
				} else if(UniUtils.indexOf(e.field, ['INCOME_SUPP_TOTAL_I'])) {
					if(Ext.isEmpty(e.record.data.COL_EDIT5)) {
						return true;
					} else{
						return false;
					}
				} else if(UniUtils.indexOf(e.field, ['DEF_IN_TAX_I'])) {
					if(Ext.isEmpty(e.record.data.COL_EDIT6)) {
						return true;
					} else{
						return false;
					}
				} else if(UniUtils.indexOf(e.field, ['DEF_SP_TAX_I'])) {
					if(Ext.isEmpty(e.record.data.COL_EDIT7)) {
						return true;
					} else{
						return false;
					}
				} else if(UniUtils.indexOf(e.field, ['ADD_TAX_I'])) {
					if(Ext.isEmpty(e.record.data.COL_EDIT8)) {
						return true;
					} else{
						return false;
					}
				} else if(UniUtils.indexOf(e.field, ['RET_IN_TAX_I'])) {
					if(Ext.isEmpty(e.record.data.COL_EDIT9)) {
						return true;
					} else{
						return false;
					}
				} else if(UniUtils.indexOf(e.field, ['IN_TAX_I'])) {
					if(Ext.isEmpty(e.record.data.COL_EDIT10)) {
						return true;
					} else{
						return false;
					}
				} else if(UniUtils.indexOf(e.field, ['SP_TAX_I'])) {
					if(Ext.isEmpty(e.record.data.COL_EDIT11)) {
						return true;
					} else{
						return false;
					}
				} else{
					return false;
				}
			}
		}
	});
	var detailGrid1_2 = Unilite.createGrid('hpc950ukrGrid1_2', {
		store		: detailStore1_2,
		layout		: 'fit',
		region		: 'south',
		minHeight	: 80,
		height		: 80,
		split		: true,
		uniOpt		: {
			useMultipleSorting	: false,
			useLiveSearch		: false,
			onLoadSelectFirst	: true,
			dblClickToEdit		: true,
			useGroupSummary		: false,
			useContextMenu		: false,
			useRowNumberer		: true,
			expandLastColumn	: true,
			useRowContext		: false,
			userToolbar			: false,
			filter				: {
				useFilter	: false,
				autoCreate	: false
			}
		},
		sortableColumns	: false,
		enableColumnHide: false,
		columns: [
			{dataIndex: 'SECT_CODE'					, width: 133, hidden: true},
			{dataIndex: 'RPT_YYYYMM'				, width: 80, hidden: true},
			{dataIndex: 'PAY_YYYYMM'				, width: 80, hidden: true},
			{dataIndex: 'SUPP_YYYYMM'				, width: 80, hidden: true},
			{text: '전월 미환급 세액의 계산',
				columns: [
					{dataIndex: 'LAST_IN_TAX_I'		, width: 110},
					{dataIndex: 'BEFORE_IN_TAX_I'	, width: 110},
					{dataIndex: 'BAL_AMT'			, width: 110,
						renderer: function(value, metaData, record) {
							metaData.tdCls = 'x-change-cell_edit_x2';
							return Ext.util.Format.number(value,'0,000');
						}
					}
				]
			},{text: '당월 발생 환급세액',
				columns: [
					{dataIndex: 'RET_AMT'			, width: 110,
						renderer: function(value, metaData, record) {
							metaData.tdCls = 'x-change-cell_edit_x2';
							return Ext.util.Format.number(value,'0,000');
						}
					},
					{dataIndex: 'TRUST_AMT'			, width: 110},
					{dataIndex: 'FIN_COMP_AMT'		, width: 110},
					{dataIndex: 'MERGER_AMT'		, width: 110}
				]
			},
			{dataIndex: 'ROW_IN_TAX_I'				, width: 115,
				renderer: function(value, metaData, record) {
					metaData.tdCls = 'x-change-cell_edit_x2';
					return Ext.util.Format.number(value,'0,000');
				}
			},
			{dataIndex: 'TOTAL_IN_TAX_I'			, width: 115,
				renderer: function(value, metaData, record) {
					metaData.tdCls = 'x-change-cell_edit_x2';
					return Ext.util.Format.number(value,'0,000');
				}
			},
			{dataIndex: 'NEXT_IN_TAX_I'				, width: 115,
				renderer: function(value, metaData, record) {
					metaData.tdCls = 'x-change-cell_edit_x2';
					return Ext.util.Format.number(value,'0,000');
				}
			},
			{dataIndex: 'RET_IN_TAX_I'				, width: 115},
			{dataIndex: 'STATE_TYPE'				, width: 100, hidden: true},
			{dataIndex: 'UPDATE_DATE'				, width: 100, hidden: true},
			{dataIndex: 'UPDATE_ID'					, width: 100, hidden: true},
			{dataIndex: 'COMP_CODE'					, width: 100, hidden: true}
		],
		listeners: {
			beforeedit: function(editor, e, eOpts) {
				if(UniUtils.indexOf(e.field, ['LAST_IN_TAX_I','BEFORE_IN_TAX_I','TRUST_AMT', 'FIN_COMP_AMT','MERGER_AMT','RET_IN_TAX_I'])) {
					return true;
				} else {
					return false;
				}
			}
		}
	});
	/** 부표자-거주자
	 */
	var detailGrid2 = Unilite.createGrid('hpc950ukrGrid2', {
		store	: detailStore2,
		layout	: 'fit',
		region	: 'center',
		flex	: 4,
		uniOpt	: {
			useMultipleSorting	: false,
			useLiveSearch		: false,
			onLoadSelectFirst	: true,
			dblClickToEdit		: true,
			useGroupSummary		: false,
			useContextMenu		: false,
			useRowNumberer		: true,
			expandLastColumn	: true,
			useRowContext		: false,
			filter				: {
				useFilter	: false,
				autoCreate	: false
			}
		},
		sortableColumns	: false,
		enableColumnHide: false,
		columns	: [
			{dataIndex: 'SECT_CODE'						, width: 133, hidden: true},
			{dataIndex: 'RPT_YYYYMM'					, width: 80, hidden: true},
			{dataIndex: 'PAY_YYYYMM'					, width: 80, hidden: true},
			{dataIndex: 'SUPP_YYYYMM'					, width: 80, hidden: true},
			{dataIndex: 'INCGUBN'						, width: 250},
			{dataIndex: 'INCCODE'						, width: 50 , align: 'center'},
			{text: '소득지급(과세미달,비과세포함)',
				columns: [
					{dataIndex: 'INCOME_CNT'			, width: 86,
						renderer: function(value, metaData, record) {
							if (UniUtils.indexOf(record.data.COL_EDIT4,'N')) {
								metaData.tdCls = 'x-change-cell_edit_x1';
								if(value == 0 ) {
									return '';
								} else{
									return Ext.util.Format.number(value,'0,000');
								}
							} else if(UniUtils.indexOf(record.data.COL_EDIT4,'D')) {
								metaData.tdCls = 'x-change-cell_edit_x2';
								return Ext.util.Format.number(value,'0,000');
							} else{
								return Ext.util.Format.number(value,'0,000');
							}
						}
					},
					{dataIndex: 'INCOME_SUPP_TOTAL_I'	, width: 120,
						renderer: function(value, metaData, record) {
							if (UniUtils.indexOf(record.data.COL_EDIT5,'N')) {
								metaData.tdCls = 'x-change-cell_edit_x1';
								if(value == 0 ) {
									return '';
								} else{
									return Ext.util.Format.number(value,'0,000');
								}
							} else if(UniUtils.indexOf(record.data.COL_EDIT5,'D')) {
								metaData.tdCls = 'x-change-cell_edit_x2';
								return Ext.util.Format.number(value,'0,000');
							} else{
								return Ext.util.Format.number(value,'0,000');
							}
						}
					}
				]
			},
			{text: '징수세액',
				columns: [
					{dataIndex: 'DEF_IN_TAX_I'			, width: 120,
						renderer: function(value, metaData, record) {
							if (UniUtils.indexOf(record.data.COL_EDIT6,'N')) {
								metaData.tdCls = 'x-change-cell_edit_x1';
								if(value == 0 ) {
									return '';
								} else{
									return Ext.util.Format.number(value,'0,000');
								}
							} else if(UniUtils.indexOf(record.data.COL_EDIT6,'D')) {
								metaData.tdCls = 'x-change-cell_edit_x2';
								return Ext.util.Format.number(value,'0,000');
							} else{
								return Ext.util.Format.number(value,'0,000');
							}
						}
					},
					{dataIndex: 'DEF_SP_TAX_I'			, width: 120,
						renderer: function(value, metaData, record) {
							if (UniUtils.indexOf(record.data.COL_EDIT7,'N')) {
								metaData.tdCls = 'x-change-cell_edit_x1';
								if(value == 0 ) {
									return '';
								} else{
									return Ext.util.Format.number(value,'0,000');
								}
							} else if(UniUtils.indexOf(record.data.COL_EDIT7,'D')) {
								metaData.tdCls = 'x-change-cell_edit_x2';
								return Ext.util.Format.number(value,'0,000');
							} else{
								return Ext.util.Format.number(value,'0,000');
							}
						}
					},
					{dataIndex: 'ADD_TAX_I'				, width: 120,
						renderer: function(value, metaData, record) {
							if (UniUtils.indexOf(record.data.COL_EDIT8,'N')) {
								metaData.tdCls = 'x-change-cell_edit_x1';
								if(value == 0 ) {
									return '';
								} else{
									return Ext.util.Format.number(value,'0,000');
								}
							} else if(UniUtils.indexOf(record.data.COL_EDIT8,'D')) {
								metaData.tdCls = 'x-change-cell_edit_x2';
								return Ext.util.Format.number(value,'0,000');
							} else{
								return Ext.util.Format.number(value,'0,000');
							}
						}
					}
				]
			},
			{dataIndex: 'RET_IN_TAX_I'					, width: 120,
				renderer: function(value, metaData, record) {
					if (UniUtils.indexOf(record.data.COL_EDIT9,'N')) {
						metaData.tdCls = 'x-change-cell_edit_x1';
						if(value == 0 ) {
									return '';
								} else{
									return Ext.util.Format.number(value,'0,000');
								}
					} else if(UniUtils.indexOf(record.data.COL_EDIT9,'D')) {
						metaData.tdCls = 'x-change-cell_edit_x2';
						return Ext.util.Format.number(value,'0,000');
					} else{
						return Ext.util.Format.number(value,'0,000');
					}
				}
			},
			{dataIndex: 'IN_TAX_I'						, width: 120,
				renderer: function(value, metaData, record) {
					if (UniUtils.indexOf(record.data.COL_EDIT10,'N')) {
						metaData.tdCls = 'x-change-cell_edit_x1';
						if(value == 0 ) {
									return '';
								} else{
									return Ext.util.Format.number(value,'0,000');
								}
					} else if(UniUtils.indexOf(record.data.COL_EDIT10,'D')) {
						metaData.tdCls = 'x-change-cell_edit_x2';
						return Ext.util.Format.number(value,'0,000');
					} else{
						return Ext.util.Format.number(value,'0,000');
					}
				}
			},
			{dataIndex: 'SP_TAX_I'						, width: 120,
				renderer: function(value, metaData, record) {
					if (UniUtils.indexOf(record.data.COL_EDIT11,'N')) {
						metaData.tdCls = 'x-change-cell_edit_x1';
						if(value == 0 ) {
									return '';
								} else{
									return Ext.util.Format.number(value,'0,000');
								}
					} else if(UniUtils.indexOf(record.data.COL_EDIT11,'D')) {
						metaData.tdCls = 'x-change-cell_edit_x2';
						return Ext.util.Format.number(value,'0,000');
					} else{
						return Ext.util.Format.number(value,'0,000');
					}
				}
			},
			{dataIndex: 'STATE_TYPE'					, width: 80, hidden: true},
			{dataIndex: 'COMP_CODE'						, width: 6, hidden: true}
//			{dataIndex: 'COL_EDIT4'		, width: 80, hidden: true},
//			{dataIndex: 'COL_EDIT5'		, width: 80, hidden: true},
//			{dataIndex: 'COL_EDIT6'		, width: 80, hidden: true},
//			{dataIndex: 'COL_EDIT7'		, width: 80, hidden: true},
//			{dataIndex: 'COL_EDIT8'		, width: 80, hidden: true},
//			{dataIndex: 'COL_EDIT9'		, width: 80, hidden: true},
//			{dataIndex: 'COL_EDIT10'	, width: 80, hidden: true},
//			{dataIndex: 'COL_EDIT11'	, width: 80, hidden: true}
		],
		listeners: {
			beforeedit: function(editor, e, eOpts) {
				if(UniUtils.indexOf(e.field, ['INCOME_CNT'])) {
					if(Ext.isEmpty(e.record.data.COL_EDIT4)) {
						return true;
					} else{
						return false;
					}
				} else if(UniUtils.indexOf(e.field, ['INCOME_SUPP_TOTAL_I'])) {
					if(Ext.isEmpty(e.record.data.COL_EDIT5)) {
						return true;
					} else{
						return false;
					}
				} else if(UniUtils.indexOf(e.field, ['DEF_IN_TAX_I'])) {
					if(Ext.isEmpty(e.record.data.COL_EDIT6)) {
						return true;
					} else{
						return false;
					}
				} else if(UniUtils.indexOf(e.field, ['DEF_SP_TAX_I'])) {
					if(Ext.isEmpty(e.record.data.COL_EDIT7)) {
						return true;
					} else{
						return false;
					}
				} else if(UniUtils.indexOf(e.field, ['ADD_TAX_I'])) {
					if(Ext.isEmpty(e.record.data.COL_EDIT8)) {
						return true;
					} else{
						return false;
					}
				} else if(UniUtils.indexOf(e.field, ['RET_IN_TAX_I'])) {
					if(Ext.isEmpty(e.record.data.COL_EDIT9)) {
						return true;
					} else{
						return false;
					}
				} else if(UniUtils.indexOf(e.field, ['IN_TAX_I'])) {
					if(Ext.isEmpty(e.record.data.COL_EDIT10)) {
						return true;
					} else{
						return false;
					}
				} else if(UniUtils.indexOf(e.field, ['SP_TAX_I'])) {
					if(Ext.isEmpty(e.record.data.COL_EDIT11)) {
						return true;
					} else{
						return false;
					}
				} else{
					return false;
				}
			}
		}
	});		
	/** 부표자-비거주자
	 */	
	var detailGrid3 = Unilite.createGrid('hpc950ukrGrid3', {
		store	: detailStore3,
		layout	: 'fit',
		region	: 'center',
		flex	: 4,
		uniOpt	: {
			useMultipleSorting	: false,
			useLiveSearch		: false,
			onLoadSelectFirst	: true,
			dblClickToEdit		: true,
			useGroupSummary		: false,
			useContextMenu		: false,
			useRowNumberer		: true,
			expandLastColumn	: true,
			useRowContext		: false,
			filter				: {
				useFilter	: false,
				autoCreate	: false
			}
		},
		sortableColumns	: false,
		enableColumnHide: false,
		columns	: [
			{dataIndex: 'SECT_CODE'						, width: 133, hidden: true},
			{dataIndex: 'RPT_YYYYMM'				, width: 80, hidden: true},
			{dataIndex: 'PAY_YYYYMM'				, width: 80, hidden: true},
			{dataIndex: 'SUPP_YYYYMM'				, width: 80, hidden: true},
			{dataIndex: 'INCGUBN'						, width: 250},
			{dataIndex: 'INCCODE'						, width: 50 , align: 'center'},
			{text: '소득지급(과세미달,비과세포함)',
				columns: [
					{dataIndex: 'INCOME_CNT'			, width: 86,
						renderer: function(value, metaData, record) {
							if (UniUtils.indexOf(record.data.COL_EDIT4,'N')) {
								metaData.tdCls = 'x-change-cell_edit_x1';
								if(value == 0 ) {
									return '';
								} else{
									return Ext.util.Format.number(value,'0,000');
								}
							} else if(UniUtils.indexOf(record.data.COL_EDIT4,'D')) {
								metaData.tdCls = 'x-change-cell_edit_x2';
								return Ext.util.Format.number(value,'0,000');
							} else{
								return Ext.util.Format.number(value,'0,000');
							}
						}
					},
					{dataIndex: 'INCOME_SUPP_TOTAL_I'	, width: 120,
						renderer: function(value, metaData, record) {
							if (UniUtils.indexOf(record.data.COL_EDIT5,'N')) {
								metaData.tdCls = 'x-change-cell_edit_x1';
								if(value == 0 ) {
									return '';
								} else{
									return Ext.util.Format.number(value,'0,000');
								}
							} else if(UniUtils.indexOf(record.data.COL_EDIT5,'D')) {
								metaData.tdCls = 'x-change-cell_edit_x2';
								return Ext.util.Format.number(value,'0,000');
							} else{
								return Ext.util.Format.number(value,'0,000');
							}
						}
					}
				]
			},{text: '징수세액',
				columns: [
					{dataIndex: 'DEF_IN_TAX_I'			, width: 120,
						renderer: function(value, metaData, record) {
							if (UniUtils.indexOf(record.data.COL_EDIT6,'N')) {
								metaData.tdCls = 'x-change-cell_edit_x1';
								if(value == 0 ) {
									return '';
								} else{
									return Ext.util.Format.number(value,'0,000');
								}
							} else if(UniUtils.indexOf(record.data.COL_EDIT6,'D')) {
								metaData.tdCls = 'x-change-cell_edit_x2';
								return Ext.util.Format.number(value,'0,000');
							} else{
								return Ext.util.Format.number(value,'0,000');
							}
						}
					},
					{dataIndex: 'DEF_SP_TAX_I'			, width: 120,
						renderer: function(value, metaData, record) {
							if (UniUtils.indexOf(record.data.COL_EDIT7,'N')) {
								metaData.tdCls = 'x-change-cell_edit_x1';
								if(value == 0 ) {
									return '';
								} else{
									return Ext.util.Format.number(value,'0,000');
								}
							} else if(UniUtils.indexOf(record.data.COL_EDIT7,'D')) {
								metaData.tdCls = 'x-change-cell_edit_x2';
								return Ext.util.Format.number(value,'0,000');
							} else{
								return Ext.util.Format.number(value,'0,000');
							}
						}
					},
					{dataIndex: 'ADD_TAX_I'				, width: 120,
						renderer: function(value, metaData, record) {
							if (UniUtils.indexOf(record.data.COL_EDIT8,'N')) {
								metaData.tdCls = 'x-change-cell_edit_x1';
								if(value == 0 ) {
									return '';
								} else{
									return Ext.util.Format.number(value,'0,000');
								}
							} else if(UniUtils.indexOf(record.data.COL_EDIT8,'D')) {
								metaData.tdCls = 'x-change-cell_edit_x2';
								return Ext.util.Format.number(value,'0,000');
							} else{
								return Ext.util.Format.number(value,'0,000');
							}
						}
					}
				]
			},
			{dataIndex: 'RET_IN_TAX_I'					, width: 120,
				renderer: function(value, metaData, record) {
					if (UniUtils.indexOf(record.data.COL_EDIT9,'N')) {
						metaData.tdCls = 'x-change-cell_edit_x1';
						if(value == 0 ) {
									return '';
								} else{
									return Ext.util.Format.number(value,'0,000');
								}
					} else if(UniUtils.indexOf(record.data.COL_EDIT9,'D')) {
						metaData.tdCls = 'x-change-cell_edit_x2';
						return Ext.util.Format.number(value,'0,000');
					} else{
						return Ext.util.Format.number(value,'0,000');
					}
				}
			},
			{dataIndex: 'IN_TAX_I'						, width: 120,
				renderer: function(value, metaData, record) {
					if (UniUtils.indexOf(record.data.COL_EDIT10,'N')) {
						metaData.tdCls = 'x-change-cell_edit_x1';
						if(value == 0 ) {
									return '';
								} else{
									return Ext.util.Format.number(value,'0,000');
								}
					} else if(UniUtils.indexOf(record.data.COL_EDIT10,'D')) {
						metaData.tdCls = 'x-change-cell_edit_x2';
						return Ext.util.Format.number(value,'0,000');
					} else{
						return Ext.util.Format.number(value,'0,000');
					}
				}
			},
			{dataIndex: 'SP_TAX_I'						, width: 120,
				renderer: function(value, metaData, record) {
					if (UniUtils.indexOf(record.data.COL_EDIT11,'N')) {
						metaData.tdCls = 'x-change-cell_edit_x1';
						if(value == 0 ) {
									return '';
								} else{
									return Ext.util.Format.number(value,'0,000');
								}
					} else if(UniUtils.indexOf(record.data.COL_EDIT11,'D')) {
						metaData.tdCls = 'x-change-cell_edit_x2';
						return Ext.util.Format.number(value,'0,000');
					} else{
						return Ext.util.Format.number(value,'0,000');
					}
				}
			},
			{dataIndex: 'STATE_TYPE'					, width: 80, hidden: true},
			{dataIndex: 'COMP_CODE'						, width: 6, hidden: true}
//			{dataIndex: 'COL_EDIT4'		, width: 80},
//			{dataIndex: 'COL_EDIT5'		, width: 80},
//			{dataIndex: 'COL_EDIT6'		, width: 80},
//			{dataIndex: 'COL_EDIT7'		, width: 80},
//			{dataIndex: 'COL_EDIT8'		, width: 80},
//			{dataIndex: 'COL_EDIT9'		, width: 80},
//			{dataIndex: 'COL_EDIT10'	, width: 80},
//			{dataIndex: 'COL_EDIT11'	, width: 80}
		],
		listeners: {
			beforeedit: function(editor, e, eOpts) {
				if(UniUtils.indexOf(e.field, ['INCOME_CNT'])) {
					if(Ext.isEmpty(e.record.data.COL_EDIT4)) {
						return true;
					} else{
						return false;
					}
				} else if(UniUtils.indexOf(e.field, ['INCOME_SUPP_TOTAL_I'])) {
					if(Ext.isEmpty(e.record.data.COL_EDIT5)) {
						return true;
					} else{
						return false;
					}
				} else if(UniUtils.indexOf(e.field, ['DEF_IN_TAX_I'])) {
					if(Ext.isEmpty(e.record.data.COL_EDIT6)) {
						return true;
					} else{
						return false;
					}
				} else if(UniUtils.indexOf(e.field, ['DEF_SP_TAX_I'])) {
					if(Ext.isEmpty(e.record.data.COL_EDIT7)) {
						return true;
					} else{
						return false;
					}
				} else if(UniUtils.indexOf(e.field, ['ADD_TAX_I'])) {
					if(Ext.isEmpty(e.record.data.COL_EDIT8)) {
						return true;
					} else{
						return false;
					}
				} else if(UniUtils.indexOf(e.field, ['RET_IN_TAX_I'])) {
					if(Ext.isEmpty(e.record.data.COL_EDIT9)) {
						return true;
					} else{
						return false;
					}
				} else if(UniUtils.indexOf(e.field, ['IN_TAX_I'])) {
					if(Ext.isEmpty(e.record.data.COL_EDIT10)) {
						return true;
					} else{
						return false;
					}
				} else if(UniUtils.indexOf(e.field, ['SP_TAX_I'])) {
					if(Ext.isEmpty(e.record.data.COL_EDIT11)) {
						return true;
					} else{
						return false;
					}
				} else{
					return false;
				}
			}
		}
	});
	/** 부표자-법인원천
	 */
	var detailGrid4 = Unilite.createGrid('hpc950ukrGrid4', {
		store	: detailStore4,
		layout	: 'fit',
		region	: 'center',
		flex	: 4,
		uniOpt	: {
			useMultipleSorting	: false,
			useLiveSearch		: false,
			onLoadSelectFirst	: true,
			dblClickToEdit		: true,
			useGroupSummary		: false,
			useContextMenu		: false,
			useRowNumberer		: true,
			expandLastColumn	: true,
			useRowContext		: false,
			filter				: {
				useFilter	: false,
				autoCreate	: false
			}
		},			
		sortableColumns	: false,
		enableColumnHide: false,
		columns	: [
			{dataIndex: 'SECT_CODE'						, width: 133, hidden: true},
			{dataIndex: 'RPT_YYYYMM'				, width: 80, hidden: true},
			{dataIndex: 'PAY_YYYYMM'				, width: 80, hidden: true},
			{dataIndex: 'SUPP_YYYYMM'				, width: 80, hidden: true},
			{dataIndex: 'INCGUBN'						, width: 250},
			{dataIndex: 'INCCODE'						, width: 50 , align: 'center'},
			{text: '소득지급(과세미달,비과세포함)',
				columns: [
					{dataIndex: 'INCOME_CNT'			, width: 86,
						renderer: function(value, metaData, record) {
							if (UniUtils.indexOf(record.data.COL_EDIT4,'N')) {
								metaData.tdCls = 'x-change-cell_edit_x1';
								if(value == 0 ) {
									return '';
								} else{
									return Ext.util.Format.number(value,'0,000');
								}
							} else if(UniUtils.indexOf(record.data.COL_EDIT4,'D')) {
								metaData.tdCls = 'x-change-cell_edit_x2';
								return Ext.util.Format.number(value,'0,000');
							} else{
								return Ext.util.Format.number(value,'0,000');
							}
						}
					},
					{dataIndex: 'INCOME_SUPP_TOTAL_I'	, width: 120,
						renderer: function(value, metaData, record) {
							if (UniUtils.indexOf(record.data.COL_EDIT5,'N')) {
								metaData.tdCls = 'x-change-cell_edit_x1';
								if(value == 0 ) {
									return '';
								} else{
									return Ext.util.Format.number(value,'0,000');
								}
							} else if(UniUtils.indexOf(record.data.COL_EDIT5,'D')) {
								metaData.tdCls = 'x-change-cell_edit_x2';
								return Ext.util.Format.number(value,'0,000');
							} else{
								return Ext.util.Format.number(value,'0,000');
							}
						}
					}
				]
			},
			{text: '징수세액',
				columns: [
					{dataIndex: 'DEF_IN_TAX_I'			, width: 120,
						renderer: function(value, metaData, record) {
							if (UniUtils.indexOf(record.data.COL_EDIT6,'N')) {
								metaData.tdCls = 'x-change-cell_edit_x1';
								if(value == 0 ) {
									return '';
								} else{
									return Ext.util.Format.number(value,'0,000');
								}
							} else if(UniUtils.indexOf(record.data.COL_EDIT6,'D')) {
								metaData.tdCls = 'x-change-cell_edit_x2';
								return Ext.util.Format.number(value,'0,000');
							} else{
								return Ext.util.Format.number(value,'0,000');
							}
						}
					},
					{dataIndex: 'DEF_SP_TAX_I'			, width: 120,
						renderer: function(value, metaData, record) {
							if (UniUtils.indexOf(record.data.COL_EDIT7,'N')) {
								metaData.tdCls = 'x-change-cell_edit_x1';
								if(value == 0 ) {
									return '';
								} else{
									return Ext.util.Format.number(value,'0,000');
								}
							} else if(UniUtils.indexOf(record.data.COL_EDIT7,'D')) {
								metaData.tdCls = 'x-change-cell_edit_x2';
								return Ext.util.Format.number(value,'0,000');
							} else{
								return Ext.util.Format.number(value,'0,000');
							}
						}
					},
					{dataIndex: 'ADD_TAX_I'				, width: 120,
						renderer: function(value, metaData, record) {
							if (UniUtils.indexOf(record.data.COL_EDIT8,'N')) {
								metaData.tdCls = 'x-change-cell_edit_x1';
								if(value == 0 ) {
									return '';
								} else{
									return Ext.util.Format.number(value,'0,000');
								}
							} else if(UniUtils.indexOf(record.data.COL_EDIT8,'D')) {
								metaData.tdCls = 'x-change-cell_edit_x2';
								return Ext.util.Format.number(value,'0,000');
							} else{
								return Ext.util.Format.number(value,'0,000');
							}
						}
					}
				]
			},
			{dataIndex: 'RET_IN_TAX_I'					, width: 120,
				renderer: function(value, metaData, record) {
					if (UniUtils.indexOf(record.data.COL_EDIT9,'N')) {
						metaData.tdCls = 'x-change-cell_edit_x1';
						if(value == 0 ) {
									return '';
								} else{
									return Ext.util.Format.number(value,'0,000');
								}
					} else if(UniUtils.indexOf(record.data.COL_EDIT9,'D')) {
						metaData.tdCls = 'x-change-cell_edit_x2';
						return Ext.util.Format.number(value,'0,000');
					} else{
						return Ext.util.Format.number(value,'0,000');
					}
				}
			},
			{dataIndex: 'IN_TAX_I'						, width: 120,
				renderer: function(value, metaData, record) {
					if (UniUtils.indexOf(record.data.COL_EDIT10,'N')) {
						metaData.tdCls = 'x-change-cell_edit_x1';
						if(value == 0 ) {
									return '';
								} else{
									return Ext.util.Format.number(value,'0,000');
								}
					} else if(UniUtils.indexOf(record.data.COL_EDIT10,'D')) {
						metaData.tdCls = 'x-change-cell_edit_x2';
						return Ext.util.Format.number(value,'0,000');
					} else{
						return Ext.util.Format.number(value,'0,000');
					}
				}
			},
			{dataIndex: 'SP_TAX_I'						, width: 120,
				renderer: function(value, metaData, record) {
					if (UniUtils.indexOf(record.data.COL_EDIT11,'N')) {
						metaData.tdCls = 'x-change-cell_edit_x1';
						if(value == 0 ) {
									return '';
								} else{
									return Ext.util.Format.number(value,'0,000');
								}
					} else if(UniUtils.indexOf(record.data.COL_EDIT11,'D')) {
						metaData.tdCls = 'x-change-cell_edit_x2';
						return Ext.util.Format.number(value,'0,000');
					} else{
						return Ext.util.Format.number(value,'0,000');
					}
				}
			},
			{dataIndex: 'STATE_TYPE'					, width: 80, hidden: true},
			{dataIndex: 'COMP_CODE'						, width: 6, hidden: true}
			

//			{dataIndex: 'COL_EDIT4'		, width: 80},
//			{dataIndex: 'COL_EDIT5'		, width: 80},
//			{dataIndex: 'COL_EDIT6'		, width: 80},
//			{dataIndex: 'COL_EDIT7'		, width: 80},
//			{dataIndex: 'COL_EDIT8'		, width: 80},
//			{dataIndex: 'COL_EDIT9'		, width: 80},
//			{dataIndex: 'COL_EDIT10'	, width: 80},
//			{dataIndex: 'COL_EDIT11'	, width: 80}
		],
		listeners: {
			beforeedit: function(editor, e, eOpts) {
				if(UniUtils.indexOf(e.field, ['INCOME_CNT'])) {
					if(Ext.isEmpty(e.record.data.COL_EDIT4)) {
						return true;
					} else{
						return false;
					}
				} else if(UniUtils.indexOf(e.field, ['INCOME_SUPP_TOTAL_I'])) {
					if(Ext.isEmpty(e.record.data.COL_EDIT5)) {
						return true;
					} else{
						return false;
					}
				} else if(UniUtils.indexOf(e.field, ['DEF_IN_TAX_I'])) {
					if(Ext.isEmpty(e.record.data.COL_EDIT6)) {
						return true;
					} else{
						return false;
					}
				} else if(UniUtils.indexOf(e.field, ['DEF_SP_TAX_I'])) {
					if(Ext.isEmpty(e.record.data.COL_EDIT7)) {
						return true;
					} else{
						return false;
					}
				} else if(UniUtils.indexOf(e.field, ['ADD_TAX_I'])) {
					if(Ext.isEmpty(e.record.data.COL_EDIT8)) {
						return true;
					} else{
						return false;
					}
				} else if(UniUtils.indexOf(e.field, ['RET_IN_TAX_I'])) {
					if(Ext.isEmpty(e.record.data.COL_EDIT9)) {
						return true;
					} else{
						return false;
					}
				} else if(UniUtils.indexOf(e.field, ['IN_TAX_I'])) {
					if(Ext.isEmpty(e.record.data.COL_EDIT10)) {
						return true;
					} else{
						return false;
					}
				} else if(UniUtils.indexOf(e.field, ['SP_TAX_I'])) {
					if(Ext.isEmpty(e.record.data.COL_EDIT11)) {
						return true;
					} else{
						return false;
					}
				} else{
					return false;
				}
			}
		}
	});  



	var tab = Unilite.createTabPanel('tabPanel',{
		activeTab	: 0,
		region		: 'center',
		items		: [{
			title	: '원천징수내역',
			xtype	: 'container',
			layout	: {type:'vbox', align:'stretch'},
			items	: [detailGrid1,detailGrid1_2],
			id		: 'hpa990tab1'
		},{
			title	: '부표-거주자',
			xtype	: 'container',
			layout	: {type:'vbox', align:'stretch'},
			items	: [detailGrid2],
			id		: 'hpa990tab2'
		},{
			title	: '부표-비거주자',
			xtype	: 'container',
			layout	: {type:'vbox', align:'stretch'},
			items	: [detailGrid3],
			id		: 'hpa990tab3'
		},{
			title	: '부표-법인원천',
			xtype	: 'container',
			layout	: {type:'vbox', align:'stretch'},
			items	: [detailGrid4],
			id		: 'hpa990tab4'
		}],
		listeners : {
			beforetabchange : function ( tabPanel, newCard, oldCard, eOpts ) {
				if(!panelSearch.getInvalidMessage()) return false;   // 필수체크
				if(oldCard.getId() == 'hpa990tab1') {
					if(oldCard.down().getStore().getCount() < 1) {
						alert('원천징수내역 조회후 진행해 주십시오. 만약 원천징수내역이 없다면 신고자료생성을 먼저 진행해 주십시오.');
						return false;
					}
				}
// 				if(oldCard.down().getStore().isDirty()) {
// 					alert('변경사항이 있습니다. 저장을 먼저 진행해주십시오.');
// 					return false;
// 				}
			},
			tabChange : function ( tabPanel, newCard, oldCard, eOpts ) {
				//UniAppManager.setToolbarButtons('deleteAll',false);
				//UniAppManager.app.onQueryButtonDown();
			}
		}
	});



	Unilite.Main({
		id			: 'hpc950ukrApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			id		: 'pageAll',
			items	: [
				panelSearch, tab
			]
		}],
		fnInitBinding : function(param) {
			panelSearch.setValue("DIV_CODE"		, UserInfo.divCode);
			panelSearch.setValue('RPT_YYYYMM'	, UniDate.get('today'));
			if(gsPayDateOpt == '2')	{ // 1:귀속연월,지급연월 동일/ 2:귀속연월,지급연월+1
				panelSearch.setValue('PAY_YYYYMM'   , UniDate.add(UniDate.today(), {'months' : -2}));
				panelSearch.setValue('SUPP_YYYYMM'  , UniDate.add(UniDate.today(), {'months' : -1}));
			} else {
				panelSearch.setValue('PAY_YYYYMM'   , UniDate.add(UniDate.today(), {'months' : -1}));
				panelSearch.setValue('SUPP_YYYYMM'  , UniDate.add(UniDate.today(), {'months' : -1}));
			}
			panelSearch.setValue("STATE_TYPE"	, "0");
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			detailGrid1.reset();
			detailStore1.clearData();
			detailGrid1_2.reset();
			detailStore1_2.clearData();
			detailGrid2.reset();
			detailStore2.clearData();
			detailGrid3.reset();
			detailStore3.clearData();
			detailGrid4.reset();
			detailStore4.clearData();
			this.fnInitInputFields();
			tab.setActiveTab(tab.down('#hpa990tab1'));
		},
		onQueryButtonDown : function() {
			if(!panelSearch.getInvalidMessage()) return;   // 필수체크
			detailStore1.loadStoreRecords();
		},
		onSaveDataButtonDown: function(config) {
			detailStore1.saveAllData();
		},
		onDeleteAllButtonDown: function() {
			if(confirm("전체 삭제 하시겠습니까?")) {
				var param = panelSearch.getValues();
				hpc950ukrService.deleteList(param, function(provider, response) {
					if(provider) {
						UniAppManager.updateStatus('삭제 되었습니다.');
						UniAppManager.app.onResetButtonDown();
					}
				});
			}
		},
		fnInitInputFields: function() {
			panelSearch.setValue("DIV_CODE"		, UserInfo.divCode);
			panelSearch.setValue('RPT_YYYYMM'	, UniDate.get('today'));
			if(gsPayDateOpt == '2')	{ // 1:귀속연월,지급연월 동일/ 2:귀속연월,지급연월+1
				panelSearch.setValue('PAY_YYYYMM'   , UniDate.add(UniDate.today(), {'months' : -2}));
				panelSearch.setValue('SUPP_YYYYMM'  , UniDate.add(UniDate.today(), {'months' : -1}));
			} else {
				panelSearch.setValue('PAY_YYYYMM'   , UniDate.add(UniDate.today(), {'months' : -1}));
				panelSearch.setValue('SUPP_YYYYMM'  , UniDate.add(UniDate.today(), {'months' : -1}));
			}
			panelSearch.setValue("STATE_TYPE"	, "0");
			panelSearch.setDisableFields(false);
			UniAppManager.setToolbarButtons(['query','reset'], true);
			UniAppManager.setToolbarButtons(['newData','delete','save','deleteAll','print'], false);
		},
		/**
		 * 그리드 합계관련 함수
		 */
		fnSubCalc: function(recordAll,a10YN_Sub,a20YN_Sub,a30YN_Sub,a40YN_Sub,a47YN_Sub,a50YN_Sub,a60YN_Sub,a69YN_Sub,a70YN_Sub,a80YN_Sub ) {	//(환급받을금액이(-금액이) 소진되었을시)   6.소득세등, 7.농어촌특별세, 8.가산세, 9.당월조정환급세액, 10.소득세등(가산세포함), 11.농어촌특별세   들의 연관관계 계산 로직 관련
			Ext.each(recordAll,function (rec, i) {
				var defInTaxIPl	= 0;
				var defSpTaxIPl	= 0;
				var addTaxIPl	= 0;
				defInTaxIPl		= Ext.isEmpty(rec.get('DEF_IN_TAX_I')) ? 0 : rec.get('DEF_IN_TAX_I') < 0 ? 0 : rec.get('DEF_IN_TAX_I');
				defSpTaxIPl		= Ext.isEmpty(rec.get('DEF_SP_TAX_I')) ? 0 : rec.get('DEF_SP_TAX_I') < 0 ? 0 : rec.get('DEF_SP_TAX_I');
				addTaxIPl		= Ext.isEmpty(rec.get('ADD_TAX_I')) ? 0 : rec.get('ADD_TAX_I') < 0 ? 0 : rec.get('ADD_TAX_I');
	
				//국세청양식에 따라 사용하는필드가 다르기 때문에 각각 조건별로 나눔
				if(rec.get('INCCODE') == 'A10' && a10YN_Sub == 'N') {
					rec.set('RET_IN_TAX_I',0);			//9.당월조정환급세액	0
					rec.set('IN_TAX_I',defInTaxIPl + addTaxIPl);	//10.소득세 등(가산세포함)	 = 6.소득세등 + 8.가산세
					rec.set('SP_TAX_I',defSpTaxIPl);				//11.농어촌특별세 = 7.농어촌특별세
					
				} else if(rec.get('INCCODE') == 'A20' && a20YN_Sub == 'N') {
					rec.set('RET_IN_TAX_I',0);			//9.당월조정환급세액	0
					rec.set('IN_TAX_I',defInTaxIPl + addTaxIPl);	//10.소득세 등(가산세포함)	 = 6.소득세등 + 8.가산세
					
				} else if(rec.get('INCCODE') == 'A30' && a30YN_Sub == 'N') {
					rec.set('RET_IN_TAX_I',0);			//9.당월조정환급세액	0
					rec.set('IN_TAX_I',defInTaxIPl + addTaxIPl);	//10.소득세 등(가산세포함)	 = 6.소득세등 + 8.가산세
					rec.set('SP_TAX_I',defSpTaxIPl);				//11.농어촌특별세 = 7.농어촌특별세
				} else if(rec.get('INCCODE') == 'A40' && a40YN_Sub == 'N') {
					rec.set('RET_IN_TAX_I',0);			//9.당월조정환급세액	0
					rec.set('IN_TAX_I',defInTaxIPl + addTaxIPl);	//10.소득세 등(가산세포함)	 = 6.소득세등 + 8.가산세
					
				} else if(rec.get('INCCODE') == 'A47' && a47YN_Sub == 'N') {
					rec.set('RET_IN_TAX_I',0);			//9.당월조정환급세액	0
					rec.set('IN_TAX_I',defInTaxIPl + addTaxIPl);	//10.소득세 등(가산세포함)	 = 6.소득세등 + 8.가산세
					
				} else if(rec.get('INCCODE') == 'A50' && a50YN_Sub == 'N') {
					rec.set('RET_IN_TAX_I',0);			//9.당월조정환급세액	0
					rec.set('IN_TAX_I',defInTaxIPl + addTaxIPl);	//10.소득세 등(가산세포함)	 = 6.소득세등 + 8.가산세
					rec.set('SP_TAX_I',defSpTaxIPl);				//11.농어촌특별세 = 7.농어촌특별세
					
				} else if(rec.get('INCCODE') == 'A60' && a60YN_Sub == 'N') {
					rec.set('RET_IN_TAX_I',0);			//9.당월조정환급세액	0
					rec.set('IN_TAX_I',defInTaxIPl + addTaxIPl);	//10.소득세 등(가산세포함)	 = 6.소득세등 + 8.가산세
					rec.set('SP_TAX_I',defSpTaxIPl);				//11.농어촌특별세 = 7.농어촌특별세
					
				} else if(rec.get('INCCODE') == 'A69' && a69YN_Sub == 'N') {
					rec.set('RET_IN_TAX_I',0);			//9.당월조정환급세액	0
					rec.set('IN_TAX_I',defInTaxIPl + addTaxIPl);	//10.소득세 등(가산세포함)	 = 6.소득세등 + 8.가산세
					
				} else if(rec.get('INCCODE') == 'A70' && a70YN_Sub == 'N') {
					rec.set('RET_IN_TAX_I',0);			//9.당월조정환급세액	0
					rec.set('IN_TAX_I',defInTaxIPl + addTaxIPl);	//10.소득세 등(가산세포함)	 = 6.소득세등 + 8.가산세
					
				} else if(rec.get('INCCODE') == 'A80' && a80YN_Sub == 'N') {
					rec.set('RET_IN_TAX_I',0);			//9.당월조정환급세액	0
					rec.set('IN_TAX_I',defInTaxIPl + addTaxIPl);	//10.소득세 등(가산세포함)	 = 6.소득세등 + 8.가산세
				}
			});
		},
		fnCalc: function(recordAll, editColumn, currRecord, newValue) {		//원천징수내역 관련
			if(editColumn == "INCOME_CNT") {		//4.인원
				var incomeCntSum_10 = 0;
				var incomeCntSum_20 = 0;
				var incomeCntSum_30 = 0;
				var incomeCntSum_40 = 0;
				var incomeCntSum_47 = 0;

				Ext.each(recordAll,function (rec, i) {
					if(rec.get('INCCODE') == 'A01'||rec.get('INCCODE') == 'A02'||rec.get('INCCODE') == 'A03'||rec.get('INCCODE') == 'A04') {
						incomeCntSum_10 = incomeCntSum_10 + rec.get('INCOME_CNT');
						
					} else if(rec.get('INCCODE') == 'A21'||rec.get('INCCODE') == 'A22') {
						incomeCntSum_20 = incomeCntSum_20 + rec.get('INCOME_CNT');
						
					} else if(rec.get('INCCODE') == 'A25'||rec.get('INCCODE') == 'A26') {
						incomeCntSum_30 = incomeCntSum_30 + rec.get('INCOME_CNT');
						
					} else if(rec.get('INCCODE') == 'A41'||rec.get('INCCODE') == 'A42') {
						incomeCntSum_40 = incomeCntSum_40 + rec.get('INCOME_CNT');
						
					} else if(rec.get('INCCODE') == 'A48'||rec.get('INCCODE') == 'A45'||rec.get('INCCODE') == 'A46') {
						incomeCntSum_47 = incomeCntSum_47 + rec.get('INCOME_CNT');
						
					}
				});

				Ext.each(recordAll,function (rec, i) {
					if(rec.get('INCCODE') == 'A10') {
						rec.set('INCOME_CNT',incomeCntSum_10);
					} else if(rec.get('INCCODE') == 'A20') {
						rec.set('INCOME_CNT',incomeCntSum_20);
					} else if(rec.get('INCCODE') == 'A30') {
						rec.set('INCOME_CNT',incomeCntSum_30);
					} else if(rec.get('INCCODE') == 'A40') {
						rec.set('INCOME_CNT',incomeCntSum_40);
					} else if(rec.get('INCCODE') == 'A47') {
						rec.set('INCOME_CNT',incomeCntSum_47);
					}
				});
			} else if(editColumn == "INCOME_SUPP_TOTAL_I") {	//5.총지급액
				var incomeSuppTotalSum_10 = 0;
				var incomeSuppTotalSum_20 = 0;
				var incomeSuppTotalSum_30 = 0;
				var incomeSuppTotalSum_40 = 0;
				var incomeSuppTotalSum_47 = 0;

				Ext.each(recordAll,function (rec, i) {
					if(rec.get('INCCODE') == 'A01'||rec.get('INCCODE') == 'A02'||rec.get('INCCODE') == 'A03'||rec.get('INCCODE') == 'A04') {
						incomeSuppTotalSum_10 = incomeSuppTotalSum_10 + rec.get('INCOME_SUPP_TOTAL_I');
						
					} else if(rec.get('INCCODE') == 'A21'||rec.get('INCCODE') == 'A22') {
						incomeSuppTotalSum_20 = incomeSuppTotalSum_20 + rec.get('INCOME_SUPP_TOTAL_I');
						
					} else if(rec.get('INCCODE') == 'A25'||rec.get('INCCODE') == 'A26') {
						incomeSuppTotalSum_30 = incomeSuppTotalSum_30 + rec.get('INCOME_SUPP_TOTAL_I');
						
					} else if(rec.get('INCCODE') == 'A41'||rec.get('INCCODE') == 'A42') {
						incomeSuppTotalSum_40 = incomeSuppTotalSum_40 + rec.get('INCOME_SUPP_TOTAL_I');
						
					} else if(rec.get('INCCODE') == 'A48'||rec.get('INCCODE') == 'A45'||rec.get('INCCODE') == 'A46') {
						incomeSuppTotalSum_47 = incomeSuppTotalSum_47 + rec.get('INCOME_SUPP_TOTAL_I');
						
					}
				});

				Ext.each(recordAll,function (rec, i) {
					if(rec.get('INCCODE') == 'A10') {
						rec.set('INCOME_SUPP_TOTAL_I',incomeSuppTotalSum_10);
					} else if(rec.get('INCCODE') == 'A20') {
						rec.set('INCOME_SUPP_TOTAL_I',incomeSuppTotalSum_20);
					} else if(rec.get('INCCODE') == 'A30') {
						rec.set('INCOME_SUPP_TOTAL_I',incomeSuppTotalSum_30);
					} else if(rec.get('INCCODE') == 'A40') {
						rec.set('INCOME_SUPP_TOTAL_I',incomeSuppTotalSum_40);
					} else if(rec.get('INCCODE') == 'A47') {
						rec.set('INCOME_SUPP_TOTAL_I',incomeSuppTotalSum_47);
					}
				});
			} else if(editColumn == "DEF_IN_TAX_I") {		//6.소득세 등
				// A04, A05, A06 수정시  1----
				var defInTaxIA04 = 0 ;
				var defInTaxIA05 = 0 ;
				var defInTaxIA06 = 0 ;

				if(currRecord.get('INCCODE') == 'A04' || currRecord.get('INCCODE') == 'A05' || currRecord.get('INCCODE') == 'A06') {
					Ext.each(recordAll,function (rec, i) {
						
						if(rec.get('INCCODE') == 'A04') {
							defInTaxIA04 = rec.get('DEF_IN_TAX_I');
						} else if(rec.get('INCCODE') == 'A05') {
							defInTaxIA05 = rec.get('DEF_IN_TAX_I');
						} else if(rec.get('INCCODE') == 'A06') {
							defInTaxIA06 = rec.get('DEF_IN_TAX_I');
						}
					});
				}
				if(currRecord.get('INCCODE') == 'A04') {
					
					Ext.each(recordAll,function (rec, i) {
						if(rec.get('INCCODE') == 'A06') {
							rec.set('DEF_IN_TAX_I',newValue - defInTaxIA05);
						}
					});
					
				} else if(currRecord.get('INCCODE') == 'A05') {
					Ext.each(recordAll,function (rec, i) {
						if(rec.get('INCCODE') == 'A04') {
							rec.set('DEF_IN_TAX_I',newValue + defInTaxIA06);
						}
					});
				} else if(currRecord.get('INCCODE') == 'A06') {
					Ext.each(recordAll,function (rec, i) {
						if(rec.get('INCCODE') == 'A04') {
							rec.set('DEF_IN_TAX_I',newValue + defInTaxIA05);
						}
					});
				}
				//----1
				var defInTaxISum_10 = 0;
				var defInTaxISum_20 = 0;
				var defInTaxISum_30 = 0;
				var defInTaxISum_40 = 0;
				var defInTaxISum_47 = 0;

				Ext.each(recordAll,function (rec, i) {
					if(rec.get('INCCODE') == 'A01'||rec.get('INCCODE') == 'A02'||rec.get('INCCODE') == 'A03'||rec.get('INCCODE') == 'A06') {
						defInTaxISum_10 = defInTaxISum_10 + parseInt(rec.get('DEF_IN_TAX_I'));
						
					} else if(rec.get('INCCODE') == 'A21'||rec.get('INCCODE') == 'A22') {
						defInTaxISum_20 = defInTaxISum_20 + parseInt(rec.get('DEF_IN_TAX_I'));
						
					} else if(rec.get('INCCODE') == 'A25'||rec.get('INCCODE') == 'A26') {
						defInTaxISum_30 = defInTaxISum_30 + parseInt(rec.get('DEF_IN_TAX_I'));
						
					} else if(rec.get('INCCODE') == 'A41'||rec.get('INCCODE') == 'A42') {
						defInTaxISum_40 = defInTaxISum_40 + parseInt(rec.get('DEF_IN_TAX_I'));
						
					} else if(rec.get('INCCODE') == 'A48'||rec.get('INCCODE') == 'A45'||rec.get('INCCODE') == 'A46') {
						defInTaxISum_47 = defInTaxISum_47 + parseInt(rec.get('DEF_IN_TAX_I'));
					}
				});

				Ext.each(recordAll,function (rec, i) {
					if(rec.get('INCCODE') == 'A10') {
						rec.set('DEF_IN_TAX_I',defInTaxISum_10);
					} else if(rec.get('INCCODE') == 'A20') {
						rec.set('DEF_IN_TAX_I',defInTaxISum_20);
					} else if(rec.get('INCCODE') == 'A30') {
						rec.set('DEF_IN_TAX_I',defInTaxISum_30);
					} else if(rec.get('INCCODE') == 'A40') {
						rec.set('DEF_IN_TAX_I',defInTaxISum_40);
					} else if(rec.get('INCCODE') == 'A47') {
						rec.set('DEF_IN_TAX_I',defInTaxISum_47);
					}
				});
				UniAppManager.app.fnCalcRefunds(recordAll);
				
			} else if(editColumn == "DEF_SP_TAX_I") {		//7.농어촌특별세
				// A04, A05, A06 수정시  1----
				var defSpTaxIA04 = 0 ;
				var defSpTaxIA05 = 0 ;
				var defSpTaxIA06 = 0 ;

				if(currRecord.get('INCCODE') == 'A04' || currRecord.get('INCCODE') == 'A05' || currRecord.get('INCCODE') == 'A06') {
					Ext.each(recordAll,function (rec, i) {
						if(rec.get('INCCODE') == 'A04') {
							defSpTaxIA04 = rec.get('DEF_SP_TAX_I');
						} else if(rec.get('INCCODE') == 'A05') {
							defSpTaxIA05 = rec.get('DEF_SP_TAX_I');
						} else if(rec.get('INCCODE') == 'A06') {
							defSpTaxIA06 = rec.get('DEF_SP_TAX_I');
						}
					});
				}
				if(currRecord.get('INCCODE') == 'A04') {
					Ext.each(recordAll,function (rec, i) {
						if(rec.get('INCCODE') == 'A06') {
							rec.set('DEF_SP_TAX_I',newValue - defSpTaxIA05);
						}
					});
				} else if(currRecord.get('INCCODE') == 'A05') {
					Ext.each(recordAll,function (rec, i) {
						if(rec.get('INCCODE') == 'A04') {
							rec.set('DEF_SP_TAX_I',newValue + defSpTaxIA06);
						}
					});
				} else if(currRecord.get('INCCODE') == 'A06') {
					Ext.each(recordAll,function (rec, i) {
						if(rec.get('INCCODE') == 'A04') {
							rec.set('DEF_SP_TAX_I',newValue + defSpTaxIA05);
						}
					});
				}
				//----1
				var defSpTaxISum_10 = 0;
				var defSpTaxISum_20 = 0;
				var defSpTaxISum_30 = 0;
				var defSpTaxISum_40 = 0;
				var defSpTaxISum_47 = 0;

				Ext.each(recordAll,function (rec, i) {
					if(rec.get('INCCODE') == 'A01'||rec.get('INCCODE') == 'A02'||rec.get('INCCODE') == 'A06') {
						defSpTaxISum_10 = defSpTaxISum_10 + parseInt(rec.get('DEF_SP_TAX_I'));
						
					} else if(rec.get('INCCODE') == 'A21'||rec.get('INCCODE') == 'A22') {
						defSpTaxISum_20 = defSpTaxISum_20 + parseInt(rec.get('DEF_SP_TAX_I'));
						
					} else if(rec.get('INCCODE') == 'A25'||rec.get('INCCODE') == 'A26') {
						defSpTaxISum_30 = defSpTaxISum_30 + parseInt(rec.get('DEF_SP_TAX_I'));
						
					} else if(rec.get('INCCODE') == 'A41'||rec.get('INCCODE') == 'A42') {
						defSpTaxISum_40 = defSpTaxISum_40 + parseInt(rec.get('DEF_SP_TAX_I'));
						
					} else if(rec.get('INCCODE') == 'A48'||rec.get('INCCODE') == 'A45'||rec.get('INCCODE') == 'A46') {
						defSpTaxISum_47 = defSpTaxISum_47 + parseInt(rec.get('DEF_SP_TAX_I'));
						
					}
				});

				Ext.each(recordAll,function (rec, i) {
					if(rec.get('INCCODE') == 'A10') {
						rec.set('DEF_SP_TAX_I',defSpTaxISum_10);
					} else if(rec.get('INCCODE') == 'A20') {
						rec.set('DEF_SP_TAX_I',defSpTaxISum_20);
					} else if(rec.get('INCCODE') == 'A30') {
						rec.set('DEF_SP_TAX_I',defSpTaxISum_30);
					} else if(rec.get('INCCODE') == 'A40') {
						rec.set('DEF_SP_TAX_I',defSpTaxISum_40);
					} else if(rec.get('INCCODE') == 'A47') {
						rec.set('DEF_SP_TAX_I',defSpTaxISum_47);
					}
				});
				UniAppManager.app.fnCalcRefunds(recordAll);

			} else if(editColumn == "ADD_TAX_I") {		//8.가산세
				// A04, A05, A06 수정시  1----
				var addTaxIA04 = 0 ;
				var addTaxIA05 = 0 ;
				var addTaxIA06 = 0 ;

				if(currRecord.get('INCCODE') == 'A04' || currRecord.get('INCCODE') == 'A05' || currRecord.get('INCCODE') == 'A06') {
					Ext.each(recordAll,function (rec, i) {
						if(rec.get('INCCODE') == 'A04') {
							addTaxIA04 = rec.get('ADD_TAX_I');
						} else if(rec.get('INCCODE') == 'A05') {
							addTaxIA05 = rec.get('ADD_TAX_I');
						} else if(rec.get('INCCODE') == 'A06') {
							addTaxIA06 = rec.get('ADD_TAX_I');
						}
					});
				}
				if(currRecord.get('INCCODE') == 'A04') {
					Ext.each(recordAll,function (rec, i) {
						if(rec.get('INCCODE') == 'A06') {
							rec.set('ADD_TAX_I',newValue - addTaxIA05);
						}
					});
				} else if(currRecord.get('INCCODE') == 'A05') {
					Ext.each(recordAll,function (rec, i) {
						if(rec.get('INCCODE') == 'A04') {
							rec.set('ADD_TAX_I',newValue + addTaxIA06);
						}
					});
				} else if(currRecord.get('INCCODE') == 'A06') {
					Ext.each(recordAll,function (rec, i) {
						if(rec.get('INCCODE') == 'A04') {
							rec.set('ADD_TAX_I',newValue + addTaxIA06);
						}
					});
				}
				//----1
				var addTaxISum_10 = 0;
				var addTaxISum_20 = 0;
				var addTaxISum_30 = 0;
				var addTaxISum_40 = 0;
				var addTaxISum_47 = 0;

				Ext.each(recordAll,function (rec, i) {
					if(rec.get('INCCODE') == 'A01'||rec.get('INCCODE') == 'A02'||rec.get('INCCODE') == 'A03'||rec.get('INCCODE') == 'A06') {
						addTaxISum_10 = addTaxISum_10 + rec.get('ADD_TAX_I');
						
					} else if(rec.get('INCCODE') == 'A21'||rec.get('INCCODE') == 'A22') {
						addTaxISum_20 = addTaxISum_20 + rec.get('ADD_TAX_I');
						
					} else if(rec.get('INCCODE') == 'A25'||rec.get('INCCODE') == 'A26') {
						addTaxISum_30 = addTaxISum_30 + rec.get('ADD_TAX_I');
						
					} else if(rec.get('INCCODE') == 'A41'||rec.get('INCCODE') == 'A42') {
						addTaxISum_40 = addTaxISum_40 + rec.get('ADD_TAX_I');
						
					} else if(rec.get('INCCODE') == 'A48'||rec.get('INCCODE') == 'A45'||rec.get('INCCODE') == 'A46') {
						addTaxISum_47 = addTaxISum_47 + rec.get('ADD_TAX_I');
						
					}
				});
				
				Ext.each(recordAll,function (rec, i) {
					if(rec.get('INCCODE') == 'A10') {
						rec.set('ADD_TAX_I',addTaxISum_10);
					} else if(rec.get('INCCODE') == 'A20') {
						rec.set('ADD_TAX_I',addTaxISum_20);
					} else if(rec.get('INCCODE') == 'A30') {
						rec.set('ADD_TAX_I',addTaxISum_30);
					} else if(rec.get('INCCODE') == 'A40') {
						rec.set('ADD_TAX_I',addTaxISum_40);
					} else if(rec.get('INCCODE') == 'A47') {
						rec.set('ADD_TAX_I',addTaxISum_47);
					}
				});
				UniAppManager.app.fnCalcRefunds(recordAll);

			} else if(editColumn == "RET_IN_TAX_I") {		//9.당월조정환급세액
				//9.당월조정환급세액을 직접 입력시 6. + 8. - 9. 한뒤  0 보다 크면  10.에 그값 set 작거나 같으면  10. 0set	 작거나 같을때 그다음 그 계산 한 금액으로 7.과 동일하게 비교 하여  11. 에 set  
				Ext.each(recordAll,function (rec, i) {
					if(rec.get('INCCODE') == 'A10' || rec.get('INCCODE') == 'A30' || rec.get('INCCODE') == 'A50' || rec.get('INCCODE') == 'A60') {
						var inTaxIC	= 0;
						var spTaxIC	= 0;
						inTaxIC		= rec.get('DEF_IN_TAX_I') + rec.get('ADD_TAX_I') - rec.get('RET_IN_TAX_I');
						spTaxIC		= rec.get('DEF_SP_TAX_I');
						
						if(inTaxIC > 0) {
							rec.set('IN_TAX_I', inTaxIC);
							rec.set('SP_TAX_I', spTaxIC);
						} else{
							if(spTaxIC + inTaxIC > 0) {
								rec.set('IN_TAX_I', 0);
								rec.set('SP_TAX_I', spTaxIC + inTaxIC);
							} else{
								rec.set('IN_TAX_I', 0);
								rec.set('SP_TAX_I', 0);
							}
						}
					} else if(rec.get('INCCODE') == 'A20' || rec.get('INCCODE') == 'A40' || rec.get('INCCODE') == 'A47' || rec.get('INCCODE') == 'A69' || rec.get('INCCODE') == 'A70' ||
							 rec.get('INCCODE') == 'A80') {
						var inTaxIC	= 0;
						inTaxIC		= rec.get('DEF_IN_TAX_I') + rec.get('ADD_TAX_I') - rec.get('RET_IN_TAX_I');

						if(inTaxIC > 0) {
							rec.set('IN_TAX_I', inTaxIC);
						} else{
							rec.set('IN_TAX_I', 0);
						}
					}
				});
			}
		},
		fnTotalSumCalc: function() {										//총합계 SUM  원천징수내역 관련
			var incomeCntSum_Total			= 0;
			var incomeSuppTotalISum_Total	= 0;
			var defInTaxISum_Total			= 0;
			var defSpTaxISum_Total			= 0;
			var addTaxISum_Total			= 0;
			var retInTaxISum_Total			= 0;
			var inTaxISum_Total				= 0;
			var spTaxISum_Total				= 0;
			var recordAll2					=  detailStore1.data.items;

			Ext.each(recordAll2,function (rec2, i) {
				if(rec2.get('INCCODE') == 'A10' ||
					rec2.get('INCCODE') == 'A20' ||
					rec2.get('INCCODE') == 'A30' ||
					rec2.get('INCCODE') == 'A40' ||
					rec2.get('INCCODE') == 'A47' ||
					rec2.get('INCCODE') == 'A50' ||
					rec2.get('INCCODE') == 'A60' ||
					rec2.get('INCCODE') == 'A69' ||
					rec2.get('INCCODE') == 'A70' ||
					rec2.get('INCCODE') == 'A80' ||
					rec2.get('INCCODE') == 'A90'
				) {
					var incomeCnt		= Ext.isEmpty(rec2.get('INCOME_CNT')) ? 0 : rec2.get('INCOME_CNT');
					var incomeSuppTotalI= Ext.isEmpty(rec2.get('INCOME_SUPP_TOTAL_I')) ? 0 : rec2.get('INCOME_SUPP_TOTAL_I');
					//6.소득세 등, 7.농어촌특별세 는 -값이 허용 되지만 총합계는 +금액들만 총합계를 구한다
					var defInTaxI		= Ext.isEmpty(rec2.get('DEF_IN_TAX_I')) ? 0 : rec2.get('DEF_IN_TAX_I') < 0 ? 0 : rec2.get('DEF_IN_TAX_I');
					var defSpTaxI		= Ext.isEmpty(rec2.get('DEF_SP_TAX_I')) ? 0 : rec2.get('DEF_SP_TAX_I') < 0 ? 0 : rec2.get('DEF_SP_TAX_I');
					var addTaxI			= Ext.isEmpty(rec2.get('ADD_TAX_I')) ? 0 : rec2.get('ADD_TAX_I');
					var retInTaxI		= Ext.isEmpty(rec2.get('RET_IN_TAX_I')) ? 0 : rec2.get('RET_IN_TAX_I');
					var inTaxI			= Ext.isEmpty(rec2.get('IN_TAX_I')) ? 0 : rec2.get('IN_TAX_I');
					var spTaxI			= Ext.isEmpty(rec2.get('SP_TAX_I')) ? 0 : rec2.get('SP_TAX_I');

					incomeCntSum_Total			= incomeCntSum_Total + incomeCnt;
					incomeSuppTotalISum_Total	= incomeSuppTotalISum_Total + incomeSuppTotalI;
					defInTaxISum_Total			= defInTaxISum_Total + defInTaxI;
					defSpTaxISum_Total			= defSpTaxISum_Total + defSpTaxI;
					addTaxISum_Total			= addTaxISum_Total + addTaxI;
					retInTaxISum_Total			= retInTaxISum_Total + retInTaxI;
					inTaxISum_Total				= inTaxISum_Total + inTaxI;
					spTaxISum_Total				= spTaxISum_Total + spTaxI;
				}
			});
			var recordAll3 =  detailStore1.data.items;
			Ext.each(recordAll3,function (rec3, i) {
				if(rec3.get('INCCODE') == 'A99') {		//총합계
					rec3.set('INCOME_CNT'			, incomeCntSum_Total);
					rec3.set('INCOME_SUPP_TOTAL_I'	, incomeSuppTotalISum_Total);
					rec3.set('DEF_IN_TAX_I'			, defInTaxISum_Total);
					rec3.set('DEF_SP_TAX_I'			, defSpTaxISum_Total);
					rec3.set('ADD_TAX_I'			, addTaxISum_Total);
					rec3.set('RET_IN_TAX_I'			, retInTaxISum_Total);
					rec3.set('IN_TAX_I'				, defInTaxISum_Total + addTaxISum_Total);
					rec3.set('SP_TAX_I'				, spTaxISum_Total);
				}
			});
		},
		fnCalcRefunds: function(recordAll) {								//원천징수내역   환급금액 관련
			// 6. 7. 8. 9. 10. 11. 들의 관계 로직 시작
			var defInTaxIMi = 0;	//6.소득세등 의 마이너스 금액들관련
			var defSpTaxIMi = 0;	//7.농어촌특별세 의 마이너스 금액들관련
			var defTaxICalc = 0;	//환급받을금액  변수 관련

			Ext.each(recordAll,function (rec, i) {
				if(rec.get('INCCODE') == 'A10' ||
					rec.get('INCCODE') == 'A20' ||
					rec.get('INCCODE') == 'A30' ||
					rec.get('INCCODE') == 'A40' ||
					rec.get('INCCODE') == 'A47' ||
					rec.get('INCCODE') == 'A50' ||
					rec.get('INCCODE') == 'A60' ||
					rec.get('INCCODE') == 'A69' ||
					rec.get('INCCODE') == 'A70' ||
					rec.get('INCCODE') == 'A80' ||
					rec.get('INCCODE') == 'A90'
				) {
					if(rec.get('DEF_IN_TAX_I') < 0) {
						defInTaxIMi = defInTaxIMi + rec.get('DEF_IN_TAX_I');
					} else if(rec.get('DEF_SP_TAX_I') < 0) {
						defSpTaxIMi = defSpTaxIMi + rec.get('DEF_SP_TAX_I');
					}
				}
			});
			defTaxICalc = defInTaxIMi + defSpTaxIMi;
			defTaxICalc = defTaxICalc * -1;  //아래 그리드에 계산 로직실행후 비교하기 위해 양수로 변경
			//defTaxICalc  환급이 되어야 하는 금액은  원천징수내역의 아래 그리드에서 계산된 금액으로 변경 되어야 한다
			//로직시작전, 아래그리드에 15.일반환급에 환급받을 -금액을	 +금액으로 set 하고 아래 그리드 계산로직대로 계산후
			//18.조정대상환급  금액으로 위의 그리드 계산 로직을 돌린다 
			//만약 18.조정대상환급 의  값이 -금액이 나올경우 위의 그리드에서 환급 금액이 없는 것처럼 계산을 돌리면 된다.
			//계산 로직 실행후 9.당월조정환급세액 총합계 값을 19.당월조정환급액계에 set 하고	20.차월이월환급액 (18-19) 로직대로 set 한다 
			//만약 아래 그리드 값을 입력 하면  위의 그리드 6. 7. 값들의 -금액들의 합을(환급 받을 금액) 15.일반환급 에 set 하고 아래그리드 로직 시행후 18.조정대상환급 값으로 위의 그리드 로직 시행후 19.set 20.set 한다 
			var defTaxICalcPl	= 0;		//환급받을금액  최종 변수 관련
			var subRecord		= detailStore1_2.data.items[0];

			subRecord.set('RET_AMT'		, defTaxICalc);		// 15. set
			subRecord.set('BAL_AMT'		, subRecord.get('LAST_IN_TAX_I') - subRecord.get('BEFORE_IN_TAX_I'));	// 14. set
			subRecord.set('ROW_IN_TAX_I', subRecord.get('LAST_IN_TAX_I') - subRecord.get('BEFORE_IN_TAX_I') + defTaxICalc + subRecord.get('TRUST_AMT') + subRecord.get('FIN_COMP_AMT') + subRecord.get('MERGER_AMT'));	//18. set

			defTaxICalcPl = subRecord.get('LAST_IN_TAX_I') - subRecord.get('BEFORE_IN_TAX_I') + defTaxICalc + subRecord.get('TRUST_AMT') + subRecord.get('FIN_COMP_AMT') + subRecord.get('MERGER_AMT');

			if(defTaxICalcPl > 0 ) {		// 환급받을금액이 있을시  (	6.소득세등	, 7.농어촌특별세 금액들 안에 -금액이 있을시 )
				var a10YN = 'N';
				var a20YN = 'N';
				var a30YN = 'N';
				var a40YN = 'N';
				var a47YN = 'N';
				var a50YN = 'N';
				var a60YN = 'N';
				var a69YN = 'N';
				var a70YN = 'N';
				var a80YN = 'N';

				var a10YN_Sub = 'N';
				var a20YN_Sub = 'N';
				var a30YN_Sub = 'N';
				var a40YN_Sub = 'N';
				var a47YN_Sub = 'N';
				var a50YN_Sub = 'N';
				var a60YN_Sub = 'N';
				var a69YN_Sub = 'N';
				var a70YN_Sub = 'N';
				var a80YN_Sub = 'N';

				var defTaxICalc_A10 = 0;
				defTaxICalc_A10 = defTaxICalcPl;

				var defTaxICalc_A20 = 0;
				var defTaxICalc_A30 = 0;
				var defTaxICalc_A40 = 0;
				var defTaxICalc_A47 = 0;
				var defTaxICalc_A50 = 0;
				var defTaxICalc_A60 = 0;
				var defTaxICalc_A69 = 0;
				var defTaxICalc_A70 = 0;
				var defTaxICalc_A80 = 0;

				Ext.each(recordAll,function (rec, i) {
					if(rec.get('INCCODE') == 'A10') {
						a10YN_Sub = 'Y';
						var defInTaxI_CalcA10 = 0; 
						defInTaxI_CalcA10 = Ext.isEmpty(rec.get('DEF_IN_TAX_I')) ? 0 : rec.get('DEF_IN_TAX_I') < 0 ? 0 : rec.get('DEF_IN_TAX_I');
						var addTaxI_CalcA10 = 0;
						addTaxI_CalcA10 = Ext.isEmpty(rec.get('ADD_TAX_I')) ? 0 : rec.get('ADD_TAX_I');
						var defSpTaxI_CalcA10 = 0;
						defSpTaxI_CalcA10 = Ext.isEmpty(rec.get('DEF_SP_TAX_I')) ? 0 : rec.get('DEF_SP_TAX_I') < 0 ? 0 : rec.get('DEF_SP_TAX_I');

						if(defTaxICalc_A10 >= defInTaxI_CalcA10 + addTaxI_CalcA10) {	//6. , 7. 들의 -금액의 가감계들의 합이  (*-1 하여 플러스로 변경한 금액)   A10의 6. , 8. 의 +금액들의 합보다 크거나 같을때
							rec.set('IN_TAX_I',0);  //0을 10. 에 SET
							
							if(defTaxICalc_A10 - (defInTaxI_CalcA10 + addTaxI_CalcA10) >= defSpTaxI_CalcA10) {// 6. , 7. 들의 -금액의 가감계들의 합(*-1 하여 플러스로 변경한 금액) 으로 A10의 6. , 8. 의 +금액들의 합을 뺀 금액이 7. 의 금액보다 크거나 같을때 
								rec.set('SP_TAX_I',0);  //0 을  11. 에 SET
								rec.set('RET_IN_TAX_I',defInTaxI_CalcA10 + addTaxI_CalcA10 + defSpTaxI_CalcA10);  //A10의 6. 7. 8. 금액들의 합을 9.에 SET
								
								if(defTaxICalc_A10 - (defInTaxI_CalcA10 + addTaxI_CalcA10 + defSpTaxI_CalcA10) > 0) {	//환급받을 금액이 남았음
									a10YN = 'Y';	//다음 비교로 (A20으로 ) 넘어감
									defTaxICalc_A20 = defTaxICalc_A10 - (defInTaxI_CalcA10 + addTaxI_CalcA10 + defSpTaxI_CalcA10);
								}
							} else {  // 6. , 7. 들의 -금액의 가감계들의 합(*-1 하여 플러스로 변경한 금액) 으로 A10의 6. , 8. 의 +금액들의 합을 뺀 금액이 7. 의 금액보다 작을때
								rec.set('SP_TAX_I',defSpTaxI_CalcA10 - (defTaxICalc_A10 - (defInTaxI_CalcA10 + addTaxI_CalcA10)));  // A10의 11. 금액  -  6. , 7. 들의 -금액의 가감계들의 합(*-1 하여 플러스로 변경한 금액) 으로 A10의 6. , 8. 의 +금액들의 합   을  11. 에 SET
								rec.set('RET_IN_TAX_I',defTaxICalc_A10);  //환급받을금액 9.에 SET
							}
						} else {			//6. , 7. 들의 -금액의 가감계들의 합이  (*-1 하여 플러스로 변경한 금액)   A10의 6. , 8. 의 +금액들의 합보다 작을때
							rec.set('IN_TAX_I',(defInTaxI_CalcA10 + addTaxI_CalcA10) - defTaxICalc_A10);  //A10의 (6. + 8.)  -  6. , 7. 들의 -금액의 가감계들의 합  (*-1 하여 플러스로 변경한 금액)을   10. 에 SET
							rec.set('SP_TAX_I',defSpTaxI_CalcA10 );//A10의  7. 금액을 11.에 SET
							rec.set('RET_IN_TAX_I',defTaxICalc_A10);  //6. , 7. 들의 -금액의 가감계들의 합  (*-1 하여 플러스로 변경한 금액) 을 9. 에 SET
						}
					} else if(rec.get('INCCODE') == 'A20' && a10YN == 'Y') {
						a20YN_Sub = 'Y';
						var defInTaxI_CalcA20 = 0; 
						defInTaxI_CalcA20 = Ext.isEmpty(rec.get('DEF_IN_TAX_I')) ? 0 : rec.get('DEF_IN_TAX_I') < 0 ? 0 : rec.get('DEF_IN_TAX_I');
						var addTaxI_CalcA20 = 0;
						addTaxI_CalcA20 = Ext.isEmpty(rec.get('ADD_TAX_I')) ? 0 : rec.get('ADD_TAX_I');
						var defSpTaxI_CalcA20 = 0;
						defSpTaxI_CalcA20 = Ext.isEmpty(rec.get('DEF_SP_TAX_I')) ? 0 : rec.get('DEF_SP_TAX_I') < 0 ? 0 : rec.get('DEF_SP_TAX_I');

						if(defTaxICalc_A20 >= defInTaxI_CalcA20 + addTaxI_CalcA20) {
							rec.set('IN_TAX_I',0);

							if(defTaxICalc_A20 - (defInTaxI_CalcA20 + addTaxI_CalcA20) >= defSpTaxI_CalcA20) {
								rec.set('SP_TAX_I',0);
								rec.set('RET_IN_TAX_I',defInTaxI_CalcA20 + addTaxI_CalcA20 + defSpTaxI_CalcA20);
								
								if(defTaxICalc_A20 - (defInTaxI_CalcA20 + addTaxI_CalcA20 + defSpTaxI_CalcA20) > 0) {
									a20YN = 'Y';
									defTaxICalc_A30 = defTaxICalc_A20 - (defInTaxI_CalcA20 + addTaxI_CalcA20 + defSpTaxI_CalcA20);
								}
							} else {
								rec.set('SP_TAX_I',defSpTaxI_CalcA20 - (defTaxICalc_A20 - (defInTaxI_CalcA20 + addTaxI_CalcA20)));
								rec.set('RET_IN_TAX_I',defTaxICalc_A20);
							}
						} else {
							rec.set('IN_TAX_I',(defInTaxI_CalcA20 + addTaxI_CalcA20) - defTaxICalc_A20);
							rec.set('SP_TAX_I',defSpTaxI_CalcA20 );
							rec.set('RET_IN_TAX_I',defTaxICalc_A20);
						}
					} else if(rec.get('INCCODE') == 'A30' && a20YN == 'Y') {
						a30YN_Sub = 'Y';
						var defInTaxI_CalcA30 = 0; 
						defInTaxI_CalcA30 = Ext.isEmpty(rec.get('DEF_IN_TAX_I')) ? 0 : rec.get('DEF_IN_TAX_I') < 0 ? 0 : rec.get('DEF_IN_TAX_I');
						var addTaxI_CalcA30 = 0;
						addTaxI_CalcA30 = Ext.isEmpty(rec.get('ADD_TAX_I')) ? 0 : rec.get('ADD_TAX_I');
						var defSpTaxI_CalcA30 = 0;
						defSpTaxI_CalcA30 = Ext.isEmpty(rec.get('DEF_SP_TAX_I')) ? 0 : rec.get('DEF_SP_TAX_I') < 0 ? 0 : rec.get('DEF_SP_TAX_I');

						if(defTaxICalc_A30 >= defInTaxI_CalcA30 + addTaxI_CalcA30) {
							rec.set('IN_TAX_I',0);

							if(defTaxICalc_A30 - (defInTaxI_CalcA30 + addTaxI_CalcA30) >= defSpTaxI_CalcA30) {
								rec.set('SP_TAX_I',0);
								rec.set('RET_IN_TAX_I',defInTaxI_CalcA30 + addTaxI_CalcA30 + defSpTaxI_CalcA30);

								if(defTaxICalc_A30 - (defInTaxI_CalcA30 + addTaxI_CalcA30 + defSpTaxI_CalcA30) > 0) {
									a30YN = 'Y';
									defTaxICalc_A40 = defTaxICalc_A30 - (defInTaxI_CalcA30 + addTaxI_CalcA30 + defSpTaxI_CalcA30);
								}
							} else {
								rec.set('SP_TAX_I',defSpTaxI_CalcA30 - (defTaxICalc_A30 - (defInTaxI_CalcA30 + addTaxI_CalcA30)));
								rec.set('RET_IN_TAX_I',defTaxICalc_A30);
							}
						} else {
							rec.set('IN_TAX_I',(defInTaxI_CalcA30 + addTaxI_CalcA30) - defTaxICalc_A30);
							rec.set('SP_TAX_I',defSpTaxI_CalcA30 );
							rec.set('RET_IN_TAX_I',defTaxICalc_A30);
						}
					} else if(rec.get('INCCODE') == 'A40' && a30YN == 'Y') {
						a40YN_Sub = 'Y';
						var defInTaxI_CalcA40 = 0; 
						defInTaxI_CalcA40 = Ext.isEmpty(rec.get('DEF_IN_TAX_I')) ? 0 : rec.get('DEF_IN_TAX_I') < 0 ? 0 : rec.get('DEF_IN_TAX_I');
						var addTaxI_CalcA40 = 0;
						addTaxI_CalcA40 = Ext.isEmpty(rec.get('ADD_TAX_I')) ? 0 : rec.get('ADD_TAX_I');
						var defSpTaxI_CalcA40 = 0;
						defSpTaxI_CalcA40 = Ext.isEmpty(rec.get('DEF_SP_TAX_I')) ? 0 : rec.get('DEF_SP_TAX_I') < 0 ? 0 : rec.get('DEF_SP_TAX_I');

						if(defTaxICalc_A40 >= defInTaxI_CalcA40 + addTaxI_CalcA40) {
							rec.set('IN_TAX_I',0);

							if(defTaxICalc_A40 - (defInTaxI_CalcA40 + addTaxI_CalcA40) >= defSpTaxI_CalcA40) {
								rec.set('SP_TAX_I',0);
								rec.set('RET_IN_TAX_I',defInTaxI_CalcA40 + addTaxI_CalcA40 + defSpTaxI_CalcA40);

								if(defTaxICalc_A40 - (defInTaxI_CalcA40 + addTaxI_CalcA40 + defSpTaxI_CalcA40) > 0) {
									a40YN = 'Y';
									defTaxICalc_A47 = defTaxICalc_A40 - (defInTaxI_CalcA40 + addTaxI_CalcA40 + defSpTaxI_CalcA40);
								}
							} else {
								rec.set('SP_TAX_I',defSpTaxI_CalcA40 - (defTaxICalc_A40 - (defInTaxI_CalcA40 + addTaxI_CalcA40)));
								rec.set('RET_IN_TAX_I',defTaxICalc_A40);
							}
						} else {
							rec.set('IN_TAX_I',(defInTaxI_CalcA40 + addTaxI_CalcA40) - defTaxICalc_A40);
							rec.set('SP_TAX_I',defSpTaxI_CalcA40 );
							rec.set('RET_IN_TAX_I',defTaxICalc_A40);
						}
					} else if(rec.get('INCCODE') == 'A47' && a40YN == 'Y') {
						a47YN_Sub = 'Y';
						var defInTaxI_CalcA47 = 0; 
						defInTaxI_CalcA47 = Ext.isEmpty(rec.get('DEF_IN_TAX_I')) ? 0 : rec.get('DEF_IN_TAX_I') < 0 ? 0 : rec.get('DEF_IN_TAX_I');
						var addTaxI_CalcA47 = 0;
						addTaxI_CalcA47 = Ext.isEmpty(rec.get('ADD_TAX_I')) ? 0 : rec.get('ADD_TAX_I');
						var defSpTaxI_CalcA47 = 0;
						defSpTaxI_CalcA47 = Ext.isEmpty(rec.get('DEF_SP_TAX_I')) ? 0 : rec.get('DEF_SP_TAX_I') < 0 ? 0 : rec.get('DEF_SP_TAX_I');

						if(defTaxICalc_A47 >= defInTaxI_CalcA47 + addTaxI_CalcA47) {
							rec.set('IN_TAX_I',0);

							if(defTaxICalc_A47 - (defInTaxI_CalcA47 + addTaxI_CalcA47) >= defSpTaxI_CalcA47) {
								rec.set('SP_TAX_I',0);
								rec.set('RET_IN_TAX_I',defInTaxI_CalcA47 + addTaxI_CalcA47 + defSpTaxI_CalcA47);

								if(defTaxICalc_A47 - (defInTaxI_CalcA47 + addTaxI_CalcA47 + defSpTaxI_CalcA47) > 0) {
									a47YN = 'Y';
									defTaxICalc_A50 = defTaxICalc_A47 - (defInTaxI_CalcA47 + addTaxI_CalcA47 + defSpTaxI_CalcA47);
								}
							} else {
								rec.set('SP_TAX_I',defSpTaxI_CalcA47 - (defTaxICalc_A47 - (defInTaxI_CalcA47 + addTaxI_CalcA47)));
								rec.set('RET_IN_TAX_I',defTaxICalc_A47);
							}
						} else {
							rec.set('IN_TAX_I',(defInTaxI_CalcA47 + addTaxI_CalcA47) - defTaxICalc_A47);
							rec.set('SP_TAX_I',defSpTaxI_CalcA47 );
							rec.set('RET_IN_TAX_I',defTaxICalc_A47);
						}
					} else if(rec.get('INCCODE') == 'A50' && a47YN == 'Y') {
						a50YN_Sub = 'Y';
						var defInTaxI_CalcA50 = 0; 
						defInTaxI_CalcA50 = Ext.isEmpty(rec.get('DEF_IN_TAX_I')) ? 0 : rec.get('DEF_IN_TAX_I') < 0 ? 0 : rec.get('DEF_IN_TAX_I');
						var addTaxI_CalcA50 = 0;
						addTaxI_CalcA50 = Ext.isEmpty(rec.get('ADD_TAX_I')) ? 0 : rec.get('ADD_TAX_I');
						var defSpTaxI_CalcA50 = 0;
						defSpTaxI_CalcA50 = Ext.isEmpty(rec.get('DEF_SP_TAX_I')) ? 0 : rec.get('DEF_SP_TAX_I') < 0 ? 0 : rec.get('DEF_SP_TAX_I');

						if(defTaxICalc_A50 >= defInTaxI_CalcA50 + addTaxI_CalcA50) {
							rec.set('IN_TAX_I',0);

							if(defTaxICalc_A50 - (defInTaxI_CalcA50 + addTaxI_CalcA50) >= defSpTaxI_CalcA50) {
								rec.set('SP_TAX_I',0);
								rec.set('RET_IN_TAX_I',defInTaxI_CalcA50 + addTaxI_CalcA50 + defSpTaxI_CalcA50);

								if(defTaxICalc_A50 - (defInTaxI_CalcA50 + addTaxI_CalcA50 + defSpTaxI_CalcA50) > 0) {
									a50YN = 'Y';
									defTaxICalc_A60 = defTaxICalc_A50 - (defInTaxI_CalcA50 + addTaxI_CalcA50 + defSpTaxI_CalcA50);
								}
							} else {
								rec.set('SP_TAX_I',defSpTaxI_CalcA50 - (defTaxICalc_A50 - (defInTaxI_CalcA50 + addTaxI_CalcA50)));
								rec.set('RET_IN_TAX_I',defTaxICalc_A50);
							}
						} else {
							rec.set('IN_TAX_I',(defInTaxI_CalcA50 + addTaxI_CalcA50) - defTaxICalc_A50);
							rec.set('SP_TAX_I',defSpTaxI_CalcA50 );
							rec.set('RET_IN_TAX_I',defTaxICalc_A50);
						}
					} else if(rec.get('INCCODE') == 'A60' && a50YN == 'Y') {
						a60YN_Sub = 'Y';
						var defInTaxI_CalcA60 = 0; 
						defInTaxI_CalcA60 = Ext.isEmpty(rec.get('DEF_IN_TAX_I')) ? 0 : rec.get('DEF_IN_TAX_I') < 0 ? 0 : rec.get('DEF_IN_TAX_I');
						var addTaxI_CalcA60 = 0;
						addTaxI_CalcA60 = Ext.isEmpty(rec.get('ADD_TAX_I')) ? 0 : rec.get('ADD_TAX_I');
						var defSpTaxI_CalcA60 = 0;
						defSpTaxI_CalcA60 = Ext.isEmpty(rec.get('DEF_SP_TAX_I')) ? 0 : rec.get('DEF_SP_TAX_I') < 0 ? 0 : rec.get('DEF_SP_TAX_I');

						if(defTaxICalc_A60 >= defInTaxI_CalcA60 + addTaxI_CalcA60) {
							rec.set('IN_TAX_I',0);

							if(defTaxICalc_A60 - (defInTaxI_CalcA60 + addTaxI_CalcA60) >= defSpTaxI_CalcA60) {
								rec.set('SP_TAX_I',0);
								rec.set('RET_IN_TAX_I',defInTaxI_CalcA60 + addTaxI_CalcA60 + defSpTaxI_CalcA60);

								if(defTaxICalc_A60 - (defInTaxI_CalcA60 + addTaxI_CalcA60 + defSpTaxI_CalcA60) > 0) {
									a60YN = 'Y';
									defTaxICalc_A69 = defTaxICalc_A60 - (defInTaxI_CalcA60 + addTaxI_CalcA60 + defSpTaxI_CalcA60);
								}
							} else {
								rec.set('SP_TAX_I',defSpTaxI_CalcA60 - (defTaxICalc_A60 - (defInTaxI_CalcA60 + addTaxI_CalcA60)));
								rec.set('RET_IN_TAX_I',defTaxICalc_A60);
							}
						} else {
							rec.set('IN_TAX_I',(defInTaxI_CalcA60 + addTaxI_CalcA60) - defTaxICalc_A60);
							rec.set('SP_TAX_I',defSpTaxI_CalcA60 );
							rec.set('RET_IN_TAX_I',defTaxICalc_A60);
						}
					} else if(rec.get('INCCODE') == 'A69' && a60YN == 'Y') {
						a69YN_Sub = 'Y';
						var defInTaxI_CalcA69 = 0; 
						defInTaxI_CalcA69 = Ext.isEmpty(rec.get('DEF_IN_TAX_I')) ? 0 : rec.get('DEF_IN_TAX_I') < 0 ? 0 : rec.get('DEF_IN_TAX_I');
						var addTaxI_CalcA69 = 0;
						addTaxI_CalcA69 = Ext.isEmpty(rec.get('ADD_TAX_I')) ? 0 : rec.get('ADD_TAX_I');
						var defSpTaxI_CalcA69 = 0;
						defSpTaxI_CalcA69 = Ext.isEmpty(rec.get('DEF_SP_TAX_I')) ? 0 : rec.get('DEF_SP_TAX_I') < 0 ? 0 : rec.get('DEF_SP_TAX_I');

						if(defTaxICalc_A69 >= defInTaxI_CalcA69 + addTaxI_CalcA69) {
							rec.set('IN_TAX_I',0);

							if(defTaxICalc_A69 - (defInTaxI_CalcA69 + addTaxI_CalcA69) >= defSpTaxI_CalcA69) {
								rec.set('SP_TAX_I',0);
								rec.set('RET_IN_TAX_I',defInTaxI_CalcA69 + addTaxI_CalcA69 + defSpTaxI_CalcA69);

								if(defTaxICalc_A69 - (defInTaxI_CalcA69 + addTaxI_CalcA69 + defSpTaxI_CalcA69) > 0) {
									a69YN = 'Y';
									defTaxICalc_A70 = defTaxICalc_A69 - (defInTaxI_CalcA69 + addTaxI_CalcA69 + defSpTaxI_CalcA69);
								}
							} else {
								rec.set('SP_TAX_I',defSpTaxI_CalcA69 - (defTaxICalc_A69 - (defInTaxI_CalcA69 + addTaxI_CalcA69)));
								rec.set('RET_IN_TAX_I',defTaxICalc_A69);
							}
						} else {
							rec.set('IN_TAX_I',(defInTaxI_CalcA69 + addTaxI_CalcA69) - defTaxICalc_A69);
							rec.set('SP_TAX_I',defSpTaxI_CalcA69 );
							rec.set('RET_IN_TAX_I',defTaxICalc_A69);
						}
					} else if(rec.get('INCCODE') == 'A70' && a69YN == 'Y') {
						a70YN_Sub = 'Y';
						var defInTaxI_CalcA70 = 0; 
						defInTaxI_CalcA70 = Ext.isEmpty(rec.get('DEF_IN_TAX_I')) ? 0 : rec.get('DEF_IN_TAX_I') < 0 ? 0 : rec.get('DEF_IN_TAX_I');
						var addTaxI_CalcA70 = 0;
						addTaxI_CalcA70 = Ext.isEmpty(rec.get('ADD_TAX_I')) ? 0 : rec.get('ADD_TAX_I');
						var defSpTaxI_CalcA70 = 0;
						defSpTaxI_CalcA70 = Ext.isEmpty(rec.get('DEF_SP_TAX_I')) ? 0 : rec.get('DEF_SP_TAX_I') < 0 ? 0 : rec.get('DEF_SP_TAX_I');

						if(defTaxICalc_A70 >= defInTaxI_CalcA70 + addTaxI_CalcA70) {
							rec.set('IN_TAX_I',0);

							if(defTaxICalc_A70 - (defInTaxI_CalcA70 + addTaxI_CalcA70) >= defSpTaxI_CalcA70) {
								rec.set('SP_TAX_I',0);
								rec.set('RET_IN_TAX_I',defInTaxI_CalcA70 + addTaxI_CalcA70 + defSpTaxI_CalcA70);

								if(defTaxICalc_A70 - (defInTaxI_CalcA70 + addTaxI_CalcA70 + defSpTaxI_CalcA70) > 0) {
									a70YN = 'Y';
									defTaxICalc_A80 = defTaxICalc_A70 - (defInTaxI_CalcA70 + addTaxI_CalcA70 + defSpTaxI_CalcA70);
								}
							} else {
								rec.set('SP_TAX_I',defSpTaxI_CalcA70 - (defTaxICalc_A70 - (defInTaxI_CalcA70 + addTaxI_CalcA70)));
								rec.set('RET_IN_TAX_I',defTaxICalc_A70);
							}
						} else {
							rec.set('IN_TAX_I',(defInTaxI_CalcA70 + addTaxI_CalcA70) - defTaxICalc_A70);
							rec.set('SP_TAX_I',defSpTaxI_CalcA70 );
							rec.set('RET_IN_TAX_I',defTaxICalc_A70);
						}
					} else if(rec.get('INCCODE') == 'A80' && a70YN == 'Y') {
						a80YN_Sub = 'Y';
						var defInTaxI_CalcA80 = 0; 
						defInTaxI_CalcA80 = Ext.isEmpty(rec.get('DEF_IN_TAX_I')) ? 0 : rec.get('DEF_IN_TAX_I') < 0 ? 0 : rec.get('DEF_IN_TAX_I');
						var addTaxI_CalcA80 = 0;
						addTaxI_CalcA80 = Ext.isEmpty(rec.get('ADD_TAX_I')) ? 0 : rec.get('ADD_TAX_I');
						var defSpTaxI_CalcA80 = 0;
						defSpTaxI_CalcA80 = Ext.isEmpty(rec.get('DEF_SP_TAX_I')) ? 0 : rec.get('DEF_SP_TAX_I') < 0 ? 0 : rec.get('DEF_SP_TAX_I');

						if(defTaxICalc_A80 >= defInTaxI_CalcA80 + addTaxI_CalcA80) {
							rec.set('IN_TAX_I',0);

							if(defTaxICalc_A80 - (defInTaxI_CalcA80 + addTaxI_CalcA80) >= defSpTaxI_CalcA80) {
								rec.set('SP_TAX_I',0);
								rec.set('RET_IN_TAX_I',defInTaxI_CalcA80 + addTaxI_CalcA80 + defSpTaxI_CalcA80);

								if(defTaxICalc_A80 - (defInTaxI_CalcA80 + addTaxI_CalcA80 + defSpTaxI_CalcA80) > 0) {
									a80YN = 'Y';
									//defTaxICalc_A90 = defTaxICalc_A80 - (defInTaxI_CalcA80 + addTaxI_CalcA80 + defSpTaxI_CalcA80);
								}
							} else {
								rec.set('SP_TAX_I',defSpTaxI_CalcA80 - (defTaxICalc_A80 - (defInTaxI_CalcA80 + addTaxI_CalcA80)));
								rec.set('RET_IN_TAX_I',defTaxICalc_A80);
							}
						} else {
							rec.set('IN_TAX_I',(defInTaxI_CalcA80 + addTaxI_CalcA80) - defTaxICalc_A80);
							rec.set('SP_TAX_I',defSpTaxI_CalcA80 );
							rec.set('RET_IN_TAX_I',defTaxICalc_A80);
						}
					}
				});
				UniAppManager.app.fnSubCalc(recordAll,a10YN_Sub,a20YN_Sub,a30YN_Sub,a40YN_Sub,a47YN_Sub,a50YN_Sub,a60YN_Sub,a69YN_Sub,a70YN_Sub,a80YN_Sub);

			} else{						// 환급받을금액이 없을시 
				var a10YN_Sub = 'N';
				var a20YN_Sub = 'N';
				var a30YN_Sub = 'N';
				var a40YN_Sub = 'N';
				var a47YN_Sub = 'N';
				var a50YN_Sub = 'N';
				var a60YN_Sub = 'N';
				var a69YN_Sub = 'N';
				var a70YN_Sub = 'N';
				var a80YN_Sub = 'N';
				UniAppManager.app.fnSubCalc(recordAll,a10YN_Sub,a20YN_Sub,a30YN_Sub,a40YN_Sub,a47YN_Sub,a50YN_Sub,a60YN_Sub,a69YN_Sub,a70YN_Sub,a80YN_Sub);
			}
			//19.당월조정 환급액계 set
			var totalInTaxI = 0;
			Ext.each(recordAll,function (rec, i) {
				if(rec.get('INCCODE') == 'A10' ||
					rec.get('INCCODE') == 'A20' ||
					rec.get('INCCODE') == 'A30' ||
					rec.get('INCCODE') == 'A40' ||
					rec.get('INCCODE') == 'A47' ||
					rec.get('INCCODE') == 'A50' ||
					rec.get('INCCODE') == 'A60' ||
					rec.get('INCCODE') == 'A69' ||
					rec.get('INCCODE') == 'A70' ||
					rec.get('INCCODE') == 'A80' 
				) {
					totalInTaxI = totalInTaxI + rec.get('RET_IN_TAX_I');
				}
			});
			subRecord.set('TOTAL_IN_TAX_I', totalInTaxI);
			subRecord.set('NEXT_IN_TAX_I', defTaxICalcPl - totalInTaxI);
		},
		fnCalc2: function(recordAll, editColumn, currRecord, newValue) {	//부표-거주자 관련
			if(UniUtils.indexOf(editColumn , ["INCOME_CNT","INCOME_SUPP_TOTAL_I","DEF_IN_TAX_I","DEF_SP_TAX_I","ADD_TAX_I"])) {				//4.인원, 5.총지급액, 6.소득세 등, 7.농어촌특별세, 8.가산세
				var sum_C30 = 0;
				var sum_C50 = 0;
				Ext.each(recordAll,function (rec, i) {
					if(rec.get('INCCODE') == 'C01'|| rec.get('INCCODE') == 'C02'|| rec.get('INCCODE') == 'C03'|| rec.get('INCCODE') == 'C05'|| rec.get('INCCODE') == 'C06'||
					   rec.get('INCCODE') == 'C07'|| rec.get('INCCODE') == 'C08'|| rec.get('INCCODE') == 'C10'|| rec.get('INCCODE') == 'C20'|| rec.get('INCCODE') == 'C23'||
					   rec.get('INCCODE') == 'C40'|| rec.get('INCCODE') == 'C60'|| rec.get('INCCODE') == 'C19'|| rec.get('INCCODE') == 'C29'|| rec.get('INCCODE') == 'C11'||
					   rec.get('INCCODE') == 'C54'|| rec.get('INCCODE') == 'C55'|| rec.get('INCCODE') == 'C56'|| rec.get('INCCODE') == 'C57'|| rec.get('INCCODE') == 'C93'||
					   rec.get('INCCODE') == 'C12'|| rec.get('INCCODE') == 'C22'|| rec.get('INCCODE') == 'C13'|| rec.get('INCCODE') == 'C18'|| rec.get('INCCODE') == 'C58'||
					   rec.get('INCCODE') == 'C39'|| rec.get('INCCODE') == 'C14'|| rec.get('INCCODE') == 'C24'|| rec.get('INCCODE') == 'C91'|| rec.get('INCCODE') == 'C92'||
					   rec.get('INCCODE') == 'C15'|| rec.get('INCCODE') == 'C25'|| rec.get('INCCODE') == 'C16'|| rec.get('INCCODE') == 'C26'
					 ) {
						sum_C30 = sum_C30 + parseInt(rec.get(editColumn));
					} else if(rec.get('INCCODE') == 'C41'|| rec.get('INCCODE') == 'C42'|| rec.get('INCCODE') == 'C43'|| rec.get('INCCODE') == 'C44'|| rec.get('INCCODE') == 'C45'|| 
							 rec.get('INCCODE') == 'C46') {
						sum_C50 = sum_C50 + parseInt(rec.get(editColumn));
					}
					
				});
				
				Ext.each(recordAll,function (rec, i) {
					if(rec.get('INCCODE') == 'C30') {
						rec.set(editColumn, sum_C30);
					} else if(rec.get('INCCODE') == 'C50') {
						rec.set(editColumn, sum_C50);
					}
				});
				var rec_A69     = detailStore1.getAt(detailStore1.find('INCCODE', 'A69'))
				if(rec_A69)	{
					rec_A69.set(editColumn, sum_C50)
				}
				
			} 
		    //이자소득, 배당소득 
			var sum_A50 = 0;
			var sum_A60 = 0;
			if(UniUtils.indexOf(editColumn , ["INCOME_CNT","INCOME_SUPP_TOTAL_I","DEF_IN_TAX_I","DEF_SP_TAX_I","ADD_TAX_I", "RET_IN_TAX_I"])) {				//4.인원, 5.총지급액, 6.소득세 등, 7.농어촌특별세, 8.가산세
				var sum_C30 = 0;
				var sum_C50 = 0;
				var sum_A50 = 0;
				var sum_A60 = 0;
				Ext.each(recordAll,function (rec, i) {
					if(rec.get('INCCODE') == 'C01'|| rec.get('INCCODE') == 'C02'|| rec.get('INCCODE') == 'C03'|| rec.get('INCCODE') == 'C05'|| rec.get('INCCODE') == 'C06'||
					   rec.get('INCCODE') == 'C08'|| rec.get('INCCODE') == 'C19'|| rec.get('INCCODE') == 'C12'|| rec.get('INCCODE') == 'C13'||
					   rec.get('INCCODE') == 'C18'|| rec.get('INCCODE') == 'C14'|| rec.get('INCCODE') == 'C15'|| rec.get('INCCODE') == 'C16'
					 ) {
						sum_A50 = sum_A50 + parseInt(rec.get(editColumn));
					}
					
					if(rec.get('INCCODE') == 'C07'|| rec.get('INCCODE') == 'C10'|| rec.get('INCCODE') == 'C20'|| rec.get('INCCODE') == 'C23'|| rec.get('INCCODE') == 'C29'||
					   rec.get('INCCODE') == 'C54'|| rec.get('INCCODE') == 'C55'|| rec.get('INCCODE') == 'C56'|| rec.get('INCCODE') == 'C57'||
					   rec.get('INCCODE') == 'C22'|| rec.get('INCCODE') == 'C58'|| rec.get('INCCODE') == 'C39'|| rec.get('INCCODE') == 'C24'||
					   rec.get('INCCODE') == 'C91'|| rec.get('INCCODE') == 'C92'|| rec.get('INCCODE') == 'C25'|| rec.get('INCCODE') == 'C26'
					 ) {
						sum_A60 = sum_A60 + parseInt(rec.get(editColumn));
					}
				});
				
				
				var rec_A50     = detailStore1.getAt(detailStore1.find('INCCODE', 'A50'))
				if(rec_A50)	{
					rec_A50.set(editColumn, sum_A50);
				}
				
				var rec_A60     = detailStore1.getAt(detailStore1.find('INCCODE', 'A60'))
				if(rec_A60)	{
					rec_A60.set(editColumn, sum_A60);
				}
				
			} 
			if(UniUtils.indexOf(editColumn , ["DEF_IN_TAX_I","DEF_SP_TAX_I","ADD_TAX_I"])) {		//6.소득세 등, 7.농어촌특별세, 8.가산세
				UniAppManager.app.fnCalcRefunds2(recordAll);
			}
		},
		fnCalcRefunds2: function(recordAll) {								//부표-거주자   환급금액 관련
			//10.소득세등(가산세포함) = 6.소득세등(+금액만) + 8.가산세 - 9.당월조정환급세액	->(계산한 값이 -금액이면 0) ,  (+금액이면  +금액 set)
			//11.농어촌특별세 =  6.소득세등(+금액만) + 8.가산세 - 9.당월조정환급세액  = -금액이면	 -금액 + 7.농어촌특별세   -> (계산한 값이 -금액이면  0)  ,  (+금액이면  +금액 set)
			Ext.each(recordAll,function (rec, i) {
				if(rec.get('INCCODE') == 'C30' || rec.get('INCCODE') == 'C59' || rec.get('INCCODE') == 'C50') {
					var inTaxIC	= 0;
					var spTaxIC	= 0;
					inTaxIC		= rec.get('DEF_IN_TAX_I') + rec.get('ADD_TAX_I') - rec.get('RET_IN_TAX_I');
					spTaxIC		= rec.get('DEF_SP_TAX_I');

					if(inTaxIC > 0) {
						rec.set('IN_TAX_I', inTaxIC);
						rec.set('SP_TAX_I', spTaxIC);
					} else{
						if(spTaxIC + inTaxIC > 0) {
							rec.set('IN_TAX_I', 0);
							rec.set('SP_TAX_I', spTaxIC + inTaxIC);
						} else{
							rec.set('IN_TAX_I', 0);
							rec.set('SP_TAX_I', 0);
						}
					}
				}
			});
			
			//이자소득, 배당소득
			var sumInTaxI_A50 = 0, sumSpTaxI_A50 = 0, sumInTaxI_A60 = 0, sumSpTaxI_A60 = 0;
			Ext.each(recordAll,function (rec, i) {
				if(rec.get('INCCODE') == 'C01'|| rec.get('INCCODE') == 'C02'|| rec.get('INCCODE') == 'C03'|| rec.get('INCCODE') == 'C05'|| rec.get('INCCODE') == 'C06'||
				   rec.get('INCCODE') == 'C08'|| rec.get('INCCODE') == 'C19'|| rec.get('INCCODE') == 'C12'|| rec.get('INCCODE') == 'C13'||
				   rec.get('INCCODE') == 'C18'|| rec.get('INCCODE') == 'C14'|| rec.get('INCCODE') == 'C15'|| rec.get('INCCODE') == 'C16'
				 ) {
					sumSpTaxI_A50 = sumSpTaxI_A50 + parseInt(rec.get('SP_TAX_I'));
				}
				if(rec.get('INCCODE') == 'C07'|| rec.get('INCCODE') == 'C10'|| rec.get('INCCODE') == 'C20'|| rec.get('INCCODE') == 'C23'|| rec.get('INCCODE') == 'C29'||
				   rec.get('INCCODE') == 'C54'|| rec.get('INCCODE') == 'C55'|| rec.get('INCCODE') == 'C56'|| rec.get('INCCODE') == 'C57'||
				   rec.get('INCCODE') == 'C22'|| rec.get('INCCODE') == 'C58'|| rec.get('INCCODE') == 'C39'|| rec.get('INCCODE') == 'C24'||
				   rec.get('INCCODE') == 'C91'|| rec.get('INCCODE') == 'C92'|| rec.get('INCCODE') == 'C25'|| rec.get('INCCODE') == 'C26'
				 ) {
					sumSpTaxI_A60 = sumSpTaxI_A60 + parseInt(rec.get('SP_TAX_I'));
				}
			});
			// 이자소득
			var rec_C61     = detailStore3.getAt(detailStore3.find('INCCODE', 'C61'))
			if(rec_C61 )	{
				sumInTaxI_A50 = sumInTaxI_A50 + rec_C61.get("IN_TAX_I");
			}
			
			var rec_A50     = detailStore1.getAt(detailStore1.find('INCCODE', 'A50'))
			if(rec_A50)	{
				rec_A50.set("IN_TAX_I", sumInTaxI_A50);
				rec_A50.set("SP_TAX_I", sumSpTaxI_A50);
			}
			
			//배당소득
			var rec_C62     = detailStore3.getAt(detailStore3.find('INCCODE', 'C62'))
			if(rec_C62 )	{
				sumSpTaxI_A60 = sumSpTaxI_A60 + rec_C62.get("IN_TAX_I");
			}
			
			var rec_A60     = detailStore1.getAt(detailStore1.find('INCCODE', 'A60'))
			if(rec_A60)	{
				rec_A60.set("IN_TAX_I", sumInTaxI_A60);
				rec_A60.set("SP_TAX_I", sumSpTaxI_A60);
			}
		},
		fnCalc3: function(recordAll, editColumn, currRecord, newValue) {	//부표-비거주자 관련
			var sum_C70 = 0;

			var rec_C61 ,rec_C63 ,rec_C64 ,rec_C66 , rec_C67 , rec_C68, rec_C70 ;    
			Ext.each(recordAll,function (rec, i) {
				if(rec.get('INCCODE') == 'C61'|| rec.get('INCCODE') == 'C62'|| rec.get('INCCODE') == 'C63'|| rec.get('INCCODE') == 'C64'|| rec.get('INCCODE') == 'C65'|| 
				   rec.get('INCCODE') == 'C66'|| rec.get('INCCODE') == 'C67'|| rec.get('INCCODE') == 'C68'|| rec.get('INCCODE') == 'C69'
				) {
					sum_C70 = sum_C70 + parseInt(rec.get(editColumn));
					
					if(rec.get('INCCODE') == 'C61')	 rec_C61 = rec;
					if(rec.get('INCCODE') == 'C62')	 rec_C62 = rec;
					if(rec.get('INCCODE') == 'C63')	 rec_C63 = rec;
					if(rec.get('INCCODE') == 'C64')	 rec_C64 = rec;
					if(rec.get('INCCODE') == 'C66')	 rec_C66 = rec;
					if(rec.get('INCCODE') == 'C67')	 rec_C67 = rec;
					if(rec.get('INCCODE') == 'C68')	 rec_C68 = rec;
					
				}
				if(rec.get('INCCODE') == 'C70')	 rec_C70 = rec;
			});
			
			rec_C70.set(editColumn, sum_C70);
			
			var sum_A70     = parseInt(rec_C66.get(editColumn)) + parseInt(rec_C67.get(editColumn));
			
			var rec_A70     = detailStore1.getAt(detailStore1.find('INCCODE', 'A70'));
			if(rec_A70)	{
				rec_A70.set(editColumn, sum_A70)
			}
			
			var rec_A40     = detailStore1.getAt(detailStore1.find('INCCODE', 'A40'));
			if(rec_A40)	{
				rec_A40.set(editColumn, parseInt(A40_ORG[editColumn]) + parseInt(rec_C68.get(editColumn)))
			}
			
			var rec_A25     = detailStore1.getAt(detailStore1.find('INCCODE', 'A25'));
			if(rec_A25)	{
				rec_A25.set(editColumn, parseInt(A25_ORG[editColumn]) + parseInt(rec_C63.get(editColumn)) + parseInt(rec_C64.get(editColumn)) )
			}

			if(editColumn == 'DEF_IN_TAX_I'	|| editColumn == 'DEF_SP_TAX_I'	|| editColumn == 'ADD_TAX_I' || editColumn == 'RET_IN_TAX_I') {
				UniAppManager.app.fnCalcRefunds3(recordAll);
			}
		
			
		},
		fnCalcRefunds3: function(recordAll) {								//부표-비거주자   환급금액 관련
			var rec_C61 ,rec_C63 ,rec_C64 ,rec_C66 , rec_C67 , rec_C68, rec_C70 ;   
			var sumInTaxI_C70 = 0 , sumSpTaxI_C70 = 0;
			//10.소득세등(가산세포함) = 6.소득세등(+금액만) + 8.가산세 - 9.당월조정환급세액	->(계산한 값이 -금액이면 0) ,  (+금액이면  +금액 set)
			//11.농어촌특별세 =  6.소득세등(+금액만) + 8.가산세 - 9.당월조정환급세액  = -금액이면	 -금액 + 7.농어촌특별세   -> (계산한 값이 -금액이면  0)  ,  (+금액이면  +금액 set)
			//9.당월조정환급세액을 직접 입력시는 계산 X
			Ext.each(recordAll,function (rec, i) {
				var inTaxIC	= 0;
				var spTaxIC	= 0;
				inTaxIC		= rec.get('DEF_IN_TAX_I') + rec.get('ADD_TAX_I') - rec.get('RET_IN_TAX_I');
				spTaxIC		= rec.get('DEF_SP_TAX_I');

				if(inTaxIC > 0) {
					rec.set('IN_TAX_I', inTaxIC);
					rec.set('SP_TAX_I', spTaxIC);
				} else{
					if(spTaxIC + inTaxIC > 0) {
						rec.set('IN_TAX_I', 0);
						rec.set('SP_TAX_I', spTaxIC + inTaxIC);
					} else{
						rec.set('IN_TAX_I', 0);
						rec.set('SP_TAX_I', 0);
					}
				}
				
				if(rec.get('INCCODE') == 'C61'|| rec.get('INCCODE') == 'C62'|| rec.get('INCCODE') == 'C63'|| rec.get('INCCODE') == 'C64'|| rec.get('INCCODE') == 'C65'|| 
					   rec.get('INCCODE') == 'C66'|| rec.get('INCCODE') == 'C67'|| rec.get('INCCODE') == 'C68'|| rec.get('INCCODE') == 'C69'
					) {
					sumInTaxI_C70 = sumInTaxI_C70 + parseInt(rec.get("IN_TAX_I"));
					sumSpTaxI_C70 = sumSpTaxI_C70 + parseInt(rec.get("SP_TAX_I"));
				}
				
				if(rec.get('INCCODE') == 'C61')	 rec_C61 = rec;
				if(rec.get('INCCODE') == 'C62')	 rec_C62 = rec;
				if(rec.get('INCCODE') == 'C63')	 rec_C63 = rec;
				if(rec.get('INCCODE') == 'C64')	 rec_C64 = rec;
				if(rec.get('INCCODE') == 'C66')	 rec_C66 = rec;
				if(rec.get('INCCODE') == 'C67')	 rec_C67 = rec;
				if(rec.get('INCCODE') == 'C68')	 rec_C68 = rec;
				if(rec.get('INCCODE') == 'C70')	 rec_C70 = rec;
				
			});
			
			rec_C70.set('IN_TAX_I', sumInTaxI_C70);
			rec_C70.set('SP_TAX_I', sumSpTaxI_C70);
			
			var sum_A70     = parseInt(rec_C66.get('IN_TAX_I')) + parseInt(rec_C67.get('IN_TAX_I'));
			
			var rec_A70     = detailStore1.getAt(detailStore1.find('INCCODE', 'A70'));
			if(rec_A70)	{
				rec_A70.set('IN_TAX_I', sum_A70)
			}
			
			var rec_A40     = detailStore1.getAt(detailStore1.find('INCCODE', 'A40'));
			if(rec_A40)	{
				rec_A40.set('IN_TAX_I', parseInt(A40_ORG['IN_TAX_I']) + parseInt(rec_C68.get('IN_TAX_I')))
			}
			
			var rec_A25     = detailStore1.getAt(detailStore1.find('INCCODE', 'A25'));
			if(rec_A25)	{
				rec_A25.set('IN_TAX_I', parseInt(A25_ORG['IN_TAX_I']) + parseInt(rec_C63.get('IN_TAX_I')) + parseInt(rec_C64.get('IN_TAX_I')) )
			}
			
			// 이자소득
			if(rec_C61 )	{
				rec_C61.set("IN_TAX_I", parseInt(rec_C61.get("DEF_IN_TAX_I")) + parseInt(rec_C61.get("ADD_TAX_I")));
				sumInTaxI_A50 = rec_C61.get("IN_TAX_I");
			}
			
			var rec_A50     = detailStore1.getAt(detailStore1.find('INCCODE', 'A50'))
			if(rec_A50)	{
				rec_A50.set("IN_TAX_I", sumInTaxI_A50);
			}
			
			//배당소득
			if(rec_C62 )	{
				rec_C62.set("IN_TAX_I", parseInt(rec_C62.get("DEF_IN_TAX_I")) + parseInt(rec_C62.get("ADD_TAX_I")));
				sumInTaxI_A60 = rec_C62.get("IN_TAX_I");
			}
			
			var rec_A60     = detailStore1.getAt(detailStore1.find('INCCODE', 'A60'))
			if(rec_A60)	{
				rec_A60.set("IN_TAX_I", sumInTaxI_A60);
			}
		},
		fnCalc4: function(recordAll, editColumn, currRecord, newValue) {	//부표-법인원천 관련
			var sum_C90 = 0;

			Ext.each(recordAll,function (rec, i) {
				if(rec.get('INCCODE') == 'C71'|| rec.get('INCCODE') == 'C72'|| rec.get('INCCODE') == 'C73'|| rec.get('INCCODE') == 'C74'|| rec.get('INCCODE') == 'C75'||
				   rec.get('INCCODE') == 'C76'|| rec.get('INCCODE') == 'C81'|| rec.get('INCCODE') == 'C82'|| rec.get('INCCODE') == 'C83'|| rec.get('INCCODE') == 'C84'||
				   rec.get('INCCODE') == 'C85'|| rec.get('INCCODE') == 'C86'|| rec.get('INCCODE') == 'C87'|| rec.get('INCCODE') == 'C88'
				) {
					sum_C90 = sum_C90 + rec.get(editColumn);
				}
			});

			Ext.each(recordAll,function (rec, i) {
				if(rec.get('INCCODE') == 'C90') {
					rec.set(editColumn,sum_C90);
				}
			});
			
			var rec_A80     = detailStore1.getAt(detailStore1.find('INCCODE', 'A80'));
			if(rec_A80)	{
				rec_A80.set(editColumn, sum_C90 )
			}
			
			if(editColumn == 'DEF_IN_TAX_I'	|| editColumn == 'ADD_TAX_I' || editColumn == 'RET_IN_TAX_I') {
				UniAppManager.app.fnCalcRefunds4(recordAll);
			}
		},
		fnCalcRefunds4: function(recordAll) {								//부표-비거주자   환급금액 관련
			//10.소득세등(가산세포함) = 6.소득세등(+금액만) + 8.가산세 - 9.당월조정환급세액	->(계산한 값이 -금액이면 0) ,  (+금액이면  +금액 set)
			//11.농어촌특별세 =  6.소득세등(+금액만) + 8.가산세 - 9.당월조정환급세액  = -금액이면	 -금액 + 7.농어촌특별세   -> (계산한 값이 -금액이면  0)  ,  (+금액이면  +금액 set)
			//9.당월조정환급세액을 직접 입력시는 계산 X
			Ext.each(recordAll,function (rec, i) {
				var inTaxIC	= 0;
				inTaxIC		= rec.get('DEF_IN_TAX_I') + rec.get('ADD_TAX_I') - rec.get('RET_IN_TAX_I');

				if(inTaxIC > 0) {
					rec.set('IN_TAX_I', inTaxIC);
				} else{
					rec.set('IN_TAX_I', 0);
				}
			});
			var sum_C90 = 0;
			Ext.each(recordAll,function (rec, i) {
				if(rec.get('INCCODE') == 'C71'|| rec.get('INCCODE') == 'C72'|| rec.get('INCCODE') == 'C73'|| rec.get('INCCODE') == 'C74'|| rec.get('INCCODE') == 'C75'||
				   rec.get('INCCODE') == 'C76'|| rec.get('INCCODE') == 'C81'|| rec.get('INCCODE') == 'C82'|| rec.get('INCCODE') == 'C83'|| rec.get('INCCODE') == 'C84'||
				   rec.get('INCCODE') == 'C85'|| rec.get('INCCODE') == 'C86'|| rec.get('INCCODE') == 'C87'|| rec.get('INCCODE') == 'C88'
				) {
					sum_C90 = sum_C90 + rec.get('IN_TAX_I');
				}
			});
			var rec_C90     = detailStore4.getAt(detailStore4.find('INCCODE', 'C90'));
			if(rec_C90)	{
				rec_C90.set('IN_TAX_I', sum_C90 )
			}
			var rec_A80     = detailStore1.getAt(detailStore1.find('INCCODE', 'A80'));
			if(rec_A80)	{
				rec_A80.set('IN_TAX_I', sum_C90 )
			}
		}
	});


	// 신고서 출력
	function openPrintWindow() {
		if (!printWindow) {
			printWindow = Ext.create('widget.uniDetailWindow', {
				title		: '원천징수이행상황 신고서 출력',
				width		: 325,
				height		: 255,
				defaultType	: 'uniTextfield',
				items		: [{
					xtype	: 'uniDetailFormSimple',
					id		: 'printDataForm',
					layout	: {type: 'uniTable', columns: 1},
					items	: [{
						tdAttrs     : {style:'padding-top : 10px;'},
						fieldLabel	: '신고사업장',
						name		: 'DIV_CODE',
						xtype		: 'uniCombobox',
						comboType	: 'BOR120',
						comboCode	: 'BILL',
						allowBlank	: false
					},{
						fieldLabel	: '신고연월',
						xtype		: 'uniMonthfield',
						name		: 'RPT_YYYYMM',
						value		: new Date(),
						allowBlank	: false
					},{
						fieldLabel	: '귀속연월',
						xtype		: 'uniMonthfield',
						name		: 'PAY_YYYYMM',
						value		: new Date(),
						allowBlank	: false
					},{
						fieldLabel	: '지급연월',
						xtype		: 'uniMonthfield',
						name		: 'SUPP_YYYYMM',
						value		: new Date(),
						allowBlank	: false
					},{
						fieldLabel	: '신고구분',
						xtype		: 'uniTextfield',
						name		: 'STATE_TYPE',
						hidden      : true,
						allowBlank	: false
					},{
						fieldLabel	: '작성일자',
						xtype		: 'uniDatefield',
						name		: 'RECEIVE_DATE',
						value		: new Date(),
						allowBlank	: false
					},{	//20200814 추가: 출력물 개발과 관련하여 조건 추가
//						fieldLabel	: '근로소득납부서 등 출력여부',
						fieldLabel	: ' ',
						boxLabel	: '근로소득납부서 등 출력여부',
						xtype		: 'checkbox',
						name		: 'ETC_PRINT_YN',
						value		: 'Y'
					},{	//20200814 수정: 버튼 추가로 인해 팝업 배치, 크기 등 변경
						xtype		: 'container',
						layout		: {type: 'table', columns: 3},
						defaults	: { xtype: 'button' },
						items		: [{
							//20200814 추가: 출력 기능 추가로 버튼 생성
							text	: '출력',
							width	: 90,
							margin	: '0 0 5 15',
							handler	: function(btn) {
								var param	= Ext.getCmp('printDataForm').getValues();
								param.PGM_ID		= 'hpc950ukr';
								param.SUPP_DATE		= param.SUPP_YYYYMM;
								param.WORK_YYYYMM	= param.PAY_YYYYMM;
								
								var win = Ext.create('widget.ClipReport', {
									url		: CPATH+'/human/hpc950clukrPrint.do',
									prgID	: 'hpc950ukr',
									extParam: param
								});
								win.center();
								win.show();
							}
						},{
							text	: '다운로드',
							width	: 90,
							margin	: '0 0 5 5',
							handler	: function(btn) {
								// TODO : do something
								var form		= panelFileDown;
								var winForm    = Ext.getCmp('printDataForm');
								
								form.setValue("DIV_CODE", winForm.getValue("DIV_CODE"));
								form.setValue("RPT_YYYYMM", UniDate.getMonthStr(winForm.getValue("RPT_YYYYMM")));
								form.setValue("PAY_YYYYMM", UniDate.getMonthStr(winForm.getValue("PAY_YYYYMM")));
								form.setValue("SUPP_YYYYMM", UniDate.getMonthStr(winForm.getValue("SUPP_YYYYMM")));
								form.setValue("WORK_DATE", UniDate.getDateStr(winForm.getValue("RECEIVE_DATE")));
								form.setValue("STATE_TYPE", winForm.getValue("STATE_TYPE"));
								form.setValue("RECEIVE_DATE", winForm.getValue("RECEIVE_DATE"));
				
								var param = form.getValues();

								form.submit({
									params	: param,
									success	: function() {
									},
									failure: function(form, action) {
									}
								});
							}
						},{
							text	: '닫기',
							width	: 90,
							margin	: '0 0 5 5',
							handler	: function(btn) {
								printWindow.hide();
							}
						}]
					}]
				}],
				listeners:{
					beforeshow:function(){
						var form = Ext.getCmp('printDataForm');
						form.setValue("DIV_CODE", panelSearch.getValue("DIV_CODE"));
						form.setValue("RPT_YYYYMM", panelSearch.getValue("RPT_YYYYMM"));
						form.setValue("PAY_YYYYMM", panelSearch.getValue("PAY_YYYYMM"));
						form.setValue("SUPP_YYYYMM", panelSearch.getValue("SUPP_YYYYMM"));
						form.setValue("STATE_TYPE", panelSearch.getValue("STATE_TYPE"));
						form.setValue("RECEIVE_DATE", UniDate.add(UniDate.extParseDate(UniDate.get("startOfMonth", panelSearch.getValue("RPT_YYYYMM"))),{"days":10}));
					}
				}
			});
		}
		printWindow.center();
		printWindow.show();
	}

	var panelFileDown = Unilite.createForm('FileDownForm', {
		url				: CPATH+'/human/hpc950ukrExcelDown.do',
		colspan			: 2,
		layout			: {type: 'uniTable', columns: 1},
		height			: 30,
		padding			: '0 0 0 195',
		disabled		: false,
		autoScroll		: false,
		standardSubmit	: true,  
		items:[{
			xtype	: 'uniTextfield',
			name	: 'DIV_CODE'
		},{
			xtype	: 'uniTextfield',
			name	: 'WORK_YYYYMM'		//신고연월		//PAY_YYYYMM-귀속연월	SUPP_DATE-지급연월
		},{
			xtype	: 'uniTextfield',
			name	: 'RPT_YYYYMM'		//신고연월		//PAY_YYYYMM-귀속연월	SUPP_DATE-지급연월
		},{
			xtype	: 'uniTextfield',
			name	: 'PAY_YYYYMM'		//귀속연월		//PAY_YYYYMM-귀속연월	SUPP_DATE-지급연월
		},{
			xtype	: 'uniTextfield',
			name	: 'SUPP_YYYYMM'		//지급연월일
		},{
			xtype	: 'uniTextfield',
			name	: 'STATE_TYPE'		//산고구분
		},{
			xtype	: 'uniTextfield',
			name	: 'WORK_DATE'		//작성일자
		},{
			xtype	: 'uniTextfield',
			name	: 'HOMETAX_ID'		//HOMETAX ID
		}]
	});
	
	//전자파일 자료 다운로드
	var panelFileDown2 = Unilite.createForm('FileDownForm2', {
		url				: CPATH+'/human/hpc950ukrcreateFileDown.do',
		colspan			: 2,
		layout			: {type: 'uniTable', columns: 1},
		height			: 30,
		padding			: '0 0 0 195',
		disabled		: false,
		autoScroll		: false,
		standardSubmit	: true,  
		items:[{
			xtype	: 'uniTextfield',
			name	: 'DIV_CODE'
		},{
			xtype	: 'uniTextfield',
			name	: 'WORK_YYYYMM'		//신고연월		//PAY_YYYYMM-귀속연월	SUPP_DATE-지급연월
		},{
			xtype	: 'uniTextfield',
			name	: 'RPT_YYYYMM'		//신고연월		//PAY_YYYYMM-귀속연월	SUPP_DATE-지급연월
		},{
			xtype	: 'uniTextfield',
			name	: 'PAY_YYYYMM'		//귀속연월		//PAY_YYYYMM-귀속연월	SUPP_DATE-지급연월
		},{
			xtype	: 'uniTextfield',
			name	: 'SUPP_YYYYMM'		//지급연월일
		},{
			xtype	: 'uniTextfield',
			name	: 'STATE_TYPE'		//산고구분
		},{
			xtype	: 'uniTextfield',
			name	: 'WORK_DATE'		//작성일자
		},{
			xtype	: 'uniTextfield',
			name	: 'HOMETAX_ID'		//HOMETAX ID
		}]
	});
	

	/** 원천징수내역
	 */
	Unilite.createValidator('validator01', {
		store	: detailStore1,
		grid	: detailGrid1,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv			= true;
			var recordAll	=  detailStore1.data.items;

			switch(fieldName) {
				case "INCOME_CNT" :
					if(newValue < 0) {
						rv = "0보다 작은 값이 입력되었습니다.";
						break;
					}
					setTimeout(function() {
						UniAppManager.app.fnCalc(recordAll, fieldName, record, newValue);
					}, 50);
					
					setTimeout(function() {
						UniAppManager.app.fnTotalSumCalc();
					}, 55);
				break;

				case "INCOME_SUPP_TOTAL_I" :
					if(newValue < 0) {
						rv = "0보다 작은 값이 입력되었습니다.";
						break;
					}
					setTimeout(function() {
						UniAppManager.app.fnCalc(recordAll, fieldName, record, newValue);
					}, 50);
					
					setTimeout(function() {
						UniAppManager.app.fnTotalSumCalc();
					}, 55);
				break;
				
				case "DEF_IN_TAX_I" :	//6.소득세 등
					//6.소득세 등 , 8.가산세 ,  7.농어촌특별세	컬럼들은 수정시 각 수정된 컬럼 들의 가감계, 총계 를 내고 나서 다음 로직 실행
					//6.소득세 등 , 8.가산세 의 총계는 각 가감계 금액의 +금액들만 더한다  (6.소득세 등 , 8.가산세 들은 -금액이 입력 될수 있음)
					//6.소득세 등, 7.농어촌특별세 중에 -금액들 다 더한다 
					//만약 -금액이 없으면 6.소득세 등 + 7.농어촌특별세  = 10.소득세 등(가산세포함)
					//				7.농어촌특별세 = 11.농어촌특별세 에 각 가감계 라인에 SET
					// 				9.당월 조정 환급세액 = 전부 0
					//만약 -금액이 있으면 A10 의 6.소득세 등 + 8.가산세  금액과 비교시작  ( -금액과 비교 하는 금액은 각 라인의 +금액들과 비교 )
					// -금액을  *-1 하여 양수로 변경해서  6.소득세 등 + 8.가산세  금액과 비교 하였을시  -금액이 크면 6.소득세 등 + 8.가산세  금액을 10.소득세 등 특별세 에 SET
					// -금액(양수로 변경한)에서 6.소득세 등 + 8.가산세  금액을 빼고 남은것으로 7.농어촌특별세 와 비교 하여 -금액의 남은것이 더 클 경우 7.농어촌특별세 금액 = 11.농어촌특별세 금액으로 SET
					// 9.당월조정환급세액 에는  6.소득세 등 + 8.가산세	+ 7.농어촌특별세  값을 SET
					// 각 가감계 라인들과 동일하게 비교 
					//전부 비교하여 SET이 끝나면 9.당월조정환급세액, 10.소득세등(가산세포함), 11.농어촌특별세 들의  각 가감계 계산 후 총계 로직 실행
					//SET 로직 끝나면 원천징수내역의 아래그리드 의 계산 로직 실행
					setTimeout(function() {
						UniAppManager.app.fnCalc(recordAll, fieldName, record, newValue);
					}, 50);

					setTimeout(function() {
						UniAppManager.app.fnTotalSumCalc();
					}, 55);
				break;

				case "DEF_SP_TAX_I" :	//7.농어촌특별세
					setTimeout(function() {
						UniAppManager.app.fnCalc(recordAll, fieldName, record, newValue);
					}, 50);
					
					setTimeout(function() {
						UniAppManager.app.fnTotalSumCalc();
					}, 55);
				break;

				case "ADD_TAX_I" :	//8.가산세
					if(newValue < 0) {
						rv = "0보다 작은 값이 입력되었습니다.";
						break;
					}
					setTimeout(function() {
						UniAppManager.app.fnCalc(recordAll, fieldName, record, newValue);
					}, 50);

					setTimeout(function() {
						UniAppManager.app.fnTotalSumCalc();
					}, 55);
				break;

				case "RET_IN_TAX_I" :	//9.당월조정환급세액
					if(newValue < 0) {
						rv = "0보다 작은 값이 입력되었습니다.";
						break;
					}
					//원천징수내역 에서 9.당월조정환급세액을 직접 입력시 기존의 금액보다 큰금액 입력시  "입력할수 있는 값이 초과 되었습니다."
					if(newValue > oldValue) {
						rv = "입력할수 있는 값이 초과 되었습니다.";
						break;
					}

					setTimeout(function() {
						UniAppManager.app.fnCalc(recordAll, fieldName, record, newValue);
					}, 50);

					setTimeout(function() {
						UniAppManager.app.fnTotalSumCalc();
					}, 55);

					setTimeout(function() {
						// 9.당월조정 환급세액 총합계를 19.당월조정환급액계에 set 하고 18. - 19. 을  20. 에 set
						var tempI = 0;
						Ext.each(recordAll,function (rec, i) {
							if(rec.get('INCCODE') == 'A99') {
								tempI = rec.get('RET_IN_TAX_I');
							}
						});
						var subRecord = detailStore1_2.data.items[0];
						subRecord.set('TOTAL_IN_TAX_I'	, tempI);
						subRecord.set('NEXT_IN_TAX_I'	, subRecord.get('ROW_IN_TAX_I') - tempI);
					}, 60);
				break;
			}
			return rv;
		}
	});

	Unilite.createValidator('validator01_2', {
		store	: detailStore1_2,
		grid	: detailGrid1_2,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv			= true;
			var recordAll	=  detailStore1.data.items;

			switch(fieldName) {
				case "LAST_IN_TAX_I" :
				case "BEFORE_IN_TAX_I" :
				case "TRUST_AMT" :
				case "FIN_COMP_AMT" :
				case "MERGER_AMT" :
					setTimeout(function() {	
						// 6. 7. 8. 9. 10. 11. 들의 관계 로직 시작
						var defInTaxIMi = 0; //6.소득세등 의 마이너스 금액들관련
						var defSpTaxIMi = 0; //7.농어촌특별세 의 마이너스 금액들관련
						var defTaxICalc = 0;

						Ext.each(recordAll,function (rec, i) {
							if(rec.get('INCCODE') == 'A10' ||
								rec.get('INCCODE') == 'A20' ||
								rec.get('INCCODE') == 'A30' ||
								rec.get('INCCODE') == 'A40' ||
								rec.get('INCCODE') == 'A47' ||
								rec.get('INCCODE') == 'A50' ||
								rec.get('INCCODE') == 'A60' ||
								rec.get('INCCODE') == 'A69' ||
								rec.get('INCCODE') == 'A70' ||
								rec.get('INCCODE') == 'A80' ||
								rec.get('INCCODE') == 'A90'
							) {
								if(rec.get('DEF_IN_TAX_I') < 0) {
									defInTaxIMi = defInTaxIMi + rec.get('DEF_IN_TAX_I');
								} else if(rec.get('DEF_SP_TAX_I') < 0) {
									defSpTaxIMi = defSpTaxIMi + rec.get('DEF_SP_TAX_I');
								}
							}
						});
						defTaxICalc = defInTaxIMi + defSpTaxIMi;
						defTaxICalc = defTaxICalc * -1;  //아래 그리드에 계산 로직실행후 비교하기 위해 양수로 변경

						//defTaxICalc  환급이 되어야 하는 금액은  원천징수내역의 아래 그리드에서 계산된 금액으로 변경 되어야 한다
						//로직시작전, 아래그리드에 15.일반환급에 환급받을 -금액을 +금액으로 set 하고 아래 그리드 계산로직대로 계산후
						//18.조정대상환급  금액으로 위의 그리드 계산 로직을 돌린다 
						//만약 18.조정대상환급 의  값이 -금액이 나올경우 위의 그리드에서 환급 금액이 없는 것처럼 계산을 돌리면 된다.
						//계산 로직 실행후 9.당월조정환급세액 총합계 값을 19.당월조정환급액계에 set 하고 20.차월이월환급액 (18-19) 로직대로 set 한다 
						//만약 아래 그리드 값을 입력 하면  위의 그리드 6. 7. 값들의 -금액들의 합을(환급 받을 금액) 15.일반환급 에 set 하고 아래그리드 로직 시행후 18.조정대상환급 값으로 위의 그리드 로직 시행후 19.set 20.set 한다 
						var defTaxICalcPl = 0;
						var subRecord = detailStore1_2.data.items[0];

						subRecord.set('RET_AMT',defTaxICalc);		// 15. set
						subRecord.set('BAL_AMT',subRecord.get('LAST_IN_TAX_I') - subRecord.get('BEFORE_IN_TAX_I'));	// 14. set
						subRecord.set('ROW_IN_TAX_I', subRecord.get('LAST_IN_TAX_I') - subRecord.get('BEFORE_IN_TAX_I') + defTaxICalc + subRecord.get('TRUST_AMT') + subRecord.get('FIN_COMP_AMT') + subRecord.get('MERGER_AMT'));	//18. set
					
						defTaxICalcPl = subRecord.get('LAST_IN_TAX_I') - subRecord.get('BEFORE_IN_TAX_I') + defTaxICalc + subRecord.get('TRUST_AMT') + subRecord.get('FIN_COMP_AMT') + subRecord.get('MERGER_AMT');
						var totalInTaxI = 0;

						Ext.each(recordAll,function (rec, i) {
							if(rec.get('INCCODE') == 'A10' ||
								rec.get('INCCODE') == 'A20' ||
								rec.get('INCCODE') == 'A30' ||
								rec.get('INCCODE') == 'A40' ||
								rec.get('INCCODE') == 'A47' ||
								rec.get('INCCODE') == 'A50' ||
								rec.get('INCCODE') == 'A60' ||
								rec.get('INCCODE') == 'A69' ||
								rec.get('INCCODE') == 'A70' ||
								rec.get('INCCODE') == 'A80' 
							) {
								totalInTaxI = totalInTaxI + rec.get('RET_IN_TAX_I');
							}
						});
						subRecord.set('TOTAL_IN_TAX_I', totalInTaxI);
						subRecord.set('NEXT_IN_TAX_I', defTaxICalcPl - totalInTaxI);

						if(defTaxICalcPl > 0 ) {		// 환급받을금액이 있을시  (	6.소득세등	, 7.농어촌특별세 금액들 안에 -금액이 있을시 )
							var a10YN = 'N';
							var a20YN = 'N';
							var a30YN = 'N';
							var a40YN = 'N';
							var a47YN = 'N';
							var a50YN = 'N';
							var a60YN = 'N';
							var a69YN = 'N';
							var a70YN = 'N';
							var a80YN = 'N';

							var a10YN_Sub = 'N';
							var a20YN_Sub = 'N';
							var a30YN_Sub = 'N';
							var a40YN_Sub = 'N';
							var a47YN_Sub = 'N';
							var a50YN_Sub = 'N';
							var a60YN_Sub = 'N';
							var a69YN_Sub = 'N';
							var a70YN_Sub = 'N';
							var a80YN_Sub = 'N';

							var defTaxICalc_A10 = 0;
							defTaxICalc_A10 = defTaxICalcPl;

							var defTaxICalc_A20 = 0;
							var defTaxICalc_A30 = 0;
							var defTaxICalc_A40 = 0;
							var defTaxICalc_A47 = 0;
							var defTaxICalc_A50 = 0;
							var defTaxICalc_A60 = 0;
							var defTaxICalc_A69 = 0;
							var defTaxICalc_A70 = 0;
							var defTaxICalc_A80 = 0;

							Ext.each(recordAll,function (rec, i) {
								if(rec.get('INCCODE') == 'A10') {
									a10YN_Sub				= 'Y';
									var defInTaxI_CalcA10	= 0; 
									defInTaxI_CalcA10		= Ext.isEmpty(rec.get('DEF_IN_TAX_I')) ? 0 : rec.get('DEF_IN_TAX_I') < 0 ? 0 : rec.get('DEF_IN_TAX_I');
									var addTaxI_CalcA10		= 0;
									addTaxI_CalcA10			= Ext.isEmpty(rec.get('ADD_TAX_I')) ? 0 : rec.get('ADD_TAX_I');
									var defSpTaxI_CalcA10	= 0;
									defSpTaxI_CalcA10		= Ext.isEmpty(rec.get('DEF_SP_TAX_I')) ? 0 : rec.get('DEF_SP_TAX_I') < 0 ? 0 : rec.get('DEF_SP_TAX_I');

									if(defTaxICalc_A10 >= defInTaxI_CalcA10 + addTaxI_CalcA10) {	//6. , 7. 들의 -금액의 가감계들의 합이  (*-1 하여 플러스로 변경한 금액)   A10의 6. , 8. 의 +금액들의 합보다 크거나 같을때
										rec.set('IN_TAX_I',0);  //0을 10. 에 SET

										if(defTaxICalc_A10 - (defInTaxI_CalcA10 + addTaxI_CalcA10) >= defSpTaxI_CalcA10) {// 6. , 7. 들의 -금액의 가감계들의 합(*-1 하여 플러스로 변경한 금액) 으로 A10의 6. , 8. 의 +금액들의 합을 뺀 금액이 7. 의 금액보다 크거나 같을때 
											rec.set('SP_TAX_I',0);  //0 을  11. 에 SET
											rec.set('RET_IN_TAX_I',defInTaxI_CalcA10 + addTaxI_CalcA10 + defSpTaxI_CalcA10);  //A10의 6. 7. 8. 금액들의 합을 9.에 SET

											if(defTaxICalc_A10 - (defInTaxI_CalcA10 + addTaxI_CalcA10 + defSpTaxI_CalcA10) > 0) {	//환급받을 금액이 남았음
												a10YN = 'Y';	//다음 비교로 (A20으로 ) 넘어감
												defTaxICalc_A20 = defTaxICalc_A10 - (defInTaxI_CalcA10 + addTaxI_CalcA10 + defSpTaxI_CalcA10);
											}
										} else {  // 6. , 7. 들의 -금액의 가감계들의 합(*-1 하여 플러스로 변경한 금액) 으로 A10의 6. , 8. 의 +금액들의 합을 뺀 금액이 7. 의 금액보다 작을때
											rec.set('SP_TAX_I',defSpTaxI_CalcA10 - (defTaxICalc_A10 - (defInTaxI_CalcA10 + addTaxI_CalcA10)));  // A10의 11. 금액  -  6. , 7. 들의 -금액의 가감계들의 합(*-1 하여 플러스로 변경한 금액) 으로 A10의 6. , 8. 의 +금액들의 합   을  11. 에 SET
											rec.set('RET_IN_TAX_I',defTaxICalc_A10);  //환급받을금액 9.에 SET
										}
									} else {			//6. , 7. 들의 -금액의 가감계들의 합이  (*-1 하여 플러스로 변경한 금액)   A10의 6. , 8. 의 +금액들의 합보다 작을때
										rec.set('IN_TAX_I',(defInTaxI_CalcA10 + addTaxI_CalcA10) - defTaxICalc_A10);  //A10의 (6. + 8.)  -  6. , 7. 들의 -금액의 가감계들의 합  (*-1 하여 플러스로 변경한 금액)을   10. 에 SET
										rec.set('SP_TAX_I',defSpTaxI_CalcA10 );//A10의  7. 금액을 11.에 SET
										rec.set('RET_IN_TAX_I',defTaxICalc_A10);  //6. , 7. 들의 -금액의 가감계들의 합  (*-1 하여 플러스로 변경한 금액) 을 9. 에 SET
									}
								} else if(rec.get('INCCODE') == 'A20' && a10YN == 'Y') {
									a20YN_Sub = 'Y';
									var defInTaxI_CalcA20 = 0; 
									defInTaxI_CalcA20 = Ext.isEmpty(rec.get('DEF_IN_TAX_I')) ? 0 : rec.get('DEF_IN_TAX_I') < 0 ? 0 : rec.get('DEF_IN_TAX_I');
									var addTaxI_CalcA20 = 0;
									addTaxI_CalcA20 = Ext.isEmpty(rec.get('ADD_TAX_I')) ? 0 : rec.get('ADD_TAX_I');
									var defSpTaxI_CalcA20 = 0;
									defSpTaxI_CalcA20 = Ext.isEmpty(rec.get('DEF_SP_TAX_I')) ? 0 : rec.get('DEF_SP_TAX_I') < 0 ? 0 : rec.get('DEF_SP_TAX_I');

									if(defTaxICalc_A20 >= defInTaxI_CalcA20 + addTaxI_CalcA20) {
										rec.set('IN_TAX_I',0);

										if(defTaxICalc_A20 - (defInTaxI_CalcA20 + addTaxI_CalcA20) >= defSpTaxI_CalcA20) {
											rec.set('SP_TAX_I',0);
											rec.set('RET_IN_TAX_I',defInTaxI_CalcA20 + addTaxI_CalcA20 + defSpTaxI_CalcA20);

											if(defTaxICalc_A20 - (defInTaxI_CalcA20 + addTaxI_CalcA20 + defSpTaxI_CalcA20) > 0) {
												a20YN = 'Y';
												defTaxICalc_A30 = defTaxICalc_A20 - (defInTaxI_CalcA20 + addTaxI_CalcA20 + defSpTaxI_CalcA20);
											}
										} else {
											rec.set('SP_TAX_I',defSpTaxI_CalcA20 - (defTaxICalc_A20 - (defInTaxI_CalcA20 + addTaxI_CalcA20)));
											rec.set('RET_IN_TAX_I',defTaxICalc_A20);
										}
									} else {
										rec.set('IN_TAX_I',(defInTaxI_CalcA20 + addTaxI_CalcA20) - defTaxICalc_A20);
										rec.set('SP_TAX_I',defSpTaxI_CalcA20 );
										rec.set('RET_IN_TAX_I',defTaxICalc_A20);
									}
								} else if(rec.get('INCCODE') == 'A30' && a20YN == 'Y') {
									a30YN_Sub = 'Y';
									var defInTaxI_CalcA30 = 0; 
									defInTaxI_CalcA30 = Ext.isEmpty(rec.get('DEF_IN_TAX_I')) ? 0 : rec.get('DEF_IN_TAX_I') < 0 ? 0 : rec.get('DEF_IN_TAX_I');
									var addTaxI_CalcA30 = 0;
									addTaxI_CalcA30 = Ext.isEmpty(rec.get('ADD_TAX_I')) ? 0 : rec.get('ADD_TAX_I');
									var defSpTaxI_CalcA30 = 0;
									defSpTaxI_CalcA30 = Ext.isEmpty(rec.get('DEF_SP_TAX_I')) ? 0 : rec.get('DEF_SP_TAX_I') < 0 ? 0 : rec.get('DEF_SP_TAX_I');

									if(defTaxICalc_A30 >= defInTaxI_CalcA30 + addTaxI_CalcA30) {
										rec.set('IN_TAX_I',0);

										if(defTaxICalc_A30 - (defInTaxI_CalcA30 + addTaxI_CalcA30) >= defSpTaxI_CalcA30) {
											rec.set('SP_TAX_I',0);
											rec.set('RET_IN_TAX_I',defInTaxI_CalcA30 + addTaxI_CalcA30 + defSpTaxI_CalcA30);

											if(defTaxICalc_A30 - (defInTaxI_CalcA30 + addTaxI_CalcA30 + defSpTaxI_CalcA30) > 0) {
												a30YN = 'Y';
												defTaxICalc_A40 = defTaxICalc_A30 - (defInTaxI_CalcA30 + addTaxI_CalcA30 + defSpTaxI_CalcA30);
											}
										} else {
											rec.set('SP_TAX_I',defSpTaxI_CalcA30 - (defTaxICalc_A30 - (defInTaxI_CalcA30 + addTaxI_CalcA30)));
											rec.set('RET_IN_TAX_I',defTaxICalc_A30);
										}
									} else {
										rec.set('IN_TAX_I',(defInTaxI_CalcA30 + addTaxI_CalcA30) - defTaxICalc_A30);
										rec.set('SP_TAX_I',defSpTaxI_CalcA30 );
										rec.set('RET_IN_TAX_I',defTaxICalc_A30);
									}
								} else if(rec.get('INCCODE') == 'A40' && a30YN == 'Y') {
									a40YN_Sub = 'Y';
									var defInTaxI_CalcA40 = 0; 
									defInTaxI_CalcA40 = Ext.isEmpty(rec.get('DEF_IN_TAX_I')) ? 0 : rec.get('DEF_IN_TAX_I') < 0 ? 0 : rec.get('DEF_IN_TAX_I');
									var addTaxI_CalcA40 = 0;
									addTaxI_CalcA40 = Ext.isEmpty(rec.get('ADD_TAX_I')) ? 0 : rec.get('ADD_TAX_I');
									var defSpTaxI_CalcA40 = 0;
									defSpTaxI_CalcA40 = Ext.isEmpty(rec.get('DEF_SP_TAX_I')) ? 0 : rec.get('DEF_SP_TAX_I') < 0 ? 0 : rec.get('DEF_SP_TAX_I');

									if(defTaxICalc_A40 >= defInTaxI_CalcA40 + addTaxI_CalcA40) {
										rec.set('IN_TAX_I',0);

										if(defTaxICalc_A40 - (defInTaxI_CalcA40 + addTaxI_CalcA40) >= defSpTaxI_CalcA40) {
											rec.set('SP_TAX_I',0);
											rec.set('RET_IN_TAX_I',defInTaxI_CalcA40 + addTaxI_CalcA40 + defSpTaxI_CalcA40);

											if(defTaxICalc_A40 - (defInTaxI_CalcA40 + addTaxI_CalcA40 + defSpTaxI_CalcA40) > 0) {
												a40YN = 'Y';
												defTaxICalc_A47 = defTaxICalc_A40 - (defInTaxI_CalcA40 + addTaxI_CalcA40 + defSpTaxI_CalcA40);
											}
										} else {
											rec.set('SP_TAX_I',defSpTaxI_CalcA40 - (defTaxICalc_A40 - (defInTaxI_CalcA40 + addTaxI_CalcA40)));
											rec.set('RET_IN_TAX_I',defTaxICalc_A40);
										}
									} else {
										rec.set('IN_TAX_I',(defInTaxI_CalcA40 + addTaxI_CalcA40) - defTaxICalc_A40);
										rec.set('SP_TAX_I',defSpTaxI_CalcA40 );
										rec.set('RET_IN_TAX_I',defTaxICalc_A40);
									}
								} else if(rec.get('INCCODE') == 'A47' && a40YN == 'Y') {
									a47YN_Sub = 'Y';
									var defInTaxI_CalcA47 = 0; 
									defInTaxI_CalcA47 = Ext.isEmpty(rec.get('DEF_IN_TAX_I')) ? 0 : rec.get('DEF_IN_TAX_I') < 0 ? 0 : rec.get('DEF_IN_TAX_I');
									var addTaxI_CalcA47 = 0;
									addTaxI_CalcA47 = Ext.isEmpty(rec.get('ADD_TAX_I')) ? 0 : rec.get('ADD_TAX_I');
									var defSpTaxI_CalcA47 = 0;
									defSpTaxI_CalcA47 = Ext.isEmpty(rec.get('DEF_SP_TAX_I')) ? 0 : rec.get('DEF_SP_TAX_I') < 0 ? 0 : rec.get('DEF_SP_TAX_I');

									if(defTaxICalc_A47 >= defInTaxI_CalcA47 + addTaxI_CalcA47) {
										rec.set('IN_TAX_I',0);

										if(defTaxICalc_A47 - (defInTaxI_CalcA47 + addTaxI_CalcA47) >= defSpTaxI_CalcA47) {
											rec.set('SP_TAX_I',0);
											rec.set('RET_IN_TAX_I',defInTaxI_CalcA47 + addTaxI_CalcA47 + defSpTaxI_CalcA47);

											if(defTaxICalc_A47 - (defInTaxI_CalcA47 + addTaxI_CalcA47 + defSpTaxI_CalcA47) > 0) {
												a47YN = 'Y';
												defTaxICalc_A50 = defTaxICalc_A47 - (defInTaxI_CalcA47 + addTaxI_CalcA47 + defSpTaxI_CalcA47);
											}
										} else {
											rec.set('SP_TAX_I',defSpTaxI_CalcA47 - (defTaxICalc_A47 - (defInTaxI_CalcA47 + addTaxI_CalcA47)));
											rec.set('RET_IN_TAX_I',defTaxICalc_A47);
										}
									} else {
										rec.set('IN_TAX_I',(defInTaxI_CalcA47 + addTaxI_CalcA47) - defTaxICalc_A47);
										rec.set('SP_TAX_I',defSpTaxI_CalcA47 );
										rec.set('RET_IN_TAX_I',defTaxICalc_A47);
									}
								} else if(rec.get('INCCODE') == 'A50' && a47YN == 'Y') {
									a50YN_Sub = 'Y';
									var defInTaxI_CalcA50 = 0; 
									defInTaxI_CalcA50 = Ext.isEmpty(rec.get('DEF_IN_TAX_I')) ? 0 : rec.get('DEF_IN_TAX_I') < 0 ? 0 : rec.get('DEF_IN_TAX_I');
									var addTaxI_CalcA50 = 0;
									addTaxI_CalcA50 = Ext.isEmpty(rec.get('ADD_TAX_I')) ? 0 : rec.get('ADD_TAX_I');
									var defSpTaxI_CalcA50 = 0;
									defSpTaxI_CalcA50 = Ext.isEmpty(rec.get('DEF_SP_TAX_I')) ? 0 : rec.get('DEF_SP_TAX_I') < 0 ? 0 : rec.get('DEF_SP_TAX_I');

									if(defTaxICalc_A50 >= defInTaxI_CalcA50 + addTaxI_CalcA50) {
										rec.set('IN_TAX_I',0);

										if(defTaxICalc_A50 - (defInTaxI_CalcA50 + addTaxI_CalcA50) >= defSpTaxI_CalcA50) {
											rec.set('SP_TAX_I',0);
											rec.set('RET_IN_TAX_I',defInTaxI_CalcA50 + addTaxI_CalcA50 + defSpTaxI_CalcA50);

											if(defTaxICalc_A50 - (defInTaxI_CalcA50 + addTaxI_CalcA50 + defSpTaxI_CalcA50) > 0) {
												a50YN = 'Y';
												defTaxICalc_A60 = defTaxICalc_A50 - (defInTaxI_CalcA50 + addTaxI_CalcA50 + defSpTaxI_CalcA50);
											}
										} else {
											rec.set('SP_TAX_I',defSpTaxI_CalcA50 - (defTaxICalc_A50 - (defInTaxI_CalcA50 + addTaxI_CalcA50)));
											rec.set('RET_IN_TAX_I',defTaxICalc_A50);
										}
									} else {
										rec.set('IN_TAX_I',(defInTaxI_CalcA50 + addTaxI_CalcA50) - defTaxICalc_A50);
										rec.set('SP_TAX_I',defSpTaxI_CalcA50 );
										rec.set('RET_IN_TAX_I',defTaxICalc_A50);
									}
								} else if(rec.get('INCCODE') == 'A60' && a50YN == 'Y') {
									a60YN_Sub = 'Y';
									var defInTaxI_CalcA60 = 0; 
									defInTaxI_CalcA60 = Ext.isEmpty(rec.get('DEF_IN_TAX_I')) ? 0 : rec.get('DEF_IN_TAX_I') < 0 ? 0 : rec.get('DEF_IN_TAX_I');
									var addTaxI_CalcA60 = 0;
									addTaxI_CalcA60 = Ext.isEmpty(rec.get('ADD_TAX_I')) ? 0 : rec.get('ADD_TAX_I');
									var defSpTaxI_CalcA60 = 0;
									defSpTaxI_CalcA60 = Ext.isEmpty(rec.get('DEF_SP_TAX_I')) ? 0 : rec.get('DEF_SP_TAX_I') < 0 ? 0 : rec.get('DEF_SP_TAX_I');

									if(defTaxICalc_A60 >= defInTaxI_CalcA60 + addTaxI_CalcA60) {
										rec.set('IN_TAX_I',0);

										if(defTaxICalc_A60 - (defInTaxI_CalcA60 + addTaxI_CalcA60) >= defSpTaxI_CalcA60) {
											rec.set('SP_TAX_I',0);
											rec.set('RET_IN_TAX_I',defInTaxI_CalcA60 + addTaxI_CalcA60 + defSpTaxI_CalcA60);

											if(defTaxICalc_A60 - (defInTaxI_CalcA60 + addTaxI_CalcA60 + defSpTaxI_CalcA60) > 0) {
												a60YN = 'Y';
												defTaxICalc_A69 = defTaxICalc_A60 - (defInTaxI_CalcA60 + addTaxI_CalcA60 + defSpTaxI_CalcA60);
											}
										} else {
											rec.set('SP_TAX_I',defSpTaxI_CalcA60 - (defTaxICalc_A60 - (defInTaxI_CalcA60 + addTaxI_CalcA60)));
											rec.set('RET_IN_TAX_I',defTaxICalc_A60);
										}
									} else {
										rec.set('IN_TAX_I',(defInTaxI_CalcA60 + addTaxI_CalcA60) - defTaxICalc_A60);
										rec.set('SP_TAX_I',defSpTaxI_CalcA60 );
										rec.set('RET_IN_TAX_I',defTaxICalc_A60);
									}
								} else if(rec.get('INCCODE') == 'A69' && a60YN == 'Y') {
									a69YN_Sub = 'Y';
									var defInTaxI_CalcA69 = 0; 
									defInTaxI_CalcA69 = Ext.isEmpty(rec.get('DEF_IN_TAX_I')) ? 0 : rec.get('DEF_IN_TAX_I') < 0 ? 0 : rec.get('DEF_IN_TAX_I');
									var addTaxI_CalcA69 = 0;
									addTaxI_CalcA69 = Ext.isEmpty(rec.get('ADD_TAX_I')) ? 0 : rec.get('ADD_TAX_I');
									var defSpTaxI_CalcA69 = 0;
									defSpTaxI_CalcA69 = Ext.isEmpty(rec.get('DEF_SP_TAX_I')) ? 0 : rec.get('DEF_SP_TAX_I') < 0 ? 0 : rec.get('DEF_SP_TAX_I');

									if(defTaxICalc_A69 >= defInTaxI_CalcA69 + addTaxI_CalcA69) {
										rec.set('IN_TAX_I',0);

										if(defTaxICalc_A69 - (defInTaxI_CalcA69 + addTaxI_CalcA69) >= defSpTaxI_CalcA69) {
											rec.set('SP_TAX_I',0);
											rec.set('RET_IN_TAX_I',defInTaxI_CalcA69 + addTaxI_CalcA69 + defSpTaxI_CalcA69);

											if(defTaxICalc_A69 - (defInTaxI_CalcA69 + addTaxI_CalcA69 + defSpTaxI_CalcA69) > 0) {
												a69YN = 'Y';
												defTaxICalc_A70 = defTaxICalc_A69 - (defInTaxI_CalcA69 + addTaxI_CalcA69 + defSpTaxI_CalcA69);
											}
										} else {
											rec.set('SP_TAX_I',defSpTaxI_CalcA69 - (defTaxICalc_A69 - (defInTaxI_CalcA69 + addTaxI_CalcA69)));
											rec.set('RET_IN_TAX_I',defTaxICalc_A69);
										}
									} else {
										rec.set('IN_TAX_I',(defInTaxI_CalcA69 + addTaxI_CalcA69) - defTaxICalc_A69);
										rec.set('SP_TAX_I',defSpTaxI_CalcA69 );
										rec.set('RET_IN_TAX_I',defTaxICalc_A69);
									}
								} else if(rec.get('INCCODE') == 'A70' && a69YN == 'Y') {
									a70YN_Sub = 'Y';
									var defInTaxI_CalcA70 = 0; 
									defInTaxI_CalcA70 = Ext.isEmpty(rec.get('DEF_IN_TAX_I')) ? 0 : rec.get('DEF_IN_TAX_I') < 0 ? 0 : rec.get('DEF_IN_TAX_I');
									var addTaxI_CalcA70 = 0;
									addTaxI_CalcA70 = Ext.isEmpty(rec.get('ADD_TAX_I')) ? 0 : rec.get('ADD_TAX_I');
									var defSpTaxI_CalcA70 = 0;
									defSpTaxI_CalcA70 = Ext.isEmpty(rec.get('DEF_SP_TAX_I')) ? 0 : rec.get('DEF_SP_TAX_I') < 0 ? 0 : rec.get('DEF_SP_TAX_I');

									if(defTaxICalc_A70 >= defInTaxI_CalcA70 + addTaxI_CalcA70) {
										rec.set('IN_TAX_I',0);

										if(defTaxICalc_A70 - (defInTaxI_CalcA70 + addTaxI_CalcA70) >= defSpTaxI_CalcA70) {
											rec.set('SP_TAX_I',0);
											rec.set('RET_IN_TAX_I',defInTaxI_CalcA70 + addTaxI_CalcA70 + defSpTaxI_CalcA70);

											if(defTaxICalc_A70 - (defInTaxI_CalcA70 + addTaxI_CalcA70 + defSpTaxI_CalcA70) > 0) {
												a70YN = 'Y';
												defTaxICalc_A80 = defTaxICalc_A70 - (defInTaxI_CalcA70 + addTaxI_CalcA70 + defSpTaxI_CalcA70);
											}
										} else {
											rec.set('SP_TAX_I',defSpTaxI_CalcA70 - (defTaxICalc_A70 - (defInTaxI_CalcA70 + addTaxI_CalcA70)));
											rec.set('RET_IN_TAX_I',defTaxICalc_A70);
										}
									} else {
										rec.set('IN_TAX_I',(defInTaxI_CalcA70 + addTaxI_CalcA70) - defTaxICalc_A70);
										rec.set('SP_TAX_I',defSpTaxI_CalcA70 );
										rec.set('RET_IN_TAX_I',defTaxICalc_A70);
									}
								} else if(rec.get('INCCODE') == 'A80' && a70YN == 'Y') {
									a80YN_Sub = 'Y';
									var defInTaxI_CalcA80 = 0; 
									defInTaxI_CalcA80 = Ext.isEmpty(rec.get('DEF_IN_TAX_I')) ? 0 : rec.get('DEF_IN_TAX_I') < 0 ? 0 : rec.get('DEF_IN_TAX_I');
									var addTaxI_CalcA80 = 0;
									addTaxI_CalcA80 = Ext.isEmpty(rec.get('ADD_TAX_I')) ? 0 : rec.get('ADD_TAX_I');
									var defSpTaxI_CalcA80 = 0;
									defSpTaxI_CalcA80 = Ext.isEmpty(rec.get('DEF_SP_TAX_I')) ? 0 : rec.get('DEF_SP_TAX_I') < 0 ? 0 : rec.get('DEF_SP_TAX_I');

									if(defTaxICalc_A80 >= defInTaxI_CalcA80 + addTaxI_CalcA80) {
										rec.set('IN_TAX_I',0);

										if(defTaxICalc_A80 - (defInTaxI_CalcA80 + addTaxI_CalcA80) >= defSpTaxI_CalcA80) {
											rec.set('SP_TAX_I',0);
											rec.set('RET_IN_TAX_I',defInTaxI_CalcA80 + addTaxI_CalcA80 + defSpTaxI_CalcA80);

											if(defTaxICalc_A80 - (defInTaxI_CalcA80 + addTaxI_CalcA80 + defSpTaxI_CalcA80) > 0) {
												a80YN = 'Y';
												//defTaxICalc_A90 = defTaxICalc_A80 - (defInTaxI_CalcA80 + addTaxI_CalcA80 + defSpTaxI_CalcA80);
											}
										} else {
											rec.set('SP_TAX_I',defSpTaxI_CalcA80 - (defTaxICalc_A80 - (defInTaxI_CalcA80 + addTaxI_CalcA80)));
											rec.set('RET_IN_TAX_I',defTaxICalc_A80);
										}
									} else {
										rec.set('IN_TAX_I',(defInTaxI_CalcA80 + addTaxI_CalcA80) - defTaxICalc_A80);
										rec.set('SP_TAX_I',defSpTaxI_CalcA80 );
										rec.set('RET_IN_TAX_I',defTaxICalc_A80);
									}
								}
	//						}
							});
							UniAppManager.app.fnSubCalc(recordAll,a10YN_Sub,a20YN_Sub,a30YN_Sub,a40YN_Sub,a47YN_Sub,a50YN_Sub,a60YN_Sub,a69YN_Sub,a70YN_Sub,a80YN_Sub);
						} else{						// 환급받을금액이 없을시 
							var a10YN_Sub = 'N';
							var a20YN_Sub = 'N';
							var a30YN_Sub = 'N';
							var a40YN_Sub = 'N';
							var a47YN_Sub = 'N';
							var a50YN_Sub = 'N';
							var a60YN_Sub = 'N';
							var a69YN_Sub = 'N';
							var a70YN_Sub = 'N';
							var a80YN_Sub = 'N';
							UniAppManager.app.fnSubCalc(recordAll,a10YN_Sub,a20YN_Sub,a30YN_Sub,a40YN_Sub,a47YN_Sub,a50YN_Sub,a60YN_Sub,a69YN_Sub,a70YN_Sub,a80YN_Sub);
						}
						//19.당월조정 환급액계 set
						var totalInTaxI = 0;
						Ext.each(recordAll,function (rec, i) {
							if(rec.get('INCCODE') == 'A10' ||
								rec.get('INCCODE') == 'A20' ||
								rec.get('INCCODE') == 'A30' ||
								rec.get('INCCODE') == 'A40' ||
								rec.get('INCCODE') == 'A47' ||
								rec.get('INCCODE') == 'A50' ||
								rec.get('INCCODE') == 'A60' ||
								rec.get('INCCODE') == 'A69' ||
								rec.get('INCCODE') == 'A70' ||
								rec.get('INCCODE') == 'A80' 
							) {
								totalInTaxI = totalInTaxI + rec.get('RET_IN_TAX_I');
							}
						});
						subRecord.set('TOTAL_IN_TAX_I', totalInTaxI);
						subRecord.set('NEXT_IN_TAX_I', defTaxICalcPl - totalInTaxI);
					}, 50);

					setTimeout(function() {
						UniAppManager.app.fnTotalSumCalc();
					}, 55);
				break;

				case "RET_IN_TAX_I" : 
					if(newValue > record.get('NEXT_IN_TAX_I')) {
						rv = "(21.환급 신청액) 이 (20.차월이월 환급액) 보다 큽니다.";
						break;
					}
				break;
			}
			return rv;
		}
	});

	/** 부표자-거주자
	 */
	Unilite.createValidator('validator02', {
		store	: detailStore2,
		grid	: detailGrid2,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv			= true;
			var recordAll	= detailStore2.data.items;

			switch(fieldName) {
				case "INCOME_CNT" :
					if(newValue < 0) {
						rv = "0보다 작은 값이 입력되었습니다.";
						break;
					}
					setTimeout(function() {
						UniAppManager.app.fnCalc2(recordAll, fieldName, record, newValue);
					}, 50);
				break;

				case "INCOME_SUPP_TOTAL_I" :
					if(newValue < 0) {
						rv = "0보다 작은 값이 입력되었습니다.";
						break;
					}
					setTimeout(function() {
						UniAppManager.app.fnCalc2(recordAll, fieldName, record, newValue);
					}, 50);
				break;

				case "DEF_IN_TAX_I" :	//6.소득세 등
					setTimeout(function() {
						UniAppManager.app.fnCalc2(recordAll, fieldName, record, newValue);
					}, 50);
				break;

				case "DEF_SP_TAX_I" :	//7.농어촌특별세
					setTimeout(function() {
						UniAppManager.app.fnCalc2(recordAll, fieldName, record, newValue);
					}, 50);
				break;

				case "ADD_TAX_I" :	//8.가산세
					if(newValue < 0) {
						rv = "0보다 작은 값이 입력되었습니다.";
						break;
					}
					setTimeout(function() {
						UniAppManager.app.fnCalc2(recordAll, fieldName, record, newValue);
					}, 50);
				break;

				case "RET_IN_TAX_I" :	//9.당월조정환급세액
					if(newValue < 0) {
						rv = "0보다 작은 값이 입력되었습니다.";
						break;
					}
					setTimeout(function() {
						UniAppManager.app.fnCalcRefunds2(recordAll);
					}, 50);
				break;
			}
			return rv;
		}
	});

	/** 부표자-비거주자
	 */
	Unilite.createValidator('validator03', {
		store	: detailStore3,
		grid	: detailGrid3,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv			= true;
			var recordAll	=  detailStore3.data.items;

			switch(fieldName) {
				case "INCOME_CNT" :
					if(newValue < 0) {
						rv = "0보다 작은 값이 입력되었습니다.";
						break;
					}
					setTimeout(function() {
						UniAppManager.app.fnCalc3(recordAll, fieldName, record, newValue);
					}, 50);
				break;

				case "INCOME_SUPP_TOTAL_I" :
					if(newValue < 0) {
						rv = "0보다 작은 값이 입력되었습니다.";
						break;
					}
					setTimeout(function() {
						UniAppManager.app.fnCalc3(recordAll, fieldName, record, newValue);
					}, 50);
				break;

				case "DEF_IN_TAX_I" :	//6.소득세 등
					setTimeout(function() {
						UniAppManager.app.fnCalc3(recordAll, fieldName, record, newValue);
					}, 50);
				break;

				case "DEF_SP_TAX_I" :	//7.농어촌특별세
					setTimeout(function() {
						UniAppManager.app.fnCalc3(recordAll, fieldName, record, newValue);
					}, 50);
				break;

				case "ADD_TAX_I" :	//8.가산세
					if(newValue < 0) {
						rv = "0보다 작은 값이 입력되었습니다.";
						break;
					}
					setTimeout(function() {
						UniAppManager.app.fnCalc3(recordAll, fieldName, record, newValue);
					}, 50);
				break;

				case "RET_IN_TAX_I" :	//9.당월조정환급세액
					if(newValue < 0) {
						rv = "0보다 작은 값이 입력되었습니다.";
						break;
					}
					setTimeout(function() {
						UniAppManager.app.fnCalc3(recordAll, fieldName, record, newValue);
					}, 50);
				break;
			}
			return rv;
		}
	});

	/** 부표자-법인원천 
	 */
	Unilite.createValidator('validator04', {
		store	: detailStore4,
		grid	: detailGrid4,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv			= true;
			var recordAll	= detailStore4.data.items;

			switch(fieldName) {
				case "INCOME_CNT" :
					if(newValue < 0) {
						rv = "0보다 작은 값이 입력되었습니다.";
						break;
					}
					setTimeout(function() {
						UniAppManager.app.fnCalc4(recordAll, fieldName, record, newValue);
					}, 50);
				break;

				case "INCOME_SUPP_TOTAL_I" :
					if(newValue < 0) {
						rv = "0보다 작은 값이 입력되었습니다.";
						break;
					}
					setTimeout(function() {
						UniAppManager.app.fnCalc4(recordAll, fieldName, record, newValue);
					}, 50);
				break;

				case "DEF_IN_TAX_I" :	//6.소득세 등
					setTimeout(function() {
						UniAppManager.app.fnCalc4(recordAll, fieldName, record, newValue);
					}, 50);
				break;

				case "DEF_SP_TAX_I" :	//7.농어촌특별세
					setTimeout(function() {
						UniAppManager.app.fnCalc4(recordAll, fieldName, record, newValue);
					}, 50);
				break;

				case "ADD_TAX_I" :	//8.가산세
					if(newValue < 0) {
						rv = "0보다 작은 값이 입력되었습니다.";
						break;
					}
					setTimeout(function() {
						UniAppManager.app.fnCalc4(recordAll, fieldName, record, newValue);
					}, 50);
				break;

				case "RET_IN_TAX_I" :	//9.당월조정환급세액
					if(newValue < 0) {
						rv = "0보다 작은 값이 입력되었습니다.";
						break;
					}
					setTimeout(function() {
						UniAppManager.app.fnCalc4(recordAll, fieldName, record, newValue);
					}, 50);
				break;
			}
			return rv;
		}
	});
};
</script>