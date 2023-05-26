<%--
'	프로그램명 : 구매입고 라벨 출력 (s_mtr110skrv_in)
'	작  성  자   : 시너지시스템즈 개발팀
'	작  성  일   : 2020.05.21
'	최종수정자 :
'	최종수정일 :
'	버	 전  : OMEGA Plus V6.0.0
--%>
<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_mtr110skrv_in">
	<t:ExtComboStore comboType="BOR120"/>				<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B004" />	<!-- 통화 -->
	<t:ExtComboStore comboType="AU" comboCode="B020" />	<!-- 품목계정 (O) -->
	<t:ExtComboStore comboType="AU" comboCode="M001" />	<!-- 발주형태 -->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >


function appMain() {
	/** 검색조건 (Search Panel)
	 * @type
	 */
	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 4},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel	: '<t:message code="system.label.purchase.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel		: '<t:message code="system.label.purchase.receiptdate" default="입고일"/>',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'INOUT_FR_DATE',
			endFieldName	: 'INOUT_TO_DATE',
			allowBlank		: false,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
			}
		},
		Unilite.popup('DIV_PUMOK',{
			fieldLabel		: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',
			valueFieldName	: 'ITEM_CODE',
			textFieldName	: 'ITEM_NAME',
			validateBlank	: false,
			listeners		: {
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
				},
				onValueFieldChange: function(field, newValue){
				},
				onTextFieldChange: function(field, newValue){
				}
			}
		}),{
			xtype		: 'radiogroup',
			fieldLabel	: '원자재 출력방법',
			labelWidth	: 110,
			items		: [{
				boxLabel	: '통합',
				width		: 60,
				name		: 'PRINT_FLAG',
				inputValue	: '1',
				checked		: true
			},{
				boxLabel	: '개별',
				width		: 70,
				name		: 'PRINT_FLAG',
				inputValue	: '2'
			}]
		},
		Unilite.popup('AGENT_CUST', {
			fieldLabel		: '<t:message code="system.label.purchase.custom" default="거래처"/>',
			valueFieldName	: 'CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME',
			validateBlank	: false,
			listeners		: {
				onValueFieldChange: function(field, newValue){
				},
				onTextFieldChange: function(field, newValue){
				},
				applyextparam: function(popup){
					popup.setExtParam({'AGENT_CUST_FILTER'	: ['1','2']});
					popup.setExtParam({'CUSTOM_TYPE'		: ['1','2']});
				}
			}
		}),{
			fieldLabel	: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>',
			name		: 'ITEM_ACCOUNT',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B020',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: 'Lot No.',
			name		: 'LOT_NO',
			xtype		: 'uniTextfield'
		},{ 
			xtype	: 'button',
			text	: '<div style="color: red"><t:message code="system.label.purchase.labelprint" default="라벨출력"/></div>',
			margin	: '0 0 0 120',
			handler	: function() {
				var records		= detailGrid.getSelectedRecords();
				if(Ext.isEmpty(records)) {
					Unilite.messageBox('<t:message code="system.message.sales.message061" default="선택된 데이터가 없습니다."/>');
					return false;
				}
				var dataErr	= false;
				var errMsg	= '';
				var errItem	= 'INDEX01';
				var data;
				var data2;
				//20200528 추가: 페이지 체크해서 많으면 확인 팝업 띄우는 로직 추가
				var totPages = 0;

				Ext.each(records, function(record, index) {
					if(record.get('ITEM_ACCOUNT') != '00' && record.get('ITEM_ACCOUNT') != '05' && record.get('ITEM_ACCOUNT') != '40' && record.get('ITEM_ACCOUNT') != '50') {
						errMsg	= '<t:message code="system.message.purchase.message107" default="출력양식이 없어 출력할 수 없습니다."/>(<t:message code="system.label.purchase.itemcode" default="품목코드"/>: ' + record.get(errItem) + ')';
						dataErr	= true;
						return false;
					} else {
						if(index == 0) {
							data = record.get('INOUT_NUM') + '/' + record.get('INOUT_SEQ');
							data2 = record.get('INOUT_NUM');
						} else {
							data = data + ',' + record.get('INOUT_NUM') + '/' + record.get('INOUT_SEQ');
							data2 = data2 + ',' + record.get('INOUT_NUM');
						}
						//20200528 추가: 페이지 체크해서 많으면 확인 팝업 띄우는 로직 추가
						if(record.get('ITEM_ACCOUNT') == '40' || record.get('ITEM_ACCOUNT') == '50') {
							totPages = totPages + record.get('ORDER_UNIT_Q');
						} else if(record.get('ITEM_ACCOUNT') == '00' || record.get('ITEM_ACCOUNT') == '05') {
							totPages = totPages + 1;
						}
					}
				});
				if(dataErr) {
					Unilite.messageBox(errMsg);
					return false;
				}
				//20200528 추가: 페이지 체크해서 많으면 확인 팝업 띄우는 로직 추가
				if(panelResult.getValues().PRINT_FLAG == '2' && totPages > 500) {
					if(!confirm('출력할 라벨수량이 500페이지 보다 많습니다. 계속 진행하시겠습니까?')) {
						return false;
					}
				}
				var param	= {
					PGM_ID		: PGM_ID,
					MAIN_CODE	: 'M030',
					DIV_CODE	: panelResult.getValue('DIV_CODE'),
					INOUT_DATA	: data,
					INOUT_NUMS	: data2,
					PRINT_FLAG	: panelResult.getValues().PRINT_FLAG
				};
				var win		= Ext.create('widget.ClipReport', {
					url			:  CPATH + '/z_in/s_mtr110clskrv_in.do',
					prgID		: 's_mtr110skrv_in',
					extParam	: param,
					//20200526 추가
					submitType	: 'POST'
				});
				win.center();
				win.show();
			}
		}]
	});



	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 's_mtr110skrv_inService.selectList'
		}
	});

	/** Model 정의
	 * @type
	 */
	Unilite.defineModel('s_mtr110skrv_inModel1', {
		fields: [
			{name: 'ITEM_LEVEL1'		, text: '<t:message code="system.label.purchase.majorgroup" default="대분류"/>'				, type: 'string'},
			{name: 'ITEM_LEVEL2'		, text: '<t:message code="system.label.purchase.middlegroup" default="중분류"/>'				, type: 'string'},
			{name: 'ITEM_LEVEL3'		, text: '<t:message code="system.label.purchase.minorgroup" default="소분류"/>'				, type: 'string'},
			{name: 'INDEX01'			, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'					, type: 'string'},//ITEM_CODE
			{name: 'INDEX02'			, text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'					, type: 'string'},//ITEM_NAME
			{name: 'INDEX03'			, text: '<t:message code="system.label.purchase.spec" default="규격"/>'						, type: 'string'},//SPEC
			{name: 'INDEX04'			, text: '<t:message code="system.label.purchase.receiptdate" default="입고일"/>'				, type: 'uniDate'},//INOUT_DATE
			{name: 'INDEX05'			, text: '<t:message code="system.label.purchase.custom" default="거래처"/>'					, type: 'string'},//INOUT_CODE
			{name: 'INDEX06'			, text: '<t:message code="system.label.purchase.custom" default="거래처"/>'					, type: 'string'},//CUSTOM_NAME
			{name: 'INOUT_Q'			, text: '<t:message code="system.label.purchase.receiptqty3" default="입고량(재고)"/>'			, type: 'uniQty'},
			{name: 'STOCK_UNIT'			, text: '<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>'			, type: 'string'},
			{name: 'WH_CODE'			, text: '<t:message code="system.label.purchase.receiptwarehouse" default="입고창고"/>'			, type: 'string'},
			{name: 'INOUT_PRSN'			, text: '<t:message code="system.label.purchase.receiptcharge" default="입고담당"/>'			, type: 'string'},
			{name: 'MAKE_EXP_DATE'		, text: '<t:message code="system.label.inventory.expirationdate" default="유통기한"/>'			, type: 'uniDate'},
			{name: 'INOUT_NUM'			, text: '<t:message code="system.label.purchase.receiptno" default="입고번호"/>'				, type: 'string'},
			{name: 'INOUT_METH'			, text: '<t:message code="system.label.purchase.tranmethod" default="수불방법"/>'				, type: 'string'},
			{name: 'INOUT_TYPE_DETAIL'	, text: '<t:message code="system.label.purchase.trantype" default="수불유형"/>'					, type: 'string'},
			{name: 'ORDER_DATE'			, text: '<t:message code="system.label.purchase.podate" default="발주일"/>'					, type: 'uniDate'},
			{name: 'ORDER_NUM'			, text: '<t:message code="system.label.purchase.pono" default="발주번호"/>'						, type: 'string'},
			{name: 'ORDER_SEQ'			, text: '<t:message code="system.label.purchase.poseq" default="발주순번"/>'					, type: 'int'},
			{name: 'DVRY_DATE'			, text: '<t:message code="system.label.purchase.deliverydate" default="납기일"/>'				, type: 'uniDate'},
			{name: 'BUY_Q'				, text: '<t:message code="system.label.purchase.purchaseqty" default="매입량"/>'				, type: 'uniQty'},
			{name: 'REMARK'				, text: '<t:message code="system.label.purchase.remarks" default="비고"/>'					, type: 'string'},
			{name: 'PROJECT_NO'			, text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'				, type: 'string'},
			{name: 'LOT_NO'				, text: 'LOT No.'				, type: 'string'},
			{name: 'LC_NUM'				, text: '<t:message code="system.label.purchase.lcno" default="L/C번호"/>'					, type: 'string'},
			{name: 'BL_NUM'				, text: '<t:message code="system.label.purchase.blno" default="B/L번호"/>'					, type: 'string'},
			{name: 'CREATE_LOC'			, text: '<t:message code="system.label.purchase.creationpath" default="생성경로"/>'				, type: 'string'},
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.purchase.division" default="사업장"/>'					, type: 'string'},
			{name: 'UPDATE_DB_TIME'		, text: '<t:message code="system.label.purchase.entrydate" default="등록일"/>'					, type: 'uniDate'},
			{name: 'ORDER_UNIT_Q'		, text: '<t:message code="system.label.purchase.receiptqty" default="입고량"/>'				, type: 'uniQty'},
			{name: 'ORDER_UNIT'			, text: '<t:message code="system.label.purchase.pounit2" default="발주단위"/>'					, type: 'string'},
			{name: 'RECEIPT_DATE'		, text: '<t:message code="system.label.purchase.receiptdate2" default="접수일"/>'				, type: 'uniDate'},
			{name: 'ORDER_TYPE'			, text: '<t:message code="system.label.purchase.potype" default="발주형태"/>'					, type: 'string', comboType: 'AU', comboCode: 'M001'},
			{name: 'ITEM_ACCOUNT'		, text: '품목계정'					, type: 'string'	, type: 'string', comboType: 'AU', comboCode: 'B020'},
			{name: 'INOUT_SEQ'			, text: 'INOUT_SEQ'				, type: 'int'}
		]
	});

	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore = Unilite.createStore('s_mtr110skrv_inMasterStore1',{
		proxy	: directProxy,
		model	: 's_mtr110skrv_inModel1',
		uniOpt	: {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		autoLoad: false,
		loadStoreRecords: function() {
			var param= Ext.getCmp('resultForm').getValues();

			console.log( param );
			this.load({
				params: param
			});
		},
//		groupField: 'INDEX02',
		listeners:{
			load:function( store, records, successful, operation, eOpts )	{
				if(records && records.length > 0){
					detailGrid.setShowSummaryRow(true);
				}
			}
		}
	});


	/** Master Grid1 정의(Grid Panel)
	 * @type
	 */
	var detailGrid = Unilite.createGrid('s_mtr110skrv_inGrid1', {
		store	: directMasterStore,
		layout	: 'fit',
		region	: 'center',
//		title	: '<t:message code="system.label.purchase.itemby" default="품목별"/>',
		tbar	: [{
			xtype		: 'uniNumberfield',
			fieldLabel	: '<t:message code="system.label.purchase.selectionsummary" default="선택된 데이터 합계"/>',
			itemId		: 'selectionSummaryItem',
			readOnly	: true,
			value		: 0,
			format		: '0,000.0000',
			labelWidth	: 110,
			decimalPrecision:4
		}],
		uniOpt: {
			useGroupSummary		: true,
			useLiveSearch		: true,
			useContextMenu		: false,
			useMultipleSorting	: true,
			useRowNumberer		: false,
			expandLastColumn	: false,
			onLoadSelectFirst	: false,
			filter				: {
				useFilter	: true,
				autoCreate	: true
			},
			excel: {
				useExcel		: true,		//엑셀 다운로드 사용 여부
				exportGroup		: true,		//group 상태로 export 여부
				onlyData		: false,
				summaryExport	: true
			}
		},
		features: [ {id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
					{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false}],
		selModel	: Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false,
			listeners: {
				select: function(grid, selectRecord, index, rowIndex, eOpts ){
				},
				deselect:  function(grid, selectRecord, index, eOpts ){
				}
			}
		}),
		columns		: [{
				xtype	: 'rownumberer', 
				sortable: false, 
				width	: 35,
				align	: 'center  !important',
				resizable: true
			},	
			{dataIndex: 'ITEM_ACCOUNT'		, width: 100, locked: false},
			{dataIndex: 'INDEX01'			, width: 120, locked: false},
			{dataIndex: 'INDEX02'			, width: 150, locked: false,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.purchase.subtotal" default="소계"/>', '<t:message code="system.label.purchase.total" default="총계"/>');
				}
			},
			{dataIndex: 'LOT_NO'			, width: 113},
			{dataIndex: 'INDEX03'			, width: 150, locked: false},
			{dataIndex: 'INDEX04'			, width: 86	, locked: false},
			{dataIndex: 'ORDER_UNIT_Q'		, width: 95	, summaryType: 'sum'},
			{dataIndex: 'ORDER_UNIT'		, width: 66	, align: 'center'},
			{dataIndex: 'MAKE_EXP_DATE'		, width: 86},
			{dataIndex: 'INDEX06'			, width: 166},
//			{dataIndex: 'INOUT_Q'			, width: 95	,summaryType: 'sum'},
//			{dataIndex: 'STOCK_UNIT'		, width: 66	, align: 'center'},
//			{dataIndex: 'WH_CODE'			, width: 100},
//			{dataIndex: 'INOUT_PRSN'		, width: 66},
			{dataIndex: 'INOUT_NUM'			, width: 120},
//			{dataIndex: 'INOUT_METH'		, width: 66},
//			{dataIndex: 'INOUT_TYPE_DETAIL'	, width: 66},
//			{dataIndex: 'ORDER_DATE'		, width: 93},
			{dataIndex: 'ORDER_NUM'			, width: 120},
//			{dataIndex: 'ORDER_SEQ'			, width: 66},
//			{dataIndex: 'DVRY_DATE'			, width: 93},
//			{dataIndex: 'BUY_Q'				, width: 93	,summaryType: 'sum'},
//			{dataIndex: 'REMARK'			, width: 133},
//			{dataIndex: 'PROJECT_NO'		, width: 133},
			{dataIndex: 'ITEM_LEVEL1'		, width: 120, locked: false},
			{dataIndex: 'ITEM_LEVEL2'		, width: 120, locked: false},
			{dataIndex: 'ITEM_LEVEL3'		, width: 120, locked: false},
//			{dataIndex: 'LC_NUM'			, width: 113},
//			{dataIndex: 'BL_NUM'			, width: 113},
//			{dataIndex: 'ORDER_TYPE'		, width: 100},
//			{dataIndex: 'CREATE_LOC'		, width: 66	, hidden: true},
//			{dataIndex: 'DIV_CODE'			, width: 66	, hidden: true},
			{dataIndex: 'UPDATE_DB_TIME'	, width: 120}
		],
		listeners: {
			selectionchange:function( grid, selection, eOpts )	{
				if(selection && selection.startCell)	{
					var columnName = selection.startCell.column.dataIndex;
					if(selection.startCell.column.xtype == 'uniNnumberColumn' && selection.startCell.column.dataIndex == selection.endCell.column.dataIndex)	{
						var startIdx = selection.startCell.rowIdx, endIdx = selection.endCell.rowIdx;
						var store = grid.store;
						var sum = 0;

						for(var i=startIdx; i <= endIdx; i++){
							var record = store.getAt(i);
							sum += record.get(columnName);
						}
						this.down('#selectionSummaryItem').setValue(sum);
					} else {
						this.down('#selectionSummaryItem').setValue(0);
					}
				}
			}
		}
	});



	Unilite.Main({
		id			: 's_mtr110skrv_inApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				detailGrid, panelResult
			]
		}],
		fnInitBinding: function(params) {
			panelResult.setValue('DIV_CODE'		, UserInfo.divCode);
			panelResult.setValue('INOUT_FR_DATE', UniDate.get('startOfMonth'));
			panelResult.setValue('INOUT_TO_DATE', UniDate.get('today'));
			panelResult.getField('PRINT_FLAG').setValue('1');

			panelResult.onLoadSelectText('DIV_CODE');
		},
		onQueryButtonDown: function() {
			if(!panelResult.getInvalidMessage()){
				return false;
			}else{
				detailGrid.getStore().loadStoreRecords();
			}
		},
		onResetButtonDown: function() {
			panelResult.clearForm();
			detailGrid.getStore().loadData({});
			this.fnInitBinding();
		}
	});
};
</script>