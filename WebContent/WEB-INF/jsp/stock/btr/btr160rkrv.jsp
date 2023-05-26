<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="btr160rkrv">
	<t:ExtComboStore comboType="BOR120" pgmId="btr160rkrv"/>					<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B020"/>							<!-- 품목계정 -->
	<%-- <t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList"/> --%>		<!-- 창고 -->
	<t:ExtComboStore items="${COMBO_WH_CELL_LIST}" storeId="whCellList"/>		<!-- 창고Cell -->
	<t:ExtComboStore comboType="O" storeId="whList"/>							<!-- 창고(전체) -->
	<t:ExtComboStore comboType="AU" comboCode="B024"/>							<!-- 담당자 -->
	<t:ExtComboStore comboType="AU" comboCode="B131"/>							<!-- 예/아니오 -->
	<t:ExtComboStore comboType="AU" comboCode="S011"/>							<!-- 마감정보 -->
</t:appConfig>
<style type="text/css">
	.x-change-cell3 {
		background-color: #CCFFFF;	<%--20210324 추가: 연한 파랑(하늘색)--%>
	}
</style>

<script type="text/javascript" >
var BsaCodeInfo = {		//컨트롤러에서 값을 받아옴.
	gsLotNoYN	: '${gsLotNoYN}',
	gsCellCodeYN: '${gsCellCodeYN}'
};

function appMain() {
	var LotNoYN = true;
	if(BsaCodeInfo.gsLotNoYN =='Y') {
		LotNoYN = false;
	}
	var CellCodeYN = true;
	if(BsaCodeInfo.gsCellCodeYN =='Y') {
		CellCodeYN = false;
	}


	/** 검색조건 (Search Panel)
	 * @type
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm',{
		title		: '<t:message code="system.label.inventory.searchconditon" default="검색조건"/>',
		defaultType	: 'uniSearchSubPanel',
		collapsed	: true,
		listeners	: {
			collapse: function () {
				panelResult.show();
			},
			expand: function() {
				panelResult.hide();
			}
		},
		items		: [{
			title		: '<t:message code="system.label.inventory.basisinfo" default="기본정보"/>',
			itemId		: 'search_panel1',
			layout		: {type: 'uniTable', columns: 1},
			defaultType	: 'uniTextfield',
			items		: [{
				fieldLabel	: '<t:message code="system.label.inventory.requestdivision" default="요청사업장"/>',
				name		: 'DIV_CODE',
				child		: 'WH_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				allowBlank	: false,
				value		: UserInfo.divCode,		//20200707 추가
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
						combo.changeDivCode(combo, newValue, oldValue, eOpts);
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel		: '입고희망일',			//20210324 수정: 필드명 수정: 출고요청일 -> 입고희망일
				xtype			: 'uniDateRangefield',
				startFieldName	: 'REQSTOCK_DATE_FR',
				endFieldName	: 'REQSTOCK_DATE_TO',
				startDate		: UniDate.get('today'),
				endDate			: UniDate.get('today'),
				width			: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('REQSTOCK_DATE_FR',newValue);
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('REQSTOCK_DATE_TO',newValue);
					}
				}
			},{
				xtype		: 'radiogroup',
				fieldLabel	: '출력여부',
				items		: [{
					boxLabel	: '<t:message code="system.label.sales.noprint" default="미출력"/>',
					name		: 'PRINT_YN',
					inputValue	: 'N', 
					width		: 70,
					checked		: true
				},{
					boxLabel	: '<t:message code="system.label.sales.print" default="출력"/>',
					name		: 'PRINT_YN',
					inputValue	: 'Y',
					width		: 60
				},{
					boxLabel	: '<t:message code="system.label.sales.whole" default="전체"/>',
					name		: 'PRINT_YN',
					inputValue	: '',
					width		: 70
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.getField('PRINT_YN').setValue(newValue.PRINT_YN);
					}
				}
			},{
				fieldLabel	: '입고창고',
				name		: 'WH_CODE',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('whList'),
				multiSelect	: true,
				child		: 'WH_CELL_CODE',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('WH_CODE', newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.inventory.charger" default="담당자"/>',
				name		: 'REQ_PRSN',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'B024',
				autoSelect	: false,
				onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode) {
					combo.divFilterByRefCode('refCode1', newValue, divCode);
				},
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('REQ_PRSN', newValue);
					}
				}
			},{
				xtype		: 'radiogroup',
				fieldLabel	: '출고여부',
				items		: [{
					boxLabel	: '<t:message code="system.label.product.unissued" default="미출고"/>',
					name		: 'OUT_YN',
					inputValue	: 'N', 
					width		: 70,
					checked		: true
				},{
					boxLabel	: '<t:message code="system.label.inventory.issue" default="출고"/>',
					name		: 'OUT_YN',
					inputValue	: 'Y',
					width		: 60
				},{
					boxLabel	: '<t:message code="system.label.sales.whole" default="전체"/>',
					name		: 'OUT_YN',
					inputValue	: '',
					width		: 70
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.getField('OUT_YN').setValue(newValue.OUT_YN);
					}
				}
			}]
		}]
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		region	: 'north',
		layout	: {type : 'uniTable', columns : 3},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel	: '<t:message code="system.label.inventory.requestdivision" default="요청사업장"/>',
			name		: 'DIV_CODE',
			child		: 'WH_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false,
			value		: UserInfo.divCode,		//20200707 추가
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					combo.changeDivCode(combo, newValue, oldValue, eOpts);
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
			fieldLabel		: '입고희망일',			//20210324 수정: 필드명 수정: 출고요청일 -> 입고희망일
			xtype			: 'uniDateRangefield',
			startFieldName	: 'REQSTOCK_DATE_FR',
			endFieldName	: 'REQSTOCK_DATE_TO',
			startDate		: UniDate.get('today'),
			endDate			: UniDate.get('today'),
			width			: 315,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('REQSTOCK_DATE_FR',newValue);
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('REQSTOCK_DATE_TO',newValue);
				}
			}
		},{
			xtype		: 'radiogroup',
			fieldLabel	: '출력여부',
			items		: [{
				boxLabel	: '<t:message code="system.label.sales.noprint" default="미출력"/>',
				name		: 'PRINT_YN',
				inputValue	: 'N', 
				width		: 70,
				checked		: true
			},{
				boxLabel	: '<t:message code="system.label.sales.print" default="출력"/>',
				name		: 'PRINT_YN',
				inputValue	: 'Y',
				width		: 60
			},{
				boxLabel	: '<t:message code="system.label.sales.whole" default="전체"/>',
				name		: 'PRINT_YN',
				inputValue	: '',
				width		: 70
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.getField('PRINT_YN').setValue(newValue.PRINT_YN);
				}
			}
		},{
			fieldLabel	: '입고창고',
			name		: 'WH_CODE',
			xtype		: 'uniCombobox',
			store		: Ext.data.StoreManager.lookup('whList'),
			multiSelect	: true,
			child		: 'WH_CELL_CODE',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('WH_CODE', newValue);
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.inventory.charger" default="담당자"/>',
			name		: 'REQ_PRSN',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B024',
			autoSelect	: false,
			onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode) {
				combo.divFilterByRefCode('refCode1', newValue, divCode);
			},
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('REQ_PRSN', newValue);
				}
			}
		},{
			xtype		: 'radiogroup',
			fieldLabel	: '출고여부',
			items		: [{
				boxLabel	: '<t:message code="system.label.product.unissued" default="미출고"/>',
				name		: 'OUT_YN',
				inputValue	: 'N', 
				width		: 70,
				checked		: true
			},{
				boxLabel	: '<t:message code="system.label.inventory.issue" default="출고"/>',
				name		: 'OUT_YN',
				inputValue	: 'Y',
				width		: 60
			},{
				boxLabel	: '<t:message code="system.label.sales.whole" default="전체"/>',
				name		: 'OUT_YN',
				inputValue	: '',
				width		: 70
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.getField('OUT_YN').setValue(newValue.OUT_YN);
				}
			}
		}]
	});



	/** Model 정의
	 * @type
	 */
	Unilite.defineModel('btr160rkrvModel', {
		fields: [
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.inventory.item" default="품목"/>',								type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.inventory.itemname" default="품목명"/>',						type: 'string'},
			{name: 'SPEC'				, text: '<t:message code="system.label.inventory.spec" default="규격"/>',								type: 'string'},
			{name: 'STOCK_UNIT'			, text: '<t:message code="system.label.inventory.inventoryunit" default="재고단위"/>',					type: 'string'},
			{name: 'OUT_DIV_CODE'		, text: '<t:message code="system.label.inventory.issuedivision" default="출고사업장"/>',					type: 'string', comboType: 'BOR120', defaultValue: UserInfo.divCode},
			{name: 'OUT_WH_NAME'		, text: '<t:message code="system.label.inventory.issuewarehouse" default="출고창고"/>',					type: 'string'},
			{name: 'OUT_WH_CODE'		, text: '출고처',			type: 'string'},
			{name: 'OUT_WH_CELL_NAME'	, text: '<t:message code="system.label.inventory.issuewarehousecell" default="출고창고Cell"/>',			type: 'string'},
			{name: 'ITEM_STATUS_NAME'	, text: '<t:message code="system.label.inventory.gooddefecttype" default="양불구분"/>',					type: 'string'},
			{name: 'REQSTOCK_Q'			, text: '<t:message code="system.label.inventory.requestqty" default="요청량"/>',						type: 'uniQty'},
			{name: 'OUTSTOCK_Q'			, text: '<t:message code="system.label.inventory.issueqty" default="출고량"/>',						type: 'uniQty'},
			{name: 'NOTSTOCK_Q'			, text: '<t:message code="system.label.inventory.unissuedqty" default="미출고량"/>',					type: 'uniQty'},
			{name: 'GOOD_STOCK_Q'		, text: '<t:message code="system.label.inventory.goodstockqty" default="양품재고량"/>',					type: 'uniQty'},
			{name: 'BAD_STOCK_Q'		, text: '<t:message code="system.label.inventory.defectinventoryqty" default="불량재고량"/>',			type: 'uniQty'},
			{name: 'OUTSTOCK_DATE'		, text: '<t:message code="system.label.inventory.receiptrequestdate" default="입고희망일"/>',			type: 'uniDate'},
			{name: 'REQSTOCK_NUM'		, text: '출고요청번호',		type: 'string'},
			{name: 'REQSTOCK_SEQ'		, text: '<t:message code="system.label.inventory.seq" default="순번"/>',								type: 'int'},
			{name: 'REQSTOCK_DATE'		, text: '<t:message code="system.label.inventory.requestdate" default="요청일"/>',						type: 'uniDate'},
			{name: 'CLOSE_YN'			, text: '<t:message code="system.label.inventory.requestclosing" default="요청마감"/>',					type: 'string', comboType: 'AU', comboCode: 'S011'},
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.inventory.receiptdivision2" default="받을사업장"/>',				type: 'string'},
			{name: 'WH_NAME'			, text: '입고창고(요청처)',	type: 'string'},
			{name: 'WH_CODE'			, text: '입고창고(요청처)',	type: 'string'},
			{name: 'WH_CELL_NAME'		, text: '<t:message code="system.label.inventory.receiptwarehousecellname" default="받을창고Cell명"/>',	type: 'string'},
			{name: 'INSTOCK_Q'			, text: '<t:message code="system.label.inventory.receiptqty" default="입고량"/>',						type: 'uniQty'},
			{name: 'REQ_PRSN'			, text: '<t:message code="system.label.inventory.charger" default="담당자"/>',							type: 'string', comboType: 'AU', comboCode: 'B024',		autoSelect	: false},
			{name: 'LOT_NO'				, text: '<t:message code="system.label.inventory.lotno" default="LOT번호"/>',							type: 'string'},
			{name: 'REMARK'				, text: '<t:message code="system.label.inventory.remarks" default="비고"/>',							type: 'string'},
			{name: 'PROJECT_NO'			, text: '<t:message code="system.label.inventory.projectno" default="프로젝트번호"/>',					type: 'string'},
			{name: 'UPDATE_DB_USER'		, text: '<t:message code="system.label.inventory.writer" default="작성자"/>',							type: 'string'},
			{name: 'UPDATE_DB_TIME'		, text: '<t:message code="system.label.inventory.writtendate" default="작성일"/>',						type: 'string'},
			{name: 'ORDER_NUM'			, text: '<t:message code="system.label.sales.sono" default="수주번호"/>',								type: 'string'},
			{name: 'ORDER_SEQ'			, text: '<t:message code="system.label.sales.seq" default="순번"/>',									type: 'int'},
			{name: 'PRINT_YN'			, text: '출력여부',			type: 'string', comboType: 'AU', comboCode: 'B131'}
		]
	});

	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('btr160rkrvMasterStore1',{
		model	: 'btr160rkrvModel',
		uniOpt	: {
			isMaster	: false,		// 상위 버튼 연결
			editable	: false,		// 수정 모드 사용
			deletable	: false,		// 삭제 가능 여부
			useNavi		: false			// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy	: {
			type: 'direct',
			api	: {
				read: 'btr160rkrvService.selectList'
			}
		},
		loadStoreRecords : function() {
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		groupField: ''
	});

	/** Master Grid1 정의(Grid Panel)
	 * @type
	 */
	var masterGrid = Unilite.createGrid('biv160skrvGrid1', {
		store	: directMasterStore1,
		region	: 'center',
		layout	: 'fit',
		uniOpt	: {
			onLoadSelectFirst	: false,
			expandLastColumn	: true,
			useRowNumberer		: false,
			useLiveSearch		: true,
			useMultipleSorting	: true
		},
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: true, toggleOnClick: false,
			listeners: {
				beforeselect: function(rowSelection, record, index, eOpts) {
				},
				select: function(grid, selectRecord, index, rowIndex, eOpts ) {
					UniAppManager.setToolbarButtons('print', true);
				},
				deselect:  function(grid, selectRecord, index, eOpts ) {
					if (this.selected.getCount() == 0) {
						UniAppManager.setToolbarButtons('print', false);
					}
				}
			}
		}),
		features: [
			{id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false },
			{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false}
		],
		columns:  [
			{dataIndex: 'REQSTOCK_NUM'		, width :120},
			{dataIndex: 'REQSTOCK_SEQ'		, width :80	, align: 'center'},
			{dataIndex: 'REQSTOCK_DATE'		, width :80},
			{dataIndex: 'WH_CODE'			, width :110},
			{dataIndex: 'WH_CELL_NAME'		, width :100, hidden:true},
			{dataIndex: 'ITEM_CODE'			, width :120, locked: false},
			{dataIndex: 'ITEM_NAME'			, width :180, locked: false},
			{dataIndex: 'SPEC'				, width :150},
			{dataIndex: 'STOCK_UNIT'		, width :60	, hidden:true},
			{dataIndex: 'OUT_DIV_CODE'		, width :100, hidden:true},
			{dataIndex: 'OUT_WH_NAME'		, width :85	, hidden:true},
			{dataIndex: 'ITEM_STATUS_NAME'	, width :66	, hidden:true},
			{dataIndex: 'REQSTOCK_Q'		, width :80},
			{dataIndex: 'OUTSTOCK_Q'		, width :80},
			{dataIndex: 'NOTSTOCK_Q'		, width :80, hidden:true},		//미출고량
			{dataIndex: 'OUT_WH_CODE'		, width :100},
			{dataIndex: 'OUT_WH_CELL_NAME'	, width :100, hidden:true},
			{dataIndex: 'GOOD_STOCK_Q'		, width :80	, hidden:true},
			{dataIndex: 'BAD_STOCK_Q'		, width :80	, hidden:true},
			{dataIndex: 'OUTSTOCK_DATE'		, width :80	, hidden:false},	//20210324 수정: hidden: false
			{dataIndex: 'ORDER_NUM'			, width :120, hidden:true},
			{dataIndex: 'ORDER_SEQ'			, width :66	, hidden:true},
			{dataIndex: 'CLOSE_YN'			, width :66	, hidden:true},
			{dataIndex: 'DIV_CODE'			, width :100, hidden:true},
			{dataIndex: 'WH_NAME'			, width :85	, hidden:true},
			{dataIndex: 'INSTOCK_Q'			, width :80	, hidden:true},
			{dataIndex: 'REQ_PRSN'			, width :100, hidden:true},
			{dataIndex: 'LOT_NO'			, width :120, hidden:true},
			{dataIndex: 'REMARK'			, width :133, hidden:true},
			{dataIndex: 'PROJECT_NO'		, width :133, hidden:true},
			{dataIndex: 'UPDATE_DB_USER'	, width :66	, hidden:true},
			{dataIndex: 'UPDATE_DB_TIME'	, width :66 , hidden:true},
			{dataIndex: 'PRINT_YN'			, width :66	, align: 'center'}
		],
		listeners: {
			cellclick: function( view, td, cellIndex, selRecord, tr, rowIndex, e, eOpts ) {
				//20210324 수정: 선택된 데이터는 요청번호가 같을 때 같이 취소되도록 로직 추가
				if(cellIndex != 0) {
					var sm		= masterGrid.getSelectionModel();
					var records	= directMasterStore1.data.items;
					if(!masterGrid.getSelectionModel().isSelected(selRecord)) {
						var data = masterGrid.getSelectionModel().getSelection();
						Ext.each(records, function(record, idx) {
							if(selRecord.get('REQSTOCK_NUM') == record.get('REQSTOCK_NUM')){
								data.push(record);
							}
						});
						sm.select(data);
					} else {
						var data	= new Object();
						data.records= [];
						Ext.each(records, function(record, idx) {
							if(selRecord.get('REQSTOCK_NUM') == record.get('REQSTOCK_NUM')){
								data.records.push(record);
							}
						});
						sm.deselect(data.records);
					}
				}
			},
			beforeedit: function( editor, e, eOpts) {
			},
			selectionchangerecord:function(selected) {
			},
			onGridDblClick:function(grid, record, cellIndex, colName) {
			}
		},
		//20210324 추가: 출력여부가 Y이면 표시
		viewConfig: {
			getRowClass: function(record, rowIndex, rowParams, store) {
				var cls = '';
				if(record.get('PRINT_YN') == 'Y') {
					cls = 'x-change-cell3';
				}
				return cls;
			}
		}
	});



	Unilite.Main({
		id			: 'btr160rkrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				masterGrid, panelResult
			]
		},
			panelSearch
		],
		fnInitBinding : function() {
			this.setDefault();
			btr160rkrvService.userWhcode({}, function(provider, response) {
				if(!Ext.isEmpty(provider)) {
					panelSearch.setValue('WH_CODE', provider['WH_CODE']);
					panelResult.setValue('WH_CODE', provider['WH_CODE']);
				}
			})
		},
		fnGetreqPrsnDivCode: function(subCode) {	//사업장의 첫번째 영업담당자 가져오기..
			var fRecord ='';
			Ext.each(BsaCodeInfo.reqPrsn, function(item, i) {
				if(item['refCode1'] == subCode) {
					fRecord = item['codeNo'];
					return false;
				}
			});
			return fRecord;
		},
		setDefault: function() {
			var field = panelSearch.getField('REQ_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
			field = panelResult.getField('REQ_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");

			var reqPrsn = UniAppManager.app.fnGetreqPrsnDivCode(UserInfo.divCode);		//사업장의 첫번째 영업담당자 set
			panelSearch.setValue('DIV_CODE'			, UserInfo.divCode);
			panelSearch.setValue('REQ_PRSN'			, reqPrsn);
			panelSearch.setValue('REQSTOCK_DATE_FR'	, UniDate.get('today'));
			panelSearch.setValue('REQSTOCK_DATE_TO'	, UniDate.get('today'));
			panelSearch.getField('PRINT_YN').setValue('N');
			panelSearch.getField('OUT_YN').setValue('N');

			panelResult.setValue('DIV_CODE'			, UserInfo.divCode);
			panelResult.setValue('REQ_PRSN'			, reqPrsn);
			panelResult.setValue('REQSTOCK_DATE_FR'	, UniDate.get('today'));
			panelResult.setValue('REQSTOCK_DATE_TO'	, UniDate.get('today'));
			panelResult.getField('PRINT_YN').setValue('N');
			panelResult.getField('OUT_YN').setValue('N');

			UniAppManager.setToolbarButtons(['reset'], true);
		},
		onQueryButtonDown : function() {
			if(!this.isValidSearchForm()) {
				return false;
			}else{
				masterGrid.getStore().loadStoreRecords();
				var viewNormal = masterGrid.getView();
			}
			UniAppManager.setToolbarButtons('reset', true);
		},
		onResetButtonDown: function() {		// 초기화
			this.suspendEvents();
			panelSearch.reset();
			masterGrid.reset();
			panelResult.reset();
			this.fnInitBinding();
		},
		onPrintButtonDown: function() {
			var selectedMasters = masterGrid.getSelectedRecords();
			if(Ext.isEmpty(selectedMasters)) {
				Unilite.messageBox('출력할 데이터가 없습니다.');
				return false;
			}
			var reqInfo;
			Ext.each(selectedMasters, function(record, idx) {
				if(idx ==0) {
					reqInfo = record.get('REQSTOCK_NUM') + '/' + record.get('REQSTOCK_SEQ');
				} else {
					reqInfo = reqInfo + ',' + record.get('REQSTOCK_NUM') + '/' + record.get('REQSTOCK_SEQ');
				}
			});
			var param			= panelResult.getValues();
			param.PGM_ID		= 'btr160rkrv';
			param.MAIN_CODE		= 'I015';
			param.reqInfo		= reqInfo;
			param.dataCount		= selectedMasters.length;

			var win = Ext.create('widget.ClipReport', {
				url			: CPATH+'/btr/btr160rkrv.do',
				prgID		: 'btr160rkrv',
				extParam	: param,
				submitType	: 'POST'
			});
			win.center();
			win.show();
			//출력한 데이터 출력여부 UPDATE 로직 추가
			btr160rkrvService.updatePrintStatus(param, function(provider, response) {
			});
		}
	});
};
</script>