<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
//기사정보 등록
request.setAttribute("PKGNAME","Unilite_app_gdr100ukrv");
%>
<t:appConfig pgmId="gdr100ukrv"  >
	<t:ExtComboStore comboType="BOR120"/>				<!-- 사업장   	--> 
	<t:ExtComboStore comboType="AU" comboCode="GO18"/>				<!-- 근무조  	-->	
	<t:ExtComboStore items="${ROUTE_COMBO}" storeId="routeStore" /> <!-- 노선 -->
	<t:ExtComboStore comboType="AU" comboCode="GO16"/>				<!-- 노선그룹  	-->	
</t:appConfig>
<script type="text/javascript">
function appMain() {
	Unilite.defineModel('${PKGNAME}Model', {
	    fields: [
					 {name: 'DIV_CODE'   			,text:'<t:message code="system.label.base.division" default="사업장"/>'			,type : 'string'  ,editable:false  	,allowBlank:false, comboType: 'BOR120' ,defaultValue: UserInfo.divCode} 
					,{name: 'DRIVER_CODE'    		,text:'기사코드'		,type : 'string'  ,editable:false	,allowBlank:false} 
					,{name: 'DRIVER_NAME'    		,text:'기사명'			,type : 'string'  ,editable:false	,allowBlank:false} 
					,{name: 'ROUTE_GROUP'    		,text:'노선그룹'		,type : 'string'  ,comboType:'AU', comboCode:'GO16', child: 'ROUTE_CODE'}
					,{name: 'ROUTE_CODE'    		,text:'노선'			,type : 'string'  ,comboType:'AU', store: Ext.data.StoreManager.lookup('routeStore') }
					,{name: 'WORK_TEAM_CODE'    	,text:'근무조'			,type : 'string'  ,comboType:'AU'	,comboCode:'GO18'} 					
					,{name: 'REMARK'  				,text:'<t:message code="system.label.base.remarks" default="비고"/>'			,type : 'string' } 
					,{name: 'COMP_CODE'  			,text:'<t:message code="system.label.base.companycode" default="법인코드"/>'		,type : 'string'  ,allowBlank:false ,defaultValue: UserInfo.compCode} 
			]
	});
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read : 'gdr100ukrvService.selectList',
           	update : 'gdr100ukrvService.update',
			syncAll: 'gdr100ukrvService.saveAll'
		}
	});
	var masterStore =  Unilite.createStore('${PKGNAME}Store',{
        model: '${PKGNAME}Model',
         autoLoad: false,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            
            proxy: directProxy,
            saveStore : function(config)	{				
				var inValidRecs = this.getInvalidRecords();
				
				if(inValidRecs.length == 0 )	{
					this.syncAllDirect();					
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
		title: '기사정보',
        defaultType: 'uniSearchSubPanel',
        defaults: {
			autoScroll:true
	  	},
        width: 330,
		items: [{	
					title: '<t:message code="system.label.base.searchconditon" default="검색조건"/>', 	
					id: 'search_panel1',
		   			itemId: 'search_panel1',
		           	layout: {type: 'uniTable', columns: 1},
		           	defaultType: 'uniTextfield',  
		           	defaults:{
		           		labelWidth:90
		           	},
			    	items:[{	    
						fieldLabel: '<t:message code="system.label.base.division" default="사업장"/>',
						name: 'DIV_CODE',
						xtype:'uniCombobox',
						comboType:'BOR120',
						value: UserInfo.divCode,
						allowBlank:false
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
						child: 'ROUTE_CODE'
						
					},{	    
						fieldLabel: '노선',
						name: 'ROUTE_CODE'	,
						xtype: 'uniCombobox',
						store: Ext.data.StoreManager.lookup('routeStore')
					},{	    
						fieldLabel: '근무조',
						name: 'WORK_TEAM_CODE',
						xtype:'uniCombobox',
						comboType:'AU',
						comboCode:'GO18'						
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
    	store: masterStore,
		columns:[
			{dataIndex:'DIV_CODE'			,width: 100},
			{dataIndex:'DRIVER_CODE'		,width: 100},
			{dataIndex:'DRIVER_NAME'		,width: 100 },
			{dataIndex:'WORK_TEAM_CODE'		,width: 100 },
			{dataIndex:'ROUTE_GROUP'		,width: 120},
			{dataIndex:'ROUTE_CODE'			,width: 120},
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