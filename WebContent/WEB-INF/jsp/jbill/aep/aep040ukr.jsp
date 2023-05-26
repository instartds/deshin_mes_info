<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="aep040ukr"  >
	<t:ExtComboStore comboType="BOR120" pgmId="aep040ukr"/>  <!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A020" />		 <!--사용여부-->
	<t:ExtComboStore comboType="AU" comboCode="A022" />		 <!--증빙유형-->
	<t:ExtComboStore comboType="AU" comboCode="J685" />		 <!--세금코드-->
</t:appConfig>
<script type="text/javascript" >

function appMain() {	
	
   /**
    *   Model 정의 
    * @type 
    */

	Unilite.defineModel('Aep040ukrModel', {
		fields: [
			{name: 'COST_CENTER',		text: '비용부서',			type: 'string', allowBlank: false},
			{name: 'COST_CENTER_NAME',	text: '비용부서명',			type: 'string', allowBlank: false},
			{name: 'TAX_CODE',			text: '세금코드',			type: 'string', comboType: 'AU', comboCode: 'J685', allowBlank: false},
			{name: 'ACCT_CD',			text: '부가세계정',			type: 'string', allowBlank: false},
			{name: 'ACCNT_NAME',		text: '부가세계정명',		type: 'string', allowBlank: false},
			{name: 'CARD_TAX_YN',		text: '법인카드',			type: 'string', comboType: 'AU',  comboCode: 'A020', allowBlank: false},
			{name: 'REAL_TAX_YN',		text: '실물증빙',			type: 'string', comboType: 'AU',  comboCode: 'A020', allowBlank: false},
			{name: 'TAX_YN',			text: '세금계산서',			type: 'string', comboType: 'AU',  comboCode: 'A020', allowBlank: false},
			{name: 'ETAX_YN',			text: '전자세금계산서',		type: 'string', comboType: 'AU',  comboCode: 'A020', allowBlank: false},
			{name: 'INPUT_YN',			text: '부가세입력여부',		type: 'string', comboType: 'AU',  comboCode: 'A020', allowBlank: false},
			{name: 'USE_YN',			text: '사용유무',			type: 'string', comboType: 'AU',  comboCode: 'A020', allowBlank: false},
			{name: 'TAX_DESC',			text: '세금코드설명',		type: 'string'}
		]
	});
   
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			create: 'aep040ukrService.insertList',				
			read: 'aep040ukrService.selectList',
			update: 'aep040ukrService.updateList',
			destroy: 'aep040ukrService.deleteList',
			syncAll: 'aep040ukrService.saveAll'
		}
	});
	
   /**
    * Store 정의(Service 정의)
    * @type 
    */               
   var directMasterStore = Unilite.createStore('aep040ukrMasterStore1',{
         model: 'Aep040ukrModel',
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
				}), {
					fieldLabel: '세금코드',
					name:'TAX_CODE',	
					xtype: 'uniCombobox', 
					comboType:'AU',
					comboCode:'J685',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('TAX_CODE', newValue);
						}
					}
				},{
					xtype: 'container',
					layout: {type: 'uniTable', columns: 3},
					defaults: {width: 110},
					items:[{
						name:'CARD_TAX_YN',                                                                                                                
						boxLabel: '법인카드',                                                                                                       		
						inputValue :'Y',                                                                                                        		
						xtype:'checkbox',                                                                                                       		
						width: 153,                                                                                                             		
						margin: '0 0 0 43',                                                                                                     		
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
								panelResult.setValue('CARD_TAX_YN', newValue);
							}
						}
					},{
						name:'REAL_TAX_YN', 
						boxLabel: '실물증빙',
						hideLabel: true,
						inputValue :'Y',
						width: 90,
						xtype:'checkbox',
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
								panelResult.setValue('REAL_TAX_YN', newValue);
							}
						}
					},{
						name:'TAX_YN',
						boxLabel: '세금계산서',
						hideLabel: true,
						inputValue :'Y',						
						xtype:'checkbox',
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
								panelResult.setValue('TAX_YN', newValue);
							}
						}
					}]
				},{
					xtype: 'container',
					layout: {type: 'uniTable', columns: 2},
					defaults: {width: 110},
					items:[{
						name:'ETAX_YN',
						boxLabel: '전자세금계산서',
						hideLabel: true,
						inputValue :'Y',
						width: 153,
						margin: '0 0 0 43',
						xtype:'checkbox',
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
								panelResult.setValue('ETAX_YN', newValue);
							}
						}
					},{
						name:'INPUT_YN',
						boxLabel: '부가세입력여부',
						hideLabel: true,
						inputValue :'Y',						
						xtype:'checkbox',
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
								panelResult.setValue('INPUT_YN', newValue);
							}
						}
					}]
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
				listeners: {
//					onSelected: {
//						fn: function(records, type) {
//							panelSearch.setValue('DEPT_CODE', panelSearch.getValue('DEPT_CODE'));
//							panelSearch.setValue('DEPT_NAME', panelSearch.getValue('DEPT_NAME'));
//                    	},
//						scope: this
//					},
//					onClear: function(type)	{
//						panelSearch.setValue('DEPT_CODE', '');
//						panelSearch.setValue('DEPT_NAME', '');
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
			}), {
				fieldLabel: '세금코드',
				name:'TAX_CODE',	
				xtype: 'uniCombobox', 
				comboType:'AU',
				comboCode:'J685',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('TAX_CODE', newValue);
					}
				}
			},{
				xtype: 'container',
				layout: {type: 'uniTable', columns: 5},
				items:[{
					name:'CARD_TAX_YN',                                                                                                                
					boxLabel: '법인카드',                                                                                                       		
					inputValue :'Y',                                                                                                        		
					xtype:'checkbox',                                                                                                       		
					width: 130,                                                                                                             		
					margin: '0 0 0 43',                                                                                                     		
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('CARD_TAX_YN', newValue);
						}
					}
				},{
					name:'REAL_TAX_YN', 
					boxLabel: '실물증빙',
					hideLabel: true,
					inputValue :'Y',					
					xtype:'checkbox',
					width: 85,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('REAL_TAX_YN', newValue);
						}
					}
				},{
					name:'TAX_YN',
					boxLabel: '세금계산서',
					hideLabel: true,
					inputValue :'Y',					
					xtype:'checkbox',
					width: 90,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('TAX_YN', newValue);
						}
					}
				},{
					name:'ETAX_YN',
					boxLabel: '전자세금계산서',
					hideLabel: true,
					inputValue :'Y',					
					xtype:'checkbox',
					width: 120,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('ETAX_YN', newValue);
						}
					}
				},{
					name:'INPUT_YN',
					boxLabel: '부가세입력여부',
					hideLabel: true,
					inputValue :'Y',					
					xtype:'checkbox',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('INPUT_YN', newValue);
						}
					}
				}]
			}
    	]
    });

    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
	var masterGrid = Unilite.createGrid('aep040ukrGrid1', {
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
        	{dataIndex: 'COST_CENTER'			, width: 100,
			  editor: Unilite.popup('DEPT_G', {
			  		autoPopup: true,
//		  			textFieldName: 'TREE_CODE',
 	 				DBtextFieldName: 'TREE_CODE',
						listeners: {'onSelected': {
							fn: function(records, type) {
									var rtnRecord = masterGrid.uniOpt.currentRecord;	
									rtnRecord.set('COST_CENTER', records[0]['TREE_CODE']);
									rtnRecord.set('COST_CENTER_NAME', records[0]['TREE_NAME']);
								},
							scope: this	
							},
							'onClear': function(type) {
								var rtnRecord = masterGrid.uniOpt.currentRecord;	
									rtnRecord.set('COST_CENTER', '');
									rtnRecord.set('COST_CENTER_NAME', '');
							},
							applyextparam: function(popup){
								
							}									
						}
				})
			},
    		{dataIndex: 'COST_CENTER_NAME'			, width: 200,
			  editor: Unilite.popup('DEPT_G', {
			  		autoPopup: true,
//		  			textFieldName: 'TREE_NAME',
 	 				DBtextFieldName: 'TREE_NAME',
						listeners: {'onSelected': {
							fn: function(records, type) {
									var rtnRecord = masterGrid.uniOpt.currentRecord;	
									rtnRecord.set('COST_CENTER', records[0]['TREE_CODE']);
									rtnRecord.set('COST_CENTER_NAME', records[0]['TREE_NAME']);
								},
							scope: this	
							},
							'onClear': function(type) {
								var rtnRecord = masterGrid.uniOpt.currentRecord;	
									rtnRecord.set('COST_CENTER', '');
									rtnRecord.set('COST_CENTER_NAME', '');
							},
							applyextparam: function(popup){
								
							}									
						}
				})
			},
        	{dataIndex: 'TAX_CODE',					width: 120},
        	{dataIndex: 'ACCT_CD'     		, width: 100, 
			  	editor: Unilite.popup('ACCNT_G', {
			  		autoPopup: true,
    				DBtextFieldName: 'ACCNT_CODE',
	 				listeners: {'onSelected': {
							fn: function(records, type) {
			                    console.log('records : ', records);
			                    var grdRecord = masterGrid.uniOpt.currentRecord;
			                    Ext.each(records, function(record,i) {	
									grdRecord.set('ACCT_CD', record['ACCNT_CODE']);
									grdRecord.set('ACCNT_NAME', record['ACCNT_NAME']);
								}); 
							},
							scope: this
						},
						'onClear': function(type) {
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('ACCT_CD', '');
							grdRecord.set('ACCNT_NAME', '');
						},
						applyextparam: function(popup){
								popup.setExtParam({'ADD_QUERY': "SPEC_DIVI = 'F1'"});			//WHERE절 추카 쿼리
//								popup.setExtParam({'CHARGE_CODE': gsChargeCode});				//bParam(3)
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
									grdRecord.set('ACCT_CD', record['ACCNT_CODE']);
									grdRecord.set('ACCNT_NAME', record['ACCNT_NAME']);
								}); 
							},
								scope: this
						},
						'onClear': function(type) {
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('ACCT_CD', '');
							grdRecord.set('ACCNT_NAME', '');
						},
						applyextparam: function(popup){
								popup.setExtParam({'ADD_QUERY': "SPEC_DIVI = 'F1'"});			//WHERE절 추카 쿼리
//								popup.setExtParam({'CHARGE_CODE': gsChargeCode});			//bParam(3)
						}
					}
				 }
			)},
        	{dataIndex: 'CARD_TAX_YN',				width: 120},
        	{dataIndex: 'REAL_TAX_YN',				width: 120},
        	{dataIndex: 'TAX_YN',					width: 120},
        	{dataIndex: 'ETAX_YN',					width: 120},
        	{dataIndex: 'INPUT_YN',					width: 120},
        	{dataIndex: 'USE_YN',					width: 120},
        	{dataIndex: 'TAX_DESC',					minWidth: 120, flex: 1}
        	
        ],
        listeners: {
        	beforeedit: function(editor, e){
        		if(!e.record.phantom){
        			if(e.field == 'COST_CENTER' || e.field == 'COST_CENTER_NAME' || e.field == 'ACCT_CD' || e.field == 'ACCNT_NAME' || e.field == 'TAX_CODE'){
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
      id  : 'aep040ukrApp',
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
				COST_CENTER: panelSearch.getValue('DEPT_CODE'),
				COST_CENTER_NAME: panelSearch.getValue('DEPT_NAME'),
				TAX_CODE: panelSearch.getValue('TAX_CODE'),
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