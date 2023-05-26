<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="qba210ukrv" >
  <t:ExtComboStore comboType="BOR120" pgmId="bcm120ukrv"/> <!-- 사업장 -->
  <t:ExtComboStore comboType="AU" comboCode="B020" />	<!-- 품목계정 	-->
  <t:ExtComboStore comboType="AU" comboCode="B131" />	<!-- 예/아니오 	-->
</t:appConfig>
<script type="text/javascript">
  
function appMain() {

	var selectedR;
	var isItemGridUseChange = false;
	
	Unilite.defineModel('qba210ukrvItemModel', {
		fields : [ {name : 'DIV_CODE',		text : '사업장',		type : 'string'}
				  ,{name : 'ITEM_CODE',		text : '품목코드',		type : 'string'}
				  ,{name : 'ITEM_NAME',		text : '품목명',      	type : 'string'}
				  ,{name : 'SPEC',			text : '규격',      	type : 'string'}
				  ,{name : 'USE_YN',		text : '등록여부',     type : 'string', 			comboType:'AU', 			comboCode:'B131'}
		]
		
	});
	
	var directItemStore = Unilite.createStore('qba210ukrvItemStore', {
		model : 'qba210ukrvItemModel',
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
				read : 'qba210ukrvService.selectList'
			} 
		},
		loadStoreRecords : function() {
			var param = Ext.getCmp('qba210ukrvSearchForm').getValues();
			this.load({
				params: param,
				callback : function(records,options,success)    {
                    if(success) { 
                    	if(!Ext.isEmpty(records)){
            	        	UniAppManager.setToolbarButtons(['newData'], true);
            	        } else {
            	        	UniAppManager.setToolbarButtons(['newData'], false);
            	        	testGrid.getStore().loadData({});
            	        }
                    }}
			});
		}
	});

	Unilite.defineModel('qba210ukrvTestModel', {
		fields : [ {name : 'DIV_CODE',			text : '사업장',			type : 'string',		allowBlank:false}
				  ,{name : 'ITEM_CODE',			text : '품목코드',			type : 'string',		allowBlank:false}
				  ,{name : 'TEST_CODE',			text : '검사항목',			type : 'string',		allowBlank:false, 		comboType:'AU', 	comboCode:'Q040'}
				  ,{name : 'REVISION_DATE',		text : '개정일자',			type : 'uniDate',		allowBlank:false}
				  ,{name : 'TEST_METH',			text : '검사방법',			type : 'string'}
				  ,{name : 'TEST_COND',			text : '검사기준',			type : 'string'}
				  ,{name : 'TEST_VALUE',		text : '검사값',			type : 'string'}
				  
				  ,{name : 'TEST_VER',		text : '버전',			type : 'float', 		maxLength: 10, 		decimalPrecision: 2, 	format: '00,000,000.00'}
		]
	});

	var directTestModelProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy', {
		api : {
			read : 'qba210ukrvService.selectTestList',
			update : 'qba210ukrvService.updateDetail',
			create : 'qba210ukrvService.insertDetail',
			destroy : 'qba210ukrvService.deleteDetail',
			syncAll : 'qba210ukrvService.saveAll'
		}
	});

	var directTestStore = Unilite.createStore('qba210ukrvTestStore', {
		model : 'qba210ukrvTestModel',
		autoLoad : false,
		uniOpt : {
			isMaster : true,
			editable : true,
			deletable : true,
			useNavi : false
		},
		proxy : directTestModelProxy,
		loadStoreRecords : function(record) {
			var searchParam = Ext.getCmp('qba210ukrvSearchForm').getValues();
			var param = {'ITEM_CODE'		: record.get('ITEM_CODE')};
			var params = Ext.merge(searchParam, param);
			this.load({
				params: params,
				callback : function(records,options,success)    {
					isItemGridUseChange = false;
					
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
		   	var searchParam = Ext.getCmp('qba210ukrvSearchForm').getValues();
			var param = {	'DIV_CODE' : record.get('DIV_CODE'),
							'ITEM_CODE'	: record.get('ITEM_CODE'),
						 	'REVISION_DATE': searchParam.REVISION_DATE};
			if(inValidRecs.length == 0 ) {
				config = { 
					/* params: [param], */
					success: function(batch, option) {
						UniAppManager.app.fnChangeUse();
						
						var chkRecord = qba210ukrvService.getCntQba210t(param, function(provider, response){
							 var useYn = provider[0].USE_YN;
							 
							 Ext.each(selectedR, function(record, i){
									record.set('USE_YN', useYn);
							 });
						}); 
						directTestStore.loadStoreRecords(record);
				 	} 
				}
				this.syncAllDirect(config);
			}else {
				testGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
		
	});
	
	var panelSearch = Unilite.createSearchPanel('qba210ukrvSearchForm', {     
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
					fieldLabel: '개정일자',
					name: 'REVISION_DATE',
					xtype: 'uniDatefield',
					value: UniDate.get('today'),
					holdable: 'hold',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('REVISION_DATE', newValue);
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
				fieldLabel: '개정일자',
				name: 'REVISION_DATE',
				xtype: 'uniDatefield',
				value: UniDate.get('today'),
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('REVISION_DATE', newValue);
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
    var itemGrid = Unilite.createGrid('qba210ukrvItemGrid', {
    	store : directItemStore,
    	layout : 'fit',
    	title : '품목리스트',
    	flex: 2,
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
    		{dataIndex : 'ITEM_NAME',		width:300 },
    		{dataIndex : 'SPEC',			width:120 },
    		{dataIndex : 'USE_YN',			width:100 }
    	],
    	listeners: {
    		render: function(grid, eOpts){
    		/* 	var girdNm = grid.getItemId()
    			grid.getEl().on('click', function(e, t, eOpt) {
    				if(directTestStore.isDirty()){
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
				if(directTestStore.isDirty()){
					alert("변경된 데이터가 있습니다.\n저장 후 다시 시도해주세요.")
					return false;
				} 
			}, */
			beforeselect : function ( grid, record, index, eOpts )
			{
				var detailStore = directTestStore;
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
					directTestStore.loadData({});
					directTestStore.loadStoreRecords(record);
				}
		 }
    });

    var testGrid = Unilite.createGrid('qba210ukrvtestGrid', {
		store : directTestStore,
		title : '검사항목리스트',
		flex : 3,
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
    		{dataIndex : 'DIV_CODE',		width:100, 		hidden : true },
    		{dataIndex : 'ITEM_CODE',		width:100, 		hidden : true },
    		{dataIndex : 'TEST_CODE',		width:100 },
    		
    		{dataIndex : 'TEST_METH',		width:180 },
    		{dataIndex : 'TEST_COND',		width:180 },
    		{dataIndex : 'TEST_VALUE',		width:180 },
    		{dataIndex : 'REVISION_DATE',	width:100 },
    		{dataIndex : 'TEST_VER',		width:70 }

    	],
    	listeners: {
			beforeedit: function( editor, e, eOpts ) {
				if(!e.record.phantom) {					
					if (UniUtils.indexOf(e.field, ['DIV_CODE', 'ITEM_CODE','TEST_CODE','REVISION_DATE'])){
						return false;
					}

				}else if(e.record.phantom) {
					if (UniUtils.indexOf(e.field, ['DIV_CODE', 'ITEM_CODE'])){
						return false;
					}
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
				layout: {type: 'hbox', align: 'stretch'},
				border: false,
				flex: 1,
				items: [itemGrid, testGrid]
				//items: [testGrid]
				
			}, panelResult]
		}		
    	, panelSearch
		],
		id : 'qba210ukrvApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			UniAppManager.setToolbarButtons(['reset'], true);
         	// UniAppManager.setToolbarButtons('newData', false);
			this.setDefault();
		},
		onQueryButtonDown:function() {
	        itemGrid.getStore().loadStoreRecords();
	        //testGrid.getStore().loadStoreRecords();
      	},
      	onSaveDataButtonDown: function () {                   
           if(directTestStore.isDirty()) {
        	   directTestStore.saveStore();           
           }
        },
        onResetButtonDown:function() {
			itemGrid.getStore().loadData({});
			testGrid.getStore().loadData({});
			Ext.getCmp('qba210ukrvSearchForm').reset();
        },
        onNewDataButtonDown : function()    {
			 /**
			  * Detail Grid Default 값 설정
			  */
			var divCode = panelResult.getValue('DIV_CODE');
			var revisionDate = panelResult.getValue('REVISION_DATE');
			var record = itemGrid.getSelectedRecords();
			if(!Ext.isEmpty(record)){
				var r = {
					     DIV_CODE		: divCode,
					     ITEM_CODE		: record[0].data['ITEM_CODE'],
					     REVISION_DATE	: revisionDate
					};
				testGrid.createRow(r);	
			}
       },
        onDeleteDataButtonDown: function() {
			var selRow = testGrid.getSelectedRecord();
            if(!Ext.isEmpty(selRow)){
                if(selRow.phantom === true) {
                	testGrid.deleteSelectedRow();
                }else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')){
                	testGrid.deleteSelectedRow();   
                }
            }
        },
        setDefault: function() {
        	panelSearch.setValue('DIV_CODE',UserInfo.divCode);
        	panelSearch.getForm().wasDirty = false;
        	panelSearch.resetDirtyStatus();                                         
            UniAppManager.setToolbarButtons('save', false);
        },
		fnChangeUse: function() {
			/* var iCnt = 0; */
			var itemRecords = directTestStore.data.items;
			var selectedItemRecord = itemGrid.getSelectedRecord();
			if (!isItemGridUseChange && /* !Ext.isEmpty(itemRecords) && */ !Ext.isEmpty(selectedItemRecord)){
				selectedR = selectedItemRecord;	
				/* Ext.each(itemRecords, function(record, i){
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
				} */
			}
			
		}
    });
    
    Unilite.createValidator('qba210ukrvValidator', {
		store: directTestStore,
		grid: testGrid,
		forms: {'formA: ': qba210ukrvSearchForm},
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type': type, 'fieldName': fieldName, 'newValue': newValue, 'oldValue': oldValue, 'record': record});
			var rv = true;
			
			return rv;
		}
		});
};


</script>