<%--
'	프로그램명 : 주문등록
'	작   성   자 : 시너지 시스템즈 개발팀
'	작   성   일 :
'	최종수정자 :
'	최종수정일 :
'	버	 전 : OMEGA Plus V6.0.0
--%>

<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="scn100ukrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="scn100ukrv" />	<!-- 사업장  -->
	<t:ExtComboStore comboType="AU" comboCode="B013"  />		<!-- 상태   -->
	<t:ExtComboStore comboType="AU" comboCode="B004"  />		<!-- 화폐단위 -->
	<t:ExtComboStore comboType="AU" comboCode="B039"  />		<!-- 출고방법 -->
	<t:ExtComboStore comboType="AU" comboCode="S002"  />		<!-- 판매유형 -->
	<t:ExtComboStore comboType="AU" comboCode="S167"  />		<!-- 계약등급 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}	
</style>
<script type="text/javascript" >

var gsContGubun = '1';
var SearchInfoWindow;					// SearchInfoWindow : 검색창
var BsaCodeInfo = {
	gsMoneyUnit	: '${gsMoneyUnit}',		//기준화폐 - BsaCodeInfo.gsMoneyUnit
	gsVatRate	: '${gsVatRate}'		//부가세율 - BsaCodeInfo.gsVatRate
}
var CustomCodeInfo = {
	gsUnderCalBase : ''
}
//파일첨부에 사용되는 변수 선언
var uploadWin;				//파일 업로드 윈도우
var photoWin;				//파일 이미지 보여줄 윈도우
var fid = '';				//파일 ID
var gsNeedPhotoSave	= false;

function appMain() {
	var dateStore = Unilite.createStore('dateComboStore', {  
		fields	: ['text', 'value'],
		data	: [
			{'text':'01', 'value':'01'}, {'text':'02', 'value':'02'}, {'text':'03', 'value':'03'}, {'text':'04', 'value':'04'},
			{'text':'05', 'value':'05'}, {'text':'06', 'value':'06'}, {'text':'07', 'value':'07'}, {'text':'08', 'value':'08'},
			{'text':'09', 'value':'09'}, {'text':'11', 'value':'11'}, {'text':'12', 'value':'12'}, {'text':'13', 'value':'13'},
			{'text':'14', 'value':'14'}, {'text':'15', 'value':'15'}, {'text':'16', 'value':'16'}, {'text':'17', 'value':'17'},
			{'text':'18', 'value':'18'}, {'text':'19', 'value':'19'}, {'text':'21', 'value':'21'}, {'text':'22', 'value':'22'},
			{'text':'23', 'value':'23'}, {'text':'24', 'value':'24'}, {'text':'25', 'value':'25'}, {'text':'26', 'value':'26'},
			{'text':'27', 'value':'27'}, {'text':'28', 'value':'28'}, {'text':'29', 'value':'29'}, {'text':'30', 'value':'30'},
			{'text':'31', 'value':'31'}
		]
	});

	/** Proxy 정의 
	 *  @type 
	 */
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'scn100ukrvService.selectList2',
			create	: 'scn100ukrvService.insertDetail2',
			update	: 'scn100ukrvService.updateDetail2',
			destroy	: 'scn100ukrvService.deleteDetail2',
			syncAll	: 'scn100ukrvService.saveAll2'
		}
	});

	//품목 정보 관련 파일 업로드
	var itemInfoProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'scn100ukrvService.getAttachmentsInfo',
			update	: 'scn100ukrvService.attachmentsUpdate',
			create	: 'scn100ukrvService.attachmentsInsert',
			destroy : 'scn100ukrvService.attachmentsDelete',
			syncAll : 'scn100ukrvService.saveAttachments'
		}
	});



	/** Model 정의
	 *  @type 
	 */
	Unilite.defineModel('scn100ukrvModel', {
		fields: [
			{name: 'COMP_CODE'			, text: 'COMP_CODE'	,type:'string'},
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.sales.division" default="사업장"/>'			, type: 'string'	, allowBlank: false},
			{name: 'CONT_NUM'			, text: '<t:message code="system.label.sales.contractnumber" default="계약번호"/>'	, type: 'string'},
			{name: 'CONT_SEQ'			, text: '<t:message code="system.label.sales.seq" default="순번"/>'				, type: 'int'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.sales.itemcode" default="품목코드"/>'		, type: 'string'	, allowBlank: false},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.sales.itemname" default="품목명"/>'			, type: 'string'},
			{name: 'SPEC'				, text: '<t:message code="system.label.sales.spec" default="규격"/>'				, type: 'string'},
			{name: 'CONT_Q'				, text: '<t:message code="system.label.sales.qty" default="수량"/>'				, type: 'uniQty'},
			{name: 'CONT_P'				, text: '<t:message code="system.label.sales.price" default="단가"/>'				, type: 'uniUnitPrice'},
			{name: 'CONT_SUPPLY_AMT'	, text: '<t:message code="system.label.sales.supplyamount" default="공급가액"/>'	, type: 'uniPrice'},
			{name: 'CONT_TAX_AMT'		, text: '<t:message code="system.label.sales.vat" default="부가세"/>'				, type: 'uniPrice'},
			{name: 'CONT_TOT_AMT'		, text: '<t:message code="system.label.sales.totalamount2" default="총액"/>'		, type: 'uniPrice'},
			{name: 'LOT_NO'				, text: '<t:message code="system.label.sales.lotno" default="LOT번호"/>'				, type: 'string'},
			{name: 'TAX_TYPE'			, text: '<t:message code="system.label.sales.taxabledivision" default="과세구분"/>'	, type: 'string'},		//(과세/면세)
			{name: 'TAX_CALC_TYPE'		, text: '세액계산법'			, type: 'string'},
			{name: 'VAT_RATE'			, text: '<t:message code="system.label.sales.vatrate" default="부가세율"/>'			, type: 'uniPercent'}
		]
	});



	/** Store 정의(Service 정의)
	 *  @type 
	 */
	var directMasterStore = Unilite.createStore('scn100ukrvMasterStore1',{
		proxy	: directProxy,
		model	: 'scn100ukrvModel',
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결 
			editable	: true,		// 수정 모드 사용 
			deletable	: true,		// 삭제 가능 여부 
			useNavi		: false		// prev | next 버튼 사용
		},
		autoLoad: false,
		loadStoreRecords : function() {
			var param= panelResult.getValues();
			this.load({
				params : param
			});
		},
		saveStore: function() {
			var toCreate	= this.getNewRecords();
			var toUpdate	= this.getUpdatedRecords();
			var toDelete	= this.getRemovedRecords();
			var list		= [].concat(toUpdate, toCreate);
			console.log("list:", list);

			//1. 마스터 정보 파라미터 구성
			var paramMaster= panelResult.getValues();	// syncAll 수정
			
			Ext.each(list, function(record,i) {
				if(Ext.isEmpty(record.get('CONT_NUM'))) {
					record.set('CONT_NUM', panelResult.getValue('CONT_NUM'));
				}
			});

			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						var master = batch.operations[0].getResultSet();
						panelResult.setValue("CONT_NUM", master.CONT_NUM);
						//기타 처리
						panelResult.getForm().wasDirty = false;
						panelResult.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);

						UniAppManager.app.onQueryButtonDown();

						if(directMasterStore.getCount() == 0) {
							UniAppManager.app.onResetButtonDown();
						}
					}
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('scn100ukrvGrid1');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
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



	/** Master Grid1 정의(Grid Panel)
	 *  @type 
	 */
	var masterGrid = Unilite.createGrid('scn100ukrvGrid1', {
		store	: directMasterStore,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			useGroupSummary		: true,
			useLiveSearch		: true,
			useContextMenu		: false,
			useMultipleSorting	: true,
			useRowNumberer		: true,
			onLoadSelectFirst	: false,
			expandLastColumn	: true,
			filter				: {
				useFilter	: false,
				autoCreate	: false
			}
		},
		features: [ 
			{id: 'masterGridSubTotal1'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false },
			{id: 'masterGridTotal1'		, ftype: 'uniSummary'			, showSummaryRow: true}
		],
		columns: [
			{dataIndex: 'COMP_CODE'			, width: 80		, hidden: true},
			{dataIndex: 'DIV_CODE'			, width: 100	, hidden: true},
			{dataIndex: 'CONT_NUM'			, width: 120	, hidden: true},
			{dataIndex: 'CONT_SEQ'			, width: 50		, hidden: true},
			{dataIndex: 'ITEM_CODE'			, width: 120,
				editor: Unilite.popup('DIV_PUMOK_G', {
					textFieldName	: 'ITEM_CODE',
					DBtextFieldName	: 'ITEM_CODE',
					autoPopup		: true,
					listeners		: {
						'onSelected': {
							fn: function(records, type) {
								console.log('records : ', records);
								Ext.each(records, function(record,i) {
									console.log('record',record);
									if(i==0) {
										masterGrid.setItemData(record,false, masterGrid.uniOpt.currentRecord);
									} else {
										UniAppManager.app.onNewDataButtonDown();
										masterGrid.setItemData(record,false, masterGrid.getSelectedRecord());
									}
								});
							},
							scope: this
							},
						'onClear': function(type) {
							masterGrid.setItemData(null,true, masterGrid.uniOpt.currentRecord);
						},
						'applyextparam': function(popup){
							var record	= masterGrid.getSelectedRecord();
							var divCode	= panelResult.getValue('DIV_CODE');
							popup.setExtParam({'SELMODEL': 'MULTI', 'DIV_CODE': divCode, 'POPUP_TYPE': 'GRID_CODE'});
//							popup.setExtParam({multiSelectItemAccount: true}); //20181224 폼목계정 상품, 제품 고정값 임시 해제,  유양은 반제품도 수주 함
//							if(BsaCodeInfo.gsBalanceOut == 'Y') {
//								popup.setExtParam({'ADD_QUERY': "ISNULL(B_OUT_YN, 'N') != N'Y'"});		   // WHERE절
//							}
						}
					}
				})
			},
			{dataIndex: 'ITEM_NAME'			, width: 200,
				editor: Unilite.popup('DIV_PUMOK_G', {
					autoPopup		: true,
					listeners		: {
						'onSelected': {
							fn: function(records, type) {
								console.log('records : ', records);
								Ext.each(records, function(record,i) {
									console.log('record',record);
									if(i==0) {
										masterGrid.setItemData(record,false, masterGrid.uniOpt.currentRecord);
									} else {
										UniAppManager.app.onNewDataButtonDown();
										masterGrid.setItemData(record,false, masterGrid.getSelectedRecord());
									}
								});
							},
							scope: this
							},
						'onClear': function(type) {
							masterGrid.setItemData(null,true, masterGrid.uniOpt.currentRecord);
						},
						'applyextparam': function(popup){
							var record	= masterGrid.getSelectedRecord();
							var divCode	= panelResult.getValue('DIV_CODE');
							popup.setExtParam({'SELMODEL': 'MULTI', 'DIV_CODE': divCode, 'POPUP_TYPE': 'GRID_CODE'});
//							popup.setExtParam({multiSelectItemAccount: true}); //20181224 폼목계정 상품, 제품 고정값 임시 해제,  유양은 반제품도 수주 함
//							if(BsaCodeInfo.gsBalanceOut == 'Y') {
//								popup.setExtParam({'ADD_QUERY': "ISNULL(B_OUT_YN, 'N') != N'Y'"});		   // WHERE절
//							}
						}
					}
				})
			},
			{dataIndex: 'SPEC'				, width: 120 },
			{dataIndex: 'LOT_NO'			, width: 90 
			 , editor:Unilite.popup('LOTNO_G', {
				 textFieldName : 'LOT_NO',
				 DBtextFieldName: 'LOT_NO',
				 allowInputData : true
			 })
			},
			{dataIndex: 'CONT_Q'			, width: 90		, summaryType: 'sum'},
			{dataIndex: 'CONT_P'			, width: 100	, summaryType: 'sum'},
			{dataIndex: 'CONT_SUPPLY_AMT'	, width: 100	, summaryType: 'sum'},
			{dataIndex: 'CONT_TAX_AMT'		, width: 100	, summaryType: 'sum'},
			{dataIndex: 'CONT_TOT_AMT'		, width: 100	, summaryType: 'sum'},
			{dataIndex: 'TAX_TYPE'			, width: 100	, hidden: true},
			{dataIndex: 'TAX_CALC_TYPE'		, width: 100	, hidden: true},
			{dataIndex: 'VAT_RATE'			, width: 100	, hidden: true}
		],
		setItemData: function(record, dataClear, grdRecord) {
			if(dataClear) {
				grdRecord.set('ITEM_CODE'		, '');
				grdRecord.set('ITEM_NAME'		, '');
				grdRecord.set('SPEC'			, '');
				grdRecord.set('CONT_Q'			, 0);
				grdRecord.set('CONT_P'			, 0);
				grdRecord.set('CONT_SUPPLY_AMT'	, 0);
				grdRecord.set('CONT_TAX_AMT'	, 0);
				grdRecord.set('CONT_TOT_AMT'	, 0);
				grdRecord.set('TAX_TYPE'		, '1');	//세구분(과세/면세)
			} else {
				grdRecord.set('ITEM_CODE'		, record['ITEM_CODE']);
				grdRecord.set('ITEM_NAME'		, record['ITEM_NAME']);
				grdRecord.set('SPEC'			, record['SPEC']);
				grdRecord.set('CONT_Q'			, 0);
				grdRecord.set('CONT_P'			, record['SALE_BASIS_P']);
				grdRecord.set('CONT_SUPPLY_AMT'	, 0);
				grdRecord.set('CONT_TAX_AMT'	, 0);
				grdRecord.set('CONT_TOT_AMT'	, 0);
				grdRecord.set('TAX_TYPE'		, record['TAX_TYPE']);	//세구분(과세/면세)
			}
		},
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				if(e.record.phantom) {
					if (UniUtils.indexOf(e.field, ['ITEM_CODE', 'ITEM_NAME', 'LOT_NO', 'CONT_Q', 'CONT_P', 'CONT_SUPPLY_AMT', 'CONT_TAX_AMT'])) {
						return true;
					} else {
						return false;
					}
				} else {
					if (UniUtils.indexOf(e.field, ['LOT_NO', 'CONT_Q', 'CONT_P', 'CONT_SUPPLY_AMT', 'CONT_TAX_AMT'])) {
						return true;
					} else {
						return false;
					}
				}
			},
			cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
			},
			edit: function(editor, e) {
//				var fieldName = e.field;
//				if(fieldName == 'ORDER_TYPE' || fieldName == 'MONEY_UNIT' || fieldName == 'EXCHG_RATE_O'){
//					var saveYn = UniAppManager.app._needSave();
//					directMasterStore.commitChanges();
//					UniAppManager.setToolbarButtons('save', saveYn);
//				}
			}
		}
	});



	//품목 정보 관련 파일업로드
	Unilite.defineModel('itemInfoModel', {
		fields: [
			{name: 'COMP_CODE'		,text: '<t:message code="system.label.base.companycode" default="법인코드"/>'				,type: 'string'},
			{name: 'DIV_CODE'		,text: 'DIV_CODE'		,type: 'string'},
			{name: 'CUSTOM_CODE'	,text: 'CUSTOM_CODE'	,type: 'string'},
			{name: 'MANAGE_NO'		,text: '<t:message code="system.label.base.manageno" default="관리번호"/>'					,type: 'string'},
			{name: 'SEQ'			,text: '<t:message code="system.label.sales.seq" default="순번"/>'						,type: 'int'},
			{name: 'REMARK'			,text: '<t:message code="system.label.base.remarks" default="비고"/>'						,type: 'string'},
			{name: 'CERT_FILE'		,text: '<t:message code="system.label.base.filename" default="파일명"/>'					,type: 'string'},
			{name: 'FILE_ID'		,text: '<t:message code="system.label.base.savedfilename" default="저장된 파일명"/>'			,type: 'string'},
			{name: 'FILE_PATH'		,text: '<t:message code="system.label.base.savedfilepath" default="저장된 파일경로"/>'			,type: 'string'},
			{name: 'FILE_EXT'		,text: '<t:message code="system.label.base.savedfileextension" default="저장된 파일확장자"/>'	,type: 'string'},
			//공통코드 생성 (B702 - 01:제품사진, 02:도면, 03:승인원)
			{name: 'FILE_TYPE'		,text: '<t:message code="system.label.base.classfication" default="구분"/>'				,type: 'string'		, comboType: 'AU'	, comboCode: 'B702'}
		]
	});

	var itemInfoStore = Unilite.createStore('itemInfoStore',{
		model	: 'itemInfoModel',
		proxy	: itemInfoProxy,
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,		// 상위 버튼 연결
			editable	: true,			// 수정 모드 사용
			deletable	: true,			// 삭제 가능 여부
			useNavi		: false			// prev | next 버튼 사용
		},
		loadStoreRecords : function(){
			var param= panelResult.getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore : function(config) {
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			if(inValidRecs.length == 0 ) {
				config = {
					success	: function(batch, option) {
						if(gsNeedPhotoSave){
							fnPhotoSave();
						}
					}
				};
				this.syncAllDirect(config);
			}else {
				itemInfoGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			update:function( store, record, operation, modifiedFieldNames, eOpts ){
			},
			metachange:function( store, meta, eOpts ){
			}
		},
		_onStoreUpdate: function (store, eOpt) {
			console.log("Store data updated save btn enabled !");
			this.setToolbarButtons('sub_save4', true);
		}, // onStoreUpdate
		_onStoreLoad: function ( store, records, successful, eOpts ) {
			console.log("onStoreLoad");
			if (records) {
				this.setToolbarButtons('sub_save4', false);
			}
		},
		_onStoreDataChanged: function( store, eOpts ) {
			console.log("_onStoreDataChanged store.count() : ", store.count());
			if(store.count() == 0){
				this.setToolbarButtons(['sub_delete4'], false);
				Ext.apply(this.uniOpt.state, {'btn':{'sub_delete4':false}});
			}else {
				if(this.uniOpt.deletable)	{
					this.setToolbarButtons(['sub_delete4'], true);
					Ext.apply(this.uniOpt.state, {'btn':{'sub_delete4':true}});
				}
			}
			if(store.isDirty()) {
				this.setToolbarButtons(['sub_save4'], true);
			}else {
				this.setToolbarButtons(['sub_save4'], false);
			}
		},
		setToolbarButtons: function( btnName, state)	 {
			var toolbar = itemInfoGrid.getDockedItems('toolbar[dock="top"]');
			var obj = toolbar[0].getComponent(btnName);
			if(obj) {
				(state) ? obj.enable():obj.disable();
			}
		}
	});

	var itemInfoGrid = Unilite.createGrid('itemInfoGrid', {
		store	: itemInfoStore,
		border	: true,
		height	: 185,
		width	: 771,
		sortableColumns : false,
		excelTitle: '<t:message code="system.label.base.referfile" default="관련파일"/>',
		uniOpt	:{
			onLoadSelectFirst	: false,
			expandLastColumn	: false,
			useRowNumberer		: true,
			useMultipleSorting	: false
		},
		dockedItems : [{
			xtype	: 'toolbar',
			dock	: 'top',
			items	: [{
				xtype	: 'uniBaseButton',
				text	: '<t:message code="system.label.base.inquiry" default="조회"/>',
				tooltip	: '<t:message code="system.label.base.inquiry" default="조회"/>',
				iconCls	: 'icon-query',
				width	: 26,
				height	: 26,
				itemId	: 'sub_query4',
				handler: function() {
					//if( me._needSave()) {
					if(panelResult.isDirty()) {
						Unilite.messageBox('<t:message code="system.message.sales.message066" default="먼저 저장 후 다시 작업하십시오."/>');
						return false;
					}
					var customCode = ''
					var toolbar	= itemInfoGrid.getDockedItems('toolbar[dock="top"]');
					var needSave= !toolbar[0].getComponent('sub_save4').isDisabled();
					if (needSave) {
						Ext.Msg.show({
							title	: '<t:message code="system.label.base.confirm" default="확인"/>',
							msg		: Msg.sMB017 + "\n" + Msg.sMB061,
							buttons	: Ext.Msg.YESNOCANCEL,
							icon	: Ext.Msg.QUESTION,
							fn		: function(res) {
								//console.log(res);
								if (res === 'yes' ) {
									var saveTask =Ext.create('Ext.util.DelayedTask', function(){
										itemInfoStore.saveStore();
									});
									saveTask.delay(500);
								} else if(res === 'no') {
									itemInfoStore.loadStoreRecords();
								}
							}
						});
					} else {
						itemInfoStore.loadStoreRecords();
					}
				}
			},{
				xtype	: 'uniBaseButton',
				text	: '<t:message code="system.label.base.reset2" default="초기화"/>',
				tooltip	: '<t:message code="system.label.base.reset2" default="초기화"/>',
				iconCls	: 'icon-reset',
				width	: 26,
				height	: 26,
				itemId	: 'sub_reset4',
				handler: function() {
					var toolbar	= itemInfoGrid.getDockedItems('toolbar[dock="top"]');
					var needSave= !toolbar[0].getComponent('sub_save4').isDisabled();
					if(needSave) {
						Ext.Msg.show({
							title	: '<t:message code="system.label.base.confirm" default="확인"/>',
							msg		: Msg.sMB017 + "\n" + Msg.sMB061,
							buttons	: Ext.Msg.YESNOCANCEL,
							icon	: Ext.Msg.QUESTION,
							fn		: function(res) {
								console.log(res);
								if (res === 'yes' ) {
									var saveTask =Ext.create('Ext.util.DelayedTask', function(){
										itemInfoStore.saveStore();
									});
									saveTask.delay(500);
								} else if(res === 'no') {
									itemInfoGrid.reset();
									itemInfoStore.clearData();
									itemInfoStore.setToolbarButtons('sub_save4', false);
									itemInfoStore.setToolbarButtons('sub_delete4', false);
								}
							}
						});
					} else {
						itemInfoGrid.reset();
						itemInfoStore.clearData();
						itemInfoStore.setToolbarButtons('sub_save4', false);
						itemInfoStore.setToolbarButtons('sub_delete4', false);
					}
				}
			},{
				xtype	: 'uniBaseButton',
				text	: '<t:message code="system.label.base.add" default="추가"/>',
				tooltip	: '<t:message code="system.label.base.add" default="추가"/>',
				iconCls	: 'icon-new',
				width	: 26,
				height	: 26,
				itemId	: 'sub_newData4',
				handler: function() {
					if(!Ext.isEmpty(panelResult.getValue('CONT_NUM'))) {
						if(panelResult.setAllFieldsReadOnly(true)) {
							var compCode	= UserInfo.compCode;
							var divCode		= panelResult.getValue('DIV_CODE');
							var customCode	= panelResult.getValue('CUSTOM_CODE');
							var manageNo	= panelResult.getValue('CONT_NUM');
							var seq			= itemInfoStore.max('SEQ');
							if(!seq) seq = 1;
							else seq += 1;
							var r			= {
								COMP_CODE		: compCode,
								DIV_CODE		: divCode,
								CUSTOM_CODE		: customCode,
								MANAGE_NO		: manageNo,
								SEQ				: seq
							};
							itemInfoGrid.createRow(r);
						}
					} else {
						Unilite.messageBox('<t:message code="system.message.sales.message131" default="먼저 계약등록을 저장하신 후에 첨부파일을 등록하세요."/>');
						return false;
					}
				}
			},{
				xtype		: 'uniBaseButton',
				text		: '<t:message code="system.label.base.delete" default="삭제"/>',
				tooltip		: '<t:message code="system.label.base.delete" default="삭제"/>',
				iconCls		: 'icon-delete',
				disabled	: true,
				width		: 26,
				height		: 26,
				itemId		: 'sub_delete4',
				handler		: function() {
					var selRow = itemInfoGrid.getSelectedRecord();
					if(!Ext.isEmpty(selRow)) {
						if(selRow.phantom === true) {
							itemInfoGrid.deleteSelectedRow();
						}else if(confirm('<t:message code="system.message.base.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
							itemInfoGrid.deleteSelectedRow();
						}
					} else {
						Unilite.messageBox(Msg.sMA0256);
						return false;
					}
				}
			},{
				xtype		: 'uniBaseButton',
				text		: '<t:message code="system.label.base.save" default="저장 "/>',
				tooltip		: '<t:message code="system.label.base.save" default="저장 "/>',
				iconCls		: 'icon-save',
				disabled	: true,
				width		: 26,
				height		: 26,
				itemId		: 'sub_save4',
				handler		: function() {
					var records	= itemInfoStore.data.items;
					var flag	= true;
					Ext.each(records, function(record, index) {
						if(Ext.isEmpty(record.get('CERT_FILE'))) {
							Unilite.messageBox('<t:message code="system.message.sales.message130" default="먼저 첨부파일을 등록하신 후에 저장하세요."/>');
							flag = false;
						}
					});
					if(!flag) return false;
					var inValidRecs = itemInfoStore.getInvalidRecords();
					if(inValidRecs.length == 0)	 {
						var saveTask =Ext.create('Ext.util.DelayedTask', function(){
							itemInfoStore.saveStore();
						});
						saveTask.delay(500);
					} else {
						itemInfoGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
					}
				}
			}]
		}],
		columns:[
			{ dataIndex	: 'COMP_CODE'			, width: 80		,hidden:true},
			{ dataIndex	: 'DIV_CODE'			, width: 80		,hidden:true},
			{ dataIndex	: 'CUSTOM_CODE'			, width: 80		,hidden:true},
			{ dataIndex	: 'MANAGE_NO'			, width: 150},
			{ dataIndex	: 'SEQ'					, width: 50		,hidden:true},
			{ text		: '<t:message code="system.label.base.relatedfile" default="관련파일"/>',
			 	columns:[
					{ dataIndex	: 'CERT_FILE'	, width: 230		, align: 'center'	,
						renderer: function (val, meta, record) {
							if (!Ext.isEmpty(record.data.CERT_FILE)) {
								//확장자에 관계 없이 바로다운로드 하도록 설정
								/*if(record.data.FILE_EXT == 'jpg' || record.data.FILE_EXT == 'png' || record.data.FILE_EXT == 'pdf'){
									return '<font color = "blue" >' + val + '</font>';
								} else */{
									var fileName	= record.data.FILE_ID + '.' +  record.data.FILE_EXT;
									var originFile	= record.data.CERT_FILE;
									var divCode		= record.data.DIV_CODE;
									var customCode	= record.data.CUSTOM_CODE;
									var manageNo	= record.data.MANAGE_NO;
									var seq			= record.data.SEQ;
//									Unilite.messageBox(CHOST + CPATH + '/fileman/downloadFile/' + divCode+ '/' + customCode + '/' + manageNo + '/' + seq  );
									return  '<A href="'+ CHOST + CPATH + '/fileman/downloadFile/' + divCode + '/' + customCode + '/' + manageNo + '/' + seq  +'">' + val + '</A>';
								}
							} else {
								return '';
							}
						}
					},{
						text		: '',
						dataIndex	: 'REG_IMG',
						xtype		: 'actioncolumn',
						align		: 'center',
						padding		: '-2 0 2 0',
						width		: 30,
						items		: [{
							icon	: CPATH+'/resources/css/theme_01/barcodetest.png',
							handler	: function(grid, rowIndex, colIndex, item, e, record) {
								itemInfoGrid.getSelectionModel().select(record);
								openUploadWindow();
							}
						}]
					}
				]
			},
			{ dataIndex	: 'REMARK'				, flex: 1	, minWidth: 30},
			{ dataIndex	: 'FILE_TYPE'			, width: 100, hidden: true}
		],
		listeners: {
			beforeedit: function( editor, e, eOpts ) {
				if(!e.record.phantom) {
					if (UniUtils.indexOf(e.field, ['FILE_TYPE', 'MANAGE_NO', 'SEQ', 'CERT_FILE'])){
						return false;
					}
				} else {
					if (UniUtils.indexOf(e.field, ['MANAGE_NO', 'SEQ', 'CERT_FILE'])){
						return false;
					}
				}
			},
			select: function(grid, selectRecord, index, rowIndex, eOpts ){
			},
			cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
				if(cellIndex == 6 && !Ext.isEmpty(record.get('CERT_FILE'))) {
					fid = record.data.FILE_ID
					var fileExtension	= record.get('CERT_FILE').lastIndexOf( "." );
					var fileExt			= record.get('CERT_FILE').substring( fileExtension + 1 );
					//확장자에 관계없이 바로 다운로드하도록 설정
//					if(fileExt == 'pdf') {
//						var win = Ext.create('widget.CrystalReport', {
//							url		: CPATH+'/fileman/downloadItemInfoImage/' + fid,
//							prgID	: 'scn100ukrv'
//						});
//						win.center();
//						win.show();
//
//					} else if(fileExt == 'jpg' || fileExt == 'png') {
//						openPhotoWindow();
//					} else {
//					}
				}
			}
		}
	});



	var panelResult = Unilite.createSearchForm('resultForm',{
		region		: 'north',
		padding		: '1 1 1 1',
		border		: true,
		autoScroll	: true,
		layout		: {type : 'uniTable', columns : 3},
		api			: {
			load	: 'scn100ukrvService.selectList1',
			submit	: 'scn100ukrvService.saveMaster'
		},
		items		: [{
			fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			value		: UserInfo.divCode,
			allowBlank	: false,
			holdable	: 'hold',
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					combo.changeDivCode(combo, newValue, oldValue, eOpts);
					var field = panelResult.getField('SALE_PRSN');
					field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);
				}
			}
		},{
			xtype	: 'container',
			layout	: {type : 'uniTable', columns : 2},
			items	: [{
				xtype		: 'radiogroup',
				fieldLabel	: '<t:message code="system.label.sales.contractclassification" default="계약구분"/>',
				id			: 'contractClassification',
				items		: [{
					boxLabel	: '<t:message code="system.label.sales.lease" default="임대"/>', 
					width		: 60,
					name		: 'CONT_GUBUN',
					holdable	: 'hold',
					inputValue	: '1',
					checked		: true
				},{
					boxLabel	: '<t:message code="system.label.sales.maintenance" default="유지보수"/>', 
					width		: 80,
					name		: 'CONT_GUBUN',
					holdable	: 'hold',
					inputValue	: '2'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						if(newValue.CONT_GUBUN == '1') {
							//계약기간, 월유지보수비, 청구일 등 필드 보이지 않음
							Ext.getCmp('DATE_CONTAINER').setVisible(false);
							Ext.getCmp('VIEW_CONTAINER').setHeight(0);
							panelResult.getField('MONTH_MAINT_AMT').setVisible(false);
							panelResult.getField('CHAGE_DAY').setVisible(false);
							panelResult.getField('CONT_GRADE').setVisible(false);
							//숨겨지는 필드 값 ''로 set
							panelResult.setValue('CONT_FR_DATE'		, '');
							panelResult.setValue('CONT_TO_DATE'		, '');
							panelResult.setValue('CONT_MONTH'		, 0);
							panelResult.setValue('MONTH_MAINT_AMT'	, 0);
							panelResult.setValue('CHAGE_DAY'		, '');
							
						} else {
							//계약기간, 월유지보수비, 청구일 등 필드 보임
							Ext.getCmp('DATE_CONTAINER').setVisible(true);
							panelResult.getField('MONTH_MAINT_AMT').setVisible(true);
							panelResult.getField('CHAGE_DAY').setVisible(true);
							panelResult.getField('CONT_GRADE').setVisible(true);
							Ext.getCmp('VIEW_CONTAINER').setHeight(60);
						}
					}
				}
			}]
		},{
			fieldLabel	: '<t:message code="system.label.sales.contractnumber" default="계약번호"/>',
			name		: 'CONT_NUM',
			xtype		: 'uniTextfield',
			readOnly	: true,
			listeners	: {
			}
		},
		Unilite.popup('AGENT_CUST', {
			fieldLabel		: '<t:message code="system.label.sales.custom" default="거래처"/>',
			valueFieldName	: 'CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME',
			allowBlank		: false,
			holdable		: 'hold',
			listeners		: {
				onSelected: {
					fn: function(records, type) {
						BsaCodeInfo.gsVatRate			= records[0]["VAT_RATE"];		//부가세율
						CustomCodeInfo.gsUnderCalBase	= records[0]["WON_CALC_BAS"];
					}
				},
				applyextparam: function(popup){
					popup.setExtParam({'AGENT_CUST_FILTER'	: ['1','3']});
					popup.setExtParam({'CUSTOM_TYPE'		: ['1','3']});
				}
			}
		}),{
			fieldLabel	: '<t:message code="system.label.sales.contractdate" default="계약일"/>',
			xtype		: 'uniDatefield',
			name		: 'CONT_DATE',
			value		: UniDate.get('today'),
			allowBlank	: false,
			holdable	: 'hold',
			listeners	: {
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.contractamount" default="계약금액"/>',
			xtype		: 'uniNumberfield',
			type		: 'Price',
			name		: 'CONT_AMT',
			value		: 0,
			allowBlank	: false,
			holdable	: 'hold',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.salescharge" default="영업담당"/>',
			name		: 'SALE_PRSN',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'S010',
			allowBlank	: false,
			onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
				if(eOpts){
					combo.filterByRefCode('refCode1', newValue, eOpts.parent);
				} else {
					combo.divFilterByRefCode('refCode1', newValue, divCode);
				}
			},
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					if(newValue != oldValue) {
						UniAppManager.setToolbarButtons(['save', 'reset'], true);
					}
				}
			}
		},{
			xtype	: 'container',
			layout	: {type : 'uniTable', columns : 2},
			items	: [{
				xtype		: 'radiogroup',
				fieldLabel	: '<t:message code="system.label.sales.taxincludedflag" default="세액포함여부"/>',
				name		: 'TAX_IN_OUT',
				id			: 'TAX_IN_OUT',
				items		: [{
					boxLabel	: '<t:message code="system.label.sales.exclusive" default="별도"/>', 
					name		: 'TAX_IN_OUT',
					inputValue	: '1',
					holdable	: 'hold',
					width		: 60
				},{
					boxLabel	: '<t:message code="system.label.sales.inclusion" default="포함"/>', 
					name		: 'TAX_IN_OUT',
					inputValue	: '2',
					width		: 80,
					holdable	: 'hold',
					checked		: true
				}],
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			}]
		},{
			xtype	: 'container',
			layout	: {type : 'uniTable', columns : 2},
			items	: [{
				xtype		: 'radiogroup',
				fieldLabel	: '<t:message code="system.label.sales.contractstatus" default="계약상태"/>',
				name		: 'CONT_STATE',
				id			: 'contractStatus',
				items		: [{
					boxLabel	: '<t:message code="system.label.sales.end" default="종료"/>', 
					width		: 60,
					name		: 'CONT_STATE',
					inputValue	: '9'
				},{
					boxLabel	: '<t:message code="system.label.sales.contract" default="계약"/>', 
					width		: 80,
					name		: 'CONT_STATE',
					inputValue	: '1',
					checked		: true
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			}]
		},{
			xtype	: 'container',
			layout	: {type : 'uniTable', columns : 3},
			id		: 'VIEW_CONTAINER',
			padding	: '0 0 3 0',
			colspan	: 3,
			items	: [{
				xtype	: 'container',
				layout	: {type : 'uniTable', columns : 2},
				id		: 'DATE_CONTAINER',
				padding	: '0 0 3 0',
				items	: [{
					fieldLabel		: '<t:message code="system.label.sales.contractedperiod" default="계약기간"/>',
					xtype			: 'uniDateRangefield',
					startFieldName	: 'CONT_FR_DATE',
					endFieldName	: 'CONT_TO_DATE',
					holdable		: 'hold',
					onStartDateChange: function(field, newValue, oldValue, eOpts) {
						if(!Ext.isEmpty(newValue)) {
							if(UniDate.getDbDateStr(newValue).length == 8) { 
								if(!Ext.isEmpty(panelResult.getValue('CONT_TO_DATE'))) {
									fnCalcMonth();
								}
							} else if(Ext.isEmpty(newValue)) {
								panelResult.setValue('CONT_MONTH', 0);
							}
						}
					},
					onEndDateChange: function(field, newValue, oldValue, eOpts) {
						if(!Ext.isEmpty(newValue)) {
							if(UniDate.getDbDateStr(newValue).length == 8) { 
								if(!Ext.isEmpty(panelResult.getValue('CONT_FR_DATE'))) {
									fnCalcMonth();
								}
							} else if(Ext.isEmpty(newValue)) {
								panelResult.setValue('CONT_MONTH', 0);
							}
						}
					}
				},{//계약개월수
					fieldLabel	: '',
					xtype		: 'uniNumberfield',
					name		: 'CONT_MONTH',
					width		: 60,
					value		: 0,
					suffixTpl	: '<t:message code="system.label.sales.month2" default="개월"/>',
					holdable	: 'hold',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
						}
					}
				}]
			},{
				fieldLabel	: '<t:message code="system.label.sales.monthmaintenancecost" default="월유지보수비"/>',
				xtype		: 'uniNumberfield',
				name		: 'MONTH_MAINT_AMT',
				type		: 'Price',
				value		: 0,
				holdable	: 'hold',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
					},
					blur: function(field, The, eOpts){
						//20190827 - 유지보수 일 때,
						if(!panelResult.getValue('CONT_GUBUN')) {
							var contMonth = panelResult.getValue('CONT_MONTH');
							if (contMonth != 0) {
								//20190827 - 계약금액을 계약기간(month) * 월유지보수비 값으로 set
								panelResult.setValue('CONT_AMT', Unilite.multiply(contMonth, field.lastValue));
							}
						}
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.sales.billingdate" default="청구일"/>',
				name		: 'CHAGE_DAY',
				xtype		: 'uniCombobox',
				store		: dateStore,
				holdable	: 'hold',
				listeners	: {
				}
			},{
        		fieldLabel:'<t:message code="system.label.sales.contactgrade" default="계약등급"/>',
        		name : 'CONT_GRADE',
				xtype : 'uniCombobox',
				comboType : 'AU',
				comboCode : 'S167',
				holdable  : 'hold',
				colspan : 3
			}]
		},{
			fieldLabel	: '<t:message code="system.label.sales.remarks" default="비고"/>',
			xtype		: 'textarea',
			name		: 'REMARK',
			width		: 870,
			colspan		: 3,
			layout		: {type : 'uniTable', columns : 3},
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					if(newValue != oldValue) {
						UniAppManager.setToolbarButtons(['save', 'reset'], true);
					}
				}
			}
		},{
			title		: '<t:message code="system.label.base.referfile" default="관련파일"/>',
			xtype		: 'panel',
			height		: 220,
			width		: 870,
			colspan		: 3,
			autoScroll	: true,
			padding		: '0 0 0 95',
			layout		: {
				type	: 'uniTable',
				tdAttrs	: {valign: 'top'},
				columns	: 1
			},
			items		: [itemInfoGrid]
		},{
			fieldLabel	: 'FILE_NO',
			xtype		: 'uniTextfield',
			name		: 'FILE_NO',
			hidden		: true,
			listeners	: {
			}
		}],
		listeners: {
			uniOnChange:function( basicForm, dirty, eOpts ) {
				console.log("onDirtyChange");
				if(basicForm.getField('CONT_STATE').isDirty() || basicForm.getField('REMARK').isDirty()) {
					UniAppManager.setToolbarButtons(['save', 'reset'], true);
				}else {
					UniAppManager.setToolbarButtons('save', false);
				}
			},
			dirtychange:function( basicForm, dirty, eOpts ) {
				UniAppManager.setToolbarButtons(['save', 'reset'], true);
			}
		},
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
							var popupFC = item.up('uniPopupField')  ;
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
						var popupFC = item.up('uniPopupField')  ;
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		}
	});	



	var searchPopupPanel = Unilite.createSearchForm('searchPopupPanel', {
		layout	: {type: 'uniTable', columns : 2},
		trackResetOnLoad: true,
		items	: [{
			fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
//					combo.changeDivCode(combo, newValue, oldValue, eOpts);
//					var field = orderNoSearch.getField('ORDER_PRSN');
//					field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);
				}
			}
		},{
			fieldLabel		: '<t:message code="system.label.sales.contractdate" default="계약일"/>',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'CONT_DATE_FR',
			endFieldName	: 'CONT_DATE_TO',
			startDate		: UniDate.get('startOfMonth'),
			endDate			: UniDate.get('today')
		},
		Unilite.popup('AGENT_CUST',{
			fieldLabel		: '<t:message code="system.label.sales.custom" default="거래처"/>',
			valueFieldName	: 'CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME',
			validateBlank	: false,
			listeners		: {
				onValueFieldChange: function(field, newValue, oldValue){
					if(!Ext.isObject(oldValue)) {
						searchPopupPanel.setValue('CUSTOM_NAME', '');
					}
				},
				onTextFieldChange: function(field, newValue, oldValue){
					if(!Ext.isObject(oldValue)) {
						searchPopupPanel.setValue('CUSTOM_CODE', '');
					}
				},
				applyextparam: function(popup){
					popup.setExtParam({'AGENT_CUST_FILTER'	: ['1','3']});
					popup.setExtParam({'CUSTOM_TYPE'		: ['1','3']});
				}
			}
		}),{
			xtype	: 'container',
			layout	: {type : 'uniTable', columns : 2},
			items	: [{
				xtype		: 'radiogroup',
				fieldLabel	: '<t:message code="system.label.sales.contractclassification" default="계약구분"/>',
				id			: 'contractClassification2',
				items		: [{
					boxLabel	: '<t:message code="system.label.sales.lease" default="임대"/>', 
					width		: 60,
					name		: 'CONT_GUBUN',
					inputValue	: '1',
					checked		: true
				},{
					boxLabel	: '<t:message code="system.label.sales.maintenance" default="유지보수"/>', 
					width		: 80,
					name		: 'CONT_GUBUN',
					inputValue	: '2'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			}]
		},{
			fieldLabel	: '<t:message code="system.label.sales.contractnumber" default="계약번호"/>',
			name		: 'CONT_NUM'
		}]
	}); // createSearchForm
	//검색 모델
	Unilite.defineModel('searchPopupModel', {
		fields: [
			{name: 'COMP_CODE'		, text: 'COMP_CODE'	,type:'string'},
			{name: 'DIV_CODE'		, text: '<t:message code="system.label.sales.division" default="사업장"/>'					, type: 'string'},
			{name: 'CONT_NUM'		, text: '<t:message code="system.label.sales.contractnumber" default="계약번호"/>'			, type: 'string'},
			{name: 'CUSTOM_CODE'	, text: '<t:message code="system.label.sales.custom" default="거래처"/>'					, type: 'string'},
			{name: 'CUSTOM_NAME'	, text: '<t:message code="system.label.sales.customname" default="거래처명"/>'				, type: 'string'},
			{name: 'CONT_GUBUN'		, text: '<t:message code="system.label.sales.contractclassification" default="계약구분"/>'	, type: 'string'},
			{name: 'CONT_DATE'		, text: '<t:message code="system.label.sales.contractdate" default="계약일"/>'				, type: 'uniDate'}
		]
	});
	//검색 스토어
	var searchPopupStore = Unilite.createStore('searchPopupStore', {
		model	: 'searchPopupModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		proxy: {
			type: 'direct',
			api: {
				read : 'scn100ukrvService.searchPopupList'
			}
		},
		loadStoreRecords : function()  {
			var param = searchPopupPanel.getValues();
//			var authoInfo = pgmInfo.authoUser;		// 권한정보(N-전체,A-자기사업장>5-자기부서)
//			if(authoInfo == "5" && Ext.isEmpty(searchPopupPanel.getValue('DEPT_CODE'))){
//				param.DEPT_CODE = deptCode;
//			}
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	//검색 그리드
	var searchPopupGrid = Unilite.createGrid('scn100ukrvsearchPopupGrid', {
		store	: searchPopupStore,
		layout	: 'fit',
		uniOpt	:{
			expandLastColumn: true,
			useRowNumberer	: true
		},
		selModel:'rowmodel',
		columns:  [
			{ dataIndex: 'COMP_CODE'	, width: 80		, hidden: true},
			{ dataIndex: 'DIV_CODE'		, width: 80		, hidden: true},
			{ dataIndex: 'CONT_NUM'		, width: 120 },
			{ dataIndex: 'CUSTOM_CODE'	, width: 100 },
			{ dataIndex: 'CUSTOM_NAME'	, width: 150 },
			{ dataIndex: 'CONT_GUBUN'	, width: 80		, hidden: true},
			{ dataIndex: 'CONT_DATE'	, width: 80 }
		],
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
				searchPopupGrid.returnData(record);
				UniAppManager.app.onQueryButtonDown();
				SearchInfoWindow.hide();
			}
		},
		returnData: function(record) {
			if(Ext.isEmpty(record)) {
				record = this.getSelectedRecord();
			}
			panelResult.setValues({
				'DIV_CODE'	: record.get('DIV_CODE'),
				'CONT_NUM'	: record.get('CONT_NUM')
			});
		}
	});
	//openSearchInfoWindow(검색 메인)
	function openSearchInfoWindow() {
		if(!SearchInfoWindow) {
			SearchInfoWindow = Ext.create('widget.uniDetailWindow', {
				title	: '계약번호 검색',
				width	: 1080,
				height	: 580,
				layout	: {type:'vbox', align:'stretch'},
				items	: [searchPopupPanel, searchPopupGrid],
				tbar	:  ['->', {
					itemId	: 'searchBtn',
					text	: '<t:message code="system.label.sales.inquiry" default="조회"/>',
					handler	: function() {
						searchPopupStore.loadStoreRecords();
					},
					disabled: false
				},{
					itemId	: 'closeBtn',
					text	: '<t:message code="system.label.sales.close" default="닫기"/>',
					handler	: function() {
						SearchInfoWindow.hide();
					},
					disabled: false
				}],
				listeners : {
					beforehide: function(me, eOpt) {
						searchPopupPanel.clearForm();
						searchPopupGrid.reset();
					},
					beforeclose: function( panel, eOpts )  {
						searchPopupPanel.clearForm();
						searchPopupGrid.reset();
					},
					show: function( panel, eOpts ) {
						searchPopupPanel.setValue('DIV_CODE', panelResult.getValue('DIV_CODE'));
						searchPopupPanel.setValue('DIV_CODE', panelResult.getValue('DIV_CODE'));
					}
				}
			})
		}
		SearchInfoWindow.center();
		SearchInfoWindow.show();
	}



	Unilite.Main({
		id			: 'scn100ukrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				masterGrid, panelResult
			]
		}],
		fnInitBinding : function() {
			panelResult.setValue('DIV_CODE'	, UserInfo.divCode);
			var field = panelResult.getField('SALE_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");

			panelResult.setValue('CONT_DATE'	, UniDate.get('today'));
			panelResult.setValue('CONT_GUBUN'	, gsContGubun);
			panelResult.setValue('TAX_IN_OUT'	, '2');
			panelResult.setValue('CONT_STATE'	, '1');

			panelResult.setValue('CONT_AMT'		, 0);
			panelResult.setValue('CONT_MONTH'	, 0);
			panelResult.setValue('MONTH_MAINT_AMT', 0);

			UniAppManager.setToolbarButtons('reset'		, false);
			UniAppManager.setToolbarButtons('newData'	, true);
			
			//계약기간, 월유지보수비, 청구일 등 필드 보이지 않음
			if(gsContGubun == '1') {
				Ext.getCmp('DATE_CONTAINER').setVisible(false);
				Ext.getCmp('VIEW_CONTAINER').setHeight(0);
				panelResult.getField('MONTH_MAINT_AMT').setVisible(false);
				panelResult.getField('CHAGE_DAY').setVisible(false);
				panelResult.getField('CONT_GRADE').setVisible(false);
			} else {
				Ext.getCmp('DATE_CONTAINER').setVisible(true);
				panelResult.getField('MONTH_MAINT_AMT').setVisible(true);
				panelResult.getField('CHAGE_DAY').setVisible(true);
				panelResult.getField('CONT_GRADE').setVisible(true);
				Ext.getCmp('VIEW_CONTAINER').setHeight(60);
			}
			panelResult.getForm().wasDirty = false;
			panelResult.resetDirtyStatus();
		},
		onQueryButtonDown : function(){
			if(Ext.isEmpty(panelResult.getValue('CONT_NUM'))) {
				openSearchInfoWindow();
			} else {
				var param = panelResult.getValues();
				panelResult.uniOpt.inLoading = true;
				panelResult.getForm().load({
					params	: param,
					success	: function() {
						Ext.getBody().unmask();
						panelResult.getForm().wasDirty = false;
						panelResult.resetDirtyStatus();

						if(panelResult.setAllFieldsReadOnly(true)) {
							directMasterStore.loadStoreRecords();
							itemInfoStore.loadStoreRecords();
						}
					},
					failure: function(batch, option) {
						Ext.getBody().unmask();
					}
				});
				UniAppManager.setToolbarButtons('reset', true);
			}
		},
		onResetButtonDown: function() {
			gsContGubun = panelResult.getValue('CONT_GUBUN');
			panelResult.clearForm();
			masterGrid.getStore().loadData({});

			panelResult.setAllFieldsReadOnly(false);
			this.fnInitBinding();

			panelResult.getForm().wasDirty = false;
			panelResult.resetDirtyStatus();
		},
		onNewDataButtonDown: function() {
			if(panelResult.setAllFieldsReadOnly(true)) {
				var compCode	= UserInfo.compCode;
				var divCode		= panelResult.getValue('DIV_CODE');
				var contNum		= panelResult.getValue('CONT_NUM');
				var seq			= directMasterStore.max('CONT_SEQ');
				if(!seq) seq = 1;
				else seq += 1;
				var taxCalcType	= Ext.getCmp('TAX_IN_OUT').getChecked()[0].inputValue;	//세액포함여부
				var vatRate		= BsaCodeInfo.gsVatRate;				//세율
	
				var r = {
					COMP_CODE		: compCode,
					DIV_CODE		: divCode,
					CONT_NUM		: contNum,
					CONT_SEQ		: seq,
					TAX_CALC_TYPE	: taxCalcType,
					VAT_RATE		: vatRate
				};
				masterGrid.createRow(r);
			}
		},
		onDeleteDataButtonDown: function() {
			var selRow	= masterGrid.getSelectedRecord();
			if(!Ext.isEmpty(selRow)) {
				if(confirm('<t:message code="system.message.product.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
					masterGrid.deleteSelectedRow();
				}
			} else {
				Unilite.messageBox('<t:message code="system.message.sales.message061" default="선택된 데이터가 없습니다."/>');
				return false;
			}
		},
		onDeleteAllButtonDown: function() {
			var records = directMasterStore.data.items;
			var isNewData = false;
			Ext.each(records, function(record,i) {
				if(record.phantom){					// 신규 레코드일시 isNewData에 true를 반환
					isNewData = true;
				} else {							// 신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
					isNewData = false;
					if(confirm('<t:message code="system.message.sales.confirm002" default="전체삭제 하시겠습니까?"/>')) {
						var deletable = true;
						/*---------삭제전 로직 구현 시작----------*/
//						Ext.each(records, function(record,i) {
//							if(record.get('ISSUE_REQ_Q') > 0 || record.get('OUTSTOCK_Q') > 0 ) {
//								Unilite.messageBox('<t:message code="system.message.sales.datacheck007" default="출고가 진행중인 수주내역은 삭제가 불가능합니다."/>');
//								deletable = false;
//								return false;
//							}
//						});
						/*---------삭제전 로직 구현 끝----------*/
						if(deletable){
							masterGrid.reset();
							UniAppManager.app.onSaveDataButtonDown2();
						}
					}
					return false;
				}
			});
			if(isNewData){								// 신규 레코드들만 있을시 그리드 리셋
				masterGrid.reset();
				UniAppManager.app.onResetButtonDown();	// 삭제후 RESET..
			}
		},
		onSaveDataButtonDown: function(config) {
			if(!panelResult.getInvalidMessage()) return;	//필수체크
			if(directMasterStore.isDirty()){
				directMasterStore.saveStore();
			} else if(panelResult.isDirty()) {
				//디테일 정보가 없으면 저장하지 않음
				var detailDelete = directMasterStore.getRemovedRecords();
				if(Ext.isEmpty(detailDelete) && directMasterStore.getCount() == 0) {
					Unilite.messageBox('<t:message code="system.message.sales.message132" default="상세 데이터를 입력하신 후 저장해 주세요."/>');
					return false;
				}
				var param = panelResult.getValues();
				panelResult.getForm().submit({
					params	: param,
					success	: function(form, action) {
						panelResult.getForm().wasDirty = false;
						panelResult.resetDirtyStatus();
						
						UniAppManager.setToolbarButtons('save', false);	
						UniAppManager.updateStatus(Msg.sMB011);
						UniAppManager.app.onQueryButtonDown();
					}
				});
			} else {
				Unilite.messageBox('<t:message code="system.message.common.savecheck2" default="저장할 데이터가 없습니다."/>');
				return false;
			}
		},
		onSaveDataButtonDown2: function(config) {
			if(directMasterStore.isDirty()){
				directMasterStore.saveStore();
			} else {
				Unilite.messageBox('<t:message code="system.message.common.savecheck2" default="저장할 데이터가 없습니다."/>');
				return false;
			}
		}
	});		//End of Unilite.Main({



	//입력된 두 날짜 사이의 개월 수 구하는 함수
	function fnCalcMonth() {
		var sdd		= panelResult.getValue('CONT_FR_DATE');
		var edd		= panelResult.getValue('CONT_TO_DATE');
		var dif		= edd - sdd;
		var cDay	= 24 * 60 * 60 * 1000;		// 시 * 분 * 초 * 밀리세컨
		var cMonth	= cDay * 30;				// 월 만듬
		var cYear	= cMonth * 12;				// 년 만듬
		if(sdd && edd){
			var diffYear	= parseInt(dif/cYear)
			var diffMonth	= parseInt(dif/cMonth)
			var diffDay		= parseInt(dif/cDay)
			
			panelResult.setValue('CONT_MONTH', diffMonth);
		}
	}

	//금액계산로직
	function fnCalcAmt(record, flag, newValue) {
		var digit			= UniFormat.Price.indexOf(".") == -1 ? UniFormat.Price.length : UniFormat.Price.indexOf(".") + 1;
		var numDigitOfPrice	= UniFormat.Price.length - digit;
		var sOrderP			= record.get('CONT_P');
		var sOrderQ			= record.get('CONT_Q');
		var sTaxType		= record.get('TAX_TYPE');
		var sTaxInoutType	= record.get('TAX_CALC_TYPE');
		var sVatRate		= record.get('VAT_RATE');
		var dOrderAmtO		= 0;
		var dTaxAmtO		= 0;
		var dAmountI		= 0;
		
		if(flag == 'Q' || flag == 'P') {
			if(flag == 'Q') {
				sOrderQ = newValue;
			} else if(flag == 'P') {
				sOrderP = newValue;
			}

			if(sTaxInoutType == '1') {
				dOrderAmtO	= Unilite.multiply(sOrderP, sOrderQ);
				dTaxAmtO	= Unilite.multiply(dOrderAmtO, sVatRate) / 100;
				dOrderAmtO	= UniSales.fnAmtWonCalc(dOrderAmtO	, '3'	, numDigitOfPrice);
				dTaxAmtO	= UniSales.fnAmtWonCalc(dTaxAmtO	, '2'	, numDigitOfPrice);
			} else if(sTaxInoutType == '2') {
				dAmountI	= Unilite.multiply(sOrderP, sOrderQ);
				dTemp		= UniSales.fnAmtWonCalc(Unilite.multiply((dAmountI / ( sVatRate + 100 )), 100), '2', numDigitOfPrice);
				dTaxAmtO	= UniSales.fnAmtWonCalc(Unilite.multiply(dTemp, sVatRate) / 100, '2', numDigitOfPrice);
				dOrderAmtO	= UniSales.fnAmtWonCalc((dAmountI - dTaxAmtO), CustomCodeInfo.gsUnderCalBase, numDigitOfPrice) ;
			}
			if(sTaxType == '2') {
				dOrderAmtO	= UniSales.fnAmtWonCalc(dOrderO, CustomCodeInfo.gsUnderCalBase, numDigitOfPrice);
				dTaxAmtO	= 0;
			}
		} else if(flag == 'O') {
			dOrderAmtO	= newValue;
			dTaxAmtO	= record.get('CONT_TAX_AMT');
			dOrderAmtO	= UniSales.fnAmtWonCalc(dOrderAmtO	, '3'	, numDigitOfPrice);
			dTaxAmtO	= UniSales.fnAmtWonCalc(dTaxAmtO	, '2'	, numDigitOfPrice);
		} else if(flag == 'T') {
			dOrderAmtO		= record.get('CONT_SUPPLY_AMT');
			dTaxAmtO		= newValue;
			dOrderAmtO	= UniSales.fnAmtWonCalc(dOrderAmtO	, '3'	, numDigitOfPrice);
			dTaxAmtO	= UniSales.fnAmtWonCalc(dTaxAmtO	, '2'	, numDigitOfPrice);
		}
		record.set('CONT_SUPPLY_AMT', dOrderAmtO);
		record.set('CONT_TAX_AMT'	, dTaxAmtO);
		record.set('CONT_TOT_AMT'	, dOrderAmtO + dTaxAmtO);

//		if((flag == 'O' || flag == 'T') && sTaxInoutType == '2') {
//			record.set('CONT_TOT_AMT'	, dOrderAmtO);
//		}
	}


	//첨부파일 업로드
	function fnPhotoSave() {				//이미지 등록
		//조건에 맞는 내용은 적용 되는 로직
		var record		= itemInfoGrid.getSelectedRecord();
		var photoForm	= uploadWin.down('#photoForm').getForm();
		var param		= {
			DIV_CODE	: record.data.DIV_CODE,
			CUSTOM_CODE	: record.data.CUSTOM_CODE,
			MANAGE_NO	: record.data.MANAGE_NO,
			SEQ			: record.data.SEQ
		}
		photoForm.submit({
			params	: param,
			waitMsg	: 'Uploading your files...',
			success	: function(form, action) {
				uploadWin.afterSuccess();
				gsNeedPhotoSave = false;
			}
		});
	}

	function openUploadWindow() {
		if(!uploadWin) {
			uploadWin = Ext.create('Ext.window.Window', {
				title		: '<t:message code="system.label.base.file" default="파일"/> <t:message code="system.label.base.entry" default="등록"/>',
				closable	: false,
				closeAction	: 'hide',
				modal		: true,
				resizable	: true,
				width		: 300,
				height		: 100,
				layout		: {
					type	: 'fit'
				},
				items		: [
					photoForm,
					{
						xtype		: 'uniDetailForm',
						itemId		: 'photoForm',
						disabled	: false,
						fileUpload	: true,
						api			: {
							submit: scn100ukrvService.photoUploadFile
						},
						items		:[{
						 	xtype		: 'filefield',
							fieldLabel	: '<t:message code="system.label.base.file" default="파일"/>',
							name		: 'photoFile',
							buttonText	: '<t:message code="system.label.base.selectfile" default="파일선택"/>',
							buttonOnly	: false,
							labelWidth	: 70,
							flex		: 1,
							width		: 270
						}]
					}
				],
				listeners : {
					beforeshow: function( window, eOpts)	{
 						var toolbar	= itemInfoGrid.getDockedItems('toolbar[dock="top"]');
						var needSave= !toolbar[0].getComponent('sub_save4').isDisabled();
						var record	= itemInfoGrid.getSelectedRecord();

						if (needSave) {
							if(Ext.isEmpty(record.data.MANAGE_NO)){
								Unilite.messageBox('<t:message code="system.message.human.message002" default="필수입력사항을 입력하신 후 사진을 올려주세요."/>');
								return false;
							}
						} else {
							if (Ext.isEmpty(record)) {
								Unilite.messageBox('<t:message code="system.message.base.message004" default="품목 관련 정보를 입력하신 후, 사진을 업로드 하시기 바랍니다."/>');
								return false;
							}
						}
					},
					show: function( window, eOpts)	{
						window.center();
					}
				},
				afterSuccess: function()	{
					var param = {
						DIV_CODE	: panelResult.getValue('DIV_CODE'),
						CUSTOM_CODE	: panelResult.getValue('CUSTOM_CODE'),
						CONT_NUM	: panelResult.getValue('CONT_NUM')
					}
					itemInfoStore.loadStoreRecords(param);
					this.afterSavePhoto();
				},
				afterSavePhoto: function()	{
					var photoForm = uploadWin.down('#photoForm');
					photoForm.clearForm();
					uploadWin.hide();
				},
				tbar:['->',{
					xtype	: 'button',
					text	: '<t:message code="system.label.base.upload" default="올리기"/>',
					handler	: function()	{
						var photoForm	= uploadWin.down('#photoForm');
						var toolbar		= itemInfoGrid.getDockedItems('toolbar[dock="top"]');
						var needSave	= !toolbar[0].getComponent('sub_save4').isDisabled();

						if (Ext.isEmpty(photoForm.getValue('photoFile'))) {
							Unilite.messageBox('<t:message code="system.message.base.message002" default="업로드 할 파일을 선택하십시오."/>');
							return false;
						}

						//jpg파일만 등록 가능
						var filePath		= photoForm.getValue('photoFile');
						var fileExtension	= filePath.lastIndexOf( "." );
						var fileExt			= filePath.substring( fileExtension + 1 );


						if(needSave)	{
							gsNeedPhotoSave = needSave;
							itemInfoStore.saveStore();

						} else {
							fnPhotoSave();
						}
					}
				},{
					xtype	: 'button',
					text	: '<t:message code="system.label.base.close" default="닫기"/>',
					handler	: function()	{
//						var photoForm = uploadWin.down('#photoForm').getForm();
//						if(photoForm.isDirty())	{
//							if(confirm('사진이 변경되었습니다. 저장하시겠습니까?'))	{
//								var config = {
//									success : function()	{
//										// TODO: fix it!!!
//										uploadWin.afterSavePhoto();
//									}
//								}
//								UniAppManager.app.onSaveDataButtonDown(config);
//
//							}else{
								// TODO: fix it!!!
								uploadWin.afterSavePhoto();
//							}
//
//						} else {
							uploadWin.hide();
//						}
					}
				}]
			});
		}
		uploadWin.show();
	}

	var photoForm = Ext.create('Unilite.com.form.UniDetailForm',{
		xtype		: 'uniDetailForm',
		disabled	: false,
		fileUpload	: true,
		itemId		: 'photoForm',
		api			: {
			submit	: scn100ukrvService.photoUploadFile
		},
		items		: [{
				xtype		: 'filefield',
				buttonOnly	: false,
				fieldLabel	: '<t:message code="system.label.base.photo" default="사진"/>',
				flex		: 1,
				name		: 'photoFile',
				id			: 'photoFile',
				buttonText	: '<t:message code="system.label.base.selectfile" default="파일선택"/>',
				width		: 270,
				labelWidth	: 70
			}
		]
	});

	function openPhotoWindow() {
		photoWin = Ext.create('widget.uniDetailWindow', {
			title		: '<t:message code="system.label.base.preview" default="미리보기"/>',
			modal		: true,
			resizable	: true,
			closable	: false,
			width		: '80%',
			height		: '100%',
			layout		: {
				type	: 'fit'
			},
			closeAction	: 'destroy',
			items		: [{
				xtype		: 'uniDetailForm',
				itemId		: 'downForm',
				url			: CPATH + "/fileman/downloadItemInfoImage/" + fid,
				layout		: {type: 'uniTable', columns:'1'},
				standardSubmit: true,
				disabled	: false,
				autoScroll	: true,
				items		: [{
					xtype	: 'image',
					itemId	: 'photView',
					autoEl	: {
						tag: 'img',
						src: CPATH+'/resources/images/human/noPhoto.png'
					}
	  			}]
			}],
			listeners : {
				beforeshow: function( window, eOpts)	{
					window.down('#photView').setSrc(CPATH+'/fileman/downloadItemInfoImage/' + fid);
				},
				show: function( window, eOpts)	{
					window.center();
				}
			},
			tbar:['->',{
				xtype	: 'button',
				text	: '<t:message code="system.label.base.download" default="다운로드"/>',
				handler	: function() {
					photoWin.down('#downForm').submit({
						success:function(comp, action)  {
							Ext.getBody().unmask();
						},
						failure: function(form, action){
							Ext.getBody().unmask();
						}
					});
				}
			},{
				xtype	: 'button',
				text	: '<t:message code="system.label.base.close" default="닫기"/>',
				handler	: function()	{
					photoWin.down('#downForm').clearForm();
					photoWin.close();
					photoWin.hide();
				}
			}]
		});
		photoWin.show();
	}



	Unilite.createValidator('validator01', {
		store	: directMasterStore,
		grid	: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "CONT_Q":
					if(newValue <= 0) {
						rv='<t:message code="system.message.sales.message034" default="양수만 입력가능합니다."/>';
						record.set('CONT_Q',oldValue);
						break
					}
					fnCalcAmt(record, 'Q', newValue);
				break;

				case "CONT_P":
					if(newValue <= 0) {
						rv='<t:message code="system.message.sales.message034" default="양수만 입력가능합니다."/>';
						record.set('CONT_Q',oldValue);
						break
					}
					fnCalcAmt(record, 'P', newValue);
				break;

				case "CONT_SUPPLY_AMT":
					if(newValue <= 0) {
						rv='<t:message code="system.message.sales.message034" default="양수만 입력가능합니다."/>';
						record.set('CONT_Q',oldValue);
						break
					}
					fnCalcAmt(record, 'O', newValue);
				break;

				case "CONT_TAX_AMT":
					if(newValue <= 0) {
						rv='<t:message code="system.message.sales.message034" default="양수만 입력가능합니다."/>';
						record.set('CONT_Q',oldValue);
						break
					}
					fnCalcAmt(record, 'T', newValue);
				break;
			}
			return rv;
		}
	});
};
</script>
