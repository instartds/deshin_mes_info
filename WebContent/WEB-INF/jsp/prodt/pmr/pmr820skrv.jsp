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
<t:appConfig pgmId="pmr820skrv"  >
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

function appMain() {
 
	Unilite.defineModel('pmr820skrvModel1', {
		fields: [	 
			{name: 'PRODT_DATE'		,text: '작업일자'	,type: 'uniDate'},
			{name: 'WORK_SHOP_CODE'	,text: '<t:message code="system.label.product.mainworkcenter" default="주작업장"/>'	,type: 'string'},
			{name: 'TREE_NAME'		,text: '<t:message code="system.label.product.workcentername" default="작업장명"/>'	,type: 'string'},
			{name: 'PROG_WORK_CODE'	,text: '공정코드'	,type: 'string'},
			{name: 'PROG_WORK_NAME'	,text: '공정명'	,type: 'string'},
			{name: 'FR_TIME'		,text: '시작'	,type: 'string'},
			{name: 'TO_TIME'		,text: '종료'	,type: 'string'},
			{name: 'WKORD_NUM'		,text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>'	,type: 'string'},
			{name: 'ITEM_CODE'		,text: '<t:message code="system.label.product.item" default="품목"/>'				,type: 'string'},
			{name: 'ITEM_NAME'		,text: '<t:message code="system.label.product.itemname" default="품목명"/>'		,type: 'string'},
			{name: 'STOCK_UNIT'		,text: '<t:message code="system.label.product.unit" default="단위"/>'				,type: 'string'},
			{name: 'CODE_NAME'		,text: '상태'	,type: 'string'},	
			{name: 'WKORD_Q'		,text: '<t:message code="system.label.product.workorderqty" default="작업지시량"/>'	,type: 'uniQty'},
			{name: 'WORK_Q'			,text: '<t:message code="system.label.product.workqty" default="생산량"/>'			,type: 'uniQty'},
			{name: 'PRODT_Q'		,text: '<t:message code="system.label.product.productionqty" default="양품량"/>'	,type: 'uniQty'},
			{name: 'LOT_NO'			,text: 'LOT NO'	,type: 'string'},
			{name: 'MAN_HOUR'		,text: '<t:message code="system.label.product.inputtimesum" default="투입공수합계"/>'	,type: 'uniQty'},
			{name: 'REMARK'			,text: '<t:message code="system.label.product.remarks" default="비고"/>'			,type: 'string'},
			//20190621 설비코드, 명 추가
			{name: 'EQUIP_CODE'		,text:'<t:message code="system.label.product.facilities" default="설비코드"/>'		,type: 'string'},
			{name: 'EQUIP_NAME'		,text:'<t:message code="system.label.product.facilitiesname" default="설비명"/>'	,type: 'string'},
			//20200131 대분류 추가
	    	{name: 'ITEM_LEVEL1',		text: '<t:message code="system.label.product.majorgroupcode" default="대분류코드"/>',		type:'string'},
	    	{name: 'ITEM_LEVEL_NAME1',	text: '<t:message code="system.label.product.majorgroup" default="대분류"/>',		type:'string'}
		]
	});	



	var MasterStore1 = Unilite.createStore('pmr820skrvMasterStore1',{
		model: 'pmr820skrvModel1',
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
				read: 'pmr820skrvService.selectList1'
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



	var masterGrid1 = Unilite.createGrid('pmr820skrvGrid1', {
		store : MasterStore1,
		region:'center',
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
			{dataIndex: 'ITEM_LEVEL1'		, width: 80,hidden: true},
			{dataIndex: 'ITEM_LEVEL_NAME1'		, width: 120},
			{dataIndex: 'REMARK'			, width: 500}
		]
	});		



	Unilite.Main({
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid1,  panelSearch
			]
		}],
		id: 'pmr820skrvApp',
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

