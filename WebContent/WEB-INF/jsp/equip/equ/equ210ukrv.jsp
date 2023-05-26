<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="equ210ukrv"  >
	<t:ExtComboStore comboType="BOR120"  />							<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="I801" />				<!-- 장비상태 -->
	<t:ExtComboStore comboType="AU" comboCode="I802" />				<!-- 목형종류 -->
	<t:ExtComboStore comboType="AU" comboCode="I803" />				<!-- 목형재질 -->
	<t:ExtComboStore comboType="AU" comboCode="I804" />				<!-- 폐기구분 -->
	<t:ExtComboStore comboType="AU" comboCode="WB08" />				<!-- 구분 -->
	<t:ExtComboStore items="${COMBO_WS_LIST}" storeId="wsList" />	<!-- 작업장 -->
</t:appConfig>

<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
.x-grid-cell_red {
	background-color: #ff5500;
	//color:white;
}
.x-grid-cell_yellow {
	background-color: #ffff66;
	//color:white;
}
.x-grid-cell_black {
	background-color: #eee;
	//color:white;
}
</style>

<script type="text/javascript" >

var SearchInfoWindow, RefSearchWindow , otherRefSearchWindow;
var excelWindow;
var gImportType, gNationInout ;
var gsDel = '';
var gbRetrieved='';
var isLoad = false; //로딩 플래그 화폐단위 환율 change 로드시 계속 타므로 임시로 막음
var BsaCodeInfo = {
	gsDefaultMoney	: '${gsDefaultMoney}',
	gsAutoNumber	: '${gsAutoNumber}',
	agreePrsn		: '${agreePrsn}',

	gsLotNoInputMethod: '${MNG_LOT}',
	gsLotNoEssential: '${ESS_YN}',
	gsEssItemAccount: '${ESS_ACCOUNT}',
	gsOrderConfirm	: '${gsOrderConfirm}'
};

var outDivCode = UserInfo.divCode;
var aa = 0;
var agreePrsn = '';
var agreeStatus = '';
var agreeDate = '';
var selectRecordCode;

var BsaCodeInfo = {
		gsUseWorkColumnYn	: '${gsUseWorkColumnYn}',	//작업 관련컬럼(작업자, 작업호기, 작업시간, 주야구분) 사용여부
		gsAutoType			: '${gsAutoType}',
		gsAutoNo			: '${gsAutoNo}',			//생산자동채번여부
		gsBadInputYN		: '${gsBadInputYN}',		//자동입고시 불량입고 반영여부
		gsChildStockPopYN	: '${gsChildStockPopYN}',	//자재부족수량 팝업 호출여부
		gsShowBtnReserveYN	: '${gsShowBtnReserveYN}',	//BOM PATH 관리여부
		gsManageLotNoYN		: '${gsManageLotNoYN}',		//재고와 작업지시LOT 연계여부

		gsLotNoInputMethod	: '${gsLotNoInputMethod}',	//LOT 연계여부
		gsLotNoEssential	: '${gsLotNoEssential}',
		gsEssItemAccount	: '${gsEssItemAccount}',

		gsLinkPGM			: '${gsLinkPGM}',			//등록 PG 내 링크 ID 설정
		gsGoodsInputYN		: '${gsGoodsInputYN}',		//상품등록 가능여부
		gsSetWorkShopWhYN	: '${gsSetWorkShopWhYN}',	//작업장의 가공창고 설정여부
		gsMoldCode			: '${gsMoldCode}',			//작업지시 설비여부
		gsEquipCode			: '${gsEquipCode}',			//작업지시 금형여부
		gsReportGubun		: '${gsReportGubun}',		//레포트 구분
		gsCompName			: '${gsCompName}',			//출력 관련해서 제이월드 report만 따로 사용... 하기 위해 comp_name 가져오는 로직

		gsSiteCode			: '${gsSiteCode}',
		gsIfCode			: '${gsIfCode}',            //작업지시데이터 연동여부
		gsIfSiteCode		: '${gsIfSiteCode}'         //작업지시데이터 연동주소
	};

function appMain() {
	var directProxy1 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'equ210ukrvService.selectList',
			update	: 'equ210ukrvService.updateDetail',
			create	: 'equ210ukrvService.insertDetail',
			destroy	: 'equ210ukrvService.deleteDetail',
			syncAll	: 'equ210ukrvService.saveAll'
		}
	});

	var isMoldCode = false;
	if(BsaCodeInfo.gsMoldCode=='N') {
		isMoldCode = true;
	}


	Unilite.defineModel('equ210ukrvModel1', {
		fields: [
			{name: 'GUBUN'				, text: '<t:message code="system.label.equipment.type" default="구분"/>'					, type: 'string'	,comboType:'AU'		,comboCode:'WB08'},
			{name: 'COMP_CODE'			, text: '<t:message code="system.label.equipment.compcode" default="법인코드"/>'			, type: 'string'	,isPk:true},
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.equipment.division" default="사업장"/>'				, type: 'string'	,isPk:true},
			{name: 'WORK_SHOP_CODE'		, text: '<t:message code="system.label.product.workcenter" default="작업장"/>'				, type: 'string'	,allowBlank:false	,comboType:'AU'		,store: Ext.data.StoreManager.lookup('wsList')},

			{name: 'EQU_CODE'			,text: '<t:message code="system.label.product.moldcode" default="금형코드"/>'			,type:'string', allowBlank: true},
			{name: 'EQU_NAME'			,text: '<t:message code="system.label.product.moldname" default="금형명"/>'			 ,type:'string', allowBlank: true},


		//	{name: 'EQU_CODE'			, text: '<t:message code="system.label.equipment.equipcodemold" default="장비(금형)코드"/>'	, type: 'string'	,allowBlank:false},
		//	{name: 'EQU_NAME'			, text: '<t:message code="system.label.equipment.equipnamemold" default="장비(금형)명"/>'	, type: 'string'},
			{name: 'EQU_SPEC'			, text: '<t:message code="system.label.equipment.spec" default="규격"/>'					, type: 'string'},
		//	{name: 'WOODEN_CODE'		, text: '<t:message code="system.label.equipment.woodencode" default="목형코드"/>'			, type: 'string'	,allowBlank:false},
		//	{name: 'SN_NO'				, text: 'S/N (LOT)'		, type: 'string'	,allowBlank:false},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.equipment.itemcode" default="품목코드"/>'			, type: 'string'	,allowBlank:true},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.equipment.itemname" default="품목명"/>'				, type: 'string'},
			{name: 'EQU_GUBUN'			, text: '<t:message code="system.label.equipment.woodendivision" default="목형구분"/>'		, type: 'string'	,comboType:'AU'		,comboCode:'I802'},
			{name: 'INSTOCK_DATE'		, text: '<t:message code="system.label.equipment.receiptdate" default="입고일"/>'			, type: 'uniDate'},
			{name: 'EQU_GRADE'			, text: '<t:message code="system.label.equipment.status" default="상태"/>'				, type: 'string'	,comboType:'AU'		,comboCode:'I801'},
			{name: 'TOT_PUNCH_Q'		, text: '<t:message code="system.label.equipment.totalpunchcount" default="총타발수"/>'		, type: 'uniQty'},
			{name: 'MIN_PUNCH_Q'		, text: '<t:message code="system.label.equipment.punchcount" default="타발수"/>' + 'Min'	, type: 'uniQty'},
			{name: 'MAX_PUNCH_Q'		, text: '<t:message code="system.label.equipment.punchcount" default="타발수"/>' + 'Max'	, type: 'uniQty'},
			{name: 'DISPOSAL_DATE'		, text: '<t:message code="system.label.equipment.disposaldate" default="폐기일자"/>'		, type: 'uniDate'},
			{name: 'DISPOSAL_GUBUN'		, text: '<t:message code="system.label.equipment.disposalreason" default="폐기구분"/>'		, type: 'string'	,comboType:'AU'		,comboCode:'I804'},
			{name: 'REMARK'				, text: '<t:message code="system.label.equipment.etc" default="기타"/>'					, type: 'string'},

			//원래 컬럼
			{name: 'MODEL_CODE'			, text: '대표모델'			, type: 'string'},
			{name: 'CUSTOM_CODE'		, text: '제작처'			, type: 'string'},
			{name: 'CUSTOM_NAME'		, text: '제작처명'			, type: 'string'},
			{name: 'PRODT_DATE'			, text: '제작일'			, type: 'uniDate'},
			{name: 'PRODT_Q'			, text: '제작수량'			, type: 'uniQty'},
			{name: 'PRODT_O'			, text: '제작금액'			, type: 'uniUnitPrice'},
			{name: 'REP_O'				, text: '수리금액'			, type: 'uniUnitPrice'},
			{name: 'ASSETS_NO'			, text: '자산번호'			, type: 'string'},
			{name: 'WEIGHT'				, text: '장비중량'			, type: 'uniQty'},
			{name: 'EQU_PRSN'			, text: '담당자'			, type: 'string'},
			{name: 'EQU_TYPE'			, text: '금형종류'			, type: 'string'},
			{name: 'MTRL_TYPE'			, text: '금형재질'			, type: 'string'},
			{name: 'MTRL_TEXT'			, text: '재질_비고'			, type: 'string'},
			{name: 'BUY_COMP'			, text: '매입처'			, type: 'string'},
			{name: 'BUY_DATE'			, text: 'BUY_DATE'		, type: 'uniDate'},
			{name: 'BUY_AMT'			, text: '매입액'			, type: 'uniUnitPrice'},
			{name: 'SELL_DATE'			, text: '매각일'			, type: 'uniDate'},
			{name: 'SELL_AMT'			, text: '매각액'			, type: 'uniUnitPrice'},
			{name: 'ABOL_DATE'			, text: '폐기일'			, type: 'uniDate'},
			{name: 'ABOL_AMT'			, text: '폐기액'			, type: 'uniUnitPrice'},
			{name: 'CAPA'				, text: '한도수량'			, type: 'uniUnitPrice'},
			{name: 'WORK_Q'				, text: '사용수량'			, type: 'uniQty'},
			{name: 'CAVIT_BASE_Q'		, text: '캐비티수량'			, type: 'uniQty'},
			{name: 'TRANS_DATE'			, text: '이동날자'			, type: 'uniDate'},
			{name: 'FROM_DIV_CODE'		, text: '이관사업장'			, type: 'string'},
			{name: 'USE_CUSTOM_CODE'	, text: '보관처'			, type: 'string'},
			{name: 'USE_CUSTOM_NAME'	, text: '보관처'			, type: 'string'},
			{name: 'INSERT_DB_USER'		, text: '입력자'			, type: 'string'},
			{name: 'INSERT_DB_TIME'		, text: '입력일자'			, type: 'string'},
			{name: 'UPDATE_DB_USER'		, text: '수정자'			, type: 'string'},
			{name: 'UPDATE_DB_TIME'		, text: '수정일자'			, type: 'string'},
			{name: 'TEMPC_01'			, text: '여분필드01'		, type: 'string'},
			{name: 'TEMPC_02'			, text: '여분필드02'		, type: 'string'},
			{name: 'TEMPC_03'			, text: '여분필드03'		, type: 'string'},
			{name: 'TEMPN_01'			, text: '여분필드01'		, type: 'uniUnitPrice'},
			{name: 'TEMPN_02'			, text: '여분필드02'		, type: 'uniUnitPrice'},
			{name: 'TEMPN_03'			, text: '여분필드03'		, type: 'uniUnitPrice'},

			//이미지 관련
			{name: 'IMAGE_FID'			, text: '사진FID'			, type: 'string'},
 			{name: '_fileChange'		, text: '사진저장체크' 		, type: 'string'	,editable:false},
 			{name: 'STATUS'				, text: '<t:message code="system.label.equipment.status" default="상태"/>'			, type: 'string'	,editable:false}
		]
	});



	/** Store 정의(Service 정의)
	* @type
	*/
	var directMasterStore1 = Unilite.createStore('equ210ukrvMasterStore1',{
		model	: 'equ210ukrvModel1',
		proxy	: directProxy1,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결
			editable	: true,		// 수정 모드 사용
			deletable	: true,		// 삭제 가능 여부
			allDeletable: false,	// 전체 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용

		},
		autoLoad: false,
		listeners:{
			load: function(store, records, successful, eOpts){
				detailForm.setReadOnly(false);
				detailForm.getField('WOODEN_CODE').setReadOnly(true);
				detailForm.getField('SN_NO').setReadOnly(true);
				//쿼리로 이동
//				if(!Ext.isEmpty(records)) {
//					Ext.each(records, function(record, idex) {
//						if(Unilite.nvl(record.get('TOT_PUNCH_Q'), 0) < Unilite.nvl(record.get('MIN_PUNCH_Q'), 0) && record.get('EQU_GRADE') != 'C') {			//총타발수 < min 타발수 - 정상
//							record.set('STATUS', '<t:message code="system.label.equipment.normal" default="정상"/>');
//
//						} else if(Unilite.nvl(record.get('TOT_PUNCH_Q'), 0) > Unilite.nvl(record.get('MAX_PUNCH_Q'), 0)
//								|| record.get('EQU_GRADE') == 'C') {														//총타발수 > max 타발수이거나 상태가 폐기이면 - 폐기
//							record.set('STATUS', '<t:message code="system.label.equipment.disposal" default="폐기"/>');
//
//						} else {													//정상
//							record.set('STATUS', '<t:message code="system.label.equipment.attention" default="주의"/>');
//						}
//						directMasterStore1.commitChanges();
//					});
//				}
			},
			add: function(store, records, index, eOpts) {
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
			},
			remove: function(store, record, index, isMove, eOpts) {
			}
		},
		loadStoreRecords: function() {
			var param= Ext.getCmp('resultForm').getValues();
			console.log( param );
			this.load({
				params: param,
				callback:function(records, operation, success)	{
					if(success){
						if(!Ext.isEmpty(selectRecordCode)){
							var items = directMasterStore1.data.items
							Ext.each(items,function(item,i){
								if(item.data.EQU_CODE == selectRecordCode){
									masterGrid.getSelectionModel().select(item);
									return false;
								}
							});

						} else {
							masterGrid.getSelectionModel().select(0);
						}
					}
				}
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
				var paramMaster= panelResult.getValues();	//syncAll 수정
				config = {
					params	: [paramMaster],
					success	: function(batch, option) {
						UniAppManager.setToolbarButtons('save', false);

//						if (directMasterStore1.count() == 0) {
//							UniAppManager.app.onResetButtonDown();
//						}else{
//							panelResult.setAllFieldsReadOnly(true);
//							directMasterStore1.loadStoreRecords();
//						}
					}
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('equ210ukrvGrid1');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});//End of var directMasterStore1 = Unilite.createStore('equ210ukrvMasterStore1',{



	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 3,	rows:2, tableAttrs: { /*style: { width: '100%', height:'100%' }*/ }},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel	: '<t:message code="system.label.equipment.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.product.moldcode" default="금형코드"/>',
			xtype		: 'uniTextfield',
			name		: 'EQU_CODE',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},
		Unilite.popup('DIV_PUMOK',{
			fieldLabel		: '<t:message code="system.label.equipment.item" default="품목"/>',
			validateBlank	: false,
			valueFieldName	: 'ITEM_CODE',
			textFieldName	: 'ITEM_NAME'
		}),{
			fieldLabel	: '작업장',
			name		: 'WORK_SHOP_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			store		: Ext.data.StoreManager.lookup('wsList'),
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.equipment.status" default="상태"/>',
			name		: 'EQU_GRADE',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'I801',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
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
						var labelText = invalid.items[0]['fieldLabel']+':';
					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
						var labelText = invalid.items[0].ownerCt['fieldLabel']+':';
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
						if(item.isPopupField)	{
							var popupFC = item.up('uniPopupField');
							if(popupFC.holdable == 'hold') {
								popupFC.setReadOnly(true);
							}
						}
					})
				}

			} else {
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) )	{
					 	if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					}
					if(item.isPopupField)	{
						var popupFC = item.up('uniPopupField');
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		},
		listeners: {
			collapse: function () {
				panelResult.show();
			},
			expand: function() {
				panelResult.hide();
			}
		}
	});		// end of var panelResult = Unilite.createSearchForm('resultForm',{



	var masterGrid = Unilite.createGrid('equ210ukrvGrid1', {
		title	: '',
		layout	: 'fit',
		region	: 'center',
		store	: directMasterStore1,
		uniOpt	: {
			useGroupSummary		: false,
			useLiveSearch		: true,
			useContextMenu		: false,
			useMultipleSorting	: true,
			useRowNumberer		: true,
			expandLastColumn	: true,
			onLoadSelectFirst	: false,
			filter: {
				useFilter	: false,
				autoCreate	: false
			},
			excel: {
				useExcel	  : true,		//엑셀 다운로드 사용 여부
				exportGroup   : true, 		//group 상태로 export 여부
				onlyData	  : false,
				summaryExport : true
			}
		},
		columns: [
			{dataIndex: 'WORK_SHOP_CODE'	, width: 80},
			{dataIndex: 'GUBUN'				, width: 80},
			{dataIndex: 'COMP_CODE'			, width: 120	,hidden:true},
			{dataIndex: 'DIV_CODE'			, width: 120	,hidden:true},
		//	{dataIndex: 'EQU_CODE'			, width: 120	,hidden:true},
			{dataIndex: 'EQU_CODE'			, width: 110, hidden: isMoldCode
				,'editor' : Unilite.popup('EQU_MOLD_CODE_G',{
							textFieldName:'EQU_MOLD_NAME',
							DBtextFieldName: 'EQU_MOLD_NAME',
							autoPopup: true,
							listeners: {'onSelected': {
									fn: function(records, type) {
										grdRecord = masterGrid.getSelectedRecord();
										Ext.each(records, function(record,i) {
											grdRecord.set('EQU_CODE',records[0]['EQU_MOLD_CODE']);
											grdRecord.set('EQU_NAME',records[0]['EQU_MOLD_NAME']);
											grdRecord.set('EQU_SPEC',records[0]['EQU_SPEC']);
										});
									},
									scope: this
								},
								'onClear': function(type) {
									grdRecord = masterGrid.getSelectedRecord();
									grdRecord.set('EQU_CODE', '');
									grdRecord.set('EQU_NAME', '');
									grdRecord.set('EQU_SPEC', '');
								},
								applyextparam: function(popup){
									var param =panelResult.getValues();
									popup.setExtParam({'DIV_CODE': param.DIV_CODE});
								}
							}
				})
			},
			{dataIndex: 'EQU_NAME'			, width: 200, hidden: isMoldCode
				,'editor' : Unilite.popup('EQU_MOLD_CODE_G',{
							textFieldName:'EQU_MOLD_NAME',
							DBtextFieldName: 'EQU_MOLD_NAME',
							autoPopup: true,
							listeners: {'onSelected': {
									fn: function(records, type) {
										grdRecord = masterGrid.getSelectedRecord();
										Ext.each(records, function(record,i) {
											grdRecord.set('EQU_CODE',records[0]['EQU_MOLD_CODE']);
											grdRecord.set('EQU_NAME',records[0]['EQU_MOLD_NAME']);
											grdRecord.set('EQU_SPEC',records[0]['EQU_SPEC']);
										});
									},
									scope: this
								},
								'onClear': function(type) {
									grdRecord = masterGrid.getSelectedRecord();
									grdRecord.set('EQU_CODE', '');
									grdRecord.set('EQU_NAME', '');
									grdRecord.set('EQU_SPEC', '');
								},
								applyextparam: function(popup){
									var param =panelResult.getValues();
									popup.setExtParam({'DIV_CODE': param.DIV_CODE});
								}
							}
				})
			},
		//	{dataIndex: 'WOODEN_CODE'		, width: 120},
		//	{dataIndex: 'SN_NO'				, width: 120},
			{dataIndex: 'ITEM_CODE'			, width: 130	,
				editor: Unilite.popup('DIV_PUMOK_G', {
					textFieldName	: 'ITEM_CODE',
					DBtextFieldName	: 'ITEM_CODE',
					autoPopup		: true,
					listeners		: {
						'onSelected': {
							fn: function(records, type) {
								console.log('records : ', records);
								var grdRecord = masterGrid.uniOpt.currentRecord;
								grdRecord.set('ITEM_CODE', records[0]['ITEM_CODE']);
								grdRecord.set('ITEM_NAME', records[0]['ITEM_NAME']);
							},
							scope: this
						},
						'onClear': function(type) {
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('ITEM_CODE', '');
							grdRecord.set('ITEM_NAME', '');
						},
						applyextparam: function(popup){
							popup.setExtParam({'POPUP_TYPE': 'GRID_CODE'});
							popup.setExtParam({'DIV_CODE': panelResult.getValue("DIV_CODE")});
						}
					}
				})
			 },
			{dataIndex: 'ITEM_NAME'			, width: 180,
				editor: Unilite.popup('DIV_PUMOK_G', {
					autoPopup	: true,
					listeners	: {
						'onSelected': {
							fn: function(records, type) {
								console.log('records : ', records);
								var grdRecord = masterGrid.uniOpt.currentRecord;
								grdRecord.set('ITEM_CODE', records[0]['ITEM_CODE']);
								grdRecord.set('ITEM_NAME', records[0]['ITEM_NAME']);
							},
							scope: this
						},
						'onClear': function(type) {
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('ITEM_CODE', '');
							grdRecord.set('ITEM_NAME', '');
						},
						applyextparam: function(popup){
							popup.setExtParam({'POPUP_TYPE': 'GRID_CODE'});
							popup.setExtParam({'DIV_CODE': panelResult.getValue("DIV_CODE")});
						}
					}
				})
			 },
			{dataIndex: 'EQU_GUBUN'			, width: 100},
			{dataIndex: 'INSTOCK_DATE'		, width: 80 },
			{dataIndex: 'EQU_GRADE'			, width: 80 },
			{dataIndex: 'TOT_PUNCH_Q'		, width: 120/*,
				renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
					if(Unilite.nvl(record.get('TOT_PUNCH_Q'), 0) < Unilite.nvl(record.get('MIN_PUNCH_Q'), 0)) {						//총타발수 < min 타발수 - 정상
						return '<span style="color:' + 'black' + ';">' +  val +'</span>';

					} else if(Unilite.nvl(record.get('TOT_PUNCH_Q'), 0) > Unilite.nvl(record.get('MAX_PUNCH_Q'), 0)) {				//총타발수 > max 타발수 - 폐기
						return '<span style="color:' + 'red' + ';">' +  val +'</span>';

					} else {													//정상
						return '<span style="color:' + 'yellow' + ';">' +  val +'</span>';
//						return '<span style="color:' + 'black' + ';">' +  '<b>' + val + '<b>' +'</span>';
					}
					return val;
				}*/
			},
			{dataIndex: 'MIN_PUNCH_Q'		, width: 120},
			{dataIndex: 'MAX_PUNCH_Q'		, width: 120},
			{dataIndex: 'DISPOSAL_DATE'		, width: 80 },
			{dataIndex: 'DISPOSAL_GUBUN'	, width: 80 },
			{dataIndex: 'STATUS'			, width: 80	, align: 'center'}
		],
		listeners: {
			beforeedit: function( editor, e, eOpts ) {
				if(e.record.phantom == false) {
  					if(UniUtils.indexOf(e.field, ['GUBUN', 'WOODEN_CODE', 'SN_NO'])) {
						return false;
  					}
				}
			},
			selectionchangerecord:function(selected) {
				selectRecordCode = selected.data.EQU_CODE;
				detailForm.setActiveRecord(selected);
				itemImageForm.setImage(selected.get('IMAGE_FID'));
			},
			onGridDblClick:function(grid, record, cellIndex, colName) {
				if(!record.phantom) {
					switch(colName)	{
					case 'WOODEN_CODE' :
					case 'SN_NO' :
						masterGrid.hide();
						break;
					default:
						break;
					}
				}
			},
			hide:function()	{
				detailForm.show();
			},
			edit: function(editor, e) {
				var record = masterGrid.getSelectedRecord();
				detailForm.setActiveRecord(record);
			}
		},
		viewConfig: {
			getRowClass: function(record, rowIndex, rowParams, store){
				var cls = '';

			  	if(Unilite.nvl(record.get('TOT_PUNCH_Q'), 0) < Unilite.nvl(record.get('MIN_PUNCH_Q'), 0) && record.get('EQU_GRADE') != 'C'){
					cls = '';
				}
				else if(Unilite.nvl(record.get('TOT_PUNCH_Q'), 0) > Unilite.nvl(record.get('MAX_PUNCH_Q'), 0) || record.get('EQU_GRADE') == 'C'){
					cls = 'x-change-cell_red';
				}
				else {
					cls = 'x-change-cell_dark';
				}

				return cls;
			}
		}
	});



	/** 상세 Form
	 */
	var itemImageForm = Unilite.createForm('equ200ImageForm' + 'itemImageForm', {
		fileUpload: true,
		//url:  CPATH+'/fileman/upload.do',
		api		:{ submit: equ210ukrvService.uploadPhoto},
		disabled: false,
		width	: 450,
		height	: 500,
		layout	: {type: 'uniTable', columns: 2},
		items	: [{
			xtype		: 'filefield',
			fieldLabel	: '<t:message code="system.label.equipment.photo" default="사진"/>',
			name		: 'fileUpload',
			hideLabel	: true,
			width		: 350,
			buttonText	: '<t:message code="system.label.commonJS.excel.btnText" default="파일선택"/>',
			buttonOnly	: false,
			listeners	: {
				change : function( filefield, value, eOpts )	{
					var fileExtention = value.lastIndexOf(".");
					//FIXME : 업로드 확장자 체크, 이미지파일만 upload
					if(value !='' )	{
						var record = masterGrid.getSelectedRecord();
						detailForm.setValue('_fileChange', 'true');
						//detailWin.setToolbarButtons(['saveBtn','saveCloseBtn'],true);
						//detailWin.setToolbarButtons(['prev','next'],false);
					}
				}
			}
		},{
			xtype	: 'button',
			text	: '<t:message code="system.label.base.uploadphoto" default="사진등록"/>',
			margin	: '0 0 2 2',
			handler	: function()	{
				if(Ext.isEmpty(detailForm.getValue('EQU_CODE')))	{
					alert('<t:message code="system.message.equipment.message001" default="장비(금형)번호가 없습니다. 저장 후, 사진을 올려주세요."/>')
					return;
				}
				itemImageForm.submit({
					params :{
						'DIV_CODE':detailForm.getValue('DIV_CODE'),
						'EQU_CODE':detailForm.getValue('EQU_CODE')
					},
					success : function()	{
						var selRecord = masterGrid.getSelectedRecord();
//							detailForm.loadForm(selRecord);				// 입력값 이외의 자동생성 필드가 있다면 반드시 넣어준다.

					UniAppManager.app.onQueryButtonDown();
					//detailWin.setToolbarButtons(['saveBtn','saveCloseBtn'],false);
					//detailWin.setToolbarButtons(['prev','next'],true);
					}
				});
			}
		},{
			xtype	: 'image',
			id		: 'equ200',
			src		: CPATH+'/resources/images/nameCard.jpg',
			width	: 400,
			overflow: 'auto',
			colspan	: 2
		}],
		setImage : function (fid)	{
			var image	= Ext.getCmp('equ200');
			var src		= CPATH+'/resources/images/nameCard.jpg';
			if(!Ext.isEmpty(fid))	{
				src= CPATH+'/equit/equPhoto/'+fid;
			}
			image.setSrc(src);
		}
	});

	var detailForm = Unilite.createForm('detailForm', {
		masterGrid	: masterGrid,
		hidden		: true,
		autoScroll	: true,
		flex		: 1,
		border		: false,
		layout		: {type: 'uniTable', columns: 3, tableAttrs:{cellpadding:5}, tdAttrs: {valign:'top'}},
		defaultType	: 'uniFieldset',
		uniOpt		: {
			store : directMasterStore1
		},
		api: {
			 load: 'equ210ukrvService.selectListForForm'
		},
		items : [{
			title	: '',
			colspan	: 1,
			layout	: {
				type	: 'uniTable',
				columns	: 2
			},
			width	: 600,
			height	: 400,
			padding	: '10 0 0 0',
			defaults: { type:'uniTextfield'},
			items	: [{
				fieldLabel	: '<t:message code="system.label.equipment.compcode" default="법인코드"/>',
				xtype		: 'uniTextfield',
				name		: 'COMP_CODE',
				hidden		: true
			},{
				fieldLabel	: '<t:message code="system.label.equipment.division" default="사업장"/>',
				xtype		: 'uniTextfield',
				name		: 'DIV_CODE',
				hidden		: true
			},{
				fieldLabel	: '<t:message code="system.label.equipment.equipcodemold" default="장비(금형)코드"/>',
				xtype		: 'uniTextfield',
				name		: 'EQU_CODE',
				hidden		: true
			},{
				fieldLabel	: '<t:message code="system.label.equipment.woodencode" default="목형코드"/>',
				xtype		: 'uniTextfield',
				name		: 'WOODEN_CODE',
				allowBlank	: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						detailForm.setValue('EQU_CODE', newValue + '-' + detailForm.getValue('SN_NO'));
					}
				}
			},
			Unilite.popup('DIV_PUMOK',{
				fieldLabel		: '<t:message code="system.label.equipment.productionitem" default="생산품목"/>',
				valueFieldName	: 'ITEM_CODE',
				textFieldName	: 'ITEM_NAME',
				allowBlank		: true
			}),{
				fieldLabel	: 'S/N (LOT)',
				xtype		: 'uniTextfield',
				name		: 'SN_NO',
				allowBlank	: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						detailForm.setValue('EQU_CODE',  detailForm.getValue('WOODEN_CODE') + '-' + newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.equipment.receiptdate" default="입고일"/>',
				xtype		: 'uniDatefield',
				name		: 'INSTOCK_DATE'
			},{
//				xtype	: 'container',
//				padding	: '0 0 0 0',
//				items	: [{
					fieldLabel	: '<t:message code="system.label.equipment.availablepunchquantity" default="타발가능수량"/>' + ' ' + 'Min',
					xtype		: 'uniNumberfield',
					name		: 'MIN_PUNCH_Q',
					decimalPrecision: 0,
					hidden		: false
				},{
					fieldLabel	: '~ Max',
					xtype		: 'uniNumberfield',
					name		: 'MAX_PUNCH_Q',
					decimalPrecision: 0,
					hidden		: false
//				}]
			},{
				fieldLabel	: '<t:message code="system.label.equipment.woodendivision" default="목형구분"/>',
				xtype		: 'uniCombobox',
				name		: 'EQU_GUBUN',
				comboType	: 'AU',
				comboCode	: 'I802'
			},{
				fieldLabel	: '<t:message code="system.label.equipment.status" default="상태"/>',
				xtype		: 'uniCombobox',
				name		: 'EQU_GRADE',
				comboType	: 'AU',
				comboCode	: 'I801'
			},{
				fieldLabel	: '<t:message code="system.label.equipment.disposaldate" default="폐기일자"/>',
				xtype		: 'uniDatefield',
				name		: 'DISPOSAL_DATE',
				hidden		: false
			},{
				fieldLabel	: '<t:message code="system.label.equipment.disposalreason" default="폐기구분"/>',
				xtype		: 'uniCombobox',
				name		: 'DISPOSAL_GUBUN',
				comboType	: 'AU',
				comboCode	: 'I804'
			}]
		},{
			title	: '',
			colspan	: 2,
			height	: 400,
			layout	: {
				type	: 'uniTable',
				columns	: 1,
				tdAttrs	: {valign:'top'}

			},
			defaults: {type: 'uniTextfield'},
			items	: [
				itemImageForm,
				{
					name		: '_fileChange',
					fieldLabel	: '사진수정여부',
					hidden		: true
				}
			]
		}],
		loadForm: function(record)	{
			itemImageForm.setImage(record.get('IMAGE_FID'));
		}
	});





	Unilite.Main( {
		id			: 'equ210ukrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				panelResult,{
				region	: 'center',
				title	: '',
				layout	: {type:'vbox', align:'stretch'},
				flex	: 1,
				autoScroll:true,
				tools	: [{
					type	: 'hum-grid',
					handler	: function () {
						detailForm.hide();
						masterGrid.show();
						panelResult.show();
						UniAppManager.setToolbarButtons(['newData'], true);
					}
				},{
					type	: 'hum-photo',
					handler	: function () {
						masterGrid.hide();
						panelResult.show();
						detailForm.show();
						if(masterGrid.getSelectedRecord()){
							detailForm.setActiveRecord(masterGrid.getSelectedRecord());
							var contrlNo = masterGrid.getSelectedRecord().get("EQU_CODE");
//							panelResult.setValue("EQU_CODE", contrlNo);
							if(contrlNo){
								UniAppManager.app.onLoadForm();
							}
						}
						UniAppManager.setToolbarButtons(['newData'], true);
					}
				}],
				items:[
					masterGrid,
					detailForm
				]
			}]
		}],
		fnInitBinding: function(params) {
			panelResult.setValue('DIV_CODE', UserInfo.divCode);

			UniAppManager.setToolbarButtons(['newData','reset'], true);
			UniAppManager.setToolbarButtons(['save','deleteAll'], false);
		},

		onQueryButtonDown: function() {
			if(!panelResult.getInvalidMessage()){
				return false;
			}
			masterGrid.getStore().loadStoreRecords();
		},
		onLoadForm: function(){
		},
		onResetButtonDown: function() {
			masterGrid.getStore().loadData({});
//			masterGrid.reset();
			panelResult.clearForm();
			detailForm.clearForm();;
			detailForm.setReadOnly(true);
			this.fnInitBinding();

		},
		onNewDataButtonDown: function()	{
			if(!panelResult.getInvalidMessage()){
				return false;
			}
			detailForm.setReadOnly(false);
			detailForm.getField('WOODEN_CODE').setReadOnly(false);
			detailForm.getField('SN_NO').setReadOnly(false);

			var r = {
				'COMP_CODE'		: UserInfo.compCode,
				'DIV_CODE'		: panelResult.getValue("DIV_CODE"),
				'INSTOCK_DATE'	: UniDate.get("today")
			};
			masterGrid.createRow(r);
		},

		onSaveDataButtonDown: function(config) {
			if(itemImageForm.isDirty())	{
				itemImageForm.submit({
					waitMsg: 'Uploading...',
					success: function(form, action) {
						if( action.result.success === true)	{
							masterGrid.getSelectedRecord().set('IMAGE_FID',action.result.fid);
							directMasterStore1.saveStore(config);
							itemImageForm.setImage(action.result.fid);
							itemImageForm.clearForm();
						}
					}
				});
			} else {
				directMasterStore1.saveStore();
			}
		},
		onDeleteDataButtonDown: function() {
			var selRow = masterGrid.getSelectedRecord();
			if(selRow.phantom === true)	{
				masterGrid.deleteSelectedRow();
			}else {
				if(selRow.get('CLOSE_FLAG') == 'Y'){
					Ext.Msg.alert('<t:message code="unilite.msg.sMB099"/>','<t:message code="system.message.equipment.message002" default="이후 프로세스가 진형중입니다. 수정 및 삭제할 수 없습니다."/>');
				}else{
					if(confirm('<t:message code="system.message.equipment.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
							masterGrid.deleteSelectedRow();
					}
				}
			}
			if(Ext.isEmpty(directMasterStore1.data.items)){
				gsDel = "Y";
			}
		},
		onDeleteAllButtonDown: function() {
		}

	});





	Unilite.createValidator('validator01', {
		store	: directMasterStore1,
		grid	: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			var rv = true;

			switch(fieldName) {
				case "WOODEN_CODE" :
					record.set('EQU_CODE', newValue + '-' + record.get('SN_NO'));
					break;

				case "SN_NO" :
					record.set('EQU_CODE', record.get('WOODEN_CODE') + '-' + newValue);
					break;

				case "EQU_GRADE" :
					if(newValue == 'C') {
						record.set('STATUS', '<t:message code="system.label.equipment.disposal" default="폐기"/>');
					}
					break;

				case "WEIGHT" :
					if(newValue>=0){
						 rv = true;
					}
					break;

				case "PRODT_Q" :
					if(newValue>=0){
						 rv = true;
					}
					break;

				case "PRODT_O" :
					if(newValue>=0){
						 rv = true;
					}
					break;
			}
			return rv;
		}
	});
};
</script>