<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
//정비요청
request.setAttribute("PKGNAME","Unilite_app_gre100ukrv");
%>
<t:appConfig pgmId="gre100ukrv"  >
	<t:ExtComboStore comboType="BOR120"/>				<!-- 사업장   	-->  
	<t:ExtComboStore comboType="AU" comboCode="GO13"/>				<!-- 운행/폐지 구분  	-->	
	<t:ExtComboStore comboType="AU" comboCode="GO19"/>				<!-- 정비코드  	-->	
	<t:ExtComboStore comboType="AU" comboCode="GO21"/>				<!-- 결과판정  	-->	
	<t:ExtComboStore items="${ROUTE_COMBO}" storeId="routeStore" /> <!-- 노선 -->
</t:appConfig>
<script type="text/javascript">
var activeGrid;
function appMain() {
	Unilite.defineModel('${PKGNAME}model', {
	    fields: [
			 {name: 'DIV_CODE'   		,text:'사업장'			,type : 'string'  ,comboType: 'BOR120' ,allowBlank:false ,defaultValue: UserInfo.divCode} 
			,{name: 'REQUEST_NUM'    	,text:'정비요청번호'	,type : 'string'  ,editable:false } 
			,{name: 'REQUEST_DATE'    	,text:'요청일자'		,type : 'uniDate' ,allowBlank:false , defaultValue:UniDate.today()} 					
			,{name: 'VEHICLE_CODE'    	,text:'차량코드'		,type : 'string' } 	
			,{name: 'VEHICLE_NAME'    	,text:'차량'			,type : 'string' }
			,{name: 'DRIVER_CODE'    	,text:'기사코드'		,type : 'string' } 	
			,{name: 'DRIVER_NAME'    	,text:'기사'			,type : 'string' } 	
			,{name: 'ROUTE_CODE'    	,text:'노선'		,type : 'string' , store: Ext.data.StoreManager.lookup('routeStore')}
			,{name: 'COMMENTS'    		,text:'메모'			,type : 'string' }
			,{name: 'REMARK'  			,text:'비고'			,type : 'string' } 
			,{name: 'COMP_CODE'  		,text:'법인코드'		,type : 'string' ,allowBlank:false ,defaultValue: UserInfo.compCode} 
		]
	});
	
    var maintainStore =  Unilite.createStore('${PKGNAME}store',{
        model: '${PKGNAME}model',
         autoLoad: false,
            uniOpt : {
            	isMaster: false,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable:true,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            
            proxy: {
                type: 'direct',
                api: {
                	   read : 'gre100ukrvService.selectList'
                }
            },
      
			loadStoreRecords: function(requestNum)	{				
				var searchForm = Ext.getCmp('${PKGNAME}searchForm');
				var param= searchForm.getValues();
				if(searchForm.isValid())	{
					this.load({params: param,
						callback: function(records, operation, success) {
					        if (success) {
					        	if(requestNum)	{
					        		var index = maintainStore.find('REQUEST_NUM', requestNum);
					        		maintainGrid.select(index);
					        	}
					        }
						}
					
					});
				}		
			}
            
		});
	
	Unilite.defineModel('${PKGNAME}detailModel', {
	    fields: [
			 {name: 'DIV_CODE'   		,text:'사업장'			,type : 'string'  ,comboType: 'BOR120' ,allowBlank:false ,defaultValue: UserInfo.divCode} 
			,{name: 'REQUEST_NUM'    	,text:'정비요청번호'	,type : 'string'  ,editable:false } 
			,{name: 'REQUEST_SEQ'    	,text:'순번'			,type : 'int' ,editable:false} 
			,{name: 'MAINTAIN_CODE'    	,text:'정비코드'		,type : 'string' ,comboType: 'AU', comboCode:'GO19'} 					
			,{name: 'CONDITION'    		,text:'상태설명'		,type : 'string' } 					
			,{name: 'CHECK_RESULT'    	,text:'결과판정'		,type : 'string' ,comboType: 'AU', comboCode:'GO21'} 					
			,{name: 'REMARK'  			,text:'비고'			,type : 'string' } 
			,{name: 'COMP_CODE'  		,text:'법인코드'		,type : 'string' ,allowBlank:false ,defaultValue: UserInfo.compCode} 
		]
	});
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'gre100ukrvService.selectDetailList',
			update: 'gre100ukrvService.updateDetail',
			create: 'gre100ukrvService.insertDetail',
			destroy: 'gre100ukrvService.deleteDetail',
			syncAll: 'gre100ukrvService.saveAll'
		}
	});
    var detailStore =  Unilite.createStore('${PKGNAME}store',{
        model: '${PKGNAME}detailModel',
         autoLoad: false,
          uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:true,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            proxy: directProxy,
			loadStoreRecords: function(record)	{
				var param= {
					'DIV_CODE' : record.get('DIV_CODE'),
					'REQUEST_NUM': record.get('REQUEST_NUM')
				}
				this.load({params: param});			
			},
			saveStore:function(config)	{
				var paramMaster= masterForm.getValues();
				var inValidRecs = this.getInvalidRecords();
				console.log("inValidRecords : ", inValidRecs);
				if(inValidRecs.length == 0) {
					config = {
							params: [paramMaster],
							success: function(batch, option) {
								
								var master = batch.operations[0].getResultSet();
								masterForm.setValue("REQUEST_NUM", master.REQUEST_NUM);
								

								masterForm.getForm().wasDirty = false;
								masterForm.resetDirtyStatus();
								console.log("set was dirty to false");
								UniAppManager.setToolbarButtons('save', false);			
							 } 
					};
					this.syncAllDirect(config);
				}
			},
			listeners: {
				load:function()	{
					if(maintainStore.isDirty())	{
			    		UniApp.setToolbarButtons(['save'], true);			    		
			    	}
				}
			}
		});	
		
	var maintainGrid = Unilite.createGrid('${PKGNAME}grid', { 
		uniOpt:{
			useRowNumberer: false,
        	expandLastColumn: false,
            useMultipleSorting: false,
            onLoadSelectFirst: false,
            state: {
			   useState: false,   
			   useStateList: false  
			}            
        },
    	store: maintainStore,
		columns:[
			{dataIndex:'REQUEST_DATE'	,width: 80},
			{dataIndex:'VEHICLE_NAME'	,width: 80},
			{dataIndex:'DRIVER_NAME'	,width: 80},
			{dataIndex:'ROUTE_CODE'		,flex: 1}
		],
		listeners: {
			render: function(grid, eOpts) {
			    grid.getEl().on('click', function(e, t, eOpt) {
			    	if(activeGrid){
			    		activeGrid.getStore().uniOpt.isMaster = false;
			    	}
			    	activeGrid = grid;
			    	store = grid.getStore();
			    	store.uniOpt.isMaster = true;
			    	store.uniOpt.deletable = true;
			    	store._onStoreDataChanged(store);
			    	if(detailStore.isDirty())	{
			    		UniApp.setToolbarButtons(['save'], true);			    		
			    	}
			    });
			},
			beforedeselect: function( grid, record, index, eOpts )	{
				if(detailStore.isDirty())	{
					if(confirm(Msg.sMB061))	{
						UniAppManager.app.onSaveDataButtonDown();
						return false;
					}  else {
						UniAppManager.app.rejectSave();
					}
				}
			},
			deselect: function( model, record, index, eOpts )	{
				model.getStore().uniOpt.isMaster = false;
			},
      		selectionchange: function( grid, selected, eOpts ) {   
      				masterForm.clearForm();
      				masterForm.uniOpt.inLoading = true; 
					masterForm.getForm().load({params : selected[0].data,
										 success: function(form, action)	{
										 	masterForm.uniOpt.inLoading = false; 
										 }
										}
									   );
      				detailStore.loadStoreRecords(selected[0]);
			}
         }
   });	
	var panelSearch = Unilite.createSearchPanel('${PKGNAME}searchForm',{
		title: '정비요청정보',
        defaultType: 'uniSearchSubPanel',
        defaults: {
			autoScroll:true
	  	},
        width: 330,
		items: [{	
					title: '검색조건', 	
					id: 'search_panel1',
		   			itemId: 'search_panel1',
		   			height:140,
		           	layout: {type: 'uniTable', columns: 1, tableAttrs:{border:0, cellpadding:0, cellspacing:0}},
		           	defaultType: 'uniTextfield',  
		           	defaults:{
		           		labelWidth:90
		           	},
			    	items:[{	    
						fieldLabel: '사업장',
						name: 'DIV_CODE',
						xtype:'uniCombobox',
						comboType:'BOR120',
						value: UserInfo.divCode,
						allowBlank:false
					},{	    
						fieldLabel: '요청일자',
						name: 'REQUEST_DATE',
						xtype: 'uniDateRangefield',
			            startFieldName: 'REQUEST_DATE_FR',
			            endFieldName: 'REQUEST_DATE_TO',	
			            startDate: UniDate.get('startOfWeeK'),
			            endDate: UniDate.get('endOfWeeK'),
			            width:320
					},{
						xtype: 'container',
						layout:{type:'hbox', align:'stretch'},
						defaultType:'uniTextfield',
						items:[
							{	    
								fieldLabel: '차량코드',
								name: 'VEHICLE_CODE_FR',
								width:195
							},{
								xtype:'label', 
								text:'~', 
								width: '5', 
								style: 'margin-top: 3px!important;'
							},{	    
								fieldLabel: '차량',
								hideLabel:true,
								name: 'VEHICLE_CODE_TO'	,
								width:110
								
							}
						]
					},{	    
						fieldLabel: '기사',
						name: 'DRIVER_CODE'	
					}]				
				},maintainGrid]

	});	//end panelSearch    
   
    var masterForm = Unilite.createForm('${PKGNAME}Form', {
    	height:140,
    	disabled: false,
        layout : {type:'uniTable', columns:3},
        api: {
			load: gre100ukrvService.select,
			submit: gre100ukrvService.insertMaster
		},
		
        items:[
        	{	    
				fieldLabel: '사업장',
				name: 'DIV_CODE',
				xtype:'uniCombobox',
				comboType:'BOR120',
				value: UserInfo.divCode,
				allowBlank:false,
				listeners:{
					change:function(field, newValue, oldValue)	{
						var vehiclePopup = masterForm.down('#vehicle');
						var driverPopup = masterForm.down('#driver');
						vehiclePopup.setExtParam({'DIV_CODE':newValue});
					 	driverPopup.setExtParam({'DIV_CODE':newValue});
					}
				}
			},{
				fieldLabel: '요청번호',
				name: 'REQUEST_NUM',
				readOnly:true
			},{
				fieldLabel: '요청일자',
				name: 'REQUEST_DATE',
				xtype:'uniDatefield',
				allowBlank:false
			},
			Unilite.popup('VEHICLE',
						 {
						 	itemId:'vehicle',
						 	extParam:{'DIV_CODE': UserInfo.divCode}
						 }
			),
			{
				fieldLabel: '노선',
				name: 'ROUTE_CODE',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('routeStore')
			},
			Unilite.popup('DRIVER',
					 	 {
					 		itemId:'driver',
					 		extParam:{'DIV_CODE': UserInfo.divCode}
					 	 }
			),
			{
				fieldLabel: '메모',
				name: 'COMMENTS',
				xtype:'textareafield',
				width:750,
				height:70,
				colspan:3
			}
		],
		listeners:{
			uniOnChange:function( form, dirty, eOpts ) {
				UniAppManager.setToolbarButtons('save', true);
			}
		}
    });

    var detailGrid = Unilite.createGrid('${PKGNAME}detailGrid', {
    	flex:1,
		uniOpt:{
			useRowNumberer: false,
        	expandLastColumn: false,
            useMultipleSorting: false,
            onLoadSelectFirst: false,
        	state: {
			   useState: true,   
			   useStateList: true  
			}
        },
    	store: detailStore,
		columns: [
			{dataIndex:'REQUEST_SEQ'		,width: 65 },
			{dataIndex:'MAINTAIN_CODE'		,width: 150 },
			{dataIndex:'CONDITION'			,flex: 1},
			{dataIndex:'CHECK_RESULT'		,width: 150}
		],
		listeners:{
			render: function(grid, eOpts) {
			    grid.getEl().on('click', function(e, t, eOpt) {
			    	if(activeGrid){
			    		activeGrid.getStore().uniOpt.isMaster = false;
			    	}
			    	activeGrid = grid;
			    	store = grid.getStore();
			    	store.uniOpt.isMaster = true;
			    	store.uniOpt.deletable = true;
			    	store._onStoreDataChanged(store);
			    	if(maintainStore.isDirty())	{
			    		UniApp.setToolbarButtons(['save'], true);			    		
			    	}
			    });
			 }
		}
   });
	
      Unilite.Main({
		borderItems:[
	 		  panelSearch,
	 		  {
	 		  	region:'center',
	 		  	xtype:'container',
	 		  	layout:{type:'vbox', align:'stretch'},
	 		  	items:[
		 		  masterForm,
		 		  detailGrid
		 		]
	 		  }
		],
		id  : '${PKGNAME}ukrApp',
		autoButtonControl : false,
		fnInitBinding : function(params) {
			UniAppManager.setToolbarButtons(['print', 'excel'],false);
			UniAppManager.setToolbarButtons(['reset', 'newData' ],true);			
		},		
		onQueryButtonDown : function()	{
			detailGrid.reset();
			maintainStore.loadStoreRecords();
		},
		onPrevDataButtonDown:  function()	{
			detailGrid.selectPriorRow();
		},
		onNextDataButtonDown:  function()	{
			detailGrid.selectNextRow();
		},	
		onNewDataButtonDown:  function()	{	
			var requestNum = masterForm.getValue('REQUEST_NUM');			
			var r = {
				REQUEST_NUM :requestNum,
				REQUEST_SEQ : Unilite.nvl(detailStore.max('REQUEST_SEQ'),0)+1
			}
			detailGrid.createRow(r);
			
		},	
		onSaveDataButtonDown: function (config) {
			if(detailStore.isDirty())	{
				detailStore.saveStore(config);
			} else {
				var param = masterForm.getValues()
				if(masterForm.isValid())	{
					masterForm.submit({
						success:function(form, action)	{
							masterForm.uniOpt.inLoading = true;
							masterForm.getEl().unmask();
							if(action.result.success === true)	{
								UniAppManager.updateStatus(Msg.sMB011);
								UniAppManager.setToolbarButtons('save', false);
								masterForm.getForm().wasDirty = false;
								masterForm.resetDirtyStatus();
								maintainStore.loadStoreRecords(Ext.isEmpty(action.result.REQUEST_NUM) ? param['REQUEST_NUM']:action.result.REQUEST_NUM);
								
							}
							masterForm.uniOpt.inLoading = false;
						}
					});
				}else {
					var invalid = masterForm.getForm().getFields().filterBy(function(field) {
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
	
					   	alert(labelText+Msg.sMB083);
					   	invalid.items[0].focus();
					}
				}
			}
		},
		onDeleteDataButtonDown : function()	{
			if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				console.log("activeGrid(${PKGNAME}grid) :", activeGrid);
				if(activeGrid.getId() == '${PKGNAME}grid')	{
					if(!detailStore.isDirty())	{
						var record = activeGrid.getSelectedRecord();
						var param = {
							'DIV_CODE': record.get('DIV_CODE'),
							'REQUEST_NUM': record.get('REQUEST_NUM')
						}
						gre100ukrvService.checkDetail(param, function(provider, response){
							if(provider.CNT > 0)	{
								alert('정비상세내역이 존재하여 삭제할 수 없습니다.');
							}else {
								activeGrid.deleteSelectedRow();	
							}
						});
					} else {
						if(confirm(Msg.sMB061))	{
							UniAppManager.app.onSaveDataButtonDown();
							return false;
						}  else {
							UniAppManager.app.rejectSave();
						}
					}
				}else {
					activeGrid.deleteSelectedRow();			
				}
			}
		},
		onResetButtonDown:function() {
			var me = this;
			panelSearch.reset();
			maintainGrid.reset();
			detailGrid.reset();
			masterForm.clearForm();
			UniAppManager.setToolbarButtons('save',false);
		},
		rejectSave: function() {			
			masterForm.clearForm();	
			detailStore.rejectChanges();	
			detailStore.onStoreActionEnable();
		}
	});
	/*
	Unilite.createValidator('validator01', {
		store : masterStore,
		forms:{'formA':masterForm},
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			var rv = true;
			switch(fieldName)	{
				case 'DIV_CODE' :	
					
					var vehiclePopup = masterForm.down('#vehicle').getEditor();
					var driverPopup = masterForm.down('#driver').getEditor();
					vehiclePopup.setExtParam({'DIV_CODE':newValue});
				 	vehiclePopup.setExtParam({'DIV_CODE':newValue});
					break;
				default :
					break;
			}
			return rv;
		}
	}); // validator
	*/
}; // main

</script>