<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="qba200ukrv" >
  <t:ExtComboStore comboType="BOR120" pgmId="bcm120ukrv"/> <!-- 사업장 -->
  <t:ExtComboStore comboType="AU" comboCode="B020" />	<!-- 품목계정 	-->
  <t:ExtComboStore comboType="AU" comboCode="B131" />	<!-- 예/아니오 	-->
</t:appConfig>
<script type="text/javascript">
  
function appMain() {
	
	var isItemGridUseChange = false;
	
	Unilite.defineModel('qba200ukrvItemModel', {
		fields : [ {name : 'DIV_CODE',		text : '사업장',		type : 'string'}
				  ,{name : 'ITEM_CODE',		text : '품목코드',		type : 'string'}
				  ,{name : 'ITEM_NAME',		text : '품목명',      	type : 'string'}
				  ,{name : 'SPEC',			text : '규격',      	type : 'string'}
				  ,{name : 'USE_YN',		text : '등록여부',     type : 'string', 			comboType:'AU', 			comboCode:'B131'}
		]
		
	});
	
	var directItemStore = Unilite.createStore('qba200ukrvItemStore', {
		model : 'qba200ukrvItemModel',
		autoLoad : false,
		uniOpt : {
			isMaster : false,
			editable : false,
			deletable: false,
			useNavi  : false 
		},
		proxy : {
			type : 'direct',
			api  : {
				read : 'qba200ukrvService.selectList'
			} 
		},
		loadStoreRecords : function() {
			var param = Ext.getCmp('qba200ukrvSearchForm').getValues();
			this.load({
				params: param,
				callback : function(records,options,success)    {
                    if(success) { }}
			});
		}
	});

	Unilite.defineModel('qba200ukrvEquipModel', {
		fields : [ {name : 'DIV_CODE',		text : '사업장',			type : 'string'}
				  ,{name : 'EQU_CODE',		text : '장비코드',			type : 'string'}
				  ,{name : 'EQU_NAME',		text : '장비명',			type : 'string'}
				  ,{name : 'EQU_SPEC',		text : '규격',			type : 'string'}
				  ,{name : 'USE_YN',		text : '사용유무',			type : 'string'}
		]
	});

	var directEquipModelProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy', {
		api : {
			read : 'qba200ukrvService.selectEquipList',
			update : 'qba200ukrvService.saveAll',
			create : 'qba200ukrvService.saveAll',
			destroy : 'qba200ukrvService.saveAll',
			syncAll : 'qba200ukrvService.saveAll',
		}
	});

	var directEquipStore = Unilite.createStore('qba200ukrvEquipStore', {
		model : 'qba200ukrvEquipModel',
		autoLoad : false,
		uniOpt : {
			isMaster : true,
			editable : false,
			deletable : false,
			useNavi : false
		},
		proxy : directEquipModelProxy,
		loadStoreRecords : function(record) {
			var searchParam = Ext.getCmp('qba200ukrvSearchForm').getValues();
			var param = {'ITEM_CODE'		: record.get('ITEM_CODE')};
			var params = Ext.merge(searchParam, param);
			this.load({
				params: params,
				callback : function(records,options,success)    {
					isItemGridUseChange = false;
					
                    if(success && records[0] != null) { 
                    	
                    	var searchRecords = directEquipStore.data.items;
    					data = new Object();
    					data.records = [];
    					Ext.each(searchRecords, function(record, i){
    						if(record.get('USE_YN') == 'Y') {
    							data.records.push(record);
    						}
    					});
    					equipGrid.getSelectionModel().select(data.records);
    					equipGrid.store.sort({
    						property : 'USE_YN',
    						direction : 'DESC'
    					})
                    }
				}
			});
		},
		listneers : {
			datachanged : function( store, eOpts ) {
				if( directMasterStore1.isDirty() || directMasterStore3.isDirty() || store.isDirty()) {
					UniAppManager.setToolbarButtons('save', true);
				}else {
					UniAppManager.setToolbarButtons('save', false);
				}
			}
		},
		saveStore : function() {
			var inValidRecs = this.getInvalidRecords();
		   	var record = itemGrid.getSelectedRecord();
		   	var param = {'ITEM_CODE'		: record.get('ITEM_CODE')};
			if(inValidRecs.length == 0 ) {
				config = { 
					params: [param],
					success: function(batch, option) {
						UniAppManager.app.fnChangeUse();
				 	} 
				}
				this.syncAllDirect(config);
			}else {
				equipGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
		
	});
	
	var panelSearch = Unilite.createSearchPanel('qba200ukrvSearchForm', {     
        title: '검색조건',
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
        items: [{
	    	title: '기본정보',
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
           	items : [{
					fieldLabel: '사업장',
					name:'DIV_CODE',
					xtype: 'uniCombobox',
					comboType:'BOR120',
					value: '01',
					allowBlank:false,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('DIV_CODE', newValue);
						}
						,applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
				},
				Unilite.popup('DIV_PUMOK',{
		        	fieldLabel: '품목',
		        	valueFieldName: 'ITEM_CODE',
					textFieldName: 'ITEM_NAME',
		        	listeners: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('ITEM_CODE', panelSearch.getValue('ITEM_CODE'));
								panelResult.setValue('ITEM_NAME', panelSearch.getValue('ITEM_NAME'));
							},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('ITEM_CODE', '');
							panelResult.setValue('ITEM_NAME', '');
						},
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
		   		}),{
					fieldLabel: '품목계정',
					name:'ITEM_ACCOUNT',
					xtype: 'uniCombobox',
					comboType:'AU',
					comboCode:'B020',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('ITEM_ACCOUNT', newValue);
						}
					}
				},{
				    xtype: 'radiogroup',
				    fieldLabel: '등록여부',
				    items : [{
				    	boxLabel: '전체',
				    	name: 'CHK_RDO',
				    	inputValue: 'ALL',
				    	width:80,
				    	checked: true
				    }, {
				    	boxLabel: '미등록',
				    	name: 'CHK_RDO' ,
				    	inputValue: 'N',
				    	width:80
				    }, {
				    	boxLabel: '등록',
				    	name: 'CHK_RDO' ,
				    	inputValue: 'Y',
				    	width:80
				    }],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.getField('CHK_RDO').setValue(newValue.CHK_RDO);
						}
					}
				}
			]
		}]
    });
	
	 
    var panelResult = Unilite.createSearchForm('resultForm', {
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
				fieldLabel: '사업장',
				name:'DIV_CODE',
				xtype: 'uniCombobox',
				comboType:'BOR120',
				value: '01',
				allowBlank:false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('DIV_CODE', newValue);
					}
					,applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}
			},
			Unilite.popup('DIV_PUMOK',{
	        	fieldLabel: '품목',
	        	valueFieldName: 'ITEM_CODE',
				textFieldName: 'ITEM_NAME',
	        	listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('ITEM_CODE', panelResult.getValue('ITEM_CODE'));
							panelSearch.setValue('ITEM_NAME', panelResult.getValue('ITEM_NAME'));
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('ITEM_CODE', '');
						panelSearch.setValue('ITEM_NAME', '');
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}
		   	}),{
				fieldLabel: '품목계정',
				name:'ITEM_ACCOUNT',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'B020',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('ITEM_ACCOUNT', newValue);
					}
				}
			},{
			    xtype: 'radiogroup',
			    fieldLabel: '등록여부',
			    items : [{
			    	boxLabel: '전체',
			    	name: 'CHK_RDO',
			    	inputValue: 'ALL',
			    	width:80,
			    	checked: true
			    }, {
			    	boxLabel: '미등록',
			    	name: 'CHK_RDO' ,
			    	inputValue: 'N',
			    	width:80
			    }, {
			    	boxLabel: '등록',
			    	name: 'CHK_RDO' ,
			    	inputValue: 'Y',
			    	width:80
			    }],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.getField('CHK_RDO').setValue(newValue.CHK_RDO);
					}
				}
			}
		]
	});
    var itemGrid = Unilite.createGrid('qba200ukrvItemGrid', {
    	store : directItemStore,
    	layout : 'fit',
    	title : '품목리스트',
    	uniOpt:{
			useGroupSummary: false,
			useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: false,
			copiedRow : true,
			filter: {
				useFilter: false,
				autoCreate: false
			}
		},
		features: [{
            id: 'detailGridSubTotal',
            ftype: 'uniGroupingsummary',
            showSummaryRow: false
        },{
            id: 'detailGridTotal',
            ftype: 'uniSummary',
            showSummaryRow: false
        }],
		selModel:'rowmodel',
    	columns : [
    		{dataIndex : 'DIV_CODE',		width:200, 		hidden : true },
    		{dataIndex : 'ITEM_CODE',		width:100 },
    		{dataIndex : 'ITEM_NAME',		width:350 },
    		{dataIndex : 'SPEC',			width:120 },
    		{dataIndex : 'USE_YN',			width:100 }
    	],
    	listeners: {
    		render: function(grid, eOpts){
    		/* 	var girdNm = grid.getItemId()
    			grid.getEl().on('click', function(e, t, eOpt) {
    				if(directEquipStore.isDirty()){
    					alert(Msg.sMB154);
    					return false;
    				}else {
    					masterSelectedGrid = girdNm;
    				}
    			}); */
    		},
			/* render: function(grid, eOpts){
				var girdNm = grid.getItemId()
				grid.getEl().on('click', function(e, t, eOpt) {
					if(directMasterStore2.isDirty() ||  directMasterStore3.isDirty()){
						alert(Msg.sMB154);
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
					if (UniUtils.indexOf(e.field, ['LAB_NO','REQST_ID'])){
						return true;
					}else{
				   		return false;
					}
				}
				if (UniUtils.indexOf(e.field, ['COMP_CODE','DIV_CODE','CHILD_ITEM_CODE','SPEC']))
					return false;
				else
					return true;
			}, */
    		/* beforeselect: function(grid, record, index, eOpts){
				// selectionChk = 'Y';
				if(directEquipStore.isDirty()){
					alert("변경된 데이터가 있습니다.\n저장 후 다시 시도해주세요.")
					return false;
				} 
			}, */
			beforeselect : function ( grid, record, index, eOpts )
			{
				var detailStore = directEquipStore;
				if(detailStore.isDirty())	{
					if(confirm(Msg.sMB017 + "\n" + Msg.sMB061))	{
						var inValidRecs = detailStore.getInvalidRecords();
						if(inValidRecs.length > 0 )	{
							alert(Msg.sMB083);
							return false;
						}else {
							detailStore.saveStore();
							UniAppManager.app.fnChangeUse();
							isItemGridUseChange = true;
						}
					}
				}
			},
			selectionchange : function( model1, selected, eOpts ){
				this.setDetailGrd( selected, eOpts);
			}
		},
		 setDetailGrd : function ( selected, eOpts) {
			 if(selected.length > 0) {
					var record = selected[0];
					directEquipStore.loadData({});
					directEquipStore.loadStoreRecords(record);
				}
		 }
    });

    var equipGrid = Unilite.createGrid('qba200ukrvEquipGrid', {
		store : directEquipStore,
		title : '장비리스트',
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: true, toggleOnClick: false,
            listeners : {
				select: function(grid, selectRecord, index, rowIndex, eOpts ){
					/* var selectedItemGridRecord = itemGrid.getSelectedRecord(); */
					if(Ext.isEmpty(selectRecord)){
                    	selectRecord.set('USE_YN', 'N')
                    }else{
                    	selectRecord.set('USE_YN', 'Y')
                    }

                },
                deselect:  function(grid, selectRecord, index, eOpts ){
                	/* var selectedItemGridRecord = itemGrid.getSelectedRecord(); */
                	selectRecord.set('USE_YN', 'N')
                }
			}
        }),     
		uniOpt:{
			useGroupSummary: false,
			useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: false,
			onLoadSelectFirst : false
		},
		features: [{
            id: 'detailGridSubTotal',
            ftype: 'uniGroupingsummary',
            showSummaryRow: false
        },{
            id: 'detailGridTotal',
            ftype: 'uniSummary',
            showSummaryRow: false
        }],
		columns : [
    		{dataIndex : 'DIV_CODE',		width:200, 		hidden : true },
    		{dataIndex : 'EQU_CODE',		width:100 },
    		{dataIndex : 'EQU_NAME',		width:350 },
    		{dataIndex : 'EQU_SPEC',		width:120 },
    		{dataIndex : 'USE_YN',			width:50,		hidden : true }

    	]
    });
	
    
    
    Unilite.Main({
    	borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[{
				region: 'center',
				layout: {type: 'hbox', align: 'stretch'},
				border: false,
				flex: 1,
				items: [itemGrid, equipGrid]
				//items: [equipGrid]
				
			}, panelResult]
		}		
    	, panelSearch
		],
		id : 'qba200ukrvApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			UniAppManager.setToolbarButtons(['reset'], true);
         	// UniAppManager.setToolbarButtons('newData', false);
			this.setDefault();
		},
		onQueryButtonDown:function() {
	        itemGrid.getStore().loadStoreRecords();
	        //equipGrid.getStore().loadStoreRecords();
      	},
      	onSaveDataButtonDown: function () {                   
           if(directEquipStore.isDirty()) {
        	   directEquipStore.saveStore();           
           }
        },
        onResetButtonDown:function() {
			itemGrid.getStore().loadData({});
			equipGrid.getStore().loadData({});
			Ext.getCmp('qba200ukrvSearchForm').reset();
        },
        setDefault: function() {
        	panelSearch.setValue('DIV_CODE',UserInfo.divCode);
        	panelSearch.getForm().wasDirty = false;
        	panelSearch.resetDirtyStatus();                                         
            UniAppManager.setToolbarButtons('save', false);
        },
		fnChangeUse: function() {
			var iCnt = 0;
			var equipRecords = directEquipStore.data.items;
			var selectedItemRecord = itemGrid.getSelectedRecord();
			if (!isItemGridUseChange && !Ext.isEmpty(equipRecords) && !Ext.isEmpty(selectedItemRecord)){
				
				Ext.each(equipRecords, function(record, i){
					if(record.get('USE_YN') == 'Y') {
						iCnt = iCnt + 1;
						
						return false;
					}
				})
				
				if(iCnt > 0){
					Ext.each(selectedItemRecord, function(record, i){
						selectedItemRecord.set('USE_YN', 'Y')
					})
				}else{
					Ext.each(selectedItemRecord, function(record, i){
						selectedItemRecord.set('USE_YN', 'N')
					})
				}
			}
			
		}
    });
    
    Unilite.createValidator('qba200ukrvValidator', {
		store: directEquipStore,
		grid: equipGrid,
		forms: {'formA: ': qba200ukrvSearchForm},
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type': type, 'fieldName': fieldName, 'newValue': newValue, 'oldValue': oldValue, 'record': record});
			var rv = true;
			
			return rv;
		}
		});
};


</script>