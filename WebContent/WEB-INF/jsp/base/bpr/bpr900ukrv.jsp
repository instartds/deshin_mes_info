<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bpr900ukrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
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
	Unilite.defineModel('Bpr900ukrvModel1', {
	    fields: [  	 
			{name: 'COMP_CODE'			       	,text: '<t:message code="system.label.base.companycode" default="법인코드"/>'		,type: 'string'},  	 
			{name: 'DIV_CODE'			       	,text: '<t:message code="system.label.base.division" default="사업장"/>'		,type: 'string'},  	 
			{name: 'OPTION_NUM'			       	,text: 'ORDER NO.'	,type: 'string'},  	 
			{name: 'PROD_ITEM_CODE'		       	,text: '수주품번'		,type: 'string'},  	 
			{name: 'ITEM_NAME'			       	,text: '수주품명'		,type: 'string'},  	 
			{name: 'SPEC'				       	,text: '<t:message code="system.label.base.spec" default="규격"/>'			,type: 'string'},  	 
			{name: 'REMARK'				       	,text: 'OPTION명'	,type: 'string'},  	 
			{name: 'CHILD_ITEM_CODE'	       	,text: '자품목코드'		,type: 'string'},  	 
			{name: 'OLD_PATH_CODE'		       	,text: 'PATH정보'		,type: 'string'},  	 
			{name: 'PATH_CODE'			       	,text: 'PATH정보'		,type: 'string'},  	 
			{name: 'START_DATE'			       	,text: '시작일'		,type: 'uniDate'},  	 
			{name: 'STOP_DATE'			       	,text: '종료일'		,type: 'uniDate'},  	 
			{name: 'INSERT_DB_USER'		       	,text: '작성자'		,type: 'string'},  	 
			{name: 'INSERT_DB_TIME'		       	,text: '작성시간'		,type: 'string'},  	 
			{name: 'UPDATE_DB_USER'		       	,text: '수정자'		,type: 'string'},  	 
			{name: 'UPDATE_DB_TIME'		       	,text: '수정시간'		,type: 'string'}
		]  
	});		//End of Unilite.defineModel('Bpr900ukrvModel', {
	Unilite.defineModel('Bpr900ukrvModel2', {
	    fields: [  	 
			{name: 'COMP_CODE'			       	,text: '<t:message code="system.label.base.companycode" default="법인코드"/>'		,type: 'string'},  	 
			{name: 'DIV_CODE'			       	,text: '<t:message code="system.label.base.division" default="사업장"/>'		,type: 'string'},  	 
			{name: 'SEQ'				       	,text: '<t:message code="system.label.base.seq" default="순번"/>'			,type: 'string'},  	 
			{name: 'PROD_ITEM_CODE'		       	,text: '모품목코드'		,type: 'string'},  	 
			{name: 'OPTION_NUM'			       	,text: 'OPTION번호'	,type: 'string'},  	 
			{name: 'CHILD_ITEM_CODE'	       	,text: '구성품번'		,type: 'string'},  	 
			{name: 'ITEM_NAME'			       	,text: '구성품번'		,type: 'string'},  	 
			{name: 'SPEC'				       	,text: '<t:message code="system.label.base.spec" default="규격"/>'			,type: 'string'},  	 
			{name: 'STOCK_UNIT'			       	,text: '단위'			,type: 'string'},  	 
			{name: 'OLD_PATH_CODE'		       	,text: 'PATH정보'		,type: 'string'},  	 
			{name: 'PATH_CODE'			       	,text: 'PATH정보'		,type: 'string'},  	 
			{name: 'UNIT_Q'				       	,text: '원단위량'		,type: 'uniQty'},  	 
			{name: 'PROD_UNIT_Q'		       	,text: '모품목기준수'	,type: 'string'},  	 
			{name: 'LOSS_RATE'			       	,text: 'LOSS율'		,type: 'string'},  	 
			{name: 'UNIT_P1'			       	,text: '재료비'		,type: 'string'},  	 
			{name: 'UNIT_P2'			       	,text: '노무비'		,type: 'string'},  	 
			{name: 'UNIT_P3'			       	,text: '경비'			,type: 'string'},  	 
			{name: 'MAN_HOUR'			       	,text: '표준공수'		,type: 'string'},  	 
			{name: 'USE_YN'				       	,text: '<t:message code="system.label.base.use" default="사용"/>'			,type: 'string'},  	 
			{name: 'BOM_YN'				       	,text: '구성여부'		,type: 'string'},  	 
			{name: 'START_DATE'			       	,text: '구성시작일'		,type: 'uniDate'},  	 
			{name: 'STOP_DATE'			       	,text: '구성종료일'		,type: 'uniDate'},  	 
			{name: 'REMARK'				       	,text: '<t:message code="system.label.base.remarks" default="비고"/>'			,type: 'string'},  	 
			{name: 'INSERT_DB_USER'		       	,text: '수정자'		,type: 'string'},  	 
			{name: 'INSERT_DB_TIME'		       	,text: '수정시간'		,type: 'string'},  	 
			{name: 'UPDATE_DB_USER'		       	,text: '작성자'		,type: 'string'},  	 
			{name: 'UPDATE_DB_TIME'		       	,text: '작성시간'		,type: 'string'}
		]  
	});		//End of Unilite.defineModel('Bpr900ukrvModel', {

	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */			
	
	var directMasterStore1 = Unilite.createStore('bpr900ukrvMasterStore1',{
			model: 'Bpr900ukrvModel1',
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
                	   read: 'bpr900ukrvService.selectList1'                	
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
	});		// End of var directMasterStore1 = Unilite.createStore('bpr900ukrvMasterStore1',{
	
	var directMasterStore2 = Unilite.createStore('bpr900ukrvMasterStore2',{
			model: 'Bpr900ukrvModel2',
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
                	   read: 'bpr900ukrvService.selectList1'                	
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
	});		// End of var directMasterStore2 = Unilite.createStore('bpr900ukrvMasterStore2',{

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
				fieldLabel:'ORDER NO.',
				name:'',
				xtype:'uniTextfield'
			},{
				xtype: 'radiogroup',		            		
				fieldLabel: '폼목검색',						            		
				id: 'rdoSelect',
				items: [{
					boxLabel: '현재 적용품목', 
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
			},   
		        Unilite.popup('ITEM',{
		        fieldLabel: '수주품번',
		        validateBlank:false,
		        textFieldWidth:170
		    	})
		    ]
		}]
    });		// End of var panelSearch = Unilite.createSearchForm('searchForm',{    
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid1= Unilite.createGrid('bpr900ukrvGrid1', {
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
        	{dataIndex:'COMP_CODE'			     	, width:66,hidden:true },
        	{dataIndex:'DIV_CODE'			     	, width:66,hidden:true },
        	{dataIndex:'OPTION_NUM'			     	, width:100 },
        	{dataIndex:'PROD_ITEM_CODE'		     	, width:86 },
        	{dataIndex:'ITEM_NAME'			     	, width:120 },
        	{dataIndex:'SPEC'				     	, width:126 },
        	{dataIndex:'REMARK'				     	, width:100,hidden:true },
        	{dataIndex:'CHILD_ITEM_CODE'	     	, width:66,hidden:true },
        	{dataIndex:'OLD_PATH_CODE'		     	, width:66,hidden:true },
        	{dataIndex:'PATH_CODE'			     	, width:66,hidden:true },
        	{dataIndex:'START_DATE'			     	, width:10,hidden:true },
        	{dataIndex:'STOP_DATE'			     	, width:10,hidden:true },
        	{dataIndex:'INSERT_DB_USER'		     	, width:10,hidden:true },
        	{dataIndex:'INSERT_DB_TIME'		     	, width:10,hidden:true },
        	{dataIndex:'UPDATE_DB_USER'		     	, width:10,hidden:true },
        	{dataIndex:'UPDATE_DB_TIME'		     	, width:10,hidden:true }

        ]             
    });		// End of v'DIV_CODE'     ilite.createGrid('bpr900ukrvGrid1', {
    
    /**
     * Master Grid2 정의(Grid Panel)
     * @type 
     */
	var masterGrid2= Unilite.createGrid('bpr900ukrvGrid2', {
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
        	{dataIndex:'COMP_CODE'				    , width:66,hidden:true},
        	{dataIndex:'DIV_CODE'				    , width:66,hidden:true},
        	{dataIndex:'SEQ'					    , width:88},
        	{dataIndex:'PROD_ITEM_CODE'			    , width:80,hidden:true},
        	{dataIndex:'OPTION_NUM'				    , width:133,hidden:true},
        	{dataIndex:'CHILD_ITEM_CODE'		    , width:93},
        	{dataIndex:'ITEM_NAME'				    , width:93},
        	{dataIndex:'SPEC'					    , width:90},
        	{dataIndex:'STOCK_UNIT'				    , width:66},
        	{dataIndex:'OLD_PATH_CODE'			    , width:63,hidden:true},
        	{dataIndex:'PATH_CODE'				    , width:80,hidden:true},
        	{dataIndex:'UNIT_Q'					    , width:88},
        	{dataIndex:'PROD_UNIT_Q'			    , width:88},
        	{dataIndex:'LOSS_RATE'				    , width:66},
        	{dataIndex:'UNIT_P1'				    , width:66,hidden:true},
        	{dataIndex:'UNIT_P2'				    , width:66,hidden:true},
        	{dataIndex:'UNIT_P3'				    , width:56,hidden:true},
        	{dataIndex:'MAN_HOUR'				    , width:56,hidden:true},
        	{dataIndex:'USE_YN'					    , width:66},
        	{dataIndex:'BOM_YN'					    , width:66},
        	{dataIndex:'START_DATE'				    , width:88},
        	{dataIndex:'STOP_DATE'				    , width:88},
        	{dataIndex:'REMARK'					    , width:256},
        	{dataIndex:'INSERT_DB_USER'			    , width:10,hidden:true},
        	{dataIndex:'INSERT_DB_TIME'			    , width:10,hidden:true},
        	{dataIndex:'UPDATE_DB_USER'			    , width:10,hidden:true},
        	{dataIndex:'UPDATE_DB_TIME'			    , width:10,hidden:true}

    	] 
	});		// End of var masterGrid2= Unilite.createGrid('bpr900ukrvGrid2', {
    
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
		id: 'bpr900ukrvApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown: function()	{		
			
			var activeTabId = tab.getActiveTab().getId();			
			if(activeTabId == 'bpr900ukrvGrid1'){				
				directMasterStore1.loadStoreRecords();				
			}
			else if(activeTabId == 'bpr900ukrvGrid2'){
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
			}	
	});		// End of Unilite.Main({
};
</script>
