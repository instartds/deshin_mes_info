<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="sco120ukrv"  >
	<t:ExtComboStore comboType="BOR120"  pgmId="sco120ukrv"/> 			<!-- 사업장 -->  
	<t:ExtComboStore comboType="AU" comboCode="S010" /> <!--영업/수금담당자-->
	<t:ExtComboStore comboType="AU" comboCode="S017" /> <!--수금유형-->
	<t:ExtComboStore comboType="AU" comboCode="B064" /> <!--어음유형-->
	<t:ExtComboStore comboType="AU" comboCode="A022" /> <!--증빙유형-->
	<t:ExtComboStore comboType="AU" comboCode="B004" /> <!--화폐단위-->
	<t:ExtComboStore comboType="AU" comboCode="S075" /> <!--미수금참조구분-->
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
	Unilite.defineModel('sco120ukrvModel', {
	    fields: [  	  
	    	{name: 'COLLECT_SEQ'     			,text: '<t:message code="system.label.sales.seq" default="순번"/>'			,type: 'string'},
		    {name: 'REF_GUBUN'       			,text: '<t:message code="system.label.sales.classfication" default="구분"/>'			,type: 'string'},
		    {name: 'DISPLAY_PUB_NUM' 			,text: '<t:message code="system.label.sales.number" default="번호"/>'			,type: 'string'},
		    {name: 'CUSTOM_CODE'     			,text: '<t:message code="system.label.sales.client" default="고객"/>'			,type: 'string'},
		    {name: 'CUSTOM_NAME'     			,text: '<t:message code="system.label.sales.clientname" default="고객명"/>'		    ,type: 'string'},
		    {name: 'UN_COLLECT_AMT'  			,text: '<t:message code="system.label.sales.arbalance" default="미수잔액"/>'		,type: 'string'},
		    {name: 'UN_PRE_COLL_AMT' 			,text: '<t:message code="system.label.sales.advancebalance" default="선수금잔액"/>'		,type: 'string'},  
		    {name: 'COLLECT_TYPE'    			,text: '<t:message code="system.label.sales.collectiontype" default="수금유형"/>'		,type: 'string'},
		    {name: 'COLLECT_AMT'     			,text: '<t:message code="system.label.sales.collectionamount" default="수금액"/>'		,type: 'string'},
		    {name: 'AD_REFUND_NUM'   			,text: '<t:message code="system.label.sales.advancedno" default="선수금번호"/>'		,type: 'string'},
		    {name: 'AD_REFUND_AMT'   			,text: '<t:message code="system.label.sales.advancedrefundamount" default="선수반제액"/>'		,type: 'string'},
		    {name: 'NOTE_NUM'        			,text: '<t:message code="system.label.sales.noteno" default="어음번호"/>'		,type: 'string'},
		    {name: 'NOTE_CREDIT_RATE'			,text: '<t:message code="system.label.sales.authorizedrate" default="인정율(%)"/>'	    ,type: 'string'},
		    {name: 'NOTE_TYPE'       			,text: '<t:message code="system.label.sales.noteclass" default="어음구분"/>'		,type: 'string'},
		    {name: 'PUB_CUST_CD'     			,text: '<t:message code="system.label.sales.publishofficecode" default="발행기관CD"/>'	,type: 'string'},
		    {name: 'PUB_CUST_NM'     			,text: '<t:message code="system.label.sales.publishoffice" default="발행기관"/>'		,type: 'string'},
		    {name: 'NOTE_PUB_DATE'   			,text: '<t:message code="system.label.sales.publishdate" default="발행일"/>'		,type: 'string'},
		    {name: 'PUB_PRSN'        			,text: '<t:message code="system.label.sales.publisher" default="발행인"/>'		    ,type: 'string'},
		    {name: 'NOTE_DUE_DATE'   			,text: '<t:message code="system.label.sales.duedate" default="만기일"/>'		,type: 'string'},
		    {name: 'DISHONOR_DATE'   			,text: '<t:message code="system.label.sales.dishonoreddate" default="부도일"/>'		,type: 'string'},
		    {name: 'PUB_ENDOSER'     			,text: '<t:message code="system.label.sales.endorser" default="배서인"/>'		    ,type: 'string'},
		    {name: 'PROJECT_NO'      			,text: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>'	,type: 'string'},
		    {name: 'SAVE_CODE'       			,text: '<t:message code="system.label.sales.bankaccountno" default="통장번호"/>'		,type: 'string'},
		    {name: 'SAVE_NAME'       			,text: '<t:message code="system.label.sales.bankaccountname" default="통장명"/>'		    ,type: 'string'},
		    {name: 'DED_CUSTOM_CODE' 			,text: '<t:message code="system.label.sales.dedcustom" default="공제거래처"/>'		,type: 'string'},
		    {name: 'DED_CUSTOM_NAME' 			,text: '<t:message code="system.label.sales.dedcustomname" default="공제거래처명"/>'	,type: 'string'},
		    {name: 'REMARK'          			,text: '<t:message code="system.label.sales.remarks" default="비고"/>'			,type: 'string'}
		    
		]
	}); //End of Unilite.defineModel('sco120ukrvModel', {

	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('sco120ukrvMasterStore1',{
		model: 'sco120ukrvModel',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: false,			// 수정 모드 사용 
            deletable: false,			// 삭제 가능 여부 
	        useNavi : false			// prev | next 버튼 사용
        },
        autoLoad: false,
        proxy: {
        	type: 'direct',
            api: {			
            	read: 'sco120ukrvService.selectList1'                	
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
		title: '<t:message code="system.label.sales.searchconditon" default="검색조건"/>',
        defaultType: 'uniSearchSubPanel',
		items: [{	
			title: '<t:message code="system.label.sales.basisinfo" default="기본정보"/>', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items: [{
	        	fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
	        	name: 'DIV_CODE', 
	        	xtype: 'uniCombobox', 
	        	comboType: 'BOR120',
	        	allowBlank:false
	        },{
				fieldLabel: '<t:message code="system.label.sales.collectiondate" default="수금일"/>',
				xtype: 'uniDatefield',
				value: UniDate.get('today'),
				allowBlank: false
			}, 
				Unilite.popup('CUSTOMER',{ 
					fieldLabel: '<t:message code="system.label.sales.client" default="고객"/>', 
					 
					validateBlank:false
			}),{
				fieldLabel: '<t:message code="system.label.sales.collectionno" default="수금번호"/>',
				name:'', 	
				xtype: 'uniNumberfield'
			},{
				fieldLabel: '<t:message code="system.label.sales.collectioncharge" default="수금담당"/>',
				name:'',	
				xtype: 'uniCombobox', 
				comboType:'AU',
				comboCode:'S010',
				allowBlank: false
			},{
				fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
				name:'', 	
				xtype: 'uniNumberfield'
			},{
				fieldLabel: '<t:message code="system.label.sales.slipdate" default="전표일"/>',
				name:'', 	
				xtype: 'uniNumberfield'
			},{
				fieldLabel: '<t:message code="system.label.sales.number" default="번호"/>',
				name:'', 	
				xtype: 'uniNumberfield'
			}
		]},{
			title: '<t:message code="system.label.sales.collectiondetails" default="수금내역"/>', 	
			collapsed: true,
			itemId: 'search_panel2',
	       	layout: {type: 'uniTable', columns: 1},
	       	defaultType: 'uniTextfield',
		    items: [{
				fieldLabel: '<t:message code="system.label.sales.collectiontype" default="수금유형"/>',
				name:'',	
				xtype: 'uniCombobox', 
				comboType:'AU',
				comboCode:'S017',
				allowBlank: false
			},
				Unilite.popup('BANK',{ 
					fieldLabel: '<t:message code="system.label.sales.bankaccountno" default="통장번호"/>', 
					 
					validateBlank:false
			}),
				Unilite.popup('AGENT_CUST',{ 
					fieldLabel: '<t:message code="system.label.sales.dedcustom" default="공제거래처"/>', 
					 
					validateBlank:false
			}),{
				fieldLabel: '<t:message code="system.label.sales.collectiontotalamount" default="수금총액"/>',
				name:'', 	
				xtype: 'uniNumberfield'
			}]
		}]
    }); //End of var panelSearch = Unilite.createSearchForm('searchForm',{
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid1 = Unilite.createGrid('sco120ukrvGrid1', {
    	layout : 'fit',
    	region:'center',
        store : directMasterStore1, 
        uniOpt:{	expandLastColumn: true,
        			useRowNumberer: true,
                    useMultipleSorting: true
        },
        tbar: [{
        	text:'<t:message code="system.label.sales.detailsview" default="상세보기"/>',
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
        	{dataIndex: 'COLLECT_SEQ'      			, width: 66 ,locked:true }, 				
			{dataIndex: 'REF_GUBUN'        			, width: 66 ,locked:true},
			{dataIndex: 'DISPLAY_PUB_NUM'  			, width: 66 ,locked:true}, 				
			{dataIndex: 'CUSTOM_CODE'      			, width: 66 ,locked:true}, 	
			{dataIndex: 'CUSTOM_NAME'      			, width: 66 ,locked:true}, 				
			{dataIndex: 'UN_COLLECT_AMT'   			, width: 66 ,locked:true}, 	
			{dataIndex: 'UN_PRE_COLL_AMT'  			, width: 66 ,locked:true}, 				
			{dataIndex: 'COLLECT_TYPE'     			, width: 66 }, 				
			{dataIndex: 'COLLECT_AMT'      			, width: 66 }, 
			{text:'<t:message code="system.label.sales.advancedrefundinfo" default="선수금반제정보"/>' , 
        		columns: [
				{dataIndex: 'AD_REFUND_NUM'    			, width: 73 }, 				
				{dataIndex: 'AD_REFUND_AMT'    			, width: 73 } 	
			]},
			{text:'<t:message code="system.label.sales.manageiteminfo" default="관리항목정보"/>' , 
        		columns: [
					{dataIndex: 'NOTE_NUM'         			, width: 66 }, 				
					{dataIndex: 'NOTE_CREDIT_RATE' 			, width: 73 }, 	
					{dataIndex: 'NOTE_TYPE'        			, width: 66 }, 				
					{dataIndex: 'PUB_CUST_CD'      			, width: 80 , hidden:true}, 	
					{dataIndex: 'PUB_CUST_NM'      			, width: 66 }, 				
					{dataIndex: 'NOTE_PUB_DATE'    			, width: 66 }, 	
					{dataIndex: 'PUB_PRSN'         			, width: 66 }, 				
					{dataIndex: 'NOTE_DUE_DATE'    			, width: 66 }, 	
					{dataIndex: 'DISHONOR_DATE'    			, width: 66 , hidden: true}, 				
					{dataIndex: 'PUB_ENDOSER'      			, width: 66 }, 	
					{dataIndex: 'PROJECT_NO'       			, width: 66 }, 				
					{dataIndex: 'SAVE_CODE'        			, width: 66 }, 	
					{dataIndex: 'SAVE_NAME'        			, width: 66 , hidden: true}, 				
					{dataIndex: 'DED_CUSTOM_CODE'  			, width: 76 , hidden: true }, 	
					{dataIndex: 'DED_CUSTOM_NAME'  			, width: 86 } 	
				]},
			{dataIndex: 'REMARK'           			, width: 66 }
			
	
			
		] 
    });	//End of   var masterGrid1 = Unilite.createGrid('sco120ukrvGrid1', {

    Unilite.Main( {
		border: false,
		borderItems:[ 
		 		 masterGrid1
				,panelSearch
		], 
		id: 'sco120ukrvApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',true);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown : function() {		
			var activeTabId = tab.getActiveTab().getId();			
			if(activeTabId == 'sco120ukrvGrid1'){				
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
