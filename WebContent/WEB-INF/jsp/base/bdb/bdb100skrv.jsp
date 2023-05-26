<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bdb100skrv"  >
		<t:ExtComboStore comboType= "BOR120"  /> 		 <!-- 사업장 --> 
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {     
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('bdb100skrvModel', {
	    fields: [  	  
	    	{name: 'PID'					,text: 'PID'					,type: 'string'},
		    {name: 'STATUS'					,text: 'STATUS'					,type: 'string'},
		    {name: 'USER'					,text: 'USER'					,type: 'string'},
		    {name: 'HOST'					,text: 'HOST'					,type: 'string'},
		    {name: 'PROGRAM'				,text: 'PROGRAM'				,type: 'string'},
		    {name: 'MEM_USAGE'				,text: 'MEM_USAGE'				,type: 'string'},
		    {name: 'CPU_TIME'				,text: 'CPU_TIME'				,type: 'string'},
		    {name: 'I/O'					,text: 'I/O'					,type: 'string'},
		    {name: 'BLOCKED'				,text: 'BLOCKED'				,type: 'string'},
		    {name: 'DATABASE'				,text: 'DATABASE'				,type: 'string'},
		    {name: 'COMMAND'				,text: 'COMMAND'				,type: 'string'},
		    {name: 'LAST_BATCH'				,text: 'LAST_BATCH'				,type: 'string'},
		    {name: 'LOGIN_TIME'				,text: 'LOGIN_TIME'				,type: 'string'},
		    {name: 'NT_DOMAIN'				,text: 'NT_DOMAIN'				,type: 'string'},
		    {name: 'NT_USER'				,text: 'NT_USER'				,type: 'string'},
		    {name: 'NET_ADDRESS'			,text: 'NET_ADDRESS'			,type: 'string'},
		    {name: 'NET_LIBRARY'			,text: 'NET_LIBRARY'			,type: 'string'},
		    {name: 'SQL_HANDLE'				,text: 'SQL_HANDLE'				,type: 'string'}
		]
	}); //End of Unilite.defineModel('bdb100skrvModel', {

	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('bdb100skrvMasterStore1',{
		model: 'bdb100skrvModel',
		uniOpt: {
            isMaster: false,			// 상위 버튼 연결 
            editable: false,			// 수정 모드 사용 
            deletable: false,			// 삭제 가능 여부 
	        useNavi : false			// prev | next 버튼 사용
        },
        autoLoad: false,
        proxy: {
        	type: 'direct',
            api: {			
            	read: 'bdb100skrvService.selectList1'                	
            }
        },
        loadStoreRecords : function()	{
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		},
		groupField: 'ITEM_NAME'
			
	});
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm',{
		title: '<t:message code="system.label.base.searchconditon" default="검색조건"/>',
        defaultType: 'uniSearchSubPanel',
		items: [{	
			title: '<t:message code="system.label.base.basisinfo2" default="기본정보"/>', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items: [{
	        	fieldLabel: 'DATABASE', 
				xtype: 'uniTextfield',
				
				name:''
		    },{
	        	fieldLabel: 'HOST', 
				xtype: 'uniTextfield',
				
				name:''
		    },{
	        	fieldLabel: '추가검색조건', 
				xtype: 'uniTextfield',
				
				name:''
		    }]
		}]
    }); //End of var panelSearch = Unilite.createSearchForm('searchForm',{
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid1 = Unilite.createGrid('bdb100skrvGrid1', {
    	layout : 'fit',
    	region:'center',
        store : directMasterStore1, 
        uniOpt:{	expandLastColumn: true,
        			useRowNumberer: true,
                    useMultipleSorting: true
        },
        tbar: [{
        	text:'상세보기',
        	handler: function() {
        		var record = masterGrid.getSelectedRecord();
	        	if(record) {
	        		openDetailWindow(record);
	        	}
        	}
        }],
        columns: [        			 
			{dataIndex: 'PID'						, width: 66},
			{dataIndex: 'STATUS'					, width: 80},
			{dataIndex: 'USER'						, width: 66},
			{dataIndex: 'HOST'						, width: 100}, 
			{dataIndex: 'PROGRAM'					, width: 133},
			{dataIndex: 'MEM_USAGE'					, width: 93}, 
			{dataIndex: 'CPU_TIME'					, width: 85},
			{dataIndex: 'I/O'						, width: 66}, 
			{dataIndex: 'BLOCKED'					, width: 80},
			{dataIndex: 'DATABASE'					, width: 80}, 
			{dataIndex: 'COMMAND'					, width: 120},
			{dataIndex: 'LAST_BATCH'				, width: 166}, 
			{dataIndex: 'LOGIN_TIME'				, width: 166},
			{dataIndex: 'NT_DOMAIN'					, width: 93},
			{dataIndex: 'NT_USER'					, width: 93},
			{dataIndex: 'NET_ADDRESS'				, width: 100},
			{dataIndex: 'NET_LIBRARY'				, width: 100},
			{dataIndex: 'SQL_HANDLE'				, width: 166 ,hidden: true}
			
		] 
    });	//End of   var masterGrid1 = Unilite.createGrid('bdb100skrvGrid1', {

    Unilite.Main( {
		border: false,
		borderItems:[ 
		 		 masterGrid1
				,panelSearch
		], 
		id: 'bdb100skrvApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',true);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown : function() {		
			var activeTabId = tab.getActiveTab().getId();			
			if(activeTabId == 'bdb100skrvGrid1'){				
				directMasterStore1.loadStoreRecords();				
			}
			var viewLocked = tab.getActiveTab().lockedGrid.getView();
			var viewNormal = tab.getActiveTab().normalGrid.getView();
			console.log("viewLocked : ",viewLocked);
			console.log("viewNormal : ",viewNormal);
			viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
			viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		}
	}); //End of Unilite.Main( {
};

</script>
