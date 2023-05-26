<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
//카드수입금 파일등록(사용일)
request.setAttribute("PKGNAME","Unilite_app_gcd100ukrv");
%>
<t:appConfig pgmId="gcd100ukrv"  >
	<t:ExtComboStore comboType="BOR120"/>							<!-- 사업장   	-->  
	<t:ExtComboStore comboType="AU" comboCode="GO01"/>							<!-- 영업소   	--> 
</t:appConfig>
<script type="text/javascript">
var excelWindow;
function appMain() {
	Unilite.defineModel('${PKGNAME}Model', {
		//--사업장	운행일	노선그룹	노선	차량	기사코드	기사명	현금
	    fields: [
			 {name: 'DIV_CODE'   			,text:'사업장'			,type : 'string'  ,comboType: 'BOR120' ,defaultValue: UserInfo.divCode } 
			,{name: 'PAYMENT_DATE'    		,text:'사용일자'		,type : 'uniDate' } 
			,{name: 'COMPANY_NAME'    		,text:'교통사업자명'	,type : 'string'  } 
			,{name: 'OFFICE_CODE'    		,text:'영업소'	,type : 'string'  ,comboType: 'AU', comboCode:'GO01'} 
			
			,{name: 'DRIVER_CODE'    		,text:'기사코드'		,type : 'string'  } 
			,{name: 'DRIVER_NAME'    		,text:'기사명'			,type : 'string'  } 
			,{name: 'ROUTE_CODE'    		,text:'노선'			,type : 'string'  ,store: Ext.data.StoreManager.lookup('routeStore')} 					
			,{name: 'VEHICLE_REGIST_NO'    	,text:'차량번호'		,type : 'string'  }
			,{name: 'VEHICLE_CODE'    		,text:'차량'			,type : 'string'  }			
			
			,{name: 'ADULT_COUNT'    		,text:'일반건수'		,type : 'uniQty'  }
			,{name: 'ADULT_AMOUNT'    		,text:'일반금액'		,type : 'uniPrice'} 
			,{name: 'STUDENT_COUNT'    		,text:'학생건수'		,type : 'uniQty'  }
			,{name: 'STUDENT_AMOUNT'    	,text:'학생금액'		,type : 'uniPrice'} 
			,{name: 'CHILD_COUNT'    		,text:'어린이건수'		,type : 'uniQty'  }
			,{name: 'CHILD_AMOUNT'    		,text:'어린이금액'		,type : 'uniPrice'} 
			,{name: 'TOTAL_COUNT'    		,text:'총건수합계'		,type : 'uniQty'  }
			,{name: 'TOTAL_AMOUNT'    		,text:'총금액 합계'		,type : 'uniPrice'}
			,{name: 'REMARK'  				,text:'비고'			,type : 'string'} 
			,{name: 'COMP_CODE'  			,text:'법인코드'		,type : 'string'   ,defaultValue: UserInfo.compCode} 
		]
	});
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read 	: 'gcd100ukrvService.selectList',
			create  : 'gcd100ukrvService.insert',
			syncAll	: 'gcd100ukrvService.saveAll'
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
								params: [{'DIV_CODE':UserInfo.divCode, 'PAYMENT_DATE':UniDate.getDbDateStr(records[0].get('PAYMENT_DATE'))}]
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
		title: '카드수입금',
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
						fieldLabel: '사용일',
						name: 'PAYMENT_DATE',
						xtype: 'uniDatefield',
						value: UniDate.today(),
						allowBlank:false
					},	    
					Unilite.popup('DRIVER',
				 	 {
				 	 	fieldLabel:'운전자',
				 		itemId:'driver',
				 		extParam:{'DIV_CODE': UserInfo.divCode},
				 		useLike:true,
				 		validateBlank:false
				 	 }
			 		)
			 		,{	    
						fieldLabel: '차량명',
						name: 'VEHICLE_NAME'
						
					}]				
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
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: true} ],
		columns:[
			{dataIndex:'DIV_CODE'			,width: 100},
			{dataIndex:'PAYMENT_DATE'		,width: 80},
			{dataIndex:'OFFICE_CODE'		,width: 80 ,
				 summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
	              	return Unilite.renderSummaryRow(summaryData, metaData, '합계', '총계');
	            }
	        },
			{dataIndex:'DRIVER_CODE'		,width: 80 },
			{dataIndex:'DRIVER_NAME'		,width: 100},
			{dataIndex:'VEHICLE_REGIST_NO'	,width: 110},
			{dataIndex:'ADULT_COUNT'		,width: 80, summaryType: 'sum'},
			{dataIndex:'ADULT_AMOUNT'		,width: 80, summaryType: 'sum'},
			{dataIndex:'STUDENT_COUNT'		,width: 80, summaryType: 'sum'},
			{dataIndex:'STUDENT_AMOUNT'		,width: 80, summaryType: 'sum'},
			{dataIndex:'CHILD_COUNT'		,width: 80, summaryType: 'sum'},
			{dataIndex:'CHILD_AMOUNT'		,width: 80, summaryType: 'sum'},
			{dataIndex:'TOTAL_COUNT'		,width: 80, summaryType: 'sum'},
			{dataIndex:'TOTAL_AMOUNT'		,width: 80, summaryType: 'sum'},
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
   
	Unilite.defineModel('excel.gcd100.sheet01', {
	    fields: [
			 {name: 'DIV_CODE'   			,text:'사업장'			,type : 'string'  ,comboType: 'BOR120' ,defaultValue: UserInfo.divCode } 
			,{name: '_EXCEL_ROWNUM'    		,text:'순번'			,type : 'int'  } 
			,{name: '_EXCEL_HAS_ERROR'    	,text:'에러메세지'		,type : 'string'  } 
			,{name: '_EXCEL_ERROR_MSG'    	,text:'에러메세지'		,type : 'string'  } 
			 
			,{name: 'PAYMENT_DATE'    		,text:'사용일자'		,type : 'uniDate' } 
			,{name: 'COMPANY_NAME'    		,text:'교통사업자명'	,type : 'string'  } 
			,{name: 'OFFICE_CODE'    		,text:'영업소'	,type : 'string'  } 
			
			,{name: 'DRIVER_CODE'    		,text:'기사코드'		,type : 'string'  } 
			,{name: 'DRIVER_NAME'    		,text:'기사명'			,type : 'string'  } 
			,{name: 'ROUTE_CODE'    		,text:'노선'			,type : 'string'  ,store: Ext.data.StoreManager.lookup('routeStore')} 		
			,{name: 'VEHICLE_CODE'    		,text:'차량'			,type : 'string'  }
			,{name: 'VEHICLE_REGIST_NO'    	,text:'차량번호'		,type : 'string'  }
			,{name: 'ADULT_COUNT'    		,text:'일반건수'		,type : 'uniQty'  }
			,{name: 'ADULT_AMOUNT'    		,text:'일반금액'		,type : 'uniPrice'} 
			,{name: 'STUDENT_COUNT'    		,text:'학생건수'		,type : 'uniQty'  }
			,{name: 'STUDENT_AMOUNT'    	,text:'학생금액'		,type : 'uniPrice'} 
			,{name: 'CHILD_COUNT'    		,text:'어린이건수'		,type : 'uniQty'  }
			,{name: 'CHILD_AMOUNT'    		,text:'어린이금액'		,type : 'uniPrice'} 
			,{name: 'TOTAL_COUNT'    		,text:'총건수합계'		,type : 'uniQty'  }
			,{name: 'TOTAL_AMOUNT'    		,text:'총금액 합계'		,type : 'uniPrice'}
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
                		excelConfigName: 'gcd100',
                		extParam: { 
                			'DIV_CODE': panelSearch.getValue('DIV_CODE')
                		},
                        grids: [
                        	 {
                        		itemId: 'gcdExcelGrid',
                        		title: '카드수입금 파일등록(사용일)',                        		
                        		useCheckbox: true,
                        		model : 'excel.gcd100.sheet01',
                        		readApi: 'gcd100ukrvService.selectExcelUploadSheet1',
                        		
                        		columns: [
                             		     	{dataIndex:'PAYMENT_DATE'		,width: 80},
											{dataIndex:'COMPANY_NAME'		,width: 80 },
											{dataIndex:'DRIVER_CODE'		,width: 80 },
											{dataIndex:'DRIVER_NAME'			,width: 100},
											{dataIndex:'VEHICLE_REGIST_NO'	,width: 110},
											{dataIndex:'ADULT_COUNT'		,width: 80},
											{dataIndex:'ADULT_AMOUNT'		,width: 80},
											{dataIndex:'STUDENT_COUNT'		,width: 80},
											{dataIndex:'STUDENT_AMOUNT'		,width: 80},
											{dataIndex:'CHILD_COUNT'		,width: 80},
											{dataIndex:'CHILD_AMOUNT'		,width: 80},
											{dataIndex:'TOTAL_COUNT'		,width: 80},
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
		id  : 'gcd100ukrApp',
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