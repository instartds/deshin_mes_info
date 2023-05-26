<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bsa700ukrv"  >
		<t:ExtComboStore comboType= "BOR120"  /> 		 <!-- 사업장 -->
		<t:ExtComboStore comboType="AU" comboCode="B101" /> <!-- KPI 부문 -->
		<t:ExtComboStore comboType="AU" comboCode="B102" /> <!-- KPI 항목 -->
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
	Unilite.defineModel('bsa700ukrvModel', {
	    fields: [  	  
	    	{name: 'PART_CODE'				,text: '부문코드'				,type: 'string'},
		    {name: 'PART_NAME'				,text: '부문'					,type: 'string'},
		    {name: 'KPI_ID'					,text: '관리항목코드'			,type: 'string'},
		    {name: 'KPI_NM'					,text: '관리항목'			,type: 'string'},
		    {name: 'DIV_CODE'				,text: '사업장코드'				,type: 'string'},
		    {name: 'DIV_NAME' 				,text: '<t:message code="system.label.base.division" default="사업장"/>'				,type: 'string'},
		    {name: 'MIN_TARGET' 			,text: '최소목표치'				,type: 'string'},
		    {name: 'MAX_TARGET' 			,text: '최대목표치'				,type: 'string'},
		    {name: 'REF_CODE2'				,text: '최대값'				,type: 'string'},
		    {name: 'APPL_YEAR'				,text: '적용년도'				,type: 'string'},
		    {name: 'APPL_DATE' 				,text: '적용일'				,type: 'uniDate'},
		    {name: 'CODE_NAME' 				,text: '집계기준'				,type: 'string'},
		    {name: 'COMP_CODE' 				,text: '<t:message code="system.label.base.companycode" default="법인코드"/>'				,type: 'string'},
		    {name: 'UPDATE_DB_USER'			,text: '수정자'				,type: 'string'},
		    {name: 'UPDATE_DB_TIME'			,text: '수정일'				,type: 'uniDate'}
		]
	}); //End of Unilite.defineModel('bsa700ukrvModel', {

	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('bsa700ukrvMasterStore1',{
		model: 'bsa700ukrvModel',
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
            	read: 'bsa700ukrvService.selectList1'                	
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
		 		fieldLabel: '적용일',
		 		
		 		xtype: 'uniDatefield',
		 		name: '',
		 		allowBlank:false
			},{
        		fieldLabel: '부문', 
        		name:'', 
        		xtype: 'uniCombobox', 
        		comboType:'AU', 
        		comboCode:'B101'
            },{
		        fieldLabel: '<t:message code="system.label.base.division" default="사업장"/>',
		        name:'', 
		        xtype: 'uniCombobox', 
		        comboType:'BOR120'
		    },{
        		fieldLabel: '관리항목', 
        		name:'', 
        		xtype: 'uniCombobox', 
        		comboType:'AU', 
        		comboCode:'B102'
        	},{
        		fieldLabel: '~', 
        		name:'', 
        		xtype: 'uniCombobox', 
        		comboType:'AU', 
        		comboCode:'B102'
            }]
		}]
    }); //End of var panelSearch = Unilite.createSearchForm('searchForm',{
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid1 = Unilite.createGrid('bsa700ukrvGrid1', {
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
			{dataIndex: 'PART_CODE'					, width: 66 , hidden: true},
			{dataIndex: 'PART_NAME'					, width: 166},
			{dataIndex: 'KPI_ID'					, width: 66 , hidden: true},
			{dataIndex: 'KPI_NM'					, width: 233}, 
			{dataIndex: 'DIV_CODE'					, width: 66 , hidden: true},
			{dataIndex: 'DIV_NAME' 					, width: 153}, 
			{dataIndex: 'MIN_TARGET' 				, width: 133},
			{dataIndex: 'MAX_TARGET' 				, width: 133}, 
			{dataIndex: 'REF_CODE2'					, width: 133},
			{dataIndex: 'APPL_YEAR'					, width: 66 , hidden: true}, 
			{dataIndex: 'APPL_DATE' 				, width: 66 , hidden: true},
			{dataIndex: 'CODE_NAME' 				, width: 73 , hidden: true}, 
			{dataIndex: 'COMP_CODE' 				, width: 66 , hidden: true},
			{dataIndex: 'UPDATE_DB_USER'			, width: 66 , hidden: true},
			{dataIndex: 'UPDATE_DB_TIME'			, width: 66 , hidden: true}
			
		] 
    });	//End of   var masterGrid1 = Unilite.createGrid('bsa700ukrvGrid1', {

    Unilite.Main( {
		border: false,
		borderItems:[ 
		 		 masterGrid1
				,panelSearch
		], 
		id: 'bsa700ukrvApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',true);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown : function() {		
			var activeTabId = tab.getActiveTab().getId();			
			if(activeTabId == 'bsa700ukrvGrid1'){				
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
