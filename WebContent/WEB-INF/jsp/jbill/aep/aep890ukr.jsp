<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="aep890ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 --> 
	<t:ExtComboStore comboType="AU" comboCode="A004" /> <!-- 사용유무 -->
	<t:ExtComboStore comboType="AU" comboCode="J514" /> <!-- 문서종류 -->
	<t:ExtComboStore comboType="AU" comboCode="J515" /> <!-- 고정결재선 유형 -->
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
	Unilite.defineModel('Aep890ukrMasterModel', {
	   fields: [
			{name: 'COMP_CODE'                , text: '회사코드'            , type: 'string', allowBlank: false},
			{name: 'COMP_NAME'                , text: '회사명'             , type: 'string', allowBlank: false},
			{name: 'IF_SYSTEM_TYPE'           , text: '연계시스템코드'       , type: 'string', allowBlank: false, maxLength: 2},
			{name: 'IF_SYSTEM_TYPE_NM'        , text: '연계시스템명'        , type: 'string', allowBlank: false},
			{name: 'IF_REJECT_DOC_USE'        , text: '부결문서번호재사용여부' , type: 'string', comboType: 'AU', comboCode: 'A004', allowBlank: false, defaultValue: 'Y'}
	    ]
	});
	
	Unilite.defineModel('Aep890ukrDetailModel', {
	   fields: [
			{name: 'COMP_CODE'             , text: '회사코드'        , type: 'string', allowBlank: false},
            {name: 'IF_SYSTEM_TYPE'        , text: '연계시스템코드'    , type: 'string', allowBlank: false},
            {name: 'IF_SYSTEM_TYPE_NM'     , text: '연계시스템명'     , type: 'string', allowBlank: false},
            {name: 'IF_DOC_TYPE'           , text: '문서코드'        , type: 'string', allowBlank: false},
            {name: 'IF_DOC_TYPE_NM'        , text: '문서명칭'        , type: 'string', allowBlank: false},
            {name: 'IF_DOC_KIND'           , text: '문서종류'        , type: 'string', comboType: 'AU', comboCode: 'J514'},
            {name: 'IF_RETURN_PROCESS'     , text: '결재응답 대상구분'  , type: 'string', allowBlank: false, maxLength: 200},
            {name: 'IF_FIX_OBJ_TYPE'       , text: '고정결재선 유형'   , type: 'string', comboType: 'AU', comboCode: 'J515'},
            {name: 'IF_FIX_OBJ_VAL'        , text: '고정결재선 값'    , type: 'string', maxLength: 10},
            {name: 'USE_YN'                , text: '사용유무'       , type: 'string', comboType: 'AU', comboCode: 'A004', allowBlank: false, defaultValue: 'Y'}
	    ]
	});
	 
	var directMasterProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'aep890ukrService.selectMasterList',
			update: 'aep890ukrService.updateMaster',
			create: 'aep890ukrService.insertMaster',
			destroy: 'aep890ukrService.deleteMaster',
			syncAll: 'aep890ukrService.saveAll'
		}
	});
	
	var directDetailProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'aep890ukrService.selectDetailList',
			update: 'aep890ukrService.updateDetail',
			create: 'aep890ukrService.insertDetail',
			destroy: 'aep890ukrService.deleteDetail',
			syncAll: 'aep890ukrService.saveAll'
		}
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('aba700MasterStore',{
		model: 'Aep890ukrMasterModel',
		uniOpt: {
            isMaster: false,			// 상위 버튼 연결 
            editable: true,			// 수정 모드 사용 
            deletable:true,			// 삭제 가능 여부 
	        useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directMasterProxy,
        loadStoreRecords: function() {
			var param = panelSearch.getValues();			
			console.log(param);
			this.load({
				params : param
			});
			
		},
		saveStore : function()	{
			var inValidRecs = this.getInvalidRecords();
			if(inValidRecs.length == 0 )	{
				var config = {
//					params:[panelSearch.getValues()],
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
		model: 'Aep890ukrDetailModel',
		uniOpt: {
            isMaster: false,			// 상위 버튼 연결 
            editable: true,			// 수정 모드 사용 
            deletable:true,			// 삭제 가능 여부 
	        useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directDetailProxy,
        loadStoreRecords: function(record) {
			var param = record;			
			console.log(param);
			this.load({
				params : param
			});
			
		},
		saveStore : function()	{
			var inValidRecs = this.getInvalidRecords();
			if(inValidRecs.length == 0 )	{
				var config = {
//					params:[panelSearch.getValues()],
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
	    			Unilite.popup('COMP',{
	    			validateBlank:false,
					fieldLabel: '회사명',	    			
					listeners: {
						onValueFieldChange: function(field, newValue){
							panelResult.setValue('COMP_CODE', newValue);								
						},
						onTextFieldChange: function(field, newValue){
							panelResult.setValue('COMP_NAME', newValue);				
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
				})]	
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
            Unilite.popup('COMP',{
                validateBlank:false,
                fieldLabel: '회사명',                  
                listeners: {
                    onValueFieldChange: function(field, newValue){
                        panelSearch.setValue('COMP_CODE', newValue);                                
                    },
                    onTextFieldChange: function(field, newValue){
                        panelSearch.setValue('COMP_NAME', newValue);                
                    }
//                      onSelected: {
//                          fn: function(records, type) {
//                              panelResult.setValue('REMARK_CODE', panelSearch.getValue('REMARK_CODE'));
//                              panelResult.setValue('REMARK_NAME', panelSearch.getValue('REMARK_NAME'));                                                                                                           
//                          },
//                          scope: this
//                      },
//                      onClear: function(type) {
//                          panelResult.setValue('REMARK_CODE', '');
//                          panelResult.setValue('REMARK_NAME', '');
//                      }
                }
            })
        ]
	});

    /**
     * Master Grid 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('aba700MasterGrid', {
    	layout : 'fit',
        region : 'center',
        title: '연계시스템내역',
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
        columns: [{
            dataIndex: 'COMP_CODE'         , width: 90,
              editor: Unilite.popup('COMP_G', {
                    autoPopup: true,
                    DBtextFieldName: 'COMP_CODE',
                    listeners: {'onSelected': {
                        fn: function(records, type) {
                                var rtnRecord = masterGrid.uniOpt.currentRecord;    
                                rtnRecord.set('COMP_CODE', records[0]['COMP_CODE']);
                                rtnRecord.set('COMP_NAME', records[0]['COMP_NAME']);
                            },
                        scope: this 
                        },
                        'onClear': function(type) {
                            var rtnRecord = masterGrid.uniOpt.currentRecord;    
                                rtnRecord.set('COMP_CODE', '');
                                rtnRecord.set('COMP_NAME', '');
                        },
                        applyextparam: function(popup){
                            
                        }                                   
                    }
                })            
            },{
            dataIndex: 'COMP_NAME'         , width: 120,
              editor: Unilite.popup('COMP_G', {
                    autoPopup: true,
                    DBtextFieldName: 'COMP_NAME',
                    listeners: {'onSelected': {
                        fn: function(records, type) {
                                var rtnRecord = masterGrid.uniOpt.currentRecord;    
                                rtnRecord.set('COMP_CODE', records[0]['COMP_CODE']);
                                rtnRecord.set('COMP_NAME', records[0]['COMP_NAME']);
                            },
                        scope: this 
                        },
                        'onClear': function(type) {
                            var rtnRecord = masterGrid.uniOpt.currentRecord;    
                                rtnRecord.set('COMP_CODE', '');
                                rtnRecord.set('COMP_NAME', '');
                        },
                        applyextparam: function(popup){
                            
                        }                                   
                    }
                })            
            }, 
            {dataIndex: 'IF_SYSTEM_TYPE'           , width: 120},
            {dataIndex: 'IF_SYSTEM_TYPE_NM'        , width: 140},
            {dataIndex: 'IF_REJECT_DOC_USE'        , minWidth: 160, flex: 1}
        ],
        listeners: {
        	selectionchange:function( model1, selected, eOpts ){
        		if(selected.length > 0)	{
	        		var record = selected[0].data;	        		
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
					
				}
			},
			beforeedit  : function( editor, e, eOpts ) {
          		if(!e.record.phantom){
                    if(e.field != 'IF_REJECT_DOC_USE'){
                        return false;
                    }
                }
			}, 
            edit: function(editor, e) {
                if(e.field == 'IF_SYSTEM_TYPE'){
                    if(isNaN(e.value)){
                        alert(Msg.sMB074);  //숫자만 입력가능합니다.
                        e.record.set(e.field, e.originalValue);
                    }
                }
            }
        }
    });  
    
    var detailGrid = Unilite.createGrid('aba700DetailGrid', {
    	layout : 'fit',
        region : 'east',
        title: '관련문서내역',
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
            {dataIndex: 'COMP_CODE'             , width: 90},                                                    
            {dataIndex: 'IF_SYSTEM_TYPE'        , width: 120},                                                   
            {dataIndex: 'IF_SYSTEM_TYPE_NM'     , width: 100},                                                   
            {dataIndex: 'IF_DOC_TYPE'           , width: 120},                                                   
            {dataIndex: 'IF_DOC_TYPE_NM'        , width: 120},                                                   
            {dataIndex: 'IF_DOC_KIND'           , width: 120},                                                   
            {dataIndex: 'IF_RETURN_PROCESS'     , width: 120},                                                   
            {dataIndex: 'IF_FIX_OBJ_TYPE'       , width: 120},                                                   
            {dataIndex: 'IF_FIX_OBJ_VAL'        , width: 100},                                                   
            {dataIndex: 'USE_YN'                , minWidth: 100, flex: 1}                                        
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
                if(!e.record.phantom){
                    if(e.field == 'COMP_CODE' || e.field == 'IF_SYSTEM_TYPE' || e.field == 'IF_SYSTEM_TYPE_NM' || e.field == 'IF_DOC_TYPE'){  
                        return false;
                    }
                }else{
                    if(e.field == 'COMP_CODE' || e.field == 'IF_SYSTEM_TYPE' || e.field == 'IF_SYSTEM_TYPE_NM'){  
                        return false;
                    }                	
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
						flex : 4,
						items : [ masterGrid ]
					}, {
						region : 'center',
						xtype : 'container',
						layout : 'fit',
						flex : 7,
						items : [ detailGrid ]
					}
				]	
			},
            panelSearch
		], 
		id : 'aba700App',
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['newData'],true);
			UniAppManager.setToolbarButtons(['reset'],false);			
		},
		onQueryButtonDown : function()	{	
			directMasterStore.loadStoreRecords();
		}, 
		onNewDataButtonDown : function() {
			if(activeGridId == 'aba700MasterGrid' )	{
				var r = {
				    COMP_CODE: panelSearch.getValue('COMP_CODE'),
				    COMP_NAME: panelSearch.getValue('COMP_NAME')
				}				
				masterGrid.createRow(r, 'COMP_CODE');		    	
			}else{
				var pRecord = masterGrid.getSelectedRecord();
				if(directMasterStore.getCount() > 0 && !pRecord.phantom){                                                                              
					if(pRecord != null)  {                                                                                                             
                        var r = {                                                                                                                      
                            COMP_CODE: pRecord.get('COMP_CODE'),
                            IF_SYSTEM_TYPE: pRecord.get('IF_SYSTEM_TYPE'),
                            IF_SYSTEM_TYPE_NM: pRecord.get('IF_SYSTEM_TYPE_NM')
                        }
                        detailGrid.createRow(r, 'IF_DOC_TYPE');
                    }
				}else{
				    alert('먼저 저장을 하셔야 추가가 가능합니다.');					
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
	
//	Unilite.createValidator('validator01', {
//		store: directMasterStore,
//		grid: masterGrid,
//		validate: function( type, fieldName, newValue, oldValue, record, eopt, editor, e) {
//			if(newValue == oldValue){
//				return false;
//			}
//			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record, 'editor':editor, 'e':e});
//			var rv = true;
//			switch(fieldName) {
//				case "REMARK_CD" :
//				var detailRecords = directDetailStore.data.items;
//				Ext.each(detailRecords, function(record, index){					
//					record.set('REMARK_CD', newValue);
//				});					
//				break;
//			}
//			
//			return rv;
//		}
//	});
};


</script>
