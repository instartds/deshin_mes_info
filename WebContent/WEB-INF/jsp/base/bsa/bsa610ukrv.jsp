<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bsa610ukrv" >
	<t:ExtComboStore comboType="AU" comboCode="B003" /><!-- 자료수정 -->
	<t:ExtComboStore comboType="AU" comboCode="B006" /><!-- 파일저장 -->
	<t:ExtComboStore comboType="AU" comboCode="BS06" /><!-- 자료권한 -->
	<t:ExtComboStore comboType= "AU" comboCode="B010"  /> <!-- 사용여부 -->
</t:appConfig>
<script type="text/javascript">
	
function appMain() {
		var masterSelectedGrid = 'bsa610ukrvMasterGrid';  
		var beforeRowIndex;
		var pgmGrp;
		Unilite.defineModel('bsa610ukrvMasterModel', {
			fields : [ {name : 'GROUP_SORT_SEQ',	text : '그룹정렬순서',		type : 'int' }
					 , {name : 'PGM_GROUP',			text : '프로그램그룹',		type : 'string' }	
					 , {name : 'PGM_ID',			text : '프로그램ID',		type : 'string' }	
					 , {name : 'COMP_CODE',			text : '<t:message code="system.label.base.companycode" default="법인코드"/>',			type : 'string', allowBlank:false }
					]
		});
		
		Unilite.defineModel('bsa610ukrvDetailModel', {
			fields : [ {name : 'PGM_ID',			text : 'PGM_ID',			type : 'string'	, allowBlank:false}
					 , {name : 'GROUP_SORT_SEQ',	text : '그룹정렬순서',		type : 'string' }
					 , {name : 'PGM_NAME',			text : '프로그램명',		type : 'string' }
					 , {name : 'PGM_GROUP',			text : '프로그램그룹',		type : 'string' }
					 , {name : 'PGM_SORT_SEQ',		text : '프로그램정렬순서',	type : 'int' }
					 , {name : 'LOCATION',			text : '로케이션',			type : 'string' }
					 , {name : 'TYPE',				text : '타입',				type : 'string' }
					 , {name : 'USE_YN',			text : '<t:message code="system.label.base.useyn" default="사용여부"/>',			type : 'string'	,comboType:'AU', comboCode:'B010'}	
					 , {name : 'COMP_CODE',			text : '<t:message code="system.label.base.companycode" default="법인코드"/>',			type : 'string', allowBlank:false }
					]
		});			
		
		var directProxy1 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
			api: {
				read : 'bsa610ukrvService.selectMastertList',
//				update: 'bsa610ukrvService.updatePrograms',
				create : 'bsa610ukrvService.insertPrograms1',
				destroy: 'bsa610ukrvService.deletePrograms1',
				syncAll: 'bsa610ukrvService.saveAll1'
			}
		});		

		var directMasterStore = Unilite.createStore('bsa610ukrvMasterStore', { 
			model : 'bsa610ukrvMasterModel',
			autoLoad : false,
			uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:true,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
			proxy : directProxy1,
			loadStoreRecords : function()	{
				var param= [];	
				this.load({
					params : param
				});
			},
			saveStore : function(config)	{	
				var inValidRecs = this.getInvalidRecords();
				var toCreate = this.getNewRecords();
            	var toUpdate = this.getUpdatedRecords();
            	console.log("toUpdate",toUpdate);

            	var rv = true;
       	
            	if(inValidRecs.length == 0 )	{										
					config = {
						success: function(batch, option) {								
							//panelResult.resetDirtyStatus();
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
	           			masterGrid.getSelectionModel().select(0);
	           			directDetailStore.loadStoreRecords(records[0]);
	           		}
	           	}
			}			
		});	

		
		var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
			api: {
				read : 'bsa610ukrvService.selectDetailList',
				update: 'bsa610ukrvService.updatePrograms2',
				create : 'bsa610ukrvService.insertPrograms2',
				destroy: 'bsa610ukrvService.deletePrograms2',
				syncAll: 'bsa610ukrvService.saveAll2'
			}
		});
		
		var directDetailStore = Unilite.createStore('bsa610ukrvDirectDetailStore', { 
			model : 'bsa610ukrvDetailModel',
			autoLoad : false,
			uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:true,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
			proxy : directProxy2,
			loadStoreRecords : function(record)	{
				var param = record.data;	
					this.load({
						params : param
					});
			},	
			listeners: {
	           	load: function(store, records, successful, eOpts) {
	           		if(!Ext.isEmpty(records)){
	//           			detailGrid.getSelectionModel().select(0);
	           			UniAppManager.setToolbarButtons('deleteAll',false);
	           		}
	           	}
			},	
			saveStore : function(config)	{	
				var inValidRecs = this.getInvalidRecords();
				var toCreate = this.getNewRecords();
            	var toUpdate = this.getUpdatedRecords();
            	console.log("toUpdate",toUpdate);

            	var rv = true;
       	
            	if(inValidRecs.length == 0 )	{										
					config = {
						success: function(batch, option) {								
							//panelResult.resetDirtyStatus();
							UniAppManager.setToolbarButtons('save', false);	
							UniAppManager.app.onQueryButtonDown();
						 } 
					};					
					this.syncAllDirect(config);
				}else {
					detailGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			}
		});

		
	// create the Grid
	var masterGrid = Unilite.createGrid('bsa610ukrvMasterGrid', {
		region: 'west',
		store: directMasterStore,
		itemId:'bsa610ukrvMasterGrid',
		title : '프로그램 목록',
		selModel: 'rowmodel',
		uniOpt:{  
			onLoadSelectFirst: false,
        	expandLastColumn: true,
			useMultipleSorting: true,
    		useGroupSummary: false,
    		useRowNumberer: false,
    		useLiveSearch: true,
			useContextMenu: true	        	
        },
//        flex:2,
		columns : [   {dataIndex : 'GROUP_SORT_SEQ',	width:100,  align : 'center'}
					, {dataIndex : 'PGM_GROUP',			width:200	}						
					, {dataIndex : 'PGM_ID',			width:100,		hidden : true	}				
					, {dataIndex : 'COMP_CODE',			width:100,		hidden : true	}
				],
		listeners: {
			render: function(grid, eOpts){
				var girdNm = grid.getItemId()
				grid.getEl().on('click', function(e, t, eOpt) {
					if(directDetailStore.isDirty()){
						Unilite.messageBox(Msg.sMB154);
						return false;
					}else {
						masterSelectedGrid = girdNm;
						if(grid.getStore().getCount() > 0)  {
							UniAppManager.setToolbarButtons('delete', true);
						}else {
							UniAppManager.setToolbarButtons('delete', false);
						}
					}
				});
			},
			beforeedit  : function( editor, e, eOpts ) {
				if(!e.record.phantom){
			   		return false;
					
				}else{
					if (UniUtils.indexOf(e.field, ['GROUP_SORT_SEQ']))
						return false;
					else
						return true;
				}
			},
			selectionchange:function( model1, selected, eOpts ){
				if(selected.length > 0) {
					var record = selected[0];
					directDetailStore.loadData({})
					directDetailStore.loadStoreRecords(record);
				}
			},
			returnData: function(record)   {
				if(Ext.isEmpty(record)) {
					record = this.getSelectedRecord();
				}
			}
		}       
	});
		
	var detailGrid =  Unilite.createGrid('bsa610ukrvDetailGrid', {
			flex: 2,
			region: 'east',
			store : directDetailStore,
			itemId:'bsa610ukrvDetailGrid',
			title : '사용가능 프로그램',
			uniOpt:{
		    	onLoadSelectFirst: true,
	        	expandLastColumn: true,
				useMultipleSorting: true,
	    		useGroupSummary: false,
	    		useLiveSearch: true,
				useContextMenu: true,
	    		useRowNumberer: false        	
	        },     
			columns : [   {dataIndex : 'PGM_SORT_SEQ',			width:100,  align : 'center'}
						, {dataIndex : 'PGM_ID',			width:130	,
						   editor:Unilite.popup("PROGRAM_G",{
								textFieldName	: 'PGM_ID',
								listeners:{
									onSelected:function(records, type){
										if(records && records.length > 0){
											detailGrid.uniOpt.currentRecord.set("PGM_ID", records[0]["PGM_ID"]);
											detailGrid.uniOpt.currentRecord.set("PGM_NAME", records[0]["PGM_NAME"]);
											detailGrid.uniOpt.currentRecord.set("LOCATION", records[0]["LOCATION"]);
											detailGrid.uniOpt.currentRecord.set("TYPE", records[0]["TYPE"]);
										}
									},
									onClear:function(type) {
										detailGrid.uniOpt.currentRecord.set("PGM_ID", "");
										detailGrid.uniOpt.currentRecord.set("PGM_NAME", "");
										detailGrid.uniOpt.currentRecord.set("LOCATION", "");
										detailGrid.uniOpt.currentRecord.set("TYPE", "");										
									}
								}
						   })
						  }
						, {dataIndex : 'PGM_NAME',			width:200	,
						   editor:Unilite.popup("PROGRAM_G",{
								textFieldName	: 'PGM_NAME',
								listeners:{
									onSelected:function(records, type){
										if(records && records.length > 0){
											detailGrid.uniOpt.currentRecord.set("PGM_ID", records[0]["PGM_ID"]);
											detailGrid.uniOpt.currentRecord.set("PGM_NAME", records[0]["PGM_NAME"]);
											detailGrid.uniOpt.currentRecord.set("LOCATION", records[0]["LOCATION"]);
											detailGrid.uniOpt.currentRecord.set("TYPE", records[0]["TYPE"]);											
										}
									},
									onClear:function(type) {
										detailGrid.uniOpt.currentRecord.set("PGM_ID", "");
										detailGrid.uniOpt.currentRecord.set("PGM_NAME", "");
										detailGrid.uniOpt.currentRecord.set("LOCATION", "");
										detailGrid.uniOpt.currentRecord.set("TYPE", "");										
									}
								}
						   })}				
						, {dataIndex : 'USE_YN',			width:80	    ,align : 'center'}
						, {dataIndex : 'GROUP_SORT_SEQ',	width:100,		hidden : true	}
						, {dataIndex : 'PGM_SORT_SEQ',		width:100,		hidden : true	}
						, {dataIndex : 'COMP_CODE',			width:100,		hidden : true	}
					],
			listeners:{
			render: function(grid, eOpts){
				var girdNm = grid.getItemId()
				grid.getEl().on('click', function(e, t, eOpt) {
					if(directMasterStore.isDirty()){
						//grid.suspendEvents();
						Unilite.messageBox(Msg.sMB154);
						return false;
					}else {
						masterSelectedGrid = girdNm;
						if(grid.getStore().getCount() > 0)  {
							UniAppManager.setToolbarButtons('delete', true);
						}else {
							UniAppManager.setToolbarButtons('delete', false);
						}
					}
				});

			},				
				beforeedit  : function( editor, e, eOpts ) {
					if(!e.record.phantom){
						if (UniUtils.indexOf(e.field, ['USE_YN']))
							return true;
						else
							return false;
						
					}else{
						if (UniUtils.indexOf(e.field, ['PGM_SORT_SEQ']))
							return false;
						else
							return true;
					}
				} 
			}					
		});

	
	Unilite.Main({
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[{
				region: 'center',
				layout: {type: 'vbox', align: 'stretch'},
				border: false,
				flex: 2,
				items: [masterGrid, detailGrid]
			}]	
		}],
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['reset','newData'],true);
			directMasterStore.loadStoreRecords();
		},
		onQueryButtonDown:function() {
			directMasterStore.loadStoreRecords();			

		},
		onSaveDataButtonDown: function () {										
			 directMasterStore.saveStore();
			 directDetailStore.saveStore();	
		},
		onResetButtonDown:function() {
			masterGrid.reset();	
			directMasterStore.clearData();
			detailGrid.reset();	
			directDetailStore.clearData();
			this.fnInitBinding();
		},
		onNewDataButtonDown : function()	{
			
			if(masterSelectedGrid == 'bsa610ukrvDetailGrid'){	
				var record = masterGrid.getSelectedRecord();
				var compCode    	=	UserInfo.compCode; 
				var userId		 	=	UserInfo.userID;
				var groupSortSeq 	=	record.get('GROUP_SORT_SEQ');
			    var seq = directDetailStore.max('PGM_SORT_SEQ');
			    if(!seq) seq = 1;
			    else  seq += 1;				
				var pgmGroup		=	record.get('PGM_GROUP');
				var pgmId			=	'';      
				
				var r = {            
					GROUP_SORT_SEQ	: groupSortSeq,
					PGM_GROUP 		: pgmGroup,
					PGM_ID		    : pgmId,
					PGM_NAME		: '',
					PGM_SORT_SEQ	: seq,
					LOCATION	    : '',
					TYPE	        : '',
					USE_YN	        : 'Y',
					COMP_CODE       : compCode
				};
				detailGrid.createRow(r);
				UniAppManager.setToolbarButtons('save', true);
			} else if(masterSelectedGrid == 'bsa610ukrvMasterGrid'){
					var compCode    	=	UserInfo.compCode; 
					var userId		 	=	UserInfo.userID;
					var seq = directMasterStore.max('GROUP_SORT_SEQ');
				    if(!seq) seq = 1;
				    else  seq += 1;
					var pgmGroup		=	'';  
					var pgmId			=	'$';  
					
					var r = {            
						GROUP_SORT_SEQ	: seq,
						PGM_GROUP 		: pgmGroup,
						PGM_ID 		    : pgmId,
						COMP_CODE       : compCode
					};        
			        masterGrid.createRow(r);
			        UniAppManager.setToolbarButtons('save', true);
				}			
		},
		 onDeleteDataButtonDown: function() {
			if(masterSelectedGrid == 'bsa610ukrvMasterGrid'){
				var Grid1 = UniAppManager.app.down('#bsa610ukrvDetailGrid');
				var selRow = masterGrid.getSelectedRecord();
				var selIndex = masterGrid.getSelectedRowIndex();

				if(selRow.phantom !== true && directDetailStore.getCount() > 0 )
				{
					Unilite.messageBox('<t:message code="system.message.base.message035" default="하위 프로그램 리스트가 존재합니다.먼저 하위 프로그램 리스트를 삭제후 프로그램 그룹을 삭제하십시오."/>');

				}else if(confirm('<t:message code="system.message.base.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
					masterGrid.deleteSelectedRow(selIndex);
					masterGrid.getStore().onStoreActionEnable();
				}
				UniAppManager.setToolbarButtons('save', true);
			}
			
			else if(masterSelectedGrid == 'bsa610ukrvDetailGrid'){
				var selIndex = detailGrid.getSelectedRowIndex();

				if(confirm('<t:message code="system.message.base.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
					detailGrid.deleteSelectedRow(selIndex);
					detailGrid.getStore().onStoreActionEnable();
				
				UniAppManager.setToolbarButtons('save', true);
				}
			}
		},
		onSaveAndQueryButtonDown : function()	{
			this.onSaveDataButtonDown();
			//this.onQueryButtonDown();
		}		
	});		

};	// appMain
</script>