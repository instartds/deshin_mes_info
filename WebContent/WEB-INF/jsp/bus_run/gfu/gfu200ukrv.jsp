<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
//연료충전 파일이체
request.setAttribute("PKGNAME","Unilite_app_gfu200ukrv");
%>
<t:appConfig pgmId="gfu200ukrv"  >
	<t:ExtComboStore comboType="BOR120"/>							<!-- 사업장   	-->  
	<t:ExtComboStore comboType="AU" comboCode="GO01"/>							<!-- 영업소   	--> 
	<t:ExtComboStore comboType="AU" comboCode="GO16"/>				<!-- 노선그룹  	-->	
	<t:ExtComboStore items="${ROUTE_COMBO}" storeId="routeStore" /> <!-- 노선 -->
</t:appConfig>
<script type="text/javascript">
var excelWindow;
function appMain() {
	Unilite.defineModel('${PKGNAME}Model', {
	    fields: [
			 {name: 'DIV_CODE'   			,text:'사업장'			,type : 'string'  ,comboType: 'BOR120' ,defaultValue: UserInfo.divCode } 
			,{name: 'SUPPLY_DATE'    		,text:'일자'			,type : 'uniDate' } 
			,{name: 'SUPPLY_TIME'    		,text:'시간'			,type : 'string'  ,convert:convertTime} 
			,{name: 'OFFICE_CODE'    		,text:'영업소'			,type : 'string'  ,comboType: 'AU', comboCode:'GO01'} 
			,{name: 'ROUTE_GROUP'    		,text:'노선그룹'		,type : 'string'  ,comboType: 'AU', comboCode:'GO16'} 
			,{name: 'ROUTE_NUM'    			,text:'노선'			,type : 'string'  } 
			,{name: 'ROUTE_CODE'    		,text:'노선'			,type : 'string'  ,store: Ext.data.StoreManager.lookup('routeStore')} 					
			,{name: 'VEHICLE_REGIST_NO'    	,text:'차량번호'		,type : 'string'  }
			,{name: 'VEHICLE_CODE'    		,text:'차량'			,type : 'string'  }			

			,{name: 'FILLING_TIME'    		,text:'충전시간'		,type : 'string'  }
			,{name: 'GAS_AMOUNT'    		,text:'수량'			,type : 'uniUnitPrice'} 
			,{name: 'CORRECTION_FACTOR'    	,text:'보정계수'		,type : 'uniUnitPrice'}
			,{name: 'AVG_USEAGE'    		,text:'평균열량'		,type : 'uniUnitPrice'} 
			,{name: 'UNIT_PRICE'    		,text:'단가'			,type : 'uniUnitPrice'}
			,{name: 'MONEY_AMOUNT'    		,text:'금액'			,type : 'uniUnitPrice'} 
			,{name: 'TAX'    				,text:'부가세'			,type : 'uniUnitPrice'}
			,{name: 'TOTAL_AMOUNT'    		,text:'합계'			,type : 'uniUnitPrice'} 
			,{name: 'REMARK'  				,text:'비고'			,type : 'string'} 
			,{name: 'COMP_CODE'  			,text:'법인코드'		,type : 'string'   ,defaultValue: UserInfo.compCode} 
		]
	});
	
	function convertTime(val, record )	{
		var r = val;
		if(val)	{
			value = val.replace(/:/g, "");
			
			if(value.length == 6 ){
				r = value.substring(0,2)+":"+value.substring(2,4)+":"+value.substring(4,6);
			} else if(value.length == 4 ){
				r = value.substring(0,2)+":"+value.substring(2,4);
			}
		}
		return r;
	}
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read 	: 'gfu200ukrvService.selectList',
			create  : 'gfu200ukrvService.insert',
			syncAll	: 'gfu200ukrvService.saveAll'
		}
	});
    var masterStore =  Unilite.createStore('${PKGNAME}Store',{
        model: '${PKGNAME}Model',
         autoLoad: false,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : true			// prev | next 버튼 사용
            },
            
            proxy: directProxy,
            saveStore : function()	{				
				var inValidRecs = this.getInvalidRecords();
				
				if(inValidRecs.length == 0 )	{
					var records = this.getNewRecords( ) 
					if(records.length > 1)	{
						var config = {
								params: [{'DIV_CODE':UserInfo.divCode, 'CALCULATE_DATE':UniDate.getDbDateStr(records[0].get('CALCULATE_DATE'))}]
						} 
						
						this.syncAllDirect(config);
					}
				}else {
					var grid = Ext.getCmp('${PKGNAME}Grid');
                	grid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			} ,
			loadStoreRecords: function()	{
				var searchForm = Ext.getCmp('${PKGNAME}SearchForm');
				var param= searchForm.getValues();
				if(searchForm.isValid())	{
					this.load({params: param});
				}
			}
		});
	
	var panelSearch = Unilite.createSearchPanel('${PKGNAME}SearchForm',{
		title: '연료충전',
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
		           		labelWidth:80
		           	},
			    	items:[{	    
						fieldLabel: '사업장',
						name: 'DIV_CODE',
						hidden:true,
						value:UserInfo.divCode
					},{	    
						fieldLabel: '일자',
						name: 'SUPPLY_DATE',
						xtype: 'uniDateRangefield',
			            startFieldName: 'SUPPLY_DATE_FR',
			            endFieldName: 'SUPPLY_DATE_TO',	
			            startDate: UniDate.get('startOfLastMonth'),
			            endDate: UniDate.get('endOfLastMonth'),
			            width:320,
						allowBlank:false
					},{	    
						fieldLabel: '노선그룹',
						name: 'ROUTE_GROUP',
						xtype:'uniCombobox',
						comboType:'AU',
						comboCode:'GO16',
						listeners: {
							change:function()	{
								panelSearch.setValue('ROUTE_CODE', '');
							}
						}
					}	    
					,{	    
						fieldLabel: '노선',
						name: 'ROUTE_CODE',
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
			 		,Unilite.popup('VEHICLE',
						 {
						 	itemId:'vehicle',
						 	extParam:{'DIV_CODE': UserInfo.divCode}						  
						 }
					)]				
				}]
		
	});	//end panelSearch    
	
     var masterGrid = Unilite.createGrid('${PKGNAME}Grid', {
        layout : 'fit',        
    	region:'center',
    	store: masterStore,
		uniOpt:{
			useRowNumberer: false,
        	expandLastColumn: false,
            useMultipleSorting: false
        },
        tbar: [
        	{
				itemId: 'excelBtn',
				text: '엑셀업로드',
	        	handler: function() {
		        		openExcelWindow();
		       	}
			}
		],
		features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true},
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: true}],
		columns:[
			{dataIndex:'DIV_CODE'			,width: 100},
			{dataIndex:'SUPPLY_DATE'		,width: 80},
			{dataIndex:'SUPPLY_TIME'		,width: 80},
			{dataIndex:'OFFICE_CODE'		,width: 80 },
			{dataIndex:'ROUTE_GROUP'		,width: 80,
				 summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
	              	return Unilite.renderSummaryRow(summaryData, metaData, '합계', '총계');
	            }
	        },			
			{dataIndex:'ROUTE_CODE'			,width: 80 },
			{dataIndex:'VEHICLE_REGIST_NO'	,width: 110},
			
			{dataIndex:'FILLING_TIME'		,width: 80},
			{dataIndex:'GAS_AMOUNT'			,width: 100, summaryType: 'sum'},
			{dataIndex:'CORRECTION_FACTOR'	,width: 80},
			{dataIndex:'AVG_USEAGE'			,width: 80},
			{dataIndex:'UNIT_PRICE'			,width: 80},
			{dataIndex:'MONEY_AMOUNT'		,width: 110, summaryType: 'sum'},
			{dataIndex:'TAX'				,width: 110, summaryType: 'sum'},
			{dataIndex:'TOTAL_AMOUNT'		,width: 120, summaryType: 'sum'},
			{dataIndex:'REMARK'				,flex: 1}
		] ,
        setExcelData: function(records) {
        	var me = this;
        	Ext.each(records, function(record, idx){
        		me.createRow(record.data);
        	})
        	console.log("store.getNewRecords( )", me.getStore().getNewRecords( ))
        }
   });
   
	Unilite.defineModel('excel.gfu200.sheet01', {
	    fields: [
			 {name: 'DIV_CODE'   			,text:'사업장'			,type : 'string'  ,comboType: 'BOR120' ,defaultValue: UserInfo.divCode } 
			,{name: '_EXCEL_ROWNUM'    		,text:'순번'			,type : 'int'  } 
			,{name: '_EXCEL_HAS_ERROR'    	,text:'에러메세지'		,type : 'string'  } 
			,{name: '_EXCEL_ERROR_MSG'    	,text:'에러메세지'		,type : 'string'  } 
			 
			,{name: 'SUPPLY_DATE'    		,text:'일자'			,type : 'uniDate' } 
			,{name: 'SUPPLY_TIME'    		,text:'시간'			,type : 'string'  } 
			,{name: 'OFFICE_CODE'    		,text:'영업소'			,type : 'string'  } 	
			,{name: 'ROUTE_GROUP'    		,text:'노선그룹'		,type : 'string'  ,comboType: 'AU', comboCode:'GO16'} 
			,{name: 'ROUTE_NUM'    			,text:'노선'			,type : 'string'  } 
			,{name: 'ROUTE_CODE'    		,text:'노선'			,type : 'string'  ,store: Ext.data.StoreManager.lookup('routeStore')} 		
			,{name: 'VEHICLE_CODE'    		,text:'차량'			,type : 'string'  }
			,{name: 'VEHICLE_REGIST_NO'    	,text:'차량'			,type : 'string'  }
			
			
			
			,{name: 'FILLING_TIME'    		,text:'충전시간'		,type : 'string'  }
			,{name: 'GAS_AMOUNT'    		,text:'수량'			,type : 'uniUnitPrice'} 
			,{name: 'CORRECTION_FACTOR'    	,text:'보정계수'		,type : 'uniUnitPrice'  }
			,{name: 'AVG_USEAGE'    		,text:'평균열량'		,type : 'uniUnitPrice'} 
			,{name: 'UNIT_PRICE'    		,text:'단가'			,type : 'uniUnitPrice'  }
			,{name: 'MONEY_AMOUNT'    		,text:'금액'			,type : 'uniUnitPrice'} 
			,{name: 'TAX'    				,text:'부가세'			,type : 'uniUnitPrice'  }
			,{name: 'TOTAL_AMOUNT'    		,text:'합계'			,type : 'uniUnitPrice'} 
			
			,{name: 'COMP_CODE'  			,text:'법인코드'		,type : 'string'   ,defaultValue: UserInfo.compCode} 
		]
	});
  function openExcelWindow() {
		
	        var me = this;
	        var vParam = {};
	        var appName = 'Unilite.com.excel.ExcelUploadWin';
	        if(!masterStore.isDirty())	{
				masterStore.loadData({});
	        }else {
	        	if(confirm('저장될 내용이 있습니다. '+'\n'+'저장하시겠습니까?')){
	        		UniAppManager.app.onSaveDataButtonDown();
	        		return;
	        	}else {
	        		masterStore.loadData({});
	        	}
	        }
            if(!excelWindow) {
            	excelWindow =  Ext.WindowMgr.get(appName);
                excelWindow = Ext.create( appName, {
                		modal: false,
                		excelConfigName: 'gfu200',
                		extParam: { 
                			'DIV_CODE': panelSearch.getValue('DIV_CODE')
                		},
                        grids: [
                        	 {
                        		itemId: 'gcdExcelGrid',
                        		title: '연료충전 파일이체',                        		
                        		useCheckbox: true,
                        		model : 'excel.gfu200.sheet01',
                        		readApi: 'gfu200ukrvService.selectExcelUploadSheet1',
                        		
                        		columns: [
                             		     	{dataIndex:'SUPPLY_DATE'		,width: 80},
											{dataIndex:'SUPPLY_TIME'		,width: 80 },
											{dataIndex:'ROUTE_CODE'			,width: 80 },
											{dataIndex:'ROUTE_NUM'			,width: 80},
			
											{dataIndex:'VEHICLE_REGIST_NO'	,width: 110},
											{dataIndex:'FILLING_TIME'		,width: 80},
											{dataIndex:'GAS_AMOUNT'			,width: 80},
											{dataIndex:'CORRECTION_FACTOR'	,width: 80},
											{dataIndex:'AVG_USEAGE'			,width: 80},
											{dataIndex:'UNIT_PRICE'			,width: 80},
											{dataIndex:'MONEY_AMOUNT'		,width: 80},
											{dataIndex:'TAX'				,width: 80},
											{dataIndex:'TOTAL_AMOUNT'		,width: 80}
									
                        		],
                        		listeners:{
                        			render: function( grid, eOpts)	{
                        				grid.getEl().mask();
                        				grid.getStore().on('load',function(c) {        		
							    		 	grid.getEl().unmask();
							        	}); 
                        			},
                        			beforeselect:function( model, record, index, eOpts )	{
                        				if(record.get('_EXCEL_HAS_ERROR') == 'Y') {
                        					return false;
                        				}
                        			}
                        		}
                        	}
                        ],
                        listeners: {
                            close: function() {
                                this.hide();
                            },
                            show:function()	{
                            	var grid = this.down('#gcdExcelGrid');
                            	grid.getStore().loadData({});
                            	if(Ext.isDefined(grid.getEl()))	{
                            		grid.getEl().mask();
                            	}
                            }
                        },
                        onApply:function()	{
                        	var grid = this.down('#gcdExcelGrid');
                			var records = grid.getSelectionModel().getSelection();       		
							masterGrid.setExcelData(records);
							grid.getStore().remove(records);
                		}
                 });
            }
            excelWindow.center();
            excelWindow.show();
	};
      Unilite.Main({
		borderItems:[
	 		  panelSearch
	 		 ,masterGrid
		],
		id  : 'gfu200ukrApp',
		autoButtonControl : false,
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['print', 'newData'],false);
			UniAppManager.setToolbarButtons(['reset', 'excel' ],true);
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