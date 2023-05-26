<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
//운영자 공통코드 등록
request.setAttribute("PKGNAME","Unilite_app_bsa100ukrv");
%>
<t:appConfig pgmId="bsa100ukrv" >
	<t:ExtComboStore comboType="AU" comboCode="B018" />
	<t:ExtComboStore comboType="AU" comboCode="B010" />
</t:appConfig>
<script type="text/javascript">
	
function appMain() {

		Unilite.defineModel('${PKGNAME}MasterCodeModel', {
			fields : [ {name : 'MAIN_CODE',			text : '<t:message code="system.label.base.commoncode" default="종합코드"/>',			type : 'string',    allowBlank:false, isPk:true,  pkGen:'user', readOnly:true	}
					 , {name : 'CODE_NAME',			text : '<t:message code="system.label.base.commoncodename" default="종합코드명"/>',		type : 'string',	allowBlank:false  }
					 , {name : 'SYSTEM_CODE_YN',	text : '<t:message code="system.label.base.system" default="시스템"/>',			type : 'string',	allowBlank:false, comboType : 'AU', comboCode : 'B018', defaultValue:'2'}
					 , {name : 'SUB_LENGTH',		text: '<t:message code="system.label.base.length" default="길이"/>',				type : 'int',		allowBlank:false}
					 , {name : 'REF_CODE1',			text: '<t:message code="system.label.base.refer1" default="관련1"/>',				type : 'string'		}
					 , {name : 'REF_CODE2',			text: '<t:message code="system.label.base.refer2" default="관련2"/>',				type : 'string'		}
					 , {name : 'REF_CODE3',			text: '<t:message code="system.label.base.refer3" default="관련3"/>',				type : 'string'		}
					 , {name : 'REF_CODE4',			text: '<t:message code="system.label.base.refer4" default="관련4"/>',				type : 'string'		}
					 , {name : 'REF_CODE5',			text: '<t:message code="system.label.base.refer5" default="관련5"/>',				type : 'string'		}
					 , {name : 'REF_CODE6',			text: '<t:message code="system.label.base.refer6" default="관련6"/>',				type : 'string'		}
					 , {name : 'REF_CODE7',			text: '<t:message code="system.label.base.refer7" default="관련7"/>',				type : 'string'		}
					 , {name : 'REF_CODE8',			text: '<t:message code="system.label.base.refer8" default="관련8"/>',				type : 'string'		}
					 , {name : 'REF_CODE9',			text: '<t:message code="system.label.base.refer9" default="관련9"/>',				type : 'string'		}
					 , {name : 'REF_CODE10',		text: '<t:message code="system.label.base.reter10" default="관련10"/>',				type : 'string'		} 
					 , {name : 'SUB_CODE',			text: '<t:message code="system.label.base.subcode" default="상세코드"/>',			type : 'string',		defaultValue:'$'	} 
					 , {name : 'USE_YN',			text: '<t:message code="system.label.base.useyn" default="사용여부"/>',			type : 'string',		defaultValue:'Y'	, comboType : 'AU', comboCode : 'B010'} 
					 , {name : 'SORT_SEQ',			text: '<t:message code="system.label.base.arrangeorder" default="정렬순서"/>',			type : 'string',		defaultValue:1 }
					]
		});
		
		var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
			api: {
				read : 	 'bsa101ukrvService.selectMasterCodeList',
				create : 'bsa101ukrvService.insertCodes',
				update : 'bsa101ukrvService.updateCodes',
				destroy: 'bsa101ukrvService.deleteCodes',
				syncAll: 'bsa101ukrvService.saveAll'
			}
		});
		
		var directMasterStore = Unilite.createStore('${PKGNAME}MasterStore', { 
			model : '${PKGNAME}MasterCodeModel',
			autoLoad : false,
			uniOpt : {
            	isMaster: false,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:true,			// 삭제 가능 여부 
	            useNavi : false			// prev | newxt 버튼 사용
            },
			proxy : directProxy,
			loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();	
				this.load({
					params : param
				});
			},
			saveStore : function()	{
					var inValidRecs = this.getInvalidRecords();
					if(inValidRecs.length == 0 )	{
						var config = {
									params:[panelSearch.getValues()],
									success : function()	{
													if(directDetailStore.isDirty())	{
														directDetailStore.saveStore();
													}
													/*var record = masterGrid.getSelectedRecords();
													if(record)	{
														masterGrid.setDetailGrd(masterGrid, record);
													}*/
												}
									}
						this.syncAllDirect(config);			
					}else {
						var grid = Ext.getCmp('${PKGNAME}Grid');
						grid.uniSelectInvalidColumnAndAlert(inValidRecs);
					}
				
			},
			listeners:{
				load: function(store, records, successful, eOpts) {
	           		if(records != null && records.length > 0 ){
	           			UniAppManager.setToolbarButtons('delete', true);
	           		}
				},
				update : function( store, record, operation, modifiedFieldNames, details, eOpts ){
					UniAppManager.setToolbarButtons('save', true);		
				},
				datachanged : function(store,  eOpts) {
					if( directDetailStore.isDirty() || store.isDirty())	{
						UniAppManager.setToolbarButtons('save', true);	
					}else {
						UniAppManager.setToolbarButtons('save', false);
					}
				}
			}  
		});
		
		Unilite.defineModel('DetailCodeModel', {
			fields : [ 	  {name : 'MAIN_CODE',		text : '<t:message code="system.label.base.commoncode" default="종합코드"/>'	, allowBlank : false, readOnly:true}
						, {name : 'SUB_CODE',		text : '<t:message code="system.label.base.subcode" default="상세코드"/>'	, allowBlank : false, isPk:true,  pkGen:'user', readOnly:true}
						, {name : 'CODE_NAME',		text : '<t:message code="system.label.base.subcodename" default="상세코드명"/>'	, allowBlank : false}
						, {name : 'SYSTEM_CODE_YN',	text : '<t:message code="system.label.base.system" default="시스템"/>',	type : 'string',		comboType : 'AU', comboCode : 'B018', defaultValue:'2'}
						, {name : 'SORT_SEQ',		text: '<t:message code="system.label.base.arrangeorder" default="정렬순서"/>',	type : 'int',			defaultValue:1	, allowBlank : false}
						, {name : 'REF_CODE1',		text: '<t:message code="system.label.base.refer1" default="관련1"/>',		type : 'string'	}
						, {name : 'REF_CODE2',		text: '<t:message code="system.label.base.refer2" default="관련2"/>',		type : 'string'	}
						, {name : 'REF_CODE3',		text: '<t:message code="system.label.base.refer3" default="관련3"/>',		type : 'string'	}
						, {name : 'REF_CODE4',		text: '<t:message code="system.label.base.refer4" default="관련4"/>',		type : 'string'	}
						, {name : 'REF_CODE5',		text: '<t:message code="system.label.base.refer5" default="관련5"/>',		type : 'string'	}
						, {name : 'REF_CODE6',		text: '<t:message code="system.label.base.refer6" default="관련6"/>',		type : 'string'	}
						, {name : 'REF_CODE7',		text: '<t:message code="system.label.base.refer7" default="관련7"/>',		type : 'string'	}
						, {name : 'REF_CODE8',		text: '<t:message code="system.label.base.refer8" default="관련8"/>',		type : 'string'	}
						, {name : 'REF_CODE9',		text: '<t:message code="system.label.base.refer9" default="관련9"/>',		type : 'string'	}
						, {name : 'REF_CODE10',		text: '<t:message code="system.label.base.reter10" default="관련10"/>',		type : 'string'	} 
						, {name : 'USE_YN',			text: '<t:message code="system.label.base.useyn" default="사용여부"/>',	type : 'string',		defaultValue:'Y'	, allowBlank : false, comboType : 'AU', comboCode : 'B010'} 
						]
		});
		var directProxyDetail = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
			api: {
				read 	: 'bsa101ukrvService.selectDetailCodeList',
				create 	: 'bsa101ukrvService.insertCodes',
				update 	: 'bsa101ukrvService.updateCodes',
				destroy	: 'bsa101ukrvService.deleteCodes',
				syncAll	: 'bsa101ukrvService.saveAll'
			}
		});
		var directDetailStore = Unilite.createStore('directDetailStore', { 
			model : 'DetailCodeModel',
			autoLoad : false,
			uniOpt : {
            	isMaster: false,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:true,			// 삭제 가능 여부 
	            useNavi : false			// prev | newxt 버튼 사용
            },
			proxy : directProxyDetail
			,loadStoreRecords : function(mainCode)	{
					this.load({
						params : {
							MAIN_CODE : mainCode
						}
					});
			}
			,saveStore : function()	{
					var inValidRecs = this.getInvalidRecords();
					if(inValidRecs.length == 0 )	{
						var config = {
						params:[panelSearch.getValues()],
						success : function()	{}									
						}
						this.syncAllDirect(config);	
					}else {
						var grid = Ext.getCmp('${PKGNAME}DetailGrid');
						grid.uniSelectInvalidColumnAndAlert(inValidRecs);
					}
					
			},
			listeners:{
				load: function(store, records, successful, eOpts) {
	           		if(records != null && records.length > 0 ){
	           			UniAppManager.setToolbarButtons('delete', true);
	           		}
				},
				update : function( store, record, operation, modifiedFieldNames, details, eOpts ){
					UniAppManager.setToolbarButtons('save', true);		
				},
				datachanged : function(store,  eOpts) {
					if( directMasterStore.isDirty() || store.isDirty() )	{
						UniAppManager.setToolbarButtons('save', true);	
					}else {
						UniAppManager.setToolbarButtons('save', false);
					}
				}
			}
		});

		// create the Grid
		var masterGrid = Unilite.createGrid('${PKGNAME}Grid', {
			region:'center',
			enableColumnMove: false,
			store: directMasterStore,
			uniOpt:{
				useRowNumberer: true,
				copiedRow : true,
	        	expandLastColumn: false
	        },
	        itemId:'${PKGNAME}Grid',
			columns : [   {dataIndex : 'MAIN_CODE',			width : 80		}
						, {dataIndex : 'CODE_NAME',			width : 150		}
						, {dataIndex : 'SUB_LENGTH',		width : 60		}
						, {dataIndex : 'SYSTEM_CODE_YN',	width : 110		}
						, {dataIndex : 'REF_CODE1',			width : 110		}
						, {dataIndex : 'REF_CODE2',			width : 110		}
						, {dataIndex : 'REF_CODE3',			width : 110		}
						, {dataIndex : 'REF_CODE4',			width : 110		}
						, {dataIndex : 'REF_CODE5',			width : 110		}
						, {dataIndex : 'REF_CODE6',			width : 110		}
						, {dataIndex : 'REF_CODE7',			width : 110		}
						, {dataIndex : 'REF_CODE8',			width : 110		}
						, {dataIndex : 'REF_CODE9',			width : 110		}
						, {dataIndex : 'REF_CODE10',		width : 110		} 
					],
			listeners : {
				render: function(grid, eOpts){
				 	var girdNm = grid.getItemId();
				 	var store = grid.getStore();
				    grid.getEl().on('click', function(e, t, eOpt) {
				    	activeGridId = girdNm;
				    	//store.onStoreActionEnable();
				    	if( directMasterStore.isDirty() || directDetailStore.isDirty() )	{
							UniAppManager.setToolbarButtons('save', true);	
						}else {
							UniAppManager.setToolbarButtons('save', false);
						}
				    	if(grid.getStore().getCount() > 0)	{
							UniAppManager.setToolbarButtons('delete', true);		
						}else {
							UniAppManager.setToolbarButtons('delete', false);
						}
				    });
				 }
		
				,beforedeselect : function ( gird, record, index, eOpts )
								{
									var detailStore = Ext.getCmp('${PKGNAME}DetailGrid').getStore();	
									if(detailStore.isDirty())	{
										if(confirm(Msg.sMB017 + "\n" + Msg.sMB061))	{
											var inValidRecs = detailStore.getInvalidRecords();
											if(inValidRecs.length > 0 )	{
												Unilite.messageBox(Msg.sMB083);
												return false;
											}else {
												detailStore.saveStore();
											}
										}
									}
								}
				,selectionchange : function(grid, selected, eOpts) {
								this.setDetailGrd( selected, eOpts)	;						
								
							}
			}
			, setDetailGrd : function (selected, eOpts) {
								if(selected.length > 0)	{
									var dgrid = Ext.getCmp('${PKGNAME}DetailGrid');	
									var record = selected[0];
									for(var i =1; i<11; i++) {
										this.setColumnHeader(record,dgrid,'REF_CODE'+i,'관련'+i);
									}
									dgrid.getStore().loadStoreRecords(record.data['MAIN_CODE']);
								}
							}
			, setColumnHeader:function(record, grid, indexName, def) {
				var d = record.get(indexName);
				var column = grid.getColumn(indexName);

				if(Ext.isEmpty(column))  {
					return ;
				}
				if(!Ext.isEmpty(d)) {
					column.setText(d);
				} else {
					column.setText(def);
				}
			}
			
		});
		
		var detailGrid =  Unilite.createGrid('${PKGNAME}DetailGrid', {
			enableColumnMove: false,
			itemId:'${PKGNAME}DetailGrid',
			store : directDetailStore,
			uniOpt:{
	        	expandLastColumn: false
	        },
			columns : [   {dataIndex : 'id',				width: 130,		hidden: true}
						, {	dataIndex : 'MAIN_CODE',		width : 130	, 	hidden : true}
						, {	dataIndex : 'SUB_CODE',			width : 130	}
						, {	dataIndex : 'CODE_NAME',		width : 200,	tooltip : true	}
						, {	dataIndex : 'SYSTEM_CODE_YN',	width : 80	}
						, {	dataIndex : 'SORT_SEQ',			width : 80	}
						, {	dataIndex : 'REF_CODE1',		width : 110,	hidden : false	}
						, {	dataIndex : 'REF_CODE2',		width : 110,	hidden : false	}
						, {	dataIndex : 'REF_CODE3',		width : 110,	hidden : false	}
						, {	dataIndex : 'REF_CODE4',		width : 110,	hidden : false	}
						, {	dataIndex : 'REF_CODE5',		width : 110,	hidden : false	}
						, {	dataIndex : 'REF_CODE6',		width : 110,	hidden : false	}
						, {	dataIndex : 'REF_CODE7',		width : 110,	hidden : false	}
						, {	dataIndex : 'REF_CODE8',		width : 110,	hidden : false	}
						, {	dataIndex : 'REF_CODE9',		width : 110,	hidden : false	}
						, {	dataIndex : 'REF_CODE10',		width : 110,	hidden : false	}  
						, {	dataIndex : 'USE_YN',			width : 110	}  
					],
			listeners : {
				render: function(grid, eOpts){
				 	var girdNm = grid.getItemId();
				 	var store = grid.getStore();
				    grid.getEl().on('click', function(e, t, eOpt) {
				    	activeGridId = girdNm;
				    	if( directMasterStore.isDirty() || directDetailStore.isDirty() )	{
							UniAppManager.setToolbarButtons('save', true);	
						}else {
							UniAppManager.setToolbarButtons('save', false);
						}
				    	if(grid.getStore().getCount() > 0)	{
							UniAppManager.setToolbarButtons('delete', true);		
						}else {
							UniAppManager.setToolbarButtons('delete', false);
						}
				    });
				 }
			}
		});
	
		var panelSearch = Unilite.createSearchPanel('searchForm',{
				region : 'west',
				title: '<t:message code="system.label.base.searchconditon" default="검색조건"/>',
				defaultType: 'uniSearchSubPanel',
		        listeners: {
		        collapse: function () {
		        	panelResult.show();
		        },
		        expand: function() {
		        	panelResult.hide();
		        }
		    },
			defaults: {
				autoScroll:true
		  	},
			items:[{
				title: '<t:message code="system.label.base.basisinfo2" default="기본정보"/>', 	
				id: 'search_panel1',
	   			itemId: 'search_panel1',
	           	layout: {type: 'uniTable', columns: 1},
	           	defaultType: 'uniTextfield',   			
		    	items:[{
		    		fieldLabel : '<t:message code="system.label.base.commoncode" default="종합코드"/>',
		    		name : 'MAIN_CODE',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('MAIN_CODE', newValue);
						}
					}
				}, {
					fieldLabel : '<t:message code="system.label.base.commoncodename" default="종합코드명"/>',
					name : 'MAIN_CODE_NAME',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('MAIN_CODE_NAME', newValue);
						}
					}
				}]
			}]
		});	//end panelSearch    
	
		var panelResult = Unilite.createSearchForm('resultForm',{
			weight:-100,
	    	region: 'north',
			layout : {type : 'uniTable', columns : 3},
			padding:'1 1 1 1',
			border:true,
			hidden: !UserInfo.appOption.collapseLeftSearch,
			items: [{
	    		fieldLabel : '<t:message code="system.label.base.commoncode" default="종합코드"/>',
	    		name : 'MAIN_CODE',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('MAIN_CODE', newValue);
					}
				}
			}, {
				fieldLabel : '<t:message code="system.label.base.commoncodename" default="종합코드명"/>',
				name : 'MAIN_CODE_NAME',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('MAIN_CODE_NAME', newValue);
					}
				}
			}]	
	    });	
			//
			
	    Unilite.Main({
				items : [ panelResult, {
					xtype : 'container',
					flex : 1,
					layout : 'border',
					defaults : {
						collapsible : false,
						split : true
					},
					items : [ {
						region : 'center',
						xtype : 'container',
						layout : 'fit',
						items : [ masterGrid ]
					}, {
						region : 'east',
						xtype : 'container',
						layout : 'fit',
						flex : 3,
						items : [ detailGrid ]
					}, panelSearch ]
	
				} ]
				,fnInitBinding : function() {
					UniAppManager.setToolbarButtons(['reset', 'newData'],true);
				}
				, onQueryButtonDown:function() {
	//				if(!UniAppManager.app._needSave())	{
						masterGrid.getStore().loadStoreRecords();
	//				}
				}
				, onNewDataButtonDown : function()	{
					if(activeGridId == '${PKGNAME}Grid' )	{ 
						
						var r = masterGrid.createRow();
				    	
					}else if(activeGridId == '${PKGNAME}DetailGrid') 	{
						var pRecord = masterGrid.getSelectedRecord();
						if(pRecord != null)	{
							var value = {'MAIN_CODE': pRecord.data['MAIN_CODE']};
							detailGrid.createRow(value);
						}else {
							Unilite.messageBox('종합코드를 선택하세요.');
						}
					}
				}
				, onSaveDataButtonDown: function () {										
						if(directMasterStore.isDirty())	{									
							directMasterStore.saveStore();	//Master 데이타 저장 성공 후 Detail 저장함.			
						}else if(directDetailStore.isDirty())	{
							directDetailStore.saveStore();						
						}
						
					}
				, onDeleteDataButtonDown : function()	{
						if(confirm(Msg.sMB045))	{
							if(activeGridId == '${PKGNAME}Grid' )	{
								var selIndex = masterGrid.getSelectedRowIndex();
								var record = masterGrid.getSelectedRecord();
							
								if(record.phantom !== true && 
								   (directMasterStore.isDirty() && record.data['SYSTEM_CODE_YN'] == '1') || 
								   (!directMasterStore.isDirty() && record.data['SYSTEM_CODE_YN'] == '1')
								  )	
								{
									Unilite.messageBox(Msg.sMB088);
								}else if(directDetailStore.getCount() > 0 ) {
									Unilite.messageBox(Msg.sMB161);
								}else {
									masterGrid.deleteSelectedRow(selIndex);
								}
							} else {
								var selIndex = detailGrid.getSelectedRowIndex();
								var record = detailGrid.getSelectedRecord();
								
								if(record.phantom !== true && 
								   (directDetailStore.isDirty() && record.data['SYSTEM_CODE_YN'] == '1') || 
								   (!directDetailStore.isDirty() && record.data['SYSTEM_CODE_YN'] == '1')
								  )	
								{
									Unilite.messageBox(Msg.sMB088);
								}else {
									detailGrid.deleteSelectedRow(selIndex);	
								}
							}
						}
						
					},
					onResetButtonDown: function() {
	//					if(!UniAppManager.app._needSave())	{
							panelSearch.clearForm();
							
							masterGrid.getStore().loadData({});
							detailGrid.getStore().loadData({});
	//					}
					}	
			});
		
		
		var activeGridId = '${PKGNAME}Grid';

};	// appMain
</script>