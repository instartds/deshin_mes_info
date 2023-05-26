<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bsa530ukrv" >
	<t:ExtComboStore comboType="AU" comboCode="B007" /><!-- 업무구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B003" /><!-- 프로그램사용 권한 -->
	<t:ExtComboStore comboType="AU" comboCode="B006" /><!-- 파일저장 사용권한 -->
	<t:ExtComboStore comboType="AU" comboCode="BS06" /><!-- 권한범위-사업장 -->
</t:appConfig>
<script type="text/javascript">
	
function appMain() {
	var beforeRowIndex;
	Unilite.defineModel('bsa530ukrvMasterModel', {
	
		fields: [{name: 'GROUP_CODE'    		, text: '<t:message code="system.label.base.groupcode" default="권한그룹코드"/>',			type: 'string'	},
				 {name: 'GROUP_NAME'    		, text: '<t:message code="system.label.base.groupname" default="권한그룹명"/>',			type: 'string'	}
		]
	});
	
	
	
	Unilite.defineModel('bsa530ukrvDetailModel', {	
		fields: [{name: 'COMP_CODE'		    , text: '<t:message code="system.label.base.companycode" default="법인코드"/>',			type: 'string'	},
			     {name: 'USER_ID'		    , text: '<t:message code="system.label.base.userid" default="사용자ID"/>',			type: 'string', allowBlank: false	},
			     {name: 'USER_NAME'         , text: '<t:message code="system.label.base.username" default="사용자명"/>',			type: 'string', allowBlank: false	},
			     {name: 'GROUP_CODE'	    , text: '<t:message code="system.label.base.groupcode1" default="그룹코드"/>',			type: 'string', editable: false	},
			     {name: 'GROUP_NAME'	    , text: '<t:message code="system.label.base.groupname1" default="그룹명"/>',				type: 'string', editable: false	},
			     {name: 'INSERT_DB_USER'    , text: 'UPDATE_DB_TIME',	type: 'string'	},
			     {name: 'UPDATE_DB_USER'    , text: 'UPDATE_DB_USER',	type: 'string', defaultValue: UserInfo.userID},
			     {name: 'INSERT_DB_USER'    , text: 'INSERT_DB_TIME',	type: 'string'	},
			     {name: 'UPDATE_DB_USER'    , text: 'INSERT_DB_USER',	type: 'string', defaultValue: UserInfo.userID}
			     
		]
	});
	
	var directMasterStore = Unilite.createStore('bsa530ukrvDirectMasterStore', { 
		model: 'bsa530ukrvMasterModel',
		autoLoad: false,
		uniOpt: {
	    	isMaster: false,			// 상위 버튼 연결 
	    	editable: false,			// 수정 모드 사용 
	    	deletable: false,			// 삭제 가능 여부 
	        useNavi: false			// prev | next 버튼 사용
	    },
		proxy: {
			type: 'direct',
			api: {
				read: 	 'bsa530ukrvService.selecMastertList'				
			}
		}
		,loadStoreRecords: function(record)	{			
			var param  = Ext.getCmp('bsa530ukrvSearchForm').getValues();
			this.load({
				params : param
			});
		},
		listeners: {
           	load: function(store, records, successful, eOpts) {
           		if(!Ext.isEmpty(records)){
           			masterGrid.getSelectionModel().select(0);
           			directDetailStore.loadStoreRecords(records[0]);
           		}
           	}
		}
		
	});
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'bsa530ukrvService.selectDetailList',
			update: 'bsa530ukrvService.updateDetail',
			create: 'bsa530ukrvService.insertDetail',
			destroy: 'bsa530ukrvService.deleteDetail',
			syncAll: 'bsa530ukrvService.saveAll'
		}
	});
	var directDetailStore = Unilite.createStore('bsa530ukrvDirectDetailStore', { 
		model: 'bsa530ukrvDetailModel',
		autoLoad: false,
		uniOpt: {
	    	isMaster: true,			// 상위 버튼 연결 
	    	editable: true,			// 수정 모드 사용 
	    	deletable: true,			// 삭제 가능 여부 
	        useNavi: false			// prev | next 버튼 사용
	    },
		proxy: directProxy
		,loadStoreRecords: function(record)	{
			var gridParam = record.data; 
			var param  = Ext.getCmp('bsa530ukrvSearchForm').getValues();	
			var params = Ext.merge(gridParam , param);
			this.load({
				params : params
			});
		},saveStore : function(config)	{	
			var inValidRecs = this.getInvalidRecords();
        	
			if(inValidRecs.length == 0 )	{									
				config = {
					success: function(batch, option) {								
						panelSearch.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);	
						UniAppManager.app.onQueryButtonDown();
					 } 
				};
				this.syncAllDirect(config);
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
           	load: function(store, records, successful, eOpts) {
           		if(!Ext.isEmpty(records)){
//           			detailGrid.getSelectionModel().select(0);
           			UniAppManager.setToolbarButtons('deleteAll',false);
           		}
           	}
		}
		
	});	
		
	var panelSearch = Unilite.createSearchPanel('bsa530ukrvSearchForm', {          
		title: '<t:message code="system.label.base.searchconditon" default="검색조건"/>',         
		defaultType: 'uniSearchSubPanel',
		collapsed: UserInfo.appOption.collapseLeftSearch,
        listeners: {
	        collapse: function () {
	        	panelResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
	        }
	    },
		items: [{     
			title: '<t:message code="system.label.base.basisinfo2" default="기본정보"/>',   
			itemId: 'search_panel1',
			layout: {type: 'uniTable', columns: 1},
			items: [
				Unilite.popup('USER',{
				fieldLabel: '<t:message code="system.label.base.userid" default="사용자ID"/>',
				textFieldWidth:170, 
				popupWidth: 710,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('USER_ID', panelSearch.getValue('USER_ID'));
							panelResult.setValue('USER_NAME', panelSearch.getValue('USER_NAME'));
	                	},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('USER_ID', '');
						panelResult.setValue('USER_NAME', '');
					}
				}
			})]
		}]
	});
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [Unilite.popup('USER',{
				fieldLabel: '<t:message code="system.label.base.userid" default="사용자ID"/>',
				textFieldWidth:170, 
				popupWidth: 710,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('USER_ID', panelResult.getValue('USER_ID'));
							panelSearch.setValue('USER_NAME', panelResult.getValue('USER_NAME'));
	                	},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('USER_ID', '');
						panelSearch.setValue('USER_NAME', '');
					}
				}
			})]	
    });
		
   		
		
	// create the Grid			
	var masterGrid = Unilite.createGrid('bsa530ukrvMasterGrid', {
		region: 'west',
		store: directMasterStore,
		selModel: 'rowmodel',
//		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: true, toggleOnClick: false  }), 
		uniOpt: {
//	    	onLoadSelectFirst: false,
        	expandLastColumn: true,
			useMultipleSorting: true,
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: true
	    },
		columns: [{dataIndex: 'GROUP_CODE'      		,		width: 150, hidden: true	},//임시헤더
				  {dataIndex: 'GROUP_NAME'      		,		width: 200 }
		],
		listeners: {
			cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
				var needSave = !UniAppManager.app.getTopToolbar().getComponent('save').isDisabled();
				if(needSave) {
					Ext.Msg.show({
					     title:'<t:message code="system.label.base.confirm" default="확인"/>',
					     msg: Msg.sMB017 + "\n" + Msg.sMB061,
					     buttons: Ext.Msg.YESNOCANCEL,
					     icon: Ext.Msg.QUESTION,
					     fn: function(res) {
					     	//console.log(res);
					     	if (res === 'yes' ) {
					     		var saveTask =  Ext.create('Ext.util.DelayedTask', function(){
			                  		UniAppManager.app.onSaveAndQueryButtonDown();
			                    });
			                    saveTask.delay(500);
					     	} else if(res === 'no') {
					     		if(rowIndex != beforeRowIndex){
									directDetailStore.loadStoreRecords(record);
								}
								beforeRowIndex = rowIndex;
					     	}
					     }
					});
				} else {
					setTimeout(function(){
						if(rowIndex != beforeRowIndex){
							directDetailStore.loadStoreRecords(record);
						}
						beforeRowIndex = rowIndex;
						}
						, 500
					)
				}	
				
			}
        }		
		
	});
	
	
	var detailGrid = Unilite.createGrid('bsa530ukrvDetailGrid', {
		flex: 2,
		region: 'center',
		store: directDetailStore,
//		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: true, toggleOnClick: false  }), 
		uniOpt: {
//	    	onLoadSelectFirst: false,
        	expandLastColumn: true,
			useMultipleSorting: true,
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: true
	    },
		columns: [{dataIndex: 'COMP_CODE'		,		width: 100, hidden: true},
				  {dataIndex: 'USER_ID'		    ,		width: 133, 
				  	editor: Unilite.popup('USER_G', {
//	  					textFieldName: 'USER_ID',
//	 	 				DBtextFieldName: 'USER_ID',
	 	 				extParam: {SELMODEL: 'MULTI'},
	 	 				autoPopup:true,
		 				listeners: {'onSelected': {
		 								fn: function(records, type) {
	 										Ext.each(records, function(record,i) {
//	 											var grdRecord = detailGrid.getSelectedRecord();
	 											if(i==0) {
	 												var grdRecord = detailGrid.uniOpt.currentRecord;
	 												grdRecord.set('USER_ID', record['USER_ID']);
													grdRecord.set('USER_NAME', record['USER_NAME']);
	 											}else{
	 												UniAppManager.app.onNewDataButtonDown();
	 												var grdRecord = detailGrid.getSelectedRecord();
	 												grdRecord.set('USER_ID', record['USER_ID']);
													grdRecord.set('USER_NAME', record['USER_NAME']);
	 											}															
	 										}); 
		 								},
		 								scope: this
		 							},
		 							'onClear': function(type) {
//		 								var grdRecord = detailGrid.getSelectedRecord();
		 								var grdRecord = detailGrid.uniOpt.currentRecord;
		 								grdRecord.set('USER_ID', '');
										grdRecord.set('USER_NAME', '');
		 							}
		 				}
					 })},
				  {dataIndex: 'USER_NAME'       ,		width: 200, 
				  	editor: Unilite.popup('USER_G', {
//	  					textFieldName: 'USER_NAME',
//	  					DBtextFieldName: 'USER_NAME',
	 	 				extParam: {SELMODEL: 'MULTI'},
	 	 				autoPopup:true,
		 				listeners: {'onSelected': {
		 								fn: function(records, type) {								
	 										Ext.each(records, function(record,i) {
//	 											var grdRecord = detailGrid.getSelectedRecord();
												if(i==0) {
													var grdRecord = detailGrid.uniOpt.currentRecord;
	 												grdRecord.set('USER_ID', record['USER_ID']);
													grdRecord.set('USER_NAME', record['USER_NAME']);
	 											}else{
	 												UniAppManager.app.onNewDataButtonDown();
	 												var grdRecord = detailGrid.getSelectedRecord();
	 												grdRecord.set('USER_ID', record['USER_ID']);
													grdRecord.set('USER_NAME', record['USER_NAME']);
	 											}
	 										}); 
		 								},
		 								scope: this
		 							},
		 							'onClear': function(type) {
//		 								var grdRecord = detailGrid.getSelectedRecord();
		 								var grdRecord = detailGrid.uniOpt.currentRecord;
		 								grdRecord.set('USER_ID', '');
										grdRecord.set('USER_NAME', '');
		 							}
		 				}
					 })},
				  {dataIndex: 'GROUP_CODE'	    ,		width: 100, hidden: true},
				  {dataIndex: 'GROUP_NAME'	    ,		width: 100},
				  {dataIndex: 'INSERT_DB_USER'  ,		width: 66, hidden: true},
				  {dataIndex: 'UPDATE_DB_USER'  ,		width: 66, hidden: true}				  
		],
		listeners:{
			beforeedit  : function( editor, e, eOpts ) {      			
      			if(!e.record.phantom){			      				
      				return false;
      			}
       		}
		
		}
		
	});
		

    Unilite.Main({
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[masterGrid, detailGrid, panelResult]	
		}		
		,panelSearch
		],
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons(['reset','newData'],true);			
			directMasterStore.loadStoreRecords();
		}
		, onQueryButtonDown: function() {
			beforeRowIndex = -1;
			var record = masterGrid.getSelectedRecord();
			directDetailStore.loadStoreRecords(record)
//			directMasterStore.loadStoreRecords();
		}

		, onSaveDataButtonDown: function () {										
			directDetailStore.saveStore();	
		}
		,
		onResetButtonDown: function() {
			detailGrid.reset();			
			panelSearch.clearForm();
			panelResult.clearForm();			
			this.fnInitBinding();
		},
		onNewDataButtonDown : function()	{
			var record = masterGrid.getSelectedRecord();
			if(!Ext.isEmpty(record)){
				var groupCode = record.get('GROUP_CODE');
	        	var groupName = record.get('GROUP_NAME');
	        	var r = {
	        		GROUP_CODE: groupCode,
					GROUP_NAME: groupName
		        };	        
	//			detailGrid.createRow(r, null, detailGrid.getStore().getCount() - 1 == 0 ? 2 : detailGrid.getStore().getCount() - 1);
		        detailGrid.createRow(r);
			}
		},
		 onDeleteDataButtonDown: function() {
			var selRow = detailGrid.getSelectedRecord();
			if(selRow.phantom === true)	{
				detailGrid.deleteSelectedRow();
			}else if(confirm('<t:message code="system.message.base.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
				detailGrid.deleteSelectedRow();				
			}
		},
		 onDeleteAllButtonDown: function() {
//			if(confirm('삭제 하시겠습니까?')) {
//				detailGrid.reset();
//				UniAppManager.app.onSaveDataButtonDown();
//			}
		},
		onSaveAndQueryButtonDown : function()	{
			this.onSaveDataButtonDown();
			//this.onQueryButtonDown();
		}
	});

		

};	// appMain
</script>