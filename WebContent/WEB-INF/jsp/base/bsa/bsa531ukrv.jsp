<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bsa531ukrv" >
	<t:ExtComboStore comboType="AU" comboCode="B007" /><!-- 업무구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B003" /><!-- 프로그램사용 권한 -->
	<t:ExtComboStore comboType="AU" comboCode="B006" /><!-- 파일저장 사용권한 -->
	<t:ExtComboStore comboType="AU" comboCode="BS06" /><!-- 권한범위-사업장 -->
</t:appConfig>
<script type="text/javascript">
	
function appMain() {
	var beforeRowIndex;
	
	Unilite.defineModel('bsa531ukrvMasterModel', {
	
		fields: [{name: 'GROUP_CODE'    		, text: '권한그룹코드',			type: 'string'	},
				 {name: 'GROUP_NAME'    		, text: '권한그룹명',			type: 'string'	}
		]
	});
	
	Unilite.defineModel('bsa531ukrvDetailModel', {
	
		fields: [{name: 'COMP_CODE'		    , text: '<t:message code="system.label.base.companycode" default="법인코드"/>',			type: 'string'	},
			     {name: 'USER_NAME'         , text: '성명',				type: 'string', allowBlank: false	},
			     {name: 'GROUP_CODE'	    , text: '그룹코드',			type: 'string', editable: false	},
			     {name: 'GROUP_NAME'	    , text: '그룹명',				type: 'string', editable: false	},
			     {name: 'INSERT_DB_USER'    , text: 'UPDATE_DB_TIME',	type: 'string'	},
			     {name: 'INSERT_DB_USER'    , text: 'UPDATE_DB_TIME',	type: 'string'	},
			     {name: 'UPDATE_DB_USER'    , text: 'UPDATE_DB_USER',	type: 'string', defaultValue: UserInfo.userID},
			     {name: 'INSERT_DB_USER'    , text: 'INSERT_DB_TIME',	type: 'string'	},
			     {name: 'PERSON_NUMB'    	, text: '사번',				type: 'string' , allowBlank: false}
			     
		]
	});
	
	var directMasterStore = Unilite.createStore('bsa531ukrvDirectMasterStore', { 
		model: 'bsa531ukrvMasterModel',
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
				read: 	 'bsa531ukrvService.selecMastertList'				
			}
		}
		,loadStoreRecords: function(record)	{			
			var param  = Ext.getCmp('bsa531ukrvSearchForm').getValues();
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
			read: 'bsa531ukrvService.selectDetailList',
			update: 'bsa531ukrvService.updateDetail',
			create: 'bsa531ukrvService.insertDetail',
			destroy: 'bsa531ukrvService.deleteDetail',
			syncAll: 'bsa531ukrvService.saveAll'
		}
	});

	var directDetailStore = Unilite.createStore('bsa531ukrvDirectDetailStore', { 
		model: 'bsa531ukrvDetailModel',
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
			var param  = Ext.getCmp('bsa531ukrvSearchForm').getValues();	
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
           			detailGrid.getSelectionModel().select(0);
           		}
           	}
		}
		
	});	
		
	var panelSearch = Unilite.createSearchPanel('bsa531ukrvSearchForm', {          
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
				Unilite.popup('Employee',{
				
				textFieldWidth:170, 
				popupWidth: 710,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('PERSON_NUMB', panelSearch.getValue('PERSON_NUMB'));
							panelResult.setValue('NAME', panelSearch.getValue('NAME'));
	                	},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('PERSON_NUMB', '');
						panelResult.setValue('NAME', '');
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
		items: [
			Unilite.popup('Employee',{
				
				textFieldWidth:170, 
				popupWidth: 710,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('PERSON_NUMB'	, panelResult.getValue('PERSON_NUMB'));
							panelSearch.setValue('NAME'			, panelResult.getValue('NAME'));
	                	},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('PERSON_NUMB', '');
						panelSearch.setValue('NAME', '');
					}
				}
			})]	
    });
		
   		
		
	// create the Grid			
	var masterGrid = Unilite.createGrid('bsa531ukrvMasterGrid', {
		region: 'west',
		store: directMasterStore,
		selModel: 'rowmodel',
		//selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: true, toggleOnClick: false  }), 
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
					     title:'확인',
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
	
	
	var detailGrid = Unilite.createGrid('bsa531ukrvDetailGrid', {
		flex: 2,
		region: 'center',
		store: directDetailStore,
		//selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: true, toggleOnClick: false  }), 
		uniOpt: {
//	    	onLoadSelectFirst: false,
        	expandLastColumn: true,
			useMultipleSorting: true,
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: true
	    },
		columns: [{dataIndex: 'COMP_CODE'		,		width: 100, hidden: true},
				  {dataIndex: 'PERSON_NUMB'		    ,		width: 133, 
				  	editor: Unilite.popup('Employee_G', {
	  					textFieldName: 'PERSON_NUMB',
	 	 				DBtextFieldName: 'PERSON_NUMB',
	 	 				extParam: {SELMODEL: 'MULTI'},
			  			autoPopup: true,
		 				listeners: {'onSelected': {
		 								fn: function(records, type) {
	 										Ext.each(records, function(record,i) {
	 											var grdRecord = detailGrid.getSelectedRecord();
	 											if(i==0) {
	 												grdRecord.set('PERSON_NUMB', record['PERSON_NUMB']);
													grdRecord.set('USER_NAME', record['NAME']);
	 											}else{
	 												UniAppManager.app.onNewDataButtonDown();
	 												grdRecord = detailGrid.getSelectedRecord();
	 												grdRecord.set('PERSON_NUMB', record['PERSON_NUMB']);
													grdRecord.set('USER_NAME', record['NAME']);
	 											}															
	 										}); 
		 								},
		 								scope: this
		 							},
		 							'onClear': function(type) {
		 								var grdRecord = detailGrid.getSelectedRecord();
		 								grdRecord.set('PERSON_NUMB', '');
										grdRecord.set('NAME', '');
		 							}
		 				}
					 })},
				  {dataIndex: 'USER_NAME'       ,		width: 200, 
				  	editor: Unilite.popup('Employee_G', {
	  					textFieldName: 'NAME',
	  					DBtextFieldName: 'NAME',
	 	 				extParam: {SELMODEL: 'MULTI'},
			  			autoPopup: true,
		 				listeners: {'onSelected': {
		 								fn: function(records, type) {	
		 									//Unilite.messageBox('records : ', records);					 									
	 										Ext.each(records, function(record,i) {
	 											var grdRecord = detailGrid.getSelectedRecord();
												if(i==0) {
	 												grdRecord.set('PERSON_NUMB', record['PERSON_NUMB']);
													grdRecord.set('USER_NAME', record['NAME']);
	 											}else{
	 												UniAppManager.app.onNewDataButtonDown();
	 												grdRecord = detailGrid.getSelectedRecord();
	 												grdRecord.set('PERSON_NUMB', record['PERSON_NUMB']);
													grdRecord.set('USER_NAME', record['NAME']);
	 											}
	 										}); 
		 								},
		 								scope: this
		 							},
		 							'onClear': function(type) {
		 								var grdRecord = detailGrid.getSelectedRecord();
		 								grdRecord.set('PERSON_NUMB', '');
										grdRecord.set('NAME', '');
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
				var compCode = UserInfo.compCode;
				var groupCode = record.get('GROUP_CODE');
	        	var groupName = record.get('GROUP_NAME');
	        	var r = {
	        		COMP_CODE : compCode,
	        		GROUP_CODE: groupCode,
					GROUP_NAME: groupName
		        };	        
	//			detailGrid.createRow(r, null, detailGrid.getStore().getCount() - 1 == 0 ? 2 : detailGrid.getStore().getCount() - 1);
		        detailGrid.createRow(r);
			}
		},
		 onDeleteDataButtonDown: function() {
			if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {				
				detailGrid.deleteSelectedRow();
			}
		},
		 /*onDeleteAllButtonDown: function() {			
			var records = detailStore.data.items;
			var isNewData = false;
			Ext.each(records, function(record,i) {
				if(record.phantom){						//신규 레코드일시 isNewData에 true를 반환
					isNewData = true;
				}else{									//신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
					isNewData = false;
					if(confirm('전체삭제 하시겠습니까?')) {
						var deletable = true;
						
						if(deletable){		
							detailGrid.reset();			
							UniAppManager.app.onSaveDataButtonDown();	
						}													
					}
					return false;
				}
			});
			if(isNewData){								//신규 레코드들만 있을시 그리드 리셋		   
				detailGrid.reset();
				UniAppManager.app.onResetButtonDown();	//삭제후 RESET..
			}
			
		},*/
		onSaveAndQueryButtonDown : function()	{			
			this.onSaveDataButtonDown();
			//this.onQueryButtonDown();
		}
	});

		
};	// appMain
</script>