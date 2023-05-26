<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="mpo080ukrv">
	<t:ExtComboStore comboType="BOR120" pgmId="mpo080ukrv"/>	<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B020"/>			<!-- 품목계정 -->
	<t:ExtComboStore comboType="AU" comboCode="B014"/>			<!-- 조달구분 -->
</t:appConfig>
<style type="text/css">
	.x-change-cell {
	background-color: #FFFFC6;
	}
	.x-change-cell2 {
	background-color: #FDE3FF;
	}
</style>

<script type="text/javascript" >

var referProductionPlanWindow;		//생산계획참조팝업
var gsInit = true;					//20200716 초기화 시 조회로직 안 타도록 수정

function appMain() {
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'mpo080ukrvService.selectMasterList',
			create	: 'mpo080ukrvService.insertMaster',
			update	: 'mpo080ukrvService.updateMaster',
			destroy	: 'mpo080ukrvService.deleteMaster',
			syncAll	: 'mpo080ukrvService.saveMaster'
		}
	});

	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'mpo080ukrvService.selectDetailList',
			update	: 'mpo080ukrvService.updateDetail',
			syncAll	: 'mpo080ukrvService.saveDetail'
		}
	});

	var directProxy2_2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'mpo080ukrvService.selectDetailList2'
//			create: 'mpo080ukrvService.insertMaster',
//			update: 'mpo080ukrvService.updateMaster',
//			destroy: 'mpo080ukrvService.deleteMaster',
//			syncAll: 'mpo080ukrvService.saveMaster'
		}
	});

	var directProxy2_3 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'mpo080ukrvService.selectDetailList3'
		}
	});

	/* 생산계획 참조 */
	var directProxy3 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'mpo080ukrvService.selectProdList'
		}
	});

	var directButtonProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			create	: 'mpo080ukrvService.buttonInsert',
			syncAll	: 'mpo080ukrvService.buttonSave'
		}
	});

/*	var directButtonProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			create: 'mpo080ukrvService.buttonInsert2',
			syncAll: 'mpo080ukrvService.buttonSave2'
		}
	});	*/


	/** Model 정의
	 * @type
	 */
	Unilite.defineModel('mpo080ukrvModel', {
		fields: [
			{name: 'COMP_CODE'			,text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'	,type: 'string'},
			{name: 'DIV_CODE'			,text: '<t:message code="system.label.purchase.division" default="사업장"/>'		,type: 'string'},
			{name: 'WK_PLAN_NUM'		,text: '생산계획번호'			,type: 'string'},
			{name: 'PROD_ITEM_CODE'		,text: '<t:message code="system.label.purchase.item" default="품목"/>'			,type: 'string',allowBlank:false},
			{name: 'ITEM_NAME'			,text: '<t:message code="system.label.purchase.itemname2" default="품명"/>'		,type: 'string'},
			{name: 'SPEC'				,text: '<t:message code="system.label.purchase.spec" default="규격"/>'			,type: 'string'},
			{name: 'STOCK_UNIT'			,text: '단위'				,type: 'string'},
			{name: 'ITEM_ACCOUNT'		,text: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>'	,type: 'string', comboType:'AU', comboCode:'B020'},
			{name: 'PRODT_PLAN_DATE'	,text: '계획일자'			,type: 'uniDate'},
			{name: 'WEEK_NUM'			,text: '계획주차'			,type: 'string'},
			{name: 'WK_PLAN_Q'			,text: '계획수량'			,type: 'uniQty'},
			{name: 'ORDER_NUM'			,text: '<t:message code="system.label.purchase.sono" default="수주번호"/>'			,type: 'string'},
			{name: 'SER_NO'				,text: '<t:message code="system.label.purchase.seq" default="순번"/>'				,type: 'int'},
			{name: 'MRP_CONTROL_NUM'	,text: 'MRP번호'			,type: 'string'},
			{name: 'ORDER_YN'			,text: '발주확정'			,type: 'string'}
		]
	});

	Unilite.defineModel('mpo080ukrvModel2', {
		fields: [
			{name: 'COMP_CODE'			,text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'				,type: 'string'},
			{name: 'DIV_CODE'			,text: '<t:message code="system.label.purchase.division" default="사업장"/>'					,type: 'string'},
			{name: 'PROD_ITEM_CODE'		,text: '<t:message code="system.label.purchase.parentitemcode" default="모품목코드"/>'			,type: 'string'},
			{name: 'CHILD_ITEM_CODE'	,text: '<t:message code="system.label.purchase.item" default="품목"/>'						,type: 'string'},
			{name: 'ITEM_NAME'			,text: '<t:message code="system.label.purchase.itemname2" default="품명"/>'					,type: 'string'},
			{name: 'SPEC'				,text: '<t:message code="system.label.purchase.spec" default="규격"/>'						,type: 'string'},
			{name: 'STOCK_UNIT'			,text: '<t:message code="system.label.purchase.unit" default="단위"/>'						,type: 'string'},
			{name: 'ITEM_ACCOUNT'		,text: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>'				,type: 'string', comboType:'AU', comboCode:'B020'},
			{name: 'SUPPLY_TYPE'		,text: '<t:message code="system.label.purchase.procurementclassification" default="조달구분"/>'	,type: 'string', comboType:'AU', comboCode:'B014'},
			{name: 'CHILD_PRICE'		,text: '<t:message code="system.label.purchase.price" default="단가"/>'						,type: 'uniUnitPrice'},
			{name: 'CHILD_AMOUNT'		,text: '<t:message code="system.label.purchase.amount" default="금액"/>'						,type: 'uniPrice'},
			{name: 'PL_QTY'				,text: '<t:message code="system.label.purchase.totalrequiredqty" default="총소요량"/>'			,type: 'uniQty'}, //소요량 최초계산량
			{name: 'CSTOCK'				,text: '<t:message code="system.label.purchase.onhandstock" default="현재고"/>'				,type: 'uniQty'},
			{name: 'RECEIPT_PLAN_Q'		,text: '<t:message code="system.label.purchase.receiptplannedqty" default="입고예정량"/>'		,type: 'uniQty'},
			{name: 'ISSUE_PLAN_Q'		,text: '<t:message code="system.label.purchase.issueresevationqty" default="출고예정량"/>'		,type: 'uniQty'},
			{name: 'SAFE_STOCK_Q'		,text: '<t:message code="system.label.purchase.safetystock" default="안전재고"/>'				,type: 'uniQty'},
			{name: 'CALC_NET_QTY'		,text: '<t:message code="system.label.purchase.netreq" default="순소요량"/>'					,type: 'uniQty'}, //현재고, 안전재고 반영값
			{name: 'MINI_PURCH_Q'		,text: '<t:message code="system.label.purchase.minimumlot" default="최소LOT"/>'				,type: 'uniQty'},
			{name: 'MAX_PURCH_Q'		,text: '<t:message code="system.label.purchase.maximumlot" default="최대LOT"/>'				,type: 'uniQty'},
			{name: 'ORDER_UNIT'			,text: '<t:message code="system.label.purchase.purchaseunit" default="구매단위"/>'				,type: 'string'},
			{name: 'CALC_PLAN_QTY'		,text: '<t:message code="system.label.purchase.purchaseplanq" default="구매계획량"/>'			,type: 'float', decimalPrecision: 2, format:'0,000.00'},
			{name: 'ORDER_REQ_Q'		,text: '<t:message code="system.label.purchase.purchaserequestq" default="구매요청량"/>'			,type: 'float', decimalPrecision: 2, format:'0,000.00'}, //발주요청량
			{name: 'ORDER_Q'			,text: '<t:message code="system.label.purchase.poqty" default="발주량"/>'						,type: 'uniQty'},
			{name: 'CUSTOM_CODE'		,text: '<t:message code="system.label.purchase.custom" default="거래처"/>'						,type: 'string'},
			{name: 'CUSTOM_NAME'		,text: '<t:message code="system.label.purchase.customname" default="거래처명"/>'				,type: 'string'},
			{name: 'PO_NUM'				,text: '<t:message code="system.label.purchase.pono" default="발주번호"/>'						,type: 'string'},
			{name: 'PO_SEQ'				,text: '<t:message code="system.label.purchase.poseq" default="발주순번"/>'						,type: 'int'},
			{name: 'PO_DATE'			,text: '<t:message code="system.label.purchase.podate" default="발주일"/>'						,type: 'uniDate'},
			{name: 'DVRY_DATE'			,text: '<t:message code="system.label.purchase.deliverydate" default="납기일"/>'				,type: 'uniDate'}
		]
	});

	Unilite.defineModel('mpo080ukrvModel2_2', {
		fields: [
			{name: 'CHILD_ITEM_CODE'	,text: '<t:message code="system.label.purchase.item" default="품목"/>'						,type: 'string'},
			{name: 'ITEM_NAME'			,text: '<t:message code="system.label.purchase.itemname2" default="품명"/>'					,type: 'string'},
			{name: 'SPEC'				,text: '<t:message code="system.label.purchase.spec" default="규격"/>'						,type: 'string'},
			{name: 'STOCK_UNIT'			,text: '<t:message code="system.label.purchase.unit" default="단위"/>'						,type: 'string'},
			{name: 'ITEM_ACCOUNT'		,text: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>'				,type: 'string', comboType:'AU', comboCode:'B020'},
			{name: 'SUPPLY_TYPE'		,text: '<t:message code="system.label.purchase.procurementclassification" default="조달구분"/>'	,type: 'string', comboType:'AU', comboCode:'B014'},
			{name: 'ORDER_UNIT'			,text: '<t:message code="system.label.purchase.purchaseunit" default="구매단위"/>'				,type: 'string'},
			{name: 'CHILD_PRICE'		,text: '<t:message code="system.label.purchase.price" default="단가"/>'						,type: 'uniUnitPrice'},
			{name: 'CHILD_AMOUNT'		,text: '<t:message code="system.label.purchase.amount" default="금액"/>'						,type: 'uniPrice'},
			{name: 'PL_QTY'				,text: '<t:message code="system.label.purchase.requiredqty" default="소요량"/>'				,type: 'uniQty'},
			{name: 'UNIT_Q'				,text: '<t:message code="system.label.purchase.originunitqty" default="원단위량"/>'				, defaultValue:1,type: 'float', decimalPrecision: 6, format:'0,000.000000'},
			{name: 'LOSS_RATE'			,text: '<t:message code="system.label.purchase.lossrate" default="LOSS율"/>'					, defaultValue:1,type: 'float', decimalPrecision: 6, format:'0,000.000000'}
		]
	});

	Unilite.defineModel('mpo080ukrvModel2_3', {
		fields: [
			{name: 'CHILD_ITEM_CODE'	,text: '<t:message code="system.label.purchase.item" default="품목"/>'						,type: 'string'},
			{name: 'ITEM_NAME'			,text: '<t:message code="system.label.purchase.itemname2" default="품명"/>'					,type: 'string'},
			{name: 'SPEC'				,text: '<t:message code="system.label.purchase.spec" default="규격"/>'						,type: 'string'},
			{name: 'STOCK_UNIT'			,text: '<t:message code="system.label.purchase.unit" default="단위"/>'						,type: 'string'},
			{name: 'ITEM_ACCOUNT'		,text: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>'				,type: 'string', comboType:'AU', comboCode:'B020'},
			{name: 'SUPPLY_TYPE'		,text: '<t:message code="system.label.purchase.procurementclassification" default="조달구분"/>'	,type: 'string', comboType:'AU', comboCode:'B014'},
			{name: 'ORDER_UNIT'			,text: '<t:message code="system.label.purchase.purchaseunit" default="구매단위"/>'				,type: 'string'},
			{name: 'CHILD_PRICE'		,text: '<t:message code="system.label.purchase.price" default="단가"/>'						,type: 'uniUnitPrice'},
			{name: 'CHILD_AMOUNT'		,text: '<t:message code="system.label.purchase.amount" default="금액"/>'						,type: 'uniPrice'},
			{name: 'PL_QTY'				,text: '<t:message code="system.label.purchase.requiredqty" default="소요량"/>'				,type: 'uniQty'},
			{name: 'UNIT_Q'				,text: '<t:message code="system.label.purchase.originunitqty" default="원단위량"/>'				, defaultValue:1,type: 'float', decimalPrecision: 6, format:'0,000.000000'},
			{name: 'LOSS_RATE'			,text: '<t:message code="system.label.purchase.lossrate" default="LOSS율"/>'					, defaultValue:1,type: 'float', decimalPrecision: 6, format:'0,000.000000'}
		]
	});


	var buttonStore = Unilite.createStore('mpo080ukrvButtonStore',{
		proxy	: directButtonProxy,
		uniOpt	: {
			isMaster	: false,			// 상위 버튼 연결
			editable	: false,			// 수정 모드 사용
			deletable	: false,			// 삭제 가능 여부
			useNavi		: false			// prev | newxt 버튼 사용
		},
		saveStore: function() {
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();

			//폼에서 필요한 조건 가져올 경우
			var paramMaster			= panelResult.getValues();
//			paramMaster.DIV_CODE	= addResult.getValue('DIV_CODE');
//			paramMaster.OPR_FLAG	= buttonFlag;
//			paramMaster.LANG_TYPE	= UserInfo.userLang

			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						//return 값 저장
						var master = batch.operations[0].getResultSet();
						panelResult.setValue("MRP_CONTROL_NUM", master.RtnMrpNum);
						UniAppManager.app.onQueryButtonDown();
						buttonStore.clearData();
					},
					failure: function(batch, option) {
						buttonStore.clearData();
					}
				};
				this.syncAllDirect(config);
			} else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
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

/*
	var buttonStore2 = Unilite.createStore('mpo080ukrvButtonStore2',{
		uniOpt: {
			isMaster	: false,			// 상위 버튼 연결
			editable	: false,			// 수정 모드 사용
			deletable	: false,			// 삭제 가능 여부
			useNavi		: false			// prev | newxt 버튼 사용
		},
		proxy: directButtonProxy2,
		saveStore: function() {
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
			var paramMaster			= panelResult.getValues();
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						//return 값 저장
						var master = batch.operations[0].getResultSet();

						UniAppManager.app.onQueryButtonDown();
						buttonStore.clearData();
					},
					failure: function(batch, option) {
						buttonStore.clearData();
					}
				};
				this.syncAllDirect(config);
			} else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
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
	});*/

	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore = Unilite.createStore('mpo080ukrvMasterStore',{
		model	: 'mpo080ukrvModel',
		proxy	: directProxy,
		uniOpt	: {
			isMaster	: false,		// 상위 버튼 연결
			editable	: true,			// 수정 모드 사용
			deletable	: true,			// 삭제 가능 여부
			useNavi		: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		saveStore: function() {
			var inValidRecs = this.getInvalidRecords();
			var paramMaster= panelResult.getValues();	//syncAll 수정

			config = {
				params: [paramMaster],
				success: function(batch, option) {
					UniAppManager.setToolbarButtons('save', false);
					UniAppManager.app.onQueryButtonDown();
				}
			};
			this.syncAllDirect(config);
		},
		loadStoreRecords: function(newValue) {
			var param= panelResult.getValues();
			//20200717 추가: 조회조건 확정여부 추가와 관련하여 로직 추가
			if(newValue) {
				param.CONFIRM_YN = newValue;
			}
			console.log( param );
			this.load({
				params: param
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				panelResult.getField('DIV_CODE').setReadOnly(true);
			},
			add: function(store, records, index, eOpts) {
				UniAppManager.setToolbarButtons('delete', true);
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
			},
			remove: function(store, record, index, isMove, eOpts) {
			}
		}
	});

	/** Store 정의(Service 정의)
	 * @type
	 */
	var directDetailStore = Unilite.createStore('mpo080ukrvDetailStore',{
		model	: 'mpo080ukrvModel2',
		proxy	: directProxy2,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결
			editable	: true,		// 수정 모드 사용
			deletable	: true,		// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		autoLoad: false,
		loadStoreRecords: function(record) {
			var param				= panelResult2.getValues();
			param.DIV_CODE			= record.data.DIV_CODE;
			param.MRP_CONTROL_NUM	= record.data.MRP_CONTROL_NUM;

			this.load({
				params: param
			});
		},
		saveStore: function() {
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			var toCreate = this.getNewRecords();
			var toUpdate = this.getUpdatedRecords();
			var toDelete = this.getRemovedRecords();
			var list = [].concat(toUpdate, toCreate);
			console.log("list:", list);

			var paramMaster= panelResult.getValues();	//syncAll 수정
			//paramMaster.put("PROD_ITEM_CODE", )
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						var master = batch.operations[0].getResultSet();
						UniAppManager.setToolbarButtons('save', false);
					 }
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('mpo080ukrvGrid');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				if(store.sum('CALC_PLAN_QTY').toFixed(3) != 0 && store.sum('ORDER_REQ_Q').toFixed(3) == 0){
					Ext.each(records, function(record, index){
						record.set('ORDER_REQ_Q',record.get('CALC_PLAN_QTY'));
					})
					setTimeout( function() {
						UniAppManager.setToolbarButtons('save', true);
					}, 50 );
				}
			}
		}
	});

	var detailStore2 = Unilite.createStore('detailStore2',{
		model	: 'mpo080ukrvModel2_2',
		proxy	: directProxy2_2,
		uniOpt	: {
			isMaster	: false,			// 상위 버튼 연결
			editable	: false,			// 수정 모드 사용
			deletable	: false,			// 삭제 가능 여부
			useNavi		: false				// prev | newxt 버튼 사용
		},
		autoLoad: false,
		loadStoreRecords: function(record) {
			var param= record.data;
			this.load({
				params: param
			});
		}
	});

	var detailStore3 = Unilite.createStore('detailStore3',{
		model	: 'mpo080ukrvModel2_3',
		proxy	: directProxy2_3,
		uniOpt	: {
			isMaster	: false,			// 상위 버튼 연결
			editable	: false,			// 수정 모드 사용
			deletable	: false,			// 삭제 가능 여부
			useNavi		: false				// prev | newxt 버튼 사용
		},
		autoLoad: false,
		loadStoreRecords: function(param) {
			this.load({
				params: param
			});
		}
	});


	/** 검색조건 (Search Panel)
	 * @type
	 */
	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		layout	: {type : 'uniTable', columns : 3},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel	: '<t:message code="system.label.purchase.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false,
			holdable	: 'hold',
//			readOnly	: true,
			value		: UserInfo.divCode
		},{
			xtype		: 'container',
			layout		: {type:'hbox', align:'stretch'},
			width		: 530,
			items		: [{
				fieldLabel	: '계획주차',
				name		: 'OPTION_DATE_FR',
				xtype		: 'uniDatefield',
				allowBlank	: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
					},
					blur : function (field, event, eOpts) {
						if(Ext.isEmpty(field.value)){
							panelResult.setValue('WEEK_NUM_FR','');
						}else{
							var param = {
								'OPTION_DATE'	: UniDate.getDbDateStr(field.value),
								'CAL_TYPE'		: '3' //주단위
							}
							prodtCommonService.getCalNo(param, function(provider, response) {
								if(!Ext.isEmpty(provider.CAL_NO)){
									panelResult.setValue('WEEK_NUM_FR',provider.CAL_NO);
								}else{
									panelResult.setValue('WEEK_NUM_FR','');
								}
							})
						}
					}
				}
			},{
				fieldLabel	: '계획주차FR',
				xtype		: 'uniTextfield',
				name		: 'WEEK_NUM_FR',
				width		: 60,
				hideLabel	: true,
				allowBlank	: false
			},{
				xtype	: 'component',
				html	: '~',
				style	: {
					marginTop	: '3px !important',
					font		: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
				}
			},{
				fieldLabel	: '계획주차',
				hideLabel	: true,
				name		: 'OPTION_DATE_TO',
				xtype		: 'uniDatefield',
				allowBlank	: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
					},
					blur : function (field, event, eOpts) {
						if(Ext.isEmpty(field.value)){
							panelResult.setValue('WEEK_NUM_TO','');
						}else{
							var param = {
								'OPTION_DATE' : UniDate.getDbDateStr(field.value),
								'CAL_TYPE' : '3' //주단위
							}
							prodtCommonService.getCalNo(param, function(provider, response) {
								if(!Ext.isEmpty(provider.CAL_NO)){
									panelResult.setValue('WEEK_NUM_TO',provider.CAL_NO);
								}else{
									panelResult.setValue('WEEK_NUM_TO','');
								}
							})
						}
					}
				}
			},{
				fieldLabel	: '계획주차TO',
				xtype		: 'uniTextfield',
				name		: 'WEEK_NUM_TO',
				width		: 60,
				hideLabel	: true,
				allowBlank	: false
			}]
		},{	//20200716 추가: 확정여부 조회조건 추가
			xtype		: 'radiogroup',
			fieldLabel	: '<t:message code="system.label.purchase.confirmedpending" default="확정여부"/>',
			items		: [{
				boxLabel	: '<t:message code="system.label.sales.whole" default="전체"/>',
				name		: 'CONFIRM_YN',
				inputValue	: '', 
				width		: 60,
				checked		: true
			},{
				boxLabel	: '<t:message code="system.label.purchase.confirmation" default="확정"/>',
				width		: 60,
				name		: 'CONFIRM_YN',
				inputValue	: 'Y'
			},{
				boxLabel	: '<t:message code="system.label.purchase.noconfirm" default="미확정"/>',
				width		: 70,
				name		: 'CONFIRM_YN',
				inputValue	: 'N'
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					if(!gsInit) {
						directMasterStore.loadStoreRecords(newValue.CONFIRM_YN);
					}
				}
			}
		},{
			name		: 'ITEM_ACCOUNT',
			fieldLabel	: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B020'
		},{
			fieldLabel	: 'MRP번호',
			xtype		: 'uniTextfield',
			name		: 'MRP_CONTROL_NUM'
		},{
			xtype	: 'container',
			layout	: {type : 'table', columns : 2},
			tdAttrs	: {align: 'right'},
			width	: 150,
			items	: [{
				xtype	: 'button',
				text	: '<div style="color: red">소요량계산</div>',
				width	: 100,
				handler	: function(){
					if(!panelResult.getInvalidMessage()) return;	//필수체크

					var records = masterGrid.getSelectedRecords();
					if(Ext.isEmpty(records)){
						Unilite.messageBox("소요량계산할 데이터를 선택해주십시오.");
						return;
					}
					fnMakeLogStore();
				}
			}/*,{
				xtype	: 'button',
				text	: '발주확정',
				width	: 100,
				id		: 'btn2',
				handler	: function() {
					if(!panelResult.getInvalidMessage()) return;	//필수체크

					var records = directDetailStore.data.items;
					if(Ext.isEmpty(records)){
						Unilite.messageBox("발주확정 할 데이터가 없습니다.");
						return;
					}
					Ext.each(records, function(record, idx){
						if(Ext.isEmpty(record.get('CUSTOM_CODE')) || Ext.isEmpty(record.get('CUSTOM_NAME'))){
							Unilite.messageBox('거래처를 확인하십시오.');
							return false;
						}
					})
					fnMakeLogStore2();
				}
			}*/]
		}]
	});

	var panelResult2 = Unilite.createSearchForm('resultForm2',{
		region	: 'north',
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		layout	: {type : 'uniTable', columns : 4},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			name		: 'ITEM_ACCOUNT',
			fieldLabel	: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B020'
		},{
			fieldLabel	: '옵션',
			xtype		: 'uniCheckboxgroup',
			items		: [{
				boxLabel: '현재고',
				width	: 90,
				name	: 'TYPE1',
				checked	: true
			},{
				boxLabel: '입고예정량',
				width	: 90,
				name	: 'TYPE4'
			},{
				boxLabel: '출고예정량',
				width	: 90,
				name	: 'TYPE5'
			},{
				boxLabel: '안전재고',
				width	: 90,
				name	: 'TYPE2'
			},{
				boxLabel: 'MOQ',
				width	: 90,
				name	: 'TYPE3',
				checked	: true
			}]
		},{
			xtype	: 'container',
			layout	: {type : 'table', columns : 2},
			tdAttrs	: {align: 'right'},
			width	: 150,
			items	: [{
				xtype	: 'button',
				text	: '<div style="color: red">발주확정(SUM)조회</div>',
				width	: 150,
				handler	: function(){
					var record = masterGrid.getSelectedRecord();
					if(Ext.isEmpty(record)){
						Unilite.messageBox('조회 할 데이터가 없습니다.');
						return false;
					}else{
						directDetailStore.loadStoreRecords(record);
					}
				}
			}]
		}]
	});


	/** Master Grid1 정의(Grid Panel)
	 * @type
	 */
	var masterGrid = Unilite.createGrid('mpo080ukrvGrid', {
		store	: directMasterStore,
		region	: 'north' ,
		layout	: 'fit',
		split	: true,
		uniOpt	: {
			onLoadSelectFirst	:false,
			expandLastColumn	: false,
			useRowNumberer	: false
		},
		tbar: [{
			itemId: 'requestBtn',
			text: '<div style="color: blue">생산계획참조</div>',
			handler: function() {
				openProductionPlanWindow();
			}
		}],
		features: [{
			id: 'masterGridSubTotal',
			ftype: 'uniGroupingsummary',
			showSummaryRow: false
		},{
			id: 'masterGridTotal',
			ftype: 'uniSummary',
			showSummaryRow: false
		}],
		selModel: Ext.create('Ext.selection.CheckboxModel', {
			checkOnly		: false,
			toggleOnClick	: false,
			listeners		: {
				select: function(grid, selectRecord, index, rowIndex, eOpts ){
					UniAppManager.setToolbarButtons('delete', true);
				},
				deselect:  function(grid, selectRecord, index, eOpts ){
					if(grid.selected.items.length == 0){
						UniAppManager.setToolbarButtons('delete', false);
					}
				}
			}
		}),
		columns: [
			{dataIndex:'COMP_CODE'			, width: 100,hidden:true},
			{dataIndex:'DIV_CODE'			, width: 100,hidden:true},
			{dataIndex:'MRP_CONTROL_NUM'	, width: 120},
			{dataIndex:'WK_PLAN_NUM'		, width: 120},
			{dataIndex:'PROD_ITEM_CODE'		, width: 100,
				editor: Unilite.popup('DIV_PUMOK_G',{
					autoPopup: true,
					listeners:{
						scope:this,
						onSelected:function(records, type ) {
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('PROD_ITEM_CODE',records[0]['ITEM_CODE']);
							grdRecord.set('ITEM_NAME',records[0]['ITEM_NAME']);
						},
						onClear:function(type) {
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('PROD_ITEM_CODE','');
							grdRecord.set('ITEM_NAME','');
						}
					}
				})
			},
			{dataIndex:'ITEM_NAME'			, width: 200,
				editor: Unilite.popup('DIV_PUMOK_G',{
					autoPopup: true,
					listeners:{
						scope:this,
						onSelected:function(records, type ) {
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('PROD_ITEM_CODE',records[0]['ITEM_CODE']);
							grdRecord.set('ITEM_NAME',records[0]['ITEM_NAME']);
						},
						onClear:function(type) {
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('PROD_ITEM_CODE','');
							grdRecord.set('ITEM_NAME','');
						}
					}
				})
			},
			{dataIndex:'SPEC'				, width: 150},
			{dataIndex:'STOCK_UNIT'			, width: 60,align:'center'},
			{dataIndex:'ITEM_ACCOUNT'		, width: 100,align:'center'},
			{dataIndex:'PRODT_PLAN_DATE'	, width: 100},
			{dataIndex:'WEEK_NUM'			, width: 100},
			{dataIndex:'WK_PLAN_Q'			, width: 100},
			{dataIndex:'ORDER_NUM'			, width: 120},
			{dataIndex:'SER_NO'				, width: 100},
			{dataIndex:'ORDER_YN'			, width: 80,align:'center'}
		],
		setData: function(record) {
			var grdRecord = this.getSelectedRecord();
			grdRecord.set('DIV_CODE'				, record['DIV_CODE']);
			grdRecord.set('PROD_ITEM_CODE'			, record['ITEM_CODE']);
			grdRecord.set('ITEM_NAME'				, record['ITEM_NAME']);
			grdRecord.set('SPEC'					, record['SPEC']);
			grdRecord.set('STOCK_UNIT'				, record['STOCK_UNIT']);
			grdRecord.set('WK_PLAN_Q'				, record['WK_PLAN_Q']);
			grdRecord.set('WK_PLAN_NUM'				, record['WK_PLAN_NUM']);
			grdRecord.set('PRODT_PLAN_DATE'			, record['PRODT_PLAN_DATE']);
			grdRecord.set('WEEK_NUM'				, record['WEEK_NUM']);
			grdRecord.set('MRP_CONTROL_NUM'			, record['MRP_CONTROL_NUM']);
			grdRecord.set('ORDER_YN'				, record['ORDER_YN']);
			grdRecord.set('ORDER_NUM'				, record['ORDER_NUM']);
			grdRecord.set('SER_NO'					, record['SEQ']);
			grdRecord.set('ITEM_ACCOUNT'			, record['ITEM_ACCOUNT']);
			panelResult.setValue('ITEM_ACCOUNT'		, record['ITEM_ACCOUNT']);
		},
		listeners:{
			selectionchange:function(grid, selected, eOpts){
				if(selected.length > 0) {
					var record = selected[0];
					directDetailStore.loadData({});
					if(!record.phantom){
						directDetailStore.loadStoreRecords(record);
						detailStore2.loadStoreRecords(record);
					}
					var prodItemCodeRecords = new Array();
					var wkPlanNumRecords = new Array();
					var mrpControlNumRecords = new Array();
					Ext.each(selected, function(record, idx) {
						prodItemCodeRecords.push(record.get('PROD_ITEM_CODE'));
						wkPlanNumRecords.push(record.get('WK_PLAN_NUM'));
						mrpControlNumRecords.push(record.get('MRP_CONTROL_NUM'));
					});
					var param				= panelResult.getValues();
					param.dataCount			= selected.length;
					param.prodItemCodeList	= prodItemCodeRecords;
					param.wkPlanNumList		= wkPlanNumRecords;
					param.mrpControlNumList	= mrpControlNumRecords;
					detailStore3.loadStoreRecords(param);

					UniAppManager.setToolbarButtons('delete', true);
				}else{
					detailGrid.reset();
					directDetailStore.clearData();
					detailGrid2.reset();
					detailStore2.clearData();
					detailGrid3.reset();
					detailStore3.clearData();

					UniAppManager.setToolbarButtons('save', false);
				}
			},
			beforeedit:function(editor, e, eOpts) {
				if(UniUtils.indexOf(e.field, ['WK_PLAN_Q'])){
					return true;
				}else{
					return false;
				}
			}
		}
	});

	var detailGrid= Unilite.createGrid('mpo080ukrvGrid2', {
		store	: directDetailStore,
		region	: 'center',
		layout	: 'fit',
		uniOpt	: {
			expandLastColumn: false,
			useRowNumberer	: false
		},
		features: [{
			id: 'masterGridSubTotal',
			ftype: 'uniGroupingsummary',
			showSummaryRow: true
		},{
			id: 'masterGridTotal',
			ftype: 'uniSummary',
			showSummaryRow: true
		}],
		tbar:[{
			xtype	: 'button',
			text	: '<div style="color: blue">발주확정(SUM) 출력</div>',
			width	: 150,
			handler	: function(){
				var selectedDetails = detailGrid.getSelectedRecords();
				if(Ext.isEmpty(selectedDetails)){
					Unilite.messageBox('출력할 데이터를 선택하여 주십시오.');
					return;
				}
				var param = Ext.merge(panelResult.getValues(), panelResult2.getValues());
				param.PGM_ID= 'mpo080ukrv_1';
				param.MAIN_CODE= 'M030';
				param["MRP_CONTROL_NUM"] = selectedDetails[0].get('MRP_CONTROL_NUM');
				param["sTxtValue2_fileTitle"]='발주확정(SUM)';

				var win = Ext.create('widget.ClipReport', {
					url		: CPATH+'/matrl/mpo080_1clukrv.do',
					prgID	: 'mpo080ukrv',
					extParam: param
				});
				win.center();
				win.show();
			}
		}],
		columns: [
			{dataIndex: 'COMP_CODE'			, width: 100, hidden:true},
			{dataIndex: 'DIV_CODE'			, width: 100, hidden:true},
			{dataIndex: 'PROD_ITEM_CODE'	, width: 100, hidden:true},
			{dataIndex: 'CHILD_ITEM_CODE'	, width: 100, locked:true},
			{dataIndex: 'ITEM_NAME'			, width: 200, locked:true,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '', '<t:message code="system.label.purchase.totalamount" default="합계"/>');
				}
			},
			{dataIndex: 'SPEC'				, width: 120},
			{dataIndex: 'STOCK_UNIT'		, width: 66	, align:'center'  },
			{dataIndex: 'ITEM_ACCOUNT'		, width: 80	, align:'center' },
			{dataIndex: 'SUPPLY_TYPE'		, width: 80	, align:'center'  },
			{dataIndex: 'CHILD_PRICE'		, width: 100, summaryType:'sum'},
			{dataIndex: 'CHILD_AMOUNT'		, width: 120, summaryType:'sum'},
			{dataIndex: 'PL_QTY'			, width: 100, summaryType:'sum',tdCls:'x-change-cell2'},
			{dataIndex: 'CSTOCK'			, width: 100, summaryType:'sum'},
			{dataIndex: 'RECEIPT_PLAN_Q'	, width: 100, summaryType:'sum'},
			{dataIndex: 'ISSUE_PLAN_Q'		, width: 100, summaryType:'sum'},
			{dataIndex: 'SAFE_STOCK_Q'		, width: 100, summaryType:'sum'},
			{dataIndex: 'CALC_NET_QTY'		, width: 100, summaryType:'sum',tdCls:'x-change-cell2'},
			{dataIndex: 'MINI_PURCH_Q'		, width: 80	, summaryType:'sum'},
			{dataIndex: 'MAX_PURCH_Q'		, width: 80	, summaryType:'sum'},
			{dataIndex: 'ORDER_UNIT'		, width: 70	, align:'center'  },
			{dataIndex: 'CALC_PLAN_QTY'		, width: 100, summaryType:'sum',tdCls:'x-change-cell2'},
			{dataIndex: 'ORDER_REQ_Q'		, width: 100, summaryType:'sum',tdCls:'x-change-cell' },
			{dataIndex: 'ORDER_Q'			, width: 100, summaryType:'sum'},
			{dataIndex: 'CUSTOM_CODE'		, width: 80,
				'editor': Unilite.popup('CUST_G',{
					textFieldName	: 'CUSTOM_CODE',
					DBtextFieldName	: 'CUSTOM_CODE',
					autoPopup		: true,
					listeners		: {
						'onSelected': {
							fn: function(records, type  ){
								var grdRecord = detailGrid.uniOpt.currentRecord;
								grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
								grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
							},
							scope: this
						},
						'onClear' : function(type) {
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('CUSTOM_CODE','');
							grdRecord.set('CUSTOM_NAME','');
						}
					}
				})
			},
			{dataIndex: 'CUSTOM_NAME'		, width: 170,
				'editor': Unilite.popup('CUST_G',{
					autoPopup: true,
					listeners: {
						'onSelected': {
							fn: function(records, type  ){
								var grdRecord = detailGrid.uniOpt.currentRecord;
								grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
								grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
							},
							scope: this
						},
						'onClear' : function(type) {
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('CUSTOM_CODE','');
							grdRecord.set('CUSTOM_NAME','');
						}
					}
				})
			},
			{dataIndex: 'PO_NUM'		, width: 100},
			{dataIndex: 'PO_SEQ'		, width: 100},
			{dataIndex: 'PO_DATE'		, width: 100},
			{dataIndex: 'DVRY_DATE'		, width: 100}
		],
//		selModel:'spreadsheet',
		listeners: {
			beforeedit: function( editor, e, eOpts ) {
				if(UniUtils.indexOf(e.field, ['ORDER_REQ_Q', 'CUSTOM_CODE', 'CUSTOM_NAME'])){
					return true;
				}
				return false;
			}
		}
	});

	var detailGrid2= Unilite.createGrid('detailGrid2', {
		store	: detailStore2,
		selModel: 'rowmodel',
		region	: 'center',
		layout	: 'fit',
		uniOpt	: {
			expandLastColumn: false,
			useRowNumberer	: false
		},
		features: [{
			id: 'masterGridSubTotal',
			ftype: 'uniGroupingsummary',
			showSummaryRow: true
		},{
			id: 'masterGridTotal',
			ftype: 'uniSummary',
			showSummaryRow: true
		}],
		columns: [
			{dataIndex: 'CHILD_ITEM_CODE'	, width: 100},
			{dataIndex: 'ITEM_NAME'			, width: 200,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '', '<t:message code="system.label.purchase.totalamount" default="합계"/>');
				}
			},
			{dataIndex: 'SPEC'				, width: 100},
			{dataIndex: 'STOCK_UNIT'		, width: 80	,align:'center' },
			{dataIndex: 'ITEM_ACCOUNT'		, width: 80	,align:'center' },
			{dataIndex: 'SUPPLY_TYPE'		, width: 80	,align:'center' },
			{dataIndex: 'ORDER_UNIT'		, width: 80	,align:'center' },
			{dataIndex: 'CHILD_PRICE'		, width: 120,summaryType:'sum'},
			{dataIndex: 'CHILD_AMOUNT'		, width: 120,summaryType:'sum'},
			{dataIndex: 'PL_QTY'			, width: 120,summaryType:'sum'},
			{dataIndex: 'UNIT_Q'			, width: 120},
			{dataIndex: 'LOSS_RATE'			, width: 120}
		],
		listeners: {
			beforeedit: function( editor, e, eOpts ) {
			}
		}
	});

	var detailGrid3= Unilite.createGrid('detailGrid3', {
		store	: detailStore3,
		selModel: 'rowmodel',
		region	: 'center',
		layout	: 'fit',
		uniOpt	: {
			expandLastColumn: false,
			useRowNumberer	: false
		},
		features: [{
			id: 'masterGridSubTotal',
			ftype: 'uniGroupingsummary',
			showSummaryRow: true
		},{
			id: 'masterGridTotal',
			ftype: 'uniSummary',
			showSummaryRow: true
		}],
		tbar	: [{
			xtype	: 'button',
			text	: '<div style="color: blue">소요량내역(선택) 출력</div>',
			width	: 150,
			handler	: function(){
				var param = panelResult.getValues();
				var selectedMasters = masterGrid.getSelectedRecords();
				if(Ext.isEmpty(selectedMasters)){
					Unilite.messageBox('출력할 데이터를 선택하여 주십시오.');
					return;
				}
				param.PGM_ID	= 'mpo080ukrv_2';
				param.MAIN_CODE	= 'M030';

				var prodItemCodeList;
				var wkPlanNumList;
				var mrpControlNumList;
				Ext.each(selectedMasters, function(record, idx) {
					if(idx ==0) {
						prodItemCodeList= record.get("PROD_ITEM_CODE");

						if(Ext.isEmpty(record.get("WK_PLAN_NUM"))){
							wkPlanNumList= 'EMPTY';
						}else{
							wkPlanNumList= record.get("WK_PLAN_NUM");
						}
						mrpControlNumList= record.get("MRP_CONTROL_NUM");
					} else {
						prodItemCodeList= prodItemCodeList + ',' + record.get("PROD_ITEM_CODE");

						if(Ext.isEmpty(record.get("WK_PLAN_NUM"))){
							wkPlanNumList= wkPlanNumList + ',' +'EMPTY';
						}else{
							wkPlanNumList= wkPlanNumList + ',' + record.get("WK_PLAN_NUM");
						}
						mrpControlNumList= mrpControlNumList + ',' + record.get("MRP_CONTROL_NUM");
					}
				});
				param["dataCount"]				= selectedMasters.length;
				param["PROD_ITEM_CODE"]			= prodItemCodeList;
				param["WK_PLAN_NUM"]			= wkPlanNumList;
				param["MRP_CONTROL_NUM"]		= mrpControlNumList;
				param["sTxtValue2_fileTitle"]	='소요량내역(선택)';

				var win = Ext.create('widget.ClipReport', {
					url		: CPATH+'/matrl/mpo080_2clukrv.do',
					prgID	: 'mpo080ukrv',
					extParam: param
				});
				win.center();
				win.show();
			}
		}],
		columns: [
			{dataIndex: 'CHILD_ITEM_CODE'	, width: 100},
			{dataIndex: 'ITEM_NAME'			, width: 200,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '', '<t:message code="system.label.purchase.totalamount" default="합계"/>');
				}
			},
			{dataIndex: 'SPEC'				, width: 100 },
			{dataIndex: 'STOCK_UNIT'		, width: 80	,align:'center' },
			{dataIndex: 'ITEM_ACCOUNT'		, width: 80	,align:'center' },
			{dataIndex: 'SUPPLY_TYPE'		, width: 80	,align:'center' },
			{dataIndex: 'ORDER_UNIT'		, width: 80	,align:'center' },
			{dataIndex: 'CHILD_PRICE'		, width: 120,summaryType:'sum'},
			{dataIndex: 'CHILD_AMOUNT'		, width: 120,summaryType:'sum'},
			{dataIndex: 'PL_QTY'			, width: 120,summaryType:'sum'},
			{dataIndex: 'UNIT_Q'			, width: 120},
			{dataIndex: 'LOSS_RATE'			, width: 120}
		],
		listeners: {
			beforeedit: function( editor, e, eOpts ) {
			}
		}
	});



	Unilite.defineModel('mpo080ukrvRefModel', {
		fields: [
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.purchase.division" default="사업장"/>'		, type: 'string'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'		, type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.purchase.itemname2" default="품명"/>'		, type: 'string'},
			{name: 'SPEC'				, text: '<t:message code="system.label.purchase.spec" default="규격"/>'			, type: 'string'},
			{name: 'STOCK_UNIT'			, text: '<t:message code="system.label.purchase.unit" default="단위"/>'			, type: 'string'},
			{name: 'WK_PLAN_Q'			, text: '계획량'		, type: 'uniQty'},
			{name: 'WK_PLAN_NUM'		, text: '생산계획번호'	, type: 'string'},
			{name: 'PRODT_PLAN_DATE'	, text: '계획일자'		, type: 'uniDate'},
			{name: 'WEEK_NUM'			, text: '계획주차'		, type: 'string'},
			{name: 'MRP_CONTROL_NUM'	, text: 'MRP번호'		, type: 'string'},
			{name: 'ORDER_YN'			, text: '발주확정'		, type: 'string'},
			{name: 'CUSTOM_NAME'		, text: '거래처'		, type: 'string'},
			{name: 'ORDER_NUM'			, text: '수주번호'		, type: 'string'},
			{name: 'SEQ'				, text: '수주순번'		, type: 'int'},
			{name: 'ITEM_ACCOUNT'		, text: '품목계정'		, type: 'string'}
		]
	});

	var prodStore = Unilite.createStore('mpo080ukrvProdStore', {
		model	: 'mpo080ukrvRefModel',
		proxy	: directProxy3,
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,		// 상위 버튼 연결
			editable	: false,		// 수정 모드 사용
			deletable	: false,		// 삭제 가능 여부
			useNavi		: false			// prev | newxt 버튼 사용
		},
		loadStoreRecords : function() {
			var param= prodSearch.getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		listeners:{
			load:function(store, records, successful, eOpts) {
				if(successful) {
//					var masterRecords = directMasterStore.data.filterBy(directMasterStore.filterNewOnly);
					var masterRecords = directMasterStore.data;
					var prodRecords = new Array();
					if(masterRecords.items.length > 0) {
						Ext.each(records, function(item, i) {
							Ext.each(masterRecords.items, function(record, i) {
								if( (record.data['DIV_CODE'] == item.data['DIV_CODE'])
									&& (record.data['WK_PLAN_NUM'] == item.data['WK_PLAN_NUM'] )){
									prodRecords.push(item);
								}
							});
						});
						store.remove(prodRecords);
					}
				}
			}
		}
	});

	var prodSearch = Unilite.createSearchForm('prodForm', {
		layout	: {type : 'uniTable', columns : 3},
		items	: [{
			fieldLabel	: '<t:message code="system.label.purchase.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false,
			readOnly	: true
		},{
			xtype	: 'container',
			layout	: {type:'hbox', align:'stretch'},
			width	: 530,
			colspan	: 2,
			items	: [{
				fieldLabel	: '계획주차',
				name		: 'OPTION_DATE_FR',
				xtype		: 'uniDatefield',
				allowBlank	: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
					},
					blur : function (field, event, eOpts) {
						if(Ext.isEmpty(field.value)){
							prodSearch.setValue('WEEK_NUM_FR','');
						}else{
							var param = {
								'OPTION_DATE' : UniDate.getDbDateStr(field.value),
								'CAL_TYPE' : '3' //주단위
							}
							prodtCommonService.getCalNo(param, function(provider, response) {
								if(!Ext.isEmpty(provider.CAL_NO)){
									prodSearch.setValue('WEEK_NUM_FR',provider.CAL_NO);
								}else{
									prodSearch.setValue('WEEK_NUM_FR','');
								}
							})
						}
					}
				}
			},{
				fieldLabel	: '계획주차FR',
				xtype		: 'uniTextfield',
				name		: 'WEEK_NUM_FR',
				width		: 60,
				hideLabel	: true,
				allowBlank	: false
			},{
				xtype	: 'component',
				html	: '~',
				style	: {
					marginTop: '3px !important',
					font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
				}
			},{
				fieldLabel	: '계획주차',
				hideLabel	: true,
				name		: 'OPTION_DATE_TO',
				xtype		: 'uniDatefield',
				allowBlank	: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
					},
					blur : function (field, event, eOpts) {
						if(Ext.isEmpty(field.value)){
							prodSearch.setValue('WEEK_NUM_TO','');
						}else{
							var param = {
								'OPTION_DATE' : UniDate.getDbDateStr(field.value),
								'CAL_TYPE' : '3' //주단위
							}
							prodtCommonService.getCalNo(param, function(provider, response) {
								if(!Ext.isEmpty(provider.CAL_NO)){
									prodSearch.setValue('WEEK_NUM_TO',provider.CAL_NO);
								}else{
									prodSearch.setValue('WEEK_NUM_TO','');
								}
							})
						}
					}
				}
			},{
				fieldLabel	: '계획주차TO',
				xtype		: 'uniTextfield',
				name		: 'WEEK_NUM_TO',
				width		: 60,
				hideLabel	: true,
				allowBlank	: false
			}]
		},{
			name		: 'ITEM_ACCOUNT',
			fieldLabel	: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B020',
			allowBlank	: false
		},
		Unilite.popup('DIV_PUMOK',{
			fieldLabel		: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',
			valueFieldName	: 'ITEM_CODE',
			textFieldName	: 'ITEM_NAME',
			listeners		: {
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': prodSearch.getValue('DIV_CODE')});
				}
			}
		}),{
			xtype		: 'radiogroup',
			fieldLabel	: '발주확정',
			id			: 'rdoSelect',
			items		: [{
				boxLabel	: '전체',
				width		: 80,
				name		: 'ORDER_YN',
				inputValue	: 'A'
			},{
				boxLabel	: '미확정',
				width		: 80,
				name		: 'ORDER_YN',
				inputValue	: 'N',
				checked		: true
			},{
				boxLabel	: '확정',
				width		: 80,
				name		: 'ORDER_YN',
				inputValue	: 'Y'
			}]
		}]
	});

	var prodGrid = Unilite.createGrid('mpo080ukrvProdGrid', {
		layout	: 'fit',
		store	: prodStore,
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }),
		uniOpt	: {
			onLoadSelectFirst : false
		},
		columns	: [
			{ dataIndex: 'DIV_CODE'			, width: 120,hidden:true},
			{ dataIndex: 'ITEM_CODE'		, width: 100},
			{ dataIndex: 'ITEM_NAME'		, width: 200},
			{ dataIndex: 'SPEC'				, width: 100},
			{ dataIndex: 'STOCK_UNIT'		, width: 80,align:'center'},
			{ dataIndex: 'WK_PLAN_Q'		, width: 100},
			{ dataIndex: 'WK_PLAN_NUM'		, width: 120},
			{ dataIndex: 'PRODT_PLAN_DATE'	, width: 80},
			{ dataIndex: 'WEEK_NUM'			, width: 80},
			{ dataIndex: 'MRP_CONTROL_NUM'	, width: 120},
			{ dataIndex: 'ORDER_YN'			, width: 80,align:'center'},
			{ dataIndex: 'CUSTOM_NAME'		, width: 200}
		],
		listeners: {
			onGridDblClick:function(grid, record, cellIndex, colName) {
			},
			deselect: function( model, record, index, eOpts ){
			},
			select: function( model, record, index, eOpts ){
			}
		},
		returnData: function(record) {
			if(Ext.isEmpty(record)) {
				records = this.getSelectedRecords();
			}
			Ext.each(records, function(record,i) {
				UniAppManager.app.onNewDataButtonDown();
				masterGrid.setData(record.data);
			});
			this.getStore().remove(records);
			panelResult.getField('DIV_CODE').setReadOnly(true);
		}
	});

	function openProductionPlanWindow() {
		if(!panelResult.getInvalidMessage()) return;	//필수체크
		if(!referProductionPlanWindow) {
			referProductionPlanWindow = Ext.create('widget.uniDetailWindow', {
				title	: '생산계획참조',
				width	: 1200,
				height	: 580,
				layout	: {type:'vbox', align:'stretch'},
				items	: [prodSearch, prodGrid],
				tbar	: ['->',{
					itemId	: 'saveBtn',
					id		: 'saveBtn1',
					text	: '<t:message code="system.label.purchase.inquiry" default="조회"/>',
					handler	: function() {
						if(!prodSearch.getInvalidMessage()) return;	//필수체크
						prodStore.loadStoreRecords();
					},
					disabled: false
				},{
					itemId	: 'confirmBtn',
					id		: 'confirmBtn1',
					text	: '적용',
					handler	: function() {
						prodGrid.returnData();
						var maxIndex = 0;
						Ext.each(directMasterStore.data.items, function(record, index, records){
							if(record.phantom){
								maxIndex = index
							}
						});
						masterGrid.getSelectionModel().selectRange(0, maxIndex);
					},
					disabled: false
				},{
					itemId	: 'confirmCloseBtn',
					id		: 'confirmCloseBtn1',
					text	: '적용 후 닫기',
					handler	: function() {
						prodGrid.returnData();
						var maxIndex = 0;
						Ext.each(directMasterStore.data.items, function(record, index, records){
							if(record.phantom){
								maxIndex = index
							}
						});
						masterGrid.getSelectionModel().selectRange(0, maxIndex);
						referProductionPlanWindow.hide();
					},
					disabled: false
				},{
					itemId	: 'closeBtn',
					id		: 'closeBtn1',
					text	: '<t:message code="system.label.purchase.close" default="닫기"/>',
					handler	: function() {
						referProductionPlanWindow.hide();
					},
					disabled: false
				}],
				listeners : {
					beforehide: function(me, eOpt) {
						prodSearch.clearForm();
						prodGrid.reset();
						prodStore.clearData();
					},
					beforeclose: function( panel, eOpts ) {},
					beforeshow: function ( me, eOpts ) {
						prodSearch.setValue('DIV_CODE'		, panelResult.getValue("DIV_CODE"));
						prodSearch.setValue('OPTION_DATE_FR', panelResult.getValue("OPTION_DATE_FR"));
						prodSearch.setValue('WEEK_NUM_FR'	, panelResult.getValue("WEEK_NUM_FR"));
						prodSearch.setValue('OPTION_DATE_TO', panelResult.getValue("OPTION_DATE_TO"));
						prodSearch.setValue('WEEK_NUM_TO'	, panelResult.getValue("WEEK_NUM_TO"));
						prodSearch.setValue('ITEM_ACCOUNT'	, panelResult.getValue("ITEM_ACCOUNT"));
//						prodStore.loadStoreRecords();
					}
				}
			})
		}
		referProductionPlanWindow.center();
		referProductionPlanWindow.show();
	}



	var tab = Unilite.createTabPanel('tabPanel',{
		activeTab	: 0,
		region		: 'center',
		items		: [{
			title	: '발주확정(SUM)',
			xtype	: 'container',
			layout	: {type:'vbox', align:'stretch'},
			items	: [panelResult2,detailGrid],
			id		: 'tab1'
		},{
			title	: '소요량내역',
			xtype	: 'container',
			layout	: {type:'vbox', align:'stretch'},
			items	: [detailGrid2],
			id		: 'tab2'
		},{
			title	: '소요량내역(선택)',
			xtype	: 'container',
			layout	: {type:'vbox', align:'stretch'},
			items	: [detailGrid3],
			id		: 'tab3'
		}],
		listeners : {
			beforetabchange : function ( tabPanel, newCard, oldCard, eOpts )  {
				if(!panelResult.getInvalidMessage()) return false;	// 필수체크
			},
			tabChange : function ( tabPanel, newCard, oldCard, eOpts )  {
				var newTabId = newCard.getId();
//				if(newTabId == 'tab1'){
//					Ext.getCmp('btn2').setDisabled(false);
//				}else{
//					Ext.getCmp('btn2').setDisabled(true);
//				}
//				UniAppManager.app.onQueryButtonDown();
			}
		}
	});



	Unilite.Main({
		id			: 'mpo080ukrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				panelResult, masterGrid, tab
			]}
		],
		fnInitBinding: function() {
			this.setDefault();
			gsInit = false;									//20200716 초기화 시 조회로직 안 타도록 수정 
		},
		onQueryButtonDown: function() {
//			if(!panelResult.getInvalidMessage()) return;	//필수체크
			directMasterStore.loadStoreRecords();
		},
		onNewDataButtonDown: function() {
			if(!panelResult.getInvalidMessage()) return;	//필수체크
			var divCode = panelResult.getValue('DIV_CODE');
			var r = {
				DIV_CODE: divCode
			}
			masterGrid.createRow(r,null,-1);
//			UniAppManager.setToolbarButtons('delete', true);
		},
		onResetButtonDown: function() {
			gsInit = true;								//20200716 초기화 시 조회로직 안 타도록 수정 
			panelResult.clearForm();
			masterGrid.reset();
			directMasterStore.clearData();
			detailGrid.reset();
			directDetailStore.clearData();
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {
//			directMasterStore.saveStore();
			directDetailStore.saveStore();
		},
		onDeleteDataButtonDown: function() {
			var selRows = masterGrid.getSelectedRecords();
			var cnt = 0;
			Ext.each(selRows, function(row, index){
				if(row.phantom == false){
					cnt = cnt + 1;
				}
			});
			if(cnt > 0){
				if(confirm("선택한 데이터를 삭제 합니다. 삭제 하시겠습니까?")) {
					var selRow = masterGrid.getSelectedRecord();
					if(selRow) {
						masterGrid.deleteSelectedRow();
					}
					directMasterStore.saveStore();
				}
			}else{
				var selRow = masterGrid.getSelectedRecord();
				if(selRow) {
					masterGrid.deleteSelectedRow();
				}
			}
		},
		setDefault: function() {
			panelResult.setValue('DIV_CODE'			, UserInfo.divCode);
			panelResult.setValue('OPTION_DATE_FR'	, UniDate.get('today'));
			panelResult.setValue('OPTION_DATE_TO'	, UniDate.get('todayOfNextMonth'));
			//20200716 추가: 확정여부 조회조건 추가
			panelResult.getField('CONFIRM_YN').setValue('');
			var param = {
				'OPTION_DATE'	: UniDate.getDbDateStr(UniDate.get('today')),
				'CAL_TYPE'		: '3' //주단위
			}
			prodtCommonService.getCalNo(param, function(provider, response) {
				if(!Ext.isEmpty(provider.CAL_NO)){
					panelResult.setValue('WEEK_NUM_FR',provider.CAL_NO);
				}else{
					panelResult.setValue('WEEK_NUM_FR','');
				}
			});
			var param = {
				'OPTION_DATE'	: UniDate.getDbDateStr(UniDate.get('todayOfNextMonth')),
				'CAL_TYPE'		: '3' //주단위
			}
			prodtCommonService.getCalNo(param, function(provider, response) {
				if(!Ext.isEmpty(provider.CAL_NO)){
					panelResult.setValue('WEEK_NUM_TO',provider.CAL_NO);
				}else{
					panelResult.setValue('WEEK_NUM_TO','');
				}
			});
			UniAppManager.setToolbarButtons(['save','newData'], false);
			UniAppManager.setToolbarButtons('reset', true);
			panelResult.getField('DIV_CODE').setReadOnly(false);
		}
	});

	function fnMakeLogStore() {
		var records = masterGrid.getSelectedRecords();
		buttonStore.clearData();
		Ext.each(records, function(record, index) {
			record.phantom = true;
			buttonStore.insert(index, record);
		});
		buttonStore.saveStore();
	}

/*	function fnMakeLogStore2() {
		var records = directDetailStore.data.items;

		buttonStore2.clearData();
		Ext.each(records, function(record, index) {
			if(record.get('ORDER_Q') > 0){
				record.phantom			= true;
				buttonStore2.insert(index, record);
			}
		});
		buttonStore2.saveStore();
	}*/
};
</script>