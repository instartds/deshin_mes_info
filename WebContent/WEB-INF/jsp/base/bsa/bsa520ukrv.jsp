<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bsa520ukrv" >
	<t:ExtComboStore comboType="AU" comboCode="B007" /><!-- 업무구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B003" /><!-- 프로그램사용 권한 -->
	<t:ExtComboStore comboType="AU" comboCode="B006" /><!-- 파일저장 사용권한 -->
	<t:ExtComboStore comboType="AU" comboCode="BS06" /><!-- 권한범위-사업장 -->
</t:appConfig>
<script type="text/javascript">
	
function appMain() {
	
	var beforeRowIndex;
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'bsa520ukrvService.selectProgramList',
			update: 'bsa520ukrvService.updateDetail',
			create: 'bsa520ukrvService.insertDetail',
			destroy: 'bsa520ukrvService.deleteDetail',
			syncAll: 'bsa520ukrvService.saveAll'
		}
	});	 

	Unilite.defineModel('bsa520ukrvGroupModel', {
	
		fields: [{name: 'GROUP_CODE'    		, text: '<t:message code="system.label.base.groupcode" default="권한그룹코드"/>',			type: 'string'	},
				 {name: 'GROUP_NAME'    		, text: '<t:message code="system.label.base.groupname" default="권한그룹명"/>',			type: 'string'	},
				 {name: 'PGM_ID'        		, text: 'PGM_ID',			type: 'string'	},
				 {name: 'PGM_NAME'      		, text: '<t:message code="system.label.base.programname" default="프로그램명"/>',			type: 'string'	},
				 {name: 'PGM_LEVEL'     		, text: '<t:message code="system.label.base.datamodify" default="자료수정"/>',			type: 'string'	},
				 {name: 'PGM_LEVEL2'    		, text: '<t:message code="system.label.base.filesave" default="파일저장"/>',			type: 'string'	},
				 {name: 'AUTHO_USER'    		, text: '<t:message code="system.label.base.authouser" default="자료권한"/>',			type: 'string'	},
				 {name: 'AUTHO_TYPE'    		, text: '<t:message code="system.label.base.authotype" default="권한형태"/>',			type: 'string'	},
				 {name: 'AUTHO_PGM'     		, text: '<t:message code="system.label.base.authopgm" default="권한정의"/>',			type: 'string'	},
				 {name: 'REF_CODE'      		, text: '<t:message code="system.label.base.refcode" default="참조코드"/>',			type: 'string'	},
				 {name: 'AUTHO_ID'      		, text: '<t:message code="system.label.base.authotypenumb" default="권한형태(번호)"/>',		type: 'string'	},
				 {name: 'COMP_CODE'     		, text: '<t:message code="system.label.base.companycode" default="법인코드"/>',			type: 'string'	,defaultValue : UserInfo.compCode},
				 {name: 'INSERT_DB_USER'		, text: '<t:message code="system.label.base.accntperson" default="입력자"/>',				type: 'string'	,defaultValue : UserInfo.userID},
				 {name: 'UPDATE_DB_USER'		, text: '<t:message code="system.label.base.updateuser" default="수정자"/>',			 	type: 'string'	,defaultValue : UserInfo.userID}
		]
	});
	
	var directGroupStore = Unilite.createStore('bsa520ukrvGroupStore', { 
		model: 'bsa520ukrvGroupModel',
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
				read: 	 'bsa520ukrvService.selectMaster'
				
			}
		},
		loadStoreRecords: function() {
			var param= panelSearch.getValues();			
			console.log(param);
			this.load({
				params : param
			});
		}
		/*,listeners: {
           	load: function(store, records, successful, eOpts) {
           		if(!Ext.isEmpty(records)){
           			groupGrid.getSelectionModel().select( 0 );
           			//directMasterStore.loadStoreRecords(records[0]);
           		}else{
           			detailStore.removeAll('clear');           		
           		}
           	}
		}*/
	});
	
	
	Unilite.defineModel('bsa520ukrvMasterModel', {
	
		fields: [{name: 'GROUP_CODE'    		, text: 'GROUP_CODE',		type: 'string'	},
				 {name: 'PGM_ID'        		, text: 'PGM_ID',			type: 'string'	},
				 {name: 'PGM_NAME'      		, text: '<t:message code="system.label.base.programname" default="프로그램명"/>',			type: 'string'	},
				 {name: 'PGM_LEVEL'     		, text: '<t:message code="system.label.base.datamodify" default="자료수정"/>',			type: 'string'	},
				 {name: 'PGM_LEVEL2'    		, text: '<t:message code="system.label.base.filesave" default="파일저장"/>',			type: 'string'	},
				 {name: 'AUTHO_USER'    		, text: '<t:message code="system.label.base.authouser" default="자료권한"/>',			type: 'string'	},
				 {name: 'AUTHO_TYPE'    		, text: '<t:message code="system.label.base.authotype" default="권한형태"/>',			type: 'string'	},
				 {name: 'AUTHO_PGM'     		, text: '<t:message code="system.label.base.authopgm" default="권한정의"/>',			type: 'string'	},
				 {name: 'REF_CODE'      		, text: '<t:message code="system.label.base.refcode" default="참조코드"/>',			type: 'string'	},
				 {name: 'AUTHO_ID'      		, text: '<t:message code="system.label.base.authotypenumb" default="권한형태(번호)"/>',		type: 'string'	},
				 {name: 'COMP_CODE'     		, text: '<t:message code="system.label.base.companycode" default="법인코드"/>',			type: 'string'	,defaultValue : UserInfo.compCode},
				 {name: 'INSERT_DB_USER'		, text: '<t:message code="system.label.base.accntperson" default="입력자"/>',				type: 'string'	,defaultValue : UserInfo.userID},
				 {name: 'UPDATE_DB_USER'		, text: '<t:message code="system.label.base.updateuser" default="수정자"/>',			 	type: 'string'	,defaultValue : UserInfo.userID}
		]
	});
	
	var directMasterStore = Unilite.createStore('bsa520ukrvMasterStore', { 
		model: 'bsa520ukrvMasterModel',
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
				read: 	 'bsa520ukrvService.selectList'
				
			}
		}
		,loadStoreRecords : function(record){
				var gridParam = record.data; 
				var param  = Ext.getCmp('bsa520ukrvSearchForm').getValues();	
				var params = Ext.merge(gridParam , param);
				this.load({
					params : params
				});				
			},
		listeners: {
          	load: function(store, records, successful, eOpts) {
          		//if(successful)	{
	           		if(records[0] != null){
	           			if(!directGroupStore.isDirty() && !programStore.isDirty())	{
	           				//UniAppManager.setToolbarButtons('save', false);	
	           			}
		       		}
          		//}
           	}
		},
		saveStore : function()	{
					var inValidRecs = this.getInvalidRecords();
					if(inValidRecs.length == 0 )	{
						this.syncAllDirect({
							params:[panelSearch.getValues()],
							success : function()	{
								programGrid.getSelectionModel().deselectAll();
							}
						});				
					}else {
						Unilite.messageBox(Msg.sMB152);
						// 사용자ID를 선택해 주세요.
					}
			}
	});
		
	
	Unilite.defineModel('bsa520ukrvProgramModel', {		
		
		fields: [{name: 'GROUP_CODE'    		, text: 'GROUP_CODE',		type: 'string'	},
				 {name: 'PGM_ID'        		, text: 'PGM_ID',			type: 'string'	},
				 {name: 'PGM_NAME'      		, text: '<t:message code="system.label.base.programname" default="프로그램명"/>',			type: 'string'	},
				 {name: 'PGM_LEVEL'     		, text: '<t:message code="system.label.base.datamodify" default="자료수정"/>',			type: 'string'	, comboType:"AU", comboCode:"B003" , defaultValue : '1'},
				 {name: 'PGM_LEVEL2'    		, text: '<t:message code="system.label.base.filesave" default="파일저장"/>',			type: 'string'	, comboType:"AU", comboCode:"B006" , defaultValue : '1'},
				 {name: 'AUTHO_USER'    		, text: '<t:message code="system.label.base.authouser" default="자료권한"/>',			type: 'string'	, comboType:"AU", comboCode:"BS06"},
				 {name: 'AUTHO_TYPE'    		, text: '<t:message code="system.label.base.authotype" default="권한형태"/>',			type: 'string'	},
				 {name: 'AUTHO_PGM'     		, text: '<t:message code="system.label.base.authopgm" default="권한정의"/>',			type: 'string'	},
				 {name: 'REF_CODE'      		, text: '<t:message code="system.label.base.refcode" default="참조코드"/>',			type: 'string'	},
				 {name: 'AUTHO_ID'      		, text: '<t:message code="system.label.base.authotypenumb" default="권한형태(번호)"/>',		type: 'string'	},
				 {name: 'COMP_CODE'     		, text: '<t:message code="system.label.base.companycode" default="법인코드"/>',			type: 'string'	,defaultValue : UserInfo.compCode},
				 {name: 'INSERT_DB_USER'		, text: '<t:message code="system.label.base.accntperson" default="입력자"/>',				type: 'string'	,defaultValue : UserInfo.userID},
				 {name: 'UPDATE_DB_USER'		, text: '<t:message code="system.label.base.updateuser" default="수정자"/>',			 	type: 'string'	,defaultValue : UserInfo.userID}				 	
		]
	});
	
	var programStore = Unilite.createStore('bsa520ukrvProgramStore', { 
		model: 'bsa520ukrvProgramModel',
		autoLoad: false,
		uniOpt: {
	    	isMaster: true,			// 상위 버튼 연결 
	    	editable: true,			// 수정 모드 사용 
	    	deletable: false,			// 삭제 가능 여부 
	        useNavi: false			// prev | next 버튼 사용
	    },
		proxy: directProxy,
		 loadStoreRecords : function(record){
				var gridParam = record.data; 
				var param  = Ext.getCmp('bsa520ukrvSearchForm').getValues();	
				var params = Ext.merge(gridParam , param);
				this.load({
					params : params
				});				
			},
		
		saveStore: function(config) {	
			
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
        	var toUpdate = this.getUpdatedRecords();
        	var list = [].concat(toUpdate, toCreate);
        	console.log("toUpdate",toUpdate);

        	var rv = true;
       	
			if(inValidRecs.length == 0 )	{										
				config = {
					
					success: function(batch, option) {								
						panelSearch.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);			
					 } 
				};					
				this.syncAllDirect(config);
			}else {
				programGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});
		
		
	var panelSearch = Unilite.createSearchPanel('bsa520ukrvSearchForm', {          
		title: '<t:message code="system.label.base.searchconditon" default="검색조건"/>',         
		defaultType: 'uniSearchSubPanel',
		listeners: {
	        collapse: function () {
	        	panelResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
	        }
	    },
		defaults: {
			autoScroll:true
	  	},
		items: [{     
			title: '<t:message code="system.label.base.basisinfo2" default="기본정보"/>',   
			itemId: 'search_panel1',
			layout: {type: 'uniTable', columns: 1},
			items: [{
				fieldLabel: '<t:message code="system.label.base.businessclassification" default="업무구분"/>',
				name:'PGM_SEQ', 	
				xtype: 'uniCombobox', 
				comboType:'AU',
				comboCode:'B007',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('PGM_SEQ', newValue);
					}
				}
			}, {
				xtype: 'uniTextfield',
				fieldLabel: '<t:message code="system.label.base.programid" default="프로그램ID"/>',
				name:'PGM_ID',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('PGM_ID', newValue);
					}
				}
			}, {
				xtype: 'uniTextfield',
				fieldLabel: '<t:message code="system.label.base.programname" default="프로그램명"/>',
				name:'PGM_NAME',
				width: 325,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('PGM_NAME', newValue);
					}
				}
			}, {
				fieldLabel:'그리드1의 GROUP_CODE',
				name:'GROUP_CODE_P',
				xtype: 'uniTextfield',
				hidden:true
			}]
		}]
	});
		
   	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
				fieldLabel: '<t:message code="system.label.base.businessclassification" default="업무구분"/>',
				name:'PGM_SEQ', 	
				xtype: 'uniCombobox', 
				comboType:'AU',
				comboCode:'B007',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('PGM_SEQ', newValue);
					}
				}
			}, {
				xtype: 'uniTextfield',
				fieldLabel: '<t:message code="system.label.base.programid" default="프로그램ID"/>',
				name:'PGM_ID',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('PGM_ID', newValue);
					}
				}
			}, {
				xtype: 'uniTextfield',
				fieldLabel: '<t:message code="system.label.base.programname" default="프로그램명"/>',
				name:'PGM_NAME',
				width: 325,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('PGM_NAME', newValue);
					}
				}
			}, {
				fieldLabel:'그리드1의 GROUP_CODE',
				name:'GROUP_CODE_P',
				xtype: 'uniTextfield',
				hidden:true
			}]
   	});
		
	// create the Grid			
	var groupGrid = Unilite.createGrid('bsa520ukrvGroupGrid', {
		region: 'west',
		store: directGroupStore,
		title: '<t:message code="system.label.base.group" default="권한그룹"/>',
		selModel: 'rowmodel',
		uniOpt: {
	    	onLoadSelectFirst: false,
        	expandLastColumn: true,
			useMultipleSorting: true,
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: true
	    },
		columns: [{dataIndex: 'GROUP_NAME'    		,		width: 150	},
		
				  {dataIndex: 'GROUP_CODE'    		,		width: 150, hidden: true	}//임시헤더
			   /*,{dataIndex: 'PGM_ID'        		,		width: 100, hidden: true	},
				  {dataIndex: 'PGM_NAME'      		,		width: 150, hidden: true	},
				  {dataIndex: 'PGM_LEVEL'     		,		width: 100, hidden: true	},
				  {dataIndex: 'PGM_LEVEL2'    		,		width: 100, hidden: true	},
				  {dataIndex: 'AUTHO_USER'    		,		width: 100, hidden: true },
				  {dataIndex: 'AUTHO_TYPE'    		,		width: 66, hidden: true	},
				  {dataIndex: 'AUTHO_PGM'     		,		width: 66, hidden: true	},
				  {dataIndex: 'REF_CODE'      		,		width: 66, hidden: true	},
				  {dataIndex: 'AUTHO_ID'      		,		width: 66, hidden: true	},
				  {dataIndex: 'COMP_CODE'     		,		width: 66, hidden: true	},
				  {dataIndex: 'INSERT_DB_USER'		,		width: 66, hidden: true	},
				  {dataIndex: 'UPDATE_DB_USER'		,		width: 66, hidden: true	}*/
				],
				listeners: {
					cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
						if(rowIndex != beforeRowIndex){
							panelSearch.setValue('GROUP_CODE_P',record.get('GROUP_CODE'));
							
							directMasterStore.loadStoreRecords(record);
							programStore.loadStoreRecords(record);
						}
						beforeRowIndex = rowIndex;
					}
		        }
	});
	
	
	var masterGrid = Unilite.createGrid('bsa520ukrvMasterGrid', {
		region: 'north',
		store: directMasterStore,
		title: '<t:message code="system.label.base.programlist" default="프로그램 목록"/>',
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: true, toggleOnClick: false  }), 
		uniOpt: {
	        	onLoadSelectFirst: false,
	        	expandLastColumn: true,
				useMultipleSorting: true,
	    		useGroupSummary: false,
	    		useLiveSearch: true,
				useContextMenu: true
	        },
		columns: [
				  {dataIndex: 'PGM_ID'        		,		width: 100	},
				  {dataIndex: 'PGM_NAME'      		,		width: 250	}
				  /*,
				  {dataIndex: 'PGM_LEVEL'     		,		width: 100, hidden: true	},
				  {dataIndex: 'PGM_LEVEL2'    		,		width: 100, hidden: true	},
				  {dataIndex: 'AUTHO_USER'    		,		width: 100, hidden: true },
				  {dataIndex: 'AUTHO_TYPE'    		,		width: 66, hidden: true	},
				  {dataIndex: 'AUTHO_PGM'     		,		width: 66, hidden: true	},
				  {dataIndex: 'REF_CODE'      		,		width: 66, hidden: true	},
				  {dataIndex: 'AUTHO_ID'      		,		width: 66, hidden: true	},
				  {dataIndex: 'COMP_CODE'     		,		width: 66, hidden: true	},
				  {dataIndex: 'INSERT_DB_USER'		,		width: 66, hidden: true	},
				  {dataIndex: 'UPDATE_DB_USER'		,		width: 66, hidden: true	}*/
		]
	});
		
		
	var programGrid =  Unilite.createGrid('bsa520ukrvDetailSystemGrid', {
			region: 'south',
			store: programStore,
			title: '<t:message code="system.label.base.availableprogram" default="사용가능 프로그램"/>',
			uniOpt: {
	        	onLoadSelectFirst: false,
	        	expandLastColumn: true,
				useMultipleSorting: true,
	    		useGroupSummary: false,
	    		useLiveSearch: true,
				useContextMenu: true
	        },
	        selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: true, toggleOnClick: false  }), 
			columns: [{dataIndex: 'GROUP_CODE'    		,		width: 66,hidden: true	},
					  {dataIndex: 'PGM_ID'        		,		width: 100	},
					  {dataIndex: 'PGM_NAME'      		,		width: 250	},
					  {dataIndex: 'PGM_LEVEL'     		,		width: 100	},
					  {dataIndex: 'PGM_LEVEL2'    		,		width: 100	},
					  {dataIndex: 'AUTHO_USER'    		,		width: 100  },
					/*{dataIndex: 'AUTHO_TYPE'    		,		width: 66, hidden: true	},
					  {dataIndex: 'AUTHO_PGM'     		,		width: 66, hidden: true	},
					  {dataIndex: 'REF_CODE'      		,		width: 66, hidden: true	},
					  {dataIndex: 'AUTHO_ID'      		,		width: 66, hidden: true	},
					  {dataIndex: 'COMP_CODE'     		,		width: 66, hidden: true	}, */
					  {dataIndex: 'INSERT_DB_USER'		,		width: 66, hidden: true	},
					  {dataIndex: 'UPDATE_DB_USER'		,		width: 66, hidden: true	}				  	
			],
			listeners : {
				beforeedit  : function( editor, e, eOpts ) {
		        	if(e.record.phantom == false || !e.record.phantom == false) {
		        		if(UniUtils.indexOf(e.field, ['GROUP_CODE', 'PGM_ID', 'PGM_NAME' ,'INSERT_DB_USER' ,'UPDATE_DB_USER'])) 
						{ 
							return false;
	      				} 
		        	}
				}
			}
		});

	var btnArea = { 
		region: 'center',
		margin: '0 0 2 0',
		xtype: 'container',
		id: 'bsa520ukrvBtn',
		height: 30,
		layout: {
	        type: 'hbox',
	         align: 'center',
	         pack: 'center'
	       },
		items: [{
			text: '▽'+'<t:message code="system.label.base.add" default="추가"/>',
			margin: '5 30 5 10',
			xtype: 'button',
			handler: function() {					        
		       //var records, record, data = new Object();
		       if (masterGrid.getSelectedRecords()) {		
		           var records = masterGrid.getSelectedRecords();
		           console.log("records: ", records);        
		           //data.records = [];
		           
		           for (var i = 0, len = records.length; i < len; i++) {
		           		records[i].data.GROUP_CODE = groupGrid.getSelectedRecord().get('GROUP_CODE');
						records[i].data.PGM_LEVEL  = '0';
						records[i].data.PGM_LEVEL2 = '1';
		           		
		           		
		            	var proCrt = programGrid.createRow(records[i].data);
		            	programGrid.getSelectionModel().deselect(proCrt);

		            }
			        masterGrid.deleteSelectedRow();
			        masterGrid.getSelectionModel().deselectAll();  
			    }
			}
		}, {
			text: '△'+'<t:message code="system.label.base.remove" default="제거"/>',
			xtype: 'button',
			margin: '5 30 5 10',
			handler: function() {				        
		       //var records, data = new Object();
		       if (programGrid.getSelectedRecords()) {
		           var records = programGrid.getSelectedRecords();
		           //data.records = [];
		           for (var i = 0, len = records.length; i < len; i++) {
		           	
		                var masCrt = masterGrid.createRow(records[i].data);
		                masterGrid.getSelectionModel().deselect(masCrt);
		           }
			        programGrid.deleteSelectedRow();
			        programGrid.getSelectionModel().deselectAll();  
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
				items: [masterGrid, btnArea, programGrid]
				
			},groupGrid , panelResult]	
		}		
		,panelSearch
		],
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons(['delete', 'reset'],false);
			UniAppManager.app.onQueryButtonDown();
		}
		, onQueryButtonDown: function() {
			masterGrid.reset();
			programGrid.reset();
			
			directGroupStore.loadStoreRecords();
			panelSearch.setValue('GROUP_CODE_P','');
			
			//directMasterStore.loadStoreRecords();
			//programStore.loadStoreRecords();
			
			beforeRowIndex = -1;

		}
		, onSaveDataButtonDown: function () {										
			if(programStore.isDirty(false)) {
				programStore.saveStore();						
			}
		},
		onResetButtonDown: function() {
			groupGrid.reset();
			programGrid.reset();
			masterGrid.reset();
			Ext.getCmp('bsa520ukrvSearchForm').reset();
		}
	});
		Unilite.createValidator('bsa520ukrvValidator', {
		store: programStore,
		grid: programGrid,
		forms: {'formA: ': bsa520ukrvSearchForm},
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