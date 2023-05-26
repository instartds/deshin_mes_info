<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_sas100skrv_mit"  >
	<t:ExtComboStore comboType="BOR120" pgmId="s_sas100skrv_mit"/>
	<t:ExtComboStore comboType="AU" comboCode="S162"/>								<!-- 장비유형 -->
	<t:ExtComboStore comboType="AU" comboCode="S163"/>								<!-- 진행상태 -->
	<t:ExtComboStore comboType="AU" comboCode="S164"/>								<!-- 수리랭크 -->
	<t:ExtComboStore comboType="AU" comboCode="S166"/>								<!-- 보증기간 -->
	<t:ExtComboStore comboType="AU" comboCode="S167"/>								<!-- 유지보수등급 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {  
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 's_sas100skrv_mitService.selectList'
		}
	});	
	
	Unilite.defineModel('s_sas100skrv_mitModel', {
	    fields: [  	    
	    	{name: 'DIV_CODE'			, text: '<t:message code="system.label.sales.division" default="사업장"/>'			, type: 'string'},
	    	{name: 'RECEIPT_NUM'		, text: '<t:message code="system.label.sales.receiptnum" default="접수번호"/>'			, type: 'string'},
			{name: 'RECEIPT_DATE'		, text: '<t:message code="system.label.sales.receiptdate2" default="접수일"/>'		, type: 'uniDate'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.sales.item" default="품목"/>'					, type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.sales.itemname" default="품목명"/>'			, type: 'string'},
			{name: 'SPEC'				, text: '<t:message code="system.label.sales.spec" default="규격"/>'				 	, type: 'string'},
			{name: 'SERIAL_NO'			, text: '<t:message code="system.label.sales.asserialno" default="S/N"/>'			, type: 'string'},
			{name: 'CUSTOM_CODE'		, text: '<t:message code="system.label.sales.custom" default="거래처"/>'				, type: 'string'},
			{name: 'CUSTOM_NAME'		, text: '<t:message code="system.label.sales.customname" default="거래처명"/>'			, type: 'string'},
			{name: 'USER_NAME'			, text: '<t:message code="system.label.sales.charger" default="담당자"/>'				, type: 'string'},
			{name: 'SALE_DATE'			, text: '매출일'																		, type: 'uniDate'},
			{name: 'AS_STATUS'		    , text: '<t:message code="system.label.sales.processstatus" default="진행상태"/>'		, type: 'string', comboType: 'AU', comboCode: 'S163'},
			{name: 'REPAIR_DATE'		, text: '<t:message code="system.label.sales.repairdate" default="수리일"/>'			, type: 'uniDate'},
			{name: 'REPAIR_RANK'		, text: '<t:message code="system.label.sales.asrank" default="수리랭크"/>'				, type: 'string', comboType: 'AU', comboCode: 'S164'},
			{name: 'INSPEC_FLAG'		, text: '수리상태'																		, type: 'string', comboType: 'AU', comboCode: 'S165'},
	    	{name: 'OUT_DATE'			, text: '출고일' 			, type: 'uniDate'},
	    	{name: 'SALE_DATE'			, text: '매출일' 			, type: 'uniDate'},
			{name: 'REPAIR_NUM'			, text: '수리번호'			, type: 'string'},
			{name: 'QUPT_NUM'			, text: '수리견적번호'		, type: 'string'},
			{name: 'OUT_PRSN'			, text: '출고담당자'			, type: 'string'},
			{name: 'OUT_PRSN_NAME'		, text: '출고담당자명'		, type: 'string'},
			{name: 'INSPEC_DATE'		, text: '검사일'				, type: 'string'}
		]
	});
	
	var directMasterStore = Unilite.createStore('s_sas100skrv_mitMasterStore',{
		model: 's_sas100skrv_mitModel',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: false,			// 수정 모드 사용 
            deletable: false,			// 삭제 가능 여부 
	        useNavi: false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy:directProxy,
        loadStoreRecords: function() {
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
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>'  ,
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			value		: UserInfo.divCode,
			allowBlank	: false,
			width       : 250,
			labelWidth   : 90
		},{
			fieldLabel		: '<t:message code="system.label.sales.receiptdate2" default="접수일"/>',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'RECEIPT_DATE_FR',
			endFieldName	: 'RECEIPT_DATE_TO',
			allowBlank	    : false,
			labelWidth       : 90,
			startDate		: UniDate.get('startOfMonth'),
			endDate			: UniDate.get('today')
		},{
			fieldLabel		: '출고일',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'OUT_DATE_FR',
			endFieldName	: 'OUT_DATE_TO',
			labelWidth      : 90/* ,
			startDate		: UniDate.get('startOfMonth'),
			endDate			: UniDate.get('today') */
		},{
			fieldLabel : '<t:message code="system.label.sales.processstatus" default="진행상태"/>'  ,
			name : 'AS_STATUS',
			xtype : 'uniCombobox',
			comboType : 'AU',
			comboCode : 'S163'
		}
		,Unilite.popup('SAS_LOT', {
			  allowInputData : true
			, listeners : {
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': panelResult.getValue("DIV_CODE")});
				}
			}})
		,Unilite.popup('DIV_PUMOK',{
			fieldLabel:'<t:message code="system.label.sales.asitemcode" default="A/S 품목"/>',
			width:300,
			labelWidth       : 90
		 })
		,Unilite.popup('CUST',{
			fieldLabel:'<t:message code="system.label.sales.custom" default="거래처"/>',
			width:300,
			labelWidth       : 90,
			colspan          : 2
		})]
	});	
	
    var masterGrid = Unilite.createGrid('s_sas100skrv_mitGrid', {
        store: directMasterStore,
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
        	{ dataIndex: 'RECEIPT_NUM' 	, width: 120 },
            { dataIndex: 'RECEIPT_DATE'	, width: 100 },
            { dataIndex: 'ITEM_CODE'	, width: 100},
			{ dataIndex: 'ITEM_NAME'	, width: 300},
			{ dataIndex: 'SPEC'			, width: 150},
			{ dataIndex: 'SERIAL_NO'	, width: 100},
			{ dataIndex: 'CUSTOM_CODE'	, width: 80},
			{ dataIndex: 'CUSTOM_NAME'	, width: 150},
			{ dataIndex: 'USER_NAME'	, width: 100},
			{ dataIndex: 'AS_STATUS'	, width: 80},
			{ dataIndex: 'REPAIR_DATE'	, width: 80 },
			{ dataIndex: 'REPAIR_RANK'	, width: 80 },
			{ dataIndex: 'INSPEC_FLAG'	, width: 80 },
			{ dataIndex: 'OUT_DATE'		, width: 80 },
			{ dataIndex: 'SALE_DATE'	, width: 80 }
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
							SERIAL_NO : record.get('SERIAL_NO'),
							REPAIR_DATE : record.get('REPAIR_DATE')
						}
						var rec = {data : {prgID : 's_sas300ukrv_mit', 'text':''}};
						parent.openTab(rec, '/z_mit/s_sas300ukrv_mit.do', params);
					}
				});
				this.contextMenu.add({
					text: '장비출고',   iconCls : '',
					handler: function(menuItem, event) {
					
						var records = grid.getSelectionModel().getSelection();
						var record = records[0];
						if(record && !Ext.isEmpty(record.get("INSPEC_DATE")) && ( record.get("AS_STATUS") == "31" || record.get("AS_STATUS") == "40" || record.get("AS_STATUS") == "90")) {
							var params = {
								DIV_CODE: record.get("DIV_CODE"),
								RECEIPT_NUM: record.get('RECEIPT_NUM'),
								USER_NAME : record.get('OUT_PRSN_NAME'),
								OUT_PRSN : record.get('OUT_PRSN'),
								AS_STATUS : record.get('AS_STATUS'),
								INSPEC_DATE_FR : record.get('INSPEC_DATE'),
								INSPEC_DATE_TO : record.get('INSPEC_DATE')
							}
							var rec = {data : {prgID : 's_sas330ukrv_mit', 'text':''}};
							parent.openTab(rec, '/z_mit/s_sas330ukrv_mit.do', params);
						} else {
							Unilite.messageBox('출고검사 후 조회 할 수 있습니다.');
						}
					}
				});
			}
		}
    });  
    
	Unilite.Main( {
		borderItems:[
			panelResult,masterGrid
		],
		id: 's_sas100skrv_mitApp',
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['reset','newData'],true);
			UniAppManager.setToolbarButtons(['save'],false);
		},
		onQueryButtonDown: function()	{
			directMasterStore.loadStoreRecords();
		},
		onNewDataButtonDown: function()	{
				masterGrid.createRow(r);
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
