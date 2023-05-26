<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bsa750skrv"  >
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
	Unilite.defineModel('bsa750skrvModel', {
	    fields: [  	  
	    	{name: 'MODULE_NAME'			,text: '업무그룹'				,type: 'string'},
		    {name: 'PGM_NAME'				,text: '업무명'				,type: 'string'},
		    {name: 'TABLE_NAME'				,text: '테이블명'				,type: 'string'},
		    {name: 'INSERT_USER'			,text: '담당자'				,type: 'string'},
		    {name: 'DEPT_NAME'				,text: '이전건수'				,type: 'string'},
		    {name: 'DAY01'	   				,text: 'Day01'				,type: 'string'},
		    {name: 'DAY02'	   				,text: 'Day02'				,type: 'string'},
		    {name: 'DAY03'	   				,text: 'Day03'				,type: 'string'},
		    {name: 'DAY04'					,text: 'Day04'				,type: 'string'},
		    {name: 'DAY05'					,text: 'Day05'				,type: 'string'},
		    {name: 'DAY06'					,text: 'Day06'				,type: 'string'},
		    {name: 'DAY07'					,text: 'Day07'				,type: 'string'},
		    {name: 'DAY08'					,text: 'Day08'				,type: 'string'},
		    {name: 'DAY09'					,text: 'Day09'				,type: 'string'},
		    {name: 'DAY10'					,text: 'Day10'				,type: 'string'},
		    {name: 'DAY11'					,text: 'Day11'				,type: 'string'},
		    {name: 'DAY12'					,text: 'Day12'				,type: 'string'},
		    {name: 'DAY13'					,text: 'Day13'				,type: 'string'},
		    {name: 'DAY14'					,text: 'Day14'				,type: 'string'},
		    {name: 'DAY15'					,text: 'Day15'				,type: 'string'},
		    {name: 'DAY16'					,text: 'Day16'				,type: 'string'},
		    {name: 'DAY17'					,text: 'Day17'				,type: 'string'},
		    {name: 'DAY18'					,text: 'Day18'				,type: 'string'},
		    {name: 'DAY19'					,text: 'Day19'				,type: 'string'},
		    {name: 'DAY20'					,text: 'Day20'				,type: 'string'},
		    {name: 'DAY21'					,text: 'Day21'				,type: 'string'},
		    {name: 'DAY22'					,text: 'Day22'				,type: 'string'},
		    {name: 'DAY23'					,text: 'Day23'				,type: 'string'},
		    {name: 'DAY24'					,text: 'Day24'				,type: 'string'},
		    {name: 'DAY25'					,text: 'Day25'				,type: 'string'},
		    {name: 'DAY26'					,text: 'Day26'				,type: 'string'},
		    {name: 'DAY27'					,text: 'Day27'				,type: 'string'},
		    {name: 'DAY28'					,text: 'Day28'				,type: 'string'},
		    {name: 'DAY29'					,text: 'Day29'				,type: 'string'},
		    {name: 'DAY30'					,text: 'Day30'				,type: 'string'},
		    {name: 'DAY31'					,text: 'Day31'				,type: 'string'},
		    {name: 'TOT_COUNT'	 			,text: '총건수'				,type: 'string'},
		    {name: 'TOT_DATA'	 			,text: '목표건수'				,type: 'string'},
		    {name: 'START_DATE'				,text: '계획시작일'				,type: 'uniDate'},
		    {name: 'END_DATE'	 			,text: '계획종료일'				,type: 'uniDate'},
		    {name: 'UP_PGM_DIV'				,text: '위치'					,type: 'string'},
		    {name: 'MAN_USER'				,text: '책임자'				,type: 'string'},
		    {name:  'DAY00'	 				,text: '부서'					,type: 'string'}
		]
	}); //End of Unilite.defineModel('bsa750skrvModel', {

	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('bsa750skrvMasterStore1',{
		model: 'bsa750skrvModel',
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
            	read: 'bsa750skrvService.selectList1'                	
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
	        	fieldLabel: '기준일', 
				xtype: 'uniDateRangefield', 
				startFieldName: 'ORDER_DATE_FR',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				width: 315,
				startDate: UniDate.get('startOfMonth')
		    },{
	        	fieldLabel: '업무그룹', 
				xtype: 'uniTextfield'
		    }]
		}]
    }); //End of var panelSearch = Unilite.createSearchForm('searchForm',{
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid1 = Unilite.createGrid('bsa750skrvGrid1', {
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
			{dataIndex: 'MODULE_NAME'		, width: 66},
			{dataIndex: 'PGM_NAME'			, width: 120},
			{dataIndex: 'TABLE_NAME'		, width: 66},
			{dataIndex: 'INSERT_USER'		, width: 100}, 
			{dataIndex: 'DEPT_NAME'			, width: 80},
			{dataIndex: 'DAY01'	   			, width: 55}, 
			{dataIndex: 'DAY02'	   			, width: 55},
			{dataIndex: 'DAY03'	   			, width: 55}, 
			{dataIndex: 'DAY04'				, width: 55},
			{dataIndex: 'DAY05'				, width: 55}, 
			{dataIndex: 'DAY06'				, width: 55},
			{dataIndex: 'DAY07'				, width: 55}, 
			{dataIndex: 'DAY08'				, width: 55},
			{dataIndex: 'DAY09'				, width: 55},
			{dataIndex: 'DAY10'				, width: 55},
			{dataIndex: 'DAY11'				, width: 55},
			{dataIndex: 'DAY12'				, width: 55},
			{dataIndex: 'DAY13'				, width: 55}, 
			{dataIndex: 'DAY14'				, width: 55},
			{dataIndex: 'DAY15'				, width: 55}, 
			{dataIndex: 'DAY16'				, width: 55},
			{dataIndex: 'DAY17'				, width: 55}, 
			{dataIndex: 'DAY18'				, width: 55},
			{dataIndex: 'DAY19'				, width: 55}, 
			{dataIndex: 'DAY20'				, width: 55},
			{dataIndex: 'DAY21'				, width: 55}, 
			{dataIndex: 'DAY22'				, width: 55},
			{dataIndex: 'DAY23'				, width: 55}, 
			{dataIndex: 'DAY24'				, width: 55},
			{dataIndex: 'DAY25'				, width: 55},
			{dataIndex: 'DAY26'				, width: 55},
			{dataIndex: 'DAY27'				, width: 55}, 
			{dataIndex: 'DAY28'				, width: 55},
			{dataIndex: 'DAY29'				, width: 55}, 
			{dataIndex: 'DAY30'				, width: 55},
			{dataIndex: 'DAY31'				, width: 55}, 
			{dataIndex: 'TOT_COUNT'			, width: 60},
			{dataIndex: 'TOT_DATA'			, width: 80}, 
			{dataIndex: 'START_DATE'		, width: 80},
			{dataIndex: 'END_DATE'			, width: 80}, 
			{dataIndex: 'UP_PGM_DIV'		, width: 146},
			{dataIndex: 'MAN_USER'			, width: 80},
			{dataIndex: 'DAY00'	 			, width: 66}
			
		] 
    });	//End of   var masterGrid1 = Unilite.createGrid('bsa750skrvGrid1', {

    Unilite.Main( {
		border: false,
		borderItems:[ 
		 		 masterGrid1
				,panelSearch
		], 
		id: 'bsa750skrvApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',true);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown : function() {		
			var activeTabId = tab.getActiveTab().getId();			
			if(activeTabId == 'bsa750skrvGrid1'){				
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
