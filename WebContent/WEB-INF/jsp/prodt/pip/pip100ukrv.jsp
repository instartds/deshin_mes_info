<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="pip100ukrv"  >
	<t:ExtComboStore comboType="BOR120"  />	<!-- 사업장 -->
	<t:ExtComboStore comboType="OU" />		<!-- 창고-->
	<t:ExtComboStore comboType="WU" />		<!-- 작업장  -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;};  
#ext-element-3 {align:center}
</style>

<script type="text/javascript" >
var SearchInfoWindow;
var SearchRef1Window;	//참조:재고
var SearchRef2Window;	//참조:소요량

var geProviderMsg = '';	//최적화 작업 후 메세지 처리
var BsaCodeInfo = {		//컨트롤러에서 값을 받아옴.
	gsBasisNum	:	'${gsBasisNum}',
	gsMaxNum	:	'${gsMaxNum}'
};

var lossRateCalc = 0;

function appMain() {
	var p200Proxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy', {	//원단재고정보
		api: {
			read	: 'pip100ukrvService.p200SelectList',
			create	: 'pip100ukrvService.p200InsertDetail',
			update	: 'pip100ukrvService.p200UpdateDetail',
			destroy	: 'pip100ukrvService.p200DeleteDetail',
			syncAll	: 'pip100ukrvService.p200SaveAll'
		}
	});
	
	var p100Proxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy', {	//절단 소요량정보
		api: {
			read	: 'pip100ukrvService.p100SelectList',
			create	: 'pip100ukrvService.p100InsertDetail',
			update	: 'pip100ukrvService.p100UpdateDetail',
			destroy	: 'pip100ukrvService.p100DeleteDetail',
			syncAll	: 'pip100ukrvService.p100SaveAll'
		}
	});
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy', {	//최적화결과
		api: {
			read: 'pip100ukrvService.selectList'
		}
	});

	var wkordProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy', {	//작업지시 버튼 Proxy
		api: {
			create	: 'pip100ukrvService.wkordInsertDetail',
			syncAll	: 'pip100ukrvService.wkordSaveAll'
		}
	});



	Unilite.defineModel('p200Model', {		//원단재고정보
		fields: [
			{name: 'SEQ'			,text: '순번'			,type: 'int'},
			{name: 'COMP_CODE'		,text: 'COMP_CODE'	,type: 'string', allowBlank:false},
			{name: 'DIV_CODE'		,text: 'DIV_CODE'	,type: 'string', allowBlank:false},
			{name: 'ITEM_CODE'		,text: '품목코드'		,type: 'string', allowBlank:false},
			{name: 'ITEM_NAME'		,text: '품목명'		,type: 'string', allowBlank:false},
			{name: 'ITEM_WIDTH'		,text: '규격(폭)'		,type: 'float' , allowBlank:false},
			{name: 'LOT_NO'			,text: 'LOT NO'		,type: 'string'},
			{name: 'STOCK_Q'		,text: '현재고'		,type: 'float'  /* , decimalPrecision: 6 , format:'0,000.000000' */, allowBlank:false},
			{name: 'REMARK'			,text: '비고'			,type: 'string'},
			//20181218 추가
			{name: 'WH_CODE'		,text:'창고코드'		,type: 'string' },
			{name: 'WH_NAME'		,text:'창고명'			,type: 'string' },
			{name: 'TRNS_RATE'		,text:'입수(길이)'		,type: 'float'  /* , decimalPrecision: 6 , format:'0,000.000000' */ },
			{name: 'STOCK_LENGTH'	,text:'재고(길이)'		,type: 'float'  },
			{name: 'CUT'			,text:'CUT'			,type: 'float' },
			{name: 'REQ_LEN'		,text:'가용폭'			,type: 'float' }
		]
	});	

	Unilite.defineModel('p100Model', {		//절단 소요량정보
		fields: [
			{name: 'COMP_CODE'		,text: 'COMP_CODE'	,type: 'string', allowBlank:false},
			{name: 'DIV_CODE'		,text: 'DIV_CODE'	,type: 'string', allowBlank:false},
			{name: 'ITEM_CODE'		,text: 'ITEM_CODE'	,type: 'string', allowBlank:false},
			{name: 'CUT_ITEM_CODE'	,text: '절단품목'		,type: 'string', allowBlank:false},
			{name: 'CUT_ITEM_NAME'	,text: '품명'			,type: 'string'},
			{name: 'CALC_LEN'		,text: '절단폭'		,type: 'int', allowBlank:false},
			{name: 'ORDER_Q'		,text: '소요량'		,type: 'int', allowBlank:false},
			{name: 'MRP_CONTROL_NUM',text: '소요량번호'		,type: 'string'},
			{name: 'REMARK'			,text: '비고'			,type: 'string'}
		]
	});	

	Unilite.defineModel('detailModel', {	//최적화결과
		fields: [
			{name: 'COMP_CODE'			, text: 'COMP_CODE'			, type: 'string'},
			{name: 'DIV_CODE'			, text: 'DIV_CODE'			, type: 'string'},
			{name: 'ITEM_CODE'			, text: 'ITEM_CODE'			, type: 'string'},
			{name: 'STOCK_SEQ'			, text: 'STOCK_SEQ'			, type: 'int'},
			{name: 'STOCK_SEQ_EACH'		, text: 'STOCK_SEQ_EACH'	, type: 'int'},
			{name: 'REQ_LEN'			, text: '규격(폭)'				, type: 'int'},
			{name: 'CALC_LENS'			, text: '절단사이즈'				, type: 'string'},
			{name: 'SUM_LEN'			, text: '절단합계'				, type: 'int'},
			{name: 'REQ_LEN_TOTAL'		, text: '표준총폭'				, type: 'int'},
			{name: 'LOSS_LEN'			, text: 'LOSS폭'				, type: 'int'},
			{name: 'LOSS_RATE'			, text: 'LOSS율 %'			, type: 'uniER'},
			{name: 'I'					, text: '거래처'				, type: 'string'},
			{name: 'J'					, text: '거래처명'				, type: 'string'},
			{name: 'K'					, text: '구매요청번호'			, type: 'string'},
			//20181220 추가
			{name: 'REMARK'				, text: '<t:message code="system.label.product.remarks" default="비고"/>'					,type:'string'},
			{name: 'WORK_SHOP_CODE'		, text: '<t:message code="system.label.product.workcenter" default="작업장"/>'				,type:'string'	, allowBlank: false	, comboType: 'WU'},
			{name: 'PRODT_WKORD_DATE'	, text: '<t:message code="system.label.product.workorderdate" default="작업지시일"/>'		,type:'uniDate'	, allowBlank: false},
			{name: 'PRODT_START_DATE'	, text: '<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>'		,type:'uniDate'	, allowBlank: false},
			{name: 'TOP_WKORD_NUM'		, text: '<t:message code="system.label.product.topworkorderno2" default="통합작업지시번호"/>'	,type:'string'	}
		]
	});



	var p200Store = Unilite.createStore('p200Store',{				//원단재고정보
		proxy	: p200Proxy,
		model	: 'p200Model',
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,	// 상위 버튼 연결 
			editable	: true,		// 수정 모드 사용 
			deletable	: true,		// 삭제 가능 여부 
			useNavi		: false		// prev | next 버튼 사용
		},
		loadStoreRecords : function()	{
			var param= panelSearch.getValues();
			this.load({
				params : param
			});
		},
		
		saveStore : function(config)	{
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			if(inValidRecs.length == 0 ) {
				config = {
					success: function(batch, option) {
						p200Store.loadStoreRecords();
//						p200Store.commitChanges();
					}
				};
				this.syncAllDirect(config);
				
			} else {
				p200Grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		
		listeners: {
			update:function( store, record, operation, modifiedFieldNames, eOpts ) {
			},
			metachange:function( store, meta, eOpts ){
			}
		},
		
		_onStoreUpdate: function (store, eOpt) {
			console.log("Store data updated save btn enabled !");
			this.setToolbarButtons('sub_save1', true);
		}, // onStoreUpdate

		_onStoreLoad: function ( store, records, successful, eOpts ) {
			console.log("onStoreLoad");
			if (records) {
				this.setToolbarButtons('sub_save1', false);
			}
		},
		_onStoreDataChanged: function( store, eOpts )	{
			console.log("_onStoreDataChanged store.count() : ", store.count());
			if(store.count() == 0)	{
				this.setToolbarButtons(['sub_delete1'], false);
				Ext.apply(this.uniOpt.state, {'btn':{'sub_delete1':false}});
				
			} else {
				if(this.uniOpt.deletable)	{
					this.setToolbarButtons(['sub_delete1'], true);
					Ext.apply(this.uniOpt.state, {'btn':{'sub_delete1':true}});
				}
			}

			if(store.isDirty())	{
				this.setToolbarButtons(['sub_save1'], true);
			} else {
				this.setToolbarButtons(['sub_save1'], false);
			}
		},
		
		setToolbarButtons: function( btnName, state) {
			var toolbar = p200Grid.getDockedItems('toolbar[dock="top"]');
			var obj = toolbar[0].getComponent(btnName);
			if(obj) {
				(state) ? obj.enable():obj.disable();
			}
		}
	});
	
	var p100Store = Unilite.createStore('p100Store',{				//절단 소요량정보
		proxy	: p100Proxy,
		model	: 'p100Model',
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,	// 상위 버튼 연결 
			editable	: true,		// 수정 모드 사용 
			deletable	: true,		// 삭제 가능 여부 
			useNavi		: false		// prev | next 버튼 사용
		},
		loadStoreRecords : function(getCustomCode)	{
			var param= panelSearch.getValues();
			this.load({
				params : param
			});
		},
		saveStore : function(config)	{
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			if(inValidRecs.length == 0 ) {
				config = {
					success: function(batch, option) {
						p100Store.loadStoreRecords();
//						p100Store.commitChanges();
					}
				};
				this.syncAllDirect(config);
				
			} else {
				p100Grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		
		listeners: {
			update:function( store, record, operation, modifiedFieldNames, eOpts ) {
			},
			metachange:function( store, meta, eOpts ){
			}
		},
		
		_onStoreUpdate: function (store, eOpt) {
			console.log("Store data updated save btn enabled !");
			this.setToolbarButtons('sub_save2', true);
		}, // onStoreUpdate

		_onStoreLoad: function ( store, records, successful, eOpts ) {
			console.log("onStoreLoad");
			if (records) {
				this.setToolbarButtons('sub_save2', false);
			}
		},
		_onStoreDataChanged: function( store, eOpts )	{
			console.log("_onStoreDataChanged store.count() : ", store.count());
			if(store.count() == 0)	{
				this.setToolbarButtons(['sub_delete2'], false);
				Ext.apply(this.uniOpt.state, {'btn':{'sub_delete2':false}});
			} else {
				if(this.uniOpt.deletable)	{
					this.setToolbarButtons(['sub_delete2'], true);
					Ext.apply(this.uniOpt.state, {'btn':{'sub_delete2':true}});
				}
			}

			if(store.isDirty())	{
				this.setToolbarButtons(['sub_save2'], true);
			} else {
				this.setToolbarButtons(['sub_save2'], false);
			}
		},
		setToolbarButtons: function( btnName, state)	{
			var toolbar = p100Grid.getDockedItems('toolbar[dock="top"]');
			var obj = toolbar[0].getComponent(btnName);
			if(obj) {
				(state) ? obj.enable():obj.disable();
			}
		}
	});

	var detailStore = Unilite.createStore('detailStore', {			//최적화결과
		model	: 'detailModel',
		uniOpt	: {
			isMaster	: false,	// 상위 버튼 연결
			editable	: true,		// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		proxy	: directProxy,
		loadStoreRecords: function() {
			var param = panelSearch.getValues();
			this.load({
				params: param
			});
		},
		saveStore: function() {
			var toCreate = this.getNewRecords();
			var toUpdate = this.getUpdatedRecords();
			var toDelete = this.getRemovedRecords();
			var list = [].concat(toUpdate, toCreate, toDelete);
			var listLength = list.length;
			var inValidRecs = this.getInvalidRecords();
			
			var paramMaster = masterForm.getValues();	//syncAll 수정
			paramMaster.DIV_CODE = panelSearch.getValue('DIV_CODE');
			
			if (inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						var master = batch.operations[0].getResultSet();
						masterForm.setValue("AS_NUM", master.AS_NUM);
						masterForm.getForm().wasDirty = false;
						masterForm.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);
						detailStore.loadStoreRecords();
					}
				};
				this.syncAllDirect(config);
			} else {
				detailGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				if(!Ext.isEmpty(geProviderMsg)) {
					alert(geProviderMsg);
					geProviderMsg = '';
				}
				
				if(store.getCount() > 0){
					var lossLenSum = 0;
					var reqLenTotalSum = 0;
					
					Ext.each(records, function(record,i){
						lossLenSum = lossLenSum + record.get('LOSS_LEN');		//LOSS폭 SUM
						reqLenTotalSum = reqLenTotalSum + record.get('REQ_LEN_TOTAL');	//표준총폭 SUM
					});
					
					lossRateCalc = lossLenSum / reqLenTotalSum * 100;
				}else{
					lossRateCalc = 0 ;
				}
			}
		}
	});



	var panelSearch = Unilite.createSearchForm('pip100ukrvForm', {
		region	:'north',
		layout	: {type : 'uniTable', columns : 4
//		,tdAttrs: {style: 'border : 1px solid #ced9e7;'}
		},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel	: '사업장',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			width		: 250,
			allowBlank	: false
		}, 
		Unilite.popup('DIV_PUMOK', {
			fieldLabel		: '원단품목',
			valueFieldName	: 'ITEM_CODE',
			textFieldName	: 'ITEM_NAME',
			allowBlank		: false,
			width			: 325,
			listeners		: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('SPEC'			,records[0]["SPEC"]);
						panelSearch.setValue('TRNS_RATE'	,records[0]["PUR_TRNS_RATE"]);
						panelSearch.setValue('ITEM_WIDTH'	,records[0]["ITEM_WIDTH"]);
						
						var param = {
							"DIV_CODE"	: panelSearch.getValue('DIV_CODE'),
							"ITEM_CODE"	: panelSearch.getValue('ITEM_CODE')
						};
						pip100ukrvService.checkDataP200(param, function(provider, response) {
							if(!Ext.isEmpty(provider)){
								if(confirm('최적화계산한 결과값이 있습니다. \n 삭제후 다시 진행하시겠습니까?')) {
									pip100ukrvService.deleteAllLogic(param, function(provider, response) {
										if(!Ext.isEmpty(provider)){
											if(provider=='Y'){
												Ext.Msg.alert('확인', "삭제가 완료되었습니다. 계속 진행해주십시오.");
											} else {
												Ext.Msg.alert('확인', "다시 시도해주십시오.");
											}
										} else {
											Ext.Msg.alert('확인', "다시 시도해주십시오.");
										}
										
										p200Store.loadStoreRecords();
										p100Store.loadStoreRecords();
										detailStore.loadStoreRecords();
//										p200Store.commitChanges();
//										p100Store.commitChanges();
//										detailStore.commitChanges();
										
									});
								} else {
									p200Store.loadStoreRecords();
									p100Store.loadStoreRecords();
									detailStore.loadStoreRecords();
//									p200Store.commitChanges();
//									p100Store.commitChanges();
//									detailStore.commitChanges();
								}
							}
						});
						panelSearch.getField('DIV_CODE').setReadOnly(true);
						panelSearch.getField('ITEM_CODE').setReadOnly(true);
						panelSearch.getField('ITEM_NAME').setReadOnly(true);
					},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.setValue('SPEC', '');
				},
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
				}
			}
		}),{
			fieldLabel	: '',
			name		: 'SPEC',
			xtype		: 'uniTextfield',
			readOnly	: true
		},{	//20190110 추가 (품목명, 입수(길이), 규격(폭), 가용폭 추가)
			fieldLabel	: 'TRNS_RATE',
			name		: 'TRNS_RATE',
			xtype		: 'uniTextfield',
			readOnly	: true,
			hidden		: true
		},{
			fieldLabel	: 'ITEM_WIDTH',
			name		: 'ITEM_WIDTH',
			xtype		: 'uniTextfield',
			readOnly	: true,
			hidden		: true
		},{
			xtype	: 'container',
			layout	: {type : 'uniTable'},
			items	: [{
				fieldLabel	: '<t:message code="system.label.product.numberofexecutions" default="실행횟수"/>',
				name		: 'EXEC_CNT',
				xtype		: 'uniNumberfield',
				width		: 160,
				listeners	: {
					blur : function (field, event, eOpts) {
						var newValue = field.getValue();
						if(newValue <= 0){
							alert('<t:message code="system.message.product.message023" default="입력한 값이 0보다 큰 수이어야 합니다."/>');
							panelSearch.setValue('EXEC_CNT', 0);
							return false;
						}
						if(newValue > BsaCodeInfo.gsMaxNum){
							alert(BsaCodeInfo.gsMaxNum + '<t:message code="system.message.product.message063" default="을(를) 넘는 수를 입력할 수 없습니다."/>');
							panelSearch.setValue('EXEC_CNT', 0);
							return false;
						}
					}
				}
			},{
				text	: '최적화계산',
				itemId	: 'calcButton',
				id		: 'calcButton2',
				xtype	: 'button',
				margin	: '0 0 3 5',
				width	: 100,
				handler	: function() {
					if(!panelSearch.getInvalidMessage()){
						return false;
					}
					var p200R	= p200Store.data.items;
					var p100R	= p100Store.data.items;
					var detailR	= detailStore.data.items;
					
					if(Ext.isEmpty(p200R)){
						alert('최적화계산할 원단재고정보가 없습니다. 확인 해주십시오.');
						return false;
						
					} else if(Ext.isEmpty(p100R)){
						alert('최적화계산할 절단소요량정보가 없습니다. 확인 해주십시오.');
						return false;
					}
					
					if(p200Store.isDirty()){
						alert('원단재고정보에 저장할 데이터가 있습니다. 저장을 먼저 진행 해주십시오.');
						return false;
						
					} else if(p100Store.isDirty()){
						alert('절단소요량정보에 저장할 데이터가 있습니다. 저장을 먼저 진행 해주십시오.');
						return false;
					}
	
					if(!Ext.isEmpty(detailR)) {
						if(!confirm('최적화결과가 존재합니다.\n다시 진행하시겠습니까?')) {
							return false;
						}
					}
					
					var param = {
						"DIV_CODE"	: panelSearch.getValue('DIV_CODE'),
						"ITEM_CODE"	: panelSearch.getValue('ITEM_CODE'),
						"EXEC_CNT"	: panelSearch.getValue('EXEC_CNT')
					};
					Ext.getBody().mask('<t:message code="system.label.product.working" default="작업 중..."/>','loading-indicator');
					pip100ukrvService.optimizingCutOff(param, function(provider, response)	{
						geProviderMsg = '';
						if(!Ext.isEmpty(provider)){
							if(provider=='Y'){
								Ext.Msg.alert('확인','최적화계산 성공');
								detailStore.loadStoreRecords();
								
							} else if(provider=='N'){
								Ext.Msg.alert('확인','최적화계산 실패 \n 다시 시도해주십시오.');
								
							} else {
								geProviderMsg = provider;
								detailStore.loadStoreRecords();
//								alert(provider);
							}
						}
						Ext.getBody().unmask();
					});
				}
			}]
		}]
	});



	var p200Grid = Unilite.createGrid('p200Grid', {					//원단재고정보
		store			: p200Store,
		title			: '원단재고정보',
		region			: 'east',
		border			: true,
		sortableColumns : false,
		uniOpt: {
			expandLastColumn	: false,
			useLiveSearch		: false,
			useContextMenu		: false,
			useMultipleSorting	: false,
			useGroupSummary		: false,
			useRowNumberer		: false,
			filter: {
				useFilter	: false,
				autoCreate	: false
			},
			state: {
				useState	: false,
				useStateList: false
			}
		},
		features: [ 
			{id: 'p200GridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: true},
			{id: 'p200GridTotal'	, ftype: 'uniSummary'			, showSummaryRow: true}
		],
		dockedItems	: [{
			xtype	: 'toolbar',
			dock	: 'top',
				items	: [{
				fieldLabel	:'CUT',
				xtype		: 'uniNumberfield',
				id			: 'CUT',
				value		: 0,
//				decimalPrecision:4,
				format		:'0,000',
				labelWidth	: 30,
				width		: 80
			},' ',' ',' ','-',' ',' ',' ',{
				xtype	: 'uniBaseButton',
				text	: '<t:message code="system.label.base.add" default="추가"/>',
				tooltip	: '<t:message code="system.label.base.add" default="추가"/>',
				iconCls	: 'icon-new',
				width	: 26,
				height	: 26,
				itemId	: 'sub_newData1',
				handler	: function() { 
					if(!panelSearch.getInvalidMessage()) return;	//필수체크
					
					var compCode	= UserInfo.compCode;
					var divCode		= panelSearch.getValue('DIV_CODE');
					var itemCode	= panelSearch.getValue('ITEM_CODE');
					//20190110 추가 (품목명, 입수(길이), 규격(폭), 가용폭 추가)
					var itemName	= panelSearch.getValue('ITEM_NAME');
					var trnsRate	= panelSearch.getValue('TRNS_RATE');
					var itemWidth	= panelSearch.getValue('ITEM_WIDTH');
					var reqLen		= panelSearch.getValue('ITEM_WIDTH') - Ext.getCmp('CUT').value;
					
					var seq			= p200Store.max('SEQ');
					if(!seq){
						seq = 1;
					} else {
						seq += 1;
					}

					var r = {
						COMP_CODE	: compCode,
						DIV_CODE	: divCode,
						ITEM_CODE	: itemCode,
						//20190110 추가 (품목명, 입수(길이), 규격(폭), 가용폭 추가)
						ITEM_NAME	: itemName,
						TRNS_RATE	: trnsRate,
						ITEM_WIDTH	: itemWidth,
						REQ_LEN		: reqLen,
						
						SEQ			: seq
					};
					p200Grid.createRow(r);
				}
			},{
				xtype	: 'uniBaseButton',
				text	: '<t:message code="system.label.base.delete" default="삭제"/>',
				tooltip	: '<t:message code="system.label.base.delete" default="삭제"/>',
				iconCls	: 'icon-delete',
				disabled: true,
				width	: 26, 
				height	: 26,
				itemId	: 'sub_delete1',
				handler	: function() { 
					if(!panelSearch.getInvalidMessage()) return;	//필수체크
					var selRow = p200Grid.getSelectedRecord();
					if(selRow.phantom === true)	{
						p200Grid.deleteSelectedRow();

					} else if(confirm('<t:message code="system.message.base.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
						p200Grid.deleteSelectedRow();
					}
				}
			},{
				xtype	: 'uniBaseButton',
				text	: '<t:message code="system.label.base.save" default="저장 "/>', 
				tooltip	: '<t:message code="system.label.base.save" default="저장 "/>', 
				iconCls	: 'icon-save',
				disabled: true,
				width	: 26,
				height	: 26,
				itemId	: 'sub_save1',
				handler : function() {
					if(!panelSearch.getInvalidMessage()) return;	//필수체크
					var inValidRecs = p200Store.getInvalidRecords();
					if(inValidRecs.length == 0 )	{
						var saveTask =Ext.create('Ext.util.DelayedTask', function(){
							p200Store.saveStore();
						});
						saveTask.delay(500);
						
					} else {
						p200Grid.uniSelectInvalidColumnAndAlert(inValidRecs);
					}
				}
			},' ',' ',' ','-',' ',' ',' ',{
				text	: '참조 : 재고',
				xtype	: 'button',
				id		: 'btnRef1',
				minWidth: 80,
				handler	: function() {
					if(!panelSearch.getInvalidMessage()) return;	//필수체크
					openSearchRef1Window();
				}
			}]
		}],
		columns:[
			{ dataIndex: 'COMP_CODE'	, width: 120 , hidden:true},
			{ dataIndex: 'DIV_CODE'		, width: 120 , hidden:true},
			{ dataIndex: 'SEQ'			, width: 50 },
			{ dataIndex: 'WH_CODE'		, width: 80  , hidden:true},
			{ dataIndex: 'WH_NAME'		, width: 88 },
			{ dataIndex: 'ITEM_CODE'	, width: 120},
			{ dataIndex: 'ITEM_NAME'	, width: 120},
			{ dataIndex: 'ITEM_WIDTH'	, width: 88 },
			{ dataIndex: 'TRNS_RATE'	, width: 88 },
			{ dataIndex: 'LOT_NO'		, width: 110},
			{ dataIndex: 'STOCK_Q'		, width: 88  , summaryType:'sum'},
			{ dataIndex: 'STOCK_LENGTH'	, width: 88  , summaryType:'sum'},
			{ dataIndex: 'CUT'			, width: 80 },
			{ dataIndex: 'REQ_LEN'		, width: 88  , summaryType:'sum'},
			{ dataIndex: 'REMARK'		, minWidth: 120,flex:1}
		
		],
		setRef1Data:function(record){
			var grdRecord = this.getSelectedRecord();
			
			grdRecord.set('LOT_NO'	, record['LOT_NO']);
			grdRecord.set('STOCK_Q'	, record['STOCK_Q']);
			grdRecord.set('CUT'		, Ext.getCmp('CUT').value);
			
			//숫자값일때만 가져오도록
			if(isNaN(record['SPEC']) == false){
				grdRecord.set('REQ_LEN'		, record['ITEM_WIDTH'] - grdRecord.get('CUT')); 
			}
			//20181218 추가
			grdRecord.set('WH_CODE'		, record['WH_CODE']);
			grdRecord.set('WH_NAME'		, record['WH_NAME']);
			grdRecord.set('ITEM_WIDTH'	, record['ITEM_WIDTH']);
			grdRecord.set('TRNS_RATE'	, record['TRNS_RATE']);
			grdRecord.set('STOCK_LENGTH', record['STOCK_LENGTH']);
		},
		listeners: {
			beforeedit: function( editor, e, eOpts ) {
				if(UniUtils.indexOf(e.field, ['COMP_CODE', 'DIV_CODE', 'SEQ', 'WH_CODE', 'WH_NAME', 'ITEM_CODE', 'ITEM_NAME'
											, 'ITEM_WIDTH', 'TRNS_RATE', 'LOT_NO'/*, 'STOCK_Q'*/, 'STOCK_LENGTH'])){
					return false;
					
				} else {
					return true;
				}
			}
		}
	});
	
	var p100Grid = Unilite.createGrid('p100Grid', {					//절단 소요량정보
		store	: p100Store,
		title	: '절단 소요량정보',
		region	: 'west',
		border	: true,
		split	: true,
		uniOpt	: {
			expandLastColumn		: false,
			useLiveSearch		: false,
			useContextMenu		: false,
			useMultipleSorting	: false,
			useGroupSummary		: false,
			useRowNumberer		: false,
			filter: {
				useFilter	: false,
				autoCreate	: false
			},
			state: {
				useState	: false,
				useStateList: false
			}
		},
		sortableColumns : false,
		features: [ 
			{id: 'p100GridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: true},
			{id: 'p100GridTotal'	, ftype: 'uniSummary'			, showSummaryRow: true}
		],
		dockedItems	: [{
			xtype	: 'toolbar',
			dock	: 'top',
			items	: [{
				xtype	: 'uniBaseButton',
				text	: '<t:message code="system.label.base.add" default="추가"/>',
				tooltip	: '<t:message code="system.label.base.add" default="추가"/>',
				iconCls	: 'icon-new',
				width	: 26,
				height	: 26,
				itemId	: 'sub_newData2',
				handler	: function() { 
					if(!panelSearch.getInvalidMessage()) return;	//필수체크
					var compCode	= UserInfo.compCode;
					var divCode		= panelSearch.getValue('DIV_CODE');
					var itemCode	= panelSearch.getValue('ITEM_CODE');
			
					var r = {
						COMP_CODE	: compCode,
						DIV_CODE	: divCode,
						ITEM_CODE	: itemCode
					};
					p100Grid.createRow(r);
				}
			},{
				xtype	: 'uniBaseButton',
				text	: '<t:message code="system.label.base.delete" default="삭제"/>',
				tooltip	: '<t:message code="system.label.base.delete" default="삭제"/>',
				iconCls	: 'icon-delete',
				disabled: true,
				width	: 26, 
				height	: 26,
				itemId	: 'sub_delete2',
				handler	: function() { 
					if(!panelSearch.getInvalidMessage()) return;	//필수체크
					var selRow = p100Grid.getSelectedRecord();
					if(selRow.phantom === true)	{
						p100Grid.deleteSelectedRow();

					} else if(confirm('<t:message code="system.message.base.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
						p100Grid.deleteSelectedRow();
					}
				}
			},{
				xtype	: 'uniBaseButton',
				text	: '<t:message code="system.label.base.save" default="저장 "/>', 
				tooltip	: '<t:message code="system.label.base.save" default="저장 "/>', 
				iconCls	: 'icon-save',
				disabled: true,
				width	: 26,
				height	: 26,
				itemId	: 'sub_save2',
				handler	: function() {
					if(!panelSearch.getInvalidMessage()) return;	//필수체크
					var inValidRecs = p100Store.getInvalidRecords();
					if(inValidRecs.length == 0 )	{
						var saveTask =Ext.create('Ext.util.DelayedTask', function(){
							p100Store.saveStore();
						});
						saveTask.delay(500);

					} else {
						p100Grid.uniSelectInvalidColumnAndAlert(inValidRecs);
					}
				}
			},' ',' ',' ','-',' ',' ',' ',{
				
				xtype	: 'button',
				id		: 'btnRef2',
				minWidth: 80,
				text	: '참조 : 소요량',
				handler	: function() {
					if(!panelSearch.getInvalidMessage()) return;	//필수체크
					openSearchRef2Window();
				}
			}]
		 }],
		setRef2Data:function(record){
			var grdRecord = this.getSelectedRecord();
			
			grdRecord.set('CUT_ITEM_CODE'	,record['ITEM_CODE']);
			grdRecord.set('CUT_ITEM_NAME'	,record['ITEM_NAME']);
			
			if(isNaN(record['SPEC']) == false){
				grdRecord.set('CALC_LEN'	,record['SPEC']);			// 숫자값일때만 가져오도록
			}
			grdRecord.set('ORDER_Q'			,record['PROD_Q']);
			grdRecord.set('MRP_CONTROL_NUM'	,record['MRP_CONTROL_NUM']);
		},
		columns:[
			{ dataIndex: 'COMP_CODE'		, width: 120,hidden:true},
			{ dataIndex: 'DIV_CODE'			, width: 120,hidden:true},
			{ dataIndex: 'ITEM_CODE'		, width: 120,hidden:true},
			{ dataIndex: 'CUT_ITEM_CODE'	, width: 120,
				editor: Unilite.popup('DIV_PUMOK_G', {
					textFieldName	: 'ITEM_CODE',
					DBtextFieldName	: 'ITEM_CODE',
					autoPopup		: true,
					listeners		: {
						'onSelected': {
							fn: function(records, type) {
								var grdRecord = p100Grid.uniOpt.currentRecord;
									grdRecord.set('CUT_ITEM_CODE', records[0]['ITEM_CODE']);
									grdRecord.set('CUT_ITEM_NAME', records[0]['ITEM_NAME']);
							},
							scope: this
						},
						'onClear': function(type) {
							var grdRecord = p100Grid.uniOpt.currentRecord;
								grdRecord.set('CUT_ITEM_CODE', '');
								grdRecord.set('CUT_ITEM_NAME', '');
						},
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
							popup.setExtParam({'ADD_QUERY3': "AND ITEM_CODE != "+  "'"+panelSearch.getValue('ITEM_CODE')+ "'"+ " AND ITEM_CODE LIKE " + "'"+panelSearch.getValue('ITEM_CODE')+ "%'" });
						}
					}
				 })
			},
			{ dataIndex: 'CUT_ITEM_NAME'	, width: 120,
				editor: Unilite.popup('DIV_PUMOK_G', {
					textFieldName: 'ITEM_NAME',
					DBtextFieldName: 'ITEM_NAME',
					autoPopup			: true,
					listeners			: {
						'onSelected': {
							fn: function(records, type) {
								var grdRecord = p100Grid.uniOpt.currentRecord;
									grdRecord.set('CUT_ITEM_CODE', records[0]['ITEM_CODE']);
									grdRecord.set('CUT_ITEM_NAME', records[0]['ITEM_NAME']);
							},
							scope: this
						},
						'onClear': function(type) {
							var grdRecord = p100Grid.uniOpt.currentRecord;
								grdRecord.set('CUT_ITEM_CODE', '');
								grdRecord.set('CUT_ITEM_NAME', '');
						},
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
							popup.setExtParam({'ADD_QUERY3': "AND ITEM_CODE != "+  "'"+panelSearch.getValue('ITEM_CODE')+ "'"+ " AND ITEM_CODE LIKE " + "'"+panelSearch.getValue('ITEM_CODE')+ "%'" });
						}
					}
				 })
			},
			{ dataIndex: 'CALC_LEN'			, width: 120},
			{ dataIndex: 'ORDER_Q'			, width: 120,summaryType:'sum'},
			{ dataIndex: 'MRP_CONTROL_NUM'	, width: 150},
			{ dataIndex: 'REMARK'			, minWidth: 120,flex:1}
		],
		listeners: {
			beforeedit: function( editor, e, eOpts ) {
				if(UniUtils.indexOf(e.field, ['COMP_CODE','DIV_CODE','ITEM_CODE'])){
					return false;
				} else {
					return true;
				}
			}
		}
	});

	var detailGrid = Unilite.createGrid('detailGrid', {				//최적화결과
		store	: detailStore,
		title	: '최적화결과',
		region	: 'center',
		layout	: 'fit',
		flex	: 1,
		uniOpt	: {
			expandLastColumn	: true,
			useLiveSearch		: false,
			useContextMenu		: false,
			useMultipleSorting	: false,
			useGroupSummary		: false,
			useRowNumberer		: false,
			onLoadSelectFirst	: false,
			filter: {
				useFilter	: false,
				autoCreate	: false
			},
			state: {
				useState	: false,
				useStateList: false
			}
		},
		features: [ 
			{id: 'detailGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: true},
			{id: 'detailGridTotal'	, ftype: 'uniSummary'			, showSummaryRow: true}
		],
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly : false, toggleOnClick: false,
			listeners: {
				select: function(grid, selectRecord, index, rowIndex, eOpts ){
//					if (this.selected.getCount() > 0) {
//						Ext.getCmp('btnPrint').enable();
//						Ext.getCmp('btnPrint2').enable();
//					}
				},
				deselect:  function(grid, selectRecord, index, eOpts ){
//					var toDelete = detailStore.getRemovedRecords();
//					if (this.selected.getCount() == 0) {
//						Ext.getCmp('btnPrint').disable();
//						Ext.getCmp('btnPrint2').disable();
//					}
				}
			}
		}),
		dockedItems	: [{
			xtype	: 'toolbar',
			dock	: 'top',
			items	: [{
				xtype	: 'button',
				id		: 'btnWkord',
				text	: '작업지시',
				minWidth: 80,
				handler	: function() {
					var err_flag = false;
					var records = detailGrid.getSelectedRecords();
					
					Ext.each(records, function(rec, i){
						if(!Ext.isEmpty(rec.get('TOP_WKORD_NUM'))) {
							err_flag = true;
							alert('이미 작업지시가 내려진 데이터 입니다.');
							return false
						}
						rec.phantom = true;
						wkordStore.insert(i, rec);
					});
					
					if(!err_flag) {
						wkordStore.saveStore();
					}
				}
			}/*,' ','-',' ',{
				xtype	: 'button',
				id		: 'btnReq',
				text	: '구매요청',
				minWidth: 80,
				handler	: function() {
				}
			},{
				xtype	: 'button',
				id		: 'btnCancel',
				text	: '구매취소',
				minWidth: 80,
				handler	: function() {
				}
			}*/]
		}],
		columns: [
			{ dataIndex: 'COMP_CODE'		, width: 120 ,hidden:true},
			{ dataIndex: 'DIV_CODE'			, width: 120 ,hidden:true},
			{ dataIndex: 'ITEM_CODE'		, width: 120 ,hidden:true},
			{ dataIndex: 'STOCK_SEQ'		, width: 120 ,hidden:true},
			{ dataIndex: 'STOCK_SEQ_EACH'	, width: 120 ,hidden:true},
			{ dataIndex: 'REQ_LEN'			, width: 80 },
			{ dataIndex: 'CALC_LENS'		, width: 300},
//			{ dataIndex: 'C'				, width: 120},
//			{ dataIndex: 'D'				, width: 120},
			{ dataIndex: 'SUM_LEN'			, width: 120,summaryType:'sum'},
			{ dataIndex: 'REQ_LEN_TOTAL'	, width: 120,summaryType:'sum'},
			{ dataIndex: 'LOSS_LEN'			, width: 120,summaryType:'sum'},
			{ dataIndex: 'LOSS_RATE'		, width: 120,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '','<div align="right">'+ Ext.util.Format.number(lossRateCalc,'0,000.00000')+'</div>');
            	}
			},
//			{ dataIndex: 'I'				, width: 120 ,hidden:true},
//			{ dataIndex: 'J'				, width: 120 ,hidden:true},
//			{ dataIndex: 'K'				, width: 120 ,hidden:true},

			//20181220 추가
			{ dataIndex: 'WORK_SHOP_CODE'	, width: 100,
				editor:{
					xtype		: 'uniCombobox',
					comboType	: 'WU',
					listeners	:{
						beforequery:function(queryPlan, value) {
							var store = queryPlan.combo.getStore();
							this.store.clearFilter();
							this.store.filterBy(function(record){
								return (record.get('value') == 'WC70' || record.get('value') > 'WC90')
							}, this)
						}
					}
				}
			},
			{ dataIndex: 'PRODT_WKORD_DATE'	, width: 80 },
			{ dataIndex: 'PRODT_START_DATE'	, width: 80 },
			{ dataIndex: 'REMARK'			, width: 150},
			{ dataIndex: 'TOP_WKORD_NUM'	, width: 120}
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				if (UniUtils.indexOf(e.field, ['REMARK', 'WORK_SHOP_CODE', 'PRODT_WKORD_DATE', 'PRODT_START_DATE'])) {
					return true;
				} else {
					return false;
				}
			}
		}
	});



	//검색 팝업
	var subSearch = Unilite.createSearchForm('subSearchForm', {
		layout: {
			type	: 'uniTable',
			columns	: 2
		},
		trackResetOnLoad: true,
		items	: [{
			fieldLabel	: '사업장',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			width		: 250,
			allowBlank	: false,
			readOnly	: true
		}, 
		Unilite.popup('DIV_PUMOK', {
			fieldLabel		: '원단품목',
			valueFieldName	: 'ITEM_CODE',
			textFieldName	: 'ITEM_NAME',
			width			: 325,
			listeners		: {
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': subSearch.getValue('DIV_CODE')});
				}
			}
		})]
	});

	Unilite.defineModel('subModel', {
		fields: [
			{ name: 'COMP_CODE'	,text:'COMP_CODE'	,type: 'string' }, 
			{ name: 'DIV_CODE'	,text:'사업장'			,type: 'string' ,comboType:'BOR120'}, 
			{ name: 'ITEM_CODE'	,text:'품목코드'		,type: 'string' }, 
			{ name: 'ITEM_NAME'	,text:'품목명'			,type: 'string' }, 
			{ name: 'SPEC'		,text:'규격'			,type: 'string' },
			//20190110 추가
			{ name: 'ITEM_WIDTH',text:'규격(폭)'		,type: 'float'  },
			{ name: 'TRNS_RATE'	,text:'입수(길이)'		,type: 'float'  /* , decimalPrecision: 6 , format:'0,000.000000' */ }
		]
	});

	var subStore = Unilite.createStore('subStore', {
		model	: 'subModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		proxy: {
			type: 'direct',
			api: {
				read: 'pip100ukrvService.subSelectList'
			}
		},
		loadStoreRecords: function() {
			var param = subSearch.getValues();
			this.load({
				params: param
			});
		}
	});

	var subGrid = Unilite.createGrid('subGrid', {
		store	: subStore,
		layout	: 'fit',
		uniOpt	: {
			expandLastColumn	: true,
			useLiveSearch		: false,
			useContextMenu		: false,
			useMultipleSorting	: false,
			useGroupSummary		: false,
			useRowNumberer		: true,
			filter: {
				useFilter	: false,
				autoCreate	: false
			},
			state: {
				useState	: false,
				useStateList: false
			}
		},
		selModel:'rowmodel',
		columns: [
			{ dataIndex: 'COMP_CODE'	, width: 100 ,hidden:true},
			{ dataIndex: 'DIV_CODE'		, width: 100 },
			{ dataIndex: 'ITEM_CODE'	, width: 100 },
			{ dataIndex: 'ITEM_NAME'	, width: 200 },
			{ dataIndex: 'SPEC'			, width: 150 }
		],
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
				subGrid.returnData(record)
				SearchInfoWindow.hide();
				panelSearch.getField('ITEM_CODE').focus();
				panelSearch.getField('ITEM_CODE').blur();
			}
		},
		returnData: function(record) {
			if (Ext.isEmpty(record)) {
				record = this.getSelectedRecord();
			}
			panelSearch.setValues({
				'ITEM_CODE'	: record.get('ITEM_CODE'),
				'ITEM_NAME'	: record.get('ITEM_NAME'),
				'SPEC'		: record.get('SPEC'),
				'TRNS_RATE'	: record.get('TRNS_RATE'),
				'ITEM_WIDTH': record.get('ITEM_WIDTH')
			});
		}
	});

	function openSearchInfoWindow() {
		if (!SearchInfoWindow) {
			SearchInfoWindow = Ext.create('widget.uniDetailWindow', {
				title	: '원단품목검색',
				width	: 650,
				height	: 580,
				layout	: {
					type	: 'vbox',
					align	: 'stretch'
				},
				items	: [subSearch, subGrid],
				tbar	: ['->',{
					itemId	: 'searchBtn',
					text	: '조회',
					minWidth: 100,
					handler	: function() {
						if(!subSearch.getInvalidMessage()) return;	//필수체크
						subStore.loadStoreRecords();
					},
					disabled: false
				},{
					itemId	: 'closeBtn',
					text	: '닫기',
					minWidth: 100,
					handler	: function() {
						SearchInfoWindow.hide();
					},
					disabled: false
				}],
				listeners: {
					beforehide: function(me, eOpt) {
						subSearch.clearForm();
						subGrid.reset();
						subStore.clearData();
					},
					beforeclose: function(panel, eOpts) {
					},
					show: function(panel, eOpts) {
						subSearch.setValue('DIV_CODE', panelSearch.getValue('DIV_CODE'));
					}
				}
			})
		}
		SearchInfoWindow.center();
		SearchInfoWindow.show();
	}



	//원단재고정보 - 참조:재고
	var ref1Search = Unilite.createSearchForm('ref1SearchForm', {
		layout: {
			type: 'uniTable',
			columns: 2
		},
		trackResetOnLoad: true,
		items: [{
			fieldLabel	: '사업장',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			width		: 250,
			allowBlank	: false,
			readOnly	: true
		}, 
		Unilite.popup('DIV_PUMOK', {
			fieldLabel		: '원단품목',
			valueFieldName	: 'ITEM_CODE',
			textFieldName	: 'ITEM_NAME',
			width			: 325,
			allowBlank		: false,
			readOnly		: true
		}),{
			xtype		: 'uniTextfield',
			fieldLabel	: 'LOT번호',
			name		: 'LOT_NO'
		},{
			fieldLabel	: '창고',
			name		: 'WH_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'OU',
			width		: 250
		}]
	});
	
	Unilite.defineModel('ref1Model', {
		fields: [
			{ name: 'COMP_CODE'		,text:'COMP_CODE'	,type: 'string'},
			{ name: 'DIV_CODE'		,text:'사업장'			,type: 'string',comboType:'BOR120'},
			{ name: 'ITEM_CODE'		,text:'품목코드'		,type: 'string'},
			{ name: 'ITEM_NAME'		,text:'품목명'			,type: 'string'},
			{ name: 'SPEC'			,text:'규격(폭)'		,type: 'string'},
			{ name: 'LOT_NO'		,text:'LOT번호'		,type: 'string'},
			{ name: 'STOCK_Q'		,text:'현재고'			,type: 'float' },
			{ name: 'STOCK_LENGTH'	,text:'재고(길이)'		,type: 'float' /* , decimalPrecision: 6 , format:'0,000.000000' */},
			//20181218 추가
			{ name: 'WH_CODE'		,text:'창고코드'		,type: 'string', xtype: 'uniCombobox', comboType: 'OU'},
			{ name: 'WH_NAME'		,text:'창고명'			,type: 'string'},
			{ name: 'TRNS_RATE'		,text:'입수(길이)'		,type: 'float' /* , decimalPrecision: 6 , format:'0,000.000000' */ },
			{ name: 'ITEM_WIDTH'	,text:'규격(폭)'		,type: 'float' }
		]
	});

	var ref1Store = Unilite.createStore('ref1Store', {
		model	: 'ref1Model',
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		proxy: {
			type: 'direct',
			api	: {
				read: 'pip100ukrvService.ref1SelectList'
			}
		},
		loadStoreRecords: function() {
			var param = ref1Search.getValues();
			this.load({
				params: param
			});
		},
		listeners:{
			load:function(store, records, successful, eOpts)	{
				if(successful)	{
//					var masterRecords = p200Store.data.filterBy(p200Store.filterNewOnly);
					var masterRecords = p200Store.data; 
					var ref1Records = new Array();
					if(masterRecords.items.length > 0) {
						Ext.each(records, function(item, i) {
							Ext.each(masterRecords.items, function(record, i)	{
								if( (record.data['COMP_CODE'] == item.data['COMP_CODE']) 
									&& (record.data['DIV_CODE'] == item.data['DIV_CODE'])
									&& (record.data['ITEM_CODE'] == item.data['ITEM_CODE'])
									&& (record.data['LOT_NO'] == item.data['LOT_NO'])
//									&& (record.data['STOCK_Q'] == item.data['STOCK_Q'])
								){
									ref1Records.push(item);
								}
							});
						});
						store.remove(ref1Records);
					}
				}
			}
		}
	});

	var ref1Grid = Unilite.createGrid('ref1Grid', {
		store	: ref1Store,
		layout	: 'fit',
		uniOpt	: {
			expandLastColumn	: false,
			useLiveSearch		: false,
			useContextMenu		: false,
			useMultipleSorting	: false,
			useGroupSummary		: false,
			onLoadSelectFirst	: false,
			useRowNumberer		: true,
			filter: {
				useFilter	: false,
				autoCreate	: false
			},
			state: {
				useState	: false,
				useStateList: false
			}
		},
		selModel :	Ext.create('Ext.selection.CheckboxModel', { checkOnly : false, toggleOnClick:false }),
		columns: [
			{ dataIndex: 'COMP_CODE'	, width: 100 ,hidden:true},
			{ dataIndex: 'DIV_CODE'		, width: 100},
			{ dataIndex: 'ITEM_CODE'	, width: 80 },
			{ dataIndex: 'ITEM_NAME'	, width: 100},
			{ dataIndex: 'SPEC'			, width: 150},
			{ dataIndex: 'WH_CODE'		, width: 88 },
			{ dataIndex: 'LOT_NO'		, width: 110},
			{ dataIndex: 'STOCK_Q'		, width: 100}
		],
		returnData: function()	{
			var records = this.getSelectedRecords();

			Ext.each(records, function(record,i){
				var compCode	= UserInfo.compCode;
				var divCode		= panelSearch.getValue('DIV_CODE');
				var itemCode	= panelSearch.getValue('ITEM_CODE');
				var itemName	= panelSearch.getValue('ITEM_NAME');
				var seq = p200Store.max('SEQ');
				if(!seq){
					seq = 1;
				} else {
					seq += 1;
				}

				var r = {
					COMP_CODE	: compCode,
					DIV_CODE	: divCode,
					ITEM_CODE	: itemCode,
					ITEM_NAME	: itemName,
					SEQ			: seq
				};
				p200Grid.createRow(r);
				p200Grid.setRef1Data(record.data);
			}); 
			this.getStore().remove(records);
		}
	});

	function openSearchRef1Window() {
		if (!SearchRef1Window) {
			SearchRef1Window = Ext.create('widget.uniDetailWindow', {
				title	: '참조:재고',
				width	: 1000,
				height	: 580,
				layout	: {
					type	: 'vbox',
					align	: 'stretch'
				},
				items	: [ref1Search, ref1Grid],
				tbar	: ['->',{
					itemId	: 'searchBtn',
					text	: '조회',
					minWidth: 100,
					handler	: function() {
						if(!ref1Search.getInvalidMessage()) return;	//필수체크
						ref1Store.loadStoreRecords();
					},
					disabled: false
				},{	
					itemId	: 'confirmBtn',
					text	: '적용',
					minWidth:100,
					handler	: function() {
						ref1Grid.returnData();
					},
					disabled: false
				},{	
					itemId	: 'confirmCloseBtn',
					text	: '적용 후 닫기',
					minWidth: 100,
					handler	: function() {
						ref1Grid.returnData();
						SearchRef1Window.hide();
					},
					disabled: false
				},{
					itemId	: 'closeBtn',
					text	: '닫기',
					minWidth: 100,
					handler	: function() {
						SearchRef1Window.hide();
					},
					disabled: false
				}],
				listeners: {
					beforehide: function(me, eOpt) {
						ref1Search.clearForm();
						ref1Grid.reset();
						ref1Store.clearData();
					},
					beforeclose: function(panel, eOpts) {
					},
					show: function(panel, eOpts) {
						ref1Search.setValue('DIV_CODE'	, panelSearch.getValue('DIV_CODE'));
						ref1Search.setValue('ITEM_CODE'	, panelSearch.getValue('ITEM_CODE'));
						ref1Search.setValue('ITEM_NAME'	, panelSearch.getValue('ITEM_NAME'));
					}
				}
			})
		}
		SearchRef1Window.center();
		SearchRef1Window.show();
	}



	//절단 소요량 정보 - 참조:소요량
	var ref2Search = Unilite.createSearchForm('ref2SearchForm', {
		layout: {
			type	: 'uniTable',
			columns	: 3
		},
		trackResetOnLoad: true,
		items: [{
			fieldLabel	: '사업장',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			width		: 250,
			allowBlank	: false,
			readOnly	: true
		}, 
		Unilite.popup('DIV_PUMOK', {
			fieldLabel		: '원단품목',
			valueFieldName	: 'ITEM_CODE',
			textFieldName	: 'ITEM_NAME',
			width			: 325,
			allowBlank		: false,
			readOnly		: true
		}),{
			fieldLabel		: '일자',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'BASIS_DATE_FR',
			endFieldName	: 'BASIS_DATE_TO',
			startDate		: UniDate.get('today'),
			endDate			: UniDate.get('sixDayLater')
		}]
	});
	
	Unilite.defineModel('ref2Model', {
		fields: [
			{ name: 'COMP_CODE'			,text:'COMP_CODE'	,type: 'string' },
			{ name: 'DIV_CODE'			,text:'사업장'			,type: 'string' ,comboType:'BOR120'},
			{ name: 'PROD_ITEM_CODE'	,text:'원단품목코드'		,type: 'string' },
			{ name: 'ITEM_CODE'			,text:'절단품목코드'		,type: 'string' },
			{ name: 'ITEM_NAME'			,text:'절단품목명'		,type: 'string' },
			{ name: 'SPEC'				,text:'규격'			,type: 'string' },
			{ name: 'PROD_Q'			,text:'소요량'			,type: 'int' },
			{ name: 'MRP_CONTROL_NUM'	,text:'MRP번호'		,type: 'string' }
		]
	});
	
	var ref2Store = Unilite.createStore('ref2Store', {
		model: 'ref2Model',
		autoLoad: false,
		uniOpt: {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		proxy: {
			type: 'direct',
			api	: {
				read: 'pip100ukrvService.ref2SelectList'
			}
		},
		loadStoreRecords: function() {
			var param = ref2Search.getValues();
			this.load({
				params: param
			});
		},
		listeners:{
			load:function(store, records, successful, eOpts)	{
				if(successful)	{
//					var masterRecords = p100Store.data.filterBy(p100Store.filterNewOnly);
					var masterRecords = p100Store.data; 
					var ref2Records = new Array();
					if(masterRecords.items.length > 0) {
						Ext.each(records, function(item, i) {
							Ext.each(masterRecords.items, function(record, i)	{
								if( (record.data['COMP_CODE'] == item.data['COMP_CODE']) 
									&& (record.data['DIV_CODE'] == item.data['DIV_CODE'])
									&& (record.data['ITEM_CODE'] == item.data['PROD_ITEM_CODE'])
									&& (record.data['CUT_ITEM_CODE'] == item.data['ITEM_CODE'])
									&& (record.data['MRP_CONTROL_NUM'] == item.data['MRP_CONTROL_NUM'])
//									&& (record.data['ORDER_Q'] == item.data['PROD_Q'])
								){
									ref2Records.push(item);
								}
							});
						});
						store.remove(ref2Records);
					}
				}
			}
		}
	});
 
	var ref2Grid = Unilite.createGrid('ref2Grid', {
		store	: ref2Store,
		layout	: 'fit',
		uniOpt	: {
			expandLastColumn	: false,
			useLiveSearch		: false,
			useContextMenu		: false,
			useMultipleSorting	: false,
			useGroupSummary		: false,
			onLoadSelectFirst	: false,
			useRowNumberer		: true,
			filter: {
				useFilter	: false,
				autoCreate	: false
			},
			state: {
				useState	: false,
				useStateList: false
			}
		},
		selModel :	Ext.create('Ext.selection.CheckboxModel', { checkOnly : false, toggleOnClick:false }),
		columns: [
			{ dataIndex: 'COMP_CODE'		, width: 100 ,hidden:true},
			{ dataIndex: 'DIV_CODE'			, width: 100 },
			{ dataIndex: 'PROD_ITEM_CODE'	, width: 200 ,hidden:true},
			{ dataIndex: 'ITEM_CODE'		, width: 100 },
			{ dataIndex: 'ITEM_NAME'		, width: 150 },
			{ dataIndex: 'SPEC'				, width: 150 },
			{ dataIndex: 'PROD_Q'			, width: 150 },
			{ dataIndex: 'MRP_CONTROL_NUM'	, width: 150 }
		],
		returnData: function() {
			var records = this.getSelectedRecords();
				
			Ext.each(records, function(record,i){
				var compCode	= UserInfo.compCode;
				var divCode		= panelSearch.getValue('DIV_CODE');
				var itemCode	= panelSearch.getValue('ITEM_CODE');
				
				var r = {
					COMP_CODE	: compCode,
					DIV_CODE	: divCode,
					ITEM_CODE	: itemCode
				};
				p100Grid.createRow(r);
				p100Grid.setRef2Data(record.data);
			}); 
			this.getStore().remove(records);
		}
	});

	function openSearchRef2Window() {
		if (!SearchRef2Window) {
			SearchRef2Window = Ext.create('widget.uniDetailWindow', {
				title	: '참조:소요량',
				width	: 1000,
				height	: 580,
				layout	: {
					type	: 'vbox',
					align	: 'stretch'
				},
				items	: [ref2Search, ref2Grid],
				tbar	: ['->',{
					itemId	: 'searchBtn',
					text	: '조회',
					minWidth: 100,
					handler	: function() {
						if(!ref2Search.getInvalidMessage()) return;	//필수체크
						ref2Store.loadStoreRecords();
					},
					disabled: false
				},{
					itemId	: 'confirmBtn',
					text	: '적용',
					minWidth: 100,
					handler	: function() {
						ref2Grid.returnData();
					},
					disabled: false
				},{	
					itemId	: 'confirmCloseBtn',
					text	: '적용 후 닫기',
					minWidth: 100,
					handler	: function() {
						ref2Grid.returnData();
						SearchRef2Window.hide();
					},
					disabled: false
				},{
					itemId	: 'closeBtn',
					text	: '닫기',
					minWidth: 100,
					handler	: function() {
						SearchRef2Window.hide();
					},
					disabled: false
				}],
				listeners: {
					beforehide: function(me, eOpt) {
						ref2Search.clearForm();
						ref2Grid.reset();
						ref2Store.clearData();
					},
					beforeclose: function(panel, eOpts) {
					},
					show: function(panel, eOpts) {
						ref2Search.setValue('DIV_CODE'		, panelSearch.getValue('DIV_CODE'));
						ref2Search.setValue('ITEM_CODE'		, panelSearch.getValue('ITEM_CODE'));
						ref2Search.setValue('ITEM_NAME'		, panelSearch.getValue('ITEM_NAME'));
						ref2Search.setValue('BASIS_DATE_FR'	, UniDate.get('today'));
						ref2Search.setValue('BASIS_DATE_TO'	, UniDate.get('sixDayLater'));
					}
				}
			})
		}
		SearchRef2Window.center();
		SearchRef2Window.show();
	}



	Unilite.Main({
		id			: 'pip100ukrvApp',
		border		: false,
		borderItems	: [{
			id		: 'pageAll',
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				panelSearch,
				{	layout	: {type: 'hbox', align: 'stretch'},
					region	: 'north',
					flex	: 1,
					split	: true,
					border	: false,
					items	: [
						p200Grid, p100Grid
					]
				},
				detailGrid
			]
		}],
		fnInitBinding: function() {
			panelSearch.setValue("DIV_CODE", UserInfo.divCode);
			panelSearch.setValue("EXEC_CNT", BsaCodeInfo.gsBasisNum);
	
			UniAppManager.setToolbarButtons(['reset'], true);
			UniAppManager.setToolbarButtons(['print','newData','save'], false);
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			p200Grid.reset();
			p200Store.clearData();
			p100Grid.reset();
			p100Store.clearData();
			Ext.getCmp('CUT').setValue(0);
			panelSearch.setValue("EXEC_CNT", BsaCodeInfo.gsBasisNum);
			lossRateCalc = 0;
			detailGrid.reset();
			detailStore.clearData();
			
			this.fnInitInputFields();
		},
		onQueryButtonDown: function() {
			if(Ext.isEmpty(panelSearch.getValue('DIV_CODE'))){
				alert('<t:message code="system.label.product.division" default="사업장"/>'+'<t:message code="system.message.product.message060" default="은(는) 필수입력 항목입니다."/>');	
				return; 
			}
		
			if(Ext.isEmpty(panelSearch.getValue('ITEM_CODE'))) {
				openSearchInfoWindow();
			} else {
				p200Store.loadStoreRecords();
				p100Store.loadStoreRecords();
				detailStore.loadStoreRecords();
//				p200Store.commitChanges();
//				p100Store.commitChanges();
//				detailStore.commitChanges();
			};
		},
		fnInitInputFields: function(){
			panelSearch.setValue("DIV_CODE", UserInfo.divCode);
			
			panelSearch.getField('DIV_CODE').setReadOnly(false);
			panelSearch.getField('ITEM_CODE').setReadOnly(false);
			panelSearch.getField('ITEM_NAME').setReadOnly(false);
			
			UniAppManager.setToolbarButtons(['reset'], true);
			UniAppManager.setToolbarButtons(['print','newData','save'], false);
		}
	});



	Unilite.createValidator('validator', {
		store	: p200Store,
		grid	: p200Grid,
		validate: function( type, fieldName, newValue, oldValue, record, detailGrid, editor, e) {
			if(newValue == oldValue){
				return false;
			}
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			
			switch(fieldName) {
				case "STOCK_Q" :
					if(newValue <= 0) {
						rv= '<t:message code="system.message.sales.message034" default="양수만 입력가능합니다."/>';
						record.set('STOCK_Q', oldValue);
						break;
					}
					record.set('STOCK_LENGTH', Unilite.multiply(newValue, record.get('TRNS_RATE')));
				break;
				
				case "CUT" :
					var itemWidth = record.get('ITEM_WIDTH');
					if(itemWidth < newValue) {
						rv = '가용 폭이 0보다 작을 수 없습니다.';
						break;
					}
					record.set('REQ_LEN', itemWidth - newValue);
				break;
			}
		return rv;
		}
	});



	//작업지시 버튼 관련 Store
	var wkordStore = Unilite.createStore('pip101ukrvWkordStore',{
		uniOpt: {
			isMaster	: false,		// 상위 버튼 연결
			editable	: false,		// 수정 모드 사용
			deletable	: false,		// 삭제 가능 여부
			useNavi		: false			// prev | newxt 버튼 사용
		},
		proxy		: wkordProxy,
		saveStore	: function() {
			var inValidRecs = this.getInvalidRecords();
			var toCreate	= this.getNewRecords();
			
			var paramMaster	= panelSearch.getValues();
			var isErr = false;

			if(isErr) return false;

			if(inValidRecs.length == 0) {
				config = {
					params	: [paramMaster],
					success : function(batch, option) {
						//return 값 저장
						var master = batch.operations[0].getResultSet();
						detailStore.loadStoreRecords();
						wkordStore.clearData();
					 },

					 failure: function(batch, option) {
//						detailStore.loadStoreRecords();
						wkordStore.clearData();
					 }
				};
				this.syncAllDirect(config);
				
			} else {
				var grid = Ext.getCmp('detailGrid');
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
};
</script>