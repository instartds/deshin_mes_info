<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
//차량정보 등록
request.setAttribute("PKGNAME","Unilite_app_gve100ukrv");
%>
<t:appConfig pgmId="gve100ukrv"  >
	<t:ExtComboStore comboType="BOR120"/>				<!-- 사업장   	--> 
	<t:ExtComboStore comboType="AU" comboCode="GO13"/>				<!-- 운행/폐지 구분  	-->	
</t:appConfig>
<script type="text/javascript">
function appMain() {
	Unilite.defineModel('${PKGNAME}model', {
	    fields: [
					 {name: 'DIV_CODE'   			,text:'<t:message code="system.label.base.division" default="사업장"/>'			,type : 'string'  ,comboType: 'BOR120' ,allowBlank:false ,defaultValue: UserInfo.divCode} 
					,{name: 'VEHICLE_CODE'    		,text:'차량코드'		,type : 'string'  ,editable:false} 
					,{name: 'VEHICLE_NAME'    		,text:'차량명'			,type : 'string' ,allowBlank:false} 					
					,{name: 'VEHICLE_REGIST_NO'    	,text:'차량등록번호'		,type : 'string' ,allowBlank:false } 
					,{name: 'REGIST_STATUS'    		,text:'등록상태'		,type : 'string'	,comboType:'AU', comboCode:'GO13',allowBlank:false}
					,{name: 'REGIST_DATE'    		,text:'등록일'		,type : 'uniDate',allowBlank:false} 
					,{name: 'REGIST_OPEN_DATE'    	,text:'개시일'		,type : 'uniDate'} 
					,{name: 'REGIST_EXPIRE_DATE'    ,text:'폐지일'		,type : 'uniDate'} 
					,{name: 'REMARK'  				,text:'<t:message code="system.label.base.remarks" default="비고"/>'			,type : 'string'} 
					,{name: 'COMP_CODE'  			,text:'<t:message code="system.label.base.companycode" default="법인코드"/>'		,type : 'string'  ,allowBlank:false ,defaultValue: UserInfo.compCode} 
			]
	});



	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read 	: 'gve100ukrvService.selectList',
    	   	update 	: 'gve100ukrvService.update',
    	   	create 	: 'gve100ukrvService.insert',
    	   	destroy : 'gve100ukrvService.delete',
			syncAll	: 'gve100ukrvService.saveAll'
		}
	});


    var masterStore =  Unilite.createStore('${PKGNAME}store',{
        model: '${PKGNAME}model',
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
					this.syncAllDirect();					
				}else {
					var grid = Ext.getCmp('${PKGNAME}grid');
                	grid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			} ,
			loadStoreRecords: function()	{
				var searchForm = Ext.getCmp('${PKGNAME}searchForm');
				var param= searchForm.getValues();
				if(searchForm.isValid())	{
					this.load({params: param});
				}
			}
            
		});
	
	var panelSearch = Unilite.createSearchPanel('${PKGNAME}searchForm',{
		title: '차량정보',
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
						fieldLabel: '차량코드',
						name: 'VEHICLE_CODE'	
					},{	    
						fieldLabel: '차량명',
						name: 'VEHICLE_NAME'	
					},{	    
						fieldLabel: '차량등록번호',
						name: 'VEHICLE_REGIST_NO'	
					},{	    
						fieldLabel: '등록일',
						xtype: 'uniDateRangefield',
			            startFieldName: 'REGIST_DATE_FR',
			            endFieldName: 'REGIST_DATE_TO',	
			            width:320
					},{	    
						fieldLabel: '개시일',
						xtype: 'uniDateRangefield',
			            startFieldName: 'REGIST_OPEN_DATE_FR',
			            endFieldName: 'REGIST_OPEN_DATE_TO',
			            width:320
					},{	    
						fieldLabel: '폐지일',
						xtype: 'uniDateRangefield',
			            startFieldName: 'REGIST_EXPIRE_DATE_FR',
			            endFieldName: 'REGIST_EXPIRE_DATE_TO',	
			            width:320
					},{	    
						fieldLabel: '등록상태',
						name: 'REGIST_STATUS',
						xtype:'uniCombobox',
						comboType:'AU',
						comboCode:'GO13'
					}]				
				}]

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
			{dataIndex:'DIV_CODE'			,width: 100},
			{dataIndex:'VEHICLE_CODE'		,width: 80, isLink:true},
			{dataIndex:'VEHICLE_NAME'		,width: 80 },
			{dataIndex:'VEHICLE_REGIST_NO'	,width: 120 },
			{dataIndex:'REGIST_DATE'		,width: 100},
			{dataIndex:'REGIST_OPEN_DATE'	,width: 100},
			{dataIndex:'REGIST_EXPIRE_DATE'	,width: 100},
			{dataIndex:'REGIST_STATUS'		,width: 100},
			{dataIndex:'REMARK'				,flex: 1}
			
		] ,
        listeners: {
	          onGridDblClick:function(grid, record, cellIndex, colName) {
	          	if(colName == 'VEHICLE_CODE')	{
					var params = {
							'DIV_CODE' : record.data['DIV_CODE'],
							'VEHICLE_CODE' : record.data['VEHICLE_CODE'],
							'VEHICLE_NAME' : record.data['VEHICLE_NAME'],
							'VEHICLE_REGIST_NO' : record.data['VEHICLE_REGIST_NO'],
							'REGIST_STATUS' : record.data['REGIST_STATUS']
					}
					var rec = {data : {prgID : 'gve110ukrv', 'text':''}};
					
					parent.openTab(rec, '/base/gve110ukrv.do', params);
	          	}
							
	          }
        }
   });

      Unilite.Main({
		borderItems:[
	 		  panelSearch
	 		 ,masterGrid
		],
		id  : '${PKGNAME}ukrApp',
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