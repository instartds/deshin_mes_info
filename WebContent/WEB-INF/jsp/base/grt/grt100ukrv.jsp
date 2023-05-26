<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
//노선정보 등록
request.setAttribute("PKGNAME","Unilite_app_grt100ukrv");
%>
<t:appConfig pgmId="grt100ukrv"  >
	<t:ExtComboStore comboType="BOR120"/>				<!-- 사업장   	-->  
	<t:ExtComboStore comboType="AU" comboCode="GO13"/>				<!-- 운행/폐지 구분  	-->	
</t:appConfig>
<script type="text/javascript">
function appMain() {
	Unilite.defineModel('${PKGNAME}Model', {
	    fields: [
					 {name: 'DIV_CODE'   			,text:'<t:message code="system.label.base.division" default="사업장"/>'			,type : 'string'  ,comboType: 'BOR120' ,allowBlank:false ,defaultValue: UserInfo.divCode} 
					,{name: 'ROUTE_CODE'    		,text:'노선코드'		,type : 'string'  ,editable:false } 
					,{name: 'ROUTE_NUM'    			,text:'노선번호'		,type : 'string'  ,allowBlank:false } 
					,{name: 'ROUTE_NAME'    		,text:'노선명'			,type : 'string'  ,allowBlank:false } 					
					,{name: 'ROUTE_STATUS'    		,text:'노선상태'		,type : 'string'  ,allowBlank:false	,comboType:'AU', comboCode:'GO13' }
					,{name: 'ROUTE_OPEN_DATE'    	,text:'개시일'		,type : 'uniDate' ,allowBlank:false} 
					,{name: 'ROUTE_EXPIRE_DATE'    	,text:'폐지일'		,type : 'uniDate' ,defaultValue: '29991231'} 
					,{name: 'REMARK'  				,text:'<t:message code="system.label.base.remarks" default="비고"/>'			,type : 'string'} 
					,{name: 'COMP_CODE'  			,text:'<t:message code="system.label.base.companycode" default="법인코드"/>'		,type : 'string'  ,allowBlank:false ,defaultValue: UserInfo.compCode} 
			]
	});
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read 	: 'grt100ukrvService.selectList',
    	   	update 	: 'grt100ukrvService.update',
    	   	create 	: 'grt100ukrvService.insert',
    	   	destroy : 'grt100ukrvService.delete',
			syncAll	: 'grt100ukrvService.saveAll'
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
		title: '노선정보',
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
		           		labelWidth:80
		           	},
			    	items:[{	    
						fieldLabel: '<t:message code="system.label.base.division" default="사업장"/>',
						name: 'DIV_CODE',
						xtype:'uniCombobox',
						comboType:'BOR120',
						value: UserInfo.divCode,
						allowBlank:false
					},{	    
						fieldLabel: '노선코드',
						name: 'ROUTE_CODE'	
					},{	    
						fieldLabel: '노선번호',
						name: 'ROUTE_NUM'	
					},{	    
						fieldLabel: '노선명',
						name: 'ROUTE_NAME'	
					},{	    
						fieldLabel: '개시일',
						xtype: 'uniDateRangefield',
			            startFieldName: 'ROUTE_OPEN_DATE_FR',
			            endFieldName: 'ROUTE_OPEN_DATE_TO',
			            width:320
					},{	    
						fieldLabel: '폐지일',
						xtype: 'uniDateRangefield',
			            startFieldName: 'ROUTE_EXPIRE_DATE_FR',
			            endFieldName: 'ROUTE_EXPIRE_DATE_TO',	
			            width:320
					},{	    
						fieldLabel: '노선상태',
						name: 'ROUTE_STATUS',
						xtype:'uniCombobox',
						comboType:'AU',
						comboCode:'GO13'
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
			{dataIndex:'ROUTE_CODE'			,width: 80, isLink:true},
			{dataIndex:'ROUTE_NUM'			,width: 80 },
			{dataIndex:'ROUTE_NAME'			,width: 120 },
			{dataIndex:'ROUTE_OPEN_DATE'	,width: 100},
			{dataIndex:'ROUTE_EXPIRE_DATE'	,width: 100},
			{dataIndex:'ROUTE_STATUS'		,width: 80},
			{dataIndex:'REMARK'				,flex: 1}
		] ,
        listeners: {
	          onGridDblClick:function(grid, record, cellIndex, colName) {
	          	if(colName == 'ROUTE_CODE' )	{
					var params = {
							'DIV_CODE' : record.data['DIV_CODE'],
							'ROUTE_CODE' : record.data['ROUTE_CODE'],
							'ROUTE_NUM' : record.data['ROUTE_NUM'],
							'ROUTE_NAME' : record.data['ROUTE_NAME'],
							'ROUTE_STATUS' : record.data['ROUTE_STATUS']
					}
					var rec = {data : {prgID : 'grt110ukrv', 'text':''}};
					parent.openTab(rec, '/base/grt110ukrv.do', params);
	          	}
							
	          }
        }
   });
	
      Unilite.Main({
		borderItems:[
				 		  panelSearch
				 		 ,masterGrid
		],
		id  : 'grt100ukrApp',
		autoButtonControl : false,
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['print'],false);
			UniAppManager.setToolbarButtons(['reset', 'newData', 'excel' ],true);
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