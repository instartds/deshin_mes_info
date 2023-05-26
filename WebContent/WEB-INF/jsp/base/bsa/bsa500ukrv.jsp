<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bsa500ukrv" >
	<t:ExtComboStore comboType="AU" comboCode="B003" /><!-- 자료수정 -->
	<t:ExtComboStore comboType="AU" comboCode="B006" /><!-- 파일저장 -->
	<t:ExtComboStore comboType="AU" comboCode="BS06" /><!-- 자료권한 -->
</t:appConfig>
<script type="text/javascript">
	
function appMain() {
		Unilite.defineModel('bsa500ukrvMasterModel', {
			fields : [ {name : 'PGM_ID',			text : 'PGM_ID',			type : 'string'	, allowBlank:false}
					 , {name : 'PGM_NAME',			text : '<t:message code="system.label.base.programname" default="프로그램명"/>',		type : 'string' }
					 , {name : 'PGM_LEVEL',			text : '<t:message code="system.label.base.datamodify" default="자료수정"/>',			type : 'string', allowBlank:false, 	comboType:'AU', comboCode:'B003'}
					 , {name : 'PGM_LEVEL2',		text: '<t:message code="system.label.base.filesave" default="파일저장"/>',			type : 'string', allowBlank:false, 	comboType:'AU', comboCode:'B006'}
					 , {name : 'AUTHO_USER',		text: '<t:message code="system.label.base.authouser" default="자료권한"/>',			type : 'string', 	comboType:'AU', comboCode:'BS06'}
					 , {name : 'UPDATE_MAN',		text: '<t:message code="system.label.base.updateuser" default="수정자"/>',				type : 'string'		}
					 , {name : 'UPDATE_DATE',		text: '<t:message code="system.label.base.updatedate" default="수정일"/>',				type : 'string'		}
					 , {name : 'AUTHO_TYPE',		text: '<t:message code="system.label.base.authotype" default="권한형태"/>',			type : 'string'		}
					 , {name : 'AUTHO_PGM',			text: '<t:message code="system.label.base.authopgm" default="권한정의"/>',			type : 'string'		}
					 , {name : 'REF_CODE',			text: '<t:message code="system.label.base.refcode" default="참조코드"/>',			type : 'string'		}
					 , {name : 'AUTHO_ID',			text: '<t:message code="system.label.base.authotype" default="권한형태"/>',			type : 'string'		}
					 , {name : 'COMP_CODE',			text: '<t:message code="system.label.base.companycode" default="법인코드"/>',			type : 'string', allowBlank:false		}
					 , {name : 'USER_ID',			text: '<t:message code="system.label.base.userid" default="사용자ID"/>',			type : 'string'	, allowBlank:false}
					]
		});

		var directMasterStore = Unilite.createStore('bsa500ukrvMasterStore', { 
			model : 'bsa500ukrvMasterModel',
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
					read : 	 'bsa500ukrvService.selectList'
					
				}
			}
			,loadStoreRecords : function()	{
				var param= Ext.getCmp('bsa500ukrvSearchForm').getValues();	
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

		Unilite.defineModel('bsa500ukrvProgramModel', {		
			
			fields : [ {name : 'PGM_ID',			text : 'PGM_ID',		type : 'string'	, allowBlank:false, editable: false}
					 , {name : 'PGM_NAME',			text : '<t:message code="system.label.base.programname" default="프로그램명"/>',		type : 'string' , editable: false}
					 , {name : 'PGM_LEVEL',			text : '<t:message code="system.label.base.datamodify" default="자료수정"/>',			type : 'string' , allowBlank:false, 	comboType:'AU', comboCode:'B003'}
					 , {name : 'PGM_LEVEL2',		text: '<t:message code="system.label.base.filesave" default="파일저장"/>',			type : 'string' , allowBlank:false, 	comboType:'AU', comboCode:'B006'}
					 , {name : 'AUTHO_USER',		text: '<t:message code="system.label.base.authouser" default="자료권한"/>',			type : 'string' , comboType:'AU', comboCode:'BS06'}
					 , {name : 'UPDATE_MAN',		text: '<t:message code="system.label.base.updateuser" default="수정자"/>',			type : 'string' , editable: false}
					 , {name : 'UPDATE_DATE',		text: '<t:message code="system.label.base.updatedate" default="수정일"/>',			type : 'string' , editable: false}
					 , {name : 'AUTHO_TYPE',		text: '<t:message code="system.label.base.authotype" default="권한형태"/>',			type : 'string'	, editable: false}
					 , {name : 'AUTHO_PGM',			text: '<t:message code="system.label.base.authopgm" default="권한정의"/>',			type : 'string'	, editable: false}
					 , {name : 'REF_CODE',			text: '<t:message code="system.label.base.refcode" default="참조코드"/>',			type : 'string'	, editable: false}
					 , {name : 'AUTHO_ID',			text: '<t:message code="system.label.base.authotype" default="권한형태"/>',			type : 'string'	, editable: false}
					 , {name : 'COMP_CODE',			text: '<t:message code="system.label.base.companycode" default="법인코드"/>',			type : 'string'	, allowBlank:false, editable: false}
					 , {name : 'USER_ID',			text: '<t:message code="system.label.base.userid" default="사용자ID"/>',			type : 'string'	, allowBlank:false, editable: false}
					]
		});
		
		var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
			api: {
				read : 'bsa500ukrvService.selectProgramList',
				update: 'bsa500ukrvService.updatePrograms',
				create : 'bsa500ukrvService.insertPrograms',
				destroy: 'bsa500ukrvService.deletePrograms',
				syncAll: 'bsa500ukrvService.saveAll'
			}
		});
		
		var programStore = Unilite.createStore('bsa500ukrvProgramStore', { 
			model : 'bsa500ukrvProgramModel',
			autoLoad : false,
			uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
			proxy : directProxy
			,loadStoreRecords : function(mainCode)	{
				var param= Ext.getCmp('bsa500ukrvSearchForm').getValues();	
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
		var panelSearch = Unilite.createSearchForm('bsa500ukrvSearchForm',{
				
			layout : {type : 'uniTable', columns : 3},
				items : [ Unilite.popup('USER',{colspan:3, allowBlank:false, textFieldWidth:170, valueFieldWidth:100,
							listeners : {'onSelected': {
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
						, {fieldLabel : '<t:message code="system.label.base.programname" default="프로그램명"/>',	name : 'PGM_NAME'} 
						]
			});
		
		// create the Grid
		var masterGrid = Unilite.createGrid('bsa500ukrvMasterGrid', {
			store: directMasterStore,
			title : '<t:message code="system.label.base.programlist" default="프로그램 목록"/>',
			selModel :   Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false  }), 
			uniOpt:{
	        	onLoadSelectFirst: false
	        },
	        flex:2,
			columns : [   {dataIndex : 'PGM_ID',			width:100	}
						, {dataIndex : 'PGM_NAME',			width:200	}
						, {dataIndex : 'PGM_LEVEL',			width:100,		hidden : true	}
						, {dataIndex : 'PGM_LEVEL2',		width:100,		hidden : true	}
						, {dataIndex : 'AUTHO_USER',		width:100,		hidden : true	}
						, {dataIndex : 'UPDATE_MAN',		width:100,		hidden : true	}
						, {dataIndex : 'UPDATE_DATE',		width:100,		hidden : true	}
						, {dataIndex : 'AUTHO_TYPE',		width:100,		hidden : true	}
						, {dataIndex : 'AUTHO_PGM',			width:100,		hidden : true	}
						, {dataIndex : 'REF_CODE',			width:100,		hidden : true	}
						, {dataIndex : 'AUTHO_ID',			width:100,		hidden : true	}
						, {dataIndex : 'COMP_CODE',			width:100,		hidden : true	}
					]		
		});
		
	var programGrid =  Unilite.createGrid('bsa500ukrvDetailSystemGrid', {
			store : programStore,
			title : '<t:message code="system.label.base.availableprogram" default="사용가능 프로그램"/>',
	        selModel :   Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false  }), 			
			uniOpt:{
	        	onLoadSelectFirst : false
	        },
	        flex : 3,
			columns : [   /*{xtype : 'checkcolumn', text : '선택', dataIndex : 'selId', width:40}
						,*/ {dataIndex : 'PGM_ID',			width:100	}
						, {dataIndex : 'PGM_NAME',			width:180	}
						, {dataIndex : 'PGM_LEVEL',			width:80	,align : 'center'}
						, {dataIndex : 'PGM_LEVEL2',		width:80	,align : 'center'}
						, {dataIndex : 'AUTHO_USER',		width:100	,align : 'center'}
						, {dataIndex : 'UPDATE_MAN',		width:100,		hidden : true	}
						, {dataIndex : 'UPDATE_DATE',		width:100,		hidden : true	}
						, {dataIndex : 'AUTHO_TYPE',		width:100,		hidden : true	}
						, {dataIndex : 'AUTHO_PGM',			width:100,		hidden : true	}
						, {dataIndex : 'REF_CODE',			width:100,		hidden : true	}
						, {dataIndex : 'AUTHO_ID',			width:100,		hidden : true	}
						, {dataIndex : 'COMP_CODE',			width:100,		hidden : true	}
					]
		});

	var btnArea = { 	xtype : 'container',
						id:'bsa500ukrvBtn',
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
										            	//data.records.push(records[i].copy());
										            	var record = records[i].copy();
										            	record.phantom = true;	//selectedRecords 의 phantom 값이 4.2.2 에서는 기본 true, 5.1 에서는 false 임.
										            	data.records.push(record);							                
										            }
										        programGrid.getStore().insert(0, data.records);		
										        programGrid.getSelectionModel().select(data.records);
										        masterGrid.getStore().remove(records);
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
										            data.records = [];
										            for (i = 0, len = records.length; i < len; i++) {
										                //data.records.push(records[i].copy());
										            	var record = records[i].copy();
										            	record.phantom = true;	//selectedRecords 의 phantom 값이 4.2.2 에서는 기본 true, 5.1 에서는 false 임.
										            	data.records.push(record);											                
										            }
										      
										        masterGrid.getStore().insert(0, data.records);										      
										        masterGrid.getSelectionModel().select(data.records);
										        programGrid.getStore().remove(records);
										    }
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
				masterGrid.getStore().loadStoreRecords();
				programGrid.getStore().loadStoreRecords();
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
					Ext.getCmp('bsa500ukrvSearchForm').reset();
				}
		});

		Unilite.createValidator('bsa500ukrvValidator', {
		store : programStore,
		grid: programGrid,
		forms: {'formA:':bsa500ukrvSearchForm},
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