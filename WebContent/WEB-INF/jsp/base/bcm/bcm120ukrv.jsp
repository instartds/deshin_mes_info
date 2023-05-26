<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bcm120ukrv" >
	<t:ExtComboStore comboType="BOR120" pgmId="bcm120ukrv"/>	<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B010"/>			<!-- 사용여부 -->
	<t:ExtComboStore comboType="AU" comboCode="B070"/>			<!-- 그룹설정 -->
	<t:ExtComboStore comboType="AU" comboCode="B131"/>			<!-- 예/아니오 -->
</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript">

var labelPartitionPrintWindow;//라벨분할출력
var BsaCodeInfo = {		//컨트롤러에서 값을 받아옴.
	gsCellCodeYN	: '${gsCellCodeYN}',
	gsSiteCode		: '${gsSiteCode}'
};

var hiddenChk  = true;
//20200507 추가: 이노베이션 라벨출력 관련
var hiddenChk2 = true;
if(BsaCodeInfo.gsSiteCode == 'KDG'){
	hiddenChk = false;
//20200507 추가: 이노베이션 라벨출력 관련
} else if(BsaCodeInfo.gsSiteCode == 'INNO'){
	hiddenChk2 = false;
}

function appMain() {
	var masterSelectedGrid	= 'bcm120ukrvGrid1';
	var gsCellCodeYN		= false;
	if(BsaCodeInfo.gsCellCodeYN == 'N') {
		gsCellCodeYN = true;
	}


	/** Proxy 정의
	 * @type
	 */
	var directProxy1 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'bcm120ukrvService.selectMaster',
			update	: 'bcm120ukrvService.updateDetail',
			create	: 'bcm120ukrvService.insertDetail',
			destroy	: 'bcm120ukrvService.deleteDetail',
			syncAll	: 'bcm120ukrvService.saveAll'
		}
	});

	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'bcm120ukrvService.selectMaster2',
			update	: 'bcm120ukrvService.updateDetail2',
			create	: 'bcm120ukrvService.insertDetail2',
			destroy	: 'bcm120ukrvService.deleteDetail2',
			syncAll	: 'bcm120ukrvService.saveAll'
		}
	});



	var masterForm = Unilite.createSearchPanel('searchForm', {
		title		: '<t:message code="system.label.base.searchconditon" default="검색조건"/>',
		region		: 'west',
		defaultType	: 'uniSearchSubPanel',
		collapsed	: UserInfo.appOption.collapseLeftSearch,
		listeners	: {
			collapse: function () {
			panelResult.show();
			},
			expand: function() {
			panelResult.hide();
			}
		},
		items: [{
			title		: '<t:message code="system.label.base.basisinfo2" default="기본정보"/>',
			itemId		: 'search_panel1',
			layout		: {type: 'uniTable', columns: 1},
			defaultType	: 'uniTextfield',
			items		: [{
			fieldLabel	: '<t:message code="system.label.base.division" default="사업장"/>',
			name		: 'TYPE_LEVEL',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelResult.setValue('TYPE_LEVEL', newValue);
				}
			}
			},{
			fieldLabel	: '<t:message code="system.label.base.warehoust" default="창고"/>',
			name		: 'TREE_NAME',
			xtype		: 'uniTextfield',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelResult.setValue('TREE_NAME', newValue);
				}
			}
			}]
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
						var labelText = invalid.items[0]['fieldLabel']+'은(는)';
					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
						var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
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
						var popupFC = item.up('uniPopupField') ;
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		},
		setLoadRecord: function(record) {
			var me = this;
			me.uniOpt.inLoading=false;
			me.setAllFieldsReadOnly(true);
		}
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		region	: 'north',
		layout	: {type : 'uniTable', columns : 3},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel	: '<t:message code="system.label.base.division" default="사업장"/>',
			name		: 'TYPE_LEVEL',
			xtype		: 'uniCombobox',
			value		: '01',
			comboType	: 'BOR120',
			allowBlank	: false,
			listeners	: {
			change: function(field, newValue, oldValue, eOpts) {
				masterForm.setValue('TYPE_LEVEL', newValue);
			}
			}
		},{
			fieldLabel	: '<t:message code="system.label.base.warehoust" default="창고"/>',
			name		: 'TREE_NAME',
			xtype		: 'uniTextfield',
			listeners	: {
			change: function(field, newValue, oldValue, eOpts) {
				masterForm.setValue('TREE_NAME', newValue);
			}
			}
		},{
			text:'<div style="color: red">라벨출력</div>',
			xtype: 'button',
			margin: '0 0 0 20',
			hidden: hiddenChk,
			handler: function(){
				var grdRecord	= masterGrid.getSelectedRecord();
				var grdRecord2	= masterGrid2.getSelectedRecords();
				var whCellCodes;

				if(Ext.isEmpty(grdRecord2)){
					Unilite.messageBox('<t:message code="system.message.product.message017" default="출력할 데이터가 없습니다."/>');
					return;
				}
				Ext.each(grdRecord2, function(record, idx) {
					if(idx ==0) {
						whCellCodes= record.get("WH_CELL_CODE");
					} else {
						whCellCodes= whCellCodes + ',' + record.get("WH_CELL_CODE");
					}
				});
				
				var param			= panelResult.getValues();
				param.PGM_ID		= 'bcm120ukrv';
				param.WH_CODE		= grdRecord.get('TREE_CODE');
				param.WH_NAME		= grdRecord.get('TREE_NAME');
				param.WH_CELL_CODES	= whCellCodes;
				var win = Ext.create('widget.ClipReport', {
					url		: CPATH+'/bcm/bcm120clukrv.do',
					prgID	: 'bcm120ukrv',
					extParam: param
				});
				win.center();
				win.show();
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
						var labelText = invalid.items[0]['fieldLabel']+'은(는)';
					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
						var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
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
						var popupFC = item.up('uniPopupField') ;
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		},
		setLoadRecord: function(record) {
			var me = this;
			me.uniOpt.inLoading=false;
			me.setAllFieldsReadOnly(true);
		}
	});



	Unilite.defineModel('Bcm120ukrvModel', {		// 메인1
		fields: [
			// 추가(극동)
			{name: 'CUSTOM_CODE'		, text: '<t:message code="system.label.base.customcode" default="거래처코드"/>'						, type: 'string'},
			{name: 'CUSTOM_NAME'		, text: '<t:message code="system.label.base.customname" default="거래처명"/>'						, type: 'string'},
			{name: 'TREE_CODE'			, text: '<t:message code="system.label.base.warehousecode" default="창고코드"/>'					, type: 'string', allowBlank: false},
			{name: 'TREE_NAME'			, text: '<t:message code="system.label.base.warehousename" default="창고명"/>'						, type: 'string', allowBlank: false},
			{name: 'TYPE_LEVEL'			, text: '<t:message code="system.label.base.division" default="사업장"/>'							, type: 'string', allowBlank: false, xtype: 'uniCombobox', comboType: 'BOR120'},
			{name: 'GROUP_CD'			, text: '<t:message code="system.label.base.groupset" default="그룹설정"/>'							, type: 'string', comboType: 'AU', comboCode: 'B070'},
			{name: 'SECTION_CD'			, text: '<t:message code="system.label.base.businessdivision" default="사업부"/>'					, type: 'string'},
			{name: 'USE_YN'				, text: '<t:message code="system.label.base.useyn" default="사용여부"/>'							, type: 'string', allowBlank: false, comboType: 'AU', comboCode: 'B010'},
			{name: 'PABSTOCK_YN'		, text: '<t:message code="system.label.base.availableinventoryapplyyn" default="가용재고 반영여부"/>'	, type: 'string', allowBlank: false, comboType: 'AU', comboCode: 'B010'},
			{name: 'SORT_SEQ'			, text: '<t:message code="system.label.base.arrangeorder" default="정렬순서"/>'						, type: 'int', allowBlank: false, defaultValue: '1'},
			{name: 'UPDATE_DB_USER'		, text: 'UPDATE_DB_USER'	, type: 'string'},
			{name: 'UPDATE_DB_TIME'		, text: 'UPDATE_DB_TIME'	, type: 'string'},
			{name: 'COMP_CODE'			, text: 'COMP_CODE'			, type: 'string'}
		]
	});

	Unilite.defineModel('Bcm120ukrvModel2', {		// detail
		fields: [
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.base.divisioncode" default="사업장코드"/>'					, type: 'string', allowBlank: false},
			{name: 'WH_CODE'			, text: '<t:message code="system.label.base.warehousecode" default="창고코드"/>'					, type: 'string', allowBlank: false},
			{name: 'WH_CELL_CODE'		, text: '<t:message code="system.label.base.warehousecellcode" default="창고Cell코드"/>'			, type: 'string', allowBlank: false},
			{name: 'WH_CELL_NAME'		, text: '<t:message code="system.label.inventory.warehousecellname" default="창고Cell명"/>'		, type: 'string', allowBlank: false},
			{name: 'USE_YN'				, text: '<t:message code="system.label.base.useyn" default="사용여부"/>'							, type: 'string', comboType: 'AU', comboCode: 'B010'},
			{name: 'VALID_YN'			, text: '<t:message code="system.label.base.validcellyn" default="유효CELL여부"/>'					, type: 'string', comboType: 'AU', comboCode: 'B010'},
			{name: 'WH_CELL_BARCODE'	, text: '<t:message code="system.label.base.warehousecellbarcode" default="창고Cell바코드"/>'		, type: 'string'},
			{name: 'REMARK'				, text: '<t:message code="system.label.base.remarks" default="비고"/>'							, type: 'string'},
			{name: 'INSERT_DB_USER'		, text: 'INSERT_DB_USER'	, type: 'string'},
			{name: 'INSERT_DB_TIME'		, text: 'INSERT_DB_TIME'	, type: 'string'},
			{name: 'UPDATE_DB_USER'		, text: 'UPDATE_DB_USER'	, type: 'string'},
			{name: 'UPDATE_DB_TIME'		, text: 'UPDATE_DB_TIME'	, type: 'string'},
			{name: 'COMP_CODE'			, text: 'COMP_CODE'			, type: 'string'},
			//20180828 추가
			{name: 'CUSTOM_CODE'		, text: '<t:message code="system.label.base.customcode" default="거래처코드"/>'						, type: 'string'},
			{name: 'CUSTOM_NAME'		, text: '<t:message code="system.label.base.customname" default="거래처명"/>'						, type: 'string'},
			{name: 'PABSTOCK_YN'		, text: '<t:message code="system.label.base.availableinventoryapplyyn" default="가용재고 반영여부"/>'	, type: 'string', comboType: 'AU', comboCode: 'B010'},
			//20200909 추가: DEFAULT_YN 추가
			{name: 'DEFAULT_YN'			, text: '<t:message code="system.label.common.basicsetting" default="기본설정"/>'					, type: 'string', comboType: 'AU', comboCode: 'B131'}
		]
	});



	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('bcm120ukrvMasterStore1', {
		model	: 'Bcm120ukrvModel',
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결
			editable	: true,		// 수정 모드 사용
			deletable	: true,		// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		proxy	: directProxy1,
		listeners: {
			write: function(proxy, operation){
			if (operation.action == 'destroy') {
				Ext.getCmp('panelResult').reset();
			}
			}
		},
		loadStoreRecords : function() {
			var param= panelResult.getValues();
			console.log( param );
			this.load({
			params : param,
			callback : function(records, operation, success) {
				if(success) {
				}
			}
			});
		},
		// 수정/추가/삭제된 내용 DB에 적용 하기
		saveStore : function(config) {
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
			var toUpdate = this.getUpdatedRecords();
			console.log("toUpdate",toUpdate);

			var rv = true;

			if(inValidRecs.length == 0 ) {
				config = {
					success: function(batch, option) {
						panelResult.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);
					}
				};
				this.syncAllDirect(config);
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners:{
			update:function( store, record, operation, modifiedFieldNames, eOpts ) {
			}
		}
	});

	var directMasterStore2 = Unilite.createStore('bcm120ukrvMasterStore2',{
		model	: 'Bcm120ukrvModel2',
		uniOpt	: {
			isMaster	: false,	// 상위 버튼 연결
			editable	: true,		// 수정 모드 사용
			deletable	: true,		// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		proxy	: directProxy2,
		autoLoad: false,
		loadStoreRecords : function(param){
			this.load({
			params: param
			});
		},
		saveStore: function(config) {
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
			var toUpdate = this.getUpdatedRecords();
			var list = [].concat(toUpdate, toCreate);
			console.log("toUpdate",toUpdate);

			var rv = true;
			if(inValidRecs.length == 0 ) {
				config = {
					success: function(batch, option) {
						panelResult.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);
					}
				};
				this.syncAllDirect(config);
			}else {
				masterGrid2.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				if(records[0] != null){
					UniAppManager.setToolbarButtons('delete', true);
					masterGrid2.getSelectionModel().select( 0 );
					if(!directMasterStore1.isDirty()) {
						UniAppManager.setToolbarButtons('save', false);
					}
				}
			},
			update : function( store, record, operation, modifiedFieldNames, details, eOpts ){
				UniAppManager.setToolbarButtons('save', true);
			},
			datachanged : function( store, eOpts ) {
				if( directMasterStore1.isDirty() || store.isDirty()) {
					UniAppManager.setToolbarButtons('save', true);
				}else {
					UniAppManager.setToolbarButtons('save', false);
				}
			}
		}
	});



	/** Master Grid1 정의(Grid Panel)
	* @type
	*/
	var masterGrid = Unilite.createGrid('bcm120ukrvGrid1', {
		store	: directMasterStore1,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			expandLastColumn	: false,
			useRowNumberer		: false,
			useMultipleSorting	: true
		},
		columns	: [
			{dataIndex: 'TREE_CODE'			, width:133},
			{dataIndex: 'TREE_NAME'			, width:220},
			// 추가(극동)
			{dataIndex: 'CUSTOM_CODE'		, width:150,
			editor: Unilite.popup('CUST_G',{
				textFieldName: 'CUSTOM_CODE',
				DBtextFieldName: 'CUSTOM_CODE',
				autoPopup: true,
				listeners:{
					'onSelected': {
						fn: function(records, type  ){
						var grdRecord = masterGrid.uniOpt.currentRecord;
						grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
						grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
						},
						scope: this
					},
					'onClear' : function(type)  {
						var grdRecord = masterGrid.uniOpt.currentRecord;
						grdRecord.set('CUSTOM_CODE','');
						grdRecord.set('CUSTOM_NAME','');
					}
				}
			})
			},
			{dataIndex: 'CUSTOM_NAME'		, width:300,
				editor: Unilite.popup('CUST_G',{
					autoPopup: true,
					listeners:{
						'onSelected': {
							fn: function(records, type) {
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
							grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
							},
							scope: this
						},
						'onClear' : function(type) {
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('CUSTOM_CODE','');
							grdRecord.set('CUSTOM_NAME','');
						}
					}
				})
			},
			{dataIndex: 'TYPE_LEVEL'		, width:200},
			{dataIndex: 'GROUP_CD'			, width:166},
			{dataIndex: 'SECTION_CD'		, width:166,hidden:true},
			{dataIndex: 'USE_YN'			, width:100},
			{dataIndex: 'PABSTOCK_YN'		, width:200},
			{dataIndex: 'SORT_SEQ'			, width:90},
			{dataIndex: 'UPDATE_DB_USER'	, width:0,hidden:true},
			{dataIndex: 'UPDATE_DB_TIME'	, width:0,hidden:true},
			{dataIndex: 'COMP_CODE'			, width:0,hidden:true}
		],
		listeners: {
			select: function() {
				selectedGrid = 'bcm120ukrvGrid1';
				UniAppManager.setToolbarButtons(['delete'], false);
			},
			cellclick: function() {
				selectedGrid = 'bcm120ukrvGrid1';
				UniAppManager.setToolbarButtons(['delete'], false);
			},
			render: function(grid, eOpts){
				var girdNm = grid.getItemId()
				grid.getEl().on('click', function(e, t, eOpt) {
					if(directMasterStore2.isDirty()){
						Unilite.messageBox(Msg.sMB154);
						return false;
					}else {
						masterSelectedGrid = girdNm;
						if(grid.getStore().getCount() > 0) {
							UniAppManager.setToolbarButtons('delete', true);
						}else {
							UniAppManager.setToolbarButtons('delete', false);
						}
					}
				});
			},
			selectionchange:function( model1, selected, eOpts ){
				if(selected.length > 0) {
					var record = selected[0];
					var param= masterForm.getValues();
					param.TYPE_LEVEL = record.get('TYPE_LEVEL');
					param.TREE_CODE = record.get('TREE_CODE');
					directMasterStore2.loadStoreRecords(param);
				}
			},
			beforeedit: function( editor, e, eOpts ) {
				if(e.record.phantom == false) {
					if(UniUtils.indexOf(e.field, ['TREE_CODE'])) {
						return false;
					} else {
						return true;
					}
				} else {
					if(UniUtils.indexOf(e.field,['CUSTOM_CODE', 'CUSTOM_NAME', 'TREE_CODE', 'TREE_NAME', 'DEPT_CODE', 'DEPT_NAME', 'TYPE_LEVEL',
												'GROUP_CD', 'USE_YN', 'PABSTOCK_YN', 'SORT_SEQ'])) {
						return true;
					} else {
						return false;
					}
				}
			}
		},
		setItemData: function(record, dataClear) {
			var grdRecord = this.uniOpt.currentRecord;
			if(dataClear) {
				grdRecord.set('TREE_CODE'		, record['TREE_CODE']);
				grdRecord.set('TREE_NAME'		, record['TREE_NAME']);
				grdRecord.set('TYPE_LEVEL'		, record['TYPE_LEVEL']);
				grdRecord.set('GROUP_CD'		, record['GROUP_CD']);
				grdRecord.set('SECTION_CD'		, record['SECTION_CD']);
				grdRecord.set('USE_YN'			, record['USE_YN']);
				grdRecord.set('PABSTOCK_YN'		, record['PABSTOCK_YN']);
				grdRecord.set('UPDATE_DB_USER'	, record['UPDATE_DB_USER']);
				grdRecord.set('UPDATE_DB_TIME'	, record['UPDATE_DB_TIME']);
				grdRecord.set('COMP_CODE'		, record['COMP_CODE']);
			} else {
				grdRecord.set('TREE_CODE'		, record['TREE_CODE']);
				grdRecord.set('TREE_NAME'		, record['TREE_NAME']);
				grdRecord.set('TYPE_LEVEL'		, record['TYPE_LEVEL']);
				grdRecord.set('GROUP_CD'		, record['GROUP_CD']);
				grdRecord.set('SECTION_CD'		, record['SECTION_CD']);
				grdRecord.set('USE_YN'			, record['USE_YN']);
				grdRecord.set('PABSTOCK_YN'		, record['PABSTOCK_YN']);
				grdRecord.set('UPDATE_DB_USER'	, record['UPDATE_DB_USER']);
				grdRecord.set('UPDATE_DB_TIME'	, record['UPDATE_DB_TIME']);
				grdRecord.set('COMP_CODE'		, record['COMP_CODE']);
			}
		}
	});

	var masterGrid2 = Unilite.createGrid('bcm120ukrvGrid2', {
		store	: directMasterStore2,
		layout	: 'fit',
		region	: 'south',
		uniOpt	: {
			expandLastColumn	: false,
			useRowNumberer		: false,
			useMultipleSorting	: true,
			useLiveSearch		: true,			//20200303 추가: 그리드 찾기기능 추가
			filter: {
				useFilter: true,
				autoCreate: true
			}
		},
		hidden	: gsCellCodeYN,
		//20200507 추가
		tbar	: [{
			itemId	: 'printBtn',
			text	: '<div style="color: red">라벨출력</div>',
			hidden	: hiddenChk2,
			handler	: function(){
				var grdRecord	= masterGrid.getSelectedRecord();
				var grdRecord2	= masterGrid2.getSelectedRecords();
				var whCellCodes;

				if(Ext.isEmpty(grdRecord2)){
					Unilite.messageBox('<t:message code="system.message.product.message017" default="출력할 데이터가 없습니다."/>');
					return;
				}

				Ext.each(grdRecord2, function(record, idx) {
					if(idx ==0) {
						whCellCodes= record.get("WH_CELL_CODE");
					} else {
						whCellCodes= whCellCodes	+ ',' + record.get("WH_CELL_CODE");
					}
				});

				var param			= panelResult.getValues();
				param.PGM_ID		= 'bcm120ukrv';
				param.WH_CODE		= grdRecord.get('TREE_CODE');
				param.WH_NAME		= grdRecord.get('TREE_NAME');
				param.WH_CELL_CODES	= whCellCodes;
				var win = Ext.create('widget.ClipReport', {
					url		: CPATH+'/bcm/bcm120clukrv_inno.do',
					prgID	: 'bcm120ukrv',
					extParam: param
				});
				win.center();
				win.show();
			}
		}],
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly : false, toggleOnClick:false }),
		columns	: [
			{dataIndex: 'DIV_CODE'			, width:66,hidden:true},
			{dataIndex: 'WH_CODE'			, width:66,hidden:true},
			{dataIndex: 'WH_CELL_CODE'		, width:133},
			{dataIndex: 'WH_CELL_NAME'		, width:220},
			{dataIndex: 'CUSTOM_CODE'		, width:150,
				editor: Unilite.popup('CUST_G',{
					textFieldName: 'CUSTOM_CODE',
					DBtextFieldName: 'CUSTOM_CODE',
					autoPopup: true,
					listeners:{
						'onSelected': {
							fn: function(records, type  ){
							var grdRecord = masterGrid2.uniOpt.currentRecord;
							grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
							grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
							},
							scope: this
						},
						'onClear' : function(type)  {
							var grdRecord = masterGrid2.uniOpt.currentRecord;
							grdRecord.set('CUSTOM_CODE','');
							grdRecord.set('CUSTOM_NAME','');
						}
					}
				})
			},
			{dataIndex: 'CUSTOM_NAME'		, width:300,
				editor: Unilite.popup('CUST_G',{
					autoPopup: true,
					listeners:{
						'onSelected': {
							fn: function(records, type  ){
							var grdRecord = masterGrid2.uniOpt.currentRecord;
							grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
							grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
							},
							scope: this
						},
						'onClear' : function(type)  {
							var grdRecord = masterGrid2.uniOpt.currentRecord;
							grdRecord.set('CUSTOM_CODE','');
							grdRecord.set('CUSTOM_NAME','');
						}
					}
				})
			},
			{dataIndex: 'USE_YN'			, width:100},
			{dataIndex: 'PABSTOCK_YN'		, width:120},
			{dataIndex: 'VALID_YN'			, width:100},
			{dataIndex: 'WH_CELL_BARCODE'	, width:166},
			//20200909 추가: DEFAULT_YN 추가
			{dataIndex: 'DEFAULT_YN'		, width:100	, align: 'center'},
			{dataIndex: 'REMARK'			, width:400},
			{dataIndex: 'INSERT_DB_USER'	, width:0,hidden:true},
			{dataIndex: 'INSERT_DB_TIME'	, width:0,hidden:true},
			{dataIndex: 'UPDATE_DB_USER'	, width:0,hidden:true},
			{dataIndex: 'UPDATE_DB_TIME'	, width:0,hidden:true},
			{dataIndex: 'COMP_CODE'			, width:0,hidden:true}
		],
		listeners: {
			select: function() {
				selectedGrid = 'bcm120ukrvGrid2';
				var count = masterGrid.getStore().getCount();
				var record = masterGrid.getSelectedRecord();
				if(count > 0) {
					UniAppManager.setToolbarButtons(['delete'], true);
				} else {
					UniAppManager.setToolbarButtons(['delete'], false);
				}
			},
			cellclick: function() {
				selectedGrid = 'bcm120ukrvGrid2';
				var count = masterGrid.getStore().getCount();
				var record = masterGrid.getSelectedRecord();
				if(count > 0) {
					UniAppManager.setToolbarButtons(['delete'], true);
				} else {
					UniAppManager.setToolbarButtons(['delete'], false);
				}
			},
			render: function(grid, eOpts){
				var girdNm = grid.getItemId()
				grid.getEl().on('click', function(e, t, eOpt) {
					if(directMasterStore1.isDirty()){
						grid.suspendEvents();
						Unilite.messageBox(Msg.sMB154);
					}else {
						masterSelectedGrid = girdNm;
						if(grid.getStore().getCount() > 0) {
							UniAppManager.setToolbarButtons('delete', true);
						}else {
							UniAppManager.setToolbarButtons('delete', false);
						}
					}
				});
			}
		}
	});



	Unilite.Main({
		id			: 'bcm120ukrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				masterGrid, masterGrid2, panelResult
			]
		},
			masterForm
		],
		fnInitBinding: function() {
			masterForm.setValue('TYPE_LEVEL'		, UserInfo.divCode);
			panelResult.setValue('TYPE_LEVEL'		, UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail', false);
			UniAppManager.setToolbarButtons('save'	, false);
			UniAppManager.setToolbarButtons(['reset','newData'], true);
		},
		onQueryButtonDown: function() {
			if(masterForm.setAllFieldsReadOnly(true) == false){
				return false;
			}
			directMasterStore1.loadStoreRecords();
			UniAppManager.setToolbarButtons('reset', true);
		},
		onResetButtonDown: function() {			// 초기화
			this.suspendEvents();
			masterForm.clearForm();
			masterForm.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);
			masterForm.setValue('TYPE_LEVEL'	, UserInfo.divCode);
			panelResult.setValue('TYPE_LEVEL'	, UserInfo.divCode);
			masterGrid.reset();
			masterGrid2.reset();
			this.fnInitBinding();
			UniAppManager.setToolbarButtons('save', false);
			directMasterStore1.clearData();
		},
		onNewDataButtonDown: function() {			// 행추가
			if(masterSelectedGrid == 'bcm120ukrvGrid1'){
				// 추가(극동)
				var customCode		='';
				var customName		='';
				var treeCode		= '';
				var treeName		= '';
				var typeLevel		= '';
				var groupCd			= '';
				var sectionCd		= '';
				var useYn			= 'Y';
				var pabstockYn		= 'Y';
				var updateDbUser	= '';
				var updateDbTiome	= '';
				var compCode		= UserInfo.compCode;
	
				var r = {
					// 추가(극동)
					CUSTOM_CODE		: customCode,
					CUSTOM_NAME		: customName,
					TREE_CODE		: treeCode,
					TREE_NAME		: treeName,
					TYPE_LEVEL		: typeLevel,
					GROUP_CD		: groupCd,
					SECTION_CD		: sectionCd,
					USE_YN			: useYn,
					PABSTOCK_YN		: pabstockYn,
					UPDATE_DB_USER	: updateDbUser,
					UPDATE_DB_TIME	: updateDbTiome,
					COMP_CODE		: compCode
				};
				masterGrid.createRow(r);
			}else if(masterSelectedGrid == 'bcm120ukrvGrid2'){
				var masterRecord= masterGrid2.getSelectedRecord();
				var USEYN		= 'Y';
				var VALIDYN		= 'Y';
				var grdRecord	= masterGrid.getSelectedRecord();
	
	//			var grdRecord = masterGrid.uniOpt.currentRecord;
	//			Unilite.messageBox(grdRecord.get('TYPE_LEVEL'));
	//			Unilite.messageBox(grdRecord.get('TREE_CODE'));
				var compCode		= UserInfo.compCode;
				var insertDbUser	= '';
				var insertDbTiome	= '';
				var updateDbUser	= '';
				var updateDbTiome	= '';
			//20200327 주석
//			if(masterRecord) {
				var r = {
					USE_YN			: USEYN,
					PABSTOCK_YN		: 'Y',
					VALID_YN		: VALIDYN,
					DIV_CODE		: grdRecord.get('TYPE_LEVEL'),
					WH_CODE			: grdRecord.get('TREE_CODE'),
					COMP_CODE		: compCode,
					//20200909 추가: DEFAULT_YN 추가
					DEFAULT_YN		: 'N',
					INSERT_DB_USER	: insertDbUser,
					INSERT_DB_TIME	: insertDbTiome,
					UPDATE_DB_USER	: updateDbUser,
					UPDATE_DB_TIME	: updateDbTiome
				};
				masterGrid2.createRow(r);
//			}
			}
		},
		onSaveDataButtonDown: function(config) {	// 저장 버튼
			directMasterStore1.saveStore();
			directMasterStore2.saveStore();
		},
		rejectSave: function() {				// 저장
			var rowIndex = masterGrid.getSelectedRowIndex();
			masterGrid.select(rowIndex);
			directMasterStore1.rejectChanges();

			if(rowIndex >= 0){
				masterGrid.getSelectionModel().select(rowIndex);
				var selected = masterGrid.getSelectedRecord();
	
				var selected_doc_no = selected.data['DOC_NO'];
					bdc100ukrvService.getFileList(
					{DOC_NO : selected_doc_no},
					function(provider, response) {
					}
				);
			}
			directMasterStore1.onStoreActionEnable();
		},
		confirmSaveData: function(config) {			// 저장하기전 원복 시키는 작업
			var fp = Ext.getCmp('bcm120ukrvFileUploadPanel');
			if(masterStore.isDirty() || fp.isDirty()) {
				if(confirm(Msg.sMB061)) {
					this.onSaveDataButtonDown(config);
				} else {
					this.rejectSave();
				}
			}
		},
		onDeleteDataButtonDown: function() {
			if(masterSelectedGrid == 'bcm120ukrvGrid1'){
				var Grid1		= UniAppManager.app.down('#bcm120ukrvGrid1');
				var selRow		= masterGrid.getSelectedRecord();
				var selIndex	= masterGrid.getSelectedRowIndex();
	
				if(confirm('<t:message code="system.message.base.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
					masterGrid.deleteSelectedRow(selIndex);
					masterGrid.getStore().onStoreActionEnable();
				}
				UniAppManager.setToolbarButtons('save', true);
			}

			else if(masterSelectedGrid == 'bcm120ukrvGrid2'){
				var Grid1		= UniAppManager.app.down('#bcm120ukrvGrid2');
				var selRow		= masterGrid2.getSelectedRecord();
				var selIndex	= masterGrid2.getSelectedRowIndex();
	
				if(confirm('<t:message code="system.message.base.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
					masterGrid2.deleteSelectedRow(selIndex);
					masterGrid2.getStore().onStoreActionEnable();
				}
				UniAppManager.setToolbarButtons('save', true);
			}
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');
			if(as.isHidden()) {
				as.show();
			} else {
				as.hide()
			}
		},
		fnWorkShopChange: function(records) {
			grdRecord = masterGrid.getSelectedRecord();
			record = records[0];
			grdRecord.set('WH_CODE', record.TREE_CODE);
			grdRecord.set('DIV_CODE', record.TYPE_LEVEL);
			if(Ext.isEmpty(grdRecord.get('DIV_CODE'))){
				grdRecord.set('DIV_CODE', record.TYPE_LEVEL);
			}
		}
	});
};
</script>