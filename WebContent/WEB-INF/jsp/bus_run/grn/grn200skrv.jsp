<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
//정류소별 운행내역조회
request.setAttribute("PKGNAME","Unilite_app_grn200skrv");
%>
<t:appConfig pgmId="grn200skrv"  >
	<t:ExtComboStore comboType="BOR120"/>								<!-- 사업장   	--> 
	<t:ExtComboStore comboType="AU" comboCode="GO16"/>				<!-- 노선그룹   	--> 
	<t:ExtComboStore comboType="AU" comboCode="GO39"/>				<!-- 운행평가   	--> 
	<t:ExtComboStore items="${ROUTE_COMBO}" storeId="routeStore" /> 	<!-- 노선 -->
	
</t:appConfig>
<script type="text/javascript">
function appMain() {

	Ext.create('Ext.data.Store', {
		storeId:"runType",
	    fields: ['text', 'value'],
	    data : [
	        {text:"정상운행",   value:"1"},
	        {text:"추월차량",   value:"2"}
	    ]
	});
	
	Unilite.defineModel('${PKGNAME}model', {
	    fields: [
					 {name: 'DIV_CODE'   			,text:'사업장'			,type : 'string'  ,comboType: 'BOR120' ,defaultValue: UserInfo.divCode} 
					,{name: 'ROUTE_GROUP'    		,text:'노선그룹'		,type : 'string'  ,comboType: 'AU', comboCode:'GO16'} 
					,{name: 'OPERATION_DATE'    	,text:'운행일'			,type : 'uniDate' } 
					,{name: 'ROUTE_NUM'    			,text:'노선'			,type : 'string'  } 
					,{name: 'ROUTE_CODE'    		,text:'노선번호'		,type : 'string'  } 
					,{name: 'OPERATION_COUNT'    	,text:'운행순번'		,type : 'string'  }					
					,{name: 'RUN_COUNT'   			,text:'운행회차'		,type : 'string'  }	
					
					,{name: 'VEHICLE_CODE'    	,text:'차량'				,type : 'string'  } 
					,{name: 'VEHICLE_NAME'    	,text:'차량'				,type : 'string'  } 
					,{name: 'VEHICLE_REGIST_NO'   ,text:'차량등록번호'		,type : 'string'  } 
					,{name: 'DRIVER_CODE'    		,text:'기사코드'		,type : 'string'  } 
					,{name: 'NAME'    			,text:'기사명'				,type : 'string'  } 
					
					,{name: 'STATION_NAME'    		,text:'정류소'			,type : 'string'  } 
					,{name: 'PREV_ST_END_TIME'    	,text:'앞차도착시간'	,type : 'string'  ,convert:convertTime} 
					,{name: 'ST_END_TIME'    		,text:'도착시간'		,type : 'string'  ,convert:convertTime} 
					,{name: 'ST_START_TIME'    		,text:'출발시간'		,type : 'string'  ,convert:convertTime}
					,{name: 'RUN_TYPE'    			,text:'운행구분'		,type : 'string'  ,store: Ext.data.StoreManager.lookup('runType')}
						
					,{name: 'REMARK'  				,text:'비고'			,type : 'string'  } 
					,{name: 'COMP_CODE'  			,text:'법인코드'		,type : 'string' ,defaultValue: UserInfo.compCode} 
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
                	   read : 'grn200skrvService.selectList'
                }
            },
			loadStoreRecords: function()	{
				var searchForm = Ext.getCmp('${PKGNAME}searchForm');
				var param= searchForm.getValues();
//				if(searchForm.isValid())	{
//					this.load({params: param});
//				}
			}
		});

	var panelSearch = Unilite.createSearchPanel('${PKGNAME}searchForm',{
		title: '정류소별 운행내역',
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
					},{	    
						fieldLabel: '조회구분',
						name: 'RUN_TYPE'	,
						xtype: 'uniCombobox',
						store: Ext.data.StoreManager.lookup('runType')	,
						value:'2'
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
    	store: masterStore,
		columns:[
			{dataIndex:'ROUTE_GROUP'		,width: 80},
	        {dataIndex:'ROUTE_NUM'				,width: 45},
			{dataIndex:'OPERATION_DATE'			,width: 80 },
			{dataIndex:'OPERATION_COUNT'			,width: 80 },
			{dataIndex:'RUN_COUNT'			,width: 80 },
			{dataIndex:'VEHICLE_REGIST_NO'			,width: 100 },
			{dataIndex:'NAME'			,width: 80 },
			{dataIndex:'STATION_NAME'			,width: 130 },
			{dataIndex:'PREV_ST_END_TIME'			,width: 100 },
			{dataIndex:'ST_END_TIME'			,width: 80 },
			{dataIndex:'ST_START_TIME'			,width: 80 },
			{dataIndex:'RUN_TYPE'			,width: 80 },
			
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