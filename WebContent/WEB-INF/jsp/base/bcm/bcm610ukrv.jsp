<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bcm610ukrv"  >
	<t:ExtComboStore comboType="BOR120"  />								<!--  사업장   -->  
	<t:ExtComboStore comboType="AU" comboCode="B027"  />
	<t:ExtComboStore comboType="AU" comboCode="A004" />					<!-- 사용여부 -->
</t:appConfig>

<script type="text/javascript" >

function appMain() {

	/* Model 정의 
	 * @type 
	 */
	Unilite.defineTreeModel('bcm610ukrvModel', {
		// pkGen		: user, system(default)
		// idProperty	: 'PJT_CODE',
	    fields: [ 	 {name: 'parentId' 			,text:'상위부서코드' 		,type:'string'	}	// Java 내부 Tree에서 사용 하는 코드로 이름 변경 금지.
					,{name: 'COMP_CODE' 		,text:'<t:message code="system.label.base.companycode" default="법인코드"/>' 			,type:'string'	}	
	    			,{name: 'PJT_CODE' 			,text:'사업코드' 			,type:'string'	,allowBlank:false, isPk:true, pkGen:'user'}
					,{name: 'PJT_NAME' 			,text:'사업명' 			,type:'string'	,allowBlank:false}
					,{name: 'PJT_CODE'	 		,text:'사업코드' 			,type:'string'	,allowBlank:false }
					,{name: 'TREE_LEVEL' 		,text:'TREE_LEVEL' 		,type:'string'	}
					,{name: 'DEPT_CODE' 		,text:'부서' 				,type:'string'	}
					,{name: 'DEPT_NAME' 		,text:'부서명' 			,type:'string'	}
					,{name: 'PERSON_NUMB' 		,text:'담당자' 			,type:'string'	}
					,{name: 'USE_YN'	 		,text:'<t:message code="system.label.base.useyn" default="사용여부"/>' 			,type:'string'	,allowBlank:false, comboType: 'AU', comboCode: 'A004'}
			]
	});
	
	/* Store 정의(Service 정의)
	 * @type 
	 */					
	 var directProxy= Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			 read   : 'bcm610ukrvService.selectList' ,
        	 update : 'bcm610ukrvService.updateMulti',
			 create : 'bcm610ukrvService.insertMulti',
			 destroy: 'bcm610ukrvService.deleteMulti',
			 syncAll: 'bcm610ukrvService.saveAll'
		}
	});
	
	var masterStore = Unilite.createTreeStore('bcm610ukrvMasterStore',{
		model	: 'bcm610ukrvModel',
        autoLoad: false,
        uniOpt : {
        	isMaster	: true,			// 상위 버튼 연결 
        	editable	: true,			// 수정 모드 사용 
        	deletable	: true,			// 삭제 가능 여부 
            useNavi		: false			// prev | next 버튼 사용
        },
        folderSort: true,
        
        proxy: directProxy,

        loadStoreRecords : function()	{
			var param= Ext.getCmp('bcm610ukrvSearchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
				
		},
 
		saveStore : function()	{		
			var me = this;
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);

			// 상위 부서 코드 정리
			var toCreate = me.getNewRecords();
    		var toUpdate = me.getUpdatedRecords();
    		var toDelete = me.getRemovedRecords();

    		var list = [].concat( toUpdate, toCreate   );
    		
			if(inValidRecs.length == 0 )	{
				Ext.each(list, function(node, index) {
					var pid = node.get('parentId');
					if (Ext.isEmpty(pid)) {
						node.set('parentId', node.parentNode.get('PJT_CODE'));
					}
					console.log("list:", node.get('parentId') + " / " + node.parentNode.get('PJT_CODE'));
				});
				this.syncAllDirect();
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		
		listeners: {
        	'load' : function( store, records, successful, eOpts) {
        		if( records.length > 0 ) {
        			UniAppManager.setToolbarButtons('newData',	true);
        			
        		} else if (panelSearch.getValue('USE_YN') != 'N') {
					bcm610ukrvService.insertBasicData([], function(provider, response) {
						UniAppManager.app.onQueryButtonDown();
					});
        		}
        		
        		if(records) {
        			var root = this.getRootNode();
        			if(root) {
        				root.expandChildren();
        				/*
        				Ext.each(root.children, function(node, index) {
        					node
        				});// EACH
        				*/
        			}
        		}
        	}
        }
	});

	/*검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchForm('bcm610ukrvSearchForm',{
        layout : {type : 'uniTable' , columns: 3 },
        items: [
			Unilite.treePopup('PJT_TREE',{ 
		    	fieldLabel		: '사업코드',
		    	valueFieldName	: 'PJT_CODE',
				textFieldName	: 'PJT_NAME',
				valuesName		: 'DEPTS' ,
				selectChildren	: false,
				DBvalueFieldName: 'PJT_CODE',
				DBtextFieldName	: 'PJT_NAME',
				autoPopup		: true,
				useLike			: false,
		    	listeners: {
	                'onValueFieldChange': function(field, newValue, oldValue  ){
//	                    	panelResult.setValue('DEPT',newValue);
	                },
	                'onTextFieldChange':  function( field, newValue, oldValue  ){
//	                    	panelResult.setValue('DEPT_NAME',newValue);
	                },
	                'onValuesChange':  function( field, records){
//	                    	var tagfield = panelResult.getField('DEPTS') ;
//	                    	tagfield.setStoreData(records)
	                }
				}
			}),{
				fieldLabel	: '<t:message code="system.label.base.useyn" default="사용여부"/>'	,
				name		: 'USE_YN', 
				xtype		: 'uniCombobox', 
				comboType	: 'AU',
				comboCode	: 'A004',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {						
					}
				}
			}
		  
		]
	});  

    /* Master Grid 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createTreeGrid('bcm610ukrvGrid', {
        region	: 'center',
        store	: masterStore, 
        excelTitle: '자산대장조회',
        uniOpt	: {
			useMultipleSorting	: false,
    		useLiveSearch		: true,
    		onLoadSelectFirst	: true,
    		dblClickToEdit		: true,
    		useGroupSummary		: false,
			useContextMenu		: false,
			useRowNumberer		: false,
			expandLastColumn	: true,
			useRowContext		: false,
    		filter: {
				useFilter		: true,
				autoCreate		: true
			}
        },
		columns:[
			{
                xtype	: 'treecolumn', //this is so we know which column will show the tree
                text	: '사업명',
                width	: 300,
                sortable: true,
                dataIndex: 'PJT_NAME', editable: false 
			},
//			{dataIndex:'TREE_LEVEL'		, width:100},
			{dataIndex:'PJT_CODE'		, width:100/*,
		 		editor: Unilite.treePopup('PJT_TREE_G',{
		 			textFieldName	: 'PJT_CODE',
					DBtextFieldName	: 'PJT_CODE',
					listeners:{ 'onSelected': {
	                    fn: function(records, type  ){
	                    	var grdRecord;
	                    	var selectedRecords = masterGrid.getSelectionModel().getSelection();
							if(selectedRecords && selectedRecords.length > 0 ) {
								grdRecord= selectedRecords[0];
							}		                    	
							grdRecord.set('PJT_CODE',records[0]['PJT_CODE']);
							grdRecord.set('PJT_NAME',records[0]['PJT_NAME']);
	                    },
	                    scope: this
					},
	                  'onClear' : function(type)	{		                  		
	                  		var grdRecord;
	                    	var selectedRecords = masterGrid.getSelectionModel().getSelection();
							if(selectedRecords && selectedRecords.length > 0 ) {
								grdRecord= selectedRecords[0];
							}
							grdRecord.set('PJT_CODE','');
							grdRecord.set('PJT_NAME','');
						}
					}
				})
			*/},
			{dataIndex:'PJT_NAME'		, width:200/*,
		 		editor: Unilite.treePopup('PJT_TREE_G',{
					listeners:{ 'onSelected': {
	                    fn: function(records, type  ){
	                    	var grdRecord;
	                    	var selectedRecords = masterGrid.getSelectionModel().getSelection();
							if(selectedRecords && selectedRecords.length > 0 ) {
								grdRecord= selectedRecords[0];
							}		                    	
							grdRecord.set('PJT_CODE',records[0]['PJT_CODE']);
							grdRecord.set('PJT_NAME',records[0]['PJT_NAME']);
	                    },
	                    scope: this
					},
	                  'onClear' : function(type)	{		                  		
	                  		var grdRecord;
	                    	var selectedRecords = masterGrid.getSelectionModel().getSelection();
							if(selectedRecords && selectedRecords.length > 0 ) {
								grdRecord= selectedRecords[0];
							}
							grdRecord.set('PJT_CODE','');
							grdRecord.set('PJT_NAME','');
						}
					}
				})
			*/},
			{dataIndex:'DEPT_CODE'		, width:100			, hidden: true,
		 		editor: Unilite.popup('DEPT_G',{
			  		autoPopup: true,
					listeners:{ 'onSelected': {
	                    fn: function(records, type  ){
	                    	var grdRecord;
	                    	var selectedRecords = masterGrid.getSelectionModel().getSelection();
							if(selectedRecords && selectedRecords.length > 0 ) {
								grdRecord= selectedRecords[0];
							}		                    	
							grdRecord.set('DEPT_CODE',records[0]['TREE_CODE']);
							grdRecord.set('DEPT_NAME',records[0]['TREE_NAME']);
	                    },
	                    scope: this
					},
	                  'onClear' : function(type)	{		                  		
	                  		var grdRecord;
	                    	var selectedRecords = masterGrid.getSelectionModel().getSelection();
							if(selectedRecords && selectedRecords.length > 0 ) {
								grdRecord= selectedRecords[0];
							}
							grdRecord.set('DEPT_CODE','');
							grdRecord.set('DEPT_NAME','');
						}
					}
				})
			},
			{dataIndex:'DEPT_NAME'		, width:100,
		 		editor: Unilite.popup('DEPT_G',{
			  		autoPopup: true,
					listeners:{ 'onSelected': {
	                    fn: function(records, type  ){
	                    	var grdRecord;
	                    	var selectedRecords = masterGrid.getSelectionModel().getSelection();
							if(selectedRecords && selectedRecords.length > 0 ) {
								grdRecord= selectedRecords[0];
							}		                    	
							grdRecord.set('DEPT_CODE',records[0]['TREE_CODE']);
							grdRecord.set('DEPT_NAME',records[0]['TREE_NAME']);
	                    },
	                    scope: this
					},
	                  'onClear' : function(type)	{		                  		
	                  		var grdRecord;
	                    	var selectedRecords = masterGrid.getSelectionModel().getSelection();
							if(selectedRecords && selectedRecords.length > 0 ) {
								grdRecord= selectedRecords[0];
							}
							grdRecord.set('DEPT_CODE','');
							grdRecord.set('DEPT_NAME','');
						}
					}
				})
			},
			{dataIndex:'PERSON_NUMB'	, width:100,
		 		editor: Unilite.popup('Employee_G',{
			  		autoPopup: true,
					listeners:{ 'onSelected': {
	                    fn: function(records, type  ){
	                    	var grdRecord;
	                    	var selectedRecords = masterGrid.getSelectionModel().getSelection();
							if(selectedRecords && selectedRecords.length > 0 ) {
								grdRecord= selectedRecords[0];
							}		                    	
							grdRecord.set('PERSON_NUMB',records[0]['NAME']);
	                    },
	                    scope: this
					},
	                  'onClear' : function(type)	{		                  		
	                  		var grdRecord;
	                    	var selectedRecords = masterGrid.getSelectionModel().getSelection();
							if(selectedRecords && selectedRecords.length > 0 ) {
								grdRecord= selectedRecords[0];
							}
							grdRecord.set('PERSON_NUMB','');
						}
					}
				})
			} ,       
			{dataIndex:'USE_YN'			, width:100}
		],
        listeners: {
        	selectionchange:function( model1, selected, eOpts ){},
			render: function(grid, eOpts){},	
			beforedeselect : function ( gird, record, index, eOpts ){},
			beforeedit  : function( editor, e, eOpts ) {
          		if (UniUtils.indexOf(e.field,'PJT_CODE')) {
					if(e.record.phantom){
						return true;
					}else{
						return false;
					}
				} else{
					return true;
				}
			}
        }
    });                                                           	
  

  	Unilite.Main({                                                 
		items	: [panelSearch, 	masterGrid],
		id		: 'bcm610ukrvApp',
		
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['reset', 'newData'],false);

			//초기화 시 포커스 설정
			panelSearch.onLoadSelectText('PJT_CODE');
		},

		onQueryButtonDown : function() {	
			masterStore.loadStoreRecords();			
		},
		
		onSaveAndQueryButtonDown : function()	{
			this.onSaveDataButtonDown();
			//this.onQueryButtonDown();
		},
		onNewDataButtonDown : function()	{
	        var newrecord = masterGrid.createRow();
	        if(newrecord) {
	        	newrecord.set('parentId','');
		        newrecord.set('USE_YN', 'Y');
	        }
		},
		
		onSaveDataButtonDown: function () {
			masterStore.saveStore();				
		},
		
		onDeleteDataButtonDown : function()	{
			var record = masterGrid.getSelectionModel().getSelection(); 
			if (Ext.isEmpty(record)) {
				Unilite.messageBox(Msg.sMA0256);	
			} else {
				if (!Ext.isEmpty(record[0].childNodes)) {
					Unilite.messageBox(Msg.sMB123);									//하위 레벨이 있으면 삭제할 수 없음
				} else {
					masterGrid.deleteSelectedRow();
				}
			}
		},
		onResetButtonDown:function() {
			Ext.getCmp('bcm610ukrvSearchForm').getForm().reset();
			masterGrid.reset();
			UniAppManager.setToolbarButtons(['save','reset','newData','prev', 'next'],false);
		}
	});
	
}; 


</script>
