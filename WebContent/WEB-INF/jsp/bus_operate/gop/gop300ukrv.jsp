<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
//일일승무내역 등록
request.setAttribute("PKGNAME","Unilite_app_gop300ukrv");
%>
<t:appConfig pgmId="gop300ukrv"  >
	<t:ExtComboStore comboType="AU" comboCode="GO01"/>				<!-- 영업소   	-->  
	<t:ExtComboStore items="${ROUTE_COMBO}" storeId="routeStore" /> <!-- 노선 -->
	<t:ExtComboStore comboType="AU" comboCode="GO16"/>				<!-- 노선그룹   	-->  
	<t:ExtComboStore comboType="AU" comboCode="GO17"/>				<!-- 변경사유   	-->  
	<t:ExtComboStore comboType="AU" comboCode="A020"/>				<!-- 운휴여부   	-->  
</t:appConfig>
<script type="text/javascript">
var editWindow;

var BsaCodeInfo = {
	driverTypes :
		${driverTypes}
}
var confirmWindow = null;
function appMain() {
	Unilite.defineModel('gop300ukrvModel', {
	    fields: [
					 {name: 'DIV_CODE'   			,text:'사업장'				,type : 'string'} 
					,{name: 'OPERATION_DATE'    	,text:'운행일'				,type : 'string'} 
					,{name: 'OFFICE_CODE'    		,text:'운행반'				,type : 'string'} 
					,{name: 'ROUTE_CODE'    		,text:'노선코드'			,type : 'string'} 
					,{name: 'ROUTE_NUM'    			,text:'노선번호'			,type : 'string'} 
					,{name: 'ROUTE_NAME'   			,text:'노선명'				,type : 'string'} 
					,{name: 'OPERATION_COUNT'  		,text:'운행순번'			,type : 'string'} 
					,{name: 'RUN_COUNT'    			,text:'운행회수'			,type : 'string'} 
					,{name: 'VEHICLE_CODE'    		,text:'차량코드'			,type : 'string'} 
					,{name: 'VEHICLE_NAME'    		,text:'차량번호'			,type : 'string'} 
					,{name: 'NAME'    				,text:'이름'				,type : 'string'} 					
					,{name: 'DRIVER_CODE'  			,text:'기사코드'			,type : 'string'}
					,{name: 'PERSON_NUMB'    		,text:'사진'				,type : 'string'}
					,{name: 'WORK_TEAM_CODE'    	,text:'근무조'				,type : 'string'}
					
					,{name: 'CHANGE_FLAG'    		,text:'변경여부'			,type : 'string'}
					,{name: 'OTHER_VEHICLE_YN'    	,text:'타차여부'			,type : 'string'}
					,{name: 'NOTINSERVICE_YN'    	,text:'운휴여부'			,type : 'string'}
					,{name: 'RUN_DEPARTURE_TIME'   	,text:'실제출발시간'		,type : 'string'} 
					,{name: 'DUTY_FR_TIME'    		,text:'출근시간'			,type : 'string'} 
					,{name: 'DUTY_TO_TIME'    		,text:'퇴근시간'			,type : 'string'}  
					,{name: 'SYS_DUTY_FR_TIME'    	,text:'출입통제출근시간'	,type : 'string'} 
					,{name: 'SYS_DUTY_TO_TIME'    	,text:'출입통제퇴근시간'	,type : 'string'} 
					,{name: 'PLAN_VEHICLE_CODE'    	,text:'차량코드(승무지시)'	,type : 'string'} 
					,{name: 'PLAN_VEHICLE_NAME'    	,text:'차량코드(승무지시)'	,type : 'string'}
					,{name: 'PLAN_DRIVER_CODE'    	,text:'기사코드(승무지시)'	,type : 'string'} 
					,{name: 'PLAN_DRIVER_NAME'    	,text:'기사코드(승무지시)'	,type : 'string'} 
					,{name: 'DEPARTURE_DATE'    	,text:'출발일자'			,type : 'uniDate'} 
					,{name: 'DEPARTURE_TIME'    	,text:'출발시간'			,type : 'string'} 
					,{name: 'RUN_DEPARTURE_DATE'    ,text:'실제출발일자'		,type : 'uniDate'} 
					,{name: 'DUTY_FR_DATE'    		,text:'출근일자(근무)'		,type : 'uniDate'} 
					,{name: 'DUTY_TO_DATE'    		,text:'퇴근일자(근무)'		,type : 'uniDate'} 
					,{name: 'SYS_DUTY_FR_DATE'    	,text:'출근일자(출입통제)'	,type : 'uniDate'} 
					,{name: 'SYS_DUTY_TO_DATE'    	,text:'퇴근일자(출입통제)'	,type : 'uniDate'} 
					,{name: 'CHANGE_REASON'    		,text:'변경사유'			,type : 'string'} 
					,{name: 'EMPLOY_TYPE'    		,text:'기사구분'			,type : 'string'} 
					,{name: 'CONFIRM_YN'    		,text:'마감구분'			,type : 'string'}
					,{name: 'REMARK'  				,text:'비고'				,type : 'string'} 
					,{name: 'SUBTOT_RUN_CNT'    	,text:'VIEW PROPERTY'		,type : 'uniQty'} 
					,{name: 'MAX_RUN_COUNT'    		,text:'VIEW PROPERTY'		,type : 'string'} 
					,{name: 'MIN_RUN_COUNT'    		,text:'VIEW PROPERTY'		,type : 'string'} 
					,{name: 'OP_MAX_RUN_COUNT'    	,text:'VIEW PROPERTY'		,type : 'string'}
					,{name: 'OP_MIN_RUN_COUNT'    	,text:'VIEW PROPERTY'		,type : 'string'}	
					,{name: 'COL_NUM'    			,text:'VIEW PROPERTY'		,type : 'string'}	
					,{name: 'ROW_NUM'    			,text:'VIEW PROPERTY'		,type : 'string'}	
					
			]
	});
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			 read 	: gop300ukrvService.selectList,
             update : gop300ukrvService.update,
			syncAll	: gop300ukrvService.saveAll
		}
	});
    var masterStore =  Unilite.createStore('gop300ukrvStore',{
        model: 'gop300ukrvModel',
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
				if(inValidRecs.length == 0 )	{
					this.syncAllDirect();					
				}else {
					alert(Msg.sMB083);
				}
			},
			loadStoreRecords: function(record)	{
				var searchForm  = Ext.getCmp('${PKGNAME}searchForm');
				
				var param= {
					'OFFICE_CODE' : searchForm.getValue('OFFICE_CODE'),
					'OPERATION_DATE' : UniDate.getDateStr(searchForm.getValue('OPERATION_DATE')),
					'ROUTE_CODE': record.get('ROUTE_CODE')
				}
				if(searchForm.isValid())	{
					this.load({params: param});
				}
			},
			listeners: {
				load:function( store, records, successful, eOpts )	{
					if(successful)	{
						masterView.up('panel').setTitle("승무내역("+UniDate.safeFormat(panelSearch.getValue('OPERATION_DATE'))+")");
					}
				},
				write: function(store, operation, eOpts ) {
					if(operation.action == 'update')	{
						summaryStore.loadStoreRecords(routeGrid.getSelectedRecord());
					}
				},
				update: function( store, record, operation, modifiedFieldNames, eOpts )	{
					if(record.get("OTHER_VEHICLE_YN") == 'Y')	{
						record.set('CHANGE_FLAG','OTHER');
					} else if(record.get("NOTINSERVICE_YN") == 'Y')	{
						record.set('CHANGE_FLAG','NOTINSERVICE');
					} else if(record.get("OTHER_VEHICLE_YN") != 'Y' && record.get("NOTINSERVICE_YN") != 'Y')	{
						record.set('CHANGE_FLAG','');
					}
					masterView.refreshNode(store.indexOf( record ));
				}
			}
            
		});
	
		Unilite.defineModel('${PKGNAME}routeModel', {
	    fields: [
					 {name: 'DIV_CODE'   	,text:'사업장'		,type : 'string'  ,comboType: 'BOR120' } 
					,{name: 'ROUTE_CODE'    ,text:'노선코드'	,type : 'string' } 
					,{name: 'ROUTE_NUM'    	,text:'번호'	,type : 'string' } 					
					,{name: 'ROUTE_NAME'    ,text:'노선명'		,type : 'string' } 
					,{name: 'CONFIRM_YN'    		,text:'마감구분'		,type : 'string'}
					,{name: 'CONFIRM_YN_TEXT'    	,text:'마감구분'		,type : 'string' }
					,{name: 'COMP_CODE'  	,text:'법인코드'	,type : 'string' } 
			]
		});


    var routeStore =  Unilite.createStore('${PKGNAME}store',{
        model: '${PKGNAME}routeModel',
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
                	   read : 'gop300ukrvService.selectRouteList'                	   
                }
            },
			loadStoreRecords: function()	{
				masterView.up('panel').setTitle("");
				var searchForm = Ext.getCmp('${PKGNAME}searchForm');
				var param= searchForm.getValues();
				if(searchForm.isValid())	{
					UniAppManager.app.setToolbarButtons('save',false);
					masterStore.loadData([]);
					this.load({params: param});
				}
			},
			listeners:{
				load:function( store, records, successful, eOpts )	{
					if(successful)	{
						routeGrid.getSelectionModel().select(0);
					}
				}
			}
            
		});		
		
	var routeGrid = Unilite.createGrid('${PKGNAME}routeGrid', {
		uniOpt:{
			useRowNumberer: false,
        	expandLastColumn: false,
            useMultipleSorting: false,
            state: {
			   useState: false,   
			   useStateList: false  
			},
            onLoadSelectFirst: true
        },	
        selModel:'rowmodel',
        tbar:[
        	'->',
        	{
				itemId : 'applyBtn',
				text: '마감/마감취소',
				handler: function() {
					openConfirmWindow();
				},
				disabled: false
			}
		],
        border:false,
    	store: routeStore,
		columns: [
			{dataIndex:'ROUTE_CODE'		,width: 65 },
			{dataIndex:'ROUTE_NUM'		,width: 50 },
			{dataIndex:'ROUTE_NAME'		,width: 85},
			{dataIndex:'CONFIRM_YN_TEXT'	,flex: 1}
		],
		listeners: {
			
			beforedeselect: function( grid, record, index, eOpts )	{
				if(masterStore.isDirty() )	{
					if(confirm(Msg.sMB061))	{
						UniAppManager.app.onSaveDataButtonDown();
						return false;
					}  else {
						UniAppManager.app.rejectSave();
					}
				}
			},
      		selectionchange: function( grid, selected, eOpts ) {  
      				masterView.up('panel').setTitle("");
					masterStore.loadStoreRecords(selected[0]);
					summaryStore.loadStoreRecords(selected[0]);
			}
         }
   });
  
   Unilite.defineModel('${PKGNAME}SummaryModel', {
	    fields: [
					 {name: 'PLAN_CNT'   			,text:'운행계획'	,type : 'uniQty'  }		
					,{name: 'OPERATION_CNT'    		,text:'운행'		,type : 'uniQty'  }
					,{name: 'NOTINSERVICE_CNT'    	,text:'운휴'		,type : 'uniQty'  }
					,{name: 'NONE_DRIVER'   		,text:'기사미배정'	,type : 'uniQty'  }		
					,{name: 'ASSIGNED_DRIVER'    	,text:'기사배정'	,type : 'uniQty'  }
					,{name: 'OPERATION_RATE'    	,text:'운행율'		,type : 'uniPercent'  ,convert:converRate}
					,{name: 'NOTINSERVICE_RATE'    	,text:'운휴율'		,type : 'uniPercent'  ,convert:converRate}
					,{name: 'ASSIGNED_DRIVER_RATE'  ,text:'기사배정율'	,type : 'uniPercent'  ,convert:converRate}
					,{name: 'NONE_DRIVER_RATE'    	,text:'기사미배정율',type : 'uniPercent'  ,convert:converRate}
			]
	});
	function converRate(value, record)	{
		return Math.floor(value);
	}
	var summaryStore =  Unilite.createStore('${PKGNAME}summaryStore',{
        model: '${PKGNAME}SummaryModel',
        autoLoad: true,
            uniOpt : {
            	isMaster: false,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            proxy: {
                type: 'direct',
                api: {
                	   read : 'gop300ukrvService.summary'
                }
            },
			loadStoreRecords: function(record)	{
				var searchForm  = Ext.getCmp('${PKGNAME}searchForm');
				
				var param= {
					'OFFICE_CODE' : searchForm.getValue('OFFICE_CODE'),
					'OPERATION_DATE' : UniDate.getDateStr(searchForm.getValue('OPERATION_DATE')),
					'ROUTE_CODE': record.get('ROUTE_CODE')
				}
				
				if(searchForm.isValid())	{
					this.load({params: param});
				}
			}
		});	
	var masterView = Ext.create('Ext.view.View', {
		tpl: [
			'<div class="summary-source" style="width:300px;">' ,
			'<table cellpadding="5" cellspacing="0" border="0" width="100%"  align="center" style="border:1px solid #cccccc;">' ,
			'<tpl for=".">' ,
			'<tr>' ,
			'	<td width="90"  class="bus_gray-label" style="text-align:right;">운행계획</td>' ,
			'	<td class="bus_white-label" style="text-align:right;padding-right:5px;border-top: 0px solid #cccccc !important">{PLAN_CNT} 대</td>',
			'	<td width="70"  class="bus_white-label" style="border-top: 0px solid #cccccc;border-left: 0px solid #cccccc;border-right: 0px solid #cccccc !important"></td>' ,
			'	<td class="bus_white-label" style="border-top: 0px solid #cccccc;border-left: 0px solid #cccccc !important"></td>',
			'</tr>' ,
			'<tr>' ,
			'	<td width="90"  class="bus_gray-label" style="text-align:right;">운행</td>' ,
			'	<td class="bus_white-label" style="text-align:right;padding-right:5px !important">{OPERATION_CNT} 대</td>',
			'	<td width="70"  class="bus_gray-label" style="text-align:right;">운행율</td>' ,
			'	<td class="bus_white-label" style="text-align:right;padding-right:5px !important">{OPERATION_RATE} %</td>',
			'</tr>' ,
			'<tr>' ,
			'	<td width="90"  class="bus_gray-label" style="text-align:right;">운휴</td>' ,
			'	<td class="bus_white-label" style="text-align:right;padding-right:5px !important">{NOTINSERVICE_CNT} 대</td>',
			'	<td width="70"  class="bus_gray-label" style="text-align:right;">운휴율</td>' ,
			'	<td class="bus_white-label" style="text-align:right;padding-right:5px !important">{NOTINSERVICE_RATE} %</td>',
			'</tr>' ,
			'<tr>' ,
			'	<td width="90"  class="bus_gray-label" style="text-align:right;">기사배정</td>' ,
			'	<td class="bus_white-label" style="text-align:right;padding-right:5px !important">{ASSIGNED_DRIVER} 명</td>',
			'	<td width="70"  class="bus_gray-label" style="text-align:right;">배정율</td>' ,
			'	<td class="bus_white-label" style="text-align:right;padding-right:5px !important">{ASSIGNED_DRIVER_RATE} %</td>',
			'</tr>' ,
			'<tr>' ,
			'	<td width="90"  class="bus_gray-label" style="text-align:right;">기사미배정</td>' ,
			'	<td class="bus_white-label" style="text-align:right;padding-right:5px !important">{NONE_DRIVER} 명</td>',
			'	<td width="70"  class="bus_gray-label" style="text-align:right;">미배정율</td>' ,
			'	<td class="bus_white-label" style="text-align:right;padding-right:5px !important">{NONE_DRIVER_RATE} %</td>',
			'</tr>' ,
			'</tpl>' ,
			'</table><div>'
		],
		border:true,
		autoScroll:false,
		itemSelector: 'div.summary-source',
        store: summaryStore,
        margin:'5 5 5 0'
	});
	
		
	var panelSearch = Unilite.createSearchPanel('${PKGNAME}searchForm',{
		title: '일일승무내역정보',
        defaultType: 'uniSearchSubPanel',
        defaults: {
			autoScroll:true
	  	},
        width: 330,
		items: [{	
					title: '검색조건', 	
		   			itemId: 'search_panel1',
		   			height:110,
		           	layout: {type: 'uniTable', columns: 1},
		           	defaultType: 'uniTextfield',   			
			    	items:[{	    
						fieldLabel: '사업장',
						name: 'DIV_CODE',
						hidden:true,
						value:UserInfo.divCode
					},{	    
						fieldLabel: '노선그룹',
						name: 'ROUTE_GROUP'	,
						xtype: 'uniCombobox',
						comboType:'AU', 
						comboCode:'GO16',
						allowBlank:false,
						listeners: {
							change:function()	{
								panelSearch.setValue('ROUTE_CODE', '');
							}
						},
						value: '010'
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
						fieldLabel: '운행일',
						name: 'OPERATION_DATE',
						xtype: 'uniDatefield',
						value: UniDate.today(),
						allowBlank:false
					}]				
				},{	
					header: false,
		   			itemId: 'search_panel2',
		   			layout:{type:'vbox', align:'stretch'},
		   			flex: 1,
		           	items: [routeGrid]			
				},
				{	
					title: '요약정보', 	
		   			itemId: 'search_panel3',
		   			height:160,
		           	layout: {type: 'uniTable', columns: 1, tableAttrs:{'align':'center'} },	
		           	autoScroll:false,
			    	items:[masterView]
				}]
		
	});	//end panelSearch    
	

    var masterViewTplTemplate = new Ext.XTemplate(
	    '<table cellspacing="0" cellpadding="0" style="border: #99bce8 solid 1px;" class="noselect">' ,
	    '<tpl for=".">' ,
	    	'<tpl if="ROW_NUM == \'1\'">',
				'<tpl if="COL_NUM == MIN_RUN_COUNT">' ,
					'<tr><td width="20" class="bus_blue-label">&nbsp;</td>' ,
				'</tpl>',
				'<td class="bus_blue-label">{COL_NUM} 회</td>' ,
				'<tpl if="COL_NUM == MAX_RUN_COUNT">',
			 		'</tr>' ,
			 	'</tpl>',
			 '</tpl>',
		 '</tpl>',
		 '<tpl for=".">' ,
			'<tpl if="COL_NUM == MIN_RUN_COUNT">' ,
				'<tr><td nowrap="true" class="bus_blue-label"> {ROW_NUM}번 </td>' ,
			'</tpl>',
	                '<td width="163">',
	                '<tpl if="RUN_COUNT != \'\'">',
	                	'<div class="data-source busData">',
	                	'<tpl if="CHANGE_FLAG == \'\'">',
		               		'<div class="busItemGreen">',
		                '</tpl>',
		                '<tpl if="CHANGE_FLAG == \'NOTINSERVICE\'">',
		                	'<div class="busItemRed">',
		                '</tpl>',    
		                '<tpl if="CHANGE_FLAG == \'OTHER\'">',
		                	'<div class="busItemGray">',
		                '</tpl>', 
		                
		                '<table cellspacing="0" cellpadding="0" width="100%" border="0" class="noselect"><tr height="30">',
		            		'<td colspan="2" align="center">{ROUTE_NUM} -{ROUTE_NAME}</td>',
		            	'</tr><tr>',
		            		'<td width="70" align="left" style="line-height:12px;padding-left:25px;"><font style="font-size:9px;color:#5b9bd5">■</font> {DEPARTURE_TIME}</td>',			            		
		            		'<td height="54" align="left" rowspan="4" style="padding-right:24px">',
		            	'<tpl if="this.isColorFrame(EMPLOY_TYPE)">',
		            	'	<div class="dirverPhotoBlue">',
		            	'</tpl>',
		            	'<tpl if="PERSON_NUMB == \'\'">',
		            	'		<img src="'+CPATH+'/resources/images/busoperate/naPhoto.png" title="{NAME:htmlEncode}" width="50" height="50" >',
		            	'</tpl>', 
		            	'<tpl if="PERSON_NUMB != \'\'">',
		            	'		<img src="'+CPATH+'/uploads/employeePhoto/{PERSON_NUMB}" title="{NAME:htmlEncode}" width="50" height="50" >',
		            	'</tpl>', 
		            	'<tpl if="EMPLOY_TYPE == \'8\' || EMPLOY_TYPE == \'9\'	">',
		            	'	</div>',
		            	'</tpl>',
		            	'	 </td>',
		            	'</tr>',
		            		'<tr><td width="70" align="left" style="line-height:12px;padding-left:25px;"><font style="font-size:9px;color:#ed7c31">■</font> {RUN_DEPARTURE_TIME} </td></tr>',
		            	'<tpl if="COL_NUM == OP_MIN_RUN_COUNT">',
		            		'<tr><td width="70" align="left" style="line-height:12px;padding-left:25px;"><font style="font-size:9px;color:#ffc000">■</font> {DUTY_FR_TIME}</td></tr>',
		            		'<tr><td width="70" align="left" style="line-height:12px;padding-left:25px;"><font style="font-size:9px;color:#70ad47">■</font> {SYS_DUTY_FR_TIME}</td></tr>',
		            	'</tpl>',
		            	'<tpl if="RUN_COUNT == OP_MAX_RUN_COUNT">',
		            		'<tr><td width="70" align="left" style="line-height:12px;padding-left:25px;"><font style="font-size:9px;color:#ffc000">■</font> {DUTY_TO_TIME}</td></tr>',		            	
		            		'<tr><td width="70" align="left" style="line-height:12px;padding-left:25px;"><font style="font-size:9px;color:#70ad47">■</font> {SYS_DUTY_TO_TIME}</td></tr>',
		            	'</tpl>',
		            	'<tpl if="COL_NUM != OP_MAX_RUN_COUNT">',
		            		'<tpl if="COL_NUM != OP_MIN_RUN_COUNT">',
		            			'<tr><td width="70" align="left" style="height:12px;">&nbsp;</td></tr>',
		            			'<tr><td width="70" align="left" style="height:12px;">&nbsp;</td></tr>',
		            		'</tpl>',
		            	'</tpl>',
		            	'<tr>',
		            	'<tpl if="this.showDriverCode">',
		            		'<td width="70" align="right" >&nbsp;{DRIVER_CODE}</td>',
		            	'</tpl>',
		            	'<tpl if="!this.showDriverCode">',
		            		'<td width="70" align="right" >&nbsp;</td>',
		            	'</tpl>',
		            	'	<td align="center" width="70" style="padding-right:24px;line-height:12px;">{NAME}</td></tr>',
		            	'<tr height="40">',
		            		'<td  colspan="2" align="center">{VEHICLE_NAME}</td>',
		            	'</tr>',
		            	'</table></div></div>',
		            	'</tpl>',
		            	'<tpl if="RUN_COUNT == \'\'">',
		                '<div class="data-source busData" style="height:159px;">&nbsp;</div>',
		            	'</tpl>',
	                '</td>',
	        '<tpl if="COL_NUM == MAX_RUN_COUNT">',
				'</tr>',
			'</tpl>',
        '</tpl>' ,
        '</table>',
        {
        	showDriverCode:false,
        	setShowDriver: function	(visible)	{
        			this.showDriverCode = visible;
        	},
        	isColorFrame: function(employ_type)	{
    			var r = false;
        		va = Ext.each(BsaCodeInfo.driverTypes, function(item, idx){
        			if(item.CODE == employ_type)	{
        				r = true; 
        			}
        		})
        		return r
        	}
        }
	);

	var masterTableTplTemplate = new Ext.XTemplate(
	    '<table cellspacing="0" cellpadding="0" style="border: #99bce8 solid 1px;table-layout:fixed">' ,
	    '<tpl for=".">' ,
	    	'<tpl if="ROW_NUM == \'1\'">',
				'<tpl if="COL_NUM == MIN_RUN_COUNT">' ,
					'<tr><td rowspan="2" class="x-column-header x-column-header-inner" style="width:40px;text-align: center;border-left: 0px solid #c5c5c5;overflow: hidden;">운행</td>' ,
					'	<td rowspan="2" class="x-column-header x-column-header-inner" style="width:50px;text-align: center;border-left: 0px solid #c5c5c5;overflow: hidden;">근태<br>출근</td>' ,
					'	<td rowspan="2" class="x-column-header x-column-header-inner" style="width:50px;text-align: center;border-left: 0px solid #c5c5c5;overflow: hidden;">출입<br>출근</td>',
				'</tpl>',
				'<td  class="x-column-header x-column-header-inner" style="width:300px;text-align: center;border-left: 0px solid #c5c5c5;overflow: hidden;">{COL_NUM} 회</td>' ,
				'<tpl if="COL_NUM == MAX_RUN_COUNT">',
				'		<td width="50" rowspan="2" class="x-column-header x-column-header-inner" style="width:50px;text-align: center;border-left: 0px solid #c5c5c5;overflow: hidden;">근태<br>퇴근</td>' ,
				'		<td width="50" rowspan="2" class="x-column-header x-column-header-inner" style="width:50px;text-align: center;border-left: 0px solid #c5c5c5;overflow: hidden;">출입<br>퇴근</td>',
			 		'</tr>' ,
			 	'</tpl>',
			 '</tpl>',	
		 '</tpl>',
		 	
		 '<tpl for=".">' ,
		 	 '<tpl if="ROW_NUM == \'1\'">',
			 	'<td>',
			 	'<table cellspacing="0" cellpadding="0" width="100%" border="0" style="table-layout:fixed">',			 
			 	'<tr>',
				'	<td class="x-column-header x-column-header-inner" style="width:40px;text-align: center;border-left: 0px solid #c5c5c5;overflow: hidden;">차량</td>' ,
            	'	<td class="x-column-header x-column-header-inner" style="width:65px;text-align: center;border-left: 0px solid #c5c5c5;overflow: hidden;">기사명</td>' ,
            	'	<td class="x-column-header x-column-header-inner" style="width:65px;text-align: center;border-left: 0px solid #c5c5c5;overflow: hidden;">기사코드</td>' ,
            	'	<td class="x-column-header x-column-header-inner" style="width:65px;text-align: center;border-left: 0px solid #c5c5c5;overflow: hidden;">승무지시</td>',
				'	<td class="x-column-header x-column-header-inner" style="width:65px;text-align: center;border-left: 0px solid #c5c5c5;overflow: hidden;">운행시각</td>',
				'</tr>',
				'</table></td>' ,
				'<tpl if="COL_NUM == MAX_RUN_COUNT">',
				'</tr>',
				'</tpl>',
			'	</tpl>',
			'	</tpl>',
		 '<tpl for=".">' ,
			'<tpl if="COL_NUM == MIN_RUN_COUNT">' ,
				'<tr class="x-grid-row x-grid-with-row-lines"><td width="40" class="x-column-header x-column-header-inner" style="text-align: center;border-left: 0px solid #c5c5c5;overflow: hidden;"> {ROW_NUM}번</td>' ,
				'	 <td width="50" align="center" class="x-grid-cell x-grid-with-col-lines x-grid-td x-grid-cell-inner" style="vertical-align:middle;overflow: hidden;">{DUTY_FR_TIME}</td>' ,
				'	 <td width="50" align="center" class="x-grid-cell x-grid-with-col-lines x-grid-td x-grid-cell-inner" style="vertical-align:middle;overflow: hidden;">{SYS_DUTY_FR_TIME}</td>' ,
	                	
			'</tpl>',
	                '<td>',
	                	'<tpl if="RUN_COUNT != \'\' && OTHER_VEHICLE_YN !=\'Y\'">',
	                	'<div class="data-source" style="padding: 0 !important;">',
	                	'<table cellspacing="0" cellpadding="0" width="100%" border="0">',
	                	'<tr class="x-grid-row x-grid-with-row-lines',
	                	'<tpl if="NOTINSERVICE_YN ==\'Y\'">',
		                 ' bus-fixednotinservice',
		                 '</tpl>',
	                	'">' ,
						'	 <td width="40" align="center" class="x-grid-cell x-grid-with-col-lines x-grid-td  x-grid-cell-inner" style="vertical-align:middle;overflow: hidden;">{VEHICLE_NAME}</td>' ,
						'	 <td width="65"  class="x-grid-cell x-grid-with-col-lines x-grid-td  x-grid-cell-inner" style="vertical-align:middle;overflow: hidden;">{NAME}</td>' ,
						'	 <td width="65"  class="x-grid-cell x-grid-with-col-lines x-grid-td  x-grid-cell-inner" style="vertical-align:middle;overflow: hidden;">{DRIVER_CODE}</td>' ,
						'	 <td width="65" align="center" class="x-grid-cell x-grid-with-col-lines x-grid-td x-grid-cell-inner" style="vertical-align:middle;overflow: hidden;">{DEPARTURE_TIME}</td>' ,
						'	 <td width="65" align="center" class="x-grid-cell x-grid-with-col-lines x-grid-td x-grid-cell-inner" style="vertical-align:middle;overflow: hidden;">{RUN_DEPARTURE_TIME}</td>' ,
						'<tpl if="COL_NUM == OP_MIN_RUN_COUNT">',
						'</tpl>',
		            	'</tr>',
		            	'</table></div>',
		            	'</tpl>',
		            	'<tpl if="RUN_COUNT != \'\' && OTHER_VEHICLE_YN ==\'Y\'">',
	                	'<div class="data-source" style="padding: 0 !important;">',
	                	'<table cellspacing="0" cellpadding="0" width="100%" border="0">',
	                	'<tr class="x-grid-row x-grid-with-row-lines bus-fixedothervehicle">' ,
						'	 <td width="40" align="center" class="x-grid-cell x-grid-with-col-lines x-grid-td  x-grid-cell-inner" style="vertical-align:middle;overflow: hidden;">타차</td>' ,
						'	 <td width="65"  class="x-grid-cell x-grid-with-col-lines x-grid-td  x-grid-cell-inner" style="vertical-align:middle;overflow: hidden;">{NAME}</td>' ,
						'	 <td width="65"  class="x-grid-cell x-grid-with-col-lines x-grid-td  x-grid-cell-inner" style="vertical-align:middle;overflow: hidden;">{DRIVER_CODE}</td>' ,
						'	 <td width="65" align="center" class="x-grid-cell x-grid-with-col-lines x-grid-td x-grid-cell-inner" style="vertical-align:middle;overflow: hidden;">{DEPARTURE_TIME}</td>' ,
						'	 <td width="65" align="center" class="x-grid-cell x-grid-with-col-lines x-grid-td x-grid-cell-inner" style="vertical-align:middle;overflow: hidden;">{RUN_DEPARTURE_TIME}</td>' ,
		            	'</tr>',
		            	'</table></div>',
		            	'</tpl>',
		            	'<tpl if="RUN_COUNT == \'\'">',
		                '<div class="data-source" style="padding: 0 !important;">',
		                '<table cellspacing="0" cellpadding="0" width="100%" border="0">',
	                	'<tr class="x-grid-row x-grid-with-row-lines">' ,
						'	 <td width="40" align="center" class="x-grid-cell x-grid-with-col-lines x-grid-td  x-grid-cell-inner" style="vertical-align:middle;overflow: hidden;">&nbsp;</td>' ,
						'	 <td width="65" align="center" class="x-grid-cell x-grid-with-col-lines x-grid-td  x-grid-cell-inner" style="vertical-align:middle;overflow: hidden;">&nbsp;</td>' ,
						'	 <td width="65" align="center" class="x-grid-cell x-grid-with-col-lines x-grid-td  x-grid-cell-inner" style="vertical-align:middle;overflow: hidden;">&nbsp;</td>' ,
						'	 <td width="65" align="center" class="x-grid-cell x-grid-with-col-lines x-grid-td x-grid-cell-inner" style="vertical-align:middle;overflow: hidden;">&nbsp;</td>' ,
						'	 <td width="65" align="center" class="x-grid-cell x-grid-with-col-lines x-grid-td x-grid-cell-inner" style="vertical-align:middle;overflow: hidden;">&nbsp;</td>' ,
						'</tr>',
		            	'</table>',
		                '</div>',
		            	'</tpl>',
	                '</td>',
	        '<tpl if="COL_NUM == MAX_RUN_COUNT">',
	        	'	 <td width="50" align="center" class="x-grid-cell x-grid-with-col-lines x-grid-td x-grid-cell-inner" style="vertical-align:middle;overflow: hidden;">{DUTY_TO_TIME}</td>' ,
				'	 <td width="50" align="center" class="x-grid-cell x-grid-with-col-lines x-grid-td x-grid-cell-inner" style="vertical-align:middle;overflow: hidden;">{SYS_DUTY_TO_TIME}</td>' ,  	
				'</tr>',
			'</tpl>',
        '</tpl>' ,
        '</table>',
        {
        	showDriverCode:false,
        	setShowDriver: function	(visible)	{
        			this.showDriverCode = visible;
        	}
        }
	);
    var masterView = Ext.create('UniDragandDropView', {	//UniDropView
    	region:'center',
    	title: '운행일지',
    	autoScroll: true,
		tpl: masterViewTplTemplate,
        store: masterStore,
        style:'background-color: #fff',
        applyAll: true,
        singleSelect: false,
        multiSelect: true,
        
        tplType :'view',
        setApplyAll:function(bApplyAll)	{
        	this.applyAll = bApplyAll;
        },
        onDropEnter: function(target, dd, e, drag)	{
        	var me = this;
        	var drop = me.getDropRecord();
        	// 회수가 없는 경우
			if(Ext.isEmpty(drop.get("RUN_COUNT")))	{
        		me.setAllowDrop(false);
        		return false;
        	}
        	//타차의 경우
        	if(drop.get("OTHER_VEHICLE_YN") == "Y")	{
        		if("uniDragandDropView" != drag.view.getXType())	{
        			me.setAllowDrop(false);
        			return false;
        		}
        	}
        	//마감의 경우
        	if(drop.get("CONFIRM_YN") == "Y")	{
        		me.setAllowDrop(false);
        		return false;
        	}
        	
        	me.setAllowDrop(true);
        	return true;
        	
        },
        onDrop : function(target, dd, e, drag){
        	var me = this;
        	var drop = me.getDropRecord();
        	
        	var dragRec; //var dragRec = me.getDragRecord();
        	if("uniDragView" == drag.view.getXType())	{
	        	dragRec = drag.record;
        	}else if("uniDragandDropView" == drag.view.getXType())	{
        		dragRec = drag.record;
        	}else {
        		dragRec = drag.records[0];
        	}
        	
        	console.log("### Drag Data", dragRec);
        	console.log("### Drop Data", drop);
        	
        	var refreshAllFlag = false;
        	
        	var store = me.getStore();	           
            var dragRunCnt = drop.get("RUN_COUNT");
            var dragOpCnt = drop.get("OPERATION_COUNT");
            var dropDriverCode = drop.get("DRIVER_CODE");
            var dropDriverName = drop.get("NAME");
            var dropVehicleCode = drop.get("VEHICLE_CODE");
            var dropVehicleName = drop.get("VEHICLE_NAME");
            var dropChangeFlag = drop.get("CHANGE_FLAG");
            var dropOtherVehicleYn = drop.get("OTHER_VEHICLE_YN");
            var dropNotinServiceYn = drop.get("NOTINSERVICE_YN");
            var dropSysFrTime = drop.get("SYS_DUTY_FR_TIME");
            var dropSysToTime = drop.get("SYS_DUTY_TO_TIME");
            var dropWorkTeamCode = drop.get("WORK_TEAM_CODE");
            // 같은 순번의 같은 기사가 없도록 기사정보 찾기
            var s_drvCheck = -1, e_drvCheck = -1;
            Ext.each(store.data.items, function(record, idx) {
	            	if(s_drvCheck == -1 && dragRec.get('DRIVER_CODE') == record.get('DRIVER_CODE'))	{
	            		opCount = record.get("OPERATION_COUNT");
	            		s_drvCheck =  record.get('RUN_COUNT')
	            	}
	            	if(s_drvCheck > -1 && e_drvCheck == -1  )	{
	            		if(dragRec.get('DRIVER_CODE') != record.get('DRIVER_CODE'))	{
	            			e_drvCheck =  Integer.parseInt(record.get('RUN_COUNT'))-1 // 마지막 기사배정 순번 다음 run_count 이므로 -1.
	            		}else if(record.get('OP_MAX_RUN_COUNT') == record.get('RUN_COUNT')  )	{
	            			e_drvCheck =  record.get('RUN_COUNT');
	            		}
	            	}
	            	
	            	if(dragRec.get('DRIVER_CODE') == record.get('DRIVER_CODE'))	{
	            		if(s_drvCheck > record.get('RUN_COUNT'))	{
	            			s_drvCheck =  record.get('RUN_COUNT');
	            		}
						if(e_drvCheck <= record.get('RUN_COUNT'))	{
							e_drvCheck =  record.get('RUN_COUNT');
						}
	            	}
            });
            console.log("s_drvCheck :", s_drvCheck);
            console.log("e_drvCheck :", e_drvCheck);
           
            // 같은 순번의 같은 기사가 없도록 기사정보 찾기 끝
            
            // 기사정보 Panel 에서 Drag 한경우
            if("uniDragandDropView" != drag.view.getXType())	{
	     		if(masterView.applyAll)	{
	     			Ext.each(store.data.items, function(record, idx) {
		            	var runCnt = record.get('RUN_COUNT'); 
		            	var opCnt = record.get('OPERATION_COUNT');
		            	 console.log("(s_drvCheck  == -1 || runCnt >=s_drvCheck && runCnt < e_drvCheck )",(s_drvCheck  == -1 || runCnt <s_drvCheck && runCnt >= e_drvCheck ));
		            	 console.log("runCnt : ",runCnt);
		             	if(opCnt == dragOpCnt && runCnt >= dragRunCnt && (s_drvCheck  == -1 || (runCnt < s_drvCheck || runCnt > e_drvCheck )))	{
		             		if(!Ext.isEmpty(dragRec.get("NAME")) ) 			{
		             			record.set("NAME", dragRec.get("NAME"));
		             		}
		             		if(!Ext.isEmpty(dragRec.get("DRIVER_CODE")) ) 			{
		             			record.set("DRIVER_CODE", dragRec.get("DRIVER_CODE"));
		             			record.set("SYS_DUTY_FR_TIME", "");
		             			record.set("SYS_DUTY_TO_TIME", "");
		             			
		             			if(record.get("COL_NUM") == record.get("OP_MIN_RUN_COUNT") || record.get("COL_NUM") == record.get("OP_MAX_RUN_COUNT"))	{
		             				refreshAllFlag = true;
		             			}
		             		}
		             		if(!Ext.isEmpty(dragRec.get("PERSON_NUMB"))  ) 	{
		             			record.set("PERSON_NUMB", dragRec.get("PERSON_NUMB"));
		             		}
		             		if(!Ext.isEmpty(dragRec.get("VEHICLE_CODE"))  ) 	{
		             			record.set("VEHICLE_CODE", dragRec.get("VEHICLE_CODE"));
		             		}
		             		if(!Ext.isEmpty(dragRec.get("VEHICLE_NAME")) ) 	{
		             			record.set("VEHICLE_NAME", dragRec.get("VEHICLE_NAME"));
		             		}
		             		if(!Ext.isEmpty(dragRec.get("OTHER_VEHICLE_YN")) ) 	{
		             			record.set("OTHER_VEHICLE_YN", dragRec.get("OTHER_VEHICLE_YN"));
		             		}
		             		if(!Ext.isEmpty(dragRec.get("NOTINSERVICE_YN")) ) 	{
		             			record.set("NOTINSERVICE_YN", dragRec.get("NOTINSERVICE_YN"));
		             		}
		             		if(!Ext.isEmpty(dragRec.get("CHANGE_FLAG")) ) 	{
		             			record.set("CHANGE_FLAG", dragRec.get("CHANGE_FLAG"));
		             		}
		             		if(!Ext.isEmpty(dragRec.get("WORK_TEAM_CODE")) ) 	{
		             			record.set("WORK_TEAM_CODE", dragRec.get("WORK_TEAM_CODE"));
		             		}
		             		
		             		masterView.refreshNode(idx);
		             	}
		    		})
	     		}else {
	     			var idx = masterStore.indexOf(drop);
	     			if(!Ext.isEmpty(dragRec.get("NAME")) ) 			{
		             	drop.set("NAME", dragRec.get("NAME"));
		             	
		     		}
		     		if(!Ext.isEmpty(dragRec.get("DRIVER_CODE")) ) 			{
		     			drop.set("DRIVER_CODE", dragRec.get("DRIVER_CODE"));
	         			drop.set("SYS_DUTY_FR_TIME", "");
	         			drop.set("SYS_DUTY_TO_TIME", "");    	
	         			
	         			if(drop.get("COL_NUM") == drop.get("OP_MIN_RUN_COUNT") || drop.get("COL_NUM") == drop.get("OP_MAX_RUN_COUNT"))	{
	         				refreshAllFlag = true;
	         			}
		     		}
		     		if(!Ext.isEmpty(dragRec.get("PERSON_NUMB")) ) 	{
		     			drop.set("PERSON_NUMB", dragRec.get("PERSON_NUMB"));
		     		}
		     		if(!Ext.isEmpty(dragRec.get("VEHICLE_CODE")) ) 	{
		     			drop.set("VEHICLE_CODE", dragRec.get("VEHICLE_CODE"));
		     		}
		     		if(!Ext.isEmpty(dragRec.get("VEHICLE_NAME"))  ) 	{
		     			drop.set("VEHICLE_NAME", dragRec.get("VEHICLE_NAME"));
		     		}
		     		if(!Ext.isEmpty(dragRec.get("OTHER_VEHICLE_YN")) ) 	{
	         			drop.set("OTHER_VEHICLE_YN", dragRec.get("OTHER_VEHICLE_YN"));
	         		}
	         		if(!Ext.isEmpty(dragRec.get("NOTINSERVICE_YN")) ) 	{
	         			drop.set("NOTINSERVICE_YN", dragRec.get("NOTINSERVICE_YN"));
	         		}
	         		if(!Ext.isEmpty(dragRec.get("CHANGE_FLAG")) ) 	{
	         			drop.set("CHANGE_FLAG", dragRec.get("CHANGE_FLAG"));
	         		}
	         		if(!Ext.isEmpty(dragRec.get("WORK_TEAM_CODE"))  ) 	{
	         			drop.set("WORK_TEAM_CODE", dragRec.get("WORK_TEAM_CODE"));
	         		}
	         		
	         		masterView.refreshNode(idx);
	     		}
        	}else 	{ // "uniDragandDropView" == drag.view.getXType()  순서 바꾸는 경우
        		
        		var dragArr = new Array();
        		var dropArr = new Array();
        		refreshAllFlag = true;
        		
        		Ext.each(store.data.items, function(record, idx) {
	            	var opCnt = record.get('ROW_NUM');
	             	if(opCnt == dragRec.get("ROW_NUM"))	{
	             		var rec = {
	             			COL_NUM 		: record.get("COL_NUM"),
	             			NAME			: record.get("NAME"),
	             			DRIVER_CODE		: record.get("DRIVER_CODE"),
	             			PERSON_NUMB		: record.get("PERSON_NUMB"),
	             			VEHICLE_CODE	: record.get("VEHICLE_CODE"),
	             			VEHICLE_NAME	: record.get("VEHICLE_NAME"),
	             			OTHER_VEHICLE_YN: record.get("OTHER_VEHICLE_YN"),
	             			NOTINSERVICE_YN	: record.get("NOTINSERVICE_YN"),
	             			SYS_DUTY_FR_TIME: record.get("SYS_DUTY_FR_TIME"),
	             			SYS_DUTY_TO_TIME: record.get("SYS_DUTY_TO_TIME"),
	             			CHANGE_FLAG		: record.get("CHANGE_FLAG"),
	             			WORK_TEAM_CODE	: record.get("WORK_TEAM_CODE"),
	             			RUN_COUNT		: record.get("RUN_COUNT")
	             		}
        				dragArr.push(rec);       		
	             	}else if(opCnt == drop.get("ROW_NUM"))	{
	             		var rec = {
	             			COL_NUM 		: record.get("COL_NUM"),
	             			NAME			: record.get("NAME"),
	             			DRIVER_CODE		: record.get("DRIVER_CODE"),
	             			PERSON_NUMB		: record.get("PERSON_NUMB"),
	             			VEHICLE_CODE	: record.get("VEHICLE_CODE"),
	             			VEHICLE_NAME	: record.get("VEHICLE_NAME"),
	             			OTHER_VEHICLE_YN: record.get("OTHER_VEHICLE_YN"),
	             			NOTINSERVICE_YN	: record.get("NOTINSERVICE_YN"),
	             			SYS_DUTY_FR_TIME: record.get("SYS_DUTY_FR_TIME"),
	             			SYS_DUTY_TO_TIME: record.get("SYS_DUTY_TO_TIME"),
	             			CHANGE_FLAG		: record.get("CHANGE_FLAG"),
	             			WORK_TEAM_CODE	: record.get("WORK_TEAM_CODE"),
	             			RUN_COUNT		: record.get("RUN_COUNT")
	             		}
	             		dropArr.push(rec);
	             	}
        		});
        		Ext.each(store.data.items, function(record, idx) {
        			var opCnt = record.get('OPERATION_COUNT');        		
        			if(opCnt == drop.get("OPERATION_COUNT"))	{
        				var arrSize = dragArr.length-2;
        				Ext.each(dragArr, function(rec, i) {
        					if(record.get("COL_NUM") == rec.COL_NUM)	{
        						if(Ext.isEmpty(rec.RUN_COUNT) && !Ext.isEmpty(record.get("RUN_COUNT")))	{  
        							
        							if(i == 0 && arrSize > 1)	{
        								record.set("NAME"				, dragArr[1].NAME);
				             			record.set("DRIVER_CODE"		, dragArr[1].DRIVER_CODE);
				             			record.set("PERSON_NUMB"		, dragArr[1].PERSON_NUMB);
				             			record.set("VEHICLE_CODE"		, dragArr[1].VEHICLE_CODE);
				             			record.set("VEHICLE_NAME"		, dragArr[1].VEHICLE_NAME);
				             			record.set("OTHER_VEHICLE_YN"	, dragArr[1].OTHER_VEHICLE_YN);
				             			record.set("NOTINSERVICE_YN"	, dragArr[1].NOTINSERVICE_YN);
				             			record.set("SYS_DUTY_FR_TIME"	, dragArr[1].SYS_DUTY_FR_TIME);
				             			record.set("SYS_DUTY_TO_TIME"	, dragArr[1].SYS_DUTY_TO_TIME);
				             			record.set("CHANGE_FLAG"		, dragArr[1].CHANGE_FLAG);
				             			record.set("WORK_TEAM_CODE"		, dragArr[1].WORK_TEAM_CODE);
        							}else {
        								record.set("NAME"				, dragArr[arrSize].NAME);
				             			record.set("DRIVER_CODE"		, dragArr[arrSize].DRIVER_CODE);
				             			record.set("PERSON_NUMB"		, dragArr[arrSize].PERSON_NUMB);
				             			record.set("VEHICLE_CODE"		, dragArr[arrSize].VEHICLE_CODE);
				             			record.set("VEHICLE_NAME"		, dragArr[arrSize].VEHICLE_NAME);
				             			record.set("OTHER_VEHICLE_YN"	, dragArr[arrSize].OTHER_VEHICLE_YN);
				             			record.set("NOTINSERVICE_YN"	, dragArr[arrSize].NOTINSERVICE_YN);
				             			record.set("SYS_DUTY_FR_TIME"	, dragArr[arrSize].SYS_DUTY_FR_TIME);
				             			record.set("SYS_DUTY_TO_TIME"	, dragArr[arrSize].SYS_DUTY_TO_TIME);
				             			record.set("CHANGE_FLAG"		, dragArr[arrSize].CHANGE_FLAG);
				             			record.set("WORK_TEAM_CODE"		, dragArr[arrSize].WORK_TEAM_CODE);
        							}
        						}else {
	        						record.set("NAME", rec.NAME);
			             			record.set("DRIVER_CODE", rec.DRIVER_CODE);
			             			record.set("PERSON_NUMB", rec.PERSON_NUMB);
			             			record.set("VEHICLE_CODE", rec.VEHICLE_CODE);
			             			record.set("VEHICLE_NAME", rec.VEHICLE_NAME);
			             			record.set("OTHER_VEHICLE_YN", rec.OTHER_VEHICLE_YN);
			             			record.set("NOTINSERVICE_YN", rec.NOTINSERVICE_YN);
			             			record.set("SYS_DUTY_FR_TIME", rec.SYS_DUTY_FR_TIME);
			             			record.set("SYS_DUTY_TO_TIME", rec.SYS_DUTY_TO_TIME);
			             			record.set("CHANGE_FLAG", rec.CHANGE_FLAG);
			             			record.set("WORK_TEAM_CODE", rec.WORK_TEAM_CODE);
	        					}
	        				}
        				});
        				masterView.refreshNode(idx);
        			}else if(opCnt == dragRec.get("OPERATION_COUNT"))	{
        				var arrSize = dropArr.length-2;
        				Ext.each(dropArr, function(rec, i) {
        					if(record.get("COL_NUM") == rec.COL_NUM)	{
        						if(Ext.isEmpty(rec.RUN_COUNT) && !Ext.isEmpty(record.get("RUN_COUNT")))	{  
        							
        							if(i == 0 && arrSize > 1)	{
        								record.set("NAME"				, dropArr[1].NAME);
				             			record.set("DRIVER_CODE"		, dropArr[1].DRIVER_CODE);
				             			record.set("PERSON_NUMB"		, dropArr[1].PERSON_NUMB);
				             			record.set("VEHICLE_CODE"		, dropArr[1].VEHICLE_CODE);
				             			record.set("VEHICLE_NAME"		, dropArr[1].VEHICLE_NAME);
				             			record.set("OTHER_VEHICLE_YN"	, dropArr[1].OTHER_VEHICLE_YN);
				             			record.set("NOTINSERVICE_YN"	, dropArr[1].NOTINSERVICE_YN);
				             			record.set("SYS_DUTY_FR_TIME"	, dropArr[1].SYS_DUTY_FR_TIME);
				             			record.set("SYS_DUTY_TO_TIME"	, dropArr[1].SYS_DUTY_TO_TIME);
				             			record.set("CHANGE_FLAG"		, dropArr[1].CHANGE_FLAG);
				             			record.set("WORK_TEAM_CODE"		, dropArr[1].WORK_TEAM_CODE);
        							}else {
        								record.set("NAME"				, dropArr[arrSize].NAME);
				             			record.set("DRIVER_CODE"		, dropArr[arrSize].DRIVER_CODE);
				             			record.set("PERSON_NUMB"		, dropArr[arrSize].PERSON_NUMB);
				             			record.set("VEHICLE_CODE"		, dropArr[arrSize].VEHICLE_CODE);
				             			record.set("VEHICLE_NAME"		, dropArr[arrSize].VEHICLE_NAME);
				             			record.set("OTHER_VEHICLE_YN"	, dropArr[arrSize].OTHER_VEHICLE_YN);
				             			record.set("NOTINSERVICE_YN"	, dropArr[arrSize].NOTINSERVICE_YN);
				             			record.set("SYS_DUTY_FR_TIME"	, dropArr[arrSize].SYS_DUTY_FR_TIME);
				             			record.set("SYS_DUTY_TO_TIME"	, dropArr[arrSize].SYS_DUTY_TO_TIME);
				             			record.set("CHANGE_FLAG"		, dropArr[arrSize].CHANGE_FLAG);
				             			record.set("WORK_TEAM_CODE"		, dropArr[arrSize].WORK_TEAM_CODE);
        							}
        						}else {
	        						record.set("NAME", rec.NAME);
			             			record.set("DRIVER_CODE", rec.DRIVER_CODE);
			             			record.set("PERSON_NUMB", rec.PERSON_NUMB);
			             			record.set("VEHICLE_CODE", rec.VEHICLE_CODE);
			             			record.set("VEHICLE_NAME", rec.VEHICLE_NAME);
			             			record.set("OTHER_VEHICLE_YN", rec.OTHER_VEHICLE_YN);
			             			record.set("NOTINSERVICE_YN", rec.NOTINSERVICE_YN);
			             			record.set("SYS_DUTY_FR_TIME", rec.SYS_DUTY_FR_TIME);
			             			record.set("SYS_DUTY_TO_TIME", rec.SYS_DUTY_TO_TIME);
			             			record.set("CHANGE_FLAG", rec.CHANGE_FLAG);
			             			record.set("WORK_TEAM_CODE", rec.WORK_TEAM_CODE);
        						}
        					}
        				});
        				masterView.refreshNode(idx);
        			}
        		})
        	}     	
   	 		if(refreshAllFlag && masterView.tplType ==  'table') {
     			masterView.refresh();
     		}
     		
            return true;
        },     
        listeners: {
            render: function()	{
            	var me = this;
            	this.getEl().on('dblclick', function(e, t, eOpt) {
            		var selectEl = me.getSelectedNodes();
			    	openWindow(me.getRecord(selectEl[0]));
			    });
            },
            itemcontextmenu:function(view, record, item, index, event, eOpts )	{
          	  		event.stopEvent();
					contextMenu.selectedRecord = record;
					contextMenu.selectedIndex = index;
					contextMenu.showAt(event.getXY());					
          	 }
        },
        setTemplate:function(type)	{
        	this.tplType =type;
        	if(type=='view') {
        		
        		this.tpl=  masterViewTplTemplate;
        		
        	} else {
        		this.tpl = masterTableTplTemplate;
        	}
        	this.refresh();
        }
    });
 	var contextMenu = new Ext.menu.Menu({
	        items: [
	                {	text: '기사정보 삭제',   iconCls : 'icon-link',
	                	handler: function(menuItem, event) {
	                		var param = menuItem.up('menu');
	                		var record = masterStore.getAt(param.selectedIndex);
					        
					        var selectedRunCnt = record.get("RUN_COUNT");
				            var selectedOpCnt =  record.get("OPERATION_COUNT");
				            		
				     		if(masterView.applyAll)	{
				     			var store = masterView.getStore();
				     			Ext.each(store.data.items, function(rec, idx) {
					            	var runCnt = rec.get('RUN_COUNT'); 
					            	var opCnt = rec.get('OPERATION_COUNT');
					             	if(opCnt == selectedOpCnt && runCnt >= selectedRunCnt)	{
					             		rec.set("NAME", '');
						     			rec.set("DRIVER_CODE", '');   			
						     			rec.set("PERSON_NUMB", '');
					             	}
					            });
				     		}else {
	                			record.set("NAME", '');
				     			record.set("DRIVER_CODE", '');   			
				     			record.set("PERSON_NUMB", '');
     						}
	                	}
	            	}
	        	]
    	});
    
	Unilite.defineModel('gop300ukrvDriverModel', {
	    fields: [
					 {name: 'DIV_CODE'   		,text:'사업장'		,type : 'string'} 			
					,{name: 'NAME'    			,text:'이름'		,type : 'string'} 					
					,{name: 'DRIVER_CODE'  		,text:'기사코드'	,type : 'string'}
					,{name: 'PERSON_NUMB'    	,text:'사진'		,type : 'string'} 
					,{name: 'ROUTE_GROUP'    	,text:'노선그룹'		,type : 'string'  ,comboType:'AU', comboCode:'GO16', child: 'ROUTE_CODE'}
					,{name: 'ROUTE_CODE'    	,text:'노선'			,type : 'string'  ,comboType:'AU', store: Ext.data.StoreManager.lookup('routeStore') }
					,{name: 'REMARK'  			,text:'비고'		,type : 'string'} 
			]
	});
		
	var driverStore =  Unilite.createStore('gop300ukrvDriverStore',{
        model: 'gop300ukrvDriverModel',
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
                	   read : gopCommonService.driverList
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
		
     var driverView = Ext.create('UniDragView', {
		tpl: '<tpl for=".">'+
                '<div class="drivers-source bus-driver-photo"><img src="'+CPATH+'/uploads/employeePhoto/{PERSON_NUMB}" title="{NAME:htmlEncode}" width="77" height="77"><br/>'+	                
        			'<span>{NAME}</span><br><span>({DRIVER_CODE})</span>'+                    			
        		'</div>'+
            '</tpl>' ,
        itemSelector: 'div.drivers-source',
        overItemCls: 'drivers-over',
        selectedItemClass: 'drivers-selected',
        singleSelect: true,
        store: driverStore
    });
    
    var driverGrid =  Unilite.createGrid('gop300ukrvDriverGrid', {
        hidden:true,
        flex: .15,
        margins: 0,
    	store: driverStore,
    	uniOpt: {
			expandLastColumn: false,
			useRowNumberer: false
        },
        columns:  [ 
        	{dataIndex:'NAME' ,width:80},
        	{dataIndex:'DRIVER_CODE' ,width:80},
        	{dataIndex:'ROUTE_CODE',width:80} ,
        	{dataIndex:'ROUTE_GROUP' ,flex:1}
        ],
        viewConfig: {
        	itemId:'DirverList',
            plugins: {
                ddGroup: 'dataGroup',
                ptype: 'gridviewdragdrop',
                enableDrop: false
            }
        }
    });
    
   Unilite.defineModel('gop300ukrvBusModel', {
	    fields: [
					 {name: 'DIV_CODE'   		,text:'사업장'		,type : 'string'} 					
					,{name: 'VEHICLE_CODE'    	,text:'차량코드'	,type : 'string'} 
					,{name: 'VEHICLE_NAME'    	,text:'차량번호'	,type : 'string'} 
			]
	});
    var busStore = Unilite.createStore('gop300ukrvBusStore',{
        model: 'gop300ukrvBusModel',
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
				var searchForm = Ext.getCmp('${PKGNAME}driverForm');
				var param= searchForm.getValues();
				if(searchForm.isValid())	{
					this.load({params: param});
				}
			}
            
		});
	var busView = Ext.create('UniDragView', {
		tpl: '<tpl for=".">'+
                '<div class="bus-source busData2" style="border: 1px solid #ffffff">' +	                 	
                '<div class="busItemSmall"><table  cellspacing="0" cellpadding="0" width="100%" border="0">'+      	
            	'<tr><td  height="30" style="vertical-align: bottom;padding-left:20px;">{VEHICLE_NAME}</td></tr>'+           		
            	'</table></div></div>'+
            '</tpl>' ,
        itemSelector: 'div.bus-source',
        overItemCls: 'bus-over',
        selectedItemClass: 'bus-selected',
        singleSelect: true,
        store: busStore
    });
    var busGrid =  Unilite.createGrid('gop300ukrvBusGrid', {
        hidden:true,
        flex: .1,
        
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
        	itemId:'TmpBusList',
            plugins: {
                ddGroup: 'dataGroup',
                ptype: 'gridviewdragdrop',
                enableDrop: false,
                enableDrag: true
            }
        }
    });
      var panelSearch2 = Unilite.createSearchPanel('${PKGNAME}driverForm',{
		title: '참조정보',
		region:'east',
		collapseDirection : 'right',
        defaultType: 'uniSearchSubPanel',
        defaults: {
			autoScroll:true
	  	},
        width: 330,
		items: [{	
					title: '기사정보', 	
					collapsible:false,
		   			height:110,
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
						fieldLabel: '노선그룹',
						name: 'ROUTE_GROUP'	,
						xtype: 'uniCombobox',
						comboType:'AU', 
						comboCode:'GO16',
						child: 'ROUTE_CODE'
						
					},{	    
						fieldLabel: '노선',
						name: 'ROUTE_CODE'	,
						xtype: 'uniCombobox',
						store: Ext.data.StoreManager.lookup('routeStore')
					}]				
				},{
					header:false,
			        border:0,
			        defaults:{autoScroll:true},
			        layout: {type: 'vbox', align:'stretch'},
			        flex:0.5,
			        items: [driverView,driverGrid]
				},{	
					title:'차량정보',	
					collapsible:false,
		   			itemId: 'search_panel1',
		   			height:60,
		           	layout: {type: 'uniTable', columns: 1},
		           	defaultType: 'uniTextfield',  
		           	defaults:{
		           		labelWidth:80,		           		
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
						fieldLabel: '차량번호',
						name: 'VEHICLE_NAME'						
					}]				
				},{
					header:false,
			        border:0,
			        defaults:{autoScroll:true},
			        layout: {type: 'vbox', align:'stretch'},
			        flex:0.5,
			        items: [busGrid,busView]
			}]
							
		
	});
    
	var editForm = Unilite.createSearchForm('gop300ukrvDetailForm', {
		layout: {type: 'uniTable', columns : 4},
		defaults:{
			labelWidth:150,
			width:240
		},
		disabled :false,
		trackResetOnLoad: true,
		defaultType:'textfield',
	    items: [	    
			{
				fieldLabel: '차량번호(승무지시)',
				name: 'PLAN_VEHICLE_NAME',
				readOnly: true,
				colspan:2,
				width:315
			},{
				fieldLabel: '기사(승무지시)',
				name: 'PLAN_DRIVER_NAME',
				readOnly: true
			},{
				fieldLabel: '기사코드(승무지시)',
				hideLabel:true,
				name: 'PLAN_DRIVER_CODE',
				readOnly: true,
				width:70
			},{
				fieldLabel: '차량번호(실제운행)',
				name: 'VEHICLE_NAME',
				readOnly: true,
				colspan:2,
				width:315
			},{
				fieldLabel: '기사(실제운행)',
				name: 'NAME',
				readOnly: true
			},{
				fieldLabel: '기사(실제운행)',
				hideLabel:true,
				name: 'DRIVER_CODE',
				readOnly: true,
				width:70
			},{
				fieldLabel: '출발일자/시간(승무지시)',
				name: 'DEPARTURE_DATE',
				xtype:'uniDatefield',
				holdable : 'hold'
			},{
				fieldLabel: '시간',
				name: 'DEPARTURE_TIME',
				hideLabel: true,
				width: 70,
				holdable : 'hold'/*,
				listeners:{
					blur: function (field, The, eOpts )	{
						editForm.chkTime(editForm.getValue('DEPARTURE_DATE'), field, field.getValue());
					}
				}*/
			},{
				fieldLabel: '출발일자/시간(실제운행)',
				name: 'RUN_DEPARTURE_DATE',
				xtype:'uniDatefield',
				readOnly: true
			},{
				fieldLabel: '시간',
				name: 'RUN_DEPARTURE_TIME',
				hideLabel: true,
				readOnly: true,
				width: 70
			},{
				fieldLabel: '출근일자/시간(근태기준)',
				name: 'DUTY_FR_DATE',
				xtype:'uniDatefield',
				holdable : 'hold'
			},{
				fieldLabel: '시간',
				name: 'DUTY_FR_TIME',
				hideLabel: true,
				width: 70,
				holdable : 'hold'/*,
				listeners:{
					blur: function (field, The, eOpts )	{
						editForm.chkTime(editForm.getValue('DUTY_FR_DATE'), field, field.getValue());
					}
				}*/
			},{
				fieldLabel: '출근일자/시간(출입통제)',
				name: 'SYS_DUTY_FR_DATE',
				readOnly: true,
				xtype:'uniDatefield'
			},{
				fieldLabel: '시간',
				name: 'SYS_DUTY_FR_TIME',
				hideLabel: true,
				readOnly: true,
				width: 70
			},{
				fieldLabel: '퇴근일자/시간(근태기준)',
				name: 'DUTY_TO_DATE',
				xtype:'uniDatefield',
				holdable : 'hold'
			},{
				fieldLabel: '시간',
				name: 'DUTY_TO_TIME',
				hideLabel: true,
				width: 70,
				holdable : 'hold'/*,
				listeners:{
					blur: function (field, The, eOpts )	{
						editForm.chkTime(editForm.getValue('DUTY_TO_DATE'), field, field.getValue());
					}
				}*/
			},{
				fieldLabel: '퇴근일자/시간(출입통제)',
				name: 'SYS_DUTY_TO_DATE',
				readOnly: true,
				xtype:'uniDatefield'
			},{
				fieldLabel: '시간',
				name: 'SYS_DUTY_TO_TIME',
				hideLabel: true,
				readOnly: true,
				width: 70
			},{
				fieldLabel: '운휴여부',
				name: 'NOTINSERVICE_YN',
				xtype: 'uniCombobox',
				comboType:'AU', 
				comboCode:'A020',
				colspan:2,
				width:315,
				holdable : 'hold'
			},{
				fieldLabel: '변경사유코드',
				name: 'CHANGE_REASON',
				xtype: 'uniCombobox',
				comboType:'AU', 
				comboCode:'GO17',
				colspan:2,
				width:315,
				holdable : 'hold'
				
			},{
				fieldLabel: '타차여부',
				name: 'OTHER_VEHICLE_YN',
				xtype: 'uniCombobox',
				comboType:'AU', 
				comboCode:'A020',
				colspan:6,
				width: 315,
				holdable : 'hold'
			},{
				fieldLabel: '비고',
				name: 'REMARK',
				colspan:6,
				width: 632,
				holdable : 'hold'
			},{
				fieldLabel: '변경구분',
				name: 'CHANGE_FLAG',
				hidden: true
			},{
				fieldLabel: '마감여부',
				name: 'CONFIRM_YN',
				hidden: true
			}
		],
		chkTime: function(date, fieldName, newValue)	{
			
			if(!date)	{
				//alert("날짜를 입력해 주세요.");
				return;
			}
			var val = newValue.replace(/:/g, "");
			if(val.length == 4)	{
				if(!Ext.Date.isValid(date.getFullYear(),date.getMonth()+1,date.getDate(), val.substring(0,2), val.substring(2,4)))	{
					editForm.setValue(fieldName, '');
					alert("시간을 정확히 입력해 주세요."+'\n'+'예: 06:00:00');
					
					return;
				}
				val = val.substring(0,2)+":"+val.substring(2,4);
				editForm.setValue(fieldName, val);
			} else if(val.length == 6){
				if(!Ext.Date.isValid(date.getFullYear(),date.getMonth()+1,date.getDate(), val.substring(0,2), val.substring(2,4), val.substring(4,6)))	{
					editForm.setValue(fieldName, '');
					alert("시간을 정확히 입력해 주세요."+'\n'+'예: 06:00:00');
					return;
				}
				val = val.substring(0,2)+":"+val.substring(2,4)+":"+val.substring(4,6);						
				editForm.setValue(fieldName, val);
			} else  if(val.length != 0) {
				editForm.setValue(fieldName, '');
				alert("00:00:00(시:분:초) 형식으로 입력하거나 숫자만 입력해 주세요.");
				
			}					
		},
		setAllFieldsReadOnly: function(b) {
			var fields = this.getForm().getFields();
			Ext.each(fields.items, function(item) {
				if(Ext.isDefined(item.holdable) )	{
				 	if (item.holdable == 'hold') {
						item.setReadOnly(b); 
					}
					
				} 
				if(item.isPopupField)	{
					var popupFC = item.up('uniPopupField')	;							
					if(popupFC.holdable == 'hold') {
						popupFC.setReadOnly(b);
					}
					
				}
			})
			
		}
	});

	function openWindow(record) {
		
		editForm.reset(); 
		
		if(!editWindow) {
			editWindow = Ext.create('widget.uniDetailWindow', {
                title: '운행일지',
                width: 680,			                
                height: 285,
                formData: record,
                layout: {type:'vbox', align:'stretch'},	                
                items: [editForm],
                tbar:  [
				        '->',{
							itemId : 'closeBtn',
							text: '닫기',
							handler: function() {
								var node = masterView.getNode(editForm.activeRecord);
								var record= masterView.getRecord(node)
								masterView.refreshNode( masterStore.indexOf(record));
								editWindow.hide();
							},
							disabled: false
						}
				],
				listeners : {
					 beforeshow: function()	{
					 	editForm.clearForm(); 
					 },
        			 show: function( panel, eOpts )	{
        			 	
        			 	var record = panel.formData;
        			 	
        			 	if(editForm.getValue("CONFIRM_YN")!='Y')	{
							editForm.setAllFieldsReadOnly( false );
						}
						
        			 	if(record.get('COL_NUM') == record.get('OP_MIN_RUN_COUNT')){
        			 		editForm.getField("DUTY_FR_DATE").setReadOnly(false);
        			 		editForm.getField("DUTY_FR_TIME").setReadOnly(false);
        			 	}else {
        			 		editForm.getField("DUTY_FR_DATE").setReadOnly(true);
        			 		editForm.getField("DUTY_FR_TIME").setReadOnly(true);
        			 	}
        			 	if(record.get('COL_NUM') == record.get('OP_MAX_RUN_COUNT')){
        			 		editForm.getField("DUTY_TO_DATE").setReadOnly(false);
        			 		editForm.getField("DUTY_TO_TIME").setReadOnly(false);
        			 	}else {
        			 		editForm.getField("DUTY_TO_DATE").setReadOnly(true);
        			 		editForm.getField("DUTY_TO_TIME").setReadOnly(true);
        			 	}
        			 	
        			 	editForm.setActiveRecord(record);	
//        			 	if(editForm.getValue("OTHER_VEHICLE_YN")=='Y')	{
//							editForm.getField("NOTINSERVICE_YN").setReadOnly(true);
//						}
        			 	if(editForm.getValue("CONFIRM_YN")=='Y')	{
							if(!editForm.isDisabled()) editForm.setAllFieldsReadOnly( true );
						}
        			 	editWindow.center();
        			 }
                }		
			})
		}
		editWindow.formData = record;
		editWindow.show();
    }
	
 // 마감
    var confirmSearch= Unilite.createSearchForm('${PKGNAME}conFirmSearchForm', {
		           	layout: {type: 'uniTable', columns: 2},
		           	defaultType: 'uniTextfield',  
		           	defaults:{
		           		labelWidth:60,
		           		width:200
		           	},
			    	items:[{	    
						fieldLabel: '노선그룹',
						name: 'ROUTE_GROUP'	,
						xtype: 'uniCombobox',
						comboType:'AU', 
						comboCode:'GO16',
			            allowBlank:false,
						listeners: {
							change:function()	{
								confirmSearch.setValue('ROUTE_CODE', '');
							}
						}
					},{	    
						fieldLabel: '운행일',
						name: 'OPERATION_DATE',
						xtype: 'uniDatefield',
			            colspan:2,
			            allowBlank:false
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
					}
	 		 	]
    })
    
    Unilite.defineModel('${PKGNAME}ConfirmModel', {
	    fields: [
					 {name: 'DIV_CODE'   			,text:'사업장'		,type : 'string',	comboType:'BOR120'} 
					,{name: 'OPERATION_DATE'    	,text:'운행일'		,type : 'uniDate' } 
					,{name: 'ROUTE_GROUP'    		,text:'노선그룹'	,type : 'string'	,comboType:'AU', comboCode:'GO16'} 
					,{name: 'ROUTE_CODE'    		,text:'노선'		,type : 'string' ,store: Ext.data.StoreManager.lookup('routeStore')} 				
					,{name: 'CONFIRM_YN'    		,text:'마감구분'		,type : 'string'}
					,{name: 'CONFIRM_YN_TEXT'    	,text:'마감구분'		,type : 'string' }
					,{name: 'CHK'    				,text:'체크'		,type : 'string' }
			]
	});
	
	var directProxyConfirm = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read : gop300ukrvService.selectConfirmList,
            update : gop300ukrvService.updateConfirm,
			syncAll: gop300ukrvService.saveAllConfirm
		}
	});
    var confirmStore =  Unilite.createStore('${PKGNAME}ConfirmStore',{
        model: '${PKGNAME}ConfirmModel',
         autoLoad: false,
            uniOpt : {
            	isMaster: false,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            
            proxy: directProxyConfirm,
            saveStore : function(config)	{				
					var records = confirmGrid.getSelectedRecords();
	
					config = {
						params:[confirmSearch.getValues()],
						success: function()	{
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
						var val = record.get('CONFIRM_YN');
		        		if(val == 'Y')	{
		        			record.set('CONFIRM_YN', 'N');
		        		}else {
		        			record.set('CONFIRM_YN', 'Y');
		        		}
					});
					if(records.length > 0)	{
						if(confirmWindow) confirmWindow.mask();
						this.syncAllDirect(config);	
					}
				
			} ,
			loadStoreRecords: function()	{
				var searchForm = Ext.getCmp('${PKGNAME}conFirmSearchForm');
				var param= searchForm.getValues();
				if(searchForm.isValid())	{
					this.load({params: param});
				}
			}
            
		});
		
    var confirmGrid =  Unilite.createGrid('${PKGNAME}confirmGrid', {
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
        	{dataIndex:'CONFIRM_YN_TEXT',width:60},
        	{dataIndex:'OPERATION_DATE' ,width:100}, 
        	{dataIndex:'ROUTE_CODE' 	,flex:1}
        ]
    });
    
    function openConfirmWindow() {
    	if(masterStore.isDirty())	{
			alert('승무내역에 변경내용이 있습니다.'+'\n'+'저장 후 마감작업을 진행할 수 있습니다.');
			return;
		}
		var searchForm = Ext.getCmp('${PKGNAME}searchForm');
		var confirmSearchForm = Ext.getCmp('${PKGNAME}conFirmSearchForm');
		confirmSearchForm.setValue('ROUTE_CODE', searchForm.getValue('ROUTE_CODE'));
		confirmSearchForm.setValue('ROUTE_GROUP', searchForm.getValue('ROUTE_GROUP'));
		confirmSearchForm.setValue('OPERATION_DATE', searchForm.getValue('OPERATION_DATE'));
		
		if(!confirmWindow) {
			confirmWindow = Ext.create('widget.uniDetailWindow', {
                title: '마감',
                width: 450,			                
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
							text: '마감/마감취소',
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

    
      Unilite.Main({
		borderItems:[
	 		 panelSearch,
	 		 {
	 		 	region:'center',
	 		 	xtype:'panel',
				layout:'fit',
	 		 	tbar:  [
	 		 		{
	 		 			xtype:'checkbox',
	 		 			boxLabel  : '해당 순번 모두 적용&nbsp;&nbsp;',
	                    name      : 'APPLY_ALL',
	                    checked : true,
	                    listeners:{
	                    	change:function()	{
	                    		if(this.checked) masterView.setApplyAll(true);
	                    		else masterView.setApplyAll(false);
	                    	}
	                    }
	 		 		},{
	 		 			xtype:'checkbox',
	 		 			boxLabel  : '사번표시&nbsp;&nbsp;',
	                    name      : 'SHOW_CODE',
	                    itemId	  : 'SHOW_CODE',
	                    listeners:{
	                    	change:function()	{
	                    		if(this.checked) {
	                    			masterViewTplTemplate.setShowDriver(true);
	                    		}
	                    		else {
	                    			masterViewTplTemplate.setShowDriver(false);
	                    		}
	                    		masterView.refresh();
	                    	}
	                    }
	 		 		},{
	 		 			xtype:'button',
	 		 			text  : '운휴',
	 		 			title :'ctrl 누르고 버스를 먼저 선택하세요.',
	                    handler:function(){
	                    	var selNodes = masterView.getSelectedNodes();
	                    	if(selNodes.length == 0)	{
	                    		alert('버스를 먼저 선택하세요.'+'\n'+'여러 버스 선택 시 ctrl 누르고 버스를 선택하세요.');
	                    		return;
	                    	}
	                    	//var records = masterView.getRecords(selNodes);
	                    	
	                    	Ext.each(selNodes, function(selNode, idx) {
	                    		var record =  masterView.getRecord(selNode);
	                    		if(!Ext.isEmpty(record.get("RUN_COUNT")))	{
	                    			if(record.get("CONFIRM_YN") != 'Y')	{
		                    			record.set('NOTINSERVICE_YN','Y');
		                    			record.set('CHANGE_FLAG', "NOTINSERVICE");
		                    			masterView.refreshNode(idx);
	                    			}
	                    		}
	                    	})
	                    	if(masterView.applyAll)	{
	                    		Ext.each(selNodes, function(selNode, index) {
	                    			var activeRecord =  masterView.getRecord(selNode);
		                    		Ext.each(masterView.getStore().data.items, function(rec, idx) {
						             	if(rec.get('OPERATION_COUNT') == activeRecord.get('OPERATION_COUNT') && rec.get('RUN_COUNT') >= activeRecord.get('RUN_COUNT') && rec.get("CONFIRM_YN") != 'Y')	{
						             	
					             			rec.set("NOTINSERVICE_YN", 'Y');
					             			rec.set("CHANGE_FLAG", 'NOTINSERVICE');
					             			masterView.refreshNode(idx);
						             	}
						    		})
	                    		})
	                    	}
	                    }
	 		 		},{
	 		 			xtype:'button',
	 		 			text  : '운휴취소',
	                    handler:function(){
	                    	var selNodes = masterView.getSelectedNodes();
	                    	if(selNodes.length == 0)	{
	                    		alert('버스를 먼저 선택하세요.'+'\n'+'여러 버스 선택 시 ctrl 누르고 버스를 선택하세요.');
	                    		return;
	                    	}
	                    	//var records = masterView.getRecords(selNodes);
	                    	Ext.each(selNodes, function(selNode, idx) {
	                    		var record =  masterView.getRecord(selNode);
	                    		if(!Ext.isEmpty(record.get("RUN_COUNT")))	{
	                    			if(record.get("CONFIRM_YN") != 'Y')	{
		                    			record.set('NOTINSERVICE_YN','N');
		                    			record.set('CHANGE_FLAG', (record.raw.CHANGE_FLAG == 'NOTINSERVICE') ? '': record.raw.CHANGE_FLAG);	    
		                    			masterView.refreshNode(idx);
	                    			}
	                    		}
	                    	})
	                    	if(masterView.applyAll)	{
	                    		Ext.each(selNodes, function(selNode, index) {
	                    			var activeRecord =  masterView.getRecord(selNode);
		                    		Ext.each(masterView.getStore().data.items, function(rec, idx) {
						             	if(rec.get('OPERATION_COUNT') == activeRecord.get('OPERATION_COUNT') && rec.get('RUN_COUNT') >= activeRecord.get('RUN_COUNT') && rec.get("CONFIRM_YN") != 'Y')	{
					             			rec.set("NOTINSERVICE_YN", 'N');
					             			rec.set('CHANGE_FLAG', (rec.raw.CHANGE_FLAG == 'NOTINSERVICE') ? '': rec.raw.CHANGE_FLAG);	
					             			masterView.refreshNode(idx);
						             	}
						    		})
	                    		})
	                    	}
	                    	
	                    }
	 		 		},
	 		 		'->',
	 				{xtype:'component',
           			 html:'<div style="line-height:20px;">' +
           			 		/*'<img src="'+CPATH+'/resources/images/busoperate/greenO.png"> 정상&nbsp;&nbsp;' +
           			 		'<img src="'+CPATH+'/resources/images/busoperate/yellowO.png"> 변경&nbsp;&nbsp;' +
           			 		'<img src="'+CPATH+'/resources/images/busoperate/redO.png"> 운휴&nbsp;&nbsp;' +
           			 		'<img src="'+CPATH+'/resources/images/busoperate/grayO.png"> 타차&nbsp;&nbsp;&nbsp;&nbsp;' +	*/
           			 		'<font style="color:#71d071">●</font> 운행&nbsp;&nbsp;'+
           			 	  	'<font style="color:#d17272">●</font> 운휴&nbsp;&nbsp;'+
           			 	  	'<font style="color:#989898">●</font> 타차&nbsp;&nbsp;&nbsp;&nbsp;'+
           			 		
           			 		'<font style="color:#5b9bd5">■</font> 승무지시&nbsp;&nbsp;'+
           			 	  	'<font style="color:#ed7c31">■</font> 운행시각&nbsp;&nbsp;'+
           			 	  	'<font style="color:#ffc000">■</font> 근태기준&nbsp;&nbsp;'+
           			 	  	'<font style="color:#70ad47">■</font> 출입통제</div>'
           			}
				],
				tools: [
					{
						type: 'hum-grid',					            
			            handler: function () {
			                masterView.setTemplate('table');
			                UniAppManager.app.down('#SHOW_CODE').setDisabled(true);
			            }
	        		},{
	
						type: 'hum-photo',					            
			            handler: function () {
			                masterView.setTemplate('view');
			                UniAppManager.app.down('#SHOW_CODE').setDisabled(false);
			            }
	        		}
							
				],
	 		 	items: [masterView]
	 		},
	 		 panelSearch2
		],
		id  : 'gop300ukrApp',
		autoButtonControl : false,
		fnInitBinding : function(params) {
			UniAppManager.setToolbarButtons(['reset', 'excel','print','newData'],false);
			//driverStore.loadStoreRecords();
			//busStore.loadStoreRecords();
			if(params) {
				if(!Ext.isEmpty(params.DIV_CODE))	{
					var sfrm = Ext.getCmp('${PKGNAME}searchForm');
					sfrm.setValue('DIV_CODE',params.DIV_CODE);
					sfrm.setValue('ROUTE_GROUP',params.ROUTE_GROUP);
					//setTimeout("",1000);
					sfrm.setValue('ROUTE_CODE',params.ROUTE_CODE)
					sfrm.setValue('OPERATION_DATE',params.OPERATION_DATE);
					routeStore.loadStoreRecords();
				}
			}
		}
		,
		onQueryButtonDown : function()	{
			routeStore.loadStoreRecords();
			
		},	
		onSaveDataButtonDown: function (config) {
			masterStore.saveStore(config);
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
	
	Unilite.createValidator('${PKGNAME}validator', {
		store : masterStore,
		forms: {'formA:':editForm},
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			var form = this.forms["formA:"];
			var activeRecord = (record.type =='form') ? form.activeRecord: record;
			switch(fieldName)	{
				
				case 'DUTY_FR_TIME' :	
					var date = form.getValue('DUTY_FR_DATE');
					editForm.chkTime(date, fieldName, newValue);	
					Ext.each(this.store.data.items, function(rec, idx) {
		             	if(rec.get('OPERATION_COUNT') == activeRecord.get('OPERATION_COUNT'))	{
	             				rec.set(fieldName, newValue);
	             				masterView.refreshNode(idx);
		             	}
		    		})
					break;
				case 'DUTY_TO_TIME' :	
					var date = form.getValue('DUTY_TO_DATE');
					editForm.chkTime(date, fieldName, newValue);		
					Ext.each(this.store.data.items, function(rec, idx) {
		             	if(rec.get('OPERATION_COUNT') == activeRecord.get('OPERATION_COUNT'))	{
	             				rec.set(fieldName, newValue);
	             				masterView.refreshNode(idx);
		             	}
		    		})
					break;
				case 'DEPARTURE_TIME' :	
					var date = form.getValue('DEPARTURE_DATE');
					editForm.chkTime(date, fieldName, newValue);
					break;
				case 'NOTINSERVICE_YN' :	
					
					if(newValue == 'Y')	{
						editForm.setValue('CHANGE_FLAG', "NOTINSERVICE");
						var selRunCnt = activeRecord.get('RUN_COUNT');
						var selOpCnt = activeRecord.get('OPERATION_COUNT');
				
					}else {
						var planDriver = activeRecord.get("PLAN_DRIVER_CODE");
						var driver = activeRecord.get("DRIVER_CODE");
						var planVehicle = activeRecord.get("PLAN_VEHICLE_CODE");
						var vehicle = activeRecord.get("VEHICLE_CODE");						
					}
					if(masterView.applyAll)	{
						
		     			Ext.each(this.store.data.items, function(rec, idx) {
			             	if(rec.get('OPERATION_COUNT') == activeRecord.get('OPERATION_COUNT') && rec.get('RUN_COUNT') >= activeRecord.get('RUN_COUNT'))	{
		             			if(rec.get("NOTINSERVICE_YN") != newValue)	{
		             				rec.set("NOTINSERVICE_YN", newValue);
		             				if(newValue=="Y")	{
		             					rec.set("CHANGE_FLAG", 'NOTINSERVICE');
		             				}else {
		             					var planDriver = rec.get("PLAN_DRIVER_CODE");
										var driver = rec.get("DRIVER_CODE");
										var planVehicle = rec.get("PLAN_VEHICLE_CODE");
										var vehicle = rec.get("VEHICLE_CODE");
		             				}
		             				masterView.refreshNode(idx);
		             			}
			             	}
			    		})
		     		}
					break;
				default :
					break;
			}
			return rv;
		}
	}); // validator
	
	
}; // main
  
</script>