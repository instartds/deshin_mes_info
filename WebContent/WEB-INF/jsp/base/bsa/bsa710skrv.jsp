<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bsa710skrv"  >
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
	Unilite.defineModel('bsa710skrvModel', {
	    fields: [  	  
	    	{name: 'PART_NAME'				,text: '부문'					,type: 'string'},
		    {name: 'SUB_CODE'				,text: 'KPI 지표코드'			,type: 'string'},
		    {name: 'REF_CODE3'				,text: '관리항목'				,type: 'string'},
		    {name: 'MAX_TARGET'				,text: '최대목표치'				,type: 'string'},
		    {name: 'MIN_TARGET'				,text: '최소목표치'				,type: 'string'},
		    {name: 'CODE_NAME' 				,text: '집계기준'				,type: 'string'},
		    {name: 'CNT1' 					,text: '1월'					,type: 'string'},
		    {name: 'CNT2' 					,text: '2월'					,type: 'string'},
		    {name: 'CNT3'					,text: '3월'					,type: 'string'},
		    {name: 'CNT4'					,text: '4월'					,type: 'string'},
		    {name: 'CNT5' 					,text: '5월'					,type: 'string'},
		    {name: 'CNT6' 					,text: '6월'					,type: 'string'},
		    {name: 'CNT7' 					,text: '7월'					,type: 'string'},
		    {name: 'CNT8' 					,text: '8월'					,type: 'string'},
		    {name: 'CNT9'					,text: '9월'					,type: 'string'},
		    {name: 'CNT10'					,text: '10월'				,type: 'string'},
		    {name: 'CNT11' 					,text: '11월'				,type: 'string'},
		    {name: 'CNT12' 					,text: '12월'				,type: 'string'}

		]
	}); //End of Unilite.defineModel('bsa710skrvModel', {

	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('bsa710skrvMasterStore1',{
		model: 'bsa710skrvModel',
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
            	read: 'bsa710skrvService.selectList1'                	
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
	        	fieldLabel: '조회월', 
				xtype: 'uniDateRangefield', 
				startFieldName: 'ORDER_DATE_FR',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				width: 315,
				startDate: UniDate.get('startOfMonth'),
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
    
    var masterGrid1 = Unilite.createGrid('bsa710skrvGrid1', {
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
			{dataIndex: 'PART_NAME'					, width: 100}, 
			{dataIndex: 'SUB_CODE'	 				, width: 66 , hidden: true},
			{dataIndex: 'REF_CODE3'	 				, width: 133}, 
			{dataIndex: 'MAX_TARGET'				, width: 86},
			{dataIndex: 'MIN_TARGET'				, width: 86}, 
			{dataIndex: 'CODE_NAME'  				, width: 300},
			{dataIndex: 'CNT1' 		 				, width: 73}, 
			{dataIndex: 'CNT2' 						, width: 73},
			{dataIndex: 'CNT3'						, width: 73}, 
			{dataIndex: 'CNT4'		 				, width: 73},
			{dataIndex: 'CNT5' 		 				, width: 73}, 
			{dataIndex: 'CNT6' 						, width: 73},
			{dataIndex: 'CNT7' 						, width: 73}, 
			{dataIndex: 'CNT8' 		 				, width: 73},
			{dataIndex: 'CNT9'		 				, width: 73}, 
			{dataIndex: 'CNT10'						, width: 73},
			{dataIndex: 'CNT11' 					, width: 73}, 
			{dataIndex: 'CNT12' 	 				, width: 73}
		] 
    });	//End of   var masterGrid1 = Unilite.createGrid('bsa710skrvGrid1', {

    Unilite.Main( {
		border: false,
		borderItems:[ 
		 		 masterGrid1
				,panelSearch
		], 
		id: 'bsa710skrvApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',true);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown : function() {		
			var activeTabId = tab.getActiveTab().getId();			
			if(activeTabId == 'bsa710skrvGrid1'){				
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
