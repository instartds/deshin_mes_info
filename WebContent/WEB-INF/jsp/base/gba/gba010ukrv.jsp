<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="gba010ukrv"  >
	<t:ExtComboStore comboType="BOR120"  />				<!-- 사업장				 	-->  
	<t:ExtComboStore comboType="AU" comboCode="B248" /> <!-- 예산구분 			 		-->
</t:appConfig>

<script type="text/javascript" >

var lastYearCopyWindow; // 전년도자료복사 버튼

function appMain() {

	/**
	 * Model 정의 
	 * @type 
	 */
	Unilite.defineTreeModel('Gba010Model', {
		// pkGen : user, system(default)
		//idProperty: 'TREE_CODE',
	    fields: [
	    	{name: 'COMP_CODE'			, text: '<t:message code="system.label.base.companycode" default="법인코드"/>'			, type: 'string'},
	    	{name: 'DIV_CODE'			, text: '사업장코드'		, type: 'string'},
	    	{name: 'BUDG_CODE'			, text: '예산코드'			, type: 'string'},
			{name: 'BUDG_NAME'			, text: '예산명'			, type: 'string'},
			{name: 'ACCNT'				, text: '계정코드'			, type: 'string', maxLength: 16},
			{name: 'ACCNT_NAME'			, text: '계정과목명'		, type: 'string'},
			{name: 'CODE_LEVEL'			, text: '레벨'			, type: 'string'},
			{name: 'TREE_LEVEL'			, text: '트리레벨'			, type: 'string'},
			{name: 'BUDG_TYPE'			, text: '예산구분'			, type: 'string', comboType: 'AU', comboCode:'B248'},
			{name: 'ST_COST_RATE'		, text: '수주비율'			, type: 'float', decimalPrecision: 2, format:'0,000.00'},
			{name: 'USE_YN'				, text: '<t:message code="system.label.base.useyn" default="사용여부"/>'			, type: 'string', comboType: 'AU', comboCode:'A004'},
			{name: 'SORT_SEQ'			, text: '순서'			, type: 'string'},
			{name: 'REMARK'				, text: '<t:message code="system.label.base.remarks" default="비고"/>'			, type: 'string'},
			{name: 'parentId' 			, text: '상위부서코드' 		, type: 'string'}	// Java 내부 Tree에서 사용 하는 코드로 이름 변경 금지.
	    ]
	});
	 
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	 var directProxy= Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			 read   : 'gba010ukrvService.selectList'
        	,update : 'gba010ukrvService.updateMulti'
			,create : 'gba010ukrvService.insertMulti'
			,destroy: 'gba010ukrvService.deleteMulti'
			,syncAll: 'gba010ukrvService.saveAll'
		}
	});
	var directMasterStore = Unilite.createTreeStore('gba010ukrvMasterStore',{
			model: 'Gba010Model',
            autoLoad: false,
            folderSort: true,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:true,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            proxy: directProxy,
            listeners: {
            	'load' : function( store, records, successful, operation, node, eOpts ) {
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
				var param= Ext.getCmp('searchForm').getValues();
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
            		
            		var paramMaster= panelSearch.getValues();	//syncAll 수정
					
					console.log("list:", list);
					if(inValidRecs.length == 0 )	{
						debugger;
						Ext.each(list, function(node, index) {
							var pid = node.get('parentId');
							if(Ext.isEmpty(pid)) {
								node.set('parentId', node.parentNode.get('BUDG_CODE'));
							}
							console.log("list:", node.get('parentId') + " / " + node.parentNode.get('BUDG_CODE'));
						});
						
						config = {
							params: [paramMaster],
							success: function(batch, option) {
								panelSearch.getForm().wasDirty = false;
								panelSearch.resetDirtyStatus();
								console.log("set was dirty to false");
								UniAppManager.setToolbarButtons('save', false);
								if (directMasterStore.count() == 0) {   
									UniAppManager.app.onResetButtonDown();
								}else{
									directMasterStore.loadStoreRecords();
								}
							 } 
						};
						debugger;
						this.syncAllDirect(config);
					}else {
						masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
					}
			}
            
		});

	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchForm('searchForm',{
        layout : {type : 'uniTable' , columns: 2, tableAttrs: {width: '100%'}},
        items: [{
        	fieldLabel: '<t:message code="system.label.base.division" default="사업장"/>',
        	name:'DIV_CODE',
        	xtype: 'uniCombobox', 
        	comboType:'BOR120',
        	allowBlank:false,
        	value: UserInfo.divCode,
        	listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
					UniAppManager.app.onQueryButtonDown();
				}
			}
        }],
		setAllFieldsReadOnly: function(b) { 
		    var r= true
		    if(b) {
		    	var invalid = this.getForm().getFields().filterBy(function(field) {
		        	return !field.validate();
		        });                      
		        if(invalid.length > 0) {
		     		r=false;
		         	var labelText = ''
		     		if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
		          		var labelText = invalid.items[0]['fieldLabel']+'은(는)';
		        	} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
		          		var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
		        	}
					Unilite.messageBox(labelText+Msg.sMB083);
		        	invalid.items[0].focus();
		     	} else {
		      		//this.mask();
		      		var fields = this.getForm().getFields();
		      		Ext.each(fields.items, function(item) {
		       			if(Ext.isDefined(item.holdable) ) {
		         			if (item.holdable == 'hold') {
		         				item.setReadOnly(true); 
		        			}
		       			} 
		       			if(item.isPopupField) {
		        			var popupFC = item.up('uniPopupField') ;       
		        			if(popupFC.holdable == 'hold') {
		         				popupFC.setReadOnly(true);
		        			}
		       			}
		      		})
		       	}
		    } else {
		    	//this.unmask();
		       	var fields = this.getForm().getFields();
		     	Ext.each(fields.items, function(item) {
		      		if(Ext.isDefined(item.holdable) ) {
		        		if (item.holdable == 'hold') {
		        			item.setReadOnly(false);
		       			}
		      		} 
		      		if(item.isPopupField) {
		       			var popupFC = item.up('uniPopupField') ; 
		       			if(popupFC.holdable == 'hold' ) {
		        			item.setReadOnly(false);
		      			}
		      		}
		     	})
		    }
		    return r;
		}
	});	//end panelSearch 

	
    /**
     * Master Grid 정의(Grid Panel)
     * @type 
     */
    
    
    var masterGrid = Unilite.createTreeGrid('gba010ukrvGrid', {
    	store: directMasterStore,
		columns:[
        	{
                xtype: 'treecolumn', //this is so we know which column will show the tree
                text: '분류',
                width:250,
                sortable: true,
                dataIndex: 'BUDG_NAME', editable: false 
	        },
        	{dataIndex: 'BUDG_CODE', text: '분류코드'	, width: 100},
        	{dataIndex: 'BUDG_NAME', text: '항목명'	, width: 150},
        	{dataIndex: 'ACCNT'						, width: 80,
        		allowBlank: false,
				editor: Unilite.popup('ACCNT_G',{
	 				textFieldName: 'ACCNT_NAME',
	 				DBtextFieldName: 'ACCNT_NAME',
			    	//extParam: {'ADD_QUERY': "BUDG_YN = 'Y' AND GROUP_YN = 'N' AND SLIP_SW = 'Y'"},
		  			autoPopup: true,
		 			listeners: {
		 				'onSelected': {
	                    	fn: function(records, type  ){
	                    		var grdRecord;
	                    		var selectedRecords = masterGrid.getSelectionModel().getSelection();
								if(selectedRecords && selectedRecords.length > 0 ) {
									grdRecord= selectedRecords[0];
								}		                    	
								grdRecord.set('ACCNT',records[0]['ACCNT_CODE']);
								grdRecord.set('ACCNT_NAME',records[0]['ACCNT_NAME']);
	                    	},
	                    scope: this
              	   		},
	                  	'onClear' : function(type)	{		                  		
	                  		var grdRecord;
	                    	var selectedRecords = masterGrid.getSelectionModel().getSelection();
							if(selectedRecords && selectedRecords.length > 0 ) {
								grdRecord= selectedRecords[0];
							}
							grdRecord.set('ACCNT','');
							grdRecord.set('ACCNT_NAME','');
	                  	}
					}
				})  
			},
        	{dataIndex: 'ACCNT_NAME'				, width: 150,
				editor: Unilite.popup('ACCNT_G',{
	 				textFieldName: 'ACCNT_NAME',
	 				DBtextFieldName: 'ACCNT_NAME',
			    	//extParam: {'ADD_QUERY': "BUDG_YN = 'Y' AND GROUP_YN = 'N' AND SLIP_SW = 'Y'"},  
		  			autoPopup: true,
		 			listeners: { 
		 				'onSelected': {
	                    	fn: function(records, type  ){
	                    		var grdRecord;
	                    		var selectedRecords = masterGrid.getSelectionModel().getSelection();
								if(selectedRecords && selectedRecords.length > 0 ) {
									grdRecord= selectedRecords[0];
								}		                    	
								grdRecord.set('ACCNT',records[0]['ACCNT_CODE']);
								grdRecord.set('ACCNT_NAME',records[0]['ACCNT_NAME']);
	                    	},
	                    scope: this
              	   		},
	                  	'onClear' : function(type)	{		                  		
	                  		var grdRecord;
	                    	var selectedRecords = masterGrid.getSelectionModel().getSelection();
							if(selectedRecords && selectedRecords.length > 0 ) {
								grdRecord= selectedRecords[0];
							}
							grdRecord.set('ACCNT','');
							grdRecord.set('ACCNT_NAME','');
	                  	}
					}
				})   
			},
        	{dataIndex: 'BUDG_TYPE'		, text:'예산구분'		, width: 100, allowBlank: false},
        	{dataIndex: 'ST_COST_RATE'	, text:'수주액비율'		, width: 100},
        	{dataIndex: 'USE_YN'		, text:'<t:message code="system.label.base.useyn" default="사용여부"/>'		, width: 80 , align:'center'},
        	{dataIndex: 'SORT_SEQ'		, text:'순서'			, width: 60 , align:'center'},
        	{dataIndex: 'REMARK'		, text:'<t:message code="system.label.base.remarks" default="비고"/>'			, width: 80, 	flex:1}
        ]
    });                                                           	
                                                                  	
  	Unilite.Main({                                                 
		items : [panelSearch, 	masterGrid],
		id  : 'gba010ukrvApp',
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['reset'],false);
			UniAppManager.setToolbarButtons(['newData'],true);
			this.onQueryButtonDown();
		},
		onQueryButtonDown : function() {
			if(panelSearch.setAllFieldsReadOnly(true) == false){
				return false;
			}
			directMasterStore.loadStoreRecords();
			UniAppManager.setToolbarButtons(['newData'/*, 'reset'*/],true);			
		},
		onSaveAndQueryButtonDown : function()	{
			this.onSaveDataButtonDown();
		},
		onNewDataButtonDown : function()	{
	        var selectNode = masterGrid.getSelectionModel().getLastSelected();
	        
	        if(Ext.isEmpty(selectNode)) {	 
				Unilite.messageBox('등록하실 분류의 상위 분류을 선택하세요.');
				return false;
			} else {
	            var r = {
					CODE_LEVEL	: Ext.isEmpty(selectNode.get('CODE_LEVEL')) ? 1 : parseInt(selectNode.get('CODE_LEVEL')) + 1,
					TREE_LEVEL	: Ext.isEmpty(selectNode.get('TREE_LEVEL')) ? 'rootData' : selectNode.get('BUDG_CODE'),
					ST_COST_RATE: Ext.isEmpty(selectNode.get('ST_COST_RATE')) ? 0 : selectNode.get('ST_COST_RATE'),
			        USE_YN		: 'Y',
			        SORT_SEQ	: 5
		        };
				masterGrid.createRow(r);
			}
		},
		
		onSaveDataButtonDown: function () {
			var masterGrid = Ext.getCmp('gba010ukrvGrid');
			directMasterStore.saveStore();				
		},
		onDeleteDataButtonDown : function()	{
			var record = masterGrid.getSelectionModel().getSelection();
			masterGrid.deleteSelectedRow();
		},
		onResetButtonDown:function() {
			var masterGrid = Ext.getCmp('gba010ukrvGrid');
			Ext.getCmp('searchForm').getForm().reset();
			masterGrid.reset();
			directMasterStore.clearData();
			UniAppManager.setToolbarButtons(['save','prev', 'next'],false);
			this.fnInitBinding();
		}

	});

}; 


</script>
