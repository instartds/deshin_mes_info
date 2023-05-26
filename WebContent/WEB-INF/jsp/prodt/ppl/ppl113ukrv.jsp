<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="ppl113ukrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="ppl113ukrv"/> 					<!-- 사업장 -->
	<t:ExtComboStore comboType="WU" />											<!-- 작업장  -->
	<t:ExtComboStore comboType="AU" comboCode="P402" /> 						<!-- 참조유형 -->
	<t:ExtComboStore comboType="AU" comboCode="B074" /> 						<!-- 양산구분 -->
	<t:ExtComboStore comboType="AU" comboCode="S002" /> 						<!-- 매출구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B020" /> 						<!-- 품목계정 -->
	<t:ExtComboStore items="${COMBO_WS_LIST}" storeId="wsList" />				<!-- 작업장 -->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />	<!-- 대분류 -->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />	<!-- 중분류 -->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />	<!-- 소분류 -->
</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
	.x-change-cell3 {
		background-color: #fcfac5;
	}
	.x-change-cell_textR {
		color: Red;
	}
</style>
<script type="text/javascript" charset="UTF-8" src='<c:url value="/resources/plupload/plupload.full.js" />'></script>
<script type="text/javascript" >

var searchOrderWindow;
var referOrderInformationWindow;	//수주정보참조
var referSalesPlanWindow;			//판매계획참조
var referItemInformationWindow;		//제품정보팝업
var photoWin;						//이미지 보여줄 윈도우
var uploadWin;						//인증서 업로드 윈도우
var fid = '';						//인증서 ID
var gsNeedPhotoSave = false;
var detailWin;
var BsaCodeInfo = {
	gsManageTimeYN:'${gsManageTimeYN}',
	gsIfCode			: '${gsIfCode}',            //작업지시데이터 연동여부
	gsIfSiteCode		: '${gsIfSiteCode}'         //작업지시데이터 연동주소
};
var outDivCode = UserInfo.divCode;
var activationTab = 'tab1';
var gsWeekNum = '';					//20200716 추가: 불필요하게 쿼리하는 로직 삭제하기 위해 전역변수 추가

function appMain() {
	var mrpYnStore = Unilite.createStore('ppl113ukrvMRPYnStore', {
		fields	: ['text', 'value'],
		data	: [
			{'text':'<t:message code="system.label.product.yes" default="예"/>'	, 'value':'Y'},
			{'text':'<t:message code="system.label.product.no" default="아니오"/>'	, 'value':'N'}
			//ColIndex("MRP_YN"))  = sMBC02  |#Y;예|#N;아니오
			//공통코드 처리필요 MRP연계
		]
	});

	var isAutoTime = false;
	if(BsaCodeInfo.gsAutoType=='Y') {
		isAutoTime = true;
	}

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'ppl113ukrvService.selectDetailList',
			update	: 'ppl113ukrvService.updateDetail',
			create	: 'ppl113ukrvService.insertDetail',
			destroy	: 'ppl113ukrvService.deleteDetail',
			syncAll	: 'ppl113ukrvService.saveAll'
		}
	});

	/* 수주정보 참조 */
	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'ppl113ukrvService.selectEstiList',
			update	: 'ppl113ukrvService.updateEstiDetail',
			create	: 'ppl113ukrvService.insertEstiDetail',
			destroy	: 'ppl113ukrvService.deleteEstiDetail',
			syncAll	: 'ppl113ukrvService.saveRefAll'
		}
	});

	var subProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'ppl113ukrvService.selectSublList'
		}
	});

	/* 생산계획 참조*/
	var directProxy3 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'ppl113ukrvService.selectRefList',
			update	: 'ppl113ukrvService.updateRefDetail',
			create	: 'ppl113ukrvService.insertRefDetail',
			destroy	: 'ppl113ukrvService.deleteRefDetail',
			syncAll	: 'ppl113ukrvService.saveRefAll'
		}
	});

	//품목 정보 관련 파일 업로드
	var itemInfoProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'ppl113ukrvService.getItemInfo',
			update	: 'ppl113ukrvService.itemInfoUpdate',
			create	: 'ppl113ukrvService.itemInfoInsert',
			destroy	: 'ppl113ukrvService.itemInfoDelete',
			syncAll	: 'ppl113ukrvService.saveAll2'
		}
	});


	Unilite.defineModel('ppl113ukrvDetailModel', {
		fields: [
			{name: 'COMP_CODE'		, text: 'COMP_CODE'		, type: 'string'},
			{name: 'DIV_CODE'		, text: '<t:message code="system.label.product.division" default="사업장"/>'				, type: 'string'},
			{name: 'ITEM_LEVEL1'	, text: '<t:message code="system.label.product.majorgroup" default="대분류"/>'				, type: 'string'},
//			{name: 'ORDER_TYPE'		, text: '<t:message code="system.label.product.classfication" default="구분"/>'			, type: 'string'},
			{name: 'PLAN_TYPE'		, text: '<t:message code="system.label.product.classfication" default="구분"/>'			, type: 'string',comboType:'AU', comboCode:'P402'},
			{name: 'ORDER_NUM'		, text: '<t:message code="system.label.product.sono" default="수주번호"/>'					, type: 'string'},
			{name: 'SEQ'			, text: '<t:message code="system.label.product.seq" default="순번"/>'						, type: 'int'},
			{name: 'ITEM_CODE'		, text: '<t:message code="system.label.product.item" default="품목"/>'					, type: 'string'},
			{name: 'ITEM_NAME'		, text: '<t:message code="system.label.product.itemname" default="품목명"/>'				, type: 'string'},
			{name: 'SPEC'			, text: '<t:message code="system.label.product.spec" default="규격"/>'					, type: 'string'},
			{name: 'STOCK_UNIT'		, text: '<t:message code="system.label.product.unit" default="단위"/>'					, type: 'string'},
			{name: 'CUSTOM_NAME'	, text: '거래처'			, type: 'string'},
			{name: 'ITEM_ACCOUNT'	, text: '품목계정'			, type: 'string',comboType:'AU', comboCode:'B020'},//추가
			{name: 'WK_PLAN_NUM'	, text: '<t:message code="system.label.product.productionplanno" default="생산계획번호"/>'	, type: 'string'},
			{name: 'WKORD_YN'		, text: '작지'			, type: 'string'},
			{name: 'WKORD_STATUS'	, text: '생산'			, type: 'string'},
			{name: 'ORDER_YN'		, text: '발주'			, type: 'string'},
			{name: 'CONFIRM_YN'		, text: '확정'			, type: 'boolean'},
			{name: 'WORK_SHOP_CODE'	, text: '<t:message code="system.label.product.workcenter" default="작업장"/>'				, type: 'string'	, comboType: 'WU'},
			{name: 'PRODT_PLAN_DATE', text: '<t:message code="system.label.product.plandate" default="계획일"/>'				, type: 'uniDate'},
			{name: 'WEEK_NUM'		, text: '계획주차'			, type: 'string'},//추가
			{name: 'WK_PLAN_Q'		, text: '<t:message code="system.label.product.planqty" default="계획량"/>'				, type: 'uniQty'},
			{name: 'PS_OX'			, text: '자재가능여부'		, type: 'string'},
			{name: 'ORDER_UNIT_Q'	, text: '<t:message code="system.label.product.soqty" default="수주량"/>'					, type: 'uniQty'},
			{name: 'INIT_DVRY_DATE'	, text: '납품요청일'			, type: 'uniDate'},//추가
			{name: 'DVRY_DATE'		, text: '납품변경일'			, type: 'uniDate'},//추가
			{name: 'SOF_WEEK_NUM'	, text: '납기주차'			, type: 'string'},//추가
			{name: 'ORDER_DATE'		, text: '<t:message code="system.label.product.sodate" default="수주일"/>'					, type: 'uniDate'},
			{name: 'MRP_CONTROL_NUM', text: 'MRP번호'			, type: 'string'},//추가
			{name: 'WKORD_NUM'		, text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>'			, type: 'string'},
			{name: 'WKORD_Q'		, text: '<t:message code="system.label.product.workorderqty" default="작업지시량"/>'			, type: 'uniQty'},
			{name: 'PRODT_Q'		, text: '<t:message code="system.label.product.productionqty" default="생산량"/>'			, type: 'uniQty'},
			{name: 'UPDATE_DB_USER'	, text: 'UPDATE_DB_USER', type: 'string'},
			{name: 'UPDATE_DB_TIME'	, text: 'UPDATE_DB_TIME', type: 'string'},
			{name: 'CAPA_OVER_FLAG'	, text: 'CAPA_OVER_FLAG', type: 'string'},
			{name: 'DOC_YN'			, text: 'DOC_YN'		, type: 'string'},
			{name: 'LAST_YN'		, text: 'LAST_YN'		, type: 'string'}
//			{name: 'PROG_WORK_CODE'	, text: 'PROG_WORK_CODE', type: 'string'}
		]
	});

	Unilite.defineModel('subModel', {
		fields: [
			{name: 'SEQ'			, text: '순번'		, type: 'int'},
			{name: 'ITEM_ACCOUNT'	, text: '품목계정'		, type: 'string',comboType:'AU', comboCode:'B020'},
			{name: 'CHILD_ITEM_CODE', text: '품목'		, type: 'string'},
			{name: 'ITEM_NAME'		, text: '품명'		, type: 'string'},
			{name: 'SPEC'			, text: '규격'		, type: 'string'},
			{name: 'STOCK_UNIT'		, text: '단위'		, type: 'string'},
			{name: 'UNIT_Q'			, text: '원단위수량'		, type: 'uniQty'},
			{name: 'SET_QTY'		, text: '실사용율'		, type: 'uniER'},
			{name: 'NEED_Q'			, text: '소요량'		, type: 'uniQty'},
			{name: 'REAL_NEED_Q'	, text: '실소요량'		, type: 'uniQty'},
			{name: 'WAITING_Q'		, text: '입고대기수량'	, type: 'uniQty'},
			{name: 'STOCK_Q'		, text: '현재고'		, type: 'uniQty'},
			{name: 'LACK_Q'			, text: '부족량'		, type: 'uniQty'}
		]
	});


	//마스터 스토어 정의
	var detailStore = Unilite.createStore('ppl113ukrvDetailStore', {
		model	: 'ppl113ukrvDetailModel',
		proxy	: directProxy,
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결
			editable	: true,		// 수정 모드 사용
			deletable	: true,		// 삭제 가능 여부
			useNavi		: false,	// prev | next 버튼 사용
			allDeletable: true
		},
		loadStoreRecords: function() {
			var param= panelSearch.getValues();
			console.log(param);
			this.load({
				params : param
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
/*			var orderNum = panelSearch.getValue('ORDER_NUM');
			Ext.each(list, function(record, index) {
				if(record.data['ORDER_NUM'] != orderNum) {
					record.set('ORDER_NUM', orderNum);
				}
			})*/
//			console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));		//20200716 주석: 불필요로직 수적

			//1. 마스터 정보 파라미터 구성
			var paramMaster= panelSearch.getValues();	//syncAll 수정

			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						panelSearch.getForm().wasDirty = false;
						panelSearch.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);
						if (detailStore.count() == 0) {
							UniAppManager.app.onResetButtonDown();
						}else{
							detailStore.loadStoreRecords();
						}
					}
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('ppl113ukrvGrid');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		groupField:'ITEM_ACCOUNT'
	});

	//20200716 추가: 초기화 후 행 추가 시, 여러 개의 행이 추가되는 현상 수정을 위해 store 구분
	var detailStore2 = Unilite.createStore('ppl113ukrvDetailStore2', {
		model	: 'ppl113ukrvDetailModel',
		proxy	: directProxy,
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결
			editable	: true,		// 수정 모드 사용
			deletable	: true,		// 삭제 가능 여부
			useNavi		: false,	// prev | next 버튼 사용
			allDeletable: true
		},
		loadStoreRecords: function() {
			var param= panelSearch.getValues();
			console.log(param);
			this.load({
				params : param
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

			//1. 마스터 정보 파라미터 구성
			var paramMaster= panelSearch.getValues();	//syncAll 수정

			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						panelSearch.getForm().wasDirty = false;
						panelSearch.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);
						if (detailStore2.count() == 0) {
							UniAppManager.app.onResetButtonDown();
						}else{
							detailStore2.loadStoreRecords();
						}
					}
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('ppl113ukrvGrid2');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		groupField:'ITEM_ACCOUNT'
	});

	var subStore = Unilite.createStore('subStore', {
		model	: 'subModel',
		proxy	: subProxy,
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		loadStoreRecords: function(record) {
			var param= record.data;
			param.PROD_ITEM_CODE = param.ITEM_CODE;
			this.load({
				params : param
			});
		}
	});


	var panelSearch = Unilite.createSearchForm('panelSearch',{
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		region	: 'north',
		layout	: {type : 'uniTable', columns : 7},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel	: '<t:message code="system.label.product.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('WORK_SHOP_CODE','');
				}
			}
		},{
			xtype	: 'container',
			layout	: {type:'hbox', align:'stretch'},
			width	: 530,
			colspan	: 2,
			items	: [{
				fieldLabel	: '계획주차',
				name		: 'DVRY_DATE_FR',
				xtype		: 'uniDatefield',
				allowBlank	: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
					},
					blur : function (field, event, eOpts) {
						if(Ext.isEmpty(field.value)){
							panelSearch.setValue('WEEK_NUM_FR','');
						}else{
							var param = {
								'OPTION_DATE'	: UniDate.getDbDateStr(field.value),
								'CAL_TYPE'		: '3' //주단위
							}
							prodtCommonService.getCalNo(param, function(provider, response) {
								if(!Ext.isEmpty(provider.CAL_NO)){
									panelSearch.setValue('WEEK_NUM_FR',provider.CAL_NO);
								}else{
									panelSearch.setValue('WEEK_NUM_FR','');
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
				name		: 'DVRY_DATE_TO',
				xtype		: 'uniDatefield',
				allowBlank	: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
					},
					blur : function (field, event, eOpts) {
						if(Ext.isEmpty(field.value)){
							panelSearch.setValue('WEEK_NUM_TO','');
						}else{
							var param = {
								'OPTION_DATE' : UniDate.getDbDateStr(field.value),
								'CAL_TYPE' : '3' //주단위
							}
							prodtCommonService.getCalNo(param, function(provider, response) {
								if(!Ext.isEmpty(provider.CAL_NO)){
									panelSearch.setValue('WEEK_NUM_TO',provider.CAL_NO);
								}else{
									panelSearch.setValue('WEEK_NUM_TO','');
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
			xtype		: 'container',
			defaultType	: 'uniTextfield',
			layout		: {type:'hbox', align:'stretch'},
			colspan	: 3,
			hidden		: false,
			items		: [{
				fieldLabel	: '<t:message code="system.label.product.sono" default="수주번호"/>',
				name		: 'ORDER_NUM',
				width		: 200
			},{
				fieldLabel	: '',
				xtype		: 'uniNumberfield',
				name		: 'ORDER_SEQ',
				hideLabel	: true,
				width		: 45
			}]
		},{
			xtype: 'radiogroup',
			fieldLabel: '작업지시여부',
			labelWidth: 100,
			id: 'rdoSelect',
			margin: '0 0 0 -230',
			items: [{
				boxLabel: '전체',
				width: 70,
				inputValue: 'ALL',
				name: 'WKORD_YN',
				checked: true
			},{
				boxLabel : '대기',
				width: 70,
				inputValue: 'N',
				name: 'WKORD_YN'
			},{
				boxLabel : '확정',
				width: 70,
				inputValue: 'Y',
				name: 'WKORD_YN'
			}]
		},{
			fieldLabel	: '<t:message code="system.label.product.itemaccount" default="품목계정"/>',
			name		: 'ITEM_ACCOUNT',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B020'
		},{
			fieldLabel	: '<t:message code="system.label.product.majorgroup" default="대분류"/>',
			name		: 'ITEM_LEVEL1',
			xtype		: 'uniCombobox',
			store		: Ext.data.StoreManager.lookup('itemLeve1Store')
		},{
			fieldLabel	: '판매유형',
			name		: 'ORDER_TYPE',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'S002'
		},{
			fieldLabel	: '<t:message code="system.label.product.workcenter" default="작업장"/>',
			name		: 'WORK_SHOP_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'WU',
			listeners	: {
				beforequery:function( queryPlan, eOpts ) {
					var store = queryPlan.combo.store;
					store.clearFilter();
					if(!Ext.isEmpty(panelSearch.getValue('DIV_CODE'))){
						store.filterBy(function(record){
							return record.get('option') == panelSearch.getValue('DIV_CODE');
						});
					}else{
						store.filterBy(function(record){
							return false;
						});
					}
				}
			}
		},{
			xtype	: 'container',
			layout	: {type : 'table', columns : 1},
			tdAttrs	: {align: 'right'},
			width	: 150,
			items	: [{
				text	: '생산계획분할',
				xtype	: 'button',
				handler	: function() {
					var selectedRec = null;
					if(activationTab == 'tab1'){
						selectedRec = detailGrid.getSelectedRecord();
						if(Ext.isEmpty(selectedRec)){
							Unilite.messageBox('선택된 데이터가 없습니다.');
							return false;
						}else{
							var r = {
								'COMP_CODE'			: selectedRec.get('COMP_CODE'		),
								'DIV_CODE'			: selectedRec.get('DIV_CODE'		),
								'ITEM_LEVEL1'		: selectedRec.get('ITEM_LEVEL1'	),
								'ORDER_TYPE'		: selectedRec.get('ORDER_TYPE'	),
								'PLAN_TYPE'			: selectedRec.get('PLAN_TYPE'		),
								'ORDER_NUM'			: selectedRec.get('ORDER_NUM'		),
								'SEQ'				: selectedRec.get('SEQ'			),
								'ITEM_CODE'			: selectedRec.get('ITEM_CODE'		),
								'ITEM_NAME'			: selectedRec.get('ITEM_NAME'		),
								'SPEC'				: selectedRec.get('SPEC'			),
								'STOCK_UNIT'		: selectedRec.get('STOCK_UNIT'	),
								'CUSTOM_NAME'		: selectedRec.get('CUSTOM_NAME'	),
								'ITEM_ACCOUNT'		: selectedRec.get('ITEM_ACCOUNT'	),
//								'WK_PLAN_NUM'		: selectedRec.get('WK_PLAN_NUM'	),
								'WKORD_YN'			: selectedRec.get('WKORD_YN'		),
								'WKORD_STATUS'		: selectedRec.get('WKORD_STATUS'	),
								'ORDER_YN'			: selectedRec.get('ORDER_YN'		),
								'CONFIRM_YN'		: selectedRec.get('CONFIRM_YN'	),
								'WORK_SHOP_CODE'	: selectedRec.get('WORK_SHOP_CODE'),
								'PRODT_PLAN_DATE'	: selectedRec.get('PRODT_PLAN_DATE'),
								'WEEK_NUM'			: selectedRec.get('WEEK_NUM'		),
//								'WK_PLAN_Q'			: selectedRec.get('WK_PLAN_Q'		),
								'PS_OX'				: selectedRec.get('PS_OX'		),
								'ORDER_UNIT_Q'		: selectedRec.get('ORDER_UNIT_Q'  ),
								'INIT_DVRY_DATE'	: selectedRec.get('INIT_DVRY_DATE'),
								'DVRY_DATE'			: selectedRec.get('DVRY_DATE'		),
								'SOF_WEEK_NUM'		: selectedRec.get('SOF_WEEK_NUM'	),
								'ORDER_DATE'		: selectedRec.get('ORDER_DATE'	),
								'MRP_CONTROL_NUM'	: selectedRec.get('MRP_CONTROL_NUM'),
								'WKORD_NUM'			: selectedRec.get('WKORD_NUM'		),
								'WKORD_Q'			: selectedRec.get('WKORD_Q'		),
								'PRODT_Q'			: selectedRec.get('PRODT_Q'		),
								'UPDATE_DB_USER'	: selectedRec.get('UPDATE_DB_USER'),
								'UPDATE_DB_TIME'	: selectedRec.get('UPDATE_DB_TIME'),
								'CAPA_OVER_FLAG'	: selectedRec.get('CAPA_OVER_FLAG'),
								'DOC_YN'			: selectedRec.get('DOC_YN'		)
							}
							detailGrid.createRow(r, '');
						}
					}else{
						selectedRec = detailGrid2.getSelectedRecord();
						if(Ext.isEmpty(selectedRec)){
							Unilite.messageBox('선택된 데이터가 없습니다.');
							return false;
						}else{
							var r = {
								'COMP_CODE'			: selectedRec.get('COMP_CODE'		),
								'DIV_CODE'			: selectedRec.get('DIV_CODE'		),
								'ITEM_LEVEL1'		: selectedRec.get('ITEM_LEVEL1'	),
								'ORDER_TYPE'		: selectedRec.get('ORDER_TYPE'	),
								'PLAN_TYPE'			: selectedRec.get('PLAN_TYPE'		),
								'ORDER_NUM'			: selectedRec.get('ORDER_NUM'		),
								'SEQ'				: selectedRec.get('SEQ'			),
								'ITEM_CODE'			: selectedRec.get('ITEM_CODE'		),
								'ITEM_NAME'			: selectedRec.get('ITEM_NAME'		),
								'SPEC'				: selectedRec.get('SPEC'			),
								'STOCK_UNIT'		: selectedRec.get('STOCK_UNIT'	),
								'CUSTOM_NAME'		: selectedRec.get('CUSTOM_NAME'	),
								'ITEM_ACCOUNT'		: selectedRec.get('ITEM_ACCOUNT'	),
//								'WK_PLAN_NUM'		: selectedRec.get('WK_PLAN_NUM'	),
								'WKORD_YN'			: selectedRec.get('WKORD_YN'		),
								'WKORD_STATUS'		: selectedRec.get('WKORD_STATUS'	),
								'ORDER_YN'			: selectedRec.get('ORDER_YN'		),
								'CONFIRM_YN'		: selectedRec.get('CONFIRM_YN'	),
								'WORK_SHOP_CODE'	: selectedRec.get('WORK_SHOP_CODE'),
								'PRODT_PLAN_DATE'	: selectedRec.get('PRODT_PLAN_DATE'),
								'WEEK_NUM'			: selectedRec.get('WEEK_NUM'		),
//								'WK_PLAN_Q'			: selectedRec.get('WK_PLAN_Q'		),
								'PS_OX'				: selectedRec.get('PS_OX'		),
								'ORDER_UNIT_Q'		: selectedRec.get('ORDER_UNIT_Q'  ),
								'INIT_DVRY_DATE'	: selectedRec.get('INIT_DVRY_DATE'),
								'DVRY_DATE'			: selectedRec.get('DVRY_DATE'		),
								'SOF_WEEK_NUM'		: selectedRec.get('SOF_WEEK_NUM'	),
								'ORDER_DATE'		: selectedRec.get('ORDER_DATE'	),
								'MRP_CONTROL_NUM'	: selectedRec.get('MRP_CONTROL_NUM'),
								'WKORD_NUM'			: selectedRec.get('WKORD_NUM'		),
								'WKORD_Q'			: selectedRec.get('WKORD_Q'		),
								'PRODT_Q'			: selectedRec.get('PRODT_Q'		),
								'UPDATE_DB_USER'	: selectedRec.get('UPDATE_DB_USER'),
								'UPDATE_DB_TIME'	: selectedRec.get('UPDATE_DB_TIME'),
								'CAPA_OVER_FLAG'	: selectedRec.get('CAPA_OVER_FLAG'),
								'DOC_YN'			: selectedRec.get('DOC_YN'		)
							}
							detailGrid2.createRow(r, '');
						}
					}
				}
			}]
		},{
			xtype	: 'container',
			layout	: {type : 'table', columns : 1},
			tdAttrs	: {align: 'right'},
			width	: 150,
//			hidden	: true,
			items	: [{
				text	: '일괄작지등록',
				xtype	: 'button',
				itemId  : 'btnWkord',
				handler	: function() {
					if(activationTab == 'tab1'){
						selectedRecs = detailGrid.getSelectedRecords();
					}else{
						selectedRecs = detailGrid2.getSelectedRecords();
					}
					if(Ext.isEmpty(selectedRecs)){
						Unilite.messageBox('선택된 데이터가 없습니다.');
						return false;
					}else{
						var datas = []
						var cnt = 0;
						Ext.each(selectedRecs, function(rec, idx){
							if(Ext.isEmpty(rec.get('WORK_SHOP_CODE')) ||
							Ext.isEmpty(rec.get('WK_PLAN_Q')) ||
							Ext.isEmpty(rec.get('WORK_SHOP_CODE')) ||
							!Ext.isEmpty(rec.get('WKORD_NUM'))){
								Unilite.messageBox('데이터를 확인해 주십시오.');
								cnt = 1;
								return false;
							}
							datas.push(rec.data);
						})
						if(cnt == 1){
							return false;

						}
						var param = {
							'DIV_CODE' : panelSearch.getValue('DIV_CODE'),
							'WK_PLAN_NUMS' : datas
						}
//						setTimeout( function() {
						panelSearch.down('#btnWkord').setDisabled(true);

							ppl113ukrvService.savePmp100(datas, function(provider, response) {
								if(!Ext.isEmpty(provider)){
									if(provider.indexOf('Y') != -1){
											if(BsaCodeInfo.gsIfCode == 'Y'){//	작업지시데이터 MES연동사용시
												var mesIfData = provider.replace('Y','');//mes연동데이터 세팅
												mesIfData = mesIfData.split(',');
												var isErr = false;
												for(var i=0; i<mesIfData.length; i++){
													var param = {"S_COMP_CODE": UserInfo.compCode,
																 "DIV_CODE"   : panelSearch.getValue('DIV_CODE'),
																 "KEY_VALUE"  : mesIfData[i],
																 "SITE_GUBUN" : UserInfo.deptName
																};

													pmp260ukrvService.selectInterfaceInfo(param, function(provider, response) {
													var records = response.result;
														if(!Ext.isEmpty(provider)) {
																var sparam = {
																	if_seq      : provider[0]['IF_SEQ'],
																	company_no  : provider[0]['COMPANY_NO'],
																	prdctn_dt   : provider[0]['PRDCTN_DT'],
																	prdctn_product_no  : provider[0]['PRDCTN_PRODUCT_NO'],
																	prdctn_product_cd  : provider[0]['PRDCTN_PRODUCT_CD'],
																	prdctn_product_nm  : provider[0]['PRDCTN_PRODUCT_NM'],
																	plan_outtrn      : provider[0]['PLAN_OUTTRN'],
																	acmslt_outtrn   : provider[0]['ACMSLT_OUTTRN'],
																	unit_cd         : provider[0]['UNIT_CD'],
																	erp_lot_no      : provider[0]['ERP_LOT_NO'],
																	packng_qy       : provider[0]['PACKNG_QTY'],
																	member_no       : provider[0]['MEMBER_NO'],
																	ordr_i_or_d     : provider[0]['ORDR_I_OR_D'],
																	order_num     	: provider[0]['ORDER_NUM'],
																	wrkshp_ty		: provider[0]['WRKSHP_TY']
																};
																Ext.Ajax.request({
																	url	: BsaCodeInfo.gsIfSiteCode,
																	method:'POST',
																	params	: sparam,
																	cors: true,
																	useDefaultXhrHeader : false,
																	async	: false,
																	success	: function(response){
																		if(!Ext.isEmpty(response)){
																		//Unilite.messageBox('MES연동데이터  전송되었습니다.');
																		}
																	},
																	failure: function (response, options) {
																	    alert( "failed: " + response.responseText );
																		isErr = true;
																	}
																});
														}
													});

												}
												if(isErr == true){
													Unilite.messageBox('MES연동데이터  전송중 오류가 발생했습니다.');
												}else{
													Unilite.messageBox('MES연동데이터  전송되었습니다.');
												}
											}//	작업지시데이터 MES연동 end
										UniAppManager.app.onQueryButtonDown();
										panelSearch.down('#btnWkord').setDisabled(false);
										Unilite.messageBox("일괄작지 완료");
									}else{
										panelSearch.down('#btnWkord').setDisabled(false);
										Unilite.messageBox("실패");
									}
								}else{
									panelSearch.down('#btnWkord').setDisabled(false);
									Unilite.messageBox("실패");
								}
							})
//						}, 50 );
					}
				}
			}]
		},{
			fieldLabel	: '<t:message code="system.label.product.productionplanno" default="생산계획번호"/>',
			name		: 'WK_PLAN_NUM',
			xtype		: 'uniTextfield',
			hidden		: true
		},
		Unilite.popup('DIV_PUMOK',{
			fieldLabel		: '<t:message code="system.label.product.item" default="품목"/>',
			validateBlank	: false,
			valueFieldName	: 'ITEM_CODE',
			textFieldName	: 'ITEM_NAME',
			hidden			: true,
			listeners		: {
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
				}
			}
		}),{
			fieldLabel	: '<t:message code="system.label.product.temporaryfile" default="임시파일"/>',
			name		: 'COM',
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
						var labelText = invalid.items[0]['fieldLabel']+' : ';
					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
						var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
					}
					Unilite.messageBox(labelText+Msg.sMB083);
					invalid.items[0].focus();
				} else {
				//	this.mask();
				}
			} else {
				this.unmask();
			}
			return r;
		}
	});	//end panelSearch


	/** Master Grid1 정의(Grid Panel)
	 * @type
	 */
	var detailGrid = Unilite.createGrid('ppl113ukrvGrid', {
		store	: detailStore,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			expandLastColumn	: true,
			useRowNumberer		: false,
			onLoadSelectFirst	: false
		},
		tbar	: [{
			itemId	: 'requestBtn',
			text	: '<div style="color: blue"><t:message code="system.label.product.soinforeference" default="수주정보참조"/></div>',
			handler	: function() {
				openOrderInformationWindow();
			}
		},'-', {
			itemId	: 'refBtn',
			text	: '<div style="color: blue"><t:message code="system.label.product.salesplanreference" default="판매계획참조"/></div>',
			hidden	: true,
			handler	: function() {
				openSalesPlanWindow();
			}
		}],
		features: [ {id : 'detailGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
					{id : 'detailGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false}],
		selModel: Ext.create("Ext.selection.CheckboxModel", {
			singleSelect: true ,
			checkOnly	: false,
			listeners	: {
				select: function(grid, selectRecord, index, rowIndex, eOpts ){
//					if(!Ext.isEmpty(selectRecord.get('WKORD_NUM'))){
//						alert('이미 등록된 작업지시 입니다.');
//						return false;
//					}
				},
				deselect:  function(grid, selectRecord, index, eOpts ){
				}
			}
		}),
		columns	: [
			{ dataIndex: 'COMP_CODE'			, width: 20 , hidden: true},
			{ dataIndex: 'DIV_CODE'				, width: 20 , hidden: true},
//			{ dataIndex: 'ORDER_TYPE'			, width: 80 },
			{ dataIndex: 'PLAN_TYPE'			, width: 80 },
			{ dataIndex: 'ITEM_LEVEL1'			, width: 80 },
			{ dataIndex: 'ORDER_NUM'			, width: 120},
			{ dataIndex: 'SEQ'					, width: 66	, align:'center',
				renderer: function (val, meta, record) {
					if (Ext.isEmpty(val) || val == 0) {
						return '';
					} else {
						return val;
					}
				}
			},
			{ dataIndex: 'ITEM_CODE'			, width: 100,
				editor: Unilite.popup('DIV_PUMOK_G', {
					textFieldName: 'ITEM_CODE',
					DBtextFieldName: 'ITEM_CODE',
					extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode, POPUP_TYPE: 'GRID_CODE'},
					autoPopup: true,
					listeners: {'onSelected': {
						fn: function(records, type) {
							console.log('records : ', records);
							Ext.each(records, function(record,i) {
								console.log('record',record);
								if(i==0) {
									detailGrid.setItemData(record,false);
								} else {
									UniAppManager.app.onNewDataButtonDown();
									detailGrid.setItemData(record,false);
								}
							});
						},
						scope: this
						},
						'onClear': function(type) {
							detailGrid.setItemData(null,true);
						}
					}
				})
			},
			{ dataIndex: 'ITEM_NAME'			, width: 250,
				editor: Unilite.popup('DIV_PUMOK_G', {
					extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode},
					autoPopup: true,
					listeners: {'onSelected': {
						fn: function(records, type) {
							console.log('records : ', records);
							Ext.each(records, function(record,i) {
								if(i==0) {
									detailGrid.setItemData(record,false);
								} else {
									UniAppManager.app.onNewDataButtonDown();
									detailGrid.setItemData(record,false);
								}
							});
						},
						scope: this
						},
						'onClear': function(type) {
							detailGrid.setItemData(null,true);
						}
					}
				})
			},
			{ dataIndex: 'SPEC'					, width: 93},
			{ dataIndex: 'STOCK_UNIT'			, width: 40, align:'center'},
			{ dataIndex: 'CUSTOM_NAME'			, width: 150},
			{ dataIndex: 'ITEM_ACCOUNT'			, width: 80},
			{ dataIndex: 'WK_PLAN_NUM'			, width: 120,isLink:true},
			{ dataIndex: 'WKORD_YN'				, width: 66, align:'center'},
			{ dataIndex: 'WKORD_STATUS'			, width: 66, align:'center'},
			{ dataIndex: 'ORDER_YN'				, width: 66, align:'center'},
			{dataIndex: 'CONFIRM_YN'			, width: 60, xtype: 'checkcolumn',align:'center'},
			{ dataIndex: 'WORK_SHOP_CODE'		, width: 100,tdCls:'x-change-cell3',
				listeners:{
					render:function(elm)
						{ elm.editor.on('beforequery',function(queryPlan, eOpts) {
							var store = queryPlan.combo.store;
							var selRecord =  detailGrid.uniOpt.currentRecord;
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
				}
			},
			{ dataIndex: 'PRODT_PLAN_DATE'		, width: 80 ,tdCls:'x-change-cell3'},
			{ dataIndex: 'WEEK_NUM'				, width: 80,tdCls:'x-change-cell3'},
			{ dataIndex: 'WK_PLAN_Q'			, width: 66 ,tdCls:'x-change-cell3'},
			{ dataIndex: 'PS_OX'				, width: 100, align:'center'},
			{ dataIndex: 'ORDER_UNIT_Q'			, width: 66},
			{ dataIndex: 'INIT_DVRY_DATE'		, width: 80},
			{ dataIndex: 'DVRY_DATE'			, width: 80},
			{ dataIndex: 'SOF_WEEK_NUM'			, width: 80},
			{ dataIndex: 'ORDER_DATE'			, width: 80},
			{ dataIndex: 'MRP_CONTROL_NUM'		, width: 120},
			{ dataIndex: 'WKORD_NUM'			, width: 120},
			{ dataIndex: 'WKORD_Q'				, width: 100},
			{ dataIndex: 'PRODT_Q'				, width: 66},
			{
				text	: '제품정보',
				width	: 150,
				xtype	: 'widgetcolumn',
				widget	: {
					xtype		: 'button',
					text		: '제품정보 확인',
					listeners	: {
						buffer	: 1,
						click	: function(button, event, eOpts) {
							var record = event.record.data;
							itemInfoStore.loadStoreRecords(record.ITEM_CODE);
							openItemInformationWindow();
						}
					}
				}
			},{
				text	: '수주정보',
				width	: 150,
				xtype	: 'widgetcolumn',
				widget	: {
					xtype		: 'button',
					text		: '수주정보 확인',
					listeners	: {
						buffer:1,
						click: function(button, event, eOpts) {
							var record = event.record.data;
							openDetailWindow(record);
						},
						afterrender: function(chb) {
							var rec = chb.getWidgetRecord();
							if(rec.get('DOC_YN') == 'Y'){
								this.setText('<div style="color: red">수주정보 확인</div>');
							}else{
								this.setText('<div style="color: black">수주정보 확인</div>');
							}
						}
					}
				}
			},
			{ dataIndex: 'UPDATE_DB_USER'		, width: 100 , hidden: true},
			{ dataIndex: 'UPDATE_DB_TIME'		, width: 100 , hidden: true},
			{ dataIndex: 'CAPA_OVER_FLAG'		, width: 100 , hidden: true},
			{ dataIndex: 'DOC_YN'				, width: 50	, hidden: true}
		],
		listeners: {
			selectionchangerecord:function(selected) {
				if(selected.phantom){
					subGrid.reset();
					subStore.clearData();
				}else{
					subStore.loadStoreRecords(selected);
				}
			},

headerclick :function( ct, column, e, t, eOpts ) {
	debugger;
console.log(column.text);
},

			beforePasteRecord: function(rowIndex, record) {
				if(!panelSearch.getInvalidMessage()) return;	//필수체크
				var seq = detailStore.max('SER_NO');
				if(!seq) seq = 1;
				else  seq += 1;
				record.SER_NO = seq;
				return true;
			},
			//contextMenu의 복사한 행 삽입 실행 후
			afterPasteRecord: function(rowIndex, record) {
				panelSearch.setAllFieldsReadOnly(true);
			},
			beforeedit : function( editor, e, eOpts ) {
				if(!e.record.phantom){
					if (UniUtils.indexOf(e.field,['WORK_SHOP_CODE','PRODT_PLAN_DATE','WEEK_NUM','WK_PLAN_Q']) ){
						return true;
					}else{
						return false;
					}
				}else{
					if (UniUtils.indexOf(e.field,['ORDER_NUM','ITEM_CODE','ITEM_NAME','WORK_SHOP_CODE','PRODT_PLAN_DATE','WEEK_NUM','WK_PLAN_Q']) ){
						return true;
					}else{
						return false;
					}
				}
			},
			onGridDblClick: function(grid, record, cellIndex, colName) {
				detailGrid.returnData(record);
				//UniAppManager.app.onQueryButtonDown();
				if(!record.phantom){
					this.returnCell(record, colName);
				}else{
					if(colName == 'ORDER_NUM') {
						openSearchOrderWindow();
					}
				}
			}
		},
		returnData: function(record){
			if(Ext.isEmpty(record)){
				record = this.getSelectedRecord();
			}
		},
		returnCell: function(record, colName){
			if(Ext.isEmpty(record.get('WORK_SHOP_CODE'))){
				Unilite.messageBox('작업장을 선택하여 주십시오');
				return false;
			}else{
				var cellValue	= record.get(colName);
				var itemCode	= record.get('ITEM_CODE');
				var itemName	= record.get('ITEM_NAME');
				var orderNum	= record.get('ORDER_NUM');
				var wkPlanNum	= record.get('WK_PLAN_NUM');
				var seq			= record.get('SEQ');

				if(wkPlanNum == cellValue){
					var params = {
						'PGM_ID' : 'ppl113ukrv'
					}
					params = Ext.merge(params , record.data);
					var rec1 = {data : {prgID : 'pmp260ukrv', 'text':''}};
					var param = {
						'DIV_CODE'		: record.get('DIV_CODE'),
						'WK_PLAN_NUM'	: record.get('WK_PLAN_NUM')
					}
					ppl113ukrvService.selectP100(param, function(provider, response) {
						if(!Ext.isEmpty(provider)){
							if(!Ext.isEmpty(provider.WKORD_NUM)){
								params.WKORD_NUM = provider.WKORD_NUM;
								parent.openTab(rec1, '/prodt/pmp260ukrv.do', params);
							}else{
								params.WKORD_NUM = '';
								parent.openTab(rec1, '/prodt/pmp260ukrv.do', params);
							}
						}else{
							params.WKORD_NUM = '';
							parent.openTab(rec1, '/prodt/pmp260ukrv.do', params);
						}
					});
				}
			}
		},
		setItemData: function(record, dataClear) {
			//20200716 수정: 정상적으로 품목정보 set 안 되는 현상 수정
//			var grdRecord = detailGrid.uniOpt.currentRecord;
			var grdRecord = detailGrid.getSelectedRecord();
			if(dataClear) {
				grdRecord.set('ITEM_CODE'		,"");
				grdRecord.set('ITEM_NAME'		,"");
				grdRecord.set('SPEC'			,"");
				grdRecord.set('ORDER_UNIT'		,"");
				grdRecord.set('STOCK_UNIT'		,"");
//				grdRecord.set('ITEM_LEVEL1'		,"");
				grdRecord.set('ITEM_ACCOUNT'	,"");
				grdRecord.set('WORK_SHOP_CODE'	,"");

			} else {
				grdRecord.set('ITEM_CODE'		, record['ITEM_CODE']);
				grdRecord.set('ITEM_NAME'		, record['ITEM_NAME']);
				grdRecord.set('SPEC'			, record['SPEC']);
				grdRecord.set('ORDER_UNIT'		, record['SALE_UNIT']);
				grdRecord.set('STOCK_UNIT'		, record['STOCK_UNIT']);
//				grdRecord.set('ITEM_LEVEL1'		,record['ITEM_LEVEL1']);
				grdRecord.set('ITEM_ACCOUNT'	,record['ITEM_ACCOUNT']);
				grdRecord.set('WORK_SHOP_CODE'	,record['WORK_SHOP_CODE']);
			}
		},
		setRefData: function(record) {
			var grdRecord = this.getSelectedRecord();
			grdRecord.set('PLAN_TYPE'		, record['PLAN_TYPE']);
			grdRecord.set('ORDER_NUM'		, record['ORDER_NUM']);
			grdRecord.set('ITEM_CODE'		, record['ITEM_CODE']);
			grdRecord.set('ITEM_NAME'		, record['ITEM_NAME']);
			grdRecord.set('SPEC'			, record['SPEC']);
			grdRecord.set('STOCK_UNIT'		, record['STOCK_UNIT']);
			grdRecord.set('DVRY_DATE'		, record['DVRY_DATE']);
			grdRecord.set('ORDER_DATE'		, record['ORDER_DATE']);
			grdRecord.set('ORDER_UNIT_Q'	, record['ORDER_Q']);
			grdRecord.set('PROD_Q'			, record['PROD_Q']);
			grdRecord.set('WORK_SHOP_CODE'	, record['WORK_SHOP_CODE']);
		}
	});

	var detailGrid2 = Unilite.createGrid('ppl113ukrvGrid2', {
		store	: detailStore2,		//20200716 추가: 초기화 후 행 추가 시, 여러 개의 행이 추가되는 현상 수정을 위해 store 구분
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			expandLastColumn: true,
			useRowNumberer	: false
		},
		tbar	: [{
			itemId	: 'requestBtn',
			text	: '<div style="color: blue"><t:message code="system.label.product.soinforeference" default="수주정보참조"/></div>',
			handler	: function() {
				openOrderInformationWindow();
			}
		},'-', {
			itemId	: 'refBtn',
			text	: '<div style="color: blue"><t:message code="system.label.product.salesplanreference" default="판매계획참조"/></div>',
			hidden	: true,
			handler	: function() {
				openSalesPlanWindow();
			}
		}],
		features: [ {id : 'detailGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
					{id : 'detailGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false}],
		selModel: Ext.create("Ext.selection.CheckboxModel", {
			singleSelect: true,
			checkOnly	: false
		}),
		columns	: [
			{ dataIndex: 'COMP_CODE'		, width: 20 , hidden: true},
			{ dataIndex: 'DIV_CODE'			, width: 20 , hidden: true},
			{ dataIndex: 'PRODT_PLAN_DATE'	, width: 80 ,tdCls:'x-change-cell3'},
			{ dataIndex: 'WEEK_NUM'			, width: 80,tdCls:'x-change-cell3'},
			{ dataIndex: 'PLAN_TYPE'		, width: 100 },
			{ dataIndex: 'ITEM_LEVEL1'		, width: 100 },
			{ dataIndex: 'ORDER_NUM'		, width: 120},
			{ dataIndex: 'SEQ'				, width: 66	, align:'center'},
			{ dataIndex: 'ITEM_CODE'		, width: 100,
				editor: Unilite.popup('DIV_PUMOK_G', {
					textFieldName	: 'ITEM_CODE',
					DBtextFieldName	: 'ITEM_CODE',
					extParam		: {SELMODEL: 'MULTI', DIV_CODE: outDivCode, POPUP_TYPE: 'GRID_CODE'},
					autoPopup		: true,
					listeners		: {
						'onSelected': {
							fn: function(records, type) {
								console.log('records : ', records);
								Ext.each(records, function(record,i) {
									console.log('record',record);
									if(i==0) {
										detailGrid2.setItemData(record,false);
									} else {
										UniAppManager.app.onNewDataButtonDown();
										detailGrid2.setItemData(record,false);
									}
								});
							},
							scope: this
						},
						'onClear': function(type) {
							detailGrid2.setItemData(null,true);
						}
					}
				})
			},
			{ dataIndex: 'ITEM_NAME'		, width: 250,
				editor: Unilite.popup('DIV_PUMOK_G', {
					extParam	: {SELMODEL: 'MULTI', DIV_CODE: outDivCode},
					autoPopup	: true,
					listeners	: {
						'onSelected': {
							fn: function(records, type) {
								console.log('records : ', records);
								Ext.each(records, function(record,i) {
									if(i==0) {
										detailGrid2.setItemData(record,false);
									} else {
										UniAppManager.app.onNewDataButtonDown();
										detailGrid2.setItemData(record,false);
									}
								});
							},
							scope: this
						},
						'onClear': function(type) {
							detailGrid2.setItemData(null,true);
						}
					}
				})
			},
			{ dataIndex: 'SPEC'				, width: 93},
			{ dataIndex: 'STOCK_UNIT'		, width: 40, align:'center'},
			{ dataIndex: 'CUSTOM_NAME'		, width: 150},
			{ dataIndex: 'ITEM_ACCOUNT'		, width: 80},
			{ dataIndex: 'WK_PLAN_NUM'		, width: 120},
			{dataIndex: 'CONFIRM_YN'		, width: 60, xtype: 'checkcolumn',align:'center'},
			{ dataIndex: 'WORK_SHOP_CODE'	, width: 100,tdCls:'x-change-cell3',
				listeners:{
					render:function(elm)
						{ elm.editor.on('beforequery',function(queryPlan, eOpts) {
							var store = queryPlan.combo.store;
							var selRecord =  detailGrid2.uniOpt.currentRecord;
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
				}
			},
			{ dataIndex: 'WK_PLAN_Q'		, width: 66 ,tdCls:'x-change-cell3'},
			{ dataIndex: 'PS_OX'			, width: 100, align:'center'},
			{ dataIndex: 'ORDER_UNIT_Q'		, width: 66},
			{ dataIndex: 'INIT_DVRY_DATE'	, width: 80},
			{ dataIndex: 'DVRY_DATE'		, width: 80},
			{ dataIndex: 'SOF_WEEK_NUM'		, width: 80},
			{ dataIndex: 'ORDER_DATE'		, width: 80},
			{ dataIndex: 'MRP_CONTROL_NUM'	, width: 120},
			{ dataIndex: 'ORDER_YN'			, width: 80},
			{ dataIndex: 'WKORD_NUM'		, width: 120},
			{ dataIndex: 'WKORD_Q'			, width: 100},
			{ dataIndex: 'PRODT_Q'			, width: 66},
			{
				text	: '제품정보',
				width	: 150,
				xtype	: 'widgetcolumn',
				widget	: {
					xtype		: 'button',
					text		: '제품정보 확인',
					listeners	: {
						buffer	: 1,
						click	: function(button, event, eOpts) {
							var record = event.record.data;
							itemInfoStore.loadStoreRecords(record.ITEM_CODE);
							openItemInformationWindow();
						}
					}
				}
			},{
				text	: '수주정보',
				width	: 150,
				xtype	: 'widgetcolumn',
				widget	: {
					xtype		: 'button',
					text		: '수주정보 확인',
					listeners	: {
						buffer	: 1,
						click	: function(button, event, eOpts) {
							var record = event.record.data;
							openDetailWindow(record);
						}
					}
				}
			},
			{ dataIndex: 'UPDATE_DB_USER'	, width: 100 , hidden: true},
			{ dataIndex: 'UPDATE_DB_TIME'	, width: 100 , hidden: true},
			{ dataIndex: 'CAPA_OVER_FLAG'	, width: 100 , hidden: true}
		],
		listeners: {
			selectionchangerecord:function(selected) {
				if(selected.phantom){
					subGrid.reset();
					subStore.clearData();
				}else{
					subStore.loadStoreRecords(selected);
				}
			},
			beforePasteRecord: function(rowIndex, record) {
				if(!panelSearch.getInvalidMessage()) return;	//필수체크
				var seq = detailStore2.max('SER_NO');
				if(!seq) seq = 1;
				else  seq += 1;
				record.SER_NO = seq;
				return true;
			},
			//contextMenu의 복사한 행 삽입 실행 후
			afterPasteRecord: function(rowIndex, record) {
				panelSearch.setAllFieldsReadOnly(true);
			},
			beforeedit : function( editor, e, eOpts ) {
				if(!e.record.phantom){
					if (UniUtils.indexOf(e.field,['WORK_SHOP_CODE','PRODT_PLAN_DATE','WEEK_NUM','WK_PLAN_Q']) ){
						return true;
					}else{
						return false;
					}
				}else{
					if (UniUtils.indexOf(e.field,['ITEM_CODE','ITEM_NAME','WORK_SHOP_CODE','PRODT_PLAN_DATE','WEEK_NUM','WK_PLAN_Q']) ){
						return true;
					}else{
						return false;
					}
				}
			},
			onGridDblClick: function(grid, record, cellIndex, colName) {
				detailGrid2.returnData(record);
				//UniAppManager.app.onQueryButtonDown();
				if(!record.phantom){
					this.returnCell(record, colName);
				}else{
					if(colName == 'ORDER_NUM') {
						openSearchOrderWindow();
					}
				}
			}
		},
		returnData: function(record){
			if(Ext.isEmpty(record)){
				record = this.getSelectedRecord();
			}
		},
		returnCell: function(record, colName){
			if(Ext.isEmpty(record.get('WORK_SHOP_CODE'))){
				Unilite.messageBox('작업장을 선택하여 주십시오');
				return false;
			}else{
				var cellValue	= record.get(colName);
				var itemCode	= record.get('ITEM_CODE');
				var itemName	= record.get('ITEM_NAME');
				var orderNum	= record.get('ORDER_NUM');
				var wkPlanNum	= record.get('WK_PLAN_NUM');
				var seq			= record.get('SEQ');

				if(wkPlanNum == cellValue){
					var params = {
						'PGM_ID' : 'ppl113ukrv'
					}
					params	= Ext.merge(params , record.data);
					var rec1= {data : {prgID : 'pmp260ukrv', 'text':''}};
					var param = {
						'DIV_CODE'		: record.get('DIV_CODE'),
						'WK_PLAN_NUM'	: record.get('WK_PLAN_NUM')
					}
					ppl113ukrvService.selectP100(param, function(provider, response) {
						if(!Ext.isEmpty(provider)){
							if(!Ext.isEmpty(provider.WKORD_NUM)){
								params.WKORD_NUM = provider.WKORD_NUM;
								parent.openTab(rec1, '/prodt/pmp260ukrv.do', params);
							}else{
								params.WKORD_NUM = '';
								parent.openTab(rec1, '/prodt/pmp260ukrv.do', params);
							}
						}else{
							params.WKORD_NUM = '';
							parent.openTab(rec1, '/prodt/pmp260ukrv.do', params);
						}
					});
				}
			}
		},
		/*disabledLinkButtons: function(b) {
			this.down('#procTool').menu.down('#reqIssueLinkBtn').setDisabled(b);
		},*/
		setItemData: function(record, dataClear) {
			//20200716 수정: 정상적으로 품목정보 set 안 되는 현상 수정
//			var grdRecord = detailGrid2.uniOpt.currentRecord;
			var grdRecord = detailGrid2.getSelectedRecord();
			if(dataClear) {
				grdRecord.set('ITEM_CODE'		, "");
				grdRecord.set('ITEM_NAME'		, "");
				grdRecord.set('SPEC'			, "");
				grdRecord.set('ORDER_UNIT'		, "");
				grdRecord.set('STOCK_UNIT'		, "");
				grdRecord.set('ITEM_LEVEL1'		, "");
				grdRecord.set('ITEM_ACCOUNT'	, "");
				grdRecord.set('WORK_SHOP_CODE'	, "");
			} else {
				grdRecord.set('ITEM_CODE'		, record['ITEM_CODE']);
				grdRecord.set('ITEM_NAME'		, record['ITEM_NAME']);
				grdRecord.set('SPEC'			, record['SPEC']);
				grdRecord.set('ORDER_UNIT'		, record['SALE_UNIT']);
				grdRecord.set('STOCK_UNIT'		, record['STOCK_UNIT']);
				grdRecord.set('ITEM_LEVEL1'		, record['ITEM_LEVEL1']);
				grdRecord.set('ITEM_ACCOUNT'	, record['ITEM_ACCOUNT']);
				grdRecord.set('WORK_SHOP_CODE'	, record['WORK_SHOP_CODE']);
			}
		},
		setRefData: function(record) {
			var grdRecord = this.getSelectedRecord();
			grdRecord.set('PLAN_TYPE'			, record['PLAN_TYPE']);
			grdRecord.set('ORDER_NUM'			, record['ORDER_NUM']);
			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
			grdRecord.set('SPEC'				, record['SPEC']);
			grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);
			grdRecord.set('DVRY_DATE'			, record['DVRY_DATE']);
			grdRecord.set('ORDER_DATE'			, record['ORDER_DATE']);
			grdRecord.set('ORDER_UNIT_Q'		, record['ORDER_Q']);
			grdRecord.set('PROD_Q'				, record['PROD_Q']);
			grdRecord.set('WORK_SHOP_CODE'		, record['WORK_SHOP_CODE']);
		}
	});

	var subGrid = Unilite.createGrid('subGrid', {
		store	: subStore,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			expandLastColumn: false,
			useRowNumberer	: false
		},
		selModel: 'rowmodel',
	/*	viewConfig:{
			getRowClass : function(record,rowIndex,rowParams,store){
				var cls = '';
				if(!Ext.isEmpty(record.get('LACK_Q'))){		//부족량이 있을시
					cls = 'x-change-cellR';
				}
				return cls;
			}
		},*/
		columns	: [
			{ dataIndex: 'SEQ'				, width: 60,align:'center' },
			{ dataIndex: 'ITEM_ACCOUNT'		, width: 100  },
			{ dataIndex: 'CHILD_ITEM_CODE'	, width: 100 },
			{ dataIndex: 'ITEM_NAME'		, width: 200 },
			{ dataIndex: 'SPEC'				, width: 120 },
			{ dataIndex: 'STOCK_UNIT'		, width: 40 , align:'center'},
			{ dataIndex: 'UNIT_Q'			, width: 100 },
			{ dataIndex: 'SET_QTY'			, width: 80 },
			{ dataIndex: 'NEED_Q'			, width: 100 },
			{ dataIndex: 'REAL_NEED_Q'		, width: 100 },
			{ dataIndex: 'WAITING_Q'		, width: 100 },
			{ dataIndex: 'STOCK_Q'			, width: 100 },
			{ dataIndex: 'LACK_Q'			, width: 100,
				renderer : function(val,metaData,record,rowIndex,colIndex,store,view) {
					if(val > 0){
						metaData.tdCls = 'x-change-cell_textR';
					}
					return Ext.util.Format.number(val, '0,000');
				}
			}
		]
	});


	//품목 정보 관련 파일업로드
	Unilite.defineModel('itemInfoModel', {
		fields: [
			{name: 'COMP_CODE'		,text: '<t:message code="system.label.base.companycode" default="법인코드"/>'				,type: 'string'},
			{name: 'ITEM_CODE'		,text: '<t:message code="system.label.base.itemcode" default="품목코드"/>'					,type: 'string'},
			//공통코드 생성 (B702 - 01:제품사진, 02:도면, 03:승인원)
			{name: 'FILE_TYPE'		,text: '<t:message code="system.label.base.classfication" default="구분"/>'				,type: 'string'	 , allowBlank: false	 , comboType: 'AU'	, comboCode: 'B702'},
			{name: 'MANAGE_NO'		,text: '<t:message code="system.label.base.manageno" default="관리번호"/>'					,type: 'string'	 , allowBlank: false},
			{name: 'REMARK'			,text: '<t:message code="system.label.base.remarks" default="비고"/>'						,type: 'string'},
			{name: 'CERT_FILE'		,text: '<t:message code="system.label.base.filename" default="파일명"/>'					,type: 'string'},
			{name: 'FILE_ID'		,text: '<t:message code="system.label.base.savedfilename" default="저장된 파일명"/>'			,type: 'string'},
			{name: 'FILE_PATH'		,text: '<t:message code="system.label.base.savedfilepath" default="저장된 파일경로"/>'			,type: 'string'},
			{name: 'FILE_EXT'		,text: '<t:message code="system.label.base.savedfileextension" default="저장된 파일확장자"/>'	,type: 'string'}
		]
	});
	var itemInfoStore = Unilite.createStore('itemInfoStore',{
		model	: 'itemInfoModel',
		proxy	: itemInfoProxy,
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,	// 상위 버튼 연결
			editable	: true,		// 수정 모드 사용
			deletable	: true,		// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		loadStoreRecords : function(itemCOde){
			var param= Ext.getCmp('panelSearch').getValues();
			param.ITEM_CODE = itemCOde
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore : function(config) {
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			if(inValidRecs.length == 0 )	 {
				config = {
					success : function(batch, option) {
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
		}
	});
	var itemInfoGrid = Unilite.createGrid('itemInfoGrid', {
		store	: itemInfoStore,
		border	: true,
		height	: 180,
		width	: 865,
		padding	: '0 0 5 0',
		sortableColumns : false,
		excelTitle: '<t:message code="system.label.base.referfile" default="관련파일"/>',
		uniOpt	: {
			onLoadSelectFirst	: false,
			expandLastColumn	: false,
			useRowNumberer		: true,
			useMultipleSorting	: false
//			enterKeyCreateRow	: true		//마스터 그리드 추가기능 삭제
		},
		columns:[
			{ dataIndex : 'COMP_CODE'		, width: 80	,hidden:true},
			{ dataIndex : 'ITEM_CODE'		, width: 80	,hidden:true},
			{ dataIndex : 'FILE_TYPE'		, width: 100},
			{ dataIndex : 'MANAGE_NO'		, width: 150},
			{ text	: '<t:message code="system.label.base.photo" default="사진"/>',
				columns:[
					{ dataIndex : 'CERT_FILE'	, width: 230		, align: 'center'	,
						renderer: function (val, meta, record) {
							if (!Ext.isEmpty(record.data.CERT_FILE)) {
								return '<font color = "blue" >' + val + '</font>';

							} else {
								return '';
							}
						}
					}
				]
			},
			{ dataIndex : 'REMARK'			, flex: 1	, minWidth: 30}/*,
			{
			text	: '등록 버튼으로 구현 한 것',
			align : 'center',
			width : 50,
			renderer  : function(value, meta, record) {
					var id = Ext.id();
					Ext.defer(function(){
						new Ext.Button({
							text	: '등록',
							margin  : '-2 0 2 0',
							handler : function(btn, e) {
								itemInfoGrid.getSelectionModel().select(record);
								openUploadWindow();
							}
						}).render(document.body, id);
					},50);
					return Ext.String.format('<div id="{0}"></div>', id);
				}
			}*/
		],
		listeners: {
			beforeedit: function( editor, e, eOpts ) {
				if(!e.record.phantom) {
					if (UniUtils.indexOf(e.field, ['FILE_TYPE', 'MANAGE_NO', 'CERT_FILE'])){
						return false;
					}
				} else {
					if (UniUtils.indexOf(e.field, ['CERT_FILE'])){
						return false;
					}
				}
			},
			select: function(grid, selectRecord, index, rowIndex, eOpts ){
			},
			cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
				if(cellIndex == 5 && !Ext.isEmpty(record.get('CERT_FILE'))) {
					fid					= record.data.FILE_ID
					var fileExtension	= record.get('CERT_FILE').lastIndexOf( "." );
					var fileExt			= record.get('CERT_FILE').substring( fileExtension + 1 );
					if(fileExt == 'pdf') {
						var win = Ext.create('widget.CrystalReport', {
							url		: CPATH+'/fileman/downloadItemInfoImage/' + fid,
							prgID	: 'ppl113ukrv'
						});
						win.center();
						win.show();
					} else {
						openPhotoWindow();
					}
				}
			}
		}
	});
	//미리보기 관련 윈도우
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
				autoScroll  : true,
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
				beforeshow: function( window, eOpts) {
					window.down('#photView').setSrc(CPATH+'/fileman/downloadItemInfoImage/' + fid);
				},
				show: function( window, eOpts) {
					window.center();
				}
			},
			tbar:['->',{
				xtype	: 'button',
				text	: '<t:message code="system.label.base.download" default="다운로드"/>',
				handler	: function() {
					photoWin.down('#downForm').submit({
						success:function(comp, action) {
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
				handler	: function() {
					photoWin.down('#downForm').clearForm();
					photoWin.close();
					photoWin.hide();
				}
			}]
		});
		photoWin.show();
	}
	var photoForm = Ext.create('Unilite.com.form.UniDetailForm',{
		xtype		: 'uniDetailForm',
		disabled	: false,
		fileUpload	: true,
		itemId		: 'photoForm',
		api			: {
			submit: bpr300ukrvService.photoUploadFile
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
		}]
	});
	function fnPhotoSave() {				//이미지 등록
		//조건에 맞는 내용은 적용 되는 로직
		var record	= itemInfoGrid.getSelectedRecord();
		var photoForm	= uploadWin.down('#photoForm').getForm();
		var param		= {
			ITEM_CODE	: record.data.ITEM_CODE,
			MANAGE_NO	: record.data.MANAGE_NO,
			FILE_TYPE	: record.data.FILE_TYPE
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
				title		: '<t:message code="system.label.base.uploadphoto" default="사진등록"/>',
				closable	: false,
				closeAction : 'hide',
				modal		: true,
				resizable	: true,
				width		: 300,
				height		: 100,
				layout		: {
					type: 'fit'
				},
				items		: [
					photoForm,
					{
						xtype		: 'uniDetailForm',
						itemId		: 'photoForm',
						disabled	: false,
						fileUpload	: true,
						api			: {
							submit: bpr300ukrvService.photoUploadFile
						},
						items		:[{
							xtype		: 'filefield',
							fieldLabel	: '<t:message code="system.label.base.photo" default="사진"/>',
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
					beforeshow: function( window, eOpts) {
						var toolbar = itemInfoGrid.getDockedItems('toolbar[dock="top"]');
						var needSave= !toolbar[0].getComponent('sub_save4').isDisabled();
						var record  = itemInfoGrid.getSelectedRecord();
						if (needSave) {
							if(Ext.isEmpty(record.data.FILE_TYPE) || Ext.isEmpty(record.data.MANAGE_NO)){
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
					show: function( window, eOpts) {
						window.center();
					}
				},
				afterSuccess: function() {
					var record  = detailGrid2.getSelectedRecord();
					itemInfoStore.loadStoreRecords(record.get('ITEM_CODE'));
					this.afterSavePhoto();
				},
				afterSavePhoto: function() {
					var photoForm = uploadWin.down('#photoForm');
					photoForm.clearForm();
					uploadWin.hide();
				},
				tbar:['->',{
					xtype	: 'button',
					text	: '<t:message code="system.label.base.upload" default="올리기"/>',
					handler : function() {
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

						if(fileExt != 'jpg' && fileExt != 'png' && fileExt != 'bmp' && fileExt != 'pdf') {
							Unilite.messageBox('<t:message code="system.message.base.message001" default="이미지 파일(jpg, png, bmp) 또는 pdf파일만 업로드 할 수 있습니다."/>');
							return false;
						}

						if(needSave) {
							gsNeedPhotoSave = needSave;
							itemInfoStore.saveStore();
						} else {
							fnPhotoSave();
						}
					}
				},{
					xtype	: 'button',
					text	: '<t:message code="system.label.base.close" default="닫기"/>',
					handler : function() {
//					var photoForm = uploadWin.down('#photoForm').getForm();
//					if(photoForm.isDirty()) {
//						if(confirm('사진이 변경되었습니다. 저장하시겠습니까?')) {
//							var config = {
//								success : function() {
//									// TODO: fix it!!!
//									uploadWin.afterSavePhoto();
//								}
//							}
//							UniAppManager.app.onSaveDataButtonDown(config);
//
//						}else{
								// TODO: fix it!!!
								uploadWin.afterSavePhoto();
//						}
//
//					} else {
							uploadWin.hide();
//					}
					}
				}]
			});
		}
		uploadWin.show();
	}
	//제품정보 메인
	function openItemInformationWindow() {
		if(!panelSearch.getInvalidMessage()) return;	//필수체크

		if(!referItemInformationWindow) {
			referItemInformationWindow = Ext.create('widget.uniDetailWindow', {
				title	: '제품정보 확인',
				width	: 1200,
				height	: 580,
				layout	: {type:'vbox', align:'stretch'},
				items	: [itemInfoGrid],
				tbar	: ['->',{
					itemId	: 'closeBtn',
					id		: 'closeBtn2',
					text	: '<t:message code="system.label.product.close" default="닫기"/>',
					handler	: function() {
						 referItemInformationWindow.hide();
					},
					disabled: false
				}]
			})
		}
		referItemInformationWindow.show();
		referItemInformationWindow.center();
	}



	var detailForm = Unilite.createForm('ppl113ukrvDetail', {
		autoScroll	: true,
		layout		: 'fit',
		layout		: {type: 'uniTable', columns: 4,tdAttrs: {valign:'top'}},
		defaults	: {labelWidth:60},
		disabled	: false,
		items		: [{
			xtype	: 'xuploadpanel',
			id		: 'ppl113ukrvFileUploadPanel',
			itemId	: 'fileUploadPanel',
			flex	: 1,
			width	: 975,
			height	: 300,
			listeners: {
			}
		}],
		loadForm: function(record) {
			// window 오픈시 form에 Data load
			this.reset();
//			this.setActiveRecord(record || null);
			this.resetDirtyStatus();
			//첨부파일
			var fp = Ext.getCmp('ppl113ukrvFileUploadPanel');
			var ordernum = record.ORDER_NUM;
			if(!Ext.isEmpty(ordernum)) {
				ppl113ukrvService.getFileList({DOC_NO : ordernum},
					function(provider, response) {
						fp.loadData(response.result.data);
					}
				)
			}else {
				fp.clear(); //  fp.loadData() 실행 시 데이타 삭제됨.
			}
		}
	});  // detailForm
	function openDetailWindow(record) {
		detailForm.loadForm(record);
		if(!detailWin) {
			detailWin = Ext.create('widget.uniDetailWindow', {
				title	: '수주정보',
				width	: 1000,
				height	: 370,
				isNew	: false,
				x		: 0,
				y		: 0,
				layout	: {type:'vbox', align:'stretch'},
				items	: [detailForm],
				tbar	: ['->', {
					itemId	: 'closeBtn',
					text	: '<t:message code="system.label.sales.close" default="닫기"/>',
					handler	: function() {
						detailWin.hide();
					},
					disabled: false
				}],
				listeners : {
					show:function( window, eOpts) {
						detailForm.body.el.scrollTo('top',0);
					}
				}
			})
		}
		detailWin.show();
		detailWin.center();
	}
	//수주참조 참조 메인
	function openOrderInformationWindow() {
		if(!panelSearch.getInvalidMessage()) return;	//필수체크
		orderSearch.setValue('DIV_CODE'		, panelSearch.getValue('DIV_CODE'));
		orderSearch.setValue('DVRY_DATE_FR'	, panelSearch.getValue('DVRY_DATE_FR'));
		orderSearch.setValue('DVRY_DATE_TO'	, panelSearch.getValue('DVRY_DATE_TO'));
		orderSearch.setValue('WEEK_NUM_FR'	, panelSearch.getValue('WEEK_NUM_FR'));
		orderSearch.setValue('WEEK_NUM_TO'	, panelSearch.getValue('WEEK_NUM_TO'));

		if(!referOrderInformationWindow) {
			referOrderInformationWindow = Ext.create('widget.uniDetailWindow', {
				title	: '<t:message code="system.label.product.soinforeference" default="수주정보참조"/>',
				width	: 1200,
				height	: 580,
				layout	: {type:'vbox', align:'stretch'},
				items	: [orderSearch, OrderGrid],
				tbar	: ['->',{
					itemId	: 'saveBtn',
					id		: 'saveBtn1',
					text	: '<t:message code="system.label.product.inquiry" default="조회"/>',
					handler	: function() {
						if(!orderSearch.getInvalidMessage()) return;	//필수체크
						OrderStore.loadStoreRecords();
					},
					disabled: false
				},{
					itemId	: 'confirmBtn',
					id		: 'confirmBtn1',
					text	: '<t:message code="system.label.product.productionplancalcu" default="생산계획계산"/>',
					handler	: function() { /////
						panelSearch.setValue('COM',"적용");
						OrderStore.saveStore();  /* 저장된 후 조회 */
					},
					disabled: false
				},{
					itemId	: 'confirmCloseBtn',
					id		: 'confirmCloseBtn1',
					text	: '<t:message code="system.label.product.productionplancalcuapplyclose" default="생산계획계산적용후 닫기"/>',
					handler	: function() {
						panelSearch.setValue('COM'			, "적용후닫기");
						panelSearch.setValue('DVRY_DATE_FR'	, orderSearch.getValue('DVRY_DATE_FR'));
						panelSearch.setValue('DVRY_DATE_TO'	, orderSearch.getValue('DVRY_DATE_TO'));
						panelSearch.setValue('WEEK_NUM_FR'	, orderSearch.getValue('WEEK_NUM_FR'));
						panelSearch.setValue('WEEK_NUM_TO'	, orderSearch.getValue('WEEK_NUM_TO'));
						OrderStore.saveStore();
						referOrderInformationWindow.hide();
					},
					disabled: false
				},{
					itemId	: 'closeBtn',
					id		: 'closeBtn1',
					text	: '<t:message code="system.label.product.close" default="닫기"/>',
					handler	: function() {
//						detailStore.saveStore();
						referOrderInformationWindow.hide();
					},
					disabled: false
				}],
				listeners : {
					beforehide: function(me, eOpt) {
						OrderGrid.reset();
						OrderStore.clearData();
						orderSearch.clearForm();
					},
					beforeclose: function( panel, eOpts ) {
					},
					beforeshow: function ( me, eOpts ) {
					}
				}
			})
		}
		referOrderInformationWindow.show();
		referOrderInformationWindow.center();
	}
	// 수주정보 참조 모델 정의
	Unilite.defineModel('ppl113ukrvOrderModel', {
		fields: [
			{name: 'PLAN_TYPE'			, text: '<t:message code="system.label.product.typecode" default="유형코드"/>'			, type: 'string'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.product.item" default="품목"/>'				, type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.product.itemname" default="품목명"/>'			, type: 'string'},
			{name: 'SPEC'				, text: '<t:message code="system.label.product.spec" default="규격"/>'				, type: 'string'},
			{name: 'STOCK_UNIT'			, text: '<t:message code="system.label.product.unit" default="단위"/>'				, type: 'string'},
			{name: 'CUSTOM_NAME'		, text: '<t:message code="system.label.product.custom" default="거래처"/>'				, type: 'string'},
			{name: 'ORDER_NUM'			, text: '<t:message code="system.label.product.sono" default="수주번호"/>'				, type: 'string'},
			{name: 'ORDER_Q'			, text: '<t:message code="system.label.product.soqty" default="수주량"/>'				, type: 'uniQty'},
			{name: 'INIT_DVRY_DATE'		, text: '납품요청일'			, type: 'uniDate'},//추가
			{name: 'DVRY_DATE'			, text: '납품변경일'			, type: 'uniDate'},//추가
			{name: 'WEEK_NUM'			, text: '납기주차'			, type: 'string'},//추가
			{name: 'ORDER_DATE'			, text: '<t:message code="system.label.product.sodate" default="수주일"/>'				, type: 'uniDate'},
			{name: 'PO_NUM'				, text: '오더번호'			, type: 'string'},//추가
			{name: 'REMARK'				, text: '비고'			, type: 'string'},//추가
			{name: 'SER_NO'				, text: '<t:message code="system.label.product.soseq" default="수주순번"/>'				, type: 'string'},
			{name: 'WORK_SHOP_CODE'		, text: '<t:message code="system.label.product.mainworkcenter" default="주작업장"/>'	, type: 'string' , comboType: 'WU'},
			/* 파라미터 */
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.product.division" default="사업장"/>'			, type: 'string'},
			{name: 'PAD_STOCK_YN'		, text: '<t:message code="system.label.product.availableinventoryapplyyn" default="가용재고 반영여부"/>'	 , type: 'string'},
			{name: 'CHECK_YN'			, text: '그리드선택 여부'		, type: 'string'},  // 선택 했을때 체크하는 값 (그리드 데이터랑 관련없음)
			{name: 'PROD_END_DATE'		, text: '생산요청일'			, type: 'uniDate'}
		]
	});
	//수주정보 참조 스토어 정의
	var OrderStore = Unilite.createStore('ppl113ukrvOrderStore', {
		proxy	: directProxy2,
		model	: 'ppl113ukrvOrderModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		loadStoreRecords : function() {
			var param= orderSearch.getValues();
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

			var paramMaster= orderSearch.getValues();	//syncAll 수정
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						if(panelSearch.getValue('COM') == "적용"){
							OrderStore.loadStoreRecords();
							panelSearch.setValue('COM', '');
						}
						else if(panelSearch.getValue('COM') == "적용후닫기"){
							//OrderStore.loadStoreRecords();
							//20200716 수정: store 추가로 조회로직 구분
							if(activationTab == 'tab1'){
								detailStore.loadStoreRecords();
							}else{
								detailStore2.loadStoreRecords();
							}
							panelSearch.setValue('COM', '');
						}
					}
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('ppl113ukrvOrderGrid');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});
	/** 수주정보참조을 참조하기 위한 Search Form, Grid, Inner Window 정의
	 */
	//수주정보 참조 폼 정의
	var orderSearch = Unilite.createSearchForm('orderForm', {
		layout	: {type : 'uniTable', columns : 2},
		items	: [{
			fieldLabel	: '<t:message code="system.label.product.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false
		},{
			xtype	: 'container',
			layout	: {type:'hbox', align:'stretch'},
			width	: 530,
			colspan	: 2,
			items	: [{
				fieldLabel	: '납기주차',
				name		: 'DVRY_DATE_FR',
				xtype		: 'uniDatefield',
				allowBlank	: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
					},
					blur : function (field, event, eOpts) {
						if(Ext.isEmpty(field.value)){
							orderSearch.setValue('WEEK_NUM_FR','');
						}else{
							var param = {
								'OPTION_DATE'	: UniDate.getDbDateStr(field.value),
								'CAL_TYPE'		: '3' //주단위
							}
							prodtCommonService.getCalNo(param, function(provider, response) {
								if(!Ext.isEmpty(provider.CAL_NO)){
									orderSearch.setValue('WEEK_NUM_FR',provider.CAL_NO);
								}else{
									orderSearch.setValue('WEEK_NUM_FR','');
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
				name		: 'DVRY_DATE_TO',
				xtype		: 'uniDatefield',
				allowBlank	: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
					},
					blur : function (field, event, eOpts) {
						if(Ext.isEmpty(field.value)){
							orderSearch.setValue('WEEK_NUM_TO','');
						}else{
							var param = {
								'OPTION_DATE' : UniDate.getDbDateStr(field.value),
								'CAL_TYPE' : '3' //주단위
							}
							prodtCommonService.getCalNo(param, function(provider, response) {
								if(!Ext.isEmpty(provider.CAL_NO)){
									orderSearch.setValue('WEEK_NUM_TO',provider.CAL_NO);
								}else{
									orderSearch.setValue('WEEK_NUM_TO','');
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
		},
/*		{
			fieldLabel: '<t:message code="system.label.product.productionrequestdate" default="생산요청일"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'PROD_END_DATE_FR',
			endFieldName: 'PROD_END_DATE_TO',
			width: 350,
			startDate: UniDate.get('mondayOfWeek'),
			endDate: UniDate.get('endOfWeek')
		},*/
		Unilite.popup('ORDER_NUM',{
			fieldLabel		: '수주번호',
			valueFieldName	: 'ORDER_NUM',
			textFieldName	: 'ORDER_NUM',
			listeners		: {
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': orderSearch.getValue('DIV_CODE')});
				}
			}
		}),
		Unilite.popup('DIV_PUMOK',{
			fieldLabel		: '<t:message code="system.label.product.item" default="품목"/>',
			valueFieldName	: 'ITEM_CODE',
			textFieldName	: 'ITEM_NAME',
			listeners		: {
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': orderSearch.getValue('DIV_CODE')});
				}
			}
		}),{
			fieldLabel	: '<t:message code="system.label.product.sentence001" default="※ 생산계획계산시 가용재고(현재고+입고예정-출고예정-안전재고)반영여부"/>',
			xtype		: 'uniRadiogroup',
			labelWidth	: 450,
			width		: 235,
			colspan		: 2,
			name		: 'PAD_STOCK_YN',
			id			: 'padStockYn',
			items		: [{
				boxLabel	: '<t:message code="system.label.product.yes" default="예"/>',
				width		: 70,
				name		: 'PAD_STOCK_YN',
				inputValue	: 'Y'
			},{
				boxLabel	: '<t:message code="system.label.product.no" default="아니오"/>',
				width		: 70,
				name		: 'PAD_STOCK_YN',
				inputValue	: 'N' ,
				checked		: true
			}]
		}]
	});
	/* 수주정보 그리드 */
	var OrderGrid = Unilite.createGrid('ppl113ukrvOrderGrid', {
		store	: OrderStore,
		layout	: 'fit',
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }),
		uniOpt	: {
			onLoadSelectFirst : false
		},
		columns: [
			{ dataIndex: 'CHECK_YN'			, width: 40 , hidden: true},
			{ dataIndex: 'PLAN_TYPE'		, width: 40 , hidden: true},
			{ dataIndex: 'ITEM_CODE'		, width: 120},
			{ dataIndex: 'ITEM_NAME'		, width: 140},
			{ dataIndex: 'SPEC'				, width: 126},
			{ dataIndex: 'STOCK_UNIT'		, width: 44},
			{ dataIndex: 'CUSTOM_NAME'		, width: 120},
			{ dataIndex: 'ORDER_NUM'		, width: 100},
			{ dataIndex: 'ORDER_Q'			, width: 66},
			{ dataIndex: 'INIT_DVRY_DATE'	, width: 80},
			{ dataIndex: 'DVRY_DATE'		, width: 80},
			{ dataIndex: 'WEEK_NUM'			, width: 80},
			{ dataIndex: 'ORDER_DATE'		, width: 80},
			{ dataIndex: 'PO_NUM'			, width: 100},
			{ dataIndex: 'REMARK'			, width: 100},
			{ dataIndex: 'SER_NO'			, width: 100,hidden:true},
			{ dataIndex: 'DIV_CODE'			, width: 100,hidden:true},
			{ dataIndex: 'PAD_STOCK_YN'		, width: 100,hidden:true},
			{ dataIndex: 'WORK_SHOP_CODE'	, width: 100,hidden: true}
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
		if(!panelSearch.getInvalidMessage()) return;	//필수체크

		SalesPlanSearch.setValue('DIV_CODE'			, panelSearch.getValue('DIV_CODE'));
		SalesPlanSearch.setValue('PROD_END_DATE_FR'	, UniDate.get('startOfMonth', panelSearch.getValue('PRODT_PLAN_DATE_FR')));
		SalesPlanSearch.setValue('PROD_END_DATE_TO'	, panelSearch.getValue('PRODT_PLAN_DATE_FR'));

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
					},{	itemId : 'confirmBtn',
						id:'confirmBtn2',
						text: '<t:message code="system.label.product.productionplancalcu" default="생산계획계산"/>',
						handler: function() {
							panelSearch.setValue('COM',"적용");
							SalesPlanStore.saveStore();
						},
						disabled: false
					},{	itemId : 'confirmCloseBtn',
						id:'confirmCloseBtn2',
						text: '<t:message code="system.label.product.productionplancalcuapplyclose" default="생산계획계산적용후 닫기"/>',
						handler: function() {
							panelSearch.setValue('COM',"적용후닫기");
							SalesPlanStore.saveStore();
							referSalesPlanWindow.hide();
						},
						disabled: false
					},{
						itemId : 'closeBtn',
						text: '<t:message code="system.label.product.close" default="닫기"/>',
						handler: function() {
							//20200716 수정: store 추가로 데이터 닫기 로직 구분
							if(activationTab == 'tab1'){
								detailStore.saveStore();
							} else {
								detailStore2.saveStore();
							}
							referSalesPlanWindow.hide();
						},
						disabled: false
					}
				],
				listeners : {
					beforehide: function(me, eOpt) {
						//SalesOrderSearch.clearForm();
						//SalesOrderGrid.reset();
					},
					beforeclose: function( panel, eOpts ) {
						//SalesOrderSearch.clearForm();
						//SalesOrderGrid.reset();
					},
					beforeshow: function ( me, eOpts ) {
						SalesPlanStore.loadStoreRecords();
					}
				}
			})
		}
		referSalesPlanWindow.show();
		referSalesPlanWindow.center();
	}
	//판매계획 참조 모델 정의
	Unilite.defineModel('ppl113ukrvSalesPlanModel', {
		fields: [
			{name: 'GUBUN'			, text: '<t:message code="system.label.product.selection" default="선택"/>'			, type: 'string'},
			{name: 'PLAN_TYPE'		, text: '<t:message code="system.label.product.typecode" default="유형코드"/>'			, type: 'string'},
			{name: 'PLANTYPE_NAME'	, text: '<t:message code="system.label.product.type" default="유형"/>'				, type: 'string'},
			{name: 'ITEM_ACCOUNT'	, text: '<t:message code="system.label.product.itemaccount" default="품목계정"/>'		, type: 'string' , comboType:'AU', comboCode:'B020'},
			{name: 'ITEM_CODE'		, text: '<t:message code="system.label.product.item" default="품목"/>'				, type: 'string'},
			{name: 'ITEM_NAME'		, text: '<t:message code="system.label.product.itemname" default="품목명"/>'			, type: 'string'},
			{name: 'STOCK_UNIT'		, text: '<t:message code="system.label.product.inventoryunit" default="재고단위"/>'		, type: 'string'},
			{name: 'PLAN_QTY'		, text: '<t:message code="system.label.product.planqty" default="계획량"/>'			, type: 'uniQty'},
			{name: 'NOTREF_Q'		, text: '<t:message code="system.label.product.noplanqty" default="미계획량"/>'			, type: 'uniQty'},
			{name: 'BASE_DATE'		, text: '<t:message code="system.label.product.basisdate" default="기준일"/>'			, type: 'uniDate'},
			{name: 'SALE_TYPE'		, text: '<t:message code="system.label.product.salestype" default="판매유형"/>'			, type: 'string'},
			{name: 'WORK_SHOP_CODE'	, text: '<t:message code="system.label.product.mainworkcenter" default="주작업장"/>'	, type: 'string'},
			{name: 'DIV_CODE'		, text: '<t:message code="system.label.product.workcenter" default="작업장"/>'			, type: 'string'},
			{name: 'ORDER_NUM'		, text: '<t:message code="system.label.product.sono" default="수주번호"/>'				, type: 'string'},
			{name: 'SER_NO'			, text: '<t:message code="system.label.product.soseq" default="수주순번"/>'				, type: 'string'},
			{name: 'ORDER_Q'		, text: '<t:message code="system.label.product.soqty" default="수주량"/>'				, type: 'uniQty'}
		]
	});
	//판매계획 참조 스토어 정의
	var SalesPlanStore = Unilite.createStore('ppl113ukrvSalesPlanStore', {
		model	: 'ppl113ukrvSalesPlanModel',
		proxy	: directProxy3,
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		loadStoreRecords : function() {
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

						if(panelSearch.getValue('COM') == "적용"){
							OrderStore.loadStoreRecords();
							panelSearch.setValue('COM', '');
						}
						else if(panelSearch.getValue('COM') == "적용후닫기"){
							//OrderStore.loadStoreRecords();
							//20200716 수정: store 추가로 조회로직 구분
							if(activationTab == 'tab1'){
								detailStore.loadStoreRecords();
							}else{
								detailStore2.loadStoreRecords();
							}
							panelSearch.setValue('COM', '');
						}
					}
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('ppl113ukrvSalesPlanGrid');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});
	/** 판매계획을 참조하기 위한 Search Form, Grid, Inner Window 정의
	 */
	//판매계획 참조 폼 정의
	var SalesPlanSearch = Unilite.createSearchForm('ppl113ukrvSalesPlanForm', {
		layout	: {type : 'uniTable', columns : 4},
		items	: [{
			fieldLabel	: '<t:message code="system.label.product.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120'
		},{
			fieldLabel		: '<t:message code="system.label.product.planperiod" default="계획기간"/>',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'FROM_MONTH',
			endFieldName	: 'TO_MONTH',
			width			: 350,
			startDate		: UniDate.get('startOfMonth'),
			endDate			: UniDate.get('today')/*,
			allowBlank		: false*/		/// 계획기간 폼 만들기 전까지 필수조건 제거
		},{
			fieldLabel	: '<t:message code="system.label.product.salestype" default="판매유형"/>',
			name		: 'SALE_TYPE',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: ''
		},{
			fieldLabel	: '<t:message code="system.label.product.repmodel" default="대표모델"/>',
			name		: 'ITEM_GROUP',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: ''
		},{
			fieldLabel	: '<t:message code="system.label.product.itemaccount" default="품목계정"/>',
			name		: 'ITEM_ACCOUNT',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B020'
		},{
			fieldLabel	: '<t:message code="system.label.product.majorgroup" default="대분류"/>',
			name		: 'TXTLV_L1',
			xtype		: 'uniCombobox',
			store		: Ext.data.StoreManager.lookup('itemLeve1Store'),
			child		: 'TXTLV_L2'
		},{
			fieldLabel	: '<t:message code="system.label.product.middlegroup" default="중분류"/>',
			name		: 'TXTLV_L2',
			xtype		: 'uniCombobox',
			store		: Ext.data.StoreManager.lookup('itemLeve2Store'),
			child		: 'TXTLV_L3'
		},{
			fieldLabel	: '<t:message code="system.label.product.minorgroup" default="소분류"/>',
			name		: 'TXTLV_L3',
			xtype		: 'uniCombobox',
			store		: Ext.data.StoreManager.lookup('itemLeve3Store')
		},{
			fieldLabel	: '<t:message code="system.label.product.sentence001" default="※ 생산계획계산시 가용재고(현재고+입고예정-출고예정-안전재고)반영여부"/>',
			xtype		: 'uniRadiogroup',
			labelWidth	: 450,
			width		: 235,
			colspan		: 3,
			items		: [{
				boxLabel	: '<t:message code="system.label.product.yes" default="예"/>',
				width		: 70,
				name		: 'PAD_STOCK_YN',
				inputValue	: 'Y'
			},{
				boxLabel	: '<t:message code="system.label.product.no" default="아니오"/>',
				width		: 70,
				name		: 'PAD_STOCK_YN',
				inputValue	: 'N' ,
				checked		: true
			}]
		}]
	});
	//판매계획 참조 그리드 정의
	var SalesPlanGrid = Unilite.createGrid('ppl113ukrvSalesPlanGrid', {
		store	: SalesPlanStore,
		layout	: 'fit',
		region	: 'center',
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }),
		uniOpt	: {
			onLoadSelectFirst: false
		},
		columns: [
			{ dataIndex: 'GUBUN'			, width: 40 , hidden: true},
			{ dataIndex: 'CHECK_YN'			, width: 40 , hidden: true},
			{ dataIndex: 'PLAN_TYPE'		, width: 40 , hidden: true},
			{ dataIndex: 'PLANTYPE_NAME'	, width: 100},
			{ dataIndex: 'ITEM_ACCOUNT'		, width: 66 },
			{ dataIndex: 'ITEM_CODE'		, width: 100},
			{ dataIndex: 'ITEM_NAME'		, width: 146},
			{ dataIndex: 'STOCK_UNIT'		, width: 66 },
			{ dataIndex: 'PLAN_QTY'			, width: 120},
			{ dataIndex: 'NOTREF_Q'			, width: 120},
			{ dataIndex: 'BASE_DATE'		, width: 100},
			{ dataIndex: 'SALE_TYPE'		, width: 100},
			{ dataIndex: 'WORK_SHOP_CODE'	, width: 66  , hidden: true},
			{ dataIndex: 'DIV_CODE'			, width: 100 , hidden: true},
			{ dataIndex: 'ORDER_NUM'		, width: 100 , hidden: true},
			{ dataIndex: 'SER_NO'			, width: 100 , hidden: true},
			{ dataIndex: 'ORDER_Q'			, width: 100 , hidden: true}
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



	var tab = Unilite.createTabPanel('tabPanel',{
		activeTab	: 0,
		region		: 'center',
		flex		: 2,
		items		: [{
			title	: '수주번호별',
			xtype	: 'container',
			layout	: {type:'vbox', align:'stretch'},
			items	: [detailGrid],
			id		: 'tab1'
		},{
			title	: '주차별',
			xtype	: 'container',
			layout	: {type:'vbox', align:'stretch'},
			items	: [detailGrid2],
			id		: 'tab2'
		}],
		listeners : {
			beforetabchange : function ( tabPanel, newCard, oldCard, eOpts ) {
				if(!panelSearch.getInvalidMessage()) return false;	// 필수체크
			},
			tabChange : function ( tabPanel, newCard, oldCard, eOpts ) {
				var newTabId = newCard.getId();
				if(newTabId == 'tab1'){
					var tab1SelectedRec = detailGrid.getSelectedRecord();
					if(Ext.isEmpty(tab1SelectedRec)){
						subGrid.reset();
						subStore.clearData();
					}else{
						if(tab1SelectedRec.phantom){
							subGrid.reset();
							subStore.clearData();
						}else{
							subStore.loadStoreRecords(tab1SelectedRec);
						}
					}
					activationTab = 'tab1';
				}else{
					var tab2SelectedRec = detailGrid2.getSelectedRecord();
					if(Ext.isEmpty(tab2SelectedRec)){
						subGrid.reset();
						subStore.clearData();
					}else{
						if(tab2SelectedRec.phantom){
							subGrid.reset();
							subStore.clearData();
						}else{
							subStore.loadStoreRecords(tab2SelectedRec);
						}
					}
					activationTab = 'tab2';
				}
			}
		}
	});
	var tab2 = Unilite.createTabPanel('tabPanel2',{
		activeTab	: 0,
		region		: 'south',
		split		: true,
		flex		: 1,
		items		: [{
			title	: '소요자재',
			xtype	: 'container',
			layout	: {type:'vbox', align:'stretch'},
			items	: [subGrid],
			id		: 'tabSub1'
		}]
	});



	var orderNoSearch = Unilite.createSearchForm('orderNoSearchForm', {
		layout	: {
			type	: 'uniTable',
			columns	: 3
		},
		trackResetOnLoad: true,
		items	: [{
			fieldLabel	: '<t:message code="unilite.msg.sMS631" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			value		: UserInfo.divCode,
			allowBlank	: false,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					combo.changeDivCode(combo, newValue, oldValue, eOpts);
					var field = orderNoSearch.getField('ORDER_PRSN');
					field.fireEvent('changedivcode', field, newValue, oldValue, eOpts); // panelResult의 필터링 처리 위해..
				}
			}
		},{
			fieldLabel		: '<t:message code="unilite.msg.sMS122" default="수주일"/>',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'FR_ORDER_DATE',
			endFieldName	: 'TO_ORDER_DATE',
			width			: 350,
			startDate		: UniDate.get('startOfMonth'),
			endDate			: UniDate.get('today'),
			colspan			: 2
		},{
			fieldLabel	: '<t:message code="unilite.msg.sMS573" default="sMS669"/>',
			name		: 'ORDER_PRSN',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'S010',
			onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode) {
				if (eOpts) {
					combo.filterByRefCode('refCode1', newValue, eOpts.parent);
				} else {
					combo.divFilterByRefCode('refCode1', newValue, divCode);
				}
			}
		},
		Unilite.popup('AGENT_CUST', {
			fieldLabel		: '<t:message code="unilite.msg.sMSR213" default="거래처"/>',
			validateBlank	: false,
			colspan			: 2,
			listeners		: {
				applyextparam: function(popup) {
					popup.setExtParam({
						'AGENT_CUST_FILTER': ['1', '3']
					});
					popup.setExtParam({
						'CUSTOM_TYPE': ['1', '3']
					});
				}
			}
		}),
		// Unilite.popup('AGENT_CUST',{fieldLabel:'프로젝트' , valueFieldName:'PROJECT_NO',
		// textFieldName:'PROJECT_NAME', validateBlank: false}),
		Unilite.popup('DIV_PUMOK', {
			colspan		: 2,
			listeners	: {
				applyextparam: function(popup) {
					popup.setExtParam({
						'DIV_CODE': orderNoSearch.getValue('DIV_CODE')
					});
				}
			}
		}),{
			fieldLabel	: '<t:message code="unilite.msg.sMS832" default="판매유형"/>',
			name		: 'ORDER_TYPE',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'S002'
		},{
			fieldLabel: '<t:message code="unilite.msg.sMSR281" default="PO번호"/>',
			name: 'PO_NUM'
		}]
	}); // createSearchForm
	// 검색 모델(디테일)
	Unilite.defineModel('orderNoDetailModel', {
		fields: [
			{ name: 'DIV_CODE'		,text:'<t:message code="unilite.msg.sMS631" default="사업장"/>'			,type: 'string' ,comboType:'BOR120'},
			{ name: 'ITEM_CODE'		,text:'<t:message code="unilite.msg.sMR004" default="품목코드"/>'			,type: 'string' },
			{ name: 'ITEM_NAME'		,text:'<t:message code="unilite.msg.sMR349" default="품명"/>'				,type: 'string' },
			{ name: 'SPEC'			,text:'<t:message code="unilite.msg.sMSR033" default="규격"/>'			,type: 'string' },
			{ name: 'BOM_YN'		,text:'<t:message code="system.label.base.entryyn" default="등록여부"/>'	,type: 'string' },
			{ name: 'ORDER_DATE'	,text:'<t:message code="unilite.msg.sMS122" default="수주일"/>'			,type: 'uniDate'},
			{ name: 'DVRY_DATE'		,text:'<t:message code="unilite.msg.sMS123" default="납기일"/>'			,type: 'uniDate'},
			{ name: 'ORDER_Q'		,text:'<t:message code="unilite.msg.sMS543" default="수주량"/>'			,type: 'uniQty' },
			{ name: 'ORDER_TYPE'	,text:'<t:message code="unilite.msg.sMS832" default="판매유형"/>'			,type: 'string' ,comboType:'AU', comboCode:'S002'},
			{ name: 'ORDER_PRSN'	,text:'<t:message code="unilite.msg.sMS669" default="수주담당"/>'			,type: 'string' ,comboType:'AU', comboCode:'S010'},
			{ name: 'PO_NUM'		,text:'<t:message code="unilite.msg.sMSR281" default="PO번호"/>'			,type: 'string' },
			{ name: 'PROJECT_NO'	,text:'<t:message code="unilite.msg.sMR161" default="프로젝트번호"/>'			,type: 'string' },
			{ name: 'ORDER_NUM'		,text:'<t:message code="unilite.msg.sMS533" default="수주번호"/>'			,type: 'string' },
			{ name: 'SER_NO'		,text:'<t:message code="unilite.msg.sMS783" default="수주순번"/>'			,type: 'string' },
			{ name: 'CUSTOM_CODE'	,text:'<t:message code="unilite.msg.sMSR213" default="거래처"/>'			,type: 'string' },
			{ name: 'CUSTOM_NAME'	,text:'<t:message code="unilite.msg.sMSR279" default="거래처명"/>'			,type: 'string' },
			{ name: 'COMP_CODE'		,text:'COMP_CODE'		,type: 'string' },
			{ name: 'PJT_CODE'		,text:'프로젝트코드'															,type: 'string' },
			{ name: 'PJT_NAME'		,text:'프로젝트'															,type: 'string' },
			{ name: 'FR_DATE'		,text:'시작일'																,type: 'string' },
			{ name: 'TO_DATE'		,text:'종료일'																,type: 'string' }
		]
	});
	// 검색 스토어(디테일)
	var orderNoDetailStore = Unilite.createStore('orderNoDetailStore', {
		model	: 'orderNoDetailModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,// 상위 버튼 연결
			editable	: false,// 수정 모드 사용
			deletable	: false,// 삭제 가능 여부
			useNavi		: false	// prev | newxt 버튼 사용
		},
		proxy: {
			type: 'direct',
			api	: {
				read: 'sof100ukrvService.selectOrderNumDetailList'
			}
		},
		loadStoreRecords: function() {
			var param = orderNoSearch.getValues();
			var authoInfo = pgmInfo.authoUser; // 권한정보(N-전체,A-자기사업장>5-자기부서)
			var deptCode = UserInfo.deptCode; // 부서코드
			if (authoInfo == "5" && Ext.isEmpty(orderNoSearch.getValue('DEPT_CODE'))) {
				param.DEPT_CODE = deptCode;
			}
			console.log(param);
			this.load({
				params: param
			});
		}
	});
	// 검색 그리드(디테일)
	var orderNoDetailGrid = Unilite.createGrid('sof100ukrvOrderNoDetailGrid', {
		store	: orderNoDetailStore,
		layout	: 'fit',
		uniOpt	: {
			useRowNumberer: false
		},
		columns	: [
			{ dataIndex: 'DIV_CODE'		, width: 80	},
			{ dataIndex: 'ITEM_CODE'	, width: 120},
			{ dataIndex: 'ITEM_NAME'	, width: 150},
			{ dataIndex: 'SPEC'			, width: 150},
			{ dataIndex: 'BOM_YN'		, width: 70	,align: 'center' },
			{ dataIndex: 'ORDER_DATE'	, width: 80	},
			{ dataIndex: 'DVRY_DATE'	, width: 80	,hidden:true},
			{ dataIndex: 'ORDER_Q'		, width: 80	},
			{ dataIndex: 'ORDER_TYPE'	, width: 90	},
			{ dataIndex: 'ORDER_PRSN'	, width: 90	,hidden:true},
			{ dataIndex: 'PO_NUM'		, width: 100},
			{ dataIndex: 'PROJECT_NO'	, width: 90	},
			{ dataIndex: 'ORDER_NUM'	, width: 120},
			{ dataIndex: 'SER_NO'		, width: 70	,hidden:true},
			{ dataIndex: 'CUSTOM_CODE'	, width: 120,hidden:true},
			{ dataIndex: 'CUSTOM_NAME'	, width: 200},
			{ dataIndex: 'COMP_CODE'	, width: 80	,hidden:true},
			{ dataIndex: 'PJT_CODE'		, width: 120,hidden:true},
			{ dataIndex: 'PJT_NAME'		, width: 200},
			{ dataIndex: 'FR_DATE'		, width: 80	,hidden:true},
			{ dataIndex: 'TO_DATE'		, width: 80	,hidden:true}
		],
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
				orderNoDetailGrid.returnData(record)
				searchOrderWindow.hide();
			}
		},
		returnData: function(record) {
			if (Ext.isEmpty(record)) {
				record = this.getSelectedRecord();
			}
			//20200716 수정: store 추가로 데이터 set하는 로직 구분
			if(activationTab == 'tab1'){
				var grdRecord = detailGrid.uniOpt.currentRecord;
			} else {
				var grdRecord = detailGrid2.uniOpt.currentRecord;
			}
			grdRecord.set('ORDER_NUM'	,record.get('ORDER_NUM'));		//수주번호
			grdRecord.set('SEQ'			,record.get('SER_NO'));				//수주순번
			grdRecord.set('ITEM_CODE'	,record.get('ITEM_CODE'));		//품목
			grdRecord.set('ITEM_NAME'	,record.get('ITEM_NAME'));		//폼목명
			grdRecord.set('ORDER_Q'		,record.get('ORDER_UNIT_Q'));	//수주량
			grdRecord.set('PLAN_TYPE'	,'S');							//구분
		}
	});
	function openSearchOrderWindow() {
		if (!searchOrderWindow) {
			searchOrderWindow = Ext.create('widget.uniDetailWindow', {
				title	: '수주번호검색',
				width	: 1000,
				height	: 580,
				layout	: {
					type	: 'vbox',
					align	: 'stretch'
				},
				items	: [orderNoSearch, orderNoDetailGrid],
				tbar	: ['->',{
					itemId	: 'searchBtn',
					text	: '조회',
					handler	: function() {
						orderNoDetailStore.loadStoreRecords();
					},
					disabled: false
				},{
					itemId	: 'closeBtn',
					text	: '닫기',
					handler	: function() {
						searchOrderWindow.hide();
					},
					disabled: false
				}],
				listeners: {
					beforehide: function(me, eOpt) {
						orderNoSearch.clearForm();
						orderNoDetailGrid.reset();
						orderNoDetailStore.clearData();
					},
					beforeclose: function(panel, eOpts) {
					},
					show: function(panel, eOpts) {
						orderNoSearch.setValue('DIV_CODE'		, panelSearch.getValue('DIV_CODE'));
						orderNoSearch.setValue('FR_ORDER_DATE'	, UniDate.get('startOfMonth'));
						orderNoSearch.setValue('TO_ORDER_DATE'	, UniDate.get('today'));
					}
				}
			})
		}
		searchOrderWindow.center();
		searchOrderWindow.show();
	}



	/** main app
	 */
	Unilite.Main({
		id			: 'ppl113ukrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				panelSearch, tab,tab2
			]
		}],
		fnInitBinding: function() {
			this.setDefault();
		},
		onQueryButtonDown: function() {
			if(!panelSearch.getInvalidMessage()) return;	//필수체크
			//20200716 수정: store 추가로 조회로직 구분
			if(activationTab == 'tab1'){
				detailStore.loadStoreRecords();
			}else{
				detailStore2.loadStoreRecords();
			}
		},
		onNewDataButtonDown: function() {
			if(!panelSearch.getInvalidMessage()) return;	//필수체크
			panelSearch.setAllFieldsReadOnly(false);
			//20200716 수정: store 추가로 순번 구하는 로직 구분
			if(activationTab == 'tab1'){
				var seq = detailStore.max('SER_NO');
			} else {
				var seq = detailStore2.max('SER_NO');
			}
			if(!seq) seq = 1;
			else seq += 1;
			var compCode		= UserInfo.compCode
			var divCode			= panelSearch.getValue('DIV_CODE');
			var workShopCode	= panelSearch.getValue('WORK_SHOP_CODE');
			var prodtPlanDate	= UniDate.get('today');
			var wkPlanQ			= '0';
			var updateDbUser	= 'UserInfo.UserID';
			var updateDbTime	= UniDate.get('today');
			var stockQ			= '';
			var orderUnitQ		= '';
			var wkordQ			= '';
			var prodtQ			= '';
			var planType		= 'P';
			var r = {
				SER_NO			: seq,			/* 순번 */
				COMP_CODE		: compCode,		/* 법인코드*/
				DIV_CODE		: divCode,		/* 사업장*/
				WORK_SHOP_CODE	: workShopCode,	/* 작업장 */
				PRODT_PLAN_DATE	: prodtPlanDate,/* 계획정보 - 계획일 */
				WEEK_NUM		: gsWeekNum,	//20200716 추가: 불필요하게 쿼리하는 로직 삭제하기 위해 전역변수 추가
				WK_PLAN_Q		: wkPlanQ,		/* 계획량 */
				UPDATE_DB_USER	: updateDbUser,	/* 수정자 */
				UPDATE_DB_TIME	: updateDbTime,	/* 수정일 */
				STOCK_Q			: stockQ,		/* 수주정보 - 현재고 */
				ORDER_UNIT_Q	: orderUnitQ,	/* 수주정보 - 수주량 */
				WKORD_Q			: wkordQ,		/* 연계정보 - 작업지시량 */
				PRODT_Q			: prodtQ,		/* 연계정보 - 생산량 */
				PLAN_TYPE		: planType
			};
			if(activationTab == 'tab1'){
				detailGrid.createRow(r, null);
			}else{
				detailGrid2.createRow(r, null);
			}
		},
		onResetButtonDown: function() {
			this.suspendEvents();
			panelSearch.clearForm();
			detailGrid.reset();
			detailGrid2.reset();
			detailStore.clearData();
			detailStore2.clearData();		//20200716 추가
			subGrid.reset();
			subStore.clearData();
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {
			//20200716 수정: store 추가로 저장로직 구분
			if(activationTab == 'tab1'){
				detailStore.saveStore();
			}else{
				detailStore2.saveStore();
			}
		},
		onDeleteDataButtonDown: function() {
			//20200716 수정: store 추가로 삭제로직 구분
			if(activationTab == 'tab1'){
				var selGrid	= detailGrid;
				var selRow	= detailGrid.getSelectedRecord();
			}else{
				var selGrid	= detailGrid2;
				var selRow	= detailGrid2.getSelectedRecord();
			}
			//20200716 수정: 삭제전 체크로직 추가
			if(selRow) {
				if(selRow.phantom === true) {
					selGrid.deleteSelectedRow();
				}else if(confirm('<t:message code="system.message.product.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
					if(selRow.get('WKORD_NUM') != '') {
						Unilite.messageBox('<t:message code="system.message.product.message020" default="삭제할 수 없습니다."/>');
					}/*else if(selRow.get('MRP_YN') == 'Y'){
						alert('<t:message code="system.message.product.message020" default="삭제할 수 없습니다."/>');
					}*/else {
						selGrid.deleteSelectedRow();
					}
				}
			}
		},
		onDeleteAllButtonDown: function() {
			//20200716 수정: store 추가로 전체삭제로직 구분
			if(activationTab == 'tab1'){
				var selGrid	= detailGrid;
				var records = detailStore.data.items;
			}else{
				var selGrid	= detailGrid2;
				var records = detailStore2.data.items;
			}
			var isNewData = false;
			Ext.each(records, function(record,i) {
				if(record.phantom){						//신규 레코드일시 isNewData에 true를 반환
					isNewData = true;
				}else{									//신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
					if(confirm('<t:message code="system.message.product.confirm002" default="전체삭제 하시겠습니까?"/>')) {
						var deletable = true;
						if(deletable){
							selGrid.reset();
							UniAppManager.app.onSaveDataButtonDown();
						}
						isNewData = false;
					}
					return false;
				}
			});
			if(isNewData){								//신규 레코드들만 있을시 그리드 리셋
				selGrid.reset();
				UniAppManager.app.onResetButtonDown();	//삭제후 RESET..
			}
		},
		rejectSave: function() {
			var rowIndex = detailGrid.getSelectedRowIndex();
			detailGrid.select(rowIndex);
			detailStore.rejectChanges();
			if(rowIndex >= 0){
				detailGrid.getSelectionModel().select(rowIndex);
				var selected = detailGrid.getSelectedRecord();

				var selected_doc_no = selected.data['DOC_NO'];
				bdc100ukrvService.getFileList(
					{DOC_NO : selected_doc_no},
					function(provider, response) {
					}
				);
			}
			detailStore.onStoreActionEnable();
		},
		confirmSaveData: function(config) {
			var fp = Ext.getCmp('ppl113ukrvFileUploadPanel');
			if(detailStore.isDirty() || fp.isDirty()) {
				if(confirm(Msg.sMB061)) {
					this.onSaveDataButtonDown(config);
				} else {
					this.rejectSave();
				}
			}
		},
		setDefault: function() {
			gsWeekNum = ''	//20200716 추가: 불필요하게 쿼리하는 로직 삭제하기 위해 전역변수 추가
			panelSearch.setValue('DIV_CODE'		, UserInfo.divCode);
			panelSearch.setValue('DVRY_DATE_FR'	, UniDate.get('today'));
			panelSearch.setValue('DVRY_DATE_TO'	, UniDate.get('todayOfNextMonth'));

			var param = {
				'OPTION_DATE'	: UniDate.getDbDateStr(UniDate.get('today')),
				'CAL_TYPE'		: '3' //주단위
			}
			prodtCommonService.getCalNo(param, function(provider, response) {
				if(!Ext.isEmpty(provider.CAL_NO)){
					panelSearch.setValue('WEEK_NUM_FR', provider.CAL_NO);
					gsWeekNum = provider.CAL_NO;	//20200716 추가: 불필요하게 쿼리하는 로직 삭제하기 위해 전역변수 추가
				}else{
					panelSearch.setValue('WEEK_NUM_FR', '');
				}
			});
			var param = {
				'OPTION_DATE'	: UniDate.getDbDateStr(UniDate.get('todayOfNextMonth')),
				'CAL_TYPE'		: '3' //주단위
			}
			prodtCommonService.getCalNo(param, function(provider, response) {
				if(!Ext.isEmpty(provider.CAL_NO)){
					panelSearch.setValue('WEEK_NUM_TO', provider.CAL_NO);
				}else{
					panelSearch.setValue('WEEK_NUM_TO', '');
				}
			});
			panelSearch.getForm().wasDirty = false;
			panelSearch.resetDirtyStatus();
			UniAppManager.setToolbarButtons(['reset', 'newData'], true);
			UniAppManager.setToolbarButtons('save', false);
		}
	});



	/** Validation
	 */
	Unilite.createValidator('validator01', {
		store	: detailStore,
		grid	: detailGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "PRODT_PLAN_DATE" :
					var param = {
						'OPTION_DATE' : UniDate.getDbDateStr(newValue),
						'CAL_TYPE' : '3' //주단위
					}
					prodtCommonService.getCalNo(param, function(provider, response) {
						if(!Ext.isEmpty(provider.CAL_NO)){
							record.set('WEEK_NUM',provider.CAL_NO);
						}else{
							record.set('WEEK_NUM','');
						}
					});
					record.set('CONFIRM_YN',true);
				break;
			}
			return rv;
		}
	}); // validator

	Unilite.createValidator('validator02', {
		store	: detailStore2,
		grid	: detailGrid2,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "PRODT_PLAN_DATE" :
					var param = {
						'OPTION_DATE'	: UniDate.getDbDateStr(newValue),
						'CAL_TYPE'		: '3' //주단위
					}
					prodtCommonService.getCalNo(param, function(provider, response) {
						if(!Ext.isEmpty(provider.CAL_NO)){
							record.set('WEEK_NUM',provider.CAL_NO);
						}else{
							record.set('WEEK_NUM','');
						}
					});
					record.set('CONFIRM_YN',true);
				break;
			}
			return rv;
		}
	}); // validator
}
</script>