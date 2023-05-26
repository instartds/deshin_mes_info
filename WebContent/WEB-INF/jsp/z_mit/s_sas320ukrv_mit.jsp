<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_sas320ukrv_mit"  >
	<t:ExtComboStore comboType="BOR120" pgmId="s_sas320ukrv_mit"/>
	<t:ExtComboStore comboType="AU" comboCode="S163"/>								<!-- 진행상태 -->
	<t:ExtComboStore comboType="AU" comboCode="S164"/>								<!-- 수리랭크 -->
	<t:ExtComboStore comboType="AU" comboCode="S165"/>								<!-- 검사여부 -->
	
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {  
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 's_sas320ukrv_mitService.selectList',
			update: 's_sas320ukrv_mitService.updateList',
			syncAll: 's_sas320ukrv_mitService.saveAll'
		}
	});	
	
	Unilite.defineModel('s_sas320ukrv_mitModel', {
	    fields: [  	    
	    	{name: 'DIV_CODE'		, text: '<t:message code="system.label.sales.division" default="사업장"/>'			, type: 'string', comboType: 'BOR120', editable:false},
			{name: 'REPAIR_DATE'	, text: '<t:message code="system.label.sales.repairdate" default="수리일"/>'		, type: 'uniDate', editable:false},
			{name: 'REPAIR_NUM'		, text: '<t:message code="system.label.sales.repairnum" default="수리번호"/>'		, type: 'string', editable:false},
			{name: 'ITEM_CODE'		, text: '<t:message code="system.label.sales.item" default="품목"/>'				, type: 'string', editable:false},
			{name: 'ITEM_NAME'		, text: '<t:message code="system.label.sales.itemname" default="품목명"/>'			, type: 'string', editable:false},
			{name: 'SPEC'			, text: '<t:message code="system.label.sales.spec" default="규격"/>'				, type: 'string', editable:false},
			{name: 'CUSTOM_CODE'	, text: '<t:message code="system.label.sales.custom" default="거래처"/>'			, type: 'string', editable:false},
			{name: 'CUSTOM_NAME'	, text: '<t:message code="system.label.sales.customname" default="거래처명"/>'		, type: 'string', editable:false},
			{name: 'SERIAL_NO'		, text: '<t:message code="system.label.sales.asserialno" default="S/N"/>'			, type: 'string', editable:false},
			{name: 'REPAIR_RANK'	, text: '<t:message code="system.label.sales.asrank" default="수리랭크"/>'			, type: 'string', comboType: 'AU', comboCode: 'S164', editable:false},
			{name: 'INSPEC_FLAG'	, text: '검사여부'																	, type: 'string', comboType: 'AU', comboCode: 'S165'},
			{name: 'INSPEC_DATE'	, text: '검사일'																	, type: 'uniDate'},
			{name: 'BAD_REMARK'	    , text: '점검내용'																	, type: 'string'},
			{name: 'AS_STATUS'		, text: '<t:message code="system.label.sales.processstatus" default="진행상태"/>'			, type: 'string', comboType: 'AU', comboCode: 'S163', editable:false},
			{name: 'RECEIPT_NUM'	, text: '<t:message code="system.label.sales.receiptnum" default="접수번호"/>'				, type: 'string', editable:false},
			{name: 'INOUT_CNT'	    , text: '자재출고 여부'																, type: 'string', editable:false},
			{name: 'OUT_DATE'	    , text: '출고일'				    												, type: 'uniDate', editable:false}
		
		]
	});
	
	var directMasterStore = Unilite.createStore('s_sas320ukrv_mitMasterStore',{
		model: 's_sas320ukrv_mitModel',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: true,			// 수정 모드 사용 
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
		saveStore : function()	{	
			var paramMaster= panelResult.getValues();
			
			var inValidRecs = this.getInvalidRecords();
        	var rv = true;
        	var updateData = this.getModifiedRecords();
        	Ext.each(updateData, function(record, idx){
        		if(record.get("INSPEC_FLAG") == "Y")	{
        			record.set("OUT_DATE", UniDate.today());
        		}else {
        			record.set("OUT_DATE", "");
        		}
        	})
			if(inValidRecs.length == 0 )	{
				
				this.syncAllDirect();
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
		
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
			fieldLabel		: '수리일',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'REPAIR_DATE_FR',
			endFieldName	: 'REPAIR_DATE_TO',
			allowBlank	    : false,
			labelWidth       : 90,
			startDate		: UniDate.get('aMonthAgo'),
			endDate			: UniDate.get('today')
		},{
			xtype :'component',
			tdAttrs:{width:40},
			html :'&nbsp;'
		},{
			fieldLabel : ''  ,//검사여부
			labelWidth : 30,
			name : 'INSPEC_FLAG',
			xtype : 'uniRadiogroup',
			items : [
				{ boxLabel: '미검사 / 재수리'  , name: 'INSPEC_FLAG', inputValue: 'N' },
				{ boxLabel: '검사완료'		   , name: 'INSPEC_FLAG', inputValue: 'Y' }
			],
			value :'N',
			allowBlank	    : false,
			width : 250
		},Unilite.popup('USER' , {
			xtype:'uniPopupField',
			fieldLabel : '검사자',
			valueFieldName:'INSPEC_PRSN',
			textFieldName:'USER_NAME'
		}),{
			fieldLabel		: '검사일',
			xtype			: 'uniDatefield',
			name	    	: 'INSPEC_DATE',
			labelWidth      : 90,
			value			: UniDate.get('today'),
			colspan			: 3
		}]
	});	
	
    var masterGrid = Unilite.createGrid('s_sas320ukrv_mitGrid', {
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
        	{ dataIndex: 'INSPEC_FLAG' 	, width: 100 },
            { dataIndex: 'BAD_REMARK'	, width: 200 },
            { dataIndex: 'INSPEC_DATE'	, width: 100},
			{ dataIndex: 'REPAIR_DATE'	, width: 100},
            { dataIndex: 'ITEM_CODE'	, width: 80},
			{ dataIndex: 'ITEM_NAME'	, width: 200},
			{ dataIndex: 'SPEC'			, width: 150},
			{ dataIndex: 'SERIAL_NO'	, width: 130},
			{ dataIndex: 'INOUT_CNT'	, width: 100},
			{ dataIndex: 'CUSTOM_CODE'	, width: 80},
			{ dataIndex: 'CUSTOM_NAME'	, width: 130},
			{ dataIndex: 'REPAIR_RANK'	, width: 100},
			{ dataIndex: 'REPAIR_NUM'	, width: 130 }
		],
		listeners:{
			afterrender: function(grid) {
				var me = this;
				this.contextMenu = Ext.create('Ext.menu.Menu', {});
				
				this.contextMenu.add({
					text: '<t:message code="system.label.sales.registerrepair" default="수리등록"/>',   iconCls : '',
					handler: function(menuItem, event) {
						var records = grid.getSelectionModel().getSelection();
						var record = records[0];
						var params = {
							DIV_CODE: record.get("DIV_CODE"),
							REPAIR_NUM: record.get('REPAIR_NUM')
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
		id: 's_sas320ukrv_mitApp',
		fnInitBinding : function() {
			panelResult.setValue("DIV_CODE", UserInfo.divCode);
			panelResult.setValue("INSPEC_PRSN", UserInfo.userID);
			panelResult.setValue("USER_NAME", UserInfo.userName);
			panelResult.setValue("INSPEC_FLAG", "N");
			panelResult.setValue("INSPEC_DATE", UniDate.get('today'));
			
			panelResult.setValue("REPAIR_DATE_FR", UniDate.get('aMonthAgo'));
			panelResult.setValue("REPAIR_DATE_TO", UniDate.get('today'));
			
			UniAppManager.setToolbarButtons(['reset'],true);
			UniAppManager.setToolbarButtons(['save','newData'],false);
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
		},
		onSaveDataButtonDown: function(config) {	
			directMasterStore.saveStore();
		}
	});
	
	Unilite.createValidator('validator01', {
		store: directMasterStore,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt, editor, e) {
			if(newValue == oldValue){
				return false;
			}
			var rv = true;
			switch(fieldName) {
				case "INSPEC_FLAG" :	
					if(record.get("INOUT_CNT") == '미완료' && newValue == 'Y')	{
						Unilite.messageBox('검수완료를 할 수 없습니다.', '자재출고가 안된 품목');
						return false;
					} else {
						record.set('INSPEC_DATE', panelResult.getValue('INSPEC_DATE'));
					}
					break;
				default:
					break;
			}
		
			return rv;
		}
	})			
};


</script>
