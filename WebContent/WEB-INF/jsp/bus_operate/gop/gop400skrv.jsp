<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
//일일근태내역 조회
request.setAttribute("PKGNAME","Unilite_app_gop400skrv");
%>
<t:appConfig pgmId="gop400skrv"  >
	<t:ExtComboStore comboType="BOR120"/>								<!-- 사업장   	--> 
	<t:ExtComboStore comboType="AU" comboCode="GO16"/>				<!-- 노선그룹   	--> 
	<t:ExtComboStore comboType="AU" comboCode="GO37"/>				<!-- 회차구분   	--> 
	<t:ExtComboStore comboType="AU" comboCode="GO38"/>				<!-- 데이터구분   	--> 
	<t:ExtComboStore comboType="AU" comboCode="GO39"/>				<!-- 출발구분  	--> 
	<t:ExtComboStore items="${ROUTE_COMBO}" storeId="routeStore" /> 	<!-- 노선 -->
	
</t:appConfig>
<script type="text/javascript">
function appMain() {
	
	
	Unilite.defineModel('${PKGNAME}model', {
	    fields: [
					 {name: 'DIV_CODE'   			,text:'사업장'			,type : 'string'  ,comboType: 'BOR120' ,defaultValue: UserInfo.divCode} 
 
					,{name: 'DATA_FLAG'    			,text:'구분'			,type : 'string'  ,comboType:'AU', comboCode:'GO38'} 
					,{name: 'ROUTE_GROUP'    		,text:'노선그룹'		,type : 'string'  ,comboType:'AU', comboCode:'GO16'} 
					,{name: 'ROUTE_CODE'    		,text:'노선코드'		,type : 'string'  } 
					,{name: 'ROUTE_NUM'    			,text:'노선번호'		,type : 'string'  }
					,{name: 'VEHICLE_CODE'    		,text:'차량코드'		,type : 'string'  }
					,{name: 'VEHICLE_REGIST_NO'    	,text:'차량번호'		,type : 'string'  }
					,{name: 'OPERATION_DATE'   		,text:'운행일'			,type : 'uniDate' }		
					,{name: 'DRIVER_CODE'   		,text:'기사코드'		,type : 'string'  }	
					,{name: 'NAME'   				,text:'기사명'			,type : 'string'  }	
					,{name: 'OPERATION_COUNT'   	,text:'운행순번'		,type : 'string'  }	
					,{name: 'RUN_COUNT'   			,text:'운행회차'		,type : 'string'  }	
					,{name: 'REF_RUN_COUNT'    		,text:'BIS기준회차'		,type : 'string'  }					
					,{name: 'RUN_SEQ_TYPE'    		,text:'회차구분'		,type : 'string'  ,comboType:'AU', comboCode:'GO37'}
					
					,{name: 'BIS_DRIVER_NO'    		,text:'기사코드(BIS)'	,type : 'string'  }
					,{name: 'BIS_DRIVER_NAME'    	,text:'기사명(BIS)'		,type : 'string'  }
					,{name: 'BIS_RUN_COUNT'    		,text:'운행회차(BIS)'	,type : 'string'  }
					,{name: 'BIS_RUN_SEQ_TYPE'    	,text:'회차구분(BIS)'	,type : 'string'  ,comboType:'AU', comboCode:'GO37'}
					,{name: 'DEPARTURE_DATE'    	,text:'출발일자'		,type : 'uniDate' }
					,{name: 'DEPARTURE_TIME'    	,text:'출발기준'		,type : 'string'  ,convert:convertTime}
					,{name: 'RUN_START_DATE'    	,text:'출발일자(BIS)'	,type : 'uniDate' }
					,{name: 'RUN_START_TIME'    	,text:'출발시간(BIS)'	,type : 'string' ,convert:convertTime }
					,{name: 'RUN_EVAL_TYPE'    		,text:'운행평가'		,type : 'string' ,comboType:'AU', comboCode:'GO39'}
					,{name: 'RUN_DELAY_TIME'    	,text:'지연시간'		,type : 'string' ,convert:convertTime }
					,{name: 'BIS_RUN_END_TIME'    	,text:'도착시간(BIS)'	,type : 'string' ,convert:convertTime }
					,{name: 'BIS_RUN_DISTANCE'    	,text:'운행거리(BIS)'	,type : 'string'  }
					
					,{name: 'REMARK'  				,text:'비고'			,type : 'string'  } 
					,{name: 'COMP_CODE'  			,text:'법인코드'		,type : 'string' ,defaultValue: UserInfo.compCode } 
					
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
                	   read : 'gop400skrvService.selectList'
                }
            },
			loadStoreRecords: function()	{
				var searchForm = Ext.getCmp('${PKGNAME}searchForm');
				var param= searchForm.getValues();
				if(searchForm.isValid())	{
					this.load({params: param});
				}
			}
			
		});
	
	Unilite.defineModel('${PKGNAME}SummaryModel', {
	    fields: [
					 {name: 'OPERATION_CNT'    	,text:'운행'		,type : 'uniQty'  }
					,{name: 'ONTIME_CNT'    	,text:'정시출발'		,type : 'uniQty'  }		
					,{name: 'DELAY_CNT'    		,text:'지연출발'		,type : 'uniQty'  }		
					,{name: 'NONE_CNT'    		,text:'정보없음'		,type : 'uniQty'  }		
			]
			
	});
	var summaryStore =  Unilite.createStore('${PKGNAME}summaryStore',{
        model: '${PKGNAME}SummaryModel',
        data:[
				{'OPERATION_CNT': 0, 'ONTIME_CNT':0, 'DELAY_CNT':0, 'NONE_CNT':0}
			],
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
                	   read : 'gop400skrvService.summary'
                }
            },
			loadStoreRecords: function(record)	{
				var searchForm  = Ext.getCmp('${PKGNAME}searchForm');
				
				var param= searchForm.getValues()
				
				if(searchForm.isValid())	{
					this.load({params: param});
				}
			}
		});	
	var summaryView = Ext.create('Ext.view.View', {
		tpl: [
			'<div class="summary-source" style="width:300px;">' ,
			'<table cellpadding="5" cellspacing="0" border="0" width="100%"  align="center" style="border:1px solid #cccccc;">' ,
			'<tpl for=".">' ,
			'<tr>' ,
			'	<td width="140"  class="bus_gray-label" style="text-align:right;" colspan="2">운행</td>' ,
			'	<td class="bus_white-label" style="text-align:right;padding-right:70px;border-top: 0px solid #cccccc !important">{OPERATION_CNT} 대</td>',
			'</tr>' ,
			'<tr>' ,
			'	<td width="70"  class="bus_gray-label" style="text-align:right;" rowspan="3">첫차운행</td>' ,
			'	<td width="70"  class="bus_gray-label" style="text-align:right;">정시출발</td>' ,
			'	<td class="bus_white-label" style="text-align:right;padding-right:70px !important">{ONTIME_CNT} 대</td>',
			'</tr>' ,
			'<tr>' ,
			'	<td width="70"  class="bus_gray-label" style="text-align:right;">지연출발</td>' ,
			'	<td class="bus_white-label" style="text-align:right;padding-right:70px !important">{DELAY_CNT} 대</td>',
			'</tr>' ,
			'<tr>' ,
			'	<td width="70"  class="bus_gray-label" style="text-align:right;">정보없음</td>' ,
			'	<td class="bus_white-label" style="text-align:right;padding-right:70px !important">{NONE_CNT} 대</td>',
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
		title: '기사정보',
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
						allowBlank:false,
						listeners:{
							change:function(field, newValue, oldValue)	{
								var vehiclePopup = panelSearch.down('#vehicle');
							 	vehiclePopup.setExtParam({'DIV_CODE':newValue});
							 	var driverPopup = panelSearch.down('#driver');
							 	driverPopup.setExtParam({'DIV_CODE':newValue});
							}
						}
					},{	    
						fieldLabel: '운행일',
						name: 'OPERATION_DATE',
						xtype: 'uniDateRangefield',
			            startFieldName: 'OPERATION_DATE_FR',
			            endFieldName: 'OPERATION_DATE_TO',	
			            startDate: UniDate.get('today'),
			            endDate: UniDate.get('today'),
			            width:320,
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
					},{	    
						fieldLabel: '차량명',
						name: 'VEHICLE_NAME'
						
					},
					Unilite.popup('DRIVER',
						 {
						 	itemId:'driver',
						 	extParam:{'DIV_CODE': UserInfo.divCode}
						  
						 }
					)
					,{	    
							fieldLabel: '회차구분',
							name: 'RUN_SEQ_TYPE'	,
							xtype: 'uniCombobox',
							comboType:'AU', 
							comboCode:'GO37'
					},{	    
							fieldLabel: '출발구분',
							name: 'RUN_EVAL_TYPE'	,
							xtype: 'uniCombobox',
							comboType:'AU', 
							comboCode:'GO39'
					},{	    
							fieldLabel: '데이터구분',
							name: 'DATA_FLAG'	,
							xtype: 'uniCombobox',
							comboType:'AU', 
							comboCode:'GO38'
					}
					]			
				},{	
					title: '요약정보', 	
		   			itemId: 'search_panel2',
		   			height:140,
		           	layout: {type: 'uniTable', columns: 1, tableAttrs:{'align':'center'} },	
		           	autoScroll:false,
			    	items:[summaryView]
				},{	
					title: 'BIS정보 승무내역 반영',
		   			itemId: 'search_panel3',
		           	layout: {type: 'uniTable', columns: 1},
		           	defaultType: 'uniTextfield',  
		           	defaults:{
		           		labelWidth:90
		           	},
			    	items:[{	    
						fieldLabel: '사업장',
						name: 'B_DIV_CODE',
						xtype:'uniCombobox',
						comboType:'BOR120',
						value: UserInfo.divCode,
						listeners:{
							change:function(field, newValue, oldValue)	{
								var vehiclePopup = panelSearch.down('#vehicle');
							 	vehiclePopup.setExtParam({'DIV_CODE':newValue});
							}
						}
					},{	    
						fieldLabel: '운행기간',
						name: 'B_OPERATION_DATE',
						xtype: 'uniDateRangefield',
			            startFieldName: 'OPERATION_START_DATE',
			            endFieldName: 'OPERATION_END_DATE',	
			            startDate: UniDate.today(),
			            endDate: UniDate.today(),
			            width:320,
						height:22
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
						name: 'B_ROUTE_CODE',
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
						xtype:'button',
			        	text:'실행',
			        	width: 300,
			        	tdAttrs:{'align':'center'},
			        	handler: function()	{
			        		var sForm = Ext.getCmp('${PKGNAME}searchForm');
			        		
			        		if(Ext.isEmpty(sForm.getValue('B_DIV_CODE')) )	{
			        			alert("사업장은 필수입력입니다.");
			        			sForm.getField("B_DIV_CODE").focus();
			        			return;
			        		}
			        		if(Ext.isEmpty(sForm.getValue('OPERATION_START_DATE')))	{
			        			alert("운행기간은 필수입력입니다.");
			        			sForm.getField("OPERATION_START_DATE").focus();
			        			return;
			        		}
			        		if(Ext.isEmpty(sForm.getValue('OPERATION_END_DATE')))	{
			        			alert("운행기간은 필수입력입니다.");
			        			sForm.getField("OPERATION_END_DATE").focus();
			        			return;
			        		}
			        		
			        		var params = sForm.getValues();
			        		Ext.getBody().mask();
			        		gop400skrvService.updateRunTime(params, function(provider, response)	{
			        			console.log("response", response);
			        			console.log("provider", provider);
			        			if(provider!= null && provider.ErrorDesc == '')	{
			        				alert("승무내역에 반영이 완료되었습니다.");
			        			}
			        			Ext.getBody().unmask();
			        		})
			        	}
					}					
					]				
				}
				]

	});	//end panelSearch    
	
     var masterGrid = Unilite.createGrid('${PKGNAME}grid', {
        layout : 'fit',        
    	region:'center',
		uniOpt:{
			useRowNumberer: false,
        	expandLastColumn: false,
            useMultipleSorting: false
        },
    	store: masterStore,
		columns:[					

			{dataIndex:'DIV_CODE'				,width: 100, hidden:true},
			{dataIndex:'DATA_FLAG'		,width: 150 ,
			 summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
		              	return Unilite.renderSummaryRow(summaryData, metaData, '합계', '총계');
	                    }
	         },
	         {text:'승무정보',
	          columns:[
			        {dataIndex:'ROUTE_GROUP'			,width: 80 },
			        {dataIndex:'ROUTE_CODE'				,width: 80 },
			        {dataIndex:'ROUTE_NUM'				,width: 80},	        
			        {dataIndex:'VEHICLE_CODE'			,width: 80 },
					{dataIndex:'VEHICLE_REGIST_NO'		,width: 100 },
					{dataIndex:'OPERATION_DATE'			,width: 80 },
					{dataIndex:'DRIVER_CODE'			,width: 80 },
					{dataIndex:'NAME'					,width: 80 },	
					{dataIndex:'OPERATION_COUNT'		,width: 80 },	
					{dataIndex:'RUN_COUNT'				,width: 80 },
			        {dataIndex:'REF_RUN_COUNT'			,width: 80 },
			        {dataIndex:'RUN_SEQ_TYPE'			,width: 80}     
	          ]
	        },
	        {text:'운행정보',
	          columns:[
			        {dataIndex:'BIS_DRIVER_NO'			,width: 90 },
					{dataIndex:'BIS_DRIVER_NAME'		,width: 90 },
					{dataIndex:'BIS_RUN_COUNT'			,width: 100 },
					{dataIndex:'BIS_RUN_SEQ_TYPE'			,width: 100 },
					{dataIndex:'DEPARTURE_DATE'			,width: 80 },
					{dataIndex:'DEPARTURE_TIME'			,width: 80 , align:'center'},
					{dataIndex:'RUN_START_DATE'			,width: 90 },
			        {dataIndex:'RUN_START_TIME'			,width: 90 , align:'center'},
			        {dataIndex:'RUN_EVAL_TYPE'			,width: 80},	
			        {dataIndex:'RUN_DELAY_TIME'			,width: 80 , align:'center'},	
			        {dataIndex:'BIS_RUN_END_TIME'		,width: 90 , align:'center'},
					{dataIndex:'BIS_RUN_DISTANCE'		,width: 90 , align:'right'}
			]
	        },
			{dataIndex:'REMARK'					,flex: 1}
		] ,
		listeners:{
			onGridDblClick: function(grid, record, cellIndex, colName)	{
						
				if(colName == 'ROUTE_GROUP'  || colName == 'ROUTE_CODE'  		|| colName == 'ROUTE_NUM' 		||
				   colName == 'VEHICLE_CODE' || colName == 'VEHICLE_REGIST_NO' 	|| colName == 'OPERATION_DATE' 	||
				   colName == 'DRIVER_CODE'  || colName == 'NAME' 				|| colName == 'OPERATION_COUNT' ||
				   colName == 'RUN_COUNT'    || colName == 'REF_RUN_COUNT' 		|| colName == 'RUN_SEQ_TYPE' )	{	// 일일승무내역 링크
				   	if(UniDate.getDateStr(panelSearch.getValue('OPERATION_DATE_FR')) == UniDate.getDateStr(panelSearch.getValue('OPERATION_DATE_TO')))	{ //승무내역등록 링크
						var param = {
							'DIV_CODE': record.get('DIV_CODE'),
							'ROUTE_GROUP':record.get('ROUTE_GROUP'),
							'ROUTE_CODE':record.get('ROUTE_CODE'),
							'OPERATION_DATE': UniDate.getDateStr(panelSearch.getValue('OPERATION_DATE_FR'))
						}
						var rec = {data : {prgID : 'gop300ukrv'}};
							
						parent.openTab(rec, '/bus_operate/gop300ukrv.do', param);
					}
				   }
			}
		}
   });
   
      Unilite.Main({
		borderItems:[
	 		  panelSearch
	 		 ,masterGrid
		],
		id  : '${PKGNAME}ukrApp',
		autoButtonControl : false,
		fnInitBinding : function(params) {
			UniAppManager.setToolbarButtons(['print', 'newData'], false);
			UniAppManager.setToolbarButtons(['reset', 'excel' ], true);
			
			if(params) {
				if(!Ext.isEmpty(params.DIV_CODE))	{
					var sfrm = Ext.getCmp('${PKGNAME}searchForm');
					sfrm.setValue('DIV_CODE',params.DIV_CODE);
					sfrm.setValue('ROUTE_GROUP',params.ROUTE_GROUP);
					sfrm.setValue('ROUTE_CODE',params.ROUTE_CODE)
					sfrm.setValue('OPERATION_DATE_FR',params.OPERATION_DATE_FR);
					sfrm.setValue('OPERATION_DATE_TO',params.OPERATION_DATE_TO);
					sfrm.setValue('RUN_SEQ_TYPE',params.RUN_SEQ_TYPE);					
					masterStore.loadStoreRecords();
					summaryStore.loadStoreRecords();
				}
			}
		},
		
		onQueryButtonDown : function()	{
			masterStore.loadStoreRecords();
			summaryStore.loadStoreRecords();
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