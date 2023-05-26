<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="btr150ukrv"  >
	<t:ExtComboStore comboType="BOR120"  pgmId="btr150ukrv"/> 			<!-- 사업장 -->  
	<t:ExtComboStore comboType="AU" comboCode="B024" /> <!- 담당자-->
	<t:ExtComboStore comboType="AU" comboCode="A" /> 	<!- 창고-->
	<t:ExtComboStore comboType="AU" comboCode="A" /> 	<!- 창고Cell-->
	<t:ExtComboStore comboType="AU" comboCode="B013" /> <!- 단위-->
	<t:ExtComboStore comboType="AU" comboCode="B021" /> <!- 양불구분-->
	<t:ExtComboStore comboType="AU" comboCode="B020" /> <!- 품목계정-->
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
	Unilite.defineModel('btr150ukrvModel', {
	    fields: [  	  
	    	{name: 'COMP_CODE_OUT'				,text: '<t:message code="system.label.inventory.companycode" default="법인코드"/>'				,type: 'string'},
		    {name: 'DIV_CODE_OUT'				,text: '<t:message code="system.label.inventory.issuedivision" default="출고사업장"/>'				,type: 'string'},
		    {name: 'INOUT_NUM_OUT'				,text: '<t:message code="system.label.inventory.issueno" default="출고번호"/>'				,type: 'string'},
		    {name: 'INOUT_SEQ_OUT'				,text: '<t:message code="system.label.inventory.seq" default="순번"/>'					,type: 'string'},
		    {name: 'ITEM_CODE_OUT'				,text: '출고품목'				,type: 'string'},
		    {name: 'ITEM_NAME_OUT'				,text: '출고품목명'				,type: 'string'},
		    {name: 'INOUT_PRSN_OUT'				,text: '출고담당자'				,type: 'string'},
		    {name: 'WH_CODE_OUT'				,text: '출고창고코드'			,type: 'string'},
		    {name: 'WH_NAME_OUT'				,text: '<t:message code="system.label.inventory.issuewarehouse" default="출고창고"/>'				,type: 'string'},
		    {name: 'WH_CELL_CODE_OUT'			,text: '출고창고Cell코드'		,type: 'string'},
		    {name: 'WH_CELL_NAME_OUT'			,text: '<t:message code="system.label.inventory.issuewarehousecell" default="출고창고Cell"/>'			,type: 'string'},  
		    {name: 'LOT_NO_OUT'					,text: '<t:message code="system.label.inventory.lotno" default="LOT번호"/>'				    ,type: 'string'},
		    {name: 'MAKE_DATE_OUT'				,text: '제조일자'				,type: 'uniDate'},
		    {name: 'GOOD_STOCK_Q'				,text: '<t:message code="system.label.inventory.goodstockqty" default="양품재고량"/>'				,type: 'string'},
		    {name: 'BAD_STOCK_Q'				,text: '<t:message code="system.label.inventory.defectinventoryqty" default="불량재고량"/>'				,type: 'string'},
		    {name: 'ITEM_STATUS_OUT'			,text: '양불'					,type: 'string'},
		    {name: 'INOUT_Q_OUT'				,text: '<t:message code="system.label.inventory.issueqty" default="출고량"/>'				    ,type: 'uniQty'},
		    {name: 'COMP_CODE_IN'				,text: '<t:message code="system.label.inventory.companycode" default="법인코드"/>'				,type: 'string'},
		    {name: 'DIV_CODE_IN'				,text: '<t:message code="system.label.inventory.receiptdivision" default="입고사업장"/>'				,type: 'string'},
		    {name: 'INOUT_NUM_IN'				,text: '<t:message code="system.label.inventory.receiptno" default="입고번호"/>'				,type: 'string'},
		    {name: 'INOUT_SEQ_IN'				,text: '입고순번'				,type: 'string'},
		    {name: 'ITEM_CODE_IN'				,text: '입고품목'				,type: 'string'},
		    {name: 'ITEM_NAME_IN'				,text: '입고품목명'				,type: 'string'},
		    {name: 'INOUT_PRSN_IN'				,text: '입고담당자'				,type: 'string'},
		    {name: 'WH_CODE_IN'					,text: '<t:message code="system.label.inventory.receiptwarehouse" default="입고창고"/>'				,type: 'string'},
		    {name: 'WH_NAME_IN'					,text: '<t:message code="system.label.inventory.receiptwarehouse" default="입고창고"/>'				,type: 'string'},  
		    {name: 'WH_CELL_CODE_IN'			,text: '<t:message code="system.label.inventory.receiptwarehousecell2" default="입고창고Cell"/>'			,type: 'string'},
		    {name: 'WH_CELL_NAME_IN'			,text: '입고창고Cell명'			,type: 'string'},
		    {name: 'LOT_NO_IN'					,text: '<t:message code="system.label.inventory.lotno" default="LOT번호"/>'				    ,type: 'string'},
		    {name: 'MAKE_DATE_IN'				,text: '제조일자'				,type: 'uniDate'},
		    {name: 'ITEM_STATUS_IN'				,text: '<t:message code="system.label.inventory.gooddefecttype" default="양불구분"/>'				,type: 'string'},
		    {name: 'INOUT_Q_IN'					,text: '<t:message code="system.label.inventory.receiptqty" default="입고량"/>'				    ,type: 'uniQty'},
		    {name: 'REMARK'						,text: '<t:message code="system.label.inventory.remarks" default="비고"/>'					,type: 'string'}
		    
		]
	}); //End of Unilite.defineModel('btr150ukrvModel', {

	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('btr150ukrvMasterStore1',{
		model: 'btr150ukrvModel',
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
            	read: 'btr150ukrvService.selectList1'                	
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
		title: '<t:message code="system.label.inventory.searchconditon" default="검색조건"/>',
        defaultType: 'uniSearchSubPanel',
		items: [{	
			title: '<t:message code="system.label.inventory.basisinfo" default="기본정보"/>', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items: [{
				fieldLabel: '재고이동일',
				xtype: 'uniDatefield',
				value: UniDate.get('year'),
				allowBlank: false
			},{
				fieldLabel: '재고이동번호',
				name:'',	
				xtype: 'uniTextfield',
	        	allowBlank:false
			},{
	        	fieldLabel: '<t:message code="system.label.inventory.issuedivision" default="출고사업장"/>',
	        	name: 'DIV_CODE', 
	        	xtype: 'uniCombobox', 
	        	comboType: 'BOR120',
	        	allowBlank:false
	        },{
	        	fieldLabel: '출고담당자',
	        	name: '', 
	        	xtype: 'uniCombobox', 
	        	comboType: 'AU',
	        	comboCode:'B024'
	        },{
	        	fieldLabel: '<t:message code="system.label.inventory.issuewarehouse" default="출고창고"/>',
	        	name: '', 
	        	xtype: 'uniCombobox', 
	        	comboType: 'AU',
	        	comboCode:'A'
	        },{
	        	fieldLabel: '<t:message code="system.label.inventory.receiptdivision" default="입고사업장"/>',
	        	name: 'DIV_CODE', 
	        	xtype: 'uniCombobox', 
	        	comboType: 'BOR120',
	        	allowBlank:false,
	        	value:'01'
	        },{
	        	fieldLabel: '입고담당자',
	        	name: '', 
	        	xtype: 'uniCombobox', 
	        	comboType: 'AU',
	        	comboCode:'B024'
	        },{
	        	fieldLabel: '<t:message code="system.label.inventory.receiptwarehouse" default="입고창고"/>',
	        	name: '', 
	        	xtype: 'uniCombobox', 
	        	comboType: 'AU',
	        	comboCode:'A'
	        }]
		}]
    }); //End of var panelSearch = Unilite.createSearchForm('searchForm',{
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid1 = Unilite.createGrid('btr150ukrvGrid1', {
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
    
    	store: directMasterStore1,
    	features: [ 
    		{id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
    	    {id: 'masterGridTotal',    ftype: 'uniSummary', 	    showSummaryRow: false} 
    	],
        columns: [   
        	{text:'이동전(출고)' , 
        		columns: [
					{dataIndex: 'COMP_CODE_OUT'						, width: 66 , hidden: true},
					{dataIndex: 'INOUT_SEQ_OUT'						, width: 33 }, 
					{dataIndex: 'DIV_CODE_OUT'						, width: 73 }, 
					{dataIndex: 'INOUT_NUM_OUT'						, width: 66 , hidden: true},
					{dataIndex: 'ITEM_CODE_OUT'						, width: 100 },
					{dataIndex: 'ITEM_NAME_OUT'						, width: 120 }, 
					{dataIndex: 'INOUT_PRSN_OUT'					, width: 73 },
					{dataIndex: 'WH_CODE_OUT'						, width: 73 , hidden: true},
					{dataIndex: 'WH_NAME_OUT'						, width: 73 },
					{dataIndex: 'WH_CELL_CODE_OUT'					, width: 73 , hidden: true}, 
					{dataIndex: 'WH_CELL_NAME_OUT'					, width: 73 , hidden: true},
					{dataIndex: 'LOT_NO_OUT'						, width: 73 }, 
					{dataIndex: 'MAKE_DATE_OUT'						, width: 73 },
					{dataIndex: 'GOOD_STOCK_Q'						, width: 66 }, 
					{dataIndex: 'BAD_STOCK_Q'						, width: 66 },
					{dataIndex: 'ITEM_STATUS_OUT'					, width: 66 }, 
					{dataIndex: 'INOUT_Q_OUT'						, width: 66 },
					{dataIndex: 'COMP_CODE_IN'						, width: 66  , hidden: true}
        	]},
			{text:'이동후(입고)' , 
        		columns: [
					{dataIndex: 'DIV_CODE_IN'						, width: 73 },
					{dataIndex: 'INOUT_NUM_IN'						, width: 66  , hidden: true}, 
					{dataIndex: 'INOUT_SEQ_IN'						, width: 66  , hidden: true},
					{dataIndex: 'ITEM_CODE_IN'						, width: 100 , hidden: true}, 
					{dataIndex: 'ITEM_NAME_IN'						, width: 120 , hidden: true},
					{dataIndex: 'INOUT_PRSN_IN'						, width: 73}, 
					{dataIndex: 'WH_CODE_IN'						, width: 73 , hidden: true},
					{dataIndex: 'WH_NAME_IN'						, width: 73 }, 
					{dataIndex: 'WH_CELL_CODE_IN'					, width: 73 , hidden: true},
					{dataIndex: 'WH_CELL_NAME_IN'					, width: 73 , hidden: true}, 
					{dataIndex: 'LOT_NO_IN'							, width: 73 },
					{dataIndex: 'MAKE_DATE_IN'						, width: 73 }, 
					{dataIndex: 'ITEM_STATUS_IN'					, width: 53 ,  hidden: true},
					{dataIndex: 'INOUT_Q_IN'						, width: 66 }, 
					{dataIndex: 'REMARK'							, width: 200 }
			]}
		] 
    });	//End of   var masterGrid1 = Unilite.createGrid('btr150ukrvGrid1', {

    Unilite.Main( {
		border: false,
		borderItems:[ 
		 		 masterGrid1
				,panelSearch
		], 
		id: 'btr150ukrvApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',true);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown : function() {		
			var activeTabId = tab.getActiveTab().getId();			
			if(activeTabId == 'btr150ukrvGrid1'){				
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
