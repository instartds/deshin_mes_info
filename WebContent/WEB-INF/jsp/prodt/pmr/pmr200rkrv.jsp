<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="pmr200rkrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 						<!-- 사업장 -->
	<t:ExtComboStore items="${COMBO_WS_LIST}" storeId="wsList" />	<!-- 작업장 -->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" />	<!-- 창고-->

</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}	
</style>
<script type="text/javascript" >

function appMain() {

	Unilite.defineModel('pmr200rkrvModel', {
		fields: [//<t:message code="system.label.product.resultsdate" default="실적일"/>
			{name: 'COMP_CODE'		, text: '<t:message code="system.label.product.companycode" default="법인코드"/>'				, type: 'string'},
			{name: 'DIV_CODE'		, text: '<t:message code="system.label.product.division" default="사업장"/>'					, type: 'string'},
			{name: 'WORK_SHOP_CODE'	, text: '<t:message code="system.label.product.workcenter" default="작업장"/>'				, type: 'string'},
			{name: 'WORK_SHOP_NAME'	, text: '<t:message code="system.label.product.workcentername" default="작업장명"/>'			, type: 'string'},
			{name: 'ITEM_CODE'		, text: '<t:message code="system.label.product.item" default="품목"/>'						, type: 'string'},
			{name: 'ITEM_NAME'		, text: '<t:message code="system.label.product.itemname" default="품목명"/>'					, type: 'string'},
			{name: 'ITEM_NAME1'		, text: '<t:message code="system.label.product.itemname" default="품목명"/>1'					, type: 'string'},
			{name: 'SPEC'			, text: '<t:message code="system.label.product.spec" default="규격"/>'						, type: 'string'},
			{name: 'STOCK_UNIT'		, text: '<t:message code="system.label.product.unit" default="단위"/>'						, type: 'string'},
			{name: 'PRODT_Q'		, text: '<t:message code="system.label.product.productionqty" default="생산량"/>'				, type: 'uniQty'},
			{name: 'LOT_NO'			, text: 'LOT'	, type: 'string'},
			{name: 'IN_STOCK_Q'		, text: '<t:message code="system.label.product.receiptqty" default="입고량"/>'				, type: 'uniQty'},
			{name: 'WKORD_NUM'		, text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>'			, type: 'string'},
			{name: 'PRODT_NUM'		, text: '<t:message code="system.label.product.productionresultno" default="생산실적번호"/>'	, type: 'string'},
			{name: 'REMARK'			, text: '<t:message code="system.label.product.remarks" default="비고"/>'						, type: 'string'},
			{name: 'PRODT_DATE'		, text: '<t:message code="system.label.product.resultsdate" default="실적일"/>'				, type: 'uniDate'},
			//20190212 추가(통합작업지시번호, 양품량, 불량수량)
			{name: 'TOP_WKORD_NUM'	, text: '<t:message code="system.label.product.topworkorderno2" default="통합작업지시번호"/>'	, type: 'string'},
			{name: 'GOOD_PRODT_Q'	, text: '<t:message code="system.label.product.gooditemqty" default="양품량"/>'				, type: 'uniQty'},
			{name: 'BAD_PRODT_Q'	, text: '<t:message code="system.label.product.defectqty" default="불량수량"/>'				, type: 'uniQty'},
			//20190226 추가(수불(입고)창고)
			{name: 'WH_CODE'		, text: '<t:message code="system.label.product.tranwarehouse" default="수불창고"/>'			, type: 'string' , store: Ext.data.StoreManager.lookup('whList')}
		]
	});



	var directMasterStore = Unilite.createStore('pmr200rkrvMasterStore',{
		model: 'pmr200rkrvModel',
		uniOpt: {
			isMaster	: true,		// 상위 버튼 연결 
			editable	: false,	// 수정 모드 사용 
			deletable	: false,	// 삭제 가능 여부 
			useNavi		: false		// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {
				read: 'pmr200rkrvService.selectList'
			}
		},
		loadStoreRecords : function()	{
			var param = Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params: param
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
			},
			add: function(store, records, index, eOpts) {
				
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
				
			},
			remove: function(store, record, index, isMove, eOpts) {
			}
		}
	});



	var panelSearch = Unilite.createSearchPanel('searchForm',{
		title: '<t:message code="system.label.product.searchconditon" default="검색조건"/>',
		defaultType: 'uniSearchSubPanel',
		collapsed:true,
		listeners: {
			collapse: function () {
				panelResult.show();
			},
			expand: function() {
				panelResult.hide();
			}
		},
		items: [{	
			title: '<t:message code="system.label.product.basisinfo" default="기본정보"/>', 	
   			itemId: 'search_panel1',
			layout: {type: 'uniTable', columns: 1},
			defaultType: 'uniTextfield',
			items: [{
				fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
				name:'DIV_CODE', 
				xtype: 'uniCombobox', 
				comboType:'BOR120', 
				allowBlank: false,
				value : UserInfo.divCode,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
				name:'WORK_SHOP_CODE', 
				xtype: 'uniCombobox', 
				store: Ext.data.StoreManager.lookup('wsList'),
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('WORK_SHOP_CODE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.product.resultsdate" default="실적일"/>', 
				xtype: 'uniDateRangefield', 
				startFieldName: 'PRODT_DATE_FR',
				endFieldName:'PRODT_DATE_TO',
				startDate: UniDate.get('today'),
				endDate: UniDate.get('today'),
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('PRODT_DATE_FR',newValue);
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('PRODT_DATE_TO',newValue);
					}
				}
			},
			Unilite.popup('DIV_PUMOK',{
				fieldLabel: '<t:message code="system.label.product.item" default="품목"/>',
//				validateBlank:false,
				textFieldName: 'ITEM_NAME',
				valueFieldName: 'ITEM_CODE',
				listeners: {
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('ITEM_CODE', newValue);
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('ITEM_NAME', newValue);
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
					}
				}
			}),
			{
				xtype:'uniTextfield',
				fieldLabel:'<t:message code="system.label.product.workorderno" default="작업지시번호"/>',
				name:'WKORD_NUM',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('WKORD_NUM', newValue);
					}
				}
				
			}]							 
		}]
	});	
	
	var panelResult = Unilite.createSimpleForm('panelResultForm', {
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
			name:'DIV_CODE', 
			xtype: 'uniCombobox', 
			comboType:'BOR120', 
			allowBlank: false,
			value : UserInfo.divCode,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
			name:'WORK_SHOP_CODE', 
			xtype: 'uniCombobox', 
			store: Ext.data.StoreManager.lookup('wsList'),
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('WORK_SHOP_CODE', newValue);
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.product.resultsdate" default="실적일"/>', 
			xtype: 'uniDateRangefield', 
			startFieldName: 'PRODT_DATE_FR',
			endFieldName:'PRODT_DATE_TO',
			startDate: UniDate.get('today'),
			endDate: UniDate.get('today'),
			width: 315,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('PRODT_DATE_FR',newValue);
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('PRODT_DATE_TO',newValue);
				}
			}
		},
		Unilite.popup('DIV_PUMOK',{ 
			fieldLabel: '<t:message code="system.label.product.item" default="품목"/>', 
//			validateBlank:false,
			textFieldName: 'ITEM_NAME',
			valueFieldName: 'ITEM_CODE', 
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
		}),
		{
			xtype:'uniTextfield',
			fieldLabel:'<t:message code="system.label.product.workorderno" default="작업지시번호"/>',
			name:'WKORD_NUM',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('WKORD_NUM', newValue);
				}
			}
			
		}]							 
	});



	/** Master Grid1 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid = Unilite.createGrid('pmr200rkrvGrid', {
		layout	: 'fit',
		region	: 'center',
		store	: directMasterStore, 
		uniOpt	: {
			expandLastColumn	: false,
			useLiveSearch		: false,
			useContextMenu		: false,
			useMultipleSorting	: false,
			useGroupSummary		: false,
			useRowNumberer		: false,
			onLoadSelectFirst	: false,
			filter: {
				useFilter	: false,
				autoCreate	: false
			},
			excel: {
				useExcel	: true,		//엑셀 다운로드 사용 여부
				exportGroup	: false,	//group 상태로 export 여부
				onlyData	: false,	//데이터만 받는 경우
				summaryExport:true		//summary 정보도 포함(xlsx 형태의파일만 가능함)
			}
		},
		features: [ 
			{id: 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: true},
			{id: 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: true}
		],
		selModel : Ext.create("Ext.selection.CheckboxModel", {
			singleSelect : true ,
			checkOnly : false
		}),
		columns: [
			{dataIndex: 'COMP_CODE',		width: 100, hidden:true},
			{dataIndex: 'DIV_CODE',			width: 100, hidden:true},
			{dataIndex: 'WORK_SHOP_CODE',	width: 100, hidden:true},
			{dataIndex: 'WORK_SHOP_NAME',	width: 150,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '', '<t:message code="system.label.product.totalamount" default="합계"/>');
				}
			},
			{dataIndex: 'ITEM_CODE',		width: 100},
			{dataIndex: 'ITEM_NAME',		width: 250},
			{dataIndex: 'ITEM_NAME1',		width: 250, hidden: true},
			{dataIndex: 'SPEC',				width: 150},
			{dataIndex: 'STOCK_UNIT',		width: 80},
			{dataIndex: 'PRODT_DATE',		width: 100},
			{dataIndex: 'PRODT_Q',			width: 100, summaryType: 'sum'},
			//20190212 추가 (GOOD_PRODT_Q, BAD_PRODT_Q)
			{dataIndex: 'GOOD_PRODT_Q',		width: 100, summaryType: 'sum', hidden: true},
			{dataIndex: 'BAD_PRODT_Q',		width: 100, summaryType: 'sum', hidden: true},
			{dataIndex: 'LOT_NO',			width: 120},
			{dataIndex: 'IN_STOCK_Q',		width: 100, summaryType: 'sum'},
			{dataIndex: 'WKORD_NUM',		width: 130},
			//20190212 추가 (TOP_WKORD_NUM)
			{dataIndex: 'TOP_WKORD_NUM',	width: 130, hidden: true},
			{dataIndex: 'PRODT_NUM',		width: 130},
			//20190226 추가 (WH_CODE)
			{dataIndex: 'WH_CODE',			width: 100, hidden: false},
			{dataIndex: 'REMARK',			flex:1}
		]
	});



	Unilite.Main( {
		id  : 'pmr200rkrvApp',
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult
			]
		},
		panelSearch
		],
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons(['save'], false);
			UniAppManager.setToolbarButtons(['print'], true);
		},
		onQueryButtonDown : function()	{
			if(!panelResult.getInvalidMessage()) return;
			directMasterStore.loadStoreRecords();
		},
		onResetButtonDown:function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			directMasterStore.clearData();
			UniAppManager.app.fnInitBinding();
		},
		onPrintButtonDown: function() {
			if(!panelResult.getInvalidMessage()) return;   //필수체크
			
			var selectedRecords = masterGrid.getSelectedRecords();
			if(Ext.isEmpty(selectedRecords)){
				alert('<t:message code="system.message.product.message017" default="출력할 데이터가 없습니다."/>');
				return;
			}
			var wkordNumRecords = new Array();
			Ext.each(selectedRecords, function(record, idx) {
				wkordNumRecords.push(record.get('WKORD_NUM'));
			});
				
			var param = panelResult.getValues();
			
			param["dataCount"] = selectedRecords.length;
			param["WKORD_NUM"] = wkordNumRecords;
			
			param["sTxtValue2_fileTitle"]='생산실적';
			
			param["USER_LANG"] = UserInfo.userLang;
			param["RPT_ID"]='pmr200rkrv';
			param["PGM_ID"]='pmr200rkrv';
			var win = Ext.create('widget.CrystalReport', {
				url: CPATH+'/prodt/pmr200crkrv.do',
				prgID: 'pmr200rkrv',
				extParam: param
			});
			win.center();
			win.show();
		}
	});
};
</script>
