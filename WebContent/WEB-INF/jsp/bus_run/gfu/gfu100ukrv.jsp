<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
//연료주유 등록
request.setAttribute("PKGNAME","Unilite_app_gfu100ukrv");
%>
<t:appConfig pgmId="gfu100ukrv"  >
	<t:ExtComboStore comboType="BOR120"/>							<!-- 사업장   	-->  
	<t:ExtComboStore items="${ROUTE_COMBO}" storeId="routeStore" /> <!-- 노선 -->
	<t:ExtComboStore comboType="AU" comboCode="GO16"/>				<!-- 노선그룹   	-->  
	<t:ExtComboStore comboType="AU" comboCode="GO01"/>				<!-- 노선그룹   	-->  
</t:appConfig>
<style>
.red-text .x-grid-cell { 
    color: #ff0000 !important; 
}  
</style>
<script type="text/javascript">
function appMain() {
	Unilite.defineModel('${PKGNAME}Model', {
	    fields: [
					 {name: 'DIV_CODE'   			,text:'사업장'		,type : 'string'  ,comboType: 'BOR120' ,defaultValue: UserInfo.divCode ,editable:false} 
					,{name: 'SUPPLY_DATE'    		,text:'운행일'		,type : 'uniDate' ,editable:false } 
					,{name: 'OFFICE_CODE'    		,text:'영업소'		,type : 'string'  ,editable:false ,comboType:"AU" ,comboCode:"GO01"} 
					,{name: 'ROUTE_GROUP'    		,text:'노선그룹'	,type : 'string'  ,comboType:"AU" ,comboCode:"GO16"	,editable:false } 
					
					,{name: 'ROUTE_ROWNUM'    		,text:'노선순번'		,type : 'int'  ,editable:false } 					
					,{name: 'ROUTE_CODE'    		,text:'노선'		,type : 'string'  ,editable:false ,store: Ext.data.StoreManager.lookup('routeStore')} 		
					,{name: 'ROUTE_NUM'    			,text:'노선번호'	,type : 'string'  ,editable:false } 
					,{name: 'VEHICLE_CODE'    		,text:'차량'		,type : 'string'  ,editable:false}
					,{name: 'VEHICLE_NAME'    		,text:'차량명'		,type : 'string'  ,editable:false}
					,{name: 'VEHICLE_REGIST_NO'    	,text:'차량'		,type : 'string'  ,editable:false}
					,{name: 'DRIVER_CODE'    		,text:'기사코드'	,type : 'string'  ,editable:false} 
					,{name: 'DRIVER_NAME'    		,text:'기사명'		,type : 'string'  ,editable:false } 
					,{name: 'NOTINSERVICE_YN'    	,text:'운휴'		,type : 'boolean'  } 			
					
					,{name: 'FUEL_AMOUNT'    		,text:'주유량'		,type : 'uniQty' } 
					
					,{name: 'REMARK'  				,text:'비고'		,type : 'string'	} 
					,{name: 'COMP_CODE'  			,text:'법인코드'	,type : 'string'   ,defaultValue: UserInfo.compCode} 
			]
	});

	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read 	: 'gfu100ukrvService.selectList',
    	   	update 	: 'gfu100ukrvService.update',
			syncAll	: 'gfu100ukrvService.saveAll'
		}
	});
    var masterStore =  Unilite.createStore('${PKGNAME}Store',{
        model: '${PKGNAME}Model',
         autoLoad: false,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:true,			// 삭제 가능 여부 
	            useNavi : true			// prev | next 버튼 사용
            },
            groupField:'ROUTE_NUM',
            proxy: directProxy,
            saveStore : function(config)	{				
				var inValidRecs = this.getInvalidRecords();
				
				if(inValidRecs.length == 0 )	{
					this.syncAllDirect(config);					
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
		title: '연료주유',
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
						fieldLabel: '영업소',
						name: 'OFFICE_CODE',
						xtype: 'uniCombobox',
						comboType:'AU', 
						comboCode:'GO01',
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
					},{	    
						fieldLabel: '운행일',
						name: 'SUPPLY_DATE',
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
		uniOpt:{
			useRowNumberer: false,
        	expandLastColumn: false,
            useMultipleSorting: false
        },
        viewConfig: { 
		    getRowClass: function(record) { 
		        return record.get('NOTINSERVICE_YN') == 'Y' ? 'red-text' : ''; 
		    }
	    },
	    features: [ 
	    	{id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true},
	    	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: true} 
	    ],
    	store: masterStore, 
		columns:[
			{dataIndex:'SUPPLY_DATE'	,width: 80,
			 summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
		              	return Unilite.renderSummaryRow(summaryData, metaData, '합계', '총계');
	                    }
	        },
			{dataIndex:'OFFICE_CODE'			,width: 80},
			{dataIndex:'ROUTE_GROUP'			,width: 80 },
			{dataIndex:'VEHICLE_REGIST_NO'		,width: 100},
			{dataIndex:'ROUTE_ROWNUM'			,width: 80},
			{dataIndex:'ROUTE_NUM'				,width: 80 },
			{dataIndex:'VEHICLE_NAME'			,width: 60},
			{dataIndex:'FUEL_AMOUNT'			,width: 100,summaryType:'sum'},
			{dataIndex:'NOTINSERVICE_YN'		,xtype : 'checkcolumn'		,width: 60}
			
		] ,
		listeners:{
			beforeedit: function( editor, context, eOpts )	{
				if(context.record.get('NOTINSERVICE_YN') == 'Y') return false;
				if(context.record.get('NOTINSERVICE_YN') === true) return false;
			}
		}
   });
	
      Unilite.Main({
		borderItems:[
				 		  panelSearch
				 		 ,masterGrid
		],
		id  : 'gfu100ukrApp',
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