<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
//노선별차량배정 등록
request.setAttribute("PKGNAME","Unilite_app_gag100ukrv");
%>
<t:appConfig pgmId="gag100ukrv"  >
	<t:ExtComboStore comboType="BOR120"/>				<!-- 사업장   	-->  
	<t:ExtComboStore comboType="AU" comboCode="GO01"/>				<!-- 영업소  	-->  
	<t:ExtComboStore comboType="AU" comboCode="GO10"/>				<!-- 운행구분  	-->
	<t:ExtComboStore comboType="AU" comboCode="GO11"/>				<!-- 노선구분  	-->
	<t:ExtComboStore comboType="AU" comboCode="GO12"/>				<!-- 시계구분  	-->
	<t:ExtComboStore comboType="AU" comboCode="GO13"/>				<!-- 운행/폐지 구분  	-->	
	<t:ExtComboStore comboType="AU" comboCode="GO16"/>				<!-- 노선그룹  	-->	
	<t:ExtComboStore items="${ROUTE_COMBO}" storeId="routeStore" /> <!-- 노선 -->
</t:appConfig>
<script type="text/javascript">
var selectGrid;
function appMain() {
	Unilite.defineModel('${PKGNAME}model', {
	    fields: [
					 {name: 'DIV_CODE'   			,text:'사업장'			,type : 'string'  ,comboType: 'BOR120' ,allowBlank:false ,defaultValue: UserInfo.divCode} 
					,{name: 'ROUTE_CODE'    		,text:'노선코드'		,type : 'string'  ,editable:false ,allowBlank:false} 
					,{name: 'ROUTE_START_DATE'    	,text:'노선변경적용일'	,type : 'uniDate' ,editable:false ,allowBlank:false} 					
					,{name: 'ASSIGN_START_DATE'    	,text:'차량배정적용일'	,type : 'uniDate' ,allowBlank:false, isPk:true, pkGen:'user' } 		
					,{name: 'ASSIGN_END_DATE'    	,text:'차량배정완료일'	,type : 'uniDate' } 		
					,{name: 'OPERATION_TOT_COUNT'   ,text:'운행총순번'		,type : 'uniQty'  ,editable:false} 	
					,{name: 'SELF_CNT'   			,text:'자차댓수'		,type : 'uniQty'  ,editable:false} 
					,{name: 'OTHER_CNT'   			,text:'타차댓수'		,type : 'uniQty'  ,editable:false} 
					,{name: 'REMARK'  				,text:'비고'			,type : 'string'} 
					,{name: 'COMP_CODE'  			,text:'법인코드'		,type : 'string'  ,allowBlank:false ,defaultValue: UserInfo.compCode} 
			]
	});

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			  read : 'gag100ukrvService.selectList',
    	    update : 'gag100ukrvService.update',
    	    create : 'gag100ukrvService.insert',
    	   destroy : 'gag100ukrvService.delete',
		   syncAll : 'gag100ukrvService.saveAll'
		}
	});	
    var masterStore =  Unilite.createStore('${PKGNAME}store',{
        model: '${PKGNAME}model',
         autoLoad: false,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:true,			// 삭제 가능 여부 
	            useNavi : true			// prev | next 버튼 사용
            },
            
            proxy: directProxy,
            saveStore : function(config)	{				
				var inValidRecs = this.getInvalidRecords();				
				if(inValidRecs.length == 0 )	{
					this.syncAllDirect();					
				}else {
					var grid = Ext.getCmp('${PKGNAME}grid');
                	grid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			} ,
			loadStoreRecords: function(record)	{				
				var param= {
					'DIV_CODE' : record.get('DIV_CODE'),
					'ROUTE_CODE': record.get('ROUTE_CODE'),
					'ROUTE_START_DATE': UniDate.getDateStr(record.get('ROUTE_START_DATE'))
				}
				this.load({params: param});				
			},
			listeners:{
				load:function()	{
					detailStore.clearData(); 
					detailStoreForCash.clearData();
					detailView.refresh();
					detailViewForCash.refresh();
				}
			}
            
		});
	
	Unilite.defineModel('${PKGNAME}detailModel', {
	    fields: [
					 {name: 'DIV_CODE'   			,text:'사업장'			,type : 'string'   	,comboType: 'BOR120' ,allowBlank:false } 
					,{name: 'ROUTE_CODE'    		,text:'노선코드'		,type : 'string'   	,allowBlank:false} 
					,{name: 'ROUTE_START_DATE'    	,text:'노선변경적용일'	,type : 'uniDate'  	,allowBlank:false} 					
					,{name: 'ASSIGN_START_DATE'    	,text:'차량배정적용일'	,type : 'uniDate'  	,allowBlank:false } 		
					,{name: 'OPERATION_COUNT'   	,text:'운행순번'		,type : 'uniQty'  	,allowBlank:false} 							
					,{name: 'VEHICLE_CODE'    		,text:'차량코드'		,type : 'string'  	} 		
					,{name: 'VEHICLE_NAME'    		,text:'차량코드'		,type : 'string'  	}
					,{name: 'SELF_CNT'   			,text:'자차댓수'		,type : 'uniQty'  	} 							
					,{name: 'OTHER_CNT'   			,text:'타차댓수'		,type : 'uniQty'  	} 	
					,{name: 'OTHER_VEHICLE_YN'   	,text:'타차여부'		,type : 'string'  	} 	
					,{name: 'REMARK'  				,text:'비고'			,type : 'string'} 
					,{name: 'COMP_CODE'  			,text:'법인코드'		,type : 'string'  ,allowBlank:false ,defaultValue: UserInfo.compCode} 
			]
	});

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			  read : 'gag100ukrvService.detailList',
            update : 'gag100ukrvService.updateDetail',
			syncAll: 'gag100ukrvService.saveDetail'
		}
	});
    var detailStore =  Unilite.createStore('${PKGNAME}detailStore',{
        model: '${PKGNAME}detailModel',
         autoLoad: false,
            uniOpt : {
            	isMaster: false,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            
            proxy: directProxy,
            saveStore : function(config)	{				
				var inValidRecs = this.getInvalidRecords();				
				if(inValidRecs.length == 0 )	{
					var cnt = 0
					Ext.each(this.data.items, function(item, idx) { 
		        		if(item.get("OTHER_VEHICLE_YN") == 'Y' )	{
		        			cnt = cnt+1;
		        		}
		        	});
		        	
		        	if(cnt != this.getAt(0).get("OTHER_CNT"))	{
		        		alert("자차댓수와 타차댓수가 다릅니다.")
		        		return;
		        	}
					if(config==null)	{
						config = {
							params:[panelSearch.getValues()],
							success: function()	{
								UniAppManager.app.setToolbarButtons('save',false);									
							}	
						}
					}
					this.syncAllDirect(config);					
				}
			} ,
			loadStoreRecords: function(record)	{				
				var param= {
					'DIV_CODE' : record.get('DIV_CODE'),
					'ROUTE_CODE': record.get('ROUTE_CODE'),
					'ROUTE_START_DATE': UniDate.getDateStr(record.get('ROUTE_START_DATE')),
					'ASSIGN_START_DATE': UniDate.getDateStr(record.get('ASSIGN_START_DATE'))
				}
				this.load({params: param});				
			}
            
		});
	
	var directProxyForCash = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			 read : 'gag100ukrvService.detailListForCash',
			create : 'gag100ukrvService.insertDetailForCash',
            update : 'gag100ukrvService.updateDetailForCash',
            destroy: 'gag100ukrvService.deleteDetailForCash',
			syncAll: 'gag100ukrvService.saveDetailForCash'
		}
	});
	 var detailStoreForCash =  Unilite.createStore('${PKGNAME}detailStoreForCash',{
        model: '${PKGNAME}detailModel',
         autoLoad: false,
            uniOpt : {
            	isMaster: false,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            
            proxy: directProxyForCash,
            saveStore : function(config)	{				
				var inValidRecs = this.getInvalidRecords();				
				if(inValidRecs.length == 0 )	{
					/*var cnt = 0
					Ext.each(this.data.items, function(item, idx) { 
		        		if(item.get("OTHER_VEHICLE_YN") == 'Y' )	{
		        			cnt = cnt+1;
		        		}
		        	});
		        	
		        	if(cnt != this.getAt(0).get("OTHER_CNT"))	{
		        		alert("자차댓수와 타차댓수가 다릅니다.")
		        		return;
		        	}*/
					if(config==null)	{
						config = {
							params:[panelSearch.getValues()],
							success: function()	{
								UniAppManager.app.setToolbarButtons('save',false);									
							}	
						}
					}
					this.syncAllDirect(config);					
				}
			} ,
			loadStoreRecords: function(record)	{				
				var param= {
					'DIV_CODE' : record.get('DIV_CODE'),
					'ROUTE_CODE': record.get('ROUTE_CODE'),
					'ROUTE_START_DATE': UniDate.getDateStr(record.get('ROUTE_START_DATE')),
					'ASSIGN_START_DATE': UniDate.getDateStr(record.get('ASSIGN_START_DATE'))
				}
				this.load({params: param});				
			}
            
		});
		
	Unilite.defineModel('${PKGNAME}routeHistoryModel', {
	    fields: [
					 {name: 'ROUTE_CODE'    		,text:'노선코드'		,type : 'string' } 
					,{name: 'ROUTE_NUM'    			,text:'노선번호'		,type : 'string' } 	
					,{name: 'ROUTE_NAME'    		,text:'노선명'			,type : 'string' } 	
					,{name: 'ROUTE_START_DATE'    	,text:'노선변경적용일'	,type : 'uniDate' } 					
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
					detailStore.clearData(); 
					detailView.refresh();
					detailStoreForCash.clearData(); 
					detailViewForCash.refresh();
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
      			if(masterStore.isDirty() || detailStore.isDirty()|| detailStoreForCash.isDirty())	{
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
		title: '노선정보',
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
						fieldLabel: '노선명',
						name: 'ROUTE_NAME'	
					},{	    
						fieldLabel: '기준일',
						name: 'SEARCH_DATE',
						xtype: 'uniDatefield',
			            value: UniDate.today(),
			            allowBlank: false
					}]				
				},{	
					header:false,
		   			itemId: 'search_panel2',
		   			layout:{type:'vbox', align:'stretch'},
		   			flex: .8,
		           	items: [routeHistoryGrid]			
				}]

	});	//end panelSearch  	
		
     var masterGrid = Unilite.createGrid('${PKGNAME}grid', {
        layout : 'fit',       
    	flex: .35,
		uniOpt:{
        	expandLastColumn: false,
            useMultipleSorting: false,
            state: {
			   useState: true,   
			   useStateList: true  
			}
        },
       
    	store: masterStore,
    	itemId:'masterGrid',
		columns:[
			{dataIndex:'DIV_CODE'				,width: 80},
			{dataIndex:'ROUTE_CODE'				,width: 100},
			{dataIndex:'ROUTE_START_DATE'		,width: 110},
			{dataIndex:'ASSIGN_START_DATE'		,width: 110},
			{dataIndex:'ASSIGN_END_DATE'		,width: 110},
			{dataIndex:'OPERATION_TOT_COUNT'	,width: 80},
			{dataIndex:'SELF_CNT'				,width: 80},
			{dataIndex:'OTHER_CNT'				,width: 80},
			
			{dataIndex:'REMARK'					,flex: 1}
		],
		beforeSelectedRecord : '',
		checkSelectChangeRow: function(selected)	{
         	var pRec = this.beforeSelectedRecord;
         	console.log("pRec",pRec);
         	if( !Ext.isEmpty(pRec)
         	  	&& UniDate.getDateStr(pRec.get("ASSIGN_START_DATE")) !== UniDate.getDateStr(selected.get("ASSIGN_START_DATE"))
         	  	&& UniDate.getDateStr(pRec.get("ROUTE_START_DATE")) !== UniDate.getDateStr(selected.get("ROUTE_START_DATE"))
         	  	&& UniDate.getDateStr(pRec.get("ROUTE_CODE")) !== UniDate.getDateStr(selected.get("ROUTE_CODE"))
         	  )	{
         			return true
         	}
         	return false;
         }
		,listeners: {	
      		selectionchange: function( model, selected, eOpts ) {
      			if(Ext.isEmpty(selected)|| selected.length == 0 || Ext.isEmpty(selected[0].get('ASSIGN_START_DATE')))	{
		      		return;
		      	}
      			
      			if(Ext.isEmpty(masterGrid.beforeSelectedRecord))  masterGrid.beforeSelectedRecord= selected[0];
      			
  				if(masterGrid.checkSelectChangeRow(selected[0]))	{
	      			if(detailStore.isDirty())	{
							if(confirm(Msg.sMB061))	{
								var config = {
									success: function()	{
										detailStore.loadStoreRecords(selected[0]);
										detailStoreForCash.loadStoreRecords(selected[0]);
									}
								}
								UniAppManager.app.onSaveDataButtonDown(config);
							}  else {
								UniAppManager.app.rejectSave();
							}
		      		}else {
		      			detailStore.loadStoreRecords(selected[0]);  
		      			detailStoreForCash.loadStoreRecords(selected[0]);
		      		}
      			}else {
	      			detailStore.loadStoreRecords(selected[0]); 
	      			detailStoreForCash.loadStoreRecords(selected[0]);
				}
				masterGrid.beforeSelectedRecord = selected[0];
      		}
         }
         
   });
   
    var detailTplTemplate =  new Ext.XTemplate( '<tpl for=".">' +
    		'<div class="data-source busData2" style="border: 1px solid #ffffff">' ,	     
    			'<tpl if="OTHER_VEHICLE_YN == \'Y\'">	' ,
    				'<div class="busItemMedium-gray">',
    			'</tpl>',
    			'<tpl if="OTHER_VEHICLE_YN == \'N\'">	' ,
                	'<div class="busItemMedium">',
                '</tpl>',
                '<table  cellspacing="0" cellpadding="0" width="100%" border="0">',        	
            	'<tr><td  height="30" style="padding-left:20px;vertical-align: bottom;">{VEHICLE_NAME}</td>',            		
            	'<tr height="18">',
            		'<td  style="padding-left:15px;">{OPERATION_COUNT}순위</td>',
            	'</tr>',
            	'</table></div></div>'+
        '</tpl>' );
    var detailView =  Ext.create('UniDragandDropView', {
    	region:'south',
    	weight:-100,
    	flex:.35,
    	border: true,
    	autoScroll: true,
		tpl: detailTplTemplate,
        store: detailStore,
        style:{
        		'background-color': '#fff' ,
        		'border': '1px solid #9598a8; '
        },
        itemSelector: 'div.data-source',
        onDropEnter: function(target, dd, e, drag)	{
        	var me = this;
        	var drop = me.getDropRecord();
        	me.setAllowDrop(true);
        	
        	var chkDuplicateVehicle = false;
        	if("uniDragandDropView" != drag.view.getXType())	{
	        	Ext.each(detailStore.data.items, function(item, idx) { 
	        		if(drag.record.get("VEHICLE_CODE") == item.get("VEHICLE_CODE") )	{
	        			chkDuplicateVehicle = true;
	        		}
	        	});
        	}
        	
        	if( chkDuplicateVehicle /*|| drop.get("OPERATION_COUNT") > drop.get("SELF_CNT") */)	{
        		me.setAllowDrop(false);
        		return false;
        	}
        	
        	return true;
        },
        
        onDrop : function(target, dd, e, drag){
        	var me = this;
        	var drop = me.getDropRecord();
        	var dragRec ;
        	
        	var store = me.getStore();	           
	        
        	if("uniDragView" == drag.view.getXType())	{
        		dragRec = drag.record;
        	}else if("uniDragandDropView" == drag.view.getXType())	{
        		dragRec = drag.record;
        	}else {
        		dragRec = drag.records[0];
        	}
        	
	        var dropVehicleCode = drop.get("VEHICLE_CODE");
	        var dropVehicleName = drop.get("VEHICLE_NAME");
	        var dropOtherVehicleYn = drop.get("OTHER_VEHICLE_YN");
	        //if(drop.get("OPERATION_COUNT") <= drop.get("SELF_CNT") )	{        	
	        if( this.allowDrop )	{
	        	/*if(dragRec.get("OTHER_VEHICLE_YN")=="Y")	{
	        		drop.set("VEHICLE_CODE", '');
			        drop.set("VEHICLE_NAME", '');
			        drop.set("OTHER_VEHICLE_YN", 'Y');
	        	}else {*/
			        drop.set("VEHICLE_CODE", dragRec.get("VEHICLE_CODE"));
			        drop.set("VEHICLE_NAME", dragRec.get("VEHICLE_NAME"));
			        drop.set("OTHER_VEHICLE_YN",  Ext.isEmpty(dragRec.get("OTHER_VEHICLE_YN")) ? "N" : dragRec.get("OTHER_VEHICLE_YN") );
			        console.log("drag.view : ", drag.view);
			        if("uniDragandDropView" == drag.view.getXType())	{
			        	dragRec.set("VEHICLE_CODE", dropVehicleCode);
			        	dragRec.set("VEHICLE_NAME", dropVehicleName);
			        	dragRec.set("OTHER_VEHICLE_YN",  dropOtherVehicleYn);
			        	detailView.refreshNode(store.indexOf( dragRec ));
			        }
	        	//}
		        detailView.refreshNode(store.indexOf( drop ));
		        UniAppManager.app.setToolbarButtons('save',true);
	        }
            return true;
        }
        
    });  	
	
    var detailViewForCash =  Ext.create('UniDragandDropView', {
    	border: false,
    	autoScroll: true,
		tpl: detailTplTemplate,
        store: detailStoreForCash,
        style:{
        		'background-color': '#fff' ,
        		'border': '1px solid #9598a8; '
        },
        itemSelector: 'div.data-source',
        onDropEnter: function(target, dd, e, drag)	{
        	var me = this;
        	var drop = me.getDropRecord();
        	me.setAllowDrop(true);
        	
        	var chkDuplicateVehicle = false;
        	if("uniDragandDropView" != drag.view.getXType())	{
	        	Ext.each(detailStoreForCash.data.items, function(item, idx) { 
	        		if(drag.record.get("VEHICLE_CODE") == item.get("VEHICLE_CODE") )	{
	        			chkDuplicateVehicle = true;
	        		}
	        	});
        	}
        	
        	if( chkDuplicateVehicle /*|| drop.get("OPERATION_COUNT") > drop.get("SELF_CNT") */)	{
        		me.setAllowDrop(false);
        		return false;
        	}
        	
        	return true;
        },
        
        onDrop : function(target, dd, e, drag){
        	var me = this;
        	var drop = me.getDropRecord();
        	var dragRec ;
        	
        	var store = me.getStore();	           
	        
        	if("uniDragView" == drag.view.getXType())	{
        		dragRec = drag.record;
        	}else if("uniDragandDropView" == drag.view.getXType())	{
        		dragRec = drag.record;
        	}else {
        		dragRec = drag.records[0];
        	}
        	
	        var dropVehicleCode = drop.get("VEHICLE_CODE");
	        var dropVehicleName = drop.get("VEHICLE_NAME");
	        var dropOtherVehicleYn = drop.get("OTHER_VEHICLE_YN");
	        //if(drop.get("OPERATION_COUNT") <= drop.get("SELF_CNT") )	{        	
	        if( this.allowDrop )	{
	        	/*if(dragRec.get("OTHER_VEHICLE_YN")=="Y")	{
	        		drop.set("VEHICLE_CODE", '');
			        drop.set("VEHICLE_NAME", '');
			        drop.set("OTHER_VEHICLE_YN", 'Y');
	        	}else {*/
			        drop.set("VEHICLE_CODE", dragRec.get("VEHICLE_CODE"));
			        drop.set("VEHICLE_NAME", dragRec.get("VEHICLE_NAME"));
			        drop.set("OTHER_VEHICLE_YN",  Ext.isEmpty(dragRec.get("OTHER_VEHICLE_YN")) ? "N" : dragRec.get("OTHER_VEHICLE_YN") );
			        console.log("drag.view : ", drag.view);
			        if("uniDragandDropView" == drag.view.getXType())	{
			        	dragRec.set("VEHICLE_CODE", dropVehicleCode);
			        	dragRec.set("VEHICLE_NAME", dropVehicleName);
			        	dragRec.set("OTHER_VEHICLE_YN",  dropOtherVehicleYn);
			        	detailView.refreshNode(store.indexOf( dragRec ));
			        }
	        	//}
		        detailView.refreshNode(store.indexOf( drop ));
		        UniAppManager.app.setToolbarButtons('save',true);
	        }
            return true;
        }
        
    });  	
    Unilite.defineModel('${PKGNAME}busModel', {
	    fields: [
					 {name: 'DIV_CODE'   		,text:'사업장'		,type : 'string'} 					
					,{name: 'VEHICLE_CODE'    	,text:'차량코드'	,type : 'string'} 
					,{name: 'VEHICLE_NAME'    	,text:'차량번호'	,type : 'string'} 
			]
	});	
	 var busStore = Unilite.createStore('${PKGNAME}busStore',{
        model: '${PKGNAME}busModel',
        idProperty: 'VEHICLE_CODE',
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
                	   read : gop300ukrvService.busList
                }
            },
			loadStoreRecords: function()	{
				var searchForm = Ext.getCmp('${PKGNAME}vehicleSearch');
				var param= searchForm.getValues();
				if(searchForm.isValid())	{
					this.load({params: param});
				}
			}
            
            
		});
	var busView = Ext.create('UniDragView', {
		tpl:'<tpl for=".">'+
                '<div class="bus-source busData2" style="border: 1px solid #ffffff">' +	                 	
                '<div class="busItemMedium"><table  cellspacing="0" cellpadding="0" width="100%" border="0">'+      	
            	'<tr><td  height="30" style="padding-left:20px;vertical-align: bottom;">{VEHICLE_NAME}</td></tr>'+           		
            	'</table></div></div>'+
            '</tpl>' ,
        itemSelector: 'div.bus-source',
        overItemCls: 'bus-over',
        selectedItemClass: 'bus-selected',
        singleSelect: true,
        store: busStore,
        autoScroll:true
    });
    var busGrid =  Unilite.createGrid('${PKGNAME}busGrid', {
        hidden:true,
        height:400,
        margins: 0,
    	store: busStore,
    	uniOpt: {
			expandLastColumn: false,
			useRowNumberer: false
        },
        columns:  [ 
        	{dataIndex:'VEHICLE_NAME' ,flex:1},
        	{dataIndex:'VEHICLE_CODE' ,width:80} 
        ],
     
        viewConfig: {
        	itemId:'busList',
            plugins: {
                ddGroup: 'dataGroup',
                ptype: 'gridviewdragdrop',
                enableDrop: false,
                enableDrag: true
            }
        }
    });
	Unilite.defineModel('gag100ukrvOtherVehicleModel', {
	    fields: [
					 {name: 'OTHER_VEHICLE_YN'   		,text:'타차'		,type : 'string'} 		
				]
    });
    var otherVehicleStore =  Unilite.createStore('gag100ukrvOtherVehicleStore',{ //Ext.create('Ext.data.Store', {
     model: 'gag100ukrvOtherVehicleModel',
     data : [
         {OTHER_VEHICLE_YN: 'Y'}
     ]
 	});
     var otherVehicle = Ext.create('UniDragView', {
		tpl: '<tpl for=".">'+
			 '<div class="data-source" style="border: 1px solid #ffffff">' +	                 	
                '<div class="busItemMedium-gray""><table  cellspacing="0" cellpadding="0" width="100%" border="0">'+      	
            	'<tr><td  height="30" style="padding-left:20px;vertical-align: bottom;">타차</td></tr>'+           		
            	'</table></div></div>'+
        	  '</tpl>',
        itemSelector: 'div.data-source',
        overItemCls: 'data-over',
        selectedItemClass: 'data-selected',
        store: otherVehicleStore
    });
    var panelSearch2 = Unilite.createOperatePanel('${PKGNAME}vehicleSearch',{
		title: '참조정보',
		defaultType: 'uniSearchSubPanel',
        defaults: {
			autoScroll:true
	  	},
        width: 330,
		items: [{	
					title: '차량정보', 
					layout: {type: 'uniTable', columns: 1},
		   			defaults: {
						autoScroll:true
				  	},
				  	collapsible:false,
				  	defaultType: 'uniTextfield', 
				  	defaults:{	           		
						listeners:{
							specialkey: function(field, e){
			                    if (e.getKey() == e.ENTER) {
			                       busStore.loadStoreRecords();
			                    }
			                }
						}	
		           	},
		            tools: [{
			        			type: 'search',
			        			handler:function()	{
			        				busStore.loadStoreRecords();
			        			}
			        		},{
								type: 'hum-grid',					            
					            handler: function () {
					            	busView.hide();
					                busGrid.show();
					            }
			        		},{

								type: 'hum-photo',					            
					            handler: function () {
					                busGrid.hide();
					                busView.show();
					            }
			        		}
							
						],
			    	items:[{	    
							fieldLabel: '사업장',
							name: 'DIV_CODE',
							xtype:'uniCombobox',
							comboType:'BOR120',
							value: UserInfo.divCode,
							allowBlank:false
							},{	    
								fieldLabel: '차량코드',
								name: 'VEHICLE_CODE'
							},{	    
								fieldLabel: '차량명',
								name: 'VEHICLE_NAME'	
							}
						]	
		    	},{
					itemId:'otherVehicle',
					header:false,
					autoScroll:false,
			        border:0,
			        layout: {type: 'uniTable', columns: 1},
			        height:80,
			        items: [otherVehicle]
					
				}, {
		    		xtype:'panel',
					itemId:'vehicle',
			        border:0,
			        header: false,
			        width:330,
			        flex:1,
			        layout: {type: 'vbox', align:'stretch'},
			        items: [busView, busGrid]
				}]

		});	//end panelSearch  	

       
    var centerPanel = {
   		region:'center',
    	xtype:'container',
    	layout: {type:'vbox' ,align:'stretch'},
    	items:[
    			masterGrid,
	 		  	detailView,
	 		  	{xtype:'panel',
	 		  	layout:{type:'vbox' ,align:'stretch'},
	 		  	flex:.3,
	 		  	region:'south',
    			weight:-100,
	 		  	tbar:[
	 		  		'->',
		        	{xtype:'button',
		        	 text:'추가',
		        	 handler:function()	{
		        	 	var masterRecord = masterGrid.getSelectedRecord();
		        	 	if(masterRecord)	{
			        	 	var values = {
			        	 		'COMP_CODE'			: UserInfo.compCode,
								'DIV_CODE' 			: masterRecord.get("DIV_CODE"),
								'ROUTE_CODE'		: masterRecord.get("ROUTE_CODE"),
								'ROUTE_START_DATE'	: masterRecord.get("ROUTE_START_DATE"),
								'ASSIGN_START_DATE'	: masterRecord.get("ASSIGN_START_DATE"),
								'OPERATION_COUNT' 	: Unilite.nvl(detailStoreForCash.max('OPERATION_COUNT'),0)+1 ,
								'OTHER_VEHICLE_YN'	: 'N'
			        	 	}
							var newRecord =  Ext.create (detailStoreForCash.model,values);
							var index	= detailStoreForCash.getCount()
							detailStoreForCash.insert(index, newRecord);
							UniAppManager.app.setToolbarButtons('save',true);	
		        	 	} else {
		        	 		alert("배정노선을 선택하세요.");
		        	 	}
		        	 }
		        	},
		        	{xtype:'button',
		        	 text:'삭제',
		        	 handler:function()	{
						var records	= detailViewForCash.getRecords(detailViewForCash.getSelectedNodes());
						if(records)	{
							detailStoreForCash.remove(records);
							detailViewForCash.refresh();
							UniAppManager.app.setToolbarButtons('save',true);	
						}
		        	 }
		        	}
		        ],
	 		  	items:[detailViewForCash]
	 		  	}
	 		  	
    	]
    }
	
      Unilite.Main({
		borderItems:[
	 		  panelSearch,
	 		  centerPanel,
	 		  panelSearch2
		],
		id  : '${PKGNAME}ukrApp',
		autoButtonControl : false,
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['print'],false);
			UniAppManager.setToolbarButtons(['reset', 'newData', 'excel' ],true);
			busStore.loadStoreRecords();
		},
		
		onQueryButtonDown : function()	{
			routeHistoryStore.loadStoreRecords();
		},
		
		onNewDataButtonDown:  function()	{
				var selectedRec = routeHistoryGrid.getSelectedRecord();
				if(!Ext.isEmpty(selectedRec))	{
					var r = { 'DIV_CODE': panelSearch.getValue('DIV_CODE'),				
							  'ROUTE_CODE' : selectedRec.get('ROUTE_CODE'),
							  'ROUTE_START_DATE' : selectedRec.get('ROUTE_START_DATE'),
							  'OPERATION_TOT_COUNT' : selectedRec.get('ACTUAL_CNT'),
							  'SELF_CNT' : selectedRec.get('SELF_CNT'),
							  'OTHER_CNT' : selectedRec.get('OTHER_CNT')
							}
					masterGrid.createRow(r);
				}else {
					alert('노선이력정보를 조회 후 선택하세요.')
				}
		},	
		onSaveDataButtonDown: function (config) {
			masterStore.saveStore(config);	
			detailStore.saveStore(config);	
			detailStoreForCash.saveStore(config);	
		},
		onDeleteDataButtonDown : function()	{
			if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				masterGrid.deleteSelectedRow();				
			}
		},
		onResetButtonDown:function() {
			var me = this;
			panelSearch.reset();
			routeHistoryGrid.reset();
			masterGrid.reset();
			//detailView.reset();
			UniAppManager.setToolbarButtons('save',false);
		},
		onSaveAsExcelButtonDown: function() {
			
			 masterGrid.downloadExcelXml();
		},
		rejectSave: function() {			
			masterStore.rejectChanges();	
			masterStore.onStoreActionEnable();
			detailStore.rejectChanges();	
			detailStore.onStoreActionEnable();
			detailStoreForCash.rejectChanges();	
			detailStoreForCash.onStoreActionEnable();
		}
	});

	Unilite.createValidator('${PKGNAME}validator', {
		store : masterStore,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName)	{
				case 'ROUTE_START_DATE' :		
					var params = {
						'COMP_CODE': UserInfo.compCode,
						'DIV_CODE' : record.get('DIV_CODE'),
						'ROUTE_CODE': record.get('ROUTE_CODE'),
						'ROUTE_START_DATE': UniDate.getDateStr(newValue),
						'ASSIGN_START_DATE': UniDate.getDateStr(record.get('ASSIGN_START_DATE'))
					}
					
					Ext.getBody().mask();
					var rec = record;
					gag100ukrvService.checkDate(params, function(provider, response)	{
						if(provider['CNT'] > 0)	{
							alert('입력된 노선변경적용일은 이미 등록되어 있습니다.'+'\n'+'기존 등록된 변경적용일 이후의 날짜를 등록하세요.')
							rec.set('ROUTE_START_DATE', oldValue);
						}
						Ext.getBody().unmask();
					})
					break;
				case 'ASSIGN_START_DATE' :		
					var params = {
						'COMP_CODE': UserInfo.compCode,
						'DIV_CODE' : record.get('DIV_CODE'),
						'ROUTE_CODE': record.get('ROUTE_CODE'),
						'ROUTE_START_DATE': UniDate.getDateStr(record.get('ROUTE_START_DATE')),
						'ASSIGN_START_DATE': UniDate.getDateStr(newValue)
					}
					
					Ext.getBody().mask();
					var rec = record;
					gag100ukrvService.checkDate(params, function(provider, response)	{
						if(provider['CNT'] > 0)	{
							alert('입력된 노선변경적용일은 이미 등록되어 있습니다.'+'\n'+'기존 등록된 변경적용일 이후의 날짜를 등록하세요.')
							rec.set('ASSIGN_START_DATE', oldValue);							
						}
						Ext.getBody().unmask();
					})
					break;
				default :
					break;
			}
			return rv;
		}
	}); // validator
	
}; // main
  
</script>