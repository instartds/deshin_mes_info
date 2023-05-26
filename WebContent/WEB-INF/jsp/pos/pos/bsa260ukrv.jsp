<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
//프리셋등록
request.setAttribute("PKGNAME","Unilite_app_bsa260ukrv");
%>
<t:appConfig pgmId="bsa260ukrv" >
	<t:ExtComboStore comboType="BOR120" pgmId="bsa260ukrv"/><!-- 사업장   	-->  

</t:appConfig>
<script type="text/javascript">

var outDivCode = UserInfo.divCode;
var aa = 0;
var bb = 0;
function appMain() {

		Unilite.defineModel('${PKGNAME}MasterCodeModel', {
			fields : [ {name : 'COMP_CODE',			text : '법인코드',				type : 'string' }
					 , {name : 'DIV_CODE',			text : '사업장',				type : 'string' ,comboType:"BOR120"}
					 , {name : 'GROUP_CODE',		text : '프리셋그룹코드',			type : 'string' }
					 , {name : 'GROUP_NAME',		text : '프리셋그룹코드명칭',		type : 'string'	,allowBlank: false}
					 , {name : 'DEPT_CODE' ,		text : '부서',				type : 'string'	}
					 , {name : 'DEPT_NAME' ,		text : '부서명',				type : 'string'	}
					]
		});
		
		var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
			api: {
				read : 	 'bsa260ukrvService.selectMasterCodeList',
				create : 'bsa260ukrvService.insertCodes',
				update : 'bsa260ukrvService.updateCodes',
				destroy: 'bsa260ukrvService.deleteCodes',
				syncAll: 'bsa260ukrvService.saveAll'
			}
		});
		
		var directMasterStore = Unilite.createStore('${PKGNAME}MasterStore', { 
			model : '${PKGNAME}MasterCodeModel',
			autoLoad : false,
			uniOpt : {
            	isMaster: false,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:true,			// 삭제 가능 여부 
	            useNavi : false			// prev | newxt 버튼 사용
            },
			proxy : directProxy,
			loadStoreRecords: function() {
				var param= Ext.getCmp('searchForm').getValues();
				var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
				var deptCode = UserInfo.deptCode;	//부서코드
				if(authoInfo == "5" && Ext.isEmpty(panelSearch.getValue('DEPT_CODE'))){
					param.DEPT_CODE = deptCode;
				}
				console.log( param );
				this.load({
					params: param
				});
			},
			saveStore : function()	{
					var inValidRecs = this.getInvalidRecords();
					var toCreate = this.getNewRecords();
					Ext.each(toCreate, function(cRecord, index){
       					cRecord.STATUS = 'create';
       				});
       				var toUpdate = this.getUpdatedRecords();       			
       				var toDelete = this.getRemovedRecords();
					var list = [].concat(toUpdate,toCreate);
					
					var listLength = list.length;
					if(inValidRecs.length == 0 )	{
						
						var config = {
									params:[panelSearch.getValues()],
									success : function()	{
										masterGrid.getStore().loadStoreRecords();
										/*if(directDetailStore.isDirty())	{
											directDetailStore.saveStore();
											detailGrid.getStore().loadStoreRecords();
										}*/
										/*var record = masterGrid.getSelectedRecords();
										if(record)	{
											masterGrid.setDetailGrd(masterGrid, record);
										}*/
									}
								}
						this.syncAllDirect(config);			
					}else {
						var grid = Ext.getCmp('${PKGNAME}Grid');
						grid.uniSelectInvalidColumnAndAlert(inValidRecs);
					}
				
			},
			listeners:{
				load: function(store, records, successful, eOpts) {
	           		if(records != null && records.length > 0 ){
	           			//masterGrid.getSelectedRowIndex();//(records[0]);
	           			UniAppManager.setToolbarButtons('delete', true);
	           		}
				},
				update : function( store, record, operation, modifiedFieldNames, details, eOpts ){
					UniAppManager.setToolbarButtons('save', true);		
				},
				datachanged : function(store,  eOpts) {
					if( directDetailStore.isDirty() || store.isDirty())	{
						UniAppManager.setToolbarButtons('save', true);	
					}else {
						UniAppManager.setToolbarButtons('save', false);
					}
				}
			}  
		});
		
		Unilite.defineModel('DetailCodeModel', {
			fields : [ 	
						  {name : 'COMP_CODE',		text : '법인코드'  ,type : 'string' }
						, {name : 'DIV_CODE',		text : '사업장',	type : 'string' ,comboType:"BOR120"}
				 		, {name : 'GROUP_CODE',		text : '프리셋그룹코드'  ,type : 'string' }
						, {name : 'PRESET_CODE',	text : '프리셋코드'	 	,type : 'string' /*maxLength: 5*/}
						, {name : 'ITEM_CODE',		text : '품목코드' 		,type : 'string' }
						, {name : 'ITEM_NAME',		text : '품목명칭'	 	,type : 'string' }
						, {name : 'SALE_BASIS_P',	text : '단가'    		,type : 'uniPrice' }
						, {name : 'DEPT_CODE' ,		text : '부서',		type : 'string'	}
					 	, {name : 'DEPT_NAME' ,		text : '부서명',		type : 'string'	}
						
						]
		});
		var directProxyDetail = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
			api: {
				read 	: 'bsa260ukrvService.selectDetailCodeList',
				create 	: 'bsa260ukrvService.DetailinsertCodes',
				update 	: 'bsa260ukrvService.DetailupdateCodes',
				destroy	: 'bsa260ukrvService.DetaildeleteCodes',
				syncAll	: 'bsa260ukrvService.saveAll'
			}
		});
		var directDetailStore = Unilite.createStore('directDetailStore', { 
			model : 'DetailCodeModel',
			autoLoad : false,
			uniOpt : {
            	isMaster: false,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:true,			// 삭제 가능 여부 
	            useNavi : false			// prev | newxt 버튼 사용
            },
			proxy : directProxyDetail
			,loadStoreRecords : function(compCode, groupCode, divCode, deptCode)	{
					this.load({
						params : {
							 COMP_CODE  : compCode
							,GROUP_CODE : groupCode
							,DIV_CODE   : divCode
							,DEPT_CODE  : deptCode
						}
					});		
			}
			,saveStore : function()	{
					var inValidRecs = this.getInvalidRecords();
					var toCreate = this.getNewRecords();
					Ext.each(toCreate, function(cRecord, index){
       					cRecord.STATUS = 'create';
       				});
       				var toUpdate = this.getUpdatedRecords();       			
       				var toDelete = this.getRemovedRecords();
					var list = [].concat(toUpdate,toCreate);
					
					var listLength = list.length;
					if(inValidRecs.length == 0 )	{
						
						var config = {
									params:[panelSearch.getValues()],
									success : function()	{
										//masterGrid.getSelectedRecord();
										
										//masterGrid.getStore().loadStoreRecords();
									}
								}
						this.syncAllDirect(config);			
					}else {
						var grid = Ext.getCmp('${PKGNAME}Grid');
						grid.uniSelectInvalidColumnAndAlert(inValidRecs);
					}					
			},
			listeners:{
				load: function(store, records, successful, eOpts) {
	           		if(records != null && records.length > 0 ){
	           			UniAppManager.setToolbarButtons('delete', true);
	           		}
				},
				update : function( store, record, operation, modifiedFieldNames, details, eOpts ){
					UniAppManager.setToolbarButtons('save', true);		
				},
				datachanged : function(store,  eOpts) {
					if( directMasterStore.isDirty() || store.isDirty() )	{
						UniAppManager.setToolbarButtons('save', true);	
					}else {
						UniAppManager.setToolbarButtons('save', false);
					}
				}
			}
		});

		// create the Grid
		var masterGrid = Unilite.createGrid('${PKGNAME}Grid', {
			enableColumnMove: false,
			store: directMasterStore,
			excelTitle:'프리셋등록(그룹코드)',
			uniOpt:{
				useRowNumberer: true,
	        	expandLastColumn: true
	        },
	        itemId:'${PKGNAME}Grid',
			columns : [   {dataIndex : 'COMP_CODE',			width : 100		,hidden:true}
						, {dataIndex : 'DIV_CODE',			width : 100		,hidden:true}
						, {dataIndex : 'DEPT_CODE',			width : 100		,hidden:true ,
							editor: Unilite.popup('DEPT_G', {
			  				extParam: {DIV_CODE: UserInfo.divCode},
							listeners: {'onSelected': {
									fn: function(records, type) {
					                    console.log('records : ', records);
					                    var grdRecord = masterGrid.getSelectedRecord();
					                     Ext.each(records, function(record,i) {													                   
											        			if(i==0) {
																	masterGrid.setItemData(record,false, masterGrid.uniOpt.currentRecord);
											        			} else {
											        				UniAppManager.app.onNewDataButtonDown();
											        				masterGrid.setItemData(record,false, masterGrid.getSelectedRecord());
											        			}
											}); 
									},
									scope: this
										},
									'onClear': function(type) {
										masterGrid.setItemData(null,true, masterGrid.uniOpt.currentRecord);
									}
								}
							})
						}
						, {dataIndex : 'DEPT_NAME',			width : 110		,
						editor: Unilite.popup('DEPT_G', {
		  				extParam: {DIV_CODE: UserInfo.divCode},
						listeners: {'onSelected': {
								fn: function(records, type) {
				                    console.log('records : ', records);
				                    var grdRecord = masterGrid.getSelectedRecord();
				                     Ext.each(records, function(record,i) {													                   
											        			if(i==0) {
																	masterGrid.setItemData(record,false, masterGrid.uniOpt.currentRecord);
											        			} else {
											        				UniAppManager.app.onNewDataButtonDown();
											        				masterGrid.setItemData(record,false, masterGrid.getSelectedRecord());
											        			}
											}); 
									},
									scope: this
										},
									'onClear': function(type) {
										masterGrid.setItemData(null,true, masterGrid.uniOpt.currentRecord);
									}
							}
						})
					 }
						, {dataIndex : 'GROUP_CODE',		width : 100		,hidden:true}
						, {dataIndex : 'GROUP_NAME',		width : 150		}
						
					],
			listeners : {
				render: function(grid, eOpts){
				 	var girdNm = grid.getItemId()
				    grid.getEl().on('click', function(e, t, eOpt) {
				    	if(directDetailStore.isDirty()){
		        			alert(Msg.sMB154);
		        		}else {
				    		activeGridId = girdNm;
				    		if(grid.getStore().getCount() > 0)	{
								UniAppManager.setToolbarButtons('delete', true);		
							}else {
								UniAppManager.setToolbarButtons('delete', false);
							}
		        		}
				    	
				    });
				  
				},
				
				
				/*render: function(grid, eOpts){
				 	var girdNm = grid.getItemId();
				 	var store = grid.getStore();
				    grid.getEl().on('click', function(e, t, eOpt) {
				    	activeGridId = girdNm;
				    	//store.onStoreActionEnable();
				    	if( directMasterStore.isDirty() || directDetailStore.isDirty() )	{
							UniAppManager.setToolbarButtons('save', true);	
						}else {
							UniAppManager.setToolbarButtons('save', false);
						}
				    	if(grid.getStore().getCount() > 0)	{
							UniAppManager.setToolbarButtons('delete', true);		
						}else {
							UniAppManager.setToolbarButtons('delete', false);
						}
				    });
				 },*/ 
				 beforeedit  : function( editor, e, eOpts ) {
		        	if(e.record.phantom == false || !e.record.phantom == false) {
		        		if(UniUtils.indexOf(e.field, ['COMP_CODE','COMP_NAME', 'DIV_CODE' ,'GROUP_CODE'])) 
						{ 
							return false;
	      				} 
		        	}
				}
		
				,beforedeselect : function ( gird, record, index, eOpts )
								{
									var detailStore = Ext.getCmp('${PKGNAME}DetailGrid').getStore();	
									if(detailStore.isDirty())	{
										if(confirm(Msg.sMB017 + "\n" + Msg.sMB061))	{
											var inValidRecs = detailStore.getInvalidRecords();
											if(inValidRecs.length > 0 )	{
												alert(Msg.sMB083);
												return false;
											}else {
												detailStore.saveStore();
											}
										}
									}
								}
				,selectionchange : function(grid, selected, eOpts) {
								this.setDetailGrd( selected, eOpts)	;						
								
							}
			}
			, setDetailGrd : function (selected, eOpts) {
								if(selected.length > 0)	{
									var dgrid = Ext.getCmp('${PKGNAME}DetailGrid');	
									var record = selected[0];
									/*for(var i =1; i<11; i++) {
										this.setColumnHeader(record,dgrid,'REF_CODE'+i,'관련'+i);
									}*/
									dgrid.getStore().loadStoreRecords(
									record.data['COMP_CODE'],
									record.data['GROUP_CODE'],record.data['DIV_CODE'],record.data['DEPT_CODE'],record.data['DEPT_NAME'] );
								}
							}
			, setColumnHeader:function(record, grid, indexName, def) {
				var d = record.get(indexName);
				var column = grid.getColumn(indexName);

				if(Ext.isEmpty(column))  {
					return ;
				}
				if(!Ext.isEmpty(d)) {
					column.setText(d);
				} else {
					column.setText(def);
				}
			}, setItemData: function(record, dataClear, grdRecord) {
//			var grdRecord = this.uniOpt.currentRecord;			
       			if(dataClear) {
	       			grdRecord.set('DEPT_CODE'		,"");
	       			grdRecord.set('DEPT_NAME'		,"");
	       		} else {
	       			grdRecord.set('DEPT_CODE'			, record['TREE_CODE']);
	       			grdRecord.set('DEPT_NAME'			, record['TREE_NAME']);
	       		}
			 }	
		});
		
		var detailGrid =  Unilite.createGrid('${PKGNAME}DetailGrid', {
			enableColumnMove: false,
			excelTitle:'프리셋 등록(프리셋코드)',
			itemId:'${PKGNAME}DetailGrid',
			store : directDetailStore,
			selModel: Ext.create('Ext.selection.CheckboxModel', {
	        	checkOnly: true,
	        	toggleOnClick: false
			}),
			uniOpt:{
	        	expandLastColumn: true

	        },
			columns : [   { dataIndex : 'COMP_CODE',			width : 130, hidden:true}
						, { dataIndex : 'GROUP_CODE',			width : 130, hidden:true}
						, {	dataIndex : 'DIV_CODE',				width : 130, hidden:true}
						, {	dataIndex : 'PRESET_CODE',			width : 130, hidden:true}
						, {	dataIndex : 'DEPT_NAME',			width : 130, hidden:true}
						, {	dataIndex : 'ITEM_CODE',			width : 130,
						editor: Unilite.popup('DIV_PUMOK_G', {
							textFieldName: 'ITEM_CODE',
			 							DBtextFieldName: 'ITEM_CODE',
			 							extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode, POPUP_TYPE: 'GRID_CODE'},
			 							//validateBlank: false,
			 							useBarcodeScanner: false,
										listeners: {'onSelected': {
														fn: function(records, type) {
																console.log('records : ', records);
																Ext.each(records, function(record,i) {
																		console.log('record',record);
																		if(i==0) {
																			detailGrid.setItemData(record,false, detailGrid.uniOpt.currentRecord);
																			
																		} else {
																			UniAppManager.app.onNewDataButtonDown();
																			detailGrid.setItemData(record,false, detailGrid.getSelectedRecord());
																		}
																					
																					
																});
																
															},
														scope: this									
														},
													'onClear': function(type) {
																	var a = masterGrid.uniOpt.currentRecord.get('ITEM_CODE');
																	
																//	detailGrid.setItemData(null,true, detailGrid.uniOpt.currentRecord);
																//	if(masterGrid.uniOpt.currentRecord.get('ITEM_CODE') != ''){
																	detailGrid.uniOpt.currentRecord.set('ITEM_CODE',a);
																	if(aa == 0){
																//	alert(a);
																		if(a != ''){
																			alert("미등록상품입니다.");
																			aa++;
																		}
																	}else{
																		aa=0;	
																	}
											
																}
										}
								})
			}
						, {	dataIndex : 'ITEM_NAME',			width : 300,
						editor: Unilite.popup('DIV_PUMOK_G', {
			 							extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode},
										listeners: {'onSelected': {
														fn: function(records, type) {
											                    console.log('records : ', records);
											                    Ext.each(records, function(record,i) {													                   
																        			if(i==0) {
																						detailGrid.setItemData(record,false, detailGrid.uniOpt.currentRecord);
																        			} else {
																        				UniAppManager.app.onNewDataButtonDown();
																        				detailGrid.setItemData(record,false, detailGrid.getSelectedRecord());
																        			}
																}); 
															},
														scope: this
														},
													'onClear': function(type) {
																	var b = detailGrid.uniOpt.currentRecord.get('ITEM_NAME');
																	
																//	detailGrid.setItemData(null,true, detailGrid.uniOpt.currentRecord);
																//	if(masterGrid.uniOpt.currentRecord.get('ITEM_CODE') != ''){
																	detailGrid.uniOpt.currentRecord.set('ITEM_NAME',b);
																	if(bb == 0){
																//	alert(a);
																		if(b != ''){
																			alert("미등록상품입니다.");
																			bb++;
																		}
																	}else{
																		bb=0;	
																	}
											
																}
															}
								})
			}
						, {	dataIndex : 'SALE_BASIS_P',			width : 150} 
					],
			listeners : {
				render: function(grid, eOpts){
				 	var girdNm = grid.getItemId()
				    grid.getEl().on('click', function(e, t, eOpt) {
				    	if(directMasterStore.isDirty()){
		        			alert(Msg.sMB154);
		        		}else {
				    		activeGridId = girdNm;
				    		if(grid.getStore().getCount() > 0)	{
								UniAppManager.setToolbarButtons('delete', true);		
							}else {
								UniAppManager.setToolbarButtons('delete', false);
							}
		        		}
				    	
				    });
				  
				},
				/*render: function(grid, eOpts){
				 	var girdNm = grid.getItemId();
				 	var store = grid.getStore();
				    grid.getEl().on('click', function(e, t, eOpt) {
				    	activeGridId = girdNm;
				    	if( directMasterStore.isDirty() || directDetailStore.isDirty() )	{
							UniAppManager.setToolbarButtons('save', true);	
						}else {
							UniAppManager.setToolbarButtons('save', false);
						}
				    	if(grid.getStore().getCount() > 0)	{
							UniAppManager.setToolbarButtons('delete', true);		
						}else {
							UniAppManager.setToolbarButtons('delete', false);
						}
				    });
				 },*/
				 beforeedit  : function( editor, e, eOpts ) {  // 기존 Preset_code 는 수정불가
		        	if(e.record.phantom == false ) {
		        		if(UniUtils.indexOf(e.field, ['COMP_CODE','DEPT_CODE','PRESET_CODE','ITEM_NAME', 'SALE_BASIS_P', 'GROUP_CODE' , 'DIV_CODE','DEPT_NAME'])) 
						{ 
							return false;
	      				} 
		        	}else if(!e.record.phantom == false) {
		        		if(UniUtils.indexOf(e.field, ['GROUP_CODE','COMP_CODE','DIV_CODE','DEPT_NAME','DEPT_CODE' ,'PRESET_CODE'])) 
						{ 
							return false;
	      				} 
		        	}
				}
				
			}, 
			setItemData: function(record, dataClear, grdRecord) {
//			var grdRecord = this.uniOpt.currentRecord;			
       			if(dataClear) {
	       			grdRecord.set('ITEM_CODE'		,"");
	       			grdRecord.set('ITEM_NAME'		,"");
	       			grdRecord.set('SALE_BASIS_P'    ,"");
	       		} else {
	       			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
	       			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
	       			grdRecord.set('SALE_BASIS_P'		, record['SALE_BASIS_P']);
	       		}
			 }	
		});
		
		
	var panelSearch = Unilite.createSearchForm('searchForm',{
			
			layout : {type : 'uniTable' , columns: 3 },
			items : [{
		        		fieldLabel: '사업장',
		        		name: 'DIV_CODE',
		        		//value : UserInfo.divCode,
		        		xtype: 'uniCombobox',
		        		comboType: 'BOR120',
		        		holdable: 'hold',
		        		allowBlank: false
		        		/*listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
								panelResult.setValue('DIV_CODE', newValue);
							}
						}*/
		        	},
		        	Unilite.popup('DEPT',{
					fieldLabel: '부서',
					valueFieldName: 'DEPT_CODE',
					textFieldName: 'DEPT_NAME',
		        	allowBlank: false,
					listeners: {
						/*onSelected: {
							fn: function(records, type) {
								panelResult.setValue('DEPT_CODE', panelSearch.getValue('DEPT_CODE'));
								panelResult.setValue('DEPT_NAME', panelSearch.getValue('DEPT_NAME'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('DEPT_CODE', '');
							panelResult.setValue('DEPT_NAME', '');
						},*/
						applyextparam: function(popup){							
							var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
							var deptCode = UserInfo.deptCode;	//부서정보
							var divCode = '';					//사업장
							
							if(authoInfo == "A"){	
								popup.setExtParam({'DEPT_CODE': ""});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
								
							}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
								popup.setExtParam({'DEPT_CODE': ""});
								popup.setExtParam({'DIV_CODE': panelSearch.getValue('BILL_DIV_CODE')});
								
							}else if(authoInfo == "5"){		//부서권한
								popup.setExtParam({'DEPT_CODE': deptCode});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
							}
						}
					}
			}),{
        		fieldLabel: '프리셋그룹명칭',
        		name: 'GROUP_NAME',
        		xtype: 'uniTextfield'
        		//allowBlank: false,
        		/*listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('GROUP_NAME', newValue);
					}
				}*/
        	}]
		});
		
		
	
	/*var panelResult = Unilite.createSearchForm('panelResultForm', {
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
	    	items: [{
        		fieldLabel: '사업장',
        		name: 'DIV_CODE',
        		holdable: 'hold',
        		value : UserInfo.divCode,
        		xtype: 'uniCombobox',
        		comboType: 'BOR120',
        		allowBlank: false,
        		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('DIV_CODE', newValue);
					}
				}
        	},
        		Unilite.popup('DEPT',{
					fieldLabel: '부서',
					valueFieldName: 'DEPT_CODE',
					textFieldName: 'DEPT_NAME',
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelSearch.setValue('DEPT_CODE', panelResult.getValue('DEPT_CODE'));
								panelSearch.setValue('DEPT_NAME', panelResult.getValue('DEPT_NAME'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelSearch.setValue('DEPT_CODE', '');
							panelSearch.setValue('DEPT_NAME', '');
						},
						applyextparam: function(popup){							
							var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
							var deptCode = UserInfo.deptCode;	//부서정보
							var divCode = '';					//사업장
							
							if(authoInfo == "A"){	//자기사업장	
								popup.setExtParam({'DEPT_CODE': ""});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
								
							}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
								popup.setExtParam({'DEPT_CODE': ""});
								popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
								
							}else if(authoInfo == "5"){		//부서권한
								popup.setExtParam({'DEPT_CODE': UserInfo.deptCode});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
							}
						}
					}
			}),{
        		fieldLabel: '프리셋그룹명칭',
        		name: 'GROUP_NAME',
        		xtype: 'uniSearchForm',
        		//allowBlank: false,
        		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('GROUP_NAME', newValue);
					}
				}
        	}]
    });*/
		
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
					layout : 'fit',
					items : [ masterGrid ]
				}, {
					region : 'center',
					xtype : 'container',
					layout : 'fit',
					flex : 1,
					items : [ detailGrid ]
				} ]

			} ]
			,fnInitBinding : function() {
				UniAppManager.setToolbarButtons(['reset', 'newData'],true);
				panelSearch.setValue('DIV_CODE', UserInfo.divCode);
				panelSearch.setValue('DEPT_CODE', UserInfo.deptCode);
				panelSearch.setValue('DEPT_NAME', UserInfo.deptName);
			}
			, onQueryButtonDown:function() {
				//if(!UniAppManager.app._needSave())	{
					masterGrid.getStore().loadStoreRecords();
					//detailGrid.getStore().loadStoreRecords();
					//detailGrid.reset();	
					//detailGrid.getStore().loadData({});
					
				//}
			}
			, onNewDataButtonDown : function()	{
				if(activeGridId == '${PKGNAME}Grid' )	{ 
					
					var compCode   = UserInfo.compCode; 
					var divCode    = panelSearch.getValue('DIV_CODE');
					var deptCode   = panelSearch.getValue('DEPT_CODE');
					var deptName   = panelSearch.getValue('DEPT_NAME');
	
	            	var r = {
	            	 	COMP_CODE:		compCode,
	            	 	DIV_CODE:		divCode,
	            	 	DEPT_CODE: 		deptCode,
	            	 	DEPT_NAME:      deptName
			        };
					masterGrid.createRow(r);

			    	
				}else if(activeGridId == '${PKGNAME}DetailGrid') 	{
					var pRecord = masterGrid.getSelectedRecord();
					if(pRecord != null)	{
						var value = {
							'COMP_CODE'  : pRecord.data['COMP_CODE'],
							'GROUP_CODE' : pRecord.data['GROUP_CODE'],
							'DIV_CODE'   : pRecord.data['DIV_CODE'],
							'DEPT_CODE'  : pRecord.data['DEPT_CODE'],
							'DEPT_NAME'  : pRecord.data['DEPT_NAME']};
						detailGrid.createRow(value);
					}else {
						alert('프리셋그룹코드를 선택하세요.');
					}
				}
			}
			, onSaveDataButtonDown: function () {										
					if(directMasterStore.isDirty())	{									
						directMasterStore.saveStore();	//Master 데이타 저장 성공 후 Detail 저장함.			
					}
					else if(directDetailStore.isDirty())	{
						directDetailStore.saveStore();						
					}
				}
			, onDeleteDataButtonDown : function()	{
					if(confirm(Msg.sMB045))	{
						if(activeGridId == '${PKGNAME}Grid' )	{
							var selIndex = masterGrid.getSelectedRowIndex();
							var record = masterGrid.getSelectedRecord();
						 
							//masterGrid.deleteSelectedRow(selIndex);
							
							if(directDetailStore.getCount() > 0 ) {
								alert(Msg.sMB161);
							}else {
								masterGrid.deleteSelectedRow(selIndex);
							}
						} else {
							var selIndex = detailGrid.getSelectedRowIndex();   /* 삭제 여부를 묻고 바로 삭제 하게 처리 */
							var record = detailGrid.getSelectedRecord();
							
							detailGrid.deleteSelectedRow(selIndex);	
							
							/*if(record.phantom !== true)	
							{
								alert(Msg.sMB088);
							}else {
								detailGrid.deleteSelectedRow(selIndex);	
							}*/
						}
					}
					
				},
				onResetButtonDown:function() {
					panelSearch.clearForm();
					masterGrid.getStore().loadData({});
					detailGrid.getStore().loadData({});
					masterGrid.reset();
					detailGrid.reset();	
					
					this.fnInitBinding();
				}	
		});
		
		
	var activeGridId = '${PKGNAME}Grid';
	
	var validation = Unilite.createValidator('validator01', {
			store: directDetailStore,
			grid: detailGrid,
			validate: function( type, fieldName, newValue, oldValue, record, detailGrid, editor, e) {
				console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
				var rv = true;
				switch(fieldName) {
					
					case "PRESET_CODE" :	
						if(!Ext.isEmpty(newValue) && newValue.length > 5 ){
					 		rv = '프리셋코드는 5자리 이하만 가능합니다.';
					 		break;
					 	}   	
	
						if(isNaN(newValue)){
							rv = Msg.sMB074;	//숫자만 입력 가능합니다.
							break;
						}
					 	break;	 	
			}
			return rv;
		}
	}); // validator
};	// appMain
</script>