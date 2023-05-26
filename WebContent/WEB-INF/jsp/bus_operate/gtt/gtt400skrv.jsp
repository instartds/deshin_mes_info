<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
//일일근태내역 조회
request.setAttribute("PKGNAME","Unilite_app_gtt400skrv");
%>
<t:appConfig pgmId="gtt400skrv"  >
	<t:ExtComboStore comboType="BOR120"/>								<!-- 사업장   	--> 
	<t:ExtComboStore items="${EMP_DIV}" storeId="empDiv" /> 	<!-- 사원그룹 -->
	
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
	
	var srchStore =  Ext.create('Ext.data.Store', {
			fields:	["value","text","option"],
			data:	[
				{'value':'01','text':'지각자'},
				{'value':'02','text':'미등록자'}
			],
			storeId:'${PKGNAME}srchStore'
		}
	);
	
	Unilite.defineModel('${PKGNAME}model', {
	    fields: [
					 {name: 'DIV_CODE'   			,text:'사업장'			,type : 'string'  ,comboType: 'BOR120' ,defaultValue: UserInfo.divCode} 
					,{name: 'EMP_DIV'    			,text:'사원그룹'		,type : 'string'  } 
					,{name: 'PERSON_NUMB'    		,text:'사원코드'		,type : 'string'  } 
					,{name: 'NAME'    				,text:'사원명'			,type : 'string'  } 
					,{name: 'OPERATION_DATE'    	,text:'운행일'			,type : 'uniDate' } 
					,{name: 'DUTY_FR_TIME'    		,text:'출근기준'	,type : 'string'  }
					,{name: 'IN_TIME'    			,text:'출근시각'		,type : 'string'  } 
					,{name: 'FP_IN_TIME'    		,text:'지문출근'		,type : 'string'  } 
					,{name: 'CARD_IN_TIME'    		,text:'카드출근'		,type : 'string'  } 
					
					,{name: 'DUTY_TO_TIME'    		,text:'퇴근기준'	,type : 'string'  }
					,{name: 'OUT_TIME'    			,text:'퇴근시각'		,type : 'string'  } 
					,{name: 'FP_OUT_TIME'    		,text:'지문퇴근'		,type : 'string'  } 
					,{name: 'CARD_OUT_TIME'    		,text:'카드퇴근'	,type : 'string'  }
					
					,{name: 'ROUTE_NUM'    			,text:'노선'			,type : 'string'  } 
					,{name: 'ROUTE_CODE'    		,text:'노선번호'		,type : 'string'  } 
					,{name: 'VEHICLE_NAME'    		,text:'차량'			,type : 'string'  } 
					,{name: 'VEHICLE_CODE'    		,text:'차량'			,type : 'string'  } 
					,{name: 'VEHICLE_REGIST_NO'    	,text:'차량등록번호'	,type : 'string'  } 
					
					,{name: 'OPERATION_COUNT'   	,text:'운행순번'		,type : 'int'  	  }		
					,{name: 'RUN_COUNT_CNT'    		,text:'운행수'			,type : 'uniQty'  }
					,{name: 'DATE_CNT'    			,text:'근무일수'		,type : 'uniQty'  }
					,{name: 'DIFF_FR'   			,text:'지각'			,type : 'int'  	  }	
					,{name: 'DIFF_TO'   			,text:'조퇴'			,type : 'int'  	  }	
					,{name: 'CONFIRM_YN'    		,text:'마감여부'		,type : 'string'   ,store: Ext.data.StoreManager.lookup('confirmYn')} 
					,{name: 'CARD_IN_TIME'    		,text:'카드출근'		,type : 'string'  }
					,{name: 'CARD_OUT_TIME'    		,text:'카드퇴근'		,type : 'string'  }
					,{name: 'FP_IN_TIME'    		,text:'지문출근'		,type : 'string'  }
					,{name: 'FP_OUT_TIME'    		,text:'지문퇴근'		,type : 'string'  }
				 					
					,{name: 'ORG_DRIVER_NAME'    	,text:'승무지시기사'	,type : 'string'  } 		
					,{name: 'REMARK'  				,text:'비고'			,type : 'string'  } 
					,{name: 'COMP_CODE'  			,text:'법인코드'		,type : 'string' ,defaultValue: UserInfo.compCode} 
					
//					,{name: 'DRIVER_CNT'   			,text:'기사수'			,type : 'uniQty'  	  }		
//					,{name: 'ROUTE_CNT'    			,text:'노선수'			,type : 'uniQty'  }
//					,{name: 'VEHICLE_CNT'    		,text:'차량수'			,type : 'uniQty'  }
//					,{name: 'OPERATION_DATE_CNT'   	,text:'운행일수'		,type : 'uniQty'  	  }	
//					,{name: 'LATE_CNT'   			,text:'지각수'			,type : 'uniQty'  	  }	
//					,{name: 'EARLY_CNT'   			,text:'조퇴수'			,type : 'uniQty'  	  }	
//					,{name: 'ASSIGNED_DRIVER_CNT'   ,text:'배정기사수'		,type : 'uniQty'  	  }						
//					,{name: 'NO_DRIVER_CNT'   		,text:'기사미배정'		,type : 'uniQty'  	  }	
//					,{name: 'NO_TAG_IN_CNT'   		,text:'출근미등록'		,type : 'uniQty'  	  }	
//					,{name: 'NO_TAG_OUT_CNT'   		,text:'퇴근미등록'		,type : 'uniQty'  	  }	
//					,{name: 'TAG_CNT'   			,text:'정상등록'		,type : 'uniQty'  	  }
//					,{name: 'NO_TAG_CNT'   			,text:'비정상등록'		,type : 'uniQty'  	  }	
//					,{name: 'TAG_IN_CNT'   			,text:'출근등록수'		,type : 'uniQty'  	  }	
//					,{name: 'TAG_OUT_CNT'   		,text:'퇴근등록수'		,type : 'uniQty'  	  }	
//					
//					,{name: 'DRIVER_RATE'   		,text:'기사배정율'		,type : 'uniPercent'  	  }	
//					,{name: 'TAG_RATE'   			,text:'정상등록율'		,type : 'uniPercent'  	  }	
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
                	   read : 'gtt400skrvService.selectList'
                }
            },
			loadStoreRecords: function()	{
				var searchForm = Ext.getCmp('${PKGNAME}searchForm');
				var param= searchForm.getValues();
				if(searchForm.isValid())	{
					this.load({params: param});
				}
			},
            groupField: 'OPERATION_DATE',
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
					,{name: 'ASSIGNED_DRIVER_CNT'   ,text:'배정기사수'		,type : 'uniQty'  	  }						
					,{name: 'NO_DRIVER_CNT'   		,text:'기사미배정'		,type : 'uniQty'  	  }	
					,{name: 'NO_TAG_IN_CNT'   		,text:'출근미등록'		,type : 'uniQty'  	  }	
					,{name: 'NO_TAG_OUT_CNT'   		,text:'퇴근미등록'		,type : 'uniQty'  	  }	
					,{name: 'TAG_CNT'   			,text:'정상등록'		,type : 'uniQty'  	  }
					,{name: 'NO_TAG_CNT'   			,text:'비정상등록'		,type : 'uniQty'  	  }	
					,{name: 'TAG_IN_CNT'   			,text:'출근등록수'		,type : 'uniQty'  	  }	
					,{name: 'TAG_OUT_CNT'   		,text:'퇴근등록수'		,type : 'uniQty'  	  }	
					
					,{name: 'DRIVER_RATE'   		,text:'기사배정율'		,type : 'uniPercent'  	  }	
					,{name: 'TAG_RATE'   			,text:'정상등록율'		,type : 'uniPercent'  	  }	
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
			'<table cellpadding="5" cellspacing="0" border="0" width="315"  align="center" style="border:1px solid #cccccc;margin-top:5px;">' ,
			'<tpl for=".">' ,
		    '<tr class="x-grid-row x-grid-with-row-lines">' ,
			'	<td style="text-align: right;"  class="bus_gray-label">정상근태</td>' ,
			'	<td style="text-align: right;"  class="bus_white-label" style="padding-right:10px;">{TAG_CNT} 명</td>',
			'	<td style="text-align: right;"  class="bus_gray-label">비정상근태</td>' ,
			'	<td style="text-align: right;"  class="bus_white-label" style="padding-right:10px;">{NO_TAG_CNT} 명</td>',
			'</tr>' ,
			'<tr class="x-grid-row x-grid-with-row-lines">' ,
			'	<td style="text-align: right;"  class="bus_gray-label">출근등록</td>' ,
			'	<td style="text-align: right;"  class="bus_white-label" style="padding-right:10px;">{TAG_IN_CNT} 명</td>',
			'	<td style="text-align: right;"  class="bus_gray-label">출근미등록</td>' ,
			'	<td style="text-align: right;"  class="bus_white-label" style="padding-right:10px;">{NO_TAG_IN_CNT} 명</td>',
			'</tr>' ,
			'<tr class="x-grid-row x-grid-with-row-lines">' ,
			'	<td style="text-align: right;"  class="bus_gray-label">퇴근등록</td>' ,
			'	<td style="text-align: right;"  class="bus_white-label" style="padding-right:10px;">{TAG_OUT_CNT} 명</td>',
			'	<td style="text-align: right;"  class="bus_gray-label">퇴근미등록</td>' ,
			'	<td style="text-align: right;"  class="bus_white-label" style="padding-right:10px;">{NO_TAG_OUT_CNT} 명</td>',
			'</tr>' ,
			'</tpl>' ,
			'</table><div>'
		],
		border:false,
		autoScroll:false,
		itemSelector: 'div.summary-source',
        store: summaryStore
	});

	var panelSearch = Unilite.createSearchPanel('${PKGNAME}searchForm',{
		title: '사원정보',
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
						fieldLabel: '사원코드',
						name: 'PERSON_NUMB'	
					},{	    
						fieldLabel: '사원명',
						name: 'NAME'	
					},
					 {	    
						fieldLabel: '근무일',
						name: 'ATT_DATE',
						xtype: 'uniDateRangefield',
			            startFieldName: 'ATT_DATE_FR',
			            endFieldName: 'ATT_DATE_TO',	
			            startDate: UniDate.today(),
			            endDate: UniDate.today(),
			            width:320,
						allowBlank:false,
						height:22
					},{	    
						fieldLabel: '사원구분',
						name: 'EMP_DIV'	,
						xtype: 'uniCombobox',
						store: Ext.data.StoreManager.lookup('empDiv')
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
//        dockedItems:{  
//        	xtype: 'toolbar',
//	        dock: 'top',
//	        items: ['->',
//        		{
//        			xtype:'button', 
//        			text:'운행일별',
//        			handler:function()	{
//        				masterStore.group('OPERATION_DATE');
//        				masterStore.sort({property : 'ROUTE_NUM', direction: 'ASC'}, {property: 'OPERATION_COUNT', direction: 'ASC'});
//        				masterGrid.getView().getFeature('masterGridSubTotal').toggleSummaryRow(true);
//        			}
//        		},{
//        			xtype:'button', 
//        			text:'기사별',
//        			handler:function()	{
//        				masterStore.group('DRIVER_NAME');
//        				masterStore.sort({property : 'OPERATION_DATE', direction: 'ASC'});
//        				masterGrid.getView().getFeature('masterGridSubTotal').toggleSummaryRow(true);
//        			}
//        		},{
//        			xtype:'button', 
//        			text:'노선별',
//        			handler:function()	{
//        				masterStore.group('ROUTE_NUM');
//        				masterStore.sort({property : 'OPERATION_DATE', direction: 'ASC'}, {property: 'OPERATION_COUNT', direction: 'ASC'});
//        				masterGrid.getView().getFeature('masterGridSubTotal').toggleSummaryRow(true);
//        			}
//        		},{
//        			xtype:'button', 
//        			text:'차량별',
//        			handler:function()	{
//        				masterStore.group('VEHICLE_NAME');
//        				masterStore.sort({property : 'OPERATION_DATE', direction: 'ASC'});
//        				masterGrid.getView().getFeature('masterGridSubTotal').toggleSummaryRow(true);
//        			}
//        		}
//        		
//        	]
//        },
        features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true},
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: true} ],
    	store: masterStore,
		columns:[
			{dataIndex:'DIV_CODE'			,width: 100, hidden:true},
			{dataIndex:'EMP_DIV'			,width: 100}, 
			{dataIndex:'OPERATION_DATE'		,width: 80 ,
			 summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
		              	return Unilite.renderSummaryRow(summaryData, metaData, '합계', '총계');
	                    }
	        },			
			{dataIndex:'PERSON_NUMB'		,width: 70},
			{dataIndex:'NAME'		,width: 70, summaryType:'count',
			 summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
              	var me = this;
                  	var rv = '<div align="right">'+value+'</div>';
                	return rv;
                }
	        },
	        {dataIndex:'DUTY_FR_TIME'			,width: 80		,align:'center'},
			{dataIndex:'IN_TIME'			,width: 80		,align:'center', 
			 summaryType:function(values)	{
			 	var sumData = 0;
			 	var lateData=0;
			 	
			 	Ext.each(values, function(value, index){
			 							sumData = Ext.isEmpty(value.get('IN_TIME')) ? sumData : sumData+1;
			 							lateData = value.get('DIFF_FR') < 0 ?  lateData+1 : lateData ;
						             	
			 						});			 	
			 	return lateData > 0 ? sumData+'<font color="red" title="지각">('+lateData+')</font>' : sumData;
			 },
			 summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
              	var me = this;
                  	var rv = '<div align="right">'+value+'</div>';
                	return rv;
                },
             renderer: function(value, metaData, record) {
             	var rv = value;
             	if(record.get('DIFF_FR') < 0)	{
             		var rv = '<div style="color:red">'+value+'</div>';
             	}
             	return rv;
             }
			},
			{dataIndex:'FP_IN_TIME'			,width: 80		,align:'center'},
			{dataIndex:'CARD_IN_TIME'			,width: 80		,align:'center'},
			{dataIndex:'DUTY_TO_TIME'			,width: 80		,align:'center'},
			{dataIndex:'OUT_TIME'			,width: 80		,align:'center', 
			 summaryType:function(values)	{
			 	var sumData = 0;
			 	var earlyData=0;
			 	
			 	Ext.each(values, function(value, index){
			 							sumData = Ext.isEmpty(value.get('OUT_TIME')) ? sumData : sumData+1;
			 							earlyData = value.get('DIFF_TO') < 0 ?  earlyData+1 : earlyData ;
			 						});			 	
			 	return earlyData > 0 ? sumData+'<font color="red" title="조퇴">('+earlyData+')</font>' : sumData;
			 },
			 summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
              	var me = this;
                  	var rv = '<div align="right">'+value+'</div>';
                	return rv;
             },
             renderer: function(value, metaData, record) {
             	var rv = value;
             	if(record.get('DIFF_TO') < 0)	{
             		var rv = '<div style="color:red">'+value+'</div>';
             	}
             	return rv;
             }
			},
			{dataIndex:'FP_OUT_TIME'			,width: 80		,align:'center'},
			{dataIndex:'CARD_OUT_TIME'			,width: 80		,align:'center'},
			{dataIndex:'DATE_CNT'			,width: 80		,summaryType:'sum'},
			{dataIndex:'ROUTE_NUM'		,width: 45},
	        {dataIndex:'VEHICLE_NAME'		,width: 50 },
			{dataIndex:'OPERATION_COUNT'	,width: 80		},
			
			{dataIndex:'VEHICLE_REGIST_NO'	,width: 100 },
			
			{dataIndex:'ORG_DRIVER_NAME'	,width: 90 },
			{dataIndex:'CONFIRM_YN'			,width: 80 },	
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