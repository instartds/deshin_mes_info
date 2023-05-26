<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="aep070ukr"  >
	<t:ExtComboStore comboType="BOR120" pgmId="aep070ukr"/> 						<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A020" />		 <!--사용여부-->
	<t:ExtComboStore comboType="AU" comboCode="A022" />		 <!--증빙유형-->
	<t:ExtComboStore comboType="AU" comboCode="J671" />		 <!--전표유형-->
</t:appConfig>
<script type="text/javascript" >

function appMain() {	
	
	//WBS 그룹
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			create	: 'aep070ukrService.insertList',				
			read	: 'aep070ukrService.selectList',
			update	: 'aep070ukrService.updateList',
			destroy	: 'aep070ukrService.deleteList',
			syncAll	: 'aep070ukrService.saveAll'
		}
	});
	
	//그룹-WBS 매핑
	var directProxy1 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			create	: 'aep070ukrService.insertList1',				
			read	: 'aep070ukrService.selectList1',
			update	: 'aep070ukrService.updateList1',
			destroy	: 'aep070ukrService.deleteList1',
			syncAll	: 'aep070ukrService.saveAll1'
		}
	});
	
	//그룹-계정 매핑
	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			create	: 'aep070ukrService.insertList2',				
			read	: 'aep070ukrService.selectList2',
			update	: 'aep070ukrService.updateList2',
			destroy	: 'aep070ukrService.deleteList2',
			syncAll	: 'aep070ukrService.saveAll2'
		}
	});
	
	
   /** Model 정의 
    * @type 
    */
	//WBS 그룹
	Unilite.defineModel('Aep070ukrModel', {
		fields: [
			{name: 'GROUP'			, text: '그룹'		, type: 'string'	, allowBlank: false},
			{name: 'GROUP_NAME'		, text: '그룹명'		, type: 'string'	, allowBlank: false},
			{name: 'USE_YN'			, text: '사용여부'		, type: 'string'	, allowBlank: false		, comboType:'AU'	, comboCode:'A020'},
			{name: 'CHOOSE_YN'		, text: '기본선택'		, type: 'string'	, allowBlank: false}
		]
	});
	
	//그룹-WBS 매핑
	Unilite.defineModel('Aep070ukrModel1', {
		fields: [
			{name: 'GROUP'			, text: '그룹'		, type: 'string', allowBlank: false},
			{name: 'WBS'			, text: 'WBS'		, type: 'string', allowBlank: false},
			{name: 'WBS_NAME'		, text: 'WBS명'		, type: 'string', allowBlank: false}
		]
	});
	
	//그룹-계정 매핑
	Unilite.defineModel('Aep070ukrModel2', {
		fields: [
			{name: 'GROUP'			, text: '그룹'		, type: 'string', allowBlank: false},
			{name: 'ACCNT'			, text: '계정'		, type: 'string', allowBlank: false},
			{name: 'ACCNT_NAME'		, text: '계정명'		, type: 'string', allowBlank: false}
		]
	});
   
	
   /**
    * Store 정의(Service 정의)
    * @type 
    */               
	//WBS 그룹
	var masterStore = Unilite.createStore('aep070ukrMasterStore',{
		model	: 'Aep070ukrModel',
		uniOpt	: {
			isMaster	: false,        // 상위 버튼 연결 
			editable	: true,         // 수정 모드 사용 
			deletable	: true,         // 삭제 가능 여부 
			useNavi		: false         // prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy	: directProxy,
		loadStoreRecords : function()	{
//			var param= Ext.getCmp('searchForm').getValues();			
//			console.log( param );
			this.load({
//				params : param
			});
		},
		saveStore : function()	{				
			var inValidRecs = this.getInvalidRecords();				
				if(inValidRecs.length == 0 )	{
					config = {
//					params: [paramMaster],
					success: function(batch, option) {
					} 
				};
				this.syncAllDirect(config);				
			} else {    				
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners:{
			load: function(store, records, successful, eOpts) {
			}				
		},
		
	    _onStoreUpdate: function (store, eOpt) {	    	
	    	console.log("Store data updated save btn enabled !");
	    	this.setToolbarButtons('sub_save', true);    	
	    }, // onStoreUpdate

	    _onStoreLoad: function ( store, records, successful, eOpts ) {	    	
	    	console.log("onStoreLoad");
	    	if (records) {
		    	this.setToolbarButtons('sub_save', false);
	    	}	    	
	    },
	    
		_onStoreDataChanged: function( store, eOpts )	{	    	
       		console.log("_onStoreDataChanged store.count() : ", store.count());
       		if(store.count() == 0)	{
       			this.setToolbarButtons(['sub_delete'], false);
	    		Ext.apply(this.uniOpt.state, {'btn':{'sub_delete':false}});
       		}else {
       			if(this.uniOpt.deletable)	{
	       			this.setToolbarButtons(['sub_delete'], true);
		    		Ext.apply(this.uniOpt.state, {'btn':{'sub_delete':true}});
       			}
       		}
       		
       		if(store.isDirty())	{
       			this.setToolbarButtons(['sub_save'], true);
       		}else {
       			this.setToolbarButtons(['sub_save'], false);
       		}	    	
    	},
    	
    	setToolbarButtons: function( btnName, state)	{
    		var toolbar = masterGrid.getDockedItems('toolbar[dock="top"]');
			var obj = toolbar[0].getComponent(btnName);
			if(obj) {
				(state) ? obj.enable():obj.disable();
			}
    	}		
	});
	
	//그룹-WBS 매핑
	var masterStore1 = Unilite.createStore('aep070ukrMasterStore1',{
		model	: 'Aep070ukrModel1',
		uniOpt	: {
			isMaster	: false,        // 상위 버튼 연결 
			editable	: true,         // 수정 모드 사용 
			deletable	: true,         // 삭제 가능 여부 
			useNavi		: false         // prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy	: directProxy1,
		loadStoreRecords : function(record)	{
			var param = {
				'GROUP'		: record.data.GROUP
			}
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore : function()	{				
			var inValidRecs = this.getInvalidRecords();				
				if(inValidRecs.length == 0 )	{
					config = {
//					params: [paramMaster],
					success: function(batch, option) {
					} 
				};
				this.syncAllDirect(config);				
			} else {    				
				masterGrid1.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners:{
			load: function(store, records, successful, eOpts) {
			}				
		},
		
	    _onStoreUpdate: function (store, eOpt) {	    	
	    	console.log("Store data updated save btn enabled !");
	    	this.setToolbarButtons('sub_save1', true);    	
	    }, // onStoreUpdate

	    _onStoreLoad: function ( store, records, successful, eOpts ) {	    	
	    	console.log("onStoreLoad");
	    	if (records) {
		    	this.setToolbarButtons('sub_save1', false);
	    	}	    	
	    },
	    
		_onStoreDataChanged: function( store, eOpts )	{	    	
       		console.log("_onStoreDataChanged store.count() : ", store.count());
       		if(store.count() == 0)	{
       			this.setToolbarButtons(['sub_delete1'], false);
	    		Ext.apply(this.uniOpt.state, {'btn':{'sub_delete1':false}});
       		}else {
       			if(this.uniOpt.deletable)	{
	       			this.setToolbarButtons(['sub_delete1'], true);
		    		Ext.apply(this.uniOpt.state, {'btn':{'sub_delete1':true}});
       			}
       		}
       		
       		if(store.isDirty())	{
       			this.setToolbarButtons(['sub_save1'], true);
       		}else {
       			this.setToolbarButtons(['sub_save1'], false);
       		}	    	
    	},
    	
    	setToolbarButtons: function( btnName, state)	{
    		var toolbar = masterGrid1.getDockedItems('toolbar[dock="top"]');
			var obj = toolbar[0].getComponent(btnName);
			if(obj) {
				(state) ? obj.enable():obj.disable();
			}
    	}
	});

	//그룹-계정 매핑
	var masterStore2 = Unilite.createStore('aep070ukrMasterStore2',{
		model	: 'Aep070ukrModel2',
		uniOpt	: {
			isMaster	: false,        // 상위 버튼 연결 
			editable	: true,         // 수정 모드 사용 
			deletable	: true,         // 삭제 가능 여부 
			useNavi		: false         // prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy	: directProxy2,
		loadStoreRecords : function(record)	{
			var param = {
				'GROUP'		: record.data.GROUP
			}
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore : function()	{				
			var inValidRecs = this.getInvalidRecords();				
				if(inValidRecs.length == 0 )	{
					config = {
//					params: [paramMaster],
					success: function(batch, option) {
					} 
				};
				this.syncAllDirect(config);				
			} else {    				
				masterGrid2.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners:{
			load: function(store, records, successful, eOpts) {
			}				
		},
		
	    _onStoreUpdate: function (store, eOpt) {	    	
	    	console.log("Store data updated save btn enabled !");
	    	this.setToolbarButtons('sub_save2', true);    	
	    }, // onStoreUpdate

	    _onStoreLoad: function ( store, records, successful, eOpts ) {	    	
	    	console.log("onStoreLoad");
	    	if (records) {
		    	this.setToolbarButtons('sub_save2', false);
	    	}	    	
	    },
	    
		_onStoreDataChanged: function( store, eOpts )	{	    	
       		console.log("_onStoreDataChanged store.count() : ", store.count());
       		if(store.count() == 0)	{
       			this.setToolbarButtons(['sub_delete2'], false);
	    		Ext.apply(this.uniOpt.state, {'btn':{'sub_delete2':false}});
       		}else {
       			if(this.uniOpt.deletable)	{
	       			this.setToolbarButtons(['sub_delete2'], true);
		    		Ext.apply(this.uniOpt.state, {'btn':{'sub_delete2':true}});
       			}
       		}
       		
       		if(store.isDirty())	{
       			this.setToolbarButtons(['sub_save2'], true);
       		}else {
       			this.setToolbarButtons(['sub_save2'], false);
       		}	    	
    	},
    	
    	setToolbarButtons: function( btnName, state)	{
    		var toolbar = masterGrid2.getDockedItems('toolbar[dock="top"]');
			var obj = toolbar[0].getComponent(btnName);
			if(obj) {
				(state) ? obj.enable():obj.disable();
			}
    	}			
	});

	
   /** Grid 정의(Grid Panel)
     * @type 
     */
	//WBS 그룹
    var masterGrid = Unilite.createGrid('aep070ukrGrid', {    	
    	store	: masterStore,
    	border	: true,
    	height	: 150,
        region	: 'center',
    	title	: 'WBS 그룹',
    	excelTitle: 'WBS 그룹',
    	sortableColumns : false,
    	uniOpt:{
			 expandLastColumn	: true,
			 useRowNumberer		: true,
			 useMultipleSorting	: false
//			 enterKeyCreateRow	: true						//마스터 그리드 추가기능 삭제
    	},
    	dockedItems	: [{    		
	        xtype	: 'toolbar',
	        dock	: 'top',
	        items	: [{
                xtype	: 'uniBaseButton',
				text	: '추가',
				tooltip	: '추가',
				iconCls	: 'icon-new',
				width	: 26,
				height	: 26,
		 		itemId	: 'sub_newData',
				handler	: function() { 
	            	var r = {
	            	 	USE_YN		: 'Y'
			        };
					masterGrid.createRow(r);
				}
			},{
				xtype	: 'uniBaseButton',
				text	: '삭제',
				tooltip	: '삭제',
				iconCls	: 'icon-delete',
				disabled: true,
				width	: 26, 
				height	: 26,
		 		itemId	: 'sub_delete',
				handler	: function() { 
					var selRow = masterGrid.getSelectedRecord();
					if(selRow.phantom === true)	{
						masterGrid.deleteSelectedRow();
						
					}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
						masterGrid.deleteSelectedRow();						
					}	
				}				
			},{
                xtype	: 'uniBaseButton',
				text	: '저장', 
				tooltip	: '저장', 
				iconCls	: 'icon-save',
				disabled: true,
				width	: 26,
				height	: 26,
		 		itemId	: 'sub_save',
				handler : function() {
					var inValidRecs = masterStore2.getInvalidRecords();       	
					if(inValidRecs.length == 0 )	{
						var saveTask =  Ext.create('Ext.util.DelayedTask', function(){
	                  		masterStore.saveStore();
						});
						saveTask.delay(500);
					} else {
						masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
					}                  
                }
			}]
	    }],

		columns:  [  
        	{ dataIndex: 'GROUP'		 		, width: 120},
        	{ dataIndex: 'GROUP_NAME'	 		, width: 160},
	  		{ dataIndex: 'USE_YN'		 		, width: 160},
	  		{ dataIndex: 'CHOOSE_YN'		 	, width: 120}
		],
		
		listeners: {          	
			beforeedit  : function( editor, e, eOpts ) {
			},
			
        	select: function(grid, record, index, eOpts ){	
        		if (record.data.GROUP) {
	        		masterStore1.loadStoreRecords(record);
	        		masterStore2.loadStoreRecords(record);
        		}
        	}
		}          
	});
	
	//그룹-WBS 매핑
    var masterGrid1 = Unilite.createGrid('aep070ukrGrid1', {    	
    	store	: masterStore1,
    	border	: true,
    	height	: 150,
        region	: 'south',
    	title	: '그룹-WBS 매핑',
    	excelTitle: '그룹-WBS 매핑',
    	sortableColumns : false,
    	uniOpt:{
			 expandLastColumn	: true,
			 useRowNumberer		: true,
			 useMultipleSorting	: false
//			 enterKeyCreateRow	: true						//마스터 그리드 추가기능 삭제
    	},
    	dockedItems	: [{    		
	        xtype	: 'toolbar',
	        dock	: 'top',
	        items	: [{
                xtype	: 'uniBaseButton',
				text	: '추가',
				tooltip	: '추가',
				iconCls	: 'icon-new',
				width	: 26,
				height	: 26,
		 		itemId	: 'sub_newData1',
				handler	: function() { 
					var record = masterGrid.getSelectedRecord();

					if(record.data.GROUP) {
						var compCode	= UserInfo.compCode;  
						var group		= record.get('GROUP');
						
		            	var r = {
		            	 	GROUP		: group
				        };
						masterGrid1.createRow(r);
					} else {
						alert ('그룹을 먼저 선택해 주십시오');
						return false;
					}
				}
			},{
				xtype	: 'uniBaseButton',
				text	: '삭제',
				tooltip	: '삭제',
				iconCls	: 'icon-delete',
				disabled: true,
				width	: 26, 
				height	: 26,
		 		itemId	: 'sub_delete1',
				handler	: function() { 
					var selRow = masterGrid1.getSelectedRecord();
					if(selRow.phantom === true)	{
						masterGrid1.deleteSelectedRow();
					}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
						masterGrid1.deleteSelectedRow();						
					}	
				}				
			},{
                xtype	: 'uniBaseButton',
				text	: '저장', 
				tooltip	: '저장', 
				iconCls	: 'icon-save',
				disabled: true,
				width	: 26,
				height	: 26,
		 		itemId	: 'sub_save1',
				handler : function() {
					var inValidRecs = masterStore2.getInvalidRecords();       	
					if(inValidRecs.length == 0 )	{
						var saveTask =  Ext.create('Ext.util.DelayedTask', function(){
	                  		masterStore1.saveStore();
						});
						saveTask.delay(500);
					} else {
						masterGrid1.uniSelectInvalidColumnAndAlert(inValidRecs);
					}                  
                }
			}]
	    }],

		columns:  [  
        	{ dataIndex: 'GROUP'		 		, width: 120},
        	{ dataIndex: 'WBS'	 				, width: 160},
	  		{ dataIndex: 'WBS_NAME'		 		, width: 160}
		],
		
		listeners: {          	
			beforeedit  : function( editor, e, eOpts ) {
			},
			
          	selectionchangerecord:function(selected)	{
				masterStore2.loadStoreRecords(selected.get('GROUP'));

          	}
		}          
	});
	
	//그룹-WBS 매핑
    var masterGrid2 = Unilite.createGrid('aep070ukrGrid2', {    	
    	store	: masterStore2,
    	border	: true,
    	height	: 150,
        region	: 'east',
    	title	: '그룹-계정 매핑',
    	excelTitle: '그룹-계정 매핑',
    	sortableColumns : false,
    	uniOpt:{
			 expandLastColumn	: true,
			 useRowNumberer		: true,
			 useMultipleSorting	: false
//			 enterKeyCreateRow	: true						//마스터 그리드 추가기능 삭제
    	},
    	dockedItems	: [{    		
	        xtype	: 'toolbar',
	        dock	: 'top',
	        items	: [{
                xtype	: 'uniBaseButton',
				text	: '추가',
				tooltip	: '추가',
				iconCls	: 'icon-new',
				width	: 26,
				height	: 26,
		 		itemId	: 'sub_newData2',
				handler	: function() { 
					var record = masterGrid.getSelectedRecord();
					
					if(record.data.GROUP) {
						var compCode	= UserInfo.compCode;  
						var group		= record.get('GROUP');
						
		            	var r = {
		            	 	GROUP		: group
				        };
						masterGrid2.createRow(r);
					} else {
						alert ('그룹을 먼저 선택해 주십시오');
						return false;
					}
				}
			},{
				xtype	: 'uniBaseButton',
				text	: '삭제',
				tooltip	: '삭제',
				iconCls	: 'icon-delete',
				disabled: true,
				width	: 26, 
				height	: 26,
		 		itemId	: 'sub_delete2',
				handler	: function() { 
					var selRow = masterGrid2.getSelectedRecord();
					if(selRow.phantom === true)	{
						masterGrid2.deleteSelectedRow();
						
					}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
						masterGrid2.deleteSelectedRow();						
					}	
				}				
			},{
                xtype	: 'uniBaseButton',
				text	: '저장', 
				tooltip	: '저장', 
				iconCls	: 'icon-save',
				disabled: true,
				width	: 26,
				height	: 26,
		 		itemId	: 'sub_save2',
				handler : function() {
					var inValidRecs = masterStore2.getInvalidRecords();       	
					if(inValidRecs.length == 0 )	{
						var saveTask =  Ext.create('Ext.util.DelayedTask', function(){
	                  		masterStore2.saveStore();
						});
						saveTask.delay(500);
					} else {
						masterGrid2.uniSelectInvalidColumnAndAlert(inValidRecs);
					}                  
                }
			}]
	    }],

		columns:  [  
        	{ dataIndex: 'GROUP'		 		, width: 120},
        	{ dataIndex: 'ACCNT' 				, width: 160},
	  		{ dataIndex: 'ACCNT_NAME'	 		, width: 160}
		],
		
		listeners: {          	
			beforeedit  : function( editor, e, eOpts ) {
			}
		}          
	});
	
   
   
	Unilite.Main( {
		id	 		: 'aep070ukrApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [{
					region:'center',
					xtype:'container',
					flex:1.2,
					layout:{type:'vbox', align:'stretch'},
					items:[
						masterGrid, masterGrid1
					]
				},{
					region:'east',
					xtype:'container',
					flex:1,
					layout:{type:'vbox', align:'stretch'},
					items:[
						masterGrid2
					]
				}
				
			]
		}], 
		
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['reset','newData','detail'], false);			
		},

		onQueryButtonDown : function()   {
			masterStore.loadStoreRecords();	
		},
		
		onResetButtonDown: function() {											
			masterGrid.getStore().loadData({});										
			masterGrid1.getStore().loadData({});										
			masterGrid2.getStore().loadData({});										
			masterStore.clearData();										
			masterStore1.clearData();										
			masterStore2.clearData();										
			this.fnInitBinding();										
		},
		
		onSaveDataButtonDown : function() {
			masterStore.saveStore();
		}									
	});
};


</script>