<%--
'   프로그램명 : 작업일지 (생산)
'
'   작  성  자 : (주)포렌 개발실
'   작  성  일 :
'
'   최종수정자 :
'   최종수정일 :
'
'   버	  전 : OMEGA Plus V6.0.0
--%>

<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_pmr830skrv_kodi"  >
	<t:ExtComboStore comboType="BOR120" pgmId="mpo080ukrv" /><!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B020" /><!-- 품목계정 -->
	<t:ExtComboStore comboType="W"  /> <!-- 작업장 -->
</t:appConfig>
<style type="text/css">

.x-change-cell {
background-color: #FFFFC6;
}
.x-change-cell2 {
background-color: #FDE3FF;
}
</style>
<script type="text/javascript" >

var resultsAddWindow; // 생산실적등록팝업

function appMain() {

	var colData = ${colData}; //불량유형 공통코드 데이터 가져오기
	var colData2 = ${colData2}; //불량유형 공통코드 데이터 가져오기
	var fields	= createModelField(colData, colData2);
	var columns	= createGridColumn(colData, colData2);
	var gsBadQtyInfo;
	var gsBadRemarkInfo;


	Unilite.defineModel('s_pmr830skrv_kodiModel1', {
		fields: [
			{name: 'PRODT_DATE'		,text: '작업일자'	,type: 'uniDate'},
			{name: 'WORK_SHOP_CODE'	,text: '<t:message code="system.label.product.mainworkcenter" default="주작업장"/>'	,type: 'string'},
			{name: 'TREE_NAME'		,text: '<t:message code="system.label.product.workcentername" default="작업장명"/>'	,type: 'string'},
			{name: 'PROG_WORK_CODE'	,text: '공정코드'	,type: 'string'},
			{name: 'PROG_WORK_NAME'	,text: '공정명'	,type: 'string'},
			{name: 'FR_TIME'		,text: '시작'	,type: 'string'},
			{name: 'TO_TIME'		,text: '종료'	,type: 'string'},
			{name: 'WKORD_NUM'		,text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>'	,type: 'string'},
			{name: 'PRODT_NUM'		,text: '작업실적번호'	,type: 'string'},
			{name: 'ITEM_CODE'		,text: '<t:message code="system.label.product.item" default="품목"/>'				,type: 'string'},
			{name: 'ITEM_NAME'		,text: '<t:message code="system.label.product.itemname" default="품목명"/>'		,type: 'string'},
			{name: 'STOCK_UNIT'		,text: '<t:message code="system.label.product.unit" default="단위"/>'				,type: 'string'},
			{name: 'CODE_NAME'		,text: '상태'	,type: 'string'},
			{name: 'WKORD_Q'		,text: '<t:message code="system.label.product.workorderqty" default="작업지시량"/>'	,type: 'uniQty'},
			{name: 'WORK_Q'			,text: '<t:message code="system.label.product.workqty" default="생산량"/>'			,type: 'uniQty'},
			{name: 'PRODT_Q'		,text: '<t:message code="system.label.product.productionqty" default="양품량"/>'	,type: 'uniQty'},
			{name: 'LOT_NO'			,text: 'LOT NO'	,type: 'string'},
			{name: 'MAN_HOUR'		,text: '투입공수'	,type:'float', decimalPrecision: 2, format:'0,000.00'},
			{name: 'MAN_CNT'		,text: '작업인원수'	,type:'float', decimalPrecision: 1, format:'0,000.0'},
			{name: 'PRODT_PER'		,text: '인시생산성'	,type:'float', decimalPrecision: 2, format:'0,000.00'},
			{name: 'TROUBLE_OX'		,text: '특기사항'	,type: 'string'},
			{name: 'BAD_OX'		    ,text: '자재불량'	,type: 'string'},
			{name: 'MANCNT_OX'		,text: '작업인원'	,type: 'string'},
			{name: 'CAPACITY_Q'		,text: '용량'	,type: 'uniQty'},
			{name: 'HARDNESS_Q'		,text: '경도'	,type: 'uniQty'},
			{name: 'REMARK'			,text: '<t:message code="system.label.product.remarks" default="비고"/>'			,type: 'string'},
			//20190621 설비코드, 명 추가
			{name: 'EQUIP_CODE'		,text:'<t:message code="system.label.product.facilities" default="설비코드"/>'		,type: 'string'},
			{name: 'EQUIP_NAME'		,text:'<t:message code="system.label.product.facilitiesname" default="설비명"/>'	,type: 'string'},
			//20200131 대분류 추가
	    	{name: 'ITEM_LEVEL1',		text: '<t:message code="system.label.product.majorgroupcode" default="대분류코드"/>',		type:'string'},
	    	{name: 'ITEM_LEVEL_NAME1',	text: '<t:message code="system.label.product.majorgroup" default="대분류"/>',		type:'string'}
		]
	});

//	특기사항등록
	Unilite.defineModel('s_pmr830skrv_kodiModel2', {
		fields: [
			{name: 'WKORD_NUM'		,text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>'		,type:'string'},
			{name: 'PROG_WORK_CODE'	,text: '<t:message code="system.label.product.routingname" default="공정명"/>'			,type:'string', store: Ext.data.StoreManager.lookup('pmr100ukrvProgWordComboStore'), allowBlank:false },
			{name: 'PRODT_DATE'		,text: '<t:message code="system.label.product.occurreddate" default="발생일"/>'			,type:'uniDate', allowBlank:false},
			{name: 'CTL_CD1'		,text: '<t:message code="system.label.product.specialremarkclass" default="특기사항 분류"/>'	,type:'string', allowBlank:false, comboType: 'AU', comboCode: 'P002'},
			{name: 'TROUBLE_TIME'	,text: '<t:message code="system.label.product.occurredtime" default="발생시간"/>'			,type:'float', decimalPrecision: 2, format:'0,000.00'},
			{name: 'TROUBLE'		,text: '<t:message code="system.label.product.summary" default="요약"/>'				,type:'string'},
			{name: 'TROUBLE_CS'		,text: '<t:message code="system.label.product.reason" default="원인"/>'				,type:'string'},
			{name: 'ANSWER'			,text: '<t:message code="system.label.product.action" default="조치"/>'				,type:'string'},
			{name: 'SEQ'			,text: ''				,type:'int'},
			//Hidden : true
			{name: 'DIV_CODE'		,text: '<t:message code="system.label.product.division" default="사업장"/>'		,type:'string'},
			{name: 'WORK_SHOP_CODE' ,text: '<t:message code="system.label.product.mainworkcenter" default="주작업장"/>'		,type:'string'},
			//{name: 'PROG_WORK_CODE' ,text: '<t:message code="system.label.product.routingcode" default="공정코드"/>'			,type:'string'},
			{name: 'UPDATE_DB_USER' ,text: '<t:message code="system.label.product.updateuser" default="수정자"/>'			,type:'string'},
			{name: 'UPDATE_DB_TIME'	,text: '<t:message code="system.label.product.updatedate" default="수정일"/>'			,type:'uniDate'},
			{name: 'COMP_CODE'		,text: '<t:message code="system.label.product.companycode2" default="회사코드"/>'			,type:'string'},
			{name: 'FR_TIME'		,text: '<t:message code="system.label.product.workhourfrom" default="시작"/>'					,type:'uniTime' , format:'Hi'},
			{name: 'TO_TIME'		,text: '<t:message code="system.label.product.workhourto" default="종료"/>'					,type:'uniTime' , format:'Hi'}
		]
	});

	//자재불량내역
	function createModelField(colData, colData2) {
		var fields = [
			{name: 'COMP_CODE'		,text: '<t:message code="system.label.product.compcode" default="법인코드"/>'		,type: 'string'},
			{name: 'DIV_CODE'		,text: '<t:message code="system.label.product.division" default="사업장"/>'		,type: 'string'},
			{name: 'ITEM_CODE'		,text: '<t:message code="system.label.product.item" default="품목"/>'				,type: 'string'},
			{name: 'ITEM_NAME'		,text: '<t:message code="system.label.product.itemname" default="품목명"/>'		,type: 'string'},
			{name: 'SPEC'			,text: '<t:message code="system.label.product.spec" default="규격"/>'				,type:'string'},
			{name: 'STOCK_UNIT'		,text: '<t:message code="system.label.product.unit" default="단위"/>'				,type: 'string' ,comboType: 'AU' , comboCode:'B013' , displayField: 'value'},
			{name: 'CUSTOM_CODE'	,text: '<t:message code="system.label.product.custom" default="거래처코드"/>'		,type: 'string'},
			{name: 'CUSTOM_NAME'	,text: '<t:message code="system.label.product.customname" default="거래처 명"/>'		,type: 'string'},
			{name: 'WORK_SHOP_CODE' ,text: '<t:message code="system.label.product.mainworkcenter" default="주작업장"/>'	,type:'string'},
			{name: 'WKORD_NUM'		,text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>'	,type:'string'},
			{name: 'PRODT_NUM'		,text: '<t:message code="system.label.product.productionno" default="생산번호"/>'	,type:'string'},
			{name: 'SEQ'			,text: '<t:message code="system.label.product.seq" default="순번"/>'				,type:'string'},
			{name: 'SAVE_FLAG'		,text: 'SAVE_FLAG'	,type:'string'}
		];
		//동적 컬럼 모델 push
		Ext.each(colData, function(item, index){
			fields.push({name: 'BAD_' + item.SUB_CODE, type:'uniQty' });
		});

		Ext.each(colData2, function(item, index){
			fields.push({name: 'REMARK_' + item.SUB_CODE, type:'string' });
		});
		console.log(fields);
		return fields;
	}

	//자재불량내역 그리드 컬럼 생성
	function createGridColumn(colData, colData2) {
		var array1  = new Array();
		var array2  = new Array();
		var columns = [
			{dataIndex: 'SAVE_FLAG'			, width: 66		, hidden: true},
			{dataIndex: 'COMP_CODE'			, width: 66		, hidden: true},
			{dataIndex: 'DIV_CODE'			, width: 66		, hidden: true},
			{dataIndex: 'SEQ'				, width: 40, align:'center', hidden: false, locked: true},
			{dataIndex: 'WKORD_NUM'			, width: 66		, hidden: true},
			{dataIndex: 'WORK_SHOP_CODE'	, width: 66		, hidden: true},
			{dataIndex: 'PRODT_NUM'			, width: 66		, hidden: true},
			{dataIndex: 'ITEM_CODE'			, width: 90		, locked: true},
			{dataIndex: 'ITEM_NAME'			, width: 250	, locked: true},
			{dataIndex: 'SPEC'				, width: 70		, locked: false, align:'center'},
			{dataIndex: 'STOCK_UNIT'		, width: 50, align:'center'	, locked: false},
			{dataIndex: 'CUSTOM_CODE'		, width: 70	, locked: false, hidden: true},
			{dataIndex: 'CUSTOM_NAME'				, width: 150		, locked: false}
		];
		Ext.each(colData, function(item, index){
			if(index == 0){
				gsBadQtyInfo = item.SUB_CODE;
			} else {
				gsBadQtyInfo += ',' + item.SUB_CODE;
			}
			array1[index] = Ext.applyIf({dataIndex: 'BAD_' + item.SUB_CODE	, text: item.CODE_NAME	, flex:1},	{align: 'right' ,xtype:'uniNnumberColumn', format: UniFormat.Qty });
		});

		Ext.each(colData2, function(item, index){
			if(index == 0){
				gsBadRemarkInfo = item.SUB_CODE;
			} else {
				gsBadRemarkInfo += ',' + item.SUB_CODE;
			}
			array2[index] = Ext.applyIf({dataIndex: 'REMARK_' + item.SUB_CODE	, text: item.CODE_NAME+'(비고)'	, flex:1},	{align: 'left'});
		});



		columns.push(
			{text: '<t:message code="system.label.product.defectinfo" default="불량정보"/>',
				columns: array1
			}
			);

		columns.push(
			{text: '불량정보비고',
				columns: array2
			}
			);


 		console.log(columns);
		return columns;
	}

	Unilite.defineModel('s_pmr830skrv_kodiModel3', {
		fields: fields
	});

	//작업인원
	Unilite.defineModel('s_pmr830skrv_kodiModel4', {
		fields: [
			{name: 'SEQ'			,text: '구분'				,type:'int'},
			{name: 'MAN_CNT'	    ,text: '작업인원'			,type:'int'},
			{name: 'FR_TIME'		,text: '작업시작시간'			,type:'uniTime' , format:'Hi'},
			{name: 'TO_TIME'		,text: '작업종료시간'			,type:'uniTime' , format:'Hi'},
			{name: 'MAN_HOUR'	    ,text: '투입공수'			,type:'float', decimalPrecision: 1, format:'0,000.0'},
			{name: 'REMARK'		    ,text: '비고'		        ,type:'string'}

		]
	});

	var MasterStore1 = Unilite.createStore('s_pmr830skrv_kodiMasterStore1',{
		model: 's_pmr830skrv_kodiModel1',
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
				read: 's_pmr830skrv_kodiService.selectList1'
			}
		},
		loadStoreRecords: function(record){
			var param= panelSearch.getValues();
			this.load({
					params : param
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


	var MasterStore2 = Unilite.createStore('s_pmr830skrv_kodiMasterStore2',{
		model: 's_pmr830skrv_kodiModel2',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결
			editable: true,			// 수정 모드 사용
			deletable:true,			// 삭제 가능 여부
			useNavi : false			// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {
				read: 's_pmr830skrv_kodiService.selectList2'
			}
		},
		loadStoreRecords : function()	{
			var param= panelSearch.getValues();
			var record	= masterGrid1.getSelectedRecord();
			if(!Ext.isEmpty(record)) {
				param.WKORD_NUM			= record.get('WKORD_NUM');
				param.PROG_WORK_CODE	= record.get('PROG_WORK_CODE');
				param.WORK_SHOP_CODE	= record.get('WORK_SHOP_CODE');
			}
			console.log(param);
			this.load({
				params : param
			});
		},
		listeners:{
			update:function( store, record, operation, modifiedFieldNames, eOpts )	{

			}
		}
	});

	var MasterStore3 = Unilite.createStore('s_pmr830skrv_kodiMasterStore3',{
		model: 's_pmr830skrv_kodiModel3',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결
			editable: true,			// 수정 모드 사용
			deletable:true,			// 삭제 가능 여부
			useNavi : false			// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {
				read: 's_pmr830skrv_kodiService.selectList3'
			}
		},
		loadStoreRecords : function(badQtyArray, badRemarkArray)	{
			var param= panelSearch.getValues();
			var record	= masterGrid1.getSelectedRecord();
			if(!Ext.isEmpty(record)) {
				param.WKORD_NUM			= record.get('WKORD_NUM');
				param.PRODT_NUM         = record.get('PRODT_NUM');
				param.PROG_WORK_CODE	= record.get('PROG_WORK_CODE');
			}
			if(!Ext.isEmpty(badQtyArray)) {
				param.badQtyArray = badQtyArray;
			}

			if(!Ext.isEmpty(badRemarkArray)) {
				param.badRemarkArray = badRemarkArray;
			}

			console.log(param);
			this.load({
				params : param
			});
		},
		listeners:{
			update:function( store, record, operation, modifiedFieldNames, eOpts )	{

			}
		}
	});

	var MasterStore4 = Unilite.createStore('s_pmr830skrv_kodiMasterStore4',{
		model: 's_pmr830skrv_kodiModel4',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결
			editable: true,			// 수정 모드 사용
			deletable:true,			// 삭제 가능 여부
			useNavi : false			// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {
				read: 's_pmr830skrv_kodiService.selectList4'
			}
		},
		loadStoreRecords : function()	{
			var param= panelSearch.getValues();
			var record	= masterGrid1.getSelectedRecord();
			if(!Ext.isEmpty(record)) {
				param.PRODT_NUM			= record.get('PRODT_NUM');
			}
			console.log(param);
			this.load({
				params : param
			});
		},
		listeners:{
			update:function( store, record, operation, modifiedFieldNames, eOpts )	{

			}
		}
	});



	var panelSearch = Unilite.createSearchForm('searchForm', {
		region: 'north',
		layout: {
			type: 'uniTable',
			columns: 3
		},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
			name:'DIV_CODE',
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			allowBlank: false,
			value: UserInfo.divCode,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('WORK_SHOP_CODE','');
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.product.plannedstartdate" default="작업일자"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'PRODT_START_DATE',
			endFieldName: 'PRODT_END_DATE',
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today'),
			width: 315
		},{
			xtype: 'radiogroup',
			fieldLabel: '   ',
			items: [{
				boxLabel: '<t:message code="system.label.product.whole" default="전체"/>',
				width:130,
				name: 'OPT',
				inputValue: '1',
				checked: true
			},{
				boxLabel: '<t:message code="system.label.product.process" default="진행"/>',
				width:130,
				name: 'OPT',
				inputValue: '2'
			},{
				boxLabel: '<t:message code="system.label.product.closing" default="마감"/>',
				width:130,
				name: 'OPT',
				inputValue: '3'
			},{
				boxLabel: '<t:message code="system.label.product.completion" default="완료"/>',
				width:130,
				name: 'OPT',
				inputValue: '4'
			}]

		},{
			fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
			name: 'WORK_SHOP_CODE',
			xtype: 'uniCombobox',
			comboType:'W',
			listeners: {
				beforequery:function( queryPlan, eOpts )   {
					var store = queryPlan.combo.store;
					store.clearFilter();
					if(!Ext.isEmpty(panelSearch.getValue('DIV_CODE'))){
						store.filterBy(function(record){
							return record.get('option') == panelSearch.getValue('DIV_CODE');
						});
					}else{
						store.filterBy(function(record){
							return false;
						});
					}
				}
			}
		},
		Unilite.popup('DIV_PUMOK',{
				fieldLabel: '<t:message code="system.label.product.item" default="품목"/>',
				valueFieldName: 'ITEM_CODE',
				textFieldName:'ITEM_NAME',
				listeners: {
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}
		})]
	});



	var masterGrid1 = Unilite.createGrid('s_pmr830skrv_kodiGrid1', {
		store : MasterStore1,
		region:'center',
		selModel: 'rowmodel',
		uniOpt:{
			expandLastColumn: true,
			useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			useGroupSummary: false,
			useRowNumberer: false,
			filter: {
				useFilter: true,
				autoCreate: true
			}
		},
		features: [
			{id : 'masterGridSubTotal',	ftype: 'uniGroupingsummary',	showSummaryRow: true},
			{id : 'masterGridTotal' ,	ftype: 'uniSummary',			showSummaryRow: true}
		],
		columns:  [
			{dataIndex: 'PRODT_DATE'		, width: 88},
			{dataIndex: 'WORK_SHOP_CODE'	, width: 100,hidden:true},
			{dataIndex: 'TREE_NAME'			, width: 100},
			{dataIndex: 'PROG_WORK_CODE'	, width: 80,hidden:true},
			{dataIndex: 'PROG_WORK_NAME'	, width: 120},
			//20190621 설비코드, 명 추가
			{dataIndex: 'EQUIP_CODE'		, width: 80,hidden: true},
			{dataIndex: 'EQUIP_NAME'		, width: 120},
			{dataIndex: 'FR_TIME'			, width: 80, align: 'center'},
			{dataIndex: 'TO_TIME'			, width: 80, align: 'center'},
			{dataIndex: 'WKORD_NUM'			, width: 120},
			{dataIndex: 'ITEM_CODE'			, width: 125},
			{dataIndex: 'ITEM_NAME'			, width: 250},
			{dataIndex: 'STOCK_UNIT'		, width: 80, align: 'center'},
			{dataIndex: 'CODE_NAME'			, width: 80, align: 'center'},
			{dataIndex: 'WKORD_Q'			, width: 110, summaryType: 'sum',tdCls:'x-change-cell2'},
			{dataIndex: 'WORK_Q'			, width: 100, summaryType: 'sum'},
			{dataIndex: 'PRODT_Q'			, width: 110, summaryType: 'sum',tdCls:'x-change-cell2'},
			{dataIndex: 'LOT_NO'			, width: 100, align: 'center'},
			{dataIndex: 'MAN_HOUR'			, width: 100, summaryType: 'sum',tdCls:'x-change-cell2'},
			{dataIndex: 'MAN_CNT'			, width: 100, summaryType: 'sum',tdCls:'x-change-cell2'},
			{dataIndex: 'PRODT_PER'		    , width: 100},
			{dataIndex: 'TROUBLE_OX'		, width: 100, align: 'center'},
			{dataIndex: 'BAD_OX'		    , width: 100, align: 'center'},
			{dataIndex: 'MANCNT_OX'		    , width: 100, align: 'center'},
			{dataIndex: 'CAPACITY_Q'		, width: 100},
			{dataIndex: 'HARDNESS_Q'		, width: 100},
			{dataIndex: 'ITEM_LEVEL1'		, width: 80,hidden: true},
			{dataIndex: 'ITEM_LEVEL_NAME1'		, width: 120},
			{dataIndex: 'REMARK'			, width: 500}
		],
		listeners :{
			onGridDblClick:function(grid, record, cellIndex, colName) {
				var detailRecord = masterGrid1.getSelectedRecord();
				if(detailRecord.get('TROUBLE_OX') == 'O' || detailRecord.get('BAD_OX') == 'O' || detailRecord.get('MANCNT_OX') == 'O') {
					
					openResultsAddWindow(colName); // 선택한 colName

				}else{
	   				 return false;
				}
			}

		}

	});

	var masterGrid2 = Unilite.createGrid('s_pmr830skrv_kodiGrid2', {
		layout : 'fit',
		region:'center',
		height:380,
//		title : '<t:message code="system.label.product.specialremarkentry" default="특기사항등록"/>',
		store : MasterStore2,
		uniOpt:{	expandLastColumn: false,
					useRowNumberer: true,
					useMultipleSorting: true
		},
		sortableColumns: false,
		features: [
			{id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
			{id: 'masterGridTotal',	ftype: 'uniSummary', 		showSummaryRow: false}
		],
		columns: [
			{dataIndex: 'WKORD_NUM'			, width: 120 , hidden: true},
			{dataIndex: 'PROG_WORK_CODE'		, width: 166},
			{dataIndex: 'PRODT_DATE'			, width: 100},
			{dataIndex: 'CTL_CD1'			, width: 160},
			{dataIndex: 'FR_TIME'			, width: 93, align:'center'},
			{dataIndex: 'TO_TIME'			, width: 93, align:'center'},
			{dataIndex: 'TROUBLE_TIME'		, width: 100, align: 'center'},
			{dataIndex: 'TROUBLE'			, width: 166},
			{dataIndex: 'TROUBLE_CS'			, width: 166},
			{dataIndex: 'ANSWER'				, width: 800},
			{dataIndex: 'SEQ'				, width: 100, hidden:true},
			{dataIndex: 'DIV_CODE'			, width: 0 , hidden:true},
			{dataIndex: 'WORK_SHOP_CODE'		, width: 0 , hidden:true},
			{dataIndex: 'UPDATE_DB_USER'		, width: 0 , hidden:true},
			{dataIndex: 'UPDATE_DB_TIME'		, width: 0 , hidden:true},
			{dataIndex: 'COMP_CODE'			, width: 0 , hidden:true}
		]
	});


	var masterGrid3 = Unilite.createGrid('s_pmr830skrv_kodiGrid3', {
		layout : 'fit',
		region:'center',
		height:380,
//		title : '<t:message code="system.label.product.specialremarkentry" default="특기사항등록"/>',
		store : MasterStore3,
		uniOpt:{	expandLastColumn: false,
					useRowNumberer: true,
					useMultipleSorting: true
		},
		sortableColumns: false,
		features: [
			{id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
			{id: 'masterGridTotal',	ftype: 'uniSummary', 		showSummaryRow: false}
		],
		columns	: columns
	});


	var masterGrid4 = Unilite.createGrid('s_pmr830skrv_kodiGrid4', {
		layout : 'fit',
		region:'center',
		height:380,
//		title : '<t:message code="system.label.product.specialremarkentry" default="특기사항등록"/>',
		store : MasterStore4,
		uniOpt:{	expandLastColumn: false,
					useRowNumberer: true,
					useMultipleSorting: true
		},
		sortableColumns: false,
		features: [
			{id : 'masterGridSubTotal',	ftype: 'uniGroupingsummary',	showSummaryRow: true},
			{id : 'masterGridTotal' ,	ftype: 'uniSummary',			showSummaryRow: true}
		],
		columns: [
			{dataIndex: 'SEQ'				, width: 80},
			{dataIndex: 'MAN_CNT'			, width: 100, summaryType: 'sum' },
			{dataIndex: 'FR_TIME'			, width: 100, align:'center'},
			{dataIndex: 'TO_TIME'			, width: 100, align:'center'},
			{dataIndex: 'MAN_HOUR'		    , width: 100, summaryType: 'sum'},
			{dataIndex: 'REMARK'			, width: 300}
		]
	});

	var tab3 = Unilite.createTabPanel('tabPanel3',{
		split: false,
		border : true,
		activeTab: 0,
		margin: '-20 0 0 0',
		region:'center',
		items: [{	title: '<t:message code="system.label.product.specialremarkentry" default="특기사항등록"/>',
				    	xtype:'container',
				    	width:1010,
				    	height:380,
				    	layout:{type:'vbox', align:'stretch'},
				    	items:[masterGrid2],
				    	id: 's_pmr830skrv_kodiResult_tab1'
			    	},{
				    	title: '자재불량내역',
				    	xtype:'container',
				    	width:1010,
				    	height:380,
				    	layout:{type:'vbox', align:'stretch'},
				    	items:[masterGrid3],
				    	id: 's_pmr830skrv_kodiResult_tab2'
			    	},{
				    	title: '작업인원',
				    	xtype:'container',
				    	width:1010,
				    	height:380,
				    	layout:{type:'vbox', align:'stretch'},
				    	items:[masterGrid4],
				    	id: 's_pmr830skrv_kodiResult_tab3'
			    	}
		],
		listeners:  {
			beforetabchange : function( grouptabPanel, newCard, oldCard, eOpts )   {
			},
			tabChange:  function ( tabPanel, newCard, oldCard, eOpts ) {
				var newTabId	= newCard.getId();
				var record		= masterGrid1.getSelectedRecord();
		      if(!Ext.isEmpty(record)) {
					if(newTabId == 's_pmr830skrv_kodiResult_tab2'){
						var badQtyArray = new Array();
						badQtyArray = gsBadQtyInfo.split(',');
						var badRemarkArray = new Array();
						badRemarkArray = gsBadRemarkInfo.split(',');
						if(MasterStore3.getCount() == 0){
							MasterStore3.loadStoreRecords(badQtyArray, badRemarkArray);
						}
					}else if(newTabId == 's_pmr830skrv_kodiResult_tab3'){
						MasterStore4.loadStoreRecords(record);
					}else{
						MasterStore2.loadStoreRecords(record);
					}
				}
			}
		}
	});
	var resultsAddForm = Unilite.createSearchForm('resultsAddForm', {       // 생산실적 팝업창
        layout: {type : 'uniTable', columns : 3},
        height:800,
        width: 1110,
		region		: 'center',
		autoScroll	: false,
		border		: true,
		padding		: '1 1 1 1',
		layout		: {type: 'uniTable', columns: 1, tdAttrs: {valign:'top'}},
		xtype		: 'container',
		defaultType	: 'container',
        items:[{
			layout		: {type: 'uniTable', columns: 1, tableAttrs:{cellpadding:5}, tdAttrs: {valign:'top'}},
			defaultType	: 'uniFieldset',
			defaults	: { padding: '10 15 15 15'},
			items		: [{
					title	: '<t:message code="system.label.product.workorderinfo" default="작업지시정보"/>',
					layout	: { type: 'uniTable', columns: 1},
					margin: '10 0 15 15',
					width:1010,
					items	: [{fieldLabel: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>',
									xtype: 'uniTextfield',
									name: 'WKORD_NUM',
									holdable: 'hold',
									width: 300,
									readOnly: true,
									margin: '0 0 0 40',
									fieldStyle: 'text-align: center;',
									listeners: {
										change: function(field, newValue, oldValue, eOpts) {

										}
									}
								},{
					                fieldLabel: '<t:message code="system.label.product.item" default="품목"/>',
					                name:'ITEM_CODE',
					                xtype: 'uniTextfield',
					                width: 300,
					                readOnly: true,
					                margin: '0 0 0 40',
					                fieldStyle: 'text-align: center;'

					            },{
					                fieldLabel: '<t:message code="system.label.product.itemname2" default="품명"/>',
					                name:'ITEM_NAME',
					                width: 600,
					                xtype: 'uniTextfield',
					                margin: '0 0 0 40',
					                readOnly: true
					            },{
									xtype: 'container',
									layout:{type:'uniTable',columns:2},
									defaults	: { padding: '-3 0 0 0'},
									items:[{
						                fieldLabel: '<t:message code="system.label.product.workorderqty" default="작업지시량"/>',
						                name:'WKORD_Q',
						                xtype: 'uniNumberfield',
						                margin: '0 0 0 40',
						                type:'uniQty',
						                readOnly: true

						            },{
						                fieldLabel: '<t:message code="system.label.product.unit" default="단위"/>',
						                name:'STOCK_UNIT',
						                xtype: 'uniTextfield',
						                width: 150,
						                readOnly: true,
						                margin: '0 0 0 40',
						                fieldStyle: 'text-align: center;'
						            }]
					          }
					 ]},tab3
         	]}
     	 ]
//   		setAllFieldsReadOnly: setAllFieldsReadOnly
    });

	function openResultsAddWindow(colId) {   // 생산실적등록 팝업창
		if(!resultsAddWindow) {
			resultsAddWindow = Ext.create('widget.uniDetailWindow', {
				title: '<t:message code="system.label.product.productionresultentrypopup" default="생산실적등록팝업"/>',
				width: 1070,
				height: 790,
				tabDirection: 'left-right',
				resizable:true,
				layout: {type:'vbox', align:'stretch'},
				items: [resultsAddForm],
				tbar:  ['->', {
						id : 'resultsAddCloseBtn',
						width: 100,
						text: '<t:message code="system.label.product.close" default="닫기"/>',
						handler: function() {
								resultsAddForm.clearForm();
								resultsAddWindow.hide();
						},
						disabled: false
					}
				],
				listeners: {
					beforehide: function(me, eOpt) {
					},
					beforeclose: function( panel, eOpts ) {
					},
					beforeshow: function( panel, eOpts )	{
						var detailRecord = masterGrid1.getSelectedRecord();
						resultsAddForm.setValue('WKORD_NUM', detailRecord.get('WKORD_NUM'));
						resultsAddForm.setValue('ITEM_CODE', detailRecord.get('ITEM_CODE'));
						resultsAddForm.setValue('ITEM_NAME', detailRecord.get('ITEM_NAME'));
						resultsAddForm.setValue('WKORD_Q', detailRecord.get('WKORD_Q'));
						resultsAddForm.setValue('STOCK_UNIT', detailRecord.get('STOCK_UNIT'));

						MasterStore2.loadStoreRecords(detailRecord);
					}
				}
			})
		}
		
		// 이동할 탭 id 초기화
		var tabId = '';
		
		switch(colId) {
			// 자재불량내역 탭
			case "BAD_OX" :	
				tabId = 's_pmr830skrv_kodiResult_tab2';
				break;
				
			// 작업인원 탭
			case "MANCNT_OX" :
				tabId = 's_pmr830skrv_kodiResult_tab3';
				break;
				
			// default 특기사항등록 탭
			default :
				tabId = 's_pmr830skrv_kodiResult_tab1';
				break;
		}
		
		tab3.setActiveTab(tabId);
		resultsAddWindow.center();
		resultsAddWindow.show();
	}

	Unilite.Main({
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid1,  panelSearch
			]
		}],
		id: 's_pmr830skrv_kodiApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('save',false);
			panelSearch.setValue('PRODT_START_DATE', UniDate.get('today'));
			panelSearch.setValue('PRODT_END_DATE', UniDate.get('today'));
			panelSearch.getField("OPT").value = '1';
		},
		onQueryButtonDown : function() {
			if(panelSearch.getInvalidMessage()){
				MasterStore1.loadStoreRecords();
			}
		},
		onResetButtonDown: function() {
			panelSearch.reset();
			masterGrid1.reset();
			this.fnInitBinding();
		}
	});
};
</script>

