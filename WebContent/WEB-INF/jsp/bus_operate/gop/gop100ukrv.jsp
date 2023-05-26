<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
//차량배차작업
request.setAttribute("PKGNAME","Unilite_app_gop100ukrv");
%>
<t:appConfig pgmId="gop100ukrv"  >
	<t:ExtComboStore comboType="AU" comboCode="GO01"/>				<!-- 영업소   	-->  
	<t:ExtComboStore comboType="AU" comboCode="GO02"/>				<!-- 운행조   	-->  
	<t:ExtComboStore items="${ROUTE_COMBO}" storeId="routeStore" /> <!-- 노선 -->
	<t:ExtComboStore comboType="AU" comboCode="GO16"/>				<!-- 노선그룹  	-->	
	<t:ExtComboStore comboType="AU" comboCode="AO20"/>				<!-- 예/아니오  	-->	
</t:appConfig>
<script type="text/javascript">
var editWindow;
var confirmWindow;

function appMain() {
	Unilite.defineModel('gop100ukrvModel', {
	    fields: [
					 {name: 'DIV_CODE'   			,text:'사업장'		,type : 'string'} 
					,{name: 'OPERATION_DATE'    	,text:'운행일'		,type : 'string', convert:function(v) {return UniDate.safeFormat(v)} } 
					,{name: 'OFFICE_CODE'    		,text:'영업소코드'	,type : 'string'} 
					,{name: 'OFFICE_NAME'    		,text:'영업소'		,type : 'string'} 
					,{name: 'TEAM_CODE'    			,text:'운행조코드'	,type : 'string'} 
					,{name: 'TEAM_NAME'    			,text:'운행조'		,type : 'string'} 
					,{name: 'ROUTE_CODE'    		,text:'노선코드'	,type : 'string'} 
					,{name: 'ROUTE_NUM'    			,text:'노선번호'	,type : 'string'} 
					,{name: 'OPERATION_COUNT'  		,text:'운행순번'	,type : 'string'} 
					,{name: 'VEHICLE_CODE'    		,text:'차량코드'	,type : 'string'} 
					,{name: 'VEHICLE_NAME'    		,text:'차량번호'	,type : 'string'} 
					,{name: 'CONFIRM_YN'    		,text:'확정'		,type : 'string'} 
					,{name: 'CONFIRM_YN_TEXT'    	,text:'확정'		,type : 'string'} 
					,{name: 'OPERATION_DW'    		,text:'운행요일'		,type : 'string'} 
					,{name: 'NOTINSERVICE_YN'    	,text:'운휴'		,type : 'string'} 
					,{name: 'OTHER_VEHICLE_YN'    	,text:'타차여부'		,type : 'string'}					
					,{name: 'REMARK'  				,text:'비고'			,type : 'string'} 
					,{name: 'MAX_OPERATION_COUNT'   ,text:'VIEW PROPERTY'	,type : 'string'} 	// 조회 최다운행수
					,{name: 'DT_MAX_OPERATION_COUNT',text:'VIEW PROPERTY'	,type : 'string'}   // 일일 최다운행수
					,{name: 'DT_MIN_OPERATION_COUNT',text:'VIEW PROPERTY'	,type : 'string'}	// 일일 최초운행수					
					,{name: 'FULL_OPERRATION'		,text:'VIEW PROPERTY'	,type : 'string'}   // 조회 최다운행의 일자-노선-반
					,{name: 'OPERTATION'			,text:'VIEW PROPERTY'	,type : 'string'}   // 조회 일일운행의 일자-노선-반
					,{name: 'COLSPAN'    			,text:'VIEW PROPERTY'	,type : 'int'} 		// 운행하지 않는 차수 컬럼 COLSPAN
			]
	});
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			 read : gop100ukrvService.selectList,
            update : gop100ukrvService.update,
			syncAll: 'gop100ukrvService.saveAll'
		}
	});
    var masterStore =  Unilite.createStore('gop100ukrvStore',{
        model: 'gop100ukrvModel',
         autoLoad: false,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            proxy: directProxy,
            saveStore : function(config)	{				
				var inValidRecs = this.getInvalidRecords();
				console.log("store : ", this);
				console.log("inValidRecords : ", inValidRecs);
				config = {
					params:[panelSearch.getValues()],
					success: function()	{
						xlsStore.loadStoreRecords();
					}
				}
				if(inValidRecs.length == 0 )	{
					this.syncAllDirect(config);					
				}else {
					alert(Msg.sMB083);
				}
			} ,
			loadStoreRecords: function()	{
				var searchForm = Ext.getCmp('${PKGNAME}-searchForm');
				var param= searchForm.getValues();
				if(searchForm.isValid())	{
					this.load({params: param});
				}
			}
		});
	
	var panelSearch = Unilite.createSearchPanel('${PKGNAME}-searchForm',{
		title: '차량배차정보',
        defaultType: 'uniSearchSubPanel',
        defaults: {
			autoScroll:true
	  	},
        width: 350,
		items: [{	
					title: '검색조건', 	
					id: 'search_panel1',
		   			itemId: 'search_panel1',
		   			height:160,
		           	layout: {type: 'uniTable', columns: 1},
		           	defaultType: 'uniTextfield',  
		           	defaults:{
		           		labelWidth:80
		           	},
			    	items:[{	    
						fieldLabel: '영업소',
						name: 'OFFICE_CODE',
						xtype: 'uniCombobox',
						comboType:'AU', 
						comboCode:'GO01'
					},{	    
						fieldLabel: '노선그룹',
						name: 'ROUTE_GROUP'	,
						xtype: 'uniCombobox',
						comboType:'AU', 
						comboCode:'GO16',
						listeners: {
							change:function()	{
								panelSearch.setValue('ROUTE_CODE', '');
							}
						}
					},{	    
						fieldLabel: '노선',
						name: 'ROUTE_CODE'	,
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
						fieldLabel: '운행조',
						name: 'TEAM_CODE',
						xtype: 'uniCombobox',
						comboType:'AU', 
						comboCode:'GO02'
					},{	    
						fieldLabel: '운행일',
						name: 'OPERATION_DATE',
						xtype: 'uniDateRangefield',
			            startFieldName: 'OPERATION_DATE_FR',
			            endFieldName: 'OPERATION_DATE_TO',	
			            startDate: UniDate.get('startOfMonth'),
			            endDate: UniDate.get('endOfMonth'),
			            width:320,
			            allowBlank:false
					}]				
				},{
					itemId:'task',
					title:'차량배차 작업조건',
			        border:0,
			        itemId: 'search_panel2',
		   			height:120,
		           	layout: {type: 'uniTable', columns: 1},
		           	defaultType: 'uniTextfield',  
		           	defaults:{
		           		labelWidth:80
		           	},
			        flex:1,			        
			        items: [{	    
						fieldLabel: '영업소',
						name: 'B_OFFICE_CODE',
						xtype: 'uniCombobox',
						comboType:'AU', 
						comboCode:'GO01'
					},{	    
						fieldLabel: '노선그룹',
						name: 'B_ROUTE_GROUP'	,
						xtype: 'uniCombobox',
						comboType:'AU', 
						comboCode:'GO16',
						listeners: {
							change:function()	{
								panelSearch.setValue('B_ROUTE_CODE', '');
							}
						}
					},{	    
						fieldLabel: '노선',
						name: 'B_ROUTE_CODE'	,
						xtype: 'uniCombobox',
						store: Ext.data.StoreManager.lookup('routeStore'),
						listeners:{
							beforequery: function(queryPlan, eOpts )	{
								var pValue = panelSearch.getValue('B_ROUTE_GROUP');
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
						fieldLabel: '운행일',
						name: 'B_OPERATION_DATE',
						xtype: 'uniDateRangefield',
			            startFieldName: 'B_OPERATION_DATE_FR',
			            endFieldName: 'B_OPERATION_DATE_TO',	
			            startDate: UniDate.get('startOfMonth'),
			            endDate: UniDate.get('endOfMonth'),
			            width:320,
			            allowBlank:false
					},{
			        	xtype:'button',
			        	text:'실행',
			        	width: 300,
			        	tdAttrs:{'align':'center'},
			        	handler: function()	{
			        		var sForm = Ext.getCmp('${PKGNAME}-searchForm');
			        		
			        		if(Ext.isEmpty(sForm.getValue('B_OPERATION_DATE_FR')) )	{
			        			alert("운행일은 필수입력입니다.");
			        			sForm.getField("B_OPERATION_DATE_FR").focus();
			        			return;
			        		}
			        		if(Ext.isEmpty(sForm.getValue('B_OPERATION_DATE_TO')))	{
			        			alert("운행일은 필수입력입니다.");
			        			sForm.getField("B_OPERATION_DATE_TO").focus();
			        			return;
			        		}
			        		if(Ext.isEmpty(sForm.getValue('B_ROUTE_GROUP')))	{
			        			alert("노선그룹은 필수입력입니다.");
			        			sForm.getField("B_ROUTE_GROUP").focus();
			        			return;
			        		}
			        		var params = sForm.getValues();
			        		Ext.getBody().mask();
			        		gop100ukrvService.excuteData(params, function(provider, response)	{
			        			console.log("response", response);
			        			console.log("provider", provider);
			        			if(provider!= null && Ext.isDefined(provider.ErrorDesc) )	{
				        			if( provider.ErrorDesc == '')	{
				        				alert("배차실행이 완료되었습니다.");
				        			}else if(provider.ErrorDesc == '80001;' || provider.ErrorDesc == '80001'){
				        				alert("배차작업기간 내에 확정된 차량배차정보가 존재합니다.");
				        			}else if (provider.ErrorDesc == null){
				        				alert("배차실행에 오류가 있습니다.");
				        			}else {
				        				alert(provider.ErrorDesc);
				        			}
			        			}
			        			Ext.getBody().unmask();
			        		})
			        		  
			        	}
			        }]
			}]
		
	});	//end panelSearch    
	
	
    var masterTplTemplate = new Ext.XTemplate(
	    '<table cellspacing="0" cellpadding="0" border="0" class="x-grid-table" style="border-right: #99bce8 solid 1px;border-bottom: #99bce8 solid 1px;">' ,
	    '<tpl for=".">' ,
	    	'<tpl if="OPERTATION == FULL_OPERRATION">',
				'<tpl if="OPERATION_COUNT == \'1\'">' ,
					'<tr><td width="70" class="x-column-header x-column-header-inner" style="text-align: center;border-left: 0px solid #c5c5c5;">배차확정</td>',
					'<td width="60" class="x-column-header x-column-header-inner" style="text-align: center;border-left: 0px solid #c5c5c5;">영업소</td>',
					'<td width="100" class="x-column-header x-column-header-inner" style="text-align: center;border-left: 0px solid #c5c5c5;">운행일</td>' ,
					'<td width="60" class="x-column-header x-column-header-inner" style="text-align: center;border-left: 0px solid #c5c5c5;">요일</td>' ,
					'<td width="60" class="x-column-header x-column-header-inner" style="text-align: center;border-left: 0px solid #c5c5c5;">노선</td>' ,
					'<td width="60" class="x-column-header x-column-header-inner" style="text-align: center;border-left: 0px solid #c5c5c5;">운행조</td>' ,
				'</tpl>',
				'<td  class="x-column-header x-column-header-inner" style="text-align: center;">{OPERATION_COUNT}번</td>' ,
				'<tpl if="OPERATION_COUNT == MAX_OPERATION_COUNT">',
			 		'</tr>' ,
			 	'</tpl>',
			 '</tpl>',
		 '</tpl>',
		 '<tpl for=".">' ,
			'<tpl if="OPERATION_COUNT == \'1\'">' ,
				'<tr class="x-grid-row x-grid-with-row-lines" height="24">' ,
				'	 <td width="60" align="center" class="x-grid-cell x-grid-with-col-lines x-grid-td  x-grid-cell-inner" style="vertical-align:middle;">' ,
				'		<span>{CONFIRM_YN_TEXT}</span>' ,
				'	 </td>' +
				'	 <td width="60" align="center" class="x-grid-cell x-grid-with-col-lines x-grid-td  x-grid-cell-inner" style="vertical-align:middle;">{OFFICE_NAME}</td>' ,
				'	 <td width="100" align="center" class="x-grid-cell x-grid-with-col-lines x-grid-td x-grid-cell-inner" style="vertical-align:middle;">{OPERATION_DATE}</td>' ,
				'	 <td width="60" align="center" class="x-grid-cell x-grid-with-col-lines x-grid-td x-grid-cell-inner" style="vertical-align:middle;">{OPERATION_DW}</td>' ,
				'	 <td width="60" align="center" class="x-grid-cell x-grid-with-col-lines x-grid-td x-grid-cell-inner" style="vertical-align:middle;">{ROUTE_NUM}</td>' ,
				'	 <td width="60" align="center" class="x-grid-cell x-grid-with-col-lines x-grid-td x-grid-cell-inner" style="vertical-align:middle;">{TEAM_NAME}</td>' ,
			'</tpl>',
				'	<td width="73" align="center" class="x-grid-cell x-grid-with-col-lines x-grid-td x-grid-cell-inner" style="vertical-align:middle;" colspan="{COLSPAN}">' ,
				'		<div class="data-source busData2" style="border: 1px solid #ffffff">',
				'<tpl if="NOTINSERVICE_YN == \'Y\'">',
					'<div class="busItemRedSmall">',
				'</tpl>',
				'<tpl if="NOTINSERVICE_YN != \'Y\'">',
					'<tpl if="OTHER_VEHICLE_YN == \'Y\'">',
						'<div class="busItemGraySmall">',
					'</tpl>',
					'<tpl if="OTHER_VEHICLE_YN != \'Y\'">',
						'<div class="busItemGreenSmall">',
					'</tpl>',					
				'</tpl>',
                '<table  cellspacing="0" cellpadding="0" width="100%" border="0">',     	
            	'<tr><td  height="30" style="padding-left:20px;vertical-align: bottom;">{VEHICLE_NAME}</td></tr>',          		
            	'</table></div></div></td>' ,
	        '<tpl if="OPERATION_COUNT == MAX_OPERATION_COUNT">',
				'</tr>',
			'</tpl>',
        '</tpl>' ,
        '</table>'
	);
	
    var masterView = Ext.create('UniDragandDropView', {
    	flex:1,
        autoScroll:true,
		tpl: masterTplTemplate,
        store: masterStore,
        //trackOver: true,
        style:{
        		'background-color': '#fff' ,
        		'border': '1px'
        },
        itemSelector: 'div.data-source',
        
        onDropEnter: function(target, dd, e, drag)	{
        	var me = this;
        	var drop = me.getDropRecord();
        	var dragRec = drag.record;
        	me.setAllowDrop(false);
        	/*if(drop.get("OTHER_VEHICLE_YN") == "Y")	{
        		me.setAllowDrop(false);
        		return false;
        	}*/
        	if( dragRec.get("OPTION") =="BUSINFO" && drop.get("CONFIRM_YN") != 'Y')	{
        		me.setAllowDrop(true);
        	} else  if(drop.get("OPERATION_DATE") == dragRec.get("OPERATION_DATE") 
        		&& drop.get("ROUTE_CODE") == dragRec.get("ROUTE_CODE") 
        		&& drop.get("OFFICE_CODE") == dragRec.get("OFFICE_CODE")
        		&& drop.get("CONFIRM_YN") != 'Y'
        	)	{
        		me.setAllowDrop(true);
        	} else if( dragRec.get("OPTION") =="OTHER_VEHICLE_INFO"  && drop.get("CONFIRM_YN") != 'Y')	{
        		me.setAllowDrop(true);
        	}  
			
        	if(me.allowDrop)	{	
        		var chkDuplicateVehicle = false;
        		if(dragRec.get("OPTION") =="BUSINFO")	{
		        	Ext.each(masterStore.data.items, function(item, idx) { 
		        		if(	   drop.get("OPERATION_DATE") == item.get("OPERATION_DATE") 
			        		&& drop.get("ROUTE_CODE") == item.get("ROUTE_CODE") 
			        		&& drop.get("OFFICE_CODE") == item.get("OFFICE_CODE")
			        		&& drag.record.get("VEHICLE_CODE") == item.get("VEHICLE_CODE") )	{
		        			chkDuplicateVehicle = true;
		        		}
		        	});
        		}
	        	if(!chkDuplicateVehicle )	{
	        		me.setAllowDrop(true);
	        	}else {
	        		me.setAllowDrop(false);
	        	}
        	}
        	
        	if(me.allowDrop)	{
        		return true;
        	}
        	return false;
        },
        
        onDrop : function(target, dd, e, drag){
        	var me = this;
        	if(me.allowDrop)	{
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
	        	/*if(dragRec.get("OTHER_VEHICLE_YN") == "Y")	{
	        		alert("타차는 변경이 불가능합니다.");
	        		return false;
	        	}*/
		        var dropVehicleCode = drop.get("VEHICLE_CODE");
		        var dropVehicleName = drop.get("VEHICLE_NAME");		        
			    var dropOtherVehicleYn = drop.get("OTHER_VEHICLE_YN");		
			    var dropNotServiceYn = drop.get("NOTINSERVICE_YN"); 
		        if((dragRec.get("OPTION") =="BUSINFO" && drop.get("CONFIRM_YN") != 'Y')
		        	|| (drop.get("OPERATION_DATE") == dragRec.get("OPERATION_DATE") 
		        		&& drop.get("ROUTE_CODE") == dragRec.get("ROUTE_CODE") 
		        		&& drop.get("OFFICE_CODE") == dragRec.get("OFFICE_CODE")
		        		&& drop.get("CONFIRM_YN") != 'Y'		        	
		        	   )
		        	 || (dragRec.get("OPTION") =="OTHER_VEHICLE_INFO" && drop.get("CONFIRM_YN") != 'Y' )
		        	)	{
			        drop.set("VEHICLE_CODE", dragRec.get("VEHICLE_CODE"));
			        drop.set("VEHICLE_NAME", dragRec.get("VEHICLE_NAME"));	
			        drop.set("OTHER_VEHICLE_YN",   dragRec.get("OTHER_VEHICLE_YN") );
			        drop.set("NOTINSERVICE_YN",   dragRec.get("NOTINSERVICE_YN") );
			        
			        masterView.refreshNode(store.indexOf( drop ));
		
			        if(!(dragRec.get("OPTION") == "BUSINFO" || dragRec.get("OPTION") == "OTHER_VEHICLE_INFO") )	{ 
			        	dragRec.set("VEHICLE_CODE", dropVehicleCode);
			        	dragRec.set("VEHICLE_NAME", dropVehicleName);
			        	dragRec.set("OTHER_VEHICLE_YN", dropOtherVehicleYn);
			        	dragRec.set("NOTINSERVICE_YN", dropNotServiceYn);
			        	masterView.refreshNode(store.indexOf( dragRec ));
		        	}
		        }
        	}
            return true;
        },
        listeners: {
            render: function()	{
            	var me = this;
            	this.getEl().on('dblclick', function(e, t, eOpt) {
            		var selectEl = me.getSelectedNodes();
            		var record = me.getRecord(selectEl[0]);
            		if(record && record.get("CONFIRM_YN") !='Y')	{
            			if(record.get("NOTINSERVICE_YN") == 'Y')	{
            				record.set("NOTINSERVICE_YN",'N');
            			}else {
            				record.set("NOTINSERVICE_YN",'Y')
            			}
            			masterView.refreshNode(masterStore.indexOf( record ));
            		}else {
            			alert("확정된 배차는 운휴로 변경이 불가능합니다.");
            		}
			    	//openWindow(me.getRecord(selectEl[0]));
			    });
            },
            beforeshow: function()	{
        		xlsGrid.hide();
        	}
        }
    });
    
    Unilite.defineModel('${PKGNAME}-busModel', {
	    fields: [
					 {name: 'DIV_CODE'   		,text:'사업장'		,type : 'string'} 					
					,{name: 'VEHICLE_CODE'    	,text:'차량코드'	,type : 'string'} 
					,{name: 'VEHICLE_NAME'    	,text:'차량번호'	,type : 'string'} 
					,{name: 'OTHER_VEHICLE_YN'  ,text:'타차여부'	,type : 'string', 	defaultValue:'N'} 
					,{name: 'OPTION'    		,text:'옵션'		,type : 'string', 	defaultValue:'BUSINFO'} 
			]
	});	
	
	var busStore = Unilite.createStore('${PKGNAME}-busStore',{
        model: '${PKGNAME}-busModel',
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
				var searchForm = Ext.getCmp('${PKGNAME}-vehicleSearch');
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
        store: busStore
    });
    var busGrid =  Unilite.createGrid('${PKGNAME}-busGrid', {
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
    
    Unilite.defineModel('gop100ukrvOtherVehicleModel', {
	    fields: [
					 {name: 'OTHER_VEHICLE_YN'   		,text:'타차'		,type : 'string'},	 
					 {name: 'OPTION'   					,text:'구분'		,type : 'string'} 
				]
    });
    var otherVehicleStore =  Unilite.createStore('gop100ukrvOtherVehicleStore',{ //Ext.create('Ext.data.Store', {
     model: 'gop100ukrvOtherVehicleModel',
     data : [
         {OTHER_VEHICLE_YN: 'Y', OPTION: 'OTHER_VEHICLE_INFO'}
     ]
 	});
     var otherVehicle = Ext.create('UniDragView', {
		tpl: '<tpl for=".">'+
			 '<div class="data-source" style="border: 1px solid #ffffff;padding-left:4px;padding-top:4px;">' +	                 	
                '<div class="busItemMedium-gray"><table  cellspacing="0" cellpadding="0" width="100%" border="0">'+      	
            	'<tr><td  height="30" style="padding-left:20px;vertical-align: bottom;">타차</td></tr>'+           		
            	'</table></div></div>'+
        	  '</tpl>',
        itemSelector: 'div.data-source',
        overItemCls: 'data-over',
        selectedItemClass: 'data-selected',
        store: otherVehicleStore
    });
    
    var panelSearch2 = Unilite.createOperatePanel('${PKGNAME}-vehicleSearch',{
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
						autoScroll:true,		           		
						listeners:{
							specialkey: function(field, e){
			                    if (e.getKey() == e.ENTER) {
			                       busStore.loadStoreRecords();
			                    }
			                }
						}	
				  	},
					collapsible:false,
					defaultType: 'uniTextfield', 
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
			    	
		    		items: [{	    
							fieldLabel: '사업장',
							name: 'DIV_CODE',							
							value: UserInfo.divCode,
							hidden:true
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
				},{
		    		xtype:'panel',
					itemId:'vehicle',
			        border:0,
			        header: false,
			        flex:1,
			        width:330,
			        layout: {type: 'vbox', align:'stretch'},
			        items: [busView, busGrid]
				}
			]

		});	//end panelSearch  
    
    
    var confirmSearch= Unilite.createSearchForm('${PKGNAME}-conFirmSearchForm', {
		           	layout: {type: 'uniTable', columns: 3},
    				//layout: {type: 'vbox', align: 'stretch'},
		           	defaults:{
		           		labelWidth:60
		           	},
			    	items:[{	    
						fieldLabel: '영업소',
						name: 'OFFICE_CODE',
						xtype: 'uniCombobox',
						comboType:'AU', 
						comboCode:'GO01'
					},{	    
						fieldLabel: '노선그룹',
						name: 'ROUTE_GROUP'	,
						xtype: 'uniCombobox',
						comboType:'AU', 
						comboCode:'GO16',
						listeners: {
							change:function()	{
								confirmSearch.setValue('ROUTE_CODE', '');
							}
						}
					},{	    
						fieldLabel: '노선',
						name: 'ROUTE_CODE'	,
						xtype: 'uniCombobox',
						store: Ext.data.StoreManager.lookup('routeStore'),
						listeners:{
							beforequery: function(queryPlan, eOpts )	{
								var pValue = confirmSearch.getValue('ROUTE_GROUP');
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
						fieldLabel: '운행조',
						name: 'TEAM_CODE',
						xtype: 'uniCombobox',
						comboType:'AU', 
						comboCode:'GO02'
					},{	    
						fieldLabel: '운행일',
						name: 'OPERATION_DATE',
						xtype: 'uniDateRangefield',
			            startFieldName: 'OPERATION_DATE_FR',
			            endFieldName: 'OPERATION_DATE_TO',	
			            startDate: UniDate.get('startOfMonth'),
			            endDate: UniDate.get('endOfMonth'),
			            width:320,
			            colspan:2,
			            allowBlank:false
					}
	 		 	]
    })
    
    Unilite.defineModel('gop100ukrvConfirmModel', {
	    fields: [
					 {name: 'DIV_CODE'   			,text:'사업장'		,type : 'string',	comboType:'BOR120'} 
					,{name: 'OPERATION_DATE'    	,text:'운행일'		,type : 'uniDate' } 
					,{name: 'OFFICE_CODE'    		,text:'영업소'		,type : 'string'	,comboType:'AU', 	comboCode:'GO01'} 
					,{name: 'TEAM_CODE'    			,text:'운행조'		,type : 'string'	,comboType:'AU', comboCode:'GO02'} 
					,{name: 'ROUTE_GROUP'    		,text:'노선그룹'	,type : 'string'	,comboType:'AU', comboCode:'GO16'} 
					,{name: 'ROUTE_CODE'    		,text:'노선'		,type : 'string' ,store: Ext.data.StoreManager.lookup('routeStore')} 				
					,{name: 'CONFIRM_YN'    		,text:'배차확정구분'		,type : 'string'}
					,{name: 'CONFIRM_YN_TEXT'    	,text:'배차확정'		,type : 'string' }
					,{name: 'CONFIRM_END'    		,text:'마감'		,type : 'string'}
					,{name: 'CONFIRM_END_TEXT'    	,text:'마감구분'		,type : 'string' }
					
					,{name: 'CHK'    				,text:'체크'		,type : 'string' }
			]
	});
	var directProxyConfirm = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read : gop100ukrvService.selectConfirmList,
            update : gop100ukrvService.updateConfirm,
			syncAll: 'gop100ukrvService.saveConfirm'
		}
	});
    var confirmStore =  Unilite.createStore('gop100ukrvConfirmStore',{
        model: 'gop100ukrvConfirmModel',
         autoLoad: false,
            uniOpt : {
            	isMaster: false,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            
            proxy: directProxyConfirm,
            saveStore : function(config)	{				
				var grid = confirmGrid;// Ext.getCmp('${PKGNAME}-confirmGrid');
				var records = grid.getSelectedRecords();
				config = {
					params:[confirmSearch.getValues()],
					success: function(batch, option) {
						UniAppManager.app.onQueryButtonDown();
						confirmStore.loadStoreRecords();
						confirmWindow.unmask();
					},
					callback:function()	{
						confirmWindow.unmask();
					},
					failure: function (optional){
            			confirmWindow.unmask();
            		}
				}
				Ext.each(records, function(record, index){
						record.set('CHK', 'TRUE');
				});
				confirmWindow.mask();
				this.syncAllDirect(config);					
			} ,
			loadStoreRecords: function()	{
				var searchForm = Ext.getCmp('${PKGNAME}-conFirmSearchForm');
				var param= searchForm.getValues();
				if(searchForm.isValid())	{
					this.load({params: param});
				}
			}
            
		});
    var confirmGrid =  Unilite.createGrid('${PKGNAME}-confirmGrid', {
        flex: 1,
        margins: 0,
        selModel :   Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false  }), 
    	store: confirmStore,
    	uniOpt: {
    		onLoadSelectFirst: false,
			expandLastColumn: false,
			useRowNumberer: false
        },
        columns:  [ 
        	{dataIndex:'CONFIRM_YN_TEXT',width:80},
        	{dataIndex:'DIV_CODE' 		,width:100},
        	{dataIndex:'OPERATION_DATE' ,width:80}, 
        	{dataIndex:'OFFICE_CODE' 	,width:80},
        	{dataIndex:'TEAM_CODE' 		,width:60},
        	{dataIndex:'ROUTE_CODE' 	,width:60},        	
        	{dataIndex:'CONFIRM_END_TEXT',flex:1}
        ],
        listeners:{
        	beforeselect:function( model, record, index, eOpts )	{

        		if(record.get('CONFIRM_END')=='Y')	{
        			alert('마감된 배차는 취소할 수 었습니다.');
        			return false;
        		}
        		return true;
        	}
        }
    });
    function openConfirmWindow() {
		var searchForm = Ext.getCmp('${PKGNAME}-searchForm');
		var confirmSearchForm = Ext.getCmp('${PKGNAME}-conFirmSearchForm');
		confirmSearchForm.setValue('OFFICE_CODE', searchForm.getValue('OFFICE_CODE'));
		confirmSearchForm.setValue('ROUTE_CODE', searchForm.getValue('ROUTE_CODE'));
		confirmSearchForm.setValue('ROUTE_GROUP', searchForm.getValue('ROUTE_GROUP'));
		confirmSearchForm.setValue('TEAM_CODE', searchForm.getValue('TEAM_CODE'));
		confirmSearchForm.setValue('OPERATION_DATE_FR', searchForm.getValue('OPERATION_DATE_FR'));
		confirmSearchForm.setValue('OPERATION_DATE_TO', searchForm.getValue('OPERATION_DATE_TO'));
		
		if(!confirmWindow) {
			confirmWindow = Ext.create('widget.uniDetailWindow', {
                title: '배차확정',
                width: 700,			                
                height: 500,
                layout: {type:'vbox', align:'stretch'},	                
                items: [confirmSearch, confirmGrid],
                tbar:  [{
							itemId : 'searchBtn',
							text: '조회',
							handler: function() {
								confirmStore.loadStoreRecords();
							},
							disabled: false
						},{
							itemId : 'applyBtn',
							text: '배차확정/취소',
							handler: function() {
								confirmStore.saveStore()
								//confirmWindow.hide();
							},
							disabled: false
						},
				        '->',{
							itemId : 'closeBtn',
							text: '닫기',
							handler: function() {
								confirmWindow.hide();
							},
							disabled: false
						}
				],
				listeners : {beforehide: function(me, eOpt)	{
											confirmGrid.reset();                							
                						},
                			 beforeclose: function( panel, eOpts )	{
											confirmGrid.reset();
                			 			},
                			 show: function( panel, eOpts )	{
                			 	confirmStore.loadStoreRecords();
                			 	confirmWindow.center();
                			 }
                }		
			})
		}
		confirmWindow.show();
    }

    Unilite.defineModel('gop100ukrvXlsModel', {
	    fields: [
					 {name: 'DIV_CODE'   			,text:'사업장'		,type : 'string', comboType:'BOR120'} 
					,{name: 'OPERATION_DATE'    	,text:'운행일'		,type : 'uniDate'} 
					,{name: 'OFFICE_CODE'    		,text:'영업소'	,type : 'string'} 
					,{name: 'OFFICE_NAME'    		,text:'영업소'	,type : 'string'} 
					,{name: 'TEAM_CODE'    			,text:'운행조'	,type : 'string', comboType:'AU',  comboCode:'GO02'} 
					,{name: 'TEAM_NAME'    			,text:'운행조'	,type : 'string'} 
					,{name: 'ROUTE_CODE'    		,text:'노선'	,type : 'string', store: Ext.data.StoreManager.lookup('routeStore')} 
					,{name: 'ROUTE_NUM'    			,text:'노선'	,type : 'string'}
					,{name: 'OP01'  				,text:'1번'			,type : 'string'} 
					,{name: 'OP02'  				,text:'2번'			,type : 'string'} 
					,{name: 'OP03'  				,text:'3번'			,type : 'string'} 
					,{name: 'OP04'  				,text:'4번'			,type : 'string'} 
					,{name: 'OP05'  				,text:'5번'			,type : 'string'} 
					,{name: 'OP06'  				,text:'6번'			,type : 'string'} 
					,{name: 'OP07'  				,text:'7번'			,type : 'string'} 
					,{name: 'OP08'  				,text:'8번'			,type : 'string'} 
					,{name: 'OP09'  				,text:'9번'			,type : 'string'} 
					,{name: 'OP10'  				,text:'10번'			,type : 'string'}
					
					,{name: 'OP11'  				,text:'11번'			,type : 'string'} 
					,{name: 'OP12'  				,text:'12번'			,type : 'string'} 
					,{name: 'OP13'  				,text:'13번'			,type : 'string'} 
					,{name: 'OP14'  				,text:'14번'			,type : 'string'} 
					,{name: 'OP15'  				,text:'15번'			,type : 'string'} 
					,{name: 'OP16'  				,text:'16번'			,type : 'string'} 
					,{name: 'OP17'  				,text:'17번'			,type : 'string'} 
					,{name: 'OP18'  				,text:'18번'			,type : 'string'} 
					,{name: 'OP19'  				,text:'19번'			,type : 'string'} 
					,{name: 'OP20'  				,text:'20번'			,type : 'string'} 
				
					,{name: 'OP21'  				,text:'21번'			,type : 'string'} 
					,{name: 'OP22'  				,text:'22번'			,type : 'string'} 
					,{name: 'OP23'  				,text:'23번'			,type : 'string'} 
					,{name: 'OP24'  				,text:'24번'			,type : 'string'} 
					,{name: 'OP25'  				,text:'25번'			,type : 'string'} 
					,{name: 'OP26'  				,text:'26번'			,type : 'string'} 
					,{name: 'OP27'  				,text:'27번'			,type : 'string'} 
					,{name: 'OP28'  				,text:'28번'			,type : 'string'} 
					,{name: 'OP29'  				,text:'29번'			,type : 'string'} 
					,{name: 'OP30'  				,text:'30번'			,type : 'string'} 
					
					,{name: 'OP31'  				,text:'31번'			,type : 'string'} 
					,{name: 'OP32'  				,text:'32번'			,type : 'string'} 
					,{name: 'OP33'  				,text:'33번'			,type : 'string'} 
					,{name: 'OP34'  				,text:'34번'			,type : 'string'} 
					,{name: 'OP35'  				,text:'35번'			,type : 'string'} 
					,{name: 'OP36'  				,text:'36번'			,type : 'string'} 
					,{name: 'OP37'  				,text:'37번'			,type : 'string'} 
					,{name: 'OP38'  				,text:'38번'			,type : 'string'} 
					,{name: 'OP39'  				,text:'39번'			,type : 'string'} 
					,{name: 'OP40'  				,text:'30번'			,type : 'string'}
					
					,{name: 'OP41'  				,text:'41번'			,type : 'string'} 
					,{name: 'OP42'  				,text:'42번'			,type : 'string'} 
					,{name: 'OP43'  				,text:'43번'			,type : 'string'} 
					,{name: 'OP44'  				,text:'44번'			,type : 'string'} 
					,{name: 'OP45'  				,text:'45번'			,type : 'string'} 
					,{name: 'OP46'  				,text:'46번'			,type : 'string'} 
					,{name: 'OP47'  				,text:'47번'			,type : 'string'} 
					,{name: 'OP48'  				,text:'48번'			,type : 'string'} 
					,{name: 'OP49'  				,text:'49번'			,type : 'string'} 
					,{name: 'OP50'  				,text:'50번'			,type : 'string'} 
					,{name: 'CONFIRM_YN_TEXT'    	,text:'확정'		,type : 'string'} 
					,{name: 'OPERATION_DW'    		,text:'운행요일'		,type : 'string'} 
					,{name: 'REMARK'  				,text:'비고'			,type : 'string'} 
					
			]
	});
	
    var xlsStore =  Unilite.createStore('gop100ukrvXlsStore',{
        model: 'gop100ukrvXlsModel',
        autoLoad: false,
        uniOpt : {
        	isMaster: true,			// 상위 버튼 연결 
        	editable: false,			// 수정 모드 사용 
        	deletable:false,			// 삭제 가능 여부 
            useNavi : false			// prev | next 버튼 사용
        },
        proxy: {
            type: 'direct',
            api: {
            	   read : gop100ukrvService.selectListForXls
            }
        },
		loadStoreRecords: function()	{
			var searchForm = Ext.getCmp('${PKGNAME}-searchForm');
			var param= searchForm.getValues();
			if(searchForm.isValid())	{
				this.load({params: param});
			}
		}
	});
		
	var xlsGrid =  Unilite.createGrid('${PKGNAME}-xlsGrid', {
		flex:1,
		hidden:true,
		weight:-100,
    	store: xlsStore,
    	uniOpt: {
    		onLoadSelectFirst: false,
			expandLastColumn: false,
			useRowNumberer: false,			
			excel: {
				useExcel: true,			//엑셀 다운로드 사용 여부
				exportGroup : false		//group 상태로 export 여부
			}
        },
        columns:  [ 
        	{dataIndex:'OFFICE_NAME' 	,width:100},
        	{dataIndex:'OPERATION_DATE' ,width:100}, 
        	{dataIndex:'OPERATION_DW' 		,width:100},
        	{dataIndex:'ROUTE_NUM' 	,width:100},
        	{dataIndex:'TEAM_NAME' 		,width:100},
        	{dataIndex:'CONFIRM_YN_TEXT' 		,width:100},
        	{dataIndex:'OP01' 		,width:100},
        	{dataIndex:'OP02' 		,width:100},
        	{dataIndex:'OP03' 		,width:100},
        	{dataIndex:'OP04' 		,width:100},
        	{dataIndex:'OP05' 		,width:100},
        	{dataIndex:'OP06' 		,width:100},
        	{dataIndex:'OP07' 		,width:100},
        	{dataIndex:'OP08' 		,width:100},
        	{dataIndex:'OP09' 		,width:100},
        	{dataIndex:'OP10' 		,width:100},
        	
        	{dataIndex:'OP11' 		,width:100},
        	{dataIndex:'OP12' 		,width:100},
        	{dataIndex:'OP13' 		,width:100},
        	{dataIndex:'OP14' 		,width:100},
        	{dataIndex:'OP15' 		,width:100},
        	{dataIndex:'OP16' 		,width:100},
        	{dataIndex:'OP17' 		,width:100},
        	{dataIndex:'OP18' 		,width:100},
        	{dataIndex:'OP19' 		,width:100},
        	{dataIndex:'OP20' 		,width:100},
        	
        	{dataIndex:'OP21' 		,width:100},
        	{dataIndex:'OP22' 		,width:100},
        	{dataIndex:'OP23' 		,width:100},
        	{dataIndex:'OP24' 		,width:100},
        	{dataIndex:'OP25' 		,width:100},
        	{dataIndex:'OP26' 		,width:100},
        	{dataIndex:'OP27' 		,width:100},
        	{dataIndex:'OP28' 		,width:100},
        	{dataIndex:'OP29' 		,width:100},
        	{dataIndex:'OP30' 		,width:100},
        	
        	{dataIndex:'OP31' 		,width:100},
        	{dataIndex:'OP32' 		,width:100},
        	{dataIndex:'OP33' 		,width:100},
        	{dataIndex:'OP34' 		,width:100},
        	{dataIndex:'OP35' 		,width:100},
        	{dataIndex:'OP36' 		,width:100},
        	{dataIndex:'OP37' 		,width:100},
        	{dataIndex:'OP38' 		,width:100},
        	{dataIndex:'OP39' 		,width:100},
        	{dataIndex:'OP40' 		,width:100},
        	
        	{dataIndex:'OP41' 		,width:100},
        	{dataIndex:'OP42' 		,width:100},
        	{dataIndex:'OP43' 		,width:100},
        	{dataIndex:'OP44' 		,width:100},
        	{dataIndex:'OP45' 		,width:100},
        	{dataIndex:'OP46' 		,width:100},
        	{dataIndex:'OP47' 		,width:100},
        	{dataIndex:'OP48' 		,width:100},
        	{dataIndex:'OP49' 		,width:100},
        	{dataIndex:'OP50' 		,width:100}
        ],
        listeners:{
        	beforeshow:function()	{
        		masterView.hide();
        	}
        }
    });
    
    var masterGrid =  Unilite.createGrid('${PKGNAME}-grid', {
		flex:1,
		weight:-100,
    	store: xlsStore,
    	uniOpt: {
    		onLoadSelectFirst: false,
			expandLastColumn: false,
			useRowNumberer: false,			
			excel: {
				useExcel: true,			//엑셀 다운로드 사용 여부
				exportGroup : false		//group 상태로 export 여부
			}
        },
        columns:  [ 
        	{dataIndex:'OFFICE_NAME' 	,width:100},
        	{dataIndex:'OPERATION_DATE' ,width:100}, 
        	{dataIndex:'OPERATION_DW' 		,width:100},
        	{dataIndex:'ROUTE_NUM' 	,width:100},
        	{dataIndex:'TEAM_NAME' 		,width:100},
        	{dataIndex:'CONFIRM_YN_TEXT' 		,width:100},
        	{dataIndex:'OP01' 		,width:100
        	  ,renderer: function(value, metaData){
	  			 	var r=''
	  			 	var record = metaData.record;
	  			 	if(record.get("OTHER_VEHICLE_YN") == 'Y') {
					  r = '<div class="busItemMedium-gray"><img src="'+CPATH+'/resources/css/background/mbussgray.png"></div>';
	  			 	}else {
	  			 	  r = '<div class="busItemMedium-green"><img src="'+CPATH+'/resources/css/background/mbussgray.png"></div>';
	  			 	}
	  			 	return r;
	 			}	
        	},
        	{dataIndex:'OP02' 		,width:100},
        	{dataIndex:'OP03' 		,width:100},
        	{dataIndex:'OP04' 		,width:100},
        	{dataIndex:'OP05' 		,width:100},
        	{dataIndex:'OP06' 		,width:100},
        	{dataIndex:'OP07' 		,width:100},
        	{dataIndex:'OP08' 		,width:100},
        	{dataIndex:'OP09' 		,width:100},
        	{dataIndex:'OP10' 		,width:100},
        	{dataIndex:'OP11' 		,width:100},
        	{dataIndex:'OP12' 		,width:100},
        	{dataIndex:'OP13' 		,width:100},
        	{dataIndex:'OP14' 		,width:100},
        	{dataIndex:'OP15' 		,width:100}
        ],
        listeners:{
        	beforeshow:function()	{
        		masterView.hide();
        	}
        },
        viewConfig: {
        	
            plugins: {
                ddGroup: 'dataGroup',
                ptype: 'unicelldragdrop',
                enableDrop: true,
                enableDrag: true,
                copyType:'record',
                allowDrop:false,
                setAllowDrop: function(allow)	{
                	this.allowDrop = allow;
                },
                onRecordDrop: function(target, drag)	{
                	var me = this;
		        	if(me.allowDrop)	{
			        	var drop =  target.record;
			        	var dragRec ;
			        	var store = me.getStore();	           
				        if("uniDragView" == drag.view.getXType())	{
			        		dragRec = drag.record;
			        	}else if("uniDragandDropView" == drag.view.getXType())	{
			        		dragRec = drag.record;
			        	}else {
			        		dragRec = drag.records[0];
			        	}
			        	/*if(dragRec.get("OTHER_VEHICLE_YN") == "Y")	{
			        		alert("타차는 변경이 불가능합니다.");
			        		return false;
			        	}*/
				        var dropVehicleCode = drop.get("VEHICLE_CODE");
				        var dropVehicleName = drop.get("VEHICLE_NAME");		        
					    var dropOtherVehicleYn = drop.get("OTHER_VEHICLE_YN");		
					    var dropNotServiceYn = drop.get("NOTINSERVICE_YN"); 
				        if((dragRec.get("OPTION") =="BUSINFO" && drop.get("CONFIRM_YN") != 'Y')
				        	|| (drop.get("OPERATION_DATE") == dragRec.get("OPERATION_DATE") 
				        		&& drop.get("ROUTE_CODE") == dragRec.get("ROUTE_CODE") 
				        		&& drop.get("OFFICE_CODE") == dragRec.get("OFFICE_CODE")
				        		&& drop.get("CONFIRM_YN") != 'Y'		        	
				        	   )
				        	 || (dragRec.get("OPTION") =="OTHER_VEHICLE_INFO" && drop.get("CONFIRM_YN") != 'Y' )
				        	)	{
					        drop.set("VEHICLE_CODE", dragRec.get("VEHICLE_CODE"));
					        drop.set("VEHICLE_NAME", dragRec.get("VEHICLE_NAME"));	
					        drop.set("OTHER_VEHICLE_YN",   dragRec.get("OTHER_VEHICLE_YN") );
					        drop.set("NOTINSERVICE_YN",   dragRec.get("NOTINSERVICE_YN") );
					        
					        masterView.refreshNode(store.indexOf( drop ));
				
					        if(!(dragRec.get("OPTION") == "BUSINFO" || dragRec.get("OPTION") == "OTHER_VEHICLE_INFO") )	{ 
					        	dragRec.set("VEHICLE_CODE", dropVehicleCode);
					        	dragRec.set("VEHICLE_NAME", dropVehicleName);
					        	dragRec.set("OTHER_VEHICLE_YN", dropOtherVehicleYn);
					        	dragRec.set("NOTINSERVICE_YN", dropNotServiceYn);
					        	masterView.refreshNode(store.indexOf( dragRec ));
				        	}
				        }
		        	}
		            return true;
                },
                onDropEnter: function(target, dragData)	{
                	var me = this;
		        	var drop =  target.record;
		        	var dragRec = dragData.record;
		        	me.setAllowDrop(false);
		        	
		        	if( dragRec.get("OPTION") =="BUSINFO" && drop.get("CONFIRM_YN") != 'Y')	{
		        		me.setAllowDrop(true);
		        	} else  if(drop.get("OPERATION_DATE") == dragRec.get("OPERATION_DATE") 
		        		&& drop.get("ROUTE_CODE") == dragRec.get("ROUTE_CODE") 
		        		&& drop.get("OFFICE_CODE") == dragRec.get("OFFICE_CODE")
		        		&& drop.get("CONFIRM_YN") != 'Y'
		        	)	{
		        		me.setAllowDrop(true);
		        	} else if( dragRec.get("OPTION") =="OTHER_VEHICLE_INFO"  && drop.get("CONFIRM_YN") != 'Y')	{
		        		me.setAllowDrop(true);
		        	}  
					
		        	if(me.allowDrop)	{	
		        		var chkDuplicateVehicle = false;
		        		if(dragRec.get("OPTION") =="BUSINFO")	{
				        	Ext.each(masterStore.data.items, function(item, idx) { 
				        		if(	   drop.get("OPERATION_DATE") == item.get("OPERATION_DATE") 
					        		&& drop.get("ROUTE_CODE") == item.get("ROUTE_CODE") 
					        		&& drop.get("OFFICE_CODE") == item.get("OFFICE_CODE")
					        		&& dragRec.get("VEHICLE_CODE") == item.get("VEHICLE_CODE") )	{
				        			chkDuplicateVehicle = true;
				        		}
				        	});
		        		}
			        	if(!chkDuplicateVehicle )	{
			        		me.setAllowDrop(true);
			        	}else {
			        		me.setAllowDrop(false);
			        	}
		        	}
		        	
		        	if(me.allowDrop)	{
		        		return true;
		        	}
		        	return false;
                }
            }
        }
    });
      Unilite.Main({
		borderItems:[
	 		  panelSearch,
	 		 {
	 		 	region:'center',
	 		 	xtype:'panel',
	 		 	layout:'fit',
				layout:{type:'vbox', align:'stretch'},
	 		 	tbar:  [
	 		 			'->',
		 		 		{xtype:'component',
	           			 html:'<div style="line-height:20px;">' +
	           			 	/*	'<img src="'+CPATH+'/resources/images/busoperate/greenO.png"> 자차 ' +
	           			 		'<img src="'+CPATH+'/resources/images/busoperate/redO.png"> 자차운휴 ' +
	           			 		'<img src="'+CPATH+'/resources/images/busoperate/grayO.png"> 타차</div>'*/
	           			 		
	           			 	'<font style="color:#71d071">●</font> 자차&nbsp;&nbsp;'+
           			 	  	'<font style="color:#d17272">●</font> 자차운휴&nbsp;&nbsp;' +
           			 	  	'<font style="color:#989898">●</font> 타차&nbsp;&nbsp;</div>'
           			},
		        	{
						text: '배차확정/취소',
						handler: function() {
							openConfirmWindow();
						}
					}
				],
				tools: [
					{
						type: 'hum-grid',					            
			            handler: function () {
			            	if(!masterStore.isDirty() )	{
			                	xlsGrid.show();
			            	}else {
			            		if(confirm("저장되지 않은 데이타가 있습니다. 저장하시겠습니까?"))	{
			            			UniAppManager.app.onSaveDataButtonDown();
			            		}else {
			            			UniAppManager.app.rejectSave();
			            			xlsGrid.show();
			            		}
			            	}
			            }
	        		},{
						type: 'hum-photo',					            
			            handler: function () {
			                masterView.show();
			            }
	        		}
							
				],
	 		 	items: [/*masterGrid*/ masterView, xlsGrid]
	 		 },
	 		 panelSearch2
		],
		id  : 'gop100ukrApp',
		autoButtonControl : false,
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['reset', 'newData','print'],false);
			UniAppManager.setToolbarButtons(['excel'],true);
			busStore.loadStoreRecords();
			//masterStore.loadStoreRecords({params : sparams});
		},
		
		onQueryButtonDown : function()	{
			masterStore.loadStoreRecords();
			xlsStore.loadStoreRecords();
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
		},
		rejectSave: function() {			
			masterStore.rejectChanges();	
			masterStore.onStoreActionEnable();
		}
	});
}; // main
</script>