<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bsa500ukrv" >
	<t:ExtComboStore comboType="AU" comboCode="B003" /><!-- 자료수정 -->
	<t:ExtComboStore comboType="AU" comboCode="B006" /><!-- 파일저장 -->
	<t:ExtComboStore comboType="AU" comboCode="BS04" /><!-- 자료권한 -->
</t:appConfig>
<script type="text/javascript">
	
function appMain() {

		
		Unilite.defineModel('MasterCodeModel', {

			fields : [ {name : 'PGM_ID',			text : 'PGM_ID',			type : 'string'	, allowBlank:false}
					 , {name : 'PGM_NAME',			text : '프로그램명',		type : 'string' }
					 , {name : 'PGM_LEVEL',			text : '자료수정',			type : 'string', allowBlank:false, 	comboType:'AU', comboCode:'B003'}
					 , {name : 'PGM_LEVEL2',		text: '파일저장',			type : 'string', allowBlank:false, 	comboType:'AU', comboCode:'B006'}
					 , {name : 'AUTHO_USER',		text: '자료권한',			type : 'string', 	comboType:'AU', comboCode:'BS04'}
					 , {name : 'UPDATE_MAN',		text: '수정자',				type : 'string'		}
					 , {name : 'UPDATE_DATE',		text: '수정일',				type : 'string'		}
					 , {name : 'AUTHO_TYPE',		text: '권한형태',			type : 'string'		}
					 , {name : 'AUTHO_PGM',			text: '권한정의',			type : 'string'		}
					 , {name : 'REF_CODE',			text: '참조코드',			type : 'string'		}
					 , {name : 'AUTHO_ID',			text: '권한형태',			type : 'string'		}
					 , {name : 'COMP_CODE',			text: '법인코드',			type : 'string', allowBlank:false		}
					 , {name : 'USER_ID',			text: '사용자ID',			type : 'string'	, allowBlank:false}
					]
		});

		var directMasterStore = Unilite.createStore('bsa500ukrvMasterStore', { 
			model : 'MasterCodeModel',
			autoLoad : false,
			uniOpt : {
            	isMaster: false,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | newxt 버튼 사용
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
					alert(Msg.sMB083);
				
				}
			}
			
		});
			

		Unilite.defineModel('Bsa500ukrvProgramModel', {		
			
			fields : [ {name : 'PGM_ID',			text : 'PGM_ID',			type : 'string'	, allowBlank:false, editable: false}
					 , {name : 'PGM_NAME',			text : '프로그램명',		type : 'string' , editable: false}
					 , {name : 'PGM_LEVEL',			text : '자료수정',			type : 'string', allowBlank:false, 	comboType:'AU', comboCode:'B003'}
					 , {name : 'PGM_LEVEL2',		text: '파일저장',			type : 'string', allowBlank:false, 	comboType:'AU', comboCode:'B006'}
					 , {name : 'AUTHO_USER',		text: '자료권한',			type : 'string', 	comboType:'AU', comboCode:'BS04'}
					 , {name : 'UPDATE_MAN',		text: '수정자',				type : 'string' , editable: false}
					 , {name : 'UPDATE_DATE',		text: '수정일',				type : 'string' , editable: false}
					 , {name : 'AUTHO_TYPE',		text: '권한형태',			type : 'string'	, editable: false}
					 , {name : 'AUTHO_PGM',			text: '권한정의',			type : 'string'	, editable: false}
					 , {name : 'REF_CODE',			text: '참조코드',			type : 'string'	, editable: false}
					 , {name : 'AUTHO_ID',			text: '권한형태',			type : 'string'	, editable: false}
					 , {name : 'COMP_CODE',			text: '법인코드',			type : 'string'	, allowBlank:false, editable: false}
					 , {name : 'USER_ID',			text: '사용자ID',			type : 'string'	, allowBlank:false, editable: false}
						
						]
		});

		var programStore = Unilite.createStore('bsa500ukrvProgramStore', { 
			model : 'Bsa500ukrvProgramModel',
			autoLoad : false,
			uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | newxt 버튼 사용
            },
			proxy : {
				type : 'direct',
				api : {
					read : 'bsa500ukrvService.selectProgramList',
					
					create : 'bsa500ukrvService.insertPrograms',
					destroy: 'bsa500ukrvService.deletePrograms',					
					syncAll: 'bsa500ukrvService.syncAll'
					
				}
			}
			,loadStoreRecords : function(mainCode)	{
				var param= Ext.getCmp('bsa500ukrvSearchForm').getValues();	
					this.load({
						params : param
					});
				
			},saveStore : function()	{
					var inValidRecs = this.getInvalidRecords();
					if(inValidRecs.length == 0 )	{
						this.syncAll({success : function()	{
													if(userCodeStore.isDirty())	{
														userCodeStore.saveStore();
													}
												}
										});				
						
					}else {
						alert(Msg.sMB083);
					}
				
			}  
		});
		
				
   		// 검색
		var panelSearch = Unilite.createSearchForm('bsa500ukrvSearchForm',{
				
			layout : {type : 'uniTable', columns : 3},
				items : [ Unilite.popup('USER',{colspan:3, allowBlank:false, textFieldWidth:170, valueFieldWidth:100,
							listeners : {'onSelected': {
									                    fn: function(records, type ){
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
							
						  {fieldLabel : '법인코드',	name : 'COMP_CODE', hidden:true, value:'MASTER'},
						  {fieldLabel: '업무구분',		name : 'PGM_SEQ',		xtype:'uniCombobox',  comboType : 'AU', comboCode : 'B007'},
		       			  {fieldLabel : '프로그램 ID',	name : 'PGM_ID'}
						, {fieldLabel : '프로그램명',	name : 'PGM_NAME'} 
						]
			});
		
		
		// create the Grid
		var masterGrid = Unilite.createGrid('bsa500ukrvMasterGrid', {
			store: directMasterStore,
			title : '프로그램 목록',
			selModel :   Ext.create('Ext.selection.CheckboxModel', { checkOnly : false }), 
			uniOpt:{
	        	store : directMasterStore
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
			title : '사용가능 프로그램',
			uniOpt:{
	        	store : programStore
	        },
	        flex : 3,
	        selModel :   Ext.create('Ext.selection.CheckboxModel', { checkOnly : false }), 
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
									        
										       var records, data = new Object();
										        if (masterGrid.getSelectedRecords()) {
										        	
										            records = masterGrid.getSelectedRecords();
										            console.log("records : ", records);
										            data.records = [];
										            for (i = 0, len = records.length; i < len; i++) {
										                data.records.push(records[i].copy());
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
									        
										       var records, data = new Object();
										        if (programGrid.getSelectedRecords()) {
										            records = programGrid.getSelectedRecords();
										            data.records = [];
										            for (i = 0, len = records.length; i < len; i++) {
										                data.records.push(records[i].copy());
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
				defaults : {
					collapsible : false,
					split : true
				},
				items : [ masterGrid ,  btnArea, programGrid ]

			} ]
			,fnInitBinding : function() {
				UniAppManager.setToolbarButtons(['reset', 'newData'],true);
			}
			, onQueryButtonDown:function() {
				masterGrid.getStore().loadStoreRecords();
				programGrid.getStore().loadStoreRecords();
			}
			, onNewDataButtonDown : function()	{
				if(activeGridId == 'bsa500ukrvMasterGrid' )	{ 
					
					var r = masterGrid.createRow();
			    	
				}else if(activeGridId == 'bsa500ukrvDetailUserGrid') 	{
					var pRecord = masterGrid.getSelectedRecord();
					if( pRecord.data['SYSTEM_CODE_YN'] != '1')	{
						if(!pRecord.data['MAIN_CODE'] || pRecord.data['MAIN_CODE'] == '')
						{
							alert(Msg.sMB157)
							return;
						}
						var value = {'MAIN_CODE': pRecord.data['MAIN_CODE']};
						detailUserGrid.createRow(value);
					   }
				}
			}
			, onSaveDataButtonDown: function () {										
					 if(programStore.isDirty())	{
						programStore.saveStore();						
					 }
					
				}
			,
				onResetButtonDown:function() {
					detailUserGrid.reset();
					programGrid.reset();
					masterGrid.reset();
					Ext.getCmp('bsa500ukrvSearchForm').reset();
				}
		});
		
		var activeGridId = 'bsa500ukrvMasterGrid';

		Unilite.createValidator('bsa500ukrvValidator', {
		store : programStore,
		grid: programGrid,
		forms: {'formA:':bsa500ukrvSearchForm},
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName)  {
				case "USER_ID" :		// 거래처(약명)
					if(newValue == '')	{
						rv = Msg.sMB083;
					}
					break;
			}
			return rv;
		}
		});
		

};	// appMain
</script>