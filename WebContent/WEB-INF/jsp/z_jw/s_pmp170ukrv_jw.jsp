<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_pmp170ukrv_jw"  >
	<t:ExtComboStore comboType="BOR120" pgmId="s_pmp170ukrv_jw" />		<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="P507"  />		<!-- 주야구분 -->  
	<t:ExtComboStore comboType="AU" comboCode="P506"  />		<!-- 호기 -->  
	<t:ExtComboStore comboType="AU" comboCode="P505"  />		<!-- 작업자 -->  
	<t:ExtComboStore items="${COMBO_WS_LIST}" storeId="wsList" />		<!-- 작업장 -->  
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLevel1" /> <!-- 대분류 -->

</t:appConfig>
<script type="text/javascript" >

function appMain() {
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 's_pmp170ukrv_jwService.selectList',
			update: 's_pmp170ukrv_jwService.updateDetail',
			syncAll: 's_pmp170ukrv_jwService.saveAll'
		}
	});
	
	Unilite.defineModel('s_pmp170ukrv_jwModel', {
		fields: [
			{name: 'COMP_CODE'			, text: '<t:message code="system.label.product.companycode" default="법인코드"/>'		, type: 'string'},
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.product.division" default="사업장"/>'			, type: 'string'},
			{name: 'PRODT_START_DATE'	, text: '<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>'	, type: 'uniDate'},
			{name: 'WORK_SHOP_CODE'		, text: '<t:message code="system.label.product.workcenter" default="작업장"/>'			, type: 'string'},
			{name: 'WORK_SHOP_NAME'		, text: '<t:message code="system.label.product.workcentername" default="작업장명"/>'	, type: 'string'},
			{name: 'WKORD_NUM'			, text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>'		, type: 'string'},
			{name: 'PROG_WORK_CODE'		, text: '<t:message code="system.label.product.routingcode" default="공정코드"/>'		, type: 'string'},
			{name: 'PROG_WORK_NAME'		, text: '<t:message code="system.label.product.routingname" default="공정명"/>'		, type: 'string'},
			{name: 'DAY_NIGHT'			, text: '<t:message code="system.label.product.daynightclass" default="주야구분"/>'		, type: 'string' , comboType:'AU', comboCode:'P507'},
			{name: 'PRODT_MACH'			, text: '<t:message code="system.label.product.Workingmachine" default="작업호기"/>'	, type: 'string' , comboType:'AU', comboCode:'P506'},
			{name: 'ITEM_LEVEL1'		, text: '<t:message code="system.label.product.itemclass" default="품목구분"/>'			, type: 'string' , store: Ext.data.StoreManager.lookup('itemLevel1')},
			{name: 'PRODT_PRSN'			, text: '<t:message code="system.label.product.worker" default="작업자"/>'				, type: 'string' ,comboType:'AU',comboCode:'P505'},
			{name: 'PRODT_TIME'			, text: '<t:message code="system.label.product.workhour" default="작업시간"/>'			, type: 'string' , maxLength: 11},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.product.item" default="품목"/>'				, type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.product.itemname" default="품목명"/>'			, type: 'string'},
			{name: 'SPEC'				, text: '<t:message code="system.label.product.spec" default="규격"/>'				, type: 'string'},
			{name: 'WKORD_Q'			, text: '<t:message code="system.label.product.workorderqty" default="작업지시량"/>'		, type: 'uniQty'},
			{name: 'PRODT_Q'			, text: '<t:message code="system.label.product.productionqty" default="생산량"/>'		, type: 'uniQty'},
			{name: 'REMARK1'			, text: '<t:message code="system.label.product.remarks" default="비고"/>'				, type: 'string'},
			{name: 'WORK_END_YN'		, text: '<t:message code="system.label.product.status" default="상태"/>'				, type: 'string' , comboType:'AU', comboCode:'P001'},
			{name: 'STOCK_UNIT'			, text: '<t:message code="system.label.product.unit" default="단위"/>'				, type: 'string'},
			{name: 'PRODT_END_DATE'		, text: '<t:message code="system.label.product.completiondate" default="완료예정일"/>'	, type: 'uniDate'},
			{name: 'PROJECT_NO'			, text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'		, type: 'string'},
			{name: 'ORDER_NUM'			, text: '<t:message code="system.label.product.sono" default="수주번호"/>'				, type: 'string'},
			{name: 'ORDER_Q'			, text: '<t:message code="system.label.product.soqty" default="수주량"/>'				, type: 'uniQty'},
			{name: 'DVRY_DATE'			, text: '<t:message code="system.label.product.deliverydate" default="납기일"/>'		, type: 'uniDate'},
			{name: 'LOT_NO'				, text: '<t:message code="system.label.product.lotno" default="LOT번호"/>'			, type: 'string'},
			{name: 'REMARK2'			, text: '<t:message code="system.label.product.customname" default="거래처명"/>'		, type: 'string'}
		]
	});
	
	var directMasterStore = Unilite.createStore('s_pmp170ukrv_jwMasterStore1',{
		model: 's_pmp170ukrv_jwModel',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결 
			editable: true,			// 수정 모드 사용 
			deletable: false,			// 삭제 가능 여부 
			useNavi: false			// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy: directProxy,
		saveStore: function() {
			var inValidRecs = this.getInvalidRecords();
			var paramMaster= panelResult.getValues();
			if(inValidRecs.length == 0){
				var config = {
					params:[paramMaster],
					success : function()	{
						UniAppManager.app.onQueryButtonDown();
					}
				}
				this.syncAllDirect(config);	
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		loadStoreRecords: function() {
			var param= panelResult.getValues();
			console.log( param );
			this.load({
				params: param
			});
		},
		groupField: 'PROG_WORK_NAME'
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
		region: 'north',
		layout : {type : 'uniTable', columns : 2},
		padding:'1 1 1 1',
		border:true,
		items:[{
			fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
			name: 'DIV_CODE',
			value : UserInfo.divCode,
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			allowBlank: false
		},{
			fieldLabel: '<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'PRODT_START_DATE_FR',
			endFieldName: 'PRODT_START_DATE_TO',
			width: 315,
			startDate: UniDate.get('mondayOfWeek'),
			endDate: UniDate.get('sundayOfNextWeek')
		},{
			fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
			name: 'WORK_SHOP_CODE',
			xtype: 'uniCombobox',
			store: Ext.data.StoreManager.lookup('wsList'),
			listeners: {
				beforequery:function( queryPlan, eOpts )	{
					var store = queryPlan.combo.store;
					store.clearFilter();
					store.filterBy(function(record){
						return record.get('value') == 'WC10' || record.get('value') == 'WC20';
					});
				}
			}
		},{
			xtype: 'container',
			layout: {type : 'uniTable', columns : 3},
			width:285,
			items :[{
				fieldLabel:'<t:message code="system.label.product.workorderno" default="작업지시번호"/>', 
				xtype: 'uniTextfield',
				name: 'WKORD_NUM_FR'
			},{
				xtype:'component', 
				html:'~',
				style: {
					marginTop: '3px !important',
					font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
				}
			},{
				fieldLabel:'', 
				xtype: 'uniTextfield',
				name: 'WKORD_NUM_TO' 
			}]
		}]
	});
	
	var masterGrid = Unilite.createGrid('s_pmp170ukrv_jwGrid1', {
		layout: 'fit',
		region: 'center',
		uniOpt:{
			expandLastColumn: false,
			useLiveSearch: false,
			useContextMenu: false,
			useMultipleSorting: false,
			useGroupSummary: false,
			useRowNumberer: false,
			filter: {
				useFilter: true,
				autoCreate: true
			}
		},
		features: [{
			id: 'masterGridSubTotal', 
			ftype: 'uniGroupingsummary', 
			showSummaryRow: true
		},{
			id: 'masterGridTotal', 
			ftype: 'uniSummary', 
			showSummaryRow: true
		}],
		store: directMasterStore,
		columns: [
			{dataIndex: 'COMP_CODE'				, width: 100	,hidden:true},
			{dataIndex: 'DIV_CODE'				, width: 100	,hidden:true},
			{dataIndex: 'PRODT_START_DATE'		, width: 100},
			{dataIndex: 'WORK_SHOP_CODE'		, width: 100	,hidden:true},
			{dataIndex: 'WORK_SHOP_NAME'		, width: 120},
			{dataIndex: 'WKORD_NUM'				, width: 120},
			{dataIndex: 'PROG_WORK_CODE'		, width: 100	,hidden:true},
			{dataIndex: 'PROG_WORK_NAME'		, width: 100,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
						return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.product.subtotal" default="소계"/>', '<t:message code="system.label.product.total" default="총계"/>');
				}
			},
			{dataIndex: 'DAY_NIGHT'	 			, width: 80	},
			{dataIndex: 'PRODT_MACH'			, width: 80	},
  			{dataIndex: 'ITEM_LEVEL1'			, width: 100},
			{dataIndex: 'PRODT_PRSN'			, width: 150},
			{dataIndex: 'PRODT_TIME'			, width: 120},
			{dataIndex: 'ITEM_CODE'				, width: 100},
			{dataIndex: 'ITEM_NAME'				, width: 250},
			{dataIndex: 'SPEC'					, width: 150},
			{dataIndex: 'WKORD_Q'				, width: 100	,summaryType:'sum'},
			{dataIndex: 'PRODT_Q'				, width: 100	,summaryType:'sum'},
			{dataIndex: 'REMARK1'				, flex:1},
			{dataIndex: 'WORK_END_YN'			, width: 100	,hidden:true},
			{dataIndex: 'STOCK_UNIT'			, width: 100	,hidden:true},
			{dataIndex: 'PRODT_END_DATE'		, width: 100	,hidden:true},
			{dataIndex: 'PROJECT_NO'			, width: 100	,hidden:true},
			{dataIndex: 'ORDER_NUM'				, width: 100	,hidden:true},
			{dataIndex: 'ORDER_Q'				, width: 100	,hidden:true},
			{dataIndex: 'DVRY_DATE'				, width: 100	,hidden:true},
			{dataIndex: 'LOT_NO'				, width: 100	,hidden:true},
			{dataIndex: 'REMARK2'				, width: 100	,hidden:true}
		],
		listeners: {
			beforeedit:function(editor, e, eOpts) {
				if(UniUtils.indexOf(e.field, ['DAY_NIGHT','PRODT_MACH','PRODT_PRSN','PRODT_TIME'])){
					return true;
				}else{
					return false;
				}
			}
		}
	});  
	
	Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult
			]
		}],	
		id: 's_pmp170ukrv_jwApp',
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons(['newData','delete','save'], false);
			panelResult.setValue('DIV_CODE', UserInfo.divCode);
			panelResult.setValue('PRODT_START_DATE_FR', UniDate.get('mondayOfWeek'));
			panelResult.setValue('PRODT_START_DATE_TO', UniDate.get('sundayOfNextWeek'));
		},
		onQueryButtonDown: function() {
			if(!panelResult.getInvalidMessage()) return;	//필수체크
			directMasterStore.loadStoreRecords();
		},
		onResetButtonDown: function() {
			panelResult.clearForm();
			masterGrid.reset();
			directMasterStore.clearData();
			this.fnInitInputFields();
		},
		onSaveDataButtonDown: function() {
			directMasterStore.saveStore();
		},
		fnInitInputFields: function(){
			UniAppManager.setToolbarButtons(['newData','delete','save'], false);
			
			panelResult.setValue('DIV_CODE', UserInfo.divCode);
			panelResult.setValue('PRODT_START_DATE_FR', UniDate.get('mondayOfWeek'));
			panelResult.setValue('PRODT_START_DATE_TO', UniDate.get('sundayOfNextWeek'));
		}
	});
};
</script>
