<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
//일일근태내역 조회
request.setAttribute("PKGNAME","Unilite_app_gcd200skrv");
%>
<t:appConfig pgmId="gcd200skrv"  >
	<t:ExtComboStore comboType="BOR120"/>							<!-- 사업장   	-->
	<t:ExtComboStore comboType="AU" comboCode="GO01"/>				<!-- 영업소   	-->
	<t:ExtComboStore items="${ROUTEGROUP_COMBO}" storeId="routeGroupStore" /> <!-- 노선그룹 -->
	<t:ExtComboStore items="${ROUTE_COMBO}" storeId="routeStore" /> 	<!-- 노선 -->	
	
</t:appConfig>
<script type="text/javascript">
function appMain() {
	
//	Ext.create('Ext.data.Store', {
//		storeId:"confirmYn",
//	    fields: ['text', 'value'],
//	    data : [
//	        {text:"마감",   value:"Y"},
//	        {text:"미마감", value:"N"}
//	    ]
//	});
     
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
	    		,{name: 'AVG_PER_SERVICE'       	,text:'대당평균'			,type : 'uniUnitPrice' }
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
				
		] ,
		listeners: {
			onGridDblClick:function(grid, record, cellIndex, colName) {
//				var params = {
//						'DIV_CODE': record.data['DIV_CODE'],
//						'ROUTE_GROUP' : record.data['ROUTE_GROUP'],
//						'ROUTE_CODE':record.data['ROUTE_CODE'],
//						'OPERATION_DATE':UniDate.getDateStr(record.data['OPERATION_DATE'])
//				}
//				var rec = {data : {prgID : 'gop300ukrv', 'text':''}};
//				
//				parent.openTab(rec, '/bus_operate/gop300ukrv.do', params);
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