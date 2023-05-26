<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="mpo152rkrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="mpo152rkrv" /> 		<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B020" />				<!-- 품목계정 -->
	<t:ExtComboStore comboType="AU" comboCode="M001" />				<!-- 발주형태 -->
	<t:ExtComboStore comboType="AU" comboCode="M201" />				<!-- 구매담당 -->
	<t:ExtComboStore comboType="AU" comboCode="Q021" />				<!-- 접수담당 -->
	<t:ExtComboStore comboType="AU" comboCode="Q001" opts="1;3;5"/>	<!-- 검사진행상태 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

var SearchInfoWindow;		//조회버튼 누르면 나오는 조회창
var referOrderWindow;		//발주참조
var referCommerceWindow;	//무역참조

var BsaCodeInfo = {
	gsReportGubun: '${gsReportGubun}'
};
var printHiddenYn = true;
if(BsaCodeInfo.gsReportGubun == 'CLIP'){
	printHiddenYn = false
}
function appMain() {

	/** Model 정의
	 * @type
	 */
	Unilite.defineModel('Mpo152rkrvModel', {
		fields: [
					{name: 'COMP_CODE'			,text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'				,type: 'string'},
					{name: 'DIV_CODE'			,text: '<t:message code="system.label.purchase.division" default="사업장"/>'					,type: 'string',child:'WH_CODE'},
					{name: 'CUSTOM_CODE'		,text: '<t:message code="system.label.purchase.custom" default="거래처"/>'						,type: 'string'},
					{name: 'CUSTOM_NAME'		,text: '<t:message code="system.label.purchase.customname" default="거래처명"/>'				,type: 'string'},
					{name: 'ITEM_CODE'			,text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'					,type: 'string', allowBlank: false},
					{name: 'ITEM_NAME'			,text: '<t:message code="system.label.purchase.itemname2" default="품명"/>'					,type: 'string'},
					{name: 'SPEC'				,text: '<t:message code="system.label.purchase.spec" default="규격"/>'						,type: 'string'},
					{name: 'ORDER_UNIT'			,text: '<t:message code="system.label.purchase.purchaseunit" default="구매단위"/>'				,type: 'string', allowBlank: false,comboType:'AU',comboCode:'B013',displayField: 'value'},
					{name: 'STOCK_UNIT'			,text: '<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>'				,type: 'string'},
					{name: 'LOT_NO'				,text: 'LOT_NO',type: 'string'},
					{name: 'ORDER_NUM'			,text: '<t:message code="system.label.purchase.pono" default="발주번호"/>'						,type: 'string'},
					{name: 'ORDER_SEQ'			,text: '<t:message code="system.label.purchase.seq" default="순번"/>'					,type: 'int'},
					{name: 'IN_DIV_CODE'		,text: '<t:message code="system.label.purchase.receiptdivision" default="입고사업장"/>'			,type: 'string', allowBlank: true, comboType: 'BOR120'},
					{name: 'ORDER_UNIT_Q'		,text: '<t:message code="system.label.purchase.poqty" default="발주량"/>'				,type: 'uniQty' , allowBlank: false}, //, allowBlank: false
					{name: 'ORDER_UNIT_P'		,text: '<t:message code="system.label.purchase.price" default="단가"/>'				,type: 'uniFC' , allowBlank: false}, //, allowBlank: false
					{name: 'ORDER_O'			,text: '<t:message code="system.label.purchase.amount" default="금액"/>'				,type: 'uniFC'},
					{name: 'ORDER_Q'			,text: '<t:message code="system.label.purchase.inventoryunitqty" default="재고단위량"/>'	,type: 'uniQty'},
					{name: 'ORDER_P'			,text: '<t:message code="system.label.purchase.pounitprice" default="발주단가"/>'			,type: 'uniUnitPrice'},
					{name: 'ORDER_TYPE'			,text: '<t:message code="Mpo501.label.ORDER_TYPE" default="발주유형"/>'		, type: 'string',comboType:'AU',comboCode:'M001'},
					{name: 'TRNS_RATE'			,text: '<t:message code="system.label.purchase.containedqty" default="입수"/>'		,type: 'float', decimalPrecision: 4, format:'0,000.0000'},
					{name: 'WH_CODE'			,text: '<t:message code="system.label.purchase.warehouse" default="창고"/>'						, type: 'string'},
					{name: 'ORDER_DATE'			,text: '<t:message code="Mpo501.label.ORDER_DATE" default="발주일"/>'			, type: 'uniDate'},
					{name: 'PRINT_CNT'			,text: '<t:message code="system.label.purchase.print" default="출력"/><t:message code="system.label.purchase.qty" default="수량"/>'	,type: 'uniQty'},
					{name: 'INSTOCK_Q'			,text: '<t:message code="system.label.purchase.receiptqty" default="입고량"/>'	,type: 'uniQty'}


		]
	});



	var masterStore = Unilite.createStore('Mpo152rkrvMasterStore',{	//조회버튼 누르면 나오는 조회창
		model: 'Mpo152rkrvModel',
		autoLoad: false,
		uniOpt: {
			isMaster	: false,	// 상위 버튼 연결
			editable	: true,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		proxy: {
			type: 'direct',
			api: {
				read: 'mpo152rkrvService.selectreceiptNumMasterList'
			}
		},
		loadStoreRecords: function() {
			var param= panelResult.getValues();

			console.log( param );
			this.load({
				params : param
			});
		}
	});



	/** 검색조건 (Search Panel)
	 * @type
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title		: '<t:message code="system.label.purchase.searchconditon" default="검색조건"/>',
		defaultType	: 'uniSearchSubPanel',
		collapsed	: UserInfo.appOption.collapseLeftSearch,
		layout		: {type: 'uniTable', columns: 1},
		listeners	: {
			collapse: function () {
				panelResult.show();
			},
			expand: function() {
				panelResult.hide();
			}
		},
		items: [{
			fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelResult.setValue('DIV_CODE', newValue);
				}
			}
		},
		Unilite.popup('CUST',{
			fieldLabel		: '<t:message code="system.label.purchase.custom" default="거래처"/>',
			autoPopup		: true,
			validateBlank	: false,
			valueFieldName	: 'CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME',
//			extParam		: {'CUSTOM_TYPE': ['1','2']},
			listeners		: {
				onSelected: {
					fn: function(records, type) {
						panelResult.setValue('CUSTOM_CODE', panelSearch.getValue('CUSTOM_CODE'));
						panelResult.setValue('CUSTOM_NAME', panelSearch.getValue('CUSTOM_NAME'));
					},
					scope: this
				},
				onClear: function(type) {
					panelResult.setValue('CUSTOM_CODE', '');
					panelResult.setValue('CUSTOM_NAME', '');
				},
				applyextparam: function(popup){
					popup.setExtParam({'CUSTOM_TYPE': ['1','2']});
				}
			}
		}),{
			fieldLabel		: '<t:message code="system.label.purchase.receiptdate" default="입고일"/>',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'RECEIPT_DATE_FR',
			endFieldName	: 'RECEIPT_DATE_TO',
			allowBlank		: false,
			startDate		: UniDate.get('startOfMonth'),
			endDate			: UniDate.get('today'),
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelResult) {
					panelResult.setValue('RECEIPT_DATE_FR',newValue);
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelResult) {
					panelResult.setValue('RECEIPT_DATE_TO',newValue);
				}
			}
		},
		Unilite.popup('DIV_PUMOK',{
			fieldLabel		: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',
			valueFieldName	: 'ITEM_CODE',
			textFieldName	: 'ITEM_NAME',
			validateBlank	: true,
			autoPopup		: true,
			listeners		: {
				onSelected: {
					fn: function(records, type) {
						console.log('records : ', records);
						panelResult.setValue('ITEM_CODE', panelSearch.getValue('ITEM_CODE'));
						panelResult.setValue('ITEM_NAME', panelSearch.getValue('ITEM_NAME'));
					},
					scope: this
				},
				onClear: function(type) {
					panelResult.setValue('ITEM_CODE', '');
					panelResult.setValue('ITEM_NAME', '');
				},
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
				}
			}
		}),{
			fieldLabel	: '<t:message code="system.label.purchase.potype" default="발주형태"/>',
			name		: 'ORDER_TYPE',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'M001',
			hidden		: true,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					//panelResult.setValue('ORDER_TYPE', newValue);
				}
			}
		},{
			fieldLabel	: 'LOT NO',
			name		: 'LOT_NO',
			xtype		: 'uniTextfield',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelResult.setValue('LOT_NO', newValue);
				}
			}
		},{
			name		: 'ITEM_ACCOUNT',
			fieldLabel	: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B020',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					//panelResult.setValue('ITEM_ACCOUNT', newValue);
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
						if(item.isPopupField) {
							var popupFC = item.up('uniPopupField')	;
							if(popupFC.holdable == 'hold') {
								popupFC.setReadOnly(true);
							}
						}
					})
				}
			} else {
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) ) {
						if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					}
					if(item.isPopupField) {
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

	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		layout	: {type : 'uniTable', columns : 5},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false,
			child		: 'WH_CODE',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
			fieldLabel		: '<t:message code="system.label.purchase.receiptdate" default="입고일"/>',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'RECEIPT_DATE_FR',
			endFieldName	: 'RECEIPT_DATE_TO',
			allowBlank		: false,
			startDate		: UniDate.get('startOfMonth'),
			endDate			: UniDate.get('today'),
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				panelSearch.setValue('RECEIPT_DATE_FR',newValue);
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				panelSearch.setValue('RECEIPT_DATE_TO',newValue);
			}
		},
		Unilite.popup('CUST',{
			fieldLabel		: '<t:message code="system.label.purchase.custom" default="거래처"/>',
			autoPopup		: true,
			validateBlank	: false,
			valueFieldName	: 'CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME',
//			extParam		: {'CUSTOM_TYPE': ['1','2']},
			listeners		: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('CUSTOM_CODE', panelResult.getValue('CUSTOM_CODE'));
						panelSearch.setValue('CUSTOM_NAME', panelResult.getValue('CUSTOM_NAME'));
					},
					scope: this
				},
				onClear: function(type) {
					panelSearch.setValue('CUSTOM_CODE', '');
					panelSearch.setValue('CUSTOM_NAME', '');
				},
				applyextparam: function(popup){
					popup.setExtParam({'CUSTOM_TYPE': ['1','2']});
				}
			}
		}),{
			xtype: 'container',
			layout:{type:'uniTable',columns:1},
			colspan:2,
			items:[{
						text	: '<div style="color: red">라벨출력</div>',
						xtype	: 'button',
						margin	: '0 0 0 20',
						handler	: function(){
							UniAppManager.app.onPrintButtonDown();
						}
					}]
		},{
			fieldLabel	: 'LOT NO',
			name		: 'LOT_NO',
			xtype		: 'uniTextfield',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('LOT_NO', newValue);
				}
			}
		},
		Unilite.popup('DIV_PUMOK',{
			fieldLabel		: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',
			valueFieldName	: 'ITEM_CODE',
			textFieldName	: 'ITEM_NAME',
			validateBlank	: true,
			autoPopup		: true,
			colspan			: 3,
			listeners		: {
				onSelected: {
					fn: function(records, type) {
						console.log('records : ', records);
						panelSearch.setValue('ITEM_CODE', panelResult.getValue('ITEM_CODE'));
						panelSearch.setValue('ITEM_NAME', panelResult.getValue('ITEM_NAME'));
					},
					scope: this
				},
				onClear: function(type) {
					panelSearch.setValue('ITEM_CODE', '');
					panelSearch.setValue('ITEM_NAME', '');
				},
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
				}
			}
		})],
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
						if(item.isPopupField) {
							var popupFC = item.up('uniPopupField')	;
							if(popupFC.holdable == 'hold') {
								popupFC.setReadOnly(true);
							}
						}
					})
				}
			} else {
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) ) {
						if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					}
					if(item.isPopupField) {
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



	/** Master Grid1 정의(Grid Panel)
	 * @type
	 */
	var masterGrid = Unilite.createGrid('mpo152rkrvGrid1', {
		layout: 'fit',
		region: 'center',
		excelTitle: '<t:message code="system.label.purchase.receipt" default="입고"/><t:message code="system.label.purchase.labelprint" default="라벨출력"/>',
		uniOpt: {
			onLoadSelectFirst: false,
			expandLastColumn: false,
			useRowNumberer: false
		},
		features: [{
			id: 'masterGridSubTotal',
			ftype: 'uniGroupingsummary',
			showSummaryRow: true
		},{
			id: 'masterGridTotal',
			ftype: 'uniSummary',
			showSummaryRow: true
		}],
		store: masterStore,
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: false, toggleOnClick: false,
			listeners: {
				select: function(grid, selectRecord, index, rowIndex, eOpts ){

				},
				deselect:  function(grid, selectRecord, index, eOpts ){

				}
			}
		}),
		columns: [
					{dataIndex:'CUSTOM_CODE'		, width: 100 },
					{dataIndex:'CUSTOM_NAME'		, width: 150 },
					{dataIndex:'ORDER_DATE'		  	, width: 100 ,hidden: true},
					{dataIndex:'ITEM_CODE'			, width: 100 },
					{dataIndex:'ITEM_NAME'			, width: 200 },
					{dataIndex:'SPEC'				, width: 120 },
					{dataIndex:'LOT_NO'				, width: 120 },
					{dataIndex:'ORDER_UNIT_Q'		, width: 100},
					{dataIndex:'INSTOCK_Q'			, width: 100},
					{dataIndex:'STOCK_UNIT'			, width: 80, align: 'center',hidden: false},
					{dataIndex:'PRINT_CNT'			, width: 100},
					{dataIndex:'ORDER_NUM'			, width: 120},
					{dataIndex:'ORDER_SEQ'			, width: 60},
					{dataIndex:'ORDER_UNIT'			, width: 80, align: 'center',hidden: true},
					{dataIndex:'TRNS_RATE'			, width: 80, align: 'center',hidden: true},
					{dataIndex:'ORDER_TYPE'			, width: 80, align: 'center',hidden: true},
					{dataIndex:'ORDER_Q'			, width: 100,hidden: true},
					{dataIndex:'ORDER_P'			, width: 120,hidden: true},
					{dataIndex:'ORDER_O'			, width: 120,hidden: true},
					{dataIndex:'ORDER_UNIT_P'		, width: 100,hidden: true},
					{dataIndex:'DIV_CODE'			, width: 90  ,hidden: true},
					{dataIndex:'COMP_CODE'			, width: 80  ,hidden : true},
					{dataIndex:'IN_DIV_CODE'		, width: 100 ,hidden : true}
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				if(UniUtils.indexOf(e.field, ['PRINT_CNT','INSTOCK_Q','LOT_NO'])){
					return true;
				}else{
					return false;
				}
			}
		}
	});

	function pad(n, width) {
		  n = n + '';
		  return n.length >= width ? n : new Array(width - n.length + 1).join('0') + n;
	}


	Unilite.Main({
		id			: 'mpo152rkrvApp',
		borderItems	: [{
			region: 'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult
			]
		},
			panelSearch
		],
		fnInitBinding: function(){
			panelResult.setValue('RECEIPT_DATE_FR'		,UniDate.get('startOfMonth'));
			panelResult.setValue('RECEIPT_DATE_TO'		,UniDate.get('today'));
			panelResult.setValue('DIV_CODE'		,UserInfo.divCode);
			this.setDefault();
		},
		onQueryButtonDown: function() {
			if(panelResult.setAllFieldsReadOnly(true) == false){
				return false;
			}
			masterStore.loadStoreRecords();
		},
		onResetButtonDown: function(){
			panelSearch.clearForm();
			panelSearch.setAllFieldsReadOnly(false);
			panelResult.clearForm();
			panelResult.setAllFieldsReadOnly(false);
			masterGrid.reset();
			masterStore.clearData();
			this.fnInitBinding();
		},
		setDefault: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.getForm().wasDirty = false;
			panelSearch.resetDirtyStatus();
			UniAppManager.setToolbarButtons(['save','print'], false);
		},
		onPrintButtonDown: function(){
			var param = panelResult.getValues();
			var selectedDetails = masterGrid.getSelectedRecords();
			if(Ext.isEmpty(selectedDetails)){
				alert('출력할 데이터를 선택하여 주십시오.');
				return;
			}
			param.PGM_ID= 'mpo152rkrv';
			param.MAIN_CODE= 'M030';

			var orderNumList;
			var orderSeqList;
			var instockQList;
			var lotNoList;
			var printCntList;

			Ext.each(selectedDetails, function(record, idx) {
				if(idx ==0) {
					orderNumList= record.get("ORDER_NUM");
					orderSeqList= record.get("ORDER_SEQ");
					instockQList= record.get("INSTOCK_Q");
					if(Ext.isEmpty(record.get("LOT_NO"))){
						lotNoList	= "^";
					}else{
						lotNoList	= record.get("LOT_NO");
					}
					printCntList= record.get("PRINT_CNT");
				} else {
					orderNumList= orderNumList	+ ',' + record.get("ORDER_NUM");
					orderSeqList= orderSeqList	+ ',' + record.get("ORDER_SEQ");
					instockQList= instockQList	+ ',' + record.get("INSTOCK_Q");
					if(Ext.isEmpty(record.get("LOT_NO"))){
						lotNoList	= lotNoList		+ ',' + "^";
					}else{
						lotNoList	= lotNoList		+ ',' + record.get("LOT_NO");
					}
					printCntList= printCntList	+ ',' + record.get("PRINT_CNT");
				}

			});

			param["dataCount"] = selectedDetails.length;
			param["ORDER_NUM"] = orderNumList;
			param["ORDER_SEQ"] = orderSeqList;
			param["INSTOCK_Q"] = instockQList;
			param["LOT_NO"]    = lotNoList;
			param["PRINT_CNT"] = printCntList;

			var win = Ext.create('widget.ClipReport', {
			url: CPATH+'/mpo/mpo152clrkrv.do',
			prgID: 'mpo152rkrv',
			extParam: param
			});
			win.center();
			win.show();
		}
	});
};
</script>