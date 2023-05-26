<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
//일일근태내역 조회
request.setAttribute("PKGNAME","Unilite_app_gop300skrv");
%>
<t:appConfig pgmId="gop300skrv"  >
	<t:ExtComboStore comboType="BOR120"/>								<!-- 사업장   	--> 
	<t:ExtComboStore comboType="AU" comboCode="GO16"/>				<!-- 노선그룹   	--> 
	<t:ExtComboStore comboType="AU" comboCode="GO35"/>				<!-- 노선그룹   	--> 
	<t:ExtComboStore comboType="AU" comboCode="A020"/>				<!-- 예/아니오   	--> 
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
					,{name: 'OPERATION_DATE'    	,text:'운행일'			,type : 'uniDate' } 
					,{name: 'ROUTE_GROUP'    		,text:'노선그룹'		,type : 'string'  ,comboType:'AU', comboCode:'GO16'} 
					,{name: 'ROUTE_GROUP_NAME'    	,text:'노선그룹'		,type : 'string'  } 					
					,{name: 'ROUTE_CODE'    		,text:'노선번호'		,type : 'string'  ,store: Ext.data.StoreManager.lookup('routeStore')} 
					,{name: 'ROUTE_NUM'    			,text:'노선번호'		,type : 'string'  }
					,{name: 'OPERATION_CNT'    		,text:'운행계획'		,type : 'uniQty'  }
					,{name: 'ACTURAL_SERVICE'    	,text:'운행'			,type : 'uniQty'  }
					,{name: 'NOTINSERVICE_CNT'   	,text:'운휴'			,type : 'uniQty'  }		
					,{name: 'OPERATION_RATE'   		,text:'운행율(%)'		,type : 'uniPercent'  	  }	
					,{name: 'ASSIGNED_DRIVER_CNT'   ,text:'기사배정'		,type : 'uniQty'  }	
					,{name: 'NONE_DRIVER_CNT'   	,text:'기사미배정'		,type : 'uniQty'  }	
					,{name: 'ASSIGNED_DRIVER_RATE'  ,text:'배정율(%)'		,type : 'uniPercent'  	  }	
					,{name: 'CONFIRM_YN'    		,text:'마감여부'		,type : 'string'   ,store: Ext.data.StoreManager.lookup('confirmYn')}
					
					,{name: 'REMARK'  				,text:'비고'			,type : 'string'  } 
					,{name: 'COMP_CODE'  			,text:'법인코드'		,type : 'string' ,defaultValue: UserInfo.compCode } 
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
                	   read : 'gop300skrvService.selectList'
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
							}
						}
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
						fieldLabel: '마감여부',
						name: 'CONFIRM_YN'	,
						xtype: 'uniCombobox',
						store: Ext.data.StoreManager.lookup('confirmYn')
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
        features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true},
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: true} ],
    	store: masterStore,
		columns:[
			{dataIndex:'DIV_CODE'				,width: 100, hidden:true},
			{dataIndex:'ROUTE_GROUP_NAME'		,width: 100 ,
			 summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
		              	return Unilite.renderSummaryRow(summaryData, metaData, '합계', '총계');
	                    }
	         },
	        {dataIndex:'ROUTE_CODE'				,width: 100 , hidden:true},
	        {dataIndex:'ROUTE_NUM'				,width: 100},	        
	        {dataIndex:'OPERATION_DATE'			,width: 100 },
			{dataIndex:'OPERATION_CNT'			,width: 100 ,summaryType:'sum'},
			{dataIndex:'ACTURAL_SERVICE'		,width: 100 ,summaryType:'sum'},
			{dataIndex:'NOTINSERVICE_CNT'		,width: 100,summaryType:'sum'},
			{dataIndex:'OPERATION_RATE'			,width: 100,  align:'right',
			 summaryType:function(values) {
			 	var sumOperation = 0;
			 	var sumActualService = 0;
			 	
			 	Ext.each(values, function(value, index){
			 							sumOperation = sumOperation + value.get('OPERATION_CNT');
			 							sumActualService = sumActualService +  value.get('ACTURAL_SERVICE');
			 						});			
			 						
			 	return sumOperation > 0 ? (sumActualService/sumOperation*100).toFixed(1) : 0.0;
			 }
			},
			{dataIndex:'ASSIGNED_DRIVER_CNT'	,width: 100,summaryType:'sum'},
			{dataIndex:'NONE_DRIVER_CNT'		,width: 100,summaryType:'sum'},		
			{dataIndex:'ASSIGNED_DRIVER_RATE'	,width: 80 ,  align:'right',
			 summaryType:function(values) {
			 	var sumAssigned = 0;
			 	var sumNoneAssigned = 0;
			 	
			 	Ext.each(values, function(value, index){
			 							sumAssigned = sumAssigned + value.get('ASSIGNED_DRIVER_CNT');
			 							sumNoneAssigned = sumNoneAssigned +  value.get('NONE_DRIVER_CNT');
			 						});			
			 						
			 	return (sumAssigned+sumNoneAssigned) > 0 ? (sumAssigned/(sumAssigned+sumNoneAssigned)*100).toFixed(1) : 0.0;
			 }},
			
			{dataIndex:'CONFIRM_YN'				,width: 80 },
			{dataIndex:'REMARK'					,flex: 1}
		] ,
		listeners: {
			onGridDblClick:function(grid, record, cellIndex, colName) {
				var params = {
						'DIV_CODE': record.data['DIV_CODE'],
						'ROUTE_GROUP' : record.data['ROUTE_GROUP'],
						'ROUTE_CODE':record.data['ROUTE_CODE'],
						'OPERATION_DATE':UniDate.getDateStr(record.data['OPERATION_DATE'])
				}
				var rec = {data : {prgID : 'gop300ukrv', 'text':''}};
				
				parent.openTab(rec, '/bus_operate/gop300ukrv.do', params);
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