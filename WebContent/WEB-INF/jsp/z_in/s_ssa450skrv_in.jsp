<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_ssa450skrv_in">
	<t:ExtComboStore comboType="BOR120" pgmId="s_ssa450skrv_in"  />	<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="S010" />				<!-- 영업담당 -->
	<t:ExtComboStore comboType="AU" comboCode="B056" />				<!-- 지역 -->
	<t:ExtComboStore comboType="AU" comboCode="B055" />				<!-- 거래처분류 -->
	<t:ExtComboStore comboType="AU" comboCode="S007" />				<!-- 출고유형-->
	<t:ExtComboStore comboType="AU" comboCode="S024" />				<!-- 국내:부가세유형-->
	<t:ExtComboStore comboType="AU" comboCode="S118" />				<!-- 해외:부가세유형-->
	<t:ExtComboStore comboType="AU" comboCode="S002" />				<!-- 판매유형-->
	<t:ExtComboStore comboType="AU" comboCode="B020" />				<!-- 품목유형-->
	<t:ExtComboStore comboType="AU" comboCode="S003" />				<!-- 단가구분-->
	<t:ExtComboStore comboType="AU" comboCode="B031"  opts= '1;5'/>	<!-- 생성경로-->
	<t:ExtComboStore comboType="AU" comboCode="B059" />				<!-- 과세여부-->
	<t:ExtComboStore comboType="AU" comboCode="S024" />				<!-- 부가세유형-->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />
</t:appConfig>

<script type="text/javascript" >

function appMain() {
	/** Model 정의
	 * @type
	 */
	Unilite.defineModel('S_ssa450skrv_inModel1', {
		fields: [
			{name: 'SALE_CUSTOM_CODE'	,text: '<t:message code="system.label.sales.custom" default="거래처"/>'					,type: 'string'},
			{name: 'SALE_CUSTOM_NAME'	,text: '<t:message code="system.label.sales.customname" default="거래처명"/>'				,type: 'string'},
			{name: 'BILL_TYPE'			,text: '<t:message code="system.label.sales.vattype" default="부가세유형"/>'					,type: 'string',comboType: "AU", comboCode: "S024"},
			{name: 'SALE_DATE'			,text: '<t:message code="system.label.sales.salesdate" default="매출일"/>'					,type: 'uniDate'},
			{name: 'INOUT_TYPE_DETAIL'	,text: '<t:message code="system.label.sales.issuetype" default="출고유형"/>'				,type: 'string'},
			{name: 'ITEM_CODE'			,text: '<t:message code="system.label.sales.item" default="품목"/>'						,type: 'string'},
			{name: 'ITEM_NAME'			,text: '<t:message code="system.label.sales.itemname" default="품목명"/>'					,type: 'string'},
			{name: 'ITEM_NAME1'			,text: '<t:message code="system.label.sales.itemname" default="품목명"/>'					,type: 'string'},
			{name: 'CREATE_LOC'			,text: '<t:message code="system.label.sales.creationpath" default="생성경로"/>'				,type: 'string',comboType: "AU", comboCode: "B031"},
			{name: 'SPEC'				,text: '<t:message code="system.label.sales.spec" default="규격"/>'						,type: 'string'},
			{name: 'LOT_NO'				,text: '<t:message code="system.label.sales.lotno" default="LOT번호"/>'					,type: 'string'},
			{name: 'SALE_UNIT'			,text: '<t:message code="system.label.sales.unit" default="단위"/>'						,type: 'string'},
			{name: 'PRICE_TYPE'			,text: '<t:message code="system.label.sales.priceclass" default="단가구분"/>'				,type: 'string'},
			{name: 'TRNS_RATE'			,text: '<t:message code="system.label.sales.containedqty" default="입수"/>'				,type: 'string'},
			{name: 'SALE_Q'				,text: '<t:message code="system.label.sales.salesqty" default="매출량"/>'					,type: 'uniQty'},
			{name: 'SALE_WGT_Q'			,text: '<t:message code="system.label.sales.salesqtywgt" default="매출량(중량)"/>'			,type: 'uniQty'},
			{name: 'SALE_VOL_Q'			,text: '<t:message code="system.label.sales.salesqtyvol" default="매출량(부피)"/>'			,type: 'uniQty'},
			{name: 'CUSTOM_CODE'		,text: '<t:message code="system.label.sales.salesordercustom" default="수주거래처"/>'		,type: 'string'},
			{name: 'CUSTOM_NAME'		,text: '<t:message code="system.label.sales.salesordercustomname" default="수주거래처명"/>'	,type: 'string'},
			{name: 'SALE_P'				,text: '<t:message code="system.label.sales.price" default="단가"/>'						,type: 'uniUnitPrice'},
			{name: 'SALE_FOR_WGT_P'		,text: '<t:message code="system.label.sales.priceweight" default="단가(중량)"/>'			,type: 'uniUnitPrice'},
			{name: 'SALE_FOR_VOL_P'		,text: '<t:message code="system.label.sales.pricevolumn" default="단가(부피)"/>'			,type: 'uniUnitPrice'},
			{name: 'MONEY_UNIT'			,text: '<t:message code="system.label.sales.currency" default="화폐"/>'					,type: 'string'},
			{name: 'EXCHG_RATE_O'		,text: '<t:message code="system.label.sales.exchangerate" default="환율"/>'				,type: 'uniER'},
			{name: 'SALE_LOC_AMT_F'		,text: '<t:message code="system.label.sales.salesamountforeign" default="매출액(외화)"/>'	,type: 'uniFC'},
			{name: 'SALE_AMT_TOT'		,text: '<t:message code="system.label.sales.salesamount" default="매출액"/>'				,type: 'uniPrice'},
			{name: 'TAX_TYPE'			,text: '<t:message code="system.label.sales.taxationyn" default="과세여부"/>'				,type: 'string', comboType: "AU", comboCode: "B059"},
			{name: 'TAX_AMT_O'			,text: '<t:message code="system.label.sales.taxamount" default="세액"/>'					,type: 'uniPrice'},
			{name: 'SUM_SALE_AMT'		,text: '<t:message code="system.label.sales.salestotal" default="매출계"/>'				,type: 'uniPrice'},
			{name: 'ORDER_TYPE'			,text: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>'				,type: 'string',comboType: "AU", comboCode: "S002"},
			{name: 'DIV_CODE'			,text: '<t:message code="system.label.sales.division" default="사업장"/>'					,type: 'string',comboType: "BOR120"},
			{name: 'SALE_PRSN'			,text: '<t:message code="system.label.sales.salescharge" default="영업담당"/>'				,type: 'string',comboType: "AU", comboCode: "S010"},
			{name: 'MANAGE_CUSTOM'		,text: '<t:message code="system.label.sales.summarycustom" default="집계거래처"/>'			,type: 'string'},
			{name: 'MANAGE_CUSTOM_NM'	,text: '<t:message code="system.label.sales.summarycustomname" default="집계거래처명"/>'		,type: 'string'},
			{name: 'AREA_TYPE'			,text: '<t:message code="system.label.sales.area" default="지역"/>'						,type: 'string',comboType: "AU", comboCode: "B056"},
			{name: 'AGENT_TYPE'			,text: '<t:message code="system.label.sales.customclass" default="거래처분류"/>'				,type: 'string',comboType: "AU", comboCode: "B055"},
			{name: 'PROJECT_NO'			,text: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>'				,type: 'string'},
			{name: 'PUB_NUM'			,text: '<t:message code="system.label.sales.billno" default="계산서번호"/>'					,type: 'string'},
			{name: 'EX_NUM'				,text: '<t:message code="system.label.sales.slipno" default="전표번호"/>'					,type: 'string'},
			{name: 'BILL_NUM'			,text: '<t:message code="system.label.sales.salesno" default="매출번호"/>'					,type: 'string'},
			{name: 'ORDER_NUM'			,text: '<t:message code="system.label.sales.sono" default="수주번호"/>'						,type: 'string'},
			{name: 'DISCOUNT_RATE'		,text: '<t:message code="system.label.sales.discountrate" default="할인율(%)"/>'			,type: 'number'},
			{name: 'PRICE_YN'			,text: '<t:message code="system.label.sales.priceclass" default="단가구분"/>'				,type: 'string', comboType: "AU", comboCode: "S003"},
			{name: 'WGT_UNIT'			,text: '<t:message code="system.label.sales.weightunit" default="중량단위"/>'				,type: 'string'},
			{name: 'UNIT_WGT'			,text: '<t:message code="system.label.sales.unitweight" default="단위중량"/>'				,type: 'string'},
			{name: 'VOL_UNIT'			,text: '<t:message code="system.label.sales.volumnunit" default="부피단위"/>'				,type: 'string'},
			{name: 'UNIT_VOL'			,text: '<t:message code="system.label.sales.unitvolumn" default="단위부피"/>'				,type: 'string'},
			{name: 'COMP_CODE'			 ,text: '<t:message code="system.label.sales.compcode" default="법인코드"/>'				,type: 'string'},
			{name: 'BILL_SEQ'			,text: '<t:message code="system.label.sales.billseq" default="계산서순번"/>'					,type: 'string'},
			{name: 'SALE_AMT_WON'		,text: '<t:message code="system.label.sales.cosalesamount" default="매출액(자사)"/>'			,type: 'uniPrice'},
			{name: 'TAX_AMT_WON'		,text: '<t:message code="system.label.sales.cotaxamount" default="세액(자사)"/>'			,type: 'uniPrice'},
			{name: 'SUM_SALE_AMT_WON'	,text: '<t:message code="system.label.sales.cosalestotal" default="매출계(자사)"/>'			,type: 'uniPrice'},
			{name: 'CUSTOM_ITEM_CODE'	,text: '<t:message code="system.label.sales.customitem" default="거래처품목"/>'				,type: 'string'},
			{name: 'REMARK'				,text: '<t:message code="system.label.sales.remarks" default="비고"/>'					,type: 'string'},
			{name: 'INOUT_Q'			,text: '출고수량'			 ,type: 'uniQty'},
			{name: 'SALE_AMT_O'			,text: '<t:message code=" system.label.sales.supplyamount" default="공급가액"/>'			,type: 'uniPrice'}
		]
	});

	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('s_ssa450skrv_inMasterStore1',{
		model	: 'S_ssa450skrv_inModel1',
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {
				read: 's_ssa450skrv_inService.selectList1'
			}
		},
		loadStoreRecords: function() {	
			var param= Ext.getCmp('resultForm').getValues();
			console.log( param );
			this.load({
				params: param
			});
		},
		groupField: 'SALE_CUSTOM_NAME',
		listeners:{
			load:function( store, records, successful, operation, eOpts ) {
				if(records && records.length > 0){
					masterGrid.setShowSummaryRow(true);
				}
			}
		}
	});



	/** 검색조건 (Search Panel)
	 * @type
	 */
	var panelResult = Unilite.createSearchForm('resultForm',{
		region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
			fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
			name: 'DIV_CODE',
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			value: UserInfo.divCode,
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
//					combo.changeDivCode(combo, newValue, oldValue, eOpts);
//					var field = panelSearch.getField('SALE_PRSN');
//					field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);//panelResult의 필터링 처리 위해..
//					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.sales.salesdate" default="매출일"/>',
			width: 315,
			xtype: 'uniDateRangefield',
			allowBlank: false,
			startFieldName: 'SALE_FR_DATE',
			endFieldName: 'SALE_TO_DATE',
			//startDate: UniDate.get('startOfMonth'),
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today'),
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
//				if(panelSearch) {
//					panelSearch.setValue('SALE_FR_DATE',newValue);
//					//panelSearch.getField('ISSUE_REQ_DATE_FR').validate();
//				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
//				if(panelSearch) {
//					panelSearch.setValue('SALE_TO_DATE',newValue);
//					//panelSearch.getField('ISSUE_REQ_DATE_TO').validate();
//				}
			}
		},
		Unilite.popup('AGENT_CUST',{
			fieldLabel: '<t:message code="system.label.sales.custom" default="거래처"/>',
//			extParam: {'CUSTOM_TYPE': '3'},
			valueFieldName: 'SALE_CUSTOM_CODE',
			textFieldName: 'SALE_CUSTOM_NAME',
			autoPopup:true,
			validateBlank: false,
			listeners: {
				onValueFieldChange: function(field, newValue){
//					panelSearch.setValue('SALE_CUSTOM_CODE', newValue);
				},
				onTextFieldChange: function(field, newValue){
//					panelSearch.setValue('SALE_CUSTOM_NAME', newValue);
				},
//				onSelected: {
//					fn: function(records, type) {
//						panelSearch.setValue('SALE_CUSTOM_CODE', panelResult.getValue('SALE_CUSTOM_CODE'));
//						panelSearch.setValue('SALE_CUSTOM_NAME', panelResult.getValue('SALE_CUSTOM_NAME'));
//					},
//					scope: this
//				},
			onClear: function(type) {
				panelResult.setValue('SALE_CUSTOM_CODE', '');
				panelResult.setValue('SALE_CUSTOM_NAME', '');
//				panelSearch.setValue('SALE_CUSTOM_CODE', '');
//				panelSearch.setValue('SALE_CUSTOM_NAME', '');
			},
				applyextparam: function(popup){
					popup.setExtParam({'AGENT_CUST_FILTER':  ['1', '3']});
					popup.setExtParam({'CUSTOM_TYPE':  ['1', '3']});
				}
			}
		}),{
			fieldLabel: '<t:message code="system.label.sales.salesno" default="매출번호"/>',
			xtype	: 'uniTextfield',
			name	: 'BILL_NUM'
		}]
	});



	/** Master Grid1 정의(Grid Panel)
	 * @type
	 */
	var masterGrid = Unilite.createGrid('s_ssa450skrv_inGrid1', {
		store	: directMasterStore1,
		region	: 'center',
		syncRowHeight: false,
		tbar	: [{xtype:'uniNumberfield', labelWidth: 110, fieldLabel:'<t:message code="system.label.sales.selectionsummary" default="선택된 데이터 합계"/>', id:'selectionSummary', value:0, decimalPrecision:4, format:'0,000.0000'}],
		features: [ {id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
					{id: 'masterGridTotal',	 ftype: 'uniSummary',  showSummaryRow: false} ],
		columns	: [
			{ dataIndex: 'SALE_CUSTOM_CODE'	, width: 80},
			{ dataIndex: 'SALE_CUSTOM_NAME'	, width: 120, locked: false },			//거래처명
			{ dataIndex: 'SALE_DATE'		, width: 80, locked: false,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.sales.subtotal" default="소계"/>', '<t:message code="system.label.sales.total" default="총계"/>');
			}},																		//매출일
			{ dataIndex: 'ITEM_CODE'		, width: 123},							//품목코드
			{ dataIndex: 'ITEM_NAME'		, width: 150 },							//품명
			{ dataIndex: 'ITEM_NAME1'		, width: 150, hidden: true},			//품명1
			{ dataIndex: 'LOT_NO'			, width: 100 },							//LOT_NO
			{ dataIndex: 'INOUT_TYPE_DETAIL', width: 80, align: 'center'},			//출고유형
			{ dataIndex: 'INOUT_Q'			, width: 80, summaryType: 'sum'},		//출고수량
			{ dataIndex: 'SALE_UNIT'		, width: 53, align: 'center'},			//단위
			{ dataIndex: 'TRNS_RATE'		, width: 53, align: 'right'},			//입수
			{ dataIndex: 'SALE_Q'			, width: 80, summaryType: 'sum'},		//매출량
			{ dataIndex: 'SALE_P'			, width: 113 },							//단가
			{ dataIndex: 'SALE_AMT_O'		, width: 100, summaryType: 'sum'},		//공급가액
			{ dataIndex: 'TAX_AMT_O'		, width: 100, summaryType: 'sum'},		//세액
			{ dataIndex: 'SALE_AMT_TOT'		, width: 113, summaryType: 'sum'},		//매출액
			//20200206 추가: 매출번호, 비고
			{ dataIndex: 'REMARK'			, width: 113},							//비고
			{ dataIndex: 'BILL_NUM'			, width: 113}							//매출번호
		],
		listeners:{
			selectionchange:function( grid, selection, eOpts ) {
				if(selection && selection.startCell) {
					var columnName = selection.startCell.column.dataIndex;
					var displayField= Ext.getCmp("selectionSummary");
					if(selection.startCell.column.xtype == 'uniNnumberColumn' && selection.startCell.column.dataIndex == selection.endCell.column.dataIndex) {
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
			},
			afterrender: function(grid) {
				/*var me = this;
				this.contextMenu = Ext.create('Ext.menu.Menu', {});
				this.contextMenu.add({
					text: '매출등록 바로가기',   iconCls : '',
					handler: function(menuItem, event) {
						var record = grid.getSelectedRecord();
						var params = {
							sender: me,
							'PGM_ID': 's_ssa450skrv_in',
							COMP_CODE: UserInfo.compCode,
							DIV_CODE: panelResult.getValue('DIV_CODE'),
							BILL_NUM: record.data.BILL_NUM
						}
						var rec = {data : {prgID : 'ssa100ukrv', 'text':''}};
						parent.openTab(rec, '/sales/ssa100ukrv.do', params);
					}
				}); */
			}
		}
	});



	Unilite.Main({
		id			: 's_ssa450skrv_inApp',
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult
			]
		}],
		fnInitBinding: function() {
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('SALE_TO_DATE', UniDate.get('today'));
			panelResult.setValue('SALE_FR_DATE', UniDate.get('today'));
		},
		onQueryButtonDown: function() {	
			if(!this.isValidSearchForm()){
				return false;
			}
			directMasterStore1.loadStoreRecords();
		},
		onDetailButtonDown: function() {
			var as = Ext.getCmp('AdvanceSerch');
			if(as.isHidden()) {	
				as.show();
			}else {
				as.hide()
			}
		},
		onResetButtonDown: function() {
			panelResult.clearForm();
			masterGrid.getStore().loadData({})
			this.fnInitBinding();
		}
	});
};
</script>