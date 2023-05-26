<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
//정비요청
request.setAttribute("PKGNAME","Unilite_app_gre200ukrv");
%>
<t:appConfig pgmId="gre200ukrv"  >
	<t:ExtComboStore comboType="BOR120"/>				<!-- 사업장   	-->  
	<t:ExtComboStore comboType="AU" comboCode="GO19"/>				<!-- 정비코드  	-->	
	<t:ExtComboStore comboType="AU" comboCode="GO22"/>				<!-- 작업구분  	-->	
	<t:ExtComboStore comboType="AU" comboCode="GO23"/>				<!-- 작업지  	-->	
	<t:ExtComboStore comboType="AU" comboCode="GO24"/>				<!-- 작업근거  	-->	
	<t:ExtComboStore comboType="AU" comboCode="GO25"/>				<!-- 주야간구분  	-->	
	<t:ExtComboStore comboType="AU" comboCode="GO26"/>				<!-- 난이도  	-->	
	<t:ExtComboStore comboType="AU" comboCode="A020"/>				<!-- 예/아니오 	-->
	<t:ExtComboStore items="${ROUTE_COMBO}" storeId="routeStore" /> <!-- 노선 -->
</t:appConfig>
<script type="text/javascript">
var activePanel;
function appMain() {
	Unilite.defineModel('${PKGNAME}model', {
	    fields: [
			 {name: 'DIV_CODE'   			,text:'사업장'			,type : 'string'  ,comboType: 'BOR120' ,allowBlank:false ,defaultValue: UserInfo.divCode} 
			,{name: 'MAINTAIN_NUM'    		,text:'정비번호'		,type : 'string'  ,editable:false } 
			,{name: 'MAINTAIN_DATE'    		,text:'정비일'			,type : 'uniDate' ,allowBlank:false , defaultValue:UniDate.today()} 					
			,{name: 'VEHICLE_NAME'    		,text:'차량'			,type : 'string' }
			,{name: 'VEHICLE_COUNT'    		,text:'댓수'			,type : 'string' }
			,{name: 'MAINTAIN_TYPE'    		,text:'구분'			,type : 'string' ,comboType: 'AU', comboCode:'GO22'}
			
			,{name: 'MECHANIC_TEAM'			,text:'정비팀'			,type : 'string' } 	
			,{name: 'MAINTAIN_PLACE'    	,text:'작업지'			,type : 'string' ,comboType: 'AU', comboCode:'GO23'}
			,{name: 'MAINTAIN_GROUND'    	,text:'작업근거'			,type : 'string' ,comboType: 'AU', comboCode:'GO24'}
			,{name: 'COMP_CODE'  			,text:'법인코드'		,type : 'string' ,allowBlank:false ,defaultValue: UserInfo.compCode} 
		]
	});
	
    var maintainStore =  Unilite.createStore('${PKGNAME}store',{
        model: '${PKGNAME}model',
         autoLoad: false,
            uniOpt : {
            	isMaster: false,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            
            proxy: {
                type: 'direct',
                api: {
                	   read : 'gre200ukrvService.selectList'
                }
            },
      
			loadStoreRecords: function(record)	{				
				var searchForm = Ext.getCmp('${PKGNAME}searchForm');
				var param= searchForm.getValues();
				if(searchForm.isValid())	{
					this.load({params: param});
				}		
			}
            
		});
	
	Unilite.defineModel('${PKGNAME}detailModel', {
	    fields: [
			 {name: 'DIV_CODE'   		,text:'사업장'			,type : 'string'  ,comboType: 'BOR120' ,allowBlank:false ,defaultValue: UserInfo.divCode} 
			,{name: 'MAINTAIN_NUM'    	,text:'정비요청번호'	,type : 'string'  ,editable:false } 
			,{name: 'MAINTAIN_SEQ'    	,text:'순번'			,type : 'int' ,editable:false} 
			,{name: 'MAINTAIN_CODE'    	,text:'정비코드'		,type : 'string' ,comboType: 'AU', comboCode:'GO19'} 					
			,{name: 'TASK_DESC'    		,text:'작업내역'		,type : 'string' } 					
			,{name: 'DIFFICULTY'    	,text:'난이도'			,type : 'string' ,comboType: 'AU', comboCode:'GO26'} 					
			,{name: 'ASSIGNED_TIME'    	,text:'할당시간'		,type : 'string' } 					
			,{name: 'NEXT_SCHEDULD'    	,text:'차기예정일'		,type : 'uniDate' } 					
			,{name: 'REMARK'  			,text:'비고'			,type : 'string' } 
			,{name: 'COMP_CODE'  		,text:'법인코드'		,type : 'string' ,allowBlank:false ,defaultValue: UserInfo.compCode} 
		]
	});

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'gre200ukrvService.selectDetailList',
			update: 'gre200ukrvService.updateDetail',
			create: 'gre200ukrvService.insertDetail',
			destroy: 'gre200ukrvService.deleteDetail',
			syncAll: 'gre200ukrvService.saveAll'
		}
	});
    var detailStore =  Unilite.createStore('${PKGNAME}detailStore',{
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
					'MAINTAIN_NUM': record.get('MAINTAIN_NUM')
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
								masterForm.setValue("MAINTAIN_NUM", master.MAINTAIN_NUM);
								

								masterForm.getForm().wasDirty = false;
								masterForm.resetDirtyStatus();
								console.log("set was dirty to false");
								UniAppManager.setToolbarButtons('save', false);			
							 } 
					};
					this.syncAllDirect(config);
				}
			}
		});	

		
	Unilite.defineModel('${PKGNAME}itemModel', {
	    fields: [
			 {name: 'DIV_CODE'   		,text:'사업장'			,type : 'string'  ,comboType: 'BOR120' ,allowBlank:false ,defaultValue: UserInfo.divCode} 
			,{name: 'MAINTAIN_NUM'    	,text:'정비요청번호'	,type : 'string'  ,editable:false } 
			,{name: 'ITEM_CODE'    		,text:'부품코드'		,type : 'int' 	  ,editable:false} 
			,{name: 'ITEM_NAME'    		,text:'부품명'			,type : 'string' ,comboType: 'AU', comboCode:'GO19'} 					
			,{name: 'PART'    			,text:'위치'			,type : 'string' } 					
			,{name: 'QUILTY'    		,text:'품질'			,type : 'string' } 					
			,{name: 'QTY'    			,text:'수량'			,type : 'string' } 					
			,{name: 'OUT_PLACE'    		,text:'출고처'			,type : 'string' } 					
			,{name: 'COMP_CODE'  		,text:'법인코드'		,type : 'string' ,allowBlank:false ,defaultValue: UserInfo.compCode} 
		]
	});
	
	

	var itemDirectProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'gre200ukrvService.selectDetailList',
			update: 'gre200ukrvService.updateDetail',
			create: 'gre200ukrvService.insertDetail',
			destroy: 'gre200ukrvService.deleteDetail',
			syncAll: 'gre200ukrvService.saveAll'
		}
	});
    var itemStore =  Unilite.createStore('${PKGNAME}itemStore',{
        model: '${PKGNAME}itemModel',
         autoLoad: false,
          uniOpt : {
            	isMaster: false,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:true,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
	            
            },
            proxy: itemDirectProxy,
			loadStoreRecords: function(record)	{
				var param= {
					'DIV_CODE' : record.get('DIV_CODE'),
					'MAINTAIN_NUM': record.get('MAINTAIN_NUM')
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
								masterForm.setValue("MAINTAIN_NUM", master.REQUEST_NUM);
								

								masterForm.getForm().wasDirty = false;
								masterForm.resetDirtyStatus();
								console.log("set was dirty to false");
								UniAppManager.setToolbarButtons('save', false);			
							 } 
					};
					this.syncAllDirect(config);
				}
			}
		});	
	
		Unilite.defineModel('${PKGNAME}mechenicModel', {
	    fields: [
			 {name: 'DIV_CODE'   		,text:'사업장'		,type : 'string'  ,comboType: 'BOR120' ,allowBlank:false ,defaultValue: UserInfo.divCode} 
			,{name: 'MAINTAIN_NUM'    	,text:'정비번호'	,type : 'string' } 
			,{name: 'MECHANIC_CODE'    	,text:'사번'		,type : 'string' ,allowBlank:false, isPk:true, pkGen:'user'} 					
			,{name: 'MECHANIC_NAME'    	,text:'성명'		,type : 'string' ,allowBlank:false, isPk:true, pkGen:'user'} 					
			,{name: 'RECORD_YN'    		,text:'기록'		,type : 'string'  ,comboType: 'AU', comboCode:'A020'} 					
			,{name: 'COMP_CODE'  		,text:'법인코드'	,type : 'string' ,allowBlank:false ,defaultValue: UserInfo.compCode} 
		]
	});
	

	var mechenicDirectProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'gre200ukrvService.selectMechanicList',
			update: 'gre200ukrvService.updateMechanic',
			create: 'gre200ukrvService.insertMechanic',
			destroy: 'gre200ukrvService.deleteMechanic',
			syncAll: 'gre200ukrvService.saveMechanicAll'
		}
	});
    var mechenicStore =  Unilite.createStore('${PKGNAME}mechenicStore',{
        model: '${PKGNAME}mechenicModel',
         autoLoad: false,
          uniOpt : {
            	isMaster: false,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:true,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            proxy: mechenicDirectProxy,
			loadStoreRecords: function(record)	{
				var param= {
					'DIV_CODE' : record.get('DIV_CODE'),
					'MAINTAIN_NUM': record.get('MAINTAIN_NUM')
				}
				this.load({params: param});			
			},
			saveStore:function(config)	{
				var paramMaster= masterForm.getValues();
				var inValidRecs = this.getInvalidRecords();
				console.log("inValidRecords : ", inValidRecs);
				if(inValidRecs.length == 0) {
					this.syncAllDirect(config);
				}
			},
			listeners:{
				update: function( store )	{
					masterForm.setValue('MECHANIC_NUMBER', store.count());
				},
				datachanged: function( store ) {
					masterForm.setValue('MECHANIC_NUMBER', store.count());
				},
				load: function( store ) {
					masterForm.setValue('MECHANIC_NUMBER', store.count());
				}
			}
		});	
		
	var maintainGrid = Unilite.createGrid('${PKGNAME}grid', { 
		uniOpt:{
			useRowNumberer: false,
        	expandLastColumn: false,
            useMultipleSorting: false,
            state: {
			   useState: false,   
			   useStateList: false  
			}
            
        },
    	store: maintainStore,
		columns:[
			{dataIndex:'MAINTAIN_NUM'		,width: 80},
			{dataIndex:'MAINTAIN_DATE'		,width: 80},
			{dataIndex:'VEHICLE_NAME'		,width: 80},
			{dataIndex:'VEHICLE_COUNT'		,width: 80},
			{dataIndex:'MAINTAIN_TYPE'		,width: 80},
			{dataIndex:'MECHANIC_TEAM'		,width: 80},
			{dataIndex:'MAINTAIN_PLACE'		,width: 80},
			{dataIndex:'MAINTAIN_GROUND'	,flex: 1}
		],
		listeners: {
			beforedeselect: function( grid, record, index, eOpts )	{
				if(UniAppManager.app._needSave())	{
					if(confirm(Msg.sMB061))	{
						UniAppManager.app.onSaveDataButtonDown();
						return false;
					}  else {
						UniAppManager.app.rejectSave();
					}
				}
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
      				mechenicStore.loadStoreRecords(selected[0]);
			}
         }
   });	
	var panelSearch = Unilite.createSearchPanel('${PKGNAME}searchForm',{
		title: '정비내역',
        defaultType: 'uniSearchSubPanel',
        defaults: {
			autoScroll:true
	  	},
        width: 330,
		items: [{	
					title: '검색조건', 	
					id: 'search_panel1',
		   			itemId: 'search_panel1',
		   			height:170,
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
						fieldLabel: '정비일자',
						name: 'MAINTAIN_DATE',
						xtype: 'uniDateRangefield',
			            startFieldName: 'MAINTAIN_DATE_FR',
			            endFieldName: 'MAINTAIN_DATE_TO',	
			            startDate: UniDate.get('startOfWeeK'),
			            endDate: UniDate.get('endOfWeeK'),
			            width:320
					},
					Unilite.popup('VEHICLE',
						 {
						 	itemId:'vehicle',
						 	extParam:{'DIV_CODE': UserInfo.divCode}
						  
						 }
					),{	    
						fieldLabel: '정비팀',
						name: 'MECHANIC_TEAM',
						xtype:'uniCombobox',
						comboType:'BOR120'
					},{	    
						fieldLabel: '작업지	',
						name: 'MAINTAIN_PLACE',
						xtype:'uniCombobox',
						comboType:'BOR120'
					}]
					
					
				},maintainGrid]

	});	//end panelSearch    
   
    var masterForm = Unilite.createForm('${PKGNAME}Form', {
    	region:'center',
    	disabled: false,
        layout : {type:'uniTable', columns:5},
        api: {
			load: gre200ukrvService.select,
			submit: gre200ukrvService.insertMaster
		},
        items:[
        	{	    
				fieldLabel: '사업장',
				name: 'DIV_CODE',
				xtype:'uniCombobox',
				comboType:'BOR120',
				value: UserInfo.divCode,
				allowBlank:false,
				colspan:2,
				listeners:{
					change:function(field, newValue, oldValue)	{
						var vehiclePopup = masterForm.down('#vehicle');
						vehiclePopup.setExtParam({'DIV_CODE':newValue});
					}
				}
			},{
				fieldLabel: '정비번호',
				name: 'MAINTAIN_NUM',
				readOnly:true,
				colspan:3
			},{
				fieldLabel: '정비일자',
				name: 'MAINTAIN_DATE',
				xtype:'uniDatefield',
				allowBlank:false,
				colspan:2
			},{
				fieldLabel: '작업구분',
				name: 'MAINTAIN_TYPE',
				xtype:'uniCombobox',
				comboType:'AU',
				comboCode:'GO22',
				colspan:2
			},{
				fieldLabel: '차량대수',
				name: 'VEHICLE_COUNT',
				xtype: 'uniNumberfield',
				listeners:{
					blur:function(field)	{
						masterForm.setWorkingTime()
					}
				}
			},
			Unilite.popup('VEHICLE',
						 {
						 	itemId:'vehicle',
						 	extParam:{'DIV_CODE': UserInfo.divCode},
							colspan:2
						  	
						 }
			),{
				fieldLabel: '주행거리',
				name: 'RUN_DISTANCE',
				xtype: 'uniNumberfield',
				colspan:2
			},{
				fieldLabel: '노선',
				name: 'ROUTE_CODE',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('routeStore')
			},{
				fieldLabel: '작업근거',
				name: 'MAINTAIN_GROUND',
				xtype:'uniCombobox',
				comboType:'AU',
				comboCode:'GO24',
				colspan:2
			},{
				fieldLabel: '작명번호',
				name: 'TASK_NUM',
				colspan:3
			},{
				fieldLabel: '작업지',
				name: 'MAINTAIN_PLACE',
				xtype:'uniCombobox',
				comboType:'AU',
				comboCode:'GO23',
				colspan:2
			},{
				fieldLabel: '정비팀',
				name: 'MECHANIC_TEAM',
				colspan:2
			},{
				fieldLabel: '주야간구분',
				name: 'AM_PM',
				xtype:'uniCombobox',
				comboType:'AU',
				comboCode:'GO25'
			},{
				fieldLabel: '시작일',
				name: 'START_DATE',
				xtype:'uniDatefield',
				allowBlank:false,
				listeners:{
					blur:function(field)	{
						masterForm.setWorkingTime()
					}
				}
			},{
				fieldLabel: '시작시간',
				hideLabel:true,
				width:60,
				name: 'START_TIME',
				allowBlank:false,
				listeners:{
					blur:function(field)	{
						field.setValue(masterForm.convertTime(field.getValue()));
						masterForm.setWorkingTime()
					}
				}
			},{
				fieldLabel: '종료일',
				name: 'END_DATE',
				xtype:'uniDatefield',
				allowBlank:false,
				listeners:{
					blur:function(field)	{
						masterForm.setWorkingTime()
					}
				}
			},{
				fieldLabel: '종료시간',
				hideLabel:true,
				width:60,
				name: 'END_TIME',
				allowBlank:false,
				listeners:{
					blur:function(field)	{
						field.setValue(masterForm.convertTime(field.getValue()));
						masterForm.setWorkingTime()
					}
				}
			},{
				fieldLabel: '소요시간',
				name: 'WORKING_TIME',
				xtype: 'uniNumberfield',
				readOnly:true,
				suffixTpl:'&nbsp;분'
			},{
				fieldLabel: '정비사인원',
				name: 'MECHANIC_NUMBER',
				xtype: 'uniNumberfield',
				readOnly:true,
				colspan:2,
				listeners:{
					validitychange:function(field)	{
						masterForm.setWorkingTime()
					},
					blur:function(field)	{
						masterForm.setWorkingTime()
					}
				}
			},{
				fieldLabel: '인당시간',
				name: 'WT_PER_MECHANIC',
				xtype: 'uniNumberfield',
				suffixTpl:'&nbsp;분',
				readOnly:true,
				colspan:2
			},{
				fieldLabel: '대당시간',
				name: 'WT_PER_VEHICLE',
				xtype: 'uniNumberfield',
				suffixTpl:'&nbsp;분',
				readOnly:true
			},{
				fieldLabel: '외부공장명칭',
				name: 'OUT_FACTORY',
				width:855,
				colspan:5
			},
			{
				fieldLabel: '외주수리내역',
				name: 'OURSOURCE_DESC',
				width:855,
				colspan:5
			},{
				fieldLabel: '비고',
				name: 'REMARK',
				xtype:'textareafield',
				width:855,
				colspan:5,
				height:'50'
			}
		],
		listeners:{
			uniOnChange:function( form, dirty, eOpts ) {
				UniAppManager.setToolbarButtons('save', true);
			},
			render: function(panel, eOpts) {
			    panel.getEl().on('click', function(e, t, eOpt) {
			    	if(activePanel && activePanel.getXType() == 'uniGridPanel'){
			    		activePanel.getStore().uniOpt.isMaster = false;
			    	}
			    	activePanel = panel;
			    	if(masterForm.isDirty() || detailStore.isDirty() || itemStore.isDirty() || mechenicStore.isDirty() )	{
			    		UniApp.setToolbarButtons(['save'], true);			    		
			    	}
			    });
			 }
		},
		convertTime :function ( value )	{
			value = value.replace(/:/g, "");
			var r = '';
			if(value.length >= 4 ){
				r = value.substring(0,2)+":"+value.substring(2,4);
			}
			return r;
		}
		,setWorkingTime: function()	{
			var me = this
			var recStartTime 	= Ext.isDefined(me.getValue("START_TIME")) ? this.convertTime(me.getValue("START_TIME")) : "00:00";
			var recEndTime 		= Ext.isDefined(me.getValue("END_TIME")) ? this.convertTime(me.getValue("END_TIME")) : "00:00";
			
			var startTime = new Date(Ext.Date.format(me.getValue("START_DATE"), 'Y-m-d')+"T"+recStartTime+':00Z');
			var startTimeUTC = new Date(startTime.getUTCFullYear(), startTime.getUTCMonth()+1, startTime.getUTCDate(), startTime.getUTCHours(), startTime.getUTCMinutes(), startTime.getUTCSeconds());
	        
	        var endTime = new Date(Ext.Date.format(me.getValue("END_DATE"), 'Y-m-d')+"T"+recEndTime+':00Z');
	        var endTimeUTC = new Date(endTime.getUTCFullYear(), endTime.getUTCMonth()+1, endTime.getUTCDate(), endTime.getUTCHours(), endTime.getUTCMinutes(), endTime.getUTCSeconds());
	        
	        var workingTime = UniDate.diff(startTimeUTC, endTimeUTC, 'm');
	        var wkPerVehicle = (me.getValue('VEHICLE_COUNT') > 0) ?  	Math.floor(workingTime/me.getValue('VEHICLE_COUNT')):0;
	        var wkPerMechanic =(me.getValue('MECHANIC_NUMBER') > 0) ?   Math.floor(workingTime/me.getValue('MECHANIC_NUMBER')):0; 
	        
	        me.setValue('WORKING_TIME',workingTime);
	        me.setValue('WT_PER_VEHICLE',wkPerVehicle);
	        me.setValue('WT_PER_MECHANIC',wkPerMechanic);
		}
    });

    var detailGrid = Unilite.createGrid('${PKGNAME}detailGrid', {   	
    	region:'north',
    	height:100,
		uniOpt:{
			useRowNumberer: false,
        	expandLastColumn: false,
            useMultipleSorting: false,
        	state: {
			   useState: true,   
			   useStateList: true  
			}
        },
    	store: detailStore,
		columns: [
			{dataIndex:'MAINTAIN_SEQ'		,width: 65 },
			{dataIndex:'MAINTAIN_CODE'		,width: 150 },
			{dataIndex:'TASK_DESC'			,flex: 1},
			{dataIndex:'DIFFICULTY'			,width: 100},
			{dataIndex:'ASSIGNED_TIME'		,width: 100},
			{dataIndex:'NEXT_SCHEDULD'		,width: 100}
		],
		listeners:{
			render: function(grid, eOpts) {
			    grid.getEl().on('click', function(e, t, eOpt) {
			    	if(activePanel && activePanel.getXType() == 'uniGridPanel'){
			    		activePanel.getStore().uniOpt.isMaster = false;
			    	}
			    	activePanel = grid;
			    	store = grid.getStore();
			    	store.uniOpt.isMaster = true;
			    	store.uniOpt.deletable = true;
			    	store._onStoreDataChanged(store);
			    	if(masterForm.isDirty() || detailStore.isDirty() || itemStore.isDirty() || mechenicStore.isDirty() )	{
			    		UniApp.setToolbarButtons(['save'], true);			    		
			    	}
			    });
			 }
		}
   });
	
   var itemGrid = Unilite.createGrid('${PKGNAME}itemGrid', {   	
    	region:'center',
    	height:100,
    	flex:.7,
		uniOpt:{
			useRowNumberer: false,
        	expandLastColumn: false,
            useMultipleSorting: false,
        	state: {
			   useState: true,   
			   useStateList: true  
			},
			excel: {
					useExcel: false
	        }
        },
    	store: itemStore,
		columns: [
			{dataIndex:'ITEM_CODE'		,width: 150 },
			{dataIndex:'ITEM_NAME'		,width: 150 },
			{dataIndex:'PART'			,width: 100},
			{dataIndex:'QUILTY'			,width: 80},
			{dataIndex:'QTY'			,width: 60},
			{dataIndex:'OUT_PLACE'		,flex: 1}
				
		],
		listeners:{
			render: function(grid, eOpts) {
			    grid.getEl().on('click', function(e, t, eOpt) {
			    	if(activePanel && activePanel.getXType() == 'uniGridPanel'){
			    		activePanel.getStore().uniOpt.isMaster = false;
			    	}
			    	activePanel = grid;
			    	store = grid.getStore();
			    	store.uniOpt.isMaster = true;
			    	store.uniOpt.deletable = true;
			    	store._onStoreDataChanged(store);
			    	if(masterForm.isDirty() || detailStore.isDirty() || itemStore.isDirty() || mechenicStore.isDirty() )	{
			    		UniApp.setToolbarButtons(['save'], true);			    		
			    	}
			    });
			 }
		}
   });
   
   var mechenicGrid = Unilite.createGrid('${PKGNAME}mechenicGrid', {   	
    	region:'east',
    	height:100,
    	flex:.3,
		uniOpt:{
			useRowNumberer: false,
        	expandLastColumn: false,
            useMultipleSorting: false,
        	state: {
			   useState: true,   
			   useStateList: true  
			},
			excel: {
					useExcel: false
	        }
        },
    	store: mechenicStore,
		columns: [
			{dataIndex:'MECHANIC_CODE'		,width: 100 ,
			  editor: Unilite.popup('MECHANIC_G',
						 {
						 	itemId:'mechanic',
						 	textFieldName:'MECHANIC_CODE',
						 	DBtextFieldName:'MECHANIC_CODE',
						 	extParam:{'DIV_CODE': UserInfo.divCode},
						 	listeners: {
				                'onSelected':  function(records, type  ){
				                    	var grdRecord = mechenicGrid.uniOpt.currentRecord;
				                    	grdRecord.set('MECHANIC_CODE',records[0]['MECHANIC_CODE']);
				                    	grdRecord.set('MECHANIC_NAME',records[0]['MECHANIC_NAME']);
				                }
				                ,'onClear':  function( type  ){
				                    	var grdRecord = mechenicGrid.uniOpt.currentRecord;
				                    	grdRecord.set('MECHANIC_CODE','');
				                    	grdRecord.set('MECHANIC_NAME','');
				                }
				            } 
						 }
					 )
			},
			{dataIndex:'MECHANIC_NAME',
			  editor: Unilite.popup('MECHANIC_G',
						 {
						 	itemId:'mechanic',
						 	extParam:{'DIV_CODE': UserInfo.divCode},
						 	listeners: {
				                'onSelected':  function(records, type  ){
				                    	var grdRecord = mechenicGrid.uniOpt.currentRecord;
				                    	grdRecord.set('MECHANIC_CODE',records[0]['MECHANIC_CODE']);
				                    	grdRecord.set('MECHANIC_NAME',records[0]['MECHANIC_NAME']);
				                }
				                ,'onClear':  function( type  ){
				                    	var grdRecord = mechenicGrid.uniOpt.currentRecord;
				                    	grdRecord.set('MECHANIC_CODE','');
				                    	grdRecord.set('MECHANIC_NAME','');
				                }
				            } 
						 }
					 )		,flex: 1},
			{dataIndex:'RECORD_YN'			,width: 100}	
		],
		listeners:{
			render: function(grid, eOpts) {
			    grid.getEl().on('click', function(e, t, eOpt) {
			    	if(activePanel && activePanel.getXType() == 'uniGridPanel'){
			    		activePanel.getStore().uniOpt.isMaster = false;
			    	}
			    	activePanel = grid;
			    	store = grid.getStore();
			    	store.uniOpt.isMaster = true;
			    	store.uniOpt.deletable = true;
			    	store._onStoreDataChanged(store);
			    	if(masterForm.isDirty() || detailStore.isDirty() || itemStore.isDirty() || mechenicStore.isDirty() )	{
			    		UniApp.setToolbarButtons(['save'], true);			    		
			    	}
			    });
			 }
		}
   });
   
      Unilite.Main({
		borderItems:[
	 		panelSearch,	 		  
		 	masterForm,
		 	
		 	{ xtype:'panel',
		 	  layout: 'border',
		 	  weight:-100,
		 	  height:300,
		 	  region:'south',
		 	  items:[
		 	  	detailGrid,
			  	itemGrid,
			 	mechenicGrid
		 	  ]
		 	}
		 	
		],
		id  : '${PKGNAME}ukrApp',
		autoButtonControl : false,
		fnInitBinding : function(params) {
			UniAppManager.setToolbarButtons(['print', 'excel'],false);
			UniAppManager.setToolbarButtons(['reset', 'newData' ],true);
			activePanel = masterForm;
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
			var maintainNum = masterForm.getValue('MAINTAIN_NUM');			
			var r = {}
			
			if(activePanel.getXType() == 'uniGridPanel')	{
				
					if(activePanel.getId() == '${PKGNAME}detailGrid')	{
						r = {
							'MAINTAIN_NUM' :maintainNum,
							'MAINTAIN_SEQ' : Unilite.nvl(detailStore.max('MAINTAIN_SEQ'),0)+1
						}
					} else {
						if(!Ext.isEmpty(maintainNum) ) {
							r = {'MAINTAIN_NUM' :maintainNum}
						}else {
							if(masterForm.getForm().isDirty())	{
								alert("정비내역을 저장하세요.");
							} else {
								alert("정비내역을 선택 하세요.");
							}
							return;
						}
					}
				
					activePanel.createRow(r);
			
			}else {
				maintainGrid.getSelectionModel().deselect();
				activePanel.clearForm();
				activePanel.getForm().wasDirty = false;
				activePanel.resetDirtyStatus();
			}
			
			
		},	
		onSaveDataButtonDown: function (config) {
			if(detailStore.isDirty())	{
				detailStore.saveStore(config);
			} else if(masterForm.getForm().isDirty()) {
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
								maintainStore.loadStoreRecords(Ext.isEmpty(action.result.MAINTAIN_NUM) ? param['MAINTAIN_NUM']:action.result.MAINTAIN_NUM);
								
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
			
			if(mechenicStore.isDirty()) {			
				mechenicStore.saveStore(config);
			}
		},
		onDeleteDataButtonDown : function()	{
			if(activePanel.getXType() == 'uniGridPanel')	{
				
				if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
					activePanel.deleteSelectedRow();				
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
			masterForm.getForm().wasDirty = false;
			masterForm.resetDirtyStatus();
			
			detailStore.rejectChanges();	
			itemStore.rejectChanges();	
			mechenicStore.rejectChanges();
			
		}
	});
}; // main

</script>