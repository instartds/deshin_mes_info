<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="bdc110ukrv"  >  
	<t:ExtComboStore comboType="AU" comboCode="B010" /><!-- 사용여부 -->    
	<t:ExtComboStore items="${BDC100ukv_DOC_LEVEL1}" storeId="docLeve1Store" />
	<t:ExtComboStore items="${BDC100ukv_DOC_LEVEL2}" storeId="docLeve2Store" />
	<t:ExtComboStore items="${BDC100ukv_DOC_LEVEL3}" storeId="docLeve3Store" />
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >
function appMain() {

	/**
	 * Model 정의 
	 * @type 
	 */
	 
	Unilite.defineModel('bdc110ukrvModel', {
		// pkGen : user, system(default)
	    fields: [{name: 'parentId' 		,text:'상위소속' 	,type:'string'	,editable:false},
	    		 {name: 'LVL' 			,text:'LVL' 		,type:'string'		},
	    		 {name: 'LEVEL1' 		,text:'<t:message code="system.label.base.majorgroup" default="대분류"/>' 		,type:'string'		},
	    		 {name: 'LEVEL2' 		,text:'<t:message code="system.label.base.middlegroup" default="중분류"/>' 		,type:'string'		},
	    		 {name: 'LEVEL3' 		,text:'<t:message code="system.label.base.minorgroup" default="소분류"/>' 		,type:'string'		},
	    		 {name: 'LEVEL_NAME' 	,text:'항목명' 		,type:'string'	, maxLength:20},
	    		 {name: 'LEVEL_CODE' 	,text:'분류코드' 	,type:'string'	,allowBlank:false, isPk:true, maxLength:5},
	    		 {name: 'USE_YN' 		,text:'<t:message code="system.label.base.useyn" default="사용여부"/>' 	,type:'string',  comboType:'AU', comboCode:'B010'		},
	    		 {name: 'REMARK' 		,text:'<t:message code="system.label.base.remarks" default="비고"/>' 		,type:'string'		}
		]
	});
	
  
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createTreeStore('bdc110ukrvMasterStore',{
			model: 'bdc110ukrvModel',
            autoLoad: false,
            folderSort: true,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:true,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            
            proxy: {
                type: 'direct',
                api: {
	                read : 'bdc110ukrvService.selectList'
	                ,update : 'bdc110ukrvService.update'
					,create : 'bdc110ukrvService.insert'
					,destroy: 'bdc110ukrvService.delete'
					,syncAll: 'bdc110ukrvService.syncAll'
                	
                }
            }
            
			// Store 관련 BL 로직
            // 검색 조건을 통해 DB에서 데이타 읽어 오기 
			,loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();			
				console.log( param );
				this.load({
					params : param
				});
				
			}
			// 수정/추가/삭제된 내용 DB에 적용 하기 
			,saveStore : function()	{	
				var me = this;
				var inValidRecs = this.getInvalidRecords();
				console.log("inValidRecords : ", inValidRecs);
				var treeValidate = false;
				if(inValidRecs.length == 0 )	{
					treeValidate = true;
				}else if(inValidRecs.length == 1 && inValidRecs[0].data['id'] == 'rootData')	{  // 임의로 생성된 rootData의 경우 LEVEL_CODE가 없으므로 validation 에서 제외시킨다.
					treeValidate = true;
				}
				if(treeValidate)	{
					var toCreate = me.getNewRecords();
            		var toUpdate = me.getUpdatedRecords();
            		
            		var toDelete = me.getRemovedRecords();
            		var list = [].concat( toUpdate, toCreate   );
					
					console.log("list:", list);
					Ext.each(list, function(node, index) {
						var pid = node.get('parentId');
						console.log("node.getDepth() ", node.getDepth());
						console.log("node :  ", node);
						var depth = node.getDepth();
						
							if(depth=='4')	{
								node.set('parentId',  node.get('LEVEL2'));
								node.set('LEVEL1',  node.parentNode.get('LEVEL1'));
								node.set('LEVEL2',  node.parentNode.get('LEVEL2'));
								node.set('LEVEL3',  node.get('LEVEL_CODE'));
							} else if(depth=='3') 	{
								node.set('parentId',  node.get('LEVEL1'));
								node.set('LEVEL1',  node.parentNode.get('LEVEL1'));
								node.set('LEVEL2',  node.get('LEVEL_CODE'));
								node.set('LEVEL3',  '*');
							} else if(depth=='2')	{
								node.set('parentId', 'rootData');
								node.set('LEVEL1',  node.get('LEVEL_CODE'));
								node.set('LEVEL2',  '*');
								node.set('LEVEL3',  '*');
							}
						
						//node.set('parentId',  node.parentNode.get('PGM_SEQ')+node.parentNode.get('PGM_ID'));
					});
					
					
					this.syncAll({success : function()	{
										UniAppManager.app.onQueryButtonDown();
									}
								  });
					//UniAppManager.setToolbarButtons('save', false);
				}else {
					Unilite.messageBox(Msg.sMB083);
				}
			}
            
		});
	


	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
    
	var panelSearch = Unilite.createSearchForm('searchForm',{		
		region:'west',	
		title: '<t:message code="system.label.base.searchconditon" default="검색조건"/>',
		split:true,
        margin: '0 0 0 0',
        padding:0,
	    border: true,
		collapsible: false,	
		autoScroll:true,
		collapseDirection: 'left',
		width:250,
		tools: [{
			region:'west',
			type: 'left', 	
			itemId:'left',
			tooltip: 'Hide',
			handler: function(event, toolEl, panelHeader) {
						panelSearch.collapse(); 
				    }
			}
		],
		items:[{
		xtype:'container',
		defaults:{
			collapsible:true,
			titleCollapse:true,
			hideCollapseTool : true,
			bodyStyle:{'border-width': '0px',
						'spacing-bottom':'3px'
			},
			header:{ xtype:'header',
					 style:{
								'background-color': '#D9E7F8',
								'background-image':'none',
								'color': '#333333',
								'font-weight': 'normal',
								'border-width': '0px',
								'spacing':'5px'
							}
					}
		},		
		layout: {type: 'vbox', align:'stretch'},
	    defaultType: 'panel',
		items: [{	
			title: '<t:message code="system.label.base.basisinfo2" default="기본정보"/>', 	
			id: 'search_panel1',
   			itemId: 'search_panel1',
            layout : {type : 'uniTable' , columns:1 },
	        items: [{
	        	fieldLabel: '<t:message code="system.label.base.majorgroup" default="대분류"/>',
	        	name: 'LEVEL1',
	        	xtype: 'uniCombobox',
	        	store: Ext.data.StoreManager.lookup('docLeve1Store'),
	        	child: 'LEVEL2',
	        	labelWidth:68
	        },{
	        	fieldLabel: '<t:message code="system.label.base.middlegroup" default="중분류"/>',
	        	name: 'LEVEL2',
	        	xtype: 'uniCombobox',
	        	store: Ext.data.StoreManager.lookup('docLeve2Store'),
	        	child: 'LEVEL3',
	        	labelWidth:68
	        },{
	        	fieldLabel: '<t:message code="system.label.base.minorgroup" default="소분류"/>',
	        	name: 'LEVEL3',
	        	xtype: 'uniCombobox',
	        	store: Ext.data.StoreManager.lookup('docLeve3Store'),
	        	labelWidth:68
	        },{
	        	fieldLabel: '<t:message code="system.label.base.photoflag" default="사진유무"/>',
	        	name: 'USE_YN',
	        	xtype: 'uniCombobox',
	        	comboType:'AU',
	        	comboCode:'B010',
	        	labelWidth:68
	        }]	
		}]
		}]
	});	//end panelSearch 
	
    /**
     * Master Grid 정의(Grid Panel)
     * @type 
     */

    var masterGrid = Unilite.createTreeGrid('bdc110ukrvGrid', {
    	region: 'center',
    	store: directMasterStore,
    	maxDepth : 3,
		columns:[{
		                xtype: 'treecolumn', //this is so we know which column will show the tree
		                text: '분류',
		                width:250,
		                sortable: true,
		                dataIndex: 'LEVEL_NAME', editable: false 
		         },				 
				{dataIndex:'LEVEL_CODE'	,width:130 },
				{dataIndex:'LEVEL_NAME'	,width:530	},
				{dataIndex:'USE_YN'		,width:70},
				{dataIndex:'REMARK'		,flex:1}
				
				
          ] 
         ,listeners : {
         		beforeedit  : function( editor, e, eOpts ) {
								if(e.record.data.parentId =='root')	{									
									return false;
								}
         					}
         
         }
          
    });
    
  	Unilite.Main({
		items:[ {
				  layout:'fit',
				  flex:1,
				  border:false,
				  items:[{
				  		layout:'border',
				  		border:false,
				  		items:[
				 		 masterGrid
						,panelSearch
						]}
					]
				}
		], 
		id  : 'bdc110ukrvApp',
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['reset','newData'],true);
			
		},
		onQueryButtonDown : function() {	
			directMasterStore.loadStoreRecords();		
		},
		onSaveAndQueryButtonDown : function()	{
			this.onSaveDataButtonDown();
			//this.onQueryButtonDown();
		},
		onNewDataButtonDown : function()	{	         
			var selectNode = masterGrid.getSelectionModel().getLastSelected();			
	        var newRecord = masterGrid.createRow( );
	        
	        if(newRecord)	{
				newRecord.set('LEVEL1',selectNode.get('LEVEL1'));
				newRecord.set('LEVEL2',selectNode.get('LEVEL2'));
				newRecord.set('LEVEL3',selectNode.get('LEVEL3'));
	        	newRecord.set('USE_YB','Y');
	        	
	        }
		},
		
		onSaveDataButtonDown: function () {
			var masterGrid = Ext.getCmp('bdc110ukrvGrid');
			directMasterStore.saveStore();				
		},
		onDeleteDataButtonDown : function()	{
			var delRecord = masterGrid.getSelectionModel().getLastSelected();
			
			if(delRecord.childNodes.length > 0)	{
				var msg ='';
				if(delRecord.getDepth() == '3')	msg=Msg.sMB155; //소분류부터 삭제하십시오.
				else if(delRecord.getDepth() == '2')	msg=Msg.sMB156; //중분류부터 삭제하십시오.
				Unilite.messageBox(Msg);
				return;
			}
			
			if(confirm(Msg.sMB062))	{
				masterGrid.deleteSelectedRow();	
			}
		},
		onResetButtonDown:function() {
			var masterGrid = Ext.getCmp('bdc110ukrvGrid');
			Ext.getCmp('searchForm').getForm().reset();
			masterGrid.reset();
			UniAppManager.setToolbarButtons(['save','prev', 'next'],false);
		}

	});
	
	
	
}; 

</script>
