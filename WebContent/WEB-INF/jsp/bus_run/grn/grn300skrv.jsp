<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
//일일근태내역 조회
request.setAttribute("PKGNAME","Unilite_app_grn300skrv");
%>
<t:appConfig pgmId="grn300skrv"  >
	<t:ExtComboStore comboType="BOR120"/>								<!-- 사업장   	--> 
	<t:ExtComboStore comboType="AU" comboCode="GO16"/>				<!-- 노선그룹   	--> 
	<t:ExtComboStore items="${ROUTE_COMBO}" storeId="routeStore" /> 	<!-- 노선 -->
</t:appConfig>
<script type="text/javascript">
function appMain() {
	
	Unilite.defineModel('${PKGNAME}model', {
	    fields: [	 {name: 'DIV_CODE'    			,text:'사업장'		,type : 'string'  , comboType:'BOR120' }					
					,{name: 'ROUTE_GROUP'    		,text:'노선그룹'	,type : 'string'  , comboType:'AU', comboCode:'GO16'}
					,{name: 'ROUTE_CODE'    		,text:'노선'		,type : 'string'  , store: Ext.data.StoreManager.lookup('routeStore')}	
					,{name: 'OPERATION_DATE'    	,text:'운행일'		,type : 'uniDate' } 
					
					,{name: 'TOTAL_RUN_COUNT'   	,text:'총운행회차'	,type : 'uniQty'  }	
					,{name: 'AVERAGE_INTERVAL'   	,text:'평균배차간걱',type : 'string'  }	
					,{name: 'REMARK'   				,text:'비고'		,type : 'string'  }	
					,{name: 'COMP_CODE'   			,text:'법인코드',type : 'string'  }	
		]
					
	});
	
	
	var masterStore =  Unilite.createStore('${PKGNAME}store',{
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
                	   read : 'grn300skrvService.selectList'
                }
            } ,
			loadStoreRecords: function()	{
				var searchForm = Ext.getCmp('${PKGNAME}searchForm');
				var param= searchForm.getValues();
				if(searchForm.isValid())	{
					this.load({params: param});
				}
			},
            groupField: 'ROUTE_GROUP_NAME'
           
		});
		
 	Unilite.defineModel('${PKGNAME}DetailModel', {
	    fields: [	 	
					 {name: 'DIV_CODE'    				,text:'사업장'		,type : 'string'  , comboType:'BOR120' }					
					,{name: 'ROUTE_GROUP'    			,text:'노선그룹'	,type : 'string'  , comboType:'AU', comboCode:'GO16'}
					,{name: 'ROUTE_CODE'    			,text:'노선'		,type : 'string'  , store: Ext.data.StoreManager.lookup('routeStore')}	
					,{name: 'OPERATION_DATE'    		,text:'운행일'		,type : 'uniDate' } 
					
					,{name: 'OPERATION_COUNT'    		,text:'운행순번'		,type : 'string'  }					
					,{name: 'RUN_COUNT'   				,text:'운행회차'		,type : 'string'  }	
					,{name: 'VEHICLE_NAME'   			,text:'차량'		,type : 'string'  }	
					,{name: 'VEHICLE_REGIST_NO'   		,text:'차량번호'		,type : 'string'  }	
					,{name: 'NAME'   					,text:'기사'			,type : 'string'  }	
					,{name: 'PREV_RUN_DEPARTURE_DATE'   ,text:'앞차출발일자'	,type : 'string'  }	
					,{name: 'PREV_RUN_DEPARTURE_TIME'   ,text:'앞차출발시간'	,type : 'string'  ,convert:convertTime}	
					,{name: 'RUN_DEPARTURE_DATE'   		,text:'출발일자'		,type : 'string'  }	
					,{name: 'RUN_DEPARTURE_TIME'   		,text:'출발시간'		,type : 'string'  ,convert:convertTime}	
					,{name: 'RUN_INTERVAL_TIME'   		,text:'간격'			,type : 'uniQty'  }	
					,{name: 'ROW_NUM'   				,text:'행번호'			,type : 'uniQty'  }	
					,{name: 'REMARK'   					,text:'비고'		,type : 'string'  }	
			]
	});
	
	function convertTime( value, record )	{
		value = value.replace(/:/g, "");
		var r = '';
		if(value.length == 6 ){
			r = value.substring(0,2)+":"+value.substring(2,4)+":"+value.substring(4,6);
		} else if(value.length == 4 ){
			r = value.substring(0,2)+":"+value.substring(2,4);
		}
		return r;
	}
	
	var detailStore =  Unilite.createStore('${PKGNAME}DetailStore',{
        model: '${PKGNAME}DetailModel',
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
                	   read : 'grn300skrvService.selectDetailList'
                }
            },
			loadStoreRecords: function(record)	{
				if(record){
					var param= {
						"DIV_CODE": record.get("DIV_CODE"),
						"OPERATION_DATE_FR": UniDate.getDateStr(record.get("OPERATION_DATE")),
						"OPERATION_DATE_TO": UniDate.getDateStr(record.get("OPERATION_DATE")),
						"ROUTE_GROUP": record.get("ROUTE_GROUP"),
						"ROUTE_CODE": record.get("ROUTE_CODE")
					}
					this.load({params: param});
				}
			}
		});
	
		
	var panelSearch = Unilite.createSearchPanel('${PKGNAME}searchForm',{
		title: '정류소별 운행내역',
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
					},
					 {	    
						fieldLabel: '운행일',
						name: 'OPERATION_DATE',
						xtype: 'uniDateRangefield',
			            startFieldName: 'OPERATION_DATE_FR',
			            endFieldName: 'OPERATION_DATE_TO',	
			            startDate: UniDate.get('yesterday'),
			            endDate: UniDate.get('yesterday'),
			            width:320,
						allowBlank:false,
						height:22
					}
					]				
				}
				]

	});	//end panelSearch    
	
     var masterGrid = Unilite.createGrid('${PKGNAME}grid', {    
    	region:'north',
    	weight:-100,
    	flex:.3,
		uniOpt:{
			useRowNumberer: false,
        	expandLastColumn: false,
            useMultipleSorting: false
        },
    	store: masterStore,			
		columns:[
			{dataIndex:'ROUTE_GROUP'		,width: 80},
			{dataIndex:'ROUTE_CODE'			,width: 80},
			{dataIndex:'OPERATION_DATE'		,width: 80},
			{dataIndex:'TOTAL_RUN_COUNT'	,width: 110},
			{dataIndex:'AVERAGE_INTERVAL'	,width: 110},
			{dataIndex:'REMARK'		,flex: 1}
		        
		] ,
		listeners:{
			selectionchange: function( model, selected, eOpts ) {				
				detailStore.loadStoreRecords(selected[0]);
			}
		}
   });
   	 var detailGrid = Unilite.createGrid('${PKGNAME}detailGrid', {
   	 	layout:'fit',
		uniOpt:{
			useRowNumberer: false,
        	expandLastColumn: false,
            useMultipleSorting: false
        },
    	store: detailStore,
		columns:[		
			{dataIndex:'OPERATION_COUNT'		,width: 80},
			{dataIndex:'RUN_COUNT'				,width: 80},
			{dataIndex:'VEHICLE_REGIST_NO'		,width: 110},
			{dataIndex:'NAME'					,width: 80},
			{dataIndex:'PREV_RUN_DEPARTURE_TIME',width: 100},
			{dataIndex:'RUN_DEPARTURE_TIME'		,width: 100},
			{dataIndex:'RUN_INTERVAL_TIME'		,width: 80},
			{dataIndex:'REMARK'					,flex: 1}
		]
	});
	
	
	var detailTplTemplate =  new Ext.XTemplate(
		'<tpl for=".">' ,
    		'<div class="data-source busItemSmall-wrap2">' ,	    
                '<table  cellspacing="0" cellpadding="0" width="100%" border="0">',   
            	'		<tr>',
            	'		<tpl if="ROW_NUM == 1 ">',
            	'			<td valign="bottom"></td>',   
            	'		</tpl>',
            	'		<tpl if="ROW_NUM &gt; 1 ">',
            	'			<td valign="bottom">{RUN_INTERVAL_TIME}</td>',   
            	'		</tpl>',
            	'			<td rowspan="2"><div class="busItemMedium2" style="padding-top:16px;">{VEHICLE_NAME}</div></td>',            	           	       	
            	'		</tr>',
            	'		<tpl if="ROW_NUM &gt; 1 ">',
                '		<tr>',                
            	'			<td valign="top"><img src="'+CPATH+'/resources/images/busoperate/busIntervalArrow.png" border="0"></td>',     
            	'		</tr>	' ,    
            	'		</tpl>',
            	'		<tpl if="ROW_NUM == 1 ">',
                '		<tr>',                
            	'			<td valign="top" width="60"></td>',     
            	'		</tr>	' ,    
            	'		</tpl>',            	
            	'</table>',
            '</div>',
        '</tpl>' );
        
		

    var detailView =  Ext.create('Ext.view.View', {
    	hidden:true,
    	border: true,
    	flex:1,
    	autoScroll: true,
		tpl: detailTplTemplate,
        store: detailStore,
        style:{
        		'background-color': '#fff' ,
        		'border': '1px solid #9598a8; '
        },
        itemSelector: 'div.data-source'
    })
    
    var detailPanel =  Ext.create('Ext.panel.Panel', {
    	title:'상세배차간격',
    	region:'center',
    	flex:.7,
    	layout: {type: 'vbox', align:'stretch'},
		tools: [
				{
					type: 'hum-grid',					            
		            handler: function () {
		                detailView.hide();
		                detailGrid.show();
		            }
        		},{

					type: 'hum-photo',					            
		            handler: function () {
		                detailGrid.hide();
		                detailView.show();
		            }
        		}
			],
		 items:[
		 	  detailGrid
	 		 ,detailView
		 ]
      })
      Unilite.Main({
		borderItems:[
	 		  panelSearch
	 		 ,masterGrid
	 		 ,detailPanel
	 		 
		],
		id  : '${PKGNAME}ukrApp',
		autoButtonControl : false,
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['print', 'newData'], false);
			UniAppManager.setToolbarButtons(['reset', 'excel' ], true);
		},
		
		onQueryButtonDown : function()	{
			masterStore.loadStoreRecords();
		},
		onPrevDataButtonDown:  function()	{
			masterGrid.selectPriorRow();
		},
		onNextDataButtonDown:  function()	{
			masterGrid.selectNextRow();
		},	
		onNewDataButtonDown:  function()	{
			masterGrid.createRow();
		},	
		
		onSaveDataButtonDown: function (config) {
			masterStore.saveStore();
					
		},
		onDeleteDataButtonDown : function()	{
			if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				masterGrid.deleteSelectedRow();				
			}
		},
		onResetButtonDown:function() {
			var me = this;
			panelSearch.reset();
			masterGrid.reset();
			UniAppManager.setToolbarButtons('save',false);
		},
		onSaveAsExcelButtonDown: function() {
			 masterGrid.downloadExcelXml();
		}
	});
	
}; // main
  
</script>