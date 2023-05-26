<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
//현금 수입금 등록
request.setAttribute("PKGNAME","Unilite_app_gcd400skrv");
%>
<t:appConfig pgmId="gcd400skrv"  >
	<t:ExtComboStore comboType="BOR120"/>							<!-- 사업장   	-->  
	<t:ExtComboStore items="${ROUTE_COMBO}" storeId="routeStore" /> <!-- 노선 -->
	<t:ExtComboStore items="${ROUTEGROUP_COMBO}" storeId="routeGroupStore" /> <!-- 노선그룹 -->
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
		//--사업장	운행일	노선그룹	노선	차량	기사코드	기사명	현금
	    fields: [
					 {name: 'DIV_CODE'   			,text:'사업장'		,type : 'string'  ,comboType: 'BOR120' ,defaultValue: UserInfo.divCode ,editable:false} 
					,{name: 'DEPOSIT_DATE'    		,text:'운행일'		,type : 'uniDate' ,editable:false } 
					,{name: 'OFFICE_CODE'    		,text:'영업소'		,type : 'string'  ,editable:false ,comboType:"AU" ,comboCode:"GO01"} 
					,{name: 'ROUTE_GROUP'    		,text:'노선그룹'	,type : 'string'  ,store: Ext.data.StoreManager.lookup('routeGroupStore')	,editable:false } 
					
					,{name: 'ROUTE_ROWNUM'    		,text:'노선순위'		,type : 'int'  ,editable:false } 					
					,{name: 'ROUTE_CODE'    		,text:'노선'		,type : 'string'  ,editable:false ,store: Ext.data.StoreManager.lookup('routeStore')} 		
					,{name: 'ROUTE_NUM'    			,text:'노선번호'	,type : 'string'  ,editable:false } 
					,{name: 'VEHICLE_CODE'    		,text:'차량'		,type : 'string'  ,editable:false}
					,{name: 'VEHICLE_NAME'    		,text:'차량명'		,type : 'string'  ,editable:false}
					,{name: 'VEHICLE_REGIST_NO'    	,text:'차량'		,type : 'string'  ,editable:false}
					,{name: 'DRIVER_CODE'    		,text:'기사코드'	,type : 'string'  ,editable:false} 
					,{name: 'DRIVER_NAME'    		,text:'기사명'		,type : 'string'  ,editable:false } 
					
					,{name: 'RUN_COUNT_CNT'   		,text:'운행횟수'	,type : 'uniQty' } 
					,{name: 'DAY_AMOUNT'    		,text:'총수입금'		,type : 'uniPrice' } 
					,{name: 'VEHICLE_AVG'    		,text:'대당평균'		,type : 'uniPrice' } 
					,{name: 'VEHICLE_AVG_COMP'    	,text:'평균비교'		,type : 'uniPrice' } 
					
					
					,{name: 'REMARK'  				,text:'비고'		,type : 'string'	} 
					,{name: 'COMP_CODE'  			,text:'법인코드'	,type : 'string'   ,defaultValue: UserInfo.compCode} 
			]
	});

	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read 	: 'gcd400skrvService.selectList'
		}
	});
    var masterStore =  Unilite.createStore('${PKGNAME}Store',{
        model: '${PKGNAME}Model',
         autoLoad: false,
            uniOpt : {
            	isMaster: false,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            groupField:'ROUTE_NUM',
            proxy: directProxy,
			loadStoreRecords: function()	{
				var searchForm = Ext.getCmp('${PKGNAME}SearchForm');
				var param= searchForm.getValues();
				if(searchForm.isValid())	{
					this.load({params: param});
				}
			}
		});
	

	var panelSearch = Unilite.createSearchPanel('${PKGNAME}SearchForm',{
		title: '현금수입금',
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
						comboCode:'GO01'
					},{	    
						fieldLabel: '노선그룹',
						name: 'ROUTE_GROUP'	,
						xtype: 'uniCombobox',
						store: Ext.data.StoreManager.lookup('routeGroupStore'),
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
						fieldLabel: '조회일',
						name: 'DEPOSIT_DATE',
						xtype: 'uniDateRangefield',
			            startFieldName: 'DEPOSIT_DATE_FR',
			            endFieldName: 'DEPOSIT_DATE_TO',	
			            startDate: UniDate.get('today'),
			            endDate: UniDate.get('today'),
			            width:320,
			            allowBlank:false
					}
			 		,{	    
						fieldLabel: '차량명',
						name: 'VEHICLE_NAME'
						
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
						fieldLabel: '정렬',
						name: 'SORT_TYPE'	,
						xtype: 'radiogroup',
					    items : [{
					    	boxLabel: '올림',
					    	name: 'SORT_TYPE' ,
					    	inputValue: 1,
					    	width:65,
					    	checked:true
					    }, {boxLabel: '내림',
					    	name: 'SORT_TYPE',
					    	inputValue: 2,
					    	width:65
					    }]
					
					}]				
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
		        return record.get('VEHICLE_AVG_COMP') < 0 ? 'red-text' : ''; 
		    }
	    },
	    features: [ 
	    	{id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true},
	    	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: true} 
	    ],
    	store: masterStore, 
		columns:[
			{dataIndex:'OFFICE_CODE'			,width: 80,
			 summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
		              	return Unilite.renderSummaryRow(summaryData, metaData, '합계', '총계');
	                    }},
			{dataIndex:'ROUTE_GROUP'			,width: 80 },
			{dataIndex:'VEHICLE_REGIST_NO'		,width: 100},
			{dataIndex:'ROUTE_ROWNUM'			,width: 80},
			{dataIndex:'ROUTE_NUM'				,width: 80 },
			{dataIndex:'VEHICLE_NAME'			,width: 60},
			{dataIndex:'DRIVER_CODE'			,width: 70},
			{dataIndex:'DRIVER_NAME'			,width: 70},
			{dataIndex:'RUN_COUNT_CNT'			,width: 80,summaryType:'sum'},
			{dataIndex:'DAY_AMOUNT'	,width: 100,summaryType:'sum'},
			{dataIndex:'VEHICLE_AVG'	,width: 100, 
				  summaryType:function(values)	{
				 	var sumTotal = 0;
				 	var sumOperation=0;
				 	
				 	Ext.each(values, function(value, index){
						sumTotal = sumTotal+value.get('DAY_AMOUNT');
						sumOperation = sumOperation+value.get('RUN_COUNT_CNT');
					});	
					
				 	return sumOperation == 0 ? 0 : Math.round(sumTotal/sumOperation);
				 }
			},
			{dataIndex:'VEHICLE_AVG_COMP'	,width: 100, 
				  summaryType:function(values)	{
				 	var sumTotal = 0;
				 	var sumComp = 0;
				 	var sumOperation=0;
				 	
				 	Ext.each(values, function(value, index){
						sumTotal = sumTotal+value.get('DAY_AMOUNT');
						sumOperation = sumOperation+value.get('RUN_COUNT_CNT');
						sumComp = sumComp+value.get('VEHICLE_AVG_COMP');
					});	
					var avgRoute = sumOperation == 0 ? 0 : Math.round(sumTotal/sumOperation);
					
				 	return sumOperation == 0 ? 0 : avgRoute - Math.round(sumComp/sumOperation);
				 },
				  summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					 if(Unilite.isGrandSummaryRow(summaryData, metaData)) {
						return '';
	    			}
	    			return value;
				  }
			}
					
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
		id  : 'gcd400skrApp',
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