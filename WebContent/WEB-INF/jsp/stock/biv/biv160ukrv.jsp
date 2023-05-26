<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<t:appConfig pgmId="biv160ukrv">
	<t:ExtComboStore comboType="BOR120" pgmId="biv160ukrv"/>				<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B024"/>						<!-- 수불 담당자 -->
	<t:ExtComboStore comboType="OU" storeId="whList"/>						<!--창고(사용여부 Y) -->
	<t:ExtComboStore items="${COMBO_WH_CELL_LIST}" storeId="whCellList" />	<!--창고Cell-->
</t:appConfig>

<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>

<script type="text/javascript">
var BsaCodeInfo = {	// 컨트롤러에서 값을 받아옴
	gsSumTypeLot	: '${gsSumTypeLot}',
	gsSumTypeCell	: '${gsSumTypeCell}'
};
var outDivCode = UserInfo.divCode;

function appMain() {
	var SumTypeCell = false;
	if(BsaCodeInfo.gsSumTypeCell == 'N') {
		SumTypeCell = true;
	}

	/** 검색조건
	 * @type
	 */
	var panelSearch = Unilite.createForm('searchForm', {
		disabled: false,
		flex	: 1,
		layout	: {type: 'uniTable', columns: 2, tdAttrs: {valign:'top'}},
		items	: [{
			fieldLabel	: '<t:message code="system.label.inventory.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false,
			child		: 'WH_CODE',
			holdable	: 'hold',
			colspan		: 2
		},{
			fieldLabel	: '<t:message code="system.label.inventory.warehouse" default="창고"/>',
			name		: 'WH_CODE',
			xtype		: 'uniCombobox',
			holdable	: 'hold',
			allowBlank	: false,
			store		: Ext.data.StoreManager.lookup('whList'),
			child		: 'WH_CELL_CODE',								//20200526 추가
			holdable	: 'hold',
			colspan		: 2
		},{
			fieldLabel	: '<t:message code="system.label.inventory.warehousecell" default="창고Cell"/>',
			name		: 'WH_CELL_CODE',
			xtype		: 'uniCombobox',
			hidden		: SumTypeCell,
			store		: Ext.data.StoreManager.lookup('whCellList'),	//20200526 수정: whList -> whCellList
			colspan		: 2
		},
		Unilite.popup('COUNT_DATE', {
			fieldLabel		: '<t:message code="system.label.inventory.stockcountingdate" default="실사일자"/>',
			validateBlank	: false,
			allowBlank		: false,
			textFieldWidth	: 150,
			colspan			: 2,
			listeners		: {
				onSelected: {
					fn: function(records, type) {
						var countDATE = UniDate.getDbDateStr(records[0]['COUNT_DATE']).substring(0, 8);
						countDATE = countDATE.substring(0,4) + '.' + countDATE.substring(4,6) + '.' + countDATE.substring(6,8);
						panelSearch.setValue('COUNT_DATE', countDATE);
						if(Ext.isEmpty(panelSearch.getValue('WH_CODE')))
							panelSearch.setValue('WH_CODE', records[0]['WH_CODE']);
						
						UniAppManager.app.fnGetStockInfo();
					},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.setValue('COUNT_DATE'	, '');
					panelSearch.setValue('WH_CODE'		, '');
					panelSearch.setValue('ITEM_CODE'	, '');
					panelSearch.setValue('ITEM_NAME'	, '');
					panelSearch.setValue('LOT_NO'		, '');
					
					UniAppManager.app.fnGetStockInfo();
				},
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE'	: panelSearch.getValue('DIV_CODE')});
					popup.setExtParam({'WH_CODE'	: panelSearch.getValue('WH_CODE')});
				}
			}
		}),
		Unilite.popup('DIV_PUMOK',{
			fieldLabel		: '<t:message code="system.label.product.item" default="품목"/>',
			valueFieldName	: 'ITEM_CODE',
			textFieldName	: 'ITEM_NAME',
			holdable		: 'hold',
			allowBlank		: false,
			colspan			: 2,
			listeners		: {
				onSelected: {
					fn: function(records, type) {
						UniAppManager.app.fnGetStockInfo();
					},
					scope: this
				},
				onClear: function(type) {
					UniAppManager.app.fnGetStockInfo();
				},
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
				}
			}
		}),
		Unilite.popup('LOTNO',{
			fieldLabel		: 'LOT NO',
			textFieldName	: 'LOT_NO',
			DBtextFieldName	: 'LOT_NO',
			holdable		: 'hold',
			allowBlank		: false,
			autoPopup		: false,
			validateBlank	: false,
			allowInputData	: true,
			colspan			: 2,
			listeners		: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('LOT_NO',records[0].LOT_NO);
						if(Ext.isEmpty(panelSearch.getValue('ITEM_CODE'))) {
							panelSearch.setValue('ITEM_CODE', records[0].ITEM_CODE);
							panelSearch.setValue('ITEM_NAME', records[0].ITEM_NAME);
						}
						UniAppManager.app.fnGetStockInfo();
					},
					scope: this
				},
				onClear: function(type) {
					UniAppManager.app.fnGetStockInfo();
				},
				applyextparam: function(popup){
					popup.setExtParam({'ITEM_CODE'	: panelSearch.getValue('ITEM_CODE')});
					popup.setExtParam({'ITEM_NAME'	: panelSearch.getValue('ITEM_NAME')});
					popup.setExtParam({'DIV_CODE'	: panelSearch.getValue('DIV_CODE')});
					popup.setExtParam({'WH_CODE'	: panelSearch.getValue('WH_CODE')});
					popup.setExtParam({'isFieldSearch':false});
				}
			}
		}),{
			fieldLabel	: '조정수량',
			name		: 'ADJ_STOCK_Q',
			xtype		: 'uniNumberfield',
			allowBlank	: false
		},{
			xtype	: 'container',
			padding	: '4 0 0 10',
			html	: '최종 재고 수량을 입력하세요.',
			style	: {
				color: 'black'
			}
		},{
			fieldLabel	: '최종작업자',
			name		: 'UPDATE_DB_USER',
			xtype		: 'uniTextfield',
			allowBlank	: true,
			readOnly	: true,
			colspan		: 2
		},{
			fieldLabel	: '최종작업일',
			name		: 'UPDATE_DB_TIME',
			xtype		: 'uniTextfield',
			allowBlank	: true,
			readOnly	: true,
			colspan		: 2
		},{
			fieldLabel	: '<t:message code="system.label.inventory.onhandqty" default="현재고량"/>',
			name		: 'GOOD_STOCK_Q',
			xtype		: 'uniNumberfield',
			allowBlank	: true,
			readOnly	: true,
			colspan		: 2
		},{
			xtype	: 'container',
			layout	: {type: 'uniTable', columns: 2},
			margin	: '10 0 0 95',
			colspan	: 2,
			items	: [{
				text	: '확인',
				itemId	: 'btnConfirm',
				xtype	: 'button',
				width	: 100,
				handler	: function(){
					if(!panelSearch.getInvalidMessage()) {
						return;
					}
					if(Ext.isEmpty(panelSearch.getValue('ADJ_STOCK_Q'))) {
						alert("조정수량이 0이거나 데이터가 없습니다.");
						return;
					}
					if(confirm("반영하시겠습니까?")) {
						var param = panelSearch.getValues();
						param.COUNT_DATE = param.COUNT_DATE.replace(/\./gi, "");
						panelSearch.getForm().submit({
							params	: param,
							success	: function(form, action) {
								Unilite.messageBox('재고수량 조정되었습니다.');
								UniAppManager.app.fnGetStockInfo();
							}
						});
					}
				}
			},{
				text	: '취소',
				xtype	: 'button',
				itemId	: 'btnCancel',
				hidden	: true,
				width	: 100,
				handler	: function(){
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
						var labelText = invalid.items[0]['fieldLabel']+' : ';
					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
						var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
					}
					alert(labelText+'<t:message code="system.message.purchase.datacheck001" default="필수입력 항목입니다."/>');
					invalid.items[0].focus();
				} else {
					//this.mask();
				}
			} else {
				this.unmask();
			}
			return r;
		},
		api: {
			load  : 'biv160ukrvService.selectForm',
			submit: 'biv160ukrvService.excuteStockAdjust'
		}
	});


	Unilite.Main({
		id		: 'biv160ukrvApp',
		items	: [panelSearch],
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE'			, UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail', false);
			UniAppManager.setToolbarButtons('reset'	, false);
			UniAppManager.setToolbarButtons('query'	, false);
		},
		fnGetStockInfo : function() {
			var param = panelSearch.getValues();
			if(Ext.isEmpty(param.COUNT_DATE) || Ext.isEmpty(param.ITEM_CODE) || Ext.isEmpty(param.LOT_NO)) {
				panelSearch.setValue('UPDATE_DB_USER'	, '');
				panelSearch.setValue('UPDATE_DB_TIME'	, '');
				panelSearch.setValue('GOOD_STOCK_Q'		, 0 );
				return;
			}
			param.COUNT_DATE = param.COUNT_DATE.replace(/\./gi, "");

			panelSearch.getForm().load({
				params : param
			});
		}
	});
};
</script>