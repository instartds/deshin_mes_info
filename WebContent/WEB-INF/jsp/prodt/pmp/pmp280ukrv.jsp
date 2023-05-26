<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="pmp280ukrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="pmp280ukrv" />	<!-- 사업장 -->
	<t:ExtComboStore comboType="OU" />		<!-- 창고-->
	<t:ExtComboStore comboType="WU" />		<!-- 작업장  -->
	<t:ExtComboStore comboType="AU" comboCode="B020" /><!-- 품목계정 -->
	<t:ExtComboStore comboType="AU" comboCode="B024" /><!-- 수불담당 -->
</t:appConfig>

<style type="text/css">
.x-change-cell {
background-color: #FFFFC6;
}
</style>

<script type="text/javascript" >

var searchPop1Window;	//팝업 윈도우1
var searchPop2Window;	//팝업 윈도우2
var lotNoList = null;
var firstLoadGubun = 'N';
function appMain() {
	
	var gsOutGubun = '${gsOutGubun}';
	
	var gubunStore = Unilite.createStore('gubunComboStore', {
        fields: ['text', 'value'],
        data :  [
            {'text':'<t:message code="system.label.purchase.confirm" default="확인"/>'  , 'value':'Y'},
            {'text':'<t:message code="system.label.purchase.notconfirm" default="미확인"/>'  , 'value':'N'}
        ]
    });

	var pop2Proxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy', {
		api: {
			read	: 'pmp280ukrvService.pop2SelectList',
			create	: 'pmp280ukrvService.insertPop2',
			update	: 'pmp280ukrvService.updatePop2',
//			destroy	: 'pmp280ukrvService.deleteDetail',
			syncAll	: 'pmp280ukrvService.savePop2'
		}
	});
	var pop1_2Proxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy', {
		api: {
			read	: 'pmp280ukrvService.pop1_2SelectList',
//			create	: 'pmp280ukrvService.insertPop2',
//			update	: 'pmp280ukrvService.updatePop2',
			destroy	: 'pmp280ukrvService.deletePop1_2',
			syncAll	: 'pmp280ukrvService.savePop1_2'
		}
	});
	Unilite.defineModel('detailModel', {
		fields: [
//			{name: 'AA1'			,text: '<t:message code="system.label.product.seq" default="순번"/>' 			,type: 'int'},
			{name: 'WKORD_NUM'			,text: '<t:message code="system.label.product.workorderno2" default="작지번호"/>' 			,type: 'string'},
			{name: 'WEEK_NUM'			,text: '<t:message code="system.label.product.planweeknum" default="계획주차"/>' 			,type: 'string'},
			{name: 'ITEM_CODE'			,text: '<t:message code="system.label.product.itemnum" default="품번"/>' 			,type: 'string'},
			{name: 'ITEM_NAME'			,text: '<t:message code="system.label.product.itemname2" default="품명"/>' 			,type: 'string'},
			{name: 'SPEC'			,text: '<t:message code="system.label.product.spec" default="규격"/>' 			,type: 'string'},
			{name: 'STOCK_UNIT'			,text: '<t:message code="system.label.product.unit" default="단위"/>' 			,type: 'string'},
			{name: 'WKORD_Q'			,text: '<t:message code="system.label.product.workqty" default="작업량"/>' 			,type: 'uniQty'},
			{name: 'ITEM_ACCOUNT'			,text: '<t:message code="system.label.product.itemaccount" default="품목계정"/>' 			,type: 'string',comboType:'AU', comboCode:'B020' },
			{name: 'LOT_NO'			,text: 'LOT NO'			,type: 'string'},
			{name: 'GUBUN'			,text: '칭량상태' 			,type: 'string'},
			{name: 'PMR_STATUS'		,text: '제조실적상태' 			,type: 'string'},

			{name: 'PRODT_WKORD_DATE'			,text: 'PRODT_WKORD_DATE'			,type: 'string'}

		]
	});

	var detailStore = Unilite.createStore('detailStore',{
		model: 'detailModel',
		proxy: {
			type: 'direct',
			api: {
				read: 'pmp280ukrvService.selectList'
			}
		},
		autoLoad: false,
		uniOpt: {
			isMaster: true,	// 상위 버튼 연결
			editable: false,		// 수정 모드 사용
			deletable: false,		// 삭제 가능 여부
			useNavi: false		// prev | next 버튼 사용
		},
		loadStoreRecords : function()	{
			var param= panelSearch.getValues();
			this.load(
				{params : param,
					callback : function(records, operation, success) {
						if(success)	{
							if(!Ext.isEmpty(panelSearch.getValue('WKORD_NUM'))) {
								if(Ext.isEmpty(records)) {
									beep();
									Unilite.messageBox('<t:message code="system.message.inventory.message013" default="해당자료가 없습니다."/>');
									panelSearch.setValue('WKORD_NUM', '');
	//									return false;
								}else{
									openSearchPop1Window();
								}
							}
						}
					}
				}
			);
		}
		/*saveStore : function(config)	{
			var inValidRecs = this.getInvalidRecords();
			if(inValidRecs.length == 0 ) {
				config = {
					success: function(batch, option) {
						detailStore.loadStoreRecords();
					}
				};
				this.syncAllDirect(config);

			} else {
				detailGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},

		listeners: {
			update:function( store, record, operation, modifiedFieldNames, eOpts ) {
			},
			metachange:function( store, meta, eOpts ){
			}
		}*/
	});

	var detailGrid = Unilite.createGrid('detailGrid', {
		store: detailStore,
		region: 'center',
		layout: 'fit',
		uniOpt: {
			expandLastColumn: true,
			useLiveSearch: false,
			useContextMenu: false,
			useMultipleSorting: false,
			useGroupSummary: false,
			useRowNumberer: true,
			onLoadSelectFirst: true,
			filter: {
				useFilter: false,
				autoCreate: false
			},
			state: {
				useState: false,
				useStateList: false
			}
		},
		selModel: 'rowmodel',
		columns: [
//			{ dataIndex: 'AA1'					, width: 100},
			{ dataIndex: 'WKORD_NUM'			, width: 160},
			{ dataIndex: 'WEEK_NUM'				, width: 100},
			{ dataIndex: 'ITEM_CODE'			, width: 120},
			{ dataIndex: 'ITEM_NAME'			, width: 300},
			{ dataIndex: 'SPEC'					, width: 100},
			{ dataIndex: 'STOCK_UNIT'			, width: 100,align:'center'},
			{ dataIndex: 'WKORD_Q'				, width: 150},
			{ dataIndex: 'ITEM_ACCOUNT'			, width: 100,align:'center'},
			{ dataIndex: 'LOT_NO'				, width: 100},
			{ dataIndex: 'GUBUN'				, width: 100,align:'center'},
			{ dataIndex: 'PMR_STATUS'			, width: 140,align:'center'}
		],
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
				panelSearch.setValue('WKORD_NUM', '');
				openSearchPop1Window();
			}
		}
		/*listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				if (UniUtils.indexOf(e.field, ['WKORD_NUM'])) {
					return true;
				} else {
					return false;
				}
			}
		}*/
	});
	var panelSearch = Unilite.createSearchForm('panelSearch', {
		region:'north',
		layout: {type : 'uniTable', columns : 4},
		padding: '1 1 1 1',
		border: true,
//		defaults:{
//			labelWidth:140,
//			width:375
//		},
		items: [{
			fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
			name: 'DIV_CODE',
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			allowBlank: false
		},{
			fieldLabel:'<t:message code="system.label.product.workorderno" default="작업지시번호"/>',
			name:'WKORD_NUM',
			xtype:'uniTextfield',
			listeners: {
				specialkey:function(field, event)	{
					if(event.getKey() == event.ENTER) {
						var newValue = panelSearch.getValue('WKORD_NUM');
						if(!Ext.isEmpty(newValue)) {
							detailStore.loadStoreRecords();
//							setTimeout( function() {
//								var record = detailGrid.getSelectedRecord();
//								if(Ext.isEmpty(record)) {
//									beep();
//									Ext.Msg.alert('확인','<t:message code="system.message.inventory.message013" default="해당자료가 없습니다."/>');
//									panelSearch.setValue('WKORD_NUM', '');
////									return false;
//								}else{
//									openSearchPop1Window();
//								}
//			   				}, 500 );
						}
					}
				}
			}
		},{
			fieldLabel: '수불담당자',
//			margin: '0 0 0 -100',
			name: 'INOUT_PRSN',
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'B024',
			allowBlank:false
		},{
			xtype: 'radiogroup',
			fieldLabel: '<t:message code="system.label.product.selectprinter" default="프린터 선택"/>',
			id:'selectPrinterchk',
//			margin: '0 0 0 -60',
//			labelWidth: 100,
			items: [{
				boxLabel: 'TOSHIBA(소)',
				width: 100,
				name: 'SELPRINTER',
				inputValue: 'TOSHIBA',
				checked: true
			},{
				boxLabel : 'ZEBRA(대)',
				width: 100,
				name: 'SELPRINTER',
				inputValue: 'ZEBRA'
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					/* if(newValue.REWORK_YN =='Y'){

						panelResult.getField('EXCHG_TYPE').setReadOnly( false );
						panelResult.setValue('EXCHG_TYPE', "B");

					}else if(newValue.REWORK_YN =='N'){

						panelResult.setValue('EXCHG_TYPE', "");
						panelResult.getField('EXCHG_TYPE').setReadOnly( true );
					} */
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>',
			name: 'ITEM_ACCOUNT',
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'B020'
		},{
			fieldLabel: '<t:message code="system.label.product.workorderdate" default="작업지시일"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'PRODT_WKORD_DATE_FR',
			endFieldName: 'PRODT_WKORD_DATE_TO',
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today')
//			startDateFieldWidth : 150,
//			endDateFieldWidth:150,
//			width: 475
		},{
			xtype: 'radiogroup',
			fieldLabel: '칭량상태',
//			margin: '0 0 0 -60',
//			labelWidth: 100,
			items: [{
				boxLabel: '전체',
				width: 60,
				name: 'GUBUN',
				inputValue: ''
			},{
				boxLabel : '대기',
				width: 60,
				name: 'GUBUN',
				inputValue: 'B',
				checked: true
			},{
				boxLabel : '진행',
				width: 60,
				name: 'GUBUN',
				inputValue: 'C'
			},{
				boxLabel : '완료',
				width: 60,
				name: 'GUBUN',
				inputValue: 'D'
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					setTimeout( function() {
						UniAppManager.app.onQueryButtonDown();
	   				}, 50 );
				}
			}
		},{
			xtype: 'radiogroup',
			fieldLabel: '제조실적상태',
//			labelWidth: 180,
			items: [{
				boxLabel: '전체',
				width: 80,
				name: 'PMR_STATUS',
				inputValue: '',
				checked: true
			},{
				boxLabel : '미완료',
				width: 80,
				name: 'PMR_STATUS',
				inputValue: 'A'
			},{
				boxLabel : '완료',
				width: 80,
				name: 'PMR_STATUS',
				inputValue: 'B'
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					setTimeout( function() {
						UniAppManager.app.onQueryButtonDown();
	   				}, 50 );
				}
			}
		}
		]
	});

	var pop1Search = Unilite.createSearchForm('pop1SearchForm', {
		layout: {
			type: 'uniTable',
			columns: 3
		},
		padding: '1 1 1 1',
		border: true,
//		trackResetOnLoad: true,
		defaults: {readOnly:true, labelWidth:115,width:280},
		items: [{
			fieldLabel:'<t:message code="system.label.product.workorderno" default="작업지시번호"/>',
			name:'WKORD_NUM',
			xtype:'uniTextfield'
		},{
	        fieldLabel: '<t:message code="system.label.product.workorderdate" default="작업지시일"/>',
	        name: 'PRODT_WKORD_DATE',
	        xtype: 'uniDatefield'
		},{
			fieldLabel:'<t:message code="system.label.product.scancode" default="스캔코드"/>',
			name:'SCAN_CODE',
			xtype:'uniTextfield',
			readOnly:false,
			listeners: {
				specialkey:function(field, event)	{
					if(event.getKey() == event.ENTER) {
						var newValue = pop1Search.getValue('SCAN_CODE');
						if(!Ext.isEmpty(newValue)) {
							var records = pop1Store.data.items;
							var cnt = 0;

							var scanCodeSplit = pop1Search.getValue('SCAN_CODE').split('$');

							Ext.each(records,function(record, index){
								if(record.get('ITEM_CODE') == scanCodeSplit[0]){
									cnt = cnt + 1;

									pop2Search.setValue('ITEM_CODE',record.get('ITEM_CODE'));
									pop2Search.setValue('ITEM_NAME',record.get('ITEM_NAME'));
									pop2Search.setValue('SPEC',record.get('SPEC'));
									pop2Search.setValue('OUTSTOCK_REQ_Q',record.get('OUTSTOCK_REQ_Q'));
									pop2Search.setValue('WH_CODE',record.get('WH_CODE'));

									pop2Search.setValue('PMP200T_WH_CODE',record.get('PMP200T_WH_CODE'));

									pop2Search.setValue('WORK_SHOP_CODE',record.get('WORK_SHOP_CODE'));
									pop2Search.setValue('OUTSTOCK_NUM',record.get('OUTSTOCK_NUM'));
									pop2Search.setValue('REF_WKORD_NUM',record.get('REF_WKORD_NUM'));
									pop2Search.setValue('PATH_CODE',record.get('PATH_CODE'));

									pop2Search.setValue('OUTSTOCK_JAN_Q',record.get('OUTSTOCK_JAN_Q'));
									pop2Search.setValue('INOUT_Q',record.get('OUTSTOCK_JAN_Q'));
								}
							});

							if(cnt > 0){
								openSearchPop2Window();
							}else{
								beep();
								Unilite.messageBox('<t:message code="system.message.inventory.message013" default="해당자료가 없습니다."/>');
								panelSearch.setValue('SCAN_CODE', '');

							}

//							detailStore.loadStoreRecords();
//							setTimeout( function() {
//								var record = detailGrid.getSelectedRecord();
//								if(Ext.isEmpty(record)) {
//									beep();
//									Ext.Msg.alert('확인','<t:message code="system.message.inventory.message013" default="해당자료가 없습니다."/>');
//									panelSearch.setValue('WKORD_NUM', '');
////									return false;
//								}else{
//									openSearchPop1Window();
//								}
//			   				}, 500 );
						}
					}
				}
			}
		},{
			fieldLabel:'<t:message code="system.label.product.makeitem" default="제조품목"/>',
			name:'ITEM_CODE',
			xtype:'uniTextfield'
		},{
			fieldLabel: '<t:message code="system.label.product.workorderqty" default="작업지시량"/>',
			xtype: 'uniNumberfield',
			name: 'WKORD_Q'
		},{
			fieldLabel:'<t:message code="system.label.product.unit" default="단위"/>',
			name:'STOCK_UNIT',
			xtype:'uniTextfield'
//			xtype:'uniCombobox',
//			comboType: 'AU',
//			comboCode:'B013'
		},{
			fieldLabel:'<t:message code="system.label.product.itemname2" default="품명"/>',
			name:'ITEM_NAME',
			xtype:'uniTextfield',
			colspan:2,
			width:560
		},{
	        fieldLabel: '출고일자',
	        name: 'INOUT_DATE_2',
	        xtype: 'uniDatefield',
			value: UniDate.get('today'),
			readOnly:false
		}]
	});


	Unilite.defineModel('pop1Model', {
		fields: [
			{ name: 'SEQ'		,text:'<t:message code="system.label.product.seq" default="순번"/>'	,type: 'int'},
			{ name: 'ITEM_CODE'		,text:'<t:message code="system.label.product.itemnum" default="품번"/>'	,type: 'string'},
			{ name: 'ITEM_NAME'		,text:'<t:message code="system.label.product.itemname2" default="품명"/>'	,type: 'string'},
			{ name: 'SPEC'		,text:'<t:message code="system.label.product.spec" default="규격"/>'	,type: 'string'},
			{ name: 'STOCK_UNIT'		,text:'<t:message code="system.label.product.unit" default="단위"/>'	,type: 'string'},
			{ name: 'OUTSTOCK_REQ_Q'		,text:'<t:message code="system.label.product.realrequiredqty" default="실소요량"/>'	,type : 'float', decimalPrecision: 3, format:'0,000.000'},
			{ name: 'STOCK_Q'		,text:'<t:message code="system.label.product.onhandstock" default="현재고"/>'	,type : 'float', decimalPrecision: 3, format:'0,000.000'},
			{ name: 'LOCATION'		,text:'<t:message code="system.label.product.stockplace" default="재고위치"/>'	,type: 'string'},
			{ name: 'WH_CODE'		,text:'WH_CODE'	,type: 'string'},

			{ name: 'PMP200T_WH_CODE'		,text:'PMP200T_WH_CODE'	,type: 'string'},

			{ name: 'WORK_SHOP_CODE'		,text:'WORK_SHOP_CODE'	,type: 'string'},
			{ name: 'OUTSTOCK_NUM'		,text:'OUTSTOCK_NUM'	,type: 'string'},
			{ name: 'REF_WKORD_NUM'		,text:'REF_WKORD_NUM'	,type: 'string'},
			{ name: 'PATH_CODE'   		,text:'PATH_CODE'	,type: 'string'},
			{ name: 'OUTSTOCK_JAN_Q'		,text:'OUTSTOCK_JAN_Q'	,type : 'float', decimalPrecision: 3, format:'0,000.000'}

		]
	});

	var pop1Store = Unilite.createStore('pop1Store', {
		model: 'pop1Model',
		autoLoad: false,
		uniOpt: {
			isMaster: false,	// 상위 버튼 연결
			editable: false,	// 수정 모드 사용
			deletable: false,	// 삭제 가능 여부
			useNavi: false		// prev | newxt 버튼 사용
		},
		proxy: {
			type: 'direct',
			api: {
				read: 'pmp280ukrvService.pop1SelectList'
			}
		},
		loadStoreRecords: function() {
			var param = panelSearch.getValues();
			if(Ext.isEmpty(gsOutGubun)){
				param.OUT_GUBUN = '1';
			}else{
				param.OUT_GUBUN = gsOutGubun;
			}
			if(Ext.isEmpty(panelSearch.getValue('WKORD_NUM'))){
				var selectMainRecord = detailGrid.getSelectedRecord();
				param.WKORD_NUM = selectMainRecord.get('WKORD_NUM');
			}
			this.load({
				params: param
			});
		},
		listeners:{
			load:function(store, records, successful, eOpts)	{
			}
		}
	});

	var pop1Grid = Unilite.createGrid('pop1Grid', {
		store: pop1Store,
		layout: 'fit',
		uniOpt: {
			expandLastColumn: false,
			useLiveSearch: false,
			useContextMenu: false,
			useMultipleSorting: false,
			useGroupSummary: false,
			onLoadSelectFirst: false,
			useRowNumberer: true,
			filter: {
				useFilter: false,
				autoCreate: false
			},
			state: {
				useState: false,
				useStateList: false
			},
			useLoadFocus:false
		},
		selModel: 'rowmodel',
		columns: [
			{ dataIndex: 'SEQ'	, width: 80,align:'center'},
			{ dataIndex: 'ITEM_CODE'	, width: 120},
			{ dataIndex: 'ITEM_NAME'	, width: 250},
			{ dataIndex: 'SPEC'	, width: 100},
			{ dataIndex: 'STOCK_UNIT'	, width: 70,align:'center'},
			{ dataIndex: 'OUTSTOCK_REQ_Q'	, width: 120},
			{ dataIndex: 'STOCK_Q'	, width: 120},
			{ dataIndex: 'LOCATION'	, width: 120}
		],
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
				panelSearch.setValue('SCAN_CODE', '');

				pop2Search.setValue('ITEM_CODE',record.get('ITEM_CODE'));
				pop2Search.setValue('ITEM_NAME',record.get('ITEM_NAME'));
				pop2Search.setValue('SPEC',record.get('SPEC'));
				pop2Search.setValue('OUTSTOCK_REQ_Q',record.get('OUTSTOCK_REQ_Q'));
				pop2Search.setValue('WH_CODE',record.get('WH_CODE'));

				pop2Search.setValue('PMP200T_WH_CODE',record.get('PMP200T_WH_CODE'));

				pop2Search.setValue('WORK_SHOP_CODE',record.get('WORK_SHOP_CODE'));
				pop2Search.setValue('OUTSTOCK_NUM',record.get('OUTSTOCK_NUM'));
				pop2Search.setValue('REF_WKORD_NUM',record.get('REF_WKORD_NUM'));
				pop2Search.setValue('PATH_CODE',record.get('PATH_CODE'));

				pop2Search.setValue('PROD_ITEM_NAME',pop1Search.getValue('ITEM_NAME'));
				pop2Search.setValue('WKORD_NUM',pop1Search.getValue('WKORD_NUM'));
				pop2Search.setValue('STOCK_UNIT',pop1Search.getValue('STOCK_UNIT'));



				pop2Search.setValue('OUTSTOCK_JAN_Q',record.get('OUTSTOCK_JAN_Q'));
				pop2Search.setValue('INOUT_Q',record.get('OUTSTOCK_JAN_Q'));

				openSearchPop2Window();
			}
		}
	});

	Unilite.defineModel('pop1_2Model', {
		fields: [
			{ name: 'SEQ'		,text:'<t:message code="system.label.product.seq" default="순번"/>'	,type: 'int'},
			{ name: 'ITEM_CODE'		,text:'<t:message code="system.label.product.itemnum" default="품번"/>'	,type: 'string'},
			{ name: 'ITEM_NAME'		,text:'<t:message code="system.label.product.itemname2" default="품명"/>'	,type: 'string'},
			{ name: 'SPEC'		,text:'<t:message code="system.label.product.spec" default="규격"/>'	,type: 'string'},
			{ name: 'STOCK_UNIT'		,text:'<t:message code="system.label.product.unit" default="단위"/>'	,type: 'string'},
			{ name: 'OUTSTOCK_REQ_Q'		,text:'<t:message code="system.label.product.realrequiredqty" default="실소요량"/>'	,type : 'float', decimalPrecision: 3, format:'0,000.000'},
			{ name: 'INOUT_Q'		,text:'출고량'	,type : 'float', decimalPrecision: 3, format:'0,000.000'},
			{ name: 'LOCATION'		,text:'<t:message code="system.label.product.stockplace" default="재고위치"/>'	,type: 'string'},
			{ name: 'INOUT_NUM'		,text:'INOUT_NUM'	,type: 'string'},
			{ name: 'INOUT_SEQ'		,text:'INOUT_SEQ'	,type: 'string'},
			{ name: 'OUTSTOCK_NUM'		,text:'OUTSTOCK_NUM'	,type: 'string'},
			{ name: 'REF_WKORD_NUM'		,text:'REF_WKORD_NUM'	,type: 'string'},
			{ name: 'PATH_CODE'   		,text:'PATH_CODE'	,type: 'string'},
			{ name: 'LOT_NO'   		,text:'LOT NO'	,type: 'string'}
		]
	});

	var pop1_2Store = Unilite.createStore('pop1_2Store', {
		model: 'pop1_2Model',
		autoLoad: false,
		uniOpt: {
			isMaster: false,	// 상위 버튼 연결
			editable: false,	// 수정 모드 사용
			deletable: false,	// 삭제 가능 여부
			useNavi: false		// prev | newxt 버튼 사용
		},
		proxy: pop1_2Proxy,
		saveStore : function(config)	{
			var inValidRecs = this.getInvalidRecords();
			if(inValidRecs.length == 0 ) {
				config = {
					success: function(batch, option) {
						pop1Store.loadStoreRecords();
						pop1_2Store.loadStoreRecords();

                    	Ext.getCmp('pop1Page').getEl().unmask();

					},
					failure: function(form, action){
                    	Ext.getCmp('pop1Page').getEl().unmask();
						pop1_2Store.loadStoreRecords();
					}
				};
				this.syncAllDirect(config);

			} else {
				pop1_2Grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		loadStoreRecords: function() {
			var param = panelSearch.getValues();
			if(Ext.isEmpty(panelSearch.getValue('WKORD_NUM'))){
				var selectMainRecord = detailGrid.getSelectedRecord();
				param.WKORD_NUM = selectMainRecord.get('WKORD_NUM');
			}
			this.load({
				params: param
			});
		},
		listeners:{
			load:function(store, records, successful, eOpts)	{
			}
		}
	});

	var pop1_2Grid = Unilite.createGrid('pop1_2Grid', {
		store: pop1_2Store,
		layout: 'fit',
		uniOpt: {
			expandLastColumn: false,
			useLiveSearch: false,
			useContextMenu: false,
			useMultipleSorting: false,
			useGroupSummary: false,
			onLoadSelectFirst:false,
			useRowNumberer: true,
			filter: {
				useFilter: false,
				autoCreate: false
			},
			state: {
				useState: false,
				useStateList: false
			},
			useLoadFocus:false
		},
		tbar:  ['->',{
			itemId : 'deleteBtn',
			text: '선택삭제',
			handler: function() {
				var selectedRecord = pop1_2Grid.getSelectedRecord();

				if(Ext.isEmpty(selectedRecord)){
					Unilite.messageBox('선택된 데이터가 없습니다.');
					return false;
				}

				var selRow = pop1_2Grid.getSelectedRecord();
				if(confirm('선택된 행을 삭제 합니다. 삭제 하시겠습니까?')) {

                	Ext.getCmp('pop1Page').getEl().mask('저장 중...','loading-indicator');
					pop1_2Grid.deleteSelectedRow();
					pop1_2Store.saveStore();
				}
			}
		}],
		selModel :	Ext.create('Ext.selection.CheckboxModel', { checkOnly : false, toggleOnClick:false }),
		columns: [
			{ dataIndex: 'SEQ'	, width: 80,align:'center'},
			{ dataIndex: 'ITEM_CODE'	, width: 120},
			{ dataIndex: 'ITEM_NAME'	, width: 250},
			{ dataIndex: 'SPEC'	, width: 100},
			{ dataIndex: 'STOCK_UNIT'	, width: 70,align:'center'},
			{ dataIndex: 'OUTSTOCK_REQ_Q'	, width: 120},
			{ dataIndex: 'INOUT_Q'	, width: 120},
			{ dataIndex: 'LOCATION'	, width: 120},
			{ dataIndex: 'LOT_NO'	, width: 120}
		],
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
				if(confirm('<t:message code="system.message.purchase.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {

					pop1_2Grid.deleteSelectedRow();
					pop1_2Store.saveStore();
				}
			}
		}
	});

	 var tab = Unilite.createTabPanel('tabPanel',{
	    activeTab: 0,
	    region: 'center',
	    items: [{
	    	title: '미출고현황',
	    	xtype:'container',
	    	layout:{type:'vbox', align:'stretch'},
	    	items:[pop1Grid],
	    	id: 'tab1'
	    },{
	    	title: '출고현황',
	    	xtype:'container',
	    	layout:{type:'vbox', align:'stretch'},
	    	items:[pop1_2Grid],
	    	id: 'tab2'
	    }],
		listeners : {
			beforetabchange : function ( tabPanel, newCard, oldCard, eOpts )  {
//				if(!panelResult.getInvalidMessage()) return false;   // 필수체크
			},
			tabChange : function ( tabPanel, newCard, oldCard, eOpts )  {
				var newTabId = newCard.getId();

				if(newTabId == 'tab2'){
					pop1Search.getField('SCAN_CODE').setReadOnly(true);
				}else{
					pop1Search.getField('SCAN_CODE').setReadOnly(false);
				}
			}
	    }
	});


	function openSearchPop1Window() {
		if (!searchPop1Window) {
			searchPop1Window = Ext.create('widget.uniDetailWindow', {
				id: 'pop1Page',
				title: '팝업',
				width: 1000,
				height: 580,
				layout: {
					type: 'vbox',
					align: 'stretch'
				},
				items: [pop1Search, tab],
				tbar: ['->',{
					itemId: 'searchBtn',
					text: '<t:message code="system.label.product.inquiry" default="조회"/>',
					minWidth: 100,
					handler: function() {
						if(!pop1Search.getInvalidMessage()) return;	//필수체크
						pop1Store.loadStoreRecords();
						pop1_2Store.loadStoreRecords();
					},
					disabled: false
				},{
					itemId: 'closeBtn',
					text: '<t:message code="system.label.product.close" default="닫기"/>',
					minWidth: 100,
					handler: function() {
						searchPop1Window.hide();
					},
					disabled: false
				}],
				listeners: {
					beforehide: function(me, eOpt) {
						pop1Search.clearForm();
						pop1Grid.reset();
						pop1Store.clearData();
						pop1_2Grid.reset();
						pop1_2Store.clearData();
						panelSearch.setValue('WKORD_NUM', '');
					},
					beforeclose: function(panel, eOpts) {
					},
					beforeshow: function(panel, eOpts) {
						var selectedRecord = detailGrid.getSelectedRecord();

						pop1Search.setValue('WKORD_NUM',selectedRecord.get('WKORD_NUM'));
						pop1Search.setValue('PRODT_WKORD_DATE',selectedRecord.get('PRODT_WKORD_DATE'));
						pop1Search.setValue('ITEM_CODE',selectedRecord.get('ITEM_CODE'));
						pop1Search.setValue('WKORD_Q',selectedRecord.get('WKORD_Q'));
						pop1Search.setValue('STOCK_UNIT',selectedRecord.get('STOCK_UNIT'));
						pop1Search.setValue('ITEM_NAME',selectedRecord.get('ITEM_NAME'));

						pop1Search.setValue('INOUT_DATE_2',UniDate.get('today'));
					},
					show: function(panel, eOpts) {
						pop1Store.loadStoreRecords();
						pop1_2Store.loadStoreRecords();

						setTimeout( function() {
							pop1Search.getField('SCAN_CODE').focus();
						}, 50 );
					}
				}
			})
		}
		searchPop1Window.center();
		searchPop1Window.show();
	}

	var pop2Search = Unilite.createSearchForm('pop2SearchForm', {
		layout: {
			type: 'uniTable',
			columns: 3
		},
		defaults: {readOnly:true},
		padding: '1 1 1 1',
		border: true,
//		trackResetOnLoad: true,
		items: [{
			xtype: 'container',
			layout: { type: 'uniTable', columns: 4},
			defaultType: 'uniTextfield',
			defaults : {readOnly:true},
			colspan:3,
			items:[{
				fieldLabel:'<t:message code="system.label.product.issueitemnum" default="출고품번"/>',
				name:'ITEM_CODE',
				xtype:'uniTextfield'
			},{
				name:'ITEM_NAME',
				xtype:'uniTextfield',
				width:250
			},{
				name:'SPEC',
				xtype:'uniTextfield',
				width:100
			},{
				name:'WH_CODE',
				xtype:'uniTextfield',
				hidden:true
			},{
				xtype: 'radiogroup',
				fieldLabel: '칭량방법',
				items: [{
					boxLabel: '수동' , width: 80, name: 'TYPE_AB', inputValue: 'A', checked: true
				}, {
					boxLabel: '자동' , width: 80, name: 'TYPE_AB', inputValue: 'B'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						if(newValue.TYPE_AB == 'A'){
							pop2Search.setValue('INOUT_Q', pop2Search.getValue('JAN_OUTSTOCK_REQ_Q'));
							var selectedRecord = pop2Grid.getSelectedRecord();
							if(!Ext.isEmpty(selectedRecord)){

								selectedRecord.set('INOUT_Q',pop2Search.getValue('JAN_OUTSTOCK_REQ_Q'));
							}
						}else{
							//로직 보류
						}
					}
				}
			}]
		},{
			fieldLabel: '<t:message code="system.label.product.realrequiredqty" default="실소요량"/>',
			xtype: 'uniNumberfield',
			name: 'OUTSTOCK_REQ_Q',
			decimalPrecision: 3,
			format:'0,000.000'
		},{
			fieldLabel: '출고후<br>소요량잔량',
			xtype: 'uniNumberfield',
			name: 'JAN_OUTSTOCK_REQ_Q',
			decimalPrecision: 3,
			format:'0,000.000'
		},{
			fieldLabel: 'LOT NO',
			xtype: 'uniTextfield',
			name: 'LOT_NO',
			readOnly:true,
			allowBlank:false,
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
					var selectedRecord = pop2Grid.getSelectedRecord();
					selectedRecord.set('LOT_NO',newValue);
				}
			}

		},{
			fieldLabel: '<t:message code="system.label.product.issueqty" default="출고량"/>',
			xtype: 'uniNumberfield',
			name: 'INOUT_Q',
			readOnly:false,
			allowBlank:false,
			decimalPrecision: 3,
			format:'0,000.000',
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
					var selectedRecord = pop2Grid.getSelectedRecord();
					selectedRecord.set('INOUT_Q',newValue);
					selectedRecord.set('JAN_Q',selectedRecord.get('STOCK_Q') - newValue);
					pop2Search.setValue('JAN_Q',selectedRecord.get('STOCK_Q') - newValue);
				}
			}

		},{
			fieldLabel: '<t:message code="system.label.product.printq" default="인쇄수량"/>',
			xtype: 'uniNumberfield',
			name: 'PRINT_Q',
			readOnly:false
		},{

			xtype: 'container',
			layout: {type : 'table', columns : 1},
			tdAttrs: {align: 'right'},
			width:150,
	    	items:[{
				fieldLabel	: '바코드출력',
				xtype		: 'uniCheckboxgroup',
				items		: [{
					boxLabel: '',
					width	: 90,
					name	: 'PRINT_YN',
					checked	: true
				}]
			}

	    				/*{
	        	xtype:'button',
	        	text:'<t:message code="system.label.product.barcodeprint" default="바코드출력"/>',
	    		width: 100,
	        	handler:function(){
	        	}
	        }*/

	        ]



		},{
			name:'WORK_SHOP_CODE',
			xtype:'uniTextfield',
			hidden:true
		},{
			name:'OUTSTOCK_NUM',
			xtype:'uniTextfield',
			hidden:true
		},{
			name:'REF_WKORD_NUM',
			xtype:'uniTextfield',
			hidden:true
		},{
			name:'PATH_CODE',
			xtype:'uniTextfield',
			hidden:true
		},{
			fieldLabel:'PROD_ITEM_NAME',
			name:'PROD_ITEM_NAME',
			xtype:'uniTextfield',
			hidden:true
		},{
			fieldLabel:'WKORD_NUM',
			name:'WKORD_NUM',
			xtype:'uniTextfield',
			hidden:true
		}/*,{
			fieldLabel:'INOUT_PRSN',
			name:'INOUT_PRSN',
			xtype:'uniTextfield',
			hidden:true
		}*/,{
			fieldLabel:'STOCK_UNIT',
			name:'STOCK_UNIT',
			xtype:'uniTextfield',
			hidden:true
		},{
			fieldLabel:'OUTSTOCK_JAN_Q',
			xtype: 'uniNumberfield',
			name: 'OUTSTOCK_JAN_Q',
			decimalPrecision: 3,
			format:'0,000.000',
			hidden:true
		},{
			name:'PMP200T_WH_CODE',
			xtype:'uniTextfield',
			hidden:true
		},{
			fieldLabel:'JAN_Q',
			xtype: 'uniNumberfield',
			name: 'JAN_Q',
			decimalPrecision: 3,
			format:'0,000.000',
			hidden:true
		}




		]
	});


	Unilite.defineModel('pop2Model', {
		fields: [
			{ name: 'DIV_CODE'   		,text:'DIV_CODE'	,type: 'string'},
			{ name: 'LOT_NO'   		,text:'LOT NO'	,type: 'string',allowBlank:false},
			{ name: 'INOUT_DATE_1'   		,text:'<t:message code="system.label.product.receiptdate2" default="입고일자"/>'	,type: 'uniDate'},
			{ name: 'INOUT_DATE_2'   		,text:'출고일자'	,type: 'uniDate',allowBlank:false},
			{ name: 'STOCK_Q'   		,text:'<t:message code="system.label.product.onhandstock" default="현재고"/>'	,type : 'float', decimalPrecision: 3, format:'0,000.000'},
			{ name: 'INOUT_Q'   		,text:'<t:message code="system.label.product.issueqty" default="출고량"/>'	,type : 'float', decimalPrecision: 3, format:'0,000.000',allowBlank:false},
			{ name: 'JAN_Q'   		,text:'<t:message code="system.label.product.issueqtybalanceqty" default="출고후 잔량"/>'	,type : 'float', decimalPrecision: 3, format:'0,000.000'},
			{ name: 'LOCATION'   		,text:'<t:message code="system.label.product.stockplace" default="재고위치"/>'	,type: 'string'},

			{ name: 'PATH_CODE'   		,text:'PATH_CODE'	,type: 'string'},
			{ name: 'WH_CODE'   		,text:'출고창고'	,type: 'string',comboType:'OU'},

			{ name: 'PMP200T_WH_CODE'   		,text:'PMP200T_WH_CODE'	,type: 'string'},

			{ name: 'WORK_SHOP_CODE'   		,text:'WORK_SHOP_CODE'	,type: 'string'},
			{ name: 'OUTSTOCK_NUM'   		,text:'OUTSTOCK_NUM'	,type: 'string'},
			{ name: 'REF_WKORD_NUM'   		,text:'REF_WKORD_NUM'	,type: 'string'}





		]
	});

	var pop2Store = Unilite.createStore('pop2Store', {
		model: 'pop2Model',
		autoLoad: false,
		uniOpt: {
			isMaster: false,	// 상위 버튼 연결
			editable: true,	// 수정 모드 사용
			deletable: false,	// 삭제 가능 여부
			useNavi: false		// prev | newxt 버튼 사용
		},
		proxy: pop2Proxy,
		loadStoreRecords: function() {
//			var params = Ext.merge(pop2Search.getValues(), panelSearch.getValues());

			var param = panelSearch.getValues();

//			param.INOUT_PRSN = pop2Search.getValue('INOUT_PRSN');
			param.WORK_SHOP_CODE = pop2Search.getValue('WORK_SHOP_CODE');
			param.OUTSTOCK_NUM = pop2Search.getValue('OUTSTOCK_NUM');
			param.REF_WKORD_NUM = pop2Search.getValue('REF_WKORD_NUM');
			param.PATH_CODE = pop2Search.getValue('PATH_CODE');//selectPop1Record.get('PATH_CODE');

			param.ITEM_CODE = pop2Search.getValue('ITEM_CODE');

			param.OUTSTOCK_REQ_Q = pop2Search.getValue('OUTSTOCK_REQ_Q');

			param.PMP200T_WH_CODE = pop2Search.getValue('PMP200T_WH_CODE');

			if(Ext.isEmpty(pop1Search.getValue('SCAN_CODE'))){
				var selectPop1Record = pop1Grid.getSelectedRecord();
//				param.ITEM_CODE = selectPop1Record.get('ITEM_CODE');
				param.LOT_NO = '';

			}else{
				var scanCodeSplit = pop1Search.getValue('SCAN_CODE').split('$');
//				param.ITEM_CODE = scanCodeSplit[0];
				param.LOT_NO = scanCodeSplit[1];

//				var selectPop1Record = pop1Grid.getSelectedRecord();
////				pop2Search.setValue('OUTSTOCK_JAN_Q',selectPop1Record.get('OUTSTOCK_JAN_Q'));
//				pop2Search.setValue('INOUT_Q',selectPop1Record.get('OUTSTOCK_JAN_Q'));
			}
			var lotNo = param.LOT_NO;

			this.load({
				params : param,
				callback : function(records, operation, success) {
					if(success)	{
						if(Ext.isEmpty(records)) {
							var r = {
								DIV_CODE: panelSearch.getValue('DIV_CODE'),
								ITEM_CODE: pop2Search.getValue('ITEM_CODE'),
								WH_CODE: pop2Search.getValue('WH_CODE'),

								PMP200T_WH_CODE: pop2Search.getValue('PMP200T_WH_CODE'),

								INOUT_DATE_2 : UniDate.getDbDateStr(UniDate.get('today')),
								LOT_NO: lotNo,
								WORK_SHOP_CODE: pop2Search.getValue('WORK_SHOP_CODE'),
								OUTSTOCK_NUM: pop2Search.getValue('OUTSTOCK_NUM'),
								REF_WKORD_NUM: pop2Search.getValue('REF_WKORD_NUM'),
								PATH_CODE: pop2Search.getValue('PATH_CODE')

							}
							pop2Grid.createRow(r);


						}else{

							var selectedRecord = pop2Grid.getSelectedRecord();
//							selectedRecord.set('INOUT_Q',pop2Search.getValue('OUTSTOCK_JAN_Q'));
							if(firstLoadGubun == 'Y'){
								lotNoList = new Array();
								Ext.each(records, function(record, idx) {
							   		lotNoList.push(record.get('LOT_NO'));
								});
							}
							var param = {
								DIV_CODE: panelSearch.getValue('DIV_CODE'),
								WKORD_NUM: pop1Search.getValue('WKORD_NUM'),
								OUTSTOCK_REQ_Q: pop2Search.getValue('OUTSTOCK_REQ_Q'),
								PATH_CODE: pop2Search.getValue('PATH_CODE'),
								ITEM_CODE: pop2Search.getValue('ITEM_CODE'),
								lotNoList: lotNoList
							};
			  				pmp280ukrvService.getJanOutstockReqQ(param, function(provider, response) {
			  					if(!Ext.isEmpty(provider)) {
									pop2Search.setValue('JAN_OUTSTOCK_REQ_Q', provider.JAN_OUTSTOCK_REQ_Q);
									pop2Search.setValue('INOUT_Q',provider.JAN_OUTSTOCK_REQ_Q);
									selectedRecord.set('INOUT_Q',provider.JAN_OUTSTOCK_REQ_Q);

									selectedRecord.set('JAN_Q', selectedRecord.get('STOCK_Q') - pop2Search.getValue('INOUT_Q'));
									pop2Search.setValue('JAN_Q', selectedRecord.get('STOCK_Q') - pop2Search.getValue('INOUT_Q'));

			  					}else{
									pop2Search.setValue('JAN_OUTSTOCK_REQ_Q', 0);
									pop2Search.setValue('INOUT_Q',0);
									selectedRecord.set('INOUT_Q',0);

									selectedRecord.set('JAN_Q', selectedRecord.get('STOCK_Q') - pop2Search.getValue('INOUT_Q'));
									pop2Search.setValue('JAN_Q', selectedRecord.get('STOCK_Q') - pop2Search.getValue('INOUT_Q'));
			  					}
			  				});
			  				firstLoadGubun = 'N';
						}
					}
				}
			});
		},
		saveStore : function(config)	{
			var inValidRecs = this.getInvalidRecords();
			if(inValidRecs.length == 0 ) {
				config = {
					success: function(batch, option) {
//                        Ext.getCmp('pageAll').getEl().unmask();

						pop1Store.loadStoreRecords();
						pop1_2Store.loadStoreRecords();
						pop2Store.loadStoreRecords();
						if(pop2Search.getValue('PRINT_YN') == true){
							UniAppManager.app.onPrintButtonDown();
						}
                    	Ext.getCmp('pop2Page').getEl().unmask();

//						searchPop2Window.hide();
					},
					failure: function(form, action){
                    	Ext.getCmp('pop2Page').getEl().unmask();
					}
				};
				this.syncAllDirect(config);

			} else {
				pop2Grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners:{
			load:function(store, records, successful, eOpts)	{
			}
		}
	});

	var pop2Grid = Unilite.createGrid('pop2Grid', {
		store: pop2Store,
		layout: 'fit',
		uniOpt: {
			expandLastColumn: false,
			useLiveSearch: false,
			useContextMenu: false,
			useMultipleSorting: false,
			useGroupSummary: false,
			onLoadSelectFirst: true,
			useRowNumberer: true,
			filter: {
				useFilter: false,
				autoCreate: false
			},
			state: {
				useState: false,
				useStateList: false
			},
			useLoadFocus:false
		},
		selModel :	Ext.create('Ext.selection.CheckboxModel', { checkOnly : false, mode:'SINGLE',toggleOnClick:false }),
		columns: [
			{ dataIndex: 'WH_CODE'	, width: 160},
			{ dataIndex: 'LOT_NO'	, width: 120},
			{ dataIndex: 'INOUT_DATE_1'	, width: 110},
			{ dataIndex: 'INOUT_DATE_2'	, width: 110},
			{ dataIndex: 'STOCK_Q'	, width: 130},
			{ dataIndex: 'INOUT_Q'	, width: 130},
			{ dataIndex: 'JAN_Q'	, width: 130},
			{ dataIndex: 'LOCATION'	, width: 150},

			{ dataIndex: 'PMP200T_WH_CODE'	, width: 100,hidden:true}
//			{ dataIndex: 'WORK_SHOP_CODE'	, width: 100},
//			{ dataIndex: 'OUTSTOCK_NUM'	, width: 100},
//			{ dataIndex: 'REF_WKORD_NUM'	, width: 100}
//			,{ dataIndex: 'PATH_CODE'	, width: 100}


		],
		listeners:{

			selectionchange:function( model1, selected, eOpts ){
				if(selected.length > 0){
					pop2Search.setValue('LOT_NO',selected[0].get('LOT_NO'));
//					pop2Search.setValue('INOUT_Q',selected[0].get('INOUT_Q'));

					setTimeout( function() {
//						var selectedRecord = pop2Grid.getSelectedRecord();
						var pop2AllRec = pop2Store.data.items;

						Ext.each(pop2AllRec,function(pop2Rec, index){
							pop2Rec.set('INOUT_Q',0);
							pop2Rec.set('JAN_Q',pop2Rec.get('STOCK_Q'));

							pop2Rec.set('INOUT_DATE_2',pop1Search.getValue('INOUT_DATE_2'));
							pop2Rec.commit();
						});

						selected[0].set('INOUT_Q',pop2Search.getValue('INOUT_Q'));

						selected[0].set('JAN_Q', selected[0].get('STOCK_Q') - pop2Search.getValue('INOUT_Q'));


						pop2Search.setValue('JAN_Q',selected[0].get('STOCK_Q') - pop2Search.getValue('INOUT_Q'));
						pop2Search.setValue('WH_CODE',selected[0].get('WH_CODE'));

					}, 50 );
				}
			},

			beforeedit  : function( editor, e, eOpts ) {
				if(UniUtils.indexOf(e.field, ['INOUT_DATE_2'])){
					return true;
				}else{
					return false;
				}
			}
		}
	/*	listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				if(UniUtils.indexOf(e.field, ['LOT_NO'])){
					return true;
				}else{
					return false;
				}
			}
		}*/
	});

	function openSearchPop2Window() {
		if (!searchPop2Window) {
			searchPop2Window = Ext.create('widget.uniDetailWindow', {
				id: 'pop2Page',
				title: '팝업',
				width: 1100,
				height: 580,
				layout: {
					type: 'vbox',
					align: 'stretch'
				},
				items: [pop2Search, pop2Grid],
				tbar: ['->',{
					itemId: 'searchBtn',
					text: '<t:message code="system.label.product.inquiry" default="조회"/>',
					minWidth: 100,
					handler: function() {
//						if(!pop2Search.getInvalidMessage()) return;	//필수체크
						pop2Store.loadStoreRecords();
					},
					disabled: false
				},{
					itemId: 'confirmBtn',
					text: '저장',
					minWidth:100,
					handler: function() {
						if(!pop2Search.getInvalidMessage()) return;	//필수체크
                		Ext.getCmp('pop2Page').getEl().mask('저장 중...','loading-indicator');
						pop2Store.saveStore();
					},
					disabled: false
				},{
					itemId: 'closeBtn',
					text: '<t:message code="system.label.product.close" default="닫기"/>',
					minWidth: 100,
					handler: function() {
						searchPop2Window.hide();
					},
					disabled: false
				}],
				listeners: {
					beforehide: function(me, eOpt) {
						pop2Search.clearForm();
						pop2Grid.reset();
						pop2Store.clearData();
						firstLoadGubun = 'N';
					},
					beforeclose: function(panel, eOpts) {
					},
					beforeshow: function(panel, eOpts) {
						pop2Search.setValue('PRINT_YN',true);
						pop2Search.setValue('PRINT_Q',1);
//						pop2Search.setValue('INOUT_PRSN',panelSearch.getValue('INOUT_PRSN'));
						pop2Search.getField('TYPE_AB').setValue('A');//수동

					},
					show: function(panel, eOpts) {
						firstLoadGubun = 'Y';

						pop1Search.setValue('SCAN_CODE','');
						pop2Store.loadStoreRecords();

						pop2Search.getField('INOUT_Q').focus();
					}
				}
			})
		}
		searchPop2Window.center();
		searchPop2Window.show();
	}


	Unilite.Main({
		id: 'pmp280ukrvApp',
		borderItems: [{
			id: 'pageAll',
			region: 'center',
			layout: 'border',
			border: false,
			items: [
				panelSearch, detailGrid
			]
		}],
		uniOpt:{showKeyText:false},
		fnInitBinding: function() {
			this.fnInitInputFields();

		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			detailGrid.reset();
			detailStore.clearData();
			this.fnInitInputFields();
		},
		onQueryButtonDown: function() {
            if(!panelSearch.getInvalidMessage()) return;   //필수체크
			panelSearch.getField('DIV_CODE').setReadOnly(true);
			panelSearch.getField('INOUT_PRSN').setReadOnly(true);
			detailStore.loadStoreRecords();
		},
		onSaveDataButtonDown: function(config) {
            if(!panelSearch.getInvalidMessage()) return;   //필수체크

			detailStore.saveStore();
		},
		fnInitInputFields: function(){
			panelSearch.setValue("DIV_CODE", UserInfo.divCode);

			panelSearch.setValue("PRODT_WKORD_DATE_FR", UniDate.get('startOfMonth'));
			panelSearch.setValue("PRODT_WKORD_DATE_TO", UniDate.get('today'));

			panelSearch.getField('DIV_CODE').setReadOnly(false);
			panelSearch.getField('INOUT_PRSN').setReadOnly(false);
			panelSearch.getField('SELPRINTER').setValue('TOSHIBA');
			UniAppManager.setToolbarButtons(['reset'], true);
			UniAppManager.setToolbarButtons(['print','newData','delete','save'], false);

			setTimeout( function() {
				panelSearch.getField('WKORD_NUM').focus();
			}, 50 );

		},
		onPrintButtonDown: function() {
			var pop2SelectR = pop2Grid.getSelectedRecord();
			
			var param = {
				//PROD_ITEM_NAME,ITEM_NAME 특문 관련 해서 쿼리에서 추출
				//'PROD_ITEM_NAME':pop2Search.getValue('PROD_ITEM_NAME'),	//제품명
				//'ITEM_NAME' :pop2Search.getValue('ITEM_NAME'), 	//원료명
				'ITEM_CODE' :pop2Search.getValue('ITEM_CODE'), 	//원료코드
				'WKORD_NUM' :pop2Search.getValue('WKORD_NUM'), 	//작지NO
				'LOT_NO' :pop2Search.getValue('LOT_NO'), //시험의뢰번호
				//'' :pop2Search.getValue(''), TIME 현재시간
				'INOUT_Q' :pop2Search.getValue('INOUT_Q'), 	//출고량  W / T
				'INOUT_PRSN' :panelSearch.getValue('INOUT_PRSN'),	//칭량자

				'STOCK_UNIT' :pop2Search.getValue('STOCK_UNIT'),	//단위

				'PRINT_Q' : pop2Search.getValue('PRINT_Q'), //인쇄수량

				'OUTSTOCK_REQ_Q' : pop2Search.getValue('OUTSTOCK_REQ_Q'),
				'JAN_Q' : pop2Search.getValue('JAN_Q'),

				'WH_CODE' : pop2Search.getValue('WH_CODE'),
				
				'INOUT_DATE_2' : UniDate.getDbDateStr(pop2SelectR.get('INOUT_DATE_2'))
			}
			param["USER_LANG"] = UserInfo.userLang;
			param["PGM_ID"]= PGM_ID;
			param["MAIN_CODE"] = 'P010';//생산용 공통 코드
			param["DIV_CODE"] = panelSearch.getValue('DIV_CODE');
			param["SEL_PRINT"] = Ext.getCmp('selectPrinterchk').getChecked()[0].inputValue;
			var win = null;
			win = Ext.create('widget.ClipReport', {
				url: CPATH+'/prodt/pmp280clukrv.do',
				prgID: 'pmp280ukrv',
				extParam: param
			});
//			win.center();	팝업에서 호출시 위치 못찾는현상 때문에 제거
			win.show();

		}


	});

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

