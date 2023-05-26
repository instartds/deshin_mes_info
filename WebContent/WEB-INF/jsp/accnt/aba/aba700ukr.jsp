<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="aba700ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 --> 
	<t:ExtComboStore comboType="AU" comboCode="A093" /> <!-- 재무제표양식차수 -->
	<t:ExtComboStore comboType="AU" comboCode="B042"  /> 			<!-- 금액단위 -->
	<t:ExtComboStore comboType="AU" comboCode="A001"  /> 			<!-- 차대구분 -->
	
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >
var gsChargeCode = '${getChargeCode}';
function appMain() {   
	var activeGridId = 'aba700MasterGrid';
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Aba700ukrMasterModel', {
	   fields: [
			{name: 'REMARK_CD'			, text: '적요코드'				, type: 'string', allowBlank: false, maxLength: 8},
			{name: 'REMARK'				, text: '적요명'				, type: 'string', allowBlank: false, maxLength: 100},
			{name: 'UPDATE_DB_USER'		, text: 'UPDATE_DB_USER'	, type: 'string'},
			{name: 'UPDATE_DB_TIME'		, text: 'UPDATE_DB_TIME'	, type: 'string'},
			{name: 'COMP_CODE'			, text: 'COMP_CODE'			, type: 'string', defaultValue: UserInfo.compCode}
	    ]
	});
	
	Unilite.defineModel('Aba700ukrDetailModel', {
	   fields: [
			{name: 'REMARK_CD'			, text: '적요코드'				, type: 'string', allowBlank: false},
			{name: 'DR_CR'				, text: '차대구분'				, type: 'string', comboType: 'AU', comboCode: 'A001', allowBlank: false},
			{name: 'ACCNT'				, text: '계정코드'				, type: 'string', allowBlank: false, maxLength: 16},
			{name: 'ACCNT_NAME'			, text: '계정과목명'			, type: 'string'},			
			{name: 'UPDATE_DB_USER'		, text: 'UPDATE_DB_USER'	, type: 'string'},
			{name: 'UPDATE_DB_TIME'		, text: 'UPDATE_DB_TIME'	, type: 'string'},
			{name: 'COMP_CODE'			, text: 'COMP_CODE'			, type: 'string', defaultValue: UserInfo.compCode}
			
	    ]
	});
	 
	var directMasterProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'aba700ukrService.selectMasterList',
			update: 'aba700ukrService.updateMaster',
			create: 'aba700ukrService.insertMaster',
			destroy: 'aba700ukrService.deleteMaster',
			syncAll: 'aba700ukrService.saveAll'
		}
	});
	
	var directDetailProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'aba700ukrService.selectDetailList',
//			update: 'aba700ukrService.updateDetail',
			create: 'aba700ukrService.insertDetail',
			destroy: 'aba700ukrService.deleteDetail',
			syncAll: 'aba700ukrService.saveAll'
		}
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('aba700MasterStore',{
		model: 'Aba700ukrMasterModel',
		uniOpt: {
            isMaster: false,			// 상위 버튼 연결 
            editable: true,			// 수정 모드 사용 
            deletable:true,			// 삭제 가능 여부 
	        useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directMasterProxy,
        loadStoreRecords: function() {
			var param= panelSearch.getValues();			
			console.log(param);
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
					}
				}
				this.syncAllDirect(config);			
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
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
	
	var directDetailStore = Unilite.createStore('aba700DetailStore',{
		model: 'Aba700ukrDetailModel',
		uniOpt: {
            isMaster: false,			// 상위 버튼 연결 
            editable: true,			// 수정 모드 사용 
            deletable:true,			// 삭제 가능 여부 
	        useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directDetailProxy,
        loadStoreRecords: function(record) {
			var param= {
				REMARK_CD:record.get('REMARK_CD')
			};				
			console.log(param);
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
						
					}
				}
				this.syncAllDirect(config);			
			}else {
				detailGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
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
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {          
		title: '검색조건',         
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
			title: '기본정보',   
			itemId: 'search_panel1',
			layout : {type : 'vbox', align : 'stretch'},
	    	items : [{
	    		xtype:'container',
	    		layout : {type : 'uniTable', columns : 1},
	    		items:[
	    			Unilite.popup('REMARK',{
	    			validateBlank:true,
					fieldLabel: '적요',	    			
					listeners: {
						onValueFieldChange: function(field, newValue){
							panelResult.setValue('REMARK_CODE', newValue);								
						},
						onTextFieldChange: function(field, newValue){
							panelResult.setValue('REMARK_NAME', newValue);				
						}
//						onSelected: {
//							fn: function(records, type) {
//								panelResult.setValue('REMARK_CODE', panelSearch.getValue('REMARK_CODE'));
//								panelResult.setValue('REMARK_NAME', panelSearch.getValue('REMARK_NAME'));				 																							
//							},
//							scope: this
//						},
//						onClear: function(type)	{
//							panelResult.setValue('REMARK_CODE', '');
//							panelResult.setValue('REMARK_NAME', '');
//						}
					}
				})/*,{
			 		fieldLabel: '적요코드',
			 		xtype: 'uniTextfield',
			 		name: 'REMARK_CD',
			 		hidden: false
				}*/]	
			}]
		}]
	});	
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [
			Unilite.popup('REMARK',{
			validateBlank:true,
			fieldLabel: '적요',   			
			listeners: {
//				onSelected: {
//					fn: function(records, type) {
//						panelSearch.setValue('REMARK_CODE', panelResult.getValue('REMARK_CODE'));
//						panelSearch.setValue('REMARK_NAME', panelResult.getValue('REMARK_NAME'));				 																							
//					},
//					scope: this
//				},
//				onClear: function(type)	{
//					panelSearch.setValue('REMARK_CODE', '');
//					panelSearch.setValue('REMARK_NAME', '');
//				}
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('REMARK_CODE', newValue);								
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('REMARK_NAME', newValue);				
				}
			}
		})]
	});
    /**
     * Master Grid 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('aba700MasterGrid', {
    	layout : 'fit',
        region : 'center',
		store: directMasterStore,
    	uniOpt: {
    		expandLastColumn: false,
		 	useRowNumberer: true,
		 	copiedRow: true
//		 	useContextMenu: true,
        },
    	features: [{
    		id: 'masterGridSubTotal1',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: false 
    	},{
    		id: 'masterGridTotal1', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: false
    	}],
        columns: [        
        	{dataIndex: 'REMARK_CD'			, width: 206}, 				
			{dataIndex: 'REMARK'			, width: 395},
			{dataIndex: 'UPDATE_DB_USER'	, width: 266, hidden: true},
			{dataIndex: 'UPDATE_DB_TIME'	, width: 266, hidden: true}
//			{dataIndex: 'COMP_CODE'			, width: 266, hidden: true}
		],
        listeners: {
        	selectionchange:function( model1, selected, eOpts ){
        		if(selected.length > 0)	{
	        		var record = selected[0];	        		
	        		directDetailStore.loadData({})
	        		if(!record.phantom){
	        			directDetailStore.loadStoreRecords(record);
	        		}
       			}
          	},
          	render: function(grid, eOpts){
			    grid.getEl().on('click', function(e, t, eOpt) {
			    	activeGridId = grid.getItemId();
			    	if( directDetailStore.isDirty() || directMasterStore.isDirty() )	{
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
			 },	
			 beforedeselect : function ( gird, record, index, eOpts ){
				if(directDetailStore.isDirty())	{
					if(confirm(Msg.sMB017 + "\n" + Msg.sMB061))	{
						var inValidRecs = directDetailStore.getInvalidRecords();
						if(inValidRecs.length > 0 )	{
							alert(Msg.sMB083);
							return false;
						}else {
							directDetailStore.saveStore();
						}
					}
					
//					Ext.Msg.show({
//					     title:'확인',
//					     msg: Msg.sMB017 + "\n" + Msg.sMB061,
//					     buttons: Ext.Msg.YESNOCANCEL,
//					     icon: Ext.Msg.QUESTION,
//					     fn: function(res) {
//					     	//console.log(res);
//					     	if (res === 'yes' ) {
//					     		var inValidRecs = directDetailStore.getInvalidRecords();
//								if(inValidRecs.length > 0 )	{
//									alert(Msg.sMB083);
//									return false;
//								}else {
//									directDetailStore.saveStore();
//								}
//			                    saveTask.delay(500);
//					     	} else if(res === 'cancel') {
//					     		return false;
//					     	}
//					     }
//					});
				}
			},
			beforeedit  : function( editor, e, eOpts ) {
          		if (UniUtils.indexOf(e.field,'REMARK_CD')) {
					if(e.record.phantom){
						return true;
					}else{
						return false;
					}
				}else if (UniUtils.indexOf(e.field, 'REMARK')) {
					return true;
				}else{
					return false;
				}
			}
        }
    });  
    
    var detailGrid = Unilite.createGrid('aba700DetailGrid', {
    	layout : 'fit',
        region : 'east',
		store: directDetailStore,
    	uniOpt: {
    		expandLastColumn: false,
		 	useRowNumberer: true,
		 	copiedRow: true,
            onLoadSelectFirst: false
//		 	useContextMenu: true,
        },
    	features: [{
    		id: 'masterGridSubTotal2',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: false 
    	},{
    		id: 'masterGridTotal2', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: false
    	}],
        columns: [        
        	{dataIndex: 'REMARK_CD'			, width: 166, hidden: true}, 				
			{dataIndex: 'DR_CR'				, width: 160, align: 'center'}, 				
			{dataIndex: 'ACCNT'     		, width: 160, 
			  	editor: Unilite.popup('ACCNT_G', {
			  		autoPopup: true,
    				DBtextFieldName: 'ACCNT_CODE',
	 				listeners: {'onSelected': {
								fn: function(records, type) {
				                    console.log('records : ', records);
				                    var grdRecord = detailGrid.uniOpt.currentRecord;
				                    Ext.each(records, function(record,i) {	
										grdRecord.set('ACCNT', record['ACCNT_CODE']);
										grdRecord.set('ACCNT_NAME', record['ACCNT_NAME']);
									}); 
								},
								scope: this
							},
							'onClear': function(type) {
								var grdRecord = detailGrid.uniOpt.currentRecord;
								grdRecord.set('ACCNT', '');
								grdRecord.set('ACCNT_NAME', '');
							},
							applyextparam: function(popup){
								popup.setExtParam({'ADD_QUERY': "SLIP_SW = 'Y' AND GROUP_YN = 'N'"});			//WHERE절 추카 쿼리
								popup.setExtParam({'CHARGE_CODE': gsChargeCode});			//bParam(3)
							}
					}
				 }) 
			}, 				
			{dataIndex: 'ACCNT_NAME'		, width: 190, 
				autoPopup: true,
			  	editor: Unilite.popup('ACCNT_G', {
					autoPopup:true,
	 				listeners: {'onSelected': {
								fn: function(records, type) {
				                    console.log('records : ', records);
				                    var grdRecord = detailGrid.uniOpt.currentRecord;
				                    Ext.each(records, function(record,i) {	
										grdRecord.set('ACCNT', record['ACCNT_CODE']);
										grdRecord.set('ACCNT_NAME', record['ACCNT_NAME']);
									}); 
								},
									scope: this
							},
							'onClear': function(type) {
								var grdRecord = detailGrid.uniOpt.currentRecord;
								grdRecord.set('ACCNT', '');
								grdRecord.set('ACCNT_NAME', '');
							},
							applyextparam: function(popup){
								popup.setExtParam({'ADD_QUERY': "SLIP_SW = 'Y' AND GROUP_YN = 'N'"});			//WHERE절 추카 쿼리
								popup.setExtParam({'CHARGE_CODE': gsChargeCode});			//bParam(3)
							}
					}
				 }
			)}
//			{dataIndex: 'UPDATE_DB_USER'	, width: 66, hidden: true}, 				
//			{dataIndex: 'UPDATE_DB_TIME'	, width: 66, hidden: true}, 				
//			{dataIndex: 'COMP_CODE'			, width: 66, hidden: true},
//			{dataIndex: 'UPDATE_DB_TIME'	, width: 66, hidden: true}, 				
//			{dataIndex: 'COMP_CODE'			, width: 66, hidden: true}
		],
		listeners : {
			render: function(grid, eOpts){
			    grid.getEl().on('click', function(e, t, eOpt) {
			    	activeGridId = grid.getItemId();
			    	if( directDetailStore.isDirty() || directMasterStore.isDirty())	{
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
			 },
			beforeedit  : function( editor, e, eOpts ) {
          		if (UniUtils.indexOf(e.field,["DR_CR", "ACCNT", "ACCNT_NAME"])) {
					if(e.record.phantom){
						return true;
					}else{
						return false;
					}
				}else{
					return false;
				}
			}
		} 
    }); 
    
	 Unilite.Main( {
		borderItems:[{
				region:'center',
				layout: 'border',
				border: false,
				items:[panelResult,
					{
						region : 'west',
						xtype : 'container',
						layout : 'fit',
						width : 640,
						items : [ masterGrid ]
					}, {
						region : 'center',
						xtype : 'container',
						layout : 'fit',
						flex : 1,
						items : [ detailGrid ]
					}
				]	
			},
			panelSearch  	
		], 
		id : 'aba700App',
		fnInitBinding : function(params) {
//			alert(gsChargeCode);
			UniAppManager.setToolbarButtons(['newData'],true);
			UniAppManager.setToolbarButtons(['reset'],false);
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			
			if(params && params.REMARK)	{
				activeGridId == 'aba700MasterGrid' ;
				masterGrid.createRow({'REMARK':params.REMARK}	, 'REMARK_CD');
				detailGrid.createRow({'DR_CR' :params.DR_CR, 'ACCNT': params.ACCNT, 'ACCNT_NAME': params.ACCNT_NAME}	, 'DR_CR');
				return;
			}
			activeSForm.onLoadSelectText('REMARK_CODE');
		},
		onQueryButtonDown : function()	{	
			directMasterStore.loadStoreRecords();
		}, 
		onNewDataButtonDown : function() {
			if(activeGridId == 'aba700MasterGrid' )	{
				masterGrid.createRow(null, 'REMARK_CD');		    	
			}else{
				var pRecord = masterGrid.getSelectedRecord();	
				if(pRecord != null)	{
					var r = {
						REMARK_CD: pRecord.get('REMARK_CD')
					}
					detailGrid.createRow(r, 'DR_CR');
				}
			}
		},
		onSaveDataButtonDown: function () {
			var masterInValidRecs = directMasterStore.getInvalidRecords();
			var detailInValidRecs = directDetailStore.getInvalidRecords();
			
			if(masterInValidRecs.length != 0 || detailInValidRecs.length != 0)	{
				if(masterInValidRecs.length != 0){					
					masterGrid.uniSelectInvalidColumnAndAlert(masterInValidRecs);					
				}else if(detailInValidRecs.length != 0){
					detailGrid.uniSelectInvalidColumnAndAlert(detailInValidRecs);
				}		
			}else{
				if(directMasterStore.isDirty())	{
					directMasterStore.saveStore();			//Master 데이타 저장 성공 후 Detail 저장함.
				}else if(directDetailStore.isDirty()){
					directDetailStore.saveStore();
				}
			}			
		},
		onDeleteDataButtonDown : function()	{
			if(activeGridId == 'aba700MasterGrid')	{
				var selRow = masterGrid.getSelectedRecord();
				if(selRow.phantom === true)	{
					masterGrid.deleteSelectedRow();
				}else {
					var toDelete = directDetailStore.getRemovedRecords();
					if(toDelete.length > 0 || directDetailStore.getCount() > 0){						
						alert(Msg.sMB078);
						return false;												
					}
					if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
						masterGrid.deleteSelectedRow();
					}					
				}
			}else{
				var selRow = detailGrid.getSelectedRecord();
				if(selRow.phantom === true)	{
					detailGrid.deleteSelectedRow();
				}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
					detailGrid.deleteSelectedRow();				
				}
			}			
		}
	});
	
	Unilite.createValidator('validator01', {
		store: directMasterStore,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt, editor, e) {
			if(newValue == oldValue){
				return false;
			}
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record, 'editor':editor, 'e':e});
			var rv = true;
			switch(fieldName) {
				case "REMARK_CD" :
				var detailRecords = directDetailStore.data.items;
				Ext.each(detailRecords, function(record, index){					
					record.set('REMARK_CD', newValue);
				});					
				break;
			}
			
			return rv;
		}
	});
};


</script>
