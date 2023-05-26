<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="afb020ukr"  >
	<t:ExtComboStore comboType="BOR120"  />								<!--  사업장   -->  
	<t:ExtComboStore comboType="AU" comboCode="B027"  />
	<t:ExtComboStore comboType="AU" comboCode="B010"  />	
</t:appConfig>

<script type="text/javascript" >
function appMain() {

	/**
	 * Model 정의 
	 * @type 
	 */

	Unilite.defineTreeModel('afb020ukrModel', {
		// pkGen : user, system(default)
		//idProperty: 'TREE_CODE',
	    fields: [ 	 
	    		{name: 'parentId' 				,text:'상위부서코드' 		,type:'string'},	// Java 내부 Tree에서 사용 하는 코드로 이름 변경 금지.
				{name: 'LVL'					,text: '레벨'				,type: 'string'},			 
				{name: 'ONLY_CODE'				,text: 'ONLY_CODE'		,type: 'string'},	 
				{name: 'LEVEL1'					,text: '분류코드1'			,type: 'string'},	     
				{name: 'LEVEL2'					,text: '분류코드2'			,type: 'string'},	     
				{name: 'LEVEL3'					,text: '분류코드3'			,type: 'string'},	     
				{name: 'LEVEL4'					,text: '분류코드4'			,type: 'string'},	     
				{name: 'LEVEL5'					,text: '분류코드5'			,type: 'string'},     
				{name: 'TREE_CODE'				,text: '부서코드'			,type: 'string', isPk:true, pkGen:'user'},	 
				{name: 'TREE_NAME'				,text: '부서명'			,type: 'string'},	 
				{name: 'TREE_LEVEL'				,text: 'TREE_LEVEL'		,type: 'string'},	 
				{name: 'TYPE_LEVEL'				,text: '사업장'			,type: 'string', comboType: 'BOR120'},	 
				{name: 'SECTION_CD'				,text: 'SECTION_CD'		,type: 'string'},	 
				{name: 'MAKE_SALE'				,text: '제조/판관'			,type: 'string', comboType: 'AU', comboCode:'B027'},	 
				{name: 'USE_YN'					,text: '사용여부'			,type: 'string', comboType: 'AU', comboCode:'B010'},		 
				{name: 'SORT_SEQ'				,text: '정렬순서'			,type: 'string'},		 
				{name: 'BUDG_TREE_CODE'			,text: '예산부서코드'		,type: 'string', allowBlank: false},
				{name: 'BUDG_TREE_NAME'			,text: '예산부서명'			,type: 'string'},
				{name: 'REMARK'					,text: '비고'				,type: 'string'},		  
				{name: 'UPLEVE_CODE'			,text: '상위코드'			,type: 'string'},	 
				{name: 'UPDATE_DB_USER'			,text: '수정자'			,type: 'string'},
				{name: 'UPDATE_DB_TIME'			,text: '수정일'			,type: 'string'},
				{name: 'COMP_CODE'				,text: '법인코드'			,type: 'string'}	 
			]
	});
	
  
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	 var directProxy= Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			 read   : 'afb020ukrService.selectList'
        	,update : 'afb020ukrService.updateMulti'
			,syncAll: 'afb020ukrService.saveAll'
		}
	});
	var directMasterStore = Unilite.createTreeStore('afb020ukrMasterStore',{
			model: 'afb020ukrModel',
            autoLoad: false,
            folderSort: true,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:false,		// 삭제 가능 여부 
	            useNavi : false			// prev | newxt 버튼 사용
            },
            
            proxy: directProxy,
            listeners: {
            	'load' : function( store, records, successful, eOpts) {
            		if(records) {
            			var root = this.getRootNode();
            			if(root) {
            				root.expandChildren();
            			}
            		}
            	}
            },
			// Store 관련 BL 로직
            // 검색 조건을 통해 DB에서 데이타 읽어 오기 
			loadStoreRecords : function()	{
				var param= Ext.getCmp('afb020ukrSearchForm').getValues();			
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
				
			}
            
		});

	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchForm('afb020ukrSearchForm',{
        layout : {type : 'uniTable' , columns: 3 },
        items: [  {
            		xtype: 'radiogroup',		            		
            		fieldLabel: '',
            		id : 'APT_PRICE',
            		items : [{boxLabel  : '현재 적용부서', width: 130,  name: 'USE_YN',  inputValue: 'Y'  , checked: true}
                    		,{boxLabel  : '전체', width: 80, name: 'USE_YN' , inputValue: ''}
                		]}
		        
		]		            
    });  
	
    /**
     * Master Grid 정의(Grid Panel)
     * @type 
     */
    
    
    var masterGrid = Unilite.createTreeGrid('afb020ukrGrid', {
    	store: directMasterStore,
		columns:[{
		                xtype: 'treecolumn', //this is so we know which column will show the tree
		                text: '부서명',
		                width:200,
		                sortable: true,
		                dataIndex: 'TREE_NAME', editable: false 
		         }
//				,{dataIndex:'LVL'					,width:70 }
//				,{dataIndex:'ONLY_CODE'				,width:70 }
//				,{dataIndex:'LEVEL1'				,width:70 }
//				,{dataIndex:'LEVEL2'				,width:70 }
//				,{dataIndex:'LEVEL3'				,width:70 }
//				,{dataIndex:'LEVEL4'				,width:70 }
//				,{dataIndex:'LEVEL5'				,width:70 }
				,{dataIndex:'TREE_CODE'				,width:100 }
				,{dataIndex:'TREE_NAME'				,width:150 }
//				,{dataIndex:'TREE_LEVEL'			,width:70 }
				,{dataIndex:'TYPE_LEVEL'			,width:150 }
//				,{dataIndex:'SECTION_CD'			,width:70 }
				,{dataIndex:'MAKE_SALE'				,width:70 }
				,{dataIndex:'USE_YN'				,width:70 }
//				,{dataIndex:'SORT_SEQ'				,width:70 }
				,{dataIndex:'BUDG_TREE_CODE'		,width:100,
			 		editor: Unilite.popup('DEPT_G',{
	//		  			textFieldName: 'TREE_CODE',
	 	 				DBtextFieldName: 'TREE_CODE',
						autoPopup:true,
						listeners: {'onSelected': {
							fn: function(records, type) {
									var rtnRecord = masterGrid.uniOpt.currentRecord;	
									rtnRecord.set('BUDG_TREE_CODE', records[0]['TREE_CODE']);
									rtnRecord.set('BUDG_TREE_NAME', records[0]['TREE_NAME']);
								},
							scope: this	
							},
							'onClear': function(type) {
								var rtnRecord = masterGrid.uniOpt.currentRecord;	
									rtnRecord.set('BUDG_TREE_CODE', '');
									rtnRecord.set('BUDG_TREE_NAME', '');
							},
							applyextparam: function(popup){
								
							}									
						}
					})
				}
				,{dataIndex:'BUDG_TREE_NAME'		,width:150,
			 		editor: Unilite.popup('DEPT_G',{
	//		  			textFieldName: 'TREE_NAME',
	 	 				DBtextFieldName: 'TREE_NAME',
						autoPopup:true,
						listeners: {'onSelected': {
							fn: function(records, type) {
									var rtnRecord = masterGrid.uniOpt.currentRecord;	
									rtnRecord.set('BUDG_TREE_CODE', records[0]['TREE_CODE']);
									rtnRecord.set('BUDG_TREE_NAME', records[0]['TREE_NAME']);
								},
							scope: this	
							},
							'onClear': function(type) {
								var rtnRecord = masterGrid.uniOpt.currentRecord;	
									rtnRecord.set('BUDG_TREE_CODE', '');
									rtnRecord.set('BUDG_TREE_NAME', '');
							},
							applyextparam: function(popup){
								
							}									
						}
					})
				}
//				,{dataIndex:'UPLEVE_CODE'			,width:70 }
//				,{dataIndex:'UPDATE_DB_USER'		,width:70 }
//				,{dataIndex:'UPDATE_DB_TIME'		,width:70 }
//				,{dataIndex:'COMP_CODE'				,width:70 }
				,{dataIndex:'REMARK'				,flex:1}          
			],
			listeners: {
		        beforeedit  : function( editor, e, eOpts ) {
		        	if(UniUtils.indexOf(e.field, ['BUDG_TREE_CODE', 'BUDG_TREE_NAME'])) 
					{ 
						return true;
	  				} else {
	  					return false;
	  				}
		        }
			}       
    });                                                           	
                                                                  	
  	Unilite.Main({                                                 
		items : [panelSearch, 	masterGrid],
		id  : 'afb020ukrApp',
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['reset'],false);
			// root visible이 false 일경우 자동으로 load됨.
			//directMasterStore.loadStoreRecords();	
		},
		onQueryButtonDown : function() {	
			directMasterStore.loadStoreRecords();	
			UniAppManager.setToolbarButtons(['reset'],true);		
		},
		onSaveAndQueryButtonDown : function()	{
			this.onSaveDataButtonDown();
			//this.onQueryButtonDown();
		},
		
		onSaveDataButtonDown: function () {
			var masterGrid = Ext.getCmp('afb020ukrGrid');
			directMasterStore.saveStore();				
		},
		onResetButtonDown:function() {
			directMasterStore.clearData();
			panelSearch.clearForm();
			masterGrid.reset();
		}

	});
	
}; 


</script>
