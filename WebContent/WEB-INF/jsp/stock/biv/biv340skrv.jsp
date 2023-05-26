<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="biv340skrv"  >

	<t:ExtComboStore comboType="BOR120" comboCode="B001"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B020" /> 				<!-- 계정구분 -->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList"/>		<!--창고-->
	<t:ExtComboStore comboType="OU" storeId="whList" />     <!--창고(전체) -->
	<t:ExtComboStore comboType="AU" comboCode="B035" />					<!-- 수불타입 -->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	/**
	 *   Model 정의
	 * @type
	 */

	Unilite.defineModel('Biv340skrvModel', {
	    fields: [
	    	{name: 'ITEM_ACCOUNT'		, text:'<t:message code="system.label.inventory.account" default="계정"/>'				, type:'string'},
	    	{name: 'ACCOUNT1'			, text:'<t:message code="system.label.inventory.accountcode" default="계정코드"/>'			, type:'string'},
	    	{name: 'DIV_CODE'			, text:'<t:message code="system.label.inventory.division" default="사업장"/>'			, type:'string'},
	    	{name: 'WH_CODE'			, text:'<t:message code="system.label.inventory.warehouse" default="창고"/>'				, type:'string'},
	    	{name: 'ITEM_CODE'			, text:'<t:message code="system.label.inventory.item" default="품목"/>'			, type:'string'},
	    	{name: 'ITEM_NAME'			, text:'<t:message code="system.label.inventory.itemname" default="품목명"/>'			, type:'string'},
	    	{name: 'SPEC'				, text:'<t:message code="system.label.inventory.spec" default="규격"/>'				, type:'string'},
	    	{name: 'STOCK_UNIT'			, text:'<t:message code="system.label.inventory.inventoryunit" default="재고단위"/>'			, type:'string'},
	    	{name: 'INOUT_TYPE'			, text:'<t:message code="system.label.inventory.classfication" default="구분"/>'				, type:'string'},
	    	{name: 'FINAL_RECEIPT_DATE'	, text:'<t:message code="system.label.inventory.finalreceiptdate" default="최종입고일"/>'		, type:'string'},
	    	{name: 'FINAL_ISSUE_DATE'	, text:'<t:message code="system.label.inventory.finalissuedate" default="최종출고일"/>'			, type:'string'},
	    	{name: 'FINAL_INOUT_DATE'	, text:'<t:message code="system.label.inventory.finalinoutdate" default="최종수불일"/>'			, type:'string'},
	    	{name: 'STAGNATION_DAY'	    , text:'<t:message code="system.label.inventory.stagnationday" default="정체일"/>'			    , type:'int'},
	    	{name: 'AVERAGE_P'			, text:'<t:message code="system.label.inventory.price" default="단가"/>'				, type:'uniUnitPrice'},
	    	{name: 'STOCK_Q'			, text:'<t:message code="system.label.inventory.inventoryqty" default="재고량"/>'			, type:'uniQty'},
	    	{name: 'STOCK_O'			, text:'<t:message code="system.label.inventory.inventoryamount" default="재고금액"/>'			, type:'uniPrice'}
		]
	});

	/**
	 * Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('biv340skrvMasterStore1',{
			model: 'Biv340skrvModel',
			uniOpt : {
            	isMaster: true,			// 상위 버튼 연결
            	editable: false,			// 수정 모드 사용
            	deletable:false,			// 삭제 가능 여부
	            useNavi : false			// prev | newxt 버튼 사용
	            	//비고(*) 사용않함
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {
                	   read: 'biv340skrvService.selectList'
                }
            }
			,loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();
				console.log( param );
				this.load({
					params : param
				});

			},
			groupField: 'ITEM_ACCOUNT'

	});


	/**
	 * 검색조건 (Search Panel)
	 * @type
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm',{
		collapsed: true,
		title: '<t:message code="system.label.inventory.searchconditon" default="검색조건"/>',
    	defaultType: 'uniSearchSubPanel',
    	listeners: {
        	collapse: function () {
            	panelResult.show();
        	},
        	expand: function() {
        		panelResult.hide();
        	}
    	},
		items: [{
			title: '<t:message code="system.label.inventory.basisinfo" default="기본정보"/>',
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
			    items: [{
					fieldLabel: '<t:message code="system.label.inventory.division" default="사업장"/>',
					name:'DIV_CODE',
					xtype: 'uniCombobox',
					comboType:'BOR120',
					comboCode:'B001',
					allowBlank:false,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('DIV_CODE', newValue);
						}
					}
				},{
					fieldLabel: '<t:message code="system.label.inventory.account" default="계정"/>',
					name: 'ITEM_ACCOUNT',
					xtype: 'uniCombobox',
					comboType: 'AU',
					comboCode: 'B020',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('ITEM_ACCOUNT', newValue);
						}
					}
				},{
					fieldLabel: '<t:message code="system.label.inventory.warehouse" default="창고"/>',
					name: 'WH_CODE',
					xtype: 'uniCombobox',
					store: Ext.data.StoreManager.lookup('whList'),
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('WH_CODE', newValue);
						}
					}
				},{
					fieldLabel: '<t:message code="system.label.inventory.basisdate" default="기준일"/>',
					xtype: 'uniDatefield',
					name: 'BASE_DATE',
					value: UniDate.get('today'),
					allowBlank:false,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('BASE_DATE', newValue);
						}
					}
				}]
			},{
			title: '<t:message code="system.label.inventory.additionalinfo" default="추가정보"/>',
				itemId: 'search_panel2',
		       	layout: {type: 'uniTable', columns: 1},
		       	defaultType: 'uniTextfield',
				    items: [{
						fieldLabel: '<t:message code="system.label.inventory.majorgroup" default="대분류"/>',
						name: 'ITEM_LEVEL1',
						xtype: 'uniCombobox',
						store: Ext.data.StoreManager.lookup('itemLeve1Store'),
						child: 'ITEM_LEVEL2'
					},{
						fieldLabel: '<t:message code="system.label.inventory.middlegroup" default="중분류"/>',
						name: 'ITEM_LEVEL2',
						xtype: 'uniCombobox',
						store: Ext.data.StoreManager.lookup('itemLeve2Store'),
						child: 'ITEM_LEVEL3'
					},{
						fieldLabel: '<t:message code="system.label.inventory.minorgroup" default="소분류"/>',
						name: 'ITEM_LEVEL3',
						xtype: 'uniCombobox',
						store: Ext.data.StoreManager.lookup('itemLeve3Store')
				}]
			}]
    });

    var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel: '<t:message code="system.label.inventory.division" default="사업장"/>',
			name:'DIV_CODE',
			xtype: 'uniCombobox',
			comboType:'BOR120',
			comboCode:'B001',
			allowBlank:false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.inventory.account" default="계정"/>',
			name: 'ITEM_ACCOUNT',
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'B020',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('ITEM_ACCOUNT', newValue);
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.inventory.warehouse" default="창고"/>',
			name: 'WH_CODE',
			xtype: 'uniCombobox',
			store: Ext.data.StoreManager.lookup('whList'),
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('WH_CODE', newValue);
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.inventory.basisdate" default="기준일"/>',
			xtype: 'uniDatefield',
			name: 'BASE_DATE',
			value: UniDate.get('today'),
			allowBlank:false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('BASE_DATE', newValue);
				}
			}
		}]
	});		// end of var panelResult = Unilite.createSearchForm('resultForm',{

    /**
     * Master Grid1 정의(Grid Panel)
     * @type
     */

    var masterGrid = Unilite.createGrid('biv340skrvGrid1', {
    	region: 'center' ,
        layout : 'fit',
        store : directMasterStore1,
        uniOpt:{	expandLastColumn: true,
        			useRowNumberer: true,
                    useMultipleSorting: true
        },
/*         tbar: [{
        	text:'상세보기',
        	handler: function() {
        		var record = masterGrid.getSelectedRecord();
	        	if(record) {
	        		openDetailWindow(record);
	        	}
        	}
        }], */
    	store: directMasterStore1,
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary',
    		showSummaryRow: true
    	},{
    		id: 'masterGridTotal',
    		ftype: 'uniSummary',
    		showSummaryRow: true
    	}],
        columns:  [
        	{dataIndex: 'ITEM_ACCOUNT',	width: 100},
			{dataIndex: 'ACCOUNT1',		width: 86, hidden:true },
			{dataIndex: 'DIV_CODE',		width: 73, hidden:true },
			{dataIndex: 'WH_CODE',		width: 100},
			{dataIndex: 'ITEM_CODE',	width: 100},
			{dataIndex: 'ITEM_NAME',	width: 240},
			{dataIndex: 'SPEC',			width: 200},
			{dataIndex: 'STOCK_UNIT',	width: 100,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                    return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.inventory.accounttotal" default="계정계"/>', '<t:message code="system.label.inventory.total" default="총계"/>');
            }},
			//{dataIndex: 'INOUT_TYPE',	width: 80},
			{dataIndex: 'FINAL_RECEIPT_DATE',	width: 100, align: 'center'},
			{dataIndex: 'FINAL_ISSUE_DATE'  ,	width: 100, align: 'center'},
			{dataIndex: 'FINAL_INOUT_DATE'  ,	width: 100, align: 'center', hidden:true},
			{dataIndex: 'STAGNATION_DAY'    ,	width: 80, align: 'right'},
			{dataIndex: 'AVERAGE_P',	width: 120},
			{dataIndex: 'STOCK_Q',		width: 120, summaryType: 'sum'},
			{dataIndex: 'STOCK_O',		width: 120, summaryType: 'sum'}
		]
    });


    Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult
			]
		},
			panelSearch
		],
		id  : 'biv340skrvApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',true);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown : function()	{

			masterGrid.getStore().loadStoreRecords();
/* //			var viewLocked = masterGrid.lockedGrid.getView();
			var viewNormal = masterGrid.getView();
//		    viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
//		    viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
		    viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
		    viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true); */

		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		}
	});

};


</script>
