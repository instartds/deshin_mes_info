<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="biv302skrv"  >

	<t:ExtComboStore comboType="BOR120"  pgmId="biv302skrv"/> 				<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B020" /> 					<!-- 품목계정 -->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList"/>	        <!--창고-->
	<t:ExtComboStore comboType="O"/>						                <!--창고(전체) -->
	<t:ExtComboStore items="${COMBO_WH_CELL_LIST}" storeId="whCellList" />  <!--창고Cell-->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />
</t:appConfig>
<script type="text/javascript" >

var BsaCodeInfo = {	//컨트롤러에서 값을 받아옴.
	gsAvgPHiddenYN: 		'${gsAvgPHiddenYN}',
	gsWHGroupYN:			'${gsWHGroupYN}'
};

function appMain() {
	var AvgPHiddenYN = false;	// 현재고 단가필드 숨김여부 (Y:숨김, N:보여줌)
	if(BsaCodeInfo.gsAvgPHiddenYN =='Y') {
		AvgPHiddenYN = true;
	}

	/** Model 정의
	 * @type
	 */
	Unilite.defineModel('Biv302skrvModel', {
		fields: [
			{name: 'ITEM_ACCOUNT',		text: '<t:message code="system.label.inventory.itemaccount" default="품목계정"/>',				type: 'string'},
			{name: 'ACCOUNT1',			text: '<t:message code="system.label.inventory.itemaccountcode" default="품목계정코드"/>',		type: 'string'},
			{name: 'DIV_CODE',			text: '<t:message code="system.label.inventory.division" default="사업장"/>',					type: 'string'},
			{name: 'ITEM_LEVEL1',		text: '<t:message code="system.label.inventory.majorgroup" default="대분류"/>',				type: 'string', store: Ext.data.StoreManager.lookup('itemLeve1Store')},
			{name: 'ITEM_LEVEL2',		text: '<t:message code="system.label.inventory.middlegroup" default="중분류"/>',				type: 'string', store: Ext.data.StoreManager.lookup('itemLeve2Store')},
			{name: 'ITEM_LEVEL3',		text: '<t:message code="system.label.inventory.minorgroup" default="소분류"/>',				type: 'string', store: Ext.data.StoreManager.lookup('itemLeve3Store')},
			{name: 'ITEM_CODE',			text: '<t:message code="system.label.inventory.item" default="품목"/>',						type: 'string'},
			{name: 'ITEM_NAME',			text: '<t:message code="system.label.inventory.itemname" default="품목명"/>',					type: 'string'},
			{name: 'SPEC',				text: '<t:message code="system.label.inventory.spec" default="규격"/>',						type: 'string'},
			{name: 'STOCK_UNIT',		text: '<t:message code="system.label.inventory.inventoryunit" default="재고단위"/>',			type: 'string'},
			{name: 'STOCK_Q',			text: '<t:message code="system.label.inventory.totalinventoryqty" default="총재고량"/>',		type: 'uniQty'},
			{name: 'GOOD_STOCK_Q',		text: '<t:message code="system.label.inventory.goodstockqty" default="양품재고량"/>',			type: 'uniQty'},
			{name: 'BAD_STOCK_Q',		text: '<t:message code="system.label.inventory.defectinventoryqty" default="불량재고량"/>',		type: 'uniQty'},
			{name: 'LOCATION',			text: 'LOCATION',		type: 'string'},
			{name: 'CUSTOM_CODE',		text: '<t:message code="system.label.inventory.maincustomcode" default="주거래처코드"/>',			type: 'string'},
			{name: 'CUSTOM_NAME',		text: '<t:message code="system.label.inventory.maincustom" default="주거래처"/>',				type: 'string'},
			{name: 'RECEIPT_DATE',		text: '최종접수일',				type: 'uniDate'}
		]
	});

	Unilite.defineModel('Biv302skrvModel2', {
		fields: [
			{name: 'ITEM_ACCOUNT'		,text: '<t:message code="system.label.inventory.warehousename" default="창고명"/>',					type: 'string'},
			{name: 'ACCOUNT1'			,text: '<t:message code="system.label.inventory.warehouse" default="창고"/>',					type: 'string'},
			{name: 'DIV_CODE'			,text: '<t:message code="system.label.inventory.division" default="사업장"/>',					type: 'string'},
			{name: 'ITEM_LEVEL1'		,text: '<t:message code="system.label.inventory.majorgroup" default="대분류"/>',				type: 'string', store: Ext.data.StoreManager.lookup('itemLeve1Store')},
			{name: 'ITEM_LEVEL2'		,text: '<t:message code="system.label.inventory.middlegroup" default="중분류"/>',				type: 'string', store: Ext.data.StoreManager.lookup('itemLeve2Store')},
			{name: 'ITEM_LEVEL3'		,text: '<t:message code="system.label.inventory.minorgroup" default="소분류"/>',				type: 'string', store: Ext.data.StoreManager.lookup('itemLeve3Store')},
			{name: 'ITEM_CODE'			,text: '<t:message code="system.label.inventory.item" default="품목"/>',						type: 'string'},
			{name: 'ITEM_NAME'			,text: '<t:message code="system.label.inventory.itemname" default="품목명"/>',						type: 'string'},
			{name: 'SPEC'				,text: '<t:message code="system.label.inventory.spec" default="규격"/>',						type: 'string'},
			{name: 'STOCK_UNIT'			,text: '<t:message code="system.label.inventory.inventoryunit" default="재고단위"/>',			type: 'string'},
			{name: 'STOCK_Q'			,text: '<t:message code="system.label.inventory.totalinventoryqty" default="총재고량"/>',		type: 'uniQty'},
			{name: 'GOOD_STOCK_Q'		,text: '<t:message code="system.label.inventory.goodstockqty" default="양품재고량"/>',			type: 'uniQty'},
			{name: 'BAD_STOCK_Q'		,text: '<t:message code="system.label.inventory.defectinventoryqty" default="불량재고량"/>',		type: 'uniQty'},
			{name: 'LOCATION'			,text: 'LOCATION',		type: 'string'},
			{name: 'CUSTOM_CODE'		,text: '<t:message code="system.label.inventory.maincustomcode" default="주거래처코드"/>',		type: 'string'},
			{name: 'CUSTOM_NAME'		,text: '<t:message code="system.label.inventory.maincustom" default="주거래처"/>',				type: 'string'}
		]
	});

	Unilite.defineModel('Biv302skrvModel3', {
		fields:  [
			{name: 'LOT_NO'			, text: '<t:message code="system.label.inventory.lotno" default="LOT번호"/>',					type: 'string'},
			{name: 'WH_CODE'		, text: '<t:message code="system.label.inventory.warehouse" default="창고"/>',				type: 'string'},
			{name: 'WH_NAME'		, text: '<t:message code="system.label.inventory.warehousename" default="창고명"/>',			type: 'string'},
			{name: 'ITEM_CODE'		, text: '<t:message code="system.label.inventory.item" default="품목"/>',						type: 'string'},
			{name: 'ITEM_NAME'		, text: '<t:message code="system.label.inventory.itemname" default="품목명"/>',				type: 'string'},
			{name: 'SPEC'			, text: '<t:message code="system.label.inventory.spec" default="규격"/>',						type: 'string'},
			{name: 'STOCK_UNIT'		, text: '<t:message code="system.label.inventory.inventoryunit" default="재고단위"/>',			type: 'string'},
			{name: 'STOCK'			, text: '<t:message code="system.label.inventory.totalinventoryqty" default="총재고량"/>',		type: 'uniQty'},
			{name: 'GOOD_STOCK'		, text: '<t:message code="system.label.inventory.goodstockqty" default="양품재고량"/>',			type: 'uniQty'},
			{name: 'BAD_STOCK'		, text: '<t:message code="system.label.inventory.defectinventoryqty" default="불량재고량"/>',	type: 'uniQty'},
			{name: 'DIV_CODE'		, text: '<t:message code="system.label.inventory.division" default="사업장"/>',				type: 'string'},
			{name: 'WH_CODE'		, text: '<t:message code="system.label.inventory.warehouse" default="창고"/>',				type: 'string'},
			
			{name: 'LOCATION'		, text: 'Location',				type: 'string'},
			//20190529 제조일자, 사용기한 추가
			{name: 'MAKE_DATE'		, text: '<t:message code="system.label.inventory.mfgdate" default="제조일"/>',					type: 'uniDate'},
			{name: 'MAKE_EXP_DATE'	, text: '<t:message code="system.label.inventory.expirationdateII" default="사용기한"/>',		type: 'uniDate'},
			//20190603 거래처, 구매단가
			{name: 'CUSTOM_NAME'	, text: '<t:message code="system.label.inventory.customname" default="거래처명"/>',				type: 'string'}
		]
	});

	Unilite.defineModel('Biv302skrvModel4', {
		fields:  [
			{name: 'DIV_CODE'		, text: '<t:message code="system.label.inventory.division" default="사업장"/>',					type: 'string'},
			{name: 'CUSTOM_CODE'	, text: '<t:message code="system.label.inventory.custom" default="거래처"/>',						type: 'string'},
			{name: 'CUSTOM_NAME'	, text: '<t:message code="system.label.inventory.customname" default="거래처명"/>',					type: 'string'},
			{name: 'ITEM_CODE'		, text: '<t:message code="system.label.inventory.item" default="품목"/>',							type: 'string'},
			{name: 'ITEM_NAME'		, text: '<t:message code="system.label.inventory.itemname" default="품목명"/>',					type: 'string'},
			{name: 'SPEC'			, text: '<t:message code="system.label.inventory.spec" default="규격"/>',							type: 'string'},
			{name: 'STOCK_UNIT'		, text: '<t:message code="system.label.inventory.inventoryunit" default="재고단위"/>',				type: 'string'},
			{name: 'STOCK_Q'		, text: '<t:message code="system.label.inventory.totalinventoryqty" default="총재고량"/>',			type: 'uniQty'},
			{name: 'GOOD_STOCK_Q'	, text: '<t:message code="system.label.inventory.goodstockqty" default="양품재고량"/>',				type: 'uniQty'},
			{name: 'BAD_STOCK_Q'	, text: '<t:message code="system.label.inventory.defectinventoryqty" default="불량재고량"/>',		type: 'uniQty'}
		]
	});

	Unilite.defineModel('Biv302skrvModel5', {
		fields:  [
			{name: 'DIV_CODE'		,text: '<t:message code="system.label.inventory.division" default="사업장"/>',				type: 'string'},
			{name: 'WH_CODE'		,text: '<t:message code="system.label.inventory.warehouse" default="창고"/>',				type: 'string'},
			{name: 'WH_NAME'		,text: '<t:message code="system.label.inventory.warehousename" default="창고명"/>',		type: 'string'},
			{name: 'WH_CELL_CODE'	,text: '<t:message code="system.label.inventory.warehousecell" default="창고Cell"/>',		type: 'string'},
			{name: 'WH_CELL_NAME'	,text: '<t:message code="system.label.inventory.warehousecell" default="창고Cell"/>',		type: 'string'},
			{name: 'LOT_NO'			,text: '<t:message code="system.label.inventory.lotno" default="LOT번호"/>',				type: 'string'},
			{name: 'ITEM_CODE'		,text: '<t:message code="system.label.inventory.item" default="품목"/>',					type: 'string'},
			{name: 'ITEM_NAME'		,text: '<t:message code="system.label.inventory.itemname" default="품목명"/>',				type: 'string'},
			{name: 'SPEC'			,text: '<t:message code="system.label.inventory.spec" default="규격"/>',					type: 'string'},
			{name: 'STOCK_UNIT'		,text: '<t:message code="system.label.inventory.inventoryunit" default="재고단위"/>',		type: 'string'},
			{name: 'STOCK'			,text: '<t:message code="system.label.inventory.totalinventoryqty" default="총재고량"/>',	type: 'uniQty'},
			{name: 'GOOD_STOCK'		,text: '<t:message code="system.label.inventory.goodstockqty" default="양품재고량"/>',		type: 'uniQty'},
			{name: 'BAD_STOCK'		,text: '<t:message code="system.label.inventory.defectinventoryqty" default="불량재고량"/>',	type: 'uniQty'}
		]
	});



	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('biv302skrvMasterStore1',{
		model: 'Biv302skrvModel',
		uniOpt : {
			isMaster	: true,		// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {read: 'biv302skrvService.selectMaster'}
		},
		loadStoreRecords : function() {
			var param= Ext.getCmp('searchForm').getValues();
			param.SUBCON_FLAG = Ext.getCmp('rdoSelect').getChecked()[0].inputValue;
			param.QUERY_TYPE = '1'
			console.log( param );
			this.load({
				params : param
			});
		}
	});

	var directMasterStore2 = Unilite.createStore('biv302skrvMasterStore2',{
		model: 'Biv302skrvModel2',
		uniOpt : {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {read: 'biv302skrvService.selectMaster2'}
		},
		loadStoreRecords : function() {
			var param= Ext.getCmp('searchForm').getValues();
			param.QUERY_TYPE = '2'
			console.log( param );
			this.load({
				params : param
			});
		}
	});

	var directMasterStore3 = Unilite.createStore('biv302skrvMasterStore3',{
		model: 'Biv302skrvModel3',
		uniOpt : {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {read: 'biv302skrvService.selectMaster3'}
		},
		loadStoreRecords : function() {
			var param= Ext.getCmp('searchForm').getValues();
			param.FR_LOT = lotSubForm.getValue('FR_LOT');
			param.TO_LOT = lotSubForm.getValue('TO_LOT');
			console.log( param );
			this.load({
				params : param
			});
		}
	});

	var directMasterStore4 = Unilite.createStore('biv302skrvMasterStore4',{
		model: 'Biv302skrvModel4',
		uniOpt : {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {read: 'biv302skrvService.selectMaster4'}
		},
		loadStoreRecords : function() {
			var param= Ext.getCmp('searchForm').getValues();
			param.CUSTOM_CODE = customSubForm.getValue('CUSTOM_CODE');
			param.CUSTOM_NAME = customSubForm.getValue('CUSTOM_NAME');
			console.log( param );
			this.load({
				params : param
			});
		}
	});

	var directMasterStore5 = Unilite.createStore('biv302skrvMasterStore5',{
		model: 'Biv302skrvModel5',
		uniOpt : {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {read: 'biv302skrvService.selectMaster5'}
		},
		loadStoreRecords : function() {
			var param= Ext.getCmp('searchForm').getValues();
			param.WH_CODE = cellSubForm.getValue('WH_CODE');
			param.WH_CELL_CODE = cellSubForm.getValue('WH_CELL_CODE');
			param.LOT_NO = cellSubForm.getValue('LOT_NO');
			console.log( param );
			this.load({
				params : param
			});
		}
	});



	/** 검색조건 (Search Panel)
	 * @type
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm',{
		title: '<t:message code="system.label.inventory.searchconditon" default="검색조건"/>',
		defaultType: 'uniSearchSubPanel',
		collapsed: true,
		listeners: {
			collapse: function () {
				panelResult.show();
			},
			expand: function() {
				panelResult.hide();
			}
		},
		items: [{
			title: '<t:message code="system.label.inventory.basisinfo" default="기본정보"/>',
			itemId: 'search_panel1',
			layout: {type: 'uniTable', columns: 1},
			defaultType: 'uniTextfield',
			items: [{
				fieldLabel: '<t:message code="system.label.inventory.division" default="사업장"/>',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				child:'WH_CODE',
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.inventory.warehouse" default="창고"/>',
				name: 'WH_CODE',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('whList'),
				multiSelect:true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('WH_CODE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.inventory.itemaccount" default="품목계정"/>',
				name:'ITEM_ACCOUNT',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'B020',
				multiSelect:true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ITEM_ACCOUNT', newValue);
					}
				}
			},
			Unilite.popup('DIV_PUMOK',{
				fieldLabel: '<t:message code="system.label.inventory.item" default="품목"/>',
				valueFieldName: 'ITEM_CODE',
				textFieldName: 'ITEM_NAME',
				validateBlank: false,
				listeners: {
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('ITEM_CODE', newValue);
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('ITEM_NAME', newValue);
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}
			})]
		},{
			title: '<t:message code="system.label.inventory.additionalinfo" default="추가정보"/>',
			defaultType: 'uniTextfield',
			items: [{
				fieldLabel: '<t:message code="system.label.inventory.majorgroup" default="대분류"/>',
				name: 'TXTLV_L1',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('itemLeve1Store'),
				child: 'TXTLV_L2',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('TXTLV_L1', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.inventory.middlegroup" default="중분류"/>',
				name: 'TXTLV_L2',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('itemLeve2Store'),
				child: 'TXTLV_L3',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('TXTLV_L2', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.inventory.minorgroup" default="소분류"/>',
				name: 'TXTLV_L3',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('itemLeve3Store'),
				parentNames:['TXTLV_L1','TXTLV_L2'],
				levelType:'ITEM',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('TXTLV_L3', newValue);
					}
				}
			},{
				xtype: 'uniCheckboxgroup',
				fieldLabel: '',
				padding: '0 0 0 0',
				margin: '0 0 0 90',
				items: [{
					boxLabel: '<t:message code="system.label.inventory.stockzeroinclusion" default="재고수량 0포함"/>',
					width: 200,
					name: 'ZERO_STOCK_YN',
					inputValue: 'Y',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
						}
					}
				}]
			}]
		}]
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel: '<t:message code="system.label.inventory.division" default="사업장"/>',
			name: 'DIV_CODE',
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			child:'WH_CODE',
			allowBlank: false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.inventory.warehouse" default="창고"/>',
			name: 'WH_CODE',
			xtype: 'uniCombobox',
			store: Ext.data.StoreManager.lookup('whList'),
			multiSelect:true,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('WH_CODE', newValue);
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.inventory.itemaccount" default="품목계정"/>',
			name:'ITEM_ACCOUNT',
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'B020',
			colspan: 2,
			multiSelect:true,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('ITEM_ACCOUNT', newValue);
				}
			}
		},
		Unilite.popup('DIV_PUMOK',{
			fieldLabel: '<t:message code="system.label.inventory.item" default="품목"/>',
			valueFieldName: 'ITEM_CODE',
			textFieldName: 'ITEM_NAME',
			validateBlank: false,
			listeners: {
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('ITEM_CODE', newValue);
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('ITEM_NAME', newValue);
				},
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
				}
			}
		}),{
			fieldLabel: '<t:message code="system.label.inventory.majorgroup" default="대분류"/>',
			name: 'TXTLV_L1',
			xtype: 'uniCombobox',
			store: Ext.data.StoreManager.lookup('itemLeve1Store'),
			child: 'TXTLV_L2',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('TXTLV_L1', newValue);
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.inventory.middlegroup" default="중분류"/>',
			name: 'TXTLV_L2',
			xtype: 'uniCombobox',
			store: Ext.data.StoreManager.lookup('itemLeve2Store'),
			child: 'TXTLV_L3',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('TXTLV_L2', newValue);
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.inventory.minorgroup" default="소분류"/>',
			name: 'TXTLV_L3',
			xtype: 'uniCombobox',
			store: Ext.data.StoreManager.lookup('itemLeve3Store'),
			parentNames:['TXTLV_L1','TXTLV_L2'],
			levelType:'ITEM',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('TXTLV_L3', newValue);
				}
			}
		}]
	});

	var itemSubForm = Unilite.createSearchForm('itemSubForm',{
		padding: '0 0 0 0',
		layout:{type:'uniTable', columns: '1'},
		items: [{
			xtype: 'radiogroup',
			fieldLabel: '<t:message code="system.label.inventory.outsourcingstockinclusion" default="외주재고포함여부"/>',
			labelWidth: 100,
			id: 'rdoSelect',
			items: [{
				boxLabel: '<t:message code="system.label.inventory.notinclusion" default="포함안함"/>',
				width: 70,
				inputValue: '1',
				name: 'SUBCON_FLAG',
				checked: true
			},{
				boxLabel : '<t:message code="system.label.inventory.inclusion" default="포함"/>',
				width: 70,
				inputValue: '2',
				name: 'SUBCON_FLAG'
			}]
		}]
	});

	var lotSubForm = Unilite.createSearchForm('lotSubForm',{
		padding: '0 0 0 0',
		layout:{type:'uniTable', columns: '1'},
		items: [{
			xtype: 'container',
			items:[{
				xtype: 'container',
				defaultType: 'uniTextfield',
				layout: {type: 'uniTable', columns: 2},
				width: 250,
				items: [{
					fieldLabel: '<t:message code="system.label.inventory.lotno" default="LOT번호"/>',
					//suffixTpl: '&nbsp;~&nbsp;',
					width: 200,
					name: 'FR_LOT'
				}, {
					name: 'TO_LOT',
					width: 135,
					fieldLabel: '~',
					labelWidth: 15
				}]
			}]
		}]
	});

	var customSubForm = Unilite.createSearchForm('customSubForm',{
		padding: '0 0 0 0',
		layout:{type:'uniTable', columns: '1'},
		items: [
			Unilite.popup('AGENT_CUST', {
				fieldLabel: '<t:message code="system.label.inventory.subcontractor" default="외주처"/>',
				valueFieldName : 'CUSTOM_CODE',
				textFieldName  : 'CUSTOM_NAME'
			})
		]
	});

	var cellSubForm = Unilite.createSearchForm('cellSubForm',{
		padding: '0 0 0 0',
		layout:{type:'uniTable', columns: 3},
		items: [{
            fieldLabel: '<t:message code="system.label.inventory.warehouse" default="창고"/>',
            name: 'WH_CODE',
            xtype:'uniCombobox',
            comboType  : 'O',
            child: 'WH_CELL_CODE',
            listeners: {
                beforequery:function( queryPlan, eOpts )   {
                    var store = queryPlan.combo.store;
                        store.clearFilter();
                    if(!Ext.isEmpty(panelResult.getValue('DIV_CODE'))){
                        store.filterBy(function(record){
                        return record.get('option') == panelResult.getValue('DIV_CODE');
                    })
                    }else{
                        store.filterBy(function(record){
                        return false;
                    })
                }
              }
            }
        },{
            fieldLabel: 'CELL',
            name: 'WH_CELL_CODE',
            xtype:'uniCombobox',
            store: Ext.data.StoreManager.lookup('whCellList'),
            multiSelect:true
        },{
        	fieldLabel: 'LOT NO',
        	xtype:'uniTextfield',
        	name:'LOT_NO'
        }
		]
	});


	/** Master Grid1 정의(Grid Panel)
	 * @type
	 */
	var masterGrid = Unilite.createGrid('biv302skrvGrid_1', {
//		title: '품목별',
		store : directMasterStore1,
		region: 'center' ,
		layout : 'fit',
		excelTitle: '<t:message code="system.label.inventory.onhandqtybyitem" default="현재고현황(품목별)"/>',
		uniOpt:{
			expandLastColumn: true,
			useRowNumberer: false,
			useMultipleSorting: true,
			//20191205 필터기능 추가
			filter: {
				useFilter: true,
				autoCreate: true
			}
		},
        tbar:[{xtype:'uniNumberfield', labelWidth: 110, fieldLabel:'<t:message code="system.label.sales.selectionsummary" default="선택된 데이터 합계"/>', id:'selectionSummary', value:0, decimalPrecision:4, format:'0,000.0000',readOnly:true}],
		features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true },
					{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: true} ],
		columns:  [
			{dataIndex: 'ITEM_ACCOUNT'	, width: 120,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.inventory.subtotal" default="소계"/>', '<t:message code="system.label.inventory.total" default="총계"/>');
				}
			},
			{dataIndex: 'ACCOUNT1'		, width: 66, hidden:true},
			{dataIndex: 'DIV_CODE'		, width: 66, hidden:true},
			{dataIndex: 'ITEM_CODE'		, width: 120},
			{dataIndex: 'ITEM_NAME'		, width: 200},
			{dataIndex: 'SPEC'			, width: 180},
			{dataIndex: 'STOCK_UNIT'	, width: 80,align:'center'},
			{dataIndex: 'STOCK_Q'		, width: 100, summaryType: 'sum'},
			{dataIndex: 'GOOD_STOCK_Q'	, width: 100, summaryType: 'sum'},
			{dataIndex: 'BAD_STOCK_Q'	, width: 100, summaryType: 'sum'},
			{dataIndex: 'LOCATION'		, width: 86, hidden:true},
			{dataIndex: 'CUSTOM_CODE'	, width: 86, hidden:true},
			{dataIndex: 'CUSTOM_NAME'	, width: 86, hidden:true},
			{dataIndex: 'RECEIPT_DATE'	, width: 86, align:'center', hidden:true}
		] ,
        listeners:{
        	selectionchange:function( grid, selection, eOpts )	{
          		if(selection && selection.startCell)	{
          			var columnName = selection.startCell.column.dataIndex;
					var displayField= Ext.getCmp("selectionSummary");
          			if(selection.startCell.column.xtype == 'uniNnumberColumn' && selection.startCell.column.dataIndex == selection.endCell.column.dataIndex)	{

						var startIdx = selection.startCell.rowIdx, endIdx = selection.endCell.rowIdx;
						var store = grid.store;
	          			var sum = 0;

	          			for(var i=startIdx; i <= endIdx; i++){
	          				var record = store.getAt(i);
	          				sum += record.get(columnName);
	          			}
	          			displayField.setValue(sum);
	          		} else {
	          			displayField.setValue(0);
	          		}
          		}
          	}
		}
	});

	var masterGrid2 = Unilite.createGrid('biv302skrvGrid_2', {
		store : directMasterStore2,
		region: 'center' ,
		layout : 'fit',
		excelTitle: '<t:message code="system.label.inventory.onhandqtybywarehouse" default="현재고현황(창고별)"/>',
		uniOpt:{
			expandLastColumn: true,
			useRowNumberer: false,
			useMultipleSorting: true,
			//20191205 필터기능 추가
			filter: {
				useFilter: true,
				autoCreate: true
			}
		},
		tbar:[{xtype:'uniNumberfield', labelWidth: 110, fieldLabel:'<t:message code="system.label.sales.selectionsummary" default="선택된 데이터 합계"/>', id:'selectionSummary2', value:0, decimalPrecision:4, format:'0,000.0000',readOnly:true}],
		features: [ {id : 'masterGridSubTotal2', ftype: 'uniGroupingsummary', showSummaryRow: true },
					{id : 'masterGridTotal2', 	ftype: 'uniSummary', 	  showSummaryRow: true} ],
		columns:  [
			{dataIndex: 'ACCOUNT1'		,		width: 85,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.inventory.total" default="총계"/>', '<t:message code="system.label.inventory.total" default="총계"/>');
				}
			},
			{dataIndex: 'ITEM_ACCOUNT'	, width: 100},
			{dataIndex: 'DIV_CODE'		, width: 80, hidden:true},
			{dataIndex: 'ITEM_CODE'		, width: 120},
			{dataIndex: 'ITEM_NAME'		, width: 200},
			{dataIndex: 'SPEC'			, width: 180},
			{dataIndex: 'STOCK_UNIT'	, width: 80,align:'center'},
			{dataIndex: 'STOCK_Q'		, width: 100, summaryType: 'sum'},
			{dataIndex: 'GOOD_STOCK_Q'	, width: 100, summaryType: 'sum'},
			{dataIndex: 'BAD_STOCK_Q'	, width: 100, summaryType: 'sum'},
			{dataIndex: 'LOCATION'		, width: 100},
			{dataIndex: 'CUSTOM_CODE'	, width: 86, hidden:true},
			{dataIndex: 'CUSTOM_NAME'	, width: 86, hidden:true}
		] ,
        listeners:{
        	selectionchange:function( grid, selection, eOpts )	{
          		if(selection && selection.startCell)	{
          			var columnName = selection.startCell.column.dataIndex;
					var displayField= Ext.getCmp("selectionSummary2");
          			if(selection.startCell.column.xtype == 'uniNnumberColumn' && selection.startCell.column.dataIndex == selection.endCell.column.dataIndex)	{

						var startIdx = selection.startCell.rowIdx, endIdx = selection.endCell.rowIdx;
						var store = grid.store;
	          			var sum = 0;

	          			for(var i=startIdx; i <= endIdx; i++){
	          				var record = store.getAt(i);
	          				sum += record.get(columnName);
	          			}
	          			displayField.setValue(sum);
	          		} else {
	          			displayField.setValue(0);
	          		}
          		}
          	}
		}
	});

	var masterGrid3 = Unilite.createGrid('biv302skrvGrid_3', {
		store : directMasterStore3,
		region: 'center' ,
		layout : 'fit',
		excelTitle: '<t:message code="system.label.inventory.onhandqtybylot" default="현재고현황(LOT별)"/>',
		uniOpt:{
			expandLastColumn: true,
			useRowNumberer: false,
			useMultipleSorting: true,
			//20191205 필터기능 추가
			filter: {
				useFilter: true,
				autoCreate: true
			}
		},
		tbar:[{xtype:'uniNumberfield', labelWidth: 110, fieldLabel:'<t:message code="system.label.sales.selectionsummary" default="선택된 데이터 합계"/>', id:'selectionSummary3', value:0, decimalPrecision:4, format:'0,000.0000',readOnly:true}],
		features: [ {id : 'masterGridSubTotal3', ftype: 'uniGroupingsummary', showSummaryRow: true },
					{id : 'masterGridTotal3',	ftype: 'uniSummary',	  showSummaryRow: true} ],
		columns:  [
			{dataIndex: 'LOT_NO'			,		width: 115,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.inventory.subtotal" default="소계"/>', '<t:message code="system.label.inventory.total" default="총계"/>');
				}
			},
			{dataIndex: 'WH_CODE'			, width: 85},
			{dataIndex: 'WH_NAME'			, width: 100},
			{dataIndex: 'ITEM_CODE'			, width: 120},
			{dataIndex: 'ITEM_NAME'			, width: 200},
			{dataIndex: 'SPEC'				, width: 140},
			{dataIndex: 'STOCK_UNIT'		, width: 80 , align:'center'},
			{dataIndex: 'STOCK'				, width: 100, summaryType: 'sum'},
			{dataIndex: 'GOOD_STOCK'		, width: 100, summaryType: 'sum'},
			{dataIndex: 'BAD_STOCK'			, width: 100, summaryType: 'sum'},
			{dataIndex: 'DIV_CODE'			, width: 66 , hidden: true},
			{dataIndex: 'WH_CODE'			, width: 100, hidden: true},
			//20190603 거래처, 구매단가
			{dataIndex: 'CUSTOM_NAME'		, width: 200},
			
			{dataIndex: 'LOCATION'	, width: 150, hidden:true},
			//20190529 제조일자, 사용기한 추가
			{dataIndex: 'MAKE_DATE'			, width: 90},
			{dataIndex: 'MAKE_EXP_DATE'		, width: 90}
		] ,
        listeners:{
        	selectionchange:function( grid, selection, eOpts )	{
          		if(selection && selection.startCell)	{
          			var columnName = selection.startCell.column.dataIndex;
					var displayField= Ext.getCmp("selectionSummary3");
          			if(selection.startCell.column.xtype == 'uniNnumberColumn' && selection.startCell.column.dataIndex == selection.endCell.column.dataIndex)	{

						var startIdx = selection.startCell.rowIdx, endIdx = selection.endCell.rowIdx;
						var store = grid.store;
	          			var sum = 0;

	          			for(var i=startIdx; i <= endIdx; i++){
	          				var record = store.getAt(i);
	          				sum += record.get(columnName);
	          			}
	          			displayField.setValue(sum);
	          		} else {
	          			displayField.setValue(0);
	          		}
          		}
          	}
		}
	});

	var masterGrid4 = Unilite.createGrid('biv302skrvGrid_4', {
//		title: '외주처별',
		store : directMasterStore4,
		region: 'center' ,
		layout : 'fit',
		excelTitle: '<t:message code="system.label.inventory.onhandqtybysubcontract" default="현재고현황(외주처별)"/>',
		uniOpt:{
			expandLastColumn: true,
			useRowNumberer: false,
			useMultipleSorting: true,
			//20191205 필터기능 추가
			filter: {
				useFilter: true,
				autoCreate: true
			}
		},
		tbar:[{xtype:'uniNumberfield', labelWidth: 110, fieldLabel:'<t:message code="system.label.sales.selectionsummary" default="선택된 데이터 합계"/>', id:'selectionSummary4', value:0, decimalPrecision:4, format:'0,000.0000',readOnly:true}],
		features: [ {id : 'masterGridSubTotal4', ftype: 'uniGroupingsummary', showSummaryRow: true },
					{id : 'masterGridTotal4',	ftype: 'uniSummary',	  showSummaryRow: true} ],
		columns:  [
			{dataIndex: 'DIV_CODE'		, width: 100, hidden: true},
			{dataIndex: 'CUSTOM_CODE'	, width: 100, hidden: true},
			{dataIndex: 'CUSTOM_NAME'	, width: 200,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.inventory.subtotal" default="소계"/>', '<t:message code="system.label.inventory.total" default="총계"/>');
				}
			},
			{dataIndex: 'ITEM_CODE'		, width: 100},
			{dataIndex: 'ITEM_NAME'		, width: 200},
			{dataIndex: 'SPEC'			, width: 100},
			{dataIndex: 'STOCK_UNIT'	, width: 100,align:'center'},
			{dataIndex: 'STOCK_Q'		, width: 100, summaryType: 'sum'},
			{dataIndex: 'GOOD_STOCK_Q'	, width: 100, summaryType: 'sum'},
			{dataIndex: 'BAD_STOCK_Q'	, width: 100, summaryType: 'sum'}
		] ,
        listeners:{
        	selectionchange:function( grid, selection, eOpts )	{
          		if(selection && selection.startCell)	{
          			var columnName = selection.startCell.column.dataIndex;
					var displayField= Ext.getCmp("selectionSummary4");
          			if(selection.startCell.column.xtype == 'uniNnumberColumn' && selection.startCell.column.dataIndex == selection.endCell.column.dataIndex)	{

						var startIdx = selection.startCell.rowIdx, endIdx = selection.endCell.rowIdx;
						var store = grid.store;
	          			var sum = 0;

	          			for(var i=startIdx; i <= endIdx; i++){
	          				var record = store.getAt(i);
	          				sum += record.get(columnName);
	          			}
	          			displayField.setValue(sum);
	          		} else {
	          			displayField.setValue(0);
	          		}
          		}
          	}
		}
	});

	var masterGrid5 = Unilite.createGrid('biv302skrvGrid_5', {
		region: 'center' ,
		layout : 'fit',
		excelTitle: '<t:message code="system.label.inventory.onhandqtybycell" default="현재고현황(CELL별)"/>',
		store : directMasterStore5,
		uniOpt:{
			expandLastColumn: true,
			useRowNumberer: false,
			useMultipleSorting: true,
			//20191205 필터기능 추가
			filter: {
				useFilter: true,
				autoCreate: true
			}
		},
		tbar:[{xtype:'uniNumberfield', labelWidth: 110, fieldLabel:'<t:message code="system.label.sales.selectionsummary" default="선택된 데이터 합계"/>', id:'selectionSummary5', value:0, decimalPrecision:4, format:'0,000.0000',readOnly:true}],
		features: [ {id : 'masterGridSubTotal5', ftype: 'uniGroupingsummary', showSummaryRow: true },
					{id : 'masterGridTotal5',	ftype: 'uniSummary',	  showSummaryRow: true} ],
		columns:  [
			{dataIndex: 'DIV_CODE'		, width: 85, hidden: true},
			{dataIndex: 'WH_CODE'		, width: 85, hidden: true},
			{dataIndex: 'WH_NAME'		, width: 100,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.inventory.subtotal" default="소계"/>', '<t:message code="system.label.base.total" default="총계"/>');
				}
			},
			{dataIndex: 'WH_CELL_CODE'	, width: 85, hidden: true},
			{dataIndex: 'WH_CELL_NAME'	, width: 100},
			{dataIndex: 'LOT_NO'		, width: 100},
			{dataIndex: 'ITEM_CODE'		, width: 100},
			{dataIndex: 'ITEM_NAME'		, width: 200},
			{dataIndex: 'SPEC'			, width: 100},
			{dataIndex: 'STOCK_UNIT'	, width: 100,align:'center'},
			{dataIndex: 'STOCK'			, width: 100, summaryType: 'sum'},
			{dataIndex: 'GOOD_STOCK'	, width: 100, summaryType: 'sum'},
			{dataIndex: 'BAD_STOCK'		, width: 100, summaryType: 'sum'}
		] ,
        listeners:{
        	selectionchange:function( grid, selection, eOpts )	{
          		if(selection && selection.startCell)	{
          			var columnName = selection.startCell.column.dataIndex;
					var displayField= Ext.getCmp("selectionSummary5");
          			if(selection.startCell.column.xtype == 'uniNnumberColumn' && selection.startCell.column.dataIndex == selection.endCell.column.dataIndex)	{

						var startIdx = selection.startCell.rowIdx, endIdx = selection.endCell.rowIdx;
						var store = grid.store;
	          			var sum = 0;

	          			for(var i=startIdx; i <= endIdx; i++){
	          				var record = store.getAt(i);
	          				sum += record.get(columnName);
	          			}
	          			displayField.setValue(sum);
	          		} else {
	          			displayField.setValue(0);
	          		}
          		}
          	}
		}
	});



	var tab = Unilite.createTabPanel('tabPanel',{
		activeTab:  0,
		region: 'center',
		items:  [{
				title: '<t:message code="system.label.inventory.itemby" default="품목별"/>',
				xtype:'container',
				layout:{type:'vbox', align:'stretch'},
				items:[itemSubForm, masterGrid],
				id: 'biv302skrvGrid1'
			},{
				title: '<t:message code="system.label.inventory.warehouseby" default="창고별"/>',
				xtype:'container',
				layout:{type:'vbox', align:'stretch'},
				items:[masterGrid2],
				id: 'biv302skrvGrid2'
			},{
				title: '<t:message code="system.label.inventory.byeachlot" default="LOT별"/>',
				xtype:'container',
				layout:{type:'vbox', align:'stretch'},
				items:[lotSubForm, masterGrid3],
				id: 'biv302skrvGrid3'
			},{
				title: '<t:message code="system.label.inventory.parenbyeachsubcontract" default="외주처별"/>',
				xtype:'container',
				layout:{type:'vbox', align:'stretch'},
				items:[customSubForm, masterGrid4],
				id: 'biv302skrvGrid4'
			},{
				title: '<t:message code="system.label.inventory.cellby" default="CELL별"/>',
				xtype:'container',
				layout:{type:'vbox', align:'stretch'},
				items:[cellSubForm,masterGrid5],
				id: 'biv302skrvGrid5'
			}
		]
	});



	Unilite.Main({
		id  : 'biv302skrvApp',
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				tab, panelResult
			]
		},
			panelSearch
		],
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('reset',true);
			biv302skrvService.userWhcode({}, function(provider, response) {
				if(!Ext.isEmpty(provider)){
					panelSearch.setValue('WH_CODE',provider['WH_CODE']);
					panelResult.setValue('WH_CODE',provider['WH_CODE']);
				}
			})
		},
		onQueryButtonDown : function() {
			var activeTabId = tab.getActiveTab().getId();
			if(activeTabId == 'biv302skrvGrid1'){
				directMasterStore1.loadStoreRecords();
			}
			else if(activeTabId == 'biv302skrvGrid2'){
				directMasterStore2.loadStoreRecords();
			}
			else if(activeTabId == 'biv302skrvGrid3'){
				directMasterStore3.loadStoreRecords();
			}
			else if(activeTabId == 'biv302skrvGrid4'){
				directMasterStore4.loadStoreRecords();
			}
			else if(activeTabId == 'biv302skrvGrid5'){
				directMasterStore5.loadStoreRecords();
			}
			UniAppManager.setToolbarButtons('reset', true);
		},
		onResetButtonDown: function() {		// 초기화
			this.suspendEvents();
			panelSearch.clearForm();
			panelResult.clearForm();

			masterGrid.getStore().loadData({});
			masterGrid2.getStore().loadData({});
			masterGrid3.getStore().loadData({});
			masterGrid4.getStore().loadData({});
			masterGrid5.getStore().loadData({});

			this.fnInitBinding();
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');
			if(as.isHidden()) {
				as.show();
			}else {
				as.hide()
			}
		}
	});
};
</script>
