<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
//월별근태내역 조회
request.setAttribute("PKGNAME","Unilite_app_gtt110skrv");
%>
<t:appConfig pgmId="gtt110skrv"  >
	<t:ExtComboStore comboType="BOR120"/>								<!-- 사업장   	--> 
	<t:ExtComboStore comboType="BOR120" comboCode="GO16"/>				<!-- 노선그룹   	--> 
	<t:ExtComboStore comboType="BOR120" comboCode="GO35"/>				<!-- 노선그룹   	--> 
	<t:ExtComboStore items="${ROUTE_COMBO}" storeId="routeStore" /> 	<!-- 노선 -->
	
</t:appConfig>
<script type="text/javascript">
function appMain() {
	Ext.create('Ext.data.Store', {
		storeId:"confirmYn",
	    fields: ['text', 'value'],
	    data : [
	        {text:"마감",   value:"Y"},
	        {text:"미마감", value:"N"}
	    ]
	});
	Unilite.defineModel('${PKGNAME}model', {
	    fields: [
				
					 {name: 'DIV_CODE'   			,text:'사업장'			,type : 'string'  ,comboType: 'BOR120' ,defaultValue: UserInfo.divCode} 
					,{name: 'DRIVER_CODE'    		,text:'기사코드'		,type : 'string'  } 
					,{name: 'DRIVER_NAME'    		,text:'기사명'			,type : 'string'  } 
					,{name: 'OPERATION_MONTH'    	,text:'근무월'			,type : 'string' } 
					,{name: 'ROUTE_NUM'    			,text:'노선번호'		,type : 'string'  } 
					,{name: 'ROUTE_CODE'    		,text:'노선번호'		,type : 'string'  } 
					,{name: 'VEHICLE_NAME'    		,text:'차량'			,type : 'string'  } 
					,{name: 'VEHICLE_CODE'    		,text:'차량'			,type : 'string'  } 
					,{name: 'VEHICLE_REGIST_NO'    	,text:'차량등록번호'	,type : 'string'  } 
					 		


					,{name: 'DATE_CNT'    			,text:'근무대상일수'		,type : 'uniQty'  }
					,{name: 'TAG_CNT'    			,text:'근무일수'		,type : 'uniQty'  }
					,{name: 'NO_TAG_CNT'    		,text:'출퇴근없음'		,type : 'uniQty'  }
					,{name: 'NO_TAG_IN_CNT'    		,text:'출근없음'		,type : 'uniQty'  }
					,{name: 'NO_TAG_OUT_CNT'    	,text:'퇴근없음'		,type : 'uniQty'  }
					,{name: 'DIFF_FR'   			,text:'지각'			,type : 'uniQty'  }	
					,{name: 'DIFF_TO'   			,text:'조퇴'			,type : 'uniQty'  }	
						
					,{name: 'OP_DATE_CNT_CONFIRM_Y' ,text:'근무일수'		,type : 'uniQty'  }
					,{name: 'OP_DATE_CNT_CONFIRM_N' ,text:'근무일수'		,type : 'uniQty'  }
					
					,{name: 'LATE_CNT_CONFIRM_Y'   	,text:'지각'			,type : 'uniQty'  }	
					,{name: 'LATE_CNT_CONFIRM_N'   	,text:'지각'			,type : 'uniQty'  }	
					
					,{name: 'EARLY_CNT_CONFIRM_Y'   ,text:'조퇴'			,type : 'uniQty'  }	
					,{name: 'EARLY_CNT_CONFIRM_N'   ,text:'조퇴'			,type : 'uniQty'  }	
					
					,{name: 'REMARK'  				,text:'비고'			,type : 'string'  } 
					,{name: 'COMP_CODE'  			,text:'법인코드'		,type : 'string' ,defaultValue: UserInfo.compCode} 
					
					,{name: 'DRIVER_CNT'   			,text:'기사수'			,type : 'uniQty'  	  }		
					,{name: 'ROUTE_CNT'    			,text:'노선수'			,type : 'uniQty'  }
					,{name: 'VEHICLE_CNT'    		,text:'차량수'			,type : 'uniQty'  }
					,{name: 'OPERATION_DATE_CNT'   	,text:'운행일수'		,type : 'uniQty'  	  }	
					,{name: 'LATE_CNT'   			,text:'지각수'			,type : 'uniQty'  	  }	
					,{name: 'EARLY_CNT'   			,text:'조퇴수'			,type : 'uniQty'  	  }	
					
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
                	   read : 'gtt110skrvService.selectList'
                }
            },
			loadStoreRecords: function()	{
				var searchForm = Ext.getCmp('${PKGNAME}searchForm');
				var param= searchForm.getValues();
				if(searchForm.isValid())	{
					this.load({params: param});
				}
			},
            groupField: 'OPERATION_MONTH',
            listeners:{
            	load:function(store, records, successful, eOpts)	{
            		if(successful)	{
            			if(records.length > 0)
            			summaryStore.loadData([records[0]]);
            		}
            	}
            }
		});
	
 	Unilite.defineModel('${PKGNAME}SummaryModel', {
	    fields: [
					 {name: 'DRIVER_CNT'   			,text:'기사수'			,type : 'uniQty'  	  }		
					,{name: 'ROUTE_CNT'    			,text:'노선수'			,type : 'uniQty'  }
					,{name: 'VEHICLE_CNT'    		,text:'차량수'			,type : 'uniQty'  }
					,{name: 'OPERATION_DATE_CNT'   	,text:'운행일수'		,type : 'uniQty'  	  }	
					,{name: 'LATE_CNT'   			,text:'지각수'			,type : 'uniQty'  	  }	
					,{name: 'EARLY_CNT'   			,text:'조퇴수'			,type : 'uniQty'  	  }	
			]
	});
	var summaryStore =  Ext.create('Ext.data.Store', {
        model: '${PKGNAME}SummaryModel',   
        data : [
     		{'DRIVER_CNT': 0,    'ROUTE_CNT': 0,    'VEHICLE_CNT': 0,    'OPERATION_DATE_CNT': 0,    'LATE_CNT': 0,    'EARLY_CNT': 0}
     	]
			
		});	
	var masterView = Ext.create('Ext.view.View', {
		tpl: [
			'<div class="summary-source"  style="padding: 0 !important;border: 0 !important;overflow:hidden">' ,
			'<table cellpadding="5" cellspacing="0" border="0" width="315"  align="center" style="border:1px solid #cccccc;">' ,
			'<tpl for=".">' ,
			'<tr>' ,
			'	<td align="right" width="90"  class="bus_gray-label">기사수</td>' ,
			'	<td align="right" class="bus_white-label" style="padding-right:130px;border-top: 0px solid #cccccc !important">{DRIVER_CNT} 명</td>',
			'</tr>' ,
			'<tr>' ,
			'	<td align="right"  class="bus_gray-label">노선수</td>' ,
			'	<td align="right"  class="bus_white-label" style="padding-right:130px;">{ROUTE_CNT} 개</td>',
			'</tr>' ,
			'<tr>' ,
			'	<td align="right" class="bus_gray-label">차량수</td>' ,
			'	<td align="right" class="bus_white-label" style="padding-right:130px;">{VEHICLE_CNT} 대</td>',
			'</tr>' ,
			'<tr>' ,
			'	<td align="right" class="bus_gray-label">운행일수</td>' ,
			'	<td align="right" class="bus_white-label" style="padding-right:130px;">{OPERATION_DATE_CNT} 일</td>',
			'</tr>' ,
			'<tr>' ,
			'	<td align="right" class="bus_gray-label">지각수</td>' ,
			'	<td align="right" class="bus_white-label" style="padding-right:130px;">{LATE_CNT} 번</td>',
			'</tr>' ,
			'<tr>' ,
			'	<td align="right" class="bus_gray-label">조퇴수</td>' ,
			'	<td align="right" class="bus_white-label" style="padding-right:130px;">{EARLY_CNT} 번</td>',
			'</tr>' ,
			'</tpl>' ,
			'</table><div>'
		],
		border:false,
		autoScroll:false,
		itemSelector: 'div.summary-source',
        store: summaryStore
	});

	var monthStore =  Ext.create('Ext.data.Store', {
			fields:	["value","text","option"],
			data:	[
				{'value':'01','text':'1'},
				{'value':'02','text':'2'},
				{'value':'03','text':'3'},
				{'value':'04','text':'4'},
				{'value':'05','text':'5'},
				{'value':'06','text':'6'},
				{'value':'07','text':'7'},
				{'value':'08','text':'8'},
				{'value':'09','text':'9'},
				{'value':'10','text':'10'},
				{'value':'11','text':'11'},
				{'value':'12','text':'12'},
				{'value':'13','text':'13'},
				{'value':'14','text':'14'},
				{'value':'15','text':'15'},
				{'value':'16','text':'16'},
				{'value':'17','text':'17'},
				{'value':'18','text':'18'},
				{'value':'19','text':'19'},
				{'value':'20','text':'20'},
				{'value':'21','text':'21'},
				{'value':'22','text':'22'},
				{'value':'23','text':'23'},
				{'value':'24','text':'24'},
				{'value':'25','text':'25'},
				{'value':'26','text':'26'},
				{'value':'27','text':'27'},
				{'value':'28','text':'28'},
				{'value':'29','text':'29'},
				{'value':'30','text':'30'},
				{'value':'31','text':'31'}
			],
			storeId:'${PKGNAME}day'
		}
	);

	 

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
		           	layout: {type: 'uniTable', columns: 3},
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
						colspan: 3,
						listeners:{
							change:function(field, newValue, oldValue)	{
								var vehiclePopup = panelSearch.down('#vehicle');
							 	vehiclePopup.setExtParam({'DIV_CODE':newValue});
							}
						}
					},{	    
						fieldLabel: '매월 시작일',
						name: 'FIRST_DATE',
						xtype: 'uniCombobox',
			          	store: Ext.data.StoreManager.lookup('${PKGNAME}day'),
				        maxValue: 31,
				        minValue: 1,
						allowBlank:false,
						value:'26',
						colspan: 3,
						hidden:true
					},{	    
						fieldLabel: '근무월',
						name: 'OPERATION_MONTH_FR',
						xtype: 'uniMonthfield',
			          	store: Ext.data.StoreManager.lookup('${PKGNAME}month'),
						allowBlank:false,
						value: Ext.Date.format(new Date(), 'Ym'),
						width:160
					},{
						xtype:'component',
						html:'~',
						width:'10'
					},{	    
						hidelabel: true,
						name: 'OPERATION_MONTH_TO',
						xtype: 'uniMonthfield',
			          	store: Ext.data.StoreManager.lookup('${PKGNAME}month'),
						allowBlank:false,
						value:Ext.Date.format(new Date(), 'Ym'),
						width:70
					},
					Unilite.popup('DRIVER',
					 {
					 	itemId:'driver',
					 	extParam:{'DIV_CODE': UserInfo.divCode},
						colspan: 3					  	
					 })
					 ,{	    
						fieldLabel: '노선그룹',
						name: 'ROUTE_GROUP'	,
						xtype: 'uniCombobox',
						comboType:'AU', 
						comboCode:'GO16',
						colspan: 3,
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
						colspan: 3,
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
						fieldLabel: '기사구분',
						name: 'ROUTE_TYPE'	,
						xtype: 'uniCombobox',
						comboType:'AU', 
						comboCode:'GO35',
						multiSelect: true,
						typeAhead: false,
						colspan: 3
					}
					]				
				},
				{	
					title: '요약정보', 	
					id: 'search_panel2',
		   			itemId: 'search_panel2',
		           	layout: {type: 'uniTable', columns: 1, tableAttrs:{'align':'center'} },		           
			    	items:[masterView]
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
        dockedItems:{  
        	xtype: 'toolbar',
	        dock: 'top',
	        items: ['->',
        		{
        			xtype:'button', 
        			text:'운행월별',
        			handler:function()	{
        				masterStore.group('OPERATION_MONTH');
        				masterStore.sort({property : 'ROUTE_NUM', direction: 'ASC'}, {property: 'OPERATION_MONTH', direction: 'ASC'});
        				masterGrid.getView().getFeature('masterGridSubTotal').toggleSummaryRow(true);
        			}
        		},{
        			xtype:'button', 
        			text:'기사별',
        			handler:function()	{
        				masterStore.group('DRIVER_NAME');
        				masterStore.sort({property : 'OPERATION_MONTH', direction: 'ASC'});
        				masterGrid.getView().getFeature('masterGridSubTotal').toggleSummaryRow(true);
        			}
        		},{
        			xtype:'button', 
        			text:'노선별',
        			handler:function()	{
        				masterStore.group('ROUTE_NUM');
        				masterStore.sort({property : 'OPERATION_MONTH', direction: 'ASC'}, {property: 'DRIVER_NAME', direction: 'ASC'});
        				masterGrid.getView().getFeature('masterGridSubTotal').toggleSummaryRow(true);
        			}
        		},{
        			xtype:'button', 
        			text:'차량별',
        			handler:function()	{
        				masterStore.group('VEHICLE_NAME');
        				masterStore.sort({property : 'OPERATION_MONTH', direction: 'ASC'});
        				masterGrid.getView().getFeature('masterGridSubTotal').toggleSummaryRow(true);
        			}
        		}
        		
        	]
        },
        features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true},
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
    	store: masterStore,
		columns:[
			{dataIndex:'DIV_CODE'			,width: 100, hidden:true},
			{dataIndex:'OPERATION_MONTH'		,width: 80 },
			{dataIndex:'ROUTE_NUM'		,width: 65,
			 summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
		              	return Unilite.renderSummaryRow(summaryData, metaData, '합계', '총계');
	                    }
	        },
			{dataIndex:'DRIVER_CODE'		,width: 80},
			{dataIndex:'DRIVER_NAME'		,width: 80, summaryType:'count',
			 summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
              	var me = this;
                  	var rv = '<div align="right">'+value+'</div>';
                	return rv;
                }
	        },
	        
			{dataIndex:'DATE_CNT'			,width: 80		,summaryType:'sum'},
			{dataIndex:'TAG_CNT'			,width: 80		,summaryType:'sum'},
			{text:'근무제외일수',
			 columns:[
				{dataIndex:'NO_TAG_CNT'			,width: 80		,summaryType:'sum'},
				{dataIndex:'NO_TAG_IN_CNT'			,width: 80		,summaryType:'sum'},
				{dataIndex:'NO_TAG_OUT_CNT'			,width: 80		,summaryType:'sum'},
			 ]
			},
			{dataIndex:'DIFF_FR'		,width: 60		,summaryType:'sum' },			
			{dataIndex:'DIFF_TO'		,width: 60		,summaryType:'sum' },
			
			{text:'마감', 
			 columns:[
				{dataIndex:'OP_DATE_CNT_CONFIRM_Y'			,width: 60		,summaryType:'sum'},
				{dataIndex:'LATE_CNT_CONFIRM_Y'		,width: 40		,summaryType:'sum' },
				{dataIndex:'EARLY_CNT_CONFIRM_Y'		,width: 40		,summaryType:'sum' }
			 ]
			},
			{text:'미마감', 
			 columns:[
				{dataIndex:'OP_DATE_CNT_CONFIRM_N'			,width: 60		,summaryType:'sum'},
				{dataIndex:'LATE_CNT_CONFIRM_N'		,width: 40		,summaryType:'sum' },
				{dataIndex:'EARLY_CNT_CONFIRM_N'		,width: 40		,summaryType:'sum' }
			 ]
			},
			{dataIndex:'VEHICLE_NAME'		,width: 50 },
			{dataIndex:'VEHICLE_REGIST_NO'	,width: 100 },
			{dataIndex:'REMARK'				,flex: 1}
		],
		listeners:{
			onGridDblClick: function(grid, record, cellIndex, colName)	{
				var frDt = panelSearch.getValue('OPERATION_MONTH_FR');
				var toDt = panelSearch.getValue('OPERATION_MONTH_TO');
					var param = {
						'DIV_CODE': record.get('DIV_CODE'),
						'ATT_DATE_FR':  UniDate.getDateStr(UniDate.add(UniDate.extParseDate(UniDate.get('startOfLastMonth', frDt)),{days:26})),
						'ATT_DATE_TO':  UniDate.getDateStr(UniDate.add(UniDate.extParseDate(UniDate.get('startOfMonth', toDt)),{days:25})),
						'DRIVER_CODE':  record.get('DRIVER_CODE'),
						'DRIVER_NAME':  record.get('DRIVER_NAME')
					}
					var rec = {data : {prgID : 'gtt102skrv'}};
						
					parent.openTab(rec, '/bus_operate/gtt102skrv.do', param);
					
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