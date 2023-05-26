<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bpr120ukrv" >
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

	Unilite.defineModel('Bpr120ukrvModel', {
	    fields: [
	    	{name: 'COMP_CODE'      			, text: 'COMP_CODE'			, type: 'string'},
	    	{name: 'ITEM_CODE'      			, text: '<t:message code="system.label.base.itemcode" default="품목코드"/>'				, type: 'string'},
	    	{name: 'ITEM_NAME'      			, text: '<t:message code="system.label.base.itemname" default="품목명"/>'				, type: 'string'},
	    	{name: 'SPEC'						, text: '<t:message code="system.label.base.spec" default="규격"/>'				, type: 'string'},
	    	{name: 'CIR_PERIOD_YN'				, text: '제조일자관리여부'		, type: 'string'},
	    	{name: 'BARCODE'        			, text: '<t:message code="system.label.base.barcode" default="바코드"/>'				, type: 'string'},
	    	{name: 'UPDATE_DB_USER' 			, text: 'UPDATE_DB_USER'	, type: 'string'},
	    	{name: 'UPDATE_DB_TIME' 			, text: 'UPDATE_DB_TIME'	, type: 'string'}
	    ]
	});//End of Unilite.defineModel('Bpr120ukrvModel', {
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('bpr120ukrvMasterStore1', {
		model: 'Bpr120ukrvModel',
		uniOpt: {
        	isMaster: false,			// 상위 버튼 연결 
        	editable: false,			// 수정 모드 사용 
        	deletable: false,			// 삭제 가능 여부 
            useNavi: false			// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {			
				read: 'bpr120ukrvService.selectList'                	
			}
		},
		loadStoreRecords: function(){
			var param = Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params: param
			});
				
		},
		groupField: ''
			
	});//End of var directMasterStore1 = Unilite.createStore('bpr120ukrvMasterStore1', {
	
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
			items: [
			    	Unilite.popup('DIV_PUMOK',{ 
			    		fieldLabel: '<t:message code="system.label.base.itemcode" default="품목코드"/>', 
			    		textFieldWidth: 170, 
			    		validateBlank: false, 
			    		popupWidth: 710
			    	}),
					Unilite.popup('DIV_PUMOK',{ 
						fieldLabel: '~',
						valueFieldName: 'DIV_PUMOK_CODE2', 
						textFieldName: 'DIV_PUMOK_NAME2', 
						textFieldWidth:170, 
						validateBlank: false,  
						popupWidth: 710
					}),
				{ 
					fieldLabel: '<t:message code="system.label.base.majorgroup" default="대분류"/>' ,
					name: 'TXTLV_L1' , 
					xtype: 'uniCombobox' ,  
					store: Ext.data.StoreManager.lookup('itemLeve1Store') , 
					child: 'TXTLV_L2'
				},{ 
					fieldLabel: '<t:message code="system.label.base.middlegroup" default="중분류"/>' ,
					name: 'TXTLV_L2' , 
					xtype: 'uniCombobox' , 
					store: Ext.data.StoreManager.lookup('itemLeve2Store') , 
					child: 'TXTLV_L3'
				},{ 
					fieldLabel: '<t:message code="system.label.base.minorgroup" default="소분류"/>',
					name: 'TXTLV_L3' , 
					xtype: 'uniCombobox' ,  
					store: Ext.data.StoreManager.lookup('itemLeve3Store')
				},{					
	    			fieldLabel: '<t:message code="system.label.base.barcode" default="바코드"/>',
	    			name:'',
	    			xtype: 'uniTextfield'
	    		},{
					xtype: 'radiogroup',		            		
					fieldLabel: '바코드 존재여부',						            		
					id: 'rdoSelect',
					items: [{
						boxLabel: '전체', 
						width:60, 
						name: 'rdoSelect', 
						inputValue: 'A', 
						checked: true
					},{
						boxLabel: '예', 
						width:60, 
						name: 'rdoSelect', 
						inputValue: 'Y'
					},{
						boxLabel: '아니오', 
						width:60, 
						name: 'rdoSelect', 
						inputValue: 'N'
					}]
				}]
		}]
	});//End of var panelSearch = Unilite.createSearchForm('searchForm', {
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
	var masterGrid = Unilite.createGrid('bpr120ukrvGrid1', {
    	// for tab    	
		layout: 'fit',
		region: 'center',
		uniOpt: {
			expandLastColumn: true
        },
        features: [{
        	id: 'masterGridSubTotal', 
        	ftype: 'uniGroupingsummary', 
        	showSummaryRow: false
		},{
			id: 'masterGridTotal', 
			ftype: 'uniSummary', 
			showSummaryRow: false
		}],
    	store: directMasterStore1,
        columns: [
        	{dataIndex: 'COMP_CODE'     			, width:100,hidden:true},
        	{dataIndex: 'ITEM_CODE'     			, width:120},
        	{dataIndex: 'ITEM_NAME'     			, width:266},
        	{dataIndex: 'SPEC'						, width:120},
        	{dataIndex: 'CIR_PERIOD_YN'				, width:113},
        	{dataIndex: 'BARCODE'       			, width:133},
        	{dataIndex: 'UPDATE_DB_USER'			, width:100,hidden:true},
        	{dataIndex: 'UPDATE_DB_TIME'			, width:100,hidden:true}
		] 
    });//End of var masterGrid = Unilite.createGrid('bpr120ukrvGrid1', {  
	
	Unilite.Main( {
		borderItems:[ 
	 		 masterGrid,
			panelSearch
		],  	
		id: 'bpr120ukrvApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown: function() {			
			masterGrid.getStore().loadStoreRecords();
			var viewLocked = masterGrid.lockedGrid.getView();
			var viewNormal = masterGrid.normalGrid.getView();
			console.log("viewLocked: ", viewLocked);
			console.log("viewNormal: ", viewNormal);
		    viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
		    viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
		    viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
		    viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden()) {
				as.show();
			}else {
				as.hide()
			}
		}
	});

};


</script>
