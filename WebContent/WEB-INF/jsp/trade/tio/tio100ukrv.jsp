<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="tio100ukrv"  >
	<t:ExtComboStore comboType="BOR120"  />				<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B004"/>	<!-- 지급구분 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

var SearchInfoWindow, RefSearchWindow , otherRefSearchWindow;
var excelWindow;
var gImportType;
var gsDel		= '';
var gbRetrieved	= '';
var isLoad		= false; //로딩 플래그 화폐단위 <t:message code="system.label.trade.exchangerate" default="환율"/> change 로드시 계속 타므로 임시로 막음
var isLoad2		= false; //작성일 로드시 계속 타므로 임시로 막음
var outDivCode	= UserInfo.divCode;
var aa			= 0;
var agreePrsn	= '';
var agreeStatus	= '';
var agreeDate	= '';
var gNationInout= "2";
var BsaCodeInfo	= {
	gsDefaultMoney		: '${gsDefaultMoney}',
	gsAutoNumber		: '${gsAutoNumber}',
	agreePrsn			: '${agreePrsn}',
	importPrsn			: '${importPrsn}',		//20191202 구매담당 추가
	gsLotNoInputMethod	: '${MNG_LOT}',
	gsLotNoEssential	: '${ESS_YN}',
	gsEssItemAccount	: '${ESS_ACCOUNT}',
	gsOrderConfirm		: '${gsOrderConfirm}',
	gsTradeCalcMethod	: '${gsTradeCalcMethod}'
};
//20191127 계산로직 수정
var gsCalFlag = true;
//20191127 조회시 재계산 안하도록 수정
var gsQueryFlag = true;


function appMain() {
	var directProxy1 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'tio100ukrvService.selectList',
			update	: 'tio100ukrvService.updateDetail',
			create	: 'tio100ukrvService.insertDetail',
			destroy	: 'tio100ukrvService.deleteDetail',
			syncAll	: 'tio100ukrvService.saveAll'
		}
	});

	Unilite.defineModel('tio100ukrvModel1', {
		fields: [
			{name: 'DIV_CODE'		, text: '<t:message code="system.label.trade.division" default="사업장"/>'					, type: 'string'},
			{name: 'SO_SER_NO'		, text: 'SO_SER_NO'		, type: 'string', editable: false},
			{name: 'SO_SER'			, text: '<t:message code="system.label.trade.seq" default="순번"/>'						, type: 'int', editable: false},
			{name: 'ITEM_CODE'		, text: '<t:message code="system.label.trade.itemcode" default="품목코드"/>'				, type: 'string', allowBlank: false},
			{name: 'ITEM_NAME'		, text: '<t:message code="system.label.trade.itemname2" default="품명 "/>'					, type: 'string', allowBlank: false},
			{name: 'SPEC'			, text: '<t:message code="system.label.trade.spec" default="규격"/>'						, type: 'string'},
			{name: 'STOCK_UNIT_Q'	, text: '<t:message code="system.label.trade.inventoryunitqty" default="재고단위량"/>'		, type: 'uniQty', allowBlank: false, editable: false},
			{name: 'STOCK_UNIT'		, text: '<t:message code="system.label.trade.inventorystockunit" default="재고단위"/>'		, type: 'string', editable: false,comboType:'AU',comboCode:'B013', displayField: 'value'},
			{name: 'TRNS_RATE'		, text: '<t:message code="system.label.trade.containedqty" default="입수"/>'				, type: 'float' , allowBlank: false, decimalPrecision:6, format:'0,000.000000', defaultValue: 1.000000},
			{name: 'ORDER_UNIT_Q'	, text: '<t:message code="system.label.trade.purchaseunitqty" default="구매단위수량"/>'		, type: 'uniQty', allowBlank: false},
			{name: 'UNIT'			, text: '<t:message code="system.label.trade.purchaseunit" default="구매단위"/>'			, type: 'string' ,comboType:'AU',comboCode:'B013', allowBlank: false, displayField: 'value'},
			{name: 'PRICE'			, text: '<t:message code="system.label.trade.purchaseunitprice" default="구매단위단가"/>'		, type: 'uniUnitPrice', allowBlank: false},
			{name: 'SO_AMT'			, text: '<t:message code="system.label.trade.offeramount2" default="OFFER액"/>'			, type: 'uniFC', allowBlank: false},
			{name: 'EXCHANGE_RATE'	, text: '<t:message code="system.label.trade.exchangerate" default="환율"/>'				, type: 'string'},
			//20191127 수정 가능하도록 변경
			{name: 'SO_AMT_WON'		, text: '<t:message code="system.label.trade.exchangeamount" default="환산액 "/>'			, type: 'uniFC'/*,editable:false*/},//uniPrice로 추후 변경(데이터 확인을 위해 FC로 설정)
			{name: 'HS_NO'			, text: '<t:message code="system.label.trade.hsno" default="HS번호"/>'					, type: 'string', allowBlank: false},
			{name: 'HS_NAME'		, text: '<t:message code="system.label.trade.hsname" default="HS명"/>'					, type: 'string'},
			{name: 'DELIVERY_DATE'	, text: '<t:message code="system.label.trade.estimateddiliverydate" default="예상납기일"/>'	, type: 'uniDate', allowBlank: false},
			{name: 'MORE_PER_RATE'	, text: '<t:message code="system.label.trade.shortagerate" default="과부족허용율"/>(+)'		, type: 'uniPercent', allowBlank: true},
			{name: 'LESS_PER_RATE'	, text: '<t:message code="system.label.trade.shortagerate" default="과부족허용율"/>(-)'		, type: 'uniPercent', allowBlank: true},
			{name: 'CLOSE_FLAG'		, text: '<t:message code="system.label.trade.closingyn" default="마감여부"/>'				, type: 'string'},
			{name: 'USE_QTY'		, text: '<t:message code="system.label.trade.process" default="진행"/>'					, type: 'uniQty'},
			{name: 'INSPEC_FLAG'	, text: '<t:message code="system.label.trade.qualityyn" default="품질대상여부"/>'				, type: 'string', comboType:'AU',comboCode:'Q002', allowBlank: false},
			{name: 'ORDER_REQ_NUM'	, text: '<t:message code="system.label.trade.poreserveno" default="발주예정번호"/>'			, type: 'string', editable:false},
			{name: 'UPDATE_DB_USER'	, text: '<t:message code="system.label.trade.updateuser" default="수정자"/>'				, type: 'string'},
			{name: 'UPDATE_DB_TIME'	, text: '<t:message code="system.label.trade.updatedate" default="수정일"/>'				, type: 'string'},
			{name: 'ORDER_NUM'		, text: '<t:message code="system.label.trade.orderno" default="주문번호"/>'					, type: 'string'},
			{name: 'ORDER_SEQ'		, text: '<t:message code="system.label.trade.seq" default="순번"/>'						, type: 'string'},
			{name: 'PROJECT_NO'		, text: '<t:message code="system.label.trade.projectno" default="프로젝트번호"/>'				, type: 'string'},
			{name: 'COMP_CODE'		, text: 'COMP_CODE'		, type: 'string'},
			{name: 'LOT_NO'			, text: 'LOT NO'		, type: 'string', editable: false},
			{name: 'ITEM_ACCOUNT'	, text: 'ITEM_ACCOUNT'	, type: 'string'},
			{name: 'SAVE_FLAG'		, text: 'SAVE_FLAG'		, type: 'string'}
		]
	});

	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('tio100ukrvMasterStore1',{
		model	: 'tio100ukrvModel1',
		proxy	: directProxy1,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결
			editable	: true,		// 수정 모드 사용
			deletable	: true,		// 삭제 가능 여부
			allDeletable: true,		// 전체 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		autoLoad: false,
		loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
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

			if(inValidRecs.length == 0) {
				var sType = '';
				if(gsDel == "Y"){//
					sType = "D"
				} else {
					if (gbRetrieved){
						sType = "U"
					} else {
						sType = "N"
					}
				}
				var paramMaster				= panelResult.getValues();	//syncAll 수정
				paramMaster['sType']		= sType;
				paramMaster['NATION_INOUT']	= gNationInout;
				paramMaster['IMPORT_TYPE']	= gImportType;

				config = {
					params: [paramMaster],
					success: function(batch, option) {
						if(gsDel = "Y"){
							gbRetrieved = false;
						} else {
							gbRetrieved = true;
						}
						var master = batch.operations[0].getResultSet();
						panelResult.setValue("SO_SER_NO", master.SO_SER_NO);
						panelSearch.setValue("SO_SER_NO", master.SO_SER_NO);
						panelResult.getForm().wasDirty = false;
						panelResult.resetDirtyStatus();
						panelSearch.getForm().wasDirty = false;
						panelSearch.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);
						if (directMasterStore1.count() == 0) {
							UniAppManager.app.onResetButtonDown();
						} else {
							panelResult.setAllFieldsReadOnly(true);
							directMasterStore1.loadStoreRecords();
						}
					}
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('tio100ukrvGrid1');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		fnAmtTotal:function(){
			//20191127 계산로직 수정
			if(gsCalFlag) {
				var data = this.data.items;
				if(!Ext.isEmpty(data)){
					var stockQty = 0;
					var qty = 0;
					var dAMT =0;
					data.forEach(function(item,i){
						var itemData = item.data;
						if(!Ext.isEmpty(itemData.STOCK_UNIT_Q)){
							stockQty = stockQty + itemData.STOCK_UNIT_Q
						}
						if(!Ext.isEmpty(itemData.ORDER_UNIT_Q)){
							qty = qty + itemData.ORDER_UNIT_Q
						}
						if(!Ext.isEmpty(itemData.SO_AMT)){
							dAMT = dAMT+itemData.SO_AMT
						}
					});
					var er = panelResult.getValue('EXCHANGE_RATE');
					var amtUnit = panelResult.getValue('AMT_UNIT');
					panelResult.setValue('STOCK_QTY',stockQty); //재고 단위량
					panelResult.setValue('QTY',qty); //구매단위량
//					panelResult.setValue('SO_AMT_WON',UniMatrl.fnExchangeApply(amtUnit,dAMT)*er);
//					panelResult.setValue('SO_AMT',dAMT);

					panelSearch.setValue('STOCK_QTY',stockQty);
					panelSearch.setValue('QTY',qty);
//					panelSearch.setValue('SO_AMT_WON',UniMatrl.fnExchangeApply(amtUnit,dAMT)*er);
//					panelSearch.setValue('SO_AMT',dAMT);
					var results = directMasterStore1.sumBy(function(record, id){
						return true;},
					['SO_AMT', 'SO_AMT_WON']);
					panelResult.setValue('SO_AMT_WON'	, results.SO_AMT_WON);
					panelResult.setValue('SO_AMT'		, results.SO_AMT);
					panelSearch.setValue('SO_AMT_WON'	, results.SO_AMT_WON);
					panelSearch.setValue('SO_AMT'		, results.SO_AMT);
				}
			}
			gsCalFlag = true;
		},
		fnRecordSum:function(newValue){
			var data = this.data.items;
			if(!Ext.isEmpty(data)){
				Ext.each(data,function(item,i){
					var itemData = item.data;
					//20191127 로직 수정, 20191129 추가 수정
					//20200204 공통코드 t125값에 따라 절상,절사,반올림 처리
					var soAmtWon = itemData.ORDER_UNIT_Q * itemData.PRICE * newValue;
					//20200608 수정: 화폐가 'JPY'일 때 계산을 위해 UniMatrl.fnExchangeApply 함수 
					item.set('SO_AMT_WON',UniMatrl.fnAmtWonCalc(UniMatrl.fnExchangeApply(panelResult.getValue('AMT_UNIT'), soAmtWon), BsaCodeInfo.gsTradeCalcMethod, 0));
				});
				var results = directMasterStore1.sumBy(function(record, id){
					return true;},
				['SO_AMT', 'SO_AMT_WON']);
				panelResult.setValue('SO_AMT_WON'	, results.SO_AMT_WON);
				panelResult.setValue('SO_AMT'		, results.SO_AMT);
				panelSearch.setValue('SO_AMT_WON'	, results.SO_AMT_WON);
				panelSearch.setValue('SO_AMT'		, results.SO_AMT);
			}
		},
		listeners:{
			load: function(store, records, successful, eOpts){
				if(store.count() > 0){
					Ext.getCmp('ChargeInput').setDisabled(false);
					Ext.getCmp('ChargeInput1').setDisabled(false);
				}
				if(!Ext.isEmpty(directMasterStore1.data.items)){
					gbRetrieved = true;
				} else {
					gbRetrieved = false
				}
				gsDel = '';
//				this.fnAmtTotal();
			},
			add: function(store, records, index, eOpts) {
//				this.fnAmtTotal();
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
//				this.fnAmtTotal();
			},
			remove: function(store, record, index, isMove, eOpts) {
//				this.fnAmtTotal();
			}
		}
	});



	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '<t:message code="system.label.trade.searchconditon" default="검색조건"/>',
		defaultType: 'uniSearchSubPanel',
		collapsed: !UserInfo.appOption.collapseLeftSearch,
		listeners: {
		},
		items: [{
			title: '',
			itemId: 'search_panel1',
			collapsible:false,
			layout: {type: 'uniTable', columns: 1},
			defaultType: 'uniTextfield',
			items: [{
				fieldLabel: '<t:message code="system.label.trade.division" default="사업장"/>',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				allowBlank: false,
				value: UserInfo.divCode,
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},
			Unilite.popup('AGENT_CUST', {
				fieldLabel: '<t:message code="system.label.trade.exporter" default="수출자"/>',
				valueFieldName: 'EXPORTER', //EXPORTER
				textFieldName: 'EXPORTER_NM',
				textFieldWidth:175,
				allowBlank: false,
				holdable: 'hold',
				//validateBlank:false,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('EXPORTER', panelSearch.getValue('EXPORTER'));
							panelResult.setValue('EXPORTER_NM', panelSearch.getValue('EXPORTER_NM'));

							if(!Ext.isEmpty(records[0].BANK_CODE)){
								panelResult.setValue('BANK_SENDING', records[0].BANK_CODE);
								panelResult.setValue('BANK_SENDING_NM', records[0].BANK_NAME);

								panelSearch.setValue('BANK_SENDING', records[0].BANK_CODE);
								panelSearch.setValue('BANK_SENDING_NM', records[0].BANK_NAME);
							}
							panelResult.setValue('AMT_UNIT', records[0].MONEY_UNIT);
							panelSearch.setValue('AMT_UNIT', records[0].MONEY_UNIT);
						},
						scope: this
					},
					onClear: function(type) {
						panelResult.setValue('EXPORTER', '');
						panelResult.setValue('EXPORTER_NM', '');

						panelResult.setValue('BANK_SENDING', '');
						panelResult.setValue('BANK_SENDING_NM', '');

						panelSearch.setValue('BANK_SENDING', '');
						panelSearch.setValue('BANK_SENDING_NM', '');
					}
				}
			}),{
				xtype: 'uniDatefield',
				name: 'DATE_DEPART',
				fieldLabel: '<t:message code="system.label.trade.writtendate" default="작성일"/>',
				allowBlank: false,
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DATE_DEPART', newValue);
						if(Ext.isDate(newValue)) {
							UniAppManager.app.fnExchngRateO();
						}
					}
				}
			},
			Unilite.popup('USER_SINGLE', {
				fieldLabel: '<t:message code="system.label.trade.approvaluser" default="승인자"/>',
				textFieldWidth: 150,
				hidden:BsaCodeInfo.gsOrderYn == '2',
				textFieldName:'AGREE_PRSN',
				holdable: 'hold',
				listeners: {
					onSelected: {
						fn: function(records, type) {
							console.log('records : ', records);
							panelResult.setValue('AGREE_PRSN', records[0]["USER_ID"]);
//							panelResult.setValue('AGREE_PRSN_NAME', records[0]["USER_NAME"]);
						},
						scope: this
					},
					onClear: function(type) {
						panelResult.setValue('AGREE_PRSN', '');
//						panelResult.setValue('AGREE_PRSN_NAME', '');
					}
				}
			}),

				Unilite.popup('AGENT_CUST', {
				fieldLabel: '<t:message code="system.label.trade.agent" default="대행자"/>',
//				valueFieldName: 'AGENTQ', //EXPORTER
				textFieldName: 'AGENTQ',
				textFieldWidth:175,

				//validateBlank:false,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('AGENTQ', panelSearch.getValue('AGENTQ'));
//							panelResult.setValue('AGENT_NMQ', panelSearch.getValue('AGENT_NMQ'));
						},
						scope: this
					},
					onClear: function(type) {
						panelResult.setValue('AGENTQ', '');
//						panelResult.setValue('AGENT_NMQ', '');
					}
				}
			}),{
				xtype:'container',
				colspan:1,
				layout : {type : 'uniTable', columns : 3},
				margin:'0 0 0 115',
				items:[ /*{
					text: '<t:message code="system.label.trade.otherofferrefer" default="타OFFER 참조"/>',
					xtype: 'button',
					disabled:false,
					handler: function() {
							openSearchInfoWindow(1);
					}
				}, */{
					text: '<t:message code="system.label.trade.expenseentry" default="경비등록"/>',
					margin:'0 0 0 5',
					xtype: 'button',
					id:'ChargeInput',
					handler: function() {
						var needSave = !UniAppManager.app.getTopToolbar().getComponent('save').isDisabled();
						if(needSave ){
						 alert(Msg.sMB154); //먼저 저장하십시오.
						 return false;
						}
						var param = new Array();
						param[0] = "O";	//진행구분
						param[1] = panelSearch.getValue('SO_SER_NO'); //근거번호
						param[2] = panelSearch.getValue('EXPORTER');  //수출자
						param[3] = panelSearch.getValue('EXPORTER_NM');
						param[4] = ""
						param[5] = panelSearch.getValue('DIV_CODE');
						param[6] = panelSearch.getValue('AMT_UNIT');  //화폐단위
						param[7] = panelSearch.getValue('EXCHANGE_RATE'); //<t:message code="system.label.trade.exchangerate" default="환율"/>
						var params = {
							appId: UniAppManager.getApp().id,
							arrayParam: param
						}
						var rec = {data : {prgID : 'tix100ukrv', 'text':''}};
						parent.openTab(rec, '/trade/tix100ukrv.do', params, CHOST+CPATH);
					}
				}]
			}
		]},{
			title:'',
			itemId:'search_panel2',
			defaultType: 'uniTextfield',
			collapsed: false,
			layout: {type: 'uniTable', columns: 1},
			items:[{
				fieldLabel: '<t:message code="system.label.trade.offermanageno" default="OFFER 관리번호"/>',//diff
				name: 'SO_SER_NO',
				xtype: 'uniTextfield',
				readOnly: BsaCodeInfo.gsAutoNumber == 'Y',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('SO_SER_NO', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.trade.tradetype" default="무역종류"/>',
				name: 'TRADE_TYPE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'T002',
				allowBlank: false,
				value: '1',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('TRADE_TYPE', newValue);
					}
				}
			},
			Unilite.popup('AGENT_CUST', {
				fieldLabel: '<t:message code="system.label.trade.importer" default="수입자"/>',
				valueFieldName: 'IMPORTER', //EXPORTER
				textFieldName: 'IMPORTER_NM',
				textFieldWidth:175,
				allowBlank: false,
				readOnly: true,
				textFieldOnly: true,
				//validateBlank:false,
				listeners: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('IMPORTER', panelSearch.getValue('IMPORTER'));
								panelResult.setValue('IMPORTER_NM', panelSearch.getValue('IMPORTER_NM'));
							},
							scope: this
						},
						onClear: function(type) {
							panelResult.setValue('IMPORTER', '');
							panelResult.setValue('IMPORTER_NM', '');
						}
			 }
			}),{
				fieldLabel: '<t:message code="system.label.trade.contractdate" default="계약일"/>',
				xtype: 'uniDatefield',
				allowBlank: false,
				name: 'DATE_CONTRACT',

				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DATE_CONTRACT', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.trade.estimateddiliverydate" default="예상납기일"/>',
				xtype: 'uniDatefield',
				allowBlank: false,
				name: 'DATE_DELIVERY',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DATE_DELIVERY', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.trade.shipmentperiod" default="선적기한"/>',
				xtype: 'uniDatefield',
				allowBlank: true,
				name: 'DATE_EXP',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DATE_EXP', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.trade.payingterm" default="결제방법"/>',
				name: 'PAY_METHODE',
				xtype : 'uniCombobox',
				comboType:'AU',
				comboCode:'T016',
				allowBlank: false,
				value: 'T/T',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('PAY_METHODE', newValue);
						if(newValue == "LLC" || newValue =="ETC"){
							gNationInout = "1";
						} else {
							gNationInout = "2";
						}
					}
				}
			},{
				xtype: 'container',
				layout:{type:'uniTable',columns:3},
				items:
				[
					{
						fieldLabel: '<t:message code="system.label.trade.paymentcondition" default="결제조건"/>',
						name: 'PAY_TERMS',
						xtype : 'uniCombobox',
						comboType:'AU',
						allowBlank: false,
						value: '8',
						comboCode:'T006',
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {
								panelResult.setValue('PAY_TERMS', newValue);
							}
						}
					},{
						fieldLabel: '',
						name: 'PAY_DURING',
						width:40,
						padding:'0 0 0 5',
						xtype: 'uniNumberfield',
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {
								panelResult.setValue('PAY_DURING', newValue);
							}
						}
					},{
						xtype:'label',
						padding:'0 0 0 10',
						text:'Days'
					}
				]
			},{
				name: 'TERMS_PRICE',
				fieldLabel: '<t:message code="system.label.trade.pricecondition" default="가격조건 "/>',
				xtype:'uniCombobox',
				comboType:'AU',
				comboCode:'T005',
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('TERMS_PRICE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.trade.purchasecharge" default="구매담당"/>',
				name:'IMPORT_NM',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'M201',
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('IMPORT_NM', newValue);
						var param ={'SUB_CODE': newValue};
						fnGetAgreePrsn(param);

					}
				}
			},
			Unilite.popup('PJT',{
				fieldLabel: 'PROJECT NO',//diff
				valueFieldName: 'PJT_CODE',
				textFieldName: 'PJT_NAME',
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('PJT_CODE', panelResult.getValue('PJT_CODE'));
						},
						scope: this
					},
					onClear: function(type) {
						panelResult.setValue('PJT_CODE', '');
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
					}
				}
			}),
			Unilite.popup('AGENT_CUST', {
				fieldLabel: '<t:message code="system.label.trade.agent" default="대행자"/>',
				valueFieldName: 'AGENT', //EXPORTER
				textFieldName: 'AGENT_NM',
				textFieldWidth:175,

				textFieldOnly: true,
				//validateBlank:false,
				listeners: {
							onSelected: {
								fn: function(records, type) {
									panelResult.setValue('AGENT', panelSearch.getValue('AGENT'));
									panelResult.setValue('AGENT_NM', panelSearch.getValue('AGENT_NM'));
								},
								scope: this
							},
							onClear: function(type) {
								panelResult.setValue('AGENT', '');
								panelResult.setValue('AGENT_NM', '');
							}
						}
			}),{
				xtype:'container',
				layout:{type:'uniTable',columns:2},
				items:
				[
					{
						fieldLabel: '<t:message code="system.label.trade.offeramount2" default="OFFER액"/>',
						name: 'SO_AMT',
						width:185,
						xtype: 'uniNumberfield',
						type: 'uniFC',
						readOnly:true,
						allowBlank: false,
						listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('SO_AMT', newValue);
						}
						}
					},
					{
						xtype:'uniCombobox',
						comboType:'AU',
						comboCode:'B004',
						name:'AMT_UNIT',
						width:60,
						fieldLabel:'<t:message code="system.label.trade.currencyunit" default="화폐단위"/>',
						hideLabel: true,
						holdable: 'hold',
						displayField: 'value',
						fieldStyle: 'text-align: center;',
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {
								panelResult.setValue('AMT_UNIT', newValue);
								if(isLoad){
									isLoad = false;
								} else {
									UniAppManager.app.fnExchngRateO();
								}
							}
						}
					}
				]
			},{
				fieldLabel: '<t:message code="system.label.trade.exchangerate" default="환율"/>',
				name: 'EXCHANGE_RATE',
				allowBlank: false,
				xtype: 'uniNumberfield',
				type:'uniER',
//					decimalPrecision:4,
				readOnly:false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
//						//20191127 조회시 재계산 안하도록 수정
//						if(gsQueryFlag) {
//							if(newValue < 0){
//								Ext.Msg.alert('<t:message code="unilite.msg.sMB099"/>','숫자민잉력가능힘 니다');
//								panelSearch.setValue('EXCHANGE_RATE', oldValue);
//							} else {
//								panelResult.setValue('EXCHANGE_RATE', newValue);
//								var soAmt = panelSearch.getValue("SO_AMT");
//								var soAmtWon = soAmt*newValue;
//								panelResult.setValue('SO_AMT_WON',soAmtWon);
//								panelSearch.setValue('SO_AMT_WON',soAmtWon);
//								directMasterStore1.fnRecordSum(newValue);
//							}
//						}
//						gsQueryFlag = true;
					}
				}
			},{
					fieldLabel: '<t:message code="system.label.trade.exchangeamount" default="환산액 "/>',
					name: 'SO_AMT_WON',
					xtype: 'uniNumberfield',
					type:'uniUnitPrice',
					readOnly: true,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('SO_AMT_WON', newValue);
						}
					}
			},{
				fieldLabel: '<t:message code="system.label.trade.transportmethod" default="운송방법"/>',
				//labelWidth:120,
				name: 'METHD_CARRY',
				xtype : 'uniCombobox',
				comboType:'AU',
				comboCode:'T004',
				allowBlank: false,
				width:245,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('METHD_CARRY', newValue);
					}
				}
			},{
				name: 'METH_INSPECT',
				fieldLabel: '<t:message code="system.label.trade.inspecmethod" default="검사방법"/>',
				xtype:'uniCombobox',
				comboType:'AU',
				comboCode:'T011',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('METH_INSPECT', newValue);
					}
				}
			},{
				name: 'COND_PACKING',
				fieldLabel: '<t:message code="system.label.trade.packingmethod" default="포장방법"/>',
				xtype:'uniCombobox',
				comboType:'AU',
				comboCode:'T010',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('COND_PACKING', newValue);
					}
				}
			},{
				name: 'SHIP_PORT',
				fieldLabel: '<t:message code="system.label.trade.shipmentport" default="선적항"/>',
				xtype:'uniCombobox',
				comboType:'AU',
				comboCode:'T008',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('SHIP_PORT', newValue);
					}
				}
			},{
				name: 'DEST_PORT',
				fieldLabel: '<t:message code="system.label.trade.arrivalport" default="도착항"/>',
				xtype:'uniCombobox',
				comboType:'AU',
				colspan:1,
				comboCode:'T008',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DEST_PORT', newValue);
					}
				}
			},
			Unilite.popup('BANK',{
				fieldLabel:'<t:message code="system.label.trade.transbank" default="송금은행"/>',
				valueFieldName: 'BANK_SENDING',
				textFieldName: 'BANK_SENDING_NM',
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('BANK_SENDING', panelSearch.getValue('BANK_SENDING'));
							panelResult.setValue('BANK_SENDING_NM', panelSearch.getValue('BANK_SENDING_NM'));
						},
						scope: this
					},
					onClear: function(type) {
						panelResult.setValue('BANK_SENDING', '');
						panelResult.setValue('BANK_SENDING_NM', '');
					}
				}
			}),
			{	fieldLabel:'<t:message code="system.label.trade.origin1" default="원산지"/>',
				xtype: 'uniTextfield',
				name: 'ORIGIN1',
				flex: 1,

				colspan:1,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ORIGIN1', newValue);
					}
				}
			},
			{	fieldLabel:'<t:message code="system.label.trade.remarks" default="비고"/>',
				xtype: 'uniTextfield',
				name: 'FREE_TXT1',
				flex: 1,
				colspan:1,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('FREE_TXT1', newValue);
					}
				}
			},
			{	fieldLabel:'<t:message code="system.label.trade.inventoryunitqty" default="재고단위량"/>',
				xtype: 'uniNumberfield',
				name: 'STOCK_QTY',//查询没有属性
				type:'uniQty',
				flex: 1,
				readOnly:true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('STOCK_QTY', newValue);
					}
				}
			},
			{	fieldLabel:'<t:message code="system.label.purchase.purchaseunitqty" default="구매단위수량"/>',
				xtype: 'uniNumberfield',
				name: 'QTY',//查询没有属性
				type:'uniQty',
				flex: 1,
				readOnly:true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('QTY', newValue);
					}
				}
			}
			]}
		],
		setAllFieldsReadOnly: function(b) {
			var r= true
			if(b) {
				var invalid = this.getForm().getFields().filterBy(function(field) {
																	if(field.name == 'SO_AMT' && field.getValue() == 0){
																		return false;
																	}
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

					alert(labelText+Msg.sMB083);
					invalid.items[0].focus();
				} else {
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) ) {
							if (item.holdable == 'hold') {
								item.setReadOnly(true);
							}
						}
						if(item.isPopupField) {
							var popupFC = item.up('uniPopupField')	;
							if(popupFC.holdable == 'hold') {
								popupFC.setReadOnly(true);
							}
						}
					})
				}
			} else {
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) ) {
						if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					}
					if(item.isPopupField) {
						var popupFC = item.up('uniPopupField')	;
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		}
	});//End of var panelSearch = Unilite.createSearchForm('searchForm', {

	var panelResult = Unilite.createSearchForm('resultForm',{
		region: 'north',
		layout : {type : 'uniTable', columns : 1,	rows:2, tableAttrs: { style: { width: '100%',height:'100%' } }},
		padding:'1 1 1 1',
		border:true,
		defaultType: 'container',
		api:{
			load:'tio100ukrvService.selectForMaster'
		},
		items: [{
			title: '',
			itemId: 'search_panel1',
			collapsible:false,
			layout: {type: 'uniTable', columns: 3},
			defaultType: 'uniTextfield',
			items: [{
				fieldLabel: '<t:message code="system.label.trade.division" default="사업장"/>',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				allowBlank: false,
				value: UserInfo.divCode,
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('DIV_CODE', newValue);
					}
				}
			},
			Unilite.popup('AGENT_CUST', {
				fieldLabel: '<t:message code="system.label.trade.exporter" default="수출자"/>',
				valueFieldName: 'EXPORTER', //EXPORTER
				textFieldName: 'EXPORTER_NM',
				textFieldWidth:175,
				allowBlank: false,
				holdable: 'hold',
				//validateBlank:false,
				listeners: {
							onSelected: {
								fn: function(records, type) {
									panelSearch.setValue('EXPORTER', panelResult.getValue('EXPORTER'));
									panelSearch.setValue('EXPORTER_NM', panelResult.getValue('EXPORTER_NM'));

									if(!Ext.isEmpty(records[0].BANK_CODE)){
										panelResult.setValue('BANK_SENDING', records[0].BANK_CODE);
										panelResult.setValue('BANK_SENDING_NM', records[0].BANK_NAME);

										panelSearch.setValue('BANK_SENDING', records[0].BANK_CODE);
										panelSearch.setValue('BANK_SENDING_NM', records[0].BANK_NAME);
									}
									panelResult.setValue('AMT_UNIT', records[0].MONEY_UNIT);
									panelSearch.setValue('AMT_UNIT', records[0].MONEY_UNIT);
								},
								scope: this
							},
							onClear: function(type) {
								panelSearch.setValue('EXPORTER', '');
								panelSearch.setValue('EXPORTER_NM', '');

								panelResult.setValue('BANK_SENDING', '');
								panelResult.setValue('BANK_SENDING_NM', '');

								panelSearch.setValue('BANK_SENDING', '');
								panelSearch.setValue('BANK_SENDING_NM', '');
							}
						}
			}),{
				xtype: 'uniDatefield',
				name: 'DATE_DEPART',
				fieldLabel: '<t:message code="system.label.trade.writtendate" default="작성일"/>',
				allowBlank: false,
				labelWidth: 160,
				width: 264,
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('DATE_DEPART', newValue);
						if(Ext.isDate(newValue)) {
							//20191204 조회시 저장버튼 활성화에 따른 로직 추가
							if(isLoad2){
								isLoad2 = false;
							} else {
								UniAppManager.app.fnExchngRateO();
							}
//							UniAppManager.app.fnExchngRateO();
						}
					}
				}
			},
			Unilite.popup('USER_SINGLE', {
				fieldLabel: '<t:message code="system.label.trade.approvaluser" default="승인자"/>',
				hidden: BsaCodeInfo.gsOrderYn == '2',
				textFieldWidth: 150,
				textFieldName:'AGREE_PRSN',
				allowBlank: false,
				holdable: 'hold',
				listeners: {
					onSelected: {
						fn: function(records, type) {
							console.log('records : ', records);
							panelSearch.setValue('AGREE_PRSN', records[0]["USER_ID"]);
//							panelSearch.setValue('AGREE_PRSN_NAME', records[0]["USER_NAME"]);
						},
						scope: this
					},
					onClear: function(type) {
						panelSearch.setValue('AGREE_PRSN', '');
//						panelSearch.setValue('AGREE_PRSN_NAME', '');
					}
				}
			}),{
				xtype: 'uniTextfield',
				name: 'AGREE_STATUS',
				hidden: true
			},{
				xtype: 'uniTextfield',
				name: 'AGREE_DATE',
				hidden: true
			},
			Unilite.popup('AGENT_CUST', {
				fieldLabel: '<t:message code="system.label.trade.agent" default="대행자"/>',
//				valueFieldName: 'AGENTQ', //查询中未包含字段
				textFieldName: 'AGENTQ',
				textFieldWidth:175,
				//validateBlank:false,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('AGENTQ', panelResult.getValue('AGENTQ'));
//									panelSearch.setValue('AGENT_NMQ', panelResult.getValue('AGENT_NMQ'));

						},
						scope: this
					},
					onClear: function(type) {
						panelSearch.setValue('AGENTQ', '');
//								panelSearch.setValue('AGENT_NMQ', '');
					}
				}
			}),{
				fieldLabel: 'GW_FLAG',
				name:'GW_FLAG',
				xtype: 'uniTextfield',
				hidden: true,
				holdable: 'hold'/*,
				hidden: true*/
			},{
				xtype:'container',
				colspan:1,
				layout : {type : 'uniTable', columns : 3},
				margin:'0 3 0 165',
				items:[/*{
					text: '<t:message code="system.label.trade.otherofferrefer" default="타OFFER 참조"/>',
					xtype: 'button',
					disabled:false,
					handler: function() {
							openSearchInfoWindow(1);
					}
				},*/{
					text: '<t:message code="system.label.trade.expenseentry" default="경비등록"/>',
					margin:'0 0 0 5',
					xtype: 'button',
					id:'ChargeInput1',
//					hidden:true,//ChargeInput
					handler: function() {
						var needSave = !UniAppManager.app.getTopToolbar().getComponent('save').isDisabled();
						if(needSave ){
						 alert(Msg.sMB154); //먼저 저장하십시오.
						 return false;
						}
						var param = new Array();
						param[0] = "O";	//진행구분
						param[1] = panelSearch.getValue('SO_SER_NO'); //근거번호
						param[2] = panelSearch.getValue('EXPORTER');  //수출자
						param[3] = panelSearch.getValue('EXPORTER_NM');
						param[4] = ""
						param[5] = panelSearch.getValue('DIV_CODE');
						param[6] = panelSearch.getValue('AMT_UNIT');  //화폐단위
						param[7] = panelSearch.getValue('EXCHANGE_RATE'); //<t:message code="system.label.trade.exchangerate" default="환율"/>
						var params = {
							appId: UniAppManager.getApp().id,
							arrayParam: param
						}
						var rec = {data : {prgID : 'tix100ukrv', 'text':''}};
						parent.openTab(rec, '/trade/tix100ukrv.do', params, CHOST+CPATH);
					}
				}]
			}
		]},{
			title:'',
			itemId:'search_panel2',
			defaultType: 'uniTextfield',
			collapsed: false,
			layout: {type: 'uniTable', columns: 3},
			items:[{
				xtype: 'component',
				colspan: 3,
				tdAttrs: {style: 'border-bottom: 1px solid #cccccc;  padding-bottom: 3px;' }
			},{
				fieldLabel: '<t:message code="system.label.trade.offermanageno" default="OFFER 관리번호"/>',//diff
				name: 'SO_SER_NO',
				margin: '10 0 0 0',
				xtype: 'uniTextfield',
				readOnly: BsaCodeInfo.gsAutoNumber == 'Y',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('SO_SER_NO', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.trade.tradetype" default="무역종류"/>',
				name: 'TRADE_TYPE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'T002',
				allowBlank: false,
				holdable: 'hold',
				value: '1',
				margin: '10 0 0 0',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('TRADE_TYPE', newValue);
					}
				}
			},
			Unilite.popup('AGENT_CUST', {
				fieldLabel: '<t:message code="system.label.trade.importer" default="수입자"/>',
				valueFieldName: 'IMPORTER', //EXPORTER
				textFieldName: 'IMPORTER_NM',
				textFieldWidth:175,
				allowBlank: false,
				readOnly: true,
				margin: '10 0 0 0',
				//textFieldOnly: true,
				//validateBlank:false,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('IMPORTER', panelSearch.getValue('IMPORTER'));
							panelSearch.setValue('IMPORTER_NM', panelSearch.getValue('IMPORTER_NM'));
						},
						scope: this
					},
					onClear: function(type) {
						panelSearch.setValue('IMPORTER', '');
						panelSearch.setValue('IMPORTER_NM', '');
					}
				}
			}),{
				fieldLabel: '<t:message code="system.label.trade.contractdate" default="계약일"/>',
				xtype: 'uniDatefield',
				allowBlank: false,
				name: 'DATE_CONTRACT',
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('DATE_CONTRACT', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.trade.estimateddiliverydate" default="예상납기일"/>',
				xtype: 'uniDatefield',
				allowBlank: false,
				holdable: 'hold',
				name: 'DATE_DELIVERY',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('DATE_DELIVERY', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.trade.shipmentperiod" default="선적기한"/>',
				xtype: 'uniDatefield',
				allowBlank: true,
				holdable: 'hold',
				name: 'DATE_EXP',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('DATE_EXP', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.trade.payingterm" default="결제방법"/>',
				name: 'PAY_METHODE',
				xtype : 'uniCombobox',
				comboType:'AU',
				comboCode:'T016',
				allowBlank: false,
				value:'T/T',
//				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('PAY_METHODE', newValue);
						if(newValue == "LLC" || newValue =="ETC"){
							gNationInout = "1";
						} else {
							gNationInout = "2";
						}
					}
				}
			},{
				xtype: 'container',
				layout:{type:'uniTable',columns:3},
				items:
				[
					{
						fieldLabel: '<t:message code="system.label.trade.paymentcondition" default="결제조건"/>',
						name: 'PAY_TERMS',
						xtype : 'uniCombobox',
						comboType:'AU',
						allowBlank: false,
						value:'8',
//						holdable: 'hold',
						comboCode:'T006',
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {
								panelSearch.setValue('PAY_TERMS', newValue);
							}
						}
					},{
						fieldLabel: '',
						name: 'PAY_DURING',
						width:40,
						padding:'0 0 0 5',
						xtype: 'uniNumberfield',
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {
								panelSearch.setValue('PAY_DURING', newValue);
							}
						}
					},{
						xtype:'label',
						padding:'0 0 0 10',
						text:'Days'
					}
				]
			},{
				name: 'TERMS_PRICE',
				fieldLabel: '<t:message code="system.label.trade.pricecondition" default="가격조건 "/>',
				xtype:'uniCombobox',
				comboType:'AU',
				comboCode:'T005',
				allowBlank: false,
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('TERMS_PRICE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.trade.purchasecharge" default="구매담당"/>',
				name:'IMPORT_NM',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'M201',
				allowBlank: false,
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('IMPORT_NM', newValue);
						var param ={'SUB_CODE': newValue};
						fnGetAgreePrsn(param);
					}
				}
			},
			Unilite.popup('PJT',{
				fieldLabel: 'PROJECT NO',//diff
				valueFieldName: 'PJT_CODE',
				textFieldName: 'PJT_NAME',
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('PJT_CODE', panelResult.getValue('PJT_CODE'));
						},
						scope: this
					},
					onClear: function(type) {
						panelSearch.setValue('PJT_CODE', '');
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}
			}),
			Unilite.popup('AGENT_CUST', {
				fieldLabel: '<t:message code="system.label.trade.agent" default="대행자"/>',
				valueFieldName: 'AGENT', //EXPORTER
				textFieldName: 'AGENT_NM',
				textFieldWidth:175,
				textFieldOnly: true,
				//validateBlank:false,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('AGENT', panelResult.getValue('AGENT'));
							panelSearch.setValue('AGENT_NM', panelResult.getValue('AGENT_NM'));
						},
						scope: this
					},
					onClear: function(type) {
						panelSearch.setValue('AGENT', '');
						panelSearch.setValue('AGENT_NM', '');
					}
				}
			}),{
				xtype:'container',
				layout:{type:'uniTable',columns:2},
				items:
				[
					{
						fieldLabel: '<t:message code="system.label.trade.offeramount2" default="OFFER액"/>',
						name: 'SO_AMT',
						width:185,
						xtype: 'uniNumberfield',
						type: 'uniFC',
						readOnly:true,
						allowBlank: false,
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {
								panelSearch.setValue('SO_AMT', newValue);
							}
						}
					},{
						xtype:'uniCombobox',
						comboType:'AU',
						comboCode:'B004',
						name:'AMT_UNIT',
						width:60,
						allowBlank: false,
						fieldLabel:'<t:message code="system.label.trade.currencyunit" default="화폐단위"/>',
						hideLabel: true,
						holdable: 'hold',
						displayField: 'value',
						fieldStyle: 'text-align: center;',
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {
								panelSearch.setValue('AMT_UNIT', newValue);
							}
						}
					}
				]
			},{
				fieldLabel: '<t:message code="system.label.trade.exchangerate" default="환율"/>',
				name: 'EXCHANGE_RATE',
				xtype: 'uniNumberfield',
				type:'uniER',
//				decimalPrecision:4,
				allowBlank: false,
				holdable: 'hold',
				readOnly:false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						//20191127 조회시 재계산 안하도록 수정
						if(gsQueryFlag) {
							if(newValue < 0){
								Ext.Msg.alert('<t:message code="unilite.msg.sMB099"/>','<t:message code="unilite.msg.sMT249"/>');
								panelResult.setValue('EXCHANGE_RATE', oldValue);
							} else {
								panelSearch.setValue('EXCHANGE_RATE', newValue);
								var soAmt = panelResult.getValue("SO_AMT");
								var soAmtWon = soAmt*newValue;
								//20200204 공통코드 t125값에 따라 절상,절사,반올림 처리
								panelResult.setValue('SO_AMT_WON',UniMatrl.fnAmtWonCalc(soAmtWon, BsaCodeInfo.gsTradeCalcMethod, 0));
								panelSearch.setValue('SO_AMT_WON',UniMatrl.fnAmtWonCalc(soAmtWon, BsaCodeInfo.gsTradeCalcMethod, 0));
								directMasterStore1.fnRecordSum(newValue);
							}
						}
						gsQueryFlag = true;
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.trade.exchangeamount" default="환산액 "/>',
				name: 'SO_AMT_WON',
				xtype: 'uniNumberfield',
				type:'uniUnitPrice',
				readOnly: true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('SO_AMT_WON', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.trade.transportmethod" default="운송방법"/>',
				//labelWidth:120,
				name: 'METHD_CARRY',
				xtype : 'uniCombobox',
				comboType:'AU',
				comboCode:'T004',
				allowBlank: false,
				holdable: 'hold',
				width:245,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('METHD_CARRY', newValue);
					}
				}
			},{
				name: 'METH_INSPECT',
				fieldLabel: '<t:message code="system.label.trade.inspecmethod" default="검사방법"/>',
				xtype:'uniCombobox',
				comboType:'AU',
				comboCode:'T011',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('METH_INSPECT', newValue);
					}
				}
			},{
				name: 'COND_PACKING',
				fieldLabel: '<t:message code="system.label.trade.packingmethod" default="포장방법"/>',
				xtype:'uniCombobox',
				comboType:'AU',
				comboCode:'T010',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('COND_PACKING', newValue);
					}
				}
			},{
				name: 'SHIP_PORT',
				fieldLabel: '<t:message code="system.label.trade.shipmentport" default="선적항"/>',
				xtype:'uniCombobox',
				comboType:'AU',
				comboCode:'T008',
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('SHIP_PORT', newValue);
					}
				}
			},{
				name: 'DEST_PORT',
				fieldLabel: '<t:message code="system.label.trade.arrivalport" default="도착항"/>',
				xtype:'uniCombobox',
				comboType:'AU',
				colspan:2,
				holdable: 'hold',
				comboCode:'T008',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('DEST_PORT', newValue);
					}
				}
			},
			Unilite.popup('BANK',{
				fieldLabel:'<t:message code="system.label.trade.transbank" default="송금은행"/>',
				valueFieldName: 'BANK_SENDING',
				textFieldName: 'BANK_SENDING_NM',
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('BANK_SENDING', panelResult.getValue('BANK_SENDING'));
							panelSearch.setValue('BANK_SENDING_NM', panelResult.getValue('BANK_SENDING_NM'));
						},
						scope: this
					},
					onClear: function(type) {
						panelSearch.setValue('BANK_SENDING', '');
						panelSearch.setValue('BANK_SENDING_NM', '');
					}
				}
			}),
			{	fieldLabel:'<t:message code="system.label.trade.origin1" default="원산지"/>',
				xtype: 'uniTextfield',
				name: 'ORIGIN1',
				flex: 1,
				colspan:2,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('ORIGIN1', newValue);
					}
				}
			},
			{	fieldLabel:'<t:message code="system.label.trade.remarks" default="비고"/>',
				xtype: 'uniTextfield',
				name: 'FREE_TXT1',
				flex: 1,
				width:570,
				colspan:3,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('FREE_TXT1', newValue);
					}
				}
			},
			{	fieldLabel:'<t:message code="system.label.trade.inventoryunitqty" default="재고단위량"/>',
				xtype: 'uniNumberfield',
				name: 'STOCK_QTY',
				type:'uniQty',
				flex: 1,
				readOnly:true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('STOCK_QTY', newValue);
					}
				}
			},{	fieldLabel:'<t:message code="system.label.trade.purchaseunitqty" default="구매단위수량"/>',
				xtype: 'uniNumberfield',
				name: 'QTY',
				type:'uniQty',
				flex: 1,
				readOnly:true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('QTY', newValue);
					}
				}
			}]
		}],
		setAllFieldsReadOnly: function(b) {
			var r= true
			if(b) {
				var invalid = this.getForm().getFields().filterBy(function(field) {
																	if(field.name == 'SO_AMT' && field.getValue() == 0){
																		return false;
																	}
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

					alert(labelText+Msg.sMB083);
					invalid.items[0].focus();
				} else {
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) ) {
							if (item.holdable == 'hold') {
								item.setReadOnly(true);
							}
						}
						if(item.isPopupField) {
							var popupFC = item.up('uniPopupField')	;
							if(popupFC.holdable == 'hold') {
								popupFC.setReadOnly(true);
							}
						}
					})
				}
			} else {
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) ) {
						if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					}
					if(item.isPopupField) {
						var popupFC = item.up('uniPopupField')	;
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		},
		listeners: {
			uniOnChange: function(basicForm, dirty, eOpts) {
				var record = masterGrid.getSelectedRecord();
				if(!Ext.isEmpty(record)){
					UniAppManager.setToolbarButtons('save', true);
					record.set('SAVE_FLAG', 'Y');
				} else {
					UniAppManager.setToolbarButtons('save', false);
				}
			},
			collapse: function () {
				panelResult.show();
			},
			expand: function() {
				panelResult.hide();
			}
		}
	});		// end of var panelResult = Unilite.createSearchForm('resultForm',{

	function getLotPopupEditor(gsLotNoInputMethod){
		var editField;
		if(gsLotNoInputMethod == "E" || gsLotNoInputMethod == "Y"){
			editField = Unilite.popup('LOTNO_G',{
				textFieldName: 'LOTNO_CODE',
				DBtextFieldName: 'LOTNO_CODE',
				width:1000,
				autoPopup: true,
				listeners: {
					'onSelected': {
						fn: function(record, type) {
							var selectRec = masterGrid.getSelectedRecord()
							if(selectRec){
								selectRec.set('LOT_NO', record[0]["LOT_NO"]);
//										selectRec.set('GOOD_STOCK_Q', record[0]["GOOD_STOCK_Q"]);
//										selectRec.set('BAD_STOCK_Q', record[0]["BAD_STOCK_Q"]);
							}
						},
						scope: this
					},
					'onClear': {
						fn: function(record, type) {
							var selectRec = masterGrid.getSelectedRecord()
							if(selectRec){
								selectRec.set('LOT_NO', '');
//										selectRec.set('GOOD_STOCK_Q', 0);
//										selectRec.set('BAD_STOCK_Q', 0);
							}
						},
						scope: this
					},
					applyextparam: function(popup){
						var selectRec = masterGrid.getSelectedRecord();
						if(selectRec){
							popup.setExtParam({'DIV_CODE':  selectRec.get('DIV_CODE')});
							popup.setExtParam({'ITEM_CODE': selectRec.get('ITEM_CODE')});
							popup.setExtParam({'ITEM_NAME': selectRec.get('ITEM_NAME')});
							popup.setExtParam({'LOT_NO': selectRec.get('LOT_NO')});
							popup.setExtParam({'LOT_NO': selectRec.get('LOT_NO')});
//									popup.setExtParam({'CUSTOM_CODE': panelSearch.getValue('CUSTOM_CODE')});
//									popup.setExtParam({'CUSTOM_NAME': panelSearch.getValue('CUSTOM_NAME')});
//									popup.setExtParam({'WH_CODE': selectRec.get('WH_CODE')});
//									popup.setExtParam({'WH_CELL_CODE': selectRec.get('WH_CELL_CODE')});
							popup.setExtParam({'stockYN': 'Y'});
						}
					}
				}
			});
		} else if(gsLotNoInputMethod == "N"){
			editField = {xtype : 'textfield', maxLength:20}
		}

		var editor = Ext.create('Ext.grid.CellEditor', {
			ptype: 'cellediting',
			clicksToEdit: 1, // 1 or 2 , 수정 모드로 들어가기 위한 Click 횟수
			autoCancel : false,
			selectOnFocus:true,
			field: editField
		});
		return editor;
	}



	var masterGrid = Unilite.createGrid('tio100ukrvGrid1', {
		title	: '',
		store	: directMasterStore1,
		layout	: 'fit',
		region	: 'center',
		tbar	: [{
			itemId:'refTool',
			text: '<div style="color: blue"><t:message code="system.label.trade.porefer" default="발주참조"/></div>',
			handler: function() {
				if(Ext.isEmpty(panelResult.getValue('EXPORTER'))){
					Ext.Msg.alert('<t:message code="unilite.msg.sMB099" default="확인"/>','거래처를 입력하십시요.');
				} else {
					openRefSearchWindow();
				}
			}
		},{
			itemId:'refTool1',
			text: '<div style="color: blue"><t:message code="system.label.trade.otherofferrefer" default="타OFFER 참조"/></div>',
			//iconCls : 'icon-referance',
			handler: function() {
				if(Ext.isEmpty(panelResult.getValue('EXPORTER'))){
					Ext.Msg.alert('<t:message code="unilite.msg.sMB099" default="확인"/>','거래처를 입력하십시요.');
				} else {
					openOtherRefSearchWindow();
				}
			}
		},{
			itemId:'refTool2',
			text: '<div style="color: blue"><t:message code="system.label.trade.excelrefer" default="엑셀참조"/></div>',
			//iconCls : 'icon-referance',
			handler: function() {
				if(openExcelValidate()){
					openExcelWindow();
				}
			}
		}],
		uniOpt: {
			useGroupSummary		: false,
			useLiveSearch		: true,
			useContextMenu		: true,
			useMultipleSorting	: true,
			useRowNumberer		: false,
			expandLastColumn	: false,
			filter: {
				useFilter	: false,
				autoCreate	: false
			},
			excel: {
				useExcel		: true,		//엑셀 다운로드 사용 여부
				exportGroup		: true,		//group 상태로 export 여부
				onlyData		: false,
				summaryExport	: true
			}
		},
		//20191127 재고단위수량, 구매단위수량, 오퍼액, 환산액 합계 사용
		features: [{
			id: 'masterGridSubTotal',
			ftype: 'uniGroupingsummary',
			showSummaryRow: false
		},{
			id: 'masterGridTotal',
			ftype: 'uniSummary',
			showSummaryRow: true
		}],
		columns: [
			{dataIndex: 'DIV_CODE'				, width: 120, hidden:true},
			{dataIndex: 'SO_SER_NO'				, width: 120, hidden:true},
			{dataIndex: 'SO_SER'				, width: 66, locked: true, align: 'center'},
			{dataIndex: 'ITEM_CODE'				, width: 120, locked: true,
				editor: Unilite.popup('DIV_PUMOK_G', {
					textFieldName: 'ITEM_CODE',
					DBtextFieldName: 'ITEM_CODE',
					//extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode, POPUP_TYPE: 'GRID_CODE'},
					useBarcodeScanner: false,
					autoPopup: true,
					listeners: {
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
							var a = masterGrid.uniOpt.currentRecord.get('ITEM_CODE');
							masterGrid.setItemData(null,true, masterGrid.uniOpt.currentRecord);
							masterGrid.uniOpt.currentRecord.set('ITEM_CODE',a);
							if(aa == 0){
								if(a != ''){
									alert("미등록상품입니다.");
									aa++;
								}
							} else {
								aa=0;
							}
						},
						applyextparam: function(popup){
							//popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
							outDivCode = panelResult.getValue('DIV_CODE');
							popup.setExtParam({'SELMODEL': 'MULTI', 'DIV_CODE': outDivCode, 'POPUP_TYPE': 'GRID_CODE'});
						}
					}
				})
			},
			{dataIndex: 'ITEM_NAME'				, width: 120, locked: true,
				editor: Unilite.popup('DIV_PUMOK_G', {
					extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode},
					autoPopup: true,
					listeners: {
						'onSelected': {
							fn: function(records, type) {
								console.log('records : ', records);
								Ext.each(records, function(record,i) {
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
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
						}
					}
				})
			},
			{dataIndex: 'SPEC'					, width: 120},
			//20191127 재고단위수량, 구매단위수량, 오퍼액, 환산액 합계 사용
			{dataIndex: 'STOCK_UNIT_Q'			, width: 120, summaryType: 'sum'},
			{dataIndex: 'STOCK_UNIT'			, width: 120, align: 'center'},
			{dataIndex: 'TRNS_RATE'				, width: 120},
			//20191127 재고단위수량, 구매단위수량, 오퍼액, 환산액 합계 사용
			{dataIndex: 'ORDER_UNIT_Q'			, width: 120, summaryType: 'sum'},
			{dataIndex: 'UNIT'					, width: 120, align: 'center'},
			{dataIndex: 'PRICE'					, width: 120},
			//20191127 재고단위수량, 구매단위수량, 오퍼액, 환산액 합계 사용
			{dataIndex: 'SO_AMT'				, width: 120, summaryType: 'sum'},
			{dataIndex: 'EXCHANGE_RATE'			, width: 120,	hidden:true},
			//20191127 재고단위수량, 구매단위수량, 오퍼액, 환산액 합계 사용
			{dataIndex: 'SO_AMT_WON'			, width: 120, summaryType: 'sum'},
			{dataIndex: 'HS_NO'					, width: 120,
				editor: Unilite.popup('HS_G', {
					DBtextFieldName: 'HS_NO',
					autoPopup: true,
					listeners: {
						'onSelected': {
							fn: function(records, type) {
								console.log('records : ', records);
								var grdRecord = masterGrid.uniOpt.currentRecord;
								grdRecord.set('HS_NO', records[0]['HS_NO']);
								grdRecord.set('HS_NAME', records[0]['HS_NAME']);
							},
							scope: this
						},
						'onClear': function(type) {
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('HS_NO', '');
							grdRecord.set('HS_NAME', '');
						},
						applyextparam: function(popup){
							var grdRecord = masterGrid.uniOpt.currentRecord;
							popup.setExtParam({'HS_NO':grdRecord.get('HS_NO')});
						}
					}
				})
			},
			{dataIndex: 'HS_NAME'				, width: 120,
				editor: Unilite.popup('HS_G', {
					DBtextFieldName: 'HS_NAME',
					autoPopup: true,
					listeners: {
						'onSelected': {
							fn: function(records, type) {
								console.log('records : ', records);
								var grdRecord = masterGrid.uniOpt.currentRecord;
								grdRecord.set('HS_NO', records[0]['HS_NO']);
								grdRecord.set('HS_NAME', records[0]['HS_NAME']);
							},
							scope: this
						},
						'onClear': function(type) {
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('HS_NO', '');
							grdRecord.set('HS_NAME', '');
						},
						applyextparam: function(popup){
							var grdRecord = masterGrid.uniOpt.currentRecord;
							popup.setExtParam({'HS_NO':grdRecord.get('HS_NO')});
						}
					}
				})
			},
			{dataIndex: 'DELIVERY_DATE'			, width: 120},
			{dataIndex: 'MORE_PER_RATE'			, width: 120, hidden: true},
			{dataIndex: 'LESS_PER_RATE'			, width: 120, hidden: true},
			{dataIndex: 'CLOSE_FLAG'			, width: 120,	hidden:true},
			{dataIndex: 'USE_QTY'				, width: 120,	hidden:true, editable: false},
			{dataIndex: 'INSPEC_FLAG'			, width: 120},
			{dataIndex: 'ORDER_REQ_NUM'			, width: 120},
			{dataIndex: 'UPDATE_DB_USER'		, width: 120,	hidden:true},
			{dataIndex: 'UPDATE_DB_TIME'		, width: 120,	hidden:true},
			{dataIndex: 'ORDER_NUM'				, width: 120,	hidden:true},
			{dataIndex: 'ORDER_SEQ'				, width: 120,	hidden:true},
			{dataIndex: 'PROJECT_NO'			, width: 120},
			{dataIndex: 'COMP_CODE'				, width: 120,	hidden:true},
			{dataIndex: 'LOT_NO'				, width: 120,
				getEditor: function(record) {
					return getLotPopupEditor(BsaCodeInfo.gsLotNoInputMethod);
				}
			},
			{dataIndex: 'ITEM_ACCOUNT'			, width: 120,	hidden:true},
			{dataIndex: 'SAVE_FLAG'				, width: 120,	hidden:true}
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				var recordSts = "N";
				if(e.record.phantom === false){
					if(e.record.dirty === true){
						recordSts = "U"
					} else {
						recordSts = "D"
					}
				}
				if(UniUtils.indexOf(e.field, ['ITEM_CODE','ITEM_NAME'])){
					if(recordSts == 'N' && e.record.data.ORDER_REQ_NUM == ''){
						return true;
					} else {
						return false;
					}
				}
				//20191127 환산액 수정가능하도록 변경
				if(UniUtils.indexOf(e.field, ["SO_SER", "EXCHANGE_RATE"/*,"SO_AMT_WON"*/])){
					return false;
				}

				if(UniUtils.indexOf(e.field, ["TRNS_RATE"])) {
					if(e.record.data.UNIT != e.record.data.STOCK_UNIT) {
						if(panelResult.getValue('GW_FLAG') == '1' || panelResult.getValue('GW_FLAG') == '3') {
							return false;
						} else {
						return true;
						}
					}
					return false;
				}

				if(UniUtils.indexOf(e.field, ["STOCK_UNIT", "ORDER_REQ_NUM"])){
					return false;
				}
				else {
					if(panelResult.getValue('GW_FLAG') == '1' || panelResult.getValue('GW_FLAG') == '3') {
						return false;
					} else {
					return true;
					}
				}
			},
			//20191128 validator로직 여기에서 구현
			edit : function( editor, context, eOpts ) {
				if(context.originalValue != context.value) {
					var dPrice		= context.record.get('PRICE');
					var dQty		= context.record.get('ORDER_UNIT_Q');
					var dExchR		= panelResult.getValue('EXCHANGE_RATE');
					var dTrnsRate	= context.record.get('TRNS_RATE');

					switch(context.field) {
						case "QTY" :
							if(dQty <= 0){
								Unilite.messageBox('<t:message code="unilite.msg.sMB076"/>');
								break;
							}
							//20200908 추가: 20200908수정: jpy 관련로직 추가 (sMoneyUnit)
							var sMoneyUnit	= panelResult.getValue('AMT_UNIT');
							var dSoAmt		= context.record.get('QTY') * dPrice;
							var stockUnitQ	= context.record.get('QTY') * dTrnsRate;
							context.record.set('SO_AMT'			, dSoAmt);
							context.record.set('STOCK_UNIT_Q'	, stockUnitQ);
							//20200204 공통코드 t125값에 따라 절상,절사,반올림 처리, 20200908수정: jpy 관련로직 추가
							context.record.set('SO_AMT_WON'		, UniMatrl.fnAmtWonCalc(UniMatrl.fnExchangeApply(sMoneyUnit,dSoAmt) * dExchR, BsaCodeInfo.gsTradeCalcMethod, 0));
							directMasterStore1.fnAmtTotal();
						break;

						case "STOCK_UNIT_Q" :
							if(context.record.get('STOCK_UNIT_Q') <= 0){
								Unilite.messageBox('<t:message code="unilite.msg.sMB076"/>');
								break;
							}
							var dStockUnitQ		= context.record.get('STOCK_UNIT_Q');
							//20191202 수정
//							var numDigitOfPrice	= UniFormat.Price.length - UniFormat.Price.indexOf(".");
							var numDigitOfPrice	= UniFormat.Qty.length - (UniFormat.Qty.indexOf(".") == -1 ? UniFormat.Qty.length : UniFormat.Qty.indexOf(".") + 1);
							var sMoneyUnit		= panelResult.getValue('AMT_UNIT');
							dQty = dStockUnitQ / dTrnsRate;
							dQty = UniSales.fnAmtWonCalc(dQty,'1', numDigitOfPrice);//向上取整
							context.record.set('QTY', dQty);

							var dSoAmt = dQty * dPrice;

							context.record.set('SO_AMT'			, dSoAmt);
							//20200204 공통코드 t125값에 따라 절상,절사,반올림 처리
							context.record.set('SO_AMT_WON'		, UniMatrl.fnAmtWonCalc(UniMatrl.fnExchangeApply(sMoneyUnit,dSoAmt) * dExchR, BsaCodeInfo.gsTradeCalcMethod, 0));
							context.record.set('ORDER_UNIT_Q'	, dQty);
							directMasterStore1.fnAmtTotal();
						break;

						case "ORDER_UNIT_Q" :
							if(context.record.get('ORDER_UNIT_Q') <= 0){
								Unilite.messageBox('<t:message code="unilite.msg.sMB076"/>');
								break;
							}
							var dOrderUnitQ		= context.record.get('ORDER_UNIT_Q');
							//20191202 수정
//							var numDigitOfPrice	= UniFormat.Price.length - UniFormat.Price.indexOf(".");
							var numDigitOfPrice	= UniFormat.Qty.length - (UniFormat.Qty.indexOf(".") == -1 ? UniFormat.Qty.length : UniFormat.Qty.indexOf(".") + 1);
							var sMoneyUnit		= panelResult.getValue('AMT_UNIT');
							dQty = dOrderUnitQ
							dQty = UniSales.fnAmtWonCalc(dQty,'1', numDigitOfPrice);//向上取整
							context.record.set('QTY', dQty);

							var dSoAmt		= dQty * dPrice;
							var stockUnitQ	= dQty * dTrnsRate;

							context.record.set('SO_AMT'			, dSoAmt);
							//20200204 공통코드 t125값에 따라 절상,절사,반올림 처리
							context.record.set('SO_AMT_WON'		, UniMatrl.fnAmtWonCalc(UniMatrl.fnExchangeApply(sMoneyUnit,dSoAmt) * dExchR, BsaCodeInfo.gsTradeCalcMethod, 0)); //20191129 소숫점 반올림
							context.record.set('STOCK_UNIT_Q'	, stockUnitQ);
							directMasterStore1.fnAmtTotal();
						break;

						case "TRNS_RATE" :
							if(context.record.get('TRNS_RATE') <= 0){
								Unilite.messageBox('<t:message code="unilite.msg.sMB076"/>');
								break;
							}
							dTrnsRate = context.record.get('TRNS_RATE');
							context.record.set('STOCK_UNIT_Q', dQty * dTrnsRate);
							directMasterStore1.fnAmtTotal();
						break;

						case "PRICE" :
							var dSoAmt		= dQty * dPrice;
							var sMoneyUnit	= panelResult.getValue('AMT_UNIT');
							context.record.set('SO_AMT'		, dSoAmt);
							//20200204 공통코드 t125값에 따라 절상,절사,반올림 처리
							context.record.set('SO_AMT_WON'	, UniMatrl.fnAmtWonCalc(UniMatrl.fnExchangeApply(sMoneyUnit,dSoAmt) * dExchR, BsaCodeInfo.gsTradeCalcMethod, 0)); //20191129 소숫점 반올림
							directMasterStore1.fnAmtTotal();
						break;

						case "SO_AMT" :
							if(context.record.get('SO_AMT') <= 0){
								Unilite.messageBox('<t:message code="unilite.msg.sMB076"/>');
								break;
							}
							//20191202 UnitPrice 포맷 적용해서 단가 계산하도록 수정
							var numDigitOfPrice	= UniFormat.UnitPrice.length - (UniFormat.UnitPrice.indexOf(".") == -1 ? UniFormat.UnitPrice.length : UniFormat.UnitPrice.indexOf(".") + 1);
							var dSoAmt			= context.record.get('SO_AMT');
							var sMoneyUnit		= panelResult.getValue('AMT_UNIT');
							context.record.set('PRICE'		, UniMatrl.fnAmtWonCalc(dSoAmt / dQty, 3, numDigitOfPrice));
							//20200204 공통코드 t125값에 따라 절상,절사,반올림 처리
							context.record.set('SO_AMT_WON'	, UniMatrl.fnAmtWonCalc(UniMatrl.fnExchangeApply(sMoneyUnit,dSoAmt) * dExchR, BsaCodeInfo.gsTradeCalcMethod, 0)); //20191129 소숫점 반올림
							//20191127 계산로직 수정
							directMasterStore1.fnAmtTotal();
//							var sumAmt = panelSearch.getValue('SO_AMT') + newValue - oldValue;
//							panelSearch.setValue('SO_AMT', sumAmt);
//							panelResult.setValue('SO_AMT', sumAmt);
//							var results = directMasterStore1.sumBy(function(record, id){
//								return true;},
//							['SO_AMT_WON']);
//							panelSearch.setValue('SO_AMT_WON'	, results.SO_AMT_WON);
//							panelResult.setValue('SO_AMT_WON'	, results.SO_AMT_WON);
//							gsCalFlag = false;
						break;
						case "SO_AMT_WON" :
							if(context.record.get('SO_AMT_WON') <= 0){
								rv = '<t:message code="unilite.msg.sMB076"/>';
								break;
							}
							var results = directMasterStore1.sumBy(function(record, id){
								return true;},
							['SO_AMT_WON']);
							panelSearch.setValue('SO_AMT_WON'	, results.SO_AMT_WON);
							panelResult.setValue('SO_AMT_WON'	, results.SO_AMT_WON);
						break;
					}
				}
			}
		},
		setItemData: function(record, dataClear, grdRecord) {
			if(dataClear) {
				grdRecord.set('ITEM_CODE'		,'');
				grdRecord.set('ITEM_NAME'		, '');
				grdRecord.set('SPEC'			, '');
				grdRecord.set('HS_NO'			, '');
				grdRecord.set('HS_NAME'			, '');
				grdRecord.set('ITEM_ACCOUNT'	, '');
			} else {
				grdRecord.set('ITEM_CODE'		, record['ITEM_CODE']);
				grdRecord.set('ITEM_NAME'		, record['ITEM_NAME']);
				grdRecord.set('SPEC'			, record['SPEC']);
				grdRecord.set('HS_NO'			, record['HS_NO']);
				grdRecord.set('HS_NAME'			, record['HS_NAME']);
				grdRecord.set('ITEM_ACCOUNT'	, record['ITEM_ACCOUNT']);
				fnGetPrice(record,grdRecord);
				fnGetInspec(record,grdRecord);
			}
		}
	});
	//20191127 주석 추가
	<%@include file="tio100pkrv.jsp" %>		//조회팝업
	<%@include file="tio100ukrs3.jsp" %>	//발주참조
	<%@include file="tio100ukrs2.jsp" %>	//타오퍼참조
	<%@include file="tio100ukrs4.jsp" %>	//엑셀참조



	Unilite.Main({
		id			: 'tio100ukrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				masterGrid, panelResult
			]
		}/*, panelSearch*/
		],
		fnInitBinding: function(params) {
			UniAppManager.app.fnInitInputFields();
			UniAppManager.app.fnSetButton(false);
			//20191204 순서 변경
			UniAppManager.app.fnExchngRateO(true);
			UniAppManager.app.fnGetCompany();
			gsDel = '';
			//20191204 순서 변경
//			UniAppManager.app.fnExchngRateO(true);

			//20191204 만들다 만 로직 주석
/*			if(BsaCodeInfo.gsOrderConfirm == "2"){  //발주 자동승인
				panelResult.setValue('');
				panelResult.setValue('');
				panelResult.setValue('');
			}*/
			Ext.getCmp('ChargeInput').setDisabled(true);
			Ext.getCmp('ChargeInput1').setDisabled(true);
		},
		fnExchngRateO:function(isIni) {
			var param = {
				"AC_DATE"	: UniDate.getDbDateStr(panelSearch.getValue('DATE_DEPART')),
				"MONEY_UNIT": panelSearch.getValue('AMT_UNIT')
			};
			salesCommonService.fnExchgRateO(param, function(provider, response) {
				if(!Ext.isEmpty(provider)){
					if(provider.BASE_EXCHG == "1" && !isIni  && !Ext.isEmpty(panelSearch.getValue('AMT_UNIT')) && panelSearch.getValue('AMT_UNIT') != "KRW"){
						alert('<t:message code="system.label.trade.exchangerate" default="환율"/>정보가 없습니다.');
					}
					panelSearch.setValue('EXCHANGE_RATE', provider.BASE_EXCHG);
					panelResult.setValue('EXCHANGE_RATE', provider.BASE_EXCHG);
					//20191127 로직 추가
					directMasterStore1.fnRecordSum(provider.BASE_EXCHG);
				}
			});
		},
		fnInitInputFields: function(){
			panelSearch.setValue('DIV_CODE'		, UserInfo.divCode);
			panelResult.setValue('DIV_CODE'		, UserInfo.divCode);

			panelSearch.setValue('DATE_DEPART'	, UniDate.get('today'));
			panelResult.setValue('DATE_DEPART'	, UniDate.get('today'));

			panelSearch.setValue('DATE_CONTRACT', UniDate.get('today'));
			panelResult.setValue('DATE_CONTRACT', UniDate.get('today'));

			panelSearch.setValue('DATE_DELIVERY', UniDate.get('today'));
			panelResult.setValue('DATE_DELIVERY', UniDate.get('today'));

			panelSearch.setValue('SO_AMT'		, "0");
			panelResult.setValue('SO_AMT'		, "0");

			panelSearch.setValue('EXCHANGE_RATE', "0");
			panelResult.setValue('EXCHANGE_RATE', "0");

			panelSearch.setValue('SO_AMT_WON'	, "0");
			panelResult.setValue('SO_AMT_WON'	, "0");

			panelSearch.setValue('TRADE_TYPE'	, '1');
			panelResult.setValue('TRADE_TYPE'	, '1');

			//20191202 구매담당에 로그인 유저 id의 구매담당 입력하도록 수정
			panelSearch.setValue('IMPORT_NM'	, BsaCodeInfo.importPrsn);
			panelResult.setValue('IMPORT_NM'	, BsaCodeInfo.importPrsn);
			//20191127 승인자에 로그인 유저 id 입력하도록 수정
			panelSearch.setValue('USER_ID'		, UserInfo.userID);
			panelResult.setValue('USER_ID'		, UserInfo.userID);
			panelSearch.setValue('AGREE_PRSN'	, UserInfo.userName);
			panelResult.setValue('AGREE_PRSN'	, UserInfo.userName);

			gbRetrieved = false;
		},
		fnGetCompany: function(){
			var param = {};
			tio100ukrvService.fnGetCompany(param, function(provider, response) {
				if(!Ext.isEmpty(provider)){
					panelSearch.setValue('IMPORTER'		, provider['CUSTOM_CODE']);
					panelSearch.setValue('IMPORTER_NM'	, provider['CUSTOM_FULL_NAME']);
					panelResult.setValue('IMPORTER'		, provider['CUSTOM_CODE']);
					panelResult.setValue('IMPORTER_NM'	, provider['CUSTOM_FULL_NAME']);
				} else {
					panelSearch.setValue('IMPORTER'		, '');
					panelSearch.setValue('IMPORTER_NM'	, '');
					panelResult.setValue('IMPORTER'		, '');
					panelResult.setValue('IMPORTER_NM'	, '');
				}
				//20191202 초기화버튼로직 수정
				panelResult.getForm().wasDirty = false;
				panelResult.resetDirtyStatus();
				panelSearch.getForm().wasDirty = false;
				panelSearch.resetDirtyStatus();
				UniAppManager.setToolbarButtons(['newData','reset'], true);
				UniAppManager.setToolbarButtons('save', false);
			});
		},
		fnSetButton: function(bStatus){
			panelSearch.getField("DIV_CODE").setReadOnly(bStatus);
			panelResult.getField("DIV_CODE").setReadOnly(bStatus);

			panelSearch.getField("EXPORTER").setReadOnly(bStatus);
			panelResult.getField("EXPORTER").setReadOnly(bStatus);
			panelSearch.getField("EXPORTER_NM").setReadOnly(bStatus);
			panelResult.getField("EXPORTER_NM").setReadOnly(bStatus);

			panelSearch.getField("AMT_UNIT").setReadOnly(bStatus);
			panelResult.getField("AMT_UNIT").setReadOnly(bStatus);

			panelSearch.getField("AGREE_PRSN").setReadOnly(bStatus);
			panelResult.getField("AGREE_PRSN").setReadOnly(bStatus);
			if(!bStatus) {
				panelSearch.setValue("PAY_METHODE"	, 'T/T');
				panelSearch.setValue("PAY_TERMS"	, '8');
				panelResult.setValue("PAY_METHODE"	, 'T/T');
				panelResult.setValue("PAY_TERMS"	, '8');
			}
		},
		onQueryButtonDown: function() {
			isLoad	= true;
			isLoad2	= true;
			if(Ext.isEmpty(panelResult.getValue('SO_SER_NO')) ){
				gsQueryFlag = false;
				openSearchInfoWindow();
			} else {
				var param = panelResult.getValues();
				panelResult.uniOpt.inLoading = true;
				Ext.getBody().mask('로딩중...','loading-indicator');
				gsQueryFlag = false;
				panelResult.getForm().load({
					params	: param,
					success	: function(form, action) {
						console.log(action.result.data);
						if(action.result.data){
							gImportType = action.result.data.IMPORT_TYPE;
							gNationInout = action.result.data.NATION_INOUT;
							Ext.getCmp('ChargeInput').setDisabled(false);
							Ext.getCmp('ChargeInput1').setDisabled(false);
							panelSearch.setValues({
								'EXPORTER'			: panelResult.getValue('EXPORTER'),
								'EXPORTER_NM'		: panelResult.getValue('EXPORTER_NM'),
								'AGREE_PRSN'		: panelResult.getValue('AGREE_PRSN'),
								'AGREE_PRSN'		: panelResult.getValue('AGREE_PRSN'),
								'AGENTQ'			: panelResult.getValue('AGENTQ'),
//								'AGENT_NMQ'			: panelResult.getValue('AGENT_NMQ'),
								'IMPORTER'			: panelResult.getValue('IMPORTER'),
								'IMPORTER_NM'		: panelResult.getValue('IMPORTER_NM'),
								'AGENT'				: panelResult.getValue('AGENT'),
								'AGENT_NM'			: panelResult.getValue('AGENT_NM'),
								'BANK_SENDING'		: panelResult.getValue('BANK_SENDING'),
								'BANK_SENDING_NM'	: panelResult.getValue('BANK_SENDING_NM')
							});
							panelResult.setAllFieldsReadOnly(true);
							UniAppManager.app.fnSetButton(true);
							masterGrid.getStore().loadStoreRecords();
						} else {
							gNationInout	= '';
							gImportType		= '';
							UniAppManager.app.fnSetButton(false);
						}
						Ext.getBody().unmask();
						panelResult.uniOpt.inLoading = false;
					},
					failure:function(batch, option){
						Ext.getBody().unmask();
						panelResult.uniOpt.inLoading = false;
					}
				});
			}
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			panelSearch.setAllFieldsReadOnly(false);
			//20191129 수정
//			masterGrid.reset();
			masterGrid.getStore().loadData({});
			panelResult.setAllFieldsReadOnly(false);
			this.fnInitBinding();
			this.fnClearData();
		},
		fnClearData: function() {
			gImportType		= "";
			gNationInout	= "";
			this.fnSetButton(false);
			Ext.getCmp('ChargeInput').setDisabled(true);
			Ext.getCmp('ChargeInput1').setDisabled(true);
		},
		checkForNewDetail:function() {
			if(panelResult.setAllFieldsReadOnly(true)){
				panelSearch.setAllFieldsReadOnly(true);
				return true;
			}
			return false;
		},
		onNewDataButtonDown: function() {
			if(!fnEssCheck()) return false;
			if(!this.checkForNewDetail()) return false;
			gsDel		= '';
			gbRetrieved	= false;
			var seq = directMasterStore1.max('SO_SER');
			if(!seq) seq = 1;
			else  seq += 1;

			var r = {
				'SO_SER'		: seq,
				'DIV_CODE'		: panelResult.getValue('DIV_CODE'),
				'SO_SER_NO'		: panelResult.getValue('SO_SER_NO'),
				'EXCHANGE_RATE'	: panelResult.getValue('EXCHANGE_RATE'),
//				'MORE_PER_RATE'	: "5",
//				'LESS_PER_RATE'	: "5",
				'CLOSE_FLAG'	: "N",
				'DELIVERY_DATE'	: UniDate.get('today'),
				'USE_QTY'		: "0",
				'QTY'			: "0",
				'STOCK_UNIT_Q'	: "0",
				'PRICE'			: "0",
				'SO_AMT'		: "0",
				'SO_AMT_WON'	: "0",
				'UPDATE_DB_USER': UserInfo.userID,
				'UPDATE_DB_TIME': UniDate.get('today'),
				'COMP_CODE'		: UserInfo.compCode
			};

			var param = panelResult.getValues();
			if(!Ext.isEmpty(param.SO_SER_NO)) {
				tio100ukrvService.selectGwData(param, function(provider, response) {
					if(Ext.isEmpty(provider[0]) || provider[0].GW_FLAG != '1' || provider[0].GW_FLAG != '3') {
						masterGrid.createRow(r);
						UniAppManager.setToolbarButtons('reset', true);
					} else {
						alert('이미 기안된 자료입니다.');
						return false;
					}
				});
			} else {
				masterGrid.createRow(r);
				UniAppManager.setToolbarButtons('reset', true);
			}
		},
		onNewDataButtonDownNoFormValidate: function(record) {
			gsDel		= '';
			gbRetrieved	= false;

			var param = panelResult.getValues();
			if(!Ext.isEmpty(param.SO_SER_NO)) {
//				tio100ukrvService.selectGwData(param, function(provider, response) {
//					if(Ext.isEmpty(provider[0]) || provider[0].GW_FLAG != '1' || provider[0].GW_FLAG != '3') {
						//20200304 수정: 데이터 set하는 위치 수정
						var seq = directMasterStore1.max('SO_SER');
						if(!seq) seq = 1;
						else  seq += 1;
						var r = {
							'SO_SER'		: seq,
							'DIV_CODE'		: panelResult.getValue('DIV_CODE'),
							'SO_SER_NO'		: panelResult.getValue('SO_SER_NO'),
							'EXCHANGE_RATE'	: panelResult.getValue('EXCHANGE_RATE'),
			//				'MORE_PER_RATE'	: "5",
			//				'LESS_PER_RATE'	: "5",
							'CLOSE_FLAG'	: "N",
							'DELIVERY_DATE'	: UniDate.get('today'),
							'USE_QTY'		: "0",
							'QTY'			: "0",
							'STOCK_UNIT_Q'	: "0",
							'PRICE'			: "0",
							'SO_AMT'		: "0",
							'SO_AMT_WON'	: "0",
							'UPDATE_DB_USER': UserInfo.userID,
							'UPDATE_DB_TIME': UniDate.get('today'),
							'COMP_CODE'		: UserInfo.compCode
						};
						masterGrid.createRow(r);
						//20200304 수정: 데이터 set하는 위치 수정
						record['SO_SER_NO'] = panelResult.getValue('SO_SER_NO');
						masterGrid.setRefData(record);
						directMasterStore1.fnAmtTotal();
						UniAppManager.setToolbarButtons('reset', true);
//					} else {
//						alert('이미 기안된 자료입니다.');
//						return false;
//					}
//				});
			} else {
				//20200304 수정: 데이터 set하는 위치 수정
				var seq = directMasterStore1.max('SO_SER');
				if(!seq) seq = 1;
				else  seq += 1;
	
				var r = {
					'SO_SER'		: seq,
					'DIV_CODE'		: panelResult.getValue('DIV_CODE'),
					'SO_SER_NO'		: panelResult.getValue('SO_SER_NO'),
					'EXCHANGE_RATE'	: panelResult.getValue('EXCHANGE_RATE'),
	//				'MORE_PER_RATE'	: "5",
	//				'LESS_PER_RATE'	: "5",
					'CLOSE_FLAG'	: "N",
					'DELIVERY_DATE'	: UniDate.get('today'),
					'USE_QTY'		: "0",
					'QTY'			: "0",
					'STOCK_UNIT_Q'	: "0",
					'PRICE'			: "0",
					'SO_AMT'		: "0",
					'SO_AMT_WON'	: "0",
					'UPDATE_DB_USER': UserInfo.userID,
					'UPDATE_DB_TIME': UniDate.get('today'),
					'COMP_CODE'		: UserInfo.compCode
				};
				masterGrid.createRow(r);
				//20200304 수정: 데이터 set하는 위치 수정
				record['SO_SER_NO'] = panelResult.getValue('SO_SER_NO');
				masterGrid.setRefData(record);
				directMasterStore1.fnAmtTotal();
				UniAppManager.setToolbarButtons('reset', true);
			}
		},
		onSaveDataButtonDown: function(config) {
			if(!panelSearch.getInvalidMessage()) return;
			if(!panelResult.getInvalidMessage()) return;

			if(BsaCodeInfo.gsOrderConfirm == "2"){  // 발주 자동승인
				panelResult.setValue('AGREE_STATUS', '2');
				panelResult.setValue('AGREE_DATE', UniDate.getDbDateStr(panelResult.getValue('DATE_DEPART')));
			}
			directMasterStore1.saveStore();
		},
		onDeleteDataButtonDown: function() {  // 행삭제 버튼
			var param = panelResult.getValues();
			if(!Ext.isEmpty(param.ORDER_NUM)) {
				btr101ukrvService.selectGwData(param, function(provider, response) {
					if(Ext.isEmpty(provider[0]) || provider[0].GW_FLAG != '1' || provider[0].GW_FLAG != '3') {
						var selRow = masterGrid.getSelectedRecord();
						if(selRow.phantom === true) {
							masterGrid.deleteSelectedRow();
						} else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
							if(selRow.get('CLOSE_FLAG') == 'Y'){
								Ext.Msg.alert('<t:message code="unilite.msg.sMB099"/>','이루 프로셰스가 진형중입니 다， 수정 및 삭제 울가능힘니다');
							} else {
								if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
										masterGrid.deleteSelectedRow();
								}
							}
						}
					} else {
						alert('기안된 데이터는 삭제가 불가능합니다.');
						return false;
					}
				});
			} else {
				var selRow = masterGrid.getSelectedRecord();
				if(selRow.phantom === true) {
					masterGrid.deleteSelectedRow();
				} else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
					masterGrid.deleteSelectedRow();
				}
			}
			if(Ext.isEmpty(directMasterStore1.data.items)){
				gsDel = "Y";
			}
		},
		onDeleteAllButtonDown: function() {
			var records = directMasterStore1.data.items;
			var isNewData = false;
			Ext.each(records, function(record,i) {
				if(record.phantom){					//신규 레코드일시 isNewData에 true를 반환
					isNewData = true;
				} else {								//신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
					isNewData = false;
					if(confirm('전체삭제 하시겠습니까?')) {
						var deletable = true;
						/*---------삭제전 로직 구현 시작----------*/

						/*---------삭제전 로직 구현 끝----------*/

						if(deletable){
							masterGrid.reset();
							UniAppManager.app.onSaveDataButtonDown();
						}
					}
					return false;
				}
			});
			if(isNewData){							//신규 레코드들만 있을시 그리드 리셋
				masterGrid.reset();
				UniAppManager.app.onResetButtonDown();  //삭제후 RESET..
			}
		}
	});



	Unilite.createValidator('validator01', {
		store: directMasterStore1,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			var rv = true;
			var dPrice		= record.get('PRICE');
			var dQty		= record.get('ORDER_UNIT_Q');
			var dExchR		= panelResult.getValue('EXCHANGE_RATE');
			var dTrnsRate	= record.get('TRNS_RATE');
			switch(fieldName) {
				case "UNIT" :
					//fnGetPrice(null,record,callbackUnit(),newValue,fieldName); 修改為同步
					break;
				//20191128 주석 - grid editor에서 처리
//				case "QTY" :
//					if(newValue <= 0){
//						rv = '<t:message code="unilite.msg.sMB076"/>';
//						break;
//					}
//					var dSoAmt = newValue * dPrice;
//					var stockUnitQ = newValue * dTrnsRate;
//					record.set('SO_AMT', dSoAmt);
//					record.set('STOCK_UNIT_Q',stockUnitQ);
//					record.set('SO_AMT_WON',dSoAmt * dExchR);
//
//					directMasterStore1.fnAmtTotal();
//				break;
//				case "STOCK_UNIT_Q" :
//					if(newValue <= 0){
//						rv = '<t:message code="unilite.msg.sMB076"/>';
//						break;
//					}
//					var dStockUnitQ = newValue;
//					var numDigitOfPrice = UniFormat.Price.length - UniFormat.Price.indexOf(".");
//					var sMoneyUnit = panelResult.getValue('AMT_UNIT');
//					dQty = dStockUnitQ / dTrnsRate;
//					dQty = UniSales.fnAmtWonCalc(dQty,'1', numDigitOfPrice);//向上取整
//					record.set('QTY', dQty);
//
//					var dSoAmt = dQty * dPrice;
//					var stockUnitQ = dQty * dTrnsRate;
//
//					record.set('SO_AMT', dSoAmt);
//					record.set('SO_AMT_WON',UniSales.fnAmtWonCalc(UniMatrl.fnExchangeApply(sMoneyUnit,dSoAmt) * dExchR, 3, 2));
//					record.set('ORDER_UNIT_Q', stockUnitQ);
//					directMasterStore1.fnAmtTotal();
//				break;
//				case "ORDER_UNIT_Q" :
//					if(newValue <= 0){
//						rv = '<t:message code="unilite.msg.sMB076"/>';
//						break;
//					}
//					var dStockUnitQ = newValue;
//					var numDigitOfPrice = UniFormat.Price.length - UniFormat.Price.indexOf(".");
//					var sMoneyUnit = panelResult.getValue('AMT_UNIT');
//					dQty = dStockUnitQ / dTrnsRate;
//					dQty = UniSales.fnAmtWonCalc(dQty,'1', numDigitOfPrice);//向上取整
//					record.set('QTY', dQty);
//
//					var dSoAmt = dQty * dPrice;
//					var stockUnitQ = dQty * dTrnsRate;
//
//					record.set('SO_AMT', dSoAmt);
//					record.set('SO_AMT_WON',UniSales.fnAmtWonCalc(UniMatrl.fnExchangeApply(sMoneyUnit,dSoAmt) * dExchR, 3, 2)); //20191127 소숫점 3째자리에서 반올림해서 등록
//					record.set('STOCK_UNIT_Q', dStockUnitQ);
//
//					directMasterStore1.fnAmtTotal();
//				break;
//				case "TRNS_RATE" :
//					if(newValue <= 0){
//						rv = '<t:message code="unilite.msg.sMB076"/>';
//						break;
//					}
//					dTrnsRate = newValue;
//					record.set('STOCK_UNIT_Q', dQty * dTrnsRate);
//					directMasterStore1.fnAmtTotal();
//				break;
//
//				case "PRICE" :
//					dPrice = newValue;
//					var dSoAmt = dQty * dPrice;
//					var sMoneyUnit = panelResult.getValue('AMT_UNIT');
//					record.set('SO_AMT', dSoAmt);
//					record.set('SO_AMT_WON',UniSales.fnAmtWonCalc(UniMatrl.fnExchangeApply(sMoneyUnit,dSoAmt) * dExchR, 3, 2)); //20191127 소숫점 3째자리에서 반올림해서 등록
//					directMasterStore1.fnAmtTotal();
//				break;
//				case "SO_AMT" :
//					if(newValue <= 0){
//						rv = '<t:message code="unilite.msg.sMB076"/>';
//						break;
//					}
//
//					var dSoAmt = newValue;
//					var sMoneyUnit = panelResult.getValue('AMT_UNIT');
//					record.set('PRICE',dSoAmt / dQty);
//					record.set('SO_AMT_WON',UniSales.fnAmtWonCalc(UniMatrl.fnExchangeApply(sMoneyUnit,dSoAmt) * dExchR, 3, 2)); //20191127 소숫점 3째자리에서 반올림해서 등록
//					//20191127 계산로직 수정
////					directMasterStore1.fnAmtTotal();
//					var sumAmt = panelSearch.getValue('SO_AMT') + newValue - oldValue;
//					panelSearch.setValue('SO_AMT', sumAmt);
//					panelResult.setValue('SO_AMT', sumAmt);
//					var results = directMasterStore1.sumBy(function(record, id){
//						return true;},
//					['SO_AMT_WON']);
//					panelSearch.setValue('SO_AMT_WON'	, results.SO_AMT_WON);
//					panelResult.setValue('SO_AMT_WON'	, results.SO_AMT_WON);
//					gsCalFlag = false;
//				break;
				case "MORE_PER_RATE" :
					if(newValue <= 0){
						rv = '<t:message code="unilite.msg.sMB076"/>';
						break;
					}
				break;
				case "LESS_PER_RATE" :
					if(newValue <= 0){
						rv = '<t:message code="unilite.msg.sMB076"/>';
						break;
					}
				break;
				case "USE_QTY" :
					if(newValue <= 0){
						rv = '<t:message code="unilite.msg.sMB076"/>';
						break;
					}
				break;
				case "DELIVERY_DATE" :

				break;
				case "TRNS_RATE" :
					if(newValue <= 0){
						rv = '<t:message code="unilite.msg.sMB076"/>';
						break;
					}
				break;
				case "INSPEC_FLAG" :

				break;
			}
			return rv;
		}
	});

	//20191204 필요없는 로직 주석
/*	function callbackUnit(){
		var record = masterGrid.getSelectedRecord();
		var dPrice = record.get('QTY');
		var dQty = record.get('PRICE');
		var dExchR = record.get('EXCHANGE_RATE');
		var dSoAmt = dPrice * dQty;
		record.set('SO_AMT',dSoAmt);
		record.set('SO_AMT_WON',UniMatrl.fnAmtWonCalc(dSoAmt * dExchR, '3', 0));
		directMasterStore1.fnAmtTotal();
	}*/

	function fnGetPrice(record,grdRecord,callback,newValue,type){
		var sItemCode = grdRecord.get('ITEM_CODE');
		var sOrderUnit = grdRecord.get('UNIT');
		if(record){
			sItemCode = record['ITEM_CODE'];
			sOrderUnit = record['UNIT'];
		}

		var sCustomCode = panelResult.getValue('EXPORTER');
		var sMoneyUnit = panelResult.getValue('AMT_UNIT');
		var sOrderDate = panelResult.getValue('DATE_CONTRACT');
		if(type == 'UNIT'){
			sOrderUnit = newValue;
		}
		if(Ext.isEmpty(sItemCode)){
			return;
		}
		var param = {
			'ITEM_CODE' : sItemCode,
			'CUSTOM_CODE' :sCustomCode,
			'MONEY_UNIT' : sMoneyUnit,
			'ORDER_UNIT' : sOrderUnit,
			'ORDER_DATE' : sOrderDate
		};
		tio100ukrvService.fnGetPrice(param, function(provider, response) {
				if(!Ext.isEmpty(provider)){
					if(!Ext.isEmpty(provider['ORDER_P'])){
						grdRecord.set('PRICE',provider['ORDER_P']);
					} else {
						grdRecord.set('PRICE',0);
					}
					if(!Ext.isEmpty(provider['TRNS_RATE']) && provider['TRNS_RATE'] > 0){
						grdRecord.set('TRNS_RATE',provider['TRNS_RATE']);
					} else {
						grdRecord.set('TRNS_RATE',1);
					}
					grdRecord.set('UNIT',provider['ORDER_UNIT']);
					grdRecord.set('STOCK_UNIT',provider['STOCK_UNIT']);
					grdRecord.set('SO_AMT',grdRecord.get('PRICE') * grdRecord.get('QTY'));

					if(typeof(callback) == 'function'){
						callback();
					}
				}
			}
		);
	}

	function fnGetInspec(record,grdRecord){
		var sItemCode = record['ITEM_CODE'];
		if(Ext.isEmpty(sItemCode)){
			return;
		}
		var param = {
			'ITEM_CODE' : sItemCode
		};
		tio100ukrvService.fnGetInspec(param, function(provider, response) {
			if(!Ext.isEmpty(provider)){
				grdRecord.set('INSPEC_FLAG',provider['INSPEC_YN']);
			}
		});
	}

	function fnGetAgreePrsn(param){
		tio100ukrvService.fnGetAgreePrsn(param, function(provider, response) {
			if(!Ext.isEmpty(provider)){
				panelResult.setValue('AGREE_PRSN', provider['USER_ID']);
				panelSearch.setValue('AGREE_PRSN', provider['USER_ID']);
				panelResult.setValue('AGREE_PRSN', provider['USER_NAME']);
				panelSearch.setValue('AGREE_PRSN', provider['USER_NAME']);
			}
		});
	}

	function fnEssCheck(){
		var dateContract = panelResult.getValue('DATE_CONTRACT');
		var dateDelivery =  panelResult.getValue('DATE_DELIVERY');
		var dateDepart =  panelResult.getValue('DATE_DEPART');
		var dateExp  = panelResult.getValue('DATE_EXP');
		if(dateContract > dateDelivery){
			Ext.Msg.alert('예상납기일은 계약일 이후 날짜이어야 합니다.');
			return false;
		}
		if(dateDepart > dateDelivery){
			Ext.Msg.alert('예상납기일은 작성일 이후 날짜이어야 합니다.');
			return false;
		}
		if(!Ext.isEmpty(dateExp)){
			if(dateContract > dateExp){
				Ext.Msg.alert('유효일은 계약일 이후 날짜이어야 합니다.');
				return false;
			}

			if(dateDepart > dateExp){
				Ext.Msg.alert('유효일은 작성일 이후 날짜이어야 합니다.');
				return false;
			}
		}

		if(BsaCodeInfo.gsAutoNumber == "N"){
			if(Ext.isEmpty(panelResult.getValue('SO_SER_NO'))){
				Ext.Msg.alert('<t:message code="unilite.msg.sMB099"/>','<t:message code="unilite.msg.sMT127"/>'+'<t:message code="unilite.msg.sMT037"/>');
				return false;
			}
		}
		var er = panelResult.getValue('EXCHANGE_RATE');
		if(!Ext.isEmpty(er)){
			var soAmt = panelResult.getValue('SO_AMT');
			//20200204 공통코드 t125값에 따라 절상,절사,반올림 처리
			panelResult.setValue('SO_AMT_WON',UniMatrl.fnAmtWonCalc(soAmt * er, BsaCodeInfo.gsTradeCalcMethod, 0));
			panelSearch.setValue('SO_AMT_WON',UniMatrl.fnAmtWonCalc(soAmt * er, BsaCodeInfo.gsTradeCalcMethod, 0));
		}
		if(!Ext.isEmpty(panelResult.getValue('DEST_PORT')) || !Ext.isEmpty(panelResult.getValue('SHIP_PORT'))) {
			if(panelResult.getValue('DEST_PORT') == panelResult.getValue('SHIP_PORT')){
				alert('선적항, 도착항은 동일할 수 없습니다.');
				return false;
			}
		}
		return true;
//		var strPayMethode1 = panelResult.getValue('PAY_METHODE'); //PAY_METHODE 修改切換的時候
//		if(strPayMethode1 != "LLC" &&　strPayMethode1 !=　"ETC"){
//			if(Ext.isEmpty(panelResult.getValue('DEST_PORT')){
//				Ext.Msg.alert('<t:message code="unilite.msg.sMB099"/>','<t:message code="unilite.msg.sMT175"/>'+'<t:message code="unilite.msg.sMT037"/>');
//				return false;
//			}
//			if(Ext.isEmpty(panelResult.getValue('SHIP_PORT')){
//				Ext.Msg.alert('<t:message code="unilite.msg.sMB099"/>','<t:message code="unilite.msg.sMT161"/>'+'<t:message code="unilite.msg.sMT037"/>');
//				return false;
//			}
//		}
	}

	function openExcelValidate(){
		var rv = true;
		if(Ext.isEmpty(panelResult.getValue('EXPORTER'))){
			Ext.Msg.alert('<t:message code="unilite.msg.sMB099" default="확인"/>','거래처를 입력하십시요.');
			panelResult.getField('EXPORTER').focus();
			rv = false;
		}
		if(Ext.isEmpty(panelResult.getValue('DATE_CONTRACT'))){
			Ext.Msg.alert('<t:message code="unilite.msg.sMB099" default="확인"/>','제약일을(를) 입력하십시요.');
			panelResult.getField('DATE_CONTRACT').focus();
			rv = false;
		}
		if(Ext.isEmpty(panelResult.getValue('DATE_DELIVERY'))){
			Ext.Msg.alert('<t:message code="unilite.msg.sMB099" default="확인"/>','예상남기일을 잉력하십시요.');
			panelResult.getField('DATE_DELIVERY').focus();
			rv = false;
		}
		if(Ext.isEmpty(panelResult.getValue('AMT_UNIT'))){
			Ext.Msg.alert('<t:message code="unilite.msg.sMB099" default="확인"/>','화폐단위를 입력하십시요.');
			panelResult.getField('AMT_UNIT').focus();
			rv = false;
		}
		if(Ext.isEmpty(panelResult.getValue('EXCHANGE_RATE')) || panelResult.getValue('EXCHANGE_RATE')==0){
			Ext.Msg.alert('<t:message code="unilite.msg.sMB099" default="확인"/>','할률을 입력하십시요.');
			panelResult.getField('EXCHANGE_RATE').focus();
			rv = false;
		}
		return rv;
	}
};
</script>