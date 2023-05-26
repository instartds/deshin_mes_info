<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bpr620ukrv" >
	<t:ExtComboStore comboType="BOR120"  /> 					<!-- 사업장 --> 
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >
	function appMain(){
		Unilite.defineModel('Bpr620ukrvModel', {
			 fields: [
			 	{name: 'parentId' 		    ,text:'상위소속' 			,type:'string'	 ,editable:false},
			 	{name:'DIV_CODE',		text:'<t:message code="system.label.base.division" default="사업장"/>',			type:'string'},
			 	{name:'PROD_ITEM_CODE',	text:'모품목코드',		type:'string'},
			 	{name:'ITEM_CODE',		text:'<t:message code="system.label.base.itemcode" default="품목코드"/>',		type:'string'},
			 	{name:'ITEM_NAME',		text:'<t:message code="system.label.base.itemname" default="품목명"/>',			type:'string'},
			 	{name:'SPEC',			text:'<t:message code="system.label.base.spec" default="규격"/>',			type:'string'},
			 	{name:'STOCK_UNIT',		text:'단위',			type:'string'},
			 	{name:'UNIT_Q',			text:'원단위량',		type: 'float' , defaultValue:1, decimalPrecision: 6, format:'0,000.000000'},
			 	{name:'PROD_UNIT_Q',	text:'모품목기준수'	,	type: 'number', defaultValue:1},
			 	{name:'CODE_NAME',		text:'계정',			type:'string'},
			 	{name:'SUPP_CODE',		text:'<t:message code="system.label.base.procurementclassification" default="조달구분"/>',		type:'string'},
			 	{name:'MAN_HOUR',		text:'표준공수',		type:'float', decimalPrecision: 2, format:'0,000.00'},
			 	{name:'ACC_MANHOUR',	text:'누적공수',		type:'float', decimalPrecision: 2, format:'0,000.00'},
			 	{name:'SEQ',			text:'<t:message code="system.label.base.seq" default="순번"/>',			type:'uniQty'},
			 	{name:'INTENS_Q',		text:'순번1',			type:'uniQty'},
			 	{name:'ITEM_ACCOUNT',	text:'',				type:'string'},
			 	{name: 'LVL',			text:'레벨',			type:'int', editable:false}
			
			 ]
		});
		var directProxy= Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
				  api: {
				    	read   : 'bpr620ukrvService.selectList',
				    	update : 'bpr620ukrvService.updateCodes',
				    	syncAll: 'bpr620ukrvService.saveAll'
				  	}
			});
		 var directStore=Unilite.createTreeStore('bpr620ukrvStore', {
		 		model:'Bpr620ukrvModel',
		 		uniOpt :{
		           	isMaster: true,			// 상위 버튼 연결 
		           	editable: true,			// 수정 모드 사용 
		           	deletable:false,			// 삭제 가능 여부 
		            useNavi: false			// prev | next 버튼 사용
				},
				autoLoad: false,
       			folderSort: true,
       			proxy:directProxy,
				loadStoreRecords: function() {
					var searchParam= Ext.getCmp('searchForm').getValues();
					var param= {};		
					var params = Ext.merge(searchParam, param);
					console.log( param );
					this.load({
						params : params
					});
				},
				 listeners: {
		            'load' : function( store, records, successful, operation, node, eOpts ) {
		                if(records) {
		                    var root = this.getRoot();
		                    if(root) {
		                        root.expandChildren();
		                            node.cascadeBy(function(n){
		                            if(n.hasChildNodes())   {
		                                n.expand();
		                            }
		                            n.set("LVL", n.getDepth());
		                        })
		                        store.commitChanges();
		                    }
		                }
		            },
		            'update': function( store,  record  ) {
		            	record.set("LVL", record.getDepth());
                        
		            }
		        },
		        saveStore:function(){
		        	var me = this;
		        	var toUpdate = me.getUpdatedRecords();
		        	var inValidRecs = this.getInvalidRecords();
		        	console.log("inValidRecords : ", inValidRecs);
		        	if(inValidRecs.length == 0 )	{
		        		var config = {	
							success : function()	{
								UniAppManager.app.onQueryButtonDown();
							}
						  }
						EXTVERSION == '4.2.2' ?  this.syncAll(config):this.syncAllDirect(config);
		        	
		        	}else{
		        		masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
		        	}
		        }
		 });
		 var masterGrid = Unilite.createTreeGrid('bpr620ukrvGrid', {
		 	layout: 'fit',
		 	store: directStore,
		 	 columns: [ 
		 	 	{
	                xtype: 'treecolumn', //this is so we know which column will show the tree
	                text: '<t:message code="system.label.base.itemcode" default="품목코드"/>',
	                width:250,
	                sortable: false,
	                dataIndex: 'ITEM_CODE', editable: false 
			    }
			    ,{dataIndex: 'LVL',			width: 40, align: 'center'}
			    ,{dataIndex:'ITEM_NAME',	width:200, editable:false}	
			    ,{dataIndex:'SPEC',			width:180, editable:false}
			    ,{dataIndex:'STOCK_UNIT',	width:50, align: 'center', editable:false}
			    ,{dataIndex:'UNIT_Q',		width:80, editable:false}
			    ,{dataIndex:'PROD_UNIT_Q',	width:100, editable:false}
			    ,{dataIndex:'CODE_NAME',	width:80, align: 'center', editable:false}
			    ,{dataIndex:'SUPP_CODE',	width:80, align: 'center', editable:false}
			    ,{dataIndex:'MAN_HOUR',		width:80, editable:true}
			    ,{dataIndex:'ACC_MANHOUR',	width:80, editable:false}
		 	 ],
		 	 listeners:{
		 	 	beforeedit  : function( editor, e, eOpts ) {
								
					if(e.record.data.ITEM_ACCOUNT != '10' && e.record.data.ITEM_ACCOUNT != '20'){
						if(UniUtils.indexOf(e.field, ['MAN_HOUR'])) return false;
					}
				},
				cellclick : function( grid, td, cellIndex, record, tr, rowIndex, e, eOpts )	{
					if(grid.ownerCt.getColumns()[cellIndex].dataIndex == "LVL")	{
						var currentLevel = record.get('LVL');
						var root = grid.getStore().getRoot();
						root.cascadeBy(function(n){
		                    if(n.hasChildNodes())   {
		                    	if(n.getDepth() == currentLevel)	{
		                    		if(n.isExpanded())	{
		                    			n.collapse()
		                    		}else {
		                    			n.expand();
		                    		}
		                    	}
		                    	
		                    }
						});
					}
				} 
			
		 	 }
		 });
		
		var panelSearch=Unilite.createSearchForm('searchForm',{
			layout : {type : 'uniTable', columns : 2},
			items:[{
					fieldLabel: '<t:message code="system.label.base.division" default="사업장"/>',
	        		name: 'DIV_CODE',
	        		value : UserInfo.divCode,
	        		xtype: 'uniCombobox',
	        		comboType: 'BOR120',
	        		allowBlank: false
	        	},
	        		Unilite.popup('DIV_PUMOK',{ 
		    			allowBlank: false,
			        	fieldLabel: '품목',	
			        	valueFieldName: 'ITEM_CODE', 
						textFieldName: 'ITEM_NAME', 
						colspan: 2
				 })
			]
		});
		Unilite.Main({
			items:[panelSearch,masterGrid],
	      	id: 'bpr620ukrvApp',
	      	fnInitBinding: function() {
				panelSearch.setValue('DIV_CODE',UserInfo.divCode);
				UniAppManager.setToolbarButtons('detail',false);
				UniAppManager.setToolbarButtons(['newData','reset'],true);
			},
			onSaveDataButtonDown: function () {
				var masterGrid = Ext.getCmp('bpr620ukrvGrid');
				directStore.saveStore();
			},
			onQueryButtonDown: function()	{
				if(!panelSearch.getInvalidMessage()){
					return false;		
				};
				masterGrid.getStore().loadStoreRecords();
			},
			onNewDataButtonDown : function()	{        
	        	/* var r = {
					
					DIV_CODE: panelSearch.getValue('DIV_CODE')
		        };	        
				masterGrid.createRow(r);*/
			},
			onResetButtonDown: function() {
				masterGrid.reset();
				panelSearch.clearForm();
				this.fnInitBinding();
			}
		});
	}
	
</script>