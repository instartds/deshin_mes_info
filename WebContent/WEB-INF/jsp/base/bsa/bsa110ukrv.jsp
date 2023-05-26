<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
//사용자 공통코드 등록
request.setAttribute("PKGNAME","Unilite_app_bsa110ukrv");
%>
<t:appConfig pgmId="bsa110ukrv" >
	<t:ExtComboStore comboType="AU" comboCode="B018" />
	<t:ExtComboStore comboType="AU" comboCode="B010" />
	<t:ExtComboStore items="${WORK_TYPE_COMBO}" storeId="bsa110ukrvWorkTypeList" desc="업무구분" />
</t:appConfig>
<script type="text/javascript">
	
function appMain() {
	
		Unilite.defineModel('${PKGNAME}MasterCodeModel', {
			fields : [ {name : 'MAIN_CODE',			text : '<t:message code="system.label.base.commancode" default="공통코드"/>',			type : 'string',    allowBlank:false, isPk:true,  pkGen:'user', readOnly:true	}
					 , {name : 'CODE_NAME',			text : '<t:message code="system.label.base.commancodename" default="공통코드명"/>',		type : 'string',	allowBlank:false  }
					 , {name : 'SYSTEM_CODE_YN',	text : '<t:message code="system.label.base.system" default="시스템"/>',			type : 'string',	allowBlank:false, editable:false, comboType : 'AU', comboCode : 'B018', defaultValue:'2'}
					 , {name : 'SUB_LENGTH',		text: '<t:message code="system.label.base.length" default="길이"/>',				type : 'int',		allowBlank:false}
					 , {name : 'REF_CODE1',			text: '<t:message code="system.label.base.refer1" default="관련1"/>',				type : 'string'		}
					 , {name : 'REF_CODE2',			text: '<t:message code="system.label.base.refer2" default="관련2"/>',				type : 'string'		}
					 , {name : 'REF_CODE3',			text: '<t:message code="system.label.base.refer3" default="관련3"/>',				type : 'string'		}
					 , {name : 'REF_CODE4',			text: '<t:message code="system.label.base.refer4" default="관련4"/>',				type : 'string'		}
					 , {name : 'REF_CODE5',			text: '<t:message code="system.label.base.refer5" default="관련5"/>',				type : 'string'		}
					 , {name : 'REF_CODE6',			text: '<t:message code="system.label.base.refer6" default="관련6"/>',				type : 'string'		}
					 , {name : 'REF_CODE7',			text: '<t:message code="system.label.base.refer7" default="관련7"/>',				type : 'string'		}
					 , {name : 'REF_CODE8',			text: '<t:message code="system.label.base.refer8" default="관련8"/>',				type : 'string'		}
					 , {name : 'REF_CODE9',			text: '<t:message code="system.label.base.refer9" default="관련9"/>',				type : 'string'		}
					 , {name : 'REF_CODE10',		text: '<t:message code="system.label.base.reter10" default="관련10"/>',				type : 'string'		} 
					 , {name : 'SUB_CODE',			text: '<t:message code="system.label.base.subcode" default="상세코드"/>',			type : 'string',		defaultValue:'$'	} 
					 , {name : 'USE_YN',			text: '<t:message code="system.label.base.useyn" default="사용여부"/>',			type : 'string',		defaultValue:'Y'	, comboType : 'AU', comboCode : 'B010'} 
					 , {name : 'SORT_SEQ',			text: '<t:message code="system.label.base.arrangeorder" default="정렬순서"/>',			type : 'string',		defaultValue:1 }
					]
		});
		var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
			api: {
				read 	: 'bsa100ukrvService.selectMasterCodeList',
				create 	: 'bsa100ukrvService.insertCodes',
				update 	: 'bsa100ukrvService.updateCodes',
				destroy	: 'bsa100ukrvService.deleteCodes',
				syncAll	: 'bsa100ukrvService.saveAll'
			}
		});
		var directMasterStore = Unilite.createStore('${PKGNAME}MasterStore', { 
			model : '${PKGNAME}MasterCodeModel',
			autoLoad : false,
			uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:true,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
			proxy : directProxy
			,loadStoreRecords : function()	{
				var param= panelSearch.getValues();	
				this.load({
					params : param
				});
			}
			,saveStore : function()	{
					var inValidRecs = this.getInvalidRecords();
					var config = {
						params:[panelSearch.getValues()],
						success : function()	{
									if(userCodeStore.isDirty())	{
										userCodeStore.saveStore();
									}
									var record = masterGrid.getSelectedRecords();
									if(record)	{
										masterGrid.setDetailGrd(masterGrid, record);
									}
								}
						}
					if(inValidRecs.length == 0 )	{
						this.syncAllDirect(config);				
						this.onStoreActionEnable();
					}else {
						Unilite.messageBox(Msg.sMB083);
					}
				
			}  
		});
		
		Unilite.defineModel('${PKGNAME}UserCodeModel', {
			fields : [ 	  {name : 'MAIN_CODE',		text : '<t:message code="system.label.base.commancode" default="공통코드"/>'	, allowBlank : false, readOnly:true}
						, {name : 'SUB_CODE',		text : '<t:message code="system.label.base.subcode" default="상세코드"/>'	, allowBlank : false, isPk:true,  pkGen:'user', readOnly:true}
						, {name : 'CODE_NAME',		text : '<t:message code="system.label.base.subcodename" default="상세코드명"/>'	, allowBlank : false}
						, {name : 'SYSTEM_CODE_YN',	text : '<t:message code="system.label.base.system" default="시스템"/>',	type : 'string',		comboType : 'AU', comboCode : 'B018', defaultValue:'2'}
						, {name : 'SORT_SEQ',		text: '<t:message code="system.label.base.arrangeorder" default="정렬순서"/>',	type : 'int',			defaultValue:1	, allowBlank : false}
						, {name : 'REF_CODE1',		text: '<t:message code="system.label.base.refer1" default="관련1"/>',		type : 'string'	}
						, {name : 'REF_CODE2',		text: '<t:message code="system.label.base.refer2" default="관련2"/>',		type : 'string'	}
						, {name : 'REF_CODE3',		text: '<t:message code="system.label.base.refer3" default="관련3"/>',		type : 'string'	}
						, {name : 'REF_CODE4',		text: '<t:message code="system.label.base.refer4" default="관련4"/>',		type : 'string'	}
						, {name : 'REF_CODE5',		text: '<t:message code="system.label.base.refer5" default="관련5"/>',		type : 'string'	}
						, {name : 'REF_CODE6',		text: '<t:message code="system.label.base.refer6" default="관련6"/>',		type : 'string'	}
						, {name : 'REF_CODE7',		text: '<t:message code="system.label.base.refer7" default="관련7"/>',		type : 'string'	}
						, {name : 'REF_CODE8',		text: '<t:message code="system.label.base.refer8" default="관련8"/>',		type : 'string'	}
						, {name : 'REF_CODE9',		text: '<t:message code="system.label.base.refer9" default="관련9"/>',		type : 'string'	}
						, {name : 'REF_CODE10',		text: '<t:message code="system.label.base.reter10" default="관련10"/>',		type : 'string'	} 
						, {name : 'USE_YN',			text: '<t:message code="system.label.base.useyn" default="사용여부"/>',	type : 'string',		defaultValue:'Y'	, allowBlank : false, comboType : 'AU', comboCode : 'B010'} 
						]
		});
		
		var directProxyDetail = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
			api: {
				read 	: 'bsa100ukrvService.selectDetailCodeList',
				create 	: 'bsa100ukrvService.insertCodes',
				update 	: 'bsa100ukrvService.updateCodes',
				destroy	: 'bsa100ukrvService.deleteCodes',
				syncAll	: 'bsa100ukrvService.saveAll'
			}
		});
		var userCodeStore = Unilite.createStore('${PKGNAME}UserStore', { 
			model : '${PKGNAME}UserCodeModel',
			autoLoad : false,
			uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:true,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
			proxy : directProxyDetail
			,loadStoreRecords : function(mainCode)	{
					Ext.getBody().mask();
					this.load({
						params : {
							'MAIN_CODE' : mainCode
						},
						callback:function()	{
							Ext.getBody().unmask();
						}
					});
				
			}
			,saveStore : function()	{
                    var inValidRecs = this.getInvalidRecords();
                    var config = {
                        params:[panelSearch.getValues()],
                        success : function()    {
                        	UniAppManager.setToolbarButtons('save', false);
                        }
                    }
                    if(inValidRecs.length == 0 )    {
                        this.syncAllDirect(config);             
                        this.onStoreActionEnable();
                    }else {
//                        Unilite.messageBox(Msg.sMB083);
                    }
//					userCodeStore.onStoreActionEnable();
//					this.syncAllDirect();					
			}
		});
		
		Unilite.defineModel('${PKGNAME}SystemCodeModel', {
			fields : [ 	  {name : 'MAIN_CODE',		text : '<t:message code="system.label.base.commancode" default="공통코드"/>'	}
						, {name : 'SUB_CODE',		text : '<t:message code="system.label.base.subcode" default="상세코드"/>'	}
						, {name : 'CODE_NAME',		text : '<t:message code="system.label.base.subcodename" default="상세코드명"/>'	}
						, {name : 'SYSTEM_CODE_YN',	text : '<t:message code="system.label.base.system" default="시스템"/>',	type : 'string',	comboType : 'AU', comboCode : 'B018'}
						, {name : 'SORT_SEQ',		text : '<t:message code="system.label.base.arrangeorder" default="정렬순서"/>',	type : 'int' }
						, {name : 'REF_CODE1',		text : '<t:message code="system.label.base.refer1" default="관련1"/>',		type : 'string'	}
						, {name : 'REF_CODE2',		text : '<t:message code="system.label.base.refer2" default="관련2"/>',		type : 'string'	}
						, {name : 'REF_CODE3',		text : '<t:message code="system.label.base.refer3" default="관련3"/>',		type : 'string'	}
						, {name : 'REF_CODE4',		text : '<t:message code="system.label.base.refer4" default="관련4"/>',		type : 'string'	}
						, {name : 'REF_CODE5',		text : '<t:message code="system.label.base.refer5" default="관련5"/>',		type : 'string'	}
						, {name : 'REF_CODE6',		text : '<t:message code="system.label.base.refer6" default="관련6"/>',		type : 'string'	}
						, {name : 'REF_CODE7',		text : '<t:message code="system.label.base.refer7" default="관련7"/>',		type : 'string'	}
						, {name : 'REF_CODE8',		text : '<t:message code="system.label.base.refer8" default="관련8"/>',		type : 'string'	}
						, {name : 'REF_CODE9',		text : '<t:message code="system.label.base.refer9" default="관련9"/>',		type : 'string'	}
						, {name : 'REF_CODE10',		text : '<t:message code="system.label.base.reter10" default="관련10"/>',		type : 'string'	} 
						, {name : 'USE_YN',			text : '<t:message code="system.label.base.useyn" default="사용여부"/>',	type : 'string',	 comboType : 'AU', comboCode : 'B010'} 
						]
		});

		var systemCodeStore = Unilite.createStore('${PKGNAME}SystemCodeStore', { 
			model : '${PKGNAME}SystemCodeModel',
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
					read : 'bsa100ukrvService.selectDetailCodeList'
					
				}
			}
			,loadStoreRecords : function(mainCode)	{
					Ext.getBody().mask();
					this.load({
						params : {
							MAIN_CODE : mainCode
						},
						callback:function()	{
							Ext.getBody().unmask();
						}
					});
				
			}
		});
		
				
   		// 검색
		var panelSearch = Unilite.createSearchForm('${PKGNAME}SearchForm',{
				
				layout : {type : 'uniTable' , columns: 3 },
				items : [ { fieldLabel: '<t:message code="system.label.base.businessclassification" default="업무구분"/>',		 name: 'WORK_TYPE',		xtype:'uniCombobox',  store: Ext.data.StoreManager.lookup('bsa110ukrvWorkTypeList')},
		       			  {fieldLabel : '<t:message code="system.label.base.commancode" default="공통코드"/>',		name : 'MAIN_CODE'}
						, {fieldLabel : '<t:message code="system.label.base.commancodename" default="공통코드명"/>',	name : 'MAIN_CODE_NAME'} 
						]
			});
		
		
		// create the Grid
		var masterGrid = Unilite.createGrid('${PKGNAME}MasterGrid', {
			store: directMasterStore,
			uniOpt:{
	        	expandLastColumn: false
	        },
	        itemId:'${PKGNAME}MasterGrid',
			columns : [   {dataIndex : 'MAIN_CODE',			width : 80		}
						, {dataIndex : 'CODE_NAME',			width : 150		}
						, {dataIndex : 'SUB_LENGTH',		width : 40		}
						, {dataIndex : 'SYSTEM_CODE_YN',	flex : 1,		align:'center'}
					],
			listeners : {
				render: function(grid, eOpts){
				 	var girdNm = grid.getItemId();
				 	var store = grid.getStore();
				    grid.getEl().on('click', function(e, t, eOpt) {
				    	activeGridId = girdNm;
				    	store.onStoreActionEnable();
				    });
				 }
				// 종합코드의 select가 변경될 경우 이전 선택된 상세코드에 저장할 내용이 있는지 확인
				,beforedeselect : function ( gird, record, index, eOpts )
								{
									var detailStore = Ext.getCmp('${PKGNAME}DetailUserGrid').getStore();	
									if(detailStore.isDirty())	{
										if(confirm(Msg.sMB017 + "\n" + Msg.sMB061))	{
											var inValidRecs = detailStore.getInvalidRecords();
											if(inValidRecs.length > 0 )	{
												Unilite.messageBox(Msg.sMB083);
												return false;
											}else {
												detailStore.saveStore();
											}
										}
									}
								}
				,selectionchange : function(model, selected, eOpts) {
					if(selected.length != 0){
							if( selected[0].data['SYSTEM_CODE_YN'] == '1')	{ 
								this.getStore().uniOpt.deleteable = false;
							} else {
								this.getStore().uniOpt.deleteable = true;
							}
							this.setDetailGrd( selected, eOpts);
							
						}
			        }
				},
				 setDetailGrd : function ( selected, eOpts) {
								if(selected.length > 0)	{
									var record = selected[0];
									var sysDetailgrid = Ext.getCmp('${PKGNAME}DetailSystemGrid');	
									var userDetailgrid = Ext.getCmp('${PKGNAME}DetailUserGrid');	
									if(record.data['SYSTEM_CODE_YN'] == '1')	{
										userDetailgrid.getStore().loadData({});
										for(var i =1; i<11; i++) {
											this.setColumnHeader(record,sysDetailgrid,'REF_CODE'+i,'관련'+i);
										}
										for(var i =1; i<11; i++) {
											this.setColumnHeader(null,userDetailgrid,'REF_CODE'+i,'관련'+i);
										}
										sysDetailgrid.getStore().loadStoreRecords(record.data['MAIN_CODE']);
									}else {
										sysDetailgrid.getStore().loadData({});
										for(var i =1; i<11; i++) {
											this.setColumnHeader(record,userDetailgrid,'REF_CODE'+i,'관련'+i);
										}
										for(var i =1; i<11; i++) {
											this.setColumnHeader(null,sysDetailgrid,'REF_CODE'+i,'관련'+i);
										}
										userDetailgrid.getStore().loadStoreRecords(record.data['MAIN_CODE']);
									}
								}
							}
				, setColumnHeader:function(record, grid, indexName, def) {
					var d ;
					if(!Ext.isEmpty(record))	{
						d = record.get(indexName);
					}
					var column = grid.getColumn(indexName);
	
					if(Ext.isEmpty(column))  {
						return ;
					}
					if(!Ext.isEmpty(d)) {
						column.setText(d);
					} else {
						column.setText(def);
					}
				}
			/*	, setDetailGrd : function (grid, selected, eOpts) {
									
									 
									if(selected.length > 0)	{
										var record = selected[0];
										var view ;
										if(record.data['SYSTEM_CODE_YN'] == '1')	{
											 Ext.getCmp('${PKGNAME}DetailUserGrid').reset();
											 view  = Ext.getCmp('${PKGNAME}DetailSystemGrid');
											 view2 = Ext.getCmp('${PKGNAME}DetailUserGrid');	
											 view2.columns[5].setText('<t:message code="system.label.base.refer1" default="관련1"/>');											
											 view2.columns[6].setText('<t:message code="system.label.base.refer2" default="관련2"/>');												
											 view2.columns[7].setText('<t:message code="system.label.base.refer3" default="관련3"/>');													
											 view2.columns[8].setText('<t:message code="system.label.base.refer4" default="관련4"/>');													
											 view2.columns[9].setText('<t:message code="system.label.base.refer5" default="관련5"/>');													
											 view2.columns[10].setText('<t:message code="system.label.base.refer6" default="관련6"/>');		
											 view2.columns[11].setText('<t:message code="system.label.base.refer7" default="관련7"/>');		
											 view2.columns[12].setText('<t:message code="system.label.base.refer8" default="관련8"/>');		
											 view2.columns[13].setText('<t:message code="system.label.base.refer9" default="관련9"/>');		
											 view2.columns[14].setText('<t:message code="system.label.base.reter10" default="관련10"/>');
											 
											 UniAppManager.setToolbarButtons( 'delete',false);
									
										}else {
											 Ext.getCmp('${PKGNAME}DetailSystemGrid').reset();
											 view  = Ext.getCmp('${PKGNAME}DetailUserGrid');
											 
											 view2 = Ext.getCmp('${PKGNAME}DetailSystemGrid');	
											 view2.columns[5].setText('<t:message code="system.label.base.refer1" default="관련1"/>');											
											 view2.columns[6].setText('<t:message code="system.label.base.refer2" default="관련2"/>');												
											 view2.columns[7].setText('<t:message code="system.label.base.refer3" default="관련3"/>');													
											 view2.columns[8].setText('<t:message code="system.label.base.refer4" default="관련4"/>');													
											 view2.columns[9].setText('<t:message code="system.label.base.refer5" default="관련5"/>');													
											 view2.columns[10].setText('<t:message code="system.label.base.refer6" default="관련6"/>');		
											 view2.columns[11].setText('<t:message code="system.label.base.refer7" default="관련7"/>');		
											 view2.columns[12].setText('<t:message code="system.label.base.refer8" default="관련8"/>');		
											 view2.columns[13].setText('<t:message code="system.label.base.refer9" default="관련9"/>');		
											 view2.columns[14].setText('<t:message code="system.label.base.reter10" default="관련10"/>');
										}
										
										( record.data['REF_CODE1'] || record.data['REF_CODE1'] !='')  ?	view.columns[5].setText(record.data['REF_CODE1']) : view.columns[5].setText('<t:message code="system.label.base.refer1" default="관련1"/>');											
										( record.data['REF_CODE2'] || record.data['REF_CODE2'] !='')  ?	view.columns[6].setText(record.data['REF_CODE2']) : view.columns[6].setText('<t:message code="system.label.base.refer2" default="관련2"/>');												
										( record.data['REF_CODE3'] || record.data['REF_CODE3'] !='')  ?	view.columns[7].setText(record.data['REF_CODE3']) : view.columns[7].setText('<t:message code="system.label.base.refer3" default="관련3"/>');													
										( record.data['REF_CODE4'] || record.data['REF_CODE4'] !='')  ?	view.columns[8].setText(record.data['REF_CODE4']) : view.columns[8].setText('<t:message code="system.label.base.refer4" default="관련4"/>');													
										( record.data['REF_CODE5'] || record.data['REF_CODE5'] !='')  ?	view.columns[9].setText(record.data['REF_CODE5']) : view.columns[9].setText('<t:message code="system.label.base.refer5" default="관련5"/>');													
										( record.data['REF_CODE6'] || record.data['REF_CODE6'] !='')  ?	view.columns[10].setText(record.data['REF_CODE6']) : view.columns[10].setText('<t:message code="system.label.base.refer6" default="관련6"/>');		
										( record.data['REF_CODE7'] || record.data['REF_CODE7'] !='')  ?	view.columns[11].setText(record.data['REF_CODE7']) : view.columns[11].setText('<t:message code="system.label.base.refer7" default="관련7"/>');		
										( record.data['REF_CODE8'] || record.data['REF_CODE8'] !='')  ?	view.columns[12].setText(record.data['REF_CODE8']) : view.columns[12].setText('<t:message code="system.label.base.refer8" default="관련8"/>');		
										( record.data['REF_CODE9'] || record.data['REF_CODE9'] !='')  ?	view.columns[13].setText(record.data['REF_CODE9']) : view.columns[13].setText('<t:message code="system.label.base.refer9" default="관련9"/>');		
										( record.data['REF_CODE10'] || record.data['REF_CODE10'] !='')?	view.columns[14].setText(record.data['REF_CODE10']) : view.columns[14].setText('<t:message code="system.label.base.reter10" default="관련10"/>');												
										
										view.getStore().loadStoreRecords(record.data['MAIN_CODE']);
									}
								}*/
			
			
		});
		
		var detailUserGrid =  Unilite.createGrid('${PKGNAME}DetailUserGrid', {
			store : userCodeStore,
			itemId:'${PKGNAME}DetailUserGrid',
			uniOpt:{
	        	expandLastColumn: false
	        },
			title : '<t:message code="system.label.base.useruse" default="사용자 사용"/>',
			columns : [ {dataIndex : 'id',		width: 130,			hidden: true}
						, {	dataIndex : 'MAIN_CODE',		width : 130	, hidden : true}
						, {	dataIndex : 'SUB_CODE',			width : 130	}
						, {	dataIndex : 'CODE_NAME',		width : 200,		tooltip : true	}
						, {	dataIndex : 'SORT_SEQ',			width : 80	}
						, {	dataIndex : 'REF_CODE1',		width : 110,		hidden : false	}
						, {	dataIndex : 'REF_CODE2',		width : 110,		hidden : false	}
						, {	dataIndex : 'REF_CODE3',		width : 110,		hidden : false	}
						, {	dataIndex : 'REF_CODE4',		width : 110,		hidden : false	}
						, {	dataIndex : 'REF_CODE5',		width : 110,		hidden : false	}
						, {	dataIndex : 'REF_CODE6',		width : 110,		hidden : false	}
						, {	dataIndex : 'REF_CODE7',		width : 110,		hidden : false	}
						, {	dataIndex : 'REF_CODE8',		width : 110,		hidden : false	}
						, {	dataIndex : 'REF_CODE9',		width : 110,		hidden : false	}
						, {	dataIndex : 'REF_CODE10',		width : 110,		hidden : false	}  
						, {	dataIndex : 'USE_YN',			width : 110		}  
					],
			listeners : {
				render: function(grid, eOpts){
				 	var girdNm = grid.getItemId();
				 	var store = grid.getStore();
				    grid.getEl().on('click', function(e, t, eOpt) {
				    	activeGridId = girdNm;
				    	store.onStoreActionEnable();
				    });
				 }
				 /*
				// 그리드밖의 빈 공간을 클릭하여 포커스를 변경 할  경우 버튼 상세그리드로 콘트롤 적용
				containerclick : function ( girdView, The, eOpts )	{
					var pRecord = masterGrid.getSelectedRecord();
					if( pRecord.data['SYSTEM_CODE_YN'] != '1')	{ 
						activeGridId = this.getId();
						console.log("activeGridId : ", activeGridId);
						this.getStore().onStoreActionEnable();
						UniAppManager.setToolbarButtons( 'newData',true);
					}
				}
				// 그리드의 셀을 클릭하여 포커스를 변경 할 경우 버튼 상세그리드로 콘트롤 적용
				,cellclick: function( viewTable, td, cellIndex, record, tr, rowIndex, e, eOpts )	{
					var pRecord = masterGrid.getSelectedRecord();
					if( pRecord.data['SYSTEM_CODE_YN'] != '1')	{ 
						activeGridId = this.getId();
						console.log("activeGridId : ", activeGridId);
						this.getStore().onStoreActionEnable();
						UniAppManager.setToolbarButtons( 'newData',true);
					}
				}*/
			}
		});
		
	var detailSystemGrid =  Unilite.createGrid('${PKGNAME}DetailSystemGrid', {
			store : systemCodeStore,
			itemId:'${PKGNAME}DetailSystemGrid',
			uniOpt:{
	        	expandLastColumn: false
	        },
			title : '<t:message code="system.label.base.systemuse" default="시스템 사용"/>',
			columns : [ {dataIndex : 'id',		width: 130,			hidden: true}
						, {	dataIndex : 'MAIN_CODE',		width : 130	, hidden : true}
						, {	dataIndex : 'SUB_CODE',			width : 130	}
						, {	dataIndex : 'CODE_NAME',		width : 200,		tooltip : true	}
						, {	dataIndex : 'REF_CODE1',		width : 110,		hidden : false	}
						, {	dataIndex : 'REF_CODE2',		width : 110,		hidden : false	}
						, {	dataIndex : 'REF_CODE3',		width : 110,		hidden : false	}
						, {	dataIndex : 'REF_CODE4',		width : 110,		hidden : false	}
						, {	dataIndex : 'REF_CODE5',		width : 110,		hidden : false	}
						, {	dataIndex : 'REF_CODE6',		width : 110,		hidden : false	}
						, {	dataIndex : 'REF_CODE7',		width : 110,		hidden : false	}
						, {	dataIndex : 'REF_CODE8',		width : 110,		hidden : false	}
						, {	dataIndex : 'REF_CODE9',		width : 110,		hidden : false	}
						, {	dataIndex : 'REF_CODE10',		width : 110,		hidden : false	}  
						, {	dataIndex : 'USE_YN',			width : 110		}  
					],
			listeners : {
				render: function(grid, eOpts){
				 	var girdNm = grid.getItemId();
				 	var store = grid.getStore();
				    grid.getEl().on('click', function(e, t, eOpt) {
				    	activeGridId = girdNm;
				    	store.onStoreActionEnable();
				    });
				 }
				 /*
				// 그리드밖의 빈 공간을 클릭하여 포커스를 변경 할  경우 버튼 상세그리드로 콘트롤 적용
				containerclick : function ( girdView, The, eOpts )	{
					var pRecord = masterGrid.getSelectedRecord();
					if( pRecord.data['SYSTEM_CODE_YN'] == '1')	{ 
						activeGridId = this.getId();
						console.log("activeGridId : ", activeGridId);
						this.getStore().onStoreActionEnable();
						UniAppManager.setToolbarButtons( 'newData',false);
					}
				}
				// 그리드의 셀을 클릭하여 포커스를 변경 할 경우 버튼 상세그리드로 콘트롤 적용
				,cellclick: function( viewTable, td, cellIndex, record, tr, rowIndex, e, eOpts )	{
					var pRecord = masterGrid.getSelectedRecord();
					if( pRecord.data['SYSTEM_CODE_YN'] == '1')	{ 
						activeGridId = this.getId();
						console.log("activeGridId : ", activeGridId);
						this.getStore().onStoreActionEnable();
						UniAppManager.setToolbarButtons( 'newData',false);
					}
				}*/
			}
		});

		
    Unilite.Main({
			items : [ panelSearch, {
				xtype : 'container',
				flex : 1,
				layout : 'border',
				defaults : {
					collapsible : false,
					split : true
				},
				items : [ {
					region : 'west',
					xtype : 'container',
					width : 350,
					layout: 'fit',
					title : 'title',
					items : [ masterGrid ]
				}, {
					region : 'center',
					xtype : 'container',
					layout : 'fit',
					flex : 1,
					
					items : [ detailUserGrid ]
				}, {
					region : 'south',
					xtype : 'container',
					layout : 'fit',
					region: 'south',
            		weight: -100,
					flex : 1,
					
					items : [ detailSystemGrid ]
				} ]

			} ]
			,fnInitBinding : function() {
				UniAppManager.setToolbarButtons(['reset', 'newData'],true);
			}
			, onQueryButtonDown:function() {
				masterGrid.getStore().loadStoreRecords();
			}
			, onNewDataButtonDown : function()	{
				if(activeGridId == '${PKGNAME}MasterGrid' )	{ 
					var r = masterGrid.createRow();
			    	
				}else if(activeGridId == '${PKGNAME}DetailUserGrid') 	{
					var pRecord = masterGrid.getSelectedRecord();
					if( pRecord.data['SYSTEM_CODE_YN'] != '1')	{
						if(!pRecord.data['MAIN_CODE'] || pRecord.data['MAIN_CODE'] == '')
						{
							Unilite.messageBox(Msg.sMB157)
							return;
						}
						var value = {'MAIN_CODE': pRecord.data['MAIN_CODE']};
						  detailUserGrid.createRow(value);
					   }
				}
			}
			, onSaveDataButtonDown: function () {										
					if(directMasterStore.isDirty())	{									
						directMasterStore.saveStore();	//Master 데이타 저장 성공 후 Detail 저장함.			
					}else if(userCodeStore.isDirty())	{
						userCodeStore.saveStore();						
					}
					
				}
			, onDeleteDataButtonDown : function()	{
					if(confirm(Msg.sMB045))	{
						if(activeGridId == '${PKGNAME}MasterGrid' )	{
							var selIndex = masterGrid.getSelectedRowIndex();
							var record = masterGrid.getSelectedRecord();
							
							if(record.phantom !== true && 
								(directMasterStore.isDirty() && record.data['SYSTEM_CODE_YN'] == '1') || 
							   	(!directMasterStore.isDirty() && record.data['SYSTEM_CODE_YN'] == '1')
							  )	
							{
								Unilite.messageBox(Msg.sMB088);
							}else if(userCodeStore.getCount() > 0 ) {
								
								Unilite.messageBox(Msg.sMB161);
							}else {
								masterGrid.deleteSelectedRow(selIndex);
								
								masterGrid.getStore().onStoreActionEnable();
							}
						} else {
							var selIndex = detailUserGrid.getSelectedRowIndex();
							var record = detailUserGrid.getSelectedRecord();
							
							if(record.phantom !== true && 
								(userCodeStore.isDirty() && record.data['SYSTEM_CODE_YN'] == '1') || 
							   	(!userCodeStore.isDirty() && record.data['SYSTEM_CODE_YN'] == '1')
							   )	
							{
								Unilite.messageBox(Msg.sMB088);
							}else {
								detailUserGrid.deleteSelectedRow(selIndex);	
								
								detailUserGrid.getStore().onStoreActionEnable();
							}
						}
					}
					
				},
				onResetButtonDown:function() {
					detailUserGrid.getStore().loadData({});
					detailSystemGrid.getStore().loadData({});
					masterGrid.getStore().loadData({});
					panelSearch.reset();
				}
		});
		
		var activeGridId = '${PKGNAME}MasterGrid';

		
		

};	// appMain
</script>