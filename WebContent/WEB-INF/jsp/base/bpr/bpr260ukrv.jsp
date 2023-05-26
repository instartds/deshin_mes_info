<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bpr260ukrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B138" /> <!--품목계정 -->
	<t:ExtComboStore comboType="AU" comboCode="S106" /> <!-- 화폐단위 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}	
</style>
<script type="text/javascript" >


function appMain() {
	//20200511 추가: 이노베이션 컬럼 컨트롤 하기 위해 추가
	var BsaCodeInfo = {
		gsSiteCode: '${gsSiteCode}'
	};
	var hiddenChk = true;
	if(BsaCodeInfo.gsSiteCode == 'INNO'){
		hiddenChk = false;
	}
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'bpr260ukrvService.selectDetailList',
			update	: 'bpr260ukrvService.updateDetail',
			create	: 'bpr260ukrvService.insertDetail',
			destroy	: 'bpr260ukrvService.deleteDetail',
			syncAll	: 'bpr260ukrvService.saveAll'
		}
	});

	/** main Model 정의 
	 * @type
	 */
	Unilite.defineModel('bpr260ukrvModel', {
		fields: [
			{name: 'DIV_CODE'		, text: 'DIV_CODE'		, type: 'string'},
			{name: 'ITEM_CODE'		, text: '<t:message code="system.label.base.itemcode" default="품목코드"/>'			, type: 'string', allowBlank:false},
			{name: 'ITEM_NAME'		, text: '<t:message code="system.label.base.itemname" default="품목명"/>'			, type: 'string', allowBlank: false},
			{name: 'LABEL_NAME'		, text: hiddenChk ? '<t:message code="system.label.base.labelname" default="라벨 품명"/>': 'BOX 라벨'	, type: 'string'},	//20200511 수정: BsaCodeInfo.gsSiteCode에 따라 컬럼명 변경
			{name: 'HOSPITAL_ITEM'	, text: '<t:message code="system.label.base.hospitalname" default="병원용 품명"/>'	, type: 'string'},
			{name: 'USE_TARGET'		, text: '<t:message code="system.label.base.usetarget" default="사용목적"/>'		, type: 'string'},
			{name: 'REPORT_NO'		, text: '<t:message code="system.label.base.reportno" default="품목신고번호"/>'		, type: 'string'},
			{name: 'KEEP_TEMPER'	, text: '<t:message code="system.label.base.keeptemper" default="보관온도"/>'		, type: 'string'},
			{name: 'ITEM_WIDTH'		, text: '<t:message code="system.label.base.itemwidth" default="크기"/>'			, type: 'int'},
			{name: 'PACK_QTY'		, text: '<t:message code="system.label.base.packingqty" default="포장량"/>'		, type: 'int'},
			{name: 'PACK_TYPE'		, text: '<t:message code="system.label.base.packtype" default="포장형태"/>'			, type: 'string', comboType:'AU', comboCode:'B138'},
			{name: 'LABEL_TYPE'		, text: '<t:message code="system.label.base.labeltype" default="라벨타입"/>'		, type: 'string', comboType:'AU', comboCode:'S106'},
			{name: 'TYPE_NAME'		, text: '형명'			, type: 'string'},
			{name: 'LOT_ID'			, text: 'LOT ID'		, type: 'string'},
			//20200511 추가: 반제품코드, 제품 라벨
			{name: 'ACCOUNT20_CODE'	, text: '반제품코드'			, type: 'string', editable: false},
			{name: 'ACCOUNT20_NAME'	, text: '제품 라벨'			, type: 'string', editable: false}
		]
	});

	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore = Unilite.createStore('bpr260ukrvMasterStore1',{
		model	: 'bpr260ukrvModel',
		proxy	: directProxy,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결 
			editable	: true,		// 수정 모드 사용 
			deletable	: true,		// 삭제 가능 여부 
			useNavi		: false		// prev | next 버튼 사용
		},
		autoLoad: false,
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
			var toCreate = this.getNewRecords();
			var toUpdate = this.getUpdatedRecords();
			var toDelete = this.getRemovedRecords();
			var list = [].concat(toUpdate, toCreate);
			
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
					}
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('bpr260ukrvGrid');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 4},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{	
			xtype		: 'container',
			padding		: '0 5 5 5',
			defaultType	: 'uniTextfield',
			layout		: {type: 'uniTable', columns : 3},
			items		: [{
				fieldLabel	: '<t:message code="system.label.base.division" default="사업장"/>',
				name		: 'DIV_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				allowBlank	: false
			},
			Unilite.popup('ITEM',{
				fieldLabel		: '<t:message code="system.label.base.item" default="품목"/>',
				textFieldName	: 'ITEM_NAME',
				valueFieldName	: 'ITEM_CODE',
				autoPopup		: true
			})]
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
					//this.mask();
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) ) {
							if (item.holdable == 'hold') {
								item.setReadOnly(true); 
							}
						}
						if(item.isPopupField) {
							var popupFC = item.up('uniPopupField') ;
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
						var popupFC = item.up('uniPopupField');
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		}
	});

	/** Master Grid 정의(Grid Panel)
	 * @type
	 */
	var masterGrid = Unilite.createGrid('bpr260ukrvGrid', {
		store	: directMasterStore,
		layout	: 'fit',
		region	: 'center', 
		uniOpt	: {
			expandLastColumn	: true,
			useRowNumberer		: true,
			useMultipleSorting	: true
		},
		features: [ 
			{id: 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
			{id: 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false}
		],
		columns: [
			{dataIndex: 'DIV_CODE'			, width: 100, hidden: true},
			{dataIndex: 'ITEM_CODE'			, width: 100,
				editor: Unilite.popup('DIV_PUMOK_G',{
					autoPopup: true,
					listeners:{
						scope:this,
						onSelected:function(records, type ) {
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('ITEM_CODE',records[0]['ITEM_CODE']);
							grdRecord.set('ITEM_NAME',records[0]['ITEM_NAME']);
							var param ={
								"ITEM_CODE": records[0]['ITEM_CODE']
							}
							bpr260ukrvService.checkDataInfo(param, function(provider, response) {
								if(!Ext.isEmpty(provider)){
									if(Ext.isEmpty(provider[0].ITEM_CODE)){
										grdRecord.set('KEEP_TEMPER',provider[0].KEEP_TEMPER);
										grdRecord.set('ITEM_WIDTH',provider[0].ITEM_WIDTH);
										grdRecord.set('PACK_QTY',provider[0].PACK_QTY);
										grdRecord.set('PACK_TYPE',provider[0].PACK_TYPE);
									}else{
										Unilite.messageBox('이미 품목이 존재합니다.');
										panelResult.setValue('ITEM_CODE',grdRecord.get('ITEM_CODE'));
										panelResult.setValue('ITEM_NAME',grdRecord.get('ITEM_NAME'));
										directMasterStore.loadData({});
										UniAppManager.app.onQueryButtonDown();
										return false;
									}
								}else{
									grdRecord.set('KEEP_TEMPER','');
									grdRecord.set('ITEM_WIDTH','0');
									grdRecord.set('PACK_QTY','0');
									grdRecord.set('PACK_TYPE','');
									grdRecord.set('LABEL_NAME','');
									grdRecord.set('HOSPITAL_ITEM','');
									grdRecord.set('USE_TARGET','');
									grdRecord.set('REPORT_NO','');
									grdRecord.set('LABEL_TYPE','');
								}
							});
							
						},
						onClear:function(type) {
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('ITEM_CODE','');
							grdRecord.set('ITEM_NAME','');
							grdRecord.set('KEEP_TEMPER','');
							grdRecord.set('ITEM_WIDTH','0');
							grdRecord.set('PACK_QTY','0');
							grdRecord.set('PACK_TYPE','');
							grdRecord.set('LABEL_NAME','');
							grdRecord.set('HOSPITAL_ITEM','');
							grdRecord.set('USE_TARGET','');
							grdRecord.set('REPORT_NO','');
							grdRecord.set('LABEL_TYPE','');
						},
						applyExtParam:{
							scope:this,
							fn:function(popup){
								var param = {
									'DIV_CODE' :panelResult.getValue('DIV_CODE')
								}
								popup.setExtParam(param);
							}
						}
					}
				})
			},
			{dataIndex: 'ITEM_NAME'			, width: 160,
				editor: Unilite.popup('DIV_PUMOK_G',{
					autoPopup: true,
					listeners:{
						scope:this,
						onSelected:function(records, type ) {
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('ITEM_CODE',records[0]['ITEM_CODE']);
							grdRecord.set('ITEM_NAME',records[0]['ITEM_NAME']);
							var param ={
								"ITEM_CODE": records[0]['ITEM_CODE']
							}
							bpr260ukrvService.checkDataInfo(param, function(provider, response) {
								if(!Ext.isEmpty(provider)){
									if(Ext.isEmpty(provider[0].ITEM_CODE)){
										grdRecord.set('KEEP_TEMPER',provider[0].KEEP_TEMPER);
										grdRecord.set('ITEM_WIDTH',provider[0].ITEM_WIDTH);
										grdRecord.set('PACK_QTY',provider[0].PACK_QTY);
										grdRecord.set('PACK_TYPE',provider[0].PACK_TYPE);
									}else{
										Unilite.messageBox('이미 품목이 존재합니다.');
										panelResult.setValue('ITEM_CODE',grdRecord.get('ITEM_CODE'));
										panelResult.setValue('ITEM_NAME',grdRecord.get('ITEM_NAME'));
										directMasterStore.loadData({});
										UniAppManager.app.onQueryButtonDown();
										return false;
									}
								}else{
									grdRecord.set('KEEP_TEMPER','');
									grdRecord.set('ITEM_WIDTH','0');
									grdRecord.set('PACK_QTY','0');
									grdRecord.set('PACK_TYPE','');
									grdRecord.set('LABEL_NAME','');
									grdRecord.set('HOSPITAL_ITEM','');
									grdRecord.set('USE_TARGET','');
									grdRecord.set('REPORT_NO','');
									grdRecord.set('LABEL_TYPE','');
								}
							});
						},
						onClear:function(type) {
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('ITEM_CODE','');
							grdRecord.set('ITEM_NAME','');
							grdRecord.set('KEEP_TEMPER','');
							grdRecord.set('ITEM_WIDTH','0');
							grdRecord.set('PACK_QTY','0');
							grdRecord.set('PACK_TYPE','');
							grdRecord.set('LABEL_NAME','');
							grdRecord.set('HOSPITAL_ITEM','');
							grdRecord.set('USE_TARGET','');
							grdRecord.set('REPORT_NO','');
							grdRecord.set('LABEL_TYPE','');
						},
						applyExtParam:{
							scope:this,
							fn:function(popup){
								var param = {
									'DIV_CODE' :panelResult.getValue('DIV_CODE')
								}
								popup.setExtParam(param);
							}
						}
					}
				})
			},
			{dataIndex: 'LABEL_NAME'		, width: 160},
			{dataIndex: 'HOSPITAL_ITEM'		, width: 210},
			//20200511 추가: 반제품코드, 제품 라벨
			{dataIndex: 'ACCOUNT20_CODE'	, width: 100, hidden: hiddenChk},
			{dataIndex: 'ACCOUNT20_NAME'	, width: 160, hidden: hiddenChk},
			{dataIndex: 'USE_TARGET'		, width: 420},
			{dataIndex: 'REPORT_NO'			, width: 161},
			{dataIndex: 'KEEP_TEMPER'		, width: 90},
			{dataIndex: 'ITEM_WIDTH'		, width: 90},
			{dataIndex: 'PACK_QTY'			, width: 90},
			{dataIndex: 'PACK_TYPE'			, width: 90},
			{dataIndex: 'LABEL_TYPE'		, width: 90},
			{dataIndex: 'TYPE_NAME'			, width: 90},
			{dataIndex: 'LOT_ID'			, width: 90}
		],
		listeners: {
			beforeedit: function( editor, e, eOpts ) {
				if(!e.record.phantom) {
					if(UniUtils.indexOf(e.field, ['LABEL_NAME', 'HOSPITAL_ITEM', 'USE_TARGET', 'REPORT_NO', 'KEEP_TEMPER', 'ITEM_WIDTH','PACK_QTY','PACK_TYPE','LABEL_TYPE','TYPE_NAME','LOT_ID'])) {
						return true;
					} else {
						return false;
					}
				} else {
					if(UniUtils.indexOf(e.field, ['ITEM_CODE','ITEM_NAME','LABEL_NAME', 'HOSPITAL_ITEM', 'USE_TARGET', 'REPORT_NO', 'KEEP_TEMPER', 'ITEM_WIDTH','PACK_QTY','PACK_TYPE','LABEL_TYPE','TYPE_NAME','LOT_ID'])) {
						return true;
					} else {
						return false;
					}
				}
			},
			render: function(grid, eOpts){
				var girdNm = grid.getItemId();
				var store = grid.getStore();
				grid.getEl().on('click', function(e, t, eOpt) {
				});
			},
			selectionchange:function( model1, selected, eOpts ){
			}
		}
	});

	Unilite.Main({
		id			: 'bpr260ukrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				masterGrid, panelResult
			]
		}],
		fnInitBinding: function(params) {
			this.setDefault();
			UniAppManager.setToolbarButtons(['newData'], true);
		},
		onQueryButtonDown : function() {
			directMasterStore.loadStoreRecords();
			UniAppManager.setToolbarButtons('reset', true);
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');
			if(as.isHidden()) {
				as.show();
			}else {
				as.hide()
			}	
		},
		setDefault: function() {
			panelResult.setValue('DIV_CODE', UserInfo.divCode);
			UniAppManager.setToolbarButtons('save', false);
		},
		onResetButtonDown: function() {		// 새로고침 버튼
			panelResult.clearForm();
			panelResult.setAllFieldsReadOnly(false);
			directMasterStore.loadData({});
			this.fnInitBinding();
			UniAppManager.setToolbarButtons('save', false);
		},
		onNewDataButtonDown: function() {
			var divCode	= panelResult.getValue('DIV_CODE');
			var itemCode= panelResult.getValue('ITEM_CODE');
			var itemName= panelResult.getValue('ITEM_NAME');
			var keepTemper;
			var itemWidth;
			var packQty;
			var packType;

			if(!Ext.isEmpty(itemCode)){
				var param = {
					'ITEM_CODE': itemCode
				};
				bpr260ukrvService.checkDataInfo(param, function(provider, response) {
					if(!Ext.isEmpty(provider)){
						if(Ext.isEmpty(provider[0].ITEM_CODE)){
							keepTemper	= provider[0].KEEP_TEMPER;
							itemWidth	= provider[0].ITEM_WIDTH;
							packQty		= provider[0].PACK_QTY;
							packType	= provider[0].PACK_TYPE;
							var r = {
								 DIV_CODE	: divCode,
								 ITEM_CODE	: itemCode,
								 ITEM_NAME	: itemName,
								 KEEP_TEMPER: keepTemper,
								 ITEM_WIDTH	: itemWidth,
								 PACK_QTY	: packQty,
								 PACK_TYPE	: packType
							};
							masterGrid.createRow(r);
						}else{
							Unilite.messageBox('이미 품목이 존재합니다.');
							UniAppManager.app.onQueryButtonDown();
						}
					}
				});
			}else{
				 var r = {
					DIV_CODE	: divCode,
					ITEM_CODE	: itemCode,
					ITEM_NAME	: itemName
				};
				masterGrid.createRow(r);
			}
		},
		onSaveDataButtonDown: function(config) {
			//총인원 체크
			var selected = masterGrid.getSelectedRecord();
			if(directMasterStore.isDirty()){
			 directMasterStore.saveStore();
			}
		},
		onDeleteDataButtonDown: function() {
			if(confirm('<t:message code="system.message.product.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
				masterGrid.deleteSelectedRow();
			}
			if(masterGrid.getStore().getCount() > 0){
				UniAppManager.setToolbarButtons('save', true);
			}
		}
	});
};
</script>