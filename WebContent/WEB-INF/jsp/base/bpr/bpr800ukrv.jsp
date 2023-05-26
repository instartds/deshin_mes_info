<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bpr800ukrv"  >
<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
<t:ExtComboStore comboType="AU" comboCode="B055" /> <!-- 고객분류 -->
<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />
<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />
<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />
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
	Unilite.defineModel('Bpr800ukrvModel1', {
	    fields: [  	 
			{name: 'COMP_CODE'     			       	,text: 'COMP_CODE'			,type: 'string'},  	 
			{name: 'DIV_CODE'      			       	,text: '<t:message code="system.label.base.division" default="사업장"/>'				,type: 'string'},  	 
			{name: 'BOX_BARCODE'				    ,text: 'BOX바코드'			,type: 'string'},  	 
			{name: 'TRNS_RATE'					    ,text: '입수'					,type: 'string'},  	 
			{name: 'ITEM_BARCODE'				    ,text: '제품바코드'				,type: 'string'},  	 
			{name: 'ITEM_CODE'     			       	,text: '제품코드'				,type: 'string'},  	 
			{name: 'ITEM_NAME'     			       	,text: '제품명'				,type: 'string'},  	 
			{name: 'CEO_TYPE'					    ,text: '대표제품구분'			,type: 'string'},  	 
			{name: 'GUBUN'						    ,text: 'GUBUN'				,type: 'string'},  	 
			{name: 'UPDATE_DB_USER'			       	,text: 'UPDATE_DB_USER'		,type: 'string'},  	 
			{name: 'UPDATE_DB_TIME'			       	,text: 'UPDATE_DB_TIME'		,type: 'string'}
		]  
	});		//End of Unilite.defineModel('Bpr800ukrvModel', {
	Unilite.defineModel('Bpr800ukrvModel2', {
	    fields: [  	 
			{name: 'COMP_CODE'     			       	,text: 'COMP_CODE'		,type: 'string'},  	 
			{name: 'DIV_CODE'      			       	,text: '<t:message code="system.label.base.division" default="사업장"/>'			,type: 'string'},  	 
			{name: 'BOX_BARCODE'				    ,text: 'BOX바코드'		,type: 'string'},  	 
			{name: 'TRNS_RATE'					   	,text: '입수'				,type: 'string'},  	 
			{name: 'ITEM_BARCODE'				   	,text: '제품바코드'			,type: 'string'},  	 
			{name: 'ITEM_CODE'     			       	,text: '제품코드'			,type: 'string'},  	 
			{name: 'ITEM_NAME'     			       	,text: '제품명'			,type: 'string'},  	 
			{name: 'CEO_TYPE'					    ,text: '대표제품구분'		,type: 'string'},  	 
			{name: 'GUBUN'						    ,text: 'GUBUN'			,type: 'string'},  	 
			{name: 'UPDATE_DB_USER'			       	,text: 'UPDATE_DB_USER'	,type: 'string'},  	 
			{name: 'UPDATE_DB_TIME'			       	,text: 'UPDATE_DB_TIME'	,type: 'string'}
		]  
	});		//End of Unilite.defineModel('Bpr800ukrvModel', {
	Unilite.defineModel('Bpr800ukrvModel3', {
	    fields: [  	 
			{name: 'COMP_CODE'     			       	,text: 'COMP_CODE'			,type: 'string'},  	 
			{name: 'DIV_CODE'      			       	,text: '<t:message code="system.label.base.division" default="사업장"/>'				,type: 'string'},  	 
			{name: 'BOX_BARCODE'				   	,text: 'BOX바코드'			,type: 'string'},  	 
			{name: 'TRNS_RATE'					    ,text: '입수'					,type: 'string'},  	 
			{name: 'ITEM_BARCODE'				    ,text: '제품바코드'				,type: 'string'},  	 
			{name: 'ITEM_CODE'     			       	,text: '제품코드'				,type: 'string'},  	 
			{name: 'CUSTOM_CODE'   			       	,text: '거래처'				,type: 'string'},  	 
			{name: 'CUSTOM_NAME'   			       	,text: '거래처명'				,type: 'string'},  	 
			{name: 'GUBUN'						    ,text: 'GUBUN'				,type: 'string'},  	 
			{name: 'UPDATE_DB_USER'			       	,text: 'UPDATE_DB_USER'		,type: 'string'},  	 
			{name: 'UPDATE_DB_TIME'			       	,text: 'UPDATE_DB_TIME'		,type: 'string'}
		]  
	});		//End of Unilite.defineModel('Bpr800ukrvModel', {

	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */			
	
	var directMasterStore1 = Unilite.createStore('bpr800ukrvMasterStore1',{
			model: 'Bpr800ukrvModel1',
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
                	   read: 'bpr800ukrvService.selectList1'                	
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
	});		// End of var directMasterStore1 = Unilite.createStore('bpr800ukrvMasterStore1',{
	
	var directMasterStore2 = Unilite.createStore('bpr800ukrvMasterStore2',{
			model: 'Bpr800ukrvModel2',
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
                	   read: 'bpr800ukrvService.selectList1'                	
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
	});		// End of var directMasterStore2 = Unilite.createStore('bpr800ukrvMasterStore2',{
	var directMasterStore3 = Unilite.createStore('bpr800ukrvMasterStore3',{
			model: 'Bpr800ukrvModel3',
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
                	   read: 'bpr800ukrvService.selectList1'                	
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
	});		// End of var directMasterStore2 = Unilite.createStore('bpr800ukrvMasterStore3',{
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
			},   
		        Unilite.popup('CUST',{
		        fieldLabel: '거래처',
		        validateBlank:false,
		        textFieldWidth:170
		    	}),
		    {
				fieldLabel:'BOX바코드',
				name:'',
				xtype:'uniTextfield'
			},
				Unilite.popup('ITEM',{
		        	fieldLabel: '품목',
		        	validateBlank:false,
		        	textFieldWidth:170
		    	})
		    
		    ]
		}]
    });		// End of var panelSearch = Unilite.createSearchForm('searchForm',{    
	var panelResult1 = Unilite.createSimpleForm('resultForm1',{
    	//padding:'10 10 10 10',
	    items: [{	
	    	xtype:'container',
	    	//padding:'0 5 5 5',
	        defaultType: 'uniTextfield',
	        layout: {
	        	type: 'uniTable',
	        	columns : 3,
	        	tableAttrs: {align:'right'}
	        },
	        items: [
				{ 
					fieldLabel: '<t:message code="system.label.base.majorgroup" default="대분류"/>',
					name: 'TXTLV_L1', 
					xtype: 'uniCombobox',  
					store: Ext.data.StoreManager.lookup('itemLeve1Store'), 
					child: 'TXTLV_L2',
					width:165
				},{ 
					fieldLabel: '<t:message code="system.label.base.middlegroup" default="중분류"/>',
					name: 'TXTLV_L2', 
					xtype: 'uniCombobox',  
					store: Ext.data.StoreManager.lookup('itemLeve2Store'), 
					child: 'TXTLV_L3',
					width:165
				},{ 
					fieldLabel: '<t:message code="system.label.base.minorgroup" default="소분류"/>',
					name: 'TXTLV_L3', 
					xtype: 'uniCombobox', 
					store: Ext.data.StoreManager.lookup('itemLeve3Store'),
					width:165
				}]
	    }]
    });
    
    var panelResult2 = Unilite.createSimpleForm('resultForm2',{
    	region: 'north',
    	//padding:'10 10 10 10',
	    items: [{	
	    	xtype:'container',
	    	//padding:'0 5 5 5',
	        defaultType: 'uniTextfield',
	        layout: {
	        	type: 'uniTable',
	        	columns : 3,
	        	tableAttrs: {align:'right'}
	        },
	        items: [
				{ 
					fieldLabel: '<t:message code="system.label.base.majorgroup" default="대분류"/>',
					name: 'TXTLV_L1', 
					xtype: 'uniCombobox',  
					store: Ext.data.StoreManager.lookup('itemLeve1Store'), 
					child: 'TXTLV_L2',
					width:165
				},{ 
					fieldLabel: '<t:message code="system.label.base.middlegroup" default="중분류"/>',
					name: 'TXTLV_L2', 
					xtype: 'uniCombobox',  
					store: Ext.data.StoreManager.lookup('itemLeve2Store'), 
					child: 'TXTLV_L3',
					width:165
				},{ 
					fieldLabel: '<t:message code="system.label.base.minorgroup" default="소분류"/>',
					name: 'TXTLV_L3', 
					xtype: 'uniCombobox', 
					store: Ext.data.StoreManager.lookup('itemLeve3Store'),
					width:165
				}]
	    }]
    });
    var panelResult3 = Unilite.createSimpleForm('resultForm3',{
    	region: 'center',
    	//padding:'10 10 10 10',
	    items: [{	
	    	xtype:'container',
	    	//padding:'0 5 5 5',
	        defaultType: 'uniTextfield',
	        layout: {
	        	type: 'uniTable',
	        	columns : 1,
	        	tableAttrs: {align:'right'}
	        },
	        items: [{
				fieldLabel: '고객분류', 
				name: '', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'B055'
			}]
	    }]
    });
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid1= Unilite.createGrid('bpr800ukrvGrid1', {
        layout:'fit',
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
        	{dataIndex:'COMP_CODE'     				     	, width:100,hidden:true},
        	{dataIndex:'DIV_CODE'      				     	, width:100,hidden:true},
        	{dataIndex:'BOX_BARCODE'				     	, width:133},
        	{dataIndex:'TRNS_RATE'					     	, width:100},
        	{dataIndex:'ITEM_BARCODE'				     	, width:133},
        	{dataIndex:'ITEM_CODE'     				     	, width:133},
        	{dataIndex:'ITEM_NAME'     				     	, width:166},
        	{dataIndex:'CEO_TYPE'					     	, width:100,hidden:true},
        	{dataIndex:'GUBUN'						     	, width:100,hidden:true},
        	{dataIndex:'UPDATE_DB_USER'				     	, width:10,hidden:true},
        	{dataIndex:'UPDATE_DB_TIME'				     	, width:10,hidden:true}

        ]             
    });		// End of v'DIV_CODE'     ilite.createGrid('bpr800ukrvGrid1', {
    
    /**
     * Master Grid2 정의(Grid Panel)
     * @type 
     */
	var masterGrid2= Unilite.createGrid('bpr800ukrvGrid2', {
		layout:'fit',
        region:'north',
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
        	{dataIndex:'COMP_CODE'     					    , width:100,hidden:true},
        	{dataIndex:'DIV_CODE'      					    , width:100,hidden:true},
        	{dataIndex:'BOX_BARCODE'					    , width:133,hidden:true},
        	{dataIndex:'TRNS_RATE'						    , width:100,hidden:true},
        	{dataIndex:'ITEM_BARCODE'					    , width:133},
        	{dataIndex:'ITEM_CODE'     					    , width:133},
        	{dataIndex:'ITEM_NAME'     					    , width:166},
        	{dataIndex:'CEO_TYPE'						    , width:100,hidden:true},
        	{dataIndex:'GUBUN'							    , width:10,hidden:true},
        	{dataIndex:'UPDATE_DB_USER'					    , width:10,hidden:true},
        	{dataIndex:'UPDATE_DB_TIME'					    , width:10,hidden:true}

    	] 
	});		// End of var masterGrid2= Unilite.createGrid('bpr800ukrvGrid2', {
    var masterGrid3= Unilite.createGrid('bpr800ukrvGrid3', {
		layout:'fit',
        region:'center',
        uniOpt: {
			expandLastColumn: true
        },
    	store: directMasterStore3,
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
        	{dataIndex:'COMP_CODE'     				    , width:100,hidden:true},
        	{dataIndex:'DIV_CODE'      				    , width:100,hidden:true},
        	{dataIndex:'BOX_BARCODE'					, width:133,hidden:true},
        	{dataIndex:'TRNS_RATE'						, width:100,hidden:true},
        	{dataIndex:'ITEM_BARCODE'					, width:133,hidden:true},
        	{dataIndex:'ITEM_CODE'     				    , width:133,hidden:true},
        	{dataIndex:'CUSTOM_CODE'   				    , width:133},
        	{dataIndex:'CUSTOM_NAME'   				    , width:166},
        	{dataIndex:'GUBUN'							, width:100,hidden:true},
        	{dataIndex:'UPDATE_DB_USER'				    , width:10,hidden:true},
        	{dataIndex:'UPDATE_DB_TIME'				    , width:10,hidden:true}

    	] 
	});		// End of var masterGrid3= Unilite.createGrid('bpr800ukrvGrid3', {
    Unilite.Main({ 

/*borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
			{
				items: [ 
				panelResult1, {xtype:'splitter'}, masterGrid1 
			]},{
				items: [ 
				panelResult2, {xtype:'splitter'}, masterGrid2 
			]},{
				items: [ 
				panelResult3, {xtype:'splitter'}, masterGrid3 
			]}
			
		]}		*/
    	borderItems:[{
			region: 'center',
			flex:2.5,
			layout: {type: 'vbox', align: 'stretch'},
			items:[
				panelResult1,
				masterGrid1
			]
		}, {
			layout: {type: 'vbox', align: 'stretch'},
			region: 'east',			
			flex:2.5,
			items:[
				panelResult2,masterGrid2,{xtype:'splitter'},
				panelResult3,{xtype:'splitter'},masterGrid3				
			]
		},panelSearch
		],
		id: 'bpr800ukrvApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown: function()	{		
			
			var activeTabId = tab.getActiveTab().getId();			
			if(activeTabId == 'bpr800ukrvGrid1'){				
				directMasterStore1.loadStoreRecords();				
			}
			else if(activeTabId == 'bpr800ukrvGrid2'){
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
