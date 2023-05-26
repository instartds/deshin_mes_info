<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bsa540ukrv" >
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
			read: 'bsa540ukrvService.selectProgramList',
			update: 'bsa540ukrvService.updateDetail',
			create: 'bsa540ukrvService.insertDetail',
			destroy: 'bsa540ukrvService.deleteDetail',
			syncAll: 'bsa540ukrvService.saveAll'
		}
	});

	Unilite.defineModel('bsa540ukrvGroupModel', {
	
		fields: [{name: 'COMP_CODE'       		, text: '<t:message code="system.label.base.companycode" default="법인코드"/>',		type: 'string'	,defaultValue : UserInfo.compCode},
				 {name: 'PGM_SEQ'         		, text: '<t:message code="system.label.base.businessclassification" default="업무구분"/>',		type: 'string'	, comboType:"AU", comboCode:"B007"},
				 {name: 'PGM_SEQ_NM'      		, text: '<t:message code="system.label.base.businessclassification" default="업무구분"/>',		type: 'string'	},
				 {name: 'PGM_ID'          		, text: '<t:message code="system.label.base.programid" default="프로그램ID"/>',		type: 'string'	},
				 {name: 'PGM_NAME'        		, text: '<t:message code="system.label.base.programname" default="프로그램명"/>',		type: 'string'	},
				 {name: 'PGM_NAME_EN'     		, text: '<t:message code="system.label.base.programnameen" default="프로그램명(영어)"/>',		type: 'string'	},
				 {name: 'PGM_NAME_CN'     		, text: '<t:message code="system.label.base.programnamecn" default="프로그램명(중국어)"/>',		type: 'string'	},
				 {name: 'PGM_NAME_JP'     		, text: '<t:message code="system.label.base.programnamejp" default="프로그램명(일본어)"/>',		type: 'string'	},
				 {name: 'PGM_NAME_VI'     		, text: '<t:message code="system.label.base.programnamevi" default="프로그램명(베트남어)"/>',		type: 'string'	},
				 {name: 'AUTHO_TYPE'      		, text: '<t:message code="system.label.base.authotype" default="권한형태"/>',		type: 'string'	},
				 {name: 'AUTHO_PGM'       		, text: '<t:message code="system.label.base.authopgm" default="권한정의"/>',		type: 'string'	},
				 {name: 'AUTHO_GRANT'     		, text: '<t:message code="system.label.base.refcode" default="참조코드"/>',		type: 'string'	},
				 {name: 'AUTHO_ID'        		, text: '<t:message code="system.label.base.authotypenumb" default="권한형태(번호)"/>',	type: 'string'	},
				 {name: 'UPDATE_MAN'      		, text: '<t:message code="system.label.base.updateuser" default="수정자"/>',			type: 'string'	,defaultValue : UserInfo.userID},
				 {name: 'UPDATE_DATE'     		, text: '<t:message code="system.label.base.updatedate" default="수정일"/>',			type: 'uniDate'	}
		]
	});
	
	var directGroupStore = Unilite.createStore('bsa540ukrvGroupStore', { 
		model: 'bsa540ukrvGroupModel',
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
				read: 	 'bsa540ukrvService.selectMaster'
				
			}
		},
		loadStoreRecords: function() {
			var param= panelSearch.getValues();			
			console.log(param);
			this.load({
				params : param
			});
		},
		listeners: {
           	load: function(store, records, successful, eOpts) {
           		if(!Ext.isEmpty(records)){
           			panelSearch.setValue('PGM_ID_P', records[0].get('PGM_ID'));
           			panelSearch.setValue('PGM_SEQ_P', records[0].get('PGM_SEQ'));
           			groupGrid.getSelectionModel().select( 0 );
           			directMasterStore.loadStoreRecords(records[0]);
           			programStore.loadStoreRecords(records[0]);
           			
           		}else{
           			Unilite.messageBox('해당 데이터가 존재하지 않습니다.');
           			UniAppManager.app.onResetButtonDown();
//           			detailStore.removeAll('clear');           		
           		}
           	}
		}
	});
	
	
	Unilite.defineModel('bsa540ukrvMasterModel', {
	
		fields: [{name: 'COMP_CODE'       		, text: '<t:message code="system.label.base.companycode" default="법인코드"/>',		type: 'string'	,defaultValue : UserInfo.compCode},
				 {name: 'PGM_ID'          		, text: '<t:message code="system.label.base.programid" default="프로그램ID"/>',		type: 'string'	},
				 {name: 'USER_ID'         		, text: '<t:message code="system.label.base.userid" default="사용자ID"/>',		type: 'string'	},
				 {name: 'USER_NAME'       		, text: '<t:message code="system.label.base.username" default="사용자명"/>',		type: 'string'	},
				 {name: 'PGM_LEVEL'       		, text: '<t:message code="system.label.base.datamodify" default="자료수정"/>',		type: 'string'	},
				 {name: 'PGM_LEVEL2'      		, text: '<t:message code="system.label.base.filesave" default="파일저장"/>',		type: 'string'	},
				 {name: 'AUTHO_USER'      		, text: '<t:message code="system.label.base.authouser" default="자료권한"/>',		type: 'string'	},
				 {name: 'AUTHO_TYPE'      		, text: '<t:message code="system.label.base.authotype" default="권한형태"/>',		type: 'string'	},
				 {name: 'AUTHO_PGM'       		, text: '<t:message code="system.label.base.authopgm" default="권한정의"/>',		type: 'string'	},
				 {name: 'AUTHO_GRANT'     		, text: '<t:message code="system.label.base.refcode" default="참조코드"/>',		type: 'string'	},
				 {name: 'AUTHO_ID'        		, text: '<t:message code="system.label.base.authotypenumb" default="권한형태(번호)"/>',	type: 'string'	},
				 {name: 'UPDATE_MAN'      		, text: '<t:message code="system.label.base.updateuser" default="수정자"/>',			type: 'string'	,defaultValue : UserInfo.userID},
				 {name: 'UPDATE_DATE'     		, text: '<t:message code="system.label.base.updatedate" default="수정일"/>',			type: 'uniDate'	}
		]
	});
	
	var directMasterStore = Unilite.createStore('bsa540ukrvMasterStore', { 
		model: 'bsa540ukrvMasterModel',
		autoLoad: false,
		uniOpt: {
	    	isMaster: true,			// 상위 버튼 연결 
	    	editable: false,			// 수정 모드 사용 
	    	deletable: false,			// 삭제 가능 여부 
	        useNavi: false			// prev | next 버튼 사용
	    }
	    ,
		proxy: {
			type: 'direct',
			api: {
				read: 	 'bsa540ukrvService.selectList'
				
			}
		}
		,loadStoreRecords: function() {
			var param= panelSearch.getValues();			
			console.log(param);
			this.load({
				params : param
			});
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
		
	
	Unilite.defineModel('bsa540ukrvProgramModel', {		
		
		fields: [{name: 'COMP_CODE'       		, text: '<t:message code="system.label.base.companycode" default="법인코드"/>',		type: 'string'	,defaultValue : UserInfo.compCode},
				 {name: 'PGM_ID'          		, text: '<t:message code="system.label.base.programid" default="프로그램ID"/>',		type: 'string'	},
				 {name: 'USER_ID'         		, text: '<t:message code="system.label.base.userid" default="사용자ID"/>',		type: 'string'	},
				 {name: 'USER_NAME'       		, text: '<t:message code="system.label.base.username" default="사용자명"/>',		type: 'string'	},
				 {name: 'PGM_LEVEL'     		, text: '<t:message code="system.label.base.datamodify" default="자료수정"/>',		type: 'string'	, comboType:"AU", comboCode:"B003" , defaultValue : '0'},
				 {name: 'PGM_LEVEL2'    		, text: '<t:message code="system.label.base.filesave" default="파일저장"/>',		type: 'string'	, comboType:"AU", comboCode:"B006" , defaultValue : '1'},
				 {name: 'AUTHO_USER'    		, text: '<t:message code="system.label.base.authouser" default="자료권한"/>',		type: 'string'	, comboType:"AU", comboCode:"BS06"},
				 {name: 'AUTHO_TYPE'      		, text: '<t:message code="system.label.base.authotype" default="권한형태"/>',		type: 'string'	},
				 {name: 'AUTHO_PGM'       		, text: '<t:message code="system.label.base.authopgm" default="권한정의"/>',		type: 'string'	},
				 {name: 'AUTHO_GRANT'     		, text: '<t:message code="system.label.base.refcode" default="참조코드"/>',		type: 'string'	},
				 {name: 'AUTHO_ID'        		, text: '<t:message code="system.label.base.authotypenumb" default="권한형태(번호)"/>',	type: 'string'	},
				 {name: 'UPDATE_MAN'      		, text: '<t:message code="system.label.base.updateuser" default="수정자"/>',			type: 'string'	,defaultValue : UserInfo.userID},
				 {name: 'UPDATE_DATE'     		, text: '<t:message code="system.label.base.updatedate" default="수정일"/>',			type: 'uniDate'	}		 	
		]
	});
	
	var programStore = Unilite.createStore('bsa540ukrvProgramStore', { 
		model: 'bsa540ukrvProgramModel',
		autoLoad: false,
		uniOpt: {
	    	isMaster: true,			// 상위 버튼 연결 
	    	editable: true,			// 수정 모드 사용 
	    	deletable: false,			// 삭제 가능 여부 
	        useNavi: false			// prev | next 버튼 사용
	    },
		proxy: directProxy,
		
		loadStoreRecords : function(){
//			var gridParam = groupGrid.getSelectedRecord().data;//record.data; 
			var param  = Ext.getCmp('bsa540ukrvSearchForm').getValues();	
//			var params = Ext.merge(gridParam , param);
			this.load({
				params : param
			});				
		},
			
//		loadStoreRecords: function() {
//			var param= panelSearch.getValues();			
//			console.log(param);
//			this.load({
//				params : param
//			});
//		},
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
		
		
	var panelSearch = Unilite.createSearchPanel('bsa540ukrvSearchForm', {          
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
        		fieldLabel: 'UPDATE_MAN',
        		name: 'UPDATE_MAN',
        		value : UserInfo.userName,
        		xtype: 'uniTextfield',
        		hidden:true
        	},{
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
			},
				Unilite.popup('USER',{
				fieldLabel: '<t:message code="system.label.base.user" default="사용자"/>',
				validateBlank:false, 
				popupWidth: 710,
				valueFieldName:'USER_ID',
		    	textFieldName:'USER_NAME',
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
			}),{
				fieldLabel:'그리드1의 PGM_ID',
				name:'PGM_ID_P',
				xtype: 'uniTextfield',
				hidden:true
			},{
                fieldLabel:'그리드1의 PGM_SEQ',
                name:'PGM_SEQ_P',
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
			},
				Unilite.popup('USER',{
				fieldLabel: '<t:message code="system.label.base.user" default="사용자"/>',
				valueFieldName:'USER_ID',
		    	textFieldName:'USER_NAME',
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
	var groupGrid = Unilite.createGrid('bsa540ukrvGroupGrid', {
		region: 'west',
		store: directGroupStore,
		title: '<t:message code="system.label.base.programlist" default="프로그램 목록"/>',
		selModel: 'rowmodel',
		uniOpt: {
	    	onLoadSelectFirst: false,
        	expandLastColumn: true,
			useMultipleSorting: true,
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: true,
			useRowNumberer: false
	    },
		columns: [{dataIndex: 'COMP_CODE'       		,		width: 66, hidden: true },
				  {dataIndex: 'PGM_SEQ'         		,		width: 66, hidden: true },
				  {dataIndex: 'PGM_SEQ_NM'      		,		width: 86 },
				  {dataIndex: 'PGM_ID'          		,		width: 106 },
				  {dataIndex: 'PGM_NAME'        		,		width: 166 },
				  {dataIndex: 'PGM_NAME_EN'     		,		width: 166, hidden: true },
				  {dataIndex: 'PGM_NAME_CN'     		,		width: 166, hidden: true },
				  {dataIndex: 'PGM_NAME_JP'     		,		width: 166, hidden: true },
				  {dataIndex: 'PGM_NAME_VI'     		,		width: 166, hidden: true },
				  {dataIndex: 'AUTHO_TYPE'      		,		width: 66, hidden: true },
				  {dataIndex: 'AUTHO_PGM'       		,		width: 66, hidden: true },
				  {dataIndex: 'AUTHO_GRANT'     		,		width: 66, hidden: true },
				  {dataIndex: 'AUTHO_ID'        		,		width: 66, hidden: true },
				  {dataIndex: 'UPDATE_MAN'       		,		width: 66, hidden: true },
				  {dataIndex: 'UPDATE_USER'     		,		width: 66, hidden: true }
				],
				listeners: {
					cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
//						if(rowIndex != beforeRowIndex){
							panelSearch.setValue('PGM_ID_P',record.get('PGM_ID'));
                            panelSearch.setValue('PGM_SEQ_P',record.get('PGM_SEQ'));
							
							directMasterStore.loadStoreRecords();
							programStore.loadStoreRecords();
							
//						}
//						beforeRowIndex = rowIndex;
					}
		        }
		
	});
	
	
	var masterGrid = Unilite.createGrid('bsa540ukrvMasterGrid', {
		region: 'north',
		store: directMasterStore,
		title: '<t:message code="system.label.base.registeruser" default="등록된 사용자"/>',
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: true, toggleOnClick: false  }), 
		uniOpt: {
	    	onLoadSelectFirst: false,
        	expandLastColumn: true,
			useMultipleSorting: true,
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: true
	    },
		columns: [{dataIndex: 'COMP_CODE'       		,		width: 66, hidden: true },
				  {dataIndex: 'PGM_ID'          		,		width: 66, hidden: true },
				  {dataIndex: 'USER_ID'         		,		width: 100 },
				  {dataIndex: 'USER_NAME'       		,		width: 200 },
				  {dataIndex: 'PGM_LEVEL'       		,		width: 80, hidden: true },
				  {dataIndex: 'PGM_LEVEL2'      		,		width: 80, hidden: true},
				  {dataIndex: 'AUTHO_USER'      		,		width: 80, hidden: true },
				  {dataIndex: 'AUTHO_TYPE'      		,		width: 66, hidden: true },
				  {dataIndex: 'AUTHO_PGM'       		,		width: 66, hidden: true },
				  {dataIndex: 'AUTHO_GRANT'     		,		width: 66, hidden: true },
				  {dataIndex: 'AUTHO_ID'        		,		width: 66, hidden: true },
				  {dataIndex: 'UPDATE_MAN'      		,		width: 66, hidden: true },
				  {dataIndex: 'UPDATE_DATE'     		,		width: 66, hidden: true }
				]		
		
	});
		
		
		
	var programGrid =  Unilite.createGrid('bsa540ukrvDetailSystemGrid', {
			region: 'south',
			store: programStore,
			title: '<t:message code="system.label.base.availableuser" default="사용가능 사용자"/>',
			uniOpt: {
	        	onLoadSelectFirst: false,
	        	expandLastColumn: true,
				useMultipleSorting: true,
	    		useGroupSummary: false,
	    		useLiveSearch: true,
				useContextMenu: true
	        },
	        selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: true, toggleOnClick: false  }), 
			columns: [{dataIndex: 'COMP_CODE'       		,		width: 66, hidden: true },
					  {dataIndex: 'PGM_ID'          		,		width: 66, hidden: true },
					  {dataIndex: 'USER_ID'         		,		width: 100 },
					  {dataIndex: 'USER_NAME'       		,		width: 200 },
					  {dataIndex: 'PGM_LEVEL'       		,		width: 80 },
					  {dataIndex: 'PGM_LEVEL2'      		,		width: 80 },
					  {dataIndex: 'AUTHO_USER'      		,		width: 80 },
					  {dataIndex: 'AUTHO_TYPE'      		,		width: 66, hidden: true },
					  {dataIndex: 'AUTHO_PGM'       		,		width: 66, hidden: true },
					  {dataIndex: 'AUTHO_GRANT'     		,		width: 66, hidden: true },
					  {dataIndex: 'AUTHO_ID'        		,		width: 66, hidden: true },
					  {dataIndex: 'UPDATE_MAN'      		,		width: 66, hidden: true },
					  {dataIndex: 'UPDATE_DATE'     		,		width: 66, hidden: true }				  	
			],
			listeners : {
				beforeedit  : function( editor, e, eOpts ) {
		        	if(e.record.phantom == false || !e.record.phantom == false) {
		        		if(UniUtils.indexOf(e.field, ['COMP_CODE', 'PGM_ID', 'USER_ID', 'USER_NAME' ,'INSERT_DB_USER' ,'UPDATE_DB_USER'])) 
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
		id: 'bsa540ukrvBtn',
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
		       if (masterGrid.getSelectedRecords()) {		
		           var records = masterGrid.getSelectedRecords();
		           console.log("records: ", records);        
		           for (var i = 0, len = records.length; i < len; i++) {
		           		records[i].data.PGM_ID = groupGrid.getSelectedRecord().get('PGM_ID');
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
		       if (programGrid.getSelectedRecords()) {
		           var records = programGrid.getSelectedRecords();
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
				
			},groupGrid, panelResult ]	
		}		
		,panelSearch
		],
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons(['reset'],true);
			//UniAppManager.app.onQueryButtonDown();
		}
		, onQueryButtonDown: function() {
			masterGrid.reset();
			programGrid.reset();
			
			directGroupStore.loadStoreRecords();
			panelSearch.setValue('PGM_ID_P','');
			panelSearch.setValue('PGM_SEQ_P','');
			
			beforeRowIndex = -1;
			//groupGrid.getStore().loadStoreRecords();
			//panelSearch.setValue('PGM_ID_P','');
			
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
			Ext.getCmp('bsa540ukrvSearchForm').reset();
			UniAppManager.setToolbarButtons(['save'],false);
		}
	});
		
		

		Unilite.createValidator('bsa540ukrvValidator', {
		store: programStore,
		grid: programGrid,
		forms: {'formA: ': bsa540ukrvSearchForm},
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