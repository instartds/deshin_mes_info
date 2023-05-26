<%@page language="java" contentType="text/html; charset=utf-8"%>
	<t:appConfig pgmId="biv122ukrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="biv122ukrv"/> 		<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B020" />				<!-- 품목계정 -->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" />	<!--창고-->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

var BsaCodeInfo = {	// 컨트롤러에서 값을 받아옴
	gsSumTypeLot	: '${gsSumTypeLot}',
	gsSumTypeCell	: '${gsSumTypeCell}'
};

/*var output ='';
	for(var key in BsaCodeInfo){
 		output += key + '  :  ' + BsaCodeInfo[key] + '\n';
	}
	alert(output);*/

var outDivCode	= UserInfo.divCode;
var gsMoneyUnit	= UserInfo.currency;
var alertWindow;			//alertWindow : 경고창

function appMain() {
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'biv122ukrvService.selectMaster',
			update	: 'biv122ukrvService.updateDetail',
			create	: 'biv122ukrvService.insertDetail',
			destroy	: 'biv122ukrvService.deleteDetail',
			syncAll	: 'biv122ukrvService.saveAll'
		}
	});



	var masterForm = Unilite.createSearchPanel('searchForm', {		// 메인
		title		: '<t:message code="system.label.inventory.searchconditon" default="검색조건"/>',
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
		items	: [{
			title		: '<t:message code="system.label.inventory.basisinfo" default="기본정보"/>',
			itemId		: 'search_panel1',
			layout		: {type: 'uniTable', columns: 1},
			defaultType	: 'uniTextfield',
			items		: [{
				fieldLabel	: '<t:message code="system.label.inventory.division" default="사업장"/>',
				name		: 'DIV_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				child		: 'WH_CODE',
				value		: UserInfo.divCode,
				holdable	: 'hold',
				allowBlank	: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.inventory.warehouse" default="창고"/>',
				name		: 'WH_CODE',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('whList'),
				holdable	: 'hold',
				allowBlank	: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('WH_CODE', newValue);
					}
				}
			},
			Unilite.popup('COUNT_DATE', {
				fieldLabel	: '<t:message code="system.label.inventory.stockcountingdate" default="실사일"/>',
				align		: 'center',
				holdable	: 'hold',
				allowBlank	: false,
				listeners	: {
					onSelected: {
						fn: function(records, type) {
							var countDATE	= UniDate.getDbDateStr(records[0]['COUNT_DATE']).substring(0, 8);
							countDATE		= countDATE.substring(0,4) + '.' + countDATE.substring(4,6) + '.' + countDATE.substring(6,8);
							masterForm.setValue('COUNT_DATE'	, countDATE);
							masterForm.setValue('WH_CODE'		, records[0]['WH_CODE']);
							masterForm.setValue('COUNT_DATE2'	, records[0]['COUNT_CONT_DATE']);
							panelResult.setValue('COUNT_DATE'	, masterForm.getValue('COUNT_DATE'));
							panelResult.setValue('WH_CODE'		, masterForm.getValue('WH_CODE'));
							panelResult.setValue('COUNT_DATE2'	, masterForm.getValue('COUNT_DATE2'));
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('COUNT_DATE'	, '');
						panelResult.setValue('WH_CODE'		, '');
						panelResult.setValue('COUNT_DATE2'	, '');
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE'	: masterForm.getValue('DIV_CODE')});
						popup.setExtParam({'WH_CODE'	: masterForm.getValue('WH_CODE')});
					}
				}
			}),{
				fieldLabel	: '<t:message code="system.label.inventory.itemaccount" default="품목계정"/>',
				name		: 'ITEM_ACCOUNT',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'B020',
				holdable	: 'hold',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ITEM_ACCOUNT', newValue);
					}
				}
			},
			Unilite.popup('DIV_PUMOK',{
				fieldLabel		: '<t:message code="system.label.inventory.item" default="품목"/>',
				valueFieldName	: 'ITEM_CODE',
				textFieldName	: 'ITEM_NAME',
				holdable		: 'hold',
				listeners		: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('ITEM_CODE', masterForm.getValue('ITEM_CODE'));
							panelResult.setValue('ITEM_NAME', masterForm.getValue('ITEM_NAME'));
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('ITEM_CODE', '');
						panelResult.setValue('ITEM_NAME', '');
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});
					}
				}
			}),{
				fieldLabel	: '<t:message code="system.label.inventory.stockcountingapplydate" default="실사반영일"/>',
				name		: 'COUNT_DATE2',
				xtype		: 'uniDatefield',
				readOnly	: true,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('COUNT_DATE2', newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.sales.barcode" default="바코드"/>', 
				name		: 'BARCODE',
				xtype		: 'uniTextfield',
				readOnly	: true,
				fieldStyle	: 'IME-MODE: inactive',				//IE에서만 적용 됨
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
					},
					specialkey:function(field, event)	{
						if(event.getKey() == event.ENTER) {
							var newValue = panelResult.getValue('BARCODE');
							if(!Ext.isEmpty(newValue)) {}
						}
					}
				}
			}]
		},{
			title		: '<t:message code="system.label.inventory.additionalinfo" default="추가정보"/>',
			id			: 'search_panel2',
			itemId		: 'search_panel2',
			defaultType	: 'uniTextfield',
			layout		: {type: 'uniTable', columns: 1},
			items		: [{
					xtype		: 'uniCheckboxgroup',
					fieldLabel	: ' ',
					id			: 'ZERO_CK',
					holdable	: 'hold',
					items		: [{
						boxLabel	: '<t:message code="system.label.inventory.systemqtyzeroexcept" default="전산수량 0제외"/>',
						name		: 'BOOK_ZERO',
						inputValue	: 'Y',
						width		: 120
					},{
						boxLabel	: '<t:message code="system.label.inventory.stockcountingqtyzeroexcept" default="실사수량 0제외"/>',
						name		: 'CONT_ZERO',
						inputValue	: 'Y',
						width		: 120
					}]
				},{
					fieldLabel	: '<t:message code="system.label.inventory.majorgroup" default="대분류"/>',
					name		: 'ITEM_LEVEL1' ,
					xtype		: 'uniCombobox' ,
					store		: Ext.data.StoreManager.lookup('itemLeve1Store') ,
					holdable	: 'hold',
					child		: 'ITEM_LEVEL2'
				},{
					fieldLabel	: '<t:message code="system.label.inventory.middlegroup" default="중분류"/>',
					name		: 'ITEM_LEVEL2' ,
					xtype		: 'uniCombobox' ,
					store		: Ext.data.StoreManager.lookup('itemLeve2Store') ,
					holdable	: 'hold',
					child		: 'ITEM_LEVEL3'
				},{
					fieldLabel	: '<t:message code="system.label.inventory.minorgroup" default="소분류"/>',
					name		: 'ITEM_LEVEL3' ,
					xtype		: 'uniCombobox' ,
					store		: Ext.data.StoreManager.lookup('itemLeve3Store'),
					parentNames	: ['ITEM_LEVEL1','ITEM_LEVEL2'],
					holdable	: 'hold',
					levelType	: 'ITEM'
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
							var labelText = invalid.items[0]['fieldLabel']+' : ';
						} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
							var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
						}
						alert(labelText+'<t:message code="system.message.purchase.datacheck001" default="필수입력 항목입니다."/>');
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
							var popupFC = item.up('uniPopupField')	;
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
						var popupFC = item.up('uniPopupField')	;	
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		}
	});//End of var masterForm = Unilite.createSearchForm('searchForm', {

	var panelResult = Unilite.createSearchForm('resultForm', {
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		region	: 'north',
		layout 	: {type : 'uniTable', columns : 4},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
				fieldLabel	: '<t:message code="system.label.inventory.division" default="사업장"/>',
				name		: 'DIV_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				value		: 'UserInfo.divCode',
				child		: 'WH_CODE',
				holdable	: 'hold',
				allowBlank	: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						masterForm.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.inventory.warehouse" default="창고"/>',
				name		: 'WH_CODE',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('whList'),
				holdable	: 'hold',
				allowBlank	: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						masterForm.setValue('WH_CODE', newValue);
					}
				}
			},
			Unilite.popup('COUNT_DATE', {
				fieldLabel	: '<t:message code="system.label.inventory.stockcountingdate" default="실사일"/>',
				colspan		: 2,
				align		: 'center',
				holdable	: 'hold',
				allowBlank	: false,
				listeners	: {
					onSelected: {
						fn: function(records, type) {
							var countDATE = UniDate.getDbDateStr(records[0]['COUNT_DATE']).substring(0, 8);
							countDATE = countDATE.substring(0,4) + '.' + countDATE.substring(4,6) + '.' + countDATE.substring(6,8);
							panelResult.setValue('COUNT_DATE'	, countDATE);
							panelResult.setValue('WH_CODE'		, records[0]['WH_CODE']);
							panelResult.setValue('COUNT_DATE2'	, records[0]['COUNT_CONT_DATE']);
							masterForm.setValue('COUNT_DATE'	, panelResult.getValue('COUNT_DATE'));
							masterForm.setValue('WH_CODE'		, panelResult.getValue('WH_CODE'));
							masterForm.setValue('COUNT_DATE2'	, panelResult.getValue('COUNT_DATE2'));
						},
						scope: this
					},
					onClear: function(type)	{
						masterForm.setValue('COUNT_DATE'	, '');
						masterForm.setValue('WH_CODE'		, '');
						masterForm.setValue('COUNT_DATE2'	, '');
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE'	: panelResult.getValue('DIV_CODE')});
						popup.setExtParam({'WH_CODE'	: panelResult.getValue('WH_CODE')});
					}
				}
			}),{
				fieldLabel	: '<t:message code="system.label.inventory.itemaccount" default="품목계정"/>',
				name		: 'ITEM_ACCOUNT',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'B020',
				holdable	: 'hold',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						masterForm.setValue('ITEM_ACCOUNT', newValue);
					}
				}
			},
			Unilite.popup('DIV_PUMOK',{
				fieldLabel		: '<t:message code="system.label.inventory.item" default="품목"/>',
				valueFieldName	: 'ITEM_CODE',
				textFieldName	: 'ITEM_NAME',
				holdable		: 'hold',
				listeners		: {
					onSelected: {
						fn: function(records, type) {
							masterForm.setValue('ITEM_CODE', panelResult.getValue('ITEM_CODE'));
							masterForm.setValue('ITEM_NAME', panelResult.getValue('ITEM_NAME'));
						},
						scope: this
					},
					onClear: function(type)	{
						masterForm.setValue('ITEM_CODE', '');
						masterForm.setValue('ITEM_NAME', '');
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
					}
				}
			}),{
				fieldLabel	: '<t:message code="system.label.inventory.stockcountingapplydate" default="실사반영일"/>',
				name		: 'COUNT_DATE2',
				xtype		: 'uniDatefield',
				readOnly	: true,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							masterForm.setValue('COUNT_DATE2', newValue);
						}
					}
			},{
				fieldLabel	: '<t:message code="system.label.sales.barcode" default="바코드"/>', 
				name		: 'BARCODE',
				xtype		: 'uniTextfield',
				readOnly	: true,
				fieldStyle	: 'IME-MODE: inactive',				//IE에서만 적용 됨
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
					},
					specialkey:function(field, event)	{
						if(masterForm.setAllFieldsReadOnly(true) == false){
							return false;
						}
						if(panelResult.setAllFieldsReadOnly(true) == false){
							return false;
						}
						if(event.getKey() == event.ENTER) {
							var newValue = panelResult.getValue('BARCODE');
							if(!Ext.isEmpty(newValue)) {
								fnEnterBarcode(newValue);
								panelResult.setValue('BARCODE', '');
							}
						}
					}
				}
			}
		],
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
						alert(labelText+'<t:message code="system.message.purchase.datacheck001" default="필수입력 항목입니다."/>');
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
							var popupFC = item.up('uniPopupField')	;
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
						var popupFC = item.up('uniPopupField')	;	
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		}
	});



	Unilite.defineModel('biv122ukrvModel', {		// 메인
		fields: [
			{name: 'OPR_FLAG'				, text: 'OPR_FLAG'			, type: 'string'},
			{name: 'COMP_CODE'				, text: '<t:message code="system.label.inventory.companycode" default="법인코드"/>'						, type: 'string'},
			{name: 'DIV_CODE'				, text: '<t:message code="system.label.inventory.division" default="사업장"/>'							, type: 'string'},
			{name: 'WH_CODE'				, text: '<t:message code="system.label.inventory.warehouse" default="창고"/>'							, type: 'string'},
			{name: 'COUNT_DATE'				, text: '<t:message code="system.label.inventory.stockcountingdate" default="실사일"/>'				, type: 'uniDate'},
			{name: 'ITEM_ACCOUNT'			, text: '<t:message code="system.label.inventory.itemaccount" default="품목계정"/>'						, type: 'string', comboType:'AU', comboCode:'B020'},
			{name: 'ITEM_LEVEL1'			, text: '<t:message code="system.label.inventory.large" default="대"/>'								, type: 'string'},
			{name: 'ITEM_LEVEL2'			, text: '<t:message code="system.label.inventory.middle" default="중"/>'								, type: 'string'},
			{name: 'ITEM_LEVEL3'			, text: '<t:message code="system.label.inventory.small" default="소"/>'								, type: 'string'},
			{name: 'ITEM_LEVEL_NAME1'		, text: '<t:message code="system.label.inventory.large" default="대"/>'								, type: 'string'},
			{name: 'ITEM_LEVEL_NAME2'		, text: '<t:message code="system.label.inventory.middle" default="중"/>'								, type: 'string'},
			{name: 'ITEM_LEVEL_NAME3'		, text: '<t:message code="system.label.inventory.small" default="소"/>'								, type: 'string'},
			{name: 'ITEM_CODE'				, text: '<t:message code="system.label.inventory.item" default="품목"/>'								, type: 'string', allowBlank: false},
			{name: 'ITEM_NAME'				, text: '<t:message code="system.label.inventory.itemname" default="품목명"/>'							, type: 'string'},
			{name: 'SPEC'					, text: '<t:message code="system.label.inventory.spec" default="규격"/>'								, type: 'string'},
			{name: 'STOCK_UNIT'				, text: '<t:message code="system.label.inventory.inventoryunit" default="재고단위"/>'					, type: 'string', displayField: 'value'},
			{name: 'UNIT_WGT'				, text: '<t:message code="system.label.inventory.unitweight" default="단위중량"/>'						, type: 'string'},
			{name: 'WGT_UNIT'				, text: '<t:message code="system.label.inventory.weightunit" default="중량단위"/>'						, type: 'string'},
			{name: 'WH_CELL_CODE'			, text: '<t:message code="system.label.inventory.warehousecell" default="창고Cell"/>'					, type: 'string'},
			{name: 'WH_CELL_NAME'			, text: '<t:message code="system.label.inventory.warehousecell" default="창고Cell"/>'					, type: 'string'},
			{name: 'LOT_NO'					, text: '<t:message code="system.label.inventory.lotno" default="LOT번호"/>'							, type: 'string'},
			{name: 'GOOD_STOCK_BOOK_Q'		, text: '<t:message code="system.label.inventory.good" default="양품"/>'								, type: 'uniQty'},
			{name: 'BAD_STOCK_BOOK_Q'		, text: '<t:message code="system.label.inventory.defect" default="불량"/>'							, type: 'uniQty'},
			{name: 'GOOD_STOCK_BOOK_W'		, text: '<t:message code="system.label.inventory.good" default="양품"/>'								, type: 'string'},
			{name: 'BAD_STOCK_BOOK_W'		, text: '<t:message code="system.label.inventory.defect" default="불량"/>'							, type: 'string'},
			{name: 'GOOD_STOCK_Q'			, text: '<t:message code="system.label.inventory.good" default="양품"/>'								, type: 'uniQty'/*, allowBlank: false*/},
			{name: 'BAD_STOCK_Q'			, text: '<t:message code="system.label.inventory.defect" default="불량"/>'							, type: 'uniQty'},
			{name: 'GOOD_STOCK_W'			, text: '<t:message code="system.label.inventory.good" default="양품"/>'								, type: 'string'},
			{name: 'BAD_STOCK_W'			, text: '<t:message code="system.label.inventory.defect" default="불량"/>'							, type: 'string'},
			{name: 'COUNT_FLAG'				, text: '<t:message code="system.label.inventory.processstatus" default="진행상태"/>'					, type: 'string'},
			{name: 'COUNT_CONT_DATE'		, text: '<t:message code="system.label.inventory.applyyearmonth" default="반영년월"/>'					, type: 'uniDate'},
			{name: 'OVER_GOOD_STOCK_Q'		, text: '<t:message code="system.label.inventory.good" default="양품"/>'								, type: 'uniQty'},
			{name: 'OVER_BAD_STOCK_Q'		, text: '<t:message code="system.label.inventory.defect" default="불량"/>'							, type: 'uniQty'},
			{name: 'REMARK'					, text: '<t:message code="system.label.inventory.remarks" default="비고"/>'							, type: 'string'},
			{name: 'UPDATE_DB_USER'			, text: '<t:message code="system.label.inventory.writer" default="작성자"/>'							, type: 'string'},
			{name: 'UPDATE_DB_TIME'			, text: '<t:message code="system.label.inventory.writtentiem" default="작성시간"/>'						, type: 'uniDate'},
			{name: 'GOOD_STOCK_BOOK_I'		, text: '<t:message code="system.label.inventory.systeminventoryamount" default="전산재고금액"/>'			, type: 'uniPrice'},
			{name: 'GOOD_STOCK_I'			, text: '<t:message code="system.label.inventory.stockcountinginventoryamount" default="실사재고금액"/>'	, type: 'uniPrice'},
			//barcode 정보
			{name: 'GOOD_STOCK_BARCODE_Q'	, text: '<t:message code="system.label.inventory.good" default="양품"/>'								, type: 'uniQty', allowBlank: false},
//			{name: 'BAD_STOCK_BARCODE_Q'	, text: '<t:message code="system.label.inventory.defect" default="불량"/>'							, type: 'uniQty'},
			{name: 'GOOD_STOCK_BARCODE_I'	, text: '<t:message code="system.label.inventory.inventoryamount" default="재고금액"/>'					, type: 'uniPrice'}

		]
	});//End of Unilite.defineModel('biv122ukrvModel', {



	/** Store 정의(Service 정의)
	* @type
	*/
	var directMasterStore1 = Unilite.createStore('biv122ukrvMasterStore1',{		// 메인
		proxy	: directProxy,
		model	: 'biv122ukrvModel',
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결
			editable	: true,		// 수정 모드 사용
			deletable	: true,		// 삭제 가능 여부
			useNav		: false		// prev | newxt 버튼 사용
		},
		autoLoad: false,
		loadStoreRecords: function() {
			var param= masterForm.getValues();
			param.MONEY_UNIT = gsMoneyUnit;
			/*var cOUNTdATE = masterForm.getValue('COUNT_DATE').replace('.','');
			param.COUNT_DATE = cOUNTdATE;	*/
			console.log(param);
			this.load({
				params	: param,
				callback: function(records, operation, success) {
					if(success)	{
						var activeSForm ;
						if(!masterForm.hidden)	{
							activeSForm = masterForm;
						}else {
							activeSForm = panelResult;
						}
						activeSForm.getField('BARCODE').focus();
					}
				}
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				if(!Ext.isEmpty(records[0])){
					if(records[0].get('REF_CODE1') == 'Y'){
						masterGrid.getColumn("WH_CELL_CODE").setHidden(false);
						masterGrid.getColumn("WH_CELL_NAME").setHidden(false);
						
					}else{masterGrid.getColumn("WH_CELL_CODE").setHidden(true);
						masterGrid.getColumn("WH_CELL_NAME").setHidden(true);
					}
				}
			}
		},
		saveStore: function() {
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
			var toUpdate = this.getUpdatedRecords();
			var toDelete = this.getRemovedRecords();
			var list = [].concat(toUpdate, toCreate);
			console.log("inValidRecords : ", inValidRecs);
			console.log("list:", list);
			
			Ext.each(toDelete, function(deletedRecord,i) {
				deletedRecord.set('OPR_FLAG', 'D');
			});
			console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));

			//1. 마스터 정보 파라미터 구성
			var paramMaster= masterForm.getValues();	//syncAll 수정

			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						//2.마스터 정보(Server 측 처리 시 가공)
						/*var master = batch.operations[0].getResultSet();
						masterForm.setValue("ORDER_NUM", master.ORDER_NUM);*/
						//3.기타 처리
						masterForm.getForm().wasDirty = false;
						masterForm.resetDirtyStatus();
						console.log("set was dirty to false");
						
						UniAppManager.app.onQueryButtonDown();
						UniAppManager.setToolbarButtons('save', false);
					}
				};
				this.syncAllDirect(config);
				
			} else {
				var grid = Ext.getCmp('biv122ukrvGrid1');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});	//End of var directMasterStore1 = Unilite.createStore('biv122ukrvMasterStore1',{



	/** Master Grid1 정의(Grid Panel)
	 * @type
	 */
	var masterGrid = Unilite.createGrid('biv122ukrvGrid1', {
		store	: directMasterStore1,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			expandLastColumn: true,
		 	useRowNumberer	: false,
		 	useContextMenu	: true,
		 	onLoadSelectFirst: false
		},
		features: [
			{id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false },
			{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false}
		],
		columns: [
			{dataIndex: 'OPR_FLAG'						, width:66	, hidden: true },
			{dataIndex: 'COMP_CODE'						, width:66	, hidden: true },
			{dataIndex: 'DIV_CODE'						, width:80	, hidden: true },
			{dataIndex: 'WH_CODE'						, width:80	, hidden: true },
			{dataIndex: 'COUNT_DATE'					, width:80	, hidden: true },
			{dataIndex: 'ITEM_ACCOUNT'					, width:120 },
			{text: '<t:message code="system.label.inventory.itemgroup" default="품목분류"/>',
				columns:[
					{dataIndex: 'ITEM_LEVEL1'			, width:100 },
					{dataIndex: 'ITEM_LEVEL2'			, width:100 },
					{dataIndex: 'ITEM_LEVEL3'			, width:100 },
					{dataIndex: 'ITEM_LEVEL_NAME1'		, width:100	, hidden: true},
					{dataIndex: 'ITEM_LEVEL_NAME2'		, width:100	, hidden: true},
					{dataIndex: 'ITEM_LEVEL_NAME3'		, width:100	, hidden: true}
				]
			},
			{dataIndex: 'ITEM_CODE'						, width: 110,
				editor: Unilite.popup('DIV_PUMOK_G', {
					textFieldName	: 'ITEM_CODE',
					DBtextFieldName	: 'ITEM_CODE',
//					extParam		: {SELMODEL: 'MULTI', DIV_CODE: outDivCode, POPUP_TYPE: 'GRID_CODE'},
					autoPopup		: true,
					listeners		: {
						'onSelected': {
							fn: function(records, type) {
								console.log('records : ', records);
								Ext.each(records, function(record,i) {
									if(i==0) {
										masterGrid.setItemData(record,false, masterGrid.uniOpt.currentRecord);
									} else {
										UniAppManager.app.onNewDataButtonDown();
										masterGrid.setItemData(record,false, masterGrid.getSelectedRecord());
									}
								});
							},
							scope: this
						},
						'onClear': function(type) {
							masterGrid.setItemData(null,true, masterGrid.uniOpt.currentRecord);
						},
						'applyextparam': function(popup){
							popup.setExtParam({SELMODEL: 'MULTI', DIV_CODE: outDivCode, POPUP_TYPE: 'GRID_CODE'});
						}
					}
				})
			},
			{dataIndex: 'ITEM_NAME'						, width: 160,
				editor: Unilite.popup('DIV_PUMOK_G', {
//					extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode},
					autoPopup: true,
					listeners: {
						'onSelected': {
							fn: function(records, type) {
								console.log('records : ', records);
								Ext.each(records, function(record,i) {
									if(i==0) {
										masterGrid.setItemData(record,false, masterGrid.uniOpt.currentRecord);
									} else {
										UniAppManager.app.onNewDataButtonDown();
										masterGrid.setItemData(record,false, masterGrid.getSelectedRecord());
									}
								});
							},
							scope: this
						},
						'onClear': function(type) {
							masterGrid.setItemData(null,true, masterGrid.uniOpt.currentRecord);
						},
						'applyextparam': function(popup){
							popup.setExtParam({SELMODEL: 'MULTI', DIV_CODE: outDivCode, POPUP_TYPE: 'GRID_CODE'});
						}
					}
				})
			},
			{dataIndex: 'SPEC'							, width:150 },
			{dataIndex: 'STOCK_UNIT'					, width:100	, displayField: 'value' },
			{dataIndex: 'UNIT_WGT'						, width:100	, hidden: true },
			{dataIndex: 'WGT_UNIT'						, width:80	, hidden: true },
			{dataIndex: 'WH_CELL_CODE'					, width:100	, hidden: true },
			{dataIndex: 'WH_CELL_NAME'					, width:80	, hidden: true },
			{dataIndex: 'LOT_NO'						, width:120},
			{text:'<t:message code="system.label.inventory.systemqty" default="전산수량"/>',
				columns:[
					{dataIndex: 'GOOD_STOCK_BOOK_Q'		, width:80 },
					{dataIndex: 'BAD_STOCK_BOOK_Q'		, width:80,hidden: true },
					{dataIndex: 'GOOD_STOCK_BOOK_I'		, width:120}
				]
			},
			{dataIndex: 'GOOD_STOCK_BOOK_W'				, width:80	, hidden: true },
			{dataIndex: 'BAD_STOCK_BOOK_W'				, width:80	, hidden: true },
			{text:'<t:message code="system.label.inventory.barcode" default="바코드"/>',
				columns:[
					{dataIndex: 'GOOD_STOCK_BARCODE_Q'	, width:80 },
//					{dataIndex: 'BAD_STOCK_BARCODE_Q'	, width:80	,hidden: true },
					{dataIndex: 'GOOD_STOCK_BARCODE_I'	, width:120}
				]
			},
			{text:'<t:message code="system.label.inventory.stockcountingqty" default="실사수량"/>',
				columns:[
					{dataIndex: 'GOOD_STOCK_Q'			, width:80 },
					{dataIndex: 'BAD_STOCK_Q'			, width:80,hidden: true },
					{dataIndex: 'GOOD_STOCK_I'			, width:120}
				]
			},
			{dataIndex: 'GOOD_STOCK_W'					, width:80	, hidden: true },
			{dataIndex: 'BAD_STOCK_W'					, width:80	, hidden: true },
			{dataIndex: 'COUNT_FLAG'					, width:80	, hidden: true },
			{dataIndex: 'COUNT_CONT_DATE'				, width:80	, hidden: true },
			{text:'<t:message code="system.label.inventory.shortage" default="과부족"/>',
				columns:[
					{dataIndex: 'OVER_GOOD_STOCK_Q'					, width:80 },
					{dataIndex: 'OVER_BAD_STOCK_Q'					, width:80}
				]
			},
			{dataIndex: 'REMARK'						, width:200 },
			{dataIndex: 'UPDATE_DB_USER'				, width:80	, hidden: true },
			{dataIndex: 'UPDATE_DB_TIME'				, width:80	, hidden: true }
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				if(e.record.phantom == false) {
					if(UniUtils.indexOf(e.field, [/*'GOOD_STOCK_Q', 'BAD_STOCK_Q', */'GOOD_STOCK_BARCODE_Q', 'REMARK']))
					{
						return true;
						
					} else {
						return false;
					}
					
				} else {
					if(UniUtils.indexOf(e.field, ['ITEM_CODE', 'ITEM_NAME', 'GOOD_STOCK_BARCODE_Q', 'GOOD_STOCK_Q', 'BAD_STOCK_Q', 'REMARK']))
						{
						return true;
						
					} else {
						return false;
					}
				}
			}
		},
		////품목정보 팝업에서 선택된 데이타가 그리드에 추가되는 함수, 품목팝업의 onSelected/onClear 이벤트가 일어날때 호출됨
		setItemData: function(record, dataClear, grdRecord) {
			//var grdRecord = this.getSelectedRecord();
			if(dataClear) {
				grdRecord.set('ITEM_ACCOUNT'			, "");
				grdRecord.set('ITEM_LEVEL1'				, "");
				grdRecord.set('ITEM_LEVEL2'				, "");
				grdRecord.set('ITEM_LEVEL3'				, "");
				grdRecord.set('ITEM_CODE'				, "");
				grdRecord.set('ITEM_NAME'				, "");
				grdRecord.set('SPEC'					, "");
				grdRecord.set('STOCK_UNIT'				, "");
				grdRecord.set('GOOD_STOCK_BOOK_Q'		, 0);
				grdRecord.set('BAD_STOCK_BOOK_Q'		, 0);
				grdRecord.set('GOOD_STOCK_Q'			, 0);
				grdRecord.set('BAD_STOCK_Q'				, 0);
				grdRecord.set('REMARK'					, "");

			} else {
				grdRecord.set('ITEM_ACCOUNT'			, record['ITEM_ACCOUNT']);
				grdRecord.set('ITEM_LEVEL1'				, record['ITEM_LEVEL_NAME1']);
				grdRecord.set('ITEM_LEVEL2'				, record['ITEM_LEVEL_NAME2']);
				grdRecord.set('ITEM_LEVEL3'				, record['ITEM_LEVEL_NAME3']);
				grdRecord.set('ITEM_CODE'				, record['ITEM_CODE']);
				grdRecord.set('ITEM_NAME'				, record['ITEM_NAME']);
				grdRecord.set('SPEC'					, record['SPEC']);
				grdRecord.set('STOCK_UNIT'				, record['STOCK_UNIT']);
				grdRecord.set('GOOD_STOCK_BOOK_Q'		, record['GOOD_STOCK_BOOK_']);
				grdRecord.set('BAD_STOCK_BOOK_Q'		, record['BAD_STOCK_BOOK_Q']);
				grdRecord.set('GOOD_STOCK_Q'			, record['GOOD_STOCK_Q']);
				grdRecord.set('BAD_STOCK_Q'				, record['BAD_STOCK_Q']);
				grdRecord.set('REMARK'					, record['REMARK']);

			//UniSales.fnStockQ(grdRecord, UserInfo.compCode, grdRecord.get('DIV_CODE'), null, grdRecord.get('ITEM_CODE'),  grdRecord.get('WH_CODE'));
			}
		}
	});	//End of var masterGrid = Unilite.createGrid('biv122ukrvGrid1', {





	Unilite.Main({
		id			: 'biv122ukrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				masterGrid, panelResult
			]
		},
			masterForm
		],
		fnInitBinding: function() {
			this.setDefault();
		},
		onQueryButtonDown: function() {				// 조회버튼 눌렀을떄
			if(masterForm.setAllFieldsReadOnly(true) == false){
				return false;
			}
			if(panelResult.setAllFieldsReadOnly(true) == false){
				return false;
			}
			directMasterStore1.loadStoreRecords();
			UniAppManager.setToolbarButtons('newData', true);
			
			masterForm.getField('BARCODE').setReadOnly(false);
			panelResult.getField('BARCODE').setReadOnly(false);
		},
		setDefault: function() {					// 기본값
			masterForm.setValue('DIV_CODE'	, UserInfo.divCode);
			panelResult.setValue('DIV_CODE'	, UserInfo.divCode);
			
			masterForm.getField('BARCODE').setReadOnly(true);
			panelResult.getField('BARCODE').setReadOnly(true);
			
			masterForm.getForm().wasDirty = false;
		 	masterForm.resetDirtyStatus();
		 	
			UniAppManager.setToolbarButtons(['reset', 'prev', 'next'], true);
		 	UniAppManager.setToolbarButtons(['save', 'newData'], false);
		 	
			//초기화 시 전표일로 포커스 이동
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = masterForm;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('DIV_CODE');
		},
		onResetButtonDown: function() {				// 초기화
			masterForm.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);
			
			this.suspendEvents();
			masterForm.clearForm();
			panelResult.clearForm();
			masterForm.setAllFieldsReadOnly(false);
			masterGrid.getStore().loadData({});
			directMasterStore1.clearData();
			
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {	// 저장 버튼
			directMasterStore1.saveStore();
		},
		onDeleteDataButtonDown: function() {		// 행삭제 버튼
			var selRow1 = masterGrid.getSelectedRecord();
			if(selRow1.phantom === true)	{
				masterGrid.deleteSelectedRow();
			}else if(confirm('<t:message code="system.message.inventory.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
				masterGrid.deleteSelectedRow();
			}
		},
		onNewDataButtonDown: function()	{			// 행추가
			if(masterForm.setAllFieldsReadOnly(true) == false){
				return false;
			}
			if(panelResult.setAllFieldsReadOnly(true) == false){
				return false;
			}

			var oprFlag		= 'N';
			var compCode	= UserInfo.compCode;
			var divCode		= masterForm.getValue('DIV_CODE');
			var whCode		= masterForm.getValue('WH_CODE');
			var whCellCode	= masterForm.getValue('WH_CELL_CODE');
			var countDate	= masterForm.getValue('COUNT_DATE');

			var r = {
				OPR_FLAG	: oprFlag,
				COMP_CODE	: compCode,
				DIV_CODE	: divCode,
				WH_CODE		: whCode,
				COUNT_DATE	: countDate
			};
			masterGrid.createRow(r);
			masterForm.setAllFieldsReadOnly(true);
		}
	});//End of Unilite.Main( {



	Unilite.createValidator('validator01', {
		store	: directMasterStore1,
		grid	: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "GOOD_STOCK_BARCODE_Q" :
					if(newValue < 0) {
						rv= '<t:message code="system.message.inventory.message011" default="양수만 입력가능합니다."/>';
					}else{
						record.set('GOOD_STOCK_Q'		, newValue);
						record.set('OVER_GOOD_STOCK_Q'	, (record.get('GOOD_STOCK_BOOK_Q') - newValue) * -1 );
					}
					break;
					
				case "BAD_STOCK_BARCODE_Q" :
					if(newValue < 0) {
						rv= '<t:message code="system.message.inventory.message011" default="양수만 입력가능합니다."/>';
					}else{
						record.set('BAD_STOCK_Q'		, newValue);
						record.set('OVER_BAD_STOCK_Q'	, (record.get('BAD_STOCK_BOOK_Q') - newValue) * -1 );
					}
					break;
				
				case "GOOD_STOCK_Q" :
					if(newValue < 0) {
						rv= '<t:message code="system.message.inventory.message011" default="양수만 입력가능합니다."/>';
					}else{
						record.set('GOOD_STOCK_BARCODE_Q'	, newValue);
						record.set('OVER_GOOD_STOCK_Q'		, (record.get('GOOD_STOCK_BOOK_Q') - newValue) * -1 );
					}
					break;

				case "BAD_STOCK_Q" :
					if(newValue < 0) {
						rv= '<t:message code="system.message.inventory.message011" default="양수만 입력가능합니다."/>';
					}else{
						record.set('BAD_STOCK_BARCODE_Q'	, newValue);
						record.set('OVER_BAD_STOCK_Q', (record.get('BAD_STOCK_BOOK_Q') - newValue) * -1 );
					}
					break;

				case "GOOD_STOCK_W" :
					if(newValue < 0) {
						rv= '<t:message code="system.message.inventory.message011" default="양수만 입력가능합니다."/>';
					}
					break;

				case "BAD_STOCK_W" :
					if(newValue < 0) {
						rv= '<t:message code="system.message.inventory.message011" default="양수만 입력가능합니다."/>';
					}
					break;
			}
			return rv;
		}
	});





	//바코드 입력 로직 (lot_no)
	function fnEnterBarcode(newValue) {
		//동일한 LOT_NO 입력되었을 경우 처리
		var masterRecords		= directMasterStore1.data.items;
		var itemCode			= newValue.split('|')[0].toUpperCase();
		var barcodeLotNo		= newValue.split('|')[1];
		var goodStockBarcodeQ	= Ext.isEmpty(newValue.split('|')[2]) ? 0 : newValue.split('|')[2];
		var flag = true;

		if(!Ext.isEmpty(barcodeLotNo)) {
			barcodeLotNo = barcodeLotNo.toUpperCase();
			
		} else {
			itemCode			= ''
			barcodeLotNo		= newValue.split('|')[0].toUpperCase();
			goodStockBarcodeQ	= 0;
		}
		
		//BOX 바코드가 입력되었을 때, 
		if (barcodeLotNo.substring(0, 1) == 'X') {
			var param = {
				ITEM_CODE		: itemCode,
				LOT_NO			: barcodeLotNo,
				ORDER_UNIT_Q	: goodStockBarcodeQ,
				WH_CODE			: panelResult.getValue('WH_CODE'),
				DIV_CODE		: panelResult.getValue('DIV_CODE'),
				LOT_NO_S		: '',
				GSFIFO			: ''
			}
			str105ukrvService.getFifo(param, function(provider, response){
				if(!Ext.isEmpty(provider)){
					Ext.each(provider, function(record, i) {
						if(!Ext.isEmpty(provider[i].ERR_MSG)) {
							beep();
							gsText = provider[i].ERR_MSG;
							openAlertWindow(gsText);
							panelResult.setValue('BARCODE', '');
							panelResult.getField('BARCODE').focus();
							return false;
						};
						itemCode			= provider[i].NEWVALUE.split('|')[0];
						barcodeLotNo		= provider[i].NEWVALUE.split('|')[1];
						goodStockBarcodeQ	= Ext.isEmpty(provider[i].NEWVALUE.split('|')[2]) ? 0 : provider[i].NEWVALUE.split('|')[2];

						Ext.each(masterRecords, function(masterRecord,i) {
							if(masterRecord.get('LOT_NO').toUpperCase() == barcodeLotNo) {
								beep();
								gsText = '<t:message code="system.message.inventory.message004" default="이미 등록한 품목 입니다."/>' + '\n' + 'Lot no. : ' + barcodeLotNo;
								openAlertWindow(gsText);
								panelResult.setValue('BARCODE', '');
								panelResult.getField('BARCODE').focus();
								flag = false;
								return false;
							}
						});

						if(!flag) {
							return false;
						}
					});
					
					if(flag) {
						Ext.each(provider, function(record, i) {
							itemCode			= provider[i].NEWVALUE.split('|')[0];
							barcodeLotNo		= provider[i].NEWVALUE.split('|')[1];
							goodStockBarcodeQ	= Ext.isEmpty(provider[i].NEWVALUE.split('|')[2]) ? 0 : provider[i].NEWVALUE.split('|')[2];
							
							if(fnStockCounting(itemCode, barcodeLotNo, goodStockBarcodeQ)) {
								fnMakeBarcodeRow(itemCode, barcodeLotNo, goodStockBarcodeQ);
							}
						});
					}
				}
			});
		
		//일단 LOT 바코드가 입력되었을 때,
		} else {
			Ext.each(masterRecords, function(masterRecord,i) {
				if(masterRecord.get('LOT_NO').toUpperCase() == barcodeLotNo) {
					beep();
					gsText = '<t:message code="system.message.inventory.message004" default="이미 등록한 품목 입니다."/>' + '\n' + 'Lot no. : ' + barcodeLotNo;
					openAlertWindow(gsText);
					panelResult.setValue('BARCODE', '');
					panelResult.getField('BARCODE').focus();
					flag = false;
					return false;
				}
			});
			if(flag) {
				if(fnStockCounting(itemCode, barcodeLotNo, goodStockBarcodeQ)) {
					fnMakeBarcodeRow(itemCode, barcodeLotNo, goodStockBarcodeQ);
				}
			}
		}
	}

	
	
	
	
	
	
	function fnStockCounting(itemCode, barcodeLotNo, goodStockBarcodeQ) {
		var panelItemCode = panelResult.getValue('ITEM_CODE');
		var flag = true;
		
		if(!Ext.isEmpty(panelItemCode)) {
			if(itemCode != panelItemCode) {
				beep();
				gsText = '<t:message code="system.message.inventory.message003" default="품목이 일치하지 않습니다."/>';
				openAlertWindow(gsText);
				panelResult.setValue('BARCODE', '');
				panelResult.getField('BARCODE').focus();
				flag = false;
			}
		}
		return flag;
	}

	function fnMakeBarcodeRow(itemCode, barcodeLotNo, goodStockBarcodeQ) {
		var param = masterForm.getValues();
		param.ITEM_CODE				= itemCode;
		param.LOT_NO				= barcodeLotNo;
		param.GOOD_STOCK_BARCODE_Q	= goodStockBarcodeQ;
		param.MONEY_UNIT			= gsMoneyUnit;
		biv122ukrvService.fnStockCounting (param, function(provider, response){
			if(!Ext.isEmpty(provider)){
				Ext.each(provider, function(record, i) {
					record.GOOD_STOCK_BARCODE_Q	= goodStockBarcodeQ;
					record.GOOD_STOCK_Q			= goodStockBarcodeQ;
					record.OVER_GOOD_STOCK_Q	= (record.GOOD_STOCK_BOOK_Q - goodStockBarcodeQ) * -1;
	
					if(goodStockBarcodeQ == 0 || record.OPR_FLAG == 'U') {
						record.GOOD_STOCK_BARCODE_Q	= record.GOOD_STOCK_BOOK_Q;
						record.GOOD_STOCK_Q			= record.GOOD_STOCK_BOOK_Q;
						record.OVER_GOOD_STOCK_Q	= 0;
					}
					
					UniAppManager.app.onNewDataButtonDown();
					var newRecord	= masterGrid.getSelectedRecord();
					var columns		= masterGrid.getColumns();
					Ext.each(columns, function(column, index)	{
						newRecord.set(column.initialConfig.dataIndex, record[column.initialConfig.dataIndex]);
					});
					panelResult.getField('BARCODE').focus();
				});
			} else {
				beep();
				gsText = '<t:message code="system.message.inventory.message006" default="입력하신 바코드의 품목정보가 등록되지 않았습니다."/>';
				openAlertWindow(gsText);
				panelResult.setValue('BARCODE', '');
				panelResult.getField('BARCODE').focus();
			}
		});
	}
	
	
	
	
	
	//경고창
	var alertSearch = Unilite.createSearchForm('alertSearch', {
		layout	: {type : 'uniTable', columns : 1
		, tdAttrs: {width: '100%', align : 'center', style: 'background-color: #dfe8f6;'}		//cfd9e7
		},
		items	:[{
			xtype	: 'component',
			itemId	: 'TEXT_TEST',
			width	: 330,
			height	: 50,
			html	: '',
			style	: {
				marginTop	: '3px !important',
				font		: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
			}
		},{
			xtype	: 'container',
			padding	: '0 0 0 0',
			align	: 'center',
			items	: [{
				xtype	: 'button',
				text	: '<t:message code="system.label.inventory.confirm" default="확인"/>',
				width	: 80,
				handler	: function() {
					alertWindow.hide();
				},
				disabled: false
			}]
		}]
	}); 

	function openAlertWindow() {
		if(!alertWindow) {
			alertWindow = Ext.create('widget.uniDetailWindow', {
				title	: '<t:message code="system.label.sales.warntitle" default="경고"/>',
				width	: 350,
				height	: 120,
				layout	: {type:'vbox', align:'stretch'},
				items	: [alertSearch],
				listeners : {
					beforehide: function(me, eOpt) {
						alertSearch.clearForm();
					},
					beforeclose: function( panel, eOpts ) {
						alertSearch.clearForm();
					},
					beforeshow: function( panel, eOpts ) {
						alertSearch.down('#TEXT_TEST').setHtml(gsText);
					}/*,
					specialkey:function(field, event)	{
						if(event.getKey() == event.ENTER) {
							beep();
						}
					}*/
				}		
			})
		}
		alertWindow.center();
		alertWindow.show();
	}

	function beep() {
		audioCtx = new(window.AudioContext || window.webkitAudioContext)();
	
		var oscillator = audioCtx.createOscillator();
		var gainNode = audioCtx.createGain();
	
		oscillator.connect(gainNode);
		gainNode.connect(audioCtx.destination);
	
		gainNode.gain.value = 0.1;				//VOLUME 크기
		oscillator.frequency.value = 4100;
		oscillator.type = 'sine';				//sine, square, sawtooth, triangle
	
		oscillator.start();
	
		setTimeout(
			function() {
			  oscillator.stop();
			},
			1000									//길이
		);
	};
};
</script>