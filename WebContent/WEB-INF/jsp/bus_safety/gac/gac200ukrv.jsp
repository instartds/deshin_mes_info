<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
//사고내역서 파일이체
request.setAttribute("PKGNAME","Unilite_app_gac200ukrv");
%>
<t:appConfig pgmId="gac200ukrv"  >
	<t:ExtComboStore comboType="BOR120"/>							<!-- 사업장   	-->  
	<t:ExtComboStore comboType="AU" comboCode="GO01"/>				<!-- 영업소   	--> 
</t:appConfig>
<script type="text/javascript">
var excelWindow;
function appMain() {
	Unilite.defineModel('${PKGNAME}Model', {
	    fields: [
			 {name: 'DIV_CODE'   			,text:'사업장'			,type : 'string'  ,comboType: 'BOR120' ,defaultValue: UserInfo.divCode } 
			,{name: 'ACCIDENT_RESULT'    	,text:'사고처리'		,type : 'uniDate' } 
			,{name: 'VEHICLE_CODE'    		,text:'차량'			,type : 'string'  }			
			,{name: 'VEHICLE_NAME'    		,text:'차량명'			,type : 'string'  } 
			,{name: 'VEHICLE_REGIST_NO'    	,text:'차량번호'		,type : 'string'  }
			,{name: 'ACCIDENT_DATE'    		,text:'사고일'			,type : 'string'  } 
			
			,{name: 'ACCIDENT_TIME'    		,text:'시간'			,type : 'string'  } 
			,{name: 'ACCIDENT_DIV'    		,text:'구분'			,type : 'string'  } 					
			
			,{name: 'DAMAGE_NAME'    		,text:'부상자/차량'		,type : 'string'  }
			,{name: 'DRIVER_NAME'    		,text:'운전자'			,type : 'string'  } 
			,{name: 'DRIVER_CODE'    		,text:'운전자코드'		,type : 'string'  } 
			,{name: 'DAMAGE_AMOUNT'    		,text:'손해액'			,type : 'uniPrice'} 
			,{name: 'EXPECT_AMOUNT'    		,text:'추산금액'		,type : 'uniPrice'} 
			
			,{name: 'ACCIDENT_NUM'    		,text:'사고번호'		,type : 'string'  }
			,{name: 'ACCIDENT_SEQ'    		,text:'순번'			,type : 'int'  }
			
			,{name: 'REMARK'  				,text:'비고'			,type : 'string'} 
			,{name: 'COMP_CODE'  			,text:'법인코드'		,type : 'string'   ,defaultValue: UserInfo.compCode} 
		]
	});
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			create  : 'gac200ukrvService.insert',
			syncAll	: 'gac200ukrvService.saveAll'
		}
	});
    var masterStore =  Unilite.createStore('${PKGNAME}Store',{
        model: '${PKGNAME}Model',
         autoLoad: false,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            
            proxy: directProxy,
            saveStore : function()	{				
				var inValidRecs = this.getInvalidRecords();
				
				if(inValidRecs.length == 0 )	{
					var records = this.getNewRecords( ) 
					if(records.length > 1)	{						
						this.syncAllDirect();
					}
				}else {
					var grid = Ext.getCmp('${PKGNAME}Grid');
                	grid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			} 
		});
	
	
	
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
		columns:[
			{dataIndex:'DIV_CODE'			,width: 100},
			{dataIndex:'ACCIDENT_RESULT'	,width: 80},
			{dataIndex:'VEHICLE_NAME'		,width: 80 },
			{dataIndex:'VEHICLE_REGIST_NO'	,width: 110 },
			{dataIndex:'ACCIDENT_DATE'		,width: 100},
			{dataIndex:'ACCIDENT_TIME'		,width: 110},
			{dataIndex:'ACCIDENT_DIV'		,width: 80},
			{dataIndex:'DAMAGE_NAME'		,width: 80},
			{dataIndex:'DRIVER_NAME'		,width: 80},
			{dataIndex:'DAMAGE_AMOUNT'		,width: 80},
			{dataIndex:'EXPECT_AMOUNT'		,width: 80},

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
   
	Unilite.defineModel('excel.gac200.sheet01', {
	    fields: [
			 {name: 'DIV_CODE'   			,text:'사업장'			,type : 'string'  ,comboType: 'BOR120' ,defaultValue: UserInfo.divCode } 
			,{name: '_EXCEL_ROWNUM'    		,text:'순번'			,type : 'int'  } 
			,{name: '_EXCEL_HAS_ERROR'    	,text:'에러메세지'		,type : 'string'  } 
			,{name: '_EXCEL_ERROR_MSG'    	,text:'에러메세지'		,type : 'string'  } 
			 
			,{name: 'ACCIDENT_RESULT'    	,text:'사고처리'		,type : 'uniDate' } 
			,{name: 'VEHICLE_CODE'    		,text:'차량'			,type : 'string'  }			
			,{name: 'VEHICLE_NAME'    		,text:'차량명'			,type : 'string'  } 
			,{name: 'VEHICLE_REGIST_NO'    	,text:'차량번호'		,type : 'string'  }
			,{name: 'ACCIDENT_DATE'    		,text:'사고일'			,type : 'string'  } 
			
			,{name: 'ACCIDENT_TIME'    		,text:'시간'			,type : 'string'  } 
			,{name: 'ACCIDENT_DIV'    		,text:'구분'			,type : 'string'  } 					
			
			,{name: 'DAMAGE_NAME'    		,text:'부상자/차량'		,type : 'string'  }
			,{name: 'DRIVER_NAME'    		,text:'운전자'			,type : 'string'  } 
			,{name: 'DRIVER_CODE'    		,text:'운전자코드'		,type : 'string'  } 
			,{name: 'DAMAGE_AMOUNT'    		,text:'손해액'			,type : 'uniPrice'} 
			,{name: 'EXPECT_AMOUNT'    		,text:'추산금액'		,type : 'uniPrice'} 
			
			,{name: 'ACCIDENT_NUM'    		,text:'사고번호'		,type : 'string'  }
			,{name: 'ACCIDENT_SEQ'    		,text:'순번'			,type : 'int'  }
			
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
                		excelConfigName: 'gac200',
                		extParam: { 
                			'DIV_CODE': UserInfo.divCode
                		},
                        grids: [
                        	 {
                        		itemId: 'gacExcelGrid',
                        		title: '사고내역 파일이체',                        		
                        		useCheckbox: true,
                        		model : 'excel.gac200.sheet01',
                        		readApi: 'gac200ukrvService.selectExcelUploadSheet1',
                        		
                        		columns: [
                             		     	{dataIndex:'ACCIDENT_RESULT'	,width: 80},
											{dataIndex:'VEHICLE_NAME'		,width: 80 },
											{dataIndex:'VEHICLE_REGIST_NO'	,width: 80 },
											{dataIndex:'ACCIDENT_DATE'		,width: 100},
											{dataIndex:'ACCIDENT_TIME'		,width: 110},
											{dataIndex:'ACCIDENT_DIV'		,width: 80},
											{dataIndex:'DAMAGE_NAME'		,width: 80},
											{dataIndex:'DRIVER_NAME'		,width: 80},
											{dataIndex:'DAMAGE_AMOUNT'		,width: 80},
											{dataIndex:'EXPECT_AMOUNT'		,width: 80}                		     
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
                            	var grid = this.down('#gacExcelGrid');
                            	grid.getStore().loadData({});
                            	if(Ext.isDefined(grid.getEl()))	{
                            		grid.getEl().mask();
                            	}
                            }
                        },
                        onApply:function()	{
                        	var grid = this.down('#gacExcelGrid');
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
	 		 masterGrid
		],
		id  : 'gac200ukrApp',
		autoButtonControl : false,
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['print', 'newData'],false);
			UniAppManager.setToolbarButtons(['reset', 'excel' ],true);
		},
		
		onQueryButtonDown : function()	{

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