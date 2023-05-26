<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
//차량별기사배정 등록
request.setAttribute("PKGNAME","Unilite_app_gag200ukrv");
%>
<t:appConfig pgmId="gag200ukrv"  >
	<t:ExtComboStore comboType="BOR120" />				<!-- 사업장   	-->  
	<t:ExtComboStore comboType="AU" comboCode="GO13"/>				<!-- 등록상태  	-->  
	<t:ExtComboStore comboType="AU" comboCode="GO18"/>				<!-- 근무조  	-->  
	<t:ExtComboStore comboType="AU" comboCode="GO16"/>				<!-- 노선그룹  	-->	
	<t:ExtComboStore items="${ROUTE_COMBO}" storeId="routeStore" /> <!-- 노선 -->
</t:appConfig>
<script type="text/javascript">

function appMain() {
	Unilite.defineModel('gag200ukrvModel', {
	    fields: [
	    			 {name: 'DIV_CODE'   				,text:'사업장'					,type : 'string' 	,comboType:'BOR120', editable:false} 
					,{name: 'VEHICLE_CODE'    			,text:'차량코드'				,type : 'string', editable:false} 
					,{name: 'VEHICLE_NAME'    			,text:'차량명'					,type : 'string', editable:false} 
					,{name: 'VEHICLE_REGIST_NO'    		,text:'차량등록번호'			,type : 'string', editable:false} 
					,{name: 'REGIST_STATUS'    			,text:'차량등록상태'			,type : 'string', editable:false 	,comboType: 'AU' 	,comboCode: 'GO13'} 
					,{name: 'OPTION'    				,text:'옵션'					,type : 'string', editable:false, 	defaultValue:'BUSDRIVER'} 
					//고정기사1
					,{name: 'FIXED_DRIVER1'    			,text:'고정기사'					,type : 'string', editable:false} 
					,{name: 'FIXED_DRIVER1_NAME'    	,text:'고정기사명'					,type : 'string', editable:false} 
					,{name: 'FIXED_DRIVER1_TEAM_CODE'   ,text:'고정근무조'					,type : 'string', editable:true 	,comboType: 'AU' 	,comboCode: 'GO18'} 
					,{name: 'FIXED_DRIVER1_TEAM_NAME'   ,text:'고정근무조'					,type : 'string', editable:false}
					//고정기사2
					,{name: 'FIXED_DRIVER2'    			,text:'고정기사'					,type : 'string', editable:false} 
					,{name: 'FIXED_DRIVER2_NAME'    	,text:'고정기사명'					,type : 'string', editable:false}
					,{name: 'FIXED_DRIVER2_TEAM_CODE'   ,text:'고정근무조'					,type : 'string', editable:true 	,comboType: 'AU' 	,comboCode: 'GO18'} 
					,{name: 'FIXED_DRIVER2_TEAM_NAME'   ,text:'고정근무조'					,type : 'string', editable:false}
					//유동기사1
					,{name: 'NOTFIXED_DRIVER1'    		,text:'유동기사'					,type : 'string', editable:false} 
					,{name: 'NOTFIXED_DRIVER1_NAME' 	,text:'유동기사명'					,type : 'string', editable:false} 
					,{name: 'NOTFIXED_DRIVER1_TEAM_CODE',text:'유동근무조'					,type : 'string', editable:true 	,comboType: 'AU' 	,comboCode: 'GO18'} 
					,{name: 'NOTFIXED_DRIVER1_TEAM_NAME',text:'유동근무조'					,type : 'string', editable:false}
					//유동기사2
					,{name: 'NOTFIXED_DRIVER2'    		,text:'유동기사'					,type : 'string', editable:false} 
					,{name: 'NOTFIXED_DRIVER2_NAME' 	,text:'유동기사명'					,type : 'string', editable:false} 
					,{name: 'NOTFIXED_DRIVER2_TEAM_CODE',text:'유동근무조'					,type : 'string', editable:true 	,comboType: 'AU' 	,comboCode: 'GO18'} 
					,{name: 'NOTFIXED_DRIVER2_TEAM_NAME',text:'유동근무조'					,type : 'string', editable:false}
					
					,{name: 'REMARK'    				,text:'비고'					,type : 'string'} 		
					,{name: 'COMP_CODE'    				,text:'법인코드'				,type : 'string', editable:false, defaultValue:UserInfo.compCode} 		
					,{name: 'VIEW_TYPE'    				,text:'보기유형'				,type : 'string', editable:false ,defaultValue:'name'} // 기사배정 목록 보기 유형 (name : 이름으로 보기, photo: 사진으로보기)
			]
	});
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
				read : gag200ukrvService.selectList,
				update : gag200ukrvService.update,
               	syncAll : gag200ukrvService.update
		}
	});
    var masterStore =  Unilite.createStore('gag200ukrvStore',{
        model: 'gag200ukrvModel',
         autoLoad: false,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            
            proxy: directProxy,
            saveStore : function(config)	{				
				var inValidRecs = this.getInvalidRecords();
				if(inValidRecs.length == 0 )	{
					
					this.syncAllDirect();					
				}else {
					alert(Msg.sMB083);
				}
			} ,
			loadStoreRecords: function(record)	{
				var searchForm = Ext.getCmp('${PKGNAME}searchForm');
				var param= searchForm.getValues();
				Ext.apply(param, {'SEARCH_DATE': UniDate.getDateStr(panelSearch.getValue('SEARCH_DATE')), 'ROUTE_CODE': record.get('ROUTE_CODE')});
				if(searchForm.isValid())	{
					this.load({params: param});
				}
			}
		});
	
	Unilite.defineModel('${PKGNAME}routeHistoryModel', {
	    fields: [
					 {name: 'ROUTE_CODE'    		,text:'노선코드'		,type : 'string' } 
					,{name: 'ROUTE_NUM'    			,text:'노선번호'		,type : 'string' } 	
					,{name: 'ROUTE_NAME'    		,text:'노선명'			,type : 'string' } 	
					,{name: 'ROUTE_START_DATE'    	,text:'차량변경적용일'	,type : 'uniDate' } 					
					,{name: 'OFFICE_CODE'    		,text:'영업소'			,type : 'string' ,comboType: 'AU' ,comboCode: 'GO01'} 					
					,{name: 'ROUTE_ID'    			,text:'노선ID'			,type : 'string' } 					
					,{name: 'OPERATION_TYPE'    	,text:'운행구분'		,type : 'string' ,comboType: 'AU' ,comboCode: 'GO10'} 					
					,{name: 'ROUTE_TYPE'    		,text:'노선구분'		,type : 'string' ,comboType: 'AU' ,comboCode: 'GO11'}
					,{name: 'START_STOP'    		,text:'기점'			,type : 'string' }
					,{name: 'LAST_STOP'    			,text:'종점'			,type : 'string' }
					,{name: 'APPROV_CNT'    		,text:'인가댓수'		,type : 'uniQty' } 					
					,{name: 'ACTUAL_CNT'    		,text:'실제댓수'		,type : 'uniQty' } 		
					,{name: 'SELF_CNT'    			,text:'자차댓수'		,type : 'uniQty' } 		
					,{name: 'OTHER_CNT'    			,text:'타차댓수'		,type : 'uniQty' } 		
					,{name: 'RUN_CNT_MAX'    		,text:'운행횟수_최대'	,type : 'uniQty' } 					
					,{name: 'RUN_CNT_MIN'    		,text:'운행횟수_최소'	,type : 'uniQty' }
					,{name: 'REMARK'    			,text:'비고'			,type : 'string' }
			]	
	});


    var routeHistoryStore =  Unilite.createStore('${PKGNAME}routeHistoryStore',{
        model: '${PKGNAME}routeHistoryModel',
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
                	   read : 'gag100ukrvService.searchList'                	   
                }
            },
			loadStoreRecords: function()	{
				var searchForm = Ext.getCmp('${PKGNAME}searchForm');
				var param= searchForm.getValues();
				if(searchForm.isValid())	{
					this.load({params: param});
				}
			},
			listeners:{
				load:function()	{
					masterStore.clearData(); 
					masterGrid.reset();
				}
			}
            
		});	
		
	var routeHistoryGrid = Unilite.createGrid('${PKGNAME}routeHistoryGrid', {
		border: false,
		flex:1,
		uniOpt:{
			useRowNumberer: false,
        	expandLastColumn: false,
            useMultipleSorting: false,
            state: {
			   useState: false,   
			   useStateList: false  
			}
        },
         
    	store: routeHistoryStore,
    	itemId:'routeHistoryGrid',
		columns: [
			{dataIndex:'ROUTE_CODE'			,width: 85 },
			{dataIndex:'ROUTE_NUM'			,width: 70 },
			{dataIndex:'ROUTE_NAME'			,width: 100},
			{dataIndex:'ROUTE_START_DATE'	,width:100},
			{dataIndex:'OFFICE_CODE'		,width: 100 , hidden:true},
			{dataIndex:'ROUTE_ID'			,width: 100 , hidden:true},
			{dataIndex:'OPERATION_TYPE'		,width: 100, hidden:true},
			{dataIndex:'ROUTE_TYPE'			,width:100, hidden:true},			
			{dataIndex:'APPROV_CNT'			,width: 100, hidden:true},
			{dataIndex:'ACTUAL_CNT'			,width:100},
			{dataIndex:'RUN_CNT_MAX'		,width: 100 , hidden:true},
			{dataIndex:'RUN_CNT_MIN'		,width: 100 , hidden:true},
			{dataIndex:'START_STOP'			,width: 100 , hidden:true},
			{dataIndex:'LAST_STOP'			,width: 100 , hidden:true},
			{dataIndex:'REMARK'				,flex: 1 , hidden:true}
			
		],
		listeners: {
      		selectionchange: function( grid, selected, eOpts ) {  
      			if(masterStore.isDirty() )	{
					if(confirm(Msg.sMB061))	{
						var config = {
							success: function()	{
								masterStore.loadStoreRecords(selected[0]);
							}
						}
						UniAppManager.app.onSaveDataButtonDown(config);
					}  else {
						UniAppManager.app.rejectSave();
						masterStore.loadStoreRecords(selected[0]);
					}
				}else {
					masterStore.loadStoreRecords(selected[0]);
				}
				
			}
         }
   });	
		
	var panelSearch = Unilite.createSearchPanel('${PKGNAME}searchForm',{
		title: '차량정보',
        defaultType: 'uniSearchSubPanel',
        defaults: {
			autoScroll:true
	  	},
        width: 330,
		items: [{	
					title: '검색조건', 	
					id: 'search_panel1',
		   			itemId: 'search_panel1',
		           	layout: {type: 'uniTable', columns: 1},
		           	defaultType: 'uniTextfield',  
		           	defaults:{
		           		labelWidth:80
		           	},
			    	items:[
			    		{	    
							fieldLabel: '사업장',
							name: 'DIV_CODE',
							xtype:'uniCombobox',
							comboType:'BOR120',
							value: UserInfo.divCode,
							allowBlank:false
						},{	    
							fieldLabel: '노선그룹',
							name: 'ROUTE_GROUP',
							xtype:'uniCombobox',
							comboType:'AU',
							comboCode:'GO16',
							listeners: {
								change:function()	{
									panelSearch.setValue('ROUTE_CODE', '');
								}
							}
						},{	    
							fieldLabel: '노선',
							name: 'ROUTE_CODE',
							xtype: 'uniCombobox',
							store: Ext.data.StoreManager.lookup('routeStore'),
							listeners:{
								beforequery: function(queryPlan, eOpts )	{
									var pValue = panelSearch.getValue('ROUTE_GROUP');
									var store = queryPlan.combo.getStore();
									if(!Ext.isEmpty(pValue) )	{
										store.clearFilter(true);
										queryPlan.combo.queryFilter = null;				
										store.filter('option', pValue);
									} else {
										store.clearFilter(true);
										queryPlan.combo.queryFilter = null;	
										store.loadRawData(store.proxy.data);
									}
								}
							}						
						},{	    
							fieldLabel: '차량코드',
							name: 'VEHICLE_CODE'	
						},{	    
							fieldLabel: '차량명',
							name: 'VEHICLE_NAME'	
						},{	    
							fieldLabel: '차량등록번호',
							name: 'VEHICLE_REGIST_NO'	
						},{	    
							fieldLabel: '기준일',
							name: 'SEARCH_DATE'	,
							xtype:'uniDatefield',
							value: UniDate.today(),
							allowBlank:false
						},{	    
							fieldLabel: '보기유형',
							name: 'VIEW_TYPE',
							hidden: true,
							value:'name'
						}
					]				
			
			},{	
					header:false,
		   			itemId: 'search_panel2',
		   			layout:{type:'vbox', align:'stretch'},
		   			flex: .8,
		           	items: [routeHistoryGrid]			
				}]
		
	});	//end panelSearch    
	
    
	var masterGrid = Unilite.createGrid('gag200ukrvMasterGrid', {
		region:'center',
		store: masterStore,
    	uniOpt: {
			expandLastColumn: false,
			useRowNumberer: false,
			state: {
				useState: false,		//그리드 설정 버튼 사용 여부
				useStateList: false		//그리드 설정 목록 사용 여부
			}
        },
        border:false,
        tools:[
        	{
				type: 'hum-grid',					            
	            handler: function () {
	            	panelSearch.setValue('VIEW_TYPE','name');
	            	
	            	masterGrid.getColumn('FIXED_DRIVER1_NAME').show();
	            	masterGrid.getColumn('FIXED_DRIVER1_TEAM_CODE').show();
	            	masterGrid.getColumn('FIXED_DRIVER1').hide();
	            	
	            	masterGrid.getColumn('FIXED_DRIVER2_NAME').show();
	            	masterGrid.getColumn('FIXED_DRIVER2_TEAM_CODE').show();
	            	masterGrid.getColumn('FIXED_DRIVER2').hide();
	            	
	            	masterGrid.getColumn('NOTFIXED_DRIVER1_NAME').show();
	            	masterGrid.getColumn('NOTFIXED_DRIVER1_TEAM_CODE').show();
	            	masterGrid.getColumn('NOTFIXED_DRIVER1').hide();
	            	
	            	masterGrid.getColumn('NOTFIXED_DRIVER2_NAME').show();
	            	masterGrid.getColumn('NOTFIXED_DRIVER2_TEAM_CODE').show();
	            	masterGrid.getColumn('NOTFIXED_DRIVER2').hide();
	            }
    		},{

				type: 'hum-photo',					            
	            handler: function () {
	            	panelSearch.setValue('VIEW_TYPE','photo');
					masterGrid.getColumn('FIXED_DRIVER1_NAME').hide();
	            	masterGrid.getColumn('FIXED_DRIVER1_TEAM_CODE').hide();
	            	masterGrid.getColumn('FIXED_DRIVER1').show();
	            	
	            	masterGrid.getColumn('FIXED_DRIVER2_NAME').hide();
	            	masterGrid.getColumn('FIXED_DRIVER2_TEAM_CODE').hide();
	            	masterGrid.getColumn('FIXED_DRIVER2').show();
	            	
	            	masterGrid.getColumn('NOTFIXED_DRIVER1_NAME').hide();
	            	masterGrid.getColumn('NOTFIXED_DRIVER1_TEAM_CODE').hide();
	            	masterGrid.getColumn('NOTFIXED_DRIVER1').show();
	            	
	            	masterGrid.getColumn('NOTFIXED_DRIVER2_NAME').hide();
	            	masterGrid.getColumn('NOTFIXED_DRIVER2_TEAM_CODE').hide();
	            	masterGrid.getColumn('NOTFIXED_DRIVER2').show();
	            }
    		}
        ],
        style:{
        	margin: 0,
        	left:0,
        	top:0
        },
        header: {
        	hiddenAncestor: true
        },
        columns:  [ 
        	{dataIndex:'VEHICLE_CODE' ,width:80},
        	{dataIndex:'VEHICLE_NAME' ,width:80},
        	{dataIndex:'VEHICLE_REGIST_NO' ,width:90},
        	{dataIndex:'REGIST_STATUS' ,width:90},
        	{ text: '고정기사',
              columns:[
              		{
			        	dataIndex:'FIXED_DRIVER1'		,
			        	width : 90	 
   					 },
		        	{dataIndex:'FIXED_DRIVER1_NAME' ,width:80},
		        	{dataIndex:'FIXED_DRIVER1_TEAM_CODE' ,width:80,
		        	 listeners:{
	        	 		render:function(field, eOpta)	{
	        	 			console.log("FIXED_DRIVER1_TEAM_CODE" , field);
	        	 			var store = field.getEditor().getStore();
	        	 			store.filter([
							    {filterFn: function(item) { return item.get("value") == 'A' || item.get("value")=='C'; }}
							]);
	        	 		}
	        	 	 }
		        	},
		        	{
	   					 dataIndex:'FIXED_DRIVER2'		,
			        	 width : 90	 
	   				},
		        	{dataIndex:'FIXED_DRIVER2_NAME' ,width:80},
		        	{dataIndex:'FIXED_DRIVER2_TEAM_CODE' ,width:80,
		        	 listeners:{
	        	 		render:function(field, eOpta)	{
	        	 			console.log("FIXED_DRIVER1_TEAM_CODE" , field);
	        	 			var store = field.getEditor().getStore();
	        	 			store.filter([
							    {filterFn: function(item) { return item.get("value") == 'B' || item.get("value")=='D'; }}
							]);
	        	 		}
	        	 	 }
	        	 	}
        		]        	
        	},
        	{ text: '유동기사',
              columns:[
		        	{
			        	dataIndex:'NOTFIXED_DRIVER1'		,
			        	width : 90	
   					 },
		        	{dataIndex:'NOTFIXED_DRIVER1_NAME' ,width:80},
		        	{dataIndex:'NOTFIXED_DRIVER1_TEAM_CODE' ,width:80,
		        	 listeners:{
	        	 		render:function(field, eOpta)	{
	        	 			console.log("FIXED_DRIVER1_TEAM_CODE" , field);
	        	 			var store = field.getEditor().getStore();
	        	 			store.filter([
							    {filterFn: function(item) { return item.get("value") == 'A' || item.get("value")=='C'; }}
							]);
	        	 		}
	        	 	 }
	        	 	},
	        	 	
		        	{
	   					 dataIndex:'NOTFIXED_DRIVER2'		,
			        	 width : 90	 	
   					 },
		        	{dataIndex:'NOTFIXED_DRIVER2_NAME' ,width:80},
		        	{dataIndex:'NOTFIXED_DRIVER2_TEAM_CODE' ,width:80,
		        	 listeners:{
	        	 		render:function(field, eOpta)	{
	        	 			console.log("FIXED_DRIVER1_TEAM_CODE" , field);
	        	 			var store = field.getEditor().getStore();
	        	 			store.filter([
							    {filterFn: function(item) { return item.get("value") == 'B' || item.get("value")=='D'; }}
							]);
	        	 		}
	        	 	 }
	        	 	}	
        		]        	
        	},
        	{dataIndex:'REMARK',flex:1, valign:'middle'} 
        ],
        viewConfig: {
        	
            plugins: {
                ddGroup: 'dataGroup',
                ptype: 'unicelldragdrop',
                enableDrop: true,
                enableDrag: true,
                copyType:'record',
                onRecordDrop: function(target, drag)	{
                	var targetRecord = target.record,
                		dragRecord = drag.record;
                	if(target.columnName == 'FIXED_DRIVER1' || target.columnName == 'FIXED_DRIVER1_NAME' || target.columnName == 'FIXED_DRIVER1_TEAM_CODE') {
                		Ext.getBody().mask();
                		gag200ukrvService.selectCheckDriver(
                			{
                				'DRIVER_CODE':dragRecord.get("DRIVER_CODE"),
                				'DIV_CODE':panelSearch.getValue('DIV_CODE')
                			}, 
                			function(provider, resonse){
	    	 					if(provider['DRIVER_CNT'] > 0)	{
	    	 						if(confirm('이미 등록된 기사입니다.'+'\n'+'등록하시겠습니까?'))	{
	    	 								targetRecord.set("FIXED_DRIVER1", dragRecord.get("DRIVER_CODE"));
					                		targetRecord.set("FIXED_DRIVER1_NAME", dragRecord.get("NAME"));
					                		targetRecord.set("FIXED_DRIVER1_TEAM_CODE", Unilite.nvl(dragRecord.get("WORK_TEAM_CODE"), "A"));
					                		targetRecord.set("FIXED_DRIVER1_TEAM_NAME", Unilite.nvl(dragRecord.get("WORK_TEAM_NAME"), "A조"));
    	 							}
	    	 							
	    	 					}else {
    	 							targetRecord.set("FIXED_DRIVER1", dragRecord.get("DRIVER_CODE"));
			                		targetRecord.set("FIXED_DRIVER1_NAME", dragRecord.get("NAME"));
			                		targetRecord.set("FIXED_DRIVER1_TEAM_CODE", Unilite.nvl(dragRecord.get("WORK_TEAM_CODE"), "A"));
			                		targetRecord.set("FIXED_DRIVER1_TEAM_NAME", Unilite.nvl(dragRecord.get("WORK_TEAM_NAME"), "A조"));	
    	 						}
    	 						Ext.getBody().unmask();
		    	 		})
                	}
                	if(target.columnName == 'FIXED_DRIVER2' || target.columnName == 'FIXED_DRIVER2_NAME' || target.columnName == 'FIXED_DRIVER2_TEAM_CODE') {
                		Ext.getBody().mask();
                		gag200ukrvService.selectCheckDriver(
                			{
                				'DRIVER_CODE':dragRecord.get("DRIVER_CODE"),
                				'DIV_CODE':panelSearch.getValue('DIV_CODE')
                			}, 
                			function(provider, resonse){
	    	 					if(provider['DRIVER_CNT'] > 0)	{
	    	 						if(confirm('이미 등록된 기사입니다.'+'\n'+'등록하시겠습니까?'))	{
	    	 							targetRecord.set("FIXED_DRIVER2", dragRecord.get("DRIVER_CODE"));
				                		targetRecord.set("FIXED_DRIVER2_NAME", dragRecord.get("NAME"));
				                		targetRecord.set("FIXED_DRIVER2_TEAM_CODE", Unilite.nvl(dragRecord.get("WORK_TEAM_CODE"), "B"));
				                		targetRecord.set("FIXED_DRIVER2_TEAM_NAME", Unilite.nvl(dragRecord.get("WORK_TEAM_NAME"), "B조"));
    	 							}
	    	 							
	    	 					}else {
    	 							targetRecord.set("FIXED_DRIVER2", dragRecord.get("DRIVER_CODE"));
			                		targetRecord.set("FIXED_DRIVER2_NAME", dragRecord.get("NAME"));
			                		targetRecord.set("FIXED_DRIVER2_TEAM_CODE", Unilite.nvl(dragRecord.get("WORK_TEAM_CODE"), "B"));
			                		targetRecord.set("FIXED_DRIVER2_TEAM_NAME", Unilite.nvl(dragRecord.get("WORK_TEAM_NAME"), "B조"));
    	 						}
    	 						Ext.getBody().unmask();
		    	 		})
                		
                	}
                	if(target.columnName == 'NOTFIXED_DRIVER1' || target.columnName == 'NOTFIXED_DRIVER1_NAME' || target.columnName == 'NOTFIXED_DRIVER1_TEAM_CODE') {
                		targetRecord.set("NOTFIXED_DRIVER1", dragRecord.get("DRIVER_CODE"));
                		targetRecord.set("NOTFIXED_DRIVER1_NAME", dragRecord.get("NAME"));
                		targetRecord.set("NOTFIXED_DRIVER1_TEAM_CODE", Unilite.nvl(dragRecord.get("WORK_TEAM_CODE"), "C"));
                		targetRecord.set("NOTFIXED_DRIVER1_TEAM_NAME", Unilite.nvl(dragRecord.get("WORK_TEAM_NAME"), "C조"));
                	}
                	if(target.columnName == 'NOTFIXED_DRIVER2' || target.columnName == 'NOTFIXED_DRIVER2_NAME' || target.columnName == 'NOTFIXED_DRIVER2_TEAM_CODE') {
                		targetRecord.set("NOTFIXED_DRIVER2", dragRecord.get("DRIVER_CODE"));
                		targetRecord.set("NOTFIXED_DRIVER2_NAME", dragRecord.get("NAME"));
                		targetRecord.set("NOTFIXED_DRIVER2_TEAM_CODE", Unilite.nvl(dragRecord.get("WORK_TEAM_CODE"), "D"));
                		targetRecord.set("NOTFIXED_DRIVER2_TEAM_NAME", Unilite.nvl(dragRecord.get("WORK_TEAM_NAME"), "D조"));
                	}
                },
                onDropEnter: function(target, dragData)	{
                	if(dragData.record.get('OPTION') == 'BUSDRIVER')	{
                		return false;
                	}
                	if(target.columnName.indexOf('FIXED_DRIVER')  < 0 )	{
                		return false;
                	}
                	return true;
                }
            }
        },
        listeners:{
            itemcontextmenu:function(view, record, item, index, event, eOpts )	{
          	  		event.stopEvent();
					contextMenu.selectedRecord = record;
					contextMenu.selectedIndex = index;
					contextMenu.showAt(event.getXY());					
          	 }
        }
	});
    var contextMenu = new Ext.menu.Menu({
	        items: [{
            			text:'고정기사(A) 삭제',   iconCls : 'icon-link',  
            			handler: function(menuItem, event) {
	                		var param = menuItem.up('menu');
	                		var record = masterStore.getAt(param.selectedIndex);
					        
			     			record.set("FIXED_DRIVER1", '');
	                		record.set("FIXED_DRIVER1_NAME", '');
	                		record.set("FIXED_DRIVER1_TEAM_CODE", '');
	                		record.set("FIXED_DRIVER1_TEAM_NAME", '');
            			}
            		},{
            			text:'고정기사(B) 삭제',   iconCls : 'icon-link',  
            			handler: function(menuItem, event) {
	                		var param = menuItem.up('menu');
	                		var record = masterStore.getAt(param.selectedIndex);
					        
			     			record.set("FIXED_DRIVER2", '');
	                		record.set("FIXED_DRIVER2_NAME", '');
	                		record.set("FIXED_DRIVER2_TEAM_CODE", '');
	                		record.set("FIXED_DRIVER2_TEAM_NAME", '');
            			}
            		},{
            			text:'유동기사(C) 삭제',   iconCls : 'icon-link', 
            			handler: function(menuItem, event) {
	                		var param = menuItem.up('menu');
	                		var record = masterStore.getAt(param.selectedIndex);
					        
			     			record.set("NOTFIXED_DRIVER1", '');
	                		record.set("NOTFIXED_DRIVER1_NAME", '');
	                		record.set("NOTFIXED_DRIVER1_TEAM_CODE", '');
	                		record.set("NOTFIXED_DRIVER1_TEAM_NAME", '');
            			}
            		},{
            			text:'유동기사(D) 삭제',   iconCls : 'icon-link', 
            			handler: function(menuItem, event) {
	                		var param = menuItem.up('menu');
	                		var record = masterStore.getAt(param.selectedIndex);
					        
			     			record.set("NOTFIXED_DRIVER2", '');
	                		record.set("NOTFIXED_DRIVER2_NAME", '');
	                		record.set("NOTFIXED_DRIVER2_TEAM_CODE", '');
	                		record.set("NOTFIXED_DRIVER2_TEAM_NAME", '');
            			}
            		}		                
	        	]
    	});
    Unilite.defineModel('gag200ukrvDriverModel', {
	    fields: [
					 {name: 'DIV_CODE'   		,text:'사업장'		,type : 'string'} 			
					,{name: 'NAME'    			,text:'이름'		,type : 'string'} 
					,{name: 'DISPLAY_NAME'    	,text:'DISPLAY 이름'		,type : 'string'}
					,{name: 'DRIVER_CODE'  		,text:'기사코드'	,type : 'string'}
					,{name: 'WORK_TEAM_CODE'  	,text:'운행조코드'	,type : 'string'}
					,{name: 'WORK_TEAM_NAME'  	,text:'근무조'	,type : 'string'}
					,{name: 'ROUTE_GROUP'  		,text:'노선그룹'	,type : 'string'	,comboType: 'AU' 	,comboCode: 'GO16'}
					,{name: 'ROUTE_CODE'  		,text:'노선코드'	,type : 'string'	,store: Ext.data.StoreManager.lookup('routeStore')}
					,{name: 'REMARK'  			,text:'비고'		,type : 'string'} 
			]
	});
	
	var driverStore =  Unilite.createStore('gag200ukrvDriverStore',{
        model: 'gag200ukrvDriverModel',
        idProperty: 'DRIVER_CODE',
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
                	   read : gag200ukrvService.driverList
                }
            },
			loadStoreRecords: function()	{
				var searchForm = Ext.getCmp('${PKGNAME}driverForm');
				var param= searchForm.getValues();
				if(searchForm.isValid())	{
					this.load({params: param});
				}
			}
            
            
		});
		
     var driverView = Ext.create('UniDragandDropView', {
		tpl: '<tpl for=".">'+
                '<div class="data-source bus-driver-photo"><img src="'+CPATH+'/uploads/employeePhoto/{DRIVER_CODE}" title="{NAME:htmlEncode}" width="77" height="77"><br/>'+	                
        			'<span>{WORK_TEAM_NAME}/{DISPLAY_NAME}</span><br><span>({DRIVER_CODE})</span>'+                    			
        		'</div>'+
            '</tpl>' ,
        itemSelector: 'div.data-source',
        overItemCls: 'data-over',
        selectedItemClass: 'data-selected',
        singleSelect: true,
        store: driverStore,
        onDropEnter: function(target, dd, e, drag)	{
        	var me = this;
        	
        	
        	var drop = me.getDropRecord();
        	me.setAllowDrop(false);
        	
        	if(drag.record.get("OPTION") =="BUSDRIVER")	{
        		me.setAllowDrop(true);
        		return true;
        	}
        	return false;
        },
        
        onDrop : function(target, dd, e, drag){
        	var me = this;
        	var drop = me.getDropRecord();
        	var dragRec = me.getDragRecord();
        	var store = me.getStore();	           
	        var dropDom = me.getNode(target);
        	if(me.allowDrop)	{
		        if(drag.columnName == 'FIXED_DRIVER1' || drag.columnName == 'FIXED_DRIVER1_NAME' || drag.columnName == 'FIXED_DRIVER1_TEAM_CODE') {
		        		dragRec.set("FIXED_DRIVER1", '');
                		dragRec.set("FIXED_DRIVER1_NAME", '');
                		dragRec.set("FIXED_DRIVER1_TEAM_CODE", '');
                		dragRec.set("FIXED_DRIVER1_TEAM_NAME", '');
                }
                if(drag.columnName == 'FIXED_DRIVER2' || drag.columnName == 'FIXED_DRIVER2_NAME' || drag.columnName == 'FIXED_DRIVER2_TEAM_CODE') {
                		dragRec.set("FIXED_DRIVER2", '');
                		dragRec.set("FIXED_DRIVER2_NAME", '');
                		dragRec.set("FIXED_DRIVER2_TEAM_CODE", '');
                		dragRec.set("FIXED_DRIVER2_TEAM_NAME", '');
                }
                if(drag.columnName == 'NOTFIXED_DRIVER1' || drag.columnName == 'NOTFIXED_DRIVER1_NAME' || drag.columnName == 'NOTFIXED_DRIVER1_TEAM_CODE') {
                		dragRec.set("NOTFIXED_DRIVER1", '');
                		dragRec.set("NOTFIXED_DRIVER1_NAME", '');
                		dragRec.set("NOTFIXED_DRIVER1_TEAM_CODE", '');
                		dragRec.set("NOTFIXED_DRIVER1_TEAM_NAME", '');
                }
                if(drag.columnName == 'NOTFIXED_DRIVER2' || drag.columnName == 'NOTFIXED_DRIVER2_NAME' || drag.columnName == 'NOTFIXED_DRIVER2_TEAM_CODE') {
                		dragRec.set("NOTFIXED_DRIVER2", '');
                		dragRec.set("NOTFIXED_DRIVER2_NAME", '');
                		dragRec.set("NOTFIXED_DRIVER2_TEAM_CODE", '');
                		dragRec.set("NOTFIXED_DRIVER2_TEAM_NAME", '');
                }
        	}
            return true;
        }
    });
    
    var driverGrid =  Unilite.createGrid('gag200ukrvDriverGrid', {
        hidden:true,
        flex: .15,
        margins: 0,
    	store: driverStore,
    	uniOpt: {
			expandLastColumn: false,
			useRowNumberer: false
        },
        columns:  [ 
        	{dataIndex:'NAME' ,width:70},
        	{dataIndex:'DRIVER_CODE' ,width:70},
        	{dataIndex:'ROUTE_GROUP' ,width:70},
        	{dataIndex:'ROUTE_CODE' ,flex:1}
        ],
        viewConfig: {
        	itemId:'DirverList',
            plugins: {
                ddGroup: 'dataGroup',
                ptype: 'unicelldragdrop',
                copyType:'record',
                enableDrop: false
            }
        }
    });
    
    Unilite.defineModel('gag200ukrvTrashModel', {
	    fields: [
					 {name: 'TRASH'   		,text:'휴지통'		,type : 'string'} 		
				]
    });
    var trashStore =  Unilite.createStore('gag200ukrvTrashStore',{ //Ext.create('Ext.data.Store', {
     model: 'gag200ukrvTrashModel',
     data : [
         {TRASH: 'TRASH'}
     ]
 	});
     var trashView = Ext.create('UniDropView', {
		tpl: '<tpl for=".">'+
			 '<div  style="padding-top:10px;">' +
			 '	<div class="data-source" ><img src="'+CPATH+'/resources/images/busoperate/trash.png" title="배정된 기사 중 삭제할 기사를 마우스로 가져오세요.", width="30" height="30"> 배정기사 삭제</div>' +
			 '</div>'+
        	  '</tpl>',
        itemSelector: 'div.data-source',
        overItemCls: 'data-over',
        selectedItemClass: 'data-selected',
        store: trashStore,
         onDropEnter: function(target, dd, e, drag)	{
        	var me = this;
        	
        	var drop = me.getDropRecord();
        	me.setAllowDrop(false);
        	
        	if(drag.record.get("OPTION") =="BUSDRIVER")	{
        		me.setAllowDrop(true);
        		return true;
        	}
        	return false;
        },
        
        onDrop : function(target, dd, e, drag){
        	var me = this;
        	var dragRec = drag.record;    
	        var dropDom = me.getNode(target);
        	if(me.allowDrop)	{
		        if(drag.columnName == 'FIXED_DRIVER1' || drag.columnName == 'FIXED_DRIVER1_NAME' || drag.columnName == 'FIXED_DRIVER1_TEAM_CODE') {
		        		dragRec.set("FIXED_DRIVER1", '');
                		dragRec.set("FIXED_DRIVER1_NAME", '');
                		dragRec.set("FIXED_DRIVER1_TEAM_CODE", '');
                		dragRec.set("FIXED_DRIVER1_TEAM_NAME", '');
                }
                if(drag.columnName == 'FIXED_DRIVER2' || drag.columnName == 'FIXED_DRIVER2_NAME' || drag.columnName == 'FIXED_DRIVER2_TEAM_CODE') {
                		dragRec.set("FIXED_DRIVER2", '');
                		dragRec.set("FIXED_DRIVER2_NAME", '');
                		dragRec.set("FIXED_DRIVER2_TEAM_CODE", '');
                		dragRec.set("FIXED_DRIVER2_TEAM_NAME", '');
                }
                if(drag.columnName == 'NOTFIXED_DRIVER1' || drag.columnName == 'NOTFIXED_DRIVER1_NAME' || drag.columnName == 'NOTFIXED_DRIVER1_TEAM_CODE') {
                		dragRec.set("NOTFIXED_DRIVER1", '');
                		dragRec.set("NOTFIXED_DRIVER1_NAME", '');
                		dragRec.set("NOTFIXED_DRIVER1_TEAM_CODE", '');
                		dragRec.set("NOTFIXED_DRIVER1_TEAM_NAME", '');
                }
                if(drag.columnName == 'NOTFIXED_DRIVER2' || drag.columnName == 'NOTFIXED_DRIVER2_NAME' || drag.columnName == 'NOTFIXED_DRIVER2_TEAM_CODE') {
                		dragRec.set("NOTFIXED_DRIVER2", '');
                		dragRec.set("NOTFIXED_DRIVER2_NAME", '');
                		dragRec.set("NOTFIXED_DRIVER2_TEAM_CODE", '');
                		dragRec.set("NOTFIXED_DRIVER2_TEAM_NAME", '');
                }
        	}
            return true;
        }
    });
    var panelSearch2 = Unilite.createOperatePanel('${PKGNAME}driverForm',{
		title: '참조정보',
		
        defaultType: 'uniSearchSubPanel',
        defaults: {
			autoScroll:true
	  	},
        width: 330,
		items: [{	
					title: '기사정보', 	
					collapsible:false,
		   			itemId: 'search_panel1',
		   			height:80,
		           	layout: {type: 'uniTable', columns: 1},
		           	defaultType: 'uniTextfield',  
		           	defaults:{
		           		labelWidth:80,		           		
						listeners:{
							specialkey: function(field, e){
			                    if (e.getKey() == e.ENTER) {
			                       driverStore.loadStoreRecords();
			                    }
			                }
						}	
		           	},
		           	tools: [{
			        			type: 'search',
			        			handler:function()	{
			        				driverStore.loadStoreRecords();
			        			}
			        		},{
								type: 'hum-grid',					            
					            handler: function () {
					            	driverView.hide();
					                driverGrid.show();
					            }
			        		},{

								type: 'hum-photo',					            
					            handler: function () {
					                driverGrid.hide();
					                driverView.show();
					            }
			        		}
						
					],
			    	items:[{	    
						fieldLabel: '기사명',
						name: 'NAME'						
					},{
						fieldLabel: '근무조',
						name:'WORK_TEAM_CODE',
						xtype:'uniCombobox',
						comboType:'AU',
						comboCode:'GO18'
					}]				
				}/*,{
					itemId:'trash',
					header:false,
			        border:0,
			        layout: {type: 'vbox', align:'stretch'},
			        height:40,
			        items: [trashView]
			}*/,{
					itemId:'dirvers',
					header:false,
			        border:0,
			        defaults:{autoScroll:true},
			        layout: {type: 'vbox', align:'stretch'},
			        flex:1,
			        
			        items: [driverView,driverGrid]
			}]
		
	});	//end panelSearch   

      Unilite.Main({
      	constrain : true,
		borderItems:[
	 		panelSearch,
	 		masterGrid
			,panelSearch2
		],
		id  : 'gag200ukrApp',
		autoButtonControl : false,
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['reset', 'excel','print','newData'],false);
			driverStore.loadStoreRecords();
				
		},
		
		onQueryButtonDown : function()	{
			routeHistoryStore.loadStoreRecords();
			//masterStore.loadStoreRecords();
		},
		onPrevDataButtonDown:  function()	{
			masterGrid.selectPriorRow();
		},
		onNextDataButtonDown:  function()	{
			masterGrid.selectNextRow();
		},		
		onSaveDataButtonDown: function (config) {
			masterStore.saveStore();
					
		},
		onDeleteDataButtonDown : function()	{
			if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				var me = this;
				
			}
		},
		onResetButtonDown:function() {
			var me = this;
			
			UniAppManager.setToolbarButtons('save',false);
		}
		,rejectSave: function() {			
			masterStore.rejectChanges();	
			masterStore.onStoreActionEnable();
		}
	});

	
}; // main
  
</script>