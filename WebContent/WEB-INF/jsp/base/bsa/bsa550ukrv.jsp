<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bsa550ukrv" >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
</t:appConfig>
<script type="text/javascript">
	
function appMain() {
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'bsa550ukrvService.selectList3',
//			update: 'bsa550ukrvService.updateDetail',
			create: 'bsa550ukrvService.insertDetail',
			destroy: 'bsa550ukrvService.deleteDetail',
			syncAll: 'bsa550ukrvService.saveAll'
		}
	});	
	

	Unilite.defineModel('bsa550ukrvUserModel', {
	
		fields: [{name: 'USER_ID'       		, text: '사용자ID',			type: 'string'	},
				 {name: 'USER_NAME'     		, text: '사용자명',			type: 'string'	},
				 {name: 'DIV_CODE'      		, text: '사업장코드',			type: 'string'	},
				 {name: 'DIV_NAME'	    		, text: '<t:message code="system.label.base.division" default="사업장"/>',				type: 'string'	}
				 
		]
	});
	
	var directGroupStore = Unilite.createStore('bsa550ukrvUserStore', { 
		model: 'bsa550ukrvUserModel',
		autoLoad: false,
		uniOpt: {
	    	isMaster: true,			// 상위 버튼 연결 
	    	editable: false,			// 수정 모드 사용 
	    	deletable: false,			// 삭제 가능 여부 
	        useNavi: false			// prev | next 버튼 사용
	    },
		proxy: {
			type: 'direct',
			api: {
				read: 'bsa550ukrvService.selectList'				
			}
		},
		loadStoreRecords: function() {
			var param= panelSearch.getValues();			
			console.log(param);
			this.load({
				params : param
			});
		}
		
	});
	
	
	Unilite.defineModel('bsa550ukrvGrid1Model', {
	
		fields: [{name: 'DIV_CODE'    		, text: '사업장코드',		type: 'string'	},
				 {name: 'DIV_NAME'    		, text: '<t:message code="system.label.base.division" default="사업장"/>',			type: 'string'	}
				 
		]
	});			  
	
	var directMasterStore = Unilite.createStore('bsa550ukrvGrid1Store', { 
		model: 'bsa550ukrvGrid1Model',
		autoLoad: false,
		uniOpt: {
	    	isMaster: true,			// 상위 버튼 연결 
	    	editable: false,			// 수정 모드 사용 
	    	deletable: false,			// 삭제 가능 여부 
	        useNavi: false			// prev | next 버튼 사용
	    },
		proxy: {
			type: 'direct',
			api: {
				read: 	 'bsa550ukrvService.selectList2'
				
			}
		}
		,loadStoreRecords: function() {
			var param= panelSearch.getValues();
			console.log(param);
			this.load({
				params : param
			});
		}
		
	});
		
	
	Unilite.defineModel('bsa550ukrvGrid2Model', {		
		
		fields: [{name: 'COMP_CODE'		    		, text: '<t:message code="system.label.base.companycode" default="법인코드"/>',			type: 'string'	},
				 {name: 'USER_ID'		    		, text: 'USER_ID',			type: 'string'	},
				 {name: 'DIV_CODE'		    		, text: '사업장코드',			type: 'string'	},
				 {name: 'DIV_NAME'		    		, text: '<t:message code="system.label.base.division" default="사업장"/>',				type: 'string'	},
				 {name: 'AUTHORITY_YN'	    		, text: 'AUTHORITY_YN',		type: 'string'	},
				 {name: 'INSERT_DB_USER'    		, text: 'INSERT_DB_USER',	type: 'string'	},
				 {name: 'INSERT_DB_TIME'    		, text: 'INSERT_DB_TIME',	type: 'string'	}				 				 	
		]
	});	
	var programStore = Unilite.createStore('bsa550ukrvGrid2Store', { 
		model: 'bsa550ukrvGrid2Model',
		autoLoad: false,
		uniOpt: {
	    	isMaster: true,			// 상위 버튼 연결 
	    	editable: false,			// 수정 모드 사용 
	    	deletable: false,			// 삭제 가능 여부 
	        useNavi: false			// prev | next 버튼 사용
	    },
		proxy: directProxy,
		loadStoreRecords: function() {
			var param= panelSearch.getValues();			
			console.log(param);
			this.load({
				params : param
			});
		},saveStore: function()	{
			var paramMaster= panelSearch.getValues();
				var inValidRecs = this.getInvalidRecords();
				if(inValidRecs.length == 0 )	{
				config = {
					params: [paramMaster],
				success: function(batch, option) {
					divGrid2.getSelectionModel().deselectAll();
					divGrid1.getSelectionModel().deselectAll();
				 } 
				};
				this.syncAllDirect(config);
				}else {
					Unilite.messageBox(Msg.sMB083);
				}
		}  
	});
		
		
	var panelSearch = Unilite.createSearchPanel('bsa550ukrvSearchForm', {          
		title: '<t:message code="system.label.base.searchconditon" default="검색조건"/>',         
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
			title: '<t:message code="system.label.base.basisinfo2" default="기본정보"/>',   
			itemId: 'search_panel1',
			layout: {type: 'uniTable', columns: 1},
			items: [{ 
				fieldLabel: '<t:message code="system.label.base.division" default="사업장"/>',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},
				Unilite.popup('USER',{
				fieldLabel: '사용자',
				valueFieldName:'USER_ID',
			    textFieldName:'USER_NAME',
				textFieldWidth:170,
				validateBlank:false, 
				popupWidth: 710,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('USER_ID', panelSearch.getValue('USER_ID'));
							panelResult.setValue('USER_NAME', panelSearch.getValue('USER_NAME'));
                    	},
						scope: this
					},
					onClear: function(type)	{
								panelResult.setValue('USER_ID', '');
								panelResult.setValue('USER_NAME', '');
					}
				}
			}),
			{
				fieldLabel:'그리드1의 USER_ID',
				name:'USER_ID_G1',
				xtype: 'uniTextfield',
				hidden:true
			},{
				fieldLabel:'그리드1의 DIV_CODE',
				name:'DIV_CODE_G1',
				xtype: 'uniTextfield',
				hidden:true
			}]
		}]
	});
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 5},
		padding:'1 1 1 1',
		border:true,
		items: [{ 
				fieldLabel: '<t:message code="system.label.base.division" default="사업장"/>',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('DIV_CODE', newValue);
					}
				}
			},
				Unilite.popup('USER',{
				fieldLabel: '사용자',
				valueFieldName:'USER_ID',
			    textFieldName:'USER_NAME',
				textFieldWidth:170,
				validateBlank:false, 
				popupWidth: 710,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('USER_ID', panelResult.getValue('USER_ID'));
							panelSearch.setValue('USER_NAME', panelResult.getValue('USER_NAME'));
                    	},
						scope: this
					},
					onClear: function(type)	{
								panelSearch.setValue('USER_ID', '');
								panelSearch.setValue('USER_NAME', '');
					}
				}
			})]
    });		// end of var panelResult = Unilite.createSearchForm('resultForm',{
		
   		
		
	// create the Grid			
	var userGrid = Unilite.createGrid('bsa550ukrvuserGrid', {
		region: 'west',
		store: directGroupStore,
		title: '사용자',
		uniOpt: {
//	    	onLoadSelectFirst: false,
        	expandLastColumn: false,
			useMultipleSorting: true,
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: true
	    },
	    selModel:'rowmodel',
		columns: [{dataIndex: 'USER_ID'       		,		width: 150},
				  {dataIndex: 'USER_NAME'     		,		width: 110},
				  {dataIndex: 'DIV_CODE'      		,		width: 110},
				  {dataIndex: 'DIV_NAME'	    	,		minWidth: 120, flex: 1}
				],
		listeners: {
			selectionchange : function(grid, selected, eOpts) {
				if(selected.length > 0) {
    				var record = selected[0];
                    panelSearch.setValue('USER_ID_G1',record.get('USER_ID'));
                    panelSearch.setValue('DIV_CODE_G1',record.get('DIV_CODE'));
                    directMasterStore.loadStoreRecords();
                    programStore.loadStoreRecords();
				}
            }
		}
		
	});
	
	
	var divGrid1 = Unilite.createGrid('bsa550ukrvdivGrid1', {
		region: 'north',
		store: directMasterStore,
		title: '<t:message code="system.label.base.division" default="사업장"/>',
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: true, toggleOnClick: false  }), 
		uniOpt: {
	    	onLoadSelectFirst: false,
        	expandLastColumn: true,
			useMultipleSorting: true,
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: true
	    },
		columns: [{dataIndex: 'DIV_CODE'    		,		width: 120},
				  {dataIndex: 'DIV_NAME'    		,		width: 166}
				]
		
	});
		
		
		
	var divGrid2 =  Unilite.createGrid('bsa550ukrvDetailSystemGrid', {
			region: 'south',
			store: programStore,
			title: '등록된 사업장',
			uniOpt: {
	        	onLoadSelectFirst: false,
	        	expandLastColumn: true,
				useMultipleSorting: true,
	    		useGroupSummary: false,
	    		useLiveSearch: true,
				useContextMenu: true
	        },
	        selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: true, toggleOnClick: false  }), 
			columns: [{dataIndex: 'COMP_CODE'		    	,		width: 66, hidden: true},
					  {dataIndex: 'USER_ID'		    		,		width: 66, hidden: true},
					  {dataIndex: 'DIV_CODE'		    	,		width: 120},
					  {dataIndex: 'DIV_NAME'		    	,		width: 166},
					  {dataIndex: 'AUTHORITY_YN'	    	,		width: 66, hidden: true},
					  {dataIndex: 'INSERT_DB_USER'    		,		width: 66, hidden: true},
					  {dataIndex: 'INSERT_DB_TIME'    		,		width: 66, hidden: true}				  	
			]
		});

	var btnArea = { 
		region: 'center',
		margin: '0 0 2 0',
		xtype: 'container',
		id: 'bsa550ukrvBtn',
		height: 30,
		layout: {
	        type: 'hbox',
	         align: 'center',
	         pack: 'center'
	       },
		items: [{
			text: '▽ 추가',
			margin: '5 30 5 10',
			xtype: 'button',
			handler: function() {					        
		       var records, data = new Object();
		       if (divGrid1.getSelectedRecords()) {		        	
		           records = divGrid1.getSelectedRecords();
		           console.log("records: ", records);
		           data.records = [];
		           for (i = 0, len = records.length; i < len; i++) {
//		                data.records.push(records[i].copy());
			           	var record = records[i].copy();
		            	record.phantom = true;	
		            	data.records.push(record);	
		            }
		      
			        divGrid2.getStore().insert(0, data.records);
			        divGrid2.getSelectionModel().select(data.records);
			        divGrid1.getStore().remove(records);
			    }
					  
			}
		}, {
			text: '△ 제거',
			xtype: 'button',
			margin: '5 30 5 10',
			handler: function() {				        
		       var records, data = new Object();
		       if (divGrid2.getSelectedRecords()) {
		           records = divGrid2.getSelectedRecords();
		           data.records = [];
		           for (i = 0, len = records.length; i < len; i++) {
		                data.records.push(records[i].copy());
		           }
		      
			        divGrid1.getStore().insert(0, data.records);										      
			        divGrid1.getSelectionModel().select(data.records);
			        divGrid2.getStore().remove(records);
		    	}
		    	
			}
		}]					
	}
    Unilite.Main({
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[{
				region: 'center',
				layout: {type: 'vbox', align: 'stretch'},
				border: false,
				flex: 2,
				items: [
					divGrid1, btnArea, divGrid2
				]}
				,userGrid, panelResult
			]}		
			,panelSearch
		],
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons(['reset'],true);
		}
		, onQueryButtonDown: function() {
			directGroupStore.loadStoreRecords();
			panelSearch.setValue('USER_ID_G1', '');
			panelSearch.setValue('DIV_CODE_G1', '');
			divGrid2.reset();
			divGrid1.reset();
			beforeRowIndex = -1;
		}

		, onSaveDataButtonDown: function (config) {										
			 if(programStore.isDirty())  	{
				programStore.saveStore();						
			 }
		}
		,onResetButtonDown: function() {
				userGrid.reset();
				divGrid2.reset();
				divGrid1.reset();
				Ext.getCmp('bsa550ukrvSearchForm').reset();
				UniAppManager.setToolbarButtons(['save'],false);
			}
	});
		
		

		Unilite.createValidator('bsa550ukrvValidator', {
		store: programStore,
		grid: divGrid2,
		forms: {'formA: ': bsa550ukrvSearchForm},
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type': type, 'fieldName': fieldName, 'newValue': newValue, 'oldValue': oldValue, 'record': record});
			var rv = true;
			if (fieldName == "USER_ID" )	{		
					if(newValue == '')	{
						rv = Msg.sMB083;
					}
			}
			return rv;
		}
		});
		

};	// appMain
</script>