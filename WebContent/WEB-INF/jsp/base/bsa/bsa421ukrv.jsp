<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bsa421ukrv" >
	<t:ExtComboStore comboType="AU" comboCode="B003" /><!-- 자료수정 -->
	<t:ExtComboStore comboType="AU" comboCode="B006" /><!-- 파일저장 -->
	<t:ExtComboStore comboType="AU" comboCode="BS06" /><!-- 자료권한 -->
</t:appConfig>
<script type="text/javascript">
	
function appMain() {
		Unilite.defineModel('bsa421ukrvMasterModel', {
			fields: [	 {name: 'COMP_CODE'			,text:'COMP_CODE', type: 'string', allowBlank: false , defaultValue: UserInfo.compCode}
    			,{name: 'USER_ID' 			,text:'USERID' 	,type:'string', allowBlank:false	}
    			,{name: 'PGM_ID' 			,text:'<t:message code="system.label.common.programid" default="프로그램ID"/>' 	,type:'string', allowBlank:false	}
    			,{name: 'PGM_NAME' 			,text:'<t:message code="system.label.common.programname" default="프로그램명"/>' 	,type:'string', allowBlank:false	}
    			,{name: 'SHT_ID' 			,text:'GridID' 	,type:'string', allowBlank:false	}
    			,{name: 'SHT_SEQ' 			,text:'<t:message code="system.label.common.settings" default="설정"/>SEQ' 	,type:'string', allowBlank:false	}
    			,{name: 'SHT_NAME' 			,text:'<t:message code="system.label.common.settings" default="설정"/>' 	,type:'string',	allowBlank:false	}
				,{name: 'SHT_DESC' 			,text:'<t:message code="system.label.common.desc" default="설명"/>' 	,type:'string'	}
				,{name: 'SHT_TYPE' 			,text:'<t:message code="system.label.common.type" default="유형"/>' 	,type:'string'	, comboType:'AU',comboCode:'B125' , defaultValue: 'P'}
				,{name: 'SHT_INFO' 			,text:'<t:message code="system.label.common.shtinfo" default="설정정보"/>' 	,type:'string'	}
				,{name: 'DEFAULT_YN' 		,text:'<t:message code="system.label.common.basicsetting" default="기본설정"/>' 	,type:'string'	, comboType:'AU',comboCode:'B010' , defaultValue: 'Y'}
				,{name: 'QLIST_YN' 			,text:'<t:message code="system.label.common.quicklist" default="빠른목록"/>' 	,type:'string'	, comboType:'AU',comboCode:'B010' , defaultValue: 'Y'}
				
		]
		});

		var directMasterStore = Unilite.createStore('bsa421ukrvMasterStore', { 
			model : 'bsa421ukrvMasterModel',
			autoLoad : false,
			uniOpt : {
            	isMaster: false,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
			proxy : {
				type : 'direct',
				api : {
					read : 	 'bsa421ukrvService.selectList'
					
				}
			}
			,loadStoreRecords : function()	{
				var param= Ext.getCmp('bsa421ukrvSearchForm').getValues();	
				if(panelSearch.getValue('USER_ID') != '')	{					
					this.load({
						params : param
					});
				}else {
					Unilite.messageBox(Msg.sMB152);
					// 사용자ID를 선택해 주세요.
				}
			}
		});	

		Unilite.defineModel('bsa421ukrvProgramModel', {		
			fields: [	 
				 {name: 'COMP_CODE'			,text:'COMP_CODE', type: 'string', allowBlank: false , defaultValue: UserInfo.compCode}
    			,{name: 'USER_ID' 			,text:'USERID' 	,type:'string', allowBlank:false	}
    			,{name: 'PGM_ID' 			,text:'<t:message code="system.label.common.programid" default="프로그램ID"/>' 	,type:'string', allowBlank:false	}
    			,{name: 'PGM_NAME' 			,text:'<t:message code="system.label.common.programname" default="프로그램명"/>' 	,type:'string', allowBlank:false	}
    			,{name: 'SHT_ID' 			,text:'GridID' 	,type:'string', allowBlank:false	}
    			,{name: 'SHT_SEQ' 			,text:'<t:message code="system.label.common.settings" default="설정"/>SEQ' 	,type:'string', allowBlank:false	}
    			,{name: 'SHT_NAME' 			,text:'<t:message code="system.label.common.settings" default="설정"/>' 	,type:'string',	allowBlank:false	}
				,{name: 'SHT_DESC' 			,text:'<t:message code="system.label.common.desc" default="설명"/>' 	,type:'string'	}
				,{name: 'SHT_TYPE' 			,text:'<t:message code="system.label.common.type" default="유형"/>' 	,type:'string'	, comboType:'AU',comboCode:'B125' , defaultValue: 'P'}
				,{name: 'SHT_INFO' 			,text:'<t:message code="system.label.common.shtinfo" default="설정정보"/>' 	,type:'string'	}
				,{name: 'DEFAULT_YN' 		,text:'<t:message code="system.label.common.basicsetting" default="기본설정"/>' 	,type:'string'	, comboType:'AU',comboCode:'B010' , defaultValue: 'Y'}
				,{name: 'QLIST_YN' 			,text:'<t:message code="system.label.common.quicklist" default="빠른목록"/>' 	,type:'string'	, comboType:'AU',comboCode:'B010' , defaultValue: 'Y'}
				
			]
		});
		
		var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
			api: {
				read : 'bsa421ukrvService.selectProgramList',
				create : 'bsa421ukrvService.insertPrograms',
				destroy: 'bsa421ukrvService.deletePrograms',
				syncAll: 'bsa421ukrvService.saveAll'
			}
		});
		
		var programStore = Unilite.createStore('bsa421ukrvProgramStore', { 
			model : 'bsa421ukrvProgramModel',
			autoLoad : false,
			uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
			proxy : directProxy
			,loadStoreRecords : function(mainCode)	{
				var param= Ext.getCmp('bsa421ukrvSearchForm').getValues();	
					this.load({
						params : param
					});
			},saveStore : function()	{
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
				
   		// 검색
		var panelSearch = Unilite.createSearchForm('bsa421ukrvSearchForm',{
				
			layout : {type : 'uniTable', columns : 4},
				items : [ Unilite.popup('USER',
							{
								fieldLabel:'사용자 ID',
								colspan:2, 
								flex:.5,
								valueFieldName:'USER',
								extFieldName:'NAME',
								allowBlank:false, 
								textFieldWidth:170, 
								valueFieldWidth:100,
								listeners : {
									'onSelected': {
					                    fn: function(records, type ){
					                    	panelSearch.setValue('COMP_CODE', records[0]['COMP_CODE'])
					                    	if(records.length > 0)	{
					                    		var cRec = programGrid.getSelectedRecord();
					                    		if(cRec)	{
					                    			var saveUserId = cRec.get('USER_ID');
						                    		if(records[0]['USER_ID'] != saveUserId)	{
								                    	if(programStore.isDirty())	{
								                    		if(confirm(Msg.sMB017 + "\n" + Msg.sMB061))	{
																programStore.saveStore();																	
															}
								                    	} 
								                    	masterGrid.reset();
								                    	programGrid.reset();
						                    		}
					                    		}
					                    	}
					                    },
					                    scope: this
					                  }
									, 'onClear' : function(type)	{
				                  		if(programStore.isDirty())	{
				                    		if(confirm(Msg.sMB017 + "\n" + Msg.sMB061))	{
												programStore.saveStore();																	
				                    		}
					                    	masterGrid.reset();
					                    	programGrid.reset();
				                  		}
						            }			
								} 
							}) ,
						   Unilite.popup('USER',
						   	{
						   		fieldLabel:'대상 사용자 ID',
						   		valueFieldName:'TARGET_USER',
								textFieldName:'TARGET_NAME',
						   		colspan:2, 
						   		flex:.5,
						   		allowBlank:false, 
						   		textFieldWidth:170, 
						   		valueFieldWidth:100,
								listeners : {
									'onSelected': {
					                    fn: function(records, type ){
					                    	panelSearch.setValue('COMP_CODE', records[0]['COMP_CODE'])
					                    	if(records.length > 0)	{
					                    		var cRec = programGrid.getSelectedRecord();
					                    		if(cRec)	{
					                    			var saveUserId = cRec.get('USER_ID');
						                    		if(records[0]['USER_ID'] != saveUserId)	{
								                    	if(programStore.isDirty())	{
								                    		if(confirm(Msg.sMB017 + "\n" + Msg.sMB061))	{
																programStore.saveStore();																	
															}
								                    	} 
								                    	masterGrid.reset();
								                    	programGrid.reset();
						                    		}
					                    		}
					                    	}
					                    },
					                    scope: this
					                  }
										, 'onClear' : function(type)	{
									                  		if(programStore.isDirty())	{
									                    		if(confirm(Msg.sMB017 + "\n" + Msg.sMB061))	{
																	programStore.saveStore();																	
									                    		}
										                    	masterGrid.reset();
										                    	programGrid.reset();
									                  		}
									                  }			
										} 
							}) ,
						  {fieldLabel : '<t:message code="system.label.base.companycode" default="법인코드"/>',	name : 'COMP_CODE'		, hidden: true},
						  {fieldLabel: '<t:message code="system.label.base.businessclassification" default="업무구분"/>',		name : 'PGM_SEQ'		, xtype: 'uniCombobox',  comboType : 'AU', comboCode : 'B007'},
		       			  {fieldLabel : '<t:message code="system.label.base.programid" default="프로그램ID"/>',	name : 'PGM_ID'}
						, {fieldLabel : '<t:message code="system.label.base.programname" default="프로그램명"/>',	name : 'PGM_NAME', colspan:2} 
						]
			});
		
		// create the Grid
		var masterGrid = Unilite.createGrid('bsa421ukrvMasterGrid', {
			store: directMasterStore,
			title : '<t:message code="system.label.base.userstateList" default="선택 사용자 그리드 설정"/>',
			selModel :   Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false  }), 
			uniOpt:{
	        	onLoadSelectFirst: false
	        },
	        flex:2,
			columns : [   {dataIndex : 'PGM_ID',			width:100	}
						, {dataIndex : 'PGM_NAME',			width:150	}
						, {dataIndex : 'SHT_TYPE',			width:60	}
						, {dataIndex : 'SHT_ID',			width:100	}
						, {dataIndex : 'SHT_NAME',			width:150	}
						, {dataIndex : 'USER_ID',			width:100,		hidden : true	}
						, {dataIndex : 'SHT_DESC',		width:100,		hidden : true	}
						, {dataIndex : 'DEFAULT_YN',		width:100,		hidden : true	}
						, {dataIndex : 'QLIST_YN',		width:100,		hidden : true	}
					]		
		});
		
	var programGrid =  Unilite.createGrid('bsa421ukrvDetailSystemGrid', {
			store : programStore,
			title : '<t:message code="system.label.base.targetstatelist" default="대상 사용자 그리드 설정"/>',
	        selModel :   Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false  }), 			
			uniOpt:{
	        	onLoadSelectFirst : false
	        },
	        flex : 3,
			columns : [   {dataIndex : 'PGM_ID',			width:100	}
						, {dataIndex : 'PGM_NAME',			width:150	}
						, {dataIndex : 'SHT_TYPE',			width:60	}
						, {dataIndex : 'SHT_ID',			width:100	}
						, {dataIndex : 'SHT_NAME',			width:150	}
						, {dataIndex : 'USER_ID',			width:100,		hidden : true	}
						, {dataIndex : 'SHT_DESC',		width:100,		hidden : true	}
						, {dataIndex : 'DEFAULT_YN',		width:100,		hidden : true	}
						, {dataIndex : 'QLIST_YN',		width:100,		hidden : true	}
					]
		});

	var btnArea = { 	xtype : 'container',
						id:'bsa421ukrvBtn',
						layout: {
						        type: 'vbox',
						         align: 'center',
						         pack:'center'
						       },
						items: [ { text: '>>',
						margin :'2 10 2 10',
									xtype: 'button',
									    handler: function() {
									        
										       var records, record, data = new Object();
										        if (masterGrid.getSelectedRecords()) {
										        	
										            records = masterGrid.getSelectedRecords();
										            console.log("records : ", records);
										            data.records = [];
										            for (i = 0, len = records.length; i < len; i++) {
										            	var record = records[i].copy();
										            	var check = true;
										            	Ext.each(programStore.getData().items, function(sRecord, idx) {
										            		if(sRecord.get("PGM_ID") == record.get("PGM_ID")
										            		  && sRecord.get("SHT_ID") == record.get("SHT_ID")
										            		  && sRecord.get("SHT_NAME") == record.get("SHT_NAME"))	{
										            		 	if(confirm('<t:message code="system.message.base.shtNameMessage" default="같은 설정명이 있습니다. 변경 하시겠습니까?"/>'))	{
										            		 		programStore.remove(sRecord);
										            		 		check = false;
										            		 	}
										            		 }
										            	} );
										            	if(!check)	{
											            	record.phantom = true;
											            	record.set("USER_ID", panelSearch.getValue("TARGET_USER"));
											            	data.records.push(record);
										            	} else {
										            		record.phantom = true;
										            		record.set("SHT_NAME", record.get("SHT_NAME")+"_new");
											            	record.set("USER_ID", panelSearch.getValue("TARGET_USER"));
											            	data.records.push(record);
										            		//masterGrid.getSelectionModel().deselect(records[i]);
										            	}
										            }
										        programGrid.getStore().insert(0, data.records);		
										        programGrid.getSelectionModel().select(data.records);
										        masterGrid.getSelectionModel().deselect();
										    }
									    }
								  },
								   { text: '<<',
								   	 margin:'2 10 2 10',
									 xtype: 'button',
									 handler: function() {
									        
										       var records, record, data = new Object();
										        if (programGrid.getSelectedRecords()) {
										            records = programGrid.getSelectedRecords();
										        }
										      
										        programGrid.getStore().remove(records);
										    
									    }
								  }]
					}
    Unilite.Main({
			items : [ panelSearch, {
				xtype : 'container',
				flex : 1,
				layout: {
					        type: 'hbox',
					        align: 'stretch'
					    },
				/*defaults : {
					collapsible : false,
					split : true
				},*/
				items : [ masterGrid,  btnArea, programGrid ]

			} ]
			,fnInitBinding : function() {
				UniAppManager.setToolbarButtons(['reset'],true);
			}
			, onQueryButtonDown:function() {
				if(panelSearch.isValid())	{
					masterGrid.getStore().loadStoreRecords();
					programGrid.getStore().loadStoreRecords();
				}
			}

			, onSaveDataButtonDown: function () {										
					 if(programStore.isDirty())	{
						programStore.saveStore();						
					 }
				}
			,
				onResetButtonDown:function() {
					programGrid.getStore().loadData({});
					masterGrid.getStore().loadData({});
					Ext.getCmp('bsa421ukrvSearchForm').reset();
				}
		});

		Unilite.createValidator('bsa421ukrvValidator', {
		store : programStore,
		grid: programGrid,
		forms: {'formA:':bsa421ukrvSearchForm},
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			if (fieldName == "USER_ID" )	{		
					if(newValue == '')	{
						rv='<t:message code="unilite.msg.sMB152"/>';
						// 사용자ID를 선택해 주세요.
					}
			}
			return rv;
		}
		});
		

};	// appMain
</script>