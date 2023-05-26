<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bsb020ukrv" >
	<t:ExtComboStore comboType="AU" comboCode="B007" />
	<t:ExtComboStore comboType="BOR120"  />
</t:appConfig>
<script type="text/javascript">
	
function appMain() {
		Unilite.defineModel('bsb020ukrvMasterModel', {
			fields : [ {name : 'DIV_CODE',				text : '<t:message code="system.label.base.division" default="사업장"/>'				, type : 'string', comboType:"BOR120"	}
					 , {name : 'PROGRAM_ID',			text : '<t:message code="system.label.base.programid" default="프로그램ID"/>'			, type : 'string', allowBlank:false}
					 , {name : 'PROGRAM_NAME',			text : '<t:message code="system.label.base.programname" default="프로그램명"/>'		, type : 'string', editable:false}
					 , {name : 'ALERT_PROGRAM_ID',		text : '<t:message code="system.label.base.alterprogramid" default="연계프로그램ID"/>'	, type : 'string', allowBlank:false}
					 , {name : 'ALERT_PROGRAM_NAME',	text: '<t:message code="system.label.base.alterprogramname" default="연계프로그램명"/>', type : 'string', editable:false}
					 , {name : 'REMARK',	text: '<t:message code="system.label.base.remarks" default="비고"/>', type : 'string'}
					]
		});
		var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
			api: {
				read : 'bsb020ukrvService.selectList',
				update: 'bsb020ukrvService.update',
				create : 'bsb020ukrvService.insert',
				destroy: 'bsb020ukrvService.delete',
				syncAll: 'bsb020ukrvService.saveAll'
			}
		});
		var directMasterStore = Unilite.createStore('bsb020ukrvMasterStore', { 
			model : 'bsb020ukrvMasterModel',
			autoLoad : false,
			uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:true,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
			proxy : directProxy
			,loadStoreRecords : function()	{
				var param= Ext.getCmp('bsb020ukrvSearchForm').getValues();	
				if(panelSearch.isValid())	{					
					this.load({
						params : param
					});
				}
			},saveStore : function()	{
					var inValidRecs = this.getInvalidRecords();
					if(inValidRecs.length == 0 )	{
						this.syncAllDirect();				
					}
			}  
		});	
				
   		// 검색
		var panelSearch = Unilite.createSearchForm('bsb020ukrvSearchForm',{
				
			layout : {type : 'uniTable', columns : 4},
				items : [ 
						  {fieldLabel: '<t:message code="system.label.base.division" default="사업장"/>',		name : 'DIV_CODE'		, xtype: 'uniCombobox',  comboType : 'BOR120', value:UserInfo.divCode},
		       			  {fieldLabel: '<t:message code="system.label.base.businessclassification" default="업무구분"/>',		name : 'PGM_SEQ'		, xtype: 'uniCombobox',  comboType : 'AU', comboCode : 'B007'},
		       			  {fieldLabel : '<t:message code="system.label.base.programid" default="프로그램ID"/>',	name : 'PROGRAM_ID'},
						  {fieldLabel : '<t:message code="system.label.base.programname" default="프로그램명"/>',	name : 'PGM_NAME'} 
						]
			});
		
		// create the Grid
		var masterGrid = Unilite.createGrid('bsb020ukrvMasterGrid', {
			store: directMasterStore,
			
	        flex:2,
			columns : [   {dataIndex : 'PROGRAM_ID',			width:100	,
						   editor:Unilite.popup("PROGRAM_G",{
								textFieldName	: 'PROGRAM_ID',
								listeners:{
									onSelected:function(records, type){
										if(records && records.length > 0){
											masterGrid.uniOpt.currentRecord.set("PROGRAM_ID", records[0]["PGM_ID"]);
											masterGrid.uniOpt.currentRecord.set("PROGRAM_NAME", records[0]["PGM_NAME"]);
										}
									},
									onClear:function(type) {
										masterGrid.uniOpt.currentRecord.set("PROGRAM_ID", "");
										masterGrid.uniOpt.currentRecord.set("PROGRAM_NAME", "");
									}
								}
						   })
						  }
						, {dataIndex : 'PROGRAM_NAME',			width:200	,
						   editor:Unilite.popup("PROGRAM_G",{
								textFieldName	: 'PROGRAM_NAME',
								listeners:{
									onSelected:function(records, type){
										if(records && records.length > 0){
											masterGrid.uniOpt.currentRecord.set("PROGRAM_ID", records[0]["PGM_ID"]);
											masterGrid.uniOpt.currentRecord.set("PROGRAM_NAME", records[0]["PGM_NAME"]);
										}
									},
									onClear:function(type) {
										masterGrid.uniOpt.currentRecord.set("PROGRAM_ID", "");
										masterGrid.uniOpt.currentRecord.set("PROGRAM_NAME", "");
									}
								}
						   })}
						, {dataIndex : 'ALERT_PROGRAM_ID',		width:100	,
						   editor:Unilite.popup("PROGRAM_G",{
								textFieldName	: 'ALERT_PROGRAM_ID',
								listeners:{
									onSelected:function(records, type){
										if(records && records.length > 0){
											masterGrid.uniOpt.currentRecord.set("ALERT_PROGRAM_ID", records[0]["PGM_ID"]);
											masterGrid.uniOpt.currentRecord.set("ALERT_PROGRAM_NAME", records[0]["PGM_NAME"]);
										}
									},
									onClear:function(type) {
										masterGrid.uniOpt.currentRecord.set("ALERT_PROGRAM_ID", "");
										masterGrid.uniOpt.currentRecord.set("ALERT_PROGRAM_NAME", "");
									}
								}
						   })}
						, {dataIndex : 'ALERT_PROGRAM_NAME',	width:200	,
						   editor:Unilite.popup("PROGRAM_G",{
								textFieldName	: 'ALERT_PROGRAM_ID',
								listeners:{
									onSelected:function(records, type){
										if(records && records.length > 0){
											masterGrid.uniOpt.currentRecord.set("ALERT_PROGRAM_ID", records[0]["PGM_ID"]);
											masterGrid.uniOpt.currentRecord.set("ALERT_PROGRAM_NAME", records[0]["PGM_NAME"]);
										}
									},
									onClear:function(type) {
										masterGrid.uniOpt.currentRecord.set("ALERT_PROGRAM_ID", "");
										masterGrid.uniOpt.currentRecord.set("ALERT_PROGRAM_NAME", "");
									}
								}
						   })}
						, {dataIndex : 'REMARK',	flex:1	}
					],
				listeners:{
					beforeedit:function( editor, context, eOpts )  {
						if(!context.record.phantom)	{
							if(context.field != "REMARK")	{
								return false;
							}
						}
						return true;
					}
				}
		});
	
    Unilite.Main({
			items : [ panelSearch,masterGrid]
			,fnInitBinding : function() {
				UniAppManager.setToolbarButtons(['reset','newData'],true);
			}
			, onQueryButtonDown:function() {
				masterGrid.getStore().loadStoreRecords();
			}
			, onNewDataButtonDown:  function()	{
	        	 var r = {
					DIV_CODE: panelSearch.getValue("DIV_CODE")
		        };
				masterGrid.createRow(r);			
			},onSaveDataButtonDown: function () {										
					 if(directMasterStore.isDirty())	{
						directMasterStore.saveStore();						
					 }
				}
			,onResetButtonDown:function() {
					masterGrid.getStore().loadData({});
					Ext.getCmp('bsb020ukrvSearchForm').reset();
			}
			,onDeleteDataButtonDown : function()	{
				var delRecord = masterGrid.getSelectionModel().getLastSelected();
				
				masterGrid.deleteSelectedRow();	
				
			}
		});

};	// appMain
</script>