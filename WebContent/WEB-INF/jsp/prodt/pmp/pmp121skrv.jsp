<%@page language="java" contentType="text/html; charset=utf-8"%> 
<t:appConfig pgmId="pmp121skrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="pmp121skrv" /> <!-- 사업장 -->
	<t:ExtComboStore comboType="W" /><!-- 작업장  -->
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'pmp121skrvService.selectList2'
		}
	});
	var directProxy3 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'pmp121skrvService.selectList3'
		}
	});
	/**
	 * Model 정의
	 * 
	 * @type
	 */				
	Unilite.defineModel('pmp121skrvModel1', {
		fields: [  	 
			{name: 'WK_PLAN_NUM'	,text: '<t:message code="system.label.product.productionplanno" default="생산계획번호"/>'			,type: 'string' },
			{name: 'WK_PLAN_Q'		,text: '<t:message code="system.label.product.productionplanquantity" default="생산계획량"/>'	,type: 'uniQty'},
			{name: 'ITEM_CODE'		,text: '<t:message code="system.label.product.spec" default="규격"/>'							,type: 'string'},
			{name: 'ITEM_NAME'		,text: '<t:message code="system.label.product.unit" default="단위"/>'							,type: 'string'},
			{name: 'ITEM_NAME1'		,text: '<t:message code="system.label.product.itemname" default="품목명"/>1'					,type: 'string'},
			{name: 'SEQ'			,text: '<t:message code="system.label.product.seq" default="순번"/>'							,type: 'int'}
		]  
	});		// End of Unilite.defineModel('pmp121skrvModel', {
	
	Unilite.defineModel('pmp121skrvModel2', {
		fields: [  	 
			{name: 'WORK_END_YN'		,text: '<t:message code="system.label.product.status" default="상태"/>'				,type: 'string' , comboType:'AU', comboCode:'P001'},
			{name: 'WKORD_NUM'			,text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>'		,type: 'string'},
			{name: 'ITEM_CODE'			,text: '<t:message code="system.label.product.item" default="품목"/>'					,type: 'string'},
			{name: 'ITEM_NAME'			,text: '<t:message code="system.label.product.itemname" default="품목명"/>'			,type: 'string'},
			{name: 'ITEM_NAME1'			,text: '<t:message code="system.label.product.itemname" default="품목명"/>1'			,type: 'string'},
			{name: 'SPEC'				,text: '<t:message code="system.label.product.spec" default="규격"/>'					,type: 'string'},
			{name: 'STOCK_UNIT'			,text: '<t:message code="system.label.product.unit" default="단위"/>'					,type: 'string'},
			{name: 'PRODT_START_DATE'	,text: '<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>'	,type: 'uniDate'},
			{name: 'PRODT_END_DATE'		,text: '<t:message code="system.label.product.completiondate" default="완료예정일"/>'	,type: 'uniDate'},
			{name: 'WKORD_Q'			,text: '<t:message code="system.label.product.workorderqty" default="작업지시량"/>'		,type: 'uniQty'},
			{name: 'PRODT_Q'			,text: '<t:message code="system.label.product.productionqty" default="생산량"/>'		,type: 'uniQty'},
			{name: 'REMARK1'			,text: '<t:message code="system.label.product.remarks" default="비고"/>'				,type: 'string'},
			{name: 'ORDER_NUM'			,text: '<t:message code="system.label.product.sono" default="수주번호"/>'				,type: 'string'},
			{name: 'ORDER_Q'			,text: '<t:message code="system.label.product.soqty" default="수주량"/>'				,type: 'uniQty'},
			{name: 'DVRY_DATE'			,text: '<t:message code="system.label.product.deliverydate" default="납기일"/>'		,type: 'uniDate'},
			{name: 'REMARK2'			,text: '<t:message code="system.label.product.customname" default="거래처명"/>'			,type: 'string'},
			{name: 'WK_PLAN_NUM'		,text: '<t:message code="system.label.product.planno" default="계획번호"/>'				,type: 'string'},
			{name: 'SPRODT_Q'			,text: '<t:message code="system.label.product.productiontotal" default="생산누계"/>'	,type: 'uniQty'}
		]  
	});	
	Unilite.defineModel('pmp121skrvModel3', {
		fields: [  	 
			{name: 'PROG_WORK_CODE'		,text: '<t:message code="system.label.product.routingcode" default="공정코드"/>'		,type: 'string'},
			{name: 'PROG_WORK_NAME'		,text: '<t:message code="system.label.product.routingname" default="공정명"/>'			,type: 'string'},
			{name: 'PROG_UNIT'			,text: '<t:message code="system.label.product.unit" default="단위"/>'					,type: 'string'},
			{name: 'PRODT_DATE'			,text: '<t:message code="system.label.product.productiondate" default="생산일"/>'		,type: 'uniDate'},
			{name: 'PRODT_Q'			,text: '<t:message code="system.label.product.productionqty" default="생산량"/>'		,type: 'uniQty'},
			{name: 'MAN_HOUR'			,text: '<t:message code="system.label.product.inputtime" default="투입공수"/>'			,type: 'uniQty'},
			{name: 'PRORE_Q'			,text: '<t:message code="system.label.product.productionleftqty" default="생산잔량"/>'	,type: 'uniQty'},
			{name: 'WKORD_NUM'			,text: '<t:message code="system.label.product.workorderno2" default="작지번호"/>'		,type: 'string'},
			{name: 'LINE_SEQ'			,text: '<t:message code="system.label.product.routingorder" default="공정순서"/>'		,type: 'string'},
			{name: 'PRODT_START_DATE'	,text: '<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>'	,type: 'uniDate'},
			{name: 'PRODT_END_DATE'		,text: '<t:message code="system.label.product.completiondate" default="완료예정일"/>'	,type: 'uniDate'}
		]
	});
				
	var MasterStore1 = Unilite.createStore('pmp121skrvMasterStore1',{
		model: 'pmp121skrvModel1',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결
			editable: false,			// 수정 모드 사용
			deletable: false,			// 삭제 가능 여부
			useNavi: false			// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {			
				read: 'pmp121skrvService.selectList1'
			}
		},
		loadStoreRecords: function(record){
			var param= panelSearch.getValues();	
			param.WK_PLAN_NUM = record.get('WK_PLAN_NUM');
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
	});		// End of var directMasterStore1 =
			// Unilite.createStore('pmp121skrvMasterStore1',{
	
	var MasterStore2 = Unilite.createStore('pmp121skrvMasterStore2',{
			model: 'pmp121skrvModel2',
			uniOpt : {
				isMaster: false,			// 상위 버튼 연결
				editable: false,			// 수정 모드 사용
				deletable: false,			// 삭제 가능 여부
				useNavi: false			// prev | next 버튼 사용
			},
			autoLoad: false,
			proxy:directProxy2,
			loadStoreRecords: function(){
				var param= Ext.getCmp('searchForm').getValues();			
				console.log( param );
				this.load({
					params: param
				});
				
		}
	});
		var MasterStore3 = Unilite.createStore('pmp121skrvMasterStore3',{
			model: 'pmp121skrvModel3',
			uniOpt : {
				isMaster: false,			// 상위 버튼 연결
				editable: false,			// 수정 모드 사용
				deletable: false,			// 삭제 가능 여부
				useNavi: false			// prev | next 버튼 사용
			},
			autoLoad: false,
			proxy:directProxy3,
			loadStoreRecords: function(record){
				var param= panelSearch.getValues();
				param.WKORD_NUM = record.get('WKORD_NUM');
				this.load({
					params : param
				});
		 	}
	});
	
	/**
	 * 검색조건 (Search Panel)
	 * 
	 * @type
	 */
	var panelSearch = Unilite.createSearchForm('searchForm', {
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
		},Unilite.popup('DIV_PUMOK',{ 
				fieldLabel: '<t:message code="system.label.product.item" default="품목"/>', 
				valueFieldName: 'ITEM_CODE',
				textFieldName:'ITEM_NAME',
				validateBlank: false,
				listeners: {
					onValueFieldChange: function( elm, newValue, oldValue ) {
						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('ITEM_NAME', '');
						}
					},
					onTextFieldChange: function( elm, newValue, oldValue ) {
						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('ITEM_CODE', '');
						}
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}
		}),{
				fieldLabel: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>',
				xtype: 'uniTextfield',
				name: 'WKORD_NUM'
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
		},{
			fieldLabel: '<t:message code="system.label.product.workorderdate" default="작업지시일"/>',
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
				inputValue: '0', 
				checked: true
			},{
				boxLabel: '<t:message code="system.label.product.batch" default="일괄"/>', 
				width:130, 
				name: 'OPT', 
				inputValue: '1'
			},{
				boxLabel: '<t:message code="system.label.product.urgency" default="긴급"/>', 
				width:130, 
				name: 'OPT', 
				inputValue: '2'
			}]
			,listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					
					
					
				}
			}
		}]
	});
	/**
	 * Master Grid1 정의(Grid Panel)
	 * 
	 * @type
	 */
	var masterGrid1 = Unilite.createGrid('pmp121skrvGrid1', {
		store : MasterStore1,
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
			},
			state: {
		    	useState: false,	//그리드 설정 버튼 사용 여부 
		   		useStateList: false	//그리드 설정 목록 사용 여부 
			}
		},
		features: [
			{id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
			{id : 'masterGridTotal' ,   ftype: 'uniSummary', 		 showSummaryRow: false}
		],
		columns:  [
		
			{ dataIndex: 'WK_PLAN_NUM'	, width: 126},
			{ dataIndex: 'WK_PLAN_Q'	, width: 120},
			{
				text:'<t:message code="system.label.product.item" default="품목"/>',
				columns:[{ dataIndex: 'ITEM_CODE', width: 175}]
			},{
				text:'<t:message code="system.label.product.itemname" default="품목명"/>',
				columns:[{ dataIndex: 'ITEM_NAME', width: 220}]
			},
			{ dataIndex: 'ITEM_NAME1'	, width: 220, hidden: true},
			{ dataIndex: 'SEQ'			, width: 70, hidden: true}
		]
			
	});		
	var masterGrid2 = Unilite.createGrid('pmp121skrvGrid2', {
		store : MasterStore2,
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
			{id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
			{id : 'masterGridTotal' ,   ftype: 'uniSummary', 		 showSummaryRow: false}
		],
		columns:  [
			{dataIndex: 'WORK_END_YN'		, width: 100,hidden:true},
			{dataIndex: 'WKORD_NUM'			, width: 130},
			{dataIndex: 'ITEM_CODE'			, width: 130},
			{dataIndex: 'ITEM_NAME'			, width: 150},
			{dataIndex: 'ITEM_NAME1'		, width: 150,hidden:true},
			{dataIndex: 'SPEC'				, width: 140},
			{dataIndex: 'STOCK_UNIT'		, width: 100},
			{dataIndex: 'PRODT_START_DATE'	, width: 100,hidden:true},
			{dataIndex: 'PRODT_END_DATE'	, width: 100,hidden:true},
			{dataIndex: 'WKORD_Q'			, width: 100},
			{dataIndex: 'PRODT_Q'			, width: 100,hidden:true},
			{dataIndex: 'REMARK1'			, width: 100,hidden:true},
			{dataIndex: 'ORDER_NUM'			, width: 100,hidden:true},
			{dataIndex: 'ORDER_Q'			, width: 100,hidden:true},
			{dataIndex: 'DVRY_DATE'			, width: 100,hidden:true},
			{dataIndex: 'REMARK2'			, width: 100,hidden:true},
			{dataIndex: 'WK_PLAN_NUM'		, width: 100,hidden:true},
			{dataIndex: 'SPRODT_Q'			, width: 100}
			
		] ,
		selModel: 'rowmodel',		// 조회화면 selectionchange event 사용
		listeners: {
			/*
			 * cellclick: function( viewTable, td, cellIndex, record, tr,
			 * rowIndex, e, eOpts , colName) {
			 * MasterStore2.loadStoreRecords(record); this.returnCell(record); },
			 */
   		  selectionchange:function( model1, selected, eOpts ){
				if(selected.length > 0)	{
					var record = selected[0];
//					MasterStore2.loadData({})
					MasterStore1.loadStoreRecords(record);
					MasterStore3.loadStoreRecords(record);
					
				}
			}
		}
	});		
	var masterGrid3 = Unilite.createGrid('pmp121skrvGrid3', {
		store : MasterStore3,
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
			{id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
			{id : 'masterGridTotal' ,   ftype: 'uniSummary', 		 showSummaryRow: false}
		],
		columns:  [
			{dataIndex: 'PROG_WORK_CODE'	, width: 100,hidden:true},
			{dataIndex: 'PROG_WORK_NAME'	, width: 200},
			{dataIndex: 'PROG_UNIT'			, width: 100},
			{dataIndex: 'PRODT_DATE'		, width: 100},
			{dataIndex: 'PRODT_Q'			, width: 100,hidden:true},
			{dataIndex: 'MAN_HOUR'			, width: 100},
			{dataIndex: 'PRORE_Q'			, width: 100},
			{dataIndex: 'WKORD_NUM'			, width: 100,hidden:true},
			{dataIndex: 'LINE_SEQ'			, width: 100,hidden:true},
			{dataIndex: 'PRODT_START_DATE'	, width: 100,hidden:true},
			{dataIndex: 'PRODT_END_DATE'	, width: 100,hidden:true}
		] 
	});		
	Unilite.Main({
		items: [panelSearch,{
				xtype: 'container',
				flex: 1,
				layout: 'border',
				items: [{
					region : 'north',
					xtype  : 'container',
					layout : 'fit',
					height : "55%",
					layout: {
						type: 'hbox',
						align: 'stretch'
					},
					items: [masterGrid1, masterGrid2]
				},{ 
					region : 'center',
					xtype  : 'container',
					layout : 'fit',
					items: [masterGrid3]
				}]
			}],
		id: 'pmp121skrvApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('save',false);
			
			panelSearch.setValue('PRODT_START_DATE', UniDate.get('mondayOfWeek'));
			panelSearch.setValue('PRODT_END_DATE', UniDate.get('sundayOfNextWeek'));
		},
		onQueryButtonDown : function()	{		
			if(panelSearch.getInvalidMessage()){
				MasterStore2.loadStoreRecords();
			}
		},
		onResetButtonDown: function() {		// 초기화
			panelSearch.reset();
			masterGrid1.reset();
			masterGrid2.reset();
			masterGrid3.reset();
			this.fnInitBinding();
		}
	});		// End of Unilite.Main({
};
</script>

