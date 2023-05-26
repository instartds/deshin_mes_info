<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bas351ukrv"  >
		<t:ExtComboStore comboType= "BOR120"  /> 		  <!-- 사업장 -->
		<t:ExtComboStore comboType= "AU" comboCode="S010"  /> <!-- 영업담당 -->
		<t:ExtComboStore comboType= "AU" comboCode="B010"  /> <!-- 사용여부 -->
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
	Unilite.defineModel('bas351ukrvModel', {
	    fields: [  	  
	    	{name: 'COMP_CODE'					,text: '<t:message code="system.label.base.companycode" default="법인코드"/>'					,type: 'string'},
		    {name: 'DIV_CODE'					,text: '<t:message code="system.label.base.division" default="사업장"/>'					,type: 'string'},
		    {name: 'CUSTOM_CODE'       			,text: '거래처코드'					,type: 'string'},
		    {name: 'CUSTOM_NAME'       			,text: '거래처명'					,type: 'string'},
		    {name: 'USER_ID'           			,text: '사용자ID'					,type: 'string'},
		    {name: 'USER_NAME'         			,text: '사용자명'					,type: 'string'},
		    {name: 'PASSDISP'          			,text: '비밀번호'					,type: 'string'},
		    {name: 'PASSWORD'          			,text: '비밀번호(저장용)'			,type: 'string'},
		    {name: 'USE_YN'            			,text: '<t:message code="system.label.base.useyn" default="사용여부"/>'					,type: 'string'},
		    {name: 'PWD_UPDATE_DB_TIME'			,text: 'PWD_UPDATE_DB_TIME'		,type: 'string'},
		    {name: 'UPDATE_DB_USER'    			,text: '수정자'					,type: 'string'},
		    {name: 'UPDATE_DB_TIME'    			,text: '수정일'					,type: 'string'}
		]
	
	}); //End of Unilite.defineModel('bas351ukrvModel', {

	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('bas351ukrvMasterStore1',{
		model: 'bas351ukrvModel',
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
            	read: 'bas351ukrvService.selectList1'                	
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
				fieldLabel: '<t:message code="system.label.base.division" default="사업장"/>',
				name:'DIV_CODE',
				xtype: 'uniCombobox',
				comboType:'BOR120',
				allowBlank:false
			},{
				fieldLabel: '영업담당',
				name:'',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'S010'
			},{
        		fieldLabel: '사용자 ID', 
        		name:'', 
        		xtype: 'uniTextfield'
            },{
        		fieldLabel: '사용자명', 
        		name:'', 
        		xtype: 'uniTextfield'
            }]
		}]
    }); //End of var panelSearch = Unilite.createSearchForm('searchForm',{
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid1 = Unilite.createGrid('bas351ukrvGrid1', {
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
			{dataIndex: 'COMP_CODE'			 					, width: 100, hidden: true}, 
			{dataIndex: 'DIV_CODE'			 	 				, width: 100, hidden: true},
			{dataIndex: 'CUSTOM_CODE'        	 				, width: 100},
			{dataIndex: 'CUSTOM_NAME'        					, width: 166}, 
			{dataIndex: 'USER_ID'            	 				, width: 100},
			{dataIndex: 'USER_NAME'          	 				, width: 133},
			{dataIndex: 'PASSDISP'           					, width: 120}, 
			{dataIndex: 'PASSWORD'           	 				, width: 73, hidden: true},
			{dataIndex: 'USE_YN'             					, width: 66}, 
			{dataIndex: 'PWD_UPDATE_DB_TIME' 	 				, width: 66, hidden: true},
			{dataIndex: 'UPDATE_DB_USER'     	 				, width: 100 },
			{dataIndex: 'UPDATE_DB_TIME'     					, width: 166}
			
		] 
    });	//End of   var masterGrid1 = Unilite.createGrid('bas351ukrvGrid1', {

    Unilite.Main( {
		border: false,
		borderItems:[ 
		 		 masterGrid1
				,panelSearch
		], 
		id: 'bas351ukrvApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',true);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown : function() {		
			var activeTabId = tab.getActiveTab().getId();			
			if(activeTabId == 'bas351ukrvGrid1'){				
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
