<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
request.setAttribute("PKGNAME","Unilite.app.sqlTest");
%>
<t:appConfig pgmId="gtt100skrv"  >
	<t:ExtComboStore comboType="BOR120"/>								<!-- 사업장   	--> 
	<t:ExtComboStore comboType="BOR120" comboCode="GO16"/>				<!-- 노선그룹   	--> 
	<t:ExtComboStore comboType="BOR120" comboCode="GO35"/>				<!-- 노선그룹   -->
	
</t:appConfig>
<script type="text/javascript">
function appMain() {

	
	var panelSearch = Unilite.createSearchPanel('${PKGNAME}.searchForm',{
		title: '검색',
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
						fieldLabel: '조회일',
						name: 'OPERATION_DATE',
						xtype: 'uniDateRangefield',
			            startFieldName: 'FR_DATE',
			            endFieldName: 'TO_DATE',	
			            startDate:'20150125',
			            endDate: '20150131',
			            width:320,
			            allowBlank:false
					}
					]				
				}
				
				]

	});	//end panelSearch    


      Unilite.Main({
		borderItems:[
	 		  panelSearch,
	 		  {
	 		  	region:'center',
	 		  	xtype:'uniDetailForm',
	 		  	id:'sqlTest',
	 		  	disabled:false,
	 		  	flex:1,
	 		  	items:[
	 		  		{
	 		  			xtype:'button',
	 		  			text:'MyBatis',
	 		  			handler:function()	{
	 		  				var params  = panelSearch.getValues();
	 		  				sqlPerformanceService.mybatisTest(params, function(response, provider){
	 		  					console.log("response",response);
	 		  					console.log("provider",provider);
	 		  					Ext.getCmp("sqlTest").setValue('result',"MyBatis "+response);
	 		  				})
	 		  			}
	 		  		},
	 		  		{
	 		  			xtype:'button',
	 		  			text:'SQL Variable',
	 		  			handler:function()	{
	 		  				var params  = panelSearch.getValues();
	 		  				sqlPerformanceService.sqlVariableTest(params, function(response, provider){
	 		  					console.log("response",response);
	 		  					console.log("provider",provider);
	 		  					Ext.getCmp("sqlTest").setValue('result','SQL Variable '+response);
	 		  				})
	 		  			}
	 		  		},
	 		  		{
	 		  			xtype:'textarea',
	 		  			name:'result',
	 		  			height:300,
	 		  			width: 800
	 		  		}
	 		  	
	 		  	]
	 		  }
	 		 
		],
		id  : '${PKGNAME}ukrApp',
		autoButtonControl : false,
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['print', 'newData'], false);
			UniAppManager.setToolbarButtons(['reset', 'excel' ], false);
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