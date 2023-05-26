<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="tix100ukrv" >
	<t:ExtComboStore comboType="BOR120" pgmId="tix100ukrv"/> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A"/>						<!-- 창고 -->
	<t:ExtComboStore comboType="AU" comboCode="A020"/>					<!-- 종료여부 -->
	<t:ExtComboStore comboType="AU" comboCode="A022"/>					<!-- 증빙유형 -->
	<t:ExtComboStore comboType="AU" comboCode="B020"/>					<!-- 계정 -->
	<t:ExtComboStore comboType="AU" comboCode="B004"/>                 <!-- 화폐단위 -->
	<t:ExtComboStore comboType="AU" comboCode="M007"/>					<!-- 승인여부 -->
	<t:ExtComboStore comboType="AU" comboCode="M201"/>					<!-- 구매담당 콤보 -->
	<t:ExtComboStore comboType="AU" comboCode="T005"/>					<!-- 가격조건 -->
	<t:ExtComboStore comboType="AU" comboCode="T006"/>					<!-- 결제조건 -->
	<t:ExtComboStore comboType="AU" comboCode="T016"/>					<!-- 결제방법 콤보 -->
	<t:ExtComboStore comboType="AU" comboCode="T071" opts= 'B;O;P;S'/>	<!-- 진행구분-->
	<t:ExtComboStore comboType="AU" comboCode="T107" />					<!-- 배부대상 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

var BsaCodeInfo = {
	gsOrderPrsn      : '${gsOrderPrsn}',
	gsTradeCalcMethod: '${gsTradeCalcMethod}'
};
var gsAmtUnit = "";
var gsExchangeRate = 0;
var outDivCode = UserInfo.divCode;
var PassInconWindow		//통관번호팝업(공통 팝업은 그리드 설정이 안돼 로컬로 선언)

function appMain() {
	/** Model 정의
	 * @type
	 */
	Unilite.defineModel('tix100ukrvModel', {
		fields: [
			{name: 'TRADE_DIV'			, text: '<t:message code="system.label.trade.tradeclass" default="무역구분"/>'		, type: 'string'},
			{name: 'CHARGE_TYPE'		, text: '진행구분'		, type: 'string',comboType: 'AU', comboCode: 'T071'			, allowBlank: false},
			{name: 'CHARGE_SER'			, text: '순번'		, type: 'int', allowBlank: false},
			{name: 'BASIC_PAPER_NO'		, text: '근거번호'		, type: 'string', allowBlank:false},
/*hidden*/  {name: 'TRADE_CUSTOM_CODE'	, text: '<t:message code="system.label.trade.exporter" default="수출자"/>'			, type: 'string'},
			{name: 'TRADE_CUSTOM_NAME'	, text: '수출자명'		, type: 'string'},
/*hidden*/  {name: 'CHARGE_CODE'		, text: '<t:message code="system.label.trade.expensecode" default="경비코드"/>'		, type: 'string', allowBlank:false},
			{name: 'CHARGE_NAME'		, text: '<t:message code="system.label.trade.expensename" default="경비명"/>'		, type: 'string', allowBlank:false},
			{name: 'CUST_CODE'			, text: '지급처'		, type: 'string', allowBlank: false},
			{name: 'CUSTOM_NAME'		, text: '지급처명'		, type: 'string', allowBlank: false},
			{name: 'VAT_CUSTOM'			, text: '공급처'		, type: 'string'},
			{name: 'VAT_CUSTOM_NAME'	, text: '공급처명'		, type: 'string'},
			{name: 'OCCUR_DATE'			, text: '발생일자'		, type: 'uniDate', allowBlank: false},
			{name: 'CHARGE_AMT'			, text: '경비금액'		, type: 'uniFC', allowBlank: true},
			{name: 'AMT_UNIT'			, text: '<t:message code="system.label.trade.currency" default="화폐 "/>'			, type: 'string',comboType:'AU',comboCode:'B004', displayField: 'value', allowBlank: false},
			{name: 'EXCHANGE_RATE'		, text: '<t:message code="system.label.trade.exchangerate" default="환율"/>'		, type: 'uniER', allowBlank: false},
			{name: 'CHARGE_AMT_WON'		, text: '원화금액'		, type: 'uniPrice', allowBlank: true},
			{name: 'SUPPLY_AMT'			, text: '공급가액'		, type: 'uniPrice', allowBlank: true, editable: false},
			{name: 'TAX_CLS'			, text: '증빙유형'		, type: 'string',comboType: 'AU', comboCode: 'A022', allowBlank: false},
			{name: 'VAT_AMT'			, text: '부가세액'		, type: 'uniPrice', allowBlank: true},
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.trade.division" default="사업장"/>'		, type: 'string'},
			{name: 'VAT_COMP_CODE'		, text: '신고사업장'	, type: 'string',comboType:'BOR120', comboCode:'BILL',storeId:'billDivCode', allowBlank: false},
			{name: 'PAY_TYPE'			, text: '지급유형'		, type: 'string',comboType: 'AU', comboCode: 'T072',allowBlank:false},
			{name: 'SAVE_CODE'			, text: '통장코드'		, type: 'string'},
			{name: 'SAVE_NAME'			, text: '통장명'		, type: 'string'},
			{name: 'BANK_CODE'			, text: '<t:message code="system.label.trade.bankcode" default="은행코드"/>'	, type: 'string'},
			{name: 'BANK_NAME'			, text: '<t:message code="system.label.trade.bankname" default="은행명"/>'		, type: 'string'},
			{name: 'NOTE_NUM'			, text: '어음번호'		, type: 'string'},
			{name: 'EXP_DATE'			, text: '<t:message code="system.label.trade.duedate" default="만기일"/>'		, type: 'uniDate'},
			{name: 'PROJECT_NO'			, text: '프로젝트번호'	, type: 'string'},
			{name: 'PAY_DATE'			, text: '지급예정일'		, type: 'uniDate'},
/*hidden*/  {name: 'REMARKS'			, text: '적요'		, type: 'string'},
			{name: 'OFFER_SER_NO'		, text: '<t:message code="system.label.trade.offerno" default="OFFER 번호 "/>'	, type: 'string'},
			{name: 'LC_SER_NO'			, text: 'LC관리번호'	, type: 'string'},
			{name: 'LC_NO'				, text: 'LC번호'		, type: 'string'},
			{name: 'BL_SER_NO'			, text: 'BL관리번호'	, type: 'string'},
			{name: 'BL_NO'				, text: 'BL번호'		, type: 'string'},
			{name: 'COST_DIV'			, text: '배부대상'		, type: 'string',comboType: 'AU', comboCode: 'T107', allowBlank: false},
			{name: 'EX_DATE'			, text: '<t:message code="system.label.trade.exdate" default="결의일"/>'		, type: 'uniDate', editable: false},	//20200304 수정: 수정 불가
/*hidden*/  {name: 'EX_NUM'				, text: '결의번호'		, type: 'string', editable: false},	//20200304 수정: 수정 불가
			{name: 'AGREE_YN'			, text: '승인여부'		, type: 'string', editable: false},	//20200304 수정: 수정 불가
/*hidden*/  {name: 'update_db_user'		, text: '수정자'		, type: 'string'},
			{name: 'update_db_time'		, text: '수정일'		, type: 'uniDate'},
			{name: 'COMP_CODE'			, text: 'COMP_CODE'	, type: 'string'},
			{name: 'TAX_RATE'			, text: 'TAX_RATE'	, type: 'uniPrice'},
			//20191120 총지급액 컬럼 추가
			{name: 'SUPPLY_TOTAL_AMT'	, text: '총지급액'		, type: 'uniPrice', allowBlank: false}
		]
	});

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'tix100ukrvService.selectList',
			update	: 'tix100ukrvService.update',
			syncAll	: 'tix100ukrvService.saveAll',
			create	: 'tix100ukrvService.insert',
			destroy	: 'tix100ukrvService.delete'
		}
	});

	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('tix100ukrvMasterStore1', {
		model	: 'tix100ukrvModel',
		proxy	: directProxy ,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결
			editable	: true,		// 수정 모드 사용
			deletable	: true,		// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		autoLoad: false,
		saveStore: function() {
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			var toCreate = this.getNewRecords();
			var toUpdate = this.getUpdatedRecords();
			var toDelete = this.getRemovedRecords();
			var list = [].concat(toUpdate, toCreate);
			console.log("list:", list);
			var paramMaster= panelSearch.getValues();	//syncAll 수정
			if(inValidRecs.length == 0) {
				config = {
					params	: [paramMaster],
					success	: function(batch, option) {
						var master = batch.operations[0].getResultSet();
						panelSearch.getForm().wasDirty = false;
						panelSearch.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);
						//20191120 저장 후 재조회로직 주석
//						if (directMasterStore1.count() == 0) {
//							UniAppManager.app.onResetButtonDown();
//						} else {
//							directMasterStore1.loadStoreRecords();
//						}
					 }
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('tix100ukrvGrid1');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		loadStoreRecords: function(){
			var param = Ext.getCmp('searchForm').getValues();
			/*var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
			var deptCode = UserInfo.deptCode;	//부서코드
			if(authoInfo == "5" && Ext.isEmpty(Ext.getCmp('searchForm').getValue('DEPT_CODE'))){
				param.DEPT_CODE = deptCode;
			}*/
			console.log( param );
			this.load({
				params: param
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				console.log( "records.length:" ,records.length);
				if(records.length>0){
					//UniAppManager.setToolbarButtons('deleteAll',true);
					//20191120 주석: 그리드 summary 사용
//					this.charget_amtSUM();
				}
			},
			add: function(store, records, index, eOpts) {
				//20191120 주석: 그리드 summary 사용
//				this.charget_amtSUM();
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
				//20191120 주석: 그리드 summary 사용
//				this.charget_amtSUM();
			},
			remove: function(store, record, index, isMove, eOpts) {
				//20191120 주석: 그리드 summary 사용
//				this.charget_amtSUM();
			}
		},
//		//20191120 주석: 그리드 summary 사용
//		charget_amtSUM:function(){
//			var charge_amt = Ext.isNumeric(this.sum('CHARGE_AMT')) ? this.sum('CHARGE_AMT'):0; // 재고단위금액
//			var vat_amt = Ext.isNumeric(this.sum('VAT_AMT')) ? this.sum('VAT_AMT'):0;	// 자사금액(재고)
//
//			panelResult2.setValue("charge_amt",charge_amt);
//			panelResult2.setValue("vat_amt",vat_amt);
//		},
		groupField: ''
	});

	/** 검색조건 (Search Panel)
	 * @type
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '<t:message code="system.label.trade.searchconditon" default="검색조건"/>',
		defaultType: 'uniSearchSubPanel',
		collapsed: UserInfo.appOption.collapseLeftSearch,
		listeners: {
			collapse: function () {
				panelResult.show();
			},
			expand: function() {
				panelResult.hide();
			}
		},
		items: [{
			title: '<t:message code="system.label.trade.basisinfo" default="기본정보"/>',
				itemId: 'search_panel1',
				layout: {type: 'uniTable', columns: 1},
				defaultType: 'uniTextfield',
				defaults: {holdable: 'hold'},
			items: [
				{
				fieldLabel: '<t:message code="system.label.trade.shipmentdate" default="선적일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'FRORDERDATE',
				endFieldName: 'TOORDERDATE',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				allowBlank: false,
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('FRORDERDATE',newValue);
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('TOORDERDATE',newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.trade.division" default="사업장"/>',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				allowBlank: false,
				value:UserInfo.divCode,
				listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('DIV_CODE', newValue);
						}
					}
			},{

				name: 'TRADE_DIV',
				xtype: 'uniTextfield',
				hidden:true,
				value:'I',
				listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('TRADE_DIV', newValue);
						}
					}
			},{
				fieldLabel: '진행구분',
				name: 'CHARGE_TYPE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'T071',
				listeners: {
//					blur: function( field, The, eOpts ){
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('CHARGE_TYPE', newValue);
						var charge_type= panelResult.getValue("CHARGE_TYPE");
						panelResult.setValue('BASIC_PAPER_NO', '');
						if(Ext.isEmpty(charge_type)){
//							alert("진행구분을 선택 하세요.");
							panelResult.getField('BASIC_PAPER_NO').show();
							Ext.getCmp('INCOM_OFFER2').setVisible(false);
							Ext.getCmp('INCOM_BL2').setVisible(false);
							Ext.getCmp('PASS_INCOM_NO2').setVisible(false);
							Ext.getCmp('NEGO_INCOM_NO2').setVisible(false);

							Ext.getCmp('INCOM_OFFER').setVisible(false);
							Ext.getCmp('INCOM_BL').setVisible(false);
							Ext.getCmp('PASS_INCOM_NO').setVisible(false);
							Ext.getCmp('NEGO_INCOM_NO').setVisible(false);
						} else {
							switch(charge_type){
								case "O": //수입OFFER
									panelResult.getField('BASIC_PAPER_NO').setVisible(false);
									Ext.getCmp('INCOM_OFFER2').setVisible(true);
									Ext.getCmp('INCOM_BL2').setVisible(false);
									Ext.getCmp('PASS_INCOM_NO2').setVisible(false);
									Ext.getCmp('NEGO_INCOM_NO2').setVisible(false);

									Ext.getCmp('INCOM_OFFER').setVisible(true);
									Ext.getCmp('INCOM_BL').setVisible(false);
									Ext.getCmp('PASS_INCOM_NO').setVisible(false);
									Ext.getCmp('NEGO_INCOM_NO').setVisible(false);
								break;
								case "B": //B/L선적
									panelResult.getField('BASIC_PAPER_NO').setVisible(false);
									Ext.getCmp('INCOM_OFFER2').setVisible(false);
									Ext.getCmp('INCOM_BL2').setVisible(true);
									Ext.getCmp('PASS_INCOM_NO2').setVisible(false);
									Ext.getCmp('NEGO_INCOM_NO2').setVisible(false);

									Ext.getCmp('INCOM_OFFER').setVisible(false);
									Ext.getCmp('INCOM_BL').setVisible(true);
									Ext.getCmp('PASS_INCOM_NO').setVisible(false);
									Ext.getCmp('NEGO_INCOM_NO').setVisible(false);
								break;
								case "P": //수입통관
									panelResult.getField('BASIC_PAPER_NO').setVisible(false);
									Ext.getCmp('INCOM_OFFER2').setVisible(false);
									Ext.getCmp('INCOM_BL2').setVisible(false);
									Ext.getCmp('PASS_INCOM_NO2').setVisible(true);
									Ext.getCmp('NEGO_INCOM_NO2').setVisible(false);

									Ext.getCmp('INCOM_OFFER').setVisible(false);
									Ext.getCmp('INCOM_BL').setVisible(false);
									Ext.getCmp('PASS_INCOM_NO').setVisible(true);
									Ext.getCmp('NEGO_INCOM_NO').setVisible(false);
								break;
								case "S": //수입대금
									panelResult.getField('BASIC_PAPER_NO').setVisible(false);
									Ext.getCmp('INCOM_OFFER2').setVisible(false);
									Ext.getCmp('INCOM_BL2').setVisible(false);
									Ext.getCmp('PASS_INCOM_NO2').setVisible(false);
									Ext.getCmp('NEGO_INCOM_NO2').setVisible(true);

									Ext.getCmp('INCOM_OFFER').setVisible(false);
									Ext.getCmp('INCOM_BL').setVisible(false);
									Ext.getCmp('PASS_INCOM_NO').setVisible(false);
									Ext.getCmp('NEGO_INCOM_NO').setVisible(true);
								break;
							}
						}
					}
				}
			},{
				fieldLabel: '근거번호',
				name: 'BASIC_PAPER_NO',
				xtype: 'uniTextfield',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('BASIC_PAPER_NO', newValue);
					}
				}
			},Unilite.popup('INCOM_OFFER', {	 //수입 OFFER 관리번호
				fieldLabel: '근거번호',
				id: 'INCOM_OFFER',
				textFieldName: 'INCOM_OFFER',
				popupWidth: 710,
				hidden: true,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							console.log('records : ', records);
							panelResult.setValue('TRADE_CUSTOM_CODE',	records[0]["EXPORTER"]);
							panelResult.setValue('TRADE_CUSTOM_NAME',	records[0]["EXPORTERNM"]);
							panelSearch.setValue('TRADE_CUSTOM_CODE',	records[0]["EXPORTER"]);
							panelSearch.setValue('TRADE_CUSTOM_NAME',	records[0]["EXPORTERNM"]);
							panelResult.setValue('INCOM_OFFER2',		records[0]["OFFER_NO"]);
						},
						scope: this
					},
					onClear: function(type) {
						panelSearch.setValue('TRADE_CUSTOM_CODE',	'');
						panelSearch.setValue('TRADE_CUSTOM_NAME',	'');
						panelResult.setValue('TRADE_CUSTOM_CODE',	'');
						panelResult.setValue('TRADE_CUSTOM_NAME',	'');
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE':  panelSearch.getValue('DIV_CODE')});
					}
				}
			})
			,Unilite.popup('INCOM_BL', {		//수입 B/L 관리번호
				fieldLabel: '근거번호',
				id: 'INCOM_BL',
				textFieldName: 'INCOM_BL',
				hidden: true,
				popupWidth: 710,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							console.log('records : ', records);

							panelResult.setValue('TRADE_CUSTOM_CODE',	records[0]["EXPORTER"]);
							panelResult.setValue('TRADE_CUSTOM_NAME',	records[0]["EXPORTER_NM"]);
							panelSearch.setValue('TRADE_CUSTOM_CODE',	records[0]["EXPORTER"]);
							panelSearch.setValue('TRADE_CUSTOM_NAME',	records[0]["EXPORTER_NM"]);
							panelResult.setValue('INCOM_BL2',			records[0]["BL_SER_NO"]);
						},
						scope: this
					},
					onClear: function(type) {
						panelSearch.setValue('TRADE_CUSTOM_CODE',	'');
						panelSearch.setValue('TRADE_CUSTOM_NAME',	'');
						panelResult.setValue('TRADE_CUSTOM_CODE',	'');
						panelResult.setValue('TRADE_CUSTOM_NAME',	'');
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE':  panelResult.getValue('DIV_CODE')});
					}
				}
			})
			 ,Unilite.popup('PASS_INCOM_NO', {	//수입통관 관리번호
				fieldLabel: '근거번호',
				id: 'PASS_INCOM_NO',
				textFieldName: 'PASS_INCOM_NO',
				hidden: true,
				popupWidth: 710,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							console.log('records : ', records);

							panelResult.setValue('TRADE_CUSTOM_CODE',	records[0]["EXPORTER"]);
							panelResult.setValue('TRADE_CUSTOM_NAME',	records[0]["EXPORTER_NM"]);
							panelSearch.setValue('TRADE_CUSTOM_CODE',	records[0]["EXPORTER"]);
							panelSearch.setValue('TRADE_CUSTOM_NAME',	records[0]["EXPORTER_NM"]);
							panelResult.setValue('PASS_INCOM_NO2',	  records[0]["PASS_INCOM_NO"]);
						},
						scope: this
					},
					onClear: function(type) {
						panelSearch.setValue('TRADE_CUSTOM_CODE',	'');
						panelSearch.setValue('TRADE_CUSTOM_NAME',	'');
						panelResult.setValue('TRADE_CUSTOM_CODE',	'');
						panelResult.setValue('TRADE_CUSTOM_NAME',	'');
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE':  panelResult.getValue('DIV_CODE')});
					}
				}
			})
			,Unilite.popup('NEGO_INCOM_NO', {	//수입대금 관리번호
				fieldLabel: '근거번호',
				id: 'NEGO_INCOM_NO',
				textFieldName: 'NEGO_INCOM_NO',
				hidden: true,
				popupWidth: 710,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							console.log('records : ', records);

							panelResult.setValue('TRADE_CUSTOM_CODE',	records[0]["EXPORTER"]);
							panelResult.setValue('TRADE_CUSTOM_NAME',	records[0]["EXPORTER_NM"]);
							panelSearch.setValue('TRADE_CUSTOM_CODE',	records[0]["EXPORTER"]);
							panelSearch.setValue('TRADE_CUSTOM_NAME',	records[0]["EXPORTER_NM"]);
							panelResult.setValue('PASS_INCOM_NO2',	  records[0]["NEGO_INCOM_NO"]);
						},
						scope: this
					},
					onClear: function(type) {
						panelSearch.setValue('TRADE_CUSTOM_CODE',	'');
						panelSearch.setValue('TRADE_CUSTOM_NAME',	'');
						panelResult.setValue('TRADE_CUSTOM_CODE',	'');
						panelResult.setValue('TRADE_CUSTOM_NAME',	'');
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE':  panelResult.getValue('DIV_CODE')});
					}
				}
			})
			,Unilite.popup('CUST', {
					fieldLabel: '<t:message code="system.label.trade.exporter" default="수출자"/>',
					valueFieldName: 'TRADE_CUSTOM_CODE',
					textFieldName: 'TRADE_CUSTOM_NAME',
					validateBlank:false,
					popupWidth: 710,
					listeners: {
								onValueFieldChange:function( elm, newValue, oldValue) {						
									panelResult.setValue('TRADE_CUSTOM_CODE', newValue);
									
									if(!Ext.isObject(oldValue)) {
										panelResult.setValue('TRADE_CUSTOM_NAME', '');
										panelSearch.setValue('TRADE_CUSTOM_NAME', '');
									}
								},
								onTextFieldChange:function( elm, newValue, oldValue) {
									panelResult.setValue('TRADE_CUSTOM_NAME', newValue);
									
									if(!Ext.isObject(oldValue)) {
										panelResult.setValue('TRADE_CUSTOM_CODE', '');
										panelSearch.setValue('TRADE_CUSTOM_CODE', '');
									}
								}
					}
				})
			,Unilite.popup('EXPENSE', {
					fieldLabel: '<t:message code="system.label.trade.expensecode" default="경비코드"/>',
					valueFieldName: 'CHARGE_CODE',
					textFieldName: 'CHARGE_NAME',
					validateBlank:false,
					autoPopup: true,
					popupWidth: 710,
					listeners: {
						//20200224 수정
						onValueFieldChange: function(field, newValue){
							panelResult.setValue('CHARGE_CODE', newValue);
						},
						onTextFieldChange: function(field, newValue){
							panelResult.setValue('CHARGE_NAME', newValue);
						}
//						onSelected: {
//						fn: function(records, type) {
//							panelResult.setValue('CHARGE_CODE', panelSearch.getValue('CHARGE_CODE'));
//							panelResult.setValue('CHARGE_NAME', panelSearch.getValue('CHARGE_NAME'));
//						}
//						}
					}
				})
			,Unilite.popup('CUST', {
					fieldLabel: '지급처',
					valueFieldName: 'CUST_CODE',
					textFieldName: 'CUST_NAME',
					validateBlank:false,
					popupWidth: 710,
					extParam: {'CUSTOM_TYPE': ['1','2']},
					listeners: {
							onValueFieldChange:function( elm, newValue, oldValue) {						
								panelResult.setValue('CUST_CODE', newValue);
								
								if(!Ext.isObject(oldValue)) {
									panelResult.setValue('CUST_NAME', '');
									panelSearch.setValue('CUST_NAME', '');
								}
							},
							onTextFieldChange:function( elm, newValue, oldValue) {
								panelResult.setValue('CUST_NAME', newValue);
								
								if(!Ext.isObject(oldValue)) {
									panelResult.setValue('CUST_CODE', '');
									panelSearch.setValue('CUST_CODE', '');
								}
							}
					}
				})
			]
		},{
			title:'추가정보',
			id: 'search_panel2',
			itemId:'search_panel2',
			defaultType: 'uniTextfield',
			layout: {type: 'uniTable', columns: 1},
			defaults: {holdable: 'hold'},
			items:[
				{
				fieldLabel: '지급유형',
				name: 'PAY_TYPE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'T072'
				},{
				fieldLabel: '관리번호',
				name: 'PROJECT_NO',
				xtype: 'uniTextfield'
				},
				{
				fieldLabel: '결의일자',
				xtype: 'uniDatefield',
				name: 'EX_DATE'
				},{
				fieldLabel: '번호',
				name: 'EX_NUM',
				xtype: 'uniTextfield'
				},
				{
					fieldLabel: '승인여부',
					xtype: 'uniCombobox',
					comboType: 'AU',
					comboCode: 'A014'
				}]
		},{
                xtype: 'radiogroup',
                fieldLabel: '자동기표여부',
                items : [{
                    boxLabel: '전체',
                    name: 'GUBUN' ,
                    inputValue: '',
                    width:50

                }, {boxLabel: '미기표',
                    name: 'GUBUN',
                    inputValue: 'N',
                    width:85,
                    checked: true
                }, {boxLabel: '기표',
                    name: 'GUBUN',
                    inputValue: 'Y',
                    width:85
                }],
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                            panelResult.getField('GUBUN').setValue(newValue.GUBUN);
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
//					  var labelText = ''
//
//					  if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
//						  var labelText = invalid.items[0]['fieldLabel']+'은(는)';
//					  } else if(Ext.isDefined(invalid.items[0].ownerCt)) {
//						  var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
//					  }
//
//					  alert(labelText+Msg.sMB083);
					invalid.items[0].focus();
				} else {
					//this.mask();
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) )	{
							if (item.holdable == 'hold') {
								item.setReadOnly(true);
							}
						}
						if(item.isPopupField)	{
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
					if(Ext.isDefined(item.holdable) )	{
						if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					}
					if(item.isPopupField)	{
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

	var panelResult = Unilite.createSearchForm('tix100ukrvresultForm',{
		//20191120 주석
//		title	: '<t:message code="system.label.trade.searchconditon" default="검색조건"/>',
		region: 'north',
		hidden: !UserInfo.appOption.collapseLeftSearch,
		layout : {type : 'uniTable', columns : 4, tableAttrs:{width:"100%", border:0}},
		padding:'1 1 1 1',
		border:true,
		defaults: {holdable: 'hold'},
		items: [{
			fieldLabel: '<t:message code="system.label.trade.shipmentdate" default="선적일"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'FRORDERDATE',
			endFieldName: 'TOORDERDATE',
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today'),
			allowBlank: false,
			width: 315,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('FRORDERDATE',newValue);
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('TOORDERDATE',newValue);
				}
			}
		},{
				fieldLabel: '<t:message code="system.label.trade.division" default="사업장"/>',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				allowBlank: false,
				value:UserInfo.divCode,
				listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelSearch.setValue('DIV_CODE', newValue);
						}
					}
			},{

				name: 'TRADE_DIV',
				xtype: 'uniTextfield',
				value:'I',
				hidden:true,
				listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelSearch.setValue('TRADE_DIV', newValue);
						}
					}
			},{
                xtype: 'radiogroup',
                fieldLabel: '자동기표여부',
                items : [{
                    boxLabel: '전체',
                    name: 'GUBUN' ,
                    inputValue: '',
                    width:70
                }, {boxLabel: '미기표',
                    name: 'GUBUN',
                    inputValue: 'N',
                    width:85,
                    checked: true
                }, {boxLabel: '기표',
                    name: 'GUBUN',
                    inputValue: 'Y',
                    width:85
                }],
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                            panelSearch.getField('GUBUN').setValue(newValue.GUBUN);
                    }
                }
            },{
				xtype : 'container'	,
				layout:{type:'uniTable', columns:2},
				tdAttrs:{align:'right'},
				items:[{
					text: '경비자동기표',
					xtype:'button',
					itemId : 'autoSlip63Btn',
					disabled: false,
					tdAttrs:{align:'right', 'margin-right':'5px'},
					handler: function() {
						var needSave = !UniAppManager.app.getTopToolbar().getComponent('save').isDisabled();
						if(needSave) {
							Ext.Msg.show({
								 title:'확인',
								 msg: Msg.sMB017 + "\n" + Msg.sMB061,
								 buttons: Ext.Msg.YESNOCANCEL,
								 icon: Ext.Msg.QUESTION,
								 fn: function(res) {
									//console.log(res);
									if (res === 'yes' ) {
										var saveTask =  Ext.create('Ext.util.DelayedTask', function(){
											UniAppManager.app.onSaveDataButtonDown()
										});
										saveTask.delay(500);
									} else if(res === 'no') {
										UniAppManager.app.fnAutoSlip()

									}
								 }
							})
						} else {
							setTimeout(function(){
								UniAppManager.app.fnAutoSlip()
							}
							, 500
							)

					}	}
				},{
					text: '<t:message code="system.label.trade.slipcancel" default="기표취소"/>',
					xtype:'button',
					itemId : 'autoSlip63CancelBtn',
					tdAttrs:{'margin-right':'10px'},
					disabled: true,
					handler: function() {
						UniAppManager.app.fnAutoSlipCancel();

					}
				}]
			},{
				fieldLabel: '진행구분',
				name: 'CHARGE_TYPE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'T071',
				listeners: {
//					blur: function( field, The, eOpts ){
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('CHARGE_TYPE', newValue);
						var charge_type= panelResult.getValue("CHARGE_TYPE");
						panelResult.setValue('BASIC_PAPER_NO', '');
						if(Ext.isEmpty(charge_type)){
//							alert("진행구분을 선택 하세요.");
							panelSearch.getField('BASIC_PAPER_NO').show();
							Ext.getCmp('INCOM_OFFER2').setVisible(false);
							Ext.getCmp('INCOM_BL2').setVisible(false);
							Ext.getCmp('PASS_INCOM_NO2').setVisible(false);
							Ext.getCmp('NEGO_INCOM_NO2').setVisible(false);

							Ext.getCmp('INCOM_OFFER').setVisible(false);
							Ext.getCmp('INCOM_BL').setVisible(false);
							Ext.getCmp('PASS_INCOM_NO').setVisible(false);
							Ext.getCmp('NEGO_INCOM_NO').setVisible(false);
						} else {
							switch(charge_type){
								case "O": //수입OFFER
									panelSearch.getField('BASIC_PAPER_NO').setVisible(false);
									Ext.getCmp('INCOM_OFFER2').setVisible(true);
									Ext.getCmp('INCOM_BL2').setVisible(false);
									Ext.getCmp('PASS_INCOM_NO2').setVisible(false);
									Ext.getCmp('NEGO_INCOM_NO2').setVisible(false);

									Ext.getCmp('INCOM_OFFER').setVisible(true);
									Ext.getCmp('INCOM_BL').setVisible(false);
									Ext.getCmp('PASS_INCOM_NO').setVisible(false);
									Ext.getCmp('NEGO_INCOM_NO').setVisible(false);
								break;
								case "B": //B/L선적
									panelSearch.getField('BASIC_PAPER_NO').setVisible(false);
									Ext.getCmp('INCOM_OFFER2').setVisible(false);
									Ext.getCmp('INCOM_BL2').setVisible(true);
									Ext.getCmp('PASS_INCOM_NO2').setVisible(false);
									Ext.getCmp('NEGO_INCOM_NO2').setVisible(false);

									Ext.getCmp('INCOM_OFFER').setVisible(false);
									Ext.getCmp('INCOM_BL').setVisible(true);
									Ext.getCmp('PASS_INCOM_NO').setVisible(false);
									Ext.getCmp('NEGO_INCOM_NO').setVisible(false);
								break;
								case "P": //수입통관
									panelSearch.getField('BASIC_PAPER_NO').setVisible(false);
									Ext.getCmp('INCOM_OFFER2').setVisible(false);
									Ext.getCmp('INCOM_BL2').setVisible(false);
									Ext.getCmp('PASS_INCOM_NO2').setVisible(true);
									Ext.getCmp('NEGO_INCOM_NO2').setVisible(false);

									Ext.getCmp('INCOM_OFFER').setVisible(false);
									Ext.getCmp('INCOM_BL').setVisible(false);
									Ext.getCmp('PASS_INCOM_NO').setVisible(true);
									Ext.getCmp('NEGO_INCOM_NO').setVisible(false);
								break;
								case "S": //수입대금
									panelSearch.getField('BASIC_PAPER_NO').setVisible(false);
									Ext.getCmp('INCOM_OFFER2').setVisible(false);
									Ext.getCmp('INCOM_BL2').setVisible(false);
									Ext.getCmp('PASS_INCOM_NO2').setVisible(false);
									Ext.getCmp('NEGO_INCOM_NO2').setVisible(true);

									Ext.getCmp('INCOM_OFFER').setVisible(false);
									Ext.getCmp('INCOM_BL').setVisible(false);
									Ext.getCmp('PASS_INCOM_NO').setVisible(false);
									Ext.getCmp('NEGO_INCOM_NO').setVisible(true);
								break;
							}
						}
					}
				}
			},{
				fieldLabel: '근거번호',
				name: 'BASIC_PAPER_NO',
				xtype: 'uniTextfield',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('BASIC_PAPER_NO', newValue);
					}
				}
			},Unilite.popup('INCOM_OFFER', {	 //수입 OFFER 관리번호
				fieldLabel: '근거번호',
				id: 'INCOM_OFFER2',
				textFieldName: 'INCOM_OFFER2',
				popupWidth: 710,
				hidden: true,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							console.log('records : ', records);

							panelResult.setValue('TRADE_CUSTOM_CODE',	records[0]["EXPORTER"]);
							panelResult.setValue('TRADE_CUSTOM_NAME',	records[0]["EXPORTERNM"]);
							panelSearch.setValue('TRADE_CUSTOM_CODE',	records[0]["EXPORTER"]);
							panelSearch.setValue('TRADE_CUSTOM_NAME',	records[0]["EXPORTERNM"]);
							panelSearch.setValue('INCOM_OFFER',		 records[0]["OFFER_NO"]);
							panelResult.setValue('OFFER_SER_NO',	records[0]["OFFER_NO"]);
						},
						scope: this
					},
					onClear: function(type) {
						panelSearch.setValue('TRADE_CUSTOM_CODE',	'');
						panelSearch.setValue('TRADE_CUSTOM_NAME',	'');
						panelResult.setValue('TRADE_CUSTOM_CODE',	'');
						panelResult.setValue('TRADE_CUSTOM_NAME',	'');
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE':  panelResult.getValue('DIV_CODE')});
					}
				}
			})
			,Unilite.popup('INCOM_BL', {		//수입 B/L 관리번호
				fieldLabel: '근거번호',
				id: 'INCOM_BL2',
				textFieldName: 'INCOM_BL2',
				hidden: true,
				popupWidth: 710,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							console.log('records : ', records);

							panelResult.setValue('TRADE_CUSTOM_CODE',	records[0]["EXPORTER"]);
							panelResult.setValue('TRADE_CUSTOM_NAME',	records[0]["EXPORTER_NM"]);
							panelSearch.setValue('TRADE_CUSTOM_CODE',	records[0]["EXPORTER"]);
							panelSearch.setValue('TRADE_CUSTOM_NAME',	records[0]["EXPORTER_NM"]);
							panelSearch.setValue('INCOM_BL',			records[0]["BL_SER_NO"]);
							panelResult.setValue('OFFER_SER_NO',	records[0]["SO_SER_NO"]);
						},
						scope: this
					},
					onClear: function(type) {
						panelSearch.setValue('TRADE_CUSTOM_CODE',	'');
						panelSearch.setValue('TRADE_CUSTOM_NAME',	'');
						panelResult.setValue('TRADE_CUSTOM_CODE',	'');
						panelResult.setValue('TRADE_CUSTOM_NAME',	'');
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE':  panelResult.getValue('DIV_CODE')});
					}
				}
			})
			,Unilite.popup('PASS_INCOM_NO', {	//수입통관 관리번호
				fieldLabel: '근거번호',
				id: 'PASS_INCOM_NO2',
				textFieldName: 'PASS_INCOM_NO2',
				hidden: true,
				popupWidth: 710,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							console.log('records : ', records);

							panelResult.setValue('TRADE_CUSTOM_CODE',	records[0]["EXPORTER"]);
							panelResult.setValue('TRADE_CUSTOM_NAME',	records[0]["EXPORTER_NM"]);
							panelSearch.setValue('TRADE_CUSTOM_CODE',	records[0]["EXPORTER"]);
							panelSearch.setValue('TRADE_CUSTOM_NAME',	records[0]["EXPORTER_NM"]);
							panelSearch.setValue('PASS_INCOM_NO',		records[0]["PASS_INCOM_NO"]);
							panelResult.setValue('OFFER_SER_NO',	records[0]["SO_SER_NO"]);
						},
						scope: this
					},
					onClear: function(type) {
						panelSearch.setValue('TRADE_CUSTOM_CODE',	'');
						panelSearch.setValue('TRADE_CUSTOM_NAME',	'');
						panelResult.setValue('TRADE_CUSTOM_CODE',	'');
						panelResult.setValue('TRADE_CUSTOM_NAME',	'');
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE':  panelResult.getValue('DIV_CODE')});
					}
				}
			})
			,Unilite.popup('NEGO_INCOM_NO', {	//수입대금 관리번호
				fieldLabel: '근거번호',
				id: 'NEGO_INCOM_NO2',
				textFieldName: 'NEGO_INCOM_NO2',
				hidden: true,
				popupWidth: 710,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							console.log('records : ', records);

							panelResult.setValue('TRADE_CUSTOM_CODE',	records[0]["EXPORTER"]);
							panelResult.setValue('TRADE_CUSTOM_NAME',	records[0]["EXPORTER_NM"]);
							panelSearch.setValue('TRADE_CUSTOM_CODE',	records[0]["EXPORTER"]);
							panelSearch.setValue('TRADE_CUSTOM_NAME',	records[0]["EXPORTER_NM"]);
							panelSearch.setValue('PASS_INCOM_NO',		records[0]["NEGO_INCOM_NO"]);
						},
						scope: this
					},
					onClear: function(type) {
						panelSearch.setValue('TRADE_CUSTOM_CODE',	'');
						panelSearch.setValue('TRADE_CUSTOM_NAME',	'');
						panelResult.setValue('TRADE_CUSTOM_CODE',	'');
						panelResult.setValue('TRADE_CUSTOM_NAME',	'');
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE':  panelResult.getValue('DIV_CODE')});
					}
				}
			}),{
                fieldLabel: 'OFFER 번호',
                name:'OFFER_SER_NO',
                xtype: 'uniTextfield',
                colspan: 2,
                hidden: false
            }
			,Unilite.popup('CUST', {
					fieldLabel: '<t:message code="system.label.trade.exporter" default="수출자"/>',
					valueFieldName: 'TRADE_CUSTOM_CODE',
					textFieldName: 'TRADE_CUSTOM_NAME',
					validateBlank:false,
					popupWidth: 710,
					listeners: {
								onValueFieldChange:function( elm, newValue, oldValue) {						
									panelSearch.setValue('TRADE_CUSTOM_CODE', newValue);
									
									if(!Ext.isObject(oldValue)) {
										panelResult.setValue('TRADE_CUSTOM_NAME', '');
										panelSearch.setValue('TRADE_CUSTOM_NAME', '');
									}
								},
								onTextFieldChange:function( elm, newValue, oldValue) {
									panelSearch.setValue('TRADE_CUSTOM_NAME', newValue);
									
									if(!Ext.isObject(oldValue)) {
										panelResult.setValue('TRADE_CUSTOM_CODE', '');
										panelSearch.setValue('TRADE_CUSTOM_CODE', '');
									}
								}
					}
				})
			,Unilite.popup('EXPENSE', {
					fieldLabel: '<t:message code="system.label.trade.expensecode" default="경비코드"/>',
					valueFieldName: 'CHARGE_CODE',
					textFieldName: 'CHARGE_NAME',
					validateBlank:false,
					popupWidth: 710,
					listeners: {
						//20200224 수정
						onValueFieldChange: function(field, newValue){
							panelSearch.setValue('CHARGE_CODE', newValue);
						},
						onTextFieldChange: function(field, newValue){
							panelSearch.setValue('CHARGE_NAME', newValue);
						}
//						onSelected: {
//						fn: function(records, type) {
//							panelSearch.setValue('CHARGE_CODE', panelResult.getValue('CHARGE_CODE'));
//							panelSearch.setValue('CHARGE_NAME', panelResult.getValue('CHARGE_NAME'));
//						}
//						}
					}
				})
			,Unilite.popup('CUST', {
				fieldLabel: '지급처',
				valueFieldName: 'CUST_CODE',
				textFieldName: 'CUST_NAME',
				validateBlank:false,
				popupWidth: 710,
				colspan :2,
				extParam: {'CUSTOM_TYPE': ['1','2']},
				listeners: {
					onValueFieldChange:function( elm, newValue, oldValue) {						
						panelSearch.setValue('CUST_CODE', newValue);
						
						if(!Ext.isObject(oldValue)) {
							panelResult.setValue('CUST_NAME', '');
							panelSearch.setValue('CUST_NAME', '');
						}
					},
					onTextFieldChange:function( elm, newValue, oldValue) {
						panelSearch.setValue('CUST_NAME', newValue);
						
						if(!Ext.isObject(oldValue)) {
							panelResult.setValue('CUST_CODE', '');
							panelSearch.setValue('CUST_CODE', '');
						}
					}
				}
			})
		],
		setAllFieldsReadOnly: function(b) {
			var r= true
			if(b) {
				var invalid = this.getForm().getFields().filterBy(function(field) {
																	return !field.validate();
																});
				if(invalid.length > 0) {
					r=false;
//					  var labelText = ''
//
//					  if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
//						  var labelText = invalid.items[0]['fieldLabel']+'은(는)';
//					  } else if(Ext.isDefined(invalid.items[0].ownerCt)) {
//						  var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
//					  }
//
//					  alert(labelText+Msg.sMB083);
					invalid.items[0].focus();
				} else {
					//this.mask();
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) )	{
							if (item.holdable == 'hold') {
								item.setReadOnly(true);
							}
						}
						if(item.isPopupField)	{
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
					if(Ext.isDefined(item.holdable) )	{
						if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					}
					if(item.isPopupField)	{
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



	//20191120 주석: 그리드 summary 사용
	/** 金额合计panel
	 */
/*	var panelResult2 = Unilite.createSearchForm('resultForm',{
		region: 'south',
		items: [{
			xtype:'container',
			padding:'0 5 5 5',
			defaultType: 'uniTextfield',
			layout: {
				type: 'uniTable',
				columns : 2,
				tableAttrs: {align:'right'}
			},
			items: [{
				fieldLabel: '<t:message code="system.label.trade.localamounttotal" default="원화금액합계"/>',
				name:'charge_amt',
				xtype: 'uniNumberfield',
				readOnly: true
			},{
					fieldLabel: '세액합계',
					name:'vat_amt',
					xtype: 'uniNumberfield',
				readOnly: true
			}]
		}]
	});*/



	/** Master Grid1 정의(Grid Panel)
	 * @type
	 */
	var masterGrid = Unilite.createGrid('tix100ukrvGrid1', {
		store		: directMasterStore1,
		layout		: 'fit',
		region		: 'center',
		excelTitle	: '발주현황조회',
		uniOpt		: {
			expandLastColumn: false,
			useRowNumberer	: false,
			useContextMenu	: true,
			useLiveSearch	: true
		},
		features: [{
			id				: 'masterGridSubTotal',
			ftype			: 'uniGroupingsummary',
			showSummaryRow	: false
		},{
			//20191120: 그리드 합계 사용 - 원화금액, 부가세액
			id				: 'masterGridTotal',
			ftype			: 'uniSummary',
			showSummaryRow	: true
		}],
		columns: [
			//20200318 수정: trade_div ~ charge_name lock: true -> false로 변경 (그리드 search기능 사용시 오류 발생하여)
			{dataIndex: 'TRADE_DIV'			, width: 80	,hidden: false},
			{dataIndex: 'CHARGE_TYPE'		, width: 100,locked: false},
			{dataIndex: 'CHARGE_SER'		, width: 50	,locked: false	, align: 'center'},
			{dataIndex: 'BASIC_PAPER_NO'	, width: 100,locked: false,
				getEditor: function(record) {
					var record=masterGrid.getSelectedRecord();
					var charge_type= record.get("CHARGE_TYPE");
					var basicPaperNo = record.get('BASIC_PAPER_NO');
					if(charge_type ==null||charge_type==""){
						alert("진행구분을 선택 하세요.")
					} else {
						switch(charge_type){
							case "O":
								return  Ext.create('Ext.grid.CellEditor', {
								ptype: 'cellediting',
								clicksToEdit: 1, // 1 or 2 , 수정 모드로 들어가기 위한 Click 횟수
								autoCancel : false,
								selectOnFocus:true,
								field: Unilite.popup('INCOM_OFFER_G', {
									  autoPopup: true,
									  listeners: {
										  'onSelected': {
											  fn: function(records, type) {
												  console.log('records : ', records);
												  var grdRecord = masterGrid.uniOpt.currentRecord;
												  Ext.each(records, function(record,i) {
													  grdRecord.set('BASIC_PAPER_NO', record['OFFER_NO']);
													  grdRecord.set('DIV_CODE', record['DIV_CODE']);
													  grdRecord.set('PROJECT_NO', record['PROJECT_NO']);
													  grdRecord.set('TRADE_CUSTOM_CODE', record['EXPORTER']);
													  grdRecord.set('TRADE_CUSTOM_NAME', record['EXPORTERNM']);
//													  grdRecord.set('BL_SER_NO', record['OFFER_NO']);
//													  grdRecord.set('BL_NO', record['OFFER_NO']);
//													  grdRecord.set('LC_NO', record['OFFER_NO']);
													  grdRecord.set('OFFER_SER_NO', record['OFFER_NO']);
												  });
											  },
												  scope: this
										  },
										  'onClear': function(type) {
											  var grdRecord = masterGrid.uniOpt.currentRecord;
											  grdRecord.set('BASIC_PAPER_NO', '');
											  grdRecord.set('DIV_CODE', '');
											  grdRecord.set('PROJECT_NO', '');
											  grdRecord.set('BL_SER_NO', '');
											  grdRecord.set('BL_NO', '');
											  grdRecord.set('LC_NO', '');
											  grdRecord.set('OFFER_SER_NO', '');
											  grdRecord.set('TRADE_CUSTOM_CODE', '');
											  grdRecord.set('TRADE_CUSTOM_NAME', '');
										  },
										  applyextparam: function(popup){
//											  popup.setExtParam({'SUB_CODE': 'E3'});
											  popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
										  }
									  }
									})
								});
							break;
							case "B":
								return  Ext.create('Ext.grid.CellEditor', {
								ptype: 'cellediting',
								clicksToEdit: 1, // 1 or 2 , 수정 모드로 들어가기 위한 Click 횟수
								autoCancel : false,
								selectOnFocus:true,
								field: Unilite.popup('INCOM_BL_G', {
									  autoPopup: true,
									  listeners: {
										  'onSelected': {
											  fn: function(records, type) {
												  console.log('records : ', records);
												  var grdRecord = masterGrid.uniOpt.currentRecord;
												  Ext.each(records, function(record,i) {
													  grdRecord.set('BASIC_PAPER_NO', record['BL_SER_NO']);
													  grdRecord.set('DIV_CODE', record['DIV_CODE']);
													  grdRecord.set('PROJECT_NO', record['PROJECT_NO']);
													  grdRecord.set('BL_SER_NO', record['BL_SER_NO']);
													  grdRecord.set('BL_NO', record['BL_NO']);
													  grdRecord.set('LC_NO', record['LC_NO']);
													  grdRecord.set('OFFER_SER_NO', record['SO_SER_NO']);
													  grdRecord.set('TRADE_CUSTOM_CODE', record['EXPORTER']);
													  grdRecord.set('TRADE_CUSTOM_NAME', record['EXPORTER_NM']);
												  });
											  },
												  scope: this
										  },
										  'onClear': function(type) {
											  var grdRecord = masterGrid.uniOpt.currentRecord;
											  grdRecord.set('BASIC_PAPER_NO', '');
											  grdRecord.set('DIV_CODE', '');
											  grdRecord.set('PROJECT_NO', '');
											  grdRecord.set('BL_SER_NO', '');
											  grdRecord.set('BL_NO', '');
											  grdRecord.set('LC_NO', '');
											  grdRecord.set('OFFER_SER_NO', '');
											  grdRecord.set('TRADE_CUSTOM_CODE', '');
											  grdRecord.set('TRADE_CUSTOM_NAME', '');
										  },
										  applyextparam: function(popup){
//											  popup.setExtParam({'SUB_CODE': 'E3'});
											  popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
										  }
									  }
									})
								});
							break;
							case "P":
								//return  Ext.create('Ext.grid.CellEditor', {
								/* ptype: 'cellediting',
								clicksToEdit: 1, // 1 or 2 , 수정 모드로 들어가기 위한 Click 횟수
								autoCancel : false,
								selectOnFocus:true,
								field: Unilite.popup('PASS_INCOM_NO_G', {
									  autoPopup: true,
									  listeners: {
										  'onSelected': {
											  fn: function(records, type) {
												  console.log('records : ', records);
												  var grdRecord = masterGrid.uniOpt.currentRecord;
												  Ext.each(records, function(record,i) {
													  grdRecord.set('BASIC_PAPER_NO', record['PASS_INCOM_NO']);
													  grdRecord.set('DIV_CODE', record['DIV_CODE']);
													  grdRecord.set('PROJECT_NO', record['PROJECT_NO']);
													  grdRecord.set('BL_SER_NO', record['BL_SER_NO']);
													  grdRecord.set('BL_NO', record['BL_NO']);
													  grdRecord.set('LC_NO', record['LC_NO']);
													  grdRecord.set('OFFER_SER_NO', record['SO_SER_NO']);
													  grdRecord.set('TRADE_CUSTOM_CODE', record['EXPORTER']);
													  grdRecord.set('TRADE_CUSTOM_NAME', record['EXPORTER_NM']);
												  });
											  },
												  scope: this
										  },
										  'onClear': function(type) {
											  var grdRecord = masterGrid.uniOpt.currentRecord;
											  grdRecord.set('BASIC_PAPER_NO', '');
											  grdRecord.set('DIV_CODE', '');
											  grdRecord.set('PROJECT_NO', '');
											  grdRecord.set('BL_SER_NO', '');
											  grdRecord.set('BL_NO', '');
											  grdRecord.set('LC_NO', '');
											  grdRecord.set('OFFER_SER_NO', '');
											  grdRecord.set('TRADE_CUSTOM_CODE', '');
											  grdRecord.set('TRADE_CUSTOM_NAME', '');
										  },
										  applyextparam: function(popup){
//											  popup.setExtParam({'SUB_CODE': 'E3'});
											  popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
										  }
									  }
									}) */
									if(Ext.isEmpty(basicPaperNo)){
										openPassInconWindow();
									}
							//	});
							break;
							case "S":
								return  Ext.create('Ext.grid.CellEditor', {
								ptype: 'cellediting',
								clicksToEdit: 1, // 1 or 2 , 수정 모드로 들어가기 위한 Click 횟수
								autoCancel : false,
								selectOnFocus:true,
								field: Unilite.popup('NEGO_INCOM_NO_G', {
									  autoPopup: true,
									  listeners: {
										  'onSelected': {
											  fn: function(records, type) {
												  console.log('records : ', records);
												  var grdRecord = masterGrid.uniOpt.currentRecord;
												  Ext.each(records, function(record,i) {
													  grdRecord.set('BASIC_PAPER_NO', record['NEGO_INCOM_NO']);
													  grdRecord.set('DIV_CODE', record['DIV_CODE']);
													  grdRecord.set('PROJECT_NO', record['PROJECT_NO']);
													  grdRecord.set('TRADE_CUSTOM_CODE', record['EXPORTER']);
													  grdRecord.set('TRADE_CUSTOM_NAME', record['EXPORTER_NM']);
//													  grdRecord.set('BL_SER_NO', record['BL_NO']);
//													  grdRecord.set('BL_NO', record['BL_NO']);
//													  grdRecord.set('LC_NO', record['LC_NO']);
//													  grdRecord.set('OFFER_SER_NO', record['SO_SER_NO']);
												  });
											  },
												  scope: this
										  },
										  'onClear': function(type) {
											  var grdRecord = masterGrid.uniOpt.currentRecord;
											  grdRecord.set('BASIC_PAPER_NO', '');
											  grdRecord.set('DIV_CODE', '');
											  grdRecord.set('PROJECT_NO', '');
											  grdRecord.set('BL_SER_NO', '');
											  grdRecord.set('BL_NO', '');
											  grdRecord.set('LC_NO', '');
											  grdRecord.set('OFFER_SER_NO', '');
											  grdRecord.set('TRADE_CUSTOM_CODE', '');
											  grdRecord.set('TRADE_CUSTOM_NAME', '');
										  },
										  applyextparam: function(popup){
//											  popup.setExtParam({'SUB_CODE': 'E3'});
											  popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
										  }
									  }
									})
								});
							break;
						}
					}
				}
			},
			{dataIndex: 'TRADE_CUSTOM_CODE'	, width: 80	,locked: false,
				editor: Unilite.popup('CUST_G', {
					DBtextFieldName: 'CUSTOM_CODE',
					extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode, POPUP_TYPE: 'GRID_CODE'},
					autoPopup: true,
					listeners: {
						'onSelected': {
							fn: function(records, type) {
								var grdRecord = masterGrid.uniOpt.currentRecord;
								grdRecord.set('TRADE_CUSTOM_CODE',records[0]['CUSTOM_CODE']);
								grdRecord.set('TRADE_CUSTOM_NAME',records[0]['CUSTOM_NAME']);
							},
							scope: this
						},
						'onClear': function(type) {
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('TRADE_CUSTOM_CODE', '');
							grdRecord.set('TRADE_CUSTOM_NAME', '');
						}
					}
				}
			)},
			{dataIndex: 'TRADE_CUSTOM_NAME'	, width: 130,locked: false,
				editor: Unilite.popup('CUST_G', {
					DBtextFieldName: 'CUSTOM_NAME',
					extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode, POPUP_TYPE: 'GRID_CODE'},
					autoPopup: true,
					listeners: {
						'onSelected': {
							fn: function(records, type) {
								var grdRecord = masterGrid.uniOpt.currentRecord;
								grdRecord.set('TRADE_CUSTOM_CODE',records[0]['CUSTOM_CODE']);
								grdRecord.set('TRADE_CUSTOM_NAME',records[0]['CUSTOM_NAME']);
							},
							scope: this
						},
						'onClear': function(type) {
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('TRADE_CUSTOM_CODE', '');
							grdRecord.set('TRADE_CUSTOM_NAME', '');
						}
					}
				}),
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '', '합계');
				}
			},
			{dataIndex: 'BL_NO'				, width: 120,locked: false},
			{dataIndex: 'CHARGE_CODE'		, width: 80	,locked: false,
				editor: Unilite.popup('EXPENSE_G',{
					autoPopup: true,
					listeners: {
						'applyextparam': function(popup){
							var selectRec = masterGrid.getSelectedRecord();
							if(selectRec){
								popup.setExtParam({'TRADE_DIV': selectRec.get("TRADE_DIV")});
								popup.setExtParam({'CHARGE_TYPE': selectRec.get("CHARGE_TYPE")});
								//popup.setExtParam({'TXT_SEARCH': selectRec.previousValues.CHARGE_CODE});
							}
						},
						'onSelected': {
							fn: function(record, type) {
								//var selectRec = masterGrid.getSelectedRecord();
								var selectRec = masterGrid.uniOpt.currentRecord;
								if(selectRec){
									selectRec.set('CHARGE_CODE', record[0]["EXPENSE_CODE"]);
									selectRec.set('CHARGE_NAME', record[0]["EXPENSE_NAME"]);
									selectRec.set('COST_DIV', record[0]["COST_DIV"]);
								}
							},
							scope: this
						},
						'onClear': function(type){
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('CHARGE_CODE', '');
							grdRecord.set('CHARGE_NAME', '');
						}
					}
				})
			},
			{dataIndex: 'CHARGE_NAME'		, width: 130,locked: false,
				getEditor:function(record){
					return getChage_codePopupEditor();
				}
			},
			{dataIndex: 'CUST_CODE'			, width: 100,
				editor: Unilite.popup('CUST_G', {
					DBtextFieldName: 'CUSTOM_CODE',
					extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode, POPUP_TYPE: 'GRID_CODE'},
					autoPopup: true,
					listeners: {
						'onSelected': {
							fn: function(records, type) {
								var grdRecord = masterGrid.uniOpt.currentRecord;
								grdRecord.set('CUST_CODE',records[0]['CUSTOM_CODE']);
								grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
								grdRecord.set('VAT_CUSTOM',records[0]['CUSTOM_CODE']);
								grdRecord.set('VAT_CUSTOM_NAME',records[0]['CUSTOM_NAME']);
							},
							scope: this
						},
						'onClear': function(type) {
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('CUST_CODE', '');
							grdRecord.set('CUSTOM_NAME', '');
						}
					}
				}
			)},
			{dataIndex: 'CUSTOM_NAME'		, width: 130,
				editor:Unilite.popup('CUST_G', {
					DBtextFieldName: 'CUSTOM_NAME',
					extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode, POPUP_TYPE: 'GRID_CODE'},
					autoPopup: true,
					listeners: {
						'onSelected': {
							fn: function(records, type) {
								var grdRecord = masterGrid.uniOpt.currentRecord;
								grdRecord.set('CUST_CODE',records[0]['CUSTOM_CODE']);
								grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
								grdRecord.set('VAT_CUSTOM',records[0]['CUSTOM_CODE']);
								grdRecord.set('VAT_CUSTOM_NAME',records[0]['CUSTOM_NAME']);
							},
							scope: this
						},
						'onClear': function(type) {
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('CUST_CODE', '');
							grdRecord.set('CUSTOM_NAME', '');
						}
					}
				}
			)},
			{dataIndex: 'VAT_CUSTOM'		, width: 100, hidden:true,
				editor: Unilite.popup('CUST_G', {
					DBtextFieldName: 'CUSTOM_CODE',
					extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode, POPUP_TYPE: 'GRID_CODE'},
					autoPopup: true,
					listeners: {
						'onSelected': {
							fn: function(records, type) {
								var grdRecord = masterGrid.uniOpt.currentRecord;
								grdRecord.set('VAT_CUSTOM',records[0]['CUSTOM_CODE']);
								grdRecord.set('VAT_CUSTOM_NAME',records[0]['CUSTOM_NAME']);
							},
							scope: this
						},
						'onClear': function(type) {
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('VAT_CUSTOM', '');
							grdRecord.set('VAT_CUSTOM_NAME', '');
						}
					}
				}
			)},
			{dataIndex: 'VAT_CUSTOM_NAME'	, width: 150, hidden:true,
				editor:Unilite.popup('CUST_G', {
					DBtextFieldName: 'CUSTOM_NAME',
					extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode, POPUP_TYPE: 'GRID_CODE'},
					autoPopup: true,
					listeners: {
						'onSelected': {
							fn: function(records, type) {
								var grdRecord = masterGrid.uniOpt.currentRecord;
								grdRecord.set('VAT_CUSTOM',records[0]['CUSTOM_CODE']);
								grdRecord.set('VAT_CUSTOM_NAME',records[0]['CUSTOM_NAME']);
							},
							scope: this
						},
						'onClear': function(type) {
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('VAT_CUSTOM', '');
							grdRecord.set('VAT_CUSTOM_NAME', '');
						}
					}
				}
			)},
			{dataIndex: 'OCCUR_DATE'		, width: 120,
				editor:{
					xtype:'uniDatefield'
				}
			},
			{dataIndex: 'TAX_CLS'			, width: 120,
				listeners:{
					render:function(elm)	{
						var tGrid = elm.getView().ownerGrid;
						elm.editor.on(
							'beforequery',function(queryPlan, eOpts)  {
								// var grid = tGrid;
								// var record = grid.uniOpt.currentRecord;
								var store = queryPlan.combo.store;
								store.clearFilter();
								store.filterBy(function(item){
									return item.get('refCode3') == 1;
							})
						});
						//20191120 증빙유형 선택 시, tax_rate set하는 로직 수정하면서 validator로 이동 - 그리드 이상동작 발생
//						elm.editor.on(
//							'select',function(queryPlan,eOpts)  {
//								var selectdata=eOpts.data;
//								console.log("eOpts : ",eOpts.data);
//								var tGrid = elm.getView().ownerGrid;
//								var grid = tGrid;
//								//获取选中行数据
//								var record = grid.uniOpt.currentRecord;
//								//获取税前金额
//								var SUPPLY_AMT=record.get("SUPPLY_AMT");
//								//税后金额
//								record.set("VAT_AMT",parseInt(SUPPLY_AMT*(selectdata.refCode2/100)));
//								//税率
//								record.set("TAX_RATE",selectdata.refCode2);
//						});
					}
				}
			},
			{dataIndex: 'CHARGE_AMT'		, width: 120 },
			{dataIndex: 'AMT_UNIT'			, width: 73	, align: 'center'},
			{dataIndex: 'EXCHANGE_RATE'		, width: 100},
			{dataIndex: 'CHARGE_AMT_WON'	, width: 120, summaryType: 'sum'},
			{dataIndex: 'SUPPLY_AMT'		, width: 120},
			{dataIndex: 'TAX_RATE'			, width: 80	, hidden:true},
			{dataIndex: 'VAT_AMT'			, width: 120, summaryType: 'sum'},
			//20191120 총지급액 컬럼 추가
			{dataIndex: 'SUPPLY_TOTAL_AMT'	, width: 120, summaryType: 'sum'},
			{dataIndex: 'DIV_CODE'			, width: 93 , hidden: true},
			{dataIndex: 'VAT_COMP_CODE'		, width: 120},
			{dataIndex: 'PAY_TYPE'			, width: 120},
			{dataIndex: 'SAVE_CODE'			, width: 100, align: 'center', hidden: true},
			{dataIndex: 'SAVE_NAME'			, width: 180, align: 'center',
				editor:Unilite.popup('BANK_BOOK_G', {
					autoPopup: true,
					listeners: {
						'onSelected': {
							fn: function(records, type) {
								var grdRecord = masterGrid.uniOpt.currentRecord;
								grdRecord.set('SAVE_CODE',records[0]['BANK_BOOK_CODE']);
								grdRecord.set('SAVE_NAME',records[0]['BANK_BOOK_NAME']);
							},
							scope: this
						},
						'onClear': function(type) {
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('SAVE_CODE', '');
							grdRecord.set('SAVE_NAME', '');
						}
					}
				})
			},
			{dataIndex: 'BANK_CODE'			, width: 106, hidden: true},
			{dataIndex: 'BANK_NAME'			, width: 150, align: 'center',
				editor:Unilite.popup('BANK_G', {
					autoPopup: true,
					listeners: {
						'onSelected': {
							fn: function(records, type) {
								var grdRecord = masterGrid.uniOpt.currentRecord;
								grdRecord.set('BANK_CODE',records[0]['BANK_CODE']);
								grdRecord.set('BANK_NAME',records[0]['BANK_NAME']);
							},
							scope: this
						},
						'onClear': function(type) {
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('BANK_CODE', '');
							grdRecord.set('BANK_NAME', '');
						}
					}
				})
			},
			{dataIndex: 'NOTE_NUM'			, width: 80	, hidden: true},
			{dataIndex: 'EXP_DATE'			, width: 120, hidden: true},
			{dataIndex: 'PROJECT_NO'		, width: 120},
			{dataIndex: 'PAY_DATE'			, width: 120,
				editor:{
					xtype:'uniDatefield'
				}
			},
			{dataIndex: 'REMARKS'			, width: 150},
			{dataIndex: 'OFFER_SER_NO'		, width: 120},
			{dataIndex: 'LC_SER_NO'			, width: 120, hidden: true},
			{dataIndex: 'LC_NO'				, width: 120},
			{dataIndex: 'BL_SER_NO'			, width: 120/*,hidden: true*/},
			{dataIndex: 'COST_DIV'			, width: 80	, align: 'center'},
			{dataIndex: 'EX_DATE'			, width: 120},
			{dataIndex: 'EX_NUM'			, width: 80},
			{dataIndex: 'AGREE_YN'			, width: 60	, align: 'center'},
			{dataIndex: 'update_db_user'	, width: 80	, hidden: true},
			{dataIndex: 'update_db_time'	, width: 80	, hidden: true},
			{dataIndex: 'COMP_CODE'			, width: 80	, hidden: true}
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
//				if(!e.record.phantom || e.record.phantom)	{
//					if (UniUtils.indexOf(e.field,
//							['AGREE_YN','EX_NUM','EX_DATE']))
//							return false;
//				} else {
//					return true;
//				}
				var record = e.record;
				var payType = record.get('PAY_TYPE').substring(0, 1);
				if(e.record.phantom){
					if(UniUtils.indexOf(e.field, ["CHARGE_CODE","CHARGE_NAME"])){
						if(Ext.isEmpty(e.record.get('CHARGE_TYPE'))){
							alert('진행구분을 선택 하세요.')
							return false;
						}
					}
					if(UniUtils.indexOf(e.field, ["EX_DATE","EX_NUM","AGREE_YN"])){
						return false;
					}
					if(UniUtils.indexOf(e.field, ["SAVE_CODE", "SAVE_NAME"])){
						if(!Ext.isEmpty(payType) && payType == "B"){
							return true;
						} else {
							return false;
						}
					}
					if(UniUtils.indexOf(e.field, ["BANK_CODE", "BANK_NAME"])){
						if(!Ext.isEmpty(payType) && payType == "B" || payType == "C"){
							return true;
						} else {
							return false;
						}
					}
					if(UniUtils.indexOf(e.field, ["NOTE_NUM", "EXP_DATE"])){
						if(!Ext.isEmpty(payType) && payType == "C"){
							return true;
						} else {
							return false;
						}
					}
				} else {
					//20191120 조회된 데이터의 경우, 진행구분 / 순번 수정 할 수 없도록 변경
					if(UniUtils.indexOf(e.field, ['CHARGE_TYPE', 'CHARGE_SER'])){
						return false;
					}
					if(Ext.isEmpty(record.get('EX_DATE'))){
						if(UniUtils.indexOf(e.field, ["EX_DATE","EX_NUM","AGREE_YN"])){
							return false;
						}
						if(UniUtils.indexOf(e.field, ["SAVE_CODE", "SAVE_NAME"])){
							if(!Ext.isEmpty(payType) && payType == "B"){
								return true;
							} else {
								return false;
							}
						}
						if(UniUtils.indexOf(e.field, ["BANK_CODE", "BANK_NAME"])){
							if(!Ext.isEmpty(payType) && payType == "B" || payType == "C"){
								return true;
							} else {
								return false;
							}
						}
						if(UniUtils.indexOf(e.field, ["NOTE_NUM", "EXP_DATE"])){
							if(!Ext.isEmpty(payType) && payType == "C"){
								return true;
							} else {
								return false;
							}
						}
						if(UniUtils.indexOf(e.field, ["CHARGE_CODE", "CHARGE_NAME"])){
							return false;
						}
					}
					else {
						return false;
					}
				}
				if(UniUtils.indexOf(e.field, ["OFFER_SER_NO", "LC_NO", "BL_NO", "BL_SER_NO"])) {
					return false;
				}
			},
			selectionchange:function ( grid, selected, eOpts )	{
				var autoSlipBtn = panelResult.down("#autoSlip63Btn");
				var autoSlipCancelBtn = panelResult.down("#autoSlip63CancelBtn");
				if(selected && selected.length > 0)	{
					var record = selected[0];
					if(!Ext.isEmpty(record.get("EX_DATE")) && !Ext.isEmpty(record.get("EX_NUM"))  && record.get("EX_NUM") != 0 )	{
						autoSlipBtn.setDisabled(true);
						autoSlipCancelBtn.setDisabled(false);
					} else {
						autoSlipBtn.setDisabled(false);
						autoSlipCancelBtn.setDisabled(true);
					}
				} else {
					autoSlipBtn.setDisabled(true);
					autoSlipCancelBtn.setDisabled(true);
				}
			},onGridDblClick: function(grid, record, cellIndex, colName) {
				var chargeType = record.get('CHARGE_TYPE');
				if(chargeType == 'P' || !Ext.isEmpty(record.get('BASIC_PAPER_NO'))){
					openPassInconWindow();
				}
			}
		},
		setItemData: function(record, dataClear,fieldName) {
			var grdRecord = this.getSelectedRecord();
			if(dataClear){
			} else {
				if(fieldName=="TRADE_CUSTOM_NAME"||fieldName=="TRADE_CUSTOM_CODE"){
					grdRecord.set('TRADE_CUSTOM_CODE'	, record['CUSTOM_CODE']);
					grdRecord.set('TRADE_CUSTOM_NAME'	, record['CUSTOM_NAME']);
				} else if(fieldName=="CUST_CODE"||fieldName=="CUSTOM_NAME"){
					grdRecord.set('CUST_CODE'			, record['CUSTOM_CODE']);
					grdRecord.set('CUSTOM_NAME'			, record['CUSTOM_NAME']);
					grdRecord.set('VAT_CUSTOM'			, record['CUSTOM_CODE']);
					grdRecord.set('VAT_CUSTOM_NAME'		, record['CUSTOM_NAME']);
				} else {
					grdRecord.set('VAT_CUSTOM'			, record['CUSTOM_CODE']);
					grdRecord.set('VAT_CUSTOM_NAME'		, record['CUSTOM_NAME']);
				}
			}
		}
	});



	//20191120 주석: 그리드 summary 사용
/*	function charget_amtSUM(){
		var charge_amt=0;
		var vat_amt=0;
		for(var i=0;i<directMasterStore1.getCount();i++) {
			charge_amt+= directMasterStore1.getAt(i).data.CHARGE_AMT; //或者 store.getAt(i).get("columnName")
			vat_amt+=directMasterStore1.getAt(i).data.VAT_AMT; //或者 store.getAt(i).get("columnName")
		}
		panelResult2.setValue("charge_amt"	, charge_amt);
		panelResult2.setValue("vat_amt"		, vat_amt);
	}*/


	Unilite.Main({
		id			: 'tix100ukrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				panelResult,masterGrid
				//20191120 주석: 그리드 summary 사용
//				,panelResult2
			]
		},
			panelSearch
		],
		fnInitBinding: function(params) {
			panelSearch.setValue('FRORDERDATE',UniDate.get('startOfMonth'));
			panelSearch.setValue('TOORDERDATE',UniDate.get('today'));
			panelResult.setValue('FRORDERDATE',UniDate.get('startOfMonth'));
			panelResult.setValue('TOORDERDATE',UniDate.get('today'));
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('TRADE_DIV','I');
			panelResult.setValue('TRADE_DIV','I');
			if(!Ext.isEmpty(params) && !Ext.isEmpty(params.appId)){
				this.processParams(params);
			}
			UniAppManager.setToolbarButtons('reset',true);
			UniAppManager.setToolbarButtons('newData',true);
			UniAppManager.setToolbarButtons(['save'], false);

		},//링크로 넘어오는 params 받는 부분
		processParams: function(param) {
//			param[0] = "O";	//진행구분
//			param[1] = panelSearch.getValue('SO_SER_NO'); //근거번호
//			param[2] = panelSearch.getValue('EXPORTER');  //수출자
//			param[3] = panelSearch.getValue('EXPORTER_NM');
//			param[4] = ""
//			param[5] = panelSearch.getValue('DIV_CODE');
//			param[6] = panelSearch.getValue('AMT_UNIT');  //화폐단위
//			param[7] = panelSearch.getValue('EXCHANGE_RATE'); //<t:message code="system.label.trade.exchangerate" default="환율"/>
//
			panelSearch.setValue('CHARGE_TYPE'		, param.arrayParam[0]);
			panelSearch.setValue('DIV_CODE'			, param.arrayParam[5]);
			panelSearch.setValue('BASIC_PAPER_NO'	, param.arrayParam[1]);
			panelSearch.setValue('CUST_CODE'		, param.arrayParam[2]);
			panelSearch.setValue('CUST_NAME'		, param.arrayParam[3]);

			panelResult.setValue('CHARGE_TYPE'		, param.arrayParam[0]);
			panelResult.setValue('DIV_CODE'			, param.arrayParam[5]);
			panelResult.setValue('BASIC_PAPER_NO'	, param.arrayParam[1]);
			panelResult.setValue('CUST_CODE'		, param.arrayParam[2]);
			panelResult.setValue('CUST_NAME'		, param.arrayParam[3]);

			//20191120 주석: 그리드 summary 사용
//			panelResult2.setValue('charge_amt', param.arrayParam[4]);
			gsAmtUnit = param.arrayParam[6];
			gsExchangeRate = param.arrayParam[7];

			UniAppManager.app.onNewDataButtonDown();

		},
		onQueryButtonDown: function() {
			if(!panelSearch.getInvalidMessage()) return;	//필수체크
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			} else {
			masterGrid.getStore().loadStoreRecords();
			UniAppManager.setToolbarButtons('reset',true);
			UniAppManager.setToolbarButtons('excel',true);
			}
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			masterGrid.reset();
			directMasterStore1.clearData();
			panelResult.clearForm();
			panelSearch.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);
			this.fnInitBinding();
		},
		onNewDataButtonDown:function(){
			if(!panelSearch.setAllFieldsReadOnly(true)){
				return false;
			}
			if(!panelResult.setAllFieldsReadOnly(true)){
				return false;
			}
			if(!this.checkForNewDetail()) return false;
			var TRADE_DIV ='';
			if(panelSearch.getValue("TRADE_DIV")==null||panelSearch.getValue("")){
			  TRADE_DIV ='I';
			} else {
			  TRADE_DIV =panelSearch.getValue("TRADE_DIV");
			}

			var chargeSeq = directMasterStore1.max('CHARGE_SER');
			 if(!chargeSeq) chargeSeq = 1;
			 else  chargeSeq += 1;

			var CHARGE_TYPE = panelSearch.getValue("CHARGE_TYPE");
			var CHARGE_SER= chargeSeq;

			if(CHARGE_TYPE =="O") {
				var BASIC_PAPER_NO = panelSearch.getValue("INCOM_OFFER");
			} else if(CHARGE_TYPE =="B") {
				var BASIC_PAPER_NO = Ext.isEmpty(panelSearch.getValue("INCOM_BL")) ? panelSearch.getValue("BASIC_PAPER_NO") : panelSearch.getValue("INCOM_BL");
			} else if(CHARGE_TYPE =="P") {
				var BASIC_PAPER_NO = panelSearch.getValue("PASS_INCOM_NO");
			} else if(CHARGE_TYPE =="S") {
				var BASIC_PAPER_NO = panelSearch.getValue("NEGO_INCOM_NO");
			} else {
				var BASIC_PAPER_NO = "";
			}

			var TRADE_CUSTOM_CODE = panelSearch.getValue("TRADE_CUSTOM_CODE");
			var TRADE_CUSTOM_NAME = panelSearch.getValue("TRADE_CUSTOM_NAME");
			var CHARGE_CODE='';
			var CHARGE_NAME='';
			var CUST_CODE=panelSearch.getValue("CUST_CODE");
			var CUST_NAME=panelSearch.getValue("CUST_NAME");
			var VAT_CUSTOM='';
			var VAT_CUSTOM_NAME='';
			var OCCUR_DATE='';	//new Date();	사용자실수가 많아 기본값 제거
			var CHARGE_AMT=0.0;
			var AMT_UNIT= 'KRW';
			var EXCHANGE_RATE= 1.00;
			var CHARGE_AMT_WON=0.0;
			var SUPPLY_AMT=0.0;
			var TAX_CLS	='';
			var VAT_AMT=0;
			var DIV_CODE=UserInfo.divCode;
			var VAT_COMP_CODE= panelSearch.getValue("DIV_CODE");
			var PAY_TYPE='A1';
			var SAVE_CODE='';
			var SAVE_NAME='';
			var BANK_CODE='';
			var BANK_NAME='';
			var NOTE_NUM='';
			var EXP_DATE='';
			var PROJECT_NO='';
			var PAY_DATE='';
			var REMARKS='';
	//		var OFFER_SER_NO='';
	//		var LC_NO='';
	//		var BL_NO='';
			var BL_SER_NO		= '';
			var OFFER_SER_NO	= panelResult.getValue("OFFER_SER_NO");
			var LC_NO			= '';
			var BL_NO			= '';

			var COST_DIV='';
			var EX_DATE='';
			var EX_NUM=0;
			var AGREE_YN='';
			var update_db_user='';
			var update_db_time='';
			var COMP_CODE='';

			var r= {
			TRADE_DIV :TRADE_DIV,
			CHARGE_TYPE:CHARGE_TYPE,
			CHARGE_SER:CHARGE_SER,
			BASIC_PAPER_NO:BASIC_PAPER_NO,
			TRADE_CUSTOM_CODE:TRADE_CUSTOM_CODE,
			TRADE_CUSTOM_NAME:TRADE_CUSTOM_NAME,
			CHARGE_CODE:CHARGE_CODE,
			CHARGE_NAME:CHARGE_NAME,
			CUST_CODE:CUST_CODE,
			CUSTOM_NAME:CUST_NAME,
			VAT_CUSTOM:VAT_CUSTOM,
			VAT_CUSTOM_NAME:VAT_CUSTOM_NAME,
			//OCCUR_DATE:new Date(),		//사용자실수가 많아 기본값 제거
			CHARGE_AMT:CHARGE_AMT,
			AMT_UNIT:AMT_UNIT,
			EXCHANGE_RATE:EXCHANGE_RATE,
			CHARGE_AMT_WON:CHARGE_AMT_WON,
			//SUPPLY_AMT:SUPPLY_AMT,
			TAX_CLS	:TAX_CLS,
			VAT_AMT:VAT_AMT,
			DIV_CODE:DIV_CODE,
			VAT_COMP_CODE:VAT_COMP_CODE,
			PAY_TYPE:PAY_TYPE,
			SAVE_CODE:SAVE_CODE,
			SAVE_NAME:SAVE_NAME,
			BANK_CODE:BANK_CODE,
			BANK_NAME:BANK_NAME,
			NOTE_NUM:NOTE_NUM,
			EXP_DATE:EXP_DATE,
			PROJECT_NO:PROJECT_NO,
			PAY_DATE:PAY_DATE,
			REMARKS:REMARKS,
			OFFER_SER_NO:OFFER_SER_NO,
			LC_NO:LC_NO,
			BL_NO:BL_NO,
			BL_SER_NO : BL_SER_NO,
			COST_DIV:COST_DIV,
			EX_DATE:EX_DATE,
			EX_NUM:EX_NUM,
			AGREE_YN:AGREE_YN,
			update_db_user:'',
			update_db_time:'',
			COMP_CODE:COMP_CODE
			};

			if(CHARGE_TYPE =="O") {
				var param = {
					"COMP_CODE"	: UserInfo.compCode,
					"OFFER_NO"	: panelSearch.getValue("INCOM_OFFER")
				};
				popupService.incomOfferNoPopup(param, function(provider, response) {
					if(!Ext.isEmpty(provider)) {
						r.OFFER_SER_NO = provider[0].OFFER_NO;
					}
					masterGrid.createRow(r);
				});
			} else if(CHARGE_TYPE =="B") {
				var param = {
					"COMP_CODE"	: UserInfo.compCode,
					"BL_SER_NO"	: panelSearch.getValue("INCOM_BL")
				};
				popupService.incomBlNoPopup(param, function(provider, response) {
					if(!Ext.isEmpty(provider)) {
						r.BL_SER_NO		= provider[0].BL_SER_NO;
						r.OFFER_SER_NO	= provider[0].SO_SER_NO;
						r.LC_NO			= provider[0].LC_NO;
						r.BL_NO			= provider[0].BL_NO;
					}
					masterGrid.createRow(r);
				});
			} else if(CHARGE_TYPE =="P") {
				var param = {
					"COMP_CODE"			: UserInfo.compCode,
					"DIV_CODE"			: panelSearch.getValue("DIV_CODE"),
					"INVOICE_DATE_FR"	: UniDate.getDbDateStr(panelSearch.getValue("FRORDERDATE")),
					"INVOICE_DATE_TO"	: UniDate.getDbDateStr(panelSearch.getValue("TOORDERDATE")),
					"PASS_SER_NO"		: panelSearch.getValue("PASS_INCOM_NO")
				};
				popupService.passIncomNoPopup(param, function(provider, response) {
					if(!Ext.isEmpty(provider)) {
						r.BL_SER_NO		= provider[0].BL_SER_NO;
						r.OFFER_SER_NO	= provider[0].SO_SER_NO;
						r.LC_NO			= provider[0].LC_NO;
						r.BL_NO			= provider[0].BL_NO;
					}
					masterGrid.createRow(r);
				});
			} else if(CHARGE_TYPE =="S") {
	//			var param = { "COMP_CODE"		: UserInfo.compCode,
	//						  "NEGO_INCOM_NO"	: panelSearch.getValue("NEGO_INCOM_NO")
	//			};
	//
	//			popupService.passIncomNoPopup(param, function(provider, response) {
	//				if(!Ext.isEmpty(provider)) {
						r.BL_SER_NO		= '';
						r.OFFER_SER_NO	= '';
						r.LC_NO			= '';
						r.BL_NO			= '';
	//					var BL_SER_NO		= provider[0].BL_NO;
	//					var OFFER_SER_NO	= provider[0].SO_SER_NO;
	//					var LC_NO			= provider[0].LC_NO;
	//					var BL_NO			= provider[0].BL_NO;
	//				}
				masterGrid.createRow(r);
	//			});

			} else {
				r.BL_SER_NO		= '';
				r.OFFER_SER_NO	= '';
				r.LC_NO			= '';
				r.BL_NO			= '';
				masterGrid.createRow(r);
			}

			UniAppManager.setToolbarButtons('deleteData',true);
			//UniAppManager.setToolbarButtons('deleteAll',true);
		},
		onDeleteDataButtonDown:function(){
			var selRow = masterGrid.getSelectedRecord();
			if(selRow.phantom === true)	{
				masterGrid.deleteSelectedRow();
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				masterGrid.deleteSelectedRow();
			}
		},
		onDeleteAllButtonDown:function(){
			var records = directMasterStore1.data.items;
			var isNewData = false;
			Ext.each(records, function(record,i) {
				if(confirm('전체삭제 하시겠습니까?')) {
						var deletable = true;
						if(deletable){
							masterGrid.reset();
							//UniAppManager.app.onSaveDataButtonDown();
						}
						isNewData = false;
				}
				return false;
			});
			if(isNewData){								//신규 레코드들만 있을시 그리드 리셋
				masterGrid.reset();
				UniAppManager.app.onResetButtonDown();	//삭제후 RESET..
			}
		},
		onSaveDataButtonDown: function(config) {
			if(!panelSearch.getInvalidMessage()) return;	//필수체크
			directMasterStore1.saveStore();
		},
		fnAutoSlip:function()	{
			var selectedRecord = masterGrid.getSelectedRecord();
			
			if (Ext.isEmpty(selectedRecord)) {
				alert('<t:message code="system.message.sales.datacheck016" default="선택된 자료가 없습니다."/>');
				return false;
			}
			
			var chkParam = {
				'FRORDERDATE'	: UniDate.getDbDateStr(selectedRecord.get('OCCUR_DATE')),
				'TOORDERDATE'	: UniDate.getDbDateStr(selectedRecord.get('OCCUR_DATE')),
				'DIV_CODE'		: selectedRecord.get("DIV_CODE"),
				'CHARGE_TYPE'	: selectedRecord.get("CHARGE_TYPE"),
				'CHARGE_SER'	: selectedRecord.get("CHARGE_SER"),
				'TRADE_DIV'		: "I"
			}
			tix100ukrvService.selectList(chkParam, function(responseText){
				if(responseText && responseText.length > 0)	{
					var rtnRecord = responseText[0]
					if(!Ext.isEmpty(rtnRecord.EX_DATE) &&  !Ext.isEmpty(rtnRecord.EX_NUM) && rtnRecord.EX_DATE != 0 )	{
						var autoSlipBtn = panelResult.down("#autoSlip63Btn");
						var autoSlipCancelBtn = panelResult.down("#autoSlip63CancelBtn");
						autoSlipBtn.setDisabled(true);
						autoSlipCancelBtn.setDisabled(false);
						Unilite.messageBox('<t:message code="system.message.trade.message004" default="이미 전표가 등록되었습니다."/>');
						return;
					}
					var selectedRecord = masterGrid.getSelectedRecord();
					if(selectedRecord)	{
						var params = {
							"PGM_ID": 'tix100ukrv',
							'sGubun' : '63',
							"TRADE_DIVI":'I',
							"FR_ORDER_DATE":UniDate.getDbDateStr(panelResult.getValue("FRORDERDATE")),
							"TO_ORDER_DATE":UniDate.getDbDateStr(panelResult.getValue("TOORDERDATE")),
							"DIV_CODE"  :panelResult.getValue("DIV_CODE"),
							"CHARGE_TYPE":selectedRecord.get("CHARGE_TYPE"),
							"CHARGE_SER":selectedRecord.get("CHARGE_SER"),
							"OCCURDATE" : selectedRecord.get("OCCUR_DATE")
						}
						var rec1 = {data : {prgID : 'agj260ukr', 'text':''}};
						parent.openTab(rec1, '/accnt/agj260ukr.do', params);
					}
				}
			});
		},
		fnAutoSlipCancel: function() {
			var selectedRecord = masterGrid.getSelectedRecord();
			
			if (Ext.isEmpty(selectedRecord)) {
				alert('<t:message code="system.message.sales.datacheck016" default="선택된 자료가 없습니다."/>');
				return false;
			}
			
			var chkParam = {
					'FRORDERDATE' : UniDate.getDbDateStr(selectedRecord.get('OCCUR_DATE')),
					'TOORDERDATE' : UniDate.getDbDateStr(selectedRecord.get('OCCUR_DATE')),
					'DIV_CODE'	  : selectedRecord.get("DIV_CODE"),
					'CHARGE_TYPE' : selectedRecord.get("CHARGE_TYPE"),
					'CHARGE_SER'  : selectedRecord.get("CHARGE_SER"),
					'TRADE_DIV'   : selectedRecord.get("TRADE_DIV")
			}
			tix100ukrvService.selectList(chkParam, function(responseText){
				if(responseText && responseText.length > 0)	{
					var rtnRecord = responseText[0]
					if(Ext.isEmpty(rtnRecord.EX_DATE) &&  (Ext.isEmpty(rtnRecord.EX_NUM) || rtnRecord.EX_DATE == 0) )	{
						var autoSlipBtn = panelResult.down("#autoSlip63Btn");
						var autoSlipCancelBtn = panelResult.down("#autoSlip63CancelBtn");
						autoSlipBtn.setDisabled(true);
						autoSlipCancelBtn.setDisabled(false);
						Unilite.messageBox('<t:message code="system.message.trade.message005" default="기표된 전표가 없습니다."/>')
						return;
					}
					if(rtnRecord.AGREE_YN == "Y")	{
						Unilite.messageBox('<t:message code="system.message.trade.message007" default="승인된 전표는 취소 할 수 없습니다."/>')
						return;
					}
					if(selectedRecord)	{
						var params = {
							"PGM_ID": 'tix100ukrv',
							'sGubun' : '63',
							"TRADE_DIVI":'I',
							"FR_ORDER_DATE":UniDate.getDbDateStr(panelResult.getValue("FRORDERDATE")),
							"TO_ORDER_DATE":UniDate.getDbDateStr(panelResult.getValue("TOORDERDATE")),
							"DIV_CODE"  :panelResult.getValue("DIV_CODE"),
							"CHARGE_TYPE":selectedRecord.get("CHARGE_TYPE"),
							"CHARGE_SER":selectedRecord.get("CHARGE_SER")
						}
						Ext.getBody().mask();
						agj260ukrService.spAutoSlip63cancel(params, function(responseText){
							Ext.getBody().unmask();
							if(responseText)	{
								var autoSlipBtn = panelResult.down("#autoSlip63Btn");
								var autoSlipCancelBtn = panelResult.down("#autoSlip63CancelBtn");
								autoSlipBtn.setDisabled(false);
								autoSlipCancelBtn.setDisabled(true);
								UniAppManager.updateStatus('<t:message code="system.message.trade.message006" default="기표가 취소되었습니다."/>');

								UniAppManager.app.onQueryButtonDown();
							}
						});
					}
				}
			});
		},
		checkForNewDetail:function() {
			return panelSearch.setAllFieldsReadOnly(true);
		},
		//20191216 일괄 수정
		fnExchngRateO:function(newValue, newValue2, record) {		//newValue(화폐단위), newValue2(날짜)
			if(Ext.isEmpty(record)) {
				var record = masterGrid.getSelectedRecord();
			}
			var acDate		= Ext.isEmpty(newValue2)? UniDate.getDbDateStr(record.get('OCCUR_DATE')) : UniDate.getDbDateStr(newValue2);
			var moneyUnit	= Ext.isEmpty(newValue)	? record.get('AMT_UNIT') : newValue;
			var param = {
				"AC_DATE"		: acDate,
				"MONEY_UNIT"	: moneyUnit
			};
			salesCommonService.fnExchgRateO(param, function(provider, response) {
				if(!Ext.isEmpty(provider)){
					if(provider.BASE_EXCHG == "1" && !Ext.isEmpty(record.get('AMT_UNIT')) && moneyUnit != UserInfo.currency){
						alert('<t:message code="system.label.trade.exchangerate" default="환율"/>정보가 없습니다.');
					}
					record.set('EXCHANGE_RATE', provider.BASE_EXCHG);
					fnCalAmt(newValue, null, record);
				}
			});
		}
	});



	function getChage_codePopupEditor(){
		var editField = Unilite.popup('EXPENSE_G',{
			DBtextFieldName: 'CHARGE_CODE',
			textFieldName:'CHARGE_CODE',
			autoPopup: true,
			listeners: {
				'applyextparam': function(popup){
					var selectRec = masterGrid.getSelectedRecord();
					if(selectRec){
						popup.setExtParam({'TRADE_DIV': selectRec.get("TRADE_DIV")});
						popup.setExtParam({'CHARGE_TYPE': selectRec.get("CHARGE_TYPE")});
						popup.setExtParam({'TXT_SEARCH': selectRec.get("CHARGE_CODE")});
					}
				},
				'onSelected': {
					fn: function(record, type) {
						var selectRec = masterGrid.getSelectedRecord();
						if(selectRec){
							selectRec.set('CHARGE_CODE', record[0]["EXPENSE_CODE"]);
							selectRec.set('CHARGE_NAME', record[0]["EXPENSE_NAME"]);
							selectRec.set('COST_DIV', record[0]["COST_DIV"]);
						}
					},
					scope: this
				},
				'onClear': function(type){
					scope: this
				}
			}
	})

	var editor = Ext.create('Ext.grid.CellEditor', {
			ptype: 'cellediting',
			clicksToEdit: 1, // 1 or 2 , 수정 모드로 들어가기 위한 Click 횟수
			autoCancel : false,
			selectOnFocus:true,
			field: editField
		});

		return editor;
	}



	//20191216 함수 생성
	function fnCalAmt(newValue, newValue2, record){		//newValue(화폐단위), newValue2(경비금액)
		var moneyUnit		= Ext.isEmpty(newValue)		? record.get('AMT_UNIT') : newValue;
		var chageAmt		= Ext.isEmpty(newValue2)	? record.get('CHARGE_AMT') : newValue2;
		var digit			= UniFormat.Price.indexOf(".") == -1 ? UniFormat.Price.length : UniFormat.Price.indexOf(".") + 1;
		var numDigitOfPrice	= UniFormat.Price.length - digit;

		if(moneyUnit == "JPY"){
			record.set('CHARGE_AMT_WON'	, UniSales.fnAmtWonCalc(Unilite.multiply(chageAmt, record.get('EXCHANGE_RATE')) / 100, BsaCodeInfo.gsTradeCalcMethod, numDigitOfPrice));
		} else {
			record.set('CHARGE_AMT_WON'	, UniSales.fnAmtWonCalc(Unilite.multiply(chageAmt, record.get('EXCHANGE_RATE')), BsaCodeInfo.gsTradeCalcMethod, numDigitOfPrice));
		}
		record.set('SUPPLY_AMT'			, record.get('CHARGE_AMT_WON'));
		record.set('VAT_AMT'			, UniSales.fnAmtWonCalc(Unilite.multiply(record.get('SUPPLY_AMT'), record.get('TAX_RATE')) / 100, BsaCodeInfo.gsTradeCalcMethod, numDigitOfPrice));
		record.set('SUPPLY_TOTAL_AMT'	, record.get('SUPPLY_AMT') + record.get('VAT_AMT'));
	}

	Unilite.defineModel('orderNoMasterModel', {
		fields: [
			{name: 'DIV_CODE'			,text:'<t:message code="system.label.common.division" default="사업장"/>'					,type:'string', comboType: "BOR120" },
			{name: 'TRADE_TYPE'			,text:'<t:message code="system.label.common.tradetype" default="무역종류"/>'				,type:'string'},
			{name: 'PASS_INCOM_NO'		,text:'<t:message code="system.label.common.customsmanagementno" default="통관관리번호"/>'	,type:'string'},
			{name: 'INVOICE_DATE'		,text:'<t:message code="system.label.common.customdate" default="통관일"/>'				,type:'uniDate'},
			{name: 'IMPORTER'			,text:'<t:message code="system.label.common.importer" default="수입자"/>'					,type:'string'},
			{name: 'IMPORTER_NM'		,text:'<t:message code="system.label.common.importer" default="수입자"/>'					,type:'string'},
			{name: 'EXPORTER'			,text:'<t:message code="system.label.common.exporter" default="수출자"/>'					,type:'string'},
			{name: 'EXPORTER_NM'		,text:'<t:message code="system.label.common.exporter" default="수출자"/>'					,type:'string'},
			{name: 'PAY_TERMS'			,text:'<t:message code="system.label.common.paycondition" default="결제조건"/>'				,type:'string'},
			{name: 'TERMS_PRICE'		,text:'<t:message code="system.label.common.pricecondition" default="가격조건"/>'			,type:'string'},
			{name: 'PASS_EXCHANGE_RATE'	,text:'<t:message code="system.label.common.exchangerate" default="환율"/>'				,type:'string'},
			{name: 'PASS_AMT_UNIT'		,text:'<t:message code="system.label.common.currencyunit" default="화폐단위"/>'				,type:'string'},
			{name: 'PROJECT_NO'			,text:'<t:message code="system.label.common.projectno" default="프로젝트번호"/>'				,type:'string'},
			{name: 'PROJECT_NAME'		,text:'<t:message code="system.label.common.projectname" default="프로젝트명"/>'				,type:'string'},
			{name: 'SO_SER_NO'			,text:'<t:message code="system.label.common.offerno" default="OFFER번호"/>'				,type:'string'},
			{name: 'LC_SER_NO'			,text:'<t:message code="system.label.common.lcmanageno" default="L/C관리번호"/>'			,type:'string'},
			{name: 'LC_NO'				,text:'<t:message code="system.label.common.lcno" default="L/C번호"/>'					,type:'string'},
			{name: 'BL_SER_NO'			,text:'<t:message code="system.label.common.blmanageno" default="B/L관리번호"/>'			,type:'string'},
			{name: 'BL_NO'				,text:'<t:message code="system.label.common.blno" default="B/L번호"/>'					,type:'string'},
			{name: 'REMARKS1'			,text:'<t:message code="system.label.common.remarks" default="비고"/>1'					,type:'string'},
			{name: 'REMARKS2'			,text:'<t:message code="system.label.common.remarks" default="비고"/>2'					,type:'string'},
			{name: 'REMARKS3'			,text:'<t:message code="system.label.common.remarks" default="비고"/>2'					,type:'string'},
			//20191202 추가
			{name: 'PASS_AMT'			, text: '<t:message code="system.label.trade.customamount" default="통관금액"/>'			,type: 'uniFC'}
		]
	});

	var orderNoMasterStore = Unilite.createStore('orderNoMasterStore', {	//조회버튼 누르면 나오는 조회창
		model	: 'orderNoMasterModel',
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
				read : 'popupService.passIncomNoPopup'
			}
		},
		loadStoreRecords : function()	{
			if(orderNoSearch.validateForm()){
				var param= orderNoSearch.getValues();
				console.log( param );
				this.load({
					params : param
				});
			}
		},
		listeners:{
			load: function(store, records, successful, eOpts){
				if(Ext.isEmpty(this.data.items)){
					Ext.Msg.alert('<t:message code="unilite.msg.sMB099" />','<t:message code="unilite.msg.sMB015" />');
				}
			}
		}
	});

	var orderNoSearch = Unilite.createSearchForm('orderNoSearchForm', {
		layout: {type: 'uniTable', columns : 2},
		items: [{
			fieldLabel: '<t:message code="system.label.common.division" default="사업장"/>',
			name: 'DIV_CODE',
			xtype:'uniCombobox',
			comboType:'BOR120',
			readOnly: true
		},{
			fieldLabel: '<t:message code="system.label.common.customsmanagementno" default="통관관리번호"/>',
			xtype: 'uniTextfield',
			name: 'PASS_SER_NO'
		},{
			fieldLabel: '<t:message code="system.label.common.blno" default="B/L번호"/>',
			xtype: 'uniTextfield',
			name: 'BL_NO'
		}, {
			fieldLabel: '<t:message code="system.label.common.customdate" default="통관일"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'INVOICE_DATE_FR',
			endFieldName: 'INVOICE_DATE_TO',
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today'),
			allowBlank:false
		},
			Unilite.popup('AGENT_CUST',{
			fieldLabel: '<t:message code="system.label.common.exporter" default="수출자"/>',
			validateBlank: false,
			valueFieldName:'EXPORTER',
			textFieldName:'EXPORTER_NM',
//			extParam: {'AGENT_CUST_FILTER':'1,2'},
			listeners: {
				applyextparam: function(popup) {
					popup.setExtParam({'AGENT_CUST_FILTER':'1,2'});
					popup.setExtParam({'CUSTOM_TYPE':'1,2'});
				}
			}
		}),{
			fieldLabel: '<t:message code="system.label.common.paycondition" default="결제조건"/>',
			name: 'PAY_TERMS',
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'T006'
		},{
			fieldLabel: '<t:message code="system.label.common.pricecondition" default="가격조건"/>',
			name: 'TERMS_PRICE',
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'T005'
		}],
		validateForm: function(){
			var r= true
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
				alert(labelText+Msg.sMB083);
				invalid.items[0].focus();
			}
			return r;
		}
	});

	var orderNoMasterGrid = Unilite.createGrid('ipo100ma1OrderNoMasterGrid', {		//조회버튼 누르면 나오는 조회창
		store	: orderNoMasterStore,
		layout	: 'fit',
		uniOpt	: {
			useGroupSummary		: false,
			useLiveSearch		: true,
			useContextMenu		: true,
			useMultipleSorting	: true,
			expandLastColumn	: true,
			useRowNumberer		: true
		},
		selModel: 'rowmodel',
		columns	: [
			{ dataIndex: 'DIV_CODE'				, width: 100, hidden: true },
			{ dataIndex: 'TRADE_TYPE'			, width: 100, hidden: true },
			{ dataIndex: 'PASS_INCOM_NO'		, width: 100 },
			{ dataIndex: 'INVOICE_DATE'			, width: 100 },
			{ dataIndex: 'IMPORTER'				, width: 100, hidden: true },
			{ dataIndex: 'IMPORTER_NM'			, width: 100, hidden: true },
			{ dataIndex: 'EXPORTER'				, width: 100, hidden: true },
			{ dataIndex: 'EXPORTER_NM'			, width: 100 },
			{ dataIndex: 'PAY_TERMS'			, width: 100 },
			{ dataIndex: 'TERMS_PRICE'			, width: 100 },
			{ dataIndex: 'PASS_EXCHANGE_RATE'	, width: 100, hidden: true },
			{ dataIndex: 'PASS_AMT_UNIT'		, width: 100, hidden: true },
			{ dataIndex: 'PROJECT_NO'			, width: 100, hidden: true },
			{ dataIndex: 'PROJECT_NAME'			, width: 100, hidden: true },
			{ dataIndex: 'SO_SER_NO'			, width: 100 },
			{ dataIndex: 'LC_SER_NO'			, width: 100 },
			{ dataIndex: 'LC_NO'				, width: 100 },
			{ dataIndex: 'BL_SER_NO'			, width: 100, hidden: true },
			{ dataIndex: 'BL_NO'				, width: 100 },
			{ dataIndex: 'REMARKS1'				, width: 100, hidden: true },
			{ dataIndex: 'REMARKS2'				, width: 100, hidden: true },
			{ dataIndex: 'REMARKS3'				, width: 100, hidden: true },
			//20191202 추가
			{ dataIndex: 'PASS_AMT'				, width: 100 }
		],
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
				orderNoMasterGrid.returnData(record);
			}
		},
		returnData: function(record) {

			panelResult.setValue('DIV_CODE'			, record.get('DIV_CODE'));
			panelSearch.setValue('PASS_INCOM_NO'	, record.get('PASS_INCOM_NO'));
			panelResult.setValue('PASS_INCOM_NO'	, record.get('PASS_INCOM_NO'));
			var grdRecord = masterGrid.getSelectedRecord();
			  grdRecord.set('BASIC_PAPER_NO', record.get('PASS_INCOM_NO'));
			  grdRecord.set('DIV_CODE', record.get('DIV_CODE'));
			  grdRecord.set('PROJECT_NO', record.get('PROJECT_NO'));
			  grdRecord.set('BL_SER_NO', record.get('BL_SER_NO'));
			  grdRecord.set('BL_NO', record.get('BL_NO'));
			  grdRecord.set('LC_NO', record.get('LC_NO'));
			  grdRecord.set('OFFER_SER_NO', record.get('SO_SER_NO'));
			  grdRecord.set('TRADE_CUSTOM_CODE', record.get('EXPORTER'));
			  grdRecord.set('TRADE_CUSTOM_NAME', record.get('EXPORTER_NM'));

			PassInconWindow.hide();
		}
	});

	function openPassInconWindow(param) {
		if(!PassInconWindow) {
			PassInconWindow = Ext.create('widget.uniDetailWindow', {
				title	: '통관관리번호',
				width	: 1080,
				height	: 650,
				layout	: {type:'vbox', align:'stretch'},
				items	: [orderNoSearch, orderNoMasterGrid], //orderNoDetailGrid],
				tbar	: ['->',{
					itemId	: 'saveBtn',
					text	: '<t:message code="system.label.trade.inquiry" default="조회"/>',
					handler	: function() {
						orderNoMasterStore.loadStoreRecords();
					},
					disabled: false
				},{
					itemId	: 'OrderOkBtn',
					text	: '적용',
					handler	: function() {
						if(!Ext.isEmpty(orderNoMasterGrid.getSelectedRecord())){
							orderNoMasterGrid.returnData(orderNoMasterGrid.getSelectedRecord());
						}
					},
					disabled: false
				}, {
					itemId	: 'OrderNoCloseBtn',
					text	: '<t:message code="system.label.trade.close" default="닫기"/>',
					handler	: function() {
						PassInconWindow.hide();
					},
					disabled: false
				}],
				listeners : {
					beforehide: function(me, eOpt)	{
						orderNoSearch.clearForm();
						orderNoMasterGrid.reset();
					},
					beforeclose: function( panel, eOpts )	{
						orderNoSearch.clearForm();
						orderNoMasterGrid.reset();
					},
					show: function( panel, eOpts )	{
						orderNoSearch.setValues({
							'DIV_CODE'			: panelSearch.getValue('DIV_CODE'),
							'INVOICE_DATE_FR'	: UniDate.get('startOfMonth'),
							'INVOICE_DATE_TO'	: UniDate.get('today')
						});
						orderNoMasterStore.loadStoreRecords();
					}
				}
			})
		}
		PassInconWindow.center();
		PassInconWindow.show();
	}

	Unilite.createValidator('validator01', {
		store	: directMasterStore1,
		grid	: masterGrid,
		validate: function( type, fieldName, newValue, lastValidValue, record, form, field) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'lastValidValue':lastValidValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "CHARGE_TYPE":
					record.set('BASIC_PAPER_NO', '');
				break;
				case "CHARGE_CODE":

				break;
				case "CHARGE_AMT" :
					if(newValue != ''){
						if(isNaN(newValue)){
							rv='<t:message code="unilite.msg.sMB074"/>';
							break;
						}
						if(Ext.isEmpty(record.get('TAX_CLS'))){
							rv = '<t:message code="system.message.purchase.message103" default="증빙유형을 입력해주세요."/>';
							break;
						}
						//20191216 신규함수 호출하도록 변경
						fnCalAmt(null, newValue, record);
//						var huilv=record.get("EXCHANGE_RATE");
//						var dUnit = record.get('AMT_UNIT');
//						record.set("CHARGE_AMT_WON"	, UniMatrl.fnExchangeApply(dUnit,newValue*huilv));
//						record.set("SUPPLY_AMT"		, UniMatrl.fnExchangeApply(dUnit,newValue*huilv));
////						charget_amtSUM();
//						var TAX_RATE=record.get("TAX_RATE");
//						if(TAX_RATE!=0) {
//							record.set("VAT_AMT",parseInt(huilv*newValue*(TAX_RATE/100)));
//						}
//						//20191120 총지급액 컬럼 추가
//						record.set("SUPPLY_TOTAL_AMT"	, record.get('SUPPLY_AMT') + record.get('VAT_AMT'));
					}
					break;
				case "CHARGE_AMT_WON" :
					if(newValue != ''){
						if(isNaN(newValue)){  //非数字
							rv='<t:message code="unilite.msg.sMB074"/>';
							break;
						}
						if(Ext.isEmpty(record.get('TAX_CLS'))){
							rv='<t:message code="system.message.purchase.message103" default="증빙유형을 입력해주세요."/>';
							break;
						}
						//20191216 추가
						var digit			= UniFormat.Price.indexOf(".") == -1 ? UniFormat.Price.length : UniFormat.Price.indexOf(".") + 1;
						var numDigitOfPrice	= UniFormat.Price.length - digit;
						record.set('SUPPLY_AMT'			, newValue);
						record.set('VAT_AMT'			, UniSales.fnAmtWonCalc(Unilite.multiply(record.get('SUPPLY_AMT'), record.get('TAX_RATE')) / 100, '3', numDigitOfPrice));
						record.set('SUPPLY_TOTAL_AMT'	, record.get('SUPPLY_AMT') + record.get('VAT_AMT'));
					}
				break;
				//20191216 수정불가로 변경
//				case "SUPPLY_AMT" :
//					if(newValue != ''){
//						if(isNaN(newValue)){  //非数字
//							rv='<t:message code="unilite.msg.sMB074"/>';
//							break;
//						}
//						if(Ext.isEmpty(record.get('TAX_CLS'))){
//							rv='<t:message code="system.message.purchase.message103" default="증빙유형을 입력해주세요."/>';
//							break;
//						}
//						var TAX_RATE=record.get("TAX_RATE");
//						if(TAX_RATE!=0) {
//							record.set("VAT_AMT"		, parseInt(newValue*(TAX_RATE/100)));
//						}
//						//20191120 총지급액 컬럼 추가
//						record.set("SUPPLY_TOTAL_AMT"	, newValue + record.get('VAT_AMT'));
//					}
//				break;
				case "VAT_AMT" :
					//20191218 수정
					if(newValue == ''){
						newValue = 0;
					}
					if(isNaN(newValue)){  //非数字
						rv='<t:message code="unilite.msg.sMB074"/>';
						break;
					}
					if(Ext.isEmpty(record.get('TAX_CLS'))){
						rv='<t:message code="system.message.purchase.message103" default="증빙유형을 입력해주세요."/>';
						break;
					}
					newValue=Math.round(newValue);		//floor??
					//20191120 부가세는 원단위 절사
					record.set("VAT_AMT"			, newValue);
					//20191120 총지급액 컬럼 추가
					record.set("SUPPLY_TOTAL_AMT"	, newValue + record.get('SUPPLY_AMT'));
//					charget_amtSUM();
				break;
				case "AMT_UNIT" :
					if(newValue != ''){
						//20191216 fnExchngRateO에서 신규 함수호출 하도록 변경
						UniAppManager.app.fnExchngRateO(newValue, null, record);
					}
				break;
				case "EXCHANGE_RATE" :
					if(newValue != ''){
						if(isNaN(newValue)){  //非数字
							rv='<t:message code="unilite.msg.sMB074"/>';
							break;
						}
						var CHARGE_AMT	= record.get("CHARGE_AMT");
						var dUnit		= record.get('AMT_UNIT');
						//20191218 수정
						var chargeAmtWon= UniSales.fnAmtWonCalc(UniMatrl.fnExchangeApply(dUnit, Unilite.multiply(newValue, CHARGE_AMT)), BsaCodeInfo.gsTradeCalcMethod, numDigitOfPrice);
						record.set("CHARGE_AMT_WON"	, chargeAmtWon);
						record.set("SUPPLY_AMT"		, chargeAmtWon);
//
						var TAX_RATE=record.get("TAX_RATE");
						//20191218 주석
//						if(TAX_RATE!=0)
						record.set("VAT_AMT"			, UniSales.fnAmtWonCalc(Unilite.multiply(chargeAmtWon, (TAX_RATE/100)), BsaCodeInfo.gsTradeCalcMethod , numDigitOfPrice));
						//20191218 추가
						record.set('SUPPLY_TOTAL_AMT'	, record.get('SUPPLY_AMT') + record.get('VAT_AMT'));
					}
				break;
				case "TAX_CLS":
					if(newValue !=''){
					}
					//20191120 증빙유형 선택 시, tax_rate set하는 로직 추가(아래로직 전체 추가)
					var store		= Ext.StoreManager.lookup('CBS_AU_A022');
					var basisRecord	= store.findBy(function(item){
						if(item.get('value') == newValue) {
							record.set('TAX_RATE', item.get('refCode2'));
							return
						}
					});
					var digit			= UniFormat.Price.indexOf(".") == -1 ? UniFormat.Price.length : UniFormat.Price.indexOf(".") + 1;
					var numDigitOfPrice	= UniFormat.Price.length - digit;
					var suplyAmt		= record.get('SUPPLY_AMT');
					var taxRate			= record.get('TAX_RATE');
					record.set('VAT_AMT'			, UniSales.fnAmtWonCalc(Unilite.multiply(suplyAmt, (taxRate/100)), '3', numDigitOfPrice));
					record.set('SUPPLY_TOTAL_AMT'	, suplyAmt + record.get('VAT_AMT'));
				break;
				//20191216 추가
				case "OCCUR_DATE":		//환율가져와서 재계산
					if(Ext.isDate(newValue)) {
						UniAppManager.app.fnExchngRateO(null, newValue, record);
					}
				break;

			}
			return rv;
		}
	});
};
</script>