<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
//일일근태내역 조회
request.setAttribute("PKGNAME","Unilite.app.gtt100skrv");
%>
<t:appConfig pgmId="gtt100skrv"  >
	<t:ExtComboStore comboType="BOR120"/>								<!-- 사업장   	--> 
	<t:ExtComboStore comboType="BOR120" comboCode="GO16"/>				<!-- 노선그룹   	--> 
	<t:ExtComboStore comboType="BOR120" comboCode="GO35"/>				<!-- 노선그룹   -->
	
</t:appConfig>
<script type="text/javascript">
function appMain() {

	Unilite.defineModel('${PKGNAME}.model', {
	    fields: [
				
					 {name: 'DIV_CODE'   			,text:'사업장'			,type : 'string'  ,comboType: 'BOR120' ,defaultValue: UserInfo.divCode} 
					
					,{name: 'OPERATION_DATE'    	,text:'운행일'			,type : 'uniDate' } 
					,{name: 'ROUTE_NUM'    			,text:'노선'		,type : 'string'  } 
					,{name: 'ROUTE_CODE'    		,text:'노선번호'		,type : 'string'  } 
					
					
			]
	});

	var masterStore =  Unilite.createStore('${PKGNAME}.store',{
        model: '${PKGNAME}.model',
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
                	   read : 'gop100ukrvService.selectList'
                }
            },
            saveStore : function(config)	{				
				var inValidRecs = this.getInvalidRecords();
				
				if(inValidRecs.length == 0 )	{
					this.syncAll(config);					
				}else {
					var grid = Ext.getCmp('${PKGNAME}.grid');
                	grid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			} ,
			loadStoreRecords: function()	{
				var searchForm = Ext.getCmp('${PKGNAME}.searchForm');
				var param= searchForm.getValues();
				if(searchForm.isValid())	{
					this.load({params: param});
				}
			},
            groupField: 'OPERATION_DATE',
            listeners:{
            	load:function(store, records, successful, eOpts)	{
            		if(successful)	{
            			
            		}
            	}
            }
		});
	
 	
		

	var panelSearch = Unilite.createSearchPanel('${PKGNAME}.searchForm',{
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
						fieldLabel: '기사코드',
						name: 'DRIVER_CODE'	
					},{	    
						fieldLabel: '기사명',
						name: 'DRIVER_NAME'	
					},{	    
						fieldLabel: '노선그룹',
						name: 'ROUTE_GROUP'	,
						xtype: 'uniCombobox',
						comboType:'AU', 
						comboCode:'GO16',
						allowBlank:false,
						listeners: {
							change:function()	{
								panelSearch.setValue('ROUTE_CODE', '');
							}
						}
					},{	    
						fieldLabel: '운행일',
						name: 'OPERATION_DATE',
						xtype: 'uniDateRangefield',
			            startFieldName: 'OPERATION_DATE_FR',
			            endFieldName: 'OPERATION_DATE_TO',	
			            startDate: UniDate.get('startOfWeek'),
			            endDate: UniDate.get('endOfWeek'),
			            width:320,
			            allowBlank:false
					}
					]				
				}
				
				]

	});	//end panelSearch    
	 var cloneGrid;
     var masterGrid = Unilite.createGrid('${PKGNAME}.grid', {
        layout : 'fit',        
        height:300,
    	tbar:[
    		{
	 		 			xtype:'button',
	 		 			text  : 'clone',
	                    handler:function(){
	                    	if(!cloneGrid)	{
	                    		cloneGrid = masterGrid.cloneConfig();
	                    		gridPanel.add(cloneGrid);
	                    	}

	                    }
	 		 		}
    	],
		uniOpt:{
			useRowNumberer: false,
        	expandLastColumn: false,
            useMultipleSorting: false
        },
        
        
    	store: masterStore,
		columns:[
			{dataIndex:'DIV_CODE'			,width: 100, hidden:true},
			{dataIndex:'OPERATION_DATE'		,width: 80 },
			{dataIndex:'ROUTE_NUM'		,width: 65
			 
	        },
			
			{dataIndex:'REMARK'				,flex: 1}
		] 
   });
    var gridPanel = Ext.create('Ext.panel.Panel',{
	 		  region:'center',
	 		  items:[masterGrid]
	 		  });

      Unilite.Main({
		borderItems:[
	 		  panelSearch,
	 		  gridPanel
	 		 
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