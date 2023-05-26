<%--
'   프로그램명 : 생산계획등록(작업장별) (생산)
'
'   작  성  자 : (주)포렌 개발실
'   작  성  일 : 20180514
'
'   최종수정자 :
'   최종수정일 :
'
'   버	  전 : OMEGA Plus V6.0.0
--%>

<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_ppl100ukrv_jw"  >
	<t:ExtComboStore comboType="BOR120" pgmId="s_ppl100ukrv_jw"/> 				<!-- 사업장 -->
	<t:ExtComboStore comboType="WU" />											<!-- 작업장  -->
	<t:ExtComboStore comboType="AU" comboCode="P402" />							<!-- 참조유형 -->
	<t:ExtComboStore comboType="AU" comboCode="S002" />							<!-- 매출구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B020" />							<!-- 품목계정 -->
	<t:ExtComboStore items="${COMBO_WS_LIST}" storeId="wsList" />				<!-- 작업장 -->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />	<!-- 대분류 -->
 	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />	<!-- 중분류 -->
 	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />	<!-- 소분류 -->
	<t:ExtComboStore comboType="WU" />											<!-- 작업장-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
.x-change-cell3 {background-color: #fcfac5;}
</style>
<script type="text/javascript" >

var referOrderInformationWindow;		//수주정보참조
var referSalesPlanWindow;				//판매계획참조
var outDivCode = UserInfo.divCode;

var BsaCodeInfo = {
	gsManageTimeYN:'${gsManageTimeYN}'
};

var isAutoTime = false;
if(BsaCodeInfo.gsAutoType=='Y')	{
	isAutoTime = true;
}


function appMain() {

	var mrpYnStore = Unilite.createStore('s_ppl100ukrv_jwMRPYnStore', {
		fields	: ['text', 'value'],
		data	:  [
			{'text':'<t:message code="system.label.product.yes" default="예"/>'	, 'value':'Y'},
			{'text':'<t:message code="system.label.product.no" default="아니오"/>'	, 'value':'N'}
		]
	});

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_ppl100ukrv_jwService.selectDetailList',
			update	: 's_ppl100ukrv_jwService.updateDetail',
			create	: 's_ppl100ukrv_jwService.insertDetail',
			destroy	: 's_ppl100ukrv_jwService.deleteDetail',
			syncAll	: 's_ppl100ukrv_jwService.saveAll'
		}
	});

	/* 수주정보 참조 */
	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'ppl111ukrvService.selectEstiList',
			update	: 'ppl111ukrvService.updateEstiDetail',
			create	: 'ppl111ukrvService.insertEstiDetail',
			destroy	: 'ppl111ukrvService.deleteEstiDetail',
			syncAll	: 'ppl111ukrvService.saveRefAll'
		}
	});

	/* 생산계획 참조*/
	var directProxy3 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'ppl111ukrvService.selectRefList',
			update	: 'ppl111ukrvService.updateRefDetail',
			create	: 'ppl111ukrvService.insertRefDetail',
			destroy	: 'ppl111ukrvService.deleteRefDetail',
			syncAll	: 'ppl111ukrvService.saveRefAll'
		}
	});



	//작업장
	Unilite.defineModel('s_ppl100ukrv_jwMasterModel1', {
		fields: [
			{name: 'COMP_CODE'			, text: 'COMP_CODE'				, type: 'string'},
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.product.division" default="사업장"/>'		, type: 'string'},
			{name: 'WORK_SHOP_CODE'		, text: '<t:message code="system.label.product.workcenter" default="작업장"/>'		, type: 'string', comboType:'WU', allowBlank: true},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.product.item" default="품목"/>'			, type: 'string'},
			{name: 'ITEM_INFO'			, text: '<t:message code="system.label.product.itemname" default="품목명"/>'		, type: 'string'},
			{name: 'ORDER_INFO'			, text: '<t:message code="system.label.product.soqty" default="수주량"/>'			, type: 'string'},

			//20181102 추가 (규격, 단위)
			{name: 'SPEC'				, text: '<t:message code="system.label.product.spec" default="규격"/>'			, type : 'string'},
			{name: 'STOCK_UNIT'			, text: '<t:message code="system.label.product.unit" default="단위"/>'			, type : 'string'},
			
			{name: 'GUBUN'				, text: '<t:message code="system.label.product.classfication" default="구분"/>'	, type: 'string'},
			{name: 'GUBUN_CODE'			, text: '<t:message code="system.label.product.classfication" default="구분"/>'	, type: 'string'},
			{name: 'TOT_Q'				, text: '<t:message code="system.label.product.monthlytotal" default="월합계"/>'	, type: 'uniQty'},
			{name: 'DAY1_Q'				, text: '1<t:message code="system.label.product.day" default="일"/>'				, type: 'uniQty'},
			{name: 'DAY2_Q'				, text: '2<t:message code="system.label.product.day" default="일"/>'				, type: 'uniQty'},
			{name: 'DAY3_Q'				, text: '3<t:message code="system.label.product.day" default="일"/>'				, type: 'uniQty'},
			{name: 'DAY4_Q'				, text: '4<t:message code="system.label.product.day" default="일"/>'				, type: 'uniQty'},
			{name: 'DAY5_Q'				, text: '5<t:message code="system.label.product.day" default="일"/>'				, type: 'uniQty'},
			{name: 'DAY6_Q'				, text: '6<t:message code="system.label.product.day" default="일"/>'				, type: 'uniQty'},
			{name: 'DAY7_Q'				, text: '7<t:message code="system.label.product.day" default="일"/>'				, type: 'uniQty'},
			{name: 'DAY8_Q'				, text: '8<t:message code="system.label.product.day" default="일"/>'				, type: 'uniQty'},
			{name: 'DAY9_Q'				, text: '9<t:message code="system.label.product.day" default="일"/>'				, type: 'uniQty'},
			{name: 'DAY10_Q'			, text: '10<t:message code="system.label.product.day" default="일"/>'			, type: 'uniQty'},
			{name: 'DAY11_Q'			, text: '11<t:message code="system.label.product.day" default="일"/>'			, type: 'uniQty'},
			{name: 'DAY12_Q'			, text: '12<t:message code="system.label.product.day" default="일"/>'			, type: 'uniQty'},
			{name: 'DAY13_Q'			, text: '13<t:message code="system.label.product.day" default="일"/>'			, type: 'uniQty'},
			{name: 'DAY14_Q'			, text: '14<t:message code="system.label.product.day" default="일"/>'			, type: 'uniQty'},
			{name: 'DAY15_Q'			, text: '15<t:message code="system.label.product.day" default="일"/>'			, type: 'uniQty'},
			{name: 'DAY16_Q'			, text: '16<t:message code="system.label.product.day" default="일"/>'			, type: 'uniQty'},
			{name: 'DAY17_Q'			, text: '17<t:message code="system.label.product.day" default="일"/>'			, type: 'uniQty'},
			{name: 'DAY18_Q'			, text: '18<t:message code="system.label.product.day" default="일"/>'			, type: 'uniQty'},
			{name: 'DAY19_Q'			, text: '19<t:message code="system.label.product.day" default="일"/>'			, type: 'uniQty'},
			{name: 'DAY20_Q'			, text: '20<t:message code="system.label.product.day" default="일"/>'			, type: 'uniQty'},
			{name: 'DAY21_Q'			, text: '21<t:message code="system.label.product.day" default="일"/>'			, type: 'uniQty'},
			{name: 'DAY22_Q'			, text: '22<t:message code="system.label.product.day" default="일"/>'			, type: 'uniQty'},
			{name: 'DAY23_Q'			, text: '23<t:message code="system.label.product.day" default="일"/>'			, type: 'uniQty'},
			{name: 'DAY24_Q'			, text: '24<t:message code="system.label.product.day" default="일"/>'			, type: 'uniQty'},
			{name: 'DAY25_Q'			, text: '25<t:message code="system.label.product.day" default="일"/>'			, type: 'uniQty'},
			{name: 'DAY26_Q'			, text: '26<t:message code="system.label.product.day" default="일"/>'			, type: 'uniQty'},
			{name: 'DAY27_Q'			, text: '27<t:message code="system.label.product.day" default="일"/>'			, type: 'uniQty'},
			{name: 'DAY28_Q'			, text: '28<t:message code="system.label.product.day" default="일"/>'			, type: 'uniQty'},
			{name: 'DAY29_Q'			, text: '29<t:message code="system.label.product.day" default="일"/>'			, type: 'uniQty'},
			{name: 'DAY30_Q'			, text: '30<t:message code="system.label.product.day" default="일"/>'			, type: 'uniQty'},
			{name: 'DAY31_Q'			, text: '31<t:message code="system.label.product.day" default="일"/>'			, type: 'uniQty'},
			{name: 'ITEM'				, text: 'ITEM'					, type: 'string'},
			{name: 'ORDERN'				, text: '<t:message code="system.label.product.sono" default="수주번호"/>'			, type: 'string'},
			{name: 'REMARK'				, text: 'REMARK'				, type: 'string'},
			{name: 'P_SEQ'				, text: '<t:message code="system.label.product.soseq" default="수주순번"/>'			, type: 'string'},
			{name: 'WORK_SHOP'			, text: '<t:message code="system.label.product.workcenter" default="작업장"/>'		, type: 'string'},
			{name: 'PLAN_TYPE'			, text: 'PLAN_TYPE'				, type: 'string'},
			{name: 'WORK_SHOP_CODE_OLD'	, text: 'WORK_SHOP_CODE_OLD'	, type: 'string'}

		]
	});

	//품목
	Unilite.defineModel('s_ppl100ukrv_jwMasterModel2', {
		fields: [
			{name: 'COMP_CODE'			, text: 'COMP_CODE'			, type: 'string'},
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.product.division" default="사업장"/>'		, type: 'string'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.product.item" default="품목"/>'			, type: 'string', allowBlank: true},
			{name: 'ITEM_INFO'			, text: '<t:message code="system.label.product.itemname" default="품목명"/>'		, type: 'string'},
			{name: 'ORDER_INFO'			, text: '<t:message code="system.label.product.soseq" default="수주순번"/>'			, type: 'string'},
			{name: 'WORK_SHOP_CODE'		, text: '<t:message code="system.label.product.workcenter" default="작업장"/>'		, type: 'string'},

			//20181102 추가 (규격, 단위)
			{name: 'SPEC'				, text: '<t:message code="system.label.product.spec" default="규격"/>'			, type : 'string'},
			{name: 'STOCK_UNIT'			, text: '<t:message code="system.label.product.unit" default="단위"/>'			, type : 'string'},
			
			{name: 'GUBUN'				, text: '<t:message code="system.label.product.classfication" default="구분"/>'	, type: 'string'},
			{name: 'TOT_Q'				, text: '<t:message code="system.label.product.monthlytotal" default="월합계"/>'	, type: 'uniQty'},
			{name: 'DAY1_Q'				, text: '1<t:message code="system.label.product.day" default="일"/>'				, type: 'uniQty'},
			{name: 'DAY2_Q'				, text: '2<t:message code="system.label.product.day" default="일"/>'				, type: 'uniQty'},
			{name: 'DAY3_Q'				, text: '3<t:message code="system.label.product.day" default="일"/>'				, type: 'uniQty'},
			{name: 'DAY4_Q'				, text: '4<t:message code="system.label.product.day" default="일"/>'				, type: 'uniQty'},
			{name: 'DAY5_Q'				, text: '5<t:message code="system.label.product.day" default="일"/>'				, type: 'uniQty'},
			{name: 'DAY6_Q'				, text: '6<t:message code="system.label.product.day" default="일"/>'				, type: 'uniQty'},
			{name: 'DAY7_Q'				, text: '7<t:message code="system.label.product.day" default="일"/>'				, type: 'uniQty'},
			{name: 'DAY8_Q'				, text: '8<t:message code="system.label.product.day" default="일"/>'				, type: 'uniQty'},
			{name: 'DAY9_Q'				, text: '9<t:message code="system.label.product.day" default="일"/>'				, type: 'uniQty'},
			{name: 'DAY10_Q'			, text: '10<t:message code="system.label.product.day" default="일"/>'			, type: 'uniQty'},
			{name: 'DAY11_Q'			, text: '11<t:message code="system.label.product.day" default="일"/>'			, type: 'uniQty'},
			{name: 'DAY12_Q'			, text: '12<t:message code="system.label.product.day" default="일"/>'			, type: 'uniQty'},
			{name: 'DAY13_Q'			, text: '13<t:message code="system.label.product.day" default="일"/>'			, type: 'uniQty'},
			{name: 'DAY14_Q'			, text: '14<t:message code="system.label.product.day" default="일"/>'			, type: 'uniQty'},
			{name: 'DAY15_Q'			, text: '15<t:message code="system.label.product.day" default="일"/>'			, type: 'uniQty'},
			{name: 'DAY16_Q'			, text: '16<t:message code="system.label.product.day" default="일"/>'			, type: 'uniQty'},
			{name: 'DAY17_Q'			, text: '17<t:message code="system.label.product.day" default="일"/>'			, type: 'uniQty'},
			{name: 'DAY18_Q'			, text: '18<t:message code="system.label.product.day" default="일"/>'			, type: 'uniQty'},
			{name: 'DAY19_Q'			, text: '19<t:message code="system.label.product.day" default="일"/>'			, type: 'uniQty'},
			{name: 'DAY20_Q'			, text: '20<t:message code="system.label.product.day" default="일"/>'			, type: 'uniQty'},
			{name: 'DAY21_Q'			, text: '21<t:message code="system.label.product.day" default="일"/>'			, type: 'uniQty'},
			{name: 'DAY22_Q'			, text: '22<t:message code="system.label.product.day" default="일"/>'			, type: 'uniQty'},
			{name: 'DAY23_Q'			, text: '23<t:message code="system.label.product.day" default="일"/>'			, type: 'uniQty'},
			{name: 'DAY24_Q'			, text: '24<t:message code="system.label.product.day" default="일"/>'			, type: 'uniQty'},
			{name: 'DAY25_Q'			, text: '25<t:message code="system.label.product.day" default="일"/>'			, type: 'uniQty'},
			{name: 'DAY26_Q'			, text: '26<t:message code="system.label.product.day" default="일"/>'			, type: 'uniQty'},
			{name: 'DAY27_Q'			, text: '27<t:message code="system.label.product.day" default="일"/>'			, type: 'uniQty'},
			{name: 'DAY28_Q'			, text: '28<t:message code="system.label.product.day" default="일"/>'			, type: 'uniQty'},
			{name: 'DAY29_Q'			, text: '29<t:message code="system.label.product.day" default="일"/>'			, type: 'uniQty'},
			{name: 'DAY30_Q'			, text: '30<t:message code="system.label.product.day" default="일"/>'			, type: 'uniQty'},
			{name: 'DAY31_Q'			, text: '31<t:message code="system.label.product.day" default="일"/>'			, type: 'uniQty'},
			{name: 'ITEM'				, text: 'ITEM'					, type: 'string'},
			{name: 'ORDERN'				, text: '<t:message code="system.label.product.sono" default="수주번호"/>'			, type: 'string'},
			{name: 'REMARK'				, text: 'REMARK'				, type: 'string'},
			{name: 'P_SEQ'				, text: '<t:message code="system.label.product.soseq" default="수주순번"/>'			, type: 'int'},
			{name: 'WORK_SHOP'			, text: '<t:message code="system.label.product.workcenter" default="작업장"/>'		, type: 'string'},
			{name: 'PLAN_TYPE'			, text: 'PLAN_TYPE'				, type: 'string'},
			{name: 'WORK_SHOP_CODE_OLD'	, text: 'WORK_SHOP_CODE_OLD'	, type: 'string'}
		]
	});



	//마스터 스토어 정의
	var masterStore1 = Unilite.createStore('s_ppl100ukrv_jwmasterStore1', {
		model	: 's_ppl100ukrv_jwMasterModel1',
		proxy	: directProxy,
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결
			editable	: true,		// 수정 모드 사용
			deletable	: true,		// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		loadStoreRecords: function() {
			var param= panelResult.getValues();
			console.log(param);
			this.load({
				params : param
			});
		},
		saveStore: function() {
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
//			var toCreate = this.getNewRecords();
//			var toUpdate = this.getUpdatedRecords();
//			var toDelete = this.getRemovedRecords();
//			var list = [].concat(toUpdate, toCreate);
//			console.log("list:", list);
//			console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));

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
						if (masterStore1.count() == 0) {
							UniAppManager.app.onResetButtonDown();
						}else{
							masterStore1.loadStoreRecords();
						}
					}
				};
				this.syncAllDirect(config);
				
			} else {
				var grid = Ext.getCmp('s_ppl100ukrv_jwGrid1');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});

	//마스터 스토어 정의
	var masterStore2 = Unilite.createStore('s_ppl100ukrv_jwmasterStore2', {
		model	: 's_ppl100ukrv_jwMasterModel2',
		proxy	: directProxy,
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결
			editable	: true,		// 수정 모드 사용
			deletable	: true,		// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		loadStoreRecords: function() {
			var param= panelResult.getValues();
			console.log(param);
			this.load({
				params : param
			});
		},
		saveStore: function() {
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);

//			var toCreate = this.getNewRecords();
//			var toUpdate = this.getUpdatedRecords();
//			var toDelete = this.getRemovedRecords();
//			var list = [].concat(toUpdate, toCreate);
//			console.log("list:", list);
//			console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));

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
						if (masterStore2.count() == 0) {
							UniAppManager.app.onResetButtonDown();
						}else{
							masterStore2.loadStoreRecords();
						}
					}
				};
				this.syncAllDirect(config);
				
			} else {
				var grid = Ext.getCmp('s_ppl100ukrv_jwGrid2');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});



	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 2},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel	: '<t:message code="system.label.product.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.product.plandate" default="계획일"/>',
			xtype		: 'uniMonthfield',
			name		: 'FR_DATE',
			value		: UniDate.get('today'),
			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					var date=Ext.util.Format.date(panelResult.getValue('FR_DATE'), 'Y-m');
					getDate(date, masterGrid1);
					day_change(masterGrid1);

					getDate(date, masterGrid2);
					day_change(masterGrid2);
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.product.workcenter" default="작업장"/>',
			xtype		: 'uniCombobox',
			name		: 'WORK_SHOP_CODE',
			comboType	: 'WU',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},
		Unilite.popup('DIV_PUMOK',{
			fieldLabel		: '<t:message code="system.label.product.item" default="품목"/>',
			valueFieldName	: 'ITEM_CODE',
			textFieldName	: 'ITEM_NAME',
			validateBlank	: false,
			listeners		: {
				onSelected: {
					fn: function(records, type) {
						console.log('records : ', records);
					},
					scope: this
				},
				onClear: function(type)	{
				},
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
				}
			}
		}),{
			fieldLabel	: '<t:message code="system.label.product.type2" default="타입"/>',
			xtype		: 'uniTextfield',
			name		: 'TYPE',
			value		: 'W',   //작업장별
			hidden		: true,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
				}
			}
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
						var labelText = invalid.items[0]['fieldLabel']+' : ';
					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
						var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
					}

					alert(labelText+Msg.sMB083);
					invalid.items[0].focus();
				} else {}
			} else {
				this.unmask();
			}
			return r;
		}
	});	//end panelSearch



	/** Master Grid1 정의(Grid Panel)
	 * @type
	 */
	var masterGrid1 = Unilite.createGrid('s_ppl100ukrv_jwGrid1', {
		store: masterStore1,
		layout: 'fit',
		region:'center',
		enableColumnHide :false,
		sortableColumns : false,
		uniOpt: {
			expandLastColumn: false,
			useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			useGroupSummary: false,
			useRowNumberer: false
//			filter: {
//				useFilter: true,
//				autoCreate: true
//			}
		},
		tbar: [{
			xtype: 'splitbutton',
			itemId:'refTool',
			text: '<t:message code="system.label.product.reference" default="참조..."/>',
			iconCls : 'icon-referance',
			menu: Ext.create('Ext.menu.Menu', {
				items: [{
					itemId: 'requestBtn',
					text: '<t:message code="system.label.product.soinforeference" default="수주정보참조"/>',
					handler: function() {
						openOrderInformationWindow();
					}
				}]
			})
		}],
/*		viewConfig:{
			forceFit : true,
			stripeRows: false,//是否隔行换色
			getRowClass : function(record,rowIndex,rowParams,store){
				var cls = '';
				if(record.get('GUBUN')=="계획"){
					cls = 'x-change-cell_row1';
				}else if(record.get('GUBUN')=="지시"){
					cls = 'x-change-cell_row3';
				}else if(record.get('GUBUN')=="실적"){
					cls = 'x-change-cell_row3';
				}
				return cls;
			}
		},
		features: [
			{id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true},
			{id : 'masterGridTotal' ,   ftype: 'uniSummary', 		 showSummaryRow: false}
		],*/
		columns: [
			{ dataIndex: 'COMP_CODE'		, width: 80		, locked: true	, hidden: true },
			{ dataIndex: 'DIV_CODE'			, width: 80		, locked: true	, hidden: true },
			{ dataIndex: 'WORK_SHOP_CODE'	, width: 120	, locked: true	, comboType: 'WU'},
			{ dataIndex: 'ITEM_CODE'		, width: 120	, locked: true,
				editor:Unilite.popup('DIV_PUMOK_G',{
					textFieldName: 'ITEM_CODE',
					DBtextFieldName: 'ITEM_CODE',
					extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode, POPUP_TYPE: 'GRID_CODE'},
					autoPopup: true,
					listeners: {
						onSelected: {
							fn: function(records, type) {
								Ext.each(records, function(record,i) {
									console.log('record',record);
									debugger;
									if(i==0) {
										masterGrid1.setItemData(record,false);
									} else {
										UniAppManager.app.onNewDataButtonDown();
										masterGrid1.setItemData(record,false);
									}
								});
							},
							scope: this
						},
						onClear: function(type)	{
							masterGrid1.setItemData(null,true);
						}
					}
				})
			},
			{ dataIndex: 'ITEM_INFO'	, width: 120	, locked: true,
				editor:Unilite.popup('DIV_PUMOK_G',{
					textFieldName: 'ITEM_INFO',
					DBtextFieldName: 'ITEM_CODE',
					extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode, POPUP_TYPE: 'GRID_CODE'},
					autoPopup: true,
					listeners: {
						onSelected: {
							fn: function(records, type) {
								Ext.each(records, function(record,i) {
									console.log('record',record);
									if(i==0) {
										masterGrid1.setItemData(record,false);
									} else {
										UniAppManager.app.onNewDataButtonDown();
										masterGrid1.setItemData(record,false);
									}
								});
							},
							scope: this
						},
						onClear: function(type)	{
							masterGrid1.setItemData(null,true);
						}
					}
				})
			},
//			{ dataIndex: 'ORDER_INFO'	, width: 120	, locked: true},
			
			//20181102 추가 (규격, 단위)
			{ dataIndex: 'SPEC'			, width: 120	, locked: true},
			{ dataIndex: 'STOCK_UNIT'	, width: 66		, locked: true},
			
			{ dataIndex: 'GUBUN'		, width: 66		, align:'center', locked: true},
			{ dataIndex: 'TOT_Q'		, width: 100	, locked: true},
			{text :'1<t:message code="system.label.product.day" default="일"/>',
				columns:[
					{dataIndex:'DAY1_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
				]
			},
			{text :'2<t:message code="system.label.product.day" default="일"/>',
				columns:[
					{dataIndex:'DAY2_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
				]
			},
			{text :'3<t:message code="system.label.product.day" default="일"/>',
				columns:[
					{dataIndex:'DAY3_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
				]
			},
			{text :'4<t:message code="system.label.product.day" default="일"/>',
				columns:[
					{dataIndex:'DAY4_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
				]
			},
			{text :'5<t:message code="system.label.product.day" default="일"/>',
				columns:[
					{dataIndex:'DAY5_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
				]
			},
			{text :'6<t:message code="system.label.product.day" default="일"/>',
				columns:[
					{dataIndex:'DAY6_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
				]
			},
			{text :'7<t:message code="system.label.product.day" default="일"/>',
				columns:[
					{dataIndex:'DAY7_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
				]
			},
			{text :'8<t:message code="system.label.product.day" default="일"/>',
				columns:[
					{dataIndex:'DAY8_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
				]
			},
			{text :'9<t:message code="system.label.product.day" default="일"/>',
				columns:[
					{dataIndex:'DAY9_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
				]
			},
			{text :'10<t:message code="system.label.product.day" default="일"/>',
				columns:[
					{dataIndex:'DAY10_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
				]
			},
			{text :'11<t:message code="system.label.product.day" default="일"/>',
				columns:[
					{dataIndex:'DAY11_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
				]
			},
			{text :'12<t:message code="system.label.product.day" default="일"/>',
				columns:[
					{dataIndex:'DAY12_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
				]
			},
			{text :'13<t:message code="system.label.product.day" default="일"/>',
				columns:[
					{dataIndex:'DAY13_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
				]
			},
			{text :'14<t:message code="system.label.product.day" default="일"/>',
				columns:[
					{dataIndex:'DAY14_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
				]
			},
			{text :'15<t:message code="system.label.product.day" default="일"/>',
				columns:[
					{dataIndex:'DAY15_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
				]
			},
			{text :'16<t:message code="system.label.product.day" default="일"/>',
				columns:[
					{dataIndex:'DAY16_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
				]
			},
			{text :'17<t:message code="system.label.product.day" default="일"/>',
				columns:[
					{dataIndex:'DAY17_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
				]
			},
			{text :'18<t:message code="system.label.product.day" default="일"/>',
				columns:[
					{dataIndex:'DAY18_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
				]
			},
			{text :'19<t:message code="system.label.product.day" default="일"/>',
				columns:[
					{dataIndex:'DAY19_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
				]
			},
			{text :'20<t:message code="system.label.product.day" default="일"/>',
				columns:[
					{dataIndex:'DAY20_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
				]
			},
			{text :'21<t:message code="system.label.product.day" default="일"/>',
				columns:[
					{dataIndex:'DAY21_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
				]
			},
			{text :'22<t:message code="system.label.product.day" default="일"/>',
				columns:[
					{dataIndex:'DAY22_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
				]
			},
			{text :'23<t:message code="system.label.product.day" default="일"/>',
				columns:[
					{dataIndex:'DAY23_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
				]
			},
			{text :'24<t:message code="system.label.product.day" default="일"/>',
				columns:[
					{dataIndex:'DAY24_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
				]
			},
			{text :'25<t:message code="system.label.product.day" default="일"/>',
				columns:[
					{dataIndex:'DAY25_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
				]
			},
			{text :'26<t:message code="system.label.product.day" default="일"/>',
				columns:[
					{dataIndex:'DAY26_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
				]
			},
			{text :'27<t:message code="system.label.product.day" default="일"/>',
				columns:[
					{dataIndex:'DAY27_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
				]
			},
			{text :'28<t:message code="system.label.product.day" default="일"/>',
				columns:[
					{dataIndex:'DAY28_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
				]
			},
			{text :'29<t:message code="system.label.product.day" default="일"/>',
				columns:[
					{dataIndex:'DAY29_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
				]
			},
			{text :'30<t:message code="system.label.product.day" default="일"/>',
				columns:[
					{dataIndex:'DAY30_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
				]
			},
			{text :'31<t:message code="system.label.product.day" default="일"/>',
				columns:[
					{dataIndex:'DAY31_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
				]
			},
			{dataIndex:'ITEM'				, width: 66		,hidden: false},
			{dataIndex:'ORDERN'				, width: 66		,hidden: false},
			{dataIndex:'REMARK'				, width: 66		,hidden: false},
			{dataIndex:'P_SEQ'				, width: 66		,hidden: false},
			{dataIndex:'WORK_SHOP'			, width: 66		,hidden: false},
			{dataIndex:'PLAN_TYPE'			, width: 66		,hidden: false},
			{dataIndex:'WORK_SHOP_CODE_OLD'	, width: 66		,hidden: false}
		],
		setItemData: function(record, dataClear) {
			var rowIndex = masterGrid1.getSelectedRowIndex();
			if(dataClear) {
				masterStore1.getAt(rowIndex).set('ITEM_CODE'		, "");
				masterStore1.getAt(rowIndex).set('ITEM_INFO'		, "");
				masterStore1.getAt(rowIndex).set('WORK_SHOP_CODE'	, "");
				masterStore1.getAt(rowIndex).set('SPEC'				, "");
				masterStore1.getAt(rowIndex).set('STOCK_UNIT'		, "");
				
			} else {
				masterStore1.getAt(rowIndex).set('ITEM_CODE'		, record['ITEM_CODE']);
				masterStore1.getAt(rowIndex).set('ITEM_INFO'		, record['ITEM_NAME']);
				masterStore1.getAt(rowIndex).set('WORK_SHOP_CODE'	, record['WORK_SHOP_CODE']);
				masterStore1.getAt(rowIndex).set('SPEC'				, record['SPEC']);
				masterStore1.getAt(rowIndex).set('STOCK_UNIT'		, record['STOCK_UNIT']);
			}
		},
		listeners: {
			beforeedit:function(editor, e, eOpts) {
				if(!UniUtils.indexOf(e.field, [ 'GUBUN', 'TOT_Q', 'SPEC', 'STOCK_UNIT' ])){
					return true;
				}
				return false;
			}
		}
	});

	var masterGrid2 = Unilite.createGrid('s_ppl100ukrv_jwGrid2', {
		store: masterStore2,
		layout: 'fit',
		region:'center',
			enableColumnHide :false,
			sortableColumns : false,
		uniOpt: {
			expandLastColumn: true,
			useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			useGroupSummary: false,
			useRowNumberer: false
//			filter: {
//				useFilter: true,
//				autoCreate: true
//			}
		},
		tbar: [{
			xtype: 'splitbutton',
			itemId:'refTool',
			text: '<t:message code="system.label.product.reference" default="참조..."/>',
			iconCls : 'icon-referance',
			menu: Ext.create('Ext.menu.Menu', {
				items: [{
					itemId: 'requestBtn',
					text: '<t:message code="system.label.product.soinforeference" default="수주정보참조"/>',
					handler: function() {
						openOrderInformationWindow();
					}
				},{
					itemId: 'refBtn',
					text: '<t:message code="system.label.product.salesplanreference" default="판매계획참조"/>',
					handler: function() {
						openSalesPlanWindow();
					}
				}]
			})
		}],
/*		viewConfig:{
			forceFit : true,
			stripeRows: false,//是否隔行换色
			getRowClass : function(record,rowIndex,rowParams,store){
				var cls = '';
				if(record.get('GUBUN')=="계획"){
					cls = 'x-change-cell_row1';
				}else if(record.get('GUBUN')=="지시"){
					cls = 'x-change-cell_row3';
				}else if(record.get('GUBUN')=="실적"){
					cls = 'x-change-cell_row3';
				}
				return cls;
			}
		},
		features: [
			{id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true},
			{id : 'masterGridTotal' ,   ftype: 'uniSummary', 		 showSummaryRow: false}
		],*/
		columns: [
			{ dataIndex: 'COMP_CODE'		, width: 80 	, locked: true, hidden: true },
			{ dataIndex: 'DIV_CODE'			, width: 80 	, locked: true, hidden: true },
			{ dataIndex: 'ITEM_CODE'		, width: 120 	, locked: true,
				editor:Unilite.popup('DIV_PUMOK_G',{
					textFieldName: 'ITEM_CODE',
					DBtextFieldName: 'ITEM_CODE',
					extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode, POPUP_TYPE: 'GRID_CODE'},
					autoPopup: true,
					listeners: {
						onSelected: {
							fn: function(records, type) {
								Ext.each(records, function(record,i) {
									console.log('record',record);
									if(i==0) {
										masterGrid2.setItemData(record,false);
									} else {
										UniAppManager.app.onNewDataButtonDown();
										masterGrid2.setItemData(record,false);
									}
								});
							},
							scope: this
						},
						onClear: function(type)	{
							masterGrid2.setItemData(null,true);
						}
					}
				})
			},
			{ dataIndex: 'ITEM_INFO'		, width: 120	, locked: true,
				editor:Unilite.popup('DIV_PUMOK_G',{
					textFieldName: 'ITEM_INFO',
					DBtextFieldName: 'ITEM_CODE',
					extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode, POPUP_TYPE: 'GRID_CODE'},
					autoPopup: true,
					listeners: {
						onSelected: {
							fn: function(records, type) {
								Ext.each(records, function(record,i) {
									console.log('record',record);
									if(i==0) {
										masterGrid2.setItemData(record,false);
									} else {
										UniAppManager.app.onNewDataButtonDown();
										masterGrid2.setItemData(record,false);
									}
								});
							},
							scope: this
						},
						onClear: function(type)	{
							masterGrid2.setItemData(null,true);
						}
					}
				})
			},
//			{ dataIndex:'ORDER_INFO'		, width: 120	, locked: true},
			{ dataIndex:'WORK_SHOP_CODE'	, width: 120	, locked: true},
			
			//20181102 추가 (규격, 단위)
			{ dataIndex: 'SPEC'				, width: 120	, locked: true},
			{ dataIndex: 'STOCK_UNIT'		, width: 66		, locked: true},

			{ dataIndex: 'GUBUN'			, width: 66		, align:'center', locked: true},
			{ dataIndex: 'TOT_Q'			, width: 100	, locked: true},
			{text :'1<t:message code="system.label.product.day" default="일"/>',
				columns:[
					{dataIndex:'DAY1_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
				]
			},
			{text :'2<t:message code="system.label.product.day" default="일"/>',
				columns:[
					{dataIndex:'DAY2_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
				]
			},
			{text :'3<t:message code="system.label.product.day" default="일"/>',
				columns:[
					{dataIndex:'DAY3_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
				]
			},
			{text :'4<t:message code="system.label.product.day" default="일"/>',
				columns:[
					{dataIndex:'DAY4_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
				]
			},
			{text :'5<t:message code="system.label.product.day" default="일"/>',
				columns:[
					{dataIndex:'DAY5_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
				]
			},
			{text :'6<t:message code="system.label.product.day" default="일"/>',
				columns:[
					{dataIndex:'DAY6_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
				]
			},
			{text :'7<t:message code="system.label.product.day" default="일"/>',
				columns:[
					{dataIndex:'DAY7_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
				]
			},
			{text :'8<t:message code="system.label.product.day" default="일"/>',
				columns:[
					{dataIndex:'DAY8_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
				]
			},
			{text :'9<t:message code="system.label.product.day" default="일"/>',
				columns:[
					{dataIndex:'DAY9_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
				]
			},
			{text :'10<t:message code="system.label.product.day" default="일"/>',
				columns:[
					{dataIndex:'DAY10_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
				]
			},
			{text :'11<t:message code="system.label.product.day" default="일"/>',
				columns:[
					{dataIndex:'DAY11_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
				]
			},
			{text :'12<t:message code="system.label.product.day" default="일"/>',
				columns:[
					{dataIndex:'DAY12_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
				]
			},
			{text :'13<t:message code="system.label.product.day" default="일"/>',
				columns:[
					{dataIndex:'DAY13_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
				]
			},
			{text :'14<t:message code="system.label.product.day" default="일"/>',
				columns:[
					{dataIndex:'DAY14_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
				]
			},{text :'15<t:message code="system.label.product.day" default="일"/>',
				columns:[
					{dataIndex:'DAY15_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
				]
			},
			{text :'16<t:message code="system.label.product.day" default="일"/>',
				columns:[
					{dataIndex:'DAY16_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
				]
			},
			{text :'17<t:message code="system.label.product.day" default="일"/>',
				columns:[
					{dataIndex:'DAY17_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
				]
			},
			{text :'18<t:message code="system.label.product.day" default="일"/>',
				columns:[
					{dataIndex:'DAY18_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
				]
			},
			{text :'19<t:message code="system.label.product.day" default="일"/>',
				columns:[
					{dataIndex:'DAY19_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
				]
			},
			{text :'20<t:message code="system.label.product.day" default="일"/>',
				columns:[
					{dataIndex:'DAY20_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
				]
			},
			{text :'21<t:message code="system.label.product.day" default="일"/>',
				columns:[
					{dataIndex:'DAY21_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
				]
			},
			{text :'22<t:message code="system.label.product.day" default="일"/>',
				columns:[
					{dataIndex:'DAY22_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
				]
			},
			{text :'23<t:message code="system.label.product.day" default="일"/>',
				columns:[
					{dataIndex:'DAY23_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
				]
			},
			{text :'24<t:message code="system.label.product.day" default="일"/>',
				columns:[
					{dataIndex:'DAY24_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
				]
			},
			{text :'25<t:message code="system.label.product.day" default="일"/>',
				columns:[
					{dataIndex:'DAY25_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
				]
			},
			{text :'26<t:message code="system.label.product.day" default="일"/>',
				columns:[
					{dataIndex:'DAY26_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
				]
			},
			{text :'27<t:message code="system.label.product.day" default="일"/>',
				columns:[
					{dataIndex:'DAY27_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
				]
			},
			{text :'28<t:message code="system.label.product.day" default="일"/>',
				columns:[
					{dataIndex:'DAY28_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
				]
			},
			{text :'29<t:message code="system.label.product.day" default="일"/>',
				columns:[
					{dataIndex:'DAY29_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
				]
			},
			{text :'30<t:message code="system.label.product.day" default="일"/>',
				columns:[
					{dataIndex:'DAY30_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
				]
			},
			{text :'31<t:message code="system.label.product.day" default="일"/>',
				columns:[
					{dataIndex:'DAY31_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
				]
			},
			{dataIndex:'ITEM'				, width: 66		,hidden: true},
			{dataIndex:'ORDERN'				, width: 66		,hidden: true},
			{dataIndex:'REMARK'				, width: 66		,hidden: true},
			{dataIndex:'P_SEQ'				, width: 66		,hidden: true},
			{dataIndex:'WORK_SHOP'			, width: 66		,hidden: true},
			{dataIndex:'PLAN_TYPE'			, width: 66		,hidden: true},
			{dataIndex:'WORK_SHOP_CODE_OLD'	, width: 66		,hidden: true}
		],
		setItemData: function(record, dataClear) {
			var rowIndex = masterGrid2.getSelectedRowIndex();
			if(dataClear) {
				masterStore2.getAt(rowIndex).set('ITEM_CODE'	, "");
				masterStore2.getAt(rowIndex).set('ITEM_INFO'	, "");
				masterStore2.getAt(rowIndex).set('SPEC'			, "");
				masterStore2.getAt(rowIndex).set('STOCK_UNIT'	, "");
				
			} else {
				masterStore2.getAt(rowIndex).set('ITEM_CODE'	, record['ITEM_CODE']);
				masterStore2.getAt(rowIndex).set('ITEM_INFO'	, record['ITEM_NAME']);
				masterStore2.getAt(rowIndex).set('SPEC'			, record['SPEC']);
				masterStore2.getAt(rowIndex).set('STOCK_UNIT'	, record['STOCK_UNIT']);
			}
		},
		listeners: {
			beforeedit:function(editor, e, eOpts) {
				if(!UniUtils.indexOf(e.field, [ 'GUBUN', 'TOT_Q', 'SPEC', 'STOCK_UNIT' ])){
					return true;
				}
				return false;
			}
		}
	});



	//수주참조 참조 메인
	function openOrderInformationWindow() {
		if(!UniAppManager.app.checkForNewDetail()) return false;
		OrderSearch.setValue('DIV_CODE',panelResult.getValue('DIV_CODE'));
		OrderSearch.setValue('PROD_END_DATE_FR', panelResult.getValue('PRODT_PLAN_DATE_FR'));
		OrderSearch.setValue('PROD_END_DATE_TO', panelResult.getValue('PRODT_PLAN_DATE_TO'));

		if(!referOrderInformationWindow) {
			referOrderInformationWindow = Ext.create('widget.uniDetailWindow', {
				title: '<t:message code="system.label.product.soinforeference" default="수주정보참조"/>',
				width: 1200,
				height: 580,
				layout:{type:'vbox', align:'stretch'},
				items: [OrderSearch, OrderGrid],
				tbar:  ['->',
					{	itemId : 'saveBtn',
						id:'saveBtn1',
						text: '<t:message code="system.label.product.inquiry" default="조회"/>',
						handler: function() {
							OrderStore.loadStoreRecords();
						},
						disabled: false
					},{
						itemId : 'confirmBtn',
						id:'confirmBtn1',
						text: '<t:message code="system.label.product.productionplancalcu" default="생산계획계산"/>',
						handler: function() { /////
							panelResult.setValue('COM',"적용");
							OrderStore.saveStore();  /* 저장된 후 조회 */
						},
						disabled: false
					},{
						itemId : 'confirmCloseBtn',
						id:'confirmCloseBtn1',
						text: '<t:message code="system.label.product.productionplancalcuapplyclose" default="생산계획계산적용후 닫기"/>',
						handler: function() {
							panelResult.setValue('COM',"적용후닫기");
							OrderStore.saveStore();
							referOrderInformationWindow.hide();
						},
						disabled: false
					},{
						itemId : 'closeBtn',
						id:'closeBtn1',
						text: '<t:message code="system.label.product.close" default="닫기"/>',
						handler: function() {
							//masterStore.saveStore();
							var activeTabId = tab.getActiveTab().getId();
							if(activeTabId == 'masterGrid1'){
								masterStore1.saveStore();
							}
							if(activeTabId == 'masterGrid2'){
								masterStore2.saveStore();
							}
							referOrderInformationWindow.hide();
						},
						disabled: false
					}
				],
				listeners : {
					beforehide: function(me, eOpt)	{
					},
					beforeclose: function( panel, eOpts )	{
					},
					beforeshow: function ( me, eOpts )	{
						OrderStore.loadStoreRecords();
					}
				}
			})
		}
		referOrderInformationWindow.show();
	}

	// 수주정보 참조 모델 정의
	Unilite.defineModel('s_ppl100ukrv_jwOrderModel', {
		fields: [
			{name: 'GUBUN'				, text: '<t:message code="system.label.product.selection" default="선택"/>'					, type: 'string'},
			{name: 'PLAN_TYPE'			, text: '<t:message code="system.label.product.typecode" default="유형코드"/>'					, type: 'string'},
			{name: 'PLANTYPE_NAME'		, text: '<t:message code="system.label.product.type" default="유형"/>'						, type: 'string'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.product.item" default="품목"/>'						, type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.product.itemname" default="품목명"/>'					, type: 'string'},
			{name: 'SPEC'				, text: '<t:message code="system.label.product.spec" default="규격"/>'						, type: 'string'},
			{name: 'STOCK_UNIT'			, text: '<t:message code="system.label.product.unit" default="단위"/>'						, type: 'string'},
			{name: 'PROD_Q'				, text: '<t:message code="system.label.product.productionrequestqty" default="생산요청량"/>'		, type: 'uniQty'},
			{name: 'NOTREF_Q'			, text: '<t:message code="system.label.product.noplanqty" default="미계획량"/>'					, type: 'uniQty'},
			{name: 'PROD_END_DATE'		, text: '<t:message code="system.label.product.productionrequestdate" default="생산요청일"/>'	, type: 'uniDate'},
			{name: 'DVRY_DATE'			, text: '<t:message code="system.label.product.deliverydate" default="납기일"/>'				, type: 'uniDate'},
			{name: 'ORDER_DATE'			, text: '<t:message code="system.label.product.sodate" default="수주일"/>'						, type: 'uniDate'},
			{name: 'ORDER_Q'			, text: '<t:message code="system.label.product.soqty" default="수주량"/>'						, type: 'uniQty'},
			{name: 'CUSTOM_NAME'		, text: '<t:message code="system.label.product.custom" default="거래처"/>'						, type: 'string'},
			{name: 'SER_NO'				, text: '<t:message code="system.label.product.soseq" default="수주순번"/>'						, type: 'string'},
			{name: 'WORK_SHOP_CODE'		, text: '<t:message code="system.label.product.mainworkcenter" default="주작업장"/>'			, type: 'string' , comboType: 'WU'},
			{name: 'ORDER_NUM'			, text: '<t:message code="system.label.product.sono" default="수주번호"/>'						, type: 'string'},
			{name: 'PROJECT_NO'			, text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'				, type: 'string'},
			{name: 'PJT_CODE'			, text: '<t:message code="system.label.product.projectcode" default="프로젝트코드"/>'				, type: 'string'},
			/* 파라미터  */
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.product.division" default="사업장"/>'					, type: 'string'},
			{name: 'PAD_STOCK_YN'		, text: '<t:message code="system.label.product.availableinventoryapplyyn" default="가용재고 반영여부"/>'	, type: 'string'},
			{name: 'CHECK_YN'			, text: '그리드선택 여부'			, type: 'string'}  // 선택 했을때 체크하는 값 (그리드 데이터랑 관련없음)

		]
	});

	//수주정보 참조 스토어 정의
	var OrderStore = Unilite.createStore('s_ppl100ukrv_jwOrderStore', {
		model	: 's_ppl100ukrv_jwOrderModel',
		proxy	: directProxy2,
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		loadStoreRecords : function()	{
			var param= OrderSearch.getValues();
			console.log( param );
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

			var paramMaster= OrderSearch.getValues();	//syncAll 수정
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {

						if(panelResult.getValue('COM') == "적용"){
							OrderStore.loadStoreRecords();
							panelResult.setValue('COM', '');
						}
						else if(panelResult.getValue('COM') == "적용후닫기"){
							//OrderStore.loadStoreRecords();
							//masterStore.loadStoreRecords();
							var activeTabId = tab.getActiveTab().getId();
							if(activeTabId == 'masterGrid1'){
								masterStore1.loadStoreRecords();
							}
							if(activeTabId == 'masterGrid2'){
								masterStore2.loadStoreRecords();
							}
							panelResult.setValue('COM', '');
						}
					}
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('s_ppl100ukrv_jwOrderGrid');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});

	/** 수주정보참조을 참조하기 위한 Search Form, Grid, Inner Window 정의
	 */
	//수주정보 참조 폼 정의
	 var OrderSearch = Unilite.createSearchForm('OrderForm', {
			layout :  {type : 'uniTable', columns : 3},
			items :[{
				fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
				name:'DIV_CODE',
				xtype: 'uniCombobox',
				comboType:'BOR120'
			}, {
				fieldLabel: '<t:message code="system.label.product.productionrequestdate" default="생산요청일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'PROD_END_DATE_FR',
				endFieldName: 'PROD_END_DATE_TO',
				width: 350,
				startDate: UniDate.get('mondayOfWeek'),
				endDate: UniDate.get('endOfWeek')
		   }, {
				xtype: 'uniRadiogroup',
				width: 235,
				items: [{
						boxLabel:'<t:message code="system.label.product.whole" default="전체"/>',
						name:'PLAN_TYPE',
						inputValue:'',
						checked:true,
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {
								OrderStore.loadStoreRecords();
							}
						}
					},{
						boxLabel:'<t:message code="system.label.product.salesorder" default="수주"/>',
						name:'PLAN_TYPE',
						inputValue:'S',
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {
								OrderStore.loadStoreRecords();
							}
						}
					},{
						boxLabel:'<t:message code="system.label.product.tradeso" default="무역S/O"/>',
						name:'PLAN_TYPE',
						inputValue:'T',
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {
								OrderStore.loadStoreRecords();
							}
						}
					}
			]}, {
				 xtype: 'fieldcontainer',
				 fieldLabel: '<t:message code="system.label.product.sono" default="수주번호"/>',
				 combineErrors: true,
				 msgTarget : 'side',
				 layout: {type : 'table', columns : 3},
				 defaults: {
					 flex: 1,
					 hideLabel: true
				 },
				 defaultType : 'textfield',
				 items: [
					Unilite.popup('ORDER_NUM',{
						fieldLabel: '',
						valueFieldName: 'FROM_NUM',
						textFieldName: 'FROM_NUM',
						allowBlank:false,
						listeners: {
							applyextparam: function(popup){
								popup.setExtParam({'DIV_CODE': OrderSearch.getValue('DIV_CODE')});
							}
						}
					}),
					{xtype:  'displayfield', value:'&nbsp;~&nbsp;'},
					Unilite.popup('ORDER_NUM',{
						fieldLabel: '',
						valueFieldName: 'TO_NUM',
						textFieldName: 'TO_NUM',
						allowBlank:false,
						listeners: {
							applyextparam: function(popup){
								popup.setExtParam({'DIV_CODE': OrderSearch.getValue('DIV_CODE')});
							}
						}
					})
				   ]
			   },{
				 xtype: 'fieldcontainer',
				 fieldLabel: '<t:message code="system.label.product.item" default="품목"/>',
				 combineErrors: true,
				 msgTarget : 'side',
				 colspan:2,
				 layout: {type : 'table', columns : 3},
				 defaults: {
					 flex: 1,
					 hideLabel: true
				 },
				 defaultType : 'textfield',
				 items: [
					 Unilite.popup('DIV_PUMOK',{
						fieldLabel: '<t:message code="system.label.product.item" default="품목"/>',
						valueFieldName: 'ITEM_CODE_FR',
						textFieldName: 'ITEM_NAME_FR',
						allowBlank:false,
						listeners: {
							applyextparam: function(popup){
								popup.setExtParam({'DIV_CODE': OrderSearch.getValue('DIV_CODE')});
							}
						}
					}),
					{xtype:  'displayfield', value:'&nbsp;~&nbsp;'},
					Unilite.popup('DIV_PUMOK',{
						fieldLabel: '<t:message code="system.label.product.item" default="품목"/>',
						valueFieldName: 'ITEM_CODE_TO',
						textFieldName: 'ITEM_NAME_TO',
						allowBlank:false,
						listeners: {
							applyextparam: function(popup){
								popup.setExtParam({'DIV_CODE': OrderSearch.getValue('DIV_CODE')});
							}
						}
					})
				   ]
			   },{
				fieldLabel: '<t:message code="system.label.product.sentence001" default="※ 생산계획계산시 가용재고(현재고+입고예정-출고예정-안전재고)반영여부"/>',
				xtype: 'uniRadiogroup',
				labelWidth:450,
				width: 235,
				colspan:3,
				name:'PAD_STOCK_YN',
				id:'padStockYn',
				items: [{
						boxLabel:'<t:message code="system.label.product.yes" default="예"/>',
						width:70,
						name:'PAD_STOCK_YN',
						inputValue:'Y'
					},{
						boxLabel:'<t:message code="system.label.product.no" default="아니오"/>',
						width:70,
						name:'PAD_STOCK_YN',
						inputValue:'N' ,
						checked:true
				}]
		}]

	});

	/* 수주정보 그리드 */
	var OrderGrid = Unilite.createGrid('s_ppl100ukrv_jwOrderGrid', {
		layout : 'fit',
		store: OrderStore,
		selModel : Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }),
		uniOpt:{
			onLoadSelectFirst : false
		},
		columns: [
			{ dataIndex: 'GUBUN'			, width: 40,  hidden: true},
			{ dataIndex: 'CHECK_YN'			, width: 40 , hidden: true},
			{ dataIndex: 'PLAN_TYPE'		, width: 40 , hidden: true},
			{ dataIndex: 'PLANTYPE_NAME'	, width: 80},
			{ dataIndex: 'ITEM_CODE'		, width: 120},
			{ dataIndex: 'ITEM_NAME'		, width: 140},
			{ dataIndex: 'SPEC'				, width: 126},
			{ dataIndex: 'STOCK_UNIT'		, width: 44},
			{ dataIndex: 'PROD_Q'			, width: 80},
			{ dataIndex: 'NOTREF_Q'			, width: 80},
			{ dataIndex: 'PROD_END_DATE'	, width: 80},
			{ dataIndex: 'DVRY_DATE'		, width: 80},
			{ dataIndex: 'ORDER_DATE'		, width: 80},
			{ dataIndex: 'ORDER_Q'			, width: 66},
			{ dataIndex: 'CUSTOM_NAME'		, width: 120},
			{ dataIndex: 'SER_NO'			, width: 100 , hidden: true},
			{ dataIndex: 'WORK_SHOP_CODE'	, width: 100 , hidden: true},
			{ dataIndex: 'ORDER_NUM'		, width: 100},
			{ dataIndex: 'PROJECT_NO'		, width: 100 , hidden: true},
			{ dataIndex: 'PJT_CODE'			, width: 100 , hidden: true}
		],
		listeners: {
			onGridDblClick:function(grid, record, cellIndex, colName) {
			},
			deselect: function( model, record, index, eOpts ){
				record.set('CHECK_YN', '')
			},
			select: function( model, record, index, eOpts ){
				record.set('CHECK_YN', 'S')
			}
		}
	});



	//판매계획 참조 메인
	function openSalesPlanWindow() {
		if(!UniAppManager.app.checkForNewDetail()) return false;

		SalesPlanSearch.setValue('DIV_CODE',panelResult.getValue('DIV_CODE'));
		SalesPlanSearch.setValue('PROD_END_DATE_FR', UniDate.get('startOfMonth', panelResult.getValue('PRODT_PLAN_DATE_FR')));
		SalesPlanSearch.setValue('PROD_END_DATE_TO',panelResult.getValue('PRODT_PLAN_DATE_FR'));

		if(!referSalesPlanWindow) {
			referSalesPlanWindow = Ext.create('widget.uniDetailWindow', {
				title: '<t:message code="system.label.product.salesplanreference" default="판매계획참조"/>',
				width: 1200,
				height: 580,
				layout:{type:'vbox', align:'stretch'},

				items: [SalesPlanSearch, SalesPlanGrid],
				tbar:  ['->',
										{	itemId : 'saveBtn',
											text: '<t:message code="system.label.product.inquiry" default="조회"/>',
											handler: function() {
												SalesPlanStore.loadStoreRecords();
											},
											disabled: false
										},
										{	itemId : 'confirmBtn',
											id:'confirmBtn2',
											text: '<t:message code="system.label.product.productionplancalcu" default="생산계획계산"/>',
											handler: function() {
												panelResult.setValue('COM',"적용");
												SalesPlanStore.saveStore();
											},
											disabled: false
										},
										{	itemId : 'confirmCloseBtn',
											id:'confirmCloseBtn2',
											text: '<t:message code="system.label.product.productionplancalcuapplyclose" default="생산계획계산적용후 닫기"/>',
											handler: function() {
												panelResult.setValue('COM',"적용후닫기");
												SalesPlanStore.saveStore();
												referSalesPlanWindow.hide();
											},
											disabled: false
										},{
											itemId : 'closeBtn',
											text: '<t:message code="system.label.product.close" default="닫기"/>',
											handler: function() {
												//masterStore.saveStore();
												var activeTabId = tab.getActiveTab().getId();
												if(activeTabId == 'masterGrid1'){
													masterStore1.saveStore();
												}
												if(activeTabId == 'masterGrid2'){
													masterStore2.saveStore();
												}
												referSalesPlanWindow.hide();
											},
											disabled: false
										}
								]
							,
				listeners : {beforehide: function(me, eOpt)	{
											//SalesOrderSearch.clearForm();
											//SalesOrderGrid.reset();
										},
							 beforeclose: function( panel, eOpts )	{
											//SalesOrderSearch.clearForm();
											//SalesOrderGrid.reset();
										},
							  beforeshow: function ( me, eOpts )	{
								SalesPlanStore.loadStoreRecords();
							 }
				}
			})
		}
		referSalesPlanWindow.show();
	}

	//판매계획 참조 모델 정의
	Unilite.defineModel('s_ppl100ukrv_jwSalesPlanModel', {
		fields: [
			{name: 'GUBUN'				, text: '<t:message code="system.label.product.selection" default="선택"/>'			, type: 'string'},
			{name: 'PLAN_TYPE'			, text: '<t:message code="system.label.product.typecode" default="유형코드"/>'			, type: 'string'},
			{name: 'PLANTYPE_NAME'		, text: '<t:message code="system.label.product.type" default="유형"/>'				, type: 'string'},
			{name: 'ITEM_ACCOUNT'		, text: '<t:message code="system.label.product.itemaccount" default="품목계정"/>'		, type: 'string' , comboType:'AU', comboCode:'B020'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.product.item" default="품목"/>'				, type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.product.itemname" default="품목명"/>'			, type: 'string'},
			{name: 'STOCK_UNIT'			, text: '<t:message code="system.label.product.inventoryunit" default="재고단위"/>'		, type: 'string'},
			{name: 'PLAN_QTY'			, text: '<t:message code="system.label.product.planqty" default="계획량"/>'			, type: 'uniQty'},
			{name: 'NOTREF_Q'			, text: '<t:message code="system.label.product.noplanqty" default="미계획량"/>'			, type: 'uniQty'},
			{name: 'BASE_DATE'			, text: '<t:message code="system.label.product.basisdate" default="기준일"/>'			, type: 'uniDate'},
			{name: 'SALE_TYPE'			, text: '<t:message code="system.label.product.salestype" default="판매유형"/>'			, type: 'string'},
			{name: 'WORK_SHOP_CODE'		, text: '<t:message code="system.label.product.mainworkcenter" default="주작업장"/>'	, type: 'string'},
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.product.workcenter" default="작업장"/>'			, type: 'string'},
			{name: 'ORDER_NUM'			, text: '<t:message code="system.label.product.sono" default="수주번호"/>'				, type: 'string'},
			{name: 'SER_NO'				, text: '<t:message code="system.label.product.soseq" default="수주순번"/>'				, type: 'string'},
			{name: 'ORDER_Q'			, text: '<t:message code="system.label.product.soqty" default="수주량"/>'				, type: 'uniQty'}
		]
	});

	//판매계획 참조 스토어 정의
	var SalesPlanStore = Unilite.createStore('s_ppl100ukrv_jwSalesPlanStore', {
		model: 's_ppl100ukrv_jwSalesPlanModel',
		autoLoad: false,
			uniOpt : {
				isMaster: false,			// 상위 버튼 연결
				editable: false,			// 수정 모드 사용
				deletable:false,			// 삭제 가능 여부
				useNavi : false			// prev | next 버튼 사용
			},
			proxy: directProxy3
			,loadStoreRecords : function()	{
				var param= SalesPlanSearch.getValues();
				console.log( param );
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

			var paramMaster= SalesPlanSearch.getValues();	//syncAll 수정
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {

						if(panelResult.getValue('COM') == "적용"){
							OrderStore.loadStoreRecords();
							panelResult.setValue('COM', '');
						}
						else if(panelResult.getValue('COM') == "적용후닫기"){
							//OrderStore.loadStoreRecords();
							//masterStore.loadStoreRecords();
							var activeTabId = tab.getActiveTab().getId();
							if(activeTabId == 'masterGrid1'){
								masterStore1.loadStoreRecords();
							}
							if(activeTabId == 'masterGrid2'){
								masterStore2.loadStoreRecords();
							}
							panelResult.setValue('COM', '');
						}
					}
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('s_ppl100ukrv_jwSalesPlanGrid');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});

	/**
	 * 판매계획을 참조하기 위한 Search Form, Grid, Inner Window 정의
	 */
	//판매계획 참조 폼 정의
	var SalesPlanSearch = Unilite.createSearchForm('s_ppl100ukrv_jwSalesPlanForm', {
		layout :  {type : 'uniTable', columns : 4},
		items :[{
				fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
				name:'DIV_CODE',
				xtype: 'uniCombobox',
				comboType:'BOR120'
			}, {
				fieldLabel: '<t:message code="system.label.product.planperiod" default="계획기간"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'FROM_MONTH',
				endFieldName: 'TO_MONTH',
				width: 350,
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today')/*,
				allowBlank:false*/		/// 계획기간 폼 만들기 전까지 필수조건 제거
		   }, {
				fieldLabel: '<t:message code="system.label.product.salestype" default="판매유형"/>',
				name:'SALE_TYPE',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:''
		   }, {
				fieldLabel: '<t:message code="system.label.product.repmodel" default="대표모델"/>',
				name:'ITEM_GROUP',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:''
		   },{
				fieldLabel: '<t:message code="system.label.product.itemaccount" default="품목계정"/>',
				name:'ITEM_ACCOUNT',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'B020'
		   },{
				fieldLabel: '<t:message code="system.label.product.majorgroup" default="대분류"/>',
				name: 'TXTLV_L1',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('itemLeve1Store'),
				child: 'TXTLV_L2'
			},{
				fieldLabel: '<t:message code="system.label.product.middlegroup" default="중분류"/>',
				name: 'TXTLV_L2',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('itemLeve2Store'),
				child: 'TXTLV_L3'
			},{
				fieldLabel: '<t:message code="system.label.product.minorgroup" default="소분류"/>',
				name: 'TXTLV_L3',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('itemLeve3Store')
			},{
				fieldLabel: '<t:message code="system.label.product.sentence001" default="※ 생산계획계산시 가용재고(현재고+입고예정-출고예정-안전재고)반영여부"/>',
				xtype: 'uniRadiogroup',
				labelWidth:450,
				width: 235,
				colspan:3,
				items: [{
						boxLabel:'<t:message code="system.label.product.yes" default="예"/>',
						width:70,
						name:'PAD_STOCK_YN',
						inputValue:'Y'
					},{
						boxLabel:'<t:message code="system.label.product.no" default="아니오"/>',
						width:70,
						name:'PAD_STOCK_YN',
						inputValue:'N' ,
						checked:true
				}]
			}]
	});

	//판매계획 참조 그리드 정의
	var SalesPlanGrid = Unilite.createGrid('s_ppl100ukrv_jwSalesPlanGrid', {
		// title: '기본',
		layout : 'fit',
		region:'center',
		store: SalesPlanStore,
		selModel :   Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }),
			uniOpt:{
				onLoadSelectFirst : false
			},
		columns: [
			{ dataIndex: 'GUBUN'				, width: 40,  hidden: true},
			{ dataIndex: 'CHECK_YN'				, width: 40 ,  hidden: true},
			{ dataIndex: 'PLAN_TYPE'			, width: 40 , hidden: true},
			{ dataIndex: 'PLANTYPE_NAME'		, width: 100},
			{ dataIndex: 'ITEM_ACCOUNT'			, width: 66 },
			{ dataIndex: 'ITEM_CODE'			, width: 100},
			{ dataIndex: 'ITEM_NAME'			, width: 146},
			{ dataIndex: 'STOCK_UNIT'			, width: 66 },
			{ dataIndex: 'PLAN_QTY'				, width: 120},
			{ dataIndex: 'NOTREF_Q'				, width: 120},
			{ dataIndex: 'BASE_DATE'			, width: 100},
			{ dataIndex: 'SALE_TYPE'			, width: 100},
			{ dataIndex: 'WORK_SHOP_CODE'		, width: 66 , hidden: true},
			{ dataIndex: 'DIV_CODE'				, width: 100 , hidden: true},
			{ dataIndex: 'ORDER_NUM'			, width: 100 , hidden: true},
			{ dataIndex: 'SER_NO'				, width: 100 , hidden: true},
			{ dataIndex: 'ORDER_Q'				, width: 100 , hidden: true}
		],
		listeners: {
			onGridDblClick:function(grid, record, cellIndex, colName) {
			},
			deselect: function( model, record, index, eOpts ){
				record.set('CHECK_YN', '')
			},
			select: function( model, record, index, eOpts ){
				record.set('CHECK_YN', 'M')
			}
		}
	});



	function day_change(masterGrid){
		//var date=new Date(d);
		for (var i = 1; i <= 31; i++) {
			var column1=masterGrid.getColumn("DAY"+i+"_Q");
			console.log("column1.text",column1);
			if(column1.text== '<t:message code="system.label.product.sunday" default="일"/>'){
				column1.setStyle('color', 'red');
			} else if(column1.text== '<t:message code="system.label.product.saturday" default="토"/>'){
				column1.setStyle('color', 'blue');
			} else{
				column1.setStyle('color', 'black');
			}
		}
	}

	function getDate(d, masterGrid){
		var weekday=new Array(7);
		weekday[0]='<t:message code="system.label.product.sunday" default="일"/>';
		weekday[1]='<t:message code="system.label.product.monday" default="월"/>';
		weekday[2]='<t:message code="system.label.product.tuesday" default="화"/>';
		weekday[3]='<t:message code="system.label.product.wednesday" default="수"/>';
		weekday[4]='<t:message code="system.label.product.Thursday" default="목"/>';
		weekday[5]='<t:message code="system.label.product.Friday" default="금"/>';
		weekday[6]='<t:message code="system.label.product.saturday" default="토"/>';
		var date=new Date(d);
		//获取年份
		var year = date.getFullYear();
		//获取当前月份
		var mouth = date.getMonth() + 1;
		date.setMonth(date.getMonth() + 1);
		date.setDate(0);
		//定义当月的最后一天；
		var days=date.getDate();
		 if(days==31){
			var column=masterGrid.getColumn("DAY31_Q");
			var column2=masterGrid.getColumn("DAY30_Q");
			var column3=masterGrid.getColumn("DAY29_Q");
			column.show();
			column2.show();
			column3.show();
		 }
		if(days<31&&days==30){
			var column=masterGrid.getColumn("DAY31_Q");
			column.hide();
		}
		if(days<30&&days==29){
			var column=masterGrid.getColumn("DAY30_Q");
			var column2=masterGrid.getColumn("DAY31_Q");
			column.hide();
			column2.hide();
		}
		if(days<29&&days==28){
			var column=masterGrid.getColumn("DAY31_Q");
			var column2=masterGrid.getColumn("DAY30_Q");
			var column3=masterGrid.getColumn("DAY29_Q");
			column.hide();
			column2.hide();
			column3.hide();
		}
		for(var i=1;i<=days;i++){
			date.setDate(i);
			var column1=masterGrid.getColumn("DAY"+i+"_Q");
			column1.setText(weekday[date.getDay()]);
		}
		return weekday[date.getDay()];
	}



	var tab = Unilite.createTabPanel('tabPanel',{
		activeTab	: 0,
		region		: 'center',
		items		: [{
			title: '<t:message code="system.label.product.workcenterper" default="작업장별"/>',
			xtype:'container',
			layout:{type:'vbox', align:'stretch'},
			items:[masterGrid1],
			id: 'masterGrid1'
		},{
			title: '<t:message code="system.label.product.itemby" default="품목별"/>',
			xtype:'container',
			layout:{type:'vbox', align:'stretch'},
			items:[masterGrid2],
			id: 'masterGrid2'
		}],
		listeners : {
			tabChange : function ( tabPanel, newCard, oldCard, eOpts ) {
				var newTabId = newCard.getId();
					console.log("newCard : " + newCard.getId());
					console.log("oldCard : " + oldCard.getId());
				switch(newTabId){
					case 'masterGrid1' :
						panelResult.setValue('TYPE', 'W');
						masterStore1.loadStoreRecords();
						break;

					case 'masterGrid2' :
						panelResult.setValue('TYPE', 'I');
						masterStore2.loadStoreRecords();
						break;

					default:
						break;
				}
			}
		}
	});


	 /** main app
	 */
	Unilite.Main({
		id			: 's_ppl100ukrv_jwApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				tab, panelResult
			]
		}],
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons(['reset', 'newData', 'prev', 'next'], true);
			//masterGrid.disabledLinkButtons(false);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);

			var date=Ext.util.Format.date(panelResult.getValue('FR_DATE'), 'Y-m');
			getDate(date, masterGrid1);
			day_change(masterGrid1);

			getDate(date, masterGrid2);
			day_change(masterGrid2);
		},
		onQueryButtonDown: function() {
			if(panelResult.setAllFieldsReadOnly(true) == false){
				return false;
			} else {
				/* 화면오픈시 이미 수행한 로직.. 조회할시에는 불필요 해보임..
				 * var date=Ext.util.Format.date(masterForm.getValue('FR_DATE'), 'Y-m');
						getDate(date, masterGrid1);
						day_change(masterGrid1);
		
						getDate(date, masterGrid2);
						day_change(masterGrid2);*/

				var activeTabId = tab.getActiveTab().getId();
				if(activeTabId == 'masterGrid1'){
					masterStore1.loadStoreRecords();
				}
				if(activeTabId == 'masterGrid2'){
					masterStore2.loadStoreRecords();
				}
			}
		},
		onNewDataButtonDown: function()	{
			if(!this.checkForNewDetail())
				return false;
			var activeTabId = tab.getActiveTab().getId();
			var seq = 0;

			var compCode		= UserInfo.compCode
			var divCode			= panelResult.getValue('DIV_CODE');
			var workShopCode	= panelResult.getValue('WORK_SHOP_CODE');
			var prodtPlanDate	= UniDate.get('today');

			var r1 = {
				P_SEQ			: seq,			/* 순번 */
				COMP_CODE		: compCode,		/* 법인코드*/
				DIV_CODE		: divCode,		/* 사업장*/
				WORK_SHOP_CODE  : workShopCode,	/* 작업장 */
				PRODT_PLAN_DATE : prodtPlanDate,/* 계획정보 - 계획일 */
				GUBUN			: '<t:message code="system.label.product.plan" default="계획"/>',
				PLAN_TYPE		: 'P',
				REMARK			: '',
				ORDERN			: ''
			};

			if(activeTabId == 'masterGrid1'){
				masterGrid1.createRow(r1, '', -1);
			}
			if(activeTabId == 'masterGrid2'){
				masterGrid2.createRow(r1, '', -1);
			}

			panelResult.setAllFieldsReadOnly(false);
		},
		onResetButtonDown: function() {
			this.suspendEvents();

			var date=Ext.util.Format.date(panelResult.getValue('FR_DATE'), 'Y-m');
			getDate(date, masterGrid1);
			day_change(masterGrid1);

			getDate(date, masterGrid2);
			day_change(masterGrid2);

			panelResult.setAllFieldsReadOnly(false);
			var activeTabId = tab.getActiveTab().getId();
			if(activeTabId == 'masterGrid1'){
				masterGrid1.reset();
			}
			if(activeTabId == 'masterGrid2'){
				masterGrid2.reset();
			}
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {
			var activeTabId = tab.getActiveTab().getId();
			var mustVal = 0;
			if(activeTabId == 'masterGrid1'){
				var records = masterGrid1.getStore().data.items;
				 Ext.each(records, function(item, i)   {
					 if(Ext.isEmpty(item.get("WORK_SHOP_CODE")) && item.get("GUBUN") == '계획'){
						 mustVal = mustVal + 1;
					 }
				 })
				if(mustVal > 0){
					alert("작업장은 필수값입니다.");
					return false;
				}
				masterStore1.saveStore();
			}
			if(activeTabId == 'masterGrid2'){
				var records = masterGrid2.getStore().data.items;
				 Ext.each(records, function(item, i)   {
					 if(Ext.isEmpty(item.get("ITEM_CODE")) && item.get("GUBUN") == '계획'){
						 mustVal = mustVal + 1;
					 }
				 })
				if(mustVal > 0){
					alert("품목은 필수값입니다.");
					return false;
				}
				masterStore2.saveStore();
			}
		},
		onDeleteDataButtonDown: function() {
			var activeTabId = tab.getActiveTab().getId();
			if(activeTabId == 'masterGrid1'){
				this.deleteData(masterGrid1);
			}
			if(activeTabId == 'masterGrid2'){
				this.deleteData(masterGrid2);
			}
		},
		onDeleteAllButtonDown: function() {
		},
		onDetailButtonDown: function() {
			var as = Ext.getCmp('s_ppl100ukrv_jwAdvanceSerch');
			if(as.isHidden())	{
				as.show();
			} else {
				as.hide()
			}
		},
		deleteData : function(masterGrid){
/*			var model = masterGrid.getSelectionModel();
			var selRow = masterGrid.getSelectedRecord();
			var rowIndex = masterGrid.getSelectedRowIndex();
	
			if(selRow.get("GUBUN") == '<t:message code="system.label.product.plan" default="계획"/>'){
				model.selectRange(rowIndex, rowIndex+2);
			}else if(selRow.get("GUBUN") == '지시'){
				model.selectRange(rowIndex-1, rowIndex+1);
			}else{
				model.selectRange(rowIndex-2, rowIndex);
			}*/
			masterGrid.deleteSelectedRow();
		},
		checkForNewDetail:function() {
			if(Ext.isEmpty(panelResult.getValue('FR_DATE')) || Ext.isEmpty(panelResult.getValue('FR_DATE')))	{
				alert('<t:message code="system.message.product.datacheck001" default="필수입력 항목입니다."/>');
				return false;
			}
			//마스터 데이타 수정 못 하도록 설정
			return panelResult.setAllFieldsReadOnly(true);
		}
	});

		Unilite.createValidator('validator01', {
		store: masterStore1,
		grid: masterGrid1,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			var sumValue = 0;
			switch(fieldName) {
				case "ORDER_INFO" :
					if(record.get('GUBUN') == '<t:message code="system.label.product.plan" default="계획"/>' )	{
					//	record.set("ORDERN", newValue);
					}
				break;
				case "DAY1_Q" :
					if(record.get('GUBUN') == '<t:message code="system.label.product.plan" default="계획"/>'){
						if(newValue == ''){
							newValue = 0;
						}
						sumValue = 0;

						sumValue =
						sumValue
						+newValue
						+record.get('DAY2_Q')
						+record.get('DAY3_Q')
						+record.get('DAY4_Q')
						+record.get('DAY5_Q')
						+record.get('DAY6_Q')
						+record.get('DAY7_Q')
						+record.get('DAY8_Q')
						+record.get('DAY9_Q')
						+record.get('DAY10_Q')
						+record.get('DAY11_Q')
						+record.get('DAY12_Q')
						+record.get('DAY13_Q')
						+record.get('DAY14_Q')
						+record.get('DAY15_Q')
						+record.get('DAY16_Q')
						+record.get('DAY17_Q')
						+record.get('DAY18_Q')
						+record.get('DAY19_Q')
						+record.get('DAY20_Q')
						+record.get('DAY21_Q')
						+record.get('DAY22_Q')
						+record.get('DAY23_Q')
						+record.get('DAY24_Q')
						+record.get('DAY25_Q')
						+record.get('DAY26_Q')
						+record.get('DAY27_Q')
						+record.get('DAY28_Q')
						+record.get('DAY29_Q')
						+record.get('DAY30_Q')
						+record.get('DAY31_Q');


						record.set('TOT_Q',sumValue);

				break;
					}
				break;

				case "DAY2_Q" :
					if(record.get('GUBUN') == '<t:message code="system.label.product.plan" default="계획"/>'){
						if(newValue == ''){
							newValue = 0;
						}
						sumValue = 0;

						sumValue =
						sumValue
						+record.get('DAY1_Q')
						+newValue
						+record.get('DAY3_Q')
						+record.get('DAY4_Q')
						+record.get('DAY5_Q')
						+record.get('DAY6_Q')
						+record.get('DAY7_Q')
						+record.get('DAY8_Q')
						+record.get('DAY9_Q')
						+record.get('DAY10_Q')
						+record.get('DAY11_Q')
						+record.get('DAY12_Q')
						+record.get('DAY13_Q')
						+record.get('DAY14_Q')
						+record.get('DAY15_Q')
						+record.get('DAY16_Q')
						+record.get('DAY17_Q')
						+record.get('DAY18_Q')
						+record.get('DAY19_Q')
						+record.get('DAY20_Q')
						+record.get('DAY21_Q')
						+record.get('DAY22_Q')
						+record.get('DAY23_Q')
						+record.get('DAY24_Q')
						+record.get('DAY25_Q')
						+record.get('DAY26_Q')
						+record.get('DAY27_Q')
						+record.get('DAY28_Q')
						+record.get('DAY29_Q')
						+record.get('DAY30_Q')
						+record.get('DAY31_Q');


						record.set('TOT_Q',sumValue);

				break;
					}
				break;

				case "DAY3_Q" :
					if(record.get('GUBUN') == '<t:message code="system.label.product.plan" default="계획"/>'){
						if(newValue == ''){
							newValue = 0;
						}
						sumValue = 0;

						sumValue =
						sumValue
						+record.get('DAY1_Q')
						+record.get('DAY2_Q')
						+newValue
						+record.get('DAY4_Q')
						+record.get('DAY5_Q')
						+record.get('DAY6_Q')
						+record.get('DAY7_Q')
						+record.get('DAY8_Q')
						+record.get('DAY9_Q')
						+record.get('DAY10_Q')
						+record.get('DAY11_Q')
						+record.get('DAY12_Q')
						+record.get('DAY13_Q')
						+record.get('DAY14_Q')
						+record.get('DAY15_Q')
						+record.get('DAY16_Q')
						+record.get('DAY17_Q')
						+record.get('DAY18_Q')
						+record.get('DAY19_Q')
						+record.get('DAY20_Q')
						+record.get('DAY21_Q')
						+record.get('DAY22_Q')
						+record.get('DAY23_Q')
						+record.get('DAY24_Q')
						+record.get('DAY25_Q')
						+record.get('DAY26_Q')
						+record.get('DAY27_Q')
						+record.get('DAY28_Q')
						+record.get('DAY29_Q')
						+record.get('DAY30_Q')
						+record.get('DAY31_Q');


						record.set('TOT_Q',sumValue);

				break;
					}
				break;

				case "DAY4_Q" :
					if(record.get('GUBUN') == '<t:message code="system.label.product.plan" default="계획"/>'){
						if(newValue == ''){
							newValue = 0;
						}
						sumValue = 0;

						sumValue =
						sumValue
						+record.get('DAY1_Q')
						+record.get('DAY2_Q')
						+record.get('DAY3_Q')
						+newValue
						+record.get('DAY5_Q')
						+record.get('DAY6_Q')
						+record.get('DAY7_Q')
						+record.get('DAY8_Q')
						+record.get('DAY9_Q')
						+record.get('DAY10_Q')
						+record.get('DAY11_Q')
						+record.get('DAY12_Q')
						+record.get('DAY13_Q')
						+record.get('DAY14_Q')
						+record.get('DAY15_Q')
						+record.get('DAY16_Q')
						+record.get('DAY17_Q')
						+record.get('DAY18_Q')
						+record.get('DAY19_Q')
						+record.get('DAY20_Q')
						+record.get('DAY21_Q')
						+record.get('DAY22_Q')
						+record.get('DAY23_Q')
						+record.get('DAY24_Q')
						+record.get('DAY25_Q')
						+record.get('DAY26_Q')
						+record.get('DAY27_Q')
						+record.get('DAY28_Q')
						+record.get('DAY29_Q')
						+record.get('DAY30_Q')
						+record.get('DAY31_Q');


						record.set('TOT_Q',sumValue);

				break;
					}
				break;

				case "DAY5_Q" :
					if(record.get('GUBUN') == '<t:message code="system.label.product.plan" default="계획"/>'){
						if(newValue == ''){
							newValue = 0;
						}
						sumValue = 0;

						sumValue =
						sumValue
						+record.get('DAY1_Q')
						+record.get('DAY2_Q')
						+record.get('DAY3_Q')
						+record.get('DAY4_Q')
						+newValue
						+record.get('DAY6_Q')
						+record.get('DAY7_Q')
						+record.get('DAY8_Q')
						+record.get('DAY9_Q')
						+record.get('DAY10_Q')
						+record.get('DAY11_Q')
						+record.get('DAY12_Q')
						+record.get('DAY13_Q')
						+record.get('DAY14_Q')
						+record.get('DAY15_Q')
						+record.get('DAY16_Q')
						+record.get('DAY17_Q')
						+record.get('DAY18_Q')
						+record.get('DAY19_Q')
						+record.get('DAY20_Q')
						+record.get('DAY21_Q')
						+record.get('DAY22_Q')
						+record.get('DAY23_Q')
						+record.get('DAY24_Q')
						+record.get('DAY25_Q')
						+record.get('DAY26_Q')
						+record.get('DAY27_Q')
						+record.get('DAY28_Q')
						+record.get('DAY29_Q')
						+record.get('DAY30_Q')
						+record.get('DAY31_Q');


						record.set('TOT_Q',sumValue);

				break;
					}
				break;

				case "DAY6_Q" :
					if(record.get('GUBUN') == '<t:message code="system.label.product.plan" default="계획"/>'){
						if(newValue == ''){
							newValue = 0;
						}
						sumValue = 0;

						sumValue =
						sumValue
						+record.get('DAY1_Q')
						+record.get('DAY2_Q')
						+record.get('DAY3_Q')
						+record.get('DAY4_Q')
						+record.get('DAY5_Q')
						+newValue
						+record.get('DAY7_Q')
						+record.get('DAY8_Q')
						+record.get('DAY9_Q')
						+record.get('DAY10_Q')
						+record.get('DAY11_Q')
						+record.get('DAY12_Q')
						+record.get('DAY13_Q')
						+record.get('DAY14_Q')
						+record.get('DAY15_Q')
						+record.get('DAY16_Q')
						+record.get('DAY17_Q')
						+record.get('DAY18_Q')
						+record.get('DAY19_Q')
						+record.get('DAY20_Q')
						+record.get('DAY21_Q')
						+record.get('DAY22_Q')
						+record.get('DAY23_Q')
						+record.get('DAY24_Q')
						+record.get('DAY25_Q')
						+record.get('DAY26_Q')
						+record.get('DAY27_Q')
						+record.get('DAY28_Q')
						+record.get('DAY29_Q')
						+record.get('DAY30_Q')
						+record.get('DAY31_Q');


						record.set('TOT_Q',sumValue);

				break;
					}
				break;

				case "DAY7_Q" :
					if(record.get('GUBUN') == '<t:message code="system.label.product.plan" default="계획"/>'){
						if(newValue == ''){
							newValue = 0;
						}
						sumValue = 0;

						sumValue =
						sumValue
						+record.get('DAY1_Q')
						+record.get('DAY2_Q')
						+record.get('DAY3_Q')
						+record.get('DAY4_Q')
						+record.get('DAY5_Q')
						+record.get('DAY6_Q')
						+newValue
						+record.get('DAY8_Q')
						+record.get('DAY9_Q')
						+record.get('DAY10_Q')
						+record.get('DAY11_Q')
						+record.get('DAY12_Q')
						+record.get('DAY13_Q')
						+record.get('DAY14_Q')
						+record.get('DAY15_Q')
						+record.get('DAY16_Q')
						+record.get('DAY17_Q')
						+record.get('DAY18_Q')
						+record.get('DAY19_Q')
						+record.get('DAY20_Q')
						+record.get('DAY21_Q')
						+record.get('DAY22_Q')
						+record.get('DAY23_Q')
						+record.get('DAY24_Q')
						+record.get('DAY25_Q')
						+record.get('DAY26_Q')
						+record.get('DAY27_Q')
						+record.get('DAY28_Q')
						+record.get('DAY29_Q')
						+record.get('DAY30_Q')
						+record.get('DAY31_Q');


						record.set('TOT_Q',sumValue);

				break;
					}
				break;

				case "DAY8_Q" :
					if(record.get('GUBUN') == '<t:message code="system.label.product.plan" default="계획"/>'){
						if(newValue == ''){
							newValue = 0;
						}
						sumValue = 0;

						sumValue =
						sumValue
						+record.get('DAY1_Q')
						+record.get('DAY2_Q')
						+record.get('DAY3_Q')
						+record.get('DAY4_Q')
						+record.get('DAY5_Q')
						+record.get('DAY6_Q')
						+record.get('DAY7_Q')
						+newValue
						+record.get('DAY9_Q')
						+record.get('DAY10_Q')
						+record.get('DAY11_Q')
						+record.get('DAY12_Q')
						+record.get('DAY13_Q')
						+record.get('DAY14_Q')
						+record.get('DAY15_Q')
						+record.get('DAY16_Q')
						+record.get('DAY17_Q')
						+record.get('DAY18_Q')
						+record.get('DAY19_Q')
						+record.get('DAY20_Q')
						+record.get('DAY21_Q')
						+record.get('DAY22_Q')
						+record.get('DAY23_Q')
						+record.get('DAY24_Q')
						+record.get('DAY25_Q')
						+record.get('DAY26_Q')
						+record.get('DAY27_Q')
						+record.get('DAY28_Q')
						+record.get('DAY29_Q')
						+record.get('DAY30_Q')
						+record.get('DAY31_Q');


						record.set('TOT_Q',sumValue);

				break;
					}
				break;

				case "DAY9_Q" :
					if(record.get('GUBUN') == '<t:message code="system.label.product.plan" default="계획"/>'){
						if(newValue == ''){
							newValue = 0;
						}
						sumValue = 0;

						sumValue =
						sumValue
						+record.get('DAY1_Q')
						+record.get('DAY2_Q')
						+record.get('DAY3_Q')
						+record.get('DAY4_Q')
						+record.get('DAY5_Q')
						+record.get('DAY6_Q')
						+record.get('DAY7_Q')
						+record.get('DAY8_Q')
						+newValue
						+record.get('DAY10_Q')
						+record.get('DAY11_Q')
						+record.get('DAY12_Q')
						+record.get('DAY13_Q')
						+record.get('DAY14_Q')
						+record.get('DAY15_Q')
						+record.get('DAY16_Q')
						+record.get('DAY17_Q')
						+record.get('DAY18_Q')
						+record.get('DAY19_Q')
						+record.get('DAY20_Q')
						+record.get('DAY21_Q')
						+record.get('DAY22_Q')
						+record.get('DAY23_Q')
						+record.get('DAY24_Q')
						+record.get('DAY25_Q')
						+record.get('DAY26_Q')
						+record.get('DAY27_Q')
						+record.get('DAY28_Q')
						+record.get('DAY29_Q')
						+record.get('DAY30_Q')
						+record.get('DAY31_Q');


						record.set('TOT_Q',sumValue);

				break;
					}
				break;

				case "DAY10_Q" :
					if(record.get('GUBUN') == '<t:message code="system.label.product.plan" default="계획"/>'){
						if(newValue == ''){
							newValue = 0;
						}
						sumValue = 0;

						sumValue =
						sumValue
						+record.get('DAY1_Q')
						+record.get('DAY2_Q')
						+record.get('DAY3_Q')
						+record.get('DAY4_Q')
						+record.get('DAY5_Q')
						+record.get('DAY6_Q')
						+record.get('DAY7_Q')
						+record.get('DAY8_Q')
						+record.get('DAY9_Q')
						+newValue
						+record.get('DAY11_Q')
						+record.get('DAY12_Q')
						+record.get('DAY13_Q')
						+record.get('DAY14_Q')
						+record.get('DAY15_Q')
						+record.get('DAY16_Q')
						+record.get('DAY17_Q')
						+record.get('DAY18_Q')
						+record.get('DAY19_Q')
						+record.get('DAY20_Q')
						+record.get('DAY21_Q')
						+record.get('DAY22_Q')
						+record.get('DAY23_Q')
						+record.get('DAY24_Q')
						+record.get('DAY25_Q')
						+record.get('DAY26_Q')
						+record.get('DAY27_Q')
						+record.get('DAY28_Q')
						+record.get('DAY29_Q')
						+record.get('DAY30_Q')
						+record.get('DAY31_Q');


						record.set('TOT_Q',sumValue);

				break;
					}
				break;

				case "DAY11_Q" :
					if(record.get('GUBUN') == '<t:message code="system.label.product.plan" default="계획"/>'){
						if(newValue == ''){
							newValue = 0;
						}
						sumValue = 0;

						sumValue =
						sumValue
						+record.get('DAY1_Q')
						+record.get('DAY2_Q')
						+record.get('DAY3_Q')
						+record.get('DAY4_Q')
						+record.get('DAY5_Q')
						+record.get('DAY6_Q')
						+record.get('DAY7_Q')
						+record.get('DAY8_Q')
						+record.get('DAY9_Q')
						+record.get('DAY10_Q')
						+newValue
						+record.get('DAY12_Q')
						+record.get('DAY13_Q')
						+record.get('DAY14_Q')
						+record.get('DAY15_Q')
						+record.get('DAY16_Q')
						+record.get('DAY17_Q')
						+record.get('DAY18_Q')
						+record.get('DAY19_Q')
						+record.get('DAY20_Q')
						+record.get('DAY21_Q')
						+record.get('DAY22_Q')
						+record.get('DAY23_Q')
						+record.get('DAY24_Q')
						+record.get('DAY25_Q')
						+record.get('DAY26_Q')
						+record.get('DAY27_Q')
						+record.get('DAY28_Q')
						+record.get('DAY29_Q')
						+record.get('DAY30_Q')
						+record.get('DAY31_Q');


						record.set('TOT_Q',sumValue);

				break;
					}
				break;

				case "DAY12_Q" :
					if(record.get('GUBUN') == '<t:message code="system.label.product.plan" default="계획"/>'){
						if(newValue == ''){
							newValue = 0;
						}
						sumValue = 0;

						sumValue =
						sumValue
						+record.get('DAY1_Q')
						+record.get('DAY2_Q')
						+record.get('DAY3_Q')
						+record.get('DAY4_Q')
						+record.get('DAY5_Q')
						+record.get('DAY6_Q')
						+record.get('DAY7_Q')
						+record.get('DAY8_Q')
						+record.get('DAY9_Q')
						+record.get('DAY10_Q')
						+record.get('DAY11_Q')
						+newValue
						+record.get('DAY13_Q')
						+record.get('DAY14_Q')
						+record.get('DAY15_Q')
						+record.get('DAY16_Q')
						+record.get('DAY17_Q')
						+record.get('DAY18_Q')
						+record.get('DAY19_Q')
						+record.get('DAY20_Q')
						+record.get('DAY21_Q')
						+record.get('DAY22_Q')
						+record.get('DAY23_Q')
						+record.get('DAY24_Q')
						+record.get('DAY25_Q')
						+record.get('DAY26_Q')
						+record.get('DAY27_Q')
						+record.get('DAY28_Q')
						+record.get('DAY29_Q')
						+record.get('DAY30_Q')
						+record.get('DAY31_Q');


						record.set('TOT_Q',sumValue);

				break;
					}
				break;

				case "DAY13_Q" :
					if(record.get('GUBUN') == '<t:message code="system.label.product.plan" default="계획"/>'){
						if(newValue == ''){
							newValue = 0;
						}
						sumValue = 0;

						sumValue =
						sumValue
						+record.get('DAY1_Q')
						+record.get('DAY2_Q')
						+record.get('DAY3_Q')
						+record.get('DAY4_Q')
						+record.get('DAY5_Q')
						+record.get('DAY6_Q')
						+record.get('DAY7_Q')
						+record.get('DAY8_Q')
						+record.get('DAY9_Q')
						+record.get('DAY10_Q')
						+record.get('DAY11_Q')
						+record.get('DAY12_Q')
						+newValue
						+record.get('DAY14_Q')
						+record.get('DAY15_Q')
						+record.get('DAY16_Q')
						+record.get('DAY17_Q')
						+record.get('DAY18_Q')
						+record.get('DAY19_Q')
						+record.get('DAY20_Q')
						+record.get('DAY21_Q')
						+record.get('DAY22_Q')
						+record.get('DAY23_Q')
						+record.get('DAY24_Q')
						+record.get('DAY25_Q')
						+record.get('DAY26_Q')
						+record.get('DAY27_Q')
						+record.get('DAY28_Q')
						+record.get('DAY29_Q')
						+record.get('DAY30_Q')
						+record.get('DAY31_Q');


						record.set('TOT_Q',sumValue);

				break;
					}
				break;

				case "DAY14_Q" :
					if(record.get('GUBUN') == '<t:message code="system.label.product.plan" default="계획"/>'){
						if(newValue == ''){
							newValue = 0;
						}
						sumValue = 0;

						sumValue =
						sumValue
						+record.get('DAY1_Q')
						+record.get('DAY2_Q')
						+record.get('DAY3_Q')
						+record.get('DAY4_Q')
						+record.get('DAY5_Q')
						+record.get('DAY6_Q')
						+record.get('DAY7_Q')
						+record.get('DAY8_Q')
						+record.get('DAY9_Q')
						+record.get('DAY10_Q')
						+record.get('DAY11_Q')
						+record.get('DAY12_Q')
						+record.get('DAY13_Q')
						+newValue
						+record.get('DAY15_Q')
						+record.get('DAY16_Q')
						+record.get('DAY17_Q')
						+record.get('DAY18_Q')
						+record.get('DAY19_Q')
						+record.get('DAY20_Q')
						+record.get('DAY21_Q')
						+record.get('DAY22_Q')
						+record.get('DAY23_Q')
						+record.get('DAY24_Q')
						+record.get('DAY25_Q')
						+record.get('DAY26_Q')
						+record.get('DAY27_Q')
						+record.get('DAY28_Q')
						+record.get('DAY29_Q')
						+record.get('DAY30_Q')
						+record.get('DAY31_Q');


						record.set('TOT_Q',sumValue);

				break;
					}
				break;

				case "DAY15_Q" :
					if(record.get('GUBUN') == '<t:message code="system.label.product.plan" default="계획"/>'){
						if(newValue == ''){
							newValue = 0;
						}
						sumValue = 0;

						sumValue =
						sumValue
						+record.get('DAY1_Q')
						+record.get('DAY2_Q')
						+record.get('DAY3_Q')
						+record.get('DAY4_Q')
						+record.get('DAY5_Q')
						+record.get('DAY6_Q')
						+record.get('DAY7_Q')
						+record.get('DAY8_Q')
						+record.get('DAY9_Q')
						+record.get('DAY10_Q')
						+record.get('DAY11_Q')
						+record.get('DAY12_Q')
						+record.get('DAY13_Q')
						+record.get('DAY14_Q')
						+newValue
						+record.get('DAY16_Q')
						+record.get('DAY17_Q')
						+record.get('DAY18_Q')
						+record.get('DAY19_Q')
						+record.get('DAY20_Q')
						+record.get('DAY21_Q')
						+record.get('DAY22_Q')
						+record.get('DAY23_Q')
						+record.get('DAY24_Q')
						+record.get('DAY25_Q')
						+record.get('DAY26_Q')
						+record.get('DAY27_Q')
						+record.get('DAY28_Q')
						+record.get('DAY29_Q')
						+record.get('DAY30_Q')
						+record.get('DAY31_Q');


						record.set('TOT_Q',sumValue);

				break;
					}
				break;

				case "DAY16_Q" :
					if(record.get('GUBUN') == '<t:message code="system.label.product.plan" default="계획"/>'){
						if(newValue == ''){
							newValue = 0;
						}
						sumValue = 0;

						sumValue =
						sumValue
						+record.get('DAY1_Q')
						+record.get('DAY2_Q')
						+record.get('DAY3_Q')
						+record.get('DAY4_Q')
						+record.get('DAY5_Q')
						+record.get('DAY6_Q')
						+record.get('DAY7_Q')
						+record.get('DAY8_Q')
						+record.get('DAY9_Q')
						+record.get('DAY10_Q')
						+record.get('DAY11_Q')
						+record.get('DAY12_Q')
						+record.get('DAY13_Q')
						+record.get('DAY14_Q')
						+record.get('DAY15_Q')
						+newValue
						+record.get('DAY17_Q')
						+record.get('DAY18_Q')
						+record.get('DAY19_Q')
						+record.get('DAY20_Q')
						+record.get('DAY21_Q')
						+record.get('DAY22_Q')
						+record.get('DAY23_Q')
						+record.get('DAY24_Q')
						+record.get('DAY25_Q')
						+record.get('DAY26_Q')
						+record.get('DAY27_Q')
						+record.get('DAY28_Q')
						+record.get('DAY29_Q')
						+record.get('DAY30_Q')
						+record.get('DAY31_Q');


						record.set('TOT_Q',sumValue);

				break;
					}
				break;

				case "DAY17_Q" :
					if(record.get('GUBUN') == '<t:message code="system.label.product.plan" default="계획"/>'){
						if(newValue == ''){
							newValue = 0;
						}
						sumValue = 0;

						sumValue =
						sumValue
						+record.get('DAY1_Q')
						+record.get('DAY2_Q')
						+record.get('DAY3_Q')
						+record.get('DAY4_Q')
						+record.get('DAY5_Q')
						+record.get('DAY6_Q')
						+record.get('DAY7_Q')
						+record.get('DAY8_Q')
						+record.get('DAY9_Q')
						+record.get('DAY10_Q')
						+record.get('DAY11_Q')
						+record.get('DAY12_Q')
						+record.get('DAY13_Q')
						+record.get('DAY14_Q')
						+record.get('DAY15_Q')
						+record.get('DAY16_Q')
						+newValue
						+record.get('DAY18_Q')
						+record.get('DAY19_Q')
						+record.get('DAY20_Q')
						+record.get('DAY21_Q')
						+record.get('DAY22_Q')
						+record.get('DAY23_Q')
						+record.get('DAY24_Q')
						+record.get('DAY25_Q')
						+record.get('DAY26_Q')
						+record.get('DAY27_Q')
						+record.get('DAY28_Q')
						+record.get('DAY29_Q')
						+record.get('DAY30_Q')
						+record.get('DAY31_Q');


						record.set('TOT_Q',sumValue);

				break;
					}
				break;

				case "DAY18_Q" :
					if(record.get('GUBUN') == '<t:message code="system.label.product.plan" default="계획"/>'){
						if(newValue == ''){
							newValue = 0;
						}
						sumValue = 0;

						sumValue =
						sumValue
						+record.get('DAY1_Q')
						+record.get('DAY2_Q')
						+record.get('DAY3_Q')
						+record.get('DAY4_Q')
						+record.get('DAY5_Q')
						+record.get('DAY6_Q')
						+record.get('DAY7_Q')
						+record.get('DAY8_Q')
						+record.get('DAY9_Q')
						+record.get('DAY10_Q')
						+record.get('DAY11_Q')
						+record.get('DAY12_Q')
						+record.get('DAY13_Q')
						+record.get('DAY14_Q')
						+record.get('DAY15_Q')
						+record.get('DAY16_Q')
						+record.get('DAY17_Q')
						+newValue
						+record.get('DAY19_Q')
						+record.get('DAY20_Q')
						+record.get('DAY21_Q')
						+record.get('DAY22_Q')
						+record.get('DAY23_Q')
						+record.get('DAY24_Q')
						+record.get('DAY25_Q')
						+record.get('DAY26_Q')
						+record.get('DAY27_Q')
						+record.get('DAY28_Q')
						+record.get('DAY29_Q')
						+record.get('DAY30_Q')
						+record.get('DAY31_Q');


						record.set('TOT_Q',sumValue);

				break;
					}
				break;

				case "DAY19_Q" :
					if(record.get('GUBUN') == '<t:message code="system.label.product.plan" default="계획"/>'){
						if(newValue == ''){
							newValue = 0;
						}
						sumValue = 0;

						sumValue =
						sumValue
						+record.get('DAY1_Q')
						+record.get('DAY2_Q')
						+record.get('DAY3_Q')
						+record.get('DAY4_Q')
						+record.get('DAY5_Q')
						+record.get('DAY6_Q')
						+record.get('DAY7_Q')
						+record.get('DAY8_Q')
						+record.get('DAY9_Q')
						+record.get('DAY10_Q')
						+record.get('DAY11_Q')
						+record.get('DAY12_Q')
						+record.get('DAY13_Q')
						+record.get('DAY14_Q')
						+record.get('DAY15_Q')
						+record.get('DAY16_Q')
						+record.get('DAY17_Q')
						+record.get('DAY18_Q')
						+newValue
						+record.get('DAY20_Q')
						+record.get('DAY21_Q')
						+record.get('DAY22_Q')
						+record.get('DAY23_Q')
						+record.get('DAY24_Q')
						+record.get('DAY25_Q')
						+record.get('DAY26_Q')
						+record.get('DAY27_Q')
						+record.get('DAY28_Q')
						+record.get('DAY29_Q')
						+record.get('DAY30_Q')
						+record.get('DAY31_Q');


						record.set('TOT_Q',sumValue);

				break;
					}
				break;

				case "DAY20_Q" :
					if(record.get('GUBUN') == '<t:message code="system.label.product.plan" default="계획"/>'){
						if(newValue == ''){
							newValue = 0;
						}
						sumValue = 0;

						sumValue =
						sumValue
						+record.get('DAY1_Q')
						+record.get('DAY2_Q')
						+record.get('DAY3_Q')
						+record.get('DAY4_Q')
						+record.get('DAY5_Q')
						+record.get('DAY6_Q')
						+record.get('DAY7_Q')
						+record.get('DAY8_Q')
						+record.get('DAY9_Q')
						+record.get('DAY10_Q')
						+record.get('DAY11_Q')
						+record.get('DAY12_Q')
						+record.get('DAY13_Q')
						+record.get('DAY14_Q')
						+record.get('DAY15_Q')
						+record.get('DAY16_Q')
						+record.get('DAY17_Q')
						+record.get('DAY18_Q')
						+record.get('DAY19_Q')
						+newValue
						+record.get('DAY21_Q')
						+record.get('DAY22_Q')
						+record.get('DAY23_Q')
						+record.get('DAY24_Q')
						+record.get('DAY25_Q')
						+record.get('DAY26_Q')
						+record.get('DAY27_Q')
						+record.get('DAY28_Q')
						+record.get('DAY29_Q')
						+record.get('DAY30_Q')
						+record.get('DAY31_Q');


						record.set('TOT_Q',sumValue);

				break;
					}
				break;

				case "DAY21_Q" :
					if(record.get('GUBUN') == '<t:message code="system.label.product.plan" default="계획"/>'){
						if(newValue == ''){
							newValue = 0;
						}
						sumValue = 0;

						sumValue =
						sumValue
						+record.get('DAY1_Q')
						+record.get('DAY2_Q')
						+record.get('DAY3_Q')
						+record.get('DAY4_Q')
						+record.get('DAY5_Q')
						+record.get('DAY6_Q')
						+record.get('DAY7_Q')
						+record.get('DAY8_Q')
						+record.get('DAY9_Q')
						+record.get('DAY10_Q')
						+record.get('DAY11_Q')
						+record.get('DAY12_Q')
						+record.get('DAY13_Q')
						+record.get('DAY14_Q')
						+record.get('DAY15_Q')
						+record.get('DAY16_Q')
						+record.get('DAY17_Q')
						+record.get('DAY18_Q')
						+record.get('DAY19_Q')
						+record.get('DAY20_Q')
						+newValue
						+record.get('DAY22_Q')
						+record.get('DAY23_Q')
						+record.get('DAY24_Q')
						+record.get('DAY25_Q')
						+record.get('DAY26_Q')
						+record.get('DAY27_Q')
						+record.get('DAY28_Q')
						+record.get('DAY29_Q')
						+record.get('DAY30_Q')
						+record.get('DAY31_Q');


						record.set('TOT_Q',sumValue);

				break;
					}
				break;

				case "DAY22_Q" :
					if(record.get('GUBUN') == '<t:message code="system.label.product.plan" default="계획"/>'){
						if(newValue == ''){
							newValue = 0;
						}
						sumValue = 0;

						sumValue =
						sumValue
						+record.get('DAY1_Q')
						+record.get('DAY2_Q')
						+record.get('DAY3_Q')
						+record.get('DAY4_Q')
						+record.get('DAY5_Q')
						+record.get('DAY6_Q')
						+record.get('DAY7_Q')
						+record.get('DAY8_Q')
						+record.get('DAY9_Q')
						+record.get('DAY10_Q')
						+record.get('DAY11_Q')
						+record.get('DAY12_Q')
						+record.get('DAY13_Q')
						+record.get('DAY14_Q')
						+record.get('DAY15_Q')
						+record.get('DAY16_Q')
						+record.get('DAY17_Q')
						+record.get('DAY18_Q')
						+record.get('DAY19_Q')
						+record.get('DAY20_Q')
						+record.get('DAY21_Q')
						+newValue
						+record.get('DAY23_Q')
						+record.get('DAY24_Q')
						+record.get('DAY25_Q')
						+record.get('DAY26_Q')
						+record.get('DAY27_Q')
						+record.get('DAY28_Q')
						+record.get('DAY29_Q')
						+record.get('DAY30_Q')
						+record.get('DAY31_Q');


						record.set('TOT_Q',sumValue);

				break;
					}
				break;

				case "DAY23_Q" :
					if(record.get('GUBUN') == '<t:message code="system.label.product.plan" default="계획"/>'){
						if(newValue == ''){
							newValue = 0;
						}
						sumValue = 0;

						sumValue =
						sumValue
						+record.get('DAY1_Q')
						+record.get('DAY2_Q')
						+record.get('DAY3_Q')
						+record.get('DAY4_Q')
						+record.get('DAY5_Q')
						+record.get('DAY6_Q')
						+record.get('DAY7_Q')
						+record.get('DAY8_Q')
						+record.get('DAY9_Q')
						+record.get('DAY10_Q')
						+record.get('DAY11_Q')
						+record.get('DAY12_Q')
						+record.get('DAY13_Q')
						+record.get('DAY14_Q')
						+record.get('DAY15_Q')
						+record.get('DAY16_Q')
						+record.get('DAY17_Q')
						+record.get('DAY18_Q')
						+record.get('DAY19_Q')
						+record.get('DAY20_Q')
						+record.get('DAY21_Q')
						+record.get('DAY22_Q')
						+newValue
						+record.get('DAY24_Q')
						+record.get('DAY25_Q')
						+record.get('DAY26_Q')
						+record.get('DAY27_Q')
						+record.get('DAY28_Q')
						+record.get('DAY29_Q')
						+record.get('DAY30_Q')
						+record.get('DAY31_Q');


						record.set('TOT_Q',sumValue);

				break;
					}
				break;

				case "DAY24_Q" :
					if(record.get('GUBUN') == '<t:message code="system.label.product.plan" default="계획"/>'){
						if(newValue == ''){
							newValue = 0;
						}
						sumValue = 0;

						sumValue =
						sumValue
						+record.get('DAY1_Q')
						+record.get('DAY2_Q')
						+record.get('DAY3_Q')
						+record.get('DAY4_Q')
						+record.get('DAY5_Q')
						+record.get('DAY6_Q')
						+record.get('DAY7_Q')
						+record.get('DAY8_Q')
						+record.get('DAY9_Q')
						+record.get('DAY10_Q')
						+record.get('DAY11_Q')
						+record.get('DAY12_Q')
						+record.get('DAY13_Q')
						+record.get('DAY14_Q')
						+record.get('DAY15_Q')
						+record.get('DAY16_Q')
						+record.get('DAY17_Q')
						+record.get('DAY18_Q')
						+record.get('DAY19_Q')
						+record.get('DAY20_Q')
						+record.get('DAY21_Q')
						+record.get('DAY22_Q')
						+record.get('DAY23_Q')
						+newValue
						+record.get('DAY25_Q')
						+record.get('DAY26_Q')
						+record.get('DAY27_Q')
						+record.get('DAY28_Q')
						+record.get('DAY29_Q')
						+record.get('DAY30_Q')
						+record.get('DAY31_Q');


						record.set('TOT_Q',sumValue);

				break;
					}
				break;

				case "DAY25_Q" :
					if(record.get('GUBUN') == '<t:message code="system.label.product.plan" default="계획"/>'){
						if(newValue == ''){
							newValue = 0;
						}
						sumValue = 0;

						sumValue =
						sumValue
						+record.get('DAY1_Q')
						+record.get('DAY2_Q')
						+record.get('DAY3_Q')
						+record.get('DAY4_Q')
						+record.get('DAY5_Q')
						+record.get('DAY6_Q')
						+record.get('DAY7_Q')
						+record.get('DAY8_Q')
						+record.get('DAY9_Q')
						+record.get('DAY10_Q')
						+record.get('DAY11_Q')
						+record.get('DAY12_Q')
						+record.get('DAY13_Q')
						+record.get('DAY14_Q')
						+record.get('DAY15_Q')
						+record.get('DAY16_Q')
						+record.get('DAY17_Q')
						+record.get('DAY18_Q')
						+record.get('DAY19_Q')
						+record.get('DAY20_Q')
						+record.get('DAY21_Q')
						+record.get('DAY22_Q')
						+record.get('DAY23_Q')
						+record.get('DAY24_Q')
						+newValue
						+record.get('DAY26_Q')
						+record.get('DAY27_Q')
						+record.get('DAY28_Q')
						+record.get('DAY29_Q')
						+record.get('DAY30_Q')
						+record.get('DAY31_Q');


						record.set('TOT_Q',sumValue);

				break;
					}
				break;

				case "DAY26_Q" :
					if(record.get('GUBUN') == '<t:message code="system.label.product.plan" default="계획"/>'){
						if(newValue == ''){
							newValue = 0;
						}
						sumValue = 0;

						sumValue =
						sumValue
						+record.get('DAY1_Q')
						+record.get('DAY2_Q')
						+record.get('DAY3_Q')
						+record.get('DAY4_Q')
						+record.get('DAY5_Q')
						+record.get('DAY6_Q')
						+record.get('DAY7_Q')
						+record.get('DAY8_Q')
						+record.get('DAY9_Q')
						+record.get('DAY10_Q')
						+record.get('DAY11_Q')
						+record.get('DAY12_Q')
						+record.get('DAY13_Q')
						+record.get('DAY14_Q')
						+record.get('DAY15_Q')
						+record.get('DAY16_Q')
						+record.get('DAY17_Q')
						+record.get('DAY18_Q')
						+record.get('DAY19_Q')
						+record.get('DAY20_Q')
						+record.get('DAY21_Q')
						+record.get('DAY22_Q')
						+record.get('DAY23_Q')
						+record.get('DAY24_Q')
						+record.get('DAY25_Q')
						+newValue
						+record.get('DAY27_Q')
						+record.get('DAY28_Q')
						+record.get('DAY29_Q')
						+record.get('DAY30_Q')
						+record.get('DAY31_Q');


						record.set('TOT_Q',sumValue);

				break;
					}
				break;

				case "DAY27_Q" :
					if(record.get('GUBUN') == '<t:message code="system.label.product.plan" default="계획"/>'){
						if(newValue == ''){
							newValue = 0;
						}
						sumValue = 0;

						sumValue =
						sumValue
						+record.get('DAY1_Q')
						+record.get('DAY2_Q')
						+record.get('DAY3_Q')
						+record.get('DAY4_Q')
						+record.get('DAY5_Q')
						+record.get('DAY6_Q')
						+record.get('DAY7_Q')
						+record.get('DAY8_Q')
						+record.get('DAY9_Q')
						+record.get('DAY10_Q')
						+record.get('DAY11_Q')
						+record.get('DAY12_Q')
						+record.get('DAY13_Q')
						+record.get('DAY14_Q')
						+record.get('DAY15_Q')
						+record.get('DAY16_Q')
						+record.get('DAY17_Q')
						+record.get('DAY18_Q')
						+record.get('DAY19_Q')
						+record.get('DAY20_Q')
						+record.get('DAY21_Q')
						+record.get('DAY22_Q')
						+record.get('DAY23_Q')
						+record.get('DAY24_Q')
						+record.get('DAY25_Q')
						+record.get('DAY26_Q')
						+newValue
						+record.get('DAY28_Q')
						+record.get('DAY29_Q')
						+record.get('DAY30_Q')
						+record.get('DAY31_Q');


						record.set('TOT_Q',sumValue);

				break;
					}
				break;

				case "DAY28_Q" :
					if(record.get('GUBUN') == '<t:message code="system.label.product.plan" default="계획"/>'){
						if(newValue == ''){
							newValue = 0;
						}
						sumValue = 0;

						sumValue =
						sumValue
						+record.get('DAY1_Q')
						+record.get('DAY2_Q')
						+record.get('DAY3_Q')
						+record.get('DAY4_Q')
						+record.get('DAY5_Q')
						+record.get('DAY6_Q')
						+record.get('DAY7_Q')
						+record.get('DAY8_Q')
						+record.get('DAY9_Q')
						+record.get('DAY10_Q')
						+record.get('DAY11_Q')
						+record.get('DAY12_Q')
						+record.get('DAY13_Q')
						+record.get('DAY14_Q')
						+record.get('DAY15_Q')
						+record.get('DAY16_Q')
						+record.get('DAY17_Q')
						+record.get('DAY18_Q')
						+record.get('DAY19_Q')
						+record.get('DAY20_Q')
						+record.get('DAY21_Q')
						+record.get('DAY22_Q')
						+record.get('DAY23_Q')
						+record.get('DAY24_Q')
						+record.get('DAY25_Q')
						+record.get('DAY26_Q')
						+record.get('DAY27_Q')
						+newValue
						+record.get('DAY29_Q')
						+record.get('DAY30_Q')
						+record.get('DAY31_Q');


						record.set('TOT_Q',sumValue);

				break;
					}
				break;

				case "DAY29_Q" :
					if(record.get('GUBUN') == '<t:message code="system.label.product.plan" default="계획"/>'){
						if(newValue == ''){
							newValue = 0;
						}
						sumValue = 0;

						sumValue =
						sumValue
						+record.get('DAY1_Q')
						+record.get('DAY2_Q')
						+record.get('DAY3_Q')
						+record.get('DAY4_Q')
						+record.get('DAY5_Q')
						+record.get('DAY6_Q')
						+record.get('DAY7_Q')
						+record.get('DAY8_Q')
						+record.get('DAY9_Q')
						+record.get('DAY10_Q')
						+record.get('DAY11_Q')
						+record.get('DAY12_Q')
						+record.get('DAY13_Q')
						+record.get('DAY14_Q')
						+record.get('DAY15_Q')
						+record.get('DAY16_Q')
						+record.get('DAY17_Q')
						+record.get('DAY18_Q')
						+record.get('DAY19_Q')
						+record.get('DAY20_Q')
						+record.get('DAY21_Q')
						+record.get('DAY22_Q')
						+record.get('DAY23_Q')
						+record.get('DAY24_Q')
						+record.get('DAY25_Q')
						+record.get('DAY26_Q')
						+record.get('DAY27_Q')
						+record.get('DAY28_Q')
						+newValue
						+record.get('DAY30_Q')
						+record.get('DAY31_Q');


						record.set('TOT_Q',sumValue);

				break;
					}
				break;

				case "DAY30_Q" :
					if(record.get('GUBUN') == '<t:message code="system.label.product.plan" default="계획"/>'){
						if(newValue == ''){
							newValue = 0;
						}
						sumValue = 0;

						sumValue =
						sumValue
						+record.get('DAY1_Q')
						+record.get('DAY2_Q')
						+record.get('DAY3_Q')
						+record.get('DAY4_Q')
						+record.get('DAY5_Q')
						+record.get('DAY6_Q')
						+record.get('DAY7_Q')
						+record.get('DAY8_Q')
						+record.get('DAY9_Q')
						+record.get('DAY10_Q')
						+record.get('DAY11_Q')
						+record.get('DAY12_Q')
						+record.get('DAY13_Q')
						+record.get('DAY14_Q')
						+record.get('DAY15_Q')
						+record.get('DAY16_Q')
						+record.get('DAY17_Q')
						+record.get('DAY18_Q')
						+record.get('DAY19_Q')
						+record.get('DAY20_Q')
						+record.get('DAY21_Q')
						+record.get('DAY22_Q')
						+record.get('DAY23_Q')
						+record.get('DAY24_Q')
						+record.get('DAY25_Q')
						+record.get('DAY26_Q')
						+record.get('DAY27_Q')
						+record.get('DAY28_Q')
						+record.get('DAY29_Q')
						+newValue
						+record.get('DAY31_Q');


						record.set('TOT_Q',sumValue);

				break;
					}
				break;

				case "DAY31_Q" :
					if(record.get('GUBUN') == '<t:message code="system.label.product.plan" default="계획"/>'){
						if(newValue == ''){
							newValue = 0;
						}
						sumValue = 0;

						sumValue =
						sumValue
						+record.get('DAY1_Q')
						+record.get('DAY2_Q')
						+record.get('DAY3_Q')
						+record.get('DAY4_Q')
						+record.get('DAY5_Q')
						+record.get('DAY6_Q')
						+record.get('DAY7_Q')
						+record.get('DAY8_Q')
						+record.get('DAY9_Q')
						+record.get('DAY10_Q')
						+record.get('DAY11_Q')
						+record.get('DAY12_Q')
						+record.get('DAY13_Q')
						+record.get('DAY14_Q')
						+record.get('DAY15_Q')
						+record.get('DAY16_Q')
						+record.get('DAY17_Q')
						+record.get('DAY18_Q')
						+record.get('DAY19_Q')
						+record.get('DAY20_Q')
						+record.get('DAY21_Q')
						+record.get('DAY22_Q')
						+record.get('DAY23_Q')
						+record.get('DAY24_Q')
						+record.get('DAY25_Q')
						+record.get('DAY26_Q')
						+record.get('DAY27_Q')
						+record.get('DAY28_Q')
						+record.get('DAY29_Q')
						+record.get('DAY30_Q')
						+newValue;


						record.set('TOT_Q',sumValue);

				break;
					}
				break;

			}
			return rv;
		}
		});

		Unilite.createValidator('validator02', {
		store: masterStore2,
		grid: masterGrid2,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			var sumValue = 0;
			switch(fieldName) {
				case "ORDER_INFO" :
					if(record.get('GUBUN') == '<t:message code="system.label.product.plan" default="계획"/>' )	{
						//record.set("REMARK", newValue);
					}
				break;


				case "DAY1_Q" :
					if(record.get('GUBUN') == '<t:message code="system.label.product.plan" default="계획"/>'){
						if(newValue == ''){
							newValue = 0;
						}
						sumValue = 0;

						sumValue =
						sumValue
						+newValue
						+record.get('DAY2_Q')
						+record.get('DAY3_Q')
						+record.get('DAY4_Q')
						+record.get('DAY5_Q')
						+record.get('DAY6_Q')
						+record.get('DAY7_Q')
						+record.get('DAY8_Q')
						+record.get('DAY9_Q')
						+record.get('DAY10_Q')
						+record.get('DAY11_Q')
						+record.get('DAY12_Q')
						+record.get('DAY13_Q')
						+record.get('DAY14_Q')
						+record.get('DAY15_Q')
						+record.get('DAY16_Q')
						+record.get('DAY17_Q')
						+record.get('DAY18_Q')
						+record.get('DAY19_Q')
						+record.get('DAY20_Q')
						+record.get('DAY21_Q')
						+record.get('DAY22_Q')
						+record.get('DAY23_Q')
						+record.get('DAY24_Q')
						+record.get('DAY25_Q')
						+record.get('DAY26_Q')
						+record.get('DAY27_Q')
						+record.get('DAY28_Q')
						+record.get('DAY29_Q')
						+record.get('DAY30_Q')
						+record.get('DAY31_Q');


						record.set('TOT_Q',sumValue);

				break;
					}
				break;

				case "DAY2_Q" :
					if(record.get('GUBUN') == '<t:message code="system.label.product.plan" default="계획"/>'){
						if(newValue == ''){
							newValue = 0;
						}
						sumValue = 0;

						sumValue =
						sumValue
						+record.get('DAY1_Q')
						+newValue
						+record.get('DAY3_Q')
						+record.get('DAY4_Q')
						+record.get('DAY5_Q')
						+record.get('DAY6_Q')
						+record.get('DAY7_Q')
						+record.get('DAY8_Q')
						+record.get('DAY9_Q')
						+record.get('DAY10_Q')
						+record.get('DAY11_Q')
						+record.get('DAY12_Q')
						+record.get('DAY13_Q')
						+record.get('DAY14_Q')
						+record.get('DAY15_Q')
						+record.get('DAY16_Q')
						+record.get('DAY17_Q')
						+record.get('DAY18_Q')
						+record.get('DAY19_Q')
						+record.get('DAY20_Q')
						+record.get('DAY21_Q')
						+record.get('DAY22_Q')
						+record.get('DAY23_Q')
						+record.get('DAY24_Q')
						+record.get('DAY25_Q')
						+record.get('DAY26_Q')
						+record.get('DAY27_Q')
						+record.get('DAY28_Q')
						+record.get('DAY29_Q')
						+record.get('DAY30_Q')
						+record.get('DAY31_Q');


						record.set('TOT_Q',sumValue);

				break;
					}
				break;

				case "DAY3_Q" :
					if(record.get('GUBUN') == '<t:message code="system.label.product.plan" default="계획"/>'){
						if(newValue == ''){
							newValue = 0;
						}
						sumValue = 0;

						sumValue =
						sumValue
						+record.get('DAY1_Q')
						+record.get('DAY2_Q')
						+newValue
						+record.get('DAY4_Q')
						+record.get('DAY5_Q')
						+record.get('DAY6_Q')
						+record.get('DAY7_Q')
						+record.get('DAY8_Q')
						+record.get('DAY9_Q')
						+record.get('DAY10_Q')
						+record.get('DAY11_Q')
						+record.get('DAY12_Q')
						+record.get('DAY13_Q')
						+record.get('DAY14_Q')
						+record.get('DAY15_Q')
						+record.get('DAY16_Q')
						+record.get('DAY17_Q')
						+record.get('DAY18_Q')
						+record.get('DAY19_Q')
						+record.get('DAY20_Q')
						+record.get('DAY21_Q')
						+record.get('DAY22_Q')
						+record.get('DAY23_Q')
						+record.get('DAY24_Q')
						+record.get('DAY25_Q')
						+record.get('DAY26_Q')
						+record.get('DAY27_Q')
						+record.get('DAY28_Q')
						+record.get('DAY29_Q')
						+record.get('DAY30_Q')
						+record.get('DAY31_Q');


						record.set('TOT_Q',sumValue);

				break;
					}
				break;

				case "DAY4_Q" :
					if(record.get('GUBUN') == '<t:message code="system.label.product.plan" default="계획"/>'){
						if(newValue == ''){
							newValue = 0;
						}
						sumValue = 0;

						sumValue =
						sumValue
						+record.get('DAY1_Q')
						+record.get('DAY2_Q')
						+record.get('DAY3_Q')
						+newValue
						+record.get('DAY5_Q')
						+record.get('DAY6_Q')
						+record.get('DAY7_Q')
						+record.get('DAY8_Q')
						+record.get('DAY9_Q')
						+record.get('DAY10_Q')
						+record.get('DAY11_Q')
						+record.get('DAY12_Q')
						+record.get('DAY13_Q')
						+record.get('DAY14_Q')
						+record.get('DAY15_Q')
						+record.get('DAY16_Q')
						+record.get('DAY17_Q')
						+record.get('DAY18_Q')
						+record.get('DAY19_Q')
						+record.get('DAY20_Q')
						+record.get('DAY21_Q')
						+record.get('DAY22_Q')
						+record.get('DAY23_Q')
						+record.get('DAY24_Q')
						+record.get('DAY25_Q')
						+record.get('DAY26_Q')
						+record.get('DAY27_Q')
						+record.get('DAY28_Q')
						+record.get('DAY29_Q')
						+record.get('DAY30_Q')
						+record.get('DAY31_Q');


						record.set('TOT_Q',sumValue);

				break;
					}
				break;

				case "DAY5_Q" :
					if(record.get('GUBUN') == '<t:message code="system.label.product.plan" default="계획"/>'){
						if(newValue == ''){
							newValue = 0;
						}
						sumValue = 0;

						sumValue =
						sumValue
						+record.get('DAY1_Q')
						+record.get('DAY2_Q')
						+record.get('DAY3_Q')
						+record.get('DAY4_Q')
						+newValue
						+record.get('DAY6_Q')
						+record.get('DAY7_Q')
						+record.get('DAY8_Q')
						+record.get('DAY9_Q')
						+record.get('DAY10_Q')
						+record.get('DAY11_Q')
						+record.get('DAY12_Q')
						+record.get('DAY13_Q')
						+record.get('DAY14_Q')
						+record.get('DAY15_Q')
						+record.get('DAY16_Q')
						+record.get('DAY17_Q')
						+record.get('DAY18_Q')
						+record.get('DAY19_Q')
						+record.get('DAY20_Q')
						+record.get('DAY21_Q')
						+record.get('DAY22_Q')
						+record.get('DAY23_Q')
						+record.get('DAY24_Q')
						+record.get('DAY25_Q')
						+record.get('DAY26_Q')
						+record.get('DAY27_Q')
						+record.get('DAY28_Q')
						+record.get('DAY29_Q')
						+record.get('DAY30_Q')
						+record.get('DAY31_Q');


						record.set('TOT_Q',sumValue);

				break;
					}
				break;

				case "DAY6_Q" :
					if(record.get('GUBUN') == '<t:message code="system.label.product.plan" default="계획"/>'){
						if(newValue == ''){
							newValue = 0;
						}
						sumValue = 0;

						sumValue =
						sumValue
						+record.get('DAY1_Q')
						+record.get('DAY2_Q')
						+record.get('DAY3_Q')
						+record.get('DAY4_Q')
						+record.get('DAY5_Q')
						+newValue
						+record.get('DAY7_Q')
						+record.get('DAY8_Q')
						+record.get('DAY9_Q')
						+record.get('DAY10_Q')
						+record.get('DAY11_Q')
						+record.get('DAY12_Q')
						+record.get('DAY13_Q')
						+record.get('DAY14_Q')
						+record.get('DAY15_Q')
						+record.get('DAY16_Q')
						+record.get('DAY17_Q')
						+record.get('DAY18_Q')
						+record.get('DAY19_Q')
						+record.get('DAY20_Q')
						+record.get('DAY21_Q')
						+record.get('DAY22_Q')
						+record.get('DAY23_Q')
						+record.get('DAY24_Q')
						+record.get('DAY25_Q')
						+record.get('DAY26_Q')
						+record.get('DAY27_Q')
						+record.get('DAY28_Q')
						+record.get('DAY29_Q')
						+record.get('DAY30_Q')
						+record.get('DAY31_Q');


						record.set('TOT_Q',sumValue);

				break;
					}
				break;

				case "DAY7_Q" :
					if(record.get('GUBUN') == '<t:message code="system.label.product.plan" default="계획"/>'){
						if(newValue == ''){
							newValue = 0;
						}
						sumValue = 0;

						sumValue =
						sumValue
						+record.get('DAY1_Q')
						+record.get('DAY2_Q')
						+record.get('DAY3_Q')
						+record.get('DAY4_Q')
						+record.get('DAY5_Q')
						+record.get('DAY6_Q')
						+newValue
						+record.get('DAY8_Q')
						+record.get('DAY9_Q')
						+record.get('DAY10_Q')
						+record.get('DAY11_Q')
						+record.get('DAY12_Q')
						+record.get('DAY13_Q')
						+record.get('DAY14_Q')
						+record.get('DAY15_Q')
						+record.get('DAY16_Q')
						+record.get('DAY17_Q')
						+record.get('DAY18_Q')
						+record.get('DAY19_Q')
						+record.get('DAY20_Q')
						+record.get('DAY21_Q')
						+record.get('DAY22_Q')
						+record.get('DAY23_Q')
						+record.get('DAY24_Q')
						+record.get('DAY25_Q')
						+record.get('DAY26_Q')
						+record.get('DAY27_Q')
						+record.get('DAY28_Q')
						+record.get('DAY29_Q')
						+record.get('DAY30_Q')
						+record.get('DAY31_Q');


						record.set('TOT_Q',sumValue);

				break;
					}
				break;

				case "DAY8_Q" :
					if(record.get('GUBUN') == '<t:message code="system.label.product.plan" default="계획"/>'){
						if(newValue == ''){
							newValue = 0;
						}
						sumValue = 0;

						sumValue =
						sumValue
						+record.get('DAY1_Q')
						+record.get('DAY2_Q')
						+record.get('DAY3_Q')
						+record.get('DAY4_Q')
						+record.get('DAY5_Q')
						+record.get('DAY6_Q')
						+record.get('DAY7_Q')
						+newValue
						+record.get('DAY9_Q')
						+record.get('DAY10_Q')
						+record.get('DAY11_Q')
						+record.get('DAY12_Q')
						+record.get('DAY13_Q')
						+record.get('DAY14_Q')
						+record.get('DAY15_Q')
						+record.get('DAY16_Q')
						+record.get('DAY17_Q')
						+record.get('DAY18_Q')
						+record.get('DAY19_Q')
						+record.get('DAY20_Q')
						+record.get('DAY21_Q')
						+record.get('DAY22_Q')
						+record.get('DAY23_Q')
						+record.get('DAY24_Q')
						+record.get('DAY25_Q')
						+record.get('DAY26_Q')
						+record.get('DAY27_Q')
						+record.get('DAY28_Q')
						+record.get('DAY29_Q')
						+record.get('DAY30_Q')
						+record.get('DAY31_Q');


						record.set('TOT_Q',sumValue);

				break;
					}
				break;

				case "DAY9_Q" :
					if(record.get('GUBUN') == '<t:message code="system.label.product.plan" default="계획"/>'){
						if(newValue == ''){
							newValue = 0;
						}
						sumValue = 0;

						sumValue =
						sumValue
						+record.get('DAY1_Q')
						+record.get('DAY2_Q')
						+record.get('DAY3_Q')
						+record.get('DAY4_Q')
						+record.get('DAY5_Q')
						+record.get('DAY6_Q')
						+record.get('DAY7_Q')
						+record.get('DAY8_Q')
						+newValue
						+record.get('DAY10_Q')
						+record.get('DAY11_Q')
						+record.get('DAY12_Q')
						+record.get('DAY13_Q')
						+record.get('DAY14_Q')
						+record.get('DAY15_Q')
						+record.get('DAY16_Q')
						+record.get('DAY17_Q')
						+record.get('DAY18_Q')
						+record.get('DAY19_Q')
						+record.get('DAY20_Q')
						+record.get('DAY21_Q')
						+record.get('DAY22_Q')
						+record.get('DAY23_Q')
						+record.get('DAY24_Q')
						+record.get('DAY25_Q')
						+record.get('DAY26_Q')
						+record.get('DAY27_Q')
						+record.get('DAY28_Q')
						+record.get('DAY29_Q')
						+record.get('DAY30_Q')
						+record.get('DAY31_Q');


						record.set('TOT_Q',sumValue);

				break;
					}
				break;

				case "DAY10_Q" :
					if(record.get('GUBUN') == '<t:message code="system.label.product.plan" default="계획"/>'){
						if(newValue == ''){
							newValue = 0;
						}
						sumValue = 0;

						sumValue =
						sumValue
						+record.get('DAY1_Q')
						+record.get('DAY2_Q')
						+record.get('DAY3_Q')
						+record.get('DAY4_Q')
						+record.get('DAY5_Q')
						+record.get('DAY6_Q')
						+record.get('DAY7_Q')
						+record.get('DAY8_Q')
						+record.get('DAY9_Q')
						+newValue
						+record.get('DAY11_Q')
						+record.get('DAY12_Q')
						+record.get('DAY13_Q')
						+record.get('DAY14_Q')
						+record.get('DAY15_Q')
						+record.get('DAY16_Q')
						+record.get('DAY17_Q')
						+record.get('DAY18_Q')
						+record.get('DAY19_Q')
						+record.get('DAY20_Q')
						+record.get('DAY21_Q')
						+record.get('DAY22_Q')
						+record.get('DAY23_Q')
						+record.get('DAY24_Q')
						+record.get('DAY25_Q')
						+record.get('DAY26_Q')
						+record.get('DAY27_Q')
						+record.get('DAY28_Q')
						+record.get('DAY29_Q')
						+record.get('DAY30_Q')
						+record.get('DAY31_Q');


						record.set('TOT_Q',sumValue);

				break;
					}
				break;

				case "DAY11_Q" :
					if(record.get('GUBUN') == '<t:message code="system.label.product.plan" default="계획"/>'){
						if(newValue == ''){
							newValue = 0;
						}
						sumValue = 0;

						sumValue =
						sumValue
						+record.get('DAY1_Q')
						+record.get('DAY2_Q')
						+record.get('DAY3_Q')
						+record.get('DAY4_Q')
						+record.get('DAY5_Q')
						+record.get('DAY6_Q')
						+record.get('DAY7_Q')
						+record.get('DAY8_Q')
						+record.get('DAY9_Q')
						+record.get('DAY10_Q')
						+newValue
						+record.get('DAY12_Q')
						+record.get('DAY13_Q')
						+record.get('DAY14_Q')
						+record.get('DAY15_Q')
						+record.get('DAY16_Q')
						+record.get('DAY17_Q')
						+record.get('DAY18_Q')
						+record.get('DAY19_Q')
						+record.get('DAY20_Q')
						+record.get('DAY21_Q')
						+record.get('DAY22_Q')
						+record.get('DAY23_Q')
						+record.get('DAY24_Q')
						+record.get('DAY25_Q')
						+record.get('DAY26_Q')
						+record.get('DAY27_Q')
						+record.get('DAY28_Q')
						+record.get('DAY29_Q')
						+record.get('DAY30_Q')
						+record.get('DAY31_Q');


						record.set('TOT_Q',sumValue);

				break;
					}
				break;

				case "DAY12_Q" :
					if(record.get('GUBUN') == '<t:message code="system.label.product.plan" default="계획"/>'){
						if(newValue == ''){
							newValue = 0;
						}
						sumValue = 0;

						sumValue =
						sumValue
						+record.get('DAY1_Q')
						+record.get('DAY2_Q')
						+record.get('DAY3_Q')
						+record.get('DAY4_Q')
						+record.get('DAY5_Q')
						+record.get('DAY6_Q')
						+record.get('DAY7_Q')
						+record.get('DAY8_Q')
						+record.get('DAY9_Q')
						+record.get('DAY10_Q')
						+record.get('DAY11_Q')
						+newValue
						+record.get('DAY13_Q')
						+record.get('DAY14_Q')
						+record.get('DAY15_Q')
						+record.get('DAY16_Q')
						+record.get('DAY17_Q')
						+record.get('DAY18_Q')
						+record.get('DAY19_Q')
						+record.get('DAY20_Q')
						+record.get('DAY21_Q')
						+record.get('DAY22_Q')
						+record.get('DAY23_Q')
						+record.get('DAY24_Q')
						+record.get('DAY25_Q')
						+record.get('DAY26_Q')
						+record.get('DAY27_Q')
						+record.get('DAY28_Q')
						+record.get('DAY29_Q')
						+record.get('DAY30_Q')
						+record.get('DAY31_Q');


						record.set('TOT_Q',sumValue);

				break;
					}
				break;

				case "DAY13_Q" :
					if(record.get('GUBUN') == '<t:message code="system.label.product.plan" default="계획"/>'){
						if(newValue == ''){
							newValue = 0;
						}
						sumValue = 0;

						sumValue =
						sumValue
						+record.get('DAY1_Q')
						+record.get('DAY2_Q')
						+record.get('DAY3_Q')
						+record.get('DAY4_Q')
						+record.get('DAY5_Q')
						+record.get('DAY6_Q')
						+record.get('DAY7_Q')
						+record.get('DAY8_Q')
						+record.get('DAY9_Q')
						+record.get('DAY10_Q')
						+record.get('DAY11_Q')
						+record.get('DAY12_Q')
						+newValue
						+record.get('DAY14_Q')
						+record.get('DAY15_Q')
						+record.get('DAY16_Q')
						+record.get('DAY17_Q')
						+record.get('DAY18_Q')
						+record.get('DAY19_Q')
						+record.get('DAY20_Q')
						+record.get('DAY21_Q')
						+record.get('DAY22_Q')
						+record.get('DAY23_Q')
						+record.get('DAY24_Q')
						+record.get('DAY25_Q')
						+record.get('DAY26_Q')
						+record.get('DAY27_Q')
						+record.get('DAY28_Q')
						+record.get('DAY29_Q')
						+record.get('DAY30_Q')
						+record.get('DAY31_Q');


						record.set('TOT_Q',sumValue);

				break;
					}
				break;

				case "DAY14_Q" :
					if(record.get('GUBUN') == '<t:message code="system.label.product.plan" default="계획"/>'){
						if(newValue == ''){
							newValue = 0;
						}
						sumValue = 0;

						sumValue =
						sumValue
						+record.get('DAY1_Q')
						+record.get('DAY2_Q')
						+record.get('DAY3_Q')
						+record.get('DAY4_Q')
						+record.get('DAY5_Q')
						+record.get('DAY6_Q')
						+record.get('DAY7_Q')
						+record.get('DAY8_Q')
						+record.get('DAY9_Q')
						+record.get('DAY10_Q')
						+record.get('DAY11_Q')
						+record.get('DAY12_Q')
						+record.get('DAY13_Q')
						+newValue
						+record.get('DAY15_Q')
						+record.get('DAY16_Q')
						+record.get('DAY17_Q')
						+record.get('DAY18_Q')
						+record.get('DAY19_Q')
						+record.get('DAY20_Q')
						+record.get('DAY21_Q')
						+record.get('DAY22_Q')
						+record.get('DAY23_Q')
						+record.get('DAY24_Q')
						+record.get('DAY25_Q')
						+record.get('DAY26_Q')
						+record.get('DAY27_Q')
						+record.get('DAY28_Q')
						+record.get('DAY29_Q')
						+record.get('DAY30_Q')
						+record.get('DAY31_Q');


						record.set('TOT_Q',sumValue);

				break;
					}
				break;

				case "DAY15_Q" :
					if(record.get('GUBUN') == '<t:message code="system.label.product.plan" default="계획"/>'){
						if(newValue == ''){
							newValue = 0;
						}
						sumValue = 0;

						sumValue =
						sumValue
						+record.get('DAY1_Q')
						+record.get('DAY2_Q')
						+record.get('DAY3_Q')
						+record.get('DAY4_Q')
						+record.get('DAY5_Q')
						+record.get('DAY6_Q')
						+record.get('DAY7_Q')
						+record.get('DAY8_Q')
						+record.get('DAY9_Q')
						+record.get('DAY10_Q')
						+record.get('DAY11_Q')
						+record.get('DAY12_Q')
						+record.get('DAY13_Q')
						+record.get('DAY14_Q')
						+newValue
						+record.get('DAY16_Q')
						+record.get('DAY17_Q')
						+record.get('DAY18_Q')
						+record.get('DAY19_Q')
						+record.get('DAY20_Q')
						+record.get('DAY21_Q')
						+record.get('DAY22_Q')
						+record.get('DAY23_Q')
						+record.get('DAY24_Q')
						+record.get('DAY25_Q')
						+record.get('DAY26_Q')
						+record.get('DAY27_Q')
						+record.get('DAY28_Q')
						+record.get('DAY29_Q')
						+record.get('DAY30_Q')
						+record.get('DAY31_Q');


						record.set('TOT_Q',sumValue);

				break;
					}
				break;

				case "DAY16_Q" :
					if(record.get('GUBUN') == '<t:message code="system.label.product.plan" default="계획"/>'){
						if(newValue == ''){
							newValue = 0;
						}
						sumValue = 0;

						sumValue =
						sumValue
						+record.get('DAY1_Q')
						+record.get('DAY2_Q')
						+record.get('DAY3_Q')
						+record.get('DAY4_Q')
						+record.get('DAY5_Q')
						+record.get('DAY6_Q')
						+record.get('DAY7_Q')
						+record.get('DAY8_Q')
						+record.get('DAY9_Q')
						+record.get('DAY10_Q')
						+record.get('DAY11_Q')
						+record.get('DAY12_Q')
						+record.get('DAY13_Q')
						+record.get('DAY14_Q')
						+record.get('DAY15_Q')
						+newValue
						+record.get('DAY17_Q')
						+record.get('DAY18_Q')
						+record.get('DAY19_Q')
						+record.get('DAY20_Q')
						+record.get('DAY21_Q')
						+record.get('DAY22_Q')
						+record.get('DAY23_Q')
						+record.get('DAY24_Q')
						+record.get('DAY25_Q')
						+record.get('DAY26_Q')
						+record.get('DAY27_Q')
						+record.get('DAY28_Q')
						+record.get('DAY29_Q')
						+record.get('DAY30_Q')
						+record.get('DAY31_Q');


						record.set('TOT_Q',sumValue);

				break;
					}
				break;

				case "DAY17_Q" :
					if(record.get('GUBUN') == '<t:message code="system.label.product.plan" default="계획"/>'){
						if(newValue == ''){
							newValue = 0;
						}
						sumValue = 0;

						sumValue =
						sumValue
						+record.get('DAY1_Q')
						+record.get('DAY2_Q')
						+record.get('DAY3_Q')
						+record.get('DAY4_Q')
						+record.get('DAY5_Q')
						+record.get('DAY6_Q')
						+record.get('DAY7_Q')
						+record.get('DAY8_Q')
						+record.get('DAY9_Q')
						+record.get('DAY10_Q')
						+record.get('DAY11_Q')
						+record.get('DAY12_Q')
						+record.get('DAY13_Q')
						+record.get('DAY14_Q')
						+record.get('DAY15_Q')
						+record.get('DAY16_Q')
						+newValue
						+record.get('DAY18_Q')
						+record.get('DAY19_Q')
						+record.get('DAY20_Q')
						+record.get('DAY21_Q')
						+record.get('DAY22_Q')
						+record.get('DAY23_Q')
						+record.get('DAY24_Q')
						+record.get('DAY25_Q')
						+record.get('DAY26_Q')
						+record.get('DAY27_Q')
						+record.get('DAY28_Q')
						+record.get('DAY29_Q')
						+record.get('DAY30_Q')
						+record.get('DAY31_Q');


						record.set('TOT_Q',sumValue);

				break;
					}
				break;

				case "DAY18_Q" :
					if(record.get('GUBUN') == '<t:message code="system.label.product.plan" default="계획"/>'){
						if(newValue == ''){
							newValue = 0;
						}
						sumValue = 0;

						sumValue =
						sumValue
						+record.get('DAY1_Q')
						+record.get('DAY2_Q')
						+record.get('DAY3_Q')
						+record.get('DAY4_Q')
						+record.get('DAY5_Q')
						+record.get('DAY6_Q')
						+record.get('DAY7_Q')
						+record.get('DAY8_Q')
						+record.get('DAY9_Q')
						+record.get('DAY10_Q')
						+record.get('DAY11_Q')
						+record.get('DAY12_Q')
						+record.get('DAY13_Q')
						+record.get('DAY14_Q')
						+record.get('DAY15_Q')
						+record.get('DAY16_Q')
						+record.get('DAY17_Q')
						+newValue
						+record.get('DAY19_Q')
						+record.get('DAY20_Q')
						+record.get('DAY21_Q')
						+record.get('DAY22_Q')
						+record.get('DAY23_Q')
						+record.get('DAY24_Q')
						+record.get('DAY25_Q')
						+record.get('DAY26_Q')
						+record.get('DAY27_Q')
						+record.get('DAY28_Q')
						+record.get('DAY29_Q')
						+record.get('DAY30_Q')
						+record.get('DAY31_Q');


						record.set('TOT_Q',sumValue);

				break;
					}
				break;

				case "DAY19_Q" :
					if(record.get('GUBUN') == '<t:message code="system.label.product.plan" default="계획"/>'){
						if(newValue == ''){
							newValue = 0;
						}
						sumValue = 0;

						sumValue =
						sumValue
						+record.get('DAY1_Q')
						+record.get('DAY2_Q')
						+record.get('DAY3_Q')
						+record.get('DAY4_Q')
						+record.get('DAY5_Q')
						+record.get('DAY6_Q')
						+record.get('DAY7_Q')
						+record.get('DAY8_Q')
						+record.get('DAY9_Q')
						+record.get('DAY10_Q')
						+record.get('DAY11_Q')
						+record.get('DAY12_Q')
						+record.get('DAY13_Q')
						+record.get('DAY14_Q')
						+record.get('DAY15_Q')
						+record.get('DAY16_Q')
						+record.get('DAY17_Q')
						+record.get('DAY18_Q')
						+newValue
						+record.get('DAY20_Q')
						+record.get('DAY21_Q')
						+record.get('DAY22_Q')
						+record.get('DAY23_Q')
						+record.get('DAY24_Q')
						+record.get('DAY25_Q')
						+record.get('DAY26_Q')
						+record.get('DAY27_Q')
						+record.get('DAY28_Q')
						+record.get('DAY29_Q')
						+record.get('DAY30_Q')
						+record.get('DAY31_Q');


						record.set('TOT_Q',sumValue);

				break;
					}
				break;

				case "DAY20_Q" :
					if(record.get('GUBUN') == '<t:message code="system.label.product.plan" default="계획"/>'){
						if(newValue == ''){
							newValue = 0;
						}
						sumValue = 0;

						sumValue =
						sumValue
						+record.get('DAY1_Q')
						+record.get('DAY2_Q')
						+record.get('DAY3_Q')
						+record.get('DAY4_Q')
						+record.get('DAY5_Q')
						+record.get('DAY6_Q')
						+record.get('DAY7_Q')
						+record.get('DAY8_Q')
						+record.get('DAY9_Q')
						+record.get('DAY10_Q')
						+record.get('DAY11_Q')
						+record.get('DAY12_Q')
						+record.get('DAY13_Q')
						+record.get('DAY14_Q')
						+record.get('DAY15_Q')
						+record.get('DAY16_Q')
						+record.get('DAY17_Q')
						+record.get('DAY18_Q')
						+record.get('DAY19_Q')
						+newValue
						+record.get('DAY21_Q')
						+record.get('DAY22_Q')
						+record.get('DAY23_Q')
						+record.get('DAY24_Q')
						+record.get('DAY25_Q')
						+record.get('DAY26_Q')
						+record.get('DAY27_Q')
						+record.get('DAY28_Q')
						+record.get('DAY29_Q')
						+record.get('DAY30_Q')
						+record.get('DAY31_Q');


						record.set('TOT_Q',sumValue);

				break;
					}
				break;

				case "DAY21_Q" :
					if(record.get('GUBUN') == '<t:message code="system.label.product.plan" default="계획"/>'){
						if(newValue == ''){
							newValue = 0;
						}
						sumValue = 0;

						sumValue =
						sumValue
						+record.get('DAY1_Q')
						+record.get('DAY2_Q')
						+record.get('DAY3_Q')
						+record.get('DAY4_Q')
						+record.get('DAY5_Q')
						+record.get('DAY6_Q')
						+record.get('DAY7_Q')
						+record.get('DAY8_Q')
						+record.get('DAY9_Q')
						+record.get('DAY10_Q')
						+record.get('DAY11_Q')
						+record.get('DAY12_Q')
						+record.get('DAY13_Q')
						+record.get('DAY14_Q')
						+record.get('DAY15_Q')
						+record.get('DAY16_Q')
						+record.get('DAY17_Q')
						+record.get('DAY18_Q')
						+record.get('DAY19_Q')
						+record.get('DAY20_Q')
						+newValue
						+record.get('DAY22_Q')
						+record.get('DAY23_Q')
						+record.get('DAY24_Q')
						+record.get('DAY25_Q')
						+record.get('DAY26_Q')
						+record.get('DAY27_Q')
						+record.get('DAY28_Q')
						+record.get('DAY29_Q')
						+record.get('DAY30_Q')
						+record.get('DAY31_Q');


						record.set('TOT_Q',sumValue);

				break;
					}
				break;

				case "DAY22_Q" :
					if(record.get('GUBUN') == '<t:message code="system.label.product.plan" default="계획"/>'){
						if(newValue == ''){
							newValue = 0;
						}
						sumValue = 0;

						sumValue =
						sumValue
						+record.get('DAY1_Q')
						+record.get('DAY2_Q')
						+record.get('DAY3_Q')
						+record.get('DAY4_Q')
						+record.get('DAY5_Q')
						+record.get('DAY6_Q')
						+record.get('DAY7_Q')
						+record.get('DAY8_Q')
						+record.get('DAY9_Q')
						+record.get('DAY10_Q')
						+record.get('DAY11_Q')
						+record.get('DAY12_Q')
						+record.get('DAY13_Q')
						+record.get('DAY14_Q')
						+record.get('DAY15_Q')
						+record.get('DAY16_Q')
						+record.get('DAY17_Q')
						+record.get('DAY18_Q')
						+record.get('DAY19_Q')
						+record.get('DAY20_Q')
						+record.get('DAY21_Q')
						+newValue
						+record.get('DAY23_Q')
						+record.get('DAY24_Q')
						+record.get('DAY25_Q')
						+record.get('DAY26_Q')
						+record.get('DAY27_Q')
						+record.get('DAY28_Q')
						+record.get('DAY29_Q')
						+record.get('DAY30_Q')
						+record.get('DAY31_Q');


						record.set('TOT_Q',sumValue);

				break;
					}
				break;

				case "DAY23_Q" :
					if(record.get('GUBUN') == '<t:message code="system.label.product.plan" default="계획"/>'){
						if(newValue == ''){
							newValue = 0;
						}
						sumValue = 0;

						sumValue =
						sumValue
						+record.get('DAY1_Q')
						+record.get('DAY2_Q')
						+record.get('DAY3_Q')
						+record.get('DAY4_Q')
						+record.get('DAY5_Q')
						+record.get('DAY6_Q')
						+record.get('DAY7_Q')
						+record.get('DAY8_Q')
						+record.get('DAY9_Q')
						+record.get('DAY10_Q')
						+record.get('DAY11_Q')
						+record.get('DAY12_Q')
						+record.get('DAY13_Q')
						+record.get('DAY14_Q')
						+record.get('DAY15_Q')
						+record.get('DAY16_Q')
						+record.get('DAY17_Q')
						+record.get('DAY18_Q')
						+record.get('DAY19_Q')
						+record.get('DAY20_Q')
						+record.get('DAY21_Q')
						+record.get('DAY22_Q')
						+newValue
						+record.get('DAY24_Q')
						+record.get('DAY25_Q')
						+record.get('DAY26_Q')
						+record.get('DAY27_Q')
						+record.get('DAY28_Q')
						+record.get('DAY29_Q')
						+record.get('DAY30_Q')
						+record.get('DAY31_Q');


						record.set('TOT_Q',sumValue);

				break;
					}
				break;

				case "DAY24_Q" :
					if(record.get('GUBUN') == '<t:message code="system.label.product.plan" default="계획"/>'){
						if(newValue == ''){
							newValue = 0;
						}
						sumValue = 0;

						sumValue =
						sumValue
						+record.get('DAY1_Q')
						+record.get('DAY2_Q')
						+record.get('DAY3_Q')
						+record.get('DAY4_Q')
						+record.get('DAY5_Q')
						+record.get('DAY6_Q')
						+record.get('DAY7_Q')
						+record.get('DAY8_Q')
						+record.get('DAY9_Q')
						+record.get('DAY10_Q')
						+record.get('DAY11_Q')
						+record.get('DAY12_Q')
						+record.get('DAY13_Q')
						+record.get('DAY14_Q')
						+record.get('DAY15_Q')
						+record.get('DAY16_Q')
						+record.get('DAY17_Q')
						+record.get('DAY18_Q')
						+record.get('DAY19_Q')
						+record.get('DAY20_Q')
						+record.get('DAY21_Q')
						+record.get('DAY22_Q')
						+record.get('DAY23_Q')
						+newValue
						+record.get('DAY25_Q')
						+record.get('DAY26_Q')
						+record.get('DAY27_Q')
						+record.get('DAY28_Q')
						+record.get('DAY29_Q')
						+record.get('DAY30_Q')
						+record.get('DAY31_Q');


						record.set('TOT_Q',sumValue);

				break;
					}
				break;

				case "DAY25_Q" :
					if(record.get('GUBUN') == '<t:message code="system.label.product.plan" default="계획"/>'){
						if(newValue == ''){
							newValue = 0;
						}
						sumValue = 0;

						sumValue =
						sumValue
						+record.get('DAY1_Q')
						+record.get('DAY2_Q')
						+record.get('DAY3_Q')
						+record.get('DAY4_Q')
						+record.get('DAY5_Q')
						+record.get('DAY6_Q')
						+record.get('DAY7_Q')
						+record.get('DAY8_Q')
						+record.get('DAY9_Q')
						+record.get('DAY10_Q')
						+record.get('DAY11_Q')
						+record.get('DAY12_Q')
						+record.get('DAY13_Q')
						+record.get('DAY14_Q')
						+record.get('DAY15_Q')
						+record.get('DAY16_Q')
						+record.get('DAY17_Q')
						+record.get('DAY18_Q')
						+record.get('DAY19_Q')
						+record.get('DAY20_Q')
						+record.get('DAY21_Q')
						+record.get('DAY22_Q')
						+record.get('DAY23_Q')
						+record.get('DAY24_Q')
						+newValue
						+record.get('DAY26_Q')
						+record.get('DAY27_Q')
						+record.get('DAY28_Q')
						+record.get('DAY29_Q')
						+record.get('DAY30_Q')
						+record.get('DAY31_Q');


						record.set('TOT_Q',sumValue);

				break;
					}
				break;

				case "DAY26_Q" :
					if(record.get('GUBUN') == '<t:message code="system.label.product.plan" default="계획"/>'){
						if(newValue == ''){
							newValue = 0;
						}
						sumValue = 0;

						sumValue =
						sumValue
						+record.get('DAY1_Q')
						+record.get('DAY2_Q')
						+record.get('DAY3_Q')
						+record.get('DAY4_Q')
						+record.get('DAY5_Q')
						+record.get('DAY6_Q')
						+record.get('DAY7_Q')
						+record.get('DAY8_Q')
						+record.get('DAY9_Q')
						+record.get('DAY10_Q')
						+record.get('DAY11_Q')
						+record.get('DAY12_Q')
						+record.get('DAY13_Q')
						+record.get('DAY14_Q')
						+record.get('DAY15_Q')
						+record.get('DAY16_Q')
						+record.get('DAY17_Q')
						+record.get('DAY18_Q')
						+record.get('DAY19_Q')
						+record.get('DAY20_Q')
						+record.get('DAY21_Q')
						+record.get('DAY22_Q')
						+record.get('DAY23_Q')
						+record.get('DAY24_Q')
						+record.get('DAY25_Q')
						+newValue
						+record.get('DAY27_Q')
						+record.get('DAY28_Q')
						+record.get('DAY29_Q')
						+record.get('DAY30_Q')
						+record.get('DAY31_Q');


						record.set('TOT_Q',sumValue);

				break;
					}
				break;

				case "DAY27_Q" :
					if(record.get('GUBUN') == '<t:message code="system.label.product.plan" default="계획"/>'){
						if(newValue == ''){
							newValue = 0;
						}
						sumValue = 0;

						sumValue =
						sumValue
						+record.get('DAY1_Q')
						+record.get('DAY2_Q')
						+record.get('DAY3_Q')
						+record.get('DAY4_Q')
						+record.get('DAY5_Q')
						+record.get('DAY6_Q')
						+record.get('DAY7_Q')
						+record.get('DAY8_Q')
						+record.get('DAY9_Q')
						+record.get('DAY10_Q')
						+record.get('DAY11_Q')
						+record.get('DAY12_Q')
						+record.get('DAY13_Q')
						+record.get('DAY14_Q')
						+record.get('DAY15_Q')
						+record.get('DAY16_Q')
						+record.get('DAY17_Q')
						+record.get('DAY18_Q')
						+record.get('DAY19_Q')
						+record.get('DAY20_Q')
						+record.get('DAY21_Q')
						+record.get('DAY22_Q')
						+record.get('DAY23_Q')
						+record.get('DAY24_Q')
						+record.get('DAY25_Q')
						+record.get('DAY26_Q')
						+newValue
						+record.get('DAY28_Q')
						+record.get('DAY29_Q')
						+record.get('DAY30_Q')
						+record.get('DAY31_Q');


						record.set('TOT_Q',sumValue);

				break;
					}
				break;

				case "DAY28_Q" :
					if(record.get('GUBUN') == '<t:message code="system.label.product.plan" default="계획"/>'){
						if(newValue == ''){
							newValue = 0;
						}
						sumValue = 0;

						sumValue =
						sumValue
						+record.get('DAY1_Q')
						+record.get('DAY2_Q')
						+record.get('DAY3_Q')
						+record.get('DAY4_Q')
						+record.get('DAY5_Q')
						+record.get('DAY6_Q')
						+record.get('DAY7_Q')
						+record.get('DAY8_Q')
						+record.get('DAY9_Q')
						+record.get('DAY10_Q')
						+record.get('DAY11_Q')
						+record.get('DAY12_Q')
						+record.get('DAY13_Q')
						+record.get('DAY14_Q')
						+record.get('DAY15_Q')
						+record.get('DAY16_Q')
						+record.get('DAY17_Q')
						+record.get('DAY18_Q')
						+record.get('DAY19_Q')
						+record.get('DAY20_Q')
						+record.get('DAY21_Q')
						+record.get('DAY22_Q')
						+record.get('DAY23_Q')
						+record.get('DAY24_Q')
						+record.get('DAY25_Q')
						+record.get('DAY26_Q')
						+record.get('DAY27_Q')
						+newValue
						+record.get('DAY29_Q')
						+record.get('DAY30_Q')
						+record.get('DAY31_Q');


						record.set('TOT_Q',sumValue);

				break;
					}
				break;

				case "DAY29_Q" :
					if(record.get('GUBUN') == '<t:message code="system.label.product.plan" default="계획"/>'){
						if(newValue == ''){
							newValue = 0;
						}
						sumValue = 0;

						sumValue =
						sumValue
						+record.get('DAY1_Q')
						+record.get('DAY2_Q')
						+record.get('DAY3_Q')
						+record.get('DAY4_Q')
						+record.get('DAY5_Q')
						+record.get('DAY6_Q')
						+record.get('DAY7_Q')
						+record.get('DAY8_Q')
						+record.get('DAY9_Q')
						+record.get('DAY10_Q')
						+record.get('DAY11_Q')
						+record.get('DAY12_Q')
						+record.get('DAY13_Q')
						+record.get('DAY14_Q')
						+record.get('DAY15_Q')
						+record.get('DAY16_Q')
						+record.get('DAY17_Q')
						+record.get('DAY18_Q')
						+record.get('DAY19_Q')
						+record.get('DAY20_Q')
						+record.get('DAY21_Q')
						+record.get('DAY22_Q')
						+record.get('DAY23_Q')
						+record.get('DAY24_Q')
						+record.get('DAY25_Q')
						+record.get('DAY26_Q')
						+record.get('DAY27_Q')
						+record.get('DAY28_Q')
						+newValue
						+record.get('DAY30_Q')
						+record.get('DAY31_Q');


						record.set('TOT_Q',sumValue);

				break;
					}
				break;

				case "DAY30_Q" :
					if(record.get('GUBUN') == '<t:message code="system.label.product.plan" default="계획"/>'){
						if(newValue == ''){
							newValue = 0;
						}
						sumValue = 0;

						sumValue =
						sumValue
						+record.get('DAY1_Q')
						+record.get('DAY2_Q')
						+record.get('DAY3_Q')
						+record.get('DAY4_Q')
						+record.get('DAY5_Q')
						+record.get('DAY6_Q')
						+record.get('DAY7_Q')
						+record.get('DAY8_Q')
						+record.get('DAY9_Q')
						+record.get('DAY10_Q')
						+record.get('DAY11_Q')
						+record.get('DAY12_Q')
						+record.get('DAY13_Q')
						+record.get('DAY14_Q')
						+record.get('DAY15_Q')
						+record.get('DAY16_Q')
						+record.get('DAY17_Q')
						+record.get('DAY18_Q')
						+record.get('DAY19_Q')
						+record.get('DAY20_Q')
						+record.get('DAY21_Q')
						+record.get('DAY22_Q')
						+record.get('DAY23_Q')
						+record.get('DAY24_Q')
						+record.get('DAY25_Q')
						+record.get('DAY26_Q')
						+record.get('DAY27_Q')
						+record.get('DAY28_Q')
						+record.get('DAY29_Q')
						+newValue
						+record.get('DAY31_Q');


						record.set('TOT_Q',sumValue);

				break;
					}
				break;

				case "DAY31_Q" :
					if(record.get('GUBUN') == '<t:message code="system.label.product.plan" default="계획"/>'){
						if(newValue == ''){
							newValue = 0;
						}
						sumValue = 0;

						sumValue =
						sumValue
						+record.get('DAY1_Q')
						+record.get('DAY2_Q')
						+record.get('DAY3_Q')
						+record.get('DAY4_Q')
						+record.get('DAY5_Q')
						+record.get('DAY6_Q')
						+record.get('DAY7_Q')
						+record.get('DAY8_Q')
						+record.get('DAY9_Q')
						+record.get('DAY10_Q')
						+record.get('DAY11_Q')
						+record.get('DAY12_Q')
						+record.get('DAY13_Q')
						+record.get('DAY14_Q')
						+record.get('DAY15_Q')
						+record.get('DAY16_Q')
						+record.get('DAY17_Q')
						+record.get('DAY18_Q')
						+record.get('DAY19_Q')
						+record.get('DAY20_Q')
						+record.get('DAY21_Q')
						+record.get('DAY22_Q')
						+record.get('DAY23_Q')
						+record.get('DAY24_Q')
						+record.get('DAY25_Q')
						+record.get('DAY26_Q')
						+record.get('DAY27_Q')
						+record.get('DAY28_Q')
						+record.get('DAY29_Q')
						+record.get('DAY30_Q')
						+newValue;


						record.set('TOT_Q',sumValue);

				break;
					}
				break;

			}
			return rv;
		}
		});
}
</script>
