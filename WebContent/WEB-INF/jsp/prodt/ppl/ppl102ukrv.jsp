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
<t:appConfig pgmId="ppl102ukrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="ppl102ukrv"/> 					<!-- 사업장 -->
	<t:ExtComboStore comboType="WU" />											<!-- 작업장  -->
	<t:ExtComboStore comboType="AU" comboCode="P402" />							<!-- 참조유형 -->
	<t:ExtComboStore comboType="AU" comboCode="S002" />							<!-- 매출구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B020" />							<!-- 품목계정 -->
	<t:ExtComboStore items="${COMBO_WS_LIST}" storeId="wsList" />				<!-- 작업장 -->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />	<!-- 대분류 -->
 	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />	<!-- 중분류 -->
 	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />	<!-- 소분류 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
.x-change-cell3 {background-color: #fcfac5;}
</style>
<script type="text/javascript" >

var referOrderInformationWindow;		//수주정보참조
var referSalesPlanWindow;				//판매계획참조
var outDivCode = UserInfo.divCode;
var excelWindow; 						//생산계획 업로드 윈도우 생성

var BsaCodeInfo = {
	gsManageTimeYN:'${gsManageTimeYN}'
};

var isAutoTime = false;
if(BsaCodeInfo.gsAutoType=='Y')	{
	isAutoTime = true;
}


function appMain() {

	var mrpYnStore = Unilite.createStore('ppl102ukrvMRPYnStore', {
		fields	: ['text', 'value'],
		data	:  [
			{'text':'<t:message code="system.label.product.yes" default="예"/>'	, 'value':'Y'},
			{'text':'<t:message code="system.label.product.no" default="아니오"/>'	, 'value':'N'}
		]
	});

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'ppl102ukrvService.selectDetailList',
			update	: 'ppl102ukrvService.updateDetail',
			create	: 'ppl102ukrvService.insertDetail',
			destroy	: 'ppl102ukrvService.deleteDetail',
			syncAll	: 'ppl102ukrvService.saveAll'
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



	//작업장, 엑셀업로드 window의 Grid Model
	Unilite.defineModel('ppl102ukrvMasterModel1', {
		fields: [
			{name: 'COMP_CODE'			, text: 'COMP_CODE'				, type: 'string'},
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.product.division" default="사업장"/>'		, type: 'string'},
			{name: 'WORK_SHOP_CODE'		, text: '<t:message code="system.label.product.workcenter" default="작업장"/>'	, type: 'string', comboType:'WU', allowBlank: true},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.product.item" default="품목"/>'			, type: 'string'},
			{name: 'ITEM_INFO'			, text: '<t:message code="system.label.product.itemname" default="품목명"/>'		, type: 'string'},
			{name: 'ORDER_INFO'			, text: '<t:message code="system.label.product.soqty" default="수주량"/>'			, type: 'string'},

			//20181102 추가 (규격, 단위)
			{name: 'SPEC'				, text: '<t:message code="system.label.product.spec" default="규격"/>'			, type : 'string'},
			{name: 'STOCK_UNIT'			, text: '<t:message code="system.label.product.unit" default="단위"/>'			, type : 'string'},

			{name: 'GUBUN'				, text: '<t:message code="system.label.product.classfication" default="구분"/>'	, type: 'string'},
			{name: 'GUBUN_CODE'			, text: '<t:message code="system.label.product.classfication" default="구분"/>'	, type: 'string'},
			{name: 'TOT_Q'				, text: '<t:message code="system.label.product.monthlytotal" default="월합계"/>'	, type: 'uniQty'},
			{name: 'DAY1_Q'             , text: '<t:message code="system.label.product.1day" default="1일"/>'                , type: 'uniQty'},
            {name: 'DAY2_Q'             , text: '<t:message code="system.label.product.2day" default="2일"/>'                , type: 'uniQty'},
            {name: 'DAY3_Q'             , text: '<t:message code="system.label.product.3day" default="3일"/>'                , type: 'uniQty'},
            {name: 'DAY4_Q'             , text: '<t:message code="system.label.product.4day" default="4일"/>'                , type: 'uniQty'},
            {name: 'DAY5_Q'             , text: '<t:message code="system.label.product.5day" default="5일"/>'                , type: 'uniQty'},
            {name: 'DAY6_Q'             , text: '<t:message code="system.label.product.6day" default="6일"/>'                , type: 'uniQty'},
            {name: 'DAY7_Q'             , text: '<t:message code="system.label.product.7day" default="7일"/>'                , type: 'uniQty'},
            {name: 'DAY8_Q'             , text: '<t:message code="system.label.product.8day" default="8일"/>'                , type: 'uniQty'},
            {name: 'DAY9_Q'             , text: '<t:message code="system.label.product.9day" default="9일"/>'                , type: 'uniQty'},
            {name: 'DAY10_Q'            , text: '<t:message code="system.label.product.10day" default="10일"/>'          , type: 'uniQty'},
            {name: 'DAY11_Q'            , text: '<t:message code="system.label.product.11day" default="11일"/>'          , type: 'uniQty'},
            {name: 'DAY12_Q'            , text: '<t:message code="system.label.product.12day" default="12일"/>'          , type: 'uniQty'},
            {name: 'DAY13_Q'            , text: '<t:message code="system.label.product.13day" default="13일"/>'          , type: 'uniQty'},
            {name: 'DAY14_Q'            , text: '<t:message code="system.label.product.14day" default="14일"/>'          , type: 'uniQty'},
            {name: 'DAY15_Q'            , text: '<t:message code="system.label.product.15day" default="15일"/>'          , type: 'uniQty'},
            {name: 'DAY16_Q'            , text: '<t:message code="system.label.product.16day" default="16일"/>'          , type: 'uniQty'},
            {name: 'DAY17_Q'            , text: '<t:message code="system.label.product.17day" default="17일"/>'          , type: 'uniQty'},
            {name: 'DAY18_Q'            , text: '<t:message code="system.label.product.18day" default="18일"/>'          , type: 'uniQty'},
            {name: 'DAY19_Q'            , text: '<t:message code="system.label.product.19day" default="19일"/>'          , type: 'uniQty'},
            {name: 'DAY20_Q'            , text: '<t:message code="system.label.product.20day" default="20일"/>'          , type: 'uniQty'},
            {name: 'DAY21_Q'            , text: '<t:message code="system.label.product.21day" default="21일"/>'          , type: 'uniQty'},
            {name: 'DAY22_Q'            , text: '<t:message code="system.label.product.22day" default="22일"/>'          , type: 'uniQty'},
            {name: 'DAY23_Q'            , text: '<t:message code="system.label.product.23day" default="23일"/>'          , type: 'uniQty'},
            {name: 'DAY24_Q'            , text: '<t:message code="system.label.product.24day" default="24일"/>'          , type: 'uniQty'},
            {name: 'DAY25_Q'            , text: '<t:message code="system.label.product.25day" default="25일"/>'          , type: 'uniQty'},
            {name: 'DAY26_Q'            , text: '<t:message code="system.label.product.26day" default="26일"/>'          , type: 'uniQty'},
            {name: 'DAY27_Q'            , text: '<t:message code="system.label.product.27day" default="27일"/>'          , type: 'uniQty'},
            {name: 'DAY28_Q'            , text: '<t:message code="system.label.product.28day" default="28일"/>'          , type: 'uniQty'},
            {name: 'DAY29_Q'            , text: '<t:message code="system.label.product.29day" default="29일"/>'          , type: 'uniQty'},
            {name: 'DAY30_Q'            , text: '<t:message code="system.label.product.30day" default="30일"/>'          , type: 'uniQty'},
            {name: 'DAY31_Q'            , text: '<t:message code="system.label.product.31day" default="31일"/>'          , type: 'uniQty'},
			{name: 'ITEM'				, text: 'ITEM'					, type: 'string'},
			{name: 'ORDER_NUM'			, text: '<t:message code="system.label.product.sono" default="수주번호"/>'			, type: 'string'},
			{name: 'REMARK'				, text: 'REMARK'				, type: 'string'},
			{name: 'P_SEQ'				, text: '<t:message code="system.label.product.soseq" default="수주순번"/>'			, type: 'string'},
			{name: 'WORK_SHOP'			, text: '<t:message code="system.label.product.workcenter" default="작업장"/>'		, type: 'string'},
			{name: 'PLAN_TYPE'			, text: 'PLAN_TYPE'				, type: 'string'},
			{name: 'WORK_SHOP_CODE_OLD'	, text: 'WORK_SHOP_CODE_OLD'	, type: 'string'},
			//20181105 추가
			{name: 'CUSTOM_CODE'		, text: '<t:message code="system.label.product.custom" default="거래처"/>'			, type: 'string'},
			{name: 'CUSTOM_NAME'		, text: '<t:message code="system.label.product.custom" default="거래처"/>'			, type: 'string'},
			{name: 'DVRY_DATE'			, text: '<t:message code="system.label.product.deliverydate" default="납기일"/>'	, type: 'uniDate'},
			{name: 'ORDER_NUM_ORI'		, text: 'ORDER_NUM_ORI'			, type: 'string'},
			{name: 'SER_NO_ORI'			, text: 'SER_NO_ORI'			, type: 'string'}
		]
	});

	//품목
	Unilite.defineModel('ppl102ukrvMasterModel2', {
		fields: [
			{name: 'COMP_CODE'			, text: 'COMP_CODE'			, type: 'string'},
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.product.division" default="사업장"/>'		, type: 'string'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.product.item" default="품목"/>'			, type: 'string', allowBlank: true},
			{name: 'ITEM_INFO'			, text: '<t:message code="system.label.product.itemname" default="품목명"/>'		, type: 'string'},
			{name: 'ORDER_INFO'			, text: '<t:message code="system.label.product.soseq" default="수주순번"/>'			, type: 'string'},
			{name: 'WORK_SHOP_CODE'		, text: '<t:message code="system.label.product.workcenter" default="작업장"/>'		, type: 'string', comboType:'WU', allowBlank: true},

			//20181102 추가 (규격, 단위)
			{name: 'SPEC'				, text: '<t:message code="system.label.product.spec" default="규격"/>'			, type : 'string'},
			{name: 'STOCK_UNIT'			, text: '<t:message code="system.label.product.unit" default="단위"/>'			, type : 'string'},

			{name: 'GUBUN'				, text: '<t:message code="system.label.product.classfication" default="구분"/>'	, type: 'string'},
			{name: 'TOT_Q'				, text: '<t:message code="system.label.product.monthlytotal" default="월합계"/>'	, type: 'uniQty'},
			{name: 'DAY1_Q'				, text: '<t:message code="system.label.product.1day" default="1일"/>'				, type: 'uniQty'},
			{name: 'DAY2_Q'				, text: '<t:message code="system.label.product.2day" default="2일"/>'				, type: 'uniQty'},
			{name: 'DAY3_Q'				, text: '<t:message code="system.label.product.3day" default="3일"/>'				, type: 'uniQty'},
			{name: 'DAY4_Q'				, text: '<t:message code="system.label.product.4day" default="4일"/>'				, type: 'uniQty'},
			{name: 'DAY5_Q'				, text: '<t:message code="system.label.product.5day" default="5일"/>'				, type: 'uniQty'},
			{name: 'DAY6_Q'				, text: '<t:message code="system.label.product.6day" default="6일"/>'				, type: 'uniQty'},
			{name: 'DAY7_Q'				, text: '<t:message code="system.label.product.7day" default="7일"/>'				, type: 'uniQty'},
			{name: 'DAY8_Q'				, text: '<t:message code="system.label.product.8day" default="8일"/>'				, type: 'uniQty'},
			{name: 'DAY9_Q'				, text: '<t:message code="system.label.product.9day" default="9일"/>'				, type: 'uniQty'},
			{name: 'DAY10_Q'			, text: '<t:message code="system.label.product.10day" default="10일"/>'			, type: 'uniQty'},
			{name: 'DAY11_Q'			, text: '<t:message code="system.label.product.11day" default="11일"/>'			, type: 'uniQty'},
			{name: 'DAY12_Q'			, text: '<t:message code="system.label.product.12day" default="12일"/>'			, type: 'uniQty'},
			{name: 'DAY13_Q'			, text: '<t:message code="system.label.product.13day" default="13일"/>'			, type: 'uniQty'},
			{name: 'DAY14_Q'			, text: '<t:message code="system.label.product.14day" default="14일"/>'			, type: 'uniQty'},
			{name: 'DAY15_Q'			, text: '<t:message code="system.label.product.15day" default="15일"/>'			, type: 'uniQty'},
			{name: 'DAY16_Q'			, text: '<t:message code="system.label.product.16day" default="16일"/>'			, type: 'uniQty'},
			{name: 'DAY17_Q'			, text: '<t:message code="system.label.product.17day" default="17일"/>'			, type: 'uniQty'},
			{name: 'DAY18_Q'			, text: '<t:message code="system.label.product.18day" default="18일"/>'			, type: 'uniQty'},
			{name: 'DAY19_Q'			, text: '<t:message code="system.label.product.19day" default="19일"/>'			, type: 'uniQty'},
			{name: 'DAY20_Q'			, text: '<t:message code="system.label.product.20day" default="20일"/>'			, type: 'uniQty'},
			{name: 'DAY21_Q'			, text: '<t:message code="system.label.product.21day" default="21일"/>'			, type: 'uniQty'},
			{name: 'DAY22_Q'			, text: '<t:message code="system.label.product.22day" default="22일"/>'			, type: 'uniQty'},
			{name: 'DAY23_Q'			, text: '<t:message code="system.label.product.23day" default="23일"/>'			, type: 'uniQty'},
			{name: 'DAY24_Q'			, text: '<t:message code="system.label.product.24day" default="24일"/>'			, type: 'uniQty'},
			{name: 'DAY25_Q'			, text: '<t:message code="system.label.product.25day" default="25일"/>'			, type: 'uniQty'},
			{name: 'DAY26_Q'			, text: '<t:message code="system.label.product.26day" default="26일"/>'			, type: 'uniQty'},
			{name: 'DAY27_Q'			, text: '<t:message code="system.label.product.27day" default="27일"/>'			, type: 'uniQty'},
			{name: 'DAY28_Q'			, text: '<t:message code="system.label.product.28day" default="28일"/>'			, type: 'uniQty'},
			{name: 'DAY29_Q'			, text: '<t:message code="system.label.product.29day" default="29일"/>'			, type: 'uniQty'},
			{name: 'DAY30_Q'			, text: '<t:message code="system.label.product.30day" default="30일"/>'			, type: 'uniQty'},
			{name: 'DAY31_Q'			, text: '<t:message code="system.label.product.31day" default="31일"/>'			, type: 'uniQty'},
			{name: 'ITEM'				, text: 'ITEM'					, type: 'string'},
			{name: 'ORDER_NUM'			, text: '<t:message code="system.label.product.sono" default="수주번호"/>'			, type: 'string'},
			{name: 'REMARK'				, text: 'REMARK'				, type: 'string'},
			{name: 'P_SEQ'				, text: '<t:message code="system.label.product.soseq" default="수주순번"/>'			, type: 'int'},
			{name: 'WORK_SHOP'			, text: '<t:message code="system.label.product.workcenter" default="작업장"/>'		, type: 'string'},
			{name: 'PLAN_TYPE'			, text: 'PLAN_TYPE'				, type: 'string'},
			{name: 'WORK_SHOP_CODE_OLD'	, text: 'WORK_SHOP_CODE_OLD'	, type: 'string'},
			//20181105 추가
			{name: 'CUSTOM_CODE'		, text: '<t:message code="system.label.product.custom" default="거래처"/>'			, type: 'string'},
			{name: 'CUSTOM_NAME'		, text: '<t:message code="system.label.product.custom" default="거래처"/>'			, type: 'string'},
			{name: 'DVRY_DATE'			, text: '<t:message code="system.label.product.deliverydate" default="납기일"/>'	, type: 'uniDate'},
			{name: 'ORDER_NUM_ORI'		, text: 'ORDER_NUM_ORI'			, type: 'string'},
			{name: 'SER_NO_ORI'			, text: 'SER_NO_ORI'			, type: 'string'}
		]
	});



	//마스터 스토어 정의
	var masterStore1 = Unilite.createStore('ppl102ukrvmasterStore1', {
		model	: 'ppl102ukrvMasterModel1',
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
				var grid = Ext.getCmp('ppl102ukrvGrid1');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});

	//마스터 스토어 정의
	var masterStore2 = Unilite.createStore('ppl102ukrvmasterStore2', {
		model	: 'ppl102ukrvMasterModel2',
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
				var grid = Ext.getCmp('ppl102ukrvGrid2');
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
					panelResult.setValue('WORK_SHOP_CODE','');
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.product.planmonth" default="계획월"/>',
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
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
				},
                beforequery:function( queryPlan, eOpts )   {
                    var store = queryPlan.combo.store;
                    store.clearFilter();

                    if(!Ext.isEmpty(panelResult.getValue('DIV_CODE'))){
                        store.filterBy(function(record){
                            return record.get('option') == panelResult.getValue('DIV_CODE');
                        });
                    }else{
                        store.filterBy(function(record){
                            return false;
                        });
                    }
                }
			}
		},
		Unilite.popup('DIV_PUMOK',{
			fieldLabel		: '<t:message code="system.label.product.item" default="품목"/>',
			valueFieldName	: 'ITEM_CODE',
			textFieldName	: 'ITEM_NAME',
			validateBlank	: false,
			allowBlank      : true,	    // 2021.08.12 표준화 작업
			autoPopup       : false,	// 2021.08.12  표준화 작업
			listeners		: {
				onValueFieldChange: function(field, newValue, oldValue){	// 2021.08.12 표준화 작업
									panelResult.setValue('ITEM_CODE', newValue);
									if(!Ext.isObject(oldValue)) {
										panelResult.setValue('ITEM_NAME', '');
									}
				},
				onTextFieldChange: function(field, newValue, oldValue){		// 2021.08.12 표준화 작업
									panelResult.setValue('ITEM_NAME', newValue);
									if(!Ext.isObject(oldValue)) {
										panelResult.setValue('ITEM_CODE', '');
									}
				},
				onSelected: {
					fn: function(records, type) {
						console.log('records : ', records);
					},
					scope: this
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

					Unilite.messageBox(labelText+Msg.sMB083);
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
	var masterGrid1 = Unilite.createGrid('ppl102ukrvGrid1', {
		store: masterStore1,
		layout: 'fit',
		region:'center',
		enableColumnHide :true,
		sortableColumns : true,
		uniOpt: {
			expandLastColumn: false,
			useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			useGroupSummary: true,
			useRowNumberer: false,
			state: {
				useState: false,			//그리드 설정 버튼 사용 여부
				useStateList: false		//그리드 설정 목록 사용 여부
			}
//			filter: {
//				useFilter: true,
//				autoCreate: true
//			}
		},
		tbar: [{
			itemId: 'requestBtn',
			text: '<div style="color: blue"><t:message code="system.label.product.soinforeference" default="수주정보참조"/></div>',
			handler: function() {
				openOrderInformationWindow();
			}
		},{
			itemId: 'excelUploadButton',
			text: '<div style="color: blue"><t:message code="system.label.commonJS.excel.title" default="엑셀 업로드"/></div>',
			handler: function() {
				openExcelWindow();
			}
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
			{ dataIndex: 'WORK_SHOP_CODE'	, width: 80	, locked: true	, comboType: 'WU',
                listeners:{
                    render:function(elm){
                        elm.editor.on('beforequery',function(queryPlan, eOpts)  {
                            var store = queryPlan.combo.store;
                            var selRecord =  masterGrid1.uniOpt.currentRecord;
                            store.clearFilter();
                            if(!Ext.isEmpty(selRecord.get('DIV_CODE'))){
                                store.filterBy(function(record){
                                    return record.get('option') == selRecord.get('DIV_CODE');
                                });
                            }else{
                                store.filterBy(function(record){
                                    return false;
                                });
                            }
                       })
                    }
                }},
			{ dataIndex: 'ITEM_CODE'		, width: 120	, locked: true	,
				editor:Unilite.popup('DIV_PUMOK_G',{
					textFieldName: 'ITEM_CODE',
					DBtextFieldName: 'ITEM_CODE',
					extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode, POPUP_TYPE: 'GRID_CODE'},
					autoPopup: true,
					listeners: {
						onSelected: {
							fn: function(records, type) {
								var grdRecords	= masterStore1.data.items;
								var rowIndex	= masterGrid1.getSelectedRowIndex();
								var checkFlag	= false;
								Ext.each(records, function(record,i) {
									Ext.each(grdRecords, function(grdrecord,i) {
										if(record.ITEM_CODE.toUpperCase() == grdrecord.get('ITEM_CODE').toUpperCase() && rowIndex != i) {
											checkFlag = true;
											return false;
										}
									});
									if(checkFlag) {
										masterGrid1.setItemData(null,true);
										Unilite.messageBox('<t:message code="system.message.product.message003" default="동일한 품목이 입력 되었습니다."/>')
										return false;
									}
									console.log('record',record);
//									debugger;
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
			{ dataIndex: 'ITEM_INFO'		, width: 180	, locked: true,
				editor:Unilite.popup('DIV_PUMOK_G',{
					textFieldName: 'ITEM_INFO',
					DBtextFieldName: 'ITEM_CODE',
					extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode, POPUP_TYPE: 'GRID_CODE'},
					autoPopup: true,
					listeners: {
						onSelected: {
							fn: function(records, type) {
								var grdRecords	= masterStore1.data.items;
								var checkFlag	= false;
								Ext.each(records, function(record,i) {
									Ext.each(grdRecords, function(grdrecord,i) {
										if(record.ITEM_NAME == grdrecord.get('ITEM_INFO')) {
											checkFlag = true;
											return false;
										}
									});
									if(checkFlag) {
										masterGrid1.setItemData(null,true);
										Unilite.messageBox('<t:message code="system.message.product.message003" default="동일한 품목이 입력 되었습니다."/>')
										return false;
									}
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
//			{ dataIndex: 'ORDER_INFO'		, width: 120	, locked: true},

			//20181102 추가 (규격, 단위)
			{ dataIndex: 'SPEC'				, width: 80	, locked: true},
			{ dataIndex: 'STOCK_UNIT'		, width: 66		, locked: true},

			{ dataIndex:'ORDER_NUM'			, width: 120	, locked: true	, hidden: true,
				editor:Unilite.popup('ORDER_NUM_G',{
					textFieldName	: 'ORDER_NUM',
					DBtextFieldName	: 'ORDER_NUM',
					autoPopup		: true,
					listeners		: {
						onSelected: {
							fn: function(records, type) {
								var rowIndex = masterGrid1.getSelectedRowIndex();
								masterStore1.getAt(rowIndex).set('ORDER_NUM'	, records[0]['ORDER_NUM']);
								masterStore1.getAt(rowIndex).set('P_SEQ'		, records[0]['SER_NO']);
								masterStore1.getAt(rowIndex).set('CUSTOM_CODE'	, records[0]['CUSTOM_CODE']);
								masterStore1.getAt(rowIndex).set('CUSTOM_NAME'	, records[0]['CUSTOM_NAME']);
								masterStore1.getAt(rowIndex).set('DVRY_DATE'	, records[0]['DVRY_DATE']);
							},
							scope: this
						},
						onClear: function(type)	{
							var rowIndex = masterGrid1.getSelectedRowIndex();
							masterStore1.getAt(rowIndex).set('ORDER_NUM'	, "");
							masterStore1.getAt(rowIndex).set('P_SEQ'		, 0);
							masterStore1.getAt(rowIndex).set('CUSTOM_CODE'	, "");
							masterStore1.getAt(rowIndex).set('CUSTOM_NAME'	, "");
							masterStore1.getAt(rowIndex).set('DVRY_DATE'	, "");
						},
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE'), 'DETAIL_YN': 'Y'});
						}
					}
				})
			},
			{ dataIndex:'P_SEQ'				, width: 66		, locked: true, hidden: true},
			//20181105 추가 (거래처, 납기일)
			{ dataIndex: 'CUSTOM_CODE'		, width: 120	, locked: true	, hidden: true},
			{ dataIndex: 'CUSTOM_NAME'		, width: 120	, locked: true, hidden: true},
			{ dataIndex: 'DVRY_DATE'		, width: 80		, locked: true, hidden: true},

			{ dataIndex: 'GUBUN'			, width: 66		, align:'center', locked: true	, hidden: true},
			{ dataIndex: 'TOT_Q'			, width: 100	, locked: true},
			{text :'<t:message code="system.label.product.1day" default="1일"/>',
				columns:[
					{dataIndex:'DAY1_Q'	 , width: 70, summaryType: 'sum' }
				]
			},
			{text :'<t:message code="system.label.product.2day" default="2일"/>',
				columns:[
					{dataIndex:'DAY2_Q'	 , width: 70, summaryType: 'sum' }
				]
			},
			{text :'<t:message code="system.label.product.3day" default="3일"/>',
				columns:[
					{dataIndex:'DAY3_Q'	 , width: 70, summaryType: 'sum' }
				]
			},
			{text :'<t:message code="system.label.product.4day" default="4일"/>',
				columns:[
					{dataIndex:'DAY4_Q'	 , width: 70, summaryType: 'sum' }
				]
			},
			{text :'<t:message code="system.label.product.5day" default="5일"/>',
				columns:[
					{dataIndex:'DAY5_Q'	 , width: 70, summaryType: 'sum' }
				]
			},
			{text :'<t:message code="system.label.product.6day" default="6일"/>',
				columns:[
					{dataIndex:'DAY6_Q'	 , width: 70, summaryType: 'sum' }
				]
			},
			{text :'<t:message code="system.label.product.7day" default="7일"/>',
				columns:[
					{dataIndex:'DAY7_Q'	 , width: 70, summaryType: 'sum' }
				]
			},
			{text :'<t:message code="system.label.product.8day" default="8일"/>',
				columns:[
					{dataIndex:'DAY8_Q'	 , width: 70, summaryType: 'sum' }
				]
			},
			{text :'<t:message code="system.label.product.9day" default="9일"/>',
				columns:[
					{dataIndex:'DAY9_Q'	 , width: 70, summaryType: 'sum' }
				]
			},
			{text :'<t:message code="system.label.product.10day" default="10일"/>',
				columns:[
					{dataIndex:'DAY10_Q'	 , width: 70, summaryType: 'sum' }
				]
			},
			{text :'<t:message code="system.label.product.11day" default="11일"/>',
				columns:[
					{dataIndex:'DAY11_Q'	 , width: 70, summaryType: 'sum' }
				]
			},
			{text :'<t:message code="system.label.product.12day" default="12일"/>',
				columns:[
					{dataIndex:'DAY12_Q'	 , width: 70, summaryType: 'sum' }
				]
			},
			{text :'<t:message code="system.label.product.13day" default="13일"/>',
				columns:[
					{dataIndex:'DAY13_Q'	 , width: 70, summaryType: 'sum' }
				]
			},
			{text :'<t:message code="system.label.product.14day" default="14일"/>',
				columns:[
					{dataIndex:'DAY14_Q'	 , width: 70, summaryType: 'sum' }
				]
			},
			{text :'<t:message code="system.label.product.15day" default="15일"/>',
				columns:[
					{dataIndex:'DAY15_Q'	 , width: 70, summaryType: 'sum' }
				]
			},
			{text :'<t:message code="system.label.product.16day" default="16일"/>',
				columns:[
					{dataIndex:'DAY16_Q'	 , width: 70, summaryType: 'sum' }
				]
			},
			{text :'<t:message code="system.label.product.17day" default="17일"/>',
				columns:[
					{dataIndex:'DAY17_Q'	 , width: 70, summaryType: 'sum' }
				]
			},
			{text :'<t:message code="system.label.product.18day" default="18일"/>',
				columns:[
					{dataIndex:'DAY18_Q'	 , width: 70, summaryType: 'sum' }
				]
			},
			{text :'<t:message code="system.label.product.19day" default="19일"/>',
				columns:[
					{dataIndex:'DAY19_Q'	 , width: 70, summaryType: 'sum' }
				]
			},
			{text :'<t:message code="system.label.product.20day" default="20일"/>',
				columns:[
					{dataIndex:'DAY20_Q'	 , width: 70, summaryType: 'sum' }
				]
			},
			{text :'<t:message code="system.label.product.21day" default="21일"/>',
				columns:[
					{dataIndex:'DAY21_Q'	 , width: 70, summaryType: 'sum' }
				]
			},
			{text :'<t:message code="system.label.product.22day" default="22일"/>',
				columns:[
					{dataIndex:'DAY22_Q'	 , width: 70, summaryType: 'sum' }
				]
			},
			{text :'<t:message code="system.label.product.23day" default="23일"/>',
				columns:[
					{dataIndex:'DAY23_Q'	 , width: 70, summaryType: 'sum' }
				]
			},
			{text :'<t:message code="system.label.product.24day" default="24일"/>',
				columns:[
					{dataIndex:'DAY24_Q'	 , width: 70, summaryType: 'sum' }
				]
			},
			{text :'<t:message code="system.label.product.25day" default="25일"/>',
				columns:[
					{dataIndex:'DAY25_Q'	 , width: 70, summaryType: 'sum' }
				]
			},
			{text :'<t:message code="system.label.product.26day" default="26일"/>',
				columns:[
					{dataIndex:'DAY26_Q'	 , width: 70, summaryType: 'sum' }
				]
			},
			{text :'<t:message code="system.label.product.27day" default="27일"/>',
				columns:[
					{dataIndex:'DAY27_Q'	 , width: 70, summaryType: 'sum' }
				]
			},
			{text :'<t:message code="system.label.product.28day" default="28일"/>',
				columns:[
					{dataIndex:'DAY28_Q'	 , width: 70, summaryType: 'sum' }
				]
			},
			{text :'<t:message code="system.label.product.29day" default="29일"/>',
				columns:[
					{dataIndex:'DAY29_Q'	 , width: 70, summaryType: 'sum' }
				]
			},
			{text :'<t:message code="system.label.product.30day" default="30일"/>',
				columns:[
					{dataIndex:'DAY30_Q'	 , width: 70, summaryType: 'sum' }
				]
			},
			{text :'<t:message code="system.label.product.31day" default="31일"/>',
				columns:[
					{dataIndex:'DAY31_Q'	 , width: 70, summaryType: 'sum' }
				]
			},
			{ dataIndex:'ITEM'				, width: 66		,hidden: true},
			{ dataIndex:'REMARK'			, width: 66		,hidden: true},
			{ dataIndex:'WORK_SHOP'			, width: 66		,hidden: true},
			{ dataIndex:'PLAN_TYPE'			, width: 66		,hidden: true},
			{ dataIndex:'WORK_SHOP_CODE_OLD', width: 66		,hidden: true},
			{ dataIndex:'ORDER_NUM_ORI'		, width: 66		,hidden: true},
			{ dataIndex:'SER_NO_ORI'		, width: 66		,hidden: true}
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

	var masterGrid2 = Unilite.createGrid('ppl102ukrvGrid2', {
		store: masterStore2,
		layout: 'fit',
		region:'center',
			enableColumnHide :true,
			sortableColumns : true,
		uniOpt: {
			expandLastColumn: true,
			useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			useGroupSummary: false,
			useRowNumberer: false,
			state: {
				useState: false,			//그리드 설정 버튼 사용 여부
				useStateList: false		//그리드 설정 목록 사용 여부
			}
//			filter: {
//				useFilter: true,
//				autoCreate: true
//			}
		},
		tbar: [{
			itemId: 'requestBtn',
			text: '<div style="color: blue"><t:message code="system.label.product.soinforeference" default="수주정보참조"/></div>',
			handler: function() {
				openOrderInformationWindow();
			}
		},{
			itemId: 'excelUploadButton',
			text: '<div style="color: blue"><t:message code="system.label.commonJS.excel.title" default="엑셀 업로드"/></div>',
			handler: function() {
				openExcelWindow();
			}
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
								var grdRecords	= masterStore2.data.items;
								var checkFlag	= false;
								Ext.each(records, function(record,i) {
									Ext.each(grdRecords, function(grdrecord,i) {
										if(record.ITEM_CODE.toUpperCase() == grdrecord.get('ITEM_CODE').toUpperCase() && rowIndex != i) {
											checkFlag = true;
											return false;
										}
									});
									if(checkFlag) {
										masterGrid2.setItemData(null,true);
										Unilite.messageBox('<t:message code="system.message.product.message003" default="동일한 품목이 입력 되었습니다."/>')
										return false;
									}
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
			{ dataIndex: 'ITEM_INFO'		, width: 180	, locked: true,
				editor:Unilite.popup('DIV_PUMOK_G',{
					textFieldName: 'ITEM_INFO',
					DBtextFieldName: 'ITEM_CODE',
					extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode, POPUP_TYPE: 'GRID_CODE'},
					autoPopup: true,
					listeners: {
						onSelected: {
							fn: function(records, type) {
								var grdRecords	= masterStore2.data.items;
								var checkFlag	= false;
								Ext.each(records, function(record,i) {
									Ext.each(grdRecords, function(grdrecord,i) {
										if(record.ITEM_NAME == grdrecord.get('ITEM_INFO')) {
											checkFlag = true;
											return false;
										}
									});
									if(checkFlag) {
										masterGrid2.setItemData(null,true);
										Unilite.messageBox('<t:message code="system.message.product.message003" default="동일한 품목이 입력 되었습니다."/>')
										return false;
									}
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
// 			{ dataIndex:'WORK_SHOP_CODE'	, width: 120	, locked: true},
			{ dataIndex: 'WORK_SHOP_CODE'	, width: 80	, locked: true	, comboType: 'WU',
                listeners:{
                    render:function(elm){
                        elm.editor.on('beforequery',function(queryPlan, eOpts)  {
                            var store = queryPlan.combo.store;
                            var selRecord =  masterGrid2.uniOpt.currentRecord;
                            store.clearFilter();
                            if(!Ext.isEmpty(selRecord.get('DIV_CODE'))){
                                store.filterBy(function(record){
                                    return record.get('option') == selRecord.get('DIV_CODE');
                                });
                            }else{
                                store.filterBy(function(record){
                                    return false;
                                });
                            }
                       })
                    }
                }},

			//20181102 추가 (규격, 단위)
			{ dataIndex: 'SPEC'				, width: 80	, locked: true},
			{ dataIndex: 'STOCK_UNIT'		, width: 66		, locked: true},

			{ dataIndex:'ORDER_NUM'			, width: 120	, locked: true	, hidden: true,
				editor:Unilite.popup('ORDER_NUM_G',{
					textFieldName	: 'ORDER_NUM',
					DBtextFieldName	: 'ORDER_NUM',
					autoPopup		: true,
					listeners		: {
						onSelected: {
							fn: function(records, type) {
								var rowIndex = masterGrid1.getSelectedRowIndex();
								masterStore1.getAt(rowIndex).set('ORDER_NUM'	, records[0]['ORDER_NUM']);
								masterStore1.getAt(rowIndex).set('P_SEQ'		, records[0]['SER_NO']);
								masterStore1.getAt(rowIndex).set('CUSTOM_CODE'	, records[0]['CUSTOM_CODE']);
								masterStore1.getAt(rowIndex).set('CUSTOM_NAME'	, records[0]['CUSTOM_NAME']);
								masterStore1.getAt(rowIndex).set('DVRY_DATE'	, records[0]['DVRY_DATE']);
							},
							scope: this
						},
						onClear: function(type)	{
							var rowIndex = masterGrid1.getSelectedRowIndex();
							masterStore1.getAt(rowIndex).set('ORDER_NUM'	, "");
							masterStore1.getAt(rowIndex).set('P_SEQ'		, 0);
							masterStore1.getAt(rowIndex).set('CUSTOM_CODE'	, "");
							masterStore1.getAt(rowIndex).set('CUSTOM_NAME'	, "");
							masterStore1.getAt(rowIndex).set('DVRY_DATE'	, "");
						},
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE'), 'DETAIL_YN': 'Y'});
						}
					}
				})
			},
			{ dataIndex:'P_SEQ'				, width: 80		, locked: true, hidden: true},
			//20181105 추가 (거래처, 납기일)
			{ dataIndex: 'CUSTOM_CODE'		, width: 120	, locked: true	, hidden: true},
			{ dataIndex: 'CUSTOM_NAME'		, width: 120	, locked: true, hidden: true},
			{ dataIndex: 'DVRY_DATE'		, width: 80		, locked: true, hidden: true},

			{ dataIndex: 'GUBUN'			, width: 66		, align:'center', locked: true	, hidden: true},
			{ dataIndex: 'TOT_Q'			, width: 100	, locked: true},
			{text :'<t:message code="system.label.product.1day" default="1일"/>',
                columns:[
                    {dataIndex:'DAY1_Q'  , width: 70, summaryType: 'sum' }
                ]
            },
            {text :'<t:message code="system.label.product.2day" default="2일"/>',
                columns:[
                    {dataIndex:'DAY2_Q'  , width: 70, summaryType: 'sum' }
                ]
            },
            {text :'<t:message code="system.label.product.3day" default="3일"/>',
                columns:[
                    {dataIndex:'DAY3_Q'  , width: 70, summaryType: 'sum' }
                ]
            },
            {text :'<t:message code="system.label.product.4day" default="4일"/>',
                columns:[
                    {dataIndex:'DAY4_Q'  , width: 70, summaryType: 'sum' }
                ]
            },
            {text :'<t:message code="system.label.product.5day" default="5일"/>',
                columns:[
                    {dataIndex:'DAY5_Q'  , width: 70, summaryType: 'sum' }
                ]
            },
            {text :'<t:message code="system.label.product.6day" default="6일"/>',
                columns:[
                    {dataIndex:'DAY6_Q'  , width: 70, summaryType: 'sum' }
                ]
            },
            {text :'<t:message code="system.label.product.7day" default="7일"/>',
                columns:[
                    {dataIndex:'DAY7_Q'  , width: 70, summaryType: 'sum' }
                ]
            },
            {text :'<t:message code="system.label.product.8day" default="8일"/>',
                columns:[
                    {dataIndex:'DAY8_Q'  , width: 70, summaryType: 'sum' }
                ]
            },
            {text :'<t:message code="system.label.product.9day" default="9일"/>',
                columns:[
                    {dataIndex:'DAY9_Q'  , width: 70, summaryType: 'sum' }
                ]
            },
            {text :'<t:message code="system.label.product.10day" default="10일"/>',
                columns:[
                    {dataIndex:'DAY10_Q'     , width: 70, summaryType: 'sum' }
                ]
            },
            {text :'<t:message code="system.label.product.11day" default="11일"/>',
                columns:[
                    {dataIndex:'DAY11_Q'     , width: 70, summaryType: 'sum' }
                ]
            },
            {text :'<t:message code="system.label.product.12day" default="12일"/>',
                columns:[
                    {dataIndex:'DAY12_Q'     , width: 70, summaryType: 'sum' }
                ]
            },
            {text :'<t:message code="system.label.product.13day" default="13일"/>',
                columns:[
                    {dataIndex:'DAY13_Q'     , width: 70, summaryType: 'sum' }
                ]
            },
            {text :'<t:message code="system.label.product.14day" default="14일"/>',
                columns:[
                    {dataIndex:'DAY14_Q'     , width: 70, summaryType: 'sum' }
                ]
            },
            {text :'<t:message code="system.label.product.15day" default="15일"/>',
                columns:[
                    {dataIndex:'DAY15_Q'     , width: 70, summaryType: 'sum' }
                ]
            },
            {text :'<t:message code="system.label.product.16day" default="16일"/>',
                columns:[
                    {dataIndex:'DAY16_Q'     , width: 70, summaryType: 'sum' }
                ]
            },
            {text :'<t:message code="system.label.product.17day" default="17일"/>',
                columns:[
                    {dataIndex:'DAY17_Q'     , width: 70, summaryType: 'sum' }
                ]
            },
            {text :'<t:message code="system.label.product.18day" default="18일"/>',
                columns:[
                    {dataIndex:'DAY18_Q'     , width: 70, summaryType: 'sum' }
                ]
            },
            {text :'<t:message code="system.label.product.19day" default="19일"/>',
                columns:[
                    {dataIndex:'DAY19_Q'     , width: 70, summaryType: 'sum' }
                ]
            },
            {text :'<t:message code="system.label.product.20day" default="20일"/>',
                columns:[
                    {dataIndex:'DAY20_Q'     , width: 70, summaryType: 'sum' }
                ]
            },
            {text :'<t:message code="system.label.product.21day" default="21일"/>',
                columns:[
                    {dataIndex:'DAY21_Q'     , width: 70, summaryType: 'sum' }
                ]
            },
            {text :'<t:message code="system.label.product.22day" default="22일"/>',
                columns:[
                    {dataIndex:'DAY22_Q'     , width: 70, summaryType: 'sum' }
                ]
            },
            {text :'<t:message code="system.label.product.23day" default="23일"/>',
                columns:[
                    {dataIndex:'DAY23_Q'     , width: 70, summaryType: 'sum' }
                ]
            },
            {text :'<t:message code="system.label.product.24day" default="24일"/>',
                columns:[
                    {dataIndex:'DAY24_Q'     , width: 70, summaryType: 'sum' }
                ]
            },
            {text :'<t:message code="system.label.product.25day" default="25일"/>',
                columns:[
                    {dataIndex:'DAY25_Q'     , width: 70, summaryType: 'sum' }
                ]
            },
            {text :'<t:message code="system.label.product.26day" default="26일"/>',
                columns:[
                    {dataIndex:'DAY26_Q'     , width: 70, summaryType: 'sum' }
                ]
            },
            {text :'<t:message code="system.label.product.27day" default="27일"/>',
                columns:[
                    {dataIndex:'DAY27_Q'     , width: 70, summaryType: 'sum' }
                ]
            },
            {text :'<t:message code="system.label.product.28day" default="28일"/>',
                columns:[
                    {dataIndex:'DAY28_Q'     , width: 70, summaryType: 'sum' }
                ]
            },
            {text :'<t:message code="system.label.product.29day" default="29일"/>',
                columns:[
                    {dataIndex:'DAY29_Q'     , width: 70, summaryType: 'sum' }
                ]
            },
            {text :'<t:message code="system.label.product.30day" default="30일"/>',
                columns:[
                    {dataIndex:'DAY30_Q'     , width: 70, summaryType: 'sum' }
                ]
            },
            {text :'<t:message code="system.label.product.31day" default="31일"/>',
                columns:[
                    {dataIndex:'DAY31_Q'     , width: 70, summaryType: 'sum' }
                ]
            },
			{ dataIndex:'ITEM'				, width: 66		,hidden: true},
			{ dataIndex:'REMARK'			, width: 66		,hidden: true},
			{ dataIndex:'WORK_SHOP'			, width: 66		,hidden: true},
			{ dataIndex:'PLAN_TYPE'			, width: 66		,hidden: true},
			{ dataIndex:'WORK_SHOP_CODE_OLD', width: 66		,hidden: true},
			{ dataIndex:'ORDER_NUM_ORI'		, width: 66		,hidden: true},
			{ dataIndex:'SER_NO_ORI'		, width: 66		,hidden: true}
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
	Unilite.defineModel('ppl102ukrvOrderModel', {
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
	var OrderStore = Unilite.createStore('ppl102ukrvOrderStore', {
		model	: 'ppl102ukrvOrderModel',
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
				var grid = Ext.getCmp('ppl102ukrvOrderGrid');
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
	var OrderGrid = Unilite.createGrid('ppl102ukrvOrderGrid', {
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
	Unilite.defineModel('ppl102ukrvSalesPlanModel', {
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
	var SalesPlanStore = Unilite.createStore('ppl102ukrvSalesPlanStore', {
		model: 'ppl102ukrvSalesPlanModel',
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
				var grid = Ext.getCmp('ppl102ukrvSalesPlanGrid');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});

	/**
	 * 판매계획을 참조하기 위한 Search Form, Grid, Inner Window 정의
	 */
	//판매계획 참조 폼 정의
	var SalesPlanSearch = Unilite.createSearchForm('ppl102ukrvSalesPlanForm', {
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
	var SalesPlanGrid = Unilite.createGrid('ppl102ukrvSalesPlanGrid', {
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
						UniAppManager.setToolbarButtons(['newData'], true);
						break;

					case 'masterGrid2' :
						panelResult.setValue('TYPE', 'I');
						masterStore2.loadStoreRecords();
						UniAppManager.setToolbarButtons(['newData'], true);
						break;

					default:
						break;
				}
			}
		}
	});




	//생산계획 엑셀업로드 윈도우 생성 함수
	function openExcelWindow() {
		var me = this;
		var vParam = {};
		var appName = 'Unilite.com.excel.ExcelUpload';
		//필수 입력정보 체크
		if (!panelResult.getInvalidMessage()) {
			return false;
		}
		if(masterStore1.isDirty() || masterStore2.isDirty()) {				//화면에 저장할 내용이 있을 경우 저장여부 확인
			if(confirm('<t:message code="system.message.commonJS.baseApp.confirmSave" default="변경된 내용을 저장하시겠습니까?"/>')){
				UniAppManager.app.onSaveDataButtonDown();
				return;
			}else {
				masterGrid1.reset();
				masterStore1.clearData();
				masterGrid2.reset();
				masterStore2.clearData();
			}
		}
		if(!Ext.isEmpty(excelWindow)){
			excelWindow.extParam.COMP_CODE		= UserInfo.compCode;
			excelWindow.extParam.DIV_CODE		= panelResult.getValue('DIV_CODE');
		}
		if(!excelWindow) {
			excelWindow = Ext.WindowMgr.get(appName);
			excelWindow = Ext.create( appName, {
				excelConfigName: 'ppl102ukrv',
				width	: 600,
				height	: 400,
				modal	: false,
				extParam: {
					'PGM_ID'			: 'ppl102ukrv',
					'COMP_CODE'			: UserInfo.compCode,
					'DIV_CODE'			: panelResult.getValue('DIV_CODE')
				},
				grids: [{							//팝업창에서 가져오는 그리드
					itemId		: 'grid01',
					title		: '<t:message code="system.label.sales.weeklysalesplanexcelupload" default="주간판매계획 엑셀업로드"/>',
					useCheckbox	: true,
					model		: 'ppl102ukrvMasterModel1',			//masterGrid1 모델 같이 사용
					readApi		: 'ppl102ukrvService.selectExcelUploadSheet1',
					columns		: [
						{dataIndex: '_EXCEL_JOBID'		, width: 100	, hidden: true},
						{dataIndex: 'COMP_CODE'			, width: 80		, hidden: true },
						{dataIndex: 'DIV_CODE'			, width: 80		, hidden: true },
						{dataIndex: 'WORK_SHOP_CODE'	, width: 80		, comboType: 'WU'},
						{dataIndex: 'ITEM_CODE'			, width: 120},
						{dataIndex: 'ITEM_INFO'			, width: 180},
						{dataIndex: 'TOT_Q'				, width: 100},
						{dataIndex:'DAY1_Q'				, width: 66},
						{dataIndex:'DAY2_Q'				, width: 66},
						{dataIndex:'DAY3_Q'				, width: 66},
						{dataIndex:'DAY4_Q'				, width: 66},
						{dataIndex:'DAY5_Q'				, width: 66},
						{dataIndex:'DAY6_Q'				, width: 66},
						{dataIndex:'DAY7_Q'				, width: 66},
						{dataIndex:'DAY8_Q'				, width: 66},
						{dataIndex:'DAY9_Q'				, width: 66},
						{dataIndex:'DAY10_Q'			, width: 66},
						{dataIndex:'DAY11_Q'			, width: 66},
						{dataIndex:'DAY12_Q'			, width: 66},
						{dataIndex:'DAY13_Q'			, width: 66},
						{dataIndex:'DAY14_Q'			, width: 66},
						{dataIndex:'DAY15_Q'			, width: 66},
						{dataIndex:'DAY16_Q'			, width: 66},
						{dataIndex:'DAY17_Q'			, width: 66},
						{dataIndex:'DAY18_Q'			, width: 66},
						{dataIndex:'DAY19_Q'			, width: 66},
						{dataIndex:'DAY20_Q'			, width: 66},
						{dataIndex:'DAY21_Q'			, width: 66},
						{dataIndex:'DAY22_Q'			, width: 66},
						{dataIndex:'DAY23_Q'			, width: 66},
						{dataIndex:'DAY24_Q'			, width: 66},
						{dataIndex:'DAY25_Q'			, width: 66},
						{dataIndex:'DAY26_Q'			, width: 66},
						{dataIndex:'DAY27_Q'			, width: 66},
						{dataIndex:'DAY28_Q'			, width: 66},
						{dataIndex:'DAY29_Q'			, width: 66},
						{dataIndex:'DAY30_Q'			, width: 66},
						{dataIndex:'DAY31_Q'			, width: 66}
					]
				}],
				listeners: {
					beforeshow: function( panel, eOpts )	{
						//행추가 후에는 master 입력값 변경 불가
						panelResult.setAllFieldsReadOnly(true);
					},
					close: function() {
						this.hide();
					}
				},

				onApply: function() {
					excelWindow.getEl().mask('<t:message code="system.label.product.loading" default="로딩중..."/>','loading-indicator');
					var flag	= true
					var grid	= this.down('#grid01');
					var records = grid.getSelectionModel().getSelection();
					flag		=  UniAppManager.app.fnMakeExcelRef(records);
					if(flag) {
						var beforeRM = grid.getStore().count();
						grid.getStore().remove(records);
						var afterRM = grid.getStore().count();
						if (beforeRM > 0 && afterRM == 0){
							excelWindow.close();
						}
					}
					excelWindow.getEl().unmask();
					//버튼세팅
					UniAppManager.setToolbarButtons('newData'	, true);
					UniAppManager.setToolbarButtons('delete'	, false);
				},

				//툴바 세팅
				_setToolBar: function() {
					var me = this;
					me.tbar = [
					'->',
					{
						xtype	: 'button',
						text	: '<t:message code="system.label.commonJS.excel.btnUpload" default="업로드"/>',
						tooltip	: '<t:message code="system.label.commonJS.excel.btnUpload" default="업로드"/>',
						width	: 60,
						handler: function() {
							me.jobID = null;
							me.uploadFile();
						}
					},{
						xtype	: 'button',
						text	: '<t:message code="system.label.commonJS.excel.btnApply" default="적용"/>',
						tooltip	: '<t:message code="system.label.commonJS.excel.btnApply" default="적용"/>',
						width	: 60,
						handler	: function() {
							var grids	= me.down('grid');
							var isError	= false;
							if(Ext.isDefined(grids.getEl()))	{
								grids.getEl().mask();
							}
							Ext.each(grids, function(grid, i){
								if(me.grids[0].useCheckbox) {
									var records = grid.getSelectionModel().getSelection();
								} else {
									var records = grid.getStore().data.items;
								}
								return Ext.each(records, function(record, i){
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
								Unilite.messageBox('<t:message code="system.message.commonJS.excel.rowErrorText" default="에러가 있는 행은 적용이 불가능합니다."/>');
							}
						}
					},{
							xtype: 'tbspacer'
					},{
							xtype: 'tbseparator'
					},{
							xtype: 'tbspacer'
					},{
						xtype: 'button',
						text : '<t:message code="system.label.commonJS.excel.btnClose" default="닫기"/>',
						tooltip : '<t:message code="system.label.commonJS.excel.btnClose" default="닫기"/>',
						handler: function() {
							var grid = me.down('#grid01');
							grid.getStore().removeAll();
							me.hide();
						}
					}
				]}
			});
		}
		excelWindow.center();
		excelWindow.show();
	};














	 /** main app
	 */
	Unilite.Main({
		id			: 'ppl102ukrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				tab, panelResult
			]
		}],
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons(['reset', /*'newData', */'prev', 'next'], true);
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
					UniAppManager.setToolbarButtons('newData', true);
				}
				if(activeTabId == 'masterGrid2'){
					masterStore2.loadStoreRecords();
				}
				UniAppManager.setToolbarButtons('reset',true);
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
				COMP_CODE		: compCode,		/* 법인코드*/
				DIV_CODE		: divCode,		/* 사업장*/
				WORK_SHOP_CODE  : workShopCode,	/* 작업장 */
				PRODT_PLAN_DATE : prodtPlanDate,/* 계획정보 - 계획일 */
				GUBUN			: '<t:message code="system.label.product.plan" default="계획"/>',
				PLAN_TYPE		: 'P',
				REMARK			: '',
				ORDER_NUM		: '',
				P_SEQ			: seq,			/* 순번 */
				ORDER_NUM_ORI	: '',
				SER_NO_ORI		: seq			/* 순번 */
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
				masterStore1.clearData();
			}
			if(activeTabId == 'masterGrid2'){
				masterGrid2.reset();
				masterStore2.clearData();
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
					Unilite.messageBox("작업장은 필수값입니다.");
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
					Unilite.messageBox("품목은 필수값입니다.");
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
			var as = Ext.getCmp('ppl102ukrvAdvanceSerch');
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
				Unilite.messageBox('<t:message code="system.message.product.datacheck001" default="필수입력 항목입니다."/>');
				return false;
			}
			//마스터 데이타 수정 못 하도록 설정
			return panelResult.setAllFieldsReadOnly(true);
		},
		fnMakeExcelRef: function(records){		//엑셀 업로드 적용
			var newDetailRecords	= new Array();
			var flag				= true;
			var activeTabId			= tab.getActiveTab().getId();
			if(activeTabId == 'masterGrid1'){
				var activeStore = masterStore1;
			}
			if(activeTabId == 'masterGrid2'){
				var activeStore = masterStore2;
			}

			if(!this.checkForNewDetail()){
				flag = false;
				return false;
			}
			Ext.each(records, function(record,i){
				newDetailRecords[i] = activeStore.model.create();
				newDetailRecords[i].set('COMP_CODE'			, record.get('COMP_CODE'));
				newDetailRecords[i].set('DIV_CODE'			, record.get('DIV_CODE'));
				newDetailRecords[i].set('WORK_SHOP_CODE'	, record.get('WORK_SHOP_CODE'));
				newDetailRecords[i].set('WORK_SHOP_CODE_OLD', record.get('WORK_SHOP_CODE'));
				newDetailRecords[i].set('ITEM_CODE'			, record.get('ITEM_CODE'));
				newDetailRecords[i].set('ITEM'				, record.get('ITEM_CODE'));
				newDetailRecords[i].set('ITEM_INFO'			, record.get('ITEM_INFO'));
				newDetailRecords[i].set('SPEC'				, record.get('SPEC'));
				newDetailRecords[i].set('STOCK_UNIT'		, record.get('STOCK_UNIT'));
				newDetailRecords[i].set('PRODT_PLAN_DATE'	, UniDate.get('today'));
				newDetailRecords[i].set('PLAN_TYPE'			, 'P');
				newDetailRecords[i].set('REMARK'			, '');
				newDetailRecords[i].set('ORDER_NUM'			, '');
				newDetailRecords[i].set('P_SEQ'				, 0);
				newDetailRecords[i].set('ORDER_NUM_ORI'		, '');
				newDetailRecords[i].set('SER_NO_ORI'		, 0);
				newDetailRecords[i].set('TOT_Q'				, record.get('TOT_Q'));
				newDetailRecords[i].set('DAY1_Q'			, record.get('DAY1_Q'));
				newDetailRecords[i].set('DAY2_Q'			, record.get('DAY2_Q'));
				newDetailRecords[i].set('DAY3_Q'			, record.get('DAY3_Q'));
				newDetailRecords[i].set('DAY4_Q'			, record.get('DAY4_Q'));
				newDetailRecords[i].set('DAY5_Q'			, record.get('DAY5_Q'));
				newDetailRecords[i].set('DAY6_Q'			, record.get('DAY6_Q'));
				newDetailRecords[i].set('DAY7_Q'			, record.get('DAY7_Q'));
				newDetailRecords[i].set('DAY8_Q'			, record.get('DAY8_Q'));
				newDetailRecords[i].set('DAY9_Q'			, record.get('DAY9_Q'));
				newDetailRecords[i].set('DAY10_Q'			, record.get('DAY10_Q'));
				newDetailRecords[i].set('DAY11_Q'			, record.get('DAY11_Q'));
				newDetailRecords[i].set('DAY12_Q'			, record.get('DAY12_Q'));
				newDetailRecords[i].set('DAY13_Q'			, record.get('DAY13_Q'));
				newDetailRecords[i].set('DAY14_Q'			, record.get('DAY14_Q'));
				newDetailRecords[i].set('DAY15_Q'			, record.get('DAY15_Q'));
				newDetailRecords[i].set('DAY16_Q'			, record.get('DAY16_Q'));
				newDetailRecords[i].set('DAY17_Q'			, record.get('DAY17_Q'));
				newDetailRecords[i].set('DAY18_Q'			, record.get('DAY18_Q'));
				newDetailRecords[i].set('DAY19_Q'			, record.get('DAY19_Q'));
				newDetailRecords[i].set('DAY20_Q'			, record.get('DAY20_Q'));
				newDetailRecords[i].set('DAY21_Q'			, record.get('DAY21_Q'));
				newDetailRecords[i].set('DAY22_Q'			, record.get('DAY22_Q'));
				newDetailRecords[i].set('DAY23_Q'			, record.get('DAY23_Q'));
				newDetailRecords[i].set('DAY24_Q'			, record.get('DAY24_Q'));
				newDetailRecords[i].set('DAY25_Q'			, record.get('DAY25_Q'));
				newDetailRecords[i].set('DAY26_Q'			, record.get('DAY26_Q'));
				newDetailRecords[i].set('DAY27_Q'			, record.get('DAY27_Q'));
				newDetailRecords[i].set('DAY28_Q'			, record.get('DAY28_Q'));
				newDetailRecords[i].set('DAY29_Q'			, record.get('DAY29_Q'));
				newDetailRecords[i].set('DAY30_Q'			, record.get('DAY30_Q'));
				newDetailRecords[i].set('DAY31_Q'			, record.get('DAY31_Q'));
			});
			activeStore.loadData(newDetailRecords, true);

			return flag;
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
					//	record.set("ORDER_NUM", newValue);
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
