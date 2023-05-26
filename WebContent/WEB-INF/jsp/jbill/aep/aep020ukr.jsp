<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="aep020ukr"  >
	<t:ExtComboStore comboType="BOR120" pgmId="aep020ukr"/> 						<!-- 사업장 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {	
	
   /**
    *   Model 정의 
    * @type 
    */

	Unilite.defineModel('Aep020ukrModel', {
		fields: [ 
			{name: 'BGT_DEPT_CD',		text: '발생부서',			type: 'string', allowBlank: false},
			{name: 'BGT_DEPT_NM',		text: '발생부서명',			type: 'string', allowBlank: false},
			{name: 'COST_DEPT_CD',		text: '귀속부서',			type: 'string', allowBlank: false},
			{name: 'COST_DEPT_NM',		text: '귀속부서명',			type: 'string', allowBlank: false},
			{name: 'DEPT_DESC',			text: '비고',				type: 'string', maxLength: 200}
		]
	});
   
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			create: 'aep020ukrService.insertList',				
			read: 'aep020ukrService.selectList',
			update: 'aep020ukrService.updateList',
			destroy: 'aep020ukrService.deleteList',
			syncAll: 'aep020ukrService.saveAll'
		}
	});
	
   /**
    * Store 정의(Service 정의)
    * @type 
    */               
   var directMasterStore = Unilite.createStore('aep020ukrMasterStore1',{
         model: 'Aep020ukrModel',
         uniOpt : {
               isMaster: true,         // 상위 버튼 연결 
               editable: true,         // 수정 모드 사용 
               deletable:true,         // 삭제 가능 여부 
               useNavi : false         // prev | newxt 버튼 사용
                  //비고(*) 사용않함
            },
            autoLoad: false,
            proxy: directProxy,
    		listeners : {
    	        load : function(store) {
    	        	
    	        }
    	    },
    	    loadStoreRecords : function()   {
	            var param= Ext.getCmp('searchForm').getValues();	
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
				}else {    				
					masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			},
			listeners:{
				load: function(store, records, successful, eOpts) {
					
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
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',           	
			items: [
				Unilite.popup('DEPT', { 
					fieldLabel: '발생부서', 
					validateBlank:false,
					autoPopup: true,
					listeners: {
	//					onSelected: {
	//						fn: function(records, type) {
	//							panelResult.setValue('DEPT_CODE', panelSearch.getValue('DEPT_CODE'));
	//							panelResult.setValue('DEPT_NAME', panelSearch.getValue('DEPT_NAME'));
	//                    	},
	//						scope: this
	//					},
	//					onClear: function(type)	{
	//						panelResult.setValue('DEPT_CODE', '');
	//						panelResult.setValue('DEPT_NAME', '');
	//					},
						onValueFieldChange: function(field, newValue){
							panelResult.setValue('DEPT_CODE', newValue);								
						},
						onTextFieldChange: function(field, newValue){
							panelResult.setValue('DEPT_NAME', newValue);				
						},
						applyextparam: function(popup){	
							
						}
					}
				}),
				Unilite.popup('DEPT', { 
					fieldLabel: '귀속부서', 
					validateBlank:false,
					autoPopup: true,
					valueFieldName:'DEPT_CODE2',
			    	textFieldName:'DEPT_NAME2',
					listeners: {
	//					onSelected: {
	//						fn: function(records, type) {
	//							panelResult.setValue('DEPT_CODE', panelSearch.getValue('DEPT_CODE'));
	//							panelResult.setValue('DEPT_NAME', panelSearch.getValue('DEPT_NAME'));
	//                    	},
	//						scope: this
	//					},
	//					onClear: function(type)	{
	//						panelResult.setValue('DEPT_CODE', '');
	//						panelResult.setValue('DEPT_NAME', '');
	//					},
						onValueFieldChange: function(field, newValue){
							panelResult.setValue('DEPT_CODE2', newValue);								
						},
						onTextFieldChange: function(field, newValue){
							panelResult.setValue('DEPT_NAME2', newValue);				
						},
						applyextparam: function(popup){	
							
						}
					}
				}),{
					xtype: 'uniTextfield',
					name: 'DEPT_DESC',
					fieldLabel: '비고',
					width: 325,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('DEPT_DESC', newValue);
						}
					}
				}				
			]
		}]     	
	});
	
	var panelResult = Unilite.createSearchForm('panelResultForm', {
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 2},
		padding:'1 1 1 1',
		border:true,
    	items: [
    		Unilite.popup('DEPT', { 
				fieldLabel: '발생부서', 
				validateBlank:false,
				autoPopup: true,
				listeners: {
//					onSelected: {
//						fn: function(records, type) {
//							panelResult.setValue('DEPT_CODE', panelSearch.getValue('DEPT_CODE'));
//							panelResult.setValue('DEPT_NAME', panelSearch.getValue('DEPT_NAME'));
//                    	},
//						scope: this
//					},
//					onClear: function(type)	{
//						panelResult.setValue('DEPT_CODE', '');
//						panelResult.setValue('DEPT_NAME', '');
//					},
					onValueFieldChange: function(field, newValue){
						panelSearch.setValue('DEPT_CODE', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelSearch.setValue('DEPT_NAME', newValue);				
					},
					applyextparam: function(popup){	
						
					}
				}
			}),
			Unilite.popup('DEPT', { 
				fieldLabel: '귀속부서', 
				validateBlank:false,
				autoPopup: true,
				valueFieldName:'DEPT_CODE2',
		    	textFieldName:'DEPT_NAME2',
				listeners: {
//					onSelected: {
//						fn: function(records, type) {
//							panelResult.setValue('DEPT_CODE', panelSearch.getValue('DEPT_CODE'));
//							panelResult.setValue('DEPT_NAME', panelSearch.getValue('DEPT_NAME'));
//                    	},
//						scope: this
//					},
//					onClear: function(type)	{
//						panelResult.setValue('DEPT_CODE', '');
//						panelResult.setValue('DEPT_NAME', '');
//					},
					onValueFieldChange: function(field, newValue){
						panelSearch.setValue('DEPT_CODE2', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelSearch.setValue('DEPT_NAME2', newValue);				
					},
					applyextparam: function(popup){	
						
					}
				}
			}),{
				xtype: 'uniTextfield',
				name: 'DEPT_DESC',
				fieldLabel: '비고',
				width: 325,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('DEPT_DESC', newValue);
					}
				}
			}
    	]
    });
   
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
	var masterGrid = Unilite.createGrid('aep020ukrGrid1', {
       region: 'center',
        layout: 'fit',
    	uniOpt: {
    		expandLastColumn: false,
		 	useRowNumberer: true,
		 	copiedRow: true
//		 	useContextMenu: true,
        },
		features: [{
			id: 'masterGridSubTotal',
			ftype: 'uniGroupingsummary',
			showSummaryRow: false						
		},{
			id: 'masterGridTotal',
			ftype: 'uniSummary',
			showSummaryRow: false
		}],
		store: directMasterStore,
        columns: [
    		{dataIndex: 'BGT_DEPT_CD'			, width: 100,
			  editor: Unilite.popup('DEPT_G', {
//		  			textFieldName: 'TREE_CODE',
 	 				DBtextFieldName: 'TREE_CODE',
						listeners: {'onSelected': {
							fn: function(records, type) {
									var rtnRecord = masterGrid.uniOpt.currentRecord;	
									rtnRecord.set('BGT_DEPT_CD', records[0]['TREE_CODE']);
									rtnRecord.set('BGT_DEPT_NM', records[0]['TREE_NAME']);
								},
							scope: this	
							},
							'onClear': function(type) {
								var rtnRecord = masterGrid.uniOpt.currentRecord;	
									rtnRecord.set('BGT_DEPT_CD', '');
									rtnRecord.set('BGT_DEPT_NM', '');
							},
							applyextparam: function(popup){
								
							}									
						}
				})
			},
    		{dataIndex: 'BGT_DEPT_NM'			, width: 200,
			  editor: Unilite.popup('DEPT_G', {
//		  			textFieldName: 'TREE_NAME',
 	 				DBtextFieldName: 'TREE_NAME',
						listeners: {'onSelected': {
							fn: function(records, type) {
									var rtnRecord = masterGrid.uniOpt.currentRecord;	
									rtnRecord.set('BGT_DEPT_CD', records[0]['TREE_CODE']);
									rtnRecord.set('BGT_DEPT_NM', records[0]['TREE_NAME']);
								},
							scope: this	
							},
							'onClear': function(type) {
								var rtnRecord = masterGrid.uniOpt.currentRecord;	
									rtnRecord.set('BGT_DEPT_CD', '');
									rtnRecord.set('BGT_DEPT_NM', '');
							},
							applyextparam: function(popup){
								
							}									
						}
				})
			},{dataIndex: 'COST_DEPT_CD'			, width: 100,
			  editor: Unilite.popup('DEPT_G', {
//		  			textFieldName: 'TREE_CODE',
 	 				DBtextFieldName: 'TREE_CODE',
						listeners: {'onSelected': {
							fn: function(records, type) {
									var rtnRecord = masterGrid.uniOpt.currentRecord;	
									rtnRecord.set('COST_DEPT_CD', records[0]['TREE_CODE']);
									rtnRecord.set('COST_DEPT_NM', records[0]['TREE_NAME']);
								},
							scope: this	
							},
							'onClear': function(type) {
								var rtnRecord = masterGrid.uniOpt.currentRecord;	
									rtnRecord.set('COST_DEPT_CD', '');
									rtnRecord.set('COST_DEPT_NM', '');
							},
							applyextparam: function(popup){
								
							}									
						}
				})
			},
    		{dataIndex: 'COST_DEPT_NM'			, width: 200,
			  editor: Unilite.popup('DEPT_G', {
//		  			textFieldName: 'TREE_NAME',
 	 				DBtextFieldName: 'TREE_NAME',
						listeners: {'onSelected': {
							fn: function(records, type) {
									var rtnRecord = masterGrid.uniOpt.currentRecord;	
									rtnRecord.set('COST_DEPT_CD', records[0]['TREE_CODE']);
									rtnRecord.set('COST_DEPT_NM', records[0]['TREE_NAME']);
								},
							scope: this	
							},
							'onClear': function(type) {
								var rtnRecord = masterGrid.uniOpt.currentRecord;	
									rtnRecord.set('COST_DEPT_CD', '');
									rtnRecord.set('COST_DEPT_NM', '');
							},
							applyextparam: function(popup){
								
							}									
						}
				})
			},
        	{dataIndex: 'DEPT_DESC',								minWidth: 100, flex: 1}
        ],
        listeners: {
        	beforeedit: function(editor, e){
        		if(!e.record.phantom){
        			if(e.field != 'DEPT_DESC'){
	        			return false;
	        		}
        		}        		
        	}, 
        	edit: function(editor, e) {
        		
			}
    	}
    });
   
   
    Unilite.Main( {
		borderItems:[{
         region:'center',
         layout: 'border',
         border: false,
         items:[
            	masterGrid, panelResult
	     	]
	     },
	         panelSearch
	    ], 
      id  : 'aep020ukrApp',
      fnInitBinding : function() {
         UniAppManager.setToolbarButtons(['reset','newData'], true);
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('DEPT_CODE');         
      },
      onQueryButtonDown : function()   {
         masterGrid.getStore().loadStoreRecords();
      },
		onNewDataButtonDown : function() {			
			var r = {
				BGT_DEPT_CD: panelSearch.getValue('DEPT_CODE'),	
				BGT_DEPT_NM: panelSearch.getValue('DEPT_NAME'),	
				COST_DEPT_CD: panelSearch.getValue('DEPT_CODE2'),
				COST_DEPT_NM: panelSearch.getValue('DEPT_NAME2')
			};
			masterGrid.createRow(r, 'BGT_DEPT_CD');
		},
		onSaveDataButtonDown : function() {
			if (masterGrid.getStore().isDirty()) {
				masterGrid.getStore().saveStore();
			}
		},
		onDeleteDataButtonDown : function()	{
			var selRow = masterGrid.getSelectedRecord();
			if(selRow.phantom === true)	{
				masterGrid.deleteSelectedRow();
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				masterGrid.deleteSelectedRow();
			}
		},
		onResetButtonDown : function() {			
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.getStore().loadData({});
			this.fnInitBinding();;
		}
   });
};


</script>