<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_sas330ukrv_mit"  >
	<t:ExtComboStore comboType="BOR120" pgmId="s_sas330ukrv_mit"/>
	<t:ExtComboStore comboType="AU" comboCode="S163" opts="31;40;90"/>								<!-- 진행상태 -->
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
			read: 's_sas330ukrv_mitService.selectList',
			update: 's_sas330ukrv_mitService.updateList',
			syncAll: 's_sas330ukrv_mitService.saveAll'
		}
	});	
	
	Unilite.defineModel('s_sas330ukrv_mitModel', {
	    fields: [  	    
	    	{name: 'DIV_CODE'		, text: '<t:message code="system.label.sales.division" default="사업장"/>'		, type: 'string', comboType: 'BOR120', editable:false},
			{name: 'REPAIR_NUM'		, text: '<t:message code="system.label.sales.repairnum" default="수리번호"/>'		, type: 'string', editable:false},
			{name: 'AS_STATUS'	    , text: '출고상태'				, type: 'string', comboType: 'AU', comboCode: 'S163', editable:false},
			{name: 'REPAIR_DATE'	, text: '<t:message code="system.label.sales.repairdate" default="수리일"/>'		, type: 'uniDate', editable:false},
			{name: 'ITEM_CODE'		, text: '<t:message code="system.label.sales.item" default="품목"/>'				, type: 'string', editable:false},
			{name: 'ITEM_NAME'		, text: '<t:message code="system.label.sales.itemname" default="품목명"/>'		, type: 'string', editable:false},
			{name: 'SPEC'			, text: '<t:message code="system.label.sales.spec" default="규격"/>'				, type: 'string', editable:false},
			{name: 'SERIAL_NO'		, text: '<t:message code="system.label.sales.asserialno" default="S/N"/>'		, type: 'string', editable:false},
			{name: 'CUSTOM_CODE'	, text: '<t:message code="system.label.sales.custom" default="거래처"/>'			, type: 'string', editable:false},
			{name: 'CUSTOM_NAME'	, text: '<t:message code="system.label.sales.customname" default="거래처명"/>'		, type: 'string', editable:false},
			{name: 'REPAIR_RANK'	, text: '<t:message code="system.label.sales.asrank" default="수리랭크"/>'			, type: 'string', comboType: 'AU', comboCode: 'S164', editable:false},
			{name: 'RECEIPT_NUM'	, text: '<t:message code="system.label.sales.receiptnum" default="접수번호"/>'				, type: 'string', editable:false},
			{name: 'QUOT_NUM'		, text: '<t:message code="system.label.sales.quottnum" default="견적번호"/>'				, type: 'string', editable:false},
			{name: 'OUT_DATE'	    , text: '출고일'				    	, type: 'uniDate', editable:false},
			{name: 'OUT_PRSN'	    , text: '출고담당자'				    , type: 'string', editable:false},
			{name: 'ORDER_YN'	    , text: '매출등록여부'				, type: 'string', editable:false}
		]
	});
	
	var directMasterStore = Unilite.createStore('s_sas330ukrv_mitMasterStore',{
		model: 's_sas330ukrv_mitModel',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: true,			// 수정 모드 사용 
            deletable: false,			// 삭제 가능 여부 
	        useNavi: false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy:directProxy,
        loadStoreRecords: function(params) {
        	if(panelResult.getInvalidMessage())	{
				var param = Ext.getCmp('resultForm').getValues();		
				if(params && !Ext.isEmpty(params.RECEIPT_NUM))	{
					param.RECEIPT_NUM = params.RECEIPT_NUM
				}
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
			if(inValidRecs.length == 0 )	{
				this.syncAllDirect({
					success:function(){
						UniAppManager.app.onQueryButtonDown();
					}
				});
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners : {
			load : function(store, records)	{
				if(records && records.length > 0)	{
					var actionBtn = masterForm.down("#outBtn");
					masterForm.inLoading = true;
					masterForm.setValue("AS_STATUS", panelResult.getValue("AS_STATUS").AS_STATUS);
					masterForm.inLoading = false;
					var actionCancelBtn = masterForm.down("#outCancelBtn");
					if(panelResult.getValue("AS_STATUS").AS_STATUS == "40")	{
						actionBtn.show();
						actionCancelBtn.hide();
					} else {
						actionBtn.hide();
						actionCancelBtn.show();
					}
					//panelResult.setReadOnly(true);
				}
			}
		}
		
	});
	
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'0 0 0 0',
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
			fieldLabel		: '출고검사일',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'INSPEC_DATE_FR',
			endFieldName	: 'INSPEC_DATE_TO',
			allowBlank	    : false,
			labelWidth      : 90,
			startDate		: UniDate.get('aMonthAgo'),
			endDate			: UniDate.get('today')
		},{
			fieldLabel 		: '출고상태'  ,
			xtype 			: 'uniRadiogroup',
			name			: 'AS_STATUS',
			
			allowBlank	    : false,
			width 			: 250,
			items : [
				{name:'AS_STATUS', boxLabel:'출고검사'  , inputValue : '40' , width : 80 , id : 'AS_STATUS_40'},
				{name:'AS_STATUS', boxLabel:'출고완료'  , inputValue : '90' , width : 80 , id : 'AS_STATUS_90'}
			]
		}]
	});	
	var masterForm = Unilite.createSearchForm('s_sas330ukrv_mitMasterForm', {		
    	region: 'north',	
		border:true,	
		padding:'0 0 0 0',
    	disabled : false,
    	bodyStyle : {'background-color':'#fff;border-width: 1px;'},
    	layout : {type : 'uniTable', columns : 4}, 
		items: [
			Unilite.popup('USER' , {
				xtype : 'uniPopupField',
				fieldLabel : '출고담당자',
				valueFieldName : 'OUT_PRSN',
				textFieldName : 'USER_NAME',
				allowBlank : false
   			}),{
				xtype : 'uniDatefield',
	    		fieldLabel : '<t:message code="system.label.sales.issuedate" default="출고일"/>',
	    		name : 'OUT_DATE',
				value : UniDate.get('today'),
				width : 250,
	    		allowBlank : false
			},{
				xtype :'uniTextfield',
				name  : 'AS_STATUS',
				value : '40',
				hidden : true
			},{
   				xtype : 'button',
   				text  : '출고',
				width : 100,
				tdAttrs : {'align' :'right', width:250},
   				itemId : 'outBtn',
   				handler : function()	{
   					if(confirm("출고하시겠습니까?"))	{
	   					if(Ext.isEmpty(masterForm.getValue("OUT_PRSN")) ) {
	   						Unilite.messageBox("출고담당자를 입력하세요.");
	   						return;
	   					}
						if(Ext.isEmpty(masterForm.getValue("OUT_DATE")) )	{
	   						Unilite.messageBox("출고일을 입력하세요.");
							return;
						}
	   					var dataList = masterGrid.getSelectedRecords();
	   					var outPrsn = masterForm.getValue("OUT_PRSN");
	   					var outDate = masterForm.getValue("OUT_DATE");
	   					Ext.each(dataList, function(record){
	   						record.set("AS_STATUS", "90");
	   						record.set("OUT_PRSN", outPrsn);
	   						record.set("OUT_DATE", outDate);
	   					});
	   					UniAppManager.app.onSaveDataButtonDown();
   					}
   				}
   			},{
   				xtype : 'button',
   				text  : '출고취소',
				width : 100,
				tdAttrs : {'align' :'right', width:250},
   				itemId : 'outCancelBtn',
   				hidden : true,
   				handler : function()	{
   					if(confirm("출고를 취소하시겠습니까?"))	{
	   					var dataList = masterGrid.getSelectedRecords();
	   					Ext.each(dataList, function(record){
	   						record.set("AS_STATUS", "40");
	   						record.set("OUT_PRSN", "");
	   						record.set("OUT_DATE", "");
	   					});
	   					UniAppManager.app.onSaveDataButtonDown();
   					}
   				}
   			}
		]}
	);
    var masterGrid = Unilite.createGrid('s_sas330ukrv_mitGrid', {
        store: directMasterStore,
    	excelTitle: '품목코드',
    	region: 'center',
    	flex:1,
    	selModel : Ext.create("Ext.selection.CheckboxModel", { checkOnly : true }),
        uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: false,
			useMultipleSorting: true,
			useRowNumberer: true,
			expandLastColumn: false,
			onLoadSelectFirst: false,
			copiedRow:true,
    		filter: {
				useFilter: false,
				autoCreate: false
			}
        },
        columns:  [
        	{ dataIndex: 'AS_STATUS' 	, width: 100 },
            { dataIndex: 'REPAIR_DATE'	, width: 80 },
            { dataIndex: 'ITEM_CODE'	, width: 80},
			{ dataIndex: 'ITEM_NAME'	, width: 200},
			{ dataIndex: 'SPEC'			, width: 150},
			{ dataIndex: 'SERIAL_NO'	, width: 130},
			{ dataIndex: 'CUSTOM_CODE'	, width: 80},
			{ dataIndex: 'CUSTOM_NAME'	, width: 130},
			{ dataIndex: 'REPAIR_RANK'	, width: 100},
			{ dataIndex: 'REPAIR_NUM'	, width: 130 },
			{ dataIndex: 'RECEIPT_NUM'	, width: 130 },
			{ dataIndex: 'QUOT_NUM'	, width: 130 },
			{ dataIndex: 'OUT_DATE'	, width: 80 },
			{ dataIndex: 'OUT_PRSN'	, width: 100 }
		],
		listeners:{
			beforeselect : function ( dataModel, record, index, eOpts ) {
				var asStatus = masterForm.getValue("AS_STATUS");
				if (asStatus == "40")	{
					if ((record.get("AS_STATUS") != "40") && (record.get("AS_STATUS") != "31"))	{
    					return false;
    				} 
				} else if(asStatus == "90" )	{
					if(record.get("AS_STATUS") != "90")	{
    					return false;
					}
					if(record.get("ORDER_YN") == "Y")	{
						Unilite.messageBox("매출처리된 장비는 출고취소 할 수 없습니다.");
    					return false;
					}
				}
				return true;
			} 
		}
    });  
    
	Unilite.Main( {
		borderItems:[
			panelResult, masterForm, masterGrid
		],
		id: 's_sas330ukrv_mitApp',
		fnInitBinding : function(params) {
			if(!Ext.isEmpty(params) && !Ext.isEmpty(params.RECEIPT_NUM))	{
				panelResult.setValue("DIV_CODE", params.DIV_CODE);
				panelResult.setValue("USER_NAME", params.USER_NAME);
				
				panelResult.setValue("INSPEC_DATE_FR", params.INSPEC_DATE_FR);
				panelResult.setValue("INSPEC_DATE_TO", params.INSPEC_DATE_TO);
				masterForm.setValue("OUT_DATE", UniDate.get('today'));
				masterForm.setValue("OUT_PRSN", UserInfo.OUT_PRSN);
				masterForm.setValue("USER_NAME", UserInfo.USER_NAME);
				if(params.AS_STATUS == '40')	{
					panelResult.setValue("AS_STATUS", '40');
					masterForm.setValue("AS_STATUS", '40');
					Ext.getCmp('AS_STATUS_40').checked = true;
					Ext.getCmp('AS_STATUS_90').checked = false;
				} else {
					panelResult.setValue("AS_STATUS", '90');
					masterForm.setValue("AS_STATUS", '90');
					Ext.getCmp('AS_STATUS_90').checked = true;
					Ext.getCmp('AS_STATUS_40').checked = false;
				}
				directMasterStore.loadStoreRecords(params);
			} else {
				panelResult.setValue("DIV_CODE", UserInfo.divCode);
				panelResult.setValue("USER_NAME", UserInfo.userName);
				panelResult.setValue("AS_STATUS", "40");
				panelResult.setValue("INSPEC_DATE_FR", UniDate.get('aMonthAgo'));
				panelResult.setValue("INSPEC_DATE_TO", UniDate.get('today'));
				masterForm.setValue("OUT_DATE", UniDate.get('today'));
				masterForm.setValue("OUT_PRSN", UserInfo.userID);
				masterForm.setValue("USER_NAME", UserInfo.userName);
				masterForm.setValue("AS_STATUS", "40");
			}
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
			directMasterStore.clearData();
			panelResult.clearForm();
			//panelResult.setReadOnly(false);
			//panelResult.getField("AS_STATUS").setReadOnly(false);
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {	
			directMasterStore.saveStore();
		}
	});
			
};


</script>
