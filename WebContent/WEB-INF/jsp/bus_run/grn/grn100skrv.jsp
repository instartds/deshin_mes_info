<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
//첫차 막차 운행내역조회
request.setAttribute("PKGNAME","Unilite_app_grn100skrv");
%>
<t:appConfig pgmId="grn100skrv"  >
	<t:ExtComboStore comboType="BOR120"/>								<!-- 사업장   	--> 
	<t:ExtComboStore comboType="AU" comboCode="GO16"/>				<!-- 노선그룹   	--> 
	<t:ExtComboStore comboType="AU" comboCode="GO39"/>				<!-- 운행평가   	--> 
	<t:ExtComboStore items="${ROUTE_COMBO}" storeId="routeStore" /> 	<!-- 노선 -->
	
</t:appConfig>
<script type="text/javascript">
function appMain() {

	
	Unilite.defineModel('${PKGNAME}model', {
	    fields: [
					 {name: 'DIV_CODE'   			,text:'사업장'		,type : 'string'  ,comboType: 'BOR120' ,defaultValue: UserInfo.divCode} 
					,{name: 'ROUTE_GROUP'    		,text:'노선그룹코드',type : 'string'  ,comboType: 'AU', comboCode:'GO16'} 
					,{name: 'ROUTE_GROUP_NAME'    	,text:'노선그룹'	,type : 'string'  } 
					,{name: 'OPERATION_DATE'    	,text:'운행일'		,type : 'uniDate' } 
					,{name: 'ROUTE_NUM'    			,text:'노선'		,type : 'string'  } 
					,{name: 'ROUTE_CODE'    		,text:'노선번호'	,type : 'string'  } 
					
					//첫차
					,{name: 'F_VEHICLE_CODE'    	,text:'차량'		,type : 'string'  } 
					,{name: 'F_VEHICLE_NAME'    	,text:'차량'		,type : 'string'  } 
					,{name: 'F_VEHICLE_REGIST_NO'   ,text:'차량등록번호',type : 'string'  } 
					,{name: 'F_DRIVER_CODE'    		,text:'기사코드'	,type : 'string'  } 
					,{name: 'F_NAME'    			,text:'기사명'		,type : 'string'  } 
					
					//차고지 
					,{name: 'F_DEPARTURE_DATE'    	,text:'기준일자'	,type : 'string'  }
					,{name: 'F_DEPARTURE_TIME'    	,text:'기준시간'	,type : 'string'  ,convert:convertTime}
					,{name: 'F_RUN_DEPARTURE_DATE'  ,text:'출발일자'	,type : 'string'  }
					,{name: 'F_RUN_DEPARTURE_TIME'  ,text:'출발시간'	,type : 'string'  ,convert:convertTime}
					//정류장
					,{name: 'F_STOP_ARRIVAL_DATE'   ,text:'기준일자'	,type : 'string'  }
					,{name: 'F_STOP_ARRIVAL_TIME'   ,text:'기준시간'	,type : 'string'  ,convert:convertTime}
					,{name: 'F_STOP_RUN_ARRIVAL_DATE',text:'도착일자'	,type : 'string'  }
					,{name: 'F_STOP_RUN_ARRIVAL_TIME',text:'도착시간'	,type : 'string' ,convert:convertTime }
					
					,{name: 'F_RUN_EVAL_TYPE'   	,text:'운행평가'	,type : 'string'  	  ,comboType: 'AU', comboCode:'GO39'}		
					
					//막차
					,{name: 'L_VEHICLE_NAME'    	,text:'차량'		,type : 'string'  } 
					,{name: 'L_VEHICLE_CODE'    	,text:'차량'		,type : 'string'  } 
					,{name: 'L_VEHICLE_REGIST_NO'   ,text:'차량등록번호',type : 'string'  } 
					,{name: 'L_DRIVER_CODE'    		,text:'기사코드'	,type : 'string'  } 
					,{name: 'L_NAME'    			,text:'기사명'		,type : 'string'  } 
					
					//차고지 
					,{name: 'L_DEPARTURE_DATE'    	,text:'기준일자'	,type : 'string'  }
					,{name: 'L_DEPARTURE_TIME'    	,text:'기준시간'	,type : 'string'  ,convert:convertTime}
					,{name: 'L_RUN_DEPARTURE_DATE'  ,text:'출발일자'	,type : 'string'  }
					,{name: 'L_RUN_DEPARTURE_TIME'  ,text:'출발시간'	,type : 'string'  ,convert:convertTime}
					//정류장
					,{name: 'L_STOP_ARRIVAL_DATE'   ,text:'기준일자'	,type : 'string'  }
					,{name: 'L_STOP_ARRIVAL_TIME'   ,text:'기준시간'	,type : 'string'  ,convert:convertTime}
					,{name: 'L_STOP_RUN_ARRIVAL_DATE',text:'도착일자'	,type : 'string'  }
					,{name: 'L_STOP_RUN_ARRIVAL_TIME',text:'도착시간'	,type : 'string'  ,convert:convertTime}
					
					,{name: 'L_RUN_EVAL_TYPE'   	,text:'운행평가'	,type : 'string'  	 ,comboType: 'AU', comboCode:'GO39' }		
						
					,{name: 'REMARK'  				,text:'비고'		,type : 'string'  } 
					,{name: 'COMP_CODE'  			,text:'법인코드'	,type : 'string' ,defaultValue: UserInfo.compCode} 
			]
	});

	function convertTime( value, record )	{
		var r = '';
		if(value){
			value = value.replace(/:/g, "");			
			if(value.length == 6 ){
				r = value.substring(0,2)+":"+value.substring(2,4)+":"+value.substring(4,6);
			} else if(value.length == 4 ){
				r = value.substring(0,2)+":"+value.substring(2,4);
			}
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
                	   read : 'grn100skrvService.selectList'
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
		title: '첫차막차 운행내역 조회',
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
			            startDate: UniDate.get('today'),
			            endDate: UniDate.get('today'),
			            width:320,
						allowBlank:false,
						height:22
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
			{dataIndex:'ROUTE_GROUP_NAME'		,width: 80,
			 summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
		              	return Unilite.renderSummaryRow(summaryData, metaData, '합계', '총계');
	                    }
	        },
	        {dataIndex:'ROUTE_NUM'				,width: 45},
			{dataIndex:'OPERATION_DATE'			,width: 80 },
			
			{text:'첫차',
			 columns:[
			 	{dataIndex:'F_VEHICLE_REGIST_NO'		,width: 100 },
				{dataIndex:'F_NAME'				,width: 80 },
				{text:'차고지',
			 	 columns:[
				        {dataIndex:'F_DEPARTURE_TIME'		,width: 80 , align:'center'},
						{dataIndex:'F_RUN_DEPARTURE_TIME'	,width: 80 , align:'center'}
				 ]
				},
				{text:'정류장',
			 	 columns:[
				        {dataIndex:'F_STOP_ARRIVAL_TIME'	,width: 80 , align:'center'},
						{dataIndex:'F_STOP_RUN_ARRIVAL_TIME',width: 80 , align:'center'}
				 ]
				},
		        {dataIndex:'F_RUN_EVAL_TYPE'	,width: 80 ,
		         summaryType:function(values)	{
				 	var sumData = 0;
				 	var delayData=0;
				 	
				 	Ext.each(values, function(value, index){
				 							sumData = sumData+1;
				 							delayData = value.get('F_RUN_EVAL_TYPE') == '2' ?  delayData+1 : delayData ;
				 						});			 	
				 	return delayData > 0 ? sumData+'<font color="red">/'+delayData+'</font>' : sumData;
				  },
				  summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
	              	var me = this;
	                  	var rv = '<div align="right">'+value+'</div>';
	                	return rv;
	              }		        
		        }
			 ]
			},
	        {text:'막차',
			 columns:[
			 	{dataIndex:'L_VEHICLE_REGIST_NO'		,width: 100 },
				{dataIndex:'L_NAME'				,width: 80 },
				{text:'차고지',
			 	 columns:[
				        {dataIndex:'L_DEPARTURE_TIME'		,width: 80 , align:'center'},
						{dataIndex:'L_RUN_DEPARTURE_TIME'	,width: 80 , align:'center'}
				 ]
				},
				{text:'정류장',
			 	 columns:[
				        {dataIndex:'L_STOP_ARRIVAL_TIME'	,width: 80 , align:'center'},
						{dataIndex:'L_STOP_RUN_ARRIVAL_TIME',width: 80 , align:'center'}
				 ]
				},
		        {dataIndex:'L_RUN_EVAL_TYPE'	,width: 80 ,
		         summaryType:function(values)	{
				 	var sumData = 0;
				 	var delayData=0;
				 	
				 	Ext.each(values, function(value, index){
				 							sumData = sumData+1;
				 							delayData = value.get('L_RUN_EVAL_TYPE') == '2' ?  delayData+1 : delayData ;
				 						});			 	
				 	return delayData > 0 ? sumData+'<font color="red">/'+delayData+'</font>' : sumData;
				  },
				  summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
	              	var me = this;
	                  	var rv = '<div align="right">'+value+'</div>';
	                	return rv;
	              }		        
		        }
			 ]
			},
			{dataIndex:'REMARK'				,flex: 1}
		] 
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