<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bpr700ukrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B015" /> <!-- 거래처구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B020" /> <!-- 품목계정 -->
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
	Unilite.defineModel('Bpr700ukrvModel1', {
	    fields: [  	 
			{name: 'CUSTOM_CODE'	       	,text: '거래처코드'		,type: 'string'},  	 
			{name: 'CUSTOM_NAME'	       	,text: '거래처명'		,type: 'string'}
		]  
	});		//End of Unilite.defineModel('Bpr700ukrvModel', {
	
	Unilite.defineModel('Bpr700ukrvModel2', {
	    fields: [  	 
			{name: 'COMP_CODE'      	       	,text: '<t:message code="system.label.base.companycode" default="법인코드"/>'		,type: 'string'},  	 
			{name: 'DIV_CODE'       	       	,text: '사업장코드'		,type: 'string'},  	 
			{name: 'CUSTOM_CODE'    	       	,text: '거래처코드'		,type: 'string'},  	 
			{name: 'ITEM_CODE'      	       	,text: '<t:message code="system.label.base.itemcode" default="품목코드"/>'		,type: 'string'},  	 
			{name: 'ITEM_NAME'      	       	,text: '<t:message code="system.label.base.itemname" default="품목명"/>'		,type: 'string'},  	 
			{name: 'SPEC'           	       	,text: '<t:message code="system.label.base.spec" default="규격"/>'			,type: 'string'},  	 
			{name: 'ORDER_UNIT'     	       	,text: '단위'			,type: 'string'},  	 
			{name: 'VAT_RATE'       	       	,text: '부가세율'		,type: 'string'},  	 
			{name: 'START_DATE'     	       	,text: '시작일자'		,type: 'uniDate'},  	 
			{name: 'STOP_DATE'      	       	,text: '종료일자'		,type: 'uniDate'},  	 
			{name: 'USE_YN'         	       	,text: '<t:message code="system.label.base.use" default="사용"/>'		,type: 'string'},  	 
			{name: 'REMARK'         	       	,text: '<t:message code="system.label.base.remarks" default="비고"/>'			,type: 'string'},  	 
			{name: 'UPDATE_DB_USER' 	       	,text: '수정자'		,type: 'string'},  	 
			{name: 'UPDATE_DB_TIME' 	       	,text: '수정일'		,type: 'uniDate'}
		]  
	});	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */			
	
	var directMasterStore1 = Unilite.createStore('bpr700ukrvMasterStore1',{
			model: 'Bpr700ukrvModel1',
			uniOpt: {
            	isMaster: false,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable: false,			// 삭제 가능 여부 
	            useNavi: false				// prev | next 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {			
                	   read: 'bpr700ukrvService.selectList1'                	
                }
            },
            loadStoreRecords: function()	{
				var param= Ext.getCmp('searchForm').getValues();			
				console.log( param );
				this.load({
					params: param
				});			
			},
			groupField: ''
	});		// End of var directMasterStore1 = Unilite.createStore('bpr700ukrvMasterStore1',{
	
	var directMasterStore2 = Unilite.createStore('bpr700ukrvMasterStore2',{
			model: 'Bpr700ukrvModel2',
			uniOpt: {
            	isMaster: false,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable: false,			// 삭제 가능 여부 
	            useNavi: false				// prev | next 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {			
                	   read: 'bpr700ukrvService.selectList1'                	
                }
            },
            loadStoreRecords: function()	{
				var param= Ext.getCmp('searchForm').getValues();			
				console.log( param );
				this.load({
					params: param
				});
			},
			groupField: ''	
	});		// End of var directMasterStore2 = Unilite.createStore('bpr700ukrvMasterStore2',{

	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
 	
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '<t:message code="system.label.base.searchconditon" default="검색조건"/>',		
        defaultType: 'uniSearchSubPanel',
		items: [{	
			title: '<t:message code="system.label.base.basisinfo2" default="기본정보"/>', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items : [{
				fieldLabel: '<t:message code="system.label.base.division" default="사업장"/>',
				name:'DIV_CODE',
				xtype: 'uniCombobox',
				comboType:'BOR120',
				allowBlank:false
			},{
				fieldLabel: '거래처구분',
				name:'',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'B015'
			},
				Unilite.popup('CUST',{ 
					fieldLabel: '거래처', 
					textFieldWidth: 170, 
					validateBlank: false
				}),
			{
					xtype: 'radiogroup',		            		
					fieldLabel: '세율검색',						            		
					id: 'rdoSelect',
					items: [{
						boxLabel: '현재적용세율', 
						width:120, 
						name: 'rdoSelect', 
						inputValue: 'A', 
						checked: true
					},{
						boxLabel: '전체', 
						width:60, 
						name: 'rdoSelect', 
						inputValue: 'B'
					}]
			},{
				fieldLabel: '<t:message code="system.label.base.itemaccount" default="품목계정"/>',
				name:'',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'B020'
			},
				Unilite.popup('ITEM',{ 
					fieldLabel: '품목', 
					textFieldWidth: 170, 
					validateBlank: false
				})]
			}]
    });		// End of var panelSearch = Unilite.createSearchForm('searchForm',{    
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid1= Unilite.createGrid('bpr700ukrvGrid1', {
        layout:'fit',
        region:'center',
        uniOpt: {
			expandLastColumn: true
        },
        tbar: [{
			xtype: 'splitbutton',
			text: '이동...',
			iconCls : 'icon-referance',
			menu: Ext.create('Ext.menu.Menu', {
    			items: [{
     				text: '<t:message code="system.label.base.iteminfo" default="품목정보"/>'
    			}]
			})
        }],
    	store: directMasterStore1,
    	features: [{
    		id: 'masterGridSubTotal', 
    		ftype: 'uniGroupingsummary',
    		showSummaryRow: false 
    	},{
    		id: 'masterGridTotal',
    		ftype: 'uniSummary',
    		showSummaryRow: false
    	}],
        columns:  [
        	{dataIndex:'CUSTOM_CODE'	     	, width:100},
        	{dataIndex:'CUSTOM_NAME'	     	, width:300}

        ]             
    });		// End of v'DIV_CODE'     ilite.createGrid('bpr700ukrvGrid1', {
    
    /**
     * Master Grid2 정의(Grid Panel)
     * @type 
     */
	var masterGrid2= Unilite.createGrid('bpr700ukrvGrid2', {
		layout:'fit',
        region:'east',
        uniOpt: {
			expandLastColumn: true
        },
    	store: directMasterStore2,
    	features: [{
    		id: 'masterGridSubTotal', 
    		ftype: 'uniGroupingsummary',
    		showSummaryRow: false 
    	},{
    		id: 'masterGridTotal',
    		ftype: 'uniSummary',
    		showSummaryRow: false
    	}],
        columns:  [
        	{dataIndex:'COMP_CODE'      	     	, width:33,hidden:true},
        	{dataIndex:'DIV_CODE'       	     	, width:33,hidden:true},
        	{dataIndex:'CUSTOM_CODE'    	     	, width:33,hidden:true},
        	{dataIndex:'ITEM_CODE'      	     	, width:86},
        	{dataIndex:'ITEM_NAME'      	     	, width:100},
        	{dataIndex:'SPEC'           	     	, width:133},
        	{dataIndex:'ORDER_UNIT'     	     	, width:60},
        	{dataIndex:'VAT_RATE'       	     	, width:100},
        	{dataIndex:'START_DATE'     	     	, width:73},
        	{dataIndex:'STOP_DATE'      	     	, width:73},
        	{dataIndex:'USE_YN'         	     	, width:60},
        	{dataIndex:'REMARK'         	     	, width:133},
        	{dataIndex:'UPDATE_DB_USER' 	     	, width:0,hidden:true},
        	{dataIndex:'UPDATE_DB_TIME' 	     	, width:0,hidden:true}
    	] 
	});		// End of var masterGrid2= Unilite.createGrid('bpr700ukrvGrid2', {
    
    Unilite.Main({ 

borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid1, masterGrid2
			]	
		}		
		,panelSearch
		],
		id: 'bpr700ukrvApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown: function()	{	
			Unilite.messageBox("준비중입니다");
			
			/*
			var activeTabId = tab.getActiveTab().getId();			
			if(activeTabId == 'bpr700ukrvGrid1'){				
				directMasterStore1.loadStoreRecords();				
			}
			else if(activeTabId == 'bpr700ukrvGrid2'){
				directMasterStore2.loadStoreRecords();				
			}
			var viewLocked = tab.getActiveTab().lockedGrid.getView();
			var viewNormal = tab.getActiveTab().normalGrid.getView();
			
			console.log("viewLocked : ",viewLocked);
			console.log("viewNormal : ",viewNormal);
			
			viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
			viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);	
			*/
		}	
	});		// End of Unilite.Main({
};
</script>
