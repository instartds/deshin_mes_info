<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="bor130ukrv"  >
	<t:ExtComboStore comboType="BOR120"  />								<!--  사업장   -->  
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList"/>		<!--창고-->
	<t:ExtComboStore comboType="AU" comboCode="B027"  />
	<t:ExtComboStore comboType="AU" comboCode="B010"  />	
</t:appConfig>

<script type="text/javascript" >
function appMain() {

	/**
	 * Model 정의 
	 * @type 
	 */

	Unilite.defineTreeModel('bor130ukrvModel', {
		// pkGen : user, system(default)
		//idProperty: 'TREE_CODE',
	    fields: [ 	 {name: 'parentId' 			,text:'<t:message code="system.label.base.parentdeptcode" default="상위부서코드"/>' 		,type:'string'	}	// Java 내부 Tree에서 사용 하는 코드로 이름 변경 금지.
	    			,{name: 'TREE_CODE' 		,text:'<t:message code="system.label.base.department" default="부서"/>' 				,type:'string'	,allowBlank:false, isPk:true, pkGen:'user'}
					,{name: 'TREE_NAME' 		,text:'<t:message code="system.label.base.departmentname" default="부서명"/>' 			,type:'string'	,allowBlank:false}
					,{name: 'TREE_LEVEL' 		,text:'<t:message code="system.label.base.treelevel" default="내부코드"/>' 			,type:'string'	 }
					,{name: 'TYPE_LEVEL' 		,text:'<t:message code="system.label.base.division" default="사업장"/>' 			,type:'string'	,allowBlank:false, comboType: 'BOR120'}
					,{name: 'SHOP_CLASS' 		,text:'<t:message code="system.label.base.shopclass" default="매장구분"/>' 			,type:'string'	,allowBlank:false, comboType: 'AU', comboCode:'B134' }
					,{name: 'CUSTOM_CODE' 		,text:'<t:message code="system.label.base.customcode" default="거래처코드"/>' 			,type:'string'	}
					,{name: 'CUSTOM_NAME' 		,text:'<t:message code="system.label.base.customname" default="거래처명"/>' 			,type:'string'	}
		    		,{name: 'WH_CODE'			,text:'<t:message code="system.label.base.mainwarehouse" default="주창고"/>'     		,type:'string',store: Ext.data.StoreManager.lookup('whList'), allowBlank: false}
					,{name: 'SECTION_CD' 		,text:'Cost Center' 	,type:'string'	}
					,{name: 'MAKE_SALE' 		,text:'<t:message code="system.label.base.makesale" default="제조판관"/>' 			,type:'string'	,allowBlank:false, comboType: 'AU', comboCode:'B027' }					
					,{name: 'USE_YN' 			,text:'<t:message code="system.label.base.useyn" default="사용여부"/>' 			,type:'string'	,allowBlank:false, comboType: 'AU', comboCode:'B010'}
					,{name: 'SORT_SEQ' 			,text:'<t:message code="system.label.base.btnSort" default="정렬"/>' 				,type:'integer'	,allowBlank:false, defaultValue: '1'}
					,{name: 'TELEPHONE_NO' 		,text:'<t:message code="system.label.base.phoneno" default="전화번호"/>' 			,type:'string'	}
					,{name: 'FAX_NO' 			,text:'<t:message code="system.label.base.faxno" default="팩스번호"/>' 			,type:'string'	}
					,{name: 'REMARK' 			,text:'<t:message code="system.label.base.remarks" default="비고"/>' 				,type:'string'	}
					,{name: 'COMP_CODE' 		,text:'<t:message code="system.label.base.companycode" default="법인코드"/>' 			,type:'string'	}	
					/* 2015.12.02 추가 */
					,{name: 'INSPEC_FLAG' 		,text:'<t:message code="system.label.base.qualityinspectyn" default="품질검사여부"/>' 		,type:'string'	,allowBlank:false, comboType: 'AU', comboCode:'B010'}	
			]
	});
	
  
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	 var directProxy= Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			 read   : 'bor130ukrvService.selectList'
        	,update : 'bor130ukrvService.updateMulti'
			,create : 'bor130ukrvService.insertMulti'
			,destroy: 'bor130ukrvService.deleteMulti'
			,syncAll: 'bor130ukrvService.saveAll'
		}
	});
	var directMasterStore = Unilite.createTreeStore('bor130ukrvMasterStore',{
			model: 'bor130ukrvModel',
            autoLoad: false,
            folderSort: true,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:true,			// 삭제 가능 여부 
	            useNavi : false			// prev | newxt 버튼 사용
            },
            
            proxy: directProxy,
            listeners: {
            	'load' : function( store, records, successful, eOpts) {
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
            },
			// Store 관련 BL 로직
            // 검색 조건을 통해 DB에서 데이타 읽어 오기 
			loadStoreRecords : function()	{
				var param= Ext.getCmp('bor130ukrvSearchForm').getValues();			
				console.log( param );
				this.load({
					params : param
				});
				
			},
			// 수정/추가/삭제된 내용 DB에 적용 하기 
			saveStore : function()	{		
				var me = this;
				var inValidRecs = this.getInvalidRecords();
				console.log("inValidRecords : ", inValidRecs);
				
					// 상위 부서 코드 정리
					var toCreate = me.getNewRecords();
            		var toUpdate = me.getUpdatedRecords();
            		
            		var toDelete = me.getRemovedRecords();
            		var list = [].concat( toUpdate, toCreate   );
					
					console.log("list:", list);
					if(inValidRecs.length == 0 )	{
						Ext.each(list, function(node, index) {
							var pid = node.get('parentId');
							if(Ext.isEmpty(pid)) {
								node.set('parentId', node.parentNode.get('TREE_CODE'));
							}
							console.log("list:", node.get('parentId') + " / " + node.parentNode.get('TREE_CODE'));
						});
						this.syncAllDirect();
					}else {
						masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
					}
					/*this.syncAll({success : function()	{
										me.commitChanges();
									}
								  }
								);
					*/
					//UniAppManager.setToolbarButtons('save', false);
				
			}
            
		});

	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchForm('bor130ukrvSearchForm',{
        layout : {type : 'uniTable' , columns: 3 },
        items: [  {
            		xtype: 'radiogroup',		            		
            		fieldLabel: '',
            		id : 'APT_PRICE',
            		items : [{boxLabel  : '<t:message code="system.label.base.currentapplieddept" default="현재적용부서"/>', width: 130,  name: 'USE_YN',  inputValue: 'Y'  , checked: true}
                    		,{boxLabel  : '<t:message code="system.label.base.whole" default="전체"/>', width: 80, name: 'USE_YN' , inputValue: ''}
                    		/*,{
				 				fieldLabel: '출고창고',
				 				name:'WH_CODE',
				 				xtype: 'uniCombobox',
								store: Ext.data.StoreManager.lookup('whList'),
								holdable: 'hold',
								hidden: true
				 			}*/
                		]}
		        
		]		            
    });  
	
    /**
     * Master Grid 정의(Grid Panel)
     * @type 
     */
    
    
    var masterGrid = Unilite.createTreeGrid('bor130ukrvGrid', {
    	store: directMasterStore,
		columns:[{
		                xtype: 'treecolumn', //this is so we know which column will show the tree
		                text: '<t:message code="system.label.base.departmentname" default="부서명"/>',
		                width:200,
		                sortable: true,
		                dataIndex: 'TREE_NAME', editable: false 
		         }
				,{dataIndex:'TREE_CODE'		,width:70 }
				,{dataIndex:'TREE_LEVEL'		,width:70 }
				,{dataIndex:'TREE_NAME'		,width:120}	          
				,{dataIndex:'TYPE_LEVEL'	,width:150   } 
				,{dataIndex:'SHOP_CLASS'	,width:100   }
				,{dataIndex:'CUSTOM_CODE'	,width:100,
			 		editor: Unilite.popup('CUST_G',{
		 			textFieldName: 'CUSTOM_CODE',
 	 				DBtextFieldName: 'CUSTOM_CODE',
			  		autoPopup: true,
			 		listeners:{ 'onSelected': {
		                    fn: function(records, type  ){
		                    	var grdRecord;
		                    	var selectedRecords = masterGrid.getSelectionModel().getSelection();
								if(selectedRecords && selectedRecords.length > 0 ) {
									grdRecord= selectedRecords[0];
								}		                    	
								grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
								grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
		                    },
		                    scope: this
                  	   },
		                  'onClear' : function(type)	{		                  		
		                  		var grdRecord;
		                    	var selectedRecords = masterGrid.getSelectionModel().getSelection();
								if(selectedRecords && selectedRecords.length > 0 ) {
									grdRecord= selectedRecords[0];
								}
								grdRecord.set('CUSTOM_CODE','');
								grdRecord.set('CUSTOM_NAME','');
		                  }
						}
				})   }
				,{dataIndex:'CUSTOM_NAME'	,width:150,
			 		editor: Unilite.popup('CUST_G',{
			  			autoPopup: true,
			 			listeners:{ 'onSelected': {
		                    fn: function(records, type  ){
		                    	var grdRecord;
		                    	var selectedRecords = masterGrid.getSelectionModel().getSelection();
								if(selectedRecords && selectedRecords.length > 0 ) {
									grdRecord= selectedRecords[0];
								}		                    	
								grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
								grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
		                    },
		                    scope: this
                  	   },
		                  'onClear' : function(type)	{		                  		
		                  		var grdRecord;
		                    	var selectedRecords = masterGrid.getSelectionModel().getSelection();
								if(selectedRecords && selectedRecords.length > 0 ) {
									grdRecord= selectedRecords[0];
								}		                    	
								grdRecord.set('CUSTOM_CODE','');
								grdRecord.set('CUSTOM_NAME','');
		                  }
						}
				})   }
				,{dataIndex:'WH_CODE'		,width:100   } 
				,{dataIndex:'MAKE_SALE'		,width:100	}         
				,{dataIndex:'USE_YN'		,width:100	}
				,{dataIndex:'SORT_SEQ'		,width:66 	}
				,{dataIndex:'TELEPHONE_NO'	,width:110 	}
				,{dataIndex:'FAX_NO'		,width:110 	}
				,{dataIndex:'INSPEC_FLAG'	,width:100 	}
				,{dataIndex:'REMARK'		,flex:1 	}          
				]        
    });                                                           	
                                                                  	
  	Unilite.Main({                                                 
		items : [panelSearch, 	masterGrid],
		id  : 'bor130ukrvApp',
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['reset'],false);
			UniAppManager.setToolbarButtons(['newData'],true);
			// root visible이 false 일경우 자동으로 load됨.
			//directMasterStore.loadStoreRecords();	
		},
		onQueryButtonDown : function() {	
			directMasterStore.loadStoreRecords();			
		},
		onSaveAndQueryButtonDown : function()	{
			this.onSaveDataButtonDown();
			//this.onQueryButtonDown();
		},
		onNewDataButtonDown : function()	{
	         
	        var newrecord = masterGrid.createRow();
	        if(newrecord) {
	        	newrecord.set('parentId','');
	        	newrecord.set('TYPE_LEVEL', newrecord.parentNode.get('TYPE_LEVEL'));
		        newrecord.set('MAKE_SALE', newrecord.parentNode.get('MAKE_SALE'));
		        newrecord.set('USE_YN', newrecord.parentNode.get('USE_YN'));
		        newrecord.set('INSPEC_FLAG', newrecord.parentNode.get('INSPEC_FLAG'));
		        newrecord.set('SECTION_CD', newrecord.parentNode.get('SECTION_CD'));
	        }
		},
		
		onSaveDataButtonDown: function () {
			var masterGrid = Ext.getCmp('bor130ukrvGrid');
			directMasterStore.saveStore();				
		},
		onDeleteDataButtonDown : function()	{
			masterGrid.deleteSelectedRow();		
		},
		onResetButtonDown:function() {
			var masterGrid = Ext.getCmp('bor130ukrvGrid');
			Ext.getCmp('bor130ukrvSearchForm').getForm().reset();
			masterGrid.reset();
			UniAppManager.setToolbarButtons(['save','prev', 'next'],false);
		}

	});
	
}; 


</script>
