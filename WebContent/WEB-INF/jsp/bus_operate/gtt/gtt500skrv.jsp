<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
//일일근태내역 조회
request.setAttribute("PKGNAME","Unilite_app_gtt500skrv");
%>
<t:appConfig pgmId="gtt500skrv"  >
	<t:ExtComboStore comboType="BOR120"/>								<!-- 사업장   	--> 
	<t:ExtComboStore comboType="AU" comboCode="GO16"/>				<!-- 노선그룹   	--> 
	<t:ExtComboStore items="${ROUTE_COMBO}" storeId="routeStore" /> 	<!-- 노선 -->
</t:appConfig>
<script type="text/javascript">
function appMain() {
	
	Unilite.defineModel('${PKGNAME}model', {
	    fields: [	 {name: 'DIV_CODE'    			,text:'사업장'		,type : 'string'  , comboType:'BOR120' }					
					,{name: 'ROUTE_GROUP'    		,text:'노선그룹'	,type : 'string'  , comboType:'AU', comboCode:'GO16'}
					,{name: 'ROUTE_GROUP_NAME'    	,text:'노선그룹'	,type : 'string'  }
					,{name: 'ROUTE_CODE'    		,text:'노선'		,type : 'string'  , store: Ext.data.StoreManager.lookup('routeStore')}	
					
					,{name: 'OPERATION_COUNT_CNT'   ,text:'운행계획'	,type : 'uniQty'  }	
					,{name: 'RUN_OPERATION_CNT'   	,text:'운행'		,type : 'uniQty'  }	
					,{name: 'NOTINSERVICE_CNT'   	,text:'운휴'		,type : 'uniQty'  }	
					,{name: 'DEPARTURE_CNT'   		,text:'정시출발'	,type : 'uniQty'  }	
					,{name: 'LATE_DEPARTURE_CNT'   	,text:'지연출발'	,type : 'uniQty'  }	
					,{name: 'NOT_DEPARTURE_CNT'   	,text:'정보없음'	,type : 'uniQty'  }	
					
					,{name: 'ASSIGNED_DRIVER_CNT'   ,text:'기사배정'	,type : 'uniQty'  }						
					,{name: 'NO_DRIVER_CNT'   		,text:'기사미배정'	,type : 'uniQty'  }	
					,{name: 'TAG_IN_CNT'   			,text:'출근등록'	,type : 'uniQty'  }	
					,{name: 'NO_TAG_IN_CNT'   		,text:'출근미등록'	,type : 'uniQty'  }	
					,{name: 'TAG_OUT_CNT'   		,text:'퇴근등록'	,type : 'uniQty'  }	
					,{name: 'NO_TAG_OUT_CNT'   		,text:'퇴근미등록'	,type : 'uniQty'  }	
					,{name: 'LATE_CNT'   			,text:'지각'		,type : 'uniQty'  }	
					,{name: 'EARLY_CNT'   			,text:'조퇴'		,type : 'uniQty'  }	
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
                	   read : 'gtt500skrvService.selectList'
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
		
 	Unilite.defineModel('${PKGNAME}MechanicModel', {
	    fields: [	 	
					 {name: 'DIV_CODE'    			,text:'사업장'		,type : 'string'  , comboType:'BOR120' }					
					,{name: 'TAG_IN_CNT'   			,text:'출근등록'	,type : 'uniQty'  }	
					,{name: 'TAG_OUT_CNT'   		,text:'퇴근등록'	,type : 'uniQty'  }	
					,{name: 'REMARK'   				,text:'비고'		,type : 'string'  }	
			]
	});

	var mechanicStore =  Unilite.createStore('${PKGNAME}MechanicStore',{
        model: '${PKGNAME}MechanicModel',
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
                	   read : 'gtt500skrvService.selectMechanicList'
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
	
	Unilite.defineModel('${PKGNAME}OfficerModel', {
	    fields: [	 {name: 'DIV_CODE'    			,text:'사업장'		,type : 'string'  , comboType:'BOR120' }					
					,{name: 'TAG_IN_CNT'   			,text:'출근등록'	,type : 'uniQty'  }	
					,{name: 'TAG_OUT_CNT'   		,text:'퇴근등록'	,type : 'uniQty'  }	
					,{name: 'REMARK'   				,text:'비고'		,type : 'string'  }	
			]
	});

	var officerStore =  Unilite.createStore('${PKGNAME}OfficerStore',{
        model: '${PKGNAME}OfficerModel',
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
                	   read : 'gtt500skrvService.selectOfficerList'
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
		
	var panelSearch = Unilite.createSearchPanel('${PKGNAME}searchForm',{
		title: '검색정보',
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
					},
					 {	    
						fieldLabel: '근무일',
						name: 'ATT_DATE',
						xtype: 'uniDateRangefield',
			            startFieldName: 'ATT_DATE_FR',
			            endFieldName: 'ATT_DATE_TO',	
			            startDate: UniDate.get('yesterday'),
			            endDate: UniDate.get('yesterday'),
			            width:320,
						allowBlank:false,
						height:22
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
					}
					]				
				}
				]

	});	//end panelSearch    
	
     var masterGrid = Unilite.createGrid('${PKGNAME}grid', {
        layout : 'fit',        
    	region:'center',
    	title:'운전직',
		uniOpt:{
			useRowNumberer: false,
        	expandLastColumn: false,
            useMultipleSorting: false
        },
        features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true},
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: true} ],
    	store: masterStore,
		 			
		columns:[
		  
		
			{dataIndex:'ROUTE_GROUP'		,width: 80},
			{dataIndex:'ROUTE_GROUP_NAME'	,width: 80, hidden:true},
			{dataIndex:'ROUTE_CODE'		,width: 45,
			 summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
		              	return Unilite.renderSummaryRow(summaryData, metaData, '합계', '총계');
	                    }
	        },{
	        	text:'승무내역(배차정보)',
	         	columns:[
		         	{dataIndex:'OPERATION_COUNT_CNT'			,width: 80	,summaryType:'sum'},
		         	{dataIndex:'RUN_OPERATION_CNT'			,width: 80	,summaryType:'sum'},
		         	{dataIndex:'NOTINSERVICE_CNT'			,width: 80	,summaryType:'sum'},
		         	{dataIndex:'ASSIGNED_DRIVER_CNT'	,width: 80	,summaryType:'sum'},
		         	{dataIndex:'NO_DRIVER_CNT'			,width: 80	,summaryType:'sum',
		         	 renderer: function(value, metaData, record) {
		             	var rv = value;
		             	if(value > 0)	{
		             		var rv = '<div style="color:red">'+value+'</div>';
		             	}
		             	return rv;
		             }
		            }
		         ]
	        },{
	        	text:'첫차운행내역(BIS정보)',
	         	columns:[
		         	{dataIndex:'DEPARTURE_CNT'			,width: 80	,summaryType:'sum'},
		         	{dataIndex:'LATE_DEPARTURE_CNT'		,width: 80	,summaryType:'sum',
		         	 renderer: function(value, metaData, record) {
		             	var rv = value;
		             	if(value > 0)	{
		             		var rv = '<div style="color:red">'+value+'</div>';
		             	}
		             	return rv;
		             }
          		  	},
		         	{dataIndex:'NOT_DEPARTURE_CNT'		,width: 80	,summaryType:'sum',
		         	 renderer: function(value, metaData, record) {
		             	var rv = value;
		             	if(value > 0)	{
		             		var rv = '<div style="color:red">'+value+'</div>';
		             	}
		             	return rv;
		             }
		            }
		         ]
	        },{
	        	text:'근태내역(출입정보)',
	         	columns:[
		         	{dataIndex:'TAG_IN_CNT'			,width: 80	,summaryType:'sum'},
		         	{dataIndex:'TAG_OUT_CNT'		,width: 80	,summaryType:'sum'},		         	
		         	{dataIndex:'NO_TAG_IN_CNT'		,width: 80	,summaryType:'sum',
		         	 renderer: function(value, metaData, record) {
		             	var rv = value;
		             	if(value > 0)	{
		             		var rv = '<div style="color:red">'+value+'</div>';
		             	}
		             	return rv;
		             }
		            },
		         	{dataIndex:'NO_TAG_OUT_CNT'		,width: 80	,summaryType:'sum',
		         	 renderer: function(value, metaData, record) {
		             	var rv = value;
		             	if(value > 0)	{
		             		var rv = '<div style="color:red">'+value+'</div>';
		             	}
		             	return rv;
		             }
		            },
		         	{dataIndex:'LATE_CNT'			,width: 80	,summaryType:'sum',
		         	 renderer: function(value, metaData, record) {
		             	var rv = value;
		             	if(value > 0)	{
		             		var rv = '<div style="color:blue">'+value+'</div>';
		             	}
		             	return rv;
		             }
		            },
		         	{dataIndex:'EARLY_CNT'			,width: 80	,summaryType:'sum',
		         	 renderer: function(value, metaData, record) {
		             	var rv = value;
		             	if(value > 0)	{
		             		var rv = '<div style="color:blue">'+value+'</div>';
		             	}
		             	return rv;
		             }
		            }
		         ]
	        }
		] ,
		listeners:{
			onGridDblClick: function(grid, record, cellIndex, colName)	{
						
				if(colName == 'OPERATION_COUNT_CNT' || colName == 'RUN_OPERATION_CNT'  ||  colName == 'NOTINSERVICE_CNT' ||
				   colName == 'ASSIGNED_DRIVER_CNT' || colName == 'NO_DRIVER_CNT' )	{	// 일일승무내역 링크
				   	console.log("ATT_DATE_FR", panelSearch.getValue('ATT_DATE_FR'),  panelSearch.getValue('ATT_DATE_TO'))
					if(UniDate.getDateStr(panelSearch.getValue('ATT_DATE_FR')) == UniDate.getDateStr(panelSearch.getValue('ATT_DATE_TO')))	{ //승무내역등록 링크
						var param = {
							'DIV_CODE': record.get('DIV_CODE'),
							'ROUTE_GROUP':record.get('ROUTE_GROUP'),
							'ROUTE_CODE':record.get('ROUTE_CODE'),
							'OPERATION_DATE': UniDate.getDateStr(panelSearch.getValue('ATT_DATE_FR'))
						}
						var rec = {data : {prgID : 'gop300ukrv'}};
							
						parent.openTab(rec, '/bus_operate/gop300ukrv.do', param);
					}
				}else if( colName == 'DEPARTURE_CNT' 		|| colName == 'LATE_DEPARTURE_CNT' ||  colName == 'NOT_DEPARTURE_CNT'   ){	//운행기록내역 링크
					var param = {
							'DIV_CODE': record.get('DIV_CODE'),
							'ROUTE_GROUP':record.get('ROUTE_GROUP'),
							'ROUTE_CODE':record.get('ROUTE_CODE'),
							'OPERATION_DATE_FR': UniDate.getDateStr(panelSearch.getValue('ATT_DATE_FR')),
							'OPERATION_DATE_TO': UniDate.getDateStr(panelSearch.getValue('ATT_DATE_TO')),
							'RUN_SEQ_TYPE': '1'
						}
						var rec = {data : {prgID : 'gop400skrv'}};
							
						parent.openTab(rec, '/bus_operate/gop400skrv.do', param);
				}else if(colName == 'TAG_IN_CNT' 	 || colName == 'NO_TAG_IN_CNT'  || colName == 'TAG_OUT_CNT' || 
				   		 colName == 'NO_TAG_OUT_CNT' || colName == 'LATE_CNT' 		|| colName == 'EARLY_CNT' ){	//일일근태녀역 링크
					var param = {
							'DIV_CODE': record.get('DIV_CODE'),
							'ROUTE_GROUP':record.get('ROUTE_GROUP'),
							'ROUTE_CODE':record.get('ROUTE_CODE'),
							'ATT_DATE_FR': UniDate.getDateStr(panelSearch.getValue('ATT_DATE_FR')),
							'ATT_DATE_TO': UniDate.getDateStr(panelSearch.getValue('ATT_DATE_TO'))
						}
						var rec = {data : {prgID : 'gtt100skrv'}};
							
						parent.openTab(rec, '/bus_operate/gtt100skrv.do', param);
				}
			}
		}
   });

   	 var mechanicGrid = Unilite.createGrid('${PKGNAME}mechanicGrid', {
   	 	title:'정비직',
    	region:'center',
		uniOpt:{
			useRowNumberer: false,
        	expandLastColumn: false,
            useMultipleSorting: false
        },
    	store: mechanicStore,
		columns:[		
			{dataIndex:'TAG_IN_CNT'		,width: 100},
			{dataIndex:'TAG_OUT_CNT'	,width: 100},
			{dataIndex:'REMARK'			,flex: 1}
			],
		listeners:{
			onGridDblClick: function(grid, record, cellIndex, colName)	{
					var param = {
						'DIV_CODE': record.get('DIV_CODE'),
						'ATT_DATE_FR': UniDate.getDateStr(panelSearch.getValue('ATT_DATE_FR')),
						'ATT_DATE_TO': UniDate.getDateStr(panelSearch.getValue('ATT_DATE_TO'))
					}
					var rec = {data : {prgID : 'gtt200ukrv'}};
						
					parent.openTab(rec, '/bus_operate/gtt200skrv.do', param);
					
			}
		}
	});
	 var officerGrid = Unilite.createGrid('${PKGNAME}officerGrid', {
	 	title:'내근직',
    	region:'east',
		uniOpt:{
			useRowNumberer: false,
        	expandLastColumn: false,
            useMultipleSorting: false
        },
    	store: officerStore,
		columns:[		
			{dataIndex:'TAG_IN_CNT'		,width: 100},
			{dataIndex:'TAG_OUT_CNT'	,width: 100},
			{dataIndex:'REMARK'			,flex: 1}
			],
		listeners:{
			onGridDblClick: function(grid, record, cellIndex, colName)	{
					var param = {
						'DIV_CODE': record.get('DIV_CODE'),
						'ATT_DATE_FR': UniDate.getDateStr(panelSearch.getValue('ATT_DATE_FR')),
						'ATT_DATE_TO': UniDate.getDateStr(panelSearch.getValue('ATT_DATE_TO'))
					}
					var rec = {data : {prgID : 'gtt300ukrv'}};
						
					parent.openTab(rec, '/bus_operate/gtt300skrv.do', param);
					
			}
		}
	});	
      Unilite.Main({
		borderItems:[
	 		  panelSearch
	 		 ,masterGrid
	 		 ,{
	 		 	weight:-100,
	 		 	height: 130,
	 			region: 'south',
            	layout:  'border',
            	border:false,
            	items:[mechanicGrid,officerGrid]
			}
	 		 
		],
		id  : '${PKGNAME}ukrApp',
		autoButtonControl : false,
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['print', 'newData'], false);
			UniAppManager.setToolbarButtons(['reset', 'excel' ], true);
		},
		
		onQueryButtonDown : function()	{
			masterStore.loadStoreRecords();
			mechanicStore.loadStoreRecords();
			officerStore.loadStoreRecords();
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