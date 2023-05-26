<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="aep050ukr"  >
	<t:ExtComboStore comboType="BOR120" pgmId="aep050ukr"/> 						<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A020" />		 <!--사용여부-->
	<t:ExtComboStore comboType="AU" comboCode="A022" />		 <!--증빙유형-->
	<t:ExtComboStore comboType="AU" comboCode="J671" />		 <!--전표유형-->
</t:appConfig>
<script type="text/javascript" >

function appMain() {	
	
   /**
    *   Model 정의 
    * @type 
    */

	Unilite.defineModel('Aep050ukrModel', {
		fields: [
			{name: 'KOSTL_CODE',		text: '비용부서',			type: 'string', allowBlank: false},
			{name: 'KOSTL_NAME',		text: '비용부서명',			type: 'string', allowBlank: false},
			{name: 'ACCT_CODE',				text: '계정코드',			type: 'string', allowBlank: false},
			{name: 'ACCNT_NAME',		text: '계정과목명',			type: 'string', allowBlank: false},
			{name: 'KOSTL_TYPE',		text: '전표유형',			type: 'string', comboType: 'AU',  comboCode: 'J671', allowBlank: false},
			{name: 'USE_YN',			text: '사용유무',			type: 'string', comboType: 'AU',  comboCode: 'A020', allowBlank: false}
		]
	});
   
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			create: 'aep050ukrService.insertList',				
			read: 'aep050ukrService.selectList',
			update: 'aep050ukrService.updateList',
			destroy: 'aep050ukrService.deleteList',
			syncAll: 'aep050ukrService.saveAll'
		}
	});
	
   /**
    * Store 정의(Service 정의)
    * @type 
    */               
   var directMasterStore = Unilite.createStore('aep050ukrMasterStore1',{
         model: 'Aep050ukrModel',
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
	            var param= panelSearch.getValues();	
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
					fieldLabel: '비용부서', 
					validateBlank:false,
					autoPopup: true,
					allowBlank: false,
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
				Unilite.popup('ACCNT',{
			    	fieldLabel: '계정코드',
			    	valueFieldName:'ACCT_CD',
                    textFieldName:'ACCNT_NAME',
			    	validateBlank:false,	    
					autoPopup: true,			
					listeners: {
//						onSelected: {
//							fn: function(records, type) {
//								panelResult.setValue('ACCNT_CODE', panelSearch.getValue('ACCNT_CODE'));
//								panelResult.setValue('ACCNT_NAME', panelSearch.getValue('ACCNT_NAME'));
//	                    	},
//							scope: this
//						},
//						onClear: function(type)	{
//							panelResult.setValue('ACCNT_CODE', '');
//							panelResult.setValue('ACCNT_NAME', '');
//						},
						onValueFieldChange: function(field, newValue){
							panelResult.setValue('ACCT_CD', newValue);								
						},
						onTextFieldChange: function(field, newValue){
							panelResult.setValue('ACCNT_NAME', newValue);				
						},
						applyextparam: function(popup){
							popup.setExtParam({'ADD_QUERY': ''});			//WHERE절 추카 쿼리
							popup.setExtParam({'CHARGE_CODE': ''});			//bParam(3)			
						}
					}
			    }), {
					fieldLabel: '증빙유형',
					name:'KOSTL_TYPE',	
					xtype: 'uniCombobox', 
					comboType:'AU',
					comboCode:'J671',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('KOSTL_TYPE', newValue);
						}
					}
				}, {
					fieldLabel: '사용유무',
					name:'USE_YN',	
					xtype: 'uniCombobox', 
					comboType:'AU',
					comboCode:'A020',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('USE_YN', newValue);
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
			fieldLabel: '비용부서', 
			validateBlank:false,
			autoPopup: true,
			allowBlank: false,
	        tdAttrs: {width: 380},  
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
		Unilite.popup('ACCNT',{
	    	fieldLabel: '계정코드',
	    	valueFieldName:'ACCT_CD',
            textFieldName:'ACCNT_NAME',
			autoPopup: true,
	    	validateBlank:false,	    			
			listeners: {
//						onSelected: {
//							fn: function(records, type) {
//								panelSearch.setValue('ACCNT_CODE', panelSearch.getValue('ACCNT_CODE'));
//								panelSearch.setValue('ACCNT_NAME', panelSearch.getValue('ACCNT_NAME'));
//	                    	},
//							scope: this
//						},
//						onClear: function(type)	{
//							panelSearch.setValue('ACCNT_CODE', '');
//							panelSearch.setValue('ACCNT_NAME', '');
//						},
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('ACCT_CD', newValue);								
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('ACCNT_NAME', newValue);				
				},
				applyextparam: function(popup){
					popup.setExtParam({'ADD_QUERY': ''});			//WHERE절 추카 쿼리
					popup.setExtParam({'CHARGE_CODE': ''});			//bParam(3)			
				}
			}
	    }), {
			fieldLabel: '증빙유형',
			name:'KOSTL_TYPE',	
			xtype: 'uniCombobox', 
			comboType:'AU',
			comboCode:'J671',
	        tdAttrs: {width: 380},  
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('KOSTL_TYPE', newValue);
				}
			}
		}, {
			fieldLabel: '사용유무',
			name:'USE_YN',	
			xtype: 'uniCombobox', 
			comboType:'AU',
			comboCode:'A020',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('USE_YN', newValue);
				}
			}
		}]
    });

    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
	var masterGrid = Unilite.createGrid('aep050ukrGrid1', {
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
        	{dataIndex: 'KOSTL_CODE'			, width: 100,
			  editor: Unilite.popup('DEPT_G', {
			  		autoPopup: true,
//		  			textFieldName: 'TREE_CODE',
 	 				DBtextFieldName: 'TREE_CODE',
						listeners: {'onSelected': {
							fn: function(records, type) {
									var rtnRecord = masterGrid.uniOpt.currentRecord;	
									rtnRecord.set('KOSTL_CODE', records[0]['TREE_CODE']);
									rtnRecord.set('KOSTL_NAME', records[0]['TREE_NAME']);
								},
							scope: this	
							},
							'onClear': function(type) {
								var rtnRecord = masterGrid.uniOpt.currentRecord;	
									rtnRecord.set('KOSTL_CODE', '');
									rtnRecord.set('KOSTL_NAME', '');
							},
							applyextparam: function(popup){
								
							}									
						}
				})
			},
    		{dataIndex: 'KOSTL_NAME'			, width: 200,
			  editor: Unilite.popup('DEPT_G', {
			  		autoPopup: true,
//		  			textFieldName: 'TREE_NAME',
 	 				DBtextFieldName: 'TREE_NAME',
						listeners: {'onSelected': {
							fn: function(records, type) {
									var rtnRecord = masterGrid.uniOpt.currentRecord;	
									rtnRecord.set('KOSTL_CODE', records[0]['TREE_CODE']);
									rtnRecord.set('KOSTL_NAME', records[0]['TREE_NAME']);
								},
							scope: this	
							},
							'onClear': function(type) {
								var rtnRecord = masterGrid.uniOpt.currentRecord;	
									rtnRecord.set('KOSTL_CODE', '');
									rtnRecord.set('KOSTL_NAME', '');
							},
							applyextparam: function(popup){
								
							}									
						}
				})
			},
        	{dataIndex: 'ACCT_CODE'     		, width: 100, 
			  	editor: Unilite.popup('ACCNT_G', {
			  		autoPopup: true,
    				DBtextFieldName: 'ACCNT_CODE',
	 				listeners: {'onSelected': {
								fn: function(records, type) {
				                    console.log('records : ', records);
				                    var grdRecord = masterGrid.uniOpt.currentRecord;
				                    Ext.each(records, function(record,i) {	
										grdRecord.set('ACCT_CODE', record['ACCNT_CODE']);
										grdRecord.set('ACCNT_NAME', record['ACCNT_NAME']);
									}); 
								},
								scope: this
							},
							'onClear': function(type) {
								var grdRecord = masterGrid.uniOpt.currentRecord;
								grdRecord.set('ACCT_CODE', '');
								grdRecord.set('ACCNT_NAME', '');
							},
							applyextparam: function(popup){
//								popup.setExtParam({'ADD_QUERY': "SLIP_SW = 'Y' AND GROUP_YN = 'N'"});			//WHERE절 추카 쿼리
//								popup.setExtParam({'CHARGE_CODE': gsChargeCode});			//bParam(3)
							}
					}
				 }) 
			}, 				
			{dataIndex: 'ACCNT_NAME'		, width: 200, 				
			  	editor: Unilite.popup('ACCNT_G', {
			  		autoPopup: true,
	 				listeners: {'onSelected': {
								fn: function(records, type) {
				                    console.log('records : ', records);
				                    var grdRecord = masterGrid.uniOpt.currentRecord;
				                    Ext.each(records, function(record,i) {	
										grdRecord.set('ACCT_CODE', record['ACCNT_CODE']);
										grdRecord.set('ACCNT_NAME', record['ACCNT_NAME']);
									}); 
								},
									scope: this
							},
							'onClear': function(type) {
								var grdRecord = masterGrid.uniOpt.currentRecord;
								grdRecord.set('ACCT_CODE', '');
								grdRecord.set('ACCNT_NAME', '');
							},
							applyextparam: function(popup){
//								popup.setExtParam({'ADD_QUERY': "SLIP_SW = 'Y' AND GROUP_YN = 'N'"});			//WHERE절 추카 쿼리
//								popup.setExtParam({'CHARGE_CODE': gsChargeCode});			//bParam(3)
							}
					}
				 }
			)},
        	{dataIndex: 'KOSTL_TYPE',									width: 120},
        	{dataIndex: 'USE_YN',										width: 120}
        ],
        listeners: {
        	beforeedit: function(editor, e){
        		if(!e.record.phantom){
        			if(e.field == 'KOSTL_CODE' || e.field == 'KOSTL_NAME' || e.field == 'ACCNT' || e.field == 'ACCNT_NAME' || e.field == 'KOSTL_TYPE'){
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
      id  : 'aep050ukrApp',
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
		if(!this.isValidSearchForm()){
			return false;
		}
         masterGrid.getStore().loadStoreRecords();
      },
		onNewDataButtonDown : function() {			
			var r = {
				KOSTL_CODE: panelSearch.getValue('DEPT_CODE'),
				KOSTL_NAME: panelSearch.getValue('DEPT_NAME'),
				ACCT_CODE: panelSearch.getValue('ACCT_CODE'),
				ACCNT_NAME: panelSearch.getValue('ACCNT_NAME'),
				KOSTL_TYPE: panelSearch.getValue('KOSTL_TYPE'),
				USE_YN: 'Y'
			};
			masterGrid.createRow(r, 'KOSTL_CODE');
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