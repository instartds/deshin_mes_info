<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
//전일집계조회
request.setAttribute("PKGNAME","Unilite_app_gpi900skrv");
%>
<t:appConfig pgmId="gpi900skrv"  >
	<t:ExtComboStore comboType="BOR120"/>							<!-- 사업장   	-->
	<t:ExtComboStore comboType="AU" comboCode="GO01"/>				<!-- 영업소   	-->	
</t:appConfig>
<script type="text/javascript">
function appMain() {
     
	Unilite.defineModel('${PKGNAME}model', {
	    fields: [{name: 'COMP_CODE'             	,text:'법인코드'			,type : 'string' }
	    		,{name: 'DIV_CODE'              	,text:'사업장'			,type : 'string' }
	    		,{name: 'OFFICE_CODE'           	,text:'영업소'			,type : 'string',comboType:'AU', comboCode:'GO01' }
	    		,{name: 'ROUTE_GROUP'           	,text:'노선그룹'			,type : 'string',store: Ext.data.StoreManager.lookup('routeGroupStore') }
	    		,{name: 'ROUTE_GROUP_NAME'          ,text:'노선그룹'			,type : 'string'}
	    		,{name: 'ROUTE_CODE'            	,text:'노선코드'			,type : 'string',store: Ext.data.StoreManager.lookup('routeStore') }
	    		,{name: 'ROUTE_NUM'             	,text:'노선번호'			,type : 'string' }
	    		,{name: 'TOTAL_OPERATION'       	,text:'총댓수'			,type : 'uniQty' }
	    		,{name: 'TOTAL_SERVICE'         	,text:'운행'				,type : 'uniQty' }
	    		,{name: 'TOTAL_NOTINSERVICE'    	,text:'운휴'				,type : 'uniQty' }
	    		,{name: 'DEPOSIT_CASH'          	,text:'현금금액'			,type : 'uniPrice' }
	    		,{name: 'TOTAL_COUNT'           	,text:'카드건수'			,type : 'uniQty' }
	    		,{name: 'TOTAL_AMOUNT'          	,text:'카드금액'			,type : 'uniPrice' }
	    		,{name: 'TOTAL_INCOME'    	    	,text:'수입합계'			,type : 'uniPrice' }
	    		,{name: 'AVG_PER_SERVICE'       	,text:'대당평균'			,type : 'uniPercent' }
	    		,{name: 'REMARK'                	,text:'비고'				,type : 'string' }	    		
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
                	   read : 'gcd200skrvService.selectList'
                }
            },
			loadStoreRecords: function()	{
				var searchForm = Ext.getCmp('${PKGNAME}searchForm');
				var param= searchForm.getValues();
				param.OPERATION_DATE_FR = param.ATT_DATE_FR;
				param.OPERATION_DATE_TO = param.ATT_DATE_TO;
				param.OFFICE_CODE = '';
				param.ROUTE_GROUP = '';
				param.ROUTE_CODE = '';
				if(searchForm.isValid())	{
					this.load({params: param});
				}
			},
            groupField: 'ROUTE_GROUP_NAME'
		});
	
	Unilite.defineModel('SummaryModel', {
		    fields: [	 {name: 'DIV_CODE'   			,text:'구분'		,type : 'string'  }
					    ,{name: 'DIV_NAME'   			,text:'구분'		,type : 'string'  }
					    ,{name: 'ROUTE_GROUP'   		,text:'노선그룹'	,type : 'string'  }
		    			,{name: 'ROUTE_GROUP_NAME'   	,text:'노선그룹'	,type : 'string'  }	
		    			,{name: 'OPERATION_COUNT_CNT'   ,text:'운행계획'	,type : 'uniQty'  }	
						,{name: 'RUN_OPERATION_CNT'   	,text:'운행'		,type : 'uniQty'  }	
						,{name: 'NOTINSERVICE_CNT'   	,text:'운휴'		,type : 'uniQty'  }
						
						,{name: 'ASSIGNED_DRIVER_CNT'   ,text:'기사배정'	,type : 'uniQty'  }						
						,{name: 'NO_DRIVER_CNT'   		,text:'기사미배정'	,type : 'uniQty'  }	
						,{name: 'TAG_IN_CNT'   			,text:'출근'	,type : 'uniQty'  }	
						,{name: 'NO_TAG_IN_CNT'   		,text:'출근미등록'	,type : 'uniQty'  }	
						,{name: 'TAG_OUT_CNT'   		,text:'퇴근'	,type : 'uniQty'  }	
						,{name: 'NO_TAG_OUT_CNT'   		,text:'퇴근미등록'	,type : 'uniQty'  }	
						,{name: 'LATE_CNT'   			,text:'지각'		,type : 'uniQty'  }	
						,{name: 'EARLY_CNT'   			,text:'조퇴'		,type : 'uniQty'  }	
						
						,{name: 'RUN_OPERATION_RATE'   		,text:'운행율(%)'			,type : 'uniQty'  , convert:converRate}	
						,{name: 'TOT_RUN_OPERATION_RATE'   	,text:'전체운행율(%)'		,type : 'uniQty'  , convert:converRate}	
						,{name: 'ASSIGNED_DRIVER_RATE'   	,text:'기사배정율(%)'		,type : 'uniQty'  , convert:converRate}	
						,{name: 'TOT_ASSIGNED_DRIVER_RATE'	,text:'전체기사배정율(%)'	,type : 'uniQty'  , convert:converRate}	
						,{name: 'TAG_IN_RATE'   			,text:'출근등록율(%)'		,type : 'uniQty'  , convert:converRate}	
						,{name: 'TOT_TAG_IN_RATE'   		,text:'전체출근등록율(%)'	,type : 'uniQty'  , convert:converRate}	
						,{name: 'TAG_OUT_RATE'   			,text:'퇴근등록율(%)'		,type : 'uniQty'  , convert:converRate}	
						,{name: 'TOT_TAG_OUT_RATE'   		,text:'전체퇴근등록율(%)'	,type : 'uniQty'  , convert:converRate}	
						       
			]
		});
		
		function converRate(value, record)	{
			return Math.floor(value);
		}
		var summaryStore =  Ext.create('Ext.data.Store', {
			storeId:'${PKGNAME}suwonStore',
	        model: 'SummaryModel',   
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
	            	   read : 'gtt100skrvService.summaryPortal'
	            }
	        },
			loadStoreRecords: function()	{
			    	var params = panelSearch.getValues();
			    	
			    	var grd = Ext.getCmp('${PKGNAME}SummaryGrid');
					grd.getEl().mask();
					
					this.load({params: params});
			},
			listeners:{
				load:function()	{
					summarySumStore.loadStoreRecords();
				}
			}
		});	
		
		var summarySumStore =  Ext.create('Ext.data.Store', {
			storeId:'${PKGNAME}SummarySumStore',
	        model: 'SummaryModel',   
	        autoLoad: true,
	        data:[
	        	{'OPERATION_COUNT_CNT':0, 'RUN_OPERATION_CNT':0, 'ASSIGNED_DRIVER_CNT':0, 'NO_DRIVER_CNT':0,
	        	 'TAG_IN_CNT':0, 'NO_TAG_IN_CNT':0, 'TAG_OUT_CNT':0, 'NO_TAG_OUT_CNT':0}
	        ],
			loadStoreRecords: function()	{					
					var store = Ext.data.StoreManager.lookup("${PKGNAME}suwonStore");
					var arr = new Array();
					var rec = [];
					if(store.getCount() > 0)	{
						rec = store.getAt(0);
					}
					arr.push({	  'DIV_NAME':store.max("DIV_NAME")
								, 'OPERATION_COUNT_CNT':store.sum("OPERATION_COUNT_CNT")								
								, 'RUN_OPERATION_CNT':store.sum("RUN_OPERATION_CNT")
								, 'NOTINSERVICE_CNT':store.sum("NOTINSERVICE_CNT")
								, 'ASSIGNED_DRIVER_CNT':store.sum("ASSIGNED_DRIVER_CNT")
								, 'TAG_IN_CNT':store.sum("TAG_IN_CNT")
								, 'TAG_OUT_CNT':store.sum("TAG_OUT_CNT")
								, 'NO_TAG_IN_CNT':store.sum("NO_TAG_IN_CNT")
								, 'NO_TAG_OUT_CNT':store.sum("NO_TAG_OUT_CNT")	
								, 'TOT_RUN_OPERATION_RATE':rec.get("TOT_RUN_OPERATION_RATE")	
								, 'TOT_ASSIGNED_DRIVER_RATE':rec.get("TOT_ASSIGNED_DRIVER_RATE")
								, 'TOT_TAG_IN_RATE':rec.get("TOT_TAG_IN_RATE")
								, 'TOT_TAG_OUT_RATE':rec.get("TOT_TAG_OUT_RATE")
								});				
								
								
					this.loadData(arr);
					var grd = Ext.getCmp('${PKGNAME}SummaryGrid');
					grd.getEl().unmask();
					
			}
		});	
	var panelSearch = Unilite.createSearchPanel('${PKGNAME}searchForm',{
		title: '전일 집계 정보',
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
						fieldLabel: '조회일',
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
						fieldLabel: '사업장',
						name: 'DIV_CODE',
						xtype:'uniCombobox',
						comboType:'BOR120',
						value: UserInfo.divCode,
						hidden:true
					}]				
				}
				]

	});	//end panelSearch    
		var summaryGrid = Unilite.createGrid('${PKGNAME}SummaryGrid', {
			region:'north',
			title:'전체 운행집계',
			uniOpt:{
				//column option--------------------------------------------------
				expandLastColumn: false,
				useRowNumberer: false,		//번호 컬럼 사용 여부	
				onLoadSelectFirst: false,
				state: {
					useState: false,			//그리드 설정 버튼 사용 여부
					useStateList: false		//그리드 설정 목록 사용 여부
				},
				excel: {
					useExcel: false			//엑셀 다운로드 사용 여부
				}
			},
			flex:.3,
			border:false,
	    	store: summarySumStore,
	    	disableSelection :true,
			columns:[
			    { dataIndex:'DIV_NAME'						,flex: .07 },				
				{ dataIndex:'OPERATION_COUNT_CNT'			,flex: .07 },
				{ dataIndex:'RUN_OPERATION_CNT'				,flex: .07 },
				{ dataIndex:'NOTINSERVICE_CNT'				,flex: .07 },
				{ dataIndex:'TOT_RUN_OPERATION_RATE'		,flex: .07 },
				
				{ dataIndex:'ASSIGNED_DRIVER_CNT'			,flex: .07 },
				{ dataIndex:'NO_DRIVER_CNT'					,flex: .07 },
				{ dataIndex:'TOT_ASSIGNED_DRIVER_RATE'		,flex: .07 },
				
				{ dataIndex:'TAG_IN_CNT'					,flex: .07 },
				{ dataIndex:'NO_TAG_IN_CNT'					,flex: .07 },
				{ dataIndex:'TOT_TAG_IN_RATE'				,flex: .07 },
				
				{ dataIndex:'TAG_OUT_CNT'					,flex: .07 },
				{ dataIndex:'NO_TAG_OUT_CNT'				,flex: .07 },
				{ dataIndex:'TOT_TAG_OUT_RATE'				,flex: .07 }
				
			]
		});
	  var groupGrid = Unilite.createGrid('pt3Grid', {
	 		region:'center',
	 		title:'반별 운행집계',
			uniOpt:{
				//column option--------------------------------------------------
				expandLastColumn: false,
				useRowNumberer: false,		//번호 컬럼 사용 여부	
				onLoadSelectFirst: false,
				state: {
					useState: false,			//그리드 설정 버튼 사용 여부
					useStateList: false		//그리드 설정 목록 사용 여부
				},
				excel: {
					useExcel: false			//엑셀 다운로드 사용 여부
				}
			},
	        
			disableSelection :true,
			flex:.7,
			border:false,
	    	store: summaryStore,
			columns:[
				{ dataIndex:'ROUTE_GROUP_NAME'		,flex: .07 , align:'center'},
				{ dataIndex:'OPERATION_COUNT_CNT'	,flex: .07 },
				{ dataIndex:'RUN_OPERATION_CNT'		,flex: .07 },
				{ dataIndex:'NOTINSERVICE_CNT'		,flex: .07 },
				{ dataIndex:'RUN_OPERATION_RATE'	,flex: .07 },
				
				{ dataIndex:'ASSIGNED_DRIVER_CNT'	,flex: .07 },
				{ dataIndex:'NO_DRIVER_CNT'			,flex: .07 },
				{ dataIndex:'ASSIGNED_DRIVER_RATE'	,flex: .07 },
				
				{ dataIndex:'TAG_IN_CNT'			,flex: .07 },
				{ dataIndex:'NO_TAG_IN_CNT'			,flex: .07 },
				{ dataIndex:'TAG_IN_RATE'			,flex: .07 },
				
				{ dataIndex:'TAG_OUT_CNT'			,flex: .07 },
				{ dataIndex:'NO_TAG_OUT_CNT'		,flex: .07 },
				{ dataIndex:'TAG_OUT_RATE'			,flex: .07 }
				
			]
		});
     var masterGrid = Unilite.createGrid('${PKGNAME}grid', {        
    	region:'center',
    	title:'수입금집계',
		uniOpt:{
				//column option--------------------------------------------------
				expandLastColumn: false,
				useRowNumberer: false,		//번호 컬럼 사용 여부	
				onLoadSelectFirst: false,
				state: {
					useState: false,			//그리드 설정 버튼 사용 여부
					useStateList: false		//그리드 설정 목록 사용 여부
				},
				excel: {
					useExcel: false			//엑셀 다운로드 사용 여부
				}
			},
        disableSelection :true,
		flex:1,
		border:false,
        features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true},
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: true} ],
    	store: masterStore,
		columns:[{dataIndex: 'COMP_CODE'             	,width: 100, hidden: true}
				,{dataIndex: 'DIV_CODE'              	,width: 100, hidden: true}
				,{dataIndex: 'OFFICE_CODE'           	,width: 100,
					 summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
		              	return Unilite.renderSummaryRow(summaryData, metaData, '합계', '총계');
                    }}
				,{dataIndex: 'ROUTE_GROUP'           	,width: 100, hidden: true}
				,{dataIndex: 'ROUTE_GROUP_NAME'         ,width: 100}				
				,{dataIndex: 'ROUTE_CODE'            	,width: 100}
				,{dataIndex: 'ROUTE_NUM'             	,width: 100}
				,{dataIndex: 'TOTAL_OPERATION'       	,width: 66, summaryType: 'sum'}
				,{dataIndex: 'TOTAL_SERVICE'         	,width: 66, summaryType: 'sum'}
				,{dataIndex: 'TOTAL_NOTINSERVICE'    	,width: 66, summaryType: 'sum'}
				,{dataIndex: 'DEPOSIT_CASH'          	,width: 100, summaryType: 'sum'}
				,{dataIndex: 'TOTAL_COUNT'           	,width: 80, summaryType: 'sum'}
				,{dataIndex: 'TOTAL_AMOUNT'          	,width: 100, summaryType: 'sum'}
				,{dataIndex: 'TOTAL_INCOME'    	    	,width: 100, summaryType: 'sum'}
				,{dataIndex: 'AVG_PER_SERVICE'       	,width: 100, 
				  summaryType:function(values)	{
				 	var sumTotal = 0;
				 	var sumOperation=0;
				 	
				 	Ext.each(values, function(value, index){
						sumTotal = sumTotal+value.get('TOTAL_INCOME');
						sumOperation = sumOperation+value.get('TOTAL_SERVICE');
					});	
					
				 	return sumOperation == 0 ? 0 : sumTotal/sumOperation;
				 }
			  	}
				,{dataIndex: 'REMARK'                	,flex: 1}
				
		] 
   });

      Unilite.Main({
		borderItems:[
	 		  panelSearch
	 		 ,{
	 		 	region:'north',
	 		 	weight:-100,
	 		 	height:275,
	 		 	xtype:'container',
	 		 	layout:'border',
		 		items:[
		 		 	summaryGrid
		 		 	,groupGrid
		 		]
	 		 }
	 		 ,masterGrid
		],
		id  : '${PKGNAME}ukrApp',
		autoButtonControl : false,
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['print', 'newData'], false);
			UniAppManager.setToolbarButtons(['reset', 'excel' ], true);
			
		},
		
		onQueryButtonDown : function()	{
			summaryStore.loadStoreRecords();
			masterStore.loadStoreRecords();
		},
		onPrevDataButtonDown:  function()	{
			masterGrid.selectPriorRow();
		},
		onNextDataButtonDown:  function()	{
			masterGrid.selectNextRow();
		},	
		onNewDataButtonDown:  function()	{
//			masterGrid.createRow();
		},	
		
		onSaveDataButtonDown: function (config) {
			masterStore.saveStore();
					
		},
		onDeleteDataButtonDown : function()	{
//			if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
//				masterGrid.deleteSelectedRow();				
//			}
		},
		onResetButtonDown:function() {
			var me = this;
			panelSearch.reset();
			masterGrid.reset();
			this.fnInitBinding();
//			UniAppManager.setToolbarButtons('save',false);
		},
		onSaveAsExcelButtonDown: function() {
			 masterGrid.downloadExcelXml();
		}
	});

	
	
}; // main
  
</script>