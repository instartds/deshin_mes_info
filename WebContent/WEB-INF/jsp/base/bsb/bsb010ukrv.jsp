<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bsb010ukrv" >
	<t:ExtComboStore comboType="AU" comboCode="B007" />
	<t:ExtComboStore comboType="BOR120"  />
</t:appConfig>
<script type="text/javascript">
	
function appMain() {
		Unilite.defineModel('bsb010ukrvMasterModel', {
			fields : [ {name : 'DIV_CODE',				text : '<t:message code="system.label.base.division" default="사업장"/>'				, type : 'string', comboType:"BOR120"	}
					 , {name : 'PROGRAM_ID',			text : '<t:message code="system.label.base.programid" default="프로그램ID"/>'			, type : 'string', allowBlank:false}
					 , {name : 'PROGRAM_NAME',			text : '<t:message code="system.label.base.programname" default="프로그램명"/>'		, type : 'string', editable:false}
					 , {name : 'ALERT_PROGRAM_ID',		text : '<t:message code="system.label.base.alterprogramid" default="연계프로그램ID"/>'	, type : 'string', allowBlank:false}
					 , {name : 'ALERT_PROGRAM_NAME',	text: '<t:message code="system.label.base.alterprogramname" default="연계프로그램명"/>', type : 'string', editable:false}
					 , {name : 'REMARK',	text: '<t:message code="system.label.base.remarks" default="비고"/>', type : 'string'}
					]
					
		});

		var directMasterStore = Unilite.createStore('bsb010ukrvMasterStore', { 
			model : 'bsb010ukrvMasterModel',
			autoLoad : false,
			uniOpt : {
            	isMaster: false,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
			proxy : {
				type : 'direct',
				api : {
					read : 	 'bsb020ukrvService.selectList'
					
				}
			}
			,loadStoreRecords : function()	{
				if(Ext.getCmp('bsb010ukrvSearchForm').isValid())	{
				var param= Ext.getCmp('bsb010ukrvSearchForm').getValues();	
									
					this.load({
						params : param
					});
				}
			}
		});	

		Unilite.defineModel('bsb010ukrvAlertUserModel', {		
			
			fields : [ {name : 'DIV_CODE',			text : '<t:message code="system.label.base.division" default="사업장"/>',		type : 'string'	, allowBlank:false, editable:false}
					 , {name : 'PROGRAM_ID',		text : '<t:message code="system.label.base.programid" default="프로그램ID"/>',		type : 'string' , allowBlank:false, editable:false}
					 , {name : 'PROGRAM_NAME',		text : '<t:message code="system.label.base.programname" default="프로그램명"/>',		type : 'string' , editable:false}
					 , {name : 'ALERT_USER_ID',		text : '<t:message code="system.label.base.userid" default="사용자ID"/>',			type : 'string', allowBlank:false}
					 , {name : 'USER_NAME',			text : '<t:message code="system.label.base.username" default="사용자명"/>',			type : 'string', allowBlank:false}
					 , {name : 'OLD_PROGRAM_ID',		text : '<t:message code="system.label.base.programid" default="프로그램ID"/>',		type : 'string' , editable:false}
					 , {name : 'OLD_ALERT_USER_ID',		text : '<t:message code="system.label.base.userid" default="사용자ID"/>',		type : 'string' , editable:false}
					 , {name : 'REMARK',			text : '<t:message code="system.label.base.remarks" default="비고"/>',			type : 'string'}
					]
		});
		
		var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
			api: {
				read : 'bsb010ukrvService.selectList',
				update: 'bsb010ukrvService.update',
				create : 'bsb010ukrvService.insert',
				destroy: 'bsb010ukrvService.delete',
				syncAll: 'bsb010ukrvService.saveAll'
			}
		});
		
		var alertUserStore = Unilite.createStore('bsb010ukrvalertUserStore', { 
			model : 'bsb010ukrvAlertUserModel',
			autoLoad : false,
			uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:true,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
			proxy : directProxy
			,loadStoreRecords : function(record)	{
				var param= record.data;
				this.load({
					params : param
				});
			}
			,saveStore : function()	{
				var inValidRecs = this.getInvalidRecords();
				if(inValidRecs.length == 0 )	{
					this.syncAllDirect();				
				}else {
					Unilite.messageBox(Msg.sMB152);
					// 사용자ID를 선택해 주세요.
				}
			}  
		});
				
   		// 검색
		var panelSearch = Unilite.createSearchForm('bsb010ukrvSearchForm',{
				
			layout : {type : 'uniTable', columns : 4},
				items : [ {fieldLabel: '<t:message code="system.label.base.division" default="사업장"/>',	 	name : 'DIV_CODE'		, xtype: 'uniCombobox',  comboType : 'BOR120', value:UserInfo.divCode, allowBlank:false},
						  {fieldLabel: '<t:message code="system.label.base.businessclassification" default="업무구분"/>',		name : 'PGM_SEQ'		, xtype: 'uniCombobox',  comboType : 'AU', comboCode : 'B007'},
		       			  {fieldLabel : '<t:message code="system.label.base.programid" default="프로그램ID"/>',	name : 'PROGRAM_ID'},
						  {fieldLabel : '<t:message code="system.label.base.programname" default="프로그램명"/>',	name : 'PGM_NAME'} 
						]
			});
		
		// create the Grid
		var masterGrid = Unilite.createGrid('bsb010ukrvMasterGrid', {
			store: directMasterStore,
			selModel : 'rowmodel',
			title : '<t:message code="system.label.base.programlist" default="프로그램 목록"/>',
			uniOpt:{
				expandLastColumn: false
			},
	        flex:2,
			columns : [   {dataIndex : 'PROGRAM_ID',			width:100	}
						, {dataIndex : 'PROGRAM_NAME',			width:150	}
						, {dataIndex : 'ALERT_PROGRAM_ID',			width:100	}
						, {dataIndex : 'ALERT_PROGRAM_NAME',			width:150	}
						, {dataIndex : 'REMARK',			flex:1	}
						
					],
			listeners:{
				select:function(grid, selected)	{
					if(selected)	{
						alertUserStore.loadStoreRecords(selected)
					}
				}
			}
		});
		
	var alertUserGird =  Unilite.createGrid('bsb010ukrvDetailSystemGrid', {
			store : alertUserStore,
			title : '<t:message code="system.label.base.alertUser" default="담당자"/>',
	        uniOpt:{
	        	expandLastColumn: false
	        },
	        flex : 3,
			columns : [   {dataIndex : 'PROGRAM_ID',			width:100	}
						, {dataIndex : 'PROGRAM_NAME',			width:200	}
						, {dataIndex : 'ALERT_USER_ID',		width:100	,
							editor:Unilite.popup('USER_G',{
								valueFieldName:'ALERT_USER_ID',
								textFieldName:'ALERT_USER_ID',
								DBvalueFieldName: 'USER_ID',
								DBtextFieldName: 'USER_NAME',
								listeners:{
									onSelected:function(records, type) {
										if(records && records.length > 0)	{
											alertUserGird.uniOpt.currentRecord.set("ALERT_USER_ID", records[0]["USER_ID"]);
											alertUserGird.uniOpt.currentRecord.set("USER_NAME", records[0]["USER_NAME"]);
										}
									},
									onClear:function(type){
										alertUserGird.uniOpt.currentRecord.set("ALERT_USER_ID", "");
											alertUserGird.uniOpt.currentRecord.set("USER_NAME", "");
									}
								}
							})
						}
						, {dataIndex : 'USER_NAME',		width:100	,
							editor:Unilite.popup('USER_G',{
								valueFieldName:'USER_NAME',
								textFieldName:'USER_NAME',
								DBvalueFieldName: 'USER_ID',
								DBtextFieldName: 'USER_NAME',
								listeners:{
									onSelected:function(records, type) {
										if(records && records.length > 0)	{
											alertUserGird.uniOpt.currentRecord.set("ALERT_USER_ID", records[0]["USER_ID"]);
											alertUserGird.uniOpt.currentRecord.set("USER_NAME", records[0]["USER_NAME"]);
										}
									},
									onClear:function(type){
										alertUserGird.uniOpt.currentRecord.set("ALERT_USER_ID", "");
											alertUserGird.uniOpt.currentRecord.set("USER_NAME", "");
									}
								}
							})
						}
						, {dataIndex : 'REMARK',		flex:1	}
						
					]
		});

    Unilite.Main({
			items : [ panelSearch, {
				xtype : 'container',
				flex : 1,
				layout: {
					        type: 'hbox',
					        align: 'stretch'
					    },
				/*defaults : {
					collapsible : false,
					split : true
				},*/
				items : [ masterGrid,   alertUserGird ]

			} ]
			,fnInitBinding : function() {
				UniAppManager.setToolbarButtons(['reset','newData'],true);
			}
			, onQueryButtonDown:function() {
				masterGrid.getStore().loadStoreRecords();
			}
			, onNewDataButtonDown:  function()	{
				var masterGridRec = masterGrid.getSelectedRecord();
					if(masterGridRec)	{
		        	 var r = {
						DIV_CODE: panelSearch.getValue("DIV_CODE"),
						PROGRAM_ID: masterGridRec.get("PROGRAM_ID"),
						PROGRAM_NAME: masterGridRec.get("PROGRAM_NAME")
			        };
					alertUserGird.createRow(r);
				}
			}
			, onSaveDataButtonDown: function () {										
					 if(alertUserStore.isDirty())	{
						alertUserStore.saveStore();						
					 }
				}
			,
			onResetButtonDown:function() {
				alertUserGird.getStore().loadData({});
				masterGrid.getStore().loadData({});
				Ext.getCmp('bsb010ukrvSearchForm').reset();
			}
			,onDeleteDataButtonDown : function()	{
				var delRecord = alertUserGird.getSelectionModel().getLastSelected();
				
				alertUserGird.deleteSelectedRow();	
				
			}	
				
		});

		Unilite.createValidator('bsb010ukrvValidator', {
		store : alertUserStore,
		grid: alertUserGird,
		forms: {'formA:':bsb010ukrvSearchForm},
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			if (fieldName == "ALERT_USER_ID" )	{		
					if(record.phantom && newValue != '')	{
						record.set("OLD_ALERT_USER_ID", newValue);
					}
			}
			if (fieldName == "PROGRAM_ID" )	{		
					if(record.phantom && newValue != '')	{
						record.set("OLD_PROGRAM_ID", newValue);
					}
			}
			return rv;
		}
		});
		

};	// appMain
</script>