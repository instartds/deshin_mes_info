<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_sas300skrv_mit"  >
	<t:ExtComboStore comboType="BOR120" pgmId="s_sas300skrv_mit"/>
	<t:ExtComboStore comboType="AU" comboCode="S162"/>								<!-- 장비유형 -->
	<t:ExtComboStore comboType="AU" comboCode="S164"/>								<!-- 수리랭크 -->
	<t:ExtComboStore comboType="AU" comboCode="S168"/>								<!-- 위치 -->
	<t:ExtComboStore comboType="AU" comboCode="S169"/>								<!-- 증상 -->
	<t:ExtComboStore comboType="AU" comboCode="S170"/>								<!-- 원인 -->
	<t:ExtComboStore comboType="AU" comboCode="S171"/>								<!-- 해결 -->
	<t:ExtComboStore comboType="AU" comboCode="S163"/>								<!-- 진행상태 -->
	
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {  
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 's_sas300skrv_mitService.selectList'
		}
	});	
	
	Unilite.defineModel('s_sas300skrv_mitModel', {
	    fields: [  	    
	    	{name: 'DIV_CODE'				, text: '<t:message code="system.label.sales.division" default="사업장"/>'		    , type: 'string', comboType: 'BOR120'},
			{name: 'REPAIR_DATE'			, text: '<t:message code="system.label.sales.repairdate" default="수리일"/>'			, type: 'uniDate'},
			{name: 'REPAIR_NUM'				, text: '<t:message code="system.label.sales.repairnum" default="수리번호"/>'			, type: 'string'},
			{name: 'ITEM_CODE'				, text: '<t:message code="system.label.sales.item" default="품목"/>'					, type: 'string'},
			{name: 'ITEM_NAME'				, text: '<t:message code="system.label.sales.itemname" default="품목명"/>'			, type: 'string'},
			{name: 'CUSTOM_CODE'			, text: '<t:message code="system.label.sales.custom" default="거래처"/>'				, type: 'string'},
			{name: 'CUSTOM_NAME'			, text: '<t:message code="system.label.sales.customname" default="거래처명"/>'			, type: 'string'},
			{name: 'REPAIR_RANK'			, text: '<t:message code="system.label.sales.asrank" default="수리랭크"/>'				, type: 'string', comboType: 'AU', comboCode: 'S164'},
			{name: 'BAD_LOC_CODE'			, text: '<t:message code="system.label.sales.repairparts" default="위치"/>'			, type: 'string', comboType: 'AU', comboCode: 'S168'},
			{name: 'BAD_CONDITION_CODE'	    , text: '<t:message code="system.label.sales.repaircausescondition" default="증상"/>'	, type: 'string', comboType: 'AU', comboCode: 'S169'},
			{name: 'BAD_REASON_CODE'		, text: '<t:message code="system.label.sales.repaircauses" default="원인"/>'			, type: 'string', comboType: 'AU', comboCode: 'S170'},
			{name: 'SOLUTION_CODE'		    , text: '<t:message code="system.label.sales.repairsonlution" default="해결"/>'		, type: 'string', comboType: 'AU', comboCode: 'S171'},
			{name: 'BAD_LOC_CODE2'			, text: '<t:message code="system.label.sales.repairparts" default="위치"/>'			, type: 'string', comboType: 'AU', comboCode: 'S168'},
			{name: 'BAD_CONDITION_CODE2'	, text: '<t:message code="system.label.sales.repaircausescondition" default="증상"/>'	, type: 'string', comboType: 'AU', comboCode: 'S169'},
			{name: 'BAD_REASON_CODE2'		, text: '<t:message code="system.label.sales.repaircauses" default="원인"/>'			, type: 'string', comboType: 'AU', comboCode: 'S170'},
			{name: 'SOLUTION_CODE2'		    , text: '<t:message code="system.label.sales.repairsonlution" default="해결"/>'		, type: 'string', comboType: 'AU', comboCode: 'S171'},
			{name: 'BAD_LOC_CODE3'			, text: '<t:message code="system.label.sales.repairparts" default="위치"/>'			, type: 'string', comboType: 'AU', comboCode: 'S168'},
			{name: 'BAD_CONDITION_CODE3'	, text: '<t:message code="system.label.sales.repaircausescondition" default="증상"/>'	, type: 'string', comboType: 'AU', comboCode: 'S169'},
			{name: 'BAD_REASON_CODE3'		, text: '<t:message code="system.label.sales.repaircauses" default="원인"/>'			, type: 'string', comboType: 'AU', comboCode: 'S170'},
			{name: 'SOLUTION_CODE3'		    , text: '<t:message code="system.label.sales.repairsonlution" default="해결"/>'		, type: 'string', comboType: 'AU', comboCode: 'S171'},
			{name: 'RECEIPT_NUM'		    , text: '<t:message code="system.label.sales.receiptnum" default="접수번호"/>'			, type: 'string'},
			{name: 'MACHINE_TYPE'		    , text: '<t:message code="system.label.sales.equipmenttype" default="장비유형"/>'		, type: 'string', comboType: 'AU', comboCode: 'S162'},
			{name: 'SERIAL_NO'		        , text: 'S/N'		, type: 'string'},
			{name: 'AS_STATUS'		        , text: '<t:message code="system.label.sales.processstatus" default="진행상태"/>'		, type: 'string', comboType: 'AU', comboCode: 'S163'}
		]
	});
	
	var directMasterStore = Unilite.createStore('s_sas300skrv_mitMasterStore',{
		model: 's_sas300skrv_mitModel',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: false,			// 수정 모드 사용 
            deletable: false,			// 삭제 가능 여부 
	        useNavi: false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy:directProxy,
        loadStoreRecords: function() {
        	var serialNo = panelResult.getValue("SERIAL_NO");
        	var receiptDateFr = UniDate.getDbDateStr( panelResult.getValue("REPAIR_DATE_FR"));
        	var receiptDateTo = UniDate.getDbDateStr( panelResult.getValue("REPAIR_DATE_TO"));
        	if(Ext.isEmpty(serialNo) && (Ext.isEmpty(receiptDateFr) || Ext.isEmpty(receiptDateTo)))	{
        		Unilite.messageBox("접수일 또는 S/N 두 항목 중 하나는 입력해야 합니다.")
        		return;
        	}
        	if(panelResult.getInvalidMessage())	{
				var param= Ext.getCmp('resultForm').getValues();			
				this.load({
					params : param
				});
        	}
		},
		
	});
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>'  ,
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			value		: UserInfo.divCode,
			allowBlank	: false,
			labelWidth   : 90
		},{
			fieldLabel		: '<t:message code="system.label.sales.receiptdate2" default="접수일"/>',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'REPAIR_DATE_FR',
			endFieldName	: 'REPAIR_DATE_TO',
			labelWidth       : 90,
			startDate		: UniDate.get('startOfMonth'),
			endDate			: UniDate.get('today')
		}
		,Unilite.popup('SAS_LOT', {allowInputData : true})
		,Unilite.popup('DIV_PUMOK',{
			fieldLabel:'<t:message code="system.label.sales.asitemcode" default="A/S 품목"/>',
			width:300,
			labelWidth       : 90
		 })
		,Unilite.popup('CUST',{
			fieldLabel:'<t:message code="system.label.sales.custom" default="거래처"/>',
			width:300,
			labelWidth       : 90,
			colspan         : 2
		})]
	});	
	
    var masterGrid = Unilite.createGrid('s_sas300skrv_mitGrid', {
        store: directMasterStore,
    	excelTitle: '품목코드',
    	region: 'center',
    	flex:1,
        uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: false,
			useMultipleSorting: true,
			useRowNumberer: true,
			expandLastColumn: false,
			onLoadSelectFirst: true,
			copiedRow:true,
    		filter: {
				useFilter: false,
				autoCreate: false
			}
        },
        columns:  [
        	{ dataIndex: 'REPAIR_DATE' 			, width: 100 },
            { dataIndex: 'REPAIR_NUM'			, width: 100 },
            { dataIndex: 'ITEM_CODE'			, width: 80},
			{ dataIndex: 'ITEM_NAME'			, width: 130},
			{ dataIndex: 'SERIAL_NO'			, width: 100 },
			{ dataIndex: 'CUSTOM_CODE'			, width: 80},
			{ dataIndex: 'CUSTOM_NAME'			, width: 100},
			{ dataIndex: 'REPAIR_RANK'			, width: 100},
			{ dataIndex: 'BAD_LOC_CODE'			, width: 80 },
			{ dataIndex: 'BAD_CONDITION_CODE'	, width: 80},
			{ dataIndex: 'BAD_REASON_CODE'		, width: 80 },
			{ dataIndex: 'SOLUTION_CODE'		, width: 80 },
			{ dataIndex: 'RECEIPT_NUM'			, width: 110 },
			{ dataIndex: 'MACHINE_TYPE'			, width: 80 },
			{ dataIndex: 'AS_STATUS'			, width: 80 }
		],
		listeners:{
			afterrender: function(grid) {
				var me = this;
				this.contextMenu = Ext.create('Ext.menu.Menu', {});
				
				this.contextMenu.add({
					text: '<t:message code="system.label.sales.registerasreceipt" default="A/S 접수등록"/>',   iconCls : '',
					handler: function(menuItem, event) {
						var records = grid.getSelectionModel().getSelection();
						var record = records[0];
						var params = {
							DIV_CODE: record.get("DIV_CODE"),
							RECEIPT_NUM: record.get('RECEIPT_NUM'),
							SERIAL_NO : record.get('SERIAL_NO')
						}
						var rec = {data : {prgID : 's_sas100ukrv_mit', 'text':''}};
						parent.openTab(rec, '/z_mit/s_sas100ukrv_mit.do', params);
					}
				});
				this.contextMenu.add({
					text: '<t:message code="system.label.sales.registerrepairestimate" default="수리견적등록"/>',   iconCls : '',
					handler: function(menuItem, event) {
						var records = grid.getSelectionModel().getSelection();
						var record = records[0];
						var params = {
							DIV_CODE: record.get("DIV_CODE"),
							RECEIPT_NUM: record.get('RECEIPT_NUM'),
							QUOT_NUM: record.get('QUOT_NUM'),
							SERIAL_NO : record.get('SERIAL_NO')
						}
						var rec = {data : {prgID : 's_sas200ukrv_mit', 'text':''}};
						parent.openTab(rec, '/z_mit/s_sas200ukrv_mit.do', params);
					}
				});
				this.contextMenu.add({
					text: '<t:message code="system.label.sales.registerrepair" default="수리등록"/>',   iconCls : '',
					handler: function(menuItem, event) {
						var records = grid.getSelectionModel().getSelection();
						var record = records[0];
						var params = {
							DIV_CODE: record.get("DIV_CODE"),
							RECEIPT_NUM: record.get('RECEIPT_NUM'),
							QUOT_NUM: record.get('QUOT_NUM'),
							REPAIR_NUM: record.get('REPAIR_NUM'),
							SERIAL_NO : record.get('SERIAL_NO')
						}
						var rec = {data : {prgID : 's_sas300ukrv_mit', 'text':''}};
						parent.openTab(rec, '/z_mit/s_sas300ukrv_mit.do', params);
					}
				});
			}
		}
    });  
    
	Unilite.Main( {
		borderItems:[
			panelResult,masterGrid
		],
		id: 's_sas300skrv_mitApp',
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['reset','newData'],true);
			UniAppManager.setToolbarButtons(['save'],false);
		},
		onQueryButtonDown: function()	{
			directMasterStore.loadStoreRecords();
		},
		onResetButtonDown: function() {		
			masterGrid.reset();
			panelResult.clearForm();
			directMasterStore.clearData();
			this.fnInitBinding();
		}
	});
};


</script>
