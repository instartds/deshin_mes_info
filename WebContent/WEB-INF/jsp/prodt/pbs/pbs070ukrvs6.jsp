<%@page language="java" contentType="text/html; charset=utf-8"%>
	var ItemCopyWindow;			//타품목복사 팝업
	var WorkShopCopyWindow;		//작업장복사 팝업
	var process_count_register = {
		itemId	: 'process_count_register',
		id		: 'process_count_register',
		layout	: {type: 'vbox', align:'stretch'},
		items	: [{
			title	: '<t:message code="system.label.product.routingorderentry" default="공정수순등록"/>',
			itemId	: 'tab_pbs070ukrvs6Tab',
			id		: 'tab_pbs070ukrvs6Tab',
			xtype	: 'uniDetailFormSimple',
			layout	: {type: 'vbox', align:'stretch'},
			padding	: '0 0 0 0',
			items	: [{
				xtype	: 'container',
				id		: 'container6',
				layout	: {type: 'uniTable', columns : 4},
				items	: [{
					fieldLabel	: '<t:message code="system.label.product.division" default="사업장"/>',
					name		: 'DIV_CODE',
					xtype		: 'uniCombobox',
					comboType	: 'BOR120',
					value		: UserInfo.divCode,
					allowBlank	: false,
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {
							panelDetail.down('#tab_pbs070ukrvs6Tab').setValue('WORK_SHOP_CODE', '');
						}
					}
				},{
					fieldLabel	: '<t:message code="system.label.product.workcenter" default="작업장"/>',
					name		: 'WORK_SHOP_CODE',
					xtype		: 'uniCombobox',
					comboType	: 'WU',
					allowBlank	: false,
					listeners	: {
						beforequery:function( queryPlan, eOpts ) {
							var store = queryPlan.combo.store;
							store.clearFilter();
							if(!Ext.isEmpty(panelDetail.down('#tab_pbs070ukrvs6Tab').getValue('DIV_CODE'))){
								store.filterBy(function(record){
									return record.get('option') == panelDetail.down('#tab_pbs070ukrvs6Tab').getValue('DIV_CODE');
								})
							} else {
								store.filterBy(function(record){
									return false;
								})
							}
						}
					}
				},{
					fieldLabel  : '<t:message code="system.label.product.majorgroup" default="대분류"/>',
					name		: 'ITEM_LEVEL1',
					xtype		: 'uniCombobox',
					store		: Ext.data.StoreManager.lookup('itemLeve1Store'),
					child		: 'ITEM_LEVEL2',
					levelType	: 'ITEM'
				},{
					xtype	: 'button',
					name	: 'ITEM_COPY',
					text	: '<t:message code="system.label.product.itemcopy" default="타품목복사"/>',
					width	: 100,
					margin	: '0 0 0 120',
					handler	: function() {
						OpenItemCopyWindow();
					}
				},{
					fieldLabel	: '<t:message code="system.label.product.item" default="품목"/>',
					xtype		: 'uniTextfield',
					name		: 'ITEM_CODE1',
					hidden		: true
				},
				Unilite.popup('DIV_PUMOK',{
					fieldLabel		: '<t:message code="system.label.product.item" default="품목"/>',
					valueFieldName	: 'ITEM_FR_CODE',
					textFieldName	: 'ITEM_FR_NAME',
					validateBlank	: false,
					textFieldWidth	: 135,
					popupWidth		: 700,
					listeners		: {
						onValueFieldChange: function( elm, newValue, oldValue ) {
							if(!Ext.isObject(oldValue)) {
								panelDetail.down('#tab_pbs070ukrvs6Tab').setValue('ITEM_FR_NAME', '');
							}
						},
						onTextFieldChange: function( elm, newValue, oldValue ) {
							if(!Ext.isObject(oldValue)) {
								panelDetail.down('#tab_pbs070ukrvs6Tab').setValue('ITEM_FR_CODE', '');
							}
						},
						applyextparam: function(popup){
							var param =  panelDetail.down('#tab_pbs070ukrvs6Tab').getValues();
							popup.setExtParam({'DIV_CODE': param.DIV_CODE});
						}
					}
				}),{
					fieldLabel	: '<t:message code="system.label.product.itemaccount" default="품목계정"/>',
					name		: 'ITEM_ACCOUNT',
					xtype		: 'uniCombobox',
					comboCode	: 'B020',
					comboType	: 'AU'
				},{
					fieldLabel  : '<t:message code="system.label.product.middlegroup" default="중분류"/>',
					name		: 'ITEM_LEVEL2',
					xtype		:'uniCombobox',
					store		: Ext.data.StoreManager.lookup('itemLeve2Store'),
					child		: 'ITEM_LEVEL3',
					colspan		: gsSiteFlag ? 1:2
				},{	//20200603 추가: 작업장복사 버튼 추가
					xtype	: 'button',
					name	: 'COPY_WORKSHOP',
					text	: '작업장복사',
					width	: 100,
					margin	: '0 0 0 120',
					hidden	: !gsSiteFlag,
					handler	: function() {
						if(Ext.isEmpty(Ext.getCmp('tab_pbs070ukrvs6Tab').down('#pbs070ukrvs_6Grid').getSelectedRecord())){
							Unilite.messageBox('복사할 품목을 먼저 선택하십시오.');
						} else {
							OpenWorkShopCopyWindow();
						}
					}
				},{
					fieldLabel	: '<t:message code="system.label.product.procurementclassification" default="조달구분"/>',
					name		: 'SUPPLY_TYPE',
					xtype		: 'uniCombobox',
					comboCode	: 'B014',
					comboType	: 'AU'
				},{
					xtype		: 'radiogroup',
					fieldLabel	: '등록여부',
					labelWidth	: 90,
//					colspan		: 2,
					items		: [{
						boxLabel	: '<t:message code="system.label.product.whole" default="전체"/>',
						width		: 60,
						name		: 'ACC_STATUS',
						inputValue	: '0',
						checked		: true
					},{
						boxLabel	: '등록',
						width		: 60,
						name		: 'ACC_STATUS',
						inputValue	: '1'
					},{
						boxLabel	: '미등록',
						width		: 60,
						name		: 'ACC_STATUS',
						inputValue	: '2'
					}]
				},{
					fieldLabel	: '<t:message code="system.label.product.minorgroup" default="소분류"/>',
					name		: 'ITEM_LEVEL3',
					xtype		: 'uniCombobox',
					colspan		: 2,
					store		: Ext.data.StoreManager.lookup('itemLeve13Store'),
					parentNames : ['ITEM_LEVEL1','ITEM_LEVEL2']
				},{
					xtype	: 'container',
					padding	: '-5 10 0 0',
					layout	: {
						type	: 'hbox',
						align	: 'center',
						pack	: 'center'
					}
				}]
			},{
				xtype	: 'uniGridPanel',
				itemId	: 'pbs070ukrvs_6Grid',
				store	: pbs070ukrvs_6Store,
				padding	: '0 0 0 0',
				dockedItems: [{
					xtype	: 'toolbar',
					dock	: 'top',
					padding	: '0px',
					border	: 0
				}],
				selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: false, toggleOnClick: false }),
				uniOpt:{
					expandLastColumn	: true,
					useRowNumberer		: true,
					onLoadSelectFirst	: true,
					useMultipleSorting	: false
				},
				columns: [
					{dataIndex: 'COMP_CODE'				, width: 80, hidden: true},
					{dataIndex: 'ITEM_CODE'				, width: 100},
					{dataIndex: 'ITEM_NAME'				, width: 250},
					{dataIndex: 'SPEC'					, width: 133},
					{dataIndex: 'STOCK_UNIT'			, width: 53},
					{dataIndex: 'ITEM_ACCOUNT'			, width: 66, hidden: true},
					{dataIndex: 'ITEMACCOUNT_NAME'		, width: 80},
					{dataIndex: 'SUPPLY_TYPE'			, width: 80},
					{dataIndex: 'PROG_CNT'				, width: 80},
					{dataIndex: 'ITEMLEVEL1_NAME'		, width: 150},
					{dataIndex: 'ITEMLEVEL2_NAME'		, width: 150},
					{dataIndex: 'ITEMLEVEL3_NAME'		, width: 150}
				],
				listeners: {
					selectionchange:function(selected, eOpts ) {
						//Ext.getCmp('tab_pbs070ukrvs6Tab').down('#pbs070ukrvs_6Grid').getSelectedRecord();
						var record = Ext.getCmp('tab_pbs070ukrvs6Tab').down('#pbs070ukrvs_6Grid').getSelectedRecord();
						if(!Ext.isEmpty(record)) {
							this.returnCell(record);
							process_count_register.fnSelectList6_2Change(record);
						} else {
							//20200603 수정: 오류로 인해 초기화로직 변경
//							panelDetail.down('#pbs070ukrvs_6Grid2').reset();
//							pbs070ukrvs_6Store2.clearData();
							pbs070ukrvs_6Store2.loadData({});
							return false;
						}
					},
					beforeedit  : function( editor, e, eOpts ) {
						if(!e.record.phantom) {
							if(UniUtils.indexOf(e.field, ['COMP_CODE', 'ITEM_CODE', 'ITEM_NAME', 'SPEC', 'STOCK_UNIT', 'ITEM_ACCOUNT', 'ITEMACCOUNT_NAME',
															'SUPPLY_TYPE', 'PROG_CNT', 'ITEMLEVEL1_NAME', 'ITEMLEVEL2_NAME', 'ITEMLEVEL3_NAME'])) {
								return false;
							}
						} else {
							if(UniUtils.indexOf(e.field, ['COMP_CODE', 'ITEM_CODE', 'ITEM_NAME', 'SPEC', 'STOCK_UNIT', 'ITEM_ACCOUNT', 'ITEMACCOUNT_NAME',
															'SUPPLY_TYPE', 'PROG_CNT', 'ITEMLEVEL1_NAME', 'ITEMLEVEL2_NAME', 'ITEMLEVEL3_NAME'])) {
								return false;
							}
						}
					}
				},
				returnCell: function(record){
					var itemCode = record.get("ITEM_CODE");
					panelDetail.down('#tab_pbs070ukrvs6Tab').setValues({'ITEM_CODE1':itemCode});
				}
			},{
				xtype		: 'uniGridPanel',
				itemId		: 'pbs070ukrvs_6Grid2',
				store		: pbs070ukrvs_6Store2,
				padding		: '0 0 0 0',
				region		: 'south',
				dockedItems	: [{
					xtype	: 'toolbar',
					dock	: 'top',
					padding	: '0px',
					border	: 0
				}],
				uniOpt:{
					expandLastColumn	: true,
					useRowNumberer		: true,
					useMultipleSorting	: false
				},
				features: [
					{id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: true},
					{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: true}
				],
				columns: [
					{dataIndex: 'COMP_CODE'				, width: 33, hidden: true},
					{dataIndex: 'SORT_FLD'				, width: 33, hidden: true},
					{dataIndex: 'DIV_CODE'				, width: 33, hidden: true},
					{dataIndex: 'ITEM_CODE'				, width: 66, hidden: true},
					{dataIndex: 'WORK_SHOP_CODE'		, width: 33, hidden: true},
					{dataIndex: 'PROG_WORK_CODE'		, width: 100},
					{dataIndex: 'PROG_WORK_NAME'		, width: 200,
						summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
								return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.product.subtotal" default="소계"/>', '<t:message code="system.label.product.total" default="총계"/>');
					}},
					{dataIndex: 'LINE_SEQ'				, width: 80},
					{dataIndex: 'MAKE_LDTIME'			, width: 133, summaryType:'sum'},
					{dataIndex: 'PROG_RATE'				, width: 120, summaryType:'sum'},
					{dataIndex: 'PROG_UNIT_Q'			, width: 120},
					{dataIndex: 'PROG_UNIT'				, width: 100}
				],
				listeners: {
					beforeedit  : function( editor, e, eOpts ) {
						if(!e.record.phantom) {
							if(UniUtils.indexOf(e.field, ['LINE_SEQ', 'MAKE_LDTIME', 'PROG_RATE', 'PROG_UNIT_Q'])) {
								return true;
							} else {
								return false
							}
						} else {
							if(UniUtils.indexOf(e.field, ['LINE_SEQ', 'MAKE_LDTIME', 'PROG_RATE', 'PROG_UNIT_Q'])) {
								return true;
							} else {
								return false
							}
						}
					}
				}
			}],
			setAllFieldsReadOnly6 : function(b) {
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
					} else {
					//	this.mask();
					}
				} else {
					this.unmask();
				}
				return r;
			}
		}],
		fnSelectList6_2Change: function(records) {
			var record = Ext.getCmp('tab_pbs070ukrvs6Tab').down('#pbs070ukrvs_6Grid').getSelectedRecord();
			if(!Ext.isEmpty(record)){
				var param =  panelDetail.down('#tab_pbs070ukrvs6Tab').getValues();
				param.ITEM_CODE = record.get('ITEM_CODE')
				pbs070ukrvs_6Store2.loadStoreRecords(param);
			} else {
				panelDetail.down('#pbs070ukrvs_6Grid2').reset();
				pbs070ukrvs_6Store2.clearData();
				return false;
			}
		}
	};



	//타품목복사 폼
	var ItemCopyWindowForm = Unilite.createSearchForm('pbs070ukrvsItemCopy', {
		layout	: {type : 'uniTable', columns : 3},
		items	: [{
			fieldLabel	: '<t:message code="system.label.product.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			value		: UserInfo.divCode,
			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelDetail.down('#tab_pbs070ukrvs6Tab').setValue('WORK_SHOP_CODE','');
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.product.workcenter" default="작업장"/>',
			name		: 'WORK_SHOP_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'WU',
			colspan		: 2,
			allowBlank	: false,
			listeners	: {
				beforequery:function( queryPlan, eOpts ) {
					var store = queryPlan.combo.store;
					store.clearFilter();
					if(!Ext.isEmpty(panelDetail.down('#tab_pbs070ukrvs6Tab').getValue('DIV_CODE'))){
						store.filterBy(function(record){
							return record.get('option') == panelDetail.down('#tab_pbs070ukrvs6Tab').getValue('DIV_CODE');
						})
					} else {
						store.filterBy(function(record){
							return false;
						})
					}
				}
			}
		},
		Unilite.popup('DIV_PUMOK',{
			fieldLabel: '<t:message code="system.label.product.item" default="품목"/>',
			valueFieldName: 'ITEM_CODE',
			textFieldName: 'ITEM_NAME',
			textFieldWidth: 170,
			allowBlank:false,
			popupWidth: 710,
			listeners: {
				onValueFieldChange: function( elm, newValue, oldValue ) {
					if(!Ext.isObject(oldValue)) {
						panelDetail.down('#tab_pbs070ukrvs6Tab').setValue('ITEM_NAME', '');
					}
				},
				onTextFieldChange: function( elm, newValue, oldValue ) {
					if(!Ext.isObject(oldValue)) {
						panelDetail.down('#tab_pbs070ukrvs6Tab').setValue('ITEM_CODE', '');
					}
				},
				applyextparam: function(popup){
					var param =  panelDetail.down('#tab_pbs070ukrvs6Tab').getValues();
					popup.setExtParam({'DIV_CODE': param.DIV_CODE});
				}
			}
		}),{
			name:'SPEC',
			xtype:'uniTextfield',
			readOnly:true,
			holdable: 'hold',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			name:'ITEMS',
			xtype:'uniTextfield',
			readOnly:true,
			hidden:true,
			holdable: 'hold',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		}]
	});
	//타품목복사 모델
	Unilite.defineModel('pbs070ukrvsItemCopyWindowModel', {
		fields: [
			{name: 'COMP_CODE'			,text: '<t:message code="system.label.product.compcode" default="법인코드"/>'			,type: 'string'},
			{name: 'LINE_SEQ'			,text: '<t:message code="system.label.product.routingorder" default="공정순서"/>'		,type: 'string'},
			{name: 'PROG_WORK_CODE'		,text: '<t:message code="system.label.product.routingcode" default="공정코드"/>'		,type: 'string'},
			{name: 'PROG_WORK_NAME'		,text: '<t:message code="system.label.product.routingname" default="공정명"/>'			,type: 'string'},
			{name: 'PROG_UNIT'			,text: '<t:message code="system.label.product.routingunit" default="공정단위"/>'		,type: 'string'},
			{name: 'MAKE_LDTIME'		,text: '공정리드타임(일)' ,type: 'string'},
			{name: 'PROG_RATE'			,text: '공정진척률(%)'		,type: 'uniQty'},
			{name: 'PROG_UNIT_Q'		,text: '<t:message code="system.label.product.routingunitqty" default="공정원단위량"/>'	,type: 'uniQty'}
		]
	});
	//타품목복사 스토어
	var ItemCopyWindowStore = Unilite.createStore('pbs070ukrvsItemCopyWindowStore', {
		model	: 'pbs070ukrvsItemCopyWindowModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		proxy	: {
			type: 'direct',
			api	: {
				read: 'pbs070ukrvsService.selectItemCopyList'
			}
		},
		loadStoreRecords : function()  {
			var param= ItemCopyWindowForm.getValues();
//			param.CUSTOM_CODE = process_count_register.getValue('CUSTOM_CODE');
//			if(Ext.isEmpty(param.CUSTOM_CODE)){
//				return false;
//			}
			console.log( param );
			this.load({
				params : param
			});
			/*var viewNormal = purchaseItemSearchGrid.getView();
			viewNormal.getFeature('purchaseItemSearchGridTotal').toggleSummaryRow(true);*/
		}
	});
	//타품목복사 그리드
	var ItemCopyWindowGrid = Unilite.createGrid('pbs070ukrvsItemCopyWindowGrid', {
		store	: ItemCopyWindowStore,
		layout	: 'fit',
		selModel: Ext.create('Ext.selection.CheckboxModel', {checkOnly: false, toggleOnClick: false}),
		uniOpt	: {
			expandLastColumn	: false,
			useRowNumberer		: true,
			onLoadSelectFirst	: true,
			useMultipleSorting	: false,
			expandLastColumn	: true
		},
		columns	: [
			{dataIndex: 'COMP_CODE'			, width: 80, hidden: true},
			{dataIndex: 'LINE_SEQ'			, width: 80},
			{dataIndex: 'PROG_WORK_CODE'	, width: 120},
			{dataIndex: 'PROG_WORK_NAME'	, width: 120},
			{dataIndex: 'PROG_UNIT'			, width: 120},
			{dataIndex: 'MAKE_LDTIME'		, width: 120},
			{dataIndex: 'PROG_RATE'			, width: 120},
			{dataIndex: 'PROG_UNIT_Q'		, width: 120}
		],
		returnData: function() {
			//masterGrid.reset();
			var index = 0;
			var records = ItemCopyWindowStore.data.items;
			var detailRecords = pbs070ukrvs_6Store2.data.items;
			Ext.each(records, function(record, i) {
				Ext.each(detailRecords, function(detailRecord, k) {
					if ( record.get('DIV_CODE') == ItemCopyWindowForm.getValue('DIV_CODE')
						&& record.get('WORK_SHOP_CODE') == ItemCopyWindowForm.getValue('WORK_SHOP_CODE')
						&& record.get('PROG_WORK_CODE') == detailRecord.get('PROG_WORK_CODE')) {

						detailRecord.set('ITEM_CODE'		, ItemCopyWindowForm.getValue('ITEMS'));
						detailRecord.set('PROG_WORK_CODE'	, record.get('PROG_WORK_CODE'));
						detailRecord.set('PROG_WORK_NAME'	, record.get('PROG_WORK_NAME'));
						detailRecord.set('LINE_SEQ'			, record.get('LINE_SEQ'));
						detailRecord.set('MAKE_LDTIME'		, record.get('MAKE_LDTIME'));
						detailRecord.set('PROG_RATE'		, record.get('PROG_RATE'));
						detailRecord.set('PROG_UNIT_Q'		, record.get('PROG_UNIT_Q'));
						detailRecord.set('PROG_UNIT'		, record.get('PROG_UNIT'));
					}
				});
			});
			this.getStore().remove(records);
		}
	});
	function OpenItemCopyWindow() {
		if(!ItemCopyWindow) {
			ItemCopyWindow = Ext.create('widget.uniDetailWindow', {
				title	: '<t:message code="system.label.product.iteminfo" default="품목정보"/>',
				width	: 1080,
				height	: 580,
				layout	: {type:'vbox', align:'stretch'},
				items	: [ItemCopyWindowForm, ItemCopyWindowGrid],
				tbar	: ['->',{
					itemId	: 'saveBtn',
					text	: '<t:message code="system.label.product.inquiry" default="조회"/>',
					handler	: function() {
						if(!ItemCopyWindowForm.getInvalidMessage()){
							return false
						}
						ItemCopyWindowStore.loadStoreRecords();
					},
					disabled: false
				},{
					itemId	: 'confirmBtn',
					text	: '<t:message code="system.label.product.apply" default="적용"/>',
					handler	: function() {
						ItemCopyWindowGrid.returnData();
					},
					disabled: false
				},{
					itemId	: 'confirmCloseBtn',
					text	: '<t:message code="system.label.product.afterapplyclose" default="적용 후 닫기"/>',
					handler	: function() {
						ItemCopyWindowGrid.returnData();
						ItemCopyWindow.hide();
						UniAppManager.setToolbarButtons('reset', true)
					},
					disabled: false
				},{
					itemId	: 'closeBtn',
					text	: '<t:message code="system.label.product.close" default="닫기"/>',
					handler	: function() {
						ItemCopyWindow.hide();
					},
					disabled: false
				}],
				listeners : {
					beforehide: function(me, eOpt) {
						ItemCopyWindowForm.clearForm();
						ItemCopyWindowGrid.reset();
					},
					 beforeclose: function( panel, eOpts )  {
						ItemCopyWindowForm.clearForm();
						ItemCopyWindowGrid.reset();
					},
					show: function( panel, eOpts ) {
						var masterRecords = Ext.getCmp('tab_pbs070ukrvs6Tab').down('#pbs070ukrvs_6Grid').getSelectedRecords();
						Ext.each(masterRecords, function(masterRecord, j) {
							var items = ItemCopyWindowForm.getValue('ITEMS')
							if(Ext.isEmpty(items)) {
								ItemCopyWindowForm.setValue('ITEMS', masterRecord.get('ITEM_CODE'));
							} else {
								ItemCopyWindowForm.setValue('ITEMS', items + ',' + masterRecord.get('ITEM_CODE'));
							}
						});
						ItemCopyWindowForm.setValue('DIV_CODE', Ext.getCmp('tab_pbs070ukrvs6Tab').getValue('DIV_CODE'));
						ItemCopyWindowForm.setValue('WORK_SHOP_CODE', Ext.getCmp('tab_pbs070ukrvs6Tab').getValue('WORK_SHOP_CODE'));
					}
				}
			})
		}
		ItemCopyWindow.center();
		ItemCopyWindow.show();
	};



	/* 작업장 복사: 20200603 추가
	 */
	var WorkShopCopyWindowForm = Unilite.createSearchForm('pbs070ukrvsWorkShopCopy', {
		layout	: {type : 'uniTable', columns : 2},
		items	: [{
			fieldLabel	: '<t:message code="system.label.product.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			readOnly	: true
		},{
			fieldLabel	: '<t:message code="system.label.product.item" default="품목"/>',
			name		: 'ITEM_CODE',
			xtype		: 'uniTextfield',
			hidden		: true,
			readOnly	: true
		},{
			fieldLabel	: '<t:message code="system.label.product.workcenter" default="작업장"/>',
			name		: 'WORK_SHOP_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'WU',
			allowBlank	: false,
			hidden		: true
		},{
			fieldLabel	: '조회조건',
			name		: 'WORK_SHOP_CODE_QUERY',
			labelWidth	: 150,
			xtype		: 'textfield'
		},{
			xtype		: 'radiogroup',
			fieldLabel	: ' ',
			items		: [{
				boxLabel	: '<t:message code="system.label.product.codeinorder" default="코드순"/>',
				name		: 'ACC_STATUS',
				inputValue	: '0',
				width		: 70,
				checked		: true
			},{
				boxLabel	: '<t:message code="system.label.product.nameinorder" default="이름순"/>',
				name		: 'ACC_STATUS',
				inputValue	: '1',
				width		: 60
			}]
		}]
	});
	Unilite.defineModel('pbs070ukrvsWorkShopCopyWindowModel', {
		fields: [
			{name: 'COMP_CODE'	,text: '<t:message code="system.label.product.compcode" default="법인코드"/>'		,type: 'string'},
			{name: 'TYPE_LEVEL'	,text: '<t:message code="system.label.product.division" default="사업장"/>'		,type: 'string'},
			{name: 'TREE_CODE'	,text: '<t:message code="system.label.product.workcenter" default="작업장"/>'		,type: 'string'},
			{name: 'TREE_NAME'	,text: '<t:message code="system.label.product.workcentername" default="작업장명"/>'	,type: 'string'}
		]
	});
	var WorkShopCopyWindowStore = Unilite.createStore('pbs070ukrvsWorkShopCopyWindowStore', {
		model	: 'pbs070ukrvsWorkShopCopyWindowModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		proxy: {
			type: 'direct',
			api	: {
				read: 'pbs070ukrvsService.selectWorkShopCopyWindowList'
			}
		},
		loadStoreRecords : function()  {
			var param = WorkShopCopyWindowForm.getValues();
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	var WorkShopCopyWindowGrid = Unilite.createGrid('pbs070ukrvsWorkShopCopyWindowGrid', {
		store	: WorkShopCopyWindowStore,
		layout	: 'fit',
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly : false, toggleOnClick:false, mode: 'SIMPLE' }),
		uniOpt	: {
			onLoadSelectFirst	: false,
			expandLastColumn	: false,
			useRowNumberer		: false
		},
		columns	: [{
				xtype	: 'rownumberer',
				sortable: false,
				align	: 'center !important',
				resizable: true, 
				width	: 35
			},
			{dataIndex: 'COMP_CODE'	, width: 80	, hidden: true},
			{dataIndex: 'TYPE_LEVEL', width: 100, hidden: true},
			{dataIndex: 'TREE_CODE'	, width: 100},
			{dataIndex: 'TREE_NAME'	, flex: 1}
		]
	});
	function OpenWorkShopCopyWindow() {
		if(!WorkShopCopyWindow) {
			WorkShopCopyWindow = Ext.create('widget.uniDetailWindow', {
				title	: '작업장복사',
				width	: 680,
				height	: 400,
				layout	: {type:'vbox', align:'stretch'},
				items	: [WorkShopCopyWindowForm, WorkShopCopyWindowGrid],
				tbar	: ['->',{
					itemId	: 'saveBtn',
					text	: '<t:message code="system.label.product.inquiry" default="조회"/>',
					handler	: function() {
						if(!WorkShopCopyWindowForm.getInvalidMessage()){
							return false
						}
						WorkShopCopyWindowStore.loadStoreRecords();
					},
					disabled: false
				},{
					itemId	: 'confirmBtn',
					text	: '<t:message code="system.label.product.apply" default="적용"/>',
					handler	: function() {
						var selMRecords	= Ext.getCmp('tab_pbs070ukrvs6Tab').down('#pbs070ukrvs_6Grid').getSelectedRecords();
						var selRecords	= WorkShopCopyWindowGrid.getSelectedRecords();
						var selItemCodes;
						if(Ext.isEmpty(selRecords)) {
							Unilite.messageBox('<t:message code="system.message.sales.message061" default="선택된 데이터가 없습니다."/>');
							return false;
						}
						Ext.each(selMRecords, function(selMRecord, index) {
							if(index == 0) {
								selItemCodes = selMRecord.get('ITEM_CODE');
							} else {
								selItemCodes = selItemCodes + ',' + selMRecord.get('ITEM_CODE');
							}
						});
						if(confirm('품목(' + selItemCodes + ')에 대한 작업장('+ WorkShopCopyWindowForm.getValue('WORK_SHOP_CODE') + ')의 공정수순을 체크된 작업장에 복사하시겠습니까?')) {
							WorkShopCopyWindow.getEl().mask('<t:message code="system.message.human.message010" default="저장중..."/>','loading-indicator');
							Ext.each(selRecords, function(selRecord, index) {
								selRecord.phantom = true;
								selRecord.set('ITEM_CODES', selItemCodes);
								buttonStore.insert(index, selRecord);
	
								if (selRecords.length == index +1) {
									buttonStore.saveStore();
								}
							})
						} else {
							Unilite.messageBox('<t:message code="system.message.sales.datacheck015" default="취소되었습니다."/>');
							return false;
						}
					},
					disabled: false
				},{
					itemId	: 'closeBtn',
					text	: '<t:message code="system.label.product.close" default="닫기"/>',
					handler	: function() {
						WorkShopCopyWindow.hide();
					},
					disabled: false
				}],
				listeners : {
					beforehide: function(me, eOpt) {
						WorkShopCopyWindowForm.clearForm();
						WorkShopCopyWindowGrid.reset();
					},
					beforeclose: function( panel, eOpts )  {
						WorkShopCopyWindowForm.clearForm();
						WorkShopCopyWindowGrid.reset();
					},
					show: function( panel, eOpts ) {
						var record = Ext.getCmp('tab_pbs070ukrvs6Tab').down('#pbs070ukrvs_6Grid').getSelectedRecord();
						WorkShopCopyWindowForm.setValue('DIV_CODE'			, Ext.getCmp('tab_pbs070ukrvs6Tab').getValue('DIV_CODE'));
						WorkShopCopyWindowForm.setValue('WORK_SHOP_CODE'	, Ext.getCmp('tab_pbs070ukrvs6Tab').getValue('WORK_SHOP_CODE'));
						WorkShopCopyWindowForm.setValue('ITEM_CODE'			, record.get('ITEM_CODE'));
					}
				}
			})
		}
		WorkShopCopyWindow.center();
		WorkShopCopyWindow.show();
	};

	//작업장 복사 시 저장로직 구현
	var copyWorkShopProgCodeProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			create	: 'pbs070ukrvsService.copyWorkShopProgCode',
			syncAll	: 'pbs070ukrvsService.copyAll'
		}
	});
	var buttonStore = Unilite.createStore('copyWorkShopProgCodeButtonStore',{
		uniOpt: {
			isMaster	: false,			// 상위 버튼 연결
			editable	: false,			// 수정 모드 사용
			deletable	: false,			// 삭제 가능 여부
			useNavi		: false				// prev | next 버튼 사용
		},
		proxy		: copyWorkShopProgCodeProxy,
		saveStore	: function() {
			var inValidRecs	= this.getInvalidRecords();
			var toCreate	= this.getNewRecords();

			var paramMaster = WorkShopCopyWindowForm.getValues();
			if(inValidRecs.length == 0) {
				config = {
					params	: [paramMaster],
					success	: function(batch, option) {
						WorkShopCopyWindow.getEl().unmask();
						buttonStore.clearData();
					},
					failure: function(batch, option) {
						WorkShopCopyWindow.getEl().unmask();
						buttonStore.clearData();
					}
				};
				this.syncAllDirect(config);
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
