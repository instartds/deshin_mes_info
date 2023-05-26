<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="sbs032ukrv"  >

	<t:ExtComboStore comboType="BOR120"  pgmId="sbs032ukrv"/>           <!-- 사업장 -->    
    <t:ExtComboStore comboType="AU" comboCode="B020" /> <!--품목계정-->
    <t:ExtComboStore comboType="AU" comboCode="B004" /> <!--화폐단위-->
    <t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />
    <t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />
    <t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />
    
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;};  
#ext-element-3 {align:center}
</style>

<script type="text/javascript" >
function appMain() {
	Unilite.defineModel('sbs032ukrvModelMaster', {
	    fields: [
	    	{name: 'ITEM_CODE'		,text:'<t:message code="system.label.sales.item" default="품목"/>'			,type: 'string'},
		 	{name: 'ITEM_NAME'		,text:'<t:message code="system.label.sales.itemname" default="품목명"/>'		,type: 'string'},
		 	{name: 'SPEC'		 	,text:'<t:message code="system.label.sales.spec" default="규격"/>'			,type: 'string'},
		 	{name: 'STOCK_UNIT'		,text:'<t:message code="system.label.sales.inventoryunit" default="재고단위"/>',type: 'string'},
		 	{name: 'SALE_UNIT'	 	,text:'<t:message code="system.label.sales.salesunit" default="판매단위"/>'	,type: 'string'},
		 	{name: 'BASIS_P'		,text:'<t:message code="system.label.sales.sellingprice" default="판매단가"/>'	,type: 'uniUnitPrice'},
		 	{name: 'DOM_FORIGN'		,text:'<t:message code="system.label.sales.domforign" default="내외자구분"/>'	,type: 'string'},
		 	{name: 'ITEM_ACCOUNT'	,text:'<t:message code="system.label.sales.itemaccount" default="품목계정"/>'	,type: 'string'},
		 	{name: 'TRNS_RATE'	  	,text:'<t:message code="system.label.sales.containedqty" default="입수"/>'	,type: 'uniQty'},
		 	{name: 'DIV_CODE'       ,text:'<t:message code="system.label.sales.division" default="사업장"/>'      ,type: 'string'}
		]
	});
	
	Unilite.defineModel('sbs032ukrvModelDetail', {
	    fields: [
	    	{name: 'TYPE'			     ,text:'<t:message code="system.label.sales.type" default="유형"/>'		        ,type: 'string'},
		 	{name: 'ITEM_CODE'			 ,text:'<t:message code="system.label.sales.item" default="품목"/>'			,type: 'string'},
            {name: 'CUSTOM_CODE'         ,text:'<t:message code="system.label.sales.client" default="고객"/>'              ,type: 'string', allowBlank: false, maxLength: 8},
            {name: 'CUSTOM_NAME'         ,text:'<t:message code="system.label.sales.clientname" default="고객명"/>'            ,type: 'string', maxLength: 20},
            {name: 'CUSTOM_ITEM_CODE'    ,text:'<t:message code="system.label.sales.clientitem" default="고객품목"/>'          ,type: 'string', allowBlank: false, maxLength: 20},
            {name: 'CUSTOM_ITEM_NAME'    ,text:'<t:message code="system.label.sales.clientitemname" default="고객품명"/>'        ,type: 'string', maxLength: 40},
            {name: 'CUSTOM_ITEM_SPEC'    ,text:'<t:message code="system.label.sales.clientitemspec" default="고객품목규격"/>'      ,type: 'string', maxLength: 40},
            {name: 'ORDER_UNIT'          ,text:'<t:message code="system.label.sales.salesunit" default="판매단위"/>'          ,type: 'string', allowBlank: false, maxLength: 3},
            {name: 'BASIS_P'             ,text:'<t:message code="system.label.sales.basisprice" default="기준단가"/>'          ,type: 'uniUnitPrice', maxLength: 18},
            {name: 'ORDER_P'             ,text:'<t:message code="system.label.sales.sellingprice" default="판매단가"/>'          ,type: 'uniUnitPrice', maxLength: 18},
            {name: 'TRNS_RATE'           ,text:'<t:message code="system.label.sales.trnsrate" default="변환계수"/>'          ,type: 'uniER', maxLength: 12},
            {name: 'AGENT_P'             ,text:'<t:message code="system.label.sales.agentp" default="자거래처단가"/>'      ,type: 'uniUnitPrice', maxLength: 18},
            {name: 'APLY_START_DATE'     ,text:'<t:message code="system.label.sales.applystartdate" default="적용시작일"/>'        ,type: 'uniDate', allowBlank: false, maxLength: 8},
            {name: 'ORDER_PRSN'          ,text:'<t:message code="system.label.sales.orderprsn" default="구매담당자"/>'        ,type: 'string'},
            {name: 'MAKER_NAME'          ,text:'MAKER_NAME'          ,type: 'string'},
            {name: 'AGREE_DATE'          ,text:'AGREE_DATE'            ,type: 'uniDate'},
            {name: 'ORDER_RATE'          ,text:'ORDER_RATE'            ,type: 'uniER'},
            {name: 'REMARK'              ,text:'<t:message code="system.label.sales.remarks" default="비고"/>'              ,type: 'string', maxLength: 100},
            {name: 'DIV_CODE'            ,text:'<t:message code="system.label.sales.division" default="사업장"/>'            ,type: 'string'}	 
		]
	});
	
	var directProxy1 = Ext.create('Unilite.com.data.proxy.UniDirectProxy', {
	    api: {
	        read: 'sbs032ukrvService.selectMaster'
	    }
	});
	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy', {
	    api: {
	        read: 'sbs032ukrvService.selectDetail',
	        create: 'sbs032ukrvService.insertDetail',
	        update: 'sbs032ukrvService.updateDetail',
	        destroy: 'sbs032ukrvService.deleteDetail',
	        syncAll: 'sbs032ukrvService.saveAll'
	    }
	});
	
	var masterStore = Unilite.createStore('sbs032ukrvMasterStore', {
	    model: 'sbs032ukrvModelMaster',
	    uniOpt: {
	        isMaster: true, // 상위 버튼 연결
	        editable: false, // 수정 모드 사용
	        deletable: false, // 삭제 가능 여부
	        useNavi: false // prev | newxt 버튼 사용
	    },
	    proxy: directProxy1,
	    loadStoreRecords: function() {
	        var param = panelSearch.getValues();
	        console.log(param);
	        this.load({
	            params: param
	        });
	    }
	});
	
	var detailStore = Unilite.createStore('sbs032ukrvDetailStore', {
	    model: 'sbs032ukrvModelDetail',
	    uniOpt: {
	        isMaster: true, // 상위 버튼 연결
	        editable: true, // 수정 모드 사용
	        deletable: true, // 삭제 가능 여부
	        useNavi: false // prev | newxt 버튼 사용
	    },
	    proxy: directProxy2,
	    loadStoreRecords: function(param) {
	        this.load({
	            params: param
	        });
	    },
	    saveStore: function() {
	        var inValidRecs = this.getInvalidRecords();
			var paramMaster = panelSearch.getValues();	//syncAll 수정
	        if (inValidRecs.length == 0) {
	            config = {
					params: [paramMaster],
	                success: function(batch, option) {
	                	
	                	var selectedRec = masterGrid.getSelectedRecord(); 
	                	if(!Ext.isEmpty(selectedRec)){
		                	var param = selectedRec.data;
		                	param.ITEM_FLAG = Ext.getCmp('itemFlag').getChecked()[0].inputValue;
		                	detailStore.loadStoreRecords(param);
	                	}
	                }
	            };
	            this.syncAllDirect(config);
	        } else {
	            detailGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
	        }
	    }
	});
	var panelSearch = Unilite.createSearchForm('panelSearch', {
    	region:'north',
	     layout : {type : 'uniTable', columns : 3},
	    padding: '1 1 1 1',
	    border: true,
	    items: [{
            fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
            name: 'DIV_CODE',
            xtype: 'uniCombobox',
            comboType: 'BOR120',
            value: UserInfo.divCode,
            allowBlank: false
        },{
            fieldLabel: '<t:message code="system.label.sales.majorgroup" default="대분류"/>',
            name: 'ITEM_LEVEL1', 
            xtype: 'uniCombobox',  
            store: Ext.data.StoreManager.lookup('itemLeve1Store'), 
            child: 'ITEM_LEVEL2',
            colspan:2
        }, {
            fieldLabel: '<t:message code="system.label.sales.itemaccount" default="품목계정"/>',
            name:'ITEM_ACCOUNT', 
            xtype: 'uniCombobox', 
            comboType:'AU',
            comboCode:'B020'
        }, {
            fieldLabel: '<t:message code="system.label.sales.middlegroup" default="중분류"/>',
            name: 'ITEM_LEVEL2', 
            xtype: 'uniCombobox',  
            store: Ext.data.StoreManager.lookup('itemLeve2Store'), 
            child: 'ITEM_LEVEL3',
            colspan:2
        },
        Unilite.popup('DIV_PUMOK',{
			fieldLabel: '<t:message code="system.label.product.item" default="품목"/>',
			autoPopup:true,
			textFieldName: 'ITEM_NAME',
			valueFieldName: 'ITEM_CODE',
			listeners: {
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
				}
			}
        }),	
        {
            fieldLabel: '<t:message code="system.label.sales.minorgroup" default="소분류"/>',
            name: 'ITEM_LEVEL3', 
            xtype: 'uniCombobox',  
            store: Ext.data.StoreManager.lookup('itemLeve3Store')
        },{
            fieldLabel: '<t:message code="system.label.sales.pricesearch" default="단가검색"/>',
            xtype: 'uniRadiogroup',
            id:'itemFlag',
            items: [
                {boxLabel:'<t:message code="system.label.sales.currentappliedprice" default="현재적용단가"/>', name:'ITEM_FLAG', inputValue:'C', checked:true, width: 100},
                {boxLabel:'<t:message code="system.label.sales.whole" default="전체"/>', name:'ITEM_FLAG', inputValue:'A', width: 100}
            ],
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                	var selectedRec = masterGrid.getSelectedRecord(); 
                	if(!Ext.isEmpty(selectedRec)){
	                	var param = selectedRec.data;
	                	param.ITEM_FLAG = newValue.ITEM_FLAG;
	                	detailStore.loadStoreRecords(param);
                	}
                }
            }
        }]
	});
	
	var masterGrid = Unilite.createGrid('sbs032ukrvGridMaster', {
    	region:'center',
	    store: masterStore,
	    layout: 'fit',
	    selModel:'rowmodel',
	    uniOpt: {
	        expandLastColumn: false,
	        useLiveSearch: false,
	        useContextMenu: false,
	        useMultipleSorting: false,
	        useGroupSummary: false,
	        useRowNumberer: false,
	        filter: {
	            useFilter: false,
	            autoCreate: false
	        }
	    },
	    columns: [
	    	{ dataIndex: 'ITEM_CODE'	, width: 120},
	    	{ dataIndex: 'ITEM_NAME'	, width: 250},
	    	{ dataIndex: 'SPEC'		 	, width: 100},
	    	{ dataIndex: 'STOCK_UNIT'	, width: 80},
	    	{ dataIndex: 'SALE_UNIT'	, width: 80},
	    	{ dataIndex: 'BASIS_P'		, width: 100},
	    	{ dataIndex: 'DOM_FORIGN'	, width: 80},
	    	{ dataIndex: 'ITEM_ACCOUNT'	, width: 100},
	    	{ dataIndex: 'TRNS_RATE'	, width: 80},
	    	{ dataIndex: 'DIV_CODE'     , width: 100,hidden:true}
	    ],
        listeners: {
            selectionchangerecord:function(selected)    {
            	var param = selected.data;
            	param.ITEM_FLAG = Ext.getCmp('itemFlag').getChecked()[0].inputValue;
            	
        		detailStore.loadStoreRecords(param);
            }
        }
	});
	
	var detailGrid = Unilite.createGrid('sbs032ukrvGridDetail', {
    	region:'south',
	    store: detailStore,
	    layout: 'fit',
	    uniOpt: {
	        expandLastColumn: false,
	        useLiveSearch: false,
	        useContextMenu: false,
	        useMultipleSorting: false,
	        useGroupSummary: false,
	        useRowNumberer: false,
	        filter: {
	            useFilter: false,
	            autoCreate: false
	        }
	    },
	    columns: [
	    	{ dataIndex: 'TYPE'			   , width: 100,hidden:true},
	    	{ dataIndex: 'ITEM_CODE'	   , width: 100,hidden:true},
	    	{ dataIndex: 'CUSTOM_CODE'     , width: 120,
	    		editor: Unilite.popup('CUST_G', {      
	                textFieldName: 'CUSTOM_CODE',
	                DBtextFieldName: 'CUSTOM_CODE',
	 				autoPopup: true,
	                listeners: {
	                	'onSelected': {
	                        fn: function(records, type) {
	                            var grdRecord = detailGrid.uniOpt.currentRecord;
	                            grdRecord.set('CUSTOM_CODE', records[0]['CUSTOM_CODE']);
	                            grdRecord.set('CUSTOM_NAME', records[0]['CUSTOM_NAME']);
	                        },
                        	scope: this
	                    },
	                    'onClear': function(type) {
	                        var grdRecord = detailGrid.uniOpt.currentRecord;
	                        grdRecord.set('CUSTOM_CODE', '');
	                        grdRecord.set('CUSTOM_NAME', '');
	                    }
	                }
	        	})
	    	},
	    	{ dataIndex: 'CUSTOM_NAME'     , width: 250,
	    		editor: Unilite.popup('CUST_G', {      
	                textFieldName: 'CUSTOM_CODE',
	                DBtextFieldName: 'CUSTOM_CODE',
	 				autoPopup: true,
	                listeners: {
	                	'onSelected': {
	                        fn: function(records, type) {
	                            var grdRecord = detailGrid.uniOpt.currentRecord;
	                            grdRecord.set('CUSTOM_CODE', records[0]['CUSTOM_CODE']);
	                            grdRecord.set('CUSTOM_NAME', records[0]['CUSTOM_NAME']);
	                        },
                        	scope: this
	                    },
	                    'onClear': function(type) {
	                        var grdRecord = detailGrid.uniOpt.currentRecord;
	                        grdRecord.set('CUSTOM_CODE', '');
	                        grdRecord.set('CUSTOM_NAME', '');
	                    }
	                }
	        	})
	        },
	    	{ dataIndex: 'CUSTOM_ITEM_CODE', width: 120},
	    	{ dataIndex: 'CUSTOM_ITEM_NAME', width: 250},
	    	{ dataIndex: 'CUSTOM_ITEM_SPEC', width: 100},
	    	{ dataIndex: 'ORDER_UNIT'      , width: 80},
	    	{ dataIndex: 'BASIS_P'         , width: 100},
	    	{ dataIndex: 'ORDER_P'         , width: 100},
	    	{ dataIndex: 'TRNS_RATE'       , width: 80},
	    	{ dataIndex: 'AGENT_P'         , width: 100},
	    	{ dataIndex: 'APLY_START_DATE' , width: 100},
	    	{ dataIndex: 'ORDER_PRSN'      , width: 100,hidden:true},
	    	{ dataIndex: 'MAKER_NAME'      , width: 100,hidden:true},
	    	{ dataIndex: 'AGREE_DATE'      , width: 100,hidden:true},
	    	{ dataIndex: 'ORDER_RATE'      , width: 100,hidden:true},
	    	{ dataIndex: 'REMARK'          , width: 300},
	    	{ dataIndex: 'DIV_CODE'        , width: 100,hidden:true}
	    ],
        listeners: {
            beforeedit  : function( editor, e, eOpts ) {
                if(!e.record.phantom) {
                    if(UniUtils.indexOf(e.field, ['CUSTOM_ITEM_CODE','CUSTOM_ITEM_NAME', 'CUSTOM_CODE', 'CUSTOM_NAME',
                    	'TYPE', 'ITEM_CODE', 'ORDER_PRSN', 'MAKER_NAME', 'AGREE_DATE', 'ORDER_RATE', 'DIV_CODE','APLY_START_DATE'
                    ])) { 
                        return false;
                    } else {
                        return true;
                    }
                } else {
                	if(UniUtils.indexOf(e.field, ['TYPE', 'ITEM_CODE', 'ORDER_PRSN', 'MAKER_NAME', 'AGREE_DATE', 'ORDER_RATE', 'DIV_CODE'])) { 
                        return false;
                    } else {
                        return true;
                    }
                }
            }
        }           
	});
	
    Unilite.Main({
        border: false,
        borderItems: [{
            region: 'center',
            layout: 'border',
            border: false,
            id:'pageAll',
            flex: 1,
            items: [
                panelSearch, masterGrid, detailGrid
            ]
        }],
        id: 'sbs032ukrvApp',
        fnInitBinding: function() {
            
            panelSearch.setValue("DIV_CODE", UserInfo.divCode);
            
            UniAppManager.setToolbarButtons(['reset','newData'], true);
            UniAppManager.setToolbarButtons(['print','save'], false);
        },
        onResetButtonDown: function() {
            panelSearch.clearForm();
            
            masterGrid.reset();
            masterStore.clearData();
            detailGrid.reset();
            detailStore.clearData();
            
            this.fnInitInputFields();
        },
        onQueryButtonDown: function() {
			if(!panelSearch.getInvalidMessage()) return;   //필수체크
			
            masterStore.loadStoreRecords();
        },
        onNewDataButtonDown: function() {
        	
        	var selectedRecord = masterGrid.getSelectedRecord();
        	
        	if(Ext.isEmpty(selectedRecord)){
        		Unilite.messageBox('<t:message code="system.message.sales.message124" default="선택된 품목정보가 없습니다."/>');
        		return;
        	}
        	
//            panelSearch.getField('DIV_CODE').setReadOnly(true);
            
            
            var itemCode      = selectedRecord.get('ITEM_CODE');
            var type          = '2';
            var orderUnit     = selectedRecord.get('SALE_UNIT');
            var trnsRate      = selectedRecord.get('TRNS_RATE');
            var aplyStartDate = UniDate.get('today');
            var orderPrsn     = '*';
            var makerName     = '*';
            var agreeDate     = UniDate.get('today');
            var orderRate     = 100;
            var divCode       = selectedRecord.get('DIV_CODE');
            var compCode      = UserInfo.compCode;
            var basisP        = 0;
            var agentP        = 0;
            
            var r = {
                ITEM_CODE       : itemCode,      
                TYPE            : type,            
                ORDER_UNIT      : orderUnit,      
                TRNS_RATE       : trnsRate,       
                APLY_START_DATE : aplyStartDate, 
                ORDER_PRSN      : orderPrsn,      
                MAKER_NAME      : makerName,      
                AGREE_DATE      : agreeDate,      
                ORDER_RATE      : orderRate,      
                DIV_CODE        : divCode,        
                COMP_CODE       : compCode,       
                BASIS_P         : basisP,         
                AGENT_P         : agentP    
            }
            detailGrid.createRow(r);
        },
        
        
        onSaveDataButtonDown: function() {
			detailStore.saveStore();
        },
        onDeleteDataButtonDown: function() {
            var selRow = detailGrid.getSelectedRecord();
            if(!Ext.isEmpty(selRow)){
                if(selRow.phantom === true) {
                    detailGrid.deleteSelectedRow();
                }else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')){
                    detailGrid.deleteSelectedRow();   
                }
            }
        },
		fnInitInputFields: function(){
            panelSearch.setValue("DIV_CODE", UserInfo.divCode);
          
            UniAppManager.setToolbarButtons(['reset','newData'], true);
            UniAppManager.setToolbarButtons(['print','save'], false);
            
		}

    });
};
</script>