<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
//기간별 수입금 집계(평균)
request.setAttribute("PKGNAME","Unilite_app_gcd500skrv");
%>
<t:appConfig pgmId="gcd500skrv"  >
	<t:ExtComboStore comboType="BOR120"/>							<!-- 사업장   	-->
	<t:ExtComboStore comboType="AU" comboCode="GO01"/>				<!-- 영업소   	-->
	<t:ExtComboStore items="${ROUTEGROUP_COMBO}" storeId="routeGroupStore" /> <!-- 노선그룹 -->
	<t:ExtComboStore items="${ROUTE_COMBO}" storeId="routeStore" /> 	<!-- 노선 -->	
	
</t:appConfig>
<script type="text/javascript">
function appMain() {
	
     
	Unilite.defineModel('${PKGNAME}model', {
	    fields: [{name: 'COMP_CODE'             		,text:'법인코드'			,type : 'string' }
	    		,{name: 'DIV_CODE'              		,text:'사업장'			,type : 'string' }
	    		,{name: 'OFFICE_CODE'           		,text:'영업소'			,type : 'string',comboType:'AU', comboCode:'GO01' }
	    		,{name: 'ROUTE_GROUP'           		,text:'노선그룹'			,type : 'string',store: Ext.data.StoreManager.lookup('routeGroupStore') }
	    		,{name: 'ROUTE_GROUP_NAME'          	,text:'노선그룹'			,type : 'string'}
	    		,{name: 'ROUTE_CODE'            		,text:'노선코드'			,type : 'string',store: Ext.data.StoreManager.lookup('routeStore') }
	    		,{name: 'ROUTE_NUM'             		,text:'노선번호'			,type : 'string' }
	    		
	    		,{name: 'TOTAL_OPERATION'       		,text:'총댓수'			,type : 'uniQty' }
	    		,{name: 'HOLIDAY_TOTAL_OPERATION'       ,text:'총댓수'			,type : 'uniQty' }
	    		,{name: 'WORKING_TOTAL_OPERATION'       ,text:'총댓수'			,type : 'uniQty' }
	    		
	    		,{name: 'TOTAL_SERVICE'         		,text:'운행'				,type : 'uniQty' }
	    		,{name: 'HOLIDAY_TOTAL_SERVICE'        ,text:'운행'				,type : 'uniQty' }
	    		,{name: 'WORKING_TOTAL_SERVICE'         ,text:'운행'				,type : 'uniQty' }
	    		
	    		,{name: 'TOTAL_NOTINSERVICE'    		,text:'운휴'				,type : 'uniQty' }
	    		
	    		,{name: 'DAY_CNT'         				,text:'운행일'				,type : 'uniQty' }
	    		,{name: 'HOLIDAY_DAY_CNT'         		,text:'운행일'				,type : 'uniQty' }
	    		,{name: 'WORKING_DAY_CNT'         		,text:'운행일'				,type : 'uniQty' }
	    		
	    		,{name: 'AVG_DAY_OPERATION'         	,text:'평균댓수'				,type : 'uniQty' }
	    		,{name: 'HOLIDAY_AAVG_DAY_OPERATION'    ,text:'평균댓수'				,type : 'uniQty' }
	    		,{name: 'WORKING_AVG_DAY_OPERATION'     ,text:'평균댓수'				,type : 'uniQty' }
	    			
	    		,{name: 'TOTAL_INCOME'    	    		,text:'수입합계'			,type : 'uniPrice' }
	    		,{name: 'HOLIDAY_TOTAL_INCOME'    	    ,text:'수입합계'			,type : 'uniPrice' }
	    		,{name: 'WORKING_TOTAL_INCOME'    	    ,text:'수입합계'			,type : 'uniPrice' }
	    		
	    		,{name: 'AVG_PER_SERVICE'       		,text:'대당평균'			,type : 'uniPercent' }
	    		,{name: 'HOLIDAY_AVG_PER_SERVICE'       ,text:'대당평균'			,type : 'uniPercent' }
	    		,{name: 'WORKING_AVG_PER_SERVICE'       ,text:'대당평균'			,type : 'uniPercent' }
	    		
	    		,{name: 'REMARK'                		,text:'비고'				,type : 'string' }	    		
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
                	   read : 'gcd500skrvService.selectList'
                }
            },
			loadStoreRecords: function()	{
				var searchForm = Ext.getCmp('${PKGNAME}searchForm');
				var param= searchForm.getValues();
				if(searchForm.isValid())	{
					this.load({params: param});
				}
			},
            groupField: 'ROUTE_GROUP_NAME'
		});
	
	var panelSearch = Unilite.createSearchPanel('${PKGNAME}searchForm',{
		title: '수입금정보',
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
						fieldLabel: '영업소',
						name: 'OFFICE_CODE',
						xtype: 'uniCombobox',
						comboType:'AU', 
						comboCode:'GO01'
					},{	    
						fieldLabel: '노선그룹',
						name: 'ROUTE_GROUP'	,
						xtype: 'uniCombobox',
						store: Ext.data.StoreManager.lookup('routeGroupStore')
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
						xtype: 'uniDateRangefield',
			            startFieldName: 'OPERATION_DATE_FR',
			            endFieldName: 'OPERATION_DATE_TO',	
			            width:320,
						allowBlank:false
					}]				
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
        features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true},
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: true} ],
    	store: masterStore,
		columns:[{dataIndex: 'COMP_CODE'             	,width: 100, hidden: true}
				,{dataIndex: 'DIV_CODE'              	,width: 100, hidden: true}
				,{dataIndex: 'OFFICE_CODE'           	,width: 80, locked:true,
					 summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
		              	return Unilite.renderSummaryRow(summaryData, metaData, '합계', '총계');
                    }}
				,{dataIndex: 'ROUTE_GROUP'           	,width: 80, hidden: true}
				,{dataIndex: 'ROUTE_GROUP_NAME'         ,width: 80, locked:true}				
				,{dataIndex: 'ROUTE_CODE'            	,width: 80, locked:true}
				,{dataIndex: 'ROUTE_NUM'             	,width: 80, locked:true}
				,{dataIndex: 'TOTAL_OPERATION'       	,width: 45, summaryType: 'sum', locked:true}
				,{dataIndex: 'TOTAL_SERVICE'         	,width: 45, summaryType: 'sum', locked:true}
				,{dataIndex: 'TOTAL_NOTINSERVICE'    	,width: 45, summaryType: 'sum', locked:true}
				,{dataIndex: 'DAY_CNT'    				,width: 45, summaryType: 'sum', locked:true}
				,{dataIndex: 'TOTAL_INCOME'    	    	,width: 100, summaryType: 'sum', locked:true}
				,{dataIndex: 'AVG_DAY_OPERATION'    	,width: 80, summaryType: 'sum', locked:true}
				,{dataIndex: 'AVG_PER_SERVICE'       	,width: 100, locked:true, 
				  summaryType:function(values)	{
				 	var sumTotal = 0;
				 	var sumOperation=0;
				 	
				 	Ext.each(values, function(value, index){
						sumTotal = sumTotal+value.get('TOTAL_INCOME');
						sumOperation = sumOperation+value.get('TOTAL_SERVICE');
					});	
					
				 	return sumOperation == 0 ? 0 : sumTotal/sumOperation;
				 }
			  	},
			  	{text:'평일',
			  		columns:[
			  			 {dataIndex: 'WORKING_DAY_CNT'    				,width: 45, summaryType: 'sum'}
						,{dataIndex: 'WORKING_TOTAL_INCOME'    	    	,width: 100, summaryType: 'sum'}
						,{dataIndex: 'WORKING_TOTAL_SERVICE'    				,width: 45, summaryType: 'sum'}
						,{dataIndex: 'WORKING_AVG_PER_SERVICE'       	,width: 80, 
						  summaryType:function(values)	{
						 	var sumTotal = 0;
						 	var sumOperation=0;
						 	
						 	Ext.each(values, function(value, index){
								sumTotal = sumTotal+value.get('WORKING_TOTAL_INCOME');
								sumOperation = sumOperation+value.get('WORKING_TOTAL_SERVICE');
							});	
							
						 	return sumOperation == 0 ? 0 : sumTotal/sumOperation;
						 }
						}
			  	
			  		]
			  	 },
			  	{text:'공휴일',
			  		columns:[
			  			 {dataIndex: 'HOLIDAY_DAY_CNT'    				,width: 45, summaryType: 'sum'}
						,{dataIndex: 'HOLIDAY_TOTAL_INCOME'    	    	,width: 100, summaryType: 'sum'}
						,{dataIndex: 'HOLIDAY_TOTAL_SERVICE'    				,width: 45, summaryType: 'sum'}
						,{dataIndex: 'HOLIDAY_AVG_PER_SERVICE'       	,width: 80, 
						  summaryType:function(values)	{
						 	var sumTotal = 0;
						 	var sumOperation=0;
						 	
						 	Ext.each(values, function(value, index){
								sumTotal = sumTotal+value.get('HOLIDAY_TOTAL_INCOME');
								sumOperation = sumOperation+value.get('HOLIDAY_TOTAL_SERVICE');
							});	
							
						 	return sumOperation == 0 ? 0 : sumTotal/sumOperation;
						 }
						}
			  		]
			  	}
				,{dataIndex: 'REMARK'                	,flex: 1}
				
		] 
   });

      Unilite.Main({
		borderItems:[
	 		  panelSearch
	 		 ,masterGrid
		],
		id  : '${PKGNAME}ukrApp',
		autoButtonControl : false,
		fnInitBinding : function() {
			panelSearch.setValue('OPERATION_DATE_FR',new Date());
			panelSearch.setValue('OPERATION_DATE_TO',new Date());
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