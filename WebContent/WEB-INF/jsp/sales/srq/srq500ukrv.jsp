<%--
'   프로그램명 : 패킹등록
'
'   작  성  자 : (주)시너지시스템즈 개발실
'   작  성  일 :
'
'   최종수정자 :
'   최종수정일 :
'
'   버	  전 : OMEGA Plus V6.0.0
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<t:appConfig pgmId="srq500ukrv"  >
	<t:ExtComboStore comboType="BOR120"/>									<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B024"/>						<!-- 수불담당 -->
	<t:ExtComboStore comboType="AU" comboCode="B268"/>						<!-- 패킹창고 -->
	<t:ExtComboStore items="${COMBO_WH_CELL_LIST}" storeId="whCellList"/>	<!-- 창고Cell -->
	<t:ExtComboStore comboType="OU" />										<!-- 창고-->
</t:appConfig>

<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>

<script type="text/javascript">

var referRequestWindow;

function appMain() {
	
	var gsDefaultPackWhCode;
	var gsDefaultPackWhCellCode;
	fnSetDefaultWhCode();
	
	var gsInoutPrsn = '${gsInoutPrsn}';
	
	function fnSetDefaultWhCode() {
		var codes = Ext.getStore('CBS_AU_B268');
		
		Ext.each(codes.data.items, function(code) {
			if(code.get('value') == '10') {
				gsDefaultPackWhCode		= code.get('refCode1');
				gsDefaultPackWhCellCode	= code.get('refCode2');
				
				return;
			}
		});
	}
	
	var directDetailProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'srq500ukrvService.selectListDetail'
		}
	});
	
	var directLotProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'srq500ukrvService.selectListLot',
			create	: 'srq500ukrvService.insertLot',
			update	: 'srq500ukrvService.updateLot',
			destroy	: 'srq500ukrvService.deleteLot',
			syncAll : 'srq500ukrvService.saveAllLot'
		}
	});
	
	/**
	 * Detail grid Model
	 */
	Unilite.defineModel('srq500ukrvDetailModel', {
		fields: [
			{name: 'COMP_CODE'			, text: '<t:message code="system.label.sales.companycode" default="법인코드"/>'				, type: 'string'},
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.sales.division" default="사업장"/>'					, type: 'string'},
			{name: 'PACK_NO'			, text: '<t:message code="" default="패킹번호"/>'											, type: 'string'},
			{name: 'PACK_USER'			, text: '<t:message code="" default="담당자"/>'											, type: 'string'},
			{name: 'PACK_DATE'			, text: '<t:message code="" default="패킹일자"/>'											, type: 'uniDate'},
			{name: 'CUSTOM_CODE'		, text: '<t:message code="system.label.sales.customcode" default="거래처코드"/>'				, type: 'string'},
			{name: 'CUSTOM_NAME'		, text: '<t:message code="system.label.sales.customname" default="거래처명"/>'				, type: 'string'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.sales.itemcode" default="품목코드"/>'				, type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.sales.itemname" default="품목명"/>'					, type: 'string'},
			{name: 'ORDER_NUM'			, text: '<t:message code="system.label.sales.sono" default="수주번호"/>'					, type: 'string'},
			{name: 'ORDER_SEQ'			, text: '<t:message code="system.label.sales.soseq" default="수주순번"/>'					, type: 'string'},
			{name: 'ISSUE_REQ_NUM'		, text: '<t:message code="system.label.inventory.issuerequestno" default="출고요청번호"/>'	, type: 'string'},
			{name: 'ISSUE_REQ_SEQ'		, text: '<t:message code="system.label.inventory.issuerequestseq" default="출고요청순번"/>'	, type: 'string'},
			{name: 'ISSUE_YN'			, text: '<t:message code="system.label.sales.issueyn" default="출고여부"/>'					, type: 'string'},
			{name: 'ISSUE_REQ_QTY'		, text: '<t:message code="system.label.sales.shipmentorderqty" default="출하지시량"/>'		, type: 'uniQty'},
			{name: 'ISSUE_QTY'			, text: '<t:message code="system.label.sales.packedqty" default="패킹량"/>'				, type: 'uniQty'},
			{name: 'UN_ISSUE_QTY'		, text: '<t:message code="system.label.sales.balanceqty" default="잔량"/>'				, type: 'uniQty'}
		]
	});
	
	/**
	 * Detail grid Model
	 */
	Unilite.defineModel('srq500ukrvLotModel', {
		fields: [
			{name: 'COMP_CODE'			, text: '<t:message code="system.label.sales.companycode" default="법인코드"/>'				, type: 'string'},
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.sales.division" default="사업장"/>'					, type: 'string'},
			{name: 'PACK_NO'			, text: '<t:message code="" default="패킹번호"/>'											, type: 'string'},
			{name: 'PACK_SEQ'			, text: '<t:message code="" default="패킹순번"/>'											, type: 'string'},
			{name: 'WH_CODE'			, text: '<t:message code="system.label.sales.issuewarehouse" default="출고창고"/>'			, type: 'string'},
			{name: 'WH_CELL_CODE'		, text: '<t:message code="system.label.sales.issuewarehousecell" default="출고창고Cell"/>'	, type: 'string'},
			{name: 'PACK_WH_CODE'		, text: '<t:message code="system.label.sales.packwarehouse" default="패킹창고"/>'			, type: 'string'},
			{name: 'PACK_WH_CELL_CODE'	, text: '<t:message code="system.label.sales.packwarehousecell" default="패킹창고Cell"/>'	, type: 'string'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.sales.itemcode" default="품목코드"/>'				, type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.sales.itemname" default="품목명"/>'					, type: 'string'},
			{name: 'LOT_NO'				, text: '<t:message code="system.label.sales.asserialno" default="S/N"/> (LOTNO)'		, type: 'string'},
			{name: 'ISSUE_REQ_NUM'		, text: '<t:message code="system.label.inventory.issuerequestno" default="출고요청번호"/>'	, type: 'string'},
			{name: 'ISSUE_REQ_SEQ'		, text: '<t:message code="system.label.inventory.issuerequestseq" default="출고요청순번"/>'	, type: 'string'},
			{name: 'ISSUE_YN'			, text: '<t:message code="system.label.sales.issueyn" default="출고여부"/>'					, type: 'string'},
			{name: 'CUSTOM_CODE'		, text: '<t:message code="system.label.sales.customcode" default="거래처코드"/>'				, type: 'string'}
		]
	});
	
	/**
	 * master grid store
	 */
	var directDetailStore = Unilite.createStore('srq500ukrvDetailStore', {
		model : 'srq500ukrvDetailModel',
		uniOpt: {
			isMaster  : false,			// 상위 버튼 연결
			editable  : false,			// 수정 모드 사용
			deletable : false,			// 삭제 가능 여부
			useNavi   : false			// prev | newxt 버튼 사용
		},
		autoLoad : false,
		proxy: directDetailProxy,
		loadStoreRecords: function(){
			var keyList = [];
			
			Ext.each(directDetailStore.data.items, function(record) {
				keyList.push({
					COMP_CODE		: record.get('COMP_CODE'),
					DIV_CODE		: record.get('DIV_CODE'),
					ISSUE_REQ_NUM	: record.get('ISSUE_REQ_NUM'),
					ISSUE_REQ_SEQ	: record.get('ISSUE_REQ_SEQ')
				});
			});
			
			var param = panelResult.getValues();
			param.KEY_LIST = keyList;
			
			if(Ext.isEmpty(keyList)) {
				return;
			}
			
			console.log(param);
			
			this.load({
				params : param
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
//				if(records.length > 0) {
//					var record = records[0];
//					
//					panelResult.setValue('CUSTOM_CODE'	, record.get('CUSTOM_CODE'));
//					panelResult.setValue('CUSTOM_NAME'	, record.get('CUSTOM_NAME'));
//					panelResult.setValue('PACK_USER'	, record.get('PACK_USER'));
//					panelResult.setValue('PACK_DATE'	, UniDate.getDbDateStr(record.get('PACK_DATE')));
//				}
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
				this.commitChanges();
				return true;
			}
		}
	});
	
	/**
	 * Machine grid store
	 */
	var directLotStore = Unilite.createStore('srq500ukrvLotStore', {
		model : 'srq500ukrvLotModel',
		uniOpt: {
			isMaster  : true,			// 상위 버튼 연결
			editable  : true,			// 수정 모드 사용
			deletable : true,			// 삭제 가능 여부
			useNavi   : false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: directLotProxy,
		loadStoreRecords: function(){
			var param = panelResult.getValues();
			console.log(param);
			
			this.load({
				params : param,
				callback : function(batch, option) {
					setTimeout(function(){
						panelResult.getField('BARCODE').focus();
					}, 100);
				}
			});
		},
		saveStore: function() {
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			
			var param = panelResult.getValues();
			if(inValidRecs.length == 0) {
				config = {
					params: [param],
					success: function(batch, option) {
						directLotStore.loadStoreRecords();
						directDetailStore.loadStoreRecords();
					}
				};
				this.syncAllDirect(config);
			} else {
				lotGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				if(records.length > 0) {
					var record = records[0];
					
					if(panelResult.getValue('CUSTOM_CODE') != record.get('CUSTOM_CODE')) {
						beep();
						
						Unilite.messageBox('출하지시 참조한 거래처와 패킹등록된 거래처가 일치하지 않습니다.');
						
						panelResult.setValue('PACK_NO', '');
						
						lotGrid.reset();
						lotGrid.getStore().clearData();
						
						panelResult.getField('BARCODE').focus();
						
						return;
					}
				}
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
			}
		}
	});
	
	/**
	 * panelResult
	 */
	var panelResult = Unilite.createSearchForm('resultForm',{
		region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel	: '<t:message code="system.label.purchase.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false,
			holdable	: 'hold',
			colspan		: 2,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '<t:message code="" default="패킹번호"/>',
			name		: 'PACK_NO',
			xtype		: 'uniTextfield',
			holdable	: 'hold',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
//		},{
//			fieldLabel	: '<t:message code="" default="출하지시번호"/>',
//			name		: 'ISSUE_REQ_NUM',
//			xtype		: 'uniTextfield',
//			holdable	: 'hold',
//			colspan		: 2,
//			hidden		: true,
//			listeners	: {
//				change: function(field, newValue, oldValue, eOpts) {
//				}
//			}
//		},{
//			html		: '&nbsp;',
//			xtype		: 'component',
//			hidden		: true
//		},{
//			fieldLabel	: '<t:message code="" default="수주번호"/>',
//			name		: 'ORDER_NUM',
//			xtype		: 'uniTextfield',
//			holdable	: 'hold',
//			colspan		: 2,
//			hidden		: true,
//			listeners	: {
//				change: function(field, newValue, oldValue, eOpts) {
//				}
//			}
		},
		Unilite.popup('CUST', {
			fieldLabel		: '<t:message code="system.label.sales.custom" default="거래처"/>',
			textFieldWidth	: 170,
			allowBlank		: true,
			autoPopup		: false,
			validateBlank	: false,
			holdable		: 'hold',
			listeners: {
				onValueFieldChange: function(field, newValue, oldValue){
					if(!Ext.isObject(oldValue)) {
						panelResult.setValue('CUSTOM_NAME', '');
					}
				},
				onTextFieldChange: function(field, newValue, oldValue){
					if(!Ext.isObject(oldValue)) {
						panelResult.setValue('CUSTOM_CODE', '');
					}
				},
				applyextparam: function(popup){
				}
			}
		}),{
//		},{
//			fieldLabel	: '<t:message code="system.label.sales.issuewarehouse" default="출고창고"/>',
//			name		: 'WH_CODE',
//			xtype		: 'uniCombobox',
//			comboType	: 'OU',
//			child		: 'WH_CELL_CODE',
//			holdable	: 'hold',
//			listeners	: {
//				expand: function(combo, eOpts ){
//				},
//				change: function(combo, newValue, oldValue, eOpts) {
//				},
//				select: function(combo, record, eOpts){
//				},
//				specialkey: function(field, event) {
//				}
//			}
//		},{
//			fieldLabel	: '<t:message code="system.label.sales.issuewarehousecell" default="출고창고Cell"/>',
//			name		: 'WH_CELL_CODE',
//			xtype		: 'uniCombobox',
//			store		: Ext.data.StoreManager.lookup('whCellList'),
//			holdable	: 'hold',
//			hideLabel	: true,
//			listeners	: {
//				change: function(combo, newValue, oldValue, eOpts) {
//				},
//				beforequery:function( queryPlan, eOpts ) {
//					var store = queryPlan.combo.store;
//					store.clearFilter();
//					if(!Ext.isEmpty(panelResult.getValue('WH_CODE'))){
//						store.filterBy(function(record){
//							return record.get('option') == panelResult.getValue('WH_CODE');
//						});
//					} else {
//						store.filterBy(function(record){
//							return false;
//						});
//					}
//				}
//			}
//		},{
			fieldLabel	: '<t:message code="system.label.sales.packwarehouse" default="패킹창고"/>',
			name		: 'PACK_WH_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'OU',
			child		: 'PACK_WH_CELL_CODE',
			holdable	: 'hold',
			listeners	: {
				expand: function(combo, eOpts ){
				},
				change: function(combo, newValue, oldValue, eOpts) {
				},
				select: function(combo, record, eOpts){
				},
				specialkey: function(field, event) {
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.packwarehousecell" default="패킹창고Cell"/>',
			name		: 'PACK_WH_CELL_CODE',
			xtype		: 'uniCombobox',
			store		: Ext.data.StoreManager.lookup('whCellList'),
			holdable	: 'hold',
			hideLabel	: true,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
				},
				beforequery:function( queryPlan, eOpts )   {
					var store = queryPlan.combo.store;
					store.clearFilter();
					if(!Ext.isEmpty(panelResult.getValue('PACK_WH_CODE'))){
						store.filterBy(function(record){
							return record.get('option') == panelResult.getValue('PACK_WH_CODE');
						});
					} else {
						store.filterBy(function(record){
							return false;
						});
					}
				}
			}
		},{
			fieldLabel	: '<t:message code="" default="패킹일자"/>',
			name		: 'PACK_DATE',
			xtype		: 'uniDatefield',
			holdable	: 'hold',
			value		: UniDate.get('today'),
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.trancharge" default="수불담당"/>',
			name		: 'PACK_USER',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B024',
			holdable	: 'hold',
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '<t:message code="" default="바코드"/>',
			name		: 'BARCODE',
			xtype		: 'uniTextfield',
			colspan		: 4,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					UniAppManager.app.fnCheckBarcode(newValue);
				}
			}
		}],
		setAllFieldsReadOnly : setAllFieldsReadOnly
	});
	
	/**
	 * detailGrid
	 */
	var detailGrid = Unilite.createGrid('detailGrid', {
		layout: 'fit',
		region: 'center',
		flex  : 1,
		uniOpt: {
			useLiveSearch		: true,
			expandLastColumn	: false,
			useRowNumberer		: true,
			useMultipleSorting	: false,
			onLoadSelectFirst	: true,
			dblClickToEdit		: true,
			useGroupSummary		: false,
			useContextMenu		: false,
			useRowContext		: false,
			filter: {
				useFilter: true,
				autoCreate: true
			}
		},
		store: directDetailStore,
		selModel: 'rowmodel',
		tbar: [{
			itemId	: 'requestBtn',
			text	: '<div style="color: blue"><t:message code="system.label.sales.shipmentorderrefer" default="출하지시참조"/></div>',
			handler	: function() {
				if(Ext.isEmpty(panelResult.getValue('PACK_USER'))) {
					Unilite.messageBox(UniUtils.getMessage('system.label.sales.trancharge', '수불담당') + UniUtils.getMessage('system.message.commonJS..invalidText','은(는) 필수입력 항목입니다.'));
					return;
				}
				if(panelResult.setAllFieldsReadOnly(true)) {
					openRequestWindow();
				}
			}
		}],
		columns: [
			{dataIndex: 'COMP_CODE'			, width: 100, hidden: true},
			{dataIndex: 'DIV_CODE'			, width: 100, hidden: true},
			{dataIndex: 'PACK_NO'			, width: 100, hidden: true},
			{dataIndex: 'PACK_USER'			, width: 100, hidden: true},
			{dataIndex: 'PACK_DATE'			, width: 100, hidden: true},
			{dataIndex: 'CUSTOM_CODE'		, width: 100, hidden: true},
			{dataIndex: 'CUSTOM_NAME'		, width: 100, hidden: true},
			{dataIndex: 'ITEM_CODE'			, width: 150},
			{dataIndex: 'ITEM_NAME'			, width: 300},
			{dataIndex: 'ISSUE_YN'			, width: 100, hidden: true},
			{dataIndex: 'ISSUE_REQ_QTY'		, width: 150},
			{dataIndex: 'ISSUE_QTY'			, width: 150},
			{dataIndex: 'UN_ISSUE_QTY'		, width: 150},
			{dataIndex: 'ORDER_NUM'			, width: 100},
			{dataIndex: 'ORDER_SEQ'			, width: 100},
			{dataIndex: 'ISSUE_REQ_NUM'		, width: 100},
			{dataIndex: 'ISSUE_REQ_SEQ'		, width: 100}
		],
		listeners: {
			selectionchangerecord: function(record) {
			}
		},
		setRequestData:function(record) {
			var grdRecord = this.getSelectedRecord();
			
			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
			grdRecord.set('ORDER_NUM'			, record['ORDER_NUM']);
			grdRecord.set('ORDER_SEQ'			, record['SER_NO']);
			grdRecord.set('ISSUE_REQ_NUM'		, record['ISSUE_REQ_NUM']);
			grdRecord.set('ISSUE_REQ_SEQ'		, record['ISSUE_REQ_SEQ']);
			grdRecord.set('ISSUE_REQ_QTY'		, record['ISSUE_REQ_QTY']);
			grdRecord.set('ISSUE_QTY'			, record['ISSUE_QTY']);
			grdRecord.set('UN_ISSUE_QTY'		, record['NOT_REQ_Q']);
		}
	});//End of var masterGrid = Unilite.createGrid('masterGrid', {
	
	/**
	 * lotGrid
	 */
	var lotGrid = Unilite.createGrid('lotGrid', {
		layout	: 'fit',
		region	: 'south',
		uniOpt: {
			useLiveSearch		: true,
			expandLastColumn	: false,
			useRowNumberer		: true,
			useMultipleSorting	: false,
			onLoadSelectFirst	: true,
			dblClickToEdit		: true,
			useGroupSummary		: false,
			useContextMenu		: false,
			useRowContext		: false,
			filter: {
				useFilter: true,
				autoCreate: true
			}
		},
		store: directLotStore,
		columns: [
			{dataIndex: 'COMP_CODE'			, width: 100, hidden: true},
			{dataIndex: 'DIV_CODE'			, width: 100, hidden: true},
			{dataIndex: 'PACK_NO'			, width: 100, hidden: true},
			{dataIndex: 'PACK_SEQ'			, width: 150, hidden: true},
			{dataIndex: 'WH_CODE'			, width: 100, hidden: true},
			{dataIndex: 'WH_CELL_CODE'		, width: 120, hidden: true},
			{dataIndex: 'PACK_WH_CODE'		, width: 100, hidden: true},
			{dataIndex: 'PACK_WH_CELL_CODE'	, width: 100, hidden: true},
			{dataIndex: 'ITEM_CODE'			, width: 150},
			{dataIndex: 'ITEM_NAME'			, width: 300},
			{dataIndex: 'LOT_NO'			, width: 200},
			{dataIndex: 'ISSUE_REQ_NUM'		, width: 150, hidden: true},
			{dataIndex: 'ISSUE_REQ_SEQ'		, width: 150, hidden: true},
			{dataIndex: 'ISSUE_YN'			, width: 150, hidden: true}
		],
		listeners: {
			beforeedit: function(editor, e, eOpts) {
				return false;
			}
		},
		fnNewData: function(record)	{
			var maxSeq = 0;
			var mRow;
			var isDup = false;
			
			mRow = null;
			Ext.each(directDetailStore.data.items, function(mRecord) {
				if(record['ITEM_CODE'] == mRecord.get('ITEM_CODE') && Number(mRecord.get('UN_ISSUE_QTY')) > 0) {
					detailGrid.selectById(mRecord.id);
					mRow = detailGrid.getSelectedRecord();
					
					return;
				}
			});
			
			if(Ext.isEmpty(mRow)) {
				beep();
				Unilite.messageBox('출하지시한 품목이 아닙니다.');
				return;
			}
			
			Ext.each(directLotStore.data.items, function(dRecord) {
				if(Number(dRecord.get('PACK_SEQ')) > maxSeq) {
					maxSeq = Number(dRecord.get('PACK_SEQ'));
				}
				
				if(dRecord.get('ITEM_CODE') == record['ITEM_CODE'] && dRecord.get('LOT_NO') == record['LOT_NO']) {
					isDup = true;
					return;
				}
			});
			
			if(isDup) {
				beep();
				Unilite.messageBox('이미 추가된 LOT번호 입니다.', '중복된 LOT번호 : ' + record['LOT_NO'], '', {'showDetail' : true });
				return;
			}
			
			var r = {
				COMP_CODE			: UserInfo.compCode,
				DIV_CODE			: panelResult.getValue('DIV_CODE'),
				PACK_NO				: panelResult.getValue('PACK_NO'),
				PACK_SEQ			: (maxSeq + 1),
				WH_CODE				: panelResult.getValue('WH_CODE'),
				WH_CELL_CODE		: panelResult.getValue('WH_CELL_CODE'),
				PACK_WH_CODE		: panelResult.getValue('PACK_WH_CODE'),
				PACK_WH_CELL_CODE	: panelResult.getValue('PACK_WH_CELL_CODE'),
				ITEM_CODE			: record['ITEM_CODE'],
				ITEM_NAME			: record['ITEM_NAME'],
				LOT_NO				: record['LOT_NO'],
				ISSUE_REQ_NUM		: mRow.get('ISSUE_REQ_NUM'),
				ISSUE_REQ_SEQ		: mRow.get('ISSUE_REQ_SEQ'),
				ISSUE_YN			: 'N'
			};
			
			lotGrid.createRow(r);
			
			mRow.set('ISSUE_QTY', mRow.get('ISSUE_QTY') + 1);
			mRow.set('UN_ISSUE_QTY', mRow.get('UN_ISSUE_QTY') - 1);
		}
	});//End of var masterGrid = Unilite.createGrid('masterGrid', {
	
	/**
	 * Main
	 */
	Unilite.Main({
		borderItems:[{
			region : 'center',
			layout : 'border',
			border : false,
			items  : [
				detailGrid, lotGrid, panelResult
			]
		}],
		id : 'srq500ukrvApp',
		fnInitBinding : function() {
			panelResult.setValue('DIV_CODE'		, UserInfo.divCode);
			panelResult.setValue('PACK_DATE'	, UniDate.get("today"));
			
			if(!Ext.isEmpty(gsInoutPrsn)) {
				panelResult.setValue('PACK_USER'	, gsInoutPrsn);
			}

			this.fnSetDefault();
			
			UniAppManager.setToolbarButtons(['deleteAll', 'save', 'qSuery'], false);
			
			panelResult.setAllFieldsReadOnly(false);
			
			setTimeout(function() {
				panelResult.setValue('BARCODE', '');
				panelResult.getField('BARCODE').focus();
			}, 500);
		},
		fnSetDefault : function() {
			panelResult.setValue('PACK_WH_CODE'		, gsDefaultPackWhCode);
			
			//강제 필터 적용
			var store = panelResult.getField('PACK_WH_CELL_CODE').getStore();
			store.clearFilter();
			if(!Ext.isEmpty(gsDefaultPackWhCode)){
				store.filterBy(function(record){
					return record.get('option') == gsDefaultPackWhCode;
				});
			} else {
				store.filterBy(function(record){
					return false;
				});
			}
			
			panelResult.setValue('PACK_WH_CELL_CODE', gsDefaultPackWhCellCode);
		},
		onQueryButtonDown: function() {
			if(panelResult.setAllFieldsReadOnly(true)) {
				directDetailStore.loadStoreRecords();
				directLotStore.loadStoreRecords();
			}
		},
		onNewDataButtonDown: function()	{
			var r = {
				COMP_CODE			: UserInfo.compCode,
				DIV_CODE			: panelResult.getValue('DIV_CODE'),
				CUSTOM_CODE			: panelResult.getValue('CUSTOM_CODE'),
				CUSTOM_NAME			: panelResult.getValue('CUSTOM_NAME'),
				ITEM_CODE			: '',
				ITEM_NAME			: '',
				ORDER_NUM			: null,
				ORDER_SEQ			: null,
				ISSUE_REQ_NUM		: null,
				ISSUE_REQ_SEQ		: null,
				ISSUE_YN			: 'N',
				ISSUE_REQ_QTY		: 0,
				ISSUE_QTY			: 0,
				UN_ISSUE_QTY		: 0
			};
			
			detailGrid.createRow(r);
		},
		onResetButtonDown: function() {
			panelResult.clearForm();
			
			detailGrid.reset();
			detailGrid.getStore().clearData();
			
			lotGrid.reset();
			lotGrid.getStore().clearData();
			
			this.fnInitBinding();
			this.fnSetDefault();
		},
		onSaveDataButtonDown: function(config) {
			if(directLotStore.isDirty()) {
				directLotStore.saveStore();
			}
		},
		onDeleteDataButtonDown: function() {
			var record = lotGrid.getSelectedRecord();
			
			if(record.phantom) {
				lotGrid.deleteSelectedRow();
				
				UniAppManager.app.fnUpdateReference(record);
				
				panelResult.setValue('BARCODE', '');
				panelResult.getField('BARCODE').focus();
			}
			else {
				Ext.Msg.confirm('<t:message code="system.label.purchase.delete" default="삭제"/>', '<t:message code="system.message.product.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>', function(btn){
					if (btn == 'yes') {
						lotGrid.deleteSelectedRow();
						
						UniAppManager.app.fnUpdateReference(record);
						
						panelResult.setValue('BARCODE', '');
						panelResult.getField('BARCODE').focus();
					}
				});
			}
		},
		fnCheckBarcode: function(rawValue) {
			if(Ext.isEmpty(rawValue)) {
				return;
			}
			
			var values = rawValue.split('^');
			var value;
			
			if(values.length == 1) {
				value = values[0];
			}
			else if(values.length == 2 && values[0] == 'PK') {
				value = values[1];
			}
			
			var param = {
				COMP_CODE	: UserInfo.compCode,
				DIV_CODE	: panelResult.getValue('DIV_CODE'),
				BARCODE		: value
			};
			
			srq500ukrvService.checkBarcode(param, function(provider, response) {
				if(!Ext.isEmpty(provider)) {
					var rv = provider[0];
					if(rv['BARCODE_TYPE'] == '1') {
						if(directLotStore.isDirty()) {
							beep();
							
							Ext.Msg.show({
								title:UniUtils.getMessage('system.message.commonJS.baseApp.confirm','확인'),
								msg:  UniUtils.getMessage('system.message.commonJS.baseApp.dirty','내용이 변경되었습니다.') + "\n" 
									+ UniUtils.getMessage('system.message.commonJS.baseApp.confirmSave','변경된 내용을 저장하시겠습니까?'),
								buttons: Ext.Msg.YESNOCANCEL,
								icon: Ext.Msg.QUESTION,
								fn: function(res) {
									if (res === 'yes' ) {
										UniAppManager.app.onSaveDataButtonDown();
										
										panelResult.setValue('PACK_NO', rv['PACK_NO']);
										UniAppManager.app.onQueryButtonDown();
									}
									else if (res === 'no' ) {
										panelResult.setValue('PACK_NO', rv['PACK_NO']);
										UniAppManager.app.onQueryButtonDown();
									}
								}
							});
						}
						else {
							panelResult.setValue('PACK_NO', rv['PACK_NO']);
							UniAppManager.app.onQueryButtonDown();
						}
					}
					else if(rv['BARCODE_TYPE'] == '2') {
						if(Ext.isEmpty(panelResult.getValue('PACK_NO'))) {
							beep();
							
							panelResult.setValue('BARCODE', '');
							panelResult.getField('BARCODE').focus();
							
							return;
						}
						lotGrid.fnNewData(rv);
					}
					
					panelResult.setValue('BARCODE', '');
					panelResult.getField('BARCODE').focus();
				}
				else {
					beep();
					
					panelResult.setValue('BARCODE', '');
					panelResult.getField('BARCODE').focus();
				}
			});
		},
		fnUpdateReference: function(record) {
			var mRow;
			
			mRow = null;
			Ext.each(directDetailStore.data.items, function(mRecord) {
				if( record.get('ITEM_CODE')		== mRecord.get('ITEM_CODE') &&
					record.get('ISSUE_REQ_NUM') == mRecord.get('ISSUE_REQ_NUM') &&
					record.get('ISSUE_REQ_SEQ') == mRecord.get('ISSUE_REQ_SEQ')) {
					detailGrid.selectById(mRecord.id);
					mRow = detailGrid.getSelectedRecord();
					
					return;
				}
			});
			
			if(Ext.isEmpty(mRow)) {
				return;
			}
			
			mRow.set('ISSUE_QTY'	, mRow.get('ISSUE_QTY') - 1);
			mRow.set('UN_ISSUE_QTY' , mRow.get('UN_ISSUE_QTY') + 1);
		}
	});//End of Unilite.Main( {
	
	/**
	 * master grid validator
	 */
	Unilite.createValidator('validator01', {
		store: directDetailStore,
		grid: detailGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			
			if(newValue == oldValue) {
				return true;
			}
			
			switch(fieldName) {
			}
			return rv;
		}
	});
	
	function setAllFieldsReadOnly(b){
		var r = true;
		if(b) {
			var invalid = this.getForm().getFields().filterBy(function(field) {
				return !field.validate();
			});
			
			if(invalid.length > 0) {
				r = false;
				var labelText = '';
				
				if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
					labelText = invalid.items[0]['fieldLabel']+':';
				} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
					labelText = invalid.items[0].ownerCt['fieldLabel']+':';
				}
				alert(labelText+Msg.sMB083);
				invalid.items[0].focus();
				
				return r;
			}
		}
		
		//this.unmask();
		var fields = this.getForm().getFields();
		Ext.each(fields.items, function(item) {
			if(Ext.isDefined(item.holdable) ) {
				if (item.holdable == 'hold') {
					item.setReadOnly(b);
				}
			} 
			if(item.isPopupField)	{
				var popupFC = item.up('uniPopupField');
				if(popupFC.holdable == 'hold') {
					item.setReadOnly(b);
				}
			}
		});
		
		return r;
	}
	
	function beep() {
		audioCtx = new(window.AudioContext || window.webkitAudioContext)();
		
		var oscillator = audioCtx.createOscillator();
		var gainNode = audioCtx.createGain();
		
		oscillator.connect(gainNode);
		gainNode.connect(audioCtx.destination);
		
		gainNode.gain.value = 1.0;			//VOLUME 크기
		oscillator.frequency.value = 4100;
		oscillator.type = 'square';			//sine, square, sawtooth, triangle
		
		oscillator.start();
		
		setTimeout(
			function() {
				oscillator.stop();
			}
		, 800);
	};
	
	/**
	 * 출하지시내역을 참조하기 위한 Search Form, Grid, Window 정의
	 */
	var requestSearch = Unilite.createSearchForm('requestForm', {
		layout :  {type : 'uniTable', columns : 3},
		items :[{
			xtype: 'uniCombobox',
			name:'DIV_CODE',
			fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
			child: 'WH_CODE',
			comboType:'BOR120',
			allowBlank: false,
			readOnly: true
		},
		Unilite.popup('DIV_PUMOK',{
			fieldLabel:'<t:message code="system.label.sales.item" default="품목"/>' , 
			valueFieldName	: 'ITEM_CODE',
			textFieldName	: 'ITEM_NAME',
			validateBlank: false,
			listeners: {
				onValueFieldChange: function(field, newValue, oldValue){
					if(!Ext.isObject(oldValue)) {
						requestSearch.setValue('ITEM_NAME', '');
					}
				},
				onTextFieldChange: function(field, newValue, oldValue){
					if(!Ext.isObject(oldValue)) {
						requestSearch.setValue('ITEM_CODE', '');
					}
				},
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': requestSearch.getValue('DIV_CODE')});
				}
			}
		}), {
			fieldLabel: '<t:message code="system.label.sales.shipmentorderdate" default="출하지시일"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'ISSUE_DATE_FR',
			endFieldName: 'ISSUE_DATE_TO',	
			width: 350,
			endDate: UniDate.get('tomorrow')
		}, {
			fieldLabel: '<t:message code="system.label.sales.shipmentorderno" default="출하지시번호"/>',
			xtype: 'uniTextfield',
			name:'ISSUE_REQ_NUM'
		}, {
			fieldLabel: '<t:message code="system.label.sales.manageno" default="관리번호"/>',
			xtype: 'uniTextfield',
			name:'PROJECT_NO'
		}, {
			fieldLabel: '<t:message code="system.label.sales.issuewarehouse" default="출고창고"/>',
			name: 'WH_CODE',
			xtype:'uniCombobox',
			comboType:'OU',
			comboCode:''
		}, {
			xtype: 'hiddenfield',
			name:'MONEY_UNIT'
		}, {
			xtype: 'hiddenfield',
			name:'CUSTOM_CODE'
		}, {
			xtype: 'hiddenfield',
			name:'CUSTOM_NAME'
		}, {
			xtype: 'hiddenfield',
			name:'CREATE_LOC'
		}]
	});
	
	//출하지시 참조 모델 정의
	Unilite.defineModel('srq500ukrvRequestModel', {
		fields: [
			{name: 'COMP_CODE'				,text: '<t:message code="system.label.sales.companycode" default="법인코드"/>'				, type: 'string'},
			{name: 'DIV_CODE'				,text: '<t:message code="system.label.sales.division" default="사업장"/>'					, type: 'string'},
			{name: 'CUSTOM_CODE'			,text: '<t:message code="system.label.sales.customcode" default="거래처코드"/>'				, type: 'string'},
			{name: 'CUSTOM_NAME'			,text: '<t:message code="system.label.sales.custom" default="거래처"/>'					, type: 'string'},
			{name: 'ITEM_CODE'				,text: '<t:message code="system.label.sales.item" default="품목"/>'						, type: 'string'},
			{name: 'ITEM_NAME'				,text: '<t:message code="system.label.sales.itemname" default="품목명"/>'					, type: 'string'},
			{name: 'ISSUE_REQ_DATE'			,text: '<t:message code="system.label.sales.shipmentorderdate" default="출하지시일"/>'		, type: 'uniDate'},
			{name: 'ISSUE_REQ_QTY'			,text: '<t:message code="system.label.sales.shipmentorderqty" default="출하지시량"/>'		, type: 'uniQty'},
			{name: 'ISSUE_QTY'				,text: '<t:message code="system.label.sales.packqty" default="패킹량"/>'					, type: 'uniQty'},
			{name: 'NOT_REQ_Q'				,text: '<t:message code="system.label.sales.unpackedqty" default="잔량"/>'				, type: 'uniQty'},
			{name: 'ORDER_NUM'				,text: '<t:message code="system.label.sales.soofferno" default="수주(오퍼)번호"/>'			, type: 'string'},
			{name: 'SER_NO'					,text: 'SER_NO'																			, type: 'string'},
			{name: 'ISSUE_REQ_NUM'			,text: '<t:message code="system.label.sales.shipmentorderno" default="출하지시번호"/>'		, type: 'string'},
			{name: 'ISSUE_REQ_SEQ'			,text: '<t:message code="system.label.sales.seq" default="순번"/>'						, type: 'string'},
			{name: 'REF_ISSUE_QTY'			,text: '<t:message code="" default="출고량"/>'												, type: 'uniQty'},
			{name: 'REF_PACK_QTY'			,text: '<t:message code="" default="패킹량"/>'												, type: 'uniQty'}
		]
	});
	
	//출하지시 참조 스토어 정의
	var requestStore = Unilite.createStore('srq500ukrvRequestStore', {
		model: 'srq500ukrvRequestModel',
		autoLoad: false,
		uniOpt : {
			isMaster: false,			// 상위 버튼 연결
			editable: false,			// 수정 모드 사용
			deletable:false,			// 삭제 가능 여부
			useNavi : false				// prev | next 버튼 사용
		},
		proxy: {
			type: 'direct',
			api: {
				read : 'srq500ukrvService.selectRequestList'
			}
		},
		listeners:{
			load:function(store, records, successful, eOpts)	{
				if(successful)	{	   
					var masterRecords = directDetailStore.data.filterBy(directDetailStore.filterNewOnly);  
					var deleteRecords = new Array();
					
					if(masterRecords.items.length > 0)	{
						console.log("store.items :", store.items);
						console.log("records", records);
						
						Ext.each(records, function(item, i)	{
							Ext.each(masterRecords.items, function(record, i)	{
								console.log("record :", record);
								
								if((record.data['ISSUE_REQ_NUM'] == item.data['ISSUE_REQ_NUM']) 
								&& (record.data['ISSUE_REQ_SEQ'] == item.data['ISSUE_REQ_SEQ'])) {
									deleteRecords.push(item);
								}
							});
						});
						store.remove(deleteRecords);
					}
				}
			}
		},
		loadStoreRecords : function()	{
			var param = requestSearch.getValues();
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	
	//출하지시 참조 그리드 정의
	var requestGrid = Unilite.createGrid('srq500ukrvRequestGrid', {
		layout	: 'fit',
		store	: requestStore,
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly : false, toggleOnClick:false, mode: 'MULTI',
			listeners: {
				beforeselect: function(rowSelection, record, index, eOpts) {
					var curRecords = requestGrid.getSelectedRecords();
					var customCode = record.get('CUSTOM_CODE');
					var singleCustomer = true;
					
					Ext.each(curRecords, function(curRecord, i){
						if(curRecord.get('CUSTOM_CODE') != customCode) {
							singleCustomer = false;
							return;
						}
					});
					
					if(!singleCustomer) {
						return false;
					}
					
					return true;
				},
				select: function(grid, selectRecord, index, rowIndex, eOpts ){
				},
				deselect:  function(grid, selectRecord, index, eOpts ){
				}
			}
		}),
		uniOpt	:{
			onLoadSelectFirst	: false,
			useRowNumberer		: false
		},
		columns:  [
			{ dataIndex: 'COMP_CODE'			, width: 120, hidden: true },
			{ dataIndex: 'DIV_CODE'				, width: 120, hidden: true },
			{ dataIndex: 'CUSTOM_CODE'			, width: 120, hidden: true },
			{ dataIndex: 'CUSTOM_NAME'			, minWidth: 200, flex: 1 },
			{ dataIndex: 'ITEM_CODE'			, width: 120 },
			{ dataIndex: 'ITEM_NAME'			, minWidth: 200, flex: 1 },
			{ dataIndex: 'ISSUE_REQ_DATE'		, width: 120 },
			{ dataIndex: 'ISSUE_REQ_QTY'		, width: 120 },
			{ dataIndex: 'ISSUE_QTY'			, width: 120 },
			{ dataIndex: 'NOT_REQ_Q'			, width: 120 },
			{ dataIndex: 'ORDER_NUM'			, width: 120, hidden: true },
			{ dataIndex: 'SER_NO'				, width: 100, hidden: true },
			{ dataIndex: 'ISSUE_REQ_NUM'		, width: 100, hidden: true },
			{ dataIndex: 'ISSUE_REQ_SEQ'		, width: 100, hidden: true }
		],
		listeners: {	
			onGridDblClick:function(grid, record, cellIndex, colName) {
			}
		},
		returnData: function()	{
			var records = this.getSelectedRecords();
			Ext.each(records, function(record,i){
				if(i == 0) {
					if(Ext.isEmpty(panelResult.getValue('CUSTOM_CODE'))) {
						panelResult.setValue('CUSTOM_CODE', record.get('CUSTOM_CODE'));
						panelResult.setValue('CUSTOM_NAME', record.get('CUSTOM_NAME'));
					}
				}
				
				UniAppManager.app.onNewDataButtonDown();
				detailGrid.setRequestData(record.data);
			});
			this.deleteSelectedRow();
			
			panelResult.getField('BARCODE').focus();
		}
	});
	
	function openRequestWindow() {
		if(!panelResult.getInvalidMessage()) return false;
		
		if(!referRequestWindow) {
			referRequestWindow = Ext.create('widget.uniDetailWindow', {
				title: '<t:message code="system.label.sales.shipmentorderrefer" default="출하지시참조"/>',
				width: 1080,
				height: 580,
				layout:{type:'vbox', align:'stretch'},
				items: [requestSearch, requestGrid],
				tbar:  ['->',
					{	itemId : 'saveBtn',
						text: '<t:message code="system.label.sales.inquiry" default="조회"/>',
						handler: function() {
							requestStore.loadStoreRecords();
						},
						disabled: false
					}, 
					{	itemId : 'confirmBtn',
						text: '<t:message code="system.label.sales.issueapply" default="출고적용"/>',
						handler: function() {
							requestGrid.returnData();
						},
						disabled: false
					},
					{	itemId : 'confirmCloseBtn',
						text: '<t:message code="system.label.sales.issueapplyclose" default="출고적용후 닫기"/>',
						handler: function() {
							requestGrid.returnData();
							referRequestWindow.hide();
						},
						disabled: false
					},{
						itemId : 'closeBtn',
						text: '<t:message code="system.label.sales.close" default="닫기"/>',
						handler: function() {
							if(directDetailStore.getCount() == 0){
								panelResult.setAllFieldsReadOnly(false);
							}
							referRequestWindow.hide();
						},
						disabled: false
					}
				],
				listeners : {
					beforehide: function(me, eOpt)	{
						requestSearch.clearForm();
						requestGrid.reset();
					},
					beforeclose: function( panel, eOpts )	{
						requestSearch.clearForm();
						requestGrid.reset();
					},
					beforeshow: function ( me, eOpts )	{
						requestSearch.setValue('DIV_CODE'		, panelResult.getValue('DIV_CODE'));
						requestSearch.setValue('MONEY_UNIT'		, panelResult.getValue('MONEY_UNIT'));
						requestSearch.setValue('CUSTOM_CODE'	, panelResult.getValue('CUSTOM_CODE'));
						requestSearch.setValue('CUSTOM_NAME'	, panelResult.getValue('CUSTOM_NAME'));
						requestSearch.setValue('ISSUE_DATE_TO'	, panelResult.getValue('PACK_DATE'));
						requestSearch.setValue('ISSUE_DATE_FR'	, UniDate.get('startOfMonth', panelResult.getValue('PACK_DATE')));
						requestStore.loadStoreRecords();
					}
				}
			})
		}
		referRequestWindow.center();
		referRequestWindow.show();
	}

}
</script>