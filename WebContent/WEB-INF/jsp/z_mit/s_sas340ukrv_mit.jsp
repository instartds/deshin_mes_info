<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_sas340ukrv_mit"  >
	<t:ExtComboStore comboType="BOR120" pgmId="s_sas340ukrv_mit"/>
	<t:ExtComboStore comboType="AU" comboCode="S164"/>								<!-- 수리랭크 -->
	<t:ExtComboStore comboType="AU" comboCode="S168"/>								<!-- 위치 -->
	<t:ExtComboStore comboType="AU" comboCode="S169"/>								<!-- 증상 -->
	<t:ExtComboStore comboType="AU" comboCode="S170"/>								<!-- 원인 -->
	<t:ExtComboStore comboType="AU" comboCode="S171"/>								<!-- 해결 -->
	
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {  
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 's_sas340ukrv_mitService.selectList',
			update: 's_sas340ukrv_mitService.updateList',
			create: 's_sas340ukrv_mitService.insertList',
			destroy: 's_sas340ukrv_mitService.deleteList',
			syncAll: 's_sas340ukrv_mitService.saveAll'
		}
	});	
	
	Unilite.defineModel('s_sas340ukrv_mitModel', {
	    fields: [  	    
	    	{name: 'DIV_CODE'				, text: '<t:message code="system.label.sales.division" default="사업장"/>'		    , type: 'string', comboType: 'BOR120', allowBlank:false},
	    	{name: 'ITEM_CODE'				, text: '<t:message code="system.label.sales.item" default="품목"/>'					, type: 'string', allowBlank:false},
			{name: 'ITEM_NAME'				, text: '<t:message code="system.label.sales.itemname" default="품목명"/>'			, type: 'string', allowBlank:false},
			{name: 'SPEC'					, text: '<t:message code="system.label.sales.spec" default="규격"/>'					, type: 'string', editable:false},
			{name: 'LOT_NO'				    , text: '<t:message code="system.label.sales.asserialno" default="S/N"/>'			, type: 'string', allowBlank:false},
			{name: 'OUT_Q'				    , text: '출고수량' 			,type: 'uniQty'},
			{name: 'OUT_DATE'				, text: '<t:message code="system.label.sales.issuedate" default="출고일"/>' 			,type: 'uniDate', allowBlank:false},
			{name: 'CUSTOM_CODE'			, text: '<t:message code="system.label.sales.issueplacecode" default="출고처코드"/>'		, type: 'string'},
			{name: 'CUSTOM_NAME'			, text: '<t:message code="system.label.sales.issueplacename" default="출고처명"/>'			, type: 'string'},
			{name: 'CUSTOM_PRSN'			, text: '출고요청자'		, type: 'string'},
			{name: 'USER_NAME'				, text: '출고요청자명'		, type: 'string'},
			{name: 'OUT_USER_ID'			, text: '출고자'			, type: 'string'},
			{name: 'IN_DUT_DATE'	    	, text: '입고예정일'		, type: 'uniDate'},
			{name: 'IN_DATE'	    		, text: '입고일'			, type: 'uniDate'},
			{name: 'REMARK'					, text: '비고'			, type: 'string'}
		]
	});
	
	var directMasterStore = Unilite.createStore('s_sas340ukrv_mitMasterStore',{
		model: 's_sas340ukrv_mitModel',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: true,			// 수정 모드 사용 
            deletable: true,			// 삭제 가능 여부 
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
			var inValidRecs = this.getInvalidRecords();
        	var rv = true;
			if(inValidRecs.length == 0 )	{
				var config = {}
				this.syncAllDirect({});
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners:{
			load: function(store, records, successful, eOpts) {
				if(!records && records.length == 0)	{
					UniAppManager.app.setDisable(false);
				}
           	},
           	add: function(store, records, index, eOpts) {
           		if(store.isDirty())	{
           			UniAppManager.app.setDisable(true);
           		}
           	},
           	update: function(store, record, operation, modifiedFieldNames, eOpts) {
           		if(store.isDirty())	{
           			UniAppManager.app.setDisable(true);
           		}else {
           			UniAppManager.app.setDisable(false);
           		}
           	},
           	remove: function(store, record, index, isMove, eOpts) {
           		if(store.isDirty())	{
           			UniAppManager.app.setDisable(true);
           		}else {
           			UniAppManager.app.setDisable(false);
           		}
           	}
		}
		
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
			fieldLabel		: '<t:message code="system.label.sales.issuedate" default="출고일"/>',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'OUT_DATE_FR',
			endFieldName	: 'OUT_DATE_TO',
			labelWidth       : 90,
			startDate		: UniDate.get('aMonthAgo'),
			endDate			: UniDate.get('today')
		},{
			xtype		: 'radiogroup',
			fieldLabel	: ' ',
			name		: 'INOUT_YN',
			itemId		: 'INOUT_YN',
			items		: [{
				boxLabel	: '전체',
				name		: 'INOUT_YN',
				inputValue	: 'A',
				width		: 70
			},{
				boxLabel	: '미입고',
				name		: 'INOUT_YN',
				inputValue	: 'N',
				width		: 60
			}]
		}
		,Unilite.popup('USER',{
			fieldLabel:'출고자',
			valueFieldName:'OUT_USER_ID',
			textFieldName:'USER_NAME',
			width:300,
			labelWidth       : 90,
			colspan         : 2
		})]
	});	
	
    var masterGrid = Unilite.createGrid('s_sas340ukrv_mitGrid', {
        store: directMasterStore,
    	region: 'center',
    	flex:1,
        columns:  [
            { dataIndex: 'ITEM_CODE'	, width: 100,
	           	editor:Unilite.popup('DIV_PUMOK_G', {
	           		textFieldName:'ITEM_CODE',
	    			DBtextFieldName: 'ITEM_CODE',
	    			autoPopup : true,
	           		 listeners:{
	    	        		onSelected: {
	    						fn: function(records, type) {
	    							if(records) {
	    								var record = masterGrid.uniOpt.currentRecord;
	    								record.set('DIV_CODE', records[0]["DIV_CODE"]);
	    								record.set('ITEM_CODE', records[0]["ITEM_CODE"]);
	    								record.set('ITEM_NAME', records[0]["ITEM_NAME"]);
	    								record.set('SPEC', records[0]["SPEC"]);
	    								record.set('UNIT', records[0]["STOCK_UNIT"]);
	    							}
	    						},
	    						scope: this
	    					},
	    					onClear: function(type) {
	    						var record = masterGrid.uniOpt.currentRecord;
	    						record.set('DIV_CODE', '');
	    						record.set('ITEM_CODE', '');
	    						record.set('ITEM_NAME', '');
	    						record.set('SPEC', '');
	    						record.set('UNIT', '');
	    					},
	    					applyextparam: function(popup){
	    						var record = masterGrid.uniOpt.currentRecord;
	    						popup.setExtParam({'DIV_CODE': record.get("DIV_CODE")});
	    					}
	    	        	}
	           	 })
            },
			{ dataIndex: 'ITEM_NAME'	, width: 130,
        		editor:Unilite.popup('DIV_PUMOK_G', {
	    		 autoPopup : true,
           		 listeners:{
    	        		onSelected: {
    						fn: function(records, type) {
    							if(records) {
    								var record = masterGrid.uniOpt.currentRecord;
    								record.set('DIV_CODE', records[0]["DIV_CODE"]);
    								record.set('ITEM_CODE', records[0]["ITEM_CODE"]);
    								record.set('ITEM_NAME', records[0]["ITEM_NAME"]);
    								record.set('SPEC', records[0]["SPEC"]);
    							}
    						},
    						scope: this
    					},
    					onClear: function(type) {
    						var record = masterGrid.uniOpt.currentRecord;
    						record.set('DIV_CODE', '');
    						record.set('ITEM_CODE', '');
    						record.set('ITEM_NAME', '');
    						record.set('SPEC', '');
    					},
    					applyextparam: function(popup){
    						var record = masterGrid.uniOpt.currentRecord;
    						popup.setExtParam({'DIV_CODE': record.get("DIV_CODE")});
    					}
    	        	}
           	 })},
			{ dataIndex: 'SPEC'	        , width: 130},
			{ dataIndex: 'LOT_NO'	    , width: 100 ,
				editor : Unilite.popup('SAS_LOT_G', {	
					textFieldName:'LOT_NO',
					DBtextFieldName: 'SERIAL_NO',
					validateBlank :false,
					allowInputData : true,
		        	listeners:{
		        		onSelected: {
    						fn: function(records, type) {
    							if(records) {
    								var record = masterGrid.uniOpt.currentRecord;
    								record.set('LOT_NO', records[0]["SERIAL_NO"]);
    							}
    						},
    						scope: this
    					},
    					onClear: function(type) {
    						var record = masterGrid.uniOpt.currentRecord;
    						record.set('LOT_NO', '');
    					},
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': panelResult.getValue("DIV_CODE")});
						}
		        	}
		        })
			},
			{ dataIndex: 'OUT_DATE'		, width: 80},
			{ dataIndex: 'CUSTOM_CODE'	, width: 80, 
			    editor : Unilite.popup('CUST_G',{
				   textFieldName:'CUSTOM_CODE',
				   DBtextFieldName: 'CUSTOM_CODE',
		        	listeners:{
		        		onSelected: {
    						fn: function(records, type) {
    							if(records) {
    								var record = masterGrid.uniOpt.currentRecord;
    								record.set('CUSTOM_CODE', records[0]["CUSTOM_CODE"]);
    								record.set('CUSTOM_NAME', records[0]["CUSTOM_NAME"]);
    							}
    						},
    						scope: this
    					},
    					onClear: function(type) {
    						var record = masterGrid.uniOpt.currentRecord;
    						record.set('CUSTOM_CODE', '');
    						record.set('CUSTOM_NAME', '');
    					}
		        	}
	        	})
			},
			{ dataIndex: 'CUSTOM_NAME'	, width: 120, 
			    editor : Unilite.popup('CUST_G', {
			        	listeners:{
			        		onSelected: {
	    						fn: function(records, type) {
	    							if(records) {
	    								var record = masterGrid.uniOpt.currentRecord;
	    								record.set('CUSTOM_CODE', records[0]["CUSTOM_CODE"]);
	    								record.set('CUSTOM_NAME', records[0]["CUSTOM_NAME"]);
	    							}
	    						},
	    						scope: this
	    					},
	    					onClear: function(type) {
	    						var record = masterGrid.uniOpt.currentRecord;
	    						record.set('CUSTOM_CODE', '');
	    						record.set('CUSTOM_NAME', '');
	    					}
			        	}
		        	})
		    },
			{ dataIndex: 'USER_NAME'	, width: 100 ,
		    	editor : Unilite.popup('USER_G' , {
		    		textFieldName:'USER_NAME',
				    DBtextFieldName: 'USER_NAME',
				    listeners:{
		        		onSelected: {
    						fn: function(records, type) {
    							if(records) {
    								var record = masterGrid.uniOpt.currentRecord;
    								record.set('CUSTOM_PRSN', records[0]["USER_ID"]);
    								record.set('USER_NAME', records[0]["USER_NAME"]);
    							}
    						},
    						scope: this
    					},
    					onClear: function(type) {
    						var record = masterGrid.uniOpt.currentRecord;
    						record.set('CUSTOM_PRSN', '');
    						record.set('USER_NAME', '');
    					}
		        	}
		    	})
			},
			{ dataIndex: 'IN_DUT_DATE'		, width: 80},
			{ dataIndex: 'IN_DATE'		, width: 80},
			{ dataIndex: 'REMARK'		, width: 300},
			
		],
		listeners:{
			beforeedit  : function( editor, e, eOpts ) {
				var record = masterGrid.getSelectedRecord();
				if (record.phantom || UniUtils.indexOf(e.field, ["USER_NAME", "IN_DATE", "REMARK"])) {
					return true;
				} else {
					return false;
				}
			}
		}
    });  
    
	Unilite.Main( {
		borderItems:[
			panelResult,masterGrid
		],
		id: 's_sas340ukrv_mitApp',
		fnInitBinding : function() {
			panelResult.setValue("DIV_CODE", UserInfo.divCode);
			panelResult.setValue("OUT_DATE_FR", UniDate.get('aMonthAgo'));
			panelResult.setValue("OUT_DATE_TO", UniDate.get('today'));
		
			panelResult.setValue("INOUT_YN", "A");
			panelResult.setValue("OUT_USER_ID", UserInfo.userID);
			panelResult.setValue("USER_NAME", UserInfo.userName);
			this.setDisable(false);
			UniAppManager.setToolbarButtons(['reset','newData'],true);
			UniAppManager.setToolbarButtons(['save'],false);
		},
		onQueryButtonDown: function()	{
			directMasterStore.loadStoreRecords();
		},
		onNewDataButtonDown: function()	{
			var r = {'DIV_CODE' : panelResult.getValue("DIV_CODE"),
					 'OUT_USER_ID' : panelResult.getValue("OUT_USER_ID")
					};
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
		},
		onDeleteDataButtonDown: function() {
			var selRow = masterGrid.getSelectedRecord();
			
			if(!Ext.isEmpty(selRow.get("IN_DATE")))	{
				Unilite.messageBox("이력데이타는 삭제할 수 없습니다.")
				return;
			}
			if(selRow.phantom === true)	{
				masterGrid.deleteSelectedRow();
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				masterGrid.deleteSelectedRow();
			}
		},
		setDisable: function(disable){
			panelResult.getField("DIV_CODE").setReadOnly(disable);
			panelResult.getField("OUT_USER_ID").setReadOnly(disable);
			panelResult.getField("USER_NAME").setReadOnly(disable);
		}
	});
};


</script>
