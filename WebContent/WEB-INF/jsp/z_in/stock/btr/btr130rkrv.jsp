<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="btr130rkrv">
	<t:ExtComboStore comboType="BOR120" pgmId="btr130rkrv"/>					<!-- 사업장 -->
	<t:ExtComboStore comboType="O" storeId="whList"/>							<!--창고(전체) -->
	<t:ExtComboStore comboType="AU" comboCode="B024"/>							<!--담당자-->
</t:appConfig>

<script type="text/javascript" >

function appMain() {
	var BsaCodeInfo = {
		inoutPrsn: '${gsInOutPrsn}'
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
				fieldLabel	: '<t:message code="system.label.inventory.issuedivision" default="출고사업장"/>',
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
				fieldLabel		: '<t:message code="system.label.inventory.issuedate" default="출고일"/>',
				xtype			: 'uniDateRangefield',
				startFieldName	: 'INOUT_DATE_FR',
				endFieldName	: 'INOUT_DATE_TO',
				startDate		: UniDate.get('today'),
				endDate			: UniDate.get('today'),
				width			: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('INOUT_DATE_FR',newValue);
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('INOUT_DATE_TO',newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.inventory.issuewarehouse" default="출고창고"/>',
				name		: 'WH_CODE',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('whList'),
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('WH_CODE', newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.inventory.charger" default="담당자"/>',
				name		: 'INOUT_PRSN',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'B024',
				autoSelect	: false,
				onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode) {
					combo.divFilterByRefCode('refCode1', newValue, divCode);
				},
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('INOUT_PRSN', newValue);
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
				name		: 'IN_WH_CODE',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('whList'),
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('IN_WH_CODE', newValue);
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
			fieldLabel	: '<t:message code="system.label.inventory.issuedivision" default="출고사업장"/>',
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
			fieldLabel		: '<t:message code="system.label.inventory.issuedate" default="출고일"/>',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'INOUT_DATE_FR',
			endFieldName	: 'INOUT_DATE_TO',
			startDate		: UniDate.get('today'),
			endDate			: UniDate.get('today'),
			width			: 315,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('INOUT_DATE_FR',newValue);
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('INOUT_DATE_TO',newValue);
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.inventory.issuewarehouse" default="출고창고"/>',
			name		: 'WH_CODE',
			xtype		: 'uniCombobox',
			store		: Ext.data.StoreManager.lookup('whList'),
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('WH_CODE', newValue);
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.inventory.charger" default="담당자"/>',
			name		: 'INOUT_PRSN',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B024',
			autoSelect	: false,
			onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode) {
				combo.divFilterByRefCode('refCode1', newValue, divCode);
			},
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('INOUT_PRSN', newValue);
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
			name		: 'IN_WH_CODE',
			xtype		: 'uniCombobox',
			store		: Ext.data.StoreManager.lookup('whList'),
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('IN_WH_CODE', newValue);
				}
			}
		}]
	});



	/** Model 정의
	 * @type
	 */
	Unilite.defineModel('btr130rkrvModel', {
		fields: [
		 	{name: 'DIV_CODE',			text: '<t:message code="system.label.inventory.issuedivision" default="출고사업장"/>',					type: 'string'},
		 	{name: 'WH_NAME',			text: '<t:message code="system.label.inventory.issuewarehouse" default="출고창고"/>',					type: 'string'},
			{name: 'WH_CODE',			text: '<t:message code="system.label.inventory.issuewarehousename" default="출고창고명"/>',				type: 'string'},
			{name: 'ITEM_CODE',			text: '<t:message code="system.label.inventory.item" default="품목"/>',								type: 'string'},
			{name: 'ITEM_NAME',			text: '<t:message code="system.label.inventory.itemname" default="품목명"/>',							type: 'string'},
			{name: 'SPEC',				text: '<t:message code="system.label.inventory.spec" default="규격"/>',								type: 'string'},
			{name: 'LOT_NO',			text: 'LOT NO',		type: 'string'},
			{name: 'STOCK_UNIT',		text: '<t:message code="system.label.inventory.inventoryunit" default="재고단위"/>',					type: 'string'},
			{name: 'INOUT_DATE',		text: '<t:message code="system.label.inventory.issuedate" default="출고일"/>',							type: 'uniDate'},
			{name: 'ITEM_STATUS_NAME',	text: '<t:message code="system.label.inventory.gooddefecttype" default="양불구분"/>',					type: 'string'},
			{name: 'INOUT_Q',			text: '<t:message code="system.label.inventory.issueqty" default="출고량"/>',							type: 'uniQty'},
			{name: 'TO_DIV_CODE',		text: '<t:message code="system.label.inventory.requestdivision" default="요청사업장"/>',					type: 'string'},
			{name: 'INOUT_NAME',		text: '<t:message code="system.label.inventory.receiptwarehouse" default="입고창고"/>',					type: 'string'},
			{name: 'INOUT_CODE',		text: '<t:message code="system.label.inventory.receiptwarehousename" default="입고창고명"/>',			type: 'string'},
			{name: 'INOUT_CELL_CODE',	text: '<t:message code="system.label.inventory.receiptwarehousecell2" default="입고창고cell"/>',		type: 'string'},
			{name: 'INOUT_CELL_NAME',	text: '<t:message code="system.label.inventory.receiptwarehousecellname2" default="입고창고cell"/>',	type: 'string'},
			{name: 'MOVE_IN_DATE',		text: '<t:message code="system.label.inventory.receiptdate2" default="받은일자"/>',						type: 'uniDate'},
			{name: 'MOVE_IN_Q',			text: '<t:message code="system.label.inventory.receiptqty2" default="받은수량"/>',						type: 'uniQty'},
			{name: 'INOUT_PRSN',		text: '<t:message code="system.label.inventory.charger" default="담당자"/>',							type: 'string', comboType: 'AU', comboCode: 'B024'},
			{name: 'WH_CELL_CODE',		text: '<t:message code="system.label.inventory.warehousecell" default="창고Cell"/>',					type: 'string'},
			{name: 'WH_CELL_NAME',		text: '<t:message code="system.label.inventory.warehousecell" default="창고Cell"/>',					type: 'string'},
			{name: 'LOT_NO',			text: '<t:message code="system.label.inventory.lotno" default="LOT번호"/>',							type: 'string'},
			{name: 'INOUT_NUM',			text: '<t:message code="system.label.inventory.issueno" default="출고번호"/>',							type: 'string'},
			{name: 'INOUT_SEQ',			text: '<t:message code="system.label.inventory.seq" default="순번"/>',								type: 'int'},
			{name: 'REQSTOCK_NUM',		text: '<t:message code="system.label.inventory.requestno" default="요청번호"/>',						type: 'string'},
			{name: 'REQSTOCK_SEQ',		text: '<t:message code="system.label.inventory.seq" default="순번"/>',								type: 'int'},
			{name: 'REQSTOCK_DATE',		text: '<t:message code="system.label.inventory.requestdate" default="요청일"/>',						type: 'uniDate'},
			{name: 'REMARK',			text: '<t:message code="system.label.inventory.remarks" default="비고"/>',							type: 'string'},
			{name: 'PROJECT_NO',		text: '<t:message code="system.label.inventory.projectno" default="프로젝트번호"/>',						type: 'string'},
			{name: 'ORDER_NUM',			text: '<t:message code="system.label.sales.sono" default="수주번호"/>',									type: 'string'},
			{name: 'ORDER_SEQ',			text: '<t:message code="system.label.sales.seq" default="순번"/>',									type: 'int'},
			{name: 'PRINT_YN',			text: '출력여부',		type: 'string'}
		]
	});

	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('btr130rkrvMasterStore1',{
		model	: 'btr130rkrvModel',
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
				read: 'btr130rkrvService.selectList'
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
			{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: true}
		],
		columns:  [
			{dataIndex: 'INOUT_NUM',		width: 120},
			{dataIndex: 'INOUT_SEQ',		width: 50	, align: 'center'},
			{dataIndex: 'DIV_CODE',			width: 100	, hidden: true},
			{dataIndex: 'WH_NAME',			width: 85	, hidden: true},
			{dataIndex: 'WH_CODE',			width: 100,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.sales.subtotal" default="소계"/>', '<t:message code="system.label.sales.total" default="총계"/>');
				}
			},
			{dataIndex: 'WH_CELL_CODE',		width: 100	, hidden: true},
			{dataIndex: 'WH_CELL_NAME',		width: 100	, hidden: true},
			{dataIndex: 'ITEM_CODE',		width: 120},
			{dataIndex: 'ITEM_NAME',		width: 126},
			{dataIndex: 'SPEC',				width: 150},
			{dataIndex: 'LOT_NO',			width: 150	, hidden: true},
			{dataIndex: 'STOCK_UNIT',		width: 66	, hidden: true},
			{dataIndex: 'INOUT_DATE',		width: 80	, hidden: true},
			{dataIndex: 'ITEM_STATUS_NAME',	width: 66	, hidden: true},
			{dataIndex: 'INOUT_Q',			width: 70	, summaryType: 'sum'},
			{dataIndex: 'TO_DIV_CODE',		width: 150},
			{dataIndex: 'INOUT_NAME',		width: 85	, hidden: true},
			{dataIndex: 'INOUT_CODE',		width: 100},
			{dataIndex: 'INOUT_CELL_CODE',	width: 100	, hidden: true},
			{dataIndex: 'INOUT_CELL_NAME',	width: 100	, hidden: true},
			{dataIndex: 'MOVE_IN_DATE',		width: 100	, hidden: true},
			{dataIndex: 'MOVE_IN_Q',		width: 80	, hidden: true},
			{dataIndex: 'INOUT_PRSN',		width: 70	, hidden: true},
			{dataIndex: 'REQSTOCK_NUM',		width: 100	, hidden: true},
			{dataIndex: 'REQSTOCK_SEQ',		width: 50	, hidden: true},
			{dataIndex: 'REQSTOCK_DATE',	width: 100	, hidden: true},
			{dataIndex: 'ORDER_NUM',		width: 120	, hidden: true},
			{dataIndex: 'ORDER_SEQ',		width: 66	, hidden: true},
			{dataIndex: 'REMARK',			width: 133	, hidden: true},
			{dataIndex: 'PROJECT_NO',		width: 133	, hidden: true},
			{dataIndex: 'PRINT_YN',			width: 80	, hidden: false}
		],
		listeners: {
			cellclick: function( view, td, cellIndex, selRecord, tr, rowIndex, e, eOpts ) {
				//그리드 클릭 시, 동일한 수불번호 전체 선택/해제, 체크박스는 개별로 동작하도록 구성
				if(cellIndex != 0) {
					var sm		= masterGrid.getSelectionModel();
					var records	= directMasterStore1.data.items;
					var data	= masterGrid.getSelectionModel().getSelection();
					var data2	= new Array;
					Ext.each(records, function(record, idx) {
						if(selRecord.get('INOUT_NUM') == record.get('INOUT_NUM')){
							data.push(record);
							data2.push(record);
						}
					});
					if(masterGrid.getSelectionModel().isSelected(selRecord)) {
						sm.deselect(data2);
					} else {
						sm.select(data);
					}
				}
			},
			beforeedit: function( editor, e, eOpts) {
			},
			selectionchangerecord:function(selected) {
			},
			onGridDblClick:function(grid, record, cellIndex, colName) {
			}
		}
	});



	Unilite.Main({
		id			: 'btr130rkrvApp',
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
			btr130rkrvService.userWhcode({}, function(provider, response) {
				if(!Ext.isEmpty(provider)) {
					panelSearch.setValue('WH_CODE', provider['WH_CODE']);
					panelResult.setValue('WH_CODE', provider['WH_CODE']);
				}
			})
		},
		setDefault: function() {
			var field = panelSearch.getField('INOUT_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
			field = panelResult.getField('INOUT_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");

			panelSearch.setValue('DIV_CODE'			, UserInfo.divCode);
			panelSearch.setValue('INOUT_PRSN'		, BsaCodeInfo.inoutPrsn);
			panelSearch.setValue('INOUT_DATE_FR'	, UniDate.get('today'));
			panelSearch.setValue('INOUT_DATE_TO'	, UniDate.get('today'));
			panelSearch.getField('PRINT_YN').setValue('N');

			panelResult.setValue('DIV_CODE'			, UserInfo.divCode);
			panelResult.setValue('INOUT_PRSN'		, BsaCodeInfo.inoutPrsn);
			panelResult.setValue('INOUT_DATE_FR'	, UniDate.get('today'));
			panelResult.setValue('INOUT_DATE_TO'	, UniDate.get('today'));
			panelResult.getField('PRINT_YN').setValue('N');

			UniAppManager.setToolbarButtons(['reset'], true);
		},
		onQueryButtonDown : function() {
			if(!this.isValidSearchForm()) {
				return false;
			} else {
				UniAppManager.setToolbarButtons('print', false);
				masterGrid.getStore().loadStoreRecords();
			}
			UniAppManager.setToolbarButtons('reset', true);
		},
		onResetButtonDown: function() {		// 초기화
			this.suspendEvents();
			panelSearch.reset();
			panelResult.reset();
			masterGrid.reset();
			this.fnInitBinding();
		},
		onPrintButtonDown: function() {
			var selectedMasters = masterGrid.getSelectedRecords();
			if(Ext.isEmpty(selectedMasters)) {
				Unilite.messageBox('출력할 데이터가 없습니다.');
				return false;
			}
			var inoutInfo;
			Ext.each(selectedMasters, function(record, idx) {
				if(idx ==0) {
					inoutInfo = record.get('INOUT_NUM') + '/' + record.get('INOUT_SEQ');
				} else {
					inoutInfo = inoutInfo + ',' + record.get('INOUT_NUM') + '/' + record.get('INOUT_SEQ');
				}
			});
			var param			= panelResult.getValues();
			param.PGM_ID		= PGM_ID;
			param.MAIN_CODE		= 'I015';
			param.inoutInfo		= inoutInfo;
			param.dataCount		= selectedMasters.length;

			var win = Ext.create('widget.ClipReport', {
				url			: CPATH + '/btr/btr130clrkrv.do',
				prgID		: PGM_ID,
				extParam	: param,
				submitType	: 'POST'
			});
			win.center();
			win.show();

			//출력한 데이터 출력여부 UPDATE 로직 추가: DELIVERY_DATE, PRINT_YN 변경
			btr130rkrvService.updatePrintStatus(param, function(provider, response) {
			});
		}
	});
};
</script>