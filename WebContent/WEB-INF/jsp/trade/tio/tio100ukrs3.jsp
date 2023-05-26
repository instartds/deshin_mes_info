<%@page language="java" contentType="text/html; charset=utf-8"%>
//openRefSearchWindow begin
	Ext.apply(masterGrid,{
		setRefData: function(record) {
			if(!Ext.isEmpty(record['ORDER_PRSN'])) {
				panelResult.setValue('IMPORT_NM', record['ORDER_PRSN'])
			}
			panelResult.setValues({
				//20191202 주석: 상단에 수정된 로직 추가
//				'IMPORT_NM'		: record['ORDER_PRSN'],
				'AMT_UNIT'		: record['MONEY_UNIT']
				//20200114발주참조시에는 발주시 환율 세팅하지 않도록 수정'EXCHANGE_RATE'	: record['EXCHG_RATE_O']
				//20191202 주석
//				'PAY_METHODE':record['PAY_METHODE'],
			});
			gNationInout = record['NATION_INOUT'];
			var grdRecord = this.getSelectedRecord();
			grdRecord.set('SO_SER_NO', record['SO_SER_NO']);
			grdRecord.set('ITEM_CODE', record['ITEM_CODE']);
			grdRecord.set('ITEM_NAME', record['ITEM_NAME']);
			grdRecord.set('SPEC',record['SPEC']);
			grdRecord.set('STOCK_UNIT_Q', record['NINOUT_STOCK_Q']);
			grdRecord.set('UNIT', record['ORDER_UNIT']);
			grdRecord.set('ORDER_UNIT_Q',record['ORDER_UNIT_Q']);
			grdRecord.set('PRICE',record['ORDER_UNIT_P']);
			grdRecord.set('EXCHANGE_RATE', panelResult.getValue('EXCHANGE_RATE'));

			var dQty, dPrice, dExchr, dSoAmt,dUnit;
			dQty = record['NOT_INOUT_Q'];
			dPrice = record['ORDER_UNIT_P'];
			dExchr = panelResult.getValue('EXCHANGE_RATE');
			dSoAmt =  dQty * dPrice;
			dUnit = panelResult.getValue('AMT_UNIT');
			grdRecord.set('SO_AMT', dSoAmt);
			//20191129 수정
			//20200204 공통코드 t125값에 따라 절상,절사,반올림 처리
			grdRecord.set('SO_AMT_WON',UniMatrl.fnAmtWonCalc(UniMatrl.fnExchangeApply(dUnit,dSoAmt) * dExchr, BsaCodeInfo.gsTradeCalcMethod, 0));

			grdRecord.set('HS_NO', record['HS_NO']);
			grdRecord.set('HS_NAME', record['HS_NAME']);
			grdRecord.set('TRNS_RATE', record['TRNS_RATE']);
			grdRecord.set('STOCK_UNIT', record['STOCK_UNIT']);
			grdRecord.set('CLOSE_FLAG', 'N');
			grdRecord.set('USE_QTY', '0');
			grdRecord.set('ORDER_NUM', record['ORDER_NUM']);
			grdRecord.set('ORDER_SEQ', record['ORDER_SEQ']);
			grdRecord.set('PROJECT_NO', record['PROJECT_NO']);
			grdRecord.set('LOT_NO', record['LOT_NO']);
			grdRecord.set('DELIVERY_DATE', record['DVRY_DATE']);
			grdRecord.set('INSPEC_FLAG', record['INSPEC_FLAG']);
			grdRecord.set('ITEM_ACCOUNT', record['ITEM_ACCOUNT']);

			if(!Ext.isEmpty(panelResult.getValue('AGENTQ')) && !Ext.isEmpty(panelResult.getValue('AGENT_NMQ'))){
				panelResult.setValue('AGENT',panelResult.getValue('AGENTQ'));
				panelResult.setValue('AGENT_NM',panelResult.getValue('AGENT_NMQ'));
			}
			UniAppManager.setToolbarButtons('save', false);
			UniAppManager.setToolbarButtons('print', true);
		}
	});
	Unilite.defineModel('refMasterModel',{
		fields: [
			{name: 'CHOICE'			, text: '선택'				, type: 'string'},
			{name: 'ITEM_CODE'		, text: '<t:message code="system.label.trade.itemcode" default="품목코드"/>'				, type: 'string'},
			{name: 'ITEM_NAME'		, text: '<t:message code="system.label.trade.itemname" default="품목명"/>'					, type: 'string'},
			{name: 'SPEC'			, text: '<t:message code="system.label.trade.spec" default="규격"/>'						, type: 'string'},
			{name: 'ORDER_UNIT_Q'	, text: '구매단위량'				, type: 'uniQty'},
			{name: 'ORDER_Q'		, text: '재고단위량'				, type: 'uniQty'},
			{name: 'NOT_INOUT_Q'	, text: '미등록량(구매)'			, type: 'uniQty'},
			{name: 'NINOUT_STOCK_Q'	, text: '미등록량(재고)'			, type: 'uniQty'},
			{name: 'ORDER_UNIT'		, text: '구매단위'				, type: 'string'},
			{name: 'STOCK_UNIT'		, text: '재고단위'				, type: 'string'},
			{name: 'TRNS_RATE'		, text: '<t:message code="system.label.trade.containedqty" default="입수"/>'				, type: 'string'},
			{name: 'MONEY_UNIT'		, text: '<t:message code="system.label.trade.currency" default="화폐 "/>'					, type: 'string'},
			{name: 'ORDER_UNIT_P'	, text: '구매단위단가'			, type: 'uniUnitPrice'},
			{name: 'ORDER_P'		, text: '재고단위단가 '			, type: 'uniUnitPrice'},
			{name: 'EXCHG_RATE_O'	, text: '<t:message code="system.label.trade.exchangerate" default="환율"/>'				, type: 'uniUnitPrice'},
			{name: 'DVRY_DATE'		, text: '<t:message code="system.label.trade.deliverydate" default="납기일"/>'				, type: 'string'},
			{name: 'ORDER_PRSN'		, text: '발주담당'				, type: 'string'},
			{name: 'ORDER_NUM'		, text: '발주번호'				, type: 'string'},
			{name: 'ORDER_SEQ'		, text: '순번'				, type: 'string'},
			{name: 'PROJECT_NO'		, text: '프로젝트번호'			, type: 'string'},
			{name: 'LOT_NO'			, text: 'LOT NO'			, type: 'string'},
			{name: 'HS_NO'			, text: 'HS번호'				, type: 'string'},
			{name: 'HS_NAME'		, text: 'HS명'				, type: 'string'},
			{name: 'ORDER_TYPE'		, text: '발주유형'				, type: 'string', comboType:'AU', comboCode: 'T016'},
			{name: 'PAY_METHODE'	, text: '<t:message code="system.label.trade.payingterm" default="결제방법"/>'				, type: 'string', comboType:'AU', comboCode: 'T016'},
			{name: 'NATION_INOUT'	, text: '<t:message code="system.label.trade.domesticoverseasclass" default="국내외구분"/>'	, type: 'string', comboType:'AU', comboCode: 'T109'},
			{name: 'INSPEC_FLAG'	, text: '품질대상여부'			, type: 'string', comboType:'AU', comboCode: 'Q002'},
			{name: 'ITEM_ACCOUNT'	, text: '품목계정'				, type: 'string'},
			{name: 'ORDER_DATE'		, text: '<t:message code="system.label.trade.podate" default="발주일"/>'				, type: 'uniDate'}

		]
	});

	var refSearch = Unilite.createSearchForm('refSearchForm', {		//조회버튼 누르면 나오는 조회창
		layout: {type: 'uniTable', columns : 3},
		trackResetOnLoad: true,
		items: [{
				fieldLabel: '발주일',
				xtype: 'uniDateRangefield',
				startFieldName: 'ORDER_DATE_FR',
				endFieldName: 'ORDER_DATE_TO',
//				startDate: UniDate.get('startOfMonth'),
//				endDate: UniDate.get('today'),
				//holdable: 'hold',
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
				}
			},
			Unilite.popup('ITEM',{
				fieldLabel: '<t:message code="system.label.trade.itemcode" default="품목코드"/>',
				validateBlank:false,
				valueFieldName:'ITEM_CODE',
				textFieldName:'ITEM_NAME',
				listeners: {
						onValueFieldChange:function( elm, newValue, oldValue) {								
							if(!Ext.isObject(oldValue)) {
								refSearch.setValue('ITEM_NAME', '');
							}
						},
						onTextFieldChange:function( elm, newValue, oldValue) {							
							if(!Ext.isObject(oldValue)) {
								refSearch.setValue('ITEM_CODE', '');
							}
						}
				}
			})
		 ]
	});
	var refMasterStore = Unilite.createStore('refMasterStore', {	//조회버튼 누르면 나오는 조회창
		model: 'refMasterModel',
		autoLoad: false,
		uniOpt: {
			isMaster: false,			// 상위 버튼 연결
			editable: false,			// 수정 모드 사용
			deletable:false,			// 삭제 가능 여부
			useNavi : false			// prev | newxt 버튼 사용
		},
		proxy: {
			type: 'direct',
			api: {
				read: 'tio100ukrvService.fnOrderDetail'
			}
		},
		loadStoreRecords : function() {
			var param= refSearch.getValues();
			param.DIV_CODE = panelResult.getValue("DIV_CODE");
			param.EXPORTER = panelResult.getValue("EXPORTER");
			param.AGENTQ = panelResult.getValue("AGENTQ");
			console.log( param );
			this.load({
				params : param
			});
		}
	});

	var refMasterGrid = Unilite.createGrid('ipo100ma1refMasterGrid', {		//조회버튼 누르면 나오는 조회창
		layout : 'fit',
		excelTitle: 'OFFER 관리번호 팝업',
		store: refMasterStore,
		selModel :   Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }),
		uniOpt:{
			useGroupSummary: false,
			useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			onLoadSelectFirst : false,
			expandLastColumn: false,
			useRowNumberer: false
		},
		columns: [
	   		{dataIndex: 'CHOICE' , width: 80, hidden:true},
	   		{dataIndex: 'ORDER_NUM' , width: 120},
			{dataIndex: 'ORDER_DATE' , width: 80},
			{dataIndex: 'ITEM_CODE' , width: 90},
			{dataIndex: 'ITEM_NAME' , width: 100},
			{dataIndex: 'SPEC' , width: 120},
			{dataIndex: 'ORDER_UNIT_Q' , width: 105},
			{dataIndex: 'ORDER_Q' , width: 105, hidden:true},
			{dataIndex: 'NOT_INOUT_Q' , width: 105},
			{dataIndex: 'NINOUT_STOCK_Q' , width: 105},
			{dataIndex: 'ORDER_UNIT' , width: 80},
			{dataIndex: 'STOCK_UNIT' , width: 80, hidden:true},
			{dataIndex: 'TRNS_RATE' , width: 80, hidden:true},
			{dataIndex: 'MONEY_UNIT' , width: 80},
			{dataIndex: 'ORDER_UNIT_P' , width: 80},
			{dataIndex: 'ORDER_P' , width: 80, hidden:true},
			{dataIndex: 'EXCHG_RATE_O' , width: 80},
			{dataIndex: 'DVRY_DATE' , width: 80},
			{dataIndex: 'ORDER_PRSN' , width: 108},
			{dataIndex: 'ORDER_NUM' , width: 80},
			{dataIndex: 'ORDER_SEQ' , width: 80},
			{dataIndex: 'PROJECT_NO' , width: 80},
			{dataIndex: 'LOT_NO' , width: 80},
			{dataIndex: 'HS_NO' , width: 105},
			{dataIndex: 'HS_NAME' , width: 136},
			{dataIndex: 'ORDER_TYPE' , width: 80},
			{dataIndex: 'PAY_METHODE' , width: 80},
			{dataIndex: 'NATION_INOUT' , width: 80},
			{dataIndex: 'INSPEC_FLAG' , width: 117},
			{dataIndex: 'ITEM_ACCOUNT' , width: 80, hidden:true}
		],
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
				if(!Ext.isEmpty(record)){
						refMasterGrid.returnData(record);
						//UniAppManager.app.onQueryButtonDown();
						RefSearchWindow.hide();
				}else{
					alert("선택된 offer가 없습니다. offer를 선택해주세요.")
					return false;
				}
			}
		},
		returnData: function(records) {
			Ext.each(records, function(record,i){
					UniAppManager.app.onNewDataButtonDownNoFormValidate(record.data);
					//20200304 수정: 데이터set하는 위치 수정
//					masterGrid.setRefData(record.data);
			});
			directMasterStore1.fnAmtTotal();
			refMasterGrid.getStore().remove(records);
		}
	});

	function openRefSearchWindow() {			//fnFindSOSerNo
		if(!RefSearchWindow) {
			RefSearchWindow = Ext.create('widget.uniDetailWindow', {
				title: 'OFFER 참조 Tab',
				width: 1080,
				height: 580,
				layout: {type:'vbox', align:'stretch'},
				items: [refSearch, refMasterGrid], //refDetailGrid],
				tbar:  ['->',{
					itemId : 'saveBtn',
					text: '<t:message code="system.label.trade.inquiry" default="조회"/>',
					handler: function() {
						refMasterStore.loadStoreRecords();
					},
					disabled: false
				}, {
					itemId : 'OrderOkBtn',
					text: '확인',
					handler: function() {
						var records = refMasterGrid.getSelectedRecords()
						if(!Ext.isEmpty(records)){
							refMasterGrid.returnData(records);
							//UniAppManager.app.onQueryButtonDown();
							RefSearchWindow.hide();
						}
					},
					disabled: false
				},{
					itemId : 'refCloseBtn',
					text: '<t:message code="system.label.trade.close" default="닫기"/>',
					handler: function() {
						RefSearchWindow.hide();
					},
					disabled: false
				}],
				listeners : {
					beforehide: function(me, eOpt) {
						refSearch.clearForm();
						refMasterGrid.reset();
					},
					beforeclose: function( panel, eOpts ) {
						refSearch.clearForm();
						refMasterGrid.reset();
					},
					show: function( panel, eOpts ) {
						refSearch.setValues({
							'DIV_CODE':panelSearch.getValue('DIV_CODE'),
							'FR_DATE':UniDate.get('startOfMonth'),
							'TO_DATE':UniDate.get('today')
						});
						refMasterStore.loadStoreRecords();
					}
				}
			})
		}
		RefSearchWindow.center();
		RefSearchWindow.show();
	}
	//openRefSearchWindow end