<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="qba300ukrv" >
  <t:ExtComboStore comboType="BOR120" pgmId="bcm120ukrv"/> <!-- 사업장 -->
  <t:ExtComboStore comboType="AU" comboCode="B020" />	<!-- 품목계정 	-->
  <t:ExtComboStore comboType="AU" comboCode="B131" />	<!-- 예/아니오 	-->
  <t:ExtComboStore comboType="AU" comboCode="Q041" />	<!-- 검사항목 	-->
</t:appConfig>
<script type="text/javascript">
  
function appMain() {

	var selectedR;
	var isItemGridUseChange = false;
	
	Unilite.defineModel('qba300ukrvItemModel', {
		fields : [ {name : 'DIV_CODE',		text : '사업장',		type : 'string'}
				  ,{name : 'SPEC',			text : '규격',		type : 'string'}
				  ,{name : 'USE_YN',		text : '등록여부',     type : 'string', 			comboType:'AU', 			comboCode:'B131'}
		]
		
	});
	
	var directItemStore = Unilite.createStore('qba300ukrvItemStore', {
		model : 'qba300ukrvItemModel',
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
				read : 'qba300ukrvService.selectList'
			} 
		},
		loadStoreRecords : function() {
			var param = Ext.getCmp('qba300ukrvSearchForm').getValues();
			this.load({
				params: param,
				callback : function(records,options,success)    {
                    if(success) {
                    	if(!Ext.isEmpty(records)){
            	        	UniAppManager.setToolbarButtons(['newData'], true);
            	        } else {
            	        	UniAppManager.setToolbarButtons(['newData'], false);
            	        	qbaGrid.getStore().loadData({});
            	        }
                    }}
			});
		}
	});

	Unilite.defineModel('qba300ukrvQbaModel', {
		fields : [ 	 {name : 'DIV_CODE',        	text : '사업장',         type : 'string',		allowBlank:false }
					,{name : 'SPEC',            	text : '규격',          type : 'string',		allowBlank:false }
					,{name : 'TEST_CODE',			text : '검사항목',     type : 'string',			allowBlank:false , 		comboType:'AU', 	comboCode:'Q041'}
					,{name : 'TEST_METHOD',     	text : '검사방법',        type : 'string'}
					,{name : 'TEST_COND',       	text : '검사기준',        type : 'string'}
					,{name : 'EQU_CODE',        	text : '계측기코드',       type : 'string'}
					,{name : 'EQU_NAME',        	text : '계측기',         type : 'string'}
					,{name : 'REVISION_DATE',   	text : '개정일자',        type : 'uniDate',		allowBlank:false }
					,{name : 'REVISION_DATE_ORG',   text : '개정일자ORG',     type : 'uniDate'}
		]
	});

	var directQbaModelProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy', {
		api : {
			read : 'qba300ukrvService.selectTestList',
			update : 'qba300ukrvService.updateDetail',
			create : 'qba300ukrvService.insertDetail',
			destroy : 'qba300ukrvService.deleteDetail',
			syncAll : 'qba300ukrvService.saveAll',
		}
	});

	var directQbaStore = Unilite.createStore('qba300ukrvQbaStore', {
		model : 'qba300ukrvQbaModel',
		autoLoad : false,
		uniOpt : {
			isMaster : true,
			editable : true,
			deletable : true,
			useNavi : false
		},
		proxy : directQbaModelProxy,
		loadStoreRecords : function(record) {
			var searchParam = Ext.getCmp('qba300ukrvSearchForm').getValues();
			var param = {'SPEC'		: record.get('SPEC')};
			var params = Ext.merge(searchParam, param);
			this.load({
				params: params,
				callback : function(records,options,success)    {
					isItemGridUseChange = false;
					
                    /* if(success && records[0] != null) { 
                    	
                    	var searchRecords = directQbaStore.data.items;
    					data = new Object();
    					data.records = [];
    					Ext.each(searchRecords, function(record, i){
    						if(record.get('USE_YN') == 'Y') {
    							data.records.push(record);
    						}
    					});
    					qbaGrid.getSelectionModel().select(data.records);
    					qbaGrid.store.sort({
    						property : 'USE_YN',
    						direction : 'DESC'
    					})
                    } */
				}
			});
		},
		listneers : {
			datachanged : function( store, eOpts ) {
				if(directQbaStore.isDirty() || store.isDirty()) {
					UniAppManager.setToolbarButtons('save', true);
				}else {
					UniAppManager.setToolbarButtons('save', false);
				}
			}
		},
		saveStore : function() {
			
			var inValidRecs = this.getInvalidRecords();
		   	var record = itemGrid.getSelectedRecord();
		   	var searchParam = Ext.getCmp('qba300ukrvSearchForm').getValues();
			var param = {	'DIV_CODE' 		: record.get('DIV_CODE'),
							'SPEC'			: record.get('SPEC'),
							'REVISION_DATE'	: searchParam.REVISION_DATE};				
			if(inValidRecs.length == 0 ) {
				config = { 
					params: [param],
					success: function(batch, option) {
						UniAppManager.app.fnChangeUse();
						
						var chkRecord = qba300ukrvService.getCntQba300t(param, function(provider, response){
							 var useYn = provider[0].USE_YN;
							 
							 Ext.each(selectedR, function(record, i){
									record.set('USE_YN', useYn);
							 });
						});
						
						directQbaStore.loadStoreRecords(record);
				 	} 
				}
				this.syncAllDirect(config);
			}else {
				qbaGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
		
	});
	
	var panelSearch = Unilite.createSearchPanel('qba300ukrvSearchForm', {     
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
				{
					xtype: 'uniTextfield',
					fieldLabel: '규격',
					name: 'SPEC',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.getField('SPEC').setValue(newValue);
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
			},{
				xtype: 'uniTextfield',
				fieldLabel: '규격',
				name: 'SPEC',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.getField('SPEC').setValue(newValue);
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
    var itemGrid = Unilite.createGrid('qba300ukrvItemGrid', {
    	store : directItemStore,
    	layout : 'fit',
    	title : '규격리스트',
    	flex: 1,
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
    		{dataIndex : 'SPEC',			width:300 },
    		{dataIndex : 'USE_YN',			width:100 }
    	],
    	listeners: {
    		render: function(grid, eOpts){
    		/* 	var girdNm = grid.getItemId()
    			grid.getEl().on('click', function(e, t, eOpt) {
    				if(directQbaStore.isDirty()){
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
				if(directQbaStore.isDirty()){
					alert("변경된 데이터가 있습니다.\n저장 후 다시 시도해주세요.")
					return false;
				} 
			}, */
			beforeselect : function ( grid, record, index, eOpts )
			{
				var detailStore = directQbaStore;
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
					directQbaStore.loadData({});
					directQbaStore.loadStoreRecords(record);
				}
		 }
    });

    var qbaGrid = Unilite.createGrid('qba300ukrvQbaGrid', {
		store : directQbaStore,
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
    		{dataIndex : 'DIV_CODE',		width:100 , 	hidden : true },
    		{dataIndex : 'SPEC',            width:100 ,		hidden : true },
    		{dataIndex : 'TEST_CODE',       width:120 },
    		{dataIndex : 'TEST_METHOD',     width:250 },
    		{dataIndex : 'TEST_COND',       width:250 },
    		{dataIndex: 'EQU_CODE', 		width:100
				,editor : Unilite.popup('EQU_CODE_G', {
			 		
					DBtextFieldName:'EQU_CODE',  
					autoPopup: true,
					extParam: {
						EQU_CODE_TYPE : '1'
					},
					listeners: {
						
						
						'onSelected': 	function(records, type){
							var grdRecord = qbaGrid.uniOpt.currentRecord;
							grdRecord.set('EQU_CODE', records[0]['EQU_CODE']);
							grdRecord.set('EQU_NAME', records[0]['EQU_NAME']);
							},'onClear': 	function(type){
							var grdRecord = qbaGrid.uniOpt.currentRecord;
							grdRecord.set('EQU_CODE', '');
							grdRecord.set('EQU_NAME', '');
						},
						applyextparam: function(popup){
							var grdRecord = qbaGrid.uniOpt.currentRecord;
							popup.setExtParam({'DIV_CODE': grdRecord.get('DIV_CODE')});
						}
					}
				})	
			},
			{dataIndex: 'EQU_NAME'                  , width : 200 
				,editor : Unilite.popup('EQU_CODE_G', {
			 		
					DBtextFieldName:'EQU_NAME',  
					autoPopup: true,
					extParam: {
						EQU_CODE_TYPE : '1'
					},
					listeners: {
						
						
						'onSelected': 	function(records, type){
							var grdRecord = qbaGrid.uniOpt.currentRecord;
							grdRecord.set('EQU_CODE', records[0]['EQU_CODE']);
							grdRecord.set('EQU_NAME', records[0]['EQU_NAME']);
							grdRecord.set('EQU_SPEC', records[0]['EQU_SPEC']);
							
						},'onClear': 	function(type){
							var grdRecord = qbaGrid.uniOpt.currentRecord;
							grdRecord.set('EQU_CODE', '');
							grdRecord.set('EQU_NAME', '');
							grdRecord.set('EQU_SPEC', '');
						},
						applyextparam: function(popup){
							var grdRecord = qbaGrid.uniOpt.currentRecord;
							popup.setExtParam({'DIV_CODE': grdRecord.get('DIV_CODE')});
						}
					}
				})
			},
    		{dataIndex : 'REVISION_DATE',   width:120 }

    	],
    	listeners: {
			beforeedit: function( editor, e, eOpts ) {
				if(!e.record.phantom) {					
					if (UniUtils.indexOf(e.field, ['DIV_CODE', 'SPEC', 'TEST_CODE', 'REVISION_DATE'])){
						return false;
					}
				}else if (e.record.phantom) {
					if (UniUtils.indexOf(e.field, ['DIV_CODE', 'SPEC'])){
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
				items: [itemGrid, qbaGrid]
				//items: [qbaGrid]
				
			}, panelResult]
		}		
    	, panelSearch
		],
		id : 'qba300ukrvApp',
		fnInitBinding: function() {
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
            UniAppManager.setToolbarButtons(['reset'],true);
            UniAppManager.setToolbarButtons(['save'],false); 
			this.setDefault();
		},
		onQueryButtonDown:function() {
	        itemGrid.getStore().loadStoreRecords();
	        
	        //qbaGrid.getStore().loadStoreRecords();
      	},
      	onSaveDataButtonDown: function () {                   
           if(directQbaStore.isDirty()) {
        	   directQbaStore.saveStore();           
           }
        },
        onResetButtonDown:function() {
			itemGrid.getStore().loadData({});
			qbaGrid.getStore().loadData({});
			Ext.getCmp('qba300ukrvSearchForm').reset();
			UniAppManager.setToolbarButtons(['newData'], false);
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
					     SPEC			: record[0].data['SPEC'],
					     REVISION_DATE	: revisionDate
					};
					qbaGrid.createRow(r);	
			}
        },
        onDeleteDataButtonDown: function() {
			var selRow = qbaGrid.getSelectedRecord();
            if(!Ext.isEmpty(selRow)){
                if(selRow.phantom === true) {
                	qbaGrid.deleteSelectedRow();
                }else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')){
                	qbaGrid.deleteSelectedRow();   
                }
            }
        },
        setDefault: function() {
        	panelSearch.setValue('DIV_CODE',UserInfo.divCode);
        	panelSearch.getForm().wasDirty = false;
        	panelSearch.resetDirtyStatus();                                         
            UniAppManager.setToolbarButtons(['save','newData'], false);
        },
		fnChangeUse: function() {
			/* var iCnt = 0; */
			var itemRecords = directQbaStore.data.items;
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
    
    Unilite.createValidator('qba300ukrvValidator', {
		store: directQbaStore,
		grid: qbaGrid,
		forms: {'formA: ': qba300ukrvSearchForm},
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type': type, 'fieldName': fieldName, 'newValue': newValue, 'oldValue': oldValue, 'record': record});
			var rv = true;
			
			return rv;
		}
		});
};


</script>